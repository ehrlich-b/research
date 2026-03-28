# Lean Formalization Roadmap

_Last updated: 2026-03-27_

## Current State

23 files, ~5600 lines, **builds clean**.

| Component | Files | Lines | Sorry | Axioms | Status |
|-----------|-------|-------|-------|--------|--------|
| Papers 1-4 | 1 | 623 | 15 | 9 | Scaffold |
| Paper 5 | 10 | 2371 | **0** | 3 | **DONE** |
| Paper 6 | 3 | 1003 | 20 | 13 | Scaffold |
| Paper 7 + rho_J | 9 | ~1600 | 16 | 26 | **Octonions + RhoJ DONE, Albert 7/10**, rest scaffold |
| **Total** | **23** | **~5600** | **~51** | **51** | |

Paper 5 is the crown jewel: 0 sorry, 3 honest axioms, complete chain
machine-verified. **Phase A complete:** Octonions.lean 0 sorry (3 axioms).
**Phase B (Albert) 7/10:** jordanMul, det, idempotents, formally_real,
Peirce decomposition proved. 3 hard sorry remain (jordan_identity, simple,
not_special). **Phase B2 complete:** RhoJ.lean 0 sorry (1 axiom). The
rho_J uniqueness theorem is machine-verified.

---

## Why This Formalization Matters

The Radical Relativity program claims to derive physics from one
operational premise (self-modeling). The derivation chain:

  Self-modeling -> Jordan algebras -> complex QM (Paper 5, PROVED)
  Non-composability -> h_3(O) -> SM gauge group (Paper 7, CONDITIONAL)
  rho resolves to unique rho_J within h_3(O) (Paper 1, THEOREM)

Machine verification serves three purposes:
1. **Credibility.** Bryan is an independent researcher without institutional
   backing. Lean proofs replace "trust me" with "check the types."
2. **The chain is long.** Self-modeling -> sequential product -> S1-S7 ->
   EJA -> local tomography -> type exclusion -> C*-algebra. A human error
   anywhere invalidates everything downstream. Machine checking catches it.
