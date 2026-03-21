# Epistemic Poker: Deep Design

## Motivation

Phases 1-2 showed that poker is too simple to constrain 256x256 weight
algebra. MNIST constrains it (dep 1.0 -> 0.25) because rich supervised
gradients force compression. Poker's REINFORCE signal is too noisy/sparse.

We need a task where:
1. The gradient signal is RICH (like MNIST, not like poker)
2. Competition is REAL (both agents adapt, arms race)
3. Self-modeling is NECESSARY (not cosmetic)
4. The task is SYNTHETIC (harness generates and verifies)
5. Small NNs (256 hidden) can handle it

Epistemic Poker fuses progressive structure revelation (20 Questions)
with competitive betting (poker). The hidden structure provides rich
gradient signal. The betting provides competition. Self-modeling tracks
the agent's own epistemic state for bet sizing.

---

## The Game

### Hidden Structure

Each episode, the harness generates a random 8x8 matrix A. This is the
hidden "truth" that both agents try to recover.

Why 8x8:
- 64 unknowns = rich enough for algebraic structure
- K=8 rounds of 8-dim observations transitions from underdetermined
  (8 equations, 64 unknowns) to fully determined (64 equations)
- The belief space contracts across rounds = sequential measurement
- Small enough for 256-unit networks to represent
- The recovery problem IS algebraic (linear algebra over R^{8x8})

### Episode Structure

1. Harness generates:
   - Random A ~ N(0, 1/8) entry-wise (8x8 matrix)
   - Test point x* ~ N(0, 1) (8-dim vector)
   - K=8 probe points x_1, ..., x_8 ~ N(0, 1) (8-dim each)
   - Ground truth: y* = Ax*

2. For round r = 1, ..., K:
   a. Harness reveals data point (x_r, y_r = Ax_r) to both agents
   b. Each agent observes:
      - All revealed data so far: (x_1,y_1), ..., (x_r,y_r)
      - The test point x*
      - Own bet history: b_1^self, ..., b_{r-1}^self
      - Opponent bet history: b_1^opp, ..., b_{r-1}^opp
      - Current pot
      - Round number (one-hot)
   c. Each agent outputs:
      - Prediction p_r (8-dim vector: predicted y* = Ax*)
      - Bet size b_r (categorical: {0, 1, 2, ..., 10})
   d. Bets go into the pot

3. Settlement (after round K):
   - Error_A = ||p_K^A - y*||^2
   - Error_B = ||p_K^B - y*||^2
   - Winner = lower error
   - Winner gains loser's total bets; loser loses their total bets
   - Zero-sum: reward_A = -reward_B

### Why This Works

**Rich gradient signal:** Each revealed (x_r, y_r) pair provides 8
dimensions of constraint on A. The prediction loss (MSE on y*) gives
dense, informative gradients through the network - much richer than
poker's scalar REINFORCE reward. The network must learn to solve
linear systems internally.

**Competition is real:** Both agents see the same data, compete on the
same prediction. Better internal algebra for representing/updating
beliefs about A -> better predictions -> more wins. Unlike poker
where a simple policy suffices, here the internal REPRESENTATION
quality determines performance.

**Self-modeling is necessary:** The bet sizing requires the agent to
estimate its own confidence. After round 3 (underdetermined), the
agent shouldn't bet big. After round 8 (overdetermined), it should.
The self-prediction head tracks whether H2 has "changed a lot" (new
information integrated) or "stabilized" (convergence). This IS an
estimate of epistemic state.

**Opponent bets as information:** If the opponent bets big on round 5,
they think they've cracked A. This is a signal. But they could be
bluffing (miscalibrated self-model). The agent must model the
opponent's epistemic state through their bet trajectory.

---

## Observation Space

At round r, each agent observes a flat vector:

| Component | Dims | Description |
|-----------|------|-------------|
| Revealed inputs x_1..x_r | K * 8 = 64 | Zero-padded for future rounds |
| Revealed outputs y_1..y_r | K * 8 = 64 | Zero-padded for future rounds |
| Round mask | K = 8 | Binary: which rounds have been revealed |
| Test point x* | 8 | Fixed for the episode |
| Own bet history | K = 8 | Zero for future rounds |
| Opponent bet history | K = 8 | Zero for future rounds |
| Pot | 1 | Cumulative |
| Round one-hot | K = 8 | Current round |
| **Total** | **169** | |

This is comparable to MNIST's 784 dims - rich enough to force
structural compression in 256-unit hidden layers.

---

## Network Architecture

Same backbone as all previous phases (critical for comparability):

```
Input (169)
  |
  v
Linear(169, 256) -> ReLU -> [H1]
  |
  v
Linear(256, 256) -> ReLU -> [H2]
  |                           |
  v                    SP_encode(256, 64) -> ReLU
Linear(256, 256) -> ReLU -> [H3]          |
  |                        SP_decode(64, 256) -> [H2_pred]
  v
Prediction head: Linear(256, 8) -> [predicted y*]
Bet head: Linear(256, 11) -> Softmax -> [bet logits]
```

