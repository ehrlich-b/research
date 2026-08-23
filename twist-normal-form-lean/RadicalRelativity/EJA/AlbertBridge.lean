/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.AlbertCarrier
import RadicalRelativity.EJA.HermMatCarrier

set_option linter.style.longLine false

/-!
# The bridge `h₃(𝕆) ≃ H₃(𝕆)`

`Albert/Carrier.lean`'s `h3O` and `Composition/HermMat.lean`'s `HermMat (Fin 3) Octonion` were
built independently and, until this file, **no map between them existed anywhere in the tree** —
a sentence `Composition/HermMat.lean`, `Composition/HermInner.lean`, `EJA/HermMatCarrier.lean`,
`EJA/Coordinatize.lean` and the root aggregator all carried.  This file constructs it.

`toHermMat : h3O ≃ₗ[ℝ] HermMat (Fin 3) Octonion` is the coordinate bijection, and
`toHermMat_jordanMul` says it intertwines `h3O.jordanMul` with the symmetrised matrix product
`jmul`.  Transporting `Albert/Jordan.lean`'s `jordanMul_jordan` across it gives
`HermMat (Fin 3) Octonion` the Jordan identity that `jmul_jordan_of_assoc` cannot reach — that
lemma is stated under `[Ring C]` and `𝕆` is not associative — and with it the
`EuclideanJordanAlgebra` instance.

## The layout, spelled out

`Albert/Carrier.lean:23-33` fixes the convention
```
[[a₁, x₃*, x₂ ],
 [x₃, a₂,  x₁*],
 [x₂*, x₁, a₃ ]]
```
with `xₖ = off (k-1)`.  In `Fin 3` indices that is the nine entries of `toMat` below:
```
(0,0) = diag 0 • 1      (0,1) = (off 2)*      (0,2) = off 1
(1,0) = off 2           (1,1) = diag 1 • 1    (1,2) = (off 0)*
(2,0) = (off 1)*        (2,1) = off 0         (2,2) = diag 2 • 1
```
The diagonal is the real scalar embedded as `r • (1 : 𝕆)`; `diag_eq_smul_one` is the fact that
this is forced, and `ip · 1` is the inverse of that embedding, which is how `toHermMat.invFun`
reads the diagonal back off a matrix.

Each of the six entry computations below is `½(AB + BA)` at that slot, contracted with
`Fin.sum_univ_three`, against the corresponding coordinate formula of `Albert/Mul.lean`.  The
two polarisations `mul_cstar_add` and `cstar_mul_add` — `x y* + y x* = 2⟪x,y⟫ • 1` and
`x* y + y* x = 2⟪x,y⟫ • 1` — are what turn the four off-diagonal products contracted by a
diagonal slot into the `octIp` terms `jordanMul` writes there.  They are polarisations of the
composition law (`mul_cstar_self` / `cstar_mul_self`), not consequences of associativity.

## Main definitions

* `RadicalRelativity.EJA.toMat` — the nine matrix entries
* `RadicalRelativity.EJA.toHermMat` — `h3O ≃ₗ[ℝ] HermMat (Fin 3) Octonion`

## Main results

* `toHermMat_jordanMul` — `toHermMat (a ∘ b) = toHermMat a ∘ toHermMat b`
* `toHermMat_hermIp` — `toHermMat` is an isometry for the trace form and the entrywise form
* `albertHermMat_jordan` — the Jordan identity on `HermMat (Fin 3) Octonion`
* `instEuclideanJordanAlgebraHermMatOctonion` — the class, on the octonionic carrier at rank 3
* `finrank_hermMat_octonion` — `finrank ℝ (HermMat (Fin 3) Octonion) = 27`
* `hermMat3_jmul_jordan` — the Jordan identity on `H₃(C)` for *every* finite-dimensional
  Euclidean composition algebra `C`, the four branches of `hurwitz_classification` assembled

## What this does and does not settle

★ **This does not discharge Jacobson coordinatization.**  `J ≅ H_n(C)` is residue (1) of
`WallCertificates/jacobson-coordinatization.lean` and is still a `sorry` there, as are the other
two.  What lands here is one more piece of Jordan structure on that theorem's *right-hand side*,
plus the identification of that right-hand side at `(3, 𝕆)` with the carrier `Albert/` already
had.  Nothing here says any abstract `J` is isomorphic to anything.

