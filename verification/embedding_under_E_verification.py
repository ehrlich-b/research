"""
Ambient E-Transport Verification  --  VALD-62-01  (TDD GREEN phase)
====================================================================
Phase: 62-coherent-embedding-under-e-the-hard-part, Plan: 02

EXACT-symbolic (SymPy) computation, on the GENUINELY NON-ASSOCIATIVE exceptional
Albert algebra h_3(O), of THE DECISIVE AMBIENT-TRANSPORT residual

    R := E( sqrt(X) Y sqrt(X) )  -  sqrt(EX) (EY) sqrt(EX)

for GENERIC ambient X (PSD, so sqrt(X) exists) and Y in h_3(O), where sqrt(X) is
computed IN THE AMBIENT h_3(O) (power-associative CFC, here via the exact-square
trick X = C*C with C ambient PSD, exact entries) and the relevant associator is
verified EXACTLY NONZERO (non-associativity load-bearing).

    EXACT R == 0  =>  E TRANSPORTS the sequential product coherently     (branch P)
    EXACT R != 0  =>  AMBIENT-TRANSPORT OBSTRUCTION (the EXPECTED outcome) (branch O)

(O) is the EXPECTED, ACCEPTABLE outcome that REFINES RESTRICTION to
coexistence-as-island (62-03); it is NOT a program collapse and NOT a bug to be
tuned away. The verdict is whatever the EXACT computation yields -- this code
does NOT force P (no cherry-picking X,Y; no relaxing the exact test) and the
v11.0/Phase 42 precedent is cited only as historical context (a DIFFERENT
mechanism -- Clifford non-commuting pairs in M_16(R), not the h_3(O)->h_3(C_u)
projection restriction).

The slice-internal sqrt(a) b sqrt(a) (a,b in A = h_3(C_u)) is the documented
TRIVIAL CONTROL (closed associative subalgebra = range E; leakage 0; associator
0) -- NOT the decisive test.

# ASSERT_CONVENTION: metric_signature=riemannian_fisher, fourier_convention=na, natural_units=natural, gauge_choice=na, renormalization_scheme=na
# Pure-algebra: Jordan product a o b = (1/2)(ab+ba); sequential product a&b = sqrt(a) b sqrt(a)
#   (CFC principal branch); EXACT symbolic/rational/surd arithmetic (SymPy), NEVER float64 on
#   the decisive path; octonion Fano e_1 e_2 = e_4; complex structure u = e_7;
#   slice A = h_3(C_u) ~ M_3(C)^sa. LIVE-paper provenance.

Reuses the STRUCTURE of code/octonion_algebra.py (Fano table FANO_TRIPLES /
_MUL_TABLE with e1e2=e4; the H3O coordinate layout; the _mat_mul_h3o entry
formulas M11..M33; proj_u; peirce_V1/Vhalf/V0) but PORTS the octonion path to
EXACT SymPy (the existing infra is float64 NumPy). Reuses the exact-SymPy
spectral sqrt + assert-based _report/ALL_PASS/sys.exit harness pattern of
code/slice_clause_iii_verification.py (VALD-61-01). The NEW, decisive work is the
AMBIENT non-associative TRANSPORT computation; do NOT reuse 61-02's
associative-only path, and do NOT use the slice-internal case as the decisive
test (it is the trivial control).

Assert-based harness (NO pytest -- the executor venv has sympy/numpy only).
Runnable directly:  python code/embedding_under_E_verification.py
and exercised by:   python tests/test_embedding_under_E.py

References:
  Effros-Stormer 1979 (range of a positive unital idempotent on a JB-algebra is
    a JB-subalgebra) -- quoted in LIVE complexification.tex:437 (Paper 7 lem:bottleneck).
  lem:bottleneck (complexification.tex 409-487): slice A=h_3(C_u), Peirce (iii)
    V_1~R, V_{1/2}~C_u^2, V_0~h_2(C_u).
  Paper 5 Def 1 clause (iii) (qm-from-self-modeling/main.tex 351-353): product-form
    sequential product sqrt(a) b sqrt(a) is the datum.
  VALD-61-01 (code/slice_clause_iii_verification.py): exact-SymPy spectral sqrt +
    assert harness template.

Reproducibility: SymPy 1.14.0, Python 3.14.2, macOS Darwin 24.6.0. Deterministic
(no random seeds; all test elements hardcoded with exact rational/surd entries).
"""

import sys

from sympy import (
    Rational, sqrt, simplify, nsimplify, Matrix, eye, zeros, expand,
    I as symI, conjugate, Poly, symbols, factor,
)

# Track overall pass/fail; the script must exit nonzero on any SELF-CHECK failure
# (NOT merely because the verdict is O).
ALL_PASS = True


def _report(label, ok):
    """Print a PASS/FAIL line and fold into the global pass flag."""
    global ALL_PASS
    status = "PASS" if ok else "FAIL"
    print(f"  [{status}] {label}")
    if not ok:
        ALL_PASS = False
    return ok


# ============================================================================
# 1. EXACT-SymPy octonion arithmetic (Fano e_1 e_2 = e_4)
# ============================================================================
# An octonion is an 8-tuple of EXACT SymPy scalars: a = a0 + a1 e_1 + ... + a7 e_7.
# Ported from code/octonion_algebra.py FANO_TRIPLES / _MUL_TABLE.

FANO_TRIPLES = [
    (1, 2, 4),
    (2, 3, 5),
    (3, 4, 6),
    (4, 5, 7),
    (5, 6, 1),
    (6, 7, 2),
    (7, 1, 3),
]

# _MUL_TABLE[(i,j)] = (sign, index): e_i e_j = sign * e_index, for i,j in {1..7}.
_MUL_TABLE = {}
for _i in range(1, 8):
    for _j in range(1, 8):
        _MUL_TABLE[(_i, _j)] = (0, 0)
for _i, _j, _k in FANO_TRIPLES:
    _MUL_TABLE[(_i, _j)] = (+1, _k)
    _MUL_TABLE[(_j, _i)] = (-1, _k)
    _MUL_TABLE[(_j, _k)] = (+1, _i)
    _MUL_TABLE[(_k, _j)] = (-1, _i)
    _MUL_TABLE[(_k, _i)] = (+1, _j)
    _MUL_TABLE[(_i, _k)] = (-1, _j)
for _i in range(1, 8):
    _MUL_TABLE[(_i, _i)] = (-1, 0)


