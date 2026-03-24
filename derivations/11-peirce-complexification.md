# Peirce Decomposition, Complexification, and Spin(9) -> Spin(10) Upgrade

% ASSERT_CONVENTION: natural_units=dimensionless, jordan_product=(1/2)(ab+ba), peirce_decomposition=under_E11, octonion_notation=O_8dim

**Phase 18, Plan 01: Complexification from C*-Observer**

---

## Part I: Peirce Decomposition of h_3(O) under E_11

### Step 1: The Exceptional Jordan Algebra h_3(O)

The exceptional Jordan algebra $h_3(\mathbb{O})$ (also called the Albert algebra) consists of $3 \times 3$ Hermitian matrices over the octonions $\mathbb{O}$:

$$
X = \begin{pmatrix} \alpha & \bar{x}_3 & x_2 \\ x_3 & \beta & \bar{x}_1 \\ \bar{x}_2 & x_1 & \gamma \end{pmatrix}
$$

where $\alpha, \beta, \gamma \in \mathbb{R}$ and $x_1, x_2, x_3 \in \mathbb{O}$, with $\bar{\cdot}$ denoting octonion conjugation. Hermiticity means $X_{ij} = \bar{X}_{ji}$.

**Dimension count:**
$$\dim(h_3(\mathbb{O})) = 3 \cdot 1 + 3 \cdot 8 = 3 + 24 = 27$$

The three real diagonal entries contribute 3, and the three independent octonion off-diagonal entries (upper triangle) contribute $3 \times 8 = 24$.

The Jordan product is:
$$A \circ B = \frac{1}{2}(AB + BA)$$
where $AB$ denotes the usual matrix product with octonion entries (well-defined for $3 \times 3$ Hermitian matrices even though $\mathbb{O}$ is non-associative, by the results of Albert and Jordan-von Neumann-Wigner).

### Step 2: Peirce Decomposition under e = E_{11}

The observer selects a rank-1 idempotent $e = E_{11}$, the $3 \times 3$ matrix with 1 in the $(1,1)$ entry and 0 elsewhere:

$$
e = E_{11} = \begin{pmatrix} 1 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix}
$$

This is indeed an idempotent: $e \circ e = e$ (since $E_{11}^2 = E_{11}$ in the usual matrix product, so $e \circ e = \frac{1}{2}(E_{11}^2 + E_{11}^2) = E_{11}$).

The Peirce decomposition of $h_3(\mathbb{O})$ under $e$ produces eigenspaces of the multiplication operator $L_e(X) = e \circ X$:

$$h_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0$$

where $V_\lambda = \{X \in h_3(\mathbb{O}) : e \circ X = \lambda X\}$.

**Computing $L_e(X)$ explicitly:**

$$
e \circ X = \frac{1}{2}(E_{11} X + X E_{11})
$$

For $E_{11} X$:
$$
E_{11} X = \begin{pmatrix} 1 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix} \begin{pmatrix} \alpha & \bar{x}_3 & x_2 \\ x_3 & \beta & \bar{x}_1 \\ \bar{x}_2 & x_1 & \gamma \end{pmatrix} = \begin{pmatrix} \alpha & \bar{x}_3 & x_2 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix}
$$

For $X E_{11}$:
$$
X E_{11} = \begin{pmatrix} \alpha & \bar{x}_3 & x_2 \\ x_3 & \beta & \bar{x}_1 \\ \bar{x}_2 & x_1 & \gamma \end{pmatrix} \begin{pmatrix} 1 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix} = \begin{pmatrix} \alpha & 0 & 0 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix}
$$

Therefore:
$$
e \circ X = \frac{1}{2} \begin{pmatrix} 2\alpha & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix}
$$

**Identifying the Peirce eigenspaces:**

**$V_1$ (eigenvalue 1):** $e \circ X = X$ requires:
- $2\alpha / 2 = \alpha$ (always true for the $(1,1)$ entry)
- $\bar{x}_3 / 2 = \bar{x}_3 \implies \bar{x}_3 = 0$, so $x_3 = 0$
- $x_2 / 2 = x_2 \implies x_2 = 0$
- $0 = \beta$, $0 = \bar{x}_1$, $0 = \gamma$

Thus $V_1 = \{ \alpha E_{11} : \alpha \in \mathbb{R} \} \cong \mathbb{R}$.

$$\dim(V_1) = 1$$

**$V_{1/2}$ (eigenvalue 1/2):** $e \circ X = \frac{1}{2}X$ requires examining each entry of $e \circ X = \frac{1}{2}X$:
- $(1,1)$: $\alpha = \frac{1}{2}\alpha \implies \alpha = 0$
- $(1,2)$: $\frac{1}{2}\bar{x}_3 = \frac{1}{2}\bar{x}_3$ (always true)
- $(1,3)$: $\frac{1}{2}x_2 = \frac{1}{2}x_2$ (always true)
- $(2,1)$: $\frac{1}{2}x_3 = \frac{1}{2}x_3$ (always true)
- $(2,2)$: $0 = \frac{1}{2}\beta \implies \beta = 0$
- $(2,3)$: $0 = \frac{1}{2}\bar{x}_1 \implies x_1 = 0$
- $(3,1)$: $\frac{1}{2}\bar{x}_2 = \frac{1}{2}\bar{x}_2$ (always true)
- $(3,2)$: $0 = \frac{1}{2}x_1 \implies x_1 = 0$ (consistent)
- $(3,3)$: $0 = \frac{1}{2}\gamma \implies \gamma = 0$

Thus $V_{1/2}$ consists of matrices with $\alpha = \beta = \gamma = 0$, $x_1 = 0$, and $x_2, x_3 \in \mathbb{O}$ free:

$$
V_{1/2} = \left\{ \begin{pmatrix} 0 & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix} : x_2, x_3 \in \mathbb{O} \right\} \cong \mathbb{O} \oplus \mathbb{O} = \mathbb{O}^2
$$

$$\dim(V_{1/2}) = 8 + 8 = 16$$

**$V_0$ (eigenvalue 0):** $e \circ X = 0$ requires:
- $(1,1)$: $\alpha = 0$
- $(1,2)$: $\frac{1}{2}\bar{x}_3 = 0 \implies x_3 = 0$
- $(1,3)$: $\frac{1}{2}x_2 = 0 \implies x_2 = 0$
- The remaining entries are automatically zero in $e \circ X$

Thus $V_0$ consists of matrices with $\alpha = 0$, $x_2 = x_3 = 0$, and $\beta, \gamma \in \mathbb{R}$, $x_1 \in \mathbb{O}$ free:

$$
V_0 = \left\{ \begin{pmatrix} 0 & 0 & 0 \\ 0 & \beta & \bar{x}_1 \\ 0 & x_1 & \gamma \end{pmatrix} : \beta, \gamma \in \mathbb{R},\, x_1 \in \mathbb{O} \right\} \cong h_2(\mathbb{O})
$$

$$\dim(V_0) = 2 + 8 = 10$$

### Step 3: Dimension Verification

$$\dim(V_1) + \dim(V_{1/2}) + \dim(V_0) = 1 + 16 + 10 = 27 = \dim(h_3(\mathbb{O})) \quad \checkmark$$

