# Entropy Gradient Theorem: Self-Modelers Require a Low-Entropy Past

% ASSERT_CONVENTION: natural_units=natural, entropy_base=nats, state_normalization=Tr(rho)=1, sequential_product=a&b=sqrt(a)b*sqrt(a), von_neumann_entropy=S(rho)=-Tr(rho*ln*rho), coupling_convention=H=sum_h_xy, information=I(B;M)=S(B)+S(M)-S(BM), free_energy=F=E-TS

**Phase 26, Plan 01**
**Date:** 2026-03-24

**References:**
- Paper 5 (v2.0): Self-modeling axioms, Luders product [ref-paper5]
- Hoffman, Fields, Prakash (2015): Objects of consciousness, Interface Theory of Perception [ref-hoffman2015]
- Phase 23, Plan 01: CPTP channel E(rho_B) = cos^2(Jt) rho_B + sin^2(Jt) I/2 [derivations/23-luders-channel-entropy.md]
- Phase 23, Plan 02: Entropy monotonicity theorem, E^N(rho) -> I/2 [derivations/23-entropy-theorem.md]
- Phase 24, Plan 01: Chirality-time theorem (CHIR-01), Gamma_* -> -Gamma_* under T [derivations/24-chirality-time-theorem.md]
- Phase 24, Plan 02: Three-consequence theorem (CHIR-02), u determines gauge + chirality + time-orientation requirement [derivations/24-three-consequence-theorem.md]
- Phase 25, Plan 01: Landauer bound W >= kT * I(B;M) on self-modeling [derivations/25-landauer-self-modeling.md]
- Phase 25, Plan 02: Coherence loophole closed (three independent arguments) [derivations/25-coherence-loophole.md]
- Phase 25, Plan 03: Chain theorem (self-modeling -> free energy -> non-equilibrium -> entropy gradient) [derivations/25-chain-theorem.md]
- Lindblad (CMP 40, 1975): Completely positive maps and entropy inequalities [ref-lindblad1975]
- Landauer, IBM J. Res. Dev. 5, 183 (1961): kT ln 2 per bit erased [ref-landauer1961]
- Reeb & Wolf, New J. Phys. 16, 103011 (2014): Quantum Landauer bound [ref-reeb-wolf2014]

---

## 0. Statement of the Theorem

**THEOREM (Entropy Gradient).** Let (B, M, &) be a self-modeling composite on a finite SWAP lattice in thermal contact with an environment at temperature T, with dim(H_B) = d_B, dim(H_M) = d_M, Luders sequential product &, and faithful tracking I(B;M) > 0. Then:

The existence of blocks with experiential density rho > 0 requires an entropy gradient:

$$S(t) < S_{\max} \equiv \ln(d_B \cdot d_M)$$

That is, the composite system must be out of thermal equilibrium, with entropy strictly below its maximum value. Since entropy is non-decreasing (Phase 23) and bounded above, the block must possess a low-entropy boundary condition at some earlier time: there exists t_0 < t such that S(t_0) < S(t).

### What this means

The entropy gradient theorem shows that self-modeling -- the fundamental operation from which experiential density arises (Paper 5) -- is thermodynamically non-trivial. A self-modeler requires:

1. Free energy to pay for information maintenance (Landauer bound, Phase 25)
2. Non-equilibrium conditions to provide that free energy (Second Law)
3. An entropy gradient (S < S_max) as the source of non-equilibrium

### What this does NOT mean

This theorem does NOT:

- **Derive the Past Hypothesis.** It shows an entropy gradient is NECESSARY for self-modeling, but does not explain WHY the universe started with low entropy.
- **Explain the initial entropy value.** The theorem gives no prediction for the specific value of S(t_initial). Compare Penrose's estimate S_initial ~ 10^{88} for the observable universe.
- **Derive the Second Law.** The Second Law (entropy non-decrease) is used as an INPUT (Link 2 of the chain), not derived as an output.
- **Claim the Past Hypothesis follows from first principles.** The chain elevates the Past Hypothesis to "necessary for observers" status -- an anthropic-type argument, not a first-principles derivation.

