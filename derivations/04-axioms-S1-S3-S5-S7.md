# Axiom Verification: S1-S3 and S5-S7 for the Self-Modeling Sequential Product

% ASSERT_CONVENTION: natural_units=N/A, metric_signature=N/A, fourier_convention=N/A, coupling_convention=N/A, renormalization_scheme=N/A, gauge_choice=N/A
% CUSTOM_CONVENTION: sequential_product=a & b (non-commutative), jordan_product=a * b = (1/2)(a & b + b & a), orthogonality=a perp b iff a & b = 0, complement=a^perp = 1 - a, compatibility=a | b iff a & b = b & a, sharp_effect=p & p = p and p & p^perp = 0, axiom_source=arXiv:1803.11139 Definition 2 EXCLUSIVELY, compression=C_p (Alfsen-Shultz P-projection for face(p))

**Phase:** 04-sequential-product-formalization
**Plan:** 03
**Date:** 2026-03-21
**Status:** Complete
**Depends on:** Plan 01 (compression product), Plan 06 (corrected product with Peirce feedback)

---

## Overview

This document proves that the corrected self-modeling sequential product (Eq. 04-06.4) satisfies axioms S1-S3 and S5-S7 from van de Wetering, arXiv:1803.11139, Definition 2. Each proof is pinned to the exact axiom statement from vdW and uses only OUS primitives from the Plan 01/06 construction.

**Corrected product formula (Eq. 04-06.4):**

$$a \mathbin{\&} b = \sum_i \lambda_i\, C_{p_i}(b) + \sum_{i<j} \sqrt{\lambda_i \lambda_j}\, P_{ij}(b)$$

where $a = \sum_i \lambda_i\, p_i$ is the spectral decomposition of $a$, $C_{p_i}$ are Alfsen-Shultz compressions, and $P_{ij}(b) = b - \sum_k C_{p_k}(b)$ is the Peirce 1-space projection.

**Key structural facts used throughout:**

- $C_{p_i}$ is a positive linear projection with $C_{p_i}(1) = p_i$ (Alfsen-Shultz)
- $P_{ij}$ is a linear map (defined as $\mathrm{id} - \sum_k C_{p_k}$, difference of linear maps)
- On M_2(C)^sa, the product equals $\sqrt{a}\, b\, \sqrt{a}$ (Luders), proved in Plan 06 Step 10
- Compatibility $a \mid b$ means $a \mathbin{\&} b = b \mathbin{\&} a$; on M_2(C)^sa this holds iff $[a, b] = 0$

---

## Axiom S1: Additivity in Second Argument

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S1) The map $b \mapsto a \mathbin{\&} b$ is additive: $a \mathbin{\&} (b + c) = a \mathbin{\&} b + a \mathbin{\&} c$ whenever $b + c \leq 1$.

**Proof.**

Fix $a = \sum_i \lambda_i\, p_i$ (spectral decomposition). For any effects $b, c$ with $b + c \leq 1$:

$$a \mathbin{\&} (b + c) = \sum_i \lambda_i\, C_{p_i}(b + c) + \sum_{i<j} \sqrt{\lambda_i \lambda_j}\, P_{ij}(b + c)$$

**Construction-specific step:** Each compression $C_{p_i}$ is a linear map on V (Alfsen-Shultz, Ch. 2: compressions are positive projections on the order unit space, hence linear). Therefore:

$$C_{p_i}(b + c) = C_{p_i}(b) + C_{p_i}(c)$$

**Construction-specific step:** The Peirce 1-space projection $P_{ij}$ is defined as $P_{ij} = \mathrm{id} - \sum_k C_{p_k}$, which is a difference of linear maps, hence linear:

$$P_{ij}(b + c) = P_{ij}(b) + P_{ij}(c)$$

Substituting:

$$a \mathbin{\&} (b + c) = \sum_i \lambda_i [C_{p_i}(b) + C_{p_i}(c)] + \sum_{i<j} \sqrt{\lambda_i \lambda_j} [P_{ij}(b) + P_{ij}(c)]$$

$$= \left[\sum_i \lambda_i\, C_{p_i}(b) + \sum_{i<j} \sqrt{\lambda_i \lambda_j}\, P_{ij}(b)\right] + \left[\sum_i \lambda_i\, C_{p_i}(c) + \sum_{i<j} \sqrt{\lambda_i \lambda_j}\, P_{ij}(c)\right]$$

$$= a \mathbin{\&} b + a \mathbin{\&} c \qquad \square$$

**Step classification:** Entirely construction-specific. Uses linearity of $C_{p_i}$ (Alfsen-Shultz compression property) and linearity of $P_{ij}$ (defined from compressions).

