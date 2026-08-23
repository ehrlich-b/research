/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert.Jordan
import RadicalRelativity.EJA.FramePeirce

set_option linter.style.longLine false

/-!
# `h₃(𝕆)` as a Euclidean Jordan algebra

`EJA/HermitianCarrier.lean` supplies the associative carrier `H_n(𝕜)` for `EJA/Class.lean`'s
class.  This file supplies the **exceptional** one: the Albert algebra `h₃(𝕆)` of
`RadicalRelativity/Albert/`, the 27-dimensional real vector space of hermitian `3 × 3`
octonionic matrices under `a ∘ b = ½(ab + ba)` and the trace form `⟪a, b⟫ = Tr(a ∘ b)`.

Until this file the class had exactly one *base* witness — `H_n(𝕜)`.
`EJA/PeirceSubalgebra.lean`'s two instances are conditional on an ambient
`[EuclideanJordanAlgebra J]`, so they inherit whatever base is supplied and exhibit nothing on
their own.  Every theorem stated over the class was therefore, as far as the tree knew, a
theorem about algebras of matrices.  `h₃(𝕆)` is not one: it is the exceptional simple Euclidean
Jordan algebra, not isomorphic to any algebra of self-adjoint matrices over an associative ring.
★ That last clause is a fact from the literature (Jordan–von Neumann–Wigner; Albert), **not**
proved anywhere in this tree, and nothing below depends on it — what is proved here is that the
class holds of `h₃(𝕆)`, not that `h₃(𝕆)` is new to the class up to isomorphism.

## No field needed new mathematics

Every one of the class's six field obligations was proved in `RadicalRelativity/Albert/`,
and four of them are literally the lemma the `Albert/` layer states:

| class field | discharged by |
| --- | --- |
| `mul_comm` | `h3O.jordanMul_comm` |
| `add_mul` | `h3O.jordanMul_add_left` |
| `smul_mul` | `h3O.jordanMul_smul_left` |
| `one_mul` | `h3O.jordanMul_one_left` |
| `jordan` | `albert_jordanMul_jordan'` below, `h3O.jordanMul_jordan` commuted twice |
| `inner_assoc` | `albert_inner_jordanMul_assoc` below, `h3O.traceForm_jordanMul_assoc` read through `h3O.inner_def` |

The two lemmas before the instance are re-orientations, not new results.  The first is the one
`EJA/HermitianCarrier.lean` also needed and for the same reason: Mathlib's `IsCommJordan`
orients the Jordan identity as `(a ∘ b) ∘ a² = a ∘ (b ∘ a²)` and the class orients it as
`x ∘ (x² ∘ y) = x² ∘ (x ∘ y)`.  The second has no counterpart there — `EJA/Order.lean`'s
`hermitian_jordan_assoc` is already in inner-product vocabulary, whereas `Albert/Inner.lean`
states the Euclidean hypothesis on `jordanBilinO`, so it has to be read back onto the bare
product.  Conversely `EJA/HermitianCarrier.lean`'s other two re-orientations have no
counterpart here: they unbundle `jordanBilinG`'s `LinearMap` structure to get `add_mul` and
`smul_mul`, which `Albert/Mul.lean` proves on the bare function directly.

## The `Mul` collision, measured

`Albert/Jordan.lean` installs `h3O.instCommMagma` in order to state Mathlib's
`IsCommJordan h3O`; this file's class instance supplies a second `Mul h3O` through
`toMul`.  The collision is **definitional**: `albert_commMagma_toMul_eq` below is `rfl`, both
structures having `h3O.jordanMul` as their multiplication.

★ What that costs, measured rather than argued.  With this module imported the four searches
split, and they split *across* the two structures:

| search | returns |
| --- | --- |
| `Mul h3O` | `instEuclideanJordanAlgebraH3O.toMul` |
| `CommMagma h3O` | `h3O.instCommMagma` |
| `IsCommJordan h3O` | `h3O.instIsCommJordan` |
| `NonUnitalNonAssocCommRing h3O` | `EuclideanJordanAlgebra.instNonUnitalNonAssocCommRing` |

★ Note what that table does *not* say.  Mathlib's `IsCommJordan` is declared `[CommMagma A]`,
not `[Mul A]`, so the third row is settled by the second and involves no comparison with the
first — an earlier version of this paragraph read the two together as evidence that instance
search had checked the two `Mul`s against each other, and that inference was wrong.  What
actually exercises the defeq is writing a statement whose `*` comes from row 1 and proving it
with a term whose type comes from row 2, which is `albert_isCommJordan_through_class` below.
That it elaborates is the measurement: the two structures are interchangeable in use, not merely
`rfl`-equal on paper, and `EuclideanJordanAlgebra.instIsCommJordan` is shadowed on `h3O` without
consequence.

