# Jacobson Inputs: Wilsonian Continuum Limit and MVEH Formulation

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, coupling_convention=H_sum_hxy, entropy_base=nats, state_normalization=Tr_rho_1, commutation_convention=standard, modular_hamiltonian=K_minus_ln_rho

**Phase:** 10-jacobson-application, Plan 01
**Date:** 2026-03-22

**References:**
- Jacobson 2016, PRL 116, 201101, arXiv:1505.04753 ("Entanglement Equilibrium and the Einstein Equation")
- Jacobson 2012, IJMPD 21, 1242006, arXiv:1204.6349 ("Gravitation and Vacuum Entanglement Entropy")
- Speranza 2016, arXiv:1602.01380 ("Entanglement entropy of excited states in CFT and corrections beyond the first law")
- Phase 9 synthesis: derivations/09-area-law-synthesis.md
- Phase 8 LR velocity: derivations/08-lr-self-modeling.md

---

## Part A: The Wilsonian Picture

### A.1 UV Completion

The self-modeling lattice (Phase 8) provides a UV-complete quantum system:

- **Graph:** $G = (V, E)$ with vertices $V$, edges $E \subset V \times V$
- **Local algebra:** $A_x = M_n(\mathbb{C})^{sa}$ at each site $x \in V$ (self-adjoint part of $n \times n$ complex matrices)
- **Composite product:** Product-form sequential product $(a \otimes b) \mathbin{\&} (c \otimes d) = (a \mathbin{\&} c) \otimes (b \mathbin{\&} d)$
- **Hamiltonian:** $H = \sum_{\langle x,y \rangle \in E} h_{xy}$, with $h_{xy} = JF_{xy}$ (SWAP interaction), forced by diagonal $U(n)$ covariance and Schur-Weyl duality (Phase 8, Plan 01)
- **Causal structure:** Lieb-Robinson velocity $v_{LR} = 8eJ/(e-1)$ on $\mathbb{Z}^1$ (Phase 8, Eq. 08-03.3), independent of local dimension $n$

This is the UV theory. The lattice spacing $a$ serves as the fundamental UV cutoff. All structure below the scale $a$ is resolved by the lattice; all structure above the scale $a$ emerges in the continuum limit.

### A.2 The Wilsonian Argument

At length scales $L \gg a$, the lattice details become irrelevant. The long-wavelength physics is governed by an effective continuum theory whose form is constrained by:

1. **Symmetry:** Only operators compatible with the symmetries of the lattice Hamiltonian survive at long wavelengths. The self-modeling Hamiltonian $H = \sum JF_{xy}$ has $\text{diag}(U(n))$ invariance at each site and translation invariance on regular lattices.

2. **Locality:** The nearest-neighbor structure of $H$ and the finite Lieb-Robinson velocity $v_{LR}$ ensure that the emergent continuum theory is local -- no instantaneous signaling at distances $d \gg a$.

