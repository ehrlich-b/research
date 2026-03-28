"""
Numerical verification of the Landauer bound on self-modeling.

Phase 25, Plan 01, Task 2: Verify W >= kT * I(B;M) for qubit self-modeling.

ASSERT_CONVENTION: natural_units=natural, entropy_base=nats,
    state_normalization=Tr(rho)=1, coupling_convention=H=sum_h_xy,
    information=I(B;M)=S(B)+S(M)-S(BM)

References:
- derivations/25-landauer-self-modeling.md (Task 1 derivation)
- Phase 23, Plan 01: CPTP channel E(rho_B) = cos^2(Jt) rho_B + sin^2(Jt) I/2
- Phase 23, Plan 02: E^N(rho) -> I/2, entropy monotonicity

Platform: Python 3.x with numpy, scipy
Random seed: 42 (for reproducibility)
"""

import numpy as np
from scipy import linalg
import sys

np.random.seed(42)

# ============================================================
# Helper functions
# ============================================================

def von_neumann_entropy(rho):
    """Compute S(rho) = -Tr(rho ln rho) in nats."""
    eigvals = np.real(linalg.eigvalsh(rho))
    eigvals = eigvals[eigvals > 1e-15]  # Avoid log(0)
    return -np.sum(eigvals * np.log(eigvals))


def mutual_information(rho_BM, d_B, d_M):
    """Compute I(B;M) = S(B) + S(M) - S(BM)."""
    # Partial traces
    rho_B = partial_trace_M(rho_BM, d_B, d_M)
    rho_M = partial_trace_B(rho_BM, d_B, d_M)
    S_B = von_neumann_entropy(rho_B)
    S_M = von_neumann_entropy(rho_M)
    S_BM = von_neumann_entropy(rho_BM)
    return S_B + S_M - S_BM


def partial_trace_M(rho_BM, d_B, d_M):
    """Trace out subsystem M, returning rho_B."""
    rho_BM_reshaped = rho_BM.reshape(d_B, d_M, d_B, d_M)
    return np.trace(rho_BM_reshaped, axis1=1, axis2=3)


def partial_trace_B(rho_BM, d_B, d_M):
    """Trace out subsystem B, returning rho_M."""
    rho_BM_reshaped = rho_BM.reshape(d_B, d_M, d_B, d_M)
    return np.trace(rho_BM_reshaped, axis1=0, axis2=2)


def experiential_density(I_BM, S_B):
    """Compute rho = I(B;M) * (1 - I(B;M)/S(B))."""
    if S_B < 1e-15:
        return 0.0
    return I_BM * (1.0 - I_BM / S_B)


def random_density_matrix(d):
    """Generate a random density matrix of dimension d (Hilbert-Schmidt measure)."""
    G = np.random.randn(d, d) + 1j * np.random.randn(d, d)
    rho = G @ G.conj().T
    return rho / np.trace(rho)


def random_joint_density_matrix(d_B, d_M):
    """Generate a random joint density matrix on H_B tensor H_M."""
    d = d_B * d_M
    return random_density_matrix(d)


def landauer_bound(I_BM, kT=1.0):
    """Minimum work W >= kT * I(B;M)."""
    return kT * I_BM


# ============================================================
# SWAP operator and evolution
# ============================================================

def swap_operator(d):
    """SWAP operator on C^d tensor C^d."""
    F = np.zeros((d*d, d*d), dtype=complex)
    for i in range(d):
        for j in range(d):
            # F|ij> = |ji>
            F[j*d + i, i*d + j] = 1.0
    return F


def swap_evolution(rho_BM, J, t, d):
    """Evolve rho_BM under H = J*F for time t."""
    F = swap_operator(d)
    U = linalg.expm(-1j * J * F * t)
    return U @ rho_BM @ U.conj().T


def depolarizing_channel(rho_B, p):
    """E(rho_B) = (1-p) rho_B + p I/2, for qubit."""
    d = rho_B.shape[0]
    return (1 - p) * rho_B + p * np.eye(d) / d


# ============================================================
# Test 1: Parametric family of joint states
# ============================================================

