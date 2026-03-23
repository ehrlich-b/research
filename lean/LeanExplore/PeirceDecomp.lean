/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import LeanExplore.Compression
import Mathlib.Tactic.Abel

set_option linter.style.longLine false

/-!
# Peirce Decomposition

The **Peirce decomposition** associated to a sharp effect (projective unit) `p`
decomposes the order unit space into three subspaces:

* `V₂(p)` — the Peirce 2-space, the range of the compression `C_p`
* `V₀(p)` — the Peirce 0-space, the range of the complementary compression `C_{p⊥}`
* `V₁(p,q)` — the Peirce 1-space (off-diagonal), elements not fixed by either

For orthogonal sharp effects `p, q` with `p + q = 𝟙`, every element decomposes
as `x = C_p(x) + C_q(x) + P₁(x)`.

## Main definitions

* `PeirceTwo` — the Peirce 2-space V₂(p)
* `PeirceZero` — the Peirce 0-space V₀(p)
* `PeirceOne` — the Peirce 1-space V₁(p,q)
* `peirceOneProj` — the Peirce 1-space projection P₁(x) = x - C_p(x) - C_q(x)

## Main results

* `peirceTwo_char` — x ∈ V₂(p) ↔ p & x = x
* `compress_comm_of_compatible` — compatible compressions commute
* `peirce_decomp` — Peirce direct sum decomposition

## References

* Alfsen-Shultz, Geometry of State Spaces of Operator Algebras
* van de Wetering, arXiv:1803.11139
-/

noncomputable section

open OrderUnitSpace SequentialProduct Compression

namespace PeirceDecomp

variable {V : Type*} [SequentialProduct V]

/-! ## Peirce subspaces -/

/-- The **Peirce 2-space** V₂(p): the set of effects fixed by compression C_p.
    V₂(p) = {x : V | C_p(x) = x} = range(C_p). -/
def PeirceTwo (p : V) : Set V :=
  {x : V | C[p] x = x}

/-- The **Peirce 0-space** V₀(p): the set of effects fixed by the complementary
    compression C_{𝟙 - p}. Equivalently, V₀(p) = V₂(𝟙 - p). -/
def PeirceZero (p : V) : Set V :=
  PeirceTwo (𝟙 - p)

/-- The **Peirce 1-space** V₁(p,q) for orthogonal sharp effects p, q:
    the off-diagonal subspace of elements annihilated by both C_p and C_q. -/
def PeirceOne (p q : V) : Set V :=
  {x : V | C[p] x = 0 ∧ C[q] x = 0}

/-- The **Peirce 1-space projection**: P₁(x) = x - C_p(x) - C_q(x). -/
def peirceOneProj (p q : V) (x : V) : V :=
  x - C[p] x - C[q] x

/-! ## Peirce 2-space characterization -/

/-- Characterization of the Peirce 2-space: x ∈ V₂(p) ↔ p & x = x.
    This is immediate from the definition of compression. -/
theorem peirceTwo_char (p x : V) : x ∈ PeirceTwo p ↔ C[p] x = x := by
  rfl

/-- Sharp effects live in their own Peirce 2-space: p ∈ V₂(p). -/
theorem sharp_mem_peirceTwo {p : V} (hp : IsIdempotent p) :
    p ∈ PeirceTwo p := by
  rw [peirceTwo_char]
  unfold compress
  exact hp.2

/-- The unit compressed by p gives p (already in Compression, restated for convenience). -/
theorem compress_unit_eq {p : V} (hp : IsIdempotent p) :
    C[p] (𝟙 : V) = p :=
  compress_unit hp

/-- Zero is in every Peirce 2-space. -/
theorem zero_mem_peirceTwo (p : V) (hp : IsEffect p) :
    (0 : V) ∈ PeirceTwo p := by
  rw [peirceTwo_char]
  unfold compress
  exact sp_zero_right hp

/-- If x ∈ V₂(p) with p sharp, then C_p(x) = x (tautology, but useful as a rewrite). -/
theorem peirceTwo_compress_eq {p x : V} (hx : x ∈ PeirceTwo p) :
    C[p] x = x :=
  hx

