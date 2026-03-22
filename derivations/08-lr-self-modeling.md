# Lieb-Robinson Velocity for the Self-Modeling Hamiltonian

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, sequential_product=a_ampersand_b, composite_product=product_form, coupling_convention=H_sum_hxy, entropy_base=nats, commutation_convention=standard, lattice_spacing=1

**Phase:** 08-locality-formalization, Plan 03
**Date:** 2026-03-22

**References:**
- [1] Nachtergaele, Sims, Young, J. Math. Phys. 60, 061101 (2019), arXiv:1810.02428
- [2] Lieb, Robinson, Commun. Math. Phys. 28, 251 (1972)
- [3] Paper 5 (v2.0): composite OUS axioms C1-C4, product-form SP

## Part A: Interaction Norm for the Self-Modeling Hamiltonian

### A.1 Recap: The Self-Modeling Interaction

From Plan 01 (derivation in `derivations/08-hamiltonian-construction.md`), the self-modeling interaction Hamiltonian on two adjacent sites $\{x,y\} \in E$ is:

$$h_{xy} = \alpha \, \mathbf{1}_{n^2} + J \, F, \qquad F(v \otimes w) = w \otimes v$$

where $\alpha \in \mathbb{R}$ is a constant energy shift (no dynamics) and $J \in \mathbb{R} \setminus \{0\}$ is the coupling constant. The SWAP operator $F$ is self-adjoint with $F^2 = \mathbf{1}$ and eigenvalues $\pm 1$.

For $n = 2$: $h_{xy}^{\mathrm{int}} = \frac{J}{2}(\sigma_1 \otimes \sigma_1 + \sigma_2 \otimes \sigma_2 + \sigma_3 \otimes \sigma_3)$ (isotropic Heisenberg).

### A.2 Operator Norm

The operator norm of the interaction part:

$$\|h_{xy}^{\mathrm{int}}\| = \|JF\| = |J| \cdot \|F\| = |J| \cdot 1 = |J|$$

since $F$ has eigenvalues $\pm 1$, so $\|F\| = 1$ (operator norm = largest absolute eigenvalue for self-adjoint operators).

**Dimensional check:** $[\|h_{xy}\|] = [J] = [\text{energy}]$. $\checkmark$

**Note on the family:** Plan 01 established that the compatible Hamiltonians form a 1-parameter family indexed by $J$. The constant $\alpha$ does not affect the dynamics or the LR velocity (it commutes with everything). We set $\alpha = 0$ WLOG for the LR computation. The energy scale is set by $\|h_{xy}^{\mathrm{int}}\| = |J|$; we take $J > 0$ WLOG.

### A.3 Weighted Interaction Norm

From the NS framework (Plan 02, Eq. 11), for nearest-neighbor interactions with uniform coupling $\|h_{xy}\| = J$ on a lattice with coordination number $z$:

$$\|\Phi\|_a = z \cdot J \cdot e^a$$

where $a > 0$ is the decay parameter of the exponential F-function $F_a(r) = e^{-ar}$.

This is identical to the Heisenberg benchmark in Plan 02. The self-modeling Hamiltonian has the same interaction form (nearest-neighbor, uniform coupling $J$) and therefore the same weighted interaction norm.

## Part B: LR Velocity Computation

### B.1 General Formula

Combining the NS framework (Plan 02):

$$v_{LR}(a) = \frac{2\|\Phi\|_a \, C_a}{a} = \frac{2zJe^a}{a}\left[\left(\coth\frac{a}{2}\right)^d - 1\right]$$

### B.2 Results by Dimension

**$\mathbb{Z}^1$ ($z = 2$, $d = 1$):**

$$v_{LR}(a) = \frac{8Je^a}{a(e^a - 1)}$$

At $a = 1$: $v_{LR} = \frac{8eJ}{e - 1} \approx 12.66 \, J$

Since $v_{LR}(a)$ is monotonically decreasing on $\mathbb{Z}^1$ (see Plan 02, Section 6), there is no finite minimizer. The NS framework provides a family of bounds parameterized by $a$; we report $a = 1$ as the reference value.

**$\mathbb{Z}^2$ ($z = 4$, $d = 2$):**

$$v_{LR}(a) = \frac{8Je^a}{a}\left[\left(\coth\frac{a}{2}\right)^2 - 1\right]$$

At $a = 1$: $v_{LR} \approx 80.08 \, J$

$v_{LR}(a)$ is monotonically decreasing on $\mathbb{Z}^2$ as well (no finite minimizer).

**$\mathbb{Z}^3$ ($z = 6$, $d = 3$):**

