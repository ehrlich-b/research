# EJA-DIVIDEND.md — what the EJA axiomatization would buy Paper A

★★★ **STATUS 2026-08-12 (ARC-9): PART OF THE AXIOMATIZATION IS NOW BUILT, and this file's dependency
graph was wrong.** `RadicalRelativity/EJA/` (9 modules) contains the Peirce decomposition, all six
Faraut–Korányi multiplication rules, orthogonal idempotent families, **Albert's power-associativity
theorem**, formal reality with no-nilpotents, and the one-generator subalgebra. Consequences for the
table below:

* **"(E2) depends on (E1)" is STRUCK.** (E2) at a given idempotent needs the Jordan identity and the
  invertibility of `2`; nothing else. (E1) is what *produces* idempotents. **The order inverts.**
* **Three of the four hypotheses under `lem:coalescence` (row 16) are now theorems** —
  `opCommute_scalarOn_frame`, `mem_J2_of_half_half`, `diagFamily_scalarOn`. Only van de Wetering's
  Prop 5.5 stays cited. ★ Only one of the three uses the Jordan identity; the other two are
  bookkeeping that becomes available once the frame equations exist.
* ★★★ **STATUS 2026-08-22: (E1)'s SPECTRAL RESOLUTION IS PROVED, and the bullet below is superseded.**
  `RadicalRelativity/EJA/Spectral.lean` proves it unit-free (`spectral_resolution`), with completeness
  under a unit hypothesis (`spectral_resolution_complete`), on `HermitianMat d 𝕜`, and in the
  interface's bilinear-map vocabulary (`spectral_resolution_bilinear`) — which discharges
  `WallCertificate.gate_E1_spectral`. **No row in the table below moves.** Two parts of (E1) as this
  file scopes it are NOT built and are what the rows actually need:
  **the functional calculus** (row 13's "spectral inverse" is `∑ μ⁻¹ P_μ`, a calculus ON the
  resolution) and **primitivity** (the families produced are complete and orthogonal, but are not
  shown to be Jordan *frames*, and at a repeated eigenvalue they are not). Read every "(E1)" below
  with those two exclusions attached. The route this file predicted was also wrong in shape — see
  `WallCertificates/eja-spectral.lean` F1–F5.
* **(E1) is certificated, not done** — `WallCertificates/eja-spectral.lean`, two of four steps built,
  and the obstruction is structural (ring theory wants a unit; this layer is unit-free).
* **No row in the table below has moved**, and the CLOSES/PARTIAL/NOTHING verdicts are unchanged. What
  changed is that the *work* those verdicts price is partly done, and that the residue for rows 16/17
  is now interface surgery on `ComparisonSetup` — which carries `p : Fin n → J` with **no axioms** —
  rather than Jordan theory.
  ★★★ **THE SECOND SENTENCE IS SUPERSEDED 2026-08-22: the verdicts are NOT unchanged. The CLOSES
  column is retracted for rows 13, 16 and 17 — the entire column — and the residue for rows 16/17 is
  not interface surgery either.** It is the absence of an order-unit/effect layer at EJA generality,
  which is not surgery on `ComparisonSetup` and is not Jordan theory. Read "The decision, on this
  evidence" at the foot of this file before using any verdict in the table. ★ Note that the sentence
  above was itself an ARC-9 correction, written to *update* this file; "the verdicts are unchanged"
  is the clause an updating pass is least likely to check, because checking it means re-deriving the
  thing the pass was not sent to look at.


