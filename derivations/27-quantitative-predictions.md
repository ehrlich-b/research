# Quantitative Predictions from the Entropy Gradient Theorem

% ASSERT_CONVENTION: natural_units=natural, entropy_base=nats, state_normalization=Tr(rho)=1, sequential_product=a&b=sqrt(a)b*sqrt(a), von_neumann_entropy=S(rho)=-Tr(rho*ln*rho), coupling_convention=H=sum_h_xy, information=I(B;M)=S(B)+S(M)-S(BM), free_energy=F=E-TS

**Phase 27, Plan 01**
**Date:** 2026-03-24

**References:**
- Paper 5 (v2.0): Self-modeling axioms, experiential density rho [ref-paper5]
- Phase 23, Plan 01: CPTP channel E(rho_B) = cos^2(Jt) rho_B + sin^2(Jt) I/2 [derivations/23-luders-channel-entropy.md]
- Phase 23, Plan 02: Iterated channel E^N(rho) -> I/2, entropy monotonicity [derivations/23-entropy-theorem.md]
- Phase 25, Plan 01: Landauer bound W >= kT * I(B;M) per cycle [derivations/25-landauer-self-modeling.md]
- Phase 26, Plan 01: Entropy gradient theorem -- three routes [derivations/26-entropy-gradient-theorem.md]
- Phase 26, Plan 02: Gap C resolution, v7.0 master theorem, A1-A7 [derivations/26-gap-c-resolution.md]
- Penrose (1979): "Singularities and time-asymmetry," in GR: An Einstein Centenary Survey [ref-penrose1979]
- Carroll (2010): "From Eternity to Here" -- Past Hypothesis context [ref-carroll2010]
- Lloyd (2002): "Computational capacity of the universe," PRL 88, 237901 [ref-lloyd2002]
- Bousso (1999): "A covariant entropy conjecture," JHEP 9907:004 [ref-bousso1999]
- Reeb & Wolf (2014): Quantum Landauer bound, New J. Phys. 16, 103011 [ref-reeb-wolf2014]

---

## 0. Scope and Assumptions

This derivation extracts **quantitative predictions** from the entropy gradient theorem (Phase 26), the Landauer bound on self-modeling (Phase 25), and the equilibration dynamics (Phase 23). All results are **order-of-magnitude estimates** with explicitly model-dependent parameters. These are NOT precision predictions.

### Inherited assumptions (Phases 23-26)

| ID | Assumption | Source | Status |
|---|---|---|---|
| A1 | Finite-dimensional QM: dim(H_B), dim(H_M) < infinity | Paper 5 axioms | AXIOM |
| A2 | Thermal contact: BM weakly coupled to bath at temperature T | Landauer regime | STANDARD PHYSICS |
| A3 | Closed/semi-closed system equilibration | Statistical mechanics | PHYSICAL ARGUMENT |
| A4 | SWAP lattice dynamics: H = JF | Paper 6 | MODEL CHOICE |
| A5 | Experiential density rho = I(1 - I/S(B)) | Paper 5 | AXIOM |
| A6 | Continuum limit from lattice | Phases 9-10 | CONJECTURED |
| A7 | Lorentzian signature of emergent spacetime | Phase 24 | PHYSICAL ARGUMENT |

### New assumptions for cosmological estimates

| ID | Assumption | Status | What it controls |
|---|---|---|---|
| A8 | S_max ~ 10^{122} (Bekenstein bound on cosmological horizon) | COSMOLOGICAL INPUT | Overall entropy budget |
| A9 | S_initial ~ 10^{88} (Penrose, Weyl curvature hypothesis) | EXTERNAL ESTIMATE | Comparison target |
| A10 | Neural self-modeling: d_M ~ 2^{10^{10}}, update rate ~ 10 Hz | MODEL-DEPENDENT | I(B;M) and N_cycles values |

**Explicit warning:** Every numerical estimate below depends on A8-A10 (cosmological inputs), which are independent of the framework. The framework (A1-A7) provides the structural result (self-modeling requires entropy gradient); the numbers require extra-framework assumptions.

---

## 1. Minimum Initial Entropy from the Landauer Bound

### 1.1 Free energy cost of self-modeling

From Phase 25 (derivations/25-landauer-self-modeling.md, Section 7, Theorem (a)):

$$W_{\text{cycle}} \geq T \cdot I(B;M) \quad \text{(per self-modeling update cycle)}$$

where T is the bath temperature and I(B;M) = S(rho_B) + S(rho_M) - S(rho_BM) is the mutual information in nats. (In natural units, k_B = 1.)

### 1.2 Available work from entropy deficit

A system at entropy S in contact with a bath at temperature T, with maximum entropy S_max = ln(d), has available free energy:

