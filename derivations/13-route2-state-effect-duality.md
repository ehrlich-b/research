# Route 2: State-Effect Duality and Complexification

% ASSERT_CONVENTION: natural_units=dimensionless, jordan_product=(1/2)(ab+ba), peirce_decomposition=under_E11, state_normalization=Tr(rho)=1

**Phase 22, Plan 02: State-Effect Duality Route to Complexification**

---

## Part I: Observer State Probing of V_{1/2} via Peirce Duality

### Step 1: Observer States on M_n(C)^sa

The observer's algebra is $M_n(\mathbb{C})^{sa}$ -- the self-adjoint part of a complex matrix algebra (Paper 5). In the Peirce decomposition of $h_3(\mathbb{O})$ under $e = E_{11}$, the observer's Peirce 1-space is:

$$V_1 = \{\alpha E_{11} : \alpha \in \mathbb{R}\} \cong \mathbb{R}$$

A **state** on $M_n(\mathbb{C})^{sa}$ is a positive normalized linear functional:

$$\omega: M_n(\mathbb{C})^{sa} \to \mathbb{R}, \quad \omega(a) = \mathrm{Tr}(\rho \cdot a)$$

where $\rho$ is a density matrix: $\rho \geq 0$, $\mathrm{Tr}(\rho) = 1$.

**Properties of states:**
- **Linearity over R:** $\omega(\alpha a + \beta b) = \alpha\,\omega(a) + \beta\,\omega(b)$ for $\alpha, \beta \in \mathbb{R}$
- **Positivity:** $\omega(a^2) \geq 0$ for all $a \in M_n(\mathbb{C})^{sa}$
- **Normalization:** $\omega(\mathbf{1}) = 1$

The **C-linear extension** of $\omega$ to the full algebra $M_n(\mathbb{C})$ is:

$$\omega^{\mathbb{C}}: M_n(\mathbb{C}) \to \mathbb{C}, \quad \omega^{\mathbb{C}}(a + ib) = \omega(a) + i\,\omega(b)$$

for $a, b \in M_n(\mathbb{C})^{sa}$. This extension is:
- Well-defined: every $z \in M_n(\mathbb{C})$ has a unique decomposition $z = a + ib$ with $a, b$ self-adjoint
- Unique: determined entirely by $\omega$ on $M_n(\mathbb{C})^{sa}$
- $\mathbb{C}$-linear: $\omega^{\mathbb{C}}(z_1 + \lambda z_2) = \omega^{\mathbb{C}}(z_1) + \lambda\,\omega^{\mathbb{C}}(z_2)$ for $\lambda \in \mathbb{C}$

### Step 2: Peirce Multiplication Rules and the Observer Interface

The Peirce decomposition $h_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0$ under $E_{11}$ satisfies the standard multiplication rules (Alfsen-Shultz, *State Spaces of Operator Algebras*, 2001, Ch. 6):

| Product | Result |
|:---:|:---:|
| $V_1 \circ V_1$ | $\subset V_1$ |
| $V_1 \circ V_{1/2}$ | $\subset V_{1/2}$ |
| $V_1 \circ V_0$ | $= \{0\}$ |
| $V_{1/2} \circ V_{1/2}$ | $\subset V_1 \oplus V_0$ |
| $V_{1/2} \circ V_0$ | $\subset V_{1/2}$ |
| $V_0 \circ V_0$ | $\subset V_0$ |

The **observer interface** consists of two mechanisms by which the observer accesses $V_{1/2}$:

**(a) Left multiplication by V_1 elements.** For any $a \in V_1$, the map $L_a: V_{1/2} \to V_{1/2}$ defined by $v \mapsto a \circ v$ is an endomorphism of $V_{1/2}$. Since $V_1 \cong \mathbb{R}$, every element of $V_1$ is $\alpha E_{11}$, and $L_{\alpha E_{11}}(v) = \alpha \cdot (E_{11} \circ v) = \frac{\alpha}{2} v$. So $L_a$ acts as scalar multiplication by $\alpha/2$ on $V_{1/2}$ -- the observer can only rescale, not rotate, $V_{1/2}$ elements through this channel.