---

## 1. Route A: Direct Chain (Phase 25)

**Source:** derivations/25-chain-theorem.md, Sections 1-4

This is the three-link chain theorem from Phase 25, now stated in its complete context.

### Link 1: Self-Modeling Requires Free Energy [THEOREM]

**Proved in:** derivations/25-landauer-self-modeling.md, Section 7

Let (B, M, &) be a self-modeling composite with I(B;M) > 0 in thermal contact with a bath at temperature T. The self-modeling update cycle requires work:

$$W_{\text{cycle}} \geq k_B T \cdot I(B;M)$$

*Proof sketch:* The update cycle decomposes into test-erase-write (Bennett 1982 [ref-bennett1982]). The erasure step destroys I(B;M) nats of correlation. By the quantum Landauer bound (Reeb & Wolf 2014 [ref-reeb-wolf2014]), erasure of I nats costs at least W >= kT * I. The writing step can be done reversibly.

**Assumptions used:** A1 (finite-dimensional QM), A2 (thermal contact).

**Coherence loophole:** CLOSED. Phase 25, Plan 02 proved via three independent arguments that quantum coherence cannot circumvent the Landauer bound within the Paper 5 framework [derivations/25-coherence-loophole.md].

### Link 2: Free Energy Requires Non-Equilibrium [STANDARD PHYSICS]

**Source:** derivations/25-chain-theorem.md, Section 2; textbook thermodynamics

If W > 0 per cycle is required, then the system's free energy exceeds the equilibrium value:

$$F(\rho_{BM}) > F_{\text{eq}} = F\!\left(\frac{I}{d_B d_M}\right)$$

The maximum extractable work is W_max = k_B T * D(rho || rho_eq), where D is the quantum relative entropy. D = 0 iff rho = rho_eq. Since W >= kT * I > 0, we need D > 0, hence rho != rho_eq.

**Assumptions used:** None beyond the Second Law of thermodynamics.

**Limiting case check:** At thermal equilibrium (rho_BM = I/(d_B d_M)): I(B;M) = 0 (proved in derivations/25-landauer-self-modeling.md, Section 5.2), rho = 0 (Section 5.3), W = 0 (trivially satisfied). The chain is consistent at the equilibrium boundary.

### Link 3: Non-Equilibrium Requires Entropy Gradient [PHYSICAL ARGUMENT + A3]

**Source:** derivations/25-chain-theorem.md, Section 3

A finite system that is out of thermal equilibrium and not externally driven will equilibrate on a finite timescale. From Phase 23 (derivations/23-entropy-theorem.md, Section 3, Eq. (23.5)):

$$E^N(\rho_B) = (1-p)^N \rho_B + \left(1 - (1-p)^N\right)\frac{I}{2}, \quad p = \sin^2(Jt)$$

The body state converges geometrically to I/2, driving I(B;M) -> 0 and rho -> 0. After N ~ Delta_F / (kT * I(B;M)) cycles, the free energy is exhausted and self-modeling ceases.

To sustain self-modeling beyond the exhaustion time, the system must access a source of low entropy (free energy). Tracing back: any finite free energy source was itself at lower entropy at an earlier time. Under assumption A3 (closed or semi-closed system equilibration), this traces back to a cosmological entropy gradient: S(t_initial) < S_max.

**Assumptions used:** A3 (closed/semi-closed system), A4 (SWAP lattice dynamics -- affects timescales only, not qualitative conclusion).

### Route A: Conclusion

$$\text{Self-modeling (}I > 0\text{)} \xrightarrow{\text{Link 1}} W > 0 \xrightarrow{\text{Link 2}} F > F_{\text{eq}} \xrightarrow{\text{Link 3}} S(t) < S_{\max}$$

