/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.FramePeirceMul

set_option linter.style.longLine false

/-!
# Connections between frame blocks

Placeholder docstring; rewritten at the end of the build.
-/

noncomputable section

namespace RadicalRelativity.EJA

open EuclideanJordanAlgebra

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J] [EuclideanJordanAlgebra J]
variable {n : ℕ}

/-! ## The linearised Jordan identity -/

/-- **The fully linearised Jordan identity, evaluated at a point.**

Mathlib's `two_nsmul_lie_lmul_lmul_add_add_eq_zero` states
`2 • (⁅L a, L (b∘c)⁆ + ⁅L b, L (c∘a)⁆ + ⁅L c, L (a∘b)⁆) = 0` in `AddMonoid.End J`; this is that
equation applied to `w`, with the `2 •` divided out (legitimate because `J` is a real vector
space). -/
theorem lin_jordan (a b c w : J) :
    (a * ((b * c) * w) - (b * c) * (a * w))
      + (b * ((c * a) * w) - (c * a) * (b * w))
      + (c * ((a * b) * w) - (a * b) * (c * w)) = 0 := by
  have H := two_nsmul_lie_lmul_lmul_add_add_eq_zero (A := J) a b c
  have H' := DFunLike.congr_fun H w
  simp only [Ring.lie_def, AddMonoid.End.mulLeft] at H'
  have h2 : (2 : ℕ) • ((a * (b * c * w) - b * c * (a * w)) + (b * (c * a * w) - c * a * (b * w)) +
      (c * (a * b * w) - a * b * (c * w))) = 0 := H'
  have h3 : ((2 : ℕ) : ℝ) • ((a * (b * c * w) - b * c * (a * w)) +
      (b * (c * a * w) - c * a * (b * w)) + (c * (a * b * w) - a * b * (c * w))) = 0 := by
    rw [Nat.cast_smul_eq_nsmul]; exact h2
  rcases smul_eq_zero.mp h3 with h | h
  · norm_num at h
  · exact h

/-! ## The frame in the inner product -/

/-- Distinct frame members are orthogonal in the inner product, not merely in the algebra:
`⟪pᵢ, pⱼ⟫ = ⟪pᵢ ∘ pⱼ, 1⟫ = 0` by `EJA/Class.lean`'s `inner_mul_one`. -/
theorem inner_p_p_of_ne (F : JordanFrame J n) {i j : Fin n} (hij : i ≠ j) :
    (inner ℝ (F.p i) (F.p j) : ℝ) = 0 := by
  rw [← inner_mul_one (F.p i) (F.p j), F.orthIdem.orth i j hij, inner_zero_left]

/-- `⟪pᵢ, pᵢ⟫ > 0` — the frame members are nonzero and the inner product is definite. -/
theorem inner_p_self_pos (F : JordanFrame J n) (i : Fin n) :
    0 < (inner ℝ (F.p i) (F.p i) : ℝ) :=
  real_inner_self_pos.mpr (F.p_ne_zero i)

/-- Pairing an element of `V_{ij}` against `pᵢ`: `⟪x ∘ x, pᵢ⟫ = ½‖x‖²`. -/
theorem inner_sq_p_of_mem (F : JordanFrame J n) {i j : Fin n} (hij : i ≠ j) {x : J}
    (hx : x ∈ frameBlockRaw F i j) :
    (inner ℝ (x * x) (F.p i) : ℝ) = (2 : ℝ)⁻¹ * (inner ℝ x x : ℝ) := by
  rw [inner_assoc x x (F.p i), _root_.mul_comm x (F.p i),
    frameBlockRaw_mul_left_half F hij hx, real_inner_smul_right]

/-! ## The square of an off-diagonal element

★ `EJA/FramePeirceMul.lean`'s `frameBlockRaw_mul_self_eq` gives `x ∘ x = a • pᵢ + b • pⱼ`.
This section proves `a = b`, so that the square is a multiple of the *idempotent* `pᵢ + pⱼ`
and the coefficient is a quadratic form.  The argument is power associativity, not the trace
form: `x⁴` computed as `x² ∘ x²` and as `x ∘ (x ∘ x²)` gives `a² = a(a+b)/2` and
`b² = b(a+b)/2`, whence `(a - b)² = 0`. -/

