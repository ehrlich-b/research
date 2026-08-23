/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert.Inner
import Mathlib.Algebra.Jordan.Basic

set_option linter.style.longLine false

/-!
# The Jordan identity on `h₃(𝕆)`

`Albert/Mul.lean` builds the product `a ∘ b = ½(ab + ba)` and proves it commutative with unit
`1`; `Albert/Inner.lean` proves the Euclidean hypothesis `⟪x ∘ y, z⟫ = ⟪y, x ∘ z⟫`.  What was
left over is the **Jordan identity** `(a ∘ b) ∘ a² = a ∘ (b ∘ a²)`.  It is proved here as
`jordanMul_jordan`, and Mathlib's `IsCommJordan h3O` is installed on the back of it.

## Shape of the proof

The identity is cubic in `a` and linear in `b`, so in the 54 real coordinates of `(a, b)` it is
a degree-4 polynomial identity; it is not expanded there.  Instead the two sides are subtracted
component by component in the layout of `Albert/Carrier.lean`, and each component difference is
an `ℝ`-linear combination -- with coefficients built from the diagonal entries and from `octIp`
-- of octonionic identities:

* the diagonal components use `octIp_conj_cyc` and `octIp_conj_cyc'` of `Albert/Carrier.lean`
  together with `octIp_mul_conj_left`, `octIp_mul_conj_right`, `octIp_conj_mul_assoc_left` and
  `octIp_conj_mul_assoc_right` below;
* the off-diagonal components use `polar_left_alt`, `polar_right_alt`, `polar_moufang`,
  `mixed_moufang_left` and `mixed_moufang_right` below.

Those nine, plus the two cyclic-rotation lemmas of `Albert/Carrier.lean`, are the only
octonionic identities the assembly consumes; the normalisation ahead of it additionally uses
bilinearity of the octonion product and `conj_mul`.  Each of the nine is proved by expanding
the multiplication table of `Octonions.lean`; six close at the default heartbeat budget and the
three quartic ones carry an eight-fold budget.  `linear_combination` then does the assembly, `simp only` having first
distributed the products and pushed conjugation onto the variables with `conj_mul`; the
`octIp_comm` instances in those `simp only` lists do nothing but orient the inner products, so
that the goal and the supplied identities present `ring` with the same atoms.

Only two of the six components are proved directly.  `cyc` is the cyclic shift of both index
families, and `jordanMul_cyc` says it commutes with the product; that carries
`jordan_diag_zero` and `jordan_off_zero` onto the remaining four.

## Main results

* `jordanMul_jordan` -- the Jordan identity on `h₃(𝕆)`
* `instIsCommJordan` -- `h₃(𝕆)` as a `CommMagma` satisfying Mathlib's `IsCommJordan`
* `eq_zero_of_sum_sq_eq_zero` -- formal reality in sum-of-squares form, which the trace form of
  `Albert/Inner.lean` already forces
-/

noncomputable section

namespace Octonion

/-! ## Octonionic input

Nine identities.  Each is a polynomial identity in the coordinates of the octonion
multiplication table and is proved by expanding it; none of them is assumed.
-/

/-- Polarised left alternativity: `x̄(xw) = N(x)w` linearised in `x`. -/
theorem polar_left_alt (u v w : Octonion) :
    mul (conj u) (mul v w) + mul (conj v) (mul u w) = (2 * octIp u v) • w := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

/-- Polarised right alternativity: `(wx)x̄ = N(x)w` linearised in `x`. -/
theorem polar_right_alt (u v w : Octonion) :
    mul (mul w u) (conj v) + mul (mul w v) (conj u) = (2 * octIp u v) • w := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

/-- `⟨x̄ā, x̄b̄⟩ = N(x)⟨a,b⟩`. -/
theorem octIp_mul_conj_left (u a b : Octonion) :
    octIp (mul (conj u) (conj a)) (mul (conj u) (conj b)) = octIp u u * octIp a b := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

/-- `⟨āx̄, b̄x̄⟩ = ⟨a,b⟩N(x)`. -/
theorem octIp_mul_conj_right (a b u : Octonion) :
    octIp (mul (conj a) (conj u)) (mul (conj b) (conj u)) = octIp a b * octIp u u := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

/-- `⟨(ba)c̄, b⟩ = N(b)⟨a,c⟩`, the shape `(ā b̄)* c̄` takes once `conj_mul` has been applied. -/
theorem octIp_conj_mul_assoc_left (a b c : Octonion) :
    octIp (mul (mul b a) (conj c)) b = octIp b b * octIp a c := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