**Created 2026-08-09, ARC-8 block 8.6. Required deliverable of the ARC-8 ORDERS.**
**Pin:** `STATEMENT-MANIFEST.md`'s 36 rows, main.tex blob `205fdf5a` **as of this file's creation date**.
★★★ **"(never re-pinned)" DELETED 2026-08-22 — IT WAS FALSE.** `STATEMENT-MANIFEST.md` re-pinned to
blob `4b0dba30` on 2026-08-22, after the manuscript was brought to JMP form. **Nothing in this file
moves on it**: the re-pin verified that the 36-row extraction and the full `\label{...}` set are
byte-identical between the two blobs, so no row was added, dropped or renumbered. Low stakes, and it
was still a false sentence standing in a decision instrument — in two of them, this file and
`WallCertificates/eja-gated.lean:6`, both corrected today. ★ Other certificates carry `205fdf5a` as a
dated record of what they were written against; that is correct and is left alone. The defect was the
parenthesis asserting the pin had never moved, not the blob itself.
**Status snapshot:** written against 12 FORMALIZED / 19 PARTIAL / 5 ABSENT; **refreshed 2026-08-10** to 12 FORMALIZED / **3** EJA-GATED / 16 PARTIAL / 5 ABSENT. ★★★ **BOTH HALVES OF THAT REFRESH ARE STALE, 2026-08-22.** (a) It is the taxonomy-mixing form `STATEMENT-MANIFEST.md:69` records as an error — EJA-GATED is a *terminal state*, not a status word, so it must not be subtracted out of PARTIAL. The census is and has been **12 FORMALIZED / 19 PARTIAL / 5 ABSENT**, unchanged by anything in this file. (b) **EJA-GATED now stands for two rows, 13 and 16**, row 17 having been withdrawn 2026-08-22 (and row 16's own label flagged OPEN); terminal states now read 12 FORMALIZED + 6 EXTERNAL + 2 EJA-GATED + 16 WALL-CERTIFIED = 36. ★★ **EJA-GATED was briefly claimed for six rows and withdrawn the same day for rows 5, 6 and 15** — their residues include NON-EJA clauses (row 5's ball clause needs the order-unit norm; row 6's clause (ii) is already abstract via `SequentialProductOn.sp_smul_left`; row 15's `Stab(F)°` clause needs identity-component vocabulary). **So this table's "CLOSES" column is NOT the EJA-GATED list**: CLOSES means the axiomatization would move the row, which for rows 5, 6, 15 is true of *part* of the residue only — see `WallCertificates/eja-gated.lean`, which states the three gates.

---

## What "the EJA axiomatization" means here, precisely

`RadicalRelativity/MasterTheorem/Interface.lean`'s `structure ComparisonSetup` carries the abstract
Jordan-algebra layer the master theorem runs on: a Jordan product `jordan`, a unit `e`, a rank `n`
with `rank_ge : 3 ≤ n`, a Jordan frame `p : Fin n → J`, a cone `nonneg`, `Inv`, `aOf`, and
`Theta : J → (J ≃ₗ[ℝ] J)` with `Theta_unital` / `Theta_orderIso` / `Theta_jordan`. Its own docstring
states the limitation: it **does not encode the JB-algebra premises** — the Jordan identity, formal
reality, and the cone-of-squares reading of `nonneg`.

So the axiomatization is: **encode those premises, and derive as theorems what the structure now
carries as fields.** Concretely the deliverables would be

* **(E1) a Jordan spectral theorem** at f.d. formally-real Jordan generality — spectral resolution
  into a Jordan frame with real eigenvalues, and a functional calculus on it;
* **(E2) the Peirce decomposition** `J = ⊕ J_{ij}` for a Jordan frame, with the Faraut–Korányi
  multiplication rules — currently carried as `CoalescenceSetup` fields.
  ★★★ **PARTLY BUILT, AND THE DEPENDENCY BELOW IS CORRECTED, 2026-08-12 (ARC-9 blocks 9.2/9.3).**
  The Peirce decomposition **at a single given idempotent** is in the tree
  (`RadicalRelativity/EJA/Peirce.lean`): the polynomial identity `2L_c³ − 3L_c² + L_c = 0`, the three
  projections, existence *and* uniqueness of `J = J₁(c) ⊕ J_{1/2}(c) ⊕ J₀(c)`, and the eigenvalue
  trichotomy. It needs the Jordan identity and the invertibility of `2` — no spectral theorem, no
  formal reality, no finite dimension, no unit.
  ★★ **This cell was written at block 9.3 and was stale by 9.4, in two ways, both caught on the
  re-read after the arc's own diff audit.** (a) It said "and nothing else", the same overclaim the
  audit had just fixed in two `.lean` docstrings — a third copy, in a third file. (b) It said the FK
  **multiplication rules** were "still absent": they were built at block 9.4
  (`EJA/PeirceMul.lean`, all six), together with the orthogonal-idempotent layer at 9.6/9.7.
  ★ What *is* still absent is the **frame** decomposition `⊕_{i≤j} J_{ij}` as a single statement —
  the rules and the pairwise machinery exist, the assembled direct sum over a frame does not;
