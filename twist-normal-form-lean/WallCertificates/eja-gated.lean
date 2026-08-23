/-
EJA-GATED CERTIFICATE — rows 13 and 16 of STATEMENT-MANIFEST.md
  (rows 5, 6, 15 were claimed here on 2026-08-10 and are WITHDRAWN the same day — see the
   WITHDRAWAL block below; ★★★ **row 17 is WITHDRAWN 2026-08-22** — this file's own per-row line
   has said since 2026-08-10 that it "should be read as WALL-CERTIFIED, not EJA-GATED", and
   `STATEMENT-MANIFEST.md` carried it as EJA-GATED anyway, a live contradiction at HEAD for twelve
   days.  Resolved in this file's favour; see the row-17 line for the three non-EJA residues that
   settle it.)
Date: 2026-08-10, ARC-8 block 8.6.  Tag at issue: `paperA-arc8-cp4` and later.
Denominator pin: main.tex blob 205fdf5a **as of the date above**.
  ★★★ **"(never re-pinned)" DELETED 2026-08-22 — IT WAS FALSE.**  `STATEMENT-MANIFEST.md` re-pinned
  the denominator to blob `4b0dba30` on 2026-08-22 after the manuscript was brought to JMP form.
  Nothing about this certificate moves on it: the re-pin verified that the 36-row extraction and the
  full `\label{...}` set are byte-identical between the two blobs, so no row was added, dropped or
  renumbered.  What did change is the *line numbers*: every `main.tex` line cited at blob `205fdf5a`
  is **+2** at blob `4b0dba30` (+3 from row 36 onward).  Line references added below are at the NEW
  blob and say so.  ★ Other certificates in this directory carry `205fdf5a` as a dated record of
  what they were written against, which is correct and is left alone; the defect was asserting that
  the pin had never moved.

★★★ STATUS 2026-08-23: THIS FILE HAS NO `sorry`.  ALL THREE GATES ARE PROVED THEOREMS.
  (E1) via `EJA/Spectral.lean` (2026-08-22), (E2) via `EJA/InterfaceInstance.lean` (2026-08-20),
  (E3) via `EJA/OrderAuto.lean` (2026-08-23), which proves Koecher / Alfsen–Shultz at
  finite-dimensional formally-real generality.
  ★★★ **AND NO ROW MOVED ON ANY OF THE THREE.**  That is the fact this file exists to keep visible.
  A gate is an INGREDIENT; the rows that cite it need something built ON the ingredient.  Row 13
  needs the spectral *inverse*, not the spectral *resolution*.  Rows 16 and 17 were never gated on
  (E3) at all — row 16 does not consume `Theta_jordan`, row 17 is WALL-CERTIFIED, not EJA-GATED.
  Row 14 has three clauses and (E3) is one of them; its terminal state is EXTERNAL by
  pre-registration, which no discharge here touches.
  ★ So the per-row lines below, and not the gate statuses, are what a reader should audit.  A reader
  who converts "all three gates proved" into "the rows are FORMALIZED" has made exactly the error
  this file exists to prevent, and has now made it in a new way: the gates going green is precisely
  the evidence that the gates were not the binding constraint.

WHAT THIS FILE IS, AND WHAT IT IS NOT

  The ARC-8 ORDERS define a terminal state EJA-GATED: a row whose ENTIRE remaining residue is the
  EJA axiomatization gap, evidenced by a compiling certificate that (a) confirms every non-EJA clause
  is closed in-tree, and (b) states the article-generality statement in Lean with `sorry` exactly at
  the axiomatization gap, NAMING which ingredient gates it.
  ★ As of 2026-08-23 this file no longer instantiates (b) with a `sorry`, because all three named
  ingredients are proved.  The terminal state EJA-GATED is unaffected: it is defined by what a row's
  residue IS, and rows 13 and 16 still have theirs.  See the status block above.

  This file does (b) honestly by stating the three GATES THEMSELVES, once each, rather than restating
  six rows six ways.  That is deliberate and it is the more falsifiable choice: if a gate is wrong,
  it is wrong in one place, and every row that leans on it moves together.

  ★ WHAT THIS FILE DOES NOT DO, stated first so it cannot be misread: it does NOT prove any of the
  rows at the article's generality.  A reader who converts "EJA-GATED" into "FORMALIZED" has made the
  error this file exists to prevent.
  ★★★ **"and it does NOT prove the gates" DELETED FROM THE LINE ABOVE, 2026-08-22 — it was false for
  (E2) from 2026-08-20 and is now false for (E1) as well.**  Two of the three gates below are proved
  theorems: (E2) via `EJA/InterfaceInstance.lean`, (E1) via `EJA/Spectral.lean`.  (E3) alone is still
  a `sorry`.  **No row moves on either discharge**, and the reason is the same in both cases: a gate
  is an INGREDIENT, and the rows that cite it need something built ON the ingredient.  Row 13 needs
  the spectral *inverse*, not the spectral *resolution* — see its line below.
  ★★★ **"(E3) alone is still a `sorry`" IS FALSE FROM 2026-08-23** — `EJA/OrderAuto.lean` proves it.
  The sentence is left standing rather than edited because the paragraph is a dated record of the
  08-22 correction, and because the clause after it is the one that matters and is unchanged: **no
  row moved on the third discharge either**, for the same reason as the first two.
  ★★ CORRECTED 2026-08-10: an earlier version of this paragraph said "discharging a gate below would
  make the corresponding `ComparisonSetup` FIELD derivable".  That is true only of (E3).  (E1) and
  (E2) correspond to **no field at all** — they are ingredients the fields are built from, and (E2)
  produces the three `CoalescenceSetup` FK fields rather than a `ComparisonSetup` one.  A tidy
  three-way parallel was asserted where the structure has none.

THE MISSING PREMISES, EXACTLY

  `MasterTheorem/Interface.lean`'s own docstring says `ComparisonSetup` "does not encode the
  JB-algebra premises (the Jordan identity, formal reality, the cone-of-squares reading of
  `nonneg`)".  `JBPremises` below is those three, and nothing else.  Every gate is stated as: from
  `ComparisonSetup` PLUS `JBPremises`, derive a fact the structure currently carries as a field.

