/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Order
import RadicalRelativity.EJA.Pattern

set_option linter.style.longLine false

/-!
# The Euclidean Jordan algebra class

The abstract modules of the `EJA/` layer built before this one — `Peirce`, `PeirceMul`,
`Orthogonal`, `Frame`, `Power`, `PowerAssoc`, `FormallyReal`, `Subalgebra`, `Block`, `Pattern`
and `Spectral` — state their hypotheses as a *tuple* drawn from
`[NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J] [IsScalarTower ℝ J J]
[IsFormallyReal J] [Module.Finite ℝ J]`, each module taking the sub-tuple it needs; or — on the
Euclidean side of `EJA/Order.lean` and in `Spectral`'s interface section — as a bilinear map
`m : J →ₗ[ℝ] J →ₗ[ℝ] J` carrying `hcomm`/`hjordan`/`hassoc` as ordinary hypotheses.  (`Witness`,
`ConcreteInstance`, `InterfaceInstance` and `Spectral`'s concrete section state theirs over
`HermitianMat` or over `EJAComparison` instead.)  Both abstract vocabularies are correct and neither is a *class*, so a theorem
about a Euclidean Jordan algebra cannot be stated by naming one.

This file names one.  `EuclideanJordanAlgebra J` is a real inner-product space with a
commutative bilinear product with unit, satisfying the Jordan identity and the associativity of
the inner product — Faraut–Korányi's definition (FK III.1), which is also the definition the
paper's two flagship rows carry as their hypothesis
(`landing/papers/twist-normal-form/main.tex`, section labelled `sec:eja`, lines 303-307 on
2026-08-22).

★ **Hypothesis direction.**  The class is *weaker* than the article's definition in two
respects, which is the correct direction for an import — a theorem proved over this class
applies to the article's setting, not the other way round.  First, finite-dimensionality is
folded into the article's definition and is carried here as a separate `[FiniteDimensional ℝ J]`
argument.  Second, the article fixes the inner product to be the trace form
`⟪x, y⟫ = tr(x ∘ y)` for the Jordan trace, whereas the class asks only that *some*
positive-definite associative inner product exist.  `inner_mul_one` below shows the gap is
smaller than it looks: any associative inner product satisfies `⟪x ∘ y, 1⟫ = ⟪x, y⟫`, so it *is*
the trace form of the linear functional `z ↦ ⟪z, 1⟫`.  It need not be the form of the *Jordan*
trace — rescaling an associative inner product by a positive constant keeps it associative —
and nothing here claims otherwise.

## The shape, and the diamond it dodges

★ The product is placed **on top of** the additive group of the inner-product space, never
alongside a second one.  Assuming `[NormedAddCommGroup J]` and `[NonUnitalNonAssocCommRing J]`
simultaneously produces two `AddCommGroup J` instances and `Module ℝ J` then fails to
synthesise; `EJA/Bridge.lean` records that diamond and `ringOfBilinear` dodges it by building
the multiplicative structure on the *ambient* additive group.  This class is that dodge
promoted from a `def` to a `class`: it `extends Mul J, One J` over
`[NormedAddCommGroup J] [InnerProductSpace ℝ J]`, so only one `AddCommGroup J` is ever in play
and `instNonUnitalNonAssocCommRing` below is built from `inferInstance` on the nose.

Consequently `ringOfBilinear (jmulₗ J) mul_comm = instNonUnitalNonAssocCommRing` holds by `rfl`
(`ringOfBilinear_jmulₗ`), which is the statement that the class and the bilinear vocabulary of
`EJA/Order.lean` are the same structure and not merely isomorphic ones.

## What finite-dimensionality is, and is not, needed for

`FiniteDimensional ℝ J` is deliberately **not** a field of the class.  It is genuinely required
downstream: `EJA/Spectral.lean` records that its `spectral_resolution_bilinear` — which is
`spectral_resolution_complete` in bilinear vocabulary, and carries the same hypotheses minus the
inner product — is false without it, `ℝ[X]` satisfying every other hypothesis with no nonconstant
resolution.  So the dimension is carried as a separate instance argument at exactly the theorems
that need it, and `spectral_resolution_complete'` below is one of them.

