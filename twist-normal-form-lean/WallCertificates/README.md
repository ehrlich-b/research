# Wall certificates

**Created 2026-08-09 as block 7.5 of the ARC-7 orders (`../LEDGER.md`).**

## Why this directory exists

This project's recorded failure mode is that **prices decay**. Over arcs 5 and 6 it accumulated
five false absence claims, two walls mispriced CHEAP, four wrong "Mathlib lacks X", and one row
(`lem:n2-bounded`) mispriced twice *in opposite directions* — first "one step, nothing but
plumbing", then "four steps, one genuinely analytic", when the truth was three steps and none of
them the kind first named. Every one of those was a **prose** price: a paragraph asserting a cost,
with nothing behind it that could fail.

A wall certificate is the same claim made falsifiable. Each file here:

1. **states the missing step in Lean**, at the article's own generality, with `sorry` at exactly
   the gap and nothing else;
2. **compiles** under `lake env lean` from the repo root;
3. carries a header recording the date, every absence claim *with the scope of the grep that
   supports it*, and what was actually attempted.

Where the wall is the *vocabulary* itself — no Lean statement can even be written down — the
certificate states the nearest statable approximation and names what is missing. That a statement
cannot be written is itself the strongest available evidence of depth, so it gets recorded rather
than asserted.

## The hygiene rule that makes this safe

**No file here is ever imported from `RadicalRelativity/`.** The library root
(`RadicalRelativity.lean`) does not reference this directory, so `lake build` and `AxiomAudit.lean`
never see it: the `sorry`s here cannot leak into the census, and the tree's "custom axioms exactly
`[]`" claim is unaffected. Verify with:

```
grep -rn "^import.*WallCertificates" RadicalRelativity/ RadicalRelativity.lean   # expect no hits
grep -n "defaultTargets" lakefile.toml                                           # expect RadicalRelativity
```

★ **The first version of this recipe was `grep -rn WallCertificates …` with "expect no hits", and it
was wrong** — caught 2026-08-09 by the certificate-refutation review. That pattern returns two hits
(`Necessity/LeftMultiplication.lean` and `Necessity/FrameConstancy.lean`), both harmless prose
cross-references inside docstrings. A verification recipe that reports failure on a healthy tree is
worse than none: it trains the reader to ignore it.

★ **And the second version decayed in turn, exactly as that paragraph predicts** — caught
2026-08-21 in the public slice of this tree, applied here 2026-08-22. The isolation claim rested on
`lakefile.toml` declaring "exactly one `lean_lib`", which stopped being true when the Palomar
Challenge/Solution libraries were added. It now declares seven. The substance is unchanged but the
argument for it must be the import closure, not a library count: `defaultTargets` is
`RadicalRelativity`, no module under `RadicalRelativity/` imports this directory, and none of the
six Comparator libraries does either. So neither `lake build` nor `AxiomAudit.lean` ever elaborates
these files.

Compile a certificate deliberately, one at a time:

```
cd /Users/ehrlich/repos/research/twist-normal-form-lean
lake env lean WallCertificates/<row>.lean      # expect: only "declaration uses `sorry`" warnings
                                               # (Lean prints the word in backticks, not quotes:
                                               #  grep -cF 'declaration uses `sorry`')
```

## One file, sometimes several rows

The ARC-7 orders said `WallCertificates/<row>.lean`. In practice several rows are open *for the same
reason* — EJA generality that is not statable, or one shared missing object — and splitting them
would mean repeating the same evidence and the same greps five times, which is how records drift
apart. So a file is named for its primary row and its header lists every row it covers. The index:

| File | Rows covered |
| --- | --- |
| `lem-n2-descent.lean` | 34 — ★ **row now FORMALIZED (ARC-8 8.1(d))**; the file's row conclusion is discharged in-file and its two surviving `sorry`s are labelled off-route. Kept for the retractions, not as a live price |
| `prop-n2-sufficiency.lean` | 30, 35 — ★ **ZERO gaps (ARC-8)**: row 30 FORMALIZED, and row 35's gap statement (the `∃!`-moduli claim) is discharged. ★★ Note that discharge does NOT close row 35 — the gap statement was weaker than the row, which is the under-specified-price defect kind |
| `differential-trio.lean` | 16, 17, 18 — ★ **ZERO gaps (ARC-8)**; the ℂ converse was already in the tree when the file was written |
| `abstract-tier.lean` | 3, 5, 6(i), 8, 9, 12, 13 |
| `frame-geometry.lean` | 15, 22, 26, 29(b), 31, 36(i) |
| `eja-gated.lean` | **13, 16** (rows 5, 6, 15 were claimed 2026-08-10 and WITHDRAWN the same day — their residues include non-EJA clauses; see the file's WITHDRAWAL block — and ★★★ **row 17 was WITHDRAWN 2026-08-22**, resolving a contradiction with the file's own row-17 line that had stood at HEAD for twelve days; its residue is analytic, group-theoretic and order-theoretic, none of it a gate) — the **EJA-GATED** certificate (ARC-8 8.6). States the three gates (E1) Jordan spectral / (E2) Peirce+FK / (E3) `Theta_jordan` (**Koecher / Alfsen–Shultz, not vIR** — settled 2026-08-22; `Φ` is linear by type) once each rather than six rows six ways. ★★ **Row 16's own label is now flagged OPEN** on the WITHDRAWAL block's test — its residue includes `Θ_fix`, which is vdW Prop 5.5 span-extended by `lem:span` (row 5) and non-EJA — and is deliberately left standing for decision. ★★★ **ALL THREE ARE NOW PROVED THEOREMS AND THE FILE HAS NO `sorry`** — (E2) since 2026-08-20 (`EJA/InterfaceInstance.lean`), (E1) since 2026-08-22 (`EJA/Spectral.lean` via `EJA/Bridge.lean`), (E3) since 2026-08-23 (`EJA/OrderAuto.lean`, Koecher / Alfsen–Shultz). **No row moved on any of the three**: a gate is an ingredient, and row 13 needs the spectral *inverse*, not the spectral *resolution*; rows 16 and 17 were never gated on (E3) at all. ★★ **This cell said "only (E3) is a `sorry`" — corrected 2026-08-23.** ★★★ **The three gates going green is the evidence that the gates were not the binding constraint**, which is the opposite of what a reader expects a fully discharged certificate to mean, and is the single most likely way this row now gets misread. ★★ **And on (E2), "discharged" understates what the certificate shows in one direction and overstates it in another (2026-08-22)**: `gate_E2_peirce` needs the **Jordan identity alone** — its `[FiniteDimensional ℝ J]`, `formally_real` and `nonneg_iff_squares` are all inert, checked by elaborating the proof without them — but its existentially-bound `J2`/`ScalarOn` make its conclusion equivalent to a Peirce-free sentence, so it certifies row 16's clause (1) and not clause (2), and the frame-level `⊕_{i≤j} J_{ij}` remains unbuilt. ★★ An earlier version of this cell said "(E3) is row 14, pre-registered external, so rows 16/17 … cannot reach FORMALIZED by axiomatization alone" — **that is OPEN, not settled**: `gate_E3` as stated assumes `Φ` LINEAR (the classical Koecher/Alfsen–Shultz theorem, not vIR's JB-generality version). ★★★ **SETTLED 2026-08-22, and it changed no row.** `gate_E3_theta_jordan`'s `Φ : J ≃ₗ[ℝ] J` is linear **by type, not by hypothesis**, and `ComparisonSetup.Θ : J → (J ≃ₗ[ℝ] J)` (`MasterTheorem/Interface.lean:264`) makes the same commitment, so a Mathlib-grade f.d. EJA layer containing Koecher / AS 2.80 **would** discharge the gate in-tree. ★★★ **AND ONE DID, 2026-08-23 — `EJA/TraceForm.lean` + `EJA/OrderAuto.lean`, in-tree rather than in Mathlib.** It unlocks neither row 16 (which never consumes `Theta_jordan` — `coalescence_J2q`'s whole proof term is `Θ_fix` composed with `simDiag_opCommute`) nor row 17 (no longer EJA-GATED). ★ A crux can be answered cleanly and still be the wrong crux |
| `thm-quaternionic.lean` | 20 |
| `eja-power-assoc.lean` | **no manifest row** — ARC-9 block 9.8. ★★★ **REFUTED 2026-08-12, three hours after it was written, by the agent that wrote it**: `RadicalRelativity/EJA/PowerAssoc.lean` proves Albert's theorem outright, so the `sorry` is discharged and the file now has **zero gaps**. Kept because the mispricing is the record — it predicted a pair induction taking "hours, not minutes"; the actual proof is a single induction on total degree, about sixty lines, because the arc's own reduction had already made the product law derivable from the commutator law. **The fastest refutation this directory has produced, and the format is why**: the gap was stated in Lean, so it could be attacked instead of believed |
| `eja-spectral.lean` | **no manifest row directly** — ARC-9 block 9.12, ★★★ **DISCHARGED 2026-08-22, zero `sorry`.** `RadicalRelativity/EJA/Spectral.lean` proves **(E1)**'s spectral resolution outright, so the file is now a closure record in the shape of `eja-power-assoc.lean`: the statement stands verbatim, the `sorry` is replaced by the proof, and the original text is kept because the mispricing is the record. Its central claim — that step 4 forces a design decision about a unit — was false, and so were four more, corrected in the file as F1–F5. ★ It gave no hour estimate, so none was wrong; what was wrong was the SHAPE of the remainder. The proof contains none of the four steps the certificate enumerated |
| `hurwitz-classification.lean` | **no manifest row** — 2026-08-23, the composition-algebra block. The **dimension** half of Hurwitz is proved in-tree (`Composition/Hurwitz.lean`, `finrank_eq_one_or_two_or_four_or_eight`, axioms `[]`); the gap is the **classification**, that a Euclidean composition algebra is *isomorphic to* one of `ℝ`, `ℂ`, `ℍ`, `𝕆` rather than merely of one of their dimensions. That is what Jacobson coordinatization consumes. ★ The certificate's costs are labelled **unpriced** — no part of the missing construction was attempted. ★★ Two of its own claims were false when first written and are corrected in place with the correction kept: a Mathlib grep count quoted from memory (16/twelve, actually 15/11), and an in-tree absence claim that "returns nothing" when the grep returns one hit — a prose line in a file this same block had written an hour earlier |
| `jacobson-coordinatization.lean` | **no manifest row** — 2026-08-23, the Jordan-side half of the JvNW campaign. The coordinate algebra IS built in-tree (`EJA/Connection.lean`, `EJA/Coordinatize.lean`, `EJA/CoordinatizeWitness.lean`, 1,047 lines, axioms `[]`): an off-diagonal frame block carries a `CompositionAlgebra` structure, so Hurwitz applies and `dim V_ij ∈ {1,2,4,8}`, and a `CoordData` is exhibited on `H_d(ℂ)` so the layer is not about an empty structure. Three residues carry a `sorry` each: the isomorphism `J ≅ H_n(C)` (and `H_n(C)` does not exist as a type — the vendored `HermitianMat` is over `[Field 𝕜] [StarRing 𝕜]` and `CompositionAlgebra` carries no `Star` instance), **simple ⟹ every block nonzero** (the tree has no Jordan-ideal notion at all, so the certificate defines one), and `n ≥ 4` ⟹ the coordinate algebra is associative. ★ Residues 1 and 3 are **unpriced** — neither was attempted. ★★ The build itself is the pricing datum: the campaign plan called this its only zero-anchor module at 1,500–3,500 lines and 40% of the whole campaign, and what got built came to 1,047 lines including a carrier the plan did not ask for, with the two load-bearing identities compiling on the first or second attempt |
| `external-rows.md` | 1, 2, 4, 10, 14, 21 — *not* certificates; the pre-registered external six |

## How to read a certificate

A certificate is **not** a claim that the row is unreachable. It is a claim about *where the work
is*, stated precisely enough that a reviewer can attack the statement rather than the prose. The
correct response to a certificate is to try to discharge its `sorry` — and if that succeeds
cheaply, the certificate was wrong and the row moves. That has already happened three times on
this project to prose prices; the point of the format is to make it happen faster.

Certificates are inputs to the arc's refutation review, and they are dated: a certificate is
evidence about the tree **on its date**, not a standing verdict.