section Square

variable [FiniteDimensional ℝ J]

omit [FiniteDimensional ℝ J] in
/-- `x⁴ = x² ∘ x²` and `x⁴ = x ∘ (x ∘ x²)` agree — `EJA/PowerAssoc.lean`'s `jpow_mul_jpow` at
`(1, 1)`, unfolded. -/
theorem sq_mul_sq_eq (x : J) : (x * x) * (x * x) = x * (x * (x * x)) := by
  have h := jpow_mul_jpow x 1 1
  simpa using h

omit [FiniteDimensional ℝ J] in
/-- **The two coefficients of `x ∘ x` on `V_{ij}` are equal.** -/
theorem frameBlockRaw_sq_coeff_eq (F : JordanFrame J n) {i j : Fin n} (hij : i ≠ j) {x : J}
    (hx : x ∈ frameBlockRaw F i j) {a b : ℝ} (hab : x * x = a • F.p i + b • F.p j) :
    a = b := by
  have hxi : F.p i * x = (2 : ℝ)⁻¹ • x := frameBlockRaw_mul_left_half F hij hx
  have hxj : F.p j * x = (2 : ℝ)⁻¹ • x := frameBlockRaw_mul_right_half F hij hx
  -- `x ∘ (x ∘ x) = ((a + b)/2) • x`
  have hcube : x * (x * x) = ((a + b) / 2) • x := by
    rw [hab]
    simp only [mul_add, mul_smul_comm, _root_.mul_comm x (F.p i), _root_.mul_comm x (F.p j),
      hxi, hxj]
    module
  -- `x ∘ (x ∘ (x ∘ x)) = ((a + b)/2) • (a • pᵢ + b • pⱼ)`
  have hquart : x * (x * (x * x)) = ((a + b) / 2 * a) • F.p i + ((a + b) / 2 * b) • F.p j := by
    rw [hcube, mul_smul_comm, hab]
    module
  -- `(x ∘ x) ∘ (x ∘ x) = a² • pᵢ + b² • pⱼ`
  have hsqsq : (x * x) * (x * x) = (a * a) • F.p i + (b * b) • F.p j := by
    rw [hab]
    simp only [_root_.add_mul, mul_add, smul_mul, mul_smul_comm, F.orthIdem.idem i,
      F.orthIdem.idem j, F.orthIdem.orth i j hij, F.orthIdem.orth j i (Ne.symm hij)]
    module
  have hkey : (a * a) • F.p i + (b * b) • F.p j
      = ((a + b) / 2 * a) • F.p i + ((a + b) / 2 * b) • F.p j := by
    rw [← hsqsq, ← hquart]; exact sq_mul_sq_eq x
  have hτi : (0 : ℝ) < inner ℝ (F.p i) (F.p i) := inner_p_self_pos F i
  have hτj : (0 : ℝ) < inner ℝ (F.p j) (F.p j) := inner_p_self_pos F j
  have hij' : (inner ℝ (F.p i) (F.p j) : ℝ) = 0 := inner_p_p_of_ne F hij
  have hji' : (inner ℝ (F.p j) (F.p i) : ℝ) = 0 := inner_p_p_of_ne F (Ne.symm hij)
  have hA : a * a = (a + b) / 2 * a := by
    have := congrArg (fun z : J => (inner ℝ z (F.p i) : ℝ)) hkey
    simp only [inner_add_left, real_inner_smul_left, hji'] at this
    field_simp [hij', hji'] at this
    nlinarith [this, hτi]
  have hB : b * b = (a + b) / 2 * b := by
    have := congrArg (fun z : J => (inner ℝ z (F.p j) : ℝ)) hkey
    simp only [inner_add_left, real_inner_smul_left, hij'] at this
    field_simp [hij', hji'] at this
    nlinarith [this, hτj]
  have hsq : (a - b) ^ 2 = 0 := by nlinarith [hA, hB]
  have := pow_eq_zero_iff (n := 2) (by norm_num) |>.mp hsq
  linarith [this]

/-- **`x ∘ x = a • (pᵢ + pⱼ)` for `x ∈ V_{ij}`**, with `a ≥ 0` and `a = 0` only at `x = 0`.

The idempotent `pᵢ + pⱼ` is the unit of the Peirce subalgebra the block lives in, so this says
the square of a block element is a nonnegative multiple of that unit. -/
theorem exists_sq_smul (F : JordanFrame J n) {i j : Fin n} (hij : i ≠ j) {x : J}
    (hx : x ∈ frameBlockRaw F i j) :
    ∃ a : ℝ, x * x = a • (F.p i + F.p j)
      ∧ a * (inner ℝ (F.p i) (F.p i) : ℝ) = (2 : ℝ)⁻¹ * (inner ℝ x x : ℝ) := by
  obtain ⟨a, b, hab⟩ := frameBlockRaw_mul_self_eq F hij hx hx
  have hba : a = b := frameBlockRaw_sq_coeff_eq F hij hx hab
  subst hba
  refine ⟨a, by rw [hab]; module, ?_⟩
  have h := inner_sq_p_of_mem F hij hx
  rw [hab] at h
  simp only [inner_add_left, real_inner_smul_left, inner_p_p_of_ne F (Ne.symm hij)] at h
  linarith [h]

end Square

/-! ## The key operator identity -/

/-- **`x ∘ (x ∘ y) = (a/4) • y`** for `x ∈ V_{ij}`, `y ∈ V_{jk}` with `x ∘ x = a • (pᵢ + pⱼ)`.

This is the whole engine of coordinatization: it says `2 L_x` restricted to `V_{jk}` squares to
the scalar `a`, so a *normalised* `x` gives an involution `V_{jk} ≃ V_{ik}`, and it is what makes
the coordinate product multiplicative on norms.

The proof is `lin_jordan` at `(x, x, y)` evaluated at `pⱼ`.  Every term collapses:
`x ∘ y ∈ V_{ik}` is annihilated by `pⱼ`, `pⱼ` halves both `x` and `y`, and `x ∘ x` acts on `pⱼ`
as `a` and on `y` as `a/2`.  What survives is `-(x ∘ (x ∘ y)) + (a/4) • y = 0`.

★ The plain (unlinearised) Jordan identity gives **nothing** here: both of its sides reduce to
`½ a • (x ∘ y)` by the eigenvalue rules alone.  The linearisation is essential. -/
theorem block_sq_act (F : JordanFrame J n) {i j k : Fin n} (hij : i ≠ j) (hjk : j ≠ k)
    (hik : i ≠ k) {x y : J} (hx : x ∈ frameBlockRaw F i j) (hy : y ∈ frameBlockRaw F j k)
    {a : ℝ} (hxx : x * x = a • (F.p i + F.p j)) :
    x * (x * y) = (a / 4) • y := by
  have hxy : x * y ∈ frameBlockRaw F i k := frameBlockRaw_mul_middle F hij hjk hik hx hy
  have hpjxy : (x * y) * F.p j = 0 := by
    rw [_root_.mul_comm]
    exact frameBlockRaw_mul_eq_zero F (Ne.symm hij) hjk hxy
  have hpjx : x * F.p j = (2 : ℝ)⁻¹ • x := by
    rw [_root_.mul_comm]; exact frameBlockRaw_mul_right_half F hij hx
  have hpjy : y * F.p j = (2 : ℝ)⁻¹ • y := by
    rw [_root_.mul_comm]; exact frameBlockRaw_mul_left_half F hjk hy
  have hpiy : F.p i * y = 0 := frameBlockRaw_mul_eq_zero F hij hik hy
  have hxxpj : (x * x) * F.p j = a • F.p j := by
    rw [hxx]
    simp only [smul_mul, _root_.add_mul, F.orthIdem.idem j, F.orthIdem.orth i j hij]
    module
  have hxxy : (x * x) * y = (a / 2) • y := by
    rw [hxx]
    simp only [smul_mul, _root_.add_mul, hpiy, frameBlockRaw_mul_left_half F hjk hy]
    module
  have H := lin_jordan x x y (F.p j)
  rw [_root_.mul_comm y x, hpjxy, hpjx, hxxpj] at H
  simp only [mul_zero, mul_smul_comm, hpjy, hxxy, _root_.mul_comm (x * y) x] at H
  linear_combination (norm := module) -H

end RadicalRelativity.EJA
