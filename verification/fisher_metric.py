"""
Quantum Fisher information metric on reduced states.

Phase: 32-fisher-geometry-on-reduced-states, Plan 01
Date: 2026-03-30

% ASSERT_CONVENTION: units=natural, lattice_spacing=1, fisher_metric=SLD,
%   normalization=g_F_equals_4_times_g_Bures, eigenvalue_threshold=1e-14,
%   boundary=OBC, coupling=J_gt_0_antiferromagnetic,
%   finite_difference=central_dx_equals_half

The SLD quantum Fisher information metric on a 1D parameterized family of
density matrices rho(x) is:

  g(x) = sum_{m,n: p_m+p_n > eps} 2 |<m| d_x rho |n>|^2 / (p_m + p_n)

where rho(x) = sum_m p_m |m><m| is the spectral decomposition and
d_x rho = (rho(x+1) - rho(x-1)) / 2 is the central finite difference.

Identity: g_SLD = 4 * g_Bures for full-rank states (Braunstein-Caves 1994).

References:
  Braunstein-Caves, PRL 72, 3439 (1994) -- SLD Fisher metric definition
  Zanardi et al., PRL 99, 100603 (2007) -- Fisher metric at QPT
  Safranek, PRA 95, 052320 (2017) -- rank-deficient handling

Environment: Python 3.11+, numpy >= 2.4, scipy >= 1.17
"""

import numpy as np
from scipy.sparse.linalg import eigsh

from ed_entanglement import (
    construct_heisenberg_1d,
    construct_tfi_1d,
    construct_self_modeling_1d,
    partial_trace,
    ground_state,
    EIGENVALUE_THRESHOLD,
)

# ============================================================================
# Core: reduced state sweep
# ============================================================================

def reduced_states_sweep(psi, N, subsystem_size, bc='obc'):
    """Compute rho_Lambda(x) at every lattice position x.

    For OBC: x = 0, 1, ..., N - subsystem_size.
    For PBC: x = 0, 1, ..., N - 1 (wrapping).

    Parameters
    ----------
    psi : ndarray, shape (2**N,)
        Ground state vector.
    N : int
        Number of sites.
    subsystem_size : int
        |Lambda| = number of contiguous sites in subsystem.
    bc : str
        'obc' or 'pbc'.

    Returns
    -------
    list of (x, rho_x) where rho_x is (2**subsystem_size, 2**subsystem_size)
    """
    results = []
    if bc == 'obc':
        positions = range(N - subsystem_size + 1)
    else:
        positions = range(N)

    for x in positions:
        if bc == 'obc':
            sites = list(range(x, x + subsystem_size))
        else:
            sites = [(x + k) % N for k in range(subsystem_size)]

        rho_x = partial_trace(psi, N, sites)

        # Verify trace = 1 and Hermiticity
        tr = np.trace(rho_x).real
        assert abs(tr - 1.0) < 1e-13, f"Trace(rho) = {tr} at x={x}"
        herm_err = np.max(np.abs(rho_x - rho_x.conj().T))
        assert herm_err < 1e-13, f"Hermiticity error {herm_err} at x={x}"

        # Verify positive semidefiniteness
        eigs = np.linalg.eigvalsh(rho_x)
        assert np.min(eigs) >= -1e-13, f"Negative eigenvalue {np.min(eigs)} at x={x}"

        results.append((x, rho_x))
    return results


# ============================================================================
# SLD quantum Fisher information metric
# ============================================================================

def compute_qfim(rho_list, threshold=EIGENVALUE_THRESHOLD):
    """Compute the SLD quantum Fisher information metric g(x) at interior points.

    Uses central finite difference for d_x rho and eigendecomposition of rho(x).

    Parameters
    ----------
    rho_list : list of (x, rho_x)
        From reduced_states_sweep.
    threshold : float
        Eigenvalue cutoff for SLD denominator: skip (m,n) pairs with p_m+p_n < threshold.

    Returns
    -------
    list of dict with keys:
        'x': int, position
        'g': float, Fisher metric scalar
        'eigenvalues': ndarray, eigenvalues of rho_x
        'rank': int, number of eigenvalues above threshold/2
    """
    # Build position -> rho mapping
    pos_rho = {x: rho for x, rho in rho_list}
    positions = sorted(pos_rho.keys())

    results = []
    for i, x in enumerate(positions):
        # Interior points only: need x-1 and x+1
        if x - 1 not in pos_rho or x + 1 not in pos_rho:
            continue

        rho_x = pos_rho[x]
        rho_xp = pos_rho[x + 1]
        rho_xm = pos_rho[x - 1]

        # Central finite difference: d_x rho = (rho_{x+1} - rho_{x-1}) / 2
        d_rho = (rho_xp - rho_xm) / 2.0

        # Eigendecompose rho_x
        eigenvalues, eigenvectors = np.linalg.eigh(rho_x)
        # eigenvectors[:, m] is the m-th eigenvector

        rank = int(np.sum(eigenvalues > threshold / 2))

        # Compute SLD Fisher metric
        # g(x) = sum_{m,n: p_m+p_n > threshold} 2 |<m|d_rho|n>|^2 / (p_m + p_n)
        d = rho_x.shape[0]
        g = 0.0
        for m in range(d):
            for n in range(d):
                denom = eigenvalues[m] + eigenvalues[n]
                if denom < threshold:
                    continue
                # <m| d_rho |n>
                mat_elem = eigenvectors[:, m].conj() @ d_rho @ eigenvectors[:, n]
                g += 2.0 * abs(mat_elem)**2 / denom

        results.append({
            'x': x,
            'g': g,
            'eigenvalues': eigenvalues,
            'rank': rank,
        })

    return results


