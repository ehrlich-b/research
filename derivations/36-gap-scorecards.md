# Gap Scorecards: Individual Assessment of Paper 6 Gaps A--D

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, fisher_metric=SLD, coupling_convention=J_gt_0_AFM, emergent_speed=c_s=1.659Ja, modular_hamiltonian=K_A=-ln(rho_A), gap_scoring_rubric=CLOSED/NARROWED/CONDITIONAL/OPEN

**Phase:** 36-assembly-and-gap-scoring, Plan 02
**Date:** 2026-03-30

**Purpose:** Score each of the four Paper 6 gaps individually using the CLOSED/NARROWED/CONDITIONAL/OPEN rubric. Each score is justified by specific Phase 32--35 results cited by equation number. This is requirement ASBL-02.

**Scoring rubric:**
- **CLOSED:** Rigorous proof with no remaining assumptions beyond the chain's starting axioms.
- **NARROWED:** Conditional on stated assumptions, but the gap has been reduced from a vague problem to a specific conditional theorem with explicit hypotheses.
- **CONDITIONAL:** Physical argument or structural identification that is plausible but not proved; conditions may be implicit or philosophical.
- **OPEN:** Not addressed by the chain, or the evidence is insufficient to change the gap's status from Paper 6.

**References:**
- Paper 6 -- SWAP lattice, area law, four gaps (defines the scoring targets)
- Jacobson, PRL 116 (2016) 201101, arXiv:1505.04753 -- Entanglement equilibrium
- Lovelock, JMP 12 (1971) 498; JMP 13 (1972) 874 -- Uniqueness of Einstein tensor
- Casini-Huerta-Myers, JHEP 1105:036 (2011), arXiv:1102.0440 -- Conformal modular Hamiltonian
- Sorce 2024 -- Geometric modular flow requires conformal symmetry
- derivations/36-derivation-chain.md (Plan 01 chain assembly)
- Phases 32--35 derivation files (cited by equation number below)

---

## Gap A: Continuum Limit (Principal Open Problem)

### Paper 6 Definition

Paper 6 identifies the continuum limit as the principal open problem: the Wilsonian argument that the lattice Heisenberg antiferromagnet, in the long-wavelength limit, produces a smooth Riemannian manifold suitable for general relativity. Specifically, the claim is that the Fisher information metric on reduced states $\rho_\Lambda(x)$ provides a smooth, positive-definite spatial metric in the thermodynamic limit $N \to \infty$.

### Evidence from Phases 32--35

**1. FISH-01: Smoothness at finite $N$ [RIGOROUS]**

For a finite-range lattice Hamiltonian with unique ground state and spectral gap $\gamma > 0$:

$$
\| \rho_\Lambda(x+1) - \rho_\Lambda(x) \|_1 \leq C_1 \exp\bigl(-R(x)/\xi\bigr) \tag{32.8}
$$

All discrete derivatives are bounded by exponentially decaying functions (Eq. (32.6)), establishing $C^\infty$ smoothness in the discrete sense.

**Source:** derivations/32-fisher-geometry-theorems.md, Eqs. (32.5)--(32.8). Based on Hastings-Koma (CMP 265, 781, 2006).
**Rigor:** RIGOROUS for gapped systems at finite $N$. Does NOT apply to the gapless Neel phase in $d \geq 2$.

**2. FISH-02: Positive-definiteness at interior points [RIGOROUS]**

$g_F(x) > 0$ at all interior lattice points (away from the $Z_2$ reflection-symmetry center), provided $\rho_\Lambda(x)$ has full rank and the chain has OBC.

**Source:** derivations/32-fisher-geometry-theorems.md, Theorem 2 (following Eq. (32.9)).
**Rigor:** RIGOROUS at finite $N$ with OBC.

**3. FISH-03: Distance recovery FAILS in 1D [RIGOROUS NEGATIVE]**

The bulk Fisher metric vanishes in the thermodynamic limit for the 1D Heisenberg chain:

$$
g_{\rm bulk}(N) \sim A \cdot N^{-\alpha}, \quad \alpha \approx 2.75 \pm 0.3 \;(|\Lambda| = 2) \tag{32.12}
$$

