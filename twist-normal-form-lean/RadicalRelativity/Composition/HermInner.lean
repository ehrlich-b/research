/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Composition.HermMat
import Mathlib.Analysis.InnerProductSpace.Basic

set_option linter.style.longLine false

/-!
# The Euclidean structure on `H(ι, C)`

`RadicalRelativity/Composition/HermMat.lean` builds `HermMat ι C` as a `Submodule ℝ (Matrix ι ι C)`
and equips it with the symmetrised product `hermBilin`, but leaves it with **no norm and no inner
product**.  This file adds them: the entrywise form

```
⟪A, B⟫ = ∑ i, ∑ j, ⟪A i j, B i j⟫_C
```

built from the composition algebra's own form `ip` (`Composition/Defs.lean:82`), together with the
`Inner ℝ`, `NormedAddCommGroup` and `InnerProductSpace ℝ` instances it induces through
`InnerProductSpace.Core`.

## Why the entrywise form and not the trace form

`Albert/Inner.lean` uses `⟪a, b⟫ = Tr(a ∘ b)` on the 27-real-coordinate carrier `h3O`.  Here the
carrier is an honest submodule of a matrix space, so the entrywise sum is available directly and
its positive definiteness is immediate from `B_pos` on each entry — no expansion of a Jordan
product is needed, and in particular **no associativity, no `Nontrivial C`, and no `DecidableEq ι`
is used anywhere in this file**.

★ That the two agree — `∑ i, ∑ j, ⟪A i j, B i j⟫_C = Tr(A ∘ B)` — is classical and is what makes
the entrywise form the *trace* form, but it is **not proved here**: this file constructs no trace
map on `HermMat ι C` and states no theorem relating `hermIp` to `hermBilin`.  Treat the
identification as a citation, not as a result of this tree.

## The Euclidean hypothesis

`⟪A ∘ B, D⟫ = ⟪B, A ∘ D⟫` — associativity of the form against the symmetrised product, spelled
`hassoc` at `Albert/Inner.lean:172` for `h3O` and carried as an explicit hypothesis on six
declarations of `EJA/Order.lean` — **is** proved below, as `hermIp_jmul_assoc`, and restated in
`EJA/Order.lean`'s own vocabulary as `hermHassoc`.  It holds for an arbitrary Euclidean
composition algebra `C` and an arbitrary `[Fintype ι]`: the proof runs `ip_mul_adj_left` /
`ip_mul_adj_right` (`Composition/Defs.lean:229,238`) entrywise, and those two are polarisations of
the composition law, so no associativity, no alternativity, no `Nontrivial C` and no
`DecidableEq ι` enters.

★ **This does not exhibit `HermMat ι C` as a Euclidean Jordan algebra**, and nothing below claims
it does.  `hassoc` is one of several hypotheses those six declarations take, and the ones it does
not discharge are exactly the ones this carrier still lacks: the **Jordan identity** `hjordan`,
available only for associative `C` (`jmul_jordan_of_assoc`) or for `C` isomorphic to an
associative one (`jmul_jordan_of_isCompIso`) — in particular not for `𝕆` at any rank — and
**formal reality** `hfr`, which is proved nowhere for this carrier.  (`hcomm` is `jmul_comm`,
from `HermMat.lean`, not from this file.)  No `EuclideanJordanAlgebra` instance on `HermMat ι C`
exists in this tree, and this file constructs none.

## What is deliberately absent

★ No `Mul` instance is installed, for the reason `HermMat.lean:58-60` gives: a `Mul` instance
alongside the `NormedAddCommGroup` this file now supplies would reintroduce exactly the diamond
`EJA/Bridge.lean`'s `ringOfBilinear` exists to dodge.  The product stays bundled as `hermBilin`.

★ No dimension count, no orthonormal basis, and no completeness statement is proved.  (`HermMat`
already carries `instFiniteDimensionalHermMat` for `[Fintype ι] [FiniteDimensional ℝ C]`; nothing
here consumes it.)

