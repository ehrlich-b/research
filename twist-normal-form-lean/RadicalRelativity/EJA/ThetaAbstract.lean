/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.ConeTopology
import RadicalRelativity.EJA.OrderAuto

set_option linter.style.longLine false

/-!
# `prop:theta` at abstract EJA generality: the twist automorphism

STATEMENT-MANIFEST row 14.  `main.tex:763-773` asserts that for every invertible effect `a` there
is a **Jordan automorphism** `Θ_a` with `a · b = Q_{√a} Θ_a(b)` for all `b` — equivalently
`L_a = Q_{√a} Θ_a`, where `L_a` is left multiplication by `a` in the *unknown* product — that
`Θ_a` fixes everything operator-commuting with `a`, and that `Θ` is multiplicative on
operator-commuting invertibles.

The row was carried on the two concrete carriers from in-tree Kadison rigidity; what this file
builds is the abstract derivation, which became available once two things landed:

* `EJA/OrderAuto.lean`'s `map_jordan_of_orderIso` — a unital linear **order** isomorphism of a
  finite-dimensional formally real Jordan algebra is a Jordan homomorphism (the Koecher /
  Alfsen–Shultz input the row's cell recorded as its open item, then found already proved);
* row 13's order-reflection for the unknown product, `seqLeftMulAbs_reflectsNonneg`, together
  with `quadJ_jsqrt_jinv_cancel`, which is what makes `Θ_a := Q_{√a}⁻¹ ∘ L_a` an order
  isomorphism rather than merely a linear one.

★ Statements here are **resolution-relative**, exactly as row 13's are: an invertible effect is
presented with a complete orthogonal resolution whose eigenvalues do not vanish at the
idempotents that are present.  `spectral_resolution_complete` supplies one.
-/

noncomputable section

namespace RadicalRelativity.EJA

open Finset

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]
  [EuclideanJordanAlgebra J] [FiniteDimensional ℝ J]

/-! ## The two cone vocabularies agree

`jmulₗ J` is the class's bundled Jordan product and `mulLₗ` is the one `EJA/OrderAuto.lean`
runs on.  They apply to the same product, so their cones coincide; without saying so,
`map_jordan_of_orderIso` cannot be fed a hypothesis stated in the class's vocabulary. -/

theorem isSoS_jmulₗ_iff_mulLₗ (z : J) : IsSoS (jmulₗ J) z ↔ IsSoS mulLₗ z := by
  constructor
  · rintro ⟨k, f, hf⟩; exact ⟨k, f, by simpa [mulLₗ_apply, mulL_apply] using hf⟩
  · rintro ⟨k, f, hf⟩; exact ⟨k, f, by simpa [mulLₗ_apply, mulL_apply] using hf⟩

/-! ## `Q_{√a}` as a linear equivalence

At an invertible cone element the quadratic representation of the square root is invertible, with
`Q_{√(a⁻¹)}` as its two-sided inverse — that is `quadJ_jsqrt_jinv_cancel`, proved for row 13. -/

/-- **`Q_{√b}` as a linear equivalence**, at an invertible element of the cone. -/
def quadJSqrtEquiv {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) : J ≃ₗ[ℝ] J :=
  { quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) with
    invFun := quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam))
    left_inv := fun y => (quadJ_jsqrt_jinv_cancel hfam hsum hb hbsos hne y).2
    right_inv := fun y => (quadJ_jsqrt_jinv_cancel hfam hsum hb hbsos hne y).1 }

@[simp]
theorem quadJSqrtEquiv_apply {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) (y : J) :
    quadJSqrtEquiv hfam hsum hb hbsos hne y
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y := rfl

@[simp]
theorem quadJSqrtEquiv_symm_apply {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) (y : J) :
    (quadJSqrtEquiv hfam hsum hb hbsos hne).symm y
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) y := rfl

