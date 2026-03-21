# Maximal Coherence Analysis: Does S5 Force c = 1?

% ASSERT_CONVENTION: natural_units=N/A, metric_signature=N/A, fourier_convention=N/A, coupling_convention=N/A, renormalization_scheme=N/A, gauge_choice=N/A
% CUSTOM_CONVENTION: sequential_product=a & b (non-commutative), jordan_product=a * b = (1/2)(a & b + b & a), orthogonality=a perp b iff a & b = 0, complement=a^perp = 1 - a, compatibility=a | b iff a & b = b & a, sharp_effect=p & p = p and p & p^perp = 0, axiom_source=arXiv:1803.11139 Definition 2 EXCLUSIVELY, compression=C_p (Alfsen-Shultz P-projection for face(p))

**Phase:** 06-paper-assembly (targeted investigation)
**Date:** 2026-03-21
**Status:** Complete

---

## Question

The corrected sequential product on a spectral OUS is:

$$a \mathbin{\&} b = \sum_i \lambda_i C_{p_i}(b) + \sum_{i<j} f(\lambda_i, \lambda_j)\, P_{ij}(b)$$

The positivity bound gives $|f(\lambda_i, \lambda_j)| \leq \sqrt{\lambda_i \lambda_j}$. The paper uses $f = \sqrt{\lambda_i \lambda_j}$ (maximal coherence), selected by the self-modeling faithfulness argument.

**Does $f = c\sqrt{\lambda_i \lambda_j}$ for $0 < c < 1$ satisfy all S1-S7? Or does some axiom force $c = 1$?**

---

## Result

**S5 (compatible associativity) forces $c^2 = c$, hence $c = 1$ (or $c = 0$).** Sub-maximal coherence products with $0 < c < 1$ violate S5. Maximal coherence is not an independent assumption -- it is a consequence of the axioms.

**[CONFIDENCE: HIGH]** -- Proved analytically with explicit counterexample, verified by SymPy for $c \in \{0.3, 0.5, 0.7, 0.9\}$.

---

## Analytical Proof

### Setup

Define the $c$-product on $M_2(\mathbb{C})^{sa}$: for $a = \sum_i \lambda_i p_i$ (spectral decomposition),

$$a \mathbin{\&}_c b = \sum_i \lambda_i\, C_{p_i}(b) + \sum_{i<j} c\sqrt{\lambda_i \lambda_j}\, P_{ij}(b)$$

where $0 \leq c \leq 1$.

### Axiom-by-axiom analysis for $0 < c < 1$

**S1 (additivity in second argument): PASS.** The map $b \mapsto a \mathbin{\&}_c b$ is a sum of linear maps ($C_{p_i}$ and $P_{ij}$ are linear) with fixed coefficients. Linearity holds for any $c$.

**S2 (continuity in first argument): PASS.** The spectral decomposition varies continuously with $a$ in finite dimensions, and $c\sqrt{\lambda_i\lambda_j}$ is continuous in the spectral values.

**S3 (unitality, $1 \mathbin{\&}_c a = a$): PASS.** The spectral decomposition of $1$ is $1 = 1 \cdot 1$ (single projector). No Peirce 1-space terms arise. $1 \mathbin{\&}_c a = C_1(a) = a$.

**S4 (orthogonality symmetry): PASS.** The S4 proof (derivations/04-axiom-S4.md) uses only $f(0, x) = 0$. Since $c\sqrt{0 \cdot x} = 0$ for any $c$, S4 holds for all $c$.

**S5 (compatible associativity): FAILS for $0 < c < 1$.** This is the decisive axiom. Proof below.

S6 and S7 need not be checked since S5 already fails, but for completeness: both use simultaneous diagonalizability of compatible effects and would need separate analysis.

### S5 Failure Proof

**S5 states:** If $a \mid b$ (compatible), then $a \mathbin{\&}_c (b \mathbin{\&}_c d) = (a \mathbin{\&}_c b) \mathbin{\&}_c d$ for all effects $d$.

