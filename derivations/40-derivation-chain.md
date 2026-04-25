# Derivation Chain v10.0: Self-Modeling to Einstein Equations on h_3(O)

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, coupling_convention=J_gt_0_AFM, modular_hamiltonian=K_A=-ln(rho_A), kms_temperature=beta=2pi, clifford=Cl(9,0)_{T_a,T_b}=(1/2)delta_{ab}I

**Phase:** 40-assembly-all-gaps-closed, Plan 01
**Date:** 2026-03-30

**Purpose:** Assemble the complete v10.0 derivation chain from self-modeling axiom to Einstein equations with every link citing specific v10.0 equation numbers from Phases 37--39. This chain operates on the real exceptional Jordan algebra $\mathfrak{h}_3(\mathbb{O})$, not the Heisenberg toy model of v9.0.

**Convention note:** Lorentzian signature $(-,+,+,+)$ for emergent spacetime. Riemannian $(+,\ldots,+)$ for spatial Fisher metric and lattice sigma model. $K_A = -\ln\rho_A$ (positive operator). $\beta_{\text{phys}} = 2\pi/a$.

---

## v9.0 vs v10.0 Comparison

The v9.0 chain (derivations/36-derivation-chain.md) had 6 links (a)--(f) based on the Heisenberg antiferromagnet toy model with $O(3)$ symmetry and sigma model target $S^2$. The v10.0 chain has 12 links (a')--(l), with links (a')--(h') covering the real algebra and self-modeler network, and links (i)--(l) carrying forward the emergent geometry and gravity results.

| Aspect | v9.0 Chain | v10.0 Chain |
|--------|-----------|-------------|
| Starting algebra | Generic $M_n(\mathbb{C})^{\text{sa}}$ | $\mathfrak{h}_3(\mathbb{O})$ (maximal exceptional Jordan) |
| Links | 6: (a)--(f) | 12: (a')--(l) |
| On-site representation | Generic spin-$S$ ($\dim = 2S+1$) | $V_{1/2} = \mathbb{R}^{16}$, Cl(9,0) spinors |
| Symmetry | $O(3)$ | $\text{Spin}(9)$ (explicit $F_4 \to \text{Spin}(9)$) |
| SSB pattern | $O(3) \to O(2)$ | $\text{Spin}(9) \to \text{Spin}(8)$ |
| Sigma model target | $S^2$ (dim 2) | $S^8$ (dim 8) |
| Goldstone modes | 2 (Type-A) | 8 (Type-A) |
| Spin-wave velocity | $c_s = 1.659\,Ja$ (QMC, $\mathbb{Z}^2$) | $c_s = J\sqrt{3/2} = 1.225\,Ja$ (classical, $\mathbb{Z}^3$) |
| Sigma model | $O(3)$ NL sigma, $\rho_s = 0.181J$ | $O(9)$ NL sigma, $\rho_s = J/8 = 0.125J$ |
| LR velocity ratio | $v_{LR}/c_s = 7.63$ ($\mathbb{Z}^1$) | $v_{LR}/c_s \approx 60$ ($\mathbb{Z}^3$) |
| SRF | $0.9993$ (computed, Heisenberg) | $\approx 1$ (universality argument, not computed) |
| UC verification | Assumed (well-known for O(3)) | Explicitly verified: UC1--UC4 (Phase 39) |

---

## Link Status Summary Table

| Link | Description | Source | Equation | Rigor | Conditions |
|------|------------|--------|----------|-------|------------|
| **(a')** | Self-modeling $\to$ composite observer | Paper 5 | published result | ASSUMED (axiom) | Unconditional |
| **(b')** | $M_n(\mathbb{C})^{\text{sa}}$ uniqueness $\to$ $\mathfrak{h}_3(\mathbb{O})$ | Paper 7 | published result | STRUCTURAL (JvNW classification is rigorous; non-composability argument is structural) | Non-composability premise: universe's algebra is non-special |
| **(c')** | Peirce decomposition: $V_1 + V_{1/2} + V_0$, $T_b$ operators | Paper 7 / Phase 28 | $\{T_a, T_b\} = \tfrac{1}{2}\delta_{ab}I_{16}$ | RIGOROUS | Unconditional |
| **(d')** | $H_{\text{eff}} = J\sum T_a^{(i)}T_a^{(j)}$ on Cl(9,0) spinors | Phase 38 | Section 1.1 (boxed: Frame stabilizer = Spin(9)) | RIGOROUS | Unconditional |
| **(e')** | Frame stabilizer Spin(9), $\mathbb{Z}^d$ bipartite, $\det = 0$ on $\mathbb{OP}^2$ | Phase 38 | Sections 1.6, 2.3, 3.3 (boxed results) | RIGOROUS | Unconditional |
| **(f')** | SSB: Spin(9) $\to$ Spin(8) on $S^8$, 8 Type-A Goldstones | Phase 39 | Plans 01--02 (boxed: $G = \text{Spin}(9) \to H = \text{Spin}(8)$; $n_A = 8, n_B = 0$) | RIGOROUS classical / CONDITIONAL quantum | Classical: unconditional ($d \geq 3$). Quantum: conditional ($S_{\text{eff}} = 1/2$, Speer obstruction) |
| **(g')** | O(9) NL sigma model on $S^8$, Friedan beta, AF | Phase 39 | Plan 03 (boxed: sigma action; Eq. 39.8: beta function) | RIGOROUS | Unconditional (kinematic: follows from SSB pattern) |
| **(h')** | UC1--UC4 verified (classical) | Phase 39 | Plan 04 (derivations/39-universality-class.md Sections 1--4) | RIGOROUS classical / CONDITIONAL quantum | Classical: UC1--UC4 all verified. Quantum: UC1, UC4 conditional on quantum SSB |
| **(i)** | Fisher manifold from sigma model correlations | Phases 32--33, 41 | CORR-03, Eq. (33.19); FISH-01 Eq. (32.8); O(9): Eqs. (41.19, 41.22--23) | CONDITIONAL | H1--H4 (H1 SATISFIED $d \geq 3$, conditional quantum SSB; H2--H4 SATISFIED) |
| **(j)** | Emergent Lorentz from sigma model rescaling | Phases 34, 41 | Eq. (34.9); O(9): $c_s = J\sqrt{3/2}$ (Eq. 41.6), $v_{LR}/c_s \approx 60$ (Eq. 41.12) | PHYSICAL ARGUMENT | Sigma model universality; DLS RP; classical $c_s$ only |
| **(k)** | BW + KMS: $K_A = 2\pi K_{\text{boost}}$, $\beta = 2\pi$ | Phases 35, 41 | Eqs. (35.0a), (35.8), (35.3); O(9) BW: Eq. (41.17) | CONDITIONAL | UC5 (Wightman / lattice-BW by universality; SRF $\approx 1$, not computed numerically for O(9)) |
| **(l)** | Jacobson $\to$ Einstein: $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ | Phase 37 | Eq. (37.6) (Gap C); Eq. (37.12) (Gap D) | CONDITIONAL-DERIVED (C) / CONDITIONAL-THEOREM (D) | Gap C: UC5, UC6, UC8, UC9, UC10. Gap D: UC5, CS, TL. $G_N$ inherits O(9) value via $c_s$. |

---

## Detailed Link Narratives

### Link (a'): Self-Modeling Axiom

**What it establishes:** The foundational postulate. An observer with finite-dimensional Hilbert space $\mathcal{H}_{\text{obs}}$ ($\dim < \infty$) that must contain a faithful model of the system it observes requires a composite structure $\mathcal{H} = \mathcal{H}_{\text{sys}} \otimes \mathcal{H}_{\text{obs}}$.

**Source:** Paper 5 (published result).
**Rigor:** ASSUMED (axiom). This is the starting postulate of the framework.
**Conditions:** Unconditional -- this is the axiom from which everything follows.
**Classical/quantum status:** N/A (framework-level axiom).

### Link (b'): $M_n(\mathbb{C})^{\text{sa}}$ Uniqueness and $\mathfrak{h}_3(\mathbb{O})$

**What it establishes:** The self-adjoint part of the observable algebra $M_n(\mathbb{C})^{\text{sa}}$ is a formally real Jordan algebra. Among the exceptional Jordan algebras, $\mathfrak{h}_3(\mathbb{O})$ (27-dimensional, over the octonions) is the maximal one: it is the largest simple formally real Jordan algebra that is not a special Jordan algebra (i.e., not embeddable in an associative algebra).

The identification of $\mathfrak{h}_3(\mathbb{O})$ as the arena rests on the non-composability argument: (1) self-modeling $\to$ Jordan algebra [proved, Paper 5], (2) the universe cannot be a subsystem of a larger composite [structural premise], (3) every special Jordan algebra embeds in an associative algebra and therefore admits tensor products [BGW theorem], (4) contrapositive: the universe's algebra is non-special = exceptional = $\mathfrak{h}_3(\mathbb{O})$ [JvNW classification].

**Source:** Paper 7 (published result). The Jordan-von Neumann-Wigner classification (1934) provides the mathematical foundation.
**Rigor:** STRUCTURAL. The JvNW classification is a mathematical theorem. The non-composability argument (step 2: "the universe cannot be a subsystem") is a structural premise, not a theorem. It is well-motivated (the universe by definition has no exterior to compose with) but not proved from the self-modeling axiom alone.
**Conditions:** Non-composability premise.
**Classical/quantum status:** N/A (algebraic classification).

### Link (c'): Peirce Decomposition and $T_b$ Operators

**What it establishes:** The Peirce decomposition of $\mathfrak{h}_3(\mathbb{O})$ under the idempotent $E_{11}$:

$$
\mathfrak{h}_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0, \quad \dim = 1 + 16 + 10 = 27
$$

The $T_b$ operators act as $T_b(v) = \Pi_{1/2}(b \circ v)$ for $b \in V_0$, mapping $V_{1/2}$ to itself. There are 9 independent $T_a$ operators ($a = 0, \ldots, 8$) satisfying the Clifford relation:

$$
\{T_a, T_b\} = \tfrac{1}{2}\delta_{ab} I_{16}
$$

This identifies $V_{1/2} \cong \mathbb{R}^{16}$ as the spinor module of $\text{Cl}(9,0)$.

**Source:** Paper 7 / Phase 28 derivations. Clifford structure verified computationally (71 tests pass, Phase 30).
**Rigor:** RIGOROUS. The Peirce decomposition is a theorem of Jordan algebra theory; the Clifford relation was verified both algebraically and computationally.
**Conditions:** Unconditional.
**Classical/quantum status:** N/A (algebraic structure).

### Link (d'): Effective Hamiltonian $H_{\text{eff}}$

**What it establishes:** The bilinear nearest-neighbor Hamiltonian on $V_{1/2}^{(i)} \otimes V_{1/2}^{(j)}$:

$$
H_{\text{eff}} = J \sum_{\langle ij \rangle} \sum_{a=0}^{8} T_a^{(i)} \otimes T_a^{(j)}
$$

acting on $\mathbb{R}^{16}$ per site. The 2-site spectrum has 5 levels with energies $E/J = \{-7/4, -3/4, 1/4, 5/4, 9/4\}$ and multiplicities $\{9, 84, 126, 36, 1\}$ corresponding to $\Lambda^k(V_9)$ irreps of Spin(9). The ground state is $\Lambda^1(V_9)$ (vector representation, dim 9): FERROMAGNETIC.

**Source:** derivations/38-lattice-and-symmetry.md, Section 1. Boxed result: Frame stabilizer = Spin(9) (dim 36).
**Rigor:** RIGOROUS. Spectrum computed exactly by diagonalization; Spin(9) symmetry verified by three independent methods (algebraic argument, commutator computation, spectral decomposition).
**Conditions:** Unconditional.
**Classical/quantum status:** N/A (exact lattice result).

### Link (e'): Frame Stabilizer, Bipartite Lattice, Cubic Assessment

**What it establishes:** Three structural results:

1. **Frame stabilizer = Spin(9)** (dim 36), the maximal subgroup of $F_4$ stabilizing the Peirce decomposition. The explicit breaking is $F_4 \to \text{Spin}(9)$ (built into $H_{\text{eff}}$). $\|[H_2, J_u^{\text{total}}]\|_F = 24.0$ confirms $H_{\text{eff}}$ does NOT commute with $F_4$ generators outside Spin(9).

2. **Physical lattice = $\mathbb{Z}^d$** (bipartite, DLS-compatible). The Peirce graph $K_3$ is on-site algebraic structure, NOT the physical lattice. DLS reflection positivity applies to $\mathbb{Z}^d$.

3. **$\det(A) = 0$ on $\mathbb{OP}^2$ identically** (rank-1 projections). The cubic $F_4$-invariant vanishes on the physical order parameter space, so the bilinear $H_{\text{eff}}$ is sufficient.

**Source:** derivations/38-lattice-and-symmetry.md, Sections 1.6, 2.3, 3.3 (boxed results).
**Rigor:** RIGOROUS. All three results are exact (algebraic and computational).
**Conditions:** Unconditional.
**Classical/quantum status:** N/A (structural lattice results).

### Link (f'): Spontaneous Symmetry Breaking

**What it establishes:** The SSB pattern for $H_{\text{eff}}$ on $\mathbb{Z}^d$:

$$
\text{Spin}(9) \xrightarrow{\text{spontaneous}} \text{Spin}(8)
$$

The ordered state selects a direction $\mathbf{n} \in S^8 \subset \mathbb{R}^9$, breaking Spin(9) to its stabilizer Spin(8) (dim 28). Number of broken generators: $36 - 28 = 8$. Goldstone manifold: $S^8 = \text{Spin}(9)/\text{Spin}(8)$.

**Goldstone type:** All 8 modes are Type-A (linear dispersion $\omega_a(\mathbf{k}) = c_s|\mathbf{k}|$). The Watanabe-Murayama matrix $\rho_{ab} = \langle\text{GS}|[Q_a, Q_b]|\text{GS}\rangle = 0$ exactly, because the real Clifford representation forces the antisymmetric bilinear to vanish on real states. Therefore $n_B = 0$, $n_A = 8$.

**Classical SSB proof:** FSS infrared bounds (Froehlich-Simon-Spencer 1976, Biskup 2006). The classical O(9) model on $\mathbb{Z}^d$ satisfies all RP conditions (RP1--RP5). Critical temperature: $\beta_c J = 2.2746$ (from Watson integral $I_3 = 0.5055$). Spontaneous magnetization: $m^2 \geq 1 - I_d/\beta J > 0$ for $\beta > \beta_c$.

**Quantum SSB status:** CONDITIONAL. The effective spin $S_{\text{eff}} = 1/2$ is too small for the BCS argument. The Speer obstruction blocks quantum reflection positivity. Alternative approaches (mean-field heuristic, direct ED scaling) may eventually prove quantum SSB but are not available.

**Source:** derivations/39-ssb-proof.md (boxed: $G = \text{Spin}(9) \to H = \text{Spin}(8)$); derivations/39-goldstone-modes.md (boxed: $n_A = 8, n_B = 0$).
**Rigor:** RIGOROUS classical ($d \geq 3$, FSS bounds). CONDITIONAL quantum ($S_{\text{eff}} = 1/2$).
**Conditions:** Classical: unconditional for $d \geq 3$. Quantum: conditional on quantum SSB proof.
**Classical/quantum status:** Classical SSB PROVED. Quantum SSB CONDITIONAL.

### Link (g'): O(9) Nonlinear Sigma Model

**What it establishes:** The low-energy effective theory for the 8 Goldstone modes is the O(9) nonlinear sigma model on $S^8$:

$$
S[\mathbf{n}] = \frac{\rho_s}{2} \int d^d x \, (\partial_\mu \mathbf{n})^2, \quad \mathbf{n} \in S^8 \subset \mathbb{R}^9
$$

with spin stiffness $\rho_s = J/8$ and coupling $g^2 = 8T/J$.

The Ricci tensor of $S^8$ is $R_{ij} = 7g_{ij}$ (constant positive curvature). The Friedan beta function is:

$$
\mu\frac{dg^2}{d\mu} = -(d-2)g^2 + \frac{7}{2\pi}g^4 + O(g^6)
$$

The model is **asymptotically free** in $d = 2$ (and super-renormalizable for $d > 2$).

Homotopy: $\pi_k(S^8) = 0$ for $k = 1, \ldots, 7$. No topological terms (theta, WZW, Skyrmions) in $d \leq 7$.

**Source:** derivations/39-sigma-model.md. Boxed results: sigma action (Section 2.2), $\text{Ric}(S^8) = 7g$ (Section 4.2), beta function Eq. 39.8 (Section 5.2), AF (Section 5.3), homotopy (Section 6).
**Rigor:** RIGOROUS. The sigma model construction follows from the SSB pattern; the Friedan beta function is a standard result; homotopy groups are mathematical theorems.
**Conditions:** Unconditional (kinematic consequence of the SSB pattern).
**Classical/quantum status:** N/A (effective field theory construction).

### Link (h'): UC1--UC4 Verification

**What it establishes:** All four universality class properties required by the Phase 37 gap dependency theorem:

| UC | Property | Status | Evidence |
|----|----------|--------|----------|
| UC1 | Gapless excitations: $\omega(\mathbf{k}) \to 0$ as $\mathbf{k} \to 0$ | VERIFIED | Goldstone theorem from Spin(9) $\to$ Spin(8) SSB; 8 Type-A modes with $\omega = c_s|\mathbf{k}|$ |
| UC2 | Algebraic correlation decay: $C(r) \sim r^{-(d-2)}$ | VERIFIED | Massless Goldstone propagator $1/k^2$ gives $C(r) \sim \Gamma(d/2-1)/(4\pi^{d/2}\rho_s \cdot r^{d-2})$ |
| UC3 | Isotropy: cubic anisotropy RG irrelevant | VERIFIED | Hasenbusch exponent $\rho > 2$ for $O(N \geq 3)$ by monotonicity; cubic anisotropy irrelevant for $O(9)$ |
| UC4 | OS reflection positivity | VERIFIED classical | DLS RP on bipartite $\mathbb{Z}^d$; quantum RP conditional on quantum SSB ($S_{\text{eff}} = 1/2$, Speer) |

**Quantum conditionality:** UC1 and UC4 share the same root conditionality -- quantum SSB. Both trace to $S_{\text{eff}} = 1/2$ and the Speer obstruction. This is not two independent conditions but one shared condition.

**Source:** derivations/39-universality-class.md, Sections 1--4.
**Rigor:** RIGOROUS classical. CONDITIONAL quantum (UC1, UC4).
**Conditions:** Classical: all four verified. Quantum: UC1, UC4 conditional on quantum SSB.
**Classical/quantum status:** Classical: COMPLETE. Quantum: CONDITIONAL.

### Historical Note: Links (i)--(l) Model-Specific Numbers

**Note:** Links (i)--(l) were originally derived in Phases 32--35 for the Heisenberg model (v9.0). Phase 41 recomputed all model-specific numbers for the O(9)/$S^8$ sigma model. The structural arguments are model-independent; only the quantitative values have been updated. See derivations/41-o9-quantitative-results.md for the full computation.

| Aspect | Structural (model-independent) | Quantitative (updated to O(9) in Phase 41) |
|--------|-------------------------------|-------------------------------------------|
| Fisher metric from correlations | CORR-03 theorem applies to any sigma model with LRO | $\rho_s = J/8$, $C(r) = 16/(\pi J r)$ in $d = 3$ (Eq. 41.22--41.23) |
| Emergent Lorentz | Sigma model rescaling + DLS RP | $c_s = J\sqrt{3/2} = 1.225\,Ja$ (classical), $v_{LR}/c_s \approx 60$ (Eq. 41.6, 41.12) |
| BW + KMS | BW theorem + Tomita-Takesaki (model-independent) | $H_{\text{ent}} = (2\pi/c_s(\text{O}(9)))\sum x_\perp h_{\mathbf{x}}$ with O(9) $c_s$ and $h_{\mathbf{x}}$ (Eq. 41.17); SRF $\approx 1$ by universality (not computed numerically) |
| Jacobson $\to$ Einstein | Argument is model-independent | $G_N$ inherits O(9)-specific value via $c_s$; structural result unchanged |

### Link (i): Fisher Manifold from Sigma Model Correlations

**What it establishes:** A smooth, positive-definite spatial Riemannian metric $g_F(x)$ on the reduced states $\rho_\Lambda(x)$:

$$
g_F(x) = O(m_s^2) > 0 \quad \text{at interior points}
$$

conditional on hypotheses H1--H4 (CORR-03 theorem, verified for O(9) in Phase 41). For gapped systems, FISH-01 gives exponential smoothness (Eq. (32.8)). For the gapless ordered phase ($d \geq 3$), CORR-03 provides the conditional result.

**O(9) correlation function (Phase 41, Eq. 41.22):** The total connected order-parameter correlator for $O(9)/S^8$ with $N - 1 = 8$ Goldstone modes and $\rho_s = J/8$:

$$
C(r) = \frac{8\,\Gamma(d/2 - 1)}{4\pi^{d/2}\,(J/8)\,r^{d-2}} = \frac{64\,\Gamma(d/2 - 1)}{4\pi^{d/2}\,J\,r^{d-2}}
$$

In $d = 3$: $C(r) = 16/(\pi J r)$ (Eq. 41.23).

**CORR-03 hypothesis status for O(9) (Phase 41, Part E):**
- **H1 (LRO):** SATISFIED for $d \geq 3$ -- classical SSB $\text{Spin}(9) \to \text{Spin}(8)$ proved via FSS (Phase 39). Quantum SSB conditional ($S_{\text{eff}} = 1/2$).
- **H2 (Goldstone stability):** SATISFIED -- 8 Type-A modes with stable $\omega = c_s|\mathbf{k}|$, $c_s > 0$ (Phase 39).
- **H3 (full-rank $\rho_\Lambda$):** SATISFIED -- generic property of finite subsystems.
- **H4 (OBC):** SATISFIED -- applies to bounded subregions of $\mathbb{Z}^d$.

**Source:** derivations/32-fisher-geometry-theorems.md, Eq. (32.8) (FISH-01); derivations/33-fisher-smoothness-algebraic-decay.md, Eq. (33.19) (CORR-03). Phase 41 derivation: derivations/41-o9-quantitative-results.md, Part E.
**Rigor:** CONDITIONAL on H1--H4 (H1 now SATISFIED for O(9), $d \geq 3$, conditional on quantum SSB).
**Conditions:** H1 (LRO: SATISFIED classical $d \geq 3$, conditional quantum), H2 (Goldstone stability: SATISFIED), H3 (full-rank $\rho_\Lambda$: SATISFIED), H4 (OBC: SATISFIED).
**Classical/quantum status:** All four hypotheses verified for O(9) in Phase 41. H1 conditional on quantum SSB.

### Link (j): Emergent Lorentz Invariance

**What it establishes:** The combined spacetime metric:

$$
ds^2 = -c_s^2\,dt^2 + g_{ij}(x)\,dx^i dx^j
$$

where the spatial part comes from the Fisher metric (Phases 32--33, verified for O(9) in Phase 41) and the temporal part from the sigma model dynamics + Wick rotation (Phase 34). The emergent speed is $c_s$ (spin-wave velocity). DLS reflection positivity on bipartite $\mathbb{Z}^d$ justifies the Wick rotation from Euclidean to Lorentzian.

**O(9) emergent speed (Phase 41, Eq. 41.6):**

$$
c_s(\text{O}(9), \mathbb{Z}^3) = J\sqrt{\tfrac{3}{2}} = 1.225\,Ja \quad (\text{classical})
$$

derived from the hydrodynamic formula $c_s^2 = \rho_s/\chi_\perp$ with $\rho_s = J/8$ (Phase 39) and $\chi_\perp = 1/(12J)$ (classical O(9) on $\mathbb{Z}^3$).

**Quantum correction caveat:** $c_s = 1.225\,Ja$ is the classical value; quantum corrections (unknown for O(9)) may reduce this by $\sim 20\%$ (O(3) analogy: classical $c_s = 2Ja$ vs QMC $c_s = 1.659\,Ja$, a 17% reduction).

**Velocity hierarchy (Phase 41, Eqs. 41.9, 41.12):**

$$
v_{LR}(\text{O}(9), \mathbb{Z}^3) = 27eJ = 73.4\,J, \quad v_{LR}/c_s \approx 60
$$

The four arguments for $c_{\text{eff}} = c_s$ (not $v_{LR}$) carry over from Phase 34 verbatim:
1. **Dispersion:** 8 Goldstone modes with $\omega = c_s|\mathbf{k}|$ -- no low-energy excitation propagates faster.
2. **EFT:** O(9) NL sigma model (Phase 39, Eq. 39.6) is Lorentz-invariant with speed $c_s$; $v_{LR}$ does not appear.
3. **Universality:** $c_s = \sqrt{\rho_s/\chi_\perp}$ is the universal IR quantity; $v_{LR} = 2e\|h_{ij}\|z$ is UV-dependent.
4. **Hamma et al. precedent:** Toric code $v_{LR}/c_{\text{photon}} = 3.84$ (PRL 102, 017204, 2009).

**Source:** derivations/34-emergent-lorentz-invariance.md, Eq. (34.9). Phase 41 derivation: derivations/41-o9-quantitative-results.md, Parts A, C, F.
**Rigor:** PHYSICAL ARGUMENT. The sigma model universality and Wick rotation arguments are physically motivated, not rigorous.
**Conditions:** Sigma model universality; DLS RP for Wick rotation (UC4). Classical $c_s$ only -- quantum corrections unknown for O(9).
**Classical/quantum status:** O(9) quantitative values computed (classical). Structural argument model-independent.

### Link (k): Bisognano-Wichmann and KMS Equilibrium

**What it establishes:** Three key results from the BW theorem and Tomita-Takesaki theory:

1. **Modular Hamiltonian:** $K_A = 2\pi K_{\text{boost}}$ (Eq. (35.0a))
2. **KMS condition:** $F_{A,B}(t + i) = \omega(\sigma_t(B)A)$ at $\beta_{\text{mod}} = 1$ (Eq. (35.8))
3. **Unruh temperature:** $T_U = a/(2\pi)$ (Eq. (35.3))

The vacuum state restricted to a Rindler wedge IS a thermal (KMS) state with respect to modular flow. KMS is DERIVED from BW + Tomita-Takesaki, not assumed.

**O(9) lattice-BW ansatz (Phase 41, Eq. 41.17):** The BW ansatz applies to the O(9) model by universality (Giudici et al. 2018): the O(9) NL sigma model is Lorentz-invariant (Phase 39). The entanglement Hamiltonian for a half-space is:

$$
H_{\text{ent}}(\text{O}(9)) = \frac{2\pi}{c_s(\text{O}(9))} \sum_{\mathbf{x}} x_\perp \, h_{\mathbf{x}}(\text{O}(9))
$$

with $c_s(\text{O}(9)) = J\sqrt{3/2}$ (Eq. 41.6) and local Hamiltonian density $h_{\mathbf{x}} = J\sum_\delta\sum_{a=0}^{8} T_a^{(\mathbf{x})}T_a^{(\mathbf{x}+\delta)}$ (Eq. 41.16).

**SRF status:** The SRF for O(9) has not been computed numerically; no QMC or DMRG study exists for the O(9) lattice model. The universality argument predicts SRF close to 1, with lattice corrections at $O(a^2/L^2)$ from irrelevant operators (Eq. 41.18). The Heisenberg value SRF $= 0.9993$ is not carried forward as an O(9) result.

**Source:** derivations/35-kms-equilibrium-and-modular-hamiltonian.md, Eqs. (35.0a), (35.8), (35.3). Phase 41 derivation: derivations/41-o9-quantitative-results.md, Part D.
**Rigor:** CONDITIONAL. BW theorem requires Wightman axioms W1--W6 (UC5). On the lattice, lattice-BW applies by universality (Lorentz invariance established for O(9), Phase 39). SRF not computed numerically for O(9).
**Conditions:** UC5 (Wightman axioms or lattice-BW equivalent). Classical $c_s$ only -- quantum corrections unknown for O(9).
**Classical/quantum status:** Structural argument model-independent; O(9) lattice-BW ansatz written with O(9)-specific $c_s$ and $h_{\mathbf{x}}$.

### Link (l): Jacobson Argument to Einstein Equations

**What it establishes:** The Einstein equation with cosmological constant:

$$
G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}
$$

via two complementary routes:

**Gap C chain** (derivations/37-gap-c-closure-chain.md): BW $\to$ $K_B$ local $\to$ entanglement first law $\to$ Raychaudhuri area deficit $\to$ Lovelock uniqueness. Tensoriality is DERIVED from the chain (symmetric 2-tensor from first law orientation independence; $\leq 2$ derivatives from Raychaudhuri; divergence-free from Bianchi). Produces Eq. (37.6):

$$
\eta\,\delta A + \delta\langle K_A\rangle = 0 \quad \Longrightarrow \quad G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}
$$

**Gap D chain** (derivations/37-gap-d-closure-chain.md): BW $\to$ Tomita-Takesaki KMS $\to$ $\beta = 2\pi$ $\to$ Gibbs variational principle $\to$ entanglement equilibrium. MVEH mathematical content ($\delta S = 0$ at first order at fixed $\langle K_A\rangle$) is a THEOREM. Produces Eq. (37.12):

$$
\delta S = 0 \quad \text{at first order, at fixed } \langle K_A \rangle
$$

**O(9) note (Phase 41):** This link is structurally model-independent -- it depends on BW + KMS (link (k)), not on the sigma model directly. Numerical prefactors ($G_N$, $\Lambda$) depend on UV data including $c_s$. With the O(9) spin-wave velocity $c_s = J\sqrt{3/2}$ (Eq. 41.6), the Newton constant $G_N$ inherits an O(9)-specific value, but the STRUCTURAL result $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ is unchanged.

**Source:** derivations/37-gap-c-closure-chain.md, Eq. (37.6); derivations/37-gap-d-closure-chain.md, Eq. (37.12).
**Rigor:** Gap C: CONDITIONAL-DERIVED. Gap D: CONDITIONAL-THEOREM.
**Conditions:** Gap C: UC5, UC6 ($d+1=4$), UC8, UC9, UC10 + Gap A NARROWED. Gap D: UC5, CS, TL. Sorce caveat: geometric form exact for $d = 1$ (conformal), approximate for $d \geq 2$ (SRF $\approx 1$ by universality for O(9), not computed numerically).
**Classical/quantum status:** The link itself does not depend on SSB directly, but it requires the upstream links (i)--(k) which do. $G_N$ inherits O(9)-specific value via $c_s$.

---

## Conditionality Summary

### Unconditional Links (no remaining assumptions beyond framework premises)

| Link | What | Why unconditional |
|------|------|-------------------|
| (a') | Self-modeling axiom | Framework axiom |
| (b') | $\mathfrak{h}_3(\mathbb{O})$ as arena | JvNW classification (rigorous) + non-composability premise (structural) |
| (c') | Peirce decomposition, Clifford structure | Jordan algebra theorem + computational verification |
| (d') | $H_{\text{eff}}$ construction and spectrum | Exact diagonalization |
| (e') | Frame stabilizer, lattice structure, cubic | Algebraic and computational results |
| (g') | Sigma model construction | Kinematic consequence of SSB pattern |

### Classical-only Links (proved for classical, conditional for quantum)

| Link | Classical status | Quantum condition |
|------|-----------------|-------------------|
| (f') | PROVED ($d \geq 3$, FSS) | Conditional: $S_{\text{eff}} = 1/2$ too small for BCS; Speer blocks quantum RP |
| (h') | UC1--UC4 all verified | UC1, UC4 conditional on quantum SSB (same root condition) |

### Conditional Links (require additional assumptions)

| Link | Conditions |
|------|------------|
| (i) | H1--H4 (H1 SATISFIED for O(9) $d \geq 3$, conditional on quantum SSB; H2--H4 SATISFIED). Phase 41 verified all hypotheses. |
| (j) | Sigma model universality; DLS RP. Classical $c_s = J\sqrt{3/2}$ only; quantum corrections unknown for O(9). |
| (k) | UC5 (Wightman axioms or lattice-BW by universality; SRF not computed numerically for O(9)). Classical $c_s$ in BW ansatz. |
| (l) | Gap C: UC5, UC6, UC8, UC9, UC10. Gap D: UC5, CS, TL. $G_N$ inherits O(9)-specific value. |

### Dimension Dependence

| Dimension | Chain Status | Key Limitation |
|-----------|-------------|----------------|
| $d = 1$ | FAILS at link (i) | FISH-03: $g_{\text{bulk}} \to 0$. Einstein tensor vanishes in $1+1$d. |
| $d = 2$ | CONDITIONAL from link (f') onward | Mermin-Wagner prevents SSB of continuous symmetry for $d \leq 2$. CORR-03 H1 is QMC-only for $S = 1/2, d = 2$. |
| $d \geq 3$ | CONDITIONAL (classical complete) | All links at least CONDITIONAL or better. Classical SSB proved. Quantum SSB conditional. Gap A NARROWED. |

---

## Complete Chain Diagram

$$
\underbrace{(a') \to (b') \to (c') \to (d') \to (e')}_{\text{Unconditional: algebraic structure}} \to \underbrace{(f') \to (g') \to (h')}_{\text{Classical-proved / quantum-conditional}} \to \underbrace{(i) \to (j) \to (k) \to (l)}_{\text{Conditional: geometry \& gravity}}
$$

The chain naturally divides into three segments:
1. **Algebraic segment (a')--(e'):** Unconditional. Establishes the mathematical structure from self-modeling to the lattice Hamiltonian. All results are rigorous.
2. **SSB segment (f')--(h'):** Classical-proved, quantum-conditional. Establishes the symmetry breaking pattern, sigma model, and universality class. Classical SSB is a theorem; quantum SSB is conditional.
3. **Gravity segment (i)--(l):** Conditional. Establishes emergent geometry and Einstein equations. Phase 41 updated all model-specific numbers to O(9). Requires Gap A hypotheses, BW, and Jacobson inputs.

**Uncertainty markers for links (j)--(k):** The O(9) spin-wave velocity $c_s = J\sqrt{3/2}$ is a classical value. Quantum corrections (unknown for O(9)) may modify $c_s$ by $\sim 20\%$ based on O(3) analogy. This propagates into the emergent metric (link (j)) and the BW ansatz prefactor $2\pi/c_s$ (link (k)). The structural content of both links is unaffected.

---

_Phase: 40-assembly-all-gaps-closed, Plan 01, Task 1_
_Completed: 2026-03-30_