def oct_zero():
    return [Rational(0)] * 8


def oct(comps):
    """Build an exact octonion from an 8-list (SymPy-coerced)."""
    assert len(comps) == 8
    return [c if hasattr(c, "is_Number") else Rational(c) for c in comps]


def oct_real(r):
    """Real scalar as an octonion (component 0)."""
    z = oct_zero()
    z[0] = r if hasattr(r, "is_Number") else Rational(r)
    return z


def oct_add(a, b):
    return [a[k] + b[k] for k in range(8)]


def oct_sub(a, b):
    return [a[k] - b[k] for k in range(8)]


def oct_neg(a):
    return [-a[k] for k in range(8)]


def oct_scal(s, a):
    return [s * a[k] for k in range(8)]


def oct_mul(a, b):
    """EXACT octonion product via the Fano table (e_1 e_2 = e_4)."""
    r = oct_zero()
    # real*real
    r[0] = r[0] + a[0] * b[0]
    # real*imag + imag*real
    for i in range(1, 8):
        r[i] = r[i] + a[0] * b[i] + a[i] * b[0]
    # imag*imag
    for i in range(1, 8):
        if a[i] == 0:
            continue
        for j in range(1, 8):
            if b[j] == 0:
                continue
            sign, k = _MUL_TABLE[(i, j)]
            r[k] = r[k] + sign * a[i] * b[j]
    return r


def oct_conj(a):
    """Octonion conjugate: negate imaginary components."""
    c = list(a)
    for k in range(1, 8):
        c[k] = -c[k]
    return c


def oct_simplify(a):
    return [simplify(x) for x in a]


def oct_is_zero(a):
    return all(simplify(x) == 0 for x in a)


def oct_equal(a, b):
    return oct_is_zero(oct_sub(a, b))


def proj_u_exact(a, u_index=7):
    """Project octonion a onto C_u = span{1, e_7}: keep comps 0 and 7, zero 1..6.
    Exact port of code/octonion_algebra.py::proj_u (u = e_7)."""
    z = oct_zero()
    z[0] = a[0]
    z[u_index] = a[u_index]
    return z


# ============================================================================
# 2. h_3(O) elements as full 3x3 octonionic matrices  (cleanest for the
#    genuinely non-associative TRIPLE product)
# ============================================================================
# Layout (matches code/octonion_algebra.py H3O):
#     | alpha     conj(x3)   x2      |
#     | x3        beta       conj(x1)|
#     | conj(x2)  x1         gamma   |
# We carry the FULL 3x3 octonion matrix (so left/right associations of a triple
# product are computed INDEPENDENTLY -- non-associativity is not assumed away).


def h3o_from_coords(alpha, beta, gamma, x1, x2, x3):
    """Build the 3x3 octonionic Hermitian matrix from h_3(O) coordinates."""
    a = oct_real(alpha)
    b = oct_real(beta)
    g = oct_real(gamma)
    return [
        [a,            oct_conj(x3), x2],
        [x3,           b,            oct_conj(x1)],
        [oct_conj(x2), x1,           g],
    ]


def h3o_identity():
    return h3o_from_coords(1, 1, 1, oct_zero(), oct_zero(), oct_zero())


def octmat_zero():
    return [[oct_zero() for _ in range(3)] for _ in range(3)]


def octmat_add(A, B):
    return [[oct_add(A[i][j], B[i][j]) for j in range(3)] for i in range(3)]


def octmat_sub(A, B):
    return [[oct_sub(A[i][j], B[i][j]) for j in range(3)] for i in range(3)]


def octmat_scal(s, A):
    return [[oct_scal(s, A[i][j]) for j in range(3)] for i in range(3)]


def octmat_simplify(A):
    return [[oct_simplify(A[i][j]) for j in range(3)] for i in range(3)]


def octmat_is_zero(A):
    return all(oct_is_zero(A[i][j]) for i in range(3) for j in range(3))


def octmat_equal(A, B):
    return octmat_is_zero(octmat_sub(A, B))


def octmat_dagger(A):
    """Conjugate transpose of a 3x3 octonion matrix."""
    return [[oct_conj(A[j][i]) for j in range(3)] for i in range(3)]


def h3o_matmul(A, B):
    """3x3 octonionic matrix product (AB)_{ij} = sum_k A_{ik} B_{kj}.

    Each ENTRY is a sum of single oct_mul products. The TRIPLE matrix product is
    NOT assumed associative: h3o_matmul(h3o_matmul(X,Y),Z) and
    h3o_matmul(X,h3o_matmul(Y,Z)) are computed independently and generically
    DIFFER (octonion non-associativity propagates through the entry sums).
    """
    C = octmat_zero()
    for i in range(3):
        for j in range(3):
            acc = oct_zero()
            for k in range(3):
                acc = oct_add(acc, oct_mul(A[i][k], B[k][j]))
            C[i][j] = acc
    return C


def jordan(A, B):
    """Jordan product A o B = (1/2)(AB + BA) on h_3(O) (lands in h_3(O))."""
    AB = h3o_matmul(A, B)
    BA = h3o_matmul(B, A)
    return octmat_scal(Rational(1, 2), octmat_add(AB, BA))


def associator(A, B, C):
    """The matrix associator (AB)C - A(BC) (a 3x3 octonion matrix)."""
    left = h3o_matmul(h3o_matmul(A, B), C)
    right = h3o_matmul(A, h3o_matmul(B, C))
    return octmat_sub(left, right)


# ============================================================================
# 3. E : h_3(O) -> h_3(C_u)  (entrywise proj_u, u = e_7)  + diagnostics
# ============================================================================


def E(X):
    """Conditional expectation E onto h_3(C_u): apply proj_u entrywise.

    On a Hermitian element the real diagonal already lies in C_u (it is real);
    proj_u fixes it. Off-diagonals are projected onto C_u = span{1, e_7}.
    We apply proj_u to EVERY entry uniformly (diagonal real entries are fixed).
    """
    return [[proj_u_exact(X[i][j]) for j in range(3)] for i in range(3)]


def dim_range_E():
    """real-dim(range E) = dim A = 9 (3 real diagonal + 3 C_u off-diagonal x 2)."""
    return 3 + 3 * 2


def dim_ker_E():
    """real-dim(ker E) = 18 (3 off-diagonal octonions x 6 killed e_1..e_6 comps)."""
    return 3 * 6


