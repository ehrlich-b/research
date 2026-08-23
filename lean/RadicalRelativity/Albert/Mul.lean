/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert.Carrier
import Mathlib.Tactic.Module

set_option linter.style.longLine false

/-!
# The Jordan product on `h₃(𝕆)`, as a bundled bilinear map

`a ∘ b = ½(ab + ba)`, written out for hermitian `3 × 3` octonionic matrices in the layout
fixed by `Albert/Carrier.lean`, and packaged as

```
jordanBilinO : h3O →ₗ[ℝ] h3O →ₗ[ℝ] h3O
```

## Why bundled

The bare function `jordanMul` is unusable by the interfaces this is being built for.  Both
`ComparisonSetup` and `EJA/Order.lean`'s `orderUnitSpaceOfBilinear` take the Jordan product as
a bilinear *map* `m : J →ₗ[ℝ] J →ₗ[ℝ] J` over `[NormedAddCommGroup J] [InnerProductSpace ℝ J]`,
deliberately: assuming `[NonUnitalNonAssocCommRing J]` and `[NormedAddCommGroup J]` together
would put two `AddCommGroup J` instances in play, which is the diamond `EJA/Bridge.lean` was
written to dodge.  So the product is bundled here and never installed as a `Mul` instance.

`hcomm` and `jordan_unit` are stated in exactly the shapes `orderUnitSpaceOfBilinear` consumes
(`hcomm : ∀ x y, m x y = m y x` and `he : ∀ y, m e y = y` at `e := 1`).

## What is NOT here

The **Jordan identity** `m (m a b) (m a a) = m a (m b (m a a))` and formal reality.  Both are
in `Albert/Jordan.lean` -- `jordanMul_jordan` and `eq_zero_of_sum_sq_eq_zero`, the latter in
the sum-of-squares form `orderUnitSpaceOfBilinear` takes -- and neither is proved by expanding
the identity in coordinates.  Nothing in this file, and nothing in `Albert/Inner.lean`, assumes
either of them.

## Main definitions

* `jordanMul` -- the product as a bare function, in coordinates
* `jordanBilinO` -- the same product as an `ℝ`-bilinear map

## Main results

* `jordanMul_comm` / `hcomm` -- commutativity
* `jordan_unit` -- `1` is a two-sided Jordan unit
-/

noncomputable section

namespace RadicalRelativity.Albert

open Octonion

namespace h3O

/-- The **Jordan product** `a ∘ b = ½(ab + ba)` on `h₃(𝕆)`, computed in the layout
`[[a₁, x₃*, x₂], [x₃, a₂, x₁*], [x₂*, x₁, a₃]]`.

Diagonal: `(a ∘ b)ₖₖ = aₖbₖ + ⟨offᵢ, offⱼ⟩` over the two indices `≠ k`.
Off-diagonal: `(a ∘ b)_k = ½(aᵢ+aⱼ)·q_k + ½(bᵢ+bⱼ)·p_k + ½(p̄ᵢq̄ⱼ + q̄ᵢp̄ⱼ)`, the octonionic
factors taken at the two indices `≠ k` in cyclic order. -/
def jordanMul (a b : h3O) : h3O :=
  ⟨fun k =>
    if k.val = 0 then
      a.diag 0 * b.diag 0 + octIp (a.off 1) (b.off 1) + octIp (a.off 2) (b.off 2)
    else if k.val = 1 then
      a.diag 1 * b.diag 1 + octIp (a.off 0) (b.off 0) + octIp (a.off 2) (b.off 2)
    else
      a.diag 2 * b.diag 2 + octIp (a.off 0) (b.off 0) + octIp (a.off 1) (b.off 1),
   fun k =>
    if k.val = 0 then
      ((a.diag 1 + a.diag 2) / 2) • b.off 0 + ((b.diag 1 + b.diag 2) / 2) • a.off 0
      + (1/2 : ℝ) • (mul (conj (a.off 1)) (conj (b.off 2))
                    + mul (conj (b.off 1)) (conj (a.off 2)))
    else if k.val = 1 then
      ((a.diag 0 + a.diag 2) / 2) • b.off 1 + ((b.diag 0 + b.diag 2) / 2) • a.off 1
      + (1/2 : ℝ) • (mul (conj (a.off 2)) (conj (b.off 0))
                    + mul (conj (b.off 2)) (conj (a.off 0)))
    else
      ((a.diag 0 + a.diag 1) / 2) • b.off 2 + ((b.diag 0 + b.diag 1) / 2) • a.off 2
      + (1/2 : ℝ) • (mul (conj (a.off 0)) (conj (b.off 1))
                    + mul (conj (b.off 0)) (conj (a.off 1)))⟩

@[simp] theorem jordanMul_diag_zero (a b : h3O) :
    (jordanMul a b).diag 0 =
      a.diag 0 * b.diag 0 + octIp (a.off 1) (b.off 1) + octIp (a.off 2) (b.off 2) := rfl

