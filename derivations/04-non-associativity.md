# Non-Associativity of the Self-Modeling Sequential Product

% ASSERT_CONVENTION: natural_units=N/A, metric_signature=N/A, fourier_convention=N/A, coupling_convention=N/A, renormalization_scheme=N/A, gauge_choice=N/A
% CUSTOM_CONVENTION: sequential_product=a & b (non-commutative), jordan_product=a * b = (1/2)(a & b + b & a), orthogonality=a perp b iff a & b = 0, complement=a^perp = 1 - a, sharp_effect=p & p = p and p & p^perp = 0, axiom_source=arXiv:1803.11139 Definition 2 EXCLUSIVELY, entropy_base=nats, compression=C_p (Alfsen-Shultz P-projection for face(p))

**Phase:** 04-sequential-product-formalization
**Plan:** 02 (non-associativity verification)
**Date:** 2026-03-21
**Status:** Complete
**Depends on:** Plan 01 (compression-based SP), Plan 06 (corrected product with Peirce feedback)

---

## Overview

This derivation verifies that the self-modeling sequential product (Eq. 04-06.4) is non-associative. We exhibit an explicit triple (a, b, c) of effects in M_2(C)^sa such that (a & b) & c != a & (b & c), with exact symbolic computation confirming a nonzero difference.

**Kill gate:** If the product were associative, then by Westerbaan-Westerbaan-vdW (Quantum 4, 378, 2020; arXiv:2004.12749), the algebra would be commutative (classical), and the sequential product route to quantum mechanics would be dead.

**Product used:** The corrected sequential product from Plan 06:

$$a \mathbin{\&} b = \sum_i \lambda_i C_{p_i}(b) + \sum_{i<j} \sqrt{\lambda_i \lambda_j}\, P_{ij}(b) \qquad \text{(Eq. 04-06.4)}$$

which coincides with the Luders product $\sqrt{a}\, b\, \sqrt{a}$ on $M_2(\mathbb{C})^{sa}$ (Eq. 04-06.5).

---

## Step 1: Choice of Test Space and Effects

**Test space:** $M_2(\mathbb{C})^{sa}$, the 4-dimensional real vector space of 2x2 Hermitian matrices with the trace-norm order unit space structure. This is the simplest non-classical case.

**Witness triple:**

$$a = \mathrm{diag}(3/4, 1/4) = \frac{1}{2}I + \frac{1}{4}\sigma_z$$

$$b = \frac{1}{2}(I + \tfrac{1}{2}\sigma_x) = \begin{pmatrix} 1/2 & 1/4 \\ 1/4 & 1/2 \end{pmatrix}$$

$$c = P_0 = |0\rangle\langle 0| = \begin{pmatrix} 1 & 0 \\ 0 & 0 \end{pmatrix}$$

**Validity check:** All three are effects (eigenvalues in [0,1]):
- $a$: eigenvalues $\{3/4, 1/4\}$
- $b$: eigenvalues $\{3/4, 1/4\}$
- $c$: eigenvalues $\{1, 0\}$

**Non-commutativity:** $a$ and $b$ do not commute ($a$ is diagonal, $b$ has off-diagonal entries in the $|0\rangle, |1\rangle$ basis), and $b$ and $c$ do not commute. The triple is not mutually compatible.

---

## Step 2: Compute a & b

The spectral decomposition of $a$ is $a = \frac{3}{4}P_0 + \frac{1}{4}P_1$, where $P_0 = |0\rangle\langle 0|$ and $P_1 = |1\rangle\langle 1|$.

Using Eq. (04-06.4):

$$a \mathbin{\&} b = \frac{3}{4}C_{P_0}(b) + \frac{1}{4}C_{P_1}(b) + \sqrt{\frac{3}{4}\cdot\frac{1}{4}}\, P_{01}(b)$$

Compute each term:

- $C_{P_0}(b) = P_0 b P_0 = \begin{pmatrix} 1/2 & 0 \\ 0 & 0 \end{pmatrix}$

- $C_{P_1}(b) = P_1 b P_1 = \begin{pmatrix} 0 & 0 \\ 0 & 1/2 \end{pmatrix}$

- $P_{01}(b) = b - C_{P_0}(b) - C_{P_1}(b) = \begin{pmatrix} 0 & 1/4 \\ 1/4 & 0 \end{pmatrix}$

- $\sqrt{3/4 \cdot 1/4} = \sqrt{3}/4$

Therefore:

$$a \mathbin{\&} b = \frac{3}{4}\begin{pmatrix}1/2&0\\0&0\end{pmatrix} + \frac{1}{4}\begin{pmatrix}0&0\\0&1/2\end{pmatrix} + \frac{\sqrt{3}}{4}\begin{pmatrix}0&1/4\\1/4&0\end{pmatrix}$$