$$v_{LR}(a) = \frac{12Je^a}{a}\left[\left(\coth\frac{a}{2}\right)^3 - 1\right]$$

At $a = 1$: $v_{LR} \approx 297.92 \, J$

$v_{LR}(a)$ is monotonically decreasing on $\mathbb{Z}^3$ as well (no finite minimizer).

(Values computed in `code/self_modeling_lr_velocity.py`.)

### B.3 Full LR Bound Constants

The LR bound for single-site observables (Eq. 4 of Plan 02 framework):

$$\|[\tau_t(A_x), B_y]\| \leq \frac{2\|A\|\|B\|}{C_a}\left(e^{2\|\Phi\|_a C_a |t|} - 1\right)e^{-a \, d(x,y)}$$

In the form $\|[\tau_t(A_x), B_y]\| \leq C_{LR} \|A\|\|B\| \, e^{-\mu_{LR}(d(x,y) - v_{LR}|t|)}$:

- **$C_{LR}$**: the prefactor $2/C_a$ (depends on $a$; not a simple constant)
- **$\mu_{LR} = a$**: the spatial decay rate outside the light cone
- **$v_{LR}$**: as computed above

For the reference value $a = 1$ on $\mathbb{Z}^1$:
- $C_{LR} = 2/C_1 = 2 \cdot (e-1)/2 = e - 1 \approx 1.718$
- $\mu_{LR} = 1$ (in units of $a_{\text{lat}}^{-1}$)
- $v_{LR} = 8eJ/(e-1) \approx 12.66 \, J$ (in units of $J \cdot a_{\text{lat}}$)

**Dimensional check:**
- $[C_{LR}] = \text{dimensionless}$. $\checkmark$
- $[\mu_{LR}] = [a_{\text{lat}}^{-1}] = \text{dimensionless}$ (since $a_{\text{lat}} = 1$). $\checkmark$
- $[v_{LR}] = [J] = [\text{energy}] = [1/\text{time}]$ (natural units, $a_{\text{lat}} = 1$). Velocity = distance/time, and with $a_{\text{lat}} = 1$ and $\hbar = 1$: $[v] = [a_{\text{lat}}/\text{time}] = [1/\text{time}] = [\text{energy}]$. $\checkmark$

## Part C: Comparison with Heisenberg Benchmark

The self-modeling Hamiltonian for $n = 2$ IS the isotropic Heisenberg interaction. Therefore:

$$\frac{v_{LR}^{SM}}{v_{LR}^{Heisenberg}} = \frac{\|h_{xy}^{SM}\|}{\|h_{xy}^{Heisenberg}\|} = 1$$

when both are normalized to the same coupling constant $J$.

This is the expected result: Plan 01 derived that the self-modeling coupling is uniquely the Heisenberg interaction (up to the overall scale $J$), so the LR velocities are identical.

For general $n$: the interaction is still $h_{xy} = JF$ where $F$ is the SWAP on $\mathbb{C}^n \otimes \mathbb{C}^n$. The SWAP operator on $\mathbb{C}^n \otimes \mathbb{C}^n$ has eigenvalues $+1$ (on symmetric subspace, dimension $n(n+1)/2$) and $-1$ (on antisymmetric subspace, dimension $n(n-1)/2$). So $\|F\| = 1$ for all $n$, and $\|h_{xy}\| = |J|$ for all $n$. The LR velocity is independent of $n$:

$$v_{LR}^{SM}(n) = v_{LR}^{SM}(n=2) \quad \forall \, n \geq 2$$

(at fixed $J$, $z$, $d$, $a$).

## Part D: Effective Causal Structure

### D.1 Light Cone Statement

**Theorem (Effective light cone).** For the self-modeling lattice with interaction $h_{xy} = JF$ on a graph $G = (V, E)$, the Heisenberg evolution $\tau_t(A) = e^{iHt}Ae^{-iHt}$ satisfies:

$$\|[\tau_t(A_x), B_y]\| \leq \frac{2\|A\|\|B\|}{C_a}\left(e^{2\|\Phi\|_a C_a |t|} - 1\right)e^{-a \, d(x,y)}$$

for all $a > 0$, where $C_a = (\coth(a/2))^d - 1$ and $\|\Phi\|_a = zJe^a$.

The commutator is exponentially suppressed when $d(x,y) > v_{LR}(a)|t|$:

$$\|[\tau_t(A_x), B_y]\| \lesssim e^{-a(d(x,y) - v_{LR}(a)|t|)} \quad \text{for } d(x,y) \gg v_{LR}(a)|t|$$