# ============================================================================
# Bures metric (independent cross-check)
# ============================================================================

def _matrix_sqrt(A):
    """Compute matrix square root via eigendecomposition.

    A must be Hermitian positive semidefinite.
    """
    eigenvalues, eigenvectors = np.linalg.eigh(A)
    # Clip tiny negative eigenvalues from numerical noise
    eigenvalues = np.maximum(eigenvalues, 0.0)
    sqrt_eigs = np.sqrt(eigenvalues)
    return eigenvectors @ np.diag(sqrt_eigs) @ eigenvectors.conj().T


def _fidelity(rho, sigma):
    """Compute Uhlmann fidelity F(rho, sigma) = [Tr sqrt(sqrt(rho) sigma sqrt(rho))]^2."""
    sqrt_rho = _matrix_sqrt(rho)
    inner = sqrt_rho @ sigma @ sqrt_rho
    sqrt_inner = _matrix_sqrt(inner)
    F = np.trace(sqrt_inner).real ** 2
    return min(F, 1.0)  # numerical guard


def compute_bures_metric(rho_list):
    """Compute the Bures metric g_Bures(x) at interior points.

    To match the SLD central-difference convention, we compute the Bures
    distance between rho_{x-1} and rho_{x+1} (parameter separation 2a = 2):

      ds^2_B(x-1, x+1) = 2(1 - sqrt(F(rho_{x-1}, rho_{x+1})))
      g_Bures(x) = ds^2_B / (2a)^2 = ds^2_B / 4

    Then the cross-validation identity is: g_SLD(x) = 4 * g_Bures(x).

    Parameters
    ----------
    rho_list : list of (x, rho_x)

    Returns
    -------
    list of dict with keys 'x', 'g_bures'
    """
    pos_rho = {x: rho for x, rho in rho_list}
    positions = sorted(pos_rho.keys())

    results = []
    for x in positions:
        if x - 1 not in pos_rho or x + 1 not in pos_rho:
            continue

        rho_xm = pos_rho[x - 1]
        rho_xp = pos_rho[x + 1]

        F = _fidelity(rho_xm, rho_xp)
        ds2_bures = 2.0 * (1.0 - np.sqrt(F))

        # Parameter separation is 2a = 2, so metric = ds^2 / (2a)^2 = ds^2 / 4
        g_bures = ds2_bures / 4.0

        results.append({'x': x, 'g_bures': g_bures})

    return results


# ============================================================================
# Geodesic distance and distance ratios
# ============================================================================

def fisher_geodesic_distance(g_values, x1, x2):
    """Compute Fisher geodesic distance between positions x1 and x2.

    In 1D: d_Fisher(x1, x2) = sum_{x=x1}^{x2-1} sqrt(g(x)) * a
    where a = 1 (lattice spacing).

    For this to work, we need g(x) at positions x1, x1+1, ..., x2-1.
    We use the midpoint rule: the metric between x and x+1 is sqrt(g(x)).

    Parameters
    ----------
    g_values : dict mapping x -> g(x)
    x1, x2 : int, positions (x1 < x2)

    Returns
    -------
    float, geodesic distance
    """
    if x1 > x2:
        x1, x2 = x2, x1
    d = 0.0
    for x in range(x1, x2):
        if x in g_values:
            d += np.sqrt(g_values[x])
    return d


def compute_distance_ratios(g_values, bulk_positions):
    """Compute d_Fisher/d_lattice for all pairs of bulk positions.

    Parameters
    ----------
    g_values : dict mapping x -> g(x)
    bulk_positions : list of int, positions in the bulk

    Returns
    -------
    dict with 'ratios', 'mean', 'std', 'min', 'max', 'cv' (coefficient of variation)
    """
    ratios = []
    pairs = []
    for i, x1 in enumerate(bulk_positions):
        for x2 in bulk_positions[i + 1:]:
            d_lattice = abs(x2 - x1)
            d_fisher = fisher_geodesic_distance(g_values, x1, x2)
            ratio = d_fisher / d_lattice
            ratios.append(ratio)
            pairs.append((x1, x2))

    ratios = np.array(ratios)
    return {
        'ratios': ratios,
        'pairs': pairs,
        'mean': float(np.mean(ratios)),
        'std': float(np.std(ratios)),
        'min': float(np.min(ratios)),
        'max': float(np.max(ratios)),
        'cv': float(np.std(ratios) / np.mean(ratios)) if np.mean(ratios) > 0 else float('inf'),
    }


# ============================================================================
# Convenience: full pipeline for a given Hamiltonian
# ============================================================================

def compute_fisher_pipeline(H, N, subsystem_size, bc='obc', threshold=EIGENVALUE_THRESHOLD):
    """Full pipeline: ground state -> reduced states -> Fisher metric + Bures cross-check.

    Returns
    -------
    dict with keys:
        'E0': ground state energy
        'rho_list': list of (x, rho_x)
        'qfim': list of QFIM results
        'bures': list of Bures results
        'g_values': dict x -> g(x)
    """
    E0, psi = ground_state(H)

    rho_list = reduced_states_sweep(psi, N, subsystem_size, bc=bc)
    qfim = compute_qfim(rho_list, threshold=threshold)
    bures = compute_bures_metric(rho_list)

    g_values = {r['x']: r['g'] for r in qfim}

    return {
        'E0': E0,
        'rho_list': rho_list,
        'qfim': qfim,
        'bures': bures,
        'g_values': g_values,
    }
