# Phase 38: Lattice Structure, Frame Stabilizer, and Cubic Assessment

% ASSERT_CONVENTION: natural_units=natural, metric_signature=riemannian,
%   jordan_product=(1/2)(ab+ba),
%   clifford_normalization={T_a,T_b}=(1/2)delta_{ab}I,
%   coupling_convention=J_gt_0_antiferro,
%   v_half_basis=(x2_0..x2_7,x3_0..x3_7)

## 1. Frame Stabilizer Identification

### 1.1 Statement

**Theorem (Frame Stabilizer).** The effective Hamiltonian $H_{\text{eff}} = J \sum_{\langle ij \rangle} \sum_{a=0}^{8} T_a^{(i)} T_a^{(j)}$ has symmetry group $\mathrm{Spin}(9)$, not the full $F_4 = \mathrm{Aut}(\mathfrak{h}_3(\mathbb{O}))$. The frame stabilizer is $\mathrm{Spin}(9)$ (dim 36).

### 1.2 Algebraic Argument (Approach A)

The argument proceeds in four steps:

**Step 1.** $F_4$ acts on the 27-dim Jordan algebra $\mathfrak{h}_3(\mathbb{O})$. The traceless part is 26-dim and carries the smallest nontrivial $F_4$ representation. Under the maximal subgroup $\mathrm{Spin}(9) = \mathrm{Stab}_{F_4}(E_{11})$, the 26-dim decomposes as:

$$
\mathbf{26} \to \mathbf{1} \oplus \mathbf{9} \oplus \mathbf{16}
$$

where $\mathbf{1}$ is the trace part of $V_0$, $\mathbf{9}$ is the vector representation (traceless $V_0$), and $\mathbf{16}$ is the spinor representation $S_9 = V_{1/2}$.

**Step 2.** The Peirce decomposition $\mathfrak{h}_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0$ under the idempotent $E_{11}$ is preserved by $\mathrm{Spin}(9)$ but NOT by the full $F_4$. The 16 generators of $F_4$ outside $\mathrm{Spin}(9)$ correspond to the $\mathbb{OP}^2$ directions and mix $V_0$ with $V_{1/2}$.

**Step 3.** The $T_a$ operators are defined by $T_b(v) = \Pi_{1/2}(b \circ v)$ for $b \in V_0$. The projection $\Pi_{1/2}: \mathfrak{h}_3(\mathbb{O}) \to V_{1/2}$ is $\mathrm{Spin}(9)$-covariant but NOT $F_4$-covariant (since $F_4$ does not preserve the Peirce subspaces).

**Step 4.** Therefore $H_{\text{eff}} = J \sum T_a^{(i)} T_a^{(j)}$, which is constructed from $V_0$-projected operators summed over only the 9 vector components of $\mathrm{Spin}(9)$ (not all 26 components of the $F_4$ representation), is $\mathrm{Spin}(9)$-invariant but NOT $F_4$-invariant.

### 1.3 Computational Verification (Approach B)

**Test:** Krasnov's $J_u$ matrix is a grade-3 element of $\mathrm{Cl}(9,0)$, antisymmetric ($J_u^T = -J_u$), satisfying $J_u^2 = -I_{16}$, and NOT in $\mathrm{spin}(9)$ (which is grade 2). It is a representative of the 16 $F_4$ generators outside $\mathrm{Spin}(9)$.

**Result:**
$$
\|[H_2, J_u^{\text{total}}]\|_F = 24.0, \qquad \frac{\|[H_2, J_u^{\text{total}}]\|_F}{\|H_2\|_F} = 2.0
$$

The commutator is $O(1)$ relative to $H_2$, confirming $H_2$ does NOT commute with generators outside $\mathrm{Spin}(9)$.

**Verification that $J_u \notin \mathrm{spin}(9)$:**
$$
\frac{\|J_u - \mathrm{Proj}_{\mathrm{spin}(9)} J_u\|}{\|J_u\|} = 0.866
$$