THE THREE GATES (the names used throughout, and in EJA-DIVIDEND.md)

  (E1) JORDAN SPECTRAL THEOREM at f.d. formally-real generality — spectral resolution into a Jordan
       frame with real eigenvalues, and the functional calculus on it.
  (E2) PEIRCE DECOMPOSITION for a Jordan frame, with the Faraut–Korányi multiplication rules.
  (E3) `Theta_jordan` DERIVABLE — van Imhoff–Roelands: a unital order isomorphism of the cone
       preserves the Jordan product.

  ★★ (E3) AND THE STATUS ARITHMETIC — **CLAIM WEAKENED 2026-08-10 after the refutation review.**
  I had written: (E3) *is* `prop:theta` at vIR generality (row 14, pre-registered external), therefore
  rows 16/17 "terminate at EJA-GATED behind a named citation and NOT at FORMALIZED, no matter how much
  axiomatization work is done."  **That inference does not follow from the gate as stated.**
  `gate_E3_theta_jordan` assumes `Φ : J ≃ₗ[ℝ] J` — **linear** — so it is the classical
  unital-linear-order-isomorphism theorem (Koecher / Alfsen–Shultz 2.80), which `Interface.lean`
  itself cites as "classical corroboration" and which the tree already discharges concretely
  (`KadisonDischarge` / `RealKadison`).  vIR's external delta is the JB-algebra-generality version.
  Rows 16/17's article statements live on a f.d. **simple EJA**, where the classical linear fact is
  what is needed — so a Mathlib-grade f.d. EJA layer containing Koecher/AS-2.80 could discharge this
  gate in-tree, and rows 16/17 could then reach FORMALIZED.
  ★ Honest status: (E3) as stated is **not** obviously external, the load-bearing sentence of this
  file's first version was overstated, and whether rows 16/17 can reach FORMALIZED is **OPEN** pending
  a decision about which theorem row 14 actually reserves.
  ★★★ **THAT QUESTION IS SETTLED, 2026-08-22 — AND IT MOVED NO ROW.  Both halves matter and they
  point opposite ways, so read them together.**
    * **SETTLED: (E3) as stated is Koecher / Alfsen–Shultz, not vIR.**  Verified at source.
      `gate_E3_theta_jordan` below takes `Φ : J ≃ₗ[ℝ] J`, which is **linear by TYPE, not by
      hypothesis** — there is no linearity premise to drop, because the linearity is in the arrow.
      The interface makes the same commitment: `ComparisonSetup.Θ : J → (J ≃ₗ[ℝ] J)`
      (`MasterTheorem/Interface.lean:264`), so `Θ_a`'s linearity is the field's *type* rather than
      anything the field concludes.  The article does the same thing in prose: `prop:theta`'s proof
      (`main.tex:775-789`, blob `4b0dba30`) gets "a **unital linear order isomorphism** `Θ_a`" out of
      vdW Prop 5.3 FIRST, and only then upgrades it to a Jordan automorphism.  So the theorem this
      gate reserves is the classical unital-linear one, and a Mathlib-grade f.d. EJA layer containing
      Koecher / AS 2.80 **would** discharge it in-tree.  vIR's genuine delta — order isomorphisms not
      assumed linear, at JB-algebra generality — is strictly stronger than anything this gate asks
      for.
    * **AND IT UNLOCKS NEITHER ROW 16 NOR ROW 17.**  The 2026-08-10 hope recorded above was that
      discharging (E3) in-tree would let rows 16/17 reach FORMALIZED.  ★★★ **(E3) WAS discharged
      in-tree on 2026-08-23, and the hope was wrong: neither row moved.**  It could not, for reasons that
      have nothing to do with which theorem (E3) is: row 16 does not *consume* `Theta_jordan` at all
      (see its per-row line below), row 17 is not EJA-gated at all (see its line), and neither row's
      binding constraint is any of the three gates (see `EJA-DIVIDEND.md`'s 2026-08-22 retraction of
      the CLOSES column).  ★ **The pattern is worth keeping: a crux question can be answered cleanly
      and still be the wrong question.**  Ten days of this file's prose turned on "which theorem does
      (E3) reserve", and the answer changed no row, because the rows were never gated on (E3).
  ★ A citation inconsistency found in the same pass and **RESOLVED 2026-08-20**: `external-rows.md`
  named the row-14 source "van Ittersum–Reijnders" while `Interface.lean` and this file name it "van
  Imhoff–Roelands" (arXiv:1904.09278).  Checked against the arXiv metadata record for 1904.09278:
  "Order isomorphisms between cones of JB-algebras", **Hendrik van Imhoff and Mark Roelands**.
  `external-rows.md` was the lone outlier and is corrected; "van Ittersum–Reijnders" is not a paper.
  ★ Why it survived ten days of rewrites: both spellings abbreviate to "vIR", so every grep for the
  abbreviation matched both and no grep for either full name was ever run across the whole repo.

★★★ WITHDRAWAL — ROWS 5, 6 AND 15 ARE **NOT** EJA-GATED (2026-08-10, certificate-refutation review)

  EJA-GATED requires that EVERY non-EJA clause be closed in-tree first.  For three of the six rows I
  claimed, that is false, and in each case the manifest's own cell said so:

    row 5  `lem:span` — the **ball clause** ("the effects contain the ½-ball about ½·e") is open, and
      the manifest records why: it "needs the norm to *be* the order-unit norm".  That is an
      order-unit-norm fact, **not** the EJA axiomatization.  ★ My per-row line below asserted the
      ½-ball clause was CLOSED; `OrderUnitSpace.span_isEffect_eq_top` proves *spanning* from
      order-unit boundedness WITHOUT the ball, which is what I mistook for it.
    row 6  `lem:homog` — clause (ii) is **already proved at abstract order-unit generality** as
      `SequentialProductOn.sp_smul_left` (S1–S7 + S2 + `IsArchimedean`), and the manifest cell says
      outright that this "covers the article's statement, whose ambient `J` is an EJA and hence an
      order unit space".  I cited `HermitianMat.twistSeq_smul_left` instead — a theorem about **one
      specific product**, the constant-parameter twist — and then assigned the row to gate (E1), the
      Jordan spectral theorem, on the strength of that misreading.  Clause (i)'s abstract port needs
      the order-unit route, not spectral theory.  ★ **Read the statement, not the name** — the two
      differ by exactly "for an arbitrary S1–S7 product" versus "for the twist product".
    row 15 `lem:frame-fix` — the article's statement includes "**and lies in Stab(F)°**", which needs
      the stabilizer as a group with an identity component.  Two other certificates in this directory
      already record that vocabulary as absent, and it is **not** the EJA axiomatization.  My
      move-out note silently narrowed the residue to "the Peirce-block clauses".

  ★★ **The shape of the error, since it is one error made three times: I classified each row by its
  BIGGEST residue and let that stand for its WHOLE residue.**  EJA-GATED is a claim about the
  complement — that nothing else remains — and a claim about a complement cannot be checked by looking
  at the largest item in it.  This is the same failure as row 35's "and that is the whole residue",
  which the same review process caught two days earlier.
  ★ Rows 5, 6, 15 revert to WALL-CERTIFIED with this arc's attack evidence, and their non-EJA residues
  are now named in the manifest.

