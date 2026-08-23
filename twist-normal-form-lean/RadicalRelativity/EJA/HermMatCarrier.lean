/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Class
import RadicalRelativity.Composition.HermInner

set_option linter.style.longLine false

/-!
# `H_ι(C)` as a Euclidean Jordan algebra, for **associative** `C`

`Composition/HermMat.lean` builds `HermMat ι C` — the hermitian `ι × ι` matrices over a Euclidean
composition algebra `C`, as an `ℝ`-submodule of `Matrix ι ι C` — with the symmetrised product
`A ∘ B = ½(AB + BA)`, and `Composition/HermInner.lean` gives it the entrywise form and the
`NormedAddCommGroup` / `InnerProductSpace ℝ` instances `EJA/Class.lean`'s class is stated over.
Neither file supplies the class itself.  This file does, **at the associative tier only**.

## The associativity boundary, stated first because it is the whole scope of this file

The class's `jordan` field is discharged by `HermMat.lean`'s `jmul_jordan_of_assoc`, whose
section carries `[Ring C]` on top of the composition-algebra bundle — that is, `C` is an
*associative* composition algebra.  Over the Hurwitz list `[Ring C]` means `ℝ`, `ℂ` and `ℍ`, and
**not** `𝕆`.  So the instance below:

* **does** hold at every finite index type `ι`, for `C ∈ {ℝ, ℂ, ℍ}`;
* **does not** cover the octonionic case at any rank, `n = 3` included.  `H_3(𝕆)` is classically
  a Jordan algebra and this tree proves the Jordan identity for it by hand — but on the *other*
  carrier, `Albert/Carrier.lean`'s `h3O`, and `EJA/AlbertCarrier.lean` installs the class there.
  ★ **No claim is made here relating `HermMat (Fin 3) Octonion` to `h3O`.**  As
  `Composition/HermMat.lean`'s docstring records, the two are different types and **no map
  between them is constructed anywhere in the tree**, so `Albert/Jordan.lean`'s Jordan identity
  does not transfer and `EJA/AlbertCarrier.lean`'s instance is not an instance on `HermMat`.
  Extending the instance below to `𝕆` would need that map, or an octonionic proof of
  `jmul_jordan_of_assoc`; neither exists.

★ Nor is the boundary claimed to be *sharp*.  Nothing in this tree proves that `H_n(𝕆)` fails to
be a Jordan algebra for `n ≥ 4`; that is residue (3) of
`WallCertificates/jacobson-coordinatization.lean`, and it is a citation here, not a theorem.

## What this is not

★ **This does not discharge the Jacobson coordinatization residue.**  Coordinatization is the
statement that a suitable Jordan algebra `J` *is isomorphic to* some `H_n(C)`; the isomorphism is
residue (1) of `WallCertificates/jacobson-coordinatization.lean` and is still a `sorry` there, as
are the other two.  What lands here is Jordan structure on the theorem's right-hand side — the
target of an isomorphism nobody has built.  `EJA/Coordinatize.lean`'s residue note is narrowed
accordingly, not struck.

## No field needed new mathematics

Every one of the class's six field obligations is a lemma of `Composition/`, and the one lemma
before the instance is a re-orientation, not a new result.

| class field | discharged by | tier |
| --- | --- | --- |
| `mul` | `jmul` | `[Fintype ι]`, `C` any composition algebra |
| `one` | `hermOne` | `+ [DecidableEq ι] [Nontrivial C]` |
| `mul_comm` | `jmul_comm` | `[Fintype ι]`, `C` any |
| `add_mul` | `jmul_add_left` | `[Fintype ι]`, `C` any |
| `smul_mul` | `jmul_smul_left` | `[Fintype ι]`, `C` any |
| `one_mul` | `jmul_hermOne_left` | `+ [DecidableEq ι] [Nontrivial C]` |
| `jordan` | `hermMat_jmul_jordan'` below, `jmul_jordan_of_assoc` commuted twice | **`[Ring C]`** |
| `inner_assoc` | `hermIp_jmul_assoc` | `[Fintype ι]`, `C` any |

