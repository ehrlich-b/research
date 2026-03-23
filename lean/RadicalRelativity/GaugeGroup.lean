/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/

import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# The Standard Model Gauge Group from F_4

The Todorov-Drenska theorem (2018): the intersection of the two maximal
Borel-de Siebenthal subgroups of F_4 is the Standard Model gauge group.

  Spin(9) ∩ [SU(3) × SU(3)] / Z_3 = (U(1) × SU(2) × SU(3)) / Z_6

This is a theorem, not a model-building choice. The SM gauge group with
the correct Z_6 quotient falls out of the subgroup intersection.

## The two subgroups

**Spin(9)** = stabilizer of rank-1 idempotent E_1 in h_3(O).
- The observer's position (Peirce decomposition, Gap B step 1)
- dim = 36, F_4/Spin(9) = OP² (16-dim octonionic projective plane)

**[SU(3) × SU(3)] / Z_3** = commutant of the order-3 automorphism from
the octonion splitting O = C + C³.
- The observer's complex structure (Gap B step 2, self-modeling attractor)
- One SU(3) = color, other SU(3) = flavor
- Z_3 acts trivially on h_3(O)

## The intersection

The generators I_3 (weak isospin) and Y (hypercharge) arise consistently
from both decompositions (Todorov-Drenska Sections 4.1-4.3). Hypercharge
assignments are correct for all first-generation fermions.

The Z_6 quotient is partially derived from the embedding structure:
U_Y = e^{2πiY} satisfies U_Y² + U_Y + 1 = 0.

## Equivalent characterizations

- **Baez**: "The SM gauge group consists of the symmetries of an octonionic
  qutrit that restrict to symmetries of an octonionic qubit and preserve
  all the structure arising from a choice of unit imaginary octonion."
- **Krasnov** (arXiv:1912.11282): G_SM = subgroup of Spin(9) commuting
  with right multiplication by a unit imaginary octonion on O².

## What needs to be formalized

1. State the intersection theorem (depends on F4.lean subgroup definitions)
2. Verify the intersection computation (Lie algebra level)
3. Verify hypercharge assignments
4. Verify the Z_6 quotient structure

## References

* Todorov, Drenska, arXiv:1805.06739
* Todorov, Dubois-Violette, arXiv:1806.09450
* Krasnov, arXiv:1912.11282
* Baez, "Can We Understand the Standard Model Using Octonions?"
-/

-- TODO: Phase 4
-- The intersection computation is concrete Lie theory.
-- Could axiomatize the subgroup structure from F4.lean and compute
-- the intersection at the Lie algebra level.
