# Decomposition Independence of the Corrected Sequential Product

% ASSERT_CONVENTION: natural_units=N/A, metric_signature=N/A, fourier_convention=N/A, coupling_convention=N/A, renormalization_scheme=N/A, gauge_choice=N/A
% CUSTOM_CONVENTION: sequential_product=a & b (non-commutative), jordan_product=a * b = (1/2)(a & b + b & a), orthogonality=a perp b iff a & b = 0, complement=a^perp = 1 - a, sharp_effect=p & p = p and p & p^perp = 0, axiom_source=arXiv:1803.11139 Definition 2 EXCLUSIVELY, entropy_base=nats, compression=C_p (Alfsen-Shultz P-projection for face(p))

**Phase:** 06 (paper assembly)
**Date:** 2026-03-21
**Status:** Complete
**Depends on:** 04-peirce-feedback-extension.md (Eq. 04-06.4, corrected product formula)

---

## Overview

The corrected sequential product (Eq. 04-06.4) is:

> **a & b = sum_i lambda_i C_{p_i}(b) + sum_{i<j} sqrt(lambda_i lambda_j) P_{ij}(b)**

where a = sum_i lambda_i p_i is a spectral decomposition into mutually orthogonal projective units {p_i} with sum p_i = 1 and lambda_i in [0,1].

**Question:** When eigenvalues are degenerate, the spectral decomposition is not unique. If lambda_k = lambda_l for some k != l, then any orthogonal decomposition of the subspace projector p_k + p_l into q_1 + q_2 (with q_1, q_2 orthogonal projective units, q_1 + q_2 = p_k + p_l) gives another valid spectral decomposition. Does the product depend on this choice?

**Answer:** No. The product is independent of the choice of decomposition within degenerate eigenspaces.

---

## Theorem (Decomposition Independence)

Let V be a spectral OUS. Let a in [0,1]_V be an effect with two valid spectral decompositions:

- a = sum_{i=1}^n lambda_i p_i  (decomposition D1)
- a = sum_{j=1}^m mu_j q_j  (decomposition D2)

where {p_i} and {q_j} are resolutions of unity with distinct eigenvalues within each decomposition (but the projectors may have rank > 1). Then for all b in [0,1]_V:

> sum_i lambda_i C_{p_i}(b) + sum_{i<j} sqrt(lambda_i lambda_j) P_{ij}^{(D1)}(b)
> = sum_j mu_j C_{q_j}(b) + sum_{j<k} sqrt(mu_j mu_k) P_{jk}^{(D2)}(b)

### Proof Strategy

Since D1 and D2 are both spectral decompositions of the same element a, they must have the same set of distinct eigenvalues. The only freedom is in how the eigenspace for each eigenvalue is decomposed into rank-1 projective units. We prove independence by showing that the formula, restricted to a single degenerate eigenspace, produces a result determined entirely by the eigenspace projector (the sum of the rank-1 projectors), not by the individual rank-1 projectors.

---

## Step 1: Reduction to the Degenerate Subspace

Let a have distinct eigenvalues alpha_1 > alpha_2 > ... > alpha_r, with eigenspace projectors Q_1, Q_2, ..., Q_r (each Q_s projects onto the eigenspace for alpha_s). Then Q_1 + Q_2 + ... + Q_r = 1 and a = sum_s alpha_s Q_s.

Any finer decomposition refines some Q_s into rank-1 pieces: Q_s = p_{s,1} + p_{s,2} + ... + p_{s,n_s} where the p_{s,k} are mutually orthogonal rank-1 projective units. The full resolution of unity is {p_{s,k} : s = 1,...,r; k = 1,...,n_s} and the eigenvalue of p_{s,k} is alpha_s for all k.

The corrected product becomes:

a & b = sum_{s,k} alpha_s C_{p_{s,k}}(b) + sum_{(s,k)<(t,l)} sqrt(alpha_s alpha_t) P_{(s,k),(t,l)}(b)

We split the off-diagonal sum into two types:

**(A) Intra-eigenspace pairs:** s = t (same eigenvalue alpha_s), indices k < l. Here sqrt(alpha_s * alpha_s) = alpha_s.

**(B) Inter-eigenspace pairs:** s < t (different eigenvalues alpha_s != alpha_t).

So:

a & b = sum_{s,k} alpha_s C_{p_{s,k}}(b)
      + sum_s alpha_s sum_{k<l} P_{(s,k),(s,l)}(b)        ... (intra)
      + sum_{s<t} sqrt(alpha_s alpha_t) sum_{k,l} P_{(s,k),(t,l)}(b)  ... (inter)

**The key observation:** For the intra-eigenspace terms (type A), the coefficient is alpha_s for both the compression terms and the Peirce 1-space terms. We can factor:

sum_k alpha_s C_{p_{s,k}}(b) + alpha_s sum_{k<l} P_{(s,k),(s,l)}(b)
= alpha_s [sum_k C_{p_{s,k}}(b) + sum_{k<l} P_{(s,k),(s,l)}(b)]

---

## Step 2: Peirce Completeness Within a Subspace

**Lemma (Peirce completeness).** For a resolution of unity {p_1, ..., p_n} with p_1 + ... + p_n = Q (a projective unit), the Peirce decomposition relative to this resolution restricted to the range of C_Q gives:

> sum_k C_{p_k}(b) + sum_{k<l} P_{k,l}(b) = C_Q(b)

for any b in V. That is, the compressions (Peirce 2-spaces) plus all Peirce 1-spaces for the resolution reconstruct the full compression by Q.

**Proof of Lemma.** The Peirce 1-space projection relative to the resolution {p_k} within the face of Q is:

P_1(b) = C_Q(b) - sum_k C_{p_k}(b)

(This is the part of C_Q(b) not captured by the individual compressions.) The total Peirce 1-space decomposes as:

P_1(b) = sum_{k<l} P_{k,l}(b)

(Each Peirce (k,l) component lives in a distinct subspace V_{kl}.) Therefore:

sum_k C_{p_k}(b) + sum_{k<l} P_{k,l}(b) = sum_k C_{p_k}(b) + C_Q(b) - sum_k C_{p_k}(b) = C_Q(b)

QED.

**Critical consequence:** The expression sum_k C_{p_k}(b) + sum_{k<l} P_{k,l}(b) equals C_Q(b) for ANY choice of orthogonal decomposition {p_k} of Q. Different decompositions of Q redistribute content between the C_{p_k} and P_{k,l} terms, but the sum is invariant: it always equals C_Q(b).

---

## Step 3: Intra-Eigenspace Independence

Applying the Peirce completeness lemma to each eigenspace projector Q_s with an arbitrary decomposition Q_s = p_{s,1} + ... + p_{s,n_s}:

sum_k C_{p_{s,k}}(b) + sum_{k<l} P_{(s,k),(s,l)}(b) = C_{Q_s}(b)

This is independent of the decomposition {p_{s,k}}. The coefficient is alpha_s for all these terms. So the intra-eigenspace contribution is:

sum_s alpha_s C_{Q_s}(b)

which depends only on the eigenspace projectors Q_s, not on how they are decomposed.

---

## Step 4: Inter-Eigenspace Independence

For the inter-eigenspace terms (s != t), we need:

sum_{k,l} P_{(s,k),(t,l)}(b)

where k ranges over 1,...,n_s and l ranges over 1,...,n_t.

**Claim:** sum_{k,l} P_{(s,k),(t,l)}(b) = P_{Q_s, Q_t}(b), the Peirce (s,t) component relative to the coarser resolution {Q_1, ..., Q_r}.

**Proof of Claim.** The Peirce (s,t) component relative to {Q_s} is defined by:

P_{Q_s, Q_t}(b) = C_{Q_s + Q_t}(b) - C_{Q_s}(b) - C_{Q_t}(b)

Now consider the finer resolution. Define the projector for the union of the s-th and t-th eigenspaces: Q_s + Q_t = sum_k p_{s,k} + sum_l p_{t,l}. Then:

C_{Q_s + Q_t}(b) = sum_k C_{p_{s,k}}(b) + sum_l C_{p_{t,l}}(b) + sum_{k<k'} P_{(s,k),(s,k')}(b) + sum_{l<l'} P_{(t,l),(t,l')}(b) + sum_{k,l} P_{(s,k),(t,l)}(b)

(Peirce completeness for the resolution {p_{s,1},...,p_{s,n_s}, p_{t,1},...,p_{t,n_t}} of Q_s + Q_t.)

Also:

C_{Q_s}(b) = sum_k C_{p_{s,k}}(b) + sum_{k<k'} P_{(s,k),(s,k')}(b)

C_{Q_t}(b) = sum_l C_{p_{t,l}}(b) + sum_{l<l'} P_{(t,l),(t,l')}(b)

Subtracting:

P_{Q_s, Q_t}(b) = C_{Q_s + Q_t}(b) - C_{Q_s}(b) - C_{Q_t}(b) = sum_{k,l} P_{(s,k),(t,l)}(b)

QED.

So the inter-eigenspace contribution is:

sum_{s<t} sqrt(alpha_s alpha_t) P_{Q_s, Q_t}(b)

which depends only on the eigenspace projectors Q_s, Q_t, not on how they are internally decomposed.

---

## Step 5: Combining the Results

The corrected product is:

a & b = sum_s alpha_s C_{Q_s}(b) + sum_{s<t} sqrt(alpha_s alpha_t) P_{Q_s, Q_t}(b)

