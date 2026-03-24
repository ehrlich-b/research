# Order Zero Condition for the Self-Modeling Spectral Triple

% ASSERT_CONVENTION: natural_units=N/A, commutation_convention=[A,B]=AB-BA, inner_product=linear_in_second_argument

**References:**
- Connes 1995, J. Math. Phys. 36, 6194 (order zero condition definition)
- van Suijlekom 2024, NCG and Particle Physics, 2nd ed., Ch. 2-4 (opposite algebra computation)
- Paper 5 (M_n(C)^sa, J = dagger, sequential product)
- Paper 6 (SWAP operator P, doubled space H, J definition)

## Setup

**Algebra.** A = M_n(C) for general n >= 1.

**Hilbert space.** H = C^{n^2}\_p + C^{n^2}\_{ap} (particle + antiparticle sectors), where each sector is C^n tensor C^n. Elements are pairs (psi, chi). dim(H) = 2n^2.

**Conventions.**
- P (SWAP): P(v tensor w) = w tensor v, with P^2 = I, P real and self-adjoint
- C (conjugation): C(v) = v-bar (componentwise conjugation in computational basis)
- J (real structure): J(psi, chi) = (P(conj(chi)), P(conj(psi))), antilinear
- gamma (chirality): gamma(psi, chi) = (P psi, -P chi)
- Matrix units: (E_{ij})_{kl} = delta_{ik} delta_{jl}
- Opposite algebra: pi_o(b) = J pi(b*) J^{-1} where b* = b^dagger

**KO-dimension 6 signs verified:** J^2 = +1 (epsilon = +1), J gamma = -gamma J (epsilon'' = -1).

## Derivation of pi_o(b) at General n

### Step 1: Algebra action pi(a) on H

**Naive action:** pi(a)(psi, chi) = ((a tensor I_n)psi, (a tensor I_n)chi).

In block form: pi(a) = diag(a tensor I_n, a tensor I_n).

This is a *-representation: pi(ab) = pi(a)pi(b), pi(a*) = pi(a)^dagger, pi(I) = I.

### Step 2: J as antilinear operator

J(psi, chi) = (P(conj(chi)), P(conj(psi)))

where conj denotes componentwise conjugation. J is antilinear:

J(alpha psi, alpha chi) = (P(conj(alpha chi)), P(conj(alpha psi)))
= (alpha* P(conj(chi)), alpha* P(conj(psi))) = alpha* J(psi, chi).

### Step 3: Verify J^2 = I and J^{-1} = J

J(J(psi, chi)) = J(P(conj(chi)), P(conj(psi)))
= (P(conj(P(conj(psi)))), P(conj(P(conj(chi)))))

Since P is a real matrix (permutation matrix in the computational basis), conj(P(v)) = P(conj(v)) for any v. Therefore:

= (P(P(conj(conj(psi)))), P(P(conj(conj(chi)))))
= (P^2(psi), P^2(chi))
= (psi, chi).

So J^2 = I and J^{-1} = J.

### Step 4: Compute pi_o(b) = J pi(b*) J^{-1} step-by-step

For b in M_n(C), b* = b^dagger.

**Step 4a.** Apply J^{-1} = J to input (psi, chi):

J(psi, chi) = (P(conj(chi)), P(conj(psi)))

**Step 4b.** Apply pi(b*) to the result:

pi(b^dagger)(P(conj(chi)), P(conj(psi)))
= ((b^dagger tensor I)(P(conj(chi))), (b^dagger tensor I)(P(conj(psi))))

**Step 4c.** Apply J to the result of Step 4b:

J((...), (...)) = (P(conj((b^dagger tensor I)(P(conj(psi))))), P(conj((b^dagger tensor I)(P(conj(chi))))))

The particle sector output depends on psi; the antiparticle sector output depends on chi. Computing each separately.

### Step 5: Evaluate P(conj((b^dagger tensor I)(P(conj(v))))) component-by-component

Let v = sum_{ij} V_{ij} e_i tensor e_j.

1. conj(v) = sum_{ij} V_{ij}* e_i tensor e_j

2. P(conj(v)) = sum_{ij} V_{ij}* e_j tensor e_i

3. (b^dagger tensor I)(P(conj(v))) = sum_{ij} V_{ij}* (b^dagger e_j) tensor e_i
   = sum_{ijk} V_{ij}* (b^dagger)_{kj} e_k tensor e_i
   = sum_{ijk} V_{ij}* b_{jk}* e_k tensor e_i

   (using (b^dagger)_{kj} = b_{jk}*.)

4. conj(step 3 result) = sum_{ijk} V_{ij} b_{jk} e_k tensor e_i

   **KEY ANTILINEARITY STEP:** The conjugation from J converts b_{jk}* (from b^dagger) to b_{jk} (entries of b itself).

5. P(step 4 result) = sum_{ijk} V_{ij} b_{jk} e_i tensor e_k

