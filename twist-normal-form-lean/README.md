# Lean formalization — Twist Normal Form paper

Standalone Lean 4 development accompanying the paper

> **Sequential Products on Euclidean Jordan Algebras: Classification in Rank
> at Least Three and the Complex Qubit**.

This project is a self-contained extract of the paper's modules from the
parent *Radical Relativity* Lean development. It has **zero dependency** on
any other program code, and no build-time dependency other than Mathlib —
but see Provenance: some of the code is third-party, vendored in.

## Provenance — first-party vs vendored

Of the tree's 55,328 lines, **12,499 are third-party code vendored verbatim**
(pinned, Apache 2.0, per-file copyright headers retained). ★ Counts as of 2026-08-22 23:10 EDT;
reproduce with `find RadicalRelativity RadicalRelativity.lean -name '*.lean' -exec cat {} + | wc -l`
and the same over `RadicalRelativity/Vendor`. The first figure read 41,135 for three arcs after it
stopped being true, and went stale again the same day it was corrected, which is why the command is
printed here rather than the number alone. Full record,
including the 2026-08-21 re-vendor of both islands at v4.33.0 (which retired the whole
mathlib v4.32→v4.28 backport edit log recorded there):
`RadicalRelativity/Vendor/VENDOR.md`.

| Vendored island | Upstream | Author(s) | Role here |
| --- | --- | --- | --- |
| `Vendor/*.lean`, `Vendor/HermitianMat/`, `Vendor/Tactic/` (17 modules) | `leanprover-community/physlib` @ `a50684a191` | Alex Meiburg (`HermitianMat/Proj.lean` also Leonardo A Lessa) | the M1 carrier substrate: Hermitian matrices with Loewner order, trace inner product, continuous functional calculus, Jordan product |
| `Vendor/Wigner/` (8 modules) | `zblore/csd-lean4` @ `818b770010ae` | Zayn Blore | complex Wigner rigidity on `ℂP^{N-1}` — the M3 input for the ℂ row |

Everything outside `RadicalRelativity/Vendor/` is first-party. In particular
`RadicalRelativity/Wigner/RealWigner.lean` — the finite-dimensional real, non-bijective
Wigner theorem, which is what makes the real row unconditional; we are aware of no
formalization of it in any proof assistant, but have not searched them systematically —
is first-party; it lived under `Vendor/` until 2026-08-08 only because it was
written against the vendored complex development, and it imports nothing vendored.

Both islands are **tracked**: they sit inside the census prefix, so
`AxiomAudit.lean` audits every vendored declaration on the same terms as
first-party code.

## Theorem-to-file map

`THEOREM-MAP.md` records which paper statements are machine-checked, which are
carried as cited interface hypotheses, and which are not formalized at all.
Its §2 has to be read before any row of §1 is read as a verification claim.

The anonymized archive accompanying the journal submission is this same tree
with two directories renamed — `RadicalRelativity/` to
`SequentialProductsArtifact/` and `PaperA/` to `PaperStatements/` — so that no
path carries a program or paper identifier. Declaration names are identical in
both, so the map's declaration column transfers unchanged.

## Build

```bash
lake exe cache get   # download prebuilt Mathlib oleans (same pin as manifest)
lake build           # builds the paper's modules (no-sorry / axiom-closure gate: AxiomAudit.lean, not this command)
```

- Toolchain: `leanprover/lean4:v4.33.0` (see `lean-toolchain`).
- Mathlib: `v4.33.0`, pinned in `lake-manifest.json` (identical revision to the
  parent development).

## The two unconditional rows

Two rows of the paper's main theorem are machine-checked with **no hypotheses
beyond the paper's own** — an S1–S7 sequential product (the
`SequentialProductOn` fields), S2 (`FirstArgContinuous`), and a dimension
bound. Nothing else is assumed, and no interface field is posited:

```
#check @Necessity.complex_classification_unconditional
-- ∀ {N : ℕ}, 3 ≤ N → ∀ (P : SequentialProductOn (HermitianMat (Fin N) ℂ)),
--   P.FirstArgContinuous →
--     ∃! t, ∀ (a b), IsEffect a → IsEffect b → P.sp a b = HermitianMat.twistSeq t a b

#check @Necessity.real_classification
-- ∀ {N : ℕ}, 0 < N → ∀ (P : SequentialProductOn (HermitianMat (Fin N) ℝ)),
--   P.FirstArgContinuous → ∀ {b}, IsEffect b → ∀ (a), IsEffect a →
--     P.sp a b = (HermitianMat.conj ↑(a.cfc Real.sqrt)) b
```

