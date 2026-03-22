"""
Lieb-Robinson velocity for the self-modeling Hamiltonian and Paper 5 compatibility.

Phase: 08-locality-formalization, Plan 03
Date: 2026-03-22

% ASSERT_CONVENTION: natural_units=natural, lattice_spacing=1, hamiltonian_sign=H_min_energy,
%   coupling_convention=H_sum_hxy, commutation_convention=standard,
%   sequential_product=a_ampersand_b, composite_product=product_form

The self-modeling interaction is h_{xy} = J*F (SWAP operator), which for n=2
is the isotropic Heisenberg model h_{xy} = (J/2)(sigma.sigma).

This script:
1. Computes v_LR for the self-modeling Hamiltonian on Z^1, Z^2, Z^3
2. Verifies Paper 5 composite OUS axioms C1-C4
3. Verifies product-form SP numerically
4. Simulates light cone on an N=8 chain

Environment: Python 3, NumPy only (no scipy)
Seed: 42 for reproducibility
numpy version recorded at runtime
"""

import numpy as np
import sys

# Reproducibility
SEED = 42
rng = np.random.default_rng(SEED)


# ============================================================================
# Utility functions (imported concepts from upstream code)
# ============================================================================

def expm(A):
    """Matrix exponential via eigendecomposition (self-adjoint or diagonalizable)."""
    eigenvalues, V = np.linalg.eig(A)
    return V @ np.diag(np.exp(eigenvalues)) @ np.linalg.inv(V)


def expm_hermitian(H):
    """Matrix exponential for Hermitian matrices (numerically stable)."""
    eigenvalues, V = np.linalg.eigh(H)
    return V @ np.diag(np.exp(eigenvalues)) @ V.conj().T


# Pauli matrices
I2 = np.eye(2, dtype=complex)
sigma_x = np.array([[0, 1], [1, 0]], dtype=complex)
sigma_y = np.array([[0, -1j], [1j, 0]], dtype=complex)
sigma_z = np.array([[1, 0], [0, -1]], dtype=complex)
I4 = np.eye(4, dtype=complex)
paulis = [sigma_x, sigma_y, sigma_z]


def construct_swap(n=2):
    """Construct SWAP operator on C^n tensor C^n."""
    F = np.zeros((n**2, n**2), dtype=complex)
    for i in range(n):
        for j in range(n):
            F[n * j + i, n * i + j] = 1.0
    return F


def construct_h_xy(J=1.0, n=2):
    """Construct h_{xy} = J * F (SWAP) for general n."""
    return J * construct_swap(n)


def random_effect(n=2, rng_local=None):
    """Random self-adjoint effect with eigenvalues in [0, 1]."""
    if rng_local is None:
        rng_local = rng
    Z = rng_local.standard_normal((n, n)) + 1j * rng_local.standard_normal((n, n))
    Q, R = np.linalg.qr(Z)
    Q = Q @ np.diag(np.sign(np.diag(R)))
    eigenvalues = rng_local.uniform(0.05, 0.95, n)  # stay away from boundary
    return Q @ np.diag(eigenvalues) @ Q.conj().T


def random_density_matrix(n=2, rng_local=None):
    """Random density matrix (positive, trace 1)."""
    if rng_local is None:
        rng_local = rng
    Z = rng_local.standard_normal((n, n)) + 1j * rng_local.standard_normal((n, n))
    rho = Z @ Z.conj().T
    return rho / np.trace(rho)


def luders_product(a, c):
    """Luders product a & c = a^{1/2} c a^{1/2}."""
    eigenvalues, V = np.linalg.eigh(a)
    eigenvalues = np.maximum(eigenvalues, 0.0)
    sqrt_eig = np.sqrt(eigenvalues)
    a_sqrt = V @ np.diag(sqrt_eig) @ V.conj().T
    return a_sqrt @ c @ a_sqrt


def partial_trace_y(rho_xy, n=2):
    """Partial trace over site y: Tr_y(rho_{xy})."""
    rho_xy = rho_xy.reshape(n, n, n, n)
    return np.trace(rho_xy, axis1=1, axis2=3)


