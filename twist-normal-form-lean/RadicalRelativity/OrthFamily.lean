/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.SequentialProduct
import RadicalRelativity.Necessity.OrderUnitS2
import Mathlib.Data.Fintype.BigOperators

set_option linter.style.longLine false

/-!
# Orthogonal families and the vdW 5.2 value transfer, at abstract order-unit-space generality

Port of the LEDGER 2.1d layer of `Necessity/SharpEffects.lean` from the concrete
`HermitianMat n 𝕜` carrier to an arbitrary `[OrderUnitSpace V]` with an unknown product
`P : SequentialProductOn V` — the last structural blocker on `prop:pseudo-transfer`
(STATEMENT-MANIFEST row 13), whose unknown-product half needs the vdW 5.2 value law at
the generality of an arbitrary Euclidean Jordan algebra carrier.

## The orthogonality hypothesis (design decision)

The concrete theorems state pairwise orthogonality as the **matrix** product
`(p i).mat * (p j).mat = 0`, which no `OrderUnitSpace` can say.  What the proof actually
consumes is strictly order-theoretic, so that is what the abstract version carries:

* `hsharp` — each family member is sharp in the order-theoretic sense of
  `OrderUnitSpace.IsSharp` (no nonzero effect below both `p` and `𝟙 - p`);
* `hsum`   — the single family bound `∑ i ∈ s, p i ≤ 𝟙`.

No Jordan (or any other) product appears in the hypotheses.  Pairwise orthogonality
`p i + p j ≤ 𝟙` is *derived* from `hsum` and nonnegativity, and so are all subfamily
bounds — so this is weaker than the subset-sum `OrderUnitSpace.IsOrthogonalFamily`
(which the `Fin`-indexed corollaries below nevertheless accept directly, since a
spectral resolution satisfies it).

**Nothing is lost on the concrete carrier**: for Hermitian projections the concrete
hypotheses imply the abstract ones — `Necessity.isProjection_isSharp` derives `IsSharp`
from `IsProjection` (via the conjugation pinch `proj_pinch`), and
`Necessity.sum_proj_isProjection` gives `∑ p i ≤ 1` from pairwise matrix orthogonality.
No claim is made (or needed) that the abstract hypotheses imply the matrix ones back;
the abstract statement is simply the weaker-hypothesis generalization.

## Hypothesis accounting

Exactly as in the concrete file: everything up to the compatibility layer is S1, S4, S6a,
S6b and the derived lemmas; S2 (`P.FirstArgContinuous`) enters only through first-argument
homogeneity `sp_smul_left`.  The abstract statements additionally carry
`OrderUnitSpace.IsArchimedean V` — part of the definition of the article's order unit
space that the class deliberately does not bundle (see `OrderUnitSpace.lean`); on the
concrete carrier it is a theorem, which is why the concrete statements do not mention it.

## Contents

* Finite-sum order helpers at bare `OrderUnitSpace` generality (`finsetSum_nonneg`,
  `finsetSum_le_finsetSum`, `finsetSum_le_finsetSum_of_subset`, `isEffect_sum_smul`) —
  the class has no `OrderedAddCommMonoid` instance, so Mathlib's `Finset.sum` order
  lemmas do not apply and these are done by hand from the class fields.
* The Gudder–Greechie sharp-effect layer for `IsSharp`: `sp_sharp_compl`,
  `sp_sharp_self`, `sp_sharp_orth`/`sp_sharp_orth'`, `sp_comm_sharp_orth`.
* The summation layer: `sp_sum_right`, `sp_comm_sum`, `sp_sum_left_of_comm`
  (abstract twins of the same-named `Necessity` theorems; the abstract twin of
  `Necessity.sp_smul_of_mem_unitInterval` already existed as
  `SequentialProductOn.sp_smul_right_of_unitInterval`).
* **`sp_orthFamily_value`** and **`sp_orthFamily_comm`** — the vdW 5.2 value law and
  compatibility transfer, plus `Fin`-indexed corollaries stated with
  `IsOrthogonalFamily` (`sp_orthFamily_value_fin`, `sp_orthFamily_comm_fin`).
* **The pseudo-inverse layer** (`prop:pseudo-transfer`, unknown-product half; port of
  `Necessity/PseudoInverse.lean`): the normalized identities `sp_pseudoInv_eq_smul_one` /
  `sp_pseudoInv_comm` / `sp_pseudoInv_cancel` and the article-form, coefficient-free
  `spCone_specInv_eq_one` / `spConeRight_specInv_eq_one` / `spCone_specInv_both`, over a
  hypothesized complete resolution into sharp effects, with every eigenvalue hypothesis
  guarded at nonzero family members.  `exists_pseudoInvCoef` supplies the normalization;
  `sum_smul_filter_ne` and `isEffect_sum_smul_of_ne` are the support-restriction helpers.

The concrete theorems in `Necessity/SharpEffects.lean` and `Necessity/PseudoInverse.lean`
are left in place untouched; other rows consume them under their matrix-stated hypotheses.
-/

noncomputable section

open OrderUnitSpace

/-! ## Finite-sum order helpers at bare order-unit-space generality -/

namespace OrderUnitSpace

variable {V : Type*} [OrderUnitSpace V]

/-- A finite sum of nonnegative elements is nonnegative.  (`Finset.sum_nonneg` needs an
ordered-monoid instance the class does not carry, so this is done by hand.) -/
theorem finsetSum_nonneg {ι : Type*} {s : Finset ι} {f : ι → V}
    (hf : ∀ i ∈ s, (0 : V) ≤ f i) : (0 : V) ≤ ∑ i ∈ s, f i := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert j s' hj ih =>
    rw [Finset.sum_insert hj]
    exact add_nonneg (hf j (Finset.mem_insert_self j s'))
      (ih fun i hi => hf i (Finset.mem_insert_of_mem hi))

/-- Termwise comparison of finite sums. -/
theorem finsetSum_le_finsetSum {ι : Type*} {s : Finset ι} {f g : ι → V}
    (h : ∀ i ∈ s, f i ≤ g i) : ∑ i ∈ s, f i ≤ ∑ i ∈ s, g i := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert j s' hj ih =>
    rw [Finset.sum_insert hj, Finset.sum_insert hj]
    have h1 : f j + ∑ i ∈ s', f i ≤ g j + ∑ i ∈ s', f i :=
      add_le_add_right' (h j (Finset.mem_insert_self j s')) _
    have h2 : g j + ∑ i ∈ s', f i ≤ g j + ∑ i ∈ s', g i :=
      add_le_add_left _ _ (ih fun i hi => h i (Finset.mem_insert_of_mem hi)) _
    exact le_trans h1 h2

