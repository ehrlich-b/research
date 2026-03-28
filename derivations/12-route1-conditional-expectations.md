# Route 1: Conditional Expectations and Complexification

% ASSERT_CONVENTION: natural_units=dimensionless, jordan_product=(1/2)(ab+ba), peirce_decomposition=under_E11, compression=C_p_Alfsen_Shultz, state_normalization=Tr(rho)=1

**Phase 22, Plan 01: Effros-Stormer Conditional Expectations on h_3(O)**

---

## Part I: The Conditional Expectation Framework on h_3(O)

### Step 1: Conditional Expectations in the C*-Algebra and Jordan Algebra Settings

**C*-algebra setting (Umegaki, Tomiyama).** For a C*-algebra $A$ with a C*-subalgebra $B \subset A$ (sharing the unit), a *conditional expectation* is a positive unital projection $E: A \to B$ satisfying the bimodule property:

$$E(b_1 a b_2) = b_1 E(a) b_2 \quad \forall\, b_1, b_2 \in B,\; a \in A.$$

Key properties: $E$ is automatically completely positive and contractive ($\|E\| = 1$). The bimodule property forces $E$ to respect the algebraic product of $B$.

**Jordan algebra setting (Effros-Stormer 1979).** For a JB-algebra $J$ with a JB-subalgebra $B \subset J$ (sharing the unit), a *positive unital projection* $P: J \to B$ with $P^2 = P$, $P(1) = 1$, and $P(a) \geq 0$ whenever $a \geq 0$ is the Jordan analogue of a conditional expectation.

The Effros-Stormer theorem (Math. Scand. 45, 1979) establishes: the range of a positive unital projection on a JBW-algebra is a JBW-subalgebra. Moreover, for JB-algebras that are special (i.e., embeddable in a C*-algebra), positive unital projections correspond to conditional expectations in the ambient C*-algebra.

**The critical distinction for h_3(O):** The exceptional Jordan algebra $h_3(\mathbb{O})$ is *not* special -- it cannot be embedded in any C*-algebra (Albert 1934, Shirshov-Cohn theorem). This means the C*-algebraic conditional expectation theory does not apply directly. We must use the Jordan-algebraic version: positive unital projections on $h_3(\mathbb{O})$.

### Step 2: The Observer's Subalgebra and Peirce Projections

The observer is a C*-algebra system $A_{\text{obs}} = M_n(\mathbb{C})^{sa}$ (from Paper 5). The observer interacts with $h_3(\mathbb{O})$ through its idempotent $e = E_{11}$.

**Peirce decomposition** (established in derivation 11, Steps 1-3):

$$h_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0$$

with:
- $V_1 = \mathbb{R} \cdot E_{11}$, $\dim = 1$
- $V_{1/2} = \mathbb{O}^2$, $\dim = 16$
- $V_0 = h_2(\mathbb{O})$, $\dim = 10$
- **Total:** $1 + 16 + 10 = 27$ $\checkmark$

**The Peirce projections $P_\lambda$** are the spectral projections of the multiplication operator $L_e: X \mapsto e \circ X$:

$$P_1(X) = 2 L_e^2(X) - L_e(X), \qquad P_{1/2}(X) = 4L_e(X) - 4L_e^2(X), \qquad P_0(X) = 1 - 3L_e(X) + 2L_e^2(X)$$

where these formulas follow from Lagrange interpolation on the eigenvalues $\{0, 1/2, 1\}$ of $L_e$.

**Derivation of the Lagrange interpolation formulas:**

$L_e$ has eigenvalues $\lambda \in \{0, 1/2, 1\}$. The spectral projectors are:

$$P_\lambda = \prod_{\mu \neq \lambda} \frac{L_e - \mu}{\lambda - \mu}$$

For $P_1$ ($\lambda = 1$):
$$P_1 = \frac{(L_e - 0)(L_e - 1/2)}{(1-0)(1-1/2)} = \frac{L_e(L_e - 1/2)}{1/2} = 2L_e^2 - L_e$$