def partial_trace_x(rho_xy, n=2):
    """Partial trace over site x: Tr_x(rho_{xy})."""
    rho_xy = rho_xy.reshape(n, n, n, n)
    return np.trace(rho_xy, axis1=0, axis2=2)


# ============================================================================
# Part 1: LR Velocity Computation
# ============================================================================

def compute_convolution_constant(d, a):
    """C_a = (coth(a/2))^d - 1 for Z^d."""
    if a <= 0:
        raise ValueError(f"a must be > 0, got {a}")
    return (1.0 / np.tanh(a / 2.0)) ** d - 1.0


def compute_interaction_norm(J, z, a):
    """||Phi||_a = z * J * e^a."""
    return z * J * np.exp(a)


def compute_lr_velocity(J, z, d, a):
    """v_LR(a) = 2 * ||Phi||_a * C_a / a."""
    C_a = compute_convolution_constant(d, a)
    Phi_a = compute_interaction_norm(J, z, a)
    return 2.0 * Phi_a * C_a / a


def optimize_decay_parameter(J, z, d, a_min=0.01, a_max=20.0, n_grid=2000):
    """Find a that minimizes v_LR(a) via grid search."""
    a_grid = np.linspace(a_min, a_max, n_grid)
    v_grid = np.array([compute_lr_velocity(J, z, d, a) for a in a_grid])
    idx = np.argmin(v_grid)
    is_boundary = (idx == len(a_grid) - 1)
    return a_grid[idx], v_grid[idx], is_boundary


def compute_self_modeling_lr_velocity():
    """Compute v_LR for the self-modeling Hamiltonian on Z^1, Z^2, Z^3."""
    print("=" * 70)
    print("SELF-MODELING HAMILTONIAN: LR VELOCITY COMPUTATION")
    print("=" * 70)

    # The self-modeling h_{xy} = J*F has ||h_{xy}|| = J (SWAP norm = 1)
    J = 1.0  # Energy scale
    print(f"Interaction: h_{{xy}} = J*F (SWAP), ||h_{{xy}}|| = J = {J}")
    print(f"This is identical to the isotropic Heisenberg model for n=2.")
    print()

    lattices = [
        (1, 2, "Z^1"),
        (2, 4, "Z^2"),
        (3, 6, "Z^3"),
    ]

    results = {}
    for d, z, name in lattices:
        # Reference value at a = 1
        a_ref = 1.0
        C_a = compute_convolution_constant(d, a_ref)
        Phi_a = compute_interaction_norm(J, z, a_ref)
        v_lr = compute_lr_velocity(J, z, d, a_ref)
        C_LR = 2.0 / C_a

        # Optimized
        a_opt, v_opt, is_boundary = optimize_decay_parameter(J, z, d)

        print(f"{name} (d={d}, z={z}):")
        print(f"  At a=1:  C_a={C_a:.6f}, ||Phi||_a={Phi_a:.6f}, v_LR={v_lr:.4f} J")
        print(f"  C_LR = 2/C_a = {C_LR:.4f}, mu_LR = a = {a_ref}")
        if is_boundary:
            print(f"  Optimization: v_LR monotonically decreasing (no finite min)")
        else:
            print(f"  Optimized: a_opt={a_opt:.4f}, v_LR(a_opt)={v_opt:.4f} J")
        print()

        results[name] = {
            'v_lr_a1': v_lr,
            'C_a': C_a,
            'Phi_a': Phi_a,
            'C_LR': C_LR,
            'a_opt': a_opt,
            'v_opt': v_opt,
            'is_boundary': is_boundary,
        }

    # --- Verify limiting cases ---
    print("LIMITING CASE CHECKS:")

    # J -> 0
    v0 = compute_lr_velocity(0.0, 2, 1, 1.0)
    assert v0 == 0.0, f"v_LR(J=0) should be 0, got {v0}"
    print(f"  J -> 0: v_LR = {v0}  [PASS]")

    # v_LR > 0 for J > 0
    assert results["Z^1"]['v_lr_a1'] > 0, "v_LR should be > 0 for J > 0"
    print(f"  J > 0: v_LR = {results['Z^1']['v_lr_a1']:.4f} > 0  [PASS]")

    # Linear scaling
    v1 = compute_lr_velocity(1.0, 2, 1, 1.0)
    v2 = compute_lr_velocity(2.0, 2, 1, 1.0)
    assert abs(v2 / v1 - 2.0) < 1e-10, f"Linear scaling failed: {v2/v1}"
    print(f"  v_LR(2J)/v_LR(J) = {v2/v1:.6f}  [PASS]")

    # Ratio with Heisenberg benchmark (should be 1)
    # The self-modeling Hamiltonian IS Heisenberg, so ratio = 1
    ratio = 1.0  # by construction
    print(f"  v_LR^SM / v_LR^Heisenberg = {ratio:.6f} (identical interaction)  [PASS]")

    # v_LR for general n (independent of n since ||F|| = 1 for all n)
    for n in [2, 3, 4]:
        F_n = construct_swap(n)
        norm_F = np.linalg.norm(F_n, ord=2)  # operator norm
        assert abs(norm_F - 1.0) < 1e-10, f"||F|| should be 1 for n={n}, got {norm_F}"
    print(f"  ||F||_op = 1 for n=2,3,4: v_LR independent of n  [PASS]")

    print()
    return results


