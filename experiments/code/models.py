"""Network architectures for self-modeling experiments.

SelfModelingMLP: 3-hidden-layer MLP with self-prediction bottleneck.
Used for both MNIST (Phase 1b) and poker (Phase 1c/2) with different
input/output sizes.
"""

import torch
import torch.nn as nn


class SelfModelingMLP(nn.Module):
    """MLP with auxiliary self-prediction head.

    Architecture:
        input -> H1 (hidden) -> H2 (hidden) -> H3 (hidden) -> output
                                  |
                            sp_encode (bottleneck)
                                  |
                            sp_decode -> H2_pred

    Self-prediction target: H2 activations (detached).
    The self-prediction path shares the backbone through H2.
    """

    def __init__(self, input_dim, output_dim, hidden_dim=256,
                 bottleneck_dim=64):
        super().__init__()

        # Backbone
        self.h1 = nn.Linear(input_dim, hidden_dim)
        self.h2 = nn.Linear(hidden_dim, hidden_dim)
        self.h3 = nn.Linear(hidden_dim, hidden_dim)
        self.out = nn.Linear(hidden_dim, output_dim)

        # Self-prediction bottleneck
        self.sp_encode = nn.Linear(hidden_dim, bottleneck_dim)
        self.sp_decode = nn.Linear(bottleneck_dim, hidden_dim)

        self.relu = nn.ReLU()

    def forward(self, x):
        """Returns (output, h2_pred, h2_target).

        h2_target is detached - no gradient flows through it to the backbone
        via the self-prediction loss.
        """
        a1 = self.relu(self.h1(x))
        a2 = self.relu(self.h2(a1))
        a3 = self.relu(self.h3(a2))
        output = self.out(a3)

        # Self-prediction path
        sp_hidden = self.relu(self.sp_encode(a2))
        h2_pred = self.sp_decode(sp_hidden)

        return output, h2_pred, a2.detach()

    def forward_with_activations(self, x):
        """Like forward but also returns all hidden activations."""
        a1 = self.relu(self.h1(x))
        a2 = self.relu(self.h2(a1))
        a3 = self.relu(self.h3(a2))
        output = self.out(a3)

        sp_hidden = self.relu(self.sp_encode(a2))
        h2_pred = self.sp_decode(sp_hidden)

        return output, h2_pred, a2.detach(), {'a1': a1, 'a2': a2, 'a3': a3}


class PokerNetwork(nn.Module):
    """Poker-playing network with self-prediction head.

    Same hidden structure as SelfModelingMLP. Different input/output.

    Input: observation vector (my_x, bet history, game state)
    Output: action logits (bet sizes + fold)
    Also: self-prediction of H2 activations.
    """

    def __init__(self, obs_dim=14, n_actions=12, hidden_dim=256,
                 bottleneck_dim=64):
        super().__init__()

        # Backbone (same structure as SelfModelingMLP)
        self.h1 = nn.Linear(obs_dim, hidden_dim)
        self.h2 = nn.Linear(hidden_dim, hidden_dim)
        self.h3 = nn.Linear(hidden_dim, hidden_dim)

        # Game head
        self.action_head = nn.Linear(hidden_dim, n_actions)

        # Self-prediction bottleneck
        self.sp_encode = nn.Linear(hidden_dim, bottleneck_dim)
        self.sp_decode = nn.Linear(bottleneck_dim, hidden_dim)

        self.relu = nn.ReLU()

    def forward(self, obs):
        """Returns (action_logits, h2_pred, h2_target)."""
        a1 = self.relu(self.h1(obs))
        a2 = self.relu(self.h2(a1))
        a3 = self.relu(self.h3(a2))
        action_logits = self.action_head(a3)

        sp_hidden = self.relu(self.sp_encode(a2))
        h2_pred = self.sp_decode(sp_hidden)

        return action_logits, h2_pred, a2.detach()

    def act(self, obs, temperature=1.0):
        """Sample an action. Returns (action, log_prob, h2_pred, h2_target)."""
        action_logits, h2_pred, h2_target = self.forward(obs)
        probs = torch.softmax(action_logits / temperature, dim=-1)
        dist = torch.distributions.Categorical(probs)
        action = dist.sample()
        return action, dist.log_prob(action), h2_pred, h2_target, dist.entropy()


class EpistemicPokerNetwork(nn.Module):
    """Epistemic poker network with prediction head, bet head, and self-prediction.

    Same hidden backbone as all other phases (3x256 hidden layers + SP bottleneck).
    Two output heads from H3:
      - Prediction head: 8-dim continuous (predicted y* = Ax*)
      - Bet head: 11 logits for bet size (categorical)

    Input: observation vector (revealed data, test point, bet histories, game state)
    """

    def __init__(self, obs_dim=169, pred_dim=8, n_bet_sizes=11,
                 hidden_dim=256, bottleneck_dim=64):
        super().__init__()

        # Backbone (same structure as all other phases)
        self.h1 = nn.Linear(obs_dim, hidden_dim)
        self.h2 = nn.Linear(hidden_dim, hidden_dim)
        self.h3 = nn.Linear(hidden_dim, hidden_dim)

        # Prediction head (continuous output)
        self.pred_head = nn.Linear(hidden_dim, pred_dim)

        # Bet head (categorical)
        self.bet_head = nn.Linear(hidden_dim, n_bet_sizes)

        # Self-prediction bottleneck
        self.sp_encode = nn.Linear(hidden_dim, bottleneck_dim)
        self.sp_decode = nn.Linear(bottleneck_dim, hidden_dim)

        self.relu = nn.ReLU()

    def forward(self, obs):
        """Returns (prediction, bet_logits, h2_pred, h2_target)."""
        a1 = self.relu(self.h1(obs))
        a2 = self.relu(self.h2(a1))
        a3 = self.relu(self.h3(a2))

        prediction = self.pred_head(a3)
        bet_logits = self.bet_head(a3)

        sp_hidden = self.relu(self.sp_encode(a2))
        h2_pred = self.sp_decode(sp_hidden)

        return prediction, bet_logits, h2_pred, a2.detach()

    def act(self, obs, temperature=1.0):
        """Forward pass + sample bet action.

        Returns (prediction, bet_action, bet_log_prob, h2_pred, h2_target, bet_entropy).
        """
        prediction, bet_logits, h2_pred, h2_target = self.forward(obs)
        probs = torch.softmax(bet_logits / temperature, dim=-1)
        dist = torch.distributions.Categorical(probs)
        bet_action = dist.sample()
        return (prediction, bet_action, dist.log_prob(bet_action),
                h2_pred, h2_target, dist.entropy())