/-- A subfamily of nonnegative elements sums below the full family. -/
theorem finsetSum_le_finsetSum_of_subset {ι : Type*} {s t : Finset ι} {f : ι → V}
    (hst : s ⊆ t) (hf : ∀ i ∈ t, (0 : V) ≤ f i) :
    ∑ i ∈ s, f i ≤ ∑ i ∈ t, f i := by
  classical
  have hsd : ∑ i ∈ t \ s, f i + ∑ i ∈ s, f i = ∑ i ∈ t, f i := Finset.sum_sdiff hst
  have h0 : (0 : V) ≤ ∑ i ∈ t \ s, f i :=
    finsetSum_nonneg fun i hi => hf i (Finset.mem_sdiff.mp hi).1
  calc ∑ i ∈ s, f i ≤ ∑ i ∈ s, f i + ∑ i ∈ t \ s, f i := le_add_of_nonneg_right h0
    _ = ∑ i ∈ t, f i := by rw [add_comm]; exact hsd

/-- Diagonal combinations `∑ λᵢ • pᵢ` with `λᵢ ∈ [0,1]` over a family of effects summing
below the unit are effects.  Abstract twin of `Necessity.sum_smul_proj_isEffect`, with the
matrix-orthogonality route to the bound replaced by the bound itself as hypothesis. -/
theorem isEffect_sum_smul {ι : Type*} {s : Finset ι} {p : ι → V}
    (hp : ∀ i ∈ s, IsEffect (p i)) (hsum : (∑ i ∈ s, p i) ≤ 𝟙)
    {lam : ι → ℝ} (hlam0 : ∀ i ∈ s, 0 ≤ lam i) (hlam1 : ∀ i ∈ s, lam i ≤ 1) :
    IsEffect (∑ i ∈ s, lam i • p i) := by
  refine ⟨finsetSum_nonneg fun i hi => smul_nonneg' (hlam0 i hi) (hp i hi).1, ?_⟩
  refine le_trans (finsetSum_le_finsetSum fun i hi => ?_) hsum
  calc lam i • p i ≤ (1 : ℝ) • p i :=
        smul_le_smul_of_le_of_nonneg (hlam1 i hi) (hp i hi).1
    _ = p i := one_smul ℝ (p i)

end OrderUnitSpace

/-! ## Sharp effects under an unknown product, order-theoretically -/

namespace SequentialProductOn

variable {V : Type*} [OrderUnitSpace V] (P : SequentialProductOn V)

/-- The S1 splitting `p ◦' p + p ◦' (𝟙 - p) = p` for any effect `p`.  Abstract twin of
`Necessity.sp_self_add_compl`. -/
theorem sp_self_add_compl {p : V} (hpe : IsEffect p) :
    P.sp p p + P.sp p (𝟙 - p) = p := by
  have hps : p + ((𝟙 : V) - p) = (𝟙 : V) := by abel
  have hsplit := P.sp_add_right hpe hpe hpe.ortho (le_of_eq hps)
  rw [hps, P.sp_unit_right hpe] at hsplit
  exact hsplit.symm

/-- **A sharp effect annihilates its orthocomplement under any S1,S3–S7 product**:
`p ◦' (𝟙 - p) = 0`.  Abstract twin of `Necessity.sp_proj_compl`, with the
product-independent matrix pinch `proj_pinch` replaced by order-theoretic sharpness
`IsSharp` as hypothesis (on the concrete carrier `Necessity.isProjection_isSharp`
recovers it for projections).  Consumes S6a on the trivial self-compatibility and the
S1 splitting; no S2. -/
theorem sp_sharp_compl {p : V} (hp : IsSharp p) : P.sp p (𝟙 - p) = 0 := by
  have hpe : IsEffect p := hp.1
  have hpc : IsEffect ((𝟙 : V) - p) := hpe.ortho
  have hcompat : P.sp p (𝟙 - p) = P.sp (𝟙 - p) p := P.compatible_ortho hpe hpe rfl
  have hz_le_p : P.sp p (𝟙 - p) ≤ p := by
    have h := eq_sub_of_add_eq' (P.sp_self_add_compl hpe)
    rw [h]
    exact sub_le_self_of_nonneg (P.sp_nonneg hpe hpe)
  have hz_le_pc : P.sp p (𝟙 - p) ≤ 𝟙 - p := by
    rw [hcompat]
    have hsplit := P.sp_self_add_compl hpc
    rw [sub_sub_cancel] at hsplit
    have h := eq_sub_of_add_eq' hsplit
    rw [h]
    exact sub_le_self_of_nonneg (P.sp_nonneg hpc hpc)
  exact hp.2 _ (P.sp_effect hpe hpc) hz_le_p hz_le_pc

/-- **Sharp effects are ◦'-idempotent**: `p ◦' p = p` (Gudder–Greechie sharpness, at
abstract generality).  Abstract twin of `Necessity.sp_proj_self`. -/
theorem sp_sharp_self {p : V} (hp : IsSharp p) : P.sp p p = p := by
  have h := P.sp_self_add_compl hp.1
  rw [P.sp_sharp_compl hp, add_zero] at h
  exact h

/-- **Order-orthogonal effects annihilate a sharp effect**: if `p` is sharp, `q` an
effect, and `p + q ≤ 𝟙` (i.e. `AreOrthogonal p q`), then `p ◦' q = 0`.  Abstract twin
of `Necessity.sp_proj_orth`, with matrix orthogonality replaced by the order condition
(which it implies, via `proj_orth_le_one_sub`). -/
theorem sp_sharp_orth {p q : V} (hp : IsSharp p) (hq : IsEffect q)
    (hpq : p + q ≤ 𝟙) : P.sp p q = 0 := by
  have hqle : q ≤ 𝟙 - p := by
    refine le_of_sub_nonneg ?_
    have h : (𝟙 : V) - p - q = 𝟙 - (p + q) := by abel
    rw [h]
    exact sub_nonneg_of_le hpq
  have hle : P.sp p q ≤ P.sp p (𝟙 - p) :=
    P.sp_mono_right hp.1 hq hp.1.ortho hqle
  rw [P.sp_sharp_compl hp] at hle
  exact le_antisymm hle (P.sp_nonneg hp.1 hq)

/-- The reversed order, by S4.  Abstract twin of `Necessity.sp_proj_orth'`. -/
theorem sp_sharp_orth' {p q : V} (hp : IsSharp p) (hq : IsEffect q)
    (hpq : p + q ≤ 𝟙) : P.sp q p = 0 :=
  P.sp_zero_symm hp.1 hq (P.sp_sharp_orth hp hq hpq)