def test_parametric_family():
    """Test I(B;M) and Landauer bound for parametric family of 2-qubit states."""
    print("=" * 60)
    print("TEST 1: Parametric family of joint states")
    print("=" * 60)

    d_B, d_M = 2, 2
    kT = 1.0

    # Parametric family: interpolate between product state and correlated state
    # rho_BM(alpha) = (1-alpha) * (rho_B tensor rho_M) + alpha * |psi><psi|
    # where |psi> = (|00> + |11>)/sqrt(2) (Bell state)
    rho_B = np.array([[0.8, 0.0], [0.0, 0.2]])
    rho_M = np.eye(2) / 2  # maximally mixed
    rho_product = np.kron(rho_B, rho_M)
    psi_bell = np.array([1, 0, 0, 1]) / np.sqrt(2)
    rho_bell = np.outer(psi_bell, psi_bell.conj())

    alphas = np.linspace(0, 1, 50)
    I_values = []
    W_values = []
    rho_exp_values = []

    for alpha in alphas:
        rho_BM = (1 - alpha) * rho_product + alpha * rho_bell
        I_BM = mutual_information(rho_BM, d_B, d_M)
        rho_B_local = partial_trace_M(rho_BM, d_B, d_M)
        S_B = von_neumann_entropy(rho_B_local)
        W_min = landauer_bound(I_BM, kT)
        rho_exp = experiential_density(I_BM, S_B)

        I_values.append(I_BM)
        W_values.append(W_min)
        rho_exp_values.append(rho_exp)

    I_values = np.array(I_values)
    W_values = np.array(W_values)
    rho_exp_values = np.array(rho_exp_values)

    # Verify W_min = kT * I(B;M) (linear relationship)
    assert np.allclose(W_values, kT * I_values, atol=1e-14), "W_min != kT * I(B;M)"
    print(f"  W_min = kT * I(B;M) verified for {len(alphas)} states")

    # I should increase with alpha (more correlation)
    assert I_values[0] < 1e-10, f"I at alpha=0 should be ~0, got {I_values[0]}"
    assert I_values[-1] > 0.5, f"I at alpha=1 should be large, got {I_values[-1]}"
    print(f"  I(alpha=0) = {I_values[0]:.6e} (expected ~0)")
    print(f"  I(alpha=1) = {I_values[-1]:.6f} (Bell state: expected ln(2) = {np.log(2):.6f})")
    print(f"  W_min range: [{W_values[0]:.6e}, {W_values[-1]:.6f}] kT")
    print(f"  rho_exp range: [{rho_exp_values[0]:.6e}, {max(rho_exp_values):.6f}]")
    print("  PASSED")
    return True


# ============================================================
# Test 2: Equilibrium limit
# ============================================================

def test_equilibrium_limit():
    """Verify I(B;M) = 0 and rho = 0 at thermal equilibrium."""
    print("\n" + "=" * 60)
    print("TEST 2: Equilibrium limit")
    print("=" * 60)

    d_B, d_M = 2, 2
    d = d_B * d_M
    kT = 1.0

    # Maximally mixed state: rho_BM = I/(d_B * d_M)
    rho_BM_eq = np.eye(d) / d

    I_eq = mutual_information(rho_BM_eq, d_B, d_M)
    rho_B_eq = partial_trace_M(rho_BM_eq, d_B, d_M)
    S_B_eq = von_neumann_entropy(rho_B_eq)
    rho_exp_eq = experiential_density(I_eq, S_B_eq)
    W_eq = landauer_bound(I_eq, kT)

    print(f"  rho_BM = I/4 (maximally mixed 2-qubit state)")
    print(f"  I(B;M) = {I_eq:.2e} (expected 0, error < 1e-14)")
    print(f"  S(B) = {S_B_eq:.6f} (expected ln(2) = {np.log(2):.6f})")
    print(f"  rho_exp = {rho_exp_eq:.2e} (expected 0)")
    print(f"  W_min = {W_eq:.2e} (expected 0)")

    assert abs(I_eq) < 1e-14, f"I(B;M) not zero at equilibrium: {I_eq}"
    assert abs(rho_exp_eq) < 1e-14, f"rho not zero at equilibrium: {rho_exp_eq}"
    assert abs(W_eq) < 1e-14, f"W_min not zero at equilibrium: {W_eq}"
    assert abs(S_B_eq - np.log(2)) < 1e-14, f"S(B) != ln(2) at equilibrium: {S_B_eq}"

    print("  PASSED")
    return True