**(b) Peirce-projected bilinear pairing.** For $v, w \in V_{1/2}$, the Jordan product $v \circ w \in V_1 \oplus V_0$. The observer has direct access to $V_1$ (its own Peirce space), so the projection $P_1(v \circ w)$ is the observer-accessible part of this product.

### Step 3: Explicit Computation of P_1(v * w) for V_{1/2} = O^2

Let $v, w \in V_{1/2}$. Using the explicit parametrization from derivation 11:

$$v = \begin{pmatrix} 0 & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix}, \quad w = \begin{pmatrix} 0 & \bar{y}_3 & y_2 \\ y_3 & 0 & 0 \\ \bar{y}_2 & 0 & 0 \end{pmatrix}$$

where $x_2, x_3, y_2, y_3 \in \mathbb{O}$.

Computing $v \circ w = \frac{1}{2}(vw + wv)$:

The $(1,1)$ entry of $vw$ is:
$$(vw)_{11} = 0 \cdot 0 + \bar{x}_3 \cdot y_3 + x_2 \cdot \bar{y}_2$$

The $(1,1)$ entry of $wv$ is:
$$(wv)_{11} = 0 \cdot 0 + \bar{y}_3 \cdot x_3 + y_2 \cdot \bar{x}_2$$

Therefore the $(1,1)$ entry of $v \circ w$ is:

$$(v \circ w)_{11} = \frac{1}{2}\bigl(\bar{x}_3 y_3 + x_2 \bar{y}_2 + \bar{y}_3 x_3 + y_2 \bar{x}_2\bigr)$$

Using the identity $\bar{a}b + \bar{b}a = 2\,\mathrm{Re}(\bar{a}b)$ for octonions (since $\bar{a}b + \overline{\bar{a}b} = \bar{a}b + \bar{b}a$ and $\mathrm{Re}(q) = \frac{1}{2}(q + \bar{q})$):

$$(v \circ w)_{11} = \mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(x_2 \bar{y}_2)$$

Note: $\mathrm{Re}(x_2 \bar{y}_2) = \mathrm{Re}(\bar{y}_2 x_2) = \mathrm{Re}(\overline{\bar{x}_2 y_2}) = \mathrm{Re}(\bar{x}_2 y_2)$ since $\mathrm{Re}(\bar{q}) = \mathrm{Re}(q)$ for octonions. So:

$$(v \circ w)_{11} = \mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2)$$

Since $V_1 = \mathbb{R} \cdot E_{11}$, the Peirce projection is:

$$\boxed{P_1(v \circ w) = \bigl[\mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2)\bigr] \cdot E_{11}}$$

This is a **real scalar** times $E_{11}$.

**Verification:** The inner product $\langle x, y \rangle = \mathrm{Re}(\bar{x}y)$ is the standard Euclidean inner product on $\mathbb{O} \cong \mathbb{R}^8$. Therefore:

$$P_1(v \circ w) = \bigl[\langle x_3, y_3 \rangle_{\mathbb{R}^8} + \langle x_2, y_2 \rangle_{\mathbb{R}^8}\bigr] \cdot E_{11}$$

This is the standard real inner product on $V_{1/2} = \mathbb{O}^2 \cong \mathbb{R}^{16}$.

SELF-CRITIQUE CHECKPOINT (Step 3):
1. SIGN CHECK: Signs in $(v \circ w)_{11}$ verified: $\bar{x}_3 y_3$ and $x_2 \bar{y}_2$ are conjugation patterns matching the Hermitian matrix structure. The identity $\bar{a}b + \bar{b}a = 2\mathrm{Re}(\bar{a}b)$ holds for octonions. $\checkmark$
2. FACTOR CHECK: Factor of $1/2$ in Jordan product cancels with factor of 2 from $\bar{a}b + \bar{b}a = 2\mathrm{Re}(\bar{a}b)$. $\checkmark$
3. CONVENTION CHECK: Jordan product $\circ = \frac{1}{2}(ab + ba)$, Peirce under $E_{11}$. Octonion conjugation $\bar{x}$ reverses all imaginary units. $\checkmark$
4. DIMENSION CHECK: $P_1(v \circ w) \in V_1 \cong \mathbb{R}$. The inner product maps $\mathbb{R}^{16} \times \mathbb{R}^{16} \to \mathbb{R}$. $\checkmark$

