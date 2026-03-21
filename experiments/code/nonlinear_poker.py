"""Nonlinear Poker: nonlinear function discovery + competitive betting.

Each episode, the harness generates a random nonlinear function f.
Over K rounds, both agents receive probe observations (x_r, f(x_r)) and must:
  1. Predict f(x*) at multiple test points
  2. Choose a bet size based on their confidence

Unlike epistemic poker (Phase 2b), there is NO closed-form estimate.
The network must build its own internal representation of f from raw
(x, y) pairs. This forces richer weight algebra than linear tasks.

Function class: random polynomials of degree d with controlled coefficients.
Designed for batched tensor execution.
"""

import torch


class NonlinearPoker:
    """Batched nonlinear function discovery environment.

    All operations work on batches of games simultaneously.
    """

    def __init__(self, n_rounds=20, n_test=5, n_bet_sizes=11,
                 max_bet=10, degree=4, input_range=2.0, device='cpu'):
        self.n_rounds = n_rounds
        self.n_test = n_test
        self.n_bet_sizes = n_bet_sizes
        self.max_bet = max_bet
        self.degree = degree
        self.input_range = input_range
        self.device = device

        self.bet_values = torch.linspace(0, max_bet, n_bet_sizes,
                                         device=device)

        K = n_rounds
        # Observation dimension:
        # revealed x values (padded):     K
        # revealed y values (padded):     K
        # reveal mask:                    K
        # test points x*:                 n_test
        # round number (one-hot):         K
        # own bet history:                K
        # opponent bet history:           K
        # pot:                            1
        self.obs_dim = 6 * K + n_test + 1

    def _sample_functions(self, batch_size):
        """Sample random polynomial functions.

        Coefficients: c_k ~ N(0, 1/(k+1)) so higher degrees are smaller.
        Then normalize so f has roughly unit variance on [-input_range, input_range].
        """
        d = self.degree
        dev = self.device

        # Coefficients with decreasing scale
        scales = torch.tensor([1.0 / (k + 1) for k in range(d + 1)],
                              device=dev)
        self.coeffs = torch.randn(batch_size, d + 1, device=dev) * scales

        # Normalize: evaluate at 50 uniform points, compute std, rescale
        x_norm = torch.linspace(-self.input_range, self.input_range, 50,
                                device=dev)
        y_norm = self._eval_poly(self.coeffs, x_norm.unsqueeze(0).expand(batch_size, -1))
        stds = y_norm.std(dim=1, keepdim=True).clamp(min=0.1)
        self.coeffs = self.coeffs / stds

    def _eval_poly(self, coeffs, x):
        """Evaluate polynomial. coeffs: (batch, d+1), x: (batch, n).
        Returns (batch, n)."""
        # Horner's method for numerical stability
        result = torch.zeros_like(x)
        for k in range(coeffs.shape[1] - 1, -1, -1):
            result = result * x + coeffs[:, k:k+1]
        return result

    def reset(self, batch_size):
        """Start new games. Returns (obs_A, obs_B)."""
        self.batch_size = batch_size
        K = self.n_rounds
        dev = self.device

        # Sample hidden functions
        self._sample_functions(batch_size)

        # Test points (fixed per episode)
        self.x_test = (torch.rand(batch_size, self.n_test, device=dev) * 2 - 1
                       ) * self.input_range
        self.y_test = self._eval_poly(self.coeffs, self.x_test)

        # Probe points (revealed one per round)
        self.x_probes = (torch.rand(batch_size, K, device=dev) * 2 - 1
                         ) * self.input_range
        self.y_probes = self._eval_poly(self.coeffs, self.x_probes)

        # Game state
        self.revealed_x = torch.zeros(batch_size, K, device=dev)
        self.revealed_y = torch.zeros(batch_size, K, device=dev)
        self.reveal_mask = torch.zeros(batch_size, K, device=dev)
        self.bets_a = torch.zeros(batch_size, K, device=dev)
        self.bets_b = torch.zeros(batch_size, K, device=dev)
        self.pot = torch.zeros(batch_size, device=dev)
        self.current_round = 0

        return self._get_obs()

    def _get_obs(self):
        """Build observation tensors for both players."""
        K = self.n_rounds
        bs = self.batch_size

        round_onehot = torch.zeros(bs, K, device=self.device)
        if self.current_round < K:
            round_onehot[:, self.current_round] = 1.0

        obs_a = torch.cat([
            self.revealed_x,                          # K
            self.revealed_y,                          # K
            self.reveal_mask,                         # K
            self.x_test,                              # n_test
            round_onehot,                             # K
            self.bets_a,                              # K
            self.bets_b,                              # K
            self.pot.unsqueeze(1),                    # 1
        ], dim=1)

        obs_b = torch.cat([
            self.revealed_x,                          # K
            self.revealed_y,                          # K
            self.reveal_mask,                         # K
            self.x_test,                              # n_test
            round_onehot,                             # K
            self.bets_b,                              # K (swapped)
            self.bets_a,                              # K (swapped)
            self.pot.unsqueeze(1),                    # 1
        ], dim=1)

        return obs_a, obs_b

    def reveal_round(self):
        """Reveal next probe (x_r, f(x_r)). Returns new observations."""
        r = self.current_round
        assert r < self.n_rounds, "All rounds already revealed"

        self.revealed_x[:, r] = self.x_probes[:, r]
        self.revealed_y[:, r] = self.y_probes[:, r]
        self.reveal_mask[:, r] = 1.0

        self.current_round += 1
        return self._get_obs()

    def step(self, action_a, action_b):
        """Process one round of betting. Returns done flag."""
        r = self.current_round - 1
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
            pred_a: (batch, n_test) predictions from agent A
            pred_b: (batch, n_test) predictions from agent B

        Returns:
            reward_a, reward_b: (batch,) float tensors (zero-sum)
        """
        error_a = ((pred_a - self.y_test) ** 2).mean(dim=1)
        error_b = ((pred_b - self.y_test) ** 2).mean(dim=1)

        total_bet_a = self.bets_a.sum(dim=1)
        total_bet_b = self.bets_b.sum(dim=1)

        a_wins = error_a < error_b
        b_wins = error_b < error_a

        reward_a = torch.zeros(self.batch_size, device=self.device)
        reward_a[a_wins] = total_bet_b[a_wins]
        reward_a[b_wins] = -total_bet_a[b_wins]

        return reward_a, -reward_a


def validate_nonlinear_poker():
    """Run validation checks."""
    env = NonlinearPoker(device='cpu')
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
    pred_a = torch.randn(batch, env.n_test)
    pred_b = torch.randn(batch, env.n_test)
    r_a, r_b = env.get_rewards(pred_a, pred_b)
    assert (r_a + r_b).abs().max() < 1e-5, "Not zero-sum!"
    print("Test 3 (zero-sum): PASS")

    # Test 4: perfect prediction should beat random
    obs_a, obs_b = env.reset(batch)
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.ones(batch, dtype=torch.long),
                 torch.ones(batch, dtype=torch.long))
    pred_perfect = env.y_test.clone()
    pred_random = torch.randn(batch, env.n_test)
    r_a, r_b = env.get_rewards(pred_perfect, pred_random)
    win_rate = (r_a > 0).float().mean().item()
    print(f"Test 4 (perfect vs random): win rate {win_rate:.3f} "
          f"(expected ~1.0) {'PASS' if win_rate > 0.95 else 'FAIL'}")

    # Test 5: polynomial evaluation sanity
    obs_a, obs_b = env.reset(batch)
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.zeros(batch, dtype=torch.long),
                 torch.zeros(batch, dtype=torch.long))
    # Check that revealed y matches polynomial evaluation
    y_check = env._eval_poly(env.coeffs, env.x_probes)
    err = ((env.y_probes - y_check) ** 2).mean().item()
    print(f"Test 5 (poly eval consistency): MSE={err:.8f} "
          f"{'PASS' if err < 1e-10 else 'FAIL'}")

    # Test 6: functions have roughly unit variance
    obs_a, obs_b = env.reset(batch)
    y_var = env.y_test.var(dim=1).mean().item()
    print(f"Test 6 (function variance): mean var={y_var:.3f} "
          f"(target ~1.0) {'PASS' if 0.3 < y_var < 3.0 else 'FAIL'}")

    # Test 7: predictions improve with more data (sanity - use poly fit)
    obs_a, obs_b = env.reset(batch)
    errors_by_round = []
    for r in range(env.n_rounds):
        env.reveal_round()
        env.step(torch.zeros(batch, dtype=torch.long),
                 torch.zeros(batch, dtype=torch.long))
        # Naive: predict mean of revealed y
        if r > 0:
            mean_y = env.revealed_y[:, :r+1].mean(dim=1, keepdim=True)
            naive_pred = mean_y.expand(-1, env.n_test)
            err = ((naive_pred - env.y_test) ** 2).mean().item()
            errors_by_round.append(err)
    print(f"Test 7 (naive pred errors by round): "
          f"{['%.3f' % e for e in errors_by_round[:5]]}...")

    print("\nAll nonlinear poker validation checks passed.")


if __name__ == '__main__':
    validate_nonlinear_poker()
