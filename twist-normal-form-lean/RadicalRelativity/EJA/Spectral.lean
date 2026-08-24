/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Subalgebra
import RadicalRelativity.EJA.FormallyReal
import RadicalRelativity.EJA.Witness
import RadicalRelativity.EJA.Bridge
import Mathlib.LinearAlgebra.Lagrange
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.RingTheory.PrincipalIdealDomain

set_option linter.style.longLine false

/-!
# (E1): the single-element spectral theorem for a formally real Jordan algebra

**ARC-9, 2026-08-22.**

Every element of a finite-dimensional formally real Jordan algebra is a real combination of
pairwise-orthogonal idempotents drawn from the subalgebra it generates
(`spectral_resolution`), and, when a unit is available, of a family summing to it
(`spectral_resolution_complete`). Both are instantiated on `HermitianMat d 𝕜` at the end of
the file, so the abstract statements have a live carrier.

## The route, and why it carries no ring structure on `jspan x`

The classical treatment works inside the unital algebra `ℝ[x] = span{1, x, x², …}` and needs
that algebra to be a *ring* — which forces either a unit on `J` or a `Unitization` of a
subtype, and with it a `NonUnitalCommRing ↥(jspan x)` instance and its scalar towers. **None
of that appears here.** The polynomial bookkeeping is carried by a linear map

  `jeval x : ℝ[X] →ₗ[ℝ] J`,  `jeval x p = ∑ₙ p.coeff n • x^{n+1}`,

which is "`x·p(x)`" — the shape available with no unit at all, since every monomial carries
at least one factor of `x`. Its whole content is one identity,

  `jeval_mul : jeval x p * jeval x q = jeval x (X * p * q)`,

which is `EJA/PowerAssoc.lean`'s `jpow_mul_jpow` transported along bilinearity. Everything
downstream is ideal theory in `ℝ[X]`, where Mathlib already has what is needed, and the
values live in the ambient `J`, where `EJA/FormallyReal.lean` already applies.

The steps, each a named declaration below:

| step | statement | declaration |
| --- | --- | --- |
| 1 | the annihilator `{p | x·p(x) = 0}` is an ideal of `ℝ[X]`, nonzero in finite dimension | `jann`, `exists_annihilator_generator` |
| 2 | its generator `m` is radical, hence squarefree | `isRadical_of_annihilator` |
| 3 | `m` has a nonzero constant term | `coeff_zero_ne_zero_of_annihilator` |
| 4 | `m` has no non-real complex root | `annihilator_aeval_ne_zero_of_im_ne_zero` |
| 5 | so some product of distinct linear factors, none of them `X`, annihilates `x` | `exists_split_annihilator` |
| 6 | Lagrange interpolation at those roots together with `0` gives the idempotents | `exists_orthIdem_finset` |

★ **Step 2 is where formal reality enters the polynomial algebra**, through the identity
`jpow (jeval x f) n = jeval x (Xⁿ f^{n+1})` (`jpow_jeval`): a Jordan power of a value of
`jeval` is again a value of `jeval`, so `EJA/FormallyReal.lean`'s no-nilpotents theorem —
which is stated about *ambient* elements of `J` — applies with no repackaging. This is why
no `IsReduced` instance on a ring structure over `jspan x` is needed anywhere.

★ **Step 4 uses no idempotent.** The textbook argument builds `e ≡ e² (mod m)` from a Bézout
splitting and applies formal reality to `((x−Re z)e(x))² + (Im z · e(x))²`. Here the
idempotence is never used: with `q ∣ m` the real quadratic through a non-real root `z`, and
`e := βu` from `α q + β u = 1`, the *only* facts consumed are `q·e ≡ 0 (mod m)` and, for the
contradiction, `e ≢ 0 (mod m)`. What formal reality kills is the value `jeval x g` directly,
where `X * g` is `e` corrected to have zero constant term — a correction available exactly
because of step 3. Multiplicities never enter, and neither does `Mathlib`'s `radical` API.

## Scope — what these theorems are NOT

* They are stated at the **typeclass** generality of the rest of the EJA layer
  (`NonUnitalNonAssocCommRing` + `IsCommJordan` + `Module ℝ` + `IsScalarTower` + finite
  dimension + `IsFormallyReal`). `WallCertificates/eja-gated.lean`'s `gate_E1_spectral` is
  stated over `ComparisonSetup`, whose product is a *bundled bilinear map*
  `jordan : J →ₗ[ℝ] J →ₗ[ℝ] J`. **This file does not discharge that gate**, and no manifest
  row moves on it. The remaining distance is the impedance mismatch recorded in
  `EJA/Frame.lean` — `EJA/Bridge.lean`'s `ringOfBilinear` is the intended crossing and is
  not exercised here.
* `spectral_resolution` is unit-free and its idempotents therefore sum to the *support* of
  `x`, not to a unit. `spectral_resolution_complete` adds completeness by appending `e − s`
  with coefficient `0`; that member is not in `jspan x`, so the `jspan` clause is the price
  of completeness and is dropped there rather than weakened.
* Nothing here is a functional calculus. (E1) as `EJA-DIVIDEND.md` states it also asks for
  the calculus on the resolution; that is not built.
-/

namespace RadicalRelativity.EJA

open Polynomial

section Eval

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J]

/-- `jeval x p = ∑ n, p.coeff n • x^{n+1}`, morally `x * p(x)`. -/
noncomputable def jeval (x : J) : Polynomial ℝ →ₗ[ℝ] J where
  toFun p := p.sum fun n a => a • jpow x n
  map_add' p q :=
    Polynomial.sum_add_index p q _ (fun _ => zero_smul _ _) (fun _ b₁ b₂ => add_smul b₁ b₂ _)
  map_smul' r p := by
    simp only [RingHom.id_apply]
    rw [Polynomial.sum_smul_index p r (fun n a => a • jpow x n) (fun _ => zero_smul ℝ _),
      Polynomial.smul_sum]
    exact Finset.sum_congr rfl fun n _ => (mul_smul r _ _)

omit [IsCommJordan J] [IsScalarTower ℝ J J] in
@[simp] theorem jeval_monomial (x : J) (n : ℕ) (a : ℝ) :
    jeval x (monomial n a) = a • jpow x n :=
  Polynomial.sum_monomial_index a (fun n a => a • jpow x n) (zero_smul _ _)

omit [IsCommJordan J] [IsScalarTower ℝ J J] in
@[simp] theorem jeval_one (x : J) : jeval x 1 = x := by
  rw [← C_1, ← monomial_zero_left, jeval_monomial, one_smul, jpow_zero]

omit [IsCommJordan J] in
/-- Multiplying the argument by `X` multiplies the value by `x`. -/
theorem jeval_X_mul (x : J) (p : Polynomial ℝ) : jeval x (X * p) = x * jeval x p := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => rw [mul_add, map_add, map_add, hp, hq, mul_add]
  | monomial n a =>
      rw [X_mul_monomial, jeval_monomial, jeval_monomial, jpow_succ,
        mul_smul_comm']

/-- **The multiplication rule.** `jeval` is "`x·p(x)`", so the product of two values is
`x·p(x)·x·q(x) = x·(X p q)(x)`. -/
theorem jeval_mul (x : J) (p q : Polynomial ℝ) :
    jeval x p * jeval x q = jeval x (X * p * q) := by
  induction p using Polynomial.induction_on' with
  | add p₁ p₂ hp₁ hp₂ => rw [map_add, add_mul, hp₁, hp₂, mul_add, add_mul, map_add]
  | monomial m a =>
      induction q using Polynomial.induction_on' with
      | add q₁ q₂ hq₁ hq₂ => rw [map_add, mul_add, hq₁, hq₂, mul_add, map_add]
      | monomial n b =>
          rw [jeval_monomial, jeval_monomial, smul_mul_assoc, mul_smul_comm', jpow_mul_jpow,
            smul_smul, X_mul_monomial, monomial_mul_monomial, jeval_monomial]
          congr 2
          omega

end Eval

section Annihilator

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J]

omit [IsCommJordan J] in
theorem jeval_X_pow_mul {x : J} {p : Polynomial ℝ} (hp : jeval x p = 0) (k : ℕ) :
    jeval x (X ^ k * p) = 0 := by
  induction k with
  | zero => simpa using hp
  | succ k ih => rw [pow_succ', mul_assoc, jeval_X_mul, ih, mul_zero]

omit [IsCommJordan J] in
theorem jeval_mul_eq_zero {x : J} {p : Polynomial ℝ} (hp : jeval x p = 0) (q : Polynomial ℝ) :
    jeval x (q * p) = 0 := by
  induction q using Polynomial.induction_on' with
  | add q₁ q₂ h₁ h₂ => rw [add_mul, map_add, h₁, h₂, add_zero]
  | monomial n a =>
      have hmul : (monomial n a : Polynomial ℝ) * p = a • (X ^ n * p) := by
        rw [← C_mul_X_pow_eq_monomial, smul_eq_C_mul, mul_assoc]
      rw [hmul, map_smul, jeval_X_pow_mul hp n, smul_zero]

/-- The annihilator of `x`: the polynomials `p` with `x·p(x) = 0`. -/
noncomputable def jann (x : J) : Ideal (Polynomial ℝ) where
  carrier := {p | jeval x p = 0}
  add_mem' := fun {p q} hp hq => by
    simp only [Set.mem_ofPred_eq] at *
    rw [map_add, hp, hq, add_zero]
  zero_mem' := by simp only [Set.mem_ofPred_eq, map_zero]
  smul_mem' := fun q p hp => by
    simp only [Set.mem_ofPred_eq, smul_eq_mul] at *
    exact jeval_mul_eq_zero hp q

omit [IsCommJordan J] in
theorem mem_jann {x : J} {p : Polynomial ℝ} : p ∈ jann x ↔ jeval x p = 0 := Iff.rfl

omit [IsCommJordan J] in
/-- **The annihilator has a nonzero generator.** Finite dimension makes the powers of `x`
dependent, so the annihilator is a nonzero ideal of the principal ideal ring `ℝ[X]`. -/
theorem exists_annihilator_generator [Module.Finite ℝ J] (x : J) :
    ∃ m : Polynomial ℝ, m ≠ 0 ∧ ∀ f, jeval x f = 0 ↔ m ∣ f := by
  obtain ⟨n, c, ⟨i₀, hi₀⟩, hsum⟩ := exists_jpow_relation x
  have hp0 : jeval x (∑ i : Fin n, monomial (i : ℕ) (c i)) = 0 := by
    rw [map_sum]
    simpa using hsum
  have hpne : (∑ i : Fin n, monomial (i : ℕ) (c i)) ≠ 0 := by
    intro h
    have hco : (∑ i : Fin n, monomial (i : ℕ) (c i)).coeff (i₀ : ℕ) = c i₀ := by
      rw [Polynomial.finsetSum_coeff, Finset.sum_eq_single i₀]
      · simp
      · intro b _ hb
        simp [Polynomial.coeff_monomial, Fin.val_ne_of_ne hb]
      · simp
    rw [h, Polynomial.coeff_zero] at hco
    exact hi₀ hco.symm
  refine ⟨Submodule.IsPrincipal.generator (jann x), ?_, fun f => ?_⟩
  · intro hgen
    have := (Submodule.IsPrincipal.mem_iff_generator_dvd (jann x)).mp (mem_jann.mpr hp0)
    rw [hgen, zero_dvd_iff] at this
    exact hpne this
  · exact (mem_jann (x := x) (p := f)).symm.trans
      (Submodule.IsPrincipal.mem_iff_generator_dvd (jann x))

/-- `x·f(x)` raised to the `n`-th Jordan power is again a value of `jeval`. -/
theorem jpow_jeval (x : J) (f : Polynomial ℝ) (n : ℕ) :
    jpow (jeval x f) n = jeval x (X ^ n * f ^ (n + 1)) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [jpow_succ, ih, jeval_mul]
      congr 1
      ring

variable [IsFormallyReal J]

/-- **The generator is radical.** A power of `f` annihilating `x` forces `f` to, because the
Jordan powers of `x·f(x)` are exactly the values of `jeval` on `Xⁿ f^{n+1}` and a formally
real Jordan algebra has no nilpotents. -/
theorem isRadical_of_annihilator {x : J} {m : Polynomial ℝ}
    (hm : ∀ f, jeval x f = 0 ↔ m ∣ f) : IsRadical m := by
  intro n f hdvd
  match n with
  | 0 => exact (isUnit_of_dvd_one (by simpa using hdvd)).dvd
  | (k + 1) =>
      refine (hm f).mp ?_
      have h1 : jeval x (X ^ k * f ^ (k + 1)) = 0 :=
        jeval_X_pow_mul ((hm _).mpr hdvd) k
      rw [← jpow_jeval] at h1
      exact eq_zero_of_jpow_eq_zero k h1

/-- **The generator has a nonzero constant term.** If `X ∣ m` then the cofactor's value
squares to zero, so it too annihilates `x`, and it has smaller degree than the generator. -/
theorem coeff_zero_ne_zero_of_annihilator {x : J} {m : Polynomial ℝ}
    (hm : ∀ f, jeval x f = 0 ↔ m ∣ f) (hm0 : m ≠ 0) : m.coeff 0 ≠ 0 := by
  intro hc
  obtain ⟨m₁, hm₁⟩ := Polynomial.X_dvd_iff.mpr hc
  have hm₁0 : m₁ ≠ 0 := by
    rintro rfl
    rw [mul_zero] at hm₁
    exact hm0 hm₁
  have hsq : jeval x m₁ * jeval x m₁ = 0 := by
    rw [jeval_mul, ← hm₁]
    exact (hm _).mpr ⟨m₁, rfl⟩
  have hdvd : m ∣ m₁ := (hm m₁).mp (eq_zero_of_mul_self_eq_zero hsq)
  have hle := Polynomial.natDegree_le_of_dvd hdvd hm₁0
  rw [hm₁, Polynomial.natDegree_mul Polynomial.X_ne_zero hm₁0, Polynomial.natDegree_X] at hle
  omega

end Annihilator

section Kill

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J] [IsFormallyReal J]