★ **Rank 3 only.**  The instance below is on `HermMat (Fin 3) Octonion` and on nothing else.
What is proved here is the single case `n = 3`, by transporting a hand-built coordinate
computation — not by any argument with a rank parameter in it.  Classically `H_n(𝕆)` is a Jordan
algebra exactly for `n ≤ 3`, so the absence of `n ≥ 4` here is a mathematical boundary and not a
hole in the formalization; but that is a citation (Albert; Jacobson) and **this tree proves
neither half of it** — neither the `n ≤ 3` half in general (`n = 1` and `n = 2` are stated
nowhere) nor the `n ≥ 4` failure, which is residue (3) of the certificate and remains open.

★ **`jmul_jordan_of_isCompIso` is the wrong shape for this** and is not used.  It transports the
Jordan identity along an isomorphism `f : C ≃ₗ[ℝ] D` of the *coefficient* algebra, landing
`H_ι(C)` on `H_ι(D)` for associative `D`; the octonions are isomorphic to no associative
composition algebra, so its hypothesis is unavailable at `C := 𝕆` and no instantiation of it
could reach this result.  The transport here is along an isomorphism of the *Jordan algebra*,
between two different presentations of `H_3(𝕆)`, and is a different theorem.

★ **The `n ≤ 3` restriction is invisible to the proof.**  Nothing below fails "because `n ≥ 4`";
what happens is that `Albert/Jordan.lean`'s coordinate proof exists only at rank 3, so only rank
3 has anything to transport.  No statement here is evidence about rank `≥ 4` in either direction.

## Instance search, measured

★ Measured 2026-08-23, with this module imported:

| search | returns |
| --- | --- |
| `Mul ↥(HermMat (Fin 3) Octonion)` | `instEuclideanJordanAlgebraHermMatOctonion.toMul` |
| `One ↥(HermMat (Fin 3) Octonion)` | `instEuclideanJordanAlgebraHermMatOctonion.toOne` |
| `EuclideanJordanAlgebra ↥(HermMat (Fin 3) Octonion)` | `instEuclideanJordanAlgebraHermMatOctonion` |
| `Mul h3O` | `instEuclideanJordanAlgebraH3O.toMul` |

Row 3 is the one worth reading: `EJA/HermMatCarrier.lean`'s `instEuclideanJordanAlgebraHermMat`
is *also* a candidate for that goal, and search does not return it — its `[Ring C]` hypothesis
fails at `Octonion`.  So there is no second `Mul` on this carrier and no collision to measure,
unlike `EJA/AlbertCarrier.lean`'s.  Row 4 is unchanged by this file: `h3O`'s `Mul` is still the
one `EJA/AlbertCarrier.lean` installs.

★ What that table does **not** say: nothing here checks that the two `EuclideanJordanAlgebra`
instances agree anywhere, because there is no type at which both apply.

## Scope

**No manifest row moves.**  This file is substrate.  In particular row 21 `thm:albert` is not
touched: that row is about sequential products on `h₃(𝕆)`, and this file constructs no product
of that kind and states nothing about one.
-/

noncomputable section

namespace RadicalRelativity.EJA

open CompositionAlgebra RadicalRelativity.Albert

/-! ## The three bridges between `Octonions.lean` and the composition-algebra API

`Albert/` is written over `Octonion.mul`, `Octonion.conj` and `Octonion.octIp`;
`Composition/` is written over the `NonAssocRing` product, `cstar` and `ip`.  The first and third
are the same function by construction of `Octonion.instNonAssocRing` and
`Octonion.instCompositionAlgebra`, so they are `rfl`.  The second is not: `cstar` is *defined* as
the reflection `x ↦ 2⟪x,1⟫ • 1 - x` and agreeing with the hard-coded coordinate conjugation is a
(one-line) theorem. -/

section Bridge

@[simp] theorem oct_one_coords (i : Fin 8) :
    (1 : Octonion).coords i = if i = 0 then 1 else 0 := rfl

/-- The composition-algebra product on `𝕆` is `Octonions.lean`'s Fano-table product. -/
theorem oct_mul_eq (x y : Octonion) : Octonion.mul x y = x * y := rfl

/-- The composition-algebra form on `𝕆` is `Albert/Carrier.lean`'s Euclidean form. -/
theorem oct_octIp_eq (x y : Octonion) : Octonion.octIp x y = ip x y := rfl

