/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.DirectSum
import RadicalRelativity.OrthFamily

set_option linter.style.longLine false

/-!
# `prop:central`, restriction half: an unknown product on a direct sum restricts to each summand

STATEMENT-MANIFEST row 12.  `DirectSum.lean` already carries the *converse* (`SequentialProductOn.prod`:
summand products assemble into a product on `V × W`) and `MasterTheorem.Central.central_decomposition`
carries the componentwise formula.  What the row recorded as genuinely open is the direction proved
here: an **arbitrary** `P : SequentialProductOn (V × W)` restricts to S1–S7 products on each summand.

## The one fact that makes it work

Everything turns on `sp_inl_snd_eq_zero`: for effects `a, b` of `V`,

  `0 ≤ P.sp (a, 0) (b, 0) ≤ (a, 0)`

— the lower bound by positivity, the upper bound by `sp_le_left` — and reading off second
components squeezes `(P.sp (a,0) (b,0)).2` between `0` and `0`.  ★ **So a product of two elements
supported in the first summand is supported in the first summand**, which is the article's "distinct
simple summands cannot couple" in the only form the restriction needs.  No S2, no spectral theory,
no centrality hypothesis: it is two derived order facts and antisymmetry.

## Where the work actually is

Six of the eight fields are then bookkeeping.  Two are not.

* `sp_unit_left` fails naively, because the unit of `V × W` is `(𝟙, 𝟙)` and the restriction needs
  `(𝟙, 0)` to act as a unit on the first summand.  That is `OrthFamily`'s `sp_sharp_value_le` —
  a sharp effect is the identity on everything below it — applied at the sharp effect `(𝟙, 0)`.
* `compatible_ortho` fails naively for the same reason: `𝟙 - (b, 0) = (𝟙 - b, 𝟙)`, not `(𝟙 - b, 0)`.
  ★ The fix is to take the complement of `(b,0) + (0,𝟙)` instead of of `(b,0)`: compatibility with
  `(b,0)` and with the (orthogonal, hence automatically compatible) `(0,𝟙)` gives compatibility
  with their sum by S6b, and `𝟙 - ((b,0) + (0,𝟙)) = (𝟙 - b, 0)` on the nose.
-/

noncomputable section

open OrderUnitSpace

namespace SequentialProductOn

variable {V W : Type*} [OrderUnitSpace V] [OrderUnitSpace W]

/-! ## The summand units are sharp -/

theorem isSharp_inl_unit : IsSharp (((𝟙 : V), (0 : W)) : V × W) := by
  refine ⟨isEffect_prod_iff.mpr ⟨isEffect_unit, isEffect_zero⟩, fun z hz hz1 hz2 => ?_⟩
  have hcompl : (𝟙 : V × W) - ((𝟙 : V), (0 : W)) = ((0 : V), (𝟙 : W)) := by
    rw [prod_ousUnit, Prod.mk_sub_mk, sub_self, sub_zero]
  rw [hcompl, Prod.le_def] at hz2
  rw [Prod.le_def] at hz1
  have h0 := hz.1
  rw [Prod.le_def] at h0
  exact Prod.ext (le_antisymm hz2.1 h0.1) (le_antisymm hz1.2 h0.2)

theorem isSharp_inr_unit : IsSharp (((0 : V), (𝟙 : W)) : V × W) := by
  refine ⟨isEffect_prod_iff.mpr ⟨isEffect_zero, isEffect_unit⟩, fun z hz hz1 hz2 => ?_⟩
  have hcompl : (𝟙 : V × W) - ((0 : V), (𝟙 : W)) = ((𝟙 : V), (0 : W)) := by
    rw [prod_ousUnit, Prod.mk_sub_mk, sub_self, sub_zero]
  rw [hcompl, Prod.le_def] at hz2
  rw [Prod.le_def] at hz1
  have h0 := hz.1
  rw [Prod.le_def] at h0
  exact Prod.ext (le_antisymm hz1.1 h0.1) (le_antisymm hz2.2 h0.2)

theorem isEffect_inl {a : V} (ha : IsEffect a) : IsEffect ((a, (0 : W)) : V × W) :=
  isEffect_prod_iff.mpr ⟨ha, isEffect_zero⟩

theorem isEffect_inr {b : W} (hb : IsEffect b) : IsEffect (((0 : V), b) : V × W) :=
  isEffect_prod_iff.mpr ⟨isEffect_zero, hb⟩

variable (P : SequentialProductOn (V × W))

/-! ## The non-coupling lemma -/

/-- The restricted product on the first summand. -/
def spFst (a b : V) : V := (P.sp (a, 0) (b, 0)).1

/-- The restricted product on the second summand. -/
def spSnd (a b : W) : W := (P.sp (0, a) (0, b)).2

/-- ★★★ **Elements supported in one summand cannot couple to the other.**  `0 ≤ a ◦' b ≤ a`
squeezes the off-summand component between `0` and `0`. -/
theorem sp_inl_snd_eq_zero {a b : V} (ha : IsEffect a) (hb : IsEffect b) :
    (P.sp ((a, 0) : V × W) (b, 0)).2 = 0 := by
  have hlo := P.sp_nonneg (isEffect_inl ha) (isEffect_inl (W := W) hb)
  have hhi := P.sp_le_left (isEffect_inl ha) (isEffect_inl (W := W) hb)
  rw [Prod.le_def] at hlo hhi
  exact le_antisymm hhi.2 hlo.2