Both close over Lean's three core axioms only. `PaperA/CertifiedConfiguration.lean`
additionally shows these two rows satisfy the *frozen conclusion shapes* of
`PaperA/Statement.lean` with the Lüders and twist reference maps instantiated
concretely (`real_meets_ludersConclusion`,
`complex_meets_uniqueTwistConclusion`), so for them the audited shape and the
proved theorem are the same statement.

The quaternionic and exceptional rows are **not** in this state, and neither gap is what an
earlier version of this file said it was. `H_n(ℍ)`: the carrier exists here
(`HermitianMat.QuatCarrier`), and the `RCLike` route is closed for an unrelated structural
reason, so the row runs through the embedding `H_n(ℍ) ↪ H_2n(ℂ)`; on that route the single
named gap is the **transfer** — that an S1--S7 product on the quaternionic carrier forces
`Θ_r = id` — and not quaternionic Wigner rigidity. `H₃(𝕆)`: the octonions are **not** missing
from every prover; they were built in the sibling development, and that claim was
retracted on 2026-08-08. ★ As of 2026-08-22 they are no longer only in the sibling
development: `Octonions.lean`, `OctonionNucleus.lean` and `OctonionTrace.lean` are **in this
tree** (see "Octonion substrate" below), so the algebra, `nucleus 𝕆 = ℝ`, and the associative
trace form are all machine-checked here. What is still absent is an `H₃(𝕆)` carrier and the
Albert-branch work above it; the row has not moved. `THEOREM-MAP.md` is the governing ledger for
what is and is not verified; read it before reading any row here as a claim.

## Axiom audit

`MasterTheorem.master_chain` (in `RadicalRelativity/MasterTheorem/Master.lean`)
is the abstract master-theorem skeleton. It is **not** a verification of the
paper's theorem: it is an implication quantified over the §2 interface fields,
so its clean closure certifies that no step between the cited inputs is
unsound, not that those inputs are discharged. Its axiom closure is exactly
Lean's three core axioms:

```
#print axioms MasterTheorem.master_chain
-- 'MasterTheorem.master_chain' depends on axioms:
--   [propext, Classical.choice, Quot.sound]
```

No custom `axiom` declarations appear in the `master_chain` import tree — nor
anywhere in the tracked tree: `AxiomAudit.lean` enforces, over every persisted
declaration of every tracked module, that the closure is a subset of
`{propext, Classical.choice, Quot.sound}` and that the custom-axiom list is
empty.

## SymPy cross-check

`verify_n2.py` corroborates the rank-two algebraic identities (labels V1–V10)
of the paper's §6 in exact symbolic arithmetic:

```bash
python3 verify_n2.py   # prints per-identity PASS lines; exits 0 on success
```

Runs under Python 3 with SymPy (tested: Python 3.14, SymPy 1.14); exact
symbolic arithmetic only, no floating point. It corroborates the
self-contained paper proofs of §6 rather than replacing them.

## Module map

`RadicalRelativity.lean` (root) aggregates the paper's modules.

### Support modules (copied verbatim from the parent development)

These carry program-shared definitions that the paper's modules depend on.
They are copied so this project stands alone; they are **not** paper content.

| Module | Role |
| --- | --- |
| `RadicalRelativity/OrderUnitSpace.lean`     | order-unit-space scaffold (leaf) |
| `RadicalRelativity/SequentialProduct.lean`  | exact S1--S7 interface plus a separately named algebraic core |
| `RadicalRelativity/LocalTomography.lean`    | composite / local-tomography structures |
| `RadicalRelativity/SpinFactor.lean`         | spin-factor algebraic-core instance (S2 not yet claimed) |

### Octonion substrate (copied from the parent development, 2026-08-22)

Landed for the Albert branch. **No paper module depends on these and no manifest row
moved when they landed**; they are tracked here only so the census audits them on the
same terms as everything else.

| Module | Role |
| --- | --- |
| `RadicalRelativity/Octonions.lean`       | `𝕆` as `Fin 8 → ℝ` with the Fano-plane table: alternativity, `N(ab) = N(a)N(b)`, the three Moufang identities, `conj_mul`, `mul_conj`, and `non_associative` |
| `RadicalRelativity/OctonionNucleus.lean` | `nucleus 𝕆 = ℝ·1`, by the finite Cayley-table check |
| `RadicalRelativity/OctonionTrace.lean`   | the trace form `⟨x, y⟩ = re (x ȳ)` is symmetric, **associative**, and positive definite — the hypothesis the `EJA` layer needs before it can apply to `h₃(𝕆)` |

The parent development carries three custom `axiom` declarations alongside these
(Hurwitz's classification, `Aut(𝕆) = G₂`, `S⁶ = G₂/SU(3)`, the latter two `True`
placeholders). Nothing consumed them; they were **dropped rather than ported**, so the
census still reports custom axioms exactly `[]`. `Albert.lean` and `F4.lean` from the
parent development did not land: they carry `sorry`s and further custom axioms.

