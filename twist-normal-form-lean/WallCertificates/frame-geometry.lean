/-
WALL CERTIFICATE — the frame-geometry and necessity remainder:
  `lem:frame-fix`            (row 15, PARTIAL)
  `lem:orientation`          (row 22, PARTIAL — was ABSENT here; corrected 2026-08-22)
  `lem:frame-connectivity`   (row 26, PARTIAL)
  `thm:qubit-boundary`       (row 31, PARTIAL)
Written 2026-08-09, ARC-7 block 7.5.  Tag `paperA-arc7-cp1`.  Pin at writing: main.tex blob
205fdf5a; the 2026-08-22 corrections below were read at blob 4b0dba30.
Statuses above re-derived 2026-08-22 22:53 EDT by running STATEMENT-MANIFEST.md's own census script:
rows 15, 22, 26 and 31 all read PARTIAL.  ★ Only those four are quoted, deliberately — the global
census moved four times on 2026-08-22 and a copy of it here would be stale by morning.  Re-run the
script; do not read a count out of a certificate.

SORRY COUNT: **1**, and it is `adjBlock_connected` (row 26).  It was 3 before 2026-08-22; the other
two were removed because the tree proves them — see the two notes immediately below.  Verify with
`lake env lean WallCertificates/frame-geometry.lean`, counting real errors over the FULL output as
`grep -cE ': error'` and gaps as ``grep -cF 'declaration uses `sorry`'``.  Row 26 is the one gap
statement; rows 15, 22 and 31 carry none — 15 and 22 are priced in prose in the per-row block, and
31's residue is assembly of in-tree declarations named in its entry.

★★★ TWO ROWS LEFT THIS CERTIFICATE ON 2026-08-22, AND NEITHER LEFT THE WAY THIS FILE PREDICTED.
Both are recorded rather than deleted, because in each case the row moved and the residue analysis
written here did not survive contact with it.

  `prop:n2-necessity` gap (b) (row 29) — **DISCHARGED IN-TREE, VERBATIM.**
    `Necessity.n2_theta_block_rotation` (`Necessity/ComplexRowUnconditional.lean:789`) carries the
    same hypotheses and the same conclusion as this file's `n2_necessity_theta_level` did, names
    this certificate in its own docstring, and is Lean-core axiom-clean (`#print axioms`, checked
    2026-08-22).  The row is FORMALIZED in the manifest on the strictly stronger
    `Necessity.n2_theta_eq_rotation`, which states the same fact in the article's own
    `cos φ · id + sin φ · 𝒥_n` form.  ★ This file's pricing of gap (b) was RIGHT — "no vocabulary
    wall, the sentence was simply never written" — which is the one prediction in this certificate
    that was both non-trivial and confirmed.

  `cor:selectors` clause (i) (row 36) — **CLOSED IN-TREE, AND WITHOUT THE OBJECT THIS FILE SENT
    THE NEXT PERSON AFTER.**  `Necessity.selector_peirceExchange` (`:608`) closes it against
    `Necessity.PeirceExchangeCovariant` (`:594`), non-vacuous on both sides
    (`luders_peirceExchangeCovariant`, `peirceExchangeCovariant_forces_zero`), all axiom-clean.
    ★★★ **The residue analysis here was wrong about WHICH OBJECT the clause needs.**  This file
    priced clause (i) as "the Peirce exchange automorphism WITH its coherence-block action" and
    wrote `exists_peirce_exchange` — an order isomorphism carrying `frameProj i` to `frameProj j`
    — as the gap.  `main.tex:1990-1994` defines Peirce exchange covariance as `E(x,y) = E(y,x)`
    with the block's complex structure `𝒥` held **fixed**, and says in the same sentence that it is
    "not a relabelling of `p_i, p_j`".  `exists_peirce_exchange` was exactly that relabelling.  It
    had already self-flagged VACUOUS in its own docstring; the vacuity and the wrong object were
    the same defect seen from two sides, and only the vacuity got recorded.  What actually closed
    the row was `E` itself — `twistSeq_diagFamily_blockHerm` exhibits the block action as
    multiplication by `blockCoef = √(xy)·exp(i t log(x/y))` — plus
    `seqLeftMul_eq_conjLinear_twistFactor`, needed because a nonzero block element is never an
    effect.  No automorphism appears anywhere in the proof.
    ★ **The transferable form: a gap statement can be non-vacuous and still be about the wrong
    object.**  The inert-hypothesis test this file applied caught the vacuity; nothing here tested
    the statement against the article's own definition of the hypothesis, which is what would have
    caught the rest.

