/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert.Mul
import Mathlib.Analysis.InnerProductSpace.Basic

set_option linter.style.longLine false

/-!
# The trace form on `h₃(𝕆)`, and the Euclidean hypothesis

The inner product `⟪a, b⟫ = Tr(a ∘ b)`, the `NormedAddCommGroup` and `InnerProductSpace ℝ`
instances it induces, and

```
hassoc : ∀ x y z, inner ℝ (jordanBilinO x y) z = inner ℝ y (jordanBilinO x z)
```

## Why `hassoc` is the point of this file

`RadicalRelativity/EJA/Order.lean` (twist tree) carries that associativity as an **explicit
hypothesis** on six declarations -- `inner_mul_self_nonneg_of_idem`, `inner_left_coeff`,
`nonneg_coeff_of_inner_nonneg`, `nonneg_coeff_of_isSoS`, `isArchimedean_ofBilinear`,
`isSoS_iff_exists_sq` -- and its module docstring says outright that the Euclidean hypothesis
is "carried, not derived".  It is Faraut-Korányi's definition of a *Euclidean* Jordan algebra
(FK III.1).  The statement here is spelled to match that hypothesis token for token, so
supplying it there is passing an argument rather than reconciling two spellings.

## How it is proved, and what it does *not* need

Not by brute force.  Unfolding both sides to real coordinates gives a degree-3 identity in 81
variables; `ring` on it times out at 2 000 000 heartbeats.  The identity's actual shape is
much smaller: after expanding the trace form, the diagonal and scalar parts match on the nose
and the whole content is **six rotations of a conjugated octonionic triple**, i.e. six
instances of `Octonion.octIp_conj_cyc`/`octIp_conj_cyc'`, which are corollaries of
`re_mul_assoc` and `re_mul_comm` from `RadicalRelativity/OctonionTrace.lean`.  The proof runs
at the default heartbeat budget.

★ In particular `hassoc` does **not** consume the Jordan identity, formal reality, or any
spectral input.  It is exactly what `OctonionTrace.lean` was built to make cheap.  The Jordan
identity and formal reality are proved downstream, in `Albert/Jordan.lean`, on top of this
file rather than alongside it.

## Main definitions

* `traceForm` -- `⟪a, b⟫ = Tr(a ∘ b)`, written out
* the `Inner ℝ`, `NormedAddCommGroup`, `InnerProductSpace ℝ` instances on `h3O`

## Main results

* `traceForm_eq_trace_jordanMul` -- the form really is the trace of the Jordan product
* `hassoc` -- the Euclidean hypothesis, in `EJA/Order.lean`'s spelling
-/

noncomputable section

namespace RadicalRelativity.Albert

open Octonion

namespace h3O

/-- The trace of a hermitian octonionic matrix. -/
def trace (a : h3O) : ℝ := a.diag 0 + a.diag 1 + a.diag 2

/-- The **trace form** `⟪a, b⟫ = Tr(a ∘ b)`, written out.  The off-diagonal entries carry a
factor `2` because each octonionic entry of a hermitian matrix stands for two matrix entries,
`x` and `x*`. -/
def traceForm (a b : h3O) : ℝ :=
  a.diag 0 * b.diag 0 + a.diag 1 * b.diag 1 + a.diag 2 * b.diag 2
    + 2 * (octIp (a.off 0) (b.off 0) + octIp (a.off 1) (b.off 1) + octIp (a.off 2) (b.off 2))

/-- The trace form is the trace of the Jordan product -- the identity that makes `hassoc`
the statement that `Tr((x ∘ y) ∘ z)` is symmetric. -/
theorem traceForm_eq_trace_jordanMul (a b : h3O) : traceForm a b = trace (jordanMul a b) := by
  simp only [traceForm, trace, jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two]
  ring

theorem traceForm_comm (a b : h3O) : traceForm a b = traceForm b a := by
  simp only [traceForm, octIp_comm (b.off 0) (a.off 0), octIp_comm (b.off 1) (a.off 1),
    octIp_comm (b.off 2) (a.off 2)]
  ring

theorem traceForm_add_left (a b c : h3O) :
    traceForm (a + b) c = traceForm a c + traceForm b c := by
  simp only [traceForm, add_diag, add_off, octIp_add_left]
  ring

theorem traceForm_smul_left (r : ℝ) (a b : h3O) :
    traceForm (r • a) b = r * traceForm a b := by
  simp only [traceForm, smul_diag, smul_off, octIp_smul_left]
  ring