### Paper modules

**Twist normal form**
- `RadicalRelativity/TwistNormalForm.lean`

**Exact statement boundary (target, not a classification proof)**
- `RadicalRelativity/PaperA/Statement.lean`

**Master theorem chain — abstract skeleton `master_chain` (13 modules including
Central and Witnesses).** Not a capstone and not a verification of the paper's theorem: it is an
implication quantified over the §2 interface fields. See "Axiom audit" above and
`THEOREM-MAP.md` §3.
- `RadicalRelativity/MasterTheorem/Interface.lean`
- `RadicalRelativity/MasterTheorem/Coalescence.lean`
- `RadicalRelativity/MasterTheorem/DiagonalHom.lean`
- `RadicalRelativity/MasterTheorem/Branches/Real.lean`
- `RadicalRelativity/MasterTheorem/Branches/Quaternionic.lean`
- `RadicalRelativity/MasterTheorem/Branches/Albert.lean`
- `RadicalRelativity/MasterTheorem/Branches/Complex.lean`
- `RadicalRelativity/MasterTheorem/Globalization.lean`
- `RadicalRelativity/MasterTheorem/Adapter.lean`
- `RadicalRelativity/MasterTheorem/Master.lean`
- `RadicalRelativity/MasterTheorem/RankTwo.lean`
- `RadicalRelativity/MasterTheorem/Central.lean`
- `RadicalRelativity/MasterTheorem/Witnesses.lean`

**Selection — earlier block-core development (pair-local ansatz route)**
- `RadicalRelativity/Selection/BaseEquality.lean`
- `RadicalRelativity/Selection/Descent.lean`
- `RadicalRelativity/Selection/Equidistribution.lean`
- `RadicalRelativity/Selection/NormalFormExistence.lean`
- `RadicalRelativity/Selection/SelectorEquivalence.lean`
- `RadicalRelativity/Selection/TwistIsotropy.lean`

**The rest of the tree** — where the two unconditional rows actually live. The
lists above are the abstract layer only; they are a small minority of the 192
modules under `RadicalRelativity/` (193 tracked declaration-bearing modules, counting the
root aggregator; measured 2026-08-23 10:35 EDT, and the audit prints its own denominator —
read that rather than this), so the map is completed by directory rather than by file.
★ Reproduce every count in the table with
`for d in EJA Hermitian Necessity RankTwo PaperA Wigner Vendor; do echo "$d $(find RadicalRelativity/$d -name '*.lean' | wc -l)"; done`
— these numbers went stale **four** times, the third within the same session that corrected
them the second time, because the tree kept growing underneath them. ★ That is the argument for
running the command rather than reading the table: a count in prose is a claim about a moment,
and this tree changes faster than the prose describing it:

| Directory | Modules | Role |
| --- | --- | --- |
| `RadicalRelativity/EJA/` | 23 | **the EJA layer (ARC-9, 2026-08-12; extended 2026-08-23)** — Jordan-algebra theory whose only Jordan input is Mathlib's `IsCommJordan` (plus the real scalars, which are load-bearing: the Peirce layer divides by `2` and Albert's theorem needs every integer invertible): the Peirce decomposition at an idempotent with its Faraut–Korányi multiplication rules, orthogonal idempotent families and the three FK facts `CoalescenceSetup` carries as citations, **Albert's power-associativity theorem**, formal reality and the absence of nilpotents, the one-generator subalgebra, and **the single-element spectral theorem** (`EJA/Spectral.lean`, 2026-08-22 — unit-free, with a complete form taking the unit as a hypothesis, live on `HermitianMat d 𝕜`, and carried into the interface's bilinear-map vocabulary). ★ This is (E2) of `EJA-DIVIDEND.md` and the resolution half of (E1); **no manifest row depends on it yet**, and none moved when it landed. Row 13's residue is the spectral *inverse*, which is a functional calculus on the resolution and is not built. ★ Since 2026-08-22 the directory also carries the Jordan–von Neumann–Wigner substrate: `Class.lean` (the `EuclideanJordanAlgebra` class, so the layer is reachable from one typeclass), `PeirceSubalgebra.lean` (`J₂(c)` and `J₀(c)` as EJAs with units `c` and `1 - c`), `Rank.lean` (primitivity, `JordanFrame`, rank), `FrameExists.lean` (every f.d. EJA with `1 ≠ 0` carries a frame), `FramePeirce.lean` (`J = ⨁_{i ≤ j} V_ij` as `DirectSum.IsInternal`) and `FramePeirceMul.lean` (the Faraut–Korányi multiplication table relative to that frame, **including `dim V_ii = 1`**). **Read those six as substrate, not results**: no manifest row depends on any of them, and `rank J = n` for a frame of cardinality `n` is NOT proved — so `dim V_ii = 1` is a statement about one block of a frame carried as data, and says nothing about the rank. ★ An earlier revision of this row said `dim V_ii = 1` is NOT proved; that was true until 2026-08-23, when `FramePeirceMul.lean` proved it by running the spectral theorem inside `J₂(p i)` — the first place in the tree that spends primitivity rather than transporting it. ★ Since 2026-08-23 the class has a **base model**: `HermitianCarrier.lean` proves `H_n(𝕜)` is a `EuclideanJordanAlgebra` for any `RCLike 𝕜`, so `exists_jordanFrame` and `frameBlock_isInternal` are statements about a live object rather than about a class only the two *conditional* Peirce-subalgebra instances inhabited. No field of the class needed new mathematics — each was already proved in `jordanBilinG`/`symmMul` vocabulary — and the `HermMul` scoped-`Mul` collision `Class.lean` warned about turns out to be definitional (`hermMul_toMul_eq`). ★ Later the same day the frame stopped being merely existential: `HermitianCarrier.lean` proves `diagFrame_isPrimitive`, the one `JordanFrame` obligation `Witness.lean` leaves open, and **names** `diagJordanFrame : JordanFrame (HermitianMat n ℂ) (Fintype.card n)` — so `diagJordanFrame_isInternal` is the frame Peirce decomposition with nothing quantified. ★ An earlier revision of this row said no frame is exhibited and that primitivity is not proved; both were true when written and were falsified within the hour. ★ Two limits that have **not** moved: the named frame is over `ℂ` only, because `Witness.lean`'s `diagFrame` is, and its cardinality `Fintype.card n` is **not** proved to be the rank — `Rank.lean` gives only `card_le_rank` and `card_le_finrank` |
| `RadicalRelativity/Hermitian/` | 13 | the concrete carrier `HermitianMat n 𝕜`: order-unit layer, extreme effects = projections, twist family, CFC continuity, sequential-product instances, and the two v4.33 migration modules (`RCLikeGeneral`, `OperatorInstances`) described in `RadicalRelativity/Vendor/VENDOR.md` |
| `RadicalRelativity/Necessity/` | 76 | the two flagship rows end to end — comparison-map instances, the ℂ twist extraction and its globalization, the ℝ rigidity, the Kadison discharges, and the capstones `complex_classification_unconditional` / `real_classification` |
| `RadicalRelativity/RankTwo/` | 8 | rank-two moduli space, complementation/descent to `ℝP²`, separation, and the frame-dependent twist product with the classification correspondence (`n2SequentialProduct`, `n2QubitModuli`, `qubit_classification_up_to_effects`). ★ This cell said "the classification *map* is absent" until 2026-08-12; it was built 2026-08-09. The correspondence is a bijection **up to agreement on effects** — the article's literal "onto the products" is refuted for this encoding (`not_exists_moduli_of_badP`), so read `THEOREM-MAP.md` §1 before reading this as the article's corollary |
| `RadicalRelativity/PaperA/` | 4 | frozen statement shapes plus the certification that the two proved rows meet them |
| `RadicalRelativity/Wigner/` | 1 | first-party finite-dimensional real, non-bijective Wigner theorem (see Provenance) |
| `RadicalRelativity/Vendor/` | 25 | vendored third-party islands (see Provenance) |

`THEOREM-MAP.md` maps paper statements to declarations across all of these; this
table is only a directory-level orientation.

### `upstream/` — not part of the library

`upstream/` holds a PR-shaped copy of the real Wigner theorem prepared for possible
contribution to Mathlib, plus its PR description and a collision check. It is
**not** imported by `RadicalRelativity.lean`, `lake build` does not compile it, and
`AxiomAudit.lean`'s census does not reach it (the census walks the
`RadicalRelativity` prefix). Nothing there has been submitted anywhere. See
`upstream/README.md`.

The development carries NO custom `axiom` declarations: every tracked
declaration's axiom closure is exactly Lean's three core axioms.
(`Selection.aczel_continuous_multiplicative` was DISCHARGED into a theorem
2026-08-05 — the from-scratch one-parameter-semigroup classification in
`RadicalRelativity/Necessity/OneParameter.lean` proves it; the historical name
and signature are preserved in
`RadicalRelativity/Selection/NormalFormExistence.lean`.)
(A second axiom, `TwistNormalForm.bgw_canonical_composite`, was eliminated
2026-08-04: it asserted only the existence of an operation with nine
specified table values — constructible, hence not falsifiable — and is now
the definition `bgwComposite` with the nine rows proved by `rfl`; the
Barnum–Graydon–Wilce citation attaches to the table's interpretation, in
prose, as before.)
