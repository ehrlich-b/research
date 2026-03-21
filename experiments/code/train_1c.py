#!/usr/bin/env python3
"""Phase 1c: Poker + Frozen Opponent + Self-Prediction

Poker game provides non-trivial input. Opponent is frozen (no learning).
Self-prediction head forces self-modeling. No competitive pressure.

This is the key baseline for Phase 2: same architecture, same task,
but no arms race. The difference between 1c and 2 isolates the effect
of competition on algebraic structure.
"""

import sys
import os
import json
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim

sys.path.insert(0, os.path.dirname(__file__))
from models import PokerNetwork
from poker import ContinuousPoker
from metrics import measure_all, save_results, print_summary

RESULTS_DIR = os.path.join(os.path.dirname(__file__), 'results', '1c')
os.makedirs(RESULTS_DIR, exist_ok=True)

# Architecture
HIDDEN_DIM = 256
BOTTLENECK_DIM = 64

# Poker
MAX_BET = 10
N_BET_SIZES = 11
BATCH_GAMES = 256  # games per update

# Training
N_EPISODES = 10000
LR = 3e-4
ENTROPY_COEFF = 0.01
GRAD_CLIP = 1.0
MEASURE_EVERY = 500  # episodes

# Device
if torch.backends.mps.is_available():
    DEVICE = torch.device('mps')
elif torch.cuda.is_available():
    DEVICE = torch.device('cuda')
else:
    DEVICE = torch.device('cpu')


def play_batch(env, learner, opponent, device):
    """Play a batch of poker games. Returns game data for policy gradient.

    Returns dict with:
        log_probs: list of (batch,) tensors, one per street
        rewards: (batch,) tensor
        h2_preds: list of (batch, hidden) tensors
        h2_targets: list of (batch, hidden) tensors
        entropies: list of (batch,) tensors
    """
    obs_a, obs_b = env.reset(BATCH_GAMES)
    obs_a, obs_b = obs_a.to(device), obs_b.to(device)

    log_probs = []
    h2_preds = []
    h2_targets = []
    entropies = []

    for street in range(3):
        n_act = env.n_actions()

        # Learner acts
        action_a, lp_a, h2p, h2t, ent = learner.act(obs_a)
        # Mask invalid actions (no fold on street 1)
        if street == 0:
            # Re-sample if fold was selected (shouldn't happen with n_actions_street1 logits)
            action_a = action_a.clamp(0, N_BET_SIZES - 1)

        # Frozen opponent acts (random policy from untrained network)
        with torch.no_grad():
            action_b, _, _, _, _ = opponent.act(obs_b)
            if street == 0:
                action_b = action_b.clamp(0, N_BET_SIZES - 1)

        log_probs.append(lp_a)
        h2_preds.append(h2p)
        h2_targets.append(h2t)
        entropies.append(ent)

        obs_a, obs_b, done = env.step(action_a.cpu(), action_b.cpu())
        obs_a, obs_b = obs_a.to(device), obs_b.to(device)

        if done.all():
            break

    reward_a, _ = env.get_rewards()
    return {
        'log_probs': log_probs,
        'rewards': reward_a.to(device),
        'h2_preds': h2_preds,
        'h2_targets': h2_targets,
        'entropies': entropies,
    }


def compute_loss(game_data, w_game, w_self, entropy_coeff, baseline):
    """Compute policy gradient + self-prediction loss."""
    rewards = game_data['rewards']

    # Policy gradient with baseline
    advantage = rewards - baseline
    policy_loss = torch.tensor(0.0, device=rewards.device)
    for lp in game_data['log_probs']:
        policy_loss -= (advantage.detach() * lp).mean()

    # Self-prediction loss
    self_loss = torch.tensor(0.0, device=rewards.device)
    n_steps = 0
    for h2p, h2t in zip(game_data['h2_preds'], game_data['h2_targets']):
        self_loss += torch.mean((h2p - h2t) ** 2)
        n_steps += 1
    if n_steps > 0:
        self_loss /= n_steps

    # Entropy bonus
    entropy = torch.tensor(0.0, device=rewards.device)
    for ent in game_data['entropies']:
        entropy += ent.mean()
    if len(game_data['entropies']) > 0:
        entropy /= len(game_data['entropies'])

    total = w_game * policy_loss + w_self * self_loss - entropy_coeff * entropy
    return total, policy_loss.item(), self_loss.item(), entropy.item()


