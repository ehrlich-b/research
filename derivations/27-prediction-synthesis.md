# Prediction Synthesis: v7.0 Arrow of Time Program

% ASSERT_CONVENTION: natural_units=natural, entropy_base=nats, state_normalization=Tr(rho)=1, sequential_product=a&b=sqrt(a)b*sqrt(a), von_neumann_entropy=S(rho)=-Tr(rho*ln*rho), coupling_convention=H=sum_h_xy, information=I(B;M)=S(B)+S(M)-S(BM), free_energy=F=E-TS

**Phase 27, Plan 02**
**Date:** 2026-03-24

**References:**
- Paper 5 (v2.0): Self-modeling axioms, experiential density rho [ref-paper5]
- Paper 7: h_3(O)/Cl(6) route to chirality, Gap C statement [ref-paper7]
- Phase 23, Plan 01: CPTP channel E(rho_B) [derivations/23-luders-channel-entropy.md]
- Phase 23, Plan 02: Entropy monotonicity, E^N(rho) -> I/2 [derivations/23-entropy-theorem.md]
- Phase 24, Plan 01: Chirality-time theorem (CHIR-01) [derivations/24-chirality-time-theorem.md]
- Phase 24, Plan 02: Three-consequence theorem (CHIR-02) [derivations/24-three-consequence-theorem.md]
- Phase 25, Plan 01: Landauer bound W >= kT * I(B;M) [derivations/25-landauer-self-modeling.md]
- Phase 25, Plan 02: Coherence loophole closed [derivations/25-coherence-loophole.md]
- Phase 25, Plan 03: Chain theorem [derivations/25-chain-theorem.md]
- Phase 26, Plan 01: Entropy gradient theorem (3 routes) [derivations/26-entropy-gradient-theorem.md]
- Phase 26, Plan 02: Gap C resolution, v7.0 master theorem, A1-A7 [derivations/26-gap-c-resolution.md]
- Phase 27, Plan 01: Quantitative predictions [derivations/27-quantitative-predictions.md]
- Sakharov (1967): "Violation of CP invariance, C asymmetry, and baryon asymmetry of the universe," JETP Lett. 5, 24 [ref-sakharov1967]
- Penrose (1979): "Singularities and time-asymmetry," in GR: An Einstein Centenary Survey [ref-penrose1979]
- Carroll (2010): "From Eternity to Here" -- Past Hypothesis context [ref-carroll2010]

---

## 0. v7.0 Achievement Summary

The v7.0 Arrow of Time program (Phases 23-27) establishes a chain from self-modeling axioms to the necessity of an entropy gradient, resolves Gap C via a selection argument, and extracts quantitative (order-of-magnitude) predictions. The phases are:

### Phase 23: Entropy Increase Under Sequential Products

Established the CPTP channel $E(\rho_B) = \cos^2(Jt)\,\rho_B + \sin^2(Jt)\,I/2$ for SWAP interactions on a lattice. Proved entropy monotonicity: $S(E^N(\rho_B))$ is non-decreasing, converging geometrically to $S_{\max} = \ln d_B$. The channel is unital; monotonicity follows from Lindblad's quantum H-theorem.

**Key result:** The SWAP lattice dynamics provides a concrete entropy-increasing mechanism within the Paper 5 / Paper 6 framework.

### Phase 24: Chirality Requires Time-Orientation

Proved the Chirality-Time Theorem (CHIR-01): on any even-dimensional Lorentzian manifold, the chirality operator $\Gamma_*$ flips sign under time reversal ($\Gamma_* \to -\Gamma_*$), so $P_L \leftrightarrow P_R$. Globally consistent Weyl spinors require time-orientation.

Proved the Three-Consequence Theorem (CHIR-02): the single algebraic choice $u \in S^6$ determines (a) the SM gauge group, (b) chirality via the Cl(6) volume form $\omega_6$, and (c) a requirement for time-orientation on the emergent spacetime.

**Key result:** Chirality and time-orientation are geometrically linked; both are downstream of the algebraic choice $u$.

### Phase 25: Self-Modeling Requires Free Energy

Proved the Landauer bound on self-modeling: $W_{\text{cycle}} \geq T \cdot I(B;M)$ per update cycle. Closed the coherence loophole via three independent arguments (Luders map destroys coherence; coherence maintenance costs free energy; Sagawa-Ueda consistency). Proved the chain theorem: self-modeling $\to$ free energy $\to$ non-equilibrium $\to$ entropy gradient.

**Key result:** Self-modeling is thermodynamically non-trivial; it requires a sustained energy cost paid from the entropy gradient.

### Phase 26: Entropy Gradient Theorem and Gap C Resolution

Proved the entropy gradient theorem via three independent routes:
- Route A (Direct Chain): Landauer $\to$ Second Law $\to$ equilibration
- Route B (Boundary): finitude + monotonicity + not-at-maximum
- Route C ($\rho$ Selection): $\rho > 0 \implies$ non-equilibrium $\implies S < S_{\max}$

Resolved Gap C as a selection effect: blocks of structure space with non-complexified $V_{1/2}$ have $\rho = 0$ (zero experiential density), because non-complexification $\to$ no chirality $\to$ no time-orientation for chiral matter $\to$ no entropy gradient $\to$ no self-modeling.

