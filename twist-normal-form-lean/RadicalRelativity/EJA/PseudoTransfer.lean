/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Class
import RadicalRelativity.EJA.FramePeirceMul
import RadicalRelativity.OrthFamily

set_option linter.style.longLine false

/-!
# `prop:pseudo-transfer`, unknown-product half, discharged at EJA generality

`RadicalRelativity/OrthFamily.lean` carries the abstract pseudo-inverse layer — the
unknown-product half of `STATEMENT-MANIFEST.md` row 13 at `[OrderUnitSpace V]` generality —
with every eigenvalue hypothesis **guarded at nonzero family members** on the stated ground
that the guarded form, unlike the universal one, is dischargeable from the cone of a
Euclidean Jordan algebra.  This file is that claim **machine-checked rather than argued**:
`sp_pseudoTransfer` instantiates `SequentialProductOn.spCone_specInv_both` on the order
`EJA/Order.lean` constructs, over the `EuclideanJordanAlgebra` class, and discharges every
hypothesis by name:

| abstract hypothesis | discharged by |
| --- | --- |
| the `OrderUnitSpace` instance | `orderUnitSpaceOfBilinear` at the `jmulₗ` tuple |
| `IsArchimedean` | `isArchimedean_ofBilinear` |
| `∀ i, IsSharp (c i)` | `isSharpOrderUnit_of_idem` on `hfam.idem` |
| `∑ i, c i = 𝟙` | completeness of the resolution plus `ousUnit_ofBilinear` (a `rfl`) |
| `c i ≠ 0 → 0 < lam i` | `nonneg_coeff_of_isSoS` on `b`, plus invertibility `lam i ≠ 0` |
| `c i ≠ 0 → lam i ≤ 1` | `nonneg_coeff_of_isSoS` on `1 - b`, via `smul_unit_sub_eq` |

★ The two `nonneg_coeff_of_isSoS` rows are the reason the abstract guards exist: that
theorem speaks only at nonzero idempotents, because a resolution's coefficient at a zero
idempotent is unconstrained (`0 • 0 = 37 • 0`).  An abstract layer with universal
eigenvalue hypotheses would be unusable at exactly these two rows.

The statement is **resolution-relative in the same sense as the standard-product half**
(`EJA/Spectral.lean`'s `luders_jsqrt_jinv`): the invertible effect is given by a complete
resolution with `lam i ≠ 0` wherever `c i ≠ 0`, its effect-hood by the two sums-of-squares
certificates `IsSoS b` and `IsSoS (1 - b)` (which are `IsEffect b` for the constructed
order, by `isEffect_ofBilinear`), and the spectral inverse is `∑ (lam i)⁻¹ • c i` — the
class-side `jinvOfResolution c lam` written out.  With those, **for any S1–S7 product
`P` with the article's S2 on the constructed order**, `b⁻¹ · b = b · b⁻¹ = 1` through the
cone extensions, with no coefficient.

★ **What this does NOT claim**: no inhabitant of `SequentialProductOn` at EJA generality is
constructed (that is still open — see the manifest row), and no canonical inverse function
of `b` alone is defined; the identity is relative to the given resolution, exactly as the
standard half is.

## Added 2026-08-24: cone preservation of `Q_v`, and both "order preserving" clauses

Three later sections extend the file beyond the unknown-product half.  **`quadJ_isSoS`** proves
that the quadratic representation preserves the cone — `IsSoS x → IsSoS (Q_v x)` for *every*
`v`, not merely cone elements — which is the fact row 13's standard-product order-preservation
clause was waiting on.  The proof is not the matrix argument (`s x s = (sb)(sb)ᵀ` is not
Jordan-expressible) and not a pure identity argument (none can exist: positivity must enter);
it runs on the atom `quadJ_primitive_eq_smul_idem` — the fundamental formula at the unit plus
`dim J₂(c) = 1` for a *primitive* `c` make `Q_v c` a nonnegative multiple of an idempotent —
with `exists_primitive_summands` (a frame of the Peirce subalgebra `J₂(c)`, coerced down)
reducing every idempotent pairing to primitive ones.  Hence the import of
`EJA.FramePeirceMul`, the first file to consume the frame layer outside the coordinatization
campaign.  **`sp_lowerIntervalSurj`** discharges `OrthFamily`'s lower-interval surjectivity
(vdW Def. 4.17, onto half) at EJA generality by the same hypothesis-by-name table as
`sp_orderReflection`, and **`luders_lowerInterval_surj`** / `luders_reflectsNonneg` are the
*standard*-product halves, from `quadJ_isSoS` plus the fundamental-formula inverse.
-/

noncomputable section

namespace RadicalRelativity.EJA

open Finset

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]
  [EuclideanJordanAlgebra J] [FiniteDimensional ℝ J]

