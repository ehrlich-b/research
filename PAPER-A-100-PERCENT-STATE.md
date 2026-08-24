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

## The gap is closed — `idem_unique_of_nonzero_spectrum` (2026-08-23, same session)

The reroute described in the correction above is DONE and sorry-free. It takes the **filtered**
image equality, which is exactly what `nonzero_spectrum_eq_of_resolutions` delivers, so the chain
now composes with nothing carried — this time verified by actually applying it, not by matching
descriptions.

Proof route, as predicted: the interpolants are NOT equal as polynomials; they are congruent mod
`jann x`. Each is `lam^-1` at its own eigenvalue and `0` at every other nonzero one, and
`jeval_eq_zero_iff_of_resolution` turns that into `jeval x (P1 - P2) = 0`, the zero eigenvalue
being killed by `jeval`'s own `lam_i` factor.

`idem_unique_of_resolutions` (the univ-image version) is KEPT, not deleted: it is true, and its
hypothesis is the natural one when both resolutions are already known reduced. But
**`idem_unique_of_nonzero_spectrum` is the one to use** — the other's hypothesis has no supplier.

Remaining to a definition of `jsqrt`: `sqrt_sum_eq_of_resolutions` via `Finset.sum_bij'` (see the
design note above), now with a usable uniqueness lemma to feed it.

## Sequential product: clause status at end of 2026-08-23

Candidate product: `a . b := quadJ (jsqrt a) b`, i.e. `Q_{sqrt a} b`, over `EJA/Class.lean`.

| clause | status | name |
|---|---|---|
| S1 additivity | **PROVED** (free) | `quadJ_add` — `quadJ a` is a linear map |
| S2 ou-norm continuity | OPEN | needs continuity of `jsqrt`; analysis, untouched |
| S3 unitality | **PROVED** | `quadJ_unit_left`, `quadJ_jsqrt_one` |
| S4 orthogonality symmetry | **PROVED** | `quadJ_jsqrt_zero_symm` |
| S5 compatible associativity | OPEN — the wall | |
| S6 compatibility/ortho + add | OPEN — the wall | |
| S7 multiplicativity of compat | OPEN — the wall | |

Also still needed for an actual `SequentialProductOnEJA` inhabitant: `sp_effect` (that
`Q_{sqrt a} b` is an effect when `a`,`b` are), which needs `Q_s` to preserve the cone.

**S5-S7 all turn on compatibility `a . b = b . a`.** The standard route is that compatible
elements operator-commute (`L_a L_b = L_b L_a`) and generate an associative subalgebra; that
characterisation is itself the hard theorem and is NOT in the tree. Do not price S5-S7 from how
S4 went.

### Why S4 went quickly, and what that predicts

Nothing in S4 was new mathematics. Every ingredient was already present or one question away:

* `mul_eq_zero_of_inner_mul_self_eq_zero` — the VANISHING case of `inner_mul_self_nonneg_of_idem`.
  That proof already decomposed `<L_c y, y> = |P_1 y|^2 + (1/2)|P_half y|^2`; nobody had read it
  at equality.
* `smul_resolution_mul_eq_zero_of_inner_eq_zero` — the PER-IDEMPOTENT form of the orthogonality
  proof, parameterised by any `g` with `g 0 = 0`. `g = sqrt` is what S4 needed.
* `jsqrt_mul_self'` — the OBSERVABLE-NONNEGATIVITY form. ★ This one was load-bearing:
  `forall i, 0 <= lam i` is UNSATISFIABLE from the order in general, because a coefficient at a
  zero idempotent is unconstrained and `nonneg_coeff_of_isSoS` only speaks at `q i != 0`. Without
  weakening it the assembly dead-ends at the last step.

★★ **The `ringOfBilinear` crossing is one-way in practice.** Going UP from a bilinear-map theorem
into `EJA/Class.lean` works — the class supplies the `jmulL` tuple by name, which is what that file
exists for (`jmul_eq_zero_of_inner_eq_zero` is the template). Going DOWN from the class's `mulLL`
into `orderUnitSpaceOfBilinear` does NOT: the two `Module R J` paths do not unify, measured twice
on 2026-08-23. Route new work upward.