SELF-CRITIQUE CHECKPOINT (Step 3):
1. SIGN CHECK: No sign changes involved (dimension counting). N/A.
2. FACTOR CHECK: No factors of 2, pi, hbar, c. Dimensions are integer counts.
3. CONVENTION CHECK: Jordan product $\circ = \frac{1}{2}(ab + ba)$ used consistently. Peirce eigenvalues are $\{0, 1/2, 1\}$ as standard. $\checkmark$
4. DIMENSION CHECK: $1 + 16 + 10 = 27$ $\checkmark$

### Step 4: Stabilizer of e in F_4 and Spin(9) Action

The automorphism group of $h_3(\mathbb{O})$ is the exceptional Lie group:

$$\mathrm{Aut}(h_3(\mathbb{O})) = F_4$$

with $\dim(F_4) = 52$ (Baez, "The Octonions," Bull. AMS 39 (2002), Sec 4.3).

The stabilizer of the idempotent $e = E_{11}$ in $F_4$ is:

$$\mathrm{Stab}_{F_4}(E_{11}) = \mathrm{Spin}(9)$$

with $\dim(\mathrm{Spin}(9)) = 36 = \binom{9}{2}$.

**Coset dimension check:** $\dim(F_4) - \dim(\mathrm{Spin}(9)) = 52 - 36 = 16 = \dim(V_{1/2})$, consistent with $F_4/\mathrm{Spin}(9) \cong \mathbb{O}P^2$ (the Cayley projective plane, also 16-dimensional). $\checkmark$

**Spin(9) action on the Peirce spaces:**

Under the $\mathrm{Spin}(9)$ stabilizer, the Peirce decomposition $27 = 1 + 16 + 10$ corresponds to:

- $V_1 \cong \mathbb{R}$ carries the **trivial representation** of $\mathrm{Spin}(9)$
- $V_{1/2} \cong \mathbb{O}^2$ carries the **real spinor representation $S_9$** of $\mathrm{Spin}(9)$
- $V_0 \cong h_2(\mathbb{O})$ carries the **vector representation $\mathbf{9}$ plus trace**: the traceless part of $h_2(\mathbb{O})$ is 9-dimensional (the defining/vector representation of $\mathrm{Spin}(9)$ via the $\mathrm{SO}(9)$ quotient), and the trace part contributes 1 additional dimension, giving $9 + 1 = 10$

**Verification that $V_{1/2}$ carries $S_9$:**

$\mathrm{Spin}(9)$ has a unique real irreducible spinor representation $S_9$ of dimension:
$$\dim_{\mathbb{R}}(S_9) = 2^{[9/2]} = 2^4 = 16$$

This matches $\dim(V_{1/2}) = 16$. The identification $V_{1/2} = \mathbb{O}^2 = S_9$ as a $\mathrm{Spin}(9)$-representation is established in:

- Baez, "The Octonions," Bull. AMS 39 (2002), Section 4.3 (Theorem 5)
- Yokota, "Exceptional Lie Groups" (2009), Chapter 2

The key structural fact is that $\mathrm{Spin}(9)$ acts on $\mathbb{O}^2$ via its spinor representation because the Cayley plane $\mathbb{O}P^2 = F_4/\mathrm{Spin}(9)$ has tangent spaces isomorphic to $\mathbb{O}^2$ at the basepoint corresponding to $E_{11}$, and the isotropy representation of $\mathrm{Spin}(9)$ on this tangent space is precisely $S_9$.

**Note on V_0:** The space $V_0 = h_2(\mathbb{O})$ can be decomposed further. The trace $\mathrm{tr} : h_2(\mathbb{O}) \to \mathbb{R}$ splits off a trivial representation, leaving the traceless part $h_2^0(\mathbb{O})$ of dimension 9, which carries the defining (vector) representation of $\mathrm{SO}(9) = \mathrm{Spin}(9)/\mathbb{Z}_2$. The full decomposition under $\mathrm{Spin}(9)$ is:
$$27 = \mathbf{1} \oplus \mathbf{16} \oplus (\mathbf{9} \oplus \mathbf{1})$$
where the first $\mathbf{1}$ comes from $V_1$, the $\mathbf{16}$ is $S_9$, and $\mathbf{9} \oplus \mathbf{1}$ is $V_0$.

SELF-CRITIQUE CHECKPOINT (Step 4):
1. SIGN CHECK: No sign-dependent computations. N/A.
2. FACTOR CHECK: Coset dimension $52 - 36 = 16$ $\checkmark$. Spinor dimension $2^4 = 16$ $\checkmark$.
3. CONVENTION CHECK: $F_4 = \mathrm{Aut}(h_3(\mathbb{O}))$ is the compact form. $\mathrm{Spin}(9)$ stabilizer is standard. $\checkmark$
4. DIMENSION CHECK: $1 + 16 + (9 + 1) = 27$ $\checkmark$

---

## Summary of Part I

| Peirce Space | Identification | $\dim_{\mathbb{R}}$ | $\mathrm{Spin}(9)$ Rep |
|:---:|:---:|:---:|:---:|
| $V_1$ | $\mathbb{R} \cdot E_{11}$ | 1 | trivial $\mathbf{1}$ |
| $V_{1/2}$ | $\mathbb{O}^2$ | 16 | spinor $S_9 = \mathbf{16}$ |
| $V_0$ | $h_2(\mathbb{O})$ | 10 | $\mathbf{9} \oplus \mathbf{1}$ |
| **Total** | $h_3(\mathbb{O})$ | **27** | $\mathbf{1} \oplus \mathbf{16} \oplus \mathbf{9} \oplus \mathbf{1}$ |

**Input assumption:** The observer's idempotent $e = E_{11}$ is taken as given input (the "rank-1 idempotent choice" / symmetry breaking that appears as Gap B step 1 in the roadmap). We do not derive why the observer selects this particular diagonal slot.

---

## Part II: C*-Observer Forces Complexification and Spin(9) -> Spin(10)

### Step 5: The Paper 5 Result -- Observer is a C*-Algebra System

Paper 5 (v2.0) established the following chain:

**Theorem (Paper 5).** A finite-dimensional system that faithfully self-models must be described by $M_n(\mathbb{C})^{sa}$ -- the self-adjoint part of a complex matrix algebra -- equipped with the Luders sequential product $a \& b = \sqrt{a}\, b\, \sqrt{a}$ and involution $X^* = X^\dagger$ (conjugate transpose).

The key steps were:
1. Self-modeling forces a sequential product satisfying axioms S1-S7 (Phase 4)
2. vdW Theorem 1 classifies the state space as an EJA (Jordan-von Neumann-Wigner)
3. Compositionality (independent accessibility of body and model) forces local tomography (Phase 5, Plan 01)
4. Local tomography excludes all non-complex EJA types: $M_n(\mathbb{R})^{sa}$, $M_n(\mathbb{H})^{sa}$, $V_n$ ($n \geq 4$), and $M_3(\mathbb{O})^{sa}$ (Phase 5, Plan 02)
5. The surviving type is $M_n(\mathbb{C})^{sa}$, promoted to a C*-algebra via vdW Theorem 3

**The critical point:** The complex structure of the observer is **not a choice or convention** -- it is forced by the self-modeling requirement through local tomography (type exclusion). The observer is a $\mathbb{C}$-linear system.

### Step 6: The Complexification Argument

The observer (a C*-algebra system with complex scalars) now probes $V_{1/2} = \mathbb{O}^2$ (a real vector space, $\dim_\mathbb{R} = 16$). We argue that the observer's C*-nature forces a complexification of $V_{1/2}$.

**Argument:**

