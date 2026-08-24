/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Analysis.Normed.Ring.Units
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Shift

set_option linter.style.longLine false

/-!
# A continuous one-parameter subgroup of a Banach algebra is differentiable

★★★ This is the analytic ingredient `STATEMENT-MANIFEST.md` row 17 names as **(c)**, the last of
the four the differential clause `ρ_{ij}(dχ(r)) = (rᵢ−rⱼ)T_{ij}` decomposes into.  The article
takes it from the Lie structure of `Stab(F)°`; the row's cell prices getting it in-tree as "a
continuous one-parameter subgroup of a matrix group is differentiable", the easy case of
Hilbert's fifth problem.  Mathlib has no such theorem, so it is proved here.

**The proof is the classical smoothing argument, and it needs no Lie theory at all.**  Put

  `F t = ∫₀ᵗ φ(s) ds`.

Then `F` is `C¹` with `F' = φ` (fundamental theorem of calculus, in its Banach-valued form), and
the group law turns into a *functional equation for `F`*:

  `φ(u)·F(t) = ∫₀ᵗ φ(u)φ(s) ds = ∫₀ᵗ φ(u+s) ds = F(u+t) − F(u)`.

Since `F(t)/t → φ(0) = 1` as `t → 0`, some `F(t₀)` is invertible, and then

  `φ(u) = (F(u+t₀) − F(u))·F(t₀)⁻¹`

exhibits `φ` as a difference of differentiable functions times a constant.  Differentiability of
`φ` is *deduced* rather than assumed — which is the whole point, since the only thing known about
`φ` in the application is continuity (paper axiom S2).

★ Everything is stated for an arbitrary real Banach algebra `A`.  The application takes
`A = V →L[ℝ] V` for a finite-dimensional `V`, where the hypotheses are automatic.

* `OneParam.mul_prim` — the functional equation.
* `OneParam.exists_isUnit_prim` — some `F(t₀)` is a unit.
* `OneParam.hasDerivAt_of_continuous` — `φ` is differentiable everywhere, with
  `φ'(u) = φ(u)·φ'(0)`.
-/

noncomputable section

open scoped Topology

namespace OneParam

variable {A : Type*} [NormedRing A] [NormedAlgebra ℝ A] [CompleteSpace A]

/-- The primitive `F t = ∫₀ᵗ φ`. -/
def prim (φ : ℝ → A) (t : ℝ) : A := ∫ s in (0 : ℝ)..t, φ s

@[simp]
theorem prim_zero (φ : ℝ → A) : prim φ 0 = 0 := by
  simp [prim]

/-- **Fundamental theorem of calculus**, Banach-valued: `F' = φ`. -/
theorem hasDerivAt_prim {φ : ℝ → A} (hφ : Continuous φ) (t : ℝ) :
    HasDerivAt (prim φ) (φ t) t :=
  (hφ.integral_hasStrictDerivAt 0 t).hasDerivAt

/-- **The functional equation.**  The group law for `φ` becomes an additive shift identity for its
primitive, and this is the step that converts a purely topological hypothesis into a differentiable
one. -/
theorem mul_prim {φ : ℝ → A} (hφ : Continuous φ) (hmul : ∀ s t, φ (s + t) = φ s * φ t) (u t : ℝ) :
    φ u * prim φ t = prim φ (u + t) - prim φ u := by
  have hint : ∀ a b : ℝ, IntervalIntegrable φ MeasureTheory.volume a b :=
    fun a b => hφ.intervalIntegrable a b
  have h1 : φ u * prim φ t = ∫ s in (0 : ℝ)..t, φ u * φ s := by
    rw [prim]
    exact (ContinuousLinearMap.intervalIntegral_comp_comm
      (ContinuousLinearMap.mul ℝ A (φ u)) (hint 0 t)).symm
  have h2 : ∀ s : ℝ, φ u * φ s = φ (u + s) := fun s => (hmul u s).symm
  rw [h1]
  simp_rw [h2]
  rw [intervalIntegral.integral_comp_add_left φ u, add_zero, prim, prim, eq_sub_iff_add_eq,
    add_comm]
  exact intervalIntegral.integral_add_adjacent_intervals (hint 0 u) (hint u (u + t))