This defines an **effective light cone** on the lattice with:
- **Cone slope:** $v_{LR}(a) = 2zJe^a C_a / a$ (velocity of the cone boundary)
- **Decay rate:** $\mu = a$ (exponential suppression outside the cone)

### D.2 Interpretation for Downstream Phases

**Phase 9 (Area Law):** The LR bound provides the "locality" input for area-law arguments. The key ingredient is the exponential decay of correlations outside the light cone: ground state correlations $\langle A_x B_y \rangle - \langle A_x \rangle \langle B_y \rangle$ decay at least exponentially in $d(x,y)$ for gapped Hamiltonians (Hastings 2004). The self-modeling Hamiltonian has LR velocity $v_{LR}$ which bounds how fast correlations can build up, constraining the entanglement structure.

**Phase 10 (Jacobson):** The LR velocity $v_{LR}$ provides the **emergent speed of light** -- the maximum speed of information propagation in the self-modeling lattice. In the continuum limit, this should match the light cone of the emergent spacetime metric. The identification $c_{\text{emergent}} = v_{LR}$ connects the lattice causal structure to the spacetime causal structure needed for the Jacobson argument (linking entanglement entropy dynamics to Einstein equations).

**Phase 11 (Numerics):** The LR velocity sets the key timescale for simulations:
- **Equilibration time:** $t_{\text{eq}} \sim L / v_{LR}$ where $L$ is system size
- **Time window for light cone verification:** $t \sim d(x,y) / v_{LR}$
- **Numerical time step:** $\Delta t \ll 1/v_{LR}$ for stable time evolution

### D.3 Connection to Effective Spacetime Geometry

The LR light cone defines an effective causal structure on the lattice:

- **Causal future** of event $(x, t_0)$: all $(y, t)$ with $d(x,y) \leq v_{LR}|t - t_0|$ and $t > t_0$
- **Causal past** of event $(x, t_0)$: all $(y, t)$ with $d(x,y) \leq v_{LR}|t - t_0|$ and $t < t_0$
- **Spacelike separation:** $(x, t_0)$ and $(y, t)$ are approximately spacelike when $d(x,y) \gg v_{LR}|t - t_0|$ (commutator exponentially small)

In the continuum limit (Phase 10), this discrete causal structure should match the light cone of the emergent spacetime metric. The LR velocity $v_{LR}$ plays the role of the speed of light. The lattice spacing $a_{\text{lat}}$ provides a natural UV cutoff. The connection is:

$$g_{\mu\nu}^{\text{emergent}} \sim \eta_{\mu\nu} \cdot \left(\frac{v_{LR}}{c}\right)^2 + \text{corrections from curvature}$$

where the precise form depends on the continuum limit procedure, to be developed in Phase 10.

---

## Part E: Paper 5 Composite OUS Compatibility

### E.1 Setup

We verify that the lattice two-site system $\{x, y\}$ with $A_x = A_y = M_2(\mathbb{C})$ reproduces the Paper 5 composite OUS axioms (C1-C4) and the product-form SP.

The two-site algebra is $A_{\{x,y\}} = M_2(\mathbb{C}) \otimes M_2(\mathbb{C}) \cong M_4(\mathbb{C})$.

### E.2 Axiom C1 (Vector space)

**Claim:** $V_{xy} = M_4(\mathbb{C})^{\mathrm{sa}}$ contains $V_x \otimes V_y = M_2(\mathbb{C})^{\mathrm{sa}} \otimes M_2(\mathbb{C})^{\mathrm{sa}}$ as a subspace.

**Verification:** $M_2(\mathbb{C})^{\mathrm{sa}}$ has dimension 4 (basis: $\{I, \sigma_1, \sigma_2, \sigma_3\}$). The tensor product $V_x \otimes V_y$ has dimension $4 \times 4 = 16$. The space $M_4(\mathbb{C})^{\mathrm{sa}}$ also has dimension 16. Since $M_2(\mathbb{C}) \otimes M_2(\mathbb{C}) = M_4(\mathbb{C})$, the self-adjoint parts embed: every element of $M_2(\mathbb{C})^{\mathrm{sa}} \otimes M_2(\mathbb{C})^{\mathrm{sa}}$ is a self-adjoint element of $M_4(\mathbb{C})$.

**Dimension count (local tomography):** $\dim(V_{xy}) = 16 = \dim(V_x) \times \dim(V_y) = 4 \times 4$. $\checkmark$

This matches the local tomography result from Plan 05-01 and Paper 5.

### E.3 Axiom C2 (Order unit)

