/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity

set_option linter.style.longLine false

/-!
# WALL CERTIFICATE — the isomorphisms, the one residue of the composition-algebra block — ★★★ **THE WALL FELL, 2026-08-23**

**Written 2026-08-23. DISCHARGED 2026-08-23, the same day.**
`RadicalRelativity/Composition/Classification.lean` proves the statement below outright
(`CompositionAlgebra.hurwitz_classification`), in a **strictly stronger** form: its isomorphism
carries the norm clause this certificate said it was missing. The `sorry` is replaced by the
derivation of this file's weaker statement from that one.

**The file is kept, with zero gaps, because the pricing is the record.** The original text is
left below with its wrong claims in place, each tagged `[D1]`…`[D6]` and answered here.

## What the discharge corrected

* **[D1] "The tree has no `CD` type former and no composition-algebra isomorphism type" — FALSE
  at the discharge.** The same grep the absence claim quotes,
  `grep -rn "CayleyDickson\|CompIso\|CompHom" RadicalRelativity/ RadicalRelativity.lean`,
  returned **1** hit when written and returns **26** now: `CD` in
  `Composition/CayleyDickson.lean` and `CompositionAlgebra.IsCompIso` in
  `Composition/Isomorphisms.lean`. ★ The claim was true when written and stale within the day —
  which is the standing point of this directory, arriving faster than usual.
* **[D2] "64 basis-pair equations, each plausibly `rfl`-or-`decide`" — wrong on both the count
  and the tactic, and wrong in the safe direction.** `decide` cannot apply at all: the
  coefficients are elements of `ℝ`, which has no decidable equality to compute with. `rfl`
  cannot either: the 64 statements are polynomial identities in 16 real variables, not
  definitional ones. And 64 is the wrong unit — the Lean proof is `ext i; fin_cases i`, giving
  **8** goals, one per output coordinate, each closed by `simp` then `ring`. The basis-pair
  framing is how the *search* was organised, not how the proof runs.
* **[D3] "Two things NOT claimed here: that the doubling order produces a *different* labelling
  — I did not compute either labelling." Now computed, and it does — necessarily.** Of the
  `14³ = 2744` signed correspondences determined by the images of `i`, `j` and `ℓ`, exactly
  **1344** are isomorphisms, and the minimum number of negated basis images over those 1344 is
  **1** (attained by 147 of them), so **no sign-free correspondence exists** — the doubling
  order does produce a different labelling, and necessarily so. ★ **Scope, exactly**: the
  enumeration ranges over the *monomial* correspondences, those sending each doubled basis
  element to a signed basis vector, and is complete for those. It says nothing about
  isomorphisms `CD ℍ[ℝ] ≃ 𝕆` in general — `Aut(𝕆) = G₂` is 14-dimensional, so almost none of
  them are monomial. ★ `1344 = 8 × 168`; `168` is the order of the Fano plane's collineation
  group `PSL(3,2)`. That factorisation is arithmetic and is recorded as an observation, not as
  a group-theoretic identification of the 1344 — none was checked against a source.
* **[D4] "These three costs are a design estimate, not a measurement" — measured.** (1) the `CD`
  functor, `Composition/CayleyDickson.lean`, 221 lines; (3) the three base identifications,
  `Composition/Isomorphisms.lean`, 232 lines; (2) the transport lemma and the chain,
  `Composition/Classification.lean`, 367 lines. ★ **The certificate's one correct prediction is
  its most useful line**: it named (3) as "the one to worry about", and (3) is the only step that
  needed a search outside Lean. The search was run in Python against the table transcribed from
  `Octonions.lean`, and the correspondence was verified there before a line of Lean was written.
* **[D5] "Anyone who closes it should also add the norm clause" — done, and the certificate was
  right that it mattered.** `CompositionAlgebra.IsCompIso` is a structure with `map_one`,
  `map_mul` **and `map_nf`**, and every result in the block carries all three. ★ What is *still*
  not formalized is the certificate's own reason for thinking the clause redundant — the `sq_eq`
  argument that the product determines `N`. It was not needed and was not written, so **the two
  notions are still not proved to coincide in this tree.** The strong statement was proved
  directly instead.
* **[D6] One obstacle the certificate did not predict, and it is the one that actually cost
  time.** Mathlib's `Quaternion.re_mul` and its three companions are `simp` lemmas keyed on
  `(a * b).re`, and they **do not fire when the first argument is a structure literal**. Since
  the natural statement of the quaternionic conjugation is `cstar q = ⟨q.re, -q.imI, …⟩`, making
  it `simp` left the octonion `map_mul` with eight unreduced goals. The repair is to give the
  conjugation four *componentwise* `simp` lemmas instead, keeping the product's arguments atomic
  (`Composition/Isomorphisms.lean`, `Quaternion.cstar_re` and companions). Nothing about the
  mathematics; the whole of the residual difficulty was a `simp` normal form.

