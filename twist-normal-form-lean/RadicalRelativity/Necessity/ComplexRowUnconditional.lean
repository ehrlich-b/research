/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Necessity.UnitaryGeneration

set_option linter.style.longLine false

/-!
# The complex row, UNCONDITIONAL  (`mthm:master` at `H_N(ℂ)`, `N ≥ 3`, hypothesis-free)

`ComplexMaster.complex_classification` proves the complex row conditional on the manuscript's
two frame-graph facts, carried as located hypotheses: a caller-supplied adjacency relation, its
connectivity (`lem:frame-connectivity`), and the cross-coherence overlap of adjacent frames'
`U(1)` characters.  **Both are now theorems of this development.**

* `frameTwistConst` — `frameTwist` is constant: `FrameConstancy.frameTwist_eq_of_adjAxis`
  supplies coherence for one adjacency step, `UnitaryGeneration.adjAxis_connected` supplies the
  walk, and `Globalization.const_of_adjacent` chains them.
* `complex_classification_unconditional` — **THE COMPLEX ROW.**  Every S1–S7 sequential product
  with S2 on `H_N(ℂ)`, `N ≥ 3`, is `a • b = a^{1/2+it} b a^{1/2−it}` for a **unique** real `t`,
  on all effects.

The hypothesis list is now exactly the paper's: an S1–S7 product, S2, and `N ≥ 3`.  Closure is
Lean core alone (`propext`, `Classical.choice`, `Quot.sound`), as it already was for the
conditional form — what changed is not the axiom closure but the *carried hypotheses*.

**The `Adj := True` step is not circular, and the ordering is what makes it so.**  A reader who
sees `complex_classification_of_frameTwistConst` instantiate the adjacency trivially may suspect
connectivity has been assumed away.  It has not: constancy of `frameTwist` is established
*first* and independently, from the genuine `AdjAxis` walk (`frameTwistConst` below, resting on
`adjAxis_connected`, which is proved from a Householder factorization and is *false* for a
trivial relation — `AdjAxis` does not hold of all pairs).  Only afterwards is the capstone reused
with the cheapest possible adjacency, at which point the frame graph plays no role because the
conclusion it would have delivered is already in hand.

**What `a^{1/2+it}` means at singular `a`.**  `twistFactor` is the continuous functional calculus
of `x ↦ √x·cos(t log x)` and `x ↦ √x·sin(t log x)`.  Under Lean's convention `Real.log 0 = 0`
these vanish at `0`, so the factor is `0` on `a`'s kernel — the intended continuous extension of
`a^{1/2+it}`, which is what makes the singular case meaningful at all.

Both flagship rows of `mthm:master` are now hypothesis-free: this one and
`RealRowUnconditional.real_classification`.
-/

noncomputable section

open ComplexOrder
open scoped Matrix
open OrderUnitSpace

namespace Necessity

variable {N : ℕ}

/-- **The per-frame twist parameter is constant** — the complex row's whole residue,
discharged.

One adjacency step is `frameTwist_eq_of_adjAxis`: axis-adjacent frames share a one-parameter
family of base points, and comparing the product's value along that family pins the two
parameters to each other exactly.  Any two frames are joined by a walk of three such steps
(`adjAxis_connected`, from the Householder factorization of `F⁻¹G`), and a real assignment
constant across adjacent pairs is constant along a walk. -/
theorem frameTwistConst (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ))
    (hS2 : P.FirstArgContinuous) :
    FrameTwistConst hN P hS2 := by
  intro F G
  exact MasterTheorem.Globalization.const_of_adjacent
    (Adj := AdjAxis) (t := frameTwist hN P hS2)
    (fun _ _ hadj => frameTwist_eq_of_adjAxis hN P hS2 hadj)
    (adjAxis_connected hN F G)

/-- **`mthm:master`, THE COMPLEX ROW — UNCONDITIONAL.**

For every S1–S7 sequential product with S2 on `H_N(ℂ)`, `N ≥ 3`, there is a **unique** real `t`
with

`a • b = a^{1/2+it} · b · a^{1/2−it}`

for **all** effects `a, b`, singular ones included.

Conditional on nothing beyond the paper's own hypotheses.  The frame-graph facts that
`complex_classification` carried — connectivity of the unitary frame graph and cross-coherence
of adjacent frames' characters — are discharged by `frameTwistConst`. -/
theorem complex_classification_unconditional (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ))
    (hS2 : P.FirstArgContinuous) :
    ∃! t : ℝ, ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq t a b :=
  complex_classification_of_frameTwistConst hN P hS2 (frameTwistConst hN P hS2)

/-! ## Non-vacuity, certified in-tree

A theorem quantified over a hypothesis class says nothing if the class is empty, and a theorem
producing a parameter says little if the parameter need not be the intended one.  Both are
checked here against a known member of the class.
-/

/-- **The hypothesis class is inhabited.**  M1's twist product with parameter `t` is an S1–S7
product with S2 on `H_N(ℂ)`, so the capstone applies to it: `3 ≤ N`, `SequentialProductOn`, and
`FirstArgContinuous` are simultaneously satisfiable, and the row is not vacuous. -/
theorem twistProductOn_classified (hN : 3 ≤ N) (t : ℝ) :
    ∃! t' : ℝ, ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      (twistProductOn t).sp a b = HermitianMat.twistSeq t' a b :=
  complex_classification_unconditional hN (twistProductOn t)
    (twistProductOn_firstArgContinuous t)

