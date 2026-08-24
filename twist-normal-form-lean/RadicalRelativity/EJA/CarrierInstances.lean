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

/-- ★★★ **The cross-block product rule**: `V_{ik} ∘ V_{kj} → V_{ij}` is `½·(multiplication in
`C`)`, for pairwise distinct `i, k, j`.  This is what turns the Jordan-derivation identity into an
identity between coordinate maps `C → C`, and hence the whole classification into algebra over `C`
rather than over `H_ι(C)`. -/
theorem hermOff_mul_hermOff {i k j : ι} (hik : i ≠ k) (hkj : k ≠ j) (hij : i ≠ j) (x y : C) :
    (hermOff hik x : HermMat ι C) * hermOff hkj y = (2 : ℝ)⁻¹ • hermOff hij (x * y) := by
  apply Subtype.ext
  rw [hermMat_mul_eq_jmul, jmul_coe, hermOff_coe, hermOff_coe, Submodule.coe_smul, hermOff_coe]
  congr 1
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.single_mul_single_same]
  rw [Matrix.single_mul_single_of_ne (h := hkj),
    Matrix.single_mul_single_of_ne (h := hik),
    Matrix.single_mul_single_of_ne (h := hij),
    Matrix.single_mul_single_of_ne (h := Ne.symm hij),
    Matrix.single_mul_single_of_ne (h := Ne.symm hkj),
    Matrix.single_mul_single_of_ne (h := Ne.symm hik),
    cstar_mul]
  abel

theorem hermOff_add {i j : ι} (hij : i ≠ j) (x y : C) :
    (hermOff hij (x + y) : HermMat ι C) = hermOff hij x + hermOff hij y := by
  apply Subtype.ext
  rw [hermOff_coe, Submodule.coe_add, hermOff_coe, hermOff_coe, cstar_add,
    Matrix.single_add, Matrix.single_add]
  abel

end StdFrame

/-! ## Frame-fixing derivations in block coordinates

★★★ Step (b) and (d) of the chain row 20 records.  A frame-fixing derivation preserves every
Peirce block, so it induces coordinate maps `d_{ab} : C → C`; the cross-block product rule then
turns the Jordan-derivation identity into

  `d_{ij}(x·y) = d_{ik}(x)·y + x·d_{kj}(y)`   (pairwise distinct `i`, `k`, `j`),

an identity **inside `C`**.  Everything after this point is algebra over the coefficient algebra,
which is what makes the remaining step type-specific rather than Jordan-theoretic. -/

section FrameDeriv

variable {n : ℕ} {C : Type*} [Ring C] [Module ℝ C] [IsScalarTower ℝ C C]
  [SMulCommClass ℝ C C] [CompositionAlgebra C] [Nontrivial C]
variable {D : HermMat (Fin n) C →ₗ[ℝ] HermMat (Fin n) C}

/-- A frame-fixing derivation preserves every off-diagonal Peirce block. -/
theorem frameDeriv_mapsTo_block (hD : ∀ A B, D (A * B) = D A * B + A * D B)
    (hfix : ∀ k, D (hermIdem k) = 0) {i j : Fin n} (hij : i ≠ j)
    {A : HermMat (Fin n) C} (hA : A ∈ frameBlockRaw (hermFrame (C := C) n) i j) :
    D A ∈ frameBlockRaw (hermFrame (C := C) n) i j := by
  obtain ⟨hi, hj⟩ := (mem_frameBlockRaw_off hij).mp hA
  have step : ∀ k : Fin n, (hermIdem k : HermMat (Fin n) C) * A = (2 : ℝ)⁻¹ • A →
      (hermIdem k : HermMat (Fin n) C) * D A = (2 : ℝ)⁻¹ • D A := by
    intro k hk
    have h := hD (hermIdem k) A
    rw [hk, hfix k, map_smul, zero_mul, zero_add] at h
    exact h.symm
  exact (mem_frameBlockRaw_off hij).mpr ⟨step i hi, step j hj⟩

/-- The coordinate map of a frame-fixing derivation on the block `V_{ij}`. -/
def blockCoord (D : HermMat (Fin n) C →ₗ[ℝ] HermMat (Fin n) C) {i j : Fin n} (hij : i ≠ j)
    (x : C) : C :=
  ((D (hermOff hij x) : HermMat (Fin n) C) : Matrix (Fin n) (Fin n) C) i j

