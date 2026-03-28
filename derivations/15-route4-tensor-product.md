# Route 4: Tensor Product A tensor_R V_{1/2} and Complexification

% ASSERT_CONVENTION: natural_units=dimensionless, jordan_product=(1/2)(ab+ba), peirce_decomposition=under_E11, state_normalization=Tr(rho)=1

**Phase 22, Plan 04: Route 4 -- Tensor Product Complexification**

References:
- Hanche-Olsen, *On the structure and tensor products of JC-algebras*, Canad. J. Math. 35 (1983), 1059--1074
- Alfsen-Shultz, *State Spaces of Operator Algebras* (2001)
- Baez, *The Octonions*, Bull. AMS 39 (2002), 145--205

---

## Part I: Setup and the R-Tensor Product

### Step 1: The Data

**Observer.** From Paper 5 (self-modeling forces C*-algebra): the observer's full algebra is $A = M_n(\mathbb{C})$, a C*-algebra over $\mathbb{C}$. Its self-adjoint part $A^{sa} = M_n(\mathbb{C})^{sa}$ is the Jordan algebra of observables. As a real vector space, $\dim_\mathbb{R}(A) = 2n^2$. As a complex vector space (with scalar multiplication by $z \in \mathbb{C}$ via $z \cdot a = za$), $\dim_\mathbb{C}(A) = n^2$.

**Target module.** The Peirce half-space of $h_3(\mathbb{O})$ under $e = E_{11}$:
$$V_{1/2} = \mathbb{O}^2 \cong S_9 \quad (\text{real Spin}(9)\text{ spinor, } \dim_\mathbb{R} = 16)$$

This is a real vector space. It carries the structure of a Jordan module (Peirce bimodule) over $V_1 \cong \mathbb{R}$ and $V_0 \cong h_2(\mathbb{O})$ via the Peirce multiplication rules $V_i \circ V_{1/2} \subseteq V_{1/2}$. However, $V_{1/2}$ is NOT itself a Jordan algebra -- it is a module (bimodule) in the Peirce decomposition.

**The question.** What happens when the observer $A = M_n(\mathbb{C})$ "probes" $V_{1/2}$, modeled by the tensor product $A \otimes_\mathbb{R} V_{1/2}$?

### Step 2: The R-Tensor Product $A \otimes_\mathbb{R} V_{1/2}$

**Definition.** The tensor product $A \otimes_\mathbb{R} V_{1/2}$ is formed over $\mathbb{R}$. This means we treat both $A$ and $V_{1/2}$ as real vector spaces and form the usual algebraic tensor product over the reals.

**Real dimension:**
$$\dim_\mathbb{R}(A \otimes_\mathbb{R} V_{1/2}) = \dim_\mathbb{R}(A) \cdot \dim_\mathbb{R}(V_{1/2}) = 2n^2 \cdot 16 = 32n^2$$

**Left A-module structure.** Since $A = M_n(\mathbb{C})$ is an algebra, $A \otimes_\mathbb{R} V_{1/2}$ is naturally a left $A$-module via:
$$a \cdot \left(\sum_i a_i \otimes v_i\right) = \sum_i (a \cdot a_i) \otimes v_i$$

where $a \cdot a_i$ is the product in $M_n(\mathbb{C})$.

**Induced complex structure.** Since $A$ is a $\mathbb{C}$-algebra, the left $A$-module $A \otimes_\mathbb{R} V_{1/2}$ inherits a complex structure from $A$: for $z \in \mathbb{C}$ and $\sum_i a_i \otimes v_i \in A \otimes_\mathbb{R} V_{1/2}$,
$$z \cdot \left(\sum_i a_i \otimes v_i\right) := \sum_i (z a_i) \otimes v_i$$

This is well-defined because $z a_i \in A$ (since $A$ is a $\mathbb{C}$-algebra). The map $z \mapsto (z \cdot -)$ satisfies $(z_1 z_2) \cdot x = z_1 \cdot (z_2 \cdot x)$ and $1 \cdot x = x$, so this gives $A \otimes_\mathbb{R} V_{1/2}$ the structure of a complex vector space.

