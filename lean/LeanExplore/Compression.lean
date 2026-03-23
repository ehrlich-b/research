/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import LeanExplore.SequentialProduct
import Mathlib.Algebra.BigOperators.Fin

set_option linter.style.longLine false

/-!
# Compressions

A **compression** `C_p` for a sharp effect `p` in a sequential product space
is the map `C_p(a) = p & a`. Compressions encode the Alfsen-Shultz projection
structure and are the mechanism through which the sequential product on
general effects is built from the product on sharp effects.

## Main definitions

* `compression` — the map `C_p(a) = p & a` for sharp (idempotent) `p`
* Properties C1-C6 of compressions derived from the sequential product axioms

## References

* Alfsen-Shultz, Geometry of State Spaces of Operator Algebras
* van de Wetering, arXiv:1803.11139
-/

noncomputable section

open OrderUnitSpace SequentialProduct

namespace Compression

variable {V : Type*} [SequentialProduct V]

/-- The compression map associated to a sharp effect p: C_p(a) = p & a. -/
def compress (p : V) : V → V := fun a => p & a

scoped notation "C[" p "]" => compress p

-- C1: Positivity — C_p maps effects to effects
theorem compress_effect {p a : V} (hp : IsIdempotent p) (ha : IsEffect a) :
    IsEffect (C[p] a) :=
  sp_effect hp.1 ha

-- C2: Idempotence — C_p(C_p(a)) = C_p(a) for sharp p
theorem compress_idem {p a : V} (hp : IsIdempotent p) (ha : IsEffect a) :
    C[p] (C[p] a) = C[p] a := by
  unfold compress
  -- p & (p & a) = (p & p) & a by S5 (p is compatible with itself)
  rw [sp_assoc_of_compatible hp.1 hp.1 ha rfl]
  -- (p & p) & a = p & a since p & p = p
  rw [hp.2]

-- C3: Unit map — C_p(𝟙) = p
theorem compress_unit {p : V} (hp : IsIdempotent p) :
    C[p] (𝟙 : V) = p := by
  unfold compress
  exact sp_unit_right hp.1

-- C6: Orthogonality — C_p(q) = 0 when p ⊥ q (i.e. p + q ≤ 𝟙)
theorem compress_orthogonal {p q : V} (_hp : IsIdempotent p) (_hq : IsIdempotent q)
    (horth : p & q = 0) : C[p] q = 0 := horth

/-- Compression is bounded by the sharp effect: C_p(x) ≤ p.
    (Note: C_p(x) ≤ x does NOT hold in general for non-commutative SPSs.) -/
theorem compress_le_left {p x : V} (hp : IsIdempotent p) (hx : IsEffect x) :
    C[p] x ≤ p := by
  unfold compress
  exact sp_le_left hp.1 hx

/-- C_p(x - C_p(x)) = 0: compression is idempotent on general elements.

    TRUE for the Lüders product: p(x - pxp)p = pxp - p²xp² = pxp - pxp = 0.

    NOT PROVABLE from S1-S7 alone. The proof requires linearity of L_p on all
    of V (not just effects). Van de Wetering (Prop 2.2) extends L_p from effects
    to all of V using S2 (continuity), which our axiom system replaces with
    sp_mono_right. The obstruction:
    - sp_sub_right gives p & (b - c) = p & b - p & c, but requires c ≤ b AND
      IsEffect (b - c).
    - Here b = x and c = p & x. We have p & x ≤ p (sp_le_left) but NOT
      p & x ≤ x in general (counterexample: p = |0⟩⟨0|, x = |+⟩⟨+| gives
      x - pxp with a negative eigenvalue). So x - p & x is not an effect.
    - The sequential product is NOT commutative, so x & p ≤ x (which holds
      via sp_mono_right + sp_unit_right) does NOT give p & x ≤ x. -/
theorem compress_sub_self {p x : V} (hp : IsIdempotent p) (hx : IsEffect x) :
    C[p] (x - C[p] x) = 0 := by
  unfold compress
  rw [sp_sub_right_general hp.1 hx (sp_effect hp.1 hx)]
  -- p & x - p & (p & x) = p & x - (p & p) & x = p & x - p & x = 0
  rw [sp_assoc_of_compatible hp.1 hp.1 hx rfl, hp.2]
  exact sub_self _

