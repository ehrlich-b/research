/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.FramePeirce
import RadicalRelativity.EJA.Witness

set_option linter.style.longLine false

/-!
# A carrier for `EuclideanJordanAlgebra`

`EJA/Class.lean` names the Euclidean Jordan algebra hypothesis as a class, and `EJA/Rank.lean`,
`EJA/FrameExists.lean` and `EJA/FramePeirce.lean` state their results over it.  Until this file
the **only** instances of that class in the tree were `EJA/PeirceSubalgebra.lean`'s two, and both
are conditional on an ambient `[EuclideanJordanAlgebra J]`, so nothing exhibited a base model:
`exists_jordanFrame` and `frameBlock_isInternal` were universally quantified over a class no
object was known to inhabit.

This file supplies the base model.  `H_n(𝕜)` — Hermitian matrices over `𝕜 = ℝ` or `ℂ` under the
symmetrized product `A ∘ B = ½(AB + BA)` and the real trace form — is a `EuclideanJordanAlgebra`.

★ **This is the same exposure ARC-6 shipped and had to repair.**  Two abstract rows landed
FORMALIZED carrying `IsArchimedean` as a hypothesis with no carrier known to satisfy it;
`HermitianMat.isArchimedean` was proved to retire that caveat, and `EJA/Witness.lean`'s
`instIsFormallyReal` and `diagFrame_orthIdem` retired it for `IsFormallyReal` and
`IsOrthIdemFamily`.  The class was the last hypothesis in the layer with no witness.

## No field needed new mathematics

Every one of the class's six field obligations was already proved in the tree, in
`jordanBilinG` or `symmMul` vocabulary:

| class field | discharged by |
| --- | --- |
| `mul_comm` | `HermitianMat.symmMul_comm` |
| `add_mul` | bilinearity of `Necessity.jordanBilinG` |
| `smul_mul` | bilinearity of `Necessity.jordanBilinG` |
| `one_mul` | `HermitianMat.one_symmMul` |
| `jordan` | `EJA/Order.lean`'s `hermitian_jordan_id` (the vendored `IsCommJordan`) |
| `inner_assoc` | `EJA/Order.lean`'s `hermitian_jordan_assoc` |

The three lemmas before the instance are re-orientations, not new results: two unbundle
`jordanBilinG`'s `LinearMap` structure, and `hermitian_symmMul_jordan` turns Mathlib's
`lmul_comm_rmul_rmul` orientation into the class's by commuting the product twice.

## The diamond `EJA/Class.lean` warned about, measured

`EJA/Class.lean` records that `instNonUnitalNonAssocCommRing` fires on any type carrying the
class, that `HermitianMat d 𝕜` already carries a `Mul` from
`RadicalRelativity/Vendor/HermitianMat/Jordan.lean`'s `scoped instance : CommMagma`, and that
"if one is ever declared, that scoped instance and this class's `toMul` will both be in scope
inside `open HermMul` sections and one of them has to give way."

That is now declared, and the collision is **definitional**: `hermMul_toMul_eq` below is `rfl`.
Both `Mul` structures have `HermitianMat.symmMul` as their multiplication, so which one instance
search returns does not change any statement.  Concretely, inside an `open HermMul` section with
this instance in scope, `#synth Mul (HermitianMat (Fin 2) ℂ)` returns *this* instance's `toMul`
(the global instance outranks the opened scoped one), `HermMul.mul_eq_symmMul` still typechecks,
and `EJA/Order.lean`'s two `open HermMul` proofs — `hermitian_jordan_id` and
`hermitian_formallyReal` — still go through unaltered.

★ Two things this does *not* claim.  It is not claimed that the collision is invisible: instance
search does return a different term inside `open HermMul` once this module is imported, and a
proof that pins the instance by name rather than by its product would notice.  And it is not
claimed that anything currently pays that cost — **no module in the tree imports this one**, so
the four existing `open HermMul` sites (`EJA/Order.lean`, `EJA/Spectral.lean`, `EJA/Witness.lean`,
`EJA/ConcreteInstance.lean`) are all upstream of this file and see exactly what they saw before.