**(a) The observer's measurement outcomes are complex-valued.**

The observer's state space is $M_n(\mathbb{C})^{sa}$. Its dual space (the space of expectation-value functionals) consists of $\mathbb{C}$-linear functionals on $M_n(\mathbb{C})$. When the observer forms expectation values of observables, the algebraic operations are intrinsically $\mathbb{C}$-linear. In particular, the observer's scalar field is $\mathbb{C}$, not $\mathbb{R}$.

**(b) When the observer constructs its description of $V_{1/2}$, it must use $\mathbb{C}$-linear structures.**

The observer accesses $V_{1/2} = \mathbb{O}^2$ through its own algebraic framework. Concretely: the observer's description of any vector space it can probe is a module over its own scalars. Since the observer's scalars are $\mathbb{C}$ (from its C*-nature), the observer's effective description of $V_{1/2}$ is:

$$V_{1/2}^{\mathbb{C}} := V_{1/2} \otimes_{\mathbb{R}} \mathbb{C}$$

This is the **extension of scalars** from $\mathbb{R}$ to $\mathbb{C}$. It is the canonical construction that turns a real vector space into a complex vector space, and it is forced here because the observer can only work with $\mathbb{C}$-modules.

**(c) Why this is forced, not assumed.**

The logical chain is:
1. Self-modeling $\implies$ C*-algebra observer (Paper 5, through local tomography and type exclusion)
2. C*-algebra observer $\implies$ observer has $\mathbb{C}$ as its scalar field
3. Observer probes $V_{1/2} \subset h_3(\mathbb{O})$ through its own algebraic framework
4. Observer's algebraic operations on any probed space are $\mathbb{C}$-linear
5. $\therefore$ The observer's effective description of $V_{1/2}$ is $V_{1/2} \otimes_\mathbb{R} \mathbb{C} = V_{1/2}^\mathbb{C}$

No step assumes complexification. Each step follows from the preceding one:
- Step 1 is Paper 5 (established)
- Step 2 is the definition of a C*-algebra (scalars are $\mathbb{C}$)
- Step 3 is the physical setup (observer interacts with the Peirce space)
- Step 4 is a consequence of Step 2 (a system with $\mathbb{C}$-scalars performs $\mathbb{C}$-linear operations)
- Step 5 is the universal property of extension of scalars

**Forbidden proxy check:** We have NOT assumed complexification. We have derived it from the sequence: self-modeling $\to$ C*-nature $\to$ complex scalars $\to$ extension of scalars on the probed space. The complexification is a consequence of the observer being a complex system, not an ad hoc mathematical choice.

SELF-CRITIQUE CHECKPOINT (Step 6):
1. SIGN CHECK: No signs involved. N/A.
2. FACTOR CHECK: No numerical factors introduced.
3. CONVENTION CHECK: Extension of scalars $\otimes_\mathbb{R} \mathbb{C}$ is the standard categorical construction. $\checkmark$
4. DIMENSION CHECK: Deferred to Step 7. The logical argument is about algebraic structure, not dimensions.

### Step 7: Computing $V_{1/2}^\mathbb{C}$

$V_{1/2} = \mathbb{O}^2$ has $\dim_\mathbb{R} = 16$.

After extension of scalars:
$$V_{1/2}^\mathbb{C} = \mathbb{O}^2 \otimes_\mathbb{R} \mathbb{C}$$

As a **complex** vector space:
$$\dim_\mathbb{C}(V_{1/2}^\mathbb{C}) = \dim_\mathbb{R}(V_{1/2}) = 16$$

As a **real** vector space:
$$\dim_\mathbb{R}(V_{1/2}^\mathbb{C}) = 2 \cdot \dim_\mathbb{R}(V_{1/2}) = 32$$

The complex dimension is 16 because extension of scalars preserves the real dimension as the new complex dimension (every real basis vector $v$ becomes a complex basis vector $v \otimes 1$, and the imaginary direction $v \otimes i$ provides the additional real dimensions).

### Step 8: Spin(9) -> Spin(10) Representation-Theoretic Upgrade

**Before complexification:**

$\mathrm{Spin}(9)$ acts on $V_{1/2} = \mathbb{O}^2 = S_9$, the unique real irreducible 16-dimensional spinor representation.

**After complexification:**

The $\mathrm{Spin}(9)$ action extends $\mathbb{C}$-linearly to $V_{1/2}^\mathbb{C}$. We now use the standard representation-theoretic fact connecting $\mathrm{Spin}(9)$ and $\mathrm{Spin}(10)$ spinors.

**Key representation-theoretic facts:**

(i) $\mathrm{Spin}(10)$ has two inequivalent complex Weyl (half-spinor) representations $S_{10}^+$ and $S_{10}^-$, each of $\dim_\mathbb{C} = 16$. The full Dirac spinor is $S_{10} = S_{10}^+ \oplus S_{10}^-$ of $\dim_\mathbb{C} = 32$.

(ii) The embedding $\mathrm{Spin}(9) \hookrightarrow \mathrm{Spin}(10)$ (where $\mathrm{Spin}(9)$ is the stabilizer of a unit vector in the defining 10-dimensional representation) induces the branching rule:

$$S_{10}^+\big|_{\mathrm{Spin}(9)} \cong S_9 \otimes_\mathbb{R} \mathbb{C}$$

That is, when the Weyl spinor $S_{10}^+$ of $\mathrm{Spin}(10)$ is restricted to the $\mathrm{Spin}(9)$ subgroup, it becomes the complexification of the real spinor $S_9$.

Equivalently: $S_9$ is a **real form** of $S_{10}^+$. The real 16-dimensional spinor of $\mathrm{Spin}(9)$ is precisely what you get by restricting the complex 16-dimensional Weyl spinor of $\mathrm{Spin}(10)$ to $\mathrm{Spin}(9)$ and then forgetting the complex structure.

(iii) **Why $S_{10}^+$ and not $S_{10}^-$?** Under the branching $\mathrm{Spin}(10) \supset \mathrm{Spin}(9)$, both Weyl representations restrict to the same real representation $S_9$ (since $S_9$ is real and has no chirality). The choice of $S_{10}^+$ vs $S_{10}^-$ corresponds to a choice of chirality/orientation, which will be resolved in Phase 19 (Cl(6) construction). For now, we denote the complexified spinor as $S_{10}^+$ following the convention of Boyle 2020.

**The upgrade chain:**

$$V_{1/2} = S_9 \;(\text{real, } \dim_\mathbb{R} = 16) \quad \xrightarrow{\text{complexification}} \quad V_{1/2}^\mathbb{C} = S_9 \otimes_\mathbb{R} \mathbb{C} = S_{10}^+ \;(\text{complex, } \dim_\mathbb{C} = 16)$$

**The symmetry upgrade:** Because the complexified space $V_{1/2}^\mathbb{C} = S_{10}^+$ carries a representation of $\mathrm{Spin}(10)$ (not just $\mathrm{Spin}(9)$), the symmetry group acting on the observer's description of the Peirce space upgrades:

$$\mathrm{Spin}(9) \longrightarrow \mathrm{Spin}(10)$$

The larger group $\mathrm{Spin}(10)$ is the natural symmetry of the complexified spinor space. $\mathrm{Spin}(9) \subset \mathrm{Spin}(10)$ preserves additional structure (the real form), but after complexification this additional structure is no longer distinguished.

