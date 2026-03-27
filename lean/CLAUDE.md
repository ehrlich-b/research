# Lean Formalization of Radical Relativity

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH" && cd ~/repos/research/lean && lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. Build must always pass - verify after every change.

## Structure

- **Paper 5** (10 files): DONE - 0 sorry, 3 axioms. Do not touch.
- **Paper 6** (3 files): Scaffold. SelfModelingLattice, AreaLaw, JacobsonGR.
- **Paper 7** (8 files): Scaffold. Octonions -> Albert -> NonComposability -> UniverseAlgebra -> F4 -> ObserverInterface -> GaugeGroup -> Chirality.
- **Papers 1-4** (1 file): ExperientialMeasure. Low priority scaffold.

## Rules

- **Axioms are honest citations** of published theorems we don't re-prove. Never add new axioms.
- **Sorry = unproved claim.** Fill sorry's, don't add new ones.
- **Don't change type signatures.** The statements are correct; only proofs are missing.
- **Don't refactor structure/API.** Keep all existing types, defs, and theorem names.
- **Don't touch downstream files** when working on upstream ones (e.g. don't edit Albert.lean when filling Octonions.lean sorry's).
- **Build incrementally.** `lake build` after every sorry elimination.
- **No native_decide on unverifiable propositions, no sorry hidden behind opaque defs.**

## Proof strategy

- For concrete algebra (Octonions, Albert): expand in components, use `ext`, `fin_cases`, `simp`, `ring`.
- For chain theorems: compose from axioms and definitions.
- If a sorry needs 500+ lines of brute force, mark `-- TODO: requires basis expansion` and move on.

## Import order (Paper 7)

Octonions -> Albert -> NonComposability -> UniverseAlgebra -> F4 -> ObserverInterface -> GaugeGroup -> Chirality