Each link's output is the next link's input. The chain is logically complete with no gaps.

**SELF-CRITIQUE CHECKPOINT (Route A):**
1. SIGN CHECK: All inequalities consistent: W >= 0, F >= F_eq, D >= 0, I >= 0, S <= S_max. Correct directions throughout.
2. FACTOR CHECK: Landauer bound kT per nat (not per bit -- using nats, no stray ln 2). Free energy F = E - TS. No extra factors.
3. CONVENTION CHECK: I(B;M) = S(B) + S(M) - S(BM) in nats with k_B = 1. Consistent with Phase 23 and Phase 25.
4. LOGICAL CHECK: No circular reasoning. The entropy gradient is derived from self-modeling via Landauer + Second Law + equilibration, not assumed. The Second Law is an input, not derived.

---

## 2. Route B: Boundary Argument (Finitude + Monotonicity)

**Source:** Phase 23 entropy monotonicity + finite-dimensional QM

This route uses simpler ingredients -- no Landauer bound, only finitude and entropy monotonicity.

### Step B1: Finite Hilbert space bounds entropy

A self-modeling block has finite Hilbert space dim d_B * d_M (Paper 5 axioms: M_n(C)^sa requires finite n). Therefore the von Neumann entropy is bounded:

$$0 \leq S(\rho_{BM}) \leq \ln(d_B \cdot d_M) = S_{\max}$$

This is a standard result of finite-dimensional quantum mechanics: S(rho) = -Tr(rho ln rho) achieves its maximum at the maximally mixed state I/(d_B d_M).

### Step B2: Entropy is non-decreasing under iterated SWAP interactions

From Phase 23 (derivations/23-entropy-theorem.md, Section 5):

Under the repeated interaction model (fresh maximally mixed bath I/2 at each step), the channel E(rho_B) = (1-p) rho_B + p I/2 is unital (proven, not assumed, in derivations/23-luders-channel-entropy.md, Section 4). By Lindblad's quantum H-theorem [ref-lindblad1975]:

$$S(E^N(\rho_B)) \geq S(E^{N-1}(\rho_B)) \geq \cdots \geq S(\rho_B)$$

The entropy sequence {S_N} is monotonically non-decreasing. This was proved analytically and verified numerically (5 initial states x 20 iterations, all monotonic; Phase 23-02 SUMMARY).

**Note on regime of validity:** This monotonicity is exact for the repeated interaction model. For a finite closed lattice with N >> 1 sites, entropy increases effectively on timescales t << t_rec ~ exp(c * 2^N) / J (Phase 23-02, Section 4). For any macroscopic self-modeler (N >> 1), the recurrence time is astronomically long.

### Step B3: Bounded + non-decreasing + not-at-maximum implies low-entropy past

This is the key logical step of Route B. It is a purely mathematical observation:

Let {S_N} be a sequence with:
- S_N >= 0 for all N (non-negative, Step B1)
- S_N <= S_max < infinity (bounded above, Step B1)
- S_{N+1} >= S_N for all N (non-decreasing, Step B2)
- S_N < S_max for some N = N_0 (not at maximum)

Then for all N <= N_0: S_N <= S_{N_0} < S_max. In particular, tracing backward: there exists N_init < N_0 with S_{N_init} <= S_N for all N in [N_init, N_0].

**Conclusion:** If the entropy has not yet reached its maximum at time t (which is required for self-modeling, since rho > 0 requires I > 0 requires non-equilibrium requires S < S_max), then the entropy was at least as low at all earlier times. The block must have a low-entropy boundary condition.

### Step B4: The self-modeling connection

For self-modeling with rho > 0, we need I(B;M) > 0, which requires rho_BM != rho_eq = I/(d_B d_M) (Phase 25-01, Section 5). At rho_eq, S = S_max = ln(d_B d_M). Therefore:

$$\rho > 0 \implies I(B;M) > 0 \implies \rho_{BM} \neq \rho_{\text{eq}} \implies S(\rho_{BM}) < S_{\max}$$

