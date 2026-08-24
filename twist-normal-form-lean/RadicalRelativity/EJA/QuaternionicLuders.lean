/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.CarrierInstances
import RadicalRelativity.MasterTheorem.Branches.Quaternionic
import Mathlib.Analysis.Quaternion

set_option linter.style.longLine false

/-!
# `thm:quaternionic` on the concrete carrier

★★★ Manifest **row 20**: on `H_n(ℍ)` with `n ≥ 3`, `Θ_r = id`, so the product is Lüders.

`EJA/CarrierInstances.lean` proves the whole statement for any associative composition coefficient
`C` satisfying `Z(C) ∩ Im C = 0` (`twistTheta_id_of_center_im_trivial`).  This file supplies that
one hypothesis at `C = ℍ`, where it is `MasterTheorem.Quaternionic.central_im_zero` — the finite
computation the tree already had, and the only type-specific input in the chain.

★ The same theorem fires at `C = ℝ` (`thm:real`), since `Z(ℝ) ∩ Im ℝ = 0` for the trivial reason
that `Im ℝ = 0`.
-/

noncomputable section

namespace RadicalRelativity.EJA

open CompositionAlgebra

variable {n : ℕ}

/-- **`Z(ℍ) ∩ Im ℍ = 0`**, in the form `CarrierInstances` consumes.  The composition-algebra form
on `ℍ` pairs with `1` by taking the real part, so `ip γ 1 = 0` is exactly `γ ∈ Im ℍ`. -/
theorem quaternion_center_im_trivial (γ : Quaternion ℝ)
    (hc : ∀ x : Quaternion ℝ, γ * x = x * γ)
    (him : ip γ (1 : Quaternion ℝ) = 0) : γ = 0 := by
  refine MasterTheorem.Quaternionic.central_im_zero ?_ hc
  have hexp : γ.re * 1 + γ.imI * 0 + γ.imJ * 0 + γ.imK * 0 = 0 := him
  have hsimp : γ.re * 1 + γ.imI * 0 + γ.imJ * 0 + γ.imK * 0 = γ.re := by ring
  rw [hsimp] at hexp
  exact hexp

/-- ★★★ **`thm:quaternionic`, on the concrete carrier.**  On `H_n(ℍ)` with `n ≥ 3` the twist
automorphism of every S1–S7 (+S2) product is the identity, so the defining identity
`L_{a(r)} = Q_{√a(r)} ∘ Θ_r` collapses to the Lüders product `a·b = Q_{√a}b`. -/
theorem quaternionic_twistTheta_id (hn : 3 ≤ n) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) (Quaternion ℝ)))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) (Quaternion ℝ))
      jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) (Quaternion ℝ)))
      (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) (Quaternion ℝ)))
      (r : Fin n → ℝ) (hr : ∀ k, r k ≤ 0) (z : HermMat (Fin n) (Quaternion ℝ)),
      twistTheta (hermFrame) P hS2 harch r hr z = z :=
  twistTheta_id_of_center_im_trivial hn quaternion_center_im_trivial

/-- ★★★ **`thm:quaternionic`, the row's literal conclusion**: the product **is** the Lüders
product on the twist family, `a · b = Q_{√a} b`. -/
theorem quaternionic_luders (hn : 3 ≤ n) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) (Quaternion ℝ)))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) (Quaternion ℝ))
      jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) (Quaternion ℝ)))
      (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) (Quaternion ℝ)))
      (r : Fin n → ℝ) (hr : ∀ k, r k ≤ 0) (z : HermMat (Fin n) (Quaternion ℝ)),
      P.seqLeftMulAbs harch (isEffect_twistElt (hermFrame) hr) z
        = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul
            (twistElt (hermFrame) r)) z := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) (Quaternion ℝ)))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) (Quaternion ℝ))
    jmulₗ_one_mul
  intro P hS2 harch r hr z
  rw [twistTheta_spec (hermFrame) P hS2 harch r hr z,
    quaternionic_twistTheta_id hn P hS2 harch r hr z]

end RadicalRelativity.EJA
