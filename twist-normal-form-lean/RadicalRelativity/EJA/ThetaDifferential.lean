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

end RadicalRelativity.EJA
