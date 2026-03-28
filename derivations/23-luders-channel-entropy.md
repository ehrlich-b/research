# Luders Channel Entropy Change for 2-Qubit SWAP Dynamics

% ASSERT_CONVENTION: natural_units=natural, entropy_base=nats, state_normalization=Tr(rho)=1, sequential_product=a&b=sqrt(a)b*sqrt(a), von_neumann_entropy=S(rho)=-Tr(rho*ln*rho), coupling_convention=H=sum_h_xy

**References:**
- Paper 5 (v2.0): Luders product a & b = sqrt(a) b sqrt(a) [ref-paper5]
- Paper 6 (v3.0): SWAP Hamiltonian h_xy = JF from diagonal U(n) covariance [ref-paper6]
- Lindblad (CMP 40, 1975): Completely positive maps and entropy inequalities [ref-lindblad1975]

---

## 1. SWAP Operator on C^2 tensor C^2

The SWAP operator F acts on the computational basis as F|ij> = |ji>.

**Matrix representation** in the basis {|00>, |01>, |10>, |11>}:

$$
F = \begin{pmatrix} 1 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 1 \end{pmatrix}
$$

**Verification:** F^2|ij> = F|ji> = |ij>, so F^2 = I. Eigenvalues of F: since F^2 = I, eigenvalues are +/-1.

**Spectral decomposition:** The triplet subspace (eigenvalue +1) is spanned by {|00>, (|01>+|10>)/sqrt(2), |11>}, dimension 3. The singlet (eigenvalue -1) is (|01>-|10>)/sqrt(2), dimension 1.

$$
\text{Tr}(F) = 1 + 0 + 0 + 1 = 2 = 3 \times (+1) + 1 \times (-1) \quad \checkmark
$$

**Projectors:**

$$
P_+ = \frac{I + F}{2}, \quad P_- = \frac{I - F}{2}
$$

**SELF-CRITIQUE CHECKPOINT (step 1):**
1. SIGN CHECK: No sign changes yet. Expected: 0. Actual: 0.
2. FACTOR CHECK: Factor of 1/2 in projectors from (I +/- F)/2. Correct: P_+^2 = P_+.
3. CONVENTION CHECK: Using computational basis {|00>,|01>,|10>,|11>} -- standard.
4. DIMENSION CHECK: F is 4x4 on C^2 tensor C^2. Tr(F) = 2. [dimensionless] as required.

**Pauli form:** F = (1/2)(I_4 + sigma_x tensor sigma_x + sigma_y tensor sigma_y + sigma_z tensor sigma_z).

Verification: Let sigma = (sigma_x, sigma_y, sigma_z). The formula is F = (1/2)(I + sigma . sigma). Acting on |01>:
- sigma_x tensor sigma_x |01> = |10>
- sigma_y tensor sigma_y |01> = (-i)(i)|10> = |10>
- sigma_z tensor sigma_z |01> = (1)(-1)|01> = -|01>

So (sigma . sigma)|01> = |10> + |10> - |01> = 2|10> - |01>.
Then (1/2)(I + sigma.sigma)|01> = (1/2)(|01> + 2|10> - |01>) = |10> = F|01>. Correct.

---

## 2. Unitary Evolution (Interpretation B -- Primary)

The Hamiltonian is h = JF (from Paper 6, SWAP Hamiltonian on the lattice).

Since F^2 = I, F has eigenvalues +/-1, and:

$$
U(t) = e^{-iJFt} = e^{-iJt} P_+ + e^{+iJt} P_-
$$

**Proof:** F = (+1)P_+ + (-1)P_-, so JF = J P_+ - J P_-, and exp(-iJFt) = exp(-iJt)P_+ + exp(iJt)P_.

**Verify unitarity:**
U(t)^dag U(t) = (e^{iJt}P_+ + e^{-iJt}P_-)(e^{-iJt}P_+ + e^{iJt}P_-) = P_+^2 + P_-^2 = P_+ + P_- = I. (Cross terms vanish since P_+ P_- = 0.)

**Alternative form:** Since P_+ + P_- = I and P_+ - P_- = F:

$$
U(t) = \cos(Jt) I - i \sin(Jt) F
$$

Verify: cos(Jt)(P_+ + P_-) - i sin(Jt)(P_+ - P_-) = [cos(Jt) - i sin(Jt)]P_+ + [cos(Jt) + i sin(Jt)]P_- = e^{-iJt}P_+ + e^{iJt}P_-. Correct.

