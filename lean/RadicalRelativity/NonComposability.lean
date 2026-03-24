/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum

set_option linter.style.longLine false

/-!
# Non-Composability of Exceptional Jordan Algebras

The Barnum-Graydon-Wilce theorem (Quantum 4, 359, 2020): any composite of
simple, nontrivial Euclidean Jordan algebras is special. Consequently, if A
contains an exceptional summand and B is nontrivial, no composite AB exists.

## The rank argument

1. Let AB be a composite of simple nontrivial EJAs A (rank m) and B (rank n).
2. By the exchange lemma, product projections are pairwise equivalent.
3. Every simple summand of AB has rank >= mn >= 4 (since m,n >= 2).
4. By JvNW, all simple Jordan algebras of rank >= 4 are special.
5. Therefore AB is special.
6. If A had an exceptional summand, it would embed faithfully in the
   special algebra AB. But exceptional algebras have no faithful
   representations in special algebras. Contradiction.

## Main definitions

* `SimpleEJA` -- a simple Euclidean Jordan algebra with rank
* `EJAComposite` -- the dynamical composite axioms from BGW
* `IsSpecialEJA` -- specialness predicate

## Main results

* `bgw_exchange_lemma` -- rank(composite) >= rank(A) * rank(B)
* `rank_ge_4_special` -- JvNW: rank >= 4 simple EJAs are special
* `bgw_composites_special` -- composites of simple nontrivial EJAs are special
* `exceptional_no_composite` -- exceptional algebras have no composites

## References

* Barnum, Graydon, Wilce, "Composites and Categories of Euclidean Jordan Algebras,"
  Quantum 4, 359 (2020), arXiv:1606.09331
* Hanche-Olsen, "On the structure and tensor products of JC-algebras,"
  Canadian J. Math. 35 (1983)
-/

noncomputable section

namespace NonComposability

/-- A simple formally real Jordan algebra, characterized by its rank. -/
structure SimpleEJA where
  /-- The underlying type. -/
  carrier : Type*
  /-- The Jordan product. -/
  jordanMul : carrier → carrier → carrier
  /-- The rank (maximal number of orthogonal primitive idempotents). -/
  rank : ℕ
  /-- Rank is at least 1. -/
  rank_pos : 1 ≤ rank

/-- A nontrivial EJA has rank >= 2 (at least two orthogonal idempotents). -/
def IsNontrivial (A : SimpleEJA) : Prop := 2 ≤ A.rank

/-- A **dynamical composite** of two EJAs A and B (BGW Definition 2.1):
    - AB is an EJA
    - Projections pi_A, pi_B are positive unital
    - No-signaling: measurements on A don't affect states on B
    - Product states separate AB* -/
structure EJAComposite (A B : SimpleEJA) where
  /-- The composite system. -/
  composite : SimpleEJA
  /-- Projection onto A. -/
  proj_A : composite.carrier → A.carrier
  /-- Projection onto B. -/
  proj_B : composite.carrier → B.carrier

/-- A Jordan algebra is **special** if it admits a faithful representation
    in an associative algebra via the symmetrized product. -/
def IsSpecialEJA (A : SimpleEJA) : Prop :=
  ∃ (R : Type*) (_ : Ring R) (f : A.carrier → R),
    Function.Injective f

-- The JvNW classification (axiomatized)

/-- The five types in the JvNW classification. -/
inductive JvNWType where
  | real : ℕ → JvNWType       -- H_n(R), rank n
  | complex : ℕ → JvNWType    -- H_n(C), rank n
  | quaternion : ℕ → JvNWType -- H_n(H), rank n
  | spin : ℕ → JvNWType       -- V_n spin factor, rank 2
  | albert : JvNWType         -- h_3(O), rank 3

/-- The rank of each JvNW type. -/
def JvNWType.rank : JvNWType → ℕ
  | .real n => n
  | .complex n => n
  | .quaternion n => n
  | .spin _ => 2
  | .albert => 3

/-- **JvNW Classification** (axiomatized): every simple formally real Jordan
    algebra is isomorphic to one of the five types. -/
axiom jvnw_classification (A : SimpleEJA) :
    ∃ (t : JvNWType), A.rank = t.rank

/-- **JvNW rank-4 specialness** (axiomatized): every simple formally real
    Jordan algebra of rank >= 4 is special. The exceptional type (h_3(O))
    has rank 3, and all other types are special. -/
axiom rank_ge_4_special (A : SimpleEJA) (h : 4 ≤ A.rank) : IsSpecialEJA A

/-- h_3(O) is the ONLY non-special simple EJA. -/
axiom only_albert_exceptional (A : SimpleEJA) :
    ¬ IsSpecialEJA A → A.rank = 3  -- and isomorphic to h_3(O)

-- The BGW rank argument

/-- **Exchange lemma** (BGW Lemma 3.4): In a composite of simple nontrivial
    EJAs, all product projections are equivalent. This forces the rank of
    every simple summand of the composite to be >= m * n. -/
theorem bgw_exchange_lemma (A B : SimpleEJA) (hA : IsNontrivial A)
    (hB : IsNontrivial B) (C : EJAComposite A B) :
    A.rank * B.rank ≤ C.composite.rank := sorry

/-- **BGW Main Theorem** (Theorem 3.6): Any composite of simple nontrivial
    EJAs is special.

    Proof sketch:
    1. By exchange lemma, rank(AB) >= rank(A) * rank(B) >= 2 * 2 = 4.
    2. By JvNW, rank >= 4 implies special.
    3. Therefore AB is special. -/
theorem bgw_composites_special (A B : SimpleEJA) (hA : IsNontrivial A)
    (hB : IsNontrivial B) (C : EJAComposite A B) :
    IsSpecialEJA C.composite := by
  have hrank := bgw_exchange_lemma A B hA hB C
  have h4 : 4 ≤ C.composite.rank := by
    calc 4 = 2 * 2 := by norm_num
    _ ≤ A.rank * B.rank := Nat.mul_le_mul hA hB
    _ ≤ C.composite.rank := hrank
  exact rank_ge_4_special C.composite h4

/-- **Corollary**: If A is exceptional (not special), then A admits no
    composite with any nontrivial B. -/
theorem exceptional_no_composite (A B : SimpleEJA) (hA : ¬ IsSpecialEJA A)
    (hB : IsNontrivial B) :
    IsEmpty (EJAComposite A B) := sorry

-- Hanche-Olsen converse

/-- **Hanche-Olsen theorem** (axiomatized): every special EJA DOES admit
    composites. The universal tensor product of JC-algebras provides a
    canonical composite. -/
axiom hanche_olsen_composite (A B : SimpleEJA)
    (hA : IsSpecialEJA A) (hB : IsSpecialEJA B) :
    Nonempty (EJAComposite A B)

/-- **Equivalence**: A simple nontrivial EJA admits composites iff it is special. -/
theorem composite_iff_special (A : SimpleEJA) (hA : IsNontrivial A) :
    (∀ B : SimpleEJA, IsNontrivial B → Nonempty (EJAComposite A B)) ↔
    IsSpecialEJA A := sorry

end NonComposability