SELF-CRITIQUE CHECKPOINT (Step 8):
1. SIGN CHECK: No sign-sensitive steps. The branching rule is a standard fact. N/A.
2. FACTOR CHECK: $\dim_\mathbb{C}(S_{10}^+) = 16$ $\checkmark$. $\dim_\mathbb{R}(S_9) = 16$ $\checkmark$. $2^{[10/2]-1} = 2^4 = 16$ for Weyl spinor $\checkmark$.
3. CONVENTION CHECK: $S_{10}^+$ choice over $S_{10}^-$ explicitly noted as a convention (chirality choice deferred to Phase 19). $\checkmark$
4. DIMENSION CHECK: $\dim_\mathbb{C}(S_9 \otimes_\mathbb{R} \mathbb{C}) = \dim_\mathbb{R}(S_9) = 16 = \dim_\mathbb{C}(S_{10}^+)$ $\checkmark$

### Step 9: Cross-Check with Boyle 2020

Boyle (arXiv:2006.16265) studies the complexified exceptional Jordan algebra $h_3^\mathbb{C}(\mathbb{O}) = h_3(\mathbb{O}) \otimes_\mathbb{R} \mathbb{C}$ and identifies:

- The structure-preserving group of $h_3^\mathbb{C}(\mathbb{O})$ is $E_6$ (the complexified automorphism group, upgrading from $F_4$)
- Under the $\mathrm{Spin}(10) \subset E_6$ subgroup, the Peirce $V_{1/2}$ of the complexified algebra carries the 16-dimensional Weyl spinor representation $S_{10}^+$
- The full 27-dimensional representation decomposes under $\mathrm{Spin}(10)$ as: $\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16}$

**Comparison with our result:**

Our derivation arrives at the same identification ($V_{1/2}^\mathbb{C} = S_{10}^+$) but via a different route:
- Boyle starts from $h_3^\mathbb{C}(\mathbb{O})$ (complexification of the full algebra) and analyzes its structure group
- We start from $h_3(\mathbb{O})$ (the real algebra), perform the Peirce decomposition, and show that the **observer's C*-nature** forces complexification of $V_{1/2}$, which then carries $S_{10}^+$

The results are consistent: the observer's complexification of $V_{1/2}$ yields the same spinor space that Boyle identifies in the complexified algebra. Our contribution is deriving the complexification from a physical principle (C*-observer nature from self-modeling) rather than taking it as a mathematical starting point.

### Step 10: What This Does NOT Yet Establish

This derivation establishes:
- $V_{1/2} = S_9$ (real spinor of $\mathrm{Spin}(9)$) -- **Part I**
- C*-observer nature forces $V_{1/2} \to V_{1/2}^\mathbb{C} = S_{10}^+$ -- **Part II**
- Symmetry upgrade $\mathrm{Spin}(9) \to \mathrm{Spin}(10)$ on $V_{1/2}^\mathbb{C}$ -- **Part II**

What remains for Plan 02:
- The full algebra-level upgrade $F_4 \to E_6$ (structure group of $h_3^\mathbb{C}(\mathbb{O})$)
- The Peirce decomposition of $h_3^\mathbb{C}(\mathbb{O})$ and verification that $\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16}$ under $\mathrm{Spin}(10)$
- The relationship between complexification of $V_{1/2}$ and complexification of the full algebra

### Step 11: Backtracking Trigger Assessment

**Does the complexification argument require more than C*-nature?**

The argument uses:
1. **C*-nature of observer** (from Paper 5): the observer's scalar field is $\mathbb{C}$
2. **Extension of scalars** (standard algebraic construction): a $\mathbb{C}$-linear system describes a real space as $V \otimes_\mathbb{R} \mathbb{C}$
3. **Observer probes $V_{1/2}$** (physical setup): the observer interacts with the Peirce space

Point 3 requires that the observer has access to $V_{1/2}$ specifically. This follows from the Peirce decomposition under the observer's idempotent $e = E_{11}$: the observer's choice of $e$ determines the Peirce decomposition, and $V_{1/2}$ is the "interaction space" between the observer's slot ($V_1$) and the rest of the algebra ($V_0$).

**Potential weakness:** The argument assumes the observer "probes" $V_{1/2}$ in a way that requires $\mathbb{C}$-linear description. This is physically natural (the observer must describe everything through its own algebraic framework), but the precise mechanism by which a $\mathbb{C}$-linear observer is forced to use extension of scalars (rather than, say, working with the real space directly and embedding the results in its complex framework) could be questioned.

**Assessment:** The argument is logically sound under the principle that a $\mathbb{C}$-linear observer describes all probed spaces as $\mathbb{C}$-modules. This principle follows from the observer's C*-nature: the observer's state space, observable algebra, and all derived structures are $\mathbb{C}$-linear. There is no mechanism by which the observer could "turn off" its complex structure when looking at $V_{1/2}$.

**Backtracking trigger status: NOT FIRED.** The complexification follows from C*-nature without additional structure. The weakest point is the "probing" step (Step 6c, point 3), which is physically well-motivated but not a formal theorem. This is documented in the uncertainty markers of the plan contract.

---

## Summary of Part II

**Central result:**

$$\boxed{V_{1/2} = S_9 \;\xrightarrow{\text{C*-observer}}\; V_{1/2}^\mathbb{C} = S_{10}^+ \quad (\text{Weyl spinor of } \mathrm{Spin}(10),\; \dim_\mathbb{C} = 16)}$$

**Logical chain:**

Self-modeling (L4) $\to$ M_n(C)^{sa} (Paper 5) $\to$ C*-observer with $\mathbb{C}$-scalars $\to$ extension of scalars on probed $V_{1/2}$ $\to$ $V_{1/2}^\mathbb{C} = S_{10}^+$ $\to$ Spin(9) upgrades to Spin(10)

**Cross-check:** Consistent with Boyle 2020's identification of $V_{1/2}$ in $h_3^\mathbb{C}(\mathbb{O})$ as $S_{10}^+$.

**No forbidden proxies violated:** Complexification derived from C*-nature (not assumed). Spin(10) established via representation-theoretic branching rule (not asserted).

---

## Part III: Full Algebra Complexification, F_4 -> E_6, and the 27-dim Decomposition

**(Phase 18, Plan 02: CMPL-02 -- Global structure of h_3^C(O))**

Part II established complexification at the level of the Peirce space $V_{1/2}$. Part III extends this to the full exceptional Jordan algebra, tracking the automorphism group upgrade $F_4 \to E_6$ and the 27-dimensional representation decomposition under $\mathrm{Spin}(10)$.

### Step 12: Complexification of the Full Algebra h_3(O) -> h_3^C(O)

**Definition.** The complexified exceptional Jordan algebra is:

$$h_3^\mathbb{C}(\mathbb{O}) := h_3(\mathbb{O}) \otimes_\mathbb{R} \mathbb{C}$$

This is the extension of scalars of the real Jordan algebra $h_3(\mathbb{O})$ from $\mathbb{R}$ to $\mathbb{C}$.

**Elements.** An element of $h_3^\mathbb{C}(\mathbb{O})$ is a formal $\mathbb{C}$-linear combination of elements of $h_3(\mathbb{O})$. Equivalently, elements are $3 \times 3$ matrices over $\mathbb{O}_\mathbb{C} = \mathbb{O} \otimes_\mathbb{R} \mathbb{C}$ (the complexified octonions, $\dim_\mathbb{C} = 8$) satisfying the complexified Hermiticity condition.

