/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.SequentialProduct
import Mathlib.Algebra.Module.Pi

set_option linter.style.longLine false

/-!
# Concrete Instance: Diagonal 2×2 Matrices

We provide a concrete instance of `SequentialProduct` for `Fin 2 → ℝ`, modeling
the diagonal self-adjoint 2×2 complex matrices. This validates that the axiom
system S1-S7 is consistent (not vacuously true).

The sequential product is componentwise multiplication:
  `(a & b) i = a i * b i`

This is the "classical" (commutative) case where the sequential product
equals the ordinary pointwise product.
-/

noncomputable section

open OrderUnitSpace

abbrev DiagOUS := Fin 2 → ℝ

namespace DiagOUS

/-- The unit element `(1, 1)`. -/
def unit : DiagOUS := fun _ => 1

/-- Pointwise multiplication. -/
def pw_mul (a b : DiagOUS) : DiagOUS := fun i => a i * b i

theorem le_def (a b : DiagOUS) : a ≤ b ↔ ∀ i, a i ≤ b i := Pi.le_def

theorem pw_mul_comm (a b : DiagOUS) : pw_mul a b = pw_mul b a := by
  ext i; simp only [pw_mul, mul_comm]

theorem pw_mul_add_right (a b c : DiagOUS) :
    pw_mul a (b + c) = pw_mul a b + pw_mul a c := by
  ext i; simp only [pw_mul, Pi.add_apply, mul_add]

theorem pw_mul_unit_left (a : DiagOUS) : pw_mul unit a = a := by
  ext i; simp only [pw_mul, unit, one_mul]

theorem pw_mul_assoc (a b c : DiagOUS) :
    pw_mul a (pw_mul b c) = pw_mul (pw_mul a b) c := by
  ext i; simp only [pw_mul, mul_assoc]

instance : OrderUnitSpace DiagOUS where
  __ := (inferInstance : AddCommGroup DiagOUS)
  __ := (inferInstance : Module ℝ DiagOUS)
  __ := (inferInstance : PartialOrder DiagOUS)
  add_le_add_left := by
    intro a b hab c
    rw [le_def] at hab ⊢
    intro i
    simp only [Pi.add_apply]
    linarith [hab i]
  ousUnit := unit
  smul_nonneg_mono := by
    intro r hr a b hab
    rw [le_def] at hab ⊢
    intro i
    simp only [Pi.smul_apply, smul_eq_mul]
    exact mul_le_mul_of_nonneg_left (hab i) hr
  ousUnit_nonneg := by
    rw [le_def]
    intro i
    simp only [Pi.zero_apply, unit]
    linarith
  archimedean := by
    intro a
    refine ⟨|a 0| + |a 1| + 1, by positivity, ?_⟩
    rw [le_def]
    intro i
    simp only [Pi.smul_apply, smul_eq_mul, unit, mul_one]
    calc a i ≤ |a i| := le_abs_self _
    _ ≤ |a 0| + |a 1| := by
        refine Fin.cases ?_ (fun j => ?_) i
        · exact le_add_of_nonneg_right (abs_nonneg _)
        · refine Fin.cases ?_ (fun j => ?_) j
          · exact le_add_of_nonneg_left (abs_nonneg _)
          · exact absurd j.isLt (by omega)
    _ ≤ |a 0| + |a 1| + 1 := le_add_of_nonneg_right (by norm_num)

theorem isEffect_iff (a : DiagOUS) :
    IsEffect a ↔ ∀ i, 0 ≤ a i ∧ a i ≤ 1 := by
  constructor
  · intro ⟨h0, h1⟩ i
    constructor
    · exact (le_def 0 a).mp h0 i
    · have := (le_def a unit).mp h1 i
      simp only [unit] at this
      exact this
  · intro h
    constructor
    · rw [le_def]; intro i; exact (h i).1
    · rw [le_def]; intro i
      change a i ≤ unit i
      simp only [unit]
      exact (h i).2

theorem isEffect_component {a : DiagOUS} (ha : IsEffect a) (i : Fin 2) :
    0 ≤ a i ∧ a i ≤ 1 := (isEffect_iff a).mp ha i

instance : SequentialProduct DiagOUS where
  sp := pw_mul
  sp_add_right := by
    intro a b c _ _ _ _
    exact pw_mul_add_right a b c
  sp_mono_right := by
    intro a b₁ b₂ ha _ _ h
    rw [le_def] at h ⊢
    intro i
    simp only [pw_mul]
    exact mul_le_mul_of_nonneg_left (h i) ((isEffect_component ha i).1)
  sp_unit_left := by
    intro a _
    exact pw_mul_unit_left a
  sp_zero_symm := by
    intro a b _ _ hab
    rw [pw_mul_comm] at hab
    exact hab
  sp_assoc_of_compatible := by
    intro a b c _ _ _ _
    exact pw_mul_assoc a b c
  compatible_ortho := by
    intro a b _ _ _
    exact pw_mul_comm a (ousUnit - b)
  compatible_add := by
    intro a b c _ _ _ _ _ _
    exact pw_mul_comm a (b + c)
  compatible_sp := by
    intro a b c _ _ _ _ _
    exact pw_mul_comm a (pw_mul b c)
  sp_effect := by
    intro a b ha hb
    constructor
    · rw [le_def]; intro i
      simp only [Pi.zero_apply, pw_mul]
      exact mul_nonneg (isEffect_component ha i).1 (isEffect_component hb i).1
    · rw [le_def]; intro i
      simp only [pw_mul]
      exact mul_le_one₀ (isEffect_component ha i).2 (isEffect_component hb i).1 (isEffect_component hb i).2

  sp_sub_right_general := by
    intro a b c _ _ _
    funext i; simp only [pw_mul, Pi.sub_apply, mul_sub]

end DiagOUS
