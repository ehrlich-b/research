/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity

set_option linter.style.longLine false

/-!
# WALL CERTIFICATE — the isomorphisms, the one residue of the composition-algebra block

**Written 2026-08-23.**

`RadicalRelativity/Composition/Hurwitz.lean` proves the **dimension** half of Hurwitz's theorem:
`CompositionAlgebra.finrank_eq_one_or_two_or_four_or_eight`, custom axioms exactly `[]`. What it
does not prove is the **classification**: that a Euclidean composition algebra is *isomorphic to*
`ℝ`, `ℂ`, `ℍ` or `𝕆`, and not merely of one of their dimensions. That statement is what
Jacobson coordinatization actually consumes, so the gap is worth stating rather than describing.

```
grep -rn "^import.*WallCertificates" RadicalRelativity/ RadicalRelativity.lean   # expect no hits
cd /Users/ehrlich/repos/research/twist-normal-form-lean
lake env lean WallCertificates/hurwitz-classification.lean 2>&1 | grep -c 'declaration uses'   # expect: 1
```

## What is proved, and what is not

| statement | status |
| --- | --- |
| `CompositionAlgebra` — the class, with the full identity toolkit (`sq_eq`, both adjoints, `cstar_mul`, both alternativity laws) | **proved**, axioms `[]` |
| `Real/Complex/Quaternion/Octonion.instCompositionAlgebra` — the four witnesses, at dimensions 1, 2, 4, 8 | **proved**, axioms `[]` |
| the three Cayley–Dickson rules `mul_mul_unit`, `unit_mul_mul`, `unit_mul_unit` | **proved**, axioms `[]` |
| `IsCompSubalgebra.forced_assoc` — a subalgebra with a unit normal is associative | **proved**, axioms `[]` |
| `finrank_eq_one_or_two_or_four_or_eight` — dimension is 1, 2, 4 or 8 | **proved**, axioms `[]` |
| `hurwitz_classification` below — `C` is isomorphic to one of the four | **`sorry` — this certificate** |

## What the missing step needs

The `Hurwitz.lean` proof builds a chain of composition subalgebras
`A₀ = ℝ ∙ 1 ⊆ A₁ ⊆ A₂ ⊆ A₃`, each `Aₖ₊₁ = double Aₖ uₖ₊₁` and each of dimension `2ᵏ`, and shows
the chain terminates at or before `A₃`. Every object in the chain is a `Submodule ℝ C` — the
proof never leaves `C`, which is exactly what made the three doubling rules cheap. To close the
classification, that chain has to be *identified* with the concrete carriers, and the identifying
data does not exist in the tree:

1. **An external Cayley–Dickson functor.** `CD D := D × D` with
   `(a,b)(c,d) = (ac - d* b, da + b c*)`, `star (a,b) = (star a, -b)`, `N (a,b) = N a + N b`,
   carrying a `NonAssocRing` instance and a `CompositionAlgebra` instance when `D` is
   associative. The build plan's M8 asked for this; `Composition/Doubling.lean` deliberately
   does **not** build it, because the internal rules are what the dimension bound needs and the
   type former is the expensive half. It becomes necessary again exactly here.
2. **The transport lemma.** If `f : D ≃ D'` is a composition-algebra isomorphism onto a
   composition subalgebra `A ≤ C`, and `u ⊥ A` is a unit vector, then
   `(a, b) ↦ f a + (f b) * u` is a composition-algebra isomorphism `CD D ≃ double A u`. The
   three rules of `Doubling.lean` are precisely its multiplicativity cases, so this step is
   bookkeeping given (1) — but it is bookkeeping over a type that does not exist yet.
3. **The three base identifications** `CD ℝ ≃ ℂ`, `CD (CD ℝ) ≃ ℍ[ℝ]`,
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

★ **These three costs are a design estimate, not a measurement.** No part of (1), (2) or (3) was
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
* **The tree has no `CD` type former and no composition-algebra isomorphism type.**
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

★ **That is deliberately the weaker of the two available notions, and the certificate does not
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
  sorry

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
former produces one map. -/

end HurwitzWall