Only `jordan` needs associativity; only `one`/`one_mul` need `[DecidableEq ι]` and
`[Nontrivial C]`, both of which come from the `variable` line of `HermMat.lean`'s `Frame` section
that `hermOne` sits in.  The re-orientation is the same one both existing carriers needed and for
the same reason: `jmul_jordan_of_assoc` carries Mathlib's orientation
`(A ∘ B) ∘ A² = A ∘ (B ∘ A²)` and the class's `jordan` field is oriented `x ∘ (x² ∘ y) =
x² ∘ (x ∘ y)`.

## No `Mul` collision, measured

Both existing carriers had to navigate one: `EJA/HermitianCarrier.lean` collides with the scoped
`HermMul` `CommMagma` and `EJA/AlbertCarrier.lean` with `h3O.instCommMagma`, and each measures
its collision as definitional.  There is **nothing to navigate here**.
`Composition/HermMat.lean:58-60` deliberately installs no `Mul` instance — the product stays
bundled as `hermBilin` — precisely so that a later `NormedAddCommGroup` could be added without
the diamond `EJA/Bridge.lean` exists to dodge.

★ Measured, 2026-08-23: with `Composition.HermInner` imported and this module *not*,
`#synth Mul ↥(HermMat ι C)` and `#synth One ↥(HermMat ι C)` both **fail to synthesize**; with
this module imported they return `instEuclideanJordanAlgebraHermMat.toMul` and `.toOne`.  This
instance is therefore the only source of either structure on the carrier.

The additive diamond does not appear either, and that is checked rather than argued:
`hermMat_normedAddCommGroup_toAddCommGroup` below is `rfl`, so the `AddCommGroup` underneath
`Composition/HermInner.lean`'s norm is literally `Submodule.addCommGroup`, the one the carrier
has carried since it was defined.  `#synth AddCommGroup ↥(HermMat ι C)` returns that submodule
instance.

## What the instance buys

* the class on a third *base* carrier.  Before this file the tree's base instances were
  `HermitianMat n 𝕜` for `RCLike 𝕜` (`EJA/HermitianCarrier.lean`) and `h3O`
  (`EJA/AlbertCarrier.lean`) — grepping `instance … : EuclideanJordanAlgebra` across
  `RadicalRelativity/` on 2026-08-23 returns exactly those two plus
  `EJA/PeirceSubalgebra.lean`'s two, which are conditional on an ambient
  `[EuclideanJordanAlgebra J]` and exhibit nothing on their own.
* the first instance whose **coefficients are quaternionic**.  `HermitianMat n 𝕜` cannot supply
  one: `RCLike 𝕜` covers `ℝ` and `ℂ` only.  ★ This is **not** the claim that the tree had no
  quaternionic hermitian matrices — it has them, as `Hermitian/Symplectic.lean`'s `QuatCarrier n`,
  the `IsQuaternionic` submodule of `HermitianMat (n ⊕ n) ℂ` reached through the complex
  embedding, and `MasterTheorem/Branches/Quaternionic.lean` runs the `thm:quaternionic` branch on
  a block space `V := Quaternion ℝ`.  What is new is the *presentation*: coefficients in `ℍ`
  directly, carrying the class.  **No map between `HermMat ι (Quaternion ℝ)` and `QuatCarrier ι`
  is constructed here or anywhere in the tree**, so nothing transfers between the two in either
  direction.
* **formal reality**, `hermMat_isFormallyReal` below.  `EJA/Class.lean`'s `instIsFormallyReal`
  derives `IsFormallyReal J` from the class unconditionally, so it fires here by synthesis.
  `Composition/HermInner.lean` records that formal reality "is proved nowhere for this carrier";
  that sentence was true when written and is narrowed by this file to the associative tier.

★ What it does **not** buy, deliberately: nothing about frames, rank, Peirce decomposition or
spectral resolution is stated here.  Those results carry further hypotheses — `[Nonempty ι]` for
`1 ≠ 0`, `[FiniteDimensional ℝ C]` for the dimension — and none of them is discharged in this
file.

## Scope

**No manifest row moves.**  This file is substrate, exactly as `EJA/HermitianCarrier.lean` and
`EJA/AlbertCarrier.lean` are.
-/

noncomputable section

namespace RadicalRelativity.EJA

open CompositionAlgebra

/-! ## The one re-orientation the class fields need -/

section Reorient

variable {ι : Type*} [Fintype ι] {C : Type*} [Ring C] [Module ℝ C] [IsScalarTower ℝ C C]
  [SMulCommClass ℝ C C] [CompositionAlgebra C]