★ It is *not* needed for formal reality.  `instIsFormallyReal` below is unconditional: pairing a
vanishing sum of squares against the unit turns `∑ᵢ ⟪xᵢ ∘ xᵢ, 1⟫` into `∑ᵢ ⟪xᵢ, xᵢ⟫` by one
application of `inner_assoc`, and a vanishing sum of nonnegative reals has vanishing terms.

This corrects the build plan on two points.  The plan derived the instance from
`EJA/Spectral.lean`'s `isFormallyReal_of_fin` under `[FiniteDimensional ℝ J]`.  That lemma
cannot supply it: `isFormallyReal_of_fin` *takes formal reality as a hypothesis*, in `Fin k`
form, and does nothing but reindex it to the `Finset` form the class `IsFormallyReal` carries.
The derivation had to come from the inner product instead — and once it does, the dimension
hypothesis turns out to be unused.

## Scope

**No manifest row moves.**  This file is substrate, and almost all of it is repackaging: the two
restatements at the end (`spectral_resolution_complete'`, `peirce_add_add'`) discharge the claim
that the existing layer is reachable from the class, and are not new results.

★ Two declarations are *not* repackaging, and the file should not be described as if they were.
`inner_mul_one`, and `instIsFormallyReal` resting on it, derive formal reality from the
associative inner product, and the existing layer does not contain that derivation anywhere: it
takes formal reality as a hypothesis at every abstract site (`EJA/Spectral.lean`'s
`isFormallyReal_of_fin` *receives* it and does nothing but reindex; `EJA/Order.lean`'s
`orderUnitSpaceOfBilinear` receives it as `[IsFormallyReal J]`), and derives it only on the
concrete carrier, in `EJA/Witness.lean`'s `instIsFormallyReal` for `HermitianMat d 𝕜`.  Both new
declarations are short; the point is only that "this file contains no new mathematics" would be
false.

