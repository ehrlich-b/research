# Route 3: GNS Construction and Complexification of V_{1/2}

% ASSERT_CONVENTION: natural_units=dimensionless, jordan_product=(1/2)(ab+ba), peirce_decomposition=under_E11, state_normalization=Tr(rho)=1

**Phase 22, Plan 03: GNS Route to Complexification**

---

## Prior Results (from derivations/11-peirce-complexification.md)

- $h_3(\mathbb{O}) = V_1(1) \oplus V_{1/2}(16) \oplus V_0(10)$ under $e = E_{11}$
- $V_1 = \mathbb{R} \cdot E_{11}$, $V_{1/2} = \mathbb{O}^2 = S_9$, $V_0 = h_2(\mathbb{O})$
- Observer $= M_n(\mathbb{C})^{sa}$ with GNS triple $(H_\omega, \pi_\omega, \Omega_\omega)$
- **CRITICAL:** $h_3(\mathbb{O})$ is exceptional -- NOT a JC-algebra (Alfsen-Shultz 2001; Baez 2002)
- $V_0 = h_2(\mathbb{O})$ IS a JC-algebra: $h_2(\mathbb{O}) \hookrightarrow M_4(\mathbb{R})^{sa} \hookrightarrow M_4(\mathbb{C})^{sa}$
- $V_1 = \mathbb{R}$ embeds trivially in any C*-algebra

---

## Task 1: GNS-Type Representation and V_{1/2} Image Analysis

### 1.1 The GNS Construction for Jordan Algebras: Algebraic Background

The standard GNS construction for C*-algebras proceeds as follows: given a C*-algebra $A$ and a state $\omega : A \to \mathbb{C}$, one constructs a Hilbert space $H_\omega$, a *-representation $\pi_\omega : A \to B(H_\omega)$, and a cyclic vector $\Omega_\omega$ such that $\omega(a) = \langle \Omega_\omega, \pi_\omega(a) \Omega_\omega \rangle$.

For Jordan algebras, the situation depends fundamentally on whether the algebra is a **JC-algebra** (can be realized as a Jordan subalgebra of $B(H)^{sa}$ for some Hilbert space $H$) or not.

**Definition (JB-algebra).** A JB-algebra is a real Jordan algebra with a norm satisfying:
1. $\|a \circ b\| \leq \|a\| \cdot \|b\|$
2. $\|a^2\| = \|a\|^2$
3. $\|a^2\| \leq \|a^2 + b^2\|$

Every finite-dimensional formally real Jordan algebra (in the sense of Jordan-von Neumann-Wigner) is a JB-algebra.

**Definition (JC-algebra).** A JC-algebra is a norm-closed Jordan subalgebra of $B(H)^{sa}$ for some Hilbert space $H$. Equivalently, a JC-algebra admits a faithful *-representation on a Hilbert space.

**The classification (Alfsen-Shultz 2001, Theorem 7.4.12; Hanche-Olsen-Stormer 1984):**

Every JB-algebra $A$ can be decomposed as:
$$A = A_{JC} \oplus A_{exc}$$
where $A_{JC}$ is a JC-algebra (the "JC-part") and $A_{exc}$ is a direct sum of copies of $h_3(\mathbb{O})$ (the "exceptional part"). A JB-algebra is a JC-algebra if and only if its exceptional part is trivial.

**Consequence for $h_3(\mathbb{O})$:** The exceptional Jordan algebra $h_3(\mathbb{O})$ is purely exceptional: $A_{JC} = 0$, $A_{exc} = h_3(\mathbb{O})$. It admits **no faithful representation** on any Hilbert space.

% IDENTITY_CLAIM: h_3(O) admits no faithful representation on any Hilbert space
% IDENTITY_SOURCE: Alfsen-Shultz 2001 Theorem 7.4.12; Hanche-Olsen-Stormer 1984; Baez 2002 Section 4.3
% IDENTITY_VERIFIED: The exceptional status is a classification theorem, not a numerical identity. Cross-checked: dim(h_3(O))=27, Aut(h_3(O))=F_4, these are standard results that are consistent with exceptional status.

### 1.2 Sub-route (a): Direct GNS of h_3(O)

**Attempt:** Construct a GNS-like representation for $h_3(\mathbb{O})$ directly.