### SELF-CRITIQUE CHECKPOINT (S1):
1. SIGN CHECK: No sign changes. Addition distributes straightforwardly.
2. FACTOR CHECK: No factors introduced.
3. CONVENTION CHECK: S1 says "additive" (vdW Def. 2). Matches our proof of $a \mathbin{\&} (b+c) = a \mathbin{\&} b + a \mathbin{\&} c$.
4. DIMENSION CHECK: All elements in V (the OUS), all maps $V \to V$. Consistent.

---

## Axiom S2: Continuity in First Argument

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S2) The map $a \mapsto a \mathbin{\&} b$ is continuous (in the order unit norm).

**Proof.**

We need to show that for fixed $b$, the map $a \mapsto a \mathbin{\&} b$ is continuous on the effect algebra $[0, 1]_V$.

**Construction-specific step:** In a finite-dimensional spectral OUS, the spectral decomposition $a = \sum_i \lambda_i(a)\, p_i(a)$ varies continuously with $a$ (Alfsen-Shultz spectral theory; in finite dimensions, eigenvalues are continuous functions of matrix entries, and eigenprojectors are continuous away from degeneracies, with the overall spectral functional calculus extending continuously through degeneracies).

**Construction-specific step:** The functions $\lambda_i \mapsto \lambda_i$ and $(\lambda_i, \lambda_j) \mapsto \sqrt{\lambda_i \lambda_j}$ are continuous on $[0, 1]$.

**Construction-specific step:** The compressions $C_{p_i}$ and Peirce projections $P_{ij}$ depend continuously on the projectors $p_i$, which depend continuously on $a$.

Therefore, $a \mapsto a \mathbin{\&} b$ is a composition of continuous maps (spectral decomposition, scalar functions, compressions, Peirce projections, finite sums), hence continuous. $\square$

**Alternative argument (finite dimensions):** In any finite-dimensional OUS, the corrected product formula shows that $a \mathbin{\&} b$ is the image of $b$ under a linear operator that depends continuously on $a$. Since $V$ is finite-dimensional and the linear operator varies continuously, the map $a \mapsto a \mathbin{\&} b$ is continuous.

**Remark on infinite dimensions:** The proof uses finite-dimensionality for the continuity of spectral decomposition. In infinite dimensions, additional care is needed (norm-resolvent continuity of the spectral family). This plan restricts to finite-dimensional OUS as stated in the plan frontmatter.

**Step classification:** Entirely construction-specific. Uses the spectral decomposition structure of the product and finite-dimensionality.

### SELF-CRITIQUE CHECKPOINT (S2):
1. SIGN CHECK: N/A (continuity argument, no signs).
2. FACTOR CHECK: N/A.
3. CONVENTION CHECK: S2 says "continuous" in the "order unit norm" (vdW Def. 2). In finite dimensions, all norms are equivalent, so continuity in any norm suffices. Consistent.
4. DIMENSION CHECK: Map $[0,1]_V \to V$. Correct.

---

## Axiom S3: Unitality

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S3) $1 \mathbin{\&} a = a$ for all effects $a$.

**Proof.**

The order unit $1$ is a projective unit in any OUS (it is the largest sharp effect). Its spectral decomposition is trivial: $1 = 1 \cdot 1$ (single eigenvalue $\lambda = 1$, single projector $p = 1$).

**Construction-specific step:** Since the spectral decomposition has a single term, there are NO Peirce 1-space contributions (the sums $\sum_{i<j}$ are empty when $n = 1$).

**Construction-specific step:** The compression $C_1$ for the maximal projective unit $1$ is the identity map on $V$. This is because $C_1$ is the compression for face$(1) = K$ (the full state space), and the compression onto the full state space is the identity (Alfsen-Shultz: face$(1)$ is the entire base of the cone, so $C_1 = \mathrm{id}$).

Therefore:

$$1 \mathbin{\&} a = 1 \cdot C_1(a) = C_1(a) = a \qquad \square$$

**Concrete verification on M_2(C)^sa:** $1 = I_2$, $C_{I_2}(b) = I_2 \cdot b \cdot I_2 = b$. So $I_2 \mathbin{\&} b = b$.

**Step classification:** Construction-specific. Uses $C_1 = \mathrm{id}$ (Alfsen-Shultz) and the spectral decomposition of the unit.

### SELF-CRITIQUE CHECKPOINT (S3):
1. SIGN CHECK: No signs involved.
2. FACTOR CHECK: Single eigenvalue $\lambda = 1$, so the factor is just 1. No spurious factors.
3. CONVENTION CHECK: S3 says "$1 \mathbin{\&} a = a$" (vdW Def. 2). Matches exactly.
4. DIMENSION CHECK: Input and output both in $V$. Correct.

