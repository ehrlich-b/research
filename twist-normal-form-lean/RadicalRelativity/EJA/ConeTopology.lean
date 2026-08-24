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

end RadicalRelativity.EJA