**Complex dimension.** As a complex vector space under this $\mathbb{C}$-action:
$$\dim_\mathbb{C}(A \otimes_\mathbb{R} V_{1/2}) = \frac{\dim_\mathbb{R}(A \otimes_\mathbb{R} V_{1/2})}{2} = \frac{32n^2}{2} = 16n^2$$

**Verification:** This can be seen directly. Choose a $\mathbb{C}$-basis $\{e_1, \ldots, e_{n^2}\}$ for $A$ and an $\mathbb{R}$-basis $\{v_1, \ldots, v_{16}\}$ for $V_{1/2}$. Then $\{e_j \otimes v_k\}_{j=1,\ldots,n^2;\, k=1,\ldots,16}$ is a $\mathbb{C}$-basis for $A \otimes_\mathbb{R} V_{1/2}$, giving $\dim_\mathbb{C} = n^2 \cdot 16$. (This works because every element can be written as a $\mathbb{C}$-linear combination: $(ie_j) \otimes v_k = i \cdot (e_j \otimes v_k)$, so $\{e_j, ie_j\}_{j}$ over $\mathbb{R}$ reduces to $\{e_j\}_{j}$ over $\mathbb{C}$.)

### Step 3: The C-Tensor Product $A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$

**Definition.** Let $V_{1/2}^\mathbb{C} = V_{1/2} \otimes_\mathbb{R} \mathbb{C}$ be the standard complexification of $V_{1/2}$. This is a complex vector space with:
$$\dim_\mathbb{C}(V_{1/2}^\mathbb{C}) = \dim_\mathbb{R}(V_{1/2}) = 16$$

Now form the tensor product over $\mathbb{C}$:
$$A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$$

**Complex dimension:**
$$\dim_\mathbb{C}(A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}) = \dim_\mathbb{C}(A) \cdot \dim_\mathbb{C}(V_{1/2}^\mathbb{C}) = n^2 \cdot 16 = 16n^2$$

This matches $\dim_\mathbb{C}(A \otimes_\mathbb{R} V_{1/2}) = 16n^2$. The dimensions agree.

### Step 4: Canonical Isomorphism $A \otimes_\mathbb{R} V_{1/2} \cong A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$

**Claim.** There is a canonical isomorphism of complex $A$-modules:
$$\varphi: A \otimes_\mathbb{C} V_{1/2}^\mathbb{C} \xrightarrow{\;\sim\;} A \otimes_\mathbb{R} V_{1/2}$$

**Construction of $\varphi$:** Define on elementary tensors:
$$\varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) = (za) \otimes_\mathbb{R} v$$

where $a \in A$, $v \in V_{1/2}$, $z \in \mathbb{C}$.

**Well-definedness over $\mathbb{C}$:** The tensor product $\otimes_\mathbb{C}$ identifies $wa \otimes_\mathbb{C} u = a \otimes_\mathbb{C} wu$ for $w \in \mathbb{C}$, $u \in V_{1/2}^\mathbb{C}$, $a \in A$. We must check $\varphi$ respects this. Take $u = v \otimes_\mathbb{R} z$:

- LHS: $\varphi(wa \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) = (zwa) \otimes_\mathbb{R} v$
- RHS: $\varphi(a \otimes_\mathbb{C} w(v \otimes_\mathbb{R} z)) = \varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} wz)) = (wza) \otimes_\mathbb{R} v$

Since $zwa = wza$ (commutativity of $\mathbb{C}$), LHS = RHS. $\checkmark$

**Construction of $\psi$ (inverse):** Define:
$$\psi: A \otimes_\mathbb{R} V_{1/2} \to A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$$
$$\psi(a \otimes_\mathbb{R} v) = a \otimes_\mathbb{C} (v \otimes_\mathbb{R} 1)$$

**Verification that $\varphi$ and $\psi$ are mutual inverses:**

$\varphi \circ \psi$: For $a \otimes_\mathbb{R} v$,
$$\varphi(\psi(a \otimes_\mathbb{R} v)) = \varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} 1)) = (1 \cdot a) \otimes_\mathbb{R} v = a \otimes_\mathbb{R} v \quad \checkmark$$

$\psi \circ \varphi$: For $a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)$,
$$\psi(\varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z))) = \psi((za) \otimes_\mathbb{R} v) = (za) \otimes_\mathbb{C} (v \otimes_\mathbb{R} 1) = a \otimes_\mathbb{C} z(v \otimes_\mathbb{R} 1) = a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z) \quad \checkmark$$

