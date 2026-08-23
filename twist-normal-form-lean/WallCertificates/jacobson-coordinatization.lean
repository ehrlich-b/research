/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Bryan Ehrlich
-/
import RadicalRelativity

set_option linter.style.longLine false

/-!
# WALL CERTIFICATE — Jacobson coordinatization, the three residues

**Written 2026-08-23.**

`RadicalRelativity/EJA/Connection.lean`, `EJA/Coordinatize.lean` and `EJA/CoordinatizeWitness.lean`
build the coordinate algebra of a Jordan frame and prove it is a Euclidean composition algebra,
custom axioms exactly `[]`. What they do **not** build is the isomorphism `J ≅ H_n(C)`. This file
states the three separately-statable things that resist, so that each is a proposition that can be
falsified rather than a paragraph asserting a price.

★★ **Residue 1 is DISCHARGED as of 2026-08-23** — `H_n(C)` exists, as
`RadicalRelativity/Composition/HermMat.lean`'s `CompositionAlgebra.HermMat`; read that section
below before quoting this file's "does not exist as a type". Residues 2 and 3 are untouched and
all three `sorry`s below stand, because none of them was the *type*: the isomorphism, the ideal
notion and the four-index associativity argument are all still absent.

```
cd /Users/ehrlich/repos/research/twist-normal-form-lean
grep -rn "^import.*WallCertificates" RadicalRelativity/ RadicalRelativity.lean   # expect no hits
lake env lean WallCertificates/jacobson-coordinatization.lean 2>&1 | grep -cF 'declaration uses `sorry`'   # expect: 3
```

## What is proved

Measured 2026-08-23 against the tree at commit `a4aa51c`; 1,047 lines in three modules, 94
declarations, `grep -cE 'sorry|native_decide|^axiom '` returns `0` in each.

| statement | name | status |
| --- | --- | --- |
| the fully linearised Jordan identity, pointwise | `lin_jordan` | **proved**, axioms `[]` |
| `x ∘ x = a • (pᵢ + pⱼ)` on `V_{ij}` — a *single* coefficient | `exists_sq_smul` | **proved**, axioms `[]` |
| `x ∘ (x ∘ y) = (a/4) • y` for `x ∈ V_{ij}`, `y ∈ V_{jk}` | `block_sq_act` | **proved**, axioms `[]` |
| the composition law on the blocks | `block_mul_sq` | **proved**, axioms `[]` |
| connectors exist on a nonzero block; transfer is an involution and a linear equivalence | `exists_isConnector`, `connEquiv` | **proved**, axioms `[]` |
| the coordinate product `x ⊙ y = 8 ((x ∘ w) ∘ (v ∘ y))`, bilinear, closed, two-sided unital | `coordMul_*` | **proved**, axioms `[]` |
| its composition law | `coordMul_sq` | **proved**, axioms `[]` |
| `CoordAlg D` is a `NonAssocRing` and a `CompositionAlgebra` | `CoordAlg.instCompositionAlgebra` | **proved**, axioms `[]` |
| `dim V_{ij} ∈ {1, 2, 4, 8}` | `CoordAlg.finrank_coordAlg` | **proved**, axioms `[]` |
| `V_{ij} ≅ ℝ, ℂ, ℍ or 𝕆` as a composition algebra | `CoordAlg.classification_coordAlg` | **proved**, axioms `[]` |
| a `CoordData` exists on `H_d(ℂ)` | `isConnector_offFrame`, `hermCoordData` | **proved**, axioms `[]` |
| `J ≅ H_n(C)` | `jacobson_coordinatization` below | **`sorry` — this certificate** |
| simple ⟹ every block nonzero | `simple_frame_connected` below | **`sorry` — this certificate** |
| `n ≥ 4` forces the coordinate algebra associative | `coordAlg_assoc_of_four` below | **`sorry` — this certificate** |

★ **This table was written when only the dimension half of Hurwitz existed, and was overtaken the
same morning.** `Composition/Classification.lean` landed the classification half, so
`CoordAlg.classification_coordAlg` now says the block is isomorphic as a composition algebra to
`ℝ`, `ℂ`, `ℍ` or `𝕆`, not merely of one of their dimensions. What still does **not** follow is
*which* branch: `dim V_{ij} = 2` for `H_d(ℂ)` is not proved anywhere, and picking the branch needs
a dimension computation on the block, not more Hurwitz. None of the three residues below moves on
this.

## Residue 1 — DISCHARGED 2026-08-23. `H_n(C)` now exists as a type; the vendored one still
cannot be reused