open Complex in
/-- **The kill.** The generator of the annihilator has no non-real complex root. -/
theorem annihilator_aeval_ne_zero_of_im_ne_zero {x : J} {m : Polynomial ℝ}
    (hm : ∀ f, jeval x f = 0 ↔ m ∣ f) (hsq : Squarefree m) (h0 : m.coeff 0 ≠ 0)
    {z : ℂ} (hz : z.im ≠ 0) : aeval z m ≠ 0 := by
  intro hroot
  obtain ⟨u, hu⟩ := m.quadratic_dvd_of_aeval_eq_zero_im_ne_zero hroot hz
  set q : Polynomial ℝ := X ^ 2 - C (2 * z.re) * X + C (‖z‖ ^ 2) with hqdef
  have hqnu : ¬ IsUnit q := by
    intro h
    have h2 : q.natDegree = 2 := by rw [hqdef]; compute_degree!
    rw [Polynomial.natDegree_eq_zero_of_isUnit h] at h2
    exact absurd h2 (by norm_num)
  have hcop : IsCoprime q u := by
    rw [hu] at hsq
    exact (IsRelPrime.of_squarefree_mul hsq).isCoprime
  obtain ⟨α, β, hbez⟩ := hcop
  set c : ℝ := (β * u).coeff 0 / m.coeff 0 with hcdef
  set g : Polynomial ℝ := (β * u - C c * m).divX with hgdef
  have hXg : X * g = β * u - C c * m := by
    have hc0 : (β * u - C c * m).coeff 0 = 0 := by
      simp [hcdef, div_mul_cancel₀ _ h0]
    rw [hgdef]
    conv_rhs => rw [← Polynomial.X_mul_divX_add (β * u - C c * m)]
    rw [hc0, map_zero, add_zero]
  -- `q` annihilates the class of `X * g`
  have h1 : m ∣ q * (X * g) := by
    rw [hXg]
    exact ⟨β - C c * q, by rw [hu]; ring⟩
  -- `q` is a sum of two squares
  have hqsq : q = (X - C z.re) ^ 2 + C (z.im ^ 2) := by
    have hnorm : ‖z‖ ^ 2 = z.re ^ 2 + z.im ^ 2 := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]; ring
    rw [hqdef, hnorm]
    simp only [Polynomial.C_add, Polynomial.C_mul, Polynomial.C_pow, map_ofNat]
    ring
  -- the sum of squares vanishes
  set a : J := jeval x ((X - C z.re) * g) with hadef
  set b : J := z.im • jeval x g with hbdef
  have hsum : a * a + b * b = 0 := by
    have hb2 : b * b = jeval x (C (z.im ^ 2) * (X * g * g)) := by
      rw [hbdef, smul_mul_assoc, mul_smul_comm', smul_smul, jeval_mul, ← Polynomial.smul_eq_C_mul,
        map_smul]
      ring_nf
    rw [hadef, jeval_mul, hb2, ← map_add]
    refine (hm _).mpr (dvd_trans (h1.mul_right g) ?_)
    exact ⟨1, by rw [hqsq]; ring⟩
  have hb0 : b = 0 := by
    have := IsFormallyReal.eq_zero_of_sum_mul_self (Finset.univ : Finset (Fin 2)) ![a, b]
      (by simpa [Fin.sum_univ_two] using hsum)
    simpa using this 1 (Finset.mem_univ 1)
  have hg0 : jeval x g = 0 := by
    rcases smul_eq_zero.mp (hbdef ▸ hb0) with h | h
    · exact absurd h hz
    · exact h
  -- and that forces `q` to be a unit
  have hmg : m ∣ β * u := by
    have h4 : m ∣ β * u - C c * m := by
      rw [← hXg]; exact ((hm g).mp hg0).mul_left X
    simpa using dvd_add h4 (⟨C c, by ring⟩ : m ∣ C c * m)
  have hqm : q ∣ m := ⟨u, hu⟩
  exact hqnu (isUnit_of_dvd_one (hbez ▸ dvd_add (dvd_mul_left q α) (hqm.trans hmg)))

end Kill


section Split

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J] [IsFormallyReal J] [Module.Finite ℝ J]

