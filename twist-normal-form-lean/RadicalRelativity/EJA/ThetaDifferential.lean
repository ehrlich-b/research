/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.ThetaAbstract
import RadicalRelativity.OneParameter

set_option linter.style.longLine false

/-!
# The differential of `χ`, and `lem:homomorphism`'s last clause

★★★ Manifest **row 17**'s remaining clause is `ρ_{ij}(dχ(r)) = (rᵢ−rⱼ)T_{ij}`, and its cell
decomposes that into four ingredients: **(a)** the block action as a named map, **(b)** triviality
on the coalescence hyperplane, **(c)** existence of the differential, **(d)** the linear-algebra
step.  (a), (b) and (d) live in `EJA/ThetaAbstract.lean`; (c) is `OneParam.hasDerivAt_of_continuous`
in `RadicalRelativity/OneParameter.lean`.  This file connects them.

The connection needs `χ` as an **operator-valued** map, because "differentiable" is a statement
about a map into a normed space, and `J ≃ₗ[ℝ] J` is not one.  `chiCLM` is that map, and
`continuous_chiCLM` is the hypothesis (c) consumes — obtained from
`continuous_toCLM_thetaOf_twistElt` (paper S2, upgraded to operator continuity) together with
continuity of inversion at a unit of a Banach algebra, which is what carries the `Θ_{v(r)}⁻¹`
factor in `χ = Θ_{u(r)}·Θ_{v(r)}⁻¹`.
-/

noncomputable section

namespace RadicalRelativity.EJA

open Finset

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]
  [EuclideanJordanAlgebra J] [FiniteDimensional ℝ J]

/-! ## Linear automorphisms as units of the operator algebra -/

/-- A linear automorphism of `J`, as a unit of the Banach algebra `J →L[ℝ] J`. -/
def clmUnit (Θ : J ≃ₗ[ℝ] J) : (J →L[ℝ] J)ˣ where
  val := LinearMap.toContinuousLinearMap Θ.toLinearMap
  inv := LinearMap.toContinuousLinearMap Θ.symm.toLinearMap
  val_inv := by ext x; simp
  inv_val := by ext x; simp

@[simp]
theorem clmUnit_val (Θ : J ≃ₗ[ℝ] J) :
    (clmUnit Θ : J →L[ℝ] J) = LinearMap.toContinuousLinearMap Θ.toLinearMap := rfl

theorem clmUnit_mul (Θ Ψ : J ≃ₗ[ℝ] J) :
    (clmUnit (Θ * Ψ) : J →L[ℝ] J) = (clmUnit Θ : J →L[ℝ] J) * (clmUnit Ψ : J →L[ℝ] J) := by
  ext x; rfl

theorem clmUnit_one : (clmUnit (1 : J ≃ₗ[ℝ] J) : J →L[ℝ] J) = 1 := by
  ext x; rfl

/-- `Ring.inverse` on the operator algebra computes the inverse automorphism. -/
theorem ringInverse_clmUnit (Θ : J ≃ₗ[ℝ] J) :
    Ring.inverse (clmUnit Θ : J →L[ℝ] J) = (clmUnit Θ⁻¹ : J →L[ℝ] J) := by
  rw [Ring.inverse_unit (clmUnit Θ)]
  ext x
  rfl

/-- Inversion is continuous along a continuous family of automorphisms. -/
theorem continuous_ringInverse_clmUnit {X : Type*} [TopologicalSpace X] (Θ : X → (J ≃ₗ[ℝ] J))
    (hΘ : Continuous fun x => (clmUnit (Θ x) : J →L[ℝ] J)) :
    Continuous fun x => (clmUnit (Θ x)⁻¹ : J →L[ℝ] J) := by
  refine continuous_iff_continuousAt.mpr fun x => ?_
  have h : ContinuousAt (Ring.inverse ∘ fun y => (clmUnit (Θ y) : J →L[ℝ] J)) x :=
    ContinuousAt.comp (x := x) (NormedRing.inverse_continuousAt (clmUnit (Θ x)))
      hΘ.continuousAt
  simpa only [Function.comp_def, ringInverse_clmUnit] using h

/-! ## `χ` as an operator-valued map -/