The tree's hermitian matrices are `RadicalRelativity/Vendor/HermitianMat/`. Their Jordan product
is declared at
`RadicalRelativity/Vendor/HermitianMat/Jordan.lean:26`, `variable {d 𝕜 : Type*} [Fintype d]
[Field 𝕜] [StarRing 𝕜]`, and everything past line 147 of that file additionally assumes
`[RCLike 𝕜]`. **A composition algebra is neither a field nor associative nor commutative**, so no
declaration in that directory applies to `H_n(C)` for `C` a coordinate algebra. This is not a
matter of relaxing a `variable` line: `Matrix.mul` over the vendored coefficients is associative
and the hermitian predicate is `Matrix.IsHermitian`, i.e. `Aᴴ = A`, which needs `Star`.

★ **`CompositionAlgebra` carries no `Star` instance.** `grep -rn "instance.*Star\|extends.*Star"
RadicalRelativity/Composition/Defs.lean` returns **0** lines; conjugation there is the plain
function `CompositionAlgebra.cstar` (`Defs.lean:174`), a `def`, not a class field. So
`Matrix.conjTranspose` is unavailable and the hermitian condition has to be written out
entrywise, as it is in the gap statement below.

What *is* de-risked: Mathlib's `Matrix n n α` gets `Mul` from `[Fintype n] [Mul α]
[AddCommMonoid α]`, so non-associative coefficients need no work at all. The carrier is cheap;
the surrounding API is what is absent.

★★ **DISCHARGED 2026-08-23 by `RadicalRelativity/Composition/HermMat.lean`**, 48 declarations,
`grep -cE 'sorry|native_decide|^axiom '` returns `0`, `#print axioms` on each of
`symmMul_mem`, `jmul`, `hermBilin`, `hermIdem_jmul_hermOff`, `hermCongr_jmul`,
`jmul_jordan_of_assoc` gives exactly `[propext, Classical.choice, Quot.sound]`, and the tree's
census passes at 197 modules with custom axioms `[]`. `CompositionAlgebra.HermMat ι C` is the
hermitian matrices as a `Submodule ℝ (Matrix ι ι C)` with the entrywise condition
`A j i = cstar (A i j)`, and `jmul` / `hermBilin` is `½(AB + BA)`, closed on it
(`symmMul_mem`, which spends `cstar_mul`'s anti-multiplicativity and no associativity).

★ The paragraph above **priced this residue by reading declaration hypotheses rather than by
compiling**, and the compile agrees on both halves: the ambient really was free (the `Mul`
instance at `Mathlib/Data/Matrix/Mul.lean:302` needs only `[Fintype n] [Mul α]
[AddCommMonoid α]`), and the API really was the work. What the prediction did **not** name is
that the diagonal-is-real clause is *not* an extra condition: `cstar x = x ⟹ x = ip x 1 • 1`
(`eq_smul_one_of_cstar_eq_self`), so the `i = j` instance of the entrywise condition already
says it.

★ Three limits of the discharge, so it is not read as more than it is. **(a)** `HermMat ι C` is
**not** proved to be a Jordan algebra for non-associative `C`: `jmul_jordan_of_assoc` assumes
`[Ring C]`, and `jmul_jordan_of_isCompIso` extends that only to `C` isomorphic to such a ring —
between them they cover the `ℝ`, `ℂ`, `ℍ` branches of `CoordAlg.classification_coordAlg` and
**not** the `𝕆` branch, at any rank. Neither half of the classical "`H_n(𝕆)` is Jordan iff
`n ≤ 3`" is proved anywhere in the tree. **(b)** No dimension count: `finrank ℝ (HermMat (Fin 3)
Octonion) = 27` is not proved and no basis is constructed; the only non-degeneracy fact is
`hermOff_injective`. **(c)** No connection to `Albert/`: `h3O` is a *different type* (a structure
of 3 reals and 3 octonions, not 9 matrix entries), and no map between it and
`HermMat (Fin 3) Octonion` is constructed, so "the same algebra" remains a design intention.

## Residue 2 — there is no notion of a Jordan ideal in this tree

`grep -rnE "^(noncomputable )?(def|structure|class|abbrev|instance|theorem)" RadicalRelativity/ |
grep -icE "ideal|simple"` returns **2**, and neither is one: the first is prose inside a docstring
(`EJA/AlbertCarrier.lean:23`, a sentence beginning "theorem about algebras of matrices"), the
second is `EJA/Spectral.lean:166`, `jann (x : J) : Ideal (Polynomial ℝ)` — an ideal of the
*polynomial ring*, used for the spectral theorem, with no relation to ideals of `J`.

Mathlib has nothing either: `Mathlib/Algebra/Jordan/` is one file, `Basic.lean`, with **12**
declarations (`grep -cE "^theorem|^class|^instance"`), all of them operator-commutation or
linearised-identity lemmas.

So both the ideal notion and the simplicity notion are defined *in this certificate*, below,
which is the honest form of "the vocabulary is missing".

★ The article's flagship row hypothesises **simple**. That hypothesis is currently unusable in
this tree: nothing can consume it. `EJA/Connection.lean`'s `exists_isConnector_iff` and
`exists_isConnector_trans` are the two halves of the connectedness argument that *are* available
— the block-is-nonzero ⟺ connector-exists equivalence, and transitivity along the frame graph.
What is missing is the step that turns a disconnection of the frame graph into a proper ideal.

## Residue 3 — `n ≥ 4` forces associativity, and nothing here is a step towards it

Without it, `H_{n≥4}(𝕆)` survives as a spurious branch of the classification. `grep -rniE
"assoc.*four|rank_ge_4|n_ge_4" RadicalRelativity/` returns one hit and it is prose about
`jspan_assoc` in `EJA/Subalgebra.lean:35`, a different statement. The argument needs a *fourth*
index and is the Jordan identity applied across three distinct off-diagonal blocks;
`EJA/Coordinatize.lean` never uses more than three indices, by construction.

★ **Not attempted, and not priced.** I did not write the four-index computation down, in Lean or
on paper. The one thing I can say from the build is structural rather than numeric: every
multiplication rule this development consumed came out of `EJA/PeirceMul.lean`'s single-idempotent
rules plus completeness, and residue 3 is the first step that is not of that form.

## What the shape of the missing isomorphism actually is

Recorded because it was derived (in the `H_n(C)` model, before any Lean) and is the load-bearing
design fact for whoever closes this:

Fix connectors `c_{1j} ∈ V_{1j}` for `j = 2, …, n`, with `C := V_{12}` and unit `c_{12}`. The
coordinate maps are `φ_{1j} : C → V_{1j}`, `x ↦ 2 (x ∘ c_{2j})` for `j ≥ 3`, and the general
`φ_{ij}` is composed from them; the diagonal is `ℝ ∙ pᵢ`, which is where
`EJA/FramePeirceMul.lean`'s `dim V_{ii} = 1` is spent. Bijectivity is
`EJA/FramePeirce.lean`'s `frameBlock_isInternal` plus each `φ_{ij}` being a linear equivalence,
which is `EJA/Connection.lean`'s `connEquiv`. **So the linear half of the isomorphism is
essentially assembled already.** What is not is multiplicativity, which is a case analysis over
*pairs* of index pairs — diagonal·diagonal, diagonal·off, off·off-sharing-one-index,
off·off-sharing-both, off·off-disjoint — and each case is one line of
`EJA/FramePeirceMul.lean`'s table read through the `φ`'s.

★ That paragraph is a design estimate. **Prices decay here**: the two identities this certificate
records as proved were themselves priced as the campaign's only zero-anchor module at 1,500–3,500
lines, and the part that got built came to 1,047 lines including a carrier the plan did not ask
for. Read "essentially assembled already" as a claim about which lemmas exist, not as a number.

## Absence claims, with the scope of the grep that supports each

All run 2026-08-23 from the repo root against the tree at `a4aa51c` and against Mathlib at the
pinned v4.33.0 checkout (`.lake/packages/mathlib`, `lake-manifest.json`).

* **No Jordan ideal, no simplicity, anywhere in `RadicalRelativity/`** — the grep above, 2 hits,
  both accounted for by name and line.
* **No `Star` on `CompositionAlgebra`** — `grep -rn "instance.*Star\|extends.*Star"
  RadicalRelativity/Composition/Defs.lean`, 0 lines.
* **The vendored `HermitianMat` layer is over fields** — the four `variable` lines of
  `Vendor/HermitianMat/Jordan.lean` (26, 91, 126, 147), read directly.
* **Mathlib's Jordan directory is 12 declarations** — `ls
  .lake/packages/mathlib/Mathlib/Algebra/Jordan/` is `Basic.lean` alone;
  `grep -cE "^theorem|^class|^instance"` on it is 12.

★ Each of these is evidence about a *string*, not about mathematics. The one I would re-run first
before trusting is the Jordan-ideal absence: "ideal" and "simple" are English words, and a Jordan
ideal could perfectly well have been named something else. The stronger evidence for that one is
positive rather than negative — `EJA/`'s 28 modules were read for this build and none of them
defines a subobject closed under multiplication by the whole algebra;
`EJA/PeirceSubalgebra.lean` builds `NonUnitalSubalgebra`s, which are closed under multiplication
*within themselves* and are a different thing.

## The gaps, stated

`IsJordanIdeal` and `IsSimpleEJA` below are definitions **of this certificate**, not of the tree.
The `sorry`s are on `simple_frame_connected`, `jacobson_coordinatization` and
`coordAlg_assoc_of_four`, and nowhere else.

★ `jacobson_coordinatization` is stated against `Matrix (Fin n) (Fin n) (CoordAlg D)` with the
hermitian condition spelled out entrywise, rather than against a bundled `H_n(C)`. **The reason
given for that is now stale**: it said the bundled type does not exist, and since 2026-08-23 it
does (`CompositionAlgebra.HermMat`, residue 1 above). The statement is deliberately left
unchanged — it is what an `H_n(C)` isomorphism unfolds to, so discharging it is still the full
content — but the consequence clause is retracted: the type the classification theorem would want
to name now exists, and `HermMat n (CoordAlg D)` with `hermBilin` is available to restate this
`sorry` against whenever someone attacks it.
-/

namespace JacobsonWall

open RadicalRelativity.EJA
open RadicalRelativity.EJA.EuclideanJordanAlgebra

universe u

variable {J : Type u} [NormedAddCommGroup J] [InnerProductSpace ℝ J]
  [EuclideanJordanAlgebra J] [FiniteDimensional ℝ J] {n : ℕ}

/-- An **ideal** of a Jordan algebra: a submodule absorbing multiplication by the whole algebra.
Defined here because the tree has no such notion — see residue 2. -/
def IsJordanIdeal (I : Submodule ℝ J) : Prop := ∀ x : J, ∀ y ∈ I, x * y ∈ I

/-- **Simplicity**: no ideal other than `0` and `J`.  Defined here, not in the tree. -/
def IsSimpleEJA (J : Type u) [NormedAddCommGroup J] [InnerProductSpace ℝ J]
    [EuclideanJordanAlgebra J] : Prop :=
  ∀ I : Submodule ℝ J, IsJordanIdeal I → I = ⊥ ∨ I = ⊤

/-- **Residue 2.**  In a simple Euclidean Jordan algebra every off-diagonal block of every Jordan
frame is nonzero — equivalently, by `exists_isConnector_iff`, every pair of frame members is
joined by a connector.

The classical argument: if the graph `i ~ j ↔ V_{ij} ≠ 0` disconnects as `A ⊔ B`, then
`e_A = ∑_{i ∈ A} pᵢ` is a central idempotent and `J₂(e_A)` is a proper nonzero ideal.  Both halves
are missing — the tree has no ideal notion (this file supplies one) and no statement that
`J₂(e)` is an ideal for a central `e`. -/
theorem simple_frame_connected [Nontrivial J] (hs : IsSimpleEJA J) (F : JordanFrame J n)
    {i j : Fin n} (hij : i ≠ j) : frameBlockRaw F i j ≠ ⊥ := by
  sorry

/-- **Residue 1 + the assembly.**  Jacobson coordinatization: a Euclidean Jordan algebra with a
connected Jordan frame of cardinality `n ≥ 3` is, as a Jordan algebra, the hermitian `n × n`
matrices over its coordinate algebra.

The hermitian condition is written entrywise through `CompositionAlgebra.cstar` because
`CompositionAlgebra` carries no `Star` instance; the Jordan product goes to the symmetrised
matrix product `½(AB + BA)`, which is well defined on `Matrix (Fin n) (Fin n) (CoordAlg D)`
because Mathlib's matrix multiplication needs only `Mul` and `AddCommMonoid` on the
coefficients. -/
theorem jacobson_coordinatization (D : CoordData J n) (h3 : 3 ≤ n)
    (hconn : ∀ a b : Fin n, a ≠ b → ∃ c : J, IsConnector D.F a b c) :
    ∃ φ : J ≃ₗ[ℝ] Matrix (Fin n) (Fin n) (CoordAlg D),
      (∀ x : J, ∀ a b : Fin n, φ x b a = CompositionAlgebra.cstar (φ x a b)) ∧
      (∀ x y : J, φ (x * y) = (2 : ℝ)⁻¹ • (φ x * φ y + φ y * φ x)) := by
  sorry

/-- **Residue 3.**  At rank `≥ 4` the coordinate algebra is associative, which is what excludes
`H_{n ≥ 4}(𝕆)` from the classification.  The argument needs a fourth index; nothing in
`EJA/Coordinatize.lean` uses more than three. -/
theorem coordAlg_assoc_of_four (D : CoordData J n) (h4 : 4 ≤ n)
    (hconn : ∀ a b : Fin n, a ≠ b → ∃ c : J, IsConnector D.F a b c) :
    ∀ x y z : CoordAlg D, (x * y) * z = x * (y * z) := by
  sorry

end JacobsonWall
