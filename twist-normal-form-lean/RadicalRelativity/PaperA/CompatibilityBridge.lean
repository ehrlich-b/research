/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Necessity.ComparisonInstanceGen
import RadicalRelativity.PaperA.CertifiedConfiguration

set_option linter.style.longLine false

/-!
# The compatibility bridge on `H_n(𝕜)`  (`prop:bridge`, manifest row 10)

The article's `prop:bridge` (vdW Props. A.1 and A.3) reads, for effects `a, b` of a
Euclidean Jordan algebra under the standard product `a ∘ b = Q_{√a} b`,

  `a ∘ b = b ∘ a  ↔  [Q_a, Q_b] = 0  ↔  [T_a, T_b] = 0`.

Row 10 is pre-registered as an **external** import and stays external.  This file is the
row's *interior form on the concrete carriers*, and it is deliberately one-directional.
The article attributes both equivalences to van de Wetering's Appendix A, noting of the
second (`[Q_a, Q_b] = 0 ↔ [T_a, T_b] = 0`) that he could not find it in the literature and
that it is treated in `Wetering2019commutativity`.

**What is proved here, at `RCLike 𝕜` generality.**  Writing `Q_{√a} = `
`Necessity.quadRep a` and `Q_a x = a·x·a` = `Necessity.quadOp a x`:

* `quadOp_eq_jordan` — `Q_a = 2 T_a² − T_{a²}`, so `quadOp` is the *Jordan* quadratic
  representation and not merely a conjugation;
* `quadRep_comm_of_commute` — `[a, b] = 0 → Q_{√a} b = Q_{√b} a` (the standard-product leg);
* `quadOp_comm_of_commute` — `[a, b] = 0 → [Q_a, Q_b] = 0` (the `Q` leg);
* `bridge_of_commute` — the three conclusions from matrix commutation;
* `bridge_of_opCommute` — the two new conclusions from Jordan-operator commutation, through
  the already-proved `T` leg `Necessity.opCommute_iff_commuteG`
  (`Necessity/ComparisonInstanceGen.lean`), which is an honest `↔`.

**Which direction Paper A consumes.**  `prop:bridge` is cited eight times in `main.tex`
(lines 671, 738, 793, 853, 858, 922, 961, 2076).  Seven are substantive: five inside proofs
(671, 738, 793, 922, 961) and two in the import ledger, discharging the compatibility
hypothesis of vdW Prop. 5.2 (853) and of vdW Prop. 5.5 (858).  The eighth (2076) is
related-work attribution and consumes nothing.  All seven run the same way: operator
commutation is established *first*, from simultaneous diagonalisability or from centrality,
and the bridge then delivers standard-product compatibility, which is what vdW's Props. 5.2
and 5.5 take as their hypothesis.  So the implication proved here is the one the article
runs on; no use site consumes a converse, and no use site mentions `[Q_a, Q_b]` at all.

**What is NOT proved here.**  The two converses out of the standard product:
`Q_{√a} b = Q_{√b} a → [a, b] = 0` and `[Q_a, Q_b] = 0 → [a, b] = 0`.  On this carrier the
first is exactly "`√b·√a` normal ⟹ `√b·√a` self-adjoint", because
`(√b√a)^* (√b√a) = Q_{√a} b` and `(√b√a)(√b√a)^* = Q_{√b} a`.  Neither converse is used by
the article.

The hypotheses here are `0 ≤ a`, `0 ≤ b`, which the article's "effects" imply
(`IsEffect.1`); `bridge_of_opCommute_effect` records the effect-level form verbatim.
-/

noncomputable section

open ComplexOrder
open scoped Matrix
open OrderUnitSpace
open MasterTheorem

namespace Necessity

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {𝕜 : Type*} [RCLike 𝕜]

/-! ## `Q_a` and `Q_{√a}` on the matrix carrier -/

/-- `Q_a : x ↦ a·x·a`, the quadratic representation **at `a` itself**.  Note that the
pre-existing `Necessity.quadRep a` is `Q_{√a}`: it already carries the square root. -/
def quadOp (a : HermitianMat n 𝕜) : HermitianMat n 𝕜 →ₗ[ℝ] HermitianMat n 𝕜 :=
  HermitianMat.conjLinear ℝ a.mat

theorem quadOp_mat (a x : HermitianMat n 𝕜) :
    (quadOp a x).mat = a.mat * x.mat * a.mat := by
  change (x.conj a.mat).mat = _
  rw [HermitianMat.conj_apply_mat, a.H]

theorem quadRep_mat (a x : HermitianMat n 𝕜) :
    (quadRep a x).mat
      = (a.cfc Real.sqrt).mat * x.mat * (a.cfc Real.sqrt).mat := by
  change (x.conj (a.cfc Real.sqrt).mat).mat = _
  rw [HermitianMat.conj_apply_mat, (a.cfc Real.sqrt).H]

/-- `Q_{√a} b` is the development's reference (Lüders) product, on the nose. -/
theorem quadRep_eq_conj (a x : HermitianMat n 𝕜) :
    quadRep a x = x.conj (a.cfc Real.sqrt).mat := rfl

/-- On `H_n(ℂ)`, `Q_{√a}` is the `t = 0` member of the twist family. -/
theorem quadRep_eq_twistSeq_zero (a x : HermitianMat n ℂ) :
    quadRep a x = HermitianMat.twistSeq 0 a x :=
  (HermitianMat.twistSeq_zero a x).symm