Stated the v7.0 Master Theorem and complete assumption register A1-A7.

**Key result:** The Past Hypothesis is necessary for self-modeling; complexification is selected for (not algebraically forced) by the experiential measure.

### Phase 27: Quantitative Predictions (This Phase)

Plan 01 extracted quantitative predictions: Landauer entropy deficit $\sim 10^{28}$ nats (94 orders of magnitude weaker than Penrose's $\sim 10^{122}$), $\rho$ profile peaks at $I = S_B/2$ with $\rho_{\max} = S_B/4$, exhaustion timescale $\tau_{\text{exhaust}} \sim 10^{111}$ s $\gg t_U$.

Plan 02 (this document) synthesizes the full prediction table, analyzes the CP violation connection, and provides the definitive v7.0 summary.

### v7.0 Master Theorem (Phase 26-02)

**Master Theorem (Arrow of Time and Complexification Selection).** Under assumptions A1-A7:

**(I) Entropy gradient theorem.** Self-modelers on a finite SWAP lattice require an entropy gradient: $S(t) < S_{\max}$. Proved via three independent routes.

**(II) Complexification selection.** Among blocks of structure space supporting C*-observers probing $\mathfrak{h}_3(\mathbb{O})$, the experiential measure $\mu_\rho$ concentrates on those with complexified $V_{1/2}$. Non-complexified blocks have $\rho = 0$.

**(III) Gap C resolution.** The complexification of $V_{1/2}$ to $S_{10}^+$ is a selection effect, not an algebraic necessity.

### Complete Assumption Register (A1-A7)

| ID | Assumption | Source | Epistemic Status |
|---|---|---|---|
| A1 | Finite-dimensional QM: $\dim(\mathcal{H}_B), \dim(\mathcal{H}_M) < \infty$ | Paper 5 axioms | AXIOM |
| A2 | Thermal contact: BM weakly coupled to bath at temperature $T$ | Landauer regime | STANDARD PHYSICS |
| A3 | Closed/semi-closed system equilibration | Statistical mechanics | PHYSICAL ARGUMENT |
| A4 | SWAP lattice dynamics: $H = JF$ | Paper 6 | MODEL CHOICE |
| A5 | Experiential density $\rho = I(1 - I/S_B)$ | Paper 5 | AXIOM |
| A6 | Continuum limit from lattice to smooth Lorentzian manifold | Paper 6, Gap 1 | ASSUMPTION |
| A7 | Lorentzian signature of emergent spacetime | Paper 6 causal structure | PHYSICAL ARGUMENT |

**Assumption hierarchy** (strongest = most likely to fail, to weakest):
A3 $>$ A6 $>$ A7 $>$ A4 $>$ A2 $>$ A1, A5.

---

## 1. CP Violation and the Entropy Gradient

### 1.1 Sakharov Conditions

Sakharov (1967) [ref-sakharov1967] identified three necessary conditions for generating the observed baryon asymmetry of the universe:

**(a) Baryon number violation.** Processes that change baryon number $B$ must exist.

**(b) C and CP violation.** The rates of processes and their C- or CP-conjugates must differ.

**(c) Departure from thermal equilibrium.** The system must be out of thermal equilibrium at the time the baryon-number-violating and CP-violating processes occur.

Condition (c) connects directly to the entropy gradient theorem (Phase 26): the entropy gradient IS the departure from thermal equilibrium. More precisely: the entropy gradient theorem shows that self-modelers require $S < S_{\max}$ (non-equilibrium), and non-equilibrium is precisely what Sakharov's condition (c) requires for baryogenesis.

**What this means:** The entropy gradient theorem and Sakharov's condition (c) address the same physical requirement -- non-equilibrium -- from different perspectives. The entropy gradient theorem derives non-equilibrium from self-modeling. Sakharov derives the need for non-equilibrium from baryogenesis. Both point to the same cosmological fact: the universe was not in thermal equilibrium during the relevant epoch.

**What this does NOT mean:** This parallel does not imply that the entropy gradient theorem explains baryogenesis. Sakharov's conditions (a) and (b) -- baryon number violation and CP violation -- are independent requirements that the entropy gradient theorem does not address.

### 1.2 The Chirality-Time Link and CP Violation

The chirality-time link (Phase 24) establishes:

$$\text{Chiral spinors (Weyl decomposition } S = S_L \oplus S_R) \implies \text{time-orientation required}$$

CP violation is the violation of the combined charge-conjugation ($C$) and parity ($P$) symmetry. Under the CPT theorem (assuming Lorentz invariance and local QFT), CP violation implies T violation:

$$\text{CPT invariance} + \text{CP violation} \implies \text{T violation}$$

**T violation** and **time-orientation** are related but DISTINCT concepts:

- **Time-orientation** is a global geometric structure on the manifold: a continuous choice of "future" direction at every spacetime point. It is a property of the manifold's causal structure. A time-oriented manifold has a preferred temporal direction, but this does not mean the dynamics distinguish $t$ from $-t$.

- **T violation** is a dynamical property: the laws of physics (or specific processes) are not invariant under $t \to -t$. T violation occurs within a time-oriented spacetime; it is an asymmetry of the dynamics, not of the geometry.

The distinction matters: a time-oriented spacetime can have T-invariant dynamics (e.g., electrodynamics in Minkowski space). Conversely, T violation requires a time-oriented spacetime (you need a "before" and "after" to even define T violation), but does not create time-orientation.

### 1.3 The Structural Triangle

The framework establishes a structural connection between three concepts:

$$\text{Chirality} \xleftrightarrow{\text{Phase 24, CHIR-01}} \text{Time-orientation} \xleftarrow{\text{Phase 26, entropy gradient}} \text{Self-modeling}$$

$$\text{CP violation} \xrightarrow{\text{CPT theorem}} \text{T violation} \xrightarrow{\text{requires}} \text{Time-orientation}$$

The triangle:

1. **Chirality $\leftrightarrow$ time-orientation** (Phase 24, CHIR-01): Chiral spinors require time-orientation for a globally consistent Weyl decomposition. Time-orientation is a prerequisite for physical chirality.

2. **Time-orientation $\leftarrow$ self-modeling** (Phase 26, entropy gradient theorem): Self-modelers require an entropy gradient, which defines a preferred temporal direction (future = increasing $S$). On a Lorentzian manifold, this preferred direction is a time-orientation.

3. **CP violation $\to$ T violation $\to$ time-orientation** (CPT theorem): CP violation implies T violation (given CPT). T violation requires a time-oriented spacetime (you need a temporal direction to define T).

All three arrows point toward time-orientation as a common prerequisite. This suggests that chirality, the arrow of time, and CP violation are structurally connected through their shared dependence on time-orientation.

**The connection is STRUCTURAL, not quantitative.** The framework does not provide a formula relating the entropy gradient rate to the CP violation magnitude. The connection is that all three phenomena require the same geometric structure (time-orientation), and the framework shows why time-orientation is necessary (self-modeling requires it via the entropy gradient).

### 1.4 Non-Claims (CP Violation)

The following are explicitly NOT claimed:

**NC-CP-1: The framework does NOT derive the magnitude of CP violation.** The Jarlskog invariant $J = \text{Im}(V_{us}V_{cb}V_{ub}^*V_{cs}^*) \approx 3 \times 10^{-5}$, the CKM phase $\delta_{CP} \approx 1.2$ rad, and the strong CP parameter $\bar{\theta}$ are Standard Model parameters determined by the Yukawa couplings and QCD vacuum structure. The self-modeling axioms do not constrain Yukawa couplings. They concern the structure space of self-modeling composites, not the specific parameters of the Standard Model Lagrangian.

**NC-CP-2: The framework does NOT derive baryon asymmetry from the entropy gradient.** The observed baryon-to-photon ratio $\eta_B \approx 6 \times 10^{-10}$ requires all three Sakharov conditions. The entropy gradient theorem addresses only condition (c) -- departure from thermal equilibrium. Conditions (a) (baryon number violation) and (b) (CP violation) are independent requirements that the framework does not address. Even if condition (c) is satisfied, baryogenesis requires specific particle physics processes (electroweak sphalerons, GUT-scale interactions, or other mechanisms) that are outside the scope of the self-modeling framework.

**NC-CP-3: The entropy gradient RATE is NOT related to the CP violation MAGNITUDE by any equation in this framework.** A qualitative structural connection exists (both require time-orientation). A quantitative connection does not. The entropy gradient rate depends on the initial entropy deficit and the equilibration dynamics (Phase 23, Phase 27-01). The CP violation magnitude depends on the Yukawa coupling structure of the Standard Model. These are controlled by different physics.

### 1.5 Possible Future Direction

If the self-modeling framework could constrain which gauge groups are compatible with sustained self-modeling -- for example, if only gauge groups admitting CP-violating phases can support the required chiral fermion spectrum -- it might indirectly constrain CP violation. Concretely:

- Paper 7's chain shows that the SM gauge group emerges from $u \in S^6$.
- The SM gauge group admits CP-violating phases (through the CKM matrix for 3+ generations).
- If it could be shown that gauge groups WITHOUT CP-violating phases cannot support self-modeling, this would provide a selection argument for CP violation analogous to the Gap C selection argument for complexification.

This goes far beyond v7.0 scope and is listed here only as a research direction, not a result.

---

## 2. Master Prediction Table

The following table assembles all predictions of the v7.0 program. Each entry carries: the prediction statement, its strength level, the assumptions required, model-dependent parameters, uncertainty range, and source phase.

### Strength Levels

| Level | Meaning | Example |
|---|---|---|
| **THEOREM** | Proved rigorously under stated assumptions | Landauer bound $W \geq T \cdot I$ |
| **SELECTION ARGUMENT** | Logical chain with identified weakest link | Gap C resolution |
| **MATHEMATICAL** | Follows from definitions by direct computation | $\rho$ peak location |
| **ORDER-OF-MAGNITUDE ESTIMATE** | Requires model-specific numerical inputs | Cosmological entropy deficit |
| **STRUCTURAL/QUALITATIVE** | Logical connection without quantitative formula | CP-entropy gradient triangle |

### Prediction Table

| # | Prediction | Strength | Assumptions | Model-Dependent Parameters | Uncertainty Range | Phase Source |
|---|---|---|---|---|---|---|
| P1 | Entropy gradient is necessary for self-modeling: $S(t) < S_{\max}$ for blocks with $\rho > 0$ | **THEOREM** | A1, A2, A3 (Route A); A1, A3 (Route B); A1, A5 (Route C) | None (qualitative statement) | None (exact inequality) | Phase 26-01, Sections 1-3 |
| P2 | Minimum entropy deficit per update cycle: $\Delta S \geq I(B;M)$ | **THEOREM** | A1, A2 | None (framework quantities only) | Exact bound | Phase 25-01, Section 7; Phase 27-01, Section 1 |
| P3 | Equilibrium $\rho = 0$: at thermal equilibrium, $I(B;M) = 0$ and $\rho = 0$ | **THEOREM** | A1, A5 | None | Exact (verified to $10^{-14}$ numerically in Phase 25-01) | Phase 25-01, Section 5 |
| P4 | Complexification selected for by $\rho$: non-complexified blocks have $\rho = 0$ | **SELECTION ARGUMENT** | A1-A7 | None (qualitative; weakest link: A3, A6) | N/A (logical chain, not a number) | Phase 26-02, Section 1 |
| P5 | $\rho$ profile peaks at $I = S_B/2$ for fixed $S_B$, with $\rho_{\max} = S_B/4$ | **MATHEMATICAL** | A5 (definition of $\rho$) | $S_B$ (body entropy) | Exact for given $S_B$ | Paper 5 definition; Phase 27-01, Section 4 |
| P6 | $\rho \to 0$ as universe approaches heat death | **THEOREM** | A1, A3, A5 + Phase 23 monotonicity | None (qualitative) | None (follows from $I \to 0$ at equilibrium) | Phase 25-01, Section 5; Phase 23-02, Section 3 |
| P7 | Cosmological entropy deficit from Landauer: $\Delta S_{\text{Landauer}} \sim 10^{28}$ nats | **ORDER-OF-MAGNITUDE ESTIMATE** | A1, A2, A8 ($S_{\max}$), A10 ($I$, $N$) | $I(B;M) \sim 7 \times 10^9$ nats, $N \sim 4 \times 10^{18}$ cycles, $S_{\max} \sim 10^{122}$ | $10^{25}$--$10^{32}$ nats (varies with $I$ and $N$ by $\pm 3$ orders of magnitude each) | Phase 27-01, Section 2 |
| P8 | Landauer bound $\sim 94$ orders of magnitude weaker than Penrose's $10^{88}$ | **COMPARISON** | A8, A9, A10 | All three cosmological inputs | Robust: even $\pm 10$ orders in parameters gives $>80$ orders gap | Phase 27-01, Section 2.5-2.6 |
| P9 | Exhaustion timescale: $N_{\text{exhaust}} = \Delta S / I(B;M)$, giving $\tau_{\text{exhaust}} \sim 10^{111}$ s $\gg t_U$ | **THEOREM** (formula) + **ORDER-OF-MAGNITUDE ESTIMATE** (number) | A1, A2, A4, A8, A10 | $\Delta S$, $I(B;M)$, $t_{\text{cycle}}$ | $10^{108}$--$10^{114}$ s (varies with inputs) | Phase 27-01, Section 3 |
| P10 | CP violation structurally connected to entropy gradient via time-orientation | **STRUCTURAL/QUALITATIVE** | Phase 24 (CHIR-01) + CPT theorem | None (structural connection, not a number) | N/A (qualitative) | This document, Section 1 |

### Prediction Count: 10 predictions with all required metadata fields.

---

## 3. Model-Dependence Register

For each model-dependent parameter in the prediction table, this section provides: the parameter name and symbol, where it enters the framework, the plausible range of values, how predictions change across the range, and what could pin it down.

### 3.1 $d_B$, $d_M$: Hilbert space dimensions

- **Symbol:** $d_B = \dim(\mathcal{H}_B)$, $d_M = \dim(\mathcal{H}_M)$
- **Where it enters:** $S_{\max} = \ln(d_B \cdot d_M)$ bounds the total entropy; $S_B \leq \ln(d_B)$ bounds the body entropy; $\rho_{\max} = S_B/4 \leq \ln(d_B)/4$.
- **Plausible range:** For a human-scale self-modeler, $d_B$ is effectively enormous ($d_B \sim 2^{10^{26}}$ for a macroscopic object with $\sim 10^{26}$ two-level subsystems). $d_M$ depends on what counts as the "model" subsystem: $d_M \sim 2^{10^{10}}$ for neural-scale complexity.
- **Sensitivity:** $S_{\max}$ and $S_B$ enter logarithmically ($\ln d$), so even order-of-magnitude changes in $d$ produce modest changes in entropy. The qualitative predictions (P1, P3, P4, P5, P6) are insensitive to $d_B$, $d_M$. The quantitative predictions (P7, P8, P9) depend on $S_{\max}$ and $I$, which are bounded by $\ln d$.
- **What could pin it down:** A physical model of which degrees of freedom constitute the "body" and "model" subsystems of a concrete self-modeler (e.g., an organism). This requires bridging the gap between the abstract framework and specific physical systems.

### 3.2 $I(B;M)$: Mutual information

- **Symbol:** $I(B;M) = S(\rho_B) + S(\rho_M) - S(\rho_{BM})$
- **Where it enters:** Landauer cost per cycle ($W \geq T \cdot I$), exhaustion timescale ($N_{\text{exhaust}} = \Delta S / I$), $\rho$ profile ($\rho = I(1 - I/S_B)$).
- **Plausible range:** $10^6$ nats (minimal self-model) to $10^{15}$ nats (full neural connectivity). Baseline estimate: $I \sim 7 \times 10^9$ nats (from $\sim 10^{10}$ neurons at $\sim \ln 2$ nats each; see Phase 27-01, Section 2.3).
- **Sensitivity:** $\Delta S_{\text{Landauer}} = N \cdot I$ is linear in $I$. Changing $I$ by a factor of $10^3$ changes $\Delta S_{\text{Landauer}}$ by $10^3$. The Penrose comparison (P8) shifts by 3 orders of magnitude: from 94 to 91 (if $I$ increases $10^3$) or to 97 (if $I$ decreases $10^3$). The qualitative conclusion ($\Delta S_{\text{Landauer}} \ll \Delta S_{\text{Penrose}}$) is unchanged.
- **What could pin it down:** Quantitative neuroscience measurements of the mutual information between an organism's "self-model" and its body state. This is an open experimental question in computational neuroscience.

### 3.3 $J$: Coupling constant

- **Symbol:** $J$ (energy scale of the SWAP Hamiltonian $H = JF$)
- **Where it enters:** Equilibration rate: $p = \sin^2(Jt)$ per step. Equilibration timescale: $\tau_{\text{eq}} \sim 1/(J^2 t_{\text{step}})$.
- **Plausible range:** Unknown. $J$ sets the interaction energy scale on Paper 6's lattice. If the lattice is at the Planck scale, $J \sim E_P \sim 10^{19}$ GeV. If the lattice is at a lower scale, $J$ is correspondingly smaller.
- **Sensitivity:** $J$ affects TIMESCALES (how fast equilibration proceeds) but NOT qualitative conclusions (that equilibration occurs). All qualitative predictions (P1-P6, P10) are independent of $J$. The quantitative predictions (P7-P9) depend on $J$ only through the definition of "update cycle," and $J$ cancels from $N_{\text{exhaust}} = \Delta S / I$.
- **What could pin it down:** Determining the fundamental lattice scale of Paper 6's emergent spacetime. Currently an open question.

### 3.4 $T$: Bath temperature

- **Symbol:** $T$ (temperature of the thermal bath surrounding the BM composite)
- **Where it enters:** Landauer bound: $W \geq T \cdot I$ (energy cost). Free energy: $F = E - TS$. Available work: $W_{\text{avail}} = T \cdot \Delta S$.
- **Plausible range:** For a cosmological estimate, $T \sim T_{\text{CMB}} \approx 2.7$ K (current CMB temperature), but the relevant temperature is the local bath, not necessarily the CMB. For a biological self-modeler, $T \sim 300$ K.
- **Sensitivity:** $T$ cancels from $N_{\text{exhaust}} = \Delta S / I$ (both numerator and denominator are proportional to $T$). Therefore: the exhaustion timescale is INDEPENDENT of temperature. All qualitative predictions are independent of $T$. The Landauer cost per cycle ($W \geq T \cdot I$) is proportional to $T$, but the number of affordable cycles is not.
- **What could pin it down:** Not needed -- $T$ cancels from all key predictions.

### 3.5 $t_{\text{cycle}}$: Update period

- **Symbol:** $t_{\text{cycle}}$ (time between consecutive self-modeling update cycles)
- **Where it enters:** Physical exhaustion timescale: $\tau_{\text{exhaust}} = N_{\text{exhaust}} \cdot t_{\text{cycle}}$. Total number of cycles: $N = t_{\text{life}} / t_{\text{cycle}}$.
- **Plausible range:** $t_{\text{cycle}} \sim 0.01$--$1$ s (neural timescales for biological self-modelers). For a hypothetical Planck-scale self-modeler, $t_{\text{cycle}} \sim t_P \sim 10^{-44}$ s.
- **Sensitivity:** $N$ is inversely proportional to $t_{\text{cycle}}$, so $\Delta S_{\text{Landauer}} = N \cdot I = (t_{\text{life}}/t_{\text{cycle}}) \cdot I$ is inversely proportional to $t_{\text{cycle}}$. Decreasing $t_{\text{cycle}}$ by $10^2$ increases $\Delta S_{\text{Landauer}}$ by $10^2$. Still negligible compared to the 94-order gap with Penrose.
- **What could pin it down:** Empirical measurement of self-modeling update rates in biological or artificial systems.

### 3.6 $S_{\max}$: Maximum entropy of the observable universe

- **Symbol:** $S_{\max} \sim A/(4G\hbar) \sim 10^{122}$ nats (Bekenstein/Bousso bound)
- **Where it enters:** Entropy budget: $\Delta S = S_{\max} - S_{\text{initial}}$. Exhaustion timescale through $\Delta S$.
- **Plausible range:** $10^{120}$--$10^{124}$ nats, depending on cosmological model ($\Lambda$CDM, varying $\Lambda$, different horizon definitions).
- **Sensitivity:** $N_{\text{exhaust}} = \Delta S / I \approx S_{\max} / I$ (since $S_{\max} \gg S_{\text{initial}}$). Varying $S_{\max}$ by $10^2$ shifts $\tau_{\text{exhaust}}$ by $10^2$. The comparison with Penrose (P8) shifts by $\pm 2$ orders.
- **What could pin it down:** Precision cosmology -- measurement of the cosmological constant and Hubble constant determine the de Sitter horizon and hence $S_{\max}$.

---

## 4. What v7.0 Does and Does Not Achieve

### ACHIEVED (with evidence)

**4.1 Entropy gradient theorem** -- Self-modelers require $S < S_{\max}$.
- **Evidence:** Three convergent routes (A, B, C) with different assumption sets, all yielding the same conclusion. Phase 26-01, Sections 1-3.
- **Assumptions used:** A1-A5 (varying by route).
- **Significance:** Elevates the Past Hypothesis from "observed cosmological fact" to "necessary for the existence of self-modelers with $\rho > 0$." This is an anthropic-type argument, not a first-principles derivation.

**4.2 Gap C resolution** -- Complexification as selection effect.
- **Evidence:** 7-step logical chain (non-complexified $\to$ no chirality $\to$ no time-orientation $\to$ no entropy gradient $\to$ no self-modeling $\to$ $\rho = 0$). Phase 26-02, Sections 1-2.
- **Assumptions used:** A1-A7 (full set).
- **Significance:** Resolves Gap C from Paper 7 without algebraic forcing. Phase 22 proved algebraic forcing is impossible; the selection argument succeeds where algebra fails.

**4.3 Landauer bound on self-modeling** -- $W_{\text{cycle}} \geq T \cdot I(B;M)$.
- **Evidence:** Quantum Landauer bound (Reeb & Wolf 2014) applied to the test-erase-write cycle of self-modeling. Coherence loophole closed via three independent arguments. Phase 25-01, Section 7; Phase 25-02.
- **Assumptions used:** A1, A2.
- **Significance:** Establishes that self-modeling is thermodynamically costly, providing the foundation for the entropy gradient theorem.

**4.4 Chirality-time link** -- CHIR-01 and CHIR-02.
- **Evidence:** Explicit computation for $d = 2, 4, 10$ and general proof for all even $d$. Three-consequence theorem stated and proved. Phase 24-01, Phase 24-02.
- **Assumptions used:** A1-A4 for the algebraic part; A5-A6 for the spacetime satisfaction.
- **Significance:** Reveals a previously unidentified cross-paper dependency: Paper 7's chirality requires Paper 6's time-orientation.

**4.5 Quantitative framework for predictions** -- Master prediction table (Section 2 of this document).
- **Evidence:** 10 predictions with full metadata (strength, assumptions, model-dependence, uncertainty). Phase 27-01 and this document.
- **Significance:** Predictions are order-of-magnitude, not precision. The framework provides structural/qualitative predictions (P1-P6, P10) and order-of-magnitude estimates (P7-P9).

### NOT ACHIEVED (honest statement of what is missing)

**4.6 Derivation of $S_{\text{initial}} \sim 10^{88}$ (Penrose's number)** -- NOT ACHIEVED.
- **What the framework gives:** $\Delta S \geq N \cdot I(B;M) \sim 10^{28}$ nats. This is a lower bound on the initial entropy deficit.
- **What Penrose gives:** $\Delta S \sim 10^{122}$ from gravitational entropy (Weyl curvature hypothesis).
- **The gap:** 94 orders of magnitude. The Landauer bound constrains information-processing costs; Penrose constrains gravitational entropy. These are different physics.
- **What would be needed:** A mechanism within the framework to constrain gravitational entropy. Currently absent.

**4.7 Quantitative CP violation--entropy gradient connection** -- NOT ACHIEVED.
- **What the framework gives:** A structural triangle (Section 1.3): chirality, time-orientation, and entropy gradient are connected through their shared dependence on time-orientation.
- **What is missing:** A quantitative formula relating $dS/dt$ to CP-violating parameters (Jarlskog invariant, CKM phase). No such formula exists in the framework.
- **What would be needed:** A mechanism within the framework to constrain Yukawa couplings or CKM matrix elements. Currently absent.

**4.8 Precise location of "now" on the $\rho$ profile** -- NOT ACHIEVED.
- **What the framework gives:** The qualitative shape of $\rho(t)$ (rise-peak-fall or monotone decrease) and the peak location ($I = S_B/2$ for fixed $S_B$).
- **What is missing:** The mapping from abstract update steps $N$ to cosmological time $t$ requires $J$, $t_{\text{cycle}}$, and $S_B(t)$, which are model-dependent.
- **What would be needed:** A physical model specifying $J$ and $t_{\text{cycle}}$ in terms of fundamental constants.

**4.9 Algebraic proof of complexification** -- NOT ACHIEVED (and proved impossible).
- **What v6.0 showed:** Four algebraic routes to force complexification of $V_{1/2}$ all failed. The $V_1 = \mathbb{R} \cdot E_{11}$ bottleneck is genuine. Phase 22.
- **What v7.0 provides instead:** The selection argument (Phase 26-02). This is weaker than algebraic proof but is the appropriate resolution given that algebraic proof is impossible.
- **The distinction:** Algebraic proof would close Gap C unconditionally. The selection argument closes it within the $\rho > 0$ sector only.

### OPEN (for future work)

**4.10** Can the prediction framework be sharpened with additional physical input? For example, if the lattice scale $J$ could be related to the Planck energy, or if $t_{\text{cycle}}$ could be related to a fundamental timescale, the order-of-magnitude estimates would become more constrained.

**4.11** Does the structural CP-gradient connection have quantitative content in specific models? If a specific self-modeling model with explicit gauge dynamics were constructed, the CP violation parameters might be constrained by the requirement of sustained self-modeling.

**4.12** What is the correct measure on structure space for the selection argument? The selection argument (Phase 26-02) uses $\rho > 0$ as the selection criterion. A more refined measure on the space of blocks might yield sharper predictions about which blocks contribute most to the experiential measure.

---

## 5. Roadmap Verification

This section verifies each of the three Phase 27 success criteria from the roadmap and audits compliance with both forbidden proxies.

### Criterion 1: Minimum initial entropy from Landauer bound, compared to Penrose

**Roadmap statement:** "Minimum initial entropy consistent with self-modeling is computed from the Landauer bound and compared to Penrose's estimate $S_{\text{initial}} \sim 10^{88}$, with explicit assumptions stated."

**Verification:**

- **Computation present:** YES. derivations/27-quantitative-predictions.md, Section 1.4 derives:

$$S_{\text{initial}} \leq S_{\max} - N \cdot I(B;M)$$

with $\Delta S_{\min} = N \cdot I(B;M)$. The cosmological estimate (Section 2.4) gives $\Delta S_{\text{Landauer}} \sim 3 \times 10^{28}$ nats.

- **Penrose comparison present:** YES. derivations/27-quantitative-predictions.md, Section 2.5-2.6 computes:

$$\frac{\Delta S_{\text{Landauer}}}{\Delta S_{\text{Penrose}}} \sim 3 \times 10^{-94}$$

The Landauer bound is 94 orders of magnitude weaker than Penrose's gravitational entropy estimate. Section 2.6 interprets this honestly: "The Landauer bound is NECESSARY but not SUFFICIENT."

- **Assumptions explicitly stated:** YES. Section 0 lists inherited assumptions A1-A7. Section 2.1-2.3 introduces cosmological assumptions A8-A10 with explicit "[COSMOLOGICAL INPUT]" and "[MODEL-DEPENDENT]" warnings. Every numerical estimate identifies which assumptions it depends on.

**VERDICT: PASS.** Section references: derivations/27-quantitative-predictions.md, Sections 1.3, 1.4, 2.4, 2.5, 2.6.

### Criterion 2: rho profile evaluated, peak identified, "now" location addressed

**Roadmap statement:** "The rho profile $\rho = I(B;M)(1 - I/H)$ is evaluated over cosmological time, identifying the peak at $I = H/2$ and locating 'now' on the curve (or explaining why this is model-dependent)."

**Note on notation:** The roadmap uses $H$ where the framework uses $S_B = S(\rho_B)$ (body entropy). The formula is $\rho = I(1 - I/S_B)$, with peak at $I = S_B/2$.

**Verification:**

- **rho profile evaluated:** YES. derivations/27-quantitative-predictions.md, Section 4 (Sections 4.1-4.6) evaluates $\rho(I) = I(1 - I/S_B)$ as a function of the mutual information $I$, and tracks its evolution under the Phase 23 equilibration dynamics.

- **Peak identified:** YES. Section 4.2 computes: $d\rho/dI = 1 - 2I/S_B = 0$ gives $I^* = S_B/2$, with $\rho_{\max} = S_B/4$. Verified analytically and numerically (qubit case: $\rho_{\max} = \ln 2/4 \approx 0.173$).

- **"Now" location:** ADDRESSED AS MODEL-DEPENDENT. Section 4.5-4.6 explains that the qualitative shape (rise-peak-fall vs. monotone decrease) depends on the initial mutual information $I_0$ relative to $S_B/2$. The mapping from update steps $N$ to cosmological time $t$ depends on $J$, $t_{\text{cycle}}$, $S_B(t)$, and the cosmological model. These are model-dependent parameters (Section 3), so the location of "now" on the $\rho$ curve cannot be determined within the framework. This is stated explicitly in NC-2 (Section 5 of 27-quantitative-predictions.md) and in Section 4.8 of this document.

**VERDICT: PASS.** Section references: derivations/27-quantitative-predictions.md, Sections 4.1, 4.2, 4.3, 4.5, 4.6, 5 (NC-2).

### Criterion 3: All predictions carry uncertainty ranges and model-dependence

**Roadmap statement:** "All predictions carry explicit uncertainty ranges and model-dependence statements."

**Verification:**

- **Prediction table completeness:** The master prediction table (this document, Section 2) has 10 entries (P1-P10). Each entry has 6 fields: Prediction, Strength, Assumptions, Model-Dependent Parameters, Uncertainty Range, Phase Source.

- **Uncertainty ranges present:** All 10 entries have the "Uncertainty Range" field populated:
  - P1, P3, P6: "None (exact inequality)" or "None (exact)" -- theorems with no model-dependent parameters.
  - P2, P5: "Exact bound" or "Exact for given $S_B$" -- mathematical results.
  - P4, P10: "N/A (logical chain, not a number)" or "N/A (qualitative)" -- structural arguments.
  - P7: "$10^{25}$--$10^{32}$ nats" -- explicit numerical range.
  - P8: "Robust: even $\pm 10$ orders in parameters gives $>80$ orders gap" -- robustness stated.
  - P9: "$10^{108}$--$10^{114}$ s" -- explicit numerical range.

- **Model-dependence statements present:** All entries have the "Model-Dependent Parameters" field populated. Entries with no model-dependent parameters say "None" explicitly. Entries with model-dependent parameters list them.

- **Model-dependence register:** Section 3 provides a detailed register of all 6 model-dependent parameters ($d_B$/$d_M$, $I(B;M)$, $J$, $T$, $t_{\text{cycle}}$, $S_{\max}$) with plausible ranges, sensitivity analysis, and what could pin each one down.

- **Non-claims guard against overclaiming:** NC-1 through NC-4 (derivations/27-quantitative-predictions.md, Section 5) and NC-CP-1 through NC-CP-3 (this document, Section 1.4) explicitly prevent overclaiming.

**VERDICT: PASS.** Section references: this document, Sections 2 and 3; derivations/27-quantitative-predictions.md, Section 5.

### Forbidden Proxy Audit

**FP-1: "Claiming precise numerical predictions without stating model-dependence."**

**Scan method:** Search both derivation files (27-quantitative-predictions.md and 27-prediction-synthesis.md) for all numerical values and verify each has model-dependence context.

- $\Delta S_{\text{Landauer}} \sim 10^{28}$: Tagged "[MODEL-DEPENDENT: depends on $I$, $N$, $S_{\max}$]" in 27-quantitative-predictions.md Section 2.4. Listed under P7 with uncertainty range $10^{25}$--$10^{32}$ in the prediction table.
- $\tau_{\text{exhaust}} \sim 10^{111}$ s: Tagged "[MODEL-DEPENDENT]" in 27-quantitative-predictions.md Section 3.3. Listed under P9 with uncertainty range $10^{108}$--$10^{114}$.
- 94 orders of magnitude gap: Listed under P8 as "Robust: even $\pm 10$ orders in parameters gives $>80$ orders gap."
- $I \sim 7 \times 10^9$ nats: Tagged "[MODEL-DEPENDENT]" in 27-quantitative-predictions.md Section 2.3 with range $10^6$--$10^{15}$.
- $N \sim 4 \times 10^{18}$: Tagged "[MODEL-DEPENDENT]" in 27-quantitative-predictions.md Section 2.3.
- Jarlskog invariant $J \approx 3 \times 10^{-5}$: Cited as a Standard Model parameter in NC-CP-1, NOT as a prediction of this framework.
- Baryon-to-photon ratio $\eta_B \approx 6 \times 10^{-10}$: Cited in NC-CP-2 as external, NOT as a prediction.

**Zero violations found.** Every numerical value from the framework carries model-dependence context. External numbers (Penrose, Sakharov) are clearly attributed.

**VERDICT: FP-1 REJECTED (no violations).**

**FP-2: "Overclaiming cosmological implications beyond what the framework supports."**

**Scan method:** Search for cosmological claims and verify each is bounded by stated assumptions and non-claims.

- The entropy gradient theorem (P1) claims $S < S_{\max}$ -- this is a constraint ON cosmological initial conditions, not a specific prediction. The distinction is explicit in Phase 26-01, NC-1: "This does NOT derive the Past Hypothesis from self-modeling alone."
- The Landauer bound comparison (P8) explicitly states the bound is "NECESSARY but not SUFFICIENT" (27-quantitative-predictions.md, Section 2.6).
- The CP violation connection (P10) is "STRUCTURAL/QUALITATIVE" with NC-CP-1/2/3 preventing overclaiming.
- Section 4 of this document explicitly lists four "NOT ACHIEVED" items including "Derivation of $S_{\text{initial}} \sim 10^{88}$" and "Quantitative CP violation--entropy gradient connection."
- The framework is characterized as operating "on finite SWAP lattices" with cosmological application requiring "multiple additional assumptions (A3, A6, A7)" -- consistent with the forbidden proxy's concern.

**Zero violations found.** Every cosmological statement is bounded by assumptions and non-claims.

**VERDICT: FP-2 REJECTED (no violations).**

### Phase 27 Verification Summary

| Item | Status | Evidence |
|---|---|---|
| Criterion 1: Minimum entropy from Landauer + Penrose comparison | **PASS** | 27-quantitative-predictions.md, Sections 1-2 |
| Criterion 2: rho profile + peak + "now" | **PASS** | 27-quantitative-predictions.md, Section 4 |
| Criterion 3: Uncertainty ranges + model-dependence | **PASS** | This document, Sections 2-3 |
| Forbidden Proxy 1: Precise predictions without model-dependence | **REJECTED** | All numbers carry context |
| Forbidden Proxy 2: Cosmological overclaiming | **REJECTED** | All claims bounded by assumptions and non-claims |

**Overall Phase 27 result: 3/3 success criteria PASSED, 2/2 forbidden proxies REJECTED.**

Phase 27 is complete. The v7.0 Arrow of Time program (Phases 23-27) is concluded.

---

*Phase: 27-quantitative-predictions-conditional*
*Plan: 02, Tasks 1-2*
*Completed: 2026-03-24*
