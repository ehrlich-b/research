/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.OrderUnitSpace
import RadicalRelativity.EJA.Spectral
import RadicalRelativity.SequentialProduct
import RadicalRelativity.Necessity.ComparisonInstanceGen

set_option linter.style.longLine false

/-!
# The order structure on a Euclidean Jordan algebra

**ARC-9, 2026-08-22.**

`RadicalRelativity/SequentialProduct.lean` declares `SequentialProductOn (V : Type*)
[OrderUnitSpace V]`, and every one of its axioms is guarded by `OrderUnitSpace.IsEffect`,
which unfolds to `0 ≤ a ∧ a ≤ 𝟙`.  Before this file, `RadicalRelativity/EJA/` contained **no
occurrence of `OrderUnitSpace` and none of `IsEffect`** — 0 hits across the 15 files then in
that directory, on 2026-08-22 — the EJA layer ran on
`[NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]`, which carries no order at all.
So a sequential product could not even be *stated* at EJA generality.  That, not the
axiomatization gates (E1)/(E2)/(E3), was the binding constraint.

This file removes it.  `orderUnitSpaceOfBilinear` produces an `OrderUnitSpace J` for `J` a
finite-dimensional formally real Jordan algebra, with the **cone of sums of squares** as the
positive cone and the Jordan unit as the order unit.

## The cone, and why it is sums of squares rather than squares

`0 ≤ x` is defined here as "`x` is a finite sum of Jordan squares" (`IsSoS`).  The
alternative — `x` is a *single* square — is the reading `WallCertificates/eja-gated.lean`'s
`JBPremises.nonneg_iff_squares` pins, and it is the right one, but it is not usable as a
*definition*: closure of the single-square set under addition is not available before the
spectral theorem, whereas closure of the sums-of-squares set under addition is a
concatenation of index sets.  The two readings are then **proved equal** in
`isSoS_iff_exists_sq` — under the Euclidean hypothesis of the third section, and not before.

Each field of `OrderUnitSpace` is paid for by exactly one thing:

| field | what pays for it |
| --- | --- |
| `le_refl`, `le_trans` | the cone contains `0` and is closed under `+` |
| `le_antisymm` | **formal reality** (`eq_zero_of_isSoS_of_isSoS_neg`) |
| `add_le_add_left` | the order is a difference condition |
| `smul_nonneg_mono` | `r • (y ∘ y) = (√r • y) ∘ (√r • y)` for `r ≥ 0` |
| `ousUnit_nonneg` | the unit is idempotent, hence a square |
| `archimedean` (order-unit boundedness) | **the spectral theorem** |

★ **The spectral theorem is what buys order-unit boundedness, and that is not what it was
built for.**  `EJA/Spectral.lean` calls itself "(E1): the single-element spectral theorem" and
was written to discharge that gate; what it actually pays for here is one row of the table
above.  `EJA-DIVIDEND.md` reached the same diagnosis from the other side and independently —
"this file was pricing the wrong axis … what rows 13, 16 and 17 are blocked on is **order
structure**" — and this file is that structure.  `spectral_resolution_bilinear` writes
`x = ∑ lam i • q i` over an orthogonal idempotent family summing to `e`, so
`r • e - x = ∑ (r - lam i) • q i` is a sum of nonnegative multiples of idempotents — a sum of
squares — for any `r` dominating every `lam i`.  The bound taken here is `∑ i, |lam i|` rather
than `max lam`: it dominates every coefficient, is manifestly nonnegative, and needs no
nonemptiness side condition when the resolution is empty.

## Shape: a hypothesis-carrying `def` in bilinear-map vocabulary, not an instance

Two deliberate choices, both forced by diamonds this tree has already been bitten by.

1. **A `def`, never an `instance`.**  A global `OrderUnitSpace` instance keyed on the EJA
   typeclasses would fire on `HermitianMat d 𝕜`, which already carries one
   (`RadicalRelativity/Hermitian/OrderUnit.lean`), putting two `PartialOrder`s and two
   `Norm`s on the paper's own carrier.  Consumers write `letI := orderUnitSpaceOfBilinear …`,
   exactly as `EJA/Bridge.lean`'s `ringOfBilinear` is used.
2. **Bilinear-map vocabulary.**  Every statement takes the Jordan product as
   `m : J →ₗ[ℝ] J →ₗ[ℝ] J` over `[NormedAddCommGroup J] [InnerProductSpace ℝ J]` — the
   vocabulary of `ComparisonSetup` — and reaches the ring vocabulary only *inside* proofs, via
   `ringOfBilinear`.  Assuming `[NonUnitalNonAssocCommRing J]` and `[NormedAddCommGroup J]`
   together would give two `AddCommGroup J` instances, which is the diamond
   `EJA/Bridge.lean` was written to dodge.  Only one `AddCommGroup` is ever in play here, and
   the produced structure's `toNormedAddCommGroup` is the ambient instance on the nose
   (`normedAddCommGroup_ofBilinear`, proved by `rfl`).

## Scope — what is NOT proved here

* **No manifest row moves.**  Rows 13 (`prop:pseudo-transfer`) and 16 (`lem:coalescence`) each
  need this *and* more: row 13 needs its pseudo-inverse chain ported off `HermitianMat`, row 16
  needs `thetaNormG`/`thetaNorm_fixG` ported and `Theta_fix` (van de Wetering Prop 5.5).  This
  is the enabling layer, not the rows.
* **The Euclidean hypothesis `hassoc` is carried, not derived.**  Six declarations in the third
  section — `inner_mul_self_nonneg_of_idem`, `inner_left_coeff`, `nonneg_coeff_of_inner_nonneg`,
  `nonneg_coeff_of_isSoS`, `isArchimedean_ofBilinear`, `isSoS_iff_exists_sq` — assume an
  associative inner product,
  `⟪x ∘ y, z⟫ = ⟪y, x ∘ z⟫`.  That is Faraut–Korányi's definition of *Euclidean* Jordan algebra
  (FK III.1), and over ℝ in finite dimension it is equivalent to formal reality — but that
  equivalence needs the trace form and **is not formalized here**.  Both directions of the
  dependency are therefore hypotheses, and `hermitian_jordan_assoc` supplies a live carrier
  for the new one so that neither theorem is conditional on an uninhabited premise.
* ★ A third bullet stood here and was **false**: that the constructed order is not proved to be
  the Loewner order on `H_n(𝕜)`, the obstruction being PSD ⟹ sum of squares, which "needs a
  square root on the carrier" absent from the vendored island.  The absence claim about the
  square root was accurate (`grep -rn "sqrt" RadicalRelativity/Vendor/HermitianMat/` returns
  only `norm_eq_sqrt_inner_self`, a `Real.sqrt`, on 2026-08-22) and **irrelevant**: no square
  root is needed.  The spectral idempotents are themselves positive semidefinite, so
  `HermitianMat.inner_ge_zero` makes `⟪q i, A⟫ ≥ 0` and `inner_left_coeff` reads the
  coefficient off.  Both containments are now proved — `hermitian_isSoS_iff_nonneg`,
  `hermitian_le_ofEJA_iff` — so the order this file builds *is* the Loewner order on the
  paper's own carrier.  The lesson is the one this project keeps relearning: **an accurate absence claim
  is evidence about a string, and the route it prices may not be the route.**
-/

noncomputable section

namespace RadicalRelativity.EJA

open Finset

/-! ## The cone of sums of squares

Nothing in this section mentions a norm or an inner product; the ambient structure is the
additive group and the `ℝ`-module, which is all the cone algebra needs. -/

section Cone

variable {J : Type*} [AddCommGroup J] [Module ℝ J]

