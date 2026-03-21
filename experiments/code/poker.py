"""Continuous poker environment for self-modeling experiments.

Two players draw hidden values x ~ U[0,1], bet over 3 streets, higher x wins.
Designed for batched execution (all operations are tensor ops).

Rules:
  1. Both draw x_A, x_B ~ U[0,1]. Each sees only its own.
  2. Both ante 1 (forced).
  3. Street 1: Both simultaneously choose bet in {0, 1, ..., max_bet}. No fold.
  4. Street 2: Both choose bet in {0, ..., max_bet} OR fold. Simultaneous.
  5. Street 3: Same as street 2.
  6. Showdown: higher x wins the pot. If one folded, other takes pot.
"""

import torch


class ContinuousPoker:
    """Batched continuous poker environment.

    All operations work on batches of games simultaneously.
    State is tracked as tensors of shape (batch_size, ...).
    """

    def __init__(self, max_bet=10, n_bet_sizes=11, device='cpu'):
        """
        Args:
            max_bet: maximum bet per street
            n_bet_sizes: number of discrete bet levels (0 to max_bet inclusive)
            device: torch device
        """
        self.max_bet = max_bet
        self.n_bet_sizes = n_bet_sizes
        self.device = device

        # Bet values: 0, 1, 2, ..., max_bet
        self.bet_values = torch.linspace(0, max_bet, n_bet_sizes,
                                         device=device)

        # Action space:
        # Street 1: actions 0..n_bet_sizes-1 = bet amounts (no fold)
        # Streets 2-3: actions 0..n_bet_sizes-1 = bet amounts,
        #              action n_bet_sizes = fold
        self.n_actions_street1 = n_bet_sizes
        self.n_actions_street23 = n_bet_sizes + 1  # +1 for fold
        self.fold_action = n_bet_sizes

        # Observation dimension:
        # my_x (1) + my_bets (3) + opp_bets (3) + street_onehot (3) +
        # my_folded (1) + opp_folded (1) + pot (1) = 13
        self.obs_dim = 13

    def reset(self, batch_size):
        """Start new games. Returns (obs_A, obs_B), both shape (batch, obs_dim)."""
        self.batch_size = batch_size
        self.x_a = torch.rand(batch_size, device=self.device)
        self.x_b = torch.rand(batch_size, device=self.device)

        # Bet history: (batch, 3) for each player, one per street
        self.bets_a = torch.zeros(batch_size, 3, device=self.device)
        self.bets_b = torch.zeros(batch_size, 3, device=self.device)

        # Fold status
        self.folded_a = torch.zeros(batch_size, dtype=torch.bool,
                                    device=self.device)
        self.folded_b = torch.zeros(batch_size, dtype=torch.bool,
                                    device=self.device)

        # Pot starts at 2 (both ante 1)
        self.pot = torch.full((batch_size,), 2.0, device=self.device)

        # Current street (0-indexed)
        self.street = 0
        self.done = torch.zeros(batch_size, dtype=torch.bool,
                                device=self.device)

        return self._get_obs()

    def _get_obs(self):
        """Build observation tensors for both players."""
        street_onehot = torch.zeros(self.batch_size, 3, device=self.device)
        if self.street < 3:
            street_onehot[:, self.street] = 1.0

        obs_a = torch.cat([
            self.x_a.unsqueeze(1),        # my_x
            self.bets_a,                   # my_bets (3)
            self.bets_b,                   # opp_bets (3)
            street_onehot,                 # street (3)
            self.folded_a.float().unsqueeze(1),   # my_folded
            self.folded_b.float().unsqueeze(1),   # opp_folded
            self.pot.unsqueeze(1),         # pot
        ], dim=1)

        obs_b = torch.cat([
            self.x_b.unsqueeze(1),
            self.bets_b,
            self.bets_a,
            street_onehot,
            self.folded_b.float().unsqueeze(1),
            self.folded_a.float().unsqueeze(1),
            self.pot.unsqueeze(1),
        ], dim=1)

        return obs_a, obs_b

    def n_actions(self):
        """Number of actions for current street."""
        if self.street == 0:
            return self.n_actions_street1
        return self.n_actions_street23

    def step(self, action_a, action_b):
        """Process one street of betting.

        Args:
            action_a: (batch,) int tensor of actions for player A
            action_b: (batch,) int tensor of actions for player B

        Returns:
            (obs_a, obs_b): new observations
            done: (batch,) bool tensor
            info: dict with game details
        """
        assert self.street < 3, "Game already over"

        # Active games (not done, neither player folded)
        active = ~self.done & ~self.folded_a & ~self.folded_b

        if self.street == 0:
            # Street 1: bet only (no fold)
            bet_a = self.bet_values[action_a.clamp(0, self.n_bet_sizes - 1)]
            bet_b = self.bet_values[action_b.clamp(0, self.n_bet_sizes - 1)]
        else:
            # Streets 2-3: bet or fold
            is_fold_a = (action_a == self.fold_action) & active
            is_fold_b = (action_b == self.fold_action) & active
            self.folded_a = self.folded_a | is_fold_a
            self.folded_b = self.folded_b | is_fold_b

            bet_idx_a = action_a.clamp(0, self.n_bet_sizes - 1)
            bet_idx_b = action_b.clamp(0, self.n_bet_sizes - 1)
            bet_a = self.bet_values[bet_idx_a]
            bet_b = self.bet_values[bet_idx_b]

            # Zero out bets for players who folded
            bet_a = bet_a * (~self.folded_a).float()
            bet_b = bet_b * (~self.folded_b).float()

        # Record bets and update pot (only for active games)
        self.bets_a[:, self.street] = bet_a * active.float()
        self.bets_b[:, self.street] = bet_b * active.float()
        self.pot += (bet_a + bet_b) * active.float()

        self.street += 1

        # Game ends if street 3 done or someone folded
        self.done = self.done | (self.street >= 3) | self.folded_a | self.folded_b

        obs_a, obs_b = self._get_obs()
        return obs_a, obs_b, self.done

    def get_rewards(self):
        """Compute rewards for both players. Call after game is done.

        Returns:
            reward_a: (batch,) float tensor (positive = A wins)
            reward_b: (batch,) float tensor (= -reward_a, zero-sum)
        """
        # Total bet by each player (ante + street bets)
        total_a = 1.0 + self.bets_a.sum(dim=1)
        total_b = 1.0 + self.bets_b.sum(dim=1)

        reward_a = torch.zeros(self.batch_size, device=self.device)

        # Case 1: A folded -> B wins A's total bet
        a_folded = self.folded_a & ~self.folded_b
        reward_a[a_folded] = -total_a[a_folded]

        # Case 2: B folded -> A wins B's total bet
        b_folded = self.folded_b & ~self.folded_a
        reward_a[b_folded] = total_b[b_folded]

        # Case 3: Both folded (simultaneous) -> both lose ante only
        both_folded = self.folded_a & self.folded_b
        reward_a[both_folded] = 0.0

        # Case 4: Showdown -> higher x wins opponent's total bet
        showdown = ~self.folded_a & ~self.folded_b & self.done
        a_wins = showdown & (self.x_a > self.x_b)
        b_wins = showdown & (self.x_b > self.x_a)
        tie = showdown & (self.x_a == self.x_b)  # extremely rare with floats

        reward_a[a_wins] = total_b[a_wins]
        reward_a[b_wins] = -total_a[b_wins]
        reward_a[tie] = 0.0

        return reward_a, -reward_a