**Claim:** $\mathbf{1}_{xy} = \mathbf{1}_x \otimes \mathbf{1}_y = I_2 \otimes I_2 = I_4$.

**Verification:** $I_2 \otimes I_2 = I_4$ is the identity on $\mathbb{C}^4$, which is the order unit of $M_4(\mathbb{C})^{\mathrm{sa}}$. Verified numerically: $\|I_2 \otimes I_2 - I_4\| = 0$. $\checkmark$

### E.4 Axiom C3 (Product states)

**Claim:** For any states $\rho_x, \rho_y$ (density matrices on $\mathbb{C}^2$), the product state $\rho_x \otimes \rho_y$ is a valid state on $\mathbb{C}^4$.

**Verification:** If $\rho_x \geq 0$, $\mathrm{Tr}(\rho_x) = 1$ and $\rho_y \geq 0$, $\mathrm{Tr}(\rho_y) = 1$, then:
- $\rho_x \otimes \rho_y \geq 0$ (tensor product of positive operators is positive)
- $\mathrm{Tr}(\rho_x \otimes \rho_y) = \mathrm{Tr}(\rho_x) \cdot \mathrm{Tr}(\rho_y) = 1$
- $(\rho_x \otimes \rho_y)(a \otimes b) = \mathrm{Tr}[(\rho_x \otimes \rho_y)(a \otimes b)] = \mathrm{Tr}(\rho_x a) \cdot \mathrm{Tr}(\rho_y b)$

Verified numerically with 20+ random product states. $\checkmark$

### E.5 Axiom C4 (Non-signaling)

**Claim:** For any joint state $\rho_{xy}$ on $\mathbb{C}^4$, the marginals $\rho_x = \mathrm{Tr}_y(\rho_{xy})$ and $\rho_y = \mathrm{Tr}_x(\rho_{xy})$ are well-defined states. Measuring at site $x$ does not affect the marginal at site $y$.

**Verification:** For a general density matrix $\rho_{xy}$ on $\mathbb{C}^4$:
- $\rho_x = \mathrm{Tr}_y(\rho_{xy})$ is a valid 2x2 density matrix ($\geq 0$, $\mathrm{Tr} = 1$)
- $\rho_y = \mathrm{Tr}_x(\rho_{xy})$ is a valid 2x2 density matrix ($\geq 0$, $\mathrm{Tr} = 1$)
- Non-signaling: $\mathrm{Tr}[(a \otimes I)\rho_{xy}] = \mathrm{Tr}[a \, \rho_x]$ for all effects $a$ at site $x$, independent of what is measured at $y$

Verified numerically with 20+ random joint states (including entangled states). $\checkmark$

### E.6 Product-Form SP

**Claim:** $(a \otimes b) \mathbin{\&} (c \otimes d) = (a \mathbin{\&} c) \otimes (b \mathbin{\&} d)$ where $a \mathbin{\&} c = a^{1/2}ca^{1/2}$ (Luders product).

**Verification:** For effects $a, b, c, d \in M_2(\mathbb{C})^{\mathrm{sa}}$ with $0 \leq a, b, c, d \leq I$:

LHS: $(a \otimes b)^{1/2}(c \otimes d)(a \otimes b)^{1/2} = (a^{1/2} \otimes b^{1/2})(c \otimes d)(a^{1/2} \otimes b^{1/2}) = (a^{1/2}ca^{1/2}) \otimes (b^{1/2}db^{1/2})$ = RHS.

The key identity used: $(a \otimes b)^{1/2} = a^{1/2} \otimes b^{1/2}$ for positive operators $a, b \geq 0$.

% IDENTITY_CLAIM: (a tensor b)^{1/2} = a^{1/2} tensor b^{1/2} for positive a, b
% IDENTITY_SOURCE: Standard result for positive operators on tensor products (Kadison-Ringrose, Vol. II)
% IDENTITY_VERIFIED: Numerically verified for 20+ random positive operator pairs; spectral theorem on product operators gives eigenvalues lambda_i * mu_j with eigenvectors v_i tensor w_j, so sqrt gives sqrt(lambda_i) * sqrt(mu_j) = sqrt(lambda_i * mu_j). QED.

Verified numerically with 20+ random effect quadruples to relative error $< 10^{-10}$. $\checkmark$

---

## Part F: Light Cone Numerical Verification

On a chain of $N = 8$ sites with $n = 2$:
- Full Hilbert space dimension: $2^8 = 256$
- Hamiltonian: $H = \sum_{i=1}^{7} h_{i,i+1}$ with $h_{i,i+1} = JF_{i,i+1}$
- Local perturbation: $A = \sigma_z \otimes I^{\otimes 7}$ at site 1
- Probe: $B_r = I^{\otimes (r-1)} \otimes \sigma_z \otimes I^{\otimes (8-r)}$ at site $r$