/-- **`Q_a = 2 T_a² − T_{a²}`**: the conjugation `x ↦ a·x·a` *is* the Jordan quadratic
representation, so the `[Q_a, Q_b]` leg below is about the article's `Q`, not about an
unrelated conjugation map. -/
theorem quadOp_eq_jordan (a x : HermitianMat n 𝕜) :
    quadOp a x = (2 : ℝ) • a.symmMul (a.symmMul x) - (a.symmMul a).symmMul x := by
  ext1
  rw [quadOp_mat]
  simp only [HermitianMat.mat_sub, HermitianMat.mat_smul, HermitianMat.symmMul_toMat,
    Matrix.mul_add, Matrix.add_mul, smul_add, Matrix.mul_smul, Matrix.smul_mul,
    Matrix.mul_assoc]
  match_scalars <;> ring

/-! ## The bridge, in the direction the article consumes -/

/-- **The standard-product leg**: commuting positive semidefinite matrices are compatible
for the standard product, `Q_{√a} b = Q_{√b} a`.  Both sides equal `a·b`: `√a` commutes with
`b` and squares back to `a`. -/
theorem quadRep_comm_of_commute {a b : HermitianMat n 𝕜} (ha : 0 ≤ a) (hb : 0 ≤ b)
    (hab : Commute a.mat b.mat) :
    quadRep a b = quadRep b a := by
  have hsa : Commute (a.cfc Real.sqrt).mat b.mat := hab.cfc_left Real.sqrt
  have hsb : Commute (b.cfc Real.sqrt).mat a.mat := hab.symm.cfc_left Real.sqrt
  ext1
  rw [quadRep_mat, quadRep_mat]
  calc (a.cfc Real.sqrt).mat * b.mat * (a.cfc Real.sqrt).mat
      = b.mat * ((a.cfc Real.sqrt).mat * (a.cfc Real.sqrt).mat) := by
        rw [hsa.eq, Matrix.mul_assoc]
    _ = b.mat * a.mat := by rw [HermitianMat.cfcSqrt_mul_self ha]
    _ = a.mat * b.mat := hab.eq.symm
    _ = a.mat * ((b.cfc Real.sqrt).mat * (b.cfc Real.sqrt).mat) := by
        rw [HermitianMat.cfcSqrt_mul_self hb]
    _ = (b.cfc Real.sqrt).mat * a.mat * (b.cfc Real.sqrt).mat := by
        rw [← Matrix.mul_assoc, hsb.eq]

/-- **The `Q` leg**: commuting matrices have commuting quadratic representations,
`[Q_a, Q_b] = 0`.  No positivity is needed. -/
theorem quadOp_comm_of_commute {a b : HermitianMat n 𝕜} (hab : Commute a.mat b.mat) :
    (quadOp a).comp (quadOp b) = (quadOp b).comp (quadOp a) := by
  apply LinearMap.ext
  intro y
  ext1
  simp only [LinearMap.comp_apply, quadOp_mat]
  calc a.mat * (b.mat * y.mat * b.mat) * a.mat
      = a.mat * b.mat * y.mat * (b.mat * a.mat) := by simp only [Matrix.mul_assoc]
    _ = b.mat * a.mat * y.mat * (a.mat * b.mat) := by rw [hab.eq]
    _ = b.mat * (a.mat * y.mat * a.mat) * b.mat := by simp only [Matrix.mul_assoc]

/-- **`prop:bridge` on `H_n(𝕜)`, from matrix commutation**: all three of the article's
compatibility conditions follow.  The `T` leg is `opCommute_of_commuteG`. -/
theorem bridge_of_commute {a b : HermitianMat n 𝕜} (ha : 0 ≤ a) (hb : 0 ≤ b)
    (hab : Commute a.mat b.mat) :
    quadRep a b = quadRep b a
      ∧ (quadOp a).comp (quadOp b) = (quadOp b).comp (quadOp a)
      ∧ OpCommute (jordanBilinG (n := n) 𝕜) a b :=
  ⟨quadRep_comm_of_commute ha hb hab, quadOp_comm_of_commute hab,
    opCommute_of_commuteG hab⟩

/-- **`prop:bridge` on `H_n(𝕜)`, from Jordan-operator commutation** — the hypothesis every
use site of `prop:bridge` in the article actually has in hand (it is read off simultaneous
diagonalisability or centrality).  The `T`-to-matrix step is `commute_of_opCommuteG`. -/
theorem bridge_of_opCommute {a b : HermitianMat n 𝕜} (ha : 0 ≤ a) (hb : 0 ≤ b)
    (h : OpCommute (jordanBilinG (n := n) 𝕜) a b) :
    quadRep a b = quadRep b a
      ∧ (quadOp a).comp (quadOp b) = (quadOp b).comp (quadOp a) :=
  ⟨quadRep_comm_of_commute ha hb (commute_of_opCommuteG h),
    quadOp_comm_of_commute (commute_of_opCommuteG h)⟩

/-- The effect-level form, as the article states it. -/
theorem bridge_of_opCommute_effect {a b : HermitianMat n 𝕜}
    (ha : IsEffect a) (hb : IsEffect b)
    (h : OpCommute (jordanBilinG (n := n) 𝕜) a b) :
    quadRep a b = quadRep b a
      ∧ (quadOp a).comp (quadOp b) = (quadOp b).comp (quadOp a) :=
  bridge_of_opCommute ha.1 hb.1 h

end Necessity
