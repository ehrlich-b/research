/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Coordinatize
import RadicalRelativity.EJA.HermitianCarrier

set_option linter.style.longLine false

/-!
# A witness for the coordinate algebra

`EJA/Coordinatize.lean` builds `CoordAlg D` from a `CoordData D`, which carries two connectors.
Nothing there produces a `CoordData`, so on its own that file is a theory that might be about an
empty structure — the exposure ARC-6 shipped with `IsArchimedean`, where the abstract rows had no
carrier satisfying their hypothesis.  This file closes it.

## The connector

On `H_d(ℂ)` with `EJA/HermitianCarrier.lean`'s named diagonal frame, the connector on `(i, j)` is
the off-diagonal matrix unit `E_{ij} + E_{ji}` (`offFrame`).  Two entrywise computations:

* `E_{ii} ∘ (E_{ij} + E_{ji}) = ½ (E_{ij} + E_{ji})` (`diagFrame_symmMul_offFrame`), because each
  of the two nonzero entries lies on exactly one arm of the `pᵢ`-cross — `(i,j)` on row `i`,
  `(j,i)` on column `i`, neither on both — so the symmetrised product halves it rather than
  fixing or killing it;
* `(E_{ij} + E_{ji})² = E_{ii} + E_{jj}` (`offFrame_symmMul_self`), because the only surviving
  term of `∑_c M_{ac} M_{cb}` is the one whose middle index is the partner of `a`.

Together these are `IsConnector`, and three distinct indices assemble `hermCoordData`.

## What that buys

`finrank_frameBlockRaw_diagJordanFrame`: an off-diagonal block of the diagonal frame on `H_d(ℂ)`
has real dimension `1`, `2`, `4` or `8`, whenever a third index exists.  And
`classification_coordAlg_herm`: that block is isomorphic as a composition algebra to `ℝ`, `ℂ`,
`ℍ` or `𝕆`.

★ **It is `ℂ`** — the block is `{a E_{kl} + ā E_{lk} : a ∈ ℂ}` — **and that is not proved here.**
Only membership in the list is.  Picking the branch needs the dimension of the block computed
directly; the classification half of Hurwitz is already in tree
(`Composition/Classification.lean`) and does not supply it.

## Scope

**No manifest row moves.**  Substrate.

★ The frame's cardinality `Fintype.card d` is **not** claimed to be the rank of `H_d(ℂ)`; see
`EJA/HermitianCarrier.lean`'s note on `diagJordanFrame`.

★ The Albert carrier is **not** treated here.  `EJA/AlbertCarrier.lean` makes `h₃(𝕆)` a
`EuclideanJordanAlgebra`, so `EJA/FrameExists.lean`'s `exists_jordanFrame` elaborates on it (it
still wants `(1 : h₃(𝕆)) ≠ 0`, which is not discharged anywhere), but **no frame on `h₃(𝕆)` is
named and no connector on it is exhibited**, so `CoordData` has no witness there.  Building one
is the natural next test of this layer, and it is not what this file does.
-/

noncomputable section

namespace RadicalRelativity.EJA

open EuclideanJordanAlgebra Witness

variable {d : Type*} [Fintype d] [DecidableEq d]

/-! ## The off-diagonal matrix unit -/

/-- `E_ij + E_ji`, as a Hermitian matrix over `ℂ`. -/
def offFrame (i j : d) : HermitianMat d ℂ :=
  ⟨Matrix.of fun a b => if (a = i ∧ b = j) ∨ (a = j ∧ b = i) then (1 : ℂ) else 0, by
    apply Matrix.IsHermitian.ext
    intro a b
    simp only [Matrix.of_apply, Matrix.conjTranspose_apply, RCLike.star_def]
    by_cases h : (b = i ∧ a = j) ∨ (b = j ∧ a = i)
    · rw [if_pos h, if_pos (by tauto)]; simp
    · rw [if_neg h, if_neg (by tauto)]; simp⟩

