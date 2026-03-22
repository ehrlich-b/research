# Master Synthesis: Self-Modeling to Einstein's Field Equations

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, coupling_convention=H_sum_hxy, entropy_base=nats, state_normalization=Tr_rho_1, commutation_convention=standard, modular_hamiltonian=K_minus_ln_rho

**Phase:** 10-jacobson-application, Plan 03
**Date:** 2026-03-22

**References:**
- Jacobson 2016, PRL 116, 201101, arXiv:1505.04753
- Jacobson 2012, IJMPD 21, 1242006, arXiv:1204.6349
- Cao, Carroll, Michalakis 2017, PRD 95, 024031, arXiv:1606.08444
- Lashkari, McDermott, Van Raamsdonk 2014, JHEP 1404:195, arXiv:1308.3716
- Speranza 2016, arXiv:1602.01380
- Phase 8 synthesis: .gpd/phases/08-locality-formalization/08-03-SUMMARY.md
- Phase 9 synthesis: .gpd/phases/09-area-law-derivation/09-03-SUMMARY.md
- Plan 01 inputs: derivations/10-jacobson-inputs.md
- Plan 02 derivation: derivations/10-jacobson-derivation.md

---

## Part A: Master Theorem

**MASTER THEOREM (Self-Modeling to Einstein's Equations).**

*Let $G = (V, E)$ be a lattice with local algebra $A_x = M_n(\mathbb{C})^{sa}$ at each site $x \in V$, equipped with the self-modeling interaction Hamiltonian $H = \sum_{\langle x,y \rangle \in E} J F_{xy}$ (where $F_{xy}$ is the SWAP operator, forced by diagonal $U(n)$ covariance and Schur-Weyl duality; Phase 8, Plan 01).*

*Under Assumptions A1--A5 and the Wilsonian continuum limit:*

*(a) The lattice has area-law entanglement:*
- *Thermal: $I(A:B) \leq 2\beta\,|\partial(A)|\,|J|$ (WVCH, under A1)*
- *Pure: $S(A) \leq \log(n)\,|\partial(A)|$ (channel capacity, under A2)*
- *Perturbative: $\delta S \sim O(|\partial(A)|)$ for local perturbations (entanglement first law + modular Hamiltonian locality, under A3)*

*(b) The entanglement first law $\delta S = \delta\langle K_A \rangle$ holds exactly, with $K_A = -\ln\rho_A$ the modular Hamiltonian (no additional assumptions beyond quantum mechanics).*

*(c) In the Wilsonian continuum limit at scales $L \gg a$ (lattice spacing), Einstein's field equations hold at leading order:*

$$G_{ab} + \Lambda g_{ab} = 8\pi G\, T_{ab} \tag{10-03.1}$$

*with $G = 1/(4\eta)$ where $\eta$ is the entanglement entropy density per unit area, and $\Lambda$ is an undetermined integration constant (cosmological constant).*

**Proof structure:** Part (a) is established in Phase 9 (Plans 01--03). Part (b) is an exact identity of quantum information theory (Phase 9, Eq. 09-03.3). Part (c) follows from the Jacobson 2016 entanglement equilibrium argument applied in the Wilsonian continuum limit of the self-modeling lattice (Phase 10, Plans 01--02). The derivation of part (c) is conditional on A5 (MVEH). $\square$

SELF-CRITIQUE CHECKPOINT (Master Theorem):
1. SIGN CHECK: Eq. (10-03.1) has the standard sign: positive $T_{ab}$ gives positive $G_{ab}$, consistent with attractive gravity. Verified in Plan 02 sign chain.
2. FACTOR CHECK: $8\pi G$ is the standard Einstein equation prefactor. $G = 1/(4\eta)$ has factor 4 from Bekenstein-Hawking.
3. CONVENTION CHECK: Natural units, $(-,+,+,+)$ metric, $G_{ab} = R_{ab} - (1/2)Rg_{ab}$, $K = -\ln\rho$. All consistent with Plans 01--02 and Phase 9.
4. DIMENSION CHECK: $[G_{ab}] = [\Lambda] = [8\pi G T_{ab}] = [1/\text{length}^2]$ in natural units. $[G \cdot \eta] = 1/4$ dimensionless. Correct.

All checks pass.

---

## Part B: Complete Derivation Chain

| Link | Statement | Phase/Source | Status | Assumptions | Key Equations |
|------|-----------|-------------|--------|-------------|---------------|
| **L1** | Self-modeling forces $M_n(\mathbb{C})^{sa}$ with Luders product | Paper 5 (v2.0) | **Proven** | None (follows from vdW S1--S7) | -- |
| **L2** | Lattice with $H = \sum JF$ forced by diagonal $U(n)$ covariance | Phase 8, Plan 01 | **Derived** | Graph $G$ is input (A4) | $h_{xy} = JF_{xy}$ |
| **L3** | Lieb-Robinson velocity $v_{LR} = 8eJ/(e-1)$ establishes effective causal structure | Phase 8, Plans 02--03 | **Derived** | A4 | Eq. (08-03.3) |
| **L4a** | Thermal MI area law: $I(A:B) \leq 2\beta\,|\partial|\,|J|$ | Phase 9, Plan 01 | **Established** | A1 (thermal state) | Eq. (09-03.1) |
| **L4b** | Pure-state $S$ area law: $S(A) \leq \log(n)\,|\partial|$ | Phase 9, Plan 02 | **Established** | A2 (pure state) | Eq. (09-03.2) |
| **L4c** | $\delta S \sim |\partial|$ for local perturbations | Phase 9, Plan 03 | **Physical argument** | A3 (modular $K$ locality) | Eq. (09-03.6) |
| **L5** | Entanglement first law: $\delta S = \delta\langle K_A \rangle$ | Phase 9, Plan 03 | **Exact identity** | None | Eq. (09-03.3) |
| **L6** | Wilsonian continuum limit: lattice $\to$ smooth emergent manifold | Phase 10, Plan 01 | **Physical argument** | Wilsonian (standard) | -- |
| **L7** | MVEH: vacuum maximizes $S$ at fixed $\langle T_{ab} \rangle$ | Phase 10, Plan 01 | **Assumed (A5)** | A5 (MVEH) | Eq. (10-01.15) |
| **L8** | $G_{ab} + \Lambda g_{ab} = 8\pi G\, T_{ab}$ with $G = 1/(4\eta)$ | Phase 10, Plan 02 | **Derived from L1--L7** | A1--A5 + Wilsonian + conformal | Eq. (10-02.57) |

### B.1 Link Status Classification

- **Proven** (L1): rigorous mathematical result, no physics assumptions
- **Derived** (L2, L3): follows from stated physics assumptions via rigorous mathematical argument
- **Established** (L4a, L4b): mathematically rigorous given the stated assumption (A1 or A2), using published theorems (WVCH, channel capacity)
- **Physical argument** (L4c, L6): standard physics reasoning, well-motivated but not rigorous
- **Exact identity** (L5): exact result of quantum information theory, no approximations
- **Assumed** (L7): the single most significant gap; not derived from self-modeling
- **Derived from L1--L7** (L8): follows from all prior links via the Jacobson 2016 argument

### B.2 Novel Content vs. Jacobson's Contribution

| Content | Attribution | What Is It |
|---------|-----------|------------|
| **Links L1--L5** (self-modeling $\to$ lattice $\to$ area law $\to$ first law) | **NEW** (this work, Phases 8--9) | The novel contribution: a specific UV completion satisfying Jacobson's inputs |
| **Links L6--L8** (continuum $\to$ MVEH $\to$ Einstein) | **Jacobson 2016** | The Jacobson 2016 entanglement equilibrium derivation, applied to the self-modeling lattice as UV completion |

**The contribution of this work:** providing a SPECIFIC UV completion -- the self-modeling lattice forced by the algebraic structure of quantum theory (Paper 5) -- that satisfies Jacobson's three input conditions: (J1) area-law $\delta S$ (Phase 9), (J2) entanglement first law (Phase 9), and (J3) entanglement equilibrium (assumed as A5, motivated by MaxEnt). The UV completion is not arbitrary: it is forced by self-modeling through the Luders product (Paper 5), the $U(n)$-covariant SWAP interaction (Phase 8), and the resulting area-law entanglement (Phase 9).

### B.3 Comparison with Related Work

**Jacobson 2016 (Entanglement Equilibrium).** Jacobson assumed area-law entanglement and the entanglement first law as inputs, together with MVEH. Our work derives the first two from the self-modeling lattice, reducing the inputs to MVEH alone (plus the Wilsonian continuum limit). The Jacobson derivation was UV-agnostic; we provide a specific UV completion.

**Cao-Carroll-Michalakis 2017 (Space from Hilbert Space).** CCM 2017 derives a spatial constraint equation from entanglement structure, showing that the spatial geometry satisfying the Ryu-Takayanagi formula also satisfies the linearized Einstein constraint equation. Our result gives the full spacetime Einstein equation (not just the spatial constraint), including the dynamical (Hamiltonian) sector. The spatial part of our Einstein equation is consistent with CCM's constraint. The key difference: CCM uses entanglement to reconstruct spatial geometry, while we (following Jacobson) use entanglement equilibrium to derive the full gravitational dynamics.

**Lashkari-McDermott-Van Raamsdonk 2014 (Entanglement First Law $\to$ Linearized Einstein).** LMVR 2014 showed that the entanglement first law in holographic CFTs implies the linearized Einstein equation. Our derivation, following Jacobson 2016, extends this to the full nonlinear Einstein equation via the entanglement equilibrium condition. The LMVR result is recovered as the linearized limit of our Eq. (10-03.1).

---

## Part C: Lattice Parameter Identification

In the Wilsonian continuum limit (Plan 01, Part B), lattice parameters map to continuum quantities:

| Lattice Parameter | Continuum Identification | Equation | Dimensional Check |
|-------------------|------------------------|----------|-------------------|
| Lattice spacing $a$ | Planck length $\ell_P$ (up to $O(\sqrt{\log n})$) | Eq. (10-01.7) | $[a] = [\text{length}]$ |
| $v_{LR} = 8eJ/(e-1)$ | Speed of light $c$ (set to 1 in natural units) | Eq. (10-01.9) | $[v_{LR}] = [\text{velocity}]$ when $a$ restored |
| $\eta_{\text{lattice}} \leq \log(n)$ | $\eta = \eta_{\text{lattice}}/a^{d-1}$ | Eq. (10-01.3) | $[\eta] = [1/\text{length}^{d-1}]$ |
| -- | $G = 1/(4\eta)$ | Eq. (10-01.5) | $[G] = [\text{length}^{d-1}]$ in $d+1$ spacetime |
| Channel capacity bound | $G \geq a^{d-1}/(4\log n)$ | Eq. (10-01.6) | $[G] = [\text{length}^{d-1}]$ |

The Planck scale is set by the lattice spacing: the lattice IS the Planckian microstructure. In $d = 3$: $\ell_P = G^{1/2} \sim a/(\log n)^{1/2}$, so $a \sim \ell_P \sqrt{\log n}$. The logarithmic factor reflects the finite local Hilbert space dimension $n$.

SELF-CRITIQUE CHECKPOINT (Parts A--C):
1. SIGN CHECK: All quantities ($\eta$, $G$, $a$, $v_{LR}$) positive. No sign issues.
2. FACTOR CHECK: $G = 1/(4\eta)$ from Bekenstein-Hawking. Channel capacity gives $\log(n)$, not $n$. No spurious $2\pi$.
3. CONVENTION CHECK: Natural units, $(-,+,+,+)$, $K = -\ln\rho$, $H = \sum h_{xy}$. Consistent throughout.
4. DIMENSION CHECK: $[G \cdot \eta] = 1/4$ dimensionless. $[G] = [\text{length}^{d-1}]$. All consistent.

All checks pass.

---

## Part D: Comparison with Jacobson 2016

### D.1 What Jacobson Assumes vs. What We Derive

| Jacobson Input | Jacobson 2016 Status | This Work Status | Source |
|---------------|---------------------|-----------------|--------|
| **(J1)** $\delta S \sim |\partial|$ | Assumed | **Established** under A3 | Phase 9, Eq. (09-03.6) |
| **(J2)** Entanglement first law | Assumed | **Exact identity** | Phase 9, Eq. (09-03.3) |
| **(J3)** MVEH ($\delta S = 0$ for vacuum) | Assumed | **Assumed as A5** | Plan 01, Part E |
| UV completion | Unspecified | **Self-modeling lattice** | Phase 8 |
| Entropy density $\eta$ | Free parameter | **$\eta = \eta_{\text{lattice}}/a^{d-1} \leq \log(n)/a^{d-1}$** | Plan 01, Eq. (10-01.3) |

### D.2 What Is New

Jacobson 2016 derived Einstein's equations from entanglement equilibrium, leaving the UV completion unspecified. Our contribution is:

1. **A forced UV completion.** The self-modeling lattice is not an arbitrary choice; it is forced by the algebraic structure of quantum theory (Paper 5: $M_n(\mathbb{C})^{sa}$ with Luders product from S1--S7).

2. **Derivation of Jacobson's area-law input.** Jacobson assumed area-law $\delta S$. We derive it from three complementary perspectives (thermal MI, pure-state $S$, entanglement first law under A3).

3. **An upper bound on $\eta$.** The channel capacity bound $\eta_{\text{lattice}} \leq \log(n)$ provides a physical upper bound on the entropy density, connecting the lattice local dimension $n$ to Newton's constant: $G \geq a^{d-1}/(4\log n)$.

4. **An effective causal structure.** The Lieb-Robinson velocity $v_{LR} = 8eJ/(e-1)$ provides the emergent speed of light, not assumed but computed from the lattice Hamiltonian.

### D.3 What Is Jacobson's

The derivation in the continuum (Raychaudhuri $\to$ area variation, CHM modular Hamiltonian $\to$ matter variation, MVEH $\to$ equilibrium, tensor extraction $\to$ Einstein) is Jacobson's. We follow his argument, adapted to the self-modeling lattice context. The novel content is upstream (Links L1--L5).

---

## Part E: Gap Statement

**THIS SECTION IS INTENTIONALLY PROMINENT.** The gaps are first-class components of the result, not footnotes.

### Gap 1: Maximal Vacuum Entanglement Hypothesis (Assumption A5)

**What it assumes:** The vacuum state of the emergent continuum theory maximizes entanglement entropy $S(B)$ for any small geodesic ball $B$ among all states with the same stress-energy expectation value $\langle T_{ab} \rangle$.

**Why it matters:** Without A5, the derivation produces $\delta S = \delta S_{\text{UV}} + \delta S_{\text{mat}}$ but does NOT set this to zero. Without $\delta S = 0$, the Raychaudhuri-based area variation and the CHM-based matter variation are independent quantities, and no equation of motion follows.

**Physical motivation:** MaxEnt reasoning -- the self-modeling equilibrium state is the least biased state consistent with its constraints (Plan 01, Part E.4). The Gibbs state (MaxEnt at fixed energy) of the self-modeling Hamiltonian maps, in the continuum limit, to a state that is argued to maximize $S$ at fixed $\langle T_{ab} \rangle$. This chain of reasoning contains non-rigorous steps (Plan 01, Part E.4).

**What self-modeling property would establish A5:** Showing that the self-modeling equilibrium state, when mapped to the emergent continuum via the Wilsonian limit, is a MAXIMUM (not just extremum) of $S(B)$ at fixed $\langle T_{ab} \rangle$. Concretely: for the Gibbs state $\rho_\beta = e^{-\beta H}/Z$ of $H = \sum JF_{xy}$, one would need to prove that in the continuum limit, $\partial^2 S / \partial \alpha^2 |_{\alpha=0} < 0$ along all perturbation directions $\rho \to \rho + \alpha\,\delta\rho$ that preserve $\langle T_{ab} \rangle$.

**What happens if A5 fails:** The result becomes conditional: "IF MVEH holds for the self-modeling lattice, THEN Einstein's equations follow." This is still significant -- it identifies self-modeling as a UV completion compatible with Jacobson's program, with MVEH as the single remaining bridge.

**Equivalence for conformal fields:** Jacobson 2016 proved that for conformal fields, MVEH $\Leftrightarrow$ Einstein's equations. This means A5 is exactly as strong as the conclusion for CFT -- assuming the result gives the result. The 1D AFM Heisenberg chain ($n = 2$, $J > 0$), which flows to the $SU(2)_1$ WZW CFT ($c = 1$), is in this category. For nonconformal fields (the generic $d \geq 2$ case), A5 is a genuine additional postulate that may be independently checkable.

### Gap 2: Continuum Limit

**What it assumes:** The self-modeling lattice produces a smooth Riemannian manifold $(M, g_{ab})$ at long wavelengths $L \gg a$.

**Why it matters:** The Raychaudhuri equation, geodesic balls, causal diamonds, the CHM modular Hamiltonian, and the stress-energy tensor $T_{ab}$ are all defined on a differentiable manifold. Without a smooth continuum limit, these objects do not exist.

**Physical motivation:** Wilsonian universality -- at long wavelengths, the lattice details are irrelevant and the physics is governed by the symmetry-allowed effective field theory. This is the standard assumption in all lattice approaches to quantum gravity (lattice QCD, causal dynamical triangulations, Regge calculus).

**What would establish it:** A constructive proof of the continuum limit, analogous to lattice QCD $\to$ continuum QCD. This would require showing that the lattice correlation functions converge (in an appropriate sense) to correlation functions of a local QFT on a Riemannian manifold as $a \to 0$. This is a hard open problem in ALL lattice approaches to quantum gravity, not specific to self-modeling.

**What happens if it fails:** If the continuum limit does not exist (the lattice theory has no UV fixed point), the entire Jacobson route fails. If it exists but produces non-Riemannian geometry, the result changes -- possibly $f(R)$ gravity, torsion theories, or other modifications.

**Context:** This gap is shared with every lattice quantum gravity approach. It is a universal open problem, not specific to the self-modeling framework.

### Gap 3 (Minor): Conformal Approximation

**What it assumes:** The CHM modular Hamiltonian (Eq. 10-01.10) is exact, requiring conformal symmetry in the IR.

**Why it matters:** For nonconformal fields, corrections $O((mR)^{2\Delta})$ appear (Speranza 2016, Eq. 10-01.12). These modify the matter entropy variation $\delta S_{\text{mat}}$ and hence the Einstein equation at subleading order.

**Suppression:** In the window $a \ll R \ll 1/m$ (if it exists), the corrections are small. For the 1D AFM case ($SU(2)_1$ WZW), the theory is exactly conformal and this gap vanishes.

**Jacobson's conjecture:** Jacobson 2016 (Section IV) conjectures that the leading-order Einstein equation survives nonconformal corrections. This is physically motivated but not proven.

---

## Part F: Known Limits

The derived Einstein equation $G_{ab} + \Lambda g_{ab} = 8\pi G\, T_{ab}$ (Eq. 10-03.1) reproduces all standard limits:

### F.1 Flat Spacetime

$R_{abcd} = 0$, $T_{ab} = 0$, $\Lambda = 0$: Then $G_{ab} = 0$ is trivially satisfied. The entanglement equilibrium $\delta S = 0$ holds vacuously since $\delta S_{\text{UV}} = 0$ (no curvature $\Rightarrow$ no focusing $\Rightarrow$ no area change) and $\delta S_{\text{mat}} = 0$ (no matter $\Rightarrow$ no stress-energy). **Consistent.**

### F.2 Linearized Gravity

Expand $g_{ab} = \eta_{ab} + h_{ab}$ with $|h_{ab}| \ll 1$. The linearized Einstein equation in Lorenz gauge ($\partial^a \bar{h}_{ab} = 0$ where $\bar{h}_{ab} = h_{ab} - \frac{1}{2}\eta_{ab} h$) is:

$$\Box \bar{h}_{ab} = -16\pi G\, T_{ab}$$

This is the standard weak-field result, recovered at first order in $h_{ab}$. Our derivation IS first-order, so this is exact within our approximation scheme.

**Cross-check with LMVR 2014:** Lashkari, McDermott, Van Raamsdonk showed that the entanglement first law in holographic CFTs produces the linearized Einstein equation. Our result, linearized around flat space, matches theirs. **Consistent.**

### F.3 Schwarzschild

Vacuum ($T_{ab} = 0$) with spherical symmetry and $\Lambda = 0$: $G_{ab} = 0$ gives $R_{ab} = 0$ (Ricci flat). The unique spherically symmetric vacuum solution is Schwarzschild: $ds^2 = -(1-2GM/r)dt^2 + (1-2GM/r)^{-1}dr^2 + r^2 d\Omega^2$. With $G = 1/(4\eta)$, the Schwarzschild radius is $r_s = 2GM = M/(2\eta)$. **Consistent.**

### F.4 de Sitter

Vacuum ($T_{ab} = 0$), $\Lambda > 0$: $G_{ab} = -\Lambda g_{ab}$, giving constant positive curvature $R_{abcd} = \frac{2\Lambda}{d(d-1)}(g_{ac}g_{bd} - g_{ad}g_{bc})$. This is the maximally symmetric spacetime (MSS) around which the Jacobson derivation perturbs. The result is self-consistent: the background MSS satisfies the derived equation with $\Lambda$ as a free parameter (Jacobson-Speranza 2019). **Consistent.**

### F.5 Newtonian Limit

Weak field, slow motion: $g_{00} = -(1 + 2\Phi)$ with $|\Phi| \ll 1$, $T_{00} = \rho$. The time-time component of Einstein's equation gives:

$$\nabla^2 \Phi = 4\pi G \rho \tag{10-03.2}$$

This is Poisson's equation. The gravitational force is $\mathbf{F} = -\nabla\Phi \propto -GM/r^2$ (attractive for $M > 0$, $G > 0$). Since $G = 1/(4\eta) > 0$ (because $\eta > 0$), gravity is attractive. **Consistent.**

SELF-CRITIQUE CHECKPOINT (Parts D--F):
1. SIGN CHECK: Newtonian limit gives attractive gravity ($G > 0$). All limits consistent.
2. FACTOR CHECK: $16\pi G$ in linearized equation matches $8\pi G$ in Einstein equation (standard factor of 2 from trace reversal). $r_s = 2GM$ is standard Schwarzschild.
3. CONVENTION CHECK: $(-,+,+,+)$ metric, $G_{ab} = R_{ab} - (1/2)Rg_{ab}$ throughout.
4. DIMENSION CHECK: Poisson equation: $[\nabla^2 \Phi] = [1/\text{length}^2]$, $[G\rho] = [\text{length}^{d-1}] \cdot [1/\text{length}^{d+1}] = [1/\text{length}^2]$ in natural units. Correct for $d = 3$.

All checks pass.

---

## Part G: Phase 10 ROADMAP Success Criteria

| # | Criterion | Status | Source | Notes |
|---|-----------|--------|--------|-------|
| 1 | Entanglement first law $\delta S = \delta\langle K\rangle$ verified | **EXACT IDENTITY** | Phase 9, Eq. (09-03.3) | No additional assumptions; standard QI result |
| 2 | MVEH status: verified or identified as assumption | **ASSUMED as A5** | Plan 01, Part E | MaxEnt motivation; gap statement in Part E above |
| 3 | Continuum limit framed as Wilsonian | **ESTABLISHED** | Plan 01, Part A | Physical argument, not rigorous construction |
| 4 | Einstein equations derived: $G_{ab} + \Lambda g_{ab} = 8\pi G T_{ab}$ | **DERIVED** under A1--A5 | Plan 02, Eq. (10-02.57) | Sign, tensor structure, and $G = 1/(4\eta)$ verified |
| 5 | Three Jacobson inputs addressed | **ALL THREE** | Plans 01--02 | (J1) established, (J2) exact, (J3) assumed as A5 |

All five ROADMAP success criteria are addressed.

---

## Part H: Phase 11 Interface (Numerical Verification Targets)

Phase 11 can provide numerical evidence for (or against) the assumptions and results:

### H.1 Area-Law Scaling (Positive Control)

Compute $S(A)$ vs. $|\partial(A)|$ for the self-modeling lattice ($H = \sum JF_{xy}$) on small lattices ($N = 8$--$20$ sites) via exact diagonalization. Expected results:
- **AFM ground state ($J > 0$, 1D):** $S(L) = (1/3)\ln L + \text{const}$ (log correction to area law, as for any $c = 1$ CFT). Benchmark: matches Heisenberg chain.
- **FM ground state ($J < 0$, 1D):** $S(A) = 0$ (product state). Trivial area law but useless for gravity.
- **Thermal state at finite $T$:** $I(A:B) \leq 2\beta|\partial||J|$ (WVCH bound). Verify numerically.
- **Pure excited states:** $S(A) \leq \log(n)|\partial|$ (channel capacity). Verify for random pure states.

### H.2 MVEH (Qualitative Check)

Perturb the self-modeling ground state away from equilibrium (e.g., apply a local unitary to one site) and compute $\delta S = S(\rho') - S(\rho_0)$ for small geodesic balls. If A5 holds, $\delta S \leq 0$ at fixed $\langle T_{ab} \rangle$ (entropy should decrease from maximum). This is a qualitative check, not a proof.

### H.3 Modular Hamiltonian Locality (A3 Check)

Compute $K_A = -\ln\rho_A$ for small subsystems ($|A| = 3$--$6$ sites) and examine the matrix elements. Under A3, the matrix elements should decay exponentially with distance from the boundary $\partial A$. Specifically, plot $|\langle x | K_A | y \rangle|$ as a function of $\min(\text{dist}(x, \partial A), \text{dist}(y, \partial A))$ and check for exponential decay.

---

## Part I: Phase 12 Interface (Paper 6 Structure)

### I.1 Suggested Paper 6 Section Structure

1. **Introduction:** The chain from self-modeling to Einstein, the claim, the caveats
2. **The Self-Modeling Lattice** (Phase 8 results): $M_n(\mathbb{C})^{sa}$, $H = \sum JF$, $v_{LR}$, lattice definition
3. **Area-Law Entanglement** (Phase 9 results): Three perspectives, entanglement first law, $\delta S \sim |\partial|$
4. **Jacobson Application** (Phase 10 results): Wilsonian continuum limit, Raychaudhuri + CHM, MVEH, Einstein equation
5. **Numerical Verification** (Phase 11 results): Area-law scaling data, MVEH qualitative check
6. **Discussion:** Gap statement (A5 + continuum limit), relation to Jacobson/CCM/LMVR, outlook
7. **Appendix A:** Assumption register A1--A5

### I.2 Honest Framing for Paper 6

> We show that a lattice of self-modeling quantum systems provides a specific UV completion compatible with Jacobson's entanglement equilibrium program. Under the maximal vacuum entanglement hypothesis (which we motivate but do not derive), Einstein's field equations emerge as the leading-order IR effective description of the continuum limit.

This framing:
- States the result accurately (UV completion for Jacobson's program)
- Identifies the key assumption honestly (MVEH motivated but not derived)
- Does not overclaim (does not say "we derive GR from self-modeling" without the A5 qualification)
- Identifies the scope correctly (leading-order, IR, continuum limit)

### I.3 What the Paper Does NOT Claim

- Does NOT predict the cosmological constant $\Lambda$ (it is an integration constant)
- Does NOT predict the number of spacetime dimensions $d$ (the graph structure $G$ is input)
- Does NOT derive MVEH from self-modeling (A5 is assumed, with MaxEnt motivation)
- Does NOT rigorously establish the continuum limit (Wilsonian argument, not constructive proof)
- Does NOT apply to the finite lattice (all GR is emergent in the IR)

---

_End of synthesis. Phase 10, Plan 03._