## What this unblocks, precisely

`MasterTheorem/Interface.lean:234`'s `ComparisonSetup` and `EJA/Order.lean:225`'s section are both
stated over `[NormedAddCommGroup J] [InnerProductSpace ℝ J]`.  Those two ambient instances are
what this file supplies for `HermMat ι C`, so the type now *elaborates* in those positions.  Among
the further hypotheses those interfaces take as explicit arguments, this file supplies the
Euclidean one, `hassoc`, as `hermHassoc`.  It does **not** supply the Jordan identity (available
only for associative `C`, `jmul_jordan_of_assoc`) or formal reality, and `ComparisonSetup` has a
long list of further fields — a Jordan frame, the cone, the comparison maps — that nothing here
touches.

## Generality

Every declaration in this file lives at the weakest of `HermMat.lean`'s three tiers — `C` an
arbitrary Euclidean composition algebra — plus `[Fintype ι]`, which the double sum needs and
`HermMat` itself does not.  This is strictly weaker than the tier `hermOne`/`hermIdem`/`hermOff`
sit at, and much weaker than the associative tier of `jmul_jordan_of_assoc`.

## Main definitions

* `CompositionAlgebra.hermIp` — the entrywise form
* the `Inner ℝ`, `NormedAddCommGroup` and `InnerProductSpace ℝ` instances on `HermMat ι C`

## Main results

* `CompositionAlgebra.hermIp_comm` — symmetry
* `CompositionAlgebra.hermIp_add_left` / `_right`, `hermIp_smul_left` / `_right` — bilinearity
* `CompositionAlgebra.hermIp_self_nonneg`, `hermIp_self_eq_zero` — positive definiteness
* `CompositionAlgebra.hermIp_jmul_assoc` — the Euclidean hypothesis `⟪A ∘ B, D⟫ = ⟪B, A ∘ D⟫`
* `CompositionAlgebra.hermHassoc` — the same, in `EJA/Order.lean`'s `inner ℝ`/`hermBilin` spelling

## Scope

**No manifest row moves.**  This file is substrate.
-/

noncomputable section

universe u v

namespace CompositionAlgebra

/-! ## The coefficient form, and `ip` over finite sums

Two restatements of the `nf` API in `ip` vocabulary — `nf x` and `ip x x` are both `B x x` by
definition, so these are `rfl`-level, but naming them keeps the sum manipulations below readable —
followed by the two `Finset` versions of `ip_add_left`/`ip_add_right`, which
`Composition/Defs.lean` does not state.  The sum versions are what `hermIp_jmul_assoc` needs:
`Matrix.mul_apply` puts a `∑` inside an `ip`.
-/

section Coeff

variable {C : Type u} [NonAssocRing C] [Module ℝ C] [IsScalarTower ℝ C C] [SMulCommClass ℝ C C]
  [CompositionAlgebra C]

/-- The coefficient form is positive semidefinite: `nf_nonneg` in `ip` vocabulary. -/
theorem ip_self_nonneg (x : C) : 0 ≤ ip x x := nf_nonneg x

/-- The coefficient form is positive definite: `nf_eq_zero_iff` in `ip` vocabulary.  This is where
`CompositionAlgebra.B_pos` is spent. -/
theorem ip_self_eq_zero {x : C} (h : ip x x = 0) : x = 0 := nf_eq_zero_iff.mp h

/-- `ip` commutes with finite sums in its second argument: `map_sum` for the linear map `B x`.
Needed because `Matrix.mul_apply` produces a `∑` inside an `ip` and `Composition/Defs.lean` states
only the binary `ip_add_right`. -/
theorem ip_sum_right {κ : Type*} (s : Finset κ) (x : C) (f : κ → C) :
    ip x (∑ k ∈ s, f k) = ∑ k ∈ s, ip x (f k) :=
  map_sum (B x) f s