def run_experiment(w_self, seed):
    run_name = f'ws{w_self}_seed{seed}'
    run_dir = os.path.join(RESULTS_DIR, run_name)
    os.makedirs(run_dir, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"Phase 1c: w_self={w_self}, seed={seed}")
    print(f"{'='*60}")

    torch.manual_seed(seed)
    np.random.seed(seed)

    env = ContinuousPoker(MAX_BET, N_BET_SIZES, device='cpu')
    n_actions = N_BET_SIZES + 1  # max actions (streets 2-3 include fold)

    learner = PokerNetwork(obs_dim=env.obs_dim, n_actions=n_actions,
                           hidden_dim=HIDDEN_DIM,
                           bottleneck_dim=BOTTLENECK_DIM).to(DEVICE)

    # Frozen opponent: same arch, random weights, no gradient
    opponent = PokerNetwork(obs_dim=env.obs_dim, n_actions=n_actions,
                            hidden_dim=HIDDEN_DIM,
                            bottleneck_dim=BOTTLENECK_DIM).to(DEVICE)
    opponent.eval()
    for p in opponent.parameters():
        p.requires_grad_(False)

    optimizer = optim.Adam(learner.parameters(), lr=LR)

    # Moving average baseline for REINFORCE
    baseline = 0.0
    baseline_decay = 0.99

    history = []
    measurements = []

    # Measure at episode 0
    learner_cpu = PokerNetwork(obs_dim=env.obs_dim, n_actions=n_actions,
                               hidden_dim=HIDDEN_DIM,
                               bottleneck_dim=BOTTLENECK_DIM)
    learner_cpu.load_state_dict(
        {k: v.cpu() for k, v in learner.state_dict().items()})
    m = measure_all(learner_cpu, method='compose')
    m['episode'] = 0
    measurements.append(m)

    for episode in range(1, N_EPISODES + 1):
        learner.train()
        game_data = play_batch(env, learner, opponent, DEVICE)

        # Update baseline
        mean_reward = game_data['rewards'].mean().item()
        baseline = baseline_decay * baseline + (1 - baseline_decay) * mean_reward

        # Compute loss and update
        optimizer.zero_grad()
        total_loss, pg_loss, sp_loss, ent = compute_loss(
            game_data, 1.0, w_self, ENTROPY_COEFF, baseline)
        total_loss.backward()
        torch.nn.utils.clip_grad_norm_(learner.parameters(), GRAD_CLIP)
        optimizer.step()

        history.append({
            'episode': episode,
            'mean_reward': mean_reward,
            'policy_loss': pg_loss,
            'self_loss': sp_loss,
            'entropy': ent,
        })

        if episode % 1000 == 0:
            recent = history[-100:]
            avg_r = np.mean([h['mean_reward'] for h in recent])
            avg_sp = np.mean([h['self_loss'] for h in recent])
            print(f"Episode {episode}: reward={avg_r:.3f}, "
                  f"self_loss={avg_sp:.4f}, entropy={ent:.3f}")

        if episode % MEASURE_EVERY == 0:
            learner_cpu.load_state_dict(
                {k: v.cpu() for k, v in learner.state_dict().items()})
            m = measure_all(learner_cpu, method='compose')
            m['episode'] = episode
            measurements.append(m)
            cn_mean = np.mean(list(m['commutator_norms'].values()))
            print(f"  -> dep_ratio={m['dependency_ratio']:.4f}, "
                  f"cn_mean={cn_mean:.4f}")

    # Final measurement
    learner_cpu.load_state_dict(
        {k: v.cpu() for k, v in learner.state_dict().items()})
    final = measure_all(learner_cpu, method='compose')
    final['episode'] = N_EPISODES
    final['w_self'] = w_self
    final['seed'] = seed
    measurements.append(final)

    save_results(history, os.path.join(run_dir, 'history.json'))
    save_results(measurements, os.path.join(run_dir, 'measurements.json'))
    save_results(final, os.path.join(run_dir, 'final.json'))

    print_summary(final)
    return final


def main():
    print(f"Phase 1c: Poker + Frozen Opponent")
    print(f"Device: {DEVICE}")
    print(f"Hidden: {HIDDEN_DIM}, Bottleneck: {BOTTLENECK_DIM}")
    print(f"Episodes: {N_EPISODES}, Batch: {BATCH_GAMES}")

    w_self_values = [0.0, 1.0, 10.0]
    seeds = [0, 1, 2]

    all_finals = []
    for w_self in w_self_values:
        for seed in seeds:
            final = run_experiment(w_self, seed)
            all_finals.append({
                'w_self': w_self,
                'seed': seed,
                'dependency_ratio': final['dependency_ratio'],
                'algebra_dimension': final['algebra_dimension'],
                'commutator_norms': final['commutator_norms'],
            })

    # Comparison
    print(f"\n{'='*60}")
    print(f"COMPARISON SUMMARY")
    print(f"{'='*60}")
    print(f"{'w_self':>8} {'dep_ratio':>12} {'cn_mean':>10}")
    print(f"{'-'*32}")

    for w_self in w_self_values:
        runs = [r for r in all_finals if r['w_self'] == w_self]
        dep = np.mean([r['dependency_ratio'] for r in runs])
        cn = np.mean([np.mean(list(r['commutator_norms'].values()))
                      for r in runs])
        print(f"{w_self:>8.1f} {dep:>12.4f} {cn:>10.4f}")

    save_results(all_finals, os.path.join(RESULTS_DIR, 'comparison.json'))


if __name__ == '__main__':
    main()
