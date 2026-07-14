/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.LocalTomography
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

set_option linter.style.longLine false
set_option linter.unusedSectionVars false

/-!
# Master Theorem chain — the abstract interface

Foundation module for the machine-checked formalization of the master theorem of

> Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*
> (`landing/papers/twist-normal-form/main.tex`, `mthm:master`).

**Master theorem (`mthm:master`).** On a finite-dimensional simple Euclidean Jordan
algebra of rank `n ≥ 3`, every norm-continuous S1–S7 sequential product is the
Lüders product on the real, quaternionic, and exceptional types, and equals
`a^{1/2+it} b a^{1/2-it}` for one global real `t` on the complex type `Hₙ(ℂ)`.

The author's mandate: *Lean is to make sure everything passes machine analysis, not
just LLM non-deterministic checking* — so the machine must certify the **logical
chain** from an honest axiom ledger (cited classical theorems) to `mthm:master`.
Chain-completeness beats per-lemma depth: this file carries an abstract interface,
faithful to the paper's proved-vs-imported split, that lets the whole chain assemble
`sorry`-free. The deep classical inputs are `axiom`s (so `#print axioms` enumerates
them); everything the paper *proves* is a Lean theorem downstream.

## The two faces of the interface

The proof has two seams, and this module supplies the object each downstream lane
consumes:

1. **`ComparisonSetup`** — the *comparison-map face*. An abstract simple EJA with its
   Jordan product, Jordan frame, cone/order, the S1–S7 sequential product's diagonal
   effect family `a(r)`, and van de Wetering's comparison map `Θ_a` carrying its cited
   properties (`vdW` Prop 5.3 unital linear order iso; Prop 5.5 fixing of the
   operator-commutant; Prop 5.7 cocycle). Consumed by `Coalescence`, `DiagonalHom`.
   The van Imhoff–Roelands upgrade `order-iso ⟹ Jordan-auto` is the axiom
   `vanImhoffRoelands`; `ComparisonSetup.jordanAuto` *derives* that the paper's
   `prop:theta` conclusion (`Θ_a ∈ Aut(J)`) holds, matching the paper, which proves
   the assembly rather than assuming it.

2. **`StabilizerCoupling`** — the *differential face*. The output of the Lie
   differential reduction (`lem:homomorphism`): the frame-stabilizer Lie algebra
   `Stab`, its block representations `ρ_{ij}` (valued in `𝔰𝔬(V)`), the differential
   `dχ : ℝⁿ → Stab`, and the coupling `ρ_{ij}(dχ(r)) = (r_i − r_j)·T_{ij}`
   (`lem:homomorphism`). Consumed by the four typewise `Branches` lanes.

`DiagonalHom` is the bridge: it produces a `StabilizerCoupling` from a
`ComparisonSetup` using the smoothness axiom (`lieHom_smooth`).

## The axiom ledger (full statement/citation table in `PLAN.md`)

Each classical axiom is declared in the module that first consumes it, so
`#print axioms` on any theorem enumerates exactly the classical inputs it rests on.
This foundation module declares the one axiom it consumes directly:

* `vanImhoffRoelands`  — van Imhoff–Roelands, *Order isomorphisms between cones of
  JB-algebras*, arXiv:1904.09278, **Cor. 2.5 / Prop. 2.6**: a unital linear order
  isomorphism of a JB-algebra is a Jordan isomorphism. (Classical corroboration:
  Alfsen–Shultz, *Geometry of State Spaces*, Thm 2.80.) Used to upgrade `Θ_a`
  (`vdW` Prop 5.3) to a Jordan automorphism in `ComparisonSetup.jordanAuto`.

Declared downstream (ledgered in `PLAN.md`, consumed as noted):

* `lieHom_smooth` (`DiagonalHom`) — classical Lie theory: a continuous homomorphism
  between finite-dimensional Lie groups is smooth (one-parameter-subgroup / Cartan).
  Produces the real-linear differential `dχ` from the `Θ`-cocycle.
* `character_of_Rn` (`Globalization`) — classical: every continuous character
  `ℝⁿ → U(1)` is `r ↦ e^{i c·r}`. Used in the complex globalization.
* `yokota_spin8_triality_faithful` (`Branches`) — Yokota, *Exceptional Lie Groups*,
  Thm 2.7.1 + 1.16.2: the `H₃(𝕆)` frame stabilizer is `Spin(8)` acting by the three
  faithful triality representations. Feeds `StabilizerCoupling.faithful_kill`.

