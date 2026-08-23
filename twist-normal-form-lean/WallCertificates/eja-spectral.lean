/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity

/-!
# WALL CERTIFICATE — (E1), the Jordan spectral theorem — ★★★ **THE WALL FELL, 2026-08-22**

**Written 2026-08-12, ARC-9 block 9.12. DISCHARGED 2026-08-22.**
`RadicalRelativity/EJA/Spectral.lean` proves the statement below outright
(`RadicalRelativity.EJA.spectral_resolution`), so this certificate's `sorry` is gone, and its
central claim — that step 4 forces a design decision about a unit — was false.

**The file is kept, with zero gaps, because the mispricing is the record.** The `sorry` is
replaced by the real proof so this compiles clean; the original text is left below, unaltered,
so the wrong reading can be read against the right one.

```
grep -rn "^import.*WallCertificates" RadicalRelativity/ RadicalRelativity.lean   # expect no hits
cd /Users/ehrlich/repos/research/twist-normal-form-lean
lake env lean WallCertificates/eja-spectral.lean     # expect: NO warnings, NO `sorry`
```

## What was proved, and where

| statement | declaration | file |
| --- | --- | --- |
| unit-free resolution, idempotents in `jspan x` | `RadicalRelativity.EJA.spectral_resolution` | `EJA/Spectral.lean` |
| the same with `∑ cᵢ = e`, unit as an ordinary hypothesis | `RadicalRelativity.EJA.spectral_resolution_complete` | `EJA/Spectral.lean` |
| both, live on `HermitianMat d 𝕜` | `RadicalRelativity.EJA.hermitian_spectral_resolution{,_complete}` | `EJA/Spectral.lean` |
| the same in `ComparisonSetup`'s bilinear-map vocabulary | `RadicalRelativity.EJA.spectral_resolution_bilinear` | `EJA/Spectral.lean` |
| **`gate_E1_spectral` itself** | `WallCertificate.gate_E1_spectral` | `WallCertificates/eja-gated.lean` |

`AxiomAudit.lean` census PASS at 167 modules, custom axioms exactly `[]`; every declaration
above prints `[propext, Classical.choice, Quot.sound]`.

## The route that worked, against the route this file predicted

The certificate's four-step table is the textbook's: make `ℝ[x]` a ring, show it is reduced,
apply the structure theory of finite-dimensional reduced commutative `ℝ`-algebras. Every step
of that table wants a ring structure on `jspan x`, which is where the unit question came from.

**No ring structure on `jspan x` appears in the proof.** The polynomial bookkeeping is carried
by a linear map into the *ambient* algebra,

  `jeval x : ℝ[X] →ₗ[ℝ] J`,  `jeval x p = ∑ₙ p.coeff n • x^{n+1}`,

which is "`x·p(x)`" — the only shape available with no unit, since every monomial carries at
least one factor of `x`. Its whole content is one identity,
`jeval x p * jeval x q = jeval x (X * p * q)`, which is `jpow_mul_jpow` transported along
bilinearity. Then the annihilator `{p | jeval x p = 0}` is an ideal of `ℝ[X]`, its generator is
radical because a Jordan power of a value of `jeval` is again a value of `jeval`, and formal
reality applies to those values *in `J`*, where `EJA/FormallyReal.lean` already lives.

★ Consequence for the price: no `Unitization`, no `NonUnitalCommRing ↥(jspan x)` instance, no
`IsReduced`, no `IsArtinianRing`, no Mathlib `radical` API. The whole file is 528 lines of Lean in
24 declarations (599 with its module docstring), and its largest component is Lagrange-interpolation
bookkeeping.

★★ **The step that was flagged in advance as the likeliest to contain an error — a
multiplicity-`a` Bézout argument producing an idempotent `e ≡ e² (mod m)` — is not in the proof
at all.** It was designed to avoid needing squarefreeness. Squarefreeness turns out to be **one
line** from radicality — Mathlib's `IsRadical.squarefree` — and radicality is 11 lines
(`isRadical_of_annihilator`) on an 8-line helper (`jpow_jeval`). Once you have it the kill needs
**no idempotent**: with `q ∣ m` the real quadratic through a non-real root, `e := βu` from
`αq + βu = 1`, and `ẽ` its zero-constant-term correction, the only facts used are
`q·ẽ ≡ 0 (mod m)` and `ẽ ≢ 0 (mod m)`. Formal reality kills the *value* `jeval x g` directly,
where `X * g = ẽ`. Multiplicities never enter.
★ The general lesson is the one already on the record from `eja-power-assoc.lean`, now in a
third form: **the step you brace for is not the step that costs.** Here the braced step was
deleted rather than paid, and the two genuinely fiddly parts were the ones nobody flagged —
Lagrange reindexing and `Fin.snoc` casework.

