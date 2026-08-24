/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Class
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

end RadicalRelativity.EJA