PER-ROW: WHICH GATE, AND WHAT IS ALREADY CLOSED IN-TREE (rows 13 and 16; the FOUR withdrawn rows'
lines — 5, 6 and 15 on 2026-08-10, and 17 on 2026-08-22 — are retained below with their defects
marked, because the retraction is the content)

  row 5  [WITHDRAWN — see above; the ball clause is open and is NOT an EJA gap] `lem:span` — the order-unit half (effects contain the ½-ball about ½e, hence span, hence
                           linear maps agreeing on effects are equal) is CLOSED in-tree on the
                           concrete carrier.  The residue is the SECOND half: `[0,q]` spans the Peirce
                           subalgebra `J₂(q)`.  GATE (E2) — ★ now DISCHARGED, see below; the row
                           stays WITHDRAWN on its own non-EJA ball clause.
                           ★★ **AND "GATE (E2)" NEVER NAMED THIS RESIDUE — corrected 2026-08-22.**
                           A spanning statement about `[0,q]` and `J₂(q)` is not among the gate's
                           three conjuncts (`aOf_scalarOn`, `block_mem_J2`, `simDiag_opCommute`), so
                           "now DISCHARGED" discharges something this row does not ask for.  No
                           status arithmetic moves — the row is WITHDRAWN on the ball clause either
                           way — but a reader tallying residues against the gate mis-tallies.
  row 6  [WITHDRAWN — see above; clause (ii) is already abstract, and the cited theorem was the wrong one] `lem:homog` — clause (i) (additive + order bounded ⟹ unique positive linear extension)
                           is `Necessity.seqLeftMul` in-tree; clause (ii) `(λa)·b = λ(a·b)` is in-tree
                           on the concrete carrier (ARC-8: `HermitianMat.twistSeq_smul_left`, obtained
                           from the constant-parameter S5 at a scalar left factor).  Residue = both at
                           EJA generality.  GATE (E1).
  row 13 `prop:pseudo-transfer` — proved in-tree on the concrete carrier in NORMALIZED form
                           (`Necessity/PseudoInverse.lean`).  Residue = the spectral inverse at EJA
                           generality.  GATE (E1) — ★ **the RESOLUTION half of (E1) is now
                           DISCHARGED (2026-08-22, see below); this row does NOT move, because its
                           residue was never the resolution.**  What has changed is that the residue
                           is now a NAMED, SMALLER object — invert the eigenvalues of an existing
                           resolution — rather than the whole spectral theorem.
                           ★★★ **THE REASON GIVEN HERE WAS WRONG, CORRECTED 2026-08-22.**  This line
                           read "A spectral inverse is a functional calculus on the resolution, and
                           no functional calculus is built."  A **polynomial** functional calculus at
                           EJA generality IS built: `RadicalRelativity.EJA.jeval`
                           (`EJA/Spectral.lean:98`), `jeval x : ℝ[X] →ₗ[ℝ] J`, with its
                           multiplication rule `jeval_mul` (`:128`).  And the spectral inverse over a
                           finite spectrum is a polynomial — interpolate `λ ↦ λ⁻²` at the eigenvalues
                           — so it needs no *general* calculus.  What is actually absent is narrower:
                           no declaration evaluates a polynomial ON a resolution (`jeval x p =
                           ∑ᵢ λᵢ p(λᵢ) qᵢ` is not in the tree), and no declaration produces an
                           inverse.  **The row does not move, and this correction does not resize its
                           residue either — the 08-22 (E1) discharge above did that.  What was false
                           was only the stated reason.**  ★ The reason it survived: it rested on
                           a grep of the EJA declaration list for `calculus|cfc|sqrt|inverse`, which
                           returns 0 hits and is *accurate* — `jeval` contains none of the four
                           strings.  Standing rule, a further time: **an accurate grep is evidence
                           about a string, not evidence of absence.**
  row 15 [WITHDRAWN — see above; the `Stab(F)°` clause is non-EJA and open] `lem:frame-fix` — the non-EJA content is closed in-tree.  Residue = the Peirce-block
                           statements (Θ_r preserves each block; L_{a(r)} is block-diagonal).
                           GATE (E2) — ★ now DISCHARGED, see below; the row stays WITHDRAWN on its
                           own non-EJA `Stab(F)°` clause.
                           ★★ **SAME CORRECTION AS ROW 5, 2026-08-22**: "Θ_r preserves each block"
                           and "L_{a(r)} is block-diagonal" are not among the gate's three conjuncts
                           either, so the discharge does not reach this residue.  Row stays
                           WITHDRAWN on the `Stab(F)°` clause regardless; the mis-tally is the
                           correction.  ★ Two rows, one habit: **"GATE (Ek)" was written as a label
                           for "the EJA-ish part", not as a claim that the gate's conjuncts cover the
                           residue** — and once the gate became a theorem, the label started paying
                           out discharges to rows it had never covered.
  row 16 `lem:coalescence` — ★ BOTH CLAUSES ARE ALREADY PROVED AT THE INTERFACE'S OWN ABSTRACT
                           GENERALITY (`MasterTheorem.CoalescenceSetup.coalescence_J2q` and
                           `coalescence_block`), and instantiated on the concrete carrier.  There is
                           NO missing mathematics.
                           ★★★ **"Residue = that `Theta_jordan` is CARRIED, plus `Theta_fix`.  GATE
                           (E3) ALONE" IS FALSE IN BOTH HALVES — CORRECTED 2026-08-22.**
                           (a) **`Theta_jordan` is consumed by NEITHER clause.**  `coalescence_J2q`'s
                           entire proof term is `C.Θ_fix a ha b (C.simDiag_opCommute i j a b hsc hb)`
                           (`MasterTheorem/Coalescence.lean:140-142`), and `coalescence_block` is its
                           `r i = r j` specialization through `aOf_inv` / `aOf_scalarOn` /
                           `block_mem_J2` (`:148-151`).  The article agrees: at `main.tex:963-964`
                           (blob `4b0dba30`) `lem:coalescence`'s proof invokes `prop:theta`'s
                           **fixing** clause — "so \Cref{prop:theta} gives Θ_a(b) = b" — and then
                           `lem:span`, and never its Jordan-automorphism clause.  `Θ_jordan` touches
                           this row only as a `ComparisonSetup` field that any *instance* must supply
                           (concretely the hypothesis `ThetaPreservesJordan`,
                           `Necessity/ComparisonInstance.lean:381`).  That is a cost of the bundle,
                           not a residue of this row's mathematics.
                           (b) **`Theta_fix` is not (E3).**  (E3) is `Theta_jordan`, and nothing else.
                           `Θ_fix` is vdW **Prop 5.5 in span-extended form** (`Interface.lean:284-290`,
                           whose own docstring says Prop 5.5 is stated at the effect level and "the
                           paper extends it to all of `J` by linearity (effects span `J`)").  That
                           extension is `lem:span` — **manifest row 5**, the row WITHDRAWN from
                           EJA-GATED in the block above precisely because its residue is non-EJA.
                           ★★★ **This is the FOURTH instance of the error the WITHDRAWAL block above
                           documents three times: classify a row by its LARGEST residue and let that
                           stand for the WHOLE residue.**  Here it ran in both directions at once —
                           the item named as the residue (`Theta_jordan`) is not a residue of this row
                           at all, and the item that is (`Theta_fix`) was filed under a gate it does
                           not belong to.  Naming the biggest thing you can see is not the same act as
                           checking the complement, and this file exists to make that distinction.
                           ★ `EJA/InterfaceInstance.lean:54-55` has recorded the true thing since it
                           was written — "Row 16 rests on `Θ_fix` as much as on the FK three" — and
                           this certificate contradicted it at HEAD until today.
                           ★★ **CONSEQUENCE DELIBERATELY LEFT OPEN.**  EJA-GATED requires every
                           non-EJA clause to be closed in-tree first, and `Θ_fix`'s span extension is
                           a non-EJA import.  On the WITHDRAWAL block's own test row 16's EJA-GATED
                           label is therefore in question.  It is NOT changed here: this pass was
                           scoped to the stated reason, and moving a terminal state is a campaign
                           decision.  Recorded so that it gets decided rather than inherited.
                           ★ (E2) IS still DISCHARGED (see below: `gate_E2_peirce` is a proved
                           theorem, from `EJA/InterfaceInstance.lean`'s `EJAComparison` fields
                           `aOfScalar'` / `blockMem'` / `simDiag'`) — that half of the 2026-08-20
                           update stands; only "(E3) ALONE" falls.  ★★ **But read the gate's
                           2026-08-22 "WHAT IS STILL NOT BUILT" paragraph before leaning on that
                           discharge for THIS row**: the gate's existentially-bound `J2`/`ScalarOn`
                           make its conclusion equivalent to a Peirce-free sentence, so it certifies
                           clause (1) of this row and **not** clause (2), `coalescence_J2q` — the
                           clause the complex globalization actually consumes.  The strong statement
                           is proved in `InterfaceInstance.lean`; it is the certificate that is
                           weak.  ★ (This line said "via `toCoalescenceSetup`" until 2026-08-22 — a
                           misattribution copied from the gate's own docstring rather than from the
                           proof term.  Copying a citation is not checking it.)
  row 17 `lem:homomorphism` — the hyperplane clause closed in ARC-6.  GATE (E3) alone, as row 16.
                           ★ **BUT ROW 17 IS NOT WHOLLY EJA-GATED and its listing here overstates**:
                           `DiagonalHomSetup`'s `ρ`, `ρ_skew`, `dχAdd`, `dχAdd_cont` and
                           `coalescence_diff` are the ANALYTIC step (the differential of the
                           character), not Faraut–Korányi algebra, so no EJA axiomatization produces
                           them — `dχAdd_cont` is a continuity hypothesis.  This is verbatim the
                           mis-classification that withdrew rows 5, 6 and 15 above: classifying a row
                           by its BIGGEST residue and letting that stand for its WHOLE residue.
                           Row 17 should be read as WALL-CERTIFIED, not EJA-GATED.
                           ★★★ **AND IT NOW IS — CONTRADICTION RESOLVED 2026-08-22, IN THIS FILE'S
                           FAVOUR.**  `STATEMENT-MANIFEST.md` carried row 17 in terminal state
                           EJA-GATED from 2026-08-10 while this line said it should not be: a live
                           contradiction at HEAD, in two of the campaign's own decision instruments,
                           for twelve days.  The manifest is corrected rather than this file, because
                           the residue is checkable and it is non-EJA on **three independent counts**,
                           none of which is (E1), (E2) or (E3):
                             * `DiagonalHomSetup` (`MasterTheorem/DiagonalHom.lean:180-193`) carries
                               `ρ`, `ρ_skew`, `dχAdd`, `dχAdd_cont` and `coalescence_diff` as FIELDS,
                               and their own docstrings call them "interface data; the paper's
                               analytic differentiation of `χ̃`, not constructed here" and "a cited
                               hypothesis".  No Jordan axiomatization produces an analytic
                               differential or a continuity hypothesis;
                             * the article's statement includes "`→ Stab(F)^∘`", which needs the
                               stabilizer as a group with an identity component — vocabulary two
                               other certificates in this directory already record as absent
                               (`frame-geometry.lean:17`, `differential-trio.lean:161`), and the
                               same non-EJA clause that withdrew row 15.  ★ Precision, since one of
                               those two prices it: `differential-trio.lean:161` calls this residue
                               **packaging** rather than missing mathematics (`torusU_block` has the
                               content; the quotient by the global phase is stated nowhere).  That
                               makes it cheap.  It does not make it EJA;
                             * `Θ_r` is the comparison map of the *unknown sequential product*, and
                               the order-unit/effect layer that product lives on is supplied by no
                               gate — see `EJA-DIVIDEND.md`'s 2026-08-22 retraction and the
                               measurement behind it.  ★ That measurement is dated and is being
                               falsified on purpose (`EJA/Order.lean`, in progress the same day);
                               re-run it before quoting it.  The first two counts above do not
                               depend on it.
                           Row 17 is **WALL-CERTIFIED**, its evidence is
                           `WallCertificates/differential-trio.lean` (which covers rows 16, 17, 18
                           with zero gaps), and EJA-GATED now stands for rows **13 and 16**.

  ★ Note what the shape of this list means.  Four of the six rows have their mathematics done
  somewhere; what they lack is that the ARTICLE'S hypothesis class is not expressible.  That is a
  real gap against the standing bar ("FORMALIZED at the article's own generality, no located
  hypothesis") and it is NOT a gap in anyone's understanding of the mathematics.  A prose price for
  these rows that said "needs the Jordan spectral theorem" would be true and would hide that.

ABSENCE CLAIMS AND THEIR SCOPE
  * "no JB-algebra premises are encoded anywhere in the tree":
      grep -rn 'JordanIdentity\|jordan_identity\|FormallyReal\|formally_real\|coneOfSquares\|cone_of_squares' RadicalRelativity/
      -> no hits (whole first-party tree incl. Vendor/, 2026-08-10).
      ★★★ **FALSE AS OF 2026-08-12, STRUCK 2026-08-20.**  The same pattern now returns hits across
      `EJA/FormallyReal.lean`, `EJA/Subalgebra.lean` and `EJA/Witness.lean`, including
      `class IsFormallyReal` and an instance of it for `HermitianMat`.  Beyond the string, the concept
      is present AND instantiated: `EJA/InterfaceInstance.lean`'s `EJAComparison` carries the Jordan
      identity and the frame equations as fields, and `EJA/ConcreteInstance.lean` builds one on
      `H_N(ℂ)`.  What remains absent is not the premises but the spectral theory built on them (gate
      (E1), step 4).  ★ This is the failure `prop-n2-sufficiency.lean` records: when a row moves, the
      certificate's ABSENCE CLAIMS are the part most likely to survive stale, because the header gets
      rewritten and the evidence block does not.  It survived an edit to this very file on 08-13.
  * "no Jordan spectral theorem or Peirce decomposition at abstract generality":
      ★ SELF-CORRECTED on the same day, before this file was committed.  My first wording said the FK
      facts "appear ONLY as `CoalescenceSetup` fields", and that is WRONG: they are also DISCHARGED at
      the concrete carrier in `Necessity/CoalescenceInstanceGen.lean:306-309`
      (`simDiag_opCommute := …`, `aOf_scalarOn := …`, `block_mem_J2 := …`).  The accurate claim is:
      the three FK facts are **proved concretely and CARRIED abstractly** — each is documented in
      `MasterTheorem/Coalescence.lean` as "entering as a cited FK field" at the interface's
      generality.  So (E2) is not missing mathematics on `H_n(𝕜)`; it is missing at EJA generality.
      Read at source 2026-08-10.
      ★ Worth naming why the first version was wrong: "appears only as a field" was an inference from
      where I FIRST saw the identifier, not from the declaration list of every file that mentions it.
      The project's standing first move exists for exactly this, and I skipped it inside my own
      certificate.
  * ~~"Mathlib has no EJA/Jordan layer"~~ — ★★★ **HALF FALSE, SPLIT AND RE-VERIFIED 2026-08-22
      against Mathlib v4.33.0, the version this tree actually builds against.**  The claim was
      flagged here as "consistent with the 2026-07-19 landscape scout, NOT re-verified" — the flag
      was honest and the claim was still wrong, because it was two claims wearing one sentence.
      **THE JORDAN HALF IS FALSE.**  `Mathlib/Algebra/Jordan/Basic.lean` (244 lines, 12 top-level
      declarations) supplies the classes `IsJordan` (:82) and `IsCommJordan` (:90), three instances
      and seven lemmas including `commute_lmul_rmul` and
      `two_nsmul_lie_lmul_lmul_add_eq_lie_lmul_lmul_add`; `Mathlib/Algebra/Ring/IsFormallyReal.lean`
      supplies formal reality.  **And this tree does not merely coexist with them — it imports and
      uses them**: `IsCommJordan` is an instance binder in `EJA/Pattern.lean:49`, `EJA/Frame.lean:97`
      and `EJA/Order.lean`, discharged concretely at `EJA/ConcreteInstance.lean:84` via
      `IsCommJordan.lmul_comm_rmul_rmul`; `IsFormallyReal` is a binder in `EJA/Spectral.lean:216`
      and is instantiated by `EJA/Spectral.lean:556`.  So Mathlib's Jordan layer is load-bearing in
      this development, in files this certificate's own gate statements import.
      **THE EJA HALF SURVIVES**, with a denominator: `grep -rl 'EuclideanJordan\|JordanFrame'` over
      Mathlib v4.33.0 → **0 files of 8311**.  There is no Euclidean Jordan algebra, no Jordan frame,
      no Peirce decomposition and no Jordan spectral theory upstream, which is what gates (E1) and
      (E2) are about.
      ★★ **The defect was in the SCOPE WORD, not the evidence.**  "EJA/Jordan" collapsed a true
      absence (EJA) and a false one (Jordan) into a single unverifiable phrase, and the flag
      "NOT re-verified" then protected both halves equally.  ★ It was also contradicted from inside
      this directory: `WallCertificates/eja-order.lean` — last written 19 minutes after this file, on
      2026-08-22 — records the `RadicalRelativity.EJA` order layer built directly on the Mathlib
      classes this sentence said were absent.  **A neighbouring certificate is not a place a stale
      claim can hide.**

NOT imported from RadicalRelativity/.
-/
import RadicalRelativity.MasterTheorem.Coalescence
import RadicalRelativity.EJA.InterfaceInstance
import RadicalRelativity.EJA.Spectral
import RadicalRelativity.EJA.OrderAuto

set_option linter.style.longLine false

namespace WallCertificate

open MasterTheorem

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]

/-! ### The three missing premises -/

/-- **The JB-algebra premises `ComparisonSetup` does not encode.**  Exactly the three its own
docstring names, over an existing `ComparisonSetup`, so the gates below can be stated as "from these,
derive what the structure carries". -/
structure JBPremises (C : ComparisonSetup J) : Prop where
  /-- The Jordan identity `(x∘y)∘(x∘x) = x∘(y∘(x∘x))`. -/
  jordan_identity : ∀ x y : J,
    C.jordan (C.jordan x y) (C.jordan x x) = C.jordan x (C.jordan y (C.jordan x x))
  /-- Formal reality: a sum of squares vanishes only if each term does. -/
  formally_real : ∀ (m : ℕ) (f : Fin m → J),
    (∑ i, C.jordan (f i) (f i)) = 0 → ∀ i, f i = 0
  /-- The cone-of-squares reading of `nonneg`. -/
  nonneg_iff_squares : ∀ x : J,
    C.nonneg x ↔ ∃ (m : ℕ) (f : Fin m → J), x = ∑ i, C.jordan (f i) (f i)

/-! ### GATE (E1) — the Jordan spectral theorem — ★ NO LONGER A GATE (2026-08-22)

Gates row 13 (row 6 was WITHDRAWN above).  Stated as the existence of a spectral resolution in a Jordan frame with real
eigenvalues, which is what a functional calculus (hence `aOf`'s inverse and the positive extension of
`L_a`) is built from.

★★★ **It is now a theorem, proved below from `EJA/Spectral.lean`.**  Read the sentence above
carefully before drawing a consequence from that: the gate statement is what a functional calculus is
BUILT FROM, and the functional calculus is what row 13 needs.  The row's residue is unchanged in
kind and smaller in size; it has not moved. -/

/-- **FORMERLY GATE (E1), the Jordan spectral theorem; NOW A THEOREM (2026-08-22).**  Gates: row 13
`prop:pseudo-transfer` at EJA generality.  (Row 6 was WITHDRAWN above; the header naming it survived
the withdrawal until 2026-08-20.)

★★★ **PROVED, and the two claims below about its cost were both wrong.**  `EJA/Spectral.lean` proves
the single-element spectral theorem at the EJA layer's typeclass generality and
`RadicalRelativity.EJA.spectral_resolution_bilinear` carries it across to this vocabulary through
`EJA/Bridge.lean`.  The crossing is the case `Bridge.lean`'s own docstring describes as possible —
the statement below is expressible with `C.jordan` alone, so no ring instance has to exist before it
elaborates.

★ (formerly:) "This is the large piece and it has no Mathlib support.  Its natural home is upstream
of this paper (a Mathlib-grade EJA layer), not inside `RadicalRelativity`."  The second half stands
as an opinion about where the mathematics BELONGS.  The first half was a price, and it was wrong by
roughly an order of magnitude in the same direction as ARC-9's earlier mispricings: the whole route
is 528 lines of Lean in 24 declarations, and its largest single component is Lagrange
interpolation bookkeeping.

★★ **WHAT IS STILL NOT BUILT, and what a reader must not conclude.**  `EJA-DIVIDEND.md` scopes (E1)
as "spectral resolution into a Jordan frame with real eigenvalues, AND the functional calculus on
it".  Two parts of that phrase are NOT discharged by the theorem below and are not built anywhere:

  * **the functional calculus for an arbitrary `f : ℝ → ℝ`** — nothing maps such an `f` to
    `∑ f(λᵢ) qᵢ` and proves it a homomorphism.  ★★ **Read that scope literally, corrected
    2026-08-22.**  The *polynomial* calculus exists at this generality — `jeval x : ℝ[X] →ₗ[ℝ] J`
    (`EJA/Spectral.lean:98`) with `jeval_mul` (`:128`) — and row 13's spectral inverse is a
    polynomial value, so the earlier gloss "this is what row 13's spectral inverse needs" was false.
    What row 13 needs, exactly, is the evaluation identity `jeval x p = ∑ᵢ λᵢ p(λᵢ) qᵢ` on a
    resolution plus the interpolation that inverts the eigenvalues.  Neither is written; neither is
    the general calculus.
  * **primitivity** — a Jordan *frame* is a complete orthogonal family of PRIMITIVE idempotents.
    The `qᵢ` below are orthogonal, complete and have real coefficients; they are NOT shown
    primitive, and for a repeated eigenvalue they are not.

  The statement below never claimed either, so nothing here is retracted.  But "GATE (E1) is
  discharged" and "(E1) is done" are different sentences, and only the first is true.

★★★ **`[FiniteDimensional ℝ J]` ADDED 2026-08-10 after the certificate-refutation review, and without
it this gate was FALSE.**  `ComparisonSetup` requires only `NormedAddCommGroup` +
`InnerProductSpace ℝ`, so `J = ℝ[X]` with polynomial multiplication as `jordan`, `Θ = id`, and
`nonneg` the sums of squares satisfies every `ComparisonSetup` field AND all three `JBPremises` — yet
`ℝ[X]` is a domain, so its only idempotents are `0` and `1`, `∑ q i = e` forces all but one to vanish,
and `x = X` has no spectral resolution.  So as first written the gate could never be discharged by
anyone.  ★ The lesson is narrow and worth keeping: **an "at the article's generality" statement must
carry the article's STANDING hypotheses too, not only its premises.**  f.d. is standing for EJAs and I
transcribed only the three premises the interface docstring lists.
★ 2026-08-22: the discharge below **uses** that hypothesis — `EJA/Subalgebra.lean`'s
`exists_jpow_relation` is where finite dimension enters, as the statement that the powers of `x`
cannot be independent — so the counterexample above is excluded exactly where it should be. -/
theorem gate_E1_spectral [FiniteDimensional ℝ J] (C : ComparisonSetup J) (H : JBPremises C)
    (x : J) :
    ∃ (m : ℕ) (q : Fin m → J) (lam : Fin m → ℝ),
      (∀ i, C.jordan (q i) (q i) = q i) ∧
      (∀ i j, i ≠ j → C.jordan (q i) (q j) = 0) ∧
      (∑ i, q i) = C.e ∧
      x = ∑ i, lam i • q i :=
  RadicalRelativity.EJA.spectral_resolution_bilinear C.jordan C.jordan_comm H.jordan_identity
    H.formally_real C.e C.jordan_unit x

/-! ### GATE (E2) — the Peirce decomposition — ★ NO LONGER A GATE (2026-08-20)

Formerly recorded as gating rows 5 and 15 (both since WITHDRAWN on non-EJA clauses) and the FK half
of rows 16/17.  It gates nothing now: correctly stated, it is a theorem, proved below from
`EJA/InterfaceInstance.lean`.  The three `CoalescenceSetup` fields that carried Faraut–Korányi are
produced rather than carried.

★★★ **TWO SCOPE WARNINGS ON THIS HEADING, 2026-08-22 — read the theorem's "WHAT IS STILL NOT BUILT"
paragraph before quoting it.**  (a) **"the Peirce decomposition" overstates what exists**: the tree
has the decomposition at a single idempotent and a pairwise split; the frame-level `⊕_{i≤j} J_{ij}`
is not a declaration anywhere.  (b) **The theorem below certifies less than this heading suggests**:
its `J2`/`ScalarOn` are existentially bound, and the conclusion is provably equivalent to a sentence
with no Peirce vocabulary in it, so it certifies row 16's clause (1) and not clause (2).  Both are
established, not suspected. -/

/-- **FORMERLY GATE (E2) — the Peirce decomposition and its Faraut–Korányi rules; NOW A THEOREM.**

Stated as: the axiomatization **produces the three FK data** that `CoalescenceSetup` carries as fields
(`aOf_scalarOn`, `block_mem_J2`, `simDiag_opCommute`).  The first two conjuncts pin `ScalarOn` and `J2`
from below, so they cannot be cheated by `False`, and the third is the content.

★★★ **RESTATED 2026-08-10 after the certificate-refutation review, and the previous version was
FALSE — the worst defect in this arc, in the file written to prevent exactly this.**  It read
`(J2 ScalarOn : … → Prop) … (_ha : ScalarOn i j a) (_hb : J2 i j b) : OpCommute C.jordan a b` with the
two predicates as **free universally-quantified variables**.  Instantiate both at `fun _ _ _ => True`
and it says *every two elements of every JB-premised `ComparisonSetup` operator-commute*, which is
false on `H_n(𝕜)` (take `diag(1,0)` against the `(0,1)` block; the reviewer compiled this using the
tree's own `Necessity.opCommute_iff_commuteG`).  It also never used `i ≠ j`.
  ★★ **And it was SELF-DEFEATING in the exact sense this project has a test for:** discharging it as
  written would have proved that no JB-premised `ComparisonSetup` exists on the intended carriers —
  refuting the axiomatization programme the file exists to price.  Four of the six rows leaned on it.
  ★ **The transferable rule: a free predicate variable in a gap statement is an unconstrained
  hypothesis, and an unconstrained hypothesis is where vacuity and falsity both hide.**  In the field
  it was meant to reproduce, `J2`/`ScalarOn` are *fields constrained by two other fields*; dropping
  them to variables silently deleted those constraints.

★★★ **AND THE FIRST REPAIR WAS ALSO FALSE — caught by the diff audit of the repairs, hours later.
Second falsity on this one statement.**  Pinning `ScalarOn`/`J2` from below removed the vacuity and
thereby *created* a new falsity, because the existential is **antitone in its own witnesses**:
conjuncts 1 and 2 bound the predicates from below, conjunct 3 is contravariant in both, so the whole
thing is provable iff provable at the minimal choice — and **the minimal choice is built from `aOf` and
`p`, which are UNCONSTRAINED `ComparisonSetup` FIELDS.**  `Interface.lean` requires no idempotency, no
orthogonality, and no `aOf r = Σ exp(r_i) p_i`.  So take `J = H_3(ℝ)` with the genuine standard frame
but `aOf := fun _ => diag(1,1,0)`: every `ComparisonSetup` field and all three `JBPremises` hold (it is
a real EJA), conjunct 1 forces `ScalarOn 0 2 diag(1,1,0)`, conjunct 2 forces `J2 0 2 (E₀₂+E₂₀)`, and
conjunct 3 then demands an operator commutation that fails.  The reviewer machine-checked all three
tree-facing ingredients.
  ★★ **FIXED ABOVE by hypothesizing the standing facts about `p` and `aOf` — which is verbatim the
  lesson this same commit wrote down one declaration earlier for `gate_E1` ("an 'at the article's
  generality' statement must carry the article's STANDING hypotheses too") and did not apply here.**
  Writing a rule and applying it are separate acts, and the gap between them was under twenty lines.
  ★ Second consequence, also from the audit: **`[FiniteDimensional ℝ J]` is INERT in this gate** (the
  counterexample is finite-dimensional).  It was added by parallelism with `gate_E1`, where it is
  genuinely load-bearing — a hypothesis copied for symmetry rather than for need.
  ★ Note on the form of `haOf`: the article writes `a(r) = Σ e^{r_i} p_i`, and this file states instead
  that `aOf r` is a **strictly positive** combination of the frame.  Reason: `Real.exp` is not in this
  file's transitive imports, and strict positivity is exactly what blocks the counterexample (whose
  `diag(1,1,0)` is a frame combination with a **zero** coefficient).  Weaker than the article's form and
  sufficient for the purpose — recorded so nobody reads it as the article's clause verbatim.
  ★★★ **"SUFFICIENT FOR THE PURPOSE" IS WRONG — CORRECTED 2026-08-13 (ARC-9 block 9.23), and the
  instrument was an actual proof of this gate's conclusion.**  `EJA/InterfaceInstance.lean` discharges
  exactly this conclusion, and it **could not use `haOf` in this form**.  The reason is precise: the
  third conjunct `aOf_scalarOn` needs `r i = r j ⟹ aOf r` is scalar on the block, which requires the
  two block **coefficients to coincide**.  `haOf` gives some positive `c` with `aOf r = Σ c i • p i`
  and **nothing ties `c` to `r`** — so `r i = r j` yields no information about `c i` versus `c j`, and
  the conclusion does not follow.  Strict positivity blocks the *zero-coefficient* counterexample the
  note names; it does nothing about *unequal* coefficients, which is the case `aOf_scalarOn` is about.
  ★★★ **AND IT IS OUTRIGHT FALSE — THIRD FALSITY ON THIS ONE STATEMENT, established 2026-08-20.**
  The 08-13 note above stopped one step short of instantiating its own diagnosis.  The counter-model
  is one entry away from the one printed above: same `J = H_3(ℝ)`, same standard frame, but
  `aOf := fun _ => diag(1,2,3)` — **constant in `r`, with every coefficient STRICTLY POSITIVE**, so it
  satisfies `haOf` in the weak form and the strict-positivity repair does not touch it.  No
  `ComparisonSetup` field ties `aOf r` to `r` (`aOf` is constrained only by `aOf_inv`,
  `frame_opCommute` and `Θ_cocycle`), so the model is legal.  Then at `r = 0` conjunct 1 forces
  `ScalarOn 0 1 diag(1,2,3)`; `b = E₀₁+E₁₀` satisfies `IsBlockElt jordan p 0 1` (`p₀ ∘ b = p₁ ∘ b = b/2`,
  `p₂ ∘ b = 0`) so conjunct 2 forces `J2 0 1 b`; and conjunct 3 then demands `OpCommute` of the two.
  Evaluating both operator orders at `p₀`: `L_a L_b p₀ = (1/2)(a ∘ b) = 0.75 b` while
  `L_b L_a p₀ = b ∘ p₀ = 0.5 b`.  It fails.
  ★★ **The generalisable lesson, and it is the same antitonicity trap a second time:** the first repair
  constrained the *witnesses* of `aOf`'s value (strict positivity) and left its *dependence on `r`*
  free.  Conjunct 3 is contravariant in exactly that dependence.  **When the fix for a vacuous
  existential is "constrain the witnesses", check which variable the contravariant conjunct actually
  ranges over — constraining the wrong one turns vacuous into false, twice.**
  ★★★ **THE STATEMENT BELOW IS NOW THE REPAIRED ONE (`haOf` in the article's `∑ exp(r i) • p i`
  form), AND WITH THAT REPAIR THIS IS NO LONGER A GATE — IT IS A THEOREM, PROVED HERE.**  The
  hypothesis set of the repaired statement is exactly `EJAComparison`'s: `JBPremises.jordan_identity`
  supplies `jordan_id`, and `hp_idem`/`hp_orth`/`hp_sum`/`haOf` are `p_idem`/`p_orth`/`p_sum`/`aOf_eq`
  verbatim.  So `EJA/InterfaceInstance.lean`'s `toCoalescenceSetup` discharges all three conjuncts at
  the interface's own abstract generality, and the `sorry` is gone.  [★ Two corrections to this
  sentence follow immediately below: "exactly" is false, and `toCoalescenceSetup` is the wrong
  declaration.]
  ★★★ **"EXACTLY `EJAComparison`'s" IS FALSE — IT IS A STRICT SUPERSET, AND THE DIFFERENCE MIS-PRICES
  THE AXIOMATIZATION.  Machine-checked 2026-08-22.**  `structure EJAComparison` requires `jordan_id`,
  `p_idem`, `p_orth`, `aOf_eq`, `p_sum` and NOTHING ELSE — no finite dimension, no formal reality, no
  cone of squares.  The statement below carries three hypotheses on top of those: `[FiniteDimensional
  ℝ J]`, `JBPremises.formally_real` and `JBPremises.nonneg_iff_squares`.  **All three are inert.**  The
  identical proof term elaborates with all three deleted, keeping only the Jordan identity — checked
  by elaborating it, `#print axioms` giving `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.
  ★★ **The consequence is a pricing fact, not a bookkeeping one: (E2) needs the JORDAN IDENTITY ALONE.**
  Two of the three JB-algebra premises this file was built to introduce are not required for it.
  `EJA-DIVIDEND.md`'s ARC-9 header already knew this ("(E2) at a given idempotent needs the Jordan
  identity and the invertibility of `2`; nothing else"); the gate statement never caught up, and
  `[FiniteDimensional ℝ J]`'s own inertness note sits two paragraphs above this sentence,
  contradicting it.  ★ Same defect kind as the `[FiniteDimensional ℝ J]` note itself records: **a
  hypothesis copied for symmetry rather than for need** — and then a claim of exactness written over
  the copy without elaborating it once.
  ★ **Nit in the same sentence, and it propagated:** the proof does **not** go through
  `toCoalescenceSetup`.  It applies `E.aOfScalar'`, `E.blockMem'` and `E.simDiag'` directly (read the
  `exact` below).  `toCoalescenceSetup` is a *different* declaration that bundles those same three
  fields into a `CoalescenceSetup`; naming it here reads as though the gate needed the bundle.
  ★ **Scope of that nit, checked against the diff rather than asserted (2026-08-22):** it lives in
  this file only, twice — here and in the row-16 line above, where the 2026-08-22 correction pass
  carried it forward while rewriting the sentence around it.  **`STATEMENT-MANIFEST.md` and
  `EJA-DIVIDEND.md` are NOT sites of it**: their `toCoalescenceSetup` mentions are about
  `EJAComparison` producing a `CoalescenceSetup` on `H_N(ℂ)`, which is exactly what that declaration
  does.  ★★ The first draft of this correction said the misattribution had reached the manifest too;
  `git show` on the pass's own commit shows it had not.  **A correction that names extra victims is
  still a false claim, and it is the kind that gets believed** — the reader has no reason to re-check
  a self-accusation.
  ★ **CONSEQUENCE FOR THE ROWS, propagated below: (E2) is DISCHARGED and rows 16/17 are gated by (E3)
  ALONE.**  `STATEMENT-MANIFEST.md` already said this on 08-13; this file did not, and the two
  contradicted each other at HEAD for a week — in the file that teaches "fix the row, not just the
  footnote."
  ★★★ **HALF OF THAT CONSEQUENCE IS WITHDRAWN 2026-08-22.**  "(E2) is DISCHARGED" stands.  "rows
  16/17 are gated by (E3) ALONE" is false: row 16 never consumed `Theta_jordan`, and row 17 is not
  EJA-GATED — see both per-row lines above.  ★ Note the shape of the propagation error.  The
  correction of 08-20 was real, it was applied in the right file, and it carried a *second* clause
  that had never been checked; the reconciliation of a contradiction is a good place to smuggle one
  in, because the reader's attention is on the half being fixed.
  ★ And the stated *reason* for the weakening no longer holds: `Real.exp` is available —
  `EJA/InterfaceInstance.lean` imports `Mathlib.Analysis.SpecialFunctions.Exp` and uses exactly that
  form.  **A hypothesis weakened for an import-convenience reason, with the weakening's cost
  mis-assessed in the same sentence that recorded it.**