/-- A sharp effect is ◦'-compatible with every order-orthogonal effect (both products
vanish).  Abstract twin of `Necessity.sp_comm_proj_orth`. -/
theorem sp_comm_sharp_orth {p q : V} (hp : IsSharp p) (hq : IsEffect q)
    (hpq : p + q ≤ 𝟙) : P.sp p q = P.sp q p := by
  rw [P.sp_sharp_orth hp hq hpq, P.sp_sharp_orth' hp hq hpq]

/-! ## The summation layer -/

/-- Second-argument additivity over finite families of effects with a dominated sum.
Abstract twin of `Necessity.sp_sum_right` (iterated S1). -/
theorem sp_sum_right {a : V} (ha : IsEffect a) {ι : Type*}
    {s : Finset ι} {g : ι → V}
    (hg : ∀ i ∈ s, IsEffect (g i)) (hall : (∑ i ∈ s, g i) ≤ 𝟙) :
    P.sp a (∑ i ∈ s, g i) = ∑ i ∈ s, P.sp a (g i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [P.sp_zero_right ha]
  | insert j s' hj ih =>
    rw [Finset.sum_insert hj] at hall
    have hgj : IsEffect (g j) := hg j (Finset.mem_insert_self j s')
    have hg' : ∀ i ∈ s', IsEffect (g i) := fun i hi => hg i (Finset.mem_insert_of_mem hi)
    have hsum' : (∑ i ∈ s', g i) ≤ (𝟙 : V) := by
      refine le_trans ?_ hall
      calc (∑ i ∈ s', g i) ≤ (∑ i ∈ s', g i) + g j := le_add_of_nonneg_right hgj.1
        _ = g j + ∑ i ∈ s', g i := add_comm _ _
    have hs'eff : IsEffect (∑ i ∈ s', g i) :=
      ⟨finsetSum_nonneg fun i hi => (hg' i hi).1, hsum'⟩
    rw [Finset.sum_insert hj, P.sp_add_right ha hgj hs'eff hall, ih hg' hsum',
      Finset.sum_insert hj]

/-- Compatibility with each summand gives compatibility with the sum (iterated S6b).
Abstract twin of `Necessity.sp_comm_sum`. -/
theorem sp_comm_sum {c : V} (hc : IsEffect c) {ι : Type*}
    {s : Finset ι} {g : ι → V}
    (hg : ∀ i ∈ s, IsEffect (g i)) (hall : (∑ i ∈ s, g i) ≤ 𝟙)
    (hcomm : ∀ i ∈ s, P.sp (g i) c = P.sp c (g i)) :
    P.sp (∑ i ∈ s, g i) c = P.sp c (∑ i ∈ s, g i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [P.sp_zero_right hc, P.sp_zero_left hc]
  | insert j s' hj ih =>
    rw [Finset.sum_insert hj] at hall ⊢
    have hgj : IsEffect (g j) := hg j (Finset.mem_insert_self j s')
    have hg' : ∀ i ∈ s', IsEffect (g i) := fun i hi => hg i (Finset.mem_insert_of_mem hi)
    have hsum' : (∑ i ∈ s', g i) ≤ (𝟙 : V) := by
      refine le_trans ?_ hall
      calc (∑ i ∈ s', g i) ≤ (∑ i ∈ s', g i) + g j := le_add_of_nonneg_right hgj.1
        _ = g j + ∑ i ∈ s', g i := add_comm _ _
    have hs'eff : IsEffect (∑ i ∈ s', g i) :=
      ⟨finsetSum_nonneg fun i hi => (hg' i hi).1, hsum'⟩
    have hcomm' : ∀ i ∈ s', P.sp (g i) c = P.sp c (g i) :=
      fun i hi => hcomm i (Finset.mem_insert_of_mem hi)
    exact (P.compatible_add hc hgj hs'eff hall
      (hcomm j (Finset.mem_insert_self j s')).symm (ih hg' hsum' hcomm').symm).symm

/-- First-argument additivity over finite ◦'-compatible families.  Abstract twin of
`Necessity.sp_sum_left_of_comm`. -/
theorem sp_sum_left_of_comm {c : V} (hc : IsEffect c) {ι : Type*}
    {s : Finset ι} {g : ι → V}
    (hg : ∀ i ∈ s, IsEffect (g i)) (hall : (∑ i ∈ s, g i) ≤ 𝟙)
    (hcomm : ∀ i ∈ s, P.sp (g i) c = P.sp c (g i)) :
    P.sp (∑ i ∈ s, g i) c = ∑ i ∈ s, P.sp (g i) c := by
  rw [P.sp_comm_sum hc hg hall hcomm, P.sp_sum_right hc hg hall]
  exact Finset.sum_congr rfl fun i hi => (hcomm i hi).symm

/-! ## The vdW 5.2 value law and compatibility transfer -/

/-- **The vdW 5.2 value law at abstract order-unit-space generality**: over a family of
sharp effects summing below the unit, any S1–S7+S2 product takes the standard diagonal
value: `(∑ λᵢ•pᵢ) ◦' (∑ μᵢ•pᵢ) = ∑ (λᵢμᵢ)•pᵢ`.

Abstract twin of `Necessity.sp_orthFamily_value`.  The concrete matrix-orthogonality
hypothesis is replaced by the two order-theoretic facts the proof consumes — `IsSharp`
membership and the family bound `∑ i ∈ s, p i ≤ 𝟙` (pairwise orthogonality
`p i + p j ≤ 𝟙` is derived from the bound; see the module docstring for the concrete
bridge and for why no Jordan product is needed).  `IsArchimedean` is part of the
article's order-unit-space definition (not bundled in the class); S2 enters only
through `sp_smul_left`. -/
theorem sp_orthFamily_value (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {p : ι → V}
    (hsharp : ∀ i ∈ s, IsSharp (p i)) (hsum : (∑ i ∈ s, p i) ≤ 𝟙)
    {lam mu : ι → ℝ}
    (hlam0 : ∀ i ∈ s, 0 ≤ lam i) (hlam1 : ∀ i ∈ s, lam i ≤ 1)
    (hmu0 : ∀ i ∈ s, 0 ≤ mu i) (hmu1 : ∀ i ∈ s, mu i ≤ 1) :
    P.sp (∑ i ∈ s, lam i • p i) (∑ i ∈ s, mu i • p i)
      = ∑ i ∈ s, (lam i * mu i) • p i := by
  classical
  have hpe : ∀ i ∈ s, IsEffect (p i) := fun i hi => (hsharp i hi).1
  -- pairwise order-orthogonality, derived from the family bound
  have horth : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → p i + p j ≤ (𝟙 : V) := by
    intro i hi j hj hij
    have hpair : ({i, j} : Finset ι) ⊆ s :=
      Finset.insert_subset_iff.mpr ⟨hi, Finset.singleton_subset_iff.mpr hj⟩
    have h := finsetSum_le_finsetSum_of_subset hpair fun k hk => (hpe k hk).1
    rw [Finset.sum_pair hij] at h
    exact le_trans h hsum
  have ha : IsEffect (∑ i ∈ s, lam i • p i) := isEffect_sum_smul hpe hsum hlam0 hlam1
  -- the first argument against a single family member
  have hkey : ∀ j ∈ s, P.sp (∑ i ∈ s, lam i • p i) (p j) = lam j • p j := by
    intro j hj
    have hpj : IsEffect (p j) := hpe j hj
    have hcomm : ∀ i ∈ s, P.sp (lam i • p i) (p j) = P.sp (p j) (lam i • p i) := by
      intro i hi
      have hpi : IsEffect (p i) := hpe i hi
      have hbase : P.sp (p i) (p j) = P.sp (p j) (p i) := by
        rcases eq_or_ne i j with rfl | hij
        · rfl
        · exact P.sp_comm_sharp_orth (hsharp i hi) hpj (horth i hi j hj hij)
      rw [P.sp_smul_left harch hS2 hpi hpj (hlam0 i hi) (hlam1 i hi),
        P.sp_smul_right_of_unitInterval harch hpj hpi (hlam0 i hi) (hlam1 i hi), hbase]
    have hge : ∀ i ∈ s, IsEffect (lam i • p i) :=
      fun i hi => isEffect_smul (hlam0 i hi) (hlam1 i hi) (hpe i hi)
    rw [P.sp_sum_left_of_comm hpj hge ha.2 hcomm]
    -- collapse: only the j-term survives
    rw [Finset.sum_eq_single_of_mem j hj]
    · rw [P.sp_smul_left harch hS2 hpj hpj (hlam0 j hj) (hlam1 j hj),
        P.sp_sharp_self (hsharp j hj)]
    · intro i hi hij
      rw [P.sp_smul_left harch hS2 (hpe i hi) hpj (hlam0 i hi) (hlam1 i hi),
        P.sp_sharp_orth (hsharp i hi) hpj (horth i hi j hj hij), smul_zero]
  -- expand the second argument
  have hmu_eff : ∀ i ∈ s, IsEffect (mu i • p i) :=
    fun i hi => isEffect_smul (hmu0 i hi) (hmu1 i hi) (hpe i hi)
  have hmu_le : (∑ i ∈ s, mu i • p i) ≤ (𝟙 : V) :=
    (isEffect_sum_smul hpe hsum hmu0 hmu1).2
  rw [P.sp_sum_right ha hmu_eff hmu_le]
  refine Finset.sum_congr rfl fun j hj => ?_
  rw [P.sp_smul_right_of_unitInterval harch ha (hpe j hj) (hmu0 j hj) (hmu1 j hj),
    hkey j hj, smul_smul, mul_comm]

/-- **The vdW 5.2 compatibility transfer at abstract generality**: two effects diagonal
in one family of sharp effects summing below the unit are ◦'-compatible.  Abstract twin
of `Necessity.sp_orthFamily_comm`. -/
theorem sp_orthFamily_comm (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {p : ι → V}
    (hsharp : ∀ i ∈ s, IsSharp (p i)) (hsum : (∑ i ∈ s, p i) ≤ 𝟙)
    {lam mu : ι → ℝ}
    (hlam0 : ∀ i ∈ s, 0 ≤ lam i) (hlam1 : ∀ i ∈ s, lam i ≤ 1)
    (hmu0 : ∀ i ∈ s, 0 ≤ mu i) (hmu1 : ∀ i ∈ s, mu i ≤ 1) :
    P.sp (∑ i ∈ s, lam i • p i) (∑ i ∈ s, mu i • p i)
      = P.sp (∑ i ∈ s, mu i • p i) (∑ i ∈ s, lam i • p i) := by
  rw [P.sp_orthFamily_value harch hS2 hsharp hsum hlam0 hlam1 hmu0 hmu1,
    P.sp_orthFamily_value harch hS2 hsharp hsum hmu0 hmu1 hlam0 hlam1]
  exact Finset.sum_congr rfl fun i _ => by rw [mul_comm]

/-- The value law in vdW's own `E₀` vocabulary: a `Fin`-indexed `IsOrthogonalFamily`
of sharp effects (the shape of a spectral decomposition, cf. `IsSimpleEffect`). -/
theorem sp_orthFamily_value_fin (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {m : ℕ} {p : Fin m → V} (hfam : IsOrthogonalFamily p) (hsharp : ∀ i, IsSharp (p i))
    {lam mu : Fin m → ℝ}
    (hlam0 : ∀ i, 0 ≤ lam i) (hlam1 : ∀ i, lam i ≤ 1)
    (hmu0 : ∀ i, 0 ≤ mu i) (hmu1 : ∀ i, mu i ≤ 1) :
    P.sp (∑ i, lam i • p i) (∑ i, mu i • p i) = ∑ i, (lam i * mu i) • p i :=
  P.sp_orthFamily_value harch hS2 (fun i _ => hsharp i) (hfam.2 Finset.univ)
    (fun i _ => hlam0 i) (fun i _ => hlam1 i) (fun i _ => hmu0 i) (fun i _ => hmu1 i)

/-- The compatibility transfer in vdW's own `E₀` vocabulary. -/
theorem sp_orthFamily_comm_fin (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {m : ℕ} {p : Fin m → V} (hfam : IsOrthogonalFamily p) (hsharp : ∀ i, IsSharp (p i))
    {lam mu : Fin m → ℝ}
    (hlam0 : ∀ i, 0 ≤ lam i) (hlam1 : ∀ i, lam i ≤ 1)
    (hmu0 : ∀ i, 0 ≤ mu i) (hmu1 : ∀ i, mu i ≤ 1) :
    P.sp (∑ i, lam i • p i) (∑ i, mu i • p i)
      = P.sp (∑ i, mu i • p i) (∑ i, lam i • p i) :=
  P.sp_orthFamily_comm harch hS2 (fun i _ => hsharp i) (hfam.2 Finset.univ)
    (fun i _ => hlam0 i) (fun i _ => hlam1 i) (fun i _ => hmu0 i) (fun i _ => hmu1 i)

end SequentialProductOn

/-! ## The pseudo-inverse layer: `prop:pseudo-transfer`, unknown-product half

Port of the LEDGER 2.1e layer of `Necessity/PseudoInverse.lean` — the normalized identities
`ν ◦' b = b ◦' ν = c•𝟙` (`sp_pseudoInv_eq_smul_one`, `sp_pseudoInv_comm`), the cancellation
`ν ◦' (b ◦' x) = c•x` (`sp_pseudoInv_cancel`), and the article-form, coefficient-free
`b⁻¹ · b = b · b⁻¹ = 𝟙` through the cone extensions (`spCone_specInv_eq_one`,
`spConeRight_specInv_eq_one`) — from the concrete carrier to the same `[OrderUnitSpace V]`
generality as the value law above.  This is the **unknown-product half** of
`STATEMENT-MANIFEST.md` row 13; the standard-product half is `EJA/Spectral.lean`'s
`luders_jsqrt_jinv`, and the statements here are resolution-relative in exactly the same
sense as that one.

Three deliberate differences from the concrete statements, all in the hypotheses:

1. **The spectral data is hypothesized, not computed.**  The concrete `b.eigFinset` /
   `b.specProj μ` become a family `c : ι → V` of `IsSharp` effects with completeness
   `∑ i ∈ s, c i = 𝟙` and a resolution `b = ∑ i ∈ s, lam i • c i` — the shape
   `EJA.exists_resolution_distinct` produces (its idempotents are sharp for the constructed
   order by `EJA.isSharpOrderUnit_of_idem`, and its completeness lands on `𝟙` by
   `EJA.ousUnit_ofBilinear`).  As with the value law, no Jordan product appears.

2. ★ **Every eigenvalue hypothesis is guarded at nonzero family members** (`c i ≠ 0 → …`).
   An abstract resolution can carry `c i = 0` with an unconstrained coefficient —
   `0 • 0 = 37 • 0` — so the universal form is not dischargeable from the cone
   (`EJA/Order.lean`'s `nonneg_coeff_of_isSoS` speaks only at nonzero idempotents), while
   the guarded form is.  Inside the proofs the sums are restricted to the support
   (`sum_smul_filter_ne`), where the guards become the unguarded bounds the value law wants.
   The concrete statements had no such guard because `eigFinset` indexes actual eigenvalues
   and `PosDef` speaks about all of them; the abstract guard costs the concrete consumer
   nothing (it may ignore the premise `c i ≠ 0`).

3. **The normalization is any admissible constant, not a fixed product.**  Instead of
   `pseudoInvCoef b = ∏ μ`, the theorems take any `co` with `0 ≤ co` (and `co ≤ 1` where
   used) and `co ≤ lam i` on the support.  `exists_pseudoInvCoef` shows the constraint set
   is inhabited — by the product of the eigenvalues **over the support**, via the same
   product-of-unit-interval arithmetic as the concrete `pseudoInvCoef_le`, and like it with
   no nonemptiness side condition (an empty support gives `co = 1`, and then `𝟙 = 0`
   degenerately).  In the article-form theorems `co` is internal and the statements carry
   no normalization at all.

As everywhere in this file, `IsArchimedean V` is carried explicitly (part of the article's
order-unit-space definition, deliberately not bundled in the class), and S2 enters only
through `sp_smul_left` and the value law.  The concrete theorems in
`Necessity/PseudoInverse.lean` are left in place untouched. -/

namespace OrderUnitSpace

variable {V : Type*} [OrderUnitSpace V]

/-- Terms at a vanishing family member drop from a diagonal combination: the sum restricts
to the support of the family.  This is what lets guarded coefficient hypotheses replace
universal ones. -/
theorem sum_smul_filter_ne {ι : Type*} (s : Finset ι) (g : ι → ℝ) (p : ι → V)
    [DecidablePred fun i => p i ≠ 0] :
    ∑ i ∈ s.filter (fun i => p i ≠ 0), g i • p i = ∑ i ∈ s, g i • p i :=
  Finset.sum_filter_of_ne fun i _ hne hp0 => hne (by rw [hp0, smul_zero])

/-- `isEffect_sum_smul` with the coefficient bounds required only at **nonzero** members —
the form dischargeable from the cone, where a coefficient at a zero member is
unconstrained and its term contributes nothing. -/
theorem isEffect_sum_smul_of_ne {ι : Type*} {s : Finset ι} {p : ι → V}
    (hp : ∀ i ∈ s, IsEffect (p i)) (hsum : (∑ i ∈ s, p i) ≤ 𝟙)
    {lam : ι → ℝ} (hlam0 : ∀ i ∈ s, p i ≠ 0 → 0 ≤ lam i)
    (hlam1 : ∀ i ∈ s, p i ≠ 0 → lam i ≤ 1) :
    IsEffect (∑ i ∈ s, lam i • p i) := by
  classical
  rw [← sum_smul_filter_ne s lam p]
  have hsub : s.filter (fun i => p i ≠ 0) ⊆ s := Finset.filter_subset _ _
  exact isEffect_sum_smul (fun i hi => hp i (hsub hi))
    (le_trans (finsetSum_le_finsetSum_of_subset hsub fun i hi => (hp i hi).1) hsum)
    (fun i hi => hlam0 i (hsub hi) (Finset.mem_filter.mp hi).2)
    (fun i hi => hlam1 i (hsub hi) (Finset.mem_filter.mp hi).2)

end OrderUnitSpace

namespace SequentialProductOn

variable {V : Type*} [OrderUnitSpace V] (P : SequentialProductOn V)

/-- **An admissible normalization always exists**: the product of the eigenvalues over the
support.  Abstract twin of the `pseudoInvCoef` lemmas (`pseudoInvCoef_pos`,
`pseudoInvCoef_le_one`, `pseudoInvCoef_le`) — the same product-of-unit-interval real
arithmetic, restricted to the support so that garbage coefficients at zero members never
enter the product, and as in the concrete version with no nonemptiness side condition. -/
theorem exists_pseudoInvCoef {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1) :
    ∃ co : ℝ, 0 < co ∧ co ≤ 1 ∧ ∀ i ∈ s, c i ≠ 0 → co ≤ lam i := by
  classical
  have hsub : s.filter (fun j => c j ≠ 0) ⊆ s := Finset.filter_subset _ _
  have hpos' : ∀ i ∈ s.filter (fun j => c j ≠ 0), 0 < lam i := fun i hi =>
    hpos i (hsub hi) (Finset.mem_filter.mp hi).2
  have hle1' : ∀ i ∈ s.filter (fun j => c j ≠ 0), lam i ≤ 1 := fun i hi =>
    hle1 i (hsub hi) (Finset.mem_filter.mp hi).2
  refine ⟨∏ i ∈ s.filter (fun j => c j ≠ 0), lam i, Finset.prod_pos hpos',
    Finset.prod_le_one (fun i hi => (hpos' i hi).le) hle1', ?_⟩
  intro i his hine
  have hit : i ∈ s.filter (fun j => c j ≠ 0) := Finset.mem_filter.mpr ⟨his, hine⟩
  have herase : ∏ j ∈ (s.filter (fun j => c j ≠ 0)).erase i, lam j ≤ 1 :=
    Finset.prod_le_one (fun j hj => (hpos' j (Finset.mem_of_mem_erase hj)).le)
      (fun j hj => hle1' j (Finset.mem_of_mem_erase hj))
  rw [← Finset.mul_prod_erase (s.filter (fun j => c j ≠ 0)) lam hit]
  calc lam i * ∏ j ∈ (s.filter (fun j => c j ≠ 0)).erase i, lam j
      ≤ lam i * 1 := mul_le_mul_of_nonneg_left herase (hpos' i hit).le
    _ = lam i := mul_one _

/-- The value computation over a clean resolution (every hypothesis unguarded); the public
theorems restrict to the support and apply this. -/
private theorem sp_pseudoInv_value_aux (harch : IsArchimedean V)
    (hS2 : P.FirstArgContinuous) {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, 0 < lam i) (hle1 : ∀ i ∈ s, lam i ≤ 1)
    {co : ℝ} (hco0 : 0 ≤ co) (hcole : ∀ i ∈ s, co ≤ lam i) :
    P.sp (∑ i ∈ s, (co / lam i) • c i) (∑ i ∈ s, lam i • c i) = co • (𝟙 : V) := by
  have hdiv0 : ∀ i ∈ s, 0 ≤ co / lam i := fun i hi => div_nonneg hco0 (hpos i hi).le
  have hdiv1 : ∀ i ∈ s, co / lam i ≤ 1 := fun i hi =>
    (div_le_one (hpos i hi)).mpr (hcole i hi)
  have hmu0 : ∀ i ∈ s, 0 ≤ lam i := fun i hi => (hpos i hi).le
  have hval := P.sp_orthFamily_value harch hS2 hsharp (le_of_eq hsum) hdiv0 hdiv1 hmu0 hle1
  rw [hval]
  calc ∑ i ∈ s, (co / lam i * lam i) • c i
      = ∑ i ∈ s, co • c i :=
        Finset.sum_congr rfl fun i hi => by rw [div_mul_cancel₀ _ (hpos i hi).ne']
    _ = co • ∑ i ∈ s, c i := (Finset.smul_sum).symm
    _ = co • (𝟙 : V) := by rw [hsum]

/-- The compatibility transfer over a clean resolution (every hypothesis unguarded). -/
private theorem sp_pseudoInv_comm_aux (harch : IsArchimedean V)
    (hS2 : P.FirstArgContinuous) {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, 0 < lam i) (hle1 : ∀ i ∈ s, lam i ≤ 1)
    {co : ℝ} (hco0 : 0 ≤ co) (hcole : ∀ i ∈ s, co ≤ lam i) :
    P.sp (∑ i ∈ s, (co / lam i) • c i) (∑ i ∈ s, lam i • c i)
      = P.sp (∑ i ∈ s, lam i • c i) (∑ i ∈ s, (co / lam i) • c i) := by
  have hdiv0 : ∀ i ∈ s, 0 ≤ co / lam i := fun i hi => div_nonneg hco0 (hpos i hi).le
  have hdiv1 : ∀ i ∈ s, co / lam i ≤ 1 := fun i hi =>
    (div_le_one (hpos i hi)).mpr (hcole i hi)
  have hmu0 : ∀ i ∈ s, 0 ≤ lam i := fun i hi => (hpos i hi).le
  exact P.sp_orthFamily_comm harch hS2 hsharp (le_of_eq hsum) hdiv0 hdiv1 hmu0 hle1

/-- **The pseudo-inverse identity `ν ◦' b = c•𝟙` at abstract order-unit-space generality.**
Abstract twin of `Necessity.sp_pseudoInv_eq_smul_one`; see the section docstring for the
three hypothesis differences (hypothesized sharp resolution, guards at nonzero members,
abstract normalization `co`). -/
theorem sp_pseudoInv_eq_smul_one (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1)
    {co : ℝ} (hco0 : 0 ≤ co) (hcole : ∀ i ∈ s, c i ≠ 0 → co ≤ lam i) :
    P.sp (∑ i ∈ s, (co / lam i) • c i) (∑ i ∈ s, lam i • c i) = co • (𝟙 : V) := by
  classical
  have hsub : s.filter (fun j => c j ≠ 0) ⊆ s := Finset.filter_subset _ _
  have hmem : ∀ i ∈ s.filter (fun j => c j ≠ 0), c i ≠ 0 :=
    fun i hi => (Finset.mem_filter.mp hi).2
  have hcsum : (∑ i ∈ s.filter (fun j => c j ≠ 0), c i) = 𝟙 :=
    (Finset.sum_filter_of_ne fun i _ h => h).trans hsum
  have e1 : (∑ i ∈ s, (co / lam i) • c i)
      = ∑ i ∈ s.filter (fun j => c j ≠ 0), (co / lam i) • c i :=
    (sum_smul_filter_ne s (fun i => co / lam i) c).symm
  have e2 : (∑ i ∈ s, lam i • c i)
      = ∑ i ∈ s.filter (fun j => c j ≠ 0), lam i • c i :=
    (sum_smul_filter_ne s lam c).symm
  rw [e1, e2]
  exact sp_pseudoInv_value_aux P harch hS2 (fun i hi => hsharp i (hsub hi)) hcsum
    (fun i hi => hpos i (hsub hi) (hmem i hi)) (fun i hi => hle1 i (hsub hi) (hmem i hi))
    hco0 (fun i hi => hcole i (hsub hi) (hmem i hi))

/-- **The reverse order**: `ν` and `b` are ◦'-compatible.  Abstract twin of
`Necessity.sp_pseudoInv_comm`. -/
theorem sp_pseudoInv_comm (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1)
    {co : ℝ} (hco0 : 0 ≤ co) (hcole : ∀ i ∈ s, c i ≠ 0 → co ≤ lam i) :
    P.sp (∑ i ∈ s, (co / lam i) • c i) (∑ i ∈ s, lam i • c i)
      = P.sp (∑ i ∈ s, lam i • c i) (∑ i ∈ s, (co / lam i) • c i) := by
  classical
  have hsub : s.filter (fun j => c j ≠ 0) ⊆ s := Finset.filter_subset _ _
  have hmem : ∀ i ∈ s.filter (fun j => c j ≠ 0), c i ≠ 0 :=
    fun i hi => (Finset.mem_filter.mp hi).2
  have hcsum : (∑ i ∈ s.filter (fun j => c j ≠ 0), c i) = 𝟙 :=
    (Finset.sum_filter_of_ne fun i _ h => h).trans hsum
  have e1 : (∑ i ∈ s, (co / lam i) • c i)
      = ∑ i ∈ s.filter (fun j => c j ≠ 0), (co / lam i) • c i :=
    (sum_smul_filter_ne s (fun i => co / lam i) c).symm
  have e2 : (∑ i ∈ s, lam i • c i)
      = ∑ i ∈ s.filter (fun j => c j ≠ 0), lam i • c i :=
    (sum_smul_filter_ne s lam c).symm
  rw [e1, e2]
  exact sp_pseudoInv_comm_aux P harch hS2 (fun i hi => hsharp i (hsub hi)) hcsum
    (fun i hi => hpos i (hsub hi) (hmem i hi)) (fun i hi => hle1 i (hsub hi) (hmem i hi))
    hco0 (fun i hi => hcole i (hsub hi) (hmem i hi))

/-- **The cancellation identity `ν ◦' (b ◦' x) = c•x` on effects**, by S5 through the
compatibility, first-argument homogeneity, and S3.  Abstract twin of
`Necessity.sp_pseudoInv_cancel`; `co ≤ 1` is the one constraint on the normalization this
theorem uses beyond its siblings (the concrete `pseudoInvCoef_le_one`). -/
theorem sp_pseudoInv_cancel (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1)
    {co : ℝ} (hco0 : 0 ≤ co) (hco1 : co ≤ 1) (hcole : ∀ i ∈ s, c i ≠ 0 → co ≤ lam i)
    {x : V} (hx : IsEffect x) :
    P.sp (∑ i ∈ s, (co / lam i) • c i) (P.sp (∑ i ∈ s, lam i • c i) x) = co • x := by
  have hce : ∀ i ∈ s, IsEffect (c i) := fun i hi => (hsharp i hi).1
  have hν : IsEffect (∑ i ∈ s, (co / lam i) • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => div_nonneg hco0 (hpos i hi hne).le)
      (fun i hi hne => (div_le_one (hpos i hi hne)).mpr (hcole i hi hne))
  have hbe : IsEffect (∑ i ∈ s, lam i • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => (hpos i hi hne).le) hle1
  rw [P.sp_assoc_of_compatible hν hbe hx
      (P.sp_pseudoInv_comm harch hS2 hsharp hsum hpos hle1 hco0 hcole),
    P.sp_pseudoInv_eq_smul_one harch hS2 hsharp hsum hpos hle1 hco0 hcole,
    P.sp_smul_left harch hS2 isEffect_unit hx hco0 hco1, P.sp_unit_left hx]

/-- **`prop:pseudo-transfer`, first slot, at the article's own normalization and at
abstract order-unit-space generality**: the cone-extended unknown product satisfies
`b⁻¹ · b = 𝟙` with the true spectral inverse `∑ (lam i)⁻¹ • c i` and **no** coefficient.
Abstract twin of `Necessity.spCone_specInv_eq_one`; the normalization is produced by
`exists_pseudoInvCoef` and divides out. -/
theorem spCone_specInv_eq_one (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1) :
    P.spCone (∑ i ∈ s, (lam i)⁻¹ • c i) (∑ i ∈ s, lam i • c i) = 𝟙 := by
  obtain ⟨co, hco0, hco1, hcole⟩ := exists_pseudoInvCoef hpos hle1
  have hce : ∀ i ∈ s, IsEffect (c i) := fun i hi => (hsharp i hi).1
  have hν : IsEffect (∑ i ∈ s, (co / lam i) • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => div_nonneg hco0.le (hpos i hi hne).le)
      (fun i hi hne => (div_le_one (hpos i hi hne)).mpr (hcole i hi hne))
  have hbe : IsEffect (∑ i ∈ s, lam i • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => (hpos i hi hne).le) hle1
  have hkey : (∑ i ∈ s, (lam i)⁻¹ • c i) = co⁻¹ • ∑ i ∈ s, (co / lam i) • c i := by
    rw [Finset.smul_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [smul_smul, div_eq_mul_inv, ← mul_assoc, inv_mul_cancel₀ hco0.ne', one_mul]
  have hw0 : (0 : V) ≤ ∑ i ∈ s, (lam i)⁻¹ • c i := by
    rw [hkey]
    exact smul_nonneg' (inv_nonneg.mpr hco0.le) hν.1
  have hnorm : IsConeNorm (∑ i ∈ s, (lam i)⁻¹ • c i) co⁻¹ := by
    refine ⟨inv_pos.mpr hco0, ?_⟩
    rw [hkey, smul_smul, inv_inv, mul_inv_cancel₀ hco0.ne', one_smul]
    exact hν
  rw [P.spCone_eq harch hS2 hw0 hnorm hbe, hkey, smul_smul, inv_inv,
    mul_inv_cancel₀ hco0.ne', one_smul,
    P.sp_pseudoInv_eq_smul_one harch hS2 hsharp hsum hpos hle1 hco0.le hcole,
    smul_smul, inv_mul_cancel₀ hco0.ne', one_smul]

/-- **`prop:pseudo-transfer`, second slot**: `b · b⁻¹ = 𝟙` through the right-slot cone
extension.  Abstract twin of `Necessity.spConeRight_specInv_eq_one`.  As there, the
right-slot *extension* needs no S2, but this identity consumes S2 through
`sp_pseudoInv_comm` and `sp_pseudoInv_eq_smul_one`. -/
theorem spConeRight_specInv_eq_one (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1) :
    P.spConeRight (∑ i ∈ s, lam i • c i) (∑ i ∈ s, (lam i)⁻¹ • c i) = 𝟙 := by
  obtain ⟨co, hco0, hco1, hcole⟩ := exists_pseudoInvCoef hpos hle1
  have hce : ∀ i ∈ s, IsEffect (c i) := fun i hi => (hsharp i hi).1
  have hν : IsEffect (∑ i ∈ s, (co / lam i) • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => div_nonneg hco0.le (hpos i hi hne).le)
      (fun i hi hne => (div_le_one (hpos i hi hne)).mpr (hcole i hi hne))
  have hbe : IsEffect (∑ i ∈ s, lam i • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => (hpos i hi hne).le) hle1
  have hkey : (∑ i ∈ s, (lam i)⁻¹ • c i) = co⁻¹ • ∑ i ∈ s, (co / lam i) • c i := by
    rw [Finset.smul_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [smul_smul, div_eq_mul_inv, ← mul_assoc, inv_mul_cancel₀ hco0.ne', one_mul]
  have hw0 : (0 : V) ≤ ∑ i ∈ s, (lam i)⁻¹ • c i := by
    rw [hkey]
    exact smul_nonneg' (inv_nonneg.mpr hco0.le) hν.1
  have hnorm : IsConeNorm (∑ i ∈ s, (lam i)⁻¹ • c i) co⁻¹ := by
    refine ⟨inv_pos.mpr hco0, ?_⟩
    rw [hkey, smul_smul, inv_inv, mul_inv_cancel₀ hco0.ne', one_smul]
    exact hν
  rw [P.spConeRight_eq harch hbe hw0 hnorm, hkey, smul_smul, inv_inv,
    mul_inv_cancel₀ hco0.ne', one_smul,
    ← P.sp_pseudoInv_comm harch hS2 hsharp hsum hpos hle1 hco0.le hcole,
    P.sp_pseudoInv_eq_smul_one harch hS2 hsharp hsum hpos hle1 hco0.le hcole,
    smul_smul, inv_mul_cancel₀ hco0.ne', one_smul]

/-- **Both slots at once** — the article's `prop:pseudo-transfer` identity as it is
stated, at abstract order-unit-space generality.  Abstract twin of
`Necessity.spCone_specInv_both`. -/
theorem spCone_specInv_both (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1) :
    P.spCone (∑ i ∈ s, (lam i)⁻¹ • c i) (∑ i ∈ s, lam i • c i) = 𝟙 ∧
      P.spConeRight (∑ i ∈ s, lam i • c i) (∑ i ∈ s, (lam i)⁻¹ • c i) = 𝟙 :=
  ⟨P.spCone_specInv_eq_one harch hS2 hsharp hsum hpos hle1,
    P.spConeRight_specInv_eq_one harch hS2 hsharp hsum hpos hle1⟩

/-! ### Order reflection and injectivity of the left multiplication (vdW 4.19)

Port of the payoff layer of `Necessity/PseudoInverse.lean` — the linear-map cancellation
`L'_ν ∘ L'_b = co·id` (`Necessity.seqLeftMul_pseudoInv_comp`), order reflection
(`Necessity.seqLeftMul_reflectsNonneg`, vdW 4.19) and injectivity
(`Necessity.seqLeftMul_injective`) of the left multiplication by an invertible effect —
at the same resolution-relative hypotheses as the pseudo-inverse layer above.  The left
multiplication is `seqLeftMulAbs`, `Necessity/OrderUnitS2.lean`'s `lem:homog`(i) linear
extension (whence this file's import of that module); its agreement with the product on
effects (`seqLeftMulAbs_apply_effect`) and its positivity (`seqLeftMulAbs_nonneg`)
replace the concrete `seqLeftMul_apply_effect` / `seqLeftMul_nonneg`, and the extension
from effects to all of `V` is `lem:span`'s extensionality clause
(`linearMap_eq_of_eq_on_effects`), exactly as in the concrete proof.

One hypothesis-shape difference beyond the section's standard three: `seqLeftMulAbs`
carries its effect-hood proof *in the statement*, so the effect-hood of `b` (and, in the
cancellation, of `ν`) appears as an explicit hypothesis rather than as an inline derived
term as in the concrete statements.  Both are derivable from the resolution data by
`isEffect_sum_smul_of_ne`; by proof irrelevance the statements do not depend on which
proof the caller supplies.  In the reflection and injectivity theorems the normalization
`co` is internal, produced by `exists_pseudoInvCoef`. -/

/-- **The linear-map cancellation `L'_ν ∘ L'_b = co·id`** at abstract order-unit-space
generality: abstract twin of `Necessity.seqLeftMul_pseudoInv_comp`, extended from the
effects by `lem:span`'s extensionality clause. -/
theorem seqLeftMulAbs_pseudoInv_comp (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1)
    {co : ℝ} (hco0 : 0 ≤ co) (hco1 : co ≤ 1) (hcole : ∀ i ∈ s, c i ≠ 0 → co ≤ lam i)
    (hν : IsEffect (∑ i ∈ s, (co / lam i) • c i))
    (hb : IsEffect (∑ i ∈ s, lam i • c i)) :
    (seqLeftMulAbs P harch hν).comp (seqLeftMulAbs P harch hb) = co • LinearMap.id := by
  refine linearMap_eq_of_eq_on_effects _ _ fun e he => ?_
  simp only [LinearMap.comp_apply, LinearMap.smul_apply, LinearMap.id_apply]
  rw [seqLeftMulAbs_apply_effect P harch hb he,
    seqLeftMulAbs_apply_effect P harch hν (P.sp_effect hb he)]
  exact P.sp_pseudoInv_cancel harch hS2 hsharp hsum hpos hle1 hco0 hco1 hcole he

/-- **Order reflection (vdW 4.19) at abstract order-unit-space generality**: the left
multiplication by an effect whose sharp resolution has strictly positive eigenvalues at
nonzero members reflects positivity.  Abstract twin of
`Necessity.seqLeftMul_reflectsNonneg`. -/
theorem seqLeftMulAbs_reflectsNonneg (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1)
    (hb : IsEffect (∑ i ∈ s, lam i • c i)) {x : V}
    (hx : (0 : V) ≤ seqLeftMulAbs P harch hb x) : (0 : V) ≤ x := by
  obtain ⟨co, hco0, hco1, hcole⟩ := exists_pseudoInvCoef hpos hle1
  have hce : ∀ i ∈ s, IsEffect (c i) := fun i hi => (hsharp i hi).1
  have hν : IsEffect (∑ i ∈ s, (co / lam i) • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => div_nonneg hco0.le (hpos i hi hne).le)
      (fun i hi hne => (div_le_one (hpos i hi hne)).mpr (hcole i hi hne))
  have h1 : (0 : V) ≤ seqLeftMulAbs P harch hν (seqLeftMulAbs P harch hb x) :=
    seqLeftMulAbs_nonneg P harch hν hx
  have h2 : seqLeftMulAbs P harch hν (seqLeftMulAbs P harch hb x) = co • x := by
    have h := congrArg (fun f : V →ₗ[ℝ] V => f x)
      (P.seqLeftMulAbs_pseudoInv_comp harch hS2 hsharp hsum hpos hle1 hco0.le hco1 hcole hν hb)
    simpa using h
  rw [h2] at h1
  have hrepr : x = co⁻¹ • (co • x) := by
    rw [smul_smul, inv_mul_cancel₀ hco0.ne', one_smul]
  rw [hrepr]
  exact smul_nonneg' (inv_nonneg.mpr hco0.le) h1

/-- **Injectivity** of the abstract left multiplication for an effect whose sharp
resolution has strictly positive eigenvalues at nonzero members.  Abstract twin of
`Necessity.seqLeftMul_injective`. -/
theorem seqLeftMulAbs_injective (harch : IsArchimedean V) (hS2 : P.FirstArgContinuous)
    {ι : Type*} {s : Finset ι} {c : ι → V} {lam : ι → ℝ}
    (hsharp : ∀ i ∈ s, IsSharp (c i)) (hsum : (∑ i ∈ s, c i) = 𝟙)
    (hpos : ∀ i ∈ s, c i ≠ 0 → 0 < lam i) (hle1 : ∀ i ∈ s, c i ≠ 0 → lam i ≤ 1)
    (hb : IsEffect (∑ i ∈ s, lam i • c i)) :
    Function.Injective (seqLeftMulAbs P harch hb) := by
  obtain ⟨co, hco0, hco1, hcole⟩ := exists_pseudoInvCoef hpos hle1
  have hce : ∀ i ∈ s, IsEffect (c i) := fun i hi => (hsharp i hi).1
  have hν : IsEffect (∑ i ∈ s, (co / lam i) • c i) :=
    isEffect_sum_smul_of_ne hce (le_of_eq hsum)
      (fun i hi hne => div_nonneg hco0.le (hpos i hi hne).le)
      (fun i hi hne => (div_le_one (hpos i hi hne)).mpr (hcole i hi hne))
  intro x y hxy
  have hcomp : ∀ z : V, seqLeftMulAbs P harch hν (seqLeftMulAbs P harch hb z) = co • z := by
    intro z
    have h := congrArg (fun f : V →ₗ[ℝ] V => f z)
      (P.seqLeftMulAbs_pseudoInv_comp harch hS2 hsharp hsum hpos hle1 hco0.le hco1 hcole hν hb)
    simpa using h
  have hc := congrArg (seqLeftMulAbs P harch hν) hxy
  rw [hcomp x, hcomp y] at hc
  have h := congrArg (fun v : V => co⁻¹ • v) hc
  simpa [smul_smul, inv_mul_cancel₀ hco0.ne'] using h

end SequentialProductOn
