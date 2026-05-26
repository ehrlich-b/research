#!/usr/bin/env python3
# ASSERT_CONVENTION: natural_units=dimensionless, clifford_signature=Cl(9,0),
#   clifford_normalization={T_a,T_b}=(1/2)delta_{ab}I_16,
#   sequential_product=sqrt(a)b*sqrt(a), sqrt_branch=principal,
#   effect_definition=E_a=(I+2T_a)/2
#
# Phase 42, Plan 01: Exhaustive verification of the sequential product
# identity sqrt(T_a) T_b sqrt(T_a) = (i/2)*T_b for all 72 anticommuting
# Cl(9,0) generator pairs. Also verifies diagonal pairs give (1/4)*I_16
# and effect algebra stays real.
#
# GO/NO-GO gate for v11.0 Gap C closure via sequential product route.
#
# Reproducibility: numpy 2.4.2, sympy 1.14.0, Python 3.14.2,
# macOS Darwin 24.6.0. Fully deterministic (no random seeds needed).

import sys
import os

import numpy as np

# Add code/ to path so we can import effective_hamiltonian
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
from effective_hamiltonian import get_traceless_generators

from sympy import Matrix, Rational, sqrt as sp_sqrt, I as sp_I, eye as sp_eye, simplify


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def sqrt_Ta_numpy(T):
    """Closed-form principal sqrt of T_a (eigenvalues +/-1/2).

    sqrt(T_a) = ((1+i)*I + (1-i)*2*T_a) / (2*sqrt(2))

    Satisfies sqrt(T_a)^2 = T_a (verified in Section 1).
    """
    n = T.shape[0]
    I_n = np.eye(n)
    return ((1 + 1j) * I_n + (1 - 1j) * 2 * T) / (2 * np.sqrt(2))


def sqrt_Ta_sympy(T_sp):
    """Closed-form principal sqrt of T_a for SymPy exact matrices.

    Same formula: ((1+i)*I + (1-i)*2*T_a) / (2*sqrt(2))
    """
    n = T_sp.rows
    I_n = sp_eye(n)
    return ((1 + sp_I) * I_n + (1 - sp_I) * 2 * T_sp) / (2 * sp_sqrt(2))


def numpy_to_sympy_rational(T):
    """Convert a numpy matrix with entries in {-1/2, 0, +1/2} to exact
    SymPy Rational matrix. Verifies round-trip to < 1e-15."""
    n = T.shape[0]
    rows = []
    for i in range(n):
        row = []
        for j in range(n):
            x = T[i, j]
            # All entries are exactly +/-1/2 or 0
            int_2x = int(round(2 * x))
            r = Rational(int_2x, 2)
            row.append(r)
        rows.append(row)
    sp_mat = Matrix(rows)
    # Verify round-trip
    for i in range(n):
        for j in range(n):
            diff = abs(float(sp_mat[i, j]) - T[i, j])
            if diff > 1e-15:
                raise ValueError(
                    f"Round-trip error at ({i},{j}): "
                    f"original={T[i,j]}, sympy={float(sp_mat[i,j])}, diff={diff}"
                )
    return sp_mat


# ---------------------------------------------------------------------------
# Main verification
# ---------------------------------------------------------------------------

