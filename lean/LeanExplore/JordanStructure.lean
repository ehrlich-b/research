/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import LeanExplore.SequentialProduct
import LeanExplore.Compression
import LeanExplore.SpectralTheorem
import Mathlib.Algebra.Jordan.Basic

set_option linter.style.longLine false

/-!
# Jordan Algebra Structure from Sequential Product

The Jordan product `a ∘ b = ½(a & b + b & a)` makes a sequential product space
into a (commutative) Jordan algebra. This is the key algebraic consequence of
the S1-S7 axioms, formalized as van de Wetering's Theorem 1.

## Proven results

* `jordan_comm` — the Jordan product is commutative
* `jordanMul_eq_sp_of_compatible` — for compatible effects, ∘ = &
* `jordan_identity_compatible_sp` — the Jordan identity for compatible effects
  at the sequential product level: (a & b) & a² = a & (b & a²)

## The remaining gap

The *general* Jordan identity requires the spectral theorem: decompose
`a` and `b` into shared eigenbases and reduce to the compatible case.
This is marked as a single sorry — the load-bearing axiom gap.

## References

* van de Wetering, arXiv:1803.11139, Theorem 1
-/

noncomputable section

open OrderUnitSpace SequentialProduct SelfCompatibility

namespace JordanStructure

variable {V : Type*} [SequentialProduct V]

/-- The Jordan product on a sequential product space. -/
def jordanMul (a b : V) : V := (1/2 : ℝ) • ((a & b) + (b & a))

/-- The Jordan product is commutative. -/
theorem jordan_comm (a b : V) : jordanMul a b = jordanMul b a := by
  unfold jordanMul
  congr 1
  exact add_comm _ _

/-- For compatible effects, the Jordan product equals the sequential product. -/
theorem jordanMul_eq_sp_of_compatible {a b : V}
    (hab : a & b = b & a) : jordanMul a b = a & b := by
  unfold jordanMul
  rw [hab, ← two_smul ℝ (b & a), smul_smul]
  norm_num

/-- For compatible effects, a² under Jordan = a & a. -/
theorem jordanSq_eq_sp_sq {a : V} :
    jordanMul a a = a & a := by
  exact jordanMul_eq_sp_of_compatible rfl

/-- **Jordan identity at the SP level for compatible effects** (proven):
    (a & b) & (a & a) = a & (b & (a & a))
    This is S5 applied with a|b. -/
theorem jordan_identity_compatible_sp {a b : V}
    (ha : IsEffect a) (hb : IsEffect b) (hcompat : a & b = b & a) :
    (a & b) & (a & a) = a & (b & (a & a)) :=
  SelfCompatibility.jordan_identity_compatible ha hb hcompat

/-- **The Jordan identity** (general form):
    (a ∘ b) ∘ a² = a ∘ (b ∘ a²)

    **Status**: This is the single remaining axiom gap.

    The compatible case is fully proven above. The general case requires
    the spectral theorem for OUS (Alfsen-Shultz, Ch. 7-9):
    decompose a into its spectral form a = Σ λᵢ pᵢ, then the Jordan
    identity reduces to the compatible case on each spectral component.

    van de Wetering's proof (arXiv:1803.11139, §4) proceeds by:
    1. Use the spectral theorem to write a = Σ λᵢ pᵢ
    2. Show L_a acts on each Peirce subspace V₂(pᵢ) and V₁(pᵢ,pⱼ)
    3. Show L_a and L_{a²} commute on each subspace
    4. The commutation L_a ∘ L_{a²} = L_{a²} ∘ L_a IS the Jordan identity

    We axiomatize this as an explicit named axiom rather than leaving a sorry,
    following the recommendation to be honest about what is assumed vs proved. -/
axiom spectral_jordan_identity :
  ∀ (V : Type*) [inst : SequentialProduct V] (a b : V),
    IsEffect a → IsEffect b →
    jordanMul (jordanMul a b) (jordanMul a a) =
    jordanMul a (jordanMul b (jordanMul a a))

theorem jordan_identity (a b : V) (ha : IsEffect a) (hb : IsEffect b) :
    jordanMul (jordanMul a b) (jordanMul a a) =
    jordanMul a (jordanMul b (jordanMul a a)) :=
  spectral_jordan_identity V a b ha hb

/-- **van de Wetering Theorem 1** (alternative form):
    a² ∘ (a ∘ b) = a ∘ (a² ∘ b). Follows from jordan_identity by commutativity. -/
theorem vdw_theorem_1 (a b : V) (ha : IsEffect a) (hb : IsEffect b) :
    jordanMul (jordanMul a a) (jordanMul a b) =
    jordanMul a (jordanMul (jordanMul a a) b) := by
  rw [jordan_comm (jordanMul a a) (jordanMul a b)]
  rw [jordan_comm (jordanMul a a) b]
  exact jordan_identity a b ha hb

end JordanStructure