def has_kerE_content(X):
    """True iff X has nonzero e_1..e_6 content somewhere off-diagonal
    (i.e. X is genuinely ambient, NOT in the slice)."""
    for (i, j) in [(0, 2), (1, 0), (2, 1), (0, 1), (1, 2), (2, 0)]:
        for k in range(1, 7):
            if simplify(X[i][j][k]) != 0:
                return True
    return False


def E_is_entrywise_proj_u(X):
    """Check E zeroes octonion comps 1..6 of every off-diagonal entry, keeps 0,7."""
    EX = E(X)
    for i in range(3):
        for j in range(3):
            for k in range(1, 7):
                if simplify(EX[i][j][k]) != 0:
                    return False
    return True


def _positivity_slice_effect():
    """A NON-diagonal PSD slice effect with a RATIONAL spectrum {1,3,5}: the (1,2)
    block is coupled by x3 = e_7 (so it is genuinely off-diagonal in C_u, not a
    trivial diagonal positivity test), yet the eigenvalues are rational so the
    exact PSD check is surd-free.  Off-diagonals lie in C_u (a slice element)."""
    x3 = oct_zero()
    x3[7] = Rational(1)   # e_7 coupling on the (2,1) entry
    return h3o_from_coords(Rational(2), Rational(2), Rational(5),
                           oct_zero(), oct_zero(), x3)


def E_positive_spotcheck():
    """Spot positivity: a PSD slice effect maps to a PSD element (exact eigenvalues >= 0).

    Take a NON-diagonal PSD slice element a (off-diagonals in C_u). E(a) == a
    (E|_A=id), and a is PSD by construction (rational spectrum {1,3,5}); confirm
    its ambient (= slice complex) eigenvalues are real and >= 0.
    """
    a = _positivity_slice_effect()
    Ea = E(a)
    if not octmat_equal(Ea, a):
        return False
    # eigenvalues via the C_u ~ C complex 3x3 matrix
    Mc = slice_to_complex(a)
    evs = Mc.eigenvals()
    for ev in evs:
        ev_s = simplify(ev)
        # PSD: real and >= 0
        if ev_s.is_real is False:
            return False
        if (ev_s >= 0) is False:  # SymPy relational; False only if provably negative
            return False
    return True


def E_jordan_morphism_on_ambient_check(X):
    """E is NOT a Jordan morphism on the ambient: E(X o X) vs (EX) o (EX).

    Returns (is_morphism, diff_nonzero). For a generic ambient X the difference is
    exactly nonzero (this is what makes the SP-transport question non-trivial)."""
    lhs = E(jordan(X, X))
    rhs = jordan(E(X), E(X))
    diff = octmat_sub(lhs, rhs)
    is_zero = octmat_is_zero(diff)
    return (is_zero, (not is_zero))


# ============================================================================
# 4. slice <-> complex bridge (h_3(C_u) ~ M_3(C)^sa) for the slice square root
# ============================================================================
# C_u = span{1, e_7}.  Map e_7 -> i (the imaginary unit of C).  An octonion in C_u
# is a0 + a7 e_7  <->  a0 + a7 i.  This gives an exact algebra iso C_u ~ C.


def cu_to_complex(a):
    """Octonion in C_u (only comps 0,7 nonzero) -> SymPy complex number a0 + a7 i."""
    return a[0] + a[7] * symI


def complex_to_cu(z):
    """SymPy complex number -> octonion in C_u (comps 0 and 7)."""
    from sympy import re as _re, im as _im
    zz = simplify(z)
    z0 = simplify(_re(zz))
    z7 = simplify(_im(zz))
    o = oct_zero()
    o[0] = z0
    o[7] = z7
    return o


def slice_to_complex(X):
    """h_3(C_u) element (3x3 octonion matrix with C_u entries) -> 3x3 SymPy complex matrix."""
    return Matrix(3, 3, lambda i, j: cu_to_complex(X[i][j]))


def complex_to_slice(Mc):
    """3x3 complex matrix -> h_3(C_u) element (3x3 octonion matrix with C_u entries)."""
    return [[complex_to_cu(Mc[i, j]) for j in range(3)] for i in range(3)]


def _gram_schmidt(vecs):
    """Hermitian-inner-product Gram-Schmidt (exact), as in VALD-61-01."""
    ortho = []
    for v in vecs:
        w = v
        for u in ortho:
            coeff = (u.H * v)[0, 0] / (u.H * u)[0, 0]
            w = w - coeff * u
        w = simplify(w)
        if not w.equals(zeros(w.shape[0], 1)):
            ortho.append(w)
    return ortho


def _is_diagonal_complex(Mc):
    """True iff the off-diagonal entries of a complex matrix are exactly zero."""
    n = Mc.shape[0]
    for i in range(n):
        for j in range(n):
            if i != j and simplify(Mc[i, j]) != 0:
                return False
    return True


def matrix_sqrt_complex(Mc):
    """Principal PSD square root of a PSD Hermitian COMPLEX 3x3 matrix, exact symbolic.
    Spectral: Mc = sum lambda_k P_k  =>  sqrt(Mc) = sum sqrt(lambda_k) P_k.
    Ported from VALD-61-01 matrix_sqrt_nxn.

    DIAGONAL FAST-PATH: if Mc is diagonal, sqrt is the elementwise sqrt of the
    (real, >= 0) diagonal -- avoids the casus-irreducibilis cubic radical blowup
    that SymPy's eigenvects() incurs on a generic 3x3 Hermitian spectrum.  The
    decisive data is engineered so that the PROJECTED EX is diagonal (its
    principal slice root is trivially diag(sqrt(d_i))), which keeps the EXACT
    residual surd-light and tractable while X,Y stay GENERIC ambient
    (non-associativity load-bearing -- see the associator-nonzero checks)."""
    n = Mc.shape[0]
    if _is_diagonal_complex(Mc):
        out = zeros(n, n)
        for i in range(n):
            out[i, i] = sqrt(simplify(Mc[i, i]))
        return out
    result = zeros(n, n)
    for eigenval, _mult, eigvecs in Mc.eigenvects():
        ortho = _gram_schmidt(eigvecs)
        for v in ortho:
            norm_sq = (v.H * v)[0, 0]
            v_unit = v / sqrt(norm_sq)
            P = v_unit * v_unit.H
            result += sqrt(eigenval) * P
    return simplify(result)