For $P_{1/2}$ ($\lambda = 1/2$):
$$P_{1/2} = \frac{(L_e - 0)(L_e - 1)}{(1/2 - 0)(1/2 - 1)} = \frac{L_e(L_e - 1)}{-1/4} = -4L_e^2 + 4L_e$$

For $P_0$ ($\lambda = 0$):
$$P_0 = \frac{(L_e - 1/2)(L_e - 1)}{(0-1/2)(0-1)} = \frac{(L_e - 1/2)(L_e - 1)}{1/2} = 2L_e^2 - 3L_e + 1$$

**Verification:** $P_1 + P_{1/2} + P_0 = (2L_e^2 - L_e) + (-4L_e^2 + 4L_e) + (2L_e^2 - 3L_e + 1) = 0 \cdot L_e^2 + 0 \cdot L_e + 1 = \mathrm{Id}$ $\checkmark$

### Step 3: Explicit Computation of the Peirce Projections for $e = E_{11}$

We already know $L_e(X) = e \circ X$ acts on a generic element

$$X = \begin{pmatrix} \alpha & \bar{x}_3 & x_2 \\ x_3 & \beta & \bar{x}_1 \\ \bar{x}_2 & x_1 & \gamma \end{pmatrix}$$

as (from derivation 11, Step 2):

$$L_e(X) = \frac{1}{2}\begin{pmatrix} 2\alpha & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix}$$

Now $L_e^2(X) = L_e(L_e(X))$. Writing $Y = L_e(X)$, we have $Y_{11} = \alpha$, $Y_{12} = \bar{x}_3/2$, $Y_{13} = x_2/2$, and all other entries involving $\beta, \gamma, x_1$ vanish. Then:

$$L_e(Y) = \frac{1}{2}\begin{pmatrix} 2\alpha & \bar{x}_3/2 & x_2/2 \\ x_3/2 & 0 & 0 \\ \bar{x}_2/2 & 0 & 0 \end{pmatrix}$$

So $L_e^2(X) = \frac{1}{2}\begin{pmatrix} 2\alpha & \bar{x}_3/2 & x_2/2 \\ x_3/2 & 0 & 0 \\ \bar{x}_2/2 & 0 & 0 \end{pmatrix}$.

**$P_1(X) = 2L_e^2(X) - L_e(X)$:**

$$P_1(X) = \begin{pmatrix} 2\alpha & \bar{x}_3/2 & x_2/2 \\ x_3/2 & 0 & 0 \\ \bar{x}_2/2 & 0 & 0 \end{pmatrix} - \frac{1}{2}\begin{pmatrix} 2\alpha & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix} = \begin{pmatrix} \alpha & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix} = \alpha \cdot E_{11}$$

$\checkmark$ Correct: $P_1$ extracts the $V_1$ component, the scalar coefficient of $E_{11}$.

**$P_{1/2}(X) = -4L_e^2(X) + 4L_e(X)$:**

$$P_{1/2}(X) = -2\begin{pmatrix} 2\alpha & \bar{x}_3/2 & x_2/2 \\ x_3/2 & 0 & 0 \\ \bar{x}_2/2 & 0 & 0 \end{pmatrix} + 2\begin{pmatrix} 2\alpha & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix} = \begin{pmatrix} 0 & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix}$$

$\checkmark$ Correct: $P_{1/2}$ extracts the $V_{1/2}$ component (the first row/column off-diagonal entries parametrized by $x_2, x_3 \in \mathbb{O}$).

**$P_0(X) = 2L_e^2(X) - 3L_e(X) + X$:**

$$P_0(X) = \begin{pmatrix} 2\alpha & \bar{x}_3/2 & x_2/2 \\ x_3/2 & 0 & 0 \\ \bar{x}_2/2 & 0 & 0 \end{pmatrix} - \frac{3}{2}\begin{pmatrix} 2\alpha & \bar{x}_3 & x_2 \\ x_3 & 0 & 0 \\ \bar{x}_2 & 0 & 0 \end{pmatrix} + \begin{pmatrix} \alpha & \bar{x}_3 & x_2 \\ x_3 & \beta & \bar{x}_1 \\ \bar{x}_2 & x_1 & \gamma \end{pmatrix}$$