omit [Fintype d] in
@[simp] theorem offFrame_mat_apply (i j a b : d) :
    (offFrame i j).mat a b = if (a = i ∧ b = j) ∨ (a = j ∧ b = i) then (1 : ℂ) else 0 := rfl

omit [Fintype d] in
/-- Row `i` of `E_ij + E_ji`. -/
theorem offFrame_row_left {i j : d} (hij : i ≠ j) (b : d) :
    (offFrame i j).mat i b = if b = j then (1 : ℂ) else 0 := by
  rw [offFrame_mat_apply]
  by_cases hb : b = j
  · rw [if_pos (Or.inl ⟨rfl, hb⟩), if_pos hb]
  · rw [if_neg (by rintro (⟨-, h⟩ | ⟨h, -⟩) <;> [exact hb h; exact hij h]), if_neg hb]

omit [Fintype d] in
/-- Row `j` of `E_ij + E_ji`. -/
theorem offFrame_row_right {i j : d} (hij : i ≠ j) (b : d) :
    (offFrame i j).mat j b = if b = i then (1 : ℂ) else 0 := by
  rw [offFrame_mat_apply]
  by_cases hb : b = i
  · rw [if_pos (Or.inr ⟨rfl, hb⟩), if_pos hb]
  · rw [if_neg (by rintro (⟨h, -⟩ | ⟨-, h⟩) <;> [exact hij h.symm; exact hb h]), if_neg hb]

omit [Fintype d] in
/-- Every other row of `E_ij + E_ji` vanishes. -/
theorem offFrame_row_other {i j : d} {a : d} (hai : a ≠ i) (haj : a ≠ j) (b : d) :
    (offFrame i j).mat a b = 0 := by
  rw [offFrame_mat_apply, if_neg]
  rintro (⟨h, -⟩ | ⟨h, -⟩)
  · exact hai h
  · exact haj h

/-! ## It lies in the block, and it is a connector -/

/-- `E_ii ∘ (E_ij + E_ji) = ½ (E_ij + E_ji)`.  Each nonzero entry lies on exactly one arm of the
`pᵢ`-cross — `(i,j)` on row `i`, `(j,i)` on column `i` — so the symmetrised product halves it. -/
theorem diagFrame_symmMul_offFrame {i j : d} (hij : i ≠ j) :
    (diagFrame i).symmMul (offFrame i j) = ((2 : ℝ)⁻¹ : ℝ) • offFrame i j := by
  apply HermitianMat.ext
  ext a b
  rw [diagFrame_symmMul_mat_apply, HermitianMat.mat_smul, Matrix.smul_apply]
  have key : (if a = i then (offFrame i j).mat a b else 0)
      + (if b = i then (offFrame i j).mat a b else 0) = (offFrame i j).mat a b := by
    by_cases hab : (a = i ∧ b = j) ∨ (a = j ∧ b = i)
    · rcases hab with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · rw [if_pos h1, if_neg (by rw [h2]; exact Ne.symm hij), add_zero]
      · rw [if_neg (by rw [h1]; exact Ne.symm hij), if_pos h2, zero_add]
    · rw [show (offFrame i j).mat a b = 0 from by rw [offFrame_mat_apply, if_neg hab]]
      simp
  rw [key, Complex.real_smul]
  push_cast
  ring

omit [Fintype d] in
/-- `E_ij + E_ji` is symmetric in its two indices. -/
theorem offFrame_comm (i j : d) : offFrame i j = offFrame j i := by
  apply HermitianMat.ext
  ext a b
  rw [offFrame_mat_apply, offFrame_mat_apply]
  by_cases h : (a = i ∧ b = j) ∨ (a = j ∧ b = i)
  · rw [if_pos h, if_pos (by tauto)]
  · rw [if_neg h, if_neg (by tauto)]