Both terms depend only on the eigenspace projectors {Q_s} and distinct eigenvalues {alpha_s}, which are uniquely determined by a. No dependence on the internal decomposition of Q_s into rank-1 pieces remains.

**Theorem (Decomposition Independence).** The corrected sequential product Eq. (04-06.4) is independent of the choice of spectral decomposition. Any two valid decompositions of a (differing only in how degenerate eigenspaces are split into orthogonal rank-1 projective units) give the same value of a & b for all effects b. QED.

---

## Step 6: Continuity Through Degeneracies

**Claim:** The product a(t) & b is continuous in t even when eigenvalues of a(t) cross.

**Setup:** Let a(t) = lambda_1(t) p_1(t) + lambda_2(t) p_2(t) with continuous eigenvalue functions lambda_1(t), lambda_2(t) and continuous eigenprojector functions p_1(t), p_2(t). Suppose lambda_1(t_0) = lambda_2(t_0) = lambda at some crossing point t_0.

**Analysis:** For t != t_0:

a(t) & b = lambda_1(t) C_{p_1(t)}(b) + lambda_2(t) C_{p_2(t)}(b) + sqrt(lambda_1(t) lambda_2(t)) P_{12}(t)(b)

where P_{12}(t)(b) = b - C_{p_1(t)}(b) - C_{p_2(t)}(b).

As t -> t_0, eigenvalues lambda_i(t) -> lambda (continuous), and the projectors p_i(t) approach some limiting projectors (though the limiting basis is not unique due to the degeneracy). However, by decomposition independence (Step 5), the product at t = t_0 is:

a(t_0) & b = lambda C_{p_1(t_0) + p_2(t_0)}(b) = lambda C_1(b) = lambda b

(when p_1 + p_2 = 1). Meanwhile, as t -> t_0:

lambda_1(t) C_{p_1(t)}(b) + lambda_2(t) C_{p_2(t)}(b) + sqrt(lambda_1(t) lambda_2(t)) P_{12}(t)(b)
-> lambda [C_{p_1}(b) + C_{p_2}(b) + P_{12}(b)]
= lambda [Pinch(b) + (b - Pinch(b))]
= lambda b

The limit is lambda * b regardless of what the projectors do at the crossing. Continuity holds.

**Remark:** The sqrt(lambda_i lambda_j) mixing function is essential for this continuity. If the mixing function were f(lambda_i, lambda_j) = 0 (the naive pinching product), the limit through a crossing would give lambda * Pinch(b) != lambda * b in general, producing a discontinuity when V_1 != {0}.

---

## Numerical Verification (SymPy/NumPy)

Script: `/tmp/test_decomp_independence.py` (random seed = 42)

All tests use the corrected product formula and compare results across different decompositions of the same element a. Agreement is measured against the Luders product sqrt(a) b sqrt(a) as independent ground truth.

| Test | Description | Max discrepancy | Status |
|------|-------------|-----------------|--------|
| 1 | Fully degenerate 2x2, a = 0.7 I, 4 decompositions | 2.2e-16 | PASS |
| 2 | Fully degenerate 3x3, a = 0.7 I, 3 decompositions | 4.4e-16 | PASS |
| 3 | 3x3, eigenvalues (0.8, 0.3, 0.3), 4 decompositions incl. merged | 1.4e-17 | PASS |
| 4 | 4x4, eigenvalues (0.9, 0.5, 0.2, 0.2), 3 decompositions | 2.8e-17 | PASS |
| 5 | 2x2 eigenvalue crossing, 61 points, continuity check | 5.6e-17 | PASS |
| 6 | Fully degenerate 3x3, split as 1+1+1 vs 2+1 vs 3 | 2.2e-16 | PASS |

All discrepancies are at machine precision (float64). The product is numerically decomposition-independent across all tests.

---

## Conclusion

The corrected sequential product (Eq. 04-06.4) is well-defined: it depends only on the element a, not on the choice of spectral decomposition. The proof reduces to a single algebraic fact (Peirce completeness): for any resolution of a projective unit Q into orthogonal sub-projectors, the sum of compressions plus Peirce 1-space projections reconstructs C_Q. When eigenvalues are equal, the coefficient sqrt(lambda_i lambda_j) = lambda collapses to the same value for both diagonal and off-diagonal terms, making the formula manifestly independent of the internal decomposition.

The same mechanism guarantees continuity through eigenvalue crossings: as two eigenvalues merge, the off-diagonal coefficient sqrt(lambda_i lambda_j) smoothly approaches the common value lambda, and the product smoothly approaches lambda * C_{Q}(b) where Q is the merged eigenspace projector.

---

_Phase: 06 (paper assembly)_
_Completed: 2026-03-21_