★ Two things this does *not* claim.  It is not claimed that the collision is invisible: a proof
that pinned the `Mul` instance by name rather than by its product would notice.  And it is not
claimed that anything currently pays the cost — **no module in the tree imports this one** (only
the root aggregator does), so `Albert/Jordan.lean`'s own `h3O.mul_eq_jordanMul` and everything
else stated over `instCommMagma` sees exactly what it saw before.

★ **Corrected 2026-08-23**: one module now does import this one.  `EJA/AlbertBridge.lean` imports
it, and its `toHermMat_mul` is stated with the `*` a `Mul h3O` search returns — this instance's
`toMul` — and proved by `toHermMat_jordanMul`, which is stated on the bare `h3O.jordanMul`.  That
elaborating is one more exercise of the defeq, alongside `albert_isCommJordan_through_class`
below.  The rest of the paragraph stands: nothing stated over `instCommMagma` changed.

The `AddCommGroup` diamond `EJA/Bridge.lean` and `EJA/Class.lean` were written to dodge does
**not** appear.  `CommMagma` extends `Mul` alone and carries no additive data, and the class
`extends Mul J, One J` over the ambient `[NormedAddCommGroup J] [InnerProductSpace ℝ J]`, so the
only `AddCommGroup h3O` in play throughout is `Albert/Carrier.lean`'s `h3O.instAddCommGroup`,
the one `Albert/Inner.lean` builds its `NormedAddCommGroup` on top of.

## What the port buys

* the class instance, and with it `exists_jordanFrame`, `frameBlock_isInternal` and
  `spectral_resolution_complete'` on `h₃(𝕆)` — `albert_exists_jordanFrame`,
  `albert_frameBlock_isInternal`, `albert_spectral_resolution` below;
* `EJA/Order.lean`'s `orderUnitSpaceOfBilinear` on `h₃(𝕆)` — `albertOrderUnitOfEJA` — with the
  cone of sums of squares as the positive cone and `1` as the order unit;
* `OrderUnitSpace.IsArchimedean` for that structure (`albert_isArchimedean_ofEJA`).  `H_n(𝕜)`
  was the only carrier in the tree discharging `IsArchimedean`; `h₃(𝕆)` is a second one.  This
  retires no caveat that was still open — `HermitianMat.isArchimedean` retired the ARC-6
  exposure already — but it is the first *exceptional* discharge;
* the cone of the constructed order is the cone of single squares (`albert_isSoS_iff_exists_sq`).

★ What it does **not** buy, since the enabling plan for this port said otherwise: Jordan
**square roots** and the quadratic representation `Q_{√a}` do **not** become available on
`h₃(𝕆)`.  They are not part of the `EJA/` layer — listing every `def` and `abbrev` in
`RadicalRelativity/EJA/*.lean` on 2026-08-23 turns up no Jordan square root and no quadratic
representation, and outside this docstring the only `sqrt` occurring in any `EJA/` module is
`Real.sqrt`, in the proofs of exactly two of them, `EJA/Order.lean`'s `IsSoS.smul` and
`isSoS_iff_exists_sq` (an earlier version of this sentence said three).
★ The tree *does* have both, and an earlier version of this
paragraph wrongly said it did not: `Necessity.quadRep` is `Q_{√a}` and the square root is the
vendored continuous functional calculus (`a.cfc Real.sqrt`), with the quaternionic restriction
in `Hermitian/QuatQuadRep.lean`.  Both are stated over `HermitianMat`, not over the class, so
neither transfers to `h₃(𝕆)` along this instance.  What is available is the list above.

## Scope

**No manifest row moves.**  This file is substrate, exactly as `EJA/HermitianCarrier.lean` is.
In particular row 21 `thm:albert` is *not* discharged by it: that row says an arbitrary S1--S7
sequential product on `h₃(𝕆)` must be Lüders, and what is built here is the carrier's
Euclidean-Jordan structure — the ambient object such a product would live on, not a statement
about products on it.  `EJA/Order.lean`'s `SequentialProductOnEJA` becomes *writable* at
`h₃(𝕆)`, which is statability and not an inhabitant; no inhabitant is constructed here and none
is claimed.
-/

noncomputable section

namespace RadicalRelativity.EJA

open RadicalRelativity.Albert

/-! ## The two re-orientations the class fields need -/

