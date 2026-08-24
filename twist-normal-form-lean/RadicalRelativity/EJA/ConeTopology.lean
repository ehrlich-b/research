/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.PseudoTransfer

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
    simp only [Set.mem_setOf_eq, Set.mem_iInter₂]
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

end RadicalRelativity.EJA
