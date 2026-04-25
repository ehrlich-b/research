# Derivation Chain: Finite-Dimensional Observer to Einstein Equations

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, fisher_metric=SLD, coupling_convention=J_gt_0_AFM, emergent_speed=c_s=1.659Ja, modular_hamiltonian=K_A=-ln(rho_A), kms_temperature=beta=2pi

**Phase:** 36-assembly-and-gap-scoring, Plan 01
**Date:** 2026-03-30

**Purpose:** Assemble the complete derivation chain from finite-dimensional observer (Paper 5) to Einstein equations (Jacobson 2016) with every logical link explicit, every assumption classified by rigor level, and every prior result cited by equation number. This is requirement ASBL-01.

**References:**
- Paper 5 -- Finite-dimensional observer, C*-algebraic setting
- Paper 6 -- SWAP lattice, area law, four gaps, Links L1-L5
- Jacobson, PRL 116 (2016) 201101, arXiv:1505.04753 -- Entanglement equilibrium
- Lovelock, JMP 12 (1971) 498; JMP 13 (1972) 874 -- Uniqueness of Einstein tensor
- Casini-Huerta-Myers, JHEP 1105:036 (2011), arXiv:1102.0440 -- Conformal modular Hamiltonian
- Phases 32-35 derivation files (cited by equation number below)

**Convention note:** The convention_lock records metric_signature as "(+,+,...,+) Riemannian Fisher metric" for the spatial part. The full emergent spacetime metric uses Lorentzian signature $(-,+,\ldots,+)$ as established in Phase 34 (Eq. (34.11)). The Fisher metric is **spatial only** (Riemannian). The temporal component $-c_s^2 dt^2$ comes from the sigma model, not from Fisher geometry.

---

## Link Status Summary Table

| Link | What It Establishes | Source | Rigor Level | Dimension Dependence |
|------|-------------------|--------|-------------|---------------------|
| **(a)** Finite-dim observer | Observer has finite-dim Hilbert space; self-modeling requires composite $\mathcal{H}_{\rm sys} \otimes \mathcal{H}_{\rm obs}$ | Paper 5 | ASSUMED (axiom) | Universal |
| **(b)** SWAP lattice | $H_{\rm SWAP} \equiv H_{\rm Heis} + \text{const}$; unique ground state; area-law $S_{\rm UV} = \eta A$ | Paper 6 | RIGOROUS (lattice) / CONDITIONAL (area law) | Universal (lattice); area law depends on phase |
| **(c)** Correlation structure & Fisher manifold | Smooth, positive-definite spatial Riemannian metric $g_F(x)$ on reduced states | Phases 32--33 | RIGOROUS (gapped) / FAILS (1D) / CONDITIONAL ($d \geq 2$ Neel) | See dimension table |
| **(d)** Emergent Lorentz invariance | $ds^2 = -c_s^2 dt^2 + g_{ij} dx^i dx^j$ with $c_s = 1.659\,Ja$, $c_{\rm eff} = c_s$ | Phase 34 | PHYSICAL ARGUMENT | $d \geq 2$ (sigma model); $d = 1$: WZW CFT |
| **(e)** BW theorem & local equilibrium | $K_A = 2\pi K_{\rm boost}$; KMS at $\beta = 2\pi$; $T_U = a/(2\pi)$; $\theta = \sigma = 0$ at bifurcation | Phase 35 | CONDITIONAL ($K_A$) / RIGOROUS ($\theta = \sigma = 0$, once boost identified) | $d = 1$: exact (CFT); $d \geq 2$: lattice-BW numerical |
| **(f)** Jacobson $\to$ Einstein | $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ with $G_N = 1/(4\eta)$ | Jacobson 2016 + Paper 6 | CONDITIONAL (both routes have remaining gaps) | $d = 1$: $G_{ab} = 0$ trivially; $d \geq 2$: full Einstein |

---

## Link (a): Finite-Dimensional Observer

**What it establishes:** The starting axiom of the framework.

1. The observer has a finite-dimensional Hilbert space $\mathcal{H}_{\rm obs}$ with $\dim \mathcal{H}_{\rm obs} = n < \infty$.
2. The self-modeling requirement (the observer must contain a faithful representation of the system it observes) forces a composite structure $\mathcal{H} = \mathcal{H}_{\rm sys} \otimes \mathcal{H}_{\rm obs}$.
3. The C*-algebraic setting provides the mathematical framework: observable algebras are finite-dimensional matrix algebras $M_n(\mathbb{C})$.
4. The finite dimension $n$ serves as the UV cutoff of the theory -- the lattice spacing $a$ is determined by $n$.

**Source:** Paper 5 (finite-dimensional observer, C*-algebraic setting).

**Rigor level:** ASSUMED. This is the starting axiom of the framework. It is not derived from more fundamental principles; it is the foundational postulate.