/-- `⟪x, 1⟫ = x₀`: the real part, read off coordinate zero. -/
theorem oct_ip_one (x : Octonion) : ip x (1 : Octonion) = x.coords 0 := by
  change Octonion.octIp x (1 : Octonion) = x.coords 0
  simp [Octonion.octIp]

/-- **The conjugations agree.**  `Composition/Defs.lean`'s `cstar`, the reflection in `ℝ ∙ 1`,
is `Octonions.lean`'s coordinate conjugation. -/
theorem oct_conj_eq (x : Octonion) : Octonion.conj x = cstar x := by
  rw [cstar_apply, oct_ip_one, sub_eq_add_neg]
  ext i
  simp only [Octonion.conj, Octonion.add_coords, Octonion.neg_coords, Octonion.smul_coords,
    oct_one_coords]
  split_ifs with h
  · subst h; ring
  · ring

end Bridge

/-! ## Two polarisations and two scalar identities

All four hold in an arbitrary Euclidean composition algebra.  The polarisations are what the
three diagonal entries of the product need; the scalar identities are what every entry needs to
absorb a diagonal factor `r • 1`. -/

section Polar

variable {C : Type*} [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C]
  [CompositionAlgebra C]

/-- `x y* + y x* = 2⟪x, y⟫ • 1`, the polarisation of `mul_cstar_self`. -/
theorem mul_cstar_add (x y : C) : x * cstar y + y * cstar x = (2 * ip x y) • (1 : C) := by
  have h := mul_cstar_self (x + y)
  rw [cstar_add, mul_add, add_mul, add_mul, mul_cstar_self x, mul_cstar_self y, nf_add] at h
  linear_combination (norm := module) h

/-- `x* y + y* x = 2⟪x, y⟫ • 1`, the polarisation of `cstar_mul_self`. -/
theorem cstar_mul_add (x y : C) : cstar x * y + cstar y * x = (2 * ip x y) • (1 : C) := by
  have h := cstar_mul_self (x + y)
  rw [cstar_add, add_mul, mul_add, mul_add, cstar_mul_self x, cstar_mul_self y, nf_add] at h
  linear_combination (norm := module) h

/-- Conjugation is an isometry of the form.  Polarisation of `nf_cstar`. -/
theorem ip_cstar_cstar [Nontrivial C] (x y : C) : ip (cstar x) (cstar y) = ip x y := by
  have h := nf_cstar (x + y)
  rw [cstar_add, nf_add, nf_add, nf_cstar x, nf_cstar y] at h
  linarith

omit [SMulCommClass ℝ C C] [CompositionAlgebra C] in
theorem smul_one_mul' (r : ℝ) (x : C) : (r • (1 : C)) * x = r • x := by
  rw [smul_mul_assoc, one_mul]

omit [IsScalarTower ℝ C C] [CompositionAlgebra C] in
theorem mul_smul_one' (r : ℝ) (x : C) : x * (r • (1 : C)) = r • x := by
  rw [mul_smul_comm, mul_one]

omit [CompositionAlgebra C] in
theorem smul_one_mul_smul_one (r s : ℝ) : (r • (1 : C)) * (s • (1 : C)) = (r * s) • (1 : C) := by
  rw [smul_mul_assoc, mul_smul_comm, mul_one, smul_smul]

end Polar

/-! ## Extensionality for `3 × 3` octonionic matrices

`mat3_ext` is the nine-entry version, with the indices as numerals rather than the `⟨k, _⟩` forms
`fin_cases` produces, for the same reason `Albert/Carrier.lean`'s `ext_six` exists: the
index-specific `@[simp]` lemmas below have to fire on the resulting goals.  `mat3_herm_ext` cuts
that to six by deriving the three entries above the diagonal from the three below it, which is
available because both sides of every equation proved here are hermitian. -/

section Ext

theorem mat3_ext {M N : Matrix (Fin 3) (Fin 3) Octonion}
    (h00 : M 0 0 = N 0 0) (h01 : M 0 1 = N 0 1) (h02 : M 0 2 = N 0 2)
    (h10 : M 1 0 = N 1 0) (h11 : M 1 1 = N 1 1) (h12 : M 1 2 = N 1 2)
    (h20 : M 2 0 = N 2 0) (h21 : M 2 1 = N 2 1) (h22 : M 2 2 = N 2 2) : M = N := by
  refine Matrix.ext fun i j => ?_
  fin_cases i <;> fin_cases j <;>
    first
      | exact h00 | exact h01 | exact h02
      | exact h10 | exact h11 | exact h12
      | exact h20 | exact h21 | exact h22

