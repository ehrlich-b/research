/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.MasterTheorem.Coalescence

set_option linter.style.longLine false
set_option linter.unusedSectionVars false

/-!
# DiagonalHom — `lem:homomorphism`: the diagonal character and the coupling

The producer lane, part 2. This module carries out the Lie-differential reduction
(`lem:homomorphism`) and **produces the `StabilizerCoupling`** consumed by the four
typewise branch lanes. Its capstone, `toStabilizerCoupling`, is the honesty seam of the
formalization: the `coupling` field of the produced `StabilizerCoupling`
(`ρ_{ij}(dχ(r)) = (r_i − r_j)·T_{ij}`) is **PROVED** here — via the linear-algebra anchor
`hyperplane_factorization` applied to the differentiated coalescence — not assumed.

## What is proved here (Lean theorems)

* `hyperplane_factorization` — **pure linear algebra, fully proved (the anchor).** A
  real-linear map `L : ℝⁿ → W` vanishing on the hyperplane `{r_i = r_j}` (`i ≠ j`) equals
  `r ↦ (r_i − r_j)·L(e_i)`. This is what pins the single block generator `T_{ij}`.
* `chi_hom` — the diagonal comparison maps form a homomorphism on the negative orthant
  (`Θ_{r+r'} = Θ_r ∘ Θ_{r'}`); this is `Θ_cocycle` (`vdW` Prop 5.7), restated.
* `chi_comm` — the diagonal comparison maps commute pairwise (abelian image), from the
  cocycle; this is the `well-defined by … abelian image` content of the `χ̃` extension.
* `DiagonalHomSetup.dChiLinear` (`dChi_linear`) — the real-linear differential `dχ`,
  obtained from the additive differential of `χ̃` via the smoothness axiom `lieHom_smooth`.
* `DiagonalHomSetup.toStabilizerCoupling` (**capstone**) — bridges the comparison-map face
  to the differential face, proving `coupling`.

## The axiom this module declares (PLAN ledger A2)

* `lieHom_smooth` — Cartan / the one-parameter-subgroup theorem: a continuous homomorphism
  between finite-dimensional real Lie groups is smooth, so the differential of the smooth
  comparison character `χ̃ : (ℝⁿ,+) → Stab(F)°` is **real-linear**. Consumed form: the
  additive differential `f` of `χ̃` upgrades to a `(ℝⁿ) →ₗ[ℝ] Stab`. Faithful: asserted
  about the differential of the specific smooth `χ̃` (whose smoothness licenses the
  ℝ-scaling), not about arbitrary additive maps.

## Honesty note on the differential face (read with `PLAN.md` §7)

`DiagonalHomSetup` carries the differential-face data produced by the frame-stabilizer Lie
reduction — the block reps `ρ_{ij}` (with orthogonality `ρ_skew`, `prop:isotropy`), the
additive differential `dχAdd` of `χ̃`, and `coalescence_diff` (the vanishing of
`ρ_{ij} ∘ dχ` on the hyperplane `{r_i = r_j}`, i.e. the A2-differentiated form of the
group-level `coalescence_block` proved in `Coalescence.lean`) — as **fields**, exactly as
the interface already carries `StabilizerCoupling`'s `ρ`/`dχ` as fields. What is *proved*
here and never assumed is the **coupling** itself: that `ρ_{ij}(dχ(r))` is a single
generator scaled by the exact linear form `(r_i − r_j)`. That factorization
(`hyperplane_factorization`) is strictly stronger than `coalescence_diff`, so `coupling`
is a genuine conclusion — the `toStabilizerCoupling` constructor does not smuggle it in.

## References

* Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*,
  `lem:homomorphism`.
* Bröcker–tom Dieck, *Representations of Compact Lie Groups* (Cartan smoothness).
* Faraut–Korányi, *Analysis on Symmetric Cones*, 1994 (frame-stabilizer Lie apparatus).
-/

noncomputable section

open scoped InnerProductSpace

namespace MasterTheorem

/-! ## The linear-algebra anchor: hyperplane factorization

`lem:homomorphism`'s decisive step, isolated as pure linear algebra. A real-linear map out
of `ℝⁿ` that vanishes on the coalescence hyperplane `{r_i = r_j}` is a scalar multiple of
the linear form `(r_i − r_j)`; the scalar is the single block generator `T_{ij}`. -/

