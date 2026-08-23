/-
WALL CERTIFICATE — the abstract / vdW-bridge tier:
  `def:sp`                (row 3,  PARTIAL)
  `lem:span`              (row 5,  PARTIAL)
  `lem:homog` clause (i)  (row 6,  PARTIAL)
  `lem:simple-bridge`     (row 8,  PARTIAL as of 2026-08-22, ~3/4 cited — was ABSENT)
  `lem:normality`         (row 9,  ABSENT)
  `prop:central`          (row 12, PARTIAL)
  `prop:pseudo-transfer`  (row 13, PARTIAL)
Date: 2026-08-09, ARC-7 block 7.5.  Tag `paperA-arc7-cp1`.  Pin: main.tex blob 205fdf5a.

WHY ONE FILE: these are the rows whose remaining gap is the SAME kind of thing — either the
article's EJA generality (not statable, see the vocabulary-wall note) or one small clause on the
concrete carrier.  Grouping them keeps the shared evidence in one place instead of repeating it.

★★ READ THIS FIRST, because it is the pricing lesson this tier has already taught twice.
  ARC-5 priced the abstract tier as a large job, correctly diagnosing that the class carries only
  order-unit BOUNDEDNESS and that the genuine Archimedean squeeze was missing.  The diagnosis was
  right and the PRICE WAS WRONG: once `IsArchimedean` was supplied as an explicit `Prop`, the whole
  ten-step homogeneity ladder ported essentially verbatim, because it never used anything about
  matrices.  Cost was three missing order lemmas and one import.
  So: for every row below, the default assumption should be that it is CHEAPER than it looks, and
  the way to find out is to port one step, not to re-price the row.

