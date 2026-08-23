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


/-! ## The Jordan triple product

`{x, y, z} = x(yz) + z(yx) − y(xz)`.  The quadratic representation is its diagonal,
`Q_x y = {x, y, x}`, and the operator `V_{x,y} = {x, y, ·}` is what the fundamental formula's
derivation actually manipulates: it is `L_{xy} + ⁅L_x, L_y⁆`, so the linearised Jordan identity —
a statement purely about commutators of `L`s — is exactly a statement about `V`. -/

/-- The **Jordan triple product** `{x, y, z} = x(yz) + z(yx) − y(xz)`. -/
def tripleJ (x y z : J) : J := x * (y * z) + z * (y * x) - y * (x * z)

@[simp] theorem tripleJ_apply (x y z : J) :
    tripleJ x y z = x * (y * z) + z * (y * x) - y * (x * z) := rfl

/-- **The quadratic representation is the diagonal of the triple product**: `Q_x y = {x, y, x}`.
This is the definition Jordan theory uses; `quadJ`'s `2L_x² − L_{x²}` form is the operator one. -/
theorem tripleJ_self (x y : J) : tripleJ x y x = quadJ x y := by
  have h1 : x * (y * x) = x * (x * y) := by rw [mul_comm y x]
  have h2 : y * (x * x) = x * x * y := mul_comm y (x * x)
  rw [tripleJ_apply, quadJ_apply, two_smul, h1, h2]

/-- **`{x, y, ·} = L_{xy} + ⁅L_x, L_y⁆`** — the triple product operator in terms of left
multiplications.  This is what turns the linearised Jordan identity, which speaks only about
commutators, into a statement about `V`. -/
theorem tripleJ_eq_mulL (x y z : J) :
    tripleJ x y z = x * y * z + (x * (y * z) - y * (x * z)) := by
  have h : z * (y * x) = x * y * z := by rw [mul_comm y x, mul_comm z (x * y)]
  rw [tripleJ_apply, h]
  abel

/-- **`{x, x, ·} = L_{x²}`.**  The diagonal of `V` is multiplication by the square: the commutator
term dies. -/
theorem tripleJ_diag (x z : J) : tripleJ x x z = x * x * z := by
  rw [tripleJ_eq_mulL, sub_self, add_zero]

/-- **`⁅L_{a²}, L_b⁆ = 2·⁅L_a, L_{ab}⁆`**, the diagonal linearised identity rearranged into the
form the ladder uses: a commutator against `L_{a²}` — the operator `Q_a` is built from — traded
for one against `L_{ab}`, which is one degree lower in `a`. -/
theorem comm_sq_eq_two_comm (a b w : J) :
    a * a * (b * w) - b * (a * a * w) = (2 : ℝ) • (a * (a * b * w) - a * b * (a * w)) := by
  have h := lin_jordan_diag a b w
  linear_combination (norm := module) -h

end RadicalRelativity.EJA