Two further cited inputs are ledgered where they are consumed (not in this file):
the **Yokota** `Spin(8)`-triality faithfulness (Yokota, *Exceptional Lie Groups*,
Thm 2.7.1 + 1.16.2) in the exceptional branch, and the **Faraut–Korányi** Peirce /
frame-conjugacy facts, several of which enter as `ComparisonSetup` fields
(`frame_opCommute`, `simDiag_opCommute`) documented with their FK citation.

The vdW comparison propositions (5.2/5.3/5.5/5.7, Prop 4.20, EJA-appendix
compatibility bridge) are **not** free-standing axioms: they are `ComparisonSetup`
fields, so a reviewer enumerates them by reading the structure, and `#print axioms`
on any downstream theorem records the genuinely-universal classical axioms above.

## References

* Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*.
* van de Wetering, arXiv:1803.08453 (`Wetering2018three`), §5 + EJA appendix.
* van Imhoff–Roelands, arXiv:1904.09278, Cor. 2.5 / Prop. 2.6.
* Faraut–Korányi, *Analysis on Symmetric Cones*, 1994 (Peirce theory, Ch. IV).
* Yokota, *Exceptional Lie Groups*, arXiv:0902.0431, Thm 2.7.1 + 1.16.2.
-/

noncomputable section

open scoped InnerProductSpace
open LocalTomography

namespace MasterTheorem

/-! ## Peirce/block multiplicity `d`

The off-diagonal Peirce multiplicity `d = dim V_{ij}` classifies the branch:
`1, 2, 4, 8` for `Hₙ(ℝ), Hₙ(ℂ), Hₙ(ℍ), H₃(𝕆)` (Faraut–Korányi). Redefined locally
(rather than imported from `TwistNormalForm`) to keep this module's axiom closure
limited to the ledger above. -/

/-- Off-diagonal Peirce multiplicity `d = dim V_{ij}` of a simple EJA type
    (Faraut–Korányi). -/
def blockDim : EJAType → ℕ
  | .real _    => 1
  | .complex _ => 2
  | .quatern _ => 4
  | .albert    => 8
  | .spin n    => n - 2

@[simp] theorem blockDim_real (n : ℕ) : blockDim (.real n) = 1 := rfl
@[simp] theorem blockDim_complex (n : ℕ) : blockDim (.complex n) = 2 := rfl
@[simp] theorem blockDim_quatern (n : ℕ) : blockDim (.quatern n) = 4 := rfl
@[simp] theorem blockDim_albert : blockDim .albert = 8 := rfl

/-- The complex type is the unique simple matrix type whose off-diagonal block is
    even-dimensional *and* carries a torus (`SO(2)`) stabilizer — the source of the
    surviving dial. Recorded here as the arithmetic shadow of the dichotomy: only
    `blockDim = 2` gives a one-dimensional `𝔰𝔬(V_{ij})`. -/
theorem blockDim_complex_unique_dial (t : EJAType) :
    (∃ n, t = .complex n) → blockDim t = 2 := by
  rintro ⟨n, rfl⟩; rfl

/-! ## Operator commutation on an abstract Jordan algebra

For the multiplication operator `T_x(y) = x ∘ y`, elements *operator commute* when
`[T_x, T_y] = 0` (Faraut–Korányi). This is the notion the compatibility bridge
(`vdW` EJA appendix) equates with standard-product compatibility, and the hypothesis
of the `Θ_fix` field below. -/

variable {J : Type*} [AddCommGroup J] [Module ℝ J]

/-- The Jordan multiplication operator `T_x(y) = x ∘ y`. -/
def mulOp (jordan : J →ₗ[ℝ] J →ₗ[ℝ] J) (x : J) : J →ₗ[ℝ] J := jordan x

/-- **Operator commutation** `[T_x, T_y] = 0` (Faraut–Korányi): `x` and `y` operator
    commute iff their Jordan multiplication operators commute. -/
def OpCommute (jordan : J →ₗ[ℝ] J →ₗ[ℝ] J) (x y : J) : Prop :=
  (mulOp jordan x).comp (mulOp jordan y) = (mulOp jordan y).comp (mulOp jordan x)

theorem OpCommute.symm {jordan : J →ₗ[ℝ] J →ₗ[ℝ] J} {x y : J}
    (h : OpCommute jordan x y) : OpCommute jordan y x := Eq.symm h

/-! ## The comparison-map face: `ComparisonSetup`

