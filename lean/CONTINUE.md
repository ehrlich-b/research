# Lean Formalization: Status (2026-03-28)

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd ~/repos/research/lean && nice -n 15 lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. 2818 jobs, builds clean.

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