theorem sp_inr_fst_eq_zero {a b : W} (ha : IsEffect a) (hb : IsEffect b) :
    (P.sp (((0 : V), a) : V × W) (0, b)).1 = 0 := by
  have hlo := P.sp_nonneg (isEffect_inr ha) (isEffect_inr (V := V) hb)
  have hhi := P.sp_le_left (isEffect_inr ha) (isEffect_inr (V := V) hb)
  rw [Prod.le_def] at hlo hhi
  exact le_antisymm hhi.1 hlo.1

/-- The product of two first-summand effects, in closed form. -/
theorem sp_inl_eq {a b : V} (ha : IsEffect a) (hb : IsEffect b) :
    P.sp ((a, 0) : V × W) (b, 0) = (P.spFst a b, 0) :=
  Prod.ext rfl (P.sp_inl_snd_eq_zero ha hb)

theorem sp_inr_eq {a b : W} (ha : IsEffect a) (hb : IsEffect b) :
    P.sp (((0 : V), a) : V × W) (0, b) = (0, P.spSnd a b) :=
  Prod.ext (P.sp_inr_fst_eq_zero ha hb) rfl

/-- Compatibility on the first summand is compatibility in the sum. -/
theorem sp_inl_comm {a b : V} (ha : IsEffect a) (hb : IsEffect b)
    (h : P.spFst a b = P.spFst b a) :
    P.sp ((a, 0) : V × W) (b, 0) = P.sp (b, 0) (a, 0) := by
  rw [P.sp_inl_eq ha hb, P.sp_inl_eq hb ha, h]

theorem sp_inr_comm {a b : W} (ha : IsEffect a) (hb : IsEffect b)
    (h : P.spSnd a b = P.spSnd b a) :
    P.sp (((0 : V), a) : V × W) (0, b) = P.sp (0, b) (0, a) := by
  rw [P.sp_inr_eq ha hb, P.sp_inr_eq hb ha, h]

/-! ## The restriction -/

