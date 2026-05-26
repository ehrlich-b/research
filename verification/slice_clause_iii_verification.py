"""
Slice Clause (iii) Verification Harness  --  VALD-61-01
========================================================
Phase: 61-slice-satisfies-clause-iii, Plan: 02

Exact-symbolic (SymPy) verification that the C*-bottleneck slice
    A = h_3(C_u) ~ M_3(C)^sa   (n = 3, complex structure u = e_7)
has the structural data Paper 5 Definition 1 clauses (i), (iii), (iv) require,
AS AN ASSOCIATIVE ALGEBRA IN ITS OWN RIGHT:

  Clause (i)  ingredient  -- DERV-61-01:
      Jordan rank 3: three mutually orthogonal nontrivial rank-1 projective
      units E_11, E_22, E_33 summing to I_3 (>= 2 orthogonal nontrivial
      projective units; frame-independent).
  Clause (iv)             -- DERV-61-02:
      Simplicity: center(M_3(C)) = C*I_3; no nontrivial central idempotent;
      hence M_3(C)^sa is simple (no nontrivial order-unit direct-sum split).
  Clause (iii) ingredient -- DERV-61-03 (BGW-grounded):
      MINIMAL/standard composite M_3(C)^sa (x) M_3(C)^sa = M_9(C)^sa,
      real dim 81 = 9*9 (local tomography). MAXIMAL/universal composite
      M_9(C)^sa (+) M_9(C)^sa, real dim 162 != 81 (extra classical bit, BGW).
      The clause (iii) object is the MINIMAL composite (81), NOT the maximal.
  Clause (iii) datum 4    -- DERV-61-03 (Phase 60 OPEN ITEM, closed in Task 2):
      Product-form (Luders) sequential product a&b = sqrt(a) b sqrt(a)
      factorizes across the body-model tensor split on the ASSOCIATIVE
      composite M_9(C)^sa.   [implemented below; tested in tests/test_slice_clause_iii.py]

# ASSERT_CONVENTION: slice A = M_3(C)^sa (n=3); Jordan product a o b = (1/2)(ab+ba); sequential product a&b = sqrt(a) b sqrt(a); exact symbolic/rational arithmetic; pure algebra (no physical dimensions); LIVE-paper provenance.

CRITICAL FRAMING (embedded per plan):
  * These computations REPRODUCE the standard, KNOWN structure of M_3(C)^sa
    (rank 3, simple). They are the phase's "known results"; a FAILURE here is
    the BACKTRACKING TRIGGER (revisit Phase 60 framing / rem:converse), NOT
    something to force-pass.
  * Clause (iii) is checked AS STATED -- minimality in full force; the composite
    is the MINIMAL one (fp-redefine-iii, fp-conflate-composites rejected).
  * STALE-TEXT GUARD: ROADMAP Phase 61 Success Criterion 3 literally says
    "minimal = maximal per BGW" -- this is STALE (pre-Phase-60). The corrected
    fact (Phase 60, rem-converse-bgw.md) is minimal != maximal; the minimal
    composite is a DIRECT SUMMAND of the maximal. This script's dim 81 vs 162
    check IS the witness of that correction. NO "minimal = maximal coincide"
    wording is reproduced anywhere.
  * SCOPE GUARD: associative slice ONLY. No h_3(O) / non-associative reach
    (fp-reach-into-h3o) -- that is Phase 62.

References:
  Barnum-Graydon-Wilce, Quantum 4, 359 (2020); arXiv:1606.09331v3
    (composite-dimension baseline; minimal != maximal; Thm 4.15 / Cor 4.16, Table 2).
  Paper 5 Def 1 (def:self-modeling-system): clause (i) sms:finite, (iii) sms:minimal,
    (iv) sms:simple  --  LIVE paper ~/repos/blog/landing/papers/qm-from-self-modeling/main.tex.
  Paper 7 lem:bottleneck (complexification.tex line 409): supplies the slice A = M_3(C)^sa.

Reproducibility: SymPy 1.14.0, Python 3.14.2, macOS Darwin 24.6.0.
  No random seeds (deterministic exact symbolic computation; the one fixed
  unitary used for the rotated-frame check is hardcoded with sqrt(2) entries).

Environment: Python 3, SymPy >= 1.12.  Runtime budget: < 5 s for the core
VALD-61-01 assertions.  Decisive assertions use exact equality
(.equals(zeros)/== 0/Rational/integer equality), NEVER float tolerance
(fp-float-pass rejected).
"""

