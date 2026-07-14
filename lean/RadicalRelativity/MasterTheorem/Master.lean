/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.MasterTheorem.DiagonalHom
import RadicalRelativity.MasterTheorem.Branches.Real
import RadicalRelativity.MasterTheorem.Branches.Quaternionic
import RadicalRelativity.MasterTheorem.Branches.Albert
import RadicalRelativity.MasterTheorem.Branches.Complex
import RadicalRelativity.MasterTheorem.Globalization
import RadicalRelativity.MasterTheorem.Adapter
import Mathlib.Topology.Basic

set_option linter.style.longLine false
set_option linter.unusedSectionVars false

/-!
# Master Theorem — the whole-chain assembly (`mthm:master`)

The capstone module. It assembles the four typewise branches and the complex
globalization into the master theorem of

> Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*
> (`landing/papers/twist-normal-form/main.tex`, `mthm:master`),

each branch consuming the **produced** frame-stabilizer coupling
`DiagonalHomSetup.toStabilizerCoupling` (not a free hypothesis), together with the
frame-fixing certificate (`lem:frame-fix`, `prop:theta`) and `prop:singular`.

## The whole-chain axiom audit

`#print axioms master_theorem` rests on exactly the three genuinely-universal
classical theorems of the PLAN ledger, plus Lean's three core axioms:

* **A1 `vanImhoffRoelands`** — a unital linear order isomorphism of a JB-algebra is a
  Jordan isomorphism (arXiv:1904.09278, Cor. 2.5). Enters via `block_preserved`
  (`ComparisonSetup.jordanAuto` = `prop:theta`): the frame-fixing / block-preservation
  certificate, which is what makes Peirce-block-diagonality a *conclusion* and licenses
  the whole differential face.
* **A2 `lieHom_smooth`** — Cartan smoothness of a continuous Lie-group homomorphism
  (differential is real-linear). Enters via `DiagonalHomSetup.toStabilizerCoupling`,
  used by every typewise branch.
* **A4 `yokota_spin8_triality_faithful`** — Yokota's `Spin(8)`-triality faithfulness for
  `H₃(𝕆)` (arXiv:0902.0431). Enters via `albert_luders`.

Ledger axiom **A3** (`character_of_Rn`) is **not** present: `Globalization` proved it as
`real_character_unique` (differentiate the character at a point — no `2π` ambiguity), so
the complex globalization introduces no custom axiom. The van de Wetering / Faraut–Korányi
comparison propositions are `ComparisonSetup`/`CoalescenceSetup` structure fields (the
auditor reads them off the field list), not free axioms.

**Audit note on the complex case.** The globalization clause (5b) quantifies over an
abstract per-frame coupling family; the produced-coupling audit anchor for the complex type
is clause (5a) on `Dc.toStabilizerCoupling`.

## Scope (rank two is a separate boundary; see `RankTwo.lean`)

`master_theorem` is the rank `n ≥ 3` statement (the `rank_ge` field). The rank-two boundary
— the rigid real qubit versus the explicit frame-dependent `τ(F)` family for the complex
qubit — is the separate necessity-only development in `RadicalRelativity/MasterTheorem/RankTwo.lean`
(`prop:n2-necessity`, `thm:qubit-boundary`), which is **not** imported here and carries its
own concrete `M₂(ℂ)` proofs. The master theorem makes no exhaustiveness claim at rank two.

## `prop:singular` (S2 extension)

`prop_singular` proves the honest kernel of `prop:singular`: two norm-continuous product
actions agreeing on the (dense) invertible effects agree on *all* effects
(`Set.EqOn.closure` — continuity + density). The S2-continuity of the product and the
density of the invertibles enter as the explicit, disclosed hypotheses (`hf`, `hg`,
`hdense`), matching the paper's `a_ε = (1−ε)a + εe → a` limit; nothing is faked.

## References

* Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*,
  `mthm:master`, `prop:singular`, `lem:frame-fix`.
-/

noncomputable section

open scoped InnerProductSpace

namespace MasterTheorem

/-! ## `prop:singular` — the S2 continuity/density extension kernel -/

/-- **`prop:singular` (S2 extension, PROVED kernel).** Two continuous maps that agree on a
dense set agree everywhere. This is the mathematical content of `prop:singular`: the
sequential product is determined on the invertible effects (the typewise theorems), and
every effect is a limit of invertibles (`a_ε = (1−ε)a + εe → a`, S2-continuity), so the
Lüders / single-twist form extends from the invertibles to all effects.