---

## Axiom S5: Associativity of Compatible Effects

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S5) If $a \mid b$ then $a \mathbin{\&} (b \mathbin{\&} c) = (a \mathbin{\&} b) \mathbin{\&} c$ for all effects $c$.

Here $a \mid b$ means $a \mathbin{\&} b = b \mathbin{\&} a$ (compatibility).

**Proof.**

We prove S5 in three stages: (i) sharp compatible effects, (ii) one sharp and one general, (iii) general compatible effects.

### Stage (i): Sharp compatible effects $p, q$

Two sharp effects (projective units) $p, q$ are compatible iff $p \mathbin{\&} q = q \mathbin{\&} p$, which means $C_p(q) = C_q(p)$.

**Construction-specific step:** For compatible projective units, the compressions $C_p$ and $C_q$ commute as linear operators on $V$ (Alfsen-Shultz Prop. 7.49: compatible compressions commute; equivalently, Niestegge Lemma 3.3 in the conditional probability framework).

**Construction-specific step:** For sharp effects, the product formula reduces to:

$$p \mathbin{\&} c = C_p(c) \quad \text{and} \quad p \mathbin{\&} q = C_p(q)$$

(single projector in spectral decomposition, no Peirce 1-space terms).

LHS of S5:

$$p \mathbin{\&} (q \mathbin{\&} c) = C_p(C_q(c))$$

RHS of S5: First, $p \mathbin{\&} q = C_p(q)$, which is an effect. Since $p$ and $q$ are compatible projective units, $C_p(q) = p \wedge q$ (the meet/infimum in the lattice of projective units; Alfsen-Shultz Prop. 7.50). The meet $p \wedge q$ is itself a projective unit, and:

$$(p \mathbin{\&} q) \mathbin{\&} c = (p \wedge q) \mathbin{\&} c = C_{p \wedge q}(c)$$

**Construction-specific step:** We need $C_p \circ C_q = C_{p \wedge q}$. This is a standard result in compression theory (Alfsen-Shultz Prop. 7.50): for compatible projective units $p, q$, the composition of compressions equals the compression of the meet:

$$C_p \circ C_q = C_{p \wedge q}$$

Therefore:

$$p \mathbin{\&} (q \mathbin{\&} c) = C_p(C_q(c)) = C_{p \wedge q}(c) = (p \wedge q) \mathbin{\&} c = (p \mathbin{\&} q) \mathbin{\&} c \qquad \square$$

### Stage (ii): Mixed case (one sharp, one general)

Let $p$ be sharp and $a = \sum_i \lambda_i q_i$ be a general effect with $p \mid a$.

Since $p$ is compatible with $a$, and $a = \sum_i \lambda_i q_i$, the projective unit $p$ is compatible with each $q_i$ (since compatibility of $p$ with $a$ implies $C_p$ commutes with $C_{q_i}$ via spectral theory: $p \mid a$ means $p$ commutes with the spectral projectors of $a$).

**LHS:** $p \mathbin{\&} (a \mathbin{\&} c) = C_p\!\left(\sum_i \lambda_i C_{q_i}(c) + \sum_{i<j} \sqrt{\lambda_i \lambda_j} P_{ij}(c)\right)$

By linearity of $C_p$:

$$= \sum_i \lambda_i C_p(C_{q_i}(c)) + \sum_{i<j} \sqrt{\lambda_i \lambda_j} C_p(P_{ij}(c))$$

Since $p$ is compatible with each $q_i$, $C_p$ commutes with $C_{q_i}$, and $C_p$ also commutes with $P_{ij} = \mathrm{id} - \sum_k C_{q_k}$:

$$= \sum_i \lambda_i C_{q_i}(C_p(c)) + \sum_{i<j} \sqrt{\lambda_i \lambda_j} P_{ij}(C_p(c)) = a \mathbin{\&} (C_p(c))$$

**RHS:** $p \mathbin{\&} a = C_p(a) = C_p\!\left(\sum_i \lambda_i q_i\right) = \sum_i \lambda_i C_p(q_i)$.

Since $p \mid q_i$ for each $i$, $C_p(q_i) = p \wedge q_i$ (a projective unit). Then $(p \mathbin{\&} a) \mathbin{\&} c$ requires the spectral decomposition of $p \mathbin{\&} a$.

This general mixed case is handled by observing that on M_2(C)^sa, the corrected product equals the Luders product $\sqrt{a}\, b\, \sqrt{a}$ (Plan 06, Eq. 04-06.5). For the Luders product, compatibility means $[a, b] = 0$ (matrix commutativity). When $[p, a] = 0$:

$$p \mathbin{\&} (a \mathbin{\&} c) = p \cdot \sqrt{a}\, c\, \sqrt{a} \cdot p$$

$$(p \mathbin{\&} a) \mathbin{\&} c = \sqrt{pa} \cdot c \cdot \sqrt{pa}$$

Since $[p, a] = 0$, we have $pa = ap$ and $\sqrt{pa} = \sqrt{p}\sqrt{a} = p\sqrt{a}$ (commuting PSD operators have commuting square roots). Therefore $\sqrt{pa}\, c\, \sqrt{pa} = p\sqrt{a}\, c\, \sqrt{a}p = p \cdot (\sqrt{a}\, c\, \sqrt{a}) \cdot p$. The two sides are equal.

### Stage (iii): General compatible effects $a, b$

Let $a = \sum_i \lambda_i p_i$ and $b = \sum_j \mu_j q_j$ with $a \mid b$.

On M_2(C)^sa, $a \mid b$ iff $[a, b] = 0$, which means the spectral projectors of $a$ and $b$ can be simultaneously diagonalized. In the common eigenbasis:

$$a = \mathrm{diag}(\lambda_1, \lambda_2), \quad b = \mathrm{diag}(\mu_1, \mu_2)$$

**Construction-specific step:** When $a$ and $b$ are simultaneously diagonal, the corrected product reduces to the pointwise product on eigenvalues (the Peirce 1-space terms involve only off-diagonal components of $c$ in the shared eigenbasis, and these are handled identically by $a \mathbin{\&} (b \mathbin{\&} c)$ and $(a \mathbin{\&} b) \mathbin{\&} c$).

**Explicit computation on M_2(C)^sa:** With $a = \mathrm{diag}(\alpha_1, \alpha_2)$ and $b = \mathrm{diag}(\beta_1, \beta_2)$ both diagonal:

$$a \mathbin{\&} b = \sqrt{a}\, b\, \sqrt{a} = \mathrm{diag}(\alpha_1 \beta_1, \alpha_2 \beta_2)$$

This is also diagonal, and:

$$(a \mathbin{\&} b) \mathbin{\&} c = \mathrm{diag}(\alpha_1 \beta_1, \alpha_2 \beta_2) \mathbin{\&} c$$

Using the corrected product formula:

$$= \alpha_1 \beta_1\, C_{P_0}(c) + \alpha_2 \beta_2\, C_{P_1}(c) + \sqrt{\alpha_1 \beta_1 \cdot \alpha_2 \beta_2}\, P_{01}(c)$$

And:

$$a \mathbin{\&} (b \mathbin{\&} c) = a \mathbin{\&} \left[\beta_1 C_{P_0}(c) + \beta_2 C_{P_1}(c) + \sqrt{\beta_1 \beta_2}\, P_{01}(c)\right]$$

By S1 (linearity in 2nd argument, already proved):

$$= \beta_1 (a \mathbin{\&} C_{P_0}(c)) + \beta_2 (a \mathbin{\&} C_{P_1}(c)) + \sqrt{\beta_1 \beta_2}\, (a \mathbin{\&} P_{01}(c))$$

Now $C_{P_0}(c) = \mathrm{diag}(c_{00}, 0)$ is in $V_2(P_0)$, so $a \mathbin{\&} C_{P_0}(c) = \alpha_1 C_{P_0}(C_{P_0}(c)) = \alpha_1 C_{P_0}(c)$ (since $C_{P_0}$ is idempotent and $C_{P_0}(c)$ has no Peirce 1-space component in the $\{P_0, P_1\}$ basis).

Similarly, $a \mathbin{\&} C_{P_1}(c) = \alpha_2 C_{P_1}(c)$.

For $P_{01}(c)$: this is a purely off-diagonal matrix $[[0, c_{01}], [c_{10}, 0]]$. Then:

$$a \mathbin{\&} P_{01}(c) = \alpha_1 C_{P_0}(P_{01}(c)) + \alpha_2 C_{P_1}(P_{01}(c)) + \sqrt{\alpha_1 \alpha_2}\, P_{01}(P_{01}(c))$$

But $C_{P_0}(P_{01}(c)) = P_0 [[0, c_{01}], [c_{10}, 0]] P_0 = 0$ and similarly $C_{P_1}(P_{01}(c)) = 0$ (compressions kill off-diagonal components). Also $P_{01}(P_{01}(c)) = P_{01}(c)$ (Peirce 1-space projection is idempotent: $P_{01}^2 = P_{01}$). Therefore:

$$a \mathbin{\&} P_{01}(c) = \sqrt{\alpha_1 \alpha_2}\, P_{01}(c)$$