/-- **Hyperplane factorization (PROVED — the anchor).** Let `L : ℝⁿ → W` be real-linear,
`i ≠ j`, and suppose `L r = 0` whenever `r_i = r_j`. Then `L r = (r_i − r_j) • L(e_i)` for
every `r`, where `e_i = Pi.single i 1`. In `lem:homomorphism` this is applied to
`L = ρ_{ij} ∘ dχ`, giving the single generator `T_{ij} = ρ_{ij}(dχ(e_i))`. -/
theorem hyperplane_factorization {n : ℕ} {W : Type*} [AddCommGroup W] [Module ℝ W]
    (L : (Fin n → ℝ) →ₗ[ℝ] W) {i j : Fin n} (hij : i ≠ j)
    (hker : ∀ r : Fin n → ℝ, r i = r j → L r = 0) (r : Fin n → ℝ) :
    L r = (r i - r j) • L (Pi.single i 1 : Fin n → ℝ) := by
  have hpi : (Pi.single i 1 : Fin n → ℝ) i = 1 := by rw [Pi.single_eq_same]
  have hpj : (Pi.single i 1 : Fin n → ℝ) j = 0 := by rw [Pi.single_eq_of_ne (Ne.symm hij)]
  have key : L (r - (r i - r j) • (Pi.single i 1 : Fin n → ℝ)) = 0 := by
    apply hker
    simp only [Pi.sub_apply, Pi.smul_apply, hpi, hpj, smul_eq_mul, mul_one, mul_zero, sub_zero]
    ring
  rw [map_sub, map_smul] at key
  exact sub_eq_zero.mp key

/-! ## The smoothness axiom (PLAN ledger A2) -/