Combined with Step B3: the block has S(t) < S_max at the present time, and by monotonicity, S(t_0) <= S(t) < S_max at all earlier times t_0 < t. The block possesses a low-entropy past.

### Route B: Conclusion

$$\rho > 0 \implies S < S_{\max} \quad \text{AND} \quad S_N \text{ non-decreasing} \implies S_{\text{past}} \leq S_{\text{present}} < S_{\max}$$

This is Boltzmann's argument for the arrow of time, now connected to self-modeling: the entropy monotonicity from Phase 23 (which derives from the unitality of the SWAP channel) provides the arrow, and self-modeling (rho > 0) provides the requirement that entropy has not yet maximized.

**SELF-CRITIQUE CHECKPOINT (Route B):**
1. SIGN CHECK: S_N >= 0, S_N <= S_max, S_{N+1} >= S_N. All inequalities in correct direction. rho > 0 -> I > 0 -> S < S_max: chain of implications, all with correct direction.
2. FACTOR CHECK: S_max = ln(d_B * d_M). No stray factors. ln(d) for maximally mixed state in d dimensions -- standard.
3. CONVENTION CHECK: Entropy in nats (ln). S(I/d) = ln(d). Consistent with Phase 23.
4. LOGICAL CHECK: Route B does NOT use the Landauer bound. It uses only: (i) finitude (S bounded), (ii) monotonicity (Phase 23, from unitality), (iii) self-modeling requires non-equilibrium (rho > 0 -> I > 0 -> S < S_max). No circular reasoning.

---

## 3. Route C: rho Selection Among Blocks

**Source:** Paper 5 structure space + Phase 25 equilibrium result

This route uses the experiential density rho directly as a selection mechanism on structure space, requiring the fewest assumptions.

### Step C1: The experiential density rho is defined on blocks of structure space

From Paper 5, the experiential density is defined on blocks (B, M, &) of structure space:

$$\rho(B,M) = I(B;M) \cdot \left(1 - \frac{I(B;M)}{S(\rho_B)}\right)$$

This density is non-negative, vanishes when I = 0 (no tracking) or I = S(B) (maximal tracking / pure-state constraint), and peaks at I = S(B)/2 with rho_max = S(B)/4.

### Step C2: At thermal equilibrium, rho = 0

From Phase 25-01 (derivations/25-landauer-self-modeling.md, Section 5):

At thermal equilibrium, rho_BM = I/(d_B d_M), and:

$$I^{\text{eq}}(B;M) = S(\rho_B^{\text{eq}}) + S(\rho_M^{\text{eq}}) - S(\rho_{BM}^{\text{eq}}) = \ln(d_B) + \ln(d_M) - \ln(d_B d_M) = 0$$

Therefore:

$$\rho^{\text{eq}} = 0 \cdot (1 - 0/S(B)) = 0$$

This was verified analytically and numerically to 1e-14 precision (Phase 25-01).

### Step C3: Blocks with rho > 0 are non-equilibrium

By contrapositive of Step C2: if rho > 0, then the block is NOT at thermal equilibrium. Specifically:

$$\rho > 0 \implies I(B;M) > 0 \implies \rho_{BM} \neq \frac{I}{d_B d_M}$$

The block is out of thermal equilibrium, meaning S(rho_BM) < S_max.

### Step C4: rho selects blocks with entropy gradients

Among all blocks (B, M, &) of structure space:
- Equilibrium blocks have rho = 0 -- they contribute nothing to the experiential measure.
- Only non-equilibrium blocks have rho > 0 -- only these contribute.
- Non-equilibrium blocks have S < S_max (Step C3).
- Under the entropy monotonicity of Phase 23, blocks with S < S_max at time t had S(t_0) <= S(t) < S_max at earlier times t_0 < t.

