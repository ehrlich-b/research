# First-Order Condition for Barrett-Form Dirac Operator

% ASSERT_CONVENTION: natural_units=N/A, commutation_convention=[A,B]=AB-BA, inner_product=linear_in_second_argument, opposite_algebra=pi_o(b)=J_pi(b*)_J^{-1}, ko_dimension=6, barrett_iso=v_tensor_w_to_vwT, sequential_product=a&b=sqrt(a)b*sqrt(a), jordan_product=K*X=(1/2)(KX+XK)

**References:**
- Barrett 2015, arXiv:1502.05383
- Chamseddine-Connes-Marcolli 2008, arXiv:0706.3688 (CCM)
- Chamseddine-Connes-van Suijlekom 2013, arXiv:1304.8050 (CCSV)
- van Suijlekom 2024, Noncommutative Geometry and Particle Physics, 2nd ed., Ch. 8-11
- Phase 13: derivations/07-order-zero-condition.md (pi, pi_o, J, gamma, order zero)
- Phase 14: derivations/08-dirac-candidates.md (Barrett-form D, Jordan product connection)

## Setup

Work under Barrett isomorphism throughout. All operators act on M_n(C) via the identification C^n tensor C^n = M_n(C), v tensor w -> v w^T.

| Object | Definition | Reference |
|---|---|---|
| A | M_n(C) | Phase 13 |
| H | M_n(C)_p + M_n(C)_{ap}, dim = 2n^2 | Phase 13 |
| pi(a) | L_a: X -> aX (left mult) | Barrett iso, Phase 13 |
| pi_o(b) | R_b: X -> Xb (right mult) | Barrett iso, Phase 13 |
| D_K | Barrett-form Dirac: D(X_p, X_{ap}) = (D_1(X_{ap}), D_1(X_p)) | Phase 14-02 |
| D_1 | D_1(X) = KX + XK = L_K + R_K | Phase 14-02, Eq. (14-02.2) |
| K | K in M_n(R)^sym (real symmetric n x n) | Phase 14-02 |
| [A,B] | AB - BA | Convention lock |

**First-order condition** (Connes 1996, van Suijlekom 2024 Ch. 11):

$$[[D, \pi(a)], \pi_o(b)] = 0 \quad \forall\, a \in A_F,\; b \in A \qquad \text{(15-01.1)}$$

where $A_F \subseteq A$ is the maximal subalgebra satisfying this condition.

## Step 1: Compute [D_1, L_a] on M_n(C)

$D_1 = L_K + R_K$ where $L_K(X) = KX$ and $R_K(X) = XK$.

Compute:

$$[D_1, L_a](X) = D_1(aX) - a\,D_1(X)$$

$$= K(aX) + (aX)K - a(KX) - a(XK)$$

$$= KaX + aXK - aKX - aXK$$

$$= (Ka - aK)X + (aXK - aXK)$$

$$= [K, a] X$$

$$\therefore\; [D_1, L_a] = L_{[K,a]} \qquad \text{(15-01.2)}$$

**Check:** The $R_K$ part of $D_1$ cancels: $R_K(aX) - a R_K(X) = aXK - aXK = 0$. This is because $R_K$ commutes with $L_a$ (left and right multiplications commute by associativity of matrix multiplication). This is the same algebraic fact used in Phase 13 for the order zero condition.

SELF-CRITIQUE CHECKPOINT (Step 1):
1. SIGN CHECK: [K,a] = Ka - aK. Two sign changes from expanding D_1(aX) - aD_1(X). Expected: 2 cancellations (aXK - aXK). Actual: 2. OK.
2. FACTOR CHECK: No factors of 2, pi, hbar, c introduced. OK.
3. CONVENTION CHECK: [A,B] = AB - BA matches convention lock. OK.
4. DIMENSION CHECK: [D_1, L_a] maps M_n(C) -> M_n(C). L_{[K,a]} maps M_n(C) -> M_n(C). Dimensions match. OK.

## Step 2: Compute [[D_1, L_a], R_b] on M_n(C)

From Step 1, $[D_1, L_a] = L_{[K,a]} = L_C$ where $C = [K,a]$.

$$[L_C, R_b](X) = L_C(Xb) - R_b(L_C(X))$$