/-- The mirror of `mat3_herm_ext` for *establishing* hermiticity: six numeral-indexed obligations,
the three above the diagonal following by `cstar_cstar`. -/
theorem isHerm_of_six {M : Matrix (Fin 3) (Fin 3) Octonion}
    (d0 : M 0 0 = cstar (M 0 0)) (d1 : M 1 1 = cstar (M 1 1)) (d2 : M 2 2 = cstar (M 2 2))
    (h10 : M 1 0 = cstar (M 0 1)) (h20 : M 2 0 = cstar (M 0 2)) (h21 : M 2 1 = cstar (M 1 2)) :
    IsHerm M := by
  have h01 : M 0 1 = cstar (M 1 0) := by rw [h10, cstar_cstar]
  have h02 : M 0 2 = cstar (M 2 0) := by rw [h20, cstar_cstar]
  have h12 : M 1 2 = cstar (M 2 1) := by rw [h21, cstar_cstar]
  intro i j
  fin_cases i <;> fin_cases j <;>
    first
      | exact d0 | exact d1 | exact d2
      | exact h10 | exact h20 | exact h21
      | exact h01 | exact h02 | exact h12

/-- Two hermitian `3 × 3` matrices agree as soon as they agree at the three diagonal slots and at
one slot from each conjugate pair. -/
theorem mat3_herm_ext {M N : Matrix (Fin 3) (Fin 3) Octonion}
    (hM : IsHerm M) (hN : IsHerm N)
    (h00 : M 0 0 = N 0 0) (h11 : M 1 1 = N 1 1) (h22 : M 2 2 = N 2 2)
    (h10 : M 1 0 = N 1 0) (h02 : M 0 2 = N 0 2) (h21 : M 2 1 = N 2 1) : M = N := by
  have h01 : M 0 1 = N 0 1 := by rw [hM 1 0, hN 1 0, h10]
  have h20 : M 2 0 = N 2 0 := by rw [hM 0 2, hN 0 2, h02]
  have h12 : M 1 2 = N 1 2 := by rw [hM 2 1, hN 2 1, h21]
  exact mat3_ext h00 h01 h02 h10 h11 h12 h20 h21 h22

/-- The symmetrised product before the `½`: hermitian, by the same `cstar_mul` bookkeeping as
`symmMul_mem`, which states it with the scalar in place. -/
theorem symmMul_isHerm {M N : Matrix (Fin 3) (Fin 3) Octonion}
    (hM : IsHerm M) (hN : IsHerm N) : IsHerm (M * N + N * M) := by
  intro i j
  have hM' : ∀ p q, M q p = cstar (M p q) := hM
  have hN' : ∀ p q, N q p = cstar (N p q) := hN
  simp only [Matrix.add_apply, Matrix.mul_apply, cstar_add, cstar_sum, cstar_mul, ← hM', ← hN']
  first
    | rfl
    | rw [add_comm]

end Ext

/-! ## The coordinate bijection -/

/-- The nine matrix entries of an element of `h₃(𝕆)`, in the layout of
`Albert/Carrier.lean:23-33`. -/
def toMat (a : h3O) : Matrix (Fin 3) (Fin 3) Octonion :=
  !![(a.diag 0) • (1 : Octonion), cstar (a.off 2), a.off 1;
     a.off 2, (a.diag 1) • (1 : Octonion), cstar (a.off 0);
     cstar (a.off 1), a.off 0, (a.diag 2) • (1 : Octonion)]

@[simp] theorem toMat_00 (a : h3O) : toMat a 0 0 = (a.diag 0) • (1 : Octonion) := rfl
@[simp] theorem toMat_01 (a : h3O) : toMat a 0 1 = cstar (a.off 2) := rfl
@[simp] theorem toMat_02 (a : h3O) : toMat a 0 2 = a.off 1 := rfl
@[simp] theorem toMat_10 (a : h3O) : toMat a 1 0 = a.off 2 := rfl
@[simp] theorem toMat_11 (a : h3O) : toMat a 1 1 = (a.diag 1) • (1 : Octonion) := rfl
@[simp] theorem toMat_12 (a : h3O) : toMat a 1 2 = cstar (a.off 0) := rfl
@[simp] theorem toMat_20 (a : h3O) : toMat a 2 0 = cstar (a.off 1) := rfl
@[simp] theorem toMat_21 (a : h3O) : toMat a 2 1 = a.off 0 := rfl
@[simp] theorem toMat_22 (a : h3O) : toMat a 2 2 = (a.diag 2) • (1 : Octonion) := rfl

