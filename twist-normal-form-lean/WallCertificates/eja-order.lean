/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity

set_option linter.style.longLine false

/-!
# WALL CERTIFICATE — the Euclidean form, the one residue of `RadicalRelativity/EJA/Order.lean`

**Written 2026-08-22, ARC-9.**

`RadicalRelativity/EJA/Order.lean` was built to answer one question: can a Euclidean Jordan
algebra carry an `OrderUnitSpace`, so that `SequentialProductOn` is statable at EJA generality?
**It can, and it does** — `RadicalRelativity.EJA.orderUnitSpaceOfBilinear`, custom axioms
exactly `[]`.  That target is not what this certificate is about, and nothing below weakens it.

What this certificate records is the **one hypothesis that file introduces and does not
discharge**: the associativity of the inner product,

  `⟪x ∘ y, z⟫ = ⟪y, x ∘ z⟫`,

carried as `hassoc` by six declarations, enumerated by
`awk '/^theorem |^def |^abbrev /{n=$2} /hassoc :/{print n}' RadicalRelativity/EJA/Order.lean`
rather than from memory.  Faraut–Korányi define a *Euclidean* Jordan algebra to be a
finite-dimensional real Jordan algebra carrying such a form (FK Def. III.1.1), and prove that
for a finite-dimensional real Jordan algebra with unit this is **equivalent** to formal
reality, the witness being the trace form `τ(x, y) = tr(L_{x ∘ y})` (FK Prop. VIII.4.2).  That
equivalence is not formalized in this tree, so the file's third section carries a hypothesis
its first two sections do not.

```
grep -rn "^import.*WallCertificates" RadicalRelativity/ RadicalRelativity.lean   # expect no hits
cd /Users/ehrlich/repos/research/twist-normal-form-lean
lake env lean WallCertificates/eja-order.lean    # expect: exactly one `declaration uses `sorry``
```

## Scope of the gap: which results carry `hassoc` and which do not

| result | needs `hassoc`? |
| --- | --- |
| `orderUnitSpaceOfBilinear` — the `OrderUnitSpace` itself: its five own fields and the `PartialOrder` parent | **no** |
| `exists_isSoS_smul_unit_sub` — order-unit boundedness | **no** |
| `partialOrderOfSoS`, `eq_zero_of_isSoS_of_isSoS_neg` — the order and its antisymmetry | **no** |
| `hermitian_isSoS_iff_nonneg`, `hermitian_le_ofEJA_iff` — the order *is* the Loewner order on `H_n(𝕜)` | **no** (it discharges `hassoc` from `hermitian_jordan_assoc`) |
| `inner_mul_self_nonneg_of_idem` — `L_c ≥ 0` for an idempotent `c` | yes |
| `inner_left_coeff` — pairing against `q k` reads off `lam k` | yes |
| `nonneg_coeff_of_inner_nonneg` — nonnegative pairing gives a nonnegative coefficient | yes |
| `nonneg_coeff_of_isSoS` — a sum of squares has nonnegative coefficients | yes |
| `isArchimedean_ofBilinear` — the genuine Archimedean squeeze | yes |
| `isSoS_iff_exists_sq` — the cone of squares reading (`nonneg_iff_squares`) | yes |

That is the complete list of six, and the row above the rule is the one worth reading twice:
the Loewner-agreement results on the paper's own carrier are **not** blocked by this gap,
because `hermitian_jordan_assoc` discharges `hassoc` there outright.

So the gap does not touch the order structure.  It bounds how much of the *Euclidean* theory is
unconditional.

## The gap, stated

`gap_associative_form_of_formallyReal` below is FK Prop. VIII.4.2 in this tree's bilinear-map
vocabulary: from the Jordan identity, formal reality, a unit and finite dimension, produce a
symmetric positive-definite associative form.  Its hypotheses are exactly those of
`orderUnitSpaceOfBilinear`, so it is stated at the generality that would consume it.

★ **The obvious stronger statement is FALSE**, and it was considered and rejected before this
certificate was written rather than tried in Lean.  The version that would plug straight into
the six declarations above is

    `… → ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z)`