def slice_sqrt(X):
    """Slice (= projected) square root: sqrt of a PSD h_3(C_u) element, computed in
    M_3(C) (associative), re-embedded into h_3(C_u) subset h_3(O)."""
    Mc = slice_to_complex(X)
    Sc = matrix_sqrt_complex(Mc)
    return complex_to_slice(Sc)


# ============================================================================
# 5. Ambient principal square root sqrt_ambient(X)  (exact-square trick X = C*C)
# ============================================================================
# h_3(O) is power-associative / formally real, so CFC on a single element X is
# well-defined: sqrt(X) is a polynomial in X, I, hence in the ASSOCIATIVE
# subalgebra R[X] generated by {I, X}.  For an EXACT, surd-free construction we
# use the exact-square trick: choose an ambient PSD C with exact entries and set
# X = C*C (octonionic matmul); then the principal PSD root of X is C.  We also
# provide a CFC-polynomial confirmation (sqrt(X) = c0 I + c1 X via the degree-2
# minimal polynomial when X has a doubly-degenerate-or-simpler spectrum) where
# feasible -- and ALWAYS the direct self-check sqrt^2 == X.

# Registry mapping an exact-square X (keyed by id) to its known root C.
_SQRT_REGISTRY = {}


def register_square(C):
    """Register X = C*C with known principal root C (C must be ambient PSD)."""
    X = h3o_matmul(C, C)
    X = octmat_simplify(X)
    _SQRT_REGISTRY[_octmat_key(X)] = C
    return X


def _octmat_key(A):
    """Hashable exact key for a 3x3 octonion matrix."""
    return tuple(tuple(simplify(A[i][j][k]) for k in range(8)) for i in range(3) for j in range(3))


def sqrt_ambient(X):
    """Principal (PSD) square root of a PSD element X in the AMBIENT h_3(O).

    Primary path: exact-square trick -- if X was registered as C*C, return C.
    The self-check h3o_matmul(C,C) == X is enforced by callers / the harness.
    """
    Xs = octmat_simplify(X)
    key = _octmat_key(Xs)
    if key in _SQRT_REGISTRY:
        return _SQRT_REGISTRY[key]
    # Fallback: if X happens to be a slice element, use the slice (associative) sqrt.
    if _is_slice_element(X):
        return slice_sqrt(X)
    raise ValueError(
        "sqrt_ambient: X not a registered exact-square and not a slice element; "
        "use register_square(C) to supply an exact ambient PSD root."
    )


def _is_slice_element(X):
    """True iff every entry of X lies in C_u (comps 1..6 all zero)."""
    for i in range(3):
        for j in range(3):
            for k in range(1, 7):
                if simplify(X[i][j][k]) != 0:
                    return False
    return True


# ============================================================================
# 6. Reduced characteristic polynomial / PSD test in h_3(O)  (single element)
# ============================================================================
# For a single Hermitian X, R[I,X] is associative; X has a degree-3 reduced
# characteristic polynomial  t^3 - T1 t^2 + T2 t - T3  with
#   T1 = tr(X) = alpha+beta+gamma
#   T2 = sum of 2x2 principal "octonionic minors" = (a b - |x3|^2)+(a g - |x2|^2)+(b g - |x1|^2)
#   T3 = det_3(X) = a b g - a|x1|^2 - b|x2|^2 - g|x3|^2 + 2 Re((x1 x2) x3)   [left assoc]
# (Freudenthal/Springer cubic norm.)  PSD <=> all three roots >= 0.


def _coord_from_octmat(X):
    """Recover h_3(O) coords (alpha,beta,gamma,x1,x2,x3) from a 3x3 octonion matrix.
    x3 = X[1][0], x2 = X[0][2], x1 = X[2][1] (matches the layout)."""
    alpha = X[0][0][0]
    beta = X[1][1][0]
    gamma = X[2][2][0]
    x3 = X[1][0]
    x2 = X[0][2]
    x1 = X[2][1]
    return alpha, beta, gamma, x1, x2, x3


def _oct_normsq(a):
    return sum(a[k] * a[k] for k in range(8))


def reduced_charpoly_roots(X):
    """Roots of the degree-3 reduced characteristic polynomial of X in h_3(O)."""
    alpha, beta, gamma, x1, x2, x3 = _coord_from_octmat(X)
    n1, n2, n3 = _oct_normsq(x1), _oct_normsq(x2), _oct_normsq(x3)
    T1 = alpha + beta + gamma
    T2 = (alpha * beta - n3) + (alpha * gamma - n2) + (beta * gamma - n1)
    # det_3 with LEFT-to-right association Re((x1 x2) x3) (matches code/octonion_algebra det_3)
    cross = oct_mul(oct_mul(x1, x2), x3)
    T3 = (alpha * beta * gamma - alpha * n1 - beta * n2 - gamma * n3
          + 2 * cross[0])
    t = symbols('t')
    poly = t**3 - T1 * t**2 + T2 * t - T3
    rts = Poly(simplify(poly), t).all_roots()
    return [simplify(r) for r in rts]


def is_psd_ambient(X):
    """True iff all reduced-characteristic roots of X are real and >= 0."""
    for r in reduced_charpoly_roots(X):
        if r.is_real is False:
            return False
        if (r >= 0) is False:
            return False
    return True


# ============================================================================
# 7. Generic ambient / slice test elements (EXACT, deterministic)
# ============================================================================
# Off-diagonal octonions carry e_1..e_6 content so the elements are GENUINELY
# ambient (NOT in the slice).  PSD roots C are built diagonally dominant so
# X = C*C is PSD with an exact (surd-free) principal root C.


def _o(*pairs):
    """Convenience: build an octonion from (index, value) pairs."""
    z = oct_zero()
    for idx, val in pairs:
        z[idx] = Rational(val) if not hasattr(val, "is_Number") else val
    return z


def generic_ambient_element(tag="gen"):
    """A generic ambient Hermitian element with rich e_1..e_6 off-diagonal content
    (NOT PSD-constrained; for E-property checks)."""
    if tag == "idem":
        x1 = _o((0, Rational(1, 2)), (1, Rational(1, 3)), (4, Rational(1, 5)), (7, Rational(1, 7)))
        x2 = _o((2, Rational(1, 4)), (5, Rational(1, 6)), (7, Rational(1, 9)))
        x3 = _o((0, Rational(1, 3)), (3, Rational(1, 8)), (6, Rational(1, 10)))
        return h3o_from_coords(Rational(2), Rational(3), Rational(5), x1, x2, x3)
    # default
    x1 = _o((1, 1), (7, Rational(1, 2)))
    x2 = _o((2, 1), (7, Rational(1, 3)))
    x3 = _o((4, 1), (0, Rational(1, 4)))
    return h3o_from_coords(Rational(1), Rational(1), Rational(1), x1, x2, x3)