theorem toMat_isHerm (a : h3O) : IsHerm (toMat a) :=
  isHerm_of_six
    (by simp only [toMat_00, cstar_smul, cstar_one])
    (by simp only [toMat_11, cstar_smul, cstar_one])
    (by simp only [toMat_22, cstar_smul, cstar_one])
    (by simp only [toMat_10, toMat_01, cstar_cstar])
    (by simp only [toMat_20, toMat_02])
    (by simp only [toMat_21, toMat_12, cstar_cstar])

theorem toMat_mem (a : h3O) : toMat a ∈ HermMat (Fin 3) Octonion := toMat_isHerm a

/-- **The coordinate bijection** `h₃(𝕆) ≃ₗ[ℝ] H₃(𝕆)`.  Forwards, the 27 real coordinates are laid
out in the nine matrix slots; backwards, the diagonal is read through `ip · 1` — legitimate
because `diag_eq_smul_one` says a hermitian diagonal entry is a real multiple of `1` — and the
three off-diagonal coordinates are read off the slots `(2,1)`, `(0,2)`, `(1,0)`. -/
def toHermMat : h3O ≃ₗ[ℝ] HermMat (Fin 3) Octonion where
  toFun a := ⟨toMat a, toMat_mem a⟩
  map_add' a b := by
    apply Subtype.ext
    refine mat3_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
      simp only [toMat_00, toMat_01, toMat_02, toMat_10, toMat_11, toMat_12, toMat_20, toMat_21,
        toMat_22, Submodule.coe_add, Matrix.add_apply, h3O.add_diag, h3O.add_off, cstar_add,
        add_smul]
  map_smul' r a := by
    apply Subtype.ext
    refine mat3_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
      simp only [RingHom.id_apply, toMat_00, toMat_01, toMat_02, toMat_10, toMat_11, toMat_12,
        toMat_20, toMat_21, toMat_22, SetLike.val_smul, Matrix.smul_apply, h3O.smul_diag,
        h3O.smul_off, cstar_smul, smul_smul]
  invFun A :=
    ⟨fun i => ip ((A : Matrix (Fin 3) (Fin 3) Octonion) i i) 1,
     ![(A : Matrix (Fin 3) (Fin 3) Octonion) 2 1,
       (A : Matrix (Fin 3) (Fin 3) Octonion) 0 2,
       (A : Matrix (Fin 3) (Fin 3) Octonion) 1 0]⟩
  left_inv a := by
    refine h3O.ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;>
      simp only [toMat_00, toMat_11, toMat_22, toMat_21, toMat_02, toMat_10, ip_smul_left,
        ip_one_one, mul_one, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.tail_cons]
  right_inv A := by
    apply Subtype.ext
    refine mat3_herm_ext (toMat_isHerm _) A.2 ?_ ?_ ?_ ?_ ?_ ?_ <;>
      simp only [toMat_00, toMat_11, toMat_22, toMat_21, toMat_02, toMat_10,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
        Matrix.tail_cons, ← diag_eq_smul_one]

@[simp] theorem toHermMat_coe (a : h3O) :
    ((toHermMat a : HermMat (Fin 3) Octonion) : Matrix (Fin 3) (Fin 3) Octonion) = toMat a := rfl

/-! ## The products agree -/