/-- **`prop:pseudo-transfer`, unknown-product half, at EJA generality** (resolution-relative,
like the standard half `luders_jsqrt_jinv`): for an effect `b` with a complete resolution
whose eigenvalues do not vanish at nonzero idempotents, every S1–S7+S2 sequential product on
the constructed order satisfies `b⁻¹ · b = b · b⁻¹ = 1` for the spectral inverse
`b⁻¹ = ∑ (lam i)⁻¹ • c i`, through the cone extensions and with no coefficient. -/
theorem sp_pseudoTransfer {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ P : SequentialProductOn J, P.FirstArgContinuous →
      P.spCone (∑ i, (lam i)⁻¹ • c i) b = 1 ∧
        P.spConeRight b (∑ i, (lam i)⁻¹ • c i) = 1 := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2
  have harch : OrderUnitSpace.IsArchimedean J :=
    isArchimedean_ofBilinear jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal jmulₗ_inner_assoc
      (1 : J) jmulₗ_one_mul
  have hsharp : ∀ i ∈ Finset.univ, OrderUnitSpace.IsSharp (c i) := fun i _ =>
    isSharpOrderUnit_of_idem (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      jmulₗ_inner_assoc (1 : J) jmulₗ_one_mul (hfam.idem i)
  have hpos : ∀ i ∈ Finset.univ, c i ≠ 0 → 0 < lam i := fun i _ hci =>
    (nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb hbsos hci).lt_of_ne
      (Ne.symm (hne i hci))
  have hb1' : (1 : J) - b = ∑ i, ((1 : ℝ) - lam i) • c i := by
    have h := smul_unit_sub_eq hsum hb 1
    rwa [one_smul] at h
  have hle1 : ∀ i ∈ Finset.univ, c i ≠ 0 → lam i ≤ 1 := by
    intro i _ hci
    have h := nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb1' hcsos hci
    linarith
  rw [hb]
  exact P.spCone_specInv_both harch hS2 hsharp hsum hpos hle1

/-- **Order reflection and injectivity of the left multiplication (vdW 4.19) at EJA
generality** (resolution-relative, like `sp_pseudoTransfer` above): for an effect `b`
with a complete resolution whose eigenvalues do not vanish at nonzero idempotents, and
any S1–S7+S2 sequential product on the constructed order, the linear extension
`seqLeftMulAbs` of `x ↦ b ◦' x` reflects positivity and is injective.

The two quantified proofs are both inhabited — `harch` by `isArchimedean_ofBilinear`
(constructed inside `sp_pseudoTransfer`), `hbe` by `(isEffect_ofBilinear b).mpr
⟨hbsos, hcsos⟩` — and by proof irrelevance `seqLeftMulAbs` does not depend on which
proofs are supplied, so the universal quantification is the usable form, not a vacuity.
Every abstract hypothesis is discharged by the same names as in `sp_pseudoTransfer`. -/
theorem sp_orderReflection {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ P : SequentialProductOn J, P.FirstArgContinuous →
      ∀ (harch : OrderUnitSpace.IsArchimedean J) (hbe : OrderUnitSpace.IsEffect b),
        (∀ x : J, 0 ≤ P.seqLeftMulAbs harch hbe x → 0 ≤ x) ∧
          Function.Injective (P.seqLeftMulAbs harch hbe) := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 harch hbe
  have hsharp : ∀ i ∈ Finset.univ, OrderUnitSpace.IsSharp (c i) := fun i _ =>
    isSharpOrderUnit_of_idem (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      jmulₗ_inner_assoc (1 : J) jmulₗ_one_mul (hfam.idem i)
  have hpos : ∀ i ∈ Finset.univ, c i ≠ 0 → 0 < lam i := fun i _ hci =>
    (nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb hbsos hci).lt_of_ne
      (Ne.symm (hne i hci))
  have hb1' : (1 : J) - b = ∑ i, ((1 : ℝ) - lam i) • c i := by
    have h := smul_unit_sub_eq hsum hb 1
    rwa [one_smul] at h
  have hle1 : ∀ i ∈ Finset.univ, c i ≠ 0 → lam i ≤ 1 := by
    intro i _ hci
    have h := nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb1' hcsos hci
    linarith
  subst hb
  exact ⟨fun x hx => P.seqLeftMulAbs_reflectsNonneg harch hS2 hsharp hsum hpos hle1 hbe hx,
    P.seqLeftMulAbs_injective harch hS2 hsharp hsum hpos hle1 hbe⟩

/-! ## Cone preservation of the quadratic representation

`IsSoS x → IsSoS (Q_v x)` for every `v`.  Three steps.  ★ **The route is forced, and two
tempting ones are known dead ends** (recorded so they are not re-priced): the matrix proof
`s x s = (sb)(sb)ᵀ` factors through a non-symmetric element and is not Jordan-expressible;
and no proof by operator identities alone can exist, because every identity (the fundamental
formula included) holds in Jordan algebras where the statement's positivity content is
vacuous — formal reality and the inner product must be spent.  They are spent exactly once,
in the atom `quadJ_primitive_eq_smul_idem`.  Both identities that atom rests on were verified
numerically on random `3×3` real symmetric matrices before proof was attempted (2026-08-24):
`Q_c(v²) = t•c` and `(Q_v c)² = t•(Q_v c)` hold to `4e-15` for primitive `c`, and the second
**fails at order 1 for a rank-two projection** — primitivity is load-bearing. -/

/-- **Every nonzero idempotent is a finite sum of primitive idempotents.**  Run
`exists_jordanFrame` inside the Peirce subalgebra `J₂(c)` — a Euclidean Jordan algebra with
unit `c` — and coerce the frame down by `isPrimitive_coe_of_peirceOne`.  The summands are also
pairwise orthogonal, but no consumer here needs that, so it is not recorded. -/
theorem exists_primitive_summands {c : J} (hc : c * c = c) (hc0 : c ≠ 0) :
    ∃ (m : ℕ) (d : Fin m → J), (∀ r, IsPrimitive (d r)) ∧ (∑ r, d r) = c := by
  have h1 : (1 : ↥(peirceOneSub hc)) ≠ 0 := by
    intro h
    apply hc0
    have hco := congrArg Subtype.val h
    rwa [coe_one_peirceOneSub, ZeroMemClass.coe_zero] at hco
  obtain ⟨m, ⟨F⟩⟩ := exists_jordanFrame ↥(peirceOneSub hc) h1
  refine ⟨m, fun r => (F.p r : J),
    fun r => isPrimitive_coe_of_peirceOne hc (F.primitive r), ?_⟩
  rw [← AddSubmonoidClass.coe_finsetSum, F.complete]
  exact coe_one_peirceOneSub hc

/-- **`Q_v` sends a primitive idempotent to a nonnegative multiple of an idempotent** — the
atom of cone preservation, for *arbitrary* `v`.

The fundamental formula read at the unit gives `(Q_v c)² = Q_{Q_v c} 1 = Q_v Q_c Q_v 1
= Q_v (Q_c v²)`; primitivity makes the Peirce projection `Q_c = P₁(c)` scalar
(`peirceOneSub_eq_span_of_isPrimitive`), so `Q_c v² = t • c` and `(Q_v c)² = t • Q_v c`, with
`t ≥ 0` because `t‖c‖² = ⟪c, v²⟫` is an idempotent-vs-cone pairing.  `t = 0` kills `Q_v c`
outright (pair the square against the unit), and `t > 0` normalizes `Q_v c` to an idempotent.
★ Primitivity is not a convenience: `(Q_v c)² = t•(Q_v c)` fails numerically at order 1 for a
rank-two projection on `3×3` real symmetric matrices. -/
theorem quadJ_primitive_eq_smul_idem {c : J} (hp : IsPrimitive c) (v : J) :
    ∃ (t : ℝ) (d : J), 0 ≤ t ∧ d * d = d ∧ quadJ v c = t • d := by
  -- `Q_c v² = t • c`, by primitivity
  have hmem : quadJ c (v * v) ∈ peirceOneSub hp.idem := by
    rw [quadJ_eq_peirceOne hp.idem]
    exact (mem_peirceOneSub hp.idem).mpr (mul_peirceOne hp.idem (v * v))
  rw [peirceOneSub_eq_span_of_isPrimitive hp, Submodule.mem_span_singleton] at hmem
  obtain ⟨t, ht⟩ := hmem
  -- `t ≥ 0`: pair against `c`
  have hcpos : (0 : ℝ) < inner ℝ c c := real_inner_self_pos.mpr hp.ne_zero
  have hvv : IsSoS (jmulₗ J) (v * v) := ⟨1, fun _ => v, by simp⟩
  have hpair : (0 : ℝ) ≤ inner ℝ c (v * v) :=
    inner_idem_isSoS_nonneg jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc hp.idem hvv
  have hQcc : quadJ c c = c := by
    rw [quadJ_eq_peirceOne hp.idem]
    exact peirceOne_of_eigen hp.idem
  have hts : t * inner ℝ c c = inner ℝ c (v * v) := by
    have h1 := quadJ_inner_self_adjoint c (v * v) c
    rw [hQcc, ← ht, real_inner_smul_left, real_inner_comm c (v * v)] at h1
    exact h1
  have ht0 : 0 ≤ t := by nlinarith [hcpos, hpair, hts]
  -- the fundamental formula at the unit: `(Q_v c)² = t • Q_v c`
  have hff : quadJ v c * quadJ v c = t • quadJ v c := by
    have h := quadJ_quadJ_quadJ v c (1 : J)
    rw [quadJ_unit EuclideanJordanAlgebra.one_mul v,
      quadJ_unit EuclideanJordanAlgebra.one_mul (quadJ v c), ← ht, map_smul] at h
    exact h
  rcases eq_or_lt_of_le ht0 with h0 | htpos
  · -- `t = 0`: the square vanishes, so `Q_v c = 0` by pairing against the unit
    have hzz : quadJ v c * quadJ v c = 0 := by rw [hff, ← h0, zero_smul]
    have h := EuclideanJordanAlgebra.inner_mul_one (quadJ v c) (quadJ v c)
    rw [hzz, inner_zero_left] at h
    have hz : quadJ v c = 0 := inner_self_eq_zero.mp h.symm
    exact ⟨0, 0, le_refl 0, by rw [mul_zero], by rw [hz, zero_smul]⟩
  · -- `t > 0`: `t⁻¹ • Q_v c` is the idempotent
    have htne : t ≠ 0 := ne_of_gt htpos
    refine ⟨t, t⁻¹ • quadJ v c, ht0, ?_, ?_⟩
    · calc (t⁻¹ • quadJ v c) * (t⁻¹ • quadJ v c)
          = (t⁻¹ * t⁻¹) • (quadJ v c * quadJ v c) := smul_mul_smul_eq _ _ _ _
        _ = (t⁻¹ * t⁻¹ * t) • quadJ v c := by rw [hff, smul_smul]
        _ = t⁻¹ • quadJ v c := by rw [show t⁻¹ * t⁻¹ * t = t⁻¹ by field_simp]
    · rw [smul_smul, mul_inv_cancel₀ htne, one_smul]

/-- **The quadratic representation preserves the cone**: `IsSoS x → IsSoS (Q_v x)` for every
`v` — `Q_v` is a positive map, at EJA generality.  This is the fact `STATEMENT-MANIFEST.md`
row 13 names as the missing standard-product ingredient ("`Q_{√a}` having positive inverse
`Q_{√a⁻¹}`").

Resolve `Q_v x` and read each coefficient off by pairing against its own idempotent
(`nonneg_coeff_of_inner_nonneg`); self-adjointness of `Q_v` moves the pairing to
`⟪Q_v c, x⟫`, `exists_primitive_summands` splits `c` into primitives, and the atom makes each
term `t·⟪d, x⟫ ≥ 0`.  Rebuild from the now-nonnegative resolution. -/
theorem quadJ_isSoS (v : J) {x : J} (hx : IsSoS (jmulₗ J) x) :
    IsSoS (jmulₗ J) (quadJ v x) := by
  classical
  obtain ⟨n, cfam, lam, hfam, -, hz, -⟩ :=
    exists_resolution_distinct 1 EuclideanJordanAlgebra.one_mul (quadJ v x)
  have hcoef : ∀ k, cfam k ≠ 0 → 0 ≤ lam k := by
    intro k hk
    refine nonneg_coeff_of_inner_nonneg (m := jmulₗ J) jmulₗ_inner_assoc
      (fun i => hfam.idem i) (fun i j hij => hfam.orth i j hij) hz hk ?_
    have hsa := quadJ_inner_self_adjoint v (cfam k) x
    rw [← hsa]
    obtain ⟨m, d, hdprim, hdsum⟩ := exists_primitive_summands (hfam.idem k) hk
    have hexp : quadJ v (cfam k) = ∑ r, quadJ v (d r) := by rw [← hdsum, map_sum]
    rw [hexp, sum_inner]
    refine Finset.sum_nonneg fun r _ => ?_
    obtain ⟨t, dd, ht0, hdd, hQ⟩ := quadJ_primitive_eq_smul_idem (hdprim r) v
    rw [hQ, real_inner_smul_left]
    exact mul_nonneg ht0
      (inner_idem_isSoS_nonneg jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc hdd hx)
  rw [hz]
  refine isSoS_sum Finset.univ _ fun k _ => ?_
  by_cases hk : cfam k = 0
  · rw [hk, smul_zero]
    exact isSoS_zero
  · exact isSoS_smul_idem (hcoef k hk) (hfam.idem k)

/-! ## Lower-interval surjectivity at EJA generality — the unknown product

`OrthFamily.lean`'s `sp_lowerInterval_surjOn` (vdW Def. 4.17, onto half), discharged on the
constructed order by the same hypothesis-by-name table as `sp_orderReflection` above.  With
that theorem's order reflection this completes vdW's "order preserving" for the unknown
product at every invertible effect. -/

/-- **Lower-interval surjectivity (vdW Def. 4.17, onto half) at EJA generality**
(resolution-relative, like its siblings): for an effect `b` with a complete resolution whose
eigenvalues do not vanish at nonzero idempotents, and any S1–S7+S2 sequential product on the
constructed order, every `y` with `0 ≤ y ≤ b` is `b ◦' x` for an effect `x` — the left
multiplication by `b` carries the effect interval onto the order interval below `b`.  The
order hypotheses on `y` are spelled as their sums-of-squares readings, which is what `≤` on
the constructed order *is*. -/
theorem sp_lowerIntervalSurj {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hcsos : IsSoS (jmulₗ J) ((1 : J) - b))
    (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) :
    letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      (1 : J) jmulₗ_one_mul
    ∀ P : SequentialProductOn J, P.FirstArgContinuous →
      ∀ y : J, IsSoS (jmulₗ J) y → IsSoS (jmulₗ J) (b - y) →
        ∃ x : J, OrderUnitSpace.IsEffect x ∧ P.sp b x = y := by
  letI := orderUnitSpaceOfBilinear (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
    (1 : J) jmulₗ_one_mul
  intro P hS2 y hy0 hyb
  have harch : OrderUnitSpace.IsArchimedean J :=
    isArchimedean_ofBilinear jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal jmulₗ_inner_assoc
      (1 : J) jmulₗ_one_mul
  have hsharp : ∀ i ∈ Finset.univ, OrderUnitSpace.IsSharp (c i) := fun i _ =>
    isSharpOrderUnit_of_idem (jmulₗ J) jmulₗ_comm jmulₗ_jordan jmulₗ_formallyReal
      jmulₗ_inner_assoc (1 : J) jmulₗ_one_mul (hfam.idem i)
  have hpos : ∀ i ∈ Finset.univ, c i ≠ 0 → 0 < lam i := fun i _ hci =>
    (nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb hbsos hci).lt_of_ne
      (Ne.symm (hne i hci))
  have hb1' : (1 : J) - b = ∑ i, ((1 : ℝ) - lam i) • c i := by
    have h := smul_unit_sub_eq hsum hb 1
    rwa [one_smul] at h
  have hle1 : ∀ i ∈ Finset.univ, c i ≠ 0 → lam i ≤ 1 := by
    intro i _ hci
    have h := nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb1' hcsos hci
    linarith
  subst hb
  have hy0' : (0 : J) ≤ y := by
    show IsSoS (jmulₗ J) (y - 0)
    rwa [sub_zero]
  have hyb' : y ≤ ∑ i, lam i • c i := hyb
  exact P.sp_lowerInterval_surjOn harch hS2 hsharp hsum hpos hle1 hy0' hyb'

/-! ## Order preservation for the STANDARD product

Row 13's clause (iii) asks for order preservation for **both** products; the unknown-product
half is above and in `sp_orderReflection`.  The standard product is the Lüders map
`b · x = Q_{√b} x`, and its order preservation is exactly what `quadJ_isSoS` was for:
`Q_{√b}` and `Q_{√(b⁻¹)}` are mutually inverse positive maps, so `Q_{√b}` reflects the cone
and carries the effect interval onto `[0, b]`.  Everything is resolution-relative in the same
sense as `luders_jsqrt_jinv`, and effect-hood of `b` is not needed — any invertible cone
element works. -/

/-- **`Q_{√b}` and `Q_{√(b⁻¹)}` are mutually inverse**, for `b` in the cone with a complete
resolution not vanishing at nonzero idempotents.  Both square roots are diagonal in the shared
family, so they operator-commute, their Jordan product is `∑ √λᵢ·√(λᵢ⁻¹) • cᵢ = 𝟙`, and
`quadJ_mul_of_opCommute` collapses each composite to `Q_𝟙 = id`. -/
theorem quadJ_jsqrt_jinv_cancel {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) (y : J) :
    quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b)
        (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) y) = y ∧
      quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam))
        (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y) = y := by
  have hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb hbsos hci
  have hsb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ i, Real.sqrt (lam i) • c i :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hb
  have hsbinv : jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)
      = ∑ i, Real.sqrt ((lam i)⁻¹) • c i :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul _ hfam rfl
  have hprod : jsqrt 1 EuclideanJordanAlgebra.one_mul b
      * jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam) = 1 := by
    rw [hsb, hsbinv, sum_smul_mul_sum_smul_of_orthIdem hfam, ← hsum]
    refine Finset.sum_congr rfl fun i _ => ?_
    by_cases hci : c i = 0
    · rw [hci, smul_zero]
    · rw [← Real.sqrt_mul (hnn i hci), mul_inv_cancel₀ (hne i hci), Real.sqrt_one, one_smul]
  have hoc : ∀ w, jsqrt 1 EuclideanJordanAlgebra.one_mul b
        * (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam) * w)
      = jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)
        * (jsqrt 1 EuclideanJordanAlgebra.one_mul b * w) :=
    opCommute_of_shared_resolution hfam (fun i => Real.sqrt (lam i))
      (fun i => Real.sqrt ((lam i)⁻¹)) hsb hsbinv
  constructor
  · rw [← quadJ_mul_of_opCommute EuclideanJordanAlgebra.one_mul hoc, hprod,
      quadJ_unit_left EuclideanJordanAlgebra.one_mul]
  · have hprod' : jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)
        * jsqrt 1 EuclideanJordanAlgebra.one_mul b = 1 := by
      rw [_root_.mul_comm]
      exact hprod
    rw [← quadJ_mul_of_opCommute EuclideanJordanAlgebra.one_mul (fun w => (hoc w).symm),
      hprod', quadJ_unit_left EuclideanJordanAlgebra.one_mul]

/-- **The Lüders map reflects the cone** — order reflection for the *standard* product at an
invertible cone element, resolution-relatively: `Q_{√b} y ∈ K → y ∈ K`.  Pull back through
`Q_{√(b⁻¹)}`, which is a positive map by `quadJ_isSoS`. -/
theorem luders_reflectsNonneg {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) {y : J}
    (hy : IsSoS (jmulₗ J) (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) y)) :
    IsSoS (jmulₗ J) y := by
  have h := (quadJ_jsqrt_jinv_cancel hfam hsum hb hbsos hne y).2
  rw [← h]
  exact quadJ_isSoS _ hy