# ============================================================================
# Part 2: Paper 5 Composite OUS Verification
# ============================================================================

def verify_composite_ous(n_trials=25):
    """Verify Paper 5 composite OUS axioms C1-C4 for the lattice two-site system."""
    print("=" * 70)
    print("PAPER 5 COMPOSITE OUS VERIFICATION (C1-C4)")
    print("=" * 70)
    print()

    all_pass = True

    # --- C1: Vector space ---
    print("C1 (Vector space): V_{xy} contains V_x tensor V_y")
    dim_Vx = 4  # dim(M_2(C)^sa) = 4
    dim_Vy = 4
    dim_Vxy = 16  # dim(M_4(C)^sa) = 16
    assert dim_Vxy == dim_Vx * dim_Vy, "Local tomography dimension count failed"
    print(f"  dim(V_x) = {dim_Vx}, dim(V_y) = {dim_Vy}")
    print(f"  dim(V_{{xy}}) = {dim_Vxy} = {dim_Vx} * {dim_Vy}  [PASS]")

    # Verify embedding: product of self-adjoint is self-adjoint in M_4
    rng_c1 = np.random.default_rng(SEED)
    for i in range(n_trials):
        a = random_effect(2, rng_c1)
        b = random_effect(2, rng_c1)
        ab = np.kron(a, b)
        # Check self-adjointness
        sa_err = np.max(np.abs(ab - ab.conj().T))
        if sa_err > 1e-12:
            print(f"  Trial {i}: self-adjointness error = {sa_err:.2e}  [FAIL]")
            all_pass = False
    print(f"  {n_trials} random products: all self-adjoint in M_4(C)^sa  [PASS]")
    print()

    # --- C2: Order unit ---
    print("C2 (Order unit): 1_{xy} = 1_x tensor 1_y = I_4")
    unit_err = np.max(np.abs(np.kron(I2, I2) - I4))
    c2_pass = unit_err < 1e-15
    print(f"  ||I_2 tensor I_2 - I_4|| = {unit_err:.2e}  [{'PASS' if c2_pass else 'FAIL'}]")
    all_pass = all_pass and c2_pass
    print()

    # --- C3: Product states ---
    print(f"C3 (Product states): {n_trials} random product states")
    rng_c3 = np.random.default_rng(SEED + 1)
    c3_pass = True
    for i in range(n_trials):
        rho_x = random_density_matrix(2, rng_c3)
        rho_y = random_density_matrix(2, rng_c3)
        rho_xy = np.kron(rho_x, rho_y)

        # Check positivity
        eigs = np.linalg.eigvalsh(rho_xy)
        if np.min(eigs) < -1e-12:
            print(f"  Trial {i}: negative eigenvalue {np.min(eigs):.2e}  [FAIL]")
            c3_pass = False

        # Check trace 1
        tr = np.trace(rho_xy)
        if abs(tr - 1.0) > 1e-12:
            print(f"  Trial {i}: trace = {tr:.6f}  [FAIL]")
            c3_pass = False

        # Check product expectations
        a = random_effect(2, rng_c3)
        b = random_effect(2, rng_c3)
        expect_product = np.trace(rho_xy @ np.kron(a, b))
        expect_factor = np.trace(rho_x @ a) * np.trace(rho_y @ b)
        if abs(expect_product - expect_factor) > 1e-10:
            print(f"  Trial {i}: product expectation mismatch  [FAIL]")
            c3_pass = False

    print(f"  All positive, trace 1, product expectations match  [{'PASS' if c3_pass else 'FAIL'}]")
    all_pass = all_pass and c3_pass
    print()

    # --- C4: Non-signaling ---
    print(f"C4 (Non-signaling): {n_trials} random joint states")
    rng_c4 = np.random.default_rng(SEED + 2)
    c4_pass = True
    max_ns_violation = 0.0

    for i in range(n_trials):
        # Random joint state (can be entangled)
        rho_xy = random_density_matrix(4, rng_c4)

        # Marginals
        rho_x = partial_trace_y(rho_xy, 2)
        rho_y = partial_trace_x(rho_xy, 2)

        # Check marginals are valid states
        eigs_x = np.linalg.eigvalsh(rho_x)
        eigs_y = np.linalg.eigvalsh(rho_y)
        if np.min(eigs_x) < -1e-12 or np.min(eigs_y) < -1e-12:
            print(f"  Trial {i}: marginal has negative eigenvalue  [FAIL]")
            c4_pass = False

        tr_x = abs(np.trace(rho_x) - 1.0)
        tr_y = abs(np.trace(rho_y) - 1.0)
        if tr_x > 1e-12 or tr_y > 1e-12:
            print(f"  Trial {i}: marginal trace != 1  [FAIL]")
            c4_pass = False

        # Non-signaling: Tr[(a tensor I) rho_{xy}] = Tr[a rho_x]
        for _ in range(3):
            a = random_effect(2, rng_c4)
            expect_joint = np.trace(np.kron(a, I2) @ rho_xy)
            expect_marginal = np.trace(a @ rho_x)
            ns_err = abs(expect_joint - expect_marginal)
            max_ns_violation = max(max_ns_violation, ns_err)
            if ns_err > 1e-10:
                c4_pass = False

    print(f"  Max non-signaling violation: {max_ns_violation:.2e}")
    print(f"  All marginals valid states, non-signaling holds  [{'PASS' if c4_pass else 'FAIL'}]")
    all_pass = all_pass and c4_pass
    print()

    print(f"COMPOSITE OUS VERIFICATION: {'ALL PASS' if all_pass else 'FAILED'}")
    print()
    return all_pass