$$\boxed{a \mathbin{\&} b = \begin{pmatrix} 3/8 & \sqrt{3}/16 \\ \sqrt{3}/16 & 1/8 \end{pmatrix}} \qquad \text{(Eq. 04-02.1)}$$

**Cross-check with Luders:** $\sqrt{a} = \mathrm{diag}(\sqrt{3}/2, 1/2)$, so $\sqrt{a}\, b\, \sqrt{a} = \begin{pmatrix} 3/8 & \sqrt{3}/16 \\ \sqrt{3}/16 & 1/8 \end{pmatrix}$. Matches.

### SELF-CRITIQUE CHECKPOINT (Step 2):
1. SIGN CHECK: All terms positive, consistent with PSD inputs. Check.
2. FACTOR CHECK: sqrt(3/16) = sqrt(3)/4, correctly applied to the 1/4 off-diagonal entry to give sqrt(3)/16. Check.
3. CONVENTION CHECK: Using corrected product Eq. (04-06.4), not the naive compression product. Check.
4. DIMENSION CHECK: All entries are dimensionless rationals or rationals times sqrt(3). Check.

---

## Step 3: Compute (a & b) & c

The matrix $a \mathbin{\&} b$ from Step 2 has eigenvalues:

$$\lambda_{\pm} = \frac{1}{4} \pm \frac{\sqrt{7}}{16}$$

These are the roots of the characteristic polynomial $\lambda^2 - \frac{1}{2}\lambda + \frac{3}{64} - \frac{3}{256} = \lambda^2 - \frac{1}{2}\lambda + \frac{9}{256} = 0$ ... let me verify:

$$\mathrm{tr}(a \mathbin{\&} b) = 3/8 + 1/8 = 1/2, \quad \det(a \mathbin{\&} b) = \frac{3}{8}\cdot\frac{1}{8} - \frac{3}{256} = \frac{3}{64} - \frac{3}{256} = \frac{9}{256}$$

So $\lambda_{\pm} = \frac{1/2 \pm \sqrt{1/4 - 9/64}}{2} = \frac{1/2 \pm \sqrt{7/64}}{2} = \frac{1}{4} \pm \frac{\sqrt{7}}{16}$.

The corrected product $(a \mathbin{\&} b) \mathbin{\&} c$ involves the spectral decomposition of $a \mathbin{\&} b$ and compression of $c = P_0$ into the eigenbasis of $a \mathbin{\&} b$. The exact result (computed symbolically via SymPy) is:

$$\boxed{(a \mathbin{\&} b) \mathbin{\&} c = \begin{pmatrix} 81/224 & 9\sqrt{3}/224 \\ 9\sqrt{3}/224 & 3/224 \end{pmatrix}} \qquad \text{(Eq. 04-02.2)}$$

**Verification:** tr = 81/224 + 3/224 = 84/224 = 3/8. det = (81*3 - 81*3)/224^2 = (243 - 243)/224^2 ... let me verify det correctly. det = (81/224)(3/224) - (9sqrt(3)/224)^2 = 243/224^2 - 243/224^2 = 0. So this is a rank-1 matrix, which makes sense because $c = P_0$ is rank-1 and the product maps it to a rank-1 result (physically: measuring a rank-1 projector after applying $a \mathbin{\&} b$ collapses to its image).

---

## Step 4: Compute b & c

The spectral decomposition of $b$ is $b = \frac{3}{4}|+\rangle\langle+| + \frac{1}{4}|-\rangle\langle-|$ where $|\pm\rangle = \frac{1}{\sqrt{2}}(|0\rangle \pm |1\rangle)$.

$$b \mathbin{\&} c = \sqrt{b}\, c\, \sqrt{b}$$

$$\sqrt{b} = \frac{\sqrt{3}}{2}|+\rangle\langle+| + \frac{1}{2}|-\rangle\langle-| = \frac{1}{4}\begin{pmatrix} \sqrt{3}+1 & \sqrt{3}-1 \\ \sqrt{3}-1 & \sqrt{3}+1 \end{pmatrix}$$

$$b \mathbin{\&} c = \sqrt{b}\, P_0\, \sqrt{b} = \sqrt{b}\begin{pmatrix}1\\0\end{pmatrix}\begin{pmatrix}1&0\end{pmatrix}\sqrt{b}$$

The first column of $\sqrt{b}$ is $\frac{1}{4}\begin{pmatrix}\sqrt{3}+1\\\sqrt{3}-1\end{pmatrix}$, so:

$$b \mathbin{\&} c = \frac{1}{16}\begin{pmatrix}(\sqrt{3}+1)^2 & (\sqrt{3}+1)(\sqrt{3}-1) \\ (\sqrt{3}+1)(\sqrt{3}-1) & (\sqrt{3}-1)^2\end{pmatrix}$$

$$= \frac{1}{16}\begin{pmatrix} 4 + 2\sqrt{3} & 2 \\ 2 & 4 - 2\sqrt{3}\end{pmatrix} = \begin{pmatrix} 1/4 + \sqrt{3}/8 & 1/8 \\ 1/8 & 1/4 - \sqrt{3}/8 \end{pmatrix}$$

$$\boxed{b \mathbin{\&} c = \begin{pmatrix} \sqrt{3}/8 + 1/4 & 1/8 \\ 1/8 & 1/4 - \sqrt{3}/8 \end{pmatrix}} \qquad \text{(Eq. 04-02.3)}$$

### SELF-CRITIQUE CHECKPOINT (Step 4):
1. SIGN CHECK: Entry (1,1) = 1/4 - sqrt(3)/8 = 1/4 - 0.2165... = 0.0335... > 0. Matrix is PSD. Check.
2. FACTOR CHECK: sqrt(b) entries use sqrt(3), combined with P0 gives 1/16 prefactor. Check.
3. CONVENTION CHECK: Still using corrected product = Luders on M_2(C)^sa. Check.
4. DIMENSION CHECK: All dimensionless. Check.

---

## Step 5: Compute a & (b & c)

$$a \mathbin{\&} (b \mathbin{\&} c) = \sqrt{a}\, (b \mathbin{\&} c)\, \sqrt{a}$$

With $\sqrt{a} = \mathrm{diag}(\sqrt{3}/2, 1/2)$:

$$a \mathbin{\&} (b \mathbin{\&} c) = \begin{pmatrix}\sqrt{3}/2 & 0 \\ 0 & 1/2\end{pmatrix} \begin{pmatrix} \sqrt{3}/8+1/4 & 1/8 \\ 1/8 & 1/4-\sqrt{3}/8 \end{pmatrix} \begin{pmatrix}\sqrt{3}/2 & 0 \\ 0 & 1/2\end{pmatrix}$$

$$= \begin{pmatrix} \frac{3}{4}\left(\frac{\sqrt{3}}{8}+\frac{1}{4}\right) & \frac{\sqrt{3}}{4}\cdot\frac{1}{8} \\ \frac{\sqrt{3}}{4}\cdot\frac{1}{8} & \frac{1}{4}\left(\frac{1}{4}-\frac{\sqrt{3}}{8}\right) \end{pmatrix}$$

$$= \begin{pmatrix} 3\sqrt{3}/32 + 3/16 & \sqrt{3}/32 \\ \sqrt{3}/32 & 1/16 - \sqrt{3}/32 \end{pmatrix}$$

$$\boxed{a \mathbin{\&} (b \mathbin{\&} c) = \begin{pmatrix} 3\sqrt{3}/32 + 3/16 & \sqrt{3}/32 \\ \sqrt{3}/32 & 1/16 - \sqrt{3}/32 \end{pmatrix}} \qquad \text{(Eq. 04-02.4)}$$

---

## Step 6: Non-Associativity Witness

**Eq. (04-02.5):** The difference is:

$$\Delta = (a \mathbin{\&} b) \mathbin{\&} c - a \mathbin{\&} (b \mathbin{\&} c)$$

$$\boxed{\Delta = \begin{pmatrix} 39/224 - 3\sqrt{3}/32 & \sqrt{3}/112 \\ \sqrt{3}/112 & -11/224 + \sqrt{3}/32 \end{pmatrix}} \qquad \text{(Eq. 04-02.5)}$$

**Non-zero verification (exact symbolic):**

The entry $\Delta_{00} = \frac{39}{224} - \frac{3\sqrt{3}}{32}$.

- $39/224 = 0.174107...$
- $3\sqrt{3}/32 = 0.162380...$
- $\Delta_{00} = 0.011727... \neq 0$

Since $\sqrt{3}$ is irrational and $39/224$ is rational, the only way $\frac{39}{224} = \frac{3\sqrt{3}}{32}$ would be if $\sqrt{3} = \frac{39 \cdot 32}{224 \cdot 3} = \frac{1248}{672} = \frac{13}{7}$. But $\left(\frac{13}{7}\right)^2 = \frac{169}{49} \neq 3$. Therefore $\Delta_{00} \neq 0$ exactly.

Similarly, $\Delta_{01} = \frac{\sqrt{3}}{112} \neq 0$ since $\sqrt{3} \neq 0$.

**The self-modeling sequential product is non-associative.**

