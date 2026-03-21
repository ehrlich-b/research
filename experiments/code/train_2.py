#!/usr/bin/env python3
"""Phase 2: Competitive Poker Self-Play

Both networks learn simultaneously. Both have self-prediction heads.
The arms race between adapting opponents creates competitive pressure
that should prevent simplification.

Key comparison vs Phase 1c: same architecture, same task, but opponent
LEARNS instead of being frozen. Competition is the independent variable.
"""

import sys
import os
import json
import time
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim

sys.path.insert(0, os.path.dirname(__file__))
from models import PokerNetwork
from poker import ContinuousPoker
from metrics import measure_all, save_results, print_summary

RESULTS_DIR = os.path.join(os.path.dirname(__file__), 'results', '2')
os.makedirs(RESULTS_DIR, exist_ok=True)

# Architecture
HIDDEN_DIM = 256
BOTTLENECK_DIM = 64

# Poker
MAX_BET = 10
N_BET_SIZES = 11
BATCH_GAMES = 256

# Training
N_EPISODES = 10000
LR = 3e-4
LR_WARMUP = 100  # episodes at LR/10
ENTROPY_COEFF = 0.5  # Must be large for competitive self-play (Nash eq is mixed strategy)
GRAD_CLIP = 1.0
MEASURE_EVERY = 500
LOG_EVERY = 200  # frequent status updates

# Device
if torch.backends.mps.is_available():
    DEVICE = torch.device('mps')
elif torch.cuda.is_available():
    DEVICE = torch.device('cuda')
else:
    DEVICE = torch.device('cpu')


def play_batch(env, net_a, net_b, device):
    """Play a batch of games between two networks.

    Returns (data_a, data_b) dicts with log_probs, rewards, h2 preds/targets.
    """
    obs_a, obs_b = env.reset(BATCH_GAMES)
    obs_a, obs_b = obs_a.to(device), obs_b.to(device)

    log_probs_a, log_probs_b = [], []
    h2_preds_a, h2_preds_b = [], []
    h2_targets_a, h2_targets_b = [], []
    entropies_a, entropies_b = [], []

    for street in range(3):
        action_a, lp_a, h2p_a, h2t_a, ent_a = net_a.act(obs_a)
        action_b, lp_b, h2p_b, h2t_b, ent_b = net_b.act(obs_b)

        # Clamp to valid actions (no fold on street 1)
        if street == 0:
            action_a = action_a.clamp(0, N_BET_SIZES - 1)
            action_b = action_b.clamp(0, N_BET_SIZES - 1)

        log_probs_a.append(lp_a)
        log_probs_b.append(lp_b)
        h2_preds_a.append(h2p_a)
        h2_preds_b.append(h2p_b)
        h2_targets_a.append(h2t_a)
        h2_targets_b.append(h2t_b)
        entropies_a.append(ent_a)
        entropies_b.append(ent_b)

        obs_a, obs_b, done = env.step(action_a.cpu(), action_b.cpu())
        obs_a, obs_b = obs_a.to(device), obs_b.to(device)

        if done.all():
            break

    reward_a, reward_b = env.get_rewards()

    data_a = {
        'log_probs': log_probs_a, 'rewards': reward_a.to(device),
        'h2_preds': h2_preds_a, 'h2_targets': h2_targets_a,
        'entropies': entropies_a,
    }
    data_b = {
        'log_probs': log_probs_b, 'rewards': reward_b.to(device),
        'h2_preds': h2_preds_b, 'h2_targets': h2_targets_b,
        'entropies': entropies_b,
    }
    return data_a, data_b


def compute_loss(game_data, w_game, w_self, entropy_coeff, baseline):
    """Policy gradient + self-prediction loss."""
    rewards = game_data['rewards']
    advantage = rewards - baseline

    policy_loss = torch.tensor(0.0, device=rewards.device)
    for lp in game_data['log_probs']:
        policy_loss -= (advantage.detach() * lp).mean()

    self_loss = torch.tensor(0.0, device=rewards.device)
    n_steps = 0
    for h2p, h2t in zip(game_data['h2_preds'], game_data['h2_targets']):
        self_loss += torch.mean((h2p - h2t) ** 2)
        n_steps += 1
    if n_steps > 0:
        self_loss /= n_steps

    entropy = torch.tensor(0.0, device=rewards.device)
    for ent in game_data['entropies']:
        entropy += ent.mean()
    if len(game_data['entropies']) > 0:
        entropy /= len(game_data['entropies'])

    total = w_game * policy_loss + w_self * self_loss - entropy_coeff * entropy
    return total, policy_loss.item(), self_loss.item(), entropy.item()