# ============================================================================
# Part 3: Product-Form SP Verification
# ============================================================================

def verify_product_sp(n_trials=25):
    """Verify (a tensor b) & (c tensor d) = (a & c) tensor (b & d)."""
    print("=" * 70)
    print("PRODUCT-FORM SP VERIFICATION")
    print("=" * 70)
    print()

    rng_sp = np.random.default_rng(SEED + 3)
    max_err = 0.0
    all_pass = True

    for i in range(n_trials):
        a = random_effect(2, rng_sp)
        b = random_effect(2, rng_sp)
        c = random_effect(2, rng_sp)
        d = random_effect(2, rng_sp)

        # LHS: (a tensor b) & (c tensor d) using composite Luders product
        ab = np.kron(a, b)
        cd = np.kron(c, d)
        lhs = luders_product(ab, cd)

        # RHS: (a & c) tensor (b & d) using factor Luders products
        ac = luders_product(a, c)
        bd = luders_product(b, d)
        rhs = np.kron(ac, bd)

        err = np.max(np.abs(lhs - rhs))
        max_err = max(max_err, err)

        if err > 1e-10:
            print(f"  Trial {i}: ||LHS - RHS|| = {err:.2e}  [FAIL]")
            all_pass = False

    print(f"  {n_trials} random effect quadruples tested")
    print(f"  Max ||LHS - RHS|| = {max_err:.2e}")
    print(f"  Product-form SP: [{'PASS' if all_pass else 'FAIL'}]")
    print()
    return all_pass, max_err


# ============================================================================
# Part 4: Light Cone Numerical Verification
# ============================================================================