★ One elaboration trap, recorded because it cost a probe round.  Inside the structure-instance
notation, `simpa only [...] using e` **fails** on fields whose statement is in `*` form while `e`
is in `symmMul` form, reporting a type mismatch between `(A + B) * C` and `(A + B).symmMul C`
even though the two are `rfl`-equal (`hermitian_mul_eq_symmMul` below).  The named-lemma route
(`add_mul A B C := hermitian_symmMul_add_left A B C`) succeeds on the same goal.  So the
mismatch is `simpa`'s reducibility setting, not a real failure of the defeq — do not conclude
from such a message that the product is wrong.

## Scope

**No manifest row moves.**  This file is substrate.  What changes is that the M3/M4 results are
now known to be about a nonempty class: `hermitian_exists_jordanFrame` and
`hermitian_frameBlock_isInternal` are `exists_jordanFrame` and `frameBlock_isInternal` read on
`H_n(𝕜)`.  ★ `hermitian_exists_jordanFrame` is an existence statement and stays one — this file
does **not** exhibit a frame on `H_n(𝕜)`, and in particular does not prove the diagonal matrix
units of `EJA/Witness.lean` primitive, which is what naming one would require.
-/

noncomputable section

namespace RadicalRelativity.EJA

open Necessity

variable {n : Type*} [Fintype n] [DecidableEq n] {𝕜 : Type*} [RCLike 𝕜]

/-! ## The three re-orientations the class fields need -/

/-- Additivity of `∘` in its left argument, from `jordanBilinG`'s `LinearMap` structure. -/
theorem hermitian_symmMul_add_left (A B C : HermitianMat n 𝕜) :
    (A + B).symmMul C = A.symmMul C + B.symmMul C := by
  simpa only [jordanBilin_applyG] using (jordanBilinG (n := n) 𝕜).map_add₂ A B C

/-- Real homogeneity of `∘` in its left argument, from `jordanBilinG`'s `LinearMap` structure. -/
theorem hermitian_symmMul_smul_left (r : ℝ) (A B : HermitianMat n 𝕜) :
    (r • A).symmMul B = r • (A.symmMul B) := by
  simpa only [jordanBilin_applyG] using (jordanBilinG (n := n) 𝕜).map_smul₂ r A B

/-- The Jordan identity in the class's orientation, `x ∘ (x² ∘ y) = x² ∘ (x ∘ y)`.
`EJA/Order.lean`'s `hermitian_jordan_id` carries Mathlib's orientation
`(x ∘ y) ∘ x² = x ∘ (y ∘ x²)`; the two differ by commuting the product twice. -/
theorem hermitian_symmMul_jordan (A B : HermitianMat n 𝕜) :
    A.symmMul ((A.symmMul A).symmMul B) = (A.symmMul A).symmMul (A.symmMul B) := by
  have h := hermitian_jordan_id (n := n) (𝕜 := 𝕜) A B
  simp only [jordanBilin_applyG] at h
  rw [HermitianMat.symmMul_comm (A.symmMul A) B, ← h]
  exact HermitianMat.symmMul_comm _ _

/-! ## The instance -/

/-- ★★★ **`H_n(𝕜)` is a Euclidean Jordan algebra.**  The class of `EJA/Class.lean`, on the
paper's own carrier, at the generality `EJA/Order.lean` uses: any `RCLike` scalar field and any
finite decidable index type. -/
instance instEuclideanJordanAlgebraHermitianMat :
    EuclideanJordanAlgebra (HermitianMat n 𝕜) where
  mul := HermitianMat.symmMul
  one := 1
  mul_comm A B := HermitianMat.symmMul_comm A B
  add_mul A B C := hermitian_symmMul_add_left A B C
  smul_mul r A B := hermitian_symmMul_smul_left r A B
  one_mul A := HermitianMat.one_symmMul A
  jordan A B := hermitian_symmMul_jordan A B
  inner_assoc A B C := hermitian_jordan_assoc A B C

/-! ### Fidelity: the class's product is the intended one