/-! ## Compression commutativity for compatible projections -/

/-- **Compression commutativity**: if p and q are compatible sharp effects
    (p & q = q & p), then C_p ∘ C_q = C_q ∘ C_p.

    Proof: By S5 (associativity for compatible effects),
    C_p(C_q(x)) = p & (q & x) = (p & q) & x (since p|q)
    and C_q(C_p(x)) = q & (p & x) = (q & p) & x (since q|p).
    Since p & q = q & p, these are equal. -/
theorem compress_comm_of_compatible {p q : V}
    (hp : IsIdempotent p) (hq : IsIdempotent q) (hcompat : p & q = q & p)
    {x : V} (hx : IsEffect x) :
    C[p] (C[q] x) = C[q] (C[p] x) := by
  unfold compress
  rw [sp_assoc_of_compatible hp.1 hq.1 hx hcompat]
  rw [sp_assoc_of_compatible hq.1 hp.1 hx hcompat.symm]
  rw [hcompat]

/-! ## Peirce direct sum decomposition -/

/-- **Peirce decomposition**: for orthogonal sharp effects p, q with p + q = 𝟙,
    every element x decomposes as C_p(x) + C_q(x) + P₁(x).

    This is a tautology by definition of P₁, but it records the key structural fact
    that the three Peirce components sum to x. -/
theorem peirce_decomp {p q : V} (_hp : IsIdempotent p) (_hq : IsIdempotent q)
    (_hsum : p + q = (𝟙 : V)) (x : V) :
    C[p] x + C[q] x + peirceOneProj p q x = x := by
  unfold peirceOneProj
  abel

/-- **Compression annihilation**: for orthogonal sharp effects p, q
    (meaning p & q = 0), C_p(C_q(x)) = 0 for any effect x.

    Proof: p & (q & x) = (p & q) & x = 0 & x = 0 by S5 + orthogonality. -/
theorem compress_orthogonal_annihilate {p q : V}
    (hp : IsIdempotent p) (hq : IsIdempotent q)
    (horth : p & q = 0) {x : V} (hx : IsEffect x) :
    C[p] (C[q] x) = 0 := by
  unfold compress
  -- Need: p & (q & x) = 0
  -- Step 1: p|q since p & q = q & p (= 0)
  have hcompat : p & q = q & p := by
    rw [horth, sp_zero_symm hp.1 hq.1 horth]
  -- Step 2: p & (q & x) = (p & q) & x by S5
  rw [sp_assoc_of_compatible hp.1 hq.1 hx hcompat]
  -- Step 3: (p & q) & x = 0 & x = 0
  rw [horth]
  exact sp_zero_left hx

/-- The Peirce 1-projection lands in the Peirce 1-space for orthogonal
    sharp effects: C_p(P₁(x)) = 0 and C_q(P₁(x)) = 0.

    NOTE: The proof requires linearity of compression on general elements
    (not just effects). In the Lüders product, P₁(x) = px(1-p) + (1-p)xp
    is NOT an effect for non-commuting p, x. The full proof goes through the
    Jordan algebra structure (van de Wetering Theorem 1). -/