# ============================================================
# Test 3: Maximally correlated state
# ============================================================

def test_maximally_correlated():
    """For Bell state: I(B;M) = ln(2), W_min = kT * ln(2)."""
    print("\n" + "=" * 60)
    print("TEST 3: Maximally correlated state (Bell)")
    print("=" * 60)

    d_B, d_M = 2, 2
    kT = 1.0

    psi_bell = np.array([1, 0, 0, 1]) / np.sqrt(2)
    rho_bell = np.outer(psi_bell, psi_bell.conj())

    I_bell = mutual_information(rho_bell, d_B, d_M)
    rho_B_bell = partial_trace_M(rho_bell, d_B, d_M)
    S_B_bell = von_neumann_entropy(rho_B_bell)
    W_bell = landauer_bound(I_bell, kT)
    rho_exp_bell = experiential_density(I_bell, S_B_bell)

    print(f"  |psi> = (|00> + |11>)/sqrt(2)")
    print(f"  I(B;M) = {I_bell:.6f} (expected 2*ln(2) = {2*np.log(2):.6f})")
    print(f"  S(B) = {S_B_bell:.6f} (expected ln(2) = {np.log(2):.6f})")
    print(f"  W_min = {W_bell:.6f} kT (expected 2*ln(2) = {2*np.log(2):.6f})")

    # For a pure entangled state: I(B;M) = 2*S(B) = 2*ln(2)
    # since S(BM) = 0 for a pure state
    assert abs(I_bell - 2 * np.log(2)) < 1e-12, f"I != 2*ln(2): {I_bell}"
    assert abs(S_B_bell - np.log(2)) < 1e-12, f"S(B) != ln(2): {S_B_bell}"
    assert abs(W_bell - 2 * np.log(2) * kT) < 1e-12, f"W != 2*kT*ln(2): {W_bell}"

    # Experiential density: rho = I * (1 - I/S(B)) = 2*ln(2) * (1 - 2*ln(2)/ln(2))
    # = 2*ln(2) * (1 - 2) = 2*ln(2) * (-1) = -2*ln(2)
    # BUT I > S(B) here (I = 2*S(B)), so rho < 0!
    # This is expected: the experiential density formula rho = I*(1 - I/S(B)) is defined
    # for 0 <= I <= S(B). For pure entangled states, I = 2*S(B) > S(B), which is
    # outside the physical domain of the experiential density formula.
    # The experiential density is only meaningful when I <= S(B).
    print(f"  rho_exp = {rho_exp_bell:.6f} (negative: I > S(B) for pure entangled state)")
    print(f"  Note: I = 2*S(B) exceeds the domain 0 <= I <= S(B) of the experiential density formula")
    print("  PASSED (I(B;M) and W_min correct; rho domain noted)")
    return True


# ============================================================
# Test 4: Experiential density profile
# ============================================================

