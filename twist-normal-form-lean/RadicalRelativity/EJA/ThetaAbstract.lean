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


/-! ### From the effects of a Peirce block to the whole block

★★★ `theta_fixes_of_opCommute` is stated on **effects**, and the elements of an off-diagonal
Peirce block `V_{ij}` are not effects.  `Θ` is linear, so it is enough that every element of
`J₂(q)` is a real combination of effects *lying in `J₂(q)`* — and it is, for a reason that needs
no subalgebra theory: `Q_q` fixes `J₂(q)` pointwise, sends `1` to `q`, and preserves the cone, so
it pushes an ambient Archimedean bound `−x ≤ t•1` into the block as `x + t•q ≥ 0`. -/

/-- `Q_q` fixes the Peirce 2-space of `q` pointwise. -/
theorem quadJ_idem_self {q x : J} (hq : q * q = q) (hx : q * x = x) : quadJ q x = x := by
  rw [quadJ_apply, hx, hx, hq, hx]
  module

/-- ★★★ **Every element of `J₂(q)` is a real combination of two effects lying in `J₂(q)`.** -/
theorem exists_effect_decomp_peirceTwo {q x : J} (hq : q * q = q) (hx : q * x = x) :
    ∃ (s t : ℝ) (e : J), 0 < s ∧ 0 ≤ t ∧ IsSoS (jmulₗ J) e ∧
      IsSoS (jmulₗ J) ((1 : J) - e) ∧ q * e = e ∧ x = s • e - t • q := by
  obtain ⟨t, ht0, ht⟩ := exists_isSoS_smul_unit_sub (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan
    jmulₗ_formallyReal (1 : J) jmulₗ_one_mul (-x)
  -- `t•1 + x` is in the cone; push it into the block with `Q_q`
  have hpos : IsSoS (jmulₗ J) (t • (1 : J) + x) := by
    have : t • (1 : J) - -x = t • (1 : J) + x := by abel
    rwa [this] at ht
  have hQ : quadJ q (t • (1 : J) + x) = t • q + x := by
    rw [map_add, map_smul, quadJ_unit EuclideanJordanAlgebra.one_mul, hq,
      quadJ_idem_self hq hx]
  have hblk : IsSoS (jmulₗ J) (t • q + x) := by rw [← hQ]; exact quadJ_isSoS q hpos
  obtain ⟨s0, hs00, hs0⟩ := exists_isSoS_smul_unit_sub (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan
    jmulₗ_formallyReal (1 : J) jmulₗ_one_mul (t • q + x)
  refine ⟨s0 + 1, t, (s0 + 1)⁻¹ • (t • q + x), by linarith, ht0, ?_, ?_, ?_, ?_⟩
  · exact IsSoS.smul (by positivity) hblk
  · have hs : (0 : ℝ) < s0 + 1 := by linarith
    have hrw : (1 : J) - (s0 + 1)⁻¹ • (t • q + x)
        = (s0 + 1)⁻¹ • ((s0 + 1) • (1 : J) - (t • q + x)) := by
      rw [smul_sub, smul_smul, inv_mul_cancel₀ hs.ne', one_smul]
    have hbig : (s0 + 1) • (1 : J) - (t • q + x)
        = (s0 • (1 : J) - (t • q + x)) + (1 : ℝ) • (1 : J) := by
      rw [add_smul]; abel
    rw [hrw, hbig]
    exact IsSoS.smul (le_of_lt (inv_pos.mpr hs))
      (IsSoS.add hs0 (IsSoS.smul zero_le_one (isSoS_of_idem (EuclideanJordanAlgebra.one_mul 1))))
  · rw [mul_smul_comm, mul_add, mul_smul_comm, hq, hx]
  · rw [smul_smul, mul_inv_cancel₀ (by linarith : s0 + 1 ≠ 0), one_smul]
    abel


omit [FiniteDimensional ℝ J] in
theorem isSoS_one_sub_idem {q : J} (hq : q * q = q) : IsSoS (jmulₗ J) ((1 : J) - q) := by
  refine isSoS_of_idem ?_
  show ((1 : J) - q) * ((1 : J) - q) = (1 : J) - q
  rw [sub_mul, mul_sub, mul_sub, EuclideanJordanAlgebra.one_mul,
    EuclideanJordanAlgebra.one_mul, hq, mul_comm q (1 : J), EuclideanJordanAlgebra.one_mul]
  abel

/-- ★★★ **`lem:coalescence`, general clause, on the whole Peirce 2-space.**

`Θ_a` is the identity on **all** of `J₂(q)`, not only on its effects: every element of the block
is a real combination of two effects lying in the block, and `Θ` is linear. -/
theorem theta_id_on_peirceTwo_all {a : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
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
        ∀ {y : J}, q * y = y → Θ y = y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae Θ hΘ y hy
  obtain ⟨s, t, e, hs, ht, hes, hec, hqe, hxe⟩ := exists_effect_decomp_peirceTwo hq hy
  have hΘe : Θ e = e :=
    theta_id_on_peirceTwo hfam hsum ha hasos hacs hne hq hdec ha₀ P hS2 harch hae Θ hΘ hes hec hqe
  have hΘq : Θ q = q :=
    theta_id_on_peirceTwo hfam hsum ha hasos hacs hne hq hdec ha₀ P hS2 harch hae Θ hΘ
      (isSoS_of_idem hq) (isSoS_one_sub_idem hq) hq
  rw [hxe, map_sub, map_smul, map_smul, hΘe, hΘq]


/-! ### `lem:coalescence`, first clause: coalescing twist parameters -/

/-- ★★★ **`lem:coalescence`, first clause.**  If the parameters agree at `i` and `j` — `f i = f j`
— then `Θ` for `a = ∑ f k • pₖ` fixes the Peirce block `V_{ij}` pointwise.

This is the general clause specialized to `q = pᵢ + pⱼ`: coalescing the two parameters is exactly
what makes `a` scalar on `J₂(q)` with no Peirce 1-part, and `V_{ij} ⊆ J₂(q)` because an element
halved by both `pᵢ` and `pⱼ` is fixed by their sum. -/
theorem theta_id_on_frameBlock {N : ℕ} (F : JordanFrame J N) {f : Fin N → ℝ}
    (hf0 : ∀ k, 0 < f k) (hf1 : ∀ k, f k ≤ 1) {i j : Fin N} (hij : i ≠ j) (hfij : f i = f j) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J)
        (hae : OrderUnitSpace.IsEffect (∑ k, f k • F.p k)) (Θ : J ≃ₗ[ℝ] J),
        (∀ z : J, P.seqLeftMulAbs harch hae z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (∑ k, f k • F.p k)) (Θ z)) →
        ∀ {y : J}, y ∈ frameBlockRaw F i j → Θ y = y := by
  classical
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae Θ hΘ y hy
  set a : J := ∑ k, f k • F.p k with hadef
  set q : J := F.p i + F.p j with hqdef
  have hq : q * q = q :=
    add_idem_of_orthogonal (F.orthIdem.idem i) (F.orthIdem.idem j) (F.orthIdem.orth i j hij)
  -- `a` is scalar on `J₂(q)` with the rest in `J₀(q)`
  set rest : Finset (Fin N) := (Finset.univ.erase i).erase j with hrestdef
  set a₀ : J := ∑ k ∈ rest, f k • F.p k with ha₀def
  have hji : j ∈ Finset.univ.erase i := Finset.mem_erase.mpr ⟨Ne.symm hij, Finset.mem_univ j⟩
  have hdec : a = f i • q + a₀ := by
    rw [hadef, ← Finset.add_sum_erase _ _ (Finset.mem_univ i),
      ← Finset.add_sum_erase _ _ hji, hqdef, smul_add, hfij, ha₀def, hrestdef]
    abel
  have ha₀ : q * a₀ = 0 := by
    rw [ha₀def, Finset.mul_sum]
    refine Finset.sum_eq_zero fun k hk => ?_
    have hki : k ≠ i := (Finset.mem_erase.mp (Finset.mem_erase.mp hk).2).1
    have hkj : k ≠ j := (Finset.mem_erase.mp hk).1
    rw [mul_smul_comm, hqdef, add_mul, mul_comm (F.p i) (F.p k), mul_comm (F.p j) (F.p k),
      F.orthIdem.orth k i hki, F.orthIdem.orth k j hkj, add_zero, smul_zero]
  -- `V_{ij} ⊆ J₂(q)`
  have hy2 : q * y = y := by
    obtain ⟨h1, h2⟩ := (mem_frameBlockRaw_off hij).mp hy
    rw [hqdef, add_mul, h1, h2]
    module
  -- cone data for `a`
  have hasos : IsSoS (jmulₗ J) a := by
    rw [hadef]
    exact isSoS_sum _ _ fun k _ => isSoS_smul_idem (hf0 k).le (F.orthIdem.idem k)
  have hacs : IsSoS (jmulₗ J) ((1 : J) - a) := by
    have hrw : (1 : J) - a = ∑ k, (1 - f k) • F.p k := by
      have hh := smul_unit_sub_eq F.complete hadef 1
      rwa [one_smul] at hh
    rw [hrw]
    exact isSoS_sum _ _ fun k _ =>
      isSoS_smul_idem (by linarith [hf1 k]) (F.orthIdem.idem k)
  exact theta_id_on_peirceTwo_all F.orthIdem F.complete hadef hasos hacs
    (fun k _ => (hf0 k).ne') hq hdec ha₀ P hS2 harch hae Θ hΘ hy2


/-! ## `prop:theta`, multiplicativity

★★★ `Θ_{b•b'} = Θ_b Θ_{b'} = Θ_{b'} Θ_b` for operator-commuting invertible effects.  The proof
cancels `Q` on both sides of the defining identity, so it needs two structural facts:
`Q_{√(b•b')} = Q_{√b} Q_{√b'}` (the square root of the product is the product of the square roots
on a shared resolution, and `quadJ_mul_of_opCommute` turns that into composition), and that a
Jordan automorphism intertwines `Q`. -/

omit [FiniteDimensional ℝ J] in
/-- A Jordan homomorphism intertwines the quadratic representation. -/
theorem map_quadJ_of_jordanHom {Θ : J ≃ₗ[ℝ] J} (hmul : ∀ x y : J, Θ (x * y) = Θ x * Θ y)
    (v x : J) : Θ (quadJ v x) = quadJ (Θ v) (Θ x) := by
  rw [quadJ_apply, quadJ_apply, map_sub, map_smul, hmul, hmul, hmul, hmul]

/-- On a shared resolution, the square root of the Lüders product is the product of the square
roots. -/
theorem jsqrt_luders_eq {N : ℕ} {q : Fin N → J} {la mu : Fin N → ℝ}
    (hfam : IsOrthIdemFamily q) (hla0 : ∀ k, 0 ≤ la k) (hmu0 : ∀ k, 0 ≤ mu k)
    {b b' : J} (hb : b = ∑ k, la k • q k) (hb' : b' = ∑ k, mu k • q k) :
    jsqrt 1 EuclideanJordanAlgebra.one_mul
        (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) b')
      = jsqrt 1 EuclideanJordanAlgebra.one_mul b * jsqrt 1 EuclideanJordanAlgebra.one_mul b' := by
  have hsb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ k, Real.sqrt (la k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hb
  have hsb' : jsqrt 1 EuclideanJordanAlgebra.one_mul b' = ∑ k, Real.sqrt (mu k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b' hfam hb'
  have hprod : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) b'
      = ∑ k, (la k * mu k) • q k := by
    rw [hsb]
    conv_lhs => rw [hb']
    exact luders_of_resolution hfam hla0 mu
  rw [jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul _ hfam hprod, hsb, hsb',
    sum_smul_mul_sum_smul_of_orthIdem hfam]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Real.sqrt_mul (hla0 k)]

/-- `Q_{√(b•b')} = Q_{√b} ∘ Q_{√b'}` on a shared resolution. -/
theorem quadJ_jsqrt_luders_comp {N : ℕ} {q : Fin N → J} {la mu : Fin N → ℝ}
    (hfam : IsOrthIdemFamily q) (hsum : (∑ k, q k) = 1)
    (hla0 : ∀ k, 0 ≤ la k) (hmu0 : ∀ k, 0 ≤ mu k)
    {b b' : J} (hb : b = ∑ k, la k • q k) (hb' : b' = ∑ k, mu k • q k) (z : J) :
    quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul
        (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) b')) z
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b)
          (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') z) := by
  have hsb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ k, Real.sqrt (la k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hb
  have hsb' : jsqrt 1 EuclideanJordanAlgebra.one_mul b' = ∑ k, Real.sqrt (mu k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b' hfam hb'
  rw [jsqrt_luders_eq hfam hla0 hmu0 hb hb']
  exact quadJ_mul_of_opCommute EuclideanJordanAlgebra.one_mul
    (opCommute_of_shared_resolution' hfam hsb hsb') z


/-- ★★★ **`prop:theta`, multiplicativity clause, at abstract EJA generality.**

For operator-commuting invertible effects `b`, `b'` presented on a shared resolution,
`Θ_{b•b'} = Θ_b Θ_{b'} = Θ_{b'} Θ_b`.

★ Stated without a global choice of `Θ`, because the defining identity `L_b = Q_{√b} ∘ Θ_b`
determines `Θ_b` uniquely; the hypotheses are just that each of the three maps satisfies its own
identity.  The proof cancels `Q_{√(b•b')} = Q_{√b} Q_{√b'}` after moving `Θ_b` past `Q_{√b'}`,
which is legal because `Θ_b` is a Jordan automorphism fixing `√b'`. -/
theorem theta_mul {N : ℕ} {q : Fin N → J} {la mu : Fin N → ℝ}
    (hfam : IsOrthIdemFamily q) (hsum : (∑ k, q k) = 1)
    (hla0 : ∀ k, 0 ≤ la k) (hla1 : ∀ k, la k ≤ 1)
    (hmu0 : ∀ k, 0 ≤ mu k) (hmu1 : ∀ k, mu k ≤ 1)
    (hlane : ∀ k, q k ≠ 0 → la k ≠ 0) (hmune : ∀ k, q k ≠ 0 → mu k ≠ 0)
    {b b' : J} (hb : b = ∑ k, la k • q k) (hb' : b' = ∑ k, mu k • q k) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J)
        (hbe : OrderUnitSpace.IsEffect b) (hb'e : OrderUnitSpace.IsEffect b')
        (hbb'e : OrderUnitSpace.IsEffect (P.sp b b'))
        (Θb Θb' Θbb' : J ≃ₗ[ℝ] J),
        (∀ x y : J, Θb (x * y) = Θb x * Θb y) →
        (∀ z : J, P.seqLeftMulAbs harch hbe z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θb z)) →
        (∀ z : J, P.seqLeftMulAbs harch hb'e z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb' z)) →
        (∀ z : J, P.seqLeftMulAbs harch hbb'e z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (P.sp b b')) (Θbb' z)) →
        ∀ y : J, Θbb' y = Θb (Θb' y) := by
  classical
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe hb'e hbb'e Θb Θb' Θbb' hΘbmul hΘb hΘb' hΘbb' y
  -- cone data
  have hbsos : IsSoS (jmulₗ J) b :=
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul b).mp hbe |>.1
  have hbcs : IsSoS (jmulₗ J) ((1 : J) - b) :=
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul b).mp hbe |>.2
  have hb'sos : IsSoS (jmulₗ J) b' :=
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul b').mp hb'e |>.1
  have hb'cs : IsSoS (jmulₗ J) ((1 : J) - b') :=
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul b').mp hb'e |>.2
  have hsb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ k, Real.sqrt (la k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hb
  have hsb' : jsqrt 1 EuclideanJordanAlgebra.one_mul b' = ∑ k, Real.sqrt (mu k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b' hfam hb'
  have hcomm : ∀ w, b * (b' * w) = b' * (b * w) :=
    opCommute_of_shared_resolution' hfam hb hb'
  -- `b • b'` is the Lüders product and has the diagonal resolution
  have hsp : P.sp b b' = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) b' :=
    sp_eq_quadJ_of_opCommute hbsos hbcs hb'sos hb'cs hcomm P hS2
  have hspres : P.sp b b' = ∑ k, (la k * mu k) • q k := by
    rw [hsp, hsb]
    conv_lhs => rw [hb']
    exact luders_of_resolution hfam hla0 mu
  have hspne : ∀ k, q k ≠ 0 → la k * mu k ≠ 0 := fun k hk =>
    mul_ne_zero (hlane k hk) (hmune k hk)
  have hspsos : IsSoS (jmulₗ J) (P.sp b b') :=
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul _).mp hbb'e |>.1
  -- `Θb` fixes `√b'`
  have hsb'sos : IsSoS (jmulₗ J) (jsqrt 1 EuclideanJordanAlgebra.one_mul b') := by
    rw [hsb']
    exact isSoS_sum _ _ fun k _ => isSoS_smul_idem (Real.sqrt_nonneg _) (hfam.idem k)
  have hsb'cs : IsSoS (jmulₗ J) ((1 : J) - jsqrt 1 EuclideanJordanAlgebra.one_mul b') := by
    have hrw : (1 : J) - jsqrt 1 EuclideanJordanAlgebra.one_mul b'
        = ∑ k, (1 - Real.sqrt (mu k)) • q k := by
      have hh := smul_unit_sub_eq hsum hsb' 1
      rwa [one_smul] at hh
    rw [hrw]
    refine isSoS_sum _ _ fun k _ => isSoS_smul_idem ?_ (hfam.idem k)
    have : Real.sqrt (mu k) ≤ 1 := by
      rw [show (1 : ℝ) = Real.sqrt 1 by simp]; exact Real.sqrt_le_sqrt (hmu1 k)
    linarith
  have hfix : Θb (jsqrt 1 EuclideanJordanAlgebra.one_mul b') =
      jsqrt 1 EuclideanJordanAlgebra.one_mul b' :=
    theta_fixes_of_opCommute hfam hsum hb hbsos hbcs hlane P hS2 harch hbe Θb hΘb
      hsb'sos hsb'cs (opCommute_of_shared_resolution' hfam hb hsb')
  -- the two sides agree after applying `Q_{√(b•b')}`
  have hkey : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (P.sp b b')) (Θbb' y)
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (P.sp b b')) (Θb (Θb' y)) := by
    rw [← hΘbb' y]
    have hcompose : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (P.sp b b')) (Θb (Θb' y))
        = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b)
            (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb (Θb' y))) := by
      rw [hsp]
      exact quadJ_jsqrt_luders_comp hfam hsum hla0 hmu0 hb hb' _
    rw [hcompose]
    have hmove : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb (Θb' y))
        = Θb (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb' y)) := by
      rw [map_quadJ_of_jordanHom hΘbmul, hfix]
    rw [hmove, ← hΘb' y, ← hΘb (P.seqLeftMulAbs harch hb'e y)]
    -- S5: `L_{b•b'} = L_b ∘ L_{b'}`
    have hcompat : P.sp b b' = P.sp b' b := by
      rw [hsp, sp_eq_quadJ_of_opCommute hb'sos hb'cs hbsos hbcs (fun w => (hcomm w).symm) P hS2]
      exact luders_comm_of_opCommute hbsos hb'sos hcomm
    have hS5 : ∀ z : J, OrderUnitSpace.IsEffect z →
        P.seqLeftMulAbs harch hbb'e z = P.seqLeftMulAbs harch hbe (P.seqLeftMulAbs harch hb'e z) := by
      intro z hz
      rw [P.seqLeftMulAbs_apply_effect harch hbb'e hz,
        P.seqLeftMulAbs_apply_effect harch hb'e hz,
        P.seqLeftMulAbs_apply_effect harch hbe (P.sp_effect hb'e hz)]
      exact (P.sp_assoc_of_compatible hbe hb'e hz hcompat).symm
    have hlin : P.seqLeftMulAbs harch hbb'e
        = (P.seqLeftMulAbs harch hbe).comp (P.seqLeftMulAbs harch hb'e) :=
      OrderUnitSpace.linearMap_eq_of_eq_on_effects _ _ fun z hz => hS5 z hz
    rw [hlin]
    rfl
  exact (quadJSqrtEquiv hfam hsum hspres hspsos hspne).injective hkey


/-- ★★★ **`prop:theta`, the second multiplicativity equality**: `Θ_b Θ_{b'} = Θ_{b'} Θ_b` for
operator-commuting invertible effects.

Proved directly rather than by exchanging `b` and `b'` in `theta_mul`, because the exchange would
have to transport the effect proof for `b • b'` along `b • b' = b' • b`; the symmetric computation
avoids that entirely.  Both composites are carried by `Q_{√(b•b')}` onto `L_b L_{b'}` and
`L_{b'} L_b`, and those agree because S5 makes each of them `L_{b•b'}`. -/
theorem theta_comm {N : ℕ} {q : Fin N → J} {la mu : Fin N → ℝ}
    (hfam : IsOrthIdemFamily q) (hsum : (∑ k, q k) = 1)
    (hla0 : ∀ k, 0 ≤ la k) (hla1 : ∀ k, la k ≤ 1)
    (hmu0 : ∀ k, 0 ≤ mu k) (hmu1 : ∀ k, mu k ≤ 1)
    (hlane : ∀ k, q k ≠ 0 → la k ≠ 0) (hmune : ∀ k, q k ≠ 0 → mu k ≠ 0)
    {b b' : J} (hb : b = ∑ k, la k • q k) (hb' : b' = ∑ k, mu k • q k) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J)
        (hbe : OrderUnitSpace.IsEffect b) (hb'e : OrderUnitSpace.IsEffect b')
        (hbb'e : OrderUnitSpace.IsEffect (P.sp b b'))
        (Θb Θb' : J ≃ₗ[ℝ] J),
        (∀ x y : J, Θb (x * y) = Θb x * Θb y) →
        (∀ x y : J, Θb' (x * y) = Θb' x * Θb' y) →
        (∀ z : J, P.seqLeftMulAbs harch hbe z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θb z)) →
        (∀ z : J, P.seqLeftMulAbs harch hb'e z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb' z)) →
        ∀ y : J, Θb (Θb' y) = Θb' (Θb y) := by
  classical
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe hb'e hbb'e Θb Θb' hΘbmul hΘb'mul hΘb hΘb' y
  have hcone : ∀ {x : J}, OrderUnitSpace.IsEffect x →
      IsSoS (jmulₗ J) x ∧ IsSoS (jmulₗ J) ((1 : J) - x) := fun {x} hx =>
    (isEffect_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul x).mp hx
  obtain ⟨hbsos, hbcs⟩ := hcone hbe
  obtain ⟨hb'sos, hb'cs⟩ := hcone hb'e
  obtain ⟨hspsos, -⟩ := hcone hbb'e
  have hsb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ k, Real.sqrt (la k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hb
  have hsb' : jsqrt 1 EuclideanJordanAlgebra.one_mul b' = ∑ k, Real.sqrt (mu k) • q k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b' hfam hb'
  have hcomm : ∀ w, b * (b' * w) = b' * (b * w) :=
    opCommute_of_shared_resolution' hfam hb hb'
  have hsp : P.sp b b' = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) b' :=
    sp_eq_quadJ_of_opCommute hbsos hbcs hb'sos hb'cs hcomm P hS2
  have hspres : P.sp b b' = ∑ k, (la k * mu k) • q k := by
    rw [hsp, hsb]; conv_lhs => rw [hb']
    exact luders_of_resolution hfam hla0 mu
  have hspne : ∀ k, q k ≠ 0 → la k * mu k ≠ 0 := fun k hk =>
    mul_ne_zero (hlane k hk) (hmune k hk)
  -- square-root cone data, for the fixing property
  have hsqcone : ∀ (f : Fin N → ℝ), (∀ k, 0 ≤ f k) → (∀ k, f k ≤ 1) →
      IsSoS (jmulₗ J) (∑ k, Real.sqrt (f k) • q k) ∧
        IsSoS (jmulₗ J) ((1 : J) - ∑ k, Real.sqrt (f k) • q k) := by
    intro f hf0 hf1
    constructor
    · exact isSoS_sum _ _ fun k _ => isSoS_smul_idem (Real.sqrt_nonneg _) (hfam.idem k)
    · have hrw : (1 : J) - ∑ k, Real.sqrt (f k) • q k = ∑ k, (1 - Real.sqrt (f k)) • q k := by
        have hh := smul_unit_sub_eq hsum (rfl : (∑ k, Real.sqrt (f k) • q k) = _) 1
        rwa [one_smul] at hh
      rw [hrw]
      refine isSoS_sum _ _ fun k _ => isSoS_smul_idem ?_ (hfam.idem k)
      have : Real.sqrt (f k) ≤ 1 := by
        rw [show (1 : ℝ) = Real.sqrt 1 by simp]; exact Real.sqrt_le_sqrt (hf1 k)
      linarith
  obtain ⟨hsb'sos, hsb'cs⟩ := hsqcone mu hmu0 hmu1
  obtain ⟨hsbsos, hsbcs⟩ := hsqcone la hla0 hla1
  have hfixb : Θb (jsqrt 1 EuclideanJordanAlgebra.one_mul b')
      = jsqrt 1 EuclideanJordanAlgebra.one_mul b' := by
    rw [hsb']
    exact theta_fixes_of_opCommute hfam hsum hb hbsos hbcs hlane P hS2 harch hbe Θb hΘb
      hsb'sos hsb'cs (opCommute_of_shared_resolution' hfam hb (rfl : (∑ k, Real.sqrt (mu k) • q k) = _))
  have hfixb' : Θb' (jsqrt 1 EuclideanJordanAlgebra.one_mul b)
      = jsqrt 1 EuclideanJordanAlgebra.one_mul b := by
    rw [hsb]
    exact theta_fixes_of_opCommute hfam hsum hb' hb'sos hb'cs hmune P hS2 harch hb'e Θb' hΘb'
      hsbsos hsbcs (opCommute_of_shared_resolution' hfam hb' (rfl : (∑ k, Real.sqrt (la k) • q k) = _))
  -- S5 in both orders
  have hcompat : P.sp b b' = P.sp b' b := by
    rw [hsp, sp_eq_quadJ_of_opCommute hb'sos hb'cs hbsos hbcs (fun w => (hcomm w).symm) P hS2]
    exact luders_comm_of_opCommute hbsos hb'sos hcomm
  have hLcomp : ∀ z : J, OrderUnitSpace.IsEffect z →
      P.seqLeftMulAbs harch hbe (P.seqLeftMulAbs harch hb'e z)
        = P.seqLeftMulAbs harch hb'e (P.seqLeftMulAbs harch hbe z) := by
    intro z hz
    rw [P.seqLeftMulAbs_apply_effect harch hb'e hz,
      P.seqLeftMulAbs_apply_effect harch hbe (P.sp_effect hb'e hz),
      P.seqLeftMulAbs_apply_effect harch hbe hz,
      P.seqLeftMulAbs_apply_effect harch hb'e (P.sp_effect hbe hz),
      P.sp_assoc_of_compatible hbe hb'e hz hcompat,
      P.sp_assoc_of_compatible hb'e hbe hz hcompat.symm, hcompat]
  have hLlin : (P.seqLeftMulAbs harch hbe).comp (P.seqLeftMulAbs harch hb'e)
      = (P.seqLeftMulAbs harch hb'e).comp (P.seqLeftMulAbs harch hbe) :=
    OrderUnitSpace.linearMap_eq_of_eq_on_effects _ _ fun z hz => hLcomp z hz
  -- both composites are carried onto the two orders of `L`
  have hone : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (P.sp b b')) (Θb (Θb' y))
      = P.seqLeftMulAbs harch hbe (P.seqLeftMulAbs harch hb'e y) := by
    have hmove : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb (Θb' y))
        = Θb (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b') (Θb' y)) := by
      rw [map_quadJ_of_jordanHom hΘbmul, hfixb]
    rw [hsp, quadJ_jsqrt_luders_comp hfam hsum hla0 hmu0 hb hb', hmove, ← hΘb' y,
      ← hΘb (P.seqLeftMulAbs harch hb'e y)]
  have htwo : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (P.sp b b')) (Θb' (Θb y))
      = P.seqLeftMulAbs harch hb'e (P.seqLeftMulAbs harch hbe y) := by
    have hmove : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θb' (Θb y))
        = Θb' (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (Θb y)) := by
      rw [map_quadJ_of_jordanHom hΘb'mul, hfixb']
    rw [hcompat, sp_eq_quadJ_of_opCommute hb'sos hb'cs hbsos hbcs (fun w => (hcomm w).symm) P hS2,
      quadJ_jsqrt_luders_comp hfam hsum hmu0 hla0 hb' hb, hmove, ← hΘb y,
      ← hΘb' (P.seqLeftMulAbs harch hbe y)]
  refine (quadJSqrtEquiv hfam hsum hspres hspsos hspne).injective ?_
  rw [quadJSqrtEquiv_apply, quadJSqrtEquiv_apply, hone, htwo]
  exact congrFun (congrArg (fun f : J →ₗ[ℝ] J => (f : J → J)) hLlin) y


/-! ## `lem:frame-fix` (manifest row 15): what `Θ_r` does to a Jordan frame

★★★ Each frame atom is an effect that operator-commutes with `a(r) = ∑ f k • pₖ` — both are
resolved by the frame family — so the fixing property pins `Θ_r pᵢ = pᵢ` at once.  Linearity then
fixes the whole diagonal, and being a Jordan automorphism that fixes every atom makes `Θ_r`
preserve every Peirce block. -/

/-- Each atom of a Jordan frame is an effect. -/
theorem isEffect_frame_atom {N : ℕ} (F : JordanFrame J N) (i : Fin N) :
    IsSoS (jmulₗ J) (F.p i) ∧ IsSoS (jmulₗ J) ((1 : J) - F.p i) :=
  ⟨isSoS_of_idem (F.orthIdem.idem i), isSoS_one_sub_idem (F.orthIdem.idem i)⟩

/-- An atom is resolved by its own frame family, with the indicator coefficients. -/
theorem frame_atom_resolution {N : ℕ} (F : JordanFrame J N) (i : Fin N) :
    F.p i = ∑ k, (if k = i then (1 : ℝ) else 0) • F.p k := by
  classical
  rw [Finset.sum_eq_single i (fun k _ hk => by rw [if_neg hk, zero_smul])
    (fun hk => absurd (Finset.mem_univ i) hk), if_pos rfl, one_smul]

/-- ★★★ **`lem:frame-fix`, atom clause**: `Θ` fixes every atom of the frame that produced `a`. -/
theorem theta_fixes_frame_atom {N : ℕ} (F : JordanFrame J N) {f : Fin N → ℝ}
    (hf0 : ∀ k, 0 < f k) (hf1 : ∀ k, f k ≤ 1) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J)
        (hae : OrderUnitSpace.IsEffect (∑ k, f k • F.p k)) (Θ : J ≃ₗ[ℝ] J),
        (∀ z : J, P.seqLeftMulAbs harch hae z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (∑ k, f k • F.p k)) (Θ z)) →
        ∀ i : Fin N, Θ (F.p i) = F.p i := by
  classical
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae Θ hΘ i
  have hasos : IsSoS (jmulₗ J) (∑ k, f k • F.p k) :=
    isSoS_sum _ _ fun k _ => isSoS_smul_idem (hf0 k).le (F.orthIdem.idem k)
  have hacs : IsSoS (jmulₗ J) ((1 : J) - ∑ k, f k • F.p k) := by
    have hrw : (1 : J) - ∑ k, f k • F.p k = ∑ k, (1 - f k) • F.p k := by
      have hh := smul_unit_sub_eq F.complete (rfl : (∑ k, f k • F.p k) = _) 1
      rwa [one_smul] at hh
    rw [hrw]
    exact isSoS_sum _ _ fun k _ => isSoS_smul_idem (by linarith [hf1 k]) (F.orthIdem.idem k)
  obtain ⟨hpsos, hpcs⟩ := isEffect_frame_atom F i
  exact theta_fixes_of_opCommute F.orthIdem F.complete (rfl : (∑ k, f k • F.p k) = _)
    hasos hacs (fun k _ => (hf0 k).ne') P hS2 harch hae Θ hΘ hpsos hpcs
    (opCommute_of_shared_resolution' F.orthIdem (rfl : (∑ k, f k • F.p k) = _)
      (frame_atom_resolution F i))

/-- ★★★ **`lem:frame-fix`, Peirce-block clause**: a Jordan automorphism fixing every frame atom
preserves every Peirce block of the frame. -/
theorem jordanAut_maps_frameBlock {N : ℕ} (F : JordanFrame J N) {Θ : J ≃ₗ[ℝ] J}
    (hmul : ∀ x y : J, Θ (x * y) = Θ x * Θ y) (hfix : ∀ i, Θ (F.p i) = F.p i)
    {i j : Fin N} (hij : i ≠ j) {x : J} (hx : x ∈ frameBlockRaw F i j) :
    Θ x ∈ frameBlockRaw F i j := by
  obtain ⟨h1, h2⟩ := (mem_frameBlockRaw_off hij).mp hx
  refine (mem_frameBlockRaw_off hij).mpr ⟨?_, ?_⟩
  · have := congrArg Θ h1
    rwa [hmul, hfix, map_smul] at this
  · have := congrArg Θ h2
    rwa [hmul, hfix, map_smul] at this


/-- A frame-diagonal element acts on an off-diagonal Peirce block by the mean of its two
coefficients. -/
theorem frameDiag_mul_block {N : ℕ} (F : JordanFrame J N) (g : Fin N → ℝ) {i j : Fin N}
    (hij : i ≠ j) {x : J} (hx : x ∈ frameBlockRaw F i j) :
    (∑ k, g k • F.p k) * x = ((g i + g j) / 2) • x := by
  classical
  obtain ⟨hi, hj⟩ := (mem_frameBlockRaw_off hij).mp hx
  rw [Finset.sum_mul]
  have hterm : ∀ k ∈ (Finset.univ : Finset (Fin N)),
      (g k • F.p k) * x = (if k = i then g i / 2 else if k = j then g j / 2 else 0) • x := by
    intro k _
    rw [smul_mul_assoc]
    by_cases hki : k = i
    · subst hki; rw [hi, if_pos rfl, smul_smul]; ring_nf
    by_cases hkj : k = j
    · subst hkj; rw [hj, if_neg hki, if_pos rfl, smul_smul]; ring_nf
    · rw [frame_mul_eq_zero_of_eigen_half F hij hki hkj hi hj, smul_zero, if_neg hki,
        if_neg hkj, zero_smul]
  rw [Finset.sum_congr rfl hterm, ← Finset.sum_smul]
  congr 1
  have hji : j ∈ Finset.univ.erase i := Finset.mem_erase.mpr ⟨Ne.symm hij, Finset.mem_univ j⟩
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i), if_pos rfl,
    ← Finset.add_sum_erase _ _ hji, if_neg (Ne.symm hij), if_pos rfl]
  have hrest : ∑ k ∈ (Finset.univ.erase i).erase j,
      (if k = i then g i / 2 else if k = j then g j / 2 else 0) = 0 := by
    refine Finset.sum_eq_zero fun k hk => ?_
    rw [if_neg (Finset.mem_erase.mp (Finset.mem_erase.mp hk).2).1,
      if_neg (Finset.mem_erase.mp hk).1]
  rw [hrest]
  ring

/-- ★★★ **`lem:frame-fix`, block-diagonality**: `Q` of a frame-diagonal element acts on the
off-diagonal Peirce block `V_{ij}` as the scalar `gᵢgⱼ`. -/
theorem quadJ_frameDiag_block {N : ℕ} (F : JordanFrame J N) (g : Fin N → ℝ) {i j : Fin N}
    (hij : i ≠ j) {x : J} (hx : x ∈ frameBlockRaw F i j) :
    quadJ (∑ k, g k • F.p k) x = (g i * g j) • x := by
  have h1 : (∑ k, g k • F.p k) * x = ((g i + g j) / 2) • x := frameDiag_mul_block F g hij hx
  have hsq : (∑ k, g k • F.p k) * (∑ k, g k • F.p k) = ∑ k, (g k * g k) • F.p k :=
    sum_smul_mul_sum_smul_of_orthIdem F.orthIdem g g
  have h2 : (∑ k, (g k * g k) • F.p k) * x = ((g i * g i + g j * g j) / 2) • x :=
    frameDiag_mul_block F (fun k => g k * g k) hij hx
  rw [quadJ_apply, h1, hsq, h2, mul_smul_comm, h1, smul_smul]
  match_scalars
  ring


omit [FiniteDimensional ℝ J] in
/-- ★★★ **`lem:frame-fix`, diagonal clause**: fixing the atoms fixes the whole frame diagonal, by
linearity. -/
theorem jordanAut_fixes_frameDiag {N : ℕ} (F : JordanFrame J N) {Θ : J ≃ₗ[ℝ] J}
    (hfix : ∀ i, Θ (F.p i) = F.p i) (g : Fin N → ℝ) :
    Θ (∑ k, g k • F.p k) = ∑ k, g k • F.p k := by
  rw [map_sum]
  exact Finset.sum_congr rfl fun k _ => by rw [map_smul, hfix k]

/-- ★★★ **`lem:frame-fix`, final clause**: `L_{a(r)} = Q_{√a} ∘ Θ` maps every off-diagonal Peirce
block into itself, i.e. **`L_{a(r)}` is Peirce-block-diagonal**.

`Θ` preserves the block (it is a Jordan automorphism fixing the atoms) and `Q_{√a}` acts on the
block by the scalar `√fᵢ√fⱼ`. -/
theorem seqLeftMul_mapsTo_frameBlock {N : ℕ} (F : JordanFrame J N) {f : Fin N → ℝ}
    (hf0 : ∀ k, 0 < f k) (hf1 : ∀ k, f k ≤ 1) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J)
        (hae : OrderUnitSpace.IsEffect (∑ k, f k • F.p k)) (Θ : J ≃ₗ[ℝ] J),
        (∀ x y : J, Θ (x * y) = Θ x * Θ y) →
        (∀ z : J, P.seqLeftMulAbs harch hae z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (∑ k, f k • F.p k)) (Θ z)) →
        ∀ {i j : Fin N}, i ≠ j → ∀ {x : J}, x ∈ frameBlockRaw F i j →
          P.seqLeftMulAbs harch hae x ∈ frameBlockRaw F i j := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae Θ hmul hΘ i j hij x hx
  have hfix := theta_fixes_frame_atom F hf0 hf1 P hS2 harch hae Θ hΘ
  have hΘx : Θ x ∈ frameBlockRaw F i j := jordanAut_maps_frameBlock F hmul hfix hij hx
  have hsq : jsqrt 1 EuclideanJordanAlgebra.one_mul (∑ k, f k • F.p k)
      = ∑ k, Real.sqrt (f k) • F.p k :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul _ F.orthIdem rfl
  rw [hΘ x, hsq, quadJ_frameDiag_block F _ hij hΘx]
  exact Submodule.smul_mem _ _ hΘx


/-! ## `lem:homomorphism` (manifest row 17): the group law

★★★ The twist family `a(r) := ∑ e^{rₖ} pₖ` carries the additive group law of the parameters into
the *sequential product*: `a(r) · a(s) = a(r+s)` for **any** S1–S7+S2 product, not just the
standard one, because the two are operator-commuting effects and `sp_eq_quadJ_of_opCommute` pins
the value.  Combined with `theta_mul` this is the homomorphism clause `Θ_{r+s} = Θ_r Θ_s`. -/

/-- The twist family of a Jordan frame at parameter `r ∈ (−∞,0]ⁿ`. -/
def twistElt {N : ℕ} (F : JordanFrame J N) (r : Fin N → ℝ) : J :=
  ∑ k, Real.exp (r k) • F.p k

theorem twistElt_isSoS {N : ℕ} (F : JordanFrame J N) (r : Fin N → ℝ) :
    IsSoS (jmulₗ J) (twistElt F r) :=
  isSoS_sum _ _ fun k _ => isSoS_smul_idem (Real.exp_pos _).le (F.orthIdem.idem k)

theorem twistElt_compl_isSoS {N : ℕ} (F : JordanFrame J N) {r : Fin N → ℝ}
    (hr : ∀ k, r k ≤ 0) : IsSoS (jmulₗ J) ((1 : J) - twistElt F r) := by
  have hrw : (1 : J) - twistElt F r = ∑ k, (1 - Real.exp (r k)) • F.p k := by
    have hh := smul_unit_sub_eq F.complete (rfl : twistElt F r = _) 1
    rwa [one_smul] at hh
  rw [hrw]
  refine isSoS_sum _ _ fun k _ => isSoS_smul_idem ?_ (F.orthIdem.idem k)
  have : Real.exp (r k) ≤ 1 := Real.exp_le_one_iff.mpr (hr k)
  linarith

/-- ★★★ **The group law at the element level**: `a(r) · a(s) = a(r+s)`, for every S1–S7+S2
product. -/
theorem sp_twistElt {N : ℕ} (F : JordanFrame J N) {r s : Fin N → ℝ}
    (hr : ∀ k, r k ≤ 0) (hs : ∀ k, s k ≤ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      P.sp (twistElt F r) (twistElt F s) = twistElt F (r + s) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2
  have hcomm : ∀ w, twistElt F r * (twistElt F s * w) = twistElt F s * (twistElt F r * w) :=
    opCommute_of_shared_resolution' F.orthIdem rfl rfl
  rw [sp_eq_quadJ_of_opCommute (twistElt_isSoS F r) (twistElt_compl_isSoS F hr)
    (twistElt_isSoS F s) (twistElt_compl_isSoS F hs) hcomm P hS2]
  have hsq : jsqrt 1 EuclideanJordanAlgebra.one_mul (twistElt F r)
      = jsqrtOfResolution F.p (fun k => Real.exp (r k)) :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul _ F.orthIdem rfl
  rw [hsq, show twistElt F s = ∑ k, Real.exp (s k) • F.p k from rfl,
    luders_of_resolution F.orthIdem (fun k => (Real.exp_pos (r k)).le)]
  show _ = ∑ k, Real.exp ((r + s) k) • F.p k
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Pi.add_apply, Real.exp_add]


/-- ★★★ **`lem:homomorphism`, the homomorphism clause**: `Θ_{r+s} = Θ_r Θ_s` (and the two commute).

`sp_twistElt` identifies the product element `a(r) · a(s)` with `a(r+s)`, so the twist
automorphism indexed there is the one at `r + s`; `theta_mul` and `theta_comm` then supply both
equalities.  ★ Stated against `P.sp (a r) (a s)` rather than against `a (r+s)` so that no
dependent transport along `sp_twistElt` is needed — the two are the same element by that lemma. -/
theorem theta_twistElt_hom {N : ℕ} (F : JordanFrame J N) {r s : Fin N → ℝ}
    (hr : ∀ k, r k ≤ 0) (hs : ∀ k, s k ≤ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J)
        (her : OrderUnitSpace.IsEffect (twistElt F r))
        (hes : OrderUnitSpace.IsEffect (twistElt F s))
        (hers : OrderUnitSpace.IsEffect (P.sp (twistElt F r) (twistElt F s)))
        (Θr Θs Θrs : J ≃ₗ[ℝ] J),
        (∀ x y : J, Θr (x * y) = Θr x * Θr y) →
        (∀ x y : J, Θs (x * y) = Θs x * Θs y) →
        (∀ z : J, P.seqLeftMulAbs harch her z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (twistElt F r)) (Θr z)) →
        (∀ z : J, P.seqLeftMulAbs harch hes z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (twistElt F s)) (Θs z)) →
        (∀ z : J, P.seqLeftMulAbs harch hers z
            = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul
                (P.sp (twistElt F r) (twistElt F s))) (Θrs z)) →
        (∀ y : J, Θrs y = Θr (Θs y)) ∧ (∀ y : J, Θr (Θs y) = Θs (Θr y)) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch her hes hers Θr Θs Θrs hΘrmul hΘsmul hΘr hΘs hΘrs
  have hexp0 : ∀ (t : Fin N → ℝ) (k : Fin N), 0 ≤ Real.exp (t k) := fun t k =>
    (Real.exp_pos _).le
  have hexp1 : ∀ {t : Fin N → ℝ}, (∀ k, t k ≤ 0) → ∀ k, Real.exp (t k) ≤ 1 := fun ht k =>
    Real.exp_le_one_iff.mpr (ht k)
  have hexpne : ∀ (t : Fin N → ℝ) (k : Fin N), F.p k ≠ 0 → Real.exp (t k) ≠ 0 := fun t k _ =>
    (Real.exp_pos _).ne'
  exact ⟨theta_mul F.orthIdem F.complete (hexp0 r) (hexp1 hr) (hexp0 s) (hexp1 hs)
      (hexpne r) (hexpne s) rfl rfl P hS2 harch her hes hers Θr Θs Θrs hΘrmul hΘr hΘs hΘrs,
    theta_comm F.orthIdem F.complete (hexp0 r) (hexp1 hr) (hexp0 s) (hexp1 hs)
      (hexpne r) (hexpne s) rfl rfl P hS2 harch her hes hers Θr Θs hΘrmul hΘsmul hΘr hΘs⟩


/-! ## `Θ` as a definition

★★★ `exists_theta` produces `Θ` existentially, which is enough for every *algebraic* clause but
not for the analytic ones: continuity of `r ↦ Θ_r`, the identity component `Stab(F)°`, and the
differential `dχ` all need `Θ` to be a **function of its data**.  This section names it.

★ The construction is exactly the one `exists_theta` performs — `Q_{√b}⁻¹ ∘ L_b` — and
`thetaOf_spec` re-derives that theorem's three conclusions for it, so nothing downstream has to
choose between the two forms. -/

/-- ★★★ **The twist automorphism, as a function of its data.**  `Θ_b := Q_{√b}⁻¹ ∘ L_b`. -/
noncomputable def thetaOf {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J) (_ : OrderUnitSpace.IsEffect b), J ≃ₗ[ℝ] J :=
  fun P hS2 harch hbe =>
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    (LinearEquiv.ofBijective (P.seqLeftMulAbs harch hbe)
      ⟨(sp_orderReflection hfam hsum hb hbsos hcsos hne P hS2 harch hbe).2,
        (LinearMap.injective_iff_surjective
          (f := P.seqLeftMulAbs harch hbe)).mp
          (sp_orderReflection hfam hsum hb hbsos hcsos hne P hS2 harch hbe).2⟩).trans
      (quadJSqrtEquiv hfam hsum hb hbsos hne).symm

/-- ★★★ **`thetaOf` satisfies `prop:theta`'s three conclusions.**  Unitality, the Jordan-morphism
property, and the defining identity `L_b = Q_{√b} ∘ Θ_b`. -/
theorem thetaOf_spec {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (hbe : OrderUnitSpace.IsEffect b),
      thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe 1 = 1 ∧
        (∀ x y : J, thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe (x * y)
          = thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe x
            * thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe y) ∧
        ∀ z : J, P.seqLeftMulAbs harch hbe z
          = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b)
              (thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe z) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe
  set Θ := thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe with hΘdef
  set E := quadJSqrtEquiv hfam hsum hb hbsos hne with hEdef
  have hΘval : ∀ z : J, Θ z = E.symm (P.seqLeftMulAbs harch hbe z) := fun _ => rfl
  have hid : ∀ z : J, E (Θ z) = P.seqLeftMulAbs harch hbe z := fun z => by
    rw [hΘval z, LinearEquiv.apply_symm_apply]
  have hle : ∀ z : J, (0 : J) ≤ z ↔ IsSoS (jmulₗ J) z := by
    intro z
    rw [le_ofBilinear (m := jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul 0 z, sub_zero]
  have hunit : Θ 1 = 1 := by
    refine E.injective ?_
    rw [hid, hEdef, quadJSqrtEquiv_apply, quadJ_unit EuclideanJordanAlgebra.one_mul,
      jsqrt_sq_of_isSoS hbsos]
    exact P.seqLeftMulAbs_one harch hbe
  have horder : ∀ z : J, IsSoS mulLₗ z ↔ IsSoS mulLₗ (Θ z) := by
    intro z
    rw [← isSoS_jmulₗ_iff_mulLₗ, ← isSoS_jmulₗ_iff_mulLₗ]
    constructor
    · intro hz
      have h2 : IsSoS (jmulₗ J) (P.seqLeftMulAbs harch hbe z) :=
        (hle _).mp (P.seqLeftMulAbs_nonneg harch hbe ((hle z).mpr hz))
      have hval : Θ z = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul
          (jinvOfResolution c lam)) (P.seqLeftMulAbs harch hbe z) := rfl
      rw [hval]
      exact quadJ_isSoS _ h2
    · intro hz
      have hLz : IsSoS (jmulₗ J) (P.seqLeftMulAbs harch hbe z) := by
        rw [← hid z, hEdef, quadJSqrtEquiv_apply]
        exact quadJ_isSoS _ hz
      exact (hle z).mp
        ((sp_orderReflection hfam hsum hb hbsos hcsos hne P hS2 harch hbe).1 z ((hle _).mpr hLz))
  exact ⟨hunit, fun x y =>
    map_jordan_of_orderIso EuclideanJordanAlgebra.one_mul Θ hunit horder x y,
    fun z => (hid z).symm⟩


/-- ★★★ **`Θ` at the unit is the identity** — the base point every identity-component argument
starts from, and `χ(0) = id` for the twist family. -/
theorem thetaOf_one {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : (1 : J) = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) (1 : J)) (hcsos : IsSoS (jmulₗ J) ((1 : J) - 1))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (hbe : OrderUnitSpace.IsEffect (1 : J)) (z : J),
      thetaOf hfam hsum hb hbsos hcsos hne P hS2 harch hbe z = z := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe z
  obtain ⟨-, -, hid⟩ := thetaOf_spec hfam hsum hb hbsos hcsos hne P hS2 harch hbe
  have hE : ∀ w : J, quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (1 : J)) w = w := by
    intro w; rw [jsqrt_one, quadJ_unit_left EuclideanJordanAlgebra.one_mul]
  have hL : P.seqLeftMulAbs harch hbe z = z := by
    refine OrderUnitSpace.linearMap_eq_of_eq_on_effects (P.seqLeftMulAbs harch hbe)
      LinearMap.id (fun a ha => ?_) ▸ rfl
    rw [P.seqLeftMulAbs_apply_effect harch hbe ha]
    exact P.sp_unit_left ha
  have := hid z
  rw [hL, hE] at this
  exact this.symm


/-! ## The frame stabilizer

★★★ `Stab(F)` is the set of Jordan automorphisms of `J` fixing every atom of the frame `F`,
realised inside the operator space `J →L[ℝ] J` so that it carries a topology — which is what
`Stab(F)°`, the identity component, needs.  Rows 15 and 17 both quantify over it. -/

/-- **The frame stabilizer**, as a subset of the operator space. -/
def stabFrame {N : ℕ} (F : JordanFrame J N) : Set (J →L[ℝ] J) :=
  {Φ | Function.Bijective Φ ∧ (∀ x y : J, Φ (x * y) = Φ x * Φ y) ∧ ∀ i, Φ (F.p i) = F.p i}

theorem id_mem_stabFrame {N : ℕ} (F : JordanFrame J N) :
    ContinuousLinearMap.id ℝ J ∈ stabFrame F :=
  ⟨Function.bijective_id, fun _ _ => rfl, fun _ => rfl⟩

/-- ★★★ **`Θ_r` lies in the frame stabilizer.**  It is a Jordan automorphism (`thetaOf_spec`) and
it fixes every frame atom (`theta_fixes_frame_atom`). -/
theorem theta_mem_stabFrame {N : ℕ} (F : JordanFrame J N) {f : Fin N → ℝ}
    (hf0 : ∀ k, 0 < f k) (hf1 : ∀ k, f k ≤ 1) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J)
      (hae : OrderUnitSpace.IsEffect (∑ k, f k • F.p k))
      (hasos : IsSoS (jmulₗ J) (∑ k, f k • F.p k))
      (hacs : IsSoS (jmulₗ J) ((1 : J) - ∑ k, f k • F.p k)),
      LinearMap.toContinuousLinearMap
        (thetaOf F.orthIdem F.complete rfl hasos hacs (fun k _ => (hf0 k).ne')
          P hS2 harch hae).toLinearMap ∈ stabFrame F := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae hasos hacs
  obtain ⟨-, hmul, hid⟩ :=
    thetaOf_spec F.orthIdem F.complete rfl hasos hacs (fun k _ => (hf0 k).ne') P hS2 harch hae
  refine ⟨?_, hmul, ?_⟩
  · exact (thetaOf F.orthIdem F.complete rfl hasos hacs (fun k _ => (hf0 k).ne')
      P hS2 harch hae).bijective
  · intro i
    exact theta_fixes_frame_atom F hf0 hf1 P hS2 harch hae _ hid i


/-! ## The path from the identity to `Θ_r`

★★★ The last step for `Θ_r ∈ Stab(F)°`.  On the twist family everything is explicit: the
spectral inverse of `a(r)` is `a(−r)`, so `Θ_r = Q_{√a(−r)} ∘ L_{a(r)}` with **no `Classical.choose`
anywhere in the formula**, and continuity in `r` follows from the two operator-continuity theorems.
Clamping the parameter to `[0,1]` makes the path total on `ℝ`, so its range is connected. -/

theorem jinvOfResolution_twistElt {N : ℕ} (F : JordanFrame J N) (r : Fin N → ℝ) :
    jinvOfResolution F.p (fun k => Real.exp (r k)) = twistElt F (-r) := by
  show (∑ k, (Real.exp (r k))⁻¹ • F.p k : J) = ∑ k, Real.exp ((-r) k) • F.p k
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Pi.neg_apply, Real.exp_neg]

/-- ★★★ **`Θ_r` in closed form on the twist family**: `Θ_r = Q_{√a(−r)} ∘ L_{a(r)}`. -/
theorem thetaOf_twistElt_apply {N : ℕ} (F : JordanFrame J N) {r : Fin N → ℝ}
    (hr : ∀ k, r k ≤ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J)
      (hae : OrderUnitSpace.IsEffect (twistElt F r)) (z : J),
      thetaOf F.orthIdem F.complete (rfl : twistElt F r = _) (twistElt_isSoS F r)
          (twistElt_compl_isSoS F hr) (fun k _ => (Real.exp_pos (r k)).ne')
          P hS2 harch hae z
        = quadJ (∑ k, Real.sqrt (Real.exp (-r k)) • F.p k)
            (P.seqLeftMulAbs harch hae z) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae z
  have hval : thetaOf F.orthIdem F.complete (rfl : twistElt F r = _) (twistElt_isSoS F r)
      (twistElt_compl_isSoS F hr) (fun k _ => (Real.exp_pos (r k)).ne') P hS2 harch hae z
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul
          (jinvOfResolution F.p (fun k => Real.exp (r k)))) (P.seqLeftMulAbs harch hae z) := rfl
  rw [hval, jinvOfResolution_twistElt F r]
  congr 1
  have := jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul (twistElt F (-r))
    F.orthIdem (rfl : twistElt F (-r) = _)
  rw [this]
  rfl


/-- ★★★ **`Θ` depends continuously on the twist parameter**, as an operator-valued map.

Off the closed form `Θ_ρ = Q_{√a(−ρ)} ∘ L_{a(ρ)}`: the coefficient family `ρ ↦ ∑ e^{−ρₖ/2}pₖ` is
continuous, `v ↦ Q_v` is operator-continuous (`continuous_toCLM_quadJ`), `a ↦ L_a` is
operator-continuous on the effects (`continuousOn_toCLM_seqLeftMulAbs`, i.e. paper S2 upgraded),
and composition of continuous linear maps is continuous. -/
theorem continuous_toCLM_thetaOf_twistElt {N : ℕ} (F : JordanFrame J N)
    {X : Type} [TopologicalSpace X] (ρ : X → (Fin N → ℝ)) (hρ : Continuous ρ)
    (hρ0 : ∀ x k, ρ x k ≤ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J)
      (hae : ∀ x, OrderUnitSpace.IsEffect (twistElt F (ρ x))),
      Continuous fun x => LinearMap.toContinuousLinearMap
        (thetaOf F.orthIdem F.complete (rfl : twistElt F (ρ x) = _)
          (twistElt_isSoS F (ρ x)) (twistElt_compl_isSoS F (hρ0 x))
          (fun k _ => (Real.exp_pos (ρ x k)).ne') P hS2 harch (hae x)).toLinearMap := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hae
  -- the coefficient element of the inverse square root
  have hv : Continuous fun x => ∑ k, Real.sqrt (Real.exp (-(ρ x k))) • F.p k := by
    refine continuous_finsetSum _ fun k _ => ?_
    exact ((Real.continuous_sqrt.comp (Real.continuous_exp.comp
      (((continuous_apply k).comp hρ).neg))).smul continuous_const)
  -- the left multiplication
  have hg : Continuous fun x => twistElt F (ρ x) := by
    refine continuous_finsetSum _ fun k _ => ?_
    exact ((Real.continuous_exp.comp ((continuous_apply k).comp hρ)).smul continuous_const)
  have hL := continuousOn_toCLM_seqLeftMulAbs P hS2 harch (fun x => twistElt F (ρ x)) hg hae
  -- assemble
  have hrw : (fun x => LinearMap.toContinuousLinearMap
      (thetaOf F.orthIdem F.complete (rfl : twistElt F (ρ x) = _)
        (twistElt_isSoS F (ρ x)) (twistElt_compl_isSoS F (hρ0 x))
        (fun k _ => (Real.exp_pos (ρ x k)).ne') P hS2 harch (hae x)).toLinearMap)
      = fun x => (LinearMap.toContinuousLinearMap
          (quadJ (∑ k, Real.sqrt (Real.exp (-(ρ x k))) • F.p k))).comp
        (LinearMap.toContinuousLinearMap (P.seqLeftMulAbs harch (hae x))) := by
    funext x
    refine ContinuousLinearMap.ext fun z => ?_
    exact thetaOf_twistElt_apply F (hρ0 x) P hS2 harch (hae x) z
  rw [hrw]
  exact (isBoundedBilinearMap_comp (𝕜 := ℝ) (E := J) (F := J) (G := J)).continuous.comp
    ((continuous_toCLM_quadJ.comp hv).prodMk hL)

end RadicalRelativity.EJA