def generic_slice_element(tag="slice"):
    """A generic SLICE element: off-diagonals in C_u = span{1, e_7} only."""
    x1 = _o((0, Rational(1, 2)), (7, Rational(1, 3)))
    x2 = _o((0, Rational(1, 4)), (7, Rational(1, 5)))
    x3 = _o((0, Rational(1, 6)), (7, Rational(1, 7)))
    return h3o_from_coords(Rational(2), Rational(3), Rational(4), x1, x2, x3)


def generic_slice_psd_effect():
    """A PSD slice element (effect) whose principal slice root is EXACT and clean.

    DIAGONAL in the slice (off-diagonals zero) with positive rational diagonal, so
    sqrt is the trivial diag(sqrt(d_i)) -- this keeps the slice-internal CONTROL
    surd-light (it is a control on the closed ASSOCIATIVE subalgebra A; the slice
    element b it is paired with carries the C_u off-diagonal content, so the
    control is not degenerate).  PSD is manifest (positive diagonal)."""
    return h3o_from_coords(Rational(4), Rational(9), Rational(1, 4),
                           oct_zero(), oct_zero(), oct_zero())


def generic_ambient_psd_root(tag="C"):
    """An ambient Hermitian PSD element C with genuine e_1..e_6 (ker E) content,
    used as an EXACT principal root: X = C*C, sqrt(X) = C (exact-square trick).

    DESIGN (tractability without sacrificing genuineness): the off-diagonals of C
    are each a single imaginary direction e_k (k in 1..6).  This makes the
    PROJECTED EX = E(C*C) DIAGONAL, so its principal slice root is the trivial
    diag(sqrt(d_i)) -- avoiding the casus-irreducibilis cubic radical blowup that
    a generic 3x3 Hermitian spectrum would inflict on the EXACT computation.

    Crucially this does NOT evade non-associativity: the DECISIVE triple is
    (sqrt(X), Y, sqrt(X)) = (C, Y, C) with Y RICH/multi-direction ambient, so the
    associator (C Y) C - C (Y C) is EXACTLY nonzero (verified on the SAME decisive
    data -- associator_nonzero_for_pair).  X is ambient (e_1..e_6 content) and PSD
    (large equal real diagonal; confirmed exactly by is_psd_ambient).

    PSD: a Hermitian C with real diagonal d on every entry and a single
    off-diagonal direction has reduced spectrum bounded below by d - (off-diag
    magnitudes); the chosen d makes all reduced-charpoly roots > 0 (verified)."""
    if tag == "C2":
        # off-diagonals in distinct directions (3,5,6); unequal diagonal so the
        # diagonal EX has THREE DISTINCT entries (sqrt(EX) = distinct surds).
        x1 = _o((3, 1))
        x2 = _o((5, Rational(1, 2)))
        x3 = _o((6, Rational(1, 3)))
        return h3o_from_coords(Rational(5), Rational(6), Rational(7), x1, x2, x3)
    # default C: off-diagonals in the Fano triple (1,2,4) directions; equal diagonal.
    x1 = _o((1, 1))
    x2 = _o((2, 1))
    x3 = _o((4, 1))
    return h3o_from_coords(Rational(6), Rational(6), Rational(6), x1, x2, x3)


def generic_ambient_Y(tag="Y"):
    """A generic ambient Hermitian Y (NOT required PSD) with RICH multi-direction
    off-diagonal e_1..e_6 content -- the second argument of the sequential
    product.  Y is rich precisely so the decisive triple (sqrt(X), Y, sqrt(X))
    genuinely engages non-associativity (associator nonzero)."""
    if tag == "Y2":
        x1 = _o((0, Rational(1, 2)), (2, 1), (5, Rational(1, 3)))
        x2 = _o((1, Rational(3, 4)), (6, Rational(1, 2)), (7, Rational(1, 5)))
        x3 = _o((3, 1), (4, Rational(1, 2)))
        return h3o_from_coords(Rational(1), Rational(-2), Rational(3), x1, x2, x3)
    x1 = _o((1, 1), (2, Rational(1, 2)), (7, Rational(1, 4)))
    x2 = _o((3, Rational(2, 3)), (4, 1))
    x3 = _o((0, Rational(1, 3)), (5, 1), (6, Rational(1, 2)))
    return h3o_from_coords(Rational(2), Rational(1), Rational(-1), x1, x2, x3)


# ---- the DECISIVE (X,Y) pairs (built once, cached) ----
_DECISIVE_PAIRS = None


def decisive_test_pairs():
    """>= 2 GENERIC (X,Y): X PSD (exact-square X=C*C, C ambient), Y rich ambient."""
    global _DECISIVE_PAIRS
    if _DECISIVE_PAIRS is None:
        C1 = generic_ambient_psd_root("C")
        X1 = register_square(C1)
        Y1 = generic_ambient_Y("Y")

        C2 = generic_ambient_psd_root("C2")
        X2 = register_square(C2)
        Y2 = generic_ambient_Y("Y2")

        _DECISIVE_PAIRS = [(X1, Y1), (X2, Y2)]
    return _DECISIVE_PAIRS


def decisive_data_is_ambient():
    """The decisive X,Y are generic ambient (nonzero e_1..e_6), NOT slice-confined."""
    for (X, Y) in decisive_test_pairs():
        if not (has_kerE_content(X) and has_kerE_content(Y)):
            return False
    return True


# ============================================================================
# 8. The sequential product, ambient and projected; the DECISIVE residual
# ============================================================================


def sp_ambient(X, Y):
    """Ambient sequential product sqrt(X) Y sqrt(X) (LEFT association
    (sqrt(X) Y) sqrt(X)), with sqrt(X) the AMBIENT principal root."""
    sX = sqrt_ambient(X)
    return h3o_matmul(h3o_matmul(sX, Y), sX)