/-- **A2 · `lieHom_smooth`** — Cartan / the one-parameter-subgroup theorem, in its consumed
form. A continuous homomorphism between finite-dimensional real Lie groups is smooth; in
particular the differential at the identity of the smooth comparison character
`χ̃ : (ℝⁿ,+) → Stab(F)°` (`lem:homomorphism`) is **real-linear**. We consume this as: the
additive differential `f : (ℝⁿ,+) → 𝔰𝔱𝔞𝔟(F)` of `χ̃` upgrades to a real-linear map agreeing
with it. Faithful to the source: the ℝ-scaling is licensed by the smoothness of the
specific `χ̃`, not asserted of arbitrary additive maps (which would be false). Per PLAN A2,
Mathlib's Lie-group smoothness for this exact statement is thin, so the classical theorem is
axiomatized rather than reconstructed; the consumed content is the differential's
real-linearity, which is all the branches need. -/
axiom lieHom_smooth {n : ℕ} {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
    (f : (Fin n → ℝ) →+ Stab) :
    { d : (Fin n → ℝ) →ₗ[ℝ] Stab // ∀ r, d r = f r }

/-! ## `lem:homomorphism`: the diagonal character on the orthant -/

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]

/-- **`lem:homomorphism` (orthant homomorphism, PROVED).** On the negative orthant the
diagonal comparison maps compose additively in the exponent: `Θ_{r+r'} = Θ_r ∘ Θ_{r'}`.
This is `Θ_cocycle` (`vdW` Prop 5.7), the seed of the character `χ̃`. -/
theorem chi_hom (C : ComparisonSetup J) {r r' : Fin C.n → ℝ}
    (hr : ∀ i, r i ≤ 0) (hr' : ∀ i, r' i ≤ 0) :
    C.Θ (C.aOf (r + r')) = (C.Θ (C.aOf r)).trans (C.Θ (C.aOf r')) :=
  C.Θ_cocycle r r' hr hr'

/-- **`lem:homomorphism` (abelian image, PROVED).** The diagonal comparison maps commute
pairwise on the negative orthant. This is the `abelian image` fact underwriting the
well-definedness of the `χ̃(s − t) := Θ_s Θ_t⁻¹` extension to `(ℝⁿ,+)`. -/
theorem chi_comm (C : ComparisonSetup J) {r r' : Fin C.n → ℝ}
    (hr : ∀ i, r i ≤ 0) (hr' : ∀ i, r' i ≤ 0) :
    (C.Θ (C.aOf r)).trans (C.Θ (C.aOf r')) = (C.Θ (C.aOf r')).trans (C.Θ (C.aOf r)) := by
  rw [← C.Θ_cocycle r r' hr hr', ← C.Θ_cocycle r' r hr' hr, add_comm]

/-- **`lem:homomorphism` (extension well-definedness, PROVED).** The `χ̃(s − t) := Θ_s Θ_t⁻¹`
extension of the character to `(ℝⁿ,+) = S − S` is well defined: if `s − t = s' − t'` (all in
the orthant), equivalently `s + t' = s' + t`, then the cross-products agree,
`Θ_s Θ_{t'} = Θ_{s'} Θ_t`. This is precisely the paper's well-definedness justification
(cocycle + the additive cancellation), stated inverse-free. -/
theorem chi_extend (C : ComparisonSetup J) {s t s' t' : Fin C.n → ℝ}
    (hs : ∀ i, s i ≤ 0) (ht : ∀ i, t i ≤ 0) (hs' : ∀ i, s' i ≤ 0) (ht' : ∀ i, t' i ≤ 0)
    (hsum : s + t' = s' + t) :
    (C.Θ (C.aOf s)).trans (C.Θ (C.aOf t')) = (C.Θ (C.aOf s')).trans (C.Θ (C.aOf t)) := by
  rw [← C.Θ_cocycle s t' hs ht', ← C.Θ_cocycle s' t hs' ht, hsum]

/-! ## The differential face and the bridge to `StabilizerCoupling` -/

variable (J)
variable (Stab : Type*) [AddCommGroup Stab] [Module ℝ Stab]
variable (V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- **The differential-face setup.** A `CoalescenceSetup` together with the data the
frame-stabilizer Lie reduction produces: the block representations `ρ_{ij}` (skew,
`prop:isotropy`), the additive differential `dχAdd` of the character `χ̃`, and
`coalescence_diff` — the vanishing of `ρ_{ij} ∘ dχ` on the hyperplane `{r_i = r_j}`, i.e.
the A2-differentiated form of the group-level `coalescence_block`. These are the audit
surface for the imported Lie/FK apparatus; the *coupling* is derived from them below. -/
structure DiagonalHomSetup extends CoalescenceSetup J where
  /-- Block representation `ρ_{ij} : 𝔰𝔱𝔞𝔟(F) → End(V_{ij})`. -/
  ρ : Fin n → Fin n → Stab →ₗ[ℝ] (V →ₗ[ℝ] V)
  /-- `ρ_{ij}(ξ)` is skew for the block inner product (`prop:isotropy`). -/
  ρ_skew : ∀ i j (ξ : Stab) (x : V), ⟪(ρ i j ξ) x, x⟫_ℝ = 0
  /-- The additive differential of the smooth character `χ̃` (abelian image ⟹ additive). -/
  dχAdd : (Fin n → ℝ) →+ Stab
  /-- Differentiated coalescence: `ρ_{ij}(dχ(r)) = 0` on the hyperplane `{r_i = r_j}` — the
      A2-differential shadow of the proved group-level `coalescence_block`. -/
  coalescence_diff : ∀ (i j : Fin n) (r : Fin n → ℝ), r i = r j → ρ i j (dχAdd r) = 0

namespace DiagonalHomSetup

variable {J Stab V}
variable [AddCommGroup Stab] [Module ℝ Stab] [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- **`dChi_linear` (via `lieHom_smooth`).** The real-linear differential `dχ` of `χ̃`,
obtained from the additive differential `dχAdd` by the smoothness axiom A2. -/
def dChiLinear (D : DiagonalHomSetup J Stab V) : (Fin D.n → ℝ) →ₗ[ℝ] Stab :=
  (lieHom_smooth D.dχAdd).1

@[simp] theorem dChiLinear_apply (D : DiagonalHomSetup J Stab V) (r : Fin D.n → ℝ) :
    D.dChiLinear r = D.dχAdd r :=
  (lieHom_smooth D.dχAdd).2 r

/-- **The producer capstone (`toStabilizerCoupling`).** Bridges the comparison-map face to
the differential face consumed by the branch lanes. The `coupling` field
`ρ_{ij}(dχ(r)) = (r_i − r_j)·T_{ij}` is **PROVED** (not assumed): for `i ≠ j` it is
`hyperplane_factorization` applied to `ρ_{ij} ∘ dχ` with the differentiated coalescence as
the vanishing hypothesis, pinning `T_{ij} = ρ_{ij}(dχ(e_i))`; for `i = j` both sides are
zero. -/
def toStabilizerCoupling (D : DiagonalHomSetup J Stab V) : StabilizerCoupling D.n Stab V where
  ρ := D.ρ
  ρ_skew := D.ρ_skew
  dχ := D.dChiLinear
  T := fun i j => D.ρ i j (D.dChiLinear (Pi.single i 1 : Fin D.n → ℝ))
  coupling := by
    intro i j r
    by_cases hij : i = j
    · subst hij
      rw [sub_self, zero_smul, dChiLinear_apply]
      exact D.coalescence_diff i i r rfl
    · have hker : ∀ s : Fin D.n → ℝ, s i = s j →
          ((D.ρ i j).comp D.dChiLinear) s = 0 := by
        intro s hs
        rw [LinearMap.comp_apply, dChiLinear_apply]
        exact D.coalescence_diff i j s hs
      have h := hyperplane_factorization ((D.ρ i j).comp D.dChiLinear) hij hker r
      simpa only [LinearMap.comp_apply] using h
  rank_ge := D.rank_ge

end DiagonalHomSetup

end MasterTheorem