**Dimension dependence:** Universal -- the finite-dimensional observer axiom does not depend on the spatial dimension $d$.

---

## Link (b): SWAP Lattice

**What it establishes:** The lattice Hamiltonian and its ground-state entanglement structure.

1. **SWAP-Heisenberg equivalence:** The SWAP Hamiltonian $H_{\rm SWAP} = J \sum_{\langle ij \rangle} P_{ij}$ is related to the Heisenberg Hamiltonian by $H_{\rm SWAP} = H_{\rm Heis} + \tfrac{1}{2} J N_{\rm bonds}$ (Phase 33 Plan 01, derivations/33-correlation-decay-and-sigma-model.md, preamble). The constant shift does not affect the ground state, dynamics, or correlation functions.

2. **Unique ground state:** The ground state is unique for any finite $N$ on a bipartite lattice (Perron-Frobenius in the Marshall basis + Lieb-Mattis theorem for AFM).

3. **Area-law entanglement entropy:** Paper 6 Links L1-L5 establish $S_{\rm UV} = \eta A$ (area-proportional UV entanglement entropy).
   - For gapped systems: area law is rigorously proved (Hastings 2007 in 1D; higher-$d$ proved for specific models).
   - For the gapless Neel phase ($d \geq 2$): area law holds with logarithmic corrections from Goldstone modes; this is a physical argument supported by extensive numerical evidence, not a theorem.

**Rigor level:** RIGOROUS for the lattice construction and ground-state uniqueness. CONDITIONAL for the area-law entanglement in the Neel phase (proved for gapped systems; physical argument for gapless Neel with Goldstone corrections).

**Dimension dependence:** The lattice construction is universal. The area-law status depends on the phase of matter.

---

## Link (c): Correlation Structure and Fisher Manifold

**What it establishes:** A smooth, positive-definite **spatial** (Riemannian) metric on the manifold of reduced states $\rho_\Lambda(x)$.

**CRITICAL:** The Fisher metric is SPATIAL only. It does NOT provide spacetime or Lorentzian structure. It is a Riemannian metric on the space of lattice positions, measuring how distinguishable neighboring reduced density matrices are.

### FISH-01: Smoothness (Phase 32)

For a finite-range lattice Hamiltonian with unique ground state and spectral gap $\gamma > 0$:

$$
\| \rho_\Lambda(x+1) - \rho_\Lambda(x) \|_1 \leq C_1 \exp\bigl(-R(x)/\xi\bigr)
$$

where $R(x) = \min(x, N - x - |\Lambda|)$ is the distance to the nearest chain boundary and $\xi = O(v_{\rm LR}/\gamma)$ is the correlation length.

**Source:** derivations/32-fisher-geometry-theorems.md, Eq. (32.8). Based on Hastings-Koma (CMP 265, 781, 2006).

**Rigor:** RIGOROUS for gapped systems at finite $N$.

### FISH-02: Positive-Definiteness (Phase 32)

The SLD Fisher metric satisfies $g(x) > 0$ at all interior lattice points (away from the Z_2 reflection-symmetry center), provided $\rho_\Lambda(x)$ has full rank and the chain has OBC.

**Source:** derivations/32-fisher-geometry-theorems.md, Theorem 2 (following Eq. (32.9)).

**Rigor:** RIGOROUS at finite $N$ with OBC.

### FISH-03: Distance Non-Recovery in 1D (Phase 32) -- NEGATIVE RESULT

The bulk Fisher metric vanishes in the thermodynamic limit for the 1D Heisenberg chain:

$$
g_{\rm bulk}(N) \sim A \cdot N^{-\alpha}, \quad \alpha \approx 2.75 \pm 0.3 \;(|\Lambda| = 2)
$$

Therefore $d_{\rm Fisher}/d_{\rm lattice} \to 0$ as $N \to \infty$.

**Source:** derivations/32-fisher-geometry-theorems.md, Eqs. (32.12), (32.15).

**Rigor:** RIGOROUS NEGATIVE RESULT. The 1D chain is gapless ($\gamma \sim \pi^2 J/N$), translation invariance is restored in the bulk, and the Fisher metric collapses.

### CORR-01: Two-Tier Correlation Decay (Phase 33)

- **Gapped tier:** Hastings-Koma exponential clustering, Eq. (33.1). RIGOROUS.
- **Neel tier ($d \geq 2$):** Long-range order $m_s > 0$ with algebraic transverse correlations $\langle n_\perp(\mathbf{r}) n_\perp(\mathbf{0}) \rangle \sim A/|\mathbf{r}|^{d-1}$ from Goldstone modes, Eq. (33.6).
  - $S \geq 1$, $d \geq 3$: Neel order rigorous (Dyson-Lieb-Simon 1978), Eq. (33.2).
  - $S = 1/2$, $d = 3$: Neel order rigorous (Kennedy-Lieb-Shastry 1988).
  - $S = 1/2$, $d = 2$: Neel order established by QMC ($m_s = 0.3074$, Sandvik 2025), NOT rigorously proved.