Root cause: the 1D ground state has no long-range order ($m_s = 0$ by Mermin-Wagner). Translation invariance is restored in the bulk as $N \to \infty$, and $\partial_x \rho_\Lambda \to 0$.

**Source:** derivations/32-fisher-geometry-theorems.md, Eqs. (32.12), (32.15).
**Rigor:** RIGOROUS NEGATIVE RESULT.

**4. CORR-03: Fisher smoothness for $d \geq 2$ Neel phase [CONDITIONAL on H1--H4]**

The sublattice alternation mechanism gives:

$$
g_F(x) = O(m_s^2) > 0 \quad \text{at interior points} \tag{33.19}
$$

conditional on hypotheses:
- **H1:** Neel long-range order ($m_s > 0$). Rigorous for $S \geq 1, d \geq 3$ (DLS 1978, Eq. (33.2)); rigorous for $S = 1/2, d = 3$ (KLS 1988); QMC only for $S = 1/2, d = 2$ ($m_s = 0.3074$, Sandvik 2025).
- **H2:** Goldstone fluctuations do not destroy sublattice structure. Expected for $d \geq 2$; the Goldstone integral is convergent for $d \geq 3$ and logarithmically divergent ($O(\log L)$) for $d = 2$.
- **H3:** Full-rank reduced density matrix.
- **H4:** OBC (or boundary that breaks translation invariance).

**Source:** derivations/33-fisher-smoothness-algebraic-decay.md, Eqs. (33.18), (33.19).
**Rigor:** CONDITIONAL. Sound given H1--H4, but H1 is not rigorously proved for $S = 1/2, d = 2$.

**5. CORR-02: O(3) NL sigma model [PHYSICAL ARGUMENT]**

$$
S_{\rm eff} = \frac{1}{2g} \int d^d x \, d\tau \left[\frac{(\partial_\tau \mathbf{n})^2}{c_s^2} + (\nabla \mathbf{n})^2\right], \quad \mathbf{n}^2 = 1 \tag{33.11}
$$

with $c_s = 1.659\,Ja$ (QMC match to 0.3%, Eq. (33.14)).

**Source:** derivations/33-correlation-decay-and-sigma-model.md, Eqs. (33.11), (33.14).
**Rigor:** PHYSICAL ARGUMENT. The sigma model is the expected continuum description by universality, but a rigorous lattice-to-continuum derivation does not exist.

**6. Emergent metric assembly [PHYSICAL ARGUMENT]**

$$
ds^2 = -c_s^2 \, dt^2 + g_{ij}(x) \, dx^i dx^j \tag{34.9}
$$

Spatial part from Fisher metric (Phases 32--33); temporal part from sigma model dynamics + Wick rotation (Phase 34).

**Source:** derivations/34-emergent-lorentz-invariance.md, Eqs. (34.9)--(34.11).
**Rigor:** PHYSICAL ARGUMENT. Schematic assembly of spatial and temporal structures; not a rigorous construction of a pseudo-Riemannian manifold.

### What Is Still Missing

1. **Rigorous $N \to \infty$ limit of Fisher geometry for $d \geq 2$.** FISH-01/02 prove effective smoothness at finite $N$; CORR-03 provides a conditional argument for non-vanishing in the Neel phase. Neither constitutes a constructive continuum limit.
2. **Rigorous Neel order for $S = 1/2, d = 2$.** Only QMC evidence ($m_s = 0.3074$, Sandvik 2025). CORR-03 hypothesis H1 is conditional on this.
3. **Proof that the sigma model is the correct continuum description of the SWAP lattice.** This relies on a universality argument, not a rigorous derivation.

### Dimension-Dependent Score