PER-ROW STATUS AND GAP

  row 15 `lem:frame-fix`.  A certificate for the produced setup exists
    (`MasterTheorem/Master.lean`); the general statement — Theta_r fixes each frame atom and the
    diagonal pointwise, preserves each Peirce block, and lies in Stab(F)^0, hence L_{a(r)} is
    Peirce-block-diagonal — is open.  The last clause ("lies in Stab(F)^0") needs the stabilizer as
    a group with an identity component, the same missing vocabulary as row 18.

  row 22 `lem:orientation`.  ★★★ **REWRITTEN 2026-08-22.  THE "X IS A CARRIER THE TREE DOES NOT
    HAVE" RETRACTION BELOW WAS ITSELF WRONG, AND IT WAS THE STRONGER OF THIS FILE'S TWO ERRORS ON
    THIS ROW.**  Read at `main.tex:1176` (blob 4b0dba30), X is
    `{x : q ∘ x = ½x = p_k ∘ x}` — a **predicate**, not a carrier — and every clause of the lemma is
    pointwise under it, so no carrier was ever needed.  `Necessity.IsCrossCoherent`
    (`Necessity/ComplexRowUnconditional.lean:915`) is that predicate verbatim, and
    `Necessity.isCrossCoherent_iff` **proves** the article's identification of X with the corner
    form `x = z + z*` instead of assuming it.  What is proved, at what generality (all axiom-clean,
    `#print axioms` 2026-08-22):
      (i)   `orientationJ_corner`, `orientationJ_isCrossCoherent`, `orientationJ_sq` — at the
            article's own generality, q and p_k orthogonal idempotents, arbitrary n.  The clause's
            splitting-independence phrase is discharged by the FORM of the definition:
            `Necessity.orientationJ` takes q and p and nothing else, so there is no splitting for
            it to depend on, and no theorem is stated for it.
      (ii)  `orientationJ_adU` — proved UNRESTRICTED, for every x rather than only on X, because
            the article's computation q(uxu*)p_k = u(q x p_k)u* never uses the coherence condition.
            Stronger than the article's clause.
      (iii) `adU_eq_rotation_on_crossCoherent` — the article's own proof step at its own
            generality, and this is why the row is PARTIAL rather than FORMALIZED.  What is NOT
            proved is that a^{it} is such a u for an arbitrary a = lam·q + sum_{l>=3} lam_l·p_l;
            that needs `cfc f a * q = f(lam) • q` for a spectral projection q of a, which the tree
            has only for the diagonal family.  `torusU_framePair` supplies the identification at
            the standard frame and `adU_torusU_eq_rotation` FIRES clause (iii) there, so the
            hypothesis class is inhabited by composition rather than by inspection.
    Non-vacuity of X: `blockHerm_isCrossCoherent` with `blockHerm_ne_zero`.
    ★★ **WHAT SURVIVES OF THE RETRACTION, AND IT IS THE HALF WORTH KEEPING.**  The Lean statement
    this file first wrote down — the unrestricted `forall x, J (J x) = -x` — **is still FALSE**,
    with a compiled witness (`frameProj_mul_orthogonal_eq_zero` below), and so was its first repair
    (see the two retractions at `orientation_complex_structure`).  The diagnosis "the statement is
    false" was right; the explanation attached to it — "because X is a missing carrier" — was
    wrong, and the wrong explanation is what stopped the row for twelve days.  ★ **A correct
    refutation with an invented cause is more expensive than no refutation**: it prices the row and
    the price is unfalsifiable, because nobody re-greps a claim that already explains a
    counterexample.

  row 26 `lem:frame-connectivity`.  ★ The pricing here has already been corrected once and the
    correction must not be lost: `AdjBlock` (the article's adjacency: all but two axes fixed) is
    STRICTLY FINER than `AdjAxis` (some axis fixed).  So connectivity for the article's graph does
    NOT follow from the in-tree `adjAxis_connected` — it is strictly STRONGER, and needs every
    unitary to factor into rank-two block rotations (Givens/Jacobi), not into the three axis-fixing
    Householder factors `exists_axisFixing_factor` provides.  ★★ And a SECOND correction: an earlier
    claim that "`AdjBlock` is a superset of the article's relation" is FALSE (article frames are
    unordered atom sets).  Never repeat the superset claim.

  row 29 gap (b).  ★★★ **CLOSED 2026-08-22; entry kept only so the row's history reads in one
    place.**  This line said "the article's conclusion is about Theta_a restricted to W_n; Lean's is
    the product-level identity `n2_sp_eq_twistSeq_frame`; their equivalence is the route rather than
    a proved statement".  It is a proved statement now — `Necessity.n2_theta_block_rotation`
    (`Necessity/ComplexRowUnconditional.lean:789`), by way of
    `Necessity.theta_eq_conjLinear_torus`, which identifies Theta_a with conjugation by
    U·U_t(r)·U* because the Q_{sqrt a}^{-1} half cancels the twist factor's modulus exactly.  Gap
    (a) — the U(2) -> S^2 fibre gap — had already CLOSED in ARC-6.  Header note above for the rest.

  row 31 `thm:qubit-boundary`.  ★★★ CORRECTED 2026-08-22.  This line read "Parts (i) and (iii)
    are proved, plus the cocycle and backward compatibility", and **that sentence is the one the
    2026-08-22 promotion of this row inherited, and it is wrong about part (i)**.  It was written
    before the row-30/31 ENCODING SPLIT was known, and the split was later closed for clause (iii)
    ONLY.  Part (i) has two halves: effect preservation (proved), and the coherence action on W_n
    at the ordered frame — `sqrt(l+ l-) * exp(l * tau(a) * J_n)`, with the Luders value 0 at
    l- = 0 — which is part of the article's STATEMENT (main.tex:1720-1758) and is NOT in the tree.
    What exists is the entry-level `MasterTheorem.RankTwo.sp_blockForm` about
    `sp = Fdiag * b * Fdiag^H`, which no declaration identifies with `HermitianMat.twistSeq`;
    `Necessity.blockHerm` (the coherence block) occurs 0 times in `RankTwo/Sufficiency.lean`; and
    `Necessity.orientationJ` (the article's J_n) occurs in 1 of the tree's `.lean` files (**171** at 2026-08-23 02:50 EDT; re-derive with `find RadicalRelativity -name '*.lean' | wc -l` rather than trusting this number — it moved 167 → 171 in under two hours) of
    `RadicalRelativity/`, which names neither `n2Sp` nor `tauModuliRP2`.
    The manifest row is PARTIAL again on this finding, and the residue is ASSEMBLY of four
    in-tree declarations (`n2Sp_eq_twistSeq_at_frame`, `twistSeq_adU_mat`,
    `twistSeq_diagFamily_blockHerm`, `orientationJ`), not new mathematics.
    ★ LESSON, and it is why this correction is written here rather than only in the manifest:
    a certificate line that predates a defect is not evidence about that defect, and this file's
    own header row for row 31 never stopped saying PARTIAL.
    Open, restated, and it is now ONE item: part (i)'s coherence-action half in the `twistSeq`
    encoding.  The other two items this line used to list are gone for unrelated reasons and must
    not be re-added: the bundled S1-S7 clause CLOSED in ARC-8 (row 30 holds for an arbitrary
    `t : C(RP2, R)`, and `tauModuliRP2` is one, S2 included), and the unimodular cocycle subcases
    were REATTRIBUTED to row 30 — the zeta case verification is Step 6 of `prop:n2-sufficiency`'s
    proof and closes before `thm:qubit-boundary` begins.
    ★ The tail of the old line — "the bundled S1-S7 clause is an INSTANTIATION of row 30 at
    t = tau, so it should not be attacked separately" — is DELETED rather than kept as provenance,
    because it read as an instruction about live work on a clause that is closed, sitting three
    lines under the sentence saying so.  `WallCertificates/prop-n2-sufficiency.lean` still holds
    row 30's own record.

  row 36 clause (i).  ★★★ **CLOSED 2026-08-22 — see the header note, which also records what this
    entry got wrong.**  The prediction in this line held on its narrow point and is worth keeping
    for that: clause (i) did need the coherence-block action, and it did NOT go through the trace
    form (clause (ii)) or the functional calculus (clause (iii)).  What the line got wrong is the
    shape of that action — it is `E(x,y)` on a fixed block, exhibited by
    `Necessity.twistSeq_diagFamily_blockHerm`, not an automorphism of `H_N(C)`.

ATTACK EVIDENCE — REFRESHED FOR ARC-8 (2026-08-10).  The ARC-8 orders require attack evidence FROM
THIS ARC ("a certificate that was not re-attacked this arc is a prose price with a `.lean` extension"),
so the ARC-7 evidence below is retained as provenance and superseded by this block.

  row 15 `lem:frame-fix` — ★★★ CORRECTED 2026-08-10 (diff audit): the EJA-GATED claim was **WITHDRAWN
    the same day it was made**, because the article's statement includes "and lies in Stab(F)°", which
    needs identity-component vocabulary and is NOT the axiomatization — and the note below silently
    narrowed the residue to "the Peirce-block clauses", which is exactly the narrowing `eja-gated.lean`
    identifies as the defect.  **Row 15 is WALL-CERTIFIED HERE.**  Original text follows.
  (formerly:) row 15 `lem:frame-fix` — MOVED OUT of this certificate: it is now **EJA-GATED**
    (`WallCertificates/eja-gated.lean`, gate (E2) Peirce).  Its residue is the Peirce-block clauses,
    which are gated on the axiomatization, not on anything in this file.

  row 22 `lem:orientation` — ★★★ **THIS ENTRY IS REFUTED BY ITS OWN RECORDED GREP, 2026-08-22.**  It
    read: "attacked this arc by DRY PASS, and the absence CONFIRMED: no declaration in `Necessity/`
    matches `coheren|orientat|J_q` (2026-08-10).  The coherence space is a carrier the tree does not
    have.  ★ NOT restated: the previous attempt to sidestep the carrier produced a FALSE statement,
    and repeating that without the article's definition of `J_{q,k}` in front of me would repeat the
    defect."
    Re-run 2026-08-22: `grep -c 'coheren\|orientat\|J_q'
    RadicalRelativity/Necessity/ComplexRowUnconditional.lean` → **91**, in that one file alone, and
    the declaration list of that file contains `IsCrossCoherent` (:915), `orientationJ` (:880),
    `orientationJ_sq` (:1006) and `adU_eq_rotation_on_crossCoherent` (:1051).
    ★★ **The 08-10 dry pass was not wrong about the tree of 08-10; it is wrong as a standing claim,
    and it was written as one.**  An absence claim with a date and no re-run rule is a claim that
    ages into a falsehood on a schedule nobody watches — which is what happened here, and what the
    same-day promotion of row 22 to PARTIAL exposed.
    ★ And the deliberate non-restatement was the RIGHT call for the wrong reason.  Not restating
    avoided a third false statement on this row; the reason given ("the carrier is missing") was
    itself false, and the correct reason was available on the same page of `main.tex` that defines
    `J_{q,k}` — X is a predicate, three lines above the map.

  row 26 `lem:frame-connectivity` — attacked this arc and **STATED for the first time**:
    `adjBlock_connected` below.  Two findings.  (a) The statement needs **no new vocabulary** —
    `Necessity.AdjBlock` plus `Relation.ReflTransGen`, exactly the shape `adjAxis_connected` already
    uses — so the row's residue was never "unstatable", only unwritten.  (b) The INGREDIENT absence is
    re-verified this arc and holds twice over: `Givens|jacobiRot|blockRotation` over
    `RadicalRelativity/` returns one hit and it is the prose sentence recording the gap, and `Givens`
    over Mathlib returns zero hits.  So this is a standalone contribution, not an assembly.
    ★ **The toolchain stamp on that second half read "Mathlib v4.28.0" and is dropped 2026-08-22**,
    because the tree moved to v4.33.0 and a version number frozen into an evidence line makes the
    line unfalsifiable at the version anyone will actually check.  Re-run at the current toolchain is
    recorded in the ABSENCE CLAIMS block below: 0 files of 8311 in Mathlib v4.33.0, 1 file of 171 in
    the tree.
    ★★ **A NAME COLLISION THAT WILL LOOK LIKE A FALSE ABSENCE CLAIM, so it is disarmed here (dry-pass
    round 4, 2026-08-10).**  `RadicalRelativity/Necessity/BlockRotation.lean` EXISTS.  A reader who
    greps the residue's own phrasing ("rank-two block rotations") will find it and conclude this
    absence claim is the eleventh false one.  It is not: that file is about `chiEntryCLM` /
    `chiEntry_is_rotation` — the rotation **acting on** a Peirce coherence block, i.e. the image of the
    χ-map — and says nothing about **factorizing a unitary INTO** rank-two block rotations, which is
    what connectivity needs.  Read the declaration list, not the filename.
    ★ Recording this is the point of the dry pass: the absence claim survived, but only because someone
    checked what the colliding file contains.  The claim as first written invited the refutation.

  row 29 gap (b) — attacked in ARC-8 and **RESTATED NON-VACUOUSLY** (the previous
    `n2_necessity_theta_level : True` was replaced by the Θ-level conclusion itself, using
    `Necessity.theta`, `Necessity.blockHerm` and `Necessity.n2FrameTwist`), then **DISCHARGED
    IN-TREE 2026-08-22** and removed from this file.  ★ The finding recorded here held: there was no
    vocabulary wall, the sentence was simply never written — the same failure mode this directory
    already retracted at row 18 — and the discharge needed no object that did not exist on 08-10.
    ★ Worth keeping as the one place this directory's pricing was confirmed rather than corrected:
    "GATE: none; priced as ordinary work" was accurate, and the work was ordinary.

  row 31 `thm:qubit-boundary` — attacked this arc, and clause (ii) is now CLOSED as predicted:
    `RankTwo.n2SequentialProduct RankTwo.tauModuliRP2` supplies S1, S3–S7 *and* S2 for the article's
    own τ, because row 30 closed for an arbitrary `t`.  ★ And a defect this file could not have known
    about was found and fixed: clause (iii) existed only in the **entry-level `Fdiag` encoding**, which
    no theorem identified with `HermitianMat.twistSeq` — so rows 30 and 31 were about two unlinked
    objects.  Now linked (`RankTwo.not_forall_effects_tau_eq_twistSeq`, at the effects).
    ★★★ **THE RESIDUE LINE THAT STOOD HERE IS STALE ON BOTH ITEMS, 2026-08-22.**  It read "Residue:
    the unimodular cocycle subcases, and clause (iii) in the article's stronger `(Φ,t)`-conjugation
    form."  (a) Clause (iii) IS proved in that stronger form:
    `RankTwo.not_exists_jordanAuto_const_twist` (`RankTwo/Sufficiency.lean:1680`) — no pair (Φ, t)
    with Φ a surjective Jordan-multiplicative linear map and t constant reproduces the τ family on
    effects — axiom-clean, with `exists_jordanAuto_const_twist_of_twistSeq` certifying the
    existential it negates is inhabited.  (b) The unimodular cocycle subcases belong to **row 30**,
    not this row: they are Step 6 of `prop:n2-sufficiency`'s proof, closing at `main.tex:1718`,
    immediately before `thm:qubit-boundary` starts at `main.tex:1719`.
    ★ So this row's residue is neither of the two things named here.  It is the one item in the
    per-row entry above: clause (i)'s coherence-action half.

  row 36 clause (i) — ★★★ **ROW CLOSED IN-TREE 2026-08-22; THIS BLOCK IS REWRITTEN, AND THREE OF ITS
    FOUR CLAIMS DID NOT SURVIVE.**  It read: the dry pass found `Necessity.theta_conj_exchange` (vdW
    5.7(1), not the frame-atom exchange automorphism) as a near-miss; the clause was DELIBERATELY NOT
    RESTATED; the obvious restatement — exchange as conjugation by a permutation matrix — "would be
    INERT FOR A SECOND TIME, because conjugation commutes with the twist product"; and "so the
    article's clause (i) must involve an anti-linear ingredient, as clause (iii)'s transpose did".
    (a) The near-miss finding STANDS: `theta_conj_exchange` is still vdW 5.7(1) and still not this.
    (b) The inertness diagnosis of permutation conjugation STANDS, and is now the sharpest thing in
        this entry — it is why `exists_peirce_exchange` could never have closed the row.
    (c) **The anti-linear prediction is FALSE.**  `Necessity.selector_peirceExchange` closes clause
        (i) with no anti-linear ingredient anywhere: the hypothesis compares the block action at `r`
        with the block action at `r ∘ Equiv.swap i j` on the *same* block element, and the proof
        reads off that the block phase is its own inverse and applies
        `Globalization.real_character_unique`.  It is the same three-line shape as clauses (ii) and
        (iii).  The prediction was an inference from clause (iii)'s transpose to a clause that does
        not work like clause (iii).
    (d) **"Needs `main.tex`'s definition of Peirce exchange at source" was exactly right, and is the
        instruction that closed the row.**  Reading `main.tex:1990-1994` is what showed the object
        this file had built was the relabelling the article explicitly excludes.
    ★ So the file's standing rule — a row broken once by a plausible guess does not get a second
    guess — held, and the thing that replaced the guess was the article's own sentence, not more
    Lean.

PRIOR (ARC-7) ATTACK EVIDENCE, provenance only:

  Row 36 clause (iii) was attacked and CLOSED today.  Row 29 gap (a) was attacked and closed in
  ARC-6.  Rows 15, 22, 26, 29(b), 31 were NOT attempted in ARC-6 or ARC-7.  ★★ Row 22 WAS probed on
  2026-08-09, and the probe refuted this file's own pricing of it rather than advancing the row: the
  unrestricted statement written here was false.  That is the useful outcome — a certificate whose
  statement is wrong sends the next person to prove a false thing, which is worse than a vague price.
  Recorded because "ABSENT" on this project has three times meant "nobody looked", and this time
  looking produced a retraction instead of a proof.
  ★ **This sentence read "the statement written here to avoid the missing carrier is false" until
  2026-08-22.**  The clause "to avoid the missing carrier" smuggled the wrong diagnosis into a line
  whose subject was the counterexample; it is cut, and the diagnosis is retracted in row 22's entry
  above.  Row 22 is PARTIAL as of 2026-08-22, and rows 29(b) and 36(i) have since closed, so the
  "NOT attempted" sentence is provenance about ARC-6/7 only and must not be read as current.

ABSENCE CLAIMS AND THEIR SCOPE
  * "no Givens/Jacobi factorization of unitaries into rank-two block rotations":
      ★ **THE RECORDED GREP RESULT WAS WRONG TWICE** (found 2026-08-09 by the certificate-refutation
      review): `Givens` DOES hit `Necessity/FrameConstancy.lean:1925`, and `blockRotation` is
      case-sensitive so it missed `Necessity/BlockRotation.lean` entirely.  **The PRICE nevertheless
      survives**, checked at source: `BlockRotation.lean` is about the block *character* being a
      rotation (`chiEntryCLM`, `chiEntry_is_rotation`), not a factorization of unitaries.  **Fix the
      grep, keep the price** — and note that a case-sensitive pattern is exactly how the quaternionic
      certificate's absence claim went false on the same day.
      ★ **RE-RUN AT THE CURRENT TOOLCHAIN, 2026-08-22** (the recorded scope said v4.28.0; this tree
      is on v4.33.0).  Tree, at 22:54 EDT: `grep -rn 'Givens\|jacobiRot\|blockRotation'
      RadicalRelativity/` → **1 file of 171**, and it is the prose sentence recording the gap
      (`Necessity/FrameConstancy.lean:2584`).  Mathlib: case-insensitive `givens` → **0 files of
      8311** at v4.33.0.  The price stands, now with a denominator on both halves.  ★ The 171 is a
      moving number — it was 167 ninety minutes earlier the same evening — so re-run the grep rather
      than reading the denominator off this line.
  * "no complex structure on a cross-coherence space":
      ★★★ **THIS PRICE IS DEAD, 2026-08-22, and the entry's own hedge is what makes the failure
      legible.**  It read: "RECORDED GREP RESULT WAS WRONG: `crossCoherence_single_scalar` appears at
      `MasterTheorem/Globalization.lean:43,193,205`.  The price survives — those are U(1)-character
      statements, not a complex structure **on a carrier** — but the recorded result did not."
      `Necessity.orientationJ` (`Necessity/ComplexRowUnconditional.lean:880`) is the article's
      real-linear `𝒥_{q,k}`, `Necessity.IsCrossCoherent` (:915) is the article's X, and
      `orientationJ_sq` (:1006) is `𝒥² = −id` on X — axiom-clean.  ★ The three words "on a carrier"
      are the whole defect: the price was rescued by narrowing the claim to an object the article
      never asks for, and the narrowed claim was then true and useless.  **A price that survives only
      after a qualifier is added to it should be re-derived, not re-worded.**
  * "no Peirce exchange automorphism":
      ★★★ **REFUTED BY ITS OWN RECORDED PATTERN, 2026-08-22.**  The claim was
      `grep -rn 'peirceExchange\|exchangeAuto\|PeirceExchange' RadicalRelativity/` → no hits
      (2026-08-09).  Re-run at HEAD: **15 hits**, all in
      `Necessity/ComplexRowUnconditional.lean` — `PeirceExchangeCovariant` (:594),
      `selector_peirceExchange` (:608), `selector_peirceExchange_luders` (:657),
      `luders_peirceExchangeCovariant` (:667), `peirceExchangeCovariant_forces_zero` (:683).
      ★ And the claim was mis-aimed as well as stale: clause (i) never needed an *automorphism*.
      What follows is kept because it is still true and still useful — two adjacent things exist and
      neither is the object, and nobody should rebuild the mechanism:
      - `MasterTheorem/RankTwo.lean:488` `n2_exchange_selects_luders` — **exchange covariance forces
        Lueders at RANK TWO, at generator level** (`rem:n2-selection`, the paper's Remark 6.2).  So the
        MECHANISM of clause (i) is already machine-checked in the rank-two case: swap-invariance of the
        angle plus its antisymmetry in `r_0 - r_1` kills the twist.  ★ It does NOT move row 36:
        `rem:n2-selection` is one of the SEVEN EXCLUDED REMARKS of the denominator (main.tex:1550), and
        clause (i) is about `H_N(C)` with `N >= 3` and Peirce exchange, not rank two.
      - `Necessity/ThetaCocycle.lean:139` `theta_conj_exchange` — vdW 5.7(1), a DIFFERENT "exchange"
        (Theta_b commuting with Lueders conjugation at a commuting base point), not an atom swap.
    ★★ **THE SENTENCE THAT CLOSED THIS BULLET WAS HALF RIGHT AND IS REPLACED.**  It read: "So clause
    (i) still needs the Peirce exchange automorphism WITH its coherence-block action; what it does
    not need is a new idea about why exchange covariance kills the twist."  The second half held
    exactly — `selector_peirceExchange`'s mechanism is the `H_N(ℂ)` version of
    `n2_exchange_selects_luders`'s, swap-invariance of the block phase against its antisymmetry in
    `r_i − r_j`, with `real_character_unique` doing the `2π` bookkeeping.  The first half named the
    wrong object: what the clause needed was the coherence-block action alone
    (`twistSeq_diagFamily_blockHerm`), with no automorphism attached to it.

NOT imported from RadicalRelativity/.
-/
import RadicalRelativity.Necessity.FrameConstancy

set_option linter.style.longLine false

namespace WallCertificate

open scoped Matrix
open ComplexOrder OrderUnitSpace

/-! ### Row 22 `lem:orientation` — two false statements, and the wrong explanation for both

The article's clauses are about `J` restricted to the cross-coherence space `X`, and stating them
without that restriction produced a false proposition **twice** (both retractions are below).  ★
This section header used to continue "`X` is not a carrier in this tree", and that is wrong:
`main.tex:1176` defines `X` as a *predicate*, `Necessity.IsCrossCoherent` is it verbatim, and the
row is PARTIAL on the article's own clauses as of 2026-08-22.  What survives here is the pair of
counterexamples and the reason the restriction is not optional — the tree's own
`Necessity.orientationJ_sq` carries the same hypothesis for the same reason. -/

/-- ★★ **THIS CERTIFICATE'S FIRST VERSION STATED A FALSE PROPOSITION, and it is corrected here
rather than quietly replaced.**

The first version asserted the *unrestricted* pointwise form `∀ x, J (J x) = -x`, on the reasoning
that the cross-coherence subspace is the object the tree lacks, so the statement should be made
about all `x` instead.  **That is false, with a compiled witness**: for orthogonal frame
projections `frameProj 0 * frameProj 1 = 0` (checked in Lean), so at `x = q` the inner product
`q·x·p` vanishes, giving `J q = 0` and hence `J (J q) = 0`, while `-q ≠ 0`.  `J` squares to `−1`
**only on the coherence space**, which is exactly why the article states it there.

A certificate that states a gap *incorrectly* is worse than one that states it vaguely, because
someone will try to prove a false thing.  This is the failure mode this arc's certificate-refutation
brief asked reviewers to hunt for, and the first instance was mine.

★★★ **THE PARAGRAPH THAT USED TO CLOSE THIS DOCSTRING IS ITSELF RETRACTED (2026-08-22), AND IT IS
THE THIRD ERROR ON THIS ONE STATEMENT.**  It read: "So the honest content of row 22 is the opposite
of what this file first claimed.  It said the row 'needs nothing the tree lacks' and was 'the row to
attack first'.  Wrong: it needs the cross-coherence space as a *carrier*, which the tree does not
have — the same missing vocabulary as `W_n` in row 29 and the Peirce subalgebra in row 5."
`main.tex:1176` defines `X = {x : q ∘ x = ½x = p_k ∘ x}`, a predicate; nothing in the lemma quantifies
over `X` as a type.  The tree now carries it as `Necessity.IsCrossCoherent` and proves clauses (i)
and (ii) at the article's generality.  **`W_n` in row 29 went the same way** — it is
`IsCrossCoherent` too, and row 29 is FORMALIZED — so the "same missing vocabulary" inference was
wrong twice in one sentence.
★ **What the first version got right, and it is why the retraction was worth writing:** the
unrestricted statement is FALSE, and the fix is to carry the subspace condition as a *hypothesis*.
That is exactly what the theorem below does, and exactly what `Necessity.orientationJ_sq` does. -/
theorem orientation_isHermitian {N : ℕ} (q p x : HermitianMat (Fin N) ℂ) :
    (Complex.I • (q.mat * x.mat * p.mat)
      - Complex.I • (q.mat * x.mat * p.mat)ᴴ).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul, Matrix.conjTranspose_smul,
    Matrix.conjTranspose_conjTranspose]
  simp only [Complex.star_def, Complex.conj_I]
  module

theorem orientation_complex_structure {N : ℕ}
    (q p : HermitianMat (Fin N) ℂ)
    (hqp : q.mat * p.mat = 0) (hq : q.mat * q.mat = q.mat) (hp : p.mat * p.mat = p.mat)
    (J : HermitianMat (Fin N) ℂ → HermitianMat (Fin N) ℂ)
    (hJ : ∀ x, J x = ⟨Complex.I • (q.mat * x.mat * p.mat)
      - Complex.I • (q.mat * x.mat * p.mat)ᴴ, orientation_isHermitian q p x⟩) :
    ∀ x, q.mat * x.mat * p.mat + (q.mat * x.mat * p.mat)ᴴ = x.mat → J (J x) = -x := by
  intro x hx
  have hpq : p.mat * q.mat = 0 := by
    have h := congrArg Matrix.conjTranspose hqp
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_zero, q.H, p.H] at h
    exact h
  have hJx : (J x).mat = Complex.I • (q.mat * x.mat * p.mat)
      - Complex.I • (q.mat * x.mat * p.mat)ᴴ := by rw [hJ]; rfl
  have hwh : (q.mat * x.mat * p.mat)ᴴ = p.mat * x.mat * q.mat := by
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, q.H, p.H, x.H, Matrix.mul_assoc]
  have h1 : q.mat * (q.mat * x.mat * p.mat) * p.mat = q.mat * x.mat * p.mat := by
    calc q.mat * (q.mat * x.mat * p.mat) * p.mat
        = (q.mat * q.mat) * x.mat * (p.mat * p.mat) := by noncomm_ring
      _ = q.mat * x.mat * p.mat := by rw [hq, hp]
  have h2 : q.mat * (p.mat * x.mat * q.mat) * p.mat = 0 := by
    calc q.mat * (p.mat * x.mat * q.mat) * p.mat
        = (q.mat * p.mat) * x.mat * (q.mat * p.mat) := by noncomm_ring
      _ = 0 := by rw [hqp, Matrix.zero_mul, Matrix.zero_mul]
  ext1
  have hmk : (J (J x)).mat = Complex.I • (q.mat * (J x).mat * p.mat)
      - Complex.I • (q.mat * (J x).mat * p.mat)ᴴ := by rw [hJ]; rfl
  rw [hmk, HermitianMat.mat_neg, ← hx, hJx, hwh]
  rw [show q.mat * (Complex.I • (q.mat * x.mat * p.mat)
        - Complex.I • (p.mat * x.mat * q.mat)) * p.mat
      = Complex.I • (q.mat * (q.mat * x.mat * p.mat) * p.mat)
        - Complex.I • (q.mat * (p.mat * x.mat * q.mat) * p.mat) from by
    simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul]]
  rw [h1, h2, smul_zero, sub_zero, Matrix.conjTranspose_smul, hwh]
  simp only [Complex.star_def, Complex.conj_I, smul_smul, Complex.I_mul_I, neg_smul, one_smul,
    neg_neg, sub_neg_eq_add]
  match_scalars <;> simp [Complex.I_sq]