**Source:** derivations/33-correlation-decay-and-sigma-model.md, Eqs. (33.1), (33.2), (33.6).

### CORR-02: O(3) NL Sigma Model (Phase 33)

The low-energy effective theory is the O(3) nonlinear sigma model:

$$
S_{\rm eff} = \frac{1}{2g} \int d^d x \, d\tau \left[\frac{(\partial_\tau \mathbf{n})^2}{c_s^2} + (\nabla \mathbf{n})^2\right], \quad \mathbf{n}^2 = 1
$$

with $c_s = \sqrt{\rho_s/\chi_\perp} = 1.659\,Ja$ (QMC match to 0.3%).

**Source:** derivations/33-correlation-decay-and-sigma-model.md, Eqs. (33.11), (33.14).

**Rigor:** PHYSICAL ARGUMENT with strong numerical support. The sigma model is the expected low-energy theory by universality, but a rigorous derivation from the lattice Hamiltonian does not exist.

### CORR-03: Conditional Fisher Smoothness for $d \geq 2$ Neel Phase (Phase 33)

The sublattice alternation mechanism gives:

$$
g_F(x) = O(m_s^2) > 0 \quad \text{at interior points}
$$

conditional on hypotheses H1--H4:
- H1: Neel LRO ($m_s > 0$)
- H2: Goldstone fluctuations do not destroy sublattice structure
- H3: Full-rank reduced density matrix
- H4: OBC (or boundary that breaks translation invariance)

**Source:** derivations/33-fisher-smoothness-algebraic-decay.md, Eqs. (33.18), (33.19).

**Rigor:** CONDITIONAL. The argument is sound given H1--H4, but H1 is not rigorously proved for $S = 1/2$, $d = 2$.

### Dimension Table for Link (c)

| Result | $d = 1$ | $d = 2$ | $d \geq 3$ |
|--------|---------|---------|-------------|
| FISH-01 (smoothness) | RIGOROUS (finite $N$, gap $\sim 1/N$) | N/A (gapless Neel) | N/A (gapless Neel) |
| FISH-02 (positive-def) | RIGOROUS (finite $N$) | Expected (H3) | Expected (H3) |
| FISH-03 (distance recovery) | **FAILS** ($g_{\rm bulk} \sim N^{-2.75}$) | CONDITIONAL (H1--H4) | CONDITIONAL (H1--H4) |
| CORR-03 ($g_F > 0$ in Neel) | N/A ($m_s = 0$ in 1D) | $O(m_s^2) > 0$ with $\log L$ correction | $O(m_s^2) > 0$, Goldstone integral convergent |
| Neel order rigorous? | NO (Mermin-Wagner) | NO (QMC only for $S = 1/2$) | YES ($S \geq 1$: DLS 1978; $S = 1/2$: KLS 1988) |

---

## Link (d): Emergent Lorentz Invariance

**What it establishes:** The emergent spacetime metric $ds^2 = -c_s^2 dt^2 + g_{ij} dx^i dx^j$ with invariant speed $c_s = 1.659\,Ja$.

### LRNZ-01: Emergent Isotropy (Phase 34)

Cubic anisotropy from the square lattice has coefficient $\alpha_4 = -1/96$ at the lattice scale and is RG irrelevant with exponent $\rho \approx 2$ (Hasenbusch 2021). Corrections to isotropy are $O(a^2/L^2)$.

**Source:** derivations/34-emergent-lorentz-invariance.md, Eqs. (34.6)--(34.9).

**Rigor:** PHYSICAL ARGUMENT with numerical support. The RG irrelevance is established in the epsilon expansion and confirmed by Monte Carlo; application to the sigma model is by universality.

### LRNZ-02: Lorentz Invariance from Sigma Model (Phase 34)

After the rescaling $\tau' = c_s \tau$, the sigma model action becomes manifestly O($d+1$)-symmetric:

$$
S_{\rm eff} = \frac{1}{2g c_s} \int d^{d+1}x_E \; (\boldsymbol{\nabla}' \mathbf{n})^2, \quad \mathbf{n}^2 = 1
$$

Wick rotation $\tau' \to it$ (justified by DLS 1978 reflection positivity on bipartite lattices) yields a Lorentzian theory with invariant speed $c_s$.

**Source:** derivations/34-emergent-lorentz-invariance.md, Eqs. (34.15), (34.16), (34.30).

**Rigor:** PHYSICAL ARGUMENT. The O($d+1$) Euclidean symmetry is rigorous (it follows from the form of the action). DLS reflection positivity is rigorous on bipartite lattices. The Wick rotation from Euclidean to Lorentzian is a physical argument (not constructive, since W6 is open).

### Velocity Hierarchy (Phase 34)

$$
v_{\rm LR} = 12.66\,J, \quad c_s = 1.659\,Ja, \quad v_{\rm LR}/c_s = 7.63
$$

Four independent arguments establish $c_{\rm eff} = c_s$ (not $v_{\rm LR}$): dispersion relation, EFT universality, universality class invariance, and the Hamma et al. (2009) precedent ($v_{\rm LR}/c_{\rm photon} = 3.84$ for toric code).

**CRITICAL:** The emergent speed of light is $c = c_s = 1.659\,Ja$, NOT $v_{\rm LR} = 12.66\,J$.

**Source:** derivations/34-velocity-hierarchy-and-causal-structure.md, Eqs. (34.2)--(34.8).

### Emergent Metric Assembly (Phase 34)

$$
ds^2 = -c_s^2 \, dt^2 + g_{ij}(x) \, dx^i dx^j
$$

- **Temporal part** ($-c_s^2 dt^2$): from the NL sigma model dynamics + Wick rotation (Phase 34).
- **Spatial part** ($g_{ij} dx^i dx^j$): from the Fisher metric on reduced states (Phase 32, FISH-01/02; Phase 33, CORR-03).
- **Connection:** In the homogeneous case, $g_{ij} = \delta_{ij}$ and the metric reduces to flat Minkowski.

**Source:** derivations/34-velocity-hierarchy-and-causal-structure.md, Eqs. (34.9)--(34.11).

**Rigor:** PHYSICAL ARGUMENT. The metric is a schematic assembly combining spatial (Fisher) and temporal (sigma model) structures. This is not a rigorous construction of a pseudo-Riemannian manifold.

### Two-Tier Causal Structure (Phase 34)

- **Fundamental tier:** Lieb-Robinson cone with $v_{\rm LR} = 12.66\,J$ (rigorous, exact).
- **Effective tier:** Lorentzian light cone with $c_s = 1.659\,Ja$ (EFT, approximate).
- The LR cone strictly contains the Lorentzian cone: $v_{\rm LR} > c_s$.

---

## Link (e): BW Theorem and Local Equilibrium

**What it establishes:** The modular Hamiltonian is a boost, KMS equilibrium at $\beta = 2\pi$, Unruh temperature $T_U = a/(2\pi)$, and local equilibrium ($\theta = \sigma = 0$) at the bifurcation surface.

### Non-Circularity Statement

The logical flow is strictly ordered:

$$
\text{Phase 34 (Lorentz)} \longrightarrow \text{Phase 35, Plan 01 (BW)} \longrightarrow \text{Phase 35, Plan 02 (KMS + equilibrium)} \longrightarrow \text{Phase 36 (Jacobson)}
$$

BW does NOT establish Lorentz invariance -- it uses it (via W2, established in Phase 34). No step uses a later result.

### BWEQ-01: BW Prerequisites (Phase 35, Plan 01)

Wightman axiom assessment for the O(3) NL sigma model:

| Axiom | Status |
|-------|--------|
| W1 (Hilbert space) | Satisfied |
| W2 (Poincare covariance) | Satisfied (Phase 34) |
| W3 (Spectral condition) | Satisfied |
| W4 (Locality/microcausality) | Satisfied |
| W5 (Vacuum uniqueness) | Conditional (IR behavior) |
| W6 (Wightman distributions exist) | **Open** (constructive QFT problem) |

**Source:** derivations/35-bw-axioms-and-lattice-bw.md, Steps 2--3.

### Lattice-BW Entanglement Hamiltonian (Phase 35, Plan 01)

The lattice-BW route (Giudici et al. 2018) bypasses the need for rigorous W6:

$$
H_{\rm ent}^{\rm BW}(A) = \frac{2\pi}{c_s} \sum_{x \in A} x_\perp \, h_x
$$

with SRF = 0.9993 (99.93% of modular Hamiltonian weight in nearest-neighbor terms).

**Source:** derivations/35-bw-axioms-and-lattice-bw.md, Eq. (35.1).

**Rigor:** CONDITIONAL. The lattice-BW ansatz is validated numerically (SRF = 0.9993), not proved as a theorem. It provides the primary approach, bypassing the open W6 question.

### BWEQ-02: KMS from BW (Phase 35, Plan 02)

From the BW identification $K_A = 2\pi K_{\rm boost}$ (Eq. (35.0a)):

1. **Modular flow = Lorentz boost:** $\sigma_t(A) = U(\Lambda(-2\pi t)) A U(\Lambda(-2\pi t))^{-1}$ (Eq. (35.9)).
2. **KMS at $\beta_{\rm mod} = 1$:** Tomita-Takesaki theorem guarantees the vacuum is KMS with respect to the modular flow. This is DERIVED from BW, not assumed.
3. **Jacobson input J1:** $K_A = 2\pi K_{\rm boost}$ (Eq. (35.0a)). Status: CONDITIONAL on lattice-BW.
4. **Jacobson input J3:** $T_U = a/(2\pi)$ (Eq. (35.3)). The $2\pi$ traces end-to-end from BW. Status: RIGOROUS once BW is accepted.

**Source:** derivations/35-kms-equilibrium-and-modular-hamiltonian.md, Eqs. (35.0a), (35.9), (35.3).

### Local Equilibrium: $\theta = \sigma = 0$ (Phase 35, Plan 02)

The boost Killing vector $\xi^\mu$ satisfies the Killing equation $\nabla_{(\mu} \xi_{\nu)} = 0$ (Eq. (35.18)). At the bifurcation surface $B$ (where $\xi^\mu|_B = 0$):

- **Expansion:** $\theta = \nabla_\mu \xi^\mu = g^{\mu\nu} \nabla_{(\mu} \xi_{\nu)} = 0$ (Eq. (35.19)).
- **Shear:** $\sigma_{\mu\nu} = \nabla_{(\mu} \xi_{\nu)} - \frac{1}{d-1} \theta h_{\mu\nu} = 0$ (Eq. (35.21)).

**Jacobson input J2:** $\theta = \sigma = 0$ at the bifurcation surface.

**Source:** derivations/35-kms-equilibrium-and-modular-hamiltonian.md, Eqs. (35.19), (35.21).

**Rigor:** RIGOROUS once the boost Killing vector is identified. This is an exact geometric identity from the Killing equation -- it holds in any spacetime admitting a bifurcate Killing horizon.

---

## Link (f): Jacobson Entanglement Equilibrium $\to$ Einstein Equations

**What it establishes:** $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ with $G_N = 1/(4\eta)$.

This link presents two routes from entanglement equilibrium to Einstein equations, following Jacobson 2016 (arXiv:1505.04753) and Paper 6. Both routes use the same core inputs J1--J7 but differ in how the modular Hamiltonian structure constrains the resulting equation.

**Framework (Jacobson 2016, NOT Jacobson 1995):** The argument uses entanglement equilibrium ($\delta S = 0$), not the Clausius relation ($\delta Q = T dS$). The 2016 framework works with causal diamonds and the maximal vacuum entanglement hypothesis (MVEH), not with local Rindler horizons and the Clausius relation.

### Route A: Jacobson Conformal (CHM Modular Hamiltonian)

**Argument structure:**
1. MVEH: vacuum maximizes entanglement entropy at fixed stress-energy $\to$ $\delta S = 0$ for first-order perturbations.
2. Decompose: $\delta S = \delta S_{\rm UV} + \delta S_{\rm mat} = 0$.
3. UV contribution: $\delta S_{\rm UV} = \eta \, \delta A$, where $\delta A$ is the area change of the causal diamond boundary, computed via the linearized Raychaudhuri equation using $\theta = \sigma = 0$ (J2) at the bifurcation surface.
4. Matter contribution: $\delta S_{\rm mat} = \delta \langle K_B \rangle$ by the entanglement first law (J7, exact identity). For conformal fields, $K_B$ is the CHM modular Hamiltonian (Casini-Huerta-Myers 2011):
   $$
   K_B = 2\pi \int_B \frac{\ell^2 - |\mathbf{x}|^2}{2\ell} \, T_{00}(\mathbf{x}) \, d^d x
   $$
5. Combining $\eta \, \delta A + \delta \langle K_B \rangle = 0$ and using the Raychaudhuri result for $\delta A$ in terms of the Ricci tensor yields:
   $$
   G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}, \quad G_N = 1/(4\eta)
   $$