$$= C(Xb) - (CX)b$$

$$= CXb - CXb$$

$$= 0$$

$$\therefore\; [[D_1, L_a], R_b] = [L_C, R_b] = 0 \qquad \text{(15-01.3)}$$

**Key identity:** $[L_C, R_b] = 0$ for ANY matrix $C$ and ANY matrix $b$. This is the **associativity of matrix multiplication**: $C(Xb) = (CX)b$. This is the same identity that guarantees the order zero condition [pi(a), pi_o(b)] = 0 in Phase 13, Eq. (13.2).

SELF-CRITIQUE CHECKPOINT (Step 2):
1. SIGN CHECK: No sign changes involved -- pure expansion. Expected terms: CXb appears twice with same sign, cancels. OK.
2. FACTOR CHECK: No new factors. OK.
3. CONVENTION CHECK: Still using [A,B] = AB - BA. OK.
4. DIMENSION CHECK: [L_C, R_b] maps M_n(C) -> M_n(C). Result = 0 (zero map). OK.

## Step 3: Verify on the full doubled space H = M_n(C)_p + M_n(C)_{ap}

The Barrett-form D on the doubled space is:

$$D(X_p, X_{ap}) = (D_1(X_{ap}), D_1(X_p)) = \sigma_1 \otimes D_1$$

where $\sigma_1$ is the Pauli matrix swapping particle and antiparticle sectors.

The representations are:

$$\pi(a)(X_p, X_{ap}) = (aX_p, aX_{ap}) \qquad \text{(L_a on each sector)}$$

$$\pi_o(b)(X_p, X_{ap}) = (X_p b, X_{ap} b) \qquad \text{(R_b on each sector)}$$

Compute $[D, \pi(a)]$:

$$D(\pi(a)(X_p, X_{ap})) = D(aX_p, aX_{ap}) = (D_1(aX_{ap}), D_1(aX_p))$$

$$\pi(a)(D(X_p, X_{ap})) = \pi(a)(D_1(X_{ap}), D_1(X_p)) = (a\,D_1(X_{ap}), a\,D_1(X_p))$$

$$[D, \pi(a)](X_p, X_{ap}) = (D_1(aX_{ap}) - a\,D_1(X_{ap}),\; D_1(aX_p) - a\,D_1(X_p))$$

$$= ([D_1, L_a](X_{ap}),\; [D_1, L_a](X_p))$$

$$= ([K,a]X_{ap},\; [K,a]X_p)$$

$$= \sigma_1 \otimes L_{[K,a]} (X_p, X_{ap}) \qquad \text{(15-01.4)}$$

Wait -- let me be precise about the sigma_1 structure. We have:

$$[D, \pi(a)](X_p, X_{ap}) = ([K,a]X_{ap}, [K,a]X_p)$$

This is: the ap component maps to the p slot, and the p component maps to the ap slot, with L_{[K,a]} applied. So yes, this is $\sigma_1 \otimes L_{[K,a]}$.

Now compute $[[D, \pi(a)], \pi_o(b)]$:

$$[D, \pi(a)](\pi_o(b)(X_p, X_{ap})) = [D, \pi(a)](X_p b, X_{ap} b) = ([K,a](X_{ap} b), [K,a](X_p b))$$

$$\pi_o(b)([D, \pi(a)](X_p, X_{ap})) = \pi_o(b)([K,a]X_{ap}, [K,a]X_p) = ([K,a]X_{ap} b, [K,a]X_p b)$$

$$\therefore\; [[D, \pi(a)], \pi_o(b)](X_p, X_{ap}) = ([K,a](X_{ap} b) - [K,a]X_{ap} b,\; [K,a](X_p b) - [K,a]X_p b)$$

$$= ([K,a]X_{ap} b - [K,a]X_{ap} b,\; [K,a]X_p b - [K,a]X_p b)$$

$$= (0, 0) \qquad \text{(15-01.5)}$$

**Each component** is $L_C(Xb) - L_C(X) b = CXb - CXb = 0$ by associativity, same as Step 2.

