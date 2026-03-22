"""Quantum Poker: non-commutative state evolution + competitive betting.

Each episode, the harness generates a random d×d real symmetric matrix H.
Over K rounds, both agents receive measurement probes (projector P_r,
outcome v_r^T H v_r). Crucially, each measurement DISTURBS H via the
pinching map:

    H -> alpha * (P H P + (I-P) H (I-P)) + (1 - alpha) * H

This is the Peirce decomposition from Paper 5. The pinching kills
off-diagonal information (Peirce 1-space) relative to the projector.
Order matters: pinching by P then Q ≠ Q then P. The network must learn
to track non-commutative state evolution to make accurate predictions.

alpha controls measurement strength:
  alpha=0: no disturbance (classical, commutative)
  alpha=1: full projective measurement (complete Peirce collapse)
  alpha=0.3: partial measurement (history-dependent, richest signal)

Designed for batched tensor execution.
"""

import torch
import torch.nn.functional as F


class QuantumPoker:
    """Batched quantum matrix game environment."""

    def __init__(self, dim=4, n_rounds=20, n_test=1, n_bet_sizes=11,
                 max_bet=10, alpha=0.3, device='cpu'):
        self.dim = dim
        self.n_rounds = n_rounds
        self.n_test = n_test
        self.n_bet_sizes = n_bet_sizes
        self.max_bet = max_bet
        self.alpha = alpha
        self.device = device

        self.bet_values = torch.linspace(0, max_bet, n_bet_sizes,
                                         device=device)

        K = n_rounds
        d = dim
        # Observation dimension:
        # revealed probe vectors (padded):    K * d
        # revealed outcomes (padded):         K
        # reveal mask:                        K
        # test vector:                        d
        # round one-hot:                      K
        # own bet history:                    K
        # opponent bet history:               K
        # pot:                                1
        # K*d + K + K + d + K + K + K + 1 = K*(d+5) + d + 1
        self.obs_dim = K * (d + 5) + d + 1

    def _sample_matrices(self, batch_size):
        """Sample random real symmetric matrices with unit Frobenius norm."""
        d = self.dim
        dev = self.device
        # Random symmetric: A + A^T, then normalize
        A = torch.randn(batch_size, d, d, device=dev)
        H = (A + A.transpose(1, 2)) / 2.0
        # Normalize to unit Frobenius norm
        norms = torch.norm(H.reshape(batch_size, -1), dim=1, keepdim=True)
        norms = norms.unsqueeze(2).clamp(min=1e-6)
        self.H = H / norms

    def _sample_projectors(self, batch_size, n):
        """Sample n random rank-1 projectors per game (as unit vectors)."""
        d = self.dim
        dev = self.device
        v = torch.randn(batch_size, n, d, device=dev)
        v = F.normalize(v, dim=2)
        return v

    def _pinch(self, H, v):
        """Apply pinching map: H -> alpha*(PHP + (I-P)H(I-P)) + (1-alpha)*H.

        P = v v^T (rank-1 projector).
        PHP = v (v^T H v) v^T
        (I-P)H(I-P) = H - PHP - PH(I-P) - (I-P)HP
                     = H - v(v^T H) - (Hv)v^T + v(v^T H v)v^T

        More efficiently: pinched = diag_part + off_diag_part
        where diag_part preserves components along v and orthogonal to v,
        but kills cross-terms.
        """
        # v: (batch, d), H: (batch, d, d)
        # PHP = v (v^T H v) v^T
        vHv = torch.bmm(
            v.unsqueeze(1),
            torch.bmm(H, v.unsqueeze(2))
        ).squeeze(2).squeeze(1)  # (batch,)

        vvT = torch.bmm(v.unsqueeze(2), v.unsqueeze(1))  # (batch, d, d)
        PHP = vHv.unsqueeze(1).unsqueeze(2) * vvT  # (batch, d, d)

        # (I-P)H(I-P) = H - Hv v^T - v v^T H + v v^T H v v^T
        Hv = torch.bmm(H, v.unsqueeze(2))  # (batch, d, 1)
        vTH = torch.bmm(v.unsqueeze(1), H)  # (batch, 1, d)
        IpHIp = H - torch.bmm(Hv, v.unsqueeze(1)) - torch.bmm(v.unsqueeze(2), vTH) + PHP

        pinched = PHP + IpHIp
        return self.alpha * pinched + (1 - self.alpha) * H

    def _measure(self, H, v):
        """Compute expectation value v^T H v."""
        # v: (batch, d), H: (batch, d, d)
        Hv = torch.bmm(H, v.unsqueeze(2)).squeeze(2)  # (batch, d)
        return (v * Hv).sum(dim=1)  # (batch,)

    def reset(self, batch_size):
        """Start new games."""
        self.batch_size = batch_size
        K = self.n_rounds
        d = self.dim
        dev = self.device

        # Hidden matrix
        self._sample_matrices(batch_size)
        self.H_current = self.H.clone()

        # Probe vectors (one per round)
        self.probe_vectors = self._sample_projectors(batch_size, K)

        # Test vector
        self.test_vectors = self._sample_projectors(batch_size, self.n_test)

        # Pre-compute nothing - outcomes depend on evolving H

        # Game state
        self.revealed_vectors = torch.zeros(batch_size, K, d, device=dev)
        self.revealed_outcomes = torch.zeros(batch_size, K, device=dev)
        self.reveal_mask = torch.zeros(batch_size, K, device=dev)
        self.bets_a = torch.zeros(batch_size, K, device=dev)
        self.bets_b = torch.zeros(batch_size, K, device=dev)
        self.pot = torch.zeros(batch_size, device=dev)
        self.current_round = 0

        return self._get_obs()

    def _get_obs(self):
        """Build observation tensors."""
        K = self.n_rounds
        bs = self.batch_size

        round_onehot = torch.zeros(bs, K, device=self.device)
        if self.current_round < K:
            round_onehot[:, self.current_round] = 1.0

        # Flatten revealed vectors: (batch, K, d) -> (batch, K*d)
        flat_vectors = self.revealed_vectors.reshape(bs, -1)

        # Use first test vector for prediction target
        test_v = self.test_vectors[:, 0, :]  # (batch, d)

        obs_a = torch.cat([
            flat_vectors,                             # K*d
            self.revealed_outcomes,                   # K
            self.reveal_mask,                         # K
            test_v,                                   # d
            round_onehot,                             # K
            self.bets_a,                              # K
            self.bets_b,                              # K
            self.pot.unsqueeze(1),                    # 1
        ], dim=1)

        obs_b = torch.cat([
            flat_vectors,                             # K*d
            self.revealed_outcomes,                   # K
            self.reveal_mask,                         # K
            test_v,                                   # d
            round_onehot,                             # K
            self.bets_b,                              # K (swapped)
            self.bets_a,                              # K (swapped)
            self.pot.unsqueeze(1),                    # 1
        ], dim=1)

        return obs_a, obs_b

    def reveal_round(self):
        """Reveal next probe, disturb the matrix, return observations."""
        r = self.current_round
        assert r < self.n_rounds

        v_r = self.probe_vectors[:, r, :]  # (batch, d)

        # Measure BEFORE pinching (outcome from current state)
        outcome = self._measure(self.H_current, v_r)

        # Pinch: disturb the matrix
        self.H_current = self._pinch(self.H_current, v_r)

        # Record
        self.revealed_vectors[:, r, :] = v_r
        self.revealed_outcomes[:, r] = outcome
        self.reveal_mask[:, r] = 1.0

        self.current_round += 1
        return self._get_obs()

    def step(self, action_a, action_b):
        """Process betting round."""
        r = self.current_round - 1
        assert r >= 0

        bet_a = self.bet_values[action_a.clamp(0, self.n_bet_sizes - 1)]
        bet_b = self.bet_values[action_b.clamp(0, self.n_bet_sizes - 1)]

        self.bets_a[:, r] = bet_a
        self.bets_b[:, r] = bet_b
        self.pot += bet_a + bet_b

        return self.current_round >= self.n_rounds

    def get_true_outcomes(self):
        """Get true test outcomes on the FINAL (disturbed) H."""
        # (batch, n_test)
        outcomes = []
        for t in range(self.n_test):
            v = self.test_vectors[:, t, :]
            outcomes.append(self._measure(self.H_current, v))
        return torch.stack(outcomes, dim=1)

    def get_rewards(self, pred_a, pred_b):
        """Compute rewards from prediction accuracy + betting."""
        y_true = self.get_true_outcomes()

        error_a = ((pred_a - y_true) ** 2).mean(dim=1)
        error_b = ((pred_b - y_true) ** 2).mean(dim=1)

        total_bet_a = self.bets_a.sum(dim=1)
        total_bet_b = self.bets_b.sum(dim=1)

        a_wins = error_a < error_b
        b_wins = error_b < error_a

        reward_a = torch.zeros(self.batch_size, device=self.device)
        reward_a[a_wins] = total_bet_b[a_wins]
        reward_a[b_wins] = -total_bet_a[b_wins]

        return reward_a, -reward_a