★ **Ordering trap, hit twice:** `EJA/Order.lean` and `EJA/Spectral.lean` do not order their
declarations the way their section headers suggest. Two theorems had to be relocated after being
written above their dependencies. Grep for the dependency's line number before choosing an anchor.

## S5-S7: the obstruction, VERIFIED at source (2026-08-23)

S5 (compatible associativity) and S7 (multiplicativity of compatibility) turn on the **fundamental
formula** `Q_{Q_a b} = Q_a Q_b Q_a`, and S6 on the same operator-commutation theory.

**Mathlib does not have it.** Checked rather than assumed, because this manifest has been burned by
unverified "Mathlib lacks X" claims before:

* `Mathlib/Algebra/Jordan/Basic.lean` is the ONLY Jordan-algebra file. It carries `IsJordan`
  (`lmul_comm_rmul`, `lmul_lmul_comm_rmul`, `lmul_comm_rmul_rmul`) and `IsCommJordan`, and nothing
  else — no quadratic representation, no fundamental formula, no Peirce theory.
* Every other Mathlib file matching "Jordan" is unrelated: `Order/JordanHolder`,
  `LinearAlgebra/JordanChevalley`, `GroupTheory/GroupAction/Jordan`,
  `MeasureTheory/VectorMeasure/Decomposition/Jordan{,Sub}`,
  `Algebra/Lie/AdjointAction/JordanChevalley`.
* Zero hits for "quadratic representation", "fundamental formula", "Macdonald", "Shirshov"
  anywhere in Mathlib (the files that DO match "fundamental" are `RingTheory/Lasker`,
  `IsPrimary`, `AssociatedPrime`, `Artinian` — unrelated senses of the word).

So S5-S7 require building the fundamental formula in-tree, from `IsCommJordan` plus the Peirce
layer. That is a genuine multi-day theorem, not an assembly, and it is the honest price of rows 13
and 16. ★ Do NOT extrapolate from how fast S4 went: S4 consumed no Jordan identity beyond what
`inner_mul_self_nonneg_of_idem` already used.

## ★ The Peirce route into S5-S7 (found 2026-08-23, the one hopeful finding)

`quadJ_eq_peirceOne`: for an idempotent `c`, **`Q_c = P_1(c)`** — literally the same operator,
since `Q_c = 2L_c^2 - L_{c^2}` and `P_1(c) = 2L_c^2 - L_c` coincide once `c^2 = c`. Two lines.

`jsqrt_idem`: `sqrt c = c` for an idempotent, via the two-element resolution
`c = 1*c + 0*(1-c)`.

`quadJ_jsqrt_idem`: therefore **`c . b = P_1(c) b`** at a sharp effect — the Luders map, on the
nose, appearing concretely in this tree for the first time.

**Why this matters for the wall.** S5-S7 in general need the fundamental formula, which is absent
from the tree AND from Mathlib (verified above). But **at sharp effects the compatibility questions
become Peirce questions**, and the tree carries Peirce theory in depth across five files
(`Peirce`, `PeirceMul`, `PeirceSubalgebra`, `FramePeirce`, `FramePeirceMul`). That is the first
route into S5-S7 that uses machinery which exists.

★ This is NOT a claim that S5-S7 are cheap. The general case is unchanged. What changed is that
the sharp-effect case has a plausible attack, and sharp effects are exactly what `E_0` and
`lem:simple-bridge` (row 8) are about — so the two threads may converge.

## Where a next session should start

1. `sqrt_sum_eq_of_resolutions` and `jsqrt` are DONE; do not rebuild them.
2. S1/S3/S4 are DONE (`quadJ_add`, `quadJ_unit_left` + `quadJ_jsqrt_one`, `quadJ_jsqrt_zero_symm`).
3. Attack S5-S7 **at sharp effects first**, through `quadJ_eq_peirceOne` and the Peirce layer.
4. `sp_effect` (that `Q_{sqrt a} b` is an effect) is still open and needs `Q_s` to preserve the
   cone — not attempted.