**The sector-swap does not affect the result** because $\pi_o(b) = R_b$ acts identically on both sectors: it does not mix sectors, so the $\sigma_1$ structure of $[D, \pi(a)]$ is irrelevant. The key algebraic fact $[L_C, R_b] = 0$ kills each sector independently.

SELF-CRITIQUE CHECKPOINT (Step 3):
1. SIGN CHECK: Sector swap gives ([K,a]X_{ap}, [K,a]X_p), correctly applying to the swapped components. No sign errors in the doubled-space expansion. OK.
2. FACTOR CHECK: No new factors. OK.
3. CONVENTION CHECK: pi(a) = L_a, pi_o(b) = R_b, D = sigma_1 tensor D_1, all match Phase 13/14 conventions. OK.
4. DIMENSION CHECK: [[D, pi(a)], pi_o(b)] maps H = C^{2n^2} -> C^{2n^2}. Result = 0 (zero map). OK.

## Step 4: Identify A_F = M_n(C)

From Steps 1-3:

$$[[D_K, \pi(a)], \pi_o(b)] = 0 \quad \forall\, a, b \in M_n(\mathbb{C}), \;\forall\, K \in M_n(\mathbb{R})^{\text{sym}} \qquad \text{(15-01.6)}$$

The first-order condition places **no restriction on a**. Every element of M_n(C) satisfies the condition. Therefore:

$$A_F = M_n(\mathbb{C}) \qquad \text{(full algebra)} \qquad \text{(15-01.7)}$$

This result is **structurally independent of K**: the proof uses only that $[D_1, L_a]$ is a left multiplication (which holds because $D_1 = L_K + R_K$ and $[R_K, L_a] = 0$), combined with the fact that any left multiplication commutes with any right multiplication.

**The gauge group** associated with $A_F = M_n(\mathbb{C})$ is:

$$\text{Gauge group} = U(A_F) = U(n) \qquad \text{(15-01.8)}$$

At $n = 4$: the gauge group is $U(4)$, **not** the Standard Model gauge group $U(1) \times SU(2) \times SU(3)$.

## Step 5: Comparison with CCM

The Chamseddine-Connes-Marcolli (CCM) classification (arXiv:0706.3688) starts from a **direct sum** algebra:

$$A_{\text{CCM}} = M_2(\mathbb{H}) \oplus M_4(\mathbb{C})$$

and derives $A_F = \mathbb{C} \oplus \mathbb{H} \oplus M_3(\mathbb{C})$, giving gauge group $U(1) \times SU(2) \times SU(3)$.

The difference is structural:

1. **CCM uses a direct sum algebra.** In $A_{\text{CCM}} = M_2(\mathbb{H}) \oplus M_4(\mathbb{C})$, the Dirac operator D has cross-terms connecting the two summands. For $a$ in one summand, $[D, L_a]$ produces operators involving both summands, and these cross-term operators do NOT commute with $R_b$ from the other summand. The cross-term constraints force $A_F$ to be a proper subalgebra.

2. **Our algebra is simple.** In $A = M_n(\mathbb{C})$ (simple), there are no cross-terms. The Barrett-form $D_1 = L_K + R_K$ involves only left and right multiplications within the same algebra. The commutator $[D_1, L_a] = L_{[K,a]}$ is always a pure left multiplication, and left multiplications commute with right multiplications by associativity. No cross-term constraints arise.

3. **The first-order condition is non-trivial for direct sums but trivial for simple algebras.** This is not a failure of the framework but a structural consequence of working with $M_n(\mathbb{C})$ rather than a direct sum. The SM algebra emerges in the CCM framework precisely because the direct sum structure creates cross-term constraints.

**Summary table:**

| Feature | CCM (direct sum) | This work (simple) |
|---|---|---|
| Starting algebra A | M_2(H) + M_4(C) | M_n(C) |
| D cross-terms? | Yes (mix summands) | No (L_K + R_K within M_n(C)) |
| [D, L_a] type | Mixed L and R across summands | Pure L_{[K,a]} |
| A_F | C + H + M_3(C) (proper subalgebra) | M_n(C) (full algebra) |
| Gauge group | U(1) x SU(2) x SU(3) | U(n) |

## Step 6: Limiting Cases

