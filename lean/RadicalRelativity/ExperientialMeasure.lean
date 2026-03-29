/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic.Linarith

set_option linter.style.longLine false

/-!
# Experiential Measure (Papers 1-4)

Papers 1-4 of the Radical Relativity program establish the experiential measure
framework: the density functional rho on self-modeling composite Markov processes,
its analytical properties, and the negative result that Born rule selection is
NOT a consequence of rho.

## Paper 1: Experiential Measure on Structure Space

Defines the structure space S of composite Markov processes (B, M) identified up
to product-preserving isomorphism. The experiential density

    rho(p) = I(B; M) * (1 - I(B; M) / H(B))

peaks at intermediate self-modeling fidelity and vanishes at both extremes.
States Theorem A (BB negligibility via metastability theory).

## Paper 2: Theorem A Proof (7-Lemma Composition)

Self-contained proof assembling 7 lemmas from metastability theory:
  1. Basin partition (Freidlin-Wentzell cycle hierarchy)
  2. Residence time lower bound (BEGK potential theory)
  3. QSD convergence (Champagnat-Villemonais)
  4. Stable measure lower bound (combines 2 + 3)
  5. BB occupation time upper bound (renewal theory)
  6. Concentration (Donsker-Varadhan large deviations)
  7. Ratio assembly (combines 4 + 5 + 6)

Result: mu_BB / mu_stable <= C * exp(-(Delta_s - Delta_b - alpha) / eps) -> 0.

## Paper 3: Lipschitz Stability

