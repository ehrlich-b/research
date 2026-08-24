/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Necessity.UnitaryGeneration

set_option linter.style.longLine false

/-!
# Givens rotations

★★★ Manifest **row 26** (`lem:frame-connectivity`) needs every unitary to factor into **rank-two
block rotations**, which `Necessity/FrameConstancy.lean` records as strictly stronger than the
three axis-fixing Householder factors `exists_axisFixing_factor` supplies: `AdjAxis` asks that
*some* axis be fixed, `AdjBlock` that *all but two* be.

This file builds the two-level unitary and its algebra.  The matrix is written as
`G = (1 − P) + B` with `P = E_ii + E_jj` the block projection and `B` supported in the block,
which makes unitarity three `single`-algebra identities rather than an entrywise case split.
-/

noncomputable section

open scoped Matrix
open Matrix

namespace Necessity

variable {N : ℕ}

section Givens

variable {i j : Fin N}

/-- The block projection `E_ii + E_jj`. -/
def blockProjMat (i j : Fin N) : Matrix (Fin N) (Fin N) ℂ :=
  Matrix.single i i 1 + Matrix.single j j 1

/-- The two-level part of a Givens rotation: `[[c̄, s̄], [−s, c]]` on the `{i, j}` block. -/
def givensCore (i j : Fin N) (c s : ℂ) : Matrix (Fin N) (Fin N) ℂ :=
  (starRingEnd ℂ) c • Matrix.single i i 1 + (starRingEnd ℂ) s • Matrix.single i j 1
    + (-s) • Matrix.single j i 1 + c • Matrix.single j j 1

/-- **The Givens rotation** in the `{i, j}` plane. -/
def givens (i j : Fin N) (c s : ℂ) : Matrix (Fin N) (Fin N) ℂ :=
  (1 - blockProjMat i j) + givensCore i j c s

theorem blockProjMat_conjTranspose (i j : Fin N) :
    (blockProjMat i j)ᴴ = blockProjMat i j := by
  rw [blockProjMat, Matrix.conjTranspose_add]
  congr 1 <;> · ext k l; simp [Matrix.single_apply, Matrix.conjTranspose_apply, eq_comm, and_comm]

theorem blockProjMat_mul_self (hij : i ≠ j) :
    blockProjMat i j * blockProjMat i j = blockProjMat i j := by
  rw [blockProjMat, Matrix.add_mul, Matrix.mul_add, Matrix.mul_add]
  rw [Matrix.single_mul_single_of_ne (h := hij), Matrix.single_mul_single_of_ne (h := Ne.symm hij)]
  simp only [Matrix.single_mul_single_same, one_mul, add_zero, zero_add]

theorem givensCore_conjTranspose (i j : Fin N) (c s : ℂ) :
    (givensCore i j c s)ᴴ
      = c • Matrix.single i i 1 + s • Matrix.single j i 1
        + (-(starRingEnd ℂ) s) • Matrix.single i j 1
        + (starRingEnd ℂ) c • Matrix.single j j 1 := by
  have hs : ∀ (a b : Fin N) (z : ℂ), (z • Matrix.single a b (1 : ℂ))ᴴ
      = (starRingEnd ℂ) z • Matrix.single b a (1 : ℂ) := by
    intro a b z
    ext k l
    simp [Matrix.single_apply, Matrix.conjTranspose_apply, Matrix.smul_apply, and_comm,
      eq_comm, apply_ite (starRingEnd ℂ)]
  rw [givensCore, Matrix.conjTranspose_add, Matrix.conjTranspose_add,
    Matrix.conjTranspose_add, hs, hs, hs, hs]
  simp only [RingHomCompTriple.comp_apply, RingHom.id_apply, map_neg,
    RCLike.star_def, Complex.conj_conj]

/-- Products of scalar multiples of matrix units. -/
theorem smul_single_mul_smul_single (a b c d : Fin N) (z w : ℂ) :
    (z • Matrix.single a b (1 : ℂ)) * (w • Matrix.single c d (1 : ℂ))
      = if b = c then (z * w) • Matrix.single a d (1 : ℂ) else 0 := by
  by_cases h : b = c
  · subst h
    rw [if_pos rfl, Matrix.smul_mul, Matrix.mul_smul, Matrix.single_mul_single_same, one_mul,
      smul_smul]
  · rw [if_neg h, Matrix.smul_mul, Matrix.mul_smul,
      Matrix.single_mul_single_of_ne (h := h), smul_zero, smul_zero]