/-- **`(E_ij + E_ji)² = E_ii + E_jj`** — the connector equation, entrywise.  The only surviving
term of `∑_c M_ac M_cb` is the one whose middle index is the partner of `a`. -/
theorem offFrame_symmMul_self {i j : d} (hij : i ≠ j) :
    (offFrame i j).symmMul (offFrame i j) = diagFrame i + diagFrame j := by
  apply HermitianMat.ext
  rw [HermitianMat.symmMul_self]
  ext a b
  rw [HermitianMat.mat_add, Matrix.add_apply, diagFrame_mat_apply, diagFrame_mat_apply,
    Matrix.mul_apply]
  by_cases ha : a = i
  · have hsum : ∑ c, (offFrame i j).mat a c * (offFrame i j).mat c b
        = (offFrame i j).mat j b := by
      refine (Finset.sum_eq_single j ?_ ?_).trans ?_
      · intro c _ hc
        rw [ha, offFrame_row_left hij c, if_neg hc, zero_mul]
      · intro h; exact absurd (Finset.mem_univ j) h
      · rw [ha, offFrame_row_left hij j, if_pos rfl, _root_.one_mul]
    rw [hsum, offFrame_row_right hij b, ha]
    by_cases hb : b = i
    · simp [hb, hij]
    · simp [hb, Ne.symm hb]
  · by_cases haj : a = j
    · have hsum : ∑ c, (offFrame i j).mat a c * (offFrame i j).mat c b
          = (offFrame i j).mat i b := by
        refine (Finset.sum_eq_single i ?_ ?_).trans ?_
        · intro c _ hc
          rw [haj, offFrame_row_right hij c, if_neg hc, zero_mul]
        · intro h; exact absurd (Finset.mem_univ i) h
        · rw [haj, offFrame_row_right hij i, if_pos rfl, _root_.one_mul]
      rw [hsum, offFrame_row_left hij b, haj]
      by_cases hb : b = j
      · simp [hb, Ne.symm hij]
      · simp [hb, Ne.symm hb]
    · have hsum : ∑ c, (offFrame i j).mat a c * (offFrame i j).mat c b = 0 :=
        Finset.sum_eq_zero fun c _ => by rw [offFrame_row_other ha haj c, zero_mul]
      rw [hsum]
      simp [ha, haj]

/-! ## The connector on the named frame -/

open scoped HermMul in
/-- **`E_ij + E_ji` is a connector for the diagonal frame on `H_d(ℂ)`.**

★ This is what stops `EJA/Coordinatize.lean` from being a theory about an empty structure: a
`CoordData` exists, so `CoordAlg` has a witness and `finrank_coordAlg` is a statement about a
live object.  Compare `EJA/AlbertCarrier.lean`'s note on the `IsArchimedean` exposure. -/
theorem isConnector_offFrame {k l : Fin (Fintype.card d)} (hkl : k ≠ l) :
    IsConnector (diagJordanFrame (n := d)) k l
      (offFrame ((Fintype.equivFin d).symm k) ((Fintype.equivFin d).symm l)) := by
  have hij : (Fintype.equivFin d).symm k ≠ (Fintype.equivFin d).symm l :=
    (Fintype.equivFin d).symm.injective.ne hkl
  refine ⟨(mem_frameBlockRaw_off hkl).mpr ⟨?_, ?_⟩, ?_⟩
  · rw [diagJordanFrame_p, hermitian_mul_eq_symmMul]
    exact diagFrame_symmMul_offFrame hij
  · rw [diagJordanFrame_p, hermitian_mul_eq_symmMul,
      offFrame_comm ((Fintype.equivFin d).symm k) ((Fintype.equivFin d).symm l)]
    exact diagFrame_symmMul_offFrame (Ne.symm hij)
  · rw [hermitian_mul_eq_symmMul, diagJordanFrame_p, diagJordanFrame_p]
    exact offFrame_symmMul_self hij

/-! ## The coordinate algebra of `H_d(ℂ)`, instantiated -/

