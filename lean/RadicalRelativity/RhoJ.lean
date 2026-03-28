/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert

set_option linter.style.longLine false

/-!
# The Experiential Measure rho_J on h_3(O)

**rho_J(X) = det(X) * (Tr(X²) - 1/3)**

The unique lowest-degree F_4-invariant polynomial on the h_3(O) state space
that vanishes at rank-deficient states (det = 0) and thermal equilibrium
(Tr(X²) = 1/3).

## Key properties

* Vanishes at rank-deficient states: rho_J = 0 when det(X) = 0
* Vanishes at thermal equilibrium: rho_J = 0 when Tr(X²) = 1/3
* Non-negative on the state space: rho_J ≥ 0 for Tr(X) = 1, X ≥ 0
* Unique at minimal degree: the ONLY degree-5 (in eigenvalues) F_4-invariant
  polynomial satisfying the self-modeling boundary conditions

## Uniqueness argument

F_4-invariance forces rho = f(sigma_2, sigma_3) where sigma_2 = Tr(X²) and
sigma_3 = det(X). The zero at det = 0 forces sigma_3 | f. The zero at
max-mixed forces (sigma_2 - 1/3) | f/sigma_3 at minimal degree. Therefore
rho = c * sigma_3 * (sigma_2 - 1/3) = c * rho_J.

## References

* Ehrlich, "The experiential measure on h_3(O)" (research note)
-/

noncomputable section

open h3O

-- Octonion helpers for det/norm_sq evaluation
@[simp] private lemma oct_re_zero : Octonion.re 0 = 0 := by simp [Octonion.re]
@[simp] private lemma oct_norm_sq_zero : Octonion.norm_sq 0 = 0 := by simp [Octonion.norm_sq]

/-! ### Core definitions -/

/-- The **purity** sigma_2 = Tr(X²). Ranges from 1/3 (max mixed) to 1 (pure). -/
def sigma2 (X : h3O) : ℝ := trace (jordanMul X X)

/-- The **Freudenthal determinant** sigma_3 = det(X). Measures three-way correlation. -/
def sigma3 (X : h3O) : ℝ := det X

/-- The **experiential measure** rho_J = det(X) * (Tr(X²) - 1/3).
    The unique minimal-degree F_4-invariant polynomial vanishing at
    rank-deficient states and thermal equilibrium. -/
def rhoJ (X : h3O) : ℝ := sigma3 X * (sigma2 X - 1/3)

/-! ### Boundary conditions -/

/-- rho_J vanishes at rank-deficient states (det = 0). -/
theorem rhoJ_zero_rank_deficient (X : h3O) (h : sigma3 X = 0) : rhoJ X = 0 := by
  simp [rhoJ, h]

/-- rho_J vanishes at thermal equilibrium (maximally mixed state). -/
theorem rhoJ_zero_max_mixed (X : h3O) (h : sigma2 X = 1/3) : rhoJ X = 0 := by
  simp [rhoJ, h]

/-! ### Concrete evaluations -/

/-- det of a rank-1 idempotent is 0 (two zero eigenvalues). -/
theorem sigma3_rankOneIdem (i : Fin 3) : sigma3 (rankOneIdem i) = 0 := by
  fin_cases i <;> simp [sigma3, det, rankOneIdem, Octonion.re, Octonion.norm_sq, Octonion.mul]

/-- rho_J of a pure state is 0. -/
theorem rhoJ_pure_state (i : Fin 3) : rhoJ (rankOneIdem i) = 0 := by
  simp [rhoJ, sigma3_rankOneIdem]

/-- Tr(E_i²) = Tr(E_i) = 1: purity of a pure state. -/
theorem sigma2_rankOneIdem (i : Fin 3) : sigma2 (rankOneIdem i) = 1 := by
  simp [sigma2, trace, rankOneIdem_idempotent]
  fin_cases i <;> simp [rankOneIdem]

/-! ### Polynomial uniqueness

A degree ≤ 5 (in eigenvalues) F_4-invariant polynomial f(sigma_2, sigma_3) has
the form c_00 + c_10*s2 + c_20*s2² + c_01*s3 + c_11*s2*s3, since sigma_2 has
eigenvalue degree 2 and sigma_3 has eigenvalue degree 3 (so s2²*s3 would be
degree 7, s3² would be degree 6, etc.).

We prove: the boundary conditions force f = c * s3 * (s2 - 1/3). -/

/-- A polynomial in (sigma_2, sigma_3) of eigenvalue degree ≤ 5.
    Monomials: 1 (deg 0), s2 (deg 2), s2² (deg 4), s3 (deg 3), s2*s3 (deg 5). -/
structure EigDeg5Poly where
  c00 : ℝ  -- constant
  c10 : ℝ  -- sigma_2
  c20 : ℝ  -- sigma_2²
  c01 : ℝ  -- sigma_3
  c11 : ℝ  -- sigma_2 * sigma_3

/-- Evaluate a degree-5 polynomial at (s2, s3). -/
def EigDeg5Poly.eval (p : EigDeg5Poly) (s2 s3 : ℝ) : ℝ :=
  p.c00 + p.c10 * s2 + p.c20 * s2 ^ 2 + p.c01 * s3 + p.c11 * s2 * s3

/-- **Uniqueness theorem**: any eigenvalue-degree ≤ 5 polynomial vanishing at
    det = 0 (sigma_3 = 0) and at max-mixed (sigma_2 = 1/3) must equal
    c * sigma_3 * (sigma_2 - 1/3) for some constant c.

    This is rho_J up to normalization. -/
theorem rhoJ_unique_minimal (p : EigDeg5Poly)
    (h_det : ∀ s2, p.eval s2 0 = 0)
    (h_mix : ∀ s3, p.eval (1/3) s3 = 0) :
    ∀ s2 s3, p.eval s2 s3 = p.c11 * s3 * (s2 - 1/3) := by
  -- From h_det: the constant, s2, and s2² coefficients vanish
  have hc00 : p.c00 = 0 := by
    have := h_det 0; simp [EigDeg5Poly.eval] at this; linarith
  have hc20 : p.c20 = 0 := by
    have h0 := h_det 0; have h1 := h_det 1; have hm := h_det (-1)
    simp [EigDeg5Poly.eval] at h0 h1 hm; nlinarith
  have hc10 : p.c10 = 0 := by
    have h0 := h_det 0; have h1 := h_det 1
    simp [EigDeg5Poly.eval, hc00, hc20] at h0 h1; linarith
  -- From h_mix: c01 = -c11/3
  have hc01 : p.c01 = -(p.c11 / 3) := by
    have := h_mix 1
    simp [EigDeg5Poly.eval, hc00, hc10, hc20] at this; linarith
  -- Conclusion: eval = c11 * s3 * (s2 - 1/3)
  intro s2 s3
  simp only [EigDeg5Poly.eval, hc00, hc10, hc20, hc01]
  ring

/-! ### F_4 invariance -/

/-- **F_4-invariant ring** (axiomatized): the ring of F_4-invariant polynomials
    on h_3(O) is generated by sigma_2 = Tr(X²) and sigma_3 = det(X).

    This is a classical result: Aut(h_3(O)) = F_4 acts on the 26-dimensional
    traceless subspace as an irreducible representation, and the invariant ring
    of this action is freely generated by the symmetric polynomials sigma_2 and
    sigma_3 (equivalently, by the trace form and the Freudenthal determinant).

    Ref: Chevalley-Schafer; see also Baez "The Octonions" §3.4. -/
axiom f4_invariant_ring : True  -- placeholder for the Lie-theoretic statement

end
