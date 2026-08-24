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

/-! ## The standard frame on `H_ι(C)`

★★★ Rows 18 and 20 need the frame their statements are *about* — the diagonal matrix units — not
merely the abstract `exists_jordanFrame`.  `Composition/HermMat.lean` already has idempotence,
orthogonality and completeness of `hermIdem`; the one missing field of `JordanFrame` is
**primitivity**, and it is elementary: `pᵢ ∘ d = d` pins every entry of `d` off `(i,i)` to zero, the
hermitian condition makes `d_{ii}` real, and an idempotent multiple of `pᵢ` has coefficient `0` or
`1`. -/

section StdFrame

variable {ι : Type*} [Fintype ι] [DecidableEq ι] {C : Type*} [Ring C] [Module ℝ C]
  [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C] [Nontrivial C]

/-- An element of `J₁(pᵢ)` is a real multiple of `pᵢ`. -/
theorem eq_smul_hermIdem_of_peirceOne {i : ι} {d : HermMat ι C}
    (hd : (hermIdem i : HermMat ι C) * d = d) :
    d = (ip ((d : Matrix ι ι C) i i) 1) • (hermIdem i : HermMat ι C) := by
  have hentry : ∀ a b : ι, ¬(a = i ∧ b = i) → (d : Matrix ι ι C) a b = 0 := by
    intro a b hab
    have h := congrArg (fun A : HermMat ι C => (A : Matrix ι ι C) a b) hd
    rw [hermMat_mul_eq_jmul, jmul_coe, hermIdem_coe] at h
    simp only [Matrix.smul_apply, Matrix.add_apply, Matrix.diagonal_mul, Matrix.mul_diagonal,
      smul_eq_mul] at h
    by_cases hai : a = i
    · subst hai
      have hbi : b ≠ a := fun hb => hab ⟨rfl, hb⟩
      simp only [if_pos rfl, if_neg hbi] at h
      have : (2 : ℝ)⁻¹ • ((d : Matrix ι ι C) a b + 0) = (d : Matrix ι ι C) a b := by
        simpa using h
      rw [add_zero] at this
      have h2 : ((2 : ℝ)⁻¹ - 1) • (d : Matrix ι ι C) a b = 0 := by
        rw [sub_smul, this, one_smul, sub_self]
      have hne : ((2 : ℝ)⁻¹ - 1) ≠ 0 := by norm_num
      exact (smul_eq_zero.mp h2).resolve_left hne
    · by_cases hbi : b = i
      · subst hbi
        simp only [if_neg hai, if_pos rfl] at h
        have : (2 : ℝ)⁻¹ • ((0 : C) + (d : Matrix ι ι C) a b) = (d : Matrix ι ι C) a b := by
          simpa using h
        rw [zero_add] at this
        have h2 : ((2 : ℝ)⁻¹ - 1) • (d : Matrix ι ι C) a b = 0 := by
          rw [sub_smul, this, one_smul, sub_self]
        have hne : ((2 : ℝ)⁻¹ - 1) ≠ 0 := by norm_num
        exact (smul_eq_zero.mp h2).resolve_left hne
      · simp only [if_neg hai, if_neg hbi] at h
        simpa using h.symm
  apply Subtype.ext
  ext a b
  rw [Submodule.coe_smul, hermIdem_coe, Matrix.smul_apply, Matrix.diagonal_apply]
  by_cases hab : a = i ∧ b = i
  · have hab1 : a = b := hab.1.trans hab.2.symm
    rw [if_pos hab1, if_pos hab.1, hab.1, hab.2]
    exact diag_eq_smul_one d i
  · rw [hentry a b hab]
    by_cases hab2 : a = b
    · subst hab2
      have hai : a ≠ i := fun h => hab ⟨h, h⟩
      rw [if_pos rfl, if_neg hai, smul_zero]
    · rw [if_neg hab2, smul_zero]

/-- ★★★ **The diagonal matrix units are primitive.** -/
theorem hermIdem_ne_zero (i : ι) : (hermIdem i : HermMat ι C) ≠ 0 := by
  intro h
  have h1 := congrArg (fun A : HermMat ι C => (A : Matrix ι ι C) i i) h
  simp only [hermIdem_coe, Matrix.diagonal_apply_eq, if_pos, ZeroMemClass.coe_zero,
    Matrix.zero_apply, reduceIte] at h1
  exact one_ne_zero h1

theorem hermIdem_isPrimitive (i : ι) : IsPrimitive (hermIdem i : HermMat ι C) := by
  refine ⟨hermIdem_jmul_self i, hermIdem_ne_zero i, ?_⟩
  intro d hd hcd
  have hsm := eq_smul_hermIdem_of_peirceOne hcd
  set a : ℝ := ip ((d : Matrix ι ι C) i i) 1 with hadef
  have hsq : a * a = a := by
    have h1 : d * d = (a * a) • (hermIdem i : HermMat ι C) := by
      rw [hsm, hermMat_mul_eq_jmul, jmul_smul_left, jmul_smul_right,
        hermIdem_jmul_self, smul_smul]
    rw [hd, hsm] at h1
    have h2 : (a - a * a) • (hermIdem i : HermMat ι C) = 0 := by
      rw [sub_smul, ← h1, sub_self]
    rcases smul_eq_zero.mp h2 with h3 | h3
    · linarith [h3]
    · exact absurd h3 (hermIdem_ne_zero i)
  have hz : a * (a - 1) = 0 := by nlinarith [hsq]
  rcases mul_eq_zero.mp hz with h | h
  · left; rw [hsm, h, zero_smul]
  · right; rw [hsm, sub_eq_zero.mp h, one_smul]

