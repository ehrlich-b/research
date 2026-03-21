#!/usr/bin/env python3
"""Visualization for self-modeling experiments.

Generates comparison plots across phases and w_self values.
"""

import sys
import os
import json
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

RESULTS_BASE = os.path.join(os.path.dirname(__file__), 'results')


def load_json(path):
    with open(path) as f:
        return json.load(f)


def plot_1b_trajectories():
    """Plot algebra metrics over training for Phase 1b runs."""
    results_dir = os.path.join(RESULTS_BASE, '1b')
    if not os.path.isdir(results_dir):
        print("No Phase 1b results found")
        return

    fig, axes = plt.subplots(2, 2, figsize=(14, 10))

    w_self_values = [0.0, 0.1, 1.0, 10.0]
    colors = {0.0: '#333333', 0.1: '#2196F3', 1.0: '#4CAF50', 10.0: '#F44336'}
    seeds = [0, 1, 2]

    for w_self in w_self_values:
        dep_trajectories = []
        cn_trajectories = []
        acc_trajectories = []
        std_trajectories = []

        for seed in seeds:
            run_dir = os.path.join(results_dir, f'ws{w_self}_seed{seed}')
            mpath = os.path.join(run_dir, 'measurements.json')
            hpath = os.path.join(run_dir, 'history.json')
            if not os.path.exists(mpath):
                continue

            measurements = load_json(mpath)
            epochs = [m['episode'] if 'episode' in m else m['epoch']
                      for m in measurements]
            deps = [m['dependency_ratio'] for m in measurements]
            cns = [np.mean(list(m['commutator_norms'].values()))
                   for m in measurements]

            dep_trajectories.append((epochs, deps))
            cn_trajectories.append((epochs, cns))

            # Weight stats over time
            stds = []
            for m in measurements:
                ws = m.get('weight_stats', {})
                if ws:
                    stds.append(np.mean([s['std'] for s in ws.values()]))
            std_trajectories.append((epochs[:len(stds)], stds))

            if os.path.exists(hpath):
                history = load_json(hpath)
                h_epochs = [h['epoch'] for h in history]
                h_acc = [h['test_acc'] for h in history]
                acc_trajectories.append((h_epochs, h_acc))

        label = f'w_self={w_self}'
        color = colors[w_self]

        # Plot dependency ratio
        for epochs, deps in dep_trajectories:
            axes[0, 0].plot(epochs, deps, color=color, alpha=0.3)
        if dep_trajectories:
            mean_deps = np.mean([d for _, d in dep_trajectories], axis=0)
            mean_epochs = dep_trajectories[0][0]
            axes[0, 0].plot(mean_epochs, mean_deps, color=color,
                           linewidth=2, label=label)

        # Plot commutator norms
        for epochs, cns in cn_trajectories:
            axes[0, 1].plot(epochs, cns, color=color, alpha=0.3)
        if cn_trajectories:
            mean_cns = np.mean([c for _, c in cn_trajectories], axis=0)
            axes[0, 1].plot(mean_epochs, mean_cns, color=color,
                           linewidth=2, label=label)

        # Plot weight std
        for epochs, stds in std_trajectories:
            axes[1, 0].plot(epochs, stds, color=color, alpha=0.3)
        if std_trajectories:
            min_len = min(len(s) for _, s in std_trajectories)
            mean_stds = np.mean([s[:min_len] for _, s in std_trajectories],
                               axis=0)
            axes[1, 0].plot(std_trajectories[0][0][:min_len], mean_stds,
                           color=color, linewidth=2, label=label)

        # Plot test accuracy
        for epochs, accs in acc_trajectories:
            axes[1, 1].plot(epochs, accs, color=color, alpha=0.3)
        if acc_trajectories:
            min_len = min(len(a) for _, a in acc_trajectories)
            mean_accs = np.mean([a[:min_len] for _, a in acc_trajectories],
                               axis=0)
            axes[1, 1].plot(acc_trajectories[0][0][:min_len], mean_accs,
                           color=color, linewidth=2, label=label)

    axes[0, 0].set_title('Dependency Ratio (1.0 = no constraints)')
    axes[0, 0].set_xlabel('Epoch')
    axes[0, 0].set_ylabel('dim / num_products')
    axes[0, 0].legend()

    axes[0, 1].set_title('Commutator Norms')
    axes[0, 1].set_xlabel('Epoch')
    axes[0, 1].set_ylabel('Normalized ||[W_i, W_j]||')
    axes[0, 1].legend()

    axes[1, 0].set_title('Mean Weight Std')
    axes[1, 0].set_xlabel('Epoch')
    axes[1, 0].set_ylabel('std')
    axes[1, 0].legend()

    axes[1, 1].set_title('Test Accuracy')
    axes[1, 1].set_xlabel('Epoch')
    axes[1, 1].set_ylabel('Accuracy')
    axes[1, 1].legend()

    plt.suptitle('Phase 1b: MNIST + Self-Prediction', fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(results_dir, 'trajectories.png')
    plt.savefig(outpath, dpi=150)
    plt.close()
    print(f"Saved: {outpath}")


def plot_singular_value_comparison():
    """Compare singular value spectra across phases at final checkpoint."""
    fig, ax = plt.subplots(1, 1, figsize=(10, 6))

    # Phase 1a
    p1a = os.path.join(RESULTS_BASE, '1a', 'seed_0.json')
    if os.path.exists(p1a):
        data = load_json(p1a)
        sv = data.get('singular_values', [])
        if sv:
            ax.plot(range(len(sv)), sv, label='1a: Random', color='gray',
                    linewidth=2)

    # Phase 1b: w_self=0 and w_self=1
    for w_self, color, style in [(0.0, '#333333', '--'),
                                  (1.0, '#4CAF50', '-')]:
        path = os.path.join(RESULTS_BASE, '1b',
                           f'ws{w_self}_seed0', 'final.json')
        if os.path.exists(path):
            data = load_json(path)
            sv = data.get('singular_values', [])
            if sv:
                ax.plot(range(len(sv)), sv,
                       label=f'1b: w_self={w_self}', color=color,
                       linewidth=2, linestyle=style)

    # Phase 1c: w_self=1
    path = os.path.join(RESULTS_BASE, '1c', 'ws1.0_seed0', 'final.json')
    if os.path.exists(path):
        data = load_json(path)
        sv = data.get('singular_values', [])
        if sv:
            ax.plot(range(len(sv)), sv,
                   label='1c: Poker frozen, w_self=1', color='#FF9800',
                   linewidth=2)

    # Phase 2: w_self=1
    path = os.path.join(RESULTS_BASE, '2', 'ws1.0_seed0', 'final_a.json')
    if os.path.exists(path):
        data = load_json(path)
        sv = data.get('singular_values', [])
        if sv:
            ax.plot(range(len(sv)), sv,
                   label='2: Competitive, w_self=1', color='#9C27B0',
                   linewidth=2)

    ax.set_xlabel('Singular Value Index')
    ax.set_ylabel('Singular Value')
    ax.set_title('Algebra Product Matrix Singular Values')
    ax.set_yscale('log')
    ax.legend()
    plt.tight_layout()

    outpath = os.path.join(RESULTS_BASE, 'sv_comparison.png')
    plt.savefig(outpath, dpi=150)
    plt.close()
    print(f"Saved: {outpath}")


def plot_phase2_trajectories():
    """Plot algebra metrics over training for Phase 2 dual-network runs."""
    results_dir = os.path.join(RESULTS_BASE, '2')
    if not os.path.isdir(results_dir):
        print("No Phase 2 results found")
        return

    fig, axes = plt.subplots(2, 2, figsize=(14, 10))

    w_self_values = [0.0, 0.1, 1.0, 10.0]
    colors = {0.0: '#333333', 0.1: '#2196F3', 1.0: '#4CAF50', 10.0: '#F44336'}
    seeds = [0, 1, 2]

    for w_self in w_self_values:
        dep_trajectories = []
        cn_trajectories = []
        std_trajectories = []

        for seed in seeds:
            run_dir = os.path.join(results_dir, f'ws{w_self}_seed{seed}')
            # Average A and B networks
            for suffix in ['a', 'b']:
                mpath = os.path.join(run_dir, f'measurements_{suffix}.json')
                if not os.path.exists(mpath):
                    continue

                measurements = load_json(mpath)
                epochs = [m['episode'] if 'episode' in m else m['epoch']
                          for m in measurements]
                deps = [m['dependency_ratio'] for m in measurements]
                cns = [np.mean(list(m['commutator_norms'].values()))
                       for m in measurements]

                dep_trajectories.append((epochs, deps))
                cn_trajectories.append((epochs, cns))

                stds = []
                for m in measurements:
                    ws = m.get('weight_stats', {})
                    if ws:
                        stds.append(np.mean([s['std'] for s in ws.values()]))
                std_trajectories.append((epochs[:len(stds)], stds))

        label = f'w_self={w_self}'
        color = colors[w_self]

        for epochs, deps in dep_trajectories:
            axes[0, 0].plot(epochs, deps, color=color, alpha=0.3)
        if dep_trajectories:
            min_len = min(len(d) for _, d in dep_trajectories)
            mean_deps = np.mean([d[:min_len] for _, d in dep_trajectories],
                               axis=0)
            axes[0, 0].plot(dep_trajectories[0][0][:min_len], mean_deps,
                           color=color, linewidth=2, label=label)

        for epochs, cns in cn_trajectories:
            axes[0, 1].plot(epochs, cns, color=color, alpha=0.3)
        if cn_trajectories:
            min_len = min(len(c) for _, c in cn_trajectories)
            mean_cns = np.mean([c[:min_len] for _, c in cn_trajectories],
                              axis=0)
            axes[0, 1].plot(cn_trajectories[0][0][:min_len], mean_cns,
                           color=color, linewidth=2, label=label)

        for epochs, stds in std_trajectories:
            axes[1, 0].plot(epochs, stds, color=color, alpha=0.3)
        if std_trajectories:
            min_len = min(len(s) for _, s in std_trajectories)
            mean_stds = np.mean([s[:min_len] for _, s in std_trajectories],
                               axis=0)
            axes[1, 0].plot(std_trajectories[0][0][:min_len], mean_stds,
                           color=color, linewidth=2, label=label)

    axes[0, 0].set_title('Dependency Ratio (1.0 = no constraints)')
    axes[0, 0].set_xlabel('Episode')
    axes[0, 0].set_ylabel('dim / num_products')
    axes[0, 0].legend()

    axes[0, 1].set_title('Commutator Norms')
    axes[0, 1].set_xlabel('Episode')
    axes[0, 1].set_ylabel('Normalized ||[W_i, W_j]||')
    axes[0, 1].legend()

    axes[1, 0].set_title('Mean Weight Std')
    axes[1, 0].set_xlabel('Episode')
    axes[1, 0].set_ylabel('std')
    axes[1, 0].legend()

    # Leave bottom-right empty (no single accuracy metric for poker)
    axes[1, 1].axis('off')
    axes[1, 1].text(0.5, 0.5, 'Poker: no single\naccuracy metric',
                    ha='center', va='center', fontsize=12, color='gray',
                    transform=axes[1, 1].transAxes)

    plt.suptitle('Phase 2: Competitive Poker + Self-Prediction', fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(results_dir, 'trajectories.png')
    plt.savefig(outpath, dpi=150)
    plt.close()
    print(f"Saved: {outpath}")


def plot_1c_vs_2_comparison():
    """Key comparison: frozen opponent (1c) vs learning opponent (2).

    This is the money plot - competition is the independent variable.
    Shows dependency ratio and commutator norms side by side, grouped by w_self.
    """
    p1c = os.path.join(RESULTS_BASE, '1c', 'comparison.json')
    p2 = os.path.join(RESULTS_BASE, '2', 'comparison.json')

    if not os.path.exists(p1c) and not os.path.exists(p2):
        print("No Phase 1c or Phase 2 results for comparison")
        return

    data_1c = load_json(p1c) if os.path.exists(p1c) else []
    data_2 = load_json(p2) if os.path.exists(p2) else []

    # Collect w_self values present in either phase
    ws_set = sorted(set(
        [r['w_self'] for r in data_1c] + [r['w_self'] for r in data_2]
    ))

    if not ws_set:
        print("No data to compare")
        return

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))
    bar_width = 0.35

    dep_1c, dep_2 = [], []
    cn_1c, cn_2 = [], []
    dep_1c_err, dep_2_err = [], []
    cn_1c_err, cn_2_err = [], []
    labels = []

    for w in ws_set:
        runs_1c = [r for r in data_1c if r['w_self'] == w]
        runs_2 = [r for r in data_2 if r['w_self'] == w]

        labels.append(f'w_self={w}')

        if runs_1c:
            deps = [r['dependency_ratio'] for r in runs_1c]
            cns = [np.mean(list(r['commutator_norms'].values()))
                   for r in runs_1c]
            dep_1c.append(np.mean(deps))
            dep_1c_err.append(np.std(deps))
            cn_1c.append(np.mean(cns))
            cn_1c_err.append(np.std(cns))
        else:
            dep_1c.append(0)
            dep_1c_err.append(0)
            cn_1c.append(0)
            cn_1c_err.append(0)

        if runs_2:
            # Average across both A and B networks
            deps = [r['dependency_ratio'] for r in runs_2]
            cns = [np.mean(list(r['commutator_norms'].values()))
                   for r in runs_2]
            dep_2.append(np.mean(deps))
            dep_2_err.append(np.std(deps))
            cn_2.append(np.mean(cns))
            cn_2_err.append(np.std(cns))
        else:
            dep_2.append(0)
            dep_2_err.append(0)
            cn_2.append(0)
            cn_2_err.append(0)

    x = np.arange(len(labels))

    ax1.bar(x - bar_width / 2, dep_1c, bar_width, yerr=dep_1c_err,
            label='1c: Frozen opponent', color='#FF9800', alpha=0.8,
            capsize=4)
    ax1.bar(x + bar_width / 2, dep_2, bar_width, yerr=dep_2_err,
            label='2: Learning opponent', color='#9C27B0', alpha=0.8,
            capsize=4)
    ax1.set_xticks(x)
    ax1.set_xticklabels(labels)
    ax1.set_ylabel('Dependency Ratio')
    ax1.set_title('Algebraic Constraints\n(lower = more constraints)')
    ax1.axhline(y=1.0, color='gray', linestyle='--', alpha=0.5)
    ax1.legend()

    ax2.bar(x - bar_width / 2, cn_1c, bar_width, yerr=cn_1c_err,
            label='1c: Frozen opponent', color='#FF9800', alpha=0.8,
            capsize=4)
    ax2.bar(x + bar_width / 2, cn_2, bar_width, yerr=cn_2_err,
            label='2: Learning opponent', color='#9C27B0', alpha=0.8,
            capsize=4)
    ax2.set_xticks(x)
    ax2.set_xticklabels(labels)
    ax2.set_ylabel('Mean Commutator Norm')
    ax2.set_title('Non-Commutativity\n(lower = more commutative)')
    ax2.legend()

    plt.suptitle('Competition Effect: Frozen vs Learning Opponent', fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(RESULTS_BASE, '1c_vs_2_comparison.png')
    plt.savefig(outpath, dpi=150)
    plt.close()
    print(f"Saved: {outpath}")


def plot_phase_comparison_bars():
    """Bar chart comparing final metrics across all phases."""
    phases = {}

    # Phase 1a
    p1a = os.path.join(RESULTS_BASE, '1a', 'aggregate.json')
    if os.path.exists(p1a):
        data = load_json(p1a)
        phases['1a\nRandom'] = {
            'dep_ratio': data.get('dependency_ratio_mean', 1.0),
            'cn': data.get('commutator_norm_mean', 0),
        }

    # Phase 1b
    p1b = os.path.join(RESULTS_BASE, '1b', 'comparison.json')
    if os.path.exists(p1b):
        data = load_json(p1b)
        for w in [0.0, 1.0]:
            runs = [r for r in data if r['w_self'] == w]
            if runs:
                phases[f'1b\nw_s={w}'] = {
                    'dep_ratio': np.mean([r['dependency_ratio'] for r in runs]),
                    'cn': np.mean([np.mean(list(r['commutator_norms'].values()))
                                   for r in runs]),
                }

    # Phase 1c
    p1c = os.path.join(RESULTS_BASE, '1c', 'comparison.json')
    if os.path.exists(p1c):
        data = load_json(p1c)
        for w in [0.0, 1.0]:
            runs = [r for r in data if r['w_self'] == w]
            if runs:
                phases[f'1c\nw_s={w}'] = {
                    'dep_ratio': np.mean([r['dependency_ratio'] for r in runs]),
                    'cn': np.mean([np.mean(list(r['commutator_norms'].values()))
                                   for r in runs]),
                }

    # Phase 2
    p2 = os.path.join(RESULTS_BASE, '2', 'comparison.json')
    if os.path.exists(p2):
        data = load_json(p2)
        for w in [0.0, 1.0]:
            runs = [r for r in data if r['w_self'] == w]
            if runs:
                phases[f'2\nw_s={w}'] = {
                    'dep_ratio': np.mean([r['dependency_ratio'] for r in runs]),
                    'cn': np.mean([np.mean(list(r['commutator_norms'].values()))
                                   for r in runs]),
                }

    if not phases:
        print("No results to plot")
        return

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    names = list(phases.keys())
    x = range(len(names))

    deps = [phases[n]['dep_ratio'] for n in names]
    ax1.bar(x, deps, color='#2196F3', alpha=0.8)
    ax1.set_xticks(x)
    ax1.set_xticklabels(names, fontsize=9)
    ax1.set_ylabel('Dependency Ratio')
    ax1.set_title('Algebraic Constraints\n(lower = more constraints)')
    ax1.axhline(y=1.0, color='gray', linestyle='--', alpha=0.5,
                label='No constraints')
    ax1.legend()

    cns = [phases[n]['cn'] for n in names]
    ax2.bar(x, cns, color='#4CAF50', alpha=0.8)
    ax2.set_xticks(x)
    ax2.set_xticklabels(names, fontsize=9)
    ax2.set_ylabel('Mean Commutator Norm')
    ax2.set_title('Non-Commutativity\n(lower = more commutative)')
    baseline = np.sqrt(2.0 / 256)
    ax2.axhline(y=baseline, color='gray', linestyle='--', alpha=0.5,
                label=f'Random baseline ({baseline:.4f})')
    ax2.legend()

    plt.suptitle('Cross-Phase Comparison', fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(RESULTS_BASE, 'phase_comparison.png')
    plt.savefig(outpath, dpi=150)
    plt.close()
    print(f"Saved: {outpath}")


def main():
    os.makedirs(RESULTS_BASE, exist_ok=True)
    plot_1b_trajectories()
    plot_phase2_trajectories()
    plot_singular_value_comparison()
    plot_phase_comparison_bars()
    plot_1c_vs_2_comparison()
    print("\nDone.")


if __name__ == '__main__':
    main()
