/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.OctonionTrace
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

set_option linter.style.longLine false

/-!
# The Albert algebra: the carrier

The 27-dimensional real vector space `h₃(𝕆)` of hermitian `3 × 3` octonionic matrices,
carrying `AddCommGroup`, `Module ℝ`, and `FiniteDimensional ℝ` with `finrank = 27`.

This file builds **only the linear structure**.  The Jordan product is `Albert/Mul.lean`, the
trace form and the Euclidean hypothesis are `Albert/Inner.lean`, and the Jordan identity --
the gate onto the whole `EJA/` layer -- is not here and is not claimed anywhere in this
module set.

## Layout convention

An element is
```
[[a₁, x₃*, x₂ ],
 [x₃, a₂,  x₁*],
 [x₂*, x₁, a₃ ]]
```
so `diag : Fin 3 → ℝ` and `off : Fin 3 → Octonion` with `off 0 = (2,3)`, `off 1 = (1,3)`,
`off 2 = (1,2)`.  This is the convention of the older expository
`RadicalRelativity/Albert.lean`, kept deliberately so that file's frame lemmas transfer.

## Octonions as an `ℝ`-module

`RadicalRelativity/Octonions.lean` gives `Octonion` bare `Zero`/`Add`/`Neg`/`SMul ℝ`
instances and no algebraic classes at all.  The first section here supplies
`AddCommGroup Octonion`, `Module ℝ Octonion`, `FiniteDimensional ℝ Octonion`,
`finrank ℝ 𝕆 = 8`, linearity of conjugation, and the Euclidean form `octIp` that both
`Albert/Mul.lean` and `Albert/Inner.lean` are written over.
Every module data field is the pre-existing instance on the nose, so no `+`,
`•` or `0` in the octonion file changes meaning and its `@[simp]` coordinate lemmas keep
firing.  They live here rather than in `Octonions.lean` only to keep that file untouched;
moving them upstream is a pure relocation.

## Main definitions

* `Octonion.octIp` -- the Euclidean inner product on `𝕆`
* `Octonion.coordsEquiv` -- `𝕆 ≃ₗ[ℝ] (Fin 8 → ℝ)`
* `h3O` -- the carrier
* `h3O.equivProd` -- `h₃(𝕆) ≃ₗ[ℝ] (Fin 3 → ℝ) × (Fin 3 → 𝕆)`

## Main results

* `Octonion.octIp_eq_re` -- `⟨x, y⟩ = re (x ȳ)`, the bridge to `OctonionTrace.lean`
* `Octonion.re_three_cyc` -- cyclic invariance of `re ((x y) z)`
* `Octonion.octIp_conj_cyc` / `octIp_conj_cyc'` -- that invariance in `octIp` vocabulary
* `Octonion.finrank_eq_eight`
* `h3O.finrank_eq_twentyseven` -- `finrank ℝ h₃(𝕆) = 27`
-/

noncomputable section

/-! ## `Octonion` as an `ℝ`-module -/

namespace Octonion

instance instAddCommGroup : AddCommGroup Octonion where
  add := (· + ·)
  add_assoc a b c := by ext i; exact add_assoc _ _ _
  zero := 0
  nsmul := nsmulRec
  zsmul := zsmulRec
  zero_add a := by ext i; exact zero_add _
  add_zero a := by ext i; exact add_zero _
  neg := Neg.neg
  neg_add_cancel a := by ext i; exact neg_add_cancel _
  add_comm a b := by ext i; exact add_comm _ _

instance instModule : Module ℝ Octonion where
  smul := (· • ·)
  one_smul a := by ext i; exact one_mul _
  mul_smul r s a := by ext i; exact mul_assoc _ _ _
  smul_zero r := by ext i; exact mul_zero _
  smul_add r a b := by ext i; exact mul_add _ _ _
  add_smul r s a := by ext i; exact add_mul _ _ _
  zero_smul a := by ext i; exact zero_mul _

@[simp] theorem conj_zero : conj (0 : Octonion) = 0 := by
  ext i; simp only [conj, zero_coords]; split_ifs <;> simp

/-- Conjugation is additive. -/
@[simp] theorem conj_add (x y : Octonion) : conj (x + y) = conj x + conj y := by
  ext i; simp only [conj, add_coords]; split_ifs <;> ring

/-- Conjugation is `ℝ`-homogeneous; with `conj_add`, `conj` is `ℝ`-linear. -/
@[simp] theorem conj_smul (r : ℝ) (x : Octonion) : conj (r • x) = r • conj x := by
  ext i; simp only [conj, smul_coords]; split_ifs <;> ring

@[simp] theorem mul_zero' (x : Octonion) : mul x 0 = 0 := by
  ext i; fin_cases i <;> simp [mul]

@[simp] theorem zero_mul' (x : Octonion) : mul 0 x = 0 := by
  ext i; fin_cases i <;> simp [mul]

/-! ### The Euclidean inner product on `𝕆`

`octIp x y = ∑ᵢ xᵢ yᵢ` is the standard positive-definite form.  `octIp_eq_re` identifies it
with the trace form `re (x ȳ)` of `OctonionTrace.lean`, which is how the cyclic identities
there reach the Albert trace form in `Albert/Inner.lean`. -/