/-- **`χ_r` as a continuous linear operator on `J`.**  Differentiability is a statement about maps
into a normed space, and `J ≃ₗ[ℝ] J` is not one; this is the same map read in `J →L[ℝ] J`. -/
def chiCLM {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (_ : OrderUnitSpace.IsArchimedean J), (Fin N → ℝ) → (J →L[ℝ] J) :=
  fun P hS2 harch r => (clmUnit (twistChi F P hS2 harch r) : J →L[ℝ] J)

theorem chiCLM_apply {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (z : J),
      chiCLM F P hS2 harch r z = twistChi F P hS2 harch r z := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r z
  rfl

/-- **`χ` is a homomorphism, in the operator algebra.** -/
theorem chiCLM_add {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r s : Fin N → ℝ),
      chiCLM F P hS2 harch (r + s) = chiCLM F P hS2 harch r * chiCLM F P hS2 harch s := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r s
  show (clmUnit (twistChi F P hS2 harch (r + s)) : J →L[ℝ] J) = _
  rw [twistChi_add F P hS2 harch r s, clmUnit_mul]
  rfl

theorem chiCLM_zero {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J),
      chiCLM F P hS2 harch 0 = 1 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch
  show (clmUnit (twistChi F P hS2 harch 0) : J →L[ℝ] J) = 1
  rw [twistChi_eq_twistTheta F P hS2 harch 0 (fun k => le_rfl),
    twistTheta_zero F P hS2 harch (fun k => le_rfl)]
  exact clmUnit_one

/-- ★★★ **`χ` is continuous**, as an operator-valued map on all of `ℝⁿ`.

Off `continuous_toCLM_thetaOf_twistElt` — paper S2 upgraded to operator continuity — applied to the
two continuous nonpositive parts `u(r) = min(r,0)` and `v(r) = min(−r,0)`, plus continuity of
inversion at a unit of a Banach algebra, which carries the `Θ_{v(r)}⁻¹` factor.  ★ The inverse is
the only reason this is not immediate: `Θ` itself is defined only on the cone `(−∞,0]ⁿ`, and `χ`
reaches the rest of `ℝⁿ` through it. -/
theorem continuous_chiCLM {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J),
      Continuous (chiCLM F P hS2 harch) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch
  have hu : Continuous (uPart (N := N)) :=
    continuous_pi fun k => (continuous_apply k).min continuous_const
  have hv : Continuous (vPart (N := N)) :=
    continuous_pi fun k => ((continuous_apply k).neg).min continuous_const
  have hA : Continuous fun r : Fin N → ℝ =>
      (clmUnit (twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)) : J →L[ℝ] J) :=
    continuous_toCLM_thetaOf_twistElt F uPart hu (fun x => uPart_nonpos x) P hS2 harch
      (fun x => isEffect_twistElt F (uPart_nonpos x))
  have hB : Continuous fun r : Fin N → ℝ =>
      (clmUnit (twistTheta F P hS2 harch (vPart r) (vPart_nonpos r)) : J →L[ℝ] J) :=
    continuous_toCLM_thetaOf_twistElt F vPart hv (fun x => vPart_nonpos x) P hS2 harch
      (fun x => isEffect_twistElt F (vPart_nonpos x))
  have hBinv := continuous_ringInverse_clmUnit
    (fun r : Fin N → ℝ => twistTheta F P hS2 harch (vPart r) (vPart_nonpos r)) hB
  have hsplit : chiCLM F P hS2 harch
      = fun r : Fin N → ℝ =>
        (clmUnit (twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)) : J →L[ℝ] J)
          * (clmUnit (twistTheta F P hS2 harch (vPart r) (vPart_nonpos r))⁻¹ : J →L[ℝ] J) := by
    funext r
    show (clmUnit (twistChi F P hS2 harch r) : J →L[ℝ] J) = _
    rw [show twistChi F P hS2 harch r
        = twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)
          * (twistTheta F P hS2 harch (vPart r) (vPart_nonpos r))⁻¹ from rfl, clmUnit_mul]
  rw [hsplit]
  exact hA.mul hBinv

/-! ## The differential

Fix `r`.  Then `t ↦ χ(t·r)` is a continuous one-parameter subgroup of the Banach algebra
`J →L[ℝ] J`, so `OneParam.hasDerivAt_of_continuous` — ingredient **(c)** — makes it differentiable,
and `dχ(r)` is its derivative at `0`.  Linearity of `r ↦ dχ(r)` is then the product and chain
rules applied to the group law. -/

/-- `t ↦ χ(t·r)` is continuous. -/
theorem continuous_chiCLM_smul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ),
      Continuous fun t : ℝ => chiCLM F P hS2 harch (t • r) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r
  exact (continuous_chiCLM F P hS2 harch).comp (continuous_id.smul continuous_const)

/-- ★★★ **The differential exists.**  This is `lem:homomorphism`'s ingredient (c), fired: the
one-parameter subgroup `t ↦ χ(t·r)` is differentiable because it is a *continuous* homomorphism
into a Banach algebra, with no smoothness assumed anywhere. -/
theorem hasDerivAt_chiCLM_smul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (u : ℝ),
      HasDerivAt (fun t : ℝ => chiCLM F P hS2 harch (t • r))
        (chiCLM F P hS2 harch (u • r)
          * deriv (fun t : ℝ => chiCLM F P hS2 harch (t • r)) 0) u := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r u
  refine OneParam.hasDerivAt_of_continuous (continuous_chiCLM_smul F P hS2 harch r) ?_ ?_ u
  · rw [zero_smul, chiCLM_zero]
  · intro s t
    rw [add_smul, chiCLM_add]

