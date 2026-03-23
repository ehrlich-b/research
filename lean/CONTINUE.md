# Lean Formalization: Status

## Current State

10 files, ~2400 lines, builds clean on Mathlib v4.28.0.
**0 sorry's. 3 axioms (all honest). ~150 definitions/theorems/lemmas.**

### Files

| File | Lines | Sorry | Description |
|------|-------|-------|-------------|
| OrderUnitSpace.lean | ~90 | 0 | OUS typeclass, IsEffect, IsSharp |
| SequentialProduct.lean | ~170 | 0 | S1-S7 + sp_sub_right_general, derived theorems |
| Compression.lean | ~130 | 0 | C_p maps, idempotence, orthogonal annihilation |
| PeirceDecomp.lean | ~230 | 0 | Peirce subspaces, membership, uniqueness |
| SpectralTheorem.lean | ~90 | 0 | Self-compatibility, compatible Jordan identity |
| JordanStructure.lean | ~110 | 0 | Jordan product, commutativity, vdW Theorem 1 |
| LocalTomography.lean | ~130 | 0 | EJA type exclusion (complex/real/quaternionic) |
| CStarBridge.lean | ~130 | 0 | HasCStarPromotion, self_modeling_implies_qm |
| M2CInstance.lean | ~155 | 0 | Commutative SP instance (DiagOUS) |
| SpinFactor.lean | ~1050 | 0 | Non-commutative SP instance, ALL axioms proved |

### Axioms (3, all honest)

1. **spectral_jordan_identity** (JordanStructure.lean) — General Jordan identity.
   Requires spectral theorem for OUS (Alfsen-Shultz Ch. 7-9). Compatible case proved.
2. **vdw_theorem_3** (CStarBridge.lean) — C*-algebra promotion from local tomography.
3. **sp_sub_right_general** (SequentialProduct.lean) — Linearity of L_a on effect
   differences. Follows from van de Wetering's S2 continuity. Proved for both instances.

### Key results

- **SpinFactor** (V₃, the 3D spin factor / Bloch ball): First machine-checked
  non-commutative sequential product. All 9 axioms + effect preservation proved
  using explicit Lorentz cone / Lüders product formulas.
- **S2 axiom correction**: Original sp_mono_left (monotonicity in 1st arg) was
  FALSE for the Lüders product. Fixed to sp_mono_right (van de Wetering's actual S2).
  Also discovered and removed 3 false theorems in Compression.lean.
- **Complete derivation chain**: Self-modeling → SP axioms → Jordan algebra →
  Local tomography → C*-algebra → Quantum mechanics.

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd ~/repos/lean && lake build
```