$J_u$ has 86.6% of its norm orthogonal to $\mathrm{spin}(9)$ -- it is grade 3 in $\mathrm{Cl}(9,0)$ while $\mathrm{spin}(9)$ generators are grade 2.

### 1.4 Spectral Cross-Check (Approach C)

The 2-site spectrum has multiplicities $\{1, 9, 36, 84, 126\} = \{C(9,k)\}_{k=0}^{4}$, exactly matching $\Lambda^k(V_9)$ irreps of $\mathrm{Spin}(9)$. No pair of these sums to a low-dimensional $F_4$ irrep (the smallest nontrivial $F_4$ irreps have dimensions 26, 52, 273, 324, ...). The 5-fold splitting is fully explained by $\mathrm{Spin}(9)$ without any enhancement to $F_4$.

### 1.5 Cross-Check Against Known $F_4$ Subgroup Structure

$F_4$ maximal subgroups (Baez 2002, Todorov-Drenska 2018):
- $\mathrm{Spin}(9)$ (dim 36) -- our result
- $\mathrm{SU}(3) \times \mathrm{SU}(3)/\mathbb{Z}_3$ (dim 16) -- too small to contain the 36-dim stabilizer
- $\mathrm{Sp}(3) \times \mathrm{SU}(2)$ (dim 24) -- too small

The identified stabilizer $\mathrm{Spin}(9)$ (dim 36) is the unique maximal subgroup of $F_4$ that stabilizes the Peirce decomposition under $E_{11}$. This is consistent.

### 1.6 Conclusion

$$
\boxed{\text{Frame stabilizer} = \mathrm{Spin}(9) \quad (\dim = 36)}
$$

SSB pattern: $F_4 \to \mathrm{Spin}(9)$. Target space: $F_4/\mathrm{Spin}(9) = \mathbb{OP}^2$ (dim 16).

---

## 2. Lattice Structure Resolution

### 2.1 K_3 is On-Site, Not the Physical Lattice

**Step 1.** Each self-modeler's internal algebra is $\mathfrak{h}_3(\mathbb{O})$ (27-dim exceptional Jordan algebra). The Peirce decomposition under $E_{11}$ gives:
$$
\mathfrak{h}_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0, \quad \dim = 1 + 16 + 10 = 27
$$
This is the **on-site** algebraic structure.

**Step 2.** The Peirce graph $K_3$ connects three idempotents $\{E_{11}, E_{22}, E_{33}\}$ via off-diagonal subspaces $V_{12}, V_{13}, V_{23}$. $K_3$ is the complete graph on 3 vertices, describing how components of a **single** $\mathfrak{h}_3(\mathbb{O})$ are related. $K_3$ is NOT a lattice of self-modelers.

**Step 3.** The physical lattice has one node per self-modeler. For a regular lattice in $d$ spatial dimensions, this is $\mathbb{Z}^d$. Each node carries an $\mathfrak{h}_3(\mathbb{O})$ (equivalently, its $V_{1/2} = \mathbb{R}^{16}$ degree of freedom for the bilinear coupling).

**Step 4.** The nearest-neighbor interaction between sites $i$ and $j$ acts on $V_{1/2}^{(i)} \otimes V_{1/2}^{(j)}$ via:
$$
H_{ij} = J \sum_{a=0}^{8} T_a^{(i)} \otimes T_a^{(j)}
$$

### 2.2 Z^d is Bipartite

**Step 5.** The physical lattice $\mathbb{Z}^d$ IS bipartite. Partition into:
- **A-sublattice:** sites $(n_1, \ldots, n_d)$ where $\sum_k n_k$ is even
- **B-sublattice:** sites where $\sum_k n_k$ is odd

Every nearest-neighbor bond connects an A-site to a B-site. This is the standard checkerboard decomposition.