/-- **The differential of `χ` at `0` in the direction `r`.** -/
def dChi {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (_ : OrderUnitSpace.IsArchimedean J), (Fin N → ℝ) → (J →L[ℝ] J) :=
  fun P hS2 harch r => deriv (fun t : ℝ => chiCLM F P hS2 harch (t • r)) 0

theorem hasDerivAt_dChi {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ),
      HasDerivAt (fun t : ℝ => chiCLM F P hS2 harch (t • r)) (dChi F P hS2 harch r) 0 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r
  have h := hasDerivAt_chiCLM_smul F P hS2 harch r 0
  rw [zero_smul, chiCLM_zero, one_mul] at h
  exact h

theorem dChi_add {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r s : Fin N → ℝ),
      dChi F P hS2 harch (r + s) = dChi F P hS2 harch r + dChi F P hS2 harch s := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r s
  have hr := hasDerivAt_dChi F P hS2 harch r
  have hs := hasDerivAt_dChi F P hS2 harch s
  have hprod : HasDerivAt
      (fun t : ℝ => chiCLM F P hS2 harch (t • r) * chiCLM F P hS2 harch (t • s))
      (dChi F P hS2 harch r * chiCLM F P hS2 harch ((0 : ℝ) • s)
        + chiCLM F P hS2 harch ((0 : ℝ) • r) * dChi F P hS2 harch s) 0 := hr.mul hs
  simp only [zero_smul] at hprod
  rw [chiCLM_zero F P hS2 harch, mul_one, one_mul] at hprod
  refine (hasDerivAt_dChi F P hS2 harch (r + s)).unique ?_
  refine hprod.congr_of_eventuallyEq ?_
  filter_upwards with t
  rw [smul_add, chiCLM_add]

theorem dChi_smul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (c : ℝ) (r : Fin N → ℝ),
      dChi F P hS2 harch (c • r) = c • dChi F P hS2 harch r := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch c r
  have hbase : HasDerivAt (fun t : ℝ => chiCLM F P hS2 harch (t • r)) (dChi F P hS2 harch r)
      ((fun t : ℝ => t * c) 0) := by
    simpa using hasDerivAt_dChi F P hS2 harch r
  have hcomp := HasDerivAt.scomp (0 : ℝ) hbase ((hasDerivAt_id (0 : ℝ)).mul_const c)
  have hres : HasDerivAt (fun t : ℝ => chiCLM F P hS2 harch (t • (c • r)))
      ((1 * c) • dChi F P hS2 harch r) 0 := by
    refine hcomp.congr_of_eventuallyEq ?_
    filter_upwards with t
    simp only [Function.comp_apply, id_eq, smul_smul, mul_comm]
  rw [one_mul] at hres
  exact (hasDerivAt_dChi F P hS2 harch (c • r)).unique hres

/-- **The differential, bundled as the real-linear map the article's clause needs.** -/
def dChiL {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J), P.FirstArgContinuous →
      ∀ (_ : OrderUnitSpace.IsArchimedean J), (Fin N → ℝ) →ₗ[ℝ] (J →L[ℝ] J) :=
  fun P hS2 harch =>
    { toFun := dChi F P hS2 harch
      map_add' := dChi_add F P hS2 harch
      map_smul' := fun c r => dChi_smul F P hS2 harch c r }

/-! ## The block action, and `lem:homomorphism`'s conclusion -/

/-- Restriction of an operator on `J` to a submodule, as a continuous linear map.  ★ Note this is
defined for **every** operator, with no invariance hypothesis: `ρ_{ij}` as used in the differential
argument only needs to see what `χ` does *to* the block, and invariance (`jordanAut_maps_frameBlock`)
is a separate fact about where the image lands. -/
def blockRestrict (V : Submodule ℝ J) : (J →L[ℝ] J) →ₗ[ℝ] (V →L[ℝ] J) where
  toFun A := A.comp V.subtypeL
  map_add' A B := by ext x; rfl
  map_smul' c A := by ext x; rfl

@[simp]
theorem blockRestrict_apply (V : Submodule ℝ J) (A : J →L[ℝ] J) (x : V) :
    blockRestrict V A x = A (x : J) := rfl

/-- ★★★ **`χ` is the identity on `V_{ij}` on the coalescence hyperplane.**  This is manifest
row 16 (`lem:coalescence`) pushed from `Θ` to its extension `χ`: both `u(r)` and `v(r)` inherit
`rᵢ = rⱼ` from `r`, `Θ` is the identity on the block at each, and an automorphism that is the
identity on a set has an inverse that is too. -/
theorem twistChi_id_on_frameBlock {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) {i j : Fin N},
      i ≠ j → r i = r j →
      ∀ {x : J}, x ∈ frameBlockRaw F i j → twistChi F P hS2 harch r x = x := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i j hij hrij x hx
  have hu : uPart r i = uPart r j := by simp only [uPart, hrij]
  have hv : vPart r i = vPart r j := by simp only [vPart, hrij]
  have hvx : twistTheta F P hS2 harch (vPart r) (vPart_nonpos r) x = x :=
    twistTheta_id_on_frameBlock F P hS2 harch (vPart r) (vPart_nonpos r) hij hv hx
  have hinv : (twistTheta F P hS2 harch (vPart r) (vPart_nonpos r))⁻¹ x = x := by
    conv_lhs => rw [← hvx]
    exact (twistTheta F P hS2 harch (vPart r) (vPart_nonpos r)).symm_apply_apply x
  show twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)
      ((twistTheta F P hS2 harch (vPart r) (vPart_nonpos r))⁻¹ x) = x
  rw [hinv]
  exact twistTheta_id_on_frameBlock F P hS2 harch (uPart r) (uPart_nonpos r) hij hu hx

/-- ★★★ **`lem:homomorphism`'s differential clause: `ρ_{ij}(dχ(r)) = (rᵢ−rⱼ)·T_{ij}`.**

The four ingredients its manifest cell names, assembled:

* **(a)** `ρ_{ij}` — `blockRestrict (frameBlockRaw F i j)`;
* **(b)** triviality on `{rᵢ = rⱼ}` — `twistChi_id_on_frameBlock`, i.e. row 16;
* **(c)** existence of the differential — `hasDerivAt_dChi`, off
  `OneParam.hasDerivAt_of_continuous`, whose only input about `χ` is *continuity*;
* **(d)** the linear-algebra step — `exists_smul_of_vanishing_on_diag`.

★ `T_{ij}` does not depend on `r`: it is `½·ρ_{ij}(dχ(e_i − e_j))`, produced by (d). -/
theorem exists_blockGenerator {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) {i j : Fin N}, i ≠ j →
      ∃ T : frameBlockRaw F i j →L[ℝ] J, ∀ r : Fin N → ℝ,
        blockRestrict (frameBlockRaw F i j) (dChi F P hS2 harch r) = (r i - r j) • T := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch i j hij
  refine exists_smul_of_vanishing_on_diag hij
    ((blockRestrict (frameBlockRaw F i j)).comp (dChiL F P hS2 harch)) ?_
  intro r hrij
  show blockRestrict (frameBlockRaw F i j) (dChi F P hS2 harch r) = 0
  refine ContinuousLinearMap.ext fun x => ?_
  show dChi F P hS2 harch r (x : J) = 0
  have hd := (ContinuousLinearMap.apply ℝ J (x : J)).hasFDerivAt.comp_hasDerivAt (0 : ℝ)
    (hasDerivAt_dChi F P hS2 harch r)
  refine hd.unique ?_
  have hc : (⇑(ContinuousLinearMap.apply ℝ J (x : J))
      ∘ fun t : ℝ => chiCLM F P hS2 harch (t • r)) = fun _ : ℝ => (x : J) := by
    funext t
    show chiCLM F P hS2 harch (t • r) (x : J) = (x : J)
    rw [chiCLM_apply]
    exact twistChi_id_on_frameBlock F P hS2 harch (t • r) hij
      (by simp only [Pi.smul_apply, smul_eq_mul, hrij]) x.2
  rw [hc]
  exact hasDerivAt_const _ _

/-! ## Isometry on the Peirce block

`T_{ij} ∈ 𝔰𝔬(V_{ij})` is the row's own word, and it needs `χ` to be an **isometry on the block**.
That does *not* need the (unavailable) fact that a Jordan automorphism preserves an arbitrary
associative form.  It needs only this: `⟪u,v⟫ = ⟪u∘v, 1⟫` by `inner_assoc`, and for `x, y ∈ V_{ij}`
the product `x∘y` lies in `J₁(pᵢ) ⊕ J₁(pⱼ)` — by `peirceHalf_mul_half_eq_zero`
(`J½ ∘ J½ ⊆ J₁ ⊕ J₀`) and `eigen_zero_mul_zero` at the other atoms — where `Θ` is *pointwise the
identity* (`theta_id_on_peirceTwo_all`).  So `⟪χx, χy⟫ = ⟪χ(x∘y),1⟫ = ⟪x∘y,1⟫ = ⟪x,y⟫`. -/

theorem inner_mul_one (u v : J) : (inner ℝ (u * v) (1 : J) : ℝ) = inner ℝ u v := by
  rw [EuclideanJordanAlgebra.inner_assoc u v 1,
    show (u : J) * 1 = u from by
      rw [EuclideanJordanAlgebra.mul_comm, EuclideanJordanAlgebra.one_mul]]
  exact real_inner_comm u v

theorem twistTheta_jordanMul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (hr : ∀ k, r k ≤ 0) (x y : J),
      twistTheta F P hS2 harch r hr (x * y)
        = twistTheta F P hS2 harch r hr x * twistTheta F P hS2 harch r hr y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r hr x y
  exact (thetaOf_spec F.orthIdem F.complete (twistElt_eq F r) (twistElt_isSoS F r)
    (twistElt_compl_isSoS F hr) (fun k _ => (Real.exp_pos (r k)).ne') P hS2 harch
    (isEffect_twistElt F hr)).2.1 x y

theorem twistTheta_fixes_atom {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (hr : ∀ k, r k ≤ 0) (i : Fin N),
      twistTheta F P hS2 harch r hr (F.p i) = F.p i := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r hr i
  exact theta_fixes_frame_atom F (fun k => Real.exp_pos (r k))
    (fun k => Real.exp_le_one_iff.mpr (hr k)) P hS2 harch (isEffect_twistElt F hr) _
    (twistTheta_spec F P hS2 harch r hr) i

/-- ★★★ **`Θ_r` is the identity on `J₁(p_i)`.**  `theta_id_on_peirceTwo_all` at the frame's own
decomposition of the twist element. -/
theorem twistTheta_id_on_peirceOne {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (hr : ∀ k, r k ≤ 0) (i : Fin N)
      {y : J}, F.p i * y = y → twistTheta F P hS2 harch r hr y = y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  classical
  intro P hS2 harch r hr i y hy
  have hdec : twistElt F r
      = Real.exp (r i) • F.p i + ∑ k ∈ Finset.univ.erase i, Real.exp (r k) • F.p k := by
    rw [twistElt_eq F r]
    exact (Finset.add_sum_erase _ _ (Finset.mem_univ i)).symm
  have ha₀ : F.p i * (∑ k ∈ Finset.univ.erase i, Real.exp (r k) • F.p k) = 0 := by
    rw [Finset.mul_sum]
    refine Finset.sum_eq_zero fun k hk => ?_
    rw [EuclideanJordanAlgebra.mul_comm, EuclideanJordanAlgebra.smul_mul,
      F.orthIdem.orth k i (Finset.ne_of_mem_erase hk), smul_zero]
  exact theta_id_on_peirceTwo_all F.orthIdem F.complete (twistElt_eq F r)
    (twistElt_isSoS F r) (twistElt_compl_isSoS F hr)
    (fun k _ => (Real.exp_pos (r k)).ne') (F.orthIdem.idem i) hdec ha₀
    P hS2 harch (isEffect_twistElt F hr) _ (twistTheta_spec F P hS2 harch r hr) hy

/-- ★★★ **The product of two block elements is fixed by `Θ_r`.** -/
theorem twistTheta_fixes_block_mul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (hr : ∀ k, r k ≤ 0)
      {i j : Fin N}, i ≠ j → ∀ {x y : J}, x ∈ frameBlockRaw F i j → y ∈ frameBlockRaw F i j →
      twistTheta F P hS2 harch r hr (x * y) = x * y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  classical
  intro P hS2 harch r hr i j hij x y hx hy
  obtain ⟨hxi, hxj⟩ := (mem_frameBlockRaw_off hij).mp hx
  obtain ⟨hyi, hyj⟩ := (mem_frameBlockRaw_off hij).mp hy
  -- the product has no half-part at `p i` or `p j`, and is killed by every other atom
  have hhi : peirceHalf (F.p i) (x * y) = 0 :=
    peirceHalf_mul_half_eq_zero (F.orthIdem.idem i) hxi hyi
  have hhj : peirceHalf (F.p j) (x * y) = 0 :=
    peirceHalf_mul_half_eq_zero (F.orthIdem.idem j) hxj hyj
  have hzero : ∀ k, k ≠ i → k ≠ j → F.p k * (x * y) = 0 := fun k hki hkj =>
    eigen_zero_mul_zero (F.orthIdem.idem k) (frameBlockRaw_mul_eq_zero F hki hkj hx)
      (frameBlockRaw_mul_eq_zero F hki hkj hy)
  -- `p k ∘ (x∘y)` is in `J₁(p k)` whenever the half-part vanishes
  have hone : ∀ k : Fin N, peirceHalf (F.p k) (x * y) = 0 →
      F.p k * (F.p k * (x * y)) = F.p k * (x * y) := by
    intro k hk
    have hsplit := peirce_add_add (F.p k) (x * y)
    rw [hk, add_zero] at hsplit
    have h1 : F.p k * (x * y)
        = peirceOne (F.p k) (x * y) := by
      conv_lhs => rw [← hsplit]
      rw [show F.p k * (peirceOne (F.p k) (x * y) + peirceZero (F.p k) (x * y))
          = F.p k * peirceOne (F.p k) (x * y) + F.p k * peirceZero (F.p k) (x * y) from by
        rw [EuclideanJordanAlgebra.mul_comm, EuclideanJordanAlgebra.add_mul,
          EuclideanJordanAlgebra.mul_comm (peirceOne (F.p k) (x * y)),
          EuclideanJordanAlgebra.mul_comm (peirceZero (F.p k) (x * y))],
        mul_peirceOne (F.orthIdem.idem k), mul_peirceZero (F.orthIdem.idem k), add_zero]
    rw [h1, mul_peirceOne (F.orthIdem.idem k)]
  -- decompose `x∘y` over the atoms
  have hdecomp : F.p i * (x * y) + F.p j * (x * y) = x * y := by
    have hall : ∑ k, F.p k * (x * y) = x * y := by
      rw [← Finset.sum_mul, F.complete, EuclideanJordanAlgebra.one_mul]
    have hsplit : ∑ k, F.p k * (x * y)
        = F.p i * (x * y) + (F.p j * (x * y)
          + ∑ k ∈ (Finset.univ.erase i).erase j, F.p k * (x * y)) := by
      rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)]
      congr 1
      exact (Finset.add_sum_erase _ _
        (Finset.mem_erase.mpr ⟨Ne.symm hij, Finset.mem_univ j⟩)).symm
    have hz0 : ∑ k ∈ (Finset.univ.erase i).erase j, F.p k * (x * y) = 0 :=
      Finset.sum_eq_zero fun k hk =>
        hzero k (Finset.ne_of_mem_erase (Finset.mem_of_mem_erase hk))
          (Finset.ne_of_mem_erase hk)
    rw [hsplit, hz0, add_zero] at hall
    exact hall
  calc twistTheta F P hS2 harch r hr (x * y)
      = twistTheta F P hS2 harch r hr (F.p i * (x * y) + F.p j * (x * y)) := by rw [hdecomp]
    _ = twistTheta F P hS2 harch r hr (F.p i * (x * y))
        + twistTheta F P hS2 harch r hr (F.p j * (x * y)) := map_add _ _ _
    _ = F.p i * (x * y) + F.p j * (x * y) := by
        rw [twistTheta_id_on_peirceOne F P hS2 harch r hr i (hone i hhi),
          twistTheta_id_on_peirceOne F P hS2 harch r hr j (hone j hhj)]
    _ = x * y := hdecomp

/-! ## `χ` on the block: automorphism, isometry, and the skew generator -/

theorem linearEquiv_symm_jordanMul {Θ : J ≃ₗ[ℝ] J} (h : ∀ x y : J, Θ (x * y) = Θ x * Θ y)
    (x y : J) : Θ.symm (x * y) = Θ.symm x * Θ.symm y := by
  apply Θ.injective
  rw [Θ.apply_symm_apply, h, Θ.apply_symm_apply, Θ.apply_symm_apply]

theorem linearEquiv_symm_fixes {Θ : J ≃ₗ[ℝ] J} {z : J} (h : Θ z = z) : Θ.symm z = z := by
  conv_lhs => rw [← h]
  exact Θ.symm_apply_apply z

theorem twistChi_jordanMul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (x y : J),
      twistChi F P hS2 harch r (x * y)
        = twistChi F P hS2 harch r x * twistChi F P hS2 harch r y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r x y
  show twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)
      ((twistTheta F P hS2 harch (vPart r) (vPart_nonpos r)).symm (x * y)) = _
  rw [linearEquiv_symm_jordanMul (twistTheta_jordanMul F P hS2 harch (vPart r) (vPart_nonpos r)),
    twistTheta_jordanMul F P hS2 harch (uPart r) (uPart_nonpos r)]
  rfl

theorem twistChi_fixes_atom {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (i : Fin N),
      twistChi F P hS2 harch r (F.p i) = F.p i := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i
  show twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)
      ((twistTheta F P hS2 harch (vPart r) (vPart_nonpos r)).symm (F.p i)) = _
  rw [linearEquiv_symm_fixes (twistTheta_fixes_atom F P hS2 harch (vPart r) (vPart_nonpos r) i),
    twistTheta_fixes_atom F P hS2 harch (uPart r) (uPart_nonpos r) i]

theorem twistChi_fixes_block_mul {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) {i j : Fin N}, i ≠ j →
      ∀ {x y : J}, x ∈ frameBlockRaw F i j → y ∈ frameBlockRaw F i j →
      twistChi F P hS2 harch r (x * y) = x * y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i j hij x y hx hy
  show twistTheta F P hS2 harch (uPart r) (uPart_nonpos r)
      ((twistTheta F P hS2 harch (vPart r) (vPart_nonpos r)).symm (x * y)) = _
  rw [linearEquiv_symm_fixes
      (twistTheta_fixes_block_mul F P hS2 harch (vPart r) (vPart_nonpos r) hij hx hy),
    twistTheta_fixes_block_mul F P hS2 harch (uPart r) (uPart_nonpos r) hij hx hy]

theorem twistChi_mapsTo_frameBlock {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) {i j : Fin N}, i ≠ j →
      ∀ {x : J}, x ∈ frameBlockRaw F i j → twistChi F P hS2 harch r x ∈ frameBlockRaw F i j := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i j hij x hx
  exact jordanAut_maps_frameBlock F (twistChi_jordanMul F P hS2 harch r)
    (twistChi_fixes_atom F P hS2 harch r) hij hx

/-- ★★★ **`χ_r` is an isometry on `V_{ij}`.**  `⟪u,v⟫ = ⟪u∘v,1⟫`, `χ` is multiplicative, and
`χ` fixes the product of two block elements. -/
theorem inner_twistChi_block {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) {i j : Fin N}, i ≠ j →
      ∀ {x y : J}, x ∈ frameBlockRaw F i j → y ∈ frameBlockRaw F i j →
      (inner ℝ (twistChi F P hS2 harch r x) (twistChi F P hS2 harch r y) : ℝ) = inner ℝ x y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i j hij x y hx hy
  rw [← inner_mul_one (twistChi F P hS2 harch r x) (twistChi F P hS2 harch r y),
    ← twistChi_jordanMul F P hS2 harch r x y,
    twistChi_fixes_block_mul F P hS2 harch r hij hx hy, inner_mul_one]

/-! ## The generator is skew, and stays in the block -/

theorem hasDerivAt_chiCLM_apply {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) (x : J),
      HasDerivAt (fun t : ℝ => chiCLM F P hS2 harch (t • r) x)
        (dChi F P hS2 harch r x) 0 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r x
  have h := (ContinuousLinearMap.apply ℝ J x).hasFDerivAt.comp_hasDerivAt (0 : ℝ)
    (hasDerivAt_dChi F P hS2 harch r)
  simpa only [Function.comp_def, ContinuousLinearMap.apply_apply] using h

/-- ★★★ **The generator preserves the block.**  Each difference quotient lies in `V_{ij}`
(`twistChi_mapsTo_frameBlock`), and a finite-dimensional submodule is closed. -/
theorem dChi_mapsTo_frameBlock {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) {i j : Fin N}, i ≠ j →
      ∀ {x : J}, x ∈ frameBlockRaw F i j →
      dChi F P hS2 harch r x ∈ frameBlockRaw F i j := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i j hij x hx
  have h0 : chiCLM F P hS2 harch ((0 : ℝ) • r) x = x := by
    rw [zero_smul, chiCLM_zero]; rfl
  have hd := hasDerivAt_chiCLM_apply F P hS2 harch r x
  rw [hasDerivAt_iff_tendsto_slope] at hd
  refine IsClosed.mem_of_tendsto (frameBlockRaw F i j).closed_of_finiteDimensional hd ?_
  filter_upwards with t
  rw [slope, sub_zero, vsub_eq_sub, h0]
  refine Submodule.smul_mem _ _ (Submodule.sub_mem _ ?_ hx)
  rw [chiCLM_apply]
  exact twistChi_mapsTo_frameBlock F P hS2 harch (t • r) hij hx

/-- ★★★ **The generator is skew on the block** — the derivative at `0` of a one-parameter family
of isometries of `V_{ij}`. -/
theorem inner_dChi_skew {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ) {i j : Fin N}, i ≠ j →
      ∀ {x y : J}, x ∈ frameBlockRaw F i j → y ∈ frameBlockRaw F i j →
      (inner ℝ (dChi F P hS2 harch r x) y : ℝ) = -inner ℝ x (dChi F P hS2 harch r y) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r i j hij x y hx hy
  have h0x : chiCLM F P hS2 harch ((0 : ℝ) • r) x = x := by
    rw [zero_smul, chiCLM_zero]; rfl
  have h0y : chiCLM F P hS2 harch ((0 : ℝ) • r) y = y := by
    rw [zero_smul, chiCLM_zero]; rfl
  have hprod := HasDerivAt.inner ℝ (hasDerivAt_chiCLM_apply F P hS2 harch r x)
    (hasDerivAt_chiCLM_apply F P hS2 harch r y)
  rw [h0x, h0y] at hprod
  have hconst : (fun t : ℝ => (inner ℝ (chiCLM F P hS2 harch (t • r) x)
      (chiCLM F P hS2 harch (t • r) y) : ℝ)) = fun _ : ℝ => (inner ℝ x y : ℝ) := by
    funext t
    rw [chiCLM_apply, chiCLM_apply]
    exact inner_twistChi_block F P hS2 harch (t • r) hij hx hy
  rw [hconst] at hprod
  have hzero := hprod.unique (hasDerivAt_const (0 : ℝ) (inner ℝ x y : ℝ))
  linarith [hzero]

/-- ★★★ **`lem:homomorphism`'s differential clause, in the article's own `𝔰𝔬(V_{ij})` form.**

There is a single `T` with `ρ_{ij}(dχ(r)) = (rᵢ−rⱼ)·T` for every `r`, and `T` really is an element
of `𝔰𝔬(V_{ij})`: it maps the block into itself and is skew-adjoint there.  Both extras come from
`χ` being, on each block, a one-parameter family of **isometries** of that block — which needs no
form-uniqueness theorem, only `⟪u,v⟫ = ⟪u∘v,1⟫`, `J½∘J½ ⊆ J₁⊕J₀`, and the fact that `Θ` is
pointwise the identity on each `J₁(pₖ)`. -/
theorem exists_blockGenerator_skew {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) {i j : Fin N}, i ≠ j →
      ∃ T : frameBlockRaw F i j →L[ℝ] J,
        (∀ x : frameBlockRaw F i j, T x ∈ frameBlockRaw F i j) ∧
        (∀ x y : frameBlockRaw F i j, (inner ℝ (T x) (y : J) : ℝ) = -inner ℝ (x : J) (T y)) ∧
        ∀ r : Fin N → ℝ,
          blockRestrict (frameBlockRaw F i j) (dChi F P hS2 harch r) = (r i - r j) • T := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  classical
  intro P hS2 harch i j hij
  obtain ⟨T, hT⟩ := exists_blockGenerator F P hS2 harch hij
  obtain ⟨r₀, hr₀⟩ : ∃ r₀ : Fin N → ℝ, r₀ i - r₀ j = 1 :=
    ⟨fun k => if k = i then 1 else 0, by simp [Ne.symm hij]⟩
  have hTeq : ∀ x : frameBlockRaw F i j, T x = dChi F P hS2 harch r₀ (x : J) := by
    intro x
    have h := hT r₀
    rw [hr₀, one_smul] at h
    exact (congrArg (fun A : frameBlockRaw F i j →L[ℝ] J => A x) h).symm
  refine ⟨T, ?_, ?_, hT⟩
  · intro x
    rw [hTeq x]
    exact dChi_mapsTo_frameBlock F P hS2 harch r₀ hij x.2
  · intro x y
    rw [hTeq x, hTeq y]
    exact inner_dChi_skew F P hS2 harch r₀ hij x.2 y.2

/-! ## `χ` lands in `Stab(F)°`

★ The path `t ↦ χ(t·r)` is continuous, starts at the identity (`χ(0) = 1`), ends at `χ(r)`, and
stays in `Stab(F)` throughout — so its range is a connected subset of the stabilizer containing
both endpoints.  This needs **no** fact about the identity component being a subgroup, which is
what a `χ = Θ_u Θ_v⁻¹` argument would otherwise have to supply. -/

theorem chiCLM_mem_stabFrame {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ),
      chiCLM F P hS2 harch r ∈ stabFrame F := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r
  refine ⟨(twistChi F P hS2 harch r).bijective, ?_, ?_⟩
  · intro x y
    exact twistChi_jordanMul F P hS2 harch r x y
  · intro i
    exact twistChi_fixes_atom F P hS2 harch r i

/-- ★★★ **`χ : (ℝⁿ,+) → Stab(F)°`** — the codomain the article's `lem:homomorphism` asserts. -/
theorem chiCLM_mem_stabFrame_connectedComponent {N : ℕ} (F : JordanFrame J N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ (P : SequentialProductOn J) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean J) (r : Fin N → ℝ),
      chiCLM F P hS2 harch r
        ∈ connectedComponentIn (stabFrame F) (ContinuousLinearMap.id ℝ J) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch r
  have hγc : Continuous fun t : ℝ => chiCLM F P hS2 harch (t • r) :=
    continuous_chiCLM_smul F P hS2 harch r
  have hconn : IsPreconnected (Set.range fun t : ℝ => chiCLM F P hS2 harch (t • r)) := by
    rw [← Set.image_univ]
    exact (isPreconnected_univ (α := ℝ)).image _ hγc.continuousOn
  have hsub : (Set.range fun t : ℝ => chiCLM F P hS2 harch (t • r)) ⊆ stabFrame F := by
    rintro _ ⟨t, rfl⟩
    exact chiCLM_mem_stabFrame F P hS2 harch (t • r)
  have hid : ContinuousLinearMap.id ℝ J
      ∈ Set.range fun t : ℝ => chiCLM F P hS2 harch (t • r) := by
    refine ⟨0, ?_⟩
    show chiCLM F P hS2 harch ((0 : ℝ) • r) = _
    rw [zero_smul, chiCLM_zero]
    rfl
  refine hconn.subset_connectedComponentIn hid hsub ⟨1, ?_⟩
  show chiCLM F P hS2 harch ((1 : ℝ) • r) = _
  rw [one_smul]

end RadicalRelativity.EJA
