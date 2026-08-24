/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.SequentialProduct
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

The concrete theorems in `Necessity/SharpEffects.lean` are left in place untouched;
other rows consume them under their matrix-stated hypotheses.
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
