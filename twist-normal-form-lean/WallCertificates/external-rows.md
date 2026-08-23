# The six pre-registered external rows — best interior form and the external delta

**Date: 2026-08-09, ARC-7 block 7.5.** Tag `paperA-arc7-cp1`. Pin: `main.tex` blob `205fdf5a`.

These six rows are **not** wall certificates. They are the arc's second terminal state: decided
external in ARC-5/6, not re-litigated, and closing them is out of scope *by design*. What is in
scope is their best interior form, and that is what this file records — so that "external" never
becomes a place to hide work that is actually interior.

This file is Markdown, not Lean, because there is no missing step to state: the delta in each case
is a citation, not a gap.

| Row | Label | Why external | Best interior form reached | The external delta, exactly |
| --- | --- | --- | --- | --- |
| 4 | `thm:vdw1` | Cited result; the paper never claims to reprove it | none, by design | van de Wetering's theorem that a f.d. sequential product space is order-isomorphic to a Euclidean Jordan algebra |
| 10 | `prop:bridge` | Cited result; the paper never claims to reprove it | ★★★ **"none, by design" was FALSE — corrected 2026-08-22, see the section below.** The direction the article consumes, on the concrete carriers at `RCLike 𝕜` generality: `Necessity.bridge_of_opCommute` (`RadicalRelativity/PaperA/CompatibilityBridge.lean`) — Jordan-operator commutation gives both `Q_{√a} b = Q_{√b} a` and `[Q_a, Q_b] = 0`; the `T` leg was already a proved `↔` (`Necessity.opCommute_iff_commuteG`) | the two **converses** out of the standard product, and everything at EJA generality. The article's own note: the `Q`↔`T` equivalence is the one van de Wetering says he could not find in the literature, treated in `Wetering2019commutativity` |
| 1 | `mthm:master` | Stated over an *abstract* simple EJA, so the one-theorem form needs Jordan–von Neumann–Wigner | **the ℝ and ℂ rows outright** (`real_classification`, `complex_classification_unconditional`, both `+ _ouNorm`), each carrying only S1–S7 + S2 + a dimension bound, both Lean-core | JvNW: that every f.d. simple EJA is one of the four types. The campaign's one pre-registered permanent import |
| 2 | `mthm:omnibus` | Same, plus the summand decomposition | `MasterTheorem.Central.central_decomposition` (componentwise identity) | JvNW again, plus summand inheritance of S1–S7 (which is row 12's interior part, and is **not** external — see `abstract-tier.lean`) |
| 14 | `prop:theta` | ★★★ **The reason recorded here was FALSE and is corrected 2026-08-22 — see "A third thing" below. The row stays EXTERNAL; only the reason changes.** It read "The article states it at van Imhoff–Roelands' JB-algebra generality". Corrected: the article *cites* this step rather than proving it — the row-4/row-10 reason — and what it cites is satisfiable by the classical theorem it names alongside vIR | derived on **both** concrete carriers from in-tree Kadison rigidity | ★★★ **CORRECTED 2026-08-22**: formerly "vIR's JB-algebra-level statement". At most **the classical unital-linear-order-isomorphism theorem (Koecher / Alfsen–Shultz 2.80) at f.d. EJA generality**. vIR's JB-generality version is strictly stronger than this row's own statement requires |
| 21 | `thm:albert` | Needs the unscoped Albert-algebra M2 machinery | `MasterTheorem.luders_albert_produced` at skeleton level, from cited Spin(8) block injectivity | the M2-for-Albert equational algebra. ★ **NOT the octonions** — see below |

## A third thing, and it is a defect in this table rather than a warning (2026-08-22)

**Row 14's stated reason was false against the manuscript, and the row is external anyway.** Read
at `main.tex:775-789` (blob `4b0dba30`), `prop:theta` is stated on the article's own `J`, which its
proof calls "a finite-dimensional JB-algebra". The proof gets linearity **first**, from van de
Wetering's Prop 5.3 — "constructs a *unital linear order isomorphism* `Θ_a`" — and only then
upgrades it to a Jordan automorphism, citing van Imhoff–Roelands Cor. 2.5 **and, for exactly that
step, Alfsen–Shultz classically**. So the theorem the row needs is the classical unital-*linear*
one. vIR's genuine content is order isomorphisms that are *not* assumed linear, at JB-algebra
generality; the article never asks for that, and neither does the Lean interface, whose
`ComparisonSetup.Θ : J → (J ≃ₗ[ℝ] J)` (`MasterTheorem/Interface.lean:264`) makes linearity the
field's **type**. The external register was reserving a strictly stronger theorem than the row's own
statement requires.

★★ **What is NOT changed, and this is the point worth carrying: the decision and its reason came
apart, and only the reason was wrong.** Row 14's externality is a pre-registered ARC-5/6 decision;
it is not relitigated here and this pass did not attempt to. But a pre-registered decision protects
the *decision*, not the sentence written under it — and this sentence had been load-bearing
elsewhere: `eja-gated.lean` built an inference about rows 16/17 on top of it, and
`STATEMENT-MANIFEST.md` repeated it in the ceiling arithmetic and in row 14's own status cell. A
reason nobody may re-open is a reason nobody re-reads.

## A fourth thing, and it is the same defect as the third (2026-08-22)

**Row 10's "best interior form: none, by design" was false when it was written, and it was
falsifiable from this repository's own git log on the day it was written.** The `T` leg of
`prop:bridge` — `[T_a, T_b] = 0 ⟺ [a, b] = 0` on `H_n(𝕜)`, *both directions* — has been in the
tree as `Necessity.opCommute_iff_commute` since **2026-08-05** and at `RCLike 𝕜` generality as
`opCommute_iff_commuteG` since **2026-08-06** — four and three days before this file was written
on 2026-08-09.
The 08-05 commit message reads, in its own words, "prove the FK/vdW compatibility bridge via the
quarter identity". The cell claiming no interior form existed was written over a commit that said
it had built one.

**What landed on 2026-08-22**, closing the two legs that were genuinely missing, in
`RadicalRelativity/PaperA/CompatibilityBridge.lean` (`RCLike 𝕜`, axioms exactly
`[propext, Classical.choice, Quot.sound]`, `AxiomAudit` census PASS at 169 modules):

* `Necessity.quadRep_comm_of_commute` — `[a, b] = 0 → Q_{√a} b = Q_{√b} a`, for `0 ≤ a`, `0 ≤ b`;
* `Necessity.quadOp_comm_of_commute` — `[a, b] = 0 → [Q_a, Q_b] = 0`, no positivity needed;
* `Necessity.quadOp_eq_jordan` — `Q_a = 2 T_a² − T_{a²}`, so the `Q` leg is about the article's
  Jordan quadratic representation and not a bare conjugation;
* `Necessity.bridge_of_commute` / `bridge_of_opCommute` / `bridge_of_opCommute_effect` — the legs
  chained, entered from matrix commutation, from Jordan-operator commutation, and at the article's
  own effect-level hypothesis.

**All eight citations of `prop:bridge` in `main.tex` were read at source** (lines 671, 738, 793,
853, 858, 922, 961, 2076 at blob `4b0dba30`, which is the working copy). Seven are substantive —
five in proofs, two in the import ledger discharging the compatibility hypothesis of vdW Props. 5.2
and 5.5 — and **every one runs the same direction**: operator commutation is established first,
from simultaneous diagonalisability or from centrality, and the bridge then supplies
standard-product compatibility. The eighth is related-work attribution. **No use site consumes a
converse; no use site mentions `[Q_a, Q_b]` at all.** So the one-directional interior form is not a
partial answer to the article's needs — it is the whole of what the article asks this row for.

**The row stays EXTERNAL, and this is not a re-litigation.** What is missing is real and is not
attempted here: the two converses out of the standard product, and everything at EJA generality.
On this carrier the standard-product converse is exactly "`√b·√a` normal ⟹ `√b·√a` self-adjoint",
because `(√b√a)^*(√b√a) = Q_{√a} b` and `(√b√a)(√b√a)^* = Q_{√b} a` — a genuine simplification of
the statement, and not a proof of it.

★★ **The transferable lesson is row 14's in a second costume: a pre-registered decision protects
the decision, not the sentences written under it.** "External" recorded a scope choice;
"none, by design" is a *measurement of the tree* carried in the same cell in the same breath, and
it was never measured. **A row's externality is a decision; its best interior form is an
observation, and observations go stale.** Two of this table's six rows now carry a dated
correction, and neither correction moved a decision.

## Two things about this table that are easy to get wrong

**`thm:albert` is not blocked on octonions, and the claim that it was got retracted.** The
octonions are absent from *Mathlib* but they are **built** in this project, at
`~/repos/research/lean/RadicalRelativity/Octonions.lean`: 0 sorries, same toolchain v4.28.0, compiles clean, and its
one computational input `nucleus(𝕆) = ℝ` is **proved** (`Octonion.nucleus_real`, Lean-core axioms).
That file is out-of-tree, so it does not change the coverage count — but the row's obstruction is
the Albert-algebra equational machinery (`ALBERT-KERNEL-MEMO.md` rescoped it to "weeks of equational
algebra" on 2026-08-04), never the octonions. This distinction was asserted wrongly once and
corrected when challenged; it is recorded here so it is not re-asserted.

**"Needs JvNW" is a statement about the *one-theorem* form only.** Rows 1 and 2 have genuine
interior content that is *not* external, and it has been proved: the ℝ and ℂ rows of `mthm:master`
are machine-checked at the article's own generality on the concrete carriers. Reading rows 1 and 2
as "external" full stop would understate the tree by two of its strongest results. **Never rank the
ℝ row above the ℂ row or vice versa** — they are equally founded, each carrying only S1–S7 + S2 + a
dimension bound, both Lean-core. (The claim "ℝ is the only clean row" is false and superseded.)

## Ceiling arithmetic, restated with these six removed

36 rows − 6 external = **30 interior**, which is the ceiling. A realistic ceiling is **26–28**, once
`lem:simple-bridge` is read as ~3/4 cited (its own certificate prices it per clause) and the ℍ row
is priced honestly. As of this date the interior count is 10 FORMALIZED, so the interior remainder
is 16–18 rows, every one of which now carries a dated certificate in this directory.
