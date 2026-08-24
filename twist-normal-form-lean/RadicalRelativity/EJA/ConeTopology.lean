/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.PseudoTransfer
import Mathlib.Analysis.Calculus.FDeriv.Bilinear

set_option linter.style.longLine false

/-!
# Self-duality and closedness of the Euclidean Jordan cone

The cone of a Euclidean Jordan algebra is **self-dual** for the trace form:

  `x ≥ 0  ↔  ⟪x, y⟫ ≥ 0 for every y ≥ 0`.

Both directions are short given what the tree already carries, but neither was stated, and the
consequence — that the cone is **topologically closed**, hence that the effect interval is
**compact** — is what the remaining S-axioms for the Lüders product need and what nothing in the
development could say before.

★ The forward direction is where the recent work pays: `⟪g ∘ g, y⟫ = ⟪Q_g 1, y⟫ = ⟪1, Q_g y⟫` by
self-adjointness of the quadratic representation, and `Q_g y` is back in the cone by
`quadJ_isSoS` — the cone-preservation theorem proved for `prop:pseudo-transfer`.  Pairing against
the unit is then `inner_idem_isSoS_nonneg` at the idempotent `1`.

★ The reverse direction is the spectral resolution: test against each spectral idempotent to pin
every eigenvalue nonnegative, then reassemble with `isSoS_smul_idem`.

Closedness follows because self-duality exhibits the cone as an intersection of closed
half-spaces, and compactness of the effects because `0 ≤ x ≤ 1` forces `‖x‖ ≤ ‖1‖`.
-/

noncomputable section

namespace RadicalRelativity.EJA

open Finset

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]
  [EuclideanJordanAlgebra J] [FiniteDimensional ℝ J]

/-! ## Pairing against the unit -/

/-- The unit is idempotent, so pairing a cone element against it is a special case of
`inner_idem_isSoS_nonneg`. -/
theorem inner_unit_nonneg_of_isSoS {x : J} (hx : IsSoS (jmulₗ J) x) :
    (0 : ℝ) ≤ inner ℝ (1 : J) x := by
  refine inner_idem_isSoS_nonneg jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc ?_ hx
  show (1 : J) * (1 : J) = 1
  exact EuclideanJordanAlgebra.one_mul 1

/-! ## Self-duality -/

/-- ★★★ **The cone pairs nonnegatively with itself.**  `⟪g∘g, y⟫ = ⟪Q_g 1, y⟫ = ⟪1, Q_g y⟫ ≥ 0`,
using self-adjointness of `Q_g`, cone preservation (`quadJ_isSoS`) and the unit pairing. -/
theorem inner_nonneg_of_isSoS {x y : J} (hx : IsSoS (jmulₗ J) x) (hy : IsSoS (jmulₗ J) y) :
    (0 : ℝ) ≤ inner ℝ x y := by
  obtain ⟨k, g, hg⟩ := hx
  rw [hg, sum_inner]
  refine Finset.sum_nonneg fun i _ => ?_
  have hsq : jmulₗ J (g i) (g i) = quadJ (g i) (1 : J) :=
    (quadJ_unit EuclideanJordanAlgebra.one_mul (g i)).symm
  rw [hsq, quadJ_inner_self_adjoint (g i) (1 : J) y]
  exact inner_unit_nonneg_of_isSoS (quadJ_isSoS (g i) hy)

omit [FiniteDimensional ℝ J] in
/-- Distinct members of an orthogonal idempotent family are inner-orthogonal. -/
theorem inner_eq_zero_of_orth {c d : J} (hc : jmulₗ J c c = c) (hcd : jmulₗ J c d = 0) :
    (inner ℝ c d : ℝ) = 0 := by
  have h1 := jmulₗ_inner_assoc c c d
  rw [hc, hcd, inner_zero_right] at h1
  exact h1