**Step 1:** Take a state $\omega$ on $h_3(\mathbb{O})$. A state is a positive linear functional with $\omega(1) = 1$. Since $h_3(\mathbb{O})$ is finite-dimensional (dim = 27), every state has the form:
$$\omega(X) = \mathrm{Tr}(\rho \circ X)$$
for some density element $\rho \in h_3(\mathbb{O})$ with $\rho \geq 0$ and $\mathrm{Tr}(\rho) = 1$, where $\mathrm{Tr}$ is the Jordan trace (sum of eigenvalues).

**Step 2:** In the JB-algebra GNS construction (Alfsen-Shultz 2001, Chapter 11), one forms the GNS Hilbert space:
$$H_\omega = \text{completion of } A / \ker(\omega_2)$$
where $\omega_2(a, b) = \omega(a \circ b)$ is the GNS inner product and $\ker(\omega_2) = \{a : \omega(a \circ a) = 0\}$.

For a *faithful* state $\omega$ (i.e., $\omega(a^2) > 0$ for all $a \neq 0$), we have $\ker(\omega_2) = \{0\}$, so $H_\omega = h_3(\mathbb{O})$ as a real inner product space with inner product $\langle a, b \rangle = \omega(a \circ b)$.

**Critical observation:** $H_\omega$ is a **real** Hilbert space of dimension 27. It is NOT a complex Hilbert space. The JB-algebra GNS construction for non-JC algebras produces a real Hilbert space, not a complex one.

**Step 3:** The GNS "representation" is the Jordan multiplication operator:
$$\pi_\omega(a)(b) = a \circ b$$
This maps $h_3(\mathbb{O})$ into the symmetric operators on the real Hilbert space $H_\omega$. But this is NOT a Hilbert space operator representation in the C*-algebra sense -- it is a Jordan representation on a real space.

**Step 4:** Since $h_3(\mathbb{O})$ is finite-dimensional and is its own bidual ($h_3(\mathbb{O})^{**} = h_3(\mathbb{O})$, automatically for finite-dimensional spaces), the "universal representation" simply gives back $h_3(\mathbb{O})$ itself. No new structure emerges.

**Conclusion (Sub-route a):** The direct GNS construction for $h_3(\mathbb{O})$ produces a 27-dimensional **real** inner product space. No complex Hilbert space arises. No complexification is induced.

SELF-CRITIQUE CHECKPOINT (Sub-route a):
1. SIGN CHECK: No sign-dependent steps. N/A.
2. FACTOR CHECK: dim(H_omega) = 27 = dim(h_3(O)) for faithful state. Correct.
3. CONVENTION CHECK: JB-algebra GNS per Alfsen-Shultz. The key distinction (real vs complex Hilbert space for exceptional algebras) is standard.
4. DIMENSION CHECK: H_omega = R^27 as real inner product space. Consistent with h_3(O) being 27-dimensional.

### 1.3 Sub-route (b): GNS of the Peirce Components

The Peirce components $V_1$ and $V_0$ ARE JC-algebras, so they have standard complex GNS constructions. Can these induce a complex structure on $V_{1/2}$?

**V_1 = R:** This is the trivial 1-dimensional Jordan algebra. Its GNS Hilbert space is $H_1 = \mathbb{C}$ (for a faithful state, which is unique: $\omega_1(\alpha) = \alpha$). The GNS representation is $\pi_1(\alpha)(z) = \alpha z$ for $z \in \mathbb{C}$, $\alpha \in \mathbb{R}$. This carries no non-trivial complex structure information.

**V_0 = h_2(O):** This is a JC-algebra. The standard representation theory gives:

$h_2(\mathbb{O})$ is a simple, 10-dimensional JB-algebra. Its JC-representation comes from the embedding:

$$h_2(\mathbb{O}) \hookrightarrow M_4(\mathbb{R})^{sa} \hookrightarrow M_4(\mathbb{C})^{sa}$$

where the first map uses the identification of $\mathbb{O}$ with $\mathbb{R}^8$ and the fact that left multiplication by an octonion $x$ on $\mathbb{O} \cong \mathbb{R}^8$ gives a real $8 \times 8$ matrix (but the 2x2 structure reduces to 4x4 blocks via the Cayley-Dickson construction). More precisely, $h_2(\mathbb{O}) \cong V_{10}$ (the 10-dimensional spin factor = the Jordan algebra of $\mathrm{Spin}(9)$), and spin factors embed into Clifford algebras:

$$V_{10} \hookrightarrow \mathrm{Cl}(9)^+ \cong M_{16}(\mathbb{R})$$

so the GNS Hilbert space for a faithful state on $V_0$ is $H_0 = \mathbb{C}^{16}$ (after complexification of the $\mathbb{R}^{16}$ representation space).

Actually, let me be more careful. The spin factor $V_n$ has the following representation structure (Hanche-Olsen-Stormer 1984, Theorem 6.2.3):

- For $n \leq 5$: $V_n$ embeds faithfully into $M_{2^{[n/2]}}(\mathbb{C})^{sa}$
- For $n = 6$: $V_6$ embeds into $M_4(\mathbb{C})^{sa}$, but also has a "quaternionic" representation on $M_2(\mathbb{H})^{sa}$
- For $n \geq 7$: $V_n$ embeds into $M_{2^{[(n-1)/2]}}(\mathbb{R})^{sa}$

For $V_0 = h_2(\mathbb{O}) \cong V_{10}$ (spin factor of dimension $1 + 9 = 10$, corresponding to $n = 9$ in the $V_n$ notation since the spin factor $V_n$ has dimension $n+1$):

Wait -- I need to be precise about notation. The spin factor $V_n$ has dimension $n$ in some conventions. Let me use the Hanche-Olsen-Stormer convention: $V_n$ is the spin factor with $n-1$ generators (satisfying $\{a_i, a_j\} = 2\delta_{ij}$) plus the identity, so $\dim(V_n) = n$.

$h_2(\mathbb{O})$ has dimension 10. An element is $\begin{pmatrix} \alpha & \bar{x} \\ x & \beta \end{pmatrix}$ with $\alpha, \beta \in \mathbb{R}$, $x \in \mathbb{O}$. This has $2 + 8 = 10$ real parameters. As a spin factor, $h_2(\mathbb{O}) \cong V_{10}$ where the generators are the 9 traceless elements of the form $\begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}$ and $\begin{pmatrix} 0 & \bar{e}_i \\ e_i & 0 \end{pmatrix}$ for $i = 0, 1, \ldots, 7$ (the 8 standard basis elements of $\mathbb{O}$), and these 9 elements anti-commute (in the Jordan sense: $a \circ b = 0$ for distinct generators).

So $V_0 \cong V_{10}$ (spin factor of dimension 10, with 9 anti-commuting generators).

The representation theory of $V_{10}$: Since $9 \geq 7$, the representation is real. $V_{10}$ embeds into $M_{2^{[(9-1)/2]}}(\mathbb{R})^{sa} = M_{2^4}(\mathbb{R})^{sa} = M_{16}(\mathbb{R})^{sa}$.

The GNS construction for a faithful state on $V_{10}$ in the JC framework gives a representation on $\mathbb{R}^{16}$ (or, after complexification, $\mathbb{C}^{16}$). The faithful representation is:
$$\pi_0 : V_{10} \hookrightarrow M_{16}(\mathbb{R})^{sa}$$
where the 9 generators map to the 9 gamma matrices of $\mathrm{Cl}(9)$ (more precisely, to the even part of $\mathrm{Cl}(9)$, but the spin factor sits inside the Clifford algebra naturally).

**Now, the Peirce module structure.** The Peirce multiplication rules are:
- $V_1 \circ V_{1/2} \subset V_{1/2}$: the observer acts on the interface
- $V_0 \circ V_{1/2} \subset V_{1/2}$: the complement acts on the interface
- $V_{1/2} \circ V_{1/2} \subset V_1 \oplus V_0$: the interface squares back into both components

The action of $V_0$ on $V_{1/2}$: for $a_0 \in V_0 = h_2(\mathbb{O})$ and $v \in V_{1/2} = \mathbb{O}^2$, the Peirce rule gives $a_0 \circ v \in V_{1/2}$. This makes $V_{1/2}$ a module over $V_0$ (via the Jordan product).

**Can the GNS of $V_0$ induce a complex structure on $V_{1/2}$?**

The GNS of $V_0 = V_{10}$ gives a representation $\pi_0 : V_0 \to M_{16}(\mathbb{R})^{sa}$. This acts on $\mathbb{R}^{16}$. The module action of $V_0$ on $V_{1/2}$ is:

$$V_0 \times V_{1/2} \to V_{1/2}, \quad (a_0, v) \mapsto a_0 \circ v$$

This is a real-linear action. For this to induce a complex structure on $V_{1/2}$, we would need an element $J \in \mathrm{End}_\mathbb{R}(V_{1/2})$ with $J^2 = -\mathrm{Id}$ that arises canonically from the $V_0$-module structure.

**Key question:** Does the module action of $V_0$ on $V_{1/2}$ produce such a $J$?

The action of $V_0$ on $V_{1/2}$ is through Jordan multiplication. For $a_0 \in V_0$, $L_{a_0} : V_{1/2} \to V_{1/2}$ is a real-linear map. However:

- $L_{a_0}$ is self-adjoint with respect to the trace inner product (Jordan multiplication operators are symmetric)
- Self-adjoint operators have real eigenvalues
- Therefore $L_{a_0}^2$ has non-negative eigenvalues
- Thus $L_{a_0}^2 \neq -\mathrm{Id}$ for any $a_0 \in V_0$

**This means no single element of $V_0$ can provide a complex structure on $V_{1/2}$ through Jordan multiplication.**

Could a complex structure arise from the *representation of $V_0$ on the GNS space*? If we embed $V_0 \hookrightarrow M_{16}(\mathbb{R})^{sa}$ and then complexify to get $V_0^\mathbb{C} \hookrightarrow M_{16}(\mathbb{C})^{sa}$, we are working in a complex algebra. But the complexification of the *representation space* ($\mathbb{R}^{16} \to \mathbb{C}^{16}$) is the trivial complexification -- it requires no canonical structure from $V_0$.

**Conclusion (Sub-route b):** The GNS of the Peirce components does not induce a canonical complex structure on $V_{1/2}$. The $V_0$-module structure on $V_{1/2}$ is real (Jordan multiplication operators are self-adjoint, hence have real eigenvalues, hence $L_a^2 \neq -\mathrm{Id}$). The complexification of the GNS representation space of $V_0$ is trivial and non-canonical.

SELF-CRITIQUE CHECKPOINT (Sub-route b):
1. SIGN CHECK: Self-adjoint operators have real eigenvalues, hence $L_a^2$ has non-negative eigenvalues. The argument that $L_a^2 \neq -\mathrm{Id}$ is correct.
2. FACTOR CHECK: $\dim(V_{10}) = 10$, representation space $\mathbb{R}^{16} = \mathbb{R}^{2^4}$. Correct.
3. CONVENTION CHECK: Jordan product $\circ = (1/2)(ab+ba)$, Peirce rules standard. $\checkmark$
4. DIMENSION CHECK: $V_0$ is 10-dimensional, $V_{1/2}$ is 16-dimensional, representation in $M_{16}(\mathbb{R})$. All consistent.

### 1.4 Sub-route (c): Tensor Product Approach

**Attempt:** Consider forming $H_\omega \otimes_{\mathbb{R}} V_{1/2}$ where $H_\omega$ is the observer's GNS Hilbert space.

The observer is $M_n(\mathbb{C})^{sa}$ with GNS triple $(H_\omega, \pi_\omega, \Omega_\omega)$. For a faithful state $\omega$ on $M_n(\mathbb{C})$:
$$H_\omega \cong \mathbb{C}^{n^2}$$
(the GNS of a faithful state on $M_n(\mathbb{C})$ via $\omega(a) = \mathrm{Tr}(\rho a)$ with $\rho > 0$ gives $H_\omega = M_n(\mathbb{C})$ with inner product $\langle a, b \rangle = \mathrm{Tr}(\rho a^* b)$, which is $\mathbb{C}^{n^2}$ as a Hilbert space).

For a pure state $\omega = |\psi\rangle\langle\psi|$:
$$H_\omega \cong \mathbb{C}^n$$

In either case, $H_\omega$ is a complex Hilbert space.

**Forming $H_\omega \otimes_\mathbb{R} V_{1/2}$:**

$$\dim_\mathbb{C}(H_\omega \otimes_\mathbb{R} V_{1/2}) = ?$$

This is not well-defined as a complex tensor product. The correct construction is:
$$H_\omega \otimes_\mathbb{R} V_{1/2}$$
which is a real vector space of dimension $2n^2 \cdot 16$ (for faithful state) or $2n \cdot 16$ (for pure state), since $\dim_\mathbb{R}(H_\omega) = 2n^2$ or $2n$.