/-- The Jordan identity in the class's orientation, `x ∘ (x² ∘ y) = x² ∘ (x ∘ y)`.
`Albert/Jordan.lean`'s `jordanMul_jordan` carries Mathlib's orientation
`(x ∘ y) ∘ x² = x ∘ (y ∘ x²)`; the two differ by commuting the product twice. -/
theorem albert_jordanMul_jordan' (a b : h3O) :
    h3O.jordanMul a (h3O.jordanMul (h3O.jordanMul a a) b)
      = h3O.jordanMul (h3O.jordanMul a a) (h3O.jordanMul a b) := by
  rw [h3O.jordanMul_comm (h3O.jordanMul a a) b, ← h3O.jordanMul_jordan a b]
  exact h3O.jordanMul_comm _ _

/-- The Euclidean hypothesis on the bare product, in inner-product vocabulary.
`Albert/Inner.lean`'s `hassoc` says this of `jordanBilinO`; the class's field is stated on the
product itself. -/
theorem albert_inner_jordanMul_assoc (x y z : h3O) :
    (inner ℝ (h3O.jordanMul x y) z : ℝ) = inner ℝ y (h3O.jordanMul x z) := by
  simp only [h3O.inner_def]
  exact h3O.traceForm_jordanMul_assoc x y z

/-! ## The instance -/

/-- ★★★ **`h₃(𝕆)` is a Euclidean Jordan algebra.**  `EJA/Class.lean`'s class on the exceptional
carrier: the 27-dimensional Albert algebra under `a ∘ b = ½(ab + ba)` and the trace form. -/
instance instEuclideanJordanAlgebraH3O : EuclideanJordanAlgebra h3O where
  mul := h3O.jordanMul
  one := 1
  mul_comm := h3O.jordanMul_comm
  add_mul := h3O.jordanMul_add_left
  smul_mul := h3O.jordanMul_smul_left
  one_mul := h3O.jordanMul_one_left
  jordan := albert_jordanMul_jordan'
  inner_assoc := albert_inner_jordanMul_assoc

/-! ### Fidelity: the class's product is the intended one

Inhabitedness alone would be satisfied by any product making the fields true.  These `rfl`s pin
the instance's `*` to the two names the `Albert/` layer uses for `a ∘ b`, and its `1` to the
carrier's own unit. -/

/-- The class's product on `h₃(𝕆)` is `h3O.jordanMul`. -/
theorem albert_mul_eq_jordanMul (a b : h3O) : a * b = h3O.jordanMul a b := rfl

/-- The class's product on `h₃(𝕆)` is `h3O.jordanBilinO`, the bundled bilinear map
`ComparisonSetup` and `EJA/Order.lean` both run on. -/
theorem albert_mul_eq_jordanBilinO (a b : h3O) : a * b = h3O.jordanBilinO a b := rfl

/-- The class's unit on `h₃(𝕆)` is `Albert/Carrier.lean`'s `diag(1,1,1)`.  ★ Unlike the `Mul`
collision, this one is not even visible to instance search: with this module imported
`#synth One h3O` still returns `h3O.instOne`, not the class's `toOne`. -/
theorem albert_one_eq : (instEuclideanJordanAlgebraH3O).toOne = h3O.instOne := rfl

/-- ★ **The `CommMagma` collision is definitional.**  The `Mul` this instance supplies and the
one `Albert/Jordan.lean`'s `h3O.instCommMagma` supplies are the same structure, so which one
instance search returns cannot change a statement.  See the module docstring for what this does
and does not claim. -/
theorem albert_commMagma_toMul_eq :
    (h3O.instCommMagma).toMul = (instEuclideanJordanAlgebraH3O).toMul := rfl

/-- ★ **The two `Mul` structures are interchangeable in use, not merely `rfl`-equal on paper.**
The statement's `*` is the one a `Mul h3O` search returns — the class's `toMul`; the proof
term's type is stated over the `CommMagma` an `IsCommJordan h3O` search returns —
`Albert/Jordan.lean`'s `h3O.instCommMagma`.  Elaborating this is what actually checks the two
against each other; the `#synth` table in the module docstring does not, and said so only after
a first draft claimed otherwise. -/
theorem albert_isCommJordan_through_class (a b : h3O) :
    (a * b) * (a * a) = a * (b * (a * a)) :=
  IsCommJordan.lmul_comm_rmul_rmul a b

/-! ## Nontriviality -/

/-- `1 ≠ 0` in `h₃(𝕆)`: read off the `(1,1)` diagonal entry. -/
theorem albert_one_ne_zero : (1 : h3O) ≠ 0 := by
  intro h
  have h2 := congrArg (fun a : h3O => a.diag 0) h
  simp only [h3O.one_diag, h3O.zero_diag] at h2
  exact one_ne_zero h2