Take $a = \mathrm{diag}(\alpha_1, \alpha_2)$ and $b = \mathrm{diag}(\beta_1, \beta_2)$ in the same eigenbasis $\{P_0, P_1\}$. These are compatible since they share an eigenbasis ($[a,b] = 0$).

Let $d$ be an arbitrary effect with off-diagonal components: $d = [[d_{00}, d_{01}], [d_{01}^*, d_{11}]]$.

**Step 1: Compute $a \mathbin{\&}_c b$.**

Since $b$ is diagonal in $a$'s eigenbasis, $P_{01}(b) = 0$. Therefore:

$$a \mathbin{\&}_c b = \alpha_1\, C_{P_0}(b) + \alpha_2\, C_{P_1}(b) = \mathrm{diag}(\alpha_1\beta_1, \alpha_2\beta_2)$$

This is $c$-independent. The product of compatible effects does not involve the mixing function.

**Step 2: Compute $(a \mathbin{\&}_c b) \mathbin{\&}_c d$ (RHS of S5).**

$a \mathbin{\&}_c b = \mathrm{diag}(\alpha_1\beta_1, \alpha_2\beta_2)$ has the same eigenbasis $\{P_0, P_1\}$ with eigenvalues $\alpha_1\beta_1$ and $\alpha_2\beta_2$.

$$(a \mathbin{\&}_c b) \mathbin{\&}_c d = \alpha_1\beta_1\, C_{P_0}(d) + \alpha_2\beta_2\, C_{P_1}(d) + c\sqrt{\alpha_1\beta_1 \cdot \alpha_2\beta_2}\, P_{01}(d)$$

The Peirce 1-space coefficient on the RHS is:

$$\boxed{\text{RHS coefficient} = c\sqrt{\alpha_1\alpha_2\beta_1\beta_2}}$$

**Step 3: Compute $b \mathbin{\&}_c d$ (inner product of LHS).**

$b = \mathrm{diag}(\beta_1, \beta_2)$ in the same eigenbasis:

$$b \mathbin{\&}_c d = \beta_1\, C_{P_0}(d) + \beta_2\, C_{P_1}(d) + c\sqrt{\beta_1\beta_2}\, P_{01}(d)$$

**Step 4: Compute $a \mathbin{\&}_c (b \mathbin{\&}_c d)$ (LHS of S5).**

$a = \mathrm{diag}(\alpha_1, \alpha_2)$ in the same eigenbasis. The argument $b \mathbin{\&}_c d$ has Peirce 2-space and Peirce 1-space components in this basis:

- Peirce 2-space: $\beta_1 C_{P_0}(d) + \beta_2 C_{P_1}(d)$
- Peirce 1-space: $c\sqrt{\beta_1\beta_2}\, P_{01}(d)$

By S1 (linearity in second argument, which holds for any $c$):

$$a \mathbin{\&}_c (b \mathbin{\&}_c d) = \beta_1\, (a \mathbin{\&}_c C_{P_0}(d)) + \beta_2\, (a \mathbin{\&}_c C_{P_1}(d)) + c\sqrt{\beta_1\beta_2}\, (a \mathbin{\&}_c P_{01}(d))$$

Now:
- $C_{P_0}(d)$ is purely in $V_2(P_0)$ (diagonal in the 00-slot), so $a \mathbin{\&}_c C_{P_0}(d) = \alpha_1\, C_{P_0}(d)$.
- $C_{P_1}(d)$ is purely in $V_0(P_0)$ (diagonal in the 11-slot), so $a \mathbin{\&}_c C_{P_1}(d) = \alpha_2\, C_{P_1}(d)$.
- $P_{01}(d)$ is purely in $V_1$ (off-diagonal), so compressions give zero: $C_{P_0}(P_{01}(d)) = C_{P_1}(P_{01}(d)) = 0$ and $P_{01}(P_{01}(d)) = P_{01}(d)$. Therefore:
  $$a \mathbin{\&}_c P_{01}(d) = c\sqrt{\alpha_1\alpha_2}\, P_{01}(d)$$