def log(msg):
    """Print with timestamp and flush."""
    elapsed = time.time() - _start_time
    mins, secs = divmod(int(elapsed), 60)
    print(f"[{mins:02d}:{secs:02d}] {msg}", flush=True)


_start_time = time.time()


def run_experiment(w_self, seed):
    run_name = f'ws{w_self}_seed{seed}'
    run_dir = os.path.join(RESULTS_DIR, run_name)
    os.makedirs(run_dir, exist_ok=True)

    log(f"{'='*50}")
    log(f"Phase 2: w_self={w_self}, seed={seed}")
    log(f"{'='*50}")

    torch.manual_seed(seed)
    np.random.seed(seed)

    env = ContinuousPoker(MAX_BET, N_BET_SIZES, device='cpu')
    n_actions = N_BET_SIZES + 1

    net_a = PokerNetwork(obs_dim=env.obs_dim, n_actions=n_actions,
                         hidden_dim=HIDDEN_DIM,
                         bottleneck_dim=BOTTLENECK_DIM).to(DEVICE)
    net_b = PokerNetwork(obs_dim=env.obs_dim, n_actions=n_actions,
                         hidden_dim=HIDDEN_DIM,
                         bottleneck_dim=BOTTLENECK_DIM).to(DEVICE)

    opt_a = optim.Adam(net_a.parameters(), lr=LR)
    opt_b = optim.Adam(net_b.parameters(), lr=LR)

    baseline_a = 0.0
    baseline_b = 0.0
    baseline_decay = 0.99

    history = []
    measurements_a = []
    measurements_b = []

    # Skip episode-0 measurement (we know random baseline from Phase 1a)
    log("Training started (skipping ep0 measurement, known from Phase 1a)")

    ep_start = time.time()
    for episode in range(1, N_EPISODES + 1):
        net_a.train()
        net_b.train()

        # Learning rate warmup
        if episode <= LR_WARMUP:
            lr_scale = episode / LR_WARMUP
            for pg in opt_a.param_groups:
                pg['lr'] = LR * lr_scale
            for pg in opt_b.param_groups:
                pg['lr'] = LR * lr_scale

        # Play
        data_a, data_b = play_batch(env, net_a, net_b, DEVICE)

        mean_r_a = data_a['rewards'].mean().item()
        mean_r_b = data_b['rewards'].mean().item()
        baseline_a = baseline_decay * baseline_a + (1 - baseline_decay) * mean_r_a
        baseline_b = baseline_decay * baseline_b + (1 - baseline_decay) * mean_r_b

        # Update A
        opt_a.zero_grad()
        loss_a, pg_a, sp_a, ent_a = compute_loss(
            data_a, 1.0, w_self, ENTROPY_COEFF, baseline_a)
        loss_a.backward()
        torch.nn.utils.clip_grad_norm_(net_a.parameters(), GRAD_CLIP)
        opt_a.step()

        # Update B
        opt_b.zero_grad()
        loss_b, pg_b, sp_b, ent_b = compute_loss(
            data_b, 1.0, w_self, ENTROPY_COEFF, baseline_b)
        loss_b.backward()
        torch.nn.utils.clip_grad_norm_(net_b.parameters(), GRAD_CLIP)
        opt_b.step()

        history.append({
            'episode': episode,
            'reward_a': mean_r_a,
            'reward_b': mean_r_b,
            'self_loss_a': sp_a,
            'self_loss_b': sp_b,
            'entropy_a': ent_a,
            'entropy_b': ent_b,
        })

        # Frequent status updates
        if episode % LOG_EVERY == 0:
            recent = history[-LOG_EVERY:]
            avg_ra = np.mean([h['reward_a'] for h in recent])
            avg_rb = np.mean([h['reward_b'] for h in recent])
            avg_spa = np.mean([h['self_loss_a'] for h in recent])
            eps_per_sec = LOG_EVERY / (time.time() - ep_start)
            remaining = (N_EPISODES - episode) / eps_per_sec
            log(f"Ep {episode}/{N_EPISODES} | r_A={avg_ra:+.2f} r_B={avg_rb:+.2f} "
                f"sp={avg_spa:.4f} ent={ent_a:.3f} | "
                f"{eps_per_sec:.1f} ep/s, ~{remaining:.0f}s left")
            ep_start = time.time()

            # Mode collapse warning
            if abs(avg_ra) > 5.0:
                log(f"  WARNING: Possible mode collapse (reward imbalance)")

        if episode % MEASURE_EVERY == 0:
            log(f"  Measuring algebra (this takes ~30s)...")
            for label, net, mlist in [('A', net_a, measurements_a),
                                       ('B', net_b, measurements_b)]:
                net_cpu = PokerNetwork(obs_dim=env.obs_dim, n_actions=n_actions,
                                       hidden_dim=HIDDEN_DIM,
                                       bottleneck_dim=BOTTLENECK_DIM)
                net_cpu.load_state_dict(
                    {k: v.cpu() for k, v in net.state_dict().items()})
                m = measure_all(net_cpu, method='compose')
                m['episode'] = episode
                m['network'] = label
                mlist.append(m)

            cn_a = np.mean(list(measurements_a[-1]['commutator_norms'].values()))
            cn_b = np.mean(list(measurements_b[-1]['commutator_norms'].values()))
            dep_a = measurements_a[-1]['dependency_ratio']
            dep_b = measurements_b[-1]['dependency_ratio']
            log(f"  A: dep_ratio={dep_a:.4f}, cn={cn_a:.4f}")
            log(f"  B: dep_ratio={dep_b:.4f}, cn={cn_b:.4f}")
            ep_start = time.time()  # reset after measurement pause

    # Save
    save_results(history, os.path.join(run_dir, 'history.json'))
    save_results(measurements_a, os.path.join(run_dir, 'measurements_a.json'))
    save_results(measurements_b, os.path.join(run_dir, 'measurements_b.json'))

    final_a = measurements_a[-1]
    final_b = measurements_b[-1]
    final_a['w_self'] = w_self
    final_a['seed'] = seed
    final_b['w_self'] = w_self
    final_b['seed'] = seed
    save_results(final_a, os.path.join(run_dir, 'final_a.json'))
    save_results(final_b, os.path.join(run_dir, 'final_b.json'))

    log("Network A final:")
    print_summary(final_a)
    log("Network B final:")
    print_summary(final_b)

    return final_a, final_b


