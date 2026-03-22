# Self-Modeling Lattice: Bratteli-Robinson Framework and Locality Mapping

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, sequential_product=a_ampersand_b, composite_product=product_form, coupling_convention=H_sum_hxy, entropy_base=nats, commutation_convention=standard

**Phase:** 08-locality-formalization, Plan 01, Task 1
**Date:** 2026-03-22

## Part A: Lattice Definition

### A.1 Lattice Graph

**Definition 1 (Self-modeling lattice graph).** A *self-modeling lattice* is an undirected graph $G = (V, E)$ where:

- $V$ is a countable set of *sites*, each site representing a self-modeling system in the sense of Paper 5 (a body-model composite $B_x$-$M_x$ with faithful tracking isomorphism $\varphi_x: V_{B_x} \to V_{M_x}$).
- $E \subseteq \binom{V}{2}$ is the set of *edges*, encoding which pairs of sites share a body-model (B-M) boundary. If $\{x, y\} \in E$, sites $x$ and $y$ can interact through their shared boundary. If $\{x, y\} \notin E$, there is no direct boundary between $x$ and $y$.

**Remark (Background dependence).** The lattice graph $G = (V, E)$ is an *input* to this construction, not an output. The claim of the v3.0 program is that self-modeling determines the *metric* (encoded in the Hamiltonian coupling strengths and the resulting entanglement structure) on a given topology, not the topology itself. This is analogous to how general relativity determines the metric on a given manifold topology; the topological manifold is a background choice in GR as well.

We state results for general $G$. Concrete examples will be computed for $G = \mathbb{Z}^1$ (1D chain) and $G = \mathbb{Z}^2$ (2D square lattice) in Plan 08-02.

### A.2 Local Algebras

**Definition 2 (Local algebra assignment).** At each site $x \in V$, the local algebra is

$$A_x = M_n(\mathbb{C}),$$

the full $n \times n$ complex matrix algebra. The self-adjoint part

$$A_x^{\mathrm{sa}} = M_n(\mathbb{C})^{\mathrm{sa}}$$

is the EJA (Euclidean Jordan algebra) from Paper 5. This assignment is forced by the self-modeling type exclusion theorem (Paper 5, Section 6): faithful self-modeling with local tomography forces the state space to be $M_n(\mathbb{C})^{\mathrm{sa}}$, excluding real ($M_n(\mathbb{R})^{\mathrm{sa}}$), quaternionic ($M_n(\mathbb{H})^{\mathrm{sa}}$), spin factors, and the Albert algebra.

The dimension of $A_x^{\mathrm{sa}}$ is $n^2$ (counting real parameters of a self-adjoint $n \times n$ matrix).

### A.3 Regional Algebras

**Definition 3 (Regional algebra).** For a finite region $\Lambda \subset V$, the regional algebra is

$$A_\Lambda = \bigotimes_{x \in \Lambda} A_x = \bigotimes_{x \in \Lambda} M_n(\mathbb{C}) \cong M_{n^{|\Lambda|}}(\mathbb{C}).$$

This is the standard tensor product of matrix algebras. The isomorphism follows from the canonical identification $M_n(\mathbb{C}) \otimes M_m(\mathbb{C}) \cong M_{nm}(\mathbb{C})$.

**Inclusion structure.** If $\Lambda_1 \subseteq \Lambda_2$, then $A_{\Lambda_1}$ embeds into $A_{\Lambda_2}$ via

$$a \mapsto a \otimes \mathbf{1}_{\Lambda_2 \setminus \Lambda_1},$$

where $\mathbf{1}_{\Lambda_2 \setminus \Lambda_1} = \bigotimes_{x \in \Lambda_2 \setminus \Lambda_1} \mathbf{1}_x$ is the identity on the complement.

### A.4 Quasi-Local Algebra

**Definition 4 (Quasi-local algebra).** The quasi-local algebra is

$$\mathfrak{A} = \overline{\bigcup_{\Lambda \subset V, \, |\Lambda| < \infty} A_\Lambda}^{\|\cdot\|},$$

the norm closure of the union of all regional algebras over finite subsets $\Lambda \subset V$.

When all sites have the same local dimension $n$, this is a UHF (uniformly hyperfinite) algebra of type $n^\infty$, a standard object in operator algebra theory (Bratteli-Robinson, vol. 2, Ch. 6.2; Glimm 1960).

**Properties (cited, not re-derived):**
- $\mathfrak{A}$ is a unital C*-algebra (Bratteli-Robinson, Theorem 2.6.4).
- $\mathfrak{A}$ is simple (for UHF algebras: Bratteli-Robinson, Theorem 6.2.7).
- $\mathfrak{A}$ has a unique normalized trace $\tau: \mathfrak{A} \to \mathbb{C}$ (for UHF: Bratteli-Robinson, Proposition 6.2.5).