★ **What did NOT change: no manifest row moves.** This certificate never carried one. The
composition-algebra block is substrate for Jacobson coordinatization, and Hurwitz in
classification form is an *input* to that, not a row of the paper.

`RadicalRelativity/Composition/Hurwitz.lean` proves the **dimension** half of Hurwitz's theorem:
`CompositionAlgebra.finrank_eq_one_or_two_or_four_or_eight`, custom axioms exactly `[]`. What it
does not prove is the **classification**: that a Euclidean composition algebra is *isomorphic to*
`ℝ`, `ℂ`, `ℍ` or `𝕆`, and not merely of one of their dimensions. That statement is what
Jacobson coordinatization actually consumes, so the gap is worth stating rather than describing.

```
grep -rn "^import.*WallCertificates" RadicalRelativity/ RadicalRelativity.lean   # expect no hits
cd /Users/ehrlich/repos/research/twist-normal-form-lean
lake env lean WallCertificates/hurwitz-classification.lean   # expect: NO warnings, NO `sorry`
```

## What is proved, and what is not

| statement | status |
| --- | --- |
| `CompositionAlgebra` — the class, with the full identity toolkit (`sq_eq`, both adjoints, `cstar_mul`, both alternativity laws) | **proved**, axioms `[]` |
| `Real/Complex/Quaternion/Octonion.instCompositionAlgebra` — the four witnesses, at dimensions 1, 2, 4, 8 | **proved**, axioms `[]` |
| the three Cayley–Dickson rules `mul_mul_unit`, `unit_mul_mul`, `unit_mul_unit` | **proved**, axioms `[]` |
| `IsCompSubalgebra.forced_assoc` — a subalgebra with a unit normal is associative | **proved**, axioms `[]` |
| `finrank_eq_one_or_two_or_four_or_eight` — dimension is 1, 2, 4 or 8 | **proved**, axioms `[]` |
| `hurwitz_classification` below — `C` is isomorphic to one of the four | ★★★ **PROVED 2026-08-23**, `CompositionAlgebra.hurwitz_classification`, axioms `[]` |

## What the missing step needs

The `Hurwitz.lean` proof builds a chain of composition subalgebras
`A₀ = ℝ ∙ 1 ⊆ A₁ ⊆ A₂ ⊆ A₃`, each `Aₖ₊₁ = double Aₖ uₖ₊₁` and each of dimension `2ᵏ`, and shows
the chain terminates at or before `A₃`. Every object in the chain is a `Submodule ℝ C` — the
proof never leaves `C`, which is exactly what made the three doubling rules cheap. To close the
classification, that chain has to be *identified* with the concrete carriers, and the identifying
data does not exist in the tree:

1. ★★★ **BUILT** (`Composition/CayleyDickson.lean`). **An external Cayley–Dickson functor.** `CD D := D × D` with
   `(a,b)(c,d) = (ac - d* b, da + b c*)`, `star (a,b) = (star a, -b)`, `N (a,b) = N a + N b`,
   carrying a `NonAssocRing` instance and a `CompositionAlgebra` instance when `D` is
   associative. The build plan's M8 asked for this; `Composition/Doubling.lean` deliberately
   does **not** build it, because the internal rules are what the dimension bound needs and the
   type former is the expensive half. It becomes necessary again exactly here.
2. ★★★ **BUILT** (`Composition/Classification.lean`, `CompEmb.double`). **The transport lemma.** If `f : D ≃ D'` is a composition-algebra isomorphism onto a
   composition subalgebra `A ≤ C`, and `u ⊥ A` is a unit vector, then
   `(a, b) ↦ f a + (f b) * u` is a composition-algebra isomorphism `CD D ≃ double A u`. The
   three rules of `Doubling.lean` are precisely its multiplicativity cases, so this step is
   bookkeeping given (1) — but it is bookkeeping over a type that does not exist yet.