def validate_quantum_poker():
    """Run validation checks."""
    env = QuantumPoker(dim=4, n_rounds=20, alpha=0.3, device='cpu')
    batch = 1000

    # Test 1: obs dimensions
    obs_a, obs_b = env.reset(batch)
    assert obs_a.shape == (batch, env.obs_dim), \
        f"Bad obs shape: {obs_a.shape}, expected ({batch}, {env.obs_dim})"
    print(f"Test 1 (obs dim={env.obs_dim}): PASS")

    # Test 2: play full episode
    for r in range(env.n_rounds):
        obs_a, obs_b = env.reveal_round()
        bet_a = torch.randint(0, env.n_bet_sizes, (batch,))
        bet_b = torch.randint(0, env.n_bet_sizes, (batch,))
        done = env.step(bet_a, bet_b)
    assert done
    print("Test 2 (full episode): PASS")

    # Test 3: zero-sum
    pred_a = torch.randn(batch, env.n_test)
    pred_b = torch.randn(batch, env.n_test)
    r_a, r_b = env.get_rewards(pred_a, pred_b)
    assert (r_a + r_b).abs().max() < 1e-5
    print("Test 3 (zero-sum): PASS")

    # Test 4: perfect prediction beats random
    obs_a, obs_b = env.reset(batch)
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.ones(batch, dtype=torch.long),
                 torch.ones(batch, dtype=torch.long))
    y_true = env.get_true_outcomes()
    pred_random = torch.randn(batch, env.n_test)
    r_a, r_b = env.get_rewards(y_true, pred_random)
    win_rate = (r_a > 0).float().mean().item()
    print(f"Test 4 (perfect vs random): win rate {win_rate:.3f} "
          f"{'PASS' if win_rate > 0.95 else 'FAIL'}")

    # Test 5: H is symmetric throughout
    obs_a, obs_b = env.reset(batch)
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.zeros(batch, dtype=torch.long),
                 torch.zeros(batch, dtype=torch.long))
    sym_err = (env.H_current - env.H_current.transpose(1, 2)).abs().max().item()
    print(f"Test 5 (H stays symmetric): max asym={sym_err:.8f} "
          f"{'PASS' if sym_err < 1e-6 else 'FAIL'}")

    # Test 6: pinching changes H (alpha > 0)
    obs_a, obs_b = env.reset(batch)
    H_before = env.H_current.clone()
    env.reveal_round()
    H_after = env.H_current
    change = (H_after - H_before).abs().mean().item()
    print(f"Test 6 (pinching changes H): mean change={change:.6f} "
          f"{'PASS' if change > 0.001 else 'FAIL'}")

    # Test 7: order matters (non-commutativity)
    env1 = QuantumPoker(dim=4, n_rounds=2, alpha=0.5, device='cpu')
    env2 = QuantumPoker(dim=4, n_rounds=2, alpha=0.5, device='cpu')
    torch.manual_seed(42)
    env1.reset(batch)
    torch.manual_seed(42)
    env2.reset(batch)
    # Same initial H but swap probe order
    env2.probe_vectors = env2.probe_vectors.flip(1)
    env1.reveal_round(); env1.reveal_round()
    env2.reveal_round(); env2.reveal_round()
    diff = (env1.H_current - env2.H_current).abs().mean().item()
    print(f"Test 7 (order matters): mean diff={diff:.6f} "
          f"{'PASS' if diff > 0.001 else 'FAIL'}")

    # Test 8: alpha=0 means no disturbance
    env0 = QuantumPoker(dim=4, n_rounds=5, alpha=0.0, device='cpu')
    env0.reset(batch)
    H_init = env0.H_current.clone()
    for r in range(5):
        env0.reveal_round()
        env0.step(torch.zeros(batch, dtype=torch.long),
                  torch.zeros(batch, dtype=torch.long))
    change0 = (env0.H_current - H_init).abs().max().item()
    print(f"Test 8 (alpha=0, no disturbance): max change={change0:.8f} "
          f"{'PASS' if change0 < 1e-6 else 'FAIL'}")

    print("\nAll quantum poker validation checks passed.")


if __name__ == '__main__':
    validate_quantum_poker()