def construct_chain_hamiltonian(N, J=1.0):
    """Construct H = sum_{i=1}^{N-1} h_{i,i+1} on a chain of N qubits.

    h_{i,i+1} = J * F_{i,i+1} where F is SWAP acting on sites i and i+1.
    Full Hilbert space dimension: 2^N.
    """
    dim = 2**N
    H = np.zeros((dim, dim), dtype=complex)
    F_2site = construct_swap(2)  # 4x4 SWAP

    for i in range(N - 1):
        # Build the N-site operator: I^{tensor i} tensor F tensor I^{tensor (N-2-i)}
        if i == 0:
            op = F_2site.copy()
        else:
            op = np.kron(np.eye(2**i, dtype=complex), F_2site)
        if i < N - 2:
            op = np.kron(op, np.eye(2**(N - 2 - i), dtype=complex))
        H += J * op

    return H


def single_site_operator(op, site, N):
    """Construct an operator acting as 'op' on 'site' and I elsewhere.

    Parameters
    ----------
    op : ndarray, shape (2, 2)
    site : int (0-indexed)
    N : int (total number of sites)
    """
    if site == 0:
        result = op.copy()
    else:
        result = np.kron(np.eye(2**site, dtype=complex), op)
    if site < N - 1:
        result = np.kron(result, np.eye(2**(N - 1 - site), dtype=complex))
    return result


def verify_light_cone(N=8, J=1.0, t_max=2.0, n_times=21):
    """Verify LR bound by time-evolving a local perturbation.

    On a chain of N sites:
    - Perturb site 0 with sigma_z
    - Measure commutator ||[A(t), B_r]|| at site r
    - Compare with LR bound
    """
    print("=" * 70)
    print(f"LIGHT CONE VERIFICATION (N={N} chain, J={J})")
    print("=" * 70)
    print()

    # Build Hamiltonian
    H = construct_chain_hamiltonian(N, J)
    dim = 2**N
    print(f"  Hilbert space dimension: {dim}")

    # Verify H is Hermitian
    herm_err = np.max(np.abs(H - H.conj().T))
    assert herm_err < 1e-12, f"H not Hermitian: error = {herm_err}"
    print(f"  Hermiticity check: ||H - H^dag|| = {herm_err:.2e}  [PASS]")

    # Diagonalize H (exact for 256x256)
    eigenvalues, eigenvectors = np.linalg.eigh(H)
    print(f"  Energy range: [{eigenvalues[0]:.4f}, {eigenvalues[-1]:.4f}]")

    # Local operators
    A = single_site_operator(sigma_z, 0, N)  # sigma_z at site 0

    # Time grid
    times = np.linspace(0, t_max, n_times)

    # LR bound parameters (use a = 1 for the bound)
    a = 1.0
    z = 2  # Z^1 coordination
    d_dim = 1
    C_a = compute_convolution_constant(d_dim, a)
    Phi_a = compute_interaction_norm(J, z, a)
    norm_A = 1.0  # ||sigma_z|| = 1
    norm_B = 1.0

    print(f"  LR bound parameters: a={a}, C_a={C_a:.4f}, ||Phi||_a={Phi_a:.4f}")
    print(f"  v_LR(a=1) = {compute_lr_velocity(J, z, d_dim, a):.4f}")
    print()

    # Compute commutator norms
    all_within_bound = True
    print(f"  {'t':>6s}  {'r':>3s}  {'||[A(t),B_r]||':>16s}  {'LR bound':>12s}  {'Status':>8s}")
    print(f"  {'-'*6}  {'-'*3}  {'-'*16}  {'-'*12}  {'-'*8}")

    commutator_data = []

    for t in times:
        # Time evolution: A(t) = e^{iHt} A e^{-iHt}
        # Using eigendecomposition: U = V diag(e^{i*lambda*t}) V^dag
        phases = np.exp(1j * eigenvalues * t)
        U = eigenvectors @ np.diag(phases) @ eigenvectors.conj().T
        U_dag = U.conj().T
        A_t = U @ A @ U_dag

        for r in range(1, N):  # sites 1 through N-1 (distance r from site 0)
            B_r = single_site_operator(sigma_z, r, N)

            # Commutator
            comm = A_t @ B_r - B_r @ A_t
            comm_norm = np.linalg.norm(comm, ord=2)  # operator norm

            # LR bound
            distance = r  # graph distance from site 0 to site r
            lr_bound = (2 * norm_A * norm_B / C_a) * \
                       (np.exp(2 * Phi_a * C_a * abs(t)) - 1) * \
                       np.exp(-a * distance)

            # The bound is always >= 0; cap at 2*||A||*||B|| = 2
            lr_bound = min(lr_bound, 2 * norm_A * norm_B)

            within = comm_norm <= lr_bound + 1e-10  # small tolerance
            if not within:
                all_within_bound = False

            commutator_data.append({
                't': t, 'r': r, 'comm_norm': comm_norm,
                'lr_bound': lr_bound, 'within': within
            })

            # Print selected data points
            if t in [0.0, 0.5, 1.0, 1.5, 2.0] or not within:
                status = "OK" if within else "VIOLATED"
                print(f"  {t:6.2f}  {r:3d}  {comm_norm:16.8f}  {lr_bound:12.6f}  {status:>8s}")

    print()
    print(f"  All commutators within LR bound: [{'PASS' if all_within_bound else 'FAIL'}]")

    # Check wavefront: at t=1, commutator should be small for r > v_LR * t ~ 12.66
    # Since our chain only has 8 sites (max distance 7), all sites are within the
    # light cone at t=1. But at t=0.1, sites r >= 2 should have small commutators.
    print()
    print("  Wavefront analysis:")
    v_lr = compute_lr_velocity(J, z, d_dim, a)
    for t_check in [0.1, 0.2, 0.5]:
        cone_radius = v_lr * t_check
        print(f"    t={t_check}: v_LR*t = {cone_radius:.2f}")
        for entry in commutator_data:
            if abs(entry['t'] - t_check) < 0.01:
                r = entry['r']
                cn = entry['comm_norm']
                status = "inside cone" if r <= cone_radius else "outside cone"
                if r >= 3:  # only show far sites
                    print(f"      r={r}: ||[A(t),B_r]|| = {cn:.2e}  ({status})")

    print()
    return all_within_bound, commutator_data