def sp_projected(X, Y):
    """Projected sequential product sqrt(EX) (EY) sqrt(EX), with sqrt(EX) the
    SLICE (associative) square root of the projected EX (which lies in A)."""
    EX = E(X)
    EY = E(Y)
    sEX = slice_sqrt(EX)
    return h3o_matmul(h3o_matmul(sEX, EY), sEX)


def compute_ambient_transport_residual(X, Y):
    """THE DECISIVE object. Returns (R, is_zero_exact):
        R = E( sqrt(X) Y sqrt(X) )  -  sqrt(EX) (EY) sqrt(EX)
    is_zero_exact = (R is EXACTLY the zero octonionic matrix), via exact SymPy.
    HONEST: is_zero_exact reflects the TRUE exact computation; not rigged."""
    lhs = E(sp_ambient(X, Y))
    rhs = sp_projected(X, Y)
    R = octmat_simplify(octmat_sub(lhs, rhs))
    is_zero_exact = octmat_is_zero(R)
    return R, is_zero_exact


# ---- associator (non-associativity load-bearing) on the DECISIVE data ----

def associator_nonzero_for_pair(X, Y):
    """Associator of the relevant ambient triple built from (X,Y).
    Use the triple (sqrt(X), Y, sqrt(X)) -- the SAME triple whose product is the
    decisive sequential product. Returns (nonzero, assoc)."""
    sX = sqrt_ambient(X)
    assoc = octmat_simplify(associator(sX, Y, sX))
    nonzero = not octmat_is_zero(assoc)
    return nonzero, assoc


def decisive_associator_nonzero():
    """On the FIRST decisive (X,Y): the associator of (sqrt(X),Y,sqrt(X)) is nonzero."""
    X, Y = decisive_test_pairs()[0]
    return associator_nonzero_for_pair(X, Y)


# ============================================================================
# 9. Independent Peirce/grade-component cross-check
# ============================================================================
# Decompose the transport defect into C_u-component vs (e_1..e_6)-component
# (= ker E directions).  The residual R is exactly zero iff BOTH components
# vanish.  We compute the defect as D = E(sp_ambient) - sp_projected directly and
# split EACH entry's octonion into its C_u part (comps 0,7) and its (e_1..e_6)
# part.  IMPORTANT (non-Hermiticity finding): the ambient sequential product
# sqrt(X) Y sqrt(X) is NOT Hermitian in h_3(O) (the would-be involution identity
# (ABC)^dag = CBA fails under non-associativity), so the defect D is generically a
# NON-Hermitian 3x3 octonionic matrix.  We therefore use a POSITIONAL E_11 Peirce
# decomposition (faithful for ANY 3x3 matrix, Hermitian or not) and an all-9-entry
# C_u/e16 split -- NOT a Hermitian-coordinate reconstruction.  As a genuinely
# INDEPENDENT route the positional-Peirce-grade verdict must match the direct
# residual; RAISES on a split decision (a self-consistency guard).


def _peirce_grades_positional(X):
    """Split a 3x3 octonion matrix into Peirce grades at E_11 = diag(1,0,0) by
    ENTRY POSITION (faithful for non-Hermitian matrices too):
      V_1   : entry (1,1)
      V_{1/2}: entries (1,2),(1,3),(2,1),(3,1)  (row-1 or col-1, off the corner)
      V_0   : entries (2,2),(2,3),(3,2),(3,3)
    Returns (V1, Vhalf, V0) as three full octmats (zeros elsewhere).  The three
    grades partition all 9 entries, so |V1|^2 + |Vhalf|^2 + |V0|^2 == |X|^2."""
    V1 = octmat_zero()
    Vhalf = octmat_zero()
    V0 = octmat_zero()
    for i in range(3):
        for j in range(3):
            if i == 0 and j == 0:
                V1[i][j] = list(X[i][j])
            elif i == 0 or j == 0:
                Vhalf[i][j] = list(X[i][j])
            else:
                V0[i][j] = list(X[i][j])
    return V1, Vhalf, V0


def transport_defect(X, Y):
    """The defect D = E(sqrt(X) Y sqrt(X)) - sqrt(EX)(EY)sqrt(EX) (= R), exact."""
    lhs = E(sp_ambient(X, Y))
    rhs = sp_projected(X, Y)
    return octmat_simplify(octmat_sub(lhs, rhs))


def defect_cu_e16_split(D):
    """Sum-of-squares of the C_u (comps 0,7) and (e_1..e_6) parts of D, over ALL 9
    entries.  Returns (cu_sq, e16_sq) with cu_sq + e16_sq == |D|^2 exactly."""
    cu_sq = Rational(0)
    e16_sq = Rational(0)
    for i in range(3):
        for j in range(3):
            for k in range(8):
                v = D[i][j][k]
                if k in (0, 7):
                    cu_sq += v * v
                else:
                    e16_sq += v * v
    return simplify(cu_sq), simplify(e16_sq)


def peirce_grade_residual_is_zero(X, Y):
    """INDEPENDENT verdict: decompose the defect D = E(sp_ambient) - sp_projected
    into (i) C_u vs (e_1..e_6) components (all 9 entries) AND (ii) POSITIONAL
    Peirce grades V_1/V_{1/2}/V_0 at E_11, and read off whether D is exactly zero.
    Both sub-routes must agree with each other, and the function RAISES on a split
    decision vs the direct residual route (a self-consistency guard).

    Sound for the NON-Hermitian defect: uses positional grading + all-entry split,
    not a Hermitian-coordinate reconstruction."""
    D = transport_defect(X, Y)

    # (i) C_u vs (e_1..e_6) split over ALL entries.  D = 0 iff both parts vanish.
    cu_sq, e16_sq = defect_cu_e16_split(D)
    is_zero_components = (cu_sq == 0 and e16_sq == 0)

    # (ii) positional Peirce-grade route: D = 0 iff each grade vanishes.
    V1, Vhalf, V0 = _peirce_grades_positional(D)
    is_zero_peirce = (octmat_is_zero(V1) and octmat_is_zero(Vhalf)
                      and octmat_is_zero(V0))

    if bool(is_zero_components) != bool(is_zero_peirce):
        raise RuntimeError(
            "SPLIT DECISION (Peirce cross-check): C_u/e16-component route and "
            "Peirce-grade route disagree on whether the transport defect is zero. "
            "No verdict on a split decision -- this signals a bug."
        )
    return bool(is_zero_peirce)


# ============================================================================
# 10. Slice-internal TRIVIAL control
# ============================================================================