| Dimension | Score | Justification |
|-----------|-------|---------------|
| $d = 1$ | **OPEN** | FISH-03 (Eq. (32.12)) rigorously shows distance recovery fails: $g_{\rm bulk} \sim N^{-2.75} \to 0$. The Fisher geometry collapses. Additionally, the Einstein tensor vanishes identically in $1+1$d, so the continuum limit is moot for gravity. |
| $d = 2$ | **CONDITIONAL** | CORR-03 (Eq. (33.19)) gives $g_F = O(m_s^2) > 0$ conditional on H1--H4. H1 (Neel order) is QMC-established but not rigorously proved for $S = 1/2$. The Goldstone integral has $O(\log L)$ corrections (H2). The gap has been reduced to specific hypotheses, but those hypotheses are not fully established. |
| $d \geq 3$ | **NARROWED** | CORR-03 conditional on H1--H4, but with strong physical evidence: Goldstone integral convergent (no $\log L$ divergence), Neel order rigorous for $S \geq 1$ (DLS 1978) and $S = 1/2, d = 3$ (KLS 1988), QMC match to 0.3% (Eq. (33.14)). The gap has been narrowed from a vague problem to a conditional theorem (CORR-03) with four explicit hypotheses, all well-supported for $d \geq 3$. Still conditional on sigma model universality and the constructive $N \to \infty$ limit. |

### Overall Gap A Score

$$
\boxed{\text{Gap A: NARROWED ($d \geq 3$) / CONDITIONAL ($d = 2$) / OPEN ($d = 1$)}}
$$

---

## Gap B: Conformal Approximation (Route A Only)

### Paper 6 Definition

Paper 6 identifies the conformal approximation as a gap in the Jacobson 2016 entanglement equilibrium argument (Route A). The Casini-Huerta-Myers (CHM) conformal modular Hamiltonian:

$$
K_B = 2\pi \int_B \frac{\ell^2 - |\mathbf{x}|^2}{2\ell} \, T_{00}(\mathbf{x}) \, d^d x
$$

is exact only for conformal field theories in causal diamonds (Casini-Huerta-Myers, JHEP 1105:036 (2011)). For non-conformal theories, corrections are $O((m\ell)^{2\Delta})$ (Speranza 2016).

### Evidence from Phases 32--35

**1. In $d = 1$: CFT -- Gap B vanishes [RIGOROUS]**

The $S = 1/2$ Heisenberg chain in $d = 1$ flows to the SU(2)$_1$ WZW conformal field theory at low energies. This is an exact CFT (central charge $c = 1$), so the CHM modular Hamiltonian is exact. Gap B is CLOSED for $d = 1$ Route A.

**Source:** Phase 33 Plan 01. The $d = 1$ chain is gapless with conformal invariance (WZW). Belavin-Polyakov-Zamolodchikov (1984) conformal bootstrap.

**However:** This is moot for gravity: the Einstein tensor vanishes identically in $1+1$d, so the Jacobson argument produces only a cosmological equation ($\Lambda g_{ab} = 8\pi G_N T_{ab}$), not full Einstein equations.

**2. In $d \geq 2$: No conformal symmetry -- Gap B OPEN for Route A [RIGOROUS OBSTRUCTION]**

The Heisenberg AFM with Neel order in $d \geq 2$ has its low-energy physics described by the O(3) NL sigma model (Phase 33, Eq. (33.11)). This is NOT a CFT:
- Neel order breaks $O(3)$ to $O(2)$, producing massive Goldstone modes with a mass gap $m_s > 0$.
- Phase 34 established emergent Lorentz invariance (Eq. (34.16)), but NOT conformal invariance.
- Conformal invariance requires the stress-energy trace $T^\mu_\mu = 0$; the sigma model with broken symmetry has $T^\mu_\mu \neq 0$.

**Source:** Phase 33 (NL sigma model, not CFT); Phase 34 (Lorentz, not conformal).

**3. Route B circumvents Gap B entirely [STRUCTURAL]**

Route B (Lovelock uniqueness) does not require the CHM conformal modular Hamiltonian. It replaces the conformal assumption with the tensoriality assumption (Gap C) and uses Lovelock's uniqueness theorem (JMP 12, 498 (1971)) to identify the Einstein tensor as the unique divergence-free symmetric 2-tensor with at most second derivatives of the metric.

**Source:** derivations/36-derivation-chain.md, Link (f) Route B.

### What Is Still Missing

1. **Quantification of conformal corrections for the NL sigma model in $d \geq 2$.** How large are the $O((m\ell)^{2\Delta})$ corrections? Is there a "conformal window" ($a \ll \ell \ll 1/m$) where the corrections are small?
2. **Whether any alternative to the CHM form can be used for Route A in $d \geq 2$.** Current evidence suggests not: Sorce 2024 shows geometric modular flow requires conformal symmetry.