— "the *ambient* inner product is automatically associative".  Every hypothesis constrains `m`
alone and none mentions `inner`, which is suggestive but is not itself a refutation, since
rescaling a form by a single positive constant preserves associativity.  The refutation is that
on a *simple* Euclidean Jordan algebra the associative forms are exactly the positive multiples
of the trace form, so any non-proportional rescaling breaks associativity while leaving every
hypothesis untouched: on `H₂(ℝ)`, scale the diagonal part of the ambient form by 2 and the
off-diagonal part by 1.  That is still positive definite, hence still an `InnerProductSpace ℝ`
instance, and the Jordan identity, formal reality, the unit and finite dimension are unchanged.
The honest statement is therefore existential, and that has a consequence recorded in the next
section rather than buried.

## What discharging it would and would not do

★ **Discharging the statement below does not by itself remove `hassoc` from those six
declarations.**  It produces *some* associative form `B`, while they are stated against
the ambient `inner ℝ` — which `ComparisonSetup` carries and which the gap cannot constrain, for
the reason just given.  Consuming it means first restating
`RadicalRelativity/EJA/Order.lean`'s third section over an abstract form `B : J →ₗ[ℝ] J →ₗ[ℝ] ℝ`
in place of `inner ℝ`.  That restatement is mechanical — the proofs use only bilinearity,
symmetry, positive-definiteness and associativity, never completeness or the norm — but it is
work that has not been done, and pricing it as "free" is exactly the kind of claim this
directory exists to stop.

## Non-vacuity, checked rather than asserted

The hypothesis bundle is inhabited: `H_n(𝕜)` satisfies every hypothesis below, each as a
compiling theorem in `RadicalRelativity/EJA/Order.lean` — `hermitian_jordan_comm`,
`hermitian_jordan_id`, `hermitian_formallyReal`, `hermitian_jordan_unit` — and it satisfies the
associativity conclusion as well (`hermitian_jordan_assoc`, proved from `Matrix.trace_mul_cycle`
and nothing else).  So the gap is a real gap in a real theory, not a conditional about an empty
class.

★ **Variance check** (the `gate_E2_peirce` lesson: an existential is *antitone* in its own
witnesses, so "constrain the witnesses" makes an existential statement harder, not weaker, and
adding hypotheses makes it weaker, not harder).  The conclusion here is an existential over
forms with three clauses; dropping any clause would weaken it toward vacuity, and the three
carried are exactly the three FK's definition requires.  The hypotheses are exactly
`orderUnitSpaceOfBilinear`'s, neither padded nor trimmed.

★ **Self-defeat check.**  Assume the gap and check it contradicts nothing already proved: it
asserts the existence of an associative form, and `hermitian_jordan_assoc` exhibits one on the
paper's carrier, so the gap is consistent with — indeed instantiated by — the tree's own
results.

## Absence claims, with the scope of the grep that supports each (all 2026-08-22)

* **No trace form, and no `L` operator on which to define one, exists in this tree at EJA
  generality.**  `grep -rn "traceForm\|trace_form" RadicalRelativity/` returns nothing.  The
  nearest object is `RadicalRelativity.EJA.mulL` (`EJA/Peirce.lean:150`), which is `L_c` as an
  `ℝ`-linear map, so `tr (mulL (m x y))` is *expressible*; what is absent is any development of
  its symmetry or positive-definiteness.
* **Mathlib has no Euclidean Jordan algebra API to import this from.**
  `grep -rln "EuclideanJordan\|JordanFrame" .lake/packages/mathlib/Mathlib/` returns 0 files of
  8311 scanned, and `Mathlib/Algebra/Jordan/` contains exactly one file, `Basic.lean`, which
  supplies `IsCommJordan` and the linearised Jordan identities and stops there — no order, no
  trace form, no spectral theory.
