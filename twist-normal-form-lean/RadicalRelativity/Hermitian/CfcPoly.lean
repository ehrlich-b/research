/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Hermitian.OrderUnit
import RadicalRelativity.Hermitian.Resolution
import Mathlib.LinearAlgebra.Lagrange

set_option linter.style.longLine false

/-!
# The functional calculus at polynomials, over any `RCLike` field

`A.cfc p` for a polynomial `p` is just the matrix polynomial `p(A)`, so it is
**manifestly continuous in `A`** — no C⋆-algebra machinery involved.

This is the field-general replacement for the ℂ-only `HermitianMat.cfc_continuous`,
whose proof routes through `ContinuousOn.cfc` at `CStarMatrix d d ℂ` and therefore
cannot generalize: Mathlib's `CStarAlgebra` class is *complex by definition*
(`extends … NormedAlgebra ℂ A`), so real matrices are simply not an instance.

Together with the `𝕜`-general bound `norm_cfc_sub_le_of_sup_le'` (in
`RadicalRelativity.Hermitian.RCLikeGeneral`; upstream states it only for `ℂ`) and
Stone–Weierstrass on a compact spectrum window, these give continuity of
`A ↦ A.cfc f` for continuous `f` over any `RCLike 𝕜` — which is what the real
branch needs for its singular-effect extension.

* `mat_cfc_pow` — `(A.cfc (·^k)).mat = A.mat ^ k`.
* `continuous_cfc_pow` — hence `A ↦ A.cfc (·^k)` is continuous.
* `continuous_cfc_polynomial` — and so is `A ↦ A.cfc (p.eval ·)` for any `p`.
-/

noncomputable section

open scoped Matrix

namespace HermitianMat

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {𝕜 : Type*} [RCLike 𝕜]