/-! ★★★ **SECOND RETRACTION ON THIS STATEMENT, 2026-08-10, from the certificate-refutation review —
THE CORRECTED VERSION WAS ALSO FALSE, and the reviewer compiled the counterexample at the article's own
rank `N = 3`.**  With `q p` arbitrary Hermitian and no orthogonality or idempotency, take `q = 𝟙` and
`p = (1/2)•𝟙`: then `q x p = x/2` is Hermitian, so the coherence hypothesis
`q x p + (q x p)ᴴ = x` holds for **every** `x`, while `J ≡ 0`, so `J (J x) = 0 ≠ −x`.
  ★ **FIXED ABOVE** by hypothesizing that `q` and `p` are orthogonal idempotents (`q p = 0`, `q² = q`,
  `p² = p`) — which is what "frame projections" means and what the first version's prose said while its
  Lean did not.  **Fifth false gap statement in this directory, second on this row.**
  ★★ **AND A SEPARATE HYGIENE DEFECT, also fixed above: the previous version had `by sorry` INSIDE the
  statement** (the `IsHermitian` side condition), so the declaration was not fully written down and
  could not be attacked as stated — the identical defect `prop-n2-sufficiency.lean` found and repaired
  in ITSELF on 2026-08-09, surviving one file over.  The side condition is now the proved lemma
  `orientation_isHermitian`, so this file's `sorry` count equals its gap count.
  ★ The pattern across both retractions on this row: **the prose knew `q, p` were frame projections
  both times; the Lean never said so.** A hypothesis stated only in a docstring is not a hypothesis. -/