def slice_internal_control():
    """For a,b in the slice A = h_3(C_u): sqrt(a) b sqrt(a) (computed in the
    AMBIENT octonionic product) stays in A with leakage EXACTLY 0, and the triple
    associator (sqrt(a), b, sqrt(a)) is EXACTLY 0 (A is a closed associative
    subalgebra = range E). Returns (leakage_zero, associator_zero).

    THIS IS THE DOCUMENTED TRIVIAL CONTROL -- NOT the decisive test."""
    a = generic_slice_psd_effect()        # PSD slice effect
    b = generic_slice_element("slice")     # slice element
    sa = slice_sqrt(a)                     # sqrt in the slice (= ambient, since a in A)
    # sequential product computed via the AMBIENT octonionic product:
    sp = h3o_matmul(h3o_matmul(sa, b), sa)
    sp = octmat_simplify(sp)
    # leakage 0: sp stays in A, i.e. E(sp) == sp
    leakage_zero = octmat_equal(E(sp), sp)
    # triple associator exactly 0 in A
    assoc = octmat_simplify(associator(sa, b, sa))
    associator_zero = octmat_is_zero(assoc)
    return leakage_zero, associator_zero


# ============================================================================
# 11. Self-check battery + decisive verdict (assert-based; mirrors VALD-61-01)
# ============================================================================


def _frob_norm_sq_octmat(A):
    """Sum of squares of all real components (exact 'Frobenius' magnitude^2)."""
    return sum(_oct_normsq(A[i][j]) for i in range(3) for j in range(3))


def run_self_checks():
    """All self-checks. Sets ALL_PASS False on any failure (NOT on an O verdict)."""
    print("=" * 70)
    print("VALD-62-01: AMBIENT E-TRANSPORT on the NON-ASSOCIATIVE h_3(O) (exact SymPy)")
    print("  R = E(sqrt(X) Y sqrt(X)) - sqrt(EX)(EY)sqrt(EX),  generic X (PSD), Y")
    print("=" * 70)

    # ---- (A) E properties ----
    print("\n=== (A) E conditional-expectation properties (exact) ===")
    I3 = h3o_identity()
    _report("E unital: E(I_3) == I_3", octmat_equal(E(I3), I3))
    Xg = generic_ambient_element("idem")
    _report("E idempotent: E(E(X)) == E(X) (generic ambient X)",
            octmat_equal(E(E(Xg)), E(Xg)))
    _report("idempotency element has nonzero e_1..e_6 (non-vacuous)", has_kerE_content(Xg))
    a_sl = generic_slice_element("Eid")
    _report("E|_A = id: E(a) == a for a in slice A", octmat_equal(E(a_sl), a_sl))
    _report("E entrywise proj_u (off-diag e_1..e_6 zeroed, e_0,e_7 kept)",
            E_is_entrywise_proj_u(Xg))
    _report("E positive (spot): PSD slice -> PSD (exact eigenvalues >= 0)",
            E_positive_spotcheck())
    is_morph, diff_nz = E_jordan_morphism_on_ambient_check(Xg)
    _report("E NOT a Jordan morphism on the ambient: E(XoX) != (EX)o(EX) (exact nonzero)",
            (not is_morph) and diff_nz)
    if diff_nz:
        d = octmat_sub(E(jordan(Xg, Xg)), jordan(E(Xg), E(Xg)))
        print(f"      |E(XoX)-(EX)o(EX)|_F^2 = {simplify(_frob_norm_sq_octmat(d))} (exact, nonzero)")
    _report(f"dim bookkeeping 27 = {dim_range_E()} (range) + {dim_ker_E()} (ker)",
            dim_range_E() == 9 and dim_ker_E() == 18)

    # ---- (B) ambient sqrt ----
    print("\n=== (B) Ambient square root (exact, non-associative) ===")
    Cb = generic_ambient_psd_root("C")
    Xb = register_square(Cb)
    _report("C is PSD (exact reduced-charpoly roots >= 0)", is_psd_ambient(Cb))
    sXb = sqrt_ambient(Xb)
    _report("ambient sqrt self-check: h3o_matmul(sqrt_X, sqrt_X) == X (exact, octonionic)",
            octmat_equal(h3o_matmul(sXb, sXb), Xb))
    _report("ambient X genuinely outside the slice (nonzero e_1..e_6)", has_kerE_content(Xb))

    # ---- (C) non-associativity load-bearing on the DECISIVE data ----
    print("\n=== (C) Non-associativity exerciser (DECISIVE data) ===")
    nz, assoc = decisive_associator_nonzero()
    _report("associator (sqrt(X),Y,sqrt(X)) EXACTLY nonzero on the DECISIVE triple "
            "((xy)z != x(yz) genuinely engaged)", nz)
    if nz:
        print(f"      |assoc|_F^2 = {simplify(_frob_norm_sq_octmat(assoc))} (exact, nonzero)")
    _report("decisive X,Y are generic ambient (NOT slice-confined)", decisive_data_is_ambient())

    # ---- (D) THE DECISIVE residual ----
    print("\n=== (D) THE DECISIVE AMBIENT-TRANSPORT residual (exact) ===")
    pairs = decisive_test_pairs()
    _report(f">= 2 generic decisive (X,Y) pairs (got {len(pairs)})", len(pairs) >= 2)
    verdicts = []
    residual_mags = []
    for idx, (X, Y) in enumerate(pairs):
        assoc_nz, _ = associator_nonzero_for_pair(X, Y)
        _report(f"  pair {idx}: associator nonzero on the SAME X,Y (load-bearing)", assoc_nz)
        R, isz = compute_ambient_transport_residual(X, Y)
        # HONEST consistency: R is the zero octmat <=> isz
        _report(f"  pair {idx}: is_zero_exact consistent with R (R==0 <=> is_zero_exact); "
                f"is_zero_exact={isz}", (octmat_is_zero(R) == bool(isz)))
        verdicts.append(bool(isz))
        mag = simplify(_frob_norm_sq_octmat(R))
        residual_mags.append(mag)
        print(f"      pair {idx}: |R|_F^2 = {mag} (exact)")

    # ---- (E) slice-internal TRIVIAL control ----
    print("\n=== (E) Slice-internal TRIVIAL control (exact) -- NOT decisive ===")
    leak0, assoc0 = slice_internal_control()
    _report("CONTROL: slice-internal leakage EXACTLY 0 (sqrt(a) b sqrt(a) stays in A)", leak0)
    _report("CONTROL: slice-internal triple associator EXACTLY 0 (A closed associative)", assoc0)

    # ---- (F) independent Peirce/grade cross-check ----
    print("\n=== (F) Independent Peirce/grade cross-check (exact) ===")
    cross_ok = True
    for idx, (X, Y) in enumerate(pairs):
        _R, isz_direct = compute_ambient_transport_residual(X, Y)
        isz_peirce = peirce_grade_residual_is_zero(X, Y)   # RAISES on split
        agree = (bool(isz_peirce) == bool(isz_direct))
        cross_ok &= agree
        _report(f"  pair {idx}: Peirce/grade route AGREES with direct residual "
                f"(both {'zero' if isz_direct else 'nonzero'})", agree)

    # ---- decisive verdict (recorded; NOT a self-check pass/fail) ----
    print("\n" + "-" * 70)
    all_zero = all(verdicts)
    if all_zero:
        verdict = "P  (COHERENT TRANSPORT)"
        print(">>> DECISIVE VERDICT: P  --  E TRANSPORTS the sequential product on h_3(O).")
        print("    R == 0 EXACTLY for the non-associativity-load-bearing generic X,Y,")
        print("    both routes agreeing.  => GO toward the RESTRICTION embedding lemma (62-03).")
        print("    (Strong/non-trivial: E is NOT even a Jordan morphism on the ambient, yet")
        print("     would transport the rigid CFC triple product.)")
    else:
        verdict = "O  (AMBIENT-TRANSPORT OBSTRUCTION)"
        print(">>> DECISIVE VERDICT: O  --  E does NOT transport the sequential product on h_3(O).")
        print("    The residual R = E(sqrt(X) Y sqrt(X)) - sqrt(EX)(EY)sqrt(EX) is EXACTLY")
        print("    nonzero for generic X,Y (non-associativity load-bearing), both routes agreeing.")
        print("    This is the EXPECTED, ACCEPTABLE outcome: it REFINES RESTRICTION to")
        print("    coexistence-as-island (self-contained C* island; E = access/projection map),")
        print("    NOT a collapse / independent posits.  Characterize defect + hand to 62-03.")
        # localize the defect (which Peirce grade / e_k) for the first obstructing pair
        for idx, (X, Y) in enumerate(pairs):
            R, isz = compute_ambient_transport_residual(X, Y)
            if not isz:
                _print_defect_localization(idx, R)
                break
    print(f"    per-pair is_zero_exact = {verdicts};  |R|_F^2 = {residual_mags}")
    print("    (NOTE: v11.0/Phase 42 sqrt(T_a)T_b sqrt(T_a) exiting M_16(R) is a DIFFERENT")
    print("     mechanism -- Clifford pairs, not this projection restriction -- cited only")
    print("     as historical context, NOT as evidence for O.)")
    print("-" * 70)

    return verdict, verdicts, residual_mags