/-- `ip` commutes with finite sums in its first argument, from `ip_sum_right` and `ip_symm`. -/
theorem ip_sum_left {κ : Type*} (s : Finset κ) (f : κ → C) (z : C) :
    ip (∑ k ∈ s, f k) z = ∑ k ∈ s, ip (f k) z := by
  rw [ip_symm, ip_sum_right]
  exact Finset.sum_congr rfl fun k _ => ip_symm _ _

end Coeff

/-! ## The entrywise form -/

section Form

variable {ι : Type v} [Fintype ι] {C : Type u} [NonAssocRing C] [Module ℝ C]
  [IsScalarTower ℝ C C] [SMulCommClass ℝ C C] [CompositionAlgebra C]

/-- **The entrywise form** `⟪A, B⟫ = ∑ i, ∑ j, ⟪A i j, B i j⟫_C` on `H_ι(C)`, summing the
composition algebra's own form over all `ι × ι` matrix entries.

Both the `(i, j)` and the `(j, i)` entry contribute, and on a hermitian matrix these are `x` and
`x*`.  Classically `N x* = N x` — this tree proves it, as `nf_cstar` (`Composition/Defs.lean:221`),
but only under `[Nontrivial C]`, which is **not** assumed here — so an off-diagonal coefficient
morally contributes `2 N x`, matching the factor `2` written by hand at `Albert/Inner.lean:80`.
★ That reconciliation is prose only: **no declaration below invokes `nf_cstar`, and none relates
`hermIp` to `Tr(A ∘ B)`.** -/
def hermIp (A B : HermMat ι C) : ℝ :=
  ∑ i : ι, ∑ j : ι, ip ((A : Matrix ι ι C) i j) ((B : Matrix ι ι C) i j)

/-- The form is symmetric, from `ip_symm` entry by entry. -/
theorem hermIp_comm (A B : HermMat ι C) : hermIp A B = hermIp B A := by
  simp only [hermIp]
  exact Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ip_symm _ _