Combining:

$$a \mathbin{\&}_c (b \mathbin{\&}_c d) = \alpha_1\beta_1\, C_{P_0}(d) + \alpha_2\beta_2\, C_{P_1}(d) + c\sqrt{\beta_1\beta_2} \cdot c\sqrt{\alpha_1\alpha_2}\, P_{01}(d)$$

The Peirce 1-space coefficient on the LHS is:

$$\boxed{\text{LHS coefficient} = c^2\sqrt{\alpha_1\alpha_2\beta_1\beta_2}}$$

**Step 5: Compare.**

$$\text{LHS} - \text{RHS} = (c^2 - c)\sqrt{\alpha_1\alpha_2\beta_1\beta_2}\, P_{01}(d)$$

This vanishes for all compatible $a, b$ and all $d$ (with $P_{01}(d) \neq 0$ and all $\alpha_i, \beta_j > 0$) if and only if:

$$c^2 = c \quad \Longleftrightarrow \quad c \in \{0, 1\}$$

**Conclusion:** For $0 < c < 1$, S5 is violated. The equation $c^2 = c$ has no solutions in the open interval $(0, 1)$. $\square$

### Explicit counterexample

Take $c = 1/2$, $a = \mathrm{diag}(3/4, 1/4)$, $b = \mathrm{diag}(2/3, 1/3)$, $d = P_+ = \frac{1}{2}\begin{pmatrix}1&1\\1&1\end{pmatrix}$.

Then $a \mid b$ (both diagonal, with distinct eigenvalues), and $\sqrt{\alpha_1\alpha_2\beta_1\beta_2} = \sqrt{1/24} = \sqrt{6}/12$:

- $\text{LHS Peirce 1-space coeff} = c^2 \cdot \sqrt{6}/12 = (1/4) \cdot \sqrt{6}/12 = \sqrt{6}/48$
- $\text{RHS Peirce 1-space coeff} = c \cdot \sqrt{6}/12 = (1/2) \cdot \sqrt{6}/12 = \sqrt{6}/24$

These differ by a factor of 2. S5 fails.

**Important:** Both $a$ and $b$ must have distinct (non-degenerate) eigenvalues for the Peirce 1-space to be nontrivial. If $b = I/2$ (degenerate), its spectral projector is $I$ itself, so $b \mathbin{\&}_c d = (1/2)d$ regardless of $c$, and S5 holds vacuously.

### SELF-CRITIQUE CHECKPOINT:
1. SIGN CHECK: The difference $(c^2 - c)$ is negative for $0 < c < 1$, meaning the LHS has a smaller Peirce 1-space contribution than the RHS. The nested application compounds the decoherence ($c$ appears twice), while the single application uses $c$ once. Physically sensible.
2. FACTOR CHECK: No spurious factors. The $c^2$ arises from exactly two applications of the mixing function: once in $b \mathbin{\&}_c d$ (inner product) and once in $a \mathbin{\&}_c (\cdot)$ (outer product acting on the Peirce 1-space component). The single $c$ on the RHS comes from one application of the mixing function to the pre-composed effect $a \mathbin{\&}_c b$.
3. CONVENTION CHECK: S5 states $a \mid b \Rightarrow a \mathbin{\&} (b \mathbin{\&} d) = (a \mathbin{\&} b) \mathbin{\&} d$. The compatible pair is $(a, b)$ in the first two positions; $d$ is the arbitrary effect. Matches arXiv:1803.11139 Def. 2.
4. DIMENSION CHECK: All quantities dimensionless. All matrices $2 \times 2$ Hermitian. Correct.

---

## Physical Interpretation

The S5 failure has a clean physical meaning. In the LHS $a \mathbin{\&}_c (b \mathbin{\&}_c d)$, the mixing function is applied twice:

1. First, $b \mathbin{\&}_c d$ applies decoherence factor $c$ to $d$'s off-diagonal components.
2. Then, $a \mathbin{\&}_c (\cdot)$ applies decoherence factor $c$ again.