**Case K = 0:** $D_1 = 0$, so $D = 0$. The first-order condition $[[0, L_a], R_b] = [0, R_b] = 0$ is vacuously satisfied. $A_F = M_n(\mathbb{C})$. Consistent with Step 4.

**Case K = lambda I:** $[K, a] = [\lambda I, a] = 0$ for all $a$. So $[D_1, L_a] = L_0 = 0$, and $[[D_1, L_a], R_b] = [0, R_b] = 0$. $A_F = M_n(\mathbb{C})$. Consistent with Step 4.

**Case K generic (non-scalar, non-zero real symmetric):** $[K, a] \neq 0$ for generic $a$ (e.g., $a = E_{12}$ with $K = \text{diag}(1, 0, \ldots, 0)$ gives $[K, E_{12}] = E_{12} \neq 0$). But $L_{[K,a]}$ still commutes with $R_b$ by associativity. $A_F = M_n(\mathbb{C})$. This is the non-trivial case that confirms the result is not vacuous.

**All three cases** give $A_F = M_n(\mathbb{C})$, confirming the result is K-independent.

## Step 7: Pati-Salam Context

The Chamseddine-Connes-van Suijlekom 2013 (CCSV, arXiv:1304.8050) Pati-Salam result concerns **dropping** the first-order condition entirely (or relaxing it), which introduces quadratic terms in the inner fluctuations and leads to the Pati-Salam gauge group.

Our situation is different: the first-order condition is **trivially satisfied** (not dropped). This means:
- Inner fluctuations are linear (standard): $A_\mu = \sum_i a_i [D, \pi(b_i)]$
- No quadratic corrections arise
- The condition is satisfied automatically, requiring no reduction of A

The backtracking trigger in the plan -- "If A_F is trivial (C only)" -- does NOT apply. A_F = M_n(C) is **maximal**, not trivial. The issue is the opposite: A_F is too large, giving U(n) instead of the SM gauge group.

## Summary (Barrett-form D)

The first-order condition $[[D_K, \pi(a)], \pi_o(b)] = 0$ is **automatically satisfied for all $a, b \in M_n(\mathbb{C})$** when $D$ is the Barrett-form Dirac operator $D_K(X) = KX + XK$ with $K \in M_n(\mathbb{R})^{\text{sym}}$.

The proof has three lines:
1. $[D_1, L_a] = L_{[K,a]}$ (because $[R_K, L_a] = 0$)
2. $[L_{[K,a]}, R_b] = 0$ (associativity of matrix multiplication)
3. The doubled space adds nothing (sector-swap does not affect L-R commutativity)

$\therefore A_F = M_n(\mathbb{C})$, gauge group $= U(n)$. At $n = 4$: $U(4)$, not $U(1) \times SU(2) \times SU(3)$.

---

## Part II: First-Order Condition for General D from Full Moduli Space

**Added in Plan 15-02.** The Barrett-form D occupies only an $n(n+1)/2$-dimensional subspace of the full $n^2(n^2+1)$-dimensional D moduli space (Phase 14-01). We now compute the first-order condition for general D from the full moduli space.

### Step 8: General M decomposition and [M, L_a] structure

Any linear map $M: M_n(\mathbb{C}) \to M_n(\mathbb{C})$ can be written in operator-sum form:

$$M(X) = \sum_k A_k\, X\, B_k$$

for some matrices $A_k, B_k \in M_n(\mathbb{C})$.

Compute $[M, L_a]$ for general $M$:

$$[M, L_a](X) = M(aX) - a\,M(X) = \sum_k A_k\,(aX)\,B_k - a\,\sum_k A_k\,X\,B_k$$

$$= \sum_k (A_k a - a A_k)\,X\,B_k = \sum_k [A_k, a]\,X\,B_k \qquad \text{(15-02.1)}$$

For Barrett-form $M(X) = KX + XK$: $A_1 = K, B_1 = I$; $A_2 = I, B_2 = K$. Then $[A_2, a] = [I, a] = 0$, so only the $B_1 = I$ term survives, giving $[M, L_a] = L_{[K,a]}$ (pure left multiplication, recovering Eq. 15-01.2).