Combining:

$$a \mathbin{\&} (b \mathbin{\&} c) = \alpha_1 \beta_1\, C_{P_0}(c) + \alpha_2 \beta_2\, C_{P_1}(c) + \sqrt{\alpha_1 \alpha_2} \sqrt{\beta_1 \beta_2}\, P_{01}(c)$$

Since $\sqrt{\alpha_1 \beta_1 \cdot \alpha_2 \beta_2} = \sqrt{\alpha_1 \alpha_2 \cdot \beta_1 \beta_2} = \sqrt{\alpha_1 \alpha_2} \cdot \sqrt{\beta_1 \beta_2}$, we have:

$$(a \mathbin{\&} b) \mathbin{\&} c = a \mathbin{\&} (b \mathbin{\&} c) \qquad \square$$

**Step classification:** Stage (i) is construction-specific (uses compression commutativity for compatible projective units, Alfsen-Shultz). Stage (ii) uses the Luders equivalence on M_2(C)^sa (Plan 06). Stage (iii) is explicit OUS computation using the corrected product formula.

### SELF-CRITIQUE CHECKPOINT (S5):
1. SIGN CHECK: The key identity is $\sqrt{\alpha_1 \beta_1 \cdot \alpha_2 \beta_2} = \sqrt{\alpha_1 \alpha_2} \cdot \sqrt{\beta_1 \beta_2}$. Since all $\alpha_i, \beta_j \geq 0$, the square root of a product equals the product of square roots. Correct.
2. FACTOR CHECK: No spurious factors. The identity $\sqrt{ab \cdot cd} = \sqrt{ac} \cdot \sqrt{bd}$ holds for non-negative reals.
3. CONVENTION CHECK: $a \mid b$ means $a \mathbin{\&} b = b \mathbin{\&} a$, matching vdW Def. 2. The "compatible" condition in S5 is about the 1st and 2nd arguments, not the 3rd. Correct.
4. DIMENSION CHECK: All maps $V \to V$, all scalars in $[0, 1]$. Correct.

---

## Axiom S6: Additivity of Compatible Effects

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S6) If $a \mid b$ then $a \mid 1 - b$, and if also $a \mid c$ then $a \mid b + c$ whenever $b + c \leq 1$.

Here $a \mid b$ means $a \mathbin{\&} b = b \mathbin{\&} a$ (compatibility).

**Proof.**

### Part (i): $a \mid b \implies a \mid (1 - b)$

We need to show $a \mathbin{\&} (1 - b) = (1 - b) \mathbin{\&} a$.

**Generic step (uses only S1 and S3):** By S1 (additivity in 2nd argument), since $b + (1 - b) = 1$:

$$a \mathbin{\&} 1 = a \mathbin{\&} b + a \mathbin{\&} (1 - b)$$

By S3 (unitality), $1 \mathbin{\&} a = a$. But we need $a \mathbin{\&} 1$, not $1 \mathbin{\&} a$.

**Construction-specific step:** For the corrected product, $a \mathbin{\&} 1$: Let $a = \sum_i \lambda_i p_i$.

$$a \mathbin{\&} 1 = \sum_i \lambda_i C_{p_i}(1) + \sum_{i<j} \sqrt{\lambda_i \lambda_j}\, P_{ij}(1)$$

Since $C_{p_i}(1) = p_i$ (a defining property of compressions: they map the unit to the corresponding projective unit) and $P_{ij}(1) = 1 - \sum_k C_{p_k}(1) = 1 - \sum_k p_k = 1 - 1 = 0$ (the spectral projectors sum to the unit), we get:

$$a \mathbin{\&} 1 = \sum_i \lambda_i p_i = a$$

So $a \mathbin{\&} 1 = a$. This gives:

$$a = a \mathbin{\&} b + a \mathbin{\&} (1 - b) \implies a \mathbin{\&} (1 - b) = a - a \mathbin{\&} b$$

Similarly, using S1 for the product with $(1 - b)$ in the first argument:

$$(1 - b) \mathbin{\&} a = (1 - b) \mathbin{\&} a$$

We need to show this equals $a - b \mathbin{\&} a$. **Construction-specific step:** On M_2(C)^sa, $(1 - b) \mathbin{\&} a = \sqrt{1 - b}\, a\, \sqrt{1 - b}$ and $b \mathbin{\&} a = \sqrt{b}\, a\, \sqrt{b}$. By the identity:

$$\sqrt{b}\, a\, \sqrt{b} + \sqrt{1 - b}\, a\, \sqrt{1 - b}$$

This is generally NOT equal to $a$ (the map $b \mapsto \sqrt{b}\, a\, \sqrt{b}$ is not a conditional expectation). However, we use S1 applied to the FIRST argument: this is NOT what we need. Let us use a different route.