/-- **The Lüders map lands in the interval below `b`**: an effect `x` is carried to
`[0, b]`.  Needs neither completeness nor invertibility — only `b` in the cone, so that
`√b ∘ √b = b` and `Q_{√b} 𝟙 = b`. -/
theorem luders_maps_into {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) {x : J}
    (hx0 : IsSoS (jmulₗ J) x) (hx1 : IsSoS (jmulₗ J) ((1 : J) - x)) :
    IsSoS (jmulₗ J) (quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) x) ∧
      IsSoS (jmulₗ J) (b - quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) x) := by
  have hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb hbsos hci
  have hsb : jsqrt 1 EuclideanJordanAlgebra.one_mul b = ∑ i, Real.sqrt (lam i) • c i :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul b hfam hb
  have hQb1 : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) (1 : J) = b := by
    rw [quadJ_unit EuclideanJordanAlgebra.one_mul, hsb,
      sum_smul_mul_sum_smul_of_orthIdem hfam, hb]
    refine Finset.sum_congr rfl fun i _ => ?_
    by_cases hci : c i = 0
    · rw [hci, smul_zero, smul_zero]
    · rw [Real.mul_self_sqrt (hnn i hci)]
  refine ⟨quadJ_isSoS _ hx0, ?_⟩
  have hsub : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) ((1 : J) - x)
      = b - quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) x := by
    rw [map_sub, hQb1]
  rw [← hsub]
  exact quadJ_isSoS _ hx1

