# Lean Formalization of Radical Relativity

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH" && cd ~/repos/research/lean && lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. Build must always pass - verify after every change.

## Structure

- **Paper 5** (11 files): 0 sorry, 3 axioms (all external published results). Locked for journal.
- **Paper 5 bridge**: SelfModelingBridge.lean. Self-modeling -> S1-S7 via bridge axiom. 1 axiom (`self_model_gives_sp_data`), 0 sorry. Produces `SequentialProduct V` instance from `SelfModelingSystem V`.
- **Paper 5 LT**: LocalTomography.lean. `IsLocallyTomographic` is a class (not axiom) requiring dim(composite) = dim(V)^2. Type exclusion proved for real/quaternion. Gap: no explicit theorem deriving LT from self-modeling minimality (Paper 5 Thm 5.10).
- **Paper 6** (3 files): SelfModelingLattice (0 sorry), AreaLaw (0 sorry), JacobsonGR (0 sorry). DONE.
- **Paper 7** (8 files): Octonions (0) -> Albert (3 expository) -> NonComposability (3 blocked) -> UniverseAlgebra (0) -> F4 (1 conjugacy) -> ObserverInterface (0) -> GaugeGroup (0) -> Chirality (0).
- **Papers 1-4** (1 file): ExperientialMeasure. Low priority scaffold (~15 sorry).

## Sorry inventory (as of 2026-03-28)

**22 total sorry's. 0 sorry's in Paper 5. 0 theorem sorry's on critical path that are unblocked.**

| File | Sorry | Type | Status |
|------|-------|------|--------|
| Albert | jordan_identity, simple, not_special | theorem (3) | Expository only, no downstream use |
| NonComposability | bgw_exchange_lemma | theorem | Blocked: EJAComposite missing embedding field |
| NonComposability | exceptional_no_composite, composite_iff_special | theorem (2) | Blocked: needs embedding + subalgebra-of-special lemma |
| F4 | stab_complex_conjugate | theorem | Needs G_2 transitivity infrastructure |
| ExperientialMeasure | stationaryDist, mu_stable, mu_BB, expectedExitTime, qsdMixingTime, spectralGap, kernelDiffNorm, stationaryL1Dist, BornFisherConjecture | def (9) | Low priority scaffold, need measure/spectral theory |
| ExperientialMeasure | experientialFunctional, isomorphism_invariant, theorem_A, lipschitz_*, born_fisher_falsified | theorem (6) | Blocked by sorry defs above |

## Paper 5 axiom budget (3 total, all external)

| Axiom | File | Source |
|-------|------|--------|
| `self_model_gives_sp_data` | SelfModelingBridge | Paper 5 Sections 3-4 + Alfsen-Shultz 2003 |
| `spectral_jordan_identity` | JordanStructure | vdW 2019, section 4 |
| `vdw_theorem_3` | CStarBridge | vdW 2019, Theorem 3 |

`IsLocallyTomographic` is NOT an axiom — it's a class requiring dim(composite) = dim(V)^2.
Type exclusion (real/quaternion excluded) is PROVED. The gap: no theorem yet deriving
IsLocallyTomographic from self-modeling minimality (Paper 5 Theorem 5.10).

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
- For `experientialDensity` proofs: use `by_cases` + `simp [experientialDensity, condition]` (not `unfold` + `split_ifs`, which fails on let bindings).
- `Real.add_one_le_exp` takes a real number, not a proof of nonnegativity.
- If a sorry needs 500+ lines of brute force, mark `-- TODO: requires basis expansion` and move on.

## Structural blocks

- **NonComposability**: `EJAComposite` is missing an embedding `A.carrier -> composite.carrier`. Without it, can't prove exceptional algebras can't be tensor factors. Needs type signature change to unblock.

## Import order (Paper 7)

Octonions -> Albert -> NonComposability -> UniverseAlgebra -> F4 -> ObserverInterface -> GaugeGroup -> Chirality