### Dimension-Dependent Score

| Dimension | Route | Score | Justification |
|-----------|-------|-------|---------------|
| $d = 1$ | Route A | **CLOSED** | Exact CFT (SU(2)$_1$ WZW). CHM modular Hamiltonian is exact. But moot: Einstein tensor vanishes in $1+1$d. |
| $d \geq 2$ | Route A | **OPEN** | No conformal symmetry in the NL sigma model. Neel order $\Rightarrow$ mass gap $\Rightarrow$ $T^\mu_\mu \neq 0$. Sorce 2024 further constrains geometric modular flow to conformal settings. |
| Any $d$ | Route B | **N/A** | Route B circumvents Gap B entirely via Lovelock uniqueness. Gap B is replaced by Gap C (tensoriality). |

### Route A / Route B Complementarity

The two routes are complementary, not competing:

- **Route A** works where Gap B is closed ($d = 1$, exact CFT) but the Einstein equations are trivial ($G_{ab} = 0$ in $1+1$d).
- **Route B** circumvents Gap B but introduces Gap C (tensoriality). Route B is most useful in $d \geq 2$, where conformal symmetry is absent but the physics of gravity is nontrivial.

Together, they cover all spatial dimensions, each with its own caveats. Neither route alone is sufficient across all dimensions.

### Overall Gap B Score

$$
\boxed{\text{Gap B: CLOSED ($d = 1$ Route A) / OPEN ($d \geq 2$ Route A) / N/A (Route B)}}
$$

---

## Gap C: Tensoriality (Route B Only)

### Paper 6 Definition

Paper 6 identifies tensoriality as the additional assumption required by Route B (Lovelock uniqueness): the entanglement-geometry equation derived from $\delta S = 0$ must be a symmetric 2-tensor equation involving at most second derivatives of the metric. Lovelock's uniqueness theorem (JMP 12, 498 (1971); JMP 13, 874 (1972)) then guarantees the result is the Einstein tensor (plus cosmological constant).

### Evidence from Phases 32--35

**1. The emergent metric IS a symmetric 2-tensor [RIGOROUS]**

Phase 34 established the emergent spacetime metric:

$$
ds^2 = -c_s^2 \, dt^2 + g_{ij}(x) \, dx^i dx^j \tag{34.9}
$$

The spatial part $g_{ij}$ is the Fisher information metric (symmetric, positive-definite Riemannian 2-tensor on the lattice positions). The full spacetime metric $g_{\mu\nu}$ is a symmetric 2-tensor on the $(d+1)$-dimensional emergent manifold.

**Source:** derivations/34-emergent-lorentz-invariance.md, Eq. (34.9).

**2. First-order perturbation argument [PHYSICAL ARGUMENT]**

Paper 6 argues: the entanglement first law is first-order perturbation theory ($\delta S = \delta \langle K_B \rangle$, Jacobson input J7, exact identity). The modular Hamiltonian $K_B$ is local at leading order (from BW, Phase 35 Eq. (35.0a)). Therefore, the geometric equation coupling $\delta A$ to $\delta S_{\rm mat}$ has at most two derivatives of the metric (the linearized Raychaudhuri equation for $\delta A$ involves $R_{\mu\nu}$, which is second-order in $g$).

This is a physically motivated argument: the first-order nature of the entanglement first law limits the derivative order, and the locality of $K_B$ (from BW) limits the nonlocal terms.

**Source:** Paper 6 gap discussion; Jacobson 2016 argument structure.

**3. Dimension caveat: $d+1 > 4$ [STRUCTURAL LIMITATION]**

In $d+1 > 4$ spacetime dimensions, the Lovelock theorem allows additional terms beyond $G_{ab} + \Lambda g_{ab}$: the Gauss-Bonnet tensor and higher-order Lovelock invariants. To obtain exactly Einstein's equation, one must independently assume that the second-derivative restriction holds, or that the coefficients of higher Lovelock terms vanish.