/-- **The split annihilator.** Some product of *distinct* linear factors, none of them `X`,
annihilates `x`. -/
theorem exists_split_annihilator (x : J) :
    ∃ S : Finset ℝ, (0 : ℝ) ∉ S ∧ jeval x (∏ a ∈ S, (X - C a)) = 0 := by
  obtain ⟨m, hm0, hm⟩ := exists_annihilator_generator x
  have hsq : Squarefree m := (isRadical_of_annihilator hm).squarefree hm0
  have hc0 : m.coeff 0 ≠ 0 := coeff_zero_ne_zero_of_annihilator hm hm0
  refine ⟨m.roots.toFinset, ?_, ?_⟩
  · rw [Polynomial.coeff_zero_eq_eval_zero] at hc0
    simpa [Polynomial.mem_roots', Polynomial.IsRoot.def] using fun _ => hc0
  · have hPm : (∏ a ∈ m.roots.toFinset, (X - C a)) ∣ m :=
      Finset.prod_dvd_of_coprime
        ((Polynomial.pairwise_coprime_X_sub_C (Function.injective_id (α := ℝ))).set_pairwise _)
        (fun a ha => Polynomial.dvd_iff_isRoot.mpr
          (Polynomial.isRoot_of_mem_roots (Multiset.mem_toFinset.mp ha)))
    obtain ⟨W, hW⟩ := hPm
    have hWnr : ∀ r : ℝ, W.eval r ≠ 0 := by
      intro r hr
      have hmr : m.IsRoot r := by rw [hW]; simp [Polynomial.IsRoot.def, hr]
      have hrS : r ∈ m.roots.toFinset :=
        Multiset.mem_toFinset.mpr (Polynomial.mem_roots'.mpr ⟨hm0, hmr⟩)
      have hdd : (X - C r) * (X - C r) ∣ m := by
        rw [hW]
        exact mul_dvd_mul (Finset.dvd_prod_of_mem _ hrS) (Polynomial.dvd_iff_isRoot.mpr hr)
      have hu := hsq _ hdd
      rw [Polynomial.isUnit_iff_degree_eq_zero, Polynomial.degree_X_sub_C] at hu
      exact one_ne_zero hu
    have hWu : IsUnit W := by
      by_contra hWnu
      have hW0 : W ≠ 0 := by
        rintro rfl
        rw [mul_zero] at hW
        exact hm0 hW
      have hdeg : W.degree ≠ 0 := fun h => hWnu (Polynomial.isUnit_iff_degree_eq_zero.mpr h)
      obtain ⟨z, hz⟩ := IsAlgClosed.exists_aeval_eq_zero ℂ W hdeg
      have him : z.im ≠ 0 := by
        intro h
        refine hWnr z.re ?_
        have hzr : z = algebraMap ℝ ℂ z.re := by
          apply Complex.ext <;> simp [h]
        rw [hzr, Polynomial.aeval_algebraMap_apply_eq_algebraMap_eval] at hz
        simpa using hz
      exact annihilator_aeval_ne_zero_of_im_ne_zero hm hsq hc0 him (by rw [hW, map_mul, hz, mul_zero])
    obtain ⟨v, hv⟩ := hWu.exists_right_inv
    refine (hm _).mpr ⟨v, ?_⟩
    calc (∏ a ∈ m.roots.toFinset, (X - C a))
        = (∏ a ∈ m.roots.toFinset, (X - C a)) * (W * v) := by rw [hv, mul_one]
      _ = m * v := by rw [← mul_assoc, ← hW]

omit [IsCommJordan J] [IsScalarTower ℝ J J] [IsFormallyReal J] [Module.Finite ℝ J] in
/-- Every value of `jeval x` lies in the subalgebra generated by `x`. -/
theorem jeval_mem_jspan (x : J) (p : Polynomial ℝ) : jeval x p ∈ jspan x := by
  change p.sum (fun n a => a • jpow x n) ∈ jspan x
  rw [Polynomial.sum_def]
  exact Submodule.sum_mem _ fun n _ => Submodule.smul_mem _ _ (jpow_mem_jspan x n)

omit [IsCommJordan J] [IsFormallyReal J] [Module.Finite ℝ J] in
/-- **The vehicle.** A polynomial vanishing at every node of `S ∪ {0}` is divisible by the
nodal polynomial, and the annihilator absorbs the quotient. -/
theorem jeval_eq_zero_of_eval_eq_zero {x : J} {S : Finset ℝ} (h0S : (0 : ℝ) ∉ S)
    (hA : jeval x (∏ a ∈ S, (X - C a)) = 0) {p f : Polynomial ℝ} (hpf : X * p = f)
    (hf : ∀ ν ∈ insert (0 : ℝ) S, f.eval ν = 0) : jeval x p = 0 := by
  have hnodal : (∏ ν ∈ insert (0 : ℝ) S, (X - C ν)) = X * ∏ a ∈ S, (X - C a) := by
    rw [Finset.prod_insert h0S, map_zero, sub_zero]
  have hdvd : (∏ ν ∈ insert (0 : ℝ) S, (X - C ν)) ∣ f :=
    Finset.prod_dvd_of_coprime
      ((Polynomial.pairwise_coprime_X_sub_C (Function.injective_id (α := ℝ))).set_pairwise _)
      (fun ν hν => Polynomial.dvd_iff_isRoot.mpr (hf ν hν))
  rw [hnodal] at hdvd
  obtain ⟨h, hh⟩ := hdvd
  have hp : p = (∏ a ∈ S, (X - C a)) * h := by
    apply mul_left_cancel₀ (Polynomial.X_ne_zero (R := ℝ))
    rw [hpf, hh, mul_assoc]
  rw [hp, mul_comm]
  exact jeval_mul_eq_zero hA h

/-- **The spectral resolution, indexed by the eigenvalues.** -/
theorem exists_orthIdem_finset (x : J) :
    ∃ (S : Finset ℝ) (c : ℝ → J), (∀ a ∈ S, c a * c a = c a) ∧
      (∀ a ∈ S, ∀ a' ∈ S, a ≠ a' → c a * c a' = 0) ∧
      (∀ a, c a ∈ jspan x) ∧ x = ∑ a ∈ S, a • c a := by
  classical
  obtain ⟨S, h0S, hA⟩ := exists_split_annihilator x
  set b : ℝ → Polynomial ℝ := fun a => Lagrange.basis (insert (0 : ℝ) S) id a with hbdef
  set g : ℝ → Polynomial ℝ := fun a => (b a).divX with hgdef
  have h0T : (0 : ℝ) ∈ insert (0 : ℝ) S := Finset.mem_insert_self 0 S
  have hne : ∀ a ∈ S, a ≠ 0 := fun a ha h => h0S (h ▸ ha)
  have hinj : Set.InjOn (id : ℝ → ℝ) (↑(insert (0 : ℝ) S) : Set ℝ) := fun _ _ _ _ h => h
  have heval : ∀ a ∈ S, ∀ ν ∈ insert (0 : ℝ) S, (b a).eval ν = if ν = a then 1 else 0 := by
    intro a ha ν hν
    by_cases h : ν = a
    · subst h
      simpa [hbdef] using Lagrange.eval_basis_self hinj (Finset.mem_insert_of_mem ha)
    · simpa [hbdef, h] using Lagrange.eval_basis_of_ne (v := (id : ℝ → ℝ)) (Ne.symm h) hν
  have hXg : ∀ a ∈ S, b a = X * g a := by
    intro a ha
    have h0 : (b a).coeff 0 = 0 := by
      rw [Polynomial.coeff_zero_eq_eval_zero, heval a ha 0 h0T, if_neg (Ne.symm (hne a ha))]
    conv_lhs => rw [← Polynomial.X_mul_divX_add (b a)]
    rw [h0, map_zero, add_zero, hgdef]
  refine ⟨S, fun a => jeval x (g a), ?_, ?_, fun a => jeval_mem_jspan x (g a), ?_⟩
  · intro a ha
    have key : jeval x (X * g a * g a - g a) = 0 := by
      refine jeval_eq_zero_of_eval_eq_zero h0S hA (f := b a ^ 2 - b a) ?_ ?_
      · rw [hXg a ha]; ring
      · intro ν hν
        simp only [Polynomial.eval_sub, Polynomial.eval_pow, heval a ha ν hν]
        by_cases h : ν = a <;> simp [h]
    rw [map_sub, sub_eq_zero, ← jeval_mul] at key
    change jeval x (g a) * jeval x (g a) = jeval x (g a)
    exact key
  · intro a ha a' ha' haa'
    have key : jeval x (X * g a * g a') = 0 := by
      refine jeval_eq_zero_of_eval_eq_zero h0S hA (f := b a * b a') ?_ ?_
      · rw [hXg a ha, hXg a' ha']; ring
      · intro ν hν
        simp only [Polynomial.eval_mul, heval a ha ν hν, heval a' ha' ν hν]
        by_cases h : ν = a
        · rw [if_pos h, if_neg (by rw [h]; exact haa'), mul_zero]
        · rw [if_neg h, zero_mul]
    rw [← jeval_mul] at key
    change jeval x (g a) * jeval x (g a') = 0
    exact key
  · have key : jeval x (1 - ∑ a ∈ S, a • g a) = 0 := by
      refine jeval_eq_zero_of_eval_eq_zero h0S hA (f := X - ∑ a ∈ S, a • b a) ?_ ?_
      · rw [mul_sub, mul_one, Finset.mul_sum]
        congr 1
        exact Finset.sum_congr rfl fun a ha => by rw [mul_smul_comm, ← hXg a ha]
      · intro ν hν
        simp only [Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_finsetSum,
          Polynomial.eval_smul, smul_eq_mul]
        rcases Finset.mem_insert.mp hν with rfl | hνS
        · rw [Finset.sum_eq_zero fun a ha => by
            rw [heval a ha 0 hν, if_neg (Ne.symm (hne a ha)), mul_zero], sub_zero]
        · rw [Finset.sum_eq_single ν
            (fun a ha hane => by rw [heval a ha ν hν, if_neg (Ne.symm hane), mul_zero])
            (fun h => absurd hνS h),
            heval ν hνS ν hν, if_pos rfl, mul_one, sub_self]
    rw [map_sub, map_sum, jeval_one, sub_eq_zero] at key
    simpa using key

/-- **(E1), the single-element spectral theorem.** -/
theorem spectral_resolution (x : J) :
    ∃ (n : ℕ) (c : Fin n → J) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∀ i, c i ∈ jspan x) ∧ x = ∑ i, lam i • c i := by
  classical
  obtain ⟨S, c, hidem, horth, hmem, hx⟩ := exists_orthIdem_finset x
  refine ⟨S.card, fun i => c (S.equivFin.symm i), fun i => ((S.equivFin.symm i : ℝ)),
    ⟨fun i => hidem _ (S.equivFin.symm i).2, fun i j hij => ?_⟩, fun i => hmem _, ?_⟩
  · refine horth _ (S.equivFin.symm i).2 _ (S.equivFin.symm j).2 fun h => hij ?_
    exact S.equivFin.symm.injective (Subtype.ext h)
  · rw [hx, ← Finset.sum_coe_sort S (fun a => a • c a)]
    exact (Equiv.sum_comp S.equivFin.symm (fun a : {y // y ∈ S} => (a : ℝ) • c a)).symm

/-- **(E1) with completeness**, the unit carried as an ordinary hypothesis. -/
theorem spectral_resolution_complete (e : J) (he : ∀ y : J, e * y = y) (x : J) :
    ∃ (n : ℕ) (c : Fin n → J) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∑ i, c i) = e ∧ x = ∑ i, lam i • c i := by
  obtain ⟨n, c, lam, hfam, _, hx⟩ := spectral_resolution x
  have hss : (∑ i, c i) * (∑ i, c i) = ∑ i, c i := hfam.sum_idem Finset.univ
  have hsc : ∀ k, (∑ i, c i) * c k = c k := by
    intro k
    rw [Finset.sum_mul, Finset.sum_eq_single k (fun j _ hjk => hfam.orth j k hjk)
      (fun h => absurd (Finset.mem_univ k) h)]
    exact hfam.idem k
  have hes : (∑ i, c i) * e = ∑ i, c i := by rw [mul_comm, he]
  have hlast : (e - ∑ i, c i) * (e - ∑ i, c i) = e - ∑ i, c i := by
    rw [sub_mul, mul_sub, mul_sub, he, he, hss, hes, sub_self, sub_zero]
  have horthlast : ∀ k, (e - ∑ i, c i) * c k = 0 := by
    intro k
    rw [sub_mul, he, hsc, sub_self]
  refine ⟨n + 1, Fin.snoc c (e - ∑ i, c i), Fin.snoc lam 0, ⟨?_, ?_⟩, ?_, ?_⟩
  · intro i
    induction i using Fin.lastCases with
    | last => simpa using hlast
    | cast i => simpa using hfam.idem i
  · intro i j hij
    induction i using Fin.lastCases with
    | last =>
        induction j using Fin.lastCases with
        | last => exact absurd rfl hij
        | cast j => simpa using horthlast j
    | cast i =>
        induction j using Fin.lastCases with
        | last => simpa [mul_comm] using horthlast i
        | cast j =>
            simpa using hfam.orth i j fun h => hij (by rw [h])
  · rw [Fin.sum_univ_castSucc]
    simp
  · rw [Fin.sum_univ_castSucc]
    simpa using hx


/-! ## The evaluation identity on a resolution

`jeval x p` is morally `x·p(x)` (its `n`-th term is `p.coeff n • jpow x n` and `jpow x n` is
`x^{n+1}`).  On a spectral resolution `x = ∑ᵢ λᵢ cᵢ` over an orthogonal idempotent family it
therefore collapses to `∑ᵢ λᵢ·p(λᵢ) cᵢ`, which is the shape a functional calculus is built on.

`STATEMENT-MANIFEST.md` row 13 records this identity as absent from the tree; it is proved here.
It is *not* a functional calculus on its own — that additionally needs the resolution to be
canonical, which nothing here supplies. -/

section Calculus

variable {J : Type*} [NonUnitalNonAssocCommRing J] [IsCommJordan J] [Module ℝ J]
  [IsScalarTower ℝ J J]

omit [IsCommJordan J] in
/-- Scalars pull out of both factors of a Jordan product. -/
theorem smul_mul_smul_eq (a b : ℝ) (x y : J) : (a • x) * (b • y) = (a * b) • (x * y) := by
  have h2 : x * (b • y) = b • (x * y) := by
    rw [mul_comm x (b • y), smul_mul_assoc, mul_comm y x]
  rw [smul_mul_assoc, h2, smul_smul]

omit [IsCommJordan J] in
/-- **Elements spanned by one orthogonal idempotent family multiply coefficientwise.**  The
workhorse: cross terms die by orthogonality, diagonal terms collapse by idempotence.  Everything
else in this section is a corollary. -/
theorem sum_smul_mul_sum_smul_of_orthIdem {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (a b : Fin n → ℝ) :
    (∑ i, a i • c i) * (∑ i, b i • c i) = ∑ i, (a i * b i) • c i := by
  rw [Finset.sum_mul_sum]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [Finset.sum_eq_single i]
  · rw [smul_mul_smul_eq, hfam.idem i]
  · intro j _ hji
    rw [smul_mul_smul_eq, hfam.orth i j (Ne.symm hji), smul_zero]
  · intro h
    exact absurd (Finset.mem_univ i) h

omit [IsCommJordan J] in
/-- **Powers on a resolution.**  On an orthogonal idempotent family the `k`-th Jordan power of
`∑ᵢ λᵢ cᵢ` is `∑ᵢ λᵢ^{k+1} cᵢ`. -/
theorem jpow_sum_smul_of_orthIdem {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (lam : Fin n → ℝ) (k : ℕ) :
    jpow (∑ i, lam i • c i) k = ∑ i, (lam i) ^ (k + 1) • c i := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [jpow_succ, ih, sum_smul_mul_sum_smul_of_orthIdem hfam]
      refine Finset.sum_congr rfl fun i _ => ?_
      congr 1
      ring

/-- **The evaluation identity on a resolution.**  `jeval x p = ∑ᵢ λᵢ·p(λᵢ) cᵢ`.

The `λᵢ` factor in front of `p(λᵢ)` is not a slip: `jeval` is `x·p(x)`, not `p(x)`, because the
ambient algebra is not assumed unital and `jpow x 0 = x`. -/
theorem jeval_of_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (lam : Fin n → ℝ) (p : Polynomial ℝ) :
    jeval (∑ i, lam i • c i) p = ∑ i, (lam i * p.eval (lam i)) • c i := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq =>
      rw [map_add, hp, hq, ← Finset.sum_add_distrib]
      refine Finset.sum_congr rfl fun i _ => ?_
      rw [← add_smul, Polynomial.eval_add, mul_add]
  | monomial m a =>
      rw [jeval_monomial, jpow_sum_smul_of_orthIdem hfam, Finset.smul_sum]
      refine Finset.sum_congr rfl fun i _ => ?_
      rw [smul_smul, Polynomial.eval_monomial]
      congr 1
      ring


/-! ### The Jordan quadratic representation

`Q_a b = 2·a(ab) − (aa)b`.  ★ **Not a duplicate of `Necessity.quadRep`**, which is
`x ↦ √a·x·√a` built from *matrix* conjugation and the vendored continuous functional calculus.
That one is `HermitianMat`-specific and cannot transfer to `h₃(𝕆)` at all — matrix conjugation is
not even well-defined over a non-associative coordinate algebra.  `EJA/AlbertCarrier.lean` records
exactly this: both the square root and `Q_{√a}` "are stated over `HermitianMat`, not over the
class, so neither transfers to `h₃(𝕆)`".  The Jordan form below is the one that does, and it is
what `a·b = Q_{√a}b` must mean at EJA generality.

Linear in the acted-on argument by construction; the dependence on `a` is quadratic, which is why
it is not bundled as a bilinear map. -/

/-- **The Jordan quadratic representation** `Q_a = 2·L_a² − L_{a²}`. -/
noncomputable def quadJ (a : J) : J →ₗ[ℝ] J where
  toFun b := (2 : ℝ) • (a * (a * b)) - (a * a) * b
  map_add' b d := by
    simp only [mul_add, smul_add]
    abel
  map_smul' r b := by
    have hsm : ∀ (t : ℝ) (u v : J), u * (t • v) = t • (u * v) := by
      intro t u v
      rw [mul_comm u (t • v), smul_mul_assoc, mul_comm v u]
    simp only [RingHom.id_apply, hsm, smul_sub, smul_comm (2 : ℝ) r]

@[simp] theorem quadJ_apply (a b : J) : quadJ a b = (2 : ℝ) • (a * (a * b)) - (a * a) * b := rfl

/-- **`Q_a` at the unit returns `a²`** — the normalisation that makes `a·b = Q_{√a}b` reduce to
`a·e = a` at `b = e`, which is S3. -/
theorem quadJ_unit {e : J} (he : ∀ y : J, e * y = y) (a : J) : quadJ a e = a * a := by
  rw [quadJ_apply, mul_comm a e, he, mul_comm (a * a) e, he]
  module

/-- **`Q_e` is the identity.**  With `√e = e`, this is S3 (unitality) for the candidate product
`a · b = Q_{√a} b`, discharged outright. -/
theorem quadJ_unit_left {e : J} (he : ∀ y : J, e * y = y) (b : J) : quadJ e b = b := by
  rw [quadJ_apply]
  simp only [he]
  module

/-- **S1 (additivity in the acted-on argument) is free**, because `quadJ a` is a linear map by
construction.  Recorded as a named theorem rather than left implicit, so that the claim
"S1 and S3 fall out" is checkable rather than asserted. -/
theorem quadJ_add (a b d : J) : quadJ a (b + d) = quadJ a b + quadJ a d :=
  map_add _ _ _

/-- **The quadratic representation acts coefficientwise on a shared resolution:**
`Q_{∑ aᵢcᵢ} (∑ bᵢcᵢ) = ∑ aᵢ²bᵢ cᵢ`.

Both terms of `Q_x y = 2·x(xy) − x²y` collapse to `∑ aᵢ²bᵢ cᵢ` by coefficientwise multiplication,
and `2 − 1 = 1` leaves one copy.  This is the concrete face of the quadratic representation, and
it is what makes `Q` computable on the spectral side: squaring the subscript's eigenvalues,
leaving the argument's alone. -/
theorem quadJ_of_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (a b : Fin n → ℝ) :
    quadJ (∑ i, a i • c i) (∑ i, b i • c i) = ∑ i, (a i * a i * b i) • c i := by
  have hxy : (∑ i, a i • c i) * (∑ i, b i • c i) = ∑ i, (a i * b i) • c i :=
    sum_smul_mul_sum_smul_of_orthIdem hfam a b
  have hx2 : (∑ i, a i • c i) * (∑ i, a i • c i) = ∑ i, (a i * a i) • c i :=
    sum_smul_mul_sum_smul_of_orthIdem hfam a a
  rw [quadJ_apply, hxy, hx2, sum_smul_mul_sum_smul_of_orthIdem hfam,
    sum_smul_mul_sum_smul_of_orthIdem hfam]
  have hassoc : ∀ i, a i * (a i * b i) = a i * a i * b i := fun i => (mul_assoc _ _ _).symm
  simp only [hassoc, two_smul]
  abel

/-! ### Inverses and square roots on a resolution

`STATEMENT-MANIFEST.md` row 13 records that "no declaration produces an inverse".  These do, on a
resolution.  Both are `def`s over an explicitly given resolution rather than functions of the
element: the resolution `spectral_resolution_complete` produces is existential, and nothing in
the tree yet makes it canonical, so `jinvOfResolution c lam` is *an* inverse relative to `(c, lam)`
and `jsqrtOfResolution c lam` *a* square root, not "the" one.  Canonicity is a separate result and
is not claimed here. -/

/-- The inverse of `∑ᵢ λᵢ cᵢ` relative to the resolution `(c, lam)`: invert the eigenvalues. -/
noncomputable def jinvOfResolution {n : ℕ} (c : Fin n → J) (lam : Fin n → ℝ) : J :=
  ∑ i, (lam i)⁻¹ • c i

omit [IsCommJordan J] in
/-- **An inverse, produced.**  If no eigenvalue vanishes and the family is complete for `e`, then
`jinvOfResolution` is a two-sided inverse of `∑ᵢ λᵢ cᵢ` for `e` (two-sided is one-sided here: the
algebra is commutative). -/
theorem mul_jinvOfResolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hlam : ∀ i, lam i ≠ 0) {e : J} (hsum : (∑ i, c i) = e) :
    (∑ i, lam i • c i) * jinvOfResolution c lam = e := by
  rw [jinvOfResolution, sum_smul_mul_sum_smul_of_orthIdem hfam, ← hsum]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [mul_inv_cancel₀ (hlam i), one_smul]

/-- **`Q_x` sends the inverse to the element**: `Q_x (x⁻¹) = x` on a resolution with no vanishing
eigenvalue.  Coefficientwise this is `λ²·λ⁻¹ = λ`.

★ This is the first identity of the pseudo-inverse chain that `STATEMENT-MANIFEST.md` row 13
(`prop:pseudo-transfer`) is waiting on, and it is the shape the article's `Q_{√a}` argument uses
with `a` invertible. -/
theorem quadJ_jinvOfResolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hlam : ∀ i, lam i ≠ 0) :
    quadJ (∑ i, lam i • c i) (jinvOfResolution c lam) = ∑ i, lam i • c i := by
  rw [jinvOfResolution, quadJ_of_resolution hfam]
  refine Finset.sum_congr rfl fun i _ => ?_
  congr 1
  field_simp

/-- A square root of `∑ᵢ λᵢ cᵢ` relative to the resolution `(c, lam)`: take roots of the
eigenvalues.

★ **This is NOT new capability, and must not be read as any.**  `EJA/Order.lean`'s
`isSoS_iff_exists_sq` already produces a square root for every element of the cone, by this same
construction (`∑ᵢ √(max λᵢ 0) • qᵢ`) and via the same `nonneg_coeff_of_isSoS`.  The only thing
these two declarations add is the same statement one level down — over the ring vocabulary
(`NonUnitalNonAssocCommRing` + `IsCommJordan`) rather than over a bundled bilinear map `m` — which
is the side of `EJA/Bridge.lean`'s `ringOfBilinear` crossing the resolution lemmas above live on.
Use `isSoS_iff_exists_sq` where the order is what matters. -/
noncomputable def jsqrtOfResolution {n : ℕ} (c : Fin n → J) (lam : Fin n → ℝ) : J :=
  ∑ i, Real.sqrt (lam i) • c i

omit [IsCommJordan J] in
/-- **A square root, produced.**  Needs the eigenvalues nonnegative, which is where the order
enters; `Real.sqrt` is junk-valued below zero and the identity fails there. -/
theorem jsqrtOfResolution_mul_self {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hlam : ∀ i, 0 ≤ lam i) :
    jsqrtOfResolution c lam * jsqrtOfResolution c lam = ∑ i, lam i • c i := by
  rw [jsqrtOfResolution, sum_smul_mul_sum_smul_of_orthIdem hfam]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [Real.mul_self_sqrt (hlam i)]

omit [IsCommJordan J] in
/-- **Existence form.**  An element carrying a resolution with nonnegative eigenvalues has a
square root.  ★ Deriving the hypothesis from `0 ≤ x` is *already done* on the bilinear-map side —
`EJA/Order.lean`'s `nonneg_coeff_of_isSoS` proves a sum of squares has nonnegative coefficients,
and `isSoS_iff_exists_sq` chains it to exactly this conclusion.  Nothing here supersedes that. -/
theorem exists_mul_self_eq_of_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hlam : ∀ i, 0 ≤ lam i) {x : J} (hx : x = ∑ i, lam i • c i) :
    ∃ s : J, s * s = x :=
  ⟨jsqrtOfResolution c lam, by rw [jsqrtOfResolution_mul_self hfam hlam, hx]⟩

end Calculus


omit [IsCommJordan J] in
/-- **Coefficients over an orthogonal idempotent family are pinned by the element.**  Pairing with
`cₖ` isolates the `k`-th coefficient, so a vanishing combination has vanishing coefficients at
every nonzero member.  (At a *zero* member the coefficient is genuinely free — `0 • 0 = 1 • 0` —
which is why the nonvanishing hypothesis is there and cannot be dropped.) -/
theorem sum_smul_mul_idem {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (a : Fin n → ℝ) (k : Fin n) : (∑ i, a i • c i) * c k = a k • c k := by
  rw [Finset.sum_mul, Finset.sum_eq_single k]
  · rw [smul_mul_assoc, hfam.idem k]
  · intro j _ hjk
    rw [smul_mul_assoc, hfam.orth j k hjk, smul_zero]
  · intro hcon
    exact absurd (Finset.mem_univ k) hcon

/-- **A spectral projection reads its own coefficient off a function of the element.**  Combined
with `jeval_of_resolution` this is `(jeval x p) ∘ cₖ = λₖ·p(λₖ) cₖ` — the Jordan-generality form of
"the functional calculus acts by the scalar `f(λ)` on the spectral projection at `λ`".

`STATEMENT-MANIFEST.md` row 22 names exactly that shape as its residue, in the concrete
`HermitianMat` vocabulary (`cfc f a` composed with `q` equal to `f(λ)·q`); this is the statement it
needs, one layer up.  The bridge from `jeval` to the vendored `cfc` is **not** built here. -/
theorem jeval_mul_idem {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (lam : Fin n → ℝ) (p : Polynomial ℝ) (k : Fin n) :
    jeval (∑ i, lam i • c i) p * c k = (lam k * p.eval (lam k)) • c k := by
  rw [jeval_of_resolution hfam, sum_smul_mul_idem hfam]

theorem coeff_eq_zero_of_sum_smul_eq_zero {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {a : Fin n → ℝ} (h : (∑ i, a i • c i) = 0) {k : Fin n} (hk : c k ≠ 0) : a k = 0 := by
  have hmul := sum_smul_mul_idem hfam a k
  rw [h, zero_mul] at hmul
  exact (smul_eq_zero.mp hmul.symm).resolve_right hk

/-- **The annihilator of `x` is read off its resolution.**  `p` annihilates `x` exactly when
`λᵢ·p(λᵢ)` vanishes at every idempotent that is actually present.

This is what makes the eigenvalue list a function of `x` rather than of the resolution: `jann x`
is defined from `x` alone, and this identifies it with a condition on the `λᵢ`. -/
theorem jeval_eq_zero_iff_of_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (lam : Fin n → ℝ) (p : Polynomial ℝ) :
    jeval (∑ i, lam i • c i) p = 0 ↔ ∀ i, c i ≠ 0 → lam i * p.eval (lam i) = 0 := by
  rw [jeval_of_resolution hfam]
  constructor
  · intro h i hi
    exact coeff_eq_zero_of_sum_smul_eq_zero hfam h hi
  · intro h
    refine Finset.sum_eq_zero fun i _ => ?_
    by_cases hi : c i = 0
    · rw [hi, smul_zero]
    · rw [h i hi, zero_smul]

/-- **The idempotents of a distinct-eigenvalue resolution are polynomials in `x`.**

With the eigenvalues distinct, Lagrange interpolation produces a real polynomial that is
`(λₖ)⁻¹` at `λₖ` and `0` at every other eigenvalue; `jeval_of_resolution` then evaluates it to
`cₖ` exactly.  So `cₖ` is not an artefact of the choice of resolution — it is a *function of `x`*,
recovered by a polynomial that depends only on the eigenvalue list.

★ **This is the canonicity step, and it is why distinctness was needed.**  Without injective
eigenvalues no such interpolant exists, and repeated-eigenvalue idempotents genuinely are not
determined by `x` — only their sum is.

★ The hypothesis `λₖ ≠ 0` is not removable and is not a defect: `jeval` is `x·p(x)`, so
everything it produces is annihilated by the zero eigenvalue's idempotent.  That idempotent is
still determined, as `e − ∑_{i ≠ k} cᵢ`, but not by this route. -/
theorem idem_eq_jeval_lagrange {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hinj : Function.Injective lam) (k : Fin n) (hk : lam k ≠ 0) :
    jeval (∑ i, lam i • c i) (C (lam k)⁻¹ * Lagrange.basis Finset.univ lam k) = c k := by
  rw [jeval_of_resolution hfam, Finset.sum_eq_single k]
  · rw [Polynomial.eval_mul, Polynomial.eval_C,
      Lagrange.eval_basis_self hinj.injOn (Finset.mem_univ k), mul_one,
      mul_inv_cancel₀ hk, one_smul]
  · intro i _ hik
    rw [Polynomial.eval_mul,
      Lagrange.eval_basis_of_ne (Ne.symm hik) (Finset.mem_univ i), mul_zero, mul_zero, zero_smul]
  · intro h
    exact absurd (Finset.mem_univ k) h

/-- **The nonzero spectrum is a function of the element, not of the resolution.**

A nonzero `t` carries a present idempotent in *some* resolution of `x` exactly when every
annihilator of `x` vanishes at `t`.  The right-hand side mentions only `x`, so any two resolutions
of the same element expose the same nonzero eigenvalues.

Backwards is the substantive direction: `∏ (X − λᵢ)` over the present nonzero eigenvalues
annihilates `x` — at a zero eigenvalue the `λᵢ` factor of `jeval` kills the term, and at a nonzero
one the product does — so it must vanish at `t`, forcing `t` to be one of them.

★ Zero is excluded and must be: `jeval` is `x·p(x)`, so the zero eigenvalue is invisible to every
annihilator and cannot be detected this way. -/
theorem exists_idem_iff_forall_jann_eval {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    (lam : Fin n → ℝ) {t : ℝ} (ht : t ≠ 0) :
    (∃ i, c i ≠ 0 ∧ lam i = t) ↔ ∀ p ∈ jann (∑ i, lam i • c i), p.eval t = 0 := by
  classical
  constructor
  · rintro ⟨i, hci, rfl⟩ p hp
    have hzero := (jeval_eq_zero_iff_of_resolution hfam lam p).mp (mem_jann.mp hp) i hci
    exact (mul_eq_zero.mp hzero).resolve_left ht
  · intro h
    set S : Finset (Fin n) := Finset.univ.filter (fun i => c i ≠ 0 ∧ lam i ≠ 0) with hS
    set q : Polynomial ℝ := ∏ i ∈ S, (X - C (lam i)) with hq
    have hqann : q ∈ jann (∑ i, lam i • c i) := by
      rw [mem_jann]
      refine (jeval_eq_zero_iff_of_resolution hfam lam q).mpr fun i hci => ?_
      by_cases hli : lam i = 0
      · rw [hli, zero_mul]
      · have hiS : i ∈ S := Finset.mem_filter.mpr ⟨Finset.mem_univ i, hci, hli⟩
        have hev : q.eval (lam i) = 0 := by
          rw [hq, Polynomial.eval_prod]
          exact Finset.prod_eq_zero hiS (by simp)
        rw [hev, mul_zero]
    have hqt : q.eval t = 0 := h q hqann
    rw [hq, Polynomial.eval_prod] at hqt
    obtain ⟨i, hiS, hi0⟩ := Finset.prod_eq_zero_iff.mp hqt
    refine ⟨i, (Finset.mem_filter.mp hiS).2.1, ?_⟩
    simp only [Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_C, sub_eq_zero] at hi0
    exact hi0.symm

/-- **A Lagrange basis polynomial depends only on the set of nodes, not on how they are indexed.**

`Lagrange.basis s v i = ∏_{j ≠ i} basisDivisor (v i) (v j)`, so two injective indexings with the
same image and the same distinguished node give literally the same product.  Stated here because
uniqueness of a spectral resolution needs to compare interpolants built over two different index
types. -/
theorem lagrange_basis_congr {n m : ℕ} {v : Fin n → ℝ} {w : Fin m → ℝ}
    (hv : Function.Injective v) (hw : Function.Injective w)
    (himg : Finset.image v Finset.univ = Finset.image w Finset.univ)
    {i : Fin n} {j : Fin m} (hij : v i = w j) :
    Lagrange.basis Finset.univ v i = Lagrange.basis Finset.univ w j := by
  classical
  have hstep : ∀ {k : ℕ} (u : Fin k → ℝ), Function.Injective u → ∀ a : Fin k,
      Lagrange.basis Finset.univ u a
        = ∏ t ∈ (Finset.image u Finset.univ).erase (u a), Lagrange.basisDivisor (u a) t := by
    intro k u hu a
    rw [Lagrange.basis, show (Finset.image u Finset.univ).erase (u a)
        = (Finset.univ.erase a).image u from (Finset.image_erase hu Finset.univ a).symm,
      Finset.prod_image (fun p _ q _ h => hu h)]
  rw [hstep v hv i, hstep w hw j, hij, himg]

/-- **Uniqueness of a resolution's idempotents.**  Two distinct-eigenvalue resolutions of the same
element, over the same eigenvalue set, assign the same idempotent to a shared nonzero eigenvalue.

Both idempotents are `jeval x` of the *same* interpolant — the element is the same by hypothesis
and the interpolant is the same by `lagrange_basis_congr` — so they are equal for the reason the
canonicity argument wants: neither is a choice. -/
theorem idem_unique_of_resolutions {n m : ℕ} {c : Fin n → J} {d : Fin m → J}
    (hc : IsOrthIdemFamily c) (hd : IsOrthIdemFamily d)
    {lc : Fin n → ℝ} {ld : Fin m → ℝ}
    (hinjc : Function.Injective lc) (hinjd : Function.Injective ld)
    (himg : Finset.image lc Finset.univ = Finset.image ld Finset.univ)
    (hx : (∑ i, lc i • c i) = ∑ j, ld j • d j)
    {k : Fin n} {l : Fin m} (hkl : lc k = ld l) (hk : lc k ≠ 0) :
    c k = d l := by
  have hk' : ld l ≠ 0 := hkl ▸ hk
  rw [← idem_eq_jeval_lagrange hc hinjc k hk, ← idem_eq_jeval_lagrange hd hinjd l hk', hx, hkl,
    lagrange_basis_congr hinjc hinjd himg hkl]

open scoped Classical in
/-- **Two resolutions of the same element have the same nonzero spectrum**, as Finsets.

Immediate from `exists_idem_iff_forall_jann_eval`: membership on each side is the same condition on
`jann x`, and `x` is the same element.  Zero belongs to neither side by construction, so the
excluded case costs nothing.

★★ **This is NOT the hypothesis `idem_unique_of_resolutions` takes, and an earlier note here
wrongly said it discharged it.**  That theorem asks for `image lc univ = image ld univ` — the
*full* eigenvalue sets — because it routes through `lagrange_basis_congr`, which needs the two
interpolants to be equal *as polynomials*, and `Lagrange.basis Finset.univ` is built over the
whole index type.  This theorem gives equality of the **filtered** images only, and the two
genuinely differ: a resolution may carry `c i = 0` with `lc i = 7`, a phantom eigenvalue
contributing nothing to `x`, where another does not.

★ **The repair, recorded because the current route is stronger than it needs to be.**  Polynomial
equality is not required — only that the two interpolants agree *modulo* `jann x`.  They do: both
are `λₖ⁻¹` at `λₖ` and `0` at every other nonzero eigenvalue, so their difference vanishes on the
nonzero spectrum, and `jeval_eq_zero_iff_of_resolution` then gives `jeval x (P₁ − P₂) = 0` — at a
zero eigenvalue the `λᵢ` factor kills the term regardless.  Rerouting `idem_unique_of_resolutions`
through that argument would let it take *this* theorem as its hypothesis.  Not done. -/
theorem nonzero_spectrum_eq_of_resolutions {n m : ℕ} {c : Fin n → J} {d : Fin m → J}
    (hc : IsOrthIdemFamily c) (hd : IsOrthIdemFamily d)
    (lc : Fin n → ℝ) (ld : Fin m → ℝ)
    (hx : (∑ i, lc i • c i) = ∑ j, ld j • d j) :
    (Finset.univ.filter (fun i => c i ≠ 0 ∧ lc i ≠ 0)).image lc
      = (Finset.univ.filter (fun j => d j ≠ 0 ∧ ld j ≠ 0)).image ld := by
  classical
  ext t
  simp only [Finset.mem_image, Finset.mem_filter, Finset.mem_univ, true_and]
  by_cases ht : t = 0
  · subst ht
    constructor
    · rintro ⟨i, ⟨-, hne⟩, hi⟩; exact absurd hi hne
    · rintro ⟨j, ⟨-, hne⟩, hj⟩; exact absurd hj hne
  · have hL : (∃ i, (c i ≠ 0 ∧ lc i ≠ 0) ∧ lc i = t) ↔ ∃ i, c i ≠ 0 ∧ lc i = t := by
      constructor
      · rintro ⟨i, ⟨hci, -⟩, hi⟩; exact ⟨i, hci, hi⟩
      · rintro ⟨i, hci, hi⟩; exact ⟨i, ⟨hci, hi ▸ ht⟩, hi⟩
    have hR : (∃ j, (d j ≠ 0 ∧ ld j ≠ 0) ∧ ld j = t) ↔ ∃ j, d j ≠ 0 ∧ ld j = t := by
      constructor
      · rintro ⟨j, ⟨hdj, -⟩, hj⟩; exact ⟨j, hdj, hj⟩
      · rintro ⟨j, hdj, hj⟩; exact ⟨j, ⟨hdj, hj ▸ ht⟩, hj⟩
    rw [hL, hR, exists_idem_iff_forall_jann_eval hc lc ht,
      exists_idem_iff_forall_jann_eval hd ld ht, hx]

open scoped Classical in
/-- **Uniqueness of a resolution's idempotents, under the hypothesis the tree can actually
supply.**

`idem_unique_of_resolutions` above wants the *full* eigenvalue images to agree, which nothing
proves and which can genuinely fail — a phantom eigenvalue at a zero idempotent sits in the image
and contributes nothing to `x`.  This version takes the **filtered** images, which is exactly
`nonzero_spectrum_eq_of_resolutions`.

The route is weaker and therefore works: the two interpolants need not be equal as polynomials,
only congruent modulo `jann x`.  They are — each is `λ⁻¹` at its own eigenvalue and `0` at every
other *nonzero* one — and `jeval_eq_zero_iff_of_resolution` converts that into
`jeval x (P₁ − P₂) = 0`, the zero eigenvalue being killed by `jeval`'s own `λᵢ` factor. -/
theorem idem_unique_of_nonzero_spectrum {n m : ℕ} {c : Fin n → J} {d : Fin m → J}
    (hc : IsOrthIdemFamily c) (hd : IsOrthIdemFamily d)
    {lc : Fin n → ℝ} {ld : Fin m → ℝ}
    (hinjc : Function.Injective lc) (hinjd : Function.Injective ld)
    (hspec : (Finset.univ.filter (fun i => c i ≠ 0 ∧ lc i ≠ 0)).image lc
      = (Finset.univ.filter (fun j => d j ≠ 0 ∧ ld j ≠ 0)).image ld)
    (hx : (∑ i, lc i • c i) = ∑ j, ld j • d j)
    {k : Fin n} {l : Fin m} (hkl : lc k = ld l) (hk : lc k ≠ 0) :
    c k = d l := by
  classical
  have hk' : ld l ≠ 0 := hkl ▸ hk
  have h1 : jeval (∑ i, lc i • c i) (C (lc k)⁻¹ * Lagrange.basis Finset.univ lc k) = c k :=
    idem_eq_jeval_lagrange hc hinjc k hk
  have h2 : jeval (∑ j, ld j • d j) (C (ld l)⁻¹ * Lagrange.basis Finset.univ ld l) = d l :=
    idem_eq_jeval_lagrange hd hinjd l hk'
  rw [← h1, ← h2, ← hx, ← sub_eq_zero, ← map_sub]
  refine (jeval_eq_zero_iff_of_resolution hc lc _).mpr fun i hci => ?_
  by_cases hli : lc i = 0
  · rw [hli, zero_mul]
  · have hmem : lc i ∈ (Finset.univ.filter (fun j => d j ≠ 0 ∧ ld j ≠ 0)).image ld := by
      rw [← hspec]
      exact Finset.mem_image_of_mem lc (Finset.mem_filter.mpr ⟨Finset.mem_univ i, hci, hli⟩)
    obtain ⟨j, hj, hjl⟩ := Finset.mem_image.mp hmem
    have hev : (C (lc k)⁻¹ * Lagrange.basis Finset.univ lc k).eval (lc i)
        = (C (ld l)⁻¹ * Lagrange.basis Finset.univ ld l).eval (lc i) := by
      by_cases hik : i = k
      · rw [Polynomial.eval_mul, Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_C,
          hik, Lagrange.eval_basis_self hinjc.injOn (Finset.mem_univ k), hkl,
          Lagrange.eval_basis_self hinjd.injOn (Finset.mem_univ l)]
      · have hjne : j ≠ l := fun h => hik (hinjc (by rw [hkl, ← hjl, h]))
        rw [Polynomial.eval_mul, Polynomial.eval_mul,
          Lagrange.eval_basis_of_ne (Ne.symm hik) (Finset.mem_univ i), ← hjl,
          Lagrange.eval_basis_of_ne (Ne.symm hjne) (Finset.mem_univ j), mul_zero, mul_zero]
    rw [Polynomial.eval_sub, hev, sub_self, mul_zero]

/-- **The square root of a resolved element is `jeval` of a polynomial.**

Every idempotent carrying a nonzero eigenvalue is `jeval x` of a Lagrange interpolant
(`idem_eq_jeval_lagrange`), and `jeval x` is linear, so the whole square root is `jeval x` of a
single polynomial built from the eigenvalue list.

★ **This is the payoff of the canonicity chain.**  The zero eigenvalue needs no separate
treatment here — `√0 = 0` deletes its term — so the square root depends only on the *nonzero*
spectrum and its idempotents, and `exists_idem_iff_forall_jann_eval` and
`idem_unique_of_resolutions` show both of those are functions of `x`.  A square root produced this
way is therefore not a choice, which is what `SequentialProductOnEJA` needs and what
`isSoS_iff_exists_sq`, which merely *exhibits* one, does not give. -/
theorem sqrt_sum_eq_jeval {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hinj : Function.Injective lam) :
    (∑ i, Real.sqrt (lam i) • c i)
      = jeval (∑ i, lam i • c i)
          (∑ i ∈ Finset.univ.filter (fun i => lam i ≠ 0),
            Real.sqrt (lam i) • (C (lam i)⁻¹ * Lagrange.basis Finset.univ lam i)) := by
  classical
  rw [map_sum]
  have hterm : ∀ i ∈ Finset.univ.filter (fun i => lam i ≠ 0),
      jeval (∑ j, lam j • c j)
          (Real.sqrt (lam i) • (C (lam i)⁻¹ * Lagrange.basis Finset.univ lam i))
        = Real.sqrt (lam i) • c i := by
    intro i hi
    rw [map_smul, idem_eq_jeval_lagrange hfam hinj i (Finset.mem_filter.mp hi).2]
  rw [Finset.sum_congr rfl hterm]
  refine (Finset.sum_subset (Finset.filter_subset _ _) ?_).symm
  intro i _ hi
  have hz : lam i = 0 := by
    by_contra hne
    exact hi (Finset.mem_filter.mpr ⟨Finset.mem_univ i, hne⟩)
  rw [hz, Real.sqrt_zero, zero_smul]

/-- **The square root does not depend on the resolution.**

Both sums collapse onto their nonzero-eigenvalue parts (`√0 = 0`); those index sets carry the same
eigenvalues (`nonzero_spectrum_eq_of_resolutions`); and matched eigenvalues carry the same
idempotent (`idem_unique_of_nonzero_spectrum`).  The bijection sends `i` to the unique `j` with
`ld j = lc i`, which exists by the spectrum equality and is unique by injectivity.

★ **This is the theorem that licenses a definition of `√`.**  Everything before it showed the
ingredients are determined by `x`; this shows the assembled sum is. -/
theorem sqrt_sum_eq_of_resolutions {n m : ℕ} {c : Fin n → J} {d : Fin m → J}
    (hc : IsOrthIdemFamily c) (hd : IsOrthIdemFamily d)
    {lc : Fin n → ℝ} {ld : Fin m → ℝ}
    (hinjc : Function.Injective lc) (hinjd : Function.Injective ld)
    (hx : (∑ i, lc i • c i) = ∑ j, ld j • d j) :
    (∑ i, Real.sqrt (lc i) • c i) = ∑ j, Real.sqrt (ld j) • d j := by
  classical
  have hspec := nonzero_spectrum_eq_of_resolutions hc hd lc ld hx
  have hcollapse : ∀ {k : ℕ} (u : Fin k → J) (lu : Fin k → ℝ),
      (∑ i ∈ Finset.univ.filter (fun i => u i ≠ 0 ∧ lu i ≠ 0), Real.sqrt (lu i) • u i)
        = ∑ i, Real.sqrt (lu i) • u i := by
    intro k u lu
    refine Finset.sum_subset (Finset.filter_subset _ _) fun i _ hi => ?_
    by_cases hu : u i = 0
    · rw [hu, smul_zero]
    · have hz : lu i = 0 := by
        by_contra hne
        exact hi (Finset.mem_filter.mpr ⟨Finset.mem_univ i, hu, hne⟩)
      rw [hz, Real.sqrt_zero, zero_smul]
  rw [← hcollapse c lc, ← hcollapse d ld]
  have hfwd : ∀ i ∈ Finset.univ.filter (fun i => c i ≠ 0 ∧ lc i ≠ 0),
      ∃ j, j ∈ Finset.univ.filter (fun j => d j ≠ 0 ∧ ld j ≠ 0) ∧ ld j = lc i := by
    intro i hi
    have hmem : lc i ∈ (Finset.univ.filter (fun j => d j ≠ 0 ∧ ld j ≠ 0)).image ld := by
      rw [← hspec]; exact Finset.mem_image_of_mem lc hi
    obtain ⟨j, hj, hjl⟩ := Finset.mem_image.mp hmem
    exact ⟨j, hj, hjl⟩
  have hbwd : ∀ j ∈ Finset.univ.filter (fun j => d j ≠ 0 ∧ ld j ≠ 0),
      ∃ i, i ∈ Finset.univ.filter (fun i => c i ≠ 0 ∧ lc i ≠ 0) ∧ lc i = ld j := by
    intro j hj
    have hmem : ld j ∈ (Finset.univ.filter (fun i => c i ≠ 0 ∧ lc i ≠ 0)).image lc := by
      rw [hspec]; exact Finset.mem_image_of_mem ld hj
    obtain ⟨i, hi, hil⟩ := Finset.mem_image.mp hmem
    exact ⟨i, hi, hil⟩
  refine Finset.sum_bij' (fun i hi => (hfwd i hi).choose) (fun j hj => (hbwd j hj).choose)
    (fun i hi => (hfwd i hi).choose_spec.1) (fun j hj => (hbwd j hj).choose_spec.1)
    ?_ ?_ (fun i hi => ?_)
  · intro i hi
    refine hinjc ?_
    have h1 := (hbwd ((hfwd i hi).choose) ((hfwd i hi).choose_spec.1)).choose_spec.2
    have h2 := (hfwd i hi).choose_spec.2
    exact h1.trans h2
  · intro j hj
    refine hinjd ?_
    have h1 := (hfwd ((hbwd j hj).choose) ((hbwd j hj).choose_spec.1)).choose_spec.2
    have h2 := (hbwd j hj).choose_spec.2
    exact h1.trans h2
  have hval : ld ((hfwd i hi).choose) = lc i := (hfwd i hi).choose_spec.2
  have hne : lc i ≠ 0 := (Finset.mem_filter.mp hi).2.2
  have hidem : c i = d ((hfwd i hi).choose) :=
    idem_unique_of_nonzero_spectrum hc hd hinjc hinjd hspec hx hval.symm hne
  rw [hval, hidem]

/-- **A resolution with distinct eigenvalues.**  Merging the idempotents that share an eigenvalue
leaves an orthogonal idempotent family, still complete for `e`, whose coefficients are injective.

This is the first step toward a **canonical** resolution, which is what the tree actually lacks.
Without distinctness the same element has many resolutions, differing in how a repeated eigenvalue
is split among idempotents, so no function of `x` alone can be read off one — which is exactly why
`jinvOfResolution` and `jsqrtOfResolution` above are relative to a resolution rather than functions
of the element, and why `SequentialProductOnEJA` still has no inhabitant. -/
theorem exists_resolution_distinct (e : J) (he : ∀ y : J, e * y = y) (x : J) :
    ∃ (n : ℕ) (c : Fin n → J) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∑ i, c i) = e ∧ x = ∑ i, lam i • c i ∧
        Function.Injective lam := by
  classical
  obtain ⟨m, q, mu, hfam, hsum, hx⟩ := spectral_resolution_complete e he x
  set S : Finset ℝ := Finset.image mu Finset.univ with hSdef
  set d : ℝ → J := fun t => ∑ i ∈ Finset.univ.filter (fun i => mu i = t), q i with hddef
  have hmaps : ∀ i ∈ (Finset.univ : Finset (Fin m)), mu i ∈ S := fun i _ =>
    Finset.mem_image_of_mem mu (Finset.mem_univ i)
  have hdidem : ∀ t, d t * d t = d t := fun t => hfam.sum_idem _
  have hdorth : ∀ t u, t ≠ u → d t * d u = 0 := by
    intro t u htu
    rw [hddef]
    simp only
    rw [Finset.sum_mul_sum]
    refine Finset.sum_eq_zero fun i hi => Finset.sum_eq_zero fun j hj => ?_
    refine hfam.orth i j ?_
    rintro rfl
    exact htu (((Finset.mem_filter.mp hi).2).symm.trans (Finset.mem_filter.mp hj).2)
  have hdsum : (∑ t ∈ S, d t) = e := by
    rw [hddef]
    simp only
    rw [Finset.sum_fiberwise_of_maps_to hmaps]
    exact hsum
  have hxd : x = ∑ t ∈ S, t • d t := by
    rw [hx, ← Finset.sum_fiberwise_of_maps_to hmaps (fun i => mu i • q i)]
    refine Finset.sum_congr rfl fun t _ => ?_
    rw [hddef]
    simp only
    rw [Finset.smul_sum]
    exact Finset.sum_congr rfl fun i hi => by rw [(Finset.mem_filter.mp hi).2]
  have hinj : Function.Injective (fun k : Fin S.card => ((S.equivFin.symm k : ℝ))) := by
    intro k l hkl
    exact S.equivFin.symm.injective (Subtype.ext hkl)
  refine ⟨S.card, fun k => d ((S.equivFin.symm k : ℝ)), fun k => ((S.equivFin.symm k : ℝ)),
    ⟨fun k => hdidem _, fun k l hkl => hdorth _ _ fun h => hkl (hinj h)⟩, ?_, ?_, hinj⟩
  · rw [← hdsum, ← Finset.sum_coe_sort S d]
    exact Equiv.sum_comp S.equivFin.symm (fun a : {y // y ∈ S} => d (a : ℝ))
  · rw [hxd, ← Finset.sum_coe_sort S (fun t => t • d t)]
    exact (Equiv.sum_comp S.equivFin.symm (fun a : {y // y ∈ S} => (a : ℝ) • d (a : ℝ))).symm


omit [IsCommJordan J] [IsFormallyReal J] [Module.Finite ℝ J] in
/-- **The square-root identity, needing nonnegativity only where it can be observed.**

A resolution's coefficient at a *zero* idempotent is unconstrained — `0 • 0 = 1 • 0` — so
demanding `0 ≤ λᵢ` everywhere asks for more than the cone can supply.  Where `cᵢ = 0` the term
vanishes on both sides regardless. -/
theorem jsqrtOfResolution_mul_self' {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hlam : ∀ i, c i ≠ 0 → 0 ≤ lam i) :
    jsqrtOfResolution c lam * jsqrtOfResolution c lam = ∑ i, lam i • c i := by
  rw [jsqrtOfResolution, sum_smul_mul_sum_smul_of_orthIdem hfam]
  refine Finset.sum_congr rfl fun i _ => ?_
  by_cases hi : c i = 0
  · rw [hi, smul_zero, smul_zero]
  · rw [Real.mul_self_sqrt (hlam i hi)]

/-- **`a · a⁻¹ = 1` for the Lüders product** — the standard-product half of
`STATEMENT-MANIFEST.md` row 13 (`prop:pseudo-transfer`), at EJA generality.

The Lüders product is `a · b = Q_{√a} b`, and `Q` acts coefficientwise with the subscript's
eigenvalues squared, so `a · a⁻¹` has coefficients `(√λᵢ)²·λᵢ⁻¹ = λᵢ·λᵢ⁻¹ = 1` and the sum is the
completeness relation `∑ᵢ cᵢ = e`.  Nonnegativity is needed to undo the square root, and
nonvanishing to invert.

★ The row's *other* half — the same identity for an **unknown** S1–S7 product — is not this
theorem and does not follow from it. -/
theorem luders_jsqrt_jinv {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hnn : ∀ i, 0 ≤ lam i) (hne : ∀ i, lam i ≠ 0)
    {e : J} (hsum : (∑ i, c i) = e) :
    quadJ (jsqrtOfResolution c lam) (jinvOfResolution c lam) = e := by
  rw [jsqrtOfResolution, jinvOfResolution, quadJ_of_resolution hfam, ← hsum]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [Real.mul_self_sqrt (hnn i), mul_inv_cancel₀ (hne i), one_smul]

/-- **The Lüders product is coefficientwise on a shared resolution:**
`a · b = ∑ᵢ λᵢμᵢ cᵢ` when `a = ∑ λᵢcᵢ` and `b = ∑ μᵢcᵢ` over one orthogonal idempotent family.

`Q` squares its subscript's eigenvalues (`quadJ_of_resolution`) and `√` halves them, so the two
operations cancel and the product reads off as multiplication of coefficients.

★ **This is the engine for S1–S7 on simultaneously-resolved elements.**  Every sequential-product
axiom — additivity, unitality, orthogonality symmetry, compatible associativity, the two
multiplicativity clauses — becomes a statement about real numbers once both arguments are
diagonal in one family, because `λᵢμᵢ` is commutative and associative.  What that does *not* do is
prove the axioms in general: it reduces them to the claim that the relevant elements share a
resolution, which for compatible effects is simultaneous diagonalisation and is **not** proved
here. -/
theorem luders_of_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {lam : Fin n → ℝ} (hnn : ∀ i, 0 ≤ lam i) (mu : Fin n → ℝ) :
    quadJ (jsqrtOfResolution c lam) (∑ i, mu i • c i) = ∑ i, (lam i * mu i) • c i := by
  rw [jsqrtOfResolution, quadJ_of_resolution hfam]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [Real.mul_self_sqrt (hnn i)]

/-! ### `jsqrt`: the square root as a function

`sqrt_sum_eq_of_resolutions` says the sum `∑ √λᵢ cᵢ` does not depend on which resolution produced
it, and `exists_resolution_distinct` says one always exists.  Together those are exactly what a
definition needs, so here it is: `jsqrt e he x` is *the* square root, not a choice.

★ The `Classical.choose` in the definition is harmless precisely because of the well-definedness
theorem — `jsqrt_eq_of_resolution` below shows the value agrees with *every* admissible
resolution, so nothing depends on which one choice returns. -/

/-- **The square root of `x`, as a function.** -/
noncomputable def jsqrt (e : J) (he : ∀ y : J, e * y = y) (x : J) : J :=
  ∑ i, Real.sqrt ((exists_resolution_distinct e he x).choose_spec.choose_spec.choose i) •
    (exists_resolution_distinct e he x).choose_spec.choose i

/-- **`jsqrt` agrees with every admissible resolution**, which is what makes the `Classical.choose`
in its definition invisible. -/
theorem jsqrt_eq_of_resolution (e : J) (he : ∀ y : J, e * y = y) (x : J)
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hinj : Function.Injective lam) (hx : x = ∑ i, lam i • c i) :
    jsqrt e he x = ∑ i, Real.sqrt (lam i) • c i := by
  obtain ⟨hfam', -, hx', hinj'⟩ :=
    (exists_resolution_distinct e he x).choose_spec.choose_spec.choose_spec
  exact sqrt_sum_eq_of_resolutions hfam' hfam hinj' hinj (hx'.symm.trans hx)

/-- **`jsqrt` agrees with every resolution, injectivity not required.**  Idempotents sharing a
coefficient merge into the fibers of the coefficient map — the same coalescing
`exists_resolution_distinct` performs — and the merged resolution has distinct coefficients, so
`jsqrt_eq_of_resolution` reads `jsqrt` off it.  `√` takes one value per fiber, so the merged sum
un-merges into the stated one.  ★ No sign condition and no completeness enter: members sharing
a *negative* coefficient land in one fiber, where `Real.sqrt`'s junk value is at least taken
consistently.

This matters because shared resolutions are generally not injective: `exists_simultaneous_resolution`
refines blocks independently, so distinct blocks may repeat a coefficient, and
`jsqrt_eq_of_resolution` cannot read those. -/
theorem jsqrt_eq_of_resolution' (e : J) (he : ∀ y : J, e * y = y) (x : J)
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hx : x = ∑ i, lam i • c i) :
    jsqrt e he x = ∑ i, Real.sqrt (lam i) • c i := by
  classical
  set S : Finset ℝ := Finset.image lam Finset.univ with hSdef
  set d : ℝ → J := fun t => ∑ i ∈ Finset.univ.filter (fun i => lam i = t), c i with hddef
  have hmaps : ∀ i ∈ (Finset.univ : Finset (Fin n)), lam i ∈ S := fun i _ =>
    Finset.mem_image_of_mem lam (Finset.mem_univ i)
  have hdidem : ∀ t, d t * d t = d t := fun t => hfam.sum_idem _
  have hdorth : ∀ t u, t ≠ u → d t * d u = 0 := by
    intro t u htu
    rw [hddef]
    simp only
    rw [Finset.sum_mul_sum]
    refine Finset.sum_eq_zero fun i hi => Finset.sum_eq_zero fun j hj => ?_
    refine hfam.orth i j ?_
    rintro rfl
    exact htu (((Finset.mem_filter.mp hi).2).symm.trans (Finset.mem_filter.mp hj).2)
  have hunfiber : ∀ g : ℝ → ℝ,
      (∑ t ∈ S, ∑ i ∈ Finset.univ.filter (fun i => lam i = t), g t • c i)
        = ∑ i, g (lam i) • c i := by
    intro g
    rw [← Finset.sum_fiberwise_of_maps_to hmaps (fun i => g (lam i) • c i)]
    refine Finset.sum_congr rfl fun t _ => Finset.sum_congr rfl fun i hi => ?_
    rw [(Finset.mem_filter.mp hi).2]
  have hxd : x = ∑ t ∈ S, t • d t := by
    rw [hx, ← hunfiber (fun t => t)]
    refine Finset.sum_congr rfl fun t _ => ?_
    rw [hddef]
    simp only
    rw [Finset.smul_sum]
  have hinj : Function.Injective (fun k : Fin S.card => ((S.equivFin.symm k : ℝ))) := by
    intro k l hkl
    exact S.equivFin.symm.injective (Subtype.ext hkl)
  have hdfam : IsOrthIdemFamily (fun k : Fin S.card => d ((S.equivFin.symm k : ℝ))) :=
    ⟨fun k => hdidem _, fun k l hkl => hdorth _ _ fun h => hkl (hinj h)⟩
  have hxres : x = ∑ k : Fin S.card,
      ((S.equivFin.symm k : ℝ)) • d ((S.equivFin.symm k : ℝ)) := by
    rw [hxd, ← Finset.sum_coe_sort S (fun t => t • d t)]
    exact (Equiv.sum_comp S.equivFin.symm (fun a : {y // y ∈ S} => (a : ℝ) • d (a : ℝ))).symm
  rw [jsqrt_eq_of_resolution e he x hdfam hinj hxres]
  calc (∑ k : Fin S.card, Real.sqrt ((S.equivFin.symm k : ℝ)) • d ((S.equivFin.symm k : ℝ)))
      = ∑ t ∈ S, Real.sqrt t • d t := by
        rw [← Finset.sum_coe_sort S (fun t => Real.sqrt t • d t)]
        exact Equiv.sum_comp S.equivFin.symm
          (fun a : {y // y ∈ S} => Real.sqrt (a : ℝ) • d (a : ℝ))
    _ = ∑ i, Real.sqrt (lam i) • c i := by
        rw [← hunfiber Real.sqrt]
        refine Finset.sum_congr rfl fun t _ => ?_
        rw [hddef]
        simp only
        rw [Finset.smul_sum]

/-- **`jsqrt` squares back to `x`** whenever `x` has a resolution with nonnegative eigenvalues.

Deriving that hypothesis from `0 ≤ x` is `EJA/Order.lean`'s `nonneg_coeff_of_isSoS`, which lives
downstream of this file; the order-theoretic statement belongs there, not here. -/
theorem jsqrt_mul_self (e : J) (he : ∀ y : J, e * y = y) (x : J)
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hinj : Function.Injective lam) (hx : x = ∑ i, lam i • c i) (hnn : ∀ i, 0 ≤ lam i) :
    jsqrt e he x * jsqrt e he x = x := by
  rw [jsqrt_eq_of_resolution e he x hfam hinj hx, hx]
  exact jsqrtOfResolution_mul_self hfam hnn

/-- `jsqrt_mul_self` with nonnegativity demanded only at the idempotents that are present —
the form the cone actually supplies, via `nonneg_coeff_of_isSoS`. -/
theorem jsqrt_mul_self' (e : J) (he : ∀ y : J, e * y = y) (x : J)
    {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ} (hfam : IsOrthIdemFamily c)
    (hinj : Function.Injective lam) (hx : x = ∑ i, lam i • c i)
    (hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i) :
    jsqrt e he x * jsqrt e he x = x := by
  rw [jsqrt_eq_of_resolution e he x hfam hinj hx, hx]
  exact jsqrtOfResolution_mul_self' hfam hnn

/-! ### Simultaneous resolution of operator-commuting elements

The Jordan half of Faraut–Korányi Lemma X.2.2: two elements whose multiplication operators
commute are diagonal in a *single* complete orthogonal idempotent family
(`exists_simultaneous_resolution`).  Combined with `luders_of_resolution` this makes the
Lüders product of compatible effects coefficientwise — `a·b = ∑ᵢ λᵢμᵢcᵢ` — so the S1–S7
axioms on compatible pairs reduce to arithmetic on the eigenvalue lists.

★ **The route dodges the zero-eigenvalue trap, and how it does so is the point.**  The
tempting argument — each `cᵢ` is a polynomial in `a` (`idem_eq_jeval_lagrange`), so `L_b`
commutes with each `L_{cᵢ}` — runs through `jeval`, which is `x·p(x)` and cannot see the zero
eigenvalue; it also needs `⁅L_a, L_b⁆ = 0 → ⁅L_{a²}, L_b⁆ = 0`, which the Jordan identity
alone does not give.  Neither is used.  Instead everything runs on **associative** iterates of
`L_a` applied to `b`: with `uᵢ := cᵢ ∘ b`, operator commutation gives `L_a^k b = ∑ᵢ λᵢ^k uᵢ`
and `L_{cᵢ} L_a^k b = λᵢ^k uᵢ` — a plain Vandermonde system over the *full* eigenvalue list,
zero included — and the Lagrange interpolant at `λᵢ` isolates `cᵢ ∘ uᵢ = uᵢ`.  So each `uᵢ`
lands in the Peirce-1 space of its own `cᵢ`, where `exists_resolution_rel` refines it.  No
polynomial in the element `a` ever appears, and no dimension induction is needed. -/

/-- **Relative spectral resolution.**  An element of the Peirce-1 space of an idempotent `c`
is resolved by an orthogonal idempotent family drawn from that same Peirce space and
*complete for `c`* — the idempotent plays the unit's role.  `spectral_resolution` supplies
the family inside `jspan x`, which lies in the Peirce-1 space because that space is closed
under the product (`eigen_one_mul_one`); the deficit `c − ∑ⱼ dⱼ` is appended with coefficient
`0`, exactly as `spectral_resolution_complete` appends `e − ∑ᵢ cᵢ`. -/
theorem exists_resolution_rel {c x : J} (hc : c * c = c) (hx : c * x = x) :
    ∃ (n : ℕ) (d : Fin n → J) (mu : Fin n → ℝ),
      IsOrthIdemFamily d ∧ (∀ j, c * d j = d j) ∧ (∑ j, d j) = c ∧ x = ∑ j, mu j • d j := by
  obtain ⟨n, d, mu, hdfam, hdspan, hxd⟩ := spectral_resolution x
  have hjp : ∀ k, c * jpow x k = jpow x k := by
    intro k
    induction k with
    | zero => simpa using hx
    | succ k ih => rw [jpow_succ]; exact eigen_one_mul_one hc hx ih
  have hmemspan : ∀ z ∈ jspan x, c * z = z := by
    intro z hz
    induction hz using Submodule.span_induction with
    | mem w hw => obtain ⟨k, rfl⟩ := hw; exact hjp k
    | zero => exact mul_zero c
    | add p q _ _ hp hq => rw [mul_add, hp, hq]
    | smul r p _ hp => rw [mul_smul_comm', hp]
  have hmem : ∀ j, c * d j = d j := fun j => hmemspan _ (hdspan j)
  have hcs : c * (∑ j, d j) = ∑ j, d j := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun j _ => hmem j
  have hss : (∑ j, d j) * (∑ j, d j) = ∑ j, d j := hdfam.sum_idem Finset.univ
  have hsd : ∀ k, (∑ j, d j) * d k = d k := by
    intro k
    rw [Finset.sum_mul, Finset.sum_eq_single k (fun j _ hjk => hdfam.orth j k hjk)
      (fun h => absurd (Finset.mem_univ k) h)]
    exact hdfam.idem k
  have hlast : (c - ∑ j, d j) * (c - ∑ j, d j) = c - ∑ j, d j := by
    rw [sub_mul, mul_sub, mul_sub, hc, hcs, mul_comm (∑ j, d j) c, hcs, hss, sub_self, sub_zero]
  have horthlast : ∀ k, (c - ∑ j, d j) * d k = 0 := by
    intro k
    rw [sub_mul, hmem k, hsd k, sub_self]
  refine ⟨n + 1, Fin.snoc d (c - ∑ j, d j), Fin.snoc mu 0, ⟨?_, ?_⟩, ?_, ?_, ?_⟩
  · intro i
    induction i using Fin.lastCases with
    | last => simpa using hlast
    | cast i => simpa using hdfam.idem i
  · intro i j hij
    induction i using Fin.lastCases with
    | last =>
        induction j using Fin.lastCases with
        | last => exact absurd rfl hij
        | cast j => simpa using horthlast j
    | cast i =>
        induction j using Fin.lastCases with
        | last => simpa [mul_comm] using horthlast i
        | cast j => simpa using hdfam.orth i j fun h => hij (by rw [h])
  · intro j
    induction j using Fin.lastCases with
    | last =>
        simp only [Fin.snoc_last]
        rw [mul_sub, hc, hcs]
    | cast j => simpa using hmem j
  · rw [Fin.sum_univ_castSucc]
    simp
  · rw [Fin.sum_univ_castSucc]
    simpa using hxd

/-- **Simultaneous spectral resolution of operator-commuting elements** — the Jordan half of
Faraut–Korányi Lemma X.2.2, at the typeclass generality of this file.

Resolve `a` with *distinct* eigenvalues (`exists_resolution_distinct`).  Operator commutation
pins each component `uᵢ = cᵢ ∘ b` into the Peirce-1 space of its own `cᵢ` — the Vandermonde
argument of the section docstring — where `exists_resolution_rel` refines `cᵢ` into a
resolution of `uᵢ`.  Idempotents of different blocks annihilate each other because the
Peirce-1 spaces of orthogonal idempotents do (`eigen_one_mul_zero`), so the union of the
blocks is one orthogonal family, complete for `e`, diagonalising `a` blockwise-constantly and
`b` by construction. -/
theorem exists_simultaneous_resolution (e : J) (he : ∀ y : J, e * y = y) {a b : J}
    (hab : ∀ w, a * (b * w) = b * (a * w)) :
    ∃ (N : ℕ) (q : Fin N → J) (lam mu : Fin N → ℝ),
      IsOrthIdemFamily q ∧ (∑ k, q k) = e ∧
      a = ∑ k, lam k • q k ∧ b = ∑ k, mu k • q k := by
  classical
  obtain ⟨n, c, lam, hfam, hsum, hae, hinj⟩ := exists_resolution_distinct e he a
  set u : Fin n → J := fun i => c i * b with hudef
  have hbu : b = ∑ i, u i := by
    have h : (∑ i, c i) * b = ∑ i, c i * b := Finset.sum_mul _ _ _
    rw [hsum, he b] at h
    simpa [hudef] using h
  have hac : ∀ i, a * c i = lam i • c i := by
    intro i
    rw [hae]
    exact sum_smul_mul_idem hfam lam i
  have hau : ∀ i, a * u i = lam i • u i := by
    intro i
    simp only [hudef]
    calc a * (c i * b) = a * (b * c i) := by rw [mul_comm (c i) b]
      _ = b * (a * c i) := hab (c i)
      _ = b * (lam i • c i) := by rw [hac i]
      _ = lam i • (b * c i) := mul_smul_comm' _ _ _
      _ = lam i • (c i * b) := by rw [mul_comm b (c i)]
  have hccw : ∀ i j w, c i * (c j * w) = c j * (c i * w) := by
    intro i j w
    rcases eq_or_ne i j with rfl | hij
    · rfl
    · exact mul_comm_of_eigen_zero (hfam.idem i) (hfam.orth i j hij) w
  have hca : ∀ i w, c i * (a * w) = a * (c i * w) := by
    intro i w
    rw [hae, Finset.sum_mul, Finset.mul_sum, Finset.sum_mul]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [smul_mul_assoc, smul_mul_assoc, mul_smul_comm', hccw i j w]
  -- the associative iterates of `L_a` on `b`, evaluated two ways
  have hvsum : ∀ k : ℕ, (fun w => a * w)^[k] b = ∑ j, lam j ^ k • u j := by
    intro k
    induction k with
    | zero => simpa using hbu
    | succ k ih =>
        simp only [Function.iterate_succ_apply']
        rw [ih, Finset.mul_sum]
        refine Finset.sum_congr rfl fun j _ => ?_
        rw [mul_smul_comm', hau j, smul_smul, ← pow_succ]
  have hcv : ∀ i (k : ℕ), c i * (fun w => a * w)^[k] b = lam i ^ k • u i := by
    intro i k
    induction k with
    | zero => simp [hudef]
    | succ k ih =>
        simp only [Function.iterate_succ_apply']
        rw [hca i, ih, mul_smul_comm', hau i, smul_smul, ← pow_succ]
  have hmono : ∀ i (k : ℕ), (∑ j, lam j ^ k • (c i * u j)) = lam i ^ k • u i := by
    intro i k
    rw [← hcv i k, hvsum k, Finset.mul_sum]
    exact Finset.sum_congr rfl fun j _ => (mul_smul_comm' _ _ _).symm
  have hpoly : ∀ i (p : Polynomial ℝ),
      (∑ j, p.eval (lam j) • (c i * u j)) = p.eval (lam i) • u i := by
    intro i p
    induction p using Polynomial.induction_on' with
    | add p q hp hq =>
        simp only [Polynomial.eval_add, add_smul]
        rw [Finset.sum_add_distrib, hp, hq]
    | monomial k coef =>
        simp only [Polynomial.eval_monomial, mul_smul]
        rw [← Finset.smul_sum, hmono i k]
  -- the Lagrange interpolant at `λᵢ` isolates `cᵢ ∘ uᵢ = uᵢ`
  have hcu : ∀ i, c i * u i = u i := by
    intro i
    have h := hpoly i (Lagrange.basis Finset.univ lam i)
    rw [Finset.sum_eq_single i (fun j _ hji => by
        rw [Lagrange.eval_basis_of_ne (Ne.symm hji) (Finset.mem_univ j), zero_smul])
      (fun hi => absurd (Finset.mem_univ i) hi),
      Lagrange.eval_basis_self hinj.injOn (Finset.mem_univ i), one_smul, one_smul] at h
    exact h
  -- refine each block
  choose m d nu hdfam hdmem hdsum hud using fun i => exists_resolution_rel (hfam.idem i) (hcu i)
  have hcross : ∀ i i', i ≠ i' → ∀ (j : Fin (m i)) (j' : Fin (m i')), d i j * d i' j' = 0 := by
    intro i i' hii' j j'
    have h1 : d i' j' * c i = 0 :=
      eigen_one_mul_zero (hfam.idem i') (hdmem i' j') (hfam.orth i' i (Ne.symm hii'))
    exact eigen_one_mul_zero (hfam.idem i) (hdmem i j) (by rw [mul_comm] at h1; exact h1)
  have horth : ∀ σ τ : (i : Fin n) × Fin (m i), σ ≠ τ → d σ.1 σ.2 * d τ.1 τ.2 = 0 := by
    rintro ⟨i, j⟩ ⟨i', j'⟩ hne
    rcases eq_or_ne i i' with rfl | hii'
    · exact (hdfam i).orth j j' fun h => hne (by rw [h])
    · exact hcross i i' hii' j j'
  -- assemble over the sigma type
  let σe := Fintype.equivFin ((i : Fin n) × Fin (m i))
  have hsum_sigma : ∀ (g : ∀ i, Fin (m i) → J),
      (∑ k, g (σe.symm k).1 (σe.symm k).2) = ∑ i, ∑ j, g i j := by
    intro g
    calc (∑ k, g (σe.symm k).1 (σe.symm k).2)
        = ∑ σ : (i : Fin n) × Fin (m i), g σ.1 σ.2 :=
          Equiv.sum_comp σe.symm (fun σ => g σ.1 σ.2)
      _ = ∑ i, ∑ j, g i j := by rw [← Finset.univ_sigma_univ, Finset.sum_sigma]
  refine ⟨Fintype.card ((i : Fin n) × Fin (m i)),
    fun k => d (σe.symm k).1 (σe.symm k).2,
    fun k => lam (σe.symm k).1,
    fun k => nu (σe.symm k).1 (σe.symm k).2,
    ⟨fun k => (hdfam (σe.symm k).1).idem (σe.symm k).2,
     fun k k' hkk' => horth _ _ fun h => hkk' (by simpa using congrArg σe h)⟩,
    ?_, ?_, ?_⟩
  · exact (hsum_sigma d).trans ((Finset.sum_congr rfl fun i _ => hdsum i).trans hsum)
  · refine hae.trans ?_
    refine (Finset.sum_congr rfl fun i _ => ?_).trans (hsum_sigma fun i j => lam i • d i j).symm
    rw [← hdsum i, Finset.smul_sum]
  · refine hbu.trans ?_
    exact (Finset.sum_congr rfl fun i _ => hud i).trans (hsum_sigma fun i j => nu i j • d i j).symm

omit [IsFormallyReal J] [Module.Finite ℝ J] in
/-- **The converse: elements diagonal in one orthogonal idempotent family operator-commute.**
Together with `exists_simultaneous_resolution` this makes operator commutation *equivalent*
to simultaneous diagonalisability.  This direction needs neither formal reality nor finite
dimension: it is the pairwise operator commutation of orthogonal idempotents
(`mul_comm_of_eigen_zero`), extended bilinearly. -/
theorem opCommute_of_shared_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {a b : J} (la mu : Fin n → ℝ) (ha : a = ∑ i, la i • c i) (hb : b = ∑ i, mu i • c i)
    (w : J) : a * (b * w) = b * (a * w) := by
  have hccw : ∀ i j, c i * (c j * w) = c j * (c i * w) := by
    intro i j
    rcases eq_or_ne i j with rfl | hij
    · rfl
    · exact mul_comm_of_eigen_zero (hfam.idem i) (hfam.orth i j hij) w
  have key : ∀ f g : Fin n → ℝ,
      (∑ i, f i • c i) * ((∑ j, g j • c j) * w)
        = ∑ i, ∑ j, (f i * g j) • (c i * (c j * w)) := by
    intro f g
    calc (∑ i, f i • c i) * ((∑ j, g j • c j) * w)
        = ∑ i, (f i • c i) * ((∑ j, g j • c j) * w) := Finset.sum_mul _ _ _
      _ = ∑ i, ∑ j, (f i * g j) • (c i * (c j * w)) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [Finset.sum_mul _ (fun j => g j • c j) w, Finset.mul_sum]
          refine Finset.sum_congr rfl fun j _ => ?_
          rw [smul_mul_assoc, smul_mul_assoc, mul_smul_comm', smul_smul]
  rw [ha, hb, key la mu, key mu la, Finset.sum_comm]
  refine Finset.sum_congr rfl fun x _ => Finset.sum_congr rfl fun y _ => ?_
  rw [hccw y x, mul_comm (la y) (mu x)]

omit [IsFormallyReal J] [Module.Finite ℝ J] in
/-- **Quadratic representations of elements diagonal in one orthogonal idempotent family
commute.**  `Q_a = 2L_a² − L_{a²}`, and `a²`, `b²` are again diagonal in the family
(`sum_smul_mul_sum_smul_of_orthIdem`), so all four multiplication operators in sight commute
pairwise (`opCommute_of_shared_resolution`) and each monomial of `Q_a Q_b` rearranges one
factor at a time.  Like the operator commutation it rests on, this needs neither formal
reality, nor finite dimension, nor completeness of the family. -/
theorem quadJ_comm_of_shared_resolution {n : ℕ} {c : Fin n → J} (hfam : IsOrthIdemFamily c)
    {a b : J} (la mu : Fin n → ℝ) (ha : a = ∑ i, la i • c i) (hb : b = ∑ i, mu i • c i)
    (z : J) : quadJ a (quadJ b z) = quadJ b (quadJ a z) := by
  have ha2 : a * a = ∑ i, (la i * la i) • c i := by
    rw [ha, sum_smul_mul_sum_smul_of_orthIdem hfam]
  have hb2 : b * b = ∑ i, (mu i * mu i) • c i := by
    rw [hb, sum_smul_mul_sum_smul_of_orthIdem hfam]
  have hab : ∀ w, a * (b * w) = b * (a * w) :=
    opCommute_of_shared_resolution hfam la mu ha hb
  have hab2 : ∀ w, a * (b * b * w) = b * b * (a * w) :=
    opCommute_of_shared_resolution hfam la (fun i => mu i * mu i) ha hb2
  have ha2b : ∀ w, a * a * (b * w) = b * (a * a * w) := fun w =>
    (opCommute_of_shared_resolution hfam mu (fun i => la i * la i) hb ha2 w).symm
  have ha2b2 : ∀ w, a * a * (b * b * w) = b * b * (a * a * w) :=
    opCommute_of_shared_resolution hfam (fun i => la i * la i) (fun i => mu i * mu i) ha2 hb2
  have k1 : a * (a * (b * (b * z))) = b * (b * (a * (a * z))) := by
    rw [hab (b * z), hab (a * (b * z)), hab z, hab (a * z)]
  have k2 : a * (a * (b * b * z)) = b * b * (a * (a * z)) := by
    rw [hab2 z, hab2 (a * z)]
  have k3 : a * a * (b * (b * z)) = b * (b * (a * a * z)) := by
    rw [ha2b (b * z), ha2b z]
  have k4 : a * a * (b * b * z) = b * b * (a * a * z) := ha2b2 z
  simp only [quadJ_apply, mul_sub, mul_smul_comm', smul_sub, smul_smul]
  linear_combination (norm := module) (4 : ℝ) • k1 - (2 : ℝ) • k2 - (2 : ℝ) • k3 + k4

end Split


section Concrete

open HermMul

variable {d : Type*} [Fintype d] [DecidableEq d] {𝕜 : Type*} [RCLike 𝕜]

/-- **(E1) live on the paper's own carrier.** -/
theorem hermitian_spectral_resolution (A : HermitianMat d 𝕜) :
    ∃ (n : ℕ) (c : Fin n → HermitianMat d 𝕜) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∀ i, c i ∈ jspan A) ∧ A = ∑ i, lam i • c i :=
  spectral_resolution A

/-- **(E1) with completeness, live on the paper's own carrier**: the unit is `1`. -/
theorem hermitian_spectral_resolution_complete (A : HermitianMat d 𝕜) :
    ∃ (n : ℕ) (c : Fin n → HermitianMat d 𝕜) (lam : Fin n → ℝ),
      IsOrthIdemFamily c ∧ (∑ i, c i) = 1 ∧ A = ∑ i, lam i • c i :=
  spectral_resolution_complete 1 (fun y => by rw [mul_eq_symmMul, HermitianMat.symmMul_comm,
    HermitianMat.symmMul_one]) A

end Concrete


section Interface

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]

omit [InnerProductSpace ℝ J] in
/-- Formal reality over an arbitrary `Finset`, from the `Fin k` form that
`MasterTheorem/Interface.lean`'s premises carry. The two differ only by reindexing. -/
theorem isFormallyReal_of_fin [Module ℝ J] (m : J →ₗ[ℝ] J →ₗ[ℝ] J) (hcomm : ∀ x y : J, m x y = m y x)
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0) :
    letI : NonUnitalNonAssocCommRing J := ringOfBilinear m hcomm
    IsFormallyReal J := by
  letI : NonUnitalNonAssocCommRing J := ringOfBilinear m hcomm
  refine ⟨fun {ι} s f hsum i hi => ?_⟩
  classical
  have key : (∑ k : Fin s.card, m (f (s.equivFin.symm k)) (f (s.equivFin.symm k))) = 0 := by
    rw [show (∑ k : Fin s.card, m (f (s.equivFin.symm k)) (f (s.equivFin.symm k)))
        = ∑ a : {y // y ∈ s}, m (f a) (f a) from
      Equiv.sum_comp s.equivFin.symm (fun a : {y // y ∈ s} => m (f a) (f a)),
      Finset.sum_coe_sort s (fun a => m (f a) (f a))]
    exact hsum
  simpa using hfr s.card (fun k => f (s.equivFin.symm k)) key (s.equivFin ⟨i, hi⟩)

/-- **(E1) in `MasterTheorem/Interface.lean`'s own vocabulary**: the Jordan product as a bundled
bilinear map, the Jordan identity and formal reality as hypotheses in that vocabulary, and the
conclusion stated without mentioning any ring instance.

★ This is the crossing `EJA/Bridge.lean` was built for, and it works here for the reason that file
gives: the *statement* is expressible with `m` alone, so no ring instance has to exist before it
elaborates. Only the proof needs one, and `ringOfBilinear` supplies it on the ambient additive
group.

★ Finite-dimensionality is not decoration. Without it the statement is false: `ℝ[X]` with
polynomial multiplication satisfies every hypothesis below and has no nonconstant spectral
resolution, its only idempotents being `0` and `1`. -/
theorem spectral_resolution_bilinear [FiniteDimensional ℝ J] (m : J →ₗ[ℝ] J →ₗ[ℝ] J)
    (hcomm : ∀ x y : J, m x y = m y x)
    (hjordan : ∀ a b : J, m (m a b) (m a a) = m a (m b (m a a)))
    (hfr : ∀ (k : ℕ) (f : Fin k → J), (∑ i, m (f i) (f i)) = 0 → ∀ i, f i = 0)
    (e : J) (he : ∀ y : J, m e y = y) (x : J) :
    ∃ (n : ℕ) (q : Fin n → J) (lam : Fin n → ℝ),
      (∀ i, m (q i) (q i) = q i) ∧
      (∀ i j, i ≠ j → m (q i) (q j) = 0) ∧
      (∑ i, q i) = e ∧
      x = ∑ i, lam i • q i := by
  letI : NonUnitalNonAssocCommRing J := ringOfBilinear m hcomm
  letI : IsCommJordan J := ⟨hjordan⟩
  letI : IsScalarTower ℝ J J := ⟨fun r x y => smul_bilinear m r x y⟩
  letI : IsFormallyReal J := isFormallyReal_of_fin m hcomm hfr
  obtain ⟨n, q, lam, hfam, hsum, hx⟩ := spectral_resolution_complete e he x
  exact ⟨n, q, lam, hfam.idem, hfam.orth, hsum, hx⟩

end Interface

end RadicalRelativity.EJA