/-- **Lower-interval surjectivity for the STANDARD product**: the Lüders map of an invertible
cone element `b` carries the effect interval *onto* `[0, b]` — every `y` with `0 ≤ y ≤ b` is
`Q_{√b} x` for an effect `x`, namely `x = Q_{√(b⁻¹)} y`.  With `luders_reflectsNonneg` this is
vdW Def. 4.17's "order preserving" for the standard product, closing the half of row 13's
clause (iii) the manifest records as "reachable … but not proved".

`x ≤ 𝟙` is the cone preservation `quadJ_isSoS` applied to `b - y`, through
`Q_{√(b⁻¹)} b = 𝟙` — the coefficientwise computation `(√(λ⁻¹))²·λ = 1`. -/
theorem luders_lowerInterval_surj {b : J} {n : ℕ} {c : Fin n → J} {lam : Fin n → ℝ}
    (hfam : IsOrthIdemFamily c) (hsum : (∑ i, c i) = 1) (hb : b = ∑ i, lam i • c i)
    (hbsos : IsSoS (jmulₗ J) b) (hne : ∀ i, c i ≠ 0 → lam i ≠ 0) {y : J}
    (hy0 : IsSoS (jmulₗ J) y) (hyb : IsSoS (jmulₗ J) (b - y)) :
    ∃ x : J, IsSoS (jmulₗ J) x ∧ IsSoS (jmulₗ J) ((1 : J) - x) ∧
      quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul b) x = y := by
  have hnn : ∀ i, c i ≠ 0 → 0 ≤ lam i := fun i hci =>
    nonneg_coeff_of_isSoS jmulₗ_comm jmulₗ_jordan jmulₗ_inner_assoc
      (fun k => hfam.idem k) (fun k l hkl => hfam.orth k l hkl) hb hbsos hci
  have hsbinv : jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)
      = ∑ i, Real.sqrt ((lam i)⁻¹) • c i :=
    jsqrt_eq_of_resolution' 1 EuclideanJordanAlgebra.one_mul _ hfam rfl
  -- `Q_{√(b⁻¹)} b = 𝟙`, coefficientwise
  have hK : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) b = 1 := by
    rw [hsbinv, hb, quadJ_of_resolution hfam, ← hsum]
    refine Finset.sum_congr rfl fun i _ => ?_
    by_cases hci : c i = 0
    · rw [hci, smul_zero]
    · rw [Real.mul_self_sqrt (inv_nonneg.mpr (hnn i hci)), inv_mul_cancel₀ (hne i hci),
        one_smul]
  refine ⟨quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) y,
    quadJ_isSoS _ hy0, ?_, (quadJ_jsqrt_jinv_cancel hfam hsum hb hbsos hne y).1⟩
  have hsub : quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) (b - y)
      = (1 : J) - quadJ (jsqrt 1 EuclideanJordanAlgebra.one_mul (jinvOfResolution c lam)) y := by
    rw [map_sub, hK]
  rw [← hsub]
  exact quadJ_isSoS _ hyb

end RadicalRelativity.EJA