$$W_{\text{available}} = T \cdot (S_{\max} - S) = T \cdot \Delta S$$

where Delta_S = S_max - S is the **entropy deficit** (in nats).

**Derivation:** The Helmholtz free energy is F = E - TS. At thermal equilibrium, F_eq = E_eq - T S_max. The maximum extractable work is:

$$W_{\max} = F - F_{\text{eq}} = T \cdot D(\rho \| \rho_{\text{eq}})$$

where D is the quantum relative entropy. For states close to equilibrium, D(rho || rho_eq) = S_max - S(rho) + O((rho - rho_eq)^2). The leading term is exactly Delta_S.

**DIMENSIONAL CHECK:** [W] = [energy]. [T] = [energy] (k_B = 1). [Delta_S] = [nats] = dimensionless. [T * Delta_S] = [energy]. Consistent.

### 1.3 Number of self-modeling cycles before exhaustion

$$N_{\text{exhaust}} = \frac{W_{\text{available}}}{W_{\text{cycle}}} \leq \frac{T \cdot \Delta S}{T \cdot I(B;M)} = \frac{\Delta S}{I(B;M)}$$

The temperature T cancels. This is the maximum number of update cycles the system can sustain before the entropy deficit is consumed and the system equilibrates.

**DIMENSIONAL CHECK:** [N] = [nats]/[nats] = dimensionless. Correct -- N is a count.

### 1.4 Minimum entropy deficit for self-modeling

For self-modeling to occur at all, we need at least one cycle: N_exhaust >= 1.

$$N_{\text{exhaust}} \geq 1 \implies \Delta S \geq I(B;M)$$

In terms of absolute entropy:

$$S_{\text{initial}} \leq S_{\max} - I(B;M)$$

For N cycles of self-modeling:

$$\boxed{S_{\text{initial}} \leq S_{\max} - N \cdot I(B;M)}$$

The **minimum entropy deficit** for N cycles is:

$$\Delta S_{\min} = N \cdot I(B;M)$$

**SELF-CRITIQUE CHECKPOINT (step 1):**
1. SIGN CHECK: Delta_S = S_max - S >= 0 (entropy below maximum). N * I >= 0 (non-negative mutual information, non-negative count). The constraint Delta_S >= N * I points in the correct direction. Correct.
2. FACTOR CHECK: T cancelled from numerator and denominator in N_exhaust. No stray factors of 2, pi, or ln 2 (all in nats). Correct.
3. CONVENTION CHECK: Entropy in nats (ln), k_B = 1 so T has dimensions of energy, I is dimensionless. Consistent with Phase 25 conventions.
4. DIMENSION CHECK: [S_initial] = [nats] = dimensionless. [S_max] = dimensionless. [N * I] = dimensionless. [S_initial <= S_max - N * I]: dimensionless <= dimensionless. Correct.

---

## 2. Cosmological Estimate

### 2.1 Maximum entropy of the observable universe (A8)

The Bekenstein bound on the cosmological horizon (covariant entropy bound, Bousso 1999 [ref-bousso1999]) gives:

$$S_{\max} \sim \frac{A}{4 G \hbar} \sim \frac{\pi R_H^2}{l_P^2} \sim 10^{122} \text{ nats}$$

where R_H ~ 4.4 * 10^{26} m is the Hubble radius and l_P ~ 1.6 * 10^{-35} m is the Planck length. This is the de Sitter entropy of the cosmological horizon.

**[COSMOLOGICAL INPUT -- not derived from the framework. Depends on the cosmological model (Lambda-CDM), the value of the cosmological constant, and the interpretation of de Sitter entropy.]**

### 2.2 Penrose's initial entropy estimate (A9)

Penrose (1979) [ref-penrose1979] estimated the initial entropy of the observable universe from the Weyl curvature hypothesis:

$$S_{\text{initial}} \sim 10^{88} \text{ nats (order of magnitude)}$$

This comes from the observation that the early universe was gravitationally smooth (low Weyl curvature), while the maximum gravitational entropy is dominated by black holes. The entropy budget is:

- Current visible matter entropy: ~ 10^{80} (dominated by CMB photons)
- Current entropy if all matter collapsed to one black hole: ~ 10^{121}
- Penrose's estimate S_initial ~ 10^{88}: the gravitational contribution at the Big Bang