**SELF-CRITIQUE CHECKPOINT (step 2):**
1. SIGN CHECK: e^{-iJFt} with F eigenvalue +1 gives e^{-iJt}, with -1 gives e^{+iJt}. Sign in exponent: -iJt for triplet. Correct.
2. FACTOR CHECK: No extra factors introduced. cos/sin form consistent with e^{-i*theta} = cos theta - i sin theta.
3. CONVENTION CHECK: H = JF (no factor of 1/2). U = e^{-iHt}. Consistent with plan conventions.
4. DIMENSION CHECK: Jt is [energy]*[1/energy] = [dimensionless]. U is dimensionless. All consistent.

---

## 3. Channel on Subsystem B (Interpretation B)

Given initial state rho_BM = rho_B tensor rho_M with rho_M = I_2/2 (maximally mixed model), the evolved composite state is:

$$
\rho_{BM}(t) = U(t)(\rho_B \otimes \rho_M) U(t)^\dagger
$$

The reduced state of B is:

$$
\rho_B(t) = \text{Tr}_M[\rho_{BM}(t)] = \text{Tr}_M[U(t)(\rho_B \otimes I/2) U(t)^\dagger]
$$

This defines the channel E_U: rho_B -> rho_B(t).

**Explicit computation with rho_M = I/2:**

$$
\rho_B(t) = \text{Tr}_M\left[(\cos(Jt) I - i\sin(Jt) F)(\rho_B \otimes I/2)(\cos(Jt) I + i\sin(Jt) F)\right]
$$

Expanding:

$$
\rho_B(t) = \cos^2(Jt)\, \text{Tr}_M[\rho_B \otimes I/2] + \sin^2(Jt)\, \text{Tr}_M[F(\rho_B \otimes I/2)F]
$$
$$
\quad - i\sin(Jt)\cos(Jt)\, \text{Tr}_M[F(\rho_B \otimes I/2)] + i\sin(Jt)\cos(Jt)\, \text{Tr}_M[(\rho_B \otimes I/2)F]
$$

**Term 1:** Tr_M[rho_B tensor I/2] = rho_B * Tr(I/2) = rho_B.

**Term 2:** Tr_M[F(rho_B tensor I/2)F].

We need to compute F(rho_B tensor I/2)F. Since F swaps the two subsystems:

F(rho_B tensor rho_M)F = rho_M tensor rho_B

So F(rho_B tensor I/2)F = (I/2) tensor rho_B.

Then Tr_M[(I/2) tensor rho_B] = (I/2) * Tr(rho_B) = I/2.

**Term 3:** Tr_M[F(rho_B tensor I/2)].

F(rho_B tensor I/2) = (swapped). Let me compute this more carefully. For any operator A tensor B on C^2 tensor C^2, F(A tensor B) = B tensor A (SWAP exchanges the two factors but as an operator, F(A tensor B)F^{-1} = B tensor A. Here we have F(A tensor B) without the right F).

Actually, let me be more careful. F acts on vectors as F|phi>|psi> = |psi>|phi>. For operators: F(A tensor B)F = B tensor A. But F(A tensor B) alone is not simply B tensor A -- we need to think in matrix elements.

Let me use index notation. With rho_B having elements (rho_B)_{ab} and I/2 having elements (1/2)delta_{cd}:

[F(rho_B tensor I/2)]_{ac,bd} = sum_{a'c'} F_{ac,a'c'} (rho_B)_{a'b} (1/2)delta_{c'd}

F_{ac,a'c'} = delta_{a,c'} delta_{c,a'} (SWAP exchanges the two indices).

So: [F(rho_B tensor I/2)]_{ac,bd} = sum_{a'c'} delta_{a,c'} delta_{c,a'} (rho_B)_{a'b} (1/2)delta_{c'd}
= (rho_B)_{cb} (1/2) delta_{ad}

Then Tr_M of this: sum_c [F(rho_B tensor I/2)]_{ac,bc} = sum_c (rho_B)_{cb} (1/2) delta_{ab} = (1/2) delta_{ab} Tr(rho_B) ... wait, sum_c (rho_B)_{cb} = [rho_B^T . (1,...,1)]_b.

Hmm, let me redo this. Tr_M means tracing over the second (M) subsystem, so we set c=d and sum:

[Tr_M(F(rho_B tensor I/2))]_{ab} = sum_c [F(rho_B tensor I/2)]_{ac,bc}

From above: [F(rho_B tensor I/2)]_{ac,bd} = (rho_B)_{cb} * (1/2) * delta_{ad}

Setting d = c: [F(rho_B tensor I/2)]_{ac,bc} = (rho_B)_{cb} * (1/2) * delta_{ac}

Summing over c: sum_c (rho_B)_{cb} * (1/2) * delta_{ac} = (1/2)(rho_B)_{ab}

So **Tr_M[F(rho_B tensor I/2)] = (1/2) rho_B**.

**Term 4:** Tr_M[(rho_B tensor I/2)F].

[(rho_B tensor I/2)F]_{ac,bd} = sum_{b'd'} (rho_B)_{ab'} (1/2) delta_{cd'} F_{b'd',bd} = sum_{b'd'} (rho_B)_{ab'} (1/2) delta_{cd'} delta_{b',d} delta_{d',b}

= (rho_B)_{ad} (1/2) delta_{cb}

Tr_M: set d=c, sum over c:

[Tr_M((rho_B tensor I/2)F)]_{ab} = sum_c (rho_B)_{ac} (1/2) delta_{cb} = (1/2)(rho_B)_{ab}

So **Tr_M[(rho_B tensor I/2)F] = (1/2) rho_B**.

**Combining all terms:**

$$
\rho_B(t) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \frac{I}{2} - i\sin(Jt)\cos(Jt)\, \frac{\rho_B}{2} + i\sin(Jt)\cos(Jt)\, \frac{\rho_B}{2}
$$

The last two terms cancel! So:

$$
\boxed{\rho_B(t) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \frac{I}{2}}
$$

**SELF-CRITIQUE CHECKPOINT (step 3):**
1. SIGN CHECK: Cross terms (-i)(1/2)rho_B and (+i)(1/2)rho_B cancel. Expected: real result for density matrix. Actual: yes, cancellation correct.
2. FACTOR CHECK: cos^2 + sin^2 = 1. Tr(rho_B(t)) = cos^2(Jt) * 1 + sin^2(Jt) * 1 = 1. Trace preserved.
3. CONVENTION CHECK: rho_M = I/2 (maximally mixed qubit). S(I/2) = ln(2) nats.
4. DIMENSION CHECK: rho_B(t) is 2x2 density matrix, dimensionless. Jt is dimensionless. All consistent.

**Limiting cases:**
- t = 0: rho_B(0) = rho_B. Correct (no evolution).
- Jt = pi/2: rho_B = I/2. Body state becomes maximally mixed. This is the FULL SWAP point: B and M exchange states, and since rho_M = I/2, the body ends up maximally mixed.
- rho_B = I/2 initially: rho_B(t) = cos^2(Jt)(I/2) + sin^2(Jt)(I/2) = I/2. Channel preserves the maximally mixed state.

All limiting cases correct.

---

## 4. Unitality Test (Interpretation B)

**Question:** Is the channel E_U(rho_B) = cos^2(Jt) rho_B + sin^2(Jt) I/2 unital?

A channel on a qubit is unital if E(I/2) = I/2.

E_U(I/2) = cos^2(Jt)(I/2) + sin^2(Jt)(I/2) = I/2.

**The channel E_U is UNITAL** for all values of t and J.

This makes physical sense: the maximally mixed state is the unique state invariant under the SWAP channel with a maximally mixed environment.

More generally, E(I) = cos^2(Jt) I + sin^2(Jt) I = I. Unital confirmed.

**Note:** This channel is a **depolarizing channel** (mixing with the maximally mixed state):

$$
E_U(\rho_B) = (1-p)\rho_B + p \frac{I}{2}
$$

where p = sin^2(Jt) in [0,1].

---

## 5. Kraus Representation (Interpretation B)

The channel rho_B -> cos^2(Jt) rho_B + sin^2(Jt) I/2 can be written in Kraus form.

First, write I/2 = (1/4)(rho_B + sigma_x rho_B sigma_x + sigma_y rho_B sigma_y + sigma_z rho_B sigma_z) (depolarizing channel identity). Actually, let me use the standard depolarizing channel Kraus form.

The depolarizing channel E(rho) = (1-p)rho + p I/d with d=2 has Kraus operators:

$$
K_0 = \sqrt{1 - \frac{3p}{4}}\, I, \quad K_i = \frac{\sqrt{p}}{2}\, \sigma_i \quad (i=1,2,3)
$$

Check: sum K_i^dag K_i = (1-3p/4)I + (p/4)(sigma_x^2 + sigma_y^2 + sigma_z^2) = (1-3p/4)I + (3p/4)I = I. Trace-preserving.

Channel action: K_0 rho K_0^dag + sum_i K_i rho K_i^dag = (1-3p/4)rho + (p/4)(sigma_x rho sigma_x + sigma_y rho sigma_y + sigma_z rho sigma_z).

Using the Pauli twirl identity: (1/3)sum_i sigma_i rho sigma_i = (2/3)(I/2) - (1/3)rho + rho = ... actually let me just verify directly.

sigma_x rho sigma_x + sigma_y rho sigma_y + sigma_z rho sigma_z for rho = diag(a,b):
= diag(b,a) + diag(b,a) + diag(a,b) = diag(a+2b, 2a+b)... no, let me be more careful.

For general rho = ((rho_00, rho_01), (rho_10, rho_11)):
sigma_x rho sigma_x = ((rho_11, rho_10), (rho_01, rho_00))
sigma_y rho sigma_y = ((rho_11, -rho_10), (-rho_01, rho_00))
sigma_z rho sigma_z = ((rho_00, -rho_01), (-rho_10, rho_11))

Sum = ((rho_00 + 2*rho_11, -rho_01), (-rho_10, 2*rho_00 + rho_11))

Hmm, that gives: sum = Tr(rho)*I - rho + 2*diag(rho_11, rho_00)... let me just use the known identity:

sum_{i=1}^{3} sigma_i rho sigma_i = 2 Tr(rho) I/2 * 2 - rho = ... Actually the standard result is:

$$
\sum_{i=1}^{3} \sigma_i \rho \sigma_i = 2\text{Tr}(\rho) \frac{I}{2} \cdot 2 - \rho
$$

No. The correct identity is: sum_{i=0}^{3} sigma_i rho sigma_i = 2 Tr(rho) I where sigma_0 = I. So sum_{i=1}^{3} sigma_i rho sigma_i = 2I - rho (using Tr(rho)=1).

Then the channel gives: (1-3p/4)rho + (p/4)(2I - rho) = (1-3p/4)rho + (p/2)I - (p/4)rho = (1-p)rho + p(I/2).

Since I/2 = I/d with d=2, this is exactly the depolarizing channel with parameter p = sin^2(Jt).

So the Kraus operators are:

$$
K_0 = \sqrt{1 - \frac{3\sin^2(Jt)}{4}}\, I_2, \quad K_i = \frac{\sin(Jt)}{2}\, \sigma_i \quad (i=1,2,3)
$$

Verify trace preservation: K_0^dag K_0 + sum K_i^dag K_i = (1 - 3sin^2(Jt)/4)I + 3(sin^2(Jt)/4)I = I. Correct.

---

## 6. Entropy Change (Interpretation B)

With rho_B(t) = (1-p) rho_B + p I/2 where p = sin^2(Jt):

For a qubit, write rho_B = diag(lambda, 1-lambda) in its eigenbasis (0 <= lambda <= 1).

Then rho_B(t) = diag((1-p)lambda + p/2, (1-p)(1-lambda) + p/2) = diag(lambda', 1-lambda') where:

$$
\lambda'(t) = (1-p)\lambda + p/2 = \lambda + p(1/2 - \lambda)
$$

The eigenvalues of rho_B(t) are lambda' and 1-lambda'. Note that lambda' is a convex combination of lambda and 1/2, so lambda' is always closer to 1/2 than lambda is.

The von Neumann entropy is:

$$
S(\rho_B(t)) = -\lambda' \ln \lambda' - (1-\lambda') \ln(1-\lambda')  \equiv h(\lambda')
$$

where h(x) = -x ln x - (1-x) ln(1-x) is the binary entropy function (in nats).

$$
\Delta S = h(\lambda') - h(\lambda) = h(\lambda + p(1/2 - \lambda)) - h(\lambda)
$$

**Key property:** The binary entropy h(x) is strictly concave on [0,1] with maximum at x = 1/2.

Since lambda' = lambda + p(1/2 - lambda) is between lambda and 1/2 (for p in (0,1)):
- If lambda < 1/2: lambda < lambda' <= 1/2, so h(lambda') >= h(lambda) (moving toward maximum).
- If lambda > 1/2: 1/2 <= lambda' < lambda, so h(lambda') >= h(lambda) (moving toward maximum).
- If lambda = 1/2: lambda' = 1/2, h unchanged.