The net effect on the off-diagonal sector is $c \times c = c^2$.

In the RHS $(a \mathbin{\&}_c b) \mathbin{\&}_c d$, the effects $a$ and $b$ first compose (with no decoherence since they share an eigenbasis), and then the combined effect applies decoherence factor $c$ once. The net effect is $c$.

Associativity for compatible effects demands that the order of operations doesn't matter. This forces $c^2 = c$.

The only non-trivial solution is $c = 1$ (maximal coherence). The trivial solution $c = 0$ gives the pinching product, which fails S3 (unitality) on non-commutative systems as shown in Plan 01.

**Therefore, maximal coherence is the unique choice satisfying S1-S7.** The self-modeling faithfulness argument and the S5 axiom independently select the same value. This is a strong consistency check on the framework.

---

## SymPy Verification

The following script was run to verify the analytical result numerically.

```python
#!/usr/bin/env python3
"""
Maximal coherence analysis: test whether f = c*sqrt(lambda_i*lambda_j)
with 0 < c < 1 satisfies S5 (compatible associativity).

Result: S5 FAILS for all 0 < c < 1. The Peirce 1-space coefficients
differ by a factor of c vs c^2 in the nested product.
"""
from sympy import (
    Matrix, sqrt, Rational, eye, zeros, simplify, Symbol, I as symI
)


def corrected_sp_c(a, b, c_param):
    """Corrected sequential product with mixing function f = c * sqrt(lam_i * lam_j).

    Correctly handles degenerate eigenvalues by merging projectors for
    the same spectral value (as required by the spectral decomposition).
    """
    eigdata = a.eigenvects()
    projectors = []
    for eigenval, multiplicity, eigvecs in eigdata:
        proj = zeros(2)
        for v in eigvecs:
            norm_sq = v.dot(v.conjugate())
            v_norm = v / sqrt(norm_sq)
            proj = proj + v_norm * v_norm.H
        projectors.append((simplify(eigenval), simplify(proj)))
    n = len(projectors)
    result = zeros(2)
    for lam_i, p_i in projectors:
        result = result + lam_i * (p_i * b * p_i)
    if n >= 2:
        pinch = zeros(2)
        for _, p_i in projectors:
            pinch = pinch + p_i * b * p_i
        peirce_1 = b - pinch
        for i in range(n):
            for j in range(i + 1, n):
                lam_i = projectors[i][0]
                lam_j = projectors[j][0]
                weight = c_param * sqrt(lam_i * lam_j)
                result = result + weight * peirce_1
    return simplify(result)


I2 = eye(2)
P0 = Matrix([[1, 0], [0, 0]])
P1 = Matrix([[0, 0], [0, 1]])
Px_plus = Rational(1, 2) * Matrix([[1, 1], [1, 1]])

# S5 test: a | b (both diagonal with DISTINCT eigenvalues)
a = Matrix([[Rational(3, 4), 0], [0, Rational(1, 4)]])
b = Matrix([[Rational(2, 3), 0], [0, Rational(1, 3)]])
d = Px_plus

for c_val in [Rational(3, 10), Rational(1, 2), Rational(7, 10), Rational(9, 10)]:
    inner = corrected_sp_c(b, d, c_val)
    lhs = corrected_sp_c(a, inner, c_val)
    ab = corrected_sp_c(a, b, c_val)
    rhs = corrected_sp_c(ab, d, c_val)
    diff = simplify(lhs - rhs)
    is_zero = diff.equals(zeros(2))
    print(f"c = {c_val}:")
    print(f"  LHS - RHS = {diff}")
    print(f"  S5 holds? {is_zero}")
    print()

c_val = Rational(1, 1)
inner = corrected_sp_c(b, d, c_val)
lhs = corrected_sp_c(a, inner, c_val)
ab = corrected_sp_c(a, b, c_val)
rhs = corrected_sp_c(ab, d, c_val)
diff = simplify(lhs - rhs)
is_zero = diff.equals(zeros(2))
print(f"c = {c_val} (maximal coherence):")
print(f"  LHS - RHS = {diff}")
print(f"  S5 holds? {is_zero}")

# Verify S1, S3, S4 all pass for c < 1
print("\n=== S1, S3, S4 checks for c = 1/2 ===")
c_half = Rational(1, 2)
s3_result = corrected_sp_c(I2, Px_plus, c_half)
print(f"S3 (1 & P+ = P+): {simplify(s3_result - Px_plus).equals(zeros(2))}")
b1 = Rational(1, 4) * P0
b2 = Rational(1, 4) * Px_plus
lhs_s1 = corrected_sp_c(a, b1 + b2, c_half)
rhs_s1 = corrected_sp_c(a, b1, c_half) + corrected_sp_c(a, b2, c_half)
print(f"S1 (additivity in 2nd arg): {simplify(lhs_s1 - rhs_s1).equals(zeros(2))}")
print(f"S4 (P0 & P1 = 0): {corrected_sp_c(P0, P1, c_half).equals(zeros(2))}")
print(f"S4 (P1 & P0 = 0): {corrected_sp_c(P1, P0, c_half).equals(zeros(2))}")
```

