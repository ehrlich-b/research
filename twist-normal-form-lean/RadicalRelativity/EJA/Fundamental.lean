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

## The two targets, and what is known about the cost of reaching them

```
(FF1)  V_{x,y} U_x = U_x V_{y,x}      `tripleJ x y (quadJ x z) = quadJ x (tripleJ y x z)`
(FF2)  U_{U_x y} = U_x U_y U_x        the fundamental formula
```

★ **Both are TRUE and were checked before any effort was spent on them** (2026-08-23): evaluated
on 200 random triples of symmetric `3×3` real matrices under `a ∘ b = ½(ab + ba)`, the maximum
relative discrepancy was `2.3e-15` for (FF1) and `3.7e-14` for (FF2) — machine precision.  So the
statements above are the right ones; what follows is about proving them, not about whether they
hold.

★★★ **A NEGATIVE RESULT WAS RECORDED HERE ON 2026-08-23 AND IT WAS WRONG.  It is replaced,
not deleted, because how it was wrong is the useful part.**

The claim was: "(FF1) is not a linear combination of degree-5 instances of the linearised Jordan
identity", on the evidence of an inconsistent linear system over `ℚ` across 390 relations, said to
include "full commutativity `uv = vu` at every product node".

**It does not include that, and that is the whole error.**  The commutativity relations generated
were swaps at the *root* of each monomial only.  Relating two trees that differ at a **deep** node
needs commutativity *in context* — `w·(u·v) = w·(v·u)` — which is not of the form `uv = vu` and was
never generated.  The system was inconsistent because the search space was incomplete, not because
the goal was outside the span.

**(FF1) is a linear combination of exactly eight instances**, with coefficients
`+1, −2, +1, +1, −1, −2/3, −1, +1/3`; `tripleJ_quadJ_comm` below is that certificate.  It is found
by solving in the free *commutative* non-associative `ℚ`-algebra, where the identification is
automatic.

★ **The one real obstacle, and its fix, are worth keeping.**  `linear_combination (norm := module)`
compares atoms **syntactically**, so a commutative-model certificate does not transfer as-is.
`simp only [mul_comm]` does not help: as a general lemma it rewrites by term order and never
reaches a normal form on nested products.  What works is **oriented ground instances** —
`mul_comm (x * z) x` and twenty others, each a specific rewrite pointed at a fixed total order on
trees.  Each strictly decreases a well-founded order, so `simp only` terminates, and every atom
lands in the canonical form the solver used.

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


/-! ## Polarisation of the quadratic representation

`Q` is quadratic in its subscript, so its polarisation `Q_{x+y} − Q_x − Q_y` is the symmetric
bilinear object every derivation of the fundamental formula runs on.  It is `2{x, ·, y}` — twice
the triple product with the two outer slots split — which is why the triple product is the right
primitive and `Q` the derived one. -/

/-- **`Q_x x = x³`**, in the bracketing the tree's `jpow` uses. -/
theorem quadJ_self (x : J) : quadJ x x = x * (x * x) := by
  rw [quadJ_apply, two_smul, mul_comm (x * x) x]
  abel

/-- **The polarisation identity** `Q_{x+y} − Q_x − Q_y = 2·{x, ·, y}`.

Both sides are checked by expanding; the only non-formal step is that `Q`'s `L_{x²}` term
contributes the cross term `2(xy)z`, which is exactly the `−z(xy)` of the triple product doubled
and re-signed. -/
theorem quadJ_polarisation (x y z : J) :
    quadJ (x + y) z - quadJ x z - quadJ y z = (2 : ℝ) • tripleJ x z y := by
  have hxy : (x + y) * ((x + y) * z) =
      x * (x * z) + x * (y * z) + (y * (x * z) + y * (y * z)) := by
    simp only [add_mul, mul_add]
    abel
  have hsq : (x + y) * (x + y) * z = x * x * z + x * y * z + (y * x * z + y * y * z) := by
    simp only [add_mul, mul_add]
    abel
  have hcomm : y * x * z = x * y * z := by rw [mul_comm y x]
  rw [quadJ_apply, quadJ_apply, quadJ_apply, tripleJ_apply, hxy, hsq, hcomm,
    two_smul, two_smul, two_smul, two_smul]
  have h1 : z * (x * y) = x * y * z := by rw [mul_comm z (x * y)]
  have h2 : x * (z * y) = x * (y * z) := by rw [mul_comm z y]
  have h3 : y * (z * x) = y * (x * z) := by rw [mul_comm z x]
  rw [h1, h2, h3]
  abel