/-- **The positive cone**: `z` is a finite sum of squares of the bilinear product `m`.

The empty sum is allowed, so `0` is in the cone by `k = 0`. -/
def IsSoS (m : J →ₗ[ℝ] J →ₗ[ℝ] J) (z : J) : Prop :=
  ∃ (k : ℕ) (f : Fin k → J), z = ∑ i, m (f i) (f i)

variable {m : J →ₗ[ℝ] J →ₗ[ℝ] J}

theorem isSoS_zero : IsSoS m 0 := ⟨0, fun i => i.elim0, by simp⟩

/-- The cone is closed under addition — the whole reason it is stated with sums of squares
rather than squares: the witness is a concatenation of index sets. -/
theorem IsSoS.add {a b : J} (ha : IsSoS m a) (hb : IsSoS m b) : IsSoS m (a + b) := by
  obtain ⟨k, f, hf⟩ := ha
  obtain ⟨l, g, hg⟩ := hb
  refine ⟨k + l, Fin.append f g, ?_⟩
  rw [Fin.sum_univ_add]
  simp only [Fin.append_left, Fin.append_right]
  rw [← hf, ← hg]

theorem isSoS_sum {ι : Type*} (s : Finset ι) (g : ι → J) (h : ∀ i ∈ s, IsSoS m (g i)) :
    IsSoS m (∑ i ∈ s, g i) := by
  classical
  induction s using Finset.induction with
  | empty => simpa using isSoS_zero
  | insert a s ha ih =>
      rw [Finset.sum_insert ha]
      exact (h a (Finset.mem_insert_self a s)).add
        (ih fun i hi => h i (Finset.mem_insert_of_mem hi))

/-- The cone is closed under nonnegative scalars: `r • (y ∘ y) = (√r • y) ∘ (√r • y)`. -/
theorem IsSoS.smul {r : ℝ} (hr : 0 ≤ r) {a : J} (ha : IsSoS m a) : IsSoS m (r • a) := by
  obtain ⟨k, f, hf⟩ := ha
  refine ⟨k, fun i => Real.sqrt r • f i, ?_⟩
  rw [hf, Finset.smul_sum]
  refine Finset.sum_congr rfl fun i _ => ?_
  simp only [map_smul, LinearMap.smul_apply, smul_smul]
  rw [Real.mul_self_sqrt hr]

theorem isSoS_of_idem {c : J} (hc : m c c = c) : IsSoS m c :=
  ⟨1, fun _ => c, by simp [hc]⟩

theorem isSoS_smul_idem {r : ℝ} (hr : 0 ≤ r) {c : J} (hc : m c c = c) : IsSoS m (r • c) :=
  (isSoS_of_idem hc).smul hr

/-- **Antisymmetry of the cone, and the only place formal reality is used in this file.**

If `a` and `-a` are both sums of squares then the concatenated family has vanishing sum of
squares, so formal reality kills every member of it — including every member of `a`'s own
family. -/
theorem eq_zero_of_isSoS_of_isSoS_neg
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    {a : J} (ha : IsSoS m a) (hna : IsSoS m (-a)) : a = 0 := by
  obtain ⟨k, f, hf⟩ := ha
  obtain ⟨l, g, hg⟩ := hna
  have hsum : (∑ i, m (Fin.append f g i) (Fin.append f g i)) = 0 := by
    rw [Fin.sum_univ_add]
    simp only [Fin.append_left, Fin.append_right]
    rw [← hf, ← hg, add_neg_cancel]
  have hz := hfr (k + l) (Fin.append f g) hsum
  rw [hf, Finset.sum_eq_zero]
  intro i _
  have hi := hz (Fin.castAdd l i)
  rw [Fin.append_left] at hi
  simp [hi]

/-- The partial order induced by the cone: `x ≤ y` iff `y - x` is a sum of squares. -/
@[instance_reducible]
def partialOrderOfSoS (m : J →ₗ[ℝ] J →ₗ[ℝ] J)
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0) :
    PartialOrder J where
  le x y := IsSoS m (y - x)
  le_refl x := by simpa using isSoS_zero
  le_trans x y z hxy hyz := by
    show IsSoS m (z - x)
    rw [← sub_add_sub_cancel z y x]
    exact hyz.add hxy
  le_antisymm x y hxy hyx := by
    have h : y - x = 0 :=
      eq_zero_of_isSoS_of_isSoS_neg hfr hxy (by rw [neg_sub]; exact hyx)
    exact (sub_eq_zero.mp h).symm

/-- The rearrangement both the order-unit bound and the Archimedean squeeze run on: against a
complete orthogonal idempotent family, `r • e - x` is again diagonal, with coefficients
`r - lam i`. -/
theorem smul_unit_sub_eq {n : ℕ} {q : Fin n → J} {lam : Fin n → ℝ} {e x : J}
    (hsum : (∑ i, q i) = e) (hx : x = ∑ i, lam i • q i) (r : ℝ) :
    r • e - x = ∑ i, (r - lam i) • q i := by
  rw [← hsum, hx, Finset.smul_sum, ← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun i _ => (sub_smul _ _ _).symm

end Cone

/-! ## The order unit space

From here the ambient structure is `ComparisonSetup`'s: a finite-dimensional real inner
product space carrying the Jordan product as a bundled bilinear map. -/

section OrderUnit

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J] [FiniteDimensional ℝ J]
variable {m : J →ₗ[ℝ] J →ₗ[ℝ] J}

/-- **Order-unit boundedness, read off the spectral resolution.**  This is the field the EJA
layer had no way to supply before `EJA/Spectral.lean`. -/
theorem exists_isSoS_smul_unit_sub
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (e : J) (he : ∀ y : J, m e y = y) (x : J) :
    ∃ r : ℝ, 0 ≤ r ∧ IsSoS m (r • e - x) := by
  obtain ⟨n, q, lam, hidem, _horth, hsum, hx⟩ :=
    spectral_resolution_bilinear m hcomm hjordan hfr e he x
  refine ⟨∑ i, |lam i|, Finset.sum_nonneg fun i _ => abs_nonneg _, ?_⟩
  have hle : ∀ i, lam i ≤ ∑ j, |lam j| := fun i =>
    le_trans (le_abs_self _)
      (Finset.single_le_sum (f := fun j => |lam j|) (fun j _ => abs_nonneg _) (Finset.mem_univ i))
  rw [smul_unit_sub_eq hsum hx]
  exact isSoS_sum _ _ fun i _ => isSoS_smul_idem (by linarith [hle i]) (hidem i)

/-- **A Euclidean Jordan algebra is an order unit space**, with the cone of sums of squares
as the positive cone and the Jordan unit as the order unit.

A `def`, not an `instance` — see the module docstring.  The `NormedAddCommGroup` and
`NormedSpace` parents are filled from the ambient instances, so no second normed structure is
created. -/
@[instance_reducible]
def orderUnitSpaceOfBilinear (m : J →ₗ[ℝ] J →ₗ[ℝ] J)
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (e : J) (he : ∀ y : J, m e y = y) :
    OrderUnitSpace J :=
  { (inferInstance : NormedAddCommGroup J), (inferInstance : NormedSpace ℝ J),
    partialOrderOfSoS m hfr with
    add_le_add_left := fun a b h c => by
      show IsSoS m (c + b - (c + a))
      rw [show c + b - (c + a) = b - a by abel]
      exact h
    ousUnit := e
    smul_nonneg_mono := fun r hr {a b} h => by
      show IsSoS m (r • b - r • a)
      rw [← smul_sub]
      exact IsSoS.smul hr h
    ousUnit_nonneg := by
      show IsSoS m (e - 0)
      rw [sub_zero]
      exact isSoS_of_idem (he e)
    archimedean := fun a => exists_isSoS_smul_unit_sub hcomm hjordan hfr e he a }