★★★ **WHAT IS STILL NOT BUILT, AND WHAT A READER MUST NOT CONCLUDE (added 2026-08-22).**  `gate_E1`
below carries a paragraph of exactly this shape, separating "the gate is discharged" from "(E1) is
done".  (E2) had none, and needs the identical one — more urgently, because (E2) is the gate whose
*statement* is weaker than its name.  Nothing here retracts the theorem: it is true, sorry-free, and
its axioms are exactly `[propext, Classical.choice, Quot.sound]`.

  * **THE STATEMENT CERTIFIES LESS THAN THE PROOF PROVES, and the gap is structural.**  `J2` and
    `ScalarOn` are **existentially bound and free in the statement**.  They are pinned to real
    definitions only inside the *proof* — and the statement is what a reader audits.  Machine-checked
    2026-08-22, in both directions: the conclusion below is **equivalent** to the single sentence

      `∀ r i j b, r i = r j → IsBlockElt C.jordan C.p i j b → OpCommute C.jordan (C.aOf r) b`

    (forward by instantiating the three conjuncts; backward by taking `J2 := IsBlockElt …` and
    `ScalarOn i j a := ∃ r, r i = r j ∧ a = C.aOf r`, the minimal witnesses conjuncts 1 and 2 force).
    **That sentence contains no Peirce decomposition, no `J₂(q)`, and no scalar-on-range vocabulary at
    all.**  So this gate certifies the FK input to row 16's clause (1) — `coalescence_block` — and
    **does not certify clause (2)**, `coalescence_J2q`, which quantifies over an arbitrary `a` scalar
    on `range(q)` and an arbitrary `b ∈ J₂(q)`.
    ★★ **The strong version genuinely IS proved — in `EJA/InterfaceInstance.lean`, where `ScalarOn'`
    and `J2'` are definitions with real extensions.  The certificate under-certifies its own tree.**
    ★★★ **Transferable rule, and it is the third lesson this one statement has taught: AN EXISTENTIAL
    OVER THE PREDICATES CANNOT CERTIFY ANYTHING ABOUT THE INTENDED PREDICATES.**  The existential was
    the right repair for the original *falsity* (it removed the free universally-quantified predicate
    variables) and the wrong *shape for evidence*.  Certifying FK vocabulary requires the predicates
    **defined and universally quantified**, not guessed at existentially.  The antitonicity analysis
    twice recorded above is the same fact seen from the falsity side; this is it seen from the
    evidence side.
  * **THE FRAME-LEVEL PEIRCE DECOMPOSITION IS NOT BUILT.**  The section header calls (E2) "the Peirce
    decomposition" and `EJA-DIVIDEND.md` scopes it as `J = ⊕_{i≤j} J_{ij}` over a Jordan frame with
    the FK rules.  What the tree has is the decomposition at a **single** idempotent
    (`EJA/Peirce.lean:292`, `exists_peirce_decomposition`) and a **pairwise** split
    (`EJA/Block.lean:96`, `exists_block_split`).  The assembled direct sum over a frame is a
    declaration that does not exist — declaration lists of **every** `EJA/*.lean` file, re-swept
    2026-08-22 22:51 EDT, when `ls RadicalRelativity/EJA/*.lean | wc -l` was **19**.
    ★★★ **THE SCOPE WAS WRITTEN AS "all 15" AND IS WRONG AT EVERY MOMENT SINCE — 16 EARLIER THE SAME
    EVENING, 19 AT THE RE-SWEEP.**  `EJA/Order.lean`, then `Class.lean`, `PeirceSubalgebra.lean` and
    `Rank.lean` landed after the number was written down.  **Do not re-pin a literal count here.**
    Re-run the sweep: `grep -n '^def \|^theorem \|^structure \|^instance \|^abbrev \|^class '
    RadicalRelativity/EJA/*.lean`, which is this project's standing first move, and read the
    declaration list rather than the file count.
    ★★ **THE FINDING SURVIVES ALL THREE COUNTS, and the newest files sharpen rather than weaken it.**
    `Rank.lean:97` now declares a `JordanFrame` structure and `PeirceSubalgebra.lean` builds the
    Peirce one- and zero-subalgebras as carriers with EJA instances — so the *vocabulary* for the
    frame-level statement has arrived — while the assembled `J = ⊕_{i≤j} J_{ij}` over a frame still
    has no declaration.  What exists is the decomposition at a **single** idempotent
    (`EJA/Peirce.lean:292`), a **pairwise** split (`EJA/Block.lean:96`), and now the subalgebras and
    the frame; the sum over a frame is not among them.  Independently confirmed by
    `EJA/Pattern.lean`'s own closing note, which says the constraints proved there "say what the
    summands can be, not that every element decomposes into them" and names
    `J = ⊕_{i ≤ j} J_{ij}` as still unbuilt.
    ★ **A count inside the scope of an absence claim decays faster than the claim it scopes.**  This
    one decayed three times in one evening while its conclusion did not move once, and a reader
    checking "15" against `ls` would have had to decide unaided whether the missed files were the
    ones that mattered.  State the sweep, not the census.
    "GATE (E2) is discharged" and "(E2) is done" are different sentences, and only the first is
    true. -/