**Step 6.** DLS reflection positivity applies to the physical lattice $\mathbb{Z}^d$, NOT to the internal Peirce graph $K_3$. The $K_3$ non-bipartiteness is irrelevant because $K_3$ describes the internal algebraic structure at each site, not the spatial arrangement of sites.

### 2.3 Conclusion

$$
\boxed{\text{Physical lattice} = \mathbb{Z}^d \text{ (bipartite, DLS-compatible)}}
$$
$$
\boxed{K_3 = \text{on-site Peirce structure, NOT the lattice}}
$$

---

## 3. Cubic det(A) Assessment

### 3.1 The Cubic Invariant

The determinant $\det(A) = abc + 2\mathrm{Re}(x_1 x_2 x_3) - a|x_1|^2 - b|x_2|^2 - c|x_3|^2$ is the unique cubic $F_4$-invariant of $\mathfrak{h}_3(\mathbb{O})$.

### 3.2 RG Scaling Dimension (if it were nonzero)

In the sigma model on $F_4/\mathrm{Spin}(9) = \mathbb{OP}^2$ (16-dim target), the field $\phi$ has engineering dimension $[\phi] = (d-2)/2$ in $d$ spatial dimensions. A cubic term has dimension $3(d-2)/2$. The cubic is relevant if $3(d-2)/2 < d$, i.e., $d < 6$. In $d = 3$: scaling dimension $= 3/2 < 3$, formally **relevant**.

### 3.3 Vanishing on OP^2 (Decisive Argument)

**However, the cubic invariant vanishes identically on the target space $\mathbb{OP}^2$.**

$\mathbb{OP}^2 = \{p \in \mathfrak{h}_3(\mathbb{O}) : p^2 = p, \; \mathrm{Tr}(p) = 1\}$

These are rank-1 projections. For any rank-1 projection $p$:
- $p$ has Jordan eigenvalues $(1, 0, 0)$
- $\det(p) = 1 \cdot 0 \cdot 0 = 0$

Since $F_4$ acts transitively on $\mathbb{OP}^2$ and $\det$ is $F_4$-invariant, $\det(g \cdot E_{11} \cdot g^{-1}) = \det(E_{11}) = 0$ for all $g \in F_4$.

$$
\boxed{\det(\phi) = 0 \quad \forall \phi \in \mathbb{OP}^2}
$$

**This is a geometric constraint, not a symmetry argument.** It holds regardless of whether the ground state is ferromagnetic or antiferromagnetic. The cubic term cannot appear in the nonlinear sigma model action because it vanishes identically on the target manifold.

### 3.4 Note on Ferro vs Antiferro

The original plan anticipated using a sublattice $\mathbb{Z}_2$ symmetry ($A_i \to -A_i$ on one sublattice) to forbid the cubic in the antiferromagnetic case. Since Plan 01 found a **ferromagnetic** ground state, the sublattice symmetry argument does not directly apply (ferromagnets do not have staggered order parameters).

The geometric argument above ($\det = 0$ on $\mathbb{OP}^2$) is **stronger** and applies universally. This is the correct and complete resolution.

---

## 4. Phase 39 Handoff

### 4.1 H_eff Form and Coupling

$$
H_{\text{eff}} = J \sum_{\langle ij \rangle} \sum_{a=0}^{8} T_a^{(i)} \otimes T_a^{(j)}, \quad J > 0
$$

- 9 traceless generators $T_a$ with $\{T_a, T_b\} = \frac{1}{2}\delta_{ab} I_{16}$
- Each site carries $V_{1/2} = \mathbb{R}^{16}$ (spinor rep of $\mathrm{Spin}(9)$)
- Lattice: $\mathbb{Z}^d$ with coordination number $z = 2d$

### 4.2 2-Site Spectrum (from Plan 01)