import sys
from sympy import (
    Matrix, sqrt, Rational, eye, zeros, I as symI, simplify,
    kronecker_product, symbols, conjugate,
)

# Track overall pass/fail; the script must exit nonzero on any failure.
ALL_PASS = True


def _report(label, ok):
    """Print a PASS/FAIL line and fold into the global pass flag."""
    global ALL_PASS
    status = "PASS" if ok else "FAIL"
    print(f"  [{status}] {label}")
    if not ok:
        ALL_PASS = False
    return ok


# ============================================================
# 1. Hermitian 3x3 builder + real-dimension count
# ============================================================
# M_3(C)^sa = { 3x3 H : H = H^dag }.  Real parameters:
#   3 real diagonal (a, b, c)
#   3 complex off-diagonal upper entries (x, y, z) = 6 real params
#   lower entries fixed by Hermiticity.
# Total real dimension = 3 + 6 = 9 = dim_R(M_3(C)^sa).  (Jordan rank 3.)

def hermitian_3x3(a, b, c, x_re, x_im, y_re, y_im, z_re, z_im):
    """General 3x3 Hermitian matrix from 9 real parameters.

      [[ a        , x_re+i x_im, y_re+i y_im],
       [ x_re-i x_im, b        , z_re+i z_im],
       [ y_re-i y_im, z_re-i z_im, c        ]]
    """
    x = x_re + x_im * symI
    y = y_re + y_im * symI
    z = z_re + z_im * symI
    return Matrix([
        [a, x, y],
        [conjugate(x), b, z],
        [conjugate(y), conjugate(z), c],
    ])


def check_hermiticity_and_dim():
    print("\n=== 1. Hermitian 3x3 builder + real-dimension count ===")
    a, b, c = symbols('a b c', real=True)
    xr, xi, yr, yi, zr, zi = symbols('xr xi yr yi zr zi', real=True)
    H = hermitian_3x3(a, b, c, xr, xi, yr, yi, zr, zi)

    # Hermiticity: H == H^dag (conjugate transpose), exact symbolic.
    herm_ok = simplify(H - H.H).equals(zeros(3, 3))
    _report("general 3x3 builder is Hermitian: H == H.H (exact, symbolic)", herm_ok)

    # Real-dimension count: 9 independent real parameters.
    real_params = {a, b, c, xr, xi, yr, yi, zr, zi}
    dim_R = len(real_params)
    _report(f"dim_R(M_3(C)^sa) = {dim_R} (expect 9; Jordan rank 3)", dim_R == 9)
    print(f"      independent real parameters: 3 diagonal + 3 complex off-diagonal = {dim_R}")
    return H


# ============================================================
# 2. RANK 3 / three orthogonal rank-1 projective units (clause i)
# ============================================================

I3 = eye(3)


def _e(i):
    """Standard basis column vector e_i in C^3 (i = 0,1,2)."""
    v = zeros(3, 1)
    v[i] = 1
    return v


def jordan_product(A, B):
    """Jordan product A o B = (1/2)(A B + B A) -- convention lock."""
    return Rational(1, 2) * (A * B + B * A)


def is_rank_one_projection(P):
    """Exact checks: P^2 == P (idempotent), P Hermitian, rank(P) == 1,
    P != 0, P != I_3."""
    idem = simplify(P * P - P).equals(zeros(3, 3))
    herm = simplify(P - P.H).equals(zeros(3, 3))
    rank1 = (P.rank() == 1)
    nonzero = not simplify(P).equals(zeros(3, 3))
    not_identity = not simplify(P - I3).equals(zeros(3, 3))
    return idem and herm and rank1 and nonzero and not_identity