/-- The compiled witness behind the FIRST retraction: distinct frame projections annihilate, so the
unrestricted form fails at `x = q`. -/
theorem frameProj_mul_orthogonal_eq_zero :
    (Necessity.frameProj (0 : Fin 3)).mat * (Necessity.frameProj (1 : Fin 3)).mat = 0 := by
  rw [Necessity.frameProj_mat_eq_single, Necessity.frameProj_mat_eq_single]
  ext i j
  simp only [Matrix.mul_apply, Matrix.single, Matrix.of_apply]
  refine Finset.sum_eq_zero fun x _ => ?_
  split_ifs with h1 h2
  · exact absurd (h1.2.trans h2.1.symm) (by decide)
  all_goals simp

/-! ### Row 29 gap (b) — DISCHARGED IN-TREE 2026-08-22; the gap statement is removed from this file

★★★ **`Necessity.n2_theta_block_rotation` (`Necessity/ComplexRowUnconditional.lean:789`) is this
file's `n2_necessity_theta_level`, proved.**  Same hypotheses, same conclusion, and its own docstring
says so ("Row 29 gap (b), discharged.  The wall certificate's `n2_necessity_theta_level` …").
Lean-core axiom-clean, verified by `#print axioms` on 2026-08-22.  The manifest row is FORMALIZED on
the strictly stronger `Necessity.n2_theta_eq_rotation`, which states the conclusion in the article's
own `cos φ · id + sin φ · 𝒥_n` form with `𝒥_n = Necessity.orientationJ` — so rows 22 and 29 are one
encoding, not two.