To get a complex vector space, we can view $V_{1/2}$ as sitting inside $V_{1/2} \otimes_\mathbb{R} \mathbb{C}$, giving:
$$H_\omega \otimes_\mathbb{C} (V_{1/2} \otimes_\mathbb{R} \mathbb{C}) = H_\omega \otimes_\mathbb{C} V_{1/2}^\mathbb{C}$$

But this **assumes** the complexification of $V_{1/2}$. It does not derive it from the GNS structure. The tensor product with $H_\omega$ simply enlarges the space; it does not provide a canonical complex structure on $V_{1/2}$.

**Alternative: canonical embedding $V_{1/2} \hookrightarrow H_\omega$.**

For this, we need a canonical $\mathbb{R}$-linear injection $\iota : V_{1/2} \to H_\omega$ such that the $\mathbb{C}$-span of $\iota(V_{1/2})$ in $H_\omega$ provides the complexification.

The only canonical map from $V_{1/2}$ to any space associated with the observer comes from the Peirce interface: the observer acts on $V_{1/2}$ via:
$$V_1 \circ V_{1/2} \subset V_{1/2}$$

But $V_1 = \mathbb{R} \cdot E_{11}$, so for $\alpha E_{11} \in V_1$ and $v \in V_{1/2}$:
$$(\alpha E_{11}) \circ v = \frac{\alpha}{2} v$$

This is scalar multiplication by $\alpha/2$. The action is trivial (proportional to the identity on $V_{1/2}$). It carries **no information** about the complex structure of the observer. The map $v \mapsto E_{11} \circ v = \frac{1}{2}v$ is just $\frac{1}{2}\mathrm{Id}_{V_{1/2}}$, not an embedding into $H_\omega$.

**Conclusion (Sub-route c):** The tensor product approach either assumes complexification (defeating the purpose) or provides only a trivial embedding (scalar multiplication). There is no canonical map $V_{1/2} \to H_\omega$ arising from the Peirce interface, because $V_1 = \mathbb{R}$ acts on $V_{1/2}$ by scalar multiplication only.

### 1.5 Summary of Task 1

| Sub-route | Construction | Complex structure on $V_{1/2}$? | Why? |
|:---:|:---|:---:|:---|
| (a) Direct GNS of $h_3(\mathbb{O})$ | JB-algebra GNS | **No** | $h_3(\mathbb{O})$ is exceptional; GNS gives real $\mathbb{R}^{27}$, not complex |
| (b) GNS of Peirce components | $V_0 = h_2(\mathbb{O})$ JC-rep | **No** | Jordan multiplication operators are self-adjoint ($L_a^2 \neq -\mathrm{Id}$); complexification of rep space is trivial |
| (c) Tensor with observer $H_\omega$ | $H_\omega \otimes V_{1/2}$ | **No** (canonical) | $V_1 = \mathbb{R}$ acts by scalar mult; no canonical $V_{1/2} \to H_\omega$ embedding |

**Core obstacle:** The GNS construction for $h_3(\mathbb{O})$ does not produce a complex Hilbert space (because $h_3(\mathbb{O})$ is not a JC-algebra). The observer's GNS space $H_\omega$ is complex, but the Peirce interface between $V_1$ and $V_{1/2}$ transmits only scalar information (because $V_1 = \mathbb{R}$), insufficient to induce a complex structure on $V_{1/2}$.

---

## Task 2: Does the GNS Construction Canonically Induce Complexification of V_{1/2}?

### 2.1 Precise Statement of the Question

**Route 3 asks:** Does the GNS representation of $h_3(\mathbb{O})$ on a complex Hilbert space $H_\omega$ (from an observer state $\omega$) canonically induce $V_{1/2} \otimes_\mathbb{R} \mathbb{C}$?

For "canonically induce" to hold, we need a canonical $\mathbb{R}$-linear embedding $\iota : V_{1/2} \to H$ into some complex Hilbert space $H$ arising from the GNS construction such that:

(i) $\iota$ is $\mathbb{R}$-linear and injective

(ii) The $\mathbb{C}$-span of $\iota(V_{1/2})$ in $H$ is isomorphic to $V_{1/2} \otimes_\mathbb{R} \mathbb{C}$ as a $\mathrm{Spin}(9)$-representation

