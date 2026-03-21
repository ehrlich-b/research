#!/usr/bin/env python3
"""Phase 2b: Epistemic Poker

Progressive structure revelation + competitive betting. Both networks
learn simultaneously. Rich supervised gradients from prediction task,
REINFORCE from bet competition, self-prediction of H2.

Key comparison:
  - vs Phase 1b (MNIST): rich gradients, no competition, dep=0.25
  - vs Phase 2 (poker): sparse gradients, real competition, dep=0.99
  - Phase 2b: rich gradients + real competition + epistemic self-modeling
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
from models import EpistemicPokerNetwork
from epistemic_poker import EpistemicPoker
from metrics import measure_all, save_results, print_summary

RESULTS_DIR = os.path.join(os.path.dirname(__file__), 'results', '2b')
os.makedirs(RESULTS_DIR, exist_ok=True)

# Architecture
HIDDEN_DIM = 256
BOTTLENECK_DIM = 64

# Game
MATRIX_DIM = 8
N_ROUNDS = 8
N_BET_SIZES = 11
MAX_BET = 10
BATCH_GAMES = 256

# Training
N_EPISODES = 10000
LR = 3e-4
LR_WARMUP = 100
W_PRED = 1.0
W_GAME = 0.1
ENTROPY_COEFF = 0.5
GRAD_CLIP = 1.0
MEASURE_EVERY = 500
LOG_EVERY = 200

# Device
if torch.backends.mps.is_available():
    DEVICE = torch.device('mps')
elif torch.cuda.is_available():
    DEVICE = torch.device('cuda')
else:
    DEVICE = torch.device('cpu')


def play_batch(env, net_a, net_b, device):
    """Play a batch of epistemic poker games.

    Returns (data_a, data_b) dicts with predictions, log_probs,
    rewards, h2 preds/targets, entropies.
    """
    obs_a, obs_b = env.reset(BATCH_GAMES)
    obs_a, obs_b = obs_a.to(device), obs_b.to(device)

    preds_a, preds_b = [], []
    log_probs_a, log_probs_b = [], []
    h2_preds_a, h2_preds_b = [], []
    h2_targets_a, h2_targets_b = [], []
    entropies_a, entropies_b = [], []

    for r in range(env.n_rounds):
        # Reveal next observation
        obs_a, obs_b = env.reveal_round()
        obs_a, obs_b = obs_a.to(device), obs_b.to(device)

        # Both agents act
        pred_a, bet_a, lp_a, h2p_a, h2t_a, ent_a = net_a.act(obs_a)
        pred_b, bet_b, lp_b, h2p_b, h2t_b, ent_b = net_b.act(obs_b)

        preds_a.append(pred_a)
        preds_b.append(pred_b)
        log_probs_a.append(lp_a)
        log_probs_b.append(lp_b)
        h2_preds_a.append(h2p_a)
        h2_preds_b.append(h2p_b)
        h2_targets_a.append(h2t_a)
        h2_targets_b.append(h2t_b)
        entropies_a.append(ent_a)
        entropies_b.append(ent_b)

        # Process bets
        env.step(bet_a.cpu(), bet_b.cpu())

    # Settlement based on final predictions
    final_pred_a = preds_a[-1]
    final_pred_b = preds_b[-1]
    reward_a, reward_b = env.get_rewards(
        final_pred_a.detach().cpu(), final_pred_b.detach().cpu())

    y_star = env.y_star.to(device)

    data_a = {
        'preds': preds_a,
        'log_probs': log_probs_a,
        'rewards': reward_a.to(device),
        'h2_preds': h2_preds_a,
        'h2_targets': h2_targets_a,
        'entropies': entropies_a,
        'y_star': y_star,
    }
    data_b = {
        'preds': preds_b,
        'log_probs': log_probs_b,
        'rewards': reward_b.to(device),
        'h2_preds': h2_preds_b,
        'h2_targets': h2_targets_b,
        'entropies': entropies_b,
        'y_star': y_star,
    }
    return data_a, data_b


def compute_loss(game_data, w_pred, w_game, w_self, entropy_coeff, baseline):
    """Combined prediction + policy gradient + self-prediction loss."""
    rewards = game_data['rewards']
    y_star = game_data['y_star']

    # 1. Prediction loss: MSE at every round (Option A from design doc)
    pred_loss = torch.tensor(0.0, device=rewards.device)
    for pred in game_data['preds']:
        pred_loss += torch.mean((pred - y_star) ** 2)
    pred_loss /= len(game_data['preds'])

    # 2. Policy gradient on bet sizing
    advantage = rewards - baseline
    policy_loss = torch.tensor(0.0, device=rewards.device)
    for lp in game_data['log_probs']:
        policy_loss -= (advantage.detach() * lp).mean()

    # 3. Self-prediction loss
    self_loss = torch.tensor(0.0, device=rewards.device)
    n_steps = 0
    for h2p, h2t in zip(game_data['h2_preds'], game_data['h2_targets']):
        self_loss += torch.mean((h2p - h2t) ** 2)
        n_steps += 1
    if n_steps > 0:
        self_loss /= n_steps

    # 4. Entropy bonus
    entropy = torch.tensor(0.0, device=rewards.device)
    for ent in game_data['entropies']:
        entropy += ent.mean()
    if len(game_data['entropies']) > 0:
        entropy /= len(game_data['entropies'])

    total = (w_pred * pred_loss
             + w_game * policy_loss
             + w_self * self_loss
             - entropy_coeff * entropy)

    return total, pred_loss.item(), policy_loss.item(), self_loss.item(), entropy.item()


def log(msg):
    elapsed = time.time() - _start_time
    mins, secs = divmod(int(elapsed), 60)
    print(f"[{mins:02d}:{secs:02d}] {msg}", flush=True)


_start_time = time.time()


def run_experiment(w_self, seed):
    run_name = f'ws{w_self}_seed{seed}'
    run_dir = os.path.join(RESULTS_DIR, run_name)
    os.makedirs(run_dir, exist_ok=True)

    log(f"{'='*50}")
    log(f"Phase 2b: w_self={w_self}, seed={seed}")
    log(f"{'='*50}")

    torch.manual_seed(seed)
    np.random.seed(seed)

    env = EpistemicPoker(matrix_dim=MATRIX_DIM, n_rounds=N_ROUNDS,
                         n_bet_sizes=N_BET_SIZES, max_bet=MAX_BET,
                         device='cpu')

    net_a = EpistemicPokerNetwork(
        obs_dim=env.obs_dim, pred_dim=MATRIX_DIM,
        n_bet_sizes=N_BET_SIZES, hidden_dim=HIDDEN_DIM,
        bottleneck_dim=BOTTLENECK_DIM).to(DEVICE)
    net_b = EpistemicPokerNetwork(
        obs_dim=env.obs_dim, pred_dim=MATRIX_DIM,
        n_bet_sizes=N_BET_SIZES, hidden_dim=HIDDEN_DIM,
        bottleneck_dim=BOTTLENECK_DIM).to(DEVICE)

    opt_a = optim.Adam(net_a.parameters(), lr=LR)
    opt_b = optim.Adam(net_b.parameters(), lr=LR)

    baseline_a = 0.0
    baseline_b = 0.0
    baseline_decay = 0.99

    history = []
    measurements_a = []
    measurements_b = []

    log("Training started")

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
        loss_a, pred_a, pg_a, sp_a, ent_a = compute_loss(
            data_a, W_PRED, W_GAME, w_self, ENTROPY_COEFF, baseline_a)
        loss_a.backward()
        torch.nn.utils.clip_grad_norm_(net_a.parameters(), GRAD_CLIP)
        opt_a.step()

        # Update B
        opt_b.zero_grad()
        loss_b, pred_b, pg_b, sp_b, ent_b = compute_loss(
            data_b, W_PRED, W_GAME, w_self, ENTROPY_COEFF, baseline_b)
        loss_b.backward()
        torch.nn.utils.clip_grad_norm_(net_b.parameters(), GRAD_CLIP)
        opt_b.step()

        history.append({
            'episode': episode,
            'reward_a': mean_r_a,
            'reward_b': mean_r_b,
            'pred_loss_a': pred_a,
            'pred_loss_b': pred_b,
            'self_loss_a': sp_a,
            'self_loss_b': sp_b,
            'entropy_a': ent_a,
            'entropy_b': ent_b,
        })

        if episode % LOG_EVERY == 0:
            recent = history[-LOG_EVERY:]
            avg_ra = np.mean([h['reward_a'] for h in recent])
            avg_pred = np.mean([h['pred_loss_a'] for h in recent])
            avg_spa = np.mean([h['self_loss_a'] for h in recent])
            eps_per_sec = LOG_EVERY / (time.time() - ep_start)
            remaining = (N_EPISODES - episode) / eps_per_sec
            log(f"Ep {episode}/{N_EPISODES} | r_A={avg_ra:+.2f} "
                f"pred={avg_pred:.4f} sp={avg_spa:.4f} ent={ent_a:.3f} | "
                f"{eps_per_sec:.1f} ep/s, ~{remaining:.0f}s left")
            ep_start = time.time()

        if episode % MEASURE_EVERY == 0:
            log(f"  Measuring algebra...")
            for label, net, mlist in [('A', net_a, measurements_a),
                                       ('B', net_b, measurements_b)]:
                net_cpu = EpistemicPokerNetwork(
                    obs_dim=env.obs_dim, pred_dim=MATRIX_DIM,
                    n_bet_sizes=N_BET_SIZES, hidden_dim=HIDDEN_DIM,
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
            ep_start = time.time()

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
    log(f"Phase 2b: Epistemic Poker")
    log(f"Device: {DEVICE}")
    log(f"Hidden: {HIDDEN_DIM}, Bottleneck: {BOTTLENECK_DIM}")
    log(f"Matrix: {MATRIX_DIM}x{MATRIX_DIM}, Rounds: {N_ROUNDS}")
    log(f"Episodes: {N_EPISODES}, Batch: {BATCH_GAMES}")
    log(f"w_pred={W_PRED}, w_game={W_GAME}, entropy={ENTROPY_COEFF}")
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