★ The route this file predicted is the route that worked, step for step: `seqLeftMul` pinned
everywhere by `linearMap_eq_of_eq_on_effects` (necessary — a nonzero block element is never an
effect), `theta = quadRepInv ∘ seqLeftMul`, and the modulus cancelling against `Q_{√a}⁻¹` to leave
the pure phase.

**The gap statement that stood here, and its two retractions, are kept below as prose.** They are
the only record of the FOURTH false gap statement in this directory, and the test that caught it is
reusable.

**GAP — row 29's Θ-level form, RESTATED NON-VACUOUSLY (2026-08-10, ARC-8 block 8.6).**

★★★ The previous version of this gap was `theorem n2_necessity_theta_level : True`, flagged in this
same file as VACUOUS: provable in one token, moving nothing.  That flag was right, and leaving the
placeholder in place was the wrong call — a reader discharges it and the row does not move.  It is
replaced here by a statement with content.

The article's `prop:n2-necessity` concludes about `Θ_a` restricted to the coherence space `W_n`:
`Θ_a|_{W_n} = exp(ℓ · t̃(n) · 𝒥_n)` with `ℓ = log(λ₊/λ₋)`.  Lean's in-tree form
(`Necessity.n2_sp_eq_twistSeq_frame`) is the PRODUCT-level identity.  The equivalence is the route,
not a theorem — and the honest way to say that is to state the Θ-level conclusion itself.

