# Gap C Closure Theorem

% ASSERT_CONVENTION: natural_units=dimensionless, generator_normalization=T_a=(1/2)gamma_a, clifford_signature=Cl(9,0), commutation_convention=[A,B]=AB-BA;{A,B}=AB+BA, sequential_product=sqrt(a)b*sqrt(a), sqrt_branch=principal

**Phase:** 44-gap-c-theorem-assembly, Plan 01
**Date:** 2026-04-05
**Status:** Complete
**Type:** Assembly (no new mathematics)

---

## 1. Hypotheses and Setup

**(H1) Universe algebra.** The universe algebra is $\mathfrak{h}_3(\mathbb{O})$, the exceptional Jordan algebra of $3 \times 3$ Hermitian octonionic matrices (Gap A; Paper 7, Remark 2.1 [complexification.tex]).

**(H2) Observer selection.** The observer selects a rank-1 idempotent $e = E_{11} \in \mathfrak{h}_3(\mathbb{O})$, inducing the Peirce decomposition $\mathfrak{h}_3(\mathbb{O}) = V_1 \oplus V_{1/2} \oplus V_0$ with $V_{1/2} \cong \mathbb{R}^{16}$ (Gap B1; Paper 7, Sec. 2.2 [complexification.tex, Eq. (2.5)--(2.8)]).

**(H3) Observer type.** The observer's state space is $M_n(\mathbb{C})^{\mathrm{sa}}$ for some $n \ge 2$, with the Luders sequential product $a\,\&\,b = \sqrt{a}\,b\,\sqrt{a}$ (Paper 5, Theorem 3.1 [type-exclusion.tex, lines 205--246]).

**Clifford generators.** The Peirce multiplication operators $T_a : V_{1/2} \to V_{1/2}$ ($a = 1, \ldots, 9$) satisfy $\{T_a, T_b\} = \tfrac{1}{2}\delta_{ab}I_{16}$ and generate $\mathrm{Cl}(9,0)|_{V_{1/2}} = M_{16}(\mathbb{R})$ (Phase 29).

---

## 2. Theorem Statement

**Theorem (Gap C Closure --- Observer-Induced Complexification).**
*Under hypotheses H1--H3, the following chain holds:*

1. *The C\*-observer possesses the complex functional calculus on all self-adjoint elements, extending the Gudder--Greechie sequential product beyond the effect domain.*

2. *Applying this to the Clifford generators $T_a$ (spectrum $\{+1/2, -1/2\}$) yields $\sqrt{T_a}\,T_b\,\sqrt{T_a} = (i/2)\,T_b$ for all 72 anticommuting pairs.*

3. *The $\mathbb{C}$-linear closure of the sequential product algebra is $M_{16}(\mathbb{C})$, identified with the $\hat\omega = +1$ summand of $\mathrm{Cl}(9,\mathbb{C}) = M_{16}(\mathbb{C}) \oplus M_{16}(\mathbb{C})$.*

4. *The spinor module complexifies: $V_{1/2}^{\mathbb{C}} = S_9 \otimes_\mathbb{R} \mathbb{C} \cong S_{10}^+$ (positive-chirality Weyl spinor of $\mathrm{Spin}(10)$).*

5. *$\mathrm{Spin}(9)$ extends to $\mathrm{Spin}(10)$: the complexified module $S_9^{\mathbb{C}}$ is the restriction of $S_{10}^+$ to $\mathrm{Spin}(9)$, uniquely by multiplicity-free branching.*

6. *$F_4$ extends to $E_6$: $\mathrm{Aut}(\mathfrak{h}_3(\mathbb{O})) = F_4$ extends to $\mathrm{Str}_0(\mathfrak{h}_3(\mathbb{O}_\mathbb{C})) = E_6$, with $\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16}$ under $\mathrm{Spin}(10)$.*

7. *Given $u \in S^6$ (Gap B2 input), the induced $\mathrm{Cl}(6) \subset \mathrm{Cl}(10)$ and its volume form $\omega_6$ select the LEFT chiral embedding $\mathbf{16} \to (\mathbf{4},\mathbf{2},\mathbf{1}) \oplus (\bar{\mathbf{4}},\mathbf{1},\mathbf{2})$ under Pati--Salam.*

---

## 3. Proof (by citation)

