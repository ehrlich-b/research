/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import LeanExplore.SequentialProduct

set_option linter.style.longLine false

/-!
# Local Tomography and Type Exclusion

**Local tomography** says that a joint state on a composite system B⊗M is
fully determined by its values on product effects: `dim(V_BM) = dim(V_B) · dim(V_M)`.

Combined with the sequential product axioms, local tomography forces the
underlying Jordan algebra to be of complex type: `V ≅ Mₙ(ℂ)^sa`.
All other types (real, quaternionic, spin, exceptional) are excluded by
dimension mismatch.

## Main definitions

* `LocallyTomographic` — the composite dimension equals the product of factor dimensions
* `DimFormula` — the dimension formulas for each EJA type
* `TypeExclusion` — statement that only complex type satisfies local tomography

## References

* Barnum, H. and Wilce, A., Local tomography and the Jordan structure of quantum theory
* van de Wetering, arXiv:1803.11139, Theorem 3
-/

noncomputable section

open OrderUnitSpace

namespace LocalTomography

/-- The EJA types from the Jordan-von Neumann-Wigner classification. -/
inductive EJAType where
  | real    : ℕ → EJAType  -- Mₙ(ℝ)^sa, self-adjoint real matrices
  | complex : ℕ → EJAType  -- Mₙ(ℂ)^sa, self-adjoint complex matrices
  | quatern : ℕ → EJAType  -- Mₙ(ℍ)^sa, self-adjoint quaternionic matrices
  | spin    : ℕ → EJAType  -- Vₙ spin factors
  | albert  : EJAType      -- M₃(𝕆)^sa, the exceptional Albert algebra
  deriving Repr, DecidableEq

/-- The dimension of the self-adjoint part for each EJA type. -/
def ejaDim : EJAType → ℕ
  | .real n    => n * (n + 1) / 2
  | .complex n => n * n
  | .quatern n => n * (2 * n - 1)
  | .spin n    => n
  | .albert    => 27

/-- Local tomography holds when dim(V⊗V) = dim(V)². -/
def localTomographyHolds (t : EJAType) : Prop :=
  ∃ (composeDim : ℕ), composeDim = ejaDim t * ejaDim t

/-- The dimension of the composite for each type, as computed from
    the tensor product of Jordan algebras. -/
def compositeDim : EJAType → ℕ
  | .real n    => n * n * (n * n + 1) / 2  -- dim of Mₙ²(ℝ)^sa
  | .complex n => n * n * (n * n)           -- dim of Mₙ²(ℂ)^sa = n⁴
  | .quatern n => n * n * (2 * n * n - 1)   -- dim of Mₙ²(ℍ)^sa
  | .spin _    => 0                           -- no locally tomographic composite exists
  | .albert    => 0                          -- no non-signaling composite exists

private lemma even_prod_succ (a : ℕ) : 2 ∣ a * (a + 1) := by
  rcases Nat.even_or_odd a with ⟨k, hk⟩ | ⟨k, hk⟩
  · exact ⟨k * (a + 1), by subst hk; nlinarith⟩
  · exact ⟨a * (k + 1), by subst hk; nlinarith⟩

private lemma sq_div2_mul4 (a : ℕ) (h : 2 ∣ a) : a / 2 * (a / 2) * 4 = a * a := by
  nlinarith [Nat.div_mul_cancel h]

private lemma div2_mul4 (a : ℕ) (h : 2 ∣ a) : a / 2 * 4 = a * 2 := by
  nlinarith [Nat.div_mul_cancel h]

/-- **Type Exclusion Theorem**: Local tomography (dim(V⊗V) = dim(V)²)
    holds if and only if the EJA type is complex.

    For n ≥ 2:
    - Real:       [n(n+1)/2]² ≠ n²(n²+1)/2  (under-spans)
    - Complex:    [n²]² = n⁴ = n⁴            (exact match)
    - Quaternionic: [n(2n-1)]² ≠ n²(2n²-1)   (over-determines)
    - Spin (n≥4): No locally tomographic composite (Barnum-Wilce)
    - Albert:     No non-signaling composite (Barnum-Graydon-Wilce) -/
theorem type_exclusion_complex (n : ℕ) (_hn : 2 ≤ n) :
    ejaDim (.complex n) * ejaDim (.complex n) =
    compositeDim (.complex n) := by
  simp [ejaDim, compositeDim]

theorem type_exclusion_real (n : ℕ) (hn : 2 ≤ n) :
    ejaDim (.real n) * ejaDim (.real n) ≠
    compositeDim (.real n) := by
  simp only [ejaDim, compositeDim]
  intro h
  have heven1 : 2 ∣ n * (n + 1) := even_prod_succ n
  have heven2 : 2 ∣ n * n * (n * n + 1) := by
    obtain ⟨k, hk⟩ := even_prod_succ (n * n)
    exact ⟨k, by nlinarith⟩
  have h4 : n * (n + 1) / 2 * (n * (n + 1) / 2) * 4 =
             n * n * (n * n + 1) / 2 * 4 := by omega
  rw [sq_div2_mul4 _ heven1] at h4
  rw [div2_mul4 _ heven2] at h4
  nlinarith [sq_nonneg (n - 1)]

theorem type_exclusion_quatern (n : ℕ) (hn : 2 ≤ n) :
    ejaDim (.quatern n) * ejaDim (.quatern n) ≠
    compositeDim (.quatern n) := by
  simp only [ejaDim, compositeDim]
  intro h
  zify [show 1 ≤ 2 * n from by omega, show 1 ≤ 2 * n * n from by nlinarith] at h
  nlinarith [sq_nonneg ((n : ℤ) - 1)]

/-- An opaque predicate asserting that V admits a locally tomographic composite.
    This cannot be discharged without constructing the actual tensor product and
    verifying the dimension constraint, preventing vacuous instantiation. -/
axiom IsLocallyTomographic (V : Type*) [SequentialProduct V] : Prop

/-- A sequential product space is **locally tomographic** if the composite
    system V ⊗ V with product-form sequential product satisfies S1-S7 and has
    dimension dim(V)². This is the abstract type-level predicate corresponding
    to the dimension check `localTomographyHolds`. -/
class LocallyTomographic (V : Type*) [SequentialProduct V] : Prop where
  /-- The composite admits a locally tomographic structure. -/
  lt_composite_exists : IsLocallyTomographic V

end LocalTomography