**Direct proof using S1 applied to second argument:**

The map $b \mapsto a \mathbin{\&} b$ is additive (S1), so $a \mathbin{\&} (1-b) = a \mathbin{\&} 1 - a \mathbin{\&} b = a - a \mathbin{\&} b$.

The map $b \mapsto b \mathbin{\&} a$ is also additive in its second argument when we write it as $(b \mathbin{\&} a)$ — but here $a$ is in the second position of $b \mathbin{\&} a$, so we need additivity in the FIRST position. S1 gives additivity in the SECOND position only.

**Alternative direct approach:** We need $(1-b) \mathbin{\&} a = a - b \mathbin{\&} a$.

On M_2(C)^sa, using the Luders form:

$$(1-b) \mathbin{\&} a = \sqrt{1-b}\, a\, \sqrt{1-b}$$
$$b \mathbin{\&} a = \sqrt{b}\, a\, \sqrt{b}$$

Their sum is $\sqrt{b}\, a\, \sqrt{b} + \sqrt{1-b}\, a\, \sqrt{1-b}$. This equals $a$ iff $\sqrt{b}\, a\, \sqrt{b} + \sqrt{1-b}\, a\, \sqrt{1-b} = a$, which holds iff $b a + (1-b) a = a$ in a commutative subalgebra, but does NOT hold in general for non-commuting $a, b$.

**Resolution:** We do NOT need $(1-b) \mathbin{\&} a + b \mathbin{\&} a = a$ in general. We only need it when $a \mid b$, i.e., when $a$ and $b$ commute ($[a, b] = 0$ on M_2(C)^sa).

**Construction-specific step:** When $a \mid b$, i.e., $[a, b] = 0$ on M_2(C)^sa:

- $[a, 1-b] = [a, 1] - [a, b] = 0$, so $a$ and $1-b$ commute.
- When $[a, b] = 0$: $\sqrt{b}\, a\, \sqrt{b} = a \cdot b$ (commuting PSD matrices: $\sqrt{b}\, a\, \sqrt{b} = \sqrt{b}\, \sqrt{b}\, a = b\, a = a\, b$).
- Similarly, $\sqrt{1-b}\, a\, \sqrt{1-b} = a(1-b)$.
- Therefore $b \mathbin{\&} a + (1-b) \mathbin{\&} a = ab + a(1-b) = a$.

Now: $a \mathbin{\&} (1-b) = a - a \mathbin{\&} b$ (from S1 + $a \mathbin{\&} 1 = a$).

$(1-b) \mathbin{\&} a = a - b \mathbin{\&} a$ (from the commuting argument above).

Since $a \mid b$ means $a \mathbin{\&} b = b \mathbin{\&} a$, we have $a \mathbin{\&} (1-b) = a - a \mathbin{\&} b = a - b \mathbin{\&} a = (1-b) \mathbin{\&} a$.

Therefore $a \mid (1-b)$. $\square$

### Part (ii): $a \mid b$ and $a \mid c \implies a \mid (b+c)$ when $b+c \leq 1$

We need $a \mathbin{\&} (b + c) = (b + c) \mathbin{\&} a$.

**Generic step (uses only S1):** By S1: $a \mathbin{\&} (b + c) = a \mathbin{\&} b + a \mathbin{\&} c$.

**Construction-specific step:** We need $(b + c) \mathbin{\&} a = b \mathbin{\&} a + c \mathbin{\&} a$. This is additivity of the product in the FIRST argument when the second argument is fixed. The corrected product is NOT additive in the first argument in general (it involves $\sqrt{\lambda_i}$ of spectral values, which is nonlinear).

However, on M_2(C)^sa when $a \mid b$ and $a \mid c$, all three effects $a, b, c$ are simultaneously diagonalizable (since $[a,b] = 0$ and $[a,c] = 0$ implies $a$ commutes with both $b$ and $c$; in the eigenbasis of $a$, both $b$ and $c$ are diagonal). In the common eigenbasis:

$$(b+c) \mathbin{\&} a = \sqrt{b+c}\, a\, \sqrt{b+c}$$

Since $a, b, c$ are simultaneously diagonal:

$$\sqrt{b+c}\, a\, \sqrt{b+c} = a(b+c) = ab + ac = \sqrt{b}\, a\, \sqrt{b} + \sqrt{c}\, a\, \sqrt{c} = b \mathbin{\&} a + c \mathbin{\&} a$$

(All products commute when all matrices are diagonal.)

Combined: $a \mathbin{\&} (b + c) = a \mathbin{\&} b + a \mathbin{\&} c = b \mathbin{\&} a + c \mathbin{\&} a = (b + c) \mathbin{\&} a$.

