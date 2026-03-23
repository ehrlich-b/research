/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/

import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# Chirality from Cl(6)

The weak force only couples to left-handed fermions (parity violation).
In the octonionic framework, chirality requires complexification of h_3(O)
to h_3^C(O), upgrading F_4 → E_6 and Spin(9) → Spin(10).

## The resolution path

The SAME octonion splitting O = C + C³ that gives the SM gauge group
(via [SU(3)×SU(3)]/Z_3) ALSO induces a Cl(6) subalgebra inside Cl(10).

1. Observer's C*-nature forces complexification of V_1 = O² (16-dim real
   Spin(9) spinor) to (C⊗O)² (16-dim complex Spin(10) Weyl spinor).
2. Chirality (16_L vs 16_R) is INTRINSIC to Spin(10) — the volume element
   of Cl(10) splits the Dirac spinor automatically.
3. The octonion splitting O = C + C³ gives 6 "internal" directions that
   generate Cl(6) ⊂ Cl(10).
4. The Cl(6) volume form ω₆ defines a particle projector P = ½(1 - iω₆).
5. The stabilizer of ω₆ in Spin(10) is the Pati-Salam group.
6. Breaking Pati-Salam via the complex structure gives SM with the LEFT
   (chiral) embedding (Furey 2018: automatic, no ad hoc projector).

ONE CHOICE (complex structure on O) does THREE things:
- Gives the SM gauge group (Gap B)
- Forces complexification → chirality exists
- Induces Cl(6) → selects the chiral embedding

## The Baez-Sawin problem and why complexification fixes it

Sawin's theorem: two conjugacy classes of SU(2)×SU(3) in Spin(10):
- Left (chiral, correct): does NOT fit inside Spin(9)
- Diagonal (symmetric, wrong): DOES fit inside Spin(9)

At the F_4/Spin(9) level, all reps are self-dual → only diagonal embedding.
Complexification to E_6/Spin(10) makes both available. The observer's
complex nature forces complexification and the Cl(6) mechanism selects left.

## Status

GPD prompt written at ~/scratch/get-physics-done/paper7-chirality-h3o-prompt.md.
Pending computational verification that the Cl(6) assembly through the Peirce
decomposition starting point gives the correct chiral embedding.

## What needs to be formalized

1. Cl(10) acting on complexified V_1 = (C⊗O)²
2. Cl(6) as subalgebra from the octonion splitting
3. Volume form ω₆ and the particle projector
4. Pati-Salam as stabilizer of ω₆
5. The breaking to SM with left embedding

## References

* Furey, arXiv:1806.00612 (automatic parity violation from Cl(6))
* Todorov, arXiv:2206.06912 (Cl(6) inside Cl(10), ω₆ projector)
* Baez, n-Category Cafe Part 13, Dec 2025 (Sawin's theorem)
* Krasnov, arXiv:2504.16465 (complex structures and SM fermions)
* Boyle, arXiv:2006.16265 (complexification, triality, 3 generations)
-/

-- TODO: Phase 5 (after GPD verification)
-- Depends on: Octonions.lean, Albert.lean, ObserverInterface.lean
-- The Clifford algebra Cl(10) may need Mathlib's Clifford algebra API.