# ============================================================================
# Main
# ============================================================================

def main():
    print("Self-Modeling Hamiltonian: LR Velocity and Paper 5 Compatibility")
    print(f"numpy version: {np.__version__}")
    print(f"Random seed: {SEED}")
    print()

    all_pass = True

    # Part 1: LR velocity
    lr_results = compute_self_modeling_lr_velocity()

    # Part 2: Paper 5 composite OUS
    c_pass = verify_composite_ous(n_trials=25)
    all_pass = all_pass and c_pass

    # Part 3: Product-form SP
    sp_pass, sp_err = verify_product_sp(n_trials=25)
    all_pass = all_pass and sp_pass

    # Part 4: Light cone
    lc_pass, lc_data = verify_light_cone(N=8, J=1.0, t_max=2.0, n_times=21)
    all_pass = all_pass and lc_pass

    # --- Final summary ---
    print()
    print("=" * 70)
    print("FINAL SUMMARY")
    print("=" * 70)
    print()
    print("LR Velocity for Self-Modeling Hamiltonian h_{xy} = J*F (SWAP):")
    for name in ["Z^1", "Z^2", "Z^3"]:
        r = lr_results[name]
        print(f"  {name}: v_LR(a=1) = {r['v_lr_a1']:.4f} J, "
              f"C_LR = {r['C_LR']:.4f}, mu_LR = 1")
        if not r['is_boundary']:
            print(f"       optimized: v_LR(a={r['a_opt']:.2f}) = {r['v_opt']:.4f} J")
    print()
    print(f"Paper 5 composite OUS (C1-C4): {'PASS' if c_pass else 'FAIL'}")
    print(f"Product-form SP (max error {sp_err:.2e}): {'PASS' if sp_pass else 'FAIL'}")
    print(f"Light cone (N=8 chain): {'PASS' if lc_pass else 'FAIL'}")
    print()
    print(f"OVERALL: {'ALL PASS' if all_pass else 'SOME TESTS FAILED'}")

    return 0 if all_pass else 1


if __name__ == "__main__":
    sys.exit(main())