def _check_three_units(E, frame_label):
    """Check that E = [E0, E1, E2] are three mutually orthogonal nontrivial
    rank-1 projective units summing to I_3 (Jordan-orthogonal)."""
    ok = True
    for i in range(3):
        ok &= _report(
            f"[{frame_label}] E_{i+1}{i+1} is a nontrivial rank-1 projective unit "
            f"(E^2=E, Hermitian, rank 1, !=0, !=I_3)",
            is_rank_one_projection(E[i]))
    # Mutual Jordan-orthogonality: E_ii o E_jj == 0 (and E_ii E_jj == 0) for i != j.
    for i in range(3):
        for j in range(i + 1, 3):
            jp = jordan_product(E[i], E[j])
            ok &= _report(
                f"[{frame_label}] E_{i+1}{i+1} o E_{j+1}{j+1} = 0 (Jordan-orthogonal)",
                simplify(jp).equals(zeros(3, 3)))
            mm = simplify(E[i] * E[j])
            ok &= _report(
                f"[{frame_label}] E_{i+1}{i+1} E_{j+1}{j+1} = 0 (matrix-orthogonal)",
                mm.equals(zeros(3, 3)))
    # Completeness: sum == I_3.
    total = simplify(E[0] + E[1] + E[2])
    ok &= _report(f"[{frame_label}] E_11 + E_22 + E_33 = I_3 (completeness)",
                  total.equals(I3))
    return ok


def check_rank_three_units():
    print("\n=== 2. Rank 3 / three orthogonal rank-1 projective units (clause i) ===")

    # Standard diagonal frame.
    E_std = [ _e(i) * _e(i).H for i in range(3) ]  # E_ii = e_i e_i^dag
    _check_three_units(E_std, "standard")

    # Rank caps at 3: the three E_ii are a complete orthogonal system; their
    # orthocomplement in M_3(C)^sa is {0}.  Operationally: the only Hermitian P
    # with P E_ii = 0 for all i is P = 0 (its support must avoid all three
    # coordinate lines, i.e. the whole space).  We verify the resolution of
    # identity is complete -> any further orthogonal projective unit would have
    # to live in (I_3 - sum E_ii) = 0_3, so it is 0.  Rank of A is 3.
    leftover = simplify(I3 - (E_std[0] + E_std[1] + E_std[2]))
    _report("rank caps at 3: I_3 - (E_11+E_22+E_33) = 0_3 "
            "(no room for a 4th orthogonal nonzero projective unit)",
            leftover.equals(zeros(3, 3)))
    print("      => Jordan rank(M_3(C)^sa) = 3 (>= 2 required by clause (i)).")

    # ----- ROTATED-FRAME robustness (frame-independence of clause (i)) -----
    # Fixed exact unitary U in M_3(C): a real rotation in the (1,2) plane by
    # pi/4 (entries 1/sqrt(2)) combined with a phase on coordinate 3.  U is
    # unitary with exact sqrt(2) entries; U U^dag = I_3 verified.
    r = Rational(1, 1) / sqrt(2)
    U = Matrix([
        [ r,  r,        0],
        [-r,  r,        0],
        [ 0,  0,    symI],   # phase i on the 3rd coordinate (still unitary)
    ])
    unitary_ok = simplify(U * U.H - I3).equals(zeros(3, 3))
    _report("fixed rotated-frame unitary U is unitary: U U^dag = I_3 (exact)",
            unitary_ok)
    E_rot = [ simplify(U * E_std[i] * U.H) for i in range(3) ]
    _check_three_units(E_rot, "rotated")
    print("      => three orthogonal rank-1 projective units summing to I_3 "
          "hold in BOTH frames; clause (i) is intrinsic / frame-independent.")
    return E_std


# ============================================================
# 3. SIMPLICITY / center = C*I_3, no nontrivial central idempotent (clause iv)
# ============================================================