/-- **The recovered parameter is the intended one.**  Run the capstone on the twist product with
parameter `t` and the unique `t'` it returns is `t` itself.  So the classification is sharp: the
twist family is faithfully parameterized, and the `∃!` is not satisfied by some unrelated
value. -/
theorem complex_classification_sharp (hN : 3 ≤ N) (t t' : ℝ) :
    (∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
        (twistProductOn t).sp a b = HermitianMat.twistSeq t' a b)
      ↔ t' = t := by
  constructor
  · intro h
    refine (twist_param_unique (N := N) (by omega) (fun a b ha hb => ?_)).symm
    rw [← twistProductOn_sp t a b]
    exact h a b ha hb
  · intro h a b _ _
    rw [h, twistProductOn_sp]

/-! ## `cor:selectors`, clause (ii): trace-form symmetry selects the Lüders product

The article's `cor:selectors` gives three sufficient conditions for the classified
complex-type product to be the Lüders product (`t = 0`).  Clause (ii) is trace-form
symmetry, `⟪a · b, c⟫ = ⟪b, a · c⟫`, and it is proved here at the article's own
generality — `H_N(ℂ)` with `N ≥ 3`, an S1–S7 product, and S2, exactly the hypotheses
of the classification it consumes.

The mechanism is that the twist product's *own* trace adjoint flips the twist:
`⟪a^{1/2+it} b a^{1/2-it}, c⟫ = ⟪b, a^{1/2-it} c a^{1/2+it}⟫` by cyclicity of the
trace (`inner_twistSeq_left`).  So trace symmetry says the product is represented by
`-t` as well as by `t`, and the `∃!` of `complex_classification_unconditional` closes
it: `-t = t`.  No new analysis is involved; the selector is a corollary of uniqueness.

★ **CORRECTED.**  This paragraph used to open "**Clauses (i) and (iii) are NOT proved
here**".  Both are now proved here, further down this same file: clause (iii) as
`selector_transpose` (ARC-7 block 7.3) and clause (i) as `selector_peirceExchange`.  The
sentence survived the arrival of clause (iii) in its own file by thirteen days (2026-08-09
to 2026-08-22), which is the
failure mode this development has on record — a summary left asserting the old thing after
the row moved — so it is corrected rather than deleted.  All three selectors of
`cor:selectors` are proved in this file.

Clause (iii) (covariance under every unital order automorphism; the article notes the
transpose suffices) needed one missing ingredient, and only one: that transposition commutes with
the real functional calculus, `(cfc f a)ᵀ = cfc f (aᵀ)`.  ★ **That ingredient is now in
this tree** — `Necessity.cfc_transpose` and `Necessity.transposeMap_cfc`, added
2026-08-08 (ARC-6 rung 6.4) by exactly the route below; the sentence that used to stand
here, "Nothing in this tree has it", is retired.  What remains for clause (iii) is the
assembly, not an ingredient.
The route is `StarAlgHomClass.map_cfc` (Mathlib) applied to entrywise complex
conjugation — which is an ℝ-star-algebra hom of `Matrix n n ℂ` because conjugation
does *not* reverse products and `star (conj A) = conj (star A)` — built from
`AlgHom.mapMatrix Complex.conjAe.toAlgHom` plus a `map_star'` field; for Hermitian `a`,
`aᵀ = conj a`.  With that lemma, `transposeMap (twistSeq t a b) = twistSeq (-t)
(transposeMap a) (transposeMap b)` and clause (iii) closes by the same uniqueness step
used below.  Clause (i) additionally needs the coherence-block action on `H_N(ℂ)`; that
action is `twistSeq_diagFamily_blockHerm` in the Peirce-exchange section at the end of this
file, where the block coefficient is computed rather than assumed. -/

/-- The twist product's **trace adjoint flips the twist**: conjugating the left slot by
`a^{1/2+it}` is adjoint, for the trace form, to conjugating the right slot by
`a^{1/2-it}`.  Pure cyclicity of the trace, with
`twistFactor_conjTranspose : (a^{1/2+it})ᴴ = a^{1/2-it}` supplying the sign flip. -/
theorem inner_twistSeq_left {n : Type*} [Fintype n] [DecidableEq n]
    (t : ℝ) (a b c : HermitianMat n ℂ) :
    inner ℝ (HermitianMat.twistSeq t a b) c
      = inner ℝ b (HermitianMat.twistSeq (-t) a c) := by
  rw [HermitianMat.inner_eq_re_trace, HermitianMat.inner_eq_re_trace,
    HermitianMat.twistSeq_mat, HermitianMat.twistSeq_mat,
    HermitianMat.twistFactor_conjTranspose, HermitianMat.twistFactor_conjTranspose, neg_neg]
  congr 1
  simp only [Matrix.mul_assoc]
  rw [Matrix.trace_mul_comm]
  simp only [Matrix.mul_assoc]

/-- **The effects are trace-form separating.**  Two elements with the same trace pairing
against every effect are equal: the effects span (`span_isEffect_eq_top`), so the pairing
agrees everywhere, and the trace form is definite. -/
theorem eq_of_inner_effect_eq {n : Type*} [Fintype n] [DecidableEq n]
    {z w : HermitianMat n ℂ}
    (h : ∀ b : HermitianMat n ℂ, IsEffect b → inner ℝ b z = inner ℝ b w) : z = w := by
  have hall : ∀ x : HermitianMat n ℂ, inner ℝ x z = inner ℝ x w := by
    intro x
    have hx : x ∈ Submodule.span ℝ {b : HermitianMat n ℂ | IsEffect b} := by
      rw [span_isEffect_eq_top]; exact Submodule.mem_top
    induction hx using Submodule.span_induction with
    | mem y hy => exact h y hy
    | zero => simp
    | add y y' _ _ hy hy' => rw [inner_add_left, inner_add_left, hy, hy']
    | smul r y _ hy => rw [real_inner_smul_left, real_inner_smul_left, hy]
  have h0 : inner ℝ (z - w) (z - w) = (0 : ℝ) := by
    rw [inner_sub_right, hall (z - w), sub_self]
  exact sub_eq_zero.mp (inner_self_eq_zero.mp h0)

/-- **`cor:selectors` clause (ii)** — trace-form symmetry selects the Lüders product.
For an S1–S7 product with S2 on `H_N(ℂ)`, `N ≥ 3`, if `⟪a · b, c⟫ = ⟪b, a · c⟫` on
effects then the product is `twistSeq 0`, i.e. `a · b = √a · b · √a`. -/
theorem selector_traceSymm (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) (hS2 : P.FirstArgContinuous)
    (hsym : ∀ a b c : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b → IsEffect c →
      inner ℝ (P.sp a b) c = inner ℝ b (P.sp a c)) :
    ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq 0 a b := by
  obtain ⟨t, ht, huniq⟩ := complex_classification_unconditional hN P hS2
  have hneg : ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq (-t) a b := by
    intro a c ha hc
    rw [ht a c ha hc]
    refine eq_of_inner_effect_eq (fun b hb => ?_)
    rw [← inner_twistSeq_left, ← ht a b ha hb, hsym a b c ha hb hc, ht a c ha hc]
  have ht0 : t = 0 := by have := huniq (-t) hneg; linarith
  intro a b ha hb
  rw [ht a b ha hb, ht0]

/-- The same selector, stated with the Lüders product written out as
`b.conj √a` rather than as `twistSeq 0`. -/
theorem selector_traceSymm_luders (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) (hS2 : P.FirstArgContinuous)
    (hsym : ∀ a b c : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b → IsEffect c →
      inner ℝ (P.sp a b) c = inner ℝ b (P.sp a c)) :
    ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = b.conj ((a.cfc Real.sqrt) : Matrix (Fin N) (Fin N) ℂ) := by
  intro a b ha hb
  rw [selector_traceSymm hN P hS2 hsym a b ha hb, HermitianMat.twistSeq_zero]

/-! ## Transposition commutes with the real functional calculus

The one ingredient `cor:selectors` clause (iii) was missing.  Landed 2026-08-08 (ARC-6 rung
6.4) by exactly the route this file's module docstring recorded: entrywise complex
conjugation is an ℝ-star-algebra homomorphism of `Matrix n n ℂ` (conjugation does not reverse
products, and it commutes with `star`), so `StarAlgHomClass.map_cfc` applies to it; and for a
Hermitian matrix `Aᵀ = conj A`, which converts the statement about conjugation into the
statement about transposition. -/

section CfcTranspose

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Entrywise complex conjugation of matrices, as an ℝ-star-algebra homomorphism.

Conjugation, unlike transposition, does *not* reverse products, so it is a genuine algebra
homomorphism; and `star (conj A) = conj (star A)`, so it is a star homomorphism.  The
ℝ-algebra structure is what makes it a hom at all: it is only conjugate-linear over ℂ. -/
def conjMatStarAlg : Matrix n n ℂ →⋆ₐ[ℝ] Matrix n n ℂ :=
  { AlgHom.mapMatrix (Complex.conjAe.toAlgHom) with
    map_star' := by
      intro A
      ext i j
      simp [Matrix.star_eq_conjTranspose, Matrix.conjTranspose_apply,
        AlgHom.mapMatrix, Matrix.map_apply] }

@[simp]
theorem conjMatStarAlg_apply (A : Matrix n n ℂ) :
    conjMatStarAlg A = A.map (starRingEnd ℂ) := rfl

theorem continuous_conjMatStarAlg :
    Continuous (conjMatStarAlg : Matrix n n ℂ → Matrix n n ℂ) := by
  refine continuous_pi_iff.mpr fun i => continuous_pi_iff.mpr fun j => ?_
  exact Complex.continuous_conj.comp ((continuous_apply j).comp (continuous_apply i))

omit [Fintype n] [DecidableEq n] in
/-- For a Hermitian matrix, the transpose is the entrywise conjugate. -/
theorem transpose_eq_conj_of_isHermitian {A : Matrix n n ℂ} (hA : A.IsHermitian) :
    A.transpose = A.map (starRingEnd ℂ) := by
  ext i j
  have h : star (A j i) = A i j := by
    have h0 := congrFun (congrFun hA i) j
    simpa [Matrix.conjTranspose_apply] using h0
  rw [Matrix.transpose_apply, Matrix.map_apply, ← h]
  simp

/-- **Transposition commutes with the real functional calculus** — the one lemma
`cor:selectors` clause (iii) was missing. -/
theorem cfc_transpose (f : ℝ → ℝ) {A : Matrix n n ℂ} (hA : IsSelfAdjoint A)
    (hf : ContinuousOn f (spectrum ℝ A)) :
    (cfc f A).transpose = cfc f A.transpose := by
  have hherm : A.IsHermitian := hA
  have hcfc : (cfc f A).IsHermitian := by
    have : IsSelfAdjoint (cfc f A) := cfc_predicate f A
    exact this
  rw [transpose_eq_conj_of_isHermitian hcfc, transpose_eq_conj_of_isHermitian hherm]
  have hmap := StarAlgHomClass.map_cfc (conjMatStarAlg (n := n)) f A hf
    continuous_conjMatStarAlg hA (by
      change IsSelfAdjoint (conjMatStarAlg A)
      rw [conjMatStarAlg_apply, ← transpose_eq_conj_of_isHermitian hherm]
      exact (Matrix.isHermitian_transpose_iff (A := A)).mpr hherm)
  simpa using hmap

/-- Transposition does not move the real spectrum: `algebraMap r - Aᵀ` is the transpose of
`algebraMap r - A`, and `det` is transpose-invariant. -/
theorem spectrum_transpose (A : Matrix n n ℂ) :
    spectrum ℝ A.transpose = spectrum ℝ A := by
  have key : ∀ B : Matrix n n ℂ, ∀ r : ℝ,
      IsUnit (algebraMap ℝ (Matrix n n ℂ) r - B) →
      IsUnit (algebraMap ℝ (Matrix n n ℂ) r - B.transpose) := by
    intro B r hu
    rw [Matrix.isUnit_iff_isUnit_det] at hu ⊢
    have hrw : (algebraMap ℝ (Matrix n n ℂ) r - B.transpose)
        = (algebraMap ℝ (Matrix n n ℂ) r - B).transpose := by
      simp [Matrix.transpose_sub, Matrix.algebraMap_eq_diagonal, Matrix.diagonal_transpose]
    rw [hrw, Matrix.det_transpose]
    exact hu
  ext r
  simp only [spectrum.mem_iff]
  exact ⟨fun h hu => h (key _ r hu), fun h hu => h (by simpa using key _ r hu)⟩

/-- **Transposition commutes with the real functional calculus, UNCONDITIONALLY.**

Both hypotheses of `cfc_transpose` are **inert**, found by the ARC-6 cold review: outside its
domain `cfc` is junk-valued at `0`, and it degrades on *both* sides together — if `f` is
discontinuous on the spectrum then it is discontinuous on the transpose's spectrum too
(`spectrum_transpose`), and if `A` is not self-adjoint neither is `Aᵀ`. So the identity holds
for arbitrary `f` and arbitrary `A`.

This is the **third** inert hypothesis caught in this arc, after `lem:adjacent` (arc-5) and
`rhoChi_eq_smul_generator`; unlike those two it was found by an outside reviewer rather than by
me, which is the case for cold review in one line. -/
theorem cfc_transpose_unconditional (f : ℝ → ℝ) (A : Matrix n n ℂ) :
    (cfc f A).transpose = cfc f A.transpose := by
  by_cases hA : IsSelfAdjoint A
  · by_cases hf : ContinuousOn f (spectrum ℝ A)
    · exact cfc_transpose f hA hf
    · rw [cfc_apply_of_not_continuousOn (f := f) A hf, Matrix.transpose_zero,
        cfc_apply_of_not_continuousOn (f := f) A.transpose (by rwa [spectrum_transpose])]
  · rw [cfc_apply_of_not_predicate (R := ℝ) A hA, Matrix.transpose_zero,
      cfc_apply_of_not_predicate (R := ℝ) _ (by
        rw [show IsSelfAdjoint A.transpose ↔ A.IsHermitian from
          Matrix.isHermitian_transpose_iff (A := A)]
        exact hA)]

/-- The `HermitianMat` form, likewise unconditional — the continuity hypothesis it used to
carry was inert for the same reason. -/
theorem transposeMap_cfc (f : ℝ → ℝ) (A : HermitianMat n ℂ) :
    transposeMap (A.cfc f) = (transposeMap A).cfc f := by
  rw [HermitianMat.ext_iff]
  rw [transposeMap_mat, HermitianMat.mat_cfc, HermitianMat.mat_cfc, transposeMap_mat]
  exact cfc_transpose_unconditional f A.mat

end CfcTranspose

/-! ## `cor:selectors` clause (iii): covariance under transposition selects Lüders

★★ **Closed 2026-08-09 (ARC-7 block 7.3).**  The module docstring above recorded that clause
(iii) needed exactly one ingredient, `(cfc f a)ᵀ = cfc f (aᵀ)`, and that ARC-6 supplied it; what
remained was "the assembly, not an ingredient", with the sign reasoning checked on paper. This is
that assembly, and the paper check held: the whole thing is three short lemmas.

The mechanism, stated so it is not mistaken for a computation: transposition **flips the twist**,
because the twist factor is built from two real functional calculi and `transposeMap` commutes
with each of them while conjugating the explicit `i`. So a product that commutes with
transposition has a classified parameter equal to its own negative, and `∃!` finishes. -/

section SelectorTranspose

variable {n : Type*} [Fintype n] [DecidableEq n]

omit [Fintype n] in
theorem transposeMap_involutive (x : HermitianMat n ℂ) :
    transposeMap (transposeMap x) = x := by
  ext1
  rw [transposeMap_mat, transposeMap_mat, Matrix.transpose_transpose]

/-- **Transposition commutes with the twist factor.**  Immediate from `transposeMap_cfc`: the
twist factor is `cfc(…) + i • cfc(…)` and transposition is ℝ-linear. -/
theorem twistFactor_transposeMap (a : HermitianMat n ℂ) (s : ℝ) :
    HermitianMat.twistFactor (transposeMap a) s = (HermitianMat.twistFactor a s)ᵀ := by
  unfold HermitianMat.twistFactor HermitianMat.twistRe HermitianMat.twistIm
  rw [← transposeMap_cfc, ← transposeMap_cfc, transposeMap_mat, transposeMap_mat,
    Matrix.transpose_add, Matrix.transpose_smul]

/-- **Transposition flips the twist**: `(a ∘_t b)ᵀ = (aᵀ) ∘_{−t} (bᵀ)`.

This is the clause's whole content.  The sign flip does *not* come from `cos` even / `sin` odd
directly — it comes from `twistFactor_conjTranspose` together with `(Mᵀ)ᴴ = (Mᴴ)ᵀ`, so the two
outer factors trade places under transposition. -/
theorem transposeMap_twistSeq (t : ℝ) (a b : HermitianMat n ℂ) :
    transposeMap (HermitianMat.twistSeq t a b)
      = HermitianMat.twistSeq (-t) (transposeMap a) (transposeMap b) := by
  ext1
  have hswap : ∀ M : Matrix n n ℂ, (Mᵀ)ᴴ = (Mᴴ)ᵀ := by
    intro M
    ext i j
    simp [Matrix.conjTranspose_apply, Matrix.transpose_apply]
  rw [transposeMap_mat, HermitianMat.twistSeq_mat, HermitianMat.twistSeq_mat,
    transposeMap_mat, twistFactor_transposeMap,
    HermitianMat.twistFactor_conjTranspose,
    hswap, HermitianMat.twistFactor_conjTranspose, neg_neg,
    Matrix.transpose_mul, Matrix.transpose_mul]
  simp only [Matrix.mul_assoc]

end SelectorTranspose

section SelectorTransposeMain

variable {N : ℕ}

/-- Transposition preserves effects, being a unital order automorphism. -/
theorem transposeMap_isEffect {a : HermitianMat (Fin N) ℂ} (ha : IsEffect a) :
    IsEffect (transposeMap a) := by
  refine ⟨?_, ?_⟩
  · have h := (transposeMap_le_iff (0 : HermitianMat (Fin N) ℂ) a).mpr ha.1
    rwa [map_zero] at h
  · have h := (transposeMap_le_iff a 1).mpr ha.2
    rwa [transposeMap_one] at h

/-- **`cor:selectors` clause (iii).**  Covariance under transposition selects the Lüders product:
for an S1–S7 product with S2 on `H_N(ℂ)`, `N ≥ 3`, if the product commutes with transposition on
effects then `a · b = √a · b · √a`.

The article states clause (iii) for covariance under *every* unital order automorphism and notes
that on `H_N(ℂ)` the transpose already suffices; this is the statement with that hypothesis, so it
is the article's own sufficient condition rather than a weakening. -/
theorem selector_transpose (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) (hS2 : P.FirstArgContinuous)
    (hcov : ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      transposeMap (P.sp a b) = P.sp (transposeMap a) (transposeMap b)) :
    ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq 0 a b := by
  obtain ⟨t, ht, huniq⟩ := complex_classification_unconditional hN P hS2
  have hneg : ∀ c d : HermitianMat (Fin N) ℂ, IsEffect c → IsEffect d →
      P.sp c d = HermitianMat.twistSeq (-t) c d := by
    intro c d hc hd
    have ha : IsEffect (transposeMap c) := transposeMap_isEffect hc
    have hb : IsEffect (transposeMap d) := transposeMap_isEffect hd
    calc P.sp c d
        = transposeMap (P.sp (transposeMap c) (transposeMap d)) := by
          rw [hcov _ _ ha hb, transposeMap_involutive, transposeMap_involutive]
      _ = transposeMap (HermitianMat.twistSeq t (transposeMap c) (transposeMap d)) := by
          rw [ht _ _ ha hb]
      _ = HermitianMat.twistSeq (-t) c d := by
          rw [transposeMap_twistSeq, transposeMap_involutive, transposeMap_involutive]
  have ht0 : t = 0 := by have h := huniq (-t) hneg; linarith
  intro a b ha hb
  rw [ht a b ha hb, ht0]

/-- Clause (iii) with the Lüders product written out as `b.conj √a`. -/
theorem selector_transpose_luders (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) (hS2 : P.FirstArgContinuous)
    (hcov : ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      transposeMap (P.sp a b) = P.sp (transposeMap a) (transposeMap b)) :
    ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = b.conj ((a.cfc Real.sqrt) : Matrix (Fin N) (Fin N) ℂ) := by
  intro a b ha hb
  rw [selector_transpose hN P hS2 hcov a b ha hb, HermitianMat.twistSeq_zero]

end SelectorTransposeMain

/-! ## `cor:selectors` clause (i): Peirce exchange covariance selects Lüders

The last of the article's three selectors.  `main.tex` fixes the hypothesis in the sentence
that introduces it: writing `E(x,y)` for the action of `a ∘ (·)` on a coherence block `V_ij`
when `a` has eigenvalues `x, y` on the atoms `p_i, p_j`, so that `thm:complex` makes
`E(x,y) = √(xy)·exp(t·log(x/y)·𝒥)`, *Peirce exchange covariance* means `E(x,y) = E(y,x)`
**with the block's complex structure `𝒥` held fixed** — and the article says in the same
breath that this is *not* a relabelling of `p_i, p_j`.

That is the statement carried here, and the two halves of it are separately visible.

* `twistSeq_diagFamily_blockHerm` realizes `E(x,y)`: on the block `V_ij = {z E_ij + z̄ E_ji}`
  the product with first argument `diag(e^{r_k})` acts by multiplication by the single
  complex number `blockCoef r t i j = √(e^{r_i}e^{r_j})·exp(i·t·(r_i − r_j))`, which is the
  article's displayed formula with `x = e^{r_i}`, `y = e^{r_j}` and `𝒥` the multiplication by
  `i` on the block coordinate.  So `E` is exhibited, not assumed.
* `PeirceExchangeCovariant` then swaps only the *eigenvalues*, `r ↦ r ∘ (i j)`, and compares
  the two actions **on the same block element** `blockHerm i j z`.  The block, its coordinate
  and hence `𝒥` are literally the same term on both sides of the equation, and no permutation
  is applied to the argument.  This is the article's condition and not the relabelling it
  excludes.

The proof is the same three-line shape as clauses (ii) and (iii): the classification supplies
`t`, exchange covariance says the block phase is its own inverse, and
`Globalization.real_character_unique` on an interval of `r_i − r_j` gives `t = −t` with no
`2π` ambiguity.  The one new ingredient is `seqLeftMul_eq_conjLinear_twistFactor`, which
identifies the *linear extension* `L_a` of `b ↦ P.sp a b` with conjugation by the twist
factor — needed because a nonzero block element is never an effect (its two nonzero
eigenvalues are `±|z|`), so the article's `E` lives on `L_a` rather than on `P.sp` directly.

**Scope, stated so it is not overread.**  The hypothesis here ranges over the blocks of the
*standard* frame only, whereas the article's clause (i) asks for exchange covariance on every
coherence block of every Jordan frame.  Fewer instances is a *weaker* hypothesis, so this
theorem is at least as strong as the article's; it is not a weakening of the conclusion.

Non-vacuity is certified both ways: `luders_peirceExchangeCovariant` shows the Lüders product
satisfies the hypothesis, and `peirceExchangeCovariant_forces_zero` shows no other member of
the twist family does.  So the class is inhabited and the condition genuinely selects. -/

section SelectorExchange

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **The left multiplication of a classified product is conjugation by the twist factor.**
`seqLeftMul P a` is the positive linear extension of `b ↦ P.sp a b` off the effects; once the
product is known to be `twistSeq t` on effects, the extension is pinned everywhere by
`linearMap_eq_of_eq_on_effects`, because both sides are linear and the effects span. -/
theorem seqLeftMul_eq_conjLinear_twistFactor
    (P : SequentialProductOn (HermitianMat n ℂ)) {t : ℝ}
    {a : HermitianMat n ℂ} (ha : IsEffect a)
    (ht : ∀ b : HermitianMat n ℂ, IsEffect b → P.sp a b = HermitianMat.twistSeq t a b) :
    seqLeftMul P a ha = HermitianMat.conjLinear ℝ (HermitianMat.twistFactor a t) := by
  refine OrderUnitSpace.linearMap_eq_of_eq_on_effects _ _ (fun b hb => ?_)
  rw [seqLeftMul_apply_effect P ha hb, ht b hb]
  rfl

/-- The article's block-action coefficient `E(x,y) = √(xy)·exp(t·log(x/y)·𝒥)`, for
`x = e^{r_i}`, `y = e^{r_j}` and `𝒥` the multiplication by `i` on the block coordinate. -/
def blockCoef (r : n → ℝ) (t : ℝ) (i j : n) : ℂ :=
  ((Real.sqrt (Real.exp (r i)) * Real.sqrt (Real.exp (r j)) : ℝ) : ℂ)
    * Complex.exp (((t * (r i - r j) : ℝ) : ℂ) * Complex.I)

/-- The two twist-factor entries of `twistSeq_diagFamily_entry` collapse to `blockCoef`:
the moduli multiply to `√(xy)` and the phases subtract to `t·log(x/y)`. -/
theorem twistFactorEntry_mul (r : n → ℝ) (t : ℝ) (i j : n) (z : ℂ) :
    (((Real.sqrt (Real.exp (r i)) : ℝ) : ℂ)
        * Complex.exp (((t * r i : ℝ) : ℂ) * Complex.I))
      * z
      * star (((Real.sqrt (Real.exp (r j)) : ℝ) : ℂ)
        * Complex.exp (((t * r j : ℝ) : ℂ) * Complex.I))
      = blockCoef r t i j * z := by
  rw [blockCoef]
  simp only [star_mul', Complex.star_def, Complex.conj_ofReal, ← Complex.exp_conj]
  rw [map_mul, Complex.conj_ofReal, Complex.conj_I]
  rw [show (((Real.sqrt (Real.exp (r i)) * Real.sqrt (Real.exp (r j)) : ℝ)) : ℂ)
      = ((Real.sqrt (Real.exp (r i)) : ℝ) : ℂ) * ((Real.sqrt (Real.exp (r j)) : ℝ) : ℂ) by
    push_cast; ring]
  rw [show Complex.exp (((t * (r i - r j) : ℝ) : ℂ) * Complex.I)
      = Complex.exp (((t * r i : ℝ) : ℂ) * Complex.I)
        * Complex.exp (((t * r j : ℝ) : ℂ) * -Complex.I) by
    rw [← Complex.exp_add]; congr 1; push_cast; ring]
  ring

/-- **The block action `E(x,y)`, exhibited.**  The twist product with first argument
`diag(e^{r_k})` maps the coherence block `V_ij` into itself, acting on the block coordinate by
multiplication by `blockCoef r t i j = √(xy)·exp(i·t·log(x/y))`.  This is the article's
displayed formula for `E(x,y)`, and it is what makes the exchange hypothesis below a statement
about `E` rather than about a permutation. -/
theorem twistSeq_diagFamily_blockHerm (r : n → ℝ) (t : ℝ) {i j : n} (hij : i ≠ j) (z : ℂ) :
    HermitianMat.twistSeq t (diagFamily r) (blockHerm i j z)
      = blockHerm i j (blockCoef r t i j * z) := by
  ext k l
  rw [twistSeq_diagFamily_entry, blockHerm_mat, blockHerm_mat]
  simp only [Matrix.add_apply, Matrix.smul_apply, Matrix.single_apply, smul_eq_mul,
    mul_add, add_mul, mul_ite, ite_mul, mul_zero, zero_mul, mul_one, one_mul]
  by_cases h1 : i = k ∧ j = l
  · obtain ⟨rfl, rfl⟩ := h1
    have hne : ¬ (j = i ∧ i = j) := fun h => hij h.1.symm
    rw [if_neg hne, if_neg hne, add_zero, add_zero, if_pos ⟨rfl, rfl⟩, if_pos ⟨rfl, rfl⟩]
    exact twistFactorEntry_mul r t i j z
  · by_cases h2 : j = k ∧ i = l
    · obtain ⟨rfl, rfl⟩ := h2
      rw [if_neg h1, if_neg h1, zero_add, zero_add, if_pos ⟨rfl, rfl⟩, if_pos ⟨rfl, rfl⟩]
      rw [← twistFactorEntry_mul r t i j z]
      simp only [star_mul', star_star]
      ring
    · rw [if_neg h1, if_neg h2, if_neg h1, if_neg h2, add_zero]

/-- The block coordinate of `L_a`'s action, for a classified product. -/
theorem blockAction_entry
    (P : SequentialProductOn (HermitianMat n ℂ)) {t : ℝ}
    (ht : ∀ a b : HermitianMat n ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq t a b)
    {r : n → ℝ} (hr : IsEffect (diagFamily r)) {i j : n} (hij : i ≠ j) (z : ℂ) :
    (seqLeftMul P (diagFamily r) hr (blockHerm i j z)).mat i j
      = (((Real.sqrt (Real.exp (r i)) : ℝ) : ℂ)
            * Complex.exp (((t * r i : ℝ) : ℂ) * Complex.I))
        * z
        * star (((Real.sqrt (Real.exp (r j)) : ℝ) : ℂ)
            * Complex.exp (((t * r j : ℝ) : ℂ) * Complex.I)) := by
  rw [seqLeftMul_eq_conjLinear_twistFactor P hr (fun b hb => ht _ b hr hb)]
  show (HermitianMat.twistSeq t (diagFamily r) (blockHerm i j z)).mat i j = _
  rw [twistSeq_diagFamily_entry, blockHerm_entry hij]

end SelectorExchange

section SelectorExchangeMain

variable {N : ℕ}

/-- **Peirce exchange covariance** (`cor:selectors`(i)).  For every coherence block `V_ij` of
the standard frame and every base point `diag(e^{r_k})`, the action of `a ∘ (·)` on that block
is unchanged when the two eigenvalues on `p_i, p_j` are interchanged — `E(x,y) = E(y,x)`.

The block, its coordinate `z`, and hence its complex structure `𝒥` are the *same term* on both
sides: only the eigenvalue vector `r` is transposed at `i, j`.  So this is the article's
fixed-orientation condition and not the relabelling of `p_i, p_j` the article rules out.

The action is taken on `seqLeftMul`, the linear extension of `b ↦ P.sp a b`, because a nonzero
block element is not an effect. -/
def PeirceExchangeCovariant (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) : Prop :=
  ∀ (i j : Fin N), i ≠ j → ∀ (r : Fin N → ℝ)
      (h : IsEffect (diagFamily r)) (h' : IsEffect (diagFamily (r ∘ Equiv.swap i j)))
      (z : ℂ),
    seqLeftMul P (diagFamily r) h (blockHerm i j z)
      = seqLeftMul P (diagFamily (r ∘ Equiv.swap i j)) h' (blockHerm i j z)

/-- **`cor:selectors` clause (i).**  Peirce exchange covariance selects the Lüders product:
for an S1–S7 product with S2 on `H_N(ℂ)`, `N ≥ 3`, if the block action is symmetric under
interchanging the two eigenvalues then `a · b = √a · b · √a`.

The article's clause (i) assumes the condition on every coherence block of every Jordan frame;
the hypothesis here asks for it on the standard frame's blocks only, which is weaker, so this
covers the article's statement. -/
theorem selector_peirceExchange (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) (hS2 : P.FirstArgContinuous)
    (hexch : PeirceExchangeCovariant P) :
    ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq 0 a b := by
  obtain ⟨t, ht, huniq⟩ := complex_classification_unconditional hN P hS2
  have h0 : (0 : ℕ) < N := by omega
  have h1 : (1 : ℕ) < N := by omega
  set i : Fin N := ⟨0, h0⟩ with hi
  set j : Fin N := ⟨1, h1⟩ with hj
  have hij : i ≠ j := by rw [hi, hj]; exact Fin.ne_of_val_ne (by norm_num)
  have hchar : t = -t := by
    refine MasterTheorem.Globalization.real_character_unique (a := -1) (b := 0) (by norm_num) ?_
    intro x hx
    have hxneg : x < 0 := hx.2
    have hrle : ∀ k, (Pi.single i x : Fin N → ℝ) k ≤ 0 := by
      intro k
      by_cases hk : k = i
      · rw [hk, Pi.single_eq_same]; exact le_of_lt hxneg
      · rw [Pi.single_eq_of_ne hk]
    have hr'le : ∀ k, ((Pi.single i x : Fin N → ℝ) ∘ Equiv.swap i j) k ≤ 0 := fun k => hrle _
    have hentry := congrArg (fun M : HermitianMat (Fin N) ℂ => M.mat i j)
      (hexch i j hij (Pi.single i x) (diagFamily_isEffect hrle) (diagFamily_isEffect hr'le) 1)
    rw [blockAction_entry P ht (diagFamily_isEffect hrle) hij,
      blockAction_entry P ht (diagFamily_isEffect hr'le) hij] at hentry
    have hri : (Pi.single i x : Fin N → ℝ) i = x := Pi.single_eq_same _ _
    have hrj : (Pi.single i x : Fin N → ℝ) j = 0 := Pi.single_eq_of_ne (Ne.symm hij) _
    have hr'i : ((Pi.single i x : Fin N → ℝ) ∘ Equiv.swap i j) i = 0 := by
      simp only [Function.comp_apply, Equiv.swap_apply_left]; exact hrj
    have hr'j : ((Pi.single i x : Fin N → ℝ) ∘ Equiv.swap i j) j = x := by
      simp only [Function.comp_apply, Equiv.swap_apply_right]; exact hri
    rw [hri, hrj, hr'i, hr'j] at hentry
    simp only [Real.exp_zero, Real.sqrt_one, mul_zero, Complex.ofReal_zero, zero_mul,
      Complex.exp_zero, mul_one, star_one, Complex.ofReal_one, one_mul, star_mul',
      Complex.star_def, Complex.conj_ofReal, ← Complex.exp_conj] at hentry
    have hne : ((Real.sqrt (Real.exp x) : ℝ) : ℂ) ≠ 0 := by
      simp only [ne_eq, Complex.ofReal_eq_zero]
      exact Real.sqrt_ne_zero'.mpr (Real.exp_pos x)
    have hcancel := mul_left_cancel₀ hne hentry
    rw [show ((t : ℂ) * (x : ℂ)) = ((t * x : ℝ) : ℂ) by push_cast; ring, hcancel]
    congr 1
    rw [map_mul, Complex.conj_ofReal, Complex.conj_I]
    push_cast
    ring
  have ht0 : t = 0 := by linarith
  intro a b ha hb
  rw [ht a b ha hb, ht0]

/-- Clause (i) with the Lüders product written out as `b.conj √a`. -/
theorem selector_peirceExchange_luders (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ)) (hS2 : P.FirstArgContinuous)
    (hexch : PeirceExchangeCovariant P) :
    ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = b.conj ((a.cfc Real.sqrt) : Matrix (Fin N) (Fin N) ℂ) := by
  intro a b ha hb
  rw [selector_peirceExchange hN P hS2 hexch a b ha hb, HermitianMat.twistSeq_zero]

/-- **Non-vacuity: the hypothesis class is inhabited.**  The Lüders product is Peirce exchange
covariant — at `t = 0` the block coefficient is the swap-symmetric `√(xy)` with no phase. -/
theorem luders_peirceExchangeCovariant :
    PeirceExchangeCovariant (N := N) (twistProductOn 0) := by
  intro i j hij r h h' z
  rw [seqLeftMul_eq_conjLinear_twistFactor _ h (fun b _ => twistProductOn_sp 0 _ b),
    seqLeftMul_eq_conjLinear_twistFactor _ h' (fun b _ => twistProductOn_sp 0 _ b)]
  show HermitianMat.twistSeq 0 (diagFamily r) (blockHerm i j z)
      = HermitianMat.twistSeq 0 (diagFamily (r ∘ Equiv.swap i j)) (blockHerm i j z)
  rw [twistSeq_diagFamily_blockHerm _ _ hij, twistSeq_diagFamily_blockHerm _ _ hij]
  congr 2
  rw [blockCoef, blockCoef, Function.comp_apply, Function.comp_apply,
    Equiv.swap_apply_left, Equiv.swap_apply_right]
  rw [mul_comm (Real.sqrt (Real.exp (r j)))]
  norm_num

/-- **Non-vacuity: the hypothesis genuinely selects.**  No twist product other than Lüders is
Peirce exchange covariant, so the condition is not satisfied by the whole family. -/
theorem peirceExchangeCovariant_forces_zero (hN : 3 ≤ N) (t : ℝ)
    (hexch : PeirceExchangeCovariant (twistProductOn (n := Fin N) t)) : t = 0 :=
  ((complex_classification_sharp hN t 0).mp
    (selector_peirceExchange hN (twistProductOn t)
      (twistProductOn_firstArgContinuous t) hexch)).symm

end SelectorExchangeMain

/-! ## `prop:n2-necessity` at the level of `Θ` (row 29, gap (b))

The tree's rank-two necessity statement (`Necessity.n2_sp_eq_twistSeq_frame`) is a
**product-level** identity: `P.sp a b = a^{1/2+it̃} b a^{1/2−it̃}`.  The article states
`prop:n2-necessity` about the **comparison map** instead, `Θ_a|_{W_n} = exp(ℓ·t̃(n)·𝒥_n)` with
`ℓ = log(λ₊/λ₋)`.  Those are the same fact, but nothing said so; the equivalence was the route
and not a theorem.  It is a theorem here.

The bridge is `seqLeftMul_eq_conjLinear_twistFactor` above: once the product is `twistSeq t` at
a given effect `a`, its left multiplication is conjugation by `a^{1/2+it}` **everywhere**, not
only on the effects — which is what makes `Θ_a` computable, since the coherence block contains
no nonzero effect.  Then `Q_{√a}⁻¹` cancels the modulus `√a` exactly (`invSqrt_mul_sqrt`),
leaving `Θ_a = Ad_{a^{it}}`, and at `a = Ad_U(diag(e^{r_k}))` the phase `a^{it}` is the torus
unitary `U·U_t(r)·U*`, whose block action `torusU_block` already computes.

★ **The frame index is the thing to check here, and the wall certificate's own record says why**:
its first version of this statement applied `Θ_a` to the *standard* block while taking a
`U`-conjugated base point, and was false for that reason.  Every object below carries the same
`U`: the base point is `Ad_U(diag)`, the block is `Ad_U(blockHerm i j z)`, and the conclusion is
in `Ad_U`'s image.  `W_n` is `a`'s own coherence space, not the standard one. -/

section ThetaLevel

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **`Θ_a` at a diagonalized base point is conjugation by `a^{it}`.**  For
`a = Ad_U(diag(e^{r_k}))` and a product that is `twistSeq t` at that `a`, the comparison map is
`Ad_{U·U_t(r)·U*}`: the `Q_{√a}⁻¹` half cancels the modulus of the twist factor exactly, leaving
the pure phase. -/
theorem theta_eq_conjLinear_torus
    (P : SequentialProductOn (HermitianMat n ℂ)) {t : ℝ} {r : n → ℝ}
    (U : Matrix.unitaryGroup n ℂ)
    {a : HermitianMat n ℂ} (hUa : a = adU (U : Matrix n n ℂ) (diagFamily r))
    (ha : IsEffect a) (hbd : a.mat.PosDef)
    (ht : ∀ b : HermitianMat n ℂ, IsEffect b → P.sp a b = HermitianMat.twistSeq t a b) :
    theta P ha hbd
      = HermitianMat.conjLinear ℝ
          ((U : Matrix n n ℂ) * torusU t r * (U : Matrix n n ℂ)ᴴ) := by
  have hU : (U : Matrix n n ℂ)ᴴ * (U : Matrix n n ℂ) = 1 := by
    have h := U.property
    rwa [Matrix.mem_unitaryGroup_iff', Matrix.star_eq_conjTranspose] at h
  have hU' : (U : Matrix n n ℂ) * (U : Matrix n n ℂ)ᴴ = 1 := by
    have h := U.property
    rwa [Matrix.mem_unitaryGroup_iff, Matrix.star_eq_conjTranspose] at h
  have hkey : (a.cfc fun x => (Real.sqrt x)⁻¹).mat * HermitianMat.twistFactor a t
      = (U : Matrix n n ℂ) * torusU t r * (U : Matrix n n ℂ)ᴴ := by
    have hcfc : (a.cfc fun x => (Real.sqrt x)⁻¹)
        = adU (U : Matrix n n ℂ) ((diagFamily r).cfc fun x => (Real.sqrt x)⁻¹) := by
      rw [hUa, adU_apply, adU_apply, HermitianMat.cfc_conj_unitary]
    have htf : HermitianMat.twistFactor a t
        = (U : Matrix n n ℂ)
            * (((diagFamily r).cfc Real.sqrt).mat * torusU t r) * (U : Matrix n n ℂ)ᴴ := by
      rw [hUa, twistFactor_adU_mat _ hU' t, twistFactor_diagFamily]
    rw [hcfc, htf, adU_apply, HermitianMat.conj_apply_mat]
    have hpd : (diagFamily r).mat.PosDef := diagFamily_posDef r
    set V : Matrix n n ℂ := (U : Matrix n n ℂ) with hV
    set D1 : Matrix n n ℂ := ((diagFamily r).cfc fun x => (Real.sqrt x)⁻¹).mat with hD1
    set D2 : Matrix n n ℂ := ((diagFamily r).cfc Real.sqrt).mat with hD2
    calc V * D1 * Vᴴ * (V * (D2 * torusU t r) * Vᴴ)
        = V * D1 * (Vᴴ * V) * (D2 * torusU t r) * Vᴴ := by noncomm_ring
      _ = V * (D1 * D2) * torusU t r * Vᴴ := by rw [hU]; noncomm_ring
      _ = V * torusU t r * Vᴴ := by
          rw [hD1, hD2, invSqrt_mul_sqrt hpd]; noncomm_ring
  refine LinearMap.ext fun x => ?_
  rw [theta]
  simp only [LinearMap.comp_apply, LinearEquiv.coe_coe, HermitianMat.conjLinear_apply]
  rw [seqLeftMul_eq_conjLinear_twistFactor P ha ht, HermitianMat.conjLinear_apply,
    quadRepEquiv_symm_apply, conj_conj_mat, hkey]

/-- **`prop:n2-necessity`, at the level of `Θ`.**  With `a = Ad_U(diag(e^{r_k}))` the comparison
map acts on the coherence block of `a`'s **own** frame, `Ad_U(W)`, by the rotation through
`t·(r_i − r_j)` — the article's `Θ_a|_{W_n} = exp(ℓ·t̃(n)·𝒥_n)` with `ℓ = r_i − r_j` the ordered
log-ratio. -/
theorem theta_block_rotation
    (P : SequentialProductOn (HermitianMat n ℂ)) {t : ℝ} {r : n → ℝ}
    (U : Matrix.unitaryGroup n ℂ)
    {a : HermitianMat n ℂ} (hUa : a = adU (U : Matrix n n ℂ) (diagFamily r))
    (ha : IsEffect a) (hbd : a.mat.PosDef)
    (ht : ∀ b : HermitianMat n ℂ, IsEffect b → P.sp a b = HermitianMat.twistSeq t a b)
    {i j : n} (hij : i ≠ j) (z : ℂ) :
    theta P ha hbd (adU (U : Matrix n n ℂ) (blockHerm i j z))
      = adU (U : Matrix n n ℂ)
          (blockHerm i j (Complex.exp ((↑(t * (r i - r j)) : ℂ) * Complex.I) * z)) := by
  have hU : (U : Matrix n n ℂ)ᴴ * (U : Matrix n n ℂ) = 1 := by
    have h := U.property
    rwa [Matrix.mem_unitaryGroup_iff', Matrix.star_eq_conjTranspose] at h
  rw [theta_eq_conjLinear_torus P U hUa ha hbd ht, HermitianMat.conjLinear_apply,
    ← torusU_block t r hij z]
  simp only [adU_apply]
  rw [conj_conj_mat, conj_conj_mat, Matrix.mul_assoc, Matrix.mul_assoc, hU, Matrix.mul_one]

end ThetaLevel

section N2ThetaLevel

/-- **Row 29 gap (b), discharged.**  The wall certificate's `n2_necessity_theta_level`: for an
arbitrary S1–S7 product with S2 on `H_2(ℂ)` and an invertible effect `a = Ad_U(diag(e^{r_k}))`,
the comparison map rotates `a`'s own coherence block by `t̃(U)·(r_0 − r_1)`. -/
theorem n2_theta_block_rotation
    (P : SequentialProductOn (HermitianMat (Fin 2) ℂ)) (hS2 : P.FirstArgContinuous)
    (U : Matrix.unitaryGroup (Fin 2) ℂ) {r : Fin 2 → ℝ} (hr : ∀ i, r i ≤ 0)
    {a : HermitianMat (Fin 2) ℂ}
    (hUa : a = adU (U : Matrix (Fin 2) (Fin 2) ℂ) (diagFamily r))
    (ha : IsEffect a) (hbd : a.mat.PosDef) (z : ℂ) :
    theta P ha hbd (adU (U : Matrix (Fin 2) (Fin 2) ℂ) (blockHerm 0 1 z))
      = adU (U : Matrix (Fin 2) (Fin 2) ℂ)
          (blockHerm 0 1
            (Complex.exp ((↑(n2FrameTwist P hS2 U * (r 0 - r 1)) : ℂ) * Complex.I) * z)) :=
  theta_block_rotation P U hUa ha hbd
    (fun b hb => n2_sp_eq_twistSeq_frame P hS2 U hr hUa hb) (by decide) z

end N2ThetaLevel


/-! ## `lem:orientation` (row 22): the splitting-independent complex structure on a
cross-coherence space

`main.tex` defines `X = {x : q ∘ x = ½x = p_k ∘ x}` for a rank-two projection `q` and an
orthogonal atom `p_k`, identifies it with the self-adjoint part of `qM_n(ℂ)p_k ⊕ p_kM_n(ℂ)q`
("each `x ∈ X` is `x = z + z*` with corner `z = q x p_k`"), and defines
`𝒥_{q,k}(x) = i z − i z*`.

★ **`X` is a predicate, not a carrier, and every clause of the lemma is pointwise under it.**
`IsCrossCoherent` is the article's definition verbatim; `isCrossCoherent_iff` **proves** the
article's identification with the corner form rather than assuming it; and `orientationJ` is the
article's real-linear map, defined for every `x` and restricted where the article restricts it.

What is proved here, clause by clause, and at what generality:

* **(i)** `orientationJ_corner` (the corner of `𝒥x` is `iz`), `orientationJ_isCrossCoherent`
  (`𝒥` maps `X` into `X`), `orientationJ_sq` (`𝒥² = −id` on `X`).  At the article's generality:
  `q`, `p_k` orthogonal idempotents, arbitrary `n`.
  ★ The clause's remaining phrase — "depends only on `q`, `p_k` and the fixed ambient `i`, **not**
  on any splitting `q = p₁ + p₂`" — is discharged by the *form of the definition*: `orientationJ`
  takes `q` and `p` and nothing else, so there is no splitting for it to depend on.  **No theorem
  is stated for it**, because every Lean rendering of "the two splittings agree" is `rfl`, and a
  `rfl` theorem here would record awkwardness and read as depth.
* **(ii)** `orientationJ_adU`.  Proved **unrestricted** — for every `x`, not only on `X` — because
  the article's own computation `q(uxu*)p_k = u(q x p_k)u*` never uses the coherence condition.
  Stronger than the article's clause.
* **(iii)** `adU_eq_rotation_on_crossCoherent`.  ★ **This is where the row stays PARTIAL, and the
  gap is named rather than papered over.**  What is proved is the article's own proof step at its
  own generality: any `u` acting on `q` and on `p_k` by scalars whose ratio is a phase rotates `X`
  through that phase's angle, in the orientation fixed by `𝒥_{q,k}` (unitarity of `u` is not
  even needed).  What is
  **not** proved is that `a^{it}` is such a unitary for an arbitrary `a = λq + Σ_{l≥3} λ_l p_l`;
  that needs `cfc f a · q = f(λ)·q` for a spectral projection `q` of `a`, which this tree has only
  for the diagonal family.  `torusU_framePair` supplies exactly that identification at the standard
  frame, where `a^{it}` **is** `U_t(r)` — so the hypothesis class is inhabited by the article's own
  object and the angle really is `t(\log λ − \log λ_k)`, but the passage from an arbitrary spectral
  decomposition to it is open.

`blockHerm_isCrossCoherent` together with `blockHerm_ne_zero` certifies that `X` is not the zero
space, so none of the three clauses is vacuously true.  And `adU_torusU_eq_rotation` **composes**
the witnesses with clause (iii) rather than asserting that they fit: it is clause (iii) fired at
the standard frame, with the article's angle `t(r_i − r_k)` in the conclusion.

★ **Placement note.**  This lemma feeds `lem:adjacent` in the article's own architecture.  This
development reaches the complex row by a different route (`frameTwistConst`, via `AdjAxis`), so
nothing below consumes `lem:orientation`; it is formalized as an article row, not as a dependency.
-/

section Orientation

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The corner `z = q x p_k` of the article's `lem:orientation`. -/
def coherenceCorner (q p x : HermitianMat n ℂ) : Matrix n n ℂ := q.mat * x.mat * p.mat

/-- `i·z − i·z*` is self-adjoint. -/
theorem orientationJ_isHermitian (q p x : HermitianMat n ℂ) :
    (Complex.I • coherenceCorner q p x - Complex.I • (coherenceCorner q p x)ᴴ).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul, Matrix.conjTranspose_smul,
    Matrix.conjTranspose_conjTranspose]
  simp only [Complex.star_def, Complex.conj_I]
  module

/-- `𝒥_{q,k}(x) = i z − i z*`, `z = q x p_k`, before bundling. -/
def orientationJFun (q p x : HermitianMat n ℂ) : HermitianMat n ℂ :=
  ⟨Complex.I • coherenceCorner q p x - Complex.I • (coherenceCorner q p x)ᴴ,
    orientationJ_isHermitian q p x⟩

@[simp]
theorem orientationJFun_mat (q p x : HermitianMat n ℂ) :
    (orientationJFun q p x).mat
      = Complex.I • coherenceCorner q p x - Complex.I • (coherenceCorner q p x)ᴴ := rfl

/-- **The article's `𝒥_{q,k}`**, as the real-linear map it is. -/
def orientationJ (q p : HermitianMat n ℂ) : HermitianMat n ℂ →ₗ[ℝ] HermitianMat n ℂ where
  toFun := orientationJFun q p
  map_add' x y := by
    ext1
    simp only [orientationJFun_mat, coherenceCorner, HermitianMat.mat_add, Matrix.mul_add,
      Matrix.add_mul, Matrix.conjTranspose_add, smul_add]
    abel
  map_smul' c x := by
    ext1
    simp only [orientationJFun_mat, coherenceCorner, HermitianMat.mat_smul, RingHom.id_apply,
      Matrix.mul_smul, Matrix.smul_mul, Matrix.conjTranspose_smul, star_trivial, smul_sub]
    rw [smul_comm Complex.I, smul_comm Complex.I]

@[simp]
theorem orientationJ_apply (q p x : HermitianMat n ℂ) :
    orientationJ q p x = orientationJFun q p x := rfl


/-- The Peirce eigenrelation `y ∘ x = ½x`, in matrix form. -/
theorem symmMul_eq_half_iff (y x : HermitianMat n ℂ) :
    y.symmMul x = (1 / 2 : ℝ) • x ↔ y.mat * x.mat + x.mat * y.mat = x.mat := by
  constructor
  · intro h
    have h' := congrArg HermitianMat.mat h
    rw [HermitianMat.symmMul_toMat, HermitianMat.mat_smul] at h'
    have hc : ((1 / 2 : ℝ) • x.mat : Matrix n n ℂ) = ((2 : ℂ))⁻¹ • x.mat := by module
    rw [hc] at h'
    exact smul_right_injective _ (by norm_num : ((2 : ℂ))⁻¹ ≠ 0) h'
  · intro h
    ext1
    rw [HermitianMat.symmMul_toMat, HermitianMat.mat_smul, h]
    module


/-- The article's cross-coherence space `X = {x : q ∘ x = ½x = p_k ∘ x}`, as the predicate it is. -/
def IsCrossCoherent (q p x : HermitianMat n ℂ) : Prop :=
  q.symmMul x = (1 / 2 : ℝ) • x ∧ p.symmMul x = (1 / 2 : ℝ) • x

theorem corner_conjTranspose (q p x : HermitianMat n ℂ) :
    (coherenceCorner q p x)ᴴ = p.mat * x.mat * q.mat := by
  rw [coherenceCorner, Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, q.H, p.H, x.H,
    Matrix.mul_assoc]

theorem mul_comm_zero {q p : HermitianMat n ℂ} (hqp : q.mat * p.mat = 0) :
    p.mat * q.mat = 0 := by
  have h := congrArg Matrix.conjTranspose hqp
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_zero, q.H, p.H] at h
  exact h

/-- **The article's identification of `X`**: `x ∈ X` iff `x = z + z*` for its own corner
`z = q x p_k`.  The article asserts this identification; it is proved here. -/
theorem isCrossCoherent_iff {q p : HermitianMat n ℂ}
    (hqp : q.mat * p.mat = 0) (hq : q.mat * q.mat = q.mat) (hp : p.mat * p.mat = p.mat)
    (x : HermitianMat n ℂ) :
    IsCrossCoherent q p x
      ↔ coherenceCorner q p x + (coherenceCorner q p x)ᴴ = x.mat := by
  have hpq : p.mat * q.mat = 0 := mul_comm_zero hqp
  rw [IsCrossCoherent, symmMul_eq_half_iff, symmMul_eq_half_iff, corner_conjTranspose,
    coherenceCorner]
  constructor
  · rintro ⟨h1, h2⟩
    have hxp : x.mat * p.mat = q.mat * x.mat * p.mat := by
      conv_lhs => rw [← h1]
      calc (q.mat * x.mat + x.mat * q.mat) * p.mat
          = q.mat * x.mat * p.mat + x.mat * (q.mat * p.mat) := by noncomm_ring
        _ = q.mat * x.mat * p.mat := by rw [hqp, Matrix.mul_zero, add_zero]
    have hpx : p.mat * x.mat = p.mat * x.mat * q.mat := by
      conv_lhs => rw [← h1]
      calc p.mat * (q.mat * x.mat + x.mat * q.mat)
          = (p.mat * q.mat) * x.mat + p.mat * x.mat * q.mat := by noncomm_ring
        _ = p.mat * x.mat * q.mat := by rw [hpq, Matrix.zero_mul, zero_add]
    rw [← hxp, ← hpx, add_comm]
    exact h2
  · intro hx
    have hqx : q.mat * x.mat = q.mat * x.mat * p.mat := by
      conv_lhs => rw [← hx]
      calc q.mat * (q.mat * x.mat * p.mat + p.mat * x.mat * q.mat)
          = (q.mat * q.mat) * x.mat * p.mat + (q.mat * p.mat) * x.mat * q.mat := by noncomm_ring
        _ = q.mat * x.mat * p.mat := by
            rw [hq, hqp, Matrix.zero_mul, Matrix.zero_mul, add_zero]
    have hxq : x.mat * q.mat = p.mat * x.mat * q.mat := by
      conv_lhs => rw [← hx]
      calc (q.mat * x.mat * p.mat + p.mat * x.mat * q.mat) * q.mat
          = q.mat * x.mat * (p.mat * q.mat) + p.mat * x.mat * (q.mat * q.mat) := by noncomm_ring
        _ = p.mat * x.mat * q.mat := by rw [hpq, hq, Matrix.mul_zero, zero_add]
    have hpx : p.mat * x.mat = p.mat * x.mat * q.mat := by
      conv_lhs => rw [← hx]
      calc p.mat * (q.mat * x.mat * p.mat + p.mat * x.mat * q.mat)
          = (p.mat * q.mat) * x.mat * p.mat + (p.mat * p.mat) * x.mat * q.mat := by noncomm_ring
        _ = p.mat * x.mat * q.mat := by
            rw [hpq, hp, Matrix.zero_mul, Matrix.zero_mul, zero_add]
    have hxp : x.mat * p.mat = q.mat * x.mat * p.mat := by
      conv_lhs => rw [← hx]
      calc (q.mat * x.mat * p.mat + p.mat * x.mat * q.mat) * p.mat
          = q.mat * x.mat * (p.mat * p.mat) + p.mat * x.mat * (q.mat * p.mat) := by noncomm_ring
        _ = q.mat * x.mat * p.mat := by rw [hp, hqp, Matrix.mul_zero, add_zero]
    exact ⟨by rw [hqx, hxq]; exact hx, by rw [hpx, hxp, add_comm]; exact hx⟩

/-- **`lem:orientation`(i), corner.**  On `X`, the corner of `𝒥_{q,k}(x)` is `i z`. -/
theorem orientationJ_corner {q p : HermitianMat n ℂ}
    (hqp : q.mat * p.mat = 0) (hq : q.mat * q.mat = q.mat) (hp : p.mat * p.mat = p.mat)
    (x : HermitianMat n ℂ) :
    coherenceCorner q p (orientationJ q p x) = Complex.I • coherenceCorner q p x := by
  have hpq : p.mat * q.mat = 0 := mul_comm_zero hqp
  rw [orientationJ_apply, coherenceCorner, orientationJFun_mat, corner_conjTranspose,
    coherenceCorner]
  calc q.mat * (Complex.I • (q.mat * x.mat * p.mat)
        - Complex.I • (p.mat * x.mat * q.mat)) * p.mat
      = Complex.I • ((q.mat * q.mat) * x.mat * (p.mat * p.mat))
        - Complex.I • ((q.mat * p.mat) * x.mat * (q.mat * p.mat)) := by
        simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul]
        congr 2 <;> noncomm_ring
    _ = Complex.I • (q.mat * x.mat * p.mat) := by
        rw [hq, hp, hqp, Matrix.zero_mul, Matrix.zero_mul, smul_zero, sub_zero]

/-- **`lem:orientation`(i), stability.**  `𝒥_{q,k}` maps `X` into `X`. -/
theorem orientationJ_isCrossCoherent {q p : HermitianMat n ℂ}
    (hqp : q.mat * p.mat = 0) (hq : q.mat * q.mat = q.mat) (hp : p.mat * p.mat = p.mat)
    {x : HermitianMat n ℂ} (hx : IsCrossCoherent q p x) :
    IsCrossCoherent q p (orientationJ q p x) := by
  rw [isCrossCoherent_iff hqp hq hp] at hx ⊢
  rw [orientationJ_corner hqp hq hp, orientationJ_apply, orientationJFun_mat,
    Matrix.conjTranspose_smul, Complex.star_def, Complex.conj_I]
  module

/-- **`lem:orientation`(i), complex structure.**  `𝒥_{q,k}² = −id` on `X`. -/
theorem orientationJ_sq {q p : HermitianMat n ℂ}
    (hqp : q.mat * p.mat = 0) (hq : q.mat * q.mat = q.mat) (hp : p.mat * p.mat = p.mat)
    {x : HermitianMat n ℂ} (hx : IsCrossCoherent q p x) :
    orientationJ q p (orientationJ q p x) = -x := by
  have hxc := (isCrossCoherent_iff hqp hq hp x).mp hx
  ext1
  rw [orientationJ_apply, orientationJFun_mat, orientationJ_corner hqp hq hp,
    HermitianMat.mat_neg, ← hxc, Matrix.conjTranspose_smul, Complex.star_def, Complex.conj_I]
  match_scalars <;> simp [Complex.I_sq]


/-- **`lem:orientation`(ii).**  Every inner automorphism `Ad_u` fixing `q` and `p_k` commutes
with `𝒥_{q,k}`.  ★ Stated for **every** `x`, not only on `X`: the article's computation
`q(uxu*)p_k = u(q x p_k)u*` never uses the coherence condition, so the restriction to `X` is not
needed and the unrestricted form is what is proved. -/
theorem orientationJ_adU {q p : HermitianMat n ℂ} {u : Matrix n n ℂ}
    (hq : u * q.mat = q.mat * u) (hp : u * p.mat = p.mat * u) (huu : uᴴ * u = 1)
    (x : HermitianMat n ℂ) :
    orientationJ q p (adU u x) = adU u (orientationJ q p x) := by
  have hcorner : coherenceCorner q p (adU u x) = u * coherenceCorner q p x * uᴴ := by
    rw [coherenceCorner, coherenceCorner, adU_apply, HermitianMat.conj_apply_mat]
    calc q.mat * (u * x.mat * uᴴ) * p.mat
        = (q.mat * u) * x.mat * (uᴴ * p.mat) := by noncomm_ring
      _ = (u * q.mat) * x.mat * (p.mat * uᴴ) := by
          rw [← hq]
          congr 1
          have h := congrArg Matrix.conjTranspose hp
          rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, p.H] at h
          exact h.symm
      _ = u * (q.mat * x.mat * p.mat) * uᴴ := by noncomm_ring
  ext1
  rw [orientationJ_apply, orientationJFun_mat, hcorner, adU_apply, HermitianMat.conj_apply_mat,
    orientationJ_apply, orientationJFun_mat]
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose]
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul]
  congr 2 <;> noncomm_ring

/-- **`lem:orientation`(iii), the mechanism at the article's own generality.**  If `u` acts on
`q` and on `p_k` by scalars `c` and `d` whose ratio `c·d̄` is a phase `e^{iφ}` — which `a^{it}`
does, with `c = e^{it\log λ}` and `d = e^{it\log λ_k}`, so `φ = t(\log λ − \log λ_k)` — then
`Ad_u` rotates `X` through `φ` in the orientation fixed by `𝒥_{q,k}`.

★ Unitarity of `u` is **not** assumed: the computation needs only the two scalar actions and
the phase condition on their ratio, so the hypothesis is weaker than "unitary" and the theorem
correspondingly stronger. -/
theorem adU_eq_rotation_on_crossCoherent {q p : HermitianMat n ℂ} {u : Matrix n n ℂ}
    (hqp : q.mat * p.mat = 0) (hq : q.mat * q.mat = q.mat) (hp : p.mat * p.mat = p.mat)
    {c d : ℂ} (hcq : u * q.mat = c • q.mat) (hdp : u * p.mat = d • p.mat)
    {φ : ℝ} (hcd : c * (starRingEnd ℂ) d = Complex.exp ((φ : ℂ) * Complex.I))
    {x : HermitianMat n ℂ} (hx : IsCrossCoherent q p x) :
    adU u x = Real.cos φ • x + Real.sin φ • orientationJ q p x := by
  have hxc := (isCrossCoherent_iff hqp hq hp x).mp hx
  have hpu : p.mat * uᴴ = (starRingEnd ℂ) d • p.mat := by
    have h := congrArg Matrix.conjTranspose hdp
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_smul, p.H] at h
    exact h
  have hcorner : u * coherenceCorner q p x * uᴴ
      = (c * (starRingEnd ℂ) d) • coherenceCorner q p x := by
    rw [coherenceCorner]
    calc u * (q.mat * x.mat * p.mat) * uᴴ
        = (u * q.mat) * x.mat * (p.mat * uᴴ) := by noncomm_ring
      _ = (c • q.mat) * x.mat * ((starRingEnd ℂ) d • p.mat) := by rw [hcq, hpu]
      _ = (c * (starRingEnd ℂ) d) • (q.mat * x.mat * p.mat) := by
          simp only [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
          rw [mul_comm]
  ext1
  rw [adU_apply, HermitianMat.conj_apply_mat, HermitianMat.mat_add, HermitianMat.mat_smul,
    HermitianMat.mat_smul, orientationJ_apply, orientationJFun_mat, ← hxc]
  rw [show u * (coherenceCorner q p x + (coherenceCorner q p x)ᴴ) * uᴴ
      = (u * coherenceCorner q p x * uᴴ) + (u * coherenceCorner q p x * uᴴ)ᴴ from by
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose]
    noncomm_ring]
  rw [hcorner, hcd]
  have hexp : Complex.exp ((φ : ℂ) * Complex.I)
      = ((Real.cos φ : ℝ) : ℂ) + ((Real.sin φ : ℝ) : ℂ) * Complex.I := by
    rw [Complex.exp_mul_I, Complex.ofReal_cos, Complex.ofReal_sin]
  have hstar : star (Complex.exp ((φ : ℂ) * Complex.I))
      = ((Real.cos φ : ℝ) : ℂ) - ((Real.sin φ : ℝ) : ℂ) * Complex.I := by
    rw [hexp]
    simp only [Complex.star_def, map_add, map_mul, Complex.conj_ofReal, Complex.conj_I]
    ring
  rw [Matrix.conjTranspose_smul, hstar, hexp]
  match_scalars <;>
    simp only [← Complex.ofReal_cos, ← Complex.ofReal_sin, Complex.coe_algebraMap] <;>
    ring


/-! ### Non-vacuity: the article's own `q`, `p_k` and `a^{it}` -/

/-- The rank-two projection `q = p_i + p_j` of the article. -/
def framePair (i j : n) : HermitianMat n ℂ := frameProj i + frameProj j

theorem framePair_mat (i j : n) :
    (framePair i j).mat
      = Matrix.diagonal (fun l => (if l = i then (1 : ℂ) else 0) + (if l = j then 1 else 0)) := by
  rw [framePair, HermitianMat.mat_add, frameProj_mat, frameProj_mat, ← Matrix.diagonal_add]

theorem framePair_idem {i j : n} (hij : i ≠ j) :
    (framePair i j).mat * (framePair i j).mat = (framePair i j).mat := by
  rw [framePair_mat, Matrix.diagonal_mul_diagonal]
  congr 1
  funext l
  by_cases hli : l = i
  · simp [hli, hij]
  · by_cases hlj : l = j <;> simp [hli, hlj, Ne.symm hij]

theorem framePair_mul_frameProj {i j k : n} (hki : k ≠ i) (hkj : k ≠ j) :
    (framePair i j).mat * (frameProj k).mat = 0 := by
  rw [framePair_mat, frameProj_mat, Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_zero]
  congr 1
  funext l
  by_cases hlk : l = k
  · subst hlk; simp [hki, hkj]
  · simp [hlk]

theorem frameProj_idem (k : n) : (frameProj k).mat * (frameProj k).mat = (frameProj k).mat := by
  rw [frameProj_mat, Matrix.diagonal_mul_diagonal]
  congr 1
  funext l
  by_cases hlk : l = k <;> simp [hlk]

/-- A diagonal unitary acts by a single scalar on any diagonal projection whose support it is
constant on. -/
theorem torusU_mul_diagonal (t : ℝ) (r : n → ℝ) (h : n → ℂ) (c : ℂ)
    (hc : ∀ l, h l ≠ 0 → Complex.exp ((↑(t * r l) : ℂ) * Complex.I) = c) :
    torusU t r * Matrix.diagonal h = c • Matrix.diagonal h := by
  ext a b
  rw [torusU, Matrix.diagonal_mul_diagonal, Matrix.diagonal_apply, Matrix.smul_apply,
    Matrix.diagonal_apply]
  by_cases hab : a = b
  · subst hab
    simp only [if_pos rfl, smul_eq_mul]
    by_cases hl : h a = 0
    · simp [hl]
    · rw [hc a hl]; simp
  · simp [hab]

/-- **The hypothesis class of `adU_eq_rotation_on_crossCoherent` is inhabited, by `a^{it}`.**
For `a = diag(e^{r_l})` with `r i = r j`, the phase `a^{it} = U_t(r)` acts on `q = p_i + p_j` by
`e^{it r_i}` and on `p_k` by `e^{it r_k}`, so the rotation angle is `t(r_i − r_k)` — the article's
`t(\log λ − \log λ_k)`. -/
theorem torusU_framePair {i j k : n} (hij : i ≠ j) (hki : k ≠ i) (hkj : k ≠ j)
    (t : ℝ) {r : n → ℝ} (hr : r i = r j) :
    torusU t r * (framePair i j).mat
        = Complex.exp ((↑(t * r i) : ℂ) * Complex.I) • (framePair i j).mat
      ∧ torusU t r * (frameProj k).mat
        = Complex.exp ((↑(t * r k) : ℂ) * Complex.I) • (frameProj k).mat
      ∧ Complex.exp ((↑(t * r i) : ℂ) * Complex.I)
          * (starRingEnd ℂ) (Complex.exp ((↑(t * r k) : ℂ) * Complex.I))
        = Complex.exp ((↑(t * (r i - r k)) : ℝ) * Complex.I) := by
  refine ⟨?_, ?_, ?_⟩
  · rw [framePair_mat]
    refine torusU_mul_diagonal t r _ _ (fun l hl => ?_)
    by_cases hli : l = i
    · rw [hli]
    · by_cases hlj : l = j
      · rw [hlj, hr]
      · simp [hli, hlj] at hl
  · rw [frameProj_mat]
    refine torusU_mul_diagonal t r _ _ (fun l hl => ?_)
    by_cases hlk : l = k
    · rw [hlk]
    · simp [hlk] at hl
  · rw [← Complex.exp_conj, ← Complex.exp_add, map_mul, Complex.conj_ofReal, Complex.conj_I]
    congr 1
    push_cast
    ring

/-- `symmMul` is additive in its first slot. -/
theorem symmMul_add_left (A B C : HermitianMat n ℂ) :
    (A + B).symmMul C = A.symmMul C + B.symmMul C := by
  ext1
  rw [HermitianMat.symmMul_toMat, HermitianMat.mat_add, HermitianMat.mat_add,
    HermitianMat.symmMul_toMat, HermitianMat.symmMul_toMat, Matrix.add_mul, Matrix.mul_add]
  module

/-- A block element with a nonzero coordinate is nonzero. -/
theorem blockHerm_ne_zero {i j : n} (hij : i ≠ j) {z : ℂ} (hz : z ≠ 0) :
    blockHerm i j z ≠ 0 := by
  intro h
  refine hz ?_
  have hentry := congrArg (fun M : HermitianMat n ℂ => M.mat i j) h
  rwa [blockHerm_entry hij, HermitianMat.mat_zero, Matrix.zero_apply] at hentry

/-- **The cross-coherence space is not the zero space**: every block element `z E_ik + z̄ E_ki`
lies in it, and by `blockHerm_ne_zero` those are not all zero, so `lem:orientation`'s clauses
are not vacuously true. -/
theorem blockHerm_isCrossCoherent {i j k : n} (hij : i ≠ j) (hki : k ≠ i) (hkj : k ≠ j)
    (z : ℂ) : IsCrossCoherent (framePair i j) (frameProj k) (blockHerm i k z) := by
  refine ⟨?_, frameProj_symmMul_blockHerm_right (Ne.symm hki) z⟩
  rw [framePair, symmMul_add_left,
    frameProj_symmMul_blockHerm_left (Ne.symm hki) z,
    frameProj_symmMul_blockHerm_other (Ne.symm hij) (fun h => hkj h.symm) z, add_zero]


/-- **Clause (iii), fired.**  The witnesses of `torusU_framePair` are plugged into
`adU_eq_rotation_on_crossCoherent`, so the hypothesis class is certified inhabited by
composition rather than by inspection, and the rotation angle is the article's
`t(\log λ − \log λ_k)`. -/
theorem adU_torusU_eq_rotation {i j k : n} (hij : i ≠ j) (hki : k ≠ i) (hkj : k ≠ j)
    (t : ℝ) {r : n → ℝ} (hr : r i = r j) {x : HermitianMat n ℂ}
    (hx : IsCrossCoherent (framePair i j) (frameProj k) x) :
    adU (torusU t r) x
      = Real.cos (t * (r i - r k)) • x
        + Real.sin (t * (r i - r k)) • orientationJ (framePair i j) (frameProj k) x := by
  obtain ⟨h1, h2, h3⟩ := torusU_framePair hij hki hkj t hr
  exact adU_eq_rotation_on_crossCoherent (framePair_mul_frameProj hki hkj)
    (framePair_idem hij) (frameProj_idem k) h1 h2 h3 hx


end Orientation

end Necessity