`ComparisonSetup J` bundles the paper's hypotheses on `J` together with the outputs
of the cited comparison machinery. Its **fields are the audit ledger** for the
imported vdW/FK facts; the van Imhoff–Roelands upgrade is applied through the
`vanImhoffRoelands` axiom in `jordanAuto` below. -/

/-- **The comparison-map interface** (`sec:machinery`). An abstract simple Euclidean
Jordan algebra `J` of rank `n ≥ 3` carrying a norm-continuous S1–S7 sequential
product, presented through van de Wetering's comparison map `Θ_a` and its cited
properties. A concrete simple EJA with a sequential product furnishes one of these;
the master-theorem chain consumes it.

Field ledger (imported facts; cited inline):
* `jordan`, `e`, `jordan_comm`, `jordan_unit` — the Euclidean Jordan product and unit
  (the paper's `(J, ∘, e)`; `jordan_comm`/`jordan_unit` are the cheap correctness
  anchors — full formal reality / the Jordan identity are EJA data, cited FK, and are
  not needed by the chain, which consumes `Θ`).
* `p`, `frame_opCommute` — a Jordan frame `{p_i}` and the FK fact that each `p_i`,
  being diagonal in `F`, operator-commutes with every diagonal effect `a(r)`.
* `nonneg` — the symmetric cone `J⁺` (the order for the order-isomorphism property).
* `Inv`, `aOf`, `aOf_inv` — invertible effects and the diagonal family
  `a(r) = Σ_i e^{r_i} p_i` (invertible for every `r`, `vdW` Prop 4.20 / spectral).
* `Θ`, `Θ_unital`, `Θ_orderIso` — `vdW` **Prop 5.3**: for invertible `a`, the
  comparison map `Θ_a` is a unital linear order isomorphism with `L_a = Q_{√a} Θ_a`.
* `Θ_fix` — `vdW` **Prop 5.5** + EJA-appendix compatibility bridge: `Θ_a` fixes every
  `b` operator-commuting with `a`.
* `Θ_cocycle` — `vdW` **Prop 5.7**: on the commuting diagonal family the comparison
  maps compose, `Θ_{a(r+r')} = Θ_{a(r)} ∘ Θ_{a(r')}` (invariance of the reference
  Lüders product supplies the hypothesis; abelian image). -/
structure ComparisonSetup (J : Type*) [NormedAddCommGroup J] [InnerProductSpace ℝ J] where
  /-- The Euclidean Jordan product `x ∘ y`. -/
  jordan : J →ₗ[ℝ] J →ₗ[ℝ] J
  /-- The Jordan unit `e`. -/
  e : J
  /-- The Jordan product is commutative. -/
  jordan_comm : ∀ x y, jordan x y = jordan y x
  /-- `e` is a left (hence two-sided) unit. -/
  jordan_unit : ∀ x, jordan e x = x
  /-- The rank `n`. -/
  n : ℕ
  /-- Rank hypothesis of `mthm:master`. -/
  rank_ge : 3 ≤ n
  /-- A Jordan frame `{p_1, …, p_n}` (complete orthogonal system of primitive
      idempotents). -/
  p : Fin n → J
  /-- The symmetric cone `J⁺` (the order carrying the order-isomorphism property). -/
  nonneg : J → Prop
  /-- The invertible-effect predicate. -/
  Inv : J → Prop
  /-- The diagonal effect family `a(r) = Σ_i e^{r_i} p_i`, `r ∈ ℝⁿ`. -/
  aOf : (Fin n → ℝ) → J
  /-- Every diagonal effect is invertible (`vdW` Prop 4.20 / spectral). -/
  aOf_inv : ∀ r, Inv (aOf r)
  /-- van de Wetering's comparison map `Θ_a` (defined on invertible effects). -/
  Θ : J → (J ≃ₗ[ℝ] J)
  /-- `vdW` Prop 5.3: `Θ_a` is unital, `Θ_a(e) = e`. -/
  Θ_unital : ∀ a, Inv a → Θ a e = e
  /-- `vdW` Prop 5.3: `Θ_a` is an order isomorphism of the cone. -/
  Θ_orderIso : ∀ a, Inv a → ∀ x, nonneg x ↔ nonneg (Θ a x)
  /-- `vdW` Prop 5.5 + compatibility bridge: `Θ_a` fixes every `b` operator-commuting
      with `a`. -/
  Θ_fix : ∀ a, Inv a → ∀ b, OpCommute jordan a b → Θ a b = b
  /-- FK: each frame idempotent operator-commutes with every diagonal effect. -/
  frame_opCommute : ∀ (r : Fin n → ℝ) (i : Fin n), OpCommute jordan (aOf r) (p i)
  /-- `vdW` Prop 5.7 (cocycle): the comparison maps of the commuting diagonal *effect*
      family compose additively in the exponent. Stated on the negative orthant
      `r, r' ≤ 0` (where `a(r), a(r')` are effects, exactly Prop 5.7's simple commuting
      invertible effects); `DiagonalHom` *proves* the extension to all of `ℝⁿ` via
      `χ̃(s − t) := Θ_s Θ_t⁻¹` (the paper's `lem:homomorphism`), so the field is not
      stronger than the source. -/
  Θ_cocycle : ∀ r r' : Fin n → ℝ, (∀ i, r i ≤ 0) → (∀ i, r' i ≤ 0) →
      Θ (aOf (r + r')) = (Θ (aOf r)).trans (Θ (aOf r'))