instance instNontrivialH3O : Nontrivial h3O := ⟨⟨1, 0, albert_one_ne_zero⟩⟩

/-! ## M3, M4 and the spectral theorem on `h₃(𝕆)`

None of these proofs is new: each is the abstract theorem with `J := h₃(𝕆)`.  What is new is
that they now read on the exceptional algebra rather than only on matrix algebras. -/

/-- **(M3) on `h₃(𝕆)`.**  `EJA/FrameExists.lean`'s `exists_jordanFrame`, instantiated.  The
finite-dimensionality is `h3O.instFiniteDimensional` (`finrank ℝ h₃(𝕆) = 27`); the
nontriviality is `albert_one_ne_zero`.  ★ The cardinality is existentially quantified and is
**not** claimed to be `3`, nor to be the rank — `EJA/Rank.lean` proves only that a frame's
cardinality is bounded by the rank and by the dimension. -/
theorem albert_exists_jordanFrame : ∃ n, Nonempty (JordanFrame h3O n) :=
  exists_jordanFrame h3O albert_one_ne_zero

/-- **(M4) on `h₃(𝕆)`.**  `EJA/FramePeirce.lean`'s `frameBlock_isInternal`, instantiated: a
Jordan frame of `h₃(𝕆)` splits it as the internal direct sum of its diagonal and coherence
blocks. -/
theorem albert_frameBlock_isInternal {n : ℕ} (F : JordanFrame h3O n) :
    DirectSum.IsInternal (frameBlock F) :=
  frameBlock_isInternal F

/-- **(M3) and (M4) together on `h₃(𝕆)`.** -/
theorem albert_exists_frame_isInternal :
    ∃ (n : ℕ) (F : JordanFrame h3O n), DirectSum.IsInternal (frameBlock F) := by
  obtain ⟨n, ⟨F⟩⟩ := albert_exists_jordanFrame
  exact ⟨n, F, frameBlock_isInternal F⟩

/-- **(E1) with completeness on `h₃(𝕆)`.**  `EJA/Class.lean`'s `spectral_resolution_complete'`,
instantiated: every element is a real combination of an orthogonal idempotent family summing to
the unit. -/
theorem albert_spectral_resolution (x : h3O) :
    ∃ (n : ℕ) (c : Fin n → h3O) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∑ i, c i) = 1 ∧ x = ∑ i, lam i • c i :=
  spectral_resolution_complete' x

/-! ## The order unit space on `h₃(𝕆)`

`EJA/Order.lean`'s construction, applied to the exceptional carrier.  A `def`, not an
`instance`, for the reason that file records: a global `OrderUnitSpace` instance keyed on the
EJA typeclasses would collide with the one `RadicalRelativity/Hermitian/OrderUnit.lean` already
puts on the paper's own carrier. -/

/-- **The order unit space on `h₃(𝕆)`**: the cone of sums of squares of the Jordan product, with
`1` as the order unit.  All five hypotheses are the ones `Albert/Mul.lean`, `Albert/Inner.lean`
and `Albert/Jordan.lean` were written to state in these exact shapes. -/
@[instance_reducible]
def albertOrderUnitOfEJA : OrderUnitSpace h3O :=
  orderUnitSpaceOfBilinear (J := h3O) h3O.jordanBilinO h3O.hcomm h3O.hjordan h3O.hfr
    (1 : h3O) h3O.jordan_unit

/-- The Archimedean squeeze holds for the constructed structure on `h₃(𝕆)`.  Before this file
`H_n(𝕜)` was the only carrier in the tree discharging `OrderUnitSpace.IsArchimedean`; this is
the first exceptional one.  It retires no caveat that was still open. -/
theorem albert_isArchimedean_ofEJA :
    @OrderUnitSpace.IsArchimedean h3O albertOrderUnitOfEJA :=
  isArchimedean_ofBilinear (J := h3O) (m := h3O.jordanBilinO) h3O.hcomm h3O.hjordan h3O.hfr
    h3O.hassoc (1 : h3O) h3O.jordan_unit

/-- And the cone of the constructed order on `h₃(𝕆)` is the cone of *single* squares — the
reading `WallCertificates/eja-gated.lean`'s `JBPremises.nonneg_iff_squares` pins. -/
theorem albert_isSoS_iff_exists_sq (a : h3O) :
    IsSoS h3O.jordanBilinO a ↔ ∃ b : h3O, a = h3O.jordanBilinO b b :=
  isSoS_iff_exists_sq (J := h3O) (m := h3O.jordanBilinO) h3O.hcomm h3O.hjordan h3O.hfr
    h3O.hassoc (1 : h3O) h3O.jordan_unit a

end RadicalRelativity.EJA