In $d+1 = 4$ (i.e., $d = 3$), Lovelock uniqueness gives exactly $G_{ab} + \Lambda g_{ab}$ with no additional terms. For $d = 2$, the Einstein tensor in $2+1$d has no local degrees of freedom (pure topological gravity), which is a separate issue.

**Source:** Lovelock, JMP 12 (1971) 498; JMP 13 (1972) 874.

### What Is Still Missing

1. **Proof that the entanglement-geometry relation contains no higher-derivative or non-local terms.** The first-order argument is plausible but not a theorem.
2. **For $d+1 > 4$: independent argument excluding higher Lovelock terms** (or evidence that their coefficients vanish for the SWAP lattice).

### Score

| Dimension | Score | Justification |
|-----------|-------|---------------|
| $d = 1$ | **N/A** | In $1+1$d, the Einstein tensor vanishes identically. Tensoriality is trivially satisfied but irrelevant. Route B is not needed since Route A works (CFT). |
| $d = 2$ | **CONDITIONAL** | Einstein gravity in $2+1$d is topological (no local gravitons). Tensoriality is physically motivated by the first-order argument but unproved. |
| $d \geq 3$ | **CONDITIONAL** | Tensoriality is assumed based on the physical argument (first-order perturbation + BW locality). For $d = 3$ specifically ($d+1 = 4$), Lovelock uniqueness requires only the symmetric 2-tensor assumption with $\leq 2$ derivatives. For $d > 3$, must additionally exclude higher Lovelock terms. |

**Note:** Gap C applies ONLY to Route B. Route A (Jacobson conformal) does not need tensoriality but needs conformal $K_B$ (Gap B).

### Overall Gap C Score

$$
\boxed{\text{Gap C: CONDITIONAL (physically motivated assumption, not proved)}}
$$

---

## Gap D: MVEH (Maximum Vacuum Entanglement Hypothesis)

### Paper 6 Definition

Paper 6 presents the Maximum Vacuum Entanglement Hypothesis (MVEH): the vacuum state maximizes the entanglement entropy at fixed stress-energy content. This is reframed as a structural identification via Connes-Rovelli thermal time (Connes-Rovelli, CMP 179 (1994) 141) and Van Raamsdonk's entanglement-geometry correspondence (Van Raamsdonk, IJMP D19 (2010) 2429).

In the Jacobson 2016 framework, MVEH is the starting point: $\delta S = 0$ for first-order perturbations away from the vacuum state (entanglement equilibrium).

### Evidence from Phases 32--35

**1. BW + KMS: vacuum = thermal state with respect to boosts [CONDITIONAL]**

Phase 35 established:
- $K_A = 2\pi K_{\rm boost}$ (BW, Eq. (35.0a)): the modular Hamiltonian is a boost generator.
- KMS at $\beta_{\rm mod} = 1$ derived from Tomita-Takesaki (Eq. (35.8)): the vacuum is a KMS (thermal) state with respect to modular flow.
- Physical KMS temperature $T_U = a/(2\pi)$ (Unruh, Eq. (35.3)).

This means the vacuum state, restricted to a Rindler wedge, IS a thermal equilibrium state. Thermal equilibrium states maximize entropy at fixed energy -- this is the thermodynamic content of MVEH.

**Source:** derivations/35-kms-equilibrium-and-modular-hamiltonian.md, Eqs. (35.0a), (35.3), (35.8), (35.9).
**Rigor:** CONDITIONAL on lattice-BW (SRF = 0.9993, not a theorem).

**2. Paper 6 numerical evidence [SUPPORTING]**

Paper 6 provides numerical evidence that all Hamiltonian perturbations decrease $S(A)$ (the entanglement entropy of the reduced state). This supports MVEH directly but is not a proof -- it is evidence for a specific lattice model at finite $N$.

**Source:** Paper 6.

**3. Structural identification via Connes-Rovelli + Van Raamsdonk [PHYSICAL ARGUMENT]**

The Connes-Rovelli thermal time hypothesis identifies the physical time flow with the modular flow of the equilibrium state. In the pre-geometric framework (before spacetime is assumed), the vacuum is the state that defines the geometry via its entanglement structure. Van Raamsdonk's argument that "entanglement builds geometry" provides the physical picture: the vacuum state IS the geometry-defining state, so asking it to maximize entanglement is asking it to be the most "geometrical" state.