/-- `⟨c̄(ab), b⟩ = N(b)⟨a,c⟩`, the shape `c̄ (b̄ ā)*` takes once `conj_mul` has been applied. -/
theorem octIp_conj_mul_assoc_right (a b c : Octonion) :
    octIp (mul (conj c) (mul a b)) b = octIp b b * octIp a c := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

set_option maxHeartbeats 1600000 in
/-- Polarised middle Moufang. -/
theorem polar_moufang (p q r s : Octonion) :
    mul (mul p r) (mul q s) + mul (mul s r) (mul q p)
        + (4 * octIp p s) • mul (conj q) (conj r)
      = mul (mul s (mul (conj p) (conj q))) (conj r)
        + mul (conj q) (mul (mul (conj r) (conj p)) s)
        + (4 * octIp (mul (conj q) (conj r)) s) • p := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

set_option maxHeartbeats 1600000 in
/-- Mixed Moufang, left form. -/
theorem mixed_moufang_left (p q r s : Octonion) :
    mul (mul p r) (mul s p) + (2 * octIp q s) • mul (conj q) (conj r)
        + (octIp p p - octIp q q) • mul (conj s) (conj r)
      = mul (conj q) (mul s (mul (conj q) (conj r)))
        + (2 * octIp (mul (conj r) (conj p)) s) • p := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

set_option maxHeartbeats 1600000 in
/-- Mixed Moufang, right form. -/
theorem mixed_moufang_right (p q r s : Octonion) :
    mul (mul p s) (mul q p) + (2 * octIp r s) • mul (conj q) (conj r)
        + (octIp p p - octIp r r) • mul (conj q) (conj s)
      = mul (mul (mul (conj q) (conj r)) s) (conj r)
        + (2 * octIp (mul (conj p) (conj q)) s) • p := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

end Octonion

namespace RadicalRelativity.Albert

open Octonion

namespace h3O

/-! ## The cyclic shift

In the layout of `Albert/Carrier.lean`, shifting both index families by one is the map induced
by conjugating a hermitian matrix with the cyclic permutation matrix.  Only the one property
proved below is used: it commutes with the Jordan product.  That is what lets the two component
identities cover all six components.
-/

/-- The cyclic index shift, written with the same `if` cascade as `jordanMul` so that its six
projections hold by `rfl`. -/
def cyc (a : h3O) : h3O :=
  ⟨fun k => if k.val = 0 then a.diag 1 else if k.val = 1 then a.diag 2 else a.diag 0,
   fun k => if k.val = 0 then a.off 1 else if k.val = 1 then a.off 2 else a.off 0⟩

@[simp] theorem cyc_diag_zero (a : h3O) : (cyc a).diag 0 = a.diag 1 := rfl
@[simp] theorem cyc_diag_one (a : h3O) : (cyc a).diag 1 = a.diag 2 := rfl
@[simp] theorem cyc_diag_two (a : h3O) : (cyc a).diag 2 = a.diag 0 := rfl
@[simp] theorem cyc_off_zero (a : h3O) : (cyc a).off 0 = a.off 1 := rfl
@[simp] theorem cyc_off_one (a : h3O) : (cyc a).off 1 = a.off 2 := rfl
@[simp] theorem cyc_off_two (a : h3O) : (cyc a).off 2 = a.off 0 := rfl

/-- The cyclic shift commutes with the Jordan product. -/
@[simp] theorem jordanMul_cyc (a b : h3O) :
    jordanMul (cyc a) (cyc b) = cyc (jordanMul a b) := by
  refine ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
      jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
      cyc_diag_zero, cyc_diag_one, cyc_diag_two, cyc_off_zero, cyc_off_one, cyc_off_two] <;>
    first
      | ring1
      | module

/-! ## The two component identities -/