5. Route new work UP into `EJA/Class.lean` via the `jmulL` tuple, never DOWN from `mulLL`.

# ═══════════════════════════════════════════════════════════════════════════
# 2026-08-24 — THE FUNDAMENTAL FORMULA IS PROVED. Scope reversed by Bryan.
# ═══════════════════════════════════════════════════════════════════════════

Bryan reversed the ARC-5/6 external pre-registration ("reach ground on everything / formalize
anything you need that's imported") and added that upstreamable work is a feature, not a detour.
The reversal is recorded at the head of `STATEMENT-MANIFEST.md` with his words verbatim.

## The chain built tonight, in dependency order. All sorry-free, axioms `[propext, Classical.choice, Quot.sound]`.

```
PeirceMul.lean   lin_jordan_apply          fully linearised Jordan identity, torsion cancelled
                 lin_jordan_diag           its diagonal case
Fundamental.lean mulL_comm_sq              [L_a, L_{a^2}] = 0
                 quadJ_mulL_comm           Q_a L_a = L_a Q_a
                 tripleJ / tripleJ_eq_mulL the Jordan triple product, {x,y,.} = L_xy + [L_x,L_y]
                 quadJ_polarisation        Q_{x+y} - Q_x - Q_y = 2{x,.,y}
                 tripleJ_quadJ_comm        V_{x,y} U_x = U_x V_{y,x}          <- the crux
                 quadJ_quadJ_quadJ         U_{U_x y} = U_x U_y U_x            <- THE FUNDAMENTAL FORMULA
                 quadJ_sq                  Q_{x^2} = Q_x o Q_x   (FF at y = 1)
                 quadJ_jsqrt_sq            Q_a = Q_{sqrt a} o Q_{sqrt a}
Spectral.lean    quadJ_of_resolution       Q acts COEFFICIENTWISE on a shared resolution
                 quadJ_jinvOfResolution    Q_x(x^-1) = x
                 luders_jsqrt_jinv         a . a^-1 = 1 for the Luders product   <- HALF OF ROW 13
                 luders_of_resolution      the Luders product is coefficientwise
OrthFamily.lean  sp_orthFamily_value       vdW 5.2 value law at OrderUnitSpace generality
                 sp_orthFamily_comm        + the compatibility transfer, + Fin-indexed corollaries
```

★ **`quadJ_quadJ_quadJ` is not in Mathlib** — its only Jordan file is `Algebra/Jordan/Basic.lean`,
carrying `IsJordan`/`IsCommJordan` and nothing else (verified). Neither is `lin_jordan_apply` nor
the quadratic representation. These are upstreamable on their own.

## How the fundamental formula was actually proved — the method matters more than the theorem

1. **Solve, do not guess.** A symbolic solver over the free commutative non-associative Q-algebra
   finds the certificate by linear algebra: expand goal and candidate relations into monomial
   trees, solve for rational coefficients. `scratchpad/ff2args.py`.
2. **Verify the target numerically BEFORE proving it.** Both identities were checked on random
   symmetric 3x3 reals under `a.b = (ab+ba)/2` to ~1e-14 first. Cheap insurance.
3. **The transport problem, and its fix.** `linear_combination (norm := module)` compares atoms
   SYNTACTICALLY, so a commutative-model certificate does not transfer. `simp only [mul_comm]`
   does NOT help — as a general lemma it rewrites by term order and never normalises nested
   products. What works: **oriented GROUND `mul_comm` instances**, one per out-of-order product
   node, pointed at a fixed total order on trees. Each strictly decreases a well-founded order so
   `simp only` terminates. FF1 needed 21 such instances; FF2 needed 364 (784 trees -> 302 atoms).
4. FF2's certificate is **208 terms** and cannot be made much smaller — a basic solution has at
   most `rank` nonzeros and the rank is ~200. It compiled first try, ~47s, `maxHeartbeats 2400000`.

## What is left on rows 13 / 16

S1, S3, S4 are proved for the candidate product `a . b := quadJ (jsqrt a) b`
(`quadJ_add`, `quadJ_unit_left` + `quadJ_jsqrt_one`, `quadJ_jsqrt_zero_symm`).
**S2, S5, S6, S7 remain, and they now reduce to ONE theorem**: operator-commuting elements admit a
SIMULTANEOUS resolution. `luders_of_resolution` makes the product coefficientwise on a shared
family, so every remaining axiom becomes arithmetic on reals once that lands.

## ★★★ THREE OF MY OWN CLAIMS WERE WRONG TONIGHT. All corrected in place.

1. **"FF1 is not in the degree-5 span"** — a confident measured negative result, and false. My
   commutativity relations swapped only at the ROOT of each monomial; relating trees differing at
   a DEEP node needs commutativity in context. Retracted in `Fundamental.lean` with the reason.
2. **"The canonicity chain is complete, nothing carried"** — false. `idem_unique_of_resolutions`
   wanted the FULL eigenvalue images while `nonzero_spectrum_eq_of_resolutions` supplies only the
   FILTERED ones. Fixed by rerouting through `jann`-congruence rather than polynomial equality
   (`idem_unique_of_nonzero_spectrum`).
3. **Palomar: two wrong hypotheses in a row** (theorem count, then Challenge file size). The real
   cause is a **Palomar-side review outage** starting between 15:32 and 18:57 on 2026-08-23:
   successful reviews take 3-4.5 minutes, every failure since takes 17-21 seconds. Full evidence
   in `~/scratch/palomar/queue.txt`; the queue is DISARMED so nothing resubmits.

★ Every one of the three was found by trying to USE the thing, never by re-reading it.

## NEXT, and it is now a port rather than a discovery: row 13's remaining half

Row 13 asserts `a·a⁻¹ = 1` **for the unknown product as well as the standard one**. The standard
half is proved (`luders_jsqrt_jinv`). The unknown half is `Necessity.sp_pseudoInv_eq_smul_one`
(`Necessity/PseudoInverse.lean:126`), which exists only over `HermitianMat` — and its one
non-portable dependency, the vdW 5.2 value law, **was ported to `OrderUnitSpace` generality on
2026-08-24** (`RadicalRelativity/OrthFamily.lean`). So the blocker is gone.

The concrete machinery and its abstract counterparts, all now available:

| concrete (`PseudoInverse.lean`)            | abstract counterpart                                    |
|---|---|
| `b.eigFinset`                              | the image of `lam` from `exists_resolution_distinct`    |
| `b.specProj μ`                             | the idempotents `c i` of that resolution                |
| `hproj : (p i).IsProjection`               | `isSharpOrderUnit_of_idem` (proved 2026-08-23)          |
| `horth : (p i).mat * (p j).mat = 0`        | **not needed** — the abstract law wants only `∑ p i ≤ 𝟙`|
| `sp_orthFamily_value`                      | `SequentialProductOn.sp_orthFamily_value` (abstract)    |
| `pseudoInvCoef b = ∏ μ ∈ eigFinset, μ`     | `∏ i, lam i` over the resolution's index                |
| `pseudoInv b = ∑ (c/μ) • specProj μ`       | `∑ i, (coef / lam i) • c i`                             |

★ The normalisation by `∏ lam i` is not cosmetic: it is what keeps the pseudo-inverse **inside the
effect interval**, which every hypothesis of the value law needs. `pseudoInvCoef_le` (the coef is
≤ every eigenvalue) is the lemma that does it, and it is pure real arithmetic — it should port
unchanged.

★★ Do NOT assume the abstract and concrete orthogonality hypotheses are interchangeable. The port
deliberately replaced matrix orthogonality with `IsSharp` + one full-family bound, which is
strictly weaker; `Necessity.isProjection_isSharp` proves the concrete side implies it, and **no
converse is claimed**.

If this port lands, row 13 has both halves and becomes the first row to move since row 5.