3. **The rho_J uniqueness theorem** (Phase B2) is the program's Eddington
   prediction: consciousness depends on a cubic invariant (det), not
   quadratic (IIT's phi). Machine-verifying this theorem puts the prediction
   on the hardest possible footing.

Current priority: Phase B (Albert algebra) unlocks Phase B2 (rho_J) and
Phase D (Paper 7 chain). Phase B is the bottleneck.

---

## Philosophy

- **Every sorry is a claim.** The type signature says what we claim; sorry
  says we haven't proved it yet. The BUILD SUCCEEDING means all claims are
  at least well-typed.
- **Axioms are honest citations.** Each axiom cites a published theorem we
  use but don't re-prove. Axioms are permanent unless we decide to prove
  the cited result from scratch.
- **Sorry -> proof is the work.** Each sorry eliminated is a real
  contribution. Priority is: highest-impact sorry's first.
- **Axiom count matters for credibility.** 3 axioms (Paper 5) is excellent.
  50 axioms (whole program) is a lot. Some can be proved; most are deep
  published theorems we'd be insane to re-prove in Lean.

---

## Priority Ranking of Sorry's

### Tier 1: Provable now, high impact (do these first)

These are finite-dimensional algebra/arithmetic that Mathlib should handle.

**Paper 7 - Octonions.lean -- COMPLETE (14 -> 0 sorry)**

Fano-plane multiplication table. All identities proved by
`ext; fin_cases; simp; ring`. 3 axioms kept (Hurwitz, G_2, S^6).

**Paper 7 - Albert.lean (10 -> 3 sorry)**

7 proved: jordanMul, det, sum_rank1_eq_one, rankOneIdem_idempotent,
rankOneIdem_orthogonal, formally_real, peirce_complete. 1 axiom (Zel'manov).

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `jordan_identity` | a(b(aa)) = (ab)(aa) | Hard | Degree-4 identity in 54 real variables; follows from O alternativity |
| `simple` | No nontrivial ideals | Hard | Requires spectral theory of Jordan algebras |
| `not_special` | Not embeddable in A^+ | Hard | Albert's theorem (1934), Glennie identity or dim argument |

These 3 sorry's block Phase D (Paper 7 chain: NonComposability -> SM).
They do NOT block rho_J (Phase B2, already complete).

**Paper 7 - RhoJ.lean -- COMPLETE (0 sorry)**

rho_J uniqueness theorem. 1 axiom (f4_invariant_ring).

**Paper 6 - SelfModelingLattice.lean (5 sorry's)**

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `graphDist` | Graph distance | Easy | BFS / shortest path, or use Mathlib |
| `coordNumber` | Coordination number | Easy | Degree of vertex |
| `forced_hamiltonian_form` | Diagonal U(n) -> alpha*I + J*F | **Medium-Hard** | Schur-Weyl for S_2, Mathlib rep theory |
| `liebRobinsonVelocity_pos` | v_LR > 0 | Easy | From formula + J > 0 |
| `heisenberg_reduction_n2` | n=2 SWAP = Heisenberg | Easy | Pauli expansion, compute |

The `forced_hamiltonian_form` is the most important sorry in the entire Paper 6
formalization. It's the paper's novel algebraic contribution. If proved, it
machine-verifies that self-modeling forces the Heisenberg model.

**Estimated effort:** 200-400 lines.

### Tier 2: Provable with effort, medium impact

**Paper 7 - NonComposability.lean (3 sorry's)**

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `bgw_exchange_lemma` | rank(A)*rank(B) <= rank(C) | Hard | Tensor product dimension argument |
| `exceptional_no_composite` | h_3(O) has no composite | Medium | From not_special + hanche_olsen |
| `bgw_composites_are_special` | Composites are special | Medium-Hard | From rank argument + JvNW |

**Paper 7 - UniverseAlgebra.lean (2 sorry's)**

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `non_composable_not_special` | Contrapositive of hanche_olsen | Easy | Direct logic |
| `universe_non_composable` | No composite for universe algebra | Medium | Chain through definitions |

**Paper 7 - F4.lean (4 sorry's)**

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `Aut_h3O.inv` | Inverse automorphism | Easy | From Group structure |
| `stab_idem_normal` | Stab(E_i) normal in conjugation sense | Medium | Group theory |
| `stab_complex_normal` | Stab(J) normal | Medium | Group theory |
| (implicit) | F_4 IS Aut(h_3(O)) | Axiom | Deep Lie theory, keep as axiom |

**Paper 6 - AreaLaw.lean (3 sorry's)**

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `boundarySize` | Count boundary edges | Easy | Set.card of boundary set |
| `volumeA` | Count vertices in A | Easy | Finset.card |
| `maxBondEntropy_pos` | 0 < log(n) for n >= 2 | Easy | Real.log_pos + cast |

**Paper 6 - JacobsonGR.lean (9 sorry's)**

Most of these are physics axioms restated as sorry theorems. The actual
content is the chain of implications, not the proofs of individual steps.

| Sorry | What | Difficulty | Keep as sorry? |
|-------|------|-----------|---------------|
| `jacobson_step_1` | Rindler horizon exists | Physics | Yes (geometric) |
| `jacobson_step_2` | Heat flux formula | Physics | Yes |
| `jacobson_step_3` | Entropy from Raychaudhuri | Physics | Yes |
| `jacobson_step_4` | Clausius cancellation | Algebra | Provable (cancel kappa) |
| `jacobson_step_5` | All null directions -> Einstein | Algebra | Provable (tensor extraction) |
| `self_modeling_implies_einstein` | Capstone | Chain | Provable from steps |
| `vlr_maps_to_c` | v_LR -> c | Physics | Yes |
| `cosmological_constant_undetermined` | Lambda free | Physics | Yes |
| `nec_gives_attractive_gravity` | NEC -> sign | Algebra | Provable |

### Tier 3: Papers 1-4 (scaffold, lower priority)

These are mostly measure theory / probability. Less impact because
Papers 1-4 are supporting rather than load-bearing.

| Sorry | File | What | Difficulty |
|-------|------|------|-----------|
| `rho_nonneg` | ExperientialMeasure | rho >= 0 | Easy (product of nonneg terms) |
| `rho_upper_bound` | ExperientialMeasure | rho <= H/4 | Medium (AM-GM) |
| `rho_peak` | ExperientialMeasure | Peak at I = H/2 | Medium (calculus) |
| `rho_isomorphism_invariant` | ExperientialMeasure | Invariance | Medium |
| `theorem_A` | ExperientialMeasure | BB negligibility | Hard (7-lemma chain) |
| `error_composition` | ExperientialMeasure | Error propagation | Medium |
| `lipschitz_stability` | ExperientialMeasure | Lipschitz continuity | Hard |
| `lipschitz_constant_explicit` | ExperientialMeasure | Explicit bound | Hard |
| `lipschitz_uniform_bound` | ExperientialMeasure | Uniform bound | Hard |
| `born_fisher_falsified` | ExperientialMeasure | Negative result | Medium |
| + 5 measure-theoretic definitions | ExperientialMeasure | | Medium |

### Tier 4: Will remain axioms (published deep theorems)

These should stay as axioms permanently. Proving them would be
re-deriving textbook results with no research value.

**Permanent axioms (Papers 1-4):** Metastability lemmas (6), Cho-Meyer,
Fannes-Audenaert, Gleason's theorem.

**Permanent axioms (Paper 5):** spectral_jordan_identity, vdw_theorem_3,
sp_sub_right_general. (3 total - this is excellent.)

**Permanent axioms (Paper 6):** Lieb-Robinson bound, WVCH bound, Hastings
area law, Calabrese-Cardy, Raychaudhuri equation, Bisognano-Wichmann.
Gap axioms (4): Lorentz, lattice BW, local equilibrium, continuum limit.
These ARE the open physics - they should be axioms until the physics is
settled.

**Permanent axioms (Paper 7):** Hurwitz classification, Aut(O) = G_2,
JvNW classification, Chevalley-Schafer (Aut(h_3(O)) = F_4), Borel-de
Siebenthal, Todorov-Drenska intersection. These are deep Lie theory /
classification theorems. Probably 20+ of the 25 Paper 7 axioms stay.

**Potentially provable axioms:**
- `schur_weyl_S2` (Paper 6) - finite-dim rep theory, Mathlib may cover
- `rank_ge_4_special` (Paper 7) - might follow from concrete construction
- `hanche_olsen_composite` (Paper 7) - might reduce to explicit embedding

---

## Phased Roadmap

### Phase A: Octonions -- **COMPLETE** (2026-03-27)
**Result:** 14 sorry -> 0. 3 axioms kept (Hurwitz, G_2, S^6).
**Approach:** Fano plane multiplication table with `k.val` comparisons,
all identities proved by `ext; fin_cases; simp; ring`.
**Bug found:** `moufang_right` statement was wrong (was just associativity,
which is false). Fixed to correct right Moufang `((ca)b)a = c(a(ba))`.

### Phase B: Albert algebra -- **7/10 DONE** (2026-03-27)
**Result:** 10 sorry -> 3. 1 axiom kept (Zel'manov).
**Proved:** jordanMul (explicit 3×3 Hermitian octonionic formula), det
(Freudenthal), sum_rank1_eq_one, rankOneIdem_idempotent/orthogonal,
formally_real (sums-of-squares), peirce_complete (explicit decomposition).
**Remaining:** jordan_identity (54-var polynomial), simple, not_special.
**Files:** Albert.lean
**Why this is the bottleneck:** Albert.lean defines det(X) and Tr(X^2) on
h_3(O), which are needed by BOTH downstream paths:
- **Phase B2 (rho_J):** The uniqueness theorem uses det and Tr(X^2) directly.
  This is the program's most distinguishing testable prediction.
- **Phase D (Paper 7 chain):** NonComposability -> F4 -> SM gauge group.
  All depend on h_3(O) being concretely defined.
Once Albert builds clean, both paths open simultaneously.

### Phase B2: rho_J Uniqueness Theorem -- **COMPLETE** (2026-03-27)
**Result:** 0 sorry, 1 axiom (`f4_invariant_ring`). 147 lines.
**File:** RhoJ.lean (imports Albert.lean)
**What's proved:**
- `rhoJ_unique_minimal`: any degree-5 polynomial in (sigma_2, sigma_3)
  vanishing at det=0 and max-mixed is proportional to rho_J. Proof by
  `nlinarith` + `ring` (pure polynomial algebra).
- Boundary conditions: rho_J = 0 when det = 0 or Tr(X^2) = 1/3.
- Concrete evaluations: pure states have det = 0 and sigma_2 = 1.
**What's axiomatized:** `f4_invariant_ring` (F_4-invariant polynomials
on h_3(O) states are generated by sigma_2 and sigma_3). Classical
Chevalley-Schafer result.
**What's NOT proved:** Non-negativity on full state space (needs QM-AM
on eigenvalues; numerically verified in rho_uniqueness.py).
**Research note:** blog/research/rho-fixed-point-equation.md
**Verification:** blog/research/rho-j-experiment/rho_uniqueness.py

### Phase C: Paper 6 algebraic core
**Goal:** Prove forced_hamiltonian_form (the Schur-Weyl argument).
**Files:** SelfModelingLattice.lean
**Sorry reduction:** 5 -> 0
**Effort:** 200-400 lines, ~1-2 sessions
**Why here:** Paper 6's novel contribution, independent of Paper 7.
The most important single sorry for the GR paper's credibility.

### Phase D: Paper 7 chain (depends on A+B)
**Goal:** NonComposability -> UniverseAlgebra -> F4 -> Observer -> Gauge -> Chirality.
**Files:** NonComposability.lean through Chirality.lean
**Sorry reduction:** 11 -> 0-3
**Effort:** 300-500 lines, ~2-3 sessions
**Approach:** Many of these are just chaining axioms + definitions.
The sorry's are glue, not deep proofs. Once A+B are done, this
should flow relatively quickly.

### Phase E: Paper 6 physics bridge
**Goal:** Prove the algebraic sorry's in JacobsonGR.lean (steps 4, 5, capstone).
**Files:** JacobsonGR.lean, AreaLaw.lean
**Sorry reduction:** 12 -> ~5 (physics sorry's stay)
**Effort:** 200-300 lines, ~1-2 sessions
**Note:** The physics gaps (Lorentz, BW, equilibrium, continuum) stay as
axioms. The algebraic steps (Clausius cancellation, tensor extraction)
are provable.

### Phase F: Papers 1-4 (polish)
**Goal:** Prove the easy sorry's, leave hard measure theory.
**Files:** ExperientialMeasure.lean
**Sorry reduction:** 15 -> ~8
**Effort:** 200-300 lines, ~1-2 sessions
**Note:** Lower priority. These papers are supporting, not load-bearing.

### Phase G: Axiom reduction (long-term)
**Goal:** Prove select axioms from Mathlib or first principles.
**Candidates:** schur_weyl_S2, rank_ge_4_special, hanche_olsen_composite,
spectral_jordan_identity (the last Paper 5 gap).
**Note:** Each axiom proved is a meaningful contribution but diminishing
returns. The program's credibility comes from the 0-sorry chain
(Paper 5) plus the clear axiom/sorry accounting everywhere else.

---

## Target End State

| Component | Sorry | Axioms | Status |
|-----------|-------|--------|--------|
| Papers 1-4 | ~8 | 9 | Partial (measure theory hard) |
| Paper 5 | **0** | 3 | **DONE** |
| Paper 6 | ~5 | 13 | Algebraic core proved, physics gaps as axioms |
| Paper 7 | **0-3** | ~22 | Chain proved, deep Lie theory as axioms |
| **Total** | **~13-16** | **~47** | |

Down from 89 sorry to ~15, with the remaining sorry's being either
deep measure theory (Papers 1-4) or physics gaps (Paper 6). The core
mathematical claims (self-modeling -> QM -> SM gauge group) would be
machine-verified.

---

## Connection to Paper Program

| Paper Event | Lean Action |
|-------------|-------------|
| Paper 5 published | Lean already done (0 sorry). Deploy as evidence. |
| Paper 6 review | Phase C (Schur-Weyl) strengthens credibility. |
| Paper 7 assembled | Phases A+B+D prove the algebraic chain. |
| Paper 0 written | Full program in Lean is the computational appendix. |
| Any paper revised | Check corresponding Lean file, update if needed. |

**Rule: no paper ships without its Lean formalization being at least scaffolded
and building clean. Ideally, the core algebraic claims should be proved (0 sorry)
before the paper is submitted for review.**