section Characterization

variable (m)
variable (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (e : J) (he : ∀ y : J, m e y = y)

/-- **No second normed structure.**  The produced order unit space's normed group is the
ambient one on the nose — the check that the `ringOfBilinear` diamond stays shut. -/
theorem normedAddCommGroup_ofBilinear :
    (orderUnitSpaceOfBilinear m hcomm hjordan hfr e he).toNormedAddCommGroup
      = (inferInstance : NormedAddCommGroup J) := rfl

theorem le_ofBilinear (x y : J) :
    letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
    x ≤ y ↔ IsSoS m (y - x) := Iff.rfl

theorem ousUnit_ofBilinear :
    @OrderUnitSpace.ousUnit J (orderUnitSpaceOfBilinear m hcomm hjordan hfr e he) = e := rfl

/-- The effect space at EJA generality — the predicate every `SequentialProductOn` axiom is
guarded by, now expressible on a Euclidean Jordan algebra. -/
theorem isEffect_ofBilinear (a : J) :
    @OrderUnitSpace.IsEffect J (orderUnitSpaceOfBilinear m hcomm hjordan hfr e he) a
      ↔ IsSoS m a ∧ IsSoS m (e - a) := by
  constructor
  · rintro ⟨h0, h1⟩
    refine ⟨?_, h1⟩
    have h0' : IsSoS m (a - 0) := h0
    rwa [sub_zero] at h0'
  · rintro ⟨h0, h1⟩
    refine ⟨?_, h1⟩
    show IsSoS m (a - 0)
    rwa [sub_zero]

/-- `RadicalRelativity/OrderUnitSpace.lean`'s spanning theorem, live at EJA generality.  It is
here as evidence that the abstract effect API genuinely applies to the constructed structure,
not merely that the structure typechecks. -/
theorem span_isEffect_eq_top_ofBilinear :
    letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
    Submodule.span ℝ {a : J | OrderUnitSpace.IsEffect a} = ⊤ := by
  letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
  exact OrderUnitSpace.span_isEffect_eq_top

/-- **The wall this file removes, named.**  `SequentialProductOn` is declared
`structure SequentialProductOn (V : Type*) [OrderUnitSpace V]`, so before this file the type of
an S1/S3–S7 sequential product on a Euclidean Jordan algebra could not be *written down* — the
instance argument had no inhabitant at that generality.  It can be written down now.

★ **Statability is the entire claim.**  No inhabitant is constructed here and none is claimed;
rows 13 and 16 need an inhabitant *and* the ports named in the module docstring. -/
abbrev SequentialProductOnEJA : Type _ :=
  @SequentialProductOn J (orderUnitSpaceOfBilinear m hcomm hjordan hfr e he)

end Characterization

end OrderUnit

/-! ## The Euclidean hypothesis: the Archimedean squeeze and the cone of squares

The two results below need more than the order: they need the coefficients of a spectral
resolution of a *positive* element to be nonnegative, which no amount of cone algebra
supplies.  What supplies it is the associative inner product — the "Euclidean" in Euclidean
Jordan algebra. -/

section Euclidean

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]
variable {m : J →ₗ[ℝ] J →ₗ[ℝ] J}

/-- **`L_c` is a positive operator for an idempotent `c`.**

`L_c = P₁(c) + ½ P_{1/2}(c)` on the nose, and both Peirce projections are idempotent
(`EJA/Peirce.lean`'s `mul_peirceOne` feeding `peirceOne_of_eigen`) and self-adjoint (from
self-adjointness of `L_c`, which is `hassoc` at `x := c`).  A self-adjoint idempotent `P`
satisfies `⟪P y, y⟫ = ⟪P y, P y⟫ ≥ 0`, so the sum is nonnegative.