Reading off the (i,k) matrix entry of the result: R_{ik} = sum_j V_{ij} b_{jk} = (Vb)_{ik}.

**Result:** P(conj((b^dagger tensor I)(P(conj(v))))) corresponds to matrix V * b (right multiplication by b).

### Step 6: Express as tensor product operator

Right multiplication by b on the matrix V corresponds to the tensor product operator I_n tensor b^T.

**Proof:** (I_n tensor M)v has (i,k) entry = sum_j V_{ij} M_{kj}. Setting this equal to (Vb)_{ik} = sum_j V_{ij} b_{jk} requires M_{kj} = b_{jk}, i.e., M = b^T.

### Step 7: Result for pi_o(b)

Combining Steps 5-6 for both sectors:

$$\boxed{\pi_o(b)(\psi, \chi) = ((I_n \otimes b^T)\psi, \; (I_n \otimes b^T)\chi)}$$

In block form:

$$\pi_o(b) = \mathrm{diag}(I_n \otimes b^T, \; I_n \otimes b^T)$$

**Physical interpretation:** J's antilinearity converts the left algebra action (b^dagger on first tensor factor) into a transpose action on the second tensor factor (b^T). The SWAP operator P permutes the tensor factors during this conversion. The chain of identities is:

b^dagger has entries (b^dagger)_{kj} = b_{jk}* --> conj converts b_{jk}* to b_{jk} --> SWAP rearranges indices --> result is I tensor b^T.

### Step 8: Verification that pi_o is a *-representation of A^{op}

**(a) Multiplicativity (as representation of A^{op}):**

pi_o(a) pi_o(b) = diag(I tensor a^T b^T, I tensor a^T b^T)

pi_o(ba) = diag(I tensor (ba)^T, I tensor (ba)^T) = diag(I tensor a^T b^T, I tensor a^T b^T)

So pi_o(a) pi_o(b) = pi_o(ba) = pi_o(a \*\_{op} b). Confirmed: pi_o is a homomorphism from A^{op}.

**(b) *-preserving:**

pi_o(a^dagger) = diag(I tensor (a^dagger)^T, ...) = diag(I tensor conj(a), ...)

pi_o(a)^dagger = diag((I tensor a^T)^dagger, ...) = diag(I tensor conj(a), ...)

(since (a^T)^dagger = conj(a).)

Therefore pi_o(a*) = pi_o(a)^dagger. Confirmed.

**(c) Identity:**

pi_o(I_n) = diag(I_n tensor I_n, I_n tensor I_n) = I_{2n^2}. Confirmed.

### Step 9: Limiting case n = 1

For n = 1: M_1(C) = C. b is a scalar, b^T = b.

pi_o(b) = diag(b, b) = b * I_2.
pi(a) = diag(a, a) = a * I_2.

These commute trivially. Consistent.

### Step 10: Antilinearity tracking audit

At every step where J acts:
- Step 4a: J(psi, chi) -> conjugation of chi, psi applied. Antilinear.
- Step 4c: J acts on a vector containing b^dagger entries -> conjugation converts b_{jk}* to b_{jk}. This is the KEY antilinearity step.
- No step treats J as a linear operator.
- The critical identity: conj(b^dagger) = conj((b^T)*) = b^T. Treating J as linear would give conj(b) instead of b^T -- WRONG.

## Order Zero Condition [pi(a), pi_o(b)] = 0

### Step 1: Write pi(a) and pi_o(b) in block form

For the naive algebra action:

pi(a) = diag(a tensor I_n, a tensor I_n)

pi_o(b) = diag(I_n tensor b^T, I_n tensor b^T)

### Step 2: Compute the commutator block-by-block

[pi(a), pi_o(b)] = diag([a tensor I, I tensor b^T], [a tensor I, I tensor b^T])

Each block has the same commutator. It suffices to show:

[a tensor I_n, I_n tensor b^T] = 0

### Step 3: Tensor product commutator -- operators on different factors commute

For operators A, B on C^n:

(A tensor I)(I tensor B) = A tensor B
(I tensor B)(A tensor I) = A tensor B

Therefore: [A tensor I, I tensor B] = A tensor B - A tensor B = 0.

This is the fundamental algebraic fact: operators acting on different tensor factors commute.

Applying to our case with A = a and B = b^T:

$$[a \otimes I_n, \; I_n \otimes b^T] = a \otimes b^T - a \otimes b^T = 0$$

### Step 4: Conclusion for both sectors

Since both the particle and antiparticle blocks give the same commutator:

$$[\pi(a), \pi_o(b)] = \mathrm{diag}(0, 0) = 0 \quad \text{for all } a, b \in M_n(\mathbb{C})$$

This holds for ALL a, b at general n. The proof is universal -- it does not depend on specific choices of a, b, or the value of n.

### Step 5: Verification on matrix unit basis

For matrix units E_{ij} (with (E_{ij})_{kl} = delta_{ik} delta_{jl}):

