/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.OrthFamily
import Mathlib.Topology.MetricSpace.Sequences
import Mathlib.Analysis.Normed.Module.FiniteDimension

set_option linter.style.longLine false

/-!
# `lem:normality` at abstract order-unit-space generality

STATEMENT-MANIFEST row 9.  The article states: *on a f.d. order-unit space, any operation
satisfying S1 and S2 is normal in van de Wetering's sense: `b_k ↓ b ⇒ a·b_k ↓ a·b`, and
compatibility passes to order-infima.*

The row was previously carried on the concrete `HermitianMat n 𝕜` carrier
(`Necessity.sp_tendsto_of_tendsto`, `Necessity.compatible_of_tendsto`), where the convergence
clause came free from finite-dimensionality: S1 extends `b ↦ a·b` to a linear map, and a linear
map on a finite-dimensional normed space is automatically continuous.  Two things were left
open by that route and are supplied here — the article's **order-infimum** form, and the
article's own **abstract order-unit generality**.

## The finite-dimensionality hypothesis is not needed, and is not used

★★★ The concrete proof's route through "linear on a f.d. space, hence continuous" is not the
only one, and it is not the sharp one.  The map `x ↦ a·x` is **positive** and sends `𝟙` to
`a ≤ 𝟙`; those two facts alone force

  `ouNorm (a·x) ≤ ouNorm x`

(`ouNorm_seqLeftMulAbs_le`) — the extension is a **contraction for the order-unit norm**, on the
nose, with no dimension hypothesis anywhere.  Continuity is then `δ := ε`.  So the abstract
version proved here is *stronger* than the concrete one it replaces on two counts at once: it
drops finite-dimensionality, and it upgrades continuity to a Lipschitz constant of `1`.

★ This compounds the asymmetry the row's previous cell already recorded.  Second-argument
continuity does not use S2; here it does not use finite-dimensionality either.  What genuinely
needs S2 is the *compatibility* clause, because that one moves the **first** argument
(`compatible_of_tendstoOu`).  The two clauses are not two halves of one hypothesis set.

## Why `TendstoOu` and `FirstArgContinuousOu` rather than `Tendsto` and `ContinuousOn`

The `Norm` carried by an `OrderUnitSpace` comes from its `NormedAddCommGroup` parent and is
*independent structure*: it is not the order-unit norm, and on a general carrier nothing relates
the two.  `OrderUnitSpace.ContinuousOnOu` already exists for exactly this reason.  Convergence
here is therefore stated against `ouNorm` in ε–N form, matching it; on any carrier where the two
norms are equivalent (every one in this development) the notions coincide, and
`Necessity/OrderUnitS2.lean` carries that comparison where it is needed.

★ `SequentialProductOn.FirstArgContinuous` (paper S2) is stated with Mathlib's `ContinuousOn`,
i.e. in the *parent* norm.  `FirstArgContinuousOu` below is its order-unit-norm twin, and the
compatibility clause is proved against that one.  Conflating them would be a genuine error: they
are the same statement only modulo a norm comparison that no abstract order-unit space supplies.
-/

open OrderUnitSpace

namespace OrderUnitSpace

variable {V : Type*} [OrderUnitSpace V]

/-! ## Order-unit-norm toolkit

Four facts about `ouNorm` that the interface did not yet carry: it is symmetric under negation,
subadditive, separates points, and its bounds are two-sided.  All four are used below. -/