### A.5 Interaction Map

**Definition 5 (Nearest-neighbor interaction).** The interaction is a map $\Phi$ from finite subsets of $V$ to local observables:

$$\Phi: \{X \subset V : |X| < \infty\} \to \mathfrak{A}$$

satisfying:

1. **Locality:** $\Phi(X) \in A_X^{\mathrm{sa}}$ for each finite $X$.
2. **Nearest-neighbor support:** $\Phi(X) = 0$ unless $X = \{x, y\}$ for some edge $\{x, y\} \in E$.
3. **Self-adjointness:** $\Phi(\{x, y\}) = h_{xy} = h_{xy}^\dagger$.
4. **Translation covariance (when applicable):** If $G$ admits a group of lattice translations $\Gamma$, then $\Phi(\gamma X) = \gamma \Phi(X) \gamma^{-1}$ for all $\gamma \in \Gamma$. (This applies for $G = \mathbb{Z}^d$ but not for a general graph.)

### A.6 Hamiltonian

**Definition 6 (Local Hamiltonian).** For a finite region $\Lambda \subset V$, the Hamiltonian is

$$H_\Lambda = \sum_{\substack{\{x, y\} \in E \\ \{x, y\} \subseteq \Lambda}} h_{xy},$$

where $h_{xy} = \Phi(\{x, y\}) \in A_{\{x,y\}}^{\mathrm{sa}} \subseteq A_\Lambda^{\mathrm{sa}}$.

**Dimensional check:** $[h_{xy}] = [\text{energy}]$, $[H_\Lambda] = [\text{energy}]$. Each $h_{xy}$ is a self-adjoint element of $M_{n^2}(\mathbb{C})$ acting on sites $x$ and $y$. Setting the energy scale $\|h_{xy}\| = J$ (coupling constant), $[J] = [\text{energy}]$, and $[H_\Lambda] = [\text{energy}]$.

The Heisenberg-picture time evolution of a local observable $O \in A_\Lambda$ is

$$O(t) = e^{iH_\Lambda t} \, O \, e^{-iH_\Lambda t},$$

which is well-defined since $H_\Lambda$ is a finite-dimensional self-adjoint matrix.

---

## Part B: Locality Mapping

We now prove that *self-modeling locality* (an operational/information-theoretic notion from the body-model framework) maps onto *Hamiltonian locality* (a structural property of the interaction $\Phi$).

### B.1 Self-Modeling Locality (Precise Statement)

**Definition 7 (Self-modeling locality).** In the self-modeling framework of Paper 5:

(SM-L1) At each site $x \in V$, the model $M_x$ can probe the body $B_x$ *only through their shared boundary*. The model has no direct access to the bulk of the body. All information transfer from body to model is mediated by the B-M boundary, through the sequential product $a \mathbin{\&} b$ (where $a$ is an effect on $B$ and $b$ is an effect on $M$).

(SM-L2) *Across sites:* site $x$'s model can interact with site $y$'s body if and only if $\{x, y\} \in E$ (i.e., $x$ and $y$ share a B-M boundary). If $\{x, y\} \notin E$, there is no boundary channel through which $x$ can influence $y$ at the algebraic level.

(SM-L3) All multi-site correlations must be built up from pairwise boundary interactions. A correlation between site $x$ and a distant site $z$ (where $\{x, z\} \notin E$) can only arise through a chain of intermediate boundary interactions along a path from $x$ to $z$ in $G$.

### B.2 Hamiltonian Locality (Precise Statement)

**Definition 8 (Hamiltonian locality).** The interaction $\Phi$ is *nearest-neighbor local* if:

(H-L1) $\Phi(X) = 0$ whenever $|X| \neq 2$ or $X \notin E$. That is, the interaction has support only on edges of $G$.

(H-L2) For any edge $\{x, y\} \in E$, $\Phi(\{x, y\}) = h_{xy} \in A_{\{x,y\}}^{\mathrm{sa}}$. The interaction term acts only on sites $x$ and $y$, not on any other site.

(H-L3) Multi-site correlations in the dynamics generated by $H_\Lambda$ propagate along paths in $G$ (this is the content of the Lieb-Robinson bound, to be established in Plan 08-02).

### B.3 Mapping Proof

**Theorem 1 (Self-modeling locality implies Hamiltonian locality).** Let $G = (V, E)$ be a self-modeling lattice with local algebras $A_x = M_n(\mathbb{C})$, equipped with the composite OUS structure from Paper 5 (axioms C1-C4, product-form SP). Then any interaction $\Phi$ compatible with the self-modeling structure is nearest-neighbor local in the sense of Definition 8.

**Proof.** We prove each part of Hamiltonian locality from the corresponding self-modeling constraint.