## FIVE CORRECTIONS TO THE TEXT BELOW (2026-08-22)

Each was raised in a read-only recon of this file and then checked against the compiler or the
source. Two of the recon's own sub-claims did not survive that check and are marked.

**F1 (the central claim, FALSE) — the "structural, not effort" obstruction.** The text says a
unital `ℝ[x]` "is available only after adding `[One J]` and the unit axiom to the setting — a
design change to every file from `EJA/Peirce.lean` onward". Three ways this is wrong. (i) The
proof needs no unit at all, so the dilemma has no first horn. (ii) Where a unit IS wanted — the
completeness clause — it enters as an ordinary hypothesis `(e : J) (he : ∀ y, e * y = y)` on one
declaration; `spectral_resolution_complete` does exactly that and **no existing file was
edited**. (iii) `grep -rn "\[One \|MulOneClass\|instOne" RadicalRelativity/EJA/*.lean` → 0 hits
(run 2026-08-22): there was never a `One` instance to conflict with.

**F2 (materially misleading, and the recon overcorrected) — the completeness note.** The text's
"would require `[One J]` and `x` invertible" is wrong about invertibility: appending `e − s`
needs no invertibility, and `spectral_resolution_complete` assumes none. The recon then claimed
the gap is "~15 lines" using three lemmas already in the tree — `IsOrthIdemFamily.sum_idem`,
`IsOrthIdemFamily.sum_mul_of_notMem` and `add_idem_of_orthogonal` — and that they "are exactly
these three steps". **Checked against the written proof, one of the three holds, one needs an
extra step, and one does not apply.** `sum_idem` is used verbatim. `sum_mul_of_notMem` concludes
`(∑_{i∈s} pᵢ) * p_k = 0` for `k ∉ s`, whereas the step needed is `(∑_i cᵢ) * c_k = c_k` for
`k ∈ univ` — reachable from it only after a `Finset.add_sum_erase` split, so `Finset.sum_mul`
plus `Finset.sum_eq_single` was used instead. `add_idem_of_orthogonal` concludes that the SUM of
two orthogonal idempotents is idempotent; the step needed is that `e − s` is, which is the
opposite direction. The corollary is ~35 lines, not 15, and the excess is `Fin.snoc` casework.

**F3 (route claim, FALSE) — step 3's `IsReduced`.** "Repackaging `eq_zero_of_jpow_eq_zero` as
`IsReduced` for a ring structure on `jspan x` is not built" — correct as a statement about the
tree, irrelevant as a claim about the route. `eq_zero_of_jpow_eq_zero` is stated for an
*ambient* element of `J`, and every nilpotent the proof produces is an ambient element. No
`IsReduced` instance exists in the tree today and none was needed.

**F4 (scope defect in absence claim 1).** The grep supporting "no *declaration* mentions the
spectral theorem" was scoped to `RadicalRelativity/EJA/*.lean`.
`RadicalRelativity/Hermitian/Resolution.lean` is titled "Spectral resolutions and the functional
calculus" and declares `specProj`, `eigFinset`, `specProj_mul_self`, `specProj_mul_orth`,
`sum_specProj_mat`, `sum_smul_specProj_mat` (re-verified at source 2026-08-22). The absence
claim is false outside `EJA/`.
★ **But the action the recon drew from it was also wrong**, and in the more expensive direction:
it recommended instantiating on the concrete carrier "in parallel or first", priced at ~1 day,
by reindexing `eigFinset` and proving `specProj a μ ∈ jspan a`. **None of that was needed.**
`HermitianMat d 𝕜` satisfies the abstract theorem's hypotheses already, so the concrete
instantiation is `spectral_resolution A` — one line — and `Resolution.lean` is not used by it.
An absence claim can be false and the plan built on refuting it still worse than the plan it
replaced.

