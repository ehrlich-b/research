/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.MasterTheorem.Interface
import Mathlib.LinearAlgebra.StdBasis
import Mathlib.LinearAlgebra.Dimension.Finrank

set_option linter.style.longLine false
set_option linter.unusedSectionVars false

/-!
# Master Theorem chain — the exceptional branch `H₃(𝕆)` (`thm:albert`)

The exceptional typewise branch of

> Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*
> (`landing/papers/twist-normal-form/main.tex`, `thm:albert`).

**`thm:albert`.** On the Albert algebra `H₃(𝕆)`: `Θ_r = id` for all `r`, so the
sequential product is Lüders, `a•b = Q_{√a}b`.

## The argument (`thm:albert`, note `C1-CROSSTYPE-STABILIZER` Piece 5)

The frame stabilizer of `H₃(𝕆)` is `Spin(8)`, acting on the three octonionic
Peirce lines `(V₁₂, V₁₃, V₂₃)` by the *triality triple* `(8_v, 8_s, 8_c)`
(Yokota; see the axiom below). In the differential face this means: the block
representations `ρ_{ij} : 𝔰𝔭𝔦𝔫(8) → 𝔰𝔬(V_{ij})` are the three triality
representations, each a **nontrivial** representation of the **simple** Lie
algebra `𝔰𝔭𝔦𝔫(8)`, hence **faithful** — *unlike* the individual complex (torus)
and quaternionic block representations, whose kernels are nonzero.

The rank of `H₃(𝕆)` is exactly `3`, so a single frame is directly a three-index
configuration and no cross-frame globalization is needed. With `dχ(r) =
Σ_{k} r_k η_k` (`lem:homomorphism`) and `ρ_{ij}(dχ(r)) = (r_i − r_j)T_{ij}`:
for block `V₁₂` the coefficient of `r₃` is `ρ₁₂(η₃) = 0` (coalescence: the RHS is
`∝ r₁ − r₂`), and faithfulness of `ρ₁₂` forces `η₃ = 0`; symmetrically `η₂ = 0`
(block `V₁₃`) and `η₁ = 0` (block `V₂₃`). Thus `dχ ≡ 0`, so `Θ_r = id` and every
off-diagonal twist `T_{ij}` vanishes. Working with `Spin(8)` abstractly sidesteps
octonionic non-associativity.

In the interface this is exactly: **injectivity of every off-diagonal `ρ_{ij}`**
plus `StabilizerCoupling.coalescence` kills `dχ` on each standard basis vector of
`ℝ³`, hence `dχ = 0` (`dchi_eq_zero_of_faithful`), and then
`StabilizerCoupling.faithful_kill` reads off `T_{ij} = 0` (`albert_luders`).

## The single import (ledger axiom A4)

The only external input is the `Spin(8)`-triality identification of the frame
stabilizer, ledgered as `yokota_spin8_triality_faithful`: for a coupling modelling
`H₃(𝕆)` (marker `IsAlbertModel`), each off-diagonal block representation is
injective. Everything downstream (coalescence + faithful-kill) is proved from the
interface. `dchi_eq_zero_of_faithful` is the axiom-free heart (injective block
representations ⟹ `dχ = 0`); the capstone `albert_luders` discharges injectivity
via the axiom for the Albert model.
-/

noncomputable section

open scoped InnerProductSpace

namespace MasterTheorem