The S2-continuity (`hf`, `hg`) and the density of the invertible effects (`hdense`) are the
explicit disclosed hypotheses; the extension itself is proved (`Set.EqOn.closure`). Stated
over abstract spaces `X` (effects) and `W` (product actions) so it applies to whichever
concrete product objects `mthm:master`'s assembly instantiates. -/
theorem prop_singular {X W : Type*} [TopologicalSpace X] [TopologicalSpace W] [T2Space W]
    {Inv : Set X} (hdense : Dense Inv) (Lref Lunknown : X → W)
    (hf : Continuous Lref) (hg : Continuous Lunknown)
    (hagree : Set.EqOn Lref Lunknown Inv) : Lref = Lunknown := by
  funext a
  exact hagree.closure hf hg (hdense.closure_eq ▸ Set.mem_univ a)

/-! ## Per-type building blocks (each over the PRODUCED coupling)

Each lemma runs its typewise branch on `D.toStabilizerCoupling` — the coupling *produced*
by the Lie-differential reduction from the comparison-map face — so the assembly never
takes the `StabilizerCoupling` as a free hypothesis. -/

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J]

/-- **`lem:frame-fix` certificate (A1).** For the produced setup, `Θ_{a(r)}` preserves each
Peirce block `V_{ij}`. This is the frame-fixing that makes the differential face legitimate
(`prop:theta` ⟹ block-preservation), and it is the step through which the master theorem
depends on `vanImhoffRoelands` (A1). -/
theorem frame_block_fixed {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
    {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (D : DiagonalHomSetup J Stab V) (r : Fin D.n → ℝ) {i j : Fin D.n} {x : J}
    (hx : (D.toCoalescenceSetup.toComparisonSetup).isBlock i j x) :
    (D.toCoalescenceSetup.toComparisonSetup).isBlock i j
      ((D.toCoalescenceSetup.toComparisonSetup).Θ ((D.toCoalescenceSetup.toComparisonSetup).aOf r) x) :=
  block_preserved _ r hx

/-- **Real branch over the produced coupling (`prop:real`).** -/
theorem luders_real_produced {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
    (D : DiagonalHomSetup J Stab ℝ) {i j : Fin D.n} (hij : i ≠ j) :
    (D.toStabilizerCoupling).T i j = 0 :=
  real_luders _ hij

/-- **Quaternionic branch over the produced coupling (`thm:quaternionic`).** The two-slot
model form of `ρ_{ij}` (`hρ`, with imaginary coordinates `im`) is the explicit typewise
data; `Z(ℍ) ∩ Im ℍ = 0` and the `n ≥ 3` spectator index do the rest. -/
theorem luders_quaternionic_produced {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
    (D : DiagonalHomSetup J Stab (Quaternion ℝ))
    (im : Stab → Fin D.n → Quaternion ℝ)
    (himag : ∀ (ξ : Stab) (k : Fin D.n), (im ξ k).re = 0)
    (hρ : ∀ (i j : Fin D.n) (ξ : Stab) (x : Quaternion ℝ),
      (D.toStabilizerCoupling).ρ i j ξ x = im ξ i * x - x * im ξ j)
    {i j : Fin D.n} (hij : i ≠ j) : (D.toStabilizerCoupling).T i j = 0 :=
  Quaternionic.quaternionic_luders _ im himag hρ hij

/-- **Exceptional branch over the produced coupling (`thm:albert`).** The rank is exactly
`3` (`hn3`) and the coupling models `H₃(𝕆)` (`IsAlbertModel`); the Yokota triality axiom
(A4) supplies faithfulness. -/
theorem luders_albert_produced {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
    {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (D : DiagonalHomSetup J Stab V) (hn3 : D.n = 3)
    (hAlb : IsAlbertModel (hn3 ▸ D.toStabilizerCoupling))
    {i j : Fin 3} (hij : i ≠ j) : (hn3 ▸ D.toStabilizerCoupling).T i j = 0 :=
  albert_luders _ hAlb hij

/-- **Complex branch over the produced coupling (`thm:complex`, per-frame).** The torus
model (`J ≠ 0`, character matrix `c`) collapses the per-pair constants to a single per-frame
`t_F`. -/
theorem complex_perFrame_produced {Stab : Type*} [AddCommGroup Stab] [Module ℝ Stab]
    {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (D : DiagonalHomSetup J Stab V) (Jc : V →ₗ[ℝ] V) (hJc : Jc ≠ 0)
    (c : Fin D.n → Fin D.n → ℝ)
    (hmodel : ∀ i j (r : Fin D.n → ℝ),
      (D.toStabilizerCoupling).ρ i j ((D.toStabilizerCoupling).dχ r)
        = ((∑ l, c i l * r l) - (∑ l, c j l * r l)) • Jc) :
    ∃ tF : ℝ, ∀ i j (r : Fin D.n → ℝ),
      (D.toStabilizerCoupling).ρ i j ((D.toStabilizerCoupling).dχ r) = (tF * (r i - r j)) • Jc :=
  complex_perFrame_rho _ Jc hJc c hmodel

/-! ## The master theorem -/

/-- **`mthm:master` (whole-chain assembly).** On a finite-dimensional simple Euclidean
Jordan algebra of rank `n ≥ 3`, every norm-continuous S1–S7 sequential product is the
Lüders product on the real, quaternionic, and exceptional types, and the single-parameter
twist `a•b = a^{1/2+it} b a^{1/2−it}` for one global `t` on the complex type.

The statement quantifies over one **produced** frame-stabilizer coupling per simple type —
`Dᵣ/D_h/D_a/D_c.toStabilizerCoupling`, built from a `ComparisonSetup` by the Lie-differential
reduction — so the audit point holds: the coupling entering each branch is the produced one,
never a free hypothesis. The conclusion is the conjunction of:

1. the frame-fixing certificate `lem:frame-fix` (block preservation; the `prop:theta`/A1
   step licensing the differential face);
2. **real** `Hₙ(ℝ)`: `T_{ij} = 0` (Lüders) — `prop:real`;
3. **quaternionic** `Hₙ(ℍ)`: `T_{ij} = 0` (Lüders) — `thm:quaternionic`, with the two-slot
   model data `im`/`hρ`;
4. **exceptional** `H₃(𝕆)`: `T_{ij} = 0` (Lüders) — `thm:albert`, with the `IsAlbertModel`
   marker and `n = 3`;
5. **complex** `Hₙ(ℂ)`: a single per-frame `t_F` on the produced coupling (`thm:complex`
   torus model) and a single **global** `t` across all frames, obtained through the
   adapter's `complex_global_twist` (per-frame `perFrameTwist` collapsed by
   `Globalization.global_t` — frame connectivity + `real_character_unique`, no `2π`
   ambiguity). The frame connectivity (`connected`) and cross-coherence (`overlap`) are the
   adapter's disclosed located hypotheses.

`#print axioms` is exactly `{vanImhoffRoelands, lieHom_smooth, yokota_spin8_triality_faithful}`
plus Lean core — the whole-chain ledger. -/
theorem master_theorem
    -- real type `Hₙ(ℝ)`: block space `V = ℝ` (`blockDim = 1`)
    {Sr : Type*} [AddCommGroup Sr] [Module ℝ Sr] (Dr : DiagonalHomSetup J Sr ℝ)
    -- quaternionic type `Hₙ(ℍ)`: block space `V = ℍ`, two-slot model `im`/`hρ`
    {Sh : Type*} [AddCommGroup Sh] [Module ℝ Sh] (Dh : DiagonalHomSetup J Sh (Quaternion ℝ))
    (imh : Sh → Fin Dh.n → Quaternion ℝ)
    (himagh : ∀ (ξ : Sh) (k : Fin Dh.n), (imh ξ k).re = 0)
    (hρh : ∀ (i j : Fin Dh.n) (ξ : Sh) (x : Quaternion ℝ),
      (Dh.toStabilizerCoupling).ρ i j ξ x = imh ξ i * x - x * imh ξ j)
    -- exceptional type `H₃(𝕆)`: `n = 3`, `IsAlbertModel`
    {Sa : Type*} [AddCommGroup Sa] [Module ℝ Sa]
    {Va : Type*} [NormedAddCommGroup Va] [InnerProductSpace ℝ Va]
    (Da : DiagonalHomSetup J Sa Va) (hn3 : Da.n = 3)
    (hAlb : IsAlbertModel (hn3 ▸ Da.toStabilizerCoupling))
    -- complex type `Hₙ(ℂ)`: torus model `Jc ≠ 0`, character matrix `cc`
    {Sc : Type*} [AddCommGroup Sc] [Module ℝ Sc]
    {Vc : Type*} [NormedAddCommGroup Vc] [InnerProductSpace ℝ Vc]
    (Dc : DiagonalHomSetup J Sc Vc) (Jc : Vc →ₗ[ℝ] Vc) (hJc : Jc ≠ 0)
    (cc : Fin Dc.n → Fin Dc.n → ℝ)
    (hmodelc : ∀ i j (r : Fin Dc.n → ℝ),
      (Dc.toStabilizerCoupling).ρ i j ((Dc.toStabilizerCoupling).dχ r)
        = ((∑ l, cc i l * r l) - (∑ l, cc j l * r l)) • Jc)
    -- complex globalization: a per-frame family of couplings + the frame graph
    -- (`lem:frame-connectivity` = `connected`; cross-coherence = `overlap`), consumed
    -- through the adapter's `complex_global_twist`
    {Frame : Type*} [Nonempty Frame]
    (Scfam : Frame → StabilizerCoupling Dc.n Sc Vc)
    (cfam : Frame → (Fin Dc.n → Fin Dc.n → ℝ))
    (hmodelfam : ∀ (F : Frame) i j (r : Fin Dc.n → ℝ),
      (Scfam F).ρ i j ((Scfam F).dχ r)
        = ((∑ l, cfam F i l * r l) - (∑ l, cfam F j l * r l)) • Jc)
    (Adj : Frame → Frame → Prop)
    (connected : ∀ F G, Relation.ReflTransGen (Globalization.SymmStep Adj) F G)
    (overlap : ∀ F G, Adj F G → ∃ a b : ℝ, a < b ∧ ∀ x ∈ Set.Ioo a b,
        Complex.exp ((perFrameTwist (Scfam F) Jc hJc (cfam F) (hmodelfam F) : ℂ) * x * Complex.I)
          = Complex.exp ((perFrameTwist (Scfam G) Jc hJc (cfam G) (hmodelfam G) : ℂ) * x * Complex.I)) :
    -- (1) frame-fixing certificate (A1)
    (∀ (r : Fin Dr.n → ℝ) {i j : Fin Dr.n} {x : J},
        (Dr.toCoalescenceSetup.toComparisonSetup).isBlock i j x →
        (Dr.toCoalescenceSetup.toComparisonSetup).isBlock i j
          ((Dr.toCoalescenceSetup.toComparisonSetup).Θ ((Dr.toCoalescenceSetup.toComparisonSetup).aOf r) x))
    -- (2) real Lüders
    ∧ (∀ {i j : Fin Dr.n}, i ≠ j → (Dr.toStabilizerCoupling).T i j = 0)
    -- (3) quaternionic Lüders
    ∧ (∀ {i j : Fin Dh.n}, i ≠ j → (Dh.toStabilizerCoupling).T i j = 0)
    -- (4) exceptional Lüders
    ∧ (∀ {i j : Fin 3}, i ≠ j → (hn3 ▸ Da.toStabilizerCoupling).T i j = 0)
    -- (5a) complex per-frame single `t_F` on the PRODUCED coupling `Dc.toStabilizerCoupling`
    ∧ (∃ tF : ℝ, ∀ i j (r : Fin Dc.n → ℝ),
        (Dc.toStabilizerCoupling).ρ i j ((Dc.toStabilizerCoupling).dχ r) = (tF * (r i - r j)) • Jc)
    -- (5b) complex single GLOBAL `t` across all frames (adapter `complex_global_twist`)
    ∧ (∃ tG : ℝ, ∀ F : Frame, perFrameTwist (Scfam F) Jc hJc (cfam F) (hmodelfam F) = tG) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro r i j x hx; exact frame_block_fixed Dr r hx
  · intro i j hij; exact luders_real_produced Dr hij
  · intro i j hij; exact luders_quaternionic_produced Dh imh himagh hρh hij
  · intro i j hij; exact luders_albert_produced Da hn3 hAlb hij
  · exact complex_perFrame_produced Dc Jc hJc cc hmodelc
  · exact complex_global_twist Scfam Jc hJc cfam hmodelfam Adj connected overlap

end MasterTheorem