(iii) The embedding $\iota$ is **canonical** -- it depends only on the algebraic structure of $h_3(\mathbb{O})$ and the Peirce decomposition, not on the choice of state $\omega$ or any auxiliary data

### 2.2 The Obstruction Theorem

**Theorem (Route 3 Obstruction).** The GNS construction does NOT canonically induce the complexification $V_{1/2} \otimes_\mathbb{R} \mathbb{C}$. More precisely:

(A) The direct GNS of $h_3(\mathbb{O})$ produces no complex Hilbert space at all.

(B) The observer-mediated GNS (through the Peirce interface) produces only scalar information about $V_{1/2}$.

(C) Any complexification obtained through the GNS route requires a non-canonical choice (state-dependent or structure-dependent) beyond what the GNS construction alone provides.

**Proof.**

**(A) No complex Hilbert space from direct GNS.**

By the Alfsen-Shultz classification (Section 1.1 above), $h_3(\mathbb{O})$ is a purely exceptional JB-algebra. The JB-algebra GNS construction (Alfsen-Shultz 2001, Ch. 11) for a faithful state $\omega$ produces:

$$H_\omega = (h_3(\mathbb{O}), \langle \cdot, \cdot \rangle_\omega) \cong \mathbb{R}^{27}$$

with inner product $\langle a, b \rangle_\omega = \omega(a \circ b)$. This is a real inner product space. There is no canonical complex structure on $\mathbb{R}^{27}$ (27 is odd, so $\mathbb{R}^{27}$ does not admit a complex structure at all -- a complex vector space must have even real dimension).

% IDENTITY_CLAIM: R^{27} admits no complex structure (odd dimension)
% IDENTITY_SOURCE: derived (a complex vector space over C has dim_R = 2 * dim_C, hence even)
% IDENTITY_VERIFIED: 27 is odd. A complex structure J : R^n -> R^n with J^2 = -Id requires det(J)^2 = det(-Id) = (-1)^n, which for n odd gives det(J)^2 = -1 < 0, contradicting det(J) in R. Verified.

Therefore: the direct GNS of $h_3(\mathbb{O})$ gives $\mathbb{R}^{27}$, which cannot be complexified as a whole (odd dimension). Even if we restrict to the $V_{1/2}$ component (16-dimensional, even), the GNS inner product on $V_{1/2}$ is real and carries no canonical complex structure.

**(B) Observer-mediated GNS transmits only scalar information.**

The observer is $M_n(\mathbb{C})^{sa}$, which sits in the Peirce $V_1$ slot. But $V_1 = \mathbb{R} \cdot E_{11} \cong \mathbb{R}$: the observer occupies a 1-dimensional real subspace of $h_3(\mathbb{O})$.

The Peirce multiplication $V_1 \circ V_{1/2} \subset V_{1/2}$ gives, for $\alpha E_{11} \in V_1$ and $v \in V_{1/2}$:

$$(\alpha E_{11}) \circ v = \frac{\alpha}{2} v$$

This is scalar multiplication by $\alpha/2$. The entire content of the $V_1$-action on $V_{1/2}$ is the map:

$$\mathbb{R} \to \mathrm{End}_\mathbb{R}(V_{1/2}), \quad \alpha \mapsto \frac{\alpha}{2} \mathrm{Id}_{V_{1/2}}$$

This is the trivial representation. It carries:
- No information about the internal structure of $V_{1/2}$
- No preferred direction or decomposition
- No complex structure (scalar multiplication by a real number cannot produce $J^2 = -\mathrm{Id}$)
- No connection to the observer's complex Hilbert space $H_\omega$

**The fundamental reason this fails:** The observer's rich C*-algebraic structure (with complex scalars, *-involution, positivity, etc.) lives in $M_n(\mathbb{C})^{sa}$, but this is an **external** algebra. Its intersection with $h_3(\mathbb{O})$ through the Peirce decomposition is only $V_1 = \mathbb{R}$. The 1-dimensional "port" between the observer and $V_{1/2}$ is too narrow to transmit the observer's complex structure.

To say this more precisely: the GNS construction of $M_n(\mathbb{C})^{sa}$ produces $H_\omega \cong \mathbb{C}^{n^2}$ (for a faithful state). But the only canonical map from the observer's algebraic action to $V_{1/2}$ is through the Peirce product, which passes through $V_1 = \mathbb{R}$. This "bottleneck" kills the complex structure.