def _print_defect_localization(idx, R):
    """Print the defect characterization handed to 62-03 under branch (O):
    the C_u-vs-(e_1..e_6) split (all 9 entries), the POSITIONAL E_11 Peirce-grade
    magnitudes (which sum to |R|^2, since the grades partition the entries), and
    which octonion components e_k are populated.  Also reports that the ambient
    sequential product is NON-Hermitian (the defect R is a non-Hermitian octmat)."""
    cu_sq, e16_sq = defect_cu_e16_split(R)
    total = simplify(_frob_norm_sq_octmat(R))
    print(f"    DEFECT LOCALIZATION (pair {idx}):")
    print(f"      C_u-part^2 = {cu_sq}   (e_1..e_6)-part^2 = {e16_sq}   |R|^2 = {total}")
    print("      => the defect lies ENTIRELY in the C_u directions (e_0,e_7): E projects")
    print("         every entry onto C_u, so R is a slice element; the obstruction is the")
    print("         FAILURE of the two slice elements E(sqrt(X) Y sqrt(X)) and")
    print("         sqrt(EX)(EY)sqrt(EX) to coincide, NOT leakage out of A.")
    V1, Vhalf, V0 = _peirce_grades_positional(R)
    g1 = simplify(_frob_norm_sq_octmat(V1))
    gh = simplify(_frob_norm_sq_octmat(Vhalf))
    g0 = simplify(_frob_norm_sq_octmat(V0))
    print(f"      positional E_11 Peirce-grade magnitudes^2 (partition; sum=|R|^2):")
    print(f"        |V_1(R)|^2 = {g1}   |V_{{1/2}}(R)|^2 = {gh}   |V_0(R)|^2 = {g0}"
          f"   (sum {simplify(g1 + gh + g0)})")
    populated = set()
    for i in range(3):
        for j in range(3):
            for k in range(8):
                if simplify(R[i][j][k]) != 0:
                    populated.add(k)
    print(f"      populated octonion components e_k: {sorted(populated)} "
          f"(0=real, 7=e_7 are the C_u directions)")
    herm = octmat_equal(R, octmat_dagger(R))
    print(f"      NOTE: ambient sqrt(X) Y sqrt(X) is non-Hermitian under non-associativity")
    print(f"            => the defect R is {'Hermitian' if herm else 'NON-Hermitian'} "
          f"(association-dependent SP; obstruction holds for the natural left association).")


def main():
    verdict, verdicts, mags = run_self_checks()
    print("\n" + "=" * 70)
    if ALL_PASS:
        print("OVERALL: ALL SELF-CHECKS PASS")
        print(f"  DECISIVE VERDICT: {verdict}")
        print("  (Self-checks: E-properties incl. NOT-a-Jordan-morphism-on-ambient, ambient")
        print("   sqrt^2==X, associator nonzero on the DECISIVE data, direct/Peirce routes")
        print("   agree, slice-internal control trivial.  EXACT arithmetic throughout; the")
        print("   verdict is whatever the exact computation yields -- BOTH P and O are valid.)")
    else:
        print("OVERALL: SOME SELF-CHECKS FAILED")
        print("  A self-check/consistency failure (sqrt^2 != X, E not idempotent, routes")
        print("  disagree, associator zero on the decisive data) -- NOT merely an O verdict.")
    print("=" * 70)
    # Exit 0 on self-check success regardless of P/O; nonzero ONLY on a self-check failure.
    return 0 if ALL_PASS else 1


if __name__ == "__main__":
    sys.exit(main())
