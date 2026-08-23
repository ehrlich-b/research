/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Spectral
import RadicalRelativity.EJA.PeirceMul

set_option linter.style.longLine false

/-!
# Toward the fundamental formula `Q_{Q_a b} = Q_a Q_b Q_a`

The quadratic representation `Q_a = 2L_a² − L_{a²}` (`EJA/Spectral.lean`'s `quadJ`) satisfies the
**fundamental formula**, which is the central operator identity of Jordan theory: everything about
inverses, the structure group, and sequential products on a Jordan algebra runs through it.

★ **Mathlib does not have it.**  `Mathlib/Algebra/Jordan/Basic.lean` is the only Jordan-algebra
file in Mathlib and carries `IsJordan`/`IsCommJordan` and their three defining identities and
nothing further — no quadratic representation, no fundamental formula, no Peirce theory (verified
2026-08-23; every other Mathlib file matching "Jordan" is Jordan–Hölder, Jordan–Chevalley, or the
Jordan decomposition of measures).  So this development is upstreamable in its own right,
independently of what it is being built for here.

This file is the ladder.  Its engine is `EJA/PeirceMul.lean`'s `lin_jordan_apply` — the fully
linearised Jordan identity with the torsion factor cancelled — together with its diagonal
specialisation `lin_jordan_diag`.

## What is proved so far

* `mulL_comm_sq` — `⁅L_a, L_{a²}⁆ = 0`, from the linearised identity at `p = q = b = a`, where the
  three cyclic terms coincide and the factor `3` cancels over `ℝ`.
* `quadJ_mulL_comm` — `Q_a L_a = L_a Q_a`, the first operator identity of the ladder.
-/

namespace RadicalRelativity.EJA

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J]

/-- **`⁅L_a, L_{a²}⁆ = 0`.**  At `p = q = b = a` the three cyclic terms of the linearised Jordan
identity coincide, so it reads `3·⁅L_a, L_{a²}⁆ = 0`, and the factor cancels over `ℝ`.

This is the operator form of power associativity, and it is the reason `Q_a` commutes with `L_a`. -/
theorem mulL_comm_sq (a w : J) : a * (a * a * w) = a * a * (a * w) := by
  have h := lin_jordan_apply a a a w
  have h3 : (3 : ℝ) • (a * (a * a * w) - a * a * (a * w)) = 0 := by
    linear_combination (norm := module) h
  rcases smul_eq_zero.mp h3 with hc | hx
  · exact absurd hc (by norm_num)
  · exact sub_eq_zero.mp hx

/-- **`Q_a L_a = L_a Q_a`** — the quadratic representation commutes with left multiplication by
its own argument.  Immediate from `mulL_comm_sq` once `Q_a` is expanded. -/
theorem quadJ_mulL_comm (a w : J) : quadJ a (a * w) = a * quadJ a w := by
  rw [quadJ_apply, quadJ_apply, mul_sub, mulL_comm_sq]
  have hsm : ∀ (t : ℝ) (u v : J), u * (t • v) = t • (u * v) := by
    intro t u v
    rw [mul_comm u (t • v), smul_mul_assoc, mul_comm v u]
  rw [hsm]

end RadicalRelativity.EJA