variable {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
  {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-! ## The Albert model marker

`IsAlbertModel S` *names* the object `thm:albert` is about: the rank-`3`
frame-stabilizer coupling of `H₃(𝕆)`, whose block space is the octonionic Peirce
line (`dim_ℝ V_{ij} = 8`), whose stabilizer is `Spin(8)` (`dim_ℝ 𝔰𝔭𝔦𝔫(8) = 28`),
and whose block representations are the nonzero triality representations. Among the
four simple EJA block types these dimensions occur *only* for `H₃(𝕆)`
(`blockDim` is `1, 2, 4, 8` for `ℝ, ℂ, ℍ, 𝕆`; `𝔰𝔱𝔞𝔟` is `0, 2, 9, 28`), so the
marker is unsatisfiable off the exceptional type — this is what keeps the
faithfulness axiom below from overclaiming on the other three types. The genuine
representation-theoretic content (that these `28`-dimensional generators carry the
*simple* Lie structure `𝔰𝔭𝔦𝔫(8)` and act by the *triality* representations) is the
imported Yokota fact, recorded as `yokota_spin8_triality_faithful`. -/
structure IsAlbertModel (S : StabilizerCoupling 3 Stab V) : Prop where
  /-- Each Peirce block `V_{ij}` is an octonionic line: `dim_ℝ V = 8`. -/
  block_rank : Module.finrank ℝ V = 8
  /-- The frame stabilizer is `Spin(8)`: `dim_ℝ 𝔰𝔭𝔦𝔫(8) = 28`. -/
  stab_rank : Module.finrank ℝ Stab = 28
  /-- Each block representation is nontrivial (the triality representations are
      nonzero). Combined with simplicity of `𝔰𝔭𝔦𝔫(8)` this is what forces
      faithfulness; the simplicity is imported in the axiom below. -/
  block_nontrivial : ∀ i j : Fin 3, i ≠ j → S.ρ i j ≠ 0

/-! ## Ledger axiom A4 — Yokota `Spin(8)`-triality faithfulness -/

/-- **Yokota, *Exceptional Lie Groups*, arXiv:0902.0431 — ledger axiom A4.**
For `H₃(𝕆)` with `F₄ = Aut(H₃(𝕆))`, the pointwise stabilizer of the three
diagonal primitive idempotents is `≅ Spin(8)` (**Thm 2.7.1**, p. 51), realized as
the triality triple `{(a₁,a₂,a₃) ∈ SO(8)³ : (a₁x)(a₂y) = a₃(xy)}` (**Thm 1.16.2**,
pp. 28–29), whose three `SO(8)` factors act on the three octonionic Peirce lines
`(V₁₂, V₁₃, V₂₃)` by the vector and the two half-spin representations, the
`8_v, 8_s, 8_c` of Baez, *The Octonions*, Bull. AMS **39** (2002), §2.4/4.2. Each is
a **nontrivial** representation of the **simple** Lie algebra `𝔰𝔭𝔦𝔫(8)`, hence
**faithful**.

*Consumed form.* For a `StabilizerCoupling` modelling `H₃(𝕆)` (marker
`IsAlbertModel`), each off-diagonal block representation `ρ_{ij}` (`i ≠ j`) is
injective. This is exactly Yokota's faithfulness of the triality triple, not
stronger: the marker restricts to the `Spin(8)`-triality data (`dim` `8`/`28`,
blocks nonzero), and the injective conclusion is faithfulness of a nontrivial
representation of the simple `𝔰𝔭𝔦𝔫(8)`. The step "nontrivial ⟹ faithful" is
elementary Lie theory (a representation's kernel is an ideal; a simple algebra has
only `0` and itself as ideals); it is axiomatized here rather than proved because
`Stab` carries no Lie structure in the abstract interface. -/
axiom yokota_spin8_triality_faithful (S : StabilizerCoupling 3 Stab V)
    (hAlb : IsAlbertModel S) (i j : Fin 3) (hij : i ≠ j) :
    Function.Injective (S.ρ i j)

/-! ## The exceptional branch -/

/-- **`thm:albert`, axiom-free heart.** If every off-diagonal block representation
`ρ_{ij}` (`i ≠ j`) of a rank-`3` frame-stabilizer coupling is injective, then the
differential vanishes: `dχ = 0`.

The proof kills `dχ` on each standard basis vector `e_k = Pi.single k 1` of `ℝ³`.
For `e_k`, pick the two other indices `i, j` (both `≠ k`, and `i ≠ j`; available
since the block space has three indices `0, 1, 2`): then `(e_k)_i = (e_k)_j = 0`, so
`StabilizerCoupling.coalescence` gives `ρ_{ij}(dχ(e_k)) = 0`, and injectivity of
`ρ_{ij}` forces `dχ(e_k) = 0`. As the `e_k` are a basis, `dχ = 0`. This is the
faithful-triality kill of `thm:albert` with the `Spin(8)` identification abstracted
into the injectivity hypothesis. -/
theorem dchi_eq_zero_of_faithful (S : StabilizerCoupling 3 Stab V)
    (hf : ∀ i j : Fin 3, i ≠ j → Function.Injective (S.ρ i j)) :
    S.dχ = 0 := by
  -- Kill `dχ` on the basis vector `e_k`, using the two indices `i, j ∉ {k}`.
  have kill : ∀ i j k : Fin 3, i ≠ j → i ≠ k → j ≠ k →
      S.dχ (Pi.single k (1 : ℝ)) = 0 := by
    intro i j k hij hik hjk
    have hcoal : S.ρ i j (S.dχ (Pi.single k (1 : ℝ))) = 0 :=
      S.coalescence i j (Pi.single k (1 : ℝ)) (by
        rw [Pi.single_eq_of_ne hik, Pi.single_eq_of_ne hjk])
    exact hf i j hij (by rw [hcoal, map_zero])
  refine (Pi.basisFun ℝ (Fin 3)).ext fun k => ?_
  simp only [Pi.basisFun_apply, LinearMap.zero_apply]
  fin_cases k
  · exact kill 1 2 0 (by decide) (by decide) (by decide)
  · exact kill 0 2 1 (by decide) (by decide) (by decide)
  · exact kill 0 1 2 (by decide) (by decide) (by decide)

/-- **`thm:albert` (capstone).** On the exceptional type — a rank-`3`
`StabilizerCoupling` modelling `H₃(𝕆)` (marker `IsAlbertModel`) — every
off-diagonal block twist vanishes: `T_{ij} = 0` for `i ≠ j`. Hence `Θ_r = id` on
every block and the sequential product is Lüders, `a•b = Q_{√a}b`.

The proof discharges injectivity of each `ρ_{ij}` via the Yokota axiom
`yokota_spin8_triality_faithful`, obtains `dχ = 0` from `dchi_eq_zero_of_faithful`,
and reads off `T_{ij} = 0` with `StabilizerCoupling.faithful_kill`. Only the single
ledger axiom A4 enters. -/
theorem albert_luders (S : StabilizerCoupling 3 Stab V) (hAlb : IsAlbertModel S)
    {i j : Fin 3} (hij : i ≠ j) : S.T i j = 0 := by
  have hf : ∀ i j : Fin 3, i ≠ j → Function.Injective (S.ρ i j) :=
    fun i j hij => yokota_spin8_triality_faithful S hAlb i j hij
  have hdχ : S.dχ = 0 := dchi_eq_zero_of_faithful S hf
  exact S.faithful_kill hdχ hij

end MasterTheorem