**Step 1.** Paper 5, Theorem 3.1 [type-exclusion.tex, lines 205--246] establishes that the observer is $M_n(\mathbb{C})^{\mathrm{sa}}$ with the Luders product. The complex C\*-algebra $M_n(\mathbb{C})$ admits the continuous functional calculus for self-adjoint elements, accepting $\mathbb{C}$-valued functions on the real spectrum. In particular, the principal-branch square root $\sqrt{\lambda} = i\sqrt{|\lambda|}$ for $\lambda < 0$ is well-defined. This extends the Gudder--Greechie effect-domain sequential product (Rep. Math. Phys. 49:87--111, 2002) to indefinite self-adjoint elements. *Source:* derivations/43-complexification-theorem.md, Section 3 (Extended Sequential Product Proposition).

**Step 2.** Each $T_a$ has spectrum $\{+1/2, -1/2\}$ with eigenvalue $-1/2 < 0$, so $T_a$ is NOT an effect. The observer's complex FC gives $\sqrt{T_a} = (1/\sqrt{2})(P_+ + iP_-)$ where $P_\pm$ are the spectral projections. For anticommuting pairs ($\{T_a, T_b\} = 0$, $a \ne b$), the diagonal blocks $P_\pm T_b P_\pm = 0$ and therefore $\sqrt{T_a}\,T_b\,\sqrt{T_a} = (i/2)\,T_b$. This was proved analytically (Route A, holomorphic FC) and verified computationally for all 72 pairs (NumPy max error $2.23 \times 10^{-16}$; SymPy exact zero residual). *Source:* derivations/43-complexification-theorem.md, Theorem (Section 4); Phase 42 computational verification.

**Step 3.** The 256 even-grade $\mathrm{Cl}(9,0)$ monomials $\{T_S : |S|$ even$\}$ are $\mathbb{R}$-linearly independent in $M_{16}(\mathbb{R})$ (Phase 29). Since $\mathbb{R}$-independence implies $\mathbb{C}$-independence (separating real and imaginary parts), and $\dim_\mathbb{C} M_{16}(\mathbb{C}) = 256$, the $\mathbb{C}$-span equals $M_{16}(\mathbb{C})$. The complex coefficients are physically sourced by Step 2: $\sqrt{T_a}\,T_b\,\sqrt{T_a} = (i/2)\,T_b$ provides $i \cdot (\text{real elements})$. The algebra $M_{16}(\mathbb{C})$ is the $\hat\omega = +1$ summand of $\mathrm{Cl}(9,\mathbb{C}) = M_{16}(\mathbb{C}) \oplus M_{16}(\mathbb{C})$ (Lawson--Michelsohn, Table I.4.3). *Source:* derivations/43-clinear-closure.md, Proposition (Section 1) and Section 2.

**Step 4.** $V_{1/2} = \mathbb{R}^{16}$ is the unique irreducible real $\mathrm{Spin}(9)$ spinor $S_9$ (Lawson--Michelsohn, Ch. I.5). Complexification gives $S_9 \otimes_\mathbb{R} \mathbb{C} = \mathbb{C}^{16}$. The standard branching rule $S_{10}^+|_{\mathrm{Spin}(9)} \cong S_9^{\mathbb{C}}$ identifies $V_{1/2}^{\mathbb{C}} = S_{10}^+$, with chirality fixed by $\hat\omega = +I_{16}$ on $V_{1/2}$ (Phase 43 computational verification). *Source:* derivations/43-clinear-closure.md, Section 3; Lawson--Michelsohn, Ch. I.5.

**Step 5.** The branching $S_{10}^+|_{\mathrm{Spin}(9)} \cong S_9^{\mathbb{C}}$ is multiplicity-free: $S_9^{\mathbb{C}}$ is irreducible under $\mathrm{Spin}(9)$. By Schur's lemma, any $\mathrm{Spin}(10)$-module structure on $S_9^{\mathbb{C}}$ that restricts to the given $\mathrm{Spin}(9)$ action is unique (up to the $S_{10}^+ / S_{10}^-$ choice resolved by Step 4). The existence of the extension is guaranteed: $S_9$ is by construction the restriction of a $\mathrm{Spin}(10)$ Weyl spinor to $\mathrm{Spin}(9) = \mathrm{Stab}_{\mathrm{Spin}(10)}(e_{10})$. *Source:* Paper 7, Remark 2.6 [complexification.tex]; Lawson--Michelsohn, Ch. I.5.

