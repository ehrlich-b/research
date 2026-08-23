/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Necessity.ComplexRowUnconditional
import RadicalRelativity.Necessity.RealRowUnconditional

set_option linter.style.longLine false

/-!
# S2 in the ORDER-UNIT norm: the literal-fidelity bridge, and both rows restated over it

`SequentialProductOn.FirstArgContinuous` — the S2 hypothesis both flagship rows carry — is
`ContinuousOn` in the topology the carrier *has*, which on `HermitianMat n 𝕜` is the Frobenius
(Hilbert–Schmidt) norm inherited from the matrix algebra.  **The manuscript's S2 is continuity
in the order-unit norm** `‖a‖_e = inf {t ≥ 0 | −t·1 ≤ a ≤ t·1}`, the norm an order-unit space
carries intrinsically.  On a finite-dimensional carrier the two are equivalent, and
`Hermitian/OrderUnit.lean` proves the two-sided comparison
(`ouNorm_le_norm`, `norm_le_sqrt_card_mul_ouNorm`) — but a comparison of *norms* is not by
itself a statement about `ContinuousOn`, so until now the fidelity of the Lean S2 to the
paper's S2 was an argument in `THEOREM-MAP.md` rather than a theorem.  This file makes it a
theorem, and restates both rows so that their S2 hypothesis is the paper's verbatim.

Why the restatement is not vacuous bookkeeping: `ContinuousOn` cannot express "continuous in
the order-unit norm" directly, because the carrier has exactly one `TopologicalSpace` instance
and it is the Frobenius one.  So the order-unit hypothesis has to be written out in ε–δ form
against `ouNorm` on **both** sides of the map (`ContinuousOnOu`), which is precisely how the
manuscript states S2, and then proved equivalent.

* `HermitianMat.ContinuousOnOu` — ε–δ continuity on a set, both distances in `ouNorm`.
* `HermitianMat.continuousOnOu_iff_continuousOn` — **the bridge**: on a nonempty index type
  the two notions coincide.  The sandwich `ouNorm ≤ ‖·‖ ≤ √(card n)·ouNorm` supplies one
  rescaling of `ε` in each direction.
* `Necessity.FirstArgContinuousOu` — the paper's S2 for a pinned product, and
  `firstArgContinuousOu_iff` its equivalence with `FirstArgContinuous`.
* `Necessity.real_classification_ouNorm` and
  `Necessity.complex_classification_unconditional_ouNorm` — **both flagship rows with the
  paper's S2 as the literal hypothesis.**  Same conclusions, same closure (Lean core); the only
  change is that nothing is left to a prose argument about which norm S2 refers to.
-/

noncomputable section

open OrderUnitSpace

namespace HermitianMat

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {𝕜 : Type*} [RCLike 𝕜]

omit [DecidableEq n] in
/-- The comparison constant is positive as soon as the index type is nonempty. -/
theorem sqrt_card_pos [Nonempty n] : (0 : ℝ) < Real.sqrt (Fintype.card n) :=
  Real.sqrt_pos.mpr (by exact_mod_cast Fintype.card_pos)

/-- **ε–δ continuity on a set, measured in the order-unit norm on both sides.**  This is the
manuscript's form of a continuity hypothesis on the order-unit space, written without reference
to the carrier's own norm. -/
def ContinuousOnOu (f : HermitianMat n 𝕜 → HermitianMat n 𝕜)
    (s : Set (HermitianMat n 𝕜)) : Prop :=
  ∀ a₀ ∈ s, ∀ ε > 0, ∃ δ > 0, ∀ a ∈ s, ouNorm (a - a₀) < δ → ouNorm (f a - f a₀) < ε

/-- **THE BRIDGE.**  Order-unit-norm continuity on a set and `ContinuousOn` (the carried
Frobenius topology) are the same property.