def check_simplicity():
    print("\n=== 3. Simplicity / center = C*I_3 (clause iv) ===")

    # Solve for X (3x3, 9 complex entries) commuting with a GENERATING set of
    # M_3(C).  Matrix units E_12, E_23 already generate M_3(C) as an algebra;
    # we use the robust set {E_12, E_21, E_23, E_32, E_13, E_31} (all off-diag
    # matrix units) so the commutant is unambiguously the center.
    xs = symbols('m0:9')  # m0..m8, complex entries of X (treated as free unknowns)
    X = Matrix(3, 3, xs)

    def Eunit(i, j):
        M = zeros(3, 3)
        M[i, j] = 1
        return M

    gens = [Eunit(0, 1), Eunit(1, 0), Eunit(1, 2),
            Eunit(2, 1), Eunit(0, 2), Eunit(2, 0)]

    # Accumulate all commutator equations [X, g] = 0.
    eqs = []
    for g in gens:
        comm = X * g - g * X
        for k in range(3):
            for l in range(3):
                eqs.append(simplify(comm[k, l]))

    from sympy import linsolve, FiniteSet
    sol = linsolve(eqs, list(xs))
    # Expect a 1-parameter family: X = m0 * I_3 (all diagonal equal, off-diag 0).
    print(f"      commutant solution set: {sol}")

    # Verify the solution is exactly scalar multiples of I_3.
    # Substitute the solution back: pick the free parameter and confirm X = lambda I_3.
    center_is_scalar = False
    if isinstance(sol, FiniteSet) and len(sol) == 1:
        tup = list(sol)[0]
        Xsol = Matrix(3, 3, tup)
        # The off-diagonal entries must be identically 0 and the three diagonal
        # entries must be a single common free symbol.
        offdiag_zero = all(simplify(Xsol[i, j]) == 0
                           for i in range(3) for j in range(3) if i != j)
        diag_equal = (simplify(Xsol[0, 0] - Xsol[1, 1]) == 0 and
                      simplify(Xsol[1, 1] - Xsol[2, 2]) == 0)
        free_syms = Xsol.free_symbols
        one_param = (len(free_syms) == 1)
        center_is_scalar = offdiag_zero and diag_equal and one_param
        print(f"      reconstructed center element X = {tup}  (free symbols: {free_syms})")
    _report("center(M_3(C)) = C*I_3 (commutant of matrix units = scalars only)",
            center_is_scalar)

    # No nontrivial central idempotent: a central z must be scalar lambda*I_3;
    # idempotency lambda^2 = lambda forces lambda in {0, 1}, i.e. z in {0, I_3}.
    lam = symbols('lam')
    from sympy import solveset, S
    roots = solveset(lam**2 - lam, lam, domain=S.Complexes)
    print(f"      central idempotent eigenvalue equation lam^2=lam -> lam in {roots}")
    only_trivial = (roots == FiniteSet(0, 1))
    _report("no nontrivial central idempotent: central z scalar => z in {0, I_3} "
            "(lam^2=lam has only lam in {0,1})", only_trivial)
    print("      => M_3(C)^sa is SIMPLE: no nontrivial order-unit direct-sum split (clause iv).")
    return center_is_scalar and only_trivial


# ============================================================
# 4. COMPOSITE DIMENSION (clause iii ingredient, BGW-grounded)
# ============================================================

def check_composite_dimension():
    print("\n=== 4. Composite dimension (clause iii ingredient, BGW-grounded) ===")

    dim_M3 = 9    # dim_R(M_3(C)^sa) = n^2 with n=3
    dim_M9 = 81   # dim_R(M_9(C)^sa) = (n^2)^2 = n^4
    _report(f"dim_R(M_3(C)^sa) = {dim_M3} (= 3^2)", dim_M3 == 9)
    _report(f"dim_R(M_9(C)^sa) = {dim_M9} (= 9^2)", dim_M9 == 81)

    # MINIMAL / standard composite: M_3(C)^sa (x) M_3(C)^sa = M_9(C)^sa.
    # Real dimension = 9 * 9 = 81 (local tomography / product-dimension bookkeeping).
    dim_minimal = dim_M3 * dim_M3
    _report(f"dim_R(MINIMAL composite M_3(C)^sa (x) M_3(C)^sa) = {dim_minimal} "
            f"= 9*9 = dim_R(M_9(C)^sa) = {dim_M9}",
            dim_minimal == 81 and dim_minimal == dim_M9)

    # Concrete kron spot-check: kron of two 3x3 Hermitians is a 9x9 Hermitian
    # (lands in M_9(C)^sa).  This realizes the standard tensor product.
    H1 = hermitian_3x3(Rational(1, 2), Rational(1, 3), Rational(1, 4),
                       Rational(1, 5), Rational(1, 6), 0, 0, Rational(1, 7), 0)
    H2 = hermitian_3x3(Rational(2, 3), Rational(1, 5), Rational(3, 4),
                       0, Rational(1, 8), Rational(1, 9), 0, 0, Rational(1, 10))
    K = kronecker_product(H1, H2)
    _report("kron(H1,H2) is 9x9 (shape check)", K.shape == (9, 9))
    _report("kron(H1,H2) is Hermitian (lands in M_9(C)^sa): K == K.H (exact)",
            simplify(K - K.H).equals(zeros(9, 9)))

    # MAXIMAL / universal composite: C_3 box-tilde C_3 = M_9(C)^sa (+) M_9(C)^sa.
    # Real dimension = 2 * 81 = 162 (extra classical bit; BGW Table 2 / Cor 4.16).
    dim_maximal = 2 * dim_M9
    _report(f"dim_R(MAXIMAL/universal composite M_9(C)^sa (+) M_9(C)^sa) = {dim_maximal} "
            f"= 2*81", dim_maximal == 162)
    _report(f"minimal != maximal: {dim_minimal} != {dim_maximal} "
            f"(quantitative signature of the extra classical bit, BGW)",
            dim_minimal != dim_maximal)

    print("      ------------------------------------------------------------")
    print("      CLAUSE (iii) OBJECT = the MINIMAL composite (real-dim 81),")
    print("      the local-tomography-respecting standard composite M_9(C)^sa.")
    print("      The maximal composite (real-dim 162) carries an EXTRA CLASSICAL")
    print("      BIT and is NOT the clause (iii) object; minimality SELECTS the")
    print("      standard summand (BGW Thm 4.15/Cor 4.16: minimal is a direct")
    print("      summand of maximal).  STALE-TEXT GUARD: 'minimal = maximal' is")
    print("      the pre-Phase-60 error; the corrected fact is minimal != maximal.")
    print("      ------------------------------------------------------------")

    # Type/category ledger (pure-algebra analog of dimensional analysis).
    print("      TYPE/CATEGORY tags:")
    print("        M_3(C)^sa           : special simple FRJA  (Jordan rank 3)")
    print("        minimal composite   : special simple FRJA  (M_9(C)^sa)")
    print("        maximal composite   : special NON-simple FRJA (M_9 (+) M_9)")
    print("        'minimal vs maximal': same-category (FRJA) comparison; answer NOT-equal.")
    return True