### Step 4: State-Effect Pairing on V_{1/2}

The observer evaluates states on $V_{1/2}$ elements through the Peirce-projected pairing. For a state $\omega$ on $V_1 \cong \mathbb{R}$ (where $\omega(\alpha E_{11}) = \alpha$ since $\omega(E_{11}) = 1$ by normalization when the observer is at this Peirce slot), the state-effect pairing is:

$$\omega(P_1(v \circ w)) = \mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2) \in \mathbb{R}$$

More generally, if the observer's state is $\omega$ with $\omega(E_{11}) = \alpha$ (not necessarily normalized to 1 on $E_{11}$ alone, since $\omega$ is a state on the full $M_n(\mathbb{C})^{sa}$), then:

$$\omega(P_1(v \circ w)) = \alpha \cdot \bigl[\mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2)\bigr]$$

**Key observation:** $P_1(v \circ w)$ is a real scalar times $E_{11}$, and any state $\omega$ evaluated on a real scalar times $E_{11}$ returns a **real number**. The C-linear extension $\omega^{\mathbb{C}}$ does not produce additional information here because:

$$\omega^{\mathbb{C}}\bigl(P_1(v \circ w)\bigr) = \omega\bigl(P_1(v \circ w)\bigr) \in \mathbb{R}$$

since $P_1(v \circ w) \in V_1 \subset M_n(\mathbb{C})^{sa}$ (already self-adjoint, no imaginary part).

### Step 5: The R-bilinear Form Induced by States

The state-effect pairing defines an $\mathbb{R}$-bilinear form on $V_{1/2}$:

$$B_\omega: V_{1/2} \times V_{1/2} \to \mathbb{R}, \quad B_\omega(v, w) = \omega(P_1(v \circ w))$$

**Properties of $B_\omega$:**

1. **$\mathbb{R}$-bilinear:** Follows from $\mathbb{R}$-linearity of the Jordan product and projection.

2. **Symmetric:** $B_\omega(v, w) = B_\omega(w, v)$ since the Jordan product is commutative: $v \circ w = w \circ v$.

3. **Positive semi-definite:** For $v = w$:
   $$B_\omega(v, v) = \alpha \cdot (\|x_3\|^2 + \|x_2\|^2) \geq 0$$
   when $\alpha = \omega(E_{11}) > 0$ (which holds for any faithful state).

4. **Non-degenerate (for faithful states):** $B_\omega(v, w) = 0$ for all $w$ implies $x_2 = x_3 = 0$, hence $v = 0$.

This is the standard Euclidean inner product on $V_{1/2} \cong \mathbb{R}^{16}$, scaled by the state parameter $\alpha$.

### Step 6: C-Linear Extension and the Complexification Question

**Question:** Does the C-linear extension $\omega^{\mathbb{C}}$ upgrade $B_\omega$ to a $\mathbb{C}$-bilinear or sesquilinear form on $V_{1/2} \otimes_\mathbb{R} \mathbb{C}$?

Consider extending $B_\omega$ to $V_{1/2}^{\mathbb{C}} = V_{1/2} \otimes_\mathbb{R} \mathbb{C}$. There are two ways:

**(a) Sesquilinear extension (Hermitian form):**
$$H(v \otimes z_1, w \otimes z_2) = \bar{z}_1 z_2 \cdot B_\omega(v, w)$$

This gives a Hermitian inner product on $V_{1/2}^{\mathbb{C}}$.

**(b) C-bilinear extension:**
$$B^{\mathbb{C}}(v \otimes z_1, w \otimes z_2) = z_1 z_2 \cdot B_\omega(v, w)$$

This gives a symmetric $\mathbb{C}$-bilinear form.

**However**, neither extension is forced by the state-effect pairing. The pairing $B_\omega(v, w)$ is an $\mathbb{R}$-bilinear form on a real vector space. Both (a) and (b) are standard algebraic extensions that exist for any real bilinear form -- they are not specific to the state-effect duality or the C-linear extension $\omega^{\mathbb{C}}$.