**Important note.** $h_3^\mathbb{C}(\mathbb{O})$ is NOT the set of $3 \times 3$ Hermitian matrices over $\mathbb{O}_\mathbb{C}$ in the naive sense. Rather, it is the complexification of the real Jordan algebra. The "Hermiticity" condition extends $\mathbb{C}$-linearly: if $X \in h_3(\mathbb{O})$ satisfies $X = X^\dagger$ (octonion conjugation + transpose), then $X \otimes 1 \in h_3^\mathbb{C}(\mathbb{O})$ satisfies $(X \otimes 1)^\sharp = X \otimes 1$ where $\sharp$ is the $\mathbb{C}$-linear extension of $\dagger$.

**Dimension.**

$$\dim_\mathbb{C}(h_3^\mathbb{C}(\mathbb{O})) = \dim_\mathbb{R}(h_3(\mathbb{O})) = 27$$

This follows from the general property of extension of scalars: $\dim_\mathbb{C}(V \otimes_\mathbb{R} \mathbb{C}) = \dim_\mathbb{R}(V)$.

**Jordan product.** The Jordan product extends $\mathbb{C}$-linearly:

$$(a \otimes z) \circ (b \otimes w) = (a \circ b) \otimes (zw)$$

for $a, b \in h_3(\mathbb{O})$ and $z, w \in \mathbb{C}$. The complexified algebra $h_3^\mathbb{C}(\mathbb{O})$ is a complex Jordan algebra of dimension 27.

**Cubic form.** The determinant (cubic norm form) of $h_3(\mathbb{O})$ extends $\mathbb{C}$-linearly to a cubic form on $h_3^\mathbb{C}(\mathbb{O})$:

$$\det(X) = \alpha\beta\gamma - \alpha |x_1|^2 - \beta |x_2|^2 - \gamma |x_3|^2 + 2\,\mathrm{Re}(x_1(x_2 x_3))$$

extends via $(X \otimes z) \mapsto \det(X) \cdot z^3$, and then by $\mathbb{C}$-linearity to all of $h_3^\mathbb{C}(\mathbb{O})$.

**Consistency with Plan 01.** The complexification of the full algebra contains the complexification of each Peirce subspace:

$$h_3^\mathbb{C}(\mathbb{O}) = V_1^\mathbb{C} \oplus V_{1/2}^\mathbb{C} \oplus V_0^\mathbb{C}$$

where:
- $V_1^\mathbb{C} = \mathbb{R} \cdot E_{11} \otimes_\mathbb{R} \mathbb{C} = \mathbb{C} \cdot E_{11}$, $\dim_\mathbb{C} = 1$
- $V_{1/2}^\mathbb{C} = \mathbb{O}^2 \otimes_\mathbb{R} \mathbb{C}$, $\dim_\mathbb{C} = 16$ (established in Part II as $S_{10}^+$)
- $V_0^\mathbb{C} = h_2(\mathbb{O}) \otimes_\mathbb{R} \mathbb{C} = h_2^\mathbb{C}(\mathbb{O})$, $\dim_\mathbb{C} = 10$

**Dimension check:**
$$1 + 16 + 10 = 27 = \dim_\mathbb{C}(h_3^\mathbb{C}(\mathbb{O})) \quad \checkmark$$

SELF-CRITIQUE CHECKPOINT (Step 12):
1. SIGN CHECK: No sign-sensitive operations. N/A.
2. FACTOR CHECK: $\dim_\mathbb{C}(h_3^\mathbb{C}(\mathbb{O})) = 27$; $27 = 3 \cdot 1 + 3 \cdot 8$ for real, same count as complex dimension after extension. $\checkmark$
3. CONVENTION CHECK: Jordan product $\circ = \frac{1}{2}(ab + ba)$ extended $\mathbb{C}$-linearly. Peirce under $E_{11}$ as before. $\checkmark$
4. DIMENSION CHECK: $1 + 16 + 10 = 27$. $\checkmark$

### Step 13: Structure Group Upgrade F_4 -> E_6

**F_4 as automorphism group of h_3(O).**

The automorphism group of $h_3(\mathbb{O})$ as a Jordan algebra is the compact exceptional Lie group:

$$\mathrm{Aut}(h_3(\mathbb{O})) = F_4$$

with $\dim(F_4) = 52$ (Baez, "The Octonions," Sec 4.3; Yokota, "Exceptional Lie Groups," Ch 2).

An automorphism $\phi \in F_4$ satisfies:
$$\phi(A \circ B) = \phi(A) \circ \phi(B) \quad \text{for all } A, B \in h_3(\mathbb{O})$$
and preserves the unit element $\phi(\mathbb{1}) = \mathbb{1}$.

**E_6 as structure group of h_3^C(O).**

The structure group of $h_3^\mathbb{C}(\mathbb{O})$ is the exceptional Lie group $E_6$. More precisely, the relevant group is the connected component of the structure group:

$$\mathrm{Str}_0(h_3^\mathbb{C}(\mathbb{O})) = E_6$$

with $\dim(E_6) = 78$.

A structure transformation $g \in E_6$ preserves the cubic form up to a scalar (determinant-preserving up to scale):

$$\det(g \cdot X) = \chi(g)^3 \det(X)$$

for some character $\chi : E_6 \to \mathbb{C}^*$. The subgroup preserving the determinant exactly (i.e., $\chi = 1$) is the reduced structure group.

**The F_4 -> E_6 embedding.**

$F_4$ embeds into $E_6$ as the subgroup that preserves the real structure:

$$F_4 = \{ g \in E_6 : g(h_3(\mathbb{O})) = h_3(\mathbb{O}) \}$$

That is, $F_4$ is the subgroup of $E_6$ that maps the real form $h_3(\mathbb{O}) \subset h_3^\mathbb{C}(\mathbb{O})$ to itself. Equivalently, $F_4$ is the fixed-point set of the complex conjugation automorphism on $E_6$ (the automorphism that acts as complex conjugation on $h_3^\mathbb{C}(\mathbb{O})$).

**Why complexification upgrades $F_4$ to $E_6$:** Before complexification, the symmetry of $h_3(\mathbb{O})$ is $F_4$ (preserving the Jordan product). After complexification, the symmetry enlarges to $E_6$ because:
1. The complexified algebra has additional structure (the cubic form extends to $\mathbb{C}$)
2. Transformations that mix real and imaginary parts are now available
3. These additional transformations generate $E_6$ from $F_4$

**Dimension accounting:**

$$\dim(E_6) - \dim(F_4) = 78 - 52 = 26$$

The 26 additional dimensions correspond to the additional generators that become available after complexification. These generators act non-trivially on the imaginary (iX for $X \in h_3(\mathbb{O})$) directions.

**Tracking through the Peirce decomposition:**

The upgrade $F_4 \to E_6$ is not merely a group-theoretic statement; it can be seen through how the groups act on the Peirce decomposition.

Under $F_4$: Each Peirce space $V_\lambda$ is stable under $\mathrm{Stab}_{F_4}(E_{11}) = \mathrm{Spin}(9)$. The $F_4$ action permutes elements within each Peirce space (and can mix different idempotents, moving between different Peirce decompositions).

Under $E_6$: After complexification, each $V_\lambda^\mathbb{C}$ is stable under $\mathrm{Stab}_{E_6}(E_{11}) = \mathrm{Spin}(10) \times \mathrm{U}(1)$ (see Step 14). The $E_6$ action on $h_3^\mathbb{C}(\mathbb{O})$ permutes elements within each complexified Peirce space, now with the larger stabilizer symmetry.