Time evolution: $A(t) = e^{iHt}Ae^{-iHt}$

Commutator norm: $\|[A(t), B_r]\|$ measured at $t = 0, 0.1, 0.2, \ldots, 2.0$ (in units of $1/J$)

**Expected behavior:** For each $(t, r)$, the commutator is bounded by:
$$\|[A(t), B_r]\| \leq \frac{2\|A\|\|B_r\|}{C_a}\left(e^{2\|\Phi\|_a C_a |t|} - 1\right)e^{-a(r-1)}$$

The wavefront propagates at speed $\leq v_{LR}$. Commutators are exponentially small for $r - 1 > v_{LR} t$.

**Results:** See `code/self_modeling_lr_velocity.py` for numerical verification. All commutator norms are within the LR bound for all $(t, r)$ pairs tested.

---

## Part G: Complete Phase 8 Results Summary

### Summary Table

| Component | Source | Result |
|-----------|--------|--------|
| Lattice definition | Plan 01 | $G = (V, E)$, $A_x = M_n(\mathbb{C})$, quasi-local algebra $A$ (UHF) |
| Interaction Hamiltonian | Plan 01 | $h_{xy} = \alpha\mathbf{1} + JF$ (SWAP), for $n=2$: $(J/2)\vec\sigma\cdot\vec\sigma$ |
| Locality mapping | Plan 01 | SM-locality $\Rightarrow$ H-locality via C4 non-signaling + product-form SP |
| LR framework | Plan 02 | NS bound with $C_a = (\coth(a/2))^d - 1$, $\|\Phi\|_a = zJe^a$ |
| **LR velocity** | **Plan 03** | **$v_{LR} = 2zJe^a C_a / a$; on $\mathbb{Z}^1$: $v_{LR}(1) = 8eJ/(e-1) \approx 12.66J$** |
| **Paper 5 compatibility** | **Plan 03** | **C1-C4 + product-form SP all verified** |
| **Effective causal structure** | **Plan 03** | **Light cone with slope $v_{LR}$, exponential decay outside** |

### Phase 8 ROADMAP Success Criteria

1. **Lattice defined with $G$, $A_x$, $H$** -- $\checkmark$ (Plan 01)
2. **Self-modeling locality mapped to Hamiltonian locality** -- $\checkmark$ (Plan 01, Theorem 1)
3. **$v_{LR}$ computed with explicit $C$, $\mu$, $v_{LR}$** -- $\checkmark$ (this plan)
4. **Dimensional consistency and Bratteli-Robinson compatibility** -- $\checkmark$ (Plan 01 + this plan)
5. **Paper 5 local tomography compatibility** -- $\checkmark$ (this plan, C1-C4 + SP)

### Downstream Inputs for Phase 9

- **Hamiltonian:** $H = \sum_{\langle x,y \rangle} J F_{xy}$ on graph $G$
- **Causal structure:** LR light cone with $v_{LR} \approx 12.66J$ on $\mathbb{Z}^1$, exponential decay $e^{-a(d-v_{LR}t)}$ outside
- **Relevant states:** Ground state of $H$; for $J > 0$ (AFM): gapless on $\mathbb{Z}^1$ with log corrections to area law; for $J < 0$ (FM): gapped, product ground state, trivial area law
- **Local tomography:** $\dim(V_{xy}) = \dim(V_x) \cdot \dim(V_y) = n^4$

### Open Questions for Phase 9

1. **Which state has area-law entanglement?** For $J > 0$ (AFM Heisenberg on $\mathbb{Z}^1$), the ground state has entanglement entropy $S \sim (c/3)\ln L$ with $c = 1$ (CFT central charge). For $J < 0$ (FM), $S = 0$. The sign of $J$ determines the entanglement structure.

2. **Is $H$ gapped?** The AFM Heisenberg chain is gapless (Bethe ansatz, $c = 1$ CFT). The FM chain is gapped. For $d \geq 2$, the AFM model is believed to have Neel order and a gap (spin waves). This affects whether Hastings' area-law theorem (which requires a gap) applies directly.

3. **Family robustness:** Since the form $h_{xy} = JF$ is unique for all $n$, the area-law analysis should hold for any $n \geq 2$. The $n$-dependence only affects the Hilbert space dimension at each site, not the interaction structure or the LR velocity.

---

_Phase: 08-locality-formalization, Plan 03_
_Date: 2026-03-22_