This is a structural identification, not a mathematical proof. It is compelling within the framework but depends on accepting the Connes-Rovelli and Van Raamsdonk interpretations.

**Source:** Paper 6; Connes-Rovelli, CMP 179 (1994) 141; Van Raamsdonk, IJMP D19 (2010) 2429.
**Rigor:** PHYSICAL ARGUMENT (structural identification).

**4. Sorce 2024 caveat [CONSTRAINT]**

Sorce (2024) shows that geometric modular flow (where the modular flow acts geometrically on the spacetime) requires conformal symmetry. This constrains the MVEH interpretation:
- In $d = 1$: the theory is conformal (SU(2)$_1$ WZW), so the Sorce constraint is satisfied.
- In $d \geq 2$: the NL sigma model is not conformal. The modular flow is still well-defined (via Tomita-Takesaki), but it does NOT act as a geometric transformation on the emergent spacetime. This means the physical interpretation of MVEH as "the vacuum is the geometry-defining state" is more subtle in $d \geq 2$.

**Source:** Sorce 2024.

### What Is Still Missing

1. **Proof of existence and uniqueness of a geometry-defining state.** The structural identification asserts it; a proof would show that exactly one state in the Hilbert space produces a consistent emergent geometry.
2. **Proof that Van Raamsdonk's argument applies to the SWAP lattice.** The entanglement-geometry correspondence is established in AdS/CFT but not rigorously in the lattice setting.
3. **Resolution of the Sorce caveat for $d \geq 2$.** The modular flow does not act geometrically in non-conformal theories. What replaces the geometric interpretation in the sigma model setting?

### Score

MVEH is the most philosophically loaded assumption in the chain. It cannot be stated as "derived" -- it is a structural identification that may eventually follow from the self-modeling axiom (Paper 5) but is not derived in the current work.

| Dimension | Score | Justification |
|-----------|-------|---------------|
| $d = 1$ | **CONDITIONAL** | BW + KMS derived (not assumed). Conformal symmetry satisfies Sorce constraint. But "structural identification" rather than proof. |
| $d = 2$ | **CONDITIONAL** | BW + KMS via lattice-BW (SRF = 0.9993). Sorce caveat: modular flow is not geometric for non-conformal sigma model. Structural identification accepted but not proved. |
| $d \geq 3$ | **CONDITIONAL** | Same as $d = 2$. BW + KMS conditional on lattice-BW. Sorce caveat unresolved. Structural identification, not proof. |

### Overall Gap D Score

$$
\boxed{\text{Gap D: CONDITIONAL (structural identification accepted; not a mathematical proof; Sorce caveat addressed only in $d = 1$)}}
$$

---

## Gap Summary Table

| Gap | Paper 6 Name | Score ($d = 1$) | Score ($d = 2$) | Score ($d \geq 3$) | Key Evidence | Key Missing |
|-----|-------------|-----------------|-----------------|--------------------|--------------|--------------------|
| **A** | Continuum Limit | OPEN | CONDITIONAL | NARROWED | FISH-01/02 (Eqs. 32.8, 32.9), CORR-03 (Eq. 33.19), sigma model (Eq. 33.11) | Constructive $N \to \infty$ limit; rigorous Neel ($S = 1/2, d = 2$); sigma model proof |
| **B** | Conformal Approx | CLOSED (Route A) | OPEN (Route A) / N/A (Route B) | OPEN (Route A) / N/A (Route B) | WZW CFT ($d = 1$); Lovelock (Route B) | Conformal corrections for NL sigma model; Sorce caveat |
| **C** | Tensoriality | N/A (trivial) | CONDITIONAL | CONDITIONAL | Metric is 2-tensor (Eq. 34.9); first-order argument | Higher-derivative terms; Gauss-Bonnet in $d+1 > 4$ |
| **D** | MVEH | CONDITIONAL | CONDITIONAL | CONDITIONAL | BW+KMS (Eqs. 35.0a, 35.3, 35.8); Connes-Rovelli structural | Proof of geometry-defining state; Sorce caveat ($d \geq 2$) |