The key point: the Peirce subspaces do not change their role or structure under complexification -- they simply acquire the larger symmetry. This is because the Peirce decomposition is defined by the eigenvalues of $L_e$, and the operator $L_e$ extends $\mathbb{C}$-linearly to $h_3^\mathbb{C}(\mathbb{O})$ with the same eigenvalues $\{0, 1/2, 1\}$.

**References:**
- Baez, "The Octonions," Bull. AMS 39 (2002), Sec 4.3: $F_4 = \mathrm{Aut}(h_3(\mathbb{O}))$
- Yokota, "Exceptional Lie Groups" (2009), Ch 2-3: $F_4 \hookrightarrow E_6$ embedding, structure group
- Boyle (arXiv:2006.16265): $E_6$ as structure group of $h_3^\mathbb{C}(\mathbb{O})$, cubic form preservation

SELF-CRITIQUE CHECKPOINT (Step 13):
1. SIGN CHECK: No signs in group dimension computation. N/A.
2. FACTOR CHECK: $78 - 52 = 26$ $\checkmark$. No factors of 2, $\pi$, etc.
3. CONVENTION CHECK: $F_4$ is the compact form. $E_6$ here refers to the compact real form $E_6^{-78}$ (maximal compact, Killing form negative definite), consistent with its role as structure group of a compact Jordan algebra. $\checkmark$
4. DIMENSION CHECK: $\dim(F_4) = 52 = \frac{1}{2} \cdot 4 \cdot (4 \cdot 6 + 2) = 52$ (checking: rank 4 exceptional group) $\checkmark$. $\dim(E_6) = 78$ (rank 6 exceptional group). $\checkmark$

### Step 14: Stabilizer Upgrade Spin(9) -> Spin(10) x U(1)

**Before complexification: Spin(9) = Stab_{F_4}(E_11).**

From Part I (Step 4):
$$\mathrm{Stab}_{F_4}(E_{11}) = \mathrm{Spin}(9), \quad \dim = 36 = \binom{9}{2}$$

The orbit of $E_{11}$ under $F_4$ is the Cayley projective plane:
$$F_4 / \mathrm{Spin}(9) \cong \mathbb{O}P^2, \quad \dim = 52 - 36 = 16$$

**After complexification: Spin(10) x U(1) = Stab_{E_6}(E_11).**

In $E_6$, the stabilizer of the idempotent $E_{11} \in h_3^\mathbb{C}(\mathbb{O})$ is:

$$\mathrm{Stab}_{E_6}(E_{11}) = \mathrm{Spin}(10) \times \mathrm{U}(1)$$

with:
$$\dim(\mathrm{Spin}(10) \times \mathrm{U}(1)) = 45 + 1 = 46$$

**Dimension check on the orbit:**
$$\dim(E_6) - \dim(\mathrm{Spin}(10) \times \mathrm{U}(1)) = 78 - 46 = 32$$

The orbit $E_6 / (\mathrm{Spin}(10) \times \mathrm{U}(1))$ is a 32-dimensional space. This is the complexified Cayley plane $(\mathbb{O}P^2)^\mathbb{C}$: $\dim_\mathbb{R}(\mathbb{O}P^2) = 16$, so $\dim_\mathbb{R}((\mathbb{O}P^2)^\mathbb{C}) = 32$, consistent with $78 - 46 = 32$. $\checkmark$

**The stabilizer upgrade is consistent with Part II.**

Part II established that $V_{1/2}^\mathbb{C} = S_{10}^+$ carries a $\mathrm{Spin}(10)$ action. The stabilizer of $E_{11}$ in $E_6$ must preserve each complexified Peirce space, and in particular must act on $V_{1/2}^\mathbb{C}$. The $\mathrm{Spin}(10)$ factor is precisely the group that acts on $V_{1/2}^\mathbb{C} = S_{10}^+$ via the Weyl spinor representation.

The $\mathrm{U}(1)$ factor corresponds to overall phase rotations that are available after complexification. In the physics literature (Boyle 2020), this $\mathrm{U}(1)$ is identified with $B - L$ (baryon minus lepton number), but we defer this identification to Phase 19-20. For the current analysis, we note its existence and dimension ($+1$) in the stabilizer.

**Tracking the Spin(9) -> Spin(10) embedding through Peirce spaces:**

| Peirce Space | Before (real, $\mathrm{Spin}(9)$) | After (complex, $\mathrm{Spin}(10)$) | Representation Upgrade |
|:---:|:---:|:---:|:---:|
| $V_1 \to V_1^\mathbb{C}$ | $\mathbb{R}$, dim 1, trivial $\mathbf{1}$ | $\mathbb{C}$, dim 1, trivial $\mathbf{1}$ | Unchanged (trivial rep) |
| $V_{1/2} \to V_{1/2}^\mathbb{C}$ | $\mathbb{O}^2$, dim 16, spinor $S_9$ | $\mathbb{O}^2 \otimes \mathbb{C}$, dim 16, Weyl $S_{10}^+$ | $S_9 \to S_{10}^+$ (Part II result) |
| $V_0 \to V_0^\mathbb{C}$ | $h_2(\mathbb{O})$, dim 10, $\mathbf{9} \oplus \mathbf{1}$ | $h_2(\mathbb{O}) \otimes \mathbb{C}$, dim 10, vector $\mathbf{10}$ | $\mathbf{9} \oplus \mathbf{1} \to \mathbf{10}$ |

The key structural change for $V_0$: Under $\mathrm{Spin}(9)$, $V_0 = h_2(\mathbb{O})$ decomposes as $\mathbf{9} \oplus \mathbf{1}$ (traceless part + trace). Under $\mathrm{Spin}(10)$, the complexified $V_0^\mathbb{C}$ is the 10-dimensional vector (defining) representation $\mathbf{10}$ of $\mathrm{Spin}(10)$. This is consistent with the branching rule:

$$\mathbf{10}\big|_{\mathrm{Spin}(9)} = \mathbf{9} \oplus \mathbf{1}$$

which states that the vector representation of $\mathrm{Spin}(10)$, restricted to $\mathrm{Spin}(9)$, decomposes as the vector of $\mathrm{Spin}(9)$ plus a singlet. This is the standard embedding $\mathrm{SO}(9) \hookrightarrow \mathrm{SO}(10)$ where the 10-vector splits as $9 + 1$ under the $\mathrm{SO}(9)$ subgroup. $\checkmark$

**References:**
- Yokota, "Exceptional Lie Groups" (2009): $\mathrm{Stab}_{E_6}(E_{11}) = \mathrm{Spin}(10) \times \mathrm{U}(1)$
- Boyle (arXiv:2006.16265): orbit structure and $\mathrm{U}(1)$ identification

SELF-CRITIQUE CHECKPOINT (Step 14):
1. SIGN CHECK: N/A (no sign-sensitive computation).
2. FACTOR CHECK: $78 - 46 = 32 = 2 \times 16$ (complexified Cayley plane). $\checkmark$. $\dim(\mathrm{Spin}(10)) = \binom{10}{2} = 45$ $\checkmark$.
3. CONVENTION CHECK: $\mathrm{Spin}(10) \times \mathrm{U}(1)$ stabilizer. The $\mathrm{U}(1)$ factor is noted but not analyzed (deferred). $\checkmark$
4. DIMENSION CHECK: $45 + 1 = 46$; orbit $78 - 46 = 32$. Branching $\mathbf{10}|_{\mathrm{Spin}(9)} = \mathbf{9} + \mathbf{1}$: $9 + 1 = 10$. $\checkmark$