/-- Addition is monotone in both arguments.  The class carries `add_le_add_left` as a field and
no `OrderedAddCommGroup` instance, so the two-sided form is assembled by hand. -/
theorem add_le_add' {a b c d : V} (h1 : a ≤ b) (h2 : c ≤ d) : a + c ≤ b + d :=
  le_trans (add_le_add_right' h1 c) (OrderUnitSpace.add_le_add_left _ _ h2 b)

/-- The sandwiching scalars of `x` and of `-x` are the same: the two conjuncts of `ouBound`
simply exchange places. -/
theorem ouBound_neg (x : V) : ouBound (-x) = ouBound x := by
  ext t
  simp only [ouBound, Set.mem_ofPred_eq]
  constructor
  · rintro ⟨ht, h1, h2⟩
    exact ⟨ht, by simpa using neg_le_neg h2, by simpa using neg_le_neg h1⟩
  · rintro ⟨ht, h1, h2⟩
    exact ⟨ht, by simpa using neg_le_neg h2, by simpa using neg_le_neg h1⟩

/-- **The order-unit norm is symmetric under negation.** -/
theorem ouNorm_neg (x : V) : ouNorm (-x) = ouNorm x := by
  unfold ouNorm
  rw [ouBound_neg]

/-- **Subadditivity of the order-unit norm.**  Needs `IsArchimedean` only because it is proved
from the *attained* bounds; the inequality itself is elementary. -/
theorem ouNorm_add_le (harch : IsArchimedean V) (x y : V) :
    ouNorm (x + y) ≤ ouNorm x + ouNorm y := by
  obtain ⟨hx0, hx1, hx2⟩ := ouNorm_mem_ouBound harch x
  obtain ⟨hy0, hy1, hy2⟩ := ouNorm_mem_ouBound harch y
  refine ouNorm_le ⟨by linarith, ?_, ?_⟩
  · have h := add_le_add' hx1 hy1
    have he : -(ouNorm x • (𝟙 : V)) + -(ouNorm y • (𝟙 : V))
        = -((ouNorm x + ouNorm y) • (𝟙 : V)) := by
      rw [add_smul]; abel
    rwa [he] at h
  · have h := add_le_add' hx2 hy2
    have he : ouNorm x • (𝟙 : V) + ouNorm y • (𝟙 : V)
        = (ouNorm x + ouNorm y) • (𝟙 : V) := by
      rw [add_smul]
    rwa [he] at h

/-- **The order-unit norm separates points.**  `ouNorm x = 0` pins `0 ≤ x ≤ 0`, and the class's
order is a `PartialOrder`. -/
theorem eq_zero_of_ouNorm_eq_zero (harch : IsArchimedean V) {x : V} (h : ouNorm x = 0) :
    x = 0 := by
  obtain ⟨-, h1, h2⟩ := ouNorm_mem_ouBound harch x
  rw [h] at h1 h2
  simp only [zero_smul, neg_zero] at h1 h2
  exact le_antisymm h2 h1

/-! ## Convergence in the order-unit norm -/

/-- **Convergence in the order-unit norm**, in ε–N form.  See the module docstring for why this
is not Mathlib's `Tendsto` in the carried norm. -/
def TendstoOu (f : ℕ → V) (L : V) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N : ℕ, ∀ k : ℕ, N ≤ k → ouNorm (f k - L) < ε

/-- **The cone is closed for order-unit convergence**, in the form the infimum clause needs: a
lower bound of every term is a lower bound of the limit. -/
theorem le_of_tendstoOu (harch : IsArchimedean V) {f : ℕ → V} {L c : V}
    (hf : TendstoOu f L) (hc : ∀ k, c ≤ f k) : c ≤ L := by
  have key : c - L ≤ 0 := by
    refine harch _ fun ε hε => ?_
    obtain ⟨N, hN⟩ := hf ε hε
    refine le_trans (sub_le_sub_right' (hc N) L) (le_trans (ouNorm_mem_ouBound harch _).2.2 ?_)
    exact smul_le_smul_of_le_of_nonneg (le_of_lt (hN N le_rfl)) ousUnit_nonneg
  have h := add_le_add_right' key L
  rwa [sub_add_cancel, zero_add] at h

/-- The dual form: an eventual upper bound of the terms is an upper bound of the limit. -/
theorem tendstoOu_le (harch : IsArchimedean V) {f : ℕ → V} {L c : V}
    (hf : TendstoOu f L) (N₀ : ℕ) (hc : ∀ k, N₀ ≤ k → f k ≤ c) : L ≤ c := by
  have key : L - c ≤ 0 := by
    refine harch _ fun ε hε => ?_
    obtain ⟨N, hN⟩ := hf ε hε
    have hm : ouNorm (L - f (max N N₀)) < ε := by
      have hswap : ouNorm (L - f (max N N₀)) = ouNorm (f (max N N₀) - L) := by
        rw [← ouNorm_neg (f (max N N₀) - L)]; congr 1; abel
      rw [hswap]; exact hN _ (le_max_left N N₀)
    refine le_trans (sub_le_sub_left' (hc _ (le_max_right N N₀)) L)
      (le_trans (ouNorm_mem_ouBound harch _).2.2 ?_)
    exact smul_le_smul_of_le_of_nonneg (le_of_lt hm) ousUnit_nonneg
  have h := add_le_add_right' key c
  rwa [sub_add_cancel, zero_add] at h

/-- **Limits in the order-unit norm are unique** — the point-separation of `ouNorm` plus its
triangle inequality. -/
theorem eq_of_tendstoOu (harch : IsArchimedean V) {f : ℕ → V} {L L' : V}
    (h : TendstoOu f L) (h' : TendstoOu f L') : L = L' := by
  have key : ∀ ε : ℝ, 0 < ε → ouNorm (L - L') ≤ ε := by
    intro ε hε
    obtain ⟨N, hN⟩ := h (ε / 2) (by linarith)
    obtain ⟨N', hN'⟩ := h' (ε / 2) (by linarith)
    have hsplit : L - L' = (L - f (max N N')) + (f (max N N') - L') := by abel
    have htri := ouNorm_add_le harch (L - f (max N N')) (f (max N N') - L')
    rw [← hsplit] at htri
    have hswap : ouNorm (L - f (max N N')) = ouNorm (f (max N N') - L) := by
      rw [← ouNorm_neg (f (max N N') - L)]; congr 1; abel
    rw [hswap] at htri
    have h1 := hN _ (le_max_left N N')
    have h2 := hN' _ (le_max_right N N')
    linarith
  have hle : ouNorm (L - L') ≤ 0 := by
    by_contra hc
    push Not at hc
    have := key (ouNorm (L - L') / 2) (by linarith)
    linarith
  exact sub_eq_zero.mp
    (eq_zero_of_ouNorm_eq_zero harch (le_antisymm hle (ouNorm_nonneg _)))

/-- **A decreasing, order-unit-convergent sequence converges to its infimum.**  This is the
order-theoretic content the article's `↓` notation carries. -/
theorem isGLB_of_antitone_tendstoOu (harch : IsArchimedean V) {f : ℕ → V} {L : V}
    (hanti : Antitone f) (hf : TendstoOu f L) :
    IsGLB (Set.range f) L := by
  constructor
  · rintro _ ⟨m, rfl⟩
    exact tendstoOu_le harch hf m fun k hk => hanti hk
  · intro c hc
    exact le_of_tendstoOu harch hf fun k => hc ⟨k, rfl⟩


/-! ## Monotone convergence: from the article's `↓` to order-unit convergence

Everything above takes order-unit convergence as *input*.  The article writes `b_k ↓ b`, which
is the **order-theoretic** statement "decreasing with infimum `b`", so closing the row needs the
bridge from that to convergence.  ★ That bridge is exactly where the article's
finite-dimensionality hypothesis does its work, and it is the only place it is used. -/

/-- **The order-unit norm is monotone on the cone**: `0 ≤ x ≤ y` forces `ouNorm x ≤ ouNorm y`,
since any `t` sandwiching `y` sandwiches `x` too. -/
theorem ouNorm_mono_of_nonneg {x y : V} (hx : (0 : V) ≤ x) (hxy : x ≤ y) :
    ouNorm x ≤ ouNorm y := by
  refine le_csInf (ouBound_nonempty y) fun t ht => ?_
  refine ouNorm_le ⟨ht.1, le_trans ?_ hx, le_trans hxy ht.2.2⟩
  have h0 : (0 : V) ≤ t • (𝟙 : V) := OrderUnitSpace.smul_nonneg' ht.1 ousUnit_nonneg
  simpa using neg_le_neg h0

/-- Effects are exactly the elements of the unit ball that lie in the cone; in particular they
have order-unit norm at most one. -/
theorem ouNorm_le_one_of_isEffect {a : V} (ha : IsEffect a) : ouNorm a ≤ 1 := by
  refine ouNorm_le ⟨zero_le_one, le_trans ?_ ha.1, ?_⟩
  · have h0 : (0 : V) ≤ (1 : ℝ) • (𝟙 : V) := by rw [one_smul]; exact ousUnit_nonneg
    simpa using neg_le_neg h0
  · rw [one_smul]; exact ha.2

/-- **The order-unit norm is equivalent to the carried norm.**

★ The `OrderUnitSpace` class carries a `NormedAddCommGroup` parent whose norm is *independent
structure*: no field relates it to the order, so on a general carrier the two norms need not be
comparable at all.  ★★ **This is nevertheless a theorem and not a hypothesis** — see
`ouNormEquiv_of_finiteDimensional` below, which derives it from finite-dimensionality alone.
The predicate is kept as a named notion because it is what the proofs actually consume, not
because anything has to assume it. -/
def OuNormEquiv (V : Type*) [OrderUnitSpace V] : Prop :=
  (∃ C : ℝ, 0 < C ∧ ∀ x : V, ouNorm x ≤ C * ‖x‖) ∧ (∃ D : ℝ, 0 < D ∧ ∀ x : V, ‖x‖ ≤ D * ouNorm x)


/-! ### `OuNormEquiv` is a theorem, not a hypothesis

★★★ The order-unit norm really is a norm — positive-definite (`eq_zero_of_ouNorm_eq_zero`),
subadditive (`ouNorm_add_le`) and absolutely homogeneous (`ouNorm_smul`) — so on a
finite-dimensional space it is equivalent to the carried norm for the ordinary reason that any
two norms on a finite-dimensional real vector space are.  That is proved here rather than
assumed, which removes `OuNormEquiv` from the hypotheses of everything downstream.

The two directions are the two halves of the classical argument.  The easy one expands in a
basis and uses subadditivity; the hard one uses the first to get continuity of `ouNorm`, then
minimises it over the (compact) carried-norm unit sphere. -/

theorem ouNorm_zero : ouNorm (0 : V) = (0 : ℝ) :=
  le_antisymm (ouNorm_le ⟨le_rfl, by simp, by simp⟩) (ouNorm_nonneg _)

theorem ouNorm_smul_le_of_nonneg (harch : IsArchimedean V) {r : ℝ} (hr : 0 ≤ r) (x : V) :
    ouNorm (r • x) ≤ r * ouNorm x := by
  obtain ⟨h0, h1, h2⟩ := ouNorm_mem_ouBound harch x
  refine ouNorm_le ⟨by positivity, ?_, ?_⟩
  · have h := OrderUnitSpace.smul_nonneg_mono r hr h1
    have he : r • (-(ouNorm x • (𝟙 : V))) = -((r * ouNorm x) • (𝟙 : V)) := by
      rw [smul_neg, smul_smul]
    rwa [he] at h
  · have h := OrderUnitSpace.smul_nonneg_mono r hr h2
    have he : r • (ouNorm x • (𝟙 : V)) = (r * ouNorm x) • (𝟙 : V) := by rw [smul_smul]
    rwa [he] at h

theorem ouNorm_smul_of_pos (harch : IsArchimedean V) {r : ℝ} (hr : 0 < r) (x : V) :
    ouNorm (r • x) = r * ouNorm x := by
  refine le_antisymm (ouNorm_smul_le_of_nonneg harch hr.le x) ?_
  have h := ouNorm_smul_le_of_nonneg harch (inv_nonneg.mpr hr.le) (r • x)
  rw [smul_smul, inv_mul_cancel₀ hr.ne', one_smul] at h
  calc r * ouNorm x ≤ r * (r⁻¹ * ouNorm (r • x)) := mul_le_mul_of_nonneg_left h hr.le
    _ = ouNorm (r • x) := by field_simp

/-- **Absolute homogeneity of the order-unit norm.** -/
theorem ouNorm_smul (harch : IsArchimedean V) (r : ℝ) (x : V) :
    ouNorm (r • x) = |r| * ouNorm x := by
  rcases lt_trichotomy r 0 with hneg | hzero | hpos
  · have hrw : r • x = -((-r) • x) := by module
    rw [hrw, ouNorm_neg, abs_of_neg hneg]
    exact ouNorm_smul_of_pos harch (by linarith) x
  · subst hzero; simp [ouNorm_zero]
  · rw [abs_of_pos hpos]; exact ouNorm_smul_of_pos harch hpos x

/-- **Reverse triangle inequality** for the order-unit norm. -/
theorem abs_ouNorm_sub_le (harch : IsArchimedean V) (x y : V) :
    |ouNorm x - ouNorm y| ≤ ouNorm (x - y) := by
  have hswap : ouNorm (y - x) = ouNorm (x - y) := by
    rw [← ouNorm_neg (x - y)]; congr 1; abel
  have h1 : ouNorm x ≤ ouNorm (x - y) + ouNorm y := by
    have h := ouNorm_add_le harch (x - y) y; rwa [sub_add_cancel] at h
  have h2 : ouNorm y ≤ ouNorm (x - y) + ouNorm x := by
    have h := ouNorm_add_le harch (y - x) x
    rw [sub_add_cancel, hswap] at h; exact h
  rw [abs_le]; constructor <;> linarith

/-- **Finite subadditivity** of the order-unit norm. -/
theorem ouNorm_sum_le (harch : IsArchimedean V) {ι : Type*} (s : Finset ι) (f : ι → V) :
    ouNorm (∑ i ∈ s, f i) ≤ ∑ i ∈ s, ouNorm (f i) := by
  classical
  refine Finset.induction_on s ?_ ?_
  · simp [ouNorm_zero]
  · intro a t ha ih
    rw [Finset.sum_insert ha, Finset.sum_insert ha]
    exact le_trans (ouNorm_add_le harch _ _) (by linarith)

/-- **The easy direction of norm equivalence**: expand in a basis, apply subadditivity and
homogeneity, and bound each coordinate by the (continuous) coordinate functional. -/
theorem exists_ouNorm_le_norm (harch : IsArchimedean V) [FiniteDimensional ℝ V] :
    ∃ C : ℝ, 0 < C ∧ ∀ x : V, ouNorm x ≤ C * ‖x‖ := by
  classical
  set bas := Module.finBasis ℝ V with hbas
  set K := ‖bas.equivFunL.toContinuousLinearMap‖ with hKdef
  set S := ∑ i, ouNorm (bas i) with hSdef
  have hK0 : 0 ≤ K := norm_nonneg _
  have hS0 : 0 ≤ S := Finset.sum_nonneg fun i _ => ouNorm_nonneg _
  refine ⟨K * S + 1, by positivity, fun x => ?_⟩
  have hcoord : ∀ i, |bas.repr x i| ≤ K * ‖x‖ := by
    intro i
    have h1 : |bas.repr x i| ≤ ‖bas.equivFunL x‖ := by
      have h := norm_le_pi_norm (bas.equivFunL x) i
      simpa [Real.norm_eq_abs] using h
    have h2 : ‖bas.equivFunL x‖ ≤ K * ‖x‖ := by
      simpa [hKdef] using bas.equivFunL.toContinuousLinearMap.le_opNorm x
    exact le_trans h1 h2
  calc ouNorm x = ouNorm (∑ i, bas.repr x i • bas i) := by rw [bas.sum_repr]
    _ ≤ ∑ i, ouNorm (bas.repr x i • bas i) := ouNorm_sum_le harch _ _
    _ = ∑ i, |bas.repr x i| * ouNorm (bas i) :=
        Finset.sum_congr rfl fun i _ => ouNorm_smul harch _ _
    _ ≤ ∑ i, (K * ‖x‖) * ouNorm (bas i) :=
        Finset.sum_le_sum fun i _ => mul_le_mul_of_nonneg_right (hcoord i) (ouNorm_nonneg _)
    _ = (K * ‖x‖) * S := by rw [← Finset.mul_sum]
    _ ≤ (K * S + 1) * ‖x‖ := by nlinarith [norm_nonneg x]

/-- The order-unit norm is continuous for the carried norm — the easy direction, in ε–δ form. -/
theorem continuous_ouNorm (harch : IsArchimedean V) [FiniteDimensional ℝ V] :
    Continuous (fun x : V => ouNorm x) := by
  obtain ⟨C, hC, hCle⟩ := exists_ouNorm_le_norm harch
  rw [Metric.continuous_iff]
  intro b ε hε
  refine ⟨ε / C, by positivity, fun a hab => ?_⟩
  rw [Real.dist_eq]
  rw [dist_eq_norm] at hab
  calc |ouNorm a - ouNorm b| ≤ ouNorm (a - b) := abs_ouNorm_sub_le harch a b
    _ ≤ C * ‖a - b‖ := hCle _
    _ < C * (ε / C) := mul_lt_mul_of_pos_left hab hC
    _ = ε := by field_simp

/-- **The hard direction of norm equivalence**: `ouNorm` is continuous and strictly positive on
the compact carried-norm unit sphere, so it has a positive minimum there. -/
theorem exists_norm_le_ouNorm (harch : IsArchimedean V) [FiniteDimensional ℝ V] :
    ∃ D : ℝ, 0 < D ∧ ∀ x : V, ‖x‖ ≤ D * ouNorm x := by
  have hcont := continuous_ouNorm harch (V := V)
  rcases subsingleton_or_nontrivial V with hsub | hnt
  · exact ⟨1, one_pos, fun x => by
      have hx : x = 0 := Subsingleton.elim _ _
      simp [hx, ouNorm_zero]⟩
  · obtain ⟨z, hz, hmin⟩ :=
      (isCompact_sphere (0 : V) 1).exists_isMinOn
        (NormedSpace.sphere_nonempty.mpr zero_le_one) hcont.continuousOn
    have hz1 : ‖z‖ = 1 := mem_sphere_zero_iff_norm.mp hz
    have hm : 0 < ouNorm z := by
      rcases (ouNorm_nonneg z).lt_or_eq with h | h
      · exact h
      · exfalso
        have hz0 : z = 0 := eq_zero_of_ouNorm_eq_zero harch h.symm
        rw [hz0, norm_zero] at hz1
        norm_num at hz1
    refine ⟨(ouNorm z)⁻¹, by positivity, fun x => ?_⟩
    rcases eq_or_ne x 0 with rfl | hx
    · simp [ouNorm_zero]
    · have hxpos : 0 < ‖x‖ := norm_pos_iff.mpr hx
      have hmem : ‖x‖⁻¹ • x ∈ Metric.sphere (0 : V) 1 := by
        rw [mem_sphere_zero_iff_norm, norm_smul, norm_inv, norm_norm]
        field_simp
      have hle := (isMinOn_iff.mp hmin) _ hmem
      rw [ouNorm_smul harch, abs_of_pos (inv_pos.mpr hxpos)] at hle
      have h3 : ‖x‖ * ouNorm z ≤ ouNorm x := by
        calc ‖x‖ * ouNorm z ≤ ‖x‖ * (‖x‖⁻¹ * ouNorm x) :=
              mul_le_mul_of_nonneg_left hle hxpos.le
          _ = ouNorm x := by field_simp
      rw [inv_mul_eq_div, le_div_iff₀ hm]
      linarith

/-- ★★★ **Norm equivalence, proved.**  Every finite-dimensional Archimedean order-unit space
satisfies `OuNormEquiv`, so nothing downstream has to hypothesise it. -/
theorem ouNormEquiv_of_finiteDimensional (harch : IsArchimedean V) [FiniteDimensional ℝ V] :
    OuNormEquiv V :=
  ⟨exists_ouNorm_le_norm harch, exists_norm_le_ouNorm harch⟩

/-- An antitone sequence is bounded below by any limit of a subsequence. -/
theorem le_of_antitone_subseq (harch : IsArchimedean V) {b : ℕ → V} {L : V}
    (hanti : Antitone b) {φ : ℕ → ℕ} (hφ : StrictMono φ) (hsub : TendstoOu (b ∘ φ) L) (m : ℕ) :
    L ≤ b m :=
  tendstoOu_le harch hsub m fun _ hk => hanti (le_trans hk hφ.le_apply)

/-- **An antitone sequence with a convergent subsequence converges.**  The tail is squeezed
between the limit and the subsequence term by monotonicity of `ouNorm` on the cone. -/
theorem tendstoOu_of_antitone_of_subseq (harch : IsArchimedean V) {b : ℕ → V} {L : V}
    (hanti : Antitone b) {φ : ℕ → ℕ} (hφ : StrictMono φ) (hsub : TendstoOu (b ∘ φ) L) :
    TendstoOu b L := by
  intro ε hε
  obtain ⟨N, hN⟩ := hsub ε hε
  refine ⟨φ N, fun k hk => ?_⟩
  have h1 : (0 : V) ≤ b k - L := sub_nonneg_of_le (le_of_antitone_subseq harch hanti hφ hsub k)
  have h2 : b k - L ≤ b (φ N) - L := sub_le_sub_right' (hanti hk) L
  exact lt_of_le_of_lt (ouNorm_mono_of_nonneg h1 h2) (hN N le_rfl)

/-- ★★★ **Monotone convergence in a finite-dimensional order-unit space**: a decreasing sequence
of effects converges, in the order-unit norm, to its greatest lower bound.

This is the input the article's `b_k ↓ b` supplies and the tree did not carry.  The proof is the
classical one, and finite-dimensionality enters exactly once: the sequence is norm-bounded, so
properness gives a convergent subsequence, and antitonicity upgrades that to convergence of the
whole sequence.  Uniqueness of greatest lower bounds then identifies the limit. -/
theorem tendstoOu_of_antitone_isGLB (harch : IsArchimedean V) [FiniteDimensional ℝ V]
    {b : ℕ → V} {blim : V}
    (hb : ∀ k, IsEffect (b k)) (hanti : Antitone b) (hglb : IsGLB (Set.range b) blim) :
    TendstoOu b blim := by
  obtain ⟨⟨C, hC, hCle⟩, ⟨D, hD, hDle⟩⟩ := ouNormEquiv_of_finiteDimensional harch (V := V)
  have hmem : ∀ k, b k ∈ Metric.closedBall (0 : V) D := by
    intro k
    rw [Metric.mem_closedBall, dist_zero_right]
    refine le_trans (hDle (b k)) ?_
    nlinarith [ouNorm_le_one_of_isEffect (hb k), ouNorm_nonneg (b k)]
  obtain ⟨L, -, φ, hφ, hconv⟩ :=
    tendsto_subseq_of_bounded (Metric.isBounded_closedBall) hmem
  have hsub : TendstoOu (b ∘ φ) L := by
    intro ε hε
    rw [Metric.tendsto_atTop] at hconv
    obtain ⟨N, hN⟩ := hconv (ε / C) (by positivity)
    refine ⟨N, fun k hk => ?_⟩
    have h1 : ‖(b ∘ φ) k - L‖ < ε / C := by
      have := hN k hk; rwa [dist_eq_norm] at this
    calc ouNorm ((b ∘ φ) k - L) ≤ C * ‖(b ∘ φ) k - L‖ := hCle _
      _ < C * (ε / C) := by exact mul_lt_mul_of_pos_left h1 hC
      _ = ε := by field_simp
  have hfull : TendstoOu b L := tendstoOu_of_antitone_of_subseq harch hanti hφ hsub
  rwa [(isGLB_of_antitone_tendstoOu harch hanti hfull).unique hglb] at hfull


/-- ★★ **In finite dimensions the two continuity notions agree.**  `ContinuousOnOu` is stated
against `ouNorm` and Mathlib's `ContinuousOn` against the carried norm; norm equivalence makes
them interchangeable, so nothing downstream has to choose between them. -/
theorem continuousOnOu_iff_continuousOn (harch : IsArchimedean V) [FiniteDimensional ℝ V]
    (f : V → V) (s : Set V) : ContinuousOnOu f s ↔ ContinuousOn f s := by
  obtain ⟨⟨C, hC, hCle⟩, ⟨D, hD, hDle⟩⟩ := ouNormEquiv_of_finiteDimensional harch (V := V)
  rw [Metric.continuousOn_iff]
  constructor
  · intro h b hb ε hε
    obtain ⟨δ, hδ, hmain⟩ := h b hb (ε / D) (by positivity)
    refine ⟨δ / C, by positivity, fun a ha hab => ?_⟩
    rw [dist_eq_norm] at hab
    have h1 : ouNorm (a - b) < δ :=
      calc ouNorm (a - b) ≤ C * ‖a - b‖ := hCle _
        _ < C * (δ / C) := mul_lt_mul_of_pos_left hab hC
        _ = δ := by field_simp
    have h2 := hmain a ha h1
    rw [dist_eq_norm]
    calc ‖f a - f b‖ ≤ D * ouNorm (f a - f b) := hDle _
      _ < D * (ε / D) := mul_lt_mul_of_pos_left h2 hD
      _ = ε := by field_simp
  · intro h a₀ ha₀ ε hε
    obtain ⟨δ, hδ, hmain⟩ := h a₀ ha₀ (ε / C) (by positivity)
    refine ⟨δ / D, by positivity, fun a ha hd => ?_⟩
    have h1 : dist a a₀ < δ := by
      rw [dist_eq_norm]
      calc ‖a - a₀‖ ≤ D * ouNorm (a - a₀) := hDle _
        _ < D * (δ / D) := mul_lt_mul_of_pos_left hd hD
        _ = δ := by field_simp
    have h2 := hmain a ha h1
    rw [dist_eq_norm] at h2
    calc ouNorm (f a - f a₀) ≤ C * ‖f a - f a₀‖ := hCle _
      _ < C * (ε / C) := mul_lt_mul_of_pos_left h2 hC
      _ = ε := by field_simp

end OrderUnitSpace

namespace SequentialProductOn

variable {V : Type*} [OrderUnitSpace V] (P : SequentialProductOn V)

/-! ## The contraction property, and second-argument continuity

`seqLeftMulAbs P harch ha` is `Necessity/OrderUnitS2.lean`'s S1-only linear extension of
`b ↦ a·b` off the effect interval.  Everything in this section is about that map. -/

/-- ★★★ **Left multiplication by an effect is a contraction for the order-unit norm.**

The whole proof is two applications of monotonicity together with `L 𝟙 = a ≤ 𝟙`: if
`-t•𝟙 ≤ x ≤ t•𝟙` then `-t•𝟙 ≤ -t•a ≤ L x ≤ t•a ≤ t•𝟙`, so every scalar sandwiching `x`
sandwiches `L x`.  Taking infima gives the claim.

**No finite-dimensionality, and no S2.**  This replaces — and strictly strengthens — the
concrete carrier's "a linear map on a f.d. normed space is continuous". -/
theorem ouNorm_seqLeftMulAbs_le (harch : IsArchimedean V) {a : V} (ha : IsEffect a) (x : V) :
    ouNorm (seqLeftMulAbs P harch ha x) ≤ ouNorm x := by
  refine le_csInf (ouBound_nonempty x) fun t ht => ?_
  have hta : t • a ≤ t • (𝟙 : V) := OrderUnitSpace.smul_nonneg_mono t ht.1 ha.2
  refine ouNorm_le ⟨ht.1, ?_, ?_⟩
  · have hmono := seqLeftMulAbs_mono P harch ha ht.2.1
    have hval : seqLeftMulAbs P harch ha (-(t • 𝟙)) = -(t • a) := by
      rw [map_neg, map_smul, seqLeftMulAbs_one]
    rw [hval] at hmono
    exact le_trans (neg_le_neg hta) hmono
  · have hmono := seqLeftMulAbs_mono P harch ha ht.2.2
    have hval : seqLeftMulAbs P harch ha (t • 𝟙) = t • a := by
      rw [map_smul, seqLeftMulAbs_one]
    rw [hval] at hmono
    exact le_trans hmono hta

/-- The contraction property in difference form: left multiplication is `1`-Lipschitz. -/
theorem ouNorm_seqLeftMulAbs_sub_le (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    (x y : V) :
    ouNorm (seqLeftMulAbs P harch ha x - seqLeftMulAbs P harch ha y) ≤ ouNorm (x - y) := by
  rw [← map_sub]
  exact ouNorm_seqLeftMulAbs_le P harch ha _

/-- **Order-unit continuity of left multiplication, on every set at once**, with `δ := ε`. -/
theorem seqLeftMulAbs_continuousOnOu (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    (s : Set V) : ContinuousOnOu (fun x => seqLeftMulAbs P harch ha x) s := by
  intro x₀ _ ε hε
  exact ⟨ε, hε, fun x _ hd => lt_of_le_of_lt (ouNorm_seqLeftMulAbs_sub_le P harch ha x x₀) hd⟩

/-- **`lem:normality`, second-argument continuity clause, at abstract generality.**  The map
`b ↦ a·b` is order-unit continuous on the effects.  S1 only. -/
theorem sp_continuousOnOu_right (harch : IsArchimedean V) {a : V} (ha : IsEffect a) :
    ContinuousOnOu (fun b => P.sp a b) {b : V | IsEffect b} :=
  ContinuousOnOu.congr (seqLeftMulAbs_continuousOnOu P harch ha _)
    fun _b hb => seqLeftMulAbs_apply_effect P harch ha hb

/-- **`lem:normality`, convergence clause, at abstract generality**: `b_k → b` implies
`a·b_k → a·b`, in the order-unit norm.  S1 only. -/
theorem sp_tendstoOu (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {b : ℕ → V} {blim : V} (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim)
    (hconv : TendstoOu b blim) :
    TendstoOu (fun k => P.sp a (b k)) (P.sp a blim) := by
  intro ε hε
  obtain ⟨N, hN⟩ := hconv ε hε
  refine ⟨N, fun k hk => ?_⟩
  have hrw : P.sp a (b k) - P.sp a blim = seqLeftMulAbs P harch ha (b k - blim) := by
    rw [map_sub, seqLeftMulAbs_apply_effect P harch ha (hb k),
      seqLeftMulAbs_apply_effect P harch ha hblim]
  change ouNorm (P.sp a (b k) - P.sp a blim) < ε
  rw [hrw]
  exact lt_of_le_of_lt (ouNorm_seqLeftMulAbs_le P harch ha _) (hN k hk)

/-- ★★★ **`lem:normality`, the article's order-infimum form, at abstract generality.**

`b_k ↓ b ⇒ a·b_k ↓ a·b`: if the effects `b k` decrease and converge to `blim` in the order-unit
norm, then `a·blim` is the **greatest lower bound** of the `a·b k`.

This is the clause the row carried as open — the concrete carrier proved only the sequential
form.  Monotonicity supplies that `a·blim` is *a* lower bound; the contraction property plus
Archimedean closedness of the cone supplies that it is the *greatest* one.  S1 only. -/
theorem sp_isGLB (harch : IsArchimedean V) {a : V} (ha : IsEffect a)
    {b : ℕ → V} {blim : V} (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim)
    (hanti : Antitone b) (hconv : TendstoOu b blim) :
    IsGLB (Set.range fun k => P.sp a (b k)) (P.sp a blim) :=
  isGLB_of_antitone_tendstoOu harch
    (fun _ _ hjk => P.sp_mono_right ha (hb _) (hb _) (hanti hjk))
    (sp_tendstoOu P harch ha hb hblim hconv)

/-! ## The compatibility clause, and where S2 actually enters -/

/-- **Paper S2 in the order-unit norm.**  The twin of `SequentialProductOn.FirstArgContinuous`,
which is stated in the carried `NormedAddCommGroup` norm; see the module docstring on why the
two are not interchangeable at this generality. -/
def FirstArgContinuousOu (P : SequentialProductOn V) : Prop :=
  ∀ ⦃b : V⦄, IsEffect b → ContinuousOnOu (fun a : V => P.sp a b) {a : V | IsEffect a}

/-- ★★ **`lem:normality`, compatibility clause, at abstract generality**: compatibility passes
to order-unit limits.

★ **This is the clause that needs S2, and the convergence clause did not.**  The two sequences
`a·b_k` and `b_k·a` are equal termwise by hypothesis, but they converge for different reasons:
the left one by the contraction property above (S1, free), the right one only because S2 makes
the *first* argument continuous.  A reader who carried "S2 is not used" forward from
`sp_tendstoOu` to here would be wrong. -/
theorem compatible_of_tendstoOu (harch : IsArchimedean V) (hS2 : P.FirstArgContinuousOu)
    {a : V} (ha : IsEffect a) {b : ℕ → V} {blim : V}
    (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim) (hconv : TendstoOu b blim)
    (hcomp : ∀ k, P.sp a (b k) = P.sp (b k) a) :
    P.sp a blim = P.sp blim a := by
  have hL : TendstoOu (fun k => P.sp a (b k)) (P.sp a blim) :=
    sp_tendstoOu P harch ha hb hblim hconv
  have hR : TendstoOu (fun k => P.sp a (b k)) (P.sp blim a) := by
    intro ε hε
    obtain ⟨δ, hδ, hmain⟩ := hS2 ha blim hblim ε hε
    obtain ⟨N, hN⟩ := hconv δ hδ
    refine ⟨N, fun k hk => ?_⟩
    change ouNorm (P.sp a (b k) - P.sp blim a) < ε
    rw [hcomp k]
    exact hmain (b k) (hb k) (hN k hk)
  exact eq_of_tendstoOu harch hL hR


/-! ## `lem:normality`, the article's statement -/

/-- ★★★ **`lem:normality`, exactly as the article states it.**

*`b_k ↓ b ⇒ a·b_k ↓ a·b`*: for a decreasing sequence of effects with greatest lower bound `blim`,
the images `a·b_k` decrease with greatest lower bound `a·blim`.  Both `↓`s are the article's
order-theoretic ones — `IsGLB` in, `IsGLB` out — with no convergence hypothesis anywhere in the
statement.

★ The row's standing gap was precisely that the tree proved only the *sequential* form, with
convergence as an input.  `tendstoOu_of_antitone_isGLB` supplies the missing bridge, and it is
the only step that uses finite-dimensionality. -/
theorem sp_isGLB_of_isGLB (harch : IsArchimedean V) [FiniteDimensional ℝ V]
    {a : V} (ha : IsEffect a) {b : ℕ → V} {blim : V}
    (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim) (hanti : Antitone b)
    (hglb : IsGLB (Set.range b) blim) :
    IsGLB (Set.range fun k => P.sp a (b k)) (P.sp a blim) :=
  sp_isGLB P harch ha hb hblim hanti (tendstoOu_of_antitone_isGLB harch hb hanti hglb)

/-- ★★ **`lem:normality`, second half: compatibility passes to order-infima.**

If `a` is compatible with every term of a decreasing sequence of effects, it is compatible with
their greatest lower bound.  ★ As at `compatible_of_tendstoOu`, this is the clause that consumes
S2; the infimum clause above does not. -/
theorem compatible_of_isGLB (harch : IsArchimedean V) [FiniteDimensional ℝ V]
    (hS2 : P.FirstArgContinuousOu) {a : V} (ha : IsEffect a)
    {b : ℕ → V} {blim : V} (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim)
    (hanti : Antitone b) (hglb : IsGLB (Set.range b) blim)
    (hcomp : ∀ k, P.sp a (b k) = P.sp (b k) a) :
    P.sp a blim = P.sp blim a :=
  compatible_of_tendstoOu P harch hS2 ha hb hblim
    (tendstoOu_of_antitone_isGLB harch hb hanti hglb) hcomp


/-- ★★ **Paper S2 and its order-unit twin coincide in finite dimensions.** -/
theorem firstArgContinuousOu_iff_firstArgContinuous (harch : IsArchimedean V)
    [FiniteDimensional ℝ V] : P.FirstArgContinuousOu ↔ P.FirstArgContinuous :=
  ⟨fun h _ hb => (continuousOnOu_iff_continuousOn harch _ _).mp (h hb),
   fun h _ hb => (continuousOnOu_iff_continuousOn harch _ _).mpr (h hb)⟩

/-- ★★★ **`lem:normality`, compatibility clause, stated with the paper's own S2.**

Identical to `compatible_of_isGLB` except that the hypothesis is
`SequentialProductOn.FirstArgContinuous` — paper S2 exactly as the tree declares it — rather
than its order-unit twin.  With this the row's article sentence is proved verbatim: S1 and S2
in, normality out. -/
theorem compatible_of_isGLB_of_firstArgContinuous (harch : IsArchimedean V)
    [FiniteDimensional ℝ V] (hS2 : P.FirstArgContinuous) {a : V} (ha : IsEffect a)
    {b : ℕ → V} {blim : V} (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim)
    (hanti : Antitone b) (hglb : IsGLB (Set.range b) blim)
    (hcomp : ∀ k, P.sp a (b k) = P.sp (b k) a) :
    P.sp a blim = P.sp blim a :=
  compatible_of_isGLB P harch
    ((firstArgContinuousOu_iff_firstArgContinuous P harch).mpr hS2) ha hb hblim hanti hglb hcomp

end SequentialProductOn

/-! ## van de Wetering's hypothesis package: a convex σ-sequential effect algebra

★★★ vdW's Theorem A.6 says the standard product makes the effects of a f.d. EJA a *convex
σ-sequential effect algebra*, hence a *sequential effect space*.  Unpacked into this tree's own
vocabulary that is exactly three things about a `P : SequentialProductOn V`: the S1, S3–S7
structure it already is, paper S2, normality in the `↓`-sense, and convexity of the effect
interval.  ★ "hence an SES" is vdW's *name* for a convex σ-SEA on an order-unit space, not an
additional assertion, so nothing further is claimed by it here. -/

/-- **vdW's convex σ-sequential effect algebra**, for a sequential product on a fixed order-unit
space: paper S2, normality, and convexity of the effects.  The S1, S3–S7 half is the type of `P`
itself. -/
structure IsConvexSigmaSEA {V : Type*} [OrderUnitSpace V] (P : SequentialProductOn V) : Prop where
  /-- Paper S2: continuity in the first argument. -/
  s2 : P.FirstArgContinuousOu
  /-- The `σ` half: `b_k ↓ b ⇒ a·b_k ↓ a·b`. -/
  normal : ∀ {a : V}, IsEffect a → ∀ {b : ℕ → V} {blim : V}, (∀ k, IsEffect (b k)) →
    IsEffect blim → Antitone b → IsGLB (Set.range b) blim →
    IsGLB (Set.range fun k => P.sp a (b k)) (P.sp a blim)
  /-- Convexity of the effect interval. -/
  convex : ∀ {a b : V}, IsEffect a → IsEffect b → ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
    IsEffect (t • a + (1 - t) • b)

/-- The effect interval of any order-unit space is convex. -/
theorem isEffect_convexCombo {V : Type*} [OrderUnitSpace V] {a b : V}
    (ha : IsEffect a) (hb : IsEffect b) (t : ℝ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    IsEffect (t • a + (1 - t) • b) := by
  have h1t : (0 : ℝ) ≤ 1 - t := by linarith
  refine ⟨add_nonneg (smul_nonneg' ht0 ha.1) (smul_nonneg' h1t hb.1), ?_⟩
  have hle : t • a + (1 - t) • b ≤ t • (𝟙 : V) + (1 - t) • (𝟙 : V) :=
    add_le_add' (OrderUnitSpace.smul_nonneg_mono t ht0 ha.2)
      (OrderUnitSpace.smul_nonneg_mono (1 - t) h1t hb.2)
  have heq : t • (𝟙 : V) + (1 - t) • (𝟙 : V) = (𝟙 : V) := by
    rw [← add_smul]; norm_num
  rwa [heq] at hle

/-- **Any `SequentialProductOn` on a f.d. Archimedean order-unit space with S2 is a convex
σ-SEA.**  Normality is `sp_isGLB_of_isGLB`; convexity is `isEffect_convexCombo`; S2 is the
hypothesis. -/
theorem isConvexSigmaSEA_of_firstArgContinuousOu {V : Type*} [OrderUnitSpace V]
    [FiniteDimensional ℝ V] (P : SequentialProductOn V) (harch : IsArchimedean V)
    (hS2 : P.FirstArgContinuousOu) : IsConvexSigmaSEA P := by
  refine { s2 := hS2, normal := ?_, convex := ?_ }
  · intro a ha b blim hb hblim hanti hglb
    exact P.sp_isGLB_of_isGLB harch ha hb hblim hanti hglb
  · intro a b ha hb t ht0 ht1
    exact isEffect_convexCombo ha hb t ht0 ht1