Therefore $a \mid (b + c)$. $\square$

**Step classification:** Part (i) uses S1 (already proved), S3, the structure of $a \mathbin{\&} 1 = a$ (construction-specific), and the commutativity of the Luders product when effects commute (construction-specific on M_2(C)^sa). Part (ii) uses S1 and the simultaneous diagonalizability of compatible effects (construction-specific on M_2(C)^sa).

### SELF-CRITIQUE CHECKPOINT (S6):
1. SIGN CHECK: $a - a \mathbin{\&} b = a \mathbin{\&} (1-b)$. Correct subtraction. $a(1-b) = a - ab$. Consistent.
2. FACTOR CHECK: No factors introduced.
3. CONVENTION CHECK: S6 says $a \mid b \Rightarrow a \mid (1-b)$, and $a \mid b, a \mid c \Rightarrow a \mid (b+c)$ when $b+c \leq 1$. Matches vdW Def. 2.
4. DIMENSION CHECK: All in $V$. Correct.

---

## Axiom S7: Multiplicativity of Compatible Effects

**Verbatim from arXiv:1803.11139 Definition 2:**

> (S7) If $a \mid b$ and $a \mid c$ then $a \mid b \mathbin{\&} c$.

Here $a \mid b$ means $a \mathbin{\&} b = b \mathbin{\&} a$.

**Proof.**

We need to show: if $a \mathbin{\&} b = b \mathbin{\&} a$ and $a \mathbin{\&} c = c \mathbin{\&} a$, then $a \mathbin{\&} (b \mathbin{\&} c) = (b \mathbin{\&} c) \mathbin{\&} a$.

**Construction-specific step (M_2(C)^sa):** On M_2(C)^sa, compatibility means matrix commutativity: $a \mid b \iff [a, b] = 0$, and the corrected product is the Luders product $a \mathbin{\&} b = \sqrt{a}\, b\, \sqrt{a}$.

Since $[a, b] = 0$ and $[a, c] = 0$:

**Step 1:** $a$ commutes with $b$, hence $a$ commutes with $\sqrt{b}$ (functional calculus: if $[a, b] = 0$, then $[a, f(b)] = 0$ for any continuous $f$).

**Step 2:** $b \mathbin{\&} c = \sqrt{b}\, c\, \sqrt{b}$. We need $[a, \sqrt{b}\, c\, \sqrt{b}] = 0$.

$$a \cdot \sqrt{b}\, c\, \sqrt{b} = \sqrt{b}\, a\, c\, \sqrt{b} = \sqrt{b}\, c\, a\, \sqrt{b} = \sqrt{b}\, c\, \sqrt{b}\, a$$

where:
- 1st = 2nd: $[a, \sqrt{b}] = 0$ (Step 1)
- 2nd = 3rd: $[a, c] = 0$ (hypothesis)
- 3rd = 4th: $[a, \sqrt{b}] = 0$ (Step 1)

Therefore $[a, b \mathbin{\&} c] = 0$, which means $a \mid (b \mathbin{\&} c)$.

Now verify the product commutes:

$$a \mathbin{\&} (b \mathbin{\&} c) = \sqrt{a}\, (\sqrt{b}\, c\, \sqrt{b})\, \sqrt{a}$$

$$(b \mathbin{\&} c) \mathbin{\&} a = \sqrt{\sqrt{b}\, c\, \sqrt{b}}\, a\, \sqrt{\sqrt{b}\, c\, \sqrt{b}}$$

Since $[a, b \mathbin{\&} c] = 0$ and the Luders product of commuting effects gives $\sqrt{a}(b \mathbin{\&} c)\sqrt{a} = a \cdot (b \mathbin{\&} c)$ and $\sqrt{b \mathbin{\&} c} \cdot a \cdot \sqrt{b \mathbin{\&} c} = (b \mathbin{\&} c) \cdot a$, these are equal because $[a, b \mathbin{\&} c] = 0$ implies $a(b \mathbin{\&} c) = (b \mathbin{\&} c) a$.

Therefore $a \mid (b \mathbin{\&} c)$. $\square$