SELF-CRITIQUE CHECKPOINT (Step 8):
1. SIGN CHECK: [A_k, a] = A_k a - a A_k. Consistent with convention lock. OK.
2. FACTOR CHECK: No factors introduced. OK.
3. CONVENTION CHECK: [A,B] = AB - BA. OK.
4. DIMENSION CHECK: [M, L_a] maps M_n(C) -> M_n(C). Each term [A_k, a] X B_k is n x n. OK.

### Step 9: Double commutator for general M

$$[[M, L_a], R_b](X) = [M, L_a](Xb) - ([M, L_a](X))\,b$$

$$= \sum_k [A_k, a]\,(Xb)\,B_k - \sum_k [A_k, a]\,X\,B_k\,b$$

$$= \sum_k [A_k, a]\,X\,(bB_k - B_k b) \qquad \text{(using associativity: } (Xb)B_k = X(bB_k)\text{)}$$

$$= \sum_k [A_k, a]\,X\,[b, B_k] \qquad \text{(15-02.2)}$$

This is the **master formula** for the double commutator with general $M$.

**Key structural observation:** The double commutator decomposes as a sum of terms, each of the form

$$\text{(left factor depending on } a\text{)} \;\times\; X \;\times\; \text{(right factor depending on } b\text{)}$$

For Barrett-form D: all $B_k$ are scalar multiples of $I$, so $[b, B_k] = 0$ and the double commutator vanishes for all $a, b$. This is why Barrett-form gives $A_F = M_n(\mathbb{C})$.

For general D: $B_k$ are non-scalar, so $[b, B_k] \neq 0$ for generic $b$. The condition $\sum_k [A_k, a] X [b, B_k] = 0$ for all $X, b$ forces constraints on $a$.

SELF-CRITIQUE CHECKPOINT (Step 9):
1. SIGN CHECK: $(Xb)B_k = X(bB_k)$ (associativity). The sign of $[b, B_k] = bB_k - B_k b$ follows from expanding $X b B_k - X B_k b$. OK.
2. FACTOR CHECK: No new factors. OK.
3. CONVENTION CHECK: [A,B] = AB - BA. OK.
4. DIMENSION CHECK: $\sum_k [A_k, a] X [b, B_k]$ is n x n for each X. OK.

### Step 10: A_F for generic D is C (scalars only)

For $\sum_k [A_k, a] X [b, B_k] = 0$ to hold for all $X$ and all $b$:

Since $X$ is arbitrary, the equation $C X D = 0$ for all $X$ forces $C = 0$ or $D = 0$. Therefore, for each linearly independent right factor $[b, B_k]$, the corresponding left factor $[A_k, a]$ must vanish.

More precisely: fix a specific $b$ such that $[b, B_k] \neq 0$ for some $k$. Then $\sum_k [A_k, a] X [b, B_k] = 0$ for all $X$. By the rank-one decomposition of $X$, this means $\sum_k [A_k, a] \otimes [b, B_k] = 0$ as elements of $M_n(\mathbb{C}) \otimes M_n(\mathbb{C})$. If the matrices $\{[b, B_k]\}_k$ are linearly independent for various $b$, then $[A_k, a] = 0$ for all $k$.

For a **generic** $M$ (i.e., random coefficients in the moduli basis), the set of $A_k$ spans $M_n(\mathbb{C})$, and the condition $[A_k, a] = 0$ for all $k$ forces $a \in Z(M_n(\mathbb{C})) = \mathbb{C} \cdot I$.

$$\therefore\; A_F = \mathbb{C} \cdot I \quad \text{(scalars only, dim = 1)} \qquad \text{(15-02.3)}$$

### Step 11: Numerical verification at n = 2, 3, 4

**Sampling protocol:** For each $n$, construct the full moduli basis (dim $= n^2(n^2+1)$) using `build_moduli_basis(n)`. Form random $D$ as linear combinations with Gaussian random coefficients. Compute the constraint matrix for the first-order condition and find the null space dimension via SVD.

**Results:**

| n | Full moduli dim | 20 random D: dim(A_F) | Barrett D: dim(A_F) | Drop |
|---|---|---|---|---|
| 2 | 20 | 1 (all 20 samples) | 4 (= n^2) | 4 -> 1 |
| 3 | 90 | 1 (all 10 samples) | 9 (= n^2) | 9 -> 1 |
| 4 | 272 | 1 (all 10 samples) | 16 (= n^2) | 16 -> 1 |