3. ★★★ **BUILT** (`Composition/Isomorphisms.lean`). See `[D2]`, `[D3]`. **The three base identifications** `CD ℝ ≃ ℂ`, `CD (CD ℝ) ≃ ℍ[ℝ]`,
   `CD (CD (CD ℝ)) ≃ Octonion`. The first two are short. **The third is the one to worry
   about**: the tree's `Octonion` is built from a hard-coded `Fin 8` Fano multiplication table
   (`RadicalRelativity/Octonions.lean`, `Octonion.mul`), not from a doubling, so the
   identification means matching a recursive product against a table — 8 × 8 = 64 basis-pair
   equations, each plausibly `rfl`-or-`decide` *after* the right basis correspondence is chosen,
   and choosing it is a sign-convention search rather than a proof. The Fano triples in that
   file are, per its own docstring, the Baez convention
   `(1,2,4), (2,3,5), (3,4,6), (4,5,7), (5,6,1), (6,7,2), (7,1,3)`.
   ★ Two things NOT claimed here: that the doubling order produces a *different* labelling —
   I did not compute either labelling — and that the search is hard. What is established is
   only that no doubling-based octonion exists in the tree to compare against:
   `grep -n "^def \|^theorem \|^instance \|^structure " RadicalRelativity/Octonions.lean`
   shows `Octonion.mul` defined by the eight-way `if` on coordinates and nothing recursive.

★ `[D4]` **These three costs are a design estimate, not a measurement.** No part of (1), (2) or (3) was
attempted. On this project prices decay, so: I did not write a line of the `CD` type former, and
the "64 equations, each `rfl`-or-`decide`" figure in (3) is arithmetic on the basis size, not an
observed compile. Treat every number in this section as unpriced.

## Absence claims, with the scope of the grep that supports each

All run 2026-08-23 against Mathlib at the pinned v4.33.0 checkout
(`.lake/packages/mathlib`, `lake-manifest.json`) and against `RadicalRelativity/`.

* **Mathlib has no composition algebras, no Cayley–Dickson, no octonions, no Hurwitz.**
  `grep -rlniE "composition ?algebra|cayley.?dickson|octonion|hurwitz" Mathlib/` returns **15**
  files: **11** are Hurwitz *zeta functions* under `NumberTheory/`, and the four remaining hits
  are English prose in `Topology/Homotopy/HSpaces.lean`, `Algebra/Ring/Identities.lean`,
  `Algebra/Jordan/Basic.lean` and `Algebra/Polynomial/Smeval.lean`. No declaration.
  ★ The first draft of this line said "16 files, twelve under `NumberTheory/`", from memory of
  the run rather than from the run. Both numbers were wrong; they are now the output of
  `... | wc -l` and `... | grep -c '^Mathlib/NumberTheory/'`.
* **Mathlib has no alternativity class.** `grep -rn "class IsAlternative\|IsAlternative\b"
  Mathlib/` returns nothing.
* **Mathlib does have the raw eight-square identity**: `sum_eight_sq_mul_sum_eight_sq` in
  `Mathlib/Algebra/Ring/Identities.lean`, whose docstring says "This sign choice here
  corresponds to the signs obtained by multiplying two octonions." It is a polynomial identity
  in 16 variables with no algebra attached, so it does not shorten (3) — but it is the closest
  thing Mathlib has, and a future upstreaming should reconcile with it rather than duplicate it.
* `[D1]` ★★★ **FALSE AT THE DISCHARGE, true when written.** **The tree has no `CD` type former and no composition-algebra isomorphism type.**
  `grep -rn "CayleyDickson\|CompIso\|CompHom" RadicalRelativity/ RadicalRelativity.lean`
  returns **exactly one** hit, and it is prose: line 24 of
  `RadicalRelativity/Composition/Doubling.lean`, the header sentence explaining why that file is
  not the plan's `Composition/CayleyDickson.lean`. No declaration.
  ★ The first draft of this line said "returns nothing", written from the intent of the design
  rather than from a run. It was false — by one hit, in a file this same block wrote an hour
  earlier. An accurate grep is evidence about a string, and a grep not re-run is evidence about
  nothing.

## The gap, stated

Below, `IsCompIso f` says the linear equivalence `f` preserves the unit and the product, and
says nothing about the norm form.

`[D5]` ★ **That is deliberately the weaker of the two available notions, and the certificate does not
claim they coincide.** The standard notion also requires `N (f x) = N x`. The two do coincide,
because `sq_eq` shows `x * x = 2⟪x,1⟫ • x - N x • 1`, so for `x` outside `ℝ ∙ 1` the pair
`(2⟪x,1⟫, N x)` is pinned by the product alone and `N` is algebra-determined — but *that
argument is not formalized anywhere in this tree*, so quoting it here would be exactly the kind
of prose price this directory exists to replace. Consequence for reading the gap: the statement
below is **implied by** the standard classification, so discharging it is a lower bound on the
missing work, not an equivalent of it. Anyone who closes it should also add the norm clause.

The `sorry` is on `hurwitz_classification` and nowhere else.
-/

namespace HurwitzWall

open CompositionAlgebra
open scoped Quaternion

universe u v

