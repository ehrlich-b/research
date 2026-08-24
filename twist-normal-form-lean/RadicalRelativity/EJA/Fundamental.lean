/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Spectral
import RadicalRelativity.EJA.PeirceMul

set_option linter.style.longLine false

/-!
# The fundamental formula `Q_{Q_a b} = Q_a Q_b Q_a`

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

## The two targets — both now proved

```
(FF1)  V_{x,y} U_x = U_x V_{y,x}      `tripleJ_quadJ_comm`
(FF2)  U_{U_x y} = U_x U_y U_x        `quadJ_quadJ_quadJ` — the fundamental formula
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

## What is proved

* `mulL_comm_sq` — `⁅L_a, L_{a²}⁆ = 0`, from the linearised identity at `p = q = b = a`, where the
  three cyclic terms coincide and the factor `3` cancels over `ℝ`.
* `quadJ_mulL_comm` — `Q_a L_a = L_a Q_a`, the first operator identity of the ladder.
* `tripleJ_quadJ_comm` — (FF1), the crux commutation, an eight-instance certificate.
* `quadJ_quadJ_quadJ` — **(FF2), the fundamental formula itself**, a 208-instance certificate
  found the same way one degree up.
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


/-! ## The fundamental formula `U_{U_x y} = U_x U_y U_x`

The same certificate technique as `tripleJ_quadJ_comm`, one degree up: (FF2) is
multihomogeneous of degree `(4, 2, 1)` in `(x, y, z)`, and over the free *commutative*
nonassociative `ℚ`-algebra it is a linear combination of **208** instances of
`lin_jordan_apply` — 151 plain, 47 multiplied through by one generator monomial, 9 by two,
1 by three.  The certificate was found by Gaussian elimination over `ℚ` on the full
degree-`(4,2,1)` instance space and re-verified in the model before being committed here; the
hypothesis list, the canonicalisation `simp` set, and the final combination are all
machine-generated from it.

The canonicalisation pass is the same oriented-ground-`mul_comm` device as in
`tripleJ_quadJ_comm`, at scale: 784 distinct monomial trees appear across the goal and the
208 hypotheses, folding onto 302 canonical atoms via 364 oriented instances — each pointed at
a fixed total order on trees (leaves `x < y < z` before compounds, recursively), so `simp only`
terminates and every atom lands in the form the certificate was solved in. -/

set_option maxHeartbeats 2400000 in
-- 208 hypotheses, a 364-lemma canonicalisation `simp`, and a 1248-monomial `module` call:
-- the default budget is exceeded roughly tenfold.
/-- **The fundamental formula** `Q_{Q_x y} = Q_x Q_y Q_x`, elementwise — the central operator
identity of Jordan theory: inverses, the structure group, and the sequential product all run
through it.  Mathlib does not have it (2026-08-23). -/
theorem quadJ_quadJ_quadJ (x y z : J) :
    quadJ (quadJ x y) z = quadJ x (quadJ y (quadJ x z)) := by
  have h1 := lin_jordan_apply x x x (y * (z * (x * y)))
  have h2 := lin_jordan_apply x x x ((x * z) * (y * y))
  have h3 := lin_jordan_apply x x x (y * (y * (x * z)))
  have h4 := lin_jordan_apply x x x (x * (z * (y * y)))
  have h5 := lin_jordan_apply x x x (z * (y * (x * y)))
  have h6 := lin_jordan_apply x x x (z * (x * (y * y)))
  have h7 := lin_jordan_apply x x x ((x * y) * (y * z))
  have h8 := lin_jordan_apply x x x (x * (y * (y * z)))
  have h9 := lin_jordan_apply x x x (y * (x * (y * z)))
  have h10 := lin_jordan_apply x x y (y * (x * (x * z)))
  have h11 := lin_jordan_apply x x y (x * (z * (x * y)))
  have h12 := lin_jordan_apply x x y (x * (y * (x * z)))
  have h13 := lin_jordan_apply x x y (z * (y * (x * x)))
  have h14 := lin_jordan_apply x x y (z * (x * (x * y)))
  have h15 := lin_jordan_apply x x y ((x * y) * (x * z))
  have h16 := lin_jordan_apply x x y ((x * x) * (y * z))
  have h17 := lin_jordan_apply x x y (x * (x * (y * z)))
  have h18 := lin_jordan_apply x x y (y * (z * (x * x)))
  have h19 := lin_jordan_apply x x z (x * (y * (x * y)))
  have h20 := lin_jordan_apply x x z (x * (x * (y * y)))
  have h21 := lin_jordan_apply x x z ((x * y) * (x * y))
  have h22 := lin_jordan_apply x x z (y * (y * (x * x)))
  have h23 := lin_jordan_apply x x z (y * (x * (x * y)))
  have h24 := lin_jordan_apply x x z ((x * x) * (y * y))
  have h25 := lin_jordan_apply x x (x * x) (y * (y * z))
  have h26 := lin_jordan_apply x x (x * x) (z * (y * y))
  have h27 := lin_jordan_apply x x (x * y) (z * (x * y))
  have h28 := lin_jordan_apply x x (x * y) (y * (x * z))
  have h29 := lin_jordan_apply x x (x * y) (x * (y * z))
  have h30 := lin_jordan_apply x x (x * z) (x * (y * y))
  have h31 := lin_jordan_apply x x (x * z) (y * (x * y))
  have h32 := lin_jordan_apply x x (y * y) (z * (x * x))
  have h33 := lin_jordan_apply x x (y * y) (x * (x * z))
  have h34 := lin_jordan_apply x x (y * z) (x * (x * y))
  have h35 := lin_jordan_apply x x (y * z) (y * (x * x))
  have h36 := lin_jordan_apply x x (y * (x * x)) (y * z)
  have h37 := lin_jordan_apply x x (z * (x * x)) (y * y)
  have h38 := lin_jordan_apply x x (x * (x * z)) (y * y)
  have h39 := lin_jordan_apply x x (x * (y * y)) (x * z)
  have h40 := lin_jordan_apply x x (y * (x * y)) (x * z)
  have h41 := lin_jordan_apply x x (z * (x * y)) (x * y)
  have h42 := lin_jordan_apply x x (y * (x * z)) (x * y)
  have h43 := lin_jordan_apply x x (x * (y * z)) (x * y)
  have h44 := lin_jordan_apply x x (y * (y * z)) (x * x)
  have h45 := lin_jordan_apply x x (z * (y * y)) (x * x)
  have h46 := lin_jordan_apply x x ((x * y) * (x * z)) y
  have h47 := lin_jordan_apply x x ((x * x) * (y * z)) y
  have h48 := lin_jordan_apply x x (y * (y * (x * z))) x
  have h49 := lin_jordan_apply x x (z * (y * (x * y))) x
  have h50 := lin_jordan_apply x x (z * (x * (y * y))) x
  have h51 := lin_jordan_apply x y y ((x * x) * (x * z))
  have h52 := lin_jordan_apply x y y (x * (z * (x * x)))
  have h53 := lin_jordan_apply x y y (z * (x * (x * x)))
  have h54 := lin_jordan_apply x y y (x * (x * (x * z)))
  have h55 := lin_jordan_apply x y z (y * (x * (x * x)))
  have h56 := lin_jordan_apply x y z (x * (x * (x * y)))
  have h57 := lin_jordan_apply x y z (x * (y * (x * x)))
  have h58 := lin_jordan_apply x y (x * x) (z * (x * y))
  have h59 := lin_jordan_apply x y (x * x) (x * (y * z))
  have h60 := lin_jordan_apply x y (x * y) (z * (x * x))
  have h61 := lin_jordan_apply x y (x * z) (x * (x * y))
  have h62 := lin_jordan_apply x y (x * z) (y * (x * x))
  have h63 := lin_jordan_apply x y (y * z) (x * (x * x))
  have h64 := lin_jordan_apply x y (x * (x * y)) (x * z)
  have h65 := lin_jordan_apply x y (y * (x * x)) (x * z)
  have h66 := lin_jordan_apply x y (z * (x * x)) (x * y)
  have h67 := lin_jordan_apply x y (x * (x * z)) (x * y)
  have h68 := lin_jordan_apply x y (z * (x * y)) (x * x)
  have h69 := lin_jordan_apply x y (y * (x * z)) (x * x)
  have h70 := lin_jordan_apply x y (z * (x * (x * y))) x
  have h71 := lin_jordan_apply x z (x * x) (x * (y * y))
  have h72 := lin_jordan_apply x z (x * x) (y * (x * y))
  have h73 := lin_jordan_apply x z (x * y) (x * (x * y))
  have h74 := lin_jordan_apply x z (x * y) (y * (x * x))
  have h75 := lin_jordan_apply x z (y * y) (x * (x * x))
  have h76 := lin_jordan_apply x (x * x) (x * z) (y * y)
  have h77 := lin_jordan_apply x (x * x) (y * y) (x * z)
  have h78 := lin_jordan_apply x (x * x) (x * (y * y)) z
  have h79 := lin_jordan_apply x (x * x) (y * (x * y)) z
  have h80 := lin_jordan_apply x (x * x) (z * (x * y)) y
  have h81 := lin_jordan_apply x (x * x) (y * (x * z)) y
  have h82 := lin_jordan_apply x (x * x) (x * (y * z)) y
  have h83 := lin_jordan_apply x (x * x) (y * (y * z)) x
  have h84 := lin_jordan_apply x (x * x) (z * (y * y)) x
  have h85 := lin_jordan_apply x (x * y) (x * y) (x * z)
  have h86 := lin_jordan_apply x (x * y) (x * z) (x * y)
  have h87 := lin_jordan_apply x (x * y) (y * z) (x * x)
  have h88 := lin_jordan_apply x (x * y) (x * (x * y)) z
  have h89 := lin_jordan_apply x (x * y) (y * (x * x)) z
  have h90 := lin_jordan_apply x (x * y) (z * (x * x)) y
  have h91 := lin_jordan_apply x (x * y) (x * (x * z)) y
  have h92 := lin_jordan_apply x (x * y) (z * (x * y)) x
  have h93 := lin_jordan_apply x (x * y) (y * (x * z)) x
  have h94 := lin_jordan_apply x (x * y) (x * (y * z)) x
  have h95 := lin_jordan_apply x (x * z) (y * y) (x * x)
  have h96 := lin_jordan_apply x (x * z) (x * (x * y)) y
  have h97 := lin_jordan_apply x (x * z) (y * (x * x)) y
  have h98 := lin_jordan_apply x (x * z) (x * (y * y)) x
  have h99 := lin_jordan_apply x (x * z) (y * (x * y)) x
  have h100 := lin_jordan_apply x (y * y) (x * (x * x)) z
  have h101 := lin_jordan_apply x (y * y) (z * (x * x)) x
  have h102 := lin_jordan_apply x (y * y) (x * (x * z)) x
  have h103 := lin_jordan_apply x (y * z) (x * (x * x)) y
  have h104 := lin_jordan_apply x (y * z) (x * (x * y)) x
  have h105 := lin_jordan_apply x (y * z) (y * (x * x)) x
  have h106 := lin_jordan_apply y y z (x * (x * (x * x)))
  have h107 := lin_jordan_apply y y z ((x * x) * (x * x))
  have h108 := lin_jordan_apply y y (x * x) (z * (x * x))
  have h109 := lin_jordan_apply y y (x * x) (x * (x * z))
  have h110 := lin_jordan_apply y y (x * z) (x * (x * x))
  have h111 := lin_jordan_apply y y (x * (x * x)) (x * z)
  have h112 := lin_jordan_apply y y (x * (x * z)) (x * x)
  have h113 := lin_jordan_apply y z (x * x) (x * (x * y))
  have h114 := lin_jordan_apply y z (x * x) (y * (x * x))
  have h115 := lin_jordan_apply y z (x * y) (x * (x * x))
  have h116 := lin_jordan_apply y z (x * (x * x)) (x * y)
  have h117 := lin_jordan_apply y z (x * (x * y)) (x * x)
  have h118 := lin_jordan_apply y (x * x) (x * y) (x * z)
  have h119 := lin_jordan_apply y (x * x) (x * z) (x * y)
  have h120 := lin_jordan_apply y (x * x) (y * z) (x * x)
  have h121 := lin_jordan_apply y (x * x) (x * (x * y)) z
  have h122 := lin_jordan_apply y (x * x) (y * (x * x)) z
  have h123 := lin_jordan_apply y (x * x) (z * (x * x)) y
  have h124 := lin_jordan_apply y (x * x) (x * (x * z)) y
  have h125 := lin_jordan_apply y (x * x) (z * (x * y)) x
  have h126 := lin_jordan_apply y (x * x) (y * (x * z)) x
  have h127 := lin_jordan_apply y (x * x) (x * (y * z)) x
  have h128 := lin_jordan_apply y (x * y) (x * z) (x * x)
  have h129 := lin_jordan_apply y (x * y) (x * (x * x)) z
  have h130 := lin_jordan_apply y (x * y) (z * (x * x)) x
  have h131 := lin_jordan_apply y (x * y) (x * (x * z)) x
  have h132 := lin_jordan_apply y (x * z) (x * (x * x)) y
  have h133 := lin_jordan_apply y (x * z) (x * (x * y)) x
  have h134 := lin_jordan_apply y (x * z) (y * (x * x)) x
  have h135 := lin_jordan_apply y (y * z) (x * (x * x)) x
  have h136 := lin_jordan_apply z (x * x) (x * x) (y * y)
  have h137 := lin_jordan_apply z (x * x) (x * y) (x * y)
  have h138 := lin_jordan_apply z (x * x) (y * y) (x * x)
  have h139 := lin_jordan_apply z (x * x) (x * (x * y)) y
  have h140 := lin_jordan_apply z (x * x) (y * (x * x)) y
  have h141 := lin_jordan_apply z (x * x) (x * (y * y)) x
  have h142 := lin_jordan_apply z (x * x) (y * (x * y)) x
  have h143 := lin_jordan_apply z (x * y) (x * y) (x * x)
  have h144 := lin_jordan_apply z (x * y) (x * (x * x)) y
  have h145 := lin_jordan_apply z (x * y) (x * (x * y)) x
  have h146 := lin_jordan_apply z (x * y) (y * (x * x)) x
  have h147 := lin_jordan_apply z (y * y) (x * (x * x)) x
  have h148 := lin_jordan_apply (x * x) (x * x) (y * y) z
  have h149 := lin_jordan_apply (x * x) (x * x) (y * z) y
  have h150 := lin_jordan_apply (x * x) (x * z) (y * y) x
  have h151 := lin_jordan_apply (x * y) (x * y) (x * z) x
  have h152 := congrArg (fun t => x * t) (lin_jordan_apply x x x (y * (y * z)))
  have h153 := congrArg (fun t => x * t) (lin_jordan_apply x x x (z * (y * y)))
  have h154 := congrArg (fun t => x * t) (lin_jordan_apply x x y (z * (x * y)))
  have h155 := congrArg (fun t => x * t) (lin_jordan_apply x x y (x * (y * z)))
  have h156 := congrArg (fun t => x * t) (lin_jordan_apply x x z (x * (y * y)))
  have h157 := congrArg (fun t => x * t) (lin_jordan_apply x x z (y * (x * y)))
  have h158 := congrArg (fun t => x * t) (lin_jordan_apply x x (x * z) (y * y))
  have h159 := congrArg (fun t => x * t) (lin_jordan_apply x x (z * (x * y)) y)
  have h160 := congrArg (fun t => x * t) (lin_jordan_apply x y y (z * (x * x)))
  have h161 := congrArg (fun t => x * t) (lin_jordan_apply x y z (x * (x * y)))
  have h162 := congrArg (fun t => x * t) (lin_jordan_apply x y z (y * (x * x)))
  have h163 := congrArg (fun t => x * t) (lin_jordan_apply x y (x * x) (y * z))
  have h164 := congrArg (fun t => x * t) (lin_jordan_apply x y (x * z) (x * y))
  have h165 := congrArg (fun t => x * t) (lin_jordan_apply x z (x * x) (y * y))
  have h166 := congrArg (fun t => x * t) (lin_jordan_apply x z (x * y) (x * y))
  have h167 := congrArg (fun t => x * t) (lin_jordan_apply x z (y * y) (x * x))
  have h168 := congrArg (fun t => x * t) (lin_jordan_apply x (x * x) (y * y) z)
  have h169 := congrArg (fun t => x * t) (lin_jordan_apply x (x * x) (y * z) y)
  have h170 := congrArg (fun t => x * t) (lin_jordan_apply y y z (x * (x * x)))
  have h171 := congrArg (fun t => x * t) (lin_jordan_apply y y (x * x) (x * z))
  have h172 := congrArg (fun t => x * t) (lin_jordan_apply y y (x * z) (x * x))
  have h173 := congrArg (fun t => x * t) (lin_jordan_apply y z (x * x) (x * y))
  have h174 := congrArg (fun t => x * t) (lin_jordan_apply y (x * x) (x * y) z)
  have h175 := congrArg (fun t => x * t) (lin_jordan_apply y (x * x) (x * z) y)
  have h176 := congrArg (fun t => y * t) (lin_jordan_apply x x x (z * (x * y)))
  have h177 := congrArg (fun t => y * t) (lin_jordan_apply x x x (x * (y * z)))
  have h178 := congrArg (fun t => y * t) (lin_jordan_apply x x y (z * (x * x)))
  have h179 := congrArg (fun t => y * t) (lin_jordan_apply x x z (x * (x * y)))
  have h180 := congrArg (fun t => y * t) (lin_jordan_apply x x z (y * (x * x)))
  have h181 := congrArg (fun t => y * t) (lin_jordan_apply x x (x * z) (x * y))
  have h182 := congrArg (fun t => y * t) (lin_jordan_apply x x (y * z) (x * x))
  have h183 := congrArg (fun t => y * t) (lin_jordan_apply x y z (x * (x * x)))
  have h184 := congrArg (fun t => y * t) (lin_jordan_apply x y (x * z) (x * x))
  have h185 := congrArg (fun t => y * t) (lin_jordan_apply x z (x * y) (x * x))
  have h186 := congrArg (fun t => z * t) (lin_jordan_apply x x x (x * (y * y)))
  have h187 := congrArg (fun t => z * t) (lin_jordan_apply x x x (y * (x * y)))
  have h188 := congrArg (fun t => z * t) (lin_jordan_apply x x y (x * (x * y)))
  have h189 := congrArg (fun t => z * t) (lin_jordan_apply x x y (y * (x * x)))
  have h190 := congrArg (fun t => z * t) (lin_jordan_apply x x (x * y) (x * y))
  have h191 := congrArg (fun t => z * t) (lin_jordan_apply x y y (x * (x * x)))
  have h192 := congrArg (fun t => z * t) (lin_jordan_apply x y (x * y) (x * x))
  have h193 := congrArg (fun t => (x * x) * t) (lin_jordan_apply x x y (y * z))
  have h194 := congrArg (fun t => (x * x) * t) (lin_jordan_apply x x z (y * y))
  have h195 := congrArg (fun t => (x * x) * t) (lin_jordan_apply x y y (x * z))
  have h196 := congrArg (fun t => (x * x) * t) (lin_jordan_apply x y z (x * y))
  have h197 := congrArg (fun t => (x * y) * t) (lin_jordan_apply x x y (x * z))
  have h198 := congrArg (fun t => (x * z) * t) (lin_jordan_apply x x x (y * y))
  have h199 := congrArg (fun t => x * (x * t)) (lin_jordan_apply x x z (y * y))
  have h200 := congrArg (fun t => x * (x * t)) (lin_jordan_apply x x (y * y) z)
  have h201 := congrArg (fun t => x * (x * t)) (lin_jordan_apply x y y (x * z))
  have h202 := congrArg (fun t => x * (x * t)) (lin_jordan_apply x y (x * y) z)
  have h203 := congrArg (fun t => x * (x * t)) (lin_jordan_apply x y (x * z) y)
  have h204 := congrArg (fun t => x * (y * t)) (lin_jordan_apply x x y (x * z))
  have h205 := congrArg (fun t => x * (y * t)) (lin_jordan_apply x x z (x * y))
  have h206 := congrArg (fun t => x * (y * t)) (lin_jordan_apply x y z (x * x))
  have h207 := congrArg (fun t => y * (x * t)) (lin_jordan_apply x x (x * y) z)
  have h208 := congrArg (fun t => x * (x * (y * t))) (lin_jordan_apply x x y z)
  simp only [mul_sub, mul_add, mul_zero] at h152 h153 h154 h155 h156 h157 h158 h159 h160 h161 h162 h163 h164 h165 h166 h167 h168 h169 h170 h171 h172 h173 h174 h175 h176 h177 h178 h179 h180 h181 h182 h183 h184 h185 h186 h187 h188 h189 h190 h191 h192 h193 h194 h195 h196 h197 h198 h199 h200 h201 h202 h203 h204 h205 h206 h207 h208
  simp only [quadJ_apply, mul_sub, sub_mul, mul_smul_comm', smul_mul_assoc]
  simp only [mul_comm (x * (x * y)) z,
    mul_comm (x * x) y,
    mul_comm (y * (x * x)) z,
    mul_comm ((x * (x * y)) * (x * (x * y))) z,
    mul_comm ((x * (x * y)) * (y * (x * x))) z,
    mul_comm (y * (x * x)) (x * (x * y)),
    mul_comm ((y * (x * x)) * (y * (x * x))) z,
    mul_comm (x * x) z,
    mul_comm (y * y) (x * (x * z)),
    mul_comm (x * (y * y)) (x * (x * z)),
    mul_comm (x * (y * y)) (x * (x * (x * z))),
    mul_comm (y * z) (x * (x * y)),
    mul_comm (x * (y * z)) (x * (x * y)),
    mul_comm (x * (y * z)) (x * (x * (x * y))),
    mul_comm (y * (x * x)) (y * z),
    mul_comm (x * (y * (x * x))) (x * (y * z)),
    mul_comm (z * (x * x)) (y * y),
    mul_comm (x * (z * (x * x))) (x * (y * y)),
    mul_comm (x * (y * y)) (x * z),
    mul_comm (x * (x * (y * y))) (x * z),
    mul_comm (x * (x * (y * y))) (x * (x * z)),
    mul_comm (y * (x * y)) (x * z),
    mul_comm (x * (y * (x * y))) (x * z),
    mul_comm (x * (y * (x * y))) (x * (x * z)),
    mul_comm (z * (x * y)) (x * y),
    mul_comm (x * (z * (x * y))) (x * y),
    mul_comm (x * (z * (x * y))) (x * (x * y)),
    mul_comm (y * (x * z)) (x * y),
    mul_comm (x * (y * (x * z))) (x * y),
    mul_comm (x * (y * (x * z))) (x * (x * y)),
    mul_comm (x * (y * z)) (x * y),
    mul_comm (x * (x * (y * z))) (x * y),
    mul_comm (x * (x * (y * z))) (x * (x * y)),
    mul_comm (y * (y * z)) (x * x),
    mul_comm (x * (y * (y * z))) (x * x),
    mul_comm (x * (y * (y * z))) (x * (x * x)),
    mul_comm (z * (y * y)) (x * x),
    mul_comm (x * (z * (y * y))) (x * x),
    mul_comm (x * (z * (y * y))) (x * (x * x)),
    mul_comm ((x * y) * (x * z)) (y * (x * x)),
    mul_comm ((x * y) * (x * z)) y,
    mul_comm (x * ((x * y) * (x * z))) y,
    mul_comm (x * ((x * y) * (x * z))) (x * y),
    mul_comm ((x * x) * (y * z)) (y * (x * x)),
    mul_comm ((x * x) * (y * z)) y,
    mul_comm (x * ((x * x) * (y * z))) y,
    mul_comm (x * ((x * x) * (y * z))) (x * y),
    mul_comm (x * x) x,
    mul_comm (y * (y * (x * z))) (x * (x * x)),
    mul_comm (y * (y * (x * z))) x,
    mul_comm (x * (y * (y * (x * z)))) x,
    mul_comm (x * (y * (y * (x * z)))) (x * x),
    mul_comm (z * (y * (x * y))) (x * (x * x)),
    mul_comm (z * (y * (x * y))) x,
    mul_comm (x * (z * (y * (x * y)))) x,
    mul_comm (x * (z * (y * (x * y)))) (x * x),
    mul_comm (z * (x * (y * y))) (x * (x * x)),
    mul_comm (z * (x * (y * y))) x,
    mul_comm (x * (z * (x * (y * y)))) x,
    mul_comm (x * (z * (x * (y * y)))) (x * x),
    mul_comm (y * y) (x * ((x * x) * (x * z))),
    mul_comm (y * y) (x * (z * (x * x))),
    mul_comm (y * y) (x * (x * (z * (x * x)))),
    mul_comm (y * y) (x * (z * (x * (x * x)))),
    mul_comm (y * y) (x * (x * (x * z))),
    mul_comm (y * y) (x * (x * (x * (x * z)))),
    mul_comm (y * z) (x * (y * (x * (x * x)))),
    mul_comm (y * z) (x * (x * (x * y))),
    mul_comm (y * z) (x * (x * (x * (x * y)))),
    mul_comm (y * z) (x * (y * (x * x))),
    mul_comm (y * z) (x * (x * (y * (x * x)))),
    mul_comm (y * (x * x)) (x * (z * (x * y))),
    mul_comm (y * (x * x)) (x * (y * z)),
    mul_comm (y * (x * x)) (x * (x * (y * z))),
    mul_comm (y * (x * y)) (x * (z * (x * x))),
    mul_comm (y * (x * z)) (x * (x * y)),
    mul_comm (y * (x * z)) (x * (x * (x * y))),
    mul_comm (x * (x * z)) (x * (x * y)),
    mul_comm (y * (x * z)) (y * (x * x)),
    mul_comm (y * (x * z)) (x * (y * (x * x))),
    mul_comm (y * z) (x * (x * x)),
    mul_comm (y * (y * z)) (x * (x * x)),
    mul_comm (y * (y * z)) (x * (x * (x * x))),
    mul_comm (x * (y * z)) (x * (x * x)),
    mul_comm (x * (x * y)) (x * z),
    mul_comm (y * (x * (x * y))) (x * z),
    mul_comm (y * (x * (x * y))) (x * (x * z)),
    mul_comm (x * (x * (x * y))) (x * z),
    mul_comm (y * (x * x)) (x * z),
    mul_comm (y * (y * (x * x))) (x * z),
    mul_comm (y * (y * (x * x))) (x * (x * z)),
    mul_comm (x * (y * (x * x))) (x * z),
    mul_comm (z * (x * x)) (x * y),
    mul_comm (y * (z * (x * x))) (x * y),
    mul_comm (y * (z * (x * x))) (x * (x * y)),
    mul_comm (x * (z * (x * x))) (x * y),
    mul_comm (x * (x * z)) (x * y),
    mul_comm (y * (x * (x * z))) (x * y),
    mul_comm (y * (x * (x * z))) (x * (x * y)),
    mul_comm (x * (x * (x * z))) (x * y),
    mul_comm (x * y) (x * x),
    mul_comm (z * (x * y)) (x * x),
    mul_comm (y * (z * (x * y))) (x * x),
    mul_comm (y * (z * (x * y))) (x * (x * x)),
    mul_comm (x * (z * (x * y))) (x * x),
    mul_comm (y * (x * z)) (x * x),
    mul_comm (y * (y * (x * z))) (x * x),
    mul_comm (x * (y * (x * z))) (x * x),
    mul_comm (x * y) x,
    mul_comm (z * (x * (x * y))) (x * (x * y)),
    mul_comm (z * (x * (x * y))) x,
    mul_comm (y * (z * (x * (x * y)))) x,
    mul_comm (y * (z * (x * (x * y)))) (x * x),
    mul_comm (x * (z * (x * (x * y)))) x,
    mul_comm y x,
    mul_comm (x * (z * (x * (x * y)))) (x * y),
    mul_comm (z * (x * x)) (x * (y * y)),
    mul_comm (z * (x * x)) (x * (x * (y * y))),
    mul_comm (z * (x * x)) (y * (x * y)),
    mul_comm (z * (x * x)) (x * (y * (x * y))),
    mul_comm (z * (x * y)) (x * (x * y)),
    mul_comm (z * (x * y)) (x * (x * (x * y))),
    mul_comm (z * (x * y)) (y * (x * x)),
    mul_comm (z * (x * y)) (x * (y * (x * x))),
    mul_comm (y * y) (x * (x * x)),
    mul_comm (z * (y * y)) (x * (x * x)),
    mul_comm (z * (y * y)) (x * (x * (x * x))),
    mul_comm (x * (y * y)) (x * (x * x)),
    mul_comm ((x * x) * (x * z)) (y * y),
    mul_comm ((x * x) * (x * z)) (x * (y * y)),
    mul_comm (x * (x * x)) (x * z),
    mul_comm (y * y) (x * z),
    mul_comm ((x * x) * (y * y)) (x * z),
    mul_comm ((x * x) * (y * y)) (x * (x * z)),
    mul_comm (x * (x * x)) z,
    mul_comm (x * (y * y)) z,
    mul_comm ((x * x) * (x * (y * y))) z,
    mul_comm ((x * x) * (x * (y * y))) (x * z),
    mul_comm (x * (x * (y * y))) z,
    mul_comm (y * (x * y)) z,
    mul_comm ((x * x) * (y * (x * y))) z,
    mul_comm ((x * x) * (y * (x * y))) (x * z),
    mul_comm (x * (y * (x * y))) z,
    mul_comm (x * (x * x)) y,
    mul_comm (z * (x * y)) (y * (x * (x * x))),
    mul_comm (z * (x * y)) y,
    mul_comm ((x * x) * (z * (x * y))) y,
    mul_comm ((x * x) * (z * (x * y))) (x * y),
    mul_comm (x * (z * (x * y))) y,
    mul_comm (y * (x * z)) y,
    mul_comm ((x * x) * (y * (x * z))) y,
    mul_comm ((x * x) * (y * (x * z))) (x * y),
    mul_comm (x * (y * (x * z))) y,
    mul_comm (x * (y * z)) y,
    mul_comm ((x * x) * (x * (y * z))) y,
    mul_comm ((x * x) * (x * (y * z))) (x * y),
    mul_comm (x * (x * (y * z))) y,
    mul_comm (x * (x * x)) x,
    mul_comm (y * (y * z)) x,
    mul_comm ((x * x) * (y * (y * z))) x,
    mul_comm ((x * x) * (y * (y * z))) (x * x),
    mul_comm (x * (y * (y * z))) x,
    mul_comm (z * (y * y)) x,
    mul_comm ((x * x) * (z * (y * y))) x,
    mul_comm ((x * x) * (z * (y * y))) (x * x),
    mul_comm (x * (z * (y * y))) x,
    mul_comm ((x * y) * (x * y)) (x * z),
    mul_comm ((x * y) * (x * y)) (x * (x * z)),
    mul_comm (x * (x * y)) (x * y),
    mul_comm (x * z) (x * y),
    mul_comm ((x * y) * (x * z)) (x * y),
    mul_comm ((x * y) * (x * z)) (x * (x * y)),
    mul_comm (x * (x * y)) (x * x),
    mul_comm (y * z) (x * x),
    mul_comm ((x * y) * (y * z)) (x * x),
    mul_comm ((x * y) * (y * z)) (x * (x * x)),
    mul_comm (x * (y * z)) (x * x),
    mul_comm ((x * y) * (x * (x * y))) z,
    mul_comm ((x * y) * (x * (x * y))) (x * z),
    mul_comm (x * (x * (x * y))) z,
    mul_comm (x * y) z,
    mul_comm ((x * y) * (y * (x * x))) z,
    mul_comm ((x * y) * (y * (x * x))) (x * z),
    mul_comm (x * (y * (x * x))) z,
    mul_comm (x * (x * y)) y,
    mul_comm (z * (x * x)) (y * (x * (x * y))),
    mul_comm (z * (x * x)) y,
    mul_comm ((x * y) * (z * (x * x))) y,
    mul_comm ((x * y) * (z * (x * x))) (x * y),
    mul_comm (x * (z * (x * x))) y,
    mul_comm (x * y) y,
    mul_comm (x * (x * z)) y,
    mul_comm ((x * y) * (x * (x * z))) y,
    mul_comm ((x * y) * (x * (x * z))) (x * y),
    mul_comm (x * (x * (x * z))) y,
    mul_comm (x * (x * y)) x,
    mul_comm (z * (x * y)) x,
    mul_comm ((x * y) * (z * (x * y))) x,
    mul_comm ((x * y) * (z * (x * y))) (x * x),
    mul_comm (x * (z * (x * y))) x,
    mul_comm (y * (x * z)) x,
    mul_comm ((x * y) * (y * (x * z))) x,
    mul_comm ((x * y) * (y * (x * z))) (x * x),
    mul_comm (x * (y * (x * z))) x,
    mul_comm (x * (y * z)) x,
    mul_comm ((x * y) * (x * (y * z))) x,
    mul_comm ((x * y) * (x * (y * z))) (x * x),
    mul_comm (x * (x * (y * z))) x,
    mul_comm (x * (x * z)) (x * x),
    mul_comm (y * y) (x * x),
    mul_comm ((x * z) * (y * y)) (x * x),
    mul_comm ((x * z) * (y * y)) (x * (x * x)),
    mul_comm (x * (y * y)) (x * x),
    mul_comm (x * z) (x * x),
    mul_comm ((x * z) * (x * (x * y))) y,
    mul_comm ((x * z) * (x * (x * y))) (x * y),
    mul_comm (x * (x * (x * y))) y,
    mul_comm (x * z) y,
    mul_comm (y * (x * x)) y,
    mul_comm ((x * z) * (y * (x * x))) y,
    mul_comm ((x * z) * (y * (x * x))) (x * y),
    mul_comm (x * (y * (x * x))) y,
    mul_comm (x * (x * z)) x,
    mul_comm (x * (y * y)) x,
    mul_comm ((x * z) * (x * (y * y))) x,
    mul_comm ((x * z) * (x * (y * y))) (x * x),
    mul_comm (x * (x * (y * y))) x,
    mul_comm (x * z) x,
    mul_comm (y * (x * y)) (x * (x * (x * z))),
    mul_comm (y * (x * y)) x,
    mul_comm ((x * z) * (y * (x * y))) x,
    mul_comm ((x * z) * (y * (x * y))) (x * x),
    mul_comm (x * (y * (x * y))) x,
    mul_comm ((x * (x * x)) * (y * y)) z,
    mul_comm ((x * (x * x)) * (y * y)) (x * z),
    mul_comm (x * (x * (x * x))) z,
    mul_comm (y * y) z,
    mul_comm (z * (x * x)) x,
    mul_comm ((y * y) * (z * (x * x))) x,
    mul_comm ((y * y) * (z * (x * x))) (x * x),
    mul_comm (x * (z * (x * x))) x,
    mul_comm (y * y) x,
    mul_comm ((x * (x * z)) * (y * y)) x,
    mul_comm ((x * (x * z)) * (y * y)) (x * x),
    mul_comm (x * (x * (x * z))) x,
    mul_comm ((x * (x * x)) * (y * z)) y,
    mul_comm ((x * (x * x)) * (y * z)) (x * y),
    mul_comm (x * (x * (x * x))) y,
    mul_comm (y * z) y,
    mul_comm ((x * (x * y)) * (y * z)) x,
    mul_comm ((x * (x * y)) * (y * z)) (x * x),
    mul_comm (x * (x * (x * y))) x,
    mul_comm (y * z) x,
    mul_comm (y * (x * x)) x,
    mul_comm ((y * z) * (y * (x * x))) x,
    mul_comm ((y * z) * (y * (x * x))) (x * x),
    mul_comm (x * (y * (x * x))) x,
    mul_comm (y * y) (x * (x * (x * x))),
    mul_comm (y * z) (x * (x * (x * x))),
    mul_comm (y * (x * x)) (x * (x * z)),
    mul_comm (y * (x * z)) (x * (x * x)),
    mul_comm (y * (x * (x * x))) (x * z),
    mul_comm (y * (x * (x * x))) (y * (x * z)),
    mul_comm (y * (x * (x * z))) (x * x),
    mul_comm (y * (x * (x * z))) (y * (x * x)),
    mul_comm (z * (x * x)) (x * (x * y)),
    mul_comm (z * (x * x)) (y * (x * x)),
    mul_comm (z * (x * x)) (y * (y * (x * x))),
    mul_comm (z * (x * y)) (x * (x * x)),
    mul_comm (y * (x * y)) (x * (x * x)),
    mul_comm (y * z) (x * y),
    mul_comm (x * (x * x)) (x * y),
    mul_comm (z * (x * (x * x))) (x * y),
    mul_comm (z * (x * (x * x))) (y * (x * y)),
    mul_comm (y * (x * (x * x))) (x * y),
    mul_comm (z * (x * (x * y))) (x * x),
    mul_comm (z * (x * (x * y))) (y * (x * x)),
    mul_comm (y * (x * (x * y))) (x * x),
    mul_comm ((x * x) * (x * y)) (x * z),
    mul_comm ((x * x) * (x * y)) (y * (x * z)),
    mul_comm (y * (x * x)) (x * y),
    mul_comm ((x * x) * (x * z)) (x * y),
    mul_comm ((x * x) * (x * z)) (y * (x * y)),
    mul_comm (y * (x * x)) (x * x),
    mul_comm ((x * x) * (y * z)) (x * x),
    mul_comm ((x * x) * (x * (x * y))) z,
    mul_comm ((x * x) * (x * (x * y))) (y * z),
    mul_comm (y * (x * (x * y))) z,
    mul_comm ((x * x) * (y * (x * x))) z,
    mul_comm ((x * x) * (y * (x * x))) (y * z),
    mul_comm (y * (y * (x * x))) z,
    mul_comm ((x * x) * (z * (x * x))) y,
    mul_comm ((x * x) * (z * (x * x))) (y * y),
    mul_comm (y * (z * (x * x))) y,
    mul_comm (y * (z * (x * x))) (y * (x * x)),
    mul_comm ((x * x) * (x * (x * z))) y,
    mul_comm ((x * x) * (x * (x * z))) (y * y),
    mul_comm (y * (x * (x * z))) y,
    mul_comm ((x * x) * (z * (x * y))) x,
    mul_comm (y * (z * (x * y))) x,
    mul_comm (y * (x * x)) (x * (y * (x * z))),
    mul_comm ((x * x) * (y * (x * z))) x,
    mul_comm ((x * x) * (x * (y * z))) x,
    mul_comm (y * (x * (y * z))) x,
    mul_comm (y * (x * (y * z))) (x * (x * x)),
    mul_comm (y * (x * y)) (x * x),
    mul_comm ((x * y) * (x * z)) (x * x),
    mul_comm ((x * y) * (x * (x * x))) z,
    mul_comm ((x * y) * (x * (x * x))) (y * z),
    mul_comm (y * (x * (x * x))) z,
    mul_comm ((x * y) * (z * (x * x))) x,
    mul_comm (y * (z * (x * x))) x,
    mul_comm ((x * y) * (x * (x * z))) x,
    mul_comm (y * (x * (x * z))) x,
    mul_comm ((x * z) * (x * (x * x))) y,
    mul_comm ((x * z) * (x * (x * x))) (y * y),
    mul_comm (y * (x * (x * x))) y,
    mul_comm ((x * z) * (x * (x * y))) x,
    mul_comm (y * (x * (x * y))) x,
    mul_comm ((x * z) * (y * (x * x))) x,
    mul_comm (y * (y * (x * x))) x,
    mul_comm ((x * (x * x)) * (y * z)) x,
    mul_comm (y * (x * (x * x))) x,
    mul_comm (y * (x * (x * x))) (x * (y * z)),
    mul_comm ((x * x) * (x * x)) (y * y),
    mul_comm ((x * x) * (x * x)) (z * (y * y)),
    mul_comm ((x * x) * (x * y)) (x * y),
    mul_comm ((x * x) * (x * y)) (z * (x * y)),
    mul_comm (z * (x * x)) (x * x),
    mul_comm ((x * x) * (y * y)) (x * x),
    mul_comm ((x * x) * (y * y)) (z * (x * x)),
    mul_comm ((x * x) * (x * (x * y))) y,
    mul_comm z y,
    mul_comm (z * (x * (x * y))) y,
    mul_comm ((x * x) * (y * (x * x))) y,
    mul_comm (z * (y * (x * x))) y,
    mul_comm (z * (y * (x * x))) (y * (x * x)),
    mul_comm ((x * x) * (x * (y * y))) x,
    mul_comm z x,
    mul_comm ((x * x) * (y * (x * y))) x,
    mul_comm ((x * y) * (x * y)) (x * x),
    mul_comm ((x * y) * (x * y)) (z * (x * x)),
    mul_comm ((x * y) * (x * (x * x))) y,
    mul_comm (z * (x * (x * x))) y,
    mul_comm ((x * y) * (x * (x * y))) x,
    mul_comm ((x * y) * (y * (x * x))) x,
    mul_comm (z * (y * (x * x))) x,
    mul_comm (z * (y * (x * x))) (x * (x * y)),
    mul_comm ((x * (x * x)) * (y * y)) x,
    mul_comm (z * (x * (x * x))) x,
    mul_comm (z * (x * (x * x))) (x * (y * y)),
    mul_comm ((x * x) * (x * x)) z,
    mul_comm ((x * x) * (y * y)) z,
    mul_comm ((x * x) * (x * x)) y,
    mul_comm ((x * x) * (x * x)) (y * (y * z)),
    mul_comm ((x * x) * (x * z)) x,
    mul_comm ((x * z) * (y * y)) x,
    mul_comm ((x * x) * (y * y)) x,
    mul_comm ((x * y) * (x * y)) x,
    mul_comm ((x * y) * (x * z)) x,
    mul_comm ((x * x) * (y * z)) (x * y),
    mul_comm ((x * x) * (x * y)) z,
    mul_comm ((x * x) * (x * y)) (y * z),
    mul_comm ((x * x) * (x * z)) y]
    at h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 h13 h14 h15 h16 h17 h18 h19 h20 h21 h22 h23 h24 h25 h26 h27 h28 h29 h30 h31 h32 h33 h34 h35 h36 h37 h38 h39 h40 h41 h42 h43 h44 h45 h46 h47 h48 h49 h50 h51 h52 h53 h54 h55 h56 h57 h58 h59 h60 h61 h62 h63 h64 h65 h66 h67 h68 h69 h70 h71 h72 h73 h74 h75 h76 h77 h78 h79 h80 h81 h82 h83 h84 h85 h86 h87 h88 h89 h90 h91 h92 h93 h94 h95 h96 h97 h98 h99 h100 h101 h102 h103 h104 h105 h106 h107 h108 h109 h110 h111 h112 h113 h114 h115 h116 h117 h118 h119 h120 h121 h122 h123 h124 h125 h126 h127 h128 h129 h130 h131 h132 h133 h134 h135 h136 h137 h138 h139 h140 h141 h142 h143 h144 h145 h146 h147 h148 h149 h150 h151 h152 h153 h154 h155 h156 h157 h158 h159 h160 h161 h162 h163 h164 h165 h166 h167 h168 h169 h170 h171 h172 h173 h174 h175 h176 h177 h178 h179 h180 h181 h182 h183 h184 h185 h186 h187 h188 h189 h190 h191 h192 h193 h194 h195 h196 h197 h198 h199 h200 h201 h202 h203 h204 h205 h206 h207 h208 ⊢
  linear_combination (norm := module) - ((2 : ℝ) / 3) • h1 + (2 : ℝ) • h2 - ((10 : ℝ) / 3) • h3 -
    h4 - (2 : ℝ) • h5 - h6 + (4 : ℝ) • h7 - ((2 : ℝ) / 3) • h8 - ((2 : ℝ) / 3) • h9 - (2 : ℝ) • h10
    - (2 : ℝ) • h11 - (2 : ℝ) • h12 - h13 - (2 : ℝ) • h14 - (2 : ℝ) • h15 - (2 : ℝ) • h16 - (2 : ℝ)
    • h17 + h18 - (2 : ℝ) • h19 - (3 : ℝ) • h20 + (4 : ℝ) • h21 + h22 - (6 : ℝ) • h23 + h24 - h25 +
    ((7 : ℝ) / 2) • h26 + (14 : ℝ) • h27 - (4 : ℝ) • h28 - (2 : ℝ) • h29 + (3 : ℝ) • h30 - (2 : ℝ) •
    h31 + ((1 : ℝ) / 2) • h32 - (2 : ℝ) • h33 + (2 : ℝ) • h34 - (5 : ℝ) • h35 + (2 : ℝ) • h36 - (2 :
    ℝ) • h37 + h38 + (2 : ℝ) • h39 + (4 : ℝ) • h40 - (4 : ℝ) • h41 + (2 : ℝ) • h42 + (4 : ℝ) • h43 +
    (2 : ℝ) • h44 - h45 + (8 : ℝ) • h46 + (2 : ℝ) • h47 + (4 : ℝ) • h48 + (4 : ℝ) • h49 + (2 : ℝ) •
    h50 - h51 + (3 : ℝ) • h52 - h53 - (2 : ℝ) • h54 - (2 : ℝ) • h55 - (4 : ℝ) • h56 + (2 : ℝ) • h57
    + (6 : ℝ) • h58 + (6 : ℝ) • h59 + (2 : ℝ) • h60 + (4 : ℝ) • h61 + (2 : ℝ) • h62 - (2 : ℝ) • h63
    + (8 : ℝ) • h64 - (4 : ℝ) • h65 - (4 : ℝ) • h66 + (4 : ℝ) • h67 - (4 : ℝ) • h68 + (2 : ℝ) • h69
    + (8 : ℝ) • h70 + (3 : ℝ) • h71 - (2 : ℝ) • h72 - (12 : ℝ) • h73 - (2 : ℝ) • h74 - (3 : ℝ) • h75
    - (2 : ℝ) • h76 + (2 : ℝ) • h77 - (3 : ℝ) • h78 - (2 : ℝ) • h79 - (2 : ℝ) • h80 - (2 : ℝ) • h81
    - (2 : ℝ) • h82 - (2 : ℝ) • h83 - (3 : ℝ) • h84 + (4 : ℝ) • h85 - (8 : ℝ) • h86 + (4 : ℝ) • h87
    - (4 : ℝ) • h88 + (2 : ℝ) • h89 + (6 : ℝ) • h90 - (4 : ℝ) • h91 - (4 : ℝ) • h92 - (4 : ℝ) • h93
    - (4 : ℝ) • h94 + (3 : ℝ) • h95 - (4 : ℝ) • h96 + (2 : ℝ) • h97 - (6 : ℝ) • h98 - (4 : ℝ) • h99
    + h100 + (3 : ℝ) • h101 - (2 : ℝ) • h102 + (2 : ℝ) • h103 - (4 : ℝ) • h104 + (2 : ℝ) • h105 +
    h106 - h107 + ((1 : ℝ) / 2) • h108 - (2 : ℝ) • h109 - h110 + (2 : ℝ) • h111 + h112 + (2 : ℝ) •
    h113 - h114 - (2 : ℝ) • h115 + (4 : ℝ) • h116 + (4 : ℝ) • h117 + (4 : ℝ) • h118 - (4 : ℝ) • h119
    + (4 : ℝ) • h120 - (6 : ℝ) • h121 + h122 - h123 + (2 : ℝ) • h124 - (2 : ℝ) • h125 + (2 : ℝ) •
    h126 - (2 : ℝ) • h127 + (4 : ℝ) • h128 - (2 : ℝ) • h129 + (2 : ℝ) • h130 - (4 : ℝ) • h131 - (2 :
    ℝ) • h132 - (12 : ℝ) • h133 + (2 : ℝ) • h134 - (2 : ℝ) • h135 + h136 + (4 : ℝ) • h137 - h138 +
    (6 : ℝ) • h139 - h140 + (3 : ℝ) • h141 + (6 : ℝ) • h142 - (8 : ℝ) • h143 - (2 : ℝ) • h144 + (12
    : ℝ) • h145 - (2 : ℝ) • h146 - h147 - h148 - (2 : ℝ) • h149 - h150 + (8 : ℝ) • h151 + ((2 : ℝ) /
    3) • h152 - ((5 : ℝ) / 3) • h153 - (2 : ℝ) • h154 + (2 : ℝ) • h155 - h156 + (2 : ℝ) • h157 +
    h158 - (4 : ℝ) • h159 - h160 - (4 : ℝ) • h161 + (6 : ℝ) • h162 - (8 : ℝ) • h163 - (4 : ℝ) • h164
    - (2 : ℝ) • h165 + (8 : ℝ) • h166 + (4 : ℝ) • h167 + (2 : ℝ) • h168 + (4 : ℝ) • h169 + h170 - (6
    : ℝ) • h171 - h172 - (8 : ℝ) • h173 + (8 : ℝ) • h174 + (8 : ℝ) • h175 - (2 : ℝ) • h176 - ((2 :
    ℝ) / 3) • h177 + h178 + (2 : ℝ) • h179 - h180 + (2 : ℝ) • h181 + (2 : ℝ) • h182 + (2 : ℝ) • h183
    - (2 : ℝ) • h184 + (4 : ℝ) • h185 - h186 - ((2 : ℝ) / 3) • h187 - (2 : ℝ) • h188 + h189 - (4 :
    ℝ) • h190 + h191 - (4 : ℝ) • h192 + (4 : ℝ) • h193 + (3 : ℝ) • h194 + h195 + (4 : ℝ) • h196 - (2
    : ℝ) • h197 + h198 - (2 : ℝ) • h199 - (2 : ℝ) • h200 + (4 : ℝ) • h201 - (8 : ℝ) • h202 - (8 : ℝ)
    • h203 - (4 : ℝ) • h204 - (4 : ℝ) • h205 - (4 : ℝ) • h206 - (4 : ℝ) • h207 + (4 : ℝ) • h208


/-! ## Corollaries of the fundamental formula

The first consequence, and the one a sequential product needs: `Q` squares the way its subscript
does.  It is the fundamental formula read at `y = 1`, where `Q_1` is the identity
(`quadJ_unit_left`) and `Q_x 1 = x²` (`quadJ_unit`). -/

/-- **`Q_{x²} = Q_x ∘ Q_x`.**  The fundamental formula at `y = 1`.

★ This is what ties `Q_{√a}` to `Q_a`: taking `x := √a` and using `√a · √a = a` gives
`Q_a = Q_{√a} ∘ Q_{√a}`, which is the identity every step of S5–S7 for the Lüders product
`a · b = Q_{√a} b` runs on.  Before the fundamental formula there was no route to it. -/
theorem quadJ_sq {e : J} (he : ∀ y : J, e * y = y) (x z : J) :
    quadJ (x * x) z = quadJ x (quadJ x z) := by
  have hff := quadJ_quadJ_quadJ x e z
  rw [quadJ_unit he x] at hff
  rw [hff, quadJ_unit_left he]

/-- **`Q_a = Q_{√a} ∘ Q_{√a}`** for any `a` carrying a resolution with nonnegative eigenvalues.

The Lüders product is `a · b = Q_{√a} b`, so this says applying it twice with the same `a` is
`Q_a` — the first structural fact about iterating the product. -/
theorem quadJ_jsqrt_sq [IsFormallyReal J] [Module.Finite ℝ J] {e : J}
    (he : ∀ y : J, e * y = y) {a : J}
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hinj : Function.Injective lam) (ha : a = ∑ i, lam i • c i)
    (hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i) (z : J) :
    quadJ a z = quadJ (jsqrt e he a) (quadJ (jsqrt e he a) z) := by
  have hsq : jsqrt e he a * jsqrt e he a = a := jsqrt_mul_self' e he a hfam hinj ha hnn
  rw [← quadJ_sq he (jsqrt e he a) z, hsq]

end RadicalRelativity.EJA