**SVD tolerance stability:** At $n = 2$, the result dim$(A_F) = 1$ is stable under SVD threshold variation from $10^{-8}$ to $10^{-12}$. The smallest non-null singular value is $O(1)$, confirming a clean gap.

**Barrett consistency:** Barrett-form D (random real symmetric $K$) gives dim$(A_F) = n^2$ in all cases, consistent with Plan 15-01.

**Mixing test:** At $n = 2$, adding $\epsilon \times$ (random moduli D) to Barrett D gives:
- $\epsilon = 0$: dim$(A_F) = 4$ (Barrett)
- $\epsilon = 0.01$: dim$(A_F) = 1$ (immediately drops)

The transition is **discontinuous**: any non-Barrett perturbation breaks $A_F = M_n(\mathbb{C})$ to $A_F = \mathbb{C}$.

**Null space verification:** The 1-dimensional null space at dim$(A_F) = 1$ is spanned by $a = I_n$ (identity matrix), confirming $A_F = \mathbb{C} \cdot I$.

SELF-CRITIQUE CHECKPOINT (Step 11):
1. SIGN CHECK: N/A (numerical computation). OK.
2. FACTOR CHECK: N/A (numerical). OK.
3. CONVENTION CHECK: build_pi_a, build_pi_o_b, double_commutator all use the same conventions as Plan 15-01. OK.
4. DIMENSION CHECK: Constraint matrix size is correct: n^2 x (choices of b) x (2n^2)^2 rows, n^2 columns (for a components). OK.

### Step 12: Structural analysis -- Why Barrett D is special

The Barrett-form $D_1(X) = KX + XK$ has the special property that its "operator-sum" decomposition $M(X) = \sum_k A_k X B_k$ has all $B_k$ proportional to identity:
- $M(X) = KX + XK$: $A_1 = K, B_1 = I$; $A_2 = I, B_2 = K$.
- The $B_2 = K$ term does NOT contribute to the commutator because $[A_2, a] = [I, a] = 0$.
- Effectively, only the $B_1 = I$ term matters, and $[b, B_1] = [b, I] = 0$.

For general $M$ from the full moduli space, $M$ involves operators of the form $A_k X B_k$ where $B_k$ is non-scalar. When $B_k$ is non-scalar, $[b, B_k] \neq 0$ for generic $b$, producing a non-zero right factor in the double commutator. The only way to kill the double commutator for ALL $b$ is to have $[A_k, a] = 0$ for all $k$ with non-scalar $B_k$. For generic $M$, the $A_k$ span all of $M_n(\mathbb{C})$, and $a$ must commute with everything: $a \in Z(M_n(\mathbb{C})) = \mathbb{C} \cdot I$.

**In bimodule language:** The Barrett-form D is the unique type of $D$ whose commutator $[D, \pi(a)]$ lies entirely in $\pi(A) = L_A$ (the algebra of left multiplications). For general $D$, $[D, \pi(a)]$ has components in $L_A \otimes R_A$ (mixed left-right), and these mixed components generate non-trivial constraints from the second commutator with $\pi_o(b)$.

### Step 13: Codimension of the Barrett subspace

The Barrett subspace of the moduli space has dimension $n(n+1)/2$, while the full moduli space has dimension $n^2(n^2+1)$. The complement has dimension:

$$n^2(n^2+1) - \frac{n(n+1)}{2} = \frac{n(2n^3 + 2n^2 - n - 1)}{2} = \frac{n(n+1)(2n^2-1)}{2}$$

At $n = 4$: $272 - 10 = 262$. The Barrett subspace is a tiny fraction ($10/272 \approx 3.7\%$) of the full moduli space. The $A_F = M_n(\mathbb{C})$ locus is measure-zero in the full moduli space.

**The first-order condition forces D into the Barrett subspace** if we want $A_F = M_n(\mathbb{C})$ (full algebra, gauge group $U(n)$). This is precisely Barrett's result (arXiv:1502.05383): imposing the first-order condition with $A_F = A$ on a matrix geometry reduces the Dirac operator to the Barrett-form $D_1(X) = KX + XK^*$ with $K$ satisfying $\bar{K} = K$ (reality condition, our $K^T = K$).