/-- The functional calculus at a monomial is a matrix power. -/
theorem mat_cfc_pow (A : HermitianMat n 𝕜) (k : ℕ) :
    (A.cfc (fun x => x ^ k)).mat = A.mat ^ k := by
  induction k with
  | zero =>
    have h : (fun x : ℝ => x ^ 0) = (fun _ : ℝ => (1 : ℝ)) := by
      funext x; simp
    rw [h, HermitianMat.cfc_const, HermitianMat.mat_smul, HermitianMat.mat_one,
      one_smul]
    symm
    simp
  | succ k ih =>
    have hsplit : (fun x : ℝ => x ^ (k + 1)) = (fun x : ℝ => x ^ k * x) := by
      funext x; rw [pow_succ]
    rw [hsplit, HermitianMat.mat_cfc_mul_apply, ih, HermitianMat.cfc_id', pow_succ]

/-- Matrix powers are continuous in the matrix, so the functional calculus at a
monomial is continuous — with no appeal to the C⋆ structure. -/
theorem continuous_cfc_pow (k : ℕ) :
    Continuous (fun A : HermitianMat n 𝕜 => A.cfc (fun x => x ^ k)) := by
  apply Continuous.subtype_mk
  have h : (fun A : HermitianMat n 𝕜 => ((A.cfc (fun x => x ^ k)).mat))
      = fun A : HermitianMat n 𝕜 => (A.mat) ^ k := by
    funext A
    exact mat_cfc_pow A k
  show Continuous fun A : HermitianMat n 𝕜 => ((A.cfc (fun x => x ^ k)).mat)
  rw [h]
  exact (continuous_subtype_val).pow k

/-- **The functional calculus at any polynomial is continuous in the matrix.**  This
is the manifestly-continuous approximating family the real branch uses in place of
the complex-only `cfc_continuous`. -/
theorem continuous_cfc_polynomial (p : Polynomial ℝ) :
    Continuous (fun A : HermitianMat n 𝕜 => A.cfc (fun x => p.eval x)) := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq =>
    have h : (fun A : HermitianMat n 𝕜 => A.cfc (fun x => (p + q).eval x))
        = fun A : HermitianMat n 𝕜 =>
          A.cfc (fun x => p.eval x) + A.cfc (fun x => q.eval x) := by
      funext A
      rw [← HermitianMat.cfc_add_apply]
      congr 1
      funext x
      rw [Polynomial.eval_add]
    rw [h]
    exact hp.add hq
  | monomial k c =>
    apply Continuous.subtype_mk
    have h : (fun A : HermitianMat n 𝕜 =>
          (A.cfc (fun x => (Polynomial.monomial k c).eval x)).mat)
        = fun A : HermitianMat n 𝕜 => c • (A.mat ^ k) := by
      funext A
      have hfun : (fun x : ℝ => (Polynomial.monomial k c).eval x)
          = fun x : ℝ => c * x ^ k := by
        funext x
        rw [Polynomial.eval_monomial]
      rw [hfun, HermitianMat.mat_cfc_mul_apply, HermitianMat.cfc_const,
        HermitianMat.mat_smul, HermitianMat.mat_one, mat_cfc_pow, Matrix.smul_mul,
        one_mul]
    show Continuous fun A : HermitianMat n 𝕜 =>
      (A.cfc (fun x => (Polynomial.monomial k c).eval x)).mat
    rw [h]
    exact ((continuous_subtype_val).pow k).const_smul c

/-! ## `cfc` at a polynomial IS the matrix polynomial -/

/-- **`(A.cfc p).mat = p(A)`** — the functional calculus at a polynomial is literally the
matrix polynomial, `Polynomial.aeval` of the matrix.  This is the bridge any argument
needs that transfers a property from matrix polynomials to the functional calculus
(e.g. invariance under an algebra involution). -/
theorem mat_cfc_polynomial (A : HermitianMat n 𝕜) (p : Polynomial ℝ) :
    (A.cfc (fun x => p.eval x)).mat
      = Polynomial.aeval A.mat (p.map (algebraMap ℝ 𝕜)) := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq =>
    have hfun : (fun x : ℝ => (p + q).eval x)
        = (fun x : ℝ => p.eval x + q.eval x) := by
      funext x
      rw [Polynomial.eval_add]
    rw [hfun, HermitianMat.cfc_add_apply, HermitianMat.mat_add, hp, hq,
      Polynomial.map_add, map_add]
  | monomial k c =>
    have hfun : (fun x : ℝ => (Polynomial.monomial k c).eval x)
        = (fun x : ℝ => c * x ^ k) := by
      funext x
      rw [Polynomial.eval_monomial]
    rw [hfun, HermitianMat.mat_cfc_mul_apply, HermitianMat.cfc_const,
      HermitianMat.mat_smul, HermitianMat.mat_one, mat_cfc_pow]
    rw [Polynomial.map_monomial, Polynomial.aeval_monomial]
    rw [Matrix.smul_mul, one_mul]
    rw [Algebra.smul_def]
    congr 1

/-! ## Polynomials at a spectral projection

★★★ Manifest **row 22**'s residue is that `a^{it}` acts on a spectral projection `q` of `a` by the
scalar `λ^{it}` — the tree has it "only for the diagonal family".  The general statement factors
through polynomials: `a * q = λ • q` propagates to powers, hence to `Polynomial.aeval`, and
`mat_cfc_polynomial` above carries that to the functional calculus.  Since a matrix spectrum is
finite, every continuous `f` agrees on it with a polynomial, which is what closes the gap. -/

theorem pow_mul_of_eigen {M q : Matrix n n 𝕜} {μ : 𝕜} (h : M * q = μ • q) (k : ℕ) :
    M ^ k * q = μ ^ k • q := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [pow_succ, Matrix.mul_assoc, h, Matrix.mul_smul, ih, smul_smul, pow_succ, mul_comm]

/-- ★★★ **A polynomial in `M` acts on an eigenprojection by the polynomial's value.** -/
theorem aeval_mul_of_eigen {M q : Matrix n n 𝕜} {μ : 𝕜} (h : M * q = μ • q)
    (P : Polynomial 𝕜) : Polynomial.aeval M P * q = P.eval μ • q := by
  induction P using Polynomial.induction_on' with
  | add P Q hP hQ =>
    rw [map_add, Matrix.add_mul, hP, hQ, Polynomial.eval_add, add_smul]
  | monomial k c =>
    rw [Polynomial.aeval_monomial, Polynomial.eval_monomial,
      Algebra.algebraMap_eq_smul_one, Matrix.smul_mul, Matrix.one_mul, Matrix.smul_mul,
      pow_mul_of_eigen h k, smul_smul]

/-- ★★★ **The functional calculus acts on an eigenprojection by the scalar `f λ`.**

This is manifest **row 22**'s missing general step.  The tree previously knew
`a^{it} q = λ^{it} q` only when `q` was drawn from `a`'s own diagonal family; here `q`
is *any* matrix satisfying `a q = λ q`, and `f` is *any* real function — no continuity,
no positivity, no relation between `q` and `a`'s eigenprojections.

The proof is the interpolation argument: a matrix spectrum is finite, so `f` agrees on
`σ(a) ∪ {λ}` with the Lagrange interpolant `p`; `cfc_congr` replaces `f` by `p`;
`mat_cfc_polynomial` turns `A.cfc p` into the matrix polynomial `p(A)`; and
`aeval_mul_of_eigen` propagates the eigenrelation through `p`.  Note that no hypothesis
`λ ∈ σ(a)` is needed — `λ` is simply added to the interpolation nodes. -/
theorem mat_cfc_mul_of_eigen (A : HermitianMat n 𝕜) (f : ℝ → ℝ) {q : Matrix n n 𝕜} {lam : ℝ}
    (h : A.mat * q = (algebraMap ℝ 𝕜 lam) • q) :
    (A.cfc f).mat * q = (algebraMap ℝ 𝕜 (f lam)) • q := by
  classical
  set nodes : Finset ℝ := insert lam A.eigFinset with hnodes
  set p : Polynomial ℝ := Lagrange.interpolate nodes id f with hp
  have hnode_eval : ∀ z ∈ nodes, p.eval z = f z := by
    intro z hz
    simpa using! Lagrange.eval_interpolate_at_node (r := f) (Set.injOn_id _) hz
  have hcongr : A.cfc f = A.cfc (fun x => p.eval x) := by
    apply HermitianMat.cfc_congr
    intro x hx
    exact (hnode_eval x (Finset.mem_insert_of_mem
      (Finset.mem_coe.mp (HermitianMat.spectrum_subset_eigFinset A hx)))).symm
  rw [hcongr, mat_cfc_polynomial, aeval_mul_of_eigen h]
  congr 1
  rw [Polynomial.eval_map, Polynomial.eval₂_at_apply,
    hnode_eval lam (Finset.mem_insert_self _ _)]

end HermitianMat