/-- The diagonal `(1,1)` component of the Jordan identity. -/
theorem jordan_diag_zero (a b : h3O) :
    (jordanMul (jordanMul a b) (jordanMul a a)).diag 0
      = (jordanMul a (jordanMul b (jordanMul a a))).diag 0 := by
  simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
    jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
    octIp_add_left, octIp_add_right, octIp_smul_left, octIp_smul_right,
    conj_add, conj_smul, conj_mul, conj_conj,
    mul_add', add_mul', smul_mul, mul_smul',
    octIp_comm (mul (conj (a.off 0)) (conj (b.off 1))) (mul (conj (a.off 0)) (conj (a.off 1))),
    octIp_comm (mul (conj (a.off 2)) (conj (b.off 0))) (mul (conj (a.off 2)) (conj (a.off 0))),
    octIp_comm (mul (conj (b.off 0)) (conj (a.off 1))) (mul (conj (a.off 0)) (conj (a.off 1))),
    octIp_comm (mul (conj (b.off 2)) (conj (a.off 0))) (mul (conj (a.off 2)) (conj (a.off 0))),
    octIp_comm (a.off 1) (mul (mul (a.off 1) (a.off 0)) (conj (b.off 0))),
    octIp_comm (a.off 1) (mul (conj (a.off 2)) (conj (b.off 0))),
    octIp_comm (a.off 1) (mul (conj (b.off 2)) (mul (a.off 2) (a.off 1))),
    octIp_comm (a.off 1) (mul (conj (b.off 2)) (conj (a.off 0))),
    octIp_comm (a.off 2) (mul (mul (a.off 2) (a.off 1)) (conj (b.off 1))),
    octIp_comm (a.off 2) (mul (conj (a.off 0)) (conj (b.off 1))),
    octIp_comm (a.off 2) (mul (conj (b.off 0)) (mul (a.off 0) (a.off 2))),
    octIp_comm (a.off 2) (mul (conj (b.off 0)) (conj (a.off 1))),
    octIp_comm (b.off 1) (mul (conj (a.off 2)) (conj (a.off 0))),
    octIp_comm (b.off 1) (a.off 1),
    octIp_comm (b.off 2) (mul (conj (a.off 0)) (conj (a.off 1))),
    octIp_comm (b.off 2) (a.off 2)]
  linear_combination
    ((a.diag 1 - a.diag 0) / 2) * octIp_conj_cyc' (a.off 0) (a.off 1) (b.off 2)
    + ((a.diag 0 - a.diag 2) / 2) * octIp_conj_cyc' (a.off 0) (b.off 1) (a.off 2)
    + ((a.diag 2 - a.diag 1) / 2) * octIp_conj_cyc (a.off 2) (b.off 0) (a.off 1)
    - (1 / 2 : ℝ) * octIp_conj_mul_assoc_left (a.off 0) (a.off 1) (b.off 0)
    - (1 / 2 : ℝ) * octIp_conj_mul_assoc_left (a.off 1) (a.off 2) (b.off 1)
    + (1 / 2 : ℝ) * octIp_mul_conj_left (a.off 0) (a.off 1) (b.off 1)
    + (1 / 2 : ℝ) * octIp_mul_conj_right (a.off 0) (b.off 0) (a.off 1)
    + (1 / 2 : ℝ) * octIp_mul_conj_left (a.off 2) (a.off 0) (b.off 0)
    + (1 / 2 : ℝ) * octIp_mul_conj_right (a.off 2) (b.off 2) (a.off 0)
    - (1 / 2 : ℝ) * octIp_conj_mul_assoc_right (a.off 0) (a.off 2) (b.off 0)
    - (1 / 2 : ℝ) * octIp_conj_mul_assoc_right (a.off 2) (a.off 1) (b.off 2)

/-- The off-diagonal `x₁` component of the Jordan identity. -/
theorem jordan_off_zero (a b : h3O) :
    (jordanMul (jordanMul a b) (jordanMul a a)).off 0
      = (jordanMul a (jordanMul b (jordanMul a a))).off 0 := by
  simp only [jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
    jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two,
    octIp_add_right, octIp_smul_right,
    conj_add, conj_smul, conj_mul, conj_conj,
    mul_add', add_mul', smul_mul, mul_smul',
    octIp_comm (b.off 0) (mul (conj (a.off 1)) (conj (a.off 2))),
    octIp_comm (b.off 0) (a.off 0),
    octIp_comm (b.off 1) (mul (conj (a.off 2)) (conj (a.off 0))),
    octIp_comm (b.off 1) (a.off 1),
    octIp_comm (b.off 2) (mul (conj (a.off 0)) (conj (a.off 1))),
    octIp_comm (b.off 2) (a.off 2)]
  linear_combination (norm := module)
    (1 / 4 : ℝ) • polar_moufang (a.off 0) (a.off 1) (a.off 2) (b.off 0)
    + (1 / 4 : ℝ) • mixed_moufang_left (a.off 0) (a.off 1) (a.off 2) (b.off 1)
    + (1 / 4 : ℝ) • mixed_moufang_right (a.off 0) (a.off 1) (a.off 2) (b.off 2)
    + ((a.diag 0 - a.diag 1) / 4) • polar_left_alt (a.off 1) (b.off 1) (a.off 0)
    + ((a.diag 0 - a.diag 2) / 4) • polar_right_alt (a.off 2) (b.off 2) (a.off 0)
    + ((b.diag 1 - b.diag 2) / 8) • polar_right_alt (a.off 2) (a.off 2) (a.off 0)
    - ((b.diag 1 - b.diag 2) / 8) • polar_left_alt (a.off 1) (a.off 1) (a.off 0)

/-! ## The remaining four components, by the cyclic automorphism -/