The experiential density rho is Lipschitz continuous under kernel perturbations:
|rho(P) - rho(P')| <= L * ||P - P'||_inf, where L depends on the spectral gap,
state-space size, and the Cho-Meyer perturbation bound.

## Paper 4: Born-Fisher Negative Result

The Born-Fisher-Experiential conjecture (that rho selects Born rule probabilities)
is FALSIFIED. The Born rule is forced by algebra (Gleason's theorem on the
C*-algebra that self-modeling produces), not by information-theoretic optimization
of rho. This negative result is reframed by Paper 5 as confirmation: rho selects
self-modelers, algebra does the rest.

## What is proved vs axiomatized vs sorry

- Definitions are concrete where possible (shannonEntropy, experientialDensity,
  mutualInfo, bodyEntropy, QuantumExperientialDensity).
- Definitions that require measure theory or spectral theory beyond what we
  formalize here use `sorry` (stationaryDist, spectralGap, kernelDiffNorm,
  experientialFunctional, stationaryL1Dist, binEntropy).
- All theorems are `sorry` (scaffold only), except `suppression_rate_pos`
  which is pure arithmetic from the setup hypotheses.
- External published results are `axiom`: Cho-Meyer (2001), Fannes-Audenaert,
  Gleason (1957), and the 7 metastability lemmas from FW/BEGK/CV/DV.
- The 7 metastability lemmas are axioms because they cite specific published
  theorems (FW 2012, BEGK 2004, CV 2016, DV 1975-83) rather than results
  we derive. Their types use abstract definitions (mu_stable, mu_BB, etc.)
  that are themselves `sorry` definitions.

## References

* Ehrlich, "Experiential Measure on Structure Space" (Paper 1)
* Ehrlich, "Exponential Suppression of Transient-Basin Contributions" (Paper 2)
* Ehrlich, "Lipschitz Stability of rho" (Paper 3)
* Ehrlich, "Born-Fisher Negative Result" (Paper 4)
* Freidlin-Wentzell, Random Perturbations of Dynamical Systems (2012)
* Bovier et al. (BEGK), Metastability in reversible diffusion processes (2004)
* Champagnat-Villemonais, QSD convergence (2016)
* Cho-Meyer, Markov chain sensitivity (2001)
* Gleason, "Measures on the closed subspaces of a Hilbert space" (1957)
-/

noncomputable section

open Real

namespace ExperientialMeasure

-- ============================================================================
-- PAPER 1: Structure Space and Experiential Density
-- ============================================================================

section Paper1

/-- A **composite Markov process** is a finite-state Markov chain on a product
    state space Omega = B x M, where B is the "body" (the system being modeled)
    and M is the "self-model" (the subsystem that represents B).

    The transition kernel P admits a factorization detecting "observe-then-update"
    architecture. The decomposition data D witnesses the product structure. -/
structure CompositeMarkovProcess where
  /-- Number of body states. -/
  nB : ℕ
  /-- Number of model states. -/
  nM : ℕ
  /-- Body has at least 2 states (otherwise H(B) = 0 and rho = 0). -/
  hB : 2 ≤ nB
  /-- Model has at least 2 states (otherwise I(B;M) = 0 and rho = 0). -/
  hM : 2 ≤ nM
  /-- The transition kernel as a matrix (Fin nB x Fin nM) -> (Fin nB x Fin nM) -> R.
      Entry P(s', s) is the probability of transitioning from state s to state s'. -/
  kernel : (Fin nB × Fin nM) → (Fin nB × Fin nM) → ℝ
  /-- Row-stochastic: each row sums to 1. -/
  row_stochastic : ∀ s, (∑ s', kernel s' s) = 1
  /-- Non-negative entries. -/
  kernel_nonneg : ∀ s s', 0 ≤ kernel s' s
  /-- Irreducibility: every state is reachable from every other state.
      (Simplified: the stationary distribution is unique and positive.) -/
  has_unique_stationary : True  -- placeholder for irreducibility

/-- The stationary distribution of a composite Markov process.
    Exists and is unique by irreducibility. Requires solving pi * P = pi,
    which needs eigenvalue computation beyond this scaffold. -/
def CompositeMarkovProcess.stationaryDist (P : CompositeMarkovProcess) :
    (Fin P.nB × Fin P.nM) → ℝ :=
  sorry

/-- The joint distribution reshaped as p(b, m). At stationarity this is
    just the stationary distribution viewed on B x M. -/
def CompositeMarkovProcess.jointDist (P : CompositeMarkovProcess) :
    (Fin P.nB × Fin P.nM) → ℝ :=
  P.stationaryDist

/-- The body marginal distribution p_B(b) = sum_m p(b, m). -/
def bodyMarginal (P : CompositeMarkovProcess) : Fin P.nB → ℝ :=
  fun b => ∑ m : Fin P.nM, P.jointDist (b, m)

/-- The model marginal distribution p_M(m) = sum_b p(b, m). -/
def modelMarginal (P : CompositeMarkovProcess) : Fin P.nM → ℝ :=
  fun m => ∑ b : Fin P.nB, P.jointDist (b, m)

/-- Shannon entropy H(X) = -sum_x p(x) ln p(x).
    Uses natural logarithm (nats). -/
def shannonEntropy {n : ℕ} (p : Fin n → ℝ) : ℝ :=
  -(∑ i : Fin n, p i * Real.log (p i))

/-- Mutual information I(B; M) = H(B) + H(M) - H(B, M).
    Equivalently, I(B; M) = sum_{b,m} p(b,m) ln(p(b,m) / (p_B(b) * p_M(m))). -/
def mutualInfo (P : CompositeMarkovProcess) : ℝ :=
  let hB := shannonEntropy (bodyMarginal P)
  let hM := shannonEntropy (modelMarginal P)
  let hBM := -(∑ i : Fin P.nB × Fin P.nM, P.jointDist i * Real.log (P.jointDist i))
  hB + hM - hBM

/-- Body entropy H(B) at stationarity. -/
def bodyEntropy (P : CompositeMarkovProcess) : ℝ :=
  shannonEntropy (bodyMarginal P)

/-- **Experiential density** (Definition 5 in Paper 1):

    rho(p) = I(B; M) * (1 - I(B; M) / H(B))

    Peaks at intermediate self-modeling fidelity (I = H/2, giving rho_max = H/4).
    Vanishes when I = 0 (no self-model) and when I = H (trivially perfect model).
    Equivalently, rho = I(B;M) * H(B|M) / H(B). -/
def experientialDensity (P : CompositeMarkovProcess) : ℝ :=
  let i := mutualInfo P
  let h := bodyEntropy P
  if h = 0 then 0
  else i * (1 - i / h)

/-- The experiential density is nonneg when I(B;M) in [0, H(B)]
    (the classical regime). -/
theorem experientialDensity_nonneg (P : CompositeMarkovProcess)
    (hI_nonneg : 0 ≤ mutualInfo P)
    (hI_le_H : mutualInfo P ≤ bodyEntropy P) :
    0 ≤ experientialDensity P := by
  by_cases hh : bodyEntropy P = 0
  · have : experientialDensity P = 0 := by simp [experientialDensity, hh]
    linarith
  · have : experientialDensity P = mutualInfo P * (1 - mutualInfo P / bodyEntropy P) := by
      simp [experientialDensity, hh]
    rw [this]
    have hH_pos : 0 < bodyEntropy P :=
      lt_of_le_of_ne (le_trans hI_nonneg hI_le_H) (Ne.symm hh)
    apply mul_nonneg hI_nonneg
    rw [sub_nonneg, div_le_one hH_pos]
    exact hI_le_H

/-- The experiential density is bounded above by H(B)/4.
    This is a consequence of AM-GM: x(1-x) <= 1/4 for x in [0,1],
    applied to x = I/H. -/
theorem experientialDensity_le_quarter_entropy (P : CompositeMarkovProcess)
    (hI_nonneg : 0 ≤ mutualInfo P)
    (hI_le_H : mutualInfo P ≤ bodyEntropy P)
    (hH_pos : 0 < bodyEntropy P) :
    experientialDensity P ≤ bodyEntropy P / 4 := by
  have hne : bodyEntropy P ≠ 0 := ne_of_gt hH_pos
  have key : experientialDensity P = mutualInfo P * (1 - mutualInfo P / bodyEntropy P) := by
    simp [experientialDensity, hne]
  rw [key, ← sub_nonneg]
  have h1 : bodyEntropy P / 4 - mutualInfo P * (1 - mutualInfo P / bodyEntropy P) =
    (bodyEntropy P - 2 * mutualInfo P) ^ 2 / (4 * bodyEntropy P) := by
    field_simp; ring
  rw [h1]
  exact div_nonneg (sq_nonneg _) (by positivity)

/-- The peak occurs at I = H/2, giving rho_max = H/4. -/
theorem experientialDensity_max_at_half (P : CompositeMarkovProcess)
    (hI : mutualInfo P = bodyEntropy P / 2)
    (hH_pos : 0 < bodyEntropy P) :
    experientialDensity P = bodyEntropy P / 4 := by
  have hne : bodyEntropy P ≠ 0 := ne_of_gt hH_pos
  have : experientialDensity P = mutualInfo P * (1 - mutualInfo P / bodyEntropy P) := by
    simp [experientialDensity, hne]
  rw [this, hI]
  field_simp
  ring

/-- Two composite Markov processes are **isomorphic** if there exists a
    product-preserving bijection phi = phi_B x phi_M that preserves the kernel.
    This is finer than arbitrary state relabeling: it respects the B x M
    decomposition structure. (Definition 2 in Paper 1.) -/
structure IsIsomorphic (P Q : CompositeMarkovProcess) : Prop where
  /-- Body state spaces have the same size. -/
  hB_eq : P.nB = Q.nB
  /-- Model state spaces have the same size. -/
  hM_eq : P.nM = Q.nM
  /-- There exist product-preserving bijections that conjugate the kernel.
      Full statement: exists phi_B : Fin P.nB -> Fin Q.nB, phi_M : Fin P.nM -> Fin Q.nM,
      both bijections, such that Q.kernel (phi(s'), phi(s)) = P.kernel s' s
      where phi = phi_B x phi_M. -/
  kernel_preserved : True  -- simplified; full statement needs Equiv on Fin types

/-- The experiential density is a **class function**: isomorphic processes
    have the same rho. Copy collapse follows: multiple instantiations of the
    same system occupy the same point in S. (Proposition in Paper 1, Section 6.) -/
theorem experientialDensity_isomorphism_invariant
    (P Q : CompositeMarkovProcess) (h : IsIsomorphic P Q) :
    experientialDensity P = experientialDensity Q := by
  sorry

/-- **Experiential functional** (Definition 7 in Paper 1):
    mu([0, T]) = integral_0^T rho(p_t) dt.

    The time-integrated experiential density over a trajectory.
    Units: information x time (nat-seconds). The integrand rho(p_t)
    is continuous in t (since p_t = p_0 * exp(Qt) is smooth), so the
    integral is a standard Riemann integral. -/
def experientialFunctional (P : CompositeMarkovProcess) (T : ℝ) : ℝ :=
  sorry

end Paper1

-- ============================================================================
-- PAPER 2: Theorem A (Boltzmann Brain Negligibility)
-- ============================================================================

section Paper2

/-- Configuration for the metastability setup of Theorem A.
    Models a family of Markov chains indexed by noise intensity eps > 0,
    with reversible Metropolis-type dynamics on an energy landscape E.
    Encodes assumptions A1-A4 from Paper 2. -/
structure MetastabilitySetup where
  /-- The composite Markov process (for a given eps). -/
  process : CompositeMarkovProcess
  /-- Communication height of the stable (deep) basin (Freidlin-Wentzell). -/
  Delta_s : ℝ
  /-- Communication height of the BB (shallow) basin. -/
  Delta_b : ℝ
  /-- A1: The stable basin is deeper than the BB basin. -/
  hDepth : Delta_b < Delta_s
  /-- A3: The observation horizon parameter. -/
  alpha : ℝ
  /-- A3: alpha is in the valid range (0, Delta_s - Delta_b). -/
  hAlpha : 0 < alpha ∧ alpha < Delta_s - Delta_b
  /-- A2: Lower bound on rho at the QSD of the stable basin. -/
  c_lower : ℝ
  /-- A2: The lower bound is positive (nontrivial self-modeling). -/
  hc_pos : 0 < c_lower
  /-- A2: Upper bound on rho (rho_max = H(B)/4). -/
  rho_max : ℝ
  /-- A2: The upper bound is positive. -/
  hrho_max_pos : 0 < rho_max

/-- The experiential measure accumulated in the stable basin over [0, T_eps].
    mu_stable = integral from 0 to min(tau, T_eps) of rho(p_t) dt.
    Requires measure-theoretic integration; abstract definition. -/
def mu_stable (S : MetastabilitySetup) (eps : ℝ) : ℝ := sorry

/-- The experiential measure accumulated in BB states over [0, T_eps].
    mu_BB = integral of rho(p_t) over time spent in B_BB before exit. -/
def mu_BB (S : MetastabilitySetup) (eps : ℝ) : ℝ := sorry

/-- The expected exit time from the stable basin.
    E_x[tau_{B_stable^c}] for starting state x in B_stable. -/
def expectedExitTime (S : MetastabilitySetup) (eps : ℝ) : ℝ := sorry

/-- The QSD mixing time within the stable basin. -/
def qsdMixingTime (S : MetastabilitySetup) (eps : ℝ) : ℝ := sorry

-- The 7 lemmas of Theorem A. Each cites a specific published result.
-- These are `axiom` because they are external theorems we assemble.

/-- **Lemma 1: Basin Partition** (Freidlin-Wentzell, Chapter 6, Theorem 6.3.1)
    The FW cycle hierarchy decomposes the state space into metastable sets
    with well-defined communication heights. The partition is encoded in the
    MetastabilitySetup structure (Delta_s, Delta_b). -/
axiom basin_partition (S : MetastabilitySetup) :
    0 < S.Delta_s ∧ 0 < S.Delta_b

/-- **Lemma 2: Residence Time Lower Bound** (BEGK 2004, Theorems 1.2, 1.4)
    The expected exit time from the stable basin scales as exp(Delta_s / eps).
    For any starting state in B_stable:
      E_x[tau_{B_stable^c}] >= C_res * exp((Delta_s - alpha/2) / eps).
    NOTE: `expectedExitTime` is defined as sorry above. This axiom bounds
    an abstract quantity; filling it requires defining the exit time first.
    Reference: Bovier, Eckhoff, Gayrard, Klein, "Metastability in reversible
    diffusion processes I," JEMS 6 (2004), 399-424. -/
axiom residence_time_lower_bound (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ C_res : ℝ, 0 < C_res ∧
    C_res * Real.exp ((S.Delta_s - S.alpha / 2) / eps) ≤ expectedExitTime S eps

/-- **Lemma 3: QSD Convergence** (Champagnat-Villemonais 2016, Theorem 2.1)
    The killed chain on B_stable converges exponentially fast to the unique
    quasi-stationary distribution nu_QSD. The mixing time t_mix satisfies
    t_mix << tau (exponentially smaller than the exit time).
    NOTE: Both `qsdMixingTime` and `expectedExitTime` are sorry defs.
    This axiom bounds abstract quantities. -/
axiom qsd_convergence (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ rate : ℝ, 0 < rate ∧
    qsdMixingTime S eps ≤ expectedExitTime S eps / 2

/-- **Lemma 4: Stable Measure Lower Bound** (our assembly of Lemmas 2 + 3)
    The experiential measure accumulated during residence in B_stable satisfies
    mu_stable >= c * c' * exp((Delta_s - alpha) / eps),
    where c is the rho lower bound at QSD and c' absorbs the mixing correction.
    NOTE: This is NOT an independent external theorem. It is our combination
    of the BEGK residence time bound with QSD convergence. `mu_stable` is a
    sorry def; this axiom bounds an abstract quantity. Should ideally be a
    theorem once Lemmas 2+3 and mu_stable are filled. -/
axiom stable_measure_lower_bound (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ C_stable : ℝ, 0 < C_stable ∧
    C_stable * Real.exp ((S.Delta_s - S.alpha) / eps) ≤ mu_stable S eps

/-- **Lemma 5: BB Occupation Upper Bound** (Renewal theory + BEGK)
    Before exiting B_stable, the expected total time in BB states scales as
    exp(Delta_b / eps). Combined with the rho upper bound:
    mu_BB <= rho_max * C_bb * exp(Delta_b / eps).
    NOTE: `mu_BB` is a sorry def; this axiom bounds an abstract quantity.
    Reference: Renewal theory occupation bounds (Feller, "An Introduction to
    Probability Theory," Vol. II, Chapter XI) combined with BEGK exit time
    estimates (Bovier et al., JEMS 6, 2004). -/
axiom bb_occupation_upper_bound (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ C_bb : ℝ, 0 < C_bb ∧
    mu_BB S eps ≤ C_bb * Real.exp (S.Delta_b / eps)

/-- **Lemma 6: Concentration** (BEGK Theorem 1.4 / Donsker-Varadhan)
    The weighted empirical measure concentrates around its expected value.
    Stable lower bound and BB upper bound hold simultaneously with high
    probability (>= 1 - 2*exp(-eta/2) - o(1) as eps -> 0).
    NOTE: The Lean axiom only states `0 < mu_stable S eps` (positivity),
    which is weaker than the full concentration bound described above.
    `mu_stable` is a sorry def. -/
axiom donsker_varadhan_concentration (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ eta : ℝ, 0 < eta ∧
    0 < mu_stable S eps  -- concentration implies mu_stable is positive

/-- **Theorem A: Boltzmann Brain Negligibility** (Paper 2, Theorem 1)

    Under assumptions A1-A4 (encoded in MetastabilitySetup):
      mu_BB / mu_stable <= C * exp(-(Delta_s - Delta_b - alpha) / eps) -> 0

    The 7-lemma composition: basin partition decomposes the landscape,
    BEGK gives residence times, QSD convergence gives the density lower bound,
    renewal theory caps BB occupation, DV concentration makes it hold with
    high probability, and the ratio assembly combines everything.

    The exponential suppression rate is Delta_s - Delta_b - alpha, which is
    positive by assumption A3 (alpha < Delta_s - Delta_b). -/
theorem theorem_A (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ C : ℝ, 0 < C ∧
    mu_BB S eps / mu_stable S eps ≤
      C * Real.exp (-(S.Delta_s - S.Delta_b - S.alpha) / eps) := by
  sorry

/-- The suppression rate is positive (immediate from the setup).
    This is the only non-sorry proof in the file: pure arithmetic from A1 + A3. -/
theorem suppression_rate_pos (S : MetastabilitySetup) :
    0 < S.Delta_s - S.Delta_b - S.alpha := by
  linarith [S.hDepth, S.hAlpha.1, S.hAlpha.2]

/-- **Error Composition** (Proposition in Paper 2):
    The product of all correction factors from Steps 2-7 is
    1 + O(exp(-gamma/eps)) with gamma = min(alpha/2, Delta_s - alpha) > 0.
    This ensures the prefactor C in Theorem A is O(1). -/
theorem error_composition_exponential (S : MetastabilitySetup) (eps : ℝ) (heps : 0 < eps) :
    ∃ gamma : ℝ, 0 < gamma ∧
    gamma = min (S.alpha / 2) (S.Delta_s - S.alpha) := by
  have ⟨_, hDb⟩ := basin_partition S
  refine ⟨min (S.alpha / 2) (S.Delta_s - S.alpha), ?_, rfl⟩
  exact lt_min (by linarith [S.hAlpha.1]) (by linarith [S.hAlpha.2, hDb])

end Paper2

-- ============================================================================
-- PAPER 3: Lipschitz Stability
-- ============================================================================

section Paper3

/-- The absolute spectral gap of an irreducible stochastic matrix.
    gap(P) = 1 - |lambda_2(P)| where lambda_2 is the eigenvalue with
    second-largest absolute value. Requires spectral theory. -/
def spectralGap (P : CompositeMarkovProcess) : ℝ := sorry

/-- The infinity norm of the difference of two kernels:
    ||P - P'||_inf = max_s sum_{s'} |P(s',s) - P'(s',s)|.
    Requires compatible state spaces (same nB, nM). -/
def kernelDiffNorm (P Q : CompositeMarkovProcess)
    (h_nB : P.nB = Q.nB) (h_nM : P.nM = Q.nM) : ℝ :=
  let c (s : Fin P.nB × Fin P.nM) : Fin Q.nB × Fin Q.nM :=
    (Fin.cast h_nB s.1, Fin.cast h_nM s.2)
  Finset.sup' Finset.univ
    ⟨(⟨0, by have := P.hB; omega⟩, ⟨0, by have := P.hM; omega⟩), Finset.mem_univ _⟩
    fun s => ∑ s', |P.kernel s' s - Q.kernel (c s') (c s)|

/-- The L1 distance between stationary distributions of two processes.
    ||pi - pi'||_1 = sum_s |pi(s) - pi'(s)|. -/
def stationaryL1Dist (P Q : CompositeMarkovProcess)
    (h_nB : P.nB = Q.nB) (h_nM : P.nM = Q.nM) : ℝ :=
  ∑ s : Fin P.nB × Fin P.nM,
    |P.stationaryDist s - Q.stationaryDist (Fin.cast h_nB s.1, Fin.cast h_nM s.2)|

/-- The binary entropy function h_bin(x) = -x*ln(x) - (1-x)*ln(1-x). -/
def binEntropy (x : ℝ) : ℝ := -x * Real.log x - (1 - x) * Real.log (1 - x)

/-- **Cho-Meyer Perturbation Bound** (Cho-Meyer 2001):
    ||pi - pi'||_1 <= ||P - P'||_inf / gap(P).

    This is the foundation of the Lipschitz stability proof:
    small kernel perturbations produce small stationary distribution
    perturbations, controlled by the spectral gap. -/
axiom cho_meyer_bound (P Q : CompositeMarkovProcess)
    (h_nB : P.nB = Q.nB) (h_nM : P.nM = Q.nM)
    (hgap : 0 < spectralGap P) :
    stationaryL1Dist P Q h_nB h_nM ≤
      kernelDiffNorm P Q h_nB h_nM / spectralGap P

/-- The L1 distance between two distributions on Fin k. -/
def distribL1Dist {k : ℕ} (p q : Fin k → ℝ) : ℝ :=
  ∑ i : Fin k, |p i - q i|

/-- **Fannes-Audenaert Inequality** (entropy continuity):
    |H(p) - H(q)| <= (delta/2) * ln(k-1) + h_bin(delta/2)
    for distributions on k >= 2 symbols with ||p - q||_1 = delta.

    References: Fannes, "A continuity property of the entropy density for
    spin lattice systems," CMP 31 (1973), 291-294. Tight form by Audenaert,
    "A sharp continuity estimate for the von Neumann entropy," JPhysA 40
    (2007), 8127-8136.

    Cited as Lemma 2 in Paper 3. -/
axiom fannes_audenaert {k : ℕ} (hk : 2 ≤ k)
    (p q : Fin k → ℝ) (delta : ℝ)
    (hdelta_pos : 0 < delta)
    (hdelta_range : delta ≤ 2 * (1 - 1 / (k : ℝ)))
    (hdelta_eq : distribL1Dist p q = delta)
    : |shannonEntropy p - shannonEntropy q| ≤
      delta / 2 * Real.log ((k : ℝ) - 1) + binEntropy (delta / 2)

/-- **Lipschitz Stability of rho** (Paper 3, Theorem 1):

    Let P, P' be irreducible row-stochastic matrices on Omega = B x M
    with |B| >= 2, |M| >= 2. Let gap(P) > 0. Then:

      |rho(P) - rho(P')| <= L(delta) * ||P - P'||_inf

    where L(delta) = (C_I(delta) + C_H(delta)) / gap(P) and delta is the
    L1 distance between stationary distributions (bounded by Cho-Meyer).

    The proof proceeds in three steps:
    1. Cho-Meyer: kernel perturbation -> stationary distribution perturbation
    2. Fannes-Audenaert: distribution perturbation -> entropy/MI perturbation
    3. Algebraic assembly: entropy perturbations -> rho perturbation

    Verified numerically: 3000 random perturbations, zero violations. -/
theorem lipschitz_stability (P Q : CompositeMarkovProcess)
    (h_nB : P.nB = Q.nB) (h_nM : P.nM = Q.nM)
    (hgap : 0 < spectralGap P) :
    ∃ L : ℝ, 0 < L ∧
    |experientialDensity P - experientialDensity Q| ≤
      L * kernelDiffNorm P Q h_nB h_nM := by
  sorry

/-- The Lipschitz constant has explicit form (Paper 3, equations 5-8):
    L(delta) = (C_I(delta) + C_H(delta)) / gap(P) where
    C_I = (1/2)(ln(|B|-1) + ln(|M|-1) + ln(n-1)) + 3*h_bin(delta/2)/delta
    C_H = (1/2)ln(|B|-1) + h_bin(delta/2)/delta.

    For small perturbations (delta << 1), the leading behavior is:
    L ~ (1 / (2*gap(P))) * (2*ln(|B|-1) + ln(|M|-1) + ln(n-1)). -/
theorem lipschitz_constant_explicit (P Q : CompositeMarkovProcess)
    (h_nB : P.nB = Q.nB) (h_nM : P.nM = Q.nM)
    (hgap : 0 < spectralGap P) :
    |experientialDensity P - experientialDensity Q| ≤
      ((1 / (2 * spectralGap P)) *
        (2 * Real.log ((P.nB : ℝ) - 1) + Real.log ((P.nM : ℝ) - 1) +
         Real.log ((P.nB * P.nM : ℝ) - 1)) +
       4 * Real.log 2) := by
  sorry

/-- **Uniform non-linear bound** (Paper 3, equation 10):
    Substituting the Cho-Meyer bound into the non-linear Fannes bound and
    using h_bin(x) <= ln(2) gives a bound independent of delta:
    |rho(P) - rho(P')| <= ||P-P'||/(2*gap) * (log terms) + 4*ln(2). -/
theorem lipschitz_uniform_bound (P Q : CompositeMarkovProcess)
    (h_nB : P.nB = Q.nB) (h_nM : P.nM = Q.nM)
    (hgap : 0 < spectralGap P) :
    |experientialDensity P - experientialDensity Q| ≤
      kernelDiffNorm P Q h_nB h_nM / (2 * spectralGap P) *
        (2 * Real.log ((P.nB : ℝ) - 1) + Real.log ((P.nM : ℝ) - 1) +
         Real.log ((P.nB * P.nM : ℝ) - 1)) +
      4 * Real.log 2 := by
  sorry

end Paper3

-- ============================================================================
-- PAPER 4: Born-Fisher Negative Result
-- ============================================================================

section Paper4

/-- The quantum experiential density for a bipartite density matrix.
    rho_Q = I_vN(B; M) * (1 - I_vN(B; M) / S_vN(B))
    where S_vN is von Neumann entropy and I_vN is quantum mutual information.

    CRITICAL: For pure entangled states, I_vN = 2 * S_vN(B) so rho_Q < 0.
    The functional is only physically meaningful in the decohered (mixed) regime
    where I_vN(B;M) <= S_vN(B). -/
structure QuantumExperientialDensity where
  /-- Dimension of body Hilbert space. -/
  dB : ℕ
  /-- Dimension of model Hilbert space. -/
  dM : ℕ
  /-- Von Neumann entropy of the body subsystem S_vN(B). -/
  svn_B : ℝ
  /-- Von Neumann entropy of the model subsystem S_vN(M). -/
  svn_M : ℝ
  /-- Von Neumann entropy of the joint system S_vN(BM). -/
  svn_BM : ℝ

/-- Quantum mutual information I_vN(B; M) = S_vN(B) + S_vN(M) - S_vN(BM). -/
def QuantumExperientialDensity.qmi (rho : QuantumExperientialDensity) : ℝ :=
  rho.svn_B + rho.svn_M - rho.svn_BM

/-- The quantum experiential density value.
    rho_Q = I_vN * (1 - I_vN / S_vN(B)). -/
def QuantumExperientialDensity.value (rho : QuantumExperientialDensity) : ℝ :=
  if rho.svn_B = 0 then 0
  else rho.qmi * (1 - rho.qmi / rho.svn_B)

/-- For pure bipartite states: S_vN(BM) = 0 and S_vN(B) = S_vN(M) (Schmidt).
    Then I_vN = 2 * S_vN(B), so rho_Q = 2*S*(1 - 2) = -2*S < 0.
    The quantum experiential density is NEGATIVE for all entangled pure states.
    This is the key observation that kills the Born-Fisher conjecture
    in the Lindblad setting. -/
theorem pure_state_negative (rho : QuantumExperientialDensity)
    (hpure : rho.svn_BM = 0)
    (hschmidt : rho.svn_B = rho.svn_M)
    (hent : 0 < rho.svn_B) :
    rho.value < 0 := by
  have hne_M : rho.svn_M ≠ 0 := by rw [← hschmidt]; exact hent.ne'
  unfold QuantumExperientialDensity.value
  rw [if_neg hent.ne']
  simp only [QuantumExperientialDensity.qmi, hpure, hschmidt, sub_zero]
  rw [show rho.svn_M + rho.svn_M = 2 * rho.svn_M from by ring]
  rw [mul_div_cancel_right₀ 2 hne_M]
  have hM_pos : 0 < rho.svn_M := by rw [← hschmidt]; exact hent
  nlinarith

/-- The ratio I_vN / S_vN(B) for a pure state equals 2 (over-correlated). -/
theorem pure_state_ratio_eq_two (rho : QuantumExperientialDensity)
    (hpure : rho.svn_BM = 0)
    (hschmidt : rho.svn_B = rho.svn_M)
    (hent : 0 < rho.svn_B) :
    rho.qmi / rho.svn_B = 2 := by
  simp only [QuantumExperientialDensity.qmi, hpure, hschmidt, sub_zero]
  rw [show rho.svn_M + rho.svn_M = 2 * rho.svn_M from by ring]
  exact mul_div_cancel_right₀ 2 (by rw [← hschmidt]; exact hent.ne')

/-- The Born-Fisher-Experiential conjecture (Conjecture 1 in Paper 4):
    Among all probability assignments {p_k} over measurement outcomes,
    the Born rule p_k = |c_k|^2 is dynamically selected by extremizing
    the time-integrated experiential density mu_Q(theta).

    Stated as a Prop so we can express its negation. The full conjecture
    involves Lindblad dynamics and variational calculus over initial state
    parameterizations; we abstract it as an opaque proposition. -/
def BornFisherConjecture : Prop := sorry

/-- **Paper 4 Main Result: Born-Fisher Falsification**

    The Born-Fisher-Experiential conjecture is FALSE.

    Test A (static): Half-saturation tracking accuracy alpha_{1/2}(p) varies
    with p, but Born-rule body probabilities show no distinguished behavior.
    Spread across 1000 random body probabilities: 0.069 (no Born peak).

    Test B (dynamic): Under Lindblad evolution with exchange Hamiltonian and
    dephasing, rho_Q(t) <= 0 throughout the entire evolution for ALL tested
    trajectories (1900+ parameter combinations). The trajectory functional
    mu_Q = integral max(rho_Q, 0) dt is identically zero.

    Physical mechanism: the exchange Hamiltonian generates perfect tracking
    (I_vN -> 2 * S_vN(B)), keeping the system in the over-correlated regime
    where rho_Q < 0 at all times. No dynamical selection mechanism exists.

    CONSEQUENCE: The Born rule is forced by ALGEBRA (Gleason's theorem applied
    to the C*-algebra that self-modeling produces via Paper 5), not by
    information-theoretic optimization of rho. rho selects self-modelers;
    the algebra does the rest. -/
theorem born_fisher_falsified : ¬ BornFisherConjecture := by
  sorry

/-- **Gleason's Theorem** (1957): On a Hilbert space of dimension >= 3,
    the only countably additive probability measure on the lattice of
    closed subspaces is given by the Born rule: mu(P) = Tr(rho * P)
    for some density operator rho.

    This is WHY the Born rule holds in the Radical Relativity program:
    Paper 5 proves self-modeling forces C*-algebra structure, and Gleason's
    theorem on C*-algebras (dim >= 3) forces Born rule probabilities.

    Full formalization requires Hilbert space lattice theory; we axiomatize
    the statement. -/
axiom gleason_theorem (d : ℕ) (hd : 3 ≤ d) :
    True  -- placeholder: type is True because full statement needs lattice of closed subspaces

/-- **What Paper 4 establishes** (not falsified):
    The experiential density functional rho_Q itself is well-defined and
    well-behaved. It correctly identifies the parabolic peak structure
    (rho_Q^max = S_vN(B)/4 at r = 1/2) in the static diagonal-state regime.
    The issue is with the CONJECTURE that Born-rule probabilities are selected
    by it. Born is forced by algebra (Gleason), not information (rho). -/
theorem rho_well_defined_not_selective :
    True  -- documentation; the functional works, the conjecture doesn't
    := trivial

end Paper4

-- ============================================================================
-- Connection to Paper 5
-- ============================================================================

section Connection

/-- The division of labor between Papers 1-4 and Paper 5:

    **Papers 1-4 (this file):**
    (a) rho selects self-modeling composites on structure space (Paper 1)
    (b) Boltzmann brains are exponentially suppressed (Papers 1-2, Theorem A)
    (c) The selection is Lipschitz stable under perturbations (Paper 3)
    (d) The Born rule is NOT a consequence of rho (Paper 4)

    **Paper 5 (OrderUnitSpace through CStarBridge):**
    (e) Self-modeling forces sequential product axioms S1-S7
    (f) S1-S7 forces Euclidean Jordan algebra (vdW Theorem 1)
    (g) Local tomography selects complex type only
    (h) Complex EJA = M_n(C)^sa = self-adjoint part of C*-algebra (vdW Theorem 3)
    (i) Born rule follows from Gleason on the C*-algebra

    The chain: rho selects self-modelers -> self-modeling forces QM -> QM forces Born.
    The density does the selection; the algebra does the derivation. -/
theorem papers_1_4_to_paper_5_bridge :
    True  -- conceptual bridge, not a formal derivation
    := trivial

end Connection

end ExperientialMeasure