/-- **Some `F(t₀)` is invertible.**  `F(t)/t → φ(0) = 1`, so `F(t)/t` is eventually within `1` of
the identity, and a unit; scaling by `t ≠ 0` keeps it one. -/
theorem exists_isUnit_prim {φ : ℝ → A} (hφ : Continuous φ) (h0 : φ 0 = 1) :
    ∃ t : ℝ, t ≠ 0 ∧ IsUnit (prim φ t) := by
  have hslope : Filter.Tendsto (fun t : ℝ => t⁻¹ • prim φ t) (𝓝[≠] (0 : ℝ)) (𝓝 (1 : A)) := by
    have h := hasDerivAt_prim hφ (0 : ℝ)
    rw [h0, hasDerivAt_iff_tendsto_slope] at h
    refine h.congr fun t => ?_
    rw [slope, prim_zero, sub_zero, vsub_eq_sub, sub_zero]
  have hmem : {y : A | ‖y - 1‖ < 1} ∈ 𝓝 (1 : A) := by
    have hopen : IsOpen {y : A | ‖y - 1‖ < 1} :=
      isOpen_lt (by fun_prop) continuous_const
    exact hopen.mem_nhds (by simp)
  have hev : ∀ᶠ t in 𝓝[≠] (0 : ℝ), ‖t⁻¹ • prim φ t - 1‖ < 1 := hslope.eventually hmem
  obtain ⟨t, htnorm, htne⟩ := (hev.and eventually_mem_nhdsWithin).exists
  have htne' : t ≠ 0 := htne
  refine ⟨t, htne', ?_⟩
  have hunit : IsUnit (t⁻¹ • prim φ t) := by
    refine ⟨Units.oneSub (1 - t⁻¹ • prim φ t) ?_, ?_⟩
    · rw [norm_sub_rev]; exact htnorm
    · rw [Units.val_oneSub, sub_sub_cancel]
  have halg : IsUnit ((algebraMap ℝ A) t) :=
    (algebraMap ℝ A).isUnit_map (isUnit_iff_ne_zero.mpr htne')
  have hprod : (algebraMap ℝ A) t * (t⁻¹ • prim φ t) = prim φ t := by
    rw [Algebra.algebraMap_eq_smul_one, smul_mul_assoc, one_mul, smul_smul,
      mul_inv_cancel₀ htne', one_smul]
  rw [← hprod]
  exact halg.mul hunit

/-- ★★★ **A continuous one-parameter subgroup of a Banach algebra is differentiable**, with
derivative `φ'(u) = φ(u)·φ'(0)`.  No Lie theory, no local logarithm, no smoothness hypothesis —
only continuity and the group law. -/
theorem hasDerivAt_of_continuous {φ : ℝ → A} (hφ : Continuous φ) (h0 : φ 0 = 1)
    (hmul : ∀ s t, φ (s + t) = φ s * φ t) (u : ℝ) :
    HasDerivAt φ (φ u * deriv φ 0) u := by
  obtain ⟨t₀, ht₀ne, hunit⟩ := exists_isUnit_prim hφ h0
  obtain ⟨w, hw⟩ := hunit
  -- `φ u = (F(u+t₀) − F u) * w⁻¹`, so `φ` is differentiable everywhere.
  have hrep : ∀ v : ℝ, φ v = (prim φ (v + t₀) - prim φ v) * (↑w⁻¹ : A) := by
    intro v
    rw [← mul_prim hφ hmul v t₀, ← hw, mul_assoc, Units.mul_inv, mul_one]
  have hdiff : ∀ v : ℝ, DifferentiableAt ℝ φ v := by
    intro v
    have hshiftd : HasDerivAt (fun x : ℝ => prim φ (x + t₀)) (φ (v + t₀)) v :=
      HasDerivAt.comp_add_const v t₀ (hasDerivAt_prim hφ (v + t₀))
    have hd : HasDerivAt (fun x : ℝ => (prim φ (x + t₀) - prim φ x) * (↑w⁻¹ : A))
        ((φ (v + t₀) - φ v) * (↑w⁻¹ : A)) v :=
      HasDerivAt.mul_const (hshiftd.sub (hasDerivAt_prim hφ v)) _
    have : HasDerivAt φ ((φ (v + t₀) - φ v) * (↑w⁻¹ : A)) v := by
      simpa only [← hrep] using hd
    exact this.differentiableAt
  -- With differentiability in hand, the group law gives the derivative in the stated form.
  have hshift : HasDerivAt (fun h : ℝ => φ (u + h)) (φ u * deriv φ 0) 0 := by
    have hcomp : HasDerivAt (fun h : ℝ => φ u * φ h) (φ u * deriv φ 0) 0 :=
      HasDerivAt.const_mul _ (hdiff 0).hasDerivAt
    refine hcomp.congr_of_eventuallyEq ?_
    filter_upwards with h using (hmul u h)
  have hu : HasDerivAt (fun h : ℝ => φ (u + h)) (deriv φ u) 0 := by
    have hbase : HasDerivAt φ (deriv φ u) (u + 0) := by
      rw [add_zero]; exact (hdiff u).hasDerivAt
    exact HasDerivAt.comp_const_add u 0 hbase
  have hval : deriv φ u = φ u * deriv φ 0 := hu.unique hshift
  rw [← hval]
  exact (hdiff u).hasDerivAt

end OneParam