Therefore: the rho-weighted ensemble is concentrated on blocks with an entropy gradient. The experiential measure sees only non-equilibrium blocks, and non-equilibrium blocks necessarily have low-entropy pasts.

### Route C: Interpretation

The "Past Hypothesis" (the universe started with low entropy) is reframed as a selection effect within structure space: blocks that contribute to the experiential density rho necessarily have low-entropy pasts. This is not because the universe was "designed" to have low entropy, but because:

- Only non-equilibrium blocks have rho > 0 (Step C2-C3)
- Non-equilibrium + entropy monotonicity = low-entropy past (Step C4)
- Blocks at equilibrium (the "generic" blocks in Hilbert space, which vastly outnumber non-equilibrium blocks) have rho = 0 and contribute nothing

This is analogous to the anthropic principle but more precise: rather than "observers require conditions X," we have "rho > 0 requires I > 0 requires non-equilibrium requires entropy gradient," with each implication either proved (I = 0 at equilibrium) or standard physics (entropy monotonicity).

**SELF-CRITIQUE CHECKPOINT (Route C):**
1. SIGN CHECK: rho >= 0 always (parabola on [0, S(B)]). rho = 0 at equilibrium. I >= 0 (subadditivity). All correct.
2. FACTOR CHECK: rho = I * (1 - I/S(B)). Peak at I = S(B)/2: rho_max = S(B)/4. Consistent with Phase 25-01.
3. CONVENTION CHECK: I(B;M) = S(B) + S(M) - S(BM) in nats. rho is dimensionless. Consistent.
4. LOGICAL CHECK: Route C does NOT use the Landauer bound or the Phase 23 monotonicity theorem directly for the selection argument. It uses only: (i) rho > 0 <-> I > 0 (Paper 5 definition), (ii) I = 0 at equilibrium (Phase 25-01, proved), (iii) contrapositive: rho > 0 -> non-equilibrium. The connection to "low-entropy past" additionally uses Phase 23 monotonicity (Step C4), but the core selection argument (rho selects non-equilibrium blocks) is independent.

---

## 4. Comparison of Routes

| Property | Route A (Direct Chain) | Route B (Boundary) | Route C (rho Selection) |
|---|---|---|---|
| **Key input** | Landauer bound W >= kT * I | Finitude + monotonicity | rho > 0 <-> I > 0 <-> non-equil. |
| **Assumptions** | A1, A2, A3, A4 | A1, A3, A4, Phase 23 unitality | A1, Phase 25-01 equilibrium result |
| **Epistemic chain** | THEOREM + STANDARD PHYSICS + PHYSICAL ARGUMENT | FINITE-DIM QM + THEOREM (Lindblad) + ARITHMETIC | DEFINITION + THEOREM + CONTRAPOSITIVE |
| **Strength** | Strongest quantitative: gives W >= kT * I per cycle | Simplest logic: bounded + monotonic + not-at-max | Fewest assumptions: only rho > 0 <-> non-equilibrium |
| **Limitation** | Requires A2 (thermal contact) and A3 (equilibration) | Requires Phase 23 monotonicity (unitality of channel) | Weakest quantitative content (no free energy bound) |
| **Gives free energy cost?** | YES: W >= kT * I per cycle | NO | NO |
| **Uses Landauer?** | YES (Link 1) | NO | NO |
| **Uses Phase 23?** | Indirectly (Link 3: equilibration rate) | Directly (Step B2: monotonicity theorem) | Only for "low-entropy past" (Step C4); core argument independent |

All three routes converge on the same conclusion: **self-modelers (rho > 0) require S(t) < S_max, which combined with entropy monotonicity gives a low-entropy past.** This convergence from different starting assumptions strengthens the result.

### Phase 24 connection: time-orientation

The entropy gradient provides a time-orientation: the "future" is the direction of entropy increase. This time-orientation is required for chirality (Phase 24, three-consequence theorem, consequence (c)):