Both directions are the sandwich `ouNorm ≤ ‖·‖ ≤ √(card n)·ouNorm` used once on each side of
the map: going to `ContinuousOn` one shrinks the target `ε` by `√(card n)`, and coming back one
shrinks the source `δ` by the same factor.  Nonemptiness of the index type is what makes the
factor positive (on an empty index type the carrier is a single point and both sides hold
trivially, but the rescaling argument would divide by zero). -/
theorem continuousOnOu_iff_continuousOn [Nonempty n]
    (f : HermitianMat n 𝕜 → HermitianMat n 𝕜) (s : Set (HermitianMat n 𝕜)) :
    ContinuousOnOu f s ↔ ContinuousOn f s := by
  have hCpos : (0 : ℝ) < Real.sqrt (Fintype.card n) := sqrt_card_pos
  -- `rw` cannot match here: `Metric.continuousOn_iff`'s `ContinuousOn` carries the pseudo-metric
  -- topology while the goal's carries `HermitianMat.instTopologicalSpace`. Compose the iff as a
  -- term, which elaborates at default transparency where the two agree.
  refine Iff.trans ?_ Metric.continuousOn_iff.symm
  constructor
  · intro h a₀ ha₀ ε hε
    obtain ⟨δ, hδ, hmain⟩ := h a₀ ha₀ (ε / Real.sqrt (Fintype.card n)) (div_pos hε hCpos)
    refine ⟨δ, hδ, fun a ha hd => ?_⟩
    rw [dist_eq_norm] at hd
    have h2 := hmain a ha (lt_of_le_of_lt (ouNorm_le_norm _) hd)
    rw [dist_eq_norm]
    calc ‖f a - f a₀‖
        ≤ Real.sqrt (Fintype.card n) * ouNorm (f a - f a₀) :=
          norm_le_sqrt_card_mul_ouNorm _
      _ < Real.sqrt (Fintype.card n) * (ε / Real.sqrt (Fintype.card n)) :=
          mul_lt_mul_of_pos_left h2 hCpos
      _ = ε := by field_simp
  · intro h a₀ ha₀ ε hε
    obtain ⟨δ, hδ, hmain⟩ := h a₀ ha₀ ε hε
    refine ⟨δ / Real.sqrt (Fintype.card n), div_pos hδ hCpos, fun a ha hd => ?_⟩
    have h1 : ‖a - a₀‖ < δ := by
      calc ‖a - a₀‖
          ≤ Real.sqrt (Fintype.card n) * ouNorm (a - a₀) := norm_le_sqrt_card_mul_ouNorm _
        _ < Real.sqrt (Fintype.card n) * (δ / Real.sqrt (Fintype.card n)) :=
            mul_lt_mul_of_pos_left hd hCpos
        _ = δ := by field_simp
    have h2 := hmain a ha (by rw [dist_eq_norm]; exact h1)
    rw [dist_eq_norm] at h2
    exact lt_of_le_of_lt (ouNorm_le_norm _) h2

end HermitianMat

namespace Necessity

open HermitianMat

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {𝕜 : Type*} [RCLike 𝕜]

/-- **The manuscript's S2, verbatim**: for each fixed effect `b`, the map `a ↦ a • b` is
continuous on the effects, with both distances measured in the ORDER-UNIT norm. -/
def FirstArgContinuousOu (P : SequentialProductOn (HermitianMat n 𝕜)) : Prop :=
  ∀ ⦃b : HermitianMat n 𝕜⦄, IsEffect b →
    HermitianMat.ContinuousOnOu (fun a => P.sp a b) {a : HermitianMat n 𝕜 | IsEffect a}

/-- **The paper's S2 and the tree's S2 are the same hypothesis.** -/
theorem firstArgContinuousOu_iff [Nonempty n] (P : SequentialProductOn (HermitianMat n 𝕜)) :
    FirstArgContinuousOu P ↔ P.FirstArgContinuous := by
  constructor
  · intro h b hb
    exact (continuousOnOu_iff_continuousOn _ _).mp (h hb)
  · intro h b hb
    exact (continuousOnOu_iff_continuousOn _ _).mpr (h hb)

/-- **The order-unit hypothesis is inhabited.**  M1's twist product satisfies it, so the
`_ouNorm` capstones below are not quantified over an empty class.  (That
`FirstArgContinuousOu` is also not *trivially* satisfied follows from the iff above: it is
equivalent to `ContinuousOn`, which no discontinuous map satisfies.) -/
theorem twistProductOn_firstArgContinuousOu [Nonempty n] (t : ℝ) :
    FirstArgContinuousOu (twistProductOn (n := n) t) :=
  (firstArgContinuousOu_iff _).mpr (twistProductOn_firstArgContinuous t)

/-! ## Both flagship rows, with the paper's S2 as the literal hypothesis -/