**[EXTERNAL ESTIMATE -- derived from GR + black hole thermodynamics + Weyl curvature hypothesis, NOT from this framework. The number 10^{88} is Penrose's, not ours.]**

### 2.3 The Landauer constraint applied to cosmological parameters

From Section 1.4:

$$\Delta S_{\min} = N \cdot I(B;M)$$

We need estimates for N and I(B;M). Both are MODEL-DEPENDENT (A10).

**Estimate for I(B;M):** A human-scale self-modeler has a model subsystem M with effective dimension d_M. The model stores ~ 10^{10} neural-scale degrees of freedom at roughly ~ 10 bits each (this is a crude estimate of the information content of a neural representation):

$$I(B;M) \sim 10^{10} \times \ln 2 \approx 7 \times 10^{9} \text{ nats}$$

**[MODEL-DEPENDENT: depends on what counts as "self-modeling" and the information capacity of the model. Could range from 10^6 (minimal self-model) to 10^{15} (full neural connectivity). The order of magnitude is uncertain by factors of 10^3 or more.]**

**Estimate for N:** If the update rate is nu ~ 10 Hz (neural timescale, order of magnitude) and the universe is t_U ~ 4 * 10^{17} s old:

$$N \sim \nu \cdot t_U \sim 10 \times 4 \times 10^{17} = 4 \times 10^{18} \text{ cycles}$$

**[MODEL-DEPENDENT: 10 Hz is a rough neural timescale. For the entire age of the universe, this overestimates because self-modelers have not existed for the full age. For a more realistic estimate using the time since complex life: t_life ~ 10^{9} yr ~ 3 * 10^{16} s, giving N ~ 3 * 10^{17}. This changes nothing at the order-of-magnitude level.]**

### 2.4 Total entropy deficit from the Landauer bound

$$\Delta S_{\text{Landauer}} = N \cdot I(B;M) \sim 4 \times 10^{18} \times 7 \times 10^{9} \sim 3 \times 10^{28} \text{ nats}$$

**Arithmetic check:** 4 * 7 = 28. 10^{18} * 10^{9} = 10^{27}. So 28 * 10^{27} = 2.8 * 10^{28} ~ 3 * 10^{28}. Confirmed.

### 2.5 Comparison with Penrose

The Penrose entropy deficit (the "room" between S_max and S_initial):

$$\Delta S_{\text{Penrose}} = S_{\max} - S_{\text{initial}} \sim 10^{122} - 10^{88} \approx 10^{122}$$

(Since 10^{122} >> 10^{88}, the subtraction is dominated by the larger term.)

The Landauer entropy deficit:

$$\Delta S_{\text{Landauer}} \sim 3 \times 10^{28}$$

**The ratio:**

$$\frac{\Delta S_{\text{Landauer}}}{\Delta S_{\text{Penrose}}} \sim \frac{3 \times 10^{28}}{10^{122}} = 3 \times 10^{-94}$$

### 2.6 Key result: the Landauer bound is vastly weaker than Penrose

$$\boxed{\Delta S_{\text{Landauer}} \sim 10^{28} \ll \Delta S_{\text{Penrose}} \sim 10^{122}}$$

**Interpretation:** The Landauer bound on self-modeling requires the initial entropy to be at most S_max - 10^{28} nats below maximum. Penrose's estimate places S_initial at 10^{88}, which is S_max - 10^{122} below maximum. The Landauer constraint is approximately **94 orders of magnitude weaker** than Penrose's gravitational entropy argument.

**What this means:**

1. The Landauer bound is **NECESSARY but not SUFFICIENT** to explain the observed low initial entropy. It provides a lower bound on the entropy deficit (Delta_S >= 10^{28} for one human-scale self-modeler over cosmic time), but the actual deficit (~ 10^{122}) is vastly larger.

2. The framework says: "The Past Hypothesis is needed for self-modeling." It does NOT predict HOW MUCH initial low entropy there was. The enormous gap between 10^{28} and 10^{122} reflects the fact that most of the universe's entropy budget is gravitational (Weyl curvature, black holes), while the Landauer bound constrains only the information-processing cost of self-modeling.

3. The weakness of the bound is itself informative: the Landauer self-modeling cost is NOT the limiting factor in the entropy budget. Gravitational entropy dominates by ~94 orders of magnitude.

**SELF-CRITIQUE CHECKPOINT (step 2):**
1. SIGN CHECK: Delta_S_Landauer > 0 (positive entropy deficit required). Delta_S_Penrose > 0. Ratio positive and << 1. All correct.
2. FACTOR CHECK: 10^{10} * ln(2) ~ 7 * 10^9. Arithmetic: 10 * 4*10^{17} = 4*10^{18}. Product: 4*10^{18} * 7*10^9 = 28*10^{27} = 2.8*10^{28}. No stray factors.
3. CONVENTION CHECK: All entropies in nats (ln, not log_2). S_max ~ 10^{122} in nats. Penrose S_initial ~ 10^{88} in nats. Consistent.
4. DIMENSION CHECK: All quantities (S, I, N, Delta_S) are dimensionless. The temperature T cancelled in N_exhaust. Correct.

**Is this result trivial?** Partially. The qualitative statement (self-modeling requires S < S_max) was already proved in Phase 26. What Section 2 adds:
- (a) A quantitative lower bound on Delta_S (~10^{28} nats), albeit model-dependent.
- (b) An honest comparison with Penrose showing the Landauer bound is ~94 orders of magnitude weaker.
- (c) The identification of WHY the bound is so weak: gravitational entropy dominates the budget.

---

## 3. Exhaustion Timescale

### 3.1 Equilibration dynamics (Phase 23)

From Phase 23 (derivations/23-luders-channel-entropy.md, Section 3, Eq. (23.1)):

$$E(\rho_B) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \frac{I}{2}$$

where p = sin^2(Jt) is the depolarizing parameter per step. After N steps (Phase 23, Eq. (23.5)):

$$E^N(\rho_B) = (1-p)^N \rho_B + \left(1 - (1-p)^N\right) \frac{I}{2}$$

As N -> infinity, E^N(rho_B) -> I/2 for any initial state.

### 3.2 Equilibration timescale

The body's deviation from equilibrium decays geometrically:

$$\|\rho_B^{(N)} - I/2\| = (1-p)^N \|\rho_B^{(0)} - I/2\|$$

The system is effectively equilibrated when (1-p)^N ~ epsilon (small). Taking logarithms:

$$N_{\text{eq}} \sim \frac{\ln(1/\epsilon)}{\ln(1/(1-p))}$$

For weak coupling (p = sin^2(Jt) << 1, i.e., Jt << 1):

$$\ln(1/(1-p)) \approx p \approx (Jt)^2$$

So:

$$N_{\text{eq}} \sim \frac{\ln(1/\epsilon)}{(Jt)^2}$$

Each step takes time t_step, so the equilibration timescale in physical time is:

$$\tau_{\text{eq}} = N_{\text{eq}} \cdot t_{\text{step}} \sim \frac{t_{\text{step}} \cdot \ln(1/\epsilon)}{(J t_{\text{step}})^2} = \frac{\ln(1/\epsilon)}{J^2 t_{\text{step}}}$$

**DIMENSIONAL CHECK (with hbar restored):** In natural units, [J] = [energy] = [1/time]. [t_step] = [time]. [J * t_step] = dimensionless. [J^2 * t_step] = [1/time]. So [1/(J^2 * t_step)] = [time]. With hbar: [J] = [energy], [t_step] = [time], [J*t_step/hbar] = dimensionless. [tau] = [hbar^2 / (J^2 * t_step)] = [energy^2 * time^2 / (energy^2 * time)] = [time]. Consistent.

### 3.3 Exhaustion timescale for self-modeling

The exhaustion timescale combines the free energy budget with the equilibration dynamics:

$$\tau_{\text{exhaust}} = N_{\text{exhaust}} \cdot t_{\text{cycle}}$$

where N_exhaust = Delta_S / I(B;M) from Section 1.3 and t_cycle is the self-modeling update period.

For the cosmological estimate (Section 2):

$$\tau_{\text{exhaust}} \sim \frac{\Delta S}{I(B;M)} \cdot t_{\text{cycle}} \sim \frac{10^{122}}{7 \times 10^9} \times 0.1 \text{ s} \sim 10^{112} \text{ s}$$

(Using Delta_S = S_max - S_initial ~ 10^{122}, I ~ 7 * 10^9, t_cycle = 0.1 s.)

**Arithmetic check:** 10^{122} / (7 * 10^9) = (1/7) * 10^{113} ~ 1.4 * 10^{112}. Times 0.1 s = 1.4 * 10^{111} s. So tau_exhaust ~ 10^{111} s.

Compare the current age of the universe: t_U ~ 4 * 10^{17} s.

$$\frac{\tau_{\text{exhaust}}}{t_U} \sim \frac{10^{111}}{4 \times 10^{17}} \sim 10^{93}$$

The exhaustion timescale is ~10^{93} times the current age of the universe. **Self-modeling is thermodynamically permitted for an astronomically long time.**

**[MODEL-DEPENDENT: depends on Delta_S (cosmological, A8-A9), I(B;M) (neural, A10), and t_cycle (neural, A10). The key structural result is that tau_exhaust >> t_U, which is robust to order-of-magnitude changes in all parameters.]**

### 3.4 Relationship between equilibration and exhaustion

The equilibration timescale (Section 3.2) and the exhaustion timescale (Section 3.3) describe different processes:

- **Equilibration** (tau_eq): how fast the SWAP dynamics drives rho_B -> I/2 without active resistance. This is the passive relaxation time.
- **Exhaustion** (tau_exhaust): how long the system can sustain self-modeling by actively spending free energy to resist equilibration. This depends on the free energy reservoir.

The self-modeler's lifetime is bounded by the shorter of:
1. tau_exhaust (free energy runs out), or
2. The timescale on which the environment changes so much that the self-model becomes irrelevant.

**SELF-CRITIQUE CHECKPOINT (step 3):**
1. SIGN CHECK: tau_eq > 0, tau_exhaust > 0. Both timescales are positive. Correct.
2. FACTOR CHECK: N_eq ~ ln(1/epsilon) / p. For p << 1, ln(1/(1-p)) ~ p. No stray factors. tau_exhaust = N_exhaust * t_cycle = (Delta_S / I) * t_cycle. T cancelled. Correct.
3. CONVENTION CHECK: J in natural units has [energy] = [1/time]. t_step in [time]. Jt dimensionless. Consistent throughout.
4. DIMENSION CHECK: [tau_eq] = [time]. [tau_exhaust] = [time]. Both correct.

---

## 4. Experiential Density Profile rho(t)

### 4.1 Definition

The experiential density from Paper 5 and Phase 25:

$$\rho(I) = I(B;M) \cdot \left(1 - \frac{I(B;M)}{S_B}\right)$$

where S_B = S(rho_B) is the body entropy (NOT the Hamiltonian H = JF; notation clarified to avoid confusion).

**Properties (verified in Phase 25-01, Section 4):**
- rho(0) = 0 (no tracking -> no experiential density)
- rho(S_B) = 0 (maximal tracking / pure-state constraint)
- Peak at I = S_B / 2: rho_max = S_B / 4
- rho is a parabola in I, concave, non-negative on [0, S_B]

### 4.2 Verification of peak and zeros

$$\frac{d\rho}{dI} = 1 - \frac{2I}{S_B} = 0 \implies I^* = \frac{S_B}{2}$$

$$\rho(I^*) = \frac{S_B}{2} \cdot \left(1 - \frac{S_B/2}{S_B}\right) = \frac{S_B}{2} \cdot \frac{1}{2} = \frac{S_B^2}{4}$$

Wait -- let me recheck this. Phase 25-01, Section 4 states rho_max = S(B)/4, not S(B)^2/4.

rho(S_B/2) = (S_B/2) * (1 - (S_B/2)/S_B) = (S_B/2) * (1 - 1/2) = (S_B/2) * (1/2) = S_B/4.

Correct: **rho_max = S_B / 4**, not S_B^2 / 4. The S_B in the numerator is first-power.

**Correction to Section 4.1:** rho_max = S_B / 4. (The plan text stated S_B^2/4 in places; the correct value is S_B/4 from direct computation.)

**Verification -- qubit case:** d_B = 2, S_B = ln 2 ~ 0.693. rho_max = ln(2)/4 ~ 0.173.

Cross-check with the plan's stated value: the plan says rho_max = (ln 2)^2 / 4 ~ 0.120 for the qubit case, using S_B^2/4. But direct computation gives S_B/4 = 0.173. Let me re-examine.

The issue is: **which formula is correct?** Let me recompute from the definition.

rho(I) = I * (1 - I/S_B). At I = S_B/2:

$$\rho = \frac{S_B}{2} \left(1 - \frac{1}{2}\right) = \frac{S_B}{2} \cdot \frac{1}{2} = \frac{S_B}{4}$$

This is S_B/4, not S_B^2/4. The correct peak value is **rho_max = S_B/4**.

For the qubit: rho_max = ln(2)/4 = 0.693/4 = 0.173.

**DEVIATION [Rule 4 -- Missing correction]:** The plan text in several places states rho_max = S_B^2/4. This is a transcription error; the correct value from the definition rho = I(1 - I/S_B) is rho_max = S_B/4. Correcting inline. This does not change any qualitative conclusions; it is a factor-of-S_B error in the peak value formula. (Phase 25-01, Section 4 also states "rho_max = S(B)/4" -- consistent with S_B/4.)

### 4.3 Time evolution: two competing effects

As the universe evolves from a low-entropy initial state toward equilibrium:

**Effect 1: Body entropy S_B(t) increases.** Under the entropy monotonicity theorem (Phase 23), S_B grows from S_initial toward S_max. The "headroom" S_B for the parabola increases, making larger rho values possible.

**Effect 2: Mutual information I(B;M) decays.** Under the equilibration dynamics (Phase 23), the body approaches the maximally mixed state, driving I(B;M) -> 0. Without active maintenance, correlations between B and M are destroyed.

The experiential density rho = I * (1 - I/S_B) depends on both S_B and I. The time evolution of rho is controlled by the competition between these two effects.

### 4.4 Model-independent statements

The following hold for ANY cosmological model, requiring only A1-A5 + Phase 23:

**(a)** rho(I=0) = 0. At thermal equilibrium (I=0), experiential density vanishes. (Phase 25-01, Section 5.)

**(b)** rho peaks at I = S_B/2 for fixed S_B. The maximum possible experiential density given a body of entropy S_B is rho_max = S_B/4.

**(c)** rho -> 0 as the universe approaches heat death. Heat death means S -> S_max, which means rho_BM -> I/(d_B d_M), which means I(B;M) -> 0, which means rho -> 0.

**(d)** The existence of self-modelers NOW implies we are not at equilibrium. This is the entropy gradient theorem (Phase 26).

### 4.5 Model-dependent evolution: passive equilibration

Consider a self-modeler that does NOT actively resist equilibration (passive scenario). The mutual information decays as:

$$I(N) \sim I_0 \cdot (1-p)^N$$

(This follows from Phase 23 dynamics: as rho_B -> I/2, the correlations in rho_BM decay, driving I -> 0. The exact dependence of I on N requires a model for the joint state rho_BM, but the geometric decay is generic for the depolarizing channel.)

With S_B increasing slowly (S_B(N) ~ S_B^{(0)} + delta_S * N for small N):

$$\rho(N) = I_0 (1-p)^N \left(1 - \frac{I_0 (1-p)^N}{S_B(N)}\right)$$

For large N, (1-p)^N -> 0 dominates, so rho -> 0 regardless of how S_B grows. The decay is geometric (exponential in step count).

**Peak of rho(N):** Setting d(rho)/dN = 0 requires solving:

$$\frac{d\rho}{dN} = I_0 \ln(1-p) (1-p)^N \left(1 - \frac{2 I_0 (1-p)^N}{S_B}\right) + I_0 (1-p)^N \cdot \frac{I_0 (1-p)^N}{S_B^2} \cdot \frac{dS_B}{dN} = 0$$

If S_B is approximately constant (dS_B/dN ~ 0), the dominant balance gives:

$$1 - \frac{2 I_0 (1-p)^{N^*}}{S_B} = 0 \implies I_0 (1-p)^{N^*} = \frac{S_B}{2}$$

This has a solution only if I_0 > S_B/2 (initial mutual information exceeds the peak location). If I_0 < S_B/2, then rho decreases monotonically from its initial value (the system starts below the peak and decays toward zero).

**Qualitative shape for I_0 > S_B/2:** rho first increases as I decreases from I_0 toward S_B/2 (moving toward the peak of the parabola), reaches maximum rho_max = S_B/4 at I = S_B/2, then decreases as I continues to decay below S_B/2 toward zero. The profile is: rise-peak-fall.

**Qualitative shape for I_0 < S_B/2:** rho decreases monotonically from rho(I_0) toward zero. No peak; only decay.

**Qualitative shape for I_0 = S_B/2:** rho starts at its maximum rho_max = S_B/4 and decreases.

### 4.6 Which regime is physically relevant?

The constraint I(B;M) <= min(2S_B, 2S_M) (Araki-Lieb) means I_0 <= S_B for pure states and I_0 <= 2 S_B in general. The peak occurs at I = S_B/2, well within the allowed range.

For a realistic self-modeler: the mutual information I(B;M) encodes how well M tracks B. A "good" self-modeler with high-fidelity tracking has I ~ S_B/2 (near peak experiential density). A minimal self-modeler has I << S_B (low experiential density).

**Model-independent conclusion:** Whether rho rises then falls, or only falls, depends on the initial conditions (I_0 relative to S_B/2). Both scenarios end with rho -> 0 at equilibrium.

---

## 5. Non-Claims and Model-Dependence Register

For each quantitative prediction, we list the assumptions, model-dependent parameters, and what would change the result.

### NC-1: Landauer bound is NOT a prediction of initial entropy

The Landauer bound Delta_S >= N * I(B;M) is a LOWER BOUND on the entropy deficit. It does not predict the initial entropy; it provides a necessary condition. The actual entropy deficit (~10^{122} from Penrose/Bekenstein) is ~94 orders of magnitude larger than the Landauer minimum (~10^{28}).

- **Assumptions:** A1, A2, A8 (S_max), A10 (I, N)
- **Model-dependent:** I(B;M) (neural complexity), N (update rate * time), S_max (cosmological model)
- **Uncertainty:** Each of I, N, S_max uncertain by orders of magnitude. The qualitative conclusion (Landauer << Penrose) is robust: even if I * N is off by 10^{10}, the gap remains ~84 orders of magnitude.
- **Would change by >10x:** Nothing -- the 94-order-of-magnitude gap is insensitive to all reasonable parameter variations.

### NC-2: rho profile is NOT computed to observational precision

The framework gives the qualitative shape (rise-peak-fall or monotone decrease, both ending at zero). The quantitative location of the peak in cosmological time is model-dependent.

- **Assumptions:** A1-A5, Phase 23 dynamics
- **Model-dependent:** J (coupling strength), t_step (update period), S_B(t) (cosmological entropy evolution), I_0 (initial mutual information)
- **Uncertainty:** The mapping from update steps N to cosmological time t depends on J and t_step, which are not determined by the framework.
- **Would change qualitatively:** If equilibration did NOT drive I -> 0 (violation of A3), then rho could remain nonzero forever, removing the "fall" portion of the profile.

### NC-3: Comparison with Penrose is NOT a derivation of 10^{88}

The framework gives a much weaker constraint (~10^{28} entropy deficit) than Penrose's estimate (~10^{122} deficit). The two constraints come from different physics: Landauer from information processing, Penrose from gravitational entropy (Weyl curvature). The comparison shows internal consistency (our constraint is weaker = good), not a derivation of the Penrose number.

- **Assumptions:** A8 (S_max), A9 (Penrose), A10 (I, N)
- **What the two quantities measure:** Landauer: minimum for self-modeling. Penrose: gravitational entropy at Big Bang.
- **The gap (94 orders of magnitude) reflects:** Gravitational entropy dominates the universe's entropy budget; self-modeling is thermodynamically cheap.

### NC-4: Exhaustion timescale is NOT a prediction of the age of the universe

The exhaustion timescale (~10^{111} s) depends on the coupling J, update rate, and entropy budget. It is not a prediction of t_U ~ 10^{17} s. The large ratio tau_exhaust/t_U ~ 10^{93} simply means the entropy budget is far from exhausted.

- **Assumptions:** A1-A4, A8-A10
- **Model-dependent:** J (coupling), t_cycle (update period), Delta_S (entropy budget)
- **Would change by >10x:** Larger I(B;M) or faster update rate would decrease tau_exhaust, but the ratio tau_exhaust/t_U would remain >> 1 for any physically reasonable parameters.

---

## 6. Verification

**Task 2: Systematic verification of all quantitative predictions against known limits and prior phase equations. All 7 verification checks passed.**

### 6.1 Independent re-derivation of N_exhaust

Starting from scratch (independent of Section 1):

**Given:**
- Cost per cycle: W_1 >= T * I (Phase 25, Theorem (a))
- Available free energy: W_avail = T * (S_max - S) (Helmholtz free energy difference from equilibrium)
- Number of affordable cycles: N = W_avail / W_1

$$N = \frac{T(S_{\max} - S)}{T \cdot I} = \frac{S_{\max} - S}{I} = \frac{\Delta S}{I}$$

Matches Section 1.3. Confirmed.

### 6.2 Qubit case (d_B = d_M = 2)

**Parameters:** S_max = ln(d_B * d_M) = ln(4) = 2 ln 2 ~ 1.386 nats. S_B = ln(d_B) = ln 2 ~ 0.693 nats.

**Maximum I for a pure joint state:** I_max = S_B = ln 2 ~ 0.693.

**N_exhaust for one qubit self-modeler starting from a pure state (S_initial = 0):**
Delta_S = S_max - S_initial = 2 ln 2 - 0 = 2 ln 2 ~ 1.386.
N_exhaust = Delta_S / I = 2 ln 2 / ln 2 = 2 cycles.

**rho at peak:** rho_max = S_B/4 = ln(2)/4 ~ 0.173.

**Numerical check:** rho(I = S_B/2) = (ln 2/2)(1 - (ln 2/2)/ln 2) = (0.347)(1 - 0.5) = (0.347)(0.5) = 0.173. Matches.

All qubit values are finite, positive, and consistent with Phase 25 results.

### 6.3 Cosmological arithmetic verification

Step-by-step:
1. I ~ 10^{10} neurons * ln(2) nats/neuron ~ 10^{10} * 0.693 ~ 6.93 * 10^9 ~ 7 * 10^9. Correct.
2. N ~ 10 Hz * 4 * 10^{17} s = 4 * 10^{18}. Correct.
3. Delta_S_Landauer = N * I = 4 * 10^{18} * 7 * 10^9 = 28 * 10^{27} = 2.8 * 10^{28}. Correct.
4. Delta_S_Penrose = 10^{122} - 10^{88} ~ 10^{122}. Correct (10^{122} >> 10^{88}).
5. Ratio = 2.8 * 10^{28} / 10^{122} = 2.8 * 10^{-94}. Confirmed: ~94 orders of magnitude gap.

### 6.4 Penrose comparison factual accuracy

**Penrose (1979)** [ref-penrose1979]: Estimated S_initial ~ 10^{88} based on:
- The observable universe contains ~ 10^{80} baryons
- Current total entropy ~ 10^{88} (updated estimates give ~ 10^{88} - 10^{89} dominated by supermassive black holes)
- Maximum entropy (all matter in one black hole) ~ 10^{121} - 10^{123}

The number 10^{88} is Penrose's original estimate. More recent work (Egan & Lineweaver 2010) gives the current entropy of the observable universe as ~ 3.1 * 10^{104} k_B (mostly in supermassive black holes). Penrose's 10^{88} referred to the initial state, not the current state.

**Our comparison is accurate:** The Landauer bound (~10^{28}) is weaker than any reasonable estimate of S_initial (whether 10^{88} or lower). The qualitative conclusion is robust.

### 6.5 rho profile qualitative shape verification

For the passive equilibration model (Section 4.5) with constant S_B:

$$\rho(N) = I_0 e^{-\gamma N}\left(1 - \frac{I_0 e^{-\gamma N}}{S_B}\right)$$

where gamma = -ln(1-p) > 0. Define u(N) = I_0 e^{-gamma N} (the mutual information at step N).

$$\rho = u(1 - u/S_B)$$

d(rho)/dN = (du/dN)(1 - 2u/S_B) = -gamma u (1 - 2u/S_B)

Setting d(rho)/dN = 0: either u = 0 (trivial, N -> infinity) or u = S_B/2.

- If I_0 > S_B/2: u starts above S_B/2, so (1 - 2u/S_B) < 0, meaning d(rho)/dN = -gamma u * (negative) > 0 -- rho is increasing. It increases until u = S_B/2, then decreases. Single maximum confirmed.
- If I_0 < S_B/2: u starts below S_B/2, so (1 - 2u/S_B) > 0, meaning d(rho)/dN = -gamma u * (positive) < 0 -- rho is decreasing from the start. Monotone decrease. No peak.
- If I_0 = S_B/2: d(rho)/dN = 0 at N = 0. rho starts at maximum and decreases.

All cases end with rho -> 0 as N -> infinity (u -> 0). Confirmed.

### 6.6 Non-claim violation scan

Scanning the derivation text for violations:
- NC-1 (no prediction of S_initial): Section 2.6 explicitly states the Landauer bound is "NECESSARY but not SUFFICIENT." No specific S_initial is predicted. SATISFIED.
- NC-2 (rho profile not computed to precision): Section 4.6 states the qualitative shape depends on initial conditions, and the mapping to cosmological time is model-dependent. SATISFIED.
- NC-3 (not a derivation of 10^{88}): Section 2.6 explicitly states the comparison shows the Landauer bound is WEAKER than Penrose. No derivation of 10^{88} is attempted. SATISFIED.
- NC-4 (exhaustion timescale is not the age of the universe): Section 3.3 computes tau_exhaust ~ 10^{111} s and compares to t_U ~ 10^{17} s without equating them. SATISFIED.

No violations found.

### 6.7 SI units restoration for exhaustion timescale

With explicit k_B and hbar:

W_cycle >= k_B T * I(B;M) (energy units: Joules, T in Kelvin, I in nats)
W_available = k_B T * Delta_S (Joules)
N_exhaust = Delta_S / I(B;M) (dimensionless -- same as natural units, T and k_B cancel)

tau_exhaust = N_exhaust * t_cycle = (Delta_S / I) * t_cycle

**[Time]** = (nats / nats) * [time] = [time]. Dimensionally correct.

The equilibration timescale with hbar:
tau_eq = hbar^2 / (J^2 * t_step * k_B^0) -- wait, let me be careful.

In SI: H = J_coupling * F (J_coupling in Joules). U(t) = exp(-i H t / hbar). The depolarizing parameter is p = sin^2(J_coupling * t_step / hbar).

For weak coupling: p ~ (J_coupling * t_step / hbar)^2.

N_eq ~ 1/p = hbar^2 / (J_coupling^2 * t_step^2)

tau_eq = N_eq * t_step = hbar^2 / (J_coupling^2 * t_step)

**Dimensional check:** [hbar^2] = [J^2 s^2]. [J_coupling^2] = [J^2]. [t_step] = [s]. [hbar^2 / (J_coupling^2 * t_step)] = [s^2 / s] = [s]. Correct.

SI restoration successful. No hidden errors from natural units.

---

*Phase: 27-quantitative-predictions-conditional*
*Plan: 01*
*Completed: 2026-03-24*
