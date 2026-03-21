#!/usr/bin/env python3
"""Phase 1a: Random Baseline

Initialize untrained networks, measure algebraic structure.
Validates the measurement pipeline and establishes baselines.

Expected results:
- Algebra dimension ~= N^2 (full algebra)
- Commutator norms ~= sqrt(2) (Bottcher-Wenzel bound)
- No block structure
"""

import sys
import os
import json
import numpy as np
import torch

sys.path.insert(0, os.path.dirname(__file__))
from models import SelfModelingMLP
from metrics import measure_all, save_results, print_summary, algebra_dimension_by_depth

RESULTS_DIR = os.path.join(os.path.dirname(__file__), 'results', '1a')
os.makedirs(RESULTS_DIR, exist_ok=True)

N_SEEDS = 10
HIDDEN_DIM = 256
BOTTLENECK_DIM = 64
INPUT_DIM = 784   # MNIST (matches Phase 1b)
OUTPUT_DIM = 10


def run_seed(seed):
    torch.manual_seed(seed)
    np.random.seed(seed)

    model = SelfModelingMLP(INPUT_DIM, OUTPUT_DIM, HIDDEN_DIM, BOTTLENECK_DIM)

    print(f"\n--- Seed {seed} ---")
    results = measure_all(model, method='compose')
    results['seed'] = seed
    results['hidden_dim'] = HIDDEN_DIM

    print_summary(results)

    # Also check depth convergence for first seed
    if seed == 0:
        from metrics import extract_algebra_matrices
        matrices, names = extract_algebra_matrices(model, method='compose')
        print("Algebra dimension by depth:")
        dims = algebra_dimension_by_depth(matrices, max_depth=5)
        for d, dim in dims.items():
            print(f"  depth {d}: {dim} / {HIDDEN_DIM**2}")
        results['dimension_by_depth'] = dims

    save_results(results, os.path.join(RESULTS_DIR, f'seed_{seed}.json'))
    return results


def main():
    print("Phase 1a: Random Baseline")
    print(f"Hidden dim: {HIDDEN_DIM}, Bottleneck: {BOTTLENECK_DIM}")
    print(f"Running {N_SEEDS} seeds...")

    all_results = []
    for seed in range(N_SEEDS):
        r = run_seed(seed)
        all_results.append(r)

    # Summary statistics across seeds
    dims = [r['algebra_dimension'] for r in all_results]
    dep_ratios = [r['dependency_ratio'] for r in all_results]
    cn_values = []
    for r in all_results:
        cn_values.extend(r['commutator_norms'].values())

    cn_baseline = np.sqrt(2.0 / HIDDEN_DIM)

    print(f"\n{'='*60}")
    print(f"AGGREGATE (n={N_SEEDS})")
    print(f"{'='*60}")
    print(f"Algebra dimension: {np.mean(dims):.1f} +/- {np.std(dims):.1f} "
          f"(num_products = {all_results[0]['num_products']})")
    print(f"Dependency ratio: {np.mean(dep_ratios):.4f} +/- "
          f"{np.std(dep_ratios):.4f} (1.0 = all independent)")
    print(f"Commutator norms: {np.mean(cn_values):.4f} +/- "
          f"{np.std(cn_values):.4f} (random baseline = {cn_baseline:.4f})")

    # Go/no-go: random matrices should have all products independent
    # and commutator norms near sqrt(2/N)
    mean_dep = np.mean(dep_ratios)
    mean_cn = np.mean(cn_values)
    cn_ratio = mean_cn / cn_baseline
    print(f"\nGO/NO-GO CHECK:")
    if mean_dep > 0.99:
        print(f"  Dependency ratio {mean_dep:.4f} > 0.99: PASS "
              f"(all products independent)")
    else:
        print(f"  Dependency ratio {mean_dep:.4f} < 0.99: FAIL "
              f"(unexpected dependencies)")

    if 0.9 < cn_ratio < 1.1:
        print(f"  Commutator norms {mean_cn:.4f} = {cn_ratio:.2f}x baseline: "
              f"PASS (near sqrt(2/N))")
    else:
        print(f"  Commutator norms {mean_cn:.4f} = {cn_ratio:.2f}x baseline: "
              f"FAIL (expected ~1.0x)")

    # Save aggregate
    aggregate = {
        'n_seeds': N_SEEDS,
        'hidden_dim': HIDDEN_DIM,
        'algebra_dim_mean': float(np.mean(dims)),
        'algebra_dim_std': float(np.std(dims)),
        'dependency_ratio_mean': float(mean_dep),
        'commutator_norm_mean': float(np.mean(cn_values)),
        'commutator_norm_std': float(np.std(cn_values)),
        'commutator_baseline': float(cn_baseline),
    }
    save_results(aggregate, os.path.join(RESULTS_DIR, 'aggregate.json'))


if __name__ == '__main__':
    main()