theorem blockProjMat_eq_smul (i j : Fin N) :
    blockProjMat i j
      = (1 : ℂ) • Matrix.single i i (1 : ℂ) + (1 : ℂ) • Matrix.single j j (1 : ℂ) := by
  rw [blockProjMat, one_smul, one_smul]

theorem blockProjMat_mul_givensCore (hij : i ≠ j) (c s : ℂ) :
    blockProjMat i j * givensCore i j c s = givensCore i j c s := by
  rw [blockProjMat_eq_smul, givensCore]
  simp only [Matrix.add_mul, Matrix.mul_add, smul_single_mul_smul_single, hij, Ne.symm hij,
    if_true, if_false, reduceIte]
  match_scalars <;> ring

theorem givensCore_conjTranspose_mul_blockProjMat (hij : i ≠ j) (c s : ℂ) :
    (givensCore i j c s)ᴴ * blockProjMat i j = (givensCore i j c s)ᴴ := by
  rw [givensCore_conjTranspose, blockProjMat_eq_smul]
  simp only [Matrix.add_mul, Matrix.mul_add, smul_single_mul_smul_single, hij, Ne.symm hij,
    if_true, if_false, reduceIte]
  match_scalars <;> ring

theorem givensCore_conjTranspose_mul_self (hij : i ≠ j) (c s : ℂ)
    (hcs : (starRingEnd ℂ) c * c + (starRingEnd ℂ) s * s = 1) :
    (givensCore i j c s)ᴴ * givensCore i j c s = blockProjMat i j := by
  rw [givensCore_conjTranspose, givensCore, blockProjMat_eq_smul]
  simp only [Matrix.add_mul, Matrix.mul_add, smul_single_mul_smul_single, hij, Ne.symm hij,
    if_true, if_false, reduceIte]
  have hcs2 : c * (starRingEnd ℂ) c + (starRingEnd ℂ) s * s = 1 := by
    rw [mul_comm c]; exact hcs
  have hcs3 : s * (starRingEnd ℂ) s + (starRingEnd ℂ) c * c = 1 := by
    rw [mul_comm s, add_comm]; exact hcs
  match_scalars <;> (try ring) <;> (try assumption) <;> (try linear_combination hcs)

/-- ★★★ **A Givens rotation is unitary.** -/
theorem givens_conjTranspose_mul (hij : i ≠ j) (c s : ℂ)
    (hcs : (starRingEnd ℂ) c * c + (starRingEnd ℂ) s * s = 1) :
    (givens i j c s)ᴴ * givens i j c s = 1 := by
  have hP := blockProjMat_mul_self hij (i := i) (j := j)
  have hPB := blockProjMat_mul_givensCore hij c s
  have hBP := givensCore_conjTranspose_mul_blockProjMat hij c s
  have hBB := givensCore_conjTranspose_mul_self hij c s hcs
  have h1 : (1 - blockProjMat i j) * (1 - blockProjMat i j) = 1 - blockProjMat i j := by
    rw [Matrix.sub_mul, Matrix.mul_sub, Matrix.mul_sub, Matrix.one_mul, Matrix.one_mul,
      Matrix.mul_one, hP]
    abel
  have h2 : (1 - blockProjMat i j) * givensCore i j c s = 0 := by
    rw [Matrix.sub_mul, Matrix.one_mul, hPB, sub_self]
  have h3 : (givensCore i j c s)ᴴ * (1 - blockProjMat i j) = 0 := by
    rw [Matrix.mul_sub, Matrix.mul_one, hBP, sub_self]
  rw [givens, Matrix.conjTranspose_add, Matrix.conjTranspose_sub,
    Matrix.conjTranspose_one, blockProjMat_conjTranspose,
    Matrix.add_mul, Matrix.mul_add, Matrix.mul_add, h1, h2, h3, hBB]
  abel

/-! ## How a Givens rotation acts on a matrix from the left -/

theorem givens_mul_apply_of_ne (c s : ℂ) (W : Matrix (Fin N) (Fin N) ℂ)
    {k : Fin N} (hki : k ≠ i) (hkj : k ≠ j) (l : Fin N) :
    (givens i j c s * W) k l = W k l := by
  rw [givens, blockProjMat, givensCore]
  simp [Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul, hki, hkj]