3. **Universality:** Different UV completions with the same symmetries and dimensionality flow to the same IR theory (Wilson's universality). The specific form of the lattice interaction $h_{xy} = JF$ determines only the non-universal parameters (coupling constants, velocity) of the IR theory, not its qualitative structure.

This is the standard assumption in all lattice approaches to quantum gravity and quantum field theory:
- Lattice QCD: the Wilson plaquette action (UV) flows to continuum QCD (IR)
- Causal dynamical triangulations: the discrete triangulation (UV) flows to smooth spacetime (IR)
- Regge calculus: the simplicial geometry (UV) flows to smooth Riemannian geometry (IR)

**We do not attempt a rigorous construction of the continuum limit.** The statement is a physical argument following Wilson's renormalization group philosophy: at length scales $L \gg a$, only symmetry-allowed long-wavelength operators survive in the effective description.

### A.3 What the Continuum Limit Produces

In the continuum limit, the following structures are ARGUED (not proven) to emerge at scales $L \gg a$:

1. **A smooth Riemannian manifold** $(M, g_{ab})$ as the emergent spatial geometry. Lattice sites become points on $M$; the graph metric becomes the Riemannian distance.

2. **Geodesic balls** $B$ of radius $R \gg a$ containing many lattice sites, with well-defined boundary $\partial B$.

3. **Causal diamonds** $\mathcal{D}(B)$ constructed from the emergent causal structure set by $v_{LR} \to c$ (the emergent speed of light). The conformal Killing vector $\chi^a$ of $\mathcal{D}(B)$ is defined on the emergent manifold.

4. **The Raychaudhuri equation** for null congruences, as a consequence of the differential geometry on the emergent manifold.

5. **Modular Hamiltonian** $K$ with the Casini-Huerta-Myers (CHM) form for approximately conformal IR physics (see Part D for the conformal restriction).

**These structures do NOT exist on the finite lattice.** Geodesics, Ricci curvature, and the Raychaudhuri equation are properties of smooth manifolds. They do not have lattice analogues. All continuum geometry must be understood as emergent at long wavelengths.

The Phase 10 derivation (Plan 02) operates entirely in the continuum, using lattice results only through the Wilsonian mapping established in Part B below.

---

## Part B: Lattice-to-Continuum Mapping

### B.1 Boundary Area

The lattice boundary count $|\partial(A)|$ (number of bonds crossing the cut between region $A$ and its complement) maps to a physical area:

$$A_{\text{phys}} = |\partial(A)| \cdot a^{d-1} \tag{10-01.1}$$

where $d$ is the number of spatial dimensions and $a$ is the lattice spacing.

**Dimensional check:** $[A_{\text{phys}}] = [\text{count}] \cdot [\text{length}]^{d-1} = [\text{length}]^{d-1} = [\text{area in } d \text{ spatial dimensions}]$. Consistent.

### B.2 Entropy Density

The lattice entropy bound (Phase 9, Eq. 09-03.2):

$$S_{\text{lattice}} = \eta_{\text{lattice}} \cdot |\partial(A)| \tag{10-01.2a}$$

where $\eta_{\text{lattice}} \leq \log(n)$ from channel capacity (for pure states, Phase 9 Plan 02).

In the continuum:

$$S_{\text{continuum}} = \eta \cdot A_{\text{phys}} \tag{10-01.2b}$$

where $\eta$ is the continuum entropy density per unit area.

Substituting $A_{\text{phys}} = |\partial| \cdot a^{d-1}$ and requiring $S_{\text{lattice}} = S_{\text{continuum}}$:

$$\eta_{\text{lattice}} \cdot |\partial| = \eta \cdot |\partial| \cdot a^{d-1}$$

$$\therefore \quad \eta = \frac{\eta_{\text{lattice}}}{a^{d-1}} \tag{10-01.3}$$

**Dimensional check:** $[\eta] = [\text{dimensionless}] / [\text{length}]^{d-1} = [1/\text{length}^{d-1}]$. This is the entropy per unit area in the continuum. Consistent.

### B.3 Channel Capacity Bound on $\eta$

From Phase 9 Plan 02, $\eta_{\text{lattice}} \leq \log(n)$ (channel capacity per bond). Therefore:

$$\eta \leq \frac{\log(n)}{a^{d-1}} \tag{10-01.4}$$

**Dimensional check:** $[\log(n)/a^{d-1}] = [1/\text{length}^{d-1}]$. Consistent with $[\eta]$.

### B.4 Newton's Constant

Following Jacobson 2012 (arXiv:1204.6349), the UV entropy density $\eta$ determines Newton's constant via:

$$G = \frac{1}{4\eta} \tag{10-01.5}$$

This is the central identification: the Bekenstein-Hawking entropy $S = A/(4G)$ is EQUIVALENT to $S = \eta A$, with $\eta = 1/(4G)$.

**Dimensional check:** $[G] = 1/[\eta] = [\text{length}]^{d-1}$. In $d+1$ spacetime dimensions with natural units ($\hbar = c = 1$), $[G] = [\text{length}]^{d-1}$. This is correct: in $3+1$ dimensions, $[G] = [\text{length}]^2 = [1/\text{mass}]^2$ (Planck units), and in $d+1$ dimensions, $[G] = [\text{length}]^{d-1}$.

**Cross-check:** $[G \cdot \eta] = [\text{length}]^{d-1} \cdot [1/\text{length}^{d-1}] = [\text{dimensionless}] = 1/4$. Consistent.

### B.5 The Planck Scale

Using the channel capacity bound (Eq. 10-01.4) in Eq. (10-01.5):

$$G \geq \frac{a^{d-1}}{4\log(n)} \tag{10-01.6}$$

This identifies the lattice spacing $a$ with the Planck length (up to factors of $\log(n)$):

$$a \leq (4G\log(n))^{1/(d-1)} \tag{10-01.7}$$

In $d = 3$ spatial dimensions: $a \leq (4G\log(n))^{1/2} = 2\ell_P \sqrt{\log(n)}$ where $\ell_P = \sqrt{G}$ is the Planck length (in natural units).

The lattice spacing $a$ is of order the Planck length, with the local Hilbert space dimension $n$ entering only logarithmically. This is physically expected: the lattice is the Planckian microstructure of spacetime.

### B.6 Emergent Speed of Light

From Phase 8 (Eq. 08-03.3), the Lieb-Robinson velocity on $\mathbb{Z}^1$ is:

$$v_{LR} = \frac{8eJ}{e-1} \approx 12.66 \, J \tag{10-01.8}$$

In the continuum limit, $v_{LR}$ sets the emergent speed of light $c$:

$$v_{LR} \to c \quad (\text{emergent speed of light}) \tag{10-01.9}$$

When restoring the lattice spacing $a$, the velocity has dimensions:

$$[v_{LR}] = [J \cdot a / \hbar] = [\text{energy} \cdot \text{length} / \text{action}] = [\text{length}/\text{time}] = [\text{velocity}]$$

In natural units with $a_{\text{lat}} = 1$ (Phase 8 convention), $[v_{LR}] = [J] = [\text{energy}] = [1/\text{time}]$, which is consistent since $[a_{\text{lat}}] = [1]$ means length and time have units of $[1/\text{energy}]$.

**Dimensional check:** With $a$ restored: $[v_{LR}] = [J \cdot a] = [\text{velocity}]$. Consistent.

SELF-CRITIQUE CHECKPOINT (Part B complete):
1. SIGN CHECK: All quantities ($\eta$, $G$, $a$, $v_{LR}$) are positive. No sign issues.
2. FACTOR CHECK: Factor of 4 in $G = 1/(4\eta)$ from Bekenstein-Hawking. Factor of $\log(n)$ from channel capacity. No spurious factors of $2\pi$ or $\hbar$.
3. CONVENTION CHECK: Natural units, metric $(-,+,+,+)$, $K_A = -\ln\rho_A$, $H = \sum h_{xy}$. Consistent with Phase 9.
4. DIMENSION CHECK: $[G \cdot \eta] = [\text{dimensionless}] = 1/4$. $[G] = [\text{length}]^{d-1}$ in $d+1$ spacetime. All consistent.

All checks pass.

---

## Part C: What Continuum Structures Emerge

### C.1 Emergent Geometry

The following summary collects the continuum structures that the Wilsonian argument asserts emerge at scales $L \gg a$:

| Lattice Object | Continuum Emergent | Status |
|---|---|---|
| Graph $G = (V, E)$ | Smooth manifold $(M, g_{ab})$ | Argued (Wilsonian) |
| Bond count $|\partial(A)|$ | Area $\mathcal{A} = |\partial| \cdot a^{d-1}$ | Mapping (exact rescaling) |
| LR velocity $v_{LR}$ | Speed of light $c$ | Physical identification |
| $\eta_{\text{lattice}} = S/|\partial|$ | $\eta = 1/(4G)$ | Jacobson 2012 |
| Lattice region $A \subset V$ | Geodesic ball $B \subset M$ | Argued (Wilsonian) |
| Lattice boundary $\partial(A) \subset E$ | Entangling surface $\partial B$ | Argued (Wilsonian) |

### C.2 Structures That Do NOT Exist on the Lattice

The following continuum objects have no lattice analogues and must be understood as emergent:

- **Geodesics:** The graph shortest path is a lattice approximation, but the smooth geodesic equation $\nabla_{\dot{\gamma}} \dot{\gamma} = 0$ does not exist on the graph.
- **Ricci curvature:** $R_{ab}$ requires second derivatives of the metric, which requires smoothness. The lattice has no curvature.
- **Raychaudhuri equation:** $d\theta/d\lambda = -(1/2)\theta^2 - \sigma^2 + \omega^2 - R_{ab}k^a k^b$ is a statement about null congruences on a smooth Lorentzian manifold.
- **Conformal Killing vector:** $\chi^a$ of the causal diamond $\mathcal{D}(B)$ requires the smooth causal structure.
- **Stress-energy tensor:** $T_{ab}$ is defined as the functional derivative of the matter action with respect to the metric, requiring a smooth spacetime.

Writing a "lattice Raychaudhuri equation" or a "lattice $R_{ab}$" would be a category error. These objects emerge in the IR, and the Phase 10 derivation uses them only in the continuum.

---

## Part D: The Conformal Field Restriction

### D.1 Jacobson 2016 Is Rigorous for Conformal Fields

Jacobson's 2016 derivation of Einstein's equations is rigorous when the entanglement entropy is computed for a **conformal field theory** (CFT). In a CFT, the Casini-Huerta-Myers (CHM) modular Hamiltonian for a geodesic ball $B$ of radius $R$ takes the exact form:

$$K_B^{\text{CFT}} = 2\pi \int_B d^{d-1}x \; \frac{R^2 - r^2}{2R} \; T_{00}(x) \tag{10-01.10}$$

where $r = |x - x_0|$ is the distance from the center of the ball. This formula is exact for CFTs and relates the modular Hamiltonian directly to the stress-energy tensor. The entanglement first law $\delta S = \delta\langle K\rangle$ then produces:

$$\delta S = 2\pi \int_B d^{d-1}x \; \frac{R^2 - r^2}{2R} \; \delta\langle T_{00}(x) \rangle \tag{10-01.11}$$

This is the starting point for deriving Einstein's equations (see Plan 02).

### D.2 The Self-Modeling Lattice Is Generally Non-Conformal

The self-modeling Hamiltonian $H = \sum JF_{xy}$ is:
- **Integrable in 1D** ($d = 1$, spin chain): The isotropic Heisenberg chain with $J > 0$ (AFM) flows to the $SU(2)_1$ Wess-Zumino-Witten (WZW) CFT at low energies. This is a genuine CFT with central charge $c = 1$.
- **Not a CFT in $d \geq 2$**: The Heisenberg model in $d \geq 2$ is an interacting quantum magnet with a finite correlation length (for some phases) or long-range order (Neel state), but does not flow to a free CFT.

### D.3 Nonconformal Corrections

For nonconformal fields, the CHM formula (Eq. 10-01.10) receives corrections. Following Speranza 2016 (arXiv:1602.01380), the corrections to the modular Hamiltonian for a massive deformation of a CFT are of order:

$$\delta K \sim O\left((mR)^{2\Delta}\right) \tag{10-01.12}$$

where $m$ is the mass scale of the relevant deformation and $\Delta$ is its scaling dimension.

### D.4 Window of Approximate Conformality

At scales $R$ satisfying:

$$a \ll R \ll 1/m \tag{10-01.13}$$

(if the IR theory has massive excitations with mass $m$), the theory is approximately conformal:

- $R \gg a$: the continuum limit is valid (many lattice sites in the ball)
- $R \ll 1/m$: the mass deformation is irrelevant at this scale; the theory looks approximately scale-invariant

In this window, the CHM formula is approximately valid, with corrections suppressed by $(mR)^{2\Delta} \ll 1$.

This is the standard Wilsonian argument: near the UV fixed point (short distances relative to the correlation length), the theory is approximately scale-invariant. The Jacobson derivation operates in this regime.

**Limitation:** This window may be empty if the IR theory has no mass gap (as in the 1D AFM case where $m = 0$ and the theory is exactly conformal), or if the mass scale is comparable to the lattice scale ($m \sim 1/a$), in which case the continuum limit and the conformal approximation break down simultaneously.

For the 1D AFM Heisenberg chain ($n = 2$, $J > 0$), the theory IS a CFT ($SU(2)_1$ WZW), and Eq. (10-01.10) is exact. This is the most controlled case.

### D.5 Summary of Conformal Restriction

| Case | Conformality | CHM Formula Status | Jacobson Derivation |
|---|---|---|---|
| 1D AFM ($n = 2$, $J > 0$) | Exact ($SU(2)_1$ WZW, $c = 1$) | Exact | Rigorous |
| $d \geq 2$, near UV fixed point | Approximate ($a \ll R \ll 1/m$) | Approximate, corrections $O((mR)^{2\Delta})$ | Conditional on window existing |
| $d \geq 2$, IR regime | Non-conformal | Not applicable | Requires extension (Jacobson 2016, Section IV conjecture) |

Jacobson 2016 (Section IV) conjectures that the result extends to nonconformal fields with corrections that do not spoil the leading-order Einstein equation. The conjecture is physically motivated but not proven.

SELF-CRITIQUE CHECKPOINT (Parts A-D complete):
1. SIGN CHECK: Metric $(-,+,+,+)$ stated. Einstein tensor $G_{ab} = R_{ab} - (1/2)Rg_{ab}$. No sign errors in formulas.
2. FACTOR CHECK: CHM formula has factor $2\pi$ and $(R^2 - r^2)/(2R)$ -- these are standard (Casini-Huerta-Myers 2011). $G = 1/(4\eta)$ has factor 4 from Bekenstein-Hawking.
3. CONVENTION CHECK: Natural units, $(-,+,+,+)$ metric, $K = -\ln\rho$, $H = \sum h_{xy}$. All consistent with Phase 9 and plan frontmatter.
4. DIMENSION CHECK: $[K] = [\text{dimensionless}]$ ($K = -\ln\rho$). Eq. (10-01.10): $[2\pi] \cdot [\text{length}^{d-1}] \cdot [\text{length}^2/\text{length}] \cdot [T_{00}]$. Need $[T_{00}] = [\text{energy}/\text{length}^{d-1}] = [\text{length}^{-d-1+1}]$ in natural units. So $[\text{length}^{d-1}] \cdot [\text{length}] \cdot [\text{length}^{-d}] = [\text{dimensionless}]$. Consistent with $[K] = [\text{dimensionless}]$.

All checks pass.

---

## Part E: Maximal Vacuum Entanglement Hypothesis (MVEH)

### E.1 Statement

The Maximal Vacuum Entanglement Hypothesis (Jacobson 2016, arXiv:1505.04753) states:

> **MVEH:** Among all quantum states with the same expectation value of the stress-energy tensor $T_{ab}$, the vacuum state $|0\rangle$ maximizes the entanglement entropy $S(A)$ for any small geodesic ball $A$.

Equivalently: the vacuum is an entanglement equilibrium state. Under first-order perturbations that preserve $\langle T_{ab} \rangle$:

$$\delta S_{\text{EE}} = 0 \quad \text{(vacuum is an entropy extremum)} \tag{10-01.14}$$

Combined with the physical expectation that the vacuum is an entropy MAXIMUM (not a minimum or saddle point), this gives "entanglement equilibrium":

$$\delta S = 0 \quad \text{for the vacuum, at fixed } \langle T_{ab} \rangle \tag{10-01.15}$$

### E.2 Why MVEH Matters

The entanglement entropy of a geodesic ball has two contributions (Jacobson 2016):

$$S = S_{\text{UV}} + S_{\text{mat}} \tag{10-01.16}$$

where:
- $S_{\text{UV}}$ is the UV-divergent part, proportional to the area $\mathcal{A}$ of the entangling surface. This is the Bekenstein-Hawking-like contribution: $S_{\text{UV}} = \eta \mathcal{A}$.
- $S_{\text{mat}}$ is the finite, state-dependent part arising from matter excitations above the vacuum.

Entanglement equilibrium ($\delta S = 0$) then requires:

$$\delta S_{\text{UV}} + \delta S_{\text{mat}} = 0 \tag{10-01.17}$$

This balances the geometric change in area ($\delta S_{\text{UV}} \propto \delta\mathcal{A}$) against the matter entanglement change ($\delta S_{\text{mat}}$), yielding Einstein's equation (see Plan 02 for the full derivation).

Without MVEH, there is no reason for $\delta S = 0$, and the derivation does not proceed. MVEH is the physical principle that makes Einstein's equation an equilibrium condition.

### E.3 Formulation as Assumption A5

We formulate MVEH as **Assumption A5** for the self-modeling lattice:

> **A5 (Maximal Vacuum Entanglement Hypothesis).** The self-modeling equilibrium state, when mapped to the emergent continuum description via the Wilsonian continuum limit (Part A), maximizes entanglement entropy among states with the same stress-energy tensor expectation value.

Precisely: let $\rho_0$ be the vacuum state of the emergent continuum theory. For any geodesic ball $B$ with $R \gg a$:

$$S(\rho_{0,B}) \geq S(\sigma_B) \quad \text{for all } \sigma \text{ with } \langle T_{ab} \rangle_\sigma = \langle T_{ab} \rangle_{\rho_0} \tag{10-01.18}$$

where $\rho_{0,B} = \text{Tr}_{\bar{B}}(\rho_0)$ is the reduced state of the vacuum on $B$.

**A5 is an ASSUMPTION, not a theorem.** It is not derived from the self-modeling axioms.

### E.4 MaxEnt Motivation for A5

The principle of Maximum Entropy (MaxEnt, Jaynes 1957) provides physical motivation for A5:

**The MaxEnt principle:** Given a set of constraints (e.g., fixed expectation values of observables), the state that maximizes the entropy is the least biased (most typical) state consistent with those constraints.

**Application to the self-modeling lattice:**

1. The self-modeling fixed point is the state (or class of states) that best satisfies the self-modeling constraint: $\mathcal{E}(a) = a \mathbin{\&} \mathcal{E}(u)$ for all effects $a$ in the local algebra.

2. MaxEnt reasoning suggests that among all states satisfying the self-modeling constraint, the equilibrium state is the one that maximizes entropy. The self-modeling constraint selects a specific class of dynamics ($H = \sum JF$, Phase 8), and the equilibrium state of this dynamics at fixed energy is the Gibbs state (MaxEnt at fixed energy).

3. In the continuum limit, "at fixed energy-momentum distribution" maps to "at fixed $\langle T_{ab} \rangle$." The MaxEnt state at fixed $\langle T_{ab} \rangle$ is the vacuum (by definition: the vacuum maximizes $S$ among states with vanishing stress-energy, and the argument extends perturbatively to nearby $\langle T_{ab} \rangle$).

**This is a PHYSICAL ARGUMENT, not a proof.** The chain of reasoning contains several non-rigorous steps:

- The mapping from "self-modeling constraint" to "fixed $T_{ab}$" is part of the continuum limit and inherits its uncertainties (Part A).
- The identification of the self-modeling equilibrium with the MaxEnt state at fixed $T_{ab}$ assumes that the Wilsonian continuum limit preserves the entropy-maximizing character.
- The extension from "MaxEnt at fixed energy" (lattice) to "MaxEnt at fixed $T_{ab}$" (continuum) requires that the local energy density resolves into the full stress-energy tensor in the continuum limit.

### E.5 Gap Statement for A5

**What self-modeling property would ESTABLISH A5?**

A rigorous proof of A5 would require showing:

1. The self-modeling equilibrium state (the state that minimizes the self-modeling mismatch, or equivalently the Gibbs state of $H = \sum JF$) maps to a state in the continuum that satisfies MVEH.

2. Specifically: in the continuum limit, this state must maximize $S(B)$ for small geodesic balls $B$ among all states with the same $\langle T_{ab} \rangle$.

3. This is equivalent to showing that the self-modeling equilibrium is an "entanglement equilibrium" state in the sense of Jacobson 2016.

**Current status:** No such proof exists. For conformal field theories, Jacobson 2016 showed that MVEH is EQUIVALENT to Einstein's equations. This means A5 is exactly as strong as the conclusion for CFT: assuming A5 gives Einstein's equations, but Einstein's equations also imply A5 (for CFT). For the self-modeling lattice, where the IR theory is generally non-conformal, A5 remains a genuine assumption.

**What would disconfirm A5:** If one could construct a state $\sigma$ of the self-modeling lattice in the continuum limit with $\langle T_{ab} \rangle_\sigma = \langle T_{ab} \rangle_{\rho_0}$ but $S(\sigma_B) > S(\rho_{0,B})$, then A5 would fail and Einstein's equations would not follow from this argument alone.

---

## Part F: Extended Assumption Register A1-A5

Inheriting A1-A4 from Phase 9 (derivations/09-area-law-synthesis.md, Part E) and adding A5:

| ID | Assumption | Statement | Status | What It Buys | What Fails Without It |
|---|---|---|---|---|---|
| A1 | Thermal state | $\rho = e^{-\beta H}/Z$ at finite $T > 0$ | Physical (MaxEnt + KMS) | WVCH MI area law $I \leq 2\beta|\partial||J|$ | MI bound fails; fall back to A2 or $\delta S$ route |
| A2 | Pure global state | Global state is pure $|\psi\rangle$ | Physical (closed system) | von Neumann $S$ area law $S \leq \log(n)|\partial|$ | $S$ area law uncontrolled; fall back to A1 or $\delta S$ route |
| A3 | Modular $K$ locality | $K_A$ concentrated near $\partial(A)$ | Physical (BW + Peschel) | $\delta S \sim |\partial|$ (Eq. 09-03.6) | $\delta S$ may be volume-law; Jacobson (J1) fails |
| A4 | Lattice as Hamiltonian system | Lattice QM captures self-modeling | Derived (Phase 8) | All lattice machinery applies | Must use different formalism |
| A5 | MVEH | Vacuum maximizes $S$ at fixed $\langle T_{ab} \rangle$ | Physical (MaxEnt motivation) | Einstein's equations follow (Plan 02) | Only conditional: "if A5 then Einstein" |

### F.1 Assumption Hierarchy

- **A4 (derived):** This is the most secure assumption -- it follows from Phase 8's mapping of self-modeling to lattice quantum mechanics.
- **A1, A2 (physical, standard):** These are standard physical assumptions used throughout quantum statistical mechanics and quantum information. They are well-motivated but not derived from self-modeling.
- **A3 (physical, motivated):** Physically motivated by Bisognano-Wichmann and Peschel results, but not proven for the self-modeling lattice specifically. This is the weakest of A1-A4.
- **A5 (physical, weakest):** The most significant assumption. For CFT, it is equivalent to the conclusion (Jacobson 2016). For non-CFT, it is a genuine additional postulate.

### F.2 Logical Dependence

```
A4 (derived) --> enables lattice QM formulation
    |
    +-- A1 (thermal) --> WVCH MI area law
    +-- A2 (pure) --> channel capacity S area law
    +-- A3 (K locality) --> delta S ~ |boundary|
    |       |
    |       +-- Entanglement first law (exact) --> delta S = delta <K>
    |               |
    +-- A5 (MVEH) --+--> delta S = 0 for vacuum
                    |
                    +--> Einstein's equations (Plan 02)
```

The derivation of Einstein's equations in Plan 02 requires: A4 + A3 + A5 (plus the Wilsonian continuum limit).

---

## Part G: Jacobson Input Status Table

The three inputs required by Jacobson's 2016 derivation, and their status for the self-modeling lattice:

| Jacobson Input | Content | Status | Source | Assumption | Notes |
|---|---|---|---|---|---|
| **(J1)** Area-law $\delta S$ | $\delta S \sim |\partial(A)|$ for local perturbations | **Established** | Phase 9, Eq. 09-03.6 | A3 (modular $K$ locality) | Also supported by static area-law bounds (A1 or A2) |
| **(J2)** Entanglement first law | $\delta S = \delta\langle K_A \rangle$ | **Exact identity** | Phase 9, Eq. 09-03.3 | None | Standard QI result; holds for any state and perturbation |
| **(J3)** MVEH | $\delta S = 0$ for vacuum at fixed $\langle T_{ab} \rangle$ | **Assumed as A5** | This plan (Part E) | A5 (MVEH) | Motivated by MaxEnt; equivalent to conclusion for CFT |

### G.1 What Is Delivered vs. What Is Assumed

**Delivered by Phase 9:**
- (J1): $\delta S \sim |\partial|$ via three complementary perspectives (Eq. 09-03.6 under A3; Eq. 09-03.1 under A1; Eq. 09-03.2 under A2)
- (J2): $\delta S = \delta\langle K\rangle$ as exact identity (Eq. 09-03.3)

**Assumed in Phase 10:**
- (J3): MVEH as Assumption A5, with MaxEnt motivation (Part E) and explicit gap statement (Part E.5)

**The derivation of Einstein's equations in Plan 02 is therefore CONDITIONAL on A5.**

The result has the structure: "If A1-A5 hold for the self-modeling lattice, then in the Wilsonian continuum limit, Einstein's equations $G_{ab} + \Lambda g_{ab} = 8\pi G \, T_{ab}$ emerge as the leading-order gravitational dynamics."

### G.2 Equivalence for CFT

Jacobson 2016 proved: for conformal fields, MVEH $\Leftrightarrow$ Einstein's equations. This means:
- A5 is exactly as strong as the conclusion for conformal fields
- The argument is circular for CFT in the sense that assuming the result gives the result
- The non-trivial content is the PHYSICAL MOTIVATION for A5 (MaxEnt) rather than its logical status

For nonconformal fields (the generic case for the self-modeling lattice), A5 is a genuine additional postulate that is strictly stronger than the conclusion, since the equivalence has not been established beyond CFT.

---

## Part H: Complete Input Summary for Plan 02

Plan 02 will use the following inputs from this plan:

1. **Wilsonian continuum limit** (Part A): Lattice $\to$ smooth manifold at scales $L \gg a$
2. **Lattice-to-continuum mapping** (Part B): $\eta = \eta_{\text{lattice}}/a^{d-1}$, $G = 1/(4\eta)$, $v_{LR} \to c$
3. **CHM formula** (Part D): $K_B^{\text{CFT}} = 2\pi \int (R^2 - r^2)/(2R) \, T_{00} \, d^{d-1}x$ (exact for CFT, approximate otherwise)
4. **MVEH as A5** (Part E): $\delta S = 0$ for vacuum at fixed $\langle T_{ab} \rangle$
5. **UV/matter decomposition** (Part E.2): $S = S_{\text{UV}} + S_{\text{mat}}$, with $\delta S_{\text{UV}} + \delta S_{\text{mat}} = 0$
6. **Assumption register A1-A5** (Part F): Complete tracking of all assumptions
7. **Jacobson input status** (Part G): (J1) established, (J2) exact, (J3) assumed as A5

---

_End of derivation. Phase 10, Plan 01._
