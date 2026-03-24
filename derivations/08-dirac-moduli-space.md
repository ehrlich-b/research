# D Moduli Space Parameterization for the Self-Modeling Spectral Triple

% ASSERT_CONVENTION: natural_units=N/A, commutation_convention=[A,B]=AB-BA, inner_product=linear_in_second_argument, opposite_algebra=pi_o(b)=J_pi(b*)_J^{-1}, ko_dimension=6, barrett_iso=v_tensor_w_to_vwT

**References:**
- Barrett 2015, arXiv:1502.05383, Proposition 3.1 (D parameterization for matrix geometries)
- van Suijlekom 2024, NCG and Particle Physics, 2nd ed., Ch. 3-4 (D constraints and block structure)
- Cacic 2009, arXiv:0902.2068 (moduli space theory, orientability failure)
- Chamseddine-Connes 2008, arXiv:0706.3688 (SM has 31-parameter D)
- Phase 13 results: derivations/07-order-zero-condition.md, derivations/07-bimodule-krajewski.md

## Setup

**Algebra.** A = M_n(C) for general n >= 1.

**Hilbert space.** H = M_n(C)_p + M_n(C)_{ap} (particle + antiparticle sectors under Barrett isomorphism), dim(H) = 2n^2.

**Barrett isomorphism:** C^n tensor C^n = M_n(C) via v tensor w -> v w^T.

Under this identification:
- pi(a): X -> aX (left multiplication)
- pi_o(b): X -> Xb (right multiplication)
- P (SWAP): X -> X^T (transpose)
- gamma(X_p, X_{ap}) = (X_p^T, -X_{ap}^T)
- J(X_p, X_{ap}) = (overline{X_{ap}}^T, overline{X_p}^T) (antilinear)

**KO-dimension 6 signs:** J^2 = +1 (epsilon = +1), JD = DJ (epsilon' = +1), J gamma = -gamma J (epsilon'' = -1).

## Step 1: Gamma eigenspaces under Barrett isomorphism

Under P = transpose on M_n(C):
- Eigenvalue +1: symmetric matrices Sym_n(C), dim = n(n+1)/2
- Eigenvalue -1: skew-symmetric matrices Skew_n(C), dim = n(n-1)/2

**Particle sector** (gamma = P = transpose):
- gamma = +1: Sym_n^p, dim = n(n+1)/2
- gamma = -1: Skew_n^p, dim = n(n-1)/2

**Antiparticle sector** (gamma = -P = -transpose):
- gamma = +1: Skew_n^{ap} (since -X^T = X iff X^T = -X), dim = n(n-1)/2
- gamma = -1: Sym_n^{ap} (since -X^T = -X iff X^T = X), dim = n(n+1)/2

**Gamma eigenspace decomposition:**

$$H_+ (\gamma = +1) = \text{Sym}_n^p \oplus \text{Skew}_n^{ap}, \quad \dim = \frac{n(n+1)}{2} + \frac{n(n-1)}{2} = n^2$$

$$H_- (\gamma = -1) = \text{Skew}_n^p \oplus \text{Sym}_n^{ap}, \quad \dim = \frac{n(n-1)}{2} + \frac{n(n+1)}{2} = n^2$$

**Dimension check:** dim(H_+) + dim(H_-) = 2n^2 = dim(H). Correct.

SELF-CRITIQUE CHECKPOINT (Step 1):
1. SIGN CHECK: gamma|_{ap} = -P, so P = +1 -> gamma = -1, P = -1 -> gamma = +1. Two sign inversions. Expected: 2. Actual: 2.
2. FACTOR CHECK: No factors introduced.
3. CONVENTION CHECK: gamma = diag(P, -P) from Phase 13. Barrett iso P = transpose. Consistent.
4. DIMENSION CHECK: n(n+1)/2 + n(n-1)/2 = n^2. Correct.

## Step 2: D gamma = -gamma D forces off-diagonal block form

In the (H_+, H_-) basis, gamma = diag(I_{n^2}, -I_{n^2}). The anticommutation condition D gamma + gamma D = 0 forces D to be off-diagonal:

$$D = \begin{pmatrix} 0 & M^\dagger \\ M & 0 \end{pmatrix}$$

where M: H_+ -> H_- is an n^2 x n^2 complex matrix.

**Self-adjointness:** D = D* is automatic for any M, since:

$$D^* = \begin{pmatrix} 0 & M^\dagger \\ (M^\dagger)^\dagger & 0 \end{pmatrix} = \begin{pmatrix} 0 & M^\dagger \\ M & 0 \end{pmatrix} = D$$

**Free data before J constraint:** M is an arbitrary complex n^2 x n^2 matrix with n^4 complex entries = 2n^4 real parameters.

## Step 3: J in the gamma-eigenspace basis

Since J anticommutes with gamma (J gamma = -gamma J), J maps H_+ <-> H_-. Write J = J_matrix * conj (antilinear) where J_matrix has the block form:

$$J_{\text{matrix}} = \begin{pmatrix} 0 & J_-^{\text{mat}} \\ J_+^{\text{mat}} & 0 \end{pmatrix}$$

with J_+^{mat}: H_+ -> H_- and J_-^{mat}: H_- -> H_+ real matrices.

**From J^2 = I:** J_-^{mat} J_+^{mat} = I_{n^2} and J_+^{mat} J_-^{mat} = I_{n^2}, so J_-^{mat} = (J_+^{mat})^{-1}.

**Explicit J action on the 4 subspaces** (derived from J(X_p, X_{ap}) = (overline{X_{ap}}^T, overline{X_p}^T)):

| Input | J maps to | Sign | In component |
|---|---|---|---|
| S in Sym_n^p (H_+) | overline{S} in Sym_n^{ap} (H_-) | +1 | Sym_n^{ap} |
| A in Skew_n^{ap} (H_+) | -overline{A} in Skew_n^p (H_-) | -1 | Skew_n^p |
| A' in Skew_n^p (H_-) | -overline{A'} in Skew_n^{ap} (H_+) | -1 | Skew_n^{ap} |
| S' in Sym_n^{ap} (H_-) | overline{S'} in Sym_n^p (H_+) | +1 | Sym_n^p |