/-- **`mthm:master`, THE REAL ROW, with S2 in the order-unit norm.**  Identical to
`real_classification` except that the continuity hypothesis is the manuscript's own:
`a ↦ a • b` continuous on effects in `‖·‖_e`.  The product is the Lüders product on all
effects, with no twist parameter. -/
theorem real_classification_ouNorm {N : ℕ} (hN : 0 < N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℝ))
    (hS2 : FirstArgContinuousOu P)
    {b : HermitianMat (Fin N) ℝ} (hb : IsEffect b)
    (a : HermitianMat (Fin N) ℝ) (ha : IsEffect a) :
    P.sp a b = b.conj (a.cfc Real.sqrt).mat := by
  haveI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
  exact real_classification hN P ((firstArgContinuousOu_iff P).mp hS2) hb a ha

/-- **`mthm:master`, THE COMPLEX ROW, with S2 in the order-unit norm.**  Identical to
`complex_classification_unconditional` except that the continuity hypothesis is the
manuscript's own.  There is a unique real `t` with `a • b = a^{1/2+it} b a^{1/2−it}` on all
effects. -/
theorem complex_classification_unconditional_ouNorm {N : ℕ} (hN : 3 ≤ N)
    (P : SequentialProductOn (HermitianMat (Fin N) ℂ))
    (hS2 : FirstArgContinuousOu P) :
    ∃! t : ℝ, ∀ a b : HermitianMat (Fin N) ℂ, IsEffect a → IsEffect b →
      P.sp a b = HermitianMat.twistSeq t a b := by
  haveI : Nonempty (Fin N) := ⟨⟨0, by omega⟩⟩
  exact complex_classification_unconditional hN P ((firstArgContinuousOu_iff P).mp hS2)

end Necessity

/-! ## `lem:homog`(i) at order-unit generality (row 6)

The article's `lem:homog`(i): for each effect `a`, `L_a : b ↦ a·b` is additive by S1 and order
bounded, hence **extends uniquely to a positive linear map** `L_a : J → J`.  The tree already
had this on the matrix carrier (`Necessity.seqLeftMul`), where the difference representation is
`x = x⁺ − x⁻`; the article's is at order-unit generality, and the concrete route's `posPart` /
`negPart` are not available there.

They are not needed.  `SequentialProductOn.spConeRight` — the second-slot cone extension, already
in the tree and needing `IsArchimedean` but **no S2** — supplies the value on the cone, and the
splitting the article's own proof uses is available from the class's `archimedean` field alone:
for any `x` there is `r ≥ 0` with `−x ≤ r·𝟙`, so `x = (x + r·𝟙) − r·𝟙` is a difference of cone
elements.  `spConeRight_sub_congr` makes the value independent of that choice, and the rest is
the article's "extension by differences on `J = span eff(J)`".

`IsArchimedean` is the only ambient hypothesis.  This file's `OrderUnitSpace` class carries
order-unit *boundedness* in its `archimedean` field and the genuine Archimedean squeeze as the
separate `IsArchimedean` predicate, which `OrderUnitSpace.lean` records as part of the article's
own definition of an order unit space rather than a located stand-in — so a row proved under it
is at the article's generality.  Nothing about matrices enters, so this covers the article's
statement, whose ambient `J` is an EJA and hence an order unit space; that is exactly the
argument the manifest already accepts for clause (ii).
-/

namespace SequentialProductOn

variable {V : Type*} [OrderUnitSpace V] (P : SequentialProductOn V)

/-- A cone normalization is exactly an order-unit bound. -/
theorem le_smul_of_isConeNorm {v : V} {μ : ℝ} (h : IsConeNorm v μ) : v ≤ μ • (𝟙 : V) := by
  have h2 := h.2.2
  have := smul_nonneg_mono μ (le_of_lt h.1) h2
  rwa [smul_smul, mul_inv_cancel₀ (ne_of_gt h.1), one_smul] at this

/-- Conversely, an order-unit bound is a cone normalization. -/
theorem isConeNorm_of_le {v : V} (hv : (0 : V) ≤ v) {μ : ℝ} (hμ : 0 < μ)
    (h : v ≤ μ • (𝟙 : V)) : IsConeNorm v μ := by
  refine ⟨hμ, smul_nonneg' (le_of_lt (inv_pos.mpr hμ)) hv, ?_⟩
  have := smul_nonneg_mono μ⁻¹ (le_of_lt (inv_pos.mpr hμ)) h
  rwa [smul_smul, inv_mul_cancel₀ (ne_of_gt hμ), one_smul] at this