theorem map_hermOff (hD : ∀ A B, D (A * B) = D A * B + A * D B)
    (hfix : ∀ k, D (hermIdem k) = 0) {i j : Fin n} (hij : i ≠ j) (x : C) :
    D (hermOff hij x) = hermOff hij (blockCoord D hij x) :=
  eq_hermOff_of_mem_frameBlock hij
    (frameDeriv_mapsTo_block hD hfix hij (hermOff_mem_frameBlock hij x))

/-- ★★★ **The classification identity, inside `C`.** -/
theorem blockCoord_mul (hD : ∀ A B, D (A * B) = D A * B + A * D B)
    (hfix : ∀ k, D (hermIdem k) = 0) {i k j : Fin n} (hik : i ≠ k) (hkj : k ≠ j) (hij : i ≠ j)
    (x y : C) :
    blockCoord D hij (x * y)
      = blockCoord D hik x * y + x * blockCoord D hkj y := by
  have hprod := hD (hermOff hik x) (hermOff hkj y)
  rw [hermOff_mul_hermOff hik hkj hij, map_smul,
    map_hermOff hD hfix hik, map_hermOff hD hfix hkj,
    hermOff_mul_hermOff hik hkj hij, hermOff_mul_hermOff hik hkj hij,
    map_hermOff hD hfix hij] at hprod
  have hcollect : (2 : ℝ)⁻¹ • (hermOff hij (blockCoord D hij (x * y)) : HermMat (Fin n) C)
      = (2 : ℝ)⁻¹ • (hermOff hij (blockCoord D hik x * y + x * blockCoord D hkj y) :
          HermMat (Fin n) C) := by
    rw [hermOff_add, smul_add]
    exact hprod
  have h2 : (hermOff hij (blockCoord D hij (x * y)) : HermMat (Fin n) C)
      = hermOff hij (blockCoord D hik x * y + x * blockCoord D hkj y) :=
    smul_right_injective _ (by norm_num) hcollect
  exact hermOff_injective hij h2

theorem hermOff_smul {i j : Fin n} (hij : i ≠ j) (c : ℝ) (x : C) :
    (hermOff hij (c • x) : HermMat (Fin n) C) = c • hermOff hij x := by
  apply Subtype.ext
  rw [hermOff_coe, Submodule.coe_smul, hermOff_coe, cstar_smul,
    ← Matrix.smul_single, ← Matrix.smul_single, ← smul_add]

/-- The coordinate map of a frame-fixing derivation, bundled as a real-linear map `C → C`. -/
def blockCoordₗ (D : HermMat (Fin n) C →ₗ[ℝ] HermMat (Fin n) C) {i j : Fin n} (hij : i ≠ j) :
    C →ₗ[ℝ] C where
  toFun := blockCoord D hij
  map_add' x y := by
    simp only [blockCoord, hermOff_add, map_add, Submodule.coe_add, Matrix.add_apply]
  map_smul' c x := by
    simp only [blockCoord, hermOff_smul, map_smul, Submodule.coe_smul, Matrix.smul_apply,
      RingHom.id_apply]

@[simp]
theorem blockCoordₗ_apply (D : HermMat (Fin n) C →ₗ[ℝ] HermMat (Fin n) C) {i j : Fin n}
    (hij : i ≠ j) (x : C) : blockCoordₗ D hij x = blockCoord D hij x := rfl

end FrameDeriv

/-! ## The block coordinate is multiplication by a **central** element

★★★ This is the step that makes rows 20 and 21 elementary, and it is worth stating why it is not
the classification the article's proof runs.  Row 17 gives `ρ_{ij}(dχ(r)) = (rᵢ−rⱼ)·T_{ij}` — the
coordinate map is **linear in `r` with a very particular shape**.  Feeding that into the cross-block
relation `d_{ij}(xy) = d_{ik}(x)y + x·d_{kj}(y)` and reading off two standard basis vectors
`r = e_i` and `r = e_j` gives

  `t_{ij}(xy) = t_{ik}(x)·y`   and   `t_{ij}(xy) = x·t_{kj}(y)`,

and setting `x = 1` in the first and `y = 1` in the second exhibits `t_{ij}` as **both** left and
right multiplication by one element `γ`.  So `γ` is central, with no classification of derivations
and no Lie theory anywhere.  All that is left is `Z(C) ∩ Im C = 0`, which is the article's own
final input. -/

