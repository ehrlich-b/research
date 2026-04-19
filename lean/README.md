# Radical Relativity: Lean 4 Formalization

Lean 4 formalization of the [Radical Relativity](https://github.com/ehrlich-b/research)
research program. The goal: machine-verify the chain from self-modeling to the
Standard Model gauge group.

## The Chain

```
L4: all consistent structures exist                          [premise]
  |
  v
Self-modeling --> sequential product --> S1-S7 --> Jordan algebra
  |                                                    |
  |                                                    v
  |                                              Local tomography
  |                                                    |
  |                                                    v
  |                                              Complex QM (Paper 5)
  |
  v
Universe = maximal non-composable self-modeling structure     [L4 + BGW]
  |
  v
h_3(O) is the unique non-composable simple Jordan algebra    [JvNW + Zelmanov]
  |
  +---> Aut(h_3(O)) = F_4 --> SM gauge group                 [Todorov-Drenska]
  |
  +---> rho_J = det(X)*(Tr(X^2) - 1/3) is UNIQUE            [Paper 1, theorem]
         within h_3(O) at minimal degree
         --> cubic-vs-quadratic consciousness prediction
```

Every step is either the premise, a definition, a published theorem, or
a proved result from the program. The rho_J uniqueness theorem is the
program's most distinguishing falsifiable prediction: consciousness
depends on a cubic invariant (det, three-way product of Peirce sectors),
not a quadratic one (IIT's phi, pairwise integration).

## Current Status

### Paper 5: Self-Modeling --> QM (FORMALIZED)

11 files, **0 sorry's**, 17 axioms across the Paper 5 chain.

The complete derivation chain is machine-verified:

```
Self-modeling premise
  --> Sequential product on effects (S1-S7 axioms)
  --> Euclidean Jordan algebra (van de Wetering Theorem 1)
  --> Local tomography excludes real, quaternionic, spin, exceptional types
  --> Only complex type survives: V = M_n(C)^sa
  --> C*-algebra with involution (van de Wetering Theorem 3)
  --> Quantum mechanics
```

**Axioms** (17 in the Paper 5 chain):

- `SelfModelingBridge.lean` (15): 8 cite Alfsen-Shultz 2003 / OUS theory;
  1 is the named Paper 5 §3.3 postulate `S0_peirce_coherence` (Peirce
  Coherence at compression-OUS level), defended in the paper via three
  canonical models + recovery from AS Prop. 7.50; 6 are SCAFFOLD internal
  to Paper 5 (`diagonal_peirce_vanish`, `compress_annihilates_peirce1`,
  `peirce1_annihilates_compress`, `peirce1_orthogonal_idem`,
  `selfModelProduct_nonneg`, `self_modeling_locally_tomographic`).
  The four Peirce scaffolds are §3.3 Peirce-Preservation Lemma corollaries,
  derivable in the paper from S0 + compression-additivity on orthogonal
  pairs; they remain Lean axioms pending formal compression-additivity.
- `JordanStructure.lean` (1): `spectral_jordan_identity` (van de Wetering, Alfsen-Shultz)
- `CStarBridge.lean` (1): `vdw_theorem_3` (van de Wetering Theorem 3)

**Concrete models** (S1-S7 verified from scratch, no axioms):
- `SpinFactor`: The 3D spin factor (Bloch ball). First machine-checked non-commutative
  sequential product. All 9 axioms proved using explicit Lorentz cone / Luders formulas.
  ~1050 lines.
- `M2CInstance`: Commutative (diagonal) sequential product. All axioms proved.

### Paper 6: Self-Modeling Lattice --> GR (SCAFFOLDING)

The derivation chain: self-modeling lattice with forced Heisenberg Hamiltonian
produces area-law entanglement, which feeds into Jacobson's 1995 thermodynamic
argument to yield Einstein's field equations.

| File | Status | Description |
|------|--------|-------------|
| `SelfModelingLattice.lean` | SCAFFOLD | Lattice graph, diagonal U(n) covariance, forced H = Σ J·F, Lieb-Robinson |
| `AreaLaw.lean` | SCAFFOLD | Entanglement first law, WVCH bound, ground-state area law, modular Hamiltonian locality |
| `JacobsonGR.lean` | SCAFFOLD | Continuum limit, Lorentz invariance, BW/Unruh, 5-step Jacobson → G_ab + Λg_ab = 8πG_N T_ab |

Four gaps (all standard, none bespoke): (1) emergent Lorentz invariance d≥2,
(2) lattice Bisognano-Wichmann, (3) local equilibrium, (4) continuum limit.

### Paper 7: h_3(O) --> SM Gauge Group (CHAIN COMPLETE)

The full chain NonComposability → Chirality is sorry-free as of 2026-03-29
(commits 229aa99, 328886c, ce21913). Albert retains 3 expository sorry's
(jordan_identity, simple, not_special) that are not load-bearing downstream.

| File | Status | Sorry | Axioms | Description |
|------|--------|-------|--------|-------------|
| `Octonions.lean` | **DONE** | **0** | 3 | Fano-plane mul, all identities proved, Hurwitz/G2/S6 axioms |
| `Albert.lean` | Expository | 3 | 1 | jordanMul, det, idempotents, formally_real, Peirce proved. 3 sorry expository only |
| `RhoJ.lean` | **DONE** | **0** | 1 | rho_J uniqueness theorem, boundary conditions, concrete evaluations |
| `NonComposability.lean` | **DONE** | **0** | 4 | BGW rank argument, exceptional_no_composite |
| `UniverseAlgebra.lean` | **DONE** | **0** | 0 | universe_contains_h3O (Gap A capstone) |
| `F4.lean` | **DONE** | **0** | 7 | Aut_h3O, Stab_idem (Spin(9)), Stab_complex incl. stab_complex_conjugate, Borel-dS |
| `ObserverInterface.lean` | **DONE** | **0** | 1 | ObserverConfig, residualGaugeGroup, h3C_subalgebra |
| `GaugeGroup.lean` | **DONE** | **0** | 2 | SMGaugeGroupData (factor dims 1+3+8 + hypercharges), Todorov-Drenska, Krasnov |
| `Chirality.lean` | **DONE** | **0** | 9 | EmbeddingType, typed `cl6_determines_embedding` + `furey_cl6_selects_left` (Furey 2018) |

Note: JMP review of Paper 7 (prose) = MAJOR REVISION. Adversarial subagent
2026-04-16 identified Step 3 embedding ι: M_16(ℝ) → M_n(ℂ) as glossed-over
"standard inclusion" that is actually load-bearing for the complexification
crux. Not yet reflected in Lean (likely needs new axiom or lemma once the
paper-level decision lands).

### Roadmap

- **Phase A**: Octonions -- **COMPLETE**. 14 sorry -> 0.
- **Phase B**: Albert algebra -- **7/10**. 3 hard sorry remain (jordan_identity, simple, not_special).
- **Phase B2**: rho_J uniqueness -- **COMPLETE**. 0 sorry, 1 axiom.
- **Phase C**: Paper 6 algebraic core (forced_hamiltonian_form).
- **Phase D**: Paper 7 chain (NonComposability through Chirality). Blocked on Phase B.
- **Phase E**: Paper 6 physics bridge (Jacobson algebraic steps).
- **Phase F**: Papers 1-4 polish.

See `ROADMAP.md` for full details.

## The Key Insight

Both "gaps" in the chain (why h_3(O)? why SM specifically?) close by the same move:
under Tegmark L4, mathematical structure IS physical reality. There is no gap between
"the algebra admits composites" and "the system can be composed." The universe IS the
non-composable structure. The observer IS the C*-system whose self-model of octonions
IS a complex structure. The algebra IS the physics.

## Build

```bash
# Requires elan (Lean version manager)
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
cd lean && lake build
```

## References

- Ehrlich, "Spacetime from Self-Modeling" (Paper 6): [PDF](https://ehrlich.dev/papers/spacetime-from-self-modeling-2026.pdf)
- Ehrlich, "QM from Self-Modeling" (Paper 5): [PDF](https://ehrlich.dev/papers/qm-from-self-modeling-2026.pdf)
- van de Wetering, "Sequential product spaces are Jordan algebras," [arXiv:1803.11139](https://arxiv.org/abs/1803.11139)
- Barnum, Graydon, Wilce, "Composites and Categories of Euclidean Jordan Algebras," [arXiv:1606.09331](https://arxiv.org/abs/1606.09331)
- Todorov, Drenska, "Octonions, exceptional Jordan algebra and the role of the group F_4 in particle physics," [arXiv:1805.06739](https://arxiv.org/abs/1805.06739)
- Boyle, "The Standard Model, the Exceptional Jordan Algebra, and Triality," [arXiv:2006.16265](https://arxiv.org/abs/2006.16265)
- Furey, "SU(3)_C x SU(2)_L x U(1)_Y as a symmetry of division algebraic ladder operators," [arXiv:1806.00612](https://arxiv.org/abs/1806.00612)
- Krasnov, "SO(9) characterisation of the Standard Model gauge group," [arXiv:1912.11282](https://arxiv.org/abs/1912.11282)
- Jacobson, "Thermodynamics of spacetime: the Einstein equation of state," PRL 75, 1260 (1995)
- Lieb, Robinson, "The finite group velocity of quantum spin systems," CMP 28, 251 (1972)
- Wolf, Verstraete, Cirac, Hastings, "Area Laws in Quantum Systems," PRL 100, 070502 (2008)
- Hastings, "An area law for one-dimensional quantum systems," JSTAT P08024 (2007)

## License

Apache 2.0