## Part III: Phase Synthesis

### Summary Table

| n | Full moduli dim | Barrett dim | Barrett D: A_F | Barrett D: gauge | General D: A_F | General D: gauge |
|---|---|---|---|---|---|---|
| 2 | 20 | 3 | M_2(C), dim 4 | U(2) | C, dim 1 | U(1) |
| 3 | 90 | 6 | M_3(C), dim 9 | U(3) | C, dim 1 | U(1) |
| 4 | 272 | 10 | M_4(C), dim 16 | U(4) | C, dim 1 | U(1) |

### Comparison with CCM classification

The CCM construction (arXiv:0706.3688) achieves $A_F = \mathbb{C} \oplus \mathbb{H} \oplus M_3(\mathbb{C})$ (dim 14) from the direct sum algebra $A = M_2(\mathbb{H}) \oplus M_4(\mathbb{C})$. Our results show:

1. **Barrett-form D gives $A_F = M_n(\mathbb{C})$** (full algebra, too large). The gauge group $U(n)$ is not the SM gauge group.

2. **General D gives $A_F = \mathbb{C}$** (scalars only, too small). The gauge group $U(1)$ is trivially small.

3. **Neither case produces $A_F = \mathbb{C} \oplus \mathbb{H} \oplus M_3(\mathbb{C})$.** The first-order condition on the simple algebra $M_n(\mathbb{C})$ gives either the full algebra or the center, depending on whether $D$ is Barrett-form or general. There is no intermediate regime.

This is structurally necessary: the Wedderburn-Artin theorem classifies subalgebras of $M_n(\mathbb{C})$, and the only subalgebras closed under left-right multiplication structure of the bimodule $H = 2 \times M_n(\mathbb{C})$ are $\mathbb{C} \cdot I$ and $M_n(\mathbb{C})$ itself. The direct sum structure in CCM creates cross-terms that enable intermediate subalgebras.

### Implications for the self-modeling spectral triple program

**Success tier assessment:** This is the **"medium success" tier** from the Phase 17 roadmap. The self-modeling M_n(C) spectral triple exists (order zero, D axioms, and first-order condition all have consistent solutions), but:

- With Barrett-form D (the natural self-modeling D from the Jordan product): gauge group is U(n), not SM.
- With general D: gauge group is U(1), even less SM-like.
- The first-order condition cannot produce $\mathbb{C} \oplus \mathbb{H} \oplus M_3(\mathbb{C})$ from simple $M_n(\mathbb{C})$.

**The fundamental limitation:** The SM gauge group emerges from a **direct sum** algebra in the CCM framework. The self-modeling construction yields a **simple** algebra $M_n(\mathbb{C})$, which cannot produce the SM gauge group through the first-order condition alone. This is a structural impossibility, not a failure of the specific D chosen.

**Path forward (for Phase 16-17):**
1. The spectral triple $(A, H, D, J, \gamma)$ with Barrett-form D at $n = 4$ is a valid real spectral triple of KO-dimension 6 with gauge group $U(4)$.
2. To obtain SM gauge group, one would need: (a) a different starting algebra (direct sum), or (b) additional physical constraints beyond the spectral triple axioms that break $M_n(\mathbb{C})$ into a direct sum, or (c) working with a different bimodule structure.
3. The Pati-Salam route (CCSV, arXiv:1304.8050) is not relevant here because the first-order condition is satisfied (not dropped).

### Connection to Barrett 2015

Our results are fully consistent with Barrett 2015 (arXiv:1502.05383):
- Barrett's Proposition 3.1: for a matrix geometry with simple algebra $M_n(\mathbb{C})$, the first-order condition with $A_F = A$ forces $D_1(X) = KX + XK^*$ (our Barrett-form).
- Barrett's framework assumes $A_F = A$ from the start; we verified this is the maximal possible $A_F$ for Barrett-form D, and that general D gives $A_F = \mathbb{C}$ (smaller).
- The dimension counting matches: Barrett's D has $n(n+1)/2$ real parameters (for $K$ real symmetric), matching our Barrett subspace dimension.