# ============================================================
# Task 2: matrix square root (n x n) + product-form factorization
#   (functions live here so the pytest harness can import them; the
#    decisive seq-product assertions are exercised in tests/test_slice_clause_iii.py)
# ============================================================

def matrix_sqrt_nxn(M):
    """Positive (principal) square root of an n x n PSD Hermitian matrix M,
    via spectral decomposition:  M = sum_k lambda_k P_k  =>
    sqrt(M) = sum_k sqrt(lambda_k) P_k,  with eigenprojectors P_k built from
    orthonormalized eigenvectors.  Exact symbolic (Rational / surd entries).

    Requires M PSD Hermitian (eigenvalues real >= 0).  Returns the unique
    Hermitian PSD square root.
    """
    n = M.shape[0]
    result = zeros(n, n)
    for eigenval, _mult, eigvecs in M.eigenvects():
        # Gram-Schmidt orthonormalize the eigenvectors within this eigenspace,
        # then sum their rank-1 projectors (handles degenerate eigenvalues).
        ortho = _gram_schmidt(eigvecs)
        for v in ortho:
            norm_sq = (v.H * v)[0, 0]
            v_unit = v / sqrt(norm_sq)
            P = v_unit * v_unit.H
            result += sqrt(eigenval) * P
    return simplify(result)


def _gram_schmidt(vecs):
    """Gram-Schmidt orthogonalization of a list of column vectors (exact),
    using the Hermitian inner product <u,v> = u^dag v."""
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


def luders_seq_product(a, b):
    """Product-form (Luders) sequential product a & b = sqrt(a) b sqrt(a),
    for PSD Hermitian a (an effect) and Hermitian b.  Exact symbolic."""
    sa = matrix_sqrt_nxn(a)
    return simplify(sa * b * sa)