theorem givens_mul_apply_fst (hij : i ≠ j) (c s : ℂ) (W : Matrix (Fin N) (Fin N) ℂ) (l : Fin N) :
    (givens i j c s * W) i l
      = (starRingEnd ℂ) c * W i l + (starRingEnd ℂ) s * W j l := by
  rw [givens, blockProjMat, givensCore]
  simp [Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul, hij, Ne.symm hij]

theorem givens_mul_apply_snd (hij : i ≠ j) (c s : ℂ) (W : Matrix (Fin N) (Fin N) ℂ) (l : Fin N) :
    (givens i j c s * W) j l = -s * W i l + c * W j l := by
  rw [givens, blockProjMat, givensCore]
  simp [Matrix.add_mul, Matrix.sub_mul, Matrix.smul_mul, hij, Ne.symm hij]

/-- ★★★ **A Givens rotation is block-fixing**: outside the `{i, j}` block it is the identity, so
every off-diagonal entry with an index outside the block vanishes. -/
theorem givens_blockFixing (hij : i ≠ j) (c s : ℂ) :
    ∀ k l : Fin N, k ≠ l → ((k ≠ i ∧ k ≠ j) ∨ (l ≠ i ∧ l ≠ j)) → givens i j c s k l = 0 := by
  intro k l hkl h
  have hone : (givens i j c s * (1 : Matrix (Fin N) (Fin N) ℂ)) k l = givens i j c s k l := by
    rw [Matrix.mul_one]
  rcases h with ⟨hki, hkj⟩ | ⟨hli, hlj⟩
  · rw [← hone, givens_mul_apply_of_ne c s 1 hki hkj l, Matrix.one_apply_ne hkl]
  · rcases eq_or_ne k i with rfl | hki
    · rw [← hone, givens_mul_apply_fst hij c s 1 l, Matrix.one_apply_ne (Ne.symm hli),
        Matrix.one_apply_ne (Ne.symm hlj)]
      ring
    · rcases eq_or_ne k j with rfl | hkj
      · rw [← hone, givens_mul_apply_snd hij c s 1 l, Matrix.one_apply_ne (Ne.symm hli),
          Matrix.one_apply_ne (Ne.symm hlj)]
        ring
      · rw [← hone, givens_mul_apply_of_ne c s 1 hki hkj l, Matrix.one_apply_ne hkl]

/-! ## The clearing step -/

