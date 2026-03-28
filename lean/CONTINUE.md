# Lean Formalization: Status (2026-03-28)

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd ~/repos/research/lean && lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. 2818 jobs, builds clean.

## Overall: 22 sorry, 54 axioms

**Paper 5: 0 sorry, 4 axioms. LOCKED for journal submission.**
**Paper 6: 0 sorry, 12 axioms. DONE.**
**Paper 7: 7 sorry, 28 axioms. Core chain complete, 3 expository + 3 blocked + 1 infrastructure.**
**Papers 1-4: 15 sorry, 10 axioms. Low priority scaffold.**

## Paper 5 (11 files, LOCKED)

| File | Sorry | Axioms | Status |
|------|-------|--------|--------|
| OrderUnitSpace | 0 | 0 | Base types |
| SequentialProduct | 0 | 0 | S1-S7 axiom system |
| SelfModelingBridge | 0 | 1 | Bridge: SelfModelingSystem -> SequentialProduct |
| Compression | 0 | 0 | Compression maps |
| PeirceDecomp | 0 | 0 | Peirce subspaces |
| SpectralTheorem | 0 | 0 | Spectral structure |
| JordanStructure | 0 | 1 | Jordan product from SP |
| LocalTomography | 0 | 1 | EJA type exclusion |
| CStarBridge | 0 | 1 | C*-algebra promotion |
| M2CInstance | 0 | 0 | Concrete commutative model |
| SpinFactor | 0 | 0 | Concrete non-commutative model |

Chain: SelfModelingSystem -> SPData (axiom) -> SequentialProduct -> Jordan -> LT -> C* -> QM

## Paper 6 (3 files, DONE)

| File | Sorry | Axioms | Status |
|------|-------|--------|--------|
| SelfModelingLattice | 0 | 2 | Lattice graph, forced Hamiltonian |
| AreaLaw | 0 | 6 | Area-law entanglement |
| JacobsonGR | 0 | 4 | Einstein equations via Jacobson 1995 |

## Paper 7 (9 files, 7 sorry)

| File | Sorry | Axioms | Status |
|------|-------|--------|--------|
| Octonions | 0 | 3 | DONE. Fano-plane multiplication |
| Albert | 3 | 1 | jordan_identity, simple, not_special (expository, no downstream use) |
| NonComposability | 3 | 4 | BLOCKED: EJAComposite structure too thin for BGW theorem |
| UniverseAlgebra | 0 | 0 | DONE. universe_contains_h3O proved |
| F4 | 1 | 7 | stab_complex_conjugate needs G_2 transitivity |
| ObserverInterface | 0 | 2 | DONE |
| GaugeGroup | 0 | 3 | DONE |
| Chirality | 0 | 8 | DONE |
| RhoJ | 0 | 1 | DONE. rho_J uniqueness |

Core chain (UniverseAlgebra -> GaugeGroup -> Chirality): 0 sorry, fully proved from axioms.

## Papers 1-4 (1 file, 15 sorry)

| File | Sorry | Axioms | Status |
|------|-------|--------|--------|
| ExperientialMeasure | 15 | 10 | Low priority scaffold. 9 sorry defs + 6 sorry theorems |

## Blockers

### NonComposability (3 sorry, STRUCTURAL)
`EJAComposite` has only `composite : SimpleEJA`, `proj_A`, `proj_B`. Missing:
- Embedding fields `A.carrier -> composite.carrier`
- No-signaling constraint
- Product state separation
Without these, the BGW exchange lemma and downstream results can't be proved.
**Fix requires changing the `EJAComposite` type signature.**

### F4 stab_complex_conjugate (1 sorry, INFRASTRUCTURE)
Needs G_2 transitivity on S^6 (unit imaginary octonions) to conjugate complex structures.
G_2 action axiomatized in Octonions but no infrastructure for constructing conjugating automorphisms.

### Albert (3 sorry, HARD ALGEBRA)
- `jordan_identity`: degree-4 identity in 27-dimensional algebra. 500+ lines brute force.
- `simple`: no nontrivial Jordan ideals. Needs spectral decomposition of h_3(O).
- `not_special`: Albert 1934 / Glennie identity. Needs either dimension argument or polynomial identity.
All expository — not referenced downstream. The downstream code uses axioms (`only_albert_exceptional`, `zelmanov_uniqueness`).

### ExperientialMeasure (15 sorry, MEASURE THEORY)
9 sorry defs need measure theory / spectral theory (stationaryDist, spectralGap, etc.).
6 sorry theorems blocked by the sorry defs.
All low priority — Papers 1-4 scaffold.
