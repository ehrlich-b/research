# Heisenberg Ground-State Entanglement Characterization (Both Signs of J)

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, coupling_convention=H_sum_hxy, entropy_base=nats, state_normalization=Tr_rho_1, commutation_convention=standard

**Phase:** 09-area-law-derivation, Plan 01, Task 2
**Date:** 2026-03-22

---

## Part A: Ferromagnetic Case ($J < 0$)

### A.1 Ground State

For $J < 0$, the two-site interaction $h_{xy} = JF$ has eigenvalue $J < 0$ on the symmetric (triplet) subspace and eigenvalue $-J > 0$ on the antisymmetric (singlet) subspace. The ground state minimizes energy by placing every bond in the symmetric subspace.

The global ground state of $H = \sum_{\langle x,y\rangle} JF_{xy}$ with $J < 0$ is the fully polarized state:

$$|\Psi_0^{FM}\rangle = |\uparrow \uparrow \cdots \uparrow\rangle \tag{09.5}$$

and all $\mathrm{SU}(2)$ rotations thereof (coherent spin states pointing in any direction $\hat{n}$):

$$|\Psi_0^{FM}(\hat{n})\rangle = \bigotimes_{x \in V} |\hat{n}\rangle_x.$$

This is a **product state** -- it has no entanglement between any subsystems.

### A.2 Degeneracy

The ground-state manifold is the maximal total spin sector $S_{\mathrm{tot}} = N/2$ (for $N$ spin-1/2 sites). The degeneracy is:

$$\mathrm{deg} = 2S_{\mathrm{tot}} + 1 = N + 1. \tag{09.6}$$

All states in the $S = N/2$ multiplet are either product states (the coherent spin states $|\hat{n}\rangle^{\otimes N}$) or superpositions within this sector. The eigenstates $|S = N/2, M\rangle$ for $-N/2 \leq M \leq N/2$ are Dicke states, which are symmetric superpositions and have entanglement $S(A) \leq \ln(\min(|A|, N - |A|) + 1)$ (at most logarithmic in system size).

### A.3 Spectral Gap

The first excitation above the FM ground state involves flipping a single spin, creating a magnon. The magnon dispersion in 1D with periodic boundary conditions is:

$$E_k = |J|(1 - \cos k), \qquad k = \frac{2\pi m}{N}, \quad m = 0, 1, \ldots, N-1. \tag{09.7}$$

The minimum excitation energy (gap) corresponds to $k = 2\pi/N$:

$$\Delta_{FM} = |J|\left(1 - \cos\frac{2\pi}{N}\right) \approx |J| \cdot \frac{(2\pi)^2}{2N^2} = \frac{2\pi^2 |J|}{N^2}. \tag{09.8}$$

**The gap closes as $O(1/N^2)$ in the thermodynamic limit.** The FM Heisenberg model is **gapless** with a quadratic (ferromagnetic) magnon dispersion $E_k \sim |J|k^2$ at small $k$.

**Dimensional check:** $[\Delta_{FM}] = [|J|] = [\text{energy}]$. Consistent.

### A.4 Entanglement

For the canonical ground state $|\uparrow\uparrow\cdots\uparrow\rangle$:

$$S(A) = 0 \quad \text{for all } A \subseteq V. \tag{09.9}$$

This is exact: the state is a product state, so the reduced density matrix on any subsystem $A$ is a pure state $\rho_A = |\uparrow\rangle\langle\uparrow|^{\otimes |A|}$, giving $S(A) = -\mathrm{Tr}(\rho_A \ln \rho_A) = 0$.

Even within the degenerate $S = N/2$ manifold, the maximum entanglement entropy is achieved by the $M = 0$ Dicke state, which gives:

$$S_{max}(A) \leq \ln\left(\min(|A|, N - |A|) + 1\right) \sim \ln N. \tag{09.10}$$

This is at most logarithmic in system size -- far below volume-law scaling.

### A.5 FM Conclusion

The FM case **trivially satisfies** the area law: $S(A) = 0$ for the canonical ground state. However, this is physically uninteresting for the gravity connection: a product state has zero entanglement and cannot drive Jacobson's entanglement equilibrium argument, which requires $\delta S(A) \neq 0$ for perturbations of the vacuum state.

---

## Part B: Antiferromagnetic Case ($J > 0$)

### B.1 Ground State

For $J > 0$, the energy is minimized by placing each bond in the antisymmetric (singlet) state. However, unlike the FM case, it is impossible to simultaneously place all bonds in singlet states on a general lattice (singlet frustration for non-bipartite lattices; even for bipartite lattices, the ground state is a nontrivial superposition).

In 1D, the ground state is exactly solvable via the **Bethe ansatz** (Bethe, 1931). For the spin-1/2 chain with $N$ sites:

- The ground state is the unique singlet state (total spin $S_{\mathrm{tot}} = 0$).
- It is a highly entangled superposition of all spin configurations with zero total magnetization.
- Degeneracy: 1 (unique ground state for even $N$ with periodic boundary conditions).

### B.2 Spectral Gap

The spin-1/2 AFM Heisenberg chain is **exactly gapless** (des Cloizeaux-Pearson, 1962):

$$\Delta_{AFM} = 0 \quad \text{(exact, from Bethe ansatz)}. \tag{09.11}$$

The low-energy excitations are spin-1/2 spinons with a linear dispersion:

$$\epsilon(k) = \frac{\pi J}{2}|\sin k|. \tag{09.12}$$

The low-energy physics is described by the $\mathrm{SU}(2)_1$ Wess-Zumino-Witten (WZW) conformal field theory with **central charge $c = 1$**.

**Note:** The Haldane conjecture (1983, verified numerically and by field-theoretic arguments) states that integer-spin chains are gapped while half-integer-spin chains are gapless. Our model has spin-1/2 (from $n = 2$ in $M_n(\mathbb{C})^{\mathrm{sa}}$), confirming gaplessness.

### B.3 Entanglement in 1D

The Calabrese-Cardy formula (2004, JHEP 0406:002, arXiv:hep-th/0405152) gives the entanglement entropy of a block of $L$ contiguous sites in the ground state of a $(1+1)$-dimensional CFT with central charge $c$:

**Open boundary conditions, chain of total length $N \gg L$:**

$$S(L) = \frac{c}{6}\ln\left(\frac{2N}{\pi}\sin\frac{\pi L}{N}\right) + c_1', \tag{09.13}$$

where $c_1'$ is a non-universal constant.

**Periodic boundary conditions:**

$$S(L) = \frac{c}{3}\ln\left(\frac{N}{\pi}\sin\frac{\pi L}{N}\right) + c_1. \tag{09.14}$$

For $L \ll N$ (subsystem much smaller than the total system), both reduce to:

$$S(L) \approx \frac{c}{3}\ln L + \mathrm{const}. \tag{09.15}$$

For the spin-1/2 AFM Heisenberg chain, $c = 1$ (SU(2)$_1$ WZW CFT), so:

$$\boxed{S(L) = \frac{1}{3}\ln L + \mathrm{const}.} \tag{09.16}$$

% IDENTITY_CLAIM: S(L) = (c/3)*ln(L) + const for a critical 1D chain with central charge c
% IDENTITY_SOURCE: Calabrese-Cardy 2004, JHEP 0406:002 (arXiv:hep-th/0405152)
% IDENTITY_VERIFIED: (1) c=1 for SU(2)_1 WZW is standard (Affleck 1986, Di Francesco et al.); (2) Numerical verification by Laflorencie et al. 2006 confirms coefficient 1/3 for Heisenberg chain; (3) Consistent with conformal anomaly formula c = 3*l*dS/dl|_{l=L} = 3*(1/3) = 1.

This is a **logarithmic correction** to the area law. In 1D, the strict area law would be $S(L) = \mathrm{const}$ (independent of $L$). The $\frac{1}{3}\ln L$ growth is a violation of strict area law, but it is much weaker than volume-law scaling ($S \sim L$).

**Dimensional check:** $[S(L)] = [\text{dimensionless}]$ (entropy in nats). $[\frac{1}{3}\ln L] = [\text{dimensionless}]$. Consistent.

### B.4 Higher Dimensions ($d \geq 2$)

For the AFM Heisenberg model on $\mathbb{Z}^d$ with $d \geq 2$:

- The ground state has long-range antiferromagnetic (Neel) order for $d \geq 2$ in the thermodynamic limit.
- Numerical evidence (Kallin et al. 2011, Kulchytskyy et al. 2015) shows area-law scaling with logarithmic and constant corrections:

$$S(A) = c_1 |\partial(A)| + c_2 \ln|\partial(A)| + O(1). \tag{09.17}$$

- This is consistent with an area law (leading term proportional to boundary area).
- **No rigorous proof exists** for $d \geq 2$. The Hastings theorem is for $d = 1$ only, and extensions to $d \geq 2$ require additional assumptions (e.g., finite correlation length).

### B.5 AFM Conclusion

The AFM ground state has a **logarithmic correction** to the area law in 1D: $S(L) = \frac{1}{3}\ln L + \mathrm{const}$. This is qualitatively much better than volume-law scaling ($S \sim L$), but it is **not a strict area law**. The logarithmic correction is a direct consequence of the gapless excitation spectrum (conformal invariance at the critical point).

---

## Part C: Why the Hastings 2007 Area-Law Theorem Does NOT Apply

**Theorem (Hastings 2007, JSTAT P08024, arXiv:0705.2024).** For a 1D Hamiltonian with a spectral gap $\Delta > 0$ above the ground state, the ground-state entanglement entropy satisfies:

$$S(A) \leq c \cdot \xi \cdot \ln(\xi), \tag{09.18}$$