theorem jordan_diag_one (a b : h3O) :
    (jordanMul (jordanMul a b) (jordanMul a a)).diag 1
      = (jordanMul a (jordanMul b (jordanMul a a))).diag 1 := by
  simpa only [jordanMul_cyc, cyc_diag_zero] using jordan_diag_zero (cyc a) (cyc b)

theorem jordan_diag_two (a b : h3O) :
    (jordanMul (jordanMul a b) (jordanMul a a)).diag 2
      = (jordanMul a (jordanMul b (jordanMul a a))).diag 2 := by
  simpa only [jordanMul_cyc, cyc_diag_zero, cyc_diag_one] using
    jordan_diag_zero (cyc (cyc a)) (cyc (cyc b))

theorem jordan_off_one (a b : h3O) :
    (jordanMul (jordanMul a b) (jordanMul a a)).off 1
      = (jordanMul a (jordanMul b (jordanMul a a))).off 1 := by
  simpa only [jordanMul_cyc, cyc_off_zero] using jordan_off_zero (cyc a) (cyc b)

theorem jordan_off_two (a b : h3O) :
    (jordanMul (jordanMul a b) (jordanMul a a)).off 2
      = (jordanMul a (jordanMul b (jordanMul a a))).off 2 := by
  simpa only [jordanMul_cyc, cyc_off_zero, cyc_off_one] using
    jordan_off_zero (cyc (cyc a)) (cyc (cyc b))

/-! ## The Jordan identity and the `IsCommJordan` instance -/

/-- **The Jordan identity on `h₃(𝕆)`**: `(a ∘ b) ∘ a² = a ∘ (b ∘ a²)`. -/
theorem jordanMul_jordan (a b : h3O) :
    jordanMul (jordanMul a b) (jordanMul a a)
      = jordanMul a (jordanMul b (jordanMul a a)) :=
  ext_six (jordan_diag_zero a b) (jordan_diag_one a b) (jordan_diag_two a b)
    (jordan_off_zero a b) (jordan_off_one a b) (jordan_off_two a b)

/-- The Jordan product as Mathlib's `CommMagma`.  This is the only `Mul h3O` in the tree; it
carries no additive data, so it does not reintroduce the `AddCommGroup` diamond that
`Albert/Mul.lean` bundles the product to avoid. -/
instance instCommMagma : CommMagma h3O where
  mul := jordanMul
  mul_comm := jordanMul_comm

theorem mul_eq_jordanMul (a b : h3O) : a * b = jordanMul a b := rfl

/-- **`h₃(𝕆)` is a commutative Jordan algebra**, in Mathlib's own class. -/
instance instIsCommJordan : IsCommJordan h3O where
  lmul_comm_rmul_rmul a b := jordanMul_jordan a b

/-! ## Formal reality

Nothing octonionic is left to do here: the trace form of `Albert/Inner.lean` is already positive
definite and is already the trace of the Jordan product, so a vanishing sum of squares has
vanishing trace term by term.
-/

theorem trace_add (a b : h3O) : trace (a + b) = trace a + trace b := by
  simp only [trace, add_diag]; ring

@[simp] theorem trace_zero : trace (0 : h3O) = 0 := by simp [trace]

theorem trace_sum {ι : Type*} (s : Finset ι) (f : ι → h3O) :
    trace (∑ i ∈ s, f i) = ∑ i ∈ s, trace (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, trace_add, ih]

/-- **Formal reality**, in the sum-of-squares form: if a finite sum of squares vanishes then
every summand does. -/
theorem eq_zero_of_sum_sq_eq_zero {ι : Type*} {s : Finset ι} {v : ι → h3O}
    (h : ∑ i ∈ s, jordanMul (v i) (v i) = 0) {i : ι} (hi : i ∈ s) : v i = 0 := by
  have hsum : ∑ j ∈ s, traceForm (v j) (v j) = 0 := by
    have h1 : ∑ j ∈ s, traceForm (v j) (v j) = trace (∑ j ∈ s, jordanMul (v j) (v j)) := by
      rw [trace_sum]
      exact Finset.sum_congr rfl fun j _ => traceForm_eq_trace_jordanMul (v j) (v j)
    rw [h1, h, trace_zero]
  exact traceForm_self_eq_zero
    ((Finset.sum_eq_zero_iff_of_nonneg fun j _ => traceForm_self_nonneg (v j)).mp hsum i hi)

/-- The single-square form, `a ∘ a = 0 → a = 0`. -/
theorem eq_zero_of_sq_eq_zero {a : h3O} (h : jordanMul a a = 0) : a = 0 :=
  traceForm_self_eq_zero (by rw [traceForm_eq_trace_jordanMul, h, trace_zero])

end h3O

end RadicalRelativity.Albert