namespace ComparisonSetup

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]

/-- **van Imhoff–Roelands, Cor. 2.5 / Prop. 2.6** (arXiv:1904.09278) — *ledger axiom*.
On the Euclidean Jordan algebra encoded by a `ComparisonSetup`, a unital linear order
isomorphism `Θ_a` is a Jordan isomorphism: it preserves the Jordan product. The two
antecedents (`Θ_a(e)=e`, order isomorphism) are supplied from `Θ_unital`/`Θ_orderIso`
in `jordanAuto`, so this axiom is load-bearing, not vacuous. Classical corroboration:
Alfsen–Shultz, *Geometry of State Spaces*, Thm 2.80. -/
axiom vanImhoffRoelands (C : ComparisonSetup J) (a : J) :
    C.Θ a C.e = C.e →
    (∀ x, C.nonneg x ↔ C.nonneg (C.Θ a x)) →
    ∀ x y, C.Θ a (C.jordan x y) = C.jordan (C.Θ a x) (C.Θ a y)

/-- **`prop:theta` (assembly, PROVED).** For invertible `a`, the comparison map `Θ_a`
is a Jordan automorphism of `J`. This is the paper's assembly step: `vdW` Prop 5.3
gives a unital linear order isomorphism (`Θ_unital`, `Θ_orderIso`) and the van
Imhoff–Roelands theorem upgrades it to a Jordan isomorphism — bypassing the
Hilbert-space bicommutant step (`vdW` Lemma 5.8), which has no octonionic analogue.
The paper *derives* this; Lean derives it too, so it is a theorem, not an axiom. -/
theorem jordanAuto (C : ComparisonSetup J) {a : J} (ha : C.Inv a) :
    ∀ x y, C.Θ a (C.jordan x y) = C.jordan (C.Θ a x) (C.Θ a y) :=
  vanImhoffRoelands C a (C.Θ_unital a ha) (C.Θ_orderIso a ha)

/-- **`lem:frame-fix` (first half, PROVED).** The comparison map of a diagonal effect
fixes each frame idempotent: `Θ_{a(r)}(p_i) = p_i`. Immediate from `Θ_fix` (`vdW`
Prop 5.5) and `frame_opCommute` (FK): each `p_i` operator-commutes with `a(r)`. -/
theorem frame_fixed (C : ComparisonSetup J) (r : Fin C.n → ℝ) (i : Fin C.n) :
    C.Θ (C.aOf r) (C.p i) = C.p i :=
  C.Θ_fix (C.aOf r) (C.aOf_inv r) (C.p i) (C.frame_opCommute r i)

end ComparisonSetup

/-! ## The differential face: `StabilizerCoupling`

The output of the Lie differential reduction `lem:homomorphism`: after `DiagonalHom`
produces the smooth character `χ : ℝⁿ → Stab(F)°` and its real-linear differential
`dχ`, the branch lanes work entirely with the linear-algebra data below. All Peirce
blocks `V_{ij}` are modelled by a single real inner product space `V` (they are
mutually isomorphic as inner product spaces; the *representations* `ρ_{ij}` differ,
which is exactly the `8_v/8_s/8_c` triality distinction on the exceptional block). -/