### SELF-CRITIQUE CHECKPOINT (Step 6):
1. SIGN CHECK: Delta[0,0] > 0, Delta[1,1] > 0, Delta[0,1] = Delta[1,0] > 0. All positive. Delta is PSD? tr = 39/224 - 3sqrt(3)/32 - 11/224 + sqrt(3)/32 = 28/224 - 2sqrt(3)/32 = 1/8 - sqrt(3)/16 > 0 (since sqrt(3)/16 = 0.108 < 1/8 = 0.125). Check.
2. FACTOR CHECK: 224 = 7*32 arises from the eigenvalue structure of a & b. 112 = 7*16. Consistent.
3. CONVENTION CHECK: Using corrected product throughout. Cross-checked with Luders, which gives identical Delta.
4. DIMENSION CHECK: All dimensionless. Check.

---

## Step 7: Positive Controls

### Control 1: Luders product is also non-associative

The Luders product $a \mathbin{\&}_L b = \sqrt{a}\, b\, \sqrt{a}$ gives **identical** Delta for this triple because the corrected product coincides with Luders on M_2(C)^sa (Eq. 04-06.5). This is a consistency check: we are not computing the non-associativity of two different products.

**Result:** Luders Delta = corrected Delta. PASS.

### Control 2: Matrix multiplication is associative

For the same triple $(a, b, c)$:

$$(a \cdot b) \cdot c - a \cdot (b \cdot c) = 0$$

by the associativity of matrix multiplication. This confirms the test framework correctly distinguishes associative from non-associative products.

**Result:** Matrix mult Delta = 0. PASS.

---

## Step 8: Implication (Westerbaan-Westerbaan-vdW)

**Theorem (Westerbaan, Westerbaan, van de Wetering, Quantum 4, 378 (2020), arXiv:2004.12749):** In a normal sequential effect algebra, if the sequential product is associative, then the algebra is commutative.

**Contrapositive:** If the algebra is non-commutative, the sequential product must be non-associative.

**Application to our construction:**

The self-modeling sequential product on M_2(C)^sa is non-associative (Eq. 04-02.5). By the WWvdW contrapositive, this is **consistent** with the algebra being non-commutative (quantum). More precisely:

1. Our product is defined on M_2(C)^sa, which IS a non-commutative order unit space.
2. The product satisfies S1 (additivity in b) and S2 (continuity in a) and S3 (unitality) -- verified in Plan 06.
3. Non-associativity is therefore **necessary** for compatibility with the non-commutative structure.
4. If the product had been associative, WWvdW would force commutativity, contradicting the M_2(C)^sa structure. The program would be dead.

**The kill gate is passed.** The sequential product route to quantum mechanics survives this checkpoint.

**Important caveat:** Non-associativity is NECESSARY but not SUFFICIENT. The product must also satisfy S4-S7 for the full vdW Theorem 1 to apply. These are checked in Plans 03-05.

---

## Summary of Results

| Equation | Content |
|----------|---------|
| Eq. (04-02.1) | $a \mathbin{\&} b = \begin{pmatrix} 3/8 & \sqrt{3}/16 \\ \sqrt{3}/16 & 1/8 \end{pmatrix}$ |
| Eq. (04-02.2) | $(a \mathbin{\&} b) \mathbin{\&} c = \begin{pmatrix} 81/224 & 9\sqrt{3}/224 \\ 9\sqrt{3}/224 & 3/224 \end{pmatrix}$ |
| Eq. (04-02.3) | $b \mathbin{\&} c = \begin{pmatrix} \sqrt{3}/8 + 1/4 & 1/8 \\ 1/8 & 1/4 - \sqrt{3}/8 \end{pmatrix}$ |
| Eq. (04-02.4) | $a \mathbin{\&} (b \mathbin{\&} c) = \begin{pmatrix} 3\sqrt{3}/32 + 3/16 & \sqrt{3}/32 \\ \sqrt{3}/32 & 1/16 - \sqrt{3}/32 \end{pmatrix}$ |
| Eq. (04-02.5) | $\Delta = \begin{pmatrix} 39/224 - 3\sqrt{3}/32 & \sqrt{3}/112 \\ \sqrt{3}/112 & -11/224 + \sqrt{3}/32 \end{pmatrix} \neq 0$ |

**Conclusion:** The self-modeling sequential product (Eq. 04-06.4) is non-associative on M_2(C)^sa. By the Westerbaan-Westerbaan-vdW theorem, this is necessary for the algebra to be non-commutative. The kill gate is passed: the sequential product route to quantum mechanics survives.

---

_Phase: 04-sequential-product-formalization, Plan: 02_
_Completed: 2026-03-21_