**Requirements specific to Route A:**
- J1--J7 (see Jacobson Input Mapping below)
- **Gap B:** The CHM modular Hamiltonian $K_B$ is exact only for conformal fields. For non-conformal fields, corrections are $O((m\ell)^{2\Delta})$ (Speranza 2016). In $d = 1$, the Heisenberg chain flows to SU(2)$_1$ WZW CFT, making Route A exact. In $d \geq 2$, the Neel-ordered sigma model is NOT conformal (massive Goldstone modes), making Route A problematic.

**Rigor:** CONDITIONAL. Route A works in $d = 1$ (where the theory is conformal) but is problematic in $d \geq 2$ (where it is not).

### Route B: Lovelock Uniqueness

**Argument structure:**
1. Steps 1--3 identical to Route A: MVEH $\to$ $\delta S = 0$ $\to$ $\eta \, \delta A + \delta S_{\rm mat} = 0$.
2. Instead of using the CHM form for $K_B$, assume **tensoriality** (Gap C): the equation relating $\delta A$ and $\delta S_{\rm mat}$ must hold for all causal diamonds at every point, and the resulting geometric equation must be a symmetric 2-tensor equation involving at most second derivatives of the metric.
3. By the **Lovelock uniqueness theorem** (JMP 12, 498 (1971); JMP 13, 874 (1972)): the unique divergence-free symmetric 2-tensor constructed from the metric and its first and second derivatives is $G_{ab} + \Lambda g_{ab}$.
4. Therefore, the geometric equation must be Einstein's equation: $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$.