theorem spConeRight_zero (harch : IsArchimedean V) {a : V} (ha : IsEffect a) :
    P.spConeRight a 0 = 0 := by
  rw [spConeRight_eq P harch ha le_rfl (isConeNorm_one isEffect_zero), smul_zero,
    P.sp_zero_right ha, smul_zero]

theorem spConeRight_nonneg (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {v : V} (hv : (0 : V) ≤ v) : (0 : V) ≤ P.spConeRight a v := by
  obtain ⟨μ, hμ⟩ := exists_isConeNorm hv
  rw [spConeRight_eq P harch ha hv hμ]
  exact smul_nonneg' (le_of_lt hμ.1) (P.sp_nonneg ha hμ.2)

/-- **Positive homogeneity** of the second-slot cone extension. -/
theorem spConeRight_smul (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {v : V} (hv : (0 : V) ≤ v) {lam : ℝ} (hlam : 0 < lam) :
    P.spConeRight a (lam • v) = lam • P.spConeRight a v := by
  obtain ⟨μ, hμ⟩ := exists_isConeNorm hv
  have hlamv : (0 : V) ≤ lam • v := smul_nonneg' (le_of_lt hlam) hv
  rw [spConeRight_eq P harch ha hlamv (isConeNorm_smul hμ hlam),
    spConeRight_eq P harch ha hv hμ]
  rw [show (lam * μ)⁻¹ • lam • v = μ⁻¹ • v from by
    rw [smul_smul]; congr 1; field_simp]
  rw [smul_smul]

/-- **Additivity** of the second-slot cone extension: a common normalization dominating both
summands and their sum is supplied by adding the two individual ones. -/
theorem spConeRight_add (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {x y : V} (hx : (0 : V) ≤ x) (hy : (0 : V) ≤ y) :
    P.spConeRight a (x + y) = P.spConeRight a x + P.spConeRight a y := by
  obtain ⟨μx, hμx⟩ := exists_isConeNorm hx
  obtain ⟨μy, hμy⟩ := exists_isConeNorm hy
  set μ : ℝ := μx + μy with hμdef
  have hμ0 : 0 < μ := by simp only [hμdef]; linarith [hμx.1, hμy.1]
  have hxμ : x ≤ μ • (𝟙 : V) := by
    refine le_trans (le_smul_of_isConeNorm hμx) ?_
    exact smul_le_smul_of_le_of_nonneg (by simp only [hμdef]; linarith [hμy.1]) ousUnit_nonneg
  have hyμ : y ≤ μ • (𝟙 : V) := by
    refine le_trans (le_smul_of_isConeNorm hμy) ?_
    exact smul_le_smul_of_le_of_nonneg (by simp only [hμdef]; linarith [hμx.1]) ousUnit_nonneg
  have hxyμ : x + y ≤ μ • (𝟙 : V) := by
    calc x + y ≤ μx • (𝟙 : V) + μy • (𝟙 : V) := by
          refine le_trans (add_le_add_right' (le_smul_of_isConeNorm hμx) y) ?_
          exact add_le_add_left _ _ (le_smul_of_isConeNorm hμy) _
      _ = μ • (𝟙 : V) := by rw [← add_smul]
  have hcx : IsConeNorm x μ := isConeNorm_of_le hx hμ0 hxμ
  have hcy : IsConeNorm y μ := isConeNorm_of_le hy hμ0 hyμ
  have hcxy : IsConeNorm (x + y) μ :=
    isConeNorm_of_le (add_nonneg hx hy) hμ0 hxyμ
  have hsum_le : μ⁻¹ • x + μ⁻¹ • y ≤ (𝟙 : V) := by
    rw [← smul_add]
    exact hcxy.2.2
  rw [spConeRight_eq P harch ha (add_nonneg hx hy) hcxy, spConeRight_eq P harch ha hx hcx,
    spConeRight_eq P harch ha hy hcy, smul_add, P.sp_add_right ha hcx.2 hcy.2 hsum_le, smul_add]

/-- **Well-definedness over difference representations.** -/
theorem spConeRight_sub_congr (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {u v u' v' : V} (hu : (0 : V) ≤ u) (hv : (0 : V) ≤ v) (hu' : (0 : V) ≤ u')
    (hv' : (0 : V) ≤ v') (h : u - v = u' - v') :
    P.spConeRight a u - P.spConeRight a v = P.spConeRight a u' - P.spConeRight a v' := by
  have hsum : u + v' = u' + v := sub_eq_sub_iff_add_eq_add.mp h
  have h3 := congrArg (P.spConeRight a) hsum
  rw [spConeRight_add P harch ha hu hv', spConeRight_add P harch ha hu' hv] at h3
  exact sub_eq_sub_iff_add_eq_add.mpr h3

/-! ### The linear extension at order-unit generality (`lem:homog`(i)) -/

/-- An order-unit bound for `-x`, from the class's own `archimedean` field. -/
def negBound (x : V) : ℝ := Classical.choose (OrderUnitSpace.archimedean (-x))

theorem negBound_spec (x : V) : 0 ≤ negBound x ∧ -x ≤ negBound x • (𝟙 : V) :=
  Classical.choose_spec (OrderUnitSpace.archimedean (-x))

theorem add_negBound_nonneg (x : V) : (0 : V) ≤ x + negBound x • (𝟙 : V) := by
  have h := (negBound_spec x).2
  have h2 := OrderUnitSpace.add_le_add_left (-x) (negBound x • (𝟙 : V)) h x
  simpa using h2

theorem negBound_smul_nonneg (x : V) : (0 : V) ≤ negBound x • (𝟙 : V) :=
  OrderUnitSpace.smul_nonneg' (negBound_spec x).1 ousUnit_nonneg

/-- **`lem:homog`(i) at the article's own generality.**  The left multiplication of an unknown
product by an effect, extended from the effect interval to the whole order unit space, as a
real-linear map.  Only `IsArchimedean` is used; S2 is not. -/
def seqLeftMulAbs (harch : IsArchimedean V) {a : V} (ha : IsEffect a) : V →ₗ[ℝ] V where
  toFun x := P.spConeRight a (x + negBound x • 𝟙) - P.spConeRight a (negBound x • 𝟙)
  map_add' x y := by
    show P.spConeRight a ((x + y) + negBound (x + y) • 𝟙)
          - P.spConeRight a (negBound (x + y) • 𝟙)
        = (P.spConeRight a (x + negBound x • 𝟙) - P.spConeRight a (negBound x • 𝟙))
          + (P.spConeRight a (y + negBound y • 𝟙) - P.spConeRight a (negBound y • 𝟙))
    have hcomb := spConeRight_sub_congr P harch ha
      (add_nonneg (add_negBound_nonneg x) (add_negBound_nonneg y))
      (add_nonneg (negBound_smul_nonneg x) (negBound_smul_nonneg y))
      (add_negBound_nonneg (x + y)) (negBound_smul_nonneg (x + y)) (by abel)
    rw [← hcomb, spConeRight_add P harch ha (add_negBound_nonneg x) (add_negBound_nonneg y),
      spConeRight_add P harch ha (negBound_smul_nonneg x) (negBound_smul_nonneg y)]
    abel
  map_smul' t x := by
    show P.spConeRight a _ - P.spConeRight a _ = t • (P.spConeRight a _ - P.spConeRight a _)
    rcases lt_trichotomy t 0 with htneg | htzero | htpos
    · have hrep : (t • x) + negBound (t • x) • (𝟙 : V) - negBound (t • x) • 𝟙
          = (-t) • (negBound x • (𝟙 : V)) - (-t) • (x + negBound x • 𝟙) := by
        module
      rw [spConeRight_sub_congr P harch ha (add_negBound_nonneg (t • x))
        (negBound_smul_nonneg (t • x))
        (OrderUnitSpace.smul_nonneg' (by linarith) (negBound_smul_nonneg x))
        (OrderUnitSpace.smul_nonneg' (by linarith) (add_negBound_nonneg x)) hrep,
        spConeRight_smul P harch ha (negBound_smul_nonneg x) (by linarith : (0:ℝ) < -t),
        spConeRight_smul P harch ha (add_negBound_nonneg x) (by linarith : (0:ℝ) < -t)]
      simp only [RingHom.id_apply, neg_smul, smul_sub]
      abel
    · subst htzero
      have hrep : (0 : ℝ) • x + negBound ((0 : ℝ) • x) • (𝟙 : V)
            - negBound ((0 : ℝ) • x) • 𝟙
          = (0 : V) - 0 := by
        module
      rw [spConeRight_sub_congr P harch ha (add_negBound_nonneg ((0:ℝ) • x))
        (negBound_smul_nonneg ((0:ℝ) • x)) le_rfl le_rfl hrep,
        spConeRight_zero P harch ha]
      simp
    · have hrep : t • x + negBound (t • x) • (𝟙 : V) - negBound (t • x) • 𝟙
          = t • (x + negBound x • (𝟙 : V)) - t • (negBound x • 𝟙) := by
        module
      rw [spConeRight_sub_congr P harch ha (add_negBound_nonneg (t • x))
        (negBound_smul_nonneg (t • x))
        (OrderUnitSpace.smul_nonneg' (le_of_lt htpos) (add_negBound_nonneg x))
        (OrderUnitSpace.smul_nonneg' (le_of_lt htpos) (negBound_smul_nonneg x)) hrep,
        spConeRight_smul P harch ha (add_negBound_nonneg x) htpos,
        spConeRight_smul P harch ha (negBound_smul_nonneg x) htpos]
      simp only [RingHom.id_apply, smul_sub]

/-- The extension is computed by **any** difference representation in the cone. -/
theorem seqLeftMulAbs_eq (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {x u v : V} (hu : (0 : V) ≤ u) (hv : (0 : V) ≤ v) (h : x = u - v) :
    seqLeftMulAbs P harch ha x = P.spConeRight a u - P.spConeRight a v :=
  spConeRight_sub_congr P harch ha (add_negBound_nonneg x) (negBound_smul_nonneg x) hu hv
    (by rw [← h]; abel)

/-- On the cone it is the cone extension. -/
theorem seqLeftMulAbs_apply_nonneg (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {x : V} (hx : (0 : V) ≤ x) : seqLeftMulAbs P harch ha x = P.spConeRight a x := by
  rw [seqLeftMulAbs_eq P harch ha hx le_rfl (by abel), spConeRight_zero P harch ha, sub_zero]

/-- **Agreement on effects**: the extension restricts to `b ↦ P.sp a b`. -/
theorem seqLeftMulAbs_apply_effect (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {b : V} (hb : IsEffect b) : seqLeftMulAbs P harch ha b = P.sp a b := by
  rw [seqLeftMulAbs_apply_nonneg P harch ha hb.1, spConeRight_of_isEffect P harch ha hb]

/-- **Positivity** of the extension. -/
theorem seqLeftMulAbs_nonneg (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {x : V} (hx : (0 : V) ≤ x) : (0 : V) ≤ seqLeftMulAbs P harch ha x := by
  rw [seqLeftMulAbs_apply_nonneg P harch ha hx]
  exact spConeRight_nonneg P harch ha hx

/-- **Monotonicity** of the extension. -/
theorem seqLeftMulAbs_mono (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {x y : V} (h : x ≤ y) : seqLeftMulAbs P harch ha x ≤ seqLeftMulAbs P harch ha y := by
  have h2 := seqLeftMulAbs_nonneg P harch ha (sub_nonneg_of_le h)
  rw [map_sub] at h2
  exact le_of_sub_nonneg h2

/-- **The unit law**: the extension sends `𝟙` to `a`. -/
theorem seqLeftMulAbs_one (harch : IsArchimedean V) {a : V} (ha : IsEffect a) :
    seqLeftMulAbs P harch ha 𝟙 = a := by
  rw [seqLeftMulAbs_apply_effect P harch ha isEffect_unit]
  exact P.sp_unit_right ha

/-- **Uniqueness**: it is the *only* real-linear extension of `b ↦ P.sp a b`, because the
effects span (`lem:span`'s extensionality clause). -/
theorem seqLeftMulAbs_unique (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    (L : V →ₗ[ℝ] V) (hL : ∀ b : V, IsEffect b → L b = P.sp a b) :
    L = seqLeftMulAbs P harch ha :=
  linearMap_eq_of_eq_on_effects _ _
    (fun b hb => by rw [hL b hb, seqLeftMulAbs_apply_effect P harch ha hb])


end SequentialProductOn