Two output heads from H3:
- **Prediction head:** 8-dim continuous output (predicted Ax*)
- **Bet head:** 11 logits for bet size (categorical, like poker)

The self-prediction path is identical to all previous phases.
Same 3 square weight matrices (h2.weight, h3.weight, sp_composed)
for algebra measurement.

---

## Training

### Loss Function

```
L = w_pred * MSE(prediction, y*)
  + w_game * policy_gradient_loss(bets, rewards)
  + w_self * MSE(h2_pred, h2_target)
  - entropy_coeff * bet_entropy
```

Four components:
1. **Prediction loss (MSE):** Direct supervised signal on Ax*.
   This is the RICH gradient that poker lacked. Available because
   the harness knows A and can compute y*.
2. **Betting loss (REINFORCE):** Policy gradient on bet sizing.
   Reward = betting winnings (zero-sum vs opponent).
3. **Self-prediction loss:** Same as all previous phases.
4. **Entropy bonus:** Prevents bet policy collapse (lesson from Phase 2).

### Key Design Choice: When Is Prediction Evaluated?

Option A: Evaluate prediction EVERY round. Each round, both agents
predict y* and the loss is computed against the true y*. This gives
dense supervised signal at every step.

Option B: Evaluate prediction ONLY at the final round. The agent
predicts y* at each round but only the final prediction is scored.
This is more poker-like (delayed reward) but gives sparser gradient.

**Recommendation: Option A.** The whole point is to provide rich
gradient signal. Each round's prediction loss teaches the network to
integrate new data points into its running estimate of A. The bet is
still only settled at the end (competition is on final accuracy), but
the prediction loss at each round provides immediate supervision.

This means the prediction component is essentially supervised learning
(MSE against known target), while the betting component is RL. The
self-prediction head bridges both: it helps the supervised component
(by tracking internal state) AND the RL component (by estimating
confidence for bet sizing).

### Hyperparameters

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| K (rounds) | 8 | Matches hidden matrix dimension |
| Matrix dim | 8x8 | 64 unknowns, recoverable in 8 rounds |
| Hidden dim | 256 | Same as all previous phases |
| Bottleneck | 64 | Same as all previous phases |
| w_pred | 1.0 | Primary learning signal |
| w_game | 0.1 | Betting is secondary to prediction |
| w_self | sweep {0, 1, 10} | Independent variable |
| entropy_coeff | 0.5 | Learned from Phase 2 fix |
| lr | 3e-4 | Same as Phase 2 |
| batch_size | 256 | Same as Phase 2 |
| n_episodes | 10000 | Same as Phase 2 |
| measure_every | 500 | Same as Phase 2 |

### Training Loop

```
for episode in 1..N_EPISODES:
    # Generate hidden structure
    A = random 8x8 matrix
    x_star = random 8-dim vector
    y_star = A @ x_star
    probes = [random 8-dim vector for _ in range(K)]

    # Play K rounds
    for r in 1..K:
        reveal (probes[r], A @ probes[r]) to both agents
        agent_A outputs (pred_A, bet_A, h2_pred_A, h2_target_A)
        agent_B outputs (pred_B, bet_B, h2_pred_B, h2_target_B)

    # Compute losses
    pred_loss = MSE(final_pred, y_star)  # or sum over rounds
    bet_reward = settlement(bets_A, bets_B, final_errors)
    self_loss = MSE(h2_pred, h2_target)

    # Update both agents
```

---

## What We Expect

### vs Phase 1b (MNIST)

MNIST gives dep_ratio=0.25 at w_self=0 because the network must
compress 784 -> 10. Epistemic Poker gives the network 169 inputs
and requires it to internally represent an 8x8 matrix recovery problem.
The prediction loss should force similar compression of the 256x256
weight matrices.

**Prediction:** dep_ratio should drop well below 1.0 for w_self=0
(prediction-only, no self-modeling). If it stays at ~1.0, the task
isn't constraining the weights and we need a harder function class.

### vs Phase 2 (poker)

Phase 2 gave dep_ratio=0.99 because poker provides negligible gradient
signal. Epistemic Poker's MSE prediction loss provides MUCH richer
gradients. We should see dramatically more algebraic structure.

### The w_self sweep

The key experiment: does self-prediction (w_self > 0) change the
algebraic structure DIFFERENTLY in Epistemic Poker vs MNIST?

In MNIST: self-prediction RESISTED task-driven compression (dep went UP
with w_self). The self-prediction objective needed more degrees of
freedom.

In Epistemic Poker: self-prediction tracks EPISTEMIC STATE (what the
agent knows about A). This is a fundamentally different self-modeling
task than tracking hidden activations of a classifier. The self-model
is tracking a BELIEF SPACE, not a feature space.

