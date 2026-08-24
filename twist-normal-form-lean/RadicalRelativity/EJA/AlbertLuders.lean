/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.CarrierInstances
import RadicalRelativity.EJA.AlbertBridge

set_option linter.style.longLine false

/-!
# `thm:albert` on the concrete carrier

★★★ Manifest **row 21**: on `H₃(𝕆)`, `Θ_r = id`, so the product is Lüders.

★★★ **AND IT DOES NOT NEED YOKOTA TRIALITY.**  `MasterTheorem/Branches/Albert.lean` reaches the
same conclusion through `IsAlbertModel`'s `block_injective` — Spin(8)-triality faithfulness — which
its own docstring says is a *cited* hypothesis, not derivable in the abstract interface.  The route
here goes around it: `EJA/CarrierInstances.lean`'s argument is **associativity-free** and uses only
row 17's `(rᵢ−rⱼ)T_{ij}` (linear in `r`), the derivation property, and `Z(C) ∩ Im C = 0`.  The
octonions satisfy the last one, and everything before it is already stated for any composition
coefficient whose `HermMat` carries the class with the intended product — which
`EJA/AlbertBridge.lean` supplies at `𝕆` (its own docstring: "Every field except `jordan` is the
general lemma `EJA/HermMatCarrier.lean` uses, at the weakest tier — **none of them needed
associativity**").
-/

noncomputable section

namespace RadicalRelativity.EJA

open CompositionAlgebra

/-- `H₃(𝕆)`'s class product and unit are the intended ones — both `rfl`, exactly as at the
associative coefficients. -/
instance instHermMatFidOctonion : HermMatFid (Fin 3) Octonion :=
  ⟨fun _ _ => rfl, rfl⟩

/-! ## `Z(𝕆) ∩ Im 𝕆 = 0` -/

theorem ip_basisVec (k l : Fin 8) :
    ip (Octonion.basisVec k) (Octonion.basisVec l) = if k = l then 1 else 0 := by
  show Octonion.octIp _ _ = _
  rw [Octonion.octIp]
  simp only [Octonion.basisVec]
  rw [Finset.sum_eq_single k]
  · by_cases h : k = l
    · simp [h]
    · simp [h, Ne.symm h]
  · intro b _ hb
    simp [hb]
  · intro h
    exact absurd (Finset.mem_univ k) h

theorem nf_basisVec (k : Fin 8) : nf (Octonion.basisVec k) = 1 := by
  show ip _ _ = _
  rw [ip_basisVec, if_pos rfl]

theorem isPure_basisVec {k : Fin 8} (hk : k ≠ 0) : IsPure (Octonion.basisVec k) := by
  show ip (Octonion.basisVec k) 1 = 0
  rw [show (1 : Octonion) = Octonion.basisVec 0 from rfl, ip_basisVec, if_neg hk]

/-- ★★★ **`Z(𝕆) ∩ Im 𝕆 = 0`.**  The Clifford relation `xy + yx = −2⟪x,y⟫·1` turns centrality of a
pure `γ` into `γx = −⟪γ,x⟫·1` for every pure `x`; feeding it two **orthogonal** unit imaginaries
and using multiplicativity of the norm form collapses `nf γ` to `0`. -/
theorem octonion_center_im_trivial (γ : Octonion)
    (hc : ∀ x : Octonion, γ * x = x * γ) (him : ip γ (1 : Octonion) = 0) : γ = 0 := by
  have hpγ : IsPure γ := him
  have h1 : (1 : Fin 8) ≠ 0 := by decide
  have h2 : (2 : Fin 8) ≠ 0 := by decide
  have h12 : (1 : Fin 8) ≠ 2 := by decide
  set e1 : Octonion := Octonion.basisVec 1 with he1
  set e2 : Octonion := Octonion.basisVec 2 with he2
  have key : ∀ x : Octonion, IsPure x → γ * x = (-(ip γ x)) • (1 : Octonion) := by
    intro x hx
    have h := pure_mul_pure_add hpγ hx
    rw [← hc x] at h
    have h2' : (2 : ℝ) • (γ * x) = (-(2 * ip γ x)) • (1 : Octonion) := by
      rw [two_smul]; exact h
    have := congrArg (fun z : Octonion => (2 : ℝ)⁻¹ • z) h2'
    simpa [smul_smul] using this
  have hk1 := key e1 (isPure_basisVec h1)
  have hk2 := key e2 (isPure_basisVec h2)
  set α : ℝ := ip γ e1 with hα
  set β : ℝ := ip γ e2 with hβ
  -- `nf γ = α²` and `nf γ = β²`
  have hnf1 : nf γ = α ^ 2 := by
    have h := comp γ e1
    rw [hk1, nf_smul, nf_one, he1, nf_basisVec] at h
    simpa using h.symm
  have hnf2 : nf γ = β ^ 2 := by
    have h := comp γ e2
    rw [hk2, nf_smul, nf_one, he2, nf_basisVec] at h
    simpa using h.symm
  -- the combination `β·e1 − α·e2` is annihilated by `γ`
  have hz : γ * (β • e1 - α • e2) = 0 := by
    rw [mul_sub, mul_smul_comm, mul_smul_comm, hk1, hk2, smul_smul, smul_smul]
    rw [show β * -α = α * -β from by ring, sub_self]
  have hnfz : nf (β • e1 - α • e2) = β ^ 2 + α ^ 2 := by
    show ip _ _ = _
    simp only [ip_sub_left, ip_sub_right, ip_smul_left, ip_smul_right, he1, he2, ip_basisVec]
    norm_num
    rw [if_neg (by decide : (2 : Fin 8) ≠ 1), if_neg (by decide : (1 : Fin 8) ≠ 2)]
    ring
  have hprod := comp γ (β • e1 - α • e2)
  rw [hz, hnfz] at hprod
  have hzero : nf γ * (β ^ 2 + α ^ 2) = 0 := by
    rw [← hprod]
    show ip (0 : Octonion) 0 = 0
    simp
  rw [← hnf1, ← hnf2] at hzero
  have : nf γ * (2 * nf γ) = 0 := by rw [← hzero]; ring
  have hnfγ : nf γ = 0 := by
    rcases mul_eq_zero.mp this with h | h
    · exact h
    · linarith
  exact nf_eq_zero_iff.mp hnfγ

/-- ★★★ **`thm:albert`, on the concrete carrier.**  On `H₃(𝕆)` the twist automorphism of every
S1–S7 (+S2) sequential product is the identity, so the product is the Lüders product. -/
theorem albert_twistTheta_id :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin 3) Octonion))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin 3) Octonion) jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin 3) Octonion)) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin 3) Octonion))
      (r : Fin 3 → ℝ) (hr : ∀ k, r k ≤ 0) (z : HermMat (Fin 3) Octonion),
      twistTheta (hermFrame (C := Octonion)) P hS2 harch r hr z = z :=
  twistTheta_id_of_center_im_trivial (by norm_num) octonion_center_im_trivial

/-- ★★★ **`thm:albert`, the row's literal conclusion**: the product **is** the Lüders product on
the twist family, `a · b = Q_{√a} b`. -/
theorem albert_luders :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin 3) Octonion))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin 3) Octonion) jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin 3) Octonion)) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin 3) Octonion))
      (r : Fin 3 → ℝ) (hr : ∀ k, r k ≤ 0) (z : HermMat (Fin 3) Octonion),
      P.seqLeftMulAbs harch (isEffect_twistElt (hermFrame (C := Octonion)) hr) z
        = quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul
            (twistElt (hermFrame (C := Octonion)) r)) z := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin 3) Octonion))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin 3) Octonion) jmulₗ_one_mul
  intro P hS2 harch r hr z
  rw [twistTheta_spec (hermFrame (C := Octonion)) P hS2 harch r hr z,
    albert_twistTheta_id P hS2 harch r hr z]

end RadicalRelativity.EJA