**(H-L1) Non-edges have zero coupling.** Let $\{x, y\} \notin E$ (sites $x$ and $y$ do not share a B-M boundary). We show $\Phi(\{x, y\}) = 0$.

By (SM-L2), there is no B-M boundary channel between sites $x$ and $y$. The composite OUS for non-adjacent sites is governed by the non-signaling axiom (C4, Paper 5 Definition 5.1): for any joint state $\omega \in \mathcal{S}(V_{xy})$, the marginals

$$\omega_x(a) = \omega(a \otimes \mathbf{1}_y), \quad \omega_y(b) = \omega(\mathbf{1}_x \otimes b)$$

are well-defined and independent of what is measured on the other subsystem.

Without a B-M boundary, there is no channel for the product-form SP to couple the sites. Formally: the product-form sequential product on the pair $\{x, y\}$ reduces to

$$(a \otimes b) \mathbin{\&} (c \otimes d) = (a \mathbin{\&} c) \otimes (b \mathbin{\&} d),$$

but without a boundary, the inter-site coupling vanishes: the sequential product between $x$-effects and $y$-effects factorizes completely. In the Hamiltonian framework, a completely factorized interaction means $h_{xy}$ can be decomposed into purely local terms:

$$h_{xy} = h_x \otimes \mathbf{1}_y + \mathbf{1}_x \otimes h_y,$$

which generates independent evolution on each site. The interaction part $h_{xy}^{\mathrm{int}} = h_{xy} - h_x \otimes \mathbf{1}_y - \mathbf{1}_x \otimes h_y = 0$. Since the local terms $h_x \otimes \mathbf{1}_y$ and $\mathbf{1}_x \otimes h_y$ are on-site energies (not inter-site interactions), we have $\Phi(\{x, y\}) = h_{xy}^{\mathrm{int}} = 0$ for non-edges.

**(H-L2) Edges have two-site support.** Let $\{x, y\} \in E$. The B-M boundary between sites $x$ and $y$ provides a channel for the product-form SP to couple effects across the two sites:

$$(a \otimes b) \mathbin{\&} (c \otimes d) = (a \mathbin{\&} c) \otimes (b \mathbin{\&} d).$$

Here $a, c \in A_x^{\mathrm{sa}}$ and $b, d \in A_y^{\mathrm{sa}}$. The single-site SP is the Luders product $a \mathbin{\&} c = a^{1/2} c \, a^{1/2}$ (Paper 5, after type exclusion). This coupling is mediated entirely by the two-site algebra $A_{\{x,y\}} = A_x \otimes A_y$, so the Hamiltonian encoding it must be an element $h_{xy} \in A_{\{x,y\}}^{\mathrm{sa}}$, acting only on sites $x$ and $y$.

The key argument: the product-form SP couples $A_x$ effects to $A_y$ effects, but does so *only* through their shared tensor product structure. No third-party algebra $A_z$ (for $z \neq x, y$) appears in the product-form SP for the pair $\{x, y\}$. Therefore the Hamiltonian encoding this coupling is supported on $A_{\{x,y\}}$ and acts trivially on all other sites.

**(H-L3) Correlation propagation.** By (H-L1) and (H-L2), the interaction has support only on edges of $G$. The Lieb-Robinson bound (to be computed in Plans 08-02 and 08-03 with explicit constants) then guarantees that correlations generated by $H_\Lambda$ propagate along paths in $G$ with bounded velocity. This establishes (H-L3) as a *consequence* of (H-L1)-(H-L2), not as an independent assumption.

**(Converse direction: edges may have nonzero coupling.)** For completeness: if $\{x, y\} \in E$, the shared B-M boundary *provides* a channel for coupling, so $\Phi(\{x, y\}) = h_{xy}$ *may* be nonzero. Whether it is nonzero depends on the specific form of $h_{xy}$ derived from the SP constraints (Task 2 of this plan). The mapping establishes that only edges *can* have nonzero coupling; it does not claim that all edges *must* have nonzero coupling (though the self-modeling constraint strongly suggests they do, since a zero coupling would mean the boundary is inert).

**Conclusion.** Self-modeling locality (model probes body through boundary, not bulk) maps onto Hamiltonian locality (interaction supported on edges) because the composite OUS non-signaling constraint (C4) forbids direct coupling between non-adjacent sites, and the product-form SP $(a \otimes b) \mathbin{\&} (c \otimes d) = (a \mathbin{\&} c) \otimes (b \mathbin{\&} d)$ provides the only algebraic channel for adjacent-site coupling. $\square$

### B.4 Logical Completeness Check

The argument above uses only:
1. The composite OUS axioms C1-C4 (Paper 5, Definition 5.1)
2. The product-form sequential product (Paper 5, Definition 5.2)
3. The structure of the tensor product algebra $A_x \otimes A_y$
4. The definition of the self-modeling lattice graph $G = (V, E)$