theorem gate_E2_peirce [FiniteDimensional ℝ J] (C : ComparisonSetup J) (H : JBPremises C)
    (hp_idem : ∀ i, C.jordan (C.p i) (C.p i) = C.p i)
    (hp_orth : ∀ i j, i ≠ j → C.jordan (C.p i) (C.p j) = 0)
    (hp_sum : ∑ i, C.p i = C.e)
    (haOf : ∀ r : Fin C.n → ℝ, C.aOf r = ∑ i, Real.exp (r i) • C.p i) :
    ∃ J2 ScalarOn : Fin C.n → Fin C.n → J → Prop,
      (∀ (r : Fin C.n → ℝ) (i j : Fin C.n), r i = r j → ScalarOn i j (C.aOf r)) ∧
      (∀ (i j : Fin C.n) (x : J), IsBlockElt C.jordan C.p i j x → J2 i j x) ∧
      (∀ (i j : Fin C.n) (a b : J), ScalarOn i j a → J2 i j b → OpCommute C.jordan a b) := by
  let E : RadicalRelativity.EJA.EJAComparison J :=
    { C with
      jordan_id := H.jordan_identity
      p_idem := hp_idem
      p_orth := hp_orth
      aOf_eq := haOf
      p_sum := hp_sum }
  exact ⟨E.J2', E.ScalarOn', E.aOfScalar', E.blockMem', E.simDiag'⟩

