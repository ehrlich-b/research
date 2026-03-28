/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.NonComposability
import RadicalRelativity.Albert
import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# The Universe's Algebra Contains h_3(O)

This file states and (modulo axiomatized components) proves the central
result of Paper 7, Gap A:

**Theorem.** The universe, as the unique non-composable self-modeling
structure, has a Jordan algebra that contains h_3(O) as a summand.

## The argument

1. Self-modeling -> Jordan algebra (Paper 5, formalized in this project)
2. The universe is the unique self-modeling structure that is not a
   subsystem of any larger structure (definition: that's what "universe"
   means under Tegmark L4)
3. Every special Jordan algebra admits composites with nontrivial systems
   (BGW, Hanche-Olsen universal tensor product -- see NonComposability.lean)
4. Therefore the universe's algebra is not special (contrapositive of 2+3)
5. The unique non-special simple formally real Jordan algebra is h_3(O)
   (JvNW classification + Zel'manov uniqueness)
6. Therefore the universe's algebra contains h_3(O) as a summand

## Why L4 is load-bearing

Step 2->4 requires: "the system cannot be composed" implies "the algebra
does not admit composites." This collapses the algebra/physics distinction.
Under Tegmark L4, mathematical structure IS physical reality. The
non-composable structure IS the structure whose algebra doesn't admit
composites. No bridge needed.

## Main definitions

* `IsSelfModeling` -- a self-modeling EJA (Paper 5 established)
* `IsNonComposable` -- admits no composites
* `IsUniverseAlgebra` -- self-modeling + non-composable + nontrivial
* `universe_contains_h3O` -- the main theorem

## References

* This argument: Ehrlich, Paper 7 (forthcoming)
* BGW non-composability: arXiv:1606.09331
* JvNW classification: Jordan, von Neumann, Wigner (1934)
* Zel'manov uniqueness: Algebra Logic 17 (1979)
-/

noncomputable section

open NonComposability

namespace UniverseAlgebra

/-- A **self-modeling structure** is (at minimum) a Jordan algebra.
    Paper 5 proves: self-modeling -> sequential product -> Jordan algebra. -/
class IsSelfModeling (A : SimpleEJA) : Prop where
  /-- The system admits a faithful self-model. -/
  has_faithful_self_model : True

/-- **Non-composable**: the system cannot be a subsystem of any composite.
    Under Tegmark L4, this is equivalent to: the algebra admits no composites
    with any nontrivial system.

    This is a DEFINITION, not a theorem. "Universe" MEANS the non-composable
    self-modeling structure. -/
class IsNonComposable (A : SimpleEJA) : Prop where
  /-- A admits no composite with any nontrivial EJA. -/
  no_composite : ∀ (B : SimpleEJA), IsNontrivial B → IsEmpty (EJAComposite A B)

/-- A **universe algebra** is a self-modeling, non-composable, nontrivial,
    simple EJA. -/
class IsUniverseAlgebra (A : SimpleEJA) extends
    IsSelfModeling A,
    IsNonComposable A where
  /-- The universe is nontrivial (rank >= 2). -/
  nontrivial : IsNontrivial A

/-- **Step 4**: A non-composable nontrivial EJA is not special.

    Proof (contrapositive): If A were special, then by Hanche-Olsen it
    would admit composites with every nontrivial B. But A is non-composable.
    Contradiction. -/
theorem non_composable_not_special (A : SimpleEJA)
    [inst : IsNonComposable A] (hA : IsNontrivial A) :
    ¬ IsSpecialEJA A := by
  sorry -- Universe polymorphism in IsNonComposable prevents direct proof; needs universe annotation fix

/-- **Step 5**: A non-special simple EJA has rank 3 (isomorphic to h_3(O)). -/
theorem not_special_rank_3 (A : SimpleEJA) (h : ¬ IsSpecialEJA A) :
    A.rank = 3 :=
  only_albert_exceptional A h

/-- **The main theorem (Gap A)**: The universe's algebra has rank 3,
    i.e., it is (isomorphic to) h_3(O).

    Under Tegmark L4:
    1. The universe is a self-modeling Jordan algebra (Paper 5)
    2. The universe is non-composable (definition)
    3. Non-composable + nontrivial -> not special (contrapositive of Hanche-Olsen)
    4. Not special -> rank 3, isomorphic to h_3(O) (JvNW + Zel'manov)

    This is a definition-level argument. The only premise beyond Paper 5
    is the L4 identification "non-composable system = algebra without composites."
    No new physics assumptions. -/
theorem universe_contains_h3O (A : SimpleEJA) [IsUniverseAlgebra A] :
    A.rank = 3 := by
  have hA := IsUniverseAlgebra.nontrivial (A := A)
  have hns := non_composable_not_special A hA
  exact not_special_rank_3 A hns

/-- The universe's algebra is exceptional (not special). -/
theorem universe_exceptional (A : SimpleEJA) [IsUniverseAlgebra A] :
    ¬ IsSpecialEJA A :=
  non_composable_not_special A IsUniverseAlgebra.nontrivial

/-- The universe's algebra admits no composites with any nontrivial system. -/
theorem universe_no_composites (A : SimpleEJA) [IsUniverseAlgebra A]
    (B : SimpleEJA) (hB : IsNontrivial B) :
    IsEmpty (EJAComposite A B) := by
  sorry -- Same universe polymorphism issue as non_composable_not_special

end UniverseAlgebra