★ The eigenvalue trichotomy is never invoked, and no functional calculus is needed: the two
projections are polynomials in `L_c` that the tree already carries as linear maps. -/
theorem inner_mul_self_nonneg_of_idem
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {c : J} (hc : m c c = c) (y : J) :
    0 ≤ inner ℝ (m c y) y := by
  letI : NonUnitalNonAssocCommRing J := ringOfBilinear m hcomm
  letI : IsCommJordan J := ⟨hjordan⟩
  letI : IsScalarTower ℝ J J := ⟨fun r x y => smul_bilinear m r x y⟩
  have hc' : c * c = c := hc
  have hsa : ∀ u v : J, inner ℝ (c * u) v = inner ℝ u (c * v) := fun u v => hassoc c u v
  have hsa1 : ∀ u v : J, inner ℝ (peirceOne c u) v = inner ℝ u (peirceOne c v) := by
    intro u v
    simp only [peirceOne_apply, inner_sub_left, inner_sub_right, real_inner_smul_left,
      real_inner_smul_right]
    rw [hsa (c * u) v, hsa u (c * v), hsa u v]
  have hsah : ∀ u v : J, inner ℝ (peirceHalf c u) v = inner ℝ u (peirceHalf c v) := by
    intro u v
    simp only [peirceHalf_apply, inner_sub_left, inner_sub_right, real_inner_smul_left,
      real_inner_smul_right]
    rw [hsa (c * u) v, hsa u (c * v), hsa u v]
  have hid1 : peirceOne c (peirceOne c y) = peirceOne c y :=
    peirceOne_of_eigen (mul_peirceOne hc' y)
  have hidh : peirceHalf c (peirceHalf c y) = peirceHalf c y :=
    peirceHalf_of_eigen_half (mul_peirceHalf hc' y)
  have hsplit : (m c y : J) = peirceOne c y + (2 : ℝ)⁻¹ • peirceHalf c y := by
    show c * y = _
    simp only [peirceOne_apply, peirceHalf_apply]
    module
  have key1 : inner ℝ (peirceOne c y) (peirceOne c y) = inner ℝ (peirceOne c y) y := by
    rw [hsa1 y (peirceOne c y), hid1, real_inner_comm]
  have keyh : inner ℝ (peirceHalf c y) (peirceHalf c y) = inner ℝ (peirceHalf c y) y := by
    rw [hsah y (peirceHalf c y), hidh, real_inner_comm]
  have h1 : (0 : ℝ) ≤ inner ℝ (peirceOne c y) y := key1 ▸ real_inner_self_nonneg
  have hh : (0 : ℝ) ≤ inner ℝ (peirceHalf c y) y := keyh ▸ real_inner_self_nonneg
  rw [hsplit, inner_add_left, real_inner_smul_left]
  linarith

/-- **The vanishing case of `inner_mul_self_nonneg_of_idem`.**  `⟪L_c y, y⟫ = ‖P₁y‖² + ½‖P_{½}y‖²`,
so the pairing vanishes exactly when both Peirce components do — and then `L_c y` itself is zero.

This is the self-duality step a sequential product needs: orthogonality *in the inner product*
upgrades to orthogonality *in the Jordan product*.  Same proof as the positivity statement above,
read at equality instead of inequality. -/
theorem mul_eq_zero_of_inner_mul_self_eq_zero
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {c : J} (hc : m c c = c) {y : J} (h : (inner ℝ (m c y) y : ℝ) = 0) : m c y = 0 := by
  letI : NonUnitalNonAssocCommRing J := ringOfBilinear m hcomm
  letI : IsCommJordan J := ⟨hjordan⟩
  letI : IsScalarTower ℝ J J := ⟨fun r x y => smul_bilinear m r x y⟩
  have hc' : c * c = c := hc
  have hsa : ∀ u v : J, inner ℝ (c * u) v = inner ℝ u (c * v) := fun u v => hassoc c u v
  have hsa1 : ∀ u v : J, inner ℝ (peirceOne c u) v = inner ℝ u (peirceOne c v) := by
    intro u v
    simp only [peirceOne_apply, inner_sub_left, inner_sub_right, real_inner_smul_left,
      real_inner_smul_right]
    rw [hsa (c * u) v, hsa u (c * v), hsa u v]
  have hsah : ∀ u v : J, inner ℝ (peirceHalf c u) v = inner ℝ u (peirceHalf c v) := by
    intro u v
    simp only [peirceHalf_apply, inner_sub_left, inner_sub_right, real_inner_smul_left,
      real_inner_smul_right]
    rw [hsa (c * u) v, hsa u (c * v), hsa u v]
  have hid1 : peirceOne c (peirceOne c y) = peirceOne c y :=
    peirceOne_of_eigen (mul_peirceOne hc' y)
  have hidh : peirceHalf c (peirceHalf c y) = peirceHalf c y :=
    peirceHalf_of_eigen_half (mul_peirceHalf hc' y)
  have hsplit : (m c y : J) = peirceOne c y + (2 : ℝ)⁻¹ • peirceHalf c y := by
    show c * y = _
    simp only [peirceOne_apply, peirceHalf_apply]
    module
  have key1 : (inner ℝ (peirceOne c y) (peirceOne c y) : ℝ) = inner ℝ (peirceOne c y) y := by
    rw [hsa1 y (peirceOne c y), hid1, real_inner_comm]
  have keyh : (inner ℝ (peirceHalf c y) (peirceHalf c y) : ℝ) = inner ℝ (peirceHalf c y) y := by
    rw [hsah y (peirceHalf c y), hidh, real_inner_comm]
  have h1 : (0 : ℝ) ≤ inner ℝ (peirceOne c y) y := key1 ▸ real_inner_self_nonneg
  have hh : (0 : ℝ) ≤ inner ℝ (peirceHalf c y) y := keyh ▸ real_inner_self_nonneg
  rw [hsplit, inner_add_left, real_inner_smul_left] at h
  have hz1 : (inner ℝ (peirceOne c y) y : ℝ) = 0 := by linarith
  have hzh : (inner ℝ (peirceHalf c y) y : ℝ) = 0 := by linarith
  have e1 : peirceOne c y = 0 := inner_self_eq_zero.mp (key1.trans hz1)
  have eh : peirceHalf c y = 0 := inner_self_eq_zero.mp (keyh.trans hzh)
  rw [hsplit, e1, eh, smul_zero, add_zero]

/-- **Orthogonality to an idempotent, on the cone, is Jordan orthogonality.**

If `b` is a sum of squares and pairs to zero with an idempotent `c`, then `c ∘ b = 0` outright.
Each square contributes `⟪L_c fᵢ, fᵢ⟫ ≥ 0`, so a vanishing total forces every term to vanish,
`mul_eq_zero_of_inner_mul_self_eq_zero` turns each into `c ∘ fᵢ = 0`, and `J₀(c)` being a
subalgebra (`eigen_zero_mul_zero`) carries that to the squares. -/
theorem mul_isSoS_eq_zero_of_inner_eq_zero
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {c : J} (hc : m c c = c) {b : J} (hb : IsSoS m b)
    (h : (inner ℝ c b : ℝ) = 0) : m c b = 0 := by
  letI : NonUnitalNonAssocCommRing J := ringOfBilinear m hcomm
  letI : IsCommJordan J := ⟨hjordan⟩
  letI : IsScalarTower ℝ J J := ⟨fun r x y => smul_bilinear m r x y⟩
  have hc' : c * c = c := hc
  obtain ⟨k, f, hf⟩ := hb
  have hstep : ∀ i, (inner ℝ c (m (f i) (f i)) : ℝ) = inner ℝ (m c (f i)) (f i) := by
    intro i
    calc inner ℝ c (m (f i) (f i))
        = inner ℝ (m (f i) (f i)) c := real_inner_comm _ _
      _ = inner ℝ (f i) (m (f i) c) := hassoc (f i) (f i) c
      _ = inner ℝ (f i) (m c (f i)) := by rw [hcomm (f i) c]
      _ = inner ℝ (m c (f i)) (f i) := real_inner_comm _ _
  have hnn : ∀ i, (0 : ℝ) ≤ inner ℝ (m c (f i)) (f i) := fun i =>
    inner_mul_self_nonneg_of_idem hcomm hjordan hassoc hc (f i)
  have hsum : (∑ i, (inner ℝ (m c (f i)) (f i) : ℝ)) = 0 := by
    rw [← h, hf, inner_sum]
    exact (Finset.sum_congr rfl fun i _ => hstep i).symm
  have hzero : ∀ i, (c * f i : J) = 0 := by
    intro i
    refine mul_eq_zero_of_inner_mul_self_eq_zero hcomm hjordan hassoc hc ?_
    exact (Finset.sum_eq_zero_iff_of_nonneg fun j _ => hnn j).mp hsum i (Finset.mem_univ i)
  show (c * b : J) = 0
  rw [hf]
  show (c * ∑ i, (f i * f i) : J) = 0
  rw [Finset.mul_sum]
  exact Finset.sum_eq_zero fun i _ => eigen_zero_mul_zero hc' (hzero i) (hzero i)

/-- **A sum of squares has nonnegative spectral coefficients.**

Pairing against `q k` reads the coefficient off — the idempotents are pairwise orthogonal for
the inner product because `hassoc` turns `⟪q k, q i⟫` into `⟪q k, q k ∘ q i⟫` — while pairing
against the sum-of-squares presentation is nonnegative term by term, each term being
`⟪L_{q k} f j, f j⟫`.

This is the fact that both `isArchimedean_ofBilinear` and `isSoS_iff_exists_sq` reduce to, and
it is the only content in this file that the order axioms themselves do not supply. -/
theorem inner_left_coeff
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {n : ℕ} {q : Fin n → J} {lam : Fin n → ℝ}
    (hidem : ∀ i, m (q i) (q i) = q i)
    (horth : ∀ i j, i ≠ j → m (q i) (q j) = 0)
    {x : J} (hx : x = ∑ i, lam i • q i) (k : Fin n) :
    inner ℝ (q k) x = lam k * inner ℝ (q k) (q k) := by
  have horthinner : ∀ i, i ≠ k → inner ℝ (q k) (q i) = (0 : ℝ) := by
    intro i hi
    calc inner ℝ (q k) (q i) = inner ℝ (m (q k) (q k)) (q i) := by rw [hidem k]
      _ = inner ℝ (q k) (m (q k) (q i)) := hassoc (q k) (q k) (q i)
      _ = 0 := by rw [horth k i (Ne.symm hi), inner_zero_right]
  rw [hx, inner_sum, Finset.sum_eq_single k]
  · rw [real_inner_smul_right]
  · intro i _ hi
    rw [real_inner_smul_right, horthinner i hi, mul_zero]
  · intro h
    exact absurd (Finset.mem_univ k) h

/-- A coefficient is nonnegative as soon as its idempotent pairs nonnegatively with the
element — the shape shared by `nonneg_coeff_of_isSoS` (where the pairing is nonnegative
because `x` is a sum of squares) and by `hermitian_nonneg_le_isSoS` (where it is nonnegative
because `x` is positive semidefinite). -/
theorem nonneg_coeff_of_inner_nonneg
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {n : ℕ} {q : Fin n → J} {lam : Fin n → ℝ}
    (hidem : ∀ i, m (q i) (q i) = q i)
    (horth : ∀ i j, i ≠ j → m (q i) (q j) = 0)
    {x : J} (hx : x = ∑ i, lam i • q i)
    {k : Fin n} (hk : q k ≠ 0) (hnn : (0 : ℝ) ≤ inner ℝ (q k) x) : 0 ≤ lam k := by
  have hxk := inner_left_coeff hassoc hidem horth hx k
  have hpos : (0 : ℝ) < inner ℝ (q k) (q k) := real_inner_self_pos.mpr hk
  nlinarith [hxk, hnn, hpos]

theorem nonneg_coeff_of_isSoS
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {n : ℕ} {q : Fin n → J} {lam : Fin n → ℝ}
    (hidem : ∀ i, m (q i) (q i) = q i)
    (horth : ∀ i j, i ≠ j → m (q i) (q j) = 0)
    {x : J} (hx : x = ∑ i, lam i • q i) (hsos : IsSoS m x)
    {k : Fin n} (hk : q k ≠ 0) : 0 ≤ lam k := by
  obtain ⟨j, f, hf⟩ := hsos
  have hnn : (0 : ℝ) ≤ inner ℝ (q k) x := by
    rw [hf, inner_sum]
    refine Finset.sum_nonneg fun i _ => ?_
    have hstep : inner ℝ (q k) (m (f i) (f i)) = inner ℝ (m (q k) (f i)) (f i) := by
      calc inner ℝ (q k) (m (f i) (f i))
          = inner ℝ (m (f i) (f i)) (q k) := real_inner_comm _ _
        _ = inner ℝ (f i) (m (f i) (q k)) := hassoc (f i) (f i) (q k)
        _ = inner ℝ (f i) (m (q k) (f i)) := by rw [hcomm (f i) (q k)]
        _ = inner ℝ (m (q k) (f i)) (f i) := real_inner_comm _ _
    rw [hstep]
    exact inner_mul_self_nonneg_of_idem hcomm hjordan hassoc (hidem k) (f i)
  exact nonneg_coeff_of_inner_nonneg hassoc hidem horth hx hk hnn

variable [FiniteDimensional ℝ J]

/-- **The genuine Archimedean property**, in the sense
`RadicalRelativity/OrderUnitSpace.lean`'s `IsArchimedean` carries: an element under *every*
positive multiple of the unit is nonpositive.

This is strictly stronger than the class's `archimedean` field, which is order-unit
boundedness only; ARC-6 proved `lem:homog`(ii) and `lem:cone-ext` carrying `IsArchimedean` as
a hypothesis, and until now `H_n(𝕜)` was the only carrier discharging it. -/
theorem isArchimedean_ofBilinear
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    (e : J) (he : ∀ y : J, m e y = y) :
    @OrderUnitSpace.IsArchimedean J (orderUnitSpaceOfBilinear m hcomm hjordan hfr e he) := by
  intro x hx
  show IsSoS m (0 - x)
  obtain ⟨n, q, lam, hidem, horth, hsum, hxe⟩ :=
    spectral_resolution_bilinear m hcomm hjordan hfr e he x
  have hlam : ∀ i, q i ≠ 0 → lam i ≤ 0 := by
    intro i hi
    by_contra hcon
    have hpos : 0 < lam i := not_le.mp hcon
    have hsos : IsSoS m ((lam i / 2) • e - x) := hx (lam i / 2) (by linarith)
    have hrw := smul_unit_sub_eq hsum hxe (lam i / 2)
    have := nonneg_coeff_of_isSoS hcomm hjordan hassoc hidem horth hrw (hrw ▸ hsos) hi
    linarith
  have h0 := smul_unit_sub_eq hsum hxe 0
  rw [zero_smul] at h0
  rw [h0]
  refine isSoS_sum _ _ fun i _ => ?_
  by_cases hi : q i = 0
  · rw [hi, smul_zero]
    exact isSoS_zero
  · exact isSoS_smul_idem (by linarith [hlam i hi]) (hidem i)

/-- **The cone of the order is the cone of squares** — `nonneg_iff_squares` as
`WallCertificates/eja-gated.lean`'s `JBPremises` pins it, now a theorem rather than the
reading a definition would have had to assume.

The forward direction is the whole content: a sum of squares has nonnegative coefficients, so
`∑ √(lam i) • q i` squares back to it by orthogonality. -/
theorem isSoS_iff_exists_sq
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    (e : J) (he : ∀ y : J, m e y = y) (x : J) :
    IsSoS m x ↔ ∃ y : J, x = m y y := by
  constructor
  · intro hsos
    obtain ⟨n, q, lam, hidem, horth, hsum, hxe⟩ :=
      spectral_resolution_bilinear m hcomm hjordan hfr e he x
    set s : Fin n → ℝ := fun i => Real.sqrt (max (lam i) 0) with hs
    refine ⟨∑ i, s i • q i, ?_⟩
    have step : ∀ v : J, m (∑ i, s i • q i) v = ∑ i, s i • m (q i) v := by
      intro v
      rw [map_sum, LinearMap.sum_apply]
      exact Finset.sum_congr rfl fun i _ => by rw [map_smul, LinearMap.smul_apply]
    have step2 : ∀ i, m (q i) (∑ j, s j • q j) = s i • q i := by
      intro i
      rw [map_sum, Finset.sum_eq_single i]
      · rw [map_smul, hidem i]
      · intro j _ hj
        rw [map_smul, horth i j (Ne.symm hj), smul_zero]
      · intro h
        exact absurd (Finset.mem_univ i) h
    have hexp : m (∑ i, s i • q i) (∑ i, s i • q i) = ∑ i, (s i * s i) • q i := by
      rw [step]
      simp only [step2, smul_smul]
    rw [hexp, hxe]
    refine Finset.sum_congr rfl fun i _ => ?_
    by_cases hi : q i = 0
    · rw [hi, smul_zero, smul_zero]
    · have hnn : 0 ≤ lam i :=
        nonneg_coeff_of_isSoS hcomm hjordan hassoc hidem horth hxe hsos hi
      rw [hs]
      simp only
      rw [max_eq_left hnn, Real.mul_self_sqrt hnn]
  · rintro ⟨y, rfl⟩
    exact ⟨1, fun _ => y, by simp⟩


/-! ## Sharpness: idempotent effects are sharp

`STATEMENT-MANIFEST.md` row 8 (`lem:simple-bridge`) states its residue exactly: "define `E₀`,
prove `idempotent ⟹ IsSharp` for the effect order, and state 'every effect is simple'".  The
middle item is proved here; `OrderUnitSpace.IsSharp` is the article's own order-theoretic
sharpness and had, before this, exactly one occurrence in the whole checkout — its definition.

The proof needs no functional calculus and no new order theory.  It is three moves against
`inner_mul_self_nonneg_of_idem`: an idempotent pairs nonnegatively with the cone, `p` and `e - p`
pair to zero with each other, and an element of the cone pairing to zero with the unit is zero. -/

/-- **An idempotent pairs nonnegatively with the cone.**  Extracted from the body of
`nonneg_coeff_of_isSoS`, which proves exactly this en route and then discards it. -/
theorem inner_idem_isSoS_nonneg
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    {c : J} (hc : m c c = c) {x : J} (hx : IsSoS m x) : (0 : ℝ) ≤ inner ℝ c x := by
  obtain ⟨j, f, hf⟩ := hx
  rw [hf, inner_sum]
  refine Finset.sum_nonneg fun i _ => ?_
  have hstep : inner ℝ c (m (f i) (f i)) = inner ℝ (m c (f i)) (f i) := by
    calc inner ℝ c (m (f i) (f i))
        = inner ℝ (m (f i) (f i)) c := real_inner_comm _ _
      _ = inner ℝ (f i) (m (f i) c) := hassoc (f i) (f i) c
      _ = inner ℝ (f i) (m c (f i)) := by rw [hcomm (f i) c]
      _ = inner ℝ (m c (f i)) (f i) := real_inner_comm _ _
  rw [hstep]
  exact inner_mul_self_nonneg_of_idem hcomm hjordan hassoc hc (f i)

/-- **An element of the cone orthogonal to the unit is zero.**  `⟪e, ∑ fᵢ²⟫ = ∑ ‖fᵢ‖²`, so the
pairing with the unit is the squared norm of the presentation. -/
theorem eq_zero_of_isSoS_of_inner_unit_eq_zero
    (hcomm : ∀ x y : J, m x y = m y x)
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    (e : J) (he : ∀ y : J, m e y = y) {x : J} (hx : IsSoS m x)
    (h : inner ℝ e x = (0 : ℝ)) : x = 0 := by
  obtain ⟨j, f, hf⟩ := hx
  have hterm : ∀ i, inner ℝ e (m (f i) (f i)) = (inner ℝ (f i) (f i) : ℝ) := by
    intro i
    calc inner ℝ e (m (f i) (f i))
        = inner ℝ (m (f i) (f i)) e := real_inner_comm _ _
      _ = inner ℝ (f i) (m (f i) e) := hassoc (f i) (f i) e
      _ = inner ℝ (f i) (f i) := by rw [hcomm (f i) e, he]
  have hsum : (∑ i, (inner ℝ (f i) (f i) : ℝ)) = 0 := by
    rw [← h, hf, inner_sum]
    exact (Finset.sum_congr rfl fun i _ => hterm i).symm
  have hzero : ∀ i, f i = 0 := by
    intro i
    have hnn : ∀ k, (0 : ℝ) ≤ inner ℝ (f k) (f k) := fun k => real_inner_self_nonneg
    have := (Finset.sum_eq_zero_iff_of_nonneg fun k _ => hnn k).mp hsum i (Finset.mem_univ i)
    exact inner_self_eq_zero.mp this
  rw [hf]
  exact Finset.sum_eq_zero fun i _ => by simp [hzero i]

variable (m) in
/-- **The bridge between the tree's two spellings of sharpness.**

`EJA/OrderAuto.lean` defines its own `EJA.IsSharp e c` in sums-of-squares vocabulary — `0 ≤ z`
spelled `IsSoS m z`, `a ≤ b` spelled `IsSoS m (b - a)` — and proves both directions of
`sharp ⟺ idempotent` against it.  Its docstring records that **no lemma relates that predicate to
`OrderUnitSpace.IsSharp`**, the article's order-theoretic sharpness.  This is that lemma, stated
at bilinear-map generality so that both spellings are in scope.

The two are not equivalent and the asymmetry is the whole content: the sums-of-squares form
quantifies over every `x` in the cone, while the order-theoretic form quantifies only over
*effects*.  So the sums-of-squares form is **strictly stronger**, and the implication runs in this
direction only.  A converse would need every cone element below `c` to be an effect, which is true
here but is a separate fact about the interval.

★ **Measured, not predicted: applying this at `mulLₗ` does not go through today.**  The obvious
corollary — `EJA.IsSharp e c → OrderUnitSpace.IsSharp c` stated in `EJA/OrderAuto.lean` — fails to
elaborate, because `mulLₗ` takes its `Module ℝ J` from the ring side while
`orderUnitSpaceOfBilinear` takes its from `InnerProductSpace ℝ J`, and no binder order tried on
2026-08-23 makes the two paths agree; the failure is `synthInstance` on `Module ℝ J`, not on the
mathematics.  This is the same *kind* of elaboration-path artifact `EJA/PeirceSubalgebra.lean`
records for `IsFormallyReal`, and like that one it is presumably cosmetic — but it has **not** been
shown to be, so the transport is stated here and not yet used there. -/
theorem isSharpOrderUnit_of_sosSharp
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (e : J) (he : ∀ y : J, m e y = y) {c : J}
    (hc : IsSoS m c) (hec : IsSoS m (e - c))
    (hsharp : ∀ x : J, IsSoS m x → IsSoS m (c - x) → IsSoS m (e - c - x) → x = 0) :
    letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
    OrderUnitSpace.IsSharp c := by
  letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
  refine ⟨(isEffect_ofBilinear (m := m) hcomm hjordan hfr e he c).mpr ⟨hc, hec⟩, ?_⟩
  intro a ha hac hanc
  refine hsharp a ((isEffect_ofBilinear (m := m) hcomm hjordan hfr e he a).mp ha).1 hac ?_
  have h : IsSoS m (OrderUnitSpace.ousUnit - c - a) := hanc
  rwa [ousUnit_ofBilinear (m := m) hcomm hjordan hfr e he] at h

variable (m) in
/-- **Every idempotent effect is sharp** — the interior half of `lem:simple-bridge`'s clause (ii).

`p` and `e - p` are orthogonal idempotents, so each pairs to zero with the other.  An effect `a`
below both is therefore orthogonal to both, hence to `e`, hence zero.

★ The converse, `sharp ⟹ idempotent`, is **not** proved here and is not claimed: the article
itself attributes it to a citation (vdW Prop. 3.15), so it is external by the article's own
attribution.

★★ **Read this before assuming it duplicates `EJA/OrderAuto.lean`.**  That file proves both
directions, as `isSharp_of_idem`/`idem_of_isSharp`/`isSharp_iff_idem` — but against its *own*
`EJA.IsSharp e c`, a sums-of-squares spelling at class generality, and its docstring states
plainly that "**no lemma below relates the two**".  This theorem lands in
`OrderUnitSpace.IsSharp`, which is the article's order-theoretic sharpness and the one
`IsSimpleEffect` is defined against, at bilinear-map generality.  Relating the two spellings is
still not done; `EJA.IsSharp` is the *stronger* of the two (its quantifier asks only `IsSoS x`
where the order-theoretic one asks for a full effect), so that bridge should run in this
direction and would make this proof redundant.  It does not exist today. -/
theorem isSharpOrderUnit_of_idem
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    (e : J) (he : ∀ y : J, m e y = y) {p : J} (hp : m p p = p) :
    letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
    OrderUnitSpace.IsSharp p := by
  letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
  -- `e - p` is the complementary idempotent, and the two are orthogonal.
  have hpe : m p e = p := by rw [hcomm p e, he]
  have hcross : m p (e - p) = 0 := by rw [map_sub, hpe, hp, sub_self]
  have hq : m (e - p) (e - p) = e - p := by
    rw [map_sub, hcomm (e - p) e, he, hcomm (e - p) p, hcross, sub_zero]
  -- Each pairs to zero with the other.
  have hip : inner ℝ p (e - p) = (0 : ℝ) := by
    calc inner ℝ p (e - p) = inner ℝ (m p p) (e - p) := by rw [hp]
      _ = inner ℝ p (m p (e - p)) := hassoc p p (e - p)
      _ = 0 := by rw [hcross, inner_zero_right]
  have hiq : inner ℝ (e - p) p = (0 : ℝ) := by rw [real_inner_comm]; exact hip
  refine ⟨(isEffect_ofBilinear (m := m) hcomm hjordan hfr e he p).mpr
      ⟨isSoS_of_idem hp, isSoS_of_idem hq⟩, ?_⟩
  intro a ha hap haq
  have hasos : IsSoS m a := ((isEffect_ofBilinear (m := m) hcomm hjordan hfr e he a).mp ha).1
  -- `a ≤ p` and `a ≤ e - p` are literally sums-of-squares statements.
  have hpa : IsSoS m (p - a) := hap
  have hqa : IsSoS m (e - p - a) := haq
  -- Orthogonal to `e - p`, using `⟪e-p, p⟫ = 0`.
  have h1 : inner ℝ (e - p) a = (0 : ℝ) := by
    have hge := inner_idem_isSoS_nonneg hcomm hjordan hassoc hq hasos
    have hle := inner_idem_isSoS_nonneg hcomm hjordan hassoc hq hpa
    rw [inner_sub_right, hiq, zero_sub, neg_nonneg] at hle
    linarith
  -- Orthogonal to `p`, using `⟪p, e-p⟫ = 0`.
  have h2 : inner ℝ p a = (0 : ℝ) := by
    have hge := inner_idem_isSoS_nonneg hcomm hjordan hassoc hp hasos
    have hle := inner_idem_isSoS_nonneg hcomm hjordan hassoc hp hqa
    rw [inner_sub_right, hip, zero_sub, neg_nonneg] at hle
    linarith
  -- Hence orthogonal to the unit, hence zero.
  refine eq_zero_of_isSoS_of_inner_unit_eq_zero hcomm hassoc e he hasos ?_
  have : (e : J) = p + (e - p) := by abel
  rw [this, inner_add_left, h2, h1, add_zero]


variable (m) in
/-- **`E = E₀`: every effect is simple** — `lem:simple-bridge` clause (ii), at the article's own
generality.

The article's proof is one sentence (`main.tex:549-550`): "holds by the Jordan spectral theorem:
every element is a finite real combination of orthogonal idempotents".  That theorem is
`spectral_resolution_bilinear`; what this adds is that its idempotents are *sharp* in the
order-theoretic sense the definition of `E₀` requires, which is `isSharp_of_idem`, and that they
form an orthogonal family in the order sense, which is completeness `∑ qᵢ = e` read through the
cone.

★ Clause (ii) is the row's **only interior clause** — the article assigns (i) to vdW Thm. A.6,
(iii) to vdW Props. 4.19–4.20 and (iv) to a vdW remark.  ★ And the equivalence
`sharp ⟺ idempotent` is used here in the direction `idempotent ⟹ sharp` only; the converse is
vdW Prop. 3.15 and stays a citation. -/
theorem isSimpleEffect_of_isEffect
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (hassoc : ∀ x y z : J, inner ℝ (m x y) z = inner ℝ y (m x z))
    (e : J) (he : ∀ y : J, m e y = y) (a : J) :
    letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
    OrderUnitSpace.IsEffect a → OrderUnitSpace.IsSimpleEffect a := by
  classical
  letI := orderUnitSpaceOfBilinear m hcomm hjordan hfr e he
  intro ha
  obtain ⟨n, q, lam, hidem, horth, hsum, hxa⟩ :=
    spectral_resolution_bilinear m hcomm hjordan hfr e he a
  -- Every partial sum of the resolution is an effect: its complement in the family is its
  -- own certificate, because the family is complete for `e`.
  have hcompl : ∀ s : Finset (Fin n), e - ∑ i ∈ s, q i = ∑ i ∈ sᶜ, q i := by
    intro s
    rw [← hsum, ← Finset.sum_add_sum_compl s q]
    abel
  have hpartial : ∀ s : Finset (Fin n),
      OrderUnitSpace.IsEffect (∑ i ∈ s, q i) := by
    intro s
    refine (isEffect_ofBilinear (m := m) hcomm hjordan hfr e he _).mpr ⟨?_, ?_⟩
    · exact isSoS_sum s q fun i _ => isSoS_of_idem (hidem i)
    · rw [hcompl s]
      exact isSoS_sum sᶜ q fun i _ => isSoS_of_idem (hidem i)
  refine ⟨ha, n, q, lam, ⟨?_, ?_⟩, ?_, hxa⟩
  · intro i
    have := hpartial {i}
    rwa [Finset.sum_singleton] at this
  · intro s
    have h := (hpartial s).2
    rwa [ousUnit_ofBilinear (m := m) hcomm hjordan hfr e he] at h ⊢
  · intro i
    exact isSharpOrderUnit_of_idem m hcomm hjordan hfr hassoc e he (hidem i)

end Euclidean

/-! ## A live carrier for the hypothesis bundle

`H_n(𝕜)` satisfies every hypothesis above, including the associative-inner-product hypothesis
this file introduces, so nothing in the two previous sections is conditional on a premise with
no carrier.  The construction is applied to it at the end; the resulting order unit space is a
*second* one on `H_n(𝕜)`, kept as a `def` and never an instance, and it is **not** proved
equal to the vendored Loewner structure (see the module docstring). -/

section Carrier

open Necessity ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n] {𝕜 : Type*} [RCLike 𝕜]

/-- **The Euclidean hypothesis, live on the paper's own carrier.**  Both sides are
`½(Tr[ABC] + Tr[BAC])` after `Matrix.trace_mul_cycle`. -/
theorem hermitian_jordan_assoc (A B C : HermitianMat n 𝕜) :
    inner ℝ (jordanBilinG 𝕜 A B) C = inner ℝ B (jordanBilinG 𝕜 A C) := by
  have htr : (((2 : 𝕜)⁻¹ • (A.mat * B.mat + B.mat * A.mat)) * C.mat).trace
      = (B.mat * ((2 : 𝕜)⁻¹ • (A.mat * C.mat + C.mat * A.mat))).trace := by
    rw [Matrix.smul_mul, Matrix.mul_smul, Matrix.trace_smul, Matrix.trace_smul]
    congr 1
    rw [Matrix.add_mul, Matrix.mul_add, Matrix.trace_add, Matrix.trace_add, add_comm]
    congr 1
    · rw [mul_assoc]
    · rw [Matrix.trace_mul_cycle, Matrix.trace_mul_cycle, mul_assoc]
  rw [HermitianMat.inner_def, HermitianMat.inner_def, jordanBilin_applyG, jordanBilin_applyG,
    HermitianMat.symmMul_toMat, HermitianMat.symmMul_toMat, htr]

theorem hermitian_jordan_comm (A B : HermitianMat n 𝕜) :
    jordanBilinG 𝕜 A B = jordanBilinG 𝕜 B A :=
  HermitianMat.symmMul_comm A B

/-! The two facts below are the only ones that need `HermMul`'s *scoped* multiplicative
instances (`CommMagma`, `MulZeroClass`, `IsCommJordan`), so the `open` is confined to this
block rather than covering the whole section.

★ **That confinement is hygiene, not a fix, and the record should say so.**  It was made while
chasing an elaboration blow-up in `hermitian_isArchimedean_ofEJA` and
`hermitian_isSoS_iff_exists_sq` on the theory that a second multiplicative structure in scope
was making unification search a diamond.  **It changed nothing** — the timeout survived it
unaltered, as did a second theory that the mismatch between `HermitianMat.instAddCommGroup`
and `NormedAddCommGroup.toAddCommGroup` was being paid for (that defeq costs about a second in
isolation).  The real cause is recorded at the two call sites below. -/

section ScopedMul
open HermMul

theorem hermitian_jordan_id (A B : HermitianMat n 𝕜) :
    jordanBilinG 𝕜 (jordanBilinG 𝕜 A B) (jordanBilinG 𝕜 A A)
      = jordanBilinG 𝕜 A (jordanBilinG 𝕜 B (jordanBilinG 𝕜 A A)) := by
  simpa only [jordanBilin_applyG, ← HermMul.mul_eq_symmMul] using
    IsCommJordan.lmul_comm_rmul_rmul A B

theorem hermitian_formallyReal (k : ℕ) (f : Fin k → HermitianMat n 𝕜)
    (h : (∑ i, jordanBilinG 𝕜 (f i) (f i)) = 0) (i : Fin k) : f i = 0 :=
  IsFormallyReal.eq_zero_of_sum_mul_self Finset.univ f
    (by simpa only [jordanBilin_applyG, ← HermMul.mul_eq_symmMul] using h)
    i (Finset.mem_univ i)

end ScopedMul

theorem hermitian_jordan_unit (A : HermitianMat n 𝕜) : jordanBilinG 𝕜 1 A = A :=
  HermitianMat.one_symmMul A

/-! ★★ **Why every application below pins `(J := HermitianMat n 𝕜)` explicitly.**

Without it these three declarations exhausted 200 000 heartbeats, and raising the budget was
the wrong move: with `maxHeartbeats 0` the elaboration ran for two minutes and then *failed*,
having defaulted `J := ℕ` off the bare numeral `1` supplied for the explicit `e : J`.  The
profiler names the cost exactly.  With `J` unsolved, the `m` argument stays a metavariable
through the argument list, so checking `hermitian_formallyReal` becomes the higher-order
problem

  `∑ i, (?m (f i)) (f i)  =?=  ∑ i, ((jordanBilinG ?n) (f i)) (f i)`,

and `isDefEq` unfolds `Finset.sum` through `Multiset.foldr`, `Quot.liftOn` and `List.map`
hunting for a match — thirteen seconds, and it fails.  Pinning `J` makes the same unification
first-order and the whole file elaborates in about six seconds.

The transferable rule: **an `isDefEq` timeout under a `Finset.sum` usually means a
metavariable in the function position, not a budget that is too small.**  Ascribing the
numeral (`(1 : HermitianMat n 𝕜)`) is necessary too but not sufficient — it removes the wrong
`ℕ` answer without removing the search. -/

/-- **The construction, applied to `H_n(𝕜)`.**  Its only job is to witness that the
hypothesis bundle of `orderUnitSpaceOfBilinear` is inhabited. -/
@[instance_reducible]
def hermitianOrderUnitOfEJA : OrderUnitSpace (HermitianMat n 𝕜) :=
  orderUnitSpaceOfBilinear (J := HermitianMat n 𝕜) (jordanBilinG 𝕜) hermitian_jordan_comm
    hermitian_jordan_id hermitian_formallyReal (1 : HermitianMat n 𝕜) hermitian_jordan_unit

/-- The Archimedean squeeze holds for the constructed structure on `H_n(𝕜)`, so
`isArchimedean_ofBilinear` is not vacuous either. -/
theorem hermitian_isArchimedean_ofEJA :
    @OrderUnitSpace.IsArchimedean (HermitianMat n 𝕜) hermitianOrderUnitOfEJA :=
  isArchimedean_ofBilinear (J := HermitianMat n 𝕜) (m := jordanBilinG 𝕜) hermitian_jordan_comm
    hermitian_jordan_id hermitian_formallyReal hermitian_jordan_assoc (1 : HermitianMat n 𝕜)
    hermitian_jordan_unit

/-- And the cone of the constructed order is the cone of squares on `H_n(𝕜)`. -/
theorem hermitian_isSoS_iff_exists_sq (A : HermitianMat n 𝕜) :
    IsSoS (jordanBilinG 𝕜) A ↔ ∃ B : HermitianMat n 𝕜, A = jordanBilinG 𝕜 B B :=
  isSoS_iff_exists_sq (J := HermitianMat n 𝕜) (m := jordanBilinG 𝕜) hermitian_jordan_comm
    hermitian_jordan_id hermitian_formallyReal hermitian_jordan_assoc (1 : HermitianMat n 𝕜)
    hermitian_jordan_unit A

/-! ### The constructed order *is* the Loewner order on `H_n(𝕜)`

Fidelity, not inhabitedness: the abstract cone could have been inhabited and still been the
wrong cone.  Both containments are below. -/

/-- A Jordan square in `H_n(𝕜)` is positive semidefinite: the Jordan square is the matrix
square, and `M M = Mᴴ M` for `M` Hermitian. -/
theorem hermitian_sq_nonneg (B : HermitianMat n 𝕜) : 0 ≤ jordanBilinG 𝕜 B B := by
  rw [HermitianMat.zero_le_iff, jordanBilin_applyG, HermitianMat.symmMul_self]
  simpa only [B.H.eq] using Matrix.posSemidef_conjTranspose_mul_self B.mat

/-- A Jordan idempotent is therefore positive semidefinite: it *is* its own square. -/
theorem hermitian_idem_nonneg {C : HermitianMat n 𝕜} (hC : jordanBilinG 𝕜 C C = C) : 0 ≤ C :=
  hC ▸ hermitian_sq_nonneg C

/-- Sums of squares are positive semidefinite. -/
theorem hermitian_isSoS_le_nonneg {A : HermitianMat n 𝕜} (h : IsSoS (jordanBilinG 𝕜) A) :
    0 ≤ A := by
  obtain ⟨k, f, hf⟩ := h
  rw [hf]
  exact Finset.sum_nonneg fun i _ => hermitian_sq_nonneg (f i)

/-- **The containment that needed the Euclidean hypothesis**: a positive semidefinite matrix is
a sum of squares.  Its spectral idempotents are themselves positive semidefinite, so
`⟪q i, A⟫ ≥ 0` by `HermitianMat.inner_ge_zero`, and `inner_left_coeff` reads that off as
`lam i ≥ 0`. -/
theorem hermitian_nonneg_le_isSoS {A : HermitianMat n 𝕜} (hA : 0 ≤ A) :
    IsSoS (jordanBilinG 𝕜) A := by
  obtain ⟨N, q, lam, hidem, horth, hsum, hxe⟩ :=
    spectral_resolution_bilinear (J := HermitianMat n 𝕜) (jordanBilinG 𝕜) hermitian_jordan_comm
      hermitian_jordan_id hermitian_formallyReal (1 : HermitianMat n 𝕜) hermitian_jordan_unit A
  rw [hxe]
  refine isSoS_sum _ _ fun i _ => ?_
  by_cases hi : q i = 0
  · rw [hi, smul_zero]
    exact isSoS_zero
  · refine isSoS_smul_idem ?_ (hidem i)
    refine nonneg_coeff_of_inner_nonneg (J := HermitianMat n 𝕜) (m := jordanBilinG 𝕜)
      hermitian_jordan_assoc hidem horth hxe hi ?_
    exact HermitianMat.inner_ge_zero (hermitian_idem_nonneg (hidem i)) hA

/-- **The abstract cone is the Loewner cone on the paper's own carrier.** -/
theorem hermitian_isSoS_iff_nonneg (A : HermitianMat n 𝕜) :
    IsSoS (jordanBilinG 𝕜) A ↔ 0 ≤ A :=
  ⟨hermitian_isSoS_le_nonneg, hermitian_nonneg_le_isSoS⟩

/-- **The constructed order relation is the Loewner order relation.** -/
theorem hermitian_le_ofEJA_iff (A B : HermitianMat n 𝕜) :
    @LE.le (HermitianMat n 𝕜) (@Preorder.toLE _ (@PartialOrder.toPreorder _
      (@OrderUnitSpace.toPartialOrder _ hermitianOrderUnitOfEJA))) A B ↔ A ≤ B := by
  rw [show (@LE.le (HermitianMat n 𝕜) (@Preorder.toLE _ (@PartialOrder.toPreorder _
      (@OrderUnitSpace.toPartialOrder _ hermitianOrderUnitOfEJA))) A B)
    = IsSoS (jordanBilinG 𝕜) (B - A) from rfl,
    hermitian_isSoS_iff_nonneg, sub_nonneg]

end Carrier

end RadicalRelativity.EJA