**Requirements specific to Route B:**
- J1--J7 (see Jacobson Input Mapping below)
- **Gap C (tensoriality):** The equation must be tensorial (symmetric 2-tensor with at most 2 derivatives). This is ASSUMED, physically motivated by the local nature of the entanglement equilibrium argument.
- **Gap D (MVEH):** The maximal vacuum entanglement hypothesis is a structural identification (Connes-Rovelli thermal time + Van Raamsdonk entanglement $\leftrightarrow$ geometry), not a proof.

**Rigor:** CONDITIONAL. Route B circumvents the conformal approximation (Gap B) by invoking Lovelock uniqueness, but requires the tensoriality assumption (Gap C) and MVEH (Gap D).

### Complementarity of Routes A and B

| Feature | Route A | Route B |
|---------|---------|---------|
| Modular Hamiltonian | CHM (explicit form) | Not needed (Lovelock) |
| Gap B (conformal) | Required | Not needed |
| Gap C (tensoriality) | Not needed (follows from CHM) | Required (assumed) |
| Gap D (MVEH) | Required | Required |
| Best dimension | $d = 1$ (WZW CFT: exact) | $d \geq 2$ (Neel: not conformal) |
| Weakness | Fails for non-conformal fields | Tensoriality is assumed |

**The irony:** Route A is most rigorous where Einstein's equation is least interesting ($d = 1$: $G_{ab} = 0$ trivially). Route B is most applicable where Einstein's equation is physically meaningful ($d \geq 3$) but relies on an additional assumption.

### Target Equation

Both routes yield:

$$
G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}, \quad G_N = \frac{1}{4\eta}
$$

where $\eta$ is the UV entanglement entropy density (entropy per unit area).

---

## Jacobson Input Mapping Table (J1--J8)

| Input | Description | Chain Source | Equation | Status |
|-------|-------------|-------------|----------|--------|
| **J1** | $K_A = 2\pi K_{\rm boost}$ (modular Hamiltonian = boost) | Phase 35 Plan 01 | Eq. (35.0a) | CONDITIONAL (lattice-BW numerical, SRF = 0.9993, not theorem) |
| **J2** | $\theta = \sigma = 0$ at bifurcation surface | Phase 35 Plan 02 | Eqs. (35.19), (35.21) | RIGOROUS (Killing equation identity, once boost is identified) |
| **J3** | $T_U = a/(2\pi)$ (Unruh temperature) | Phase 35 Plan 02 | Eq. (35.3) | RIGOROUS (once BW accepted; $2\pi$ traced end-to-end) |
| **J4** | Smooth Lorentzian manifold $(M, g_{ab})$ | Phases 32--34 | Eqs. (32.8), (33.19), (34.9) | CONDITIONAL (effective smoothness at finite $N$, NOT constructive limit) |
| **J5** | $S_{\rm UV} = \eta A$ (area-entropy proportionality) | Paper 6 Links L1-L5 | Paper 6 Sec. arealaw | CONDITIONAL (proved for gapped; physical argument for Neel) |
| **J6** | Small-ball regime $a \ll \ell \ll L_{\rm curv}$ | Wilsonian assumption | -- | ASSUMED |
| **J7** | $\delta S_{\rm mat} = \delta \langle K_B \rangle$ (entanglement first law) | Exact identity | -- | RIGOROUS |
| **J8** | Tensoriality (Route B only) | Paper 6 Sec. gaps | -- | ASSUMED |

### Notes on J1--J8

- **J1 depends on J4:** The BW identification requires a Lorentz-invariant theory (Phase 34 provides this). The lattice-BW ansatz (Eq. (35.1)) further requires that the low-energy theory is Lorentz-invariant.
- **J2 depends on J1:** The expansion and shear vanish because the modular flow is a Killing flow, which requires identifying the modular Hamiltonian with a boost generator.
- **J3 depends on J1:** The Unruh temperature is derived from the KMS condition, which is derived from BW (J1).
- **J7 is exact:** The entanglement first law $\delta S = \delta \langle K \rangle$ for first-order perturbations around the vacuum is an identity in quantum information theory (not an approximation).
- **J8 is Route B only:** Route A derives the tensorial form from the CHM modular Hamiltonian structure; Route B assumes it.