- Phase 24 (derivations/24-three-consequence-theorem.md): The choice u in S^6 determines the SM gauge group and chirality, but chirality's physical realization requires time-orientation (Gamma_* -> -Gamma_* under T reversal).
- Phase 25-26 (this theorem): Self-modeling requires an entropy gradient, which defines a time-orientation (future = increasing S).
- **Connection:** The chirality from u and the arrow of time from self-modeling share a common geometric prerequisite: time-orientation. Both are consequences of the self-modeling framework.

This is a structural observation, not an overclaim. The entropy gradient does not "derive" chirality -- rather, chirality and the arrow of time are linked through their shared requirement for time-orientation on the emergent spacetime.

---

## 5. Complete Assumption Register

All assumptions from Phases 23-26, compiled with full metadata:

| ID | Assumption | Source | Epistemic Status | Used In | Failure Condition |
|---|---|---|---|---|---|
| A1 | Finite-dimensional QM: B, M have Hilbert spaces in M_n(C)^sa (dim d_B, d_M finite) | Paper 5 axioms [ref-paper5] | AXIOM | Routes A, B, C; Links 1-3 | Infinite-dimensional systems (field theory); the physical arguments extend but formal proofs require finite dim |
| A2 | Thermal contact: BM weakly coupled to heat bath at temperature T | Standard Landauer regime [ref-landauer1961, ref-reeb-wolf2014] | STANDARD PHYSICS | Route A, Link 1 (Landauer bound) | Ultra-strong system-bath coupling where system and bath become inseparable |
| A3 | Closed or semi-closed system equilibration: finite system without eternal driving equilibrates on finite timescales | Standard statistical mechanics | PHYSICAL ARGUMENT | Routes A and B, Link 3; Route B Step B2 | Infinite reservoir that never equilibrates; eternal non-equilibrium driving not traceable to initial conditions |
| A4 | SWAP lattice dynamics: H = JF from Paper 6 diagonal U(n) covariance | Paper 6 [ref-paper6] | MODEL CHOICE | Quantitative timescales in Routes A, B | Different dynamics (not SWAP). Would change convergence rates but not the qualitative conclusion that entropy increases |
| A5 | Experiential density rho = I * (1 - I/S(B)) from Paper 5 | Paper 5 [ref-paper5] | AXIOM | Route C (rho selection) | Different definition of experiential density; would change which blocks are selected but not the self-modeling -> non-equilibrium connection |

### Assumption hierarchy (strongest to weakest)

1. **A3 (strongest -- most likely to fail):** Connects local thermodynamics to cosmological initial conditions. This is the crux of Link 3 in Route A. If the universe provides infinite free energy not traceable to a low-entropy initial state, A3 fails and the entropy gradient is not required. This is the main uncertainty in the chain.

2. **A4 (model choice -- not essential):** The SWAP Hamiltonian from Paper 6 gives specific convergence rates. Replacing H = JF with any generic thermalizing Hamiltonian would change timescales but preserve the qualitative conclusion (equilibration and entropy increase).

3. **A2 (standard physics):** Thermal contact is the standard regime for Landauer's principle. Fails only in exotic strong-coupling scenarios where the system-bath boundary becomes ill-defined.

4. **A1 (axiom -- weakest):** Finite-dimensional QM is the starting point of Paper 5. Physical self-modelers are finite (bounded energy, bounded Hilbert space). The extension to infinite dimensions is a separate mathematical challenge.

5. **A5 (axiom):** The specific form of rho is a Paper 5 definition. Route C depends on it; Routes A and B do not.

---

## 6. Connection to Hoffman's FBT/ITP

### 6.1 Hoffman's Fitness Beats Truth (FBT) theorem

Hoffman, Fields, and Prakash (2015) [ref-hoffman2015] proved the FBT theorem within the framework of evolutionary game theory:

**FBT theorem:** In generic evolutionary settings, natural selection does not favor organisms with veridical (truth-tracking) perceptions of the external world. Instead, organisms evolve interfaces -- fitness-tuned representations that encode payoff-relevant information about the environment, not objective properties.