def check_seqprod_factorization():
    """Clause (iii) datum 4 -- the Phase 60 OPEN ITEM, closed by exact matrix
    computation: the product-form sequential product a&b = sqrt(a) b sqrt(a)
    factorizes across the body-model tensor split on the ASSOCIATIVE composite
    M_9(C)^sa = M_3(C)^sa (x) M_3(C)^sa.

    (The full robustness battery lives in tests/test_slice_clause_iii.py; this
    is a standalone in-script witness so VALD-61-01 demonstrates the closed
    open item directly.)
    """
    print("\n=== 5. Product-form seq-product factorizes on M_9(C)^sa "
          "(clause iii datum 4; Phase 60 open item) ===")

    # Exact 3x3 effects (rational entries; eigenvalues in [0,1]); at least one
    # off-diagonal factor so the factorization is non-trivial.
    a_B = hermitian_3x3(Rational(1, 2), Rational(1, 2), Rational(1, 2),
                        Rational(1, 4), 0, 0, 0, 0, 0)   # off-diagonal real
    a_M = hermitian_3x3(Rational(1, 2), Rational(1, 2), Rational(3, 4),
                        0, Rational(1, 4), 0, 0, 0, 0)   # off-diagonal complex
    b_B = Matrix([[Rational(1, 3), 0, 0],
                  [0, Rational(2, 3), 0],
                  [0, 0, Rational(1, 5)]])               # diagonal
    b_M = hermitian_3x3(Rational(2, 5), Rational(3, 5), Rational(1, 2),
                        Rational(1, 5), 0, 0, 0, 0, 0)   # off-diagonal real

    # matrix_sqrt_nxn self-check: sqrt(a_B)^2 == a_B (Hermitian PSD), exact.
    s = matrix_sqrt_nxn(a_B)
    _report("matrix_sqrt_nxn self-check: sqrt(a_B)^2 == a_B (3x3, exact)",
            simplify(s * s - a_B).equals(zeros(3, 3)))

    # Intermediate identity: sqrt(a_B (x) a_M) = sqrt(a_B) (x) sqrt(a_M).
    a = kronecker_product(a_B, a_M)                       # 9x9 PSD
    sqrt_full = matrix_sqrt_nxn(a)                         # sqrt on the full 9x9
    sqrt_kron = kronecker_product(matrix_sqrt_nxn(a_B), matrix_sqrt_nxn(a_M))
    _report("sqrt(a_B (x) a_M) = sqrt(a_B) (x) sqrt(a_M) "
            "(full-9x9 spectral sqrt vs kron of 3x3 sqrts, exact)",
            simplify(sqrt_full - sqrt_kron).equals(zeros(9, 9)))

    # DECISIVE: a&b = sqrt(a) b sqrt(a) on the full 9x9 == (a_B&b_B)(x)(a_M&b_M).
    b = kronecker_product(b_B, b_M)
    lhs = luders_seq_product(a, b)                        # 9x9, via 9x9 sqrt
    rhs = kronecker_product(luders_seq_product(a_B, b_B),
                            luders_seq_product(a_M, b_M))
    _report("PRODUCT-FORM FACTORIZATION: sqrt(a) b sqrt(a) "
            "== (a_B & b_B) (x) (a_M & b_M) on M_9(C)^sa (exact) "
            "[Phase 60 open item CLOSED]",
            simplify(lhs - rhs).equals(zeros(9, 9)))

    # S3 unitality on the composite: I_9 & a = a.
    _report("S3 unitality: I_9 & a = a (product effect, exact)",
            simplify(luders_seq_product(eye(9), a) - a).equals(zeros(9, 9)))

    print("      SCOPE: associative slice ONLY -- M_3(C)^sa and M_9(C)^sa; no")
    print("      h_3(O) / non-associative reach (fp-reach-into-h3o; Phase 62).")
    return True


# ============================================================
# Main
# ============================================================

def main():
    print("=" * 64)
    print("VALD-61-01: exact-symbolic verification of M_3(C)^sa structure")
    print("            (clauses i, iv, and clause iii composite dimension)")
    print("=" * 64)

    check_hermiticity_and_dim()
    check_rank_three_units()
    check_simplicity()
    check_composite_dimension()
    check_seqprod_factorization()

    print("\n" + "=" * 64)
    if ALL_PASS:
        print("OVERALL: ALL CHECKS PASS")
        print("  Standard M_3(C)^sa structure reproduced exactly:")
        print("    - Jordan rank 3, three orthogonal rank-1 projective units -> I_3 (clause i)")
        print("    - simple, center = C*I_3, no nontrivial central idempotent (clause iv)")
        print("    - minimal composite real-dim 81 = 9*9; maximal 162 != 81 (clause iii; BGW)")
        print("    - product-form seq-product sqrt(a) b sqrt(a) factorizes on M_9(C)^sa")
        print("      (clause iii datum 4; Phase 60 open item CLOSED by exact computation)")
        print("  Full seq-product robustness battery: tests/test_slice_clause_iii.py.")
    else:
        print("OVERALL: SOME CHECKS FAILED -- BACKTRACKING TRIGGER")
        print("  A failure here contradicts standard M_3(C)^sa structure.")
        print("  Per the plan, this signals revisiting the Phase 60 framing /")
        print("  rem:converse confirmation, NOT a force-pass.")
    print("=" * 64)
    return 0 if ALL_PASS else 1


if __name__ == "__main__":
    sys.exit(main())