The second-to-last equality uses the $\mathbb{C}$-tensor product relation $za \otimes_\mathbb{C} u = a \otimes_\mathbb{C} zu$.

**$\mathbb{C}$-linearity:** For $w \in \mathbb{C}$,
$$\varphi(w \cdot (a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z))) = \varphi((wa) \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) = (zwa) \otimes_\mathbb{R} v = w \cdot ((za) \otimes_\mathbb{R} v) = w \cdot \varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) \quad \checkmark$$

**$A$-linearity (left module map):** For $b \in A$,
$$\varphi(b \cdot (a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z))) = \varphi((ba) \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) = (zba) \otimes_\mathbb{R} v = b \cdot ((za) \otimes_\mathbb{R} v) = b \cdot \varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) \quad \checkmark$$

SELF-CRITIQUE CHECKPOINT (Step 4):
1. SIGN CHECK: No signs involved -- all maps are linear (no minus signs).
2. FACTOR CHECK: No numerical factors introduced. The map is purely algebraic.
3. CONVENTION CHECK: $\otimes_\mathbb{R}$ and $\otimes_\mathbb{C}$ are correctly distinguished. Scalars act on the LEFT factor of the tensor product ($A$-side). $\checkmark$
4. DIMENSION CHECK: Both sides have $\dim_\mathbb{C} = 16n^2$. $\checkmark$

### Step 5: Hanche-Olsen Context

**Hanche-Olsen (1983)** established a tensor product theory for **JC-algebras** -- Jordan algebras that can be realized as self-adjoint parts of C*-algebras, i.e., $B \subseteq C^*\text{-alg}^{sa}$.

Key points from Hanche-Olsen's framework:

**(a) JC-algebras tensor with C*-algebras.** For a JC-algebra $B$ and a C*-algebra $A$, Hanche-Olsen defines $B \hat{\otimes} A^{sa}$, a JC-algebra tensor product. This uses the universal C*-algebra $C^*(B)$ of $B$: every JC-algebra $B$ embeds in $C^*(B)^{sa}$, and the tensor product is defined via $C^*(B) \otimes A$.

**(b) The exceptional case.** $h_3(\mathbb{O})$ is NOT a JC-algebra. It cannot be embedded in any $B(H)^{sa}$ (Alfsen-Shultz 2001, Theorem 11.59). Consequently, the Hanche-Olsen JC-algebra tensor product framework does not apply directly to $h_3(\mathbb{O})$.

**(c) But $V_{1/2}$ is not a Jordan algebra.** $V_{1/2} = \mathbb{O}^2$ is a Peirce bimodule, not a Jordan algebra (it has no identity element, and the Jordan product $V_{1/2} \circ V_{1/2} \subseteq V_1 \oplus V_0$ takes elements OUT of $V_{1/2}$). The tensor product $A \otimes_\mathbb{R} V_{1/2}$ is formed between a C*-algebra and a real vector space -- this is simply the algebraic tensor product of vector spaces. No Jordan or C*-structure of $V_{1/2}$ is needed.

**(d) Scope of our construction.** Our tensor product $A \otimes_\mathbb{R} V_{1/2}$ is:
- Well-defined for ANY real vector space $V$ and ANY $\mathbb{C}$-algebra $A$
- Independent of the Hanche-Olsen JC-algebra framework
- Does not require $V_{1/2}$ to carry algebra structure
- Does not require $h_3(\mathbb{O})$ to be a JC-algebra

The Hanche-Olsen theory is relevant context (it tells us what would happen if we tried to tensor the Jordan algebras $V_1$ or $V_0$ with $A$ in the Jordan framework), but our construction bypasses it entirely.

### Step 6: The Peirce Interface vs. Tensor Product Model

**Two models of "observer probes $V_{1/2}$":**

**Model T (Tensor product).** The observer forms $A \otimes_\mathbb{R} V_{1/2}$, treating $V_{1/2}$ as a space the observer has "a copy of for each degree of freedom." This is the model analyzed above. It gives: the observer's description space is $A \otimes_\mathbb{R} V_{1/2} \cong A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$, and $V_{1/2}^\mathbb{C}$ appears necessarily.

