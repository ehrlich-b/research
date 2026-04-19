# Lean Formalization of Radical Relativity

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH" && cd ~/repos/research/lean && lake build
```

Lean 4 v4.28.0, Mathlib v4.28.0. Build must always pass - verify after every change.

## Structure

- **Paper 5** (11 files): 0 sorry, 2 axioms (spectral_jordan_identity, vdw_theorem_3). Locked for journal.
- **Paper 5 bridge**: SelfModelingBridge.lean. Self-modeling -> S1-S7 via corrected product construction. 0 sorry. 15 axioms (8 external AS 2003 / OUS citations + 1 Paper 5 postulate `S0_peirce_coherence` [§3.3] + 4 Peirce scaffolds [§3.3 Peirce-Preservation Lemma corollaries, pending formal derivation from S0 + compression additivity] + 1 `selfModelProduct_nonneg` + 1 `self_modeling_locally_tomographic` for Thm 5.10). **10/10 SPData fields proved.** `SelfModelingSystem` includes nontriviality (Definition 1 condition i).
- **Paper 5 LT**: LocalTomography.lean. `IsLocallyTomographic` is a class (not axiom) requiring dim(composite) = dim(V)^2. Type exclusion proved for real/quaternion. 0 sorry.
- **Paper 6** (3 files): SelfModelingLattice (0 sorry), AreaLaw (0 sorry), JacobsonGR (0 sorry). DONE.
- **Paper 7** (8 files): Octonions (0) -> Albert (3 expository) -> NonComposability (**0**) -> UniverseAlgebra (0) -> F4 (**0**) -> ObserverInterface (0) -> GaugeGroup (0) -> Chirality (0). `SimpleEJA` enforces Jordan identity + commutativity. `SMGaugeGroupData` encodes factor decomposition (1+3+8) + hypercharges. Chirality derived from typed `cl6_determines_embedding` + `furey_cl6_selects_left` axioms.
- **Papers 1-4** (1 file): ExperientialMeasure. Low priority scaffold (14 sorry).

## Sorry inventory (as of 2026-04-19)

**17 total sorry's, 67 axioms. 0 sorry's in Paper 5. 0 sorry's in Paper 7 chain (NonComposability through Chirality).**

| File | Sorry | Type | Status |
|------|-------|------|--------|
| Albert | jordan_identity, simple, not_special | theorem (3) | Expository only, no downstream use |
| ExperientialMeasure | stationaryDist, experientialFunctional, mu_stable, mu_BB, expectedExitTime, qsdMixingTime, spectralGap, BornFisherConjecture | def (8) | Low priority scaffold, need measure/spectral theory |
| ExperientialMeasure | isomorphism_invariant, theorem_A, lipschitz_stability, lipschitz_constant_explicit, lipschitz_uniform_bound, born_fisher_falsified | theorem (6) | Blocked by sorry defs above |

## Full axiom inventory (67 axioms, as of 2026-04-19)

### Paper 5 chain: 17 axioms — all load-bearing, all typed

| File | Axioms | Source |
|------|--------|--------|
| SelfModelingBridge | 15 | 8 external citations (AS 2003 / OUS theory) + 1 Paper 5 postulate (`S0_peirce_coherence`, §3.3) + 4 Peirce scaffolds (§3.3 Peirce-Preservation Lemma corollaries) + 1 our theorem (`selfModelProduct_nonneg`) + 1 Theorem 5.10 (`self_modeling_locally_tomographic`) |
| JordanStructure | 1 (`spectral_jordan_identity`) | vdW 2019, section 4 |
| CStarBridge | 1 (`vdw_theorem_3`) | vdW 2019, Theorem 3 |

The former bridge axiom `self_model_gives_sp_data` is ELIMINATED — replaced by `def`.
**10/10 SPData fields are proved.** S2 (monotonicity) proved from `selfModelProduct_nonneg`
(PSD coefficient matrix positivity, our theorem) + linearity.

`IsLocallyTomographic` is NOT an axiom — it's a class requiring dim(composite) = dim(V)^2.
Type exclusion (real/quaternion excluded) is PROVED. `self_modeling_locally_tomographic`
axiom (Theorem 5.10) bridges SelfModelingSystem to IsLocallyTomographic.

### Paper 6: 13 axioms — all True placeholders (structural documentation)

| File | Axioms | Notes |
|------|--------|-------|
| SelfModelingLattice | 2 | schur_weyl_S2 (Schur-Weyl), lieb_robinson_bound (LR 1972) |
| AreaLaw | 5 | 3 proved external (WVCH, Hastings, Calabrese-Cardy), 1 OPEN PROBLEM (neel_ordered), 1 CONJECTURE (modular_hamiltonian) |
| JacobsonGR | 6 | 2 proved external (BW continuum, Raychaudhuri), 4 OPEN PROBLEMS/CONJECTURES (Gaps 1-4) |

### Paper 7: 26 axioms — mostly True placeholders

| File | Axioms | Notes |
|------|--------|-------|
| Octonions | 3 | hurwitz (typed), aut_G2 + S6=G2/SU3 (True placeholders) |
| Albert | 1 | zelmanov_uniqueness (True placeholder) |
| NonComposability | 4 | 2 typed (rank_ge_4_special, hanche_olsen), 2 weak (jvnw rank-only, only_albert rank-only) |
| F4 | 7 | 6 True placeholders + g2_transitive_complex_structures (typed, proves stab_complex_conjugate) |
| ObserverInterface | 1 | peirce1_complexified (True placeholder) |
| GaugeGroup | 2 | todorov_drenska (vacuous exists), krasnov (True, preprint) |
| Chirality | 9 | 7 True placeholders + cl6_determines_embedding (typed, Furey 2018) + furey_cl6_selects_left (typed, Furey 2018). boyle_three_generations is SPECULATIVE |
| RhoJ | 1 | f4_invariant_ring (True placeholder) |

### Papers 1-4: 9 axioms — mixed

| File | Axioms | Notes |
|------|--------|-------|
| ExperientialMeasure | 9 | 2 cleanly typed+cited (basin_partition, cho_meyer), 1 True (gleason), 5 bound sorry defs, 1 is our assembly not external (stable_measure_lower_bound) |

### Axiom honesty categories

- **Typed + cited external results** (17): Paper 5 external citations (10 — 8 AS 2003 / OUS theory in SelfModelingBridge + `spectral_jordan_identity` + `vdw_theorem_3`), basin_partition, cho_meyer_bound, fannes_audenaert, rank_ge_4_special, hanche_olsen_composite, hurwitz_classification, g2_transitive_complex_structures, cl6_determines_embedding, furey_cl6_selects_left
- **Paper 5 postulates** (1): `S0_peirce_coherence` (§3.3, compression-level Peirce coherence; defended in paper via three canonical models + recovery from AS Prop. 7.50).
- **Paper 5 scaffolds** (6): `diagonal_peirce_vanish`, `compress_annihilates_peirce1`, `peirce1_annihilates_compress`, `peirce1_orthogonal_idem` (§3.3 Peirce-Preservation Lemma corollaries), `selfModelProduct_nonneg` (Paper 5 §3 PSD argument), `self_modeling_locally_tomographic` (Paper 5 Thm 5.10).
- **True placeholders** (33): All Paper 6, most Paper 7, gleason_theorem. Structural documentation only; contribute nothing to any proof term.
- **Open problems / conjectures** (6): neel_ordered_area_law, wilsonian_continuum_limit, emergent_lorentz_invariance, lattice_bisognano_wichmann, modular_hamiltonian_locality, local_equilibrium. All labeled with STATUS.
- **Bounds on sorry defs** (5): ExperientialMeasure Lemmas 2-6. Axioms about undefined quantities.
- **Speculative** (1): boyle_three_generations. Labeled.

## Rules

- **Axioms are either (a) honest citations of external published results, (b) named Paper 5 postulates defended in the paper, or (c) scaffold/open-problem markers.** New axioms require explicit justification in one of these categories; see "Axiom honesty categories" above.
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

- **NonComposability**: ALL sorry's eliminated. Universe polymorphism resolved by pinning `EJAComposite` and related theorems to a shared universe via `universe u in`. `composite_iff_special` uses `ULift.{u} ℝ` as concrete nontrivial special witness.

## Import order (Paper 7)

Octonions -> Albert -> NonComposability -> UniverseAlgebra -> F4 -> ObserverInterface -> GaugeGroup -> Chirality