theorem peirceOneProj_mem_peirceOne {p q : V}
    (hp : IsIdempotent p) (hq : IsIdempotent q)
    (horth : SharpOrthogonal p q) (hsum : p + q = (𝟙 : V))
    (x : V) (hx : IsEffect x) :
    peirceOneProj p q x ∈ PeirceOne p q := by
  have hpq : p & q = 0 := horth.2.2
  have hqp : q & p = 0 := sp_zero_symm hp.1 hq.1 hpq
  -- Key: p & x + q & x is an effect (both ≤ their projection, projections sum to 1)
  have hpx_eff := sp_effect hp.1 hx
  have hqx_eff := sp_effect hq.1 hx
  have hsum_le : p & x + q & x ≤ ousUnit := by
    have h1 := sp_le_left hp.1 hx  -- p & x ≤ p
    have h2 := sp_le_left hq.1 hx  -- q & x ≤ q
    have h3 := add_le_add_right' h1 (q & x)  -- p & x + q & x ≤ p + q & x
    have h4 := OrderUnitSpace.add_le_add_left _ _ h2 p  -- p + q & x ≤ p + q
    rw [hsum] at h4; exact le_trans h3 h4
  have hsum_eff : IsEffect (p & x + q & x) :=
    ⟨OrderUnitSpace.add_nonneg hpx_eff.1 hqx_eff.1, hsum_le⟩
  constructor
  · show C[p] (peirceOneProj p q x) = 0
    unfold peirceOneProj compress
    -- Goal: p & (x - p & x - q & x) = 0
    -- Rewrite arg as x - (p & x + q & x)
    have heq : x - p & x - q & x = x - (p & x + q & x) := by abel
    rw [heq, sp_sub_right_general hp.1 hx hsum_eff,
        sp_add_right hp.1 hpx_eff hqx_eff hsum_le]
    have h1 : p & (p & x) = p & x :=
      by rw [sp_assoc_of_compatible hp.1 hp.1 hx rfl, hp.2]
    have h2 : p & (q & x) = (0 : V) := by
      have hcompat : p & q = q & p := by rw [hpq]; exact hqp.symm
      rw [sp_assoc_of_compatible hp.1 hq.1 hx hcompat, hpq, sp_zero_left hx]
    rw [h1, h2, add_zero, sub_self]
  · show C[q] (peirceOneProj p q x) = 0
    unfold peirceOneProj compress
    have heq : x - p & x - q & x = x - (p & x + q & x) := by abel
    rw [heq, sp_sub_right_general hq.1 hx hsum_eff,
        sp_add_right hq.1 hpx_eff hqx_eff hsum_le]
    have h1 : q & (p & x) = (0 : V) := by
      have hcompat : q & p = p & q := by rw [hqp]; exact hpq.symm
      rw [sp_assoc_of_compatible hq.1 hp.1 hx hcompat, hqp, sp_zero_left hx]
    have h2 : q & (q & x) = q & x :=
      by rw [sp_assoc_of_compatible hq.1 hq.1 hx rfl, hq.2]
    rw [h1, h2, zero_add, sub_self]

/-- **Peirce decomposition uniqueness**: if x = a₂ + a₁ + a₀ with
    a₂ ∈ V₂(p), a₁ ∈ V₁(p,q), a₀ ∈ V₀(p), and all components are effects
    with x an effect, then the decomposition is unique
    (a₂ = C_p(x), a₀ = C_q(x), a₁ = P₁(x)).

    Requires effect hypotheses for sp_add_right (S1) to decompose compressions. -/