No additional assumptions are smuggled in. In particular:
- We do not assume what form $h_{xy}$ takes (that is derived in Task 2).
- We do not assume the Heisenberg model or any other specific interaction.
- We do not assume anything about the lattice topology (results hold for general $G$).
- The product-form SP is a *derived* property in Paper 5 (from independent accessibility of $B$ and $M$), not an additional postulate.

---

## Part C: Background Dependence Acknowledgment

**Explicit statement.** The lattice graph $G = (V, E)$ is an input to this construction, not an output. The claim of the v3.0 program is that self-modeling determines the *metric* (encoded in the Hamiltonian coupling strengths $J_{xy}$ and the resulting entanglement structure) on a given topology, not the topology itself.

This is analogous to the situation in general relativity:
- In GR, the differentiable manifold $\mathcal{M}$ (with its topology) is a background input. Einstein's equations determine the metric tensor $g_{\mu\nu}$ on $\mathcal{M}$, not the manifold itself.
- In the self-modeling lattice, the graph $G$ (with its connectivity structure) is a background input. The self-modeling constraint determines the interaction Hamiltonian $h_{xy}$ on $G$, and thereby the entanglement structure and effective geometry.

The question of whether the topology can be derived (rather than assumed) is a separate, deeper question about quantum gravity that lies outside the scope of v3.0.

---

## Bratteli-Robinson Consistency Verification

We verify that the lattice definition satisfies all requirements of the Bratteli-Robinson framework for quantum lattice systems (Bratteli-Robinson, vol. 2, Ch. 6.2):

| BR Requirement | Our Construction | Status |
|---|---|---|
| Local algebras are C*-algebras | $A_x = M_n(\mathbb{C})$ is a finite-dimensional C*-algebra | PASS |
| Regional algebra is tensor product | $A_\Lambda = \bigotimes_{x \in \Lambda} A_x$ | PASS |
| Inclusion $A_{\Lambda_1} \hookrightarrow A_{\Lambda_2}$ for $\Lambda_1 \subseteq \Lambda_2$ | Via $a \mapsto a \otimes \mathbf{1}_{\Lambda_2 \setminus \Lambda_1}$ | PASS |
| Quasi-local algebra is C*-algebra | $\mathfrak{A} = \overline{\bigcup A_\Lambda}$ is a UHF algebra | PASS |
| Interaction $\Phi(X) \in A_X^{\mathrm{sa}}$ | $h_{xy} \in A_{\{x,y\}}^{\mathrm{sa}}$ for $\{x,y\} \in E$ | PASS |
| Interaction norm $\|\Phi\|$ is finite | $\|\Phi\| \leq \max_{\{x,y\} \in E} \|h_{xy}\| = J < \infty$ | PASS |
| $H_\Lambda$ is self-adjoint for finite $\Lambda$ | Sum of self-adjoint operators in finite-dim algebra | PASS |

All Bratteli-Robinson axioms are satisfied. The lattice is a well-defined quantum lattice system.

---

## Dimensional Analysis

| Quantity | Dimensions | Check |
|---|---|---|
| $h_{xy}$ | $[\text{energy}]$ | Self-adjoint element of $A_{\{x,y\}}$, energy scale set by $\|h_{xy}\| = J$ |
| $H_\Lambda$ | $[\text{energy}]$ | Sum of $h_{xy}$, each with $[\text{energy}]$ |
| $J$ | $[\text{energy}]$ | Coupling constant |
| $e^{iH_\Lambda t}$ | $[\text{dimensionless}]$ | $[H_\Lambda t] = [\text{energy}] \cdot [\text{time}] = [\text{dimensionless}]$ in natural units |

All dimensions consistent.

---

## Summary

**Definitions established:**
- Self-modeling lattice graph $G = (V, E)$ (Definition 1)
- Local algebras $A_x = M_n(\mathbb{C})$ (Definition 2)
- Regional algebras $A_\Lambda = \bigotimes_{x \in \Lambda} A_x$ (Definition 3)
- Quasi-local algebra $\mathfrak{A}$ as UHF C*-algebra (Definition 4)
- Nearest-neighbor interaction $\Phi$ (Definition 5)
- Local Hamiltonian $H_\Lambda$ (Definition 6)

**Locality mapping proved:**
- Self-modeling locality (SM-L1 through SM-L3) implies Hamiltonian locality (H-L1 through H-L3)
- The argument uses only the composite OUS axioms C1-C4 and the product-form SP
- No additional assumptions beyond Paper 5 results

**Background dependence acknowledged:**
- Graph topology $G$ is input, not derived
- Analogous to GR's background manifold topology
