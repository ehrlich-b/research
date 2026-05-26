#!/usr/bin/env python3
# ASSERT_CONVENTION: Clifford normalization {T_a, T_b} = (1/2) delta_{ab} I_16
# ASSERT_CONVENTION: T_a from code/effective_hamiltonian.py get_traceless_generators()
# ASSERT_CONVENTION: Volume element omega = T_0 @ T_1 @ ... @ T_8
#
# Phase 43, Plan 02: Computational verification of C-linear closure claims.
#
# Verifies:
#   1. Precondition: {T_a, T_b} = (1/2) delta_{ab} I_16
#   2. C-rank of all 512 Cl(9,0) monomials = 256 = dim_C M_16(C)
#   3. Volume element omega = (1/512)*I_16 (hat_omega = +1 sector)
#   4. C-rank of even-grade monomials = 256
#
# Reproducibility: numpy 2.4.2, Python 3.14.2, macOS Darwin 24.6.0.
# Fully deterministic (no random seeds needed).

import sys
import os
import math
from itertools import combinations

import numpy as np

# Add code/ to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
from effective_hamiltonian import get_traceless_generators


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
                print(f"  FAIL: {{T_{a}, T_{b}}} error = {err:.2e}")

    print(f"Precondition: {precond_pass}/81 anticommutation checks passed "
          f"(max error = {max_precond_err:.2e})")

    if precond_pass != 81:
        print("ABORT: Precondition failed.")
        return 1

    # ==================================================================
    # Section 1: Construct all 512 Cl(9,0) monomials
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 1: Construct all 512 Cl(9,0) monomials")
    print("=" * 65)

    # For each subset S of {0,...,8}, compute T_S = T_{a_1} @ ... @ T_{a_k}
    # with a_1 < a_2 < ... < a_k. For S = empty, T_S = I_16.
    monomials = []
    monomial_grades = []

    for k in range(n_gen + 1):
        for subset in combinations(range(n_gen), k):
            if k == 0:
                mat = I_16.copy()
            else:
                mat = T_list[subset[0]].copy()
                for idx in subset[1:]:
                    mat = mat @ T_list[idx]
            monomials.append(mat)
            monomial_grades.append(k)

    n_monomials = len(monomials)
    assert n_monomials == 512, f"Expected 512 monomials, got {n_monomials}"
    print(f"Constructed {n_monomials} monomials.")

    # Count by grade
    from collections import Counter
    grade_counts = Counter(monomial_grades)
    print("Grade distribution:")
    for k in sorted(grade_counts.keys()):
        print(f"  grade {k}: {grade_counts[k]} monomials "
              f"(expected C(9,{k}) = {math.comb(9, k)})")

    # ==================================================================
    # Section 2: C-rank of all 512 monomials = 256
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 2: C-rank of all 512 monomials (expect 256)")
    print("=" * 65)

    # Flatten each 16x16 complex matrix to a 256-dim complex vector
    # (view real matrices as complex via M_16(R) subset M_16(C))
    vectors_all = np.array([
        m.astype(complex).flatten() for m in monomials
    ])  # shape (512, 256)

    rank_all = np.linalg.matrix_rank(vectors_all)
    print(f"C-rank of 512 monomials: {rank_all}")
    if rank_all == 256:
        print("  PASS: rank = 256 = dim_C M_16(C)")
    else:
        print(f"  FAIL: rank = {rank_all}, expected 256")
        all_pass = False

    # ==================================================================
    # Section 3: Volume element check
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 3: Volume element omega = T_0 @ T_1 @ ... @ T_8")
    print("=" * 65)

    # Compute omega = T_0 @ T_1 @ ... @ T_8
    omega = T_list[0].copy()
    for a in range(1, n_gen):
        omega = omega @ T_list[a]

    # omega should be real
    if np.iscomplexobj(omega):
        imag_norm = np.linalg.norm(omega.imag, 'fro')
        print(f"  Imaginary part norm: {imag_norm:.2e}")
    else:
        imag_norm = 0.0
        print("  omega is real (as expected for product of real matrices)")

    # Check omega^2
    omega_sq = omega @ omega
    err_sq = np.linalg.norm(omega_sq - (1.0 / 512**2) * I_16, 'fro')

    # Expected: omega = (1/512)*I_16, so omega^2 = (1/512^2)*I_16
    # But let's first check what omega actually is
    expected_omega = (1.0 / 512) * I_16
    err_omega = np.linalg.norm(omega - expected_omega, 'fro')

    print(f"  ||omega - (1/512)*I_16||_F = {err_omega:.2e}")

    if err_omega < TOLERANCE:
        print("  PASS: omega = (1/512)*I_16")
        print("  This confirms V_{1/2} is in the hat_omega = +1 sector")
    else:
        # Maybe omega = -(1/512)*I_16?
        err_neg = np.linalg.norm(omega + expected_omega, 'fro')
        if err_neg < TOLERANCE:
            print("  omega = -(1/512)*I_16 (hat_omega = -1 sector)")
            print("  FAIL: Wrong sector!")
            all_pass = False
        else:
            # omega might not be proportional to I_16 -- check diagonal
            print(f"  omega is NOT proportional to I_16")
            print(f"  omega diagonal: {np.diag(omega)[:4]}...")
            print(f"  ||omega + (1/512)*I_16||_F = {err_neg:.2e}")
            # Check if it's a scalar multiple of I
            trace_omega = np.trace(omega)
            scalar = trace_omega / 16
            err_scalar = np.linalg.norm(omega - scalar * I_16, 'fro')
            print(f"  Trace/16 = {scalar:.6e}, ||omega - scalar*I||_F = {err_scalar:.2e}")
            all_pass = False

    # Also verify hat_omega = 2^9 * omega should equal I_16
    hat_omega = 512 * omega
    err_hat = np.linalg.norm(hat_omega - I_16, 'fro')
    print(f"  ||hat_omega - I_16||_F = {err_hat:.2e}")

    if err_hat < TOLERANCE:
        print("  PASS: hat_omega = gamma_1...gamma_9 = +I_16 on V_{1/2}")
    else:
        err_hat_neg = np.linalg.norm(hat_omega + I_16, 'fro')
        if err_hat_neg < TOLERANCE:
            print("  hat_omega = -I_16 (wrong chirality)")
            all_pass = False
        else:
            print(f"  FAIL: hat_omega is not +/- I_16 (err_+ = {err_hat:.2e}, err_- = {err_hat_neg:.2e})")
            all_pass = False

    # ==================================================================
    # Section 4: C-rank of even-grade monomials = 256
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 4: C-rank of even-grade monomials (expect 256)")
    print("=" * 65)

    # Extract even-grade monomials
    even_monomials = [
        monomials[i] for i in range(n_monomials) if monomial_grades[i] % 2 == 0
    ]
    n_even = len(even_monomials)
    expected_even = sum(math.comb(9, k) for k in range(0, 10, 2))
    print(f"Even-grade monomials: {n_even} (expected {expected_even})")

    assert n_even == expected_even, (
        f"Count mismatch: {n_even} != {expected_even}")

    # Flatten and compute rank
    vectors_even = np.array([
        m.astype(complex).flatten() for m in even_monomials
    ])  # shape (256, 256)

    rank_even = np.linalg.matrix_rank(vectors_even)
    print(f"C-rank of even-grade monomials: {rank_even}")

    if rank_even == 256:
        print("  PASS: rank = 256 = dim_C M_16(C)")
        print("  Confirms Cl^+(9,C)|_{hat_omega=+1} = M_16(C)")
    else:
        print(f"  FAIL: rank = {rank_even}, expected 256")
        all_pass = False

    # ==================================================================
    # Section 5: Odd-grade check (should also be rank 256)
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 5: C-rank of odd-grade monomials (supplemental)")
    print("=" * 65)

    odd_monomials = [
        monomials[i] for i in range(n_monomials) if monomial_grades[i] % 2 == 1
    ]
    n_odd = len(odd_monomials)
    expected_odd = sum(math.comb(9, k) for k in range(1, 10, 2))
    print(f"Odd-grade monomials: {n_odd} (expected {expected_odd})")

    vectors_odd = np.array([
        m.astype(complex).flatten() for m in odd_monomials
    ])  # shape (256, 256)

    rank_odd = np.linalg.matrix_rank(vectors_odd)
    print(f"C-rank of odd-grade monomials: {rank_odd}")

    if rank_odd == 256:
        print("  PASS: rank = 256 (odd-grade monomials also span M_16(C))")
        print("  Consistent with hat_omega mapping even <-> odd within each summand")
    else:
        print(f"  INFO: rank = {rank_odd} (supplemental check, not a required test)")

    # ==================================================================
    # Section 6: Summary
    # ==================================================================
    print()
    print("=" * 65)
    print("SECTION 6: SUMMARY")
    print("=" * 65)

    print()
    print(f"  [1] Precondition: {{T_a, T_b}} = (1/2)*delta_{{ab}}*I_16 "
          f"for all 81 pairs: {'PASS' if precond_pass == 81 else 'FAIL'}")
    print(f"      max error = {max_precond_err:.2e}")
    print()
    print(f"  [2] C-rank of 512 Cl(9,0) monomials = {rank_all}: "
          f"{'PASS' if rank_all == 256 else 'FAIL'}")
    print(f"      (expected 256 = dim_C M_16(C))")
    print()
    print(f"  [3] Volume element: hat_omega = +I_16 on V_{{1/2}}: "
          f"{'PASS' if err_hat < TOLERANCE else 'FAIL'}")
    print(f"      ||hat_omega - I_16||_F = {err_hat:.2e}")
    print()
    print(f"  [4] C-rank of 256 even-grade monomials = {rank_even}: "
          f"{'PASS' if rank_even == 256 else 'FAIL'}")
    print(f"      (confirms Cl^+(9,C)|_{{omega=+1}} = M_16(C))")
    print()

    if all_pass:
        print("  *** ALL CHECKS PASSED ***")
        print("  C-linear closure = M_16(C) verified computationally.")
        print("  Volume element confirms hat_omega = +1 sector.")
        return 0
    else:
        print("  *** SOME CHECKS FAILED ***")
        return 1


if __name__ == '__main__':
    sys.exit(main())