**Therefore: Delta S >= 0 for ALL initial states and ALL times t.**

Entropy INCREASES (or stays constant) under the SWAP channel with maximally mixed environment.

**This is expected for a unital channel:** For unital channels on qubits, the output state is always majorized by the input state, which implies S(E(rho)) >= S(rho). This is Lindblad's quantum H-theorem for doubly stochastic maps [ref-lindblad1975].

**SELF-CRITIQUE CHECKPOINT (step 4):**
1. SIGN CHECK: Delta S = h(lambda') - h(lambda). Since lambda' is closer to 1/2 and h is concave with max at 1/2, Delta S >= 0. Sign correct.
2. FACTOR CHECK: p = sin^2(Jt). lambda' = lambda + p(1/2 - lambda). When p=0: lambda'=lambda (no change). When p=1: lambda'=1/2 (fully mixed). Correct.
3. CONVENTION CHECK: Entropy in nats (ln). S(I/2) = ln(2) = 0.693 nats. Consistent.
4. DIMENSION CHECK: S is dimensionless. lambda is probability (dimensionless). p is dimensionless. All consistent.

**Explicit special cases:**

(a) rho_B = |0><0| (lambda=1, pure): lambda' = 1-p/2, Delta S = h(1-p/2) - 0 = h(1-p/2) >= 0.
At Jt = pi/2 (p=1): lambda' = 1/2, Delta S = ln(2) (maximal entropy gain).

(b) rho_B = I/2 (lambda=1/2, maximally mixed): lambda' = 1/2, Delta S = 0.

(c) rho_B = diag(0.9, 0.1) (lambda=0.9): lambda' = 0.9 + p(-0.4) = 0.9 - 0.4p.
At Jt = pi/4 (p=1/2): lambda' = 0.7, Delta S = h(0.7) - h(0.9) > 0.

---

## 7. Non-Selective Luders Channel (Interpretation A)

The non-selective Luders channel with measurement effects {P_+, P_-} (spectral projections of F):

$$
E_{\text{Luders}}(\rho) = P_+ \rho P_+ + P_- \rho P_-
$$

**Unitality test:** E_Luders(I) = P_+ I P_+ + P_- I P_- = P_+^2 + P_-^2 = P_+ + P_- = I.

**The non-selective Luders channel IS UNITAL.** This was anticipated in the plan: for any complete set of projections {P_k}, sum P_k rho P_k is unital.

**Reduced channel on B:** We need to compute the effect of E_Luders on the composite state and then trace over M.

For rho_BM = rho_B tensor rho_M:

E_Luders(rho_BM) = P_+(rho_B tensor rho_M)P_+ + P_-(rho_B tensor rho_M)P_-

rho_B' = Tr_M[P_+(rho_B tensor rho_M)P_+ + P_-(rho_B tensor rho_M)P_-]

With rho_M = I/2, using the explicit forms P_+ = (I+F)/2, P_- = (I-F)/2:

P_+(rho_B tensor I/2)P_+ = (1/4)(I+F)(rho_B tensor I/2)(I+F)
= (1/4)[(rho_B tensor I/2) + F(rho_B tensor I/2) + (rho_B tensor I/2)F + F(rho_B tensor I/2)F]

P_-(rho_B tensor I/2)P_- = (1/4)(I-F)(rho_B tensor I/2)(I-F)
= (1/4)[(rho_B tensor I/2) - F(rho_B tensor I/2) - (rho_B tensor I/2)F + F(rho_B tensor I/2)F]

Sum: E_Luders(rho_BM) = (1/2)[(rho_B tensor I/2) + F(rho_B tensor I/2)F]

Taking partial trace over M:
rho_B' = (1/2)[rho_B + I/2] (using Tr_M[rho_B tensor I/2] = rho_B and Tr_M[F(rho_B tensor I/2)F] = Tr_M[(I/2) tensor rho_B] = I/2).

$$
\boxed{E_{\text{Luders,reduced}}(\rho_B) = \frac{1}{2}\rho_B + \frac{1}{2}\cdot\frac{I}{2} = \frac{\rho_B}{2} + \frac{I}{4}}
$$

This is the depolarizing channel with p = 1/2 (mixing parameter). It is the Interpretation B channel at the specific time Jt = pi/4 (since sin^2(pi/4) = 1/2).

**Unitality of reduced Luders channel:** E(I/2) = I/4 + I/4 = I/2. Unital. Confirmed.

**Entropy change:** Since p=1/2 always (no time parameter in the measurement channel), Delta S = h(lambda/2 + 1/4) - h(lambda).

---

## 8. Selective Luders Product (Single Outcome)

The selective Luders product for a single effect a on the composite:

$$
\rho \mapsto \frac{\sqrt{a}\, \rho\, \sqrt{a}}{\text{Tr}(\sqrt{a}\, \rho\, \sqrt{a})}
$$

This is NOT trace-preserving (post-selection). For the projective case a = P_+:

$$
\rho \mapsto \frac{P_+ \rho P_+}{\text{Tr}(P_+ \rho P_+)}
$$

The **unnormalized** map rho -> P_+ rho P_+ is CP but not TP. After normalization, the resulting state depends on the initial state in a non-linear way (denominator depends on rho).

For the reduced state of B, with initial rho_B tensor I/2:

Unnormalized: Tr_M[P_+(rho_B tensor I/2)P_+] = (1/4)[(rho_B) + Tr_M[F(rho_B tensor I/2)] + Tr_M[(rho_B tensor I/2)F] + I/2]
= (1/4)[rho_B + rho_B/2 + rho_B/2 + I/2] = (1/4)[2 rho_B + I/2] = rho_B/2 + I/8

Normalization: Tr(rho_B/2 + I/8) = 1/2 + 1/4 = 3/4.

So the selective channel for outcome "+": rho_B -> (rho_B/2 + I/8)/(3/4) = (2/3)rho_B + (1/3)(I/2).

This is a depolarizing channel with p = 1/3 -- also unital!

Similarly, for outcome "-": The unnormalized reduced state is Tr_M[P_-(rho_B tensor I/2)P_-] = (1/4)[rho_B - rho_B/2 - rho_B/2 + I/2] = I/8.

Normalization: Tr(I/8) = 1/4. So the selective channel for outcome "-" gives rho_B -> (I/8)/(1/4) = I/2. The singlet projection completely destroys all information about rho_B (dimension 1 subspace).

**SELF-CRITIQUE CHECKPOINT (step 5):**
1. SIGN CHECK: Unnormalized "+": (1/4)[rho_B + rho_B/2 + rho_B/2 + I/2]. Signs from (I+F)/2 expansion: all positive. Correct.
2. FACTOR CHECK: Probabilities: 3/4 for triplet, 1/4 for singlet. Sum = 1. Correct.
3. CONVENTION CHECK: P_+ = (I+F)/2, triplet (3-dim), probability 3/4. Correct for maximally mixed M.
4. DIMENSION CHECK: All reduced states are 2x2 with Tr=1. Consistent.

---

## 9. Summary of Results

### Interpretation B (Unitary SWAP evolution + partial trace) -- PRIMARY

**Channel:**
$$
E_U(\rho_B) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \frac{I}{2}
$$

- **Type:** Depolarizing channel with p = sin^2(Jt)
- **CPTP:** Yes. Kraus operators: K_0 = sqrt(1-3p/4) I, K_i = (sqrt(p)/2) sigma_i (i=1,2,3)
- **Unital:** YES. E(I/2) = I/2 for all t.
- **Entropy change:** Delta S = h(lambda') - h(lambda) >= 0 for all initial states
  - where lambda' = lambda + sin^2(Jt)(1/2 - lambda)
  - h(x) = -x ln x - (1-x) ln(1-x) (binary entropy in nats)
- **Entropy is monotonically non-decreasing** under this channel

### Interpretation A (Non-selective Luders measurement in SWAP eigenbasis)

**Channel:**
$$
E_{\text{Luders,reduced}}(\rho_B) = \frac{1}{2}\rho_B + \frac{1}{4}I
$$

- **Type:** Depolarizing channel with p = 1/2 (fixed)
- **CPTP:** Yes
- **Unital:** YES
- **Entropy change:** Delta S >= 0 (same argument)

### Key Physical Insight

Both interpretations yield **unital** channels on the body's reduced state when the model is maximally mixed. The roadmap's concern about non-unital Luders maps is resolved for this specific system:

**The non-unital character of the selective Luders product sqrt(a) rho sqrt(a) (single outcome) does NOT propagate to the physically relevant channels, because:**

1. The unitary evolution channel (Interpretation B) involves tracing over the model, not post-selecting on a measurement outcome. It is automatically unital when rho_M = I/2.

2. The non-selective Luders channel (Interpretation A) sums over all outcomes, restoring unitality: sum P_k rho P_k is always unital for a complete set of projections.

**Consequence for entropy:** Since both channels are unital, Lindblad's quantum H-theorem [ref-lindblad1975] applies directly: S(E(rho)) >= S(rho). The data processing inequality (for unital channels) gives Delta S >= 0 without further conditions. The forbidden proxy warnings (fp-assume-unital, fp-dpi-without-unitality) are now properly addressed: we did NOT assume unitality -- we PROVED it for this specific system.

---

## 10. Dependence on rho_M

The result rho_B(t) = cos^2(Jt) rho_B + sin^2(Jt) I/2 assumes rho_M = I/2. For general rho_M:

$$
\rho_B(t) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \rho_M + \text{(cross terms)}
$$

Actually, let me redo this for general rho_M. The cross terms from Section 3:

Tr_M[F(rho_B tensor rho_M)] and Tr_M[(rho_B tensor rho_M)F] are both equal to (1/2)... no, they depend on rho_M.

Following the index computation from Section 3 but with general rho_M:

Tr_M[F(rho_B tensor rho_M)]_{ab} = sum_c [F(rho_B tensor rho_M)]_{ac,bc}

[F(rho_B tensor rho_M)]_{ac,bd} = (rho_B)_{cb} (rho_M)_{ad}

Setting d=c, summing over c:
= sum_c (rho_B)_{cb} (rho_M)_{ac} = (rho_M rho_B)_{ab} ... wait:
sum_c (rho_M)_{ac} (rho_B)_{cb} = (rho_M rho_B)_{ab}.

So Tr_M[F(rho_B tensor rho_M)] = rho_M rho_B (matrix product).

Similarly, Tr_M[(rho_B tensor rho_M)F]_{ab} = sum_c [(rho_B tensor rho_M)F]_{ac,bc}

[(rho_B tensor rho_M)F]_{ac,bd} = (rho_B)_{ad} (rho_M)_{cb}

Setting d=c: (rho_B)_{ac} (rho_M)_{cb} = (rho_B rho_M)_{ab}... wait:
sum_c (rho_B)_{ac} (rho_M)_{cb} = (rho_B rho_M)_{ab}.

So Tr_M[(rho_B tensor rho_M)F] = rho_B rho_M.

And Tr_M[F(rho_B tensor rho_M)F] = Tr_M[(rho_M tensor rho_B)] = rho_M.

Wait -- that's not right for general rho_M. Let me recheck:
F(rho_B tensor rho_M)F = rho_M tensor rho_B (SWAP exchanges factors).
Tr_M[rho_M tensor rho_B] = rho_M * Tr(rho_B) = rho_M (since Tr(rho_B)=1).

Yes, so for general rho_M:

$$
\rho_B(t) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \rho_M - i\sin(Jt)\cos(Jt)\,(\rho_M\rho_B - \rho_B\rho_M)
$$

$$
\boxed{\rho_B(t) = \cos^2(Jt)\, \rho_B + \sin^2(Jt)\, \rho_M - i\sin(Jt)\cos(Jt)\,[\rho_M, \rho_B]}
$$

When rho_M = I/2: the commutator [I/2, rho_B] = 0, and we recover the depolarizing channel. For general rho_M, the commutator term survives and the channel may be non-unital.

**Unitality for general rho_M:** E(I/2) = cos^2(Jt)(I/2) + sin^2(Jt) rho_M - i sin(Jt)cos(Jt)[rho_M, I/2] = cos^2(Jt)(I/2) + sin^2(Jt) rho_M.

This equals I/2 only if rho_M = I/2. So **the channel is NOT unital for general rho_M != I/2.**

This is an important nuance: the unitality (and hence guaranteed entropy increase) depends on the model state being maximally mixed. For non-maximally-mixed rho_M, entropy can decrease.

---

*Phase: 23-entropy-increase-under-sequential-products*
*Plan: 01*
*Completed: 2026-03-24*