### Script output:

```
c = 3/10:
  LHS - RHS = Matrix([[0, -7*sqrt(6)/800], [-7*sqrt(6)/800, 0]])
  S5 holds? False

c = 1/2:
  LHS - RHS = Matrix([[0, -sqrt(6)/96], [-sqrt(6)/96, 0]])
  S5 holds? False

c = 7/10:
  LHS - RHS = Matrix([[0, -7*sqrt(6)/800], [-7*sqrt(6)/800, 0]])
  S5 holds? False

c = 9/10:
  LHS - RHS = Matrix([[0, -3*sqrt(6)/800], [-3*sqrt(6)/800, 0]])
  S5 holds? False

c = 1 (maximal coherence):
  LHS - RHS = Matrix([[0, 0], [0, 0]])
  S5 holds? True

=== S1, S3, S4 checks for c = 1/2 ===
S3 (1 & P+ = P+): True
S1 (additivity in 2nd arg): True
S4 (P0 & P1 = 0): True
S4 (P1 & P0 = 0): True
```

---

## Summary of Axiom Status for $f = c\sqrt{\lambda_i\lambda_j}$, $0 < c < 1$

| Axiom | Status | Reason |
|-------|--------|--------|
| S1 (additivity in b) | PASS | Linearity of $C_{p_i}$ and $P_{ij}$; $c$-independent |
| S2 (continuity in a) | PASS | Continuous spectral decomposition + continuous $c\sqrt{\cdot}$ |
| S3 (unitality) | PASS | $1$ has trivial spectral decomposition; $c$-independent |
| S4 (orthogonality symmetry) | PASS | Proof uses only $f(0,x) = 0$; $c\sqrt{0 \cdot x} = 0$ |
| S5 (compatible associativity) | **FAIL** | LHS has $c^2\sqrt{\alpha_1\alpha_2\beta_1\beta_2}$; RHS has $c\sqrt{\alpha_1\alpha_2\beta_1\beta_2}$. Forces $c^2 = c$. |
| S6 (compatibility closure) | N/A | Not needed; S5 already fails |
| S7 (compatibility under SP) | N/A | Not needed; S5 already fails |

## Conclusion

**Maximal coherence ($c = 1$) is derived from the axioms, not assumed independently.** S5 (compatible associativity) forces $c^2 = c$, leaving only $c = 1$ (since $c = 0$ fails S3 on non-commutative systems). The self-modeling faithfulness argument in Plan 06 provides a physical motivation for the same choice that S5 makes algebraically mandatory.

This strengthens the paper's argument: the mixing function $f = \sqrt{\lambda_i\lambda_j}$ is the unique choice compatible with the sequential product axioms. No free parameter remains.

---

_Completed: 2026-03-21_