**Model P (Peirce interface).** The observer interacts with $V_{1/2}$ through the Peirce multiplication rule $V_1 \circ V_{1/2} \subseteq V_{1/2}$. Since $V_1 = \mathbb{R} \cdot E_{11}$, the Peirce action of $V_1$ on $V_{1/2}$ is simply scalar multiplication by a real number: $(\alpha E_{11}) \circ w = \frac{1}{2}\alpha w$ for $w \in V_{1/2}$. The observer enriches $V_1$ from $\mathbb{R}$ to $\mathbb{C}$ (since $A = M_n(\mathbb{C})$ contains $\mathbb{C} \cdot E_{11}$ as a subalgebra), and the enriched Peirce action becomes $\mathbb{C}$-scalar multiplication on $V_{1/2}$, which requires extending $V_{1/2}$ to $V_{1/2}^\mathbb{C}$.

**The distinction:** Model T uses the full tensor product structure; Model P uses only the Peirce interface (a much more constrained interaction). Both lead to $V_{1/2}^\mathbb{C}$ appearing, but via different mechanisms:

- Model T: $V_{1/2}^\mathbb{C}$ appears because $A \otimes_\mathbb{R} V = A \otimes_\mathbb{C} V^\mathbb{C}$ for any real vector space $V$.
- Model P: $V_{1/2}^\mathbb{C}$ appears because the enriched Peirce action requires $\mathbb{C}$-scalars to act on $V_{1/2}$.

Model P is the extension-of-scalars argument from Phase 18, Step 6, now seen from the Peirce angle.

---

## Summary of Part I

| Object | Definition | $\dim_\mathbb{R}$ | $\dim_\mathbb{C}$ |
|:---:|:---:|:---:|:---:|
| $A = M_n(\mathbb{C})$ | Observer's C*-algebra | $2n^2$ | $n^2$ |
| $V_{1/2} = \mathbb{O}^2$ | Peirce half-space | 16 | N/A (real) |
| $V_{1/2}^\mathbb{C}$ | Complexification | 32 | 16 |
| $A \otimes_\mathbb{R} V_{1/2}$ | R-tensor product | $32n^2$ | $16n^2$ |
| $A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$ | C-tensor product | $32n^2$ | $16n^2$ |

Canonical isomorphism: $\varphi: A \otimes_\mathbb{C} V_{1/2}^\mathbb{C} \xrightarrow{\sim} A \otimes_\mathbb{R} V_{1/2}$, with $\varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) = (za) \otimes_\mathbb{R} v$.

---

## Part II: Does the Tensor Product Route Force Canonical Complexification?

### Step 7: The Three Levels of the Result

The situation from Part I: $A \otimes_\mathbb{R} V_{1/2} \cong A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$ canonically. We now analyze at three levels whether this constitutes a deep result specific to $h_3(\mathbb{O})$ or a generic algebraic fact.

**LEVEL 1: Algebraic tautology (generic).**

For ANY $\mathbb{C}$-algebra $A$ and ANY real vector space $V$, the canonical isomorphism
$$A \otimes_\mathbb{R} V \cong A \otimes_\mathbb{C} (V \otimes_\mathbb{R} \mathbb{C})$$
holds as complex $A$-modules. This is a standard result in commutative algebra / module theory (see, e.g., Bourbaki, *Algebra* II, Section 5.1, or Atiyah-Macdonald, Chapter 2 tensor product exercises).

**The proof is the one we gave in Steps 2--4.** It uses ONLY:
- $A$ is a $\mathbb{C}$-algebra (to define the $\mathbb{C}$-action on $A \otimes_\mathbb{R} V$)
- $V$ is a real vector space (no additional structure required)
- Commutativity of $\mathbb{C}$ (for well-definedness of $\varphi$)

It does NOT use:
- That $V = V_{1/2}$ comes from a Peirce decomposition
- That $h_3(\mathbb{O})$ is an exceptional Jordan algebra
- That $V_{1/2}$ carries a $\mathrm{Spin}(9)$ action
- Any property specific to octonions or Jordan algebras

**Verdict on Level 1:** The isomorphism $A \otimes_\mathbb{R} V_{1/2} \cong A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$ is a **generic algebraic tautology**. It proves that $V_{1/2}^\mathbb{C}$ appears as a factor in the tensor product, but this would be true for ANY real vector space $V$ in place of $V_{1/2}$.

