# Lean Formalization Roadmap

_Last updated: 2026-03-24_

## Current State

22 files, 5373 lines, **builds clean**.

| Component | Files | Lines | Sorry | Axioms | Status |
|-----------|-------|-------|-------|--------|--------|
| Papers 1-4 | 1 | 623 | 15 | 9 | Scaffold |
| Paper 5 | 10 | 2371 | **0** | 3 | **DONE** |
| Paper 6 | 3 | 1003 | 20 | 13 | Scaffold |
| Paper 7 | 8 | 1376 | 54 | 25 | Scaffold (code, not docs) |
| **Total** | **22** | **5373** | **89** | **50** | |

Paper 5 is the crown jewel: 0 sorry, 3 honest axioms, complete chain
machine-verified. Everything else is scaffold (sorry/axiom with correct
type signatures).

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

**Paper 7 - Octonions.lean (14 sorry's)**

The single biggest block. Concrete R^8 algebra with a multiplication table.

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `mul` definition | Cayley-Dickson or Fano plane multiplication | Medium | Define explicitly on basis elements, extend bilinearly |
| `mul_one'`, `one_mul'` | Unit element | Easy | Unfold mul, compute |
| `conj_conj` | Involution | Easy | Unfold conj, compute |
| `norm_sq_mul` | Composition property | Medium | Explicit computation (8x8) |
| `conj_anti_hom` | Conjugation reverses order | Medium | Explicit computation |
| `mul_conj_eq_norm` | a * conj(a) = |a|^2 | Medium | Explicit computation |
| `division_algebra` | No zero divisors | Medium | From norm_sq_mul + norm positivity |
| `not_associative` | Exists counterexample | Easy | Exhibit concrete a,b,c |
| `alternativity_left/right` | a(ab) = (aa)b | Medium | Explicit computation |
| `moufang_*` (3) | Three Moufang identities | Hard | Each is a concrete identity on R^8 |

**Estimated effort:** 500-800 lines. This is the foundation for all of Paper 7.
Once mul is defined concretely, most properties follow by `decide` or `norm_num`
on the basis elements + bilinearity.

**Paper 7 - Albert.lean (10 sorry's)**

Depends on Octonions.lean being done.

| Sorry | What | Difficulty | Approach |
|-------|------|-----------|----------|
| `jordanMul` definition | (ab + ba)/2 for 3x3 Hermitian octonionic | Medium | Define from Octonion.mul, matrix ops |
| `det` definition | 27-dim determinant | Medium | Explicit formula (Freudenthal) |
| `sum_rank1_eq_one` | E_0 + E_1 + E_2 = 1 | Easy | Unfold, compute |
| `rank1_idempotent` | E_i^2 = E_i | Easy | Unfold, compute |
| `rank1_orthogonal` | E_i * E_j = 0 | Easy | Unfold, compute |
| `jordan_identity` | a(b(aa)) = (ab)(aa) | Hard | Nontrivial identity, needs computation |
| `formally_real` | a^2 = 0 -> a = 0 | Medium | From positive-definite trace form |
| `simple` | No nontrivial ideals | Hard | Classical argument |
| `not_special` | Not embeddable in A^+ | Hard | Glennie's identity or dim argument |
| `peirce_decomp` | Every element decomposes | Medium | From idempotents + Jordan product |

**Estimated effort:** 400-600 lines. Depends on Octonions.

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

### Phase A: Octonions (highest priority)
**Goal:** Concrete octonion algebra with all properties proved.
**Files:** Octonions.lean
**Sorry reduction:** 14 -> 0
**Axiom reduction:** keep Hurwitz, G_2, S^6 (3 stay)
**Effort:** 500-800 lines, ~2-4 sessions
**Why first:** Foundation for all Paper 7. Concrete algebra, no physics
assumptions, pure computation. Most Lean-friendly work in the program.

### Phase B: Albert algebra (depends on A)
**Goal:** h_3(O) with Jordan product, idempotents, Peirce decomposition.
**Files:** Albert.lean
**Sorry reduction:** 10 -> 0 (optimistic) or 10 -> 2-3 (hard ones may stay)
**Effort:** 400-600 lines, ~2-3 sessions
**Why second:** Unlocks the entire Paper 7 chain downstream.

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