/-- ★★★ **`prop:central`, restriction half.**  An arbitrary S1–S7 product on `V × W` restricts
to an S1–S7 product on the first summand. -/
def restrictFst : SequentialProductOn V where
  sp := P.spFst
  sp_add_right := fun {a b c} ha hb hc hbc => by
    have hbc' : ((b, (0 : W)) : V × W) + (c, 0) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, prod_ousUnit, Prod.le_def]
      exact ⟨hbc, ousUnit_nonneg⟩
    have h := P.sp_add_right (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb)
      (isEffect_inl (W := W) hc) hbc'
    rw [Prod.mk_add_mk, add_zero] at h
    exact congrArg Prod.fst h
  sp_unit_left := fun {a} ha => by
    have hle : ((a, (0 : W)) : V × W) ≤ ((𝟙 : V), (0 : W)) := by
      rw [Prod.le_def]; exact ⟨ha.2, le_rfl⟩
    have h := P.sp_sharp_value_le isSharp_inl_unit (isEffect_inl (W := W) ha) hle
    exact congrArg Prod.fst h
  sp_zero_symm := fun {a b} ha hb h => by
    have hz : P.sp ((a, (0 : W)) : V × W) (b, 0) = 0 := by
      rw [P.sp_inl_eq ha hb, h]; rfl
    have h2 := P.sp_zero_symm (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb) hz
    exact congrArg Prod.fst h2
  sp_assoc_of_compatible := fun {a b c} ha hb hc h => by
    have h2 := P.sp_assoc_of_compatible (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb)
      (isEffect_inl (W := W) hc) (P.sp_inl_comm ha hb h)
    rw [P.sp_inl_eq hb hc, P.sp_inl_eq ha hb] at h2
    exact congrArg Prod.fst h2
  compatible_ortho := fun {a b} ha hb h => by
    -- compatibility with the orthogonal second-summand unit is free
    have hAp : ((a, (0 : W)) : V × W) + (0, 𝟙) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
      exact ⟨ha.2, le_rfl⟩
    have hcompA : P.sp ((a, (0 : W)) : V × W) (0, 𝟙) = P.sp (0, 𝟙) (a, 0) :=
      (P.sp_comm_sharp_orth isSharp_inr_unit (isEffect_inl (W := W) ha) (by
        rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
        exact ⟨ha.2, le_rfl⟩)).symm
    -- compatibility with `(b,0) + (0,𝟙)` by S6b
    have hBp : ((b, (0 : W)) : V × W) + (0, 𝟙) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
      exact ⟨hb.2, le_rfl⟩
    have hsum := P.compatible_add (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb)
      (isEffect_inr (V := V) isEffect_unit) hBp (P.sp_inl_comm ha hb h) hcompA
    -- take the complement of that sum, which is exactly `(𝟙 - b, 0)`
    have hBpe : IsEffect (((b, (0 : W)) : V × W) + (0, 𝟙)) := by
      rw [Prod.mk_add_mk, add_zero, zero_add]
      exact isEffect_prod_iff.mpr ⟨hb, isEffect_unit⟩
    have hres := P.compatible_ortho (isEffect_inl (W := W) ha) hBpe hsum
    have hcompl : (𝟙 : V × W) - (((b, (0 : W)) : V × W) + (0, 𝟙)) = ((𝟙 : V) - b, (0 : W)) := by
      rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.mk_sub_mk, sub_self]
    rw [hcompl] at hres
    exact congrArg Prod.fst hres
  compatible_add := fun {a b c} ha hb hc hbc h h' => by
    have hbc' : ((b, (0 : W)) : V × W) + (c, 0) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, prod_ousUnit, Prod.le_def]
      exact ⟨hbc, ousUnit_nonneg⟩
    have h2 := P.compatible_add (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb)
      (isEffect_inl (W := W) hc) hbc' (P.sp_inl_comm ha hb h) (P.sp_inl_comm ha hc h')
    rw [Prod.mk_add_mk, add_zero] at h2
    exact congrArg Prod.fst h2
  compatible_sp := fun {a b c} ha hb hc h h' => by
    have h2 := P.compatible_sp (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb)
      (isEffect_inl (W := W) hc) (P.sp_inl_comm ha hb h) (P.sp_inl_comm ha hc h')
    rw [P.sp_inl_eq hb hc] at h2
    exact congrArg Prod.fst h2
  sp_effect := fun {a b} ha hb => by
    have h := P.sp_effect (isEffect_inl (W := W) ha) (isEffect_inl (W := W) hb)
    rw [P.sp_inl_eq ha hb, isEffect_prod_iff] at h
    exact h.1

@[simp]
theorem restrictFst_sp (a b : V) : (P.restrictFst (W := W)).sp a b = (P.sp (a, 0) (b, 0)).1 := rfl


/-- **`prop:central`, restriction half, second summand.** -/
def restrictSnd : SequentialProductOn W where
  sp := P.spSnd
  sp_add_right := fun {a b c} ha hb hc hbc => by
    have hbc' : (((0 : V), b) : V × W) + (0, c) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, prod_ousUnit, Prod.le_def]
      exact ⟨ousUnit_nonneg, hbc⟩
    have h := P.sp_add_right (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb)
      (isEffect_inr (V := V) hc) hbc'
    rw [Prod.mk_add_mk, add_zero] at h
    exact congrArg Prod.snd h
  sp_unit_left := fun {a} ha => by
    have hle : (((0 : V), a) : V × W) ≤ ((0 : V), (𝟙 : W)) := by
      rw [Prod.le_def]; exact ⟨le_rfl, ha.2⟩
    have h := P.sp_sharp_value_le isSharp_inr_unit (isEffect_inr (V := V) ha) hle
    exact congrArg Prod.snd h
  sp_zero_symm := fun {a b} ha hb h => by
    have hz : P.sp (((0 : V), a) : V × W) (0, b) = 0 := by
      rw [P.sp_inr_eq ha hb, h]; rfl
    have h2 := P.sp_zero_symm (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb) hz
    exact congrArg Prod.snd h2
  sp_assoc_of_compatible := fun {a b c} ha hb hc h => by
    have h2 := P.sp_assoc_of_compatible (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb)
      (isEffect_inr (V := V) hc) (P.sp_inr_comm ha hb h)
    rw [P.sp_inr_eq hb hc, P.sp_inr_eq ha hb] at h2
    exact congrArg Prod.snd h2
  compatible_ortho := fun {a b} ha hb h => by
    have hcompA : P.sp (((0 : V), a) : V × W) (𝟙, 0) = P.sp (𝟙, 0) (0, a) :=
      (P.sp_comm_sharp_orth isSharp_inl_unit (isEffect_inr (V := V) ha) (by
        rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
        exact ⟨le_rfl, ha.2⟩)).symm
    have hBp : (((0 : V), b) : V × W) + (𝟙, 0) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
      exact ⟨le_rfl, hb.2⟩
    have hsum := P.compatible_add (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb)
      (isEffect_inl (W := W) isEffect_unit) hBp (P.sp_inr_comm ha hb h) hcompA
    have hBpe : IsEffect ((((0 : V), b) : V × W) + (𝟙, 0)) := by
      rw [Prod.mk_add_mk, add_zero, zero_add]
      exact isEffect_prod_iff.mpr ⟨isEffect_unit, hb⟩
    have hres := P.compatible_ortho (isEffect_inr (V := V) ha) hBpe hsum
    have hcompl : (𝟙 : V × W) - ((((0 : V), b) : V × W) + (𝟙, 0)) = ((0 : V), (𝟙 : W) - b) := by
      rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.mk_sub_mk, sub_self]
    rw [hcompl] at hres
    exact congrArg Prod.snd hres
  compatible_add := fun {a b c} ha hb hc hbc h h' => by
    have hbc' : (((0 : V), b) : V × W) + (0, c) ≤ 𝟙 := by
      rw [Prod.mk_add_mk, add_zero, prod_ousUnit, Prod.le_def]
      exact ⟨ousUnit_nonneg, hbc⟩
    have h2 := P.compatible_add (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb)
      (isEffect_inr (V := V) hc) hbc' (P.sp_inr_comm ha hb h) (P.sp_inr_comm ha hc h')
    rw [Prod.mk_add_mk, add_zero] at h2
    exact congrArg Prod.snd h2
  compatible_sp := fun {a b c} ha hb hc h h' => by
    have h2 := P.compatible_sp (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb)
      (isEffect_inr (V := V) hc) (P.sp_inr_comm ha hb h) (P.sp_inr_comm ha hc h')
    rw [P.sp_inr_eq hb hc] at h2
    exact congrArg Prod.snd h2
  sp_effect := fun {a b} ha hb => by
    have h := P.sp_effect (isEffect_inr (V := V) ha) (isEffect_inr (V := V) hb)
    rw [P.sp_inr_eq ha hb, isEffect_prod_iff] at h
    exact h.2

@[simp]
theorem restrictSnd_sp (a b : W) : (P.restrictSnd (V := V)).sp a b = (P.sp (0, a) (0, b)).2 := rfl

/-! ## The two halves are inverse

`prod` (assembly) and `restrict` (restriction) compose to the identity in both directions, so the
row's "conversely summand products assemble" and its restriction clause are genuinely the two
halves of one correspondence and not two unrelated constructions. -/

/-- A pinned product is determined by its operation: the remaining fields are `Prop`s. -/
theorem ext {P Q : SequentialProductOn V} (h : P.sp = Q.sp) : P = Q := by
  cases P; cases Q
  simp only at h
  subst h
  rfl

@[simp]
theorem restrictFst_prod (P : SequentialProductOn V) (Q : SequentialProductOn W) :
    (P.prod Q).restrictFst = P :=
  ext rfl

@[simp]
theorem restrictSnd_prod (P : SequentialProductOn V) (Q : SequentialProductOn W) :
    (P.prod Q).restrictSnd = Q :=
  ext rfl


/-! ## The componentwise formula, with no bridge hypothesis

★★★ `MasterTheorem.Central.central_decomposition` proves the article's `a·b = ∑ a_α·b_α` for a
general central family, but carries the compatibility `a ◦' e_α = e_α ◦' a` and the projection
value `a ◦' e_α = π_α a` as **hypotheses**, on the cited bridge/vdW-5.2 surface.  For a *direct
sum* both are theorems: `OrthFamily`'s `sp_sharp_split_left`/`_right` compute them from S1–S7
alone, because `(𝟙, 0)` splits every effect of `V × W` as "part below it plus part orthogonal to
it", which is exactly that lemma's hypothesis shape. -/

theorem inl_add_inr (A : V × W) : ((A.1, (0 : W)) : V × W) + ((0 : V), A.2) = A := by
  rw [Prod.mk_add_mk, add_zero, zero_add]

/-- ★★★ **An unknown product commutes with the central unit — derived, not imported** — and
reads off the first component. -/
theorem sp_central_inl {A : V × W} (hA : IsEffect A) :
    P.sp A ((𝟙 : V), (0 : W)) = (A.1, 0) ∧ P.sp ((𝟙 : V), (0 : W)) A = (A.1, 0) := by
  obtain ⟨hA1, hA2⟩ := isEffect_prod_iff.mp hA
  have hxp : ((A.1, (0 : W)) : V × W) ≤ ((𝟙 : V), (0 : W)) := by
    rw [Prod.le_def]; exact ⟨hA1.2, le_rfl⟩
  have hyp : (((𝟙 : V), (0 : W)) : V × W) + (0, A.2) ≤ 𝟙 := by
    rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
    exact ⟨le_rfl, hA2.2⟩
  have hxy : ((A.1, (0 : W)) : V × W) + (0, A.2) ≤ 𝟙 := by rw [inl_add_inr]; exact hA.2
  have hL := P.sp_sharp_split_left isSharp_inl_unit (isEffect_inl (W := W) hA1)
    (isEffect_inr (V := V) hA2) hxp hyp hxy
  have hR := P.sp_sharp_split_right isSharp_inl_unit (isEffect_inl (W := W) hA1)
    (isEffect_inr (V := V) hA2) hxp hyp hxy
  rw [inl_add_inr] at hL hR
  exact ⟨hL, hR⟩

theorem sp_central_inr {A : V × W} (hA : IsEffect A) :
    P.sp A ((0 : V), (𝟙 : W)) = (0, A.2) ∧ P.sp ((0 : V), (𝟙 : W)) A = (0, A.2) := by
  obtain ⟨hA1, hA2⟩ := isEffect_prod_iff.mp hA
  have hxp : (((0 : V), A.2) : V × W) ≤ ((0 : V), (𝟙 : W)) := by
    rw [Prod.le_def]; exact ⟨le_rfl, hA2.2⟩
  have hyp : (((0 : V), (𝟙 : W)) : V × W) + (A.1, 0) ≤ 𝟙 := by
    rw [Prod.mk_add_mk, add_zero, zero_add, prod_ousUnit, Prod.le_def]
    exact ⟨hA1.2, le_rfl⟩
  have hxy : (((0 : V), A.2) : V × W) + (A.1, 0) ≤ 𝟙 := by
    rw [Prod.mk_add_mk, add_zero, zero_add]
    exact hA.2
  have hL := P.sp_sharp_split_left isSharp_inr_unit (isEffect_inr (V := V) hA2)
    (isEffect_inl (W := W) hA1) hxp hyp hxy
  have hR := P.sp_sharp_split_right isSharp_inr_unit (isEffect_inr (V := V) hA2)
    (isEffect_inl (W := W) hA1) hxp hyp hxy
  have hcomm : (((0 : V), A.2) : V × W) + (A.1, 0) = A := by
    rw [Prod.mk_add_mk, add_zero, zero_add]
  rw [hcomm] at hL hR
  exact ⟨hL, hR⟩

/-- ★★ **S5 collapses the first argument onto its component.**  Since `(𝟙,0) ◦' (b,0) = (b,0)`
and `A` is compatible with `(𝟙,0)`, associativity gives
`A ◦' (b,0) = (A ◦' (𝟙,0)) ◦' (b,0) = (A.1, 0) ◦' (b,0)`. -/
theorem sp_apply_inl {A : V × W} (hA : IsEffect A) {b : V} (hb : IsEffect b) :
    P.sp A (b, 0) = P.sp (A.1, 0) (b, 0) := by
  obtain ⟨hA1, -⟩ := isEffect_prod_iff.mp hA
  obtain ⟨hAp, hpA⟩ := P.sp_central_inl hA
  have hble : ((b, (0 : W)) : V × W) ≤ ((𝟙 : V), (0 : W)) := by
    rw [Prod.le_def]; exact ⟨hb.2, le_rfl⟩
  have hfix : P.sp ((𝟙 : V), (0 : W)) (b, 0) = (b, 0) :=
    P.sp_sharp_value_le isSharp_inl_unit (isEffect_inl (W := W) hb) hble
  have h := P.sp_assoc_of_compatible hA isSharp_inl_unit.1 (isEffect_inl (W := W) hb)
    (hAp.trans hpA.symm)
  rw [hfix, hAp] at h
  exact h

theorem sp_apply_inr {A : V × W} (hA : IsEffect A) {b : W} (hb : IsEffect b) :
    P.sp A (0, b) = P.sp (0, A.2) (0, b) := by
  obtain ⟨-, hA2⟩ := isEffect_prod_iff.mp hA
  obtain ⟨hAp, hpA⟩ := P.sp_central_inr hA
  have hble : (((0 : V), b) : V × W) ≤ ((0 : V), (𝟙 : W)) := by
    rw [Prod.le_def]; exact ⟨le_rfl, hb.2⟩
  have hfix : P.sp ((0 : V), (𝟙 : W)) (0, b) = (0, b) :=
    P.sp_sharp_value_le isSharp_inr_unit (isEffect_inr (V := V) hb) hble
  have h := P.sp_assoc_of_compatible hA isSharp_inr_unit.1 (isEffect_inr (V := V) hb)
    (hAp.trans hpA.symm)
  rw [hfix, hAp] at h
  exact h

/-- ★★★ **`prop:central` for a direct sum, unconditionally**: on effects, an arbitrary S1–S7
product on `V × W` is exactly the product assembled from its two restrictions.

`a ◦' b = (a₁ ◦'₁ b₁, a₂ ◦'₂ b₂)` — the article's componentwise formula, with **no bridge
hypothesis, no vdW 5.2 citation and no centrality assumption**: S1 splits the second argument,
and `sp_apply_inl` / `sp_apply_inr` (S5 through the derived central compatibility) collapse the
first. -/
theorem sp_componentwise {A B : V × W} (hA : IsEffect A) (hB : IsEffect B) :
    P.sp A B = (P.spFst A.1 B.1, P.spSnd A.2 B.2) := by
  obtain ⟨hA1, hA2⟩ := isEffect_prod_iff.mp hA
  obtain ⟨hB1, hB2⟩ := isEffect_prod_iff.mp hB
  have hsplit := P.sp_add_right hA (isEffect_inl (W := W) hB1) (isEffect_inr (V := V) hB2)
    (by rw [inl_add_inr]; exact hB.2)
  rw [inl_add_inr, P.sp_apply_inl hA hB1, P.sp_apply_inr hA hB2,
    P.sp_inl_eq hA1 hB1, P.sp_inr_eq hA2 hB2, Prod.mk_add_mk, add_zero, zero_add] at hsplit
  exact hsplit

/-- ★★★ **The correspondence is complete on effects**: every S1–S7 product on a direct sum *is*
the assembly of its restrictions.

★ Stated on effects rather than as an equality of structures, and that is not a shortcoming being
hidden: the `sp` field is a total function on `V × W`, while every axiom of `SequentialProductOn`
constrains it **only at effects**.  Off the effect interval two products can differ and both
satisfy S1–S7, so the unrestricted equality is not merely unproved here — it is false in general.
Together with `restrictFst_prod`/`restrictSnd_prod` this is the bijection the row asserts. -/
theorem sp_eq_prod_restrict {A B : V × W} (hA : IsEffect A) (hB : IsEffect B) :
    P.sp A B = ((P.restrictFst).prod (P.restrictSnd)).sp A B :=
  P.sp_componentwise hA hB



/-! ## The `m`-fold direct sum

`prop:central` is stated for `J = ⊕_{α=1}^m J_α`, so the binary case above is a warm-up: this
section redoes it over a finite index type, where the summand inclusions are `Pi.single` and the
central units are `Pi.single i 𝟙`.  Nothing new is needed — the same three `OrthFamily` lemmas
(`sp_sharp_value_le`, `sp_sharp_split_left`, `sp_sharp_split_right`) carry it. -/

section Pi

variable {ι : Type*} [Fintype ι] [DecidableEq ι] {V : ι → Type*} [∀ i, OrderUnitSpace (V i)]

theorem single_le_unit {i : ι} {x : V i} (hx : x ≤ (𝟙 : V i)) :
    Pi.single i x ≤ (𝟙 : ∀ j, V j) := by
  intro j
  rw [pi_ousUnit]
  by_cases hj : j = i
  · subst hj; rw [Pi.single_eq_same]; exact hx
  · rw [Pi.single_eq_of_ne hj]; exact ousUnit_nonneg

theorem isEffect_single {i : ι} {a : V i} (ha : IsEffect a) : IsEffect (Pi.single i a) := by
  rw [isEffect_pi_iff]
  intro j
  by_cases hj : j = i
  · subst hj; rw [Pi.single_eq_same]; exact ha
  · rw [Pi.single_eq_of_ne hj]; exact isEffect_zero

theorem single_le_single {i : ι} {x y : V i} (h : x ≤ y) :
    Pi.single i x ≤ Pi.single (M := V) i y := by
  intro j
  by_cases hj : j = i
  · subst hj; rw [Pi.single_eq_same, Pi.single_eq_same]; exact h
  · exact le_of_eq (by rw [Pi.single_eq_of_ne hj, Pi.single_eq_of_ne hj])

/-- The central unit of the `i`-th summand is sharp. -/
theorem isSharp_single_unit (i : ι) : IsSharp (Pi.single i (𝟙 : V i)) := by
  refine ⟨isEffect_single isEffect_unit, fun z hz hz1 hz2 => ?_⟩
  rw [isEffect_pi_iff] at hz
  funext j
  rw [Pi.zero_apply]
  by_cases hj : j = i
  · subst hj
    have h2 := hz2 j
    rw [Pi.sub_apply, Pi.single_eq_same, pi_ousUnit, sub_self] at h2
    exact le_antisymm h2 (hz j).1
  · have h1 := hz1 j
    rw [Pi.single_eq_of_ne hj] at h1
    exact le_antisymm h1 (hz j).1

variable (P : SequentialProductOn (∀ i, V i))

/-- The restricted product on the `i`-th summand. -/
def spPi (i : ι) (a b : V i) : V i := P.sp (Pi.single i a) (Pi.single i b) i

theorem sp_single_apply_ne {i j : ι} (hj : j ≠ i) {a b : V i}
    (ha : IsEffect a) (hb : IsEffect b) :
    P.sp (Pi.single i a) (Pi.single i b) j = 0 := by
  have hlo := P.sp_nonneg (isEffect_single ha) (isEffect_single hb) j
  have hhi := P.sp_le_left (isEffect_single ha) (isEffect_single hb) j
  rw [Pi.single_eq_of_ne hj] at hhi
  rw [Pi.zero_apply] at hlo
  exact le_antisymm hhi hlo

theorem sp_single_eq {i : ι} {a b : V i} (ha : IsEffect a) (hb : IsEffect b) :
    P.sp (Pi.single i a) (Pi.single i b) = Pi.single i (P.spPi i a b) := by
  funext j
  by_cases hj : j = i
  · subst hj; rw [Pi.single_eq_same]; rfl
  · rw [Pi.single_eq_of_ne hj]; exact P.sp_single_apply_ne hj ha hb

theorem sp_single_comm {i : ι} {a b : V i} (ha : IsEffect a) (hb : IsEffect b)
    (h : P.spPi i a b = P.spPi i b a) :
    P.sp (Pi.single i a) (Pi.single i b) = P.sp (Pi.single i b) (Pi.single i a) := by
  rw [P.sp_single_eq ha hb, P.sp_single_eq hb ha, h]

/-! ### The complement of a central unit -/

theorem single_add_compl_self {i : ι} (x : V i) :
    (Pi.single i x + ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i))) i = x := by
  rw [Pi.add_apply, Pi.sub_apply, Pi.single_eq_same, Pi.single_eq_same, pi_ousUnit, sub_self,
    add_zero]