**Step 6.** The complexification of $\mathfrak{h}_3(\mathbb{O})$ gives $\mathfrak{h}_3(\mathbb{O}_\mathbb{C})$ with structure group $E_6 = \mathrm{Str}_0(\mathfrak{h}_3(\mathbb{O}_\mathbb{C}))$, extending $F_4 = \mathrm{Aut}(\mathfrak{h}_3(\mathbb{O}))$. The stabilizer of $E_{11}$ in $E_6$ is $\mathrm{Spin}(10) \times \mathrm{U}(1)$ (dim 46). Under $\mathrm{Spin}(10)$, the 27 decomposes as $\mathbf{27} \to \mathbf{1} \oplus \mathbf{10} \oplus \mathbf{16}$. *Source:* Paper 7, Eqs. (2.17)--(2.18) [complexification.tex]; Baez 2002; Yokota 2009.

**Step 7.** Given $u \in S^6$ (Gap B2), the induced $\mathrm{Cl}(6) \subset \mathrm{Cl}(10)$ has volume form $\omega_6 = \gamma_1 \cdots \gamma_6$ with $\omega_6^2 = -1$. The stabilizer of $\omega_6$ in $\mathrm{Spin}(10)$ is the Pati--Salam group $[\mathrm{SU}(4) \times \mathrm{SU}(2)_L \times \mathrm{SU}(2)_R]/\mathbb{Z}_2$ (dim 21). The $\mathbf{16}$ decomposes as $(\mathbf{4},\mathbf{2},\mathbf{1}) \oplus (\bar{\mathbf{4}},\mathbf{1},\mathbf{2})$, which is the LEFT (chiral) embedding: $\mathrm{SU}(2)_L$ acts only on the first component. *Source:* Paper 7, Proposition 3.3, Eq. (3.12) [chirality.tex].

---

## 4. Compatibility with Impossibility Theorems

**Phase 30, Theorem 1** remains valid: $\mathrm{End}_{\mathrm{Spin}(9)}(S_9) = \mathbb{R}$. There is no $\mathrm{Spin}(9)$-equivariant complex structure $J$ on $V_{1/2}$.

The observer-induced complexification is **non-equivariant**: the complex structure depends on which generator $T_a$ is used in the sequential product (derivations/43-complexification-theorem.md, Section 6). This is consistent with Phase 30 because:

1. The impossibility theorems establish that complexification CANNOT arise from $\mathrm{Cl}(9,0)$ alone.
2. The observer provides **external input** through its C\*-structure ($M_n(\mathbb{C})^{\mathrm{sa}}$, mandated by Paper 5).
3. The sequential product $\sqrt{T_a}\,T_b\,\sqrt{T_a} = (i/2)\,T_b$ is the specific channel through which this input acts.
4. Neither the observer alone nor the Clifford structure alone is sufficient; both are required.

The result COMPLEMENTS the impossibility theorems; it does not circumvent them.

---

## 5. Conditionality Statement

**Steps 1--6** are proved given hypotheses H1--H3. Specifically:
- Steps 1--2 follow from H3 (Paper 5, Theorem 3.1) applied to the Clifford generators from H1--H2.
- Steps 3--4 follow from Steps 1--2 by C-linear span completion and standard representation theory (Lawson--Michelsohn).
- Steps 5--6 follow from Steps 3--4 by multiplicity-free branching and the structure theory of $\mathfrak{h}_3(\mathbb{O}_\mathbb{C})$ (Baez, Yokota).

**Step 7** additionally requires $u \in S^6$ (Gap B2 input), independent of H1--H3.

**Label:** The result is **observer-induced complexification**, not algebraic closure. The complexification requires the observer's C\*-structure; it is not intrinsic to $\mathrm{Cl}(9,0)$.

**Gap C disambiguation.** This theorem addresses **Paper 7 Gap C** (complexification of the Peirce half-space from the C\*-observer). This is distinct from **v10.0 Gap C** (tensoriality of the emergent spacetime geometry via the BW + Raychaudhuri + Lovelock chain, Phases 37--40).