★ **No missing vocabulary, and that is the point.**  `Necessity.theta` is the comparison map,
`Necessity.blockHerm i j z` is the coherence block, and `Necessity.n2FrameTwist` is `t̃`.  So the
Θ-level conclusion IS statable with what the tree has — which means the previous `True` placeholder
was not recording a vocabulary wall, it was recording that nobody had written the sentence.  Compare
the identical, already-retracted mistake at row 18 in `differential-trio.lean`.

GATE: none.  This is ordinary work: relate `theta` to `seqLeftMul`/`quadRep` on the block and read off
the phase.  It is priced as such rather than as a wall.

★★★ **SELF-CAUGHT, BEFORE ANYONE ATTACKED IT: THE FIRST VERSION OF THIS STATEMENT WAS FALSE.**  It
applied `theta` to the STANDARD block `blockHerm 0 1 z` while taking `a = Ad_U(diagFamily r)`.  But the
article's `W_n` is the coherence space of **a's own frame**, which is `Ad_U(blockHerm 0 1 z)`; for
general `U` the standard block is not in it, and `Θ_a` off `W_n` has no reason to be a rotation.  So the
first version mixed a `U`-conjugated base point with an unconjugated block — a FALSE gap, and the
FOURTH in this directory.
  ★ **The transferable bit is what caught it:** not a counterexample search, but asking "which frame is