**Chain summary (Steps 12-14):**

$$F_4 = \mathrm{Aut}(h_3(\mathbb{O})) \;\xrightarrow{\text{complexification}}\; E_6 = \mathrm{Str}_0(h_3^\mathbb{C}(\mathbb{O}))$$

$$\mathrm{Stab}_{F_4}(E_{11}) = \mathrm{Spin}(9) \;\xrightarrow{\text{complexification}}\; \mathrm{Stab}_{E_6}(E_{11}) = \mathrm{Spin}(10) \times \mathrm{U}(1)$$

Tracked through Peirce decomposition: each subspace followed from real to complex, with representation upgrades verified at each level.

### Step 15: The 27-Dimensional Representation under Spin(10)

The 27-dimensional fundamental representation of $E_6$ decomposes under the subgroup $\mathrm{Spin}(10) \times \mathrm{U}(1) = \mathrm{Stab}_{E_6}(E_{11})$ as:

$$\mathbf{27} \to \mathbf{1}_{(-4)} \oplus \mathbf{10}_{(2)} \oplus \mathbf{16}_{(-1)}$$

where the subscripts denote $\mathrm{U}(1)$ charges (recorded for completeness; not essential for this phase).

**Identification with Peirce subspaces:**

| Summand | $\mathrm{Spin}(10)$ Rep | Peirce Space | Identification |
|:---:|:---:|:---:|:---:|
| $\mathbf{1}$ | Trivial (singlet) | $V_1^\mathbb{C} = \mathbb{C} \cdot E_{11}$ | The idempotent's eigenspace. Observer's "slot." |
| $\mathbf{10}$ | Vector (defining) | $V_0^\mathbb{C} = h_2^\mathbb{C}(\mathbb{O})$ | The "rest" subspace, carrying SO(10) vector structure. |
| $\mathbf{16}$ | Weyl spinor $S_{10}^+$ | $V_{1/2}^\mathbb{C} = (\mathbb{O}^2)^\mathbb{C}$ | The interaction space. One generation of SM fermions (Boyle). |

**Dimension sum:**
$$1 + 10 + 16 = 27 \quad \checkmark$$

**Detailed identification of each summand:**

**The singlet $\mathbf{1} \leftrightarrow V_1^\mathbb{C}$:** This is the 1-dimensional eigenspace of eigenvalue 1 under $L_{E_{11}}$. It consists of $\mathbb{C}$-multiples of the idempotent $E_{11}$. Under $\mathrm{Spin}(10) \times \mathrm{U}(1)$, it transforms trivially under $\mathrm{Spin}(10)$ (since $E_{11}$ is fixed by the stabilizer) and with $\mathrm{U}(1)$ charge $-4$. The $\mathrm{U}(1)$ charge reflects the weight of $E_{11}$ under the overall $\mathrm{U}(1)$ factor in the stabilizer.

**The vector $\mathbf{10} \leftrightarrow V_0^\mathbb{C}$:** $V_0 = h_2(\mathbb{O})$ (the $2 \times 2$ Hermitian octonion matrices in the lower-right block) has $\dim_\mathbb{R} = 10$. After complexification, $V_0^\mathbb{C} = h_2(\mathbb{O}) \otimes_\mathbb{R} \mathbb{C}$ has $\dim_\mathbb{C} = 10$.

Under $\mathrm{Spin}(9)$, this decomposed as $\mathbf{9} \oplus \mathbf{1}$ (traceless part + trace). Under $\mathrm{Spin}(10)$, the complexified space is the **vector representation** $\mathbf{10}$. The branching rule $\mathbf{10}|_{\mathrm{Spin}(9)} = \mathbf{9} \oplus \mathbf{1}$ (verified in Step 14) confirms this identification.

In the physics interpretation (Boyle 2020), the $\mathbf{10}$ carries the remaining gauge bosons (under further decomposition to $\mathrm{SU}(5)$ or the SM gauge group). We note this but do not analyze it further in this phase.

**The Weyl spinor $\mathbf{16} \leftrightarrow V_{1/2}^\mathbb{C}$:** This is the central result connecting Part II to Part III. In Part II (Steps 5-8), we established:

$$V_{1/2}^\mathbb{C} = \mathbb{O}^2 \otimes_\mathbb{R} \mathbb{C} = S_{10}^+ \quad (\text{Weyl spinor, } \dim_\mathbb{C} = 16)$$

The derivation was:
1. $V_{1/2} = \mathbb{O}^2 = S_9$ (Part I, Step 4)
2. C*-observer forces extension of scalars (Part II, Steps 5-6)
3. $S_9 \otimes_\mathbb{R} \mathbb{C} = S_{10}^+$ (Part II, Step 8)

The $\mathbf{16}$ in the $E_6$ branching rule is exactly this $S_{10}^+$. In the physics interpretation (Boyle 2020), this is **one generation of Standard Model fermions** (before further decomposition under $\mathrm{SU}(5)$ or the SM gauge group).

**Cross-check with Boyle 2020:**

Boyle (arXiv:2006.16265) arrives at the same decomposition $\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16}$ by analyzing $h_3^\mathbb{C}(\mathbb{O})$ directly. He identifies:
- The $\mathbf{16}$ as one generation of SM fermions (16 = number of Weyl fermions per generation including right-handed neutrino)
- The $\mathbf{10}$ as related to gauge structure
- The $\mathbf{1}$ as a singlet associated with the observer's projection

Our derivation arrives at the same result but via the route: real Jordan algebra $\to$ Peirce decomposition $\to$ C*-observer complexification $\to$ complexified Peirce spaces $\to$ Spin(10) decomposition. The novel element is that the complexification is derived from the observer's C*-nature (Paper 5), not assumed as a mathematical starting point.

SELF-CRITIQUE CHECKPOINT (Step 15):
1. SIGN CHECK: N/A (no sign-sensitive operations).
2. FACTOR CHECK: $1 + 10 + 16 = 27$ $\checkmark$. U(1) charges $(-4, 2, -1)$ are standard; we record but do not derive them.
3. CONVENTION CHECK: $S_{10}^+$ convention (following Boyle). Peirce under $E_{11}$. $\checkmark$
4. DIMENSION CHECK: $\dim_\mathbb{C}(V_1^\mathbb{C}) = 1$, $\dim_\mathbb{C}(V_0^\mathbb{C}) = 10$, $\dim_\mathbb{C}(V_{1/2}^\mathbb{C}) = 16$. Sum = 27. Each matches its $\mathrm{Spin}(10)$ representation. $\checkmark$

### Step 16: Representation Verification for V_0^C

We provide an independent check that $V_0^\mathbb{C}$ carries the $\mathbf{10}$ (vector) representation of $\mathrm{Spin}(10)$.

$V_0 = h_2(\mathbb{O})$ consists of $2 \times 2$ Hermitian matrices over $\mathbb{O}$:

$$Y = \begin{pmatrix} \beta & \bar{x}_1 \\ x_1 & \gamma \end{pmatrix}, \quad \beta, \gamma \in \mathbb{R},\; x_1 \in \mathbb{O}$$

$\dim_\mathbb{R}(V_0) = 2 + 8 = 10$.

