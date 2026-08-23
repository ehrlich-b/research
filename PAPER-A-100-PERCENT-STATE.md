# Paper A → 100% formalized — working state

**Goal (Bryan, 2026-08-23): every one of the 36 manifest rows FORMALIZED. Paper A is NOT
submitted until then.** This is a hard gate, not a preference: the program already had a
load-bearing theorem withdrawn and a flagship desk-rejected, and shipping a paper whose Lean
artifact is a conditional dependency skeleton is how that recurs.

## The metric — machine-derived, never asserted

`STATEMENT-MANIFEST.md` is the SSOT for the 36 statements. Re-run its own census script after
every move (it lives in that file, ~line 78); do not hand-count, and do not write
"fully formalized" as prose.

    python3 - <<'PY'
    import re
    c={}
    for ln in open("STATEMENT-MANIFEST.md",encoding="utf-8"):
        if re.match(r'^\| \d+ \|', ln):
            s=re.split(r'(?<!\\)\|',ln)[1:-1][5].strip()
            m=re.match(r'^\**[\s★]*\**\s*(FORMALIZED|PARTIAL|ABSENT)',s); assert m, ln[:60]
            c[m.group(1)]=c.get(m.group(1),0)+1
    print(c, sum(c.values()))
    PY

**Baseline 2026-08-23 (before today's EJA work is reflected): 16 FORMALIZED / 18 PARTIAL /
2 ABSENT = 36.** 20 rows to move. Only 2 are ABSENT — the rest are PARTIAL, i.e. a clause of
several or a concrete case where the article states it generally. These are moves, not builds
from scratch.

Standing rule of that file: `THEOREM-MAP.md` must be updated in the same commit as a status
move. A debt is already recorded there from 2026-08-22 where that was violated.

## What landed 2026-08-23 and is NOT yet reflected in the manifest

Three commits in `ehrlich-b/research`, all verified (compile clean, full library build,
axiom census exactly `[propext, Classical.choice, Quot.sound]`):

* `dab33fa` — `Composition/HermInner.lean`: entrywise form `hermIp`, `InnerProductSpace ℝ
  (HermMat ι C)` via `ofCore`, and `hermIp_jmul_assoc` (the Euclidean hypothesis
  `⟪A∘B,D⟫ = ⟪B,A∘D⟫`) at arbitrary Euclidean composition algebra — **no associativity needed**,
  because `ip_mul_adj_left/right` (`Composition/Defs.lean:229,238`) are polarisations of the
  composition law, not consequences of associativity.
* `f409d91` — `EJA/HermMatCarrier.lean`: `EuclideanJordanAlgebra (HermMat ι C)` for `[Ring C]`
  (ℝ, ℂ, ℍ). Formal reality falls out via `EJA/Class.lean`'s `instIsFormallyReal`. No additive
  diamond (proved by `rfl`).
* `9c24894` — `EJA/AlbertBridge.lean`: `toHermMat : h3O ≃ₗ[ℝ] HermMat (Fin 3) Octonion`,
  `toHermMat_jordanMul` (products agree), `toHermMat_hermIp` (isometry),
  `finrank_hermMat_octonion = 27`, and **`hermMat3_jmul_jordan` — the Jordan identity on
  `H₃(C)` for EVERY finite-dimensional Euclidean composition algebra**, by case-splitting
  `hurwitz_classification`. Gives `EuclideanJordanAlgebra (HermMat (Fin 3) Octonion)`.

**Consequence to chase first:** several manifest rows carry an `EJA-GATED` terminal state, and
the H₃(𝕆) carrier those gates were waiting on now exists. Re-audit every EJA-GATED row before
building anything new — some may be free promotions. See the terminal-state ledger in
`STATEMENT-MANIFEST.md`.

## The Albert row's real remaining blocker

`IsAlbertModel` (`MasterTheorem/Branches/Albert.lean:81`) has exactly one field:
`block_injective : ∀ i j : Fin 3, i ≠ j → Function.Injective (S.ρ i j)` — Yokota's
Spin(8)-triality faithfulness. Its docstring says why it cannot be internalised: `Stab` carries
no Lie structure in the abstract interface, so simplicity of `𝔰𝔭𝔦𝔫(8)` is unavailable.

Mathlib inventory, **checked not assumed** (2026-08-23): `CliffordAlgebra/SpinGroup.lean`
EXISTS; `Algebra/Lie/{Killing,Semisimple/,Classical,Weights}` EXIST; **triality: zero hits**;
`SO(8)`/`Spin(8)` by name: zero hits. So the gap is triality specifically, not Lie theory
wholesale.

## Non-negotiable operating rules

* **Lean memory.** Always `lake env lean -M 10240 -j 4 FILE`. **One Lean process at a time,
  never concurrent** — two concurrent runs hit 61.8 GB + 46.7 GB on this 24 GB Mac on
  2026-08-23 and killed the machine. NEVER `toString (repr e)` on a proof term (that was the
  actual cause). `lake build` here rejects both `-j` and `--jobs`.
  ★ The background memory watchdog was killed 2026-08-23 at Bryan's instruction, so the `-M`
  cap is now the ONLY protection. Do not relax it.
* **Verify agent claims yourself.** Four sub-agents went idle without their reports landing;
  in every case the filesystem was the truth. Compile + full build + axiom census, always.
* **Prose discipline.** Every Palomar rejection this project has taken was prose overclaiming
  relative to the formal statement, never bad mathematics. Use `★` markers for prose-only
  claims. When a result falsifies an older claim elsewhere in the tree, go NARROW that claim
  in the same commit — do not leave the tree lying.
* **A claimed library obstruction is a claim** — grep Mathlib before writing "Mathlib does not
  have X". Recorded lesson; I violated it once today on Spin(8).

## Open, needing Bryan

1. **3 unpushed commits** in `ehrlich-b/research` (`dab33fa`, `f409d91`, `9c24894`).
2. **The citation is WRONG, not merely stale.** `main.tex` pins `ehrlich-b/research@b7db3e8`,
   which is the 2026-07-19 pre-campaign skeleton — 27 `.lean` files, **no `Necessity/`
   directory**. A referee following it finds none of the flagship work. A drafted fix exists at
   `research/paperA-supplementary-rewrite-draft.md` (eight stale disclosure claims + the
   re-pin). `main.tex`/`supplementary.tex` are Bryan-gated. Bryan said "citation should be
   updated" — needs a pushed commit to pin to.
3. Tree is on Mathlib **v4.33.0**; the paper cites v4.28.0.

## Palomar (separate track, self-draining)

`~/scratch/palomar/tick.sh` on a session-only cron (:09/:29/:49). koecher `000005` and spectral
`000006` registered. traceform/framepeirce withdrawn and folded into the grouped `structure`
entry (6 theorems), which passed mechanical verification but whose **editorial review stalled**:
event log frozen at 18:57:57Z on "The automated review did not complete; it will be tried
again", ~2h with no retry. `classification` (4 theorems) queued behind it. NEVER `/register` —
that is Bryan's decision alone.

## Progress 2026-08-23 (post-compaction session)

Baseline was 16 FORMALIZED / 18 PARTIAL / 2 ABSENT. **Now 18 / 16 / 2.**

**Row 5 `lem:span` CLOSED** (commit `777c122`). Both open clauses:
* Ball clause — added `OrderUnitSpace.ouNorm` (abstract order-unit norm, unbundled `def`),
  `ouBound`/`ouBound_nonempty`/`bddBelow_ouBound`, `sub_le_of_le_add`,
  `le_smul_unit_of_forall_pos`, `ouNorm_mem_ouBound` (the inf is ATTAINED — the single step
  that consumes `IsArchimedean`), `isEffect_half_smul_unit_add`,
  `closedBall_half_subset_isEffect`. All in `RadicalRelativity/OrderUnitSpace.lean`.
* Peirce clause — `peirceOneSubOrderUnitSpace` + `coe_ousUnit_peirceOneSub` +
  `span_isEffect_peirceOneSub_eq_top` in `RadicalRelativity/EJA/PeirceSubalgebra.lean`.
  The row's stated reason ("the tree does not know J₂(q) is an order unit space") had been
  stale since 2026-08-22.

**Row 3 `def:sp` CLOSED** (commit `a20667a`). Its whole residue was "S2, alone … needs an
abstract `ouNorm`, which the tree does not have". Added `OrderUnitSpace.ContinuousOnOu` +
`ContinuousOnOu.congr`, then in `RankTwo/Sufficiency.lean`: `PaperA.SpFirstArgContinuousOu`,
`EffectSequentialProduct.FirstArgContinuousOu`, `restrictSp_firstArgContinuousOu`,
`extendSp_firstArgContinuousOu`, `EffectSequentialProductS2` (all eight clauses in one
object), `restrictSpS2`, `extendSpS2`, `restrictSpS2_extendSpS2`, `restrictSpS2_surjective`.
Collateral: `Necessity/OrderUnitS2.lean:119` needed `HermitianMat.` qualification — the bare
name `ContinuousOnOu` became ambiguous. No statement there changed.

★ **The leverage was real: ONE object (`ouNorm`) closed TWO rows.** Look for that shape again.

All 16 new declarations: `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.
Full `lake build RadicalRelativity` green (3306 jobs) after each.

★ **TRAP HIT TWICE — read this before believing a build.** (a) `lake env lean FILE` compiles
against CACHED oleans, so after editing a dependency you must `lake build <ThatModule>` before
the dependent file's errors mean anything; two "errors" were pure cascade. (b) `lake build ...
| grep -i error` is NOT a success check — the style/doc-string linters emit warnings whose TEXT
contains "error", and a genuine `Some required targets logged failures` line sits at the very
end. Always read the LAST 3 lines.

## Program-level flag raised by the gate audit, needing Bryan

**Rows 2 (`mthm:omnibus`) and 4 (`thm:vdw1`) are PRE-REGISTERED EXTERNAL** — two of the six
(rows 1, 2, 4, 10, 14, 21). `WallCertificates/external-rows.md` calls closing them "out of
scope *by design*"; for row 4 the manifest says the paper "never claims to reprove" van de
Wetering's theorem. Promoting them to FORMALIZED means REVERSING an ARC-5/6 pre-registration,
not finishing an unfinished row. That is a scientific-record decision, not a Lean one.
Bryan has said he wants 36/36 and does not want that re-litigated — this is recorded so the
next session knows the two rows are a different KIND of work, not so it re-opens the question.

## Session 2 (2026-08-23 evening) — where the canonicity work stands

Census went 16/18/2 -> **18/16/2**. Rows 3 and 5 CLOSED. Row 8's entire interior clause closed
(status word deliberately NOT moved — see its cell). Rows 12, 18, 21 repriced against the tree.

### The critical path, correctly identified at last

Rows 13, 16 and 21 all wait on ONE object: an inhabitant of `SequentialProductOnEJA`, i.e.
`a·b = Q_{√a}b`. ★ **The square root is NOT the blocker and never was** — `EJA/Order.lean`'s
`isSoS_iff_exists_sq` has produced one since 2026-08-22, by the same `∑ √(max λ 0) • qᵢ`
construction anyone would write. **CANONICITY is the blocker**: `√a` must be a *function of `a`*,
and `spectral_resolution_complete` hands out an existential resolution.

Progress on canonicity, all in `EJA/Spectral.lean`, all sorry-free:
* `sum_smul_mul_sum_smul_of_orthIdem` — the workhorse; elements over one orthogonal idempotent
  family multiply coefficientwise. Powers/inverses/roots are three-line corollaries of it.
* `jeval_of_resolution` — `jeval x p = ∑ᵢ λᵢ·p(λᵢ) cᵢ`. Row 13 named this as absent.
* `mul_jinvOfResolution` — an inverse. Row 13 named this as absent too.
* `exists_resolution_distinct` — every element has a resolution with **injective** eigenvalues
  (merge the idempotents sharing one).
* `idem_eq_jeval_lagrange` — **the canonicity step**: with eigenvalues distinct, `cₖ = jeval x pₖ`
  for a Lagrange interpolant `pₖ`, so `cₖ` IS a function of `x`. Needs `λₖ ≠ 0` (jeval is `x·p(x)`,
  so the zero-eigenvalue idempotent is unreachable this way — it is still determined, as
  `e − ∑_{i≠k} cᵢ`, just not by this route).

**NEXT, and it is the honest remaining gap:** full uniqueness needs (a) that two resolutions of the
same `x` have the same eigenvalue SET, and (b) that the Lagrange bases over two index types with
equal value sets are equal. (a) should come from `jann`/`exists_annihilator_generator`; (b) is a
reindexing argument on `Lagrange.basis = ∏_{j≠i} basisDivisor (v i) (v j)`. Then `√` becomes a
function, then `Q_{√a}`, then S1–S7.

### Two duplications, both caught, both recorded — read before building anything

1. `jsqrtOfResolution` duplicates `isSoS_iff_exists_sq`. Docstrings now point at it.
2. `isSharpOrderUnit_of_idem` nearly duplicated `EJA/OrderAuto.lean`'s `isSharp_of_idem` — which
   proves BOTH directions, but against its own `EJA.IsSharp` (sums-of-squares spelling) that the
   file itself says nothing relates to `OrderUnitSpace.IsSharp`. `isSharpOrderUnit_of_sosSharp`
   is now that bridge. **Applying it at `mulLₗ` does not elaborate** — `Module ℝ J` comes from the
   ring side there and from `InnerProductSpace` here; measured, recorded in the docstring, not
   claimed cosmetic.

★ **STANDING LESSON: grep for the residue item's STATEMENT SHAPE, not its name.** Both collisions
were under names no one would guess.

### Palomar — do not resubmit `structure`

Editorial review failed TWICE with an identical 21-second signature (18:57:36->57, 21:22:22->43),
same commit. Deterministic, not a stall. Mechanical verification PASSES both times. The only
structural difference from koecher/spectral (both registered fine): those carry ONE theorem;
`structure` carries SIX across TWO namespaces. `classification` (4 theorems, 4 namespaces) would
likely hit the same wall. Full note in `~/scratch/palomar/queue.txt`. Bryan's call.

## Canonicity chain — COMPLETE, nothing carried (all in `EJA/Spectral.lean`, all sorry-free)

```
coeff_eq_zero_of_sum_smul_eq_zero      coefficients pinned by their idempotents
jeval_eq_zero_iff_of_resolution        annihilator readable from a resolution
exists_idem_iff_forall_jann_eval       nonzero spectrum = common roots of jann  => function of x
nonzero_spectrum_eq_of_resolutions     two resolutions share the NONZERO spectrum  (see caveat)
exists_resolution_distinct             distinct-eigenvalue resolutions exist
idem_eq_jeval_lagrange                 idempotents are Lagrange polynomials in x
lagrange_basis_congr                   interpolants agree across indexings
idem_unique_of_resolutions             idempotents are unique
sqrt_sum_eq_jeval                      sqrt x = jeval x of ONE polynomial
quadJ / quadJ_unit                     the Jordan quadratic representation Q_a = 2 L_a^2 - L_{a^2}
```

**So `sqrt` is a function of `x`, not a choice.** That is what `SequentialProductOnEJA` needs and
what `isSoS_iff_exists_sq` never gave (it only *exhibits* a root). Remaining for the inhabitant:
define `a . b := quadJ (sqrt a) b` and verify S1-S7. Ordinary assembly, not a missing idea.

★ The zero eigenvalue needs no special handling for the square root — `sqrt 0 = 0` deletes its
term. Same structural fact forces the `lam k != 0` side condition on `idem_eq_jeval_lagrange` and
the `t != 0` on `exists_idem_iff_forall_jann_eval`: `jeval` is `x.p(x)`, so the zero eigenvalue is
invisible to it. One phenomenon, three appearances — not three limitations.

## THREE near-duplications in one session. Read this before writing any lemma.

1. `jsqrtOfResolution` duplicated `EJA/Order.lean`'s `isSoS_iff_exists_sq`.
2. `isSharpOrderUnit_of_idem` collided with `EJA/OrderAuto.lean`'s `isSharp_of_idem` — a DIFFERENT
   `IsSharp` (sums-of-squares spelling) that the file says nothing relates to the order-theoretic
   one. `isSharpOrderUnit_of_sosSharp` is now that bridge.
3. `quadJ` was nearly a duplicate of `Necessity.quadRep` — caught by grepping first. It is NOT:
   `quadRep` is matrix conjugation through the vendored CFC, `HermitianMat`-only, and meaningless
   over non-associative octonions. `EJA/AlbertCarrier.lean:119` already said so.

★★ **STANDING RULE: grep for the STATEMENT SHAPE, not the name.** All three were under names no
one would guess. `grep -n "^def \|^theorem \|^instance " <file>` — list declarations, do not
guess identifiers. This is the rule `prop:central`'s row records validating itself on first use.

★ Also: one theorem was written and DELETED rather than patched — `quadJ_of_mul_eq_zero` asserted
`(a*a)*b = 0` from `a*b = 0`, which needs associativity a Jordan algebra does not have. Ship two
correct lemmas over three with one false.

## The exact next step, with the design decision already made

`sqrt_sum_eq_of_resolutions` — "two resolutions of the same element give the same square root" —
is the one theorem standing between the canonicity chain and a *definition* of `jsqrt`. Everything
it needs is proved:

* `nonzero_spectrum_eq_of_resolutions` — the two index sets carry the same eigenvalues;
* `idem_unique_of_resolutions` — matched eigenvalues carry the same idempotent;
* both sums collapse onto their nonzero parts because `Real.sqrt 0 = 0`.

**Design decision, made and recorded so it is not re-litigated:** use `Finset.sum_bij'`, NOT
`Finset.sum_nbij'`. Checked at source
(`.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Defs.lean:527`): `sum_nbij'`
takes *non-dependent* total functions `ι -> κ`, and the forward map here ("send `i` to the unique
`j` with `ld j = lc i`") only exists on the filtered subset — off it there is no `j`, and `Fin m`
has no junk value when `m = 0`. `sum_bij'` takes `i : forall a in s, κ`, so the membership proof
is in scope exactly where the witness is extracted. That is the right tool.

Attempted once on 2026-08-23 and reverted rather than left as a `sorry`. Estimated 60-100 lines.

After it: `jsqrt` becomes definable, then `a . b := quadJ (jsqrt a) b`, then S1-S7.
**S1 and S3 are already discharged** (`quadJ_add`, `quadJ_unit_left`). ★ **S4-S7 are NOT cheap** —
an earlier note in this file called the whole assembly "ordinary", which was too broad for five of
the seven clauses. Orthogonality symmetry, compatible associativity and the two multiplicativity
clauses are substantive Jordan identities and nothing built tonight makes them fall out.

## CORRECTION 2026-08-23 — the canonicity chain is NOT closed; I claimed it was

An earlier section of this file said the chain was "COMPLETE, nothing carried" and that
`nonzero_spectrum_eq_of_resolutions` discharged `idem_unique_of_resolutions`'s hypothesis.
**That is false.** Found while attempting `sqrt_sum_eq_of_resolutions`, which needs exactly that
link and could not get it.

* `idem_unique_of_resolutions` asks for `image lc univ = image ld univ` — the **full** eigenvalue
  sets — because it routes through `lagrange_basis_congr`, which needs the two interpolants equal
  **as polynomials**, and `Lagrange.basis Finset.univ` is built over the whole index type.
* `nonzero_spectrum_eq_of_resolutions` delivers equality of the **filtered** images only.
* These genuinely differ: a resolution may carry `c i = 0` with `lc i = 7` — a phantom eigenvalue
  contributing nothing to `x` — where another does not. Nothing forces the full images to agree.

**The repair, and it makes the result stronger:** polynomial equality is more than is needed. The
two interpolants only have to agree *modulo* `jann x`. They do — both are `lam_k^-1` at `lam_k` and
`0` at every other nonzero eigenvalue, so their difference vanishes on the nonzero spectrum, and
`jeval_eq_zero_iff_of_resolution` gives `jeval x (P1 - P2) = 0` (at a zero eigenvalue the `lam_i`
factor kills the term regardless). Reroute `idem_unique_of_resolutions` through that and it takes
`nonzero_spectrum_eq_of_resolutions` directly.

**Status: `idem_unique_of_resolutions` is TRUE and PROVED, but under a hypothesis nothing in the
tree supplies.** It is not wrong, it is unusable as it stands. The reroute is the next task, before
`sqrt_sum_eq_of_resolutions`.

★ **How this got past me:** I read "the hypothesis is an equal-spectrum statement" and matched it
against "I proved an equal-spectrum statement" without comparing the two Finsets. Same failure
shape as the biggest-residue error this manifest records four times — matching on the *description*
of a residue instead of on the residue.