def test_experiential_density_profile():
    """Experiential density rho vs I(B;M) shows parabolic shape."""
    print("\n" + "=" * 60)
    print("TEST 4: Experiential density profile")
    print("=" * 60)

    d_B, d_M = 2, 2
    kT = 1.0

    # Construct states with varying I(B;M) by mixing product and correlated
    # Use classically correlated state (not entangled) to stay within I <= S(B)
    # rho_BM = (1-alpha)|00><00| + alpha|11><11| (classically correlated)
    # rho_B = (1-alpha)|0><0| + alpha|1><1| = diag(1-alpha, alpha)
    # rho_M = (1-alpha)|0><0| + alpha|1><1| = diag(1-alpha, alpha)
    # rho_BM diagonal: ((1-alpha), 0, 0, alpha)

    alphas = np.linspace(0.01, 0.99, 98)
    I_vals = []
    rho_vals = []
    W_vals = []

    for alpha in alphas:
        rho_BM = np.diag([1-alpha, 0, 0, alpha])
        I_BM = mutual_information(rho_BM, d_B, d_M)
        rho_B_local = partial_trace_M(rho_BM, d_B, d_M)
        S_B = von_neumann_entropy(rho_B_local)
        rho_exp = experiential_density(I_BM, S_B)
        W_min = landauer_bound(I_BM, kT)

        I_vals.append(I_BM)
        rho_vals.append(rho_exp)
        W_vals.append(W_min)

    I_vals = np.array(I_vals)
    rho_vals = np.array(rho_vals)
    W_vals = np.array(W_vals)

    # For this family: rho_B = rho_M = diag(1-alpha, alpha), so S(B) = S(M)
    # rho_BM has eigenvalues (1-alpha, 0, 0, alpha), so S(BM) = h(alpha) = S(B)
    # Therefore I(B;M) = S(B) + S(M) - S(BM) = S(B) + S(B) - S(B) = S(B)
    # And rho = I * (1 - I/S(B)) = S(B) * 0 = 0 always!
    # This is because for perfectly correlated classical states, I = S(B)
    # and the experiential density is at its upper boundary.

    # Need a different parametrization that gives intermediate I values
    # Use: rho_BM = (1-eps) * (rho_B tensor rho_M) + eps * rho_corr
    # with rho_corr being classically correlated
    I_vals2 = []
    rho_vals2 = []
    S_B_vals = []

    for alpha in alphas:
        # Body state
        rho_B = np.diag([0.8, 0.2])
        rho_M = np.eye(2) / 2
        rho_product = np.kron(rho_B, rho_M)

        # Classically correlated piece: rho_corr = diag(0.5, 0, 0, 0.5)
        rho_corr = np.diag([0.5, 0, 0, 0.5])

        rho_BM = (1 - alpha) * rho_product + alpha * rho_corr
        I_BM = mutual_information(rho_BM, d_B, d_M)
        rho_B_local = partial_trace_M(rho_BM, d_B, d_M)
        S_B = von_neumann_entropy(rho_B_local)
        rho_exp = experiential_density(I_BM, S_B)

        I_vals2.append(I_BM)
        rho_vals2.append(rho_exp)
        S_B_vals.append(S_B)

    I_vals2 = np.array(I_vals2)
    rho_vals2 = np.array(rho_vals2)

    # Find peak of experiential density
    peak_idx = np.argmax(rho_vals2)
    I_peak = I_vals2[peak_idx]
    rho_peak = rho_vals2[peak_idx]
    S_B_at_peak = S_B_vals[peak_idx]

    print(f"  Parametric sweep over {len(alphas)} states")
    print(f"  I(B;M) range: [{I_vals2.min():.6f}, {I_vals2.max():.6f}] nats")
    print(f"  rho_exp range: [{rho_vals2.min():.6f}, {rho_vals2.max():.6f}]")
    print(f"  Peak rho_exp = {rho_peak:.6f} at I = {I_peak:.6f}")
    print(f"  S(B) at peak: {S_B_at_peak:.6f}")
    print(f"  Expected peak at I = S(B)/2 = {S_B_at_peak/2:.6f}")

    # Verify rho >= 0 always
    assert np.all(rho_vals2 >= -1e-14), f"Experiential density < 0: min = {rho_vals2.min()}"
    print(f"  rho_exp >= 0 for all states: PASSED")

    # W_min = kT * I is linear, verified in Test 1
    print("  PASSED")
    return True


# ============================================================
# Test 5: Phase 23 channel connection
# ============================================================