theorem single_add_compl_ne {i j : ι} (hj : j ≠ i) (x : V i) :
    (Pi.single i x + ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i))) j = (𝟙 : V j) := by
  rw [Pi.add_apply, Pi.sub_apply, Pi.single_eq_of_ne hj, Pi.single_eq_of_ne hj, sub_zero,
    zero_add, pi_ousUnit]

theorem single_add_compl_le {i : ι} {x : V i} (hx : x ≤ (𝟙 : V i)) :
    Pi.single i x + ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i)) ≤ (𝟙 : ∀ j, V j) := by
  intro j
  rw [pi_ousUnit]
  by_cases hj : j = i
  · subst hj; rw [single_add_compl_self]; exact hx
  · rw [single_add_compl_ne hj]

theorem compl_add_single_le {i : ι} {x : V i} (hx : x ≤ (𝟙 : V i)) :
    ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i)) + Pi.single i x ≤ (𝟙 : ∀ j, V j) := by
  rw [add_comm]; exact single_add_compl_le hx

theorem unit_sub_single_add_compl {i : ι} (x : V i) :
    (𝟙 : ∀ j, V j) - (Pi.single i x + ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i)))
      = Pi.single i ((𝟙 : V i) - x) := by
  funext j
  by_cases hj : j = i
  · subst hj
    rw [Pi.sub_apply, single_add_compl_self, Pi.single_eq_same, pi_ousUnit]
  · rw [Pi.sub_apply, single_add_compl_ne hj, Pi.single_eq_of_ne hj, pi_ousUnit, sub_self]