/-- Additivity in the first argument. -/
theorem hermIp_add_left (A A' B : HermMat ι C) :
    hermIp (A + A') B = hermIp A B + hermIp A' B := by
  simp only [hermIp, Submodule.coe_add, Matrix.add_apply, ip_add_left, Finset.sum_add_distrib]

/-- Homogeneity in the first argument. -/
theorem hermIp_smul_left (r : ℝ) (A B : HermMat ι C) :
    hermIp (r • A) B = r * hermIp A B := by
  simp only [hermIp, SetLike.val_smul, Matrix.smul_apply, ip_smul_left, Finset.mul_sum]

/-- Additivity in the second argument, by symmetry. -/
theorem hermIp_add_right (A B B' : HermMat ι C) :
    hermIp A (B + B') = hermIp A B + hermIp A B' := by
  rw [hermIp_comm, hermIp_add_left, hermIp_comm B A, hermIp_comm B' A]

/-- Homogeneity in the second argument, by symmetry. -/
theorem hermIp_smul_right (r : ℝ) (A B : HermMat ι C) :
    hermIp A (r • B) = r * hermIp A B := by
  rw [hermIp_comm, hermIp_smul_left, hermIp_comm B A]

/-- The form is positive semidefinite: a double sum of the nonnegative reals `⟪A i j, A i j⟫_C`. -/
theorem hermIp_self_nonneg (A : HermMat ι C) : 0 ≤ hermIp A A :=
  Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => ip_self_nonneg _

/-- **Positive definiteness.**  A vanishing double sum of nonnegative terms has every term zero,
so every entry `A i j` is killed by the coefficient algebra's own definiteness and the matrix is
`0`; being an element of a submodule, `A` is then `0` there too. -/
theorem hermIp_self_eq_zero {A : HermMat ι C} (h : hermIp A A = 0) : A = 0 := by
  have h' : ∑ i : ι, ∑ j : ι, ip ((A : Matrix ι ι C) i j) ((A : Matrix ι ι C) i j) = 0 := h
  have hrow : ∀ i : ι, ∑ j : ι, ip ((A : Matrix ι ι C) i j) ((A : Matrix ι ι C) i j) = 0 :=
    fun i =>
      (Finset.sum_eq_zero_iff_of_nonneg
        (fun _ _ => Finset.sum_nonneg fun _ _ => ip_self_nonneg _)).mp h' i (Finset.mem_univ i)
  refine Subtype.ext ?_
  rw [ZeroMemClass.coe_zero]
  ext i j
  rw [Matrix.zero_apply]
  exact ip_self_eq_zero
    ((Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => ip_self_nonneg _)).mp (hrow i) j
      (Finset.mem_univ j))

/-- Strict positivity, the form in which `InnerProductSpace.Core` is usually motivated: a nonzero
hermitian matrix has strictly positive square norm.  A restatement of `hermIp_self_nonneg` and
`hermIp_self_eq_zero`, not extra content. -/
theorem hermIp_self_pos {A : HermMat ι C} (hA : A ≠ 0) : 0 < hermIp A A :=
  lt_of_le_of_ne (hermIp_self_nonneg A) fun h => hA (hermIp_self_eq_zero h.symm)

/-! ## The Euclidean hypothesis

`⟪A ∘ B, D⟫ = ⟪B, A ∘ D⟫`, on the bare product.  The whole argument is the adjoint ladder of
`Composition/Defs.lean` run entrywise.  Expanding both sides through `jmul_coe` and
`Matrix.mul_apply` gives triple sums over `i, j, k`; on the left a typical term
`⟪A i k * B k j, D i j⟫` becomes `⟪B k j, (A i k)* * D i j⟫` by `ip_mul_adj_left`, and
`(A i k)* = A k i` is the hermitian condition `A.2` read in the right direction.  The mirror
half uses `ip_mul_adj_right` and lands on `A j k`.  The two halves then match the two halves of
the right-hand side after permuting the three summation indices — `i ↔ k` for the first,
`j ↔ k` for the second — which is all `Finset.sum_comm` does here.

★ The two adjunction lemmas are polarisations of the composition law, not consequences of
associativity: `Composition/Defs.lean:229,238` prove them from `ip_exchange` alone, with no
`[Nontrivial C]`.  So nothing in this subsection is unavailable over `𝕆`, and the tier is
unchanged from the rest of the file.
-/

/-- **The Euclidean hypothesis for `H_ι(C)`**: `⟪A ∘ B, D⟫ = ⟪B, A ∘ D⟫`, the associativity of
the entrywise form against the symmetrised product.  This is what `Albert/Inner.lean:172` proves
by hand for the 27-coordinate carrier `h3O` and what six declarations of `EJA/Order.lean` carry as
an explicit hypothesis; here it is a theorem, at an arbitrary Euclidean composition algebra `C`
and an arbitrary `[Fintype ι]`.

Stated with `jmul` rather than `*` because no `Mul` instance is installed — see the module
docstring — and with `D` for the third element because `C` is the coefficient algebra.

★ It does **not** follow that `HermMat ι C` is a Euclidean Jordan algebra.  The Jordan identity
is still available only for associative `C` (`jmul_jordan_of_assoc`) or `C` isomorphic to such a
one (`jmul_jordan_of_isCompIso`), formal reality is proved nowhere for this carrier, and no
`EuclideanJordanAlgebra` instance on `HermMat ι C` exists in this tree. -/
theorem hermIp_jmul_assoc (A B D : HermMat ι C) :
    hermIp (jmul A B) D = hermIp B (jmul A D) := by
  have ha : ∀ p q : ι, (A : Matrix ι ι C) q p = cstar ((A : Matrix ι ι C) p q) := A.2
  have swap₁₃ : ∀ g : ι → ι → ι → ℝ,
      ∑ i : ι, ∑ j : ι, ∑ k : ι, g i j k = ∑ i : ι, ∑ j : ι, ∑ k : ι, g k j i := fun g =>
    calc ∑ i : ι, ∑ j : ι, ∑ k : ι, g i j k
        = ∑ j : ι, ∑ i : ι, ∑ k : ι, g i j k := Finset.sum_comm
      _ = ∑ j : ι, ∑ k : ι, ∑ i : ι, g i j k := Finset.sum_congr rfl fun _ _ => Finset.sum_comm
      _ = ∑ k : ι, ∑ j : ι, ∑ i : ι, g i j k := Finset.sum_comm
  have swap₂₃ : ∀ g : ι → ι → ι → ℝ,
      ∑ i : ι, ∑ j : ι, ∑ k : ι, g i j k = ∑ i : ι, ∑ j : ι, ∑ k : ι, g i k j := fun _ =>
    Finset.sum_congr rfl fun _ _ => Finset.sum_comm
  have e1 : ∀ i j : ι,
      ip (((A : Matrix ι ι C) * (B : Matrix ι ι C)) i j) ((D : Matrix ι ι C) i j)
        = ∑ k : ι, ip ((B : Matrix ι ι C) k j)
            ((A : Matrix ι ι C) k i * (D : Matrix ι ι C) i j) := by
    intro i j
    rw [Matrix.mul_apply, ip_sum_left]
    exact Finset.sum_congr rfl fun k _ => by rw [ip_mul_adj_left, ← ha]
  have e2 : ∀ i j : ι,
      ip (((B : Matrix ι ι C) * (A : Matrix ι ι C)) i j) ((D : Matrix ι ι C) i j)
        = ∑ k : ι, ip ((B : Matrix ι ι C) i k)
            ((D : Matrix ι ι C) i j * (A : Matrix ι ι C) j k) := by
    intro i j
    rw [Matrix.mul_apply, ip_sum_left]
    exact Finset.sum_congr rfl fun k _ => by rw [ip_mul_adj_right, ← ha]
  have e3 : ∀ i j : ι,
      ip ((B : Matrix ι ι C) i j) (((A : Matrix ι ι C) * (D : Matrix ι ι C)) i j)
        = ∑ k : ι, ip ((B : Matrix ι ι C) i j)
            ((A : Matrix ι ι C) i k * (D : Matrix ι ι C) k j) := by
    intro i j
    rw [Matrix.mul_apply, ip_sum_right]
  have e4 : ∀ i j : ι,
      ip ((B : Matrix ι ι C) i j) (((D : Matrix ι ι C) * (A : Matrix ι ι C)) i j)
        = ∑ k : ι, ip ((B : Matrix ι ι C) i j)
            ((D : Matrix ι ι C) i k * (A : Matrix ι ι C) k j) := by
    intro i j
    rw [Matrix.mul_apply, ip_sum_right]
  have hL : hermIp (jmul A B) D
      = (2 : ℝ)⁻¹ * (∑ i : ι, ∑ j : ι, ∑ k : ι,
            ip ((B : Matrix ι ι C) k j) ((A : Matrix ι ι C) k i * (D : Matrix ι ι C) i j))
        + (2 : ℝ)⁻¹ * (∑ i : ι, ∑ j : ι, ∑ k : ι,
            ip ((B : Matrix ι ι C) i k) ((D : Matrix ι ι C) i j * (A : Matrix ι ι C) j k)) := by
    simp only [hermIp, jmul_coe, Matrix.smul_apply, Matrix.add_apply, ip_smul_left,
      ip_add_left, e1, e2, mul_add, Finset.sum_add_distrib, ← Finset.mul_sum]
  have hR : hermIp B (jmul A D)
      = (2 : ℝ)⁻¹ * (∑ i : ι, ∑ j : ι, ∑ k : ι,
            ip ((B : Matrix ι ι C) i j) ((A : Matrix ι ι C) i k * (D : Matrix ι ι C) k j))
        + (2 : ℝ)⁻¹ * (∑ i : ι, ∑ j : ι, ∑ k : ι,
            ip ((B : Matrix ι ι C) i j) ((D : Matrix ι ι C) i k * (A : Matrix ι ι C) k j)) := by
    simp only [hermIp, jmul_coe, Matrix.smul_apply, Matrix.add_apply, ip_smul_right,
      ip_add_right, e3, e4, mul_add, Finset.sum_add_distrib, ← Finset.mul_sum]
  have h1 : (∑ i : ι, ∑ j : ι, ∑ k : ι,
        ip ((B : Matrix ι ι C) k j) ((A : Matrix ι ι C) k i * (D : Matrix ι ι C) i j))
      = ∑ i : ι, ∑ j : ι, ∑ k : ι,
        ip ((B : Matrix ι ι C) i j) ((A : Matrix ι ι C) i k * (D : Matrix ι ι C) k j) :=
    (swap₁₃ fun x y z => ip ((B : Matrix ι ι C) x y)
      ((A : Matrix ι ι C) x z * (D : Matrix ι ι C) z y)).symm
  have h2 : (∑ i : ι, ∑ j : ι, ∑ k : ι,
        ip ((B : Matrix ι ι C) i k) ((D : Matrix ι ι C) i j * (A : Matrix ι ι C) j k))
      = ∑ i : ι, ∑ j : ι, ∑ k : ι,
        ip ((B : Matrix ι ι C) i j) ((D : Matrix ι ι C) i k * (A : Matrix ι ι C) k j) :=
    swap₂₃ fun x y z => ip ((B : Matrix ι ι C) x z)
      ((D : Matrix ι ι C) x y * (A : Matrix ι ι C) y z)
  rw [hL, hR, h1, h2]

/-! ## The inner product space

The instance chain is the one `Albert/Inner.lean:151-168` runs on `h3O`, at the more general
carrier.  It is safe to go through `InnerProductSpace.Core` here — Mathlib warns against it when
the space already carries a norm — because neither `C` nor `Matrix ι ι C` carries a `Norm`
instance in this tree, so no second, non-defeq norm can be created. -/

instance instInnerHermMat : Inner ℝ (HermMat ι C) := ⟨hermIp⟩

/-- `⟪·, ·⟫_ℝ` on `HermMat ι C` is `hermIp`, by definition. -/
theorem hermInner_def (A B : HermMat ι C) : inner ℝ A B = hermIp A B := rfl

instance instNormedAddCommGroupHermMat : NormedAddCommGroup (HermMat ι C) :=
  @InnerProductSpace.Core.toNormedAddCommGroup ℝ (HermMat ι C) _ _ _
    { toInner := inferInstance
      conj_inner_symm := fun x y => by
        simpa only [starRingEnd_apply, star_trivial, hermInner_def] using hermIp_comm y x
      re_inner_nonneg := fun x => by
        simpa only [RCLike.re_to_real, hermInner_def] using hermIp_self_nonneg x
      definite := fun _ h => hermIp_self_eq_zero h
      add_left := fun x y z => hermIp_add_left x y z
      smul_left := fun x y r => by
        simpa only [starRingEnd_apply, star_trivial, hermInner_def] using
          hermIp_smul_left r x y }

instance instInnerProductSpaceHermMat : InnerProductSpace ℝ (HermMat ι C) :=
  InnerProductSpace.ofCore _

/-- **The Euclidean hypothesis**, spelled as `EJA/Order.lean` carries it:
`(hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))` at `m := hermBilin`.  This is
`hermIp_jmul_assoc` with the `Inner ℝ` and `hermBilin` wrappers unfolded — both are `rfl` — and it
is the shape `Albert/Inner.lean:172`'s `hassoc` supplies for `h3O`.

★ Supplying this hypothesis is not the same as instantiating those interfaces: they also take the
Jordan identity and formal reality, neither of which is available for `HermMat ι C` at a general
`C`.  See the module docstring. -/
theorem hermHassoc (A B D : HermMat ι C) :
    inner ℝ (hermBilin A B) D = inner ℝ B (hermBilin A D) :=
  hermIp_jmul_assoc A B D

end Form

end CompositionAlgebra