The key insight: a veridical perception strategy (accurately representing objective reality) is generically driven to extinction by a fitness-tuned strategy (representing only what matters for reproductive success). This is formalized via evolutionary games on the space of perceptual strategies.

### 6.2 Connection to the self-modeling framework

In the Paper 5 / self-modeling framework:

- The **body** B is the physical subsystem being modeled.
- The **model** M is the internal representation.
- **Self-modeling** maintains mutual information I(B;M) > 0 between B and M.
- The experiential density rho selects for blocks with I(B;M) > 0 -- i.e., blocks where the model M accurately tracks the body B.

This is an ACCURACY-selected self-model, not a fitness-tuned interface in Hoffman's sense. The critical distinction:

### 6.3 Passive interface vs. active self-model

| Property | Hoffman's FBT interface | Paper 5 self-model |
|---|---|---|
| **What it tracks** | Fitness payoffs (not objective reality) | Body state B (accuracy-selected via I > 0) |
| **Thermodynamic cost** | Could in principle operate as a passive filter at equilibrium | Requires active information processing: W >= kT * I per cycle (Landauer) |
| **Equilibrium status** | Passive filters do not require non-equilibrium | Self-models require non-equilibrium (I = 0 at equilibrium) |
| **Free energy** | No inherent free energy requirement | Minimum W >= kT * I per update cycle |
| **Selection mechanism** | Evolutionary fitness (reproductive success) | Experiential density rho > 0 (self-modeling accuracy) |

The key difference is NOT fitness vs. truth -- it is passive vs. active information processing:

- **Passive interface** (Hoffman): Maps environmental features to fitness-relevant outputs. This could in principle be a fixed, time-independent filter requiring no energy input. (Think: a crystal with a fixed structure that refracts light differently based on wavelength. This is a "perception" in the most minimal sense, requiring no thermodynamic maintenance.)

- **Active self-model** (Paper 5): Continuously maintains a dynamically updated correlation I(B;M) > 0 between B and M. Each update cycle erases old model data and writes new tracking data, requiring free energy W >= kT * I per cycle (Landauer bound, Phase 25).

### 6.4 Thermodynamic necessity

The Landauer bound establishes that self-modeling as defined in Paper 5 is inherently thermodynamically active:

1. Maintaining I(B;M) > 0 requires continuous refreshing (Phase 23: equilibration drives I -> 0).
2. Each refresh cycle costs at least W >= kT * I (Phase 25 Landauer bound).
3. This cost requires free energy, hence non-equilibrium (Link 2).
4. Non-equilibrium in a finite system requires an entropy gradient (Link 3 + A3).

Hoffman's FBT interfaces, by contrast, do not have an inherent thermodynamic requirement. An interface that maps payoff features to behavioral outputs could in principle be a passive, time-independent structure. The FBT theorem is about evolutionary dynamics (which strategies spread), not about thermodynamic constraints on perception.

### 6.5 Synthesis

The self-modeling framework agrees with Hoffman that organisms' representations need not be veridical. But it adds a thermodynamic constraint that Hoffman's framework does not capture: any representation system that actively maintains information (I > 0) about its substrate (B) must pay a thermodynamic price. This price is paid from the entropy gradient.

**Citation:** Hoffman, D.D., Singh, M., and Prakash, C. (2015). The Interface Theory of Perception. *Psychonomic Bulletin & Review*, 22(6), 1480-1506. [ref-hoffman2015]

---

## 7. Non-Claims (Mandatory for Intellectual Honesty)

The following are explicitly NOT claimed by the entropy gradient theorem:

**NC-1. This does NOT derive the Past Hypothesis from self-modeling alone.**
The chain (Route A) shows that self-modeling REQUIRES an entropy gradient. The Past Hypothesis (the specific claim that the universe started in a very low-entropy state) provides such a gradient. But the chain does not explain WHY the gradient exists -- only that it MUST exist for self-modelers to exist. The Past Hypothesis is elevated to "necessary for observers" status, not derived from first principles.