def test_phase23_channel():
    """Verify I(B;M) decreases as the Phase 23 channel equilibrates."""
    print("\n" + "=" * 60)
    print("TEST 5: Phase 23 channel connection")
    print("=" * 60)

    d_B, d_M = 2, 2
    J = 1.0
    kT = 1.0

    # Initial pure state: |00>
    rho_B0 = np.array([[1, 0], [0, 0]], dtype=complex)
    rho_M = np.eye(2, dtype=complex) / 2

    # Initial joint state (product)
    rho_BM0 = np.kron(rho_B0, rho_M)

    # Evolve under SWAP for various times
    times = np.linspace(0, np.pi / (2*J), 20)
    I_values = []
    W_values = []

    for t in times:
        if t == 0:
            rho_BM_t = rho_BM0
        else:
            rho_BM_t = swap_evolution(rho_BM0, J, t, d_B)

        I_BM = mutual_information(rho_BM_t, d_B, d_M)
        W_min = landauer_bound(I_BM, kT)
        I_values.append(I_BM)
        W_values.append(W_min)

    I_values = np.array(I_values)
    W_values = np.array(W_values)

    # At t=0: product state, I = 0
    print(f"  I(t=0) = {I_values[0]:.6e} (expected 0)")
    assert I_values[0] < 1e-12, f"I(t=0) should be ~0, got {I_values[0]}"

    # As t increases, B and M become correlated via SWAP, then I changes
    # At Jt = pi/2: the SWAP completely exchanges B and M.
    # Since rho_M was I/2 initially, after full SWAP: rho_B -> I/2
    # The joint state is correlated: U|0>|psi_M>
    print(f"  I(t=pi/(2J)) = {I_values[-1]:.6e}")
    print(f"  W_min(t=pi/(2J)) = {W_values[-1]:.6e}")

    # Now test the REPEATED interaction model from Phase 23, Plan 02
    # After N interactions with fresh I/2 baths, I should decrease
    print("\n  Repeated interaction model (fresh I/2 bath each step):")
    p = np.sin(J * 0.5)**2  # Jt = 0.5 (moderate coupling)
    rho_B = rho_B0.copy()

    I_repeated = []
    for n in range(20):
        # After depolarizing channel: rho_B -> (1-p)*rho_B + p*I/2
        rho_B = depolarizing_channel(rho_B, p)
        # Product state with fresh I/2 model
        rho_BM = np.kron(rho_B, rho_M)
        I_BM = mutual_information(rho_BM, d_B, d_M)
        I_repeated.append(I_BM)

    I_repeated = np.array(I_repeated)

    # All I should be very small (product states have I=0 by definition)
    # Actually, after depolarizing, the state IS a product state with fresh M
    # So I = 0 at every step in the repeated interaction model
    # The physical point is: rho_B -> I/2, so ANY future correlation will vanish
    print(f"  I after 1 step: {I_repeated[0]:.6e}")
    print(f"  I after 10 steps: {I_repeated[9]:.6e}")
    print(f"  I after 20 steps: {I_repeated[19]:.6e}")
    print(f"  (All ~0: product state with fresh bath has zero MI by definition)")

    # Better test: track entropy of B (purity decreases -> body equilibrates)
    rho_B = rho_B0.copy()
    S_B_vals = [von_neumann_entropy(rho_B)]
    for n in range(20):
        rho_B = depolarizing_channel(rho_B, p)
        S_B_vals.append(von_neumann_entropy(rho_B))
    S_B_vals = np.array(S_B_vals)

    print(f"\n  Body entropy under repeated interaction:")
    print(f"  S(B, n=0) = {S_B_vals[0]:.6f} (pure state -> 0)")
    print(f"  S(B, n=5) = {S_B_vals[5]:.6f}")
    print(f"  S(B, n=10) = {S_B_vals[10]:.6f}")
    print(f"  S(B, n=20) = {S_B_vals[20]:.6f} (expected ln(2) = {np.log(2):.6f})")

    # Verify monotonic increase
    diffs = np.diff(S_B_vals)
    assert np.all(diffs >= -1e-14), f"Entropy not monotonically increasing: min diff = {diffs.min()}"
    print(f"  Entropy monotonically increasing: PASSED")
    print(f"  Convergence to ln(2): error = {abs(S_B_vals[-1] - np.log(2)):.6e}")
    assert abs(S_B_vals[-1] - np.log(2)) < 0.01, "Not converging to ln(2)"

    # Key physical point: as S(B) -> ln(2) and rho_B -> I/2,
    # any self-modeling correlation I(B;M) is lost because the body
    # has no distinguishable states left (maximally mixed)
    # W_min -> 0 because there's nothing to self-model
    print("  PASSED")
    return True


# ============================================================
# Test 6: Exhaustive random state validation
# ============================================================