/-- The symmetrised matrix product of two elements of the image, before the `½`.  This is the
whole content of the bridge: six entry computations, each `(AB + BA)` at one slot against the
corresponding coordinate formula of `Albert/Mul.lean`. -/
theorem toMat_symmMul (a b : h3O) :
    toMat a * toMat b + toMat b * toMat a = (2 : ℝ) • toMat (h3O.jordanMul a b) := by
  refine mat3_herm_ext (symmMul_isHerm (toMat_isHerm a) (toMat_isHerm b))
    ((HermMat (Fin 3) Octonion).smul_mem (2 : ℝ) (toMat_mem _)) ?_ ?_ ?_ ?_ ?_ ?_
  -- `(0,0)`: two diagonal products, and the two polarisations at `off 1` and `off 2`.
  · simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.smul_apply, Fin.sum_univ_three,
      toMat_00, toMat_01, toMat_02, toMat_10, toMat_20, h3O.jordanMul_diag_zero,
      oct_octIp_eq]
    linear_combination (norm := module)
      smul_one_mul_smul_one (C := Octonion) (a.diag 0) (b.diag 0)
      + smul_one_mul_smul_one (C := Octonion) (b.diag 0) (a.diag 0)
      + cstar_mul_add (a.off 2) (b.off 2)
      + mul_cstar_add (a.off 1) (b.off 1)
  -- `(1,1)`.
  · simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.smul_apply, Fin.sum_univ_three,
      toMat_10, toMat_11, toMat_12, toMat_01, toMat_21, h3O.jordanMul_diag_one,
      oct_octIp_eq]
    linear_combination (norm := module)
      smul_one_mul_smul_one (C := Octonion) (a.diag 1) (b.diag 1)
      + smul_one_mul_smul_one (C := Octonion) (b.diag 1) (a.diag 1)
      + mul_cstar_add (a.off 2) (b.off 2)
      + cstar_mul_add (a.off 0) (b.off 0)
  -- `(2,2)`.
  · simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.smul_apply, Fin.sum_univ_three,
      toMat_20, toMat_21, toMat_22, toMat_02, toMat_12, h3O.jordanMul_diag_two,
      oct_octIp_eq]
    linear_combination (norm := module)
      smul_one_mul_smul_one (C := Octonion) (a.diag 2) (b.diag 2)
      + smul_one_mul_smul_one (C := Octonion) (b.diag 2) (a.diag 2)
      + cstar_mul_add (a.off 1) (b.off 1)
      + mul_cstar_add (a.off 0) (b.off 0)
  -- `(1,0)`, the slot holding `off 2`: four diagonal absorptions, no polarisation.
  · simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.smul_apply, Fin.sum_univ_three,
      toMat_10, toMat_11, toMat_12, toMat_00, toMat_20, h3O.jordanMul_off_two,
      oct_mul_eq, oct_conj_eq]
    linear_combination (norm := module)
      mul_smul_one' (b.diag 0) (a.off 2) + smul_one_mul' (a.diag 1) (b.off 2)
      + mul_smul_one' (a.diag 0) (b.off 2) + smul_one_mul' (b.diag 1) (a.off 2)
  -- `(0,2)`, the slot holding `off 1`.
  · simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.smul_apply, Fin.sum_univ_three,
      toMat_00, toMat_01, toMat_02, toMat_12, toMat_22, h3O.jordanMul_off_one,
      oct_mul_eq, oct_conj_eq]
    linear_combination (norm := module)
      smul_one_mul' (a.diag 0) (b.off 1) + mul_smul_one' (b.diag 2) (a.off 1)
      + smul_one_mul' (b.diag 0) (a.off 1) + mul_smul_one' (a.diag 2) (b.off 1)
  -- `(2,1)`, the slot holding `off 0`.
  · simp only [Matrix.add_apply, Matrix.mul_apply, Matrix.smul_apply, Fin.sum_univ_three,
      toMat_20, toMat_21, toMat_22, toMat_01, toMat_11, h3O.jordanMul_off_zero,
      oct_mul_eq, oct_conj_eq]
    linear_combination (norm := module)
      mul_smul_one' (b.diag 1) (a.off 0) + smul_one_mul' (a.diag 2) (b.off 0)
      + mul_smul_one' (a.diag 1) (b.off 0) + smul_one_mul' (b.diag 2) (a.off 0)

/-- ★★ **The products agree.**  `toHermMat` carries `Albert/Mul.lean`'s coordinate product to
`Composition/HermMat.lean`'s symmetrised matrix product. -/
theorem toHermMat_jordanMul (a b : h3O) :
    toHermMat (h3O.jordanMul a b) = jmul (toHermMat a) (toHermMat b) := by
  apply Subtype.ext
  rw [jmul_coe, toHermMat_coe, toHermMat_coe, toHermMat_coe, toMat_symmMul, smul_smul,
    inv_mul_cancel₀ (by norm_num : (2 : ℝ) ≠ 0), one_smul]

/-- `toHermMat` is an isometry: `Albert/Inner.lean`'s trace form on `h₃(𝕆)` is
`Composition/HermInner.lean`'s entrywise form on `H₃(𝕆)`.  The factor `2` written by hand at
`Albert/Inner.lean:80` is here the two matrix slots each off-diagonal coordinate occupies, and
`ip_cstar_cstar` is what says the conjugate slot contributes the same as the slot itself.