theorem traceForm_self_nonneg (a : h3O) : 0 ≤ traceForm a a := by
  simp only [traceForm]
  linarith [mul_self_nonneg (a.diag 0), mul_self_nonneg (a.diag 1), mul_self_nonneg (a.diag 2),
    octIp_self_nonneg (a.off 0), octIp_self_nonneg (a.off 1), octIp_self_nonneg (a.off 2)]

theorem traceForm_self_eq_zero {a : h3O} (h : traceForm a a = 0) : a = 0 := by
  simp only [traceForm] at h
  have h0 := mul_self_nonneg (a.diag 0)
  have h1 := mul_self_nonneg (a.diag 1)
  have h2 := mul_self_nonneg (a.diag 2)
  have k0 := octIp_self_nonneg (a.off 0)
  have k1 := octIp_self_nonneg (a.off 1)
  have k2 := octIp_self_nonneg (a.off 2)
  refine ext_six ?_ ?_ ?_ ?_ ?_ ?_ <;> simp only [zero_diag, zero_off]
  · exact mul_self_eq_zero.mp (by linarith)
  · exact mul_self_eq_zero.mp (by linarith)
  · exact mul_self_eq_zero.mp (by linarith)
  · exact octIp_self_eq_zero (by linarith)
  · exact octIp_self_eq_zero (by linarith)
  · exact octIp_self_eq_zero (by linarith)

/-! ## The Euclidean hypothesis

`⟪x ∘ y, z⟫ = ⟪y, x ∘ z⟫`.  Since the trace form is symmetric and the Jordan product is
commutative, this says the trilinear form `Tr((x ∘ y) ∘ z)` is symmetric in its last two
slots.  Expanding both sides, the diagonal terms and the scalar-times-`octIp` terms match term
by term, and the six octonionic terms match under cyclic rotation. -/

/-- **The Euclidean hypothesis, on the bare product.**  `hassoc` below is this statement in the
inner-product vocabulary `EJA/Order.lean` uses. -/
theorem traceForm_jordanMul_assoc (x y z : h3O) :
    traceForm (jordanMul x y) z = traceForm y (jordanMul x z) := by
  rw [traceForm_comm y (jordanMul x z)]
  simp only [traceForm, jordanMul_diag_zero, jordanMul_diag_one, jordanMul_diag_two,
    jordanMul_off_zero, jordanMul_off_one, jordanMul_off_two, octIp_add_left, octIp_smul_left]
  linear_combination
    (x.diag 1 + x.diag 2) * octIp_comm (y.off 0) (z.off 0)
    + (x.diag 0 + x.diag 2) * octIp_comm (y.off 1) (z.off 1)
    + (x.diag 0 + x.diag 1) * octIp_comm (y.off 2) (z.off 2)
    + octIp_conj_cyc' (x.off 1) (y.off 2) (z.off 0)
    + octIp_conj_cyc (y.off 1) (x.off 2) (z.off 0)
    + octIp_conj_cyc' (x.off 2) (y.off 0) (z.off 1)
    + octIp_conj_cyc (y.off 2) (x.off 0) (z.off 1)
    + octIp_conj_cyc' (x.off 0) (y.off 1) (z.off 2)
    + octIp_conj_cyc (y.off 0) (x.off 1) (z.off 2)

/-! ## The inner product space -/

instance instInner : Inner ℝ h3O := ⟨traceForm⟩

theorem inner_def (a b : h3O) : inner ℝ a b = traceForm a b := rfl

instance instNormedAddCommGroup : NormedAddCommGroup h3O :=
  @InnerProductSpace.Core.toNormedAddCommGroup ℝ h3O _ _ _
    { toInner := inferInstance
      conj_inner_symm := fun x y => by
        simpa only [starRingEnd_apply, star_trivial, inner_def] using traceForm_comm y x
      re_inner_nonneg := fun x => by
        simpa only [RCLike.re_to_real, inner_def] using traceForm_self_nonneg x
      definite := fun _ h => traceForm_self_eq_zero h
      add_left := fun x y z => traceForm_add_left x y z
      smul_left := fun x y r => by
        simpa only [starRingEnd_apply, star_trivial, inner_def] using
          traceForm_smul_left r x y }

instance instInnerProductSpace : InnerProductSpace ℝ h3O := InnerProductSpace.ofCore _

/-- **The Euclidean hypothesis**, spelled exactly as `EJA/Order.lean` carries it:
`(hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))` at `m := jordanBilinO`. -/
theorem hassoc (x y z : h3O) :
    inner ℝ (jordanBilinO x y) z = inner ℝ y (jordanBilinO x z) :=
  traceForm_jordanMul_assoc x y z

end h3O

end RadicalRelativity.Albert