def main():
    TOLERANCE = 1e-14
    all_pass = True

    # ==================================================================
    # Section 0: Load generators and verify anticommutation precondition
    # ==================================================================
    print("=" * 65)
    print("SECTION 0: Load generators and verify Clifford anticommutation")
    print("=" * 65)

    T_list = get_traceless_generators()
    n_gen = len(T_list)
    assert n_gen == 9, f"Expected 9 generators, got {n_gen}"
    dim = T_list[0].shape[0]
    assert dim == 16, f"Expected 16x16 matrices, got {dim}x{dim}"
    I_16 = np.eye(dim)

    precond_pass = 0
    precond_fail = 0
    max_precond_err = 0.0

    for a in range(n_gen):
        for b in range(n_gen):
            anticomm = T_list[a] @ T_list[b] + T_list[b] @ T_list[a]
            expected = 0.5 * (1 if a == b else 0) * I_16
            err = np.linalg.norm(anticomm - expected, 'fro')
            max_precond_err = max(max_precond_err, err)
            if err < TOLERANCE:
                precond_pass += 1
            else:
                precond_fail += 1
                print(f"  FAIL: {{T_{a}, T_{b}}} error = {err:.2e}")

    print(f"Precondition: {precond_pass}/81 anticommutation checks passed "
          f"(max error = {max_precond_err:.2e})")

    if precond_fail > 0:
        print("ABORT: Precondition failed. T_a matrices are not valid "
              "Cl(9,0) generators.")
        return 1

    # ==================================================================
    # Section 1: Sqrt construction and sanity check
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 1: Sqrt construction and sanity (sqrt(T_a)^2 = T_a)")
    print("=" * 65)

    sqrt_list = [sqrt_Ta_numpy(T) for T in T_list]
    sqrt_pass = 0
    max_sqrt_err = 0.0

    for a in range(n_gen):
        sq = sqrt_list[a] @ sqrt_list[a]
        err = np.linalg.norm(sq - T_list[a], 'fro')
        max_sqrt_err = max(max_sqrt_err, err)
        if err < TOLERANCE:
            sqrt_pass += 1
        else:
            print(f"  FAIL: sqrt(T_{a})^2 error = {err:.2e}")
            all_pass = False

    print(f"Sqrt sanity: {sqrt_pass}/9 checks passed "
          f"(max error = {max_sqrt_err:.2e})")

    if sqrt_pass != 9:
        all_pass = False

    # ==================================================================
    # Section 2: Off-diagonal sequential product (72 pairs, NumPy)
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 2: Off-diagonal sequential product (72 pairs, NumPy)")
    print("           sqrt(T_a) T_b sqrt(T_a) = (i/2)*T_b for a != b")
    print("=" * 65)

    offdiag_pass = 0
    offdiag_fail = 0
    max_offdiag_err = 0.0
    min_imag_norm = float('inf')
    max_real_norm = 0.0
    offdiag_count = 0

    for a in range(n_gen):
        for b in range(n_gen):
            if a == b:
                continue
            offdiag_count += 1
            product = sqrt_list[a] @ T_list[b] @ sqrt_list[a]
            expected = (1j / 2) * T_list[b]
            err = np.linalg.norm(product - expected, 'fro')
            imag_norm = np.linalg.norm(product.imag, 'fro')
            real_norm = np.linalg.norm(product.real, 'fro')
            max_offdiag_err = max(max_offdiag_err, err)
            min_imag_norm = min(min_imag_norm, imag_norm)
            max_real_norm = max(max_real_norm, real_norm)

            if err < TOLERANCE and imag_norm > 0.5:
                offdiag_pass += 1
            else:
                offdiag_fail += 1
                print(f"  FAIL: (a={a}, b={b}) err={err:.2e}, "
                      f"imag_norm={imag_norm:.4f}, real_norm={real_norm:.2e}")
                all_pass = False

    assert offdiag_count == 72, f"Expected 72 off-diagonal pairs, got {offdiag_count}"
    print(f"Off-diagonal: {offdiag_pass}/72 passed")
    print(f"  max_error = {max_offdiag_err:.2e}")
    print(f"  min_imag_norm = {min_imag_norm:.6f}")
    print(f"  max_real_norm = {max_real_norm:.2e}")

    if offdiag_fail > 0:
        all_pass = False

    # ==================================================================
    # Section 3: Diagonal sequential product (9 pairs, NumPy)
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 3: Diagonal sequential product (9 pairs, NumPy)")
    print("           sqrt(T_a) T_a sqrt(T_a) = (1/4)*I_16")
    print("=" * 65)

    diag_pass = 0
    max_diag_err = 0.0

    for a in range(n_gen):
        product = sqrt_list[a] @ T_list[a] @ sqrt_list[a]
        expected = 0.25 * I_16
        # Diagonal product should be real (T_a commutes with sqrt(T_a))
        err = np.linalg.norm(product - expected, 'fro')
        max_diag_err = max(max_diag_err, err)
        if err < TOLERANCE:
            diag_pass += 1
        else:
            print(f"  FAIL: (a={a}) err={err:.2e}")
            all_pass = False

    print(f"Diagonal: {diag_pass}/9 passed (max error = {max_diag_err:.2e})")

    if diag_pass != 9:
        all_pass = False

    # ==================================================================
    # Section 4: Effect algebra control (72 pairs, NumPy)
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 4: Effect algebra control (72 pairs, NumPy)")
    print("           E_a E_b E_a = (1/2)*E_a, effects stay real")
    print("=" * 65)

    # Compute effects E_a = (I + 2*T_a)/2
    E_list = [(I_16 + 2 * T) / 2 for T in T_list]

    # Verify E_a^2 = E_a (projection check)
    proj_pass = 0
    for a in range(n_gen):
        err = np.linalg.norm(E_list[a] @ E_list[a] - E_list[a], 'fro')
        if err < TOLERANCE:
            proj_pass += 1
        else:
            print(f"  FAIL: E_{a}^2 != E_{a}, error = {err:.2e}")
    print(f"Projection check: {proj_pass}/9 passed")

    effect_pass = 0
    effect_fail = 0
    max_effect_err = 0.0
    max_effect_imag = 0.0
    effect_count = 0

    for a in range(n_gen):
        for b in range(n_gen):
            if a == b:
                continue
            effect_count += 1
            product = E_list[a] @ E_list[b] @ E_list[a]
            expected = 0.5 * E_list[a]
            err = np.linalg.norm(product - expected, 'fro')
            # E_a are real, so product should be exactly real
            imag_norm = np.linalg.norm(np.imag(product), 'fro')
            max_effect_err = max(max_effect_err, err)
            max_effect_imag = max(max_effect_imag, imag_norm)

            if err < TOLERANCE:
                effect_pass += 1
            else:
                effect_fail += 1
                print(f"  FAIL: (a={a}, b={b}) err={err:.2e}, "
                      f"imag_norm={imag_norm:.2e}")
                all_pass = False

    assert effect_count == 72, f"Expected 72 effect pairs, got {effect_count}"
    print(f"Effect algebra: {effect_pass}/72 passed")
    print(f"  max_error = {max_effect_err:.2e}")
    print(f"  max_imag_norm = {max_effect_imag:.2e}")

    if effect_fail > 0:
        all_pass = False

    # ==================================================================
    # Section 5: SymPy exact verification
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 5: SymPy exact verification (algebraic proof)")
    print("=" * 65)

    # Convert to SymPy exact Rational matrices
    T_sp_list = [numpy_to_sympy_rational(T) for T in T_list]
    print("  Converted 9 generators to exact SymPy Rational matrices.")

    # Compute SymPy sqrt for all 9
    sqrt_sp_list = [sqrt_Ta_sympy(Tsp) for Tsp in T_sp_list]

    # Verify sqrt^2 = T_a exactly
    sympy_sqrt_pass = 0
    for a in range(n_gen):
        sq = sqrt_sp_list[a] * sqrt_sp_list[a]
        diff = simplify(sq - T_sp_list[a])
        if diff.equals(Matrix.zeros(dim, dim)):
            sympy_sqrt_pass += 1
        else:
            print(f"  FAIL: SymPy sqrt(T_{a})^2 != T_{a}")
            all_pass = False
    print(f"  SymPy sqrt sanity: {sympy_sqrt_pass}/9 exact")

    # Off-diagonal: sqrt(T_a) T_b sqrt(T_a) = (sp_I/2)*T_b
    sympy_offdiag_pass = 0
    sympy_offdiag_fail = 0
    I_sp_16 = sp_eye(dim)

    for a in range(n_gen):
        for b in range(n_gen):
            if a == b:
                continue
            product = sqrt_sp_list[a] * T_sp_list[b] * sqrt_sp_list[a]
            expected = (sp_I * Rational(1, 2)) * T_sp_list[b]
            diff = simplify(product - expected)
            if diff.equals(Matrix.zeros(dim, dim)):
                sympy_offdiag_pass += 1
            else:
                sympy_offdiag_fail += 1
                print(f"  FAIL: SymPy off-diagonal (a={a}, b={b}) "
                      f"not identically zero")
                all_pass = False

    print(f"  SymPy off-diagonal: {sympy_offdiag_pass}/72 exact")

    # Diagonal: sqrt(T_a) T_a sqrt(T_a) = (1/4)*I_16
    sympy_diag_pass = 0
    for a in range(n_gen):
        product = sqrt_sp_list[a] * T_sp_list[a] * sqrt_sp_list[a]
        expected = Rational(1, 4) * I_sp_16
        diff = simplify(product - expected)
        if diff.equals(Matrix.zeros(dim, dim)):
            sympy_diag_pass += 1
        else:
            print(f"  FAIL: SymPy diagonal (a={a}) not identically zero")
            all_pass = False

    print(f"  SymPy diagonal: {sympy_diag_pass}/9 exact")
    print(f"  SymPy total: {sympy_offdiag_pass + sympy_diag_pass}/81 exact")

    if sympy_offdiag_fail > 0 or sympy_diag_pass != 9:
        all_pass = False

    # ==================================================================
    # Section 6: GO/NO-GO verdict
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 6: GO/NO-GO VERDICT")
    print("=" * 65)

    total_pairs = offdiag_count + 9 + effect_count
    print(f"Verified: {offdiag_count} off-diagonal + 9 diagonal "
          f"+ {effect_count} effect = {total_pairs} total pairs")
    print()

    if all_pass:
        print("  [1] sqrt(T_a) T_b sqrt(T_a) = (i/2)*T_b for all 72 "
              "anticommuting pairs: PASS")
        print(f"      (NumPy max error: {max_offdiag_err:.2e}, "
              f"SymPy: exact zero)")
        print()
        print("  [2] sqrt(T_a) T_a sqrt(T_a) = (1/4)*I_16 for all 9 "
              "diagonal pairs: PASS")
        print(f"      (NumPy max error: {max_diag_err:.2e}, "
              f"SymPy: exact zero)")
        print()
        print("  [3] E_a E_b E_a = (1/2)*E_a for all 72 effect pairs: PASS")
        print(f"      (max error: {max_effect_err:.2e}, "
              f"max imag: {max_effect_imag:.2e})")
        print()
        print("  [4] Im(sqrt(T_a) T_b sqrt(T_a)) nonzero for all 72 "
              "pairs: PASS")
        print(f"      (min ||Im||_F: {min_imag_norm:.6f}, "
              f"max ||Re||_F: {max_real_norm:.2e})")
        print()
        print("  Sequential product exits M_16(R): YES")
        print("  Effect algebra stays real: YES")
        print()
        print("  *** GO: Sequential product route is viable. ***")
        print("  *** Proceed to Phase 43 (Axiom Derivation).  ***")
        return 0
    else:
        print("  *** NO-GO: Sequential product route is dead. ***")
        print("  *** Proceed to Phase 45 (Contingency).       ***")
        return 1


if __name__ == '__main__':
    sys.exit(main())