/-- An isomorphism of composition algebras: a linear equivalence preserving unit and product.
The norm form needs no separate clause — `x * cstar x = N x • 1` determines it from the
product. -/
def IsCompIso {C : Type u} {D : Type v}
    [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C]
    [NonAssocRing D] [Module ℝ D] [IsScalarTower ℝ D D] [SMulCommClass ℝ D D]
    (f : C ≃ₗ[ℝ] D) : Prop :=
  f 1 = 1 ∧ ∀ x y : C, f (x * y) = f x * f y

/-- The notion is satisfiable: the identity is a composition-algebra isomorphism. This is here
so that the `sorry` below is a gap in a *provable-in-principle* statement rather than in a
statement no map could satisfy. -/
theorem isCompIso_refl {C : Type u}
    [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] :
    IsCompIso (LinearEquiv.refl ℝ C) :=
  ⟨rfl, fun _ _ => rfl⟩

/-- **THE GAP.** Hurwitz's theorem in classification form. `Hurwitz.lean` proves the dimension
statement that this refines; what is missing is the identification of the doubling chain with
the four concrete carriers, itemised as (1), (2), (3) in the header.

The hypotheses are exactly those of `finrank_eq_one_or_two_or_four_or_eight`, which is proved,
so this statement is not vacuous: `ℝ`, `ℂ`, `ℍ[ℝ]` and `Octonion` all satisfy them
(`Composition/Instances.lean`), and each satisfies the conclusion via `isCompIso_refl` on its
own branch. -/
theorem hurwitz_classification (C : Type) [NonAssocRing C] [Module ℝ C]
    [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C] [Nontrivial C]
    [FiniteDimensional ℝ C] :
    (∃ f : C ≃ₗ[ℝ] ℝ, IsCompIso f) ∨ (∃ f : C ≃ₗ[ℝ] ℂ, IsCompIso f) ∨
      (∃ f : C ≃ₗ[ℝ] ℍ[ℝ], IsCompIso f) ∨ (∃ f : C ≃ₗ[ℝ] Octonion, IsCompIso f) := by
  -- ★★★ THE DISCHARGE.  The statement above is the weak one: unit and product, no norm clause.
  -- `CompositionAlgebra.hurwitz_classification` proves the strong one, so all this does is
  -- forget `map_nf`.  Keeping the weak statement verbatim is the point -- it is what the
  -- certificate committed to, and it must be readable against what was actually proved.
  rcases CompositionAlgebra.hurwitz_classification (C := C) with
    ⟨f, hf⟩ | ⟨f, hf⟩ | ⟨f, hf⟩ | ⟨f, hf⟩
  · exact Or.inl ⟨f, hf.map_one, hf.map_mul⟩
  · exact Or.inr (Or.inl ⟨f, hf.map_one, hf.map_mul⟩)
  · exact Or.inr (Or.inr (Or.inl ⟨f, hf.map_one, hf.map_mul⟩))
  · exact Or.inr (Or.inr (Or.inr ⟨f, hf.map_one, hf.map_mul⟩))

/-! ## The self-defeat test

The gap statement is checked against the three defect kinds this project has recorded.

* **FALSE?** No. This is Hurwitz's theorem in its standard positive-definite real form
  (Hurwitz 1898); the four algebras listed are the four that occur.
* **VACUOUS?** No, in either direction. The hypothesis class is inhabited — the four instances
  of `Composition/Instances.lean` — and the conclusion is inhabitable, `isCompIso_refl` above.
  A statement quantified over an empty class, or asserting the existence of a map of a kind that
  cannot exist, would fail one of those two.
* **SELF-DEFEATING?** Assume the gap and check it does not contradict what it feeds. What it
  feeds is Jacobson coordinatization at rank `≥ 3`, which takes the coordinate algebra
  `C = V₁₂` and needs `C ∈ {ℝ, ℂ, ℍ, 𝕆}` in order to name `H_n(C)`. Assuming the conclusion
  gives exactly that and nothing more; in particular it does **not** give `n ≥ 4 ⟹ C`
  associative, which is a separate step (the plan's M12) and is not smuggled in here.

★ One thing this certificate deliberately does not claim: that the dimension theorem is "most
of" the classification, or that the remaining step is small. The dimension theorem is a
statement about `finrank`; the classification is a statement about maps, and no amount of the
former produces one map.

★★ **That paragraph survives the discharge intact, and is the one place the certificate should
be read as it stands.** The classification proof does not derive a map from the dimension
theorem; it re-runs the dimension proof's chain with a map carried alongside it, and uses the
dimension theorem only once, at the end, to know that the third double is everything. The
`finrank` statement really did produce no map — a second construction did. -/

end HurwitzWall