/-- The Euclidean inner product on the octonions. -/
def octIp (x y : Octonion) : ℝ := ∑ i, x.coords i * y.coords i

theorem octIp_comm (x y : Octonion) : octIp x y = octIp y x := by
  simp only [octIp]; exact Finset.sum_congr rfl fun i _ => mul_comm _ _

@[simp] theorem octIp_add_left (x y z : Octonion) :
    octIp (x + y) z = octIp x z + octIp y z := by
  simp only [octIp, add_coords, ← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

@[simp] theorem octIp_smul_left (r : ℝ) (x y : Octonion) :
    octIp (r • x) y = r * octIp x y := by
  simp only [octIp, smul_coords, Finset.mul_sum]
  exact Finset.sum_congr rfl fun i _ => by ring

@[simp] theorem octIp_add_right (x y z : Octonion) :
    octIp x (y + z) = octIp x y + octIp x z := by
  rw [octIp_comm, octIp_add_left, octIp_comm y x, octIp_comm z x]

@[simp] theorem octIp_smul_right (r : ℝ) (x y : Octonion) :
    octIp x (r • y) = r * octIp x y := by
  rw [octIp_comm, octIp_smul_left, octIp_comm y x]

@[simp] theorem octIp_zero_left (x : Octonion) : octIp 0 x = 0 := by simp [octIp]

@[simp] theorem octIp_zero_right (x : Octonion) : octIp x 0 = 0 := by simp [octIp]

theorem octIp_self_nonneg (x : Octonion) : 0 ≤ octIp x x :=
  Finset.sum_nonneg fun _ _ => mul_self_nonneg _

theorem octIp_self_eq_zero {x : Octonion} (h : octIp x x = 0) : x = 0 := by
  ext i
  have hle : x.coords i * x.coords i ≤ octIp x x :=
    Finset.single_le_sum (f := fun j => x.coords j * x.coords j)
      (fun _ _ => mul_self_nonneg _) (Finset.mem_univ i)
  have : x.coords i * x.coords i = 0 := by
    linarith [mul_self_nonneg (x.coords i)]
  simpa using mul_self_eq_zero.mp this

/-- The Euclidean inner product is the trace form: `⟨x, y⟩ = re (x ȳ)`.  This is the bridge to
`OctonionTrace.lean`. -/
theorem octIp_eq_re (x y : Octonion) : octIp x y = re (mul x (conj y)) := by
  simp [octIp, re, mul, conj, Fin.sum_univ_eight]

/-- Cyclic invariance of the real part of a triple product.  `re_mul_assoc` moves the bracket,
`re_mul_comm` rotates the factors. -/
theorem re_three_cyc (x y z : Octonion) :
    re (mul (mul x y) z) = re (mul (mul y z) x) := by
  rw [re_mul_assoc, re_mul_comm]

/-- Cyclic rotation of a conjugated triple, in the `octIp` vocabulary the Albert trace form is
written in.  This and `octIp_conj_cyc'` are the only octonionic input to `Albert/Inner.lean`'s
Euclidean hypothesis. -/
theorem octIp_conj_cyc (a b c : Octonion) :
    octIp (mul (conj a) (conj b)) c = octIp (mul (conj b) (conj c)) a := by
  rw [octIp_eq_re, octIp_eq_re]
  exact re_three_cyc (conj a) (conj b) (conj c)

/-- Cyclic rotation the other way. -/
theorem octIp_conj_cyc' (a b c : Octonion) :
    octIp (mul (conj a) (conj b)) c = octIp (mul (conj c) (conj a)) b := by
  rw [octIp_conj_cyc, octIp_conj_cyc]

/-- Coordinates of an octonion, as a linear equivalence with `Fin 8 → ℝ`. -/
def coordsEquiv : Octonion ≃ₗ[ℝ] (Fin 8 → ℝ) where
  toFun a := a.coords
  map_add' _ _ := rfl
  map_smul' _ _ := rfl
  invFun c := ⟨c⟩
  left_inv a := by cases a; rfl
  right_inv c := rfl

instance instFiniteDimensional : FiniteDimensional ℝ Octonion :=
  Module.Finite.equiv coordsEquiv.symm

/-- The octonions are 8-dimensional over `ℝ`. -/
theorem finrank_eq_eight : Module.finrank ℝ Octonion = 8 := by
  rw [coordsEquiv.finrank_eq, Module.finrank_fintype_fun_eq_card, Fintype.card_fin]

end Octonion

/-! ## The carrier -/

namespace RadicalRelativity.Albert

open Octonion

/-- A hermitian `3 × 3` octonionic matrix: three real diagonal entries and three octonionic
off-diagonal entries, `3 + 3 * 8 = 27` real dimensions. -/
structure h3O where
  /-- Diagonal entries, necessarily real. -/
  diag : Fin 3 → ℝ
  /-- Off-diagonal entries: `off 0 = (2,3)`, `off 1 = (1,3)`, `off 2 = (1,2)`. -/
  off : Fin 3 → Octonion

namespace h3O

@[ext]
theorem ext {a b : h3O} (hd : ∀ i, a.diag i = b.diag i) (ho : ∀ i, a.off i = b.off i) :
    a = b := by
  cases a; cases b; congr 1
  · exact funext hd
  · exact funext ho

/-- Six-component extensionality, with the indices as numerals rather than the `⟨k, _⟩` forms
`fin_cases` produces, so that the index-specific `@[simp]` lemmas of `Albert/Mul.lean` fire on
the resulting goals. -/
theorem ext_six {a b : h3O} (d0 : a.diag 0 = b.diag 0) (d1 : a.diag 1 = b.diag 1)
    (d2 : a.diag 2 = b.diag 2) (o0 : a.off 0 = b.off 0) (o1 : a.off 1 = b.off 1)
    (o2 : a.off 2 = b.off 2) : a = b := by
  refine ext (fun i => ?_) (fun i => ?_) <;> fin_cases i <;>
    first
      | exact d0 | exact d1 | exact d2 | exact o0 | exact o1 | exact o2

instance instZero : Zero h3O := ⟨⟨fun _ => 0, fun _ => 0⟩⟩
instance instOne : One h3O := ⟨⟨fun _ => 1, fun _ => 0⟩⟩
instance instAdd : Add h3O := ⟨fun a b => ⟨fun i => a.diag i + b.diag i, fun i => a.off i + b.off i⟩⟩
instance instNeg : Neg h3O := ⟨fun a => ⟨fun i => -a.diag i, fun i => -a.off i⟩⟩
instance instSMul : SMul ℝ h3O := ⟨fun r a => ⟨fun i => r • a.diag i, fun i => r • a.off i⟩⟩

@[simp] lemma zero_diag (i : Fin 3) : (0 : h3O).diag i = 0 := rfl
@[simp] lemma zero_off (i : Fin 3) : (0 : h3O).off i = 0 := rfl
@[simp] lemma one_diag (i : Fin 3) : (1 : h3O).diag i = 1 := rfl
@[simp] lemma one_off (i : Fin 3) : (1 : h3O).off i = 0 := rfl
@[simp] lemma add_diag (a b : h3O) (i : Fin 3) : (a + b).diag i = a.diag i + b.diag i := rfl
@[simp] lemma add_off (a b : h3O) (i : Fin 3) : (a + b).off i = a.off i + b.off i := rfl
@[simp] lemma neg_diag (a : h3O) (i : Fin 3) : (-a).diag i = -a.diag i := rfl
@[simp] lemma neg_off (a : h3O) (i : Fin 3) : (-a).off i = -a.off i := rfl
@[simp] lemma smul_diag (r : ℝ) (a : h3O) (i : Fin 3) : (r • a).diag i = r * a.diag i := rfl
@[simp] lemma smul_off (r : ℝ) (a : h3O) (i : Fin 3) : (r • a).off i = r • a.off i := rfl

instance instAddCommGroup : AddCommGroup h3O where
  add := (· + ·)
  add_assoc a b c := by refine ext (fun i => ?_) (fun i => ?_) <;> exact add_assoc _ _ _
  zero := 0
  nsmul := nsmulRec
  zsmul := zsmulRec
  zero_add a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact zero_add _
  add_zero a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact add_zero _
  neg := Neg.neg
  neg_add_cancel a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact neg_add_cancel _
  add_comm a b := by refine ext (fun i => ?_) (fun i => ?_) <;> exact add_comm _ _

instance instModule : Module ℝ h3O where
  smul := (· • ·)
  one_smul a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact one_smul _ _
  mul_smul r s a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact mul_smul _ _ _
  smul_zero r := by refine ext (fun i => ?_) (fun i => ?_) <;> exact smul_zero _
  smul_add r a b := by refine ext (fun i => ?_) (fun i => ?_) <;> exact smul_add _ _ _
  add_smul r s a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact add_smul _ _ _
  zero_smul a := by refine ext (fun i => ?_) (fun i => ?_) <;> exact zero_smul ℝ _

/-- The carrier is the product of its diagonal and off-diagonal parts, linearly. -/
def equivProd : h3O ≃ₗ[ℝ] (Fin 3 → ℝ) × (Fin 3 → Octonion) where
  toFun a := (a.diag, a.off)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl
  invFun p := ⟨p.1, p.2⟩
  left_inv a := by cases a; rfl
  right_inv p := by cases p; rfl

instance instFiniteDimensional : FiniteDimensional ℝ h3O :=
  Module.Finite.equiv equivProd.symm

/-- The Albert algebra is 27-dimensional over `ℝ`: three real diagonal entries and three
octonionic off-diagonal ones. -/
theorem finrank_eq_twentyseven : Module.finrank ℝ h3O = 27 := by
  have hoff : Module.finrank ℝ (Fin 3 → Octonion) = 24 := by
    rw [Module.finrank_pi_fintype]
    simp [Octonion.finrank_eq_eight]
  rw [equivProd.finrank_eq, Module.finrank_prod, hoff, Module.finrank_fintype_fun_eq_card,
    Fintype.card_fin]

end h3O

end RadicalRelativity.Albert
