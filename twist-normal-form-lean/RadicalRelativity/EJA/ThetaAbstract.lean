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


/-! ## vdW Proposition 5.5: the commutant is fixed

★★★ This is the "fixing property" (`main.tex:791`, and the row-14 clause "Θ_a fixes every `b`
that operator-commutes with `a`"); it is also **the whole remaining residue of manifest row 16**,
whose cell isolates it as "the effect-level Prop 5.5 itself".

The mechanism: for operator-commuting effects `b` and `y` the *unknown* product already takes the
standard value `b · y = Q_{√b} y` — that is `OrthFamily.sp_orthFamily_value` (vdW 5.2) on a
simultaneous resolution, matched against `luders_of_resolution` on the same one — so
`Q_{√b}(Θ y) = Q_{√b} y`, and `Q_{√b}` is injective at an invertible `b`. -/

/-- A complete orthogonal idempotent family is an orthogonal family of effects in the order-unit
sense: every subfamily sums below the unit, because the complement sums into the cone. -/
theorem isOrthogonalFamily_of_orthIdem {N : ℕ} {q : Fin N → J} (hfam : IsOrthIdemFamily q)
    (hsum : (∑ i, q i) = 1) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    OrderUnitSpace.IsOrthogonalFamily q := by
  classical
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  have hsub : ∀ s : Finset (Fin N), (∑ i ∈ s, q i) ≤ (1 : J) := by
    intro s
    have hsplit : (1 : J) - ∑ i ∈ s, q i = ∑ i ∈ sᶜ, q i := by
      rw [← hsum, ← Finset.sum_add_sum_compl s q]; abel
    have hcone : IsSoS (jmulₗ J) (∑ i ∈ sᶜ, q i) :=
      isSoS_sum _ _ fun i _ => isSoS_of_idem (hfam.idem i)
    rw [le_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul, hsplit]
    exact hcone
  refine ⟨fun i => ?_, hsub⟩
  refine (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul (q i)).mpr ⟨isSoS_of_idem (hfam.idem i), ?_⟩
  have h := hsub {i}
  rw [Finset.sum_singleton, le_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan
    jmulₗ_formallyReal (1 : J) jmulₗ_one_mul] at h
  exact h

/-- ★★★ **vdW Proposition 5.2 in the form the fixing property needs**: on an operator-commuting
pair of effects, *every* S1–S7+S2 product already takes the standard Lüders value. -/
theorem sp_eq_quadJ_of_opCommute {b y : J}
    (hbsos : IsSoS (jmulₗ J) b) (hbc : IsSoS (jmulₗ J) ((1 : J) - b))
    (hysos : IsSoS (jmulₗ J) y) (hyc : IsSoS (jmulₗ J) ((1 : J) - y))
    (hcomm : ∀ w, b * (y * w) = y * (b * w)) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ P : SequentialProductOn J, P.FirstArgContinuous →
      P.sp b y = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y := by
  classical
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2
  have harch : OrderUnitSpace.IsArchimedean J :=
    isArchimedean_ofBilinear jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal jmulₗ_inner_assoc
      (1 : J) jmulₗ_one_mul
  obtain ⟨N, q, la, mu, hfam, hsum, hbe, hye⟩ :=
    exists_simultaneous_resolution 1 EuclideanJordanAlgebra.one_mul hcomm
  -- trim the coefficients so the range conditions hold at every index
  set la' : Fin N → ℝ := fun k => if q k = 0 then 0 else la k with hla'def
  set mu' : Fin N → ℝ := fun k => if q k = 0 then 0 else mu k with hmu'def
  have htrim : ∀ (f : Fin N → ℝ) (x : J), x = ∑ k, f k • q k →
      x = ∑ k, (if q k = 0 then 0 else f k) • q k := by
    intro f x hx
    rw [hx]
    refine Finset.sum_congr rfl fun k _ => ?_
    by_cases h : q k = 0
    · rw [h, smul_zero, smul_zero]
    · rw [if_neg h]
  have hbe' : b = ∑ k, la' k • q k := htrim la b hbe
  have hye' : y = ∑ k, mu' k • q k := htrim mu y hye
  have hrange : ∀ (f : Fin N → ℝ) (x : J), x = ∑ k, f k • q k → IsSoS (jmulₗ J) x →
      IsSoS (jmulₗ J) ((1 : J) - x) →
      ∀ k, 0 ≤ (if q k = 0 then 0 else f k) ∧ (if q k = 0 then 0 else f k) ≤ 1 := by
    intro f x hx hxs hxc k
    by_cases h : q k = 0
    · simp [h]
    · rw [if_neg h]
      constructor
      · exact nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
          (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hx hxs h
      · have hx1 : (1 : J) - x = ∑ i, (1 - f i) • q i := by
          have hh := smul_unit_sub_eq hsum hx 1
          rwa [one_smul] at hh
        have := nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
          (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hx1 hxc h
        linarith
  have hla := hrange la b hbe hbsos hbc
  have hmu := hrange mu y hye hysos hyc
  have hsharp : ∀ k, OrderUnitSpace.IsSharp (q k) := fun k =>
    isSharpOrderUnit_of_idem (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      jmulₗ_inner_assoc (1 : J) jmulₗ_one_mul (hfam.idem k)
  -- the unknown product takes the diagonal value
  have hval := P.sp_orthFamily_value_fin harch hS2 (isOrthogonalFamily_of_orthIdem hfam hsum)
    hsharp (fun k => (hla k).1) (fun k => (hla k).2)
    (fun k => (hmu k).1) (fun k => (hmu k).2)
  -- so does the standard one
  have hsq : jsqrt 1 EuclideanJordanAlgebra.one_mul b = jsqrtOfResolution q la' :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hbe'
  have hstd : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y = ∑ k, (la' k * mu' k) • q k := by
    rw [hsq]
    conv_lhs => rw [hye']
    exact luders_of_resolution hfam (fun k => (hla k).1) mu'
  rw [hstd]
  conv_lhs => rw [hbe', hye']
  exact hval


/-- ★★★ **vdW Proposition 5.5 / `prop:theta`'s fixing clause, at abstract EJA generality.**

`Θ_b` fixes every effect that operator-commutes with `b`.  ★ This is simultaneously the whole
remaining residue of manifest **row 16** (`lem:coalescence`), whose cell isolates "the effect-level
Prop 5.5 itself" as what is left of `Θ_fix`. -/
theorem theta_fixes_of_opCommute {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J) (hbe : OrderUnitSpace.IsEffect b)
        (Θ : J ≃ₗ[ℝ] J),
        (∀ z : J, P.seqLeftMulAbs harch hbe z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θ z)) →
        ∀ {y : J}, IsSoS (jmulₗ J) y → IsSoS (jmulₗ J) ((1 : J) - y) →
          (∀ w, b * (y * w) = y * (b * w)) → Θ y = y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe Θ hΘ y hysos hyc hcomm
  have hye : OrderUnitSpace.IsEffect y :=
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul y).mpr ⟨hysos, hyc⟩
  have h1 : P.seqLeftMulAbs harch hbe y = P.sp b y :=
    P.seqLeftMulAbs_apply_effect harch hbe hye
  have h2 : P.sp b y = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y :=
    sp_eq_quadJ_of_opCommute hbsos hcsos hysos hyc hcomm P hS2
  have h3 : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θ y)
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y := by
    rw [← hΘ y, h1, h2]
  exact (quadJSqrtEquiv hfam hsum hb hbsos hne).injective h3

/-- ★★★ **`lem:coalescence` (manifest row 16), general clause.**

If an invertible effect `a` is scalar on the Peirce 2-space of an idempotent `q` and has no
Peirce 1-part — `a = μ • q + a₀` with `q ∘ a₀ = 0` — then `Θ_a` is the identity on `J₂(q)`.

The hypothesis is exactly `opCommute_scalarOn`'s (the cited Faraut–Korányi shape, already in the
tree at single-idempotent generality), which makes `a` operator-commute with every element of
`J₂(q)`; the fixing property then does the rest. -/
theorem theta_id_on_peirceTwo {a : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (ha : a = ∑ i, lam i • c i)
    (hasos : IsSoS (jmulₗ J) a) (hacs : IsSoS (jmulₗ J) ((1 : J) - a))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0)
    {q a₀ : J} {μ : ℝ} (hq : q * q = q) (hdec : a = μ • q + a₀) (ha₀ : q * a₀ = 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J) (hae : OrderUnitSpace.IsEffect a)
        (Θ : J ≃ₗ[ℝ] J),
        (∀ z : J, P.seqLeftMulAbs harch hae z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) (Θ z)) →
        ∀ {y : J}, IsSoS (jmulₗ J) y → IsSoS (jmulₗ J) ((1 : J) - y) → q * y = y → Θ y = y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae Θ hΘ y hysos hyc hy2
  exact theta_fixes_of_opCommute hfam hsum ha hasos hacs hne P hS2 harch hae Θ hΘ hysos hyc
    (opCommute_scalarOn hq hdec ha₀ hy2)

end RadicalRelativity.EJA