**F5 (sourcing, in absence claim 2).** `Mathlib/RingTheory/Artinian/Ring.lean` does not carry
the structure theory for commutative Artinian rings; it is 102 lines with seven declarations
(`isNilpotent_jacobson_bot`, `jacobson_eq_radical`, `isNilpotent_nilradical`,
`isField_of_isReduced_of_isLocalRing`, `localization_surjective`, `localization_artinian`, one
instance). `IsArtinianRing.equivPi` is at `Mathlib/RingTheory/Artinian/Module.lean:633`. Both
re-verified at source 2026-08-22 at Mathlib `v4.33.0`. The certificate's own flag — "the file
was *listed*, not read" — was the right flag on the wrong file, and the conclusion it protected
("not obviously applicable") stands: that route was not taken.

## What is still absent, with grep scope (2026-08-22)

The target of this certificate is closed. `EJA-DIVIDEND.md` scopes **(E1)** more widely than
this certificate's statement, and two parts of that wider scope are not built:

1. **No functional calculus.** `grep -rn "^def \|^theorem \|^noncomputable def " RadicalRelativity/EJA/*.lean | grep -i "calculus\|cfc\|sqrt\|inverse"`
   → **0 hits** (run 2026-08-22). Nothing maps `f : ℝ → ℝ` to `∑ f(λᵢ) qᵢ` at EJA generality,
   and nothing proves such a map well defined. This is what manifest **row 13**'s residue — the
   spectral inverse — actually needs, so **row 13 does not move**, and neither do rows 16/17.
   ★ The `cfc` on `HermitianMat` (`Hermitian/Resolution.lean`, `Hermitian/CfcPoly.lean`) is the
   concrete-carrier version and is Mathlib's, not an EJA-generality one.
   ★★★ **THE HEADLINE OF THIS ITEM IS FALSE AND ITS CONCLUSION SURVIVES — CORRECTED 2026-08-22,
   HOURS AFTER IT WAS WRITTEN, BY THE PASS THAT READ IT.** A **polynomial** functional calculus at
   EJA generality is built, in this very file's target: `RadicalRelativity.EJA.jeval`
   (`EJA/Spectral.lean:98`), `jeval x : ℝ[X] →ₗ[ℝ] J`, `jeval x p = ∑ₙ p.coeff n • jpow x n`, with
   multiplicativity as `jeval_mul` (`:128`). It is the file's central object — every step of the
   route table above is stated in terms of it — and **its name contains none of the four search
   strings**. The `f : ℝ → ℝ` sentence is literally true and the "No functional calculus" heading
   over it is not.
   ★★ **And the inference to row 13 was wrong, not just the heading.** A spectral inverse over a
   *finite* spectrum is a polynomial value: interpolate `λ ↦ λ⁻²` at the eigenvalues and
   `jeval x p = ∑ᵢ λᵢ p(λᵢ) qᵢ` is `∑ᵢ λᵢ⁻¹ qᵢ`. So row 13 never needed a general calculus. What
   it does need, and what is genuinely absent, is narrower and should be priced as such: **the
   evaluation identity `jeval x p = ∑ᵢ λᵢ p(λᵢ) qᵢ` on a resolution is not in the tree** (no
   `jpow`-of-a-diagonal-family lemma exists — `EJA/Frame.lean` and `EJA/Orthogonal.lean` declaration
   lists checked 2026-08-22), **and no declaration produces an inverse.** Row 13 does not move and
   its residue does not shrink; only the stated reason changes.
   ★★★ **This is the standing rule a further time, and the third time in this file: an accurate grep
   is evidence about a string, not evidence of absence.** The grep above is correct — re-run it and
   it still returns 0. Two items further down, the same file records itself asserting a `primitive`
   count it had not run, and corrects it with "grep the declaration list, not the file text". This
   item *did* grep the declaration list. **The declaration list was the right instrument and the
   search terms were still a guess about vocabulary**, which is the failure one level up: the first
   move is to READ the declaration list of the file in question, not to filter it by what you expect
   the names to be.
2. **No primitivity.**
   `grep -rn "^def \|^theorem \|^lemma \|^structure \|^abbrev \|^noncomputable def " RadicalRelativity/ --include="*.lean" | grep -i primitive`
   → **0 hits** (run 2026-08-22): no declaration defines or asserts primitivity. A Jordan
   *frame* is a complete orthogonal family of primitive idempotents; the families produced here
   are complete and orthogonal but are not shown primitive, and at a repeated eigenvalue they
   are not. Any sentence of the form "resolution into a Jordan frame" therefore overstates what
   is proved.
   ★★★ **THE FIRST DRAFT OF THIS ITEM CLAIMED `grep -rn "[Pp]rimitive" RadicalRelativity/
   --include="*.lean"` → 0 hits, AND THAT WAS FALSE: it returns 6.** All six are prose —
   `Interface.lean:247`, `Coalescence.lean:63`, `Branches/Albert.lean:83` and three unrelated
   uses of "primitive" in the calculus sense (`Necessity/OneParameter.lean`,
   `Necessity/RealRayMap.lean`). The number was written without being run. **This is the same
   defect, in the same file, that the 2026-08-12 text below records itself committing on the
   word "spectral", together with the same correction it wrote down at the time: grep the
   declaration list, not the file text.** Recording a rule in a file does not stop the next
   author of that file from breaking it; running the command does.