@[simp] theorem jordanMul_diag_one (a b : h3O) :
    (jordanMul a b).diag 1 =
      a.diag 1 * b.diag 1 + octIp (a.off 0) (b.off 0) + octIp (a.off 2) (b.off 2) := rfl

@[simp] theorem jordanMul_diag_two (a b : h3O) :
    (jordanMul a b).diag 2 =
      a.diag 2 * b.diag 2 + octIp (a.off 0) (b.off 0) + octIp (a.off 1) (b.off 1) := rfl

@[simp] theorem jordanMul_off_zero (a b : h3O) :
    (jordanMul a b).off 0 =
      ((a.diag 1 + a.diag 2) / 2) • b.off 0 + ((b.diag 1 + b.diag 2) / 2) • a.off 0
        + (1/2 : ℝ) • (mul (conj (a.off 1)) (conj (b.off 2))
                      + mul (conj (b.off 1)) (conj (a.off 2))) := rfl

@[simp] theorem jordanMul_off_one (a b : h3O) :
    (jordanMul a b).off 1 =
      ((a.diag 0 + a.diag 2) / 2) • b.off 1 + ((b.diag 0 + b.diag 2) / 2) • a.off 1
        + (1/2 : ℝ) • (mul (conj (a.off 2)) (conj (b.off 0))
                      + mul (conj (b.off 2)) (conj (a.off 0))) := rfl

@[simp] theorem jordanMul_off_two (a b : h3O) :
    (jordanMul a b).off 2 =
      ((a.diag 0 + a.diag 1) / 2) • b.off 2 + ((b.diag 0 + b.diag 1) / 2) • a.off 2
        + (1/2 : ℝ) • (mul (conj (a.off 0)) (conj (b.off 1))
                      + mul (conj (b.off 0)) (conj (a.off 1))) := rfl

/-! ## Commutativity, the unit, and bilinearity -/

theorem jordanMul_comm (a b : h3O) : jordanMul a b = jordanMul b a := by
  refine ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
      jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
      octIp_comm (b.off 0) (a.off 0), octIp_comm (b.off 1) (a.off 1),
      octIp_comm (b.off 2) (a.off 2)] <;>
    first
      | ring1
      | module

/-- `1 = diag(1,1,1)` is a Jordan unit.  Stated in the shape `orderUnitSpaceOfBilinear` takes
its `he` argument. -/
theorem jordanMul_one_left (a : h3O) : jordanMul 1 a = a := by
  refine ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
      jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
      one_diag, one_off, conj_zero, zero_mul', mul_zero', octIp_zero_left, smul_zero,
      add_zero] <;>
    first
      | ring1
      | module

theorem jordanMul_add_left (a a' b : h3O) :
    jordanMul (a + a') b = jordanMul a b + jordanMul a' b := by
  refine ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
      jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
      add_diag, add_off, conj_add, add_mul', mul_add', octIp_add_left] <;>
    first
      | ring1
      | module

theorem jordanMul_smul_left (r : ℝ) (a b : h3O) :
    jordanMul (r • a) b = r • jordanMul a b := by
  refine ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
      jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
      smul_diag, smul_off, conj_smul, smul_mul, mul_smul', octIp_smul_left] <;>
    first
      | ring1
      | module

theorem jordanMul_add_right (a b b' : h3O) :
    jordanMul a (b + b') = jordanMul a b + jordanMul a b' := by
  rw [jordanMul_comm, jordanMul_add_left, jordanMul_comm b a, jordanMul_comm b' a]

theorem jordanMul_smul_right (r : ℝ) (a b : h3O) :
    jordanMul a (r • b) = r • jordanMul a b := by
  rw [jordanMul_comm, jordanMul_smul_left, jordanMul_comm b a]

/-! ## The bundled bilinear map -/

/-- The Jordan product on `h₃(𝕆)` as an `ℝ`-bilinear map -- the vocabulary
`ComparisonSetup` and `EJA/Order.lean`'s `orderUnitSpaceOfBilinear` both require. -/
def jordanBilinO : h3O →ₗ[ℝ] h3O →ₗ[ℝ] h3O :=
  LinearMap.mk₂ ℝ jordanMul jordanMul_add_left jordanMul_smul_left
    jordanMul_add_right jordanMul_smul_right

@[simp] theorem jordanBilinO_apply (a b : h3O) : jordanBilinO a b = jordanMul a b := rfl

/-- Commutativity, in the shape `orderUnitSpaceOfBilinear` takes its `hcomm` argument. -/
theorem hcomm (x y : h3O) : jordanBilinO x y = jordanBilinO y x := jordanMul_comm x y

/-- The Jordan unit, in the shape `orderUnitSpaceOfBilinear` takes its `he` argument. -/
theorem jordan_unit (y : h3O) : jordanBilinO 1 y = y := jordanMul_one_left y

end h3O

end RadicalRelativity.Albert
