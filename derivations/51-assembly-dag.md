# Assembly DAG: Self-Modeling to SM+GR via h_3(O)

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, jordan_product=(1/2)(XY+YX), octonion_basis=fano_e7, cubic_norm=det3=(1/6)d_IJK, C_IJK=(1/6)d_IJK

**Document type:** Pure assembly. Every claim cites a prior Phase or Paper. No new derivations.

**Status taxonomy:** PROVED (from self-modeling alone), DERIVED (from h_3(O) + standard math), CONDITIONAL-DERIVED (requires one unproved assumption), ASSUMED (taken as input), UNKNOWN (unresolved).

---

## 1. Directed Acyclic Graph: Nodes

### ROOT

**N1. Self-modeling axiom**
- **Statement:** A composite system S faithfully models itself: there exists a subsystem M inside S such that M's state space encodes the state of S.
- **Inputs:** None (axiom / definition).
- **Source:** Paper 5 (v2.0), Definition 1.
- **Status:** ASSUMED (axiom).

### QM BRANCH

**N2. C\*-algebra structure forced**
- **Statement:** Self-modeling forces the observer's state space to be the self-adjoint part of a finite-dimensional C\*-algebra, i.e., M_n(C)^{sa} for some n.
- **Inputs:** N1.
- **Source:** Paper 5 (v2.0), Theorem 1.
- **Status:** PROVED.

**N3. h_3(O) forced by non-composability**
- **Statement:** The requirement that the system be non-composable (cannot be decomposed as a tensor product of simpler observers) uniquely selects the exceptional Jordan algebra h_3(O) as the observer's state space. This is the only simple exceptional Jordan algebra compatible with a C\*-observer.
- **Inputs:** N2.
- **Source:** Paper 7 (v5.0), Theorem 2; Albert 1934 (classification).
- **Status:** DERIVED.

### PEIRCE DECOMPOSITION

**N4. Peirce decomposition 27 = 1 + 16 + 10**
- **Statement:** At the idempotent E_{11}, h_3(O) decomposes into Peirce eigenspaces: V_1 = span(E_{11}) (dim 1), V_{1/2} (dim 16, half-integer Peirce), V_0 = h_2(O) (dim 10, Peirce complement).
- **Inputs:** N3.
- **Source:** McCrimmon 2004 (A Taste of Jordan Algebras), Ch. 6; Paper 7; Phase 47-01 (computational verification: peirce_basis_27).
- **Status:** DERIVED (standard Jordan algebra theory applied to h_3(O)).

### SM BRANCH

**N5. V_{1/2} = 16 as SM fermion representation space**
- **Statement:** The 16-dimensional Peirce half-space V_{1/2} carries the spinor representation of Spin(9) and, upon restriction to Spin(6) = SU(4), decomposes into SM fermion quantum numbers (one generation).
- **Inputs:** N4.
- **Source:** Paper 7 (v5.0), Section 4; Phase 47-02 (quantum_number_table_27: all 16 states match Paper 7 Pati-Salam assignments).
- **Status:** DERIVED.

**N6. Complexification via C\*-observer sequential product**
- **Statement:** The C\*-observer's sequential product T_a -> sqrt(T_a) T_b sqrt(T_a) exits M_{16}(R) and forces extension of the real Clifford algebra Cl(9,0) to the complex Clifford algebra Cl(9,C).
- **Inputs:** N2, N5.
- **Source:** v11.0: Phase 42 (GO verdict: sqrt(T_a) T_b sqrt(T_a) = (i/2) T_b for anticommuting pairs), Phase 43 (C-linear closure theorem: 256 monomials span M_{16}(C)), Phase 44 (Gap C closure theorem).
- **Status:** PROVED (given Paper 5 C\*-observer structure).

**N7. Chirality from Cl(6) volume form**
- **Statement:** Complexification Cl(9,C) contains Cl(6,C), whose volume form omega_6 = (i)^3 gamma_1...gamma_6 defines a chirality grading on V_{1/2}, splitting it into left-handed and right-handed Weyl spinors.
- **Inputs:** N6.
- **Source:** Paper 7 (v5.0, updated v8.0), 9-link chain L1-L9; Phase 44 (L1-L9 verification, zero regressions).
- **Status:** CONDITIONAL-DERIVED (conditional on L1: u in S^6 choice, which is PROVED given Paper 5 per Phase 44-02).