/-! ## The crux commutation `V_{x,y} U_x = U_x V_{y,x}`

Elementwise this is `{x, y, Q_x z} = Q_x {y, x, z}` — the first genuinely hard step toward the
fundamental formula.  Per the negative result recorded at the top of this file, it is **not** a
linear combination of degree-5 instances of `lin_jordan_apply` over the *free* algebra; but over
the free **commutative** nonassociative algebra it is, with eight instances (two of them
multiplied through by a generator).  The certificate was found by linear algebra over `ℚ` and
re-verified by the generator script before being committed to Lean.

The Lean obstacle is purely syntactic: `linear_combination (norm := module)` compares atoms up to
syntax, and `x * (y * z)` ≠ `(y * z) * x` to it.  The fix: canonicalise every monomial atom first
with a finite set of *oriented ground* `mul_comm` instances — one per out-of-order product node
occurring in the goal or in any certificate instance, oriented toward a fixed total order on
monomial trees.  `simp only` with these terminates (each rewrite strictly decreases the order) and
lands every atom in the same canonical form the certificate was verified in, after which the
eight-term combination closes. -/

/-- **`V_{x,y} U_x = U_x V_{y,x}`** — the triple-product operator commutes past the quadratic
representation of its own leading argument, elementwise: `{x, y, Q_x z} = Q_x {y, x, z}`.

This is the crux operator identity on the way to the fundamental formula
`Q_{Q_x y} = Q_x Q_y Q_x`: it is what lets `Q_x` be dragged through a triple product. -/
theorem tripleJ_quadJ_comm (x y z : J) :
    tripleJ x y (quadJ x z) = quadJ x (tripleJ y x z) := by
  -- The eight certificate instances.  `h7`/`h8` are instances multiplied through by a
  -- generator, which is why they enter via `congrArg` and get distributed.
  have h1 := lin_jordan_apply (x * z) x x y
  have h2 := lin_jordan_apply (x * z) x y x
  have h3 := lin_jordan_apply (y * z) x x x
  have h4 := lin_jordan_apply x y z (x * x)
  have h5 := lin_jordan_apply x x z (x * y)
  have h6 := lin_jordan_apply x x x (y * z)
  have h7 := congrArg (fun t => x * t) (lin_jordan_apply x x y z)
  have h8 := congrArg (fun t => y * t) (lin_jordan_apply x x x z)
  simp only [mul_sub, mul_add, mul_zero] at h7 h8
  -- Unfold the goal and distribute products over sums and scalars, so every atom is a bare
  -- monomial tree.
  simp only [tripleJ_apply, quadJ_apply, mul_sub, mul_add, sub_mul,
    mul_smul_comm', smul_mul_assoc]
  -- Canonicalise every monomial atom: oriented ground `mul_comm` instances, one per
  -- out-of-order product node.  Leaves are ordered `x < y < z`, smaller trees first.
  simp only [mul_comm y x, mul_comm (x * x) x, mul_comm (x * x) y, mul_comm (x * x) z,
    mul_comm (x * y) x, mul_comm (x * y) z, mul_comm (x * z) x, mul_comm (x * z) y,
    mul_comm (y * z) x, mul_comm (x * y) (x * x), mul_comm (x * z) (x * x),
    mul_comm (x * z) (x * y), mul_comm (y * z) (x * x), mul_comm (x * (x * z)) x,
    mul_comm (x * (x * z)) y, mul_comm (x * (y * z)) x, mul_comm (y * (x * z)) x,
    mul_comm (x * (x * z)) (x * y), mul_comm (x * (y * z)) (x * x),
    mul_comm (y * (x * z)) (x * x), mul_comm (z * (x * x)) (x * y)]
    at h1 h2 h3 h4 h5 h6 h7 h8 ⊢
  linear_combination (norm := module) h1 - (2 : ℝ) • h2 + h3 + h4 - h5
    - ((2 : ℝ) / 3) • h6 - h7 + ((1 : ℝ) / 3) • h8

end RadicalRelativity.EJA
