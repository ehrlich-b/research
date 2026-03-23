/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/

import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# Non-Composability of Exceptional Jordan Algebras

The Barnum-Graydon-Wilce theorem (Quantum 4, 359, 2020): any composite of
simple, nontrivial Euclidean Jordan algebras is special. Consequently, if A
contains an exceptional summand and B is nontrivial, no composite AB exists.

## The rank argument

1. Let AB be a composite of simple nontrivial EJAs A (rank m) and B (rank n).
2. By the exchange lemma, product projections are pairwise equivalent.
3. Every simple summand of AB has rank ≥ mn ≥ 4 (since m,n ≥ 2).
4. By JvNW, all simple Jordan algebras of rank ≥ 4 are special.
5. Therefore AB is special.
6. If A had an exceptional summand, it would embed faithfully in the
   special algebra AB. But exceptional algebras have no faithful
   representations in special algebras. Contradiction.

## Why this matters

This theorem is load-bearing for Gap A of Paper 7:

- The universe is the unique self-modeling structure that cannot be a
  subsystem of any larger structure (definition under L4).
- Every SPECIAL Jordan algebra CAN be a subsystem (the Hanche-Olsen
  universal tensor product provides the composite).
- Therefore the universe's algebra is NOT special (contrapositive).
- The unique non-special simple Jordan algebra is h_3(O) (JvNW + Zel'manov).
- Therefore the universe contains h_3(O).

## What needs to be formalized

1. Definition of "composite" (dynamical composite axioms from BGW)
2. The exchange lemma (product projections are equivalent)
3. The rank argument (rank of composite ≥ product of ranks)
4. JvNW: rank ≥ 4 simple EJAs are special (needs the classification)
5. Main theorem: composites of simple nontrivial EJAs are special
6. Corollary: exceptional algebras admit no composites with nontrivial systems
7. Converse: special EJAs DO admit composites (Hanche-Olsen construction)

## References

* Barnum, Graydon, Wilce, "Composites and Categories of Euclidean Jordan Algebras,"
  Quantum 4, 359 (2020), arXiv:1606.09331
* Hanche-Olsen, "On the structure and tensor products of JC-algebras,"
  Canadian J. Math. 35 (1983)
-/

-- TODO: Phase 2
-- The rank argument is clean and self-contained.
-- Main dependency: JvNW classification (rank ≥ 4 implies special).
-- Could axiomatize JvNW and prove the rank argument from it.