★ This is the rank-3 octonionic instance of the identification `Composition/HermInner.lean`
flags as "classical, but not proved here"; it does **not** prove that file's general statement,
which is about `Tr(A ∘ B)` at an arbitrary `ι` and `C` and needs a trace map this tree still does
not construct. -/
theorem toHermMat_hermIp (a b : h3O) :
    hermIp (toHermMat a) (toHermMat b) = h3O.traceForm a b := by
  simp only [hermIp, toHermMat_coe, Fin.sum_univ_three, toMat_00, toMat_01, toMat_02, toMat_10,
    toMat_11, toMat_12, toMat_20, toMat_21, toMat_22, h3O.traceForm, oct_octIp_eq,
    ip_cstar_cstar, ip_smul_left, ip_smul_right, ip_one_one]
  ring

/-! ## The Jordan identity, transported -/

/-- ★★ **The Jordan identity on `H₃(𝕆)`**, in Mathlib's orientation.  Transported from
`Albert/Jordan.lean`'s `jordanMul_jordan` along `toHermMat`.

★ `Composition/HermMat.lean`'s `jmul_jordan_of_assoc` cannot give this — it is stated under
`[Ring C]` and `Octonion` carries no `Ring` instance (`Octonion.non_associative` is a theorem of
`Octonions.lean`) — and neither can `jmul_jordan_of_isCompIso`, whose hypothesis is an
isomorphism of the coefficient algebra onto an associative one.  See the module docstring. -/
theorem albertHermMat_jordan (A B : HermMat (Fin 3) Octonion) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) := by
  obtain ⟨a, rfl⟩ := toHermMat.surjective A
  obtain ⟨b, rfl⟩ := toHermMat.surjective B
  simp only [← toHermMat_jordanMul, h3O.jordanMul_jordan]

/-- The Jordan identity in the class's orientation, `x ∘ (x² ∘ y) = x² ∘ (x ∘ y)`; the two differ
by commuting the product twice, exactly as in `EJA/HermMatCarrier.lean`. -/
theorem albertHermMat_jordan' (A B : HermMat (Fin 3) Octonion) :
    jmul A (jmul (jmul A A) B) = jmul (jmul A A) (jmul A B) := by
  rw [jmul_comm (jmul A A) B, ← albertHermMat_jordan A B]
  exact jmul_comm _ _

/-! ## The instance -/

/-- ★★★ **`H₃(𝕆)` is a Euclidean Jordan algebra.**  The class of `EJA/Class.lean` on
`Composition/HermMat.lean`'s carrier at the one place `EJA/HermMatCarrier.lean` could not reach
it: non-associative coefficients, rank 3.

Every field except `jordan` is the general lemma `EJA/HermMatCarrier.lean` uses, at the weakest
tier — none of them needed associativity.  `jordan` is `albertHermMat_jordan'`, transported from
`h3O`.

★ There is no instance clash with `instEuclideanJordanAlgebraHermMat`: that one requires
`[Ring C]`, which `Octonion` does not have, so it never applies at these coefficients. -/
instance instEuclideanJordanAlgebraHermMatOctonion :
    EuclideanJordanAlgebra (HermMat (Fin 3) Octonion) where
  mul := jmul
  one := hermOne
  mul_comm A B := jmul_comm A B
  add_mul A B D := jmul_add_left A B D
  smul_mul r A B := jmul_smul_left r A B
  one_mul A := jmul_hermOne_left A
  jordan A B := albertHermMat_jordan' A B
  inner_assoc A B D := hermIp_jmul_assoc A B D

/-! ### Fidelity

As in both existing carriers: `rfl`s pinning the class's product and unit to the intended ones,
so that inhabitedness alone is not what is being claimed. -/

/-- The class's product on `H₃(𝕆)` is `CompositionAlgebra.jmul`. -/
theorem hermMatOctonion_mul_eq_jmul (A B : HermMat (Fin 3) Octonion) : A * B = jmul A B := rfl

/-- The class's unit on `H₃(𝕆)` is the identity matrix. -/
theorem hermMatOctonion_one_eq_hermOne : (1 : HermMat (Fin 3) Octonion) = hermOne := rfl

