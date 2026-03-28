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

10 files, ~2400 lines, **0 sorry's**, 3 axioms (published theorems).

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

**Axioms** (3, all published theorems we cite rather than re-prove):

| Axiom | Source | What it says |
|-------|--------|-------------|
| `spectral_jordan_identity` | van de Wetering, Alfsen-Shultz | General Jordan identity via spectral decomposition |
| `vdw_theorem_3` | van de Wetering + Barnum-Wilce + Hanche-Olsen | EJA + local tomography = C*-algebra |
| `sp_sub_right_general` | van de Wetering S2 continuity | Linearity of measurement maps on effect differences |

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

### Paper 7: h_3(O) --> SM Gauge Group (PARTIAL)

The conceptual chain is complete (both gaps closed, 2026-03-23). Octonions and
Albert algebra core are proved. Scaffold files cover the remaining chain.

| File | Status | Sorry | Axioms | Description |
|------|--------|-------|--------|-------------|
| `Octonions.lean` | **DONE** | **0** | 3 | Fano-plane mul, all identities proved, Hurwitz/G2/S6 axioms |
| `Albert.lean` | **7/10** | 3 | 1 | jordanMul, det, idempotents, formally_real, Peirce proved. 3 hard sorry remain |
| `RhoJ.lean` | **DONE** | **0** | 1 | rho_J uniqueness theorem, boundary conditions, concrete evaluations |
| `NonComposability.lean` | Scaffold | 3 | 4 | BGW rank argument, exceptional_no_composite |
| `UniverseAlgebra.lean` | Scaffold | 2 | 0 | universe_contains_h3O (Gap A capstone) |
| `F4.lean` | Scaffold | 4 | 6 | Aut_h3O, Stab_idem (Spin(9)), Stab_complex, Borel-dS |
| `ObserverInterface.lean` | Scaffold | 2 | 2 | ObserverConfig, residualGaugeGroup, h3C_subalgebra |
| `GaugeGroup.lean` | Scaffold | 2 | 2 | SMGaugeGroupData, Todorov-Drenska, hypercharge |
| `Chirality.lean` | Scaffold | 0 | 7 | EmbeddingType, Furey/Sawin, chirality_from_self_modeling |

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