Inhabitedness alone would be satisfied by any product making the fields true.  These three
`rfl`s pin the instance's `*` to the three names the rest of the tree uses for `A ∘ B`. -/

/-- The class's product on `H_n(𝕜)` is `HermitianMat.symmMul`. -/
theorem hermitian_mul_eq_symmMul (A B : HermitianMat n 𝕜) : A * B = A.symmMul B := rfl

/-- The class's product on `H_n(𝕜)` is `Necessity.jordanBilinG`, the bilinear map the paper's
`SequentialProduct` layer runs on. -/
theorem hermitian_mul_eq_jordanBilinG (A B : HermitianMat n 𝕜) :
    A * B = jordanBilinG 𝕜 A B := rfl

/-- ★ **The `HermMul` collision is definitional.**  The `Mul` this instance supplies and the one
`RadicalRelativity/Vendor/HermitianMat/Jordan.lean`'s scoped `CommMagma` supplies are the same
structure, so which one instance search returns inside an `open HermMul` section cannot change a
statement.  See the module docstring for what this does and does not claim. -/
theorem hermMul_toMul_eq :
    (HermMul.instCommMagmaHermitianMat (d := n) (𝕜 := 𝕜)).toMul
      = (instEuclideanJordanAlgebraHermitianMat (n := n) (𝕜 := 𝕜)).toMul := rfl

/-! ## Nontriviality -/

/-- `1 ≠ 0` in `H_n(𝕜)` whenever the index type is nonempty: read off the `(i, i)` entry. -/
theorem hermitian_one_ne_zero [Nonempty n] : (1 : HermitianMat n 𝕜) ≠ 0 := by
  intro h
  have h2 := congrArg
    (fun A : HermitianMat n 𝕜 => A.mat (Classical.arbitrary n) (Classical.arbitrary n)) h
  simp only [HermitianMat.mat_one, HermitianMat.mat_zero, Matrix.one_apply_eq,
    Matrix.zero_apply] at h2
  exact one_ne_zero h2

instance instNontrivialHermitianMat [Nonempty n] : Nontrivial (HermitianMat n 𝕜) :=
  ⟨⟨1, 0, hermitian_one_ne_zero⟩⟩

/-! ## M3 and M4 on the carrier

The two campaign results now read on a live object rather than on a class with no known
inhabitant.  Neither proof is new: each is the abstract theorem with `J := H_n(𝕜)`. -/

/-- **(M3) on `H_n(𝕜)`.**  `EJA/FrameExists.lean`'s `exists_jordanFrame`, instantiated.  The
finite-dimensionality it needs is `HermitianMat.FiniteDimensional`; the nontriviality is
`hermitian_one_ne_zero`. -/
theorem hermitian_exists_jordanFrame [Nonempty n] :
    ∃ k, Nonempty (JordanFrame (HermitianMat n 𝕜) k) :=
  exists_jordanFrame (HermitianMat n 𝕜) hermitian_one_ne_zero

/-- **(M4) on `H_n(𝕜)`.**  `EJA/FramePeirce.lean`'s `frameBlock_isInternal`, instantiated: a
Jordan frame of `H_n(𝕜)` splits it as the internal direct sum of its diagonal and coherence
blocks. -/
theorem hermitian_frameBlock_isInternal {k : ℕ} (F : JordanFrame (HermitianMat n 𝕜) k) :
    DirectSum.IsInternal (frameBlock F) :=
  frameBlock_isInternal F

/-- **(M3) and (M4) together on `H_n(𝕜)`**: the algebra has a Jordan frame, and that frame
decomposes it.  This is the statement that was universally quantified over an unwitnessed class
before this file. -/
theorem hermitian_exists_frame_isInternal [Nonempty n] :
    ∃ (k : ℕ) (F : JordanFrame (HermitianMat n 𝕜) k), DirectSum.IsInternal (frameBlock F) := by
  obtain ⟨k, ⟨F⟩⟩ := hermitian_exists_jordanFrame (n := n) (𝕜 := 𝕜)
  exact ⟨k, F, frameBlock_isInternal F⟩

end RadicalRelativity.EJA