---

## Dimension Comparison Table

| Link | $d = 1$ | $d = 2$ | $d \geq 3$ |
|------|---------|---------|-------------|
| **(a)** Observer | Universal | Universal | Universal |
| **(b)** SWAP lattice | $S = 1/2$ chain | $S = 1/2$ square lattice | $S = 1/2$ cubic lattice |
| **(c)** Fisher manifold | **FAILS** (FISH-03: $g_{\rm bulk} \sim N^{-2.75}$, Eq. (32.12)) | CONDITIONAL ($O(m_s^2) > 0$ with $\log L$ correction, Eq. (33.19); Neel QMC only for $S = 1/2$) | CONDITIONAL (Goldstone integral convergent; Neel rigorous for $S \geq 1$, Eq. (33.2)) |
| **(d)** Lorentz | SU(2)$_1$ WZW CFT (conformal, not just Lorentz) | Sigma model + DLS reflection positivity, Eq. (34.16) | Sigma model + DLS reflection positivity, Eq. (34.16) |
| **(e)** BW + equilibrium | Exact (CFT + BW theorem applies rigorously) | Lattice-BW numerical (SRF = 0.9993, Eq. (35.1)) | Lattice-BW numerical (SRF = 0.9993, Eq. (35.1)) |
| **(f)** Jacobson $\to$ Einstein | $G_{ab} = 0$ trivially (1+1d: cosmological equation only) | $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ (full) | $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ (full) |

**The central irony:** The chain is MOST rigorous in $d = 1$ (CFT, exact BW, no conditional hypotheses) but the Einstein tensor vanishes identically in 1+1 dimensions, so the physics is trivial. The chain is MOST physically interesting in $d \geq 3$ but relies on conditional arguments and physical arguments at Links (c)--(e).

---

## Cumulative Assumption Register

### Axioms (Starting Points)

| Assumption | Where Introduced | Role |
|------------|-----------------|------|
| Finite-dimensional observer | Paper 5, Link (a) | Foundation of the framework |
| Self-modeling requirement | Paper 5, Link (a) | Forces composite Hilbert space |
| Composite system $\mathcal{H}_{\rm sys} \otimes \mathcal{H}_{\rm obs}$ | Paper 5, Link (a) | Enables partial trace and reduced states |

### Proved Results (Rigorous)

| Result | Source | Conditions |
|--------|--------|------------|
| Hastings-Koma exponential clustering | Phase 33, Eq. (33.1) | Requires spectral gap $\gamma > 0$ |
| FISH-01: Fisher smoothness (gapped) | Phase 32, Eq. (32.8) | Requires finite range $H$, unique GS, gap $\gamma > 0$ |
| FISH-02: Fisher positive-definiteness | Phase 32, Theorem 2 | Requires full-rank $\rho$, OBC, not at $Z_2$ center |
| FISH-03: Distance non-recovery in 1D | Phase 32, Eq. (32.12) | Proved as negative result |
| Neel order ($S \geq 1$, $d \geq 3$) | Dyson-Lieb-Simon 1978, Eq. (33.2) | Bipartite lattice, AFM coupling |
| Neel order ($S = 1/2$, $d = 3$) | Kennedy-Lieb-Shastry 1988 | Bipartite lattice |
| DLS reflection positivity | DLS 1978, cited Phase 34 | Bipartite lattice |
| Entanglement first law $\delta S = \delta \langle K \rangle$ | Exact identity (J7) | First-order perturbation |
| Killing $\theta = \sigma = 0$ at bifurcation | Phase 35, Eqs. (35.19), (35.21) | Once boost Killing vector identified |
| Unruh $T_U = a/(2\pi)$ (once BW accepted) | Phase 35, Eq. (35.3) | Follows from KMS + proper time |
| Lovelock uniqueness | Lovelock 1971/1972 | Divergence-free symmetric 2-tensor, $\leq 2$ derivatives |
| BW theorem (continuum, exact) | Bisognano-Wichmann 1975/1976, Eq. (35.0) | Requires all Wightman axioms W1--W6 |

### Conditional Theorems

| Result | Source | Conditions Not Fully Established |
|--------|--------|--------------------------------|
| CORR-03: Fisher smoothness (Neel, $d \geq 2$) | Phase 33, Eq. (33.19) | Conditional on H1--H4; H1 not rigorous for $S = 1/2$, $d = 2$ |
| Area-law entanglement (Neel) | Paper 6 Links L1-L5 | Physical argument for gapless Neel (proved for gapped) |
| Lattice-BW entanglement Hamiltonian | Phase 35, Eq. (35.1) | Numerical (SRF = 0.9993), not theorem |
| BW prerequisites W5 | Phase 35, Plan 01 | Conditional on IR behavior of Goldstone modes |

