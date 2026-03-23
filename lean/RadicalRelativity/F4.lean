/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/

import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# F_4: Automorphism Group of h_3(O)

Aut(h_3(O)) = F_4, the compact exceptional Lie group (52-dimensional,
rank 4). This is a theorem of Chevalley-Schafer (1950).

## Key subgroups

F_4 has exactly two maximal Borel-de Siebenthal subgroups:

1. **Spin(9)**: stabilizer of a rank-1 idempotent E_i in h_3(O).
   F_4/Spin(9) = OP² (octonionic projective plane, 16-dim).
   dim(Spin(9)) = 36, so dim(F_4) = 36 + 16 = 52. ✓

2. **[SU(3) × SU(3)] / Z_3**: commutant of the order-3 automorphism
   induced by the octonion splitting O = C + C³ (choice of unit
   imaginary octonion u). One SU(3) is color, the other is flavor.

These are the two subgroups whose intersection gives the SM gauge group.

## Role in the program

The observer, as a C*-algebra subsystem of h_3(O), necessarily:
- Selects an idempotent (subsystem position) → breaks F_4 to Spin(9)
- Evolves a complex structure (self-modeling attractor) → breaks F_4
  to [SU(3) × SU(3)] / Z_3

The intersection of these two subgroups is the SM gauge group.

## What needs to be formalized

1. F_4 as a Lie group (or its Lie algebra f_4)
2. Aut(h_3(O)) = F_4 (the Chevalley-Schafer theorem)
3. The Spin(9) subgroup and its characterization as stabilizer of E_1
4. The [SU(3)×SU(3)]/Z_3 subgroup from the octonion splitting
5. The Borel-de Siebenthal classification for F_4

## References

* Chevalley, Schafer, "The exceptional simple Lie algebras F_4 and E_6,"
  Proc. Nat. Acad. Sci. 36 (1950)
* Borel, de Siebenthal, "Les sous-groupes fermés de rang maximum des
  groupes de Lie clos," Comment. Math. Helv. 23 (1949)
-/

-- TODO: Phase 4
-- F_4 is substantial Lie theory.
-- Likely axiomatize Aut(h_3(O)) = F_4 and the subgroup structure,
-- then prove the intersection computation from those axioms.