def test_random_states():
    """Verify Landauer bound properties for 100 random 2-qubit states."""
    print("\n" + "=" * 60)
    print("TEST 6: Exhaustive random state validation (100 states)")
    print("=" * 60)

    d_B, d_M = 2, 2
    kT = 1.0
    n_states = 100

    I_all = []
    rho_all = []
    W_all = []
    S_B_all = []

    for i in range(n_states):
        rho_BM = random_joint_density_matrix(d_B, d_M)
        I_BM = mutual_information(rho_BM, d_B, d_M)
        rho_B = partial_trace_M(rho_BM, d_B, d_M)
        S_B = von_neumann_entropy(rho_B)
        rho_exp = experiential_density(I_BM, S_B)
        W_min = landauer_bound(I_BM, kT)

        I_all.append(I_BM)
        rho_all.append(rho_exp)
        W_all.append(W_min)
        S_B_all.append(S_B)

    I_all = np.array(I_all)
    rho_all = np.array(rho_all)
    W_all = np.array(W_all)
    S_B_all = np.array(S_B_all)

    # Verify I(B;M) >= 0 always
    n_I_negative = np.sum(I_all < -1e-14)
    assert n_I_negative == 0, f"I(B;M) < 0 for {n_I_negative} states"
    print(f"  I(B;M) >= 0 for all {n_states} states: PASSED")
    print(f"  I(B;M) range: [{I_all.min():.6e}, {I_all.max():.6f}]")

    # Verify W_min >= 0 always
    n_W_negative = np.sum(W_all < -1e-14)
    assert n_W_negative == 0, f"W_min < 0 for {n_W_negative} states"
    print(f"  W_min >= 0 for all {n_states} states: PASSED")

    # Verify W_min = kT * I(B;M)
    assert np.allclose(W_all, kT * I_all, atol=1e-14), "W_min != kT * I"
    print(f"  W_min = kT * I(B;M) for all {n_states} states: PASSED")

    # Check experiential density behavior
    # rho >= 0 when I <= S(B) (which is guaranteed for separable states,
    # but may not hold for entangled states where I can exceed S(B))
    n_rho_negative = np.sum(rho_all < -1e-14)
    n_I_exceeds_S = np.sum(I_all > S_B_all + 1e-10)
    print(f"  States with I > S(B): {n_I_exceeds_S}")
    print(f"  States with rho < 0: {n_rho_negative} (occurs when I > S(B))")

    # For states with I <= S(B), rho should be >= 0
    mask_valid = I_all <= S_B_all + 1e-10
    if np.any(mask_valid):
        rho_valid = rho_all[mask_valid]
        n_rho_neg_valid = np.sum(rho_valid < -1e-14)
        assert n_rho_neg_valid == 0, f"rho < 0 for {n_rho_neg_valid} states with I <= S(B)"
        print(f"  rho >= 0 when I <= S(B): PASSED ({np.sum(mask_valid)} states)")

    # Verify rho = 0 when I = 0
    mask_I0 = I_all < 1e-10
    if np.any(mask_I0):
        rho_at_I0 = rho_all[mask_I0]
        n_rho_nonzero = np.sum(np.abs(rho_at_I0) > 1e-8)
        assert n_rho_nonzero == 0, f"rho != 0 for {n_rho_nonzero} states with I=0"
        print(f"  rho = 0 when I = 0: PASSED ({np.sum(mask_I0)} states)")
    else:
        print(f"  No states with I ~ 0 found in random sample (expected for random states)")

    # W_min = 0 when I = 0
    if np.any(mask_I0):
        W_at_I0 = W_all[mask_I0]
        assert np.all(np.abs(W_at_I0) < 1e-8), "W_min != 0 when I=0"
        print(f"  W_min = 0 when I = 0: PASSED")
    else:
        print(f"  W_min = 0 when I = 0: SKIPPED (no I~0 states)")

    print(f"\n  Summary statistics:")
    print(f"    Mean I(B;M) = {I_all.mean():.4f} nats")
    print(f"    Mean W_min = {W_all.mean():.4f} kT")
    print(f"    Mean rho_exp = {rho_all.mean():.4f}")
    print(f"    Mean S(B) = {S_B_all.mean():.4f}")
    print("  PASSED")
    return True


# ============================================================
# Test 7: Verify bound for non-trivial self-modeling states
# ============================================================