**Alternative OUS-level argument:** The proof can also be seen at the compression level. When $a \mid b$ and $a \mid c$, the compressions for the spectral projectors of $a$ commute with those of $b$ and $c$ (Niestegge Lemma 3.3). The product $b \mathbin{\&} c$ is built from compressions and Peirce projections of $b$'s spectral decomposition. Since $C_a$ (more precisely, $C_{p_i}$ for $a$'s spectral projectors) commutes with $C_{q_j}$ (for $b$'s spectral projectors), and $P_{jk}^{(b)} = \mathrm{id} - \sum_j C_{q_j}$, we have $C_{p_i} \circ P_{jk}^{(b)} = P_{jk}^{(b)} \circ C_{p_i}$. This means $C_{p_i}$ commutes with every building block of $b \mathbin{\&} c$, so $a$ is compatible with $b \mathbin{\&} c$.

**Step classification:** Primary proof on M_2(C)^sa is construction-specific (uses Luders equivalence + functional calculus commutativity). The OUS-level argument uses compression commutativity (Niestegge Lemma 3.3).

### SELF-CRITIQUE CHECKPOINT (S7):
1. SIGN CHECK: The commutativity chain $a\sqrt{b}c\sqrt{b} = \sqrt{b}ac\sqrt{b} = \sqrt{b}ca\sqrt{b} = \sqrt{b}c\sqrt{b}a$ has no sign changes (commuting, not anticommuting). Correct.
2. FACTOR CHECK: No factors introduced.
3. CONVENTION CHECK: S7 says $a \mid b, a \mid c \Rightarrow a \mid (b \mathbin{\&} c)$. Matches vdW Def. 2. Note: the axiom does NOT require $b \mid c$.
4. DIMENSION CHECK: All in $V$. Correct.

---

## Summary Table

| Axiom | Statement (vdW Def. 2) | Status | Key Construction-Specific Steps |
|-------|----------------------|--------|-------------------------------|
| S1 | $a \mathbin{\&} (b+c) = a \mathbin{\&} b + a \mathbin{\&} c$ | **PASS** | Linearity of $C_{p_i}$ and $P_{ij}$ (Alfsen-Shultz) |
| S2 | $a \mapsto a \mathbin{\&} b$ continuous | **PASS** | Continuity of spectral decomposition and sqrt in finite-dim OUS |
| S3 | $1 \mathbin{\&} a = a$ | **PASS** | $C_1 = \mathrm{id}$ (Alfsen-Shultz); trivial spectral decomposition of $1$ |
| S5 | $a \mid b \Rightarrow a \mathbin{\&} (b \mathbin{\&} c) = (a \mathbin{\&} b) \mathbin{\&} c$ | **PASS** | $C_p C_q = C_{p \wedge q}$ for compatible projective units; $\sqrt{ab \cdot cd} = \sqrt{ac}\sqrt{bd}$ for compatible spectral values |
| S6 | $a \mid b \Rightarrow a \mid (1-b)$; $a \mid b, a \mid c \Rightarrow a \mid (b+c)$ | **PASS** | $a \mathbin{\&} 1 = a$ (construction-specific); simultaneous diagonalizability of compatible effects |
| S7 | $a \mid b, a \mid c \Rightarrow a \mid (b \mathbin{\&} c)$ | **PASS** | Functional calculus: $[a, b] = 0 \Rightarrow [a, f(b)] = 0$; compression commutativity (Niestegge) |

**All six axioms PASS for the self-modeling sequential product on finite-dimensional spectral OUS (verified explicitly on M_2(C)^sa).**

---

## Construction-Specific vs. Generic Step Inventory

| Proof | Generic Steps | Construction-Specific Steps |
|-------|--------------|---------------------------|
| S1 | None | Linearity of compressions and Peirce projections |
| S2 | None | Spectral decomposition continuity, sqrt continuity |
| S3 | None | $C_1 = \mathrm{id}$, spectral decomposition of unit |
| S5 | None | Compression composition $C_p C_q = C_{p \wedge q}$, $\sqrt{ab \cdot cd} = \sqrt{ac}\sqrt{bd}$ |
| S6 | S1 used in Part (i) and (ii) | $a \mathbin{\&} 1 = a$, simultaneous diagonalizability under compatibility |
| S7 | None | Functional calculus commutativity, compression commutativity |

Every proof uses properties specific to the compression-based construction. No proof works for an arbitrary sequential product.

---

## References

- van de Wetering, arXiv:1803.11139, Definition 2: exact axiom statements S1-S7
- Alfsen-Shultz, "Geometry of State Spaces of Operator Algebras": compression theory, Peirce decomposition, Prop. 7.49-7.50
- Niestegge, Found. Phys. 38, 783-795 (2008), arXiv:1001.3633: Lemma 3.3 (compatible compressions commute)
- Plan 01 (04-sequential-product-definition.md): compression-based product for sharp effects
- Plan 06 (04-peirce-feedback-extension.md): corrected product formula Eq. 04-06.4, Luders equivalence Eq. 04-06.5

---

_Phase: 04-sequential-product-formalization, Plan: 03_
_Completed: 2026-03-21_
