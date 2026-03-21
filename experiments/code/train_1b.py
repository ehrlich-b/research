#!/usr/bin/env python3
"""Phase 1b: Premakumar Reproduction

MNIST classification + self-prediction head. Tests whether self-prediction
changes the algebraic structure of weight matrices.

Key comparison: w_self=0 (no self-prediction) vs w_self>0.
If algebra metrics differ, self-prediction constrains the algebra.
"""

import sys
import os
import json
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader
import torchvision
import torchvision.transforms as transforms

sys.path.insert(0, os.path.dirname(__file__))
from models import SelfModelingMLP
from metrics import measure_all, save_results, print_summary

RESULTS_DIR = os.path.join(os.path.dirname(__file__), 'results', '1b')
os.makedirs(RESULTS_DIR, exist_ok=True)

# Architecture
HIDDEN_DIM = 256
BOTTLENECK_DIM = 64
INPUT_DIM = 784
OUTPUT_DIM = 10

# Training
EPOCHS = 50
BATCH_SIZE = 128
LR = 1e-3
MEASURE_EVERY = 5  # epochs

# Device
if torch.backends.mps.is_available():
    DEVICE = torch.device('mps')
elif torch.cuda.is_available():
    DEVICE = torch.device('cuda')
else:
    DEVICE = torch.device('cpu')


def get_mnist(data_dir='./data'):
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,)),
        transforms.Lambda(lambda x: x.view(-1)),  # flatten to 784
    ])
    train = torchvision.datasets.MNIST(data_dir, train=True, download=True,
                                       transform=transform)
    test = torchvision.datasets.MNIST(data_dir, train=False, download=True,
                                      transform=transform)
    train_loader = DataLoader(train, batch_size=BATCH_SIZE, shuffle=True)
    test_loader = DataLoader(test, batch_size=BATCH_SIZE, shuffle=False)
    return train_loader, test_loader


def train_epoch(model, loader, optimizer, w_task, w_self, device):
    model.train()
    total_loss = 0
    task_loss_sum = 0
    self_loss_sum = 0
    correct = 0
    total = 0

    ce_loss = nn.CrossEntropyLoss()

    for data, target in loader:
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()

        logits, h2_pred, h2_target = model(data)

        # Task loss
        l_task = ce_loss(logits, target)

        # Self-prediction loss (normalized by hidden dim)
        if w_self > 0:
            l_self = torch.mean((h2_pred - h2_target) ** 2)
        else:
            l_self = torch.tensor(0.0, device=device)

        loss = w_task * l_task + w_self * l_self
        loss.backward()
        optimizer.step()

        total_loss += loss.item() * data.size(0)
        task_loss_sum += l_task.item() * data.size(0)
        self_loss_sum += l_self.item() * data.size(0)
        correct += (logits.argmax(1) == target).sum().item()
        total += data.size(0)

    n = total
    return {
        'total_loss': total_loss / n,
        'task_loss': task_loss_sum / n,
        'self_loss': self_loss_sum / n,
        'train_acc': correct / n,
    }


def evaluate(model, loader, device):
    model.eval()
    correct = 0
    total = 0
    with torch.no_grad():
        for data, target in loader:
            data, target = data.to(device), target.to(device)
            logits, _, _ = model(data)
            correct += (logits.argmax(1) == target).sum().item()
            total += data.size(0)
    return correct / total


def run_experiment(w_self, seed, train_loader, test_loader):
    run_name = f'ws{w_self}_seed{seed}'
    run_dir = os.path.join(RESULTS_DIR, run_name)
    os.makedirs(run_dir, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"Run: w_self={w_self}, seed={seed}")
    print(f"{'='*60}")

    torch.manual_seed(seed)
    np.random.seed(seed)

    model = SelfModelingMLP(INPUT_DIM, OUTPUT_DIM, HIDDEN_DIM, BOTTLENECK_DIM)
    model = model.to(DEVICE)
    optimizer = optim.Adam(model.parameters(), lr=LR)

    history = []
    measurements = []

    # Measure at epoch 0 (before training)
    model_cpu = SelfModelingMLP(INPUT_DIM, OUTPUT_DIM, HIDDEN_DIM, BOTTLENECK_DIM)
    model_cpu.load_state_dict({k: v.cpu() for k, v in model.state_dict().items()})
    m = measure_all(model_cpu, method='compose')
    m['epoch'] = 0
    measurements.append(m)
    print(f"Epoch 0: dep_ratio={m['dependency_ratio']:.4f}, "
          f"cn_mean={np.mean(list(m['commutator_norms'].values())):.4f}")

    for epoch in range(1, EPOCHS + 1):
        stats = train_epoch(model, train_loader, optimizer, 1.0, w_self, DEVICE)
        test_acc = evaluate(model, test_loader, DEVICE)
        stats['test_acc'] = test_acc
        stats['epoch'] = epoch
        history.append(stats)

        if epoch % 10 == 0 or epoch == EPOCHS:
            print(f"Epoch {epoch}: loss={stats['total_loss']:.4f} "
                  f"(task={stats['task_loss']:.4f}, self={stats['self_loss']:.4f}) "
                  f"test_acc={test_acc:.4f}")

        if epoch % MEASURE_EVERY == 0 or epoch == EPOCHS:
            model_cpu.load_state_dict(
                {k: v.cpu() for k, v in model.state_dict().items()})
            m = measure_all(model_cpu, method='compose')
            m['epoch'] = epoch
            measurements.append(m)
            cn_mean = np.mean(list(m['commutator_norms'].values()))
            print(f"  -> dep_ratio={m['dependency_ratio']:.4f}, "
                  f"cn_mean={cn_mean:.4f}")

    # Save everything
    save_results(history, os.path.join(run_dir, 'history.json'))
    save_results(measurements, os.path.join(run_dir, 'measurements.json'))

    # Save final measurement with full detail
    final = measurements[-1]
    final['w_self'] = w_self
    final['seed'] = seed
    final['final_test_acc'] = history[-1]['test_acc']
    save_results(final, os.path.join(run_dir, 'final.json'))

    print_summary(final)
    return final