**(C) Any complexification requires a non-canonical choice.**

To complexify $V_{1/2}$, one must choose a complex structure $J : V_{1/2} \to V_{1/2}$ with $J^2 = -\mathrm{Id}$. The space of such complex structures on $\mathbb{R}^{16}$ is:

$$\mathcal{J}(V_{1/2}) = \mathrm{GL}(16, \mathbb{R}) / \mathrm{GL}(8, \mathbb{C})$$

This is a non-trivial manifold. For the complexification to be canonical (in the GNS sense), $J$ must be determined uniquely by the GNS data. But:

- The GNS of $h_3(\mathbb{O})$ (sub-route a) gives $\mathbb{R}^{27}$, which contains $V_{1/2}$ as a real subspace with no preferred $J$.
- The GNS of $V_0$ (sub-route b) acts on $V_{1/2}$ through Jordan multiplication, which is self-adjoint and hence cannot produce $J$ (self-adjoint endomorphisms satisfy $J^2 \geq 0$, not $J^2 = -\mathrm{Id}$).
- The observer's GNS $H_\omega$ (sub-route c) is disconnected from $V_{1/2}$ except through scalar multiplication.

The only way to get a complex structure on $V_{1/2}$ from this data would be to choose additional input beyond the GNS construction -- for example:
- Choosing a unit imaginary octonion $u \in S^6 \subset \mathrm{Im}(\mathbb{O})$ (this is Route 4, not Route 3)
- Choosing a complex structure on $\mathbb{O}$ compatible with $u$ (this determines $J$ on $V_{1/2} = \mathbb{O}^2$ via $J(x_2, x_3) = (ux_2, ux_3)$)
- Choosing an embedding $\mathrm{Spin}(9) \hookrightarrow \mathrm{Spin}(10)$ (which requires choosing a 10th direction)

Each of these choices is external to the GNS construction. $\square$

SELF-CRITIQUE CHECKPOINT (Theorem):
1. SIGN CHECK: $J^2 = -\mathrm{Id}$ (complex structure condition). Self-adjoint $L_a$ satisfies $L_a^2 \geq 0$ (non-negative spectrum). These are opposite signs. Correct distinction.
2. FACTOR CHECK: dim(V_1) = 1, scalar action $\alpha/2$. dim(V_{1/2}) = 16 (even, so complex structure possible in principle). GL(16,R)/GL(8,C) is the correct coset for complex structures on R^{16}.
3. CONVENTION CHECK: Jordan product, Peirce eigenvalues, JB/JC distinction all consistent with established conventions.
4. DIMENSION CHECK: R^{27} (odd, no complex structure). R^{16} (even, complex structures exist but none is canonical). All consistent.

### 2.3 Precise Characterization of the Failure Mode

**What the GNS route fails to provide:** A canonical $\mathbb{R}$-linear embedding $\iota : V_{1/2} \to H$ into a complex Hilbert space $H$ that arises from the GNS data alone.

**Why it fails:** Three independent obstructions:

1. **Exceptional obstruction:** $h_3(\mathbb{O})$ has no faithful Hilbert space representation. The GNS produces $\mathbb{R}^{27}$, not $\mathbb{C}^k$ for any $k$.

2. **Parity obstruction:** $\dim_\mathbb{R}(h_3(\mathbb{O})) = 27$ is odd, so even the GNS real Hilbert space $\mathbb{R}^{27}$ cannot carry a complex structure.

3. **Bottleneck obstruction:** The Peirce interface $V_1 \circ V_{1/2} \subset V_{1/2}$ transmits only scalar information ($V_1 = \mathbb{R}$), so the observer's C*-nature cannot be transmitted to $V_{1/2}$ through this channel.

### 2.4 What Additional Input Would Fix Route 3

For the GNS route to succeed, one would need at least one of:

**(i) A larger "port" between observer and interface.** If $V_1$ were larger than $\mathbb{R}$ -- say, if $V_1 \cong M_k(\mathbb{C})^{sa}$ for some $k > 0$ -- then the observer's action on $V_{1/2}$ could transmit complex structure. But for a rank-1 idempotent $e = E_{11}$ in $h_3(\mathbb{O})$, $V_1 = \mathbb{R}$ is forced by the definition of Peirce decomposition.