★ One hazard to record for later modules.  `instNonUnitalNonAssocCommRing` fires on any type
carrying `EuclideanJordanAlgebra`, and `HermitianMat d 𝕜` already carries a `Mul` — from
`RadicalRelativity/Vendor/HermitianMat/Jordan.lean`'s `scoped instance : CommMagma
(HermitianMat d 𝕜)`, whose product is `HermitianMat.symmMul`.  Nothing declares
`EuclideanJordanAlgebra (HermitianMat d 𝕜)` today, and until something does the two never meet;
if one is ever declared, that scoped instance and this class's `toMul` will both be in scope
inside `open HermMul` sections and one of them has to give way.
-/

noncomputable section

namespace RadicalRelativity.EJA

/-- A **Euclidean Jordan algebra**: a real inner-product space carrying a commutative bilinear
product with unit, satisfying the Jordan identity and the associativity of the inner product.

This is Faraut–Korányi's definition (FK III.1), weakened in the two ways the module docstring
records: finite-dimensionality is *not* a field, and the inner product is an arbitrary
associative one rather than the Jordan trace form.  Both weakenings run in the import-safe
direction. -/
class EuclideanJordanAlgebra (J : Type*) [NormedAddCommGroup J] [InnerProductSpace ℝ J]
    extends Mul J, One J where
  /-- The Jordan product is commutative. -/
  mul_comm : ∀ x y : J, x * y = y * x
  /-- The Jordan product is additive in its left argument. -/
  add_mul : ∀ x y z : J, (x + y) * z = x * z + y * z
  /-- The Jordan product is homogeneous in its left argument. -/
  smul_mul : ∀ (r : ℝ) (x y : J), (r • x) * y = r • (x * y)
  /-- `1` is a unit for the Jordan product. -/
  one_mul : ∀ x : J, (1 : J) * x = x
  /-- The Jordan identity, `x ∘ (x² ∘ y) = x² ∘ (x ∘ y)`. -/
  jordan : ∀ x y : J, x * ((x * x) * y) = (x * x) * (x * y)
  /-- The inner product is associative: `⟪x ∘ y, z⟫ = ⟪y, x ∘ z⟫`.  This is what "Euclidean"
  adds to "formally real"; `EJA/Order.lean` carries the same condition as the hypothesis
  `hassoc`. -/
  inner_assoc : ∀ x y z : J, inner ℝ (x * y) z = inner ℝ y (x * z)

namespace EuclideanJordanAlgebra

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J] [EuclideanJordanAlgebra J]

/-- Left multiplication by `0` is `0` — the one ring axiom the class does not state, obtained
from additivity at `(0, 0, a)`. -/
theorem zero_mul' (a : J) : (0 : J) * a = 0 := by
  have h : (0 : J) * a + (0 : J) * a = (0 : J) * a + 0 := by
    rw [add_zero, ← add_mul, add_zero]
  exact add_left_cancel h

/-- The ring structure, built on the **ambient** additive group. -/
instance instNonUnitalNonAssocCommRing : NonUnitalNonAssocCommRing J :=
  { (inferInstance : AddCommGroup J), (inferInstance : Mul J) with
    left_distrib := fun a b c => by
      rw [mul_comm a (b + c), add_mul, mul_comm b a, mul_comm c a]
    right_distrib := add_mul
    zero_mul := zero_mul'
    mul_zero := fun a => by rw [mul_comm, zero_mul']
    mul_comm := mul_comm }

/-- Mathlib's Jordan class.  Its field `lmul_comm_rmul_rmul` is oriented
`a ∘ b ∘ (a ∘ a) = a ∘ (b ∘ (a ∘ a))`, which is the class's `jordan` field read through
commutativity twice. -/
instance instIsCommJordan : IsCommJordan J :=
  ⟨fun a b => by rw [mul_comm (a * b) (a * a), ← jordan a b, mul_comm (a * a) b]⟩

instance instIsScalarTower : IsScalarTower ℝ J J := ⟨smul_mul⟩

/-- Required by `Submodule`-valued and `NonUnitalSubalgebra`-valued subobject constructions
downstream; do not remove because nothing in this file uses it. -/
instance instSMulCommClass : SMulCommClass ℝ J J :=
  ⟨fun r x y => by
    change r • (x * y) = x * (r • y)
    rw [mul_comm x (r • y), smul_mul, mul_comm y x]⟩

theorem mul_one' (x : J) : x * (1 : J) = x := by rw [mul_comm, one_mul]

/-- **The inner product is a trace form.**  `⟪x ∘ y, 1⟫ = ⟪x, y⟫`: one application of
`inner_assoc` against the unit.  So the linear functional `z ↦ ⟪z, 1⟫` plays the role the
article's `tr` plays, and the inner product's positive-definiteness is available as
positive-definiteness of that form on products.  It is *not* claimed that this functional is the
Jordan trace — see the module docstring. -/
theorem inner_mul_one (x y : J) : (inner ℝ (x * y) (1 : J) : ℝ) = inner ℝ x y := by
  rw [inner_assoc x y 1, mul_one' x, real_inner_comm]

/-- **Formal reality, from the inner product.**  Unconditional on the dimension — see the
module docstring. -/
instance instIsFormallyReal : IsFormallyReal J := by
  refine ⟨fun {ι} s f hsum i hi => ?_⟩
  have hz : (∑ j ∈ s, (inner ℝ (f j) (f j) : ℝ)) = 0 := by
    have h0 : (inner ℝ (∑ j ∈ s, f j * f j) (1 : J) : ℝ) = 0 := by rw [hsum, inner_zero_left]
    rw [sum_inner] at h0
    simpa only [fun x : J => inner_mul_one x x] using h0
  have hnn : ∀ j ∈ s, (0 : ℝ) ≤ inner ℝ (f j) (f j) := fun _ _ => real_inner_self_nonneg
  exact inner_self_eq_zero.mp ((Finset.sum_eq_zero_iff_of_nonneg hnn).mp hz i hi)

/-- The associativity of the inner product in its other orientation, `⟪x ∘ y, z⟫ = ⟪x, y ∘ z⟫`,
obtained from the field by commuting the product. -/
theorem inner_assoc' (x y z : J) : (inner ℝ (x * y) z : ℝ) = inner ℝ x (y * z) := by
  rw [mul_comm x y, inner_assoc y x z]

end EuclideanJordanAlgebra

/-! ## The bridge to the bilinear-map vocabulary

`EJA/Order.lean`'s Euclidean section and `EJA/Spectral.lean`'s interface section state
everything over a bundled `m : J →ₗ[ℝ] J →ₗ[ℝ] J` carrying `hcomm`, `hjordan`, `hassoc` and a
`Fin k`-indexed formal-reality hypothesis.  `jmulₗ` is the class's product in that vocabulary
and the five lemmas after it are exactly that hypothesis tuple, so a consumer of
`orderUnitSpaceOfBilinear`, `inner_left_coeff`, `isArchimedean_ofBilinear`,
`isSoS_iff_exists_sq` or `spectral_resolution_bilinear` supplies them by name rather than
rebuilding them. -/

/-- The Jordan product of a `EuclideanJordanAlgebra` as a bundled bilinear map. -/
def jmulₗ (J : Type*) [NormedAddCommGroup J] [InnerProductSpace ℝ J]
    [EuclideanJordanAlgebra J] : J →ₗ[ℝ] J →ₗ[ℝ] J :=
  LinearMap.mk₂ ℝ (· * ·) EuclideanJordanAlgebra.add_mul EuclideanJordanAlgebra.smul_mul
    (fun x y z => mul_add x y z) (fun r x y => mul_smul_comm r x y)

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J] [EuclideanJordanAlgebra J]

@[simp] theorem jmulₗ_apply (x y : J) : jmulₗ J x y = x * y := rfl

/-- ★ The class and `EJA/Bridge.lean`'s `ringOfBilinear` produce the **same** ring structure,
definitionally.  This is the precise sense in which the class does not introduce a second
multiplicative structure alongside the one the existing layer runs on. -/
theorem ringOfBilinear_jmulₗ :
    ringOfBilinear (jmulₗ J) EuclideanJordanAlgebra.mul_comm =
      EuclideanJordanAlgebra.instNonUnitalNonAssocCommRing (J := J) := rfl

theorem jmulₗ_comm (x y : J) : jmulₗ J x y = jmulₗ J y x := EuclideanJordanAlgebra.mul_comm x y

theorem jmulₗ_jordan (a b : J) :
    jmulₗ J (jmulₗ J a b) (jmulₗ J a a) = jmulₗ J a (jmulₗ J b (jmulₗ J a a)) :=
  IsCommJordan.lmul_comm_rmul_rmul a b

theorem jmulₗ_inner_assoc (x y z : J) :
    (inner ℝ (jmulₗ J x y) z : ℝ) = inner ℝ y (jmulₗ J x z) :=
  EuclideanJordanAlgebra.inner_assoc x y z

theorem jmulₗ_one_mul (y : J) : jmulₗ J 1 y = y := EuclideanJordanAlgebra.one_mul y

/-- Formal reality in the `Fin k` form `spectral_resolution_bilinear` and
`isFormallyReal_of_fin` take. -/
theorem jmulₗ_formallyReal (k : ℕ) (f : Fin k → J) (h : (∑ i, jmulₗ J (f i) (f i)) = 0)
    (i : Fin k) : f i = 0 :=
  IsFormallyReal.eq_zero_of_sum_mul_self Finset.univ f h i (Finset.mem_univ i)

/-! ## The existing layer, restated over the class -/

/-- **(E1) with completeness, over the class.**  `EJA/Spectral.lean`'s
`spectral_resolution_complete` carries the unit as an explicit hypothesis `he : ∀ y, e ∘ y = y`
because it has no `One`; the class supplies it. -/
theorem spectral_resolution_complete' [FiniteDimensional ℝ J] (x : J) :
    ∃ (n : ℕ) (c : Fin n → J) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∑ i, c i) = 1 ∧ x = ∑ i, lam i • c i :=
  spectral_resolution_complete 1 EuclideanJordanAlgebra.one_mul x

/-- **The Peirce decomposition at a single idempotent, over the class.**  `EJA/Peirce.lean`'s
`peirce_add_add` needs no idempotency hypothesis: the three projections sum to the identity for
every `c`. -/
theorem peirce_add_add' (c y : J) : peirceOne c y + peirceHalf c y + peirceZero c y = y :=
  peirce_add_add c y


/-- **Orthogonality in the inner product is orthogonality in the Jordan product**, over the class.

`EJA/Order.lean` proves this over a bundled bilinear map; this is that theorem with the `jmulₗ`
tuple supplied by name, which is the crossing `EJA/Class.lean` exists to make.  Both hypotheses
are cone membership in the sums-of-squares sense. -/
theorem jmul_eq_zero_of_inner_eq_zero [FiniteDimensional ℝ J] {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b) (h : (inner ℝ a b : ℝ) = 0) :
    a * b = 0 :=
  mul_eq_zero_of_inner_eq_zero_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    jmulₗ_inner_assoc 1 jmulₗ_one_mul ha hb h

/-! ## The Jordan quadratic representation over the class

`EJA/Spectral.lean` defines `quadJ a = 2·L_a² − L_{a²}` in the ring vocabulary.  The class supplies
the inner product, so the two facts a sequential product needs from it can be stated here:
`Q_a` is self-adjoint, and `Q_{√a}` sends the unit to `a`. -/

/-- **`Q_a` is self-adjoint.**  `L_a` is self-adjoint by `inner_assoc`, and `Q_a` is a real
polynomial in `L_a`, so it inherits the property.  No spectral theory enters. -/
theorem quadJ_inner_self_adjoint (a x y : J) :
    (inner ℝ (quadJ a x) y : ℝ) = inner ℝ x (quadJ a y) := by
  have hL : ∀ p q r : J, (inner ℝ (p * q) r : ℝ) = inner ℝ q (p * r) :=
    fun p q r => EuclideanJordanAlgebra.inner_assoc p q r
  rw [quadJ_apply, quadJ_apply, inner_sub_left, inner_sub_right, real_inner_smul_left,
    hL a (a * x) y, hL a x (a * y), hL (a * a) x y, real_inner_smul_right]

/-- **`Q_{√a}` sends the unit to `a`**, whenever `a` has a resolution with nonnegative
eigenvalues — the identity that makes `a · e = a` for the candidate product `a · b = Q_{√a} b`,
i.e. the other half of S3. -/
theorem quadJ_jsqrt_one [FiniteDimensional ℝ J] {a : J} {n : ℕ} {c : Fin n → J}
    {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c) (hinj : Function.Injective lam)
    (ha : a = ∑ i, lam i • c i) (hnn : ∀ i, 0 ≤ lam i) :
    quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) (1 : J) = a := by
  rw [quadJ_unit EuclideanJordanAlgebra.one_mul]
  exact jsqrt_mul_self 1 EuclideanJordanAlgebra.one_mul a hfam hinj ha hnn


/-- **At an idempotent, the quadratic representation IS the Peirce-1 projection.**

`Q_c = 2L_c² − L_{c²}` and `P₁(c) = 2L_c² − L_c` are the same operator once `c² = c`.

★ This is the bridge between `quadJ` and the Peirce layer the tree already carries in depth, and
it is what makes the candidate product concrete at a **sharp** effect: since `√c = c` for an
idempotent, `c · b = Q_{√c} b = P₁(c) b`, which is the Lüders map.  (That `√c = c` is not proved
here — it needs the two-element resolution `c = 1·c + 0·(1−c)`.) -/
theorem quadJ_eq_peirceOne {c : J} (hc : c * c = c) : quadJ c = peirceOne c := by
  ext y
  rw [quadJ_apply, peirceOne_apply, hc]

/-! ## S4 for the candidate sequential product

`a · b := Q_{√a} b`.  This section proves **S4, symmetry of orthogonality**: `a · b = 0` implies
`b · a = 0`, for `a` and `b` in the cone.

The asymmetric-looking hypothesis routes through a symmetric one.  `Q_{√a}` is self-adjoint and
sends `1` to `a`, so `a · b = 0` gives `⟪b, a⟫ = 0`; that is symmetric on its face; and on the cone
inner-product orthogonality is Jordan orthogonality, which returns `√b ∘ a = 0` — the one term
`Q_{√b} a = 2·√b(√b·a) − b·a` needs. -/

/-- **The square root of a cone element annihilates whatever the element annihilates.** -/
theorem jsqrt_mul_eq_zero_of_inner_eq_zero [FiniteDimensional ℝ J] {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b) (h : (inner ℝ b a : ℝ) = 0) :
    jsqrt 1 EuclideanJordanAlgebra.one_mul b * a = 0 := by
  obtain ⟨n, d, mu, hfam, -, hb', hinj⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul b
  have hkey := smul_resolution_mul_eq_zero_of_inner_eq_zero jmulₗ_comm jmulₗ_jordan
    jmulₗ_inner_assoc (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hb' hb ha h
    Real.sqrt Real.sqrt_zero
  rw [jsqrt_eq_of_resolution 1 EuclideanJordanAlgebra.one_mul b hfam hinj hb']
  exact hkey

/-- **S4 — symmetry of orthogonality — for `a · b = Q_{√a} b`.** -/
theorem quadJ_jsqrt_zero_symm [FiniteDimensional ℝ J] {a b : J}
    (ha : IsSoS (jmulₗ J) a) (hb : IsSoS (jmulₗ J) b)
    (h : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b = 0) :
    quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) a = 0 := by
  classical
  -- `Q_{√a} 1 = a`, so pairing the hypothesis against `1` reads off `⟪b, a⟫`.
  obtain ⟨n, c, lam, hfamA, -, ha', hinjA⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul a
  have hnnA : ∀ i, c i ≠ 0 → 0 ≤ lam i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfamA.idem k) (fun k l hkl => hfamA.orth k l hkl) ha' ha hci
  have hQ1 : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul a) (1 : J) = a := by
    rw [quadJ_unit EuclideanJordanAlgebra.one_mul]
    exact jsqrt_mul_self' 1 EuclideanJordanAlgebra.one_mul a hfamA hinjA ha' hnnA
  have hba : (inner ℝ b a : ℝ) = 0 := by
    have hsa := quadJ_inner_self_adjoint (jsqrt 1 EuclideanJordanAlgebra.one_mul a) b (1 : J)
    rw [h, inner_zero_left, hQ1] at hsa
    exact hsa.symm
  -- both terms of `Q_{√b} a` vanish
  have hsq : jsqrt 1 EuclideanJordanAlgebra.one_mul b * a = 0 :=
    jsqrt_mul_eq_zero_of_inner_eq_zero ha hb hba
  have hb0 : b * a = 0 :=
    jmul_eq_zero_of_inner_eq_zero hb ha hba
  have hbb : jsqrt 1 EuclideanJordanAlgebra.one_mul b
      * jsqrt 1 EuclideanJordanAlgebra.one_mul b = b := by
    obtain ⟨n', d, mu, hfamB, -, hb', hinjB⟩ :=
      exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul b
    have hnnB : ∀ i, d i ≠ 0 → 0 ≤ mu i := fun i hdi =>
      nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
        (fun k => hfamB.idem k) (fun k l hkl => hfamB.orth k l hkl) hb' hb hdi
    exact jsqrt_mul_self' 1 EuclideanJordanAlgebra.one_mul b hfamB hinjB hb' hnnB
  rw [quadJ_apply, hsq, mul_zero, smul_zero, hbb, hb0, sub_zero]

end RadicalRelativity.EJA