/-! ### FORMERLY GATE (E3) — `Theta_jordan` derivable — ★★★ NOW A THEOREM (2026-08-23), AND IT STILL GATES NO MANIFEST ROW

★★★ **PROVED, 2026-08-23.**  `RadicalRelativity/EJA/OrderAuto.lean` proves Koecher / Alfsen–Shultz
at finite-dimensional formally-real generality —
`RadicalRelativity.EJA.orderIso_preservesJordan` — and the declaration below is that theorem applied
to `ComparisonSetup` plus `JBPremises`.  **This file now has no `sorry`**, and all three gates
(E1)/(E2)/(E3) are proved theorems.

★★★ **AND NO ROW MOVES.  Read that literally; it is not a hedge.**  Row 13's gate is (E1), and its
residue is the spectral *inverse*, built on (E1) rather than equal to it.  Row 16 does not consume
`Theta_jordan` at all — the whole proof term of `coalescence_J2q` is `Θ_fix` composed with
`simDiag_opCommute`.  Row 17 is WALL-CERTIFIED, not EJA-GATED, and its residue is analytic and
group-theoretic.  Row 14 `prop:theta` has three clauses — the construction of `Θ_a` from the
sequential product (vdW Prop 5.3), the Jordan-automorphism upgrade, and the fixing/cocycle clauses
(vdW Props 5.5, 5.7) — and this closes **one**; its terminal state is EXTERNAL by pre-registration,
a campaign decision this discharge does not touch.