If instead one used a rank-2 idempotent $f = E_{11} + E_{22}$ (or a rank-2 projection in the Peirce sense), then $V_1(f)$ would be larger. But the observer was defined to use a rank-1 idempotent (Gap B1), and changing this would fundamentally alter the setup.

**(ii) A complex structure on $\mathbb{O}$ as additional input.** Choosing $u \in S^6 \subset \mathrm{Im}(\mathbb{O})$ provides a complex structure $J_u$ on $\mathbb{O}$ (via $J_u(x) = ux$), which induces a complex structure on $V_{1/2} = \mathbb{O}^2$ (via $J_u(x_2, x_3) = (ux_2, ux_3)$). This is Route 4 (Cl(6) route), not Route 3.

**(iii) The structure group upgrade $F_4 \to E_6$.** If we allow complexification of the full algebra $h_3(\mathbb{O}) \to h_3^\mathbb{C}(\mathbb{O})$, then $E_6$ acts and $\mathrm{Spin}(10) \subset E_6$ provides the complex structure on $V_{1/2}^\mathbb{C}$. But this uses Route 1 (algebraic complexification) or Route 2 (observer map), not Route 3 (GNS).

### 2.5 Comparison with Routes 1 and 2

| Route | Mechanism | Provides complexification? | Canonical? |
|:---:|:---|:---:|:---:|
| Route 1 (algebraic) | $h_3(\mathbb{O}) \otimes_\mathbb{R} \mathbb{C}$, extension of scalars | Yes | Yes (universal property) |
| Route 2 (observer map) | C*-observer's $\mathbb{C}$-linearity forces $V \otimes_\mathbb{R} \mathbb{C}$ | Yes | Yes (from C*-nature) |
| **Route 3 (GNS)** | GNS representation on complex $H_\omega$ | **No** | N/A (fails) |
| Route 4 (Cl(6)) | Complex structure from $u \in S^6 \subset \mathrm{Im}(\mathbb{O})$ | Yes | Conditional on $u$ |

**Route 3 is the weakest of the four routes** because it tries to use the GNS representation -- but $h_3(\mathbb{O})$'s exceptional nature blocks the only mechanism (faithful Hilbert space representation) that could link $V_{1/2}$ to a complex Hilbert space canonically.

### 2.6 Forbidden Proxy Check

- **fp-wrong-algebra:** We worked specifically with $h_3(\mathbb{O})$, not a different algebra. The exceptional status of $h_3(\mathbb{O})$ is central to the obstruction. $\checkmark$
- **fp-no-canonical:** We identified precisely that the GNS fails to provide canonical complexification. The obstruction is about canonicity (state-independent, structure-only). $\checkmark$
- **fp-assume-spin10:** We did not assume $\mathrm{Spin}(10)$. We showed that the GNS route cannot derive $\mathrm{Spin}(10)$ because it cannot even produce a complex Hilbert space for $V_{1/2}$. $\checkmark$

### 2.7 Decisive Outcome

**Route 3 produces a precise obstruction statement:**

$$\boxed{\text{The GNS construction does NOT canonically induce } V_{1/2} \otimes_\mathbb{R} \mathbb{C}.}$$

**Obstruction:** $h_3(\mathbb{O})$ is exceptional (not a JC-algebra), so its GNS produces a real Hilbert space $\mathbb{R}^{27}$ (odd dimension, no complex structure). The observer's complex GNS space $H_\omega$ is disconnected from $V_{1/2}$ by the rank-1 Peirce bottleneck ($V_1 = \mathbb{R}$, scalar action only).

**What would fix it:** Either a larger Peirce port ($V_1 \supsetneq \mathbb{R}$, requiring higher-rank idempotent), an external complex structure on $\mathbb{O}$ (Route 4), or algebraic complexification of the full algebra (Route 1/2).

**Status within the four-routes framework:** Route 3 is eliminated as an independent complexification mechanism. The complexification established in prior work (Phase 18) uses Route 2 (C*-observer's $\mathbb{C}$-linearity), which does not go through GNS but rather through the universal property of extension of scalars. Route 3's failure is consistent with and reinforces the conclusion that complexification comes from the observer's C*-nature (Route 2), not from the representation theory of $h_3(\mathbb{O})$ (Route 3).

---
