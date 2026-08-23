/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Composition.Classification

set_option linter.style.longLine false

/-!
# `H(ι, C)`: hermitian matrices over a composition algebra

The carrier `H_n(C)` that Jacobson coordinatization needs on its right-hand side, built for an
arbitrary Euclidean composition algebra `C` and an arbitrary finite index type, together with the
symmetrised product `A ∘ B = ½(AB + BA)`.

This is residue (1) of `WallCertificates/jacobson-coordinatization.lean`.  **It is a carrier
construction, not a proof of the coordinatization theorem**, and it is deliberately not an
attempt at residue (2) (Jordan ideals) or residue (3) (`n ≥ 4 ⟹ the coordinate algebra is
associative).

## Why the vendored `HermitianMat` could not be reused

The four `variable` lines of `RadicalRelativity/Vendor/HermitianMat/Jordan.lean` (26, 91, 126,
147) put the whole file over `[Field 𝕜] [StarRing 𝕜]`, and its last section over `[RCLike 𝕜]`;
the symmetrised product enters at line 94 as a `CommMagma` instance inside the section headed by
line 91.  A composition algebra is not a field, not commutative, and not associative, so no
declaration in that directory applies.  Nor is the hermitian predicate reusable: `Matrix.IsHermitian` is
`Aᴴ = A`, and `Matrix.conjTranspose` needs a `Star` instance, which `CompositionAlgebra`
does not carry — `cstar` (`Composition/Defs.lean:174`) is a plain `def`.  So the hermitian
condition is written entrywise here, exactly as the certificate's gap statement writes it.

What is genuinely cheap is the ambient: Mathlib's `Mul (Matrix n n α)`
(`Mathlib/Data/Matrix/Mul.lean:302`) needs only `[Fintype n]`, `[Mul α]` and `[AddCommMonoid α]`
on the coefficients, so a `NonAssocRing` coefficient type already multiplies.  The certificate's
"cheap carrier / absent API" split is confirmed.

## The generality of each result, stated

Three different hypothesis bundles appear below, and they are not interchangeable.

* **`C` any composition algebra.**  The submodule `HermMat ι C`, closure of the symmetrised
  product, its bilinearity, its commutativity, and the fact that a hermitian matrix's diagonal
  entries lie in `ℝ ∙ 1`.
* **`C` any composition algebra, `Nontrivial`; `ι` finite with `DecidableEq`.**  The unit
  `1 ∈ HermMat ι C`, the diagonal frame `hermIdem i`, its multiplication table
  (`hermIdem_jmul_self`, `hermIdem_jmul_of_ne`, `sum_hermIdem`), and the off-diagonal elements
  `hermOff hij x` with their injectivity and their Peirce-`½` relation `hermIdem_jmul_hermOff`.
* **`C` associative** (`[Ring C]`, which over the Hurwitz list means `ℝ`, `ℂ`, `ℍ` and *not*
  `𝕆`).  The **Jordan identity** `(A ∘ B) ∘ (A ∘ A) = A ∘ (B ∘ (A ∘ A))`, at every finite index
  type — and, through `jmul_jordan_of_isCompIso`, for every `C` merely *isomorphic* to such a
  `D`, which is the shape `CoordAlg.classification_coordAlg` hands out.

★ **`HermMat ι C` is NOT claimed to be a Jordan algebra for general `C`.**  Classically
(Jacobson) `H_n(𝕆)` is a Jordan algebra exactly for `n ≤ 3`, and the `n ≥ 4` failure is what
residue (3) of the certificate is about — but that is a citation, not a theorem of this tree:
**nothing here proves either half of it**, neither the `n ≤ 3` octonionic case nor the `n ≥ 4`
failure.  ★ **Narrowed 2026-08-23** as to the first half only: `EJA/AlbertBridge.lean` —
downstream of this file, so invisible from here — proves the Jordan identity on
`HermMat (Fin 3) C` for every finite-dimensional Euclidean composition algebra `C`, `𝕆`
included, by transporting `Albert/Jordan.lean`'s coordinate computation across a linear
equivalence with `h3O`.  That is the single rank `n = 3`; `n = 1`, `n = 2` and the `n ≥ 4`
failure are all still unproved here and there.
Nothing here installs a `Mul` instance either: as in `Albert/Mul.lean`, the product is bundled as a bilinear map
`hermBilin`, because a `Mul` instance alongside a future `NormedAddCommGroup` would reintroduce
the diamond `EJA/Bridge.lean` exists to dodge.

## Relation to `Albert/`

`Albert/Carrier.lean`'s `h3O` is a *different type*: a structure with fields
`diag : Fin 3 → ℝ` and `off : Fin 3 → Octonion`, i.e. the 27 real coordinates of a hermitian
`3 × 3` octonionic matrix rather than the 9 octonionic matrix entries, with the product
`Albert/Mul.lean`'s `jordanMul` written out in those coordinates.  `HermMat (Fin 3) Octonion`
is *intended* to be the same algebra presented as an actual submodule of
`Matrix (Fin 3) (Fin 3) Octonion` — but **that is a design intention, not a theorem here**: no
linear map between the two types is constructed *in this file*, so nothing below says `jordanMul`
agrees with the symmetrised matrix product under any identification.  None of `Albert/` is
touched or subsumed; `Albert/Jordan.lean`'s Jordan identity for `h3O` is a theorem this file
cannot reach, because the associative section below excludes `Octonion` by hypothesis.

★ **Narrowed 2026-08-23.**  This paragraph used to say that no linear map between the two types
is constructed *anywhere in the tree*, and that is now false.  `EJA/AlbertBridge.lean` — which
imports this file, so it is invisible from here — constructs `toHermMat : h3O ≃ₗ[ℝ] HermMat (Fin
3) Octonion` and proves `toHermMat_jordanMul`, that it intertwines the two products; the design
intention is discharged at `(Fin 3, 𝕆)`.  Everything in *this* file is unchanged by that: the
sentences above describe this file's contents and remain exact.

## Main definitions

* `CompositionAlgebra.cstarLm` — conjugation bundled as an `ℝ`-linear map
* `CompositionAlgebra.IsHerm` — the entrywise hermitian predicate
* `CompositionAlgebra.HermMat` — `H_ι(C)`, as a `Submodule ℝ (Matrix ι ι C)`
* `CompositionAlgebra.jmul` / `hermBilin` — the symmetrised product, bare and bundled
* `CompositionAlgebra.hermIdem` / `hermOff` — the diagonal frame and the off-diagonal elements
* `CompositionAlgebra.hermCongr` — the transport map along `IsCompIso`

## Main results

* `CompositionAlgebra.symmMul_mem` — the symmetrised product of two hermitians is hermitian
* `CompositionAlgebra.diag_eq_smul_one` — the diagonal of a hermitian matrix is real
* `CompositionAlgebra.hermIdem_jmul_self`, `hermIdem_jmul_of_ne`, `sum_hermIdem` — the frame
* `CompositionAlgebra.hermIdem_jmul_hermOff` — `pᵢ ∘ x_{ij} = ½ x_{ij}`
* `CompositionAlgebra.hermOff_injective` — the block at `(i, j)` carries a copy of `C`
* `CompositionAlgebra.jmul_jordan_of_assoc` — the Jordan identity, for associative `C`
* `CompositionAlgebra.jmul_jordan_of_isCompIso` — the same, for `C` isomorphic to an associative
  composition algebra, which is what the classification supplies
* `CompositionAlgebra.hermCongr_jmul` — the transport intertwines the two products

## Scope

**No manifest row moves.**  This file is substrate.
-/

noncomputable section

universe u v w

namespace CompositionAlgebra

/-! ## Conjugation as a linear map -/

section Conj

variable {C : Type u} [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C]
  [CompositionAlgebra C]

/-- Conjugation `x ↦ x*`, bundled as an `ℝ`-linear map.  Needed because the hermitian condition
is a statement about finite sums of products and `map_sum` wants a bundled map. -/
def cstarLm : C →ₗ[ℝ] C where
  toFun := cstar
  map_add' := cstar_add
  map_smul' := cstar_smul

@[simp] theorem cstarLm_apply (x : C) : cstarLm x = cstar x := rfl

theorem cstar_sum {ι : Type w} (s : Finset ι) (f : ι → C) :
    cstar (∑ k ∈ s, f k) = ∑ k ∈ s, cstar (f k) :=
  map_sum cstarLm f s

/-- A `cstar`-fixed element is a real multiple of the unit.  This is why the entrywise hermitian
condition needs no separate "the diagonal is real" clause: the `i = j` instance already says it.
-/
theorem eq_smul_one_of_cstar_eq_self {x : C} (h : cstar x = x) : x = ip x 1 • (1 : C) := by
  have h1 : (2 * ip x 1) • (1 : C) - x = x := by rw [← cstar_apply]; exact h
  have h2 : (2 : ℝ) • (ip x 1 • (1 : C)) = (2 : ℝ) • x := by
    rw [smul_smul, sub_eq_iff_eq_add.mp h1, two_smul]
  have e : ∀ z : C, (2 : ℝ)⁻¹ • ((2 : ℝ) • z) = z := by
    intro z
    rw [smul_smul, inv_mul_cancel₀ (by norm_num : (2 : ℝ) ≠ 0), one_smul]
  have h3 : ip x 1 • (1 : C) = x := by rw [← e (ip x 1 • (1 : C)), h2, e]
  exact h3.symm

/-- Conversely, every real multiple of the unit is `cstar`-fixed. -/
theorem cstar_smul_one [Nontrivial C] (r : ℝ) : cstar (r • (1 : C)) = r • (1 : C) := by
  rw [cstar_smul, cstar_one]

end Conj

/-! ## The carrier -/

section Carrier

variable {ι : Type v} {C : Type u} [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C]
  [SMulCommClass ℝ C C] [CompositionAlgebra C]

/-- The **entrywise hermitian** condition `A j i = (A i j)*`.  Written out rather than as
`Matrix.IsHermitian` because `CompositionAlgebra` carries no `Star` instance and hence
`Matrix.conjTranspose` is unavailable. -/
def IsHerm (A : Matrix ι ι C) : Prop := ∀ i j, A j i = cstar (A i j)

/-- **`H_ι(C)`**: the hermitian `ι × ι` matrices over the composition algebra `C`, as an
`ℝ`-submodule of `Matrix ι ι C`.  Taking a `Submodule` rather than a bare structure is what
supplies the `AddCommGroup` and `Module ℝ` structure, and `≃ₗ[ℝ]` statements against it, for
free. -/
def HermMat (ι : Type v) (C : Type u) [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C]
    [SMulCommClass ℝ C C] [CompositionAlgebra C] : Submodule ℝ (Matrix ι ι C) where
  carrier := {A | IsHerm A}
  add_mem' := by
    intro A B hA hB i j
    simp only [Matrix.add_apply, cstar_add]
    rw [hA i j, hB i j]
  zero_mem' := by intro i j; simp
  smul_mem' := by
    intro r A hA i j
    simp only [Matrix.smul_apply, cstar_smul]
    rw [hA i j]

@[simp] theorem mem_hermMat {A : Matrix ι ι C} : A ∈ HermMat ι C ↔ ∀ i j, A j i = cstar (A i j) :=
  Iff.rfl

theorem herm_apply (A : HermMat ι C) (i j : ι) :
    (A : Matrix ι ι C) j i = cstar ((A : Matrix ι ι C) i j) := A.2 i j

/-- **The diagonal of a hermitian matrix is real.**  A consequence of the `i = j` instance of the
hermitian condition, not an extra axiom. -/
theorem diag_eq_smul_one (A : HermMat ι C) (i : ι) :
    (A : Matrix ι ι C) i i = ip ((A : Matrix ι ι C) i i) 1 • (1 : C) :=
  eq_smul_one_of_cstar_eq_self (A.2 i i).symm

/-- `H_ι(C)` is finite-dimensional whenever `ι` is finite and `C` is.  ★ This is `inferInstance`:
Mathlib's `Submodule.finiteDimensional` already supplies it from the ambient `Matrix ι ι C`, and
this declaration only gives it a name.  It is **not** a dimension count — see
`hermOff_injective` for the only non-degeneracy fact this file proves. -/
instance instFiniteDimensionalHermMat [Fintype ι] [FiniteDimensional ℝ C] :
    FiniteDimensional ℝ (HermMat ι C) :=
  inferInstance

end Carrier

/-! ## The symmetrised product -/

section Mul

variable {ι : Type v} [Fintype ι] {C : Type u} [NonAssocRing C] [Module ℝ C]
  [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C]

/-- **The closure step.**  The symmetrised product `½(AB + BA)` of two entrywise-hermitian
matrices is entrywise hermitian.  The proof is `(AB)ᵀ`-style bookkeeping through
`cstar_mul : (xy)* = y* x*`, which is where the *anti*-multiplicativity of conjugation is spent,
and it uses no associativity. -/
theorem symmMul_mem {A B : Matrix ι ι C} (hA : A ∈ HermMat ι C) (hB : B ∈ HermMat ι C) :
    (2 : ℝ)⁻¹ • (A * B + B * A) ∈ HermMat ι C := by
  intro i j
  have hA' : ∀ p q, A q p = cstar (A p q) := hA
  have hB' : ∀ p q, B q p = cstar (B p q) := hB
  simp only [Matrix.smul_apply, Matrix.add_apply, Matrix.mul_apply, cstar_smul, cstar_add,
    cstar_sum, cstar_mul, ← hA', ← hB']
  rw [add_comm]

/-- The **Jordan product** `A ∘ B = ½(AB + BA)` on `H_ι(C)`. -/
def jmul (A B : HermMat ι C) : HermMat ι C :=
  ⟨(2 : ℝ)⁻¹ • ((A : Matrix ι ι C) * B + (B : Matrix ι ι C) * A), symmMul_mem A.2 B.2⟩

@[simp] theorem jmul_coe (A B : HermMat ι C) :
    ((jmul A B : HermMat ι C) : Matrix ι ι C)
      = (2 : ℝ)⁻¹ • ((A : Matrix ι ι C) * B + (B : Matrix ι ι C) * A) := rfl

theorem jmul_comm (A B : HermMat ι C) : jmul A B = jmul B A := by
  apply Subtype.ext
  simp only [jmul_coe]
  rw [add_comm]

theorem jmul_add_left (A A' B : HermMat ι C) :
    jmul (A + A') B = jmul A B + jmul A' B := by
  apply Subtype.ext
  simp only [jmul_coe, Submodule.coe_add, add_mul, mul_add, smul_add]
  abel

theorem jmul_smul_left (r : ℝ) (A B : HermMat ι C) :
    jmul (r • A) B = r • jmul A B := by
  apply Subtype.ext
  simp only [jmul_coe, SetLike.val_smul, Matrix.smul_mul, Matrix.mul_smul, smul_add, smul_smul]
  rw [mul_comm]

theorem jmul_add_right (A B B' : HermMat ι C) :
    jmul A (B + B') = jmul A B + jmul A B' := by
  rw [jmul_comm, jmul_add_left, jmul_comm A B, jmul_comm A B']

theorem jmul_smul_right (r : ℝ) (A B : HermMat ι C) :
    jmul A (r • B) = r • jmul A B := by
  rw [jmul_comm, jmul_smul_left, jmul_comm]

/-- The Jordan product, bundled as an `ℝ`-bilinear map.  This is the shape the tree's interfaces
consume (`ComparisonSetup`, `EJA/Order.lean`'s `orderUnitSpaceOfBilinear`, and `Albert/Mul.lean`'s
`jordanBilinO`), and no `Mul` instance is installed — see the module docstring. -/
def hermBilin : HermMat ι C →ₗ[ℝ] HermMat ι C →ₗ[ℝ] HermMat ι C :=
  LinearMap.mk₂ ℝ jmul jmul_add_left jmul_smul_left jmul_add_right jmul_smul_right

@[simp] theorem hermBilin_apply (A B : HermMat ι C) : hermBilin A B = jmul A B := rfl

end Mul

/-! ## The unit and the diagonal frame -/

section Frame

variable {ι : Type v} [Fintype ι] [DecidableEq ι] {C : Type u} [NonAssocRing C] [Module ℝ C]
  [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C] [Nontrivial C]

theorem one_mem_hermMat : (1 : Matrix ι ι C) ∈ HermMat ι C := by
  intro i j
  simp only [Matrix.one_apply]
  by_cases h : j = i
  · subst h; simp
  · rw [if_neg h, if_neg (Ne.symm h), cstar_zero]

/-- The unit of `H_ι(C)`. -/
def hermOne : HermMat ι C := ⟨1, one_mem_hermMat⟩

@[simp] theorem hermOne_coe : ((hermOne : HermMat ι C) : Matrix ι ι C) = 1 := rfl

theorem jmul_hermOne_left (A : HermMat ι C) : jmul hermOne A = A := by
  apply Subtype.ext
  simp only [jmul_coe, hermOne_coe, one_mul, mul_one]
  rw [← two_smul ℝ ((A : Matrix ι ι C)), smul_smul]
  norm_num

theorem jmul_hermOne_right (A : HermMat ι C) : jmul A hermOne = A := by
  rw [jmul_comm]; exact jmul_hermOne_left A

/-- The `i`-th **diagonal matrix unit** `pᵢ`, an element of `H_ι(C)`. -/
def hermIdem (i : ι) : HermMat ι C :=
  ⟨Matrix.diagonal (fun k => if k = i then (1 : C) else 0), by
    intro a b
    simp only [Matrix.diagonal_apply]
    by_cases h : b = a
    · subst h
      split_ifs <;> simp
    · rw [if_neg h, if_neg (Ne.symm h), cstar_zero]⟩

@[simp] theorem hermIdem_coe (i : ι) :
    ((hermIdem i : HermMat ι C) : Matrix ι ι C)
      = Matrix.diagonal (fun k => if k = i then (1 : C) else 0) := rfl

theorem hermIdem_jmul_self (i : ι) : jmul (hermIdem i) (hermIdem (C := C) i) = hermIdem i := by
  apply Subtype.ext
  have hd : (Matrix.diagonal fun k => (if k = i then (1 : C) else 0) * (if k = i then (1 : C) else 0))
      = Matrix.diagonal (fun k => if k = i then (1 : C) else 0) := by
    congr 1
    funext k
    split_ifs
    · rw [one_mul]
    · rw [zero_mul]
  simp only [jmul_coe, hermIdem_coe, Matrix.diagonal_mul_diagonal, hd]
  rw [← two_smul ℝ (Matrix.diagonal fun k => if k = i then (1 : C) else 0), smul_smul,
    inv_mul_cancel₀ (by norm_num : (2 : ℝ) ≠ 0), one_smul]

theorem hermIdem_jmul_of_ne {i j : ι} (hij : i ≠ j) :
    jmul (hermIdem i) (hermIdem (C := C) j) = 0 := by
  apply Subtype.ext
  have h1 : (Matrix.diagonal fun k => (if k = i then (1 : C) else 0) * (if k = j then 1 else 0))
      = 0 := by
    rw [← Matrix.diagonal_zero (n := ι) (α := C)]
    congr 1
    funext k
    by_cases hk : k = i
    · subst hk; rw [if_neg hij, mul_zero]
    · rw [if_neg hk, zero_mul]
  have h2 : (Matrix.diagonal fun k => (if k = j then (1 : C) else 0) * (if k = i then 1 else 0))
      = 0 := by
    rw [← Matrix.diagonal_zero (n := ι) (α := C)]
    congr 1
    funext k
    by_cases hk : k = j
    · subst hk; rw [if_neg (Ne.symm hij), mul_zero]
    · rw [if_neg hk, zero_mul]
  simp only [jmul_coe, hermIdem_coe, Matrix.diagonal_mul_diagonal, ZeroMemClass.coe_zero, h1, h2]
  rw [add_zero, smul_zero]

theorem sum_hermIdem : ∑ i : ι, (hermIdem i : HermMat ι C) = hermOne := by
  apply Subtype.ext
  rw [Submodule.coe_sum]
  ext a b
  simp only [hermIdem_coe, hermOne_coe, Matrix.sum_apply, Matrix.diagonal_apply, Matrix.one_apply]
  by_cases h : a = b
  · subst h; simp
  · simp [h]

/-- The **off-diagonal element** `x` at `(i, j)` and `x*` at `(j, i)`, an element of `H_ι(C)`
for every `i ≠ j`.  These are the entries of the coordinate blocks `V_{ij}`. -/
def hermOff {i j : ι} (hij : i ≠ j) (x : C) : HermMat ι C :=
  ⟨Matrix.single i j x + Matrix.single j i (cstar x), by
    intro a b
    simp only [Matrix.add_apply, Matrix.single_apply, cstar_add, cstar_cstar, cstar_zero,
      add_zero, zero_add]
    split_ifs <;> simp_all⟩

@[simp] theorem hermOff_coe {i j : ι} (hij : i ≠ j) (x : C) :
    ((hermOff hij x : HermMat ι C) : Matrix ι ι C)
      = Matrix.single i j x + Matrix.single j i (cstar x) := rfl

@[simp] theorem hermOff_apply {i j : ι} (hij : i ≠ j) (x : C) :
    ((hermOff hij x : HermMat ι C) : Matrix ι ι C) i j = x := by
  simp [hermOff_coe, Matrix.single_apply, hij, Ne.symm hij]

/-- The off-diagonal elements at a fixed pair are pairwise distinct, so the block `V_{ij}` really
carries a copy of `C`.  This is the only non-degeneracy fact proved about `HermMat`: no basis and
no dimension count is constructed anywhere in this file. -/
theorem hermOff_injective {i j : ι} (hij : i ≠ j) :
    Function.Injective (fun x : C => (hermOff hij x : HermMat ι C)) := by
  intro x y h
  have h2 := congrArg (fun A : HermMat ι C => (A : Matrix ι ι C) i j) h
  simpa using h2

/-- **The Peirce-`½` relation.**  `pᵢ ∘ x_{ij} = ½ x_{ij}`: the off-diagonal elements at `(i, j)`
sit in the `½`-eigenspace of multiplication by `pᵢ`, which is what makes them the block `V_{ij}`
of the diagonal frame.  Proved with no associativity: the two matrix products each collapse to a
single `Matrix.single`. -/
theorem hermIdem_jmul_hermOff {i j : ι} (hij : i ≠ j) (x : C) :
    jmul (hermIdem i) (hermOff hij x) = (2 : ℝ)⁻¹ • hermOff hij x := by
  apply Subtype.ext
  have key : (Matrix.diagonal (fun k => if k = i then (1 : C) else 0))
        * (Matrix.single i j x + Matrix.single j i (cstar x))
      + (Matrix.single i j x + Matrix.single j i (cstar x))
        * (Matrix.diagonal (fun k => if k = i then (1 : C) else 0))
      = Matrix.single i j x + Matrix.single j i (cstar x) := by
    ext a b
    simp only [Matrix.add_apply, Matrix.diagonal_mul, Matrix.mul_diagonal, Matrix.single_apply]
    by_cases h1 : i = a ∧ j = b
    · obtain ⟨rfl, rfl⟩ := h1
      simp [hij, Ne.symm hij]
    · by_cases h2 : j = a ∧ i = b
      · obtain ⟨rfl, rfl⟩ := h2
        simp [hij, Ne.symm hij]
      · simp [h1, h2]
  simp only [jmul_coe, SetLike.val_smul, hermIdem_coe, hermOff_coe, key]

end Frame

/-! ## The Jordan identity, for associative coefficients

`[Ring C]` on top of the composition-algebra hypotheses says exactly that `C` is an *associative*
composition algebra.  Over the Hurwitz list that is `ℝ`, `ℂ` and `ℍ`, and **not** `𝕆`: this
section is silent about the octonionic case at every rank, including rank three, where the
identity is nevertheless true and is proved by hand in `Albert/Jordan.lean`. -/

section Assoc

variable {ι : Type v} [Fintype ι] {C : Type u} [Ring C] [Module ℝ C]
  [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C]

/-- **The Jordan identity** `(A ∘ B) ∘ (A ∘ A) = A ∘ (B ∘ (A ∘ A))` on `H_ι(C)`, for `C` an
associative composition algebra and `ι` any finite index type.

Proved by expanding both sides in the ambient matrix ring, where associativity is available;
this is the same argument the vendored `HermitianMat` layer runs over a field, freed of the
field hypothesis but *not* of the associativity hypothesis. -/
theorem jmul_jordan_of_assoc (A B : HermMat ι C) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) := by
  apply Subtype.ext
  simp only [jmul_coe, smul_add, Matrix.mul_smul, Matrix.smul_mul, mul_add, add_mul, smul_smul,
    Matrix.mul_assoc]
  abel

end Assoc

/-! ## Transport along an isomorphism of composition algebras -/

section Transport

variable {C : Type u} [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C]
  [CompositionAlgebra C]
variable {D : Type w} [NonAssocRing D] [Module ℝ D] [IsScalarTower ℝ D D] [SMulCommClass ℝ D D]
  [CompositionAlgebra D]

/-- An isomorphism of composition algebras preserves the form.  Polarisation of `map_nf`; the
`CompEmb` version is `CompEmb.map_ip`, and this is the `IsCompIso` one. -/
theorem IsCompIso.map_ip {f : C ≃ₗ[ℝ] D} (hf : IsCompIso f) (x y : C) :
    ip (f x) (f y) = ip x y := by
  have h := hf.map_nf (x + y)
  rw [map_add, nf_add, nf_add, hf.map_nf x, hf.map_nf y] at h
  linarith

/-- An isomorphism of composition algebras commutes with conjugation. -/
theorem IsCompIso.map_cstar {f : C ≃ₗ[ℝ] D} (hf : IsCompIso f) (x : C) :
    f (cstar x) = cstar (f x) := by
  rw [cstar_apply, cstar_apply, map_sub, map_smul, hf.map_one]
  congr 2
  rw [← hf.map_one, hf.map_ip]

variable {ι : Type v} [Fintype ι]

/-- **Transport.**  An isomorphism `C ≃ D` of composition algebras induces a linear isomorphism
`H_ι(C) ≃ H_ι(D)` intertwining the two symmetrised products.  This is the step the coordinate
algebra's classification (`CoordAlg.classification_coordAlg`) has to be pushed along: it
identifies the coordinate algebra with one of `ℝ`, `ℂ`, `ℍ`, `𝕆`, and this carries `H_n` of the
one to `H_n` of the other. -/
def hermCongr {f : C ≃ₗ[ℝ] D} (hf : IsCompIso f) : HermMat ι C ≃ₗ[ℝ] HermMat ι D where
  toFun A := ⟨(A : Matrix ι ι C).map f, by
    intro i j
    simp only [Matrix.map_apply]
    rw [A.2 i j, hf.map_cstar]⟩
  map_add' A B := by apply Subtype.ext; ext i j; simp [Matrix.map_apply]
  map_smul' r A := by apply Subtype.ext; ext i j; simp [Matrix.map_apply]
  invFun A := ⟨(A : Matrix ι ι D).map f.symm, by
    intro i j
    simp only [Matrix.map_apply]
    rw [A.2 i j, ← hf.symm.map_cstar]⟩
  left_inv A := by apply Subtype.ext; ext i j; simp [Matrix.map_apply]
  right_inv A := by apply Subtype.ext; ext i j; simp [Matrix.map_apply]

@[simp] theorem hermCongr_coe {f : C ≃ₗ[ℝ] D} (hf : IsCompIso f) (A : HermMat ι C) :
    ((hermCongr (ι := ι) hf A : HermMat ι D) : Matrix ι ι D) = (A : Matrix ι ι C).map f := rfl

theorem hermCongr_jmul {f : C ≃ₗ[ℝ] D} (hf : IsCompIso f) (A B : HermMat ι C) :
    hermCongr (ι := ι) hf (jmul A B) = jmul (hermCongr hf A) (hermCongr hf B) := by
  apply Subtype.ext
  ext i j
  simp only [hermCongr_coe, jmul_coe, Matrix.map_apply, Matrix.smul_apply, Matrix.add_apply,
    Matrix.mul_apply, map_smul, map_add, map_sum, hf.map_mul]

/-- **The Jordan identity, transported.**  If `C` is merely *isomorphic* to an associative
composition algebra `D` — which is the form `EJA/Coordinatize.lean`'s
`CoordAlg.classification_coordAlg` delivers, `∃ f : CoordAlg D ≃ₗ[ℝ] ℝ / ℂ / ℍ / 𝕆` together with
`IsCompIso f` — then `H_ι(C)` satisfies the Jordan identity even though `C` itself carries only a
`NonAssocRing` instance and no `Ring` one.  Three of that theorem's four branches land here; the
fourth, `𝕆`, does not, and that is where residue (3) lives. -/
theorem jmul_jordan_of_isCompIso {D : Type w} [Ring D] [Module ℝ D] [IsScalarTower ℝ D D]
    [SMulCommClass ℝ D D] [CompositionAlgebra D] {f : C ≃ₗ[ℝ] D} (hf : IsCompIso f)
    (A B : HermMat ι C) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) := by
  apply (hermCongr (ι := ι) hf).injective
  simp only [hermCongr_jmul]
  exact jmul_jordan_of_assoc _ _

end Transport

/-! ## Non-vacuity: the construction instantiated at the Hurwitz algebras

`Composition/Instances.lean` supplies the four witnesses `ℝ`, `ℂ`, `ℍ` and `𝕆`, so the general
construction can be *instantiated* rather than merely stated.  Each theorem below is the general
result specialised and carries no new content; they exist so that a reader can see the type
elaborate at a named coefficient algebra.

★ What is **not** here: no dimension count.  `finrank ℝ (HermMat (Fin 3) Octonion) = 27` is not
proved, and no basis of `HermMat ι C` is constructed, so nothing below rules out the submodule
being smaller than intended.  ★ **Narrowed 2026-08-23** as to the first clause only:
`EJA/AlbertBridge.lean`'s `finrank_hermMat_octonion` proves `= 27`, by transporting
`h3O.finrank_eq_twentyseven` across the linear equivalence, not by exhibiting a basis.  No basis
of `HermMat ι C` is constructed anywhere, and no other `(ι, C)` is counted. -/

section Examples

open scoped Quaternion

/-- `H_3(𝕆)`, the Albert-size carrier, exists through this construction, and its diagonal frame
sums to the unit.  ★ This is the octonionic case at rank three: the Jordan identity for it is
**not** available here — `jmul_jordan_of_assoc` assumes associativity — and is the hand-built
`Albert/Jordan.lean` theorem about the different carrier `h3O`.  ★ Since 2026-08-23 it does
reach this carrier, through `EJA/AlbertBridge.lean`'s equivalence between the two; that file is
downstream of this one, so nothing here changes. -/
theorem albert_sum_hermIdem :
    ∑ i : Fin 3, (hermIdem i : HermMat (Fin 3) Octonion) = hermOne :=
  sum_hermIdem

/-- Every octonion gives an off-diagonal element of `H_3(𝕆)` in the `(0, 1)` block, and `p₀` acts
on it by `½`. -/
theorem albert_hermIdem_jmul_hermOff (x : Octonion) :
    jmul (hermIdem (0 : Fin 3)) (hermOff (show (0 : Fin 3) ≠ 1 by decide) x)
      = (2 : ℝ)⁻¹ • hermOff (show (0 : Fin 3) ≠ 1 by decide) x :=
  hermIdem_jmul_hermOff _ x

/-- **The Jordan identity on `H_n(ℝ)`**, every `n`. -/
theorem hermMat_real_jordan {n : ℕ} (A B : HermMat (Fin n) ℝ) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) :=
  jmul_jordan_of_assoc A B

/-- **The Jordan identity on `H_n(ℂ)`**, every `n`. -/
theorem hermMat_complex_jordan {n : ℕ} (A B : HermMat (Fin n) ℂ) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) :=
  jmul_jordan_of_assoc A B

/-- **The Jordan identity on `H_n(ℍ)`**, every `n` — including `n ≥ 4`, which is exactly where
the octonionic case fails and which is why this section's hypothesis is associativity of the
coefficients and not a bound on `n`. -/
theorem hermMat_quaternion_jordan {n : ℕ} (A B : HermMat (Fin n) ℍ[ℝ]) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) :=
  jmul_jordan_of_assoc A B

end Examples

end CompositionAlgebra