$$= \begin{pmatrix} 0 & 0 & 0 \\ 0 & \beta & \bar{x}_1 \\ 0 & x_1 & \gamma \end{pmatrix}$$

$\checkmark$ Correct: $P_0$ extracts the $V_0 = h_2(\mathbb{O})$ component (the lower-right $2 \times 2$ Hermitian octonion block).

### Step 4: Alfsen-Shultz Compression Operators

The compression operator $C_e$ associated to an idempotent $e$ in a JB-algebra is (Alfsen-Shultz, *State Spaces of Operator Algebras*, Ch. 6):

$$C_e(X) = P_1(X) = 2(e \circ (e \circ X)) - e \circ X$$

This is equivalent to $C_e = 2L_e^2 - L_e = P_1$, which is the projection onto the Peirce 1-space $V_1(e)$.

The complementary compression is:

$$C_{e'} = C_{1-e} = P_0$$

which projects onto $V_0(e) = V_1(1-e)$ (since $1 - e = E_{22} + E_{33}$ in our case, and $V_0(e)$ is the Peirce 1-space of $1-e$).

**Properties of $C_e$ (Alfsen-Shultz Ch. 6, Prop. 6.23):**
1. $C_e$ is a positive map: $X \geq 0 \Rightarrow C_e(X) \geq 0$
2. $C_e$ is unital on $V_1$: $C_e(e) = e$, $C_e(1) = e$ (note: NOT unital on the full algebra)
3. $C_e^2 = C_e$ (projector)
4. $C_e$ and $C_{e'}$ commute: $C_e C_{e'} = C_{e'} C_e = 0$
5. The range of $C_e$ is $V_1(e)$

**Key observation:** $C_e$ is NOT a conditional expectation onto a subalgebra of $h_3(\mathbb{O})$ in the Effros-Stormer sense, because:
- $C_e(1) = e \neq 1$ (not unital)
- The range $V_1 = \mathbb{R} \cdot E_{11}$ is a subalgebra of $h_3(\mathbb{O})$ isomorphic to $\mathbb{R}$, but $C_e$ does not preserve the unit

The Peirce 1-projection $P_1$ and the Alfsen-Shultz compression $C_e$ are the same map.

### Step 5: Identifying the Correct "Observer Map"

The observer needs a map $P: h_3(\mathbb{O}) \to A_{\text{obs}}$ that captures what the C*-observer "sees" of the exceptional Jordan algebra. Several candidates:

**Candidate 1: Peirce 1-projection $P_1 = C_e$.**
- Maps $h_3(\mathbb{O}) \to V_1 = \mathbb{R} \cdot E_{11} \cong \mathbb{R}$
- Positive, but NOT unital ($P_1(1) = E_{11} \neq 1$)
- Too small: the observer sees only the diagonal entry $\alpha$

**Candidate 2: $P_1 + P_0$ (omitting $V_{1/2}$).**
- Maps $h_3(\mathbb{O}) \to V_1 \oplus V_0$ (dim 11)
- Positive and $P_1(1) + P_0(1) = E_{11} + (E_{22} + E_{33}) = 1$ -- unital! $\checkmark$
- But $V_1 \oplus V_0$ is NOT a Jordan subalgebra of $h_3(\mathbb{O})$: The Peirce multiplication rules give $V_0 \circ V_0 \subset V_0$ and $V_1 \circ V_1 \subset V_1$, but crucially $V_1 \circ V_0 \subset V_{1/2}$, NOT in $V_1 \oplus V_0$.

Wait -- let me verify this Peirce multiplication rule. The standard Peirce multiplication rules for a JB-algebra under an idempotent $e$ are:

$$V_i \circ V_j \subset \begin{cases} V_i & \text{if } i = j \\ V_{1/2} & \text{if } \{i,j\} = \{0,1\} \\ V_0 + V_1 & \text{if } i = j = 1/2 \end{cases}$$

More precisely: $V_1 \circ V_1 \subset V_1$, $V_0 \circ V_0 \subset V_0$, $V_1 \circ V_{1/2} \subset V_{1/2}$, $V_0 \circ V_{1/2} \subset V_{1/2}$, $V_1 \circ V_0 = 0$, and $V_{1/2} \circ V_{1/2} \subset V_1 + V_0$.

The crucial rule is $V_1 \circ V_0 = 0$: elements from $V_1$ and $V_0$ are Jordan-orthogonal! This means $V_1 \oplus V_0$ IS closed under the Jordan product:

- $V_1 \circ V_1 \subset V_1$ $\checkmark$
- $V_0 \circ V_0 \subset V_0$ $\checkmark$
- $V_1 \circ V_0 = 0 \subset V_1 \oplus V_0$ $\checkmark$

So $V_1 \oplus V_0$ is indeed a Jordan subalgebra.

**Corrected Candidate 2:** $P_1 + P_0: h_3(\mathbb{O}) \to V_1 \oplus V_0$ is a positive unital projection onto a Jordan subalgebra.

Let us verify: $V_1 \oplus V_0 = \mathbb{R} \cdot E_{11} \oplus h_2(\mathbb{O})$.

As a Jordan algebra:
- $V_1 \cong \mathbb{R}$ (trivial Jordan algebra)
- $V_0 \cong h_2(\mathbb{O})$ (spin factor $V_{10}$)
- $V_1 \circ V_0 = 0$

So $V_1 \oplus V_0 \cong \mathbb{R} \oplus h_2(\mathbb{O})$ as a direct sum of Jordan algebras, with unit $1 = E_{11} + (E_{22} + E_{33})$.

**Candidate 3: Observer's map as an Effros-Stormer positive unital projection onto a C*-subalgebra.**

For this, we need a C*-subalgebra inside $h_3(\mathbb{O})$. But $h_3(\mathbb{O})$ is exceptional: it contains no C*-subalgebra other than $\mathbb{R}$. This is because any special JB-subalgebra of $h_3(\mathbb{O})$ is contained in a maximal special subalgebra, and the maximal special subalgebras of $h_3(\mathbb{O})$ are all isomorphic to $h_3(\mathbb{R})$ or spin factors (Hanche-Olsen-Stormer, Thm. 7.2.5).

In particular, there is NO subalgebra of $h_3(\mathbb{O})$ isomorphic to $M_n(\mathbb{C})^{sa}$ for $n \geq 2$, because $M_n(\mathbb{C})^{sa}$ has $\dim = n^2 > 3$ for $n \geq 2$, while $h_3(\mathbb{R})$ has $\dim = 6$, and $V_k$ are spin factors.

**The key structural observation:** The observer $A_{\text{obs}} = M_n(\mathbb{C})^{sa}$ is an EXTERNAL system that interacts with $h_3(\mathbb{O})$. It does NOT embed IN $h_3(\mathbb{O})$ as a subalgebra. The interaction is through the Peirce decomposition: the observer's idempotent $e = E_{11}$ defines the Peirce structure, and the observer accesses information about $h_3(\mathbb{O})$ through the Peirce projections.

The correct formalization is therefore:

**Definition (Observer map).** The observer map is the Peirce projection $P_{1/2}: h_3(\mathbb{O}) \to V_{1/2}$ combined with the observer's representation of $V_{1/2}$. The observer "sees" $V_1$ (its own diagonal entry), "ignores" $V_0$ (the complement), and "interacts with" $V_{1/2}$ (the interface space).

The question of complexification then becomes: when the C*-observer represents $V_{1/2}$ in its own framework, does this representation necessarily carry a complex structure?

SELF-CRITIQUE CHECKPOINT (Steps 1-5):
1. SIGN CHECK: No sign-sensitive steps. N/A.
2. FACTOR CHECK: Lagrange interpolation coefficients verified: $P_1 + P_{1/2} + P_0 = \mathrm{Id}$ confirmed algebraically.
3. CONVENTION CHECK: Jordan product $\circ = \frac{1}{2}(ab + ba)$ used throughout. Peirce eigenvalues $\{0, 1/2, 1\}$ standard. Compression $C_e = P_1$ matches Alfsen-Shultz definition. $\checkmark$
4. DIMENSION CHECK: $P_1$ maps to dim 1, $P_{1/2}$ maps to dim 16, $P_0$ maps to dim 10. $1 + 16 + 10 = 27$. $\checkmark$

---

## Part II: Does the Conditional Expectation Force Complexification?

### Step 6: Precise Statement of the Question

**Question.** The C*-observer ($M_n(\mathbb{C})^{sa}$) interacts with $V_{1/2} = \mathbb{O}^2$ ($\dim_\mathbb{R} = 16$) through the Peirce multiplication rule

$$V_1 \circ V_{1/2} \subset V_{1/2}$$

Does the C*-nature of the observer force $V_{1/2}$ to carry a canonical complex structure $J: V_{1/2} \to V_{1/2}$ with $J^2 = -\mathrm{Id}$?

We investigate two paths and reach a nuanced conclusion.

### Step 7: The Peirce Multiplication Interface (PATH A Analysis)

The Peirce rule $V_1 \circ V_{1/2} \subset V_{1/2}$ provides the observer's algebraic access to $V_{1/2}$. Let us compute this explicitly.

$V_1 = \mathbb{R} \cdot E_{11}$. For $\alpha E_{11} \in V_1$ and $v \in V_{1/2}$:

$$(\alpha E_{11}) \circ v = \alpha (E_{11} \circ v) = \alpha \cdot \frac{1}{2} v = \frac{\alpha}{2} v$$

This is just scalar multiplication by $\alpha/2$. The Peirce multiplication interface $V_1 \circ V_{1/2} \subset V_{1/2}$ is trivial: it amounts to the fact that $L_e$ acts as $1/2$ on $V_{1/2}$, so $V_1$ acts on $V_{1/2}$ only through scalar multiplication.

**Consequence:** The Peirce multiplication rule alone provides NO non-trivial algebraic structure on $V_{1/2}$ from $V_1$. The observer's 1-eigenspace $V_1 \cong \mathbb{R}$ has no imaginary unit to transmit.

This immediately defeats the naive version of PATH A from the plan: there is no element $i \in V_1$ to act on $V_{1/2}$, because $V_1$ is 1-dimensional over $\mathbb{R}$.

### Step 8: Can the C*-Structure Transmit Through a Different Channel?

The previous step shows that the direct Peirce multiplication channel is too narrow. But the observer is a C*-system with internal complex structure. Can this complex structure be transmitted to $V_{1/2}$ through a more sophisticated mechanism?

**Mechanism attempt 1: Observer's C-linear action on V_{1/2}.**

The observer's algebra is $M_n(\mathbb{C})^{sa}$. Its complexification is $M_n(\mathbb{C})$, which has a natural $\mathbb{C}$-linear structure. Could the observer act on $V_{1/2}$ through $M_n(\mathbb{C})$ rather than through $V_1 = \mathbb{R}$?

The problem: the observer and $h_3(\mathbb{O})$ are separate algebraic systems. The observer does not act ON $h_3(\mathbb{O})$ as an algebra -- it is not a subalgebra, and there is no representation $\pi: M_n(\mathbb{C}) \to \mathrm{End}(h_3(\mathbb{O}))$ that comes from the Jordan structure. The only algebraic interface is the Peirce multiplication, which we showed is trivial.

**Mechanism attempt 2: Measurement maps as C-linear functionals.**

When the observer "measures" an element $v \in V_{1/2}$, it produces a real number (the expectation value). A measurement is a state $\rho$ on the observer's algebra, composed with some map $\phi: V_{1/2} \to A_{\text{obs}}$. If $\phi$ is $\mathbb{R}$-linear, the measurement value is:

$$\langle v \rangle = \rho(\phi(v))$$

For the observer to "see" $V_{1/2}$ through its C*-framework, $\phi$ must map into $M_n(\mathbb{C})^{sa}$. But any $\mathbb{R}$-linear map $\phi: V_{1/2} \to M_n(\mathbb{C})^{sa}$ into a complex algebra can be extended $\mathbb{C}$-linearly to $\phi_\mathbb{C}: V_{1/2} \otimes_\mathbb{R} \mathbb{C} \to M_n(\mathbb{C})$ by the universal property of extension of scalars. This is the original derivation-11 argument.

**However, this extension is not canonical or unique to the Peirce structure.** It works for ANY $\mathbb{R}$-linear map into ANY $\mathbb{C}$-algebra. It does not use the specific Jordan/Peirce structure of $h_3(\mathbb{O})$ at all.

### Step 9: The Bloch Sphere Counterexample and Its Resolution

**Counterexample attempt (from plan).** Consider $M_2(\mathbb{C})^{sa}$ acting on $\mathbb{R}^3$ (the Bloch sphere). The adjoint action:

$$\mathrm{Ad}(U): X \mapsto U X U^\dagger \quad \text{for } U \in SU(2),\; X \in \mathfrak{su}(2) \cong \mathbb{R}^3$$

is an $\mathbb{R}$-linear action of a C*-group on a real 3-dimensional space. This action does NOT complexify $\mathbb{R}^3$ -- it preserves the real structure (traceless self-adjoint matrices stay traceless self-adjoint).

**Analysis:** This shows that a C*-algebra acting on a real vector space via positive maps does not generically complexify that space. The Bloch sphere stays real even though $M_2(\mathbb{C})$ has complex structure.

**Resolution of the counterexample.** The Bloch sphere example and our situation differ in a critical way:

In the Bloch sphere case, $SU(2)$ acts on $\mathfrak{su}(2) \cong \mathbb{R}^3$ via the adjoint representation. The representation $\mathfrak{su}(2)$ is a REAL representation of $SU(2)$ -- it is the imaginary part of $M_2(\mathbb{C})$, not a space that the algebra "probes" through a Peirce interface.

In our case, $V_{1/2} = \mathbb{O}^2$ is not part of the observer's algebra at all. It is the "off-diagonal" Peirce space that lies between the observer's slot ($V_1$) and the complement ($V_0$). The observer accesses it through measurement maps (functionals), not through an internal algebraic action.

But this distinction does not by itself force complexification. The Bloch sphere counterexample shows: even when the target space is "external" to the C*-algebra, the C*-structure does not automatically transmit.

### Step 10: The Decisive Analysis -- Conditional Expectations Cannot Force Complexification

We now assemble the analysis into a definitive answer.

**Theorem (Route 1 -- Negative).** A positive unital projection $P: h_3(\mathbb{O}) \to B$ onto a JB-subalgebra $B$ does not, by itself, endow $V_{1/2}$ with a canonical complex structure. Specifically:

**(a) The Peirce interface is too narrow.** The Peirce multiplication $V_1 \circ V_{1/2} \subset V_{1/2}$ acts by scalar multiplication (Step 7). There is no algebraic element in $V_1$ that could serve as a complex structure $J$ on $V_{1/2}$.

**(b) The strongest natural Effros-Stormer map does not complexify.** The positive unital projection $P = P_1 + P_0: h_3(\mathbb{O}) \to V_1 \oplus V_0$ is the natural "conditional expectation" (it projects out $V_{1/2}$, keeping the observer's component and the complement). This map:
- Satisfies $P(1) = 1$ $\checkmark$
- Is positive: $X \geq 0 \Rightarrow P(X) \geq 0$ $\checkmark$ (since Peirce projections preserve positivity in JB-algebras, by Alfsen-Shultz Prop. 6.23)
- Is a projection: $P^2 = P$ $\checkmark$ (since $P_1$ and $P_0$ are orthogonal projectors)
- Its range $V_1 \oplus V_0 \cong \mathbb{R} \oplus h_2(\mathbb{O})$ is a Jordan subalgebra $\checkmark$

But this map annihilates $V_{1/2}$ entirely: $P(v) = 0$ for $v \in V_{1/2}$. It does not provide any structure on $V_{1/2}$.

**(c) No positive unital projection onto a C*-subalgebra exists.** As noted in Step 5, $h_3(\mathbb{O})$ contains no C*-subalgebra (isomorphic to $M_n(\mathbb{C})^{sa}$ for $n \geq 2$). The observer's C*-algebra is external. Therefore, there is no Effros-Stormer conditional expectation from $h_3(\mathbb{O})$ onto a C*-subalgebra -- the question is ill-posed within the strict Effros-Stormer framework applied to $h_3(\mathbb{O})$.

**(d) Extension of scalars is universal, not specific.** The argument from derivation 11 (Step 6) -- that the C*-observer extends scalars on any probed real space -- is valid but does not use the Peirce structure or Jordan algebra properties. It applies equally to any real vector space probed by any C*-system. This universality is both its strength (it always works) and its weakness (it provides no new structural insight from the conditional expectation framework).

**Proof of (a)-(d):**

(a) Computed explicitly in Step 7: $(\alpha E_{11}) \circ v = (\alpha/2)v$ for $v \in V_{1/2}$, which is scalar multiplication and carries no complex structure information.

(b) $P_1 + P_0$ satisfies all required properties of a positive unital projection. Its kernel is $V_{1/2}$, so it provides no information about $V_{1/2}$'s structure. Its range $V_1 \oplus V_0$ is a Jordan subalgebra (verified in Step 5) and is the joint range of the compressions $C_e$ and $C_{e'}$.

(c) $h_3(\mathbb{O})$ is an exceptional JB-algebra. By the Shirshov-Cohn theorem, any JB-subalgebra of $h_3(\mathbb{O})$ generated by two elements is special (embeds in a C*-algebra), but $h_3(\mathbb{O})$ itself is not special. The maximal special subalgebras are isomorphic to $h_3(\mathbb{R})$ (dim 6) or spin factors $V_k$ (Hanche-Olsen-Stormer, Jordan Operator Algebras, Ch. 7). None of these are isomorphic to $M_n(\mathbb{C})^{sa}$ for $n \geq 2$: $h_3(\mathbb{R}) \cong M_3(\mathbb{R})^{sa}$ is a real system, and spin factors $V_k$ are Jordan algebras of type $\mathbb{R} \oplus \mathbb{R}^{k-1}$ with product $(\alpha, v) \circ (\beta, w) = (\alpha\beta + \langle v, w\rangle, \alpha w + \beta v)$, which are NOT C*-algebra self-adjoint parts for $k \neq 3$.

(d) Extension of scalars is a functor from $\mathbb{R}$-Vect to $\mathbb{C}$-Vect. It maps any real vector space $V$ to $V \otimes_\mathbb{R} \mathbb{C}$ with the canonical complex structure $J(v \otimes z) = v \otimes iz$. This construction uses no properties of $h_3(\mathbb{O})$, no Peirce rules, and no Jordan structure. It would work equally well for $\mathbb{R}^{16}$ with no algebraic structure at all. $\square$

SELF-CRITIQUE CHECKPOINT (Steps 6-10):
1. SIGN CHECK: No sign-sensitive computations. N/A.
2. FACTOR CHECK: The $\alpha/2$ scalar in Step 7 is correct ($L_e$ has eigenvalue $1/2$ on $V_{1/2}$). $\checkmark$
3. CONVENTION CHECK: Using Peirce multiplication rules $V_1 \circ V_0 = 0$ (standard). Using Alfsen-Shultz positivity of Peirce projections. $\checkmark$
4. DIMENSION CHECK: $V_1 \oplus V_0$ has dim $1 + 10 = 11$, complement $V_{1/2}$ has dim 16, total 27. $\checkmark$

### Step 11: What Route 1 Tells Us About the Gap

**Route 1 conclusion:** The Effros-Stormer conditional expectation framework, applied to $h_3(\mathbb{O})$ with Peirce projections under $e = E_{11}$, does NOT force complexification of $V_{1/2}$. The framework is too weak to transmit the observer's complex structure to the Peirce $1/2$-space.

**Why the derivation-11 argument still works, but differently:** The complexification in derivation 11 (Step 6) is valid, but it relies on the UNIVERSAL extension-of-scalars argument, not on the SPECIFIC Peirce/Jordan structure. This is a weaker statement than "the conditional expectation forces complexification" -- it is the statement "any C*-observer describes any real space as a complex space."

**What this means for Gap C:** The complexification of $V_{1/2}$ is not a special consequence of the h_3(O) structure interacting with a C*-observer through Peirce projections. It is a general consequence of using C*-observers at all. This is still a valid physical argument (the observer IS a C*-system, and C*-systems DO extend scalars), but it lacks the specific algebraic mechanism that would make the complexification "structurally forced" by the Jordan algebra.

**Cross-check with derivation 11, Step 6c point 3:** The weakest link identified there was "observer probes V_{1/2} through its own C*-framework." Route 1 confirms that this probing does not transmit complex structure through the Peirce interface. The extension of scalars happens OUTSIDE the Jordan algebra framework, as a consequence of the observer's representation theory rather than the Jordan algebra's structure.

### Step 12: Verification Against Acceptance Tests

**test-route1-peirce:** Peirce decomposition $h_3(\mathbb{O}) = V_1(1) + V_{1/2}(16) + V_0(10)$ used explicitly, dimensions $1 + 16 + 10 = 27$. $\checkmark$

**test-route1-well-defined:** The positive unital projection $P = P_1 + P_0$ satisfies:
- $P(1) = P_1(1) + P_0(1) = E_{11} + (E_{22} + E_{33}) = 1$ $\checkmark$
- $P(X) \geq 0$ for $X \geq 0$: follows from positivity of Peirce projections $\checkmark$
- $P^2 = P$: since $P_1^2 = P_1$, $P_0^2 = P_0$, and $P_1 P_0 = P_0 P_1 = 0$ $\checkmark$

**test-route1-decisive:** The derivation produces outcome (b) -- the conditional expectation does NOT force complexification. The "counterexample" is the analysis showing the Peirce interface is trivial (scalar multiplication only) and no C*-subalgebra exists inside $h_3(\mathbb{O})$. This is a structural impossibility argument, not a single counterexample. $\checkmark$

**Forbidden proxy check:**
- fp-wrong-algebra: The proof works specifically with $h_3(\mathbb{O})$ (dim 27, Peirce under $E_{11}$). $\checkmark$
- fp-no-peirce: The Peirce multiplication rule $V_1 \circ V_{1/2} \subset V_{1/2}$ is explicitly computed and shown to be trivial (scalar multiplication). $\checkmark$
- fp-assume-spin10: Spin(10) is never assumed; the conclusion is that complexification is NOT forced by this route. $\checkmark$

---

## Summary

**Route 1 (Effros-Stormer conditional expectations): NEGATIVE.**

The conditional expectation framework does not force complexification of $V_{1/2}$. The reasons are:

1. The Peirce interface $V_1 \circ V_{1/2} \subset V_{1/2}$ is trivially scalar multiplication
2. The natural positive unital projection $P_1 + P_0$ annihilates $V_{1/2}$
3. No C*-subalgebra exists inside $h_3(\mathbb{O})$ (exceptional algebra)
4. Extension of scalars works but is universal, not specific to the Peirce structure

The derivation-11 complexification argument remains valid as a UNIVERSAL statement about C*-observers, but Route 1 does not strengthen it to a specific algebraic mechanism within the Jordan algebra framework.

**Implications for other routes:** Routes 2-4 must provide a specific algebraic mechanism (not just universal extension of scalars) by which the observer's complex structure is transmitted to $V_{1/2}$ through the structure of $h_3(\mathbb{O})$.
