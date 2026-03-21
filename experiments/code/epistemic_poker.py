"""Epistemic Poker: progressive structure revelation + competitive betting.

Each episode, the harness generates a random 8x8 matrix A. Over K=8 rounds,
both agents receive probe observations (x_r, y_r = Ax_r) and must:
  1. Predict y* = Ax* for a fixed test point x*
  2. Choose a bet size based on their confidence

The harness computes the least-squares estimate of y* at each round and
includes it in the observation. The network's job is to REFINE the estimate
(correct for underdetermined/noisy early rounds) and CALIBRATE confidence
(bet sizing). It does NOT need to internally solve linear algebra.

Designed for batched tensor execution.
"""

import torch


class EpistemicPoker:
    """Batched epistemic poker environment.

    All operations work on batches of games simultaneously.
    """

    def __init__(self, matrix_dim=8, n_rounds=8, n_bet_sizes=11,
                 max_bet=10, device='cpu'):
        self.matrix_dim = matrix_dim
        self.n_rounds = n_rounds
        self.n_bet_sizes = n_bet_sizes
        self.max_bet = max_bet
        self.device = device

        self.bet_values = torch.linspace(0, max_bet, n_bet_sizes,
                                         device=device)

        d = matrix_dim
        K = n_rounds
        # Observation dimension:
        # ls_estimate of y*:           d = 8
        # ls_residual (how good fit):  1
        # round number (one-hot):      K = 8
        # test point x*:               d = 8
        # own bet history:             K = 8
        # opponent bet history:        K = 8
        # pot:                         1
        # total = 8 + 1 + 8 + 8 + 8 + 8 + 1 = 42
        self.obs_dim = d + 1 + K + d + K * 2 + 1

    def reset(self, batch_size):
        """Start new games. Returns (obs_A, obs_B).

        Generates hidden matrix A, test point x*, probe points, and
        ground truth y* = Ax* for each game in the batch.
        """
        self.batch_size = batch_size
        d = self.matrix_dim
        K = self.n_rounds
        dev = self.device

        # Hidden structure
        self.A = torch.randn(batch_size, d, d, device=dev) / (d ** 0.5)
        self.x_star = torch.randn(batch_size, d, device=dev)
        self.y_star = torch.bmm(self.A,
                                self.x_star.unsqueeze(2)).squeeze(2)

        # Probe points
        self.probes = torch.randn(batch_size, K, d, device=dev)
        # Pre-compute probe outputs: y_r = A @ x_r
        self.probe_outputs = torch.bmm(
            self.A,
            self.probes.permute(0, 2, 1)  # (batch, d, K)
        ).permute(0, 2, 1)  # (batch, K, d)

        # Game state
        self.bets_a = torch.zeros(batch_size, K, device=dev)
        self.bets_b = torch.zeros(batch_size, K, device=dev)
        self.pot = torch.zeros(batch_size, device=dev)
        self.current_round = 0

        # Least-squares state: accumulate X^T X and X^T Y
        self.XtX = torch.zeros(batch_size, d, d, device=dev)
        self.XtY = torch.zeros(batch_size, d, d, device=dev)
        # Current LS estimate of y* (starts at zero)
        self.ls_estimate = torch.zeros(batch_size, d, device=dev)
        self.ls_residual = torch.ones(batch_size, device=dev)  # 1.0 = no info

        return self._get_obs()

    def _get_obs(self):
        """Build observation tensors for both players."""
        K = self.n_rounds
        bs = self.batch_size

        round_onehot = torch.zeros(bs, K, device=self.device)
        if self.current_round < K:
            round_onehot[:, self.current_round] = 1.0

        obs_a = torch.cat([
            self.ls_estimate,                         # d
            self.ls_residual.unsqueeze(1),            # 1
            round_onehot,                             # K
            self.x_star,                              # d
            self.bets_a,                              # K
            self.bets_b,                              # K
            self.pot.unsqueeze(1),                    # 1
        ], dim=1)

        obs_b = torch.cat([
            self.ls_estimate,                         # d
            self.ls_residual.unsqueeze(1),            # 1
            round_onehot,                             # K
            self.x_star,                              # d
            self.bets_b,                              # K (swapped)
            self.bets_a,                              # K (swapped)
            self.pot.unsqueeze(1),                    # 1
        ], dim=1)

        return obs_a, obs_b

    def _update_ls_estimate(self):
        """Update least-squares estimate of A, then compute predicted y*."""
        d = self.matrix_dim
        r = self.current_round  # number of probes revealed so far

        if r == 0:
            return

        # Solve: X @ A^T = Y, so A^T = (X^T X)^{-1} X^T Y
        reg = 1e-3 * torch.eye(d, device=self.device).unsqueeze(0)
        A_hat_T = torch.linalg.solve(
            self.XtX + reg,
            self.XtY
        )  # (batch, d, d) = A^T
        A_hat = A_hat_T.transpose(1, 2)

        # Predict y* = A_hat @ x*
        self.ls_estimate = torch.bmm(
            A_hat,
            self.x_star.unsqueeze(2)
        ).squeeze(2)

        # Information fraction: r/K (how determined the system is)
        self.ls_residual = torch.full(
            (self.batch_size,), r / self.n_rounds, device=self.device)

    def reveal_round(self):
        """Reveal the next probe observation to both agents.

        Updates the LS estimate and returns new observations.
        """
        r = self.current_round
        assert r < self.n_rounds, "All rounds already revealed"

        # Accumulate into X^T X and X^T Y
        x_r = self.probes[:, r, :]  # (batch, d)
        y_r = self.probe_outputs[:, r, :]  # (batch, d)
        self.XtX += torch.bmm(x_r.unsqueeze(2), x_r.unsqueeze(1))
        self.XtY += torch.bmm(x_r.unsqueeze(2), y_r.unsqueeze(1))

        self.current_round += 1
        self._update_ls_estimate()

        return self._get_obs()

    def step(self, action_a, action_b):
        """Process one round of betting.

        Args:
            action_a: (batch,) int tensor, bet size index 0..n_bet_sizes-1
            action_b: (batch,) int tensor, bet size index 0..n_bet_sizes-1

        Returns:
            done: bool, True if all rounds played
        """
        r = self.current_round - 1  # reveal_round increments first
        assert r >= 0

        bet_a = self.bet_values[action_a.clamp(0, self.n_bet_sizes - 1)]
        bet_b = self.bet_values[action_b.clamp(0, self.n_bet_sizes - 1)]

        self.bets_a[:, r] = bet_a
        self.bets_b[:, r] = bet_b
        self.pot += bet_a + bet_b

        return self.current_round >= self.n_rounds

    def get_rewards(self, pred_a, pred_b):
        """Compute rewards based on prediction accuracy and betting.

        Args:
            pred_a: (batch, d) final prediction from agent A
            pred_b: (batch, d) final prediction from agent B

        Returns:
            reward_a, reward_b: (batch,) float tensors (zero-sum)
        """
        error_a = ((pred_a - self.y_star) ** 2).sum(dim=1)
        error_b = ((pred_b - self.y_star) ** 2).sum(dim=1)

        total_bet_a = self.bets_a.sum(dim=1)
        total_bet_b = self.bets_b.sum(dim=1)

        # Winner = lower error, wins opponent's total bets
        a_wins = error_a < error_b
        b_wins = error_b < error_a

        reward_a = torch.zeros(self.batch_size, device=self.device)
        reward_a[a_wins] = total_bet_b[a_wins]
        reward_a[b_wins] = -total_bet_a[b_wins]

        return reward_a, -reward_a