section Central

variable {n : ℕ} {C : Type*} [Ring C] [Module ℝ C] [IsScalarTower ℝ C C]
  [SMulCommClass ℝ C C] [CompositionAlgebra C] [Nontrivial C] [FiniteDimensional ℝ C]

theorem exists_third {i j : Fin n} (hn : 3 ≤ n) : ∃ k : Fin n, k ≠ i ∧ k ≠ j := by
  classical
  by_contra hcon
  push_neg at hcon
  have hsub : (Finset.univ : Finset (Fin n)) ⊆ {i, j} := by
    intro x _
    rcases eq_or_ne x i with h | h
    · exact Finset.mem_insert.mpr (Or.inl h)
    · exact Finset.mem_insert.mpr (Or.inr (Finset.mem_singleton.mpr (hcon x h)))
  have hcard := Finset.card_le_card hsub
  rw [Finset.card_univ, Fintype.card_fin] at hcard
  have : ({i, j} : Finset (Fin n)).card ≤ 2 := (Finset.card_insert_le _ _).trans (by simp)
  omega

theorem hermIdem_coe_eq_single (i : Fin n) :
    ((hermIdem i : HermMat (Fin n) C) : Matrix (Fin n) (Fin n) C) = Matrix.single i i 1 := by
  rw [hermIdem_coe]
  ext a b
  rw [Matrix.diagonal_apply, Matrix.single_apply]
  by_cases hab : a = b
  · subst hab
    by_cases hai : a = i
    · rw [if_pos rfl, if_pos hai, if_pos ⟨hai.symm, hai.symm⟩]
    · rw [if_pos rfl, if_neg hai, if_neg (fun h => hai h.1.symm)]
  · rw [if_neg hab, if_neg (fun h => hab (h.1.symm.trans h.2))]

/-- ★★★ **The same-block product**: `V_{ij} ∘ V_{ij}` lands in `ℝpᵢ ⊕ ℝpⱼ`, and against `1` it is
the real part.  This is the identity that forces `γ` imaginary — from the *derivation* property
alone, with no appeal to the inner product on the block. -/
theorem hermOff_mul_hermOff_one {i j : Fin n} (hij : i ≠ j) (a : C) :
    (hermOff hij a : HermMat (Fin n) C) * hermOff hij 1
      = (ip a 1) • ((hermIdem i : HermMat (Fin n) C) + hermIdem j) := by
  apply Subtype.ext
  rw [hermMat_mul_eq_jmul, jmul_coe, hermOff_coe, hermOff_coe, Submodule.coe_smul,
    Submodule.coe_add, hermIdem_coe_eq_single, hermIdem_coe_eq_single]
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.single_mul_single_same]
  rw [Matrix.single_mul_single_of_ne (h := hij),
    Matrix.single_mul_single_of_ne (h := Ne.symm hij),
    Matrix.single_mul_single_of_ne (h := hij),
    Matrix.single_mul_single_of_ne (h := Ne.symm hij)]
  rw [cstar_one, mul_one, one_mul, mul_one, one_mul]
  have hsum : a + cstar a = (2 * ip a 1) • (1 : C) := by
    rw [cstar_apply]; abel
  rw [zero_add, add_zero, zero_add, add_zero]
  rw [show Matrix.single j j (cstar a) + Matrix.single i i a
      + (Matrix.single j j a + Matrix.single i i (cstar a))
      = Matrix.single i i (a + cstar a) + Matrix.single j j (a + cstar a) from by
    rw [Matrix.single_add, Matrix.single_add]; abel]
  rw [hsum, ← Matrix.smul_single, ← Matrix.smul_single, ← smul_add, smul_smul]
  congr 1
  ring