**Heterogeneity verification:** The four gaps have genuinely different status: Gap A ranges from OPEN to NARROWED depending on dimension; Gap B is CLOSED in one setting and OPEN in another; Gaps C and D are uniformly CONDITIONAL. No two rows have identical scores across all dimension columns.

---

## Route A vs Route B Comparison

| Aspect | Route A (Jacobson Conformal) | Route B (Lovelock Uniqueness) |
|--------|----------------------------|-------------------------------|
| Additional assumption | Conformal $K_B$ (Gap B) | Tensoriality (Gap C) |
| Where it works best | $d = 1$ (exact CFT, SU(2)$_1$ WZW) | $d \geq 2$ (no conformal symmetry needed) |
| Where it fails | $d \geq 2$ (NL sigma model not conformal) | $d+1 > 4$ (Gauss-Bonnet terms allowed by Lovelock) |
| Target equation | $G_{ab} + \Lambda g_{ab} = 8\pi G_N T_{ab}$ | Same |
| Needs MVEH? | Yes (Gap D) | Yes (Gap D) |
| Needs area law? | Yes (J5) | Yes (J5) |
| Needs BW? | Yes (J1) | Yes (J1) |
| Strength | Most rigorous where it applies | Broadest applicability |
| Weakness | Narrow applicability (CFT only) | Tensoriality unproved |
| Complementarity | Covers $d = 1$ exactly | Covers $d \geq 2$ conditionally |