* **Mathlib's `traceForm` is the wrong trace form**, and this is the claim most likely to be
  misread as "Mathlib already has it".  `Algebra.traceForm` (`Mathlib/RingTheory/Trace/Defs.lean:171`)
  is built over `[CommRing R] [CommRing S] [Algebra R S]`, so it is the trace form of an
  *associative commutative* algebra.  A Jordan algebra is not associative and the EJA layer
  carries no `Algebra` instance, so it does not apply and cannot be specialised to apply.
* ★ **A third bullet here claimed Mathlib has no `IsFormallyReal`, and that was false** — caught
  by running the grep it cited instead of trusting it.  `Mathlib/Algebra/Ring/IsFormallyReal.lean`
  defines `class IsFormallyReal [AddCommMonoid R] [Mul R]` (line 104), and those hypotheses are
  **non-associative**, so it would apply to a Jordan algebra; this tree carries its own
  `RadicalRelativity.EJA.IsFormallyReal` in `Finset` form instead.  That has no bearing on the
  gap below — formal reality is a *hypothesis* here, not the conclusion — but the correction
  belongs in the record, because the retracted sentence was the kind that gets forwarded.

## What was attempted

**Nothing, and the cost is not priced here.**  The route is textbook — define
`τ(x,y) = tr (mulL (m x y))`, get symmetry from `peirce_poly`-style operator identities, get
positive-definiteness from formal reality via the spectral resolution the tree already has — and
it was not attempted, because `EJA/Order.lean`'s target did not need it: the `OrderUnitSpace`
fields never touch the form, and the three results that do have a live carrier through
`hermitian_jordan_assoc`.  Recording that plainly is the point of the file: **this is an
unattempted gap, not a wall that resisted an attempt**, and the two must not be confused in
either direction.  No estimate of its size is offered, because an unattempted estimate is
exactly the sort of prose price this directory exists to stop.
-/

namespace WallCertificate

open RadicalRelativity.EJA

/-- **THE GAP — Faraut–Korányi Prop. VIII.4.2**, in `ComparisonSetup`'s bilinear-map
vocabulary: a finite-dimensional formally real unital Jordan algebra carries a symmetric,
positive-definite, **associative** bilinear form.

The `sorry` is at exactly this step and nowhere else in the certificate.  Discharging it is
the first half of removing `hassoc` from `RadicalRelativity/EJA/Order.lean`'s third section;
the second half is the restatement over an abstract form described in the header. -/
theorem gap_associative_form_of_formallyReal
    {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J] [FiniteDimensional ℝ J]
    (m : J →ₗ[ℝ] J →ₗ[ℝ] J)
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (e : J) (he : ∀ y : J, m e y = y) :
    ∃ B : J →ₗ[ℝ] J →ₗ[ℝ] ℝ,
      (∀ x y : J, B x y = B y x) ∧
      (∀ x : J, x ≠ 0 → 0 < B x x) ∧
      (∀ x y z : J, B (m x y) z = B y (m x z)) := by
  sorry

/-- The gap is not vacuous: `H_n(𝕜)` meets every hypothesis, and meets the conclusion too.
Proved outright — no `sorry` — from `RadicalRelativity/EJA/Order.lean`'s carrier section. -/
theorem gap_nonvacuous {n : Type*} [Fintype n] [DecidableEq n] {𝕜 : Type*} [RCLike 𝕜] :
    ∃ B : HermitianMat n 𝕜 →ₗ[ℝ] HermitianMat n 𝕜 →ₗ[ℝ] ℝ,
      (∀ x y : HermitianMat n 𝕜, B x y = B y x) ∧
      (∀ x : HermitianMat n 𝕜, x ≠ 0 → 0 < B x x) ∧
      (∀ x y z : HermitianMat n 𝕜,
        B (Necessity.jordanBilinG 𝕜 x y) z = B y (Necessity.jordanBilinG 𝕜 x z)) := by
  refine ⟨innerₗ (HermitianMat n 𝕜), fun x y => real_inner_comm y x,
    fun x hx => real_inner_self_pos.mpr hx, fun x y z => hermitian_jordan_assoc x y z⟩

end WallCertificate