theorem isEffect_single_add_compl {i : ι} {x : V i} (hx : IsEffect x) :
    IsEffect (Pi.single i x + ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i))) := by
  rw [isEffect_pi_iff]
  intro j
  by_cases hj : j = i
  · subst hj; rw [single_add_compl_self]; exact hx
  · rw [single_add_compl_ne hj]; exact isEffect_unit

/-! ### The restriction -/

/-- ★★★ **`prop:central`, restriction half, at the article's own `m`-fold generality.**  An
arbitrary S1–S7 product on `⊕ Jα` restricts to an S1–S7 product on `(Jα, ≤, eα)`. -/
def restrictPi (i : ι) : SequentialProductOn (V i) where
  sp := P.spPi i
  sp_add_right := fun {a b c} ha hb hc hbc => by
    have hbc' : Pi.single i b + Pi.single i c ≤ (𝟙 : ∀ j, V j) := by
      rw [← Pi.single_add]; exact single_le_unit hbc
    have h := P.sp_add_right (isEffect_single ha) (isEffect_single hb) (isEffect_single hc) hbc'
    rw [← Pi.single_add] at h
    exact congrFun h i
  sp_unit_left := fun {a} ha => by
    have h := P.sp_sharp_value_le (isSharp_single_unit i) (isEffect_single ha)
      (single_le_single ha.2)
    have h2 := congrFun h i
    rwa [Pi.single_eq_same] at h2
  sp_zero_symm := fun {a b} ha hb h => by
    have hz : P.sp (Pi.single i a) (Pi.single i b) = 0 := by
      rw [P.sp_single_eq ha hb, h, Pi.single_zero]
    have h2 := P.sp_zero_symm (isEffect_single ha) (isEffect_single hb) hz
    have h3 := congrFun h2 i
    rwa [Pi.zero_apply] at h3
  sp_assoc_of_compatible := fun {a b c} ha hb hc h => by
    have h2 := P.sp_assoc_of_compatible (isEffect_single ha) (isEffect_single hb)
      (isEffect_single hc) (P.sp_single_comm ha hb h)
    rw [P.sp_single_eq hb hc, P.sp_single_eq ha hb] at h2
    exact congrFun h2 i
  compatible_ortho := fun {a b} ha hb h => by
    have hqs : IsSharp ((𝟙 : ∀ j, V j) - Pi.single i (𝟙 : V i)) :=
      IsSharp.compl (isSharp_single_unit i)
    have hcompA :=
      (P.sp_comm_sharp_orth hqs (isEffect_single ha) (compl_add_single_le ha.2)).symm
    have hsum := P.compatible_add (isEffect_single ha) (isEffect_single hb) hqs.1
      (single_add_compl_le hb.2) (P.sp_single_comm ha hb h) hcompA
    have hres := P.compatible_ortho (isEffect_single ha) (isEffect_single_add_compl hb) hsum
    rw [unit_sub_single_add_compl] at hres
    exact congrFun hres i
  compatible_add := fun {a b c} ha hb hc hbc h h' => by
    have hbc' : Pi.single i b + Pi.single i c ≤ (𝟙 : ∀ j, V j) := by
      rw [← Pi.single_add]; exact single_le_unit hbc
    have h2 := P.compatible_add (isEffect_single ha) (isEffect_single hb) (isEffect_single hc)
      hbc' (P.sp_single_comm ha hb h) (P.sp_single_comm ha hc h')
    rw [← Pi.single_add] at h2
    exact congrFun h2 i
  compatible_sp := fun {a b c} ha hb hc h h' => by
    have h2 := P.compatible_sp (isEffect_single ha) (isEffect_single hb) (isEffect_single hc)
      (P.sp_single_comm ha hb h) (P.sp_single_comm ha hc h')
    rw [P.sp_single_eq hb hc] at h2
    exact congrFun h2 i
  sp_effect := fun {a b} ha hb => by
    have h := P.sp_effect (isEffect_single ha) (isEffect_single hb)
    rw [P.sp_single_eq ha hb, isEffect_pi_iff] at h
    have h2 := h i
    rwa [Pi.single_eq_same] at h2


/-! ### The componentwise formula and the round trip, `m`-fold -/

theorem sub_single_self_apply {i : ι} (A : ∀ j, V j) : (A - Pi.single i (A i)) i = 0 := by
  rw [Pi.sub_apply, Pi.single_eq_same, sub_self]

theorem sub_single_self_apply_ne {i j : ι} (hj : j ≠ i) (A : ∀ j, V j) :
    (A - Pi.single i (A i)) j = A j := by
  rw [Pi.sub_apply, Pi.single_eq_of_ne hj, sub_zero]

theorem isEffect_sub_single {i : ι} {A : ∀ j, V j} (hA : IsEffect A) :
    IsEffect (A - Pi.single i (A i)) := by
  rw [isEffect_pi_iff]
  intro j
  by_cases hj : j = i
  · subst hj; rw [sub_single_self_apply]; exact isEffect_zero
  · rw [sub_single_self_apply_ne hj]; exact (isEffect_pi_iff.mp hA) j

theorem single_add_sub_single {i : ι} (A : ∀ j, V j) :
    Pi.single i (A i) + (A - Pi.single i (A i)) = A := by abel

theorem unit_single_add_sub_le {i : ι} {A : ∀ j, V j} (hA : IsEffect A) :
    Pi.single i (𝟙 : V i) + (A - Pi.single i (A i)) ≤ (𝟙 : ∀ j, V j) := by
  intro j
  rw [pi_ousUnit, Pi.add_apply]
  by_cases hj : j = i
  · subst hj
    rw [Pi.single_eq_same, sub_single_self_apply, add_zero]
  · rw [Pi.single_eq_of_ne hj, sub_single_self_apply_ne hj, zero_add]
    exact ((isEffect_pi_iff.mp hA) j).2

/-- ★★★ **An unknown product commutes with each central unit `e_α`, derived.** -/
theorem sp_central_single {A : ∀ j, V j} (hA : IsEffect A) (i : ι) :
    P.sp A (Pi.single i (𝟙 : V i)) = Pi.single i (A i)
      ∧ P.sp (Pi.single i (𝟙 : V i)) A = Pi.single i (A i) := by
  have hAi : IsEffect (A i) := (isEffect_pi_iff.mp hA) i
  have hxy : Pi.single i (A i) + (A - Pi.single i (A i)) ≤ (𝟙 : ∀ j, V j) := by
    rw [single_add_sub_single]; exact hA.2
  have hL := P.sp_sharp_split_left (isSharp_single_unit i) (isEffect_single hAi)
    (isEffect_sub_single hA) (single_le_single hAi.2) (unit_single_add_sub_le hA) hxy
  have hR := P.sp_sharp_split_right (isSharp_single_unit i) (isEffect_single hAi)
    (isEffect_sub_single hA) (single_le_single hAi.2) (unit_single_add_sub_le hA) hxy
  rw [single_add_sub_single] at hL hR
  exact ⟨hL, hR⟩

/-- S5 collapses the first argument onto its `i`-th component. -/
theorem sp_apply_single {A : ∀ j, V j} (hA : IsEffect A) {i : ι} {b : V i} (hb : IsEffect b) :
    P.sp A (Pi.single i b) = P.sp (Pi.single i (A i)) (Pi.single i b) := by
  obtain ⟨hAp, hpA⟩ := P.sp_central_single hA i
  have hfix : P.sp (Pi.single i (𝟙 : V i)) (Pi.single i b) = Pi.single i b :=
    P.sp_sharp_value_le (isSharp_single_unit i) (isEffect_single hb) (single_le_single hb.2)
  have h := P.sp_assoc_of_compatible hA (isSharp_single_unit i).1 (isEffect_single hb)
    (hAp.trans hpA.symm)
  rw [hfix, hAp] at h
  exact h

/-- ★★★ **`prop:central` in full, at the article's `m`-fold generality and with no citation.**

`a ◦' b = ∑_α (a_α ◦'_α b_α)` — S1 splits `b = ∑_α e_α ∘ b` in the second argument, and
`sp_apply_single` collapses the first argument onto its component through the derived central
compatibility.  Combined with `restrictPi` and `pi`, every S1–S7 product on a finite direct sum
is exactly the assembly of its restrictions. -/
theorem sp_componentwise_pi {A B : ∀ j, V j} (hA : IsEffect A) (hB : IsEffect B) :
    P.sp A B = fun i => P.spPi i (A i) (B i) := by
  classical
  have hdecomp : (∑ i, Pi.single i (B i)) = B := Finset.univ_sum_single B
  have hall : (∑ i ∈ (Finset.univ : Finset ι), Pi.single i (B i)) ≤ (𝟙 : ∀ j, V j) := by
    rw [hdecomp]; exact hB.2
  have h := P.sp_sum_right hA
    (fun i _ => isEffect_single ((isEffect_pi_iff.mp hB) i)) hall
  rw [hdecomp] at h
  rw [h, Finset.sum_congr rfl (fun i _ => by
    rw [P.sp_apply_single hA ((isEffect_pi_iff.mp hB) i),
      P.sp_single_eq ((isEffect_pi_iff.mp hA) i) ((isEffect_pi_iff.mp hB) i)] :
      ∀ i ∈ (Finset.univ : Finset ι), P.sp A (Pi.single i (B i))
        = Pi.single i (P.spPi i (A i) (B i)))]
  exact Finset.univ_sum_single _

@[simp]
theorem restrictPi_pi (Q : ∀ i, SequentialProductOn (V i)) (i : ι) :
    (pi Q).restrictPi i = Q i := by
  refine ext (funext fun a => funext fun b => ?_)
  change ((pi Q).sp (Pi.single i a) (Pi.single i b)) i = (Q i).sp a b
  simp only [pi_sp, Pi.single_eq_same]

/-- **The correspondence, `m`-fold**: on effects, an arbitrary product is the assembly of its
restrictions.  (On effects only, for the reason recorded at `sp_eq_prod_restrict`.) -/
theorem sp_eq_pi_restrict {A B : ∀ j, V j} (hA : IsEffect A) (hB : IsEffect B) :
    P.sp A B = (pi (fun i => P.restrictPi i)).sp A B :=
  P.sp_componentwise_pi hA hB

end Pi

end SequentialProductOn