**Derivation of the J map table:**

For S in Sym_n^p: J(S, 0) = (overline{0}^T, overline{S}^T) = (0, overline{S}). Since S = S^T (symmetric), overline{S}^T = overline{S^T} = overline{S}, which is symmetric. So the output is in Sym_n^{ap} (H_-).

For A in Skew_n^{ap}: J(0, A) = (overline{A}^T, 0). Since A^T = -A (skew), overline{A}^T = overline{A^T} = -overline{A}, which is skew-symmetric. So the output -overline{A} is in Skew_n^p (H_-).

For A' in Skew_n^p: J(A', 0) = (0, overline{A'}^T). Since A'^T = -A', overline{A'}^T = -overline{A'}, skew-symmetric, in Skew_n^{ap} (H_+).

For S' in Sym_n^{ap}: J(0, S') = (overline{S'}^T, 0) = (overline{S'}, 0), symmetric, in Sym_n^p (H_+).

**Verification J^2 = I:** Starting from (S, A) in H_+ = (Sym_p, Skew_{ap}):
- J: (S, A) -> (-overline{A}, overline{S}) in H_- = (Skew_p, Sym_{ap})
- J again: (-overline{A}, overline{S}) -> (overline{overline{S}}, -overline{-overline{A}}) = (S, A). Check.

**J_+^{mat} structure:** In the ordered basis H_+ = (Sym_p, Skew_{ap}) and H_- = (Skew_p, Sym_{ap}), the real-linear part of J_+ maps:

- Sym_p basis vectors to corresponding Sym_{ap} basis vectors (with coefficient +1)
- Skew_{ap} basis vectors to corresponding Skew_p basis vectors (with coefficient -1)

$$J_+^{\text{mat}} = \begin{pmatrix} 0 & -I_a \\ I_s & 0 \end{pmatrix}$$

where s = n(n+1)/2 (dimension of Sym_n) and a = n(n-1)/2 (dimension of Skew_n). The block maps Sym_p (dim s) to Sym_{ap} (dim s) via +I_s, and Skew_{ap} (dim a) to Skew_p (dim a) via -I_a.

**Verification:**
- J_+^{mat} is orthogonal: (J_+^{mat})^T J_+^{mat} = [[0, I_s], [-I_a, 0]][[0, -I_a], [I_s, 0]] = [[I_s, 0], [0, I_a]] = I. Check.
- det(J_+^{mat}) = det(-I_a) * det(I_s) * (-1)^{sa} ... well, it's a permutation-like matrix with some signs, orthogonal with det = +/-1.

SELF-CRITIQUE CHECKPOINT (Step 3):
1. SIGN CHECK: J introduces -1 on Skew components (both directions). 2 minus signs tracked. J^2 = I verified.
2. FACTOR CHECK: No new factors.
3. CONVENTION CHECK: J = antilinear, J_matrix real, from Phase 13. Consistent.
4. DIMENSION CHECK: J_+^{mat} is n^2 x n^2 (maps H_+ to H_- of equal dimension). Correct.

## Step 4: Impose JD = DJ as a constraint on M

**Starting point:** D = [[0, M^dag], [M, 0]] in (H_+, H_-) basis, J antilinear with J_matrix = [[0, J_-^{mat}], [J_+^{mat}, 0]].

**Compute JD and DJ separately.**

For v = (x, 0) with x in H_+:

JD(x, 0) = J(M^dag * 0, M * x) ... wait, D[(x, 0)] = (0, Mx). No: D = [[0, M^dag], [M, 0]], so D applied to column vector [x; 0] gives [M^dag * 0; M * x] = [0; Mx].

JD(x, 0) = J(0, Mx) = J_matrix * conj((0, Mx)) = J_matrix * (0, conj(Mx))
= [J_-^{mat} conj(Mx); 0] = [J_-^{mat} conj(M) conj(x); 0]

DJ(x, 0) = D(J_matrix * conj((x, 0))) = D(J_matrix * (conj(x), 0))
= D(0, J_+^{mat} conj(x)) = [M^dag J_+^{mat} conj(x); 0]

Setting JD = DJ: For all x in H_+, we need:

$$J_-^{\text{mat}} \overline{M} = M^\dagger J_+^{\text{mat}} \quad \text{...(Constraint *)}$$

**Simplification.** Since M^dag = overline{M}^T and J_-^{mat} = (J_+^{mat})^{-1}:

$(J_+^{\text{mat}})^{-1} \overline{M} = \overline{M}^T J_+^{\text{mat}}$

Multiply on left by J_+^{mat}:

$\overline{M} = J_+^{\text{mat}} \overline{M}^T J_+^{\text{mat}}$

Take complex conjugate (J_+^{mat} is real):

$$\boxed{M = J_+^{\text{mat}} \, M^T \, J_+^{\text{mat}}}$$

**This is the fundamental constraint on M.**

**Real/imaginary decomposition.** Write M = M_R + i M_I with M_R, M_I real n^2 x n^2 matrices. The constraint separates:

$$M_R = J_+^{\text{mat}} \, M_R^T \, J_+^{\text{mat}}, \qquad M_I = J_+^{\text{mat}} \, M_I^T \, J_+^{\text{mat}}$$

Both real and imaginary parts satisfy the same constraint.

## Step 5: Dimension of the moduli space

**Define the involution** T: X -> J_+^{mat} X^T J_+^{mat} on the space of real n^2 x n^2 matrices.

**Verify T^2 = I:** T^2(X) = J_+^{mat} (J_+^{mat} X^T J_+^{mat})^T J_+^{mat} = J_+^{mat} (J_+^{mat})^T X (J_+^{mat})^T J_+^{mat}.

Since J_+^{mat} is orthogonal: (J_+^{mat})^T = (J_+^{mat})^{-1} = J_-^{mat}. So:

T^2(X) = J_+^{mat} J_-^{mat} X J_-^{mat} J_+^{mat} = I_{n^2} X I_{n^2} = X. Check: T^2 = I.

**+1 eigenspace dimension.** Since T is an involution on a real vector space of dimension n^4 (space of real n^2 x n^2 matrices):

$$\dim\{X : T(X) = X\} = \frac{n^4 + \text{tr}(T)}{2}$$

where tr(T) is the trace of T as a linear map on the n^4-dimensional space.

**Total moduli space dimension.** Both M_R and M_I satisfy the same constraint:

$$\dim(\text{moduli space}) = 2 \times \frac{n^4 + \text{tr}(T)}{2} = n^4 + \text{tr}(T)$$

**Computing tr(T) using the sub-block structure of J_+^{mat}.**

With J_+^{mat} = [[0, -I_a], [I_s, 0]] where s = n(n+1)/2 and a = n(n-1)/2:

Vectorize: T(X) = J_+ X^T J_+ = J_+ X^T J_+.

Write X as a block matrix matching the (Skew_p, Sym_{ap}) x (Sym_p, Skew_{ap}) structure (recall M: H_+ -> H_-):

$$M = \begin{pmatrix} M_{11} & M_{12} \\ M_{21} & M_{22} \end{pmatrix}$$

where:
- M_{11}: Sym_p (dim s) -> Skew_p (dim a), size a x s
- M_{12}: Skew_{ap} (dim a) -> Skew_p (dim a), size a x a
- M_{21}: Sym_p (dim s) -> Sym_{ap} (dim s), size s x s
- M_{22}: Skew_{ap} (dim a) -> Sym_{ap} (dim s), size s x a

The constraint M = J_+ M^T J_+ with J_+ = [[0, -I_a], [I_s, 0]] gives:

$$\begin{pmatrix} M_{11} & M_{12} \\ M_{21} & M_{22} \end{pmatrix} = \begin{pmatrix} 0 & -I_a \\ I_s & 0 \end{pmatrix} \begin{pmatrix} M_{11}^T & M_{21}^T \\ M_{12}^T & M_{22}^T \end{pmatrix} \begin{pmatrix} 0 & -I_a \\ I_s & 0 \end{pmatrix}$$

Compute RHS step by step:

First: J_+ M^T = [[0, -I_a], [I_s, 0]] [[M_{11}^T, M_{21}^T], [M_{12}^T, M_{22}^T]]
= [[-M_{12}^T, -M_{22}^T], [M_{11}^T, M_{21}^T]]

Then: (J_+ M^T) J_+ = [[-M_{12}^T, -M_{22}^T], [M_{11}^T, M_{21}^T]] [[0, -I_a], [I_s, 0]]
= [[-M_{22}^T I_s, M_{12}^T I_a], [M_{21}^T I_s, -M_{11}^T I_a]]
= [[-M_{22}^T, M_{12}^T], [M_{21}^T, -M_{11}^T]]

Wait, let me redo this more carefully. The first product:

Row 1 of J_+ M^T: [-M_{12}^T, -M_{22}^T]
Row 2 of J_+ M^T: [M_{11}^T, M_{21}^T]

Now multiplying by J_+ on the right:

(Row 1) * J_+ = [-M_{12}^T, -M_{22}^T] * [[0, -I_a], [I_s, 0]]

This is a row vector times a matrix. The (1,1) block:
[-M_{12}^T * 0 + (-M_{22}^T) * I_s] = -M_{22}^T

The (1,2) block:
[-M_{12}^T * (-I_a) + (-M_{22}^T) * 0] = M_{12}^T

Wait, I need to be careful about block dimensions.

M_{12}^T is a x a (transpose of a x a block).
M_{22}^T is a x s (transpose of s x a block).

J_+ = [[0_{a x a}, -I_a], [I_s, 0_{s x s}]]... wait, this doesn't work dimensionally.

Let me re-examine. J_+: H_+ -> H_- where H_+ = (Sym_p[s], Skew_{ap}[a]) and H_- = (Skew_p[a], Sym_{ap}[s]).

J_+ maps a vector of size n^2 = s + a to a vector of size n^2 = a + s.

J_+ = [[0_{a x s}, -I_{a x a}],
        [I_{s x s},  0_{s x a}]]

This maps (v_Sym[s], v_Skew[a]) -> (-v_Skew[a], v_Sym[s]).

Now M: H_+ -> H_- is n^2 x n^2 = (a+s) x (s+a), with sub-blocks:

M = [[M_{11}[a x s], M_{12}[a x a]],
     [M_{21}[s x s], M_{22}[s x a]]]

where:
- M_{11}: Sym_p[s] -> Skew_p[a]
- M_{12}: Skew_{ap}[a] -> Skew_p[a]
- M_{21}: Sym_p[s] -> Sym_{ap}[s]
- M_{22}: Skew_{ap}[a] -> Sym_{ap}[s]

M^T: H_- -> H_+ is (s+a) x (a+s):

M^T = [[M_{11}^T[s x a], M_{21}^T[s x s]],
       [M_{12}^T[a x a], M_{22}^T[a x s]]]

Now compute J_+ M^T: this is (a+s) x (s+a), with:

J_+ M^T = [[0_{a x s}, -I_a], [I_s, 0_{s x a}]] [[M_{11}^T, M_{21}^T], [M_{12}^T, M_{22}^T]]

Block (1,1): 0 * M_{11}^T + (-I_a) * M_{12}^T = -M_{12}^T [a x a]
Block (1,2): 0 * M_{21}^T + (-I_a) * M_{22}^T = -M_{22}^T [a x s]
Block (2,1): I_s * M_{11}^T + 0 * M_{12}^T = M_{11}^T [s x a]
Block (2,2): I_s * M_{21}^T + 0 * M_{22}^T = M_{21}^T [s x s]

So J_+ M^T = [[-M_{12}^T, -M_{22}^T], [M_{11}^T, M_{21}^T]]

Now (J_+ M^T) J_+: multiply (a+s) x (s+a) matrix by (s+a) x (a+s) J_+ matrix.

Wait, the right J_+ should map from H_+ to H_-, but we need (J_+ M^T) * J_+ where the right J_+ acts on the column index. Actually, the constraint is M = J_+ M^T J_+. Here M^T is the matrix transpose, and all three matrices multiply as n^2 x n^2 matrices. But J_+ is n^2 x n^2 (not (a+s) x (s+a)). Let me reconsider.

Actually, M is an n^2 x n^2 matrix (H_+ to H_-), and J_+ is also n^2 x n^2 (H_+ to H_-). So M^T is n^2 x n^2 (H_- to H_+). And J_+ M^T is n^2 x n^2 (H_+ to H_- composed with... no.

J_+ is n^2 x n^2 mapping H_+ to H_-. M^T is n^2 x n^2 mapping H_- to H_+.

So J_+ M^T J_+: first J_+ maps H_+ to H_-, then M^T maps H_- to H_+, then J_+ maps H_+ to H_-.

Wait, that gives a map H_+ -> H_- -> H_+ -> H_-. The product J_+ M^T J_+ is an n^2 x n^2 matrix mapping H_+ to H_-. But M also maps H_+ to H_-. So the constraint M = J_+ M^T J_+ makes dimensional sense.

Actually no. Let me think again. M^T is the ordinary matrix transpose. If M is represented as an n^2 x n^2 matrix with rows indexed by H_- and columns by H_+, then M^T has rows indexed by H_+ and columns indexed by H_-. The product J_+ (n^2 x n^2, H_+ rows -> H_- rows... no.

OK, I think the issue is that M, J_+, etc. are all n^2 x n^2 matrices in some fixed basis of dimension n^2. The "H_+" and "H_-" labels are conceptual; as matrices they're all in the same n^2-dimensional space. The constraint M = J_+ M^T J_+ is just an equation between n^2 x n^2 matrices.

Let me just do the block computation. With J_+ having the sub-block structure:

J_+ = [[0_{a x s}, -I_{a}],
        [I_s,        0_{s x a}]]

where the row blocks are (Skew_p[a], Sym_{ap}[s]) and column blocks are (Sym_p[s], Skew_{ap}[a]).

Actually wait, J_+ maps from H_+ = (Sym_p[s], Skew_{ap}[a]) to H_- = (Skew_p[a], Sym_{ap}[s]). So its columns are indexed by H_+ components and rows by H_- components.

J_+ as matrix with H_- rows and H_+ columns:
- Block (Skew_p, Sym_p): 0_{a x s} [maps Sym_p to Skew_p: zero]
- Block (Skew_p, Skew_{ap}): -I_a [maps Skew_{ap} to Skew_p: -identity]
- Block (Sym_{ap}, Sym_p): I_s [maps Sym_p to Sym_{ap}: +identity]
- Block (Sym_{ap}, Skew_{ap}): 0_{s x a} [maps Skew_{ap} to Sym_{ap}: zero]

M has the same index structure: H_- rows, H_+ columns:
- M_{11}: (Skew_p, Sym_p) block, size a x s
- M_{12}: (Skew_p, Skew_{ap}) block, size a x a
- M_{21}: (Sym_{ap}, Sym_p) block, size s x s
- M_{22}: (Sym_{ap}, Skew_{ap}) block, size s x a

M^T has H_+ rows, H_- columns:
- (M^T)_{11} = M_{11}^T: (Sym_p, Skew_p) block, size s x a
- (M^T)_{12} = M_{21}^T: (Sym_p, Sym_{ap}) block, size s x s
- (M^T)_{21} = M_{12}^T: (Skew_{ap}, Skew_p) block, size a x a
- (M^T)_{22} = M_{22}^T: (Skew_{ap}, Sym_{ap}) block, size a x s

Product J_+ M^T has H_- rows, H_- columns:

Compute block by block. J_+ has H_- rows, H_+ columns. M^T has H_+ rows, H_- columns. Product has H_- rows, H_- columns.

(J_+ M^T)_{Skew_p, Skew_p} = J_+(Skew_p, Sym_p) * M^T(Sym_p, Skew_p) + J_+(Skew_p, Skew_{ap}) * M^T(Skew_{ap}, Skew_p)
= 0 * M_{11}^T + (-I_a) * M_{12}^T = -M_{12}^T [a x a]

(J_+ M^T)_{Skew_p, Sym_{ap}} = 0 * M_{21}^T + (-I_a) * M_{22}^T = -M_{22}^T [a x s]

(J_+ M^T)_{Sym_{ap}, Skew_p} = I_s * M_{11}^T + 0 * M_{12}^T = M_{11}^T [s x a]

(J_+ M^T)_{Sym_{ap}, Sym_{ap}} = I_s * M_{21}^T + 0 * M_{22}^T = M_{21}^T [s x s]

So: J_+ M^T = [[-M_{12}^T, -M_{22}^T], [M_{11}^T, M_{21}^T]] (H_- rows and columns)

Now (J_+ M^T) J_+ has H_- rows, H_+ columns. J_+ has H_- rows, H_+ columns. Hmm wait, J_+ maps H_+ -> H_- so its columns are H_+ and rows are H_-.

The product (J_+ M^T) J_+ requires (J_+ M^T) with H_- columns to multiply J_+ with H_- rows... J_+ has H_+ -> H_-, meaning its matrix has H_- rows and H_+ columns. That doesn't match for right-multiplication.

I think the issue is that in the constraint M = J_+ M^T J_+, the matrices are all treated as abstract n^2 x n^2 matrices in a common n^2-dimensional space, NOT as maps between H_+ and H_- specifically. Let me re-derive more carefully.

If I work in a single n^2-dimensional coordinate system for BOTH H_+ and H_- (after choosing bases), then M, J_+, M^T are all n^2 x n^2 matrices, and the product makes sense. The constraint M = J_+ M^T J_+ is an equation in Mat_{n^2}(R) or Mat_{n^2}(C).

So let me pick an ordered basis:
- For H_+: first list a basis for Sym_p (s vectors), then a basis for Skew_{ap} (a vectors). Total: s + a = n^2 vectors.
- For H_-: first list a basis for Skew_p (a vectors), then a basis for Sym_{ap} (s vectors). Total: a + s = n^2 vectors.

M is represented as an n^2 x n^2 matrix: entry M_{ij} = <(H_- basis vector i), M (H_+ basis vector j)>.

J_+ is represented as an n^2 x n^2 matrix: entry (J_+)_{ij} = <(H_- basis vector i), J_+ (H_+ basis vector j)>.

But for the product J_+ M^T J_+, we need all three matrices to be n^2 x n^2 with compatible multiplication. M^T has entry (M^T)_{ij} = M_{ji}. This is an n^2 x n^2 matrix. J_+ M^T is OK: n^2 x n^2 times n^2 x n^2. Then (J_+ M^T) J_+ is also OK.

The constraint M = J_+ M^T J_+ is an equation between n^2 x n^2 matrices. The sub-block structure I derived above for J_+ M^T is correct, and I just need to multiply once more by J_+ on the right.

(J_+ M^T) is a matrix with H_- row-labeling and H_- column-labeling (since M^T "reverses" the map). Then multiplying by J_+ on the right:

[(J_+ M^T) J_+]_{ij} = sum_k (J_+ M^T)_{ik} (J_+)_{kj}

where i indexes H_- basis, k indexes... hmm, the issue is that (J_+ M^T) has its column index running over H_- (since M^T transposes from H_- columns to H_+ rows... actually this is confusing.

Let me just work with abstract n^2 x n^2 matrices, ignoring the H_+/H_- labeling. Let the first s coordinates correspond to the "symmetric" part and the last a coordinates correspond to the "skew" part.

In H_+ basis: coordinates 1..s are Sym_p, coordinates (s+1)..n^2 are Skew_{ap}.
In H_- basis: coordinates 1..a are Skew_p, coordinates (a+1)..n^2 are Sym_{ap}.

M as a matrix from basis {e_1,...,e_{n^2}} (H_+) to {f_1,...,f_{n^2}} (H_-).

In coordinate form, M is an n^2 x n^2 matrix. M^T is also n^2 x n^2. J_+ is n^2 x n^2.

The product J_+ M^T J_+ is computed as ordinary matrix multiplication of n^2 x n^2 matrices, and the result should equal M.

Let me just compute (J_+ M^T) J_+ using the block form.

J_+ M^T = [[-M_{12}^T, -M_{22}^T], [M_{11}^T, M_{21}^T]]

This is an n^2 x n^2 matrix with the SAME block structure as M: rows indexed by (a, s) and columns indexed by (s, a)... no wait.

Actually, J_+ M^T has: rows from J_+ (indexed by H_- = (a, s)) and columns from M^T. M^T has columns indexed by H_- = (a, s). So J_+ M^T has H_- x H_- indexing.

Now multiply by J_+ on the right: J_+ has H_- x H_+ indexing (rows H_-, columns H_+).

Wait, J_+ as an abstract n^2 x n^2 matrix: its rows are indexed by H_- and columns by H_+. So J_+ has dimensions (H_-) x (H_+) = n^2 x n^2.

(J_+ M^T) has dimensions (H_-) x (H_-) = n^2 x n^2.
J_+ has dimensions (H_-) x (H_+) = n^2 x n^2.

The product (J_+ M^T) * J_+ requires the column index of the first factor to match the row index of the second. First factor columns: H_-. Second factor rows: H_-. Matches! Product dimensions: H_- x H_+ = same as M.

So I can compute. (J_+ M^T) has blocks indexed by (H_- rows, H_- columns) = ((a,s), (a,s)):

Block (a,a): -M_{12}^T
Block (a,s): -M_{22}^T
Block (s,a): M_{11}^T
Block (s,s): M_{21}^T

Now J_+ has blocks ((a,s) rows, (s,a) columns):

Block (a,s): 0_{a x s}
Block (a,a): -I_a
Block (s,s): I_s  (but wait, J_+ column index is (s,a), i.e., Sym_p then Skew_{ap})
Block (s,a): 0_{s x a}

So J_+ in ((a,s) rows, (s,a) columns):
Row block a: [0_{a x s}, -I_a]
Row block s: [I_s, 0_{s x a}]

Now (J_+ M^T) * J_+. The first factor is ((a,s) rows, (a,s) columns), the second is ((a,s) rows, (s,a) columns).

But the column index of the first factor is (a,s) while the row index of the second is also H_- = (a,s). So these multiply.

Result block (a, s) [first row-block of result, first column-block]:
= (-M_{12}^T)(0) + (-M_{22}^T)(I_s) = -M_{22}^T [a x s]

Result block (a, a) [first row-block, second column-block]:
= (-M_{12}^T)(-I_a) + (-M_{22}^T)(0) = M_{12}^T [a x a]

Result block (s, s) [second row-block, first column-block]:
= (M_{11}^T)(0) + (M_{21}^T)(I_s) = M_{21}^T [s x s]

Result block (s, a) [second row-block, second column-block]:
= (M_{11}^T)(-I_a) + (M_{21}^T)(0) = -M_{11}^T [s x a]

So (J_+ M^T J_+) has the block form (with H_- rows, H_+ columns, same as M):

$$(J_+ M^T J_+) = \begin{pmatrix} -M_{22}^T & M_{12}^T \\ M_{21}^T & -M_{11}^T \end{pmatrix}$$

Wait, I need to get the block ordering right. The result maps H_+ = (Sym_p[s], Skew_{ap}[a]) to H_- = (Skew_p[a], Sym_{ap}[s]).

Result column index: H_+ = (s, a). Result row index: H_- = (a, s).

Block (Skew_p[a] row, Sym_p[s] col) = -M_{22}^T  [a x s]
Block (Skew_p[a] row, Skew_{ap}[a] col) = M_{12}^T  [a x a]
Block (Sym_{ap}[s] row, Sym_p[s] col) = M_{21}^T  [s x s]
Block (Sym_{ap}[s] row, Skew_{ap}[a] col) = -M_{11}^T  [s x a]

Recalling M's blocks:
- M_{11}: (Skew_p, Sym_p) = a x s
- M_{12}: (Skew_p, Skew_{ap}) = a x a
- M_{21}: (Sym_{ap}, Sym_p) = s x s
- M_{22}: (Sym_{ap}, Skew_{ap}) = s x a

The constraint M = J_+ M^T J_+ gives:

$$M_{11} = -M_{22}^T, \quad M_{12} = M_{12}^T, \quad M_{21} = M_{21}^T, \quad M_{22} = -M_{11}^T$$

**Check consistency:** M_{11} = -M_{22}^T and M_{22} = -M_{11}^T. From the first: M_{22} = -M_{11}^T. Substituting into the second: -M_{11}^T = -M_{11}^T. Consistent. So these are not independent: M_{22} is determined by M_{11}.

**Summary of free parameters:**

| Sub-block | Constraint | Dimension (real) | Dimension (complex) |
|---|---|---|---|
| M_{11} (a x s) | Free (M_{22} = -M_{11}^T) | 2as | as |
| M_{12} (a x a) | Symmetric: M_{12} = M_{12}^T | 2 * a(a+1)/2 = a(a+1) | a(a+1)/2 complex entries* |
| M_{21} (s x s) | Symmetric: M_{21} = M_{21}^T | 2 * s(s+1)/2 = s(s+1) | s(s+1)/2 complex entries* |
| M_{22} (s x a) | Determined: M_{22} = -M_{11}^T | 0 | 0 |

*Note: "Symmetric" here means M_{12}^T = M_{12} and M_{21}^T = M_{21} as complex matrices. A complex symmetric matrix has n(n+1)/2 independent complex entries = n(n+1) real parameters.

**Total real dimension of moduli space:**

$$\dim = 2as + a(a+1) + s(s+1)$$

where s = n(n+1)/2 and a = n(n-1)/2.

**Simplification:**

$\dim = 2as + a^2 + a + s^2 + s = (a + s)^2 + (a + s) = n^4 + n^2$

since a + s = n^2.

Wait: 2as + a^2 + a + s^2 + s = (a^2 + 2as + s^2) + (a + s) = (a + s)^2 + (a + s) = n^4 + n^2.

$$\boxed{\dim(\text{D moduli space}) = n^2(n^2 + 1)}$$

SELF-CRITIQUE CHECKPOINT (Step 5):
1. SIGN CHECK: M_{11} = -M_{22}^T introduces one sign. M_{12}^T = M_{12} and M_{21}^T = M_{21} are sign-free. Expected: 1. Actual: 1.
2. FACTOR CHECK: Dimension formula n^2(n^2+1). Factor of 2 in 2as from complex (real+imaginary). No spurious factors.
3. CONVENTION CHECK: J_+ block structure from Step 3. Sub-block indices consistently ordered.
4. DIMENSION CHECK: At n=1: s=1, a=0. dim = 0 + 0 + 1(2) = 2. So at n=1, moduli space has dim 2 = 1^2(1+1) = 2. But the plan says n=1 should give dim 1. Let me check this.

**n=1 check:** At n=1, H = C^2, gamma = diag(P, -P) = diag(1, -1) (since P = 1 on C^1 tensor C^1 = C^1). H_+ = C^1 (particle sector, gamma +1), H_- = C^1 (antiparticle sector, gamma -1). M is a 1x1 complex matrix, i.e., a complex number z.

J sends (psi, chi) -> (conj(chi), conj(psi)). J_+ maps H_+ to H_- as: psi -> conj(psi). So J_+^{mat} = 1 (the 1x1 identity; J acts as conjugation).

Constraint: z = J_+ z^T J_+ = 1 * z * 1 = z. This is always satisfied! So all z in C are allowed, giving dim = 2 (real parameters).

But the plan says "moduli space is 1-dimensional" at n=1 with D = [[0,d],[d,0]] for d real. The discrepancy is because the plan's n=1 analysis used a DIFFERENT J convention.

Let me re-examine. At n=1: J(psi, chi) = (P conj(chi), P conj(psi)) = (conj(chi), conj(psi)) since P = I for n=1.

D = [[0, z*], [z, 0]] (where z is complex) in the (H_+, H_-) = (particle, antiparticle) basis.

Actually wait -- at n=1, Sym_1 = C (1-dim), Skew_1 = {0}. So H_+ = Sym_1^p + Skew_1^{ap} = C + 0 = C. H_- = Skew_1^p + Sym_1^{ap} = 0 + C = C.

J_+ maps H_+ = Sym_1^p to H_- = Sym_1^{ap} via: S -> overline{S}. In the 1x1 case, S is just a complex number, and J_+ sends S to conj(S). The matrix part is J_+^{mat} = 1 (identity).

Constraint M = J_+ M^T J_+: M is 1x1 complex, M^T = M, so M = 1 * M * 1 = M. Always true.

So the moduli space at n=1 has dim = 2 (one complex parameter z). D = [[0, z*], [z, 0]] for any z in C.

But does the J constraint actually allow all z? Let me verify directly. JD = DJ with antilinear J:

D = [[0, conj(z)], [z, 0]].

J_matrix = [[0, 1], [1, 0]] (the SWAP part; for n=1, P = 1).

JD: J applied to D(psi, chi) = (conj(z) chi, z psi). J sends (conj(z) chi, z psi) to (P conj(z psi), P conj(conj(z) chi)) = (conj(z) conj(psi), z conj(chi)).

DJ: J(psi, chi) = (conj(chi), conj(psi)). D applied: (conj(z) conj(psi), z conj(chi)).

So JD(psi, chi) = (conj(z) conj(psi), z conj(chi)) = DJ(psi, chi). Yes, JD = DJ for ALL complex z.

So the moduli space at n=1 truly has dim = 2 (real), not 1. The plan's claim that "d real" (dim = 1) was incorrect. The antilinear J with J_+^{mat} = I does NOT force z to be real.

Let me double-check: the plan said "D = [[0,d],[d,0]] with JD = DJ forcing d real. Moduli dim = 1." But I've shown JD = DJ is satisfied for ALL complex z. The discrepancy is likely because the plan assumed a different J convention (perhaps J = sigma_1 * conj with no P). Our J has J(psi, chi) = (conj(chi), conj(psi)) which includes the sector swap AND conjugation. The sector swap undoes the constraint that would otherwise force z real.

**Revised n=1 prediction: dim = 2 (not 1).**

This matches my formula: n^2(n^2 + 1) = 1 * 2 = 2 at n=1.

Let me verify at n=2: n^2(n^2+1) = 4 * 5 = 20.

And n=3: 9 * 10 = 90. n=4: 16 * 17 = 272.

**General formula:** $\dim = n^2(n^2 + 1)$. This is the dimension of the space of complex symmetric n^2 x n^2 matrices (which has dim n^2(n^2+1)/2 complex = n^2(n^2+1) real) -- interesting!

Actually, let me verify this interpretation. The free data is:
- M_{11}: a x s complex matrix, no constraint. 2as real params.
- M_{12}: a x a complex symmetric matrix. a(a+1) real params.
- M_{21}: s x s complex symmetric matrix. s(s+1) real params.
- M_{22}: determined by M_{11}.

Total: 2as + a(a+1) + s(s+1) = 2as + a^2 + a + s^2 + s = (a+s)^2 + (a+s) = n^4 + n^2 = n^2(n^2+1).

This is the same as dim_R(Sym_{n^2}(C)) = n^2(n^2+1)/2 complex dims = n^2(n^2+1) real dims.

So the D moduli space at general n has dimension n^2(n^2+1) real parameters.

**Step 6: Barrett cross-check.**

Barrett 2015 Proposition 3.1 gives D for a matrix geometry H = V tensor M_n(C) as:

D(v tensor m) = sum_I (K_I m + epsilon' m K_I^*) tensor gamma_I v

For KO-dim 6: epsilon' = +1.

Our case: V = C^2, so we need gamma matrices on V = C^2. The grading gamma acts on V = C^2 as some matrix gamma_V (to be identified). The "gamma matrices" gamma_I are products of Clifford algebra generators on V.

For V = C^2 with a single grading operator, the Clifford algebra has generators {gamma_1} with gamma_1^2 = I or gamma_1^2 = -I. For our KO-dim 6 structure, the relevant setup has gamma_V = sigma_3 (say) and one gamma matrix gamma_1 = sigma_1 (or sigma_2).

Barrett's formula gives:
D(v tensor m) = (K_0 m + m K_0^*) tensor v + (K_1 m + m K_1^*) tensor gamma_1 v

For D to anticommute with gamma (D gamma_V = -gamma_V D on V), the K_0 term must satisfy gamma_V * I = -I * gamma_V (which is impossible unless K_0 = 0) and the K_1 term must satisfy gamma_V gamma_1 = gamma_1 gamma_V (which requires {gamma_V, gamma_1} to commute or anticommute appropriately).

Actually, the correct way to use Barrett's formula is: D anticommutes with the total grading, which acts as gamma_V tensor P on the V tensor M_n(C) space. The Barrett formula already encodes this structure through the gamma_I matrices.

For our V = C^2 with gamma_V such that gamma_total = gamma_V tensor P (transpose), the Barrett D has the form:

D(v, X) = (K X + X K^dagger) tensor sigma v

where sigma is an off-diagonal matrix on V = C^2 (to make D anticommute with the diagonal gamma_V). The free parameters are encoded in K in M_n(C).

The number of free real parameters in Barrett's parameterization depends on the constraints from J. For KO-dim 6 with J^2 = +1 and epsilon' = +1, Barrett identifies the free data as K with K arbitrary in M_n(C) (subject to possible Hermiticity or symmetry constraints from J).

However, the detailed Barrett parameterization for our specific J structure is complex to extract without re-deriving Barrett's analysis for our conventions. The numerical verification in Task 2 will provide the definitive cross-check.

**Qualitative cross-check:** Barrett's D for V = C^2 should have approximately n^2 complex parameters (since K is n x n complex). The symmetric structure from JD = DJ would give n^2(n^2+1)/2 complex parameters... but wait, that's much larger than n^2.

Actually, Barrett's K_I are n x n matrices (parameters in M_n(C)), while our M is n^2 x n^2. The Barrett parameterization expresses M in terms of left/right multiplication operators L_{K_I} and R_{K_I^*}, which are specific n^2 x n^2 matrices parameterized by n x n K_I. So Barrett's form is a SUBSPACE of our moduli space, corresponding to D operators that additionally satisfy the first-order condition [[D, pi(a)], pi_o(b)] = 0.

The full moduli space (without the first-order condition) has dim = n^2(n^2+1), while Barrett's parameterization (WITH the first-order condition) would have dim = O(n^2). This is consistent: the first-order condition (Phase 15) will drastically reduce the moduli space.

**Important distinction:** The plan asks to parameterize D satisfying ONLY:
1. D* = D (self-adjointness)
2. D gamma = -gamma D (anticommutation with grading)
3. JD = DJ (commutation with real structure)

The first-order condition [[D, pi(a)], pi_o(b)] = 0 is NOT imposed in this phase (that's Phase 15). Barrett's D form includes the first-order condition, so Barrett gives a SUBSPACE of our moduli space.

## Step 7: Explicit n=2 moduli space basis

At n=2: s = 3, a = 1, n^2 = 4. Predicted dim = 4*5 = 20.

**Free parameters:**
- M_{11}: 1 x 3 complex matrix (no constraint). 6 real params.
- M_{12}: 1 x 1 complex symmetric = 1 complex number. 2 real params.
- M_{21}: 3 x 3 complex symmetric matrix. 12 real params.
- M_{22}: 3 x 1, determined by M_{22} = -M_{11}^T. 0 free params.

Total: 6 + 2 + 12 = 20. Matches.

**Basis construction:** An explicit basis for the 20-dimensional moduli space can be built by:
1. Six basis elements from M_{11} (3 real entries + 3 imaginary entries in the 1x3 block)
2. Two basis elements from M_{12} (1 real + 1 imaginary entry)
3. Twelve basis elements from M_{21} (6 real entries + 6 imaginary entries in the 3x3 symmetric block)

Each basis element M determines D = [[0, M^dag], [M, 0]] in the (H_+, H_-) basis. To convert to the original (particle, antiparticle) basis, apply the inverse of the change-of-basis matrix that diagonalizes gamma.

## Dimension Sequence and Pattern

| n | s = n(n+1)/2 | a = n(n-1)/2 | dim = n^2(n^2+1) |
|---|---|---|---|
| 1 | 1 | 0 | 2 |
| 2 | 3 | 1 | 20 |
| 3 | 6 | 3 | 90 |
| 4 | 10 | 6 | 272 |

The dimension n^2(n^2+1) grows as n^4 + n^2 for large n.

**Comparison with CCM:** The SM spectral triple has 31 parameters for D (Yukawa couplings + Majorana mass). Our n=4 moduli space has dim = 272 BEFORE the first-order condition. The first-order condition (Phase 15) will reduce 272 -> O(n^2) or O(1) depending on the algebra structure. The fact that 272 >> 31 is expected since our moduli space includes ALL D satisfying the 3 axioms, while the SM D additionally satisfies the first-order condition with A_F = C + H + M_3(C).

## Verification Summary

1. **Dimensional consistency:** H_+, H_- each dim n^2; M is n^2 x n^2 complex; D is 2n^2 x 2n^2. PASS.
2. **n=1 limiting case:** dim = 2 (complex parameter z, D = [[0, z*], [z, 0]]). JD = DJ verified explicitly for all z in C. PASS (revised from plan's claim of dim=1).
3. **D = 0 in moduli space:** M = 0 satisfies all constraints. Trivially in the space. PASS.
4. **J antilinearity properly tracked:** JDJ^{-1} involves conj(D). Constraint M = J_+ M^T J_+ derived from conj(M) = J_+ conj(M)^T J_+. PASS.
5. **Barrett cross-check:** Our moduli space has dim n^2(n^2+1); Barrett's D (with first-order condition) is a subspace parameterized by O(n^2) parameters. Consistent: our moduli space is larger because it does not impose the first-order condition. PARTIAL (full cross-check requires Phase 15).
6. **Self-adjointness:** D = [[0, M^dag], [M, 0]] is automatically D* = D for any M. PASS.
7. **Gamma anticommutation:** D is off-diagonal in gamma eigenspace basis, so D gamma + gamma D = 0 by construction. PASS.

## Forbidden Proxy Audit

1. **fp-ad-hoc-d (ad hoc construction):** REJECTED. The moduli space is parameterized SYSTEMATICALLY by deriving all constraints (D* = D, D gamma = -gamma D, JD = DJ) and computing the null space. No specific D is assumed.

2. **fp-skip-moduli-for-candidate (testing candidate before parameterization):** REJECTED. The moduli space is fully parameterized (dim = n^2(n^2+1)) before any candidate testing. Candidate testing is deferred to Plan 14-02.

3. **fp-linear-j (treating J as linear):** REJECTED. The derivation explicitly tracks J's antilinearity: the constraint arises from J_matrix * conj(D) * J_matrix = D, which gives M = J_+ M^T J_+ (involving conjugation). The transpose M^T appears because conj(M^dag) = conj(conj(M)^T) = M^T. All steps in Step 4 track antilinearity.