**N8. SM gauge group from V_0 stabilizer**
- **Statement:** The stabilizer of V_0 under Spin(9) contains so(6) (dim 15) as the internal symmetry algebra, which contains the Standard Model gauge algebra g_SM = su(3) + su(2) + u(1) (dim 8).
- **Inputs:** N4, N11.
- **Source:** Phase 48-01 (V_0 stabilizer = so(3) x so(6), G_SM dim 8 contained, residual < 5e-15); compare Todorov-Drenska 2019.
- **Status:** CONDITIONAL-DERIVED. The containment g_SM subset so(6) is verified; the reduction mechanism so(6) -> g_SM is NOT derived from self-modeling.

### GR BRANCH

**N9. V_0 = h_2(O) projects via pi_u to h_2(C_u) = R^{3,1} with Minkowski signature**
- **Statement:** The Peirce complement V_0 = h_2(O) (dim 10), projected by the C\*-observer's complex structure pi_u to h_2(C_u) (dim 4), carries the Minkowski metric: det_2 Gram = diag(+1,-1,-1,-1).
- **Inputs:** N4, N2 (pi_u is the C\*-observer's projection).
- **Source:** Phase 46-01 (pi_u construction, det_2 Gram verification); Phase 46-02 (V_{1/2} x V_{1/2} -> V_0 yields Cl(3,0) Minkowski matrices).
- **Status:** DERIVED.

**N10. det(X) = unique F_4-invariant cubic on h_3(O)**
- **Statement:** The determinant det_3(X) is, up to normalization, the unique cubic form on h_3(O) invariant under F_4 = Aut(h_3(O)). Equivalently, dim Sym^3(27*)^{F_4} = 1.
- **Inputs:** N3 (h_3(O) structure determines F_4).
- **Source:** Springer 1962 (uniqueness theorem); Phase 47-02 (F_4 invariance verified computationally under S_3 x G_2 x Spin(9), 630 tests, max err < 1e-14).
- **Status:** DERIVED (Springer's theorem is a standard result in Jordan algebra theory).

**N11. V_0 stabilizer = so(3) x so(6) under Spin(9)**
- **Statement:** The subgroup of Spin(9) that stabilizes V_0 = h_2(O) (preserves the spacetime/internal split) has Lie algebra so(3) x so(6) (dim 18). The so(3) factor acts as the rotation subalgebra of the Lorentz group on h_2(C_u); the so(6) factor acts on the 6 internal directions killed by pi_u.
- **Inputs:** N4, N9.
- **Source:** Phase 48-01 (stabilizer computation via SVD null-space, Killing form classification), Phase 48-02 (so(3) eta-compatibility, pi_u equivariance for all 18 generators, max err 5.2e-17).
- **Status:** DERIVED.
- **Note on boosts:** Compact Spin(9) contains only so(3) (rotations), not so(3,1) (full Lorentz). Boosts are recovered via complexification so(3,C) = sl(2,C). This is a standard procedure but the weakest point in the Lorentz identification.

**N12. MESGT field content and prepotential**
- **Statement:** The h_3(O) algebraic structure, identified with the Gunaydin-Sierra-Townsend (GST) N=2 magic supergravity framework, determines: 1 gravity multiplet + 26 vector multiplets (n_V = 26), 54 real scalars on E_{7(-25)}/(E_{6(-78)} x U(1)), prepotential F(X) = d_{IJK} X^I X^J X^K / (6 X^0).
- **Inputs:** N3, N10.
- **Source:** GST 1983-84 (Phys Lett B 133; Nucl Phys B 242) for the MESGT framework; Phase 49-01 (field content table, prepotential construction, normalization C_{IJK} = (1/6) d_{IJK}).
- **Status:** ASSUMED for the MESGT identification (N=2 SUSY is algebraically identified, not derived from self-modeling); DERIVED for the algebraic content.

**N13. C_{IJK} coupling decomposition**
- **Statement:** The coupling tensor C_{IJK} = (1/6) d_{IJK} decomposes into three physical channels: 10 gravitational self-couplings (from (V_1, V_0, V_0) = det_2 bilinear), 48 matter-spacetime couplings, and 48 matter-internal couplings, totaling 106 nonzero entries.
- **Inputs:** N10, N12.
- **Source:** Phase 49-02 (decompose_couplings_49: grav_self [10] + matter_spacetime [48] + matter_internal [48] = 106; Eq. 49.6).
- **Status:** DERIVED.

### WEINBERG BRIDGE

**N14. Spin-2 from det_2 perturbation**
- **Statement:** Symmetric perturbations h_{ab} of the metric on h_2(C_u) = R^{3,1} decompose under SO(3,1) as 10 = 9 (spin-2, traceless symmetric, (1,1) of SL(2,C)) + 1 (spin-0, trace).
- **Inputs:** N9, N11.
- **Source:** Phase 50-01 (Proposition 1: SO(3,1) irrep decomposition, traceless projector verified idempotent rank 9; Eq. 50.2).
- **Status:** DERIVED.

**N15. Masslessness from det_3 quadratic expansion**
- **Statement:** Expanding det_3(E_{11} + epsilon * delta) around the rank-1 idempotent E_{11} gives O(epsilon^2) coefficient M_{ab} = det_2 Gram (kinetic-type), NOT Fierz-Pauli mass. The graviton mode is massless.
- **Inputs:** N10, N9.
- **Source:** Phase 50-01 (Proposition 2: det_3 quadratic expansion, M_{ab} = det_2 verified by analytical + numerical methods to 1.65e-16; Eq. 50.5, 50.6; Boulware-Deser ghost argument rules out non-FP mass).
- **Status:** DERIVED.

**N16. Universal coupling from C_{IJK} stress-energy structure**
- **Statement:** The matter-gravity coupling C_{i,j,a} restricted to spacetime V_0 directions is symmetric (C_{ija} = C_{jia}, exact for all 480 pairs), universal (all 16 V_{1/2} matter fields couple to all 4 spacetime directions), and bilinear. This is the non-derivative part of a stress-energy coupling. The trace coupling T_{ij} is nonzero (Frobenius norm 4.22).
- **Inputs:** N13, N9.
- **Source:** Phase 50-02 (Proposition 3: stress-energy identification; symmetry max err 0, universality 16 x 4 verified, trace norm 4.22).
- **Status:** DERIVED.

**N17. Weinberg 1964 theorem applies: -R/2 forced**
- **Statement:** Given a Lorentz-invariant theory containing a massless spin-2 field with universal coupling to stress-energy, Weinberg's 1964 theorem forces the low-energy effective action to contain -R/2 (Einstein-Hilbert term). All four Weinberg hypotheses are satisfied by the h_3(O) algebraic structure: H1 (Lorentz: Phase 48), H2 (spin-2: N14), H3 (massless: N15), H4 (universal coupling: N16).
- **Inputs:** N14, N15, N16, N11.
- **Source:** Weinberg 1964 (Phys Rev 135, B1049); Phase 50-02 (Theorem 1: all four hypotheses verified from h_3(O), non-circularity confirmed).
- **Status:** CONDITIONAL-DERIVED. The result is derived from algebraic inputs, but conditional on: (i) compact so(3) -> so(3,1) via complexification (standard but weakest link), (ii) Weinberg's theorem scope is low-energy/perturbative, (iii) N=2 SUSY identification in N12.

### CONVERGENCE

**N18. Complete bosonic Lagrangian**
- **Statement:** The complete 4d bosonic Lagrangian is fully sourced: -R/2 from Weinberg's theorem (N17), scalar kinetic terms + vector kinetic terms + topological term all determined by det(X) prepotential (N12, N13). Lambda = 0 for ungauged MESGT. This is Eq. (49.6) with every term cited.

$$e^{-1}\,\mathcal{L}_{\mathrm{bos}} = \underbrace{-\frac{R}{2}}_{\text{N17: Weinberg}} + \underbrace{g_{i\bar{j}}\,\partial_\mu z^i \partial^\mu \bar{z}^{\bar{j}} + \mathrm{Im}(\mathcal{N}_{IJ})\, F^I_{\mu\nu} F^{J\mu\nu} + \mathrm{Re}(\mathcal{N}_{IJ})\, F^I_{\mu\nu} {*F}^{J\mu\nu}}_{\text{N12, N13: from det}(X)}$$

- **Inputs:** N17, N12, N13.
- **Source:** Phase 49-02 (Eq. 49.6, Theorem 1); Phase 50-02 (Eq. 50.9, -R/2 sourced by Weinberg).
- **Status:** CONDITIONAL-DERIVED (inherits all conditions from N17 and N12).

---

## 2. Edge List (Directed Dependencies)

Each edge is labeled with what logical content flows along it.

| Edge | Content flowing |
|------|----------------|
| N1 -> N2 | Self-modeling axiom -> C\*-algebra theorem (Paper 5) |
| N2 -> N3 | C\*-observer structure -> non-composability forces h_3(O) (Paper 7) |
| N3 -> N4 | h_3(O) -> standard Peirce decomposition at E_{11} |
| N4 -> N5 | V_{1/2} = 16-dim Peirce half-space -> spinor representation |
| N2 -> N6 | C\*-observer sequential product -> complexification exit |
| N5 -> N6 | Cl(9,0) acting on V_{1/2} -> sequential product applied |
| N6 -> N7 | Cl(9,C) -> Cl(6,C) volume form -> chirality |
| N4 -> N8 | Peirce structure -> stabilizer computation inputs |
| N11 -> N8 | so(6) internal block -> contains g_SM |
| N4 -> N9 | V_0 = h_2(O) from Peirce -> target for pi_u |
| N2 -> N9 | C\*-observer complex structure -> pi_u projection |
| N3 -> N10 | h_3(O) determines F_4 = Aut(h_3(O)) -> uniqueness |
| N4 -> N11 | Peirce V_0 -> stabilizer computation domain |
| N9 -> N11 | h_2(C_u) spacetime metric -> eta-compatibility check |
| N3 -> N12 | h_3(O) algebraic structure -> GST identification |
| N10 -> N12 | det(X) uniqueness -> prepotential |
| N10 -> N13 | d_{IJK} tensor -> coupling decomposition |
| N12 -> N13 | Field content + normalization -> C_{IJK} physical interpretation |
| N9 -> N14 | h_2(C_u) = R^{3,1} metric -> perturbation space |
| N11 -> N14 | SO(3,1) action -> irrep decomposition |
| N10 -> N15 | det_3 -> quadratic expansion around E_{11} |
| N9 -> N15 | det_2 on h_2(C_u) -> M_{ab} identification |
| N13 -> N16 | C_{IJK} matter-spacetime block -> stress-energy analysis |
| N9 -> N16 | Spacetime V_0 directions -> restriction domain |
| N14 -> N17 | Spin-2 (Weinberg H2) |
| N15 -> N17 | Massless (Weinberg H3) |
| N16 -> N17 | Universal coupling (Weinberg H4) |
| N11 -> N17 | Lorentz invariance (Weinberg H1) |
| N17 -> N18 | -R/2 from Weinberg |
| N12 -> N18 | Matter Lagrangian terms from prepotential |
| N13 -> N18 | Coupling structure from C_{IJK} |

---

## 3. Topological Ordering

The topological sort of the DAG is:

**N1 -> N2 -> N3 -> N4 -> N5 -> N6 -> N7 -> N10 -> N9 -> N11 -> N8 -> N12 -> N13 -> N14 -> N15 -> N16 -> N17 -> N18**

**Verification:** Every directed edge (A -> B) has A appearing before B in this ordering:

| Edge | A position | B position | Forward? |
|------|-----------|-----------|----------|
| N1 -> N2 | 1 | 2 | YES |
| N2 -> N3 | 2 | 3 | YES |
| N3 -> N4 | 3 | 4 | YES |
| N4 -> N5 | 4 | 5 | YES |
| N2 -> N6 | 2 | 6 | YES |
| N5 -> N6 | 5 | 6 | YES |
| N6 -> N7 | 6 | 7 | YES |
| N4 -> N8 | 4 | 11 | YES |
| N11 -> N8 | 10 | 11 | YES |
| N4 -> N9 | 4 | 9 | YES |
| N2 -> N9 | 2 | 9 | YES |
| N3 -> N10 | 3 | 8 | YES |
| N4 -> N11 | 4 | 10 | YES |
| N9 -> N11 | 9 | 10 | YES |
| N3 -> N12 | 3 | 12 | YES |
| N10 -> N12 | 8 | 12 | YES |
| N10 -> N13 | 8 | 13 | YES |
| N12 -> N13 | 12 | 13 | YES |
| N9 -> N14 | 9 | 14 | YES |
| N11 -> N14 | 10 | 14 | YES |
| N10 -> N15 | 8 | 15 | YES |
| N9 -> N15 | 9 | 15 | YES |
| N13 -> N16 | 13 | 16 | YES |
| N9 -> N16 | 9 | 16 | YES |
| N14 -> N17 | 14 | 17 | YES |
| N15 -> N17 | 15 | 17 | YES |
| N16 -> N17 | 16 | 17 | YES |
| N11 -> N17 | 10 | 17 | YES |
| N17 -> N18 | 17 | 18 | YES |
| N12 -> N18 | 12 | 18 | YES |
| N13 -> N18 | 13 | 18 | YES |

**Result: 31 edges, all forward. Zero back-edges. The DAG is acyclic.**

---

## 4. det(X) Double Duty: Non-Circularity Statement

det(X) = det_3(X) plays two roles in the derivation chain:

1. **Self-modeling density factor (N10):** det(X) is the unique F_4-invariant cubic form on h_3(O), as proved by Springer 1962 and verified computationally in Phase 47-02 (630 tests under S_3 x G_2 x Spin(9)).

2. **GST prepotential (N12):** The same det(X) serves as the prepotential of the N=2 magic supergravity Lagrangian in the GST framework.

**Non-circularity argument:** F_4 = Aut(h_3(O)) is forced by the Jordan algebra structure (N3). The uniqueness of det(X) as an F_4-invariant cubic is a theorem in pure algebra (Springer 1962: dim Sym^3(27*)^{F_4} = 1). Both roles -- as density factor and as GST prepotential -- are consequences of this algebraic uniqueness, not of each other. Specifically:

- The density factor role follows from F_4 invariance alone (Phase 47-02).
- The GST prepotential role follows from identifying the h_3(O) algebraic structure with the GST framework (Phase 49-01), where the prepotential is determined by the cubic invariant.

Neither role requires knowledge of or reference to the other. The GST identification is the bridge (ASSUMED), but the cubic form itself is algebraically unique regardless of how it is physically interpreted.

**Source:** Phase 47-02 (double duty theorem, non-circular proof); Springer 1962.

---

## 5. Convention Reconciliation

| Convention | v12.0 (Phases 46-50) | Papers 5-7 (Jacobson route) | Resolution |
|-----------|----------------------|----------------------------|------------|
| Metric signature | (+,-,-,-) from det_2 on h_2(C_u) | (-,+,+,+) in Jacobson-route discussions | The algebraic content (Peirce structure, d_{IJK}, C_{IJK}, spin-2 decomposition) is convention-independent. Only the sign of the trace coupling flips: Tr(h) -> -Tr(h). The Weinberg theorem result -R/2 is stated in the mostly-minus convention. |
| Jordan product | (1/2)(XY + YX) | Same | No conflict. |
| Octonion basis | Fano, u = e_7 | Same | No conflict. |
| Cubic normalization | det_3(X) = (1/6) d_{IJK} X^I X^J X^K | Not explicitly used in Papers 5-7 | v12.0 normalization only. |
| C_{IJK} | (1/6) d_{IJK} | Not used in Papers 5-7 | v12.0 normalization only. |

**Key point:** The metric signature (+,-,-,-) in v12.0 is an OUTPUT of the algebra (det_2 on h_2(C_u) gives Gram = diag(+1,-1,-1,-1)), not an input convention. The choice of (-,+,+,+) in Papers 5-7 is a presentation convention that does not affect any claim in the v12.0 chain.

---

## 6. Paper 6 Independence Statement

**The old lattice/Jacobson route (Paper 6, v1-v3) is ABANDONED for this synthesis. It is NOT part of the v12.0 derivation chain.**

The v12.0 route derives Einstein gravity via:

h_3(O) -> det(X) prepotential -> GST MESGT Lagrangian -> Weinberg's theorem -> -R/2

This chain uses NONE of the following Paper 6 ingredients:
- Lattice structure (Z^d bipartite lattice)
- Jacobson thermodynamic argument (entanglement entropy -> area law -> Einstein equations)
- Bisognano-Wichmann theorem (in GR context; it was used in v9.0-v10.0 for BW/KMS)
- Continuum limit (Fisher metric smoothing, sigma model flow)
- Area law derivation
- Raychaudhuri equation (used in Paper 6 gap closure, not in v12.0)

Paper 6 appears in this document only as historical context (this section) to prevent conflation with the v12.0 algebraic route. No v12.0 node (N1-N18) cites Paper 6 as a logical input.

**Verification:** Scanning all 18 node source citations: Paper 5 (N1, N2), Paper 7 (N3, N5, N7), Springer 1962 (N10), McCrimmon 2004 (N4), GST 1983-84 (N12), Weinberg 1964 (N17), Phases 42-44 (N6), Phase 46 (N9), Phase 47 (N10), Phase 48 (N8, N11), Phase 49 (N12, N13), Phase 50 (N14, N15, N16, N17). Paper 6 does not appear. Todorov-Drenska 2019 is cited only as comparison (N8), not as logical input.

---

## 7. Status Summary Table

| Node | Statement (abbreviated) | Status | Key condition (if any) |
|------|------------------------|--------|----------------------|
| N1 | Self-modeling axiom | ASSUMED | Axiom |
| N2 | C\*-algebra forced | PROVED | -- |
| N3 | h_3(O) from non-composability | DERIVED | -- |
| N4 | Peirce 27 = 1 + 16 + 10 | DERIVED | -- |
| N5 | V_{1/2} = 16 SM fermions | DERIVED | -- |
| N6 | Complexification Cl(9,0) -> Cl(9,C) | PROVED | Given Paper 5 |
| N7 | Chirality from Cl(6) | CONDITIONAL-DERIVED | L1 (u choice) -> PROVED given Paper 5 |
| N8 | SM gauge group g_SM in so(6) | CONDITIONAL-DERIVED | so(6) -> g_SM reduction mechanism NOT derived |
| N9 | V_0 -> R^{3,1} Minkowski | DERIVED | -- |
| N10 | det(X) unique cubic | DERIVED | Springer 1962 |
| N11 | Stabilizer so(3) x so(6) | DERIVED | -- |
| N12 | MESGT field content + prepotential | ASSUMED (MESGT identification) | N=2 SUSY is INPUT, not derived |
| N13 | C_{IJK} decomposition | DERIVED | -- |
| N14 | Spin-2 from det_2 | DERIVED | -- |
| N15 | Massless from det_3 | DERIVED | -- |
| N16 | Universal coupling from C_{IJK} | DERIVED | -- |
| N17 | Weinberg -> -R/2 | CONDITIONAL-DERIVED | so(3)->so(3,1), low-energy scope, N=2 SUSY |
| N18 | Complete Lagrangian | CONDITIONAL-DERIVED | Inherits N17 + N12 conditions |

**Summary:** 1 axiom, 1 PROVED, 11 DERIVED, 3 CONDITIONAL-DERIVED, 2 ASSUMED.

---

## 8. Weinberg Non-Circularity Traces

For each of the four Weinberg hypotheses, we trace backward through the DAG to verify that no step assumes -R/2, Einstein field equations, or any other GR result.

### H1: Lorentz Invariance

**Backward trace:** N17 <- N11 <- N9 + N4

Full path to axiom:
- N11 (so(3) x so(6) stabilizer, Phase 48): computed from spin(9) action on V_0
- N9 (Minkowski signature, Phase 46): det_2 Gram on h_2(C_u) = diag(+1,-1,-1,-1)
- N4 (Peirce decomposition): standard Jordan algebra
- N3 (h_3(O)): non-composability, Paper 7
- N2 (C\*-algebra): self-modeling, Paper 5
- N1 (axiom)

**GR content check:** The so(3) rotation subalgebra comes from the compact Spin(9) stabilizer of V_0. Boosts are recovered via complexification so(3,C) = sl(2,C) -- this is a standard Lie algebra result that does not reference GR. No step in this chain invokes -R/2, Einstein equations, or the Christoffel connection.

**Verdict: CLEAN.** No GR assumption.

**Note:** The compact-to-non-compact step (so(3) -> so(3,1)) is the weakest point (CONDITIONAL-DERIVED), but it is a mathematical step (complexification), not a physical assumption about GR.

### H2: Spin-2

**Backward trace:** N17 <- N14 <- N9 + N11

Full path to axiom:
- N14 (spin-2 decomposition, Phase 50-01): SO(3,1) irrep of det_2 perturbation, 10 = 9 + 1
- N9 (Minkowski signature, Phase 46): det_2 on h_2(C_u)
- N11 (Lorentz structure, Phase 48): SO(3,1) action available for decomposition
- N4 (Peirce): determines V_0 = h_2(O) dim 10
- N3 -> N2 -> N1

**GR content check:** The spin-2 identification comes from the algebraic structure of det_2 on h_2(C_u). The traceless symmetric part (dim 9) transforms as the (1,1) representation of SL(2,C). This is representation theory on the space V_0, not a statement about gravitons or GR. The word "graviton" is applied after the fact based on Weinberg's theorem, not before.

**Verdict: CLEAN.** No GR assumption.

### H3: Masslessness

**Backward trace:** N17 <- N15 <- N10 + N9

Full path to axiom:
- N15 (massless, Phase 50-01): det_3(E_{11} + eps*delta) = eps^2 * det_2(delta), M_{ab} = det_2 Gram
- N10 (det_3 uniqueness, Phase 47, Springer 1962): F_4-invariant cubic
- N9 (det_2 on h_2(C_u), Phase 46): Minkowski metric structure
- N4 (Peirce): E_{11} is rank-1 idempotent with E_{11}# = 0
- N3 -> N2 -> N1

**GR content check:** Masslessness is established by computing the O(eps^2) coefficient of det_3 around the rank-1 idempotent E_{11}. The result M_{ab} = det_2 (kinetic-type, not Fierz-Pauli mass) follows from the algebraic identity Tr(delta# circ E) = det_2(delta). This is pure Jordan algebra computation. No Fierz-Pauli tuning is assumed -- it EMERGES from the algebraic structure. No GR content enters at any step.

**Verdict: CLEAN.** No GR assumption.

### H4: Universal Coupling

**Backward trace:** N17 <- N16 <- N13 + N9

Full path to axiom:
- N16 (universal coupling, Phase 50-02): C_{i,j,a} symmetric, universal, bilinear (stress-energy structure)
- N13 (C_{IJK} decomposition, Phase 49-02): 48 matter-spacetime + 48 matter-internal couplings
- N10 (d_{IJK} tensor, Phase 47-01): 106 nonzero entries from polarization of det_3
- N12 (prepotential, Phase 49-01): C_{IJK} = (1/6) d_{IJK}
- N3 -> N2 -> N1

**GR content check:** The coupling tensor C_{IJK} = (1/6) d_{IJK} is computed by polarizing det_3, which is a purely algebraic operation on h_3(O). Its restriction to spacetime V_0 directions gives the matter-gravity coupling C_{i,j,a}. Symmetry (480 pairs, max err 0) and universality (16 fields x 4 directions) are algebraic properties of d_{IJK}, verified computationally. The identification of this structure as "stress-energy" is a labeling earned by the algebraic properties (symmetric, universal, bilinear), not assumed from GR.

**Verdict: CLEAN.** No GR assumption.

### Non-Circularity Summary

| Hypothesis | Algebraic source | Intermediate nodes | -R/2 assumed? | GR assumed? |
|-----------|-----------------|-------------------|---------------|-------------|
| H1 (Lorentz) | Spin(9) stabilizer of V_0 | N11 <- N9, N4 | NO | NO |
| H2 (Spin-2) | det_2 perturbation irrep | N14 <- N9, N11 | NO | NO |
| H3 (Massless) | det_3 expansion (E# = 0) | N15 <- N10, N9 | NO | NO |
| H4 (Universal) | C_{IJK} stress-energy | N16 <- N13, N9 | NO | NO |

**All four Weinberg inputs trace to h_3(O) algebraic structure via N3 -> N2 -> N1. No path passes through -R/2, Einstein equations, Christoffel connection, or any other GR assumption. The -R/2 term appears ONLY as the OUTPUT of Weinberg's theorem at N17, never as input to any earlier node.**

---

## 9. Assembly Summary

The self-modeling axiom, via the unique exceptional Jordan algebra h_3(O), determines:

1. **Quantum mechanics** (Paper 5: C\*-algebra) [PROVED]
2. **Standard Model fermion content** (Paper 7: V_{1/2} = 16 of Spin(9), one generation) [DERIVED]
3. **Chirality** (Paper 7 + v11.0: Cl(9,C) -> Cl(6) volume form) [PROVED given Paper 5]
4. **Minkowski spacetime** (Phase 46: V_0 -> R^{3,1} via pi_u) [DERIVED]
5. **Matter-gravity couplings** (Phase 49: det(X) prepotential determines full bosonic Lagrangian) [DERIVED given MESGT identification]
6. **Einstein gravity -R/2** (Phase 50: Weinberg from algebraic inputs, non-circular) [CONDITIONAL-DERIVED]

### Conditions and Assumptions

The chain is CONDITIONAL ON:

- **N=2 SUSY algebraic identification (ASSUMED):** The MESGT framework is identified with the h_3(O) algebraic structure by matching field content and prepotential. N=2 SUSY is not derived from self-modeling; it is the mathematical framework in which the algebraic data is organized. This is the entry point for the full Lagrangian (N12).

- **Compact so(3) complexification to so(3,1) (CONDITIONAL-DERIVED):** The stabilizer computation (Phase 48) gives compact so(3) rotations. Full Lorentz invariance requires boosts, recovered via complexification so(3,C) = sl(2,C). This is a standard mathematical operation but is the weakest structural link in the H1 chain.

- **Weinberg low-energy scope (CONDITIONAL-DERIVED):** Weinberg's 1964 theorem is a statement about the low-energy effective action. It does not constrain UV completion. Higher-derivative corrections (R^2, R_{abcd}^2, ...) are not excluded but are suppressed at low energies.

- **Lambda = 0 (ASSUMED in ungauged MESGT):** The ungauged N=2 MESGT has no cosmological constant at tree level. A nonzero Lambda would require gauging or quantum corrections not addressed here.

### NOT DERIVED from self-modeling

The following are explicitly outside the scope of this chain:

- **3 generations:** The Peirce decomposition gives 27 = 1 + 16 + 10, which accommodates one generation. The origin of three generations is not addressed. (Possible avenue: Peirce tower over h_3(O) x h_3(O) x h_3(O), but not pursued here.)

- **so(6) -> G_SM reduction mechanism:** The V_0 stabilizer contains so(6), which contains g_SM = su(3) + su(2) + u(1) (Phase 48). But the mechanism that reduces so(6) to precisely g_SM is not derived from self-modeling. Compare Todorov-Drenska 2019 for an F_4 intersection argument.

- **Lambda != 0:** No mechanism for a positive cosmological constant is provided.

- **Full fermionic sector:** Only the bosonic Lagrangian (Eq. 49.6 / 50.9) is assembled. The N=2 MESGT also predicts gravitinos and gauginos, but these are not included in the v12.0 chain.

- **Quantum corrections:** Everything is at tree level. Loop corrections, anomalies, and RG running are not addressed.

- **UV completion:** Weinberg's theorem is low-energy. The self-consistent UV completion of the theory is not addressed by this chain.

### What det(X) Does and Does Not Do

**det(X) IS:** The unique F_4-invariant cubic on h_3(O) (Springer 1962). It serves as the prepotential of the MESGT Lagrangian, determining all matter-gravity coupling constants C_{IJK} = (1/6) d_{IJK}.

**det(X) DOES NOT:** Derive -R/2 directly. The Einstein-Hilbert term -R/2 is forced by Weinberg's theorem from the algebraic properties that det(X) provides (spin-2, massless, universal coupling). det(X) provides the INPUT to Weinberg; -R/2 is the OUTPUT of Weinberg. This distinction is essential for non-circularity.

---

## 10. Source Citation Registry

Every node cites at least one source. No node is uncited.

| Node | Primary source | Secondary source | Phase/Paper |
|------|---------------|------------------|-------------|
| N1 | Paper 5, Def. 1 | -- | Paper |
| N2 | Paper 5, Thm. 1 | -- | Paper |
| N3 | Paper 7, Thm. 2 | Albert 1934 | Paper |
| N4 | McCrimmon 2004, Ch. 6 | Phase 47-01 | Paper + Phase |
| N5 | Paper 7, Sec. 4 | Phase 47-02 | Paper + Phase |
| N6 | Phases 42-44 | Paper 5 (C\*) | Phase |
| N7 | Paper 7, L1-L9 | Phase 44 | Paper + Phase |
| N8 | Phase 48-01 | Todorov-Drenska 2019 (comparison) | Phase |
| N9 | Phase 46-01, 46-02 | -- | Phase |
| N10 | Springer 1962 | Phase 47-02 | Paper + Phase |
| N11 | Phase 48-01, 48-02 | -- | Phase |
| N12 | GST 1983-84 | Phase 49-01 | Paper + Phase |
| N13 | Phase 49-02 | -- | Phase |
| N14 | Phase 50-01, Prop. 1 | -- | Phase |
| N15 | Phase 50-01, Prop. 2 | Boulware-Deser | Phase + Paper |
| N16 | Phase 50-02, Prop. 3 | -- | Phase |
| N17 | Weinberg 1964 | Phase 50-02, Thm. 1 | Paper + Phase |
| N18 | Phase 49-02, Eq. 49.6 | Phase 50-02, Eq. 50.9 | Phase |

**Zero uncited nodes. Zero nodes citing Paper 6 as logical input.**