**LEVEL 2: Peirce-enhanced (partially specific).**

The tensor product model is one way to formalize "observer probes $V_{1/2}$." A more physically grounded model uses the Peirce interface:

The observer enriches $V_1 = \mathbb{R} \cdot E_{11}$ to $\mathbb{C} \cdot E_{11} \subset A$. The Peirce multiplication $L_e: V_{1/2} \to V_{1/2}$ via $L_e(w) = e \circ w = \frac{1}{2}w$ extends from $L_{\alpha e}(w) = \frac{1}{2}\alpha w$ ($\alpha \in \mathbb{R}$) to $L_{ze}(w) = \frac{1}{2}zw$ ($z \in \mathbb{C}$).

For this to make sense, we need $z \cdot w$ to be defined for $z \in \mathbb{C}$ and $w \in V_{1/2}$. But $V_{1/2}$ is a real vector space, so $i \cdot w$ is not defined within $V_{1/2}$. The resolution: the operator $J := L_{iE_{11}}$ is defined not on $V_{1/2}$ itself, but on its complexification $V_{1/2}^\mathbb{C} = V_{1/2} \otimes_\mathbb{R} \mathbb{C}$.

On $V_{1/2}^\mathbb{C}$, the operator $J$ acts as:
$$J(v \otimes z) = v \otimes (iz) \cdot \frac{1}{2} = \frac{1}{2}(v \otimes iz)$$

but more precisely, $J$ is the operator corresponding to "multiply by $\frac{1}{2}i$" in the complexified Peirce action, which requires $V_{1/2}^\mathbb{C}$ as its domain.

**What is Peirce-specific here:** The fact that the observer interacts with $V_{1/2}$ THROUGH the Peirce interface -- that is, through the map $L_e: V_{1/2} \to V_{1/2}$ -- is specific to the Jordan algebra setup. A generic real vector space $V$ has no reason to be related to the observer via such a structured map. The Peirce rules constrain HOW the observer interacts with $V_{1/2}$, even though the resulting complexification is the same as the generic tensor product.

**But:** The Peirce-enhanced argument is essentially the same as Phase 18 Step 6 (extension of scalars). The tensor product language does not add new content beyond restating the extension-of-scalars argument in tensor notation.

**LEVEL 3: Physical interpretation.**

The observer's measurement on $V_{1/2}$ involves forming correlators. The observer's state space consists of positive linear functionals $\omega: A \to \mathbb{C}$. When probing $V_{1/2}$, the observer forms "measurement outcomes" that are elements of $A \otimes V_{1/2}$ evaluated against states:
$$\omega(a) \cdot v \quad \text{for } a \otimes v \in A \otimes V_{1/2}$$

Since $\omega(a) \in \mathbb{C}$, the measurement outcomes are complex-valued vectors: $\omega(a) \cdot v$ requires $\mathbb{C}$-scalar multiplication on $V_{1/2}$, which means the observer's description of $V_{1/2}$ is automatically $V_{1/2}^\mathbb{C}$.

**Physical summary:** The observer CANNOT describe $V_{1/2}$ as purely real because:
1. Its states produce complex amplitudes ($\omega(a) \in \mathbb{C}$)
2. These amplitudes multiply vectors in $V_{1/2}$
3. The product $z \cdot v$ for $z \in \mathbb{C}$, $v \in V_{1/2}$ requires $V_{1/2}^\mathbb{C}$

SELF-CRITIQUE CHECKPOINT (Step 7):
1. SIGN CHECK: No signs involved -- the analysis is structural. N/A.
2. FACTOR CHECK: The factor of $1/2$ in the Peirce multiplication $L_e(w) = \frac{1}{2}w$ is correctly tracked from the Jordan product convention $a \circ b = \frac{1}{2}(ab + ba)$.
3. CONVENTION CHECK: $\otimes_\mathbb{R}$ vs $\otimes_\mathbb{C}$ correctly distinguished throughout. Jordan product convention consistent. $\checkmark$
4. DIMENSION CHECK: All dimension counts from Part I carry through. $\checkmark$

### Step 8: Assessment -- Generic vs. $h_3(\mathbb{O})$-Specific

**The honest verdict:**