**The critical obstruction:** The C-linear extension $\omega^{\mathbb{C}}$ acts on $M_n(\mathbb{C})$ (the observer's full algebra), not on $V_{1/2}$. When applied to $P_1(v \circ w) \in V_1 \cong \mathbb{R}$, the extension $\omega^{\mathbb{C}}$ returns the same real value as $\omega$ because $P_1(v \circ w)$ is already self-adjoint. The complex structure of the observer's algebra is not transmitted to $V_{1/2}$ through this pairing.

---

## Summary of Part I

The state-effect pairing between observer states $\omega$ and $V_{1/2}$ elements, mediated by the Peirce projection $P_1$, yields an $\mathbb{R}$-bilinear form $B_\omega(v,w) = \omega(P_1(v \circ w))$ that is the standard real inner product on $\mathbb{O}^2 \cong \mathbb{R}^{16}$ (up to a positive scalar). The C-linear extension $\omega^{\mathbb{C}}$ does not produce additional complex structure on $V_{1/2}$ because the Peirce projection $P_1$ maps to $V_1 \cong \mathbb{R}$, which is already self-adjoint.

The question for Part II: does any other Peirce-mediated mechanism transmit the observer's complex structure to $V_{1/2}$?

---

## Part II: State-Effect Duality Does NOT Force Complexification

### Step 7: Exhaustive Analysis of Observer Access Channels

The observer's C*-algebra is $M_n(\mathbb{C})^{sa}$, living at the Peirce 1-space $V_1 \cong \mathbb{R}$. We systematically enumerate all channels through which the observer can access $V_{1/2}$.

**Channel 1: Direct Peirce pairing (analyzed in Part I).**
$v, w \in V_{1/2} \implies P_1(v \circ w) \in V_1 \cong \mathbb{R}$.
Output: real scalar. No complex information transmitted.

**Channel 2: Higher-order pairings through V_1.**
The observer could attempt multi-step constructions. For instance:
- Pick $a \in V_1$, form $a \circ v \in V_{1/2}$ for $v \in V_{1/2}$
- Then form $P_1((a \circ v) \circ w) = P_1(\frac{\alpha}{2} v \circ w) = \frac{\alpha}{2} P_1(v \circ w)$

This is just a rescaling of Channel 1. Since $V_1 \cong \mathbb{R}$, the element $a = \alpha E_{11}$ acts as $\frac{\alpha}{2} \cdot \mathrm{id}$ on $V_{1/2}$, so all higher-order compositions through $V_1$ reduce to scalar multiples of the basic pairing.

**Channel 3: Triple products.**
Consider $\{v, a, w\} = (v \circ a) \circ w + (w \circ a) \circ v - (v \circ w) \circ a$ (the Jordan triple product). For $a \in V_1$, $v, w \in V_{1/2}$:

$$\{v, E_{11}, w\} = \frac{1}{2}v \circ w + \frac{1}{2}w \circ v - (v \circ w) \circ E_{11}$$

Since $v \circ w \in V_1 \oplus V_0$ and $E_{11}$ acts as the identity on $V_1$ and annihilates $V_0$:

$$\{v, E_{11}, w\} = v \circ w - P_1(v \circ w) \cdot E_{11} = P_0(v \circ w)$$

So the triple product with $a = E_{11}$ gives the $V_0$-component, which is in the "unobserved" algebra $V_0 \cong h_2(\mathbb{O})$ and not directly accessible to the observer.

**Channel 4: The observer's effect algebra.**
The effects $E(M_n(\mathbb{C})^{sa}) = \{a \in M_n(\mathbb{C})^{sa} : 0 \leq a \leq \mathbf{1}\}$ are elements of $V_1$ (since the observer's algebra is embedded at $V_1$). Since $V_1 \cong \mathbb{R}$, the effects are just numbers $\alpha \in [0,1]$, and their action on $V_{1/2}$ via Peirce multiplication is scalar: $\alpha E_{11} \circ v = \frac{\alpha}{2} v$. No complex structure transmitted.

**Channel 5: C-linear extension acting on non-self-adjoint elements.**
The C-linear extension $\omega^{\mathbb{C}}$ can evaluate non-self-adjoint elements of $M_n(\mathbb{C})$. But the Peirce product $v \circ w$ for $v, w \in V_{1/2} \subset h_3(\mathbb{O})$ produces elements in $h_3(\mathbb{O})$, which is a real Jordan algebra. Every element of $h_3(\mathbb{O})$ is self-adjoint (by definition). Therefore:

$$\omega^{\mathbb{C}}(P_1(v \circ w)) = \omega(P_1(v \circ w)) \in \mathbb{R}$$

The C-linear extension never encounters a genuinely non-self-adjoint element through Peirce-mediated access to $V_{1/2}$.

SELF-CRITIQUE CHECKPOINT (Step 7):
1. SIGN CHECK: Triple product formula verified: $\{v, e, w\} = v \circ w - P_1(v \circ w) E_{11}$ follows from $E_{11}$ acting as identity on $V_1$ and zero on $V_0$. $\checkmark$
2. FACTOR CHECK: $L_{E_{11}}$ acts as $\frac{1}{2}$ on $V_{1/2}$ (standard Peirce eigenvalue). $\checkmark$
3. CONVENTION CHECK: Effects in $[0,1]$, Peirce rules from Alfsen-Shultz. $\checkmark$
4. DIMENSION CHECK: N/A (this step is structural analysis, not dimensional). $\checkmark$

### Step 8: The Root Cause -- V_1 is One-Dimensional

The obstruction has a clean structural explanation.

**Proposition.** *For the Peirce decomposition of $h_3(\mathbb{O})$ under a rank-1 idempotent $e = E_{11}$, the observer's Peirce 1-space $V_1 \cong \mathbb{R}$ is one-dimensional over $\mathbb{R}$. Every Peirce-mediated observable on $V_{1/2}$ factors through $V_1 \cong \mathbb{R}$. Since $\mathbb{R}$ carries no complex structure, the C-linear extension of observer states cannot transmit complex structure to $V_{1/2}$.*

**Proof.**

(i) $V_1 = \mathbb{R} \cdot E_{11}$ has $\dim_{\mathbb{R}}(V_1) = 1$. This is because $e = E_{11}$ is a rank-1 idempotent in $h_3(\mathbb{O})$, and the Peirce 1-space of a rank-1 idempotent in a simple EJA is always 1-dimensional (Alfsen-Shultz, 2001, Prop. 6.31).

(ii) The observer's direct access to $V_{1/2}$ is through the map:
$$V_{1/2} \times V_{1/2} \xrightarrow{\circ} V_1 \oplus V_0 \xrightarrow{P_1} V_1 \cong \mathbb{R}$$

Every composite map from $V_{1/2}$ to the observer's algebra factors through $P_1: V_1 \oplus V_0 \to V_1$.

(iii) The C-linear extension $\omega^{\mathbb{C}}$ is defined on $M_n(\mathbb{C}) \supset M_n(\mathbb{C})^{sa}$. But the Peirce interface delivers only elements of $V_1 \cong \mathbb{R} \subset M_n(\mathbb{C})^{sa}$. Applying $\omega^{\mathbb{C}}$ to a real number returns that same real number:
$$\omega^{\mathbb{C}}(\alpha \cdot E_{11}) = \alpha \cdot \omega^{\mathbb{C}}(E_{11}) = \alpha \cdot \omega(E_{11}) = \alpha \cdot 1 = \alpha$$

(The last equality holds for a state normalized at $E_{11}$.)

(iv) Therefore, the C-linear extension $\omega^{\mathbb{C}}$ is indistinguishable from $\omega$ when restricted to Peirce-mediated observables. The complex structure of $M_n(\mathbb{C})$ is "invisible" through the Peirce interface because $V_1$ is real and 1-dimensional. $\square$

### Step 9: Counterexample -- States That Probe V_{1/2} Without Inducing Complex Structure

We construct an explicit counterexample demonstrating that the state-effect pairing is intrinsically real.

**Construction.** Let $\omega$ be any state on $M_n(\mathbb{C})^{sa}$ with $\omega(E_{11}) = 1$. Define:

$$\Phi_\omega: V_{1/2} \times V_{1/2} \to \mathbb{R}, \quad \Phi_\omega(v, w) = \omega(P_1(v \circ w))$$

We showed (Step 3) that $\Phi_\omega(v, w) = \mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2)$, independent of the choice of state $\omega$ (up to the normalization factor $\omega(E_{11})$).

**Claim.** There is no $\mathbb{R}$-linear endomorphism $J: V_{1/2} \to V_{1/2}$ with $J^2 = -\mathrm{id}$ such that $\Phi_\omega(Jv, w) = -\Phi_\omega(v, Jw)$ (skew-Hermitian condition) that is canonically determined by the state-effect pairing.

**Proof.** The pairing $\Phi_\omega$ is the standard real inner product on $\mathbb{R}^{16}$ (up to positive scalar). An almost complex structure $J$ with $J^2 = -\mathrm{id}$ on $\mathbb{R}^{16}$ that is compatible with the inner product (i.e., $J \in O(16)$) parametrizes the coset space $O(16)/U(8)$, which has dimension $\dim O(16) - \dim U(8) = 120 - 64 = 56$.

The space of almost complex structures compatible with the inner product is 56-dimensional -- there is no canonical (i.e., unique, distinguished) choice. Any $J \in O(16)$ with $J^2 = -\mathrm{id}$ defines a valid complexification $V_{1/2}^{\mathbb{C}} = (V_{1/2}, J)$, but no choice is singled out by the state-effect pairing alone.

In particular:
- The state-effect pairing provides an $O(16)$-invariant inner product on $V_{1/2}$
- An almost complex structure $J$ breaks $O(16)$ to $U(8)$
- The pairing does not select which $U(8) \subset O(16)$ to use
- Therefore the pairing does not determine a complexification

**Contrast with Phase 18 complexification.** The Phase 18 argument (derivation 11, Step 6) used the observer's C*-nature (C-linear scalar field) to argue for extension of scalars $V_{1/2} \otimes_{\mathbb{R}} \mathbb{C}$. That argument works at the level of the observer's *framework* (module structure) rather than through specific Peirce-mediated pairings. The Route 2 analysis here shows that the *specific mechanism* of state-effect pairing through Peirce projection does not transmit complex structure. $\square$

SELF-CRITIQUE CHECKPOINT (Step 9):
1. SIGN CHECK: $J^2 = -\mathrm{id}$ sign is correct for almost complex structure. $\checkmark$
2. FACTOR CHECK: $\dim(O(16)/U(8)) = \dim O(16) - \dim U(8) = 120 - 64 = 56$. Compatible complex structures form a 56-dimensional family. $\checkmark$
3. CONVENTION CHECK: Standard definitions of almost complex structure and compatibility. $\checkmark$
4. DIMENSION CHECK: $\dim(O(16)/U(8)) = \dim O(16) - \dim U(8) = 120 - 64 = 56$. $\checkmark$

### Step 10: Route 2 Verdict

**Theorem (Route 2 -- Counterexample).** *State-effect duality does NOT force complexification of $V_{1/2}$.*

*More precisely: The C-linear extension $\omega^{\mathbb{C}}$ of an observer state $\omega$ on $M_n(\mathbb{C})^{sa}$, when used to probe $V_{1/2} = \mathbb{O}^2$ through the Peirce interface $P_1: V_{1/2} \circ V_{1/2} \to V_1$, yields only a real-valued inner product on $V_{1/2}$. The complex structure of $M_n(\mathbb{C})$ is not transmitted to $V_{1/2}$ through this pairing because:*
1. *$P_1(v \circ w) \in V_1 \cong \mathbb{R}$ for all $v, w \in V_{1/2}$ (the Peirce projection produces a real scalar)*
2. *$\omega^{\mathbb{C}}$ restricted to real elements returns real values*
3. *The resulting $\mathbb{R}$-bilinear form $B_\omega(v, w) = \omega(P_1(v \circ w))$ admits infinitely many compatible complex structures (a 56-dimensional family), none canonically selected*

**Hypotheses used:**
- $h_3(\mathbb{O})$ is the exceptional Jordan algebra (27-dimensional)
- $E_{11}$ is a rank-1 idempotent generating the Peirce decomposition $V_1(1) \oplus V_{1/2}(16) \oplus V_0(10)$
- The observer's algebra is $M_n(\mathbb{C})^{sa}$ with C*-structure (Paper 5)
- States are positive normalized functionals $\omega(a) = \mathrm{Tr}(\rho \cdot a)$

**What this does NOT refute:** The Phase 18 complexification argument (derivation 11) operates at a different level. It argues that the observer's C*-nature forces extension of scalars $V_{1/2} \otimes_{\mathbb{R}} \mathbb{C}$ as a consequence of the observer's $\mathbb{C}$-linear algebraic framework, not through any specific Peirce pairing. The Route 2 analysis shows that the *specific mechanism* of state-effect duality through Peirce projection is too coarse (everything factors through $V_1 \cong \mathbb{R}$) to carry complex structure.

**Relation to Phase 18 complexification chain (Step 6):** The Phase 18 argument has 5 steps:
1. Self-modeling $\implies$ C*-algebra observer
2. C*-algebra $\implies$ $\mathbb{C}$ as scalar field
3. Observer probes $V_{1/2}$ through its algebraic framework
4. Observer's operations on probed spaces are $\mathbb{C}$-linear
5. $\therefore V_{1/2}$ is described as $V_{1/2} \otimes_{\mathbb{R}} \mathbb{C}$

Route 2 probes step 3-4 through the specific mechanism of Peirce-mediated state-effect pairing. The result: this mechanism does not achieve step 4. The Peirce interface is a lossy channel that projects everything to $V_1 \cong \mathbb{R}$, stripping out the observer's complex structure before it can be applied to $V_{1/2}$.

**Implication for v6.0:** State-effect duality (Route 2) does not provide an independent path to complexification. The complexification must come from a different mechanism -- either the framework-level argument of Phase 18, or one of the other routes (Route 1, 3, or 4).

### Step 11: Verification Checklist

1. **Peirce multiplication rules verified against Alfsen-Shultz:** $V_{1/2} \circ V_{1/2} \subset V_1 \oplus V_0$ -- confirmed in Step 3 by explicit computation. $\checkmark$

2. **State-effect pairing well-defined and R-bilinear:** $B_\omega(v,w) = \omega(P_1(v \circ w))$ is linear in both $v$ and $w$ over $\mathbb{R}$, symmetric (Jordan product is commutative), positive semi-definite. $\checkmark$

3. **P_1(v * w) computed explicitly:** $(v \circ w)_{11} = \mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2)$, which is a real scalar. $\checkmark$