**Prediction:** If self-modeling drives toward algebraic structure,
we'd see dep_ratio DECREASE with w_self (more constraints, not fewer).
If we see the same pattern as MNIST (dep INCREASES with w_self), then
self-prediction universally resists compression regardless of task,
and the "self-modeling forces algebraic structure" hypothesis takes
another hit.

---

## Function Class Ladder

The matrix recovery task is Level 1. If it works (shows algebraic
signal), we can ramp up:

### Level 1: Linear (A is a random 8x8 matrix)
- y = Ax, fully recoverable in 8 rounds
- Algebraically clean: the optimal internal representation IS matrix algebra
- Expected: strong dep_ratio signal, clear comparison to MNIST

### Level 2: Noisy Linear (y = Ax + epsilon)
- epsilon ~ N(0, sigma) adds noise
- Agent must now estimate A despite noise = implicit regularization
- Self-modeling helps: "is my estimate converging?"
- Expected: slightly weaker signal, but self-modeling becomes more useful

### Level 3: Nonlinear (y = g(Ax) for known nonlinearity g)
- g could be ReLU, tanh, polynomial
- Recovery is harder (nonlinear inverse problem)
- Agent must develop nonlinear algebra internally
- Expected: different algebraic structure than linear case

### Level 4: Compositional (y = B * g(Ax) for random A, B)
- Two hidden matrices, composed through a nonlinearity
- This is literally a randomly-generated neural network
- The agent is learning to identify a random NN from input-output pairs
- Computationally irreducible for complex compositions
- Expected: rich algebraic constraints if anything will produce them

### Level 5: Cellular Automaton Rules
- Hidden state is a CA rule (256 possible elementary rules)
- Each round reveals another timestep of evolution
- Agent must identify the rule from trajectory observations
- Computationally irreducible (Wolfram's thesis)
- Expected: qualitatively different algebraic structure

---

## Implementation Plan

### New Files

1. **epistemic_poker.py** - The game environment
   - `EpistemicPoker` class with `reset()`, `step()`, `get_rewards()`
   - Batched tensor execution (like ContinuousPoker)
   - Function class as pluggable parameter

2. **train_2b.py** - The training script
   - Two EpistemicPokerNetwork agents
   - Combined supervised + RL + self-prediction loss
   - Same measurement infrastructure as train_2.py
   - Same logging/timing improvements

### Modified Files

3. **models.py** - Add `EpistemicPokerNetwork`
   - Same backbone (3x256 hidden layers + SP bottleneck)
   - Two output heads: prediction (8-dim) + bet (11 logits)
   - `act()` returns (prediction, bet_action, log_prob, h2_pred, h2_target, entropy)

4. **plot.py** - Add epistemic poker comparison plots

### Reused Files (no changes)

5. **metrics.py** - Unchanged (same algebraic measurements)

### Run Matrix

- w_self: {0.0, 1.0, 10.0}
- seeds: {0, 1, 2}
- 9 experiments total (same as Phase 2)
- Results in results/2b/

---

## Key Risks

1. **The prediction loss dominates.** If w_pred >> w_game, the betting
   becomes irrelevant and this is just supervised learning with a
   self-prediction head. Mitigation: tune w_pred vs w_game to keep
   betting meaningful.

2. **Linear recovery is too easy.** A 256-unit network might solve 8x8
   linear systems trivially without developing interesting algebra.
   Mitigation: if dep_ratio drops but shows no w_self dependence,
   ramp to Level 2-3.

3. **Same result as MNIST.** Self-prediction resists compression again.
   This would confirm that dep_ratio measures compression resistance,
   not algebraic structure. Mitigation: this is still a finding
   (confirms the Phase 1b pattern generalizes). But it means we need
   Vanchurin extraction, not weight algebra.

4. **Observation space too large for meta-learning.** The network sees
   all K rounds at once (169 dims). It might not learn to USE the
   progressive structure and instead just do "batch" prediction.
   Mitigation: compare progressive (see one round at a time) vs batch
   (see all rounds at once) to verify the sequential structure matters.

---

## Comparison to All Previous Phases

| Phase | Task | Gradient Signal | Competition | Self-Model Use | dep_ratio |
|-------|------|-----------------|-------------|----------------|-----------|
| 1a | Random init | None | None | N/A | 1.00 |
| 1b | MNIST | Rich supervised | None | Activation tracking | 0.25 |
| 1c | Poker frozen | Sparse RL | Frozen | Activation tracking | 0.99 |
| 2 | Poker competitive | Sparse RL | Real | Activation tracking | 0.99 |
| **2b** | **Epistemic Poker** | **Rich supervised + RL** | **Real** | **Epistemic state** | **???** |

Phase 2b is the first experiment with BOTH rich gradients AND real
competition AND meaningful self-modeling. All previous phases had at
most one of these three.