The tensor product isomorphism $A \otimes_\mathbb{R} V_{1/2} \cong A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$ is a **generic algebraic fact** that holds for ANY real vector space $V$ tensored with ANY $\mathbb{C}$-algebra $A$.

This means Route 4 **does not use the specific structure of $h_3(\mathbb{O})$**, the Peirce decomposition, or the Jordan algebra framework in any essential way. The result would be the same for $V = \mathbb{R}^{16}$ with no Jordan or octonion structure.

**What IS specific to $h_3(\mathbb{O})$:**

The tensor product model is motivated by the Peirce setup: the reason $V_{1/2}$ is the space being probed (rather than some arbitrary vector space) comes from the Peirce decomposition of $h_3(\mathbb{O})$ under $E_{11}$. Specifically:
- That $V_{1/2} = \mathbb{O}^2$ has $\dim_\mathbb{R} = 16$ (not some other dimension)
- That $V_{1/2}$ carries the $\mathrm{Spin}(9)$ spinor representation $S_9$
- That the complexification $V_{1/2}^\mathbb{C} = S_{10}^+$ (Weyl spinor of $\mathrm{Spin}(10)$)
- That the symmetry upgrades $\mathrm{Spin}(9) \to \mathrm{Spin}(10)$

These downstream consequences ARE $h_3(\mathbb{O})$-specific. But the complexification step itself -- the passage from $V_{1/2}$ to $V_{1/2}^\mathbb{C}$ -- is generic.

**Forbidden proxy assessment:** The tensor product argument alone is dangerously close to the forbidden proxy fp-assume-tensor-complexify: "Assuming that tensor product with a complex algebra automatically complexifies without proving canonicity." Our analysis shows that this IS what happens -- the tensor product with a $\mathbb{C}$-algebra DOES automatically complexify -- but this is a THEOREM, not an assumption. The issue is that the theorem is too generic: it does not use the specific Jordan/Peirce structure.

**Relationship to Phase 18 extension of scalars:** The tensor product route (Route 4) is the extension-of-scalars argument (Phase 18, Step 6) expressed in tensor product language. Both reduce to the same mathematical fact: a $\mathbb{C}$-linear observer can only describe real spaces via their complexifications.

### Step 9: The Route 4 Theorem (Formal Statement)

**Theorem (Route 4 -- Tensor Product Complexification).**

Let $A$ be a unital $\mathbb{C}$-algebra and $V$ a real vector space. Then:

(a) The real tensor product $A \otimes_\mathbb{R} V$ is canonically a complex vector space via $z \cdot (a \otimes v) = (za) \otimes v$.

(b) There is a canonical isomorphism of complex $A$-modules:
$$A \otimes_\mathbb{R} V \cong A \otimes_\mathbb{C} (V \otimes_\mathbb{R} \mathbb{C})$$
given by $\varphi(a \otimes_\mathbb{C} (v \otimes_\mathbb{R} z)) = (za) \otimes_\mathbb{R} v$ with inverse $\psi(a \otimes_\mathbb{R} v) = a \otimes_\mathbb{C} (v \otimes_\mathbb{R} 1)$.

(c) In particular, $V^\mathbb{C} = V \otimes_\mathbb{R} \mathbb{C}$ appears as a factor in the observer's tensor product description. The complex structure on $V^\mathbb{C}$ is canonical (determined by $A$'s $\mathbb{C}$-algebra structure).

(d) The isomorphism is natural (functorial in $V$): for any $\mathbb{R}$-linear map $f: V \to W$, the diagram
$$\begin{array}{ccc} A \otimes_\mathbb{R} V & \xrightarrow{\text{id} \otimes f} & A \otimes_\mathbb{R} W \\ \downarrow \psi & & \downarrow \psi \\ A \otimes_\mathbb{C} V^\mathbb{C} & \xrightarrow{\text{id} \otimes f^\mathbb{C}} & A \otimes_\mathbb{C} W^\mathbb{C} \end{array}$$
commutes, where $f^\mathbb{C}(v \otimes z) = f(v) \otimes z$.

**Specialization to $h_3(\mathbb{O})$:** Setting $A = M_n(\mathbb{C})$ and $V = V_{1/2} = \mathbb{O}^2$:

$$M_n(\mathbb{C}) \otimes_\mathbb{R} \mathbb{O}^2 \cong M_n(\mathbb{C}) \otimes_\mathbb{C} (\mathbb{O}^2 \otimes_\mathbb{R} \mathbb{C}) = M_n(\mathbb{C}) \otimes_\mathbb{C} S_{10}^+$$

with $\dim_\mathbb{C} = 16n^2$.

### Step 10: Strength Assessment

**What Route 4 establishes:**
1. The tensor product $A \otimes_\mathbb{R} V_{1/2}$ necessarily contains $V_{1/2}^\mathbb{C}$ as a factor -- this is a theorem (not an assumption).
2. The complex structure on $V_{1/2}^\mathbb{C}$ is canonical (no choices involved).
3. The isomorphism is functorial, so it respects all maps between Peirce spaces.

**What Route 4 does NOT establish:**
1. It does NOT prove that $V_{1/2}$ itself carries a complex structure. The complexification lives in the tensor product $A \otimes V_{1/2}$, not in $V_{1/2}$ alone.
2. It does NOT use any $h_3(\mathbb{O})$-specific structure. The same result holds for any real vector space.
3. It does NOT distinguish "complexification in the observer's eye" from "complexification in the world."

**Classification:** Route 4 provides a **WEAK positive result**: complexification is forced when the observer forms a tensor product with $V_{1/2}$, but this is a generic algebraic fact rather than a deep consequence of the Peirce/Jordan/octonion structure.

**The distinction:**
- "Observer SEES $V_{1/2}^\mathbb{C}$" -- YES (by Level 1 algebraic tautology)
- "$V_{1/2}$ IS complex" -- NOT ESTABLISHED (would require a complex structure on $V_{1/2}$ itself, or a Peirce-specific argument like Route 2's measurement map theorem)

### Step 11: Summary and Relationship to Other Routes

**Route 4 result:** $A \otimes_\mathbb{R} V_{1/2} \cong A \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$ (generic algebraic tautology; complexification in the observer's description).

**Relationship to Phase 18 Step 6:** Route 4 is the tensor product formulation of the extension-of-scalars argument. Both express the same idea: a $\mathbb{C}$-linear system describes real spaces via their complexifications. The tensor product language adds precision (explicit isomorphism, functoriality) but no new physics.

**What ADDITIONAL argument would use $h_3(\mathbb{O})$-specific structure:**
- The Peirce multiplication rules $V_i \circ V_j \subseteq V_{|i-j|} \oplus V_{\min(i+j,1)}$
- The $\mathrm{Spin}(9)$ representation theory on $V_{1/2}$
- The non-associativity of $\mathbb{O}$ (which makes $h_3(\mathbb{O})$ exceptional)
- The exceptional nature of $h_3(\mathbb{O})$ (not embeddable as a JC-algebra)

Such Peirce-specific arguments are pursued in Routes 1--3 of this phase. Route 4 provides the algebraic baseline: complexification appears in the tensor product regardless of specific structure, and the $h_3(\mathbb{O})$-specific content enters through identifying WHAT complexifies (namely $S_9 \to S_{10}^+$) and WHAT symmetry it carries.

---

## Final Summary

| Aspect | Result |
|:---|:---|
| **Theorem** | $A \otimes_\mathbb{R} V \cong A \otimes_\mathbb{C} V^\mathbb{C}$ (generic, any $\mathbb{C}$-algebra $A$, any real $V$) |
| **Specificity** | Generic algebraic tautology; does NOT use Jordan/Peirce/octonion structure |
| **Strength** | WEAK: complexification in observer's tensor product, not on $V_{1/2}$ itself |
| **Canonical?** | YES: the isomorphism and complex structure are canonical (no choices) |
| **Functorial?** | YES: natural in $V$ |
| **Relationship to Phase 18** | Tensor product reformulation of extension-of-scalars argument (Step 6) |
| **What IS $h_3(\mathbb{O})$-specific** | The identification $V_{1/2} = S_9$ and $V_{1/2}^\mathbb{C} = S_{10}^+$ (representation theory) |
| **Forbidden proxy** | fp-assume-tensor-complexify: NOT violated (we PROVED the tautology, not assumed it), but result is generic |
| **Verdict** | Positive but weak; provides algebraic baseline for Routes 1--3 |