pi(E_{ij}) = diag(E_{ij} tensor I, E_{ij} tensor I)
pi_o(E_{kl}) = diag(I tensor E_{kl}^T, I tensor E_{kl}^T) = diag(I tensor E_{lk}, I tensor E_{lk})

Each block: [E_{ij} tensor I, I tensor E_{lk}] = 0 (different tensor factors).

This holds for all n^4 pairs of matrix units (i,j) and (k,l). By bilinearity of the commutator, this extends to all a, b in M_n(C):

a = sum_{ij} a_{ij} E_{ij}, b = sum_{kl} b_{kl} E_{kl}

[pi(a), pi_o(b)] = sum_{ij,kl} a_{ij} b_{kl} [pi(E_{ij}), pi_o(E_{kl})] = 0.

### Step 6: Role of J in the proof

The order zero condition holds because J converts the algebra action on the first tensor factor into an action on the second tensor factor. Specifically:

1. pi(a) acts as a tensor I (first factor, left multiplication)
2. J's antilinearity + sector swap + SWAP converts pi(b*) into I tensor b^T (second factor)
3. Operators on different tensor factors commute

**The sector-swap in J** (particle <-> antiparticle) is handled by the block-diagonal structure: pi(a) and pi_o(b) are both block-diagonal with the same block structure, so the commutator decomposes block-by-block.

### Step 7: Naive vs contragredient action analysis

**Naive action** pi(a) = diag(a tensor I, a tensor I): ORDER ZERO SATISFIED.

The contragredient action pi_c(a) = diag(a tensor I, a-bar tensor I) would also satisfy order zero, since:
- Particle block: [a tensor I, I tensor b^T] = 0 (same argument)
- Antiparticle block: [a-bar tensor I, I tensor b^T] = 0 (same argument -- a-bar tensor I and I tensor b^T still act on different factors)

**Both actions satisfy order zero.** The distinction between naive and contragredient does not affect the order zero condition because the key fact (operators on different tensor factors commute) is independent of what acts on the first factor.

The correct choice between naive and contragredient will be determined by other axioms (specifically, the evenness condition [gamma, pi(a)] = 0 in KO-dim 6). This is deferred to later phases.

### Step 8: Summary theorem

**Theorem (Order Zero Condition).** For A = M_n(C) acting on H = C^{2n^2} via pi(a) = diag(a tensor I_n, a tensor I_n), with J(psi, chi) = (P conj(chi), P conj(psi)) and pi_o(b) = J pi(b*) J^{-1}:

$$[\pi(a), \pi_o(b)] = 0 \quad \text{for all } a, b \in M_n(\mathbb{C}), \; \text{all } n \geq 1.$$

**Proof.** pi_o(b) = diag(I_n tensor b^T, I_n tensor b^T) (derived above). Each block of the commutator is [a tensor I_n, I_n tensor b^T] = 0 because operators on different tensor factors of C^n tensor C^n commute. QED.

## Forbidden Proxy Audit

1. **fp-specific-ab (partial checking):** REJECTED. The proof covers ALL a, b in M_n(C) via the tensor factor argument and bilinearity over matrix units. No specific pairs assumed.

2. **fp-no-j-tracking (skipping J sector-swap):** REJECTED. J's sector-swap is explicitly tracked: J maps (psi, chi) -> (P conj(chi), P conj(psi)), and the block-diagonal structure of pi(a) and pi_o(b) handles cross-sector terms. Steps 4a-4c trace the sector flow at each application of J.

3. **fp-linear-j (treating J as linear):** REJECTED. Step 5 explicitly tracks the antilinearity: conj converts b_{jk}* (from b^dagger) to b_{jk}, producing b^T rather than conj(b). Step 10 audits all J applications for linearity violations. The WARNING in Step 10 confirms that linear J would give the wrong result.

## Verification Summary

1. **pi_o(b) well-defined as linear operator:** J antilinear * pi(b*) linear * J^{-1} antilinear = linear. Confirmed.
2. **pi_o is *-representation of A^{op}:** pi_o(ba) = pi_o(a)pi_o(b), pi_o(a*) = pi_o(a)^dagger, pi_o(I) = I. Confirmed.
3. **Dimensional consistency:** pi_o(b) is 2n^2 x 2n^2. Confirmed.
4. **Antilinearity properly tracked throughout:** conj(b^dagger) = b^T is the key identity. No linear-J violations.
5. **n=1 limiting case:** Trivially satisfied. Confirmed.
6. **Order zero for ALL a, b:** Proved by tensor factor argument. Verified on all n^4 matrix unit pairs by bilinearity.
7. **J sector-swap tracked:** Block-diagonal structure handles particle/antiparticle explicitly.
8. **Both naive and contragredient actions satisfy order zero:** Tensor factor argument is independent of first-factor representation.
9. **All forbidden proxies explicitly rejected:** Universal coverage, J tracking, antilinearity handling confirmed.