theorem peirce_decomp_unique {p q : V}
    (hp : IsIdempotent p) (hq : IsIdempotent q)
    (horth : SharpOrthogonal p q) (hsum : p + q = (𝟙 : V))
    {a₂ a₁ a₀ x : V}
    (ha₂ : a₂ ∈ PeirceTwo p) (ha₁ : a₁ ∈ PeirceOne p q)
    (ha₀ : a₀ ∈ PeirceZero p)
    (hx : x = a₂ + a₁ + a₀)
    (he₂ : IsEffect a₂) (he₁ : IsEffect a₁) (he₀ : IsEffect a₀)
    (hex : IsEffect x) :
    a₂ = C[p] x ∧ a₀ = C[q] x ∧ a₁ = peirceOneProj p q x := by
  -- Extract Peirce space characterizations (at the sp level)
  have h_pa₂ : p & a₂ = a₂ := ha₂
  have h_pa₁ : p & a₁ = 0 := ha₁.1
  have h_qa₁ : q & a₁ = 0 := ha₁.2
  -- a₀ ∈ PeirceZero p = PeirceTwo (𝟙 - p), and q = 𝟙 - p
  have hq_eq : q = 𝟙 - p := by
    have h := hsum; have : q = q + 0 := by abel
    rw [this]; rw [show (0 : V) = -(p + q) + 𝟙 from by rw [h]; abel]; abel
  have h_qa₀ : q & a₀ = a₀ := by change C[q] a₀ = a₀; rw [hq_eq]; exact ha₀
  -- Orthogonality
  have hpq : p & q = 0 := horth.2.2
  have hqp : q & p = 0 := sp_zero_symm hp.1 hq.1 hpq
  have hcompat : p & q = q & p := by rw [hpq, hqp]
  -- p & a₀ = 0: from q & a₀ = a₀, p & a₀ = p & (q & a₀) = (p&q) & a₀ = 0
  have h_pa₀ : p & a₀ = 0 := by
    conv_lhs => rw [← h_qa₀]
    rw [sp_assoc_of_compatible hp.1 hq.1 he₀ hcompat, hpq, sp_zero_left he₀]
  -- q & a₂ = 0: from p & a₂ = a₂, q & a₂ = q & (p & a₂) = (q&p) & a₂ = 0
  have h_qa₂ : q & a₂ = 0 := by
    conv_lhs => rw [← h_pa₂]
    rw [sp_assoc_of_compatible hq.1 hp.1 he₂ hcompat.symm, hqp, sp_zero_left he₂]
  -- Sum bounds for sp_add_right
  have hx_le : a₂ + a₁ + a₀ ≤ 𝟙 := hx ▸ hex.2
  have ha₁a₀_le : a₁ + a₀ ≤ 𝟙 := by
    have h := sub_le_self_of_nonneg (b := a₂ + a₁ + a₀) he₂.1
    have hrw : a₂ + a₁ + a₀ - a₂ = a₁ + a₀ := by abel
    rw [hrw] at h; exact le_trans h hx_le
  have he₁₀ : IsEffect (a₁ + a₀) := he₁.add_of_le_unit he₀ ha₁a₀_le
  have ha₂_sum_le : a₂ + (a₁ + a₀) ≤ 𝟙 := by
    have hrw : a₂ + (a₁ + a₀) = a₂ + a₁ + a₀ := by abel
    rw [hrw]; exact hx_le
  -- C_p(x) = a₂
  have hcp_x : C[p] x = a₂ := by
    unfold compress; rw [hx]
    have hrw : a₂ + a₁ + a₀ = a₂ + (a₁ + a₀) := by abel
    rw [hrw, sp_add_right hp.1 he₂ he₁₀ ha₂_sum_le,
        sp_add_right hp.1 he₁ he₀ ha₁a₀_le,
        h_pa₂, h_pa₁, h_pa₀]; abel
  -- C_q(x) = a₀
  have ha₂a₁_le : a₂ + a₁ ≤ 𝟙 := by
    have h := sub_le_self_of_nonneg (b := a₂ + a₁ + a₀) he₀.1
    have hrw : a₂ + a₁ + a₀ - a₀ = a₂ + a₁ := by abel
    rw [hrw] at h; exact le_trans h hx_le
  have he₂₁ : IsEffect (a₂ + a₁) := he₂.add_of_le_unit he₁ ha₂a₁_le
  have hsum_le2 : (a₂ + a₁) + a₀ ≤ 𝟙 := by
    have hrw : (a₂ + a₁) + a₀ = a₂ + a₁ + a₀ := by abel
    rw [hrw]; exact hx_le
  have hcq_x : C[q] x = a₀ := by
    unfold compress; rw [hx]
    have hrw : a₂ + a₁ + a₀ = (a₂ + a₁) + a₀ := by abel
    rw [hrw, sp_add_right hq.1 he₂₁ he₀ hsum_le2,
        sp_add_right hq.1 he₂ he₁ ha₂a₁_le,
        h_qa₂, h_qa₁, h_qa₀]; abel
  -- Conclude
  refine ⟨hcp_x.symm, hcq_x.symm, ?_⟩
  unfold peirceOneProj; rw [hcp_x, hcq_x, hx]; abel

end PeirceDecomp