/-- `Q_{√b}` sends the unit to `b`, so its inverse sends `b` to the unit. -/
theorem quadJSqrtEquiv_symm_self {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    (quadJSqrtEquiv hfam hsum hb hbsos hne).symm b = 1 := by
  rw [LinearEquiv.symm_apply_eq, quadJSqrtEquiv_apply,
    quadJ_unit EuclideanJordanAlgebra.one_mul, jsqrt_sq_of_isSoS hbsos]


/-! ## The twist automorphism `Θ_a`

★★★ `Θ_a := Q_{√a}⁻¹ ∘ L_a`, with `L_a` the unknown product's left multiplication.  It is a
linear equivalence because `L_a` is injective (row 13's `sp_orderReflection`) hence bijective in
finite dimension, and `Q_{√a}` is invertible at an invertible element; it is **unital** because
`L_a 𝟙 = a = Q_{√a} 1`; it is an **order** isomorphism because `L_a` both preserves and reflects
the cone and `Q_{√a}`, `Q_{√a⁻¹}` preserve it; and a unital linear order isomorphism of a
finite-dimensional formally real Jordan algebra is a Jordan automorphism. -/

/-- ★★★ **`prop:theta`, existence clause, at abstract EJA generality.**

For an invertible effect `b` — presented, as throughout row 13, with a complete resolution whose
eigenvalues do not vanish at the idempotents present — and any S1–S7+S2 product, there is a
**Jordan automorphism** `Θ` of `J` with `L_b = Q_{√b} ∘ Θ`, i.e. `b · y = Q_{√b}(Θ y)`. -/
theorem exists_theta {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ P : SequentialProductOn J, P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J) (hbe : OrderUnitSpace.IsEffect b),
        ∃ Θ : J ≃ₗ[ℝ] J,
          Θ 1 = 1 ∧ (∀ x y : J, Θ (x * y) = Θ x * Θ y) ∧
            ∀ y : J, P.seqLeftMulAbs harch hbe y
              = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θ y) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe
  obtain ⟨hrefl, hinj⟩ := sp_orderReflection hfam hsum hb hbsos hcsos hne P hS2 harch hbe
  set E := quadJSqrtEquiv hfam hsum hb hbsos hne with hEdef
  set Lb := P.seqLeftMulAbs harch hbe with hLdef
  have hbij : Function.Bijective Lb :=
    ⟨hinj, (LinearMap.injective_iff_surjective (f := Lb)).mp hinj⟩
  set Θ : J ≃ₗ[ℝ] J := (LinearEquiv.ofBijective Lb hbij).trans E.symm with hΘdef
  have hEΘ : ∀ y : J, E (Θ y) = Lb y := fun y => by
    rw [hΘdef]; simp [LinearEquiv.trans_apply]
  -- unital
  have hL1 : Lb 1 = b := P.seqLeftMulAbs_one harch hbe
  have hunit : Θ 1 = 1 := by
    have : E (Θ 1) = E 1 := by
      rw [hEΘ, hL1, hEdef, quadJSqrtEquiv_apply,
        quadJ_unit EuclideanJordanAlgebra.one_mul, jsqrt_sq_of_isSoS hbsos]
    exact E.injective this
  -- order isomorphism
  have hle : ∀ z : J, (0 : J) ≤ z ↔ IsSoS (jmulₗ J) z := by
    intro z
    rw [le_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul 0 z, sub_zero]
  have hΘval : ∀ z : J,
      Θ z = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) (Lb z) := by
    intro z; rw [hΘdef]; simp [LinearEquiv.trans_apply, hEdef]
  have horder : ∀ z : J, IsSoS (jmulₗ J) z ↔ IsSoS (jmulₗ J) (Θ z) := by
    intro z
    constructor
    · intro hz
      have h2 : IsSoS (jmulₗ J) (Lb z) :=
        (hle _).mp (P.seqLeftMulAbs_nonneg harch hbe ((hle z).mpr hz))
      rw [hΘval z]
      exact quadJ_isSoS _ h2
    · intro hz
      have hLz : IsSoS (jmulₗ J) (Lb z) := by
        rw [← hEΘ z, hEdef, quadJSqrtEquiv_apply]
        exact quadJ_isSoS _ hz
      exact (hle z).mp (hrefl z ((hle _).mpr hLz))
  refine ⟨Θ, hunit, fun x y => ?_, fun y => (hEΘ y).symm ▸ rfl⟩
  refine map_jordan_of_orderIso EuclideanJordanAlgebra.one_mul Θ hunit ?_ x y
  intro z
  rw [← isSoS_jmulₗ_iff_mulLₗ, ← isSoS_jmulₗ_iff_mulLₗ]
  exact horder z

end RadicalRelativity.EJA