4. **No forbidden proxies:** Result uses specific $h_3(\mathbb{O})$ Peirce structure under $E_{11}$, not a generic state space. Does not assume Spin(10). $\checkmark$

5. **Decisive outcome:** Counterexample established -- state-effect duality does not force complexification. Exactly one outcome (counterexample, not theorem). $\checkmark$

6. **Cross-check with Phase 18:** The counterexample does not contradict Phase 18's framework-level argument. It refutes only the specific state-effect pairing mechanism (Peirce-projected bilinear form). $\checkmark$

7. **Inner product verification:** $\mathrm{Re}(\bar{x}y)$ on $\mathbb{O}$ is the standard Euclidean inner product on $\mathbb{R}^8$: for $x = \sum x_i e_i$, $y = \sum y_i e_i$, $\mathrm{Re}(\bar{x}y) = \sum x_i y_i$. $\checkmark$

---

## Summary

**Route 2 verdict: COUNTEREXAMPLE.** State-effect duality through Peirce projection does not force complexification of $V_{1/2} = \mathbb{O}^2$.

The root cause is structural: the observer's Peirce 1-space $V_1 \cong \mathbb{R}$ is one-dimensional, so every Peirce-mediated observable on $V_{1/2}$ takes real values. The C-linear extension $\omega^{\mathbb{C}}$ of observer states is inert on real-valued data -- it returns the same real number as $\omega$. The pairing $B_\omega(v,w) = \omega(P_1(v \circ w))$ is the standard real inner product on $\mathbb{R}^{16}$, which admits a 56-dimensional family of compatible complex structures but selects none.

**Key equation:**

$$\boxed{P_1(v \circ w) = \bigl[\mathrm{Re}(\bar{x}_3 y_3) + \mathrm{Re}(\bar{x}_2 y_2)\bigr] \cdot E_{11} \in \mathbb{R} \cdot E_{11} = V_1}$$

This is the central computation: the Peirce projection to the observer's 1-space produces a real number, not a complex one. References: Alfsen-Shultz (2001, Ch. 6-9), Baez (2002, Sec. 3.4).