* **(E3) `Theta_jordan` derivable** — van Imhoff–Roelands: an order isomorphism of the cone that is
  unital preserves the Jordan product. Currently a field, and pre-registered EXTERNAL as row 14.

**★ Scope warning that governs every line below.** (E3) is *the content of a cited external theorem*
(row 14, `prop:theta`, pre-registered external at vIR generality). Building the axiomatization does
NOT prove it; it makes it *statable* at the right generality so it can be cited or proved separately.
Rows whose only residue is (E3) therefore move from "carried as an unexaminable field" to
"EJA-GATED behind a named external theorem" — a real gain in honesty, **not** a move to FORMALIZED.
Any reading of this table that converts (E3)-dependence into FORMALIZED is wrong.

★★★ **THE WARNING ABOVE IS CORRECT AND ITS MEMBERSHIP LIST IS EMPTY — 2026-08-22. Read it as a rule
with no instances, not as a description of any row.** "Rows whose only residue is (E3)" was written
for rows 16 and 17. **Row 16 has no (E3) residue at all**: neither clause consumes `Theta_jordan`
(`coalescence_J2q`'s whole proof term is `Θ_fix` composed with `simDiag_opCommute`,
`MasterTheorem/Coalescence.lean:140-142`, and the article's own proof at `main.tex:963-964` invokes
`prop:theta`'s *fixing* clause and `lem:span`, never its Jordan-automorphism clause). **Row 17 is not
EJA-GATED at all** — its `dχAdd`/`dχAdd_cont`/`coalescence_diff` residue is analytic and its
`Stab(F)^∘` clause is group-theoretic. Full argument and sources in
`WallCertificates/eja-gated.lean`'s per-row lines.
★ Two further corrections to this paragraph's own parenthesis: the theorem `gate_E3` reserves is the
classical Koecher / Alfsen–Shultz one (`Φ` is linear **by type**), not vIR's JB-generality version;
and row 14's externality, while still pre-registered and not relitigated, is external for a different
reason than "vIR generality" — see `WallCertificates/external-rows.md`'s 2026-08-22 section.

---

## The table

Column meaning: **CLOSES** = the axiomatization would move the row to FORMALIZED.
**PARTIAL** = it removes some but not all of the residue. **NOTHING** = the residue is orthogonal.

| # | row | residue today | axiomatization would… | why |
|---|-----|---------------|------------------------|-----|
| 1 | `mthm:master` | the one-theorem form (JvNW), pre-registered external | **NOTHING** | the residue is a cited classification theorem, not the Jordan layer |
| 2 | `mthm:omnibus` | one-theorem form; external | **NOTHING** | same |
| 3 | `def:sp` | Lean *packaging* of the article's eight clauses + restriction/extension maps | **NOTHING** | pure interface work on an order-unit space; no Jordan structure enters |
| 4 | `thm:vdw1` | external (vdW) | **NOTHING** | cited theorem |
| 5 | `lem:span` | the Peirce half **and** the ball clause | **PARTIAL** | ★ **CORRECTED 2026-08-10**: the ball clause needs the norm to *be* the order-unit norm and is not an EJA gap. For the Peirce half, the statement is a Peirce-span identity, and with (E2) it becomes statable and provable where today only the concrete carrier is. ★ The first version of this cell contained a stray table-separator character, giving it 8 fields where every other row has 7, so the explanation rendered as a dropped column. Found by the diff audit by counting fields per row; and the first attempt to *record* that fact reintroduced the same defect, because the note itself named the character. |
| 6 | `lem:homog` | clause (i)'s abstract port | **PARTIAL** | ★ **CORRECTED 2026-08-10**: clause (ii) is **already proved at abstract order-unit generality** (`SequentialProductOn.sp_smul_left`, S1–S7 + S2 + `IsArchimedean`), so the earlier "(E1), a Jordan-spectral fact" was wrong — it came from citing a theorem about the *twist* product rather than an arbitrary one. Clause (i)'s port needs the order-unit route (`span_isEffect_eq_top`), not spectral theory |
| 8 | `lem:simple-bridge` | clause (ii) at EJA generality (clauses i/iii/iv cited to vdW) | **PARTIAL** | (E1) gives clause (ii) — "every effect is simple" IS the Jordan spectral theorem. Clauses (i), (iii), (iv) stay cited, so the row is ~3/4 external either way |
| 9 | `lem:normality` | order-**infimum** form; abstract f.d. order-unit generality | **NOTHING** | needs `⨅` for the Loewner/order-unit order and Loewner monotone convergence. An order-theoretic gap, not a Jordan one |
| 10 | `prop:bridge` | external | **NOTHING** | cited |
| 12 | `prop:central` | the **restriction** direction (= `prop:central`'s splitting) | **NOTHING** | needs "a product is compatible with each central idempotent"; the carrier is `V × W` order-unit spaces, no Jordan layer involved |
| 13 | `prop:pseudo-transfer` | EJA generality (proved on the concrete carrier in normalized form) | ★★★ **PARTIAL — "CLOSES" RETRACTED 2026-08-22** | the retracted reason read "the pseudo-inverse is defined by functional calculus — (E1)", and it is wrong twice. **(a)** A *polynomial* functional calculus at EJA generality exists — `RadicalRelativity.EJA.jeval` (`EJA/Spectral.lean:98`), multiplicative via `jeval_mul` (`:128`) — and a spectral inverse over a finite spectrum is a polynomial value, so (E1) was never what stood in the way. **(b)** The binding constraint is that this row **cannot be STATED at EJA generality at all**: it quantifies over the unknown sequential product, `SequentialProductOn` is declared `(V : Type*) [OrderUnitSpace V]` (`SequentialProduct.lean:244`), and `RadicalRelativity/EJA/` contains **zero** occurrences of `OrderUnitSpace` and **zero** of `IsEffect` — measured per file across all 15 files, 2026-08-22, every count 0. All three gates are Jordan-algebraic; none supplies an order-unit or effect layer. The axiomatization still removes *part* of the residue, so PARTIAL, not NOTHING |
| 14 | `prop:theta` | **pre-registered external** (residue restated 2026-08-22) | **PARTIAL** | ★★★ **THE IDENTIFICATION IS SETTLED 2026-08-22, AND IT MOVED NO ROW.** `gate_E3` is the classical Koecher / Alfsen–Shultz theorem: its `Φ : J ≃ₗ[ℝ] J` is linear **by type, not by hypothesis**, and `ComparisonSetup.Θ : J → (J ≃ₗ[ℝ] J)` (`MasterTheorem/Interface.lean:264`) makes the same commitment — both verified at source. So a Mathlib-grade f.d. EJA layer containing Koecher / AS 2.80 **would** discharge that gate in-tree. ★ It unlocks nothing: rows 16 and 17 were the only rows said to depend on it, and neither does (see their cells). ★★ Also corrected: this cell's "residue today" column read "vIR generality", which is the same false reason `WallCertificates/external-rows.md` carried for this row — the article derives linearity from vdW Prop 5.3 *before* invoking vIR and names Alfsen–Shultz for exactly that step (`main.tex:775-789`). The externality is a pre-registered decision and is **not** relitigated; only the reason is corrected. Improving the interior form is in scope, closing it is not |
| 15 | `lem:frame-fix` | Peirce-block clauses **and** the `Stab(F)°` clause | **PARTIAL** | ★ **CORRECTED 2026-08-10**: the `Stab(F)°` clause needs identity-component vocabulary and is not an EJA gap. The Peirce-block clauses are (E2) |
| 16 | `lem:coalescence` | **citation/axiomatization gap only** — both clauses are already proved over `ComparisonSetup` | ★★★ **PARTIAL — "CLOSES" RETRACTED 2026-08-22** | the retracted reason read "this is the cleanest case in the table … what is missing is that `Theta_jordan` and the FK fields are *carried* rather than derived. (E2)+(E3)". **`Theta_jordan` is not missing from this row**: neither clause consumes it (`coalescence_J2q`'s whole proof term is `C.Θ_fix a ha b (C.simDiag_opCommute …)`, `MasterTheorem/Coalescence.lean:140-142`; the article's own proof at `main.tex:963-964` invokes `prop:theta`'s *fixing* clause and `lem:span`, never its Jordan-automorphism clause). What IS carried is `Θ_fix` — vdW Prop 5.5 span-extended by `lem:span`, i.e. **manifest row 5**, non-EJA. And the same order-layer measurement as row 13 applies: `Θ_a` is the comparison map of the unknown sequential product, and no gate supplies the order-unit/effect layer that product lives on. (E2) still lands, so PARTIAL |
★★★ **ARC-9 UPDATE (2026-08-13) on row 16: the (E2) half is DISCHARGED on the concrete carrier.** `EJA/ConcreteInstance.lean` builds `ejaComparison` from `Necessity.comparisonSetup` plus the five equations, and `toCoalescenceSetup` produces a `CoalescenceSetup` on `H_N(ℂ)` with `simDiag_opCommute`, `aOf_scalarOn` and `block_mem_J2` **proved**. The row does not close: `Θ_fix` and `Θ_jordan` remain cited, so what is left of the gate is **(E3) only**. ★ The same work showed `WallCertificates/eja-gated.lean`'s `gate_E2_peirce` is under-hypothesised — its `haOf` does not tie the coefficients to `r`. ★★★ **"what is left of the gate is (E3) only" IS WITHDRAWN 2026-08-22.** The sentence names the right two survivors — `Θ_fix` **and** `Θ_jordan` — and then collapses them into the wrong one. `Θ_jordan` is (E3) and this row does not consume it; `Θ_fix` is vdW Prop 5.5 span-extended by `lem:span` (manifest row 5) and is not a gate at all. The clause that is true is the first one: the row does not close.

| 17 | `lem:homomorphism` | generality only (hyperplane clause closed ARC-6) | ★★★ **PARTIAL — "CLOSES" RETRACTED 2026-08-22** | the retracted reason was, in full, "same shape as row 16" — a pointer, and the cell it pointed at is now retracted. ★ Scope note, since it matters for who checked what: the adversarial pass that produced this correction named rows 13 and 16; row 17 is retracted here on evidence read at source in the same pass, on three grounds none of which is (E1)/(E2)/(E3). `DiagonalHomSetup` (`MasterTheorem/DiagonalHom.lean:180-193`) carries `ρ`, `ρ_skew`, `dχAdd`, `dχAdd_cont` and `coalescence_diff` as fields its own docstrings call "interface data … the paper's analytic differentiation of `χ̃`, not constructed here"; the article's `Stab(F)^∘` clause needs identity-component vocabulary absent from the tree; and the same order-layer measurement as rows 13 and 16 applies. **Row 17 is also withdrawn from terminal state EJA-GATED on 2026-08-22** — see `WallCertificates/eja-gated.lean`. (E2) still lands, so PARTIAL |
| 18 | `prop:stabilizers` | the `T^{n-1}` packaging; the ℝ/ℍ/𝕆 rows | **NOTHING** | ℂ row is done in `U(n)`; the remainder is a quotient-by-global-phase packaging and three concrete type-specific computations. No Jordan generality needed |
| 20 | `thm:quaternionic` | the **transfer** (`Θ_r = id` for an arbitrary product) | **NOTHING** | the carrier is concrete (`QuatCarrier n`, symplectic-fixed subspace of `H_{2n}(ℂ)`) and the product now exists on it; the open question is whether `Z(ℍ) ∩ Im ℍ = {0}` survives the embedding — a concrete computation |
| 21 | `thm:albert` | Albert M2 equational machinery; **pre-registered external** | **NOTHING** | not blocked on octonions; blocked on weeks of equational algebra. ★ Octonion claim re-checked 2026-08-10 (dry-pass round 4) and the path corrected: the file is `~/repos/research/lean/RadicalRelativity/Octonions.lean` (a **different Lean project**, toolchain v4.28.0), and `grep -c sorry` on it returns **0**. ★ Scope: that is a grep for the token, not a compile — this arc did not build that project, and the "0 sorries" claim is carried from the 2026-07 record rather than re-verified by elaboration |
| 22 | `lem:orientation` | the coherence space as a carrier (`J_{q,k}`, splitting-independence, `Ad_{a^{it}}`) | **PARTIAL** | (E2) supplies the Peirce/coherence vocabulary the statement needs; the `Ad_{a^{it}}` formula and splitting-independence are additional work |
| 26 | `lem:frame-connectivity` | Givens/Jacobi factorization into rank-two block rotations | **NOTHING** | absent from the tree AND from Mathlib (`Givens` over v4.28.0: zero hits); a matrix-group fact, orthogonal to the Jordan layer. Standalone Mathlib contribution. ★ Do not "refute" this with `Necessity/BlockRotation.lean` — that file is the rotation *acting on* a Peirce block, not a factorization *into* block rotations; see the note in `frame-geometry.lean` |
| 29 | `prop:n2-necessity` | gap (b): the Θ-level vs product-level equivalence | **NOTHING** | rank two, concrete carrier |
| 31 | `thm:qubit-boundary` | unimodular cocycle subcases; clause (iii) in the `(Φ,t)`-conjugation form | **NOTHING** | rank two, concrete |
| 35 | `cor:qubit-classification` | agreement on **effect × effect** — proved at positive-definite first arguments, open at singular ones | **NOTHING** | rank two, concrete. ★★ **This cell's earlier residue ("the onto half at singular effects, an S2 limiting argument") was REFUTED at checkpoint 2**: the onto half is FALSE, not unwritten — the tree's own `Necessity.badP` has the same moduli function and a different `.sp` (`RankTwo.not_exists_moduli_of_badP`). The target is products up to agreement on effects |
| 36 | `cor:selectors` | clause (i): the Peirce-exchange action on `H_N(ℂ)` | **NOTHING** | the carrier is concrete `H_N(ℂ)`; the missing object is a concrete coherence-block action, and the mechanism is already machine-checked at rank two |

---

## The decision, on this evidence

**Counting, CORRECTED AGAIN 2026-08-22: CLOSES 0 rows; PARTIAL on 9 (5, 6, 8, 13, 14, 15, 16, 17, 22); NOTHING on 15.** The three rows this file had in the CLOSES column — 13, 16 and 17 — are retracted to PARTIAL, each on evidence read at source and each for a reason recorded in its own cell. ★ **Prior record, kept because the trajectory is the content: CLOSES said SIX rows until 2026-08-10, THREE (13, 16, 17) until today, and ZERO now.** Every correction was in the same direction, and every one came from reading the rows rather than re-reading this table. **The third retraction this file has taken.**

★★ **What the retraction is NOT.** It is not a finding that the axiomatization is worthless, and it
does not fire the ARC-8 orders' skip condition. That condition is *literally zero yield*; the
axiomatization removes part of the residue on **nine** rows. **The pre-registered program decision —
the EJA axiomatization happens before Paper A submits — stands, and this pass did not reopen it.**
It also moves no manifest row's status word and changes no coverage count; the counts remain
12 FORMALIZED / 19 PARTIAL / 5 ABSENT.

★★★ **What the retraction IS, in one sentence: this file was pricing the wrong axis.** Its three
gates (E1) (E2) (E3) are all Jordan-algebraic, and what rows 13, 16 and 17 are blocked on is **order
structure**. `SequentialProductOn` — the object every one of those rows quantifies over — is declared
`(V : Type*) [OrderUnitSpace V]` (`SequentialProduct.lean:244`), and `RadicalRelativity/EJA/` mentions
`OrderUnitSpace` **zero** times and `IsEffect` **zero** times, measured per file across all 15 files
on 2026-08-22. Those rows cannot be *stated* at EJA generality, let alone proved there, and no amount
of (E1)/(E2)/(E3) changes that. ★ The gates are still worth building; they are just not what these
three rows were waiting for.

★★★ **SCOPE AND SHELF LIFE OF THAT MEASUREMENT, stated now so it is not read as permanent.** The
count is a measurement of `RadicalRelativity/EJA/` **as of 2026-08-22, at 15 files**, and it is
already being falsified on purpose: a parallel agent is writing `RadicalRelativity/EJA/Order.lean`,
which imports `RadicalRelativity.OrderUnitSpace` and constructs an `OrderUnitSpace J` from the
cone of sums of squares — its own module docstring cites this same measurement as the thing it
exists to remove. **When that file lands, re-run the measurement before quoting the number, and
re-price rows 13, 16 and 17 rather than inheriting the verdicts above.** ★ The retraction of the
CLOSES column stands regardless of how that work turns out: it was never a claim that the rows are
unreachable, only that the *three gates this file prices* are not what reaches them.

So the axiomatization is **not** nothing — it is the single largest remaining block of row movement
available, and it is the only thing that moves the EJA *part* of rows 5, 6, 13, 15, 16, 17 and 22,
whose residues all also contain non-EJA clauses (the ball clause, clause (i)'s order-unit port, the
`Stab(F)°` clause, the analytic differential, and — for 13, 16 and 17 — the missing order-unit/effect
layer). The do-it-unless-it-does-literally-nothing test is therefore still **passed**: the ARC-8
orders' pre-registered condition for skipping it does not fire. What is gone is "with room to spare"
and the claim that any row closes outright.

**★★ But three qualifications, and they are why this table exists rather than a headline number.**

1. ~~**The three CLOSES rows are all "generality-only" rows.**~~ ★★★ **STRUCK 2026-08-22 WITH THE
   CLOSES COLUMN ITSELF.** Rows 13, 16 and 17 are "generality-only" in the sense that the mathematics
   is done somewhere — that part was and is true, and it is why the retraction changes no status
   word. What was false is the inference drawn from it: that making the *article's own hypothesis
   class expressible* was within these gates' reach. It is not, because the hypothesis class includes
   an order-unit space with an effect algebra, and the gates are Jordan-algebraic. See the head of
   this section.
   ★ **This numeral said "six" in three places until 2026-08-12 (ARC-9 block 9.1)**, one day after
   the count was corrected to three at the head of this section — the appended correction, the
   un-rewritten summary. Sixth instance on this project; the check is `grep -n "six" EJA-DIVIDEND.md`
   and it costs one command. ★★ **And the numeral is now zero, which is the same lesson a third
   time**: this qualification was written to explain a count, it survived the count's first
   correction by being edited in place, and it would have survived the second one too — a paragraph
   whose *subject* has been retracted still reads as informative.
2. ~~**Row 14 is the load-bearing one and it is external.**~~ ★★★ **STRUCK 2026-08-22 — IT IS NOT
   LOAD-BEARING, AND IT WAS THE MOST CONFIDENT PARAGRAPH IN THIS FILE.** It read: "Rows 16 and 17
   close only if `Theta_jordan` becomes derivable, and deriving it *is* `prop:theta` at vIR
   generality." Both halves fail. **Row 16 does not consume `Theta_jordan` at all**
   (`MasterTheorem/Coalescence.lean:140-142`; `main.tex:963-964`), and row 17 is not EJA-gated. And
   `gate_E3` reserves the classical Koecher / Alfsen–Shultz theorem, not vIR's JB-generality version,
   because its `Φ : J ≃ₗ[ℝ] J` is linear **by type** — as is `ComparisonSetup.Θ`
   (`MasterTheorem/Interface.lean:264`). Row 14's externality stands as a pre-registered decision and
   is not relitigated; what falls is its use as the thing two other rows hang from.
   ★ The paragraph closed "This is the single most likely way this table gets misread." It was
   instead the most likely way this table *misled*, which is the more expensive failure and the
   harder one to notice: a warning against misreading reads as evidence that the writer checked.
3. **Nothing in the rank-two lane depends on it.** Rows 29–36 — the whole qubit crown, including the
   two that closed today — are concrete-carrier work. The axiomatization and the rank-two lane are
   independent programs, and the rank-two lane is the one with a paper-facing headline.

★★★ **THE ESTIMATE BELOW WAS WRONG ABOUT THE LARGE PIECE (2026-08-22).** (E1)'s spectral resolution
came to 599 lines in `EJA/Spectral.lean` — 528 of Lean under a 71-line module docstring, 24
declarations — whose largest component is Lagrange-interpolation
bookkeeping; the Mathlib-absence claim was correct and did not translate into the cost it was cited
to justify. The "natural home is upstream" opinion is untouched. What remains of (E1) is the
functional calculus and primitivity, and neither has been priced.

**Estimated shape of the work, for the record and not as a commitment:** (E1) a Jordan spectral
theorem is the large piece and has no Mathlib support (`lean-formalization-landscape`: essentially
we are aware of no formalization of the Jordan/EJA stack in any prover, not having searched
them systematically); ~~(E2) Peirce decomposition depends on
(E1)~~; (E3) is a citation. So the axiomatization is one big theorem plus its corollaries, and its
natural home is upstream of this paper — a Mathlib-grade EJA layer — not inside `RadicalRelativity`.

★★★ **"(E2) depends on (E1)" is STRUCK, 2026-08-12 (ARC-9 blocks 9.2/9.3), and the order inverts.**
The Peirce decomposition at a *given* idempotent is derivable from the Jordan identity alone and is
now in the tree. (E1) is what *produces* idempotents; rows 13, 16, 17 never ask anyone to produce
one, because `ComparisonSetup` carries the frame as **data** (`p : Fin n → J`). So (E2) comes first
and (E1) is not on the critical path for rows 16/17.

★ **And the pre-registered "Peirce-facts-as-hypotheses" test below is ANSWERED: the refactor is
viable, and it is larger than it sounds.** `ComparisonSetup.p` carries **no axioms** — not
idempotence, not orthogonality, not summing to `e`, and not `aOf r = Σ exp (r i) • p i`. The refactor
must add those equations before it can derive `frame_opCommute`, `aOf_scalarOn`, `block_mem_J2` and
`simDiag_opCommute`. Bounded work, none of it a spectral theorem. Full pricing in `LEDGER.md`,
ARC-9 blocks 9.2/9.3.

**What would change this verdict:** if (E1) turns out to require the spectral theorem only for the
*specific* frames the article uses (rather than in general), the three CLOSES rows might be reachable
by a much smaller "Peirce-facts-as-hypotheses" refactor of `ComparisonSetup` that keeps them
EJA-GATED but removes the unexaminable-field objection. That refactor is cheap and has not been
priced; it is the first thing to test before committing to (E1).
★★★ **SUPERSEDED 2026-08-22 — THERE ARE NO "three CLOSES rows" ANY MORE, and this test is aimed at
the wrong obstruction.** The `ComparisonSetup` refactor named above is still worth doing on its own
merits (it removes unexaminable fields), but it cannot reach rows 13, 16 or 17, because their
obstruction is that the sequential product has no carrier at EJA generality — no `OrderUnitSpace`,
no `IsEffect`, anywhere under `RadicalRelativity/EJA/`. **The honest replacement question, and it is
now the first thing to price: what would it cost to put an order-unit/effect layer on the EJA
carrier, so that `SequentialProductOn` can be instantiated there at all?** Nobody has asked it, and
until it is asked this file cannot say what the axiomatization buys those three rows.