★ **`AxiomAudit.lean` cannot see this file** — `WallCertificates/` is not imported from
`RadicalRelativity/` and is not a `lean_lib`. That was the reason the `sorry` here was safe; it
is also the reason the *proof* here is not census-evidence. The census evidence is
`EJA/Spectral.lean`, which is imported and audited.

---

**Original certificate text follows, unaltered except for the discharged step.**

## The target

Every element of a finite-dimensional formally real Jordan algebra is a real combination of
pairwise-orthogonal idempotents. `spectral_resolution` below states it in this development's
own vocabulary — `IsOrthIdemFamily` from `EJA/Frame.lean` — with one `sorry`.

★ **Completeness (`∑ cᵢ = e`) is deliberately NOT part of the statement.** This development is
unit-free by construction (`EJA/Peirce.lean` onwards), and the idempotents in the spectral
resolution of `x` sum to the *support* of `x`, not to an algebra unit. Adding `∑ cᵢ = 1` would
require `[One J]` and `x` invertible, and would state a different theorem. The ARC-9 orders'
terminal condition says "summing to the unit"; **this certificate does not meet that wording
and does not claim to** — see the note at the end.

## What is built, and what the four steps are

| step | statement | status |
| --- | --- | --- |
| 1 | `ℝ[x]` is finite-dimensional; the powers satisfy a nontrivial relation | **DONE** — `jspan_finite`, `exists_jpow_relation` (`EJA/Subalgebra.lean`). ★ Neither uses the Jordan identity; step 1 is free |
| 2 | `ℝ[x]` is an associative commutative algebra | **DONE** — `mul_mem_jspan`, `jspan_assoc` (`EJA/Subalgebra.lean`), from Albert's theorem |
| 3 | `ℝ[x]` is *reduced* | **PARTIAL** — `eq_zero_of_jpow_eq_zero` (`EJA/FormallyReal.lean`) gives no-nilpotents for elements of the *ambient* algebra. Repackaging that as `IsReduced` for a ring structure on `jspan x` is not built |
| 4 | a finite-dimensional reduced commutative `ℝ`-algebra is `ℝ^k`, and the idempotents are its coordinate projections | **ABSENT** |

## The obstruction that is worth recording, because it is structural and not effort

Step 4 wants ring theory, and ring theory wants a **unital ring**. `jspan x` is a
`Submodule ℝ J`, and it carries no unit: it is spanned by `x, x², x³, …` with no constant
term, and this development assumes no `1` in `J` at all.

The classical treatment sidesteps this by working in the *unital* `ℝ[x] = span{1, x, x², …}`.
That is available only after adding `[One J]` and the unit axiom to the setting — a design
change to every file from `EJA/Peirce.lean` onward, all of which are currently unit-free and
gain generality from being so.

★ **It is not obvious that the unit is actually needed**, and this is the honest open question
rather than a task: `jspan x` *is* unital as a ring in its own right, its unit being the
support idempotent of `x` — but that fact is a consequence of the spectral theorem, not an
input to it, so using it here would be circular. Either (a) find a route to step 4 that does
not need a unit, or (b) add `[One J]` and pay the generality. **Not decided.** Deciding it is
the first action on (E1), and it is a design question, not a proof.

## Absence claims, with grep scope (2026-08-12)

1. **Nothing in this tree does step 3 or 4.**
   `grep -rn "IsReduced\|isReduced" RadicalRelativity --include="*.lean"` → **0 hits** (run).
   `grep -n "^def \|^theorem \|^instance \|^abbrev \|^structure \|^noncomputable def " RadicalRelativity/EJA/*.lean | grep -i spectral`
   → **0 hits** (run) — no *declaration* mentions the spectral theorem.
   ★★ **The first draft of this line claimed `grep -rn "spectral" RadicalRelativity/EJA` → 0 hits,
   and that was FALSE: it returns 14.** All fourteen are prose in the EJA layer's own docstrings
   — this arc wrote every one of them, hours earlier — but the number was asserted without being
   run. That is the "verify the verifier saw data" rule broken inside a certificate whose entire
   purpose is to make absence claims falsifiable, and it is the second self-inflicted defect of
   this kind tonight (after the vacuous theorem in `EJA/Witness.lean`). The correction is also the
   arc's standing first move: **grep the declaration list, not the file text** — a topic word
   appears in prose, a declaration does not.
   ★★★ **SEE F4 ABOVE: the scope of the second grep is itself the defect.** It never reached
   `RadicalRelativity/Hermitian/Resolution.lean`.