/-- ★★★ **The block coordinate of `dχ` is `(rᵢ−rⱼ)·(γ · —)` for a single CENTRAL `γ`.** -/
theorem exists_central_blockCoord (hn : 3 ≤ n) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) C)) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) C)) {i j : Fin n} (hij : i ≠ j),
      ∃ γ : C, (∀ x : C, γ * x = x * γ) ∧
        ∀ (r : Fin n → ℝ) (x : C),
          blockCoord (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap hij x
            = (r i - r j) • (γ * x) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
  classical
  intro P hS2 harch i j hij
  -- the derivation data
  have hD : ∀ (r : Fin n → ℝ) (A B : HermMat (Fin n) C),
      (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap (A * B)
        = (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap A * B
          + A * (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap B :=
    fun r => dChi_jordanDeriv (hermFrame (C := C) n) P hS2 harch r
  have hfix : ∀ (r : Fin n → ℝ) (k : Fin n),
      (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap (hermIdem k) = 0 :=
    fun r k => dChi_frameProj (hermFrame (C := C) n) P hS2 harch r k
  -- row 17 in coordinates, for an arbitrary pair
  have hsmul : ∀ {a b : Fin n} (hab : a ≠ b), ∃ tc : C →ₗ[ℝ] C, ∀ (r : Fin n → ℝ) (x : C),
      blockCoord (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap hab x
        = (r a - r b) • tc x := by
    intro a b hab
    obtain ⟨T, hT⟩ := exists_smul_of_vanishing_on_diag hab
      ({ toFun := fun r => blockCoordₗ
            (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap hab
         map_add' := by
           intro r s
           refine LinearMap.ext fun x => ?_
           simp only [blockCoordₗ_apply, blockCoord, LinearMap.add_apply,
             dChi_add (hermFrame (C := C) n) P hS2 harch r s]
           rfl
         map_smul' := by
           intro c r
           refine LinearMap.ext fun x => ?_
           simp only [blockCoordₗ_apply, blockCoord, RingHom.id_apply, LinearMap.smul_apply,
             dChi_smul (hermFrame (C := C) n) P hS2 harch c r]
           rfl } : (Fin n → ℝ) →ₗ[ℝ] (C →ₗ[ℝ] C))
      (by
        intro r hr
        refine LinearMap.ext fun x => ?_
        show blockCoord (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap hab x = 0
        have hz : (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap (hermOff hab x) = 0 :=
          dChi_apply_eq_zero_of_eq (hermFrame (C := C) n) P hS2 harch r hab hr
            (hermOff_mem_frameBlock hab x)
        rw [blockCoord, hz]
        simp)
    refine ⟨T, fun r x => ?_⟩
    have h := congrArg (fun f : C →ₗ[ℝ] C => f x) (hT r)
    simpa using h
  obtain ⟨k, hki, hkj⟩ := exists_third (i := i) (j := j) hn
  obtain ⟨tij, htij⟩ := hsmul hij
  obtain ⟨tik, htik⟩ := hsmul (Ne.symm hki)
  obtain ⟨tkj, htkj⟩ := hsmul hkj
  have hrel : ∀ (r : Fin n → ℝ) (x y : C),
      (r i - r j) • tij (x * y)
        = ((r i - r k) • tik x) * y + x * ((r k - r j) • tkj y) := by
    intro r x y
    have h := blockCoord_mul (D := (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap)
      (hD r) (hfix r) (Ne.symm hki) hkj hij x y
    rw [htij r (x * y), htik r x, htkj r y] at h
    exact h
  have halpha : ∀ x y : C, tij (x * y) = tik x * y := by
    intro x y
    have h := hrel (Pi.single i 1) x y
    simp only [Pi.single_apply, if_neg (Ne.symm hij), if_neg hki, sub_zero,
      sub_self, zero_smul, mul_zero, add_zero] at h
    simpa using h
  have hbeta : ∀ x y : C, tij (x * y) = x * tkj y := by
    intro x y
    have h := hrel (Pi.single j 1) x y
    simp only [Pi.single_apply, if_neg hij, if_neg hkj, zero_sub,
      sub_self, zero_smul, zero_mul, zero_add] at h
    simpa using h
  have h1 : ∀ z : C, tij z = tik 1 * z := fun z => by simpa using halpha 1 z
  have h2 : ∀ z : C, tij z = z * tkj 1 := fun z => by simpa using hbeta z 1
  have h3 : tik 1 = tkj 1 := by
    have e1 := h1 1
    have e2 := h2 1
    rw [mul_one] at e1
    rw [one_mul] at e2
    rw [← e1, e2]
  refine ⟨tik 1, ?_, ?_⟩
  · intro x
    rw [← h1 x, h2 x, h3]
  · intro r x
    rw [htij r x]
    congr 1
    exact h1 x

/-- ★★★ **`γ` is imaginary.**  Two elements of `V_{ij}` multiply into `ℝpᵢ ⊕ ℝpⱼ`, where `dχ(r)`
vanishes because it annihilates the frame atoms; the derivation property then reads off
`ip γ 1 = 0`.  ★ Note this uses **no** inner product on the block and no skewness — only that
`dχ(r)` is a frame-fixing derivation. -/
theorem central_blockCoord_im (hn : 3 ≤ n) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) C)) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) C)) {i j : Fin n} (hij : i ≠ j)
      (γ : C),
      (∀ (r : Fin n → ℝ) (x : C),
        blockCoord (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap hij x
          = (r i - r j) • (γ * x)) → ip γ 1 = 0 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
  classical
  intro P hS2 harch i j hij γ hcoord
  set r : Fin n → ℝ := Pi.single i 1 with hrdef
  have hri : r i - r j = 1 := by
    rw [hrdef, Pi.single_eq_same, Pi.single_eq_of_ne (Ne.symm hij), sub_zero]
  set x : HermMat (Fin n) C := hermOff hij 1 with hxdef
  have hDx : (dChi (hermFrame (C := C) n) P hS2 harch r) x = hermOff hij γ := by
    have h := map_hermOff (D := (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap)
      (fun A B => dChi_jordanDeriv (hermFrame (C := C) n) P hS2 harch r A B)
      (fun k => dChi_frameProj (hermFrame (C := C) n) P hS2 harch r k) hij 1
    rw [hcoord r 1, hri, one_smul, mul_one] at h
    exact h
  have hxx : x * x = (hermIdem i : HermMat (Fin n) C) + hermIdem j := by
    rw [hxdef, hermOff_mul_hermOff_one hij 1, ip_one_one, one_smul]
  have hDi : (dChi (hermFrame (C := C) n) P hS2 harch r) (hermIdem i : HermMat (Fin n) C) = 0 :=
    dChi_frameProj (hermFrame (C := C) n) P hS2 harch r i
  have hDj : (dChi (hermFrame (C := C) n) P hS2 harch r) (hermIdem j : HermMat (Fin n) C) = 0 :=
    dChi_frameProj (hermFrame (C := C) n) P hS2 harch r j
  have hDdiag : (dChi (hermFrame (C := C) n) P hS2 harch r)
      ((hermIdem i : HermMat (Fin n) C) + hermIdem j) = 0 := by
    rw [map_add, hDi, hDj, add_zero]
  have hderiv := dChi_jordanDeriv (hermFrame (C := C) n) P hS2 harch r x x
  rw [hxx, hDdiag, hDx] at hderiv
  have hcomm : (hermOff hij γ : HermMat (Fin n) C) * x = x * hermOff hij γ :=
    EuclideanJordanAlgebra.mul_comm _ _
  rw [← hcomm] at hderiv
  have htwo : (2 : ℝ) • ((hermOff hij γ : HermMat (Fin n) C) * x) = 0 := by
    rw [two_smul]
    exact hderiv.symm
  have hprod : (hermOff hij γ : HermMat (Fin n) C) * x = 0 := by
    rcases smul_eq_zero.mp htwo with h | h
    · exact absurd h (by norm_num)
    · exact h
  rw [hxdef, hermOff_mul_hermOff_one hij γ] at hprod
  have hne : ((hermIdem i : HermMat (Fin n) C) + hermIdem j) ≠ 0 := by
    intro h
    have h1 := congrArg
      (fun A : HermMat (Fin n) C => (A : Matrix (Fin n) (Fin n) C) i i) h
    rw [Submodule.coe_add, Matrix.add_apply, hermIdem_coe_eq_single, hermIdem_coe_eq_single,
      Matrix.single_apply, Matrix.single_apply, if_pos ⟨rfl, rfl⟩,
      if_neg (fun hh : j = i ∧ j = i => hij hh.1.symm), add_zero,
      ZeroMemClass.coe_zero, Matrix.zero_apply] at h1
    exact one_ne_zero h1
  rcases smul_eq_zero.mp hprod with h | h
  · exact h
  · exact absurd h hne

/-- ★★★ **`dχ(r) = 0` whenever the coefficient algebra has no nonzero central imaginary
element.**  This is the whole of `thm:real` and `thm:quaternionic` at the level of the twist: the
only type-specific input is `hZ`, and for `ℝ` and `ℍ` it is `Z(C) ∩ Im C = 0`. -/
theorem dChi_eq_zero_of_center_im_trivial (hn : 3 ≤ n)
    (hZ : ∀ γ : C, (∀ x : C, γ * x = x * γ) → ip γ 1 = 0 → γ = 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) C)) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) C)) (r : Fin n → ℝ),
      dChi (hermFrame (C := C) n) P hS2 harch r = 0 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
  classical
  intro P hS2 harch r
  have hoff : ∀ {i j : Fin n} (hij : i ≠ j) (x : C),
      (dChi (hermFrame (C := C) n) P hS2 harch r) (hermOff hij x) = 0 := by
    intro i j hij x
    obtain ⟨γ, hcentral, hcoord⟩ := exists_central_blockCoord hn P hS2 harch hij
    have hzero : γ = 0 :=
      hZ γ hcentral (central_blockCoord_im hn P hS2 harch hij γ hcoord)
    have h := map_hermOff (D := (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap)
      (fun X Y => dChi_jordanDeriv (hermFrame (C := C) n) P hS2 harch r X Y)
      (fun k => dChi_frameProj (hermFrame (C := C) n) P hS2 harch r k) hij x
    rw [hcoord r x, hzero, zero_mul, smul_zero] at h
    have h2 : (dChi (hermFrame (C := C) n) P hS2 harch r) (hermOff hij x)
        = (hermOff hij (0 : C) : HermMat (Fin n) C) := h
    rw [h2]
    apply Subtype.ext
    rw [hermOff_coe]
    simp
  have hker : ∀ s : Sym2 (Fin n),
      frameBlock (hermFrame (C := C) n) s
        ≤ LinearMap.ker (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap := by
    refine Sym2.ind fun i j => ?_
    intro A hA
    rw [frameBlock_mk] at hA
    rcases eq_or_ne i j with rfl | hij
    · have hA' : (hermIdem i : HermMat (Fin n) C) * A = A := mem_frameBlockRaw_diag.mp hA
      have hpi : (dChi (hermFrame (C := C) n) P hS2 harch r)
          (hermIdem i : HermMat (Fin n) C) = 0 :=
        dChi_frameProj (hermFrame (C := C) n) P hS2 harch r i
      show (dChi (hermFrame (C := C) n) P hS2 harch r) A = 0
      rw [eq_smul_hermIdem_of_peirceOne hA', map_smul, hpi, smul_zero]
    · show (dChi (hermFrame (C := C) n) P hS2 harch r) A = 0
      rw [eq_hermOff_of_mem_frameBlock hij hA]
      exact hoff hij _
  have htop : (⊤ : Submodule ℝ (HermMat (Fin n) C))
      ≤ LinearMap.ker (dChi (hermFrame (C := C) n) P hS2 harch r).toLinearMap := by
    rw [← frameBlock_iSup_eq_top (hermFrame (C := C) n)]
    exact iSup_le hker
  refine ContinuousLinearMap.ext fun z => ?_
  have hz := htop (Submodule.mem_top (x := z))
  simpa using hz

/-- ★★★ **`Θ_r = id`** on `H_n(C)` for such a `C` — the Lüders conclusion. -/
theorem twistTheta_id_of_center_im_trivial (hn : 3 ≤ n)
    (hZ : ∀ γ : C, (∀ x : C, γ * x = x * γ) → ip γ 1 = 0 → γ = 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
      jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
    ∀ (P : SequentialProductOn (HermMat (Fin n) C)) (hS2 : P.FirstArgContinuous)
      (harch : OrderUnitSpace.IsArchimedean (HermMat (Fin n) C)) (r : Fin n → ℝ)
      (hr : ∀ k, r k ≤ 0) (z : HermMat (Fin n) C),
      twistTheta (hermFrame (C := C) n) P hS2 harch r hr z = z := by
  letI := orderUnitSpaceOfBilinear (jmulₗ (HermMat (Fin n) C))
    jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal (1 : HermMat (Fin n) C) jmulₗ_one_mul
  intro P hS2 harch r hr z
  exact twistTheta_eq_one_of_dChi_eq_zero (hermFrame (C := C) n) P hS2 harch r hr
    (dChi_eq_zero_of_center_im_trivial hn hZ P hS2 harch r) z

end Central

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