/-- **`toHermMat` is a homomorphism for the class's product**, not merely for `jmul` — the
statement's `*` is the one instance search returns on `H₃(𝕆)`. -/
theorem toHermMat_mul (a b : h3O) : toHermMat (a * b) = toHermMat a * toHermMat b :=
  toHermMat_jordanMul a b

/-- **`H₃(𝕆)` is formally real.**  `EJA/Class.lean`'s `instIsFormallyReal` derives it from the
class, so this is synthesis, not a new argument. -/
theorem hermMatOctonion_isFormallyReal : IsFormallyReal (HermMat (Fin 3) Octonion) :=
  inferInstance

/-! ## The dimension count

★ `Composition/HermMat.lean:502` records "no dimension count: `finrank ℝ (HermMat (Fin 3) Octonion) = 27`
is not proved, and no basis of `HermMat ι C` is constructed, so nothing rules out the submodule
being smaller than intended."  The first clause is retired here — through the bijection, not
through a basis.  The second and third stand: no basis of `HermMat ι C` is constructed anywhere,
and nothing below says anything about any other `ι` or `C`. -/

/-- `finrank ℝ H₃(𝕆) = 27`, transported from `h3O.finrank_eq_twentyseven`. -/
theorem finrank_hermMat_octonion :
    Module.finrank ℝ (HermMat (Fin 3) Octonion) = 27 := by
  rw [← toHermMat.finrank_eq]
  exact h3O.finrank_eq_twentyseven

/-! ## Rank three at an arbitrary coefficient algebra

`Composition/HermMat.lean` splits the Jordan identity into `jmul_jordan_of_assoc` (associative
`C`, every rank) and `jmul_jordan_of_isCompIso` (`C` isomorphic to an associative one, every
rank).  `CoordAlg.classification_coordAlg` hands out four branches and those two cover three of
them; the fourth, `𝕆`, is what this file closes — at rank three.  Combining the three
associative branches with the octonionic one through `hurwitz_classification` gives the identity
at rank three with **no hypothesis on `C` beyond the composition-algebra bundle**.

★ The bound `3` here is not derived: it is inherited from `albertHermMat_jordan`, which is
inherited from `Albert/Jordan.lean`'s coordinate computation, which exists only at rank three.
Nothing below is evidence about rank `≥ 4`. -/

section Rank3

variable {C : Type*} [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C]
  [CompositionAlgebra C]

/-- The octonionic companion of `jmul_jordan_of_isCompIso`: the Jordan identity on `H₃(C)` for
`C` isomorphic to `𝕆`, transported along `hermCongr`.  Same proof shape as that lemma, with
`albertHermMat_jordan` in place of `jmul_jordan_of_assoc` — which is exactly the substitution
that was unavailable before this file. -/
theorem jmul_jordan_of_isCompIso_octonion {f : C ≃ₗ[ℝ] Octonion} (hf : IsCompIso f)
    (A B : HermMat (Fin 3) C) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) := by
  apply (hermCongr (ι := Fin 3) hf).injective
  simp only [hermCongr_jmul]
  exact albertHermMat_jordan _ _

/-- ★★ **`H₃(C)` satisfies the Jordan identity for every finite-dimensional Euclidean composition
algebra `C`.**  `hurwitz_classification` splits into four branches; three land on
`jmul_jordan_of_isCompIso` and the fourth on `jmul_jordan_of_isCompIso_octonion`.

★ This is rank three and nothing else, and it is **not** a proof that `H_n(C)` is a Jordan
algebra for `n ≤ 3` in general: `n = 1` and `n = 2` are not stated anywhere in this tree.  ★ Nor
does it say anything about `n ≥ 4`, where the octonionic case classically fails. -/
theorem hermMat3_jmul_jordan [FiniteDimensional ℝ C] [Nontrivial C] (A B : HermMat (Fin 3) C) :
    jmul (jmul A B) (jmul A A) = jmul A (jmul B (jmul A A)) := by
  rcases hurwitz_classification (C := C) with ⟨f, hf⟩ | ⟨f, hf⟩ | ⟨f, hf⟩ | ⟨f, hf⟩
  · exact jmul_jordan_of_isCompIso hf A B
  · exact jmul_jordan_of_isCompIso hf A B
  · exact jmul_jordan_of_isCompIso hf A B
  · exact jmul_jordan_of_isCompIso_octonion hf A B

end Rank3

end RadicalRelativity.EJA
