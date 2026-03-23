/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Compression
import RadicalRelativity.PeirceDecomp
import Mathlib.Tactic.Abel

set_option linter.style.longLine false

/-!
# Self-Compatibility and the Jordan Identity

Key results toward the Jordan identity:

1. Every effect `a` is compatible with `a & a` (via S7)
2. For compatible effects, the Jordan identity follows from S5
3. The general Jordan identity requires the spectral theorem

## Main results

* `self_compatible_sq` — a is compatible with a & a
* `jordan_identity_compatible` — Jordan identity for compatible effects
* `sp_assoc_with_square` — a & ((a²) & b) = (a & a²) & b

## References

* van de Wetering, arXiv:1803.11139, §4
-/

noncomputable section

open OrderUnitSpace SequentialProduct Compression

namespace SelfCompatibility

variable {V : Type*} [SequentialProduct V]

/-- **Self-compatibility with square**: a is compatible with a & a.
    Proof: a|a (trivially), so by S7, a|(a & a). -/
theorem self_compatible_sq {a : V} (ha : IsEffect a) :
    a & (a & a) = (a & a) & a :=
  compatible_sp ha ha ha rfl rfl

/-- a & a is an effect when a is an effect. -/
theorem sq_effect {a : V} (ha : IsEffect a) : IsEffect (a & a) :=
  sp_effect ha ha

/-- **Associativity with square**: a & ((a & a) & b) = (a & (a & a)) & b.
    Follows from S5 since a is compatible with a & a. -/
theorem sp_assoc_with_square {a b : V} (ha : IsEffect a) (hb : IsEffect b) :
    a & ((a & a) & b) = (a & (a & a)) & b :=
  sp_assoc_of_compatible ha (sq_effect ha) hb (self_compatible_sq ha)

/-- a & a is compatible with a. -/
theorem sq_compatible_self {a : V} (ha : IsEffect a) :
    (a & a) & a = a & (a & a) :=
  (self_compatible_sq ha).symm

/-- **Associativity with square (flipped)**:
    (a & a) & (a & b) = a & (a & (a & b)) when a|b.
    Uses S5 with a|a: (a & a) & (a & b) = a & (a & (a & b)). -/
theorem sp_sq_assoc_of_compatible {a b : V}
    (ha : IsEffect a) (hb : IsEffect b) (_hcompat : a & b = b & a) :
    (a & a) & (a & b) = a & (a & (a & b)) :=
  -- S5 with a|a applied to (a & b): a & (a & (a&b)) = (a&a) & (a&b)
  (sp_assoc_of_compatible ha ha (sp_effect ha hb) rfl).symm

/-- **The Jordan identity for compatible effects**:

    When a|b, both sides of the Jordan identity
    (a ∘ b) ∘ a² = a ∘ (b ∘ a²)
    reduce to (a & b) & (a & a) = a & (b & (a & a)),
    which is S5 applied with a|b. -/
theorem jordan_identity_compatible {a b : V}
    (ha : IsEffect a) (hb : IsEffect b) (hcompat : a & b = b & a) :
    (a & b) & (a & a) = a & (b & (a & a)) :=
  (sp_assoc_of_compatible ha hb (sq_effect ha) hcompat).symm

/-- **S5 chain**: a & (a & (a & b)) = ((a & a) & a) & b when a|b.
    Triple application of S5 using a|a and a|b. -/
theorem sp_triple_assoc_compatible {a b : V}
    (ha : IsEffect a) (hb : IsEffect b) (hcompat : a & b = b & a) :
    a & (a & (a & b)) = (a & (a & a)) & b := by
  -- First: a & (a & b) = (a & a) & b by S5 (a|a)... wait, that needs a|a which is trivial
  rw [sp_assoc_of_compatible ha ha hb rfl]
  -- Now: a & ((a & a) & b) = (a & (a & a)) & b
  exact sp_assoc_with_square ha hb

end SelfCompatibility