/-- The Peirce-`½` condition at `pᵢ`, in entries: the `(i,i)` entry vanishes and so does every
entry with **both** indices off `i`. -/
theorem peirceHalf_entry {i : ι} {A : HermMat ι C}
    (h : (hermIdem i : HermMat ι C) * A = (2 : ℝ)⁻¹ • A) :
    (A : Matrix ι ι C) i i = 0 ∧ ∀ a b : ι, a ≠ i → b ≠ i → (A : Matrix ι ι C) a b = 0 := by
  have hent : ∀ a b : ι,
      ((if a = i then (1 : C) else 0) * (A : Matrix ι ι C) a b
        + (A : Matrix ι ι C) a b * (if b = i then (1 : C) else 0))
      = (A : Matrix ι ι C) a b := by
    intro a b
    have h1 := congrArg (fun M : HermMat ι C => (M : Matrix ι ι C) a b) h
    rw [hermMat_mul_eq_jmul, jmul_coe, hermIdem_coe] at h1
    simp only [Matrix.smul_apply, Matrix.add_apply, Matrix.diagonal_mul, Matrix.mul_diagonal,
      Submodule.coe_smul, Matrix.smul_apply] at h1
    have h2 := congrArg (fun z : C => (2 : ℝ) • z) h1
    simpa [smul_smul] using h2
  constructor
  · have h1 := hent i i
    rw [if_pos (rfl : i = i), one_mul, mul_one] at h1
    have h2 := congrArg (fun z : C => z - (A : Matrix ι ι C) i i) h1
    simpa using h2
  · intro a b ha hb
    have h1 := hent a b
    rw [if_neg ha, if_neg hb, zero_mul, mul_zero, add_zero] at h1
    exact h1.symm

theorem hermOff_symm {i j : ι} (hij : i ≠ j) (x : C) :
    (hermOff hij x : HermMat ι C) = hermOff (Ne.symm hij) (cstar x) := by
  apply Subtype.ext
  rw [hermOff_coe, hermOff_coe, cstar_cstar, add_comm]

/-- ★★★ **The standard Jordan frame of `H_ι(C)`** — the diagonal matrix units. -/
def hermFrame (n : ℕ) : JordanFrame (HermMat (Fin n) C) n where
  p := hermIdem
  orthIdem := ⟨fun i => hermIdem_jmul_self i, fun i j hij => hermIdem_jmul_of_ne hij⟩
  primitive := hermIdem_isPrimitive
  complete := sum_hermIdem

@[simp]
theorem hermFrame_p (n : ℕ) (i : Fin n) :
    (hermFrame (C := C) n).p i = hermIdem i := rfl

/-- Off-diagonal elements lie in the corresponding Peirce block. -/
theorem hermOff_mem_frameBlock {n : ℕ} {i j : Fin n} (hij : i ≠ j) (x : C) :
    (hermOff hij x : HermMat (Fin n) C) ∈ frameBlockRaw (hermFrame (C := C) n) i j := by
  refine (mem_frameBlockRaw_off hij).mpr ⟨hermIdem_jmul_hermOff hij x, ?_⟩
  rw [hermOff_symm hij x]
  exact hermIdem_jmul_hermOff (Ne.symm hij) (cstar x)

/-- ★★★ **The block `V_{ij}` of the standard frame IS a copy of `C`**: every element is
`hermOff` of its own `(i,j)` entry.  With `hermOff_injective` this is the coordinate
identification `V_{ij} ≅ C` rows 18 and 20 are stated in. -/
theorem eq_hermOff_of_mem_frameBlock {n : ℕ} {i j : Fin n} (hij : i ≠ j)
    {A : HermMat (Fin n) C} (hA : A ∈ frameBlockRaw (hermFrame (C := C) n) i j) :
    A = hermOff hij ((A : Matrix (Fin n) (Fin n) C) i j) := by
  obtain ⟨hi, hj⟩ := (mem_frameBlockRaw_off hij).mp hA
  obtain ⟨hii, hoffi⟩ := peirceHalf_entry hi
  obtain ⟨hjj, hoffj⟩ := peirceHalf_entry hj
  apply Subtype.ext
  ext a b
  rw [hermOff_coe]
  simp only [Matrix.add_apply, Matrix.single_apply]
  by_cases hA1 : i = a ∧ j = b
  · rw [if_pos hA1, if_neg (fun h : j = a ∧ i = b => hij (hA1.1.trans h.1.symm)), add_zero,
      hA1.1, hA1.2]
  · by_cases hA2 : j = a ∧ i = b
    · rw [if_neg hA1, if_pos hA2, zero_add, ← hA2.1, ← hA2.2]
      exact herm_apply A i j
    · rw [if_neg hA1, if_neg hA2, add_zero]
      by_cases hai : a = i
      · have hbj : b ≠ j := fun h => hA1 ⟨hai.symm, h.symm⟩
        by_cases hbi : b = i
        · rw [hai, hbi]; exact hii
        · exact hoffj a b (fun h => hij (hai.symm.trans h)) hbj
      · by_cases haj : a = j
        · have hbi : b ≠ i := fun h => hA2 ⟨haj.symm, h.symm⟩
          by_cases hbj : b = j
          · rw [haj, hbj]; exact hjj
          · exact hoffi a b hai hbi
        · by_cases hbi : b = i
          · exact hoffj a b haj (fun h => hij (hbi.symm.trans h))
          · exact hoffi a b hai hbi

end StdFrame

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