where $\xi \sim v_{LR}/\Delta$ is the correlation length.

**Hypotheses required by Hastings:**

| Hypothesis | Content | Our system | Status |
|---|---|---|---|
| (H1) | 1D lattice | $\mathbb{Z}^1$ for 1D case | OK |
| (H2) | Local interactions | $h_{xy}$ nearest-neighbor | OK |
| **(H3)** | **Spectral gap $\Delta > 0$** | **FM: $\Delta \sim |J|/N^2 \to 0$; AFM: $\Delta = 0$ exactly** | **FAILS** |

**Since hypothesis (H3) fails for both signs of $J$, the Hastings theorem is inapplicable.** The logarithmic violation $S \sim \frac{1}{3}\ln L$ for the AFM case is precisely the expected behavior for a 1D gapless system described by a $c = 1$ CFT -- it is not a contradiction, but rather confirmation that Hastings (which assumes a gap) cannot be used here.

### C.1 Brandao-Horodecki (2013/2015)

The Brandao-Horodecki improvement of the Hastings area-law theorem requires exponential decay of correlations:

$$|\langle O_A O_B \rangle - \langle O_A\rangle\langle O_B\rangle| \leq C \cdot e^{-d(A,B)/\xi}.$$

This condition also **fails** for both signs of $J$:

- **FM:** The ground state has long-range order (spontaneous symmetry breaking of SU(2)). Correlation functions do not decay.
- **AFM:** Correlations decay algebraically, not exponentially:

$$\langle \vec{S}_0 \cdot \vec{S}_r \rangle \sim \frac{(-1)^r}{r} \cdot (\ln r)^{1/2} \tag{09.19}$$

(Bethe ansatz + conformal field theory, with logarithmic corrections from marginally irrelevant operators).

**Neither exponential decay condition is satisfied.** Brandao-Horodecki is also inapplicable.

---

## Part D: Summary Table

| Property | FM ($J < 0$) | AFM ($J > 0$) |
|---|---|---|
| Ground state | Product $|\uparrow\cdots\uparrow\rangle$ | Bethe ansatz singlet |
| Degeneracy | $N + 1$ | 1 |
| Gap (1D) | $\Delta \sim 2\pi^2|J|/N^2 \to 0$ | $\Delta = 0$ (exact) |
| $S(A)$ in 1D | 0 | $(1/3)\ln L + \text{const}$ |
| Hastings applies? | No (gapless) | No (gapless) |
| Brandao-Horodecki? | No (long-range order) | No (algebraic decay) |
| Area law? | Trivial ($S = 0$) | Log-corrected |
| Useful for Jacobson? | No (no entanglement) | Possibly (has entanglement, but log not area) |

---

## Part E: Implications for Phase 9

Neither sign of $J$ gives a clean ground-state area law from existing theorems:

1. **FM ($J < 0$):** $S(A) = 0$ trivially satisfies area law, but zero entanglement means no Jacobson argument.
2. **AFM ($J > 0$):** $S(A) = \frac{1}{3}\ln L$ has a logarithmic correction to the area law. This is much better than volume-law, but it is not a strict area law in 1D.

**This motivates the three-pronged approach of Phase 9:**

- **Plan 01 (this plan), Task 1:** The WVCH thermal route provides a rigorous MI area law $I(A:B) \leq 2\beta|\partial||J|$ at any finite $T > 0$, for both signs of $J$, in all dimensions. This is the most robust route.
- **Plan 02:** The channel capacity route provides a pure-state information-theoretic bound independent of temperature.
- **Plan 03:** The "which state?" resolution addresses why the physically relevant state for Jacobson may be neither the ground state nor a standard thermal state, but rather a local vacuum state restricted to a causal diamond.

---

## SELF-CRITIQUE CHECKPOINT (Task 2 final):

1. **SIGN CHECK:** Both signs of $J$ analyzed independently. FM gap formula has $|J|$ (correct for FM convention $J < 0$, energy $= J$ for triplet, so gap $\propto |J|/N^2$). AFM gap = 0 (exact). No sign errors.
2. **FACTOR CHECK:** Calabrese-Cardy coefficient $c/3 = 1/3$ for $c = 1$. The factor of $1/6$ vs $1/3$ distinguishes open vs periodic BC (Eqs. 09.13 vs 09.14). Both stated correctly.
3. **CONVENTION CHECK:** Using $H = \sum h_{xy}$ (no 1/2), entropy in nats (not bits, so $\ln$ not $\log_2$), $c = 1$ for SU(2)$_1$ WZW. All consistent with convention lock.
4. **DIMENSION CHECK:** $[S(L)] = [\text{dimensionless}]$. $[\frac{1}{3}\ln L] = [\text{dimensionless}]$. $[\Delta] = [|J|/N^2] = [\text{energy}]$. All consistent.

All checks pass.
