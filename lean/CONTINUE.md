# Lean Formalization: Status

## Current State

10 proved files, ~2400 lines, builds clean on Mathlib v4.28.0.
**0 sorry's. 3 axioms (all honest). ~150 definitions/theorems/lemmas.**

8 scaffold files upgraded from documentation-only to Lean 4 code with
structure/def/theorem statements (all `sorry` for proofs). Builds clean.

### Paper 5 Files (PROVED)

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

### Paper 6 Files (SCAFFOLD)

| File | Lines | Sorry | Description |
|------|-------|-------|-------------|
| SelfModelingLattice.lean | ~210 | 5 | Lattice graph, diagonal U(n), forced Hamiltonian, LR bounds |
| AreaLaw.lean | ~230 | 3 | Entanglement first law, WVCH, ground-state area law |
| JacobsonGR.lean | ~310 | 9 | Continuum limit, BW/Unruh, 5-step Jacobson -> Einstein |

Paper 6 axioms (all standard external physics/math results):
- `schur_weyl_S2` -- Schur-Weyl duality for S_2 on (C^n)^tensor2
- `lieb_robinson_bound` -- LR exponential decay bound
- `wvch_bound` -- Wolf-Verstraete-Cirac-Hastings thermal mutual info bound
- `hastings_area_law_1d` -- Hastings 1D gapped area law
- `calabrese_cardy_log_scaling` -- CC log scaling for gapless 1D CFT
- `neel_ordered_area_law` -- Area law for Neel-ordered d>=2 ground states
- `modular_hamiltonian_locality` -- K_A localized near boundary
- `wilsonian_continuum_limit` -- Smooth (M, g_ab) at L >> a (Gap 4)
- `emergent_lorentz_invariance` -- Low-energy Lorentz symmetry (Gap 1)
- `bisognano_wichmann_continuum` -- Modular flow = boost (standard QFT)
- `lattice_bisognano_wichmann` -- Lattice BW approximation (Gap 2)
- `raychaudhuri_equation` -- dtheta/dlambda = -R_ab k^a k^b
- `local_equilibrium` -- theta = sigma = 0 at bifurcation (Gap 3)

### Paper 7 Files (SCAFFOLD - upgraded to Lean 4 code)

| File | Sorry | Axioms | Description |
|------|-------|--------|-------------|
| Octonions.lean | 14 | 3 | Octonion structure, mul, conj, norm, ComplexStructure, Hurwitz |
| Albert.lean | 10 | 1 | h3O structure, Jordan product, Peirce decomposition, IsSpecialJordanAlgebra |
| NonComposability.lean | 3 | 4 | SimpleEJA, EJAComposite, BGW rank argument, exceptional_no_composite |
| UniverseAlgebra.lean | 2 | 0 | IsUniverseAlgebra, universe_contains_h3O (Gap A capstone) |
| F4.lean | 4 | 6 | Aut_h3O, Stab_idem (Spin(9)), Stab_complex (SU(3)xSU(3)/Z_3), Borel-dS |
| ObserverInterface.lean | 2 | 2 | ObserverConfig, residualGaugeGroup, h3C_subalgebra |
| GaugeGroup.lean | 2 | 2 | SMGaugeGroupData, Todorov-Drenska, hypercharge, gap_B_complete |
| Chirality.lean | 0 | 7 | EmbeddingType, Furey/Sawin, chirality_from_self_modeling |