def validate_epistemic_poker():
    """Run validation checks on the environment."""
    env = EpistemicPoker(device='cpu')
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
    assert done, "Game should be done after K rounds"
    print("Test 2 (full episode): PASS")

    # Test 3: zero-sum rewards
    pred_a = torch.randn(batch, env.matrix_dim)
    pred_b = torch.randn(batch, env.matrix_dim)
    r_a, r_b = env.get_rewards(pred_a, pred_b)
    assert (r_a + r_b).abs().max() < 1e-5, "Not zero-sum!"
    print("Test 3 (zero-sum): PASS")

    # Test 4: perfect prediction should beat random
    obs_a, obs_b = env.reset(batch)
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.ones(batch, dtype=torch.long),
                 torch.ones(batch, dtype=torch.long))
    pred_perfect = env.y_star.clone()
    pred_random = torch.randn(batch, env.matrix_dim)
    r_a, r_b = env.get_rewards(pred_perfect, pred_random)
    win_rate = (r_a > 0).float().mean().item()
    print(f"Test 4 (perfect vs random): win rate {win_rate:.3f} "
          f"(expected ~1.0) {'PASS' if win_rate > 0.95 else 'FAIL'}")

    # Test 5: LS estimate converges to y* after all rounds
    obs_a, obs_b = env.reset(batch)
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.zeros(batch, dtype=torch.long),
                 torch.zeros(batch, dtype=torch.long))
    ls_err = ((env.ls_estimate - env.y_star) ** 2).mean().item()
    print(f"Test 5 (LS estimate MSE after {env.n_rounds} rounds): {ls_err:.6f} "
          f"{'PASS' if ls_err < 0.01 else 'FAIL'}")

    # Test 6: LS estimate is bad after 1 round (underdetermined)
    obs_a, obs_b = env.reset(batch)
    env.reveal_round()
    env.step(torch.zeros(batch, dtype=torch.long),
             torch.zeros(batch, dtype=torch.long))
    ls_err_1 = ((env.ls_estimate - env.y_star) ** 2).mean().item()
    print(f"Test 6 (LS estimate MSE after 1 round): {ls_err_1:.4f} "
          f"(should be >> 0) {'PASS' if ls_err_1 > 0.1 else 'FAIL'}")

    # Test 7: residual decreases with more rounds
    obs_a, obs_b = env.reset(batch)
    residuals = []
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.zeros(batch, dtype=torch.long),
                 torch.zeros(batch, dtype=torch.long))
        residuals.append(env.ls_residual.mean().item())
    print(f"Test 7 (residuals): {['%.4f' % r for r in residuals]}")
    print(f"  Decreasing: {'PASS' if residuals[-1] < residuals[0] else 'FAIL'}")

    print("\nAll epistemic poker validation checks passed.")


if __name__ == '__main__':
    validate_epistemic_poker()
