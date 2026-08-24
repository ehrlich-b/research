/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.ThetaDifferential
import RadicalRelativity.EJA.HermMatCarrier
import RadicalRelativity.EJA.AlbertBridge

set_option linter.style.longLine false

/-!
# The abstract layer, fired at the quaternionic and exceptional carriers

★★★ **This file exists to correct a pricing, and the correction is checkable rather than asserted.**
`STATEMENT-MANIFEST.md` row 20 recorded its obstruction as "**no concrete quaternionic carrier**",
blaming `RCLike`: that class extends `DenselyNormedField`, which is commutative, so `ℍ` can never be
an instance and the tree's field-general `Gen` layer cannot reach it.

That diagnosis is right about `Gen` and **wrong about the tree**.  `EJA/HermMatCarrier.lean`'s
`instEuclideanJordanAlgebraHermMat` carries the class on `HermMat ι C` for any *associative*
composition coefficient — which is exactly `ℝ`, `ℂ` and `ℍ` — and `EJA/AlbertBridge.lean` carries it
on `HermMat (Fin 3) Octonion`.  So every abstract result of this development instantiates at both
carriers, with nothing left to build.

The declarations below fire that instantiation, so the claim is machine-checked and not a grep:

* `quaternionicLuders` / `albertLuders` — the S1–S7 (+S2) inhabitant on `H_n(ℍ)` and `H₃(𝕆)`;
* `quaternionic_dChi_deriv` / `albert_dChi_deriv` — `dχ` itself is defined there (so row 17's whole
  chain, `chiCLM` through `exists_blockGenerator_skew`, instantiates), and `dχ(r)` is a frame-fixing
  **derivation** of the carrier.

★ What this does **not** do, and the rows must not be re-read as if it did: it supplies no
classification of the frame stabilizer.  Rows 18, 20 and 21 need the *action* of that Lie algebra on
`V_{ij}` — `ξ_i x − x ξ_j` for `ℍ`, triality for `𝕆` — and that is what is still open.  What changes
is the description of the gap: it is a classification of frame-fixing derivations of a carrier the
tree **has**, not the absence of the carrier.
-/

noncomputable section

namespace RadicalRelativity.EJA

open CompositionAlgebra

/-! ## The quaternionic carrier `H_n(ℍ)` -/

/-- **The Lüders product on `H_n(ℍ)`**, all eight fields. -/
def quaternionicLuders (n : ℕ) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) (Quaternion ℝ)))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) (Quaternion ℝ))
      jmulₗ_one_mul
    SequentialProductOn (HermMat (Fin n) (Quaternion ℝ)) :=
  ludersSequentialProduct

/-- **`dχ(r)` is a frame-fixing derivation of `H_n(ℍ)`** — the Lie-algebra element rows 18 and 20
have to classify. -/
theorem quaternionic_dChi_deriv {n N : ℕ} (F : JordanFrame (HermMat (Fin n) (Quaternion ℝ)) N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) (Quaternion ℝ)))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) (Quaternion ℝ))
      jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) (Quaternion ℝ)))
      (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) (Quaternion ℝ)))
      (r : Fin N → ℝ),
      (∀ x y : HermMat (Fin n) (Quaternion ℝ), dChi F P hS2 harch r (x * y)
        = dChi F P hS2 harch r x * y + x * dChi F P hS2 harch r y)
      ∧ ∀ k : Fin N, dChi F P hS2 harch r (F.p k) = 0 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) (Quaternion ℝ)))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) (Quaternion ℝ))
    jmulₗ_one_mul
  intro P hS2 harch r
  exact ⟨dChi_jordanDeriv F P hS2 harch r, dChi_frameProj F P hS2 harch r⟩

/-! ## The exceptional carrier `H₃(𝕆)` -/

/-- **The Lüders product on `H₃(𝕆)`**, all eight fields. -/
def albertLuders :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin 3) Octonion))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin 3) Octonion)
      jmulₗ_one_mul
    SequentialProductOn (HermMat (Fin 3) Octonion) :=
  ludersSequentialProduct

/-- **`dχ(r)` is a frame-fixing derivation of `H₃(𝕆)`** — the object `IsAlbertModel`'s cited
Yokota faithfulness is a statement *about*. -/
theorem albert_dChi_deriv {N : ℕ} (F : JordanFrame (HermMat (Fin 3) Octonion) N) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin 3) Octonion))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin 3) Octonion)
      jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin 3) Octonion))
      (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin 3) Octonion))
      (r : Fin N → ℝ),
      (∀ x y : HermMat (Fin 3) Octonion, dChi F P hS2 harch r (x * y)
        = dChi F P hS2 harch r x * y + x * dChi F P hS2 harch r y)
      ∧ ∀ k : Fin N, dChi F P hS2 harch r (F.p k) = 0 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin 3) Octonion))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin 3) Octonion)
    jmulₗ_one_mul
  intro P hS2 harch r
  exact ⟨dChi_jordanDeriv F P hS2 harch r, dChi_frameProj F P hS2 harch r⟩

end RadicalRelativity.EJA