def main():
    log(f"Phase 2: Competitive Poker Self-Play")
    log(f"Device: {DEVICE}")
    log(f"Hidden: {HIDDEN_DIM}, Bottleneck: {BOTTLENECK_DIM}")
    log(f"Episodes: {N_EPISODES}, Batch: {BATCH_GAMES}")
    log(f"9 experiments: w_self in {{0.0, 1.0, 10.0}} x 3 seeds")

    w_self_values = [0.0, 1.0, 10.0]
    seeds = [0, 1, 2]

    all_finals = []
    for w_self in w_self_values:
        for seed in seeds:
            final_a, final_b = run_experiment(w_self, seed)
            for label, final in [('A', final_a), ('B', final_b)]:
                all_finals.append({
                    'w_self': w_self,
                    'seed': seed,
                    'network': label,
                    'dependency_ratio': final['dependency_ratio'],
                    'algebra_dimension': final['algebra_dimension'],
                    'commutator_norms': final['commutator_norms'],
                })

    # Comparison
    log(f"{'='*50}")
    log(f"COMPARISON SUMMARY (averaging A and B)")
    log(f"{'='*50}")
    log(f"{'w_self':>8} {'dep_ratio':>12} {'cn_mean':>10}")
    log(f"{'-'*32}")

    for w_self in w_self_values:
        runs = [r for r in all_finals if r['w_self'] == w_self]
        dep = np.mean([r['dependency_ratio'] for r in runs])
        cn = np.mean([np.mean(list(r['commutator_norms'].values()))
                      for r in runs])
        log(f"{w_self:>8.1f} {dep:>12.4f} {cn:>10.4f}")

    save_results(all_finals, os.path.join(RESULTS_DIR, 'comparison.json'))


if __name__ == '__main__':
    main()