/-- The Jordan identity in the class's orientation, `x ∘ (x² ∘ y) = x² ∘ (x ∘ y)`.
`Composition/HermMat.lean`'s `jmul_jordan_of_assoc` carries Mathlib's orientation
`(A ∘ B) ∘ A² = A ∘ (B ∘ A²)`; the two differ by commuting the product twice.  Associativity of
`C` enters only through that lemma — this proof adds none. -/
theorem hermMat_jmul_jordan' (A B : HermMat ι C) :
    jmul A (jmul (jmul A A) B) = jmul (jmul A A) (jmul A B) := by
  rw [jmul_comm (jmul A A) B, ← jmul_jordan_of_assoc A B]
  exact jmul_comm _ _

end Reorient

/-! ## The instance -/

section Instance

variable {ι : Type*} [Fintype ι] [DecidableEq ι] {C : Type*} [Ring C] [Module ℝ C]
  [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C] [Nontrivial C]

/-- ★★★ **`H_ι(C)` is a Euclidean Jordan algebra, for associative `C`.**  `EJA/Class.lean`'s
class on `Composition/HermMat.lean`'s carrier, under the symmetrised product `A ∘ B = ½(AB + BA)`
and `Composition/HermInner.lean`'s entrywise form.

★ `[Ring C]` is the associativity hypothesis, and it is not removable by any argument in this
tree: it is what `jmul_jordan_of_assoc` needs.  Over the Hurwitz list this instance therefore
covers `ℝ`, `ℂ` and `ℍ` and **not** `𝕆` — the octonionic case at rank 3 is carried by the
different type `h3O` in `EJA/AlbertCarrier.lean`, with no map between the two constructed
anywhere.  See the module docstring. -/
instance instEuclideanJordanAlgebraHermMat :
    EuclideanJordanAlgebra (HermMat ι C) where
  mul := jmul
  one := hermOne
  mul_comm A B := jmul_comm A B
  add_mul A B D := jmul_add_left A B D
  smul_mul r A B := jmul_smul_left r A B
  one_mul A := jmul_hermOne_left A
  jordan A B := hermMat_jmul_jordan' A B
  inner_assoc A B D := hermIp_jmul_assoc A B D

/-! ### Fidelity: the class's product and unit are the intended ones

Inhabitedness alone would be satisfied by any product making the fields true.  These `rfl`s pin
the instance's `*` to the two names `Composition/` uses for `A ∘ B`, and its `1` to the carrier's
own unit. -/

/-- The class's product on `H_ι(C)` is `CompositionAlgebra.jmul`. -/
theorem hermMat_mul_eq_jmul (A B : HermMat ι C) : A * B = jmul A B := rfl

/-- The class's product on `H_ι(C)` is `CompositionAlgebra.hermBilin`, the bundled bilinear map
`EJA/Order.lean`'s interfaces and `Composition/HermInner.lean`'s `hermHassoc` run on. -/
theorem hermMat_mul_eq_hermBilin (A B : HermMat ι C) : A * B = hermBilin A B := rfl

/-- The class's unit on `H_ι(C)` is `CompositionAlgebra.hermOne`, the identity matrix. -/
theorem hermMat_one_eq_hermOne : (1 : HermMat ι C) = hermOne := rfl

omit [DecidableEq ι] [Nontrivial C] in
/-- ★ **No additive diamond.**  The `AddCommGroup` underneath `Composition/HermInner.lean`'s
`NormedAddCommGroup` — the one `EJA/Class.lean`'s `instNonUnitalNonAssocCommRing` builds its ring
on — is definitionally the submodule's own.  So the class introduces one multiplicative structure
onto an additive structure that was already there, which is what `EJA/Bridge.lean` and
`EJA/Class.lean` were written to arrange. -/
theorem hermMat_normedAddCommGroup_toAddCommGroup :
    @NormedAddCommGroup.toAddCommGroup (HermMat ι C) instNormedAddCommGroupHermMat
      = Submodule.addCommGroup (HermMat ι C) := rfl

/-! ## Formal reality, for free -/

/-- **`H_ι(C)` is formally real**, for associative `C`.  Not a new argument: `EJA/Class.lean`'s
`instIsFormallyReal` derives formal reality from the associative inner product for *any* algebra
carrying the class, so this is synthesis.

★ It narrows, and does not strike, `Composition/HermInner.lean`'s "formal reality is proved
nowhere for this carrier": that remains true for non-associative `C`, since the derivation runs
through the class and the class is only available here under `[Ring C]`. -/
theorem hermMat_isFormallyReal : IsFormallyReal (HermMat ι C) := inferInstance

end Instance

end RadicalRelativity.EJA
