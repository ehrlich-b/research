/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.OrderUnitSpace
import RadicalRelativity.SequentialProduct
import Mathlib.Analysis.SpecialFunctions.Pow.Real

set_option linter.style.longLine false

/-!
# Self-Modeling Bridge: From Self-Modeling to Sequential Product

This file bridges the gap between the paper's PREMISE (self-modeling) and
the formalization's STARTING POINT (sequential product axioms S1-S7).

## The problem this file solves

Paper 5 claims: "Self-modeling forces complex QM."
The existing Lean code proves: "Sequential product axioms S1-S7 → Jordan → C* → QM."
The GAP: the construction from self-modeling to S1-S7 was only in prose.

This file formalizes that connection:
1. Defines `SelfModelingSystem` (the paper's operational premise)
2. Axiomatizes the sequential product construction (Paper 5 Sections 3-4)
3. Produces a `SequentialProduct` instance from any self-modeling system

## The construction (in the paper)

For sharp effects (projective units) p, q:
  sp(p, q) = C_p(q)     (compression of q by p)

For general effects a = Σ λᵢ pᵢ (spectral decomposition):
  sp(a, b) = Σᵢ λᵢ · C_{pᵢ}(b) + Σᵢ<ⱼ f(λᵢ,λⱼ) · P₁ᵢⱼ(b)

where P₁ᵢⱼ is the Peirce (i,j) projection onto V₁(pᵢ,pⱼ).

The faithful self-modeling constraint forces f(λᵢ, λⱼ) = √(λᵢ λⱼ).

The key step: the naive extension (f = 0, just compressions) FAILS unitality
because sp(1, b) = Σᵢ C_{pᵢ}(b) = pinch(b) ≠ b. The pinching map annihilates
Peirce 1-space components. The mixing function f = √(λᵢ λⱼ) restores them,
giving sp(1, b) = pinch(b) + P₁(b) = b.

S1-S7 hold because:
- S1 (additivity): linearity of compression + Peirce projection
- S2 (continuity): automatic in finite dimensions
- S3 (unitality): the mixing function restores Peirce 1-space terms
- S4 (orthogonality symmetry): facial orthogonality (Alfsen-Shultz Prop 7.36)
- S5 (associativity of compatible): Peirce 1-space invariance +
  multiplicativity of f = √(λᵢ λⱼ)
- S6 (compatibility + complement/sum): Peirce structure preservation
- S7 (compatibility + product): Peirce structure preservation

## What is axiomatized and why

The bridge axiom `self_model_gives_sp_data` encapsulates the entire
construction from Paper 5 Sections 3-4. Formalizing the construction
from scratch would require OUS-level spectral theory, facial structure,
and compression theory (Alfsen-Shultz 2003, Chapters 6-9) — significant
infrastructure that is independent of the paper's contribution.

The construction is verified by two concrete instances that prove all
S1-S7 from scratch: DiagOUS (M2CInstance.lean) and SpinFactor (SpinFactor.lean).

## Connection to the rest of the formalization

Once this file produces `selfModelingSP`, the existing chain applies:
  S1-S7 → Jordan (JordanStructure.lean)
  → Local tomography (LocalTomography.lean)
  → C*-algebra (CStarBridge.lean)
  → Type exclusion: only complex (LocalTomography.lean)
  → Concrete models (M2CInstance.lean, SpinFactor.lean)

## References

* Ehrlich 2026, "QM from Self-Modeling", Sections 2-4
* Alfsen-Shultz 2003, "Geometry of State Spaces of Operator Algebras", Ch. 6-9
* van de Wetering 2019, arXiv:1803.11139
-/

noncomputable section

open OrderUnitSpace

/-! ## Self-Modeling System

A self-modeling system consists of a body space V_B, a model space V_M
(isomorphic as an order unit space), and a faithful tracking map φ.
This is Assumption A2 of Paper 5. -/

/-- A self-modeling system: a body OUS with a faithful internal model.

    The tracking map `phi` is an order isomorphism from the body to
    the model. "Faithful" means phi is bijective and order-preserving
    in both directions. The model space is isomorphic to the body;
    we represent this by having phi map V to itself (since V_M ≅ V_B,
    we can identify them without loss of generality). -/
structure SelfModelingSystem (V : Type*) [OrderUnitSpace V] where
  /-- The faithful tracking map φ: V_B → V_M.
      Since V_M ≅ V_B, we model this as an endomorphism. -/
  phi : V → V
  /-- φ preserves the order unit. -/
  phi_unit : phi ousUnit = ousUnit
  /-- φ preserves order (positive map). -/
  phi_mono : ∀ {a b : V}, a ≤ b → phi a ≤ phi b
  /-- φ is injective (faithful: distinct states map to distinct models). -/
  phi_inj : Function.Injective phi
  /-- φ is surjective (complete: every model state is realized). -/
  phi_surj : Function.Surjective phi
  /-- φ preserves effects. -/
  phi_effect : ∀ {a : V}, IsEffect a → IsEffect (phi a)
  /-- φ⁻¹ preserves order (the inverse is also positive). -/
  phi_inv_mono : ∀ {a b : V}, phi a ≤ phi b → a ≤ b

/-! ## Pre-Compression System

A compression operation on a raw OrderUnitSpace, without requiring a
SequentialProduct instance. This resolves the chicken-and-egg problem:
SpectralDecomp/compress/peirceOneProj all need `&`, but we're building `&`.

All properties here are published results from Alfsen-Shultz 2003. -/

/-- A compression system on an order unit space (Alfsen-Shultz 2003, Ch. 6-7).
    Bundles the compression operation C_p and its algebraic properties. -/
structure CompressionSystem (V : Type*) [OrderUnitSpace V] where
  /-- The compression operation C_p(x). -/
  compress : V → V → V
  /-- C_p is additive in x. -/
  compress_add : ∀ p x y, compress p (x + y) = compress p x + compress p y
  /-- C_p is ℝ-linear in x. -/
  compress_smul : ∀ p (r : ℝ) x, compress p (r • x) = r • compress p x
  /-- C_p maps effects to effects. -/
  compress_effect : ∀ {p x}, IsEffect p → IsEffect x → IsEffect (compress p x)
  /-- C_p is order-preserving. -/
  compress_mono : ∀ {p x y}, IsEffect p → x ≤ y → compress p x ≤ compress p y
  /-- C_p(𝟙) = p. -/
  compress_unit : ∀ {p}, IsEffect p → compress p ousUnit = p
  /-- C_𝟙(x) = x. -/
  compress_unit_id : ∀ x, compress ousUnit x = x
  /-- C_p is idempotent: C_p(C_p(x)) = C_p(x). -/
  compress_idem : ∀ p x, compress p (compress p x) = compress p x
  /-- C_p(x) ≤ p for effects. -/
  compress_le_left : ∀ {p x}, IsEffect p → IsEffect x → compress p x ≤ p

/-- C_p distributes over subtraction (derived from additivity + scalar). -/
theorem CompressionSystem.compress_sub {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p x y : V) :
    cs.compress p (x - y) = cs.compress p x - cs.compress p y := by
  have h : x - y = x + (-1 : ℝ) • y := by rw [neg_one_smul]; abel
  rw [h, cs.compress_add, cs.compress_smul]
  rw [neg_one_smul]; abel

/-! ## Pre-Spectral Decomposition

A spectral decomposition that uses CompressionSystem instead of `&`. -/

/-- A spectral decomposition relative to a compression system.
    Eigenvalue distinctness is NOT required — this allows simultaneous
    decompositions of compatible effects (needed for S5). -/
structure PreSpectralDecomp (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) where
  /-- Number of spectral components. -/
  n : ℕ
  /-- The projective units. -/
  proj : Fin n → V
  /-- The eigenvalues. -/
  eigenval : Fin n → ℝ
  /-- Each projection is an effect. -/
  proj_effect : ∀ i, IsEffect (proj i)
  /-- Eigenvalues are in [0,1]. -/
  eigenval_nonneg : ∀ i, 0 ≤ eigenval i
  eigenval_le_one : ∀ i, eigenval i ≤ 1
  /-- Projections are mutually orthogonal under compression. -/
  proj_orthogonal : ∀ i j, i ≠ j → cs.compress (proj i) (proj j) = 0
  /-- Projections sum to the unit. -/
  proj_sum_unit : (∑ i : Fin n, proj i) = ousUnit
  /-- Each projection is idempotent under compression. -/
  proj_idem : ∀ i, cs.compress (proj i) (proj i) = proj i
  /-- Any pair of distinct projections sums to at most 𝟙. -/
  proj_pair_le_unit : ∀ i j, i ≠ j → proj i + proj j ≤ ousUnit

/-- Reconstruct the effect from its spectral decomposition: a = Σ λᵢ pᵢ. -/
def PreSpectralDecomp.reconstruct {V : Type*} [OrderUnitSpace V]
    {cs : CompressionSystem V} (sd : PreSpectralDecomp V cs) : V :=
  ∑ i : Fin sd.n, sd.eigenval i • sd.proj i

/-! ## Peirce 1-Projection (Pre-version)

P₁ᵢⱼ(x) = C_{pᵢ+pⱼ}(x) - C_{pᵢ}(x) - C_{pⱼ}(x)

This is the off-diagonal Peirce block for the (i,j) pair. -/

/-- The Peirce 1-projection for a pair of projective units. -/
def prePeirceOneProj {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p q : V) (x : V) : V :=
  cs.compress (p + q) x - cs.compress p x - cs.compress q x

/-! ## Published-Result Axioms

Each axiom below is a published theorem from Alfsen-Shultz 2003
or standard OUS theory. We cite rather than re-prove. -/

/-- Every effect in a self-modeling OUS admits a spectral decomposition
    (Alfsen-Shultz 2003, Chapter 9). -/
axiom has_compression (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) : CompressionSystem V

/-- Every effect has a spectral decomposition (Alfsen-Shultz 2003, Thm 9.33). -/
axiom has_spectral_decomp (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) (a : V) (ha : IsEffect a) :
    PreSpectralDecomp V (has_compression V sm)

/-- The spectral decomposition reconstructs the original effect. -/
axiom spectral_reconstruct (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) (a : V) (ha : IsEffect a) :
    (has_spectral_decomp V sm a ha).reconstruct = a

/-- For elements that are diagonal in a spectral decomposition (i.e., they are
    linear combinations of the projections), the off-diagonal Peirce components
    vanish (Alfsen-Shultz 2003, Prop 7.48). -/
axiom diagonal_peirce_vanish (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    {b : V} (hb_diag : ∃ μ : Fin sd.n → ℝ, (∑ i, μ i • sd.proj i) = b) :
    ∀ i j, i ≠ j → prePeirceOneProj cs (sd.proj i) (sd.proj j) b = 0

/-- Compression annihilates Peirce 1-components: C_{pᵢ}(P₁ₖₗ(x)) = 0
    for any i, k, l from the same spectral decomposition.
    (Alfsen-Shultz 2003, Chapter 7, Peirce space orthogonality:
    V₂(pᵢ), V₁(pₖ,pₗ), V₀ are mutually annihilated by compressions
    from orthogonal projections in the same decomposition.) -/
axiom compress_annihilates_peirce1 (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (i k l : Fin sd.n) (hkl : k ≠ l) (x : V) :
    cs.compress (sd.proj i) (prePeirceOneProj cs (sd.proj k) (sd.proj l) x) = 0

/-- Peirce 1-projection annihilates compressed elements: P₁ᵢⱼ(C_{pₖ}(x)) = 0
    for any i ≠ j and any k from the same spectral decomposition.
    Dual of compress_annihilates_peirce1.
    (Alfsen-Shultz 2003, Chapter 7, Peirce space orthogonality:
    C_{pₖ}(x) ∈ V₂(pₖ), and P₁ᵢⱼ projects onto V₁(pᵢ,pⱼ),
    which is orthogonal to V₂(pₖ) for any k.) -/
axiom peirce1_annihilates_compress (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (i j k : Fin sd.n) (hij : i ≠ j) (x : V) :
    prePeirceOneProj cs (sd.proj i) (sd.proj j) (cs.compress (sd.proj k) x) = 0

/-- Peirce 1-projections are orthogonal idempotents: P₁ᵢⱼ(P₁ₖₗ(x)) = δ_{ij,kl} P₁ᵢⱼ(x)
    where the Kronecker delta is on unordered pairs {i,j} = {k,l}.
    (Alfsen-Shultz 2003, Prop 7.44: Peirce projections are orthogonal.) -/
axiom peirce1_orthogonal_idem (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (i j k l : Fin sd.n) (hij : i ≠ j) (hkl : k ≠ l) (x : V) :
    prePeirceOneProj cs (sd.proj i) (sd.proj j)
      (prePeirceOneProj cs (sd.proj k) (sd.proj l) x) =
    if (i = k ∧ j = l) ∨ (i = l ∧ j = k) then
      prePeirceOneProj cs (sd.proj i) (sd.proj j) x
    else 0

/-- Compression of orthogonal projection products: C_{pᵢ}(C_{pₖ}(x)) = δᵢₖ C_{pᵢ}(x).
    Follows from compression idempotence (i = k) and orthogonal annihilation (i ≠ k).
    (Alfsen-Shultz 2003, Chapter 6: compression idempotence C_p ∘ C_p = C_p;
    Chapter 7: orthogonal projections give C_{pᵢ} ∘ C_{pₖ} = 0 for i ≠ k.) -/
axiom compress_orthogonal_product (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (i k : Fin sd.n) (x : V) :
    cs.compress (sd.proj i) (cs.compress (sd.proj k) x) =
    if i = k then cs.compress (sd.proj i) x else 0

/-! ## The Corrected Product

sp(a, b) = Σᵢ λᵢ C_{pᵢ}(b) + Σᵢ<ⱼ √(λᵢλⱼ) P₁ᵢⱼ(b)

where a = Σᵢ λᵢ pᵢ is the spectral decomposition of a. -/

/-- The self-modeling sequential product (Paper 5, equation 7). -/
noncomputable def correctedProduct {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) (b : V) : V :=
  (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) b) +
  (∑ i : Fin sd.n, ∑ j : Fin sd.n,
    if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
      prePeirceOneProj cs (sd.proj i) (sd.proj j) b
    else 0)

/-- Trivial spectral decomposition (n=1, eigenvalue 0, projection 𝟙).
    Used as default for non-effects. -/
noncomputable def trivialSpectralDecomp {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) : PreSpectralDecomp V cs where
  n := 1
  proj := fun _ => ousUnit
  eigenval := fun _ => 0
  proj_effect := fun _ => isEffect_unit
  eigenval_nonneg := fun _ => le_refl 0
  eigenval_le_one := fun _ => by linarith [OrderUnitSpace.ousUnit_nonneg (V := V)]
  proj_orthogonal := fun i j h => absurd (Fin.ext_iff.mpr (by omega)) h
  proj_sum_unit := by simp
  proj_idem := fun _ => cs.compress_unit isEffect_unit
  proj_pair_le_unit := fun i j h => absurd (Fin.ext_iff.mpr (by omega)) h

/-- Spectral decomposition with classical choice for non-effects. -/
noncomputable def getSpectralDecomp {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) (a : V) : PreSpectralDecomp V (has_compression V sm) :=
  haveI : Decidable (IsEffect a) := Classical.dec _
  if h : IsEffect a then has_spectral_decomp V sm a h
  else trivialSpectralDecomp (has_compression V sm)

/-- The full sequential product: look up spectral decomposition, apply corrected product. -/
noncomputable def selfModelProduct {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) (a b : V) : V :=
  correctedProduct (has_compression V sm) (getSpectralDecomp sm a) b

/-- For effects, getSpectralDecomp returns the actual spectral decomp. -/
theorem getSpectralDecomp_of_effect {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) (a : V) (ha : IsEffect a) :
    getSpectralDecomp sm a = has_spectral_decomp V sm a ha := by
  unfold getSpectralDecomp
  have : Decidable (IsEffect a) := Classical.dec _
  simp [dif_pos ha]

/-- The corrected product of a single-component decomposition with
    eigenvalue λ and projection p simplifies to λ • compress p b. -/
theorem correctedProduct_single {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) (b : V)
    (hn : sd.n = 1) :
    correctedProduct cs sd b = sd.eigenval ⟨0, by omega⟩ • cs.compress (sd.proj ⟨0, by omega⟩) b := by
  unfold correctedProduct
  -- Off-diagonal sum vanishes for n=1
  have hoff : ∀ (i j : Fin sd.n), ¬(i < j) := by
    intro i j h; exact absurd (show i.val < j.val from h) (by omega)
  have hoff_sum : (∑ i : Fin sd.n, ∑ j : Fin sd.n,
    if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
      prePeirceOneProj cs (sd.proj i) (sd.proj j) b else 0) = 0 := by
    apply Finset.sum_eq_zero; intro i _
    apply Finset.sum_eq_zero; intro j _
    rw [if_neg (hoff i j)]
  rw [hoff_sum, add_zero]
  -- Diagonal sum has one term
  have hdiag : (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) b) =
    sd.eigenval ⟨0, by omega⟩ • cs.compress (sd.proj ⟨0, by omega⟩) b := by
    have : Finset.univ (α := Fin sd.n) = {⟨0, by omega⟩} := by
      ext x; simp [Fin.ext_iff]; omega
    rw [this, Finset.sum_singleton]
  exact hdiag

/-! ## Post-definition Axioms

These axioms reference correctedProduct/selfModelProduct.
- selfModelProduct_nonneg: OUR theorem (PSD coefficient matrix). The one axiom that
  encapsulates our contribution rather than citing a published result.
- The remaining axioms cite Alfsen-Shultz 2003 (compatibility, facial structure,
  spectral functional calculus). -/

/-- **Corrected product positivity** (Paper 5, Section 3, our theorem):
    If a is an effect and b ≥ 0, then sp(a, b) ≥ 0.

    The coefficient matrix M_ij = √(λᵢλⱼ) factors as vvᵀ where v = (√λ₁,...,√λₙ),
    so it is positive semidefinite (rank 1). Combined with the positivity of
    compressions (C_{pᵢ}(b) ≥ 0 for b ≥ 0), this gives sp(a,b) ≥ 0.

    This is OUR theorem, not a published external result. The PSD argument
    requires the self-model structure and does not follow from Alfsen-Shultz
    alone. Axiomatized because the formal proof needs either the Schur product
    theorem or End(V) embedding infrastructure (~500 lines). -/
axiom selfModelProduct_nonneg (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V}
    (ha : IsEffect a) (hb : (0 : V) ≤ b) :
    (0 : V) ≤ selfModelProduct sm a b

/-- Compatibility ↔ Peirce vanishing (Alfsen-Shultz 2003, Chapter 7). -/
axiom compatibility_iff_peirce_vanish (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V} (ha : IsEffect a) (hb : IsEffect b) :
    selfModelProduct sm a b = selfModelProduct sm b a ↔
    (∀ i j, i ≠ j → prePeirceOneProj (has_compression V sm)
      ((has_spectral_decomp V sm a ha).proj i)
      ((has_spectral_decomp V sm a ha).proj j) b = 0)

/-- When a|b, Peirce 1-projections from a's decomposition commute with sp(b, ·).
    (Alfsen-Shultz 2003, Prop 7.50: compatible compression algebras commute.) -/
axiom compatible_peirce_sp_commute (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b c : V}
    (ha : IsEffect a) (hb : IsEffect b)
    (hcompat : selfModelProduct sm a b = selfModelProduct sm b a)
    (i j : Fin (has_spectral_decomp V sm a ha).n) (hij : i ≠ j) :
    prePeirceOneProj (has_compression V sm)
      ((has_spectral_decomp V sm a ha).proj i)
      ((has_spectral_decomp V sm a ha).proj j)
      (selfModelProduct sm b c) =
    selfModelProduct sm b
      (prePeirceOneProj (has_compression V sm)
        ((has_spectral_decomp V sm a ha).proj i)
        ((has_spectral_decomp V sm a ha).proj j) c)

/-- Peirce 1-projection is additive. -/
theorem prePeirceOneProj_add {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p q x y : V) :
    prePeirceOneProj cs p q (x + y) = prePeirceOneProj cs p q x + prePeirceOneProj cs p q y := by
  unfold prePeirceOneProj
  rw [cs.compress_add, cs.compress_add, cs.compress_add]; abel

/-- Peirce 1-projection distributes over subtraction. -/
theorem prePeirceOneProj_sub {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p q x y : V) :
    prePeirceOneProj cs p q (x - y) = prePeirceOneProj cs p q x - prePeirceOneProj cs p q y := by
  unfold prePeirceOneProj
  rw [cs.compress_sub, cs.compress_sub, cs.compress_sub]; abel

/-- Peirce 1-projection of the unit vanishes: P₁ᵢⱼ(𝟙) = 0.
    Because C_{pᵢ+pⱼ}(𝟙) = pᵢ+pⱼ and C_{pᵢ}(𝟙) = pᵢ, C_{pⱼ}(𝟙) = pⱼ. -/
theorem prePeirceOneProj_unit {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) {p q : V}
    (hp : IsEffect p) (hq : IsEffect q) (hpq : p + q ≤ ousUnit) :
    prePeirceOneProj cs p q ousUnit = 0 := by
  unfold prePeirceOneProj
  have hpq_eff : IsEffect (p + q) := ⟨OrderUnitSpace.add_nonneg hp.1 hq.1, hpq⟩
  rw [cs.compress_unit hp, cs.compress_unit hq, cs.compress_unit hpq_eff]; abel

/-! ## Peirce Algebra Helper Lemmas

Infrastructure for distributing compression and Peirce projection through sums.
Used by compress_correctedProduct and peirce1_correctedProduct (for S5). -/

/-- Compression of 0 is 0. -/
theorem CompressionSystem.compress_zero {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p : V) : cs.compress p 0 = 0 := by
  have h := cs.compress_smul p 0 ousUnit
  simp only [zero_smul] at h; exact h

/-- Compression distributes over finite sums. -/
theorem CompressionSystem.compress_finset_sum {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p : V) {ι : Type*} (s : Finset ι) (f : ι → V) :
    cs.compress p (s.sum f) = s.sum (fun i => cs.compress p (f i)) := by
  classical
  induction s using Finset.induction_on with
  | empty => rw [Finset.sum_empty, Finset.sum_empty]; exact cs.compress_zero p
  | @insert a s has ih => rw [Finset.sum_insert has, cs.compress_add, ih, Finset.sum_insert has]

/-- Peirce 1-projection is ℝ-linear. -/
theorem prePeirceOneProj_smul {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p q : V) (r : ℝ) (x : V) :
    prePeirceOneProj cs p q (r • x) = r • prePeirceOneProj cs p q x := by
  unfold prePeirceOneProj
  rw [cs.compress_smul, cs.compress_smul, cs.compress_smul, smul_sub, smul_sub]

/-- Peirce 1-projection of 0 is 0. -/
theorem prePeirceOneProj_zero {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p q : V) : prePeirceOneProj cs p q 0 = 0 := by
  unfold prePeirceOneProj
  rw [cs.compress_zero, cs.compress_zero, cs.compress_zero]; abel

/-- Peirce 1-projection distributes over finite sums. -/
theorem prePeirceOneProj_finset_sum {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (p q : V) {ι : Type*} (s : Finset ι) (f : ι → V) :
    prePeirceOneProj cs p q (s.sum f) = s.sum (fun i => prePeirceOneProj cs p q (f i)) := by
  classical
  induction s using Finset.induction_on with
  | empty => rw [Finset.sum_empty, Finset.sum_empty]; exact prePeirceOneProj_zero cs p q
  | @insert a s has ih => rw [Finset.sum_insert has, prePeirceOneProj_add, ih, Finset.sum_insert has]

/-! ## Sequential Product Data (SPData)

Bundles the sequential product operation with its S1-S7 properties. -/

/-- Sequential product data for an existing order unit space.
    Bundles `sp` and all S1-S7 properties without OUS inheritance. -/
structure SPData (V : Type*) [OrderUnitSpace V] where
  /-- The sequential product operation. -/
  sp : V → V → V
  /-- S1: Additivity in second argument. -/
  sp_add_right : ∀ {a b c : V}, IsEffect a → IsEffect b → IsEffect c →
    b + c ≤ ousUnit → sp a (b + c) = sp a b + sp a c
  /-- S2: Monotonicity in second argument. -/
  sp_mono_right : ∀ {a b₁ b₂ : V}, IsEffect a → IsEffect b₁ → IsEffect b₂ →
    b₁ ≤ b₂ → sp a b₁ ≤ sp a b₂
  /-- S3: Unitality. -/
  sp_unit_left : ∀ {a : V}, IsEffect a → sp ousUnit a = a
  /-- S4: Symmetry of orthogonality. -/
  sp_zero_symm : ∀ {a b : V}, IsEffect a → IsEffect b → sp a b = 0 → sp b a = 0
  /-- S5: Associativity of compatible effects. -/
  sp_assoc_of_compatible : ∀ {a b c : V},
    IsEffect a → IsEffect b → IsEffect c →
    sp a b = sp b a → sp a (sp b c) = sp (sp a b) c
  /-- S6a: Compatibility with orthocomplement. -/
  compatible_ortho : ∀ {a b : V}, IsEffect a → IsEffect b →
    sp a b = sp b a → sp a (ousUnit - b) = sp (ousUnit - b) a
  /-- S6b: Additivity of compatibility. -/
  compatible_add : ∀ {a b c : V}, IsEffect a → IsEffect b → IsEffect c →
    b + c ≤ ousUnit →
    sp a b = sp b a → sp a c = sp c a →
    sp a (b + c) = sp (b + c) a
  /-- S7: Multiplicativity of compatibility. -/
  compatible_sp : ∀ {a b c : V}, IsEffect a → IsEffect b → IsEffect c →
    sp a b = sp b a → sp a c = sp c a →
    sp a (sp b c) = sp (sp b c) a
  /-- Effect closure. -/
  sp_effect : ∀ {a b : V}, IsEffect a → IsEffect b → IsEffect (sp a b)
  /-- Linearity of L_a on effect differences. -/
  sp_sub_right_general : ∀ {a b c : V}, IsEffect a → IsEffect b → IsEffect c →
    sp a (b - c) = sp a b - sp a c

/-- Promote `SPData` to a full `SequentialProduct` instance. -/
def SPData.toSequentialProduct {V : Type*} [OrderUnitSpace V]
    (d : SPData V) : SequentialProduct V where
  sp := d.sp
  sp_add_right := d.sp_add_right
  sp_mono_right := d.sp_mono_right
  sp_unit_left := d.sp_unit_left
  sp_zero_symm := d.sp_zero_symm
  sp_assoc_of_compatible := d.sp_assoc_of_compatible
  compatible_ortho := d.compatible_ortho
  compatible_add := d.compatible_add
  compatible_sp := d.compatible_sp
  sp_effect := d.sp_effect
  sp_sub_right_general := d.sp_sub_right_general

/-! ## S1-S7 Proofs for the Corrected Product -/

-- Helper: the off-diagonal sum is additive in x
private theorem offdiag_add {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) (b c : V) :
    (∑ i : Fin sd.n, ∑ j : Fin sd.n,
      if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
        prePeirceOneProj cs (sd.proj i) (sd.proj j) (b + c) else 0) =
    (∑ i : Fin sd.n, ∑ j : Fin sd.n,
      if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
        prePeirceOneProj cs (sd.proj i) (sd.proj j) b else 0) +
    (∑ i : Fin sd.n, ∑ j : Fin sd.n,
      if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
        prePeirceOneProj cs (sd.proj i) (sd.proj j) c else 0) := by
  rw [← Finset.sum_add_distrib]
  congr 1; ext i
  rw [← Finset.sum_add_distrib]
  congr 1; ext j
  split_ifs with h
  · unfold prePeirceOneProj
    rw [cs.compress_add, cs.compress_add, cs.compress_add]
    rw [show ∀ (r : ℝ) (A A' B B' C C' : V),
        r • (A + A' - (B + B') - (C + C')) =
        r • (A - B - C) + r • (A' - B' - C') from
      fun r A A' B B' C C' => by rw [← smul_add]; congr 1; abel]
  · rw [add_zero]

-- S1: Additivity in second argument
theorem correctedProduct_add {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) (b c : V) :
    correctedProduct cs sd (b + c) = correctedProduct cs sd b + correctedProduct cs sd c := by
  unfold correctedProduct
  rw [show (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) (b + c)) =
      (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) b) +
      (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) c) from by
    rw [← Finset.sum_add_distrib]; congr 1; ext i
    rw [cs.compress_add, smul_add]]
  rw [offdiag_add]
  abel

-- Helper: the off-diagonal sum distributes over subtraction
private theorem offdiag_sub {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) (b c : V) :
    (∑ i : Fin sd.n, ∑ j : Fin sd.n,
      if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
        prePeirceOneProj cs (sd.proj i) (sd.proj j) (b - c) else 0) =
    (∑ i : Fin sd.n, ∑ j : Fin sd.n,
      if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
        prePeirceOneProj cs (sd.proj i) (sd.proj j) b else 0) -
    (∑ i : Fin sd.n, ∑ j : Fin sd.n,
      if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
        prePeirceOneProj cs (sd.proj i) (sd.proj j) c else 0) := by
  rw [← Finset.sum_sub_distrib]
  congr 1; ext i
  rw [← Finset.sum_sub_distrib]
  congr 1; ext j
  split_ifs with h
  · unfold prePeirceOneProj
    rw [cs.compress_sub, cs.compress_sub, cs.compress_sub]
    rw [show ∀ (r : ℝ) (A A' B B' C C' : V),
        r • (A - A' - (B - B') - (C - C')) =
        r • (A - B - C) - r • (A' - B' - C') from
      fun r A A' B B' C C' => by rw [← smul_sub]; congr 1; abel]
  · rw [sub_self]

-- sp_sub_right_general: linearity for subtraction
theorem correctedProduct_sub {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) (b c : V) :
    correctedProduct cs sd (b - c) = correctedProduct cs sd b - correctedProduct cs sd c := by
  unfold correctedProduct
  rw [show (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) (b - c)) =
      (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) b) -
      (∑ i : Fin sd.n, sd.eigenval i • cs.compress (sd.proj i) c) from by
    rw [← Finset.sum_sub_distrib]; congr 1; ext i
    rw [cs.compress_sub, smul_sub]]
  rw [offdiag_sub]
  abel

-- correctedProduct of 0 is 0 (from linearity)
theorem correctedProduct_zero {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) :
    correctedProduct cs sd 0 = 0 := by
  have h := correctedProduct_sub cs sd ousUnit ousUnit
  rwa [sub_self, sub_self] at h

-- correctedProduct of 𝟙 is the reconstruction: sp(a, 𝟙) = Σ λᵢ pᵢ = a
theorem correctedProduct_unit {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs) :
    correctedProduct cs sd ousUnit = sd.reconstruct := by
  unfold correctedProduct PreSpectralDecomp.reconstruct
  have hoff : (∑ i : Fin sd.n, ∑ j : Fin sd.n,
    if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
      prePeirceOneProj cs (sd.proj i) (sd.proj j) ousUnit
    else 0) = 0 := by
    apply Finset.sum_eq_zero; intro i _
    apply Finset.sum_eq_zero; intro j _
    split_ifs with h
    · rw [prePeirceOneProj_unit cs (sd.proj_effect i) (sd.proj_effect j)
        (sd.proj_pair_le_unit i j (ne_of_lt h))]
      simp
    · rfl
  rw [hoff, add_zero]
  congr 1; ext i
  rw [cs.compress_unit (sd.proj_effect i)]

-- selfModelProduct of 0 in second argument
theorem selfModelProduct_zero {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) (a : V) :
    selfModelProduct sm a 0 = 0 := correctedProduct_zero _ _

-- Right-unitality: sp(a, 𝟙) = a
theorem selfModelProduct_unit {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a : V} (ha : IsEffect a) :
    selfModelProduct sm a ousUnit = a := by
  unfold selfModelProduct
  rw [getSpectralDecomp_of_effect sm a ha, correctedProduct_unit]
  exact spectral_reconstruct V sm a ha

/-- **S2 proved**: the self-model product is monotone in the second argument.
    Proof: by positivity (selfModelProduct_nonneg) + linearity (correctedProduct_sub).
    If b₁ ≤ b₂ then b₂ - b₁ ≥ 0, so sp(a, b₂-b₁) ≥ 0, so sp(a,b₂) - sp(a,b₁) ≥ 0. -/
theorem selfModelProduct_mono {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b₁ b₂ : V}
    (ha : IsEffect a) (hle : b₁ ≤ b₂) :
    selfModelProduct sm a b₁ ≤ selfModelProduct sm a b₂ := by
  have hnonneg := selfModelProduct_nonneg V sm ha (OrderUnitSpace.sub_nonneg_of_le hle)
  have hlin : selfModelProduct sm a (b₂ - b₁) =
      selfModelProduct sm a b₂ - selfModelProduct sm a b₁ := by
    unfold selfModelProduct; exact correctedProduct_sub _ _ _ _
  rw [hlin] at hnonneg
  have := OrderUnitSpace.add_le_add_left _ _ hnonneg (selfModelProduct sm a b₁)
  rwa [add_zero, add_comm, sub_eq_add_neg, add_assoc, neg_add_cancel, add_zero] at this

-- sp_effect: effect closure from positivity + monotonicity + right-unitality
theorem selfModelProduct_effect {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V} (ha : IsEffect a) (hb : IsEffect b) :
    IsEffect (selfModelProduct sm a b) := by
  constructor
  · exact selfModelProduct_nonneg V sm ha hb.1
  · have h1 := selfModelProduct_unit sm ha
    have hmono := selfModelProduct_mono sm ha hb.2
    rw [h1] at hmono; exact le_trans hmono ha.2

/-! ## Peirce Algebra Computation Lemmas

These derive how compression and Peirce projection interact with the corrected
product when applied to the SAME spectral decomposition. Used for S5. -/

/-- **Compression of corrected product**: C_{pᵢ}(correctedProduct sd c) = λᵢ C_{pᵢ}(c).
    The diagonal terms collapse via compress_orthogonal_product (Kronecker delta),
    the off-diagonal terms vanish via compress_annihilates_peirce1. -/
theorem compress_correctedProduct {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (i : Fin sd.n) (c : V) :
    cs.compress (sd.proj i) (correctedProduct cs sd c) =
    sd.eigenval i • cs.compress (sd.proj i) c := by
  unfold correctedProduct
  rw [cs.compress_add]
  -- Diagonal: C_{pᵢ}(Σ λₖ C_{pₖ}(c)) = λᵢ C_{pᵢ}(c)
  have hdiag : cs.compress (sd.proj i) (∑ k : Fin sd.n, sd.eigenval k • cs.compress (sd.proj k) c) =
      sd.eigenval i • cs.compress (sd.proj i) c := by
    rw [cs.compress_finset_sum]
    simp_rw [cs.compress_smul, compress_orthogonal_product V cs sd i, smul_ite, smul_zero]
    simp [Finset.sum_ite_eq', Finset.mem_univ]
  -- Off-diagonal: C_{pᵢ}(Σ ... P₁(c)) = 0
  have hoffdiag : cs.compress (sd.proj i)
      (∑ k : Fin sd.n, ∑ l : Fin sd.n,
        if k < l then Real.sqrt (sd.eigenval k * sd.eigenval l) •
          prePeirceOneProj cs (sd.proj k) (sd.proj l) c else 0) = 0 := by
    rw [cs.compress_finset_sum]
    apply Finset.sum_eq_zero; intro k _
    rw [cs.compress_finset_sum]
    apply Finset.sum_eq_zero; intro l _
    split_ifs with h
    · rw [cs.compress_smul, compress_annihilates_peirce1 V cs sd i k l (ne_of_lt h) c, smul_zero]
    · exact cs.compress_zero _
  rw [hdiag, hoffdiag, add_zero]

/-! ## S4: Orthogonality Symmetry

sp(a,b) = 0 → sp(b,a) = 0. Sub-axiom 1 (compress_correctedProduct extraction)
is now proved; sub-axiom 2 (facial orthogonality) remains axiomatized. -/

/-- If sp(a,b) = 0 then C_{pᵢ}(b) = 0 for each positive-eigenvalue projection.
    Proof: compress_correctedProduct gives C_{pᵢ}(sp(a,b)) = λᵢ C_{pᵢ}(b).
    Since sp(a,b) = 0, we get λᵢ C_{pᵢ}(b) = 0; dividing by λᵢ > 0 gives C_{pᵢ}(b) = 0. -/
theorem sp_zero_implies_compress_zero (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V} (ha : IsEffect a) (hb : IsEffect b)
    (h : selfModelProduct sm a b = 0) :
    ∀ i, (has_spectral_decomp V sm a ha).eigenval i > 0 →
      (has_compression V sm).compress ((has_spectral_decomp V sm a ha).proj i) b = 0 := by
  intro i hpos
  let cs := has_compression V sm
  let sd := has_spectral_decomp V sm a ha
  have hc : cs.compress (sd.proj i) (selfModelProduct sm a b) =
      sd.eigenval i • cs.compress (sd.proj i) b := by
    unfold selfModelProduct; rw [getSpectralDecomp_of_effect sm a ha]
    exact compress_correctedProduct cs sd i b
  rw [h, cs.compress_zero] at hc
  have hne : sd.eigenval i ≠ 0 := ne_of_gt hpos
  have h0 := hc.symm
  rw [show cs.compress (sd.proj i) b =
      (sd.eigenval i)⁻¹ • (sd.eigenval i • cs.compress (sd.proj i) b) from by
    rw [smul_smul, inv_mul_cancel₀ hne, one_smul]]
  rw [h0, smul_zero]

/-- S4 sub-axiom 2: If b lives in the orthogonal face of a's support,
    then sp(b,a) = 0. (Alfsen-Shultz 2003, Prop 7.36.) -/
axiom orthogonal_face_sp_zero (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V} (ha : IsEffect a) (hb : IsEffect b)
    (h : ∀ i, (has_spectral_decomp V sm a ha).eigenval i > 0 →
      (has_compression V sm).compress ((has_spectral_decomp V sm a ha).proj i) b = 0) :
    selfModelProduct sm b a = 0

/-- **S4 proved**: sp(a,b) = 0 → sp(b,a) = 0.
    Proof: compress_correctedProduct extracts C_{pᵢ}(b) = 0 (theorem above),
    then facial orthogonality gives sp(b,a) = 0 (sub-axiom 2). -/
theorem orthogonality_symmetry {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V}
    (ha : IsEffect a) (hb : IsEffect b)
    (h : selfModelProduct sm a b = 0) :
    selfModelProduct sm b a = 0 :=
  orthogonal_face_sp_zero V sm ha hb (sp_zero_implies_compress_zero V sm ha hb h)

/-- **Peirce 1-projection of corrected product**: P₁ᵢⱼ(correctedProduct sd c) = √(λᵢλⱼ) P₁ᵢⱼ(c).
    Diagonal terms vanish by peirce1_annihilates_compress; off-diagonal double sum
    collapses via peirce1_orthogonal_idem to the single matching (i,j) term. -/
theorem peirce1_correctedProduct (V : Type*) [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (i j : Fin sd.n) (hij : i ≠ j) (c : V) :
    prePeirceOneProj cs (sd.proj i) (sd.proj j) (correctedProduct cs sd c) =
    Real.sqrt (sd.eigenval i * sd.eigenval j) •
      prePeirceOneProj cs (sd.proj i) (sd.proj j) c := by
  unfold correctedProduct
  rw [prePeirceOneProj_add]
  -- Diagonal terms vanish under P₁ᵢⱼ
  have hdiag : prePeirceOneProj cs (sd.proj i) (sd.proj j)
      (∑ k : Fin sd.n, sd.eigenval k • cs.compress (sd.proj k) c) = 0 := by
    rw [prePeirceOneProj_finset_sum]
    apply Finset.sum_eq_zero; intro k _
    rw [prePeirceOneProj_smul, peirce1_annihilates_compress V cs sd i j k hij c, smul_zero]
  rw [hdiag, zero_add]
  -- Off-diagonal: P₁ᵢⱼ extracts the matching term via orthogonal idempotence
  rw [prePeirceOneProj_finset_sum]
  simp_rw [prePeirceOneProj_finset_sum cs (sd.proj i) (sd.proj j)]
  -- Classify each (k,l) term
  have hterm : ∀ (k l : Fin sd.n),
      prePeirceOneProj cs (sd.proj i) (sd.proj j)
        (if (k : Fin sd.n) < l then
          Real.sqrt (sd.eigenval k * sd.eigenval l) •
            prePeirceOneProj cs (sd.proj k) (sd.proj l) c
        else 0) =
      if k < l ∧ ((i = k ∧ j = l) ∨ (i = l ∧ j = k)) then
        Real.sqrt (sd.eigenval k * sd.eigenval l) •
          prePeirceOneProj cs (sd.proj i) (sd.proj j) c
      else 0 := by
    intro k l
    by_cases hkl : (k : Fin sd.n) < l
    · rw [if_pos hkl, prePeirceOneProj_smul,
          peirce1_orthogonal_idem V cs sd i j k l hij (ne_of_lt hkl) c]
      by_cases hmatch : (i = k ∧ j = l) ∨ (i = l ∧ j = k)
      · rw [if_pos hmatch, if_pos ⟨hkl, hmatch⟩]
      · rw [if_neg hmatch, smul_zero, if_neg (fun ⟨_, h⟩ => hmatch h)]
    · rw [if_neg hkl, prePeirceOneProj_zero, if_neg (fun ⟨h, _⟩ => hkl h)]
  simp_rw [hterm]
  -- Collapse double sum to single matching term
  rcases lt_or_gt_of_ne hij with h_lt | h_gt
  · -- Case i < j: surviving pair is (i, j)
    rw [Finset.sum_eq_single_of_mem i (Finset.mem_univ i) (fun k _ hki => by
      apply Finset.sum_eq_zero; intro l _
      apply if_neg; intro ⟨hkl, hmatch⟩
      rcases hmatch with ⟨hik, _⟩ | ⟨hil, hjk⟩
      · exact hki hik.symm
      · rw [← hjk, ← hil] at hkl; exact absurd h_lt (lt_asymm hkl))]
    rw [Finset.sum_eq_single_of_mem j (Finset.mem_univ j) (fun l _ hlj => by
      apply if_neg; intro ⟨_, hmatch⟩
      rcases hmatch with ⟨_, hjl⟩ | ⟨_, hji⟩
      · exact hlj hjl.symm
      · exact hij hji.symm)]
    rw [if_pos ⟨h_lt, Or.inl ⟨rfl, rfl⟩⟩]
  · -- Case j < i: surviving pair is (j, i), coefficient matches by mul_comm
    rw [Finset.sum_eq_single_of_mem j (Finset.mem_univ j) (fun k _ hkj => by
      apply Finset.sum_eq_zero; intro l _
      apply if_neg; intro ⟨hkl, hmatch⟩
      rcases hmatch with ⟨hik, hjl⟩ | ⟨_, hjk⟩
      · rw [← hik, ← hjl] at hkl; exact absurd h_gt (lt_asymm hkl)
      · exact hkj hjk.symm)]
    rw [Finset.sum_eq_single_of_mem i (Finset.mem_univ i) (fun l _ hli => by
      apply if_neg; intro ⟨_, hmatch⟩
      rcases hmatch with ⟨hij', _⟩ | ⟨hil, _⟩
      · exact hij hij'
      · exact hli hil.symm)]
    rw [if_pos ⟨h_gt, Or.inr ⟨rfl, rfl⟩⟩]
    congr 1; congr 1; ring

/-! ## S5 Infrastructure: Simultaneous Spectral Decomposition -/

/-- Create a PreSpectralDecomp with the same projections but different eigenvalues.
    Used for simultaneous spectral decomposition of compatible effects. -/
noncomputable def PreSpectralDecomp.withEigenvals {V : Type*} [OrderUnitSpace V]
    {cs : CompressionSystem V} (sd : PreSpectralDecomp V cs)
    (ev : Fin sd.n → ℝ) (h_nn : ∀ i, 0 ≤ ev i) (h_le : ∀ i, ev i ≤ 1) :
    PreSpectralDecomp V cs where
  n := sd.n
  proj := sd.proj
  eigenval := ev
  proj_effect := sd.proj_effect
  eigenval_nonneg := h_nn
  eigenval_le_one := h_le
  proj_orthogonal := sd.proj_orthogonal
  proj_sum_unit := sd.proj_sum_unit
  proj_idem := sd.proj_idem
  proj_pair_le_unit := sd.proj_pair_le_unit

/-- Compatible effects admit a simultaneous spectral decomposition: there exists
    a single set of projections {pₖ} with eigenvalue functions α, β such that
    a = Σ αₖ pₖ, b = Σ βₖ pₖ, and the selfModelProduct of each can be computed
    using this shared decomposition.
    (Alfsen-Shultz 2003, Thm 7.55: simultaneously diagonalizable.) -/
axiom compatible_simultaneous_decomp (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b : V} (ha : IsEffect a) (hb : IsEffect b)
    (hcompat : selfModelProduct sm a b = selfModelProduct sm b a) :
    ∃ (sd : PreSpectralDecomp V (has_compression V sm))
      (α β : Fin sd.n → ℝ)
      (hα_nn : ∀ i, 0 ≤ α i) (hα_le : ∀ i, α i ≤ 1)
      (hβ_nn : ∀ i, 0 ≤ β i) (hβ_le : ∀ i, β i ≤ 1),
      (∑ i, α i • sd.proj i) = a ∧
      (∑ i, β i • sd.proj i) = b ∧
      (∀ x, selfModelProduct sm a x =
        correctedProduct (has_compression V sm) (sd.withEigenvals α hα_nn hα_le) x) ∧
      (∀ x, selfModelProduct sm b x =
        correctedProduct (has_compression V sm) (sd.withEigenvals β hβ_nn hβ_le) x)

/-- Spectral calculus: the selfModelProduct can be computed using any spectral
    decomposition that correctly represents the effect. This is the uniqueness
    half of the spectral functional calculus.
    (Alfsen-Shultz 2003, Chapter 9.) -/
axiom selfModelProduct_any_decomp (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a : V} (ha : IsEffect a)
    (sd : PreSpectralDecomp V (has_compression V sm))
    (hrec : sd.reconstruct = a) :
    ∀ x, selfModelProduct sm a x = correctedProduct (has_compression V sm) sd x

/-- The corrected product of a diagonal element is the eigenvalue-weighted sum.
    If b = Σ βₖ pₖ (diagonal in the decomposition), then
    correctedProduct(sd_α, b) = Σ αₖβₖ pₖ.
    Uses: proj_idem, proj_orthogonal, diagonal_peirce_vanish. -/
theorem correctedProduct_diagonal {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) (sd : PreSpectralDecomp V cs)
    (β : Fin sd.n → ℝ) :
    correctedProduct cs sd (∑ k, β k • sd.proj k) =
    ∑ k, (sd.eigenval k * β k) • sd.proj k := by
  have hdiag_vanish := diagonal_peirce_vanish V cs sd
    (b := ∑ k, β k • sd.proj k) ⟨β, rfl⟩
  unfold correctedProduct
  -- Off-diagonal terms vanish on diagonal elements
  have hoff : (∑ i : Fin sd.n, ∑ j : Fin sd.n,
    if i < j then Real.sqrt (sd.eigenval i * sd.eigenval j) •
      prePeirceOneProj cs (sd.proj i) (sd.proj j) (∑ k, β k • sd.proj k)
    else 0) = 0 := by
    apply Finset.sum_eq_zero; intro i _
    apply Finset.sum_eq_zero; intro j _
    split_ifs with h
    · rw [hdiag_vanish i j (ne_of_lt h), smul_zero]
    · rfl
  rw [hoff, add_zero]
  -- Diagonal: Σ λᵢ C_{pᵢ}(Σ βₖ pₖ) = Σ (λᵢβᵢ) pᵢ
  congr 1; ext i
  -- Goal: λᵢ • C_{pᵢ}(Σ βₖ pₖ) = (λᵢ * βᵢ) • pᵢ
  -- Step 1: C_{pᵢ}(Σ βₖ pₖ) = βᵢ • pᵢ
  have hcompress_diag : cs.compress (sd.proj i) (∑ k, β k • sd.proj k) = β i • sd.proj i := by
    rw [cs.compress_finset_sum]; simp_rw [cs.compress_smul]
    have hvanish : ∀ k : Fin sd.n, k ≠ i →
        β k • cs.compress (sd.proj i) (sd.proj k) = 0 :=
      fun k hki => by rw [sd.proj_orthogonal i k (fun h => hki (h ▸ rfl)), smul_zero]
    rw [Finset.sum_eq_single_of_mem i (Finset.mem_univ i) (fun k _ => hvanish k)]
    rw [sd.proj_idem]
  rw [hcompress_diag, smul_smul]

/-- **S5 proved**: sp(a, sp(b,c)) = sp(sp(a,b), c) when a|b.
    Both sides equal Σ αᵢβᵢ C_{pᵢ}(c) + Σᵢ<ⱼ √(αᵢβᵢαⱼβⱼ) P₁ᵢⱼ(c)
    on the shared eigenbasis, using √(αᵢαⱼ)√(βᵢβⱼ) = √(αᵢβᵢαⱼβⱼ). -/
theorem compatible_assoc_thm {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b c : V}
    (ha : IsEffect a) (hb : IsEffect b) (hc : IsEffect c)
    (hcompat : selfModelProduct sm a b = selfModelProduct sm b a) :
    selfModelProduct sm a (selfModelProduct sm b c) =
    selfModelProduct sm (selfModelProduct sm a b) c := by
  obtain ⟨sd, α, β, hα_nn, hα_le, hβ_nn, hβ_le, hrec_a, hrec_b, hsp_a, hsp_b⟩ :=
    compatible_simultaneous_decomp V sm ha hb hcompat
  let cs := has_compression V sm
  let sd_α := sd.withEigenvals α hα_nn hα_le
  let sd_β := sd.withEigenvals β hβ_nn hβ_le
  -- LHS: sp(a, sp(b,c)) = correctedProduct(sd_α, correctedProduct(sd_β, c))
  conv_lhs => rw [hsp_a, hsp_b c]
  -- RHS: sp(sp(a,b), c)
  -- sp(a,b) = Σ αₖβₖ pₖ (diagonal in shared basis)
  have hab_eq : selfModelProduct sm a b = ∑ k, (α k * β k) • sd.proj k := by
    calc selfModelProduct sm a b
      _ = correctedProduct cs sd_α b := hsp_a b
      _ = correctedProduct cs sd_α (∑ k, β k • sd.proj k) := by rw [← hrec_b]
      _ = ∑ k, (α k * β k) • sd.proj k := correctedProduct_diagonal cs sd_α β
  have hab_eff := selfModelProduct_effect sm ha hb
  have hγ_nn : ∀ i, 0 ≤ α i * β i := fun i => mul_nonneg (hα_nn i) (hβ_nn i)
  have hγ_le : ∀ i, α i * β i ≤ 1 := fun i => mul_le_one₀ (hα_le i) (hβ_nn i) (hβ_le i)
  let sd_γ := sd.withEigenvals (fun k => α k * β k) hγ_nn hγ_le
  have hrec_γ : sd_γ.reconstruct = selfModelProduct sm a b := by
    show (∑ i, (α i * β i) • sd.proj i) = selfModelProduct sm a b; exact hab_eq.symm
  conv_rhs => rw [selfModelProduct_any_decomp V sm hab_eff sd_γ hrec_γ c]
  -- Both sides: correctedProduct on shared projections
  -- LHS uses sd_α (eigenvalues α), RHS uses sd_γ (eigenvalues αβ)
  -- Need: correctedProduct(sd_α, correctedProduct(sd_β, c)) = correctedProduct(sd_γ, c)
  show correctedProduct cs sd_α (correctedProduct cs sd_β c) = correctedProduct cs sd_γ c
  unfold correctedProduct
  congr 1
  · -- Diagonal: Σ αᵢ C_{pᵢ}(cp_β(c)) = Σ (αᵢβᵢ) C_{pᵢ}(c)
    congr 1; ext i
    show α i • cs.compress (sd_β.proj i) (correctedProduct cs sd_β c) =
      (α i * β i) • cs.compress (sd_β.proj i) c
    rw [compress_correctedProduct cs sd_β i c, smul_smul]; rfl
  · -- Off-diagonal: √(αᵢαⱼ) P₁(cp_β(c)) = √(αᵢβᵢαⱼβⱼ) P₁(c)
    congr 1; ext i; congr 1; ext j
    split_ifs with h
    · show Real.sqrt (α i * α j) •
            prePeirceOneProj cs (sd_β.proj i) (sd_β.proj j) (correctedProduct cs sd_β c) =
          Real.sqrt (α i * β i * (α j * β j)) •
            prePeirceOneProj cs (sd_β.proj i) (sd_β.proj j) c
      rw [peirce1_correctedProduct V cs sd_β i j (ne_of_lt h) c, smul_smul]
      congr 1
      rw [← Real.sqrt_mul (mul_nonneg (hα_nn i) (hα_nn j))]
      congr 1
      change α i * α j * (β i * β j) = α i * β i * (α j * β j)
      ring
    · rfl

-- S3: Unitality — sp(𝟙, a) = a
-- Construct a decomposition of 𝟙 (n=1, λ=1, p=𝟙) and use selfModelProduct_any_decomp.

/-- Decomposition of 𝟙: n=1, eigenvalue=1, projection=𝟙. -/
noncomputable def unitDecomp {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) : PreSpectralDecomp V cs where
  n := 1
  proj := fun _ => ousUnit
  eigenval := fun _ => 1
  proj_effect := fun _ => isEffect_unit
  eigenval_nonneg := fun _ => zero_le_one
  eigenval_le_one := fun _ => le_refl 1
  proj_orthogonal := fun i j h => absurd (Fin.ext_iff.mpr (by omega)) h
  proj_sum_unit := by simp
  proj_idem := fun _ => cs.compress_unit isEffect_unit
  proj_pair_le_unit := fun i j h => absurd (Fin.ext_iff.mpr (by omega)) h

/-- The unit decomposition reconstructs to 𝟙. -/
theorem unitDecomp_reconstruct {V : Type*} [OrderUnitSpace V]
    (cs : CompressionSystem V) :
    (unitDecomp cs).reconstruct = (ousUnit : V) := by
  unfold unitDecomp PreSpectralDecomp.reconstruct; simp

/-- sp(𝟙, a) = a via the unit decomposition and selfModelProduct_any_decomp. -/
theorem selfModelProduct_unit_left {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a : V} (_ha : IsEffect a) :
    selfModelProduct sm ousUnit a = a := by
  rw [selfModelProduct_any_decomp V sm isEffect_unit (unitDecomp (has_compression V sm))
      (unitDecomp_reconstruct (has_compression V sm)) a]
  rw [correctedProduct_single (has_compression V sm) (unitDecomp (has_compression V sm)) a (by rfl)]
  simp [unitDecomp, (has_compression V sm).compress_unit_id]

/-! ## S7: Compatibility preserved by product -/

/-- **S7 proved**: a|b ∧ a|c → a|sp(b,c).
    Proof: P₁ᵢⱼ^a(sp(b,c)) = sp(b, P₁ᵢⱼ^a(c)) = sp(b, 0) = 0
    using compatible_peirce_sp_commute (a|b) and peirce_vanish (a|c). -/
theorem compatible_preserves_sp_thm {V : Type*} [OrderUnitSpace V]
    (sm : SelfModelingSystem V) {a b c : V}
    (ha : IsEffect a) (hb : IsEffect b) (hc : IsEffect c)
    (hab : selfModelProduct sm a b = selfModelProduct sm b a)
    (hac : selfModelProduct sm a c = selfModelProduct sm c a) :
    selfModelProduct sm a (selfModelProduct sm b c) =
    selfModelProduct sm (selfModelProduct sm b c) a := by
  apply (compatibility_iff_peirce_vanish V sm ha (selfModelProduct_effect sm hb hc)).mpr
  intro i j hij
  rw [compatible_peirce_sp_commute V sm ha hb hab i j hij]
  rw [(compatibility_iff_peirce_vanish V sm ha hc).mp hac i j hij]
  exact selfModelProduct_zero sm b

/-! ## The Bridge Theorem -/

/-- **Self-Modeling Bridge Theorem** (Paper 5, Sections 3-4):
    A self-modeling system gives rise to sequential product data satisfying S1-S7.

    This REPLACES the former bridge axiom. ALL 10 SPData fields are PROVED.
    S2 (monotonicity) proved from selfModelProduct_nonneg (positivity) + linearity.

    Axiom budget: 14 axioms total.
    - 8 clean Alfsen-Shultz 2003 (compression, spectral, Peirce algebra)
    - 5 Alfsen-Shultz referencing our product (compatibility, facial, spectral calculus)
    - 1 our theorem (selfModelProduct_nonneg: PSD coefficient matrix positivity) -/
def self_model_gives_sp_data (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) : SPData V where
  sp := selfModelProduct sm
  sp_add_right := fun {a b c} ha _hb _hc _hbc => by
    unfold selfModelProduct
    exact correctedProduct_add _ _ _ _
  sp_mono_right := fun {a b₁ b₂} ha _hb₁ _hb₂ hle =>
    selfModelProduct_mono sm ha hle
  sp_unit_left := fun {a} ha => selfModelProduct_unit_left sm ha
  sp_zero_symm := fun {a b} ha hb h =>
    orthogonality_symmetry sm ha hb h
  sp_assoc_of_compatible := fun {a b c} ha hb hc hcompat =>
    compatible_assoc_thm sm ha hb hc hcompat
  compatible_ortho := fun {a b} ha hb hcompat => by
    show selfModelProduct sm a (ousUnit - b) = selfModelProduct sm (ousUnit - b) a
    rw [(compatibility_iff_peirce_vanish V sm ha hb.ortho).mpr]
    intro i j hij
    let sd := has_spectral_decomp V sm a ha
    rw [prePeirceOneProj_sub]
    have hvan := (compatibility_iff_peirce_vanish V sm ha hb).mp hcompat i j hij
    -- P₁ᵢⱼ(𝟙) = 0: need pᵢ + pⱼ ≤ 𝟙
    have hpq_le : sd.proj i + sd.proj j ≤ ousUnit := sd.proj_pair_le_unit i j hij
    have hunit := prePeirceOneProj_unit (has_compression V sm) (sd.proj_effect i) (sd.proj_effect j) hpq_le
    rw [hunit, hvan, sub_zero]
  compatible_add := fun {a b c} ha hb hc hbc hab hac => by
    show selfModelProduct sm a (b + c) = selfModelProduct sm (b + c) a
    rw [(compatibility_iff_peirce_vanish V sm ha (hb.add_of_le_unit hc hbc)).mpr]
    intro i j hij
    rw [prePeirceOneProj_add]
    have hvb := (compatibility_iff_peirce_vanish V sm ha hb).mp hab i j hij
    have hvc := (compatibility_iff_peirce_vanish V sm ha hc).mp hac i j hij
    rw [hvb, hvc, add_zero]
  compatible_sp := fun {a b c} ha hb hc hab hac =>
    compatible_preserves_sp_thm sm ha hb hc hab hac
  sp_effect := fun {a b} ha hb => selfModelProduct_effect sm ha hb
  sp_sub_right_general := fun {a b c} ha _hb _hc => by
    unfold selfModelProduct
    exact correctedProduct_sub _ _ _ _

/-! ## The Bridge Instance -/

/-- **Self-Modeling Bridge**: produces a `SequentialProduct` instance. -/
def selfModelingSP (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) : SequentialProduct V :=
  (self_model_gives_sp_data V sm).toSequentialProduct

end