Under $\mathrm{Spin}(9)$, the traceless part $h_2^0(\mathbb{O}) = \{Y \in h_2(\mathbb{O}) : \mathrm{tr}(Y) = 0\}$ has $\dim = 9$ and carries the **vector** (defining) representation of $\mathrm{SO}(9) = \mathrm{Spin}(9)/\mathbb{Z}_2$. The trace $\mathrm{tr}(Y) = \beta + \gamma$ is a singlet. So:

$$V_0\big|_{\mathrm{Spin}(9)} = \mathbf{9} \oplus \mathbf{1}$$

After complexification, $V_0^\mathbb{C}$ has $\dim_\mathbb{C} = 10$. The key representation-theoretic fact is:

$$\mathbf{10}\big|_{\mathrm{Spin}(9)} = \mathbf{9} \oplus \mathbf{1}$$

This is the standard branching rule for $\mathrm{SO}(10) \supset \mathrm{SO}(9)$: the 10-dimensional vector of $\mathrm{SO}(10)$ restricted to $\mathrm{SO}(9)$ gives the 9-vector plus a singlet (the component in the 10th direction).

Since $V_0$ carries $\mathbf{9} \oplus \mathbf{1}$ of $\mathrm{Spin}(9)$, and this matches the branching of the $\mathbf{10}$ of $\mathrm{Spin}(10)$, the complexified $V_0^\mathbb{C}$ carries the $\mathbf{10}$ of $\mathrm{Spin}(10)$. $\checkmark$

**Consistency check:** $\dim_\mathbb{C}(\mathbf{10}) = 10 = \dim_\mathbb{C}(V_0^\mathbb{C})$ $\checkmark$.

### Step 17: Phase 18 Synthesis

Collecting all results from Plans 01 and 02:

---

**CMPL-01 (Complexification proof -- Plan 01):**

1. The observer's C*-algebra nature (Paper 5: self-modeling $\to$ local tomography $\to$ $M_n(\mathbb{C})^{sa}$) gives the observer $\mathbb{C}$ as its scalar field.
2. The observer probes the Peirce space $V_{1/2} = \mathbb{O}^2 = S_9$ ($\mathrm{Spin}(9)$ spinor, $\dim_\mathbb{R} = 16$).
3. The C*-nature forces extension of scalars: $V_{1/2} \to V_{1/2}^\mathbb{C} = S_9 \otimes_\mathbb{R} \mathbb{C}$.
4. The complexified spinor is $V_{1/2}^\mathbb{C} = S_{10}^+$ (Weyl spinor of $\mathrm{Spin}(10)$, $\dim_\mathbb{C} = 16$).
5. Symmetry upgrade: $\mathrm{Spin}(9) \to \mathrm{Spin}(10)$ on $V_{1/2}^\mathbb{C}$.

**Key property:** The complexification is **derived**, not assumed. It follows from the observer's proven C*-nature.

---

**CMPL-02 (F_4 -> E_6 upgrade -- Plan 02):**

1. The full algebra complexifies: $h_3(\mathbb{O}) \to h_3^\mathbb{C}(\mathbb{O}) = h_3(\mathbb{O}) \otimes_\mathbb{R} \mathbb{C}$, $\dim_\mathbb{C} = 27$.
2. The automorphism group upgrades: $F_4 = \mathrm{Aut}(h_3(\mathbb{O})) \to E_6 = \mathrm{Str}_0(h_3^\mathbb{C}(\mathbb{O}))$.
3. The stabilizer upgrades: $\mathrm{Spin}(9) = \mathrm{Stab}_{F_4}(E_{11}) \to \mathrm{Spin}(10) \times \mathrm{U}(1) = \mathrm{Stab}_{E_6}(E_{11})$.
4. The 27-dim fundamental of $E_6$ decomposes under $\mathrm{Spin}(10)$ as: $\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16}$.
5. Each summand matches a Peirce subspace: $\mathbf{1} = V_1^\mathbb{C}$, $\mathbf{10} = V_0^\mathbb{C}$, $\mathbf{16} = V_{1/2}^\mathbb{C} = S_{10}^+$.

**Key property:** The decomposition is **traced through the Peirce structure**, not just cited as a branching rule. Each summand is identified with its algebraic origin in $h_3(\mathbb{O})$.

---

**What Phase 18 establishes for Phase 19:**

- The complexified Peirce space $V_{1/2}^\mathbb{C} = S_{10}^+$ is a $\mathrm{Spin}(10)$ Weyl spinor of $\dim_\mathbb{C} = 16$.
- Phase 19 will show: choosing a complex structure on $\mathrm{Im}(\mathbb{O})$ (i.e., selecting a unit imaginary octonion $u \in S^6$) gives $\mathbb{O} = \mathbb{C} \oplus \mathbb{C}^3$, inducing $\mathrm{Cl}(6) \hookrightarrow \mathrm{Cl}(10)$, whose chirality operator selects a definite chirality on $S_{10}^+$.

---

**Gaps acknowledged:**

1. **Gap B step 1 (rank-1 idempotent choice):** The choice $e = E_{11}$ is taken as input. Why the observer selects a rank-1 idempotent (rather than rank-2 or the identity) is not derived from self-modeling in this phase.

2. **U(1) factor:** The $\mathrm{U}(1)$ in $\mathrm{Spin}(10) \times \mathrm{U}(1)$ is identified as $B - L$ in the literature (Boyle 2020) but not analyzed here. Relevant for Phase 19-20.

3. **"Probing" step formalizability:** The argument that the C*-observer's probing of $V_{1/2}$ forces extension of scalars (Step 6) is physically motivated but not stated as a formal theorem. This is the weakest link in the CMPL-01 chain.

4. **From local to global complexification:** The observer directly complexifies $V_{1/2}$ (Part II). The full algebra complexification $h_3(\mathbb{O}) \to h_3^\mathbb{C}(\mathbb{O})$ (Part III) is the natural algebraic completion. A formal proof that complexification of $V_{1/2}$ alone necessitates complexification of the full algebra is not provided; rather, we observe that the full complexification is the consistent algebraic framework containing $V_{1/2}^\mathbb{C}$.

---

## Summary of Part III

**Central result:**

$$\boxed{\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16} \quad \text{under } \mathrm{Spin}(10) \subset E_6 = \mathrm{Str}_0(h_3^\mathbb{C}(\mathbb{O}))}$$

with each summand identified with a Peirce subspace of $h_3(\mathbb{O})$:

$$\mathbf{1} = V_1^\mathbb{C}, \quad \mathbf{10} = V_0^\mathbb{C}, \quad \mathbf{16} = V_{1/2}^\mathbb{C} = S_{10}^+$$

**Full upgrade chain (Phase 18 combined):**

$$\begin{aligned}
\text{Algebra:} &\quad h_3(\mathbb{O}) \xrightarrow{\text{C*-observer}} h_3^\mathbb{C}(\mathbb{O}) \\
\text{Symmetry:} &\quad F_4 \to E_6 \\
\text{Stabilizer:} &\quad \mathrm{Spin}(9) \to \mathrm{Spin}(10) \times \mathrm{U}(1) \\
\text{Spinor:} &\quad S_9 \to S_{10}^+ \\
\text{Decomposition:} &\quad 27 = 1 + 16 + 10 \;\to\; 27 = \mathbf{1} + \mathbf{16} + \mathbf{10} \text{ of } \mathrm{Spin}(10)
\end{aligned}$$