★★★ **THIS HEADER READ "Gates the other half of rows 16/17.  ★★ This is manifest row 14
`prop:theta` at van Imhoff–Roelands generality, which is PRE-REGISTERED EXTERNAL."  BOTH SENTENCES
ARE WITHDRAWN** (2026-08-22, and the withdrawal stands).  Row 16 does not consume `Theta_jordan`,
and row 17 is not EJA-GATED at all.  As for the identification with row 14: the theorem below
assumes `Φ` **linear by type**, so it is the classical Koecher / Alfsen–Shultz theorem, not vIR's
JB-generality version — settled at source 2026-08-22, see the header block.  That identification is
exactly why it was provable in-tree: vIR's version *concludes* linearity, which is a strictly
harder theorem and is not what this statement asks for.

★ **What changes, and it is a certificate-level fact rather than a census one:**
`ComparisonSetup.Θ_jordan` becomes derivable for any instance carrying `JBPremises`, so one cited
hypothesis can leave the interface bundle.  The `example` at the end of this file still shows the
field, so the theorem and the field it would replace can be read side by side. -/

/-- **FORMERLY GATE (E3), `Theta_jordan` derivable; NOW A THEOREM (2026-08-23).**  A unital *linear*
order isomorphism of the cone preserves the Jordan product.