/-- ★★★ **One Givens rotation kills one entry.**  The parameters are the normalised pair
`(c, s) = (a, b)/‖(a,b)‖`; the annihilation `−s·a + c·b = 0` is a ring identity that holds for
*any* common denominator, so only the unitarity condition needs `(a,b) ≠ 0`. -/
theorem exists_givens_clear (hij : i ≠ j) (W : Matrix (Fin N) (Fin N) ℂ) (m : Fin N) :
    ∃ c s : ℂ, (starRingEnd ℂ) c * c + (starRingEnd ℂ) s * s = 1
      ∧ (givens i j c s * W) j m = 0 := by
  by_cases hab : Complex.normSq (W i m) + Complex.normSq (W j m) = 0
  · refine ⟨1, 0, by simp, ?_⟩
    have h1 : W i m = 0 := by
      have := Complex.normSq_nonneg (W i m)
      have h2 := Complex.normSq_nonneg (W j m)
      exact Complex.normSq_eq_zero.mp (by linarith)
    have h2 : W j m = 0 := by
      have := Complex.normSq_nonneg (W i m)
      have h3 := Complex.normSq_nonneg (W j m)
      exact Complex.normSq_eq_zero.mp (by linarith)
    rw [givens_mul_apply_snd hij, h1, h2]
    ring
  · set q : ℝ := Complex.normSq (W i m) + Complex.normSq (W j m) with hqdef
    have hq : 0 < q := lt_of_le_of_ne
      (by rw [hqdef]; exact add_nonneg (Complex.normSq_nonneg _) (Complex.normSq_nonneg _))
      (Ne.symm hab)
    set r : ℝ := Real.sqrt q with hrdef
    have hr : 0 < r := Real.sqrt_pos.mpr hq
    have hrne : (r : ℂ) ≠ 0 := by
      simpa using hr.ne'
    have hrsq : (r : ℂ) * (r : ℂ) = (q : ℂ) := by
      have hrr : r * r = q := Real.mul_self_sqrt hq.le
      exact_mod_cast congrArg (fun x : ℝ => (x : ℂ)) hrr
    refine ⟨W i m / (r : ℂ), W j m / (r : ℂ), ?_, ?_⟩
    · have hconj : ∀ z : ℂ, (starRingEnd ℂ) (z / (r : ℂ)) = (starRingEnd ℂ) z / (r : ℂ) := by
        intro z
        rw [map_div₀, Complex.conj_ofReal]
      rw [hconj, hconj, div_mul_div_comm, div_mul_div_comm, ← add_div, hrsq]
      rw [div_eq_one_iff_eq (by exact_mod_cast hq.ne')]
      have e1 : (starRingEnd ℂ) (W i m) * W i m = (Complex.normSq (W i m) : ℂ) := by
        rw [mul_comm, Complex.mul_conj]
      have e2 : (starRingEnd ℂ) (W j m) * W j m = (Complex.normSq (W j m) : ℂ) := by
        rw [mul_comm, Complex.mul_conj]
      rw [e1, e2, hqdef]
      push_cast
      ring
    · rw [givens_mul_apply_snd hij]
      ring

end Givens

/-! ## Walks in the article's frame graph

`AdjBlock` is right-translation invariant, so a walk from `F` to `G` exists exactly when `F⁻¹G`
is a product of block-fixing unitaries.  `IsBlockProd` packages that without a subgroup. -/

section Walk

open MasterTheorem.Globalization

variable {i j : Fin N}

/-- `W` moves every frame along a walk of `AdjBlock` steps. -/
def IsBlockProd (W : Matrix.unitaryGroup (Fin N) ℂ) : Prop :=
  ∀ F : Matrix.unitaryGroup (Fin N) ℂ,
    Relation.ReflTransGen (SymmStep AdjBlock) F (F * W)

theorem walk_symm {F G : Matrix.unitaryGroup (Fin N) ℂ}
    (h : Relation.ReflTransGen (SymmStep AdjBlock) F G) :
    Relation.ReflTransGen (SymmStep AdjBlock) G F := by
  induction h with
  | refl => exact Relation.ReflTransGen.refl
  | tail _ h2 ih =>
      refine (Relation.ReflTransGen.single ?_).trans ih
      exact h2.symm

theorem isBlockProd_one : IsBlockProd (1 : Matrix.unitaryGroup (Fin N) ℂ) := by
  intro F
  rw [mul_one]

theorem isBlockProd_mul {V W : Matrix.unitaryGroup (Fin N) ℂ}
    (hV : IsBlockProd V) (hW : IsBlockProd W) : IsBlockProd (V * W) := by
  intro F
  have h2 := hW (F * V)
  rw [mul_assoc] at h2
  exact (hV F).trans h2

theorem isBlockProd_inv {W : Matrix.unitaryGroup (Fin N) ℂ} (h : IsBlockProd W) :
    IsBlockProd W⁻¹ := by
  intro F
  have h1 := h (F * W⁻¹)
  rw [mul_assoc, inv_mul_cancel, mul_one] at h1
  exact walk_symm h1

/-- Right multiplication by a block-fixing unitary is one adjacency step. -/
theorem adjBlock_mul_right (F : Matrix.unitaryGroup (Fin N) ℂ)
    {V : Matrix.unitaryGroup (Fin N) ℂ} {i j : Fin N} (hij : i ≠ j)
    (hV : ∀ k l : Fin N, k ≠ l → ((k ≠ i ∧ k ≠ j) ∨ (l ≠ i ∧ l ≠ j)) →
      (V : Matrix (Fin N) (Fin N) ℂ) k l = 0) :
    AdjBlock F (F * V) := by
  refine ⟨i, j, hij, fun k l hkl h => ?_⟩
  have hcoe : ((F : Matrix (Fin N) (Fin N) ℂ))ᴴ
        * ((F * V : Matrix.unitaryGroup (Fin N) ℂ) : Matrix (Fin N) (Fin N) ℂ)
      = (V : Matrix (Fin N) (Fin N) ℂ) := by
    have h' : ((F * V : Matrix.unitaryGroup (Fin N) ℂ) : Matrix (Fin N) (Fin N) ℂ)
        = (F : Matrix (Fin N) (Fin N) ℂ) * (V : Matrix (Fin N) (Fin N) ℂ) := rfl
    rw [h', ← Matrix.mul_assoc, unitaryGroup_conjTranspose_mul F, Matrix.one_mul]
  rw [hcoe]
  exact hV k l hkl h

theorem isBlockProd_of_blockFixing {V : Matrix.unitaryGroup (Fin N) ℂ} {i j : Fin N}
    (hij : i ≠ j)
    (hV : ∀ k l : Fin N, k ≠ l → ((k ≠ i ∧ k ≠ j) ∨ (l ≠ i ∧ l ≠ j)) →
      (V : Matrix (Fin N) (Fin N) ℂ) k l = 0) :
    IsBlockProd V :=
  fun F => Relation.ReflTransGen.single (Or.inl (adjBlock_mul_right F hij hV))

/-- The Givens rotation, as a member of the unitary group. -/
def givensU (hij : i ≠ j) (c s : ℂ)
    (hcs : (starRingEnd ℂ) c * c + (starRingEnd ℂ) s * s = 1) :
    Matrix.unitaryGroup (Fin N) ℂ :=
  ⟨givens i j c s, Matrix.mem_unitaryGroup_iff'.mpr (givens_conjTranspose_mul hij c s hcs)⟩

@[simp]
theorem givensU_coe (hij : i ≠ j) (c s : ℂ)
    (hcs : (starRingEnd ℂ) c * c + (starRingEnd ℂ) s * s = 1) :
    ((givensU hij c s hcs : Matrix.unitaryGroup (Fin N) ℂ) : Matrix (Fin N) (Fin N) ℂ)
      = givens i j c s := rfl

theorem isBlockProd_givensU (hij : i ≠ j) (c s : ℂ)
    (hcs : (starRingEnd ℂ) c * c + (starRingEnd ℂ) s * s = 1) :
    IsBlockProd (givensU hij c s hcs) :=
  isBlockProd_of_blockFixing hij (by simpa using givens_blockFixing hij c s)

end Walk

/-! ## Clearing the columns

The Givens sweep, as a double induction: an inner one over the rows of a single column and an
outer one over the columns.  The invariant is `ColsClearedU W S` — the columns indexed by `S` are
supported on their own index — and the sweep only ever rotates in planes **disjoint from `S`**, so
already-cleared columns are untouched. -/

section Sweep

open MasterTheorem.Globalization

/-- The columns of `W` indexed by `S` are supported on their own index. -/
def ColsClearedU (W : Matrix.unitaryGroup (Fin N) ℂ) (S : Finset (Fin N)) : Prop :=
  ∀ m ∈ S, ∀ k : Fin N, k ≠ m → (W : Matrix (Fin N) (Fin N) ℂ) k m = 0

/-- **A cleared column is orthogonal to every other column.**  If column `l` of a unitary is
supported on `l`, then row `l` vanishes off `l` as well. -/
theorem cleared_col_orthogonal {V : Matrix (Fin N) (Fin N) ℂ} (hV : Vᴴ * V = 1)
    {l : Fin N} (hl : ∀ p : Fin N, p ≠ l → V p l = 0) {m : Fin N} (hlm : l ≠ m) :
    V l m = 0 := by
  classical
  have hsum : ∀ b : Fin N, (Vᴴ * V) l b = (starRingEnd ℂ) (V l l) * V l b := by
    intro b
    rw [Matrix.mul_apply]
    refine Finset.sum_eq_single l (fun p _ hp => ?_) (fun h => absurd (Finset.mem_univ l) h)
    rw [Matrix.conjTranspose_apply, hl p hp]
    simp
  have h1 : (starRingEnd ℂ) (V l l) * V l l = 1 := by
    rw [← hsum l, hV, Matrix.one_apply_eq]
  have h2 : (starRingEnd ℂ) (V l l) * V l m = 0 := by
    rw [← hsum m, hV, Matrix.one_apply_ne hlm]
  have hne : (starRingEnd ℂ) (V l l) ≠ 0 := by
    intro h
    rw [h, zero_mul] at h1
    exact zero_ne_one h1
  exact (mul_eq_zero.mp h2).resolve_left hne

/-- **One column, cleared**, by an inner induction over the rows still to be zeroed. -/
theorem exists_clear_col (S : Finset (Fin N)) {m : Fin N} (hm : m ∉ S) :
    ∀ T : Finset (Fin N), (∀ k ∈ T, k ≠ m ∧ k ∉ S) →
    ∀ W : Matrix.unitaryGroup (Fin N) ℂ, ColsClearedU W S →
      ∃ U : Matrix.unitaryGroup (Fin N) ℂ, IsBlockProd U ∧ ColsClearedU (U * W) S ∧
        ∀ k ∈ T, ((U * W : Matrix.unitaryGroup (Fin N) ℂ) : Matrix (Fin N) (Fin N) ℂ) k m = 0 := by
  classical
  intro T
  induction T using Finset.induction_on with
  | empty =>
      intro _ W hW
      exact ⟨1, isBlockProd_one, by rwa [one_mul], by simp⟩
  | insert k T' hk ih =>
      intro hT W hW
      obtain ⟨U', hU', hcl', hzero'⟩ := ih (fun l hl => hT l (Finset.mem_insert_of_mem hl)) W hW
      obtain ⟨hkm, hkS⟩ := hT k (Finset.mem_insert_self k T')
      obtain ⟨V, hVdef⟩ : ∃ V : Matrix (Fin N) (Fin N) ℂ,
          ((U' * W : Matrix.unitaryGroup (Fin N) ℂ) : Matrix (Fin N) (Fin N) ℂ) = V := ⟨_, rfl⟩
      have hclV : ∀ m' ∈ S, ∀ l : Fin N, l ≠ m' → V l m' = 0 := by
        rw [← hVdef]; exact hcl'
      have hzeroV : ∀ l ∈ T', V l m = 0 := by
        rw [← hVdef]; exact hzero'
      obtain ⟨c, s, hcs, hclear⟩ := exists_givens_clear (i := m) (j := k) (Ne.symm hkm) V m
      have hassoc : ((givensU (Ne.symm hkm) c s hcs * U' * W :
            Matrix.unitaryGroup (Fin N) ℂ) : Matrix (Fin N) (Fin N) ℂ)
          = givens m k c s * V := by
        rw [← hVdef, mul_assoc]
        rfl
      refine ⟨givensU (Ne.symm hkm) c s hcs * U',
        isBlockProd_mul (isBlockProd_givensU _ c s hcs) hU', ?_, ?_⟩
      · intro m' hm' l hl
        rw [hassoc]
        have hmm' : m ≠ m' := fun h => hm (h ▸ hm')
        have hkm' : k ≠ m' := fun h => hkS (h ▸ hm')
        rcases eq_or_ne l m with rfl | hlm
        · rw [givens_mul_apply_fst (Ne.symm hkm), hclV m' hm' l hmm', hclV m' hm' k hkm']
          ring
        · rcases eq_or_ne l k with rfl | hlk
          · rw [givens_mul_apply_snd (Ne.symm hkm), hclV m' hm' m hmm', hclV m' hm' l hkm']
            ring
          · rw [givens_mul_apply_of_ne c s V hlm hlk]
            exact hclV m' hm' l hl
      · intro l hl
        rw [hassoc]
        rcases Finset.mem_insert.mp hl with rfl | hlT'
        · exact hclear
        · have hlm : l ≠ m := (hT l (Finset.mem_insert_of_mem hlT')).1
          have hlk : l ≠ k := fun h => hk (h ▸ hlT')
          rw [givens_mul_apply_of_ne c s V hlm hlk]
          exact hzeroV l hlT'

/-- A unitary all of whose columns are supported on their own index is diagonal, hence
block-fixing for any pair of indices. -/
theorem isBlockProd_of_diag (hN : 2 ≤ N) {W : Matrix.unitaryGroup (Fin N) ℂ}
    (hW : ColsClearedU W Finset.univ) : IsBlockProd W := by
  obtain ⟨i, j, hij⟩ : ∃ i j : Fin N, i ≠ j := by
    refine ⟨⟨0, by omega⟩, ⟨1, by omega⟩, ?_⟩
    simp only [ne_eq, Fin.mk.injEq]
    omega
  exact isBlockProd_of_blockFixing hij (fun k l hkl _ => hW l (Finset.mem_univ l) k hkl)

/-- **The Givens sweep.**  Outer induction on the number of columns still to clear. -/
theorem isBlockProd_of_colsCleared (hN : 2 ≤ N) :
    ∀ n : ℕ, ∀ S : Finset (Fin N), Sᶜ.card ≤ n →
    ∀ W : Matrix.unitaryGroup (Fin N) ℂ, ColsClearedU W S → IsBlockProd W := by
  classical
  have hunivOfCompl : ∀ S : Finset (Fin N), Sᶜ = ∅ → S = Finset.univ := by
    intro S hSc
    ext x
    simp only [Finset.mem_univ, iff_true]
    by_contra hx
    have : x ∈ Sᶜ := Finset.mem_compl.mpr hx
    rw [hSc] at this
    simp at this
  intro n
  induction n with
  | zero =>
      intro S hS W hW
      have hSc : Sᶜ = ∅ := Finset.card_eq_zero.mp (Nat.le_zero.mp hS)
      exact isBlockProd_of_diag hN (by rwa [hunivOfCompl S hSc] at hW)
  | succ n ih =>
      intro S hS W hW
      rcases Finset.eq_empty_or_nonempty (Sᶜ) with hSc | ⟨m, hm⟩
      · exact isBlockProd_of_diag hN (by rwa [hunivOfCompl S hSc] at hW)
      · have hmS : m ∉ S := Finset.mem_compl.mp hm
        obtain ⟨U, hU, hcl, hzero⟩ := exists_clear_col S hmS (Sᶜ.erase m)
          (fun k hk => ⟨Finset.ne_of_mem_erase hk,
            Finset.mem_compl.mp (Finset.mem_of_mem_erase hk)⟩) W hW
        have hUW : ColsClearedU (U * W) (insert m S) := by
          intro m' hm' l hlne
          rcases Finset.mem_insert.mp hm' with rfl | hm'S
          · by_cases hlS : l ∈ S
            · exact cleared_col_orthogonal
                (Matrix.mem_unitaryGroup_iff'.mp (U * W).2)
                (fun p hp => hcl l hlS p hp) hlne
            · exact hzero l (Finset.mem_erase.mpr ⟨hlne, Finset.mem_compl.mpr hlS⟩)
          · exact hcl m' hm'S l hlne
        have hcompl : (insert m S)ᶜ = Sᶜ.erase m := by
          ext x
          simp only [Finset.mem_compl, Finset.mem_erase, Finset.mem_insert, not_or]
          try tauto
        have hcard : (insert m S)ᶜ.card ≤ n := by
          rw [hcompl, Finset.card_erase_of_mem hm]
          omega
        have hUWprod : IsBlockProd (U * W) := ih (insert m S) hcard (U * W) hUW
        have hWeq : U⁻¹ * (U * W) = W := by group
        rw [← hWeq]
        exact isBlockProd_mul (isBlockProd_inv hU) hUWprod

/-- ★★★ **Every unitary is a product of Givens rotations** (`N ≥ 2`), in the form the frame graph
needs: it moves every frame along a walk of `AdjBlock` steps. -/
theorem isBlockProd_all (hN : 2 ≤ N) (W : Matrix.unitaryGroup (Fin N) ℂ) : IsBlockProd W :=
  isBlockProd_of_colsCleared hN (Finset.univ : Finset (Fin N)).card ∅ (by simp) W
    (by intro m hm; exact absurd hm (by simp))

/-- ★★★ **`lem:frame-connectivity`**: the graph on Jordan frames with `F ∼ F'` iff they share all
but two atoms is **connected**, for every `N ≥ 2`.

This is manifest **row 26**.  `AdjBlock` is strictly finer than `AdjAxis`, so it does not follow
from `adjAxis_connected`: it needs every unitary to factor into rank-two block rotations, which is
the Givens sweep above.  At `N = 2` the relation is total and the statement is trivial; the content
is at `N ≥ 3`, where a frame and its neighbour agree on `N − 2` atoms. -/
theorem adjBlock_connected (hN : 2 ≤ N) (F G : Matrix.unitaryGroup (Fin N) ℂ) :
    Relation.ReflTransGen (MasterTheorem.Globalization.SymmStep AdjBlock) F G := by
  have h := isBlockProd_all hN (F⁻¹ * G) F
  rw [← mul_assoc, mul_inv_cancel, one_mul] at h
  exact h

end Sweep

end Necessity