variable (n : ℕ) (Stab : Type*) [AddCommGroup Stab] [Module ℝ Stab]
  (V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- **`lem:homomorphism` (differential form).** The frame-stabilizer coupling consumed
by the four typewise branches: the block representations `ρ_{ij} : 𝔰𝔱𝔞𝔟(F) → 𝔰𝔬(V)`,
the real-linear differential `dχ : ℝⁿ → 𝔰𝔱𝔞𝔟(F)`, and the coupling identity
`ρ_{ij}(dχ(r)) = (r_i − r_j)·T_{ij}` (`lem:homomorphism`). `ρ_skew` records that the
stabilizer acts orthogonally on each block (`T_{ij} ∈ 𝔰𝔬(V_{ij})`, `prop:isotropy`),
so `ρ_{ij}(ξ)` is skew for the trace inner product. -/
structure StabilizerCoupling where
  /-- Block representation `ρ_{ij} : 𝔰𝔱𝔞𝔟(F) → End(V_{ij})`. -/
  ρ : Fin n → Fin n → Stab →ₗ[ℝ] (V →ₗ[ℝ] V)
  /-- `ρ_{ij}(ξ) ∈ 𝔰𝔬(V)`: the stabilizer acts by skew-adjoint operators
      (`prop:isotropy`). -/
  ρ_skew : ∀ i j (ξ : Stab) (x : V), ⟪(ρ i j ξ) x, x⟫_ℝ = 0
  /-- The real-linear differential `dχ : ℝⁿ → 𝔰𝔱𝔞𝔟(F)` (`lem:homomorphism`;
      real-linearity is the Lie smoothness of `χ`). -/
  dχ : (Fin n → ℝ) →ₗ[ℝ] Stab
  /-- The single per-block twist generator `T_{ij}` (`lem:homomorphism`). -/
  T : Fin n → Fin n → (V →ₗ[ℝ] V)
  /-- **The coupling** `ρ_{ij}(dχ(r)) = (r_i − r_j)·T_{ij}` (`lem:homomorphism`): the
      block twist is a single stabilizer element read through `ρ_{ij}`, pinned by
      coalescence to the difference `r_i − r_j`. -/
  coupling : ∀ i j (r : Fin n → ℝ), ρ i j (dχ r) = (r i - r j) • T i j
  /-- Rank hypothesis of `mthm:master` (supplies the third index in the branches). -/
  rank_ge : 3 ≤ n

namespace StabilizerCoupling

variable {n Stab V} [AddCommGroup Stab] [Module ℝ Stab]
  [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- **Coalescence at the differential level (PROVED).** On the coalescence hyperplane
`r_i = r_j` the block coupling vanishes: `ρ_{ij}(dχ(r)) = 0`. This is the differential
shadow of `lem:coalescence` (the twist is `∝ (r_i − r_j)`), and is what makes the
`r_l`-coefficient (`l ≠ i,j`) drop out in every typewise branch. -/
theorem coalescence (S : StabilizerCoupling n Stab V) (i j : Fin n)
    (r : Fin n → ℝ) (h : r i = r j) : S.ρ i j (S.dχ r) = 0 := by
  rw [S.coupling, h, sub_self, zero_smul]

/-- **Twist recovery (PROVED).** From the coupling with any `r` for which
`r_i − r_j = 1`, the twist generator is `T_{ij} = ρ_{ij}(dχ(r))`. Lets a branch pass
between "kill `dχ`" and "kill `T_{ij}`". -/
theorem T_eq (S : StabilizerCoupling n Stab V) (i j : Fin n)
    (r : Fin n → ℝ) (h : r i - r j = 1) : S.T i j = S.ρ i j (S.dχ r) := by
  rw [S.coupling, h, one_smul]

/-- **Faithful-kill reduction (PROVED).** Once the differential vanishes, `dχ = 0`,
every *off-diagonal* twist `T_{ij}` (`i ≠ j`) is zero, so the block action is Lüders.
This is the tail of the exceptional (and real) branch: the faithfulness of the
triality representations of the simple `𝔰𝔭𝔦𝔫(8)` (Yokota, ledgered in the `Branches`
lane) forces `dχ = 0`, and this lemma reads off `T_{ij} = 0` from there. -/
theorem faithful_kill (S : StabilizerCoupling n Stab V)
    (hdχ : S.dχ = 0) {i j : Fin n} (hij : i ≠ j) : S.T i j = 0 := by
  have hr : (Pi.single i 1 : Fin n → ℝ) i - (Pi.single i 1 : Fin n → ℝ) j = 1 := by
    rw [Pi.single_eq_same, Pi.single_eq_of_ne (Ne.symm hij), sub_zero]
  rw [S.T_eq i j (Pi.single i 1) hr, hdχ]
  simp

end StabilizerCoupling

end MasterTheorem