def main():
    print(f"Phase 1b: Premakumar Reproduction")
    print(f"Device: {DEVICE}")
    print(f"Hidden: {HIDDEN_DIM}, Bottleneck: {BOTTLENECK_DIM}")
    print(f"Epochs: {EPOCHS}, Batch: {BATCH_SIZE}, LR: {LR}")

    train_loader, test_loader = get_mnist()

    # Experiment matrix: w_self values x seeds
    w_self_values = [0.0, 0.1, 1.0, 10.0]
    seeds = [0, 1, 2]

    all_finals = []
    for w_self in w_self_values:
        for seed in seeds:
            final = run_experiment(w_self, seed, train_loader, test_loader)
            all_finals.append({
                'w_self': w_self,
                'seed': seed,
                'dependency_ratio': final['dependency_ratio'],
                'algebra_dimension': final['algebra_dimension'],
                'commutator_norms': final['commutator_norms'],
                'test_acc': final.get('final_test_acc', 0),
            })

    # Comparison summary
    print(f"\n{'='*60}")
    print(f"COMPARISON SUMMARY")
    print(f"{'='*60}")
    print(f"{'w_self':>8} {'dep_ratio':>12} {'cn_mean':>10} {'test_acc':>10}")
    print(f"{'-'*42}")

    for w_self in w_self_values:
        runs = [r for r in all_finals if r['w_self'] == w_self]
        dep_ratios = [r['dependency_ratio'] for r in runs]
        cn_means = [np.mean(list(r['commutator_norms'].values())) for r in runs]
        accs = [r['test_acc'] for r in runs]
        print(f"{w_self:>8.1f} {np.mean(dep_ratios):>12.4f} "
              f"{np.mean(cn_means):>10.4f} {np.mean(accs):>10.4f}")

    # Save comparison
    save_results(all_finals, os.path.join(RESULTS_DIR, 'comparison.json'))

    # Go/no-go analysis
    baseline = [r for r in all_finals if r['w_self'] == 0.0]
    sp_runs = [r for r in all_finals if r['w_self'] > 0]
    base_dep = np.mean([r['dependency_ratio'] for r in baseline])
    sp_dep = np.mean([r['dependency_ratio'] for r in sp_runs])
    base_cn = np.mean([np.mean(list(r['commutator_norms'].values()))
                       for r in baseline])
    sp_cn = np.mean([np.mean(list(r['commutator_norms'].values()))
                     for r in sp_runs])

    print(f"\nGO/NO-GO:")
    print(f"  Baseline (w_self=0): dep_ratio={base_dep:.4f}, cn={base_cn:.4f}")
    print(f"  Self-pred (w_self>0): dep_ratio={sp_dep:.4f}, cn={sp_cn:.4f}")

    dep_diff = abs(sp_dep - base_dep)
    cn_diff = abs(sp_cn - base_cn) / base_cn if base_cn > 0 else 0

    if dep_diff > 0.01 or cn_diff > 0.05:
        print(f"  SIGNAL: Self-prediction changes algebra "
              f"(dep_diff={dep_diff:.4f}, cn_diff={cn_diff:.2%})")
    else:
        print(f"  NO SIGNAL: Self-prediction doesn't measurably change algebra "
              f"(dep_diff={dep_diff:.4f}, cn_diff={cn_diff:.2%})")
        print(f"  Consider: higher depth, different threshold, or dynamics-based metrics")


if __name__ == '__main__':
    main()