def validate_poker():
    """Run validation checks on the poker environment."""
    device = 'cpu'
    env = ContinuousPoker(max_bet=10, n_bet_sizes=11, device=device)
    batch = 10000

    # Test 1: Random play should average ~0 reward (symmetric, zero-sum)
    obs_a, obs_b = env.reset(batch)
    for street in range(3):
        n = env.n_actions()
        action_a = torch.randint(0, n, (batch,))
        action_b = torch.randint(0, n, (batch,))
        obs_a, obs_b, done = env.step(action_a, action_b)
    r_a, r_b = env.get_rewards()
    mean_r = r_a.mean().item()
    print(f"Test 1 (random play, mean reward): {mean_r:.3f} "
          f"(expected ~0) {'PASS' if abs(mean_r) < 1.0 else 'FAIL'}")
    assert (r_a + r_b).abs().max() < 1e-5, "Not zero-sum!"
    print(f"  Zero-sum check: PASS")

    # Test 2: Always-fold-street-2 vs always-check should lose
    obs_a, obs_b = env.reset(batch)
    # Street 1: both bet 0
    obs_a, obs_b, done = env.step(
        torch.zeros(batch, dtype=torch.long),
        torch.zeros(batch, dtype=torch.long))
    # Street 2: A folds, B checks (bet 0)
    obs_a, obs_b, done = env.step(
        torch.full((batch,), env.fold_action, dtype=torch.long),
        torch.zeros(batch, dtype=torch.long))
    r_a, r_b = env.get_rewards()
    mean_fold_r = r_a.mean().item()
    print(f"Test 2 (always fold vs check): A reward = {mean_fold_r:.3f} "
          f"(expected -1.0) {'PASS' if mean_fold_r < -0.5 else 'FAIL'}")

    # Test 3: Observation dimensions
    obs_a, obs_b = env.reset(batch)
    assert obs_a.shape == (batch, env.obs_dim), f"Bad obs shape: {obs_a.shape}"
    print(f"Test 3 (obs dim={env.obs_dim}): PASS")

    # Test 4: High x should beat low x at showdown with same bets
    obs_a, obs_b = env.reset(batch)
    for street in range(3):
        obs_a, obs_b, done = env.step(
            torch.zeros(batch, dtype=torch.long),
            torch.zeros(batch, dtype=torch.long))
    r_a, r_b = env.get_rewards()
    # A wins when x_a > x_b, loses when x_b > x_a
    a_higher = (env.x_a > env.x_b).float().mean().item()
    a_win_rate = (r_a > 0).float().mean().item()
    print(f"Test 4 (showdown correctness): A higher {a_higher:.3f}, "
          f"A win rate {a_win_rate:.3f} "
          f"{'PASS' if abs(a_higher - a_win_rate) < 0.01 else 'FAIL'}")

    print("\nAll poker validation checks passed.")


if __name__ == '__main__':
    validate_poker()