2. **Mathlib's Artinian/reduced machinery exists but is not obviously applicable.**
   `Mathlib/RingTheory/Artinian/Ring.lean` carries the structure theory for commutative
   Artinian rings. ★ Scope: the file was *listed*, not read. Whether it gives
   "finite-dimensional reduced commutative `ℝ`-algebra ⟹ `ℝ^k`" in a usable form, and at what
   unitality cost, is **unassessed** — that assessment is itself part of the first action
   above, and pricing step 4 before doing it would be exactly the mistake
   `eja-power-assoc.lean` made three hours earlier in this arc.
   ★★★ **SEE F5 ABOVE: the file named does not carry that structure theory.**

## Scope of the whole certificate

This prices (E1) at "two of four steps done, one structural decision open, step 4 unassessed".
It does **not** price it in hours. ★ That is deliberate: this arc has already produced one
route-price that was wrong by an order of magnitude, in this directory, today. The rule earned
there — *prices about route fail, prices about vocabulary hold* — says to record what is
missing and what is built, and to stop.
★★★ **The rule held again and the caution did not save the file.** No hour price was given, so
none was wrong. What was wrong was the *shape* of the remainder: four steps, of which two were
declared done and two open. The proof has none of those four steps in it.
-/

namespace WallCertificate.EJASpectral

open RadicalRelativity.EJA

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J] [Module.Finite ℝ J] [IsFormallyReal J]

/-- **FORMERLY THE GAP: (E1), the single-element spectral theorem; now discharged.**

Every element of a finite-dimensional formally real Jordan algebra is a real combination of
pairwise-orthogonal idempotents drawn from the subalgebra it generates.

The `IsOrthIdemFamily` and `jspan` vocabulary is this development's own, so the statement is
written at the generality the rest of the EJA layer runs at rather than at a located one.

★ The statement is verbatim as written on 2026-08-12; only the proof changed. -/
theorem spectral_resolution (x : J) :
    ∃ (n : ℕ) (c : Fin n → J) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∀ i, c i ∈ jspan x) ∧ x = ∑ i, lam i • c i :=
  RadicalRelativity.EJA.spectral_resolution x

/-- The completeness clause the certificate called "a different theorem". It is a corollary,
and it needs no invertibility. -/
example (e : J) (he : ∀ y : J, e * y = y) (x : J) :
    ∃ (n : ℕ) (c : Fin n → J) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∑ i, c i) = e ∧ x = ∑ i, lam i • c i :=
  RadicalRelativity.EJA.spectral_resolution_complete e he x

/-- The steps that are **not** gaps, restated so the certificate is honest about how much of
the route is already in the tree. These use no `sorry`.

★ 2026-08-22: they are still true and still in the tree; what they are not is the route. Only
the first and the last are used by the proof — `exists_jpow_relation` supplies the nonzero
annihilator, `eq_zero_of_jpow_eq_zero` supplies radicality. `mul_mem_jspan` and `jspan_assoc`
are used only to place the idempotents in `jspan x`, not to build any algebra structure. -/
example (x : J) : Module.Finite ℝ (jspan x) := jspan_finite x

example (x : J) : ∃ (n : ℕ) (c : Fin n → ℝ), (∃ i, c i ≠ 0) ∧ ∑ i, c i • jpow x i = 0 :=
  exists_jpow_relation x

example {x a b : J} (ha : a ∈ jspan x) (hb : b ∈ jspan x) : a * b ∈ jspan x :=
  mul_mem_jspan ha hb

example {x a b c : J} (ha : a ∈ jspan x) (hb : b ∈ jspan x) (hc : c ∈ jspan x) :
    (a * b) * c = a * (b * c) :=
  jspan_assoc ha hb hc

example {x : J} {n : ℕ} (h : jpow x n = 0) : x = 0 := eq_zero_of_jpow_eq_zero n h

end WallCertificate.EJASpectral