**The statement is unchanged.**  Nothing was added to its hypotheses and nothing was weakened in its
conclusion; only the binder names moved, from `_H`/`_hunital`/`_horder` to `H`/`hunital`/`horder`,
because all three are now used.  Hypothesis by hypothesis against
`RadicalRelativity.EJA.orderIso_preservesJordan`:

* `C.jordan_comm`, `C.jordan_unit`, `H.jordan_identity`, `H.formally_real` are the four algebra
  hypotheses, in the same shapes;
* `H.nonneg_iff_squares` is **the same proposition** as `RadicalRelativity.EJA.IsSoS C.jordan`, so
  the cone rewrite is free — this is the hypothesis that would have bitten if `nonneg` had been a
  cone-membership predicate instead of the cone of squares;
* `Φ : J ≃ₗ[ℝ] J` supplies linearity **and** bijectivity, and bijectivity is genuinely spent, in
  transporting the sharpness clause through `Φ.symm`;
* ★ `horder` must stay a **biconditional**.  A one-directional `nonneg x → nonneg (Φ x)` would not
  suffice: the sharpness clause is a `∀` over the cone, and reflecting it needs the converse.

★ Unused by the proof and inert here: `C.n`, `C.rank_ge`, `C.p`, `C.Inv`, `C.aOf`, `C.aOf_inv`,
`C.Θ` and all five `Θ_*` fields.  In particular `C.Θ_jordan` is **not** smuggled back in — it could
not be, since `Φ` is an arbitrary linear equivalence and need not be any `C.Θ a`.

★★★ **"Gates: the `Theta_jordan` half of rows 16 and 17" — WITHDRAWN 2026-08-22, and the withdrawal
stands.**  It gates neither.  Row 16's two clauses never invoke `Θ_jordan`; row 17's residue is
analytic and group-theoretic.  What this discharge buys is that a `ComparisonSetup` FIELD becomes
derivable, and nothing above it. -/
theorem gate_E3_theta_jordan [FiniteDimensional ℝ J] (C : ComparisonSetup J) (H : JBPremises C)
    (Φ : J ≃ₗ[ℝ] J) (hunital : Φ C.e = C.e)
    (horder : ∀ x, C.nonneg x ↔ C.nonneg (Φ x)) (x y : J) :
    Φ (C.jordan x y) = C.jordan (Φ x) (Φ y) :=
  RadicalRelativity.EJA.orderIso_preservesJordan C.jordan C.jordan_comm H.jordan_identity
    H.formally_real C.e C.jordan_unit Φ hunital
    (fun z => ((H.nonneg_iff_squares z).symm.trans (horder z)).trans
      (H.nonneg_iff_squares (Φ z))) x y

/-! ### What is ALREADY closed, made self-evidencing

None of these is a gap.  They compile, so a reader who suspects the per-row reading above is
over-generous can check it here rather than take it on trust.
★★★ **THE SENTENCE THAT STOOD HERE — "In particular rows 16 and 17 have no missing mathematics at
the interface's own generality — which is why their residue is (E3), a citation, and not a proof" —
IS WITHDRAWN 2026-08-22.**  Its first half is true and its second half is false, which is the shape
that made it durable.  Row 16's residue is `Theta_fix` (vdW Prop 5.5 span-extended by `lem:span`,
manifest row 5), not (E3); row 17 is not EJA-GATED.  ★ **Note where the false half sat: in a summary
sentence, three hundred lines away from the per-row lines it summarised, introduced by "in
particular".**  The per-row line for row 17 had contradicted it since the day both were written. -/

/-- Row 16's SECOND clause at the interface's abstract generality — **in the tree**. -/
example (C : CoalescenceSetup J) {a b : J} {i j : Fin C.n}
    (ha : C.Inv a) (hsc : C.ScalarOn i j a) (hb : C.J2 i j b) :
    C.Θ a b = b :=
  C.coalescence_J2q ha hsc hb

/-- The gate that would make `Θ_jordan` a theorem is stated against the very field it would replace:
here is that field, so the two can be compared side by side. -/
example (C : ComparisonSetup J) (a : J) (ha : C.Inv a) (x y : J) :
    C.Θ a (C.jordan x y) = C.jordan (C.Θ a x) (C.Θ a y) :=
  C.Θ_jordan a ha x y

end WallCertificate