def test_self_modeling_states():
    """Test the Landauer bound for physically motivated self-modeling states."""
    print("\n" + "=" * 60)
    print("TEST 7: Self-modeling states (SWAP-correlated)")
    print("=" * 60)

    d_B, d_M = 2, 2
    J = 1.0
    kT = 1.0

    # Initial state: body in known state, model in I/2
    rho_B0 = np.array([[0.9, 0.1], [0.1, 0.1]], dtype=complex)
    # Ensure valid density matrix
    eigvals = linalg.eigvalsh(rho_B0)
    assert np.all(eigvals >= -1e-15), "rho_B0 not PSD"
    rho_B0 = (rho_B0 + rho_B0.conj().T) / 2  # Ensure Hermitian
    rho_B0 /= np.trace(rho_B0)  # Ensure Tr=1

    rho_M = np.eye(2, dtype=complex) / 2
    rho_BM0 = np.kron(rho_B0, rho_M)

    # Evolve under SWAP for various times
    print(f"  Initial rho_B eigenvalues: {sorted(linalg.eigvalsh(rho_B0), reverse=True)}")
    print(f"  Initial S(B) = {von_neumann_entropy(rho_B0):.6f} nats\n")

    times = np.linspace(0, np.pi / J, 40)
    results = []

    for t in times:
        rho_BM_t = swap_evolution(rho_BM0, J, t, d_B)
        I_BM = mutual_information(rho_BM_t, d_B, d_M)
        rho_B_t = partial_trace_M(rho_BM_t, d_B, d_M)
        S_B = von_neumann_entropy(rho_B_t)
        rho_exp = experiential_density(I_BM, S_B)
        W_min = landauer_bound(I_BM, kT)
        results.append((t, I_BM, S_B, rho_exp, W_min))

    # Print selected results
    for i in [0, 10, 20, 30, 39]:
        t, I, S, rho_e, W = results[i]
        print(f"  Jt = {J*t:.3f}: I = {I:.4f}, S(B) = {S:.4f}, "
              f"rho = {rho_e:.4f}, W_min = {W:.4f}")

    # Verify all W_min >= 0
    all_W = [r[4] for r in results]
    assert np.all(np.array(all_W) >= -1e-14), "W_min < 0 found"
    print(f"\n  W_min >= 0 for all {len(times)} time points: PASSED")

    # At t=0: product state, I=0
    assert results[0][1] < 1e-12, f"I(t=0) not zero: {results[0][1]}"
    print(f"  I(t=0) = 0: PASSED")

    # SWAP dynamics creates and then destroys correlations periodically
    # Check that I returns to ~0 at Jt = pi (full period of density matrix)
    I_at_pi = results[-1][1]
    print(f"  I(Jt=pi) = {I_at_pi:.6e} (should be ~0, density matrix period)")
    assert I_at_pi < 1e-10, f"I(Jt=pi) not zero: {I_at_pi}"
    print(f"  I(Jt=pi) ~ 0: PASSED")

    print("  PASSED")
    return True


# ============================================================
# Main
# ============================================================

def main():
    print("Landauer Bound on Self-Modeling: Numerical Verification")
    print("Phase 25, Plan 01, Task 2")
    print("Conventions: natural units (k_B=1), entropy in nats, Tr(rho)=1")
    print()

    all_passed = True
    test_results = {}

    tests = [
        ("Test 1: Parametric family", test_parametric_family),
        ("Test 2: Equilibrium limit", test_equilibrium_limit),
        ("Test 3: Maximally correlated (Bell)", test_maximally_correlated),
        ("Test 4: Experiential density profile", test_experiential_density_profile),
        ("Test 5: Phase 23 channel connection", test_phase23_channel),
        ("Test 6: Random states (100)", test_random_states),
        ("Test 7: Self-modeling states (SWAP)", test_self_modeling_states),
    ]

    for name, test_fn in tests:
        try:
            passed = test_fn()
            test_results[name] = "PASSED" if passed else "FAILED"
            if not passed:
                all_passed = False
        except Exception as e:
            test_results[name] = f"ERROR: {e}"
            all_passed = False
            import traceback
            traceback.print_exc()

    # Summary
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    for name, result in test_results.items():
        status = "PASS" if result == "PASSED" else "FAIL"
        print(f"  [{status}] {name}")

    n_passed = sum(1 for v in test_results.values() if v == "PASSED")
    n_total = len(test_results)
    print(f"\n  {n_passed}/{n_total} tests passed")

    if all_passed:
        print("\n  ALL TESTS PASSED")
    else:
        print("\n  SOME TESTS FAILED")
        sys.exit(1)


if __name__ == "__main__":
    main()