/-- ★★★ **Self-duality of the Euclidean Jordan cone.**  `x ≥ 0` exactly when `x` pairs
nonnegatively with the whole cone. -/
theorem isSoS_iff_forall_inner_nonneg {x : J} :
    IsSoS (jmulₗ J) x ↔ ∀ y : J, IsSoS (jmulₗ J) y → (0 : ℝ) ≤ inner ℝ x y := by
  refine ⟨fun hx y hy => inner_nonneg_of_isSoS hx hy, fun h => ?_⟩
  classical
  obtain ⟨n, c, lam, hfam, -, hx, -⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul x
  rw [hx]
  refine isSoS_sum _ _ fun i _ => ?_
  by_cases hc : c i = 0
  · rw [hc, smul_zero]; exact isSoS_zero
  refine isSoS_smul_idem ?_ (hfam.idem i)
  have hpair := h (c i) (isSoS_of_idem (hfam.idem i))
  rw [hx, sum_inner] at hpair
  have hdiag : ∀ j ∈ (Finset.univ : Finset (Fin n)),
      (inner ℝ (lam j • c j) (c i) : ℝ)
        = if j = i then lam i * (inner ℝ (c i) (c i) : ℝ) else 0 := by
    intro j _
    by_cases hj : j = i
    · subst hj; simp [real_inner_smul_left]
    · rw [if_neg hj, real_inner_smul_left,
        inner_eq_zero_of_orth (hfam.idem j) (hfam.orth j i hj), mul_zero]
  rw [Finset.sum_congr rfl hdiag, Finset.sum_ite_eq' Finset.univ i] at hpair
  simp only [Finset.mem_univ, if_true] at hpair
  have hpos : (0 : ℝ) < inner ℝ (c i) (c i) := by
    rcases (real_inner_self_nonneg (x := c i)).lt_or_eq with hlt | heq
    · exact hlt
    · exact absurd (inner_self_eq_zero.mp heq.symm) hc
  nlinarith [hpair, hpos]


/-! ## Closedness of the cone, compactness of the effect interval

Self-duality exhibits the cone as an intersection of closed half-spaces, which is what makes it
closed; the effect interval is then closed as an intersection of two closed sets and bounded
because `0 ≤ x ≤ 1` forces `‖x‖ ≤ ‖1‖`.  Finite dimensionality turns that into compactness.

★ The effect interval is written out as a set here rather than through
`EJA.orderUnitSpaceOfBilinear`'s `IsEffect`, so that nothing in this file depends on which
order-unit instance is in scope. -/

/-- **The Euclidean Jordan cone is closed.** -/
theorem isClosed_isSoS : IsClosed {x : J | IsSoS (jmulₗ J) x} := by
  have hset : {x : J | IsSoS (jmulₗ J) x}
      = ⋂ y ∈ {y : J | IsSoS (jmulₗ J) y}, {x : J | (0 : ℝ) ≤ inner ℝ x y} := by
    ext x
    simp only [Set.mem_ofPred_eq, Set.mem_iInter₂]
    exact ⟨fun hx y hy => inner_nonneg_of_isSoS hx hy,
      fun h => isSoS_iff_forall_inner_nonneg.mpr h⟩
  rw [hset]
  refine isClosed_biInter fun y _ => ?_
  exact isClosed_le continuous_const (Continuous.inner continuous_id continuous_const)

/-- The effect interval `[0, 1]` of the Jordan order, as a set. -/
def effectSet (J : Type*) [NormedAddCommGroup J] [InnerProductSpace ℝ J]
    [EuclideanJordanAlgebra J] : Set J :=
  {x : J | IsSoS (jmulₗ J) x ∧ IsSoS (jmulₗ J) (1 - x)}

theorem isClosed_effectSet : IsClosed (effectSet J) := by
  have h1 : IsClosed {x : J | IsSoS (jmulₗ J) x} := isClosed_isSoS
  have h2 : IsClosed {x : J | IsSoS (jmulₗ J) (1 - x)} :=
    isClosed_isSoS.preimage (continuous_const.sub continuous_id)
  exact h1.inter h2

/-- Effects have norm at most `‖1‖`: `⟪x,x⟫ ≤ ⟪x,1⟫ ≤ ⟪1,1⟫`, both steps by self-duality. -/
theorem inner_self_le_of_mem_effectSet {x : J} (hx : x ∈ effectSet J) :
    (inner ℝ x x : ℝ) ≤ inner ℝ (1 : J) (1 : J) := by
  obtain ⟨hx0, hx1⟩ := hx
  have hone : IsSoS (jmulₗ J) (1 : J) :=
    isSoS_of_idem (show jmulₗ J (1 : J) (1 : J) = 1 from EuclideanJordanAlgebra.one_mul 1)
  have hstep1 : (inner ℝ x x : ℝ) ≤ inner ℝ x 1 := by
    have h := inner_nonneg_of_isSoS hx0 hx1
    rw [inner_sub_right] at h
    linarith
  have hstep2 : (inner ℝ x (1 : J) : ℝ) ≤ inner ℝ (1 : J) (1 : J) := by
    have h := inner_nonneg_of_isSoS hx1 hone
    rw [inner_sub_left] at h
    have hc : (inner ℝ x (1 : J) : ℝ) = inner ℝ (1 : J) x := real_inner_comm _ _
    linarith [hc]
  linarith

theorem isBounded_effectSet : Bornology.IsBounded (effectSet J) := by
  refine (Metric.isBounded_iff_subset_closedBall 0).mpr ⟨‖(1 : J)‖, fun x hx => ?_⟩
  rw [Metric.mem_closedBall, dist_zero_right]
  have h := inner_self_le_of_mem_effectSet hx
  rw [real_inner_self_eq_norm_sq, real_inner_self_eq_norm_sq] at h
  nlinarith [norm_nonneg x, norm_nonneg (1 : J)]

/-- ★★ **The effect interval of a finite-dimensional Euclidean Jordan algebra is compact.**
This is what the continuity of the Jordan square root — hence paper S2 for the Lüders product —
is going to be extracted from. -/
theorem isCompact_effectSet : IsCompact (effectSet J) :=
  Metric.isCompact_of_isClosed_isBounded isClosed_effectSet isBounded_effectSet


/-! ## Uniqueness of the positive square root

`jsqrt` is *defined* by a chosen resolution, so "it is a square root" (`jsqrt_mul_self`) and "it
is *the* square root" are different statements, and only the first was in the tree.  The second
is what injectivity of squaring on the cone needs, and injectivity is half of what the
compactness argument for continuity needs. -/

/-- **`jsqrt` inverts squaring on the cone.**  Reading `jsqrt` off the squared resolution gives
`∑ √(σᵢ²) • cᵢ = ∑ |σᵢ| • cᵢ`, and the cone pins `σᵢ ≥ 0` at every nonzero idempotent
(`nonneg_coeff_of_isSoS`), where alone the term matters. -/
theorem jsqrt_mul_self_of_isSoS {s : J} (hs : IsSoS (jmulₗ J) s) :
    jsqrt 1 EuclideanJordanAlgebra.one_mul (s * s) = s := by
  classical
  obtain ⟨n, c, sig, hfam, -, hs', -⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul s
  have hnn : ∀ i, c i ≠ 0 → 0 ≤ sig i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hs' hs hci
  have hsq : s * s = ∑ i, (sig i * sig i) • c i := by
    rw [hs']
    exact sum_smul_mul_sum_smul_of_orthIdem hfam sig sig
  rw [jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul (s * s) hfam hsq, hs']
  refine Finset.sum_congr rfl fun i _ => ?_
  by_cases hci : c i = 0
  · rw [hci, smul_zero, smul_zero]
  · rw [Real.sqrt_mul_self (hnn i hci)]

/-- ★★★ **Squaring is injective on the cone** — the positive square root is unique. -/
theorem eq_of_mul_self_eq_of_isSoS {s t : J} (hs : IsSoS (jmulₗ J) s) (ht : IsSoS (jmulₗ J) t)
    (h : s * s = t * t) : s = t := by
  rw [← jsqrt_mul_self_of_isSoS hs, h, jsqrt_mul_self_of_isSoS ht]


/-! ## Continuity of the Jordan product

The Jordan product is a bilinear map between finite-dimensional normed spaces, hence continuous;
the tree had no statement of this, because nothing before needed a topology on `J` beyond the one
its `NormedAddCommGroup` supplies.  The route through `LinearMap.toContinuousLinearMap` is the
short one: it is a *linear equivalence* on a finite-dimensional domain, so composing it with
`jmulₗ` gives a linear map into a normed space, which `LinearMap.continuous_of_finiteDimensional`
makes continuous, and evaluation of continuous linear maps is a bounded bilinear map. -/

theorem continuous_jmul : Continuous (fun p : J × J => p.1 * p.2) := by
  have hB : Continuous (fun x : J => LinearMap.toContinuousLinearMap (jmulₗ J x)) :=
    LinearMap.continuous_of_finiteDimensional
      ((LinearMap.toContinuousLinearMap : (J →ₗ[ℝ] J) ≃ₗ[ℝ] (J →L[ℝ] J)).toLinearMap.comp
        (jmulₗ J))
  exact isBoundedBilinearMap_apply.continuous.comp
    ((hB.comp continuous_fst).prodMk continuous_snd)

theorem _root_.Continuous.jmul {α : Type*} [TopologicalSpace α] {f g : α → J}
    (hf : Continuous f) (hg : Continuous g) : Continuous (fun x => f x * g x) :=
  continuous_jmul.comp (hf.prodMk hg)

theorem continuous_jmul_self : Continuous (fun x : J => x * x) :=
  Continuous.jmul continuous_id continuous_id

/-- `quadJ` is continuous in its first argument. -/
theorem continuous_quadJ_left (b : J) : Continuous (fun v : J => quadJ v b) := by
  have h : (fun v : J => quadJ v b) = fun v : J => (2 : ℝ) • (v * (v * b)) - (v * v) * b := by
    funext v; rw [quadJ_apply]
  rw [h]
  exact ((continuous_id.jmul (continuous_id.jmul continuous_const)).const_smul (2 : ℝ)).sub
    (continuous_jmul_self.jmul continuous_const)


/-! ## Continuity of the Jordan square root, and paper S2 for the Lüders product

★★★ The square root is not given by a formula that could be differentiated or estimated — `jsqrt`
is defined through a *chosen* spectral resolution — so continuity cannot be read off its
definition.  The argument is the classical one and it is exactly why compactness was proved
above: squaring is a continuous bijection of the (compact) effect interval onto itself, and a
continuous bijection from a compact space to a Hausdorff space is a homeomorphism, so its inverse
— the square root — is continuous. -/

/-- Every coefficient of an effect's resolution is at most one, at the idempotents present. -/
theorem resolution_coeff_le_one {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = (1 : J)) {x : J}
    (hx : x = ∑ i, lam i • c i) (hx1 : IsSoS (jmulₗ J) (1 - x)) {k : Fin n} (hk : c k ≠ 0) :
    lam k ≤ 1 := by
  have hrep : (1 : J) - x = ∑ i, (1 - lam i) • c i := by
    rw [hx, ← hsum, ← Finset.sum_sub_distrib]
    exact Finset.sum_congr rfl fun i _ => by rw [sub_smul, one_smul]
  have h := nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
    (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hrep hx1 hk
  linarith

omit [FiniteDimensional ℝ J] in
theorem isSoS_mul_self (x : J) : IsSoS (jmulₗ J) (x * x) :=
  ⟨1, fun _ => x, by simp⟩

/-- The square of an effect is an effect. -/
theorem mul_self_mem_effectSet {x : J} (hx : x ∈ effectSet J) : x * x ∈ effectSet J := by
  classical
  obtain ⟨hx0, hx1⟩ := hx
  obtain ⟨n, c, lam, hfam, hsum, hxr, hinj⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul x
  have hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hxr hx0 hci
  have hle : ∀ i, c i ≠ 0 → lam i ≤ 1 := fun i hci =>
    resolution_coeff_le_one hfam hsum hxr hx1 hci
  refine ⟨isSoS_mul_self x, ?_⟩
  have hsq : x * x = ∑ i, (lam i * lam i) • c i := by
    rw [hxr]; exact sum_smul_mul_sum_smul_of_orthIdem hfam lam lam
  have hrep : (1 : J) - x * x = ∑ i, (1 - lam i * lam i) • c i := by
    rw [hsq, ← hsum, ← Finset.sum_sub_distrib]
    exact Finset.sum_congr rfl fun i _ => by rw [sub_smul, one_smul]
  rw [hrep]
  refine isSoS_sum _ _ fun i _ => ?_
  by_cases hci : c i = 0
  · rw [hci, smul_zero]; exact isSoS_zero
  · exact isSoS_smul_idem (by nlinarith [hnn i hci, hle i hci]) (hfam.idem i)

/-- The square root of an effect is an effect. -/
theorem jsqrt_mem_effectSet {x : J} (hx : x ∈ effectSet J) :
    jsqrt 1 EuclideanJordanAlgebra.one_mul x ∈ effectSet J := by
  classical
  obtain ⟨hx0, hx1⟩ := hx
  obtain ⟨n, c, lam, hfam, hsum, hxr, hinj⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul x
  have hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hxr hx0 hci
  have hle : ∀ i, c i ≠ 0 → lam i ≤ 1 := fun i hci =>
    resolution_coeff_le_one hfam hsum hxr hx1 hci
  rw [jsqrt_eq_of_resolution 1 EuclideanJordanAlgebra.one_mul x hfam hinj hxr]
  constructor
  · refine isSoS_sum _ _ fun i _ => ?_
    exact isSoS_smul_idem (Real.sqrt_nonneg _) (hfam.idem i)
  · have hrep : (1 : J) - ∑ i, Real.sqrt (lam i) • c i
        = ∑ i, (1 - Real.sqrt (lam i)) • c i := by
      rw [← hsum, ← Finset.sum_sub_distrib]
      exact Finset.sum_congr rfl fun i _ => by rw [sub_smul, one_smul]
    rw [hrep]
    refine isSoS_sum _ _ fun i _ => ?_
    by_cases hci : c i = 0
    · rw [hci, smul_zero]; exact isSoS_zero
    · refine isSoS_smul_idem ?_ (hfam.idem i)
      have h1 : Real.sqrt (lam i) ≤ 1 := by
        rw [show (1 : ℝ) = Real.sqrt 1 by simp]
        exact Real.sqrt_le_sqrt (hle i hci)
      linarith

/-- `jsqrt` squares back on the cone. -/
theorem jsqrt_sq_of_isSoS {x : J} (hx : IsSoS (jmulₗ J) x) :
    jsqrt 1 EuclideanJordanAlgebra.one_mul x * jsqrt 1 EuclideanJordanAlgebra.one_mul x = x := by
  obtain ⟨n, c, lam, hfam, -, hxr, hinj⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul x
  exact jsqrt_mul_self' 1 EuclideanJordanAlgebra.one_mul x hfam hinj hxr
    (fun i hci => nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hxr hx hci)

/-- ★★★ **The Jordan square root is continuous on the effect interval.** -/
theorem continuousOn_jsqrt :
    ContinuousOn (jsqrt 1 EuclideanJordanAlgebra.one_mul) (effectSet J) := by
  have : CompactSpace ↥(effectSet J) := isCompact_iff_compactSpace.mp isCompact_effectSet
  set sq : ↥(effectSet J) → ↥(effectSet J) :=
    fun x => ⟨x.1 * x.1, mul_self_mem_effectSet x.2⟩ with hsqdef
  set rt : ↥(effectSet J) → ↥(effectSet J) :=
    fun x => ⟨jsqrt 1 EuclideanJordanAlgebra.one_mul x.1, jsqrt_mem_effectSet x.2⟩ with hrtdef
  have hleft : Function.LeftInverse rt sq := fun x =>
    Subtype.ext (jsqrt_mul_self_of_isSoS x.2.1)
  have hright : Function.RightInverse rt sq := fun x =>
    Subtype.ext (jsqrt_sq_of_isSoS x.2.1)
  have hsqc : Continuous sq :=
    Continuous.subtype_mk (continuous_jmul_self.comp continuous_subtype_val) _
  have hrtc : Continuous rt :=
    (Continuous.homeoOfEquivCompactToT2 (f := (⟨sq, rt, hleft, hright⟩ : _ ≃ _)) hsqc).symm.continuous
  rw [continuousOn_iff_continuous_restrict]
  exact continuous_subtype_val.comp hrtc


/-! ## Paper S2 for the Lüders product

★★★ `def:sp`'s cell recorded that S2 "cannot be a field at abstract generality without an
order-unit norm the tree lacks", and `EJA/Class.lean` carries S1, S3, S4 and S5 for the candidate
product `a · b = Q_{√a} b` with S2 untouched.  This is S2: the map `a ↦ Q_{√a} b` is continuous on
the effects, for every effect `b`. -/

theorem mem_effectSet_iff_isEffect {a : J} :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    a ∈ effectSet J ↔ OrderUnitSpace.IsEffect a := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  constructor
  · rintro ⟨h0, h1⟩
    refine ⟨?_, h1⟩
    show IsSoS (jmulₗ J) (a - 0)
    rwa [sub_zero]
  · rintro ⟨h0, h1⟩
    refine ⟨?_, h1⟩
    have h0' : IsSoS (jmulₗ J) (a - 0) := h0
    rwa [sub_zero] at h0'

theorem effectSet_eq_setOf_isEffect :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    effectSet J = {a : J | OrderUnitSpace.IsEffect a} := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  ext a
  exact mem_effectSet_iff_isEffect

/-- ★★★ **Paper S2 for the Lüders product `a · b = Q_{√a} b`, at EJA generality.**

`a ↦ Q_{√a} b` is continuous on the effect interval — the composition of the square root, whose
continuity is the compactness argument above, with `quadJ` in its first argument, which is a
polynomial map.  ★ The hypothesis on `b` is not used: continuity in the first argument holds for
every `b` whatsoever. -/
theorem luders_continuousOn_fst (b : J) :
    ContinuousOn (fun a : J => quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b)
      (effectSet J) :=
  (continuous_quadJ_left b).comp_continuousOn continuousOn_jsqrt

/-- S2 in the vocabulary of the order-unit instance the sequential-product axioms are stated
over. -/
theorem luders_continuousOn_isEffect (b : J) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ContinuousOn (fun a : J => quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b)
      {a : J | OrderUnitSpace.IsEffect a} := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  rw [← effectSet_eq_setOf_isEffect]
  exact luders_continuousOn_fst b


/-! ## Toward `prop:bridge` at EJA generality: the Peirce defect

★★★ Rows 8, 16 and 21 all wait on S6, S7 and S5's own hypothesis for the Lüders product, and all
three reduce to one implication — the converse half of `prop:bridge` (manifest row 10):

  `Q_{√a} b = Q_{√b} a  ⟹  ⁅L_a, L_b⁆ = 0`.

On the matrix carrier that implication is `Necessity`'s `commute_of_twistSeq_comm`, proved by a
**Frobenius certificate**: expand `tr(C Cᴴ)` for `C = √b·a − a·√b` into four traces, show each
equals `tr(b a²)` — one of them by the hypothesis — so the certificate vanishes and `C = 0`.

★★ **That argument has an EJA transcription, and this section is its first half.**  The four
matrix traces reassemble, in Jordan vocabulary, into the single scalar

  `Φ(v, x) := ⟪v∘v, x∘x⟫ − ‖v∘x‖²`,

and the hypothesis forces `Φ(√b, a) = 0` — that is `luders_comm_peirceDefect_eq_zero` below.
The identity behind it is `⟪Q_v x, x⟫ = 2‖v∘x‖² − ⟪v∘v, x∘x⟫`, which is two applications of
associativity of the trace form and nothing else.

★★★ **What `Φ` is, and why the remaining half is the whole content.**  Writing `v = ∑ μₖ qₖ` for
the spectral resolution and decomposing `x` into Peirce blocks `x_{kl}` of that family,

  `Φ(v, x) = ∑_{k,l} ((μₖ − μₗ)² / 4) ‖x_{kl}‖²`,

because `L_{v∘v} − L_v²` acts on the block `J_{kl}` by `(μₖ² + μₗ²)/2 − μₖμₗ = (μₖ − μₗ)²/2`.  So
`Φ ≥ 0` always, and `Φ = 0` exactly when `x` is Peirce-diagonal for `v`'s spectral idempotents —
which is exactly `⁅L_v, L_x⁆ = 0`.  **That equality case is the open half**; it needs the joint
Peirce decomposition of an orthogonal idempotent family, not just of one idempotent.  It is
recorded here rather than left implicit because the reduction above is the part that was not
obvious, and it is now machine-checked. -/

omit [FiniteDimensional ℝ J] in
/-- `Q_u(u²) = (u²)²`, via the fundamental formula's `quadJ_sq` at the unit. -/
theorem quadJ_self_sq (u : J) : quadJ u (u * u) = (u * u) * (u * u) := by
  have h := quadJ_sq EuclideanJordanAlgebra.one_mul u (1 : J)
  rw [quadJ_unit EuclideanJordanAlgebra.one_mul u,
    quadJ_unit EuclideanJordanAlgebra.one_mul (u * u)] at h
  exact h.symm

omit [FiniteDimensional ℝ J] in
/-- **The pairing identity behind the certificate**: `⟪Q_v x, x⟫ = 2‖v∘x‖² − ⟪v∘v, x∘x⟫`. -/
theorem inner_quadJ_self (v x : J) :
    (inner ℝ (quadJ v x) x : ℝ)
      = 2 * (inner ℝ (v * x) (v * x) : ℝ) - (inner ℝ (v * v) (x * x) : ℝ) := by
  rw [quadJ_apply, inner_sub_left, real_inner_smul_left,
    EuclideanJordanAlgebra.inner_assoc v (v * x) x,
    EuclideanJordanAlgebra.inner_assoc' (v * v) x x]

/-- The **Peirce defect** of a pair: `Φ(v, x) = ⟪v∘v, x∘x⟫ − ‖v∘x‖²`. -/
def peirceDefect (v x : J) : ℝ :=
  (inner ℝ (v * v) (x * x) : ℝ) - (inner ℝ (v * x) (v * x) : ℝ)

/-- ★★★ **Lüders compatibility kills the Peirce defect.**  This is the Frobenius certificate of
the matrix proof, transcribed: the hypothesis is used exactly once, to identify `⟪Q_{√b} a, a⟫`
with `⟪b, a∘a⟫`, and the pairing identity does the rest. -/
theorem luders_comm_peirceDefect_eq_zero {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b)
    (h : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b
       = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a) :
    peirceDefect (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a = 0 := by
  set u := jsqrt 1 EuclideanJordanAlgebra.one_mul a with hudef
  set v := jsqrt 1 EuclideanJordanAlgebra.one_mul b with hvdef
  have hu : u * u = a := jsqrt_sq_of_isSoS ha
  have hv : v * v = b := jsqrt_sq_of_isSoS hb
  have hqa : quadJ u a = a * a := by rw [← hu, quadJ_self_sq u, hu]
  have h1 : (inner ℝ (quadJ v a) a : ℝ) = inner ℝ b (a * a) := by
    rw [← h, quadJ_inner_self_adjoint u b a, hqa]
  have h2 := inner_quadJ_self v a
  rw [h1, hv] at h2
  unfold peirceDefect
  rw [hv]
  linarith


/-! ### The Peirce block projection of a pair of orthogonal idempotents

★★★ The remaining half of the bridge needs `⟪L_p L_q x, x⟫ ≥ 0` for orthogonal idempotents, with
vanishing forcing `L_p L_q x = 0`.  Both follow at once from a fact worth having on its own:

  **`4 L_p L_q` is a self-adjoint idempotent** — the Peirce block projection onto `J_{pq}`.

It needs no block algebra.  `q` annihilates `J₁(p)` (`eigen_one_mul_zero`), and `Q_p` lands in
`J₁(p)` (`mul_peirceOne`), so `L_q Q_p = 0`; since `Q_p = 2L_p² − L_p` for an idempotent, that is
`L_q L_p² = ½ L_q L_p`.  With the same relation in the other order and `⁅L_p, L_q⁆ = 0`
(`opCommute_of_orthogonal`), `(L_pL_q)² = L_p²L_q² = ¼ L_pL_q`.

★ Verified numerically on `H₅(ℂ)` before it was attempted: `‖P² − P‖ ≤ 1.3e-15`, `‖P − Pᵀ‖ ≤
4.4e-16`, and ranks `2|pₖ||pₗ|` on the nose. -/

/-- An orthogonal idempotent annihilates the `1`-eigenspace of the other. -/
theorem mul_peirceOne_eq_zero_of_orth {p q : J} (hp : p * p = p) (hpq : p * q = 0) (w : J) :
    q * peirceOne p w = 0 := by
  rw [mul_comm]
  exact eigen_one_mul_zero hp (mul_peirceOne hp w) hpq

/-- `L_q L_p² = ½ L_q L_p` for orthogonal idempotents — the `Q_p`-annihilation, unpacked. -/
theorem mul_mul_mul_eq_half {p q : J} (hp : p * p = p) (hpq : p * q = 0) (w : J) :
    q * (p * (p * w)) = (2 : ℝ)⁻¹ • (q * (p * w)) := by
  have h := mul_peirceOne_eq_zero_of_orth hp hpq w
  rw [peirceOne_apply, mul_sub, mul_smul_comm] at h
  have h2 : (2 : ℝ) • (q * (p * (p * w))) = q * (p * w) := by
    have := sub_eq_zero.mp h
    linear_combination (norm := module) this
  have h3 := congrArg (fun z : J => (2 : ℝ)⁻¹ • z) h2
  simpa using h3

/-- **`4 L_p L_q` is idempotent** for orthogonal idempotents `p`, `q`. -/
theorem blockProj_idem {p q : J} (hp : p * p = p) (hq : q * q = q) (hpq : p * q = 0) (w : J) :
    p * (q * (p * (q * w))) = (4 : ℝ)⁻¹ • (p * (q * w)) := by
  have hqp : q * p = 0 := by rw [mul_comm]; exact hpq
  have e0 : p * (q * (p * (q * w))) = q * (p * (p * (q * w))) :=
    opCommute_of_orthogonal hp hpq (p * (q * w))
  have e1 : q * (p * (p * (q * w))) = (2 : ℝ)⁻¹ • (q * (p * (q * w))) :=
    mul_mul_mul_eq_half hp hpq (q * w)
  have e2 : q * (p * (q * w)) = p * (q * (q * w)) :=
    (opCommute_of_orthogonal hp hpq (q * w)).symm
  have e3 : p * (q * (q * w)) = (2 : ℝ)⁻¹ • (p * (q * w)) :=
    mul_mul_mul_eq_half hq hqp w
  rw [e0, e1, e2, e3, smul_smul]
  norm_num

/-- The pairing of the block projection is a square: `⟪L_pL_q x, x⟫ = 4‖L_pL_q x‖²`. -/
theorem inner_blockProj_self {p q : J} (hp : p * p = p) (hq : q * q = q) (hpq : p * q = 0)
    (x : J) :
    (inner ℝ (p * (q * x)) x : ℝ) = (4 : ℝ) * (inner ℝ (p * (q * x)) (p * (q * x)) : ℝ) := by
  have h1 : (inner ℝ (p * (q * x)) (p * (q * x)) : ℝ)
      = inner ℝ (p * (q * (p * (q * x)))) x := by
    rw [EuclideanJordanAlgebra.inner_assoc p (q * (p * (q * x))) x,
      EuclideanJordanAlgebra.inner_assoc q (p * (q * x)) (p * x),
      ← opCommute_of_orthogonal hp hpq x]
  rw [h1, blockProj_idem hp hq hpq x, real_inner_smul_left]
  ring

/-- ★★★ **`⟪L_p L_q x, x⟫ ≥ 0` for orthogonal idempotents**, because `4 L_p L_q` is a
self-adjoint idempotent, so the pairing is `4‖L_pL_q x‖²`. -/
theorem inner_blockProj_nonneg {p q : J} (hp : p * p = p) (hq : q * q = q) (hpq : p * q = 0)
    (x : J) : (0 : ℝ) ≤ inner ℝ (p * (q * x)) x := by
  rw [inner_blockProj_self hp hq hpq x]
  have h := real_inner_self_nonneg (x := p * (q * x))
  linarith

/-- ★★★ **The pairing vanishes only when the block component does** — the equality case the
bridge needs. -/
theorem blockProj_eq_zero_of_inner_eq_zero {p q : J} (hp : p * p = p) (hq : q * q = q)
    (hpq : p * q = 0) {x : J} (h : (inner ℝ (p * (q * x)) x : ℝ) = 0) : p * (q * x) = 0 := by
  rw [inner_blockProj_self hp hq hpq x] at h
  have h2 : (inner ℝ (p * (q * x)) (p * (q * x)) : ℝ) = 0 := by linarith
  exact inner_self_eq_zero.mp h2


/-! ### The defect as a positive combination of block pairings

★★★ With `v = ∑ μₖ qₖ` over a complete orthogonal idempotent family, write
`B k l := ⟪qₖ ∘ (qₗ ∘ x), x⟫`.  Then

  `Φ(v, x) = ½ ∑_{k,l} (μₖ − μₗ)² · B k l`,

every `B k l` is `≥ 0` (`inner_blockProj_nonneg` off the diagonal, a square on it), and `B` is
symmetric.  So `Φ = 0` forces `B k l = 0` at every pair with `μₖ ≠ μₗ` — which for a spectral
resolution is every `k ≠ l` — and then `blockProj_eq_zero_of_inner_eq_zero` turns that into
`qₖ ∘ (qₗ ∘ x) = 0`. -/

/-- The block pairing of `x` against a pair of family members. -/
def blockPairing (c : Fin n → J) (x : J) (k l : Fin n) : ℝ :=
  (inner ℝ (c k * (c l * x)) x : ℝ)

omit [FiniteDimensional ℝ J] in
theorem blockPairing_comm {n : ℕ} (c : Fin n → J) (x : J) (k l : Fin n) :
    blockPairing c x k l = blockPairing c x l k := by
  unfold blockPairing
  rw [EuclideanJordanAlgebra.inner_assoc (c k) (c l * x) x,
    EuclideanJordanAlgebra.inner_assoc (c l) (c k * x) x, real_inner_comm]

theorem blockPairing_nonneg {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c) (x : J)
    (k l : Fin n) : 0 ≤ blockPairing c x k l := by
  unfold blockPairing
  by_cases hkl : k = l
  · subst hkl
    rw [EuclideanJordanAlgebra.inner_assoc (c k) (c k * x) x]
    exact real_inner_self_nonneg
  · exact inner_blockProj_nonneg (hfam.idem k) (hfam.idem l) (hfam.orth k l hkl) x

omit [FiniteDimensional ℝ J] in
/-- Summing a block pairing over its second index recovers the single-idempotent pairing. -/
theorem sum_blockPairing {n : ℕ} {c : Fin n → J} (hsum : (∑ i, c i) = (1 : J)) (x : J)
    (k : Fin n) : (∑ l, blockPairing c x k l) = (inner ℝ (c k * x) x : ℝ) := by
  unfold blockPairing
  rw [← sum_inner]
  congr 1
  rw [← Finset.mul_sum, ← Finset.sum_mul, hsum, EuclideanJordanAlgebra.one_mul]

omit [FiniteDimensional ℝ J] in
/-- `⟪v∘v, x∘x⟫` in block pairings. -/
theorem inner_sq_eq_sum_blockPairing {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = (1 : J)) {v : J}
    (hv : v = ∑ i, lam i • c i) (x : J) :
    (inner ℝ (v * v) (x * x) : ℝ)
      = ∑ k, ∑ l, (lam k * lam k) * blockPairing c x k l := by
  have hvv : v * v = ∑ i, (lam i * lam i) • c i := by
    rw [hv]; exact sum_smul_mul_sum_smul_of_orthIdem hfam lam lam
  rw [hvv, sum_inner]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [real_inner_smul_left, ← Finset.mul_sum, sum_blockPairing hsum x k]
  congr 1
  exact (EuclideanJordanAlgebra.inner_assoc' (c k) x x).symm

omit [FiniteDimensional ℝ J] in
/-- `‖v∘x‖²` in block pairings. -/
theorem inner_mul_self_eq_sum_blockPairing {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    {v : J} (hv : v = ∑ i, lam i • c i) (x : J) :
    (inner ℝ (v * x) (v * x) : ℝ)
      = ∑ k, ∑ l, (lam k * lam l) * blockPairing c x k l := by
  have hvx : v * x = ∑ i, lam i • (c i * x) := by
    rw [hv, Finset.sum_mul]
    exact Finset.sum_congr rfl fun i _ => smul_mul_assoc (lam i) (c i) x
  rw [hvx, sum_inner]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [real_inner_smul_left, inner_sum, Finset.mul_sum]
  refine Finset.sum_congr rfl fun l _ => ?_
  rw [real_inner_smul_right]
  unfold blockPairing
  rw [EuclideanJordanAlgebra.inner_assoc (c k) x (c l * x), real_inner_comm,
    EuclideanJordanAlgebra.inner_assoc (c k) (c l * x) x]
  ring


omit [FiniteDimensional ℝ J] in
/-- ★★★ **The defect as a manifestly nonnegative sum**: `2Φ = ∑_{k,l} (μₖ − μₗ)² B k l`. -/
theorem two_peirceDefect_eq_sum {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = (1 : J)) {v : J}
    (hv : v = ∑ i, lam i • c i) (x : J) :
    2 * peirceDefect v x
      = ∑ k, ∑ l, (lam k - lam l) ^ 2 * blockPairing c x k l := by
  have hswap : (∑ k, ∑ l, (lam l * lam l) * blockPairing c x k l)
      = ∑ k, ∑ l, (lam k * lam k) * blockPairing c x k l := by
    rw [Finset.sum_comm]
    exact Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun b _ => by
      rw [blockPairing_comm c x b a]
  have hsplit : (∑ k, ∑ l, (lam k - lam l) ^ 2 * blockPairing c x k l)
      = ((∑ k, ∑ l, (lam k * lam k) * blockPairing c x k l)
          - ∑ k, ∑ l, (lam k * lam l) * blockPairing c x k l)
        + ((∑ k, ∑ l, (lam l * lam l) * blockPairing c x k l)
          - ∑ k, ∑ l, (lam k * lam l) * blockPairing c x k l) := by
    rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun l _ => by ring
  rw [hsplit, hswap]
  unfold peirceDefect
  rw [inner_sq_eq_sum_blockPairing hfam hsum hv x, inner_mul_self_eq_sum_blockPairing hv x]
  ring

/-- ★★★ **(B), the equality case.**  If the Peirce defect vanishes, then `x` is annihilated by
every off-diagonal block projection of the resolution. -/
theorem blockPairing_eq_zero_of_peirceDefect {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = (1 : J)) {v : J}
    (hv : v = ∑ i, lam i • c i) {x : J} (hzero : peirceDefect v x = 0)
    {k l : Fin n} (hkl : lam k ≠ lam l) : c k * (c l * x) = 0 := by
  have hne : k ≠ l := fun h => hkl (by rw [h])
  have hsum0 : (∑ k', ∑ l', (lam k' - lam l') ^ 2 * blockPairing c x k' l') = 0 := by
    rw [← two_peirceDefect_eq_sum hfam hsum hv x, hzero]; ring
  have hterm_nonneg : ∀ k' ∈ (Finset.univ : Finset (Fin n)),
      0 ≤ ∑ l', (lam k' - lam l') ^ 2 * blockPairing c x k' l' := fun k' _ =>
    Finset.sum_nonneg fun l' _ =>
      mul_nonneg (sq_nonneg _) (blockPairing_nonneg hfam x k' l')
  have hrow : (∑ l', (lam k - lam l') ^ 2 * blockPairing c x k l') = 0 :=
    (Finset.sum_eq_zero_iff_of_nonneg hterm_nonneg).mp hsum0 k (Finset.mem_univ k)
  have hcell : (lam k - lam l) ^ 2 * blockPairing c x k l = 0 :=
    (Finset.sum_eq_zero_iff_of_nonneg
      (fun l' _ => mul_nonneg (sq_nonneg _) (blockPairing_nonneg hfam x k l'))).mp hrow l
      (Finset.mem_univ l)
  have hsqpos : (lam k - lam l) ^ 2 ≠ 0 := pow_ne_zero 2 (sub_ne_zero.mpr hkl)
  have hB : blockPairing c x k l = 0 := by
    rcases mul_eq_zero.mp hcell with h | h
    · exact absurd h hsqpos
    · exact h
  exact blockProj_eq_zero_of_inner_eq_zero (hfam.idem k) (hfam.idem l) (hfam.orth k l hne) hB


/-- ★★ **`⟪v∘v, x∘x⟫ ≥ ‖v∘x‖²` in any Euclidean Jordan algebra** — a Cauchy–Schwarz-shaped
inequality that appears to be new here, and the sign half of the defect analysis. -/
theorem peirceDefect_nonneg {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = (1 : J)) {v : J}
    (hv : v = ∑ i, lam i • c i) (x : J) : 0 ≤ peirceDefect v x := by
  have h := two_peirceDefect_eq_sum hfam hsum hv x
  have hnn : 0 ≤ ∑ k, ∑ l, (lam k - lam l) ^ 2 * blockPairing c x k l :=
    Finset.sum_nonneg fun k _ => Finset.sum_nonneg fun l _ =>
      mul_nonneg (sq_nonneg _) (blockPairing_nonneg hfam x k l)
  linarith

/-- ★★★ **`prop:bridge`, the converse, analytic half complete.**

Lüders compatibility `Q_{√a} b = Q_{√b} a` forces `a` to be annihilated by every off-diagonal
block projection of `√b`'s spectral resolution — i.e. **`a` is Peirce-diagonal for `b`'s spectral
family**, which is the content of operator commutation.

★ This is the composition of the two halves: `luders_comm_peirceDefect_eq_zero` (the Frobenius
certificate) and `blockPairing_eq_zero_of_peirceDefect` (the block-projection equality case).
What remains between here and `⁅L_a, L_b⁆ = 0` is the structural passage from "Peirce-diagonal"
to a shared resolution, which is what S5–S7 consume anyway. -/
theorem luders_comm_blockDiagonal {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b)
    (h : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b
       = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a)
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hsum : (∑ i, c i) = (1 : J))
    (hv : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ i, lam i • c i)
    {k l : Fin n} (hkl : lam k ≠ lam l) : c k * (c l * a) = 0 :=
  blockPairing_eq_zero_of_peirceDefect hfam hsum hv
    (luders_comm_peirceDefect_eq_zero ha hb h) hkl


/-! ### From block-diagonality to the vanishing of the Peirce half-part

★★★ `c k ∘ (c l ∘ a) = 0` for every `l ≠ k` sums, over the completeness relation `∑ c l = 1`, to
`c k ∘ a = c k ∘ (c k ∘ a)` — that is, `L_{c k}` and `L_{c k}²` agree on `a`.  Since `L_{c k}` has
eigenvalues `0, ½, 1`, that forces the `½`-component to vanish: `peirceHalf (c k) a = 0`.  This is
the usable form of "`a` is Peirce-diagonal", and it is one lemma away from a shared resolution of
`a` and `b`, which is what S5–S7 actually consume. -/

omit [FiniteDimensional ℝ J] in
theorem mul_eq_mul_mul_of_blockDiagonal {n : ℕ} {c : Fin n → J} (hsum : (∑ i, c i) = (1 : J))
    {a : J} {k : Fin n} (hoff : ∀ l, l ≠ k → c k * (c l * a) = 0) :
    c k * a = c k * (c k * a) := by
  classical
  have ha : a = ∑ l, c l * a := by
    rw [← Finset.sum_mul, hsum, EuclideanJordanAlgebra.one_mul]
  calc c k * a = c k * ∑ l, c l * a := by rw [← ha]
    _ = ∑ l, c k * (c l * a) := by rw [Finset.mul_sum]
    _ = c k * (c k * a) := by
        rw [Finset.sum_eq_single k (fun l _ hl => hoff l hl) (fun hk => absurd (Finset.mem_univ k) hk)]

omit [FiniteDimensional ℝ J] in
/-- ★★★ **The Peirce half-part vanishes**: `a` sits in `J₁(cₖ) ⊕ J₀(cₖ)` for every member of the
resolution. -/
theorem peirceHalf_eq_zero_of_blockDiagonal {n : ℕ} {c : Fin n → J}
    (hsum : (∑ i, c i) = (1 : J)) {a : J} {k : Fin n}
    (hoff : ∀ l, l ≠ k → c k * (c l * a) = 0) : peirceHalf (c k) a = 0 := by
  rw [peirceHalf_apply]
  nth_rewrite 1 [mul_eq_mul_mul_of_blockDiagonal hsum hoff]
  rw [sub_self]

/-- ★★★ **`prop:bridge`, converse: Lüders compatibility puts `a` in the Peirce-diagonal part of
`b`'s spectral resolution.**  The `½`-part of `a` vanishes at every spectral idempotent of `b`. -/
theorem luders_comm_peirceHalf_eq_zero {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b)
    (h : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b
       = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a)
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hsum : (∑ i, c i) = (1 : J)) (hinj : Function.Injective lam)
    (hv : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ i, lam i • c i)
    (k : Fin n) : peirceHalf (c k) a = 0 := by
  refine peirceHalf_eq_zero_of_blockDiagonal hsum fun l hl => ?_
  exact luders_comm_blockDiagonal ha hb h hfam hsum hv (fun hEq => hl (hinj hEq).symm)


/-! ### `prop:bridge`, the converse, at EJA generality

★★★ The vanishing half-part is already operator commutation.  If `peirceHalf c a = 0` then
`a = P₁(c)a + P₀(c)a`, and `c` operator-commutes with each summand — with the `1`-part by
`mul_comm_of_eigen_one`, with the `0`-part by `mul_comm_of_eigen_zero` — so with `a` by
linearity.  Summing against the resolution transfers it from each `cₖ` to any element resolved
by that family, and `b` and `√b` are both such elements. -/

omit [FiniteDimensional ℝ J] in
/-- **An element with no Peirce half-part operator-commutes with the idempotent.** -/
theorem opCommute_of_peirceHalf_eq_zero {c a : J} (hc : c * c = c)
    (hhalf : peirceHalf c a = 0) (w : J) : c * (a * w) = a * (c * w) := by
  have hdec : peirceOne c a + peirceZero c a = a := by
    have h := peirce_add_add' c a
    rw [hhalf, add_zero] at h
    exact h
  have h1 := mul_comm_of_eigen_one hc (mul_peirceOne hc a) w
  have h0 := mul_comm_of_eigen_zero hc (mul_peirceZero hc a) w
  calc c * (a * w) = c * ((peirceOne c a + peirceZero c a) * w) := by rw [hdec]
    _ = c * (peirceOne c a * w) + c * (peirceZero c a * w) := by rw [add_mul, mul_add]
    _ = peirceOne c a * (c * w) + peirceZero c a * (c * w) := by rw [h1, h0]
    _ = a * (c * w) := by rw [← add_mul, hdec]

omit [FiniteDimensional ℝ J] in
/-- **Transfer along a resolution**: anything with no half-part at every member of the family
operator-commutes with every element the family resolves. -/
theorem opCommute_of_resolution {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} {v a : J}
    (hfam : IsOrthIdemFamily c) (hv : v = ∑ i, lam i • c i)
    (hhalf : ∀ k, peirceHalf (c k) a = 0) (w : J) : v * (a * w) = a * (v * w) := by
  rw [hv, Finset.sum_mul, Finset.sum_mul, Finset.mul_sum]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [smul_mul_assoc, smul_mul_assoc, mul_smul_comm,
    opCommute_of_peirceHalf_eq_zero (hfam.idem k) (hhalf k) w]

/-- ★★★ **`prop:bridge`, the converse direction, at EJA generality.**

`Q_{√a} b = Q_{√b} a  ⟹  ⁅L_a, L_b⁆ = 0`.

This is the implication the article's row 10 records as unproved, the one the matrix carrier gets
from `commute_of_twistSeq_comm`, and the one S5, S6 and S7 for the Lüders product all reduce to.
The route, all of it in this file: the Frobenius certificate kills the Peirce defect
(`luders_comm_peirceDefect_eq_zero`); the block-projection identity `4L_pL_q` idempotent turns
that into block-diagonality (`blockPairing_eq_zero_of_peirceDefect`); block-diagonality is the
vanishing of the half-part (`peirceHalf_eq_zero_of_blockDiagonal`); and a vanishing half-part *is*
operator commutation (`opCommute_of_peirceHalf_eq_zero`). -/
theorem opCommute_of_luders_comm {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b)
    (h : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b
       = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a) (w : J) :
    b * (a * w) = a * (b * w) := by
  classical
  obtain ⟨n, c, lam, hfam, hsum, hv, hinj⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul
      (jsqrt 1 EuclideanJordanAlgebra.one_mul b)
  have hhalf : ∀ k, peirceHalf (c k) a = 0 := fun k =>
    luders_comm_peirceHalf_eq_zero ha hb h hfam hsum hinj hv k
  have hbres : b = ∑ i, (lam i * lam i) • c i := by
    rw [← jsqrt_sq_of_isSoS hb, hv]
    exact sum_smul_mul_sum_smul_of_orthIdem hfam lam lam
  exact opCommute_of_resolution hfam hbres hhalf w


/-- ★★★ **`prop:bridge`, the forward direction, at EJA generality.**

Operator commutation gives a simultaneous resolution, on which both orders of the Lüders product
are the same diagonal `∑ λₖμₖ qₖ`.  ★ The coefficients are trimmed to `0` at absent idempotents
before `luders_of_resolution` is applied, because a *simultaneous* resolution need not have
nonnegative coefficients where its idempotents vanish — only where they do not. -/
theorem luders_comm_of_opCommute {a b : J} (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b)
    (hab : ∀ w, a * (b * w) = b * (a * w)) :
    quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b
      = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a := by
  classical
  obtain ⟨N, q, la, mu, hfam, hsum, hae, hbe⟩ :=
    exists_simultaneous_resolution 1 EuclideanJordanAlgebra.one_mul hab
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
  have hae' : a = ∑ k, la' k • q k := htrim la a hae
  have hbe' : b = ∑ k, mu' k • q k := htrim mu b hbe
  have hnna : ∀ k, 0 ≤ la' k := by
    intro k
    by_cases h : q k = 0
    · rw [hla'def]; simp [h]
    · rw [hla'def]
      simp only [if_neg h]
      exact nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
        (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hae ha h
  have hnnb : ∀ k, 0 ≤ mu' k := by
    intro k
    by_cases h : q k = 0
    · rw [hmu'def]; simp [h]
    · rw [hmu'def]
      simp only [if_neg h]
      exact nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
        (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hbe hb h
  have hsqa : jsqrt 1 EuclideanJordanAlgebra.one_mul a = jsqrtOfResolution q la' :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul a hfam hae'
  have hsqb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = jsqrtOfResolution q mu' :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hbe'
  rw [hsqa, hsqb]
  conv_lhs => rw [hbe']
  conv_rhs => rw [hae']
  rw [luders_of_resolution hfam hnna mu', luders_of_resolution hfam hnnb la']
  exact Finset.sum_congr rfl fun k _ => by rw [mul_comm]

/-- ★★★ **`prop:bridge`'s standard-product leg, as an equivalence, at EJA generality.**

For cone elements of a finite-dimensional Euclidean Jordan algebra,

  `Q_{√a} b = Q_{√b} a  ↔  ⁅L_a, L_b⁆ = 0`,

i.e. **standard-product compatibility is exactly Jordan operator commutation**.  This is the leg
every one of the article's eight `prop:bridge` citations actually consumes, and the direction the
row recorded as unproved is the `→`. -/
theorem luders_comm_iff_opCommute {a b : J} (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b) :
    (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b
        = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a)
      ↔ ∀ w : J, a * (b * w) = b * (a * w) :=
  ⟨fun h w => (opCommute_of_luders_comm ha hb h w).symm,
   fun hab => luders_comm_of_opCommute ha hb hab⟩

end RadicalRelativity.EJA