/-- Compression distributes over subtraction: C_p(b - c) = C_p(b) - C_p(c)
    when c ≤ b and both are effects. -/
theorem compress_sub {p b c : V} (hp : IsIdempotent p) (hb : IsEffect b)
    (hc : IsEffect c) (hle : c ≤ b) (hbc_eff : IsEffect (b - c)) :
    C[p] (b - c) = C[p] b - C[p] c := by
  unfold compress
  exact sp_sub_right hp.1 hb hc hle hbc_eff

/-- For orthogonal idempotents p, q, C_p(x - C_q(x)) = C_p(x).

    NOT PROVABLE from S1-S7 alone — same obstruction as compress_sub_self.
    Requires p & (x - q & x) = p & x - p & (q & x), which needs linearity of
    L_p on non-effects (x - q & x is not generally an effect). Then the second
    term p & (q & x) = (p & q) & x = 0 & x = 0 by S5 + orthogonality, giving
    the result. But the first step (linearity) requires continuity (S2). -/
theorem compress_sub_orthogonal_compress {p q x : V}
    (hp : IsIdempotent p) (hq : IsIdempotent q)
    (horth : p & q = 0) (hx : IsEffect x) :
    C[p] (x - C[q] x) = C[p] x := by
  unfold compress
  rw [sp_sub_right_general hp.1 hx (sp_effect hq.1 hx)]
  -- p & x - p & (q & x). By S5: p & (q & x) = (p & q) & x = 0 & x = 0.
  have hcompat : p & q = q & p := by
    rw [horth]; exact (sp_zero_symm hp.1 hq.1 horth).symm
  rw [sp_assoc_of_compatible hp.1 hq.1 hx hcompat, horth, sp_zero_left hx]
  exact sub_zero _

-- NOTE: compress_orthogonal_sum_le (C_p(x) + C_q(x) ≤ x) and
-- isEffect_sub_compress_compress are FALSE for non-commutative SPSs.
-- Counterexample: p = projUp, x = projPlus in V₃ gives
-- x - pxp - qxq = [[0,b],[b,0]] which has eigenvalue -b < 0.

/-- Two sharp effects are orthogonal if p & q = 0. -/
def SharpOrthogonal (p q : V) : Prop :=
  IsIdempotent p ∧ IsIdempotent q ∧ p & q = 0

/-- Orthogonality of sharp effects is symmetric (by S4). -/
theorem sharp_orthogonal_symm {p q : V} (h : SharpOrthogonal p q) :
    SharpOrthogonal q p := by
  exact ⟨h.2.1, h.1, sp_zero_symm h.1.1 h.2.1.1 h.2.2⟩

/-- A spectral decomposition of an effect a is a finite collection of
    mutually orthogonal sharp effects pᵢ with coefficients λᵢ ∈ [0,1]
    such that a = Σᵢ λᵢ pᵢ and Σᵢ pᵢ = 𝟙. -/
structure SpectralDecomp (V : Type*) [SequentialProduct V] where
  /-- Number of spectral components. -/
  n : ℕ
  /-- The sharp effects (projective units). -/
  proj : Fin n → V
  /-- The eigenvalues. -/
  eigenval : Fin n → ℝ
  /-- Each projection is sharp (idempotent). -/
  proj_idempotent : ∀ i, IsIdempotent (proj i)
  /-- Eigenvalues are in [0,1]. -/
  eigenval_bound : ∀ i, 0 ≤ eigenval i ∧ eigenval i ≤ 1
  /-- Projections are mutually orthogonal. -/
  proj_orthogonal : ∀ i j, i ≠ j → (proj i) & (proj j) = 0
  /-- Projections sum to the unit (resolution of unity). -/
  proj_sum_unit : (∑ i : Fin n, proj i) = ousUnit

/-- The effect reconstructed from a spectral decomposition:
    `a = Σᵢ λᵢ · pᵢ`. -/
def SpectralDecomp.reconstruct {V : Type*} [SequentialProduct V]
    (sd : SpectralDecomp V) : V :=
  ∑ i : Fin sd.n, sd.eigenval i • sd.proj i

end Compression