/-- **A `CoordData` on `H_d(ℂ)`**, built from three distinct diagonal indices and the two
off-diagonal matrix units they name. -/
def hermCoordData {k l m : Fin (Fintype.card d)} (hkl : k ≠ l) (hlm : l ≠ m) (hkm : k ≠ m) :
    CoordData (HermitianMat d ℂ) (Fintype.card d) :=
  CoordData.mk' diagJordanFrame hkl hlm hkm (isConnector_offFrame hkl) (isConnector_offFrame hkm)

@[simp] theorem hermCoordData_F {k l m : Fin (Fintype.card d)} (hkl : k ≠ l) (hlm : l ≠ m)
    (hkm : k ≠ m) : (hermCoordData hkl hlm hkm).F = diagJordanFrame (n := d) := rfl

@[simp] theorem hermCoordData_i {k l m : Fin (Fintype.card d)} (hkl : k ≠ l) (hlm : l ≠ m)
    (hkm : k ≠ m) : (hermCoordData hkl hlm hkm).i = k := rfl

@[simp] theorem hermCoordData_j {k l m : Fin (Fintype.card d)} (hkl : k ≠ l) (hlm : l ≠ m)
    (hkm : k ≠ m) : (hermCoordData hkl hlm hkm).j = l := rfl

/-- **The dimension theorem, instantiated on `H_d(ℂ)`.**  Every off-diagonal block of the
diagonal frame has real dimension `1`, `2`, `4` or `8`, provided a third index exists.

★ It is `2` — the block is `{a E_{kl} + ā E_{lk} : a ∈ ℂ}` — and *that* is not proved here;
only membership in the Hurwitz list is.  The value of this statement is that it is not vacuous:
`CoordAlg` and `finrank_coordAlg` are statements about a structure this theorem exhibits. -/
theorem finrank_frameBlockRaw_diagJordanFrame {k l m : Fin (Fintype.card d)} (hkl : k ≠ l)
    (hlm : l ≠ m) (hkm : k ≠ m) :
    Module.finrank ℝ ↥(frameBlockRaw (diagJordanFrame (n := d)) k l) = 1 ∨
      Module.finrank ℝ ↥(frameBlockRaw (diagJordanFrame (n := d)) k l) = 2 ∨
      Module.finrank ℝ ↥(frameBlockRaw (diagJordanFrame (n := d)) k l) = 4 ∨
      Module.finrank ℝ ↥(frameBlockRaw (diagJordanFrame (n := d)) k l) = 8 :=
  CoordAlg.finrank_frameBlockRaw_of_coordData (hermCoordData hkl hlm hkm)

/-- **The classification, instantiated on `H_d(ℂ)`.**  The coordinate algebra of an off-diagonal
block of the diagonal frame is isomorphic to `ℝ`, `ℂ`, `ℍ` or `𝕆`.

★ It is `ℂ`, and this does not say so — see the module docstring. -/
theorem classification_coordAlg_herm {k l m : Fin (Fintype.card d)} (hkl : k ≠ l) (hlm : l ≠ m)
    (hkm : k ≠ m) :
    (∃ f : CoordAlg (hermCoordData hkl hlm hkm) ≃ₗ[ℝ] ℝ, CompositionAlgebra.IsCompIso f) ∨
      (∃ f : CoordAlg (hermCoordData hkl hlm hkm) ≃ₗ[ℝ] ℂ, CompositionAlgebra.IsCompIso f) ∨
      (∃ f : CoordAlg (hermCoordData hkl hlm hkm) ≃ₗ[ℝ] Quaternion ℝ,
        CompositionAlgebra.IsCompIso f) ∨
      (∃ f : CoordAlg (hermCoordData hkl hlm hkm) ≃ₗ[ℝ] Octonion,
        CompositionAlgebra.IsCompIso f) :=
  CoordAlg.classification_coordAlg

end RadicalRelativity.EJA
