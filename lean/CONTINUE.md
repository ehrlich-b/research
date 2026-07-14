# Lean Formalization: Status (2026-03-28)

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd ~/repos/research/lean && nice -n 15 lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. 2861 jobs, builds clean.

## MasterTheorem tree (twist paper "Sequential-Product Moduli on Simple EJAs", 2026-07-14): 0 sorry, 3 axioms (all cited classical theorems)

`RadicalRelativity/MasterTheorem/` — machine-checked chain for `mthm:master`
(paper: `blog/landing/papers/twist-normal-form/main.tex`). Ledger + honesty
notes: `MasterTheorem/PLAN.md` §2 (the auditor reads that first).

### Axioms (3, each declared in its consuming module)

| Axiom | File | Source |
|-------|------|--------|
| `vanImhoffRoelands` | MasterTheorem/Interface | van Imhoff-Roelands arXiv:1904.09278 Cor 2.5/Prop 2.6 |
| `lieHom_smooth` | MasterTheorem/DiagonalHom | Cartan/one-parameter-subgroup theorem |
| `yokota_spin8_triality_faithful` | MasterTheorem/Branches/Albert | Yokota arXiv:0902.0431 Thm 2.7.1 + 1.16.2 |

`#print axioms MasterTheorem.master_theorem` = exactly these 3 + core
(propext, Classical.choice, Quot.sound). A3 (characters of ℝ) was PROVED
(`real_character_unique`), not axiomatized. vdW Props 4.20/5.2/5.3/5.5/5.7 +
the EJA compatibility bridge are `ComparisonSetup` FIELDS (auditable imports,
not free axioms).

### Chain

```
ComparisonSetup (vdW comparison-map face, 17 fields)
  → jordanAuto (PROVED via A1) → frame_fixed/block_preserved (PROVED)
  → Coalescence (D3, PROVED from Θ_fix + FK fields)
  → DiagonalHom (χ extension + hyperplane factorization PROVED;
      toStabilizerCoupling PRODUCES the coupling — A2 consumed here)
  → Branches: Real (rank-free), Quaternionic (two-slot, pure proof),
      Albert (A4), Complex per-frame (pure proof)
  → Globalization (open-interval character uniqueness PROVED;
      connectivity induction PROVED, geometric move = `hmove` hypothesis)
  → Adapter → Master: master_theorem (6-conjunct assembly over PRODUCED couplings)
RankTwo (separate, concrete M₂(ℂ)): 15 results, core axioms only,
  incl. n2_exchange_selects_luders (paper Remark 6.2, Paper-B-facing).
```

### Disclosed located hypotheses (NOT axioms; PLAN §2 has the full list)

`coalescence_diff` (DiagonalHomSetup field; group-level version proved),
`hmove` (frame-connectivity geometric move), `overlap` (cross-coherence
character equality), S2-continuity + invertible-density (prop_singular),
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