| Level | $E/J$ | Multiplicity | Irrep | Sector | Casimir |
|-------|-------|-------------|-------|--------|---------|
| 0 | $-7/4$ | 9 | $\Lambda^1(V_9)$ | sym | 1 |
| 1 | $-3/4$ | 84 | $\Lambda^3(V_9)$ | antisym | 3 |
| 2 | $+1/4$ | 126 | $\Lambda^4(V_9)$ | sym | 5 |
| 3 | $+5/4$ | 36 | $\Lambda^2(V_9)$ | antisym | 7 |
| 4 | $+9/4$ | 1 | $\Lambda^0(V_9)$ | sym | 9 |

- Ground state energy: $E_0 = -7/4 \, J$
- Energy gap: $\Delta = J$
- Ground state: $\Lambda^1(V_9)$ (vector rep, dim 9), **FERROMAGNETIC**

### 4.3 Frame Stabilizer

- **Stabilizer:** $\mathrm{Spin}(9)$ (dim 36)
- **SSB pattern:** $F_4 \to \mathrm{Spin}(9)$
- **Target space:** $F_4/\mathrm{Spin}(9) = \mathbb{OP}^2$ (dim 16)
- **Evidence:** Algebraic (Peirce projection breaks $F_4$), computational ($\|[H_2, J_u^{\text{total}}]\| = 24.0$), spectral (multiplicities = $C(9,k)$)

### 4.4 Lattice Structure

- Physical lattice: $\mathbb{Z}^d$ with $\mathfrak{h}_3(\mathbb{O})$ per site
- **Bipartite:** yes (checkerboard sublattices)
- **DLS reflection positivity:** applicable on $\mathbb{Z}^d$
- $K_3$ Peirce graph: on-site algebraic structure, NOT the lattice

### 4.5 Cubic det(A)

- RG scaling dimension in $d = 3$: $3/2$ (formally relevant)
- **Actual coefficient: zero** ($\det = 0$ identically on $\mathbb{OP}^2$)
- The bilinear $H_{\text{eff}}$ is sufficient; no cubic correction needed

### 4.6 Goldstone Mode Counting

- Broken generators: $\dim(F_4) - \dim(\mathrm{Spin}(9)) = 52 - 36 = 16$
- **FERROMAGNETIC ground state -- Type-II Goldstone modes possible**
- The tangent space of $\mathbb{OP}^2$ at the basepoint is $S_9$ (16-dim real spinor)
- $S_9$ is a **real** representation of $\mathrm{Spin}(9)$
- Whether Type-I (16 modes, $\omega \sim |k|$) or Type-II (8 modes, $\omega \sim k^2$) depends on the symplectic structure of $[\mathfrak{m}, \mathfrak{m}]$ evaluated on the ground state
- **Phase 39 must determine:** rank of the 2-form $\omega_{\alpha\beta} = \langle \mathrm{GS}| [Q_\alpha, Q_\beta] |\mathrm{GS}\rangle$

### 4.7 UC1-UC4 Verification Roadmap (from Phase 37)

| Property | Statement | Phase 39 Task |
|----------|-----------|---------------|
| UC1 | Gapless excitations | Goldstone theorem applied to $F_4 \to \mathrm{Spin}(9)$ SSB |
| UC2 | Algebraic correlation decay | Massless Goldstone propagator on $\mathbb{OP}^2$ |
| UC3 | Isotropy | Cubic lattice anisotropy RG-irrelevance (Hasenbusch $\rho \sim 2$) |
| UC4 | OS reflection positivity | DLS on $\mathbb{Z}^d$ (bipartite, confirmed above) |

### 4.8 Key Uncertainties for Phase 39

1. **Goldstone type (I vs II):** Ferro ground state means Type-II is possible. Must compute symplectic form rank.
2. **No F_4 lattice model benchmark:** All validation is internal (Casimir, commutators, dimensions). No literature comparison available.
3. **Spin(9) stabilizer is from Peirce projection:** If a different starting idempotent is used, the stabilizer could differ. $E_{11}$ is canonical (chosen by self-modeler singling out its own state).

---

_Phase: 38-effective-hamiltonian-from-peirce-multiplication, Plan: 02_
_Completed: 2026-03-30_