PER-ROW STATUS AND GAP

  row 3 `def:sp`.  ★★★ **REWRITTEN 2026-08-22.  THE RESIDUE THIS ENTRY DESCRIBED IS BUILT, AND ITS
    "ATTACK THIS FIRST" RECOMMENDATION WOULD NOW COST A READER A DAY REBUILDING IT.**  The entry read:
    "Encoded as `SequentialProductOn` / `SequentialProduct`.  The gap is presentational but real:
    effect-closure is carried as the CODOMAIN condition `sp_effect` rather than as one of the
    article's seven clauses, so the Lean definition is not clause-for-clause the article's.  Closing
    it means restating the article's seven clauses verbatim and proving the two definitions
    equivalent.  Cheap, purely bookkeeping, and it would move a row.  ATTACK THIS FIRST in this file
    — it is the highest ratio of row-movement to difficulty anywhere in the manifest."
    **Every object it names now exists**, in namespace `PaperA` in
    `RadicalRelativity/RankTwo/Sufficiency.lean`, all Lean-core axiom-clean (`#print axioms`,
    2026-08-22):
      * `EffectSequentialProduct` (:1761) — the article's definition over `PaperA.Effect V`, with the
        operation typed `Effect V → Effect V → Effect V`, so **effect-closure is the codomain exactly
        as `main.tex:367` types it** rather than a clause.  Fields: S1 `add_right`, S3 `unit_left`,
        S4 `zero_symm`, S5 `assoc_of_compatible`, S6 `compatible_ortho` + `compatible_add`, S7
        `compatible_op`.
      * `restrictSp` (:1796) and `extendSp` (:1852), built on `extendByZero` (:1830), with
        `restrictSp_extendSp` an **equality of structures** and `extendSp_restrictSp_on_effects`
        agreement on the effects; `restrictSp_eq_iff` (:1923) is the extensionality this needs.
    ★★ **The 08-10 correction recorded further down this file was RIGHT, and is what the tree
    built.**  It said the two definitions "cannot be an isomorphism of products — by the same `badP`
    mechanism that killed row 35's onto half, extension is not unique, so the honest target is
    agreement on effect × effect".  That is precisely the asymmetric pair above, and
    `restrictSp_badP` (:1969) is `badP` landing on the correct side of it.  A certificate got a
    negative structural fact right and it survived into the design; that is the best moment in this
    file and it must not be lost in a rewrite.
    ★★★ **WHAT ACTUALLY BLOCKS THE ROW NOW IS S2, ALONE, and it is a missing OBJECT rather than a
    missing proof.**  `EffectSequentialProduct` carries S1 and S3–S7; the article lists S2 —
    continuity in the **order-unit** norm — as a clause of `def:sp`, and it cannot be a field at
    abstract generality because `OrderUnitSpace` carries its norm as independent structure that is
    not the order-unit norm.  Making it a field needs an abstract `ouNorm`; the only `ouNorm` in the
    tree is `HermitianMat.ouNorm` (`Hermitian/OrderUnit.lean`), and on that concrete carrier the gap
    is already closed by `Necessity.firstArgContinuousOu_iff`.  Verified at source 2026-08-22:
    `grep -rn 'ouNorm' RadicalRelativity/` → **114 hits across 5 files of 171** (22:54 EDT; the
    denominator is rising, re-run rather than trust it)
    (`Hermitian/OrderUnit.lean`, `Hermitian/Sequential.lean`, `Necessity/OrderUnitS2.lean`,
    `Necessity/ThetaIsometry.lean`, and one prose line in `SequentialProduct.lean`), with **exactly
    one definition site**, `Hermitian/OrderUnit.lean:133`, typed `HermitianMat n 𝕜 → ℝ`.
    ★ **The transferable bit is about the recommendation, not the row.**  "Highest ratio of
    row-movement to difficulty" was a *ranking*, and a ranking decays silently: the row it ranked
    first got most of the way done elsewhere in the tree, and nothing in this file could tell.  A
    certificate should price a row against the tree, not rank it against other rows.

  row 5 `lem:span`.  Spanning and extensionality are PROVED at the `OrderUnitSpace` interface
    (`span_isEffect_eq_top`, `linearMap_eq_of_eq_on_effects`), with the proof using order-unit
    boundedness alone.  Two clauses remain: (a) the BALL clause (effects contain the ball of radius
    1/2 about 1/2 * 1) needs the carried norm to BE the order-unit norm plus Archimedean — and note
    `HermitianMat.isArchimedean` is now proved (ARC-7), so this clause got cheaper today and should
    be re-attempted; (b) the PEIRCE clause, which the article gets by instantiating the lemma at
    (J_2(q), q) — so it follows once the tree knows J_2(q) is an order unit space, which it does not.

  row 6 clause (i).  ★ The record for this was WRONG until ARC-6: THEOREM-MAP said the positive
    linear extension was "not in the tree in any form", and `Necessity.seqLeftMul` IS it (a genuine
    `→ₗ[ℝ]`, with `seqLeftMul_apply_effect`, `_nonneg`, `_one`, and uniqueness from
    `linearMap_eq_of_eq_on_effects`).  What clause (i) needs is therefore the ABSTRACT PORT of that
    construction, not a construction.  Given the ARC-6 lesson above, this is likely cheap.

  row 8 `lem:simple-bridge`.  Priced per clause in ARC-6: the article's own proof assigns (i) to
    vdW Thm A.6, (iii) to vdW Props 4.19-4.20, (iv) to a vdW remark.  Only (ii) ("every effect is
    simple") is interior, and it is the Jordan spectral theorem.  Honest target = clause (ii) on the
    concrete carrier, where Mathlib's spectral theorem applies.  So this row should be READ AS ~3/4
    CITED, and the coverage arithmetic should not count it as a full interior row.
    ★ SUPERSEDED IN ITS TARGET 2026-08-22 (the ~3/4-cited pricing stands): clause (ii) no longer has
    to retreat to the concrete carrier, because the Jordan spectral theorem is now proved at EJA
    generality in this tree (`EJA.spectral_resolution_bilinear`).  See the ARC-8 block below.

  row 9 `lem:normality`.  ★★ REFUTED SAME DAY — see below; the row is now PARTIAL.  Original text:
    ABSENT.  On a f.d. order-unit space, S1 + S2 imply vdW-normality
    (b_k decreasing to b implies a . b_k decreasing to a . b) and compatibility passes to infima.
    The gap is stated below.  In finite dimension monotone bounded nets converge, so this is
    plausibly cheap; it was never attempted.

  row 12 `prop:central`.  The componentwise identity is proved
    (`MasterTheorem.Central.central_decomposition`).  ★★★ THIS ENTRY WAS WRONG TWICE OVER AND IS
    RETRACTED (2026-08-09).  It said the row needs "a direct-sum-of-order-unit-spaces construction the
    tree does not have": that construction is `DirectSum.lean:38 instance instProd`.  It also listed
    "the converse assembly" as open: that is `SequentialProductOn.prod` (`DirectSum.lean:84`), all
    eight fields, with `prod_sp`, `prod_fst`, `prod_snd` and `sp_eq_of_prod_eq`, and its docstring
    says outright "This is the *sufficiency* half of the omnibus's factorwise assembly".
    ★★ Caught by applying the rule from the quaternionic retraction — list a file's declarations
    instead of grepping for a guessed name.  The rule found this on its FIRST use.
    WHAT ACTUALLY REMAINS: the RESTRICTION direction only — that an arbitrary product on `V × W`
    restricts to S1-S7 products on each summand (grep `restrict|toSummand|ofProd` in DirectSum.lean
    -> prose only, 2026-08-09).

  row 13 `prop:pseudo-transfer`.  ★ ADVANCED TODAY: `Necessity.spCone_specInv_eq_one` proves the
    article's literal `a⁻¹ · a = 𝟙` with the true spectral inverse and no coefficient, using
    `spCone` and the freshly-proved `HermitianMat.isArchimedean`.  What remains is (a) the companion
    `a · a⁻¹ = 𝟙`, which puts the non-effect in the SECOND slot — `spCone` extends the first slot
    only, so this needs a second-argument extension nothing in the tree has; and (b) EJA generality.

ATTACK EVIDENCE — REFRESHED FOR ARC-8 (2026-08-10).  The ARC-8 orders require evidence FROM THIS ARC,
so the ARC-7 block below is provenance only.

  rows 5, 6, 13 — ★★★ CORRECTED 2026-08-10 (diff audit): only **row 13** moved out.  Rows 5 and 6 were
    claimed EJA-GATED and **WITHDRAWN the same day** (their residues contain non-EJA clauses: row 5's
    ball clause needs the order-unit norm; row 6's clause (ii) is ALREADY abstract as
    `SequentialProductOn.sp_smul_left`, and the reasoning below citing `HermitianMat.twistSeq_smul_left`
    — a theorem about ONE product — is the misreading that produced the wrong gate assignment).  **Rows 5
    and 6 are WALL-CERTIFIED HERE**, and this note claimed otherwise for hours, leaving them pointing at
    a certificate whose own header disclaimed them.  Original text follows.
  (formerly:) rows 5, 6, 13 — MOVED OUT of this certificate: all three are now **EJA-GATED**
    (`WallCertificates/eja-gated.lean`; row 5 and row 15 on gate (E2) Peirce, rows 6 and 13 on gate
    (E1) the Jordan spectral theorem).  ★ Row 6's clause (ii) `(λa)·b = λ(a·b)` was also CLOSED on the
    concrete carrier this arc as `HermitianMat.twistSeq_smul_left`, and the way it closed is worth
    keeping: it came out of the **constant-parameter S5 instantiated at a scalar left factor**, not
    from a functional-calculus scaling identity.  An axiom the tree already has, applied at a
    degenerate argument, replaced a lemma about the construction.

  row 3 `def:sp` — attacked in ARC-8; see the block at `extendByZero` below.  Net: the restriction
    direction is trivial, the extension direction has a canonical construction now in this file (and
    already in the tree, instantiated, as `Necessity.badP`), and the row's real cost is **transcribing
    the article's seven clauses over the effect subtype** — statement size, not proof difficulty.
    Deliberately not `sorry`-ed without `main.tex:363-392` open, for the reason row 22 and row 36(i)
    illustrate.
    ★★★ **SETTLED 2026-08-22 AND THE ESTIMATE HELD EXACTLY.**  The transcription was done — in the
    tree, not here — as `PaperA.EffectSequentialProduct` with `restrictSp`/`extendSp`
    (`RankTwo/Sufficiency.lean:1761` ff.), and it is statement size: the structure's eight fields are
    the `SequentialProductOn` fields with the guards discharged by the subtype, and every proof in
    `restrictSp` is a `show`/`rw` pair.  ★ The decision not to `sorry` it without `main.tex` open was
    also right for its stated reason — the article types the operation on the effects
    (`main.tex:367`), and a transcription from memory would have written effect-closure as a clause,
    which is the very defect the row records.  **This is the one row in this file where the price,
    the reason, and the refusal to guess were all correct**; see row 3's rewritten entry above for
    what is left, which is S2 and only S2.
    ★★ ONE CORRECTION, 2026-08-10 (refutation review): the row-3 block promises an "equivalence" of the
    two definitions.  **It cannot be an isomorphism of products** — by the same `badP` mechanism that
    killed row 35's onto half, extension is **not unique**, so the honest target is agreement on
    effect × effect.  Sending the next person after a bijection this directory proves does not exist
    would waste them.

  row 8 `lem:simple-bridge` — ★★★ THIS BLOCK IS RETRACTED 2026-08-22, on both of its claims.  It read:
    "attacked this arc and **BLOCKED ON THE ARTICLE, not on Lean.**  The only interior clause is (ii)
    'every effect is simple (E = E₀)', and `simple` here is vdW's SES notion.  I could not state clause
    (ii) faithfully without vdW's definition, and declined to guess it.  ★ That is a different kind of
    blocker from every other row in this file and it should be labelled as such: the obstruction is a
    missing DEFINITION from a cited source, so the next action is a reading task, not a proving task."
    (a) THE DEFINITION WAS ON THE PAGE THIS FILE IS PINNED TO.  `main.tex:507-515` gives it in the
    lemma's own preamble: a simple effect is one in vdW's class E_0, i.e. with a finite spectral
    decomposition into orthogonal SHARP effects, and sharp is the order-theoretic `p ^ (e - p) = 0`
    (vdW Def. 3.14), which the article then identifies with idempotence (vdW Prop. 3.15).  Nothing had
    to be guessed and no reading task was outstanding.
    (b) THE MATHEMATICS IS NOW IN THE TREE.  The article's own proof of clause (ii) is "the Jordan
    spectral theorem" (main.tex:549-550), and that is `EJA.spectral_resolution_bilinear`
    (`EJA/Spectral.lean:580`) at EJA generality, with a unit and completeness.  The manifest row moved
    ABSENT -> PARTIAL on this.
    ★ What remains is genuinely small and is the honest next action: define E_0, prove
    `idempotent -> IsSharp` for the effect order, and state "every effect is simple".
    `OrderUnitSpace.IsSharp` (`OrderUnitSpace.lean:161`) exists and is used NOWHERE — 1 occurrence in
    the whole checkout, its own definition — and the carrier link the bridge needs landed the same day
    (`EJA.orderUnitSpaceOfBilinear`, `EJA/Order.lean:252`).
    Clauses (i), (iii), (iv) remain assigned to vdW by the article's own proof, so this row is
    ~3/4 external either way, and that part of the ARC-6 pricing is unaffected.

  row 9 `lem:normality` — attacked this arc and ADVANCED: `Necessity.compatible_of_tendsto` closes the
    compatibility clause (compatibility passes to limits of effect sequences).  ★★ And the finding is
    an asymmetry this certificate's earlier note would have led a reader to get wrong: the convergence
    clause needs **no S2** (linearity of `seqLeftMul` plus finite dimensionality), but the compatibility
    clause **does** — `a·b_k → a·b` is free, `b_k·a → b·a` is first-argument continuity.  Anyone
    carrying "S2 is not used at all" forward from the convergence clause is wrong.  Residue: the
    article's order-INFIMUM form, which additionally needs Loewner monotone convergence — absent, grep
    scope recorded at the theorem (`iInf|⨅|Antitone|tendsto_of_antitone` over `RadicalRelativity/`,
    2026-08-09: only `Submodule`-kernel infima and one vendored `Set.Icc` lemma).

  row 12 `prop:central` — attacked this arc from BOTH directions.
    (a) Positive direction: the residue is confirmed to be the **restriction** half only — that every
    product on `V × W` is of the form `P.prod Q` — and `DirectSum.lean`'s own docstring says so.  This
    is `prop:central`'s splitting via central idempotents, the half the manuscript carries as a paper
    proof.  So the ARC-8 orders' listing of it under the "cheap interior sweep" was a MISPRICING, now
    corrected in `LEDGER.md`.
    (b) ★★ Refutation direction, prompted by the row-35 result this arc (where the analogous "onto"
    claim turned out FALSE because `badP` exploits the `IsEffect`-guarding): I tried to build a
    NON-split product on `V × W`.  The obvious candidates fail, and they fail at **S3**: any
    construction that discards a summand (e.g. `Q.sp a b := (P.sp a.1 b.1, 0)`) breaks
    `sp_unit_left`, since `Q.sp ousUnit a = (a.1, 0) ≠ a`.  So unlike row 35, row 12's claim is **not**
    refutable by a totality trick — the unit axiom reaches into both summands.  A failed refutation is
    evidence, and this one says the row is genuinely open in the positive direction rather than
    mis-stated.

PRIOR (ARC-7) ATTACK EVIDENCE, provenance only:

  Rows 6(ii) and 7 were attacked and CLOSED in ARC-6 at abstract generality.  Row 13's first half
  was attacked and closed today.  Rows 3, 5(a), 5(b), 8(ii), 9, 12 were NOT attempted in either
  arc — their prices above are reasoned from the article's own proofs plus the tree's contents, and
  are therefore the weak grade of evidence.  Row 3 and row 9 are the two most likely to be
  over-priced here.

ABSENCE CLAIMS AND THEIR SCOPE
  * ★★★ "no Jordan/EJA class, so EJA generality is not statable" — **RETRACTED 2026-08-09.  The
    tree DOES state the article's generality.**  `MasterTheorem/Interface.lean`'s
    `structure ComparisonSetup` carries a Jordan product (as a FIELD named `jordan`), a unit,
    `jordan_comm`, `rank_ge : 3 <= n`, a **Jordan frame** `p : Fin n -> J`, a cone, `Inv`, and
    `Theta` with its three properties — and row 16's clauses are PROVED over it.  My grep pattern
    could not see it because the structure is named `ComparisonSetup`.  Tenth false absence claim on
    this project; full retraction in WallCertificates/differential-trio.lean.
    ★ What IS absent: an axiomatization making the cited vIR/FK fields derivable rather than carried
    (`Interface.lean` says outright it "does not encode the JB-algebra premises").  So where this
    file leaned on "not statable" — rows 5 (Peirce clause) and 6(i) — the honest blocker is that
    axiomatization, not the vocabulary.
  * "no `J_2(q)` as an order unit space":
      grep -rn 'J2\|PeirceTwo\|peirce.*OrderUnit' RadicalRelativity/ -> `cornerJ2` is a PREDICATE on
      elements, not a carrier type; no `OrderUnitSpace` instance for a Peirce subalgebra.
  * ★★ "no direct sum of order unit spaces" — **FALSE, RETRACTED 2026-08-09 by the
    certificate-refutation review.**  `RadicalRelativity/DirectSum.lean:38` is
    `instance instProd : OrderUnitSpace (V × W)`, with `prod_ousUnit` (:54) and `isEffect_prod_iff`
    (:59), and that file's own header calls it "the M7 foundation … carrier for that decomposition:
    the direct sum of order-unit spaces".  The grep
    `DirectSum.*OrderUnit|OrderUnit.*DirectSum|Pi.*OrderUnitSpace` was accurate and the inference was
    invalid: the pattern needed both words on ONE LINE, and the instance is called `instProd` in a
    file called `DirectSum.lean`.  **This DE-PRICES row 12 `prop:central`, whose stated blocker was
    exactly this object** — summand inheritance and the converse assembly should now be attempted, not
    deferred.  Seventh false absence claim on this project; second one today whose grep was accurate.
  * ★★ "no second-argument cone extension" — the OBJECT was genuinely absent, but the PRICING was
    wrong and the object now EXISTS.  `SequentialProductOn.spConeRight` /
    `sp_coneNorm_indep_right` / `spConeRight_eq` / `spConeRight_of_isEffect` landed 2026-08-09 after
    the review discharged it in ~25 lines: its only ingredient, `sp_smul_right_of_unitInterval`, was
    already in the tree, and it needs `IsArchimedean` but **no S2 at all** — making the right slot
    strictly CHEAPER than the left.  The phrase "nothing in the tree has" was true of the object and
    misleading about the cost.  Consequence: `Necessity.spConeRight_specInv_eq_one` now proves the
    article's `a · a⁻¹ = 𝟙`, so **row 13's identity holds in BOTH slots**.

NOT imported from RadicalRelativity/.
-/
import RadicalRelativity.Necessity.PseudoInverse

set_option linter.style.longLine false

namespace WallCertificate

open scoped Matrix
open ComplexOrder OrderUnitSpace

variable {V : Type*} [OrderUnitSpace V]

/-! ### Row 9 `lem:normality` — stated, never attempted

The cleanest statable form of the article's normality: a decreasing sequence of effects with an
infimum has its images decreasing to the image of the infimum.  In finite dimension this should
follow from S2 plus monotone convergence; the tree has neither the statement nor an attempt. -/

/-- ★★ **NO LONGER A GAP — REFUTED 2026-08-09, THE SAME DAY THIS CERTIFICATE WAS WRITTEN.**

The convergence clause is proved in the tree as `Necessity.sp_tendsto_of_tendsto`, and it needs
**no S2 at all**: additivity alone extends `b ↦ a · b` to the linear map `seqLeftMul`, and a linear
map on a finite-dimensional normed space is automatically continuous.  So the result is *stronger*
than the article's statement, which assumes S1 and S2.

The statement below is kept, with its `sorry`, as the **abstract** form — the article's own
generality, over an arbitrary `OrderUnitSpace` rather than the concrete carrier.  That is what
remains, together with the compatibility-passes-to-infima clause.

★★★ UNDER-HYPOTHESIZED — flagged 2026-08-10 by the certificate-refutation review.  The statement
below quantifies over an arbitrary `OrderUnitSpace V` with **neither finite-dimensionality nor
`IsArchimedean`**, while its own prose argues "in finite dimension monotone bounded nets converge" —
about a statement that does not assume it.  `OrderUnitSpace` carries the norm as *independent*
structure and only order-unit boundedness, so positivity of `seqLeftMul` does not give norm
continuity, and the in-tree concrete proof (`Necessity.sp_tendsto_of_tendsto`) used
finite-dimensionality explicitly.  ★★ **The same defect is flagged TWELVE LINES BELOW for its
neighbour `spCone_right_exists` ("as written it OMITS `IsArchimedean V` … probably not provable at
all") — flagged there, missed here, in one pass over one file.**  Left as written, with this label, so
the pair can be compared; the fix is `[FiniteDimensional ℝ V]` (and `hS2` is additionally inert by
this file's own row-9 finding). -/
theorem normality (P : SequentialProductOn V) (hS2 : P.FirstArgContinuous)
    {a : V} (ha : IsEffect a) (b : ℕ → V) (hb : ∀ k, IsEffect (b k))
    (hmono : ∀ k, b (k + 1) ≤ b k) (blim : V) (hblim : IsEffect blim)
    (hconv : Filter.Tendsto b Filter.atTop (nhds blim)) :
    Filter.Tendsto (fun k => P.sp a (b k)) Filter.atTop (nhds (P.sp a blim)) := by
  sorry

/-! ### Row 13's remaining half — the second-slot extension

`spCone` extends the FIRST argument.  The article's `a · a⁻¹ = 𝟙` needs the non-effect in the
second slot.  Stated below so the missing object is on the record as an object, not a remark. -/

/-- ★★ **NO LONGER A GAP — DISCHARGED 2026-08-09, the day this certificate was written**, by the
certificate-refutation review.  `SequentialProductOn.spConeRight` is in the tree.

The statement below is kept, with its `sorry`, only to record a **second defect the review found in
it**: as written it OMITS `IsArchimedean V`, and without that hypothesis there is no route to
second-argument homogeneity, so the proposition is probably not provable at all.  Compare
`spCone_eq`/`sp_coneNorm_indep`, which both carry `harch`.  A gap stated with too few hypotheses is
the same class of defect as row 22's false statement: it sends the next person after something
unreachable. -/
theorem spCone_right_exists (P : SequentialProductOn V) :
    ∃ f : V → V → V, ∀ (a v : V), IsEffect a → (0 : V) ≤ v →
      ∀ μ : ℝ, SequentialProductOn.IsConeNorm v μ → f a v = μ • P.sp a (μ⁻¹ • v) := by
  sorry

/-! ### Row 3 `def:sp` — BUILT IN THE TREE 2026-08-22; this section's declarations are removed

★★★ **EVERYTHING THIS SECTION CONTAINED NOW EXISTS IN NAMESPACE `PaperA` IN
`RadicalRelativity/RankTwo/Sufficiency.lean`, AND KEEPING A LOCAL COPY WOULD HAVE SENT A READER TO
REBUILD IT.**  The declarations that stood here were `def_sp_clauses` (three of the article's clauses
read off the structure's fields, proved), `extendByZero` and `extendByZero_apply`.  In the tree:
`PaperA.EffectSequentialProduct` (`:1761`), `PaperA.restrictSp` (`:1796`), `PaperA.extendByZero`
(`:1830`), `PaperA.extendSp` (`:1852`), with `restrictSp_extendSp`, `extendSp_restrictSp_on_effects`,
`restrictSp_eq_iff` and `restrictSp_badP`.  All Lean-core axiom-clean, checked 2026-08-22.

**The two findings this section recorded both held, and they are the reason it is worth reading at
all:**

* **The price was right and it was about STATEMENT SIZE, not difficulty.**  "The honest cost of this
  row is writing the article's seven clauses out over the effect subtype — roughly thirty lines of
  *statement* — and not any proof difficulty.  Every clause is the corresponding
  `SequentialProductOn` field with the guards discharged by the subtype."  That is exactly what
  `EffectSequentialProduct` and `restrictSp` are.  It also correctly predicted that the *extension*
  direction needed a construction and that `Necessity.badP` was already that construction
  instantiated — `PaperA.restrictSp_badP` is `badP` landing in the finished frame.

* ★★ **The 08-10 correction — "it cannot be an isomorphism of products; the honest target is
  agreement on effect × effect" — was the load-bearing one.**  Extension is not unique (`badP`), so
  no bijection exists, and the tree's pair is asymmetric for that reason: `restrictSp_extendSp` is an
  **equality of structures** in one direction and `extendSp_restrictSp_on_effects` is agreement on
  the effects in the other, which is the most that can be true because the axioms are
  `IsEffect`-guarded and cannot see off the effects.  A certificate that talks a later builder out of
  a theorem that does not exist has paid for itself.

★ **What is NOT closed, and it is one clause: S2.**  See row 3's entry in the header block.  The
article lists S2 as a clause of `def:sp`; `EffectSequentialProduct` cannot carry it at abstract
generality because the tree's only `ouNorm` is `HermitianMat`-typed.  ★ Note what that does to the
old recommendation: the row's *residue* is now smaller and *harder* than the residue this section
priced.  Transcription was cheap and is done; the missing object is not transcription.

★ **Deliberately no `sorry` is left here.**  An abstract `ouNorm` is a definition to write, not a
proposition to prove, and this directory's rule is that a gap statement must be strong enough that
proving it would move the row.  There is no proposition here whose proof would move row 3. -/

end WallCertificate
