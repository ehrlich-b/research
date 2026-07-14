# Lean Formalization: Status (2026-03-28)

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd ~/repos/research/lean && nice -n 15 lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. 2861 jobs, builds clean.

## MasterTheorem tree (twist paper "Sequential-Product Moduli on Simple EJAs", 2026-07-14): 0 sorry, 0 custom axioms — conditional dependency skeleton

`RadicalRelativity/MasterTheorem/` — the dependency-skeleton counterpart of
the paper's `mthm:master` (paper:
`blog/landing/papers/twist-normal-form/main.tex`). It is NOT a formalization
of the paper theorem (no effects, no S1-S7, no product equalities); it
machine-checks the downstream algebraic chain from auditable interface
fields. Ledger + honesty notes: `MasterTheorem/PLAN.md` §2 (read first);
audit history incl. the adversarial round: `AUDIT.md` top section.

### Classical imports (ZERO axiom declarations tree-wide)

| Former plan-ledger item | End state |
|---|---|
| vIR order-iso ⟹ Jordan-iso | `ComparisonSetup.Θ_jordan` FIELD (cited hypothesis, arXiv:1904.09278 Cor 2.5/Prop 2.6) |
| Continuous-additive ⟹ ℝ-linear | PROVED `def lieHom_smooth` (Mathlib `AddMonoidHom.toRealLinearMap`); continuity = cited field `dχAdd_cont` |
| Characters of ℝ | PROVED `real_character_unique` |
| Yokota Spin(8) triality faithfulness | `IsAlbertModel.block_injective` FIELD (cited hypothesis, arXiv:0902.0431 Thm 2.7.1+1.16.2) |

`#print axioms MasterTheorem.master_chain` = [propext, Classical.choice,
Quot.sound] — Lean core only. Caveat: that is syntactic closure, not a
faithfulness certificate; the import surface is the interface field lists.
vdW Props 4.20/5.2/5.3/5.5/5.7 + the EJA compatibility bridge are
`ComparisonSetup` fields (Θ_fix carried in span-extended form, disclosed).

### Chain

```
ComparisonSetup (vdW comparison-map face; Θ_jordan field)
  → jordanAuto (field projection) → frame_fixed/block_preserved (PROVED)
  → Coalescence (D3, PROVED from Θ_fix + FK fields)
  → DiagonalHom (hyperplane factorization PROVED; toStabilizerCoupling
      PROVES the coupling; differential face = interface data starting
      AFTER the paper's analytic step — disclosed)
  → Branches: Real (rank-free), Quaternionic (two-slot, pure proof),
      Albert (block_injective field), Complex per-frame (pure proof)
  → Globalization (character uniqueness PROVED; connectivity induction
      PROVED, geometric move = `hmove` hypothesis)
  → Adapter → Master: master_chain (skeleton conjunction over PRODUCED
      couplings; 5b anchored to 5a via Scfam F₀ = Dc.toStabilizerCoupling)
RankTwo (separate, concrete M₂(ℂ)): 15 results, core only,
  incl. n2_exchange_selects_luders (paper Remark 6.2, Paper-B-facing).
```

### Disclosed located hypotheses (PLAN §2 has the authoritative list)

`Θ_jordan`, `block_injective`, `dχAdd_cont`, Θ_fix span-extension,
`coalescence_diff` (group-level version proved), `hmove`, `overlap`,
S2-continuity + invertible-density (prop_singular, standalone lemma),
RankTwo scoping (V5b/d + full S1-S7 bundling not formalized).

## Paper 5: 0 sorry, 3 axioms (all external). LOCKED FOR JOURNAL.

### Axioms (3, all published external results)

| Axiom | File | Source |
|-------|------|--------|
| `self_model_gives_sp_data` | SelfModelingBridge | Alfsen-Shultz 2003 + vdW 2019 |
| `spectral_jordan_identity` | JordanStructure | vdW 2019 section 4 |
| `vdw_theorem_3` | CStarBridge | vdW 2019 Theorem 3 |

### Chain

```
SelfModelingSystem (DEFINED, 7 fields, all non-vacuous)
  → SPData (AXIOM: self_model_gives_sp_data)
  → SequentialProduct (PROVED: SPData.toSequentialProduct)
  → Jordan algebra (AXIOM: spectral_jordan_identity)
  → IsLocallyTomographic (CLASS, not axiom — requires dim(W) = dim(V)²)
  → Type exclusion: complex only (PROVED: type_exclusion_real/quatern)
  → C*-algebra (AXIOM: vdw_theorem_3, gated on IsLocallyTomographic)
  → QM
```

### Known gap

No explicit theorem deriving `IsLocallyTomographic` from self-modeling minimality.
The paper's Theorem 5.10 proves this via:
- Lower bound: d² product effects linearly independent → dim(W) ≥ d²
- Upper bound: span satisfies (C1)-(C4) + minimality → dim(W) ≤ d²

This is the one unfilled link. `vdw_theorem_3` takes `IsLocallyTomographic V` as
an explicit hypothesis, so the gate is enforced but the derivation from
self-modeling is not formalized.

### What was tried and reverted

- Making `IsLocallyTomographic := True` — REVERTED. Made the gate vacuous.
- Adding `composite_minimal : True` to SelfModelingSystem — REVERTED. Vacuous field.
- Both were caught by adversarial review.

### Concrete models (verify axiom consistency)

- M2CInstance (DiagOUS): commutative, all S1-S7 proved from scratch
- SpinFactor (V₃): non-commutative Lüders product, all S1-S7 proved, explicit non-commutativity witness

## Paper 6: 0 sorry, 12 axioms. DONE.

| File | Sorry | Axioms |
|------|-------|--------|
| SelfModelingLattice | 0 | 2 |
| AreaLaw | 0 | 5 |
| JacobsonGR | 0 | 6 |

## Paper 7: 6 sorry, 28 axioms

Core chain (UniverseAlgebra → GaugeGroup → Chirality): 0 sorry.

| File | Sorry | Status |
|------|-------|--------|
| Octonions | 0 | DONE |
| Albert | 3 | Expository (jordan_identity, simple, not_special). No downstream use. |
| NonComposability | 2 | `special_of_embed_in_special` (universe technicality), `composite_iff_special` (needs witness) |
| UniverseAlgebra | 0 | DONE |
| F4 | 1 | stab_complex_conjugate (needs G_2 transitivity) |
| ObserverInterface | 0 | DONE |
| GaugeGroup | 0 | DONE |
| Chirality | 0 | DONE |
| RhoJ | 0 | DONE |

### Session changes to NonComposability

- `EJAComposite` enriched: embeddings, Jordan homomorphism conditions, rank bound
- `IsSpecialEJA` now includes Jordan homomorphism condition (was injection-only)
- `bgw_exchange_lemma` PROVED (from rank_bound field)
- `exceptional_no_composite` PROVED (embedding + composition)
- `special_of_embed_in_special` sorry (universe polymorphism technicality)
- `composite_iff_special` sorry (needs nontrivial special SimpleEJA witness)

## Papers 1-4: 13 sorry, 9 axioms. Low priority scaffold.

Session filled: `kernelDiffNorm`, `stationaryL1Dist`.