this object indexed by?" of every object in the statement.  Two of the three were indexed by `U` and one
was not.  A gap statement that mixes frame indices is the specific shape to look for here, and it is the
same shape as the retracted `frame_param_eq_of_compatible` (which mixed "U commutes with a" and "U
diagonalizes a").
  ★ Route, unchanged by the fix: `Necessity.seqLeftMul` agrees with `HermitianMat.conjLinear ℝ
(twistFactor a t)` on effects, hence everywhere by `OrderUnitSpace.linearMap_eq_of_eq_on_effects`
(row 5's order-unit half, in-tree); `theta = quadRepInv ∘ seqLeftMul`; then
`Necessity.adU_conj_twistSeq` reduces the general `U` to `U = 1`, where it is an entry computation via
`Necessity.twistSeq_diagFamily_entry`.

★ **Statement removed 2026-08-22.**  It was
`n2_necessity_theta_level (P) (hS2) {a} (ha) (hbd) (U) {r} (hr) (hU : a = adU U (diagFamily r)) (z)`
concluding `theta P ha hbd (adU U (blockHerm 0 1 z)) = adU U (blockHerm 0 1 (exp(i·t̃(U)·(r 0 − r 1))·z))`,
which is `Necessity.n2_theta_block_rotation` verbatim.  Keeping a `sorry` for a theorem the tree
proves would have made this file's `sorry` count stop meaning what its header says it means. -/

/-- **GAP — row 26 `lem:frame-connectivity`, STATED for the first time (2026-08-10, ARC-8 8.6).**

Until now this row's residue lived only in prose ("needs a Givens/Jacobi factorization").  ★ The
statement needs **no new vocabulary either**: `Necessity.AdjBlock` is the article's adjacency and
`Relation.ReflTransGen` is the connectivity the tree already uses for `AdjAxis`
(`Necessity.adjAxis_connected`).  So this is the article's graph-connectivity claim, written down.

★ Keep the two standing corrections attached to it: `AdjBlock` is **strictly finer** than `AdjAxis`,
so this does NOT follow from `adjAxis_connected`; and the claim that `AdjBlock` is a *superset* of the
article's relation is FALSE and must never be repeated.

GATE: none — but the ingredient is absent from the tree **and from Mathlib**, re-verified at the
current toolchain 2026-08-22: case-insensitive `givens` over Mathlib v4.33.0 → **0 files of 8311**,
and `Givens|jacobiRot|blockRotation` over `RadicalRelativity/` → **1 file of 171** at 22:54 EDT, the
prose sentence at `Necessity/FrameConstancy.lean:2584` recording this gap.  So this is a standalone
contribution rather than an assembly. -/
theorem adjBlock_connected {N : ℕ} (hN : 3 ≤ N) (F G : Matrix.unitaryGroup (Fin N) ℂ) :
    Relation.ReflTransGen (MasterTheorem.Globalization.SymmStep (Necessity.AdjBlock (N := N))) F G := by
  sorry

/-! ### Row 36 clause (i) — CLOSED IN-TREE 2026-08-22; the gap statement is removed from this file

★★★ **`Necessity.selector_peirceExchange` (`Necessity/ComplexRowUnconditional.lean:608`) closes the
clause**, against `Necessity.PeirceExchangeCovariant` (:594), with non-vacuity pinned from both
sides — `luders_peirceExchangeCovariant` (the class is inhabited) and
`peirceExchangeCovariant_forces_zero` (no other member of the twist family is in it).  All
Lean-core axiom-clean, `#print axioms` 2026-08-22.  The hypothesis is imposed on the *standard*
frame's blocks only, which is a WEAKER antecedent than the article's every-frame condition, so the
theorem implies `cor:selectors`(i) by restriction rather than being a special case of it.

★★★ **THE GAP STATEMENT REMOVED FROM HERE WAS ABOUT THE WRONG OBJECT, AND ITS OWN DOCSTRING HAD
ALREADY SAID HALF OF THAT.**  It was

  `exists_peirce_exchange {N} (hN : 3 ≤ N) (i j : Fin N) (hij : i ≠ j) :`
  `  ∃ Φ : H_N(ℂ) →ₗ[ℝ] H_N(ℂ), (∀ x y, x ≤ y ↔ Φ x ≤ Φ y) ∧ Φ 1 = 1 ∧ Φ (frameProj i) = frameProj j`

— an order isomorphism relabelling two frame atoms.  `main.tex:1990-1994` (read at blob 4b0dba30)
defines Peirce exchange covariance as `E(x,y) = E(y,x)` on a coherence block **with the block's
complex structure `𝒥` held fixed**, and says in the same sentence that this is "the fixed-orientation
condition of `rem:n2-selection`, **not a relabelling of `p_i, p_j`**".  The removed statement was
precisely the excluded relabelling.

The original docstring's findings, kept because the diagnosis was right and the inference from it
was not:
  * **VACUOUS — refuted 2026-08-09** by a reviewer who DISCHARGED it: conjugation by the permutation
    matrix of `Equiv.swap i j` satisfies it, and the compiled discharge returned **both** `hN` and
    `hij` as `unused variable` lints.  A statement that does not need `i ≠ j` cannot be capturing
    "swaps two frame atoms and acts on the coherence blocks accordingly".
  * The paired lesson stands: **a gap statement has to be strong enough that proving it would close
    the row, and the cheapest test is the inert-hypothesis test applied to the GAP rather than to the
    theorem.**
  * ★★ **What did NOT follow, and this is the correction:** the docstring's instruction was to
    "restate it with the coherence-block action as an explicit conclusion (its effect on
    `blockEmbedLm`/`cornerJ2`)" — i.e. to keep the automorphism and strengthen it.  Two inert
    hypotheses were evidence the *object* was wrong, not merely that the statement was weak.  The
    coherence-block action is the whole hypothesis, and it appears in the closing theorem as
    `twistSeq_diagFamily_blockHerm`'s block coefficient `√(xy)·exp(i·t·log(x/y))` — the article's
    own displayed `E(x,y)`, exhibited rather than assumed.  No `Φ` occurs anywhere in the proof. -/

end WallCertificate