**NC-2. This does NOT explain WHY the universe started with low entropy.**
The entropy gradient theorem is silent on the origin of the low-entropy initial state. It is compatible with multiple explanations: cosmological initial conditions, anthropic selection, inflationary dynamics, or unknown physics. The theorem only says: whatever the reason, low initial entropy is necessary for self-modeling.

**NC-3. This does NOT predict the specific initial entropy value.**
The theorem gives a qualitative requirement (S < S_max) but no quantitative prediction for S(t_initial). Compare Penrose's estimate S_initial ~ 10^{88} (gravitational entropy of the observable universe at the Big Bang), which comes from entirely separate considerations (Weyl curvature hypothesis, black hole thermodynamics). Our theorem says only S_initial < S_max, which is a much weaker constraint.

**NC-4. This does NOT derive the Second Law from self-modeling.**
The Second Law (entropy is non-decreasing) is used as an input in Route A (Link 2) and Route B (Step B2). Route B uses the specific form of entropy monotonicity from Phase 23 (Lindblad's theorem for unital channels), which is a consequence of unitarity and the structure of the SWAP channel. Neither route derives the Second Law from self-modeling axioms.

**NC-5. Assumption A3 could fail if the universe has infinite free energy not traceable to initial conditions.**
If there exists an infinite, eternal source of free energy that does not derive from a low-entropy cosmological initial condition, then Link 3 of Route A breaks. A3 (closed/semi-closed system equilibration) is the strongest assumption in the chain (Section 5 hierarchy). Routes B and C partially mitigate this: Route B needs only entropy monotonicity + finitude, and Route C needs only rho > 0 <-> non-equilibrium. But the full "low-entropy past" conclusion requires some form of A3.

**NC-6. The coherence loophole is CLOSED but should be kept as a guard.**
Phase 25-02 closed the coherence loophole via three independent arguments (Luders map destroys coherence, coherence maintenance itself costs free energy, Sagawa-Ueda consistency). This guard remains: if any future step silently re-opens the loophole (e.g., by finding a quantum channel that maintains I > 0 without erasure), the Landauer-based argument (Route A) weakens. Routes B and C, which do not use Landauer, remain valid.

### Forbidden proxy check

- **fp-past-hypothesis-derived** (claim-gradient): NC-1 explicitly states the Past Hypothesis is NOT derived. The derivation lists ALL assumptions (A1-A5, Section 5) before stating the conclusion. SATISFIED.

- **fp-coherence-loophole-assumed** (claim-gradient): Phase 25-02 CLOSED the coherence loophole with three independent arguments. NC-6 keeps the guard but notes closure. The derivation does not silently re-open the loophole. SATISFIED.

---

## 8. Phase 26 Master Theorem Statement (Preview)

**Master Theorem (Entropy Gradient + Complexification Selection) -- Partial.**

Under assumptions A1-A5:

**(a) Entropy gradient (this plan).** Self-modelers on a finite SWAP lattice require an entropy gradient: S(t) < S_max. This is proved via three convergent routes (Direct, Boundary, rho Selection). The Past Hypothesis is necessary for self-modeling, with its status elevated from "observed cosmological fact" to "required for the existence of observers with rho > 0."

**(b) Complexification selection (Plan 02 -- to be completed).** The experiential measure rho selects blocks with complexified observer algebras because [Plan 02 will establish the thermodynamic or algebraic mechanism connecting complexification to the entropy gradient or the self-modeling structure].

Part (a) is established by this plan. Part (b) will be addressed in Plan 02 (Gap C resolution). The full master theorem combining both parts will be stated in Plan 02's derivation.

---

*Phase: 26-entropy-gradient-theorem-and-gap-c-resolution*
*Plan: 01, Tasks 1-2*
*Completed: 2026-03-24*