**The two routes are complementary, not competing.** Together they cover all spatial dimensions $d = 1, 2, 3$, each with its own caveats. Route A provides the rigorous anchor in $d = 1$ (where the physics of gravity is trivial but the mathematical argument is exact). Route B provides the physically relevant argument in $d \geq 2$ (where Einstein's equations have local degrees of freedom but the mathematical assumptions are not fully proved).

---

## Honest Assessment: What the Chain Achieves

### 1. What IS Established

For $d \geq 3$, a conditional derivation chain from finite-dimensional observer (Paper 5) to Einstein equations (Jacobson 2016) exists with every link at least PHYSICAL ARGUMENT or CONDITIONAL. No link is OPEN. The six-link chain (derivations/36-derivation-chain.md):

$$
\text{(a) Observer} \to \text{(b) SWAP lattice} \to \text{(c) Fisher manifold} \to \text{(d) Lorentz} \to \text{(e) BW + equilibrium} \to \text{(f) Jacobson} \to \text{Einstein}
$$

is assembled with equation-level citations from Phases 32--35.

The four Paper 6 gaps have been individually scored:
- **Gap A** (Continuum Limit): NARROWED for $d \geq 3$ -- reduced from a vague problem to a specific conditional theorem (CORR-03, Eq. (33.19)) with four explicit hypotheses (H1--H4), all well-supported.
- **Gap B** (Conformal Approximation): CLOSED for $d = 1$ Route A (exact CFT), OPEN for $d \geq 2$ Route A, N/A for Route B.
- **Gap C** (Tensoriality): CONDITIONAL -- physically motivated assumption, not proved.
- **Gap D** (MVEH): CONDITIONAL -- structural identification via Connes-Rovelli and Van Raamsdonk, not a mathematical proof.

This represents genuine progress: no prior work has assembled a comparable derivation chain from a finite-dimensional starting point through explicit lattice calculations to Einstein's equations.

### 2. What Is NOT Established

A constructive continuum limit. A rigorous proof. The chain is conditional on:
- Sigma model universality argument (the O(3) NL sigma model as the continuum description of the SWAP lattice -- PHYSICAL ARGUMENT, not proved)
- CORR-03 hypotheses H1--H4 (effective smoothness of the Fisher metric in the Neel phase)
- Lattice-BW validity (SRF = 0.9993, numerical, not theorem)
- MVEH structural identification (accepted, not proved)
- Tensoriality assumption (Route B, Gap C)

These are standard physics assumptions, not exotic inputs: universality of effective field theories, existence of long-range order in antiferromagnets, locality of the entanglement Hamiltonian, thermodynamic interpretation of entanglement equilibrium. But they are assumptions nonetheless. None has been rigorously proved in the lattice setting.

### 3. The Dimension Paradox

The chain is most rigorous in $d = 1$: the theory is an exact CFT (SU(2)$_1$ WZW), the BW theorem applies rigorously, Gap B is CLOSED, and no conditional hypotheses are needed for the field theory. But the physics is trivial there: the Einstein tensor vanishes identically in $1+1$ dimensions, so only a cosmological equation survives.

The chain is most interesting in $d \geq 3$: Einstein's equations have local degrees of freedom (gravitons), Neel order is rigorously established (for $S \geq 1$ by DLS 1978, for $S = 1/2$ by KLS 1988), the Goldstone integral converges, and the sigma model description is well-supported by QMC (0.3% match, Eq. (33.14)). But every link from (c) onward relies on conditional or physical arguments.

This is not a flaw but a feature: the hard physics IS the conditional steps, and identifying them precisely is the achievement. The conditional steps (H1--H4 for CORR-03, sigma model universality, lattice-BW, MVEH) are now explicit targets for future work.

### 4. Comparison with Prior Work

| This Chain | Prior Work | Difference |
|------------|-----------|------------|
| Starts from finite-dim observer (Paper 5) | Jacobson (1995, 2016) assumes smooth manifold | This chain tries to derive the smooth manifold from a lattice |
| Uses Fisher metric on lattice reduced states | Lashkari-McDermott-Van Raamsdonk (2014) assumes AdS/CFT | This chain does not assume AdS/CFT |
| Derives emergent Lorentz from sigma model | Faulkner-Lewkowycz-Maldacena (2013) assumes holography | This chain does not assume holography |
| Constructs factored Hilbert space from SWAP lattice | Cao-Carroll-Michalakis (2017) assumes factored Hilbert space | This chain derives the factorization from the lattice |
| BW via lattice-BW (Giudici et al. 2018) | Continuum BW (Bisognano-Wichmann 1975) requires Wightman axioms W1--W6 | Lattice-BW bypasses the open constructive QFT problem (W6) |

The present work is unique in starting from a finite-dimensional observer and proceeding through explicit lattice calculations. The price is conditionality at every link beyond the lattice construction.

### 5. What Comes Next

To upgrade NARROWED to CLOSED for Gap A ($d \geq 3$), the key targets are well-defined mathematical problems:

1. **Rigorous continuum limit of Fisher geometry for $d \geq 2$:** Prove that $g_F(x) = O(m_s^2) > 0$ in the thermodynamic limit $N \to \infty$ (currently CORR-03, conditional on H1--H4).
2. **Proof of sigma model as continuum description of SWAP lattice:** Rigorous lattice-to-continuum derivation (currently a universality argument).
3. **Rigorous Neel order for $S = 1/2, d = 2$:** Currently QMC-established ($m_s = 0.3074$, Sandvik 2025) but not proved. This is a long-standing open problem in mathematical physics.

For Gap C: prove that the entanglement-geometry relation has no higher-derivative terms (would upgrade CONDITIONAL to NARROWED or CLOSED).

For Gap D: derive MVEH from the self-modeling axiom (Paper 5), or prove existence/uniqueness of the geometry-defining state (would upgrade CONDITIONAL to NARROWED).

### Overall v9.0 Milestone Verdict

**The derivation chain is ASSEMBLED and CONDITIONALLY COMPLETE for $d \geq 3$.** The four Paper 6 gaps have been scored individually with honest calibration. The continuum limit remains the principal open problem (as Paper 6 stated), but it has been NARROWED from a vague gap to a specific conditional theorem (CORR-03) with four explicit hypotheses (H1--H4). The other gaps are CONDITIONAL (Gaps C, D) or route-dependent (Gap B: CLOSED for Route A $d = 1$, OPEN for Route A $d \geq 2$, N/A for Route B).

No gap is scored CLOSED for $d \geq 3$. The honest summary is: conditional progress toward a derivation of Einstein's equations from a finite-dimensional observer, not a claimed proof.

---

_Phase: 36-assembly-and-gap-scoring, Plan 02_
_Completed: 2026-03-30_