### Physical Arguments (Plausible but Unproved)

| Argument | Source | Why Not Rigorous |
|----------|--------|-----------------|
| Sigma model as continuum description | Phase 33, Eq. (33.11) | Universality argument; no rigorous lattice-to-continuum derivation |
| Isotropy from RG irrelevance | Phase 34, Eqs. (34.6)--(34.9) | Based on RG analysis and Monte Carlo; not proved for sigma model |
| Wick rotation from DLS positivity | Phase 34, Eq. (34.30) | DLS is rigorous; Wick rotation to Lorentzian is physical (W6 open) |
| $c_{\rm eff} = c_s$ (four arguments) | Phase 34, Eqs. (34.2)--(34.8) | Self-consistent but not proved; relies on EFT universality |
| Metric assembly (Fisher + sigma model) | Phase 34, Eq. (34.9) | Schematic combination of spatial and temporal structures |
| Neel order for $S = 1/2$, $d = 2$ | QMC: $m_s = 0.3074$ (Sandvik 2025) | Established numerically to high precision but not a theorem |

### Assumed (Taken as Input)

| Assumption | Source | Justification |
|------------|--------|---------------|
| MVEH (maximal vacuum entanglement) | Paper 6 | Structural identification (Connes-Rovelli + Van Raamsdonk), NOT a proof |
| Wilsonian regime $a \ll \ell \ll L_{\rm curv}$ (J6) | Standard EFT | Physically necessary for Raychaudhuri to be valid; cannot be derived from lattice |
| Tensoriality (J8, Route B only) | Paper 6 | Physically motivated by local nature of equilibrium; not derived |

### Open (Not Addressed)

| Item | Status | Impact |
|------|--------|--------|
| Constructive continuum limit ($N \to \infty$) | Open | FISH-01/02 prove smoothness at finite $N$; the $N \to \infty$ limit is the principal open problem (Paper 6) |
| Conformal modular Hamiltonian in $d \geq 2$ | Route A only; fails for non-conformal sigma model | Blocks Route A in $d \geq 2$; motivates Route B |
| Neel order for $S = 1/2$, $d = 2$ (rigorous proof) | Open (QMC evidence only) | Affects CORR-03 hypothesis H1 |
| Wightman axiom W6 (constructive QFT) | Open | Blocks continuum BW theorem; lattice-BW bypasses |

---

## Cumulative Chain Status

**For $d \geq 3$:** The chain from (a) to (f) is **CONDITIONAL**. Each link is at least PHYSICAL ARGUMENT or CONDITIONAL, and no link is OPEN. The strongest links are (a) (axiom), (b) (rigorous lattice construction), and the Killing geometry in (e) (rigorous once boost identified). The weakest links are the sigma model description in (c)/(d) (physical argument, not proved) and the MVEH in (f) (structural identification, not proof). The Neel order is rigorously established for $S \geq 1$ (DLS 1978), and for $S = 1/2$ by KLS 1988.

**For $d = 2$:** The chain is **CONDITIONAL with additional caveats**. The Neel order is not rigorously proved for $S = 1/2$ (QMC evidence only, $m_s = 0.3074$). The Goldstone integral in CORR-03 has an $O(\log L)$ correction that requires careful treatment. All other links have the same status as $d \geq 3$.

**For $d = 1$:** Link (c) **FAILS** (FISH-03: $g_{\rm bulk} \sim N^{-2.75} \to 0$, Eq. (32.12)). The Fisher geometry collapses in the thermodynamic limit. Additionally, Link (f) gives a **TRIVIAL** result: the Einstein tensor vanishes identically in 1+1 dimensions, so only a cosmological equation survives. The chain is not viable as a route to gravity in $d = 1$.

---

## Verification Summary

**Acceptance test results (Plan 01 contract):**

| Test ID | Result | Evidence |
|---------|--------|----------|
| test-six-links | PASS | All six links (a)--(f) present with explicit sections; each cites prior phase equations |
| test-rigor-classification | PASS | Every link classified {RIGOROUS, CONDITIONAL, PHYSICAL ARGUMENT, ASSUMED}; no overclaiming |
| test-no-rederivation | PASS | Zero new derivations; all results cited by (Phase, Equation) pair |
| test-convention-consistency | PASS | Natural units, SLD Fisher, J>0 AFM, c=c_s throughout; Fisher always "spatial/Riemannian" |
| test-jacobson-mapping | PASS | J1-J8 all mapped with source and status |
| test-route-ab | PASS | Route A (Gap B: conformal) and Route B (Gap C: tensoriality) clearly distinguished |
| test-dimension-columns | PASS | Dimension table: d=1 (FISH-03 failure, G_ab trivial), d=2 (log, QMC only), d>=3 (convergent, DLS rigorous) |

---