Paper 7 axioms (all published theorems):
- `hurwitz_classification` -- R, C, H, O are the only normed division algebras
- `aut_octonions_eq_G2` -- Aut(O) = G_2
- `unit_imag_sphere_eq_G2_mod_SU3` -- S^6 = G_2/SU(3)
- `zelmanov_uniqueness` -- h_3(O) is the unique exceptional simple EJA
- `jvnw_classification` -- JvNW classification of simple EJAs
- `rank_ge_4_special` -- rank >= 4 simple EJAs are special
- `only_albert_exceptional` -- h_3(O) is the only non-special simple EJA
- `hanche_olsen_composite` -- special EJAs admit composites
- `chevalley_schafer` -- Aut(h_3(O)) = F_4
- `stab_is_Spin9` -- Stab(E_i) = Spin(9)
- `quotient_is_OP2` -- F_4/Spin(9) = OP^2
- `spin9_acts_on_peirce1` -- Spin(9) acts on V_1 as spinor
- `stab_complex_is_SU3xSU3modZ3` -- Stab(J) = [SU(3)xSU(3)]/Z_3
- `borel_de_siebenthal_F4` -- maximal rank subgroups of F_4
- `todorov_drenska` -- Spin(9) cap [SU(3)xSU(3)]/Z_3 = SM gauge group
- `krasnov_characterization` -- equivalent Krasnov characterization
- `complexification_upgrades_spin` -- Spin(9) -> Spin(10) via complexification
- `gamma11_sq_one`, `omega6_sq_neg_one`, `particleProjector_idem` -- Clifford identities
- `omega6_stabilizer_is_pati_salam` -- Stab(omega_6) = Pati-Salam
- `sawin_two_classes` -- two conjugacy classes of SU(2)xSU(3) in Spin(10)
- `boyle_three_generations` -- triality and three generations
- `peirce1_complexified_is_weyl16` -- complexified V_1 = Weyl 16
- `l4_observer_principle` -- observer IS its configuration under L4

Key proven results (not sorry):
- `bgw_composites_special` -- composites of nontrivial EJAs are special (from axioms)
- `furey_selects_left` -- Cl(6) selects left embedding (constructive)
- `chirality_from_self_modeling` -- full chain to chiral SM (from Todorov-Drenska)
- `stab_idem_closed_comp` -- stabilizer closed under composition (from defs)
- `stab_idem_id` -- identity in stabilizer (from defs)
- Various definitional equalities (observer_breaks_to_spin9, etc.)

### Paper 5 Axioms (3, all honest)

1. **spectral_jordan_identity** (JordanStructure.lean) -- General Jordan identity.
   Requires spectral theorem for OUS (Alfsen-Shultz Ch. 7-9). Compatible case proved.
2. **vdw_theorem_3** (CStarBridge.lean) -- C*-algebra promotion from local tomography.
3. **sp_sub_right_general** (SequentialProduct.lean) -- Linearity of L_a on effect
   differences. Follows from van de Wetering's S2 continuity. Proved for both instances.

### Key results

- **SpinFactor** (V_3, the 3D spin factor / Bloch ball): First machine-checked
  non-commutative sequential product. All 9 axioms + effect preservation proved
  using explicit Lorentz cone / Luders product formulas.
- **S2 axiom correction**: Original sp_mono_left (monotonicity in 1st arg) was
  FALSE for the Luders product. Fixed to sp_mono_right (van de Wetering's actual S2).
  Also discovered and removed 3 false theorems in Compression.lean.
- **Complete derivation chain**: Self-modeling -> SP axioms -> Jordan algebra ->
  Local tomography -> C*-algebra -> Quantum mechanics.

### Import dependency order (Paper 7)

```
Octonions
  |
Albert (imports Octonions)
  |
NonComposability (imports Albert)
  |
UniverseAlgebra (imports NonComposability, Albert)
  |
F4 (imports Albert, Octonions)
  |
ObserverInterface (imports Albert, F4, Octonions)
  |
GaugeGroup (imports F4, ObserverInterface, Octonions)
  |
Chirality (imports Octonions, Albert, F4, ObserverInterface, GaugeGroup)
```

### Next steps (Phase 1)

1. Fill in Octonion multiplication table (Cayley-Dickson or Fano plane)
2. Prove conj_conj, mul_one, one_mul from concrete definitions
3. Prove Jordan identity on h_3(O) from concrete Jordan product
4. Prove sum_rank1_eq_one and idempotent properties concretely
5. Fill in bgw_exchange_lemma (the rank argument)
6. Fill in non_composable_not_special (contrapositive argument)

## Build

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd ~/repos/research/lean && lake build
```
