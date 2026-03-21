# S6 and S7 Proofs for General Finite-Dimensional Spectral OUS

% ASSERT_CONVENTION: natural_units=N/A, metric_signature=N/A, fourier_convention=N/A, coupling_convention=N/A, renormalization_scheme=N/A, gauge_choice=N/A
% CUSTOM_CONVENTION: sequential_product=sp(a,b) (non-commutative), compatibility=a compat b iff sp(a,b)=sp(b,a), sharp_effect=p with p&p=p, compression=C_p (Alfsen-Shultz P-projection for face(p)), peirce_1_space=P_1^{(a)} = id - sum_i C_{p_i}, axiom_source=arXiv:1803.11139 Definition 2 EXCLUSIVELY

**Phase:** 06-paper-assembly
**Date:** 2026-03-21
**Status:** Complete
**Depends on:** 04-peirce-feedback-extension.md, 04-axioms-S1-S3-S5-S7.md

---

## Overview

The Phase 4 proofs of S6 and S7 relied on matrix language, commutator brackets, and the Luders formula -- all of which are circular at the point in the paper where these axioms are verified (Section 4, before the EJA classification theorem is invoked). This document provides complete, rigorous proofs using only OUS-level constructions:

- Compressions C_p (Alfsen-Shultz)
- Peirce decompositions derived from compressions
- The corrected product formula (Eq. 04-06.4)
- Compression commutativity for compatible effects (Alfsen-Shultz Prop 7.49, Niestegge Lemma 3.3)
- Previously verified axioms S1 and S3

**Corrected product formula (Eq. 04-06.4):**

> sp(a, b) = sum_i lambda_i C_{p_i}(b) + sum_{i<j} sqrt(lambda_i lambda_j) P_{ij}(b)

where a = sum_i lambda_i p_i is the spectral decomposition, C_{p_i} are Alfsen-Shultz compressions, and P_{ij} is the Peirce (i,j) projection.

**Peirce decomposition completeness:** For any resolution of unity {p_1, ..., p_n}:

> b = sum_i C_{p_i}(b) + sum_{i<j} P_{ij}(b)

The total Peirce 1-space projection is P_1^{(a)} = id - sum_i C_{p_i}, and we have P_1^{(a)}(1) = 0 (since sum_i C_{p_i}(1) = sum_i p_i = 1).

**Peirce (i,j) projection from compressions:** For orthogonal projective units q_j, q_{j'} with q_j + q_{j'} <= 1:

> Q_{jj'} = C_{q_j + q_{j'}} - C_{q_j} - C_{q_{j'}}

This expresses each individual Peirce 1-space projection as a linear combination of compressions (all OUS primitives).

---

## Preliminary: Peirce Vanishing Lemma

**Lemma 1 (Peirce vanishing for compatible effects).** Let V be a finite-dimensional spectral OUS. If a compat b (i.e., sp(a,b) = sp(b,a)), then:

(a) The compressions C_{p_i} and C_{q_j} commute for all spectral projectors p_i of a and q_j of b:

> C_{p_i} o C_{q_j} = C_{q_j} o C_{p_i}  for all i, j.

(b) Each effect has zero Peirce 1-space component in the other's spectral decomposition:

> P_1^{(a)}(b) = 0  and  P_1^{(b)}(a) = 0.

**Proof.**

Part (a) is Alfsen-Shultz Prop 7.49 (compression commutativity for compatible projective units) combined with Niestegge Lemma 3.3 (which lifts compatibility from effects to their spectral projectors): if sp(a,b) = sp(b,a), then the spectral projectors of a are compatible with the spectral projectors of b, and compatible projective units have commuting compressions.

Part (b): Since the spectral projectors p_i and q_j are pairwise compatible (from part (a)), by Alfsen-Shultz Prop 7.50:

> C_{p_i} o C_{q_j} = C_{p_i wedge q_j}

where p_i wedge q_j is the meet (infimum) in the lattice of projective units. The meets {p_i wedge q_j}_{j} form a resolution of p_i within face(p_i), giving:

> sum_j (p_i wedge q_j) = p_i

(This is the join-refinement property: since {q_j} resolves 1 and p_i is compatible with each q_j, the meets {p_i wedge q_j} partition p_i.)

Now compute sum_j C_{q_j}(a):

sum_j C_{q_j}(a) = sum_j C_{q_j}(sum_i lambda_i p_i)
= sum_{i,j} lambda_i C_{q_j}(p_i)        [linearity of C_{q_j}]
= sum_{i,j} lambda_i (p_i wedge q_j)      [C_{q_j}(p_i) = C_{q_j}(C_{p_i}(1)) = C_{q_j wedge p_i}(1) = p_i wedge q_j]
= sum_i lambda_i (sum_j p_i wedge q_j)
= sum_i lambda_i p_i
= a

Therefore P_1^{(b)}(a) = a - sum_j C_{q_j}(a) = a - a = 0.

The same argument with a and b interchanged gives P_1^{(a)}(b) = 0. QED.

### SELF-CRITIQUE CHECKPOINT (Lemma 1):
1. SIGN CHECK: No sign changes. All steps are additive.
2. FACTOR CHECK: No factors introduced or removed.
3. CONVENTION CHECK: Using C_p for Alfsen-Shultz compression, P_1^{(a)} for total Peirce 1-space projection. Compatible with conventions file.
4. DIMENSION CHECK: All maps V -> V, all elements in V. Scalars in [0,1]. Correct.

---

## Preliminary: Block-Diagonal Compatibility Proposition

**Proposition 2 (Block-diagonal implies compatible).** Let a = sum_i lambda_i p_i in a finite-dimensional spectral OUS. If an effect e satisfies P_1^{(a)}(e) = 0, then sp(a, e) = sp(e, a), i.e., a compat e.

**Proof.**

**Step 1: Compute sp(a, e).**

Since P_1^{(a)}(e) = 0, all Peirce 1-space components P_{ii'}(e) vanish. The corrected product formula gives:

> sp(a, e) = sum_i lambda_i C_{p_i}(e) + sum_{i<i'} sqrt(lambda_i lambda_{i'}) P_{ii'}(e) = sum_i lambda_i C_{p_i}(e)

**Step 2: Decompose e within a's faces.**

P_1^{(a)}(e) = 0 means e = sum_i C_{p_i}(e). Each C_{p_i}(e) lies in face(p_i), the range of C_{p_i}. Since the faces face(p_i) are pairwise complementary (p_i perp p_{i'} for i != i'), the effect e is "block-diagonal" in a's spectral decomposition.

**Step 3: Spectral decomposition of e.**

Since e = sum_i C_{p_i}(e) with each C_{p_i}(e) in face(p_i), the spectral decomposition of e is the union of spectral decompositions within each face. Write:

> C_{p_i}(e) = sum_{l} delta_{i,l} s_{i,l}   within face(p_i)

where {s_{i,l}}_l are mutually orthogonal projective units in face(p_i), and delta_{i,l} >= 0 are the corresponding spectral values. Then:

> e = sum_{i,l} delta_{i,l} s_{i,l}

**Step 4: Each s_{i,l} is compatible with each p_{i'}.**

Since s_{i,l} <= p_i (lies in face(p_i)):
- For i' = i: s_{i,l} <= p_i implies C_{p_i}(s_{i,l}) = s_{i,l} and C_{s_{i,l}} o C_{p_i} = C_{p_i} o C_{s_{i,l}} = C_{s_{i,l}} (the compression onto a sub-face commutes with the compression onto the containing face).
- For i' != i: s_{i,l} <= p_i and p_i perp p_{i'} give s_{i,l} perp p_{i'}, hence C_{p_{i'}}(s_{i,l}) = 0 and C_{s_{i,l}}(p_{i'}) = 0. The compressions satisfy C_{p_{i'}} o C_{s_{i,l}} = C_{s_{i,l}} o C_{p_{i'}} = 0.

In both cases, C_{p_{i'}} commutes with C_{s_{i,l}} for all i', i, l. By Lemma 1 (part (b) direction): the Peirce 1-space of a in e's decomposition vanishes.

**Step 5: Compute sp(e, a).**

Since every spectral projector s_{i,l} of e is compatible with every p_{i'}, the Peirce 1-space terms vanish:

> sp(e, a) = sum_{i,l} delta_{i,l} C_{s_{i,l}}(a)

Expand: C_{s_{i,l}}(a) = C_{s_{i,l}}(sum_{i'} lambda_{i'} p_{i'}) = sum_{i'} lambda_{i'} C_{s_{i,l}}(p_{i'}).

From Step 4:
- C_{s_{i,l}}(p_{i'}) = s_{i,l} wedge p_{i'} = s_{i,l} if i' = i (since s_{i,l} <= p_i)
- C_{s_{i,l}}(p_{i'}) = 0 if i' != i

So C_{s_{i,l}}(a) = lambda_i s_{i,l}. Therefore:

> sp(e, a) = sum_{i,l} delta_{i,l} lambda_i s_{i,l} = sum_i lambda_i (sum_l delta_{i,l} s_{i,l}) = sum_i lambda_i C_{p_i}(e)

**Step 6: Compare.**

sp(a, e) = sum_i lambda_i C_{p_i}(e) = sp(e, a). QED.

### SELF-CRITIQUE CHECKPOINT (Proposition 2):
1. SIGN CHECK: No sign changes throughout. All equalities are additive decompositions.
2. FACTOR CHECK: No factors introduced. The lambda_i and delta_{i,l} propagate correctly.
3. CONVENTION CHECK: P_1^{(a)} = id - sum_i C_{p_i}. Compression commutativity from AS Prop 7.49. All OUS-level.
4. DIMENSION CHECK: All maps V -> V. Spectral values in [0,1]. Projective units in V. Correct.

---

## Axiom S6: Additivity of Compatibility

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S6) If a compat b then a compat (1 - b); if also a compat c then a compat (b + c) whenever b + c <= 1.

### Part (i): a compat b => a compat (1 - b)

**Proof.**

By Lemma 1(b), a compat b implies P_1^{(a)}(b) = 0. Since P_1^{(a)}(1) = 0 (the unit has zero Peirce 1-space component) and P_1^{(a)} is linear (it is id - sum_i C_{p_i}, a difference of linear maps):

> P_1^{(a)}(1 - b) = P_1^{(a)}(1) - P_1^{(a)}(b) = 0 - 0 = 0.

By Proposition 2, P_1^{(a)}(1 - b) = 0 implies a compat (1 - b). QED.

**Verification:** We confirm this matches the left/right product:

sp(a, 1-b) = sp(a, 1) - sp(a, b) = a - sp(a, b)  [by S1 and sp(a,1) = a]

sp(1-b, a): Since P_1^{(a)}(1-b) = 0, Proposition 2 gives sp(1-b, a) = sum_i lambda_i C_{p_i}(1-b) = sum_i lambda_i (p_i - C_{p_i}(b)) = a - sum_i lambda_i C_{p_i}(b).

Since P_1^{(a)}(b) = 0: sp(a, b) = sum_i lambda_i C_{p_i}(b). So sp(a, 1-b) = a - sp(a, b) = a - sum_i lambda_i C_{p_i}(b) = sp(1-b, a). Check.

### Part (ii): a compat b and a compat c => a compat (b + c) when b + c <= 1

**Proof.**

By Lemma 1(b): P_1^{(a)}(b) = 0 (from a compat b) and P_1^{(a)}(c) = 0 (from a compat c). By linearity of P_1^{(a)}:

> P_1^{(a)}(b + c) = P_1^{(a)}(b) + P_1^{(a)}(c) = 0 + 0 = 0.

By Proposition 2, a compat (b + c). QED.

**Verification:**

sp(a, b+c) = sp(a,b) + sp(a,c)  [S1]

sp(b+c, a): Since P_1^{(a)}(b+c) = 0, Proposition 2 gives:
sp(b+c, a) = sum_i lambda_i C_{p_i}(b+c) = sum_i lambda_i [C_{p_i}(b) + C_{p_i}(c)]
= [sum_i lambda_i C_{p_i}(b)] + [sum_i lambda_i C_{p_i}(c)]
= sp(a, b) + sp(a, c) [since P_1^{(a)}(b) = P_1^{(a)}(c) = 0]
= sp(a, b+c). Check.

### SELF-CRITIQUE CHECKPOINT (S6):
1. SIGN CHECK: Subtraction 1 - b gives P_1^{(a)}(1-b) = 0 - 0 = 0. Correct signs.
2. FACTOR CHECK: No factors introduced.
3. CONVENTION CHECK: S6 statement from vdW Def. 2. Compatibility = sp(a,b) = sp(b,a). All OUS-level.
4. DIMENSION CHECK: 1 - b and b + c are effects (in [0,1]_V) by hypothesis. All maps V -> V.

---

## Axiom S7: Multiplicativity of Compatibility

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S7) If a compat b and a compat c then a compat sp(b, c).

### Proof

We show P_1^{(a)}(sp(b, c)) = 0, then invoke Proposition 2.

Write a = sum_i lambda_i p_i, b = sum_j mu_j q_j, c = sum_k nu_k r_k.

**Step 1: Compression commutativity.**

Since a compat b: C_{p_i} o C_{q_j} = C_{q_j} o C_{p_i} for all i, j (Lemma 1(a)).

Since a compat c: C_{p_i} o C_{r_k} = C_{r_k} o C_{p_i} for all i, k (Lemma 1(a)).

**Step 2: C_{p_i} commutes with every building block of sp(b, c).**

The product sp(b, c) = sum_j mu_j C_{q_j}(c) + sum_{j<j'} sqrt(mu_j mu_{j'}) Q_{jj'}(c), where Q_{jj'} is the Peirce (j, j') projection for b's resolution.

Since Q_{jj'} = C_{q_j + q_{j'}} - C_{q_j} - C_{q_{j'}}, we need C_{p_i} to commute with C_{q_j + q_{j'}}. This holds because:
- p_i is compatible with q_j and q_{j'} (from Step 1)
- q_j perp q_{j'}, so q_j + q_{j'} is a projective unit
- By Alfsen-Shultz Prop 7.50, C_{p_i} o C_{q_j + q_{j'}} = C_{p_i wedge (q_j + q_{j'})} and C_{q_j + q_{j'}} o C_{p_i} = C_{(q_j + q_{j'}) wedge p_i}; since meets are commutative, these are equal.

Therefore C_{p_i} commutes with Q_{jj'} = C_{q_j + q_{j'}} - C_{q_j} - C_{q_{j'}} (a linear combination of maps that each commute with C_{p_i}).

**Step 3: Compute sum_i C_{p_i}(sp(b, c)).**

sum_i C_{p_i}(sp(b, c))
= sum_i C_{p_i}(sum_j mu_j C_{q_j}(c) + sum_{j<j'} sqrt(mu_j mu_{j'}) Q_{jj'}(c))

By linearity of C_{p_i}:
= sum_j mu_j [sum_i C_{p_i}(C_{q_j}(c))] + sum_{j<j'} sqrt(mu_j mu_{j'}) [sum_i C_{p_i}(Q_{jj'}(c))]

By compression commutativity (Steps 1 and 2):
= sum_j mu_j [sum_i C_{q_j}(C_{p_i}(c))] + sum_{j<j'} sqrt(mu_j mu_{j'}) [sum_i Q_{jj'}(C_{p_i}(c))]

By linearity of C_{q_j} and Q_{jj'}:
= sum_j mu_j C_{q_j}(sum_i C_{p_i}(c)) + sum_{j<j'} sqrt(mu_j mu_{j'}) Q_{jj'}(sum_i C_{p_i}(c))

**Step 4: Apply P_1^{(a)}(c) = 0.**

Since a compat c, Lemma 1(b) gives P_1^{(a)}(c) = 0, so sum_i C_{p_i}(c) = c. Substituting:

sum_i C_{p_i}(sp(b, c)) = sum_j mu_j C_{q_j}(c) + sum_{j<j'} sqrt(mu_j mu_{j'}) Q_{jj'}(c) = sp(b, c)

**Step 5: Conclude.**

P_1^{(a)}(sp(b, c)) = sp(b, c) - sum_i C_{p_i}(sp(b, c)) = sp(b, c) - sp(b, c) = 0.

By Proposition 2, a compat sp(b, c). QED.

### SELF-CRITIQUE CHECKPOINT (S7):
1. SIGN CHECK: No sign changes. All steps are additive/compositional.
2. FACTOR CHECK: The sqrt(mu_j mu_{j'}) factors pass through linearity unchanged. No factors introduced or lost.
3. CONVENTION CHECK: S7 from vdW Def. 2. All tools are OUS-level: compressions, Peirce projections, compression commutativity (AS Prop 7.49/7.50). No Jordan algebra, no Luders formula, no matrix multiplication.
4. DIMENSION CHECK: sp(b,c) is an effect (shown by S4 proof that sp maps effects to effects). All maps V -> V.

---

## Circularity Audit

The proofs use ONLY:
- Alfsen-Shultz compressions C_p and their properties (linearity, C_p(1) = p, idempotence)
- Peirce decomposition completeness (derived from compressions)
- Compression commutativity for compatible projective units (Alfsen-Shultz Prop 7.49, Niestegge Lemma 3.3)
- Composition formula C_p o C_q = C_{p wedge q} for compatible p, q (Alfsen-Shultz Prop 7.50)
- The corrected product formula (Eq. 04-06.4)
- Previously verified axiom S1 (additivity in second argument)
- The construction identity sp(a, 1) = a

**Forbidden items NOT used:**
- No Jordan algebra structure (no Jordan product, no [a,b] commutator)
- No matrix multiplication or "ordinary product"
- No Luders formula (sqrt(a) b sqrt(a))
- No "common eigenbasis" (only "spectral decomposition" and "resolution of unity")
- No C*-algebraic functional calculus

**Key structural insight:** The central object is the Peirce 1-space projection P_1^{(a)} = id - sum_i C_{p_i}. Compatibility forces P_1^{(a)}(b) = 0 (Lemma 1), and conversely P_1^{(a)}(e) = 0 implies compatibility (Proposition 2). Both S6 and S7 then follow from the linearity of P_1^{(a)} and the fact that C_{p_i} commutes with every building block of sp(b, c).
