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
comparable at all, and this has to be hypothesised rather than derived.  It is the formal content
of the article's phrase "finite-dimensional order-unit space", where the space is normed **by**
its order unit, and it holds at every carrier in this development — on `HermitianMat n 𝕜` with
unit `1` the two norms are literally equal (both are the operator norm), and on the Euclidean
Jordan carrier they are the spectral and the trace-form norms, equivalent by finite
dimensionality. -/
def OuNormEquiv (V : Type*) [OrderUnitSpace V] : Prop :=
  (∃ C : ℝ, 0 < C ∧ ∀ x : V, ouNorm x ≤ C * ‖x‖) ∧ (∃ D : ℝ, 0 < D ∧ ∀ x : V, ‖x‖ ≤ D * ouNorm x)

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
    (hequiv : OuNormEquiv V) {b : ℕ → V} {blim : V}
    (hb : ∀ k, IsEffect (b k)) (hanti : Antitone b) (hglb : IsGLB (Set.range b) blim) :
    TendstoOu b blim := by
  obtain ⟨⟨C, hC, hCle⟩, ⟨D, hD, hDle⟩⟩ := hequiv
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
    (hequiv : OuNormEquiv V) {a : V} (ha : IsEffect a) {b : ℕ → V} {blim : V}
    (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim) (hanti : Antitone b)
    (hglb : IsGLB (Set.range b) blim) :
    IsGLB (Set.range fun k => P.sp a (b k)) (P.sp a blim) :=
  sp_isGLB P harch ha hb hblim hanti (tendstoOu_of_antitone_isGLB harch hequiv hb hanti hglb)

/-- ★★ **`lem:normality`, second half: compatibility passes to order-infima.**

If `a` is compatible with every term of a decreasing sequence of effects, it is compatible with
their greatest lower bound.  ★ As at `compatible_of_tendstoOu`, this is the clause that consumes
S2; the infimum clause above does not. -/
theorem compatible_of_isGLB (harch : IsArchimedean V) [FiniteDimensional ℝ V]
    (hequiv : OuNormEquiv V) (hS2 : P.FirstArgContinuousOu) {a : V} (ha : IsEffect a)
    {b : ℕ → V} {blim : V} (hb : ∀ k, IsEffect (b k)) (hblim : IsEffect blim)
    (hanti : Antitone b) (hglb : IsGLB (Set.range b) blim)
    (hcomp : ∀ k, P.sp a (b k) = P.sp (b k) a) :
    P.sp a blim = P.sp blim a :=
  compatible_of_tendstoOu P harch hS2 ha hb hblim
    (tendstoOu_of_antitone_isGLB harch hequiv hb hanti hglb) hcomp

end SequentialProductOn
