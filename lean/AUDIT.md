# MasterTheorem Tree Audit (2026-07-14, two rounds)

New tree `RadicalRelativity/MasterTheorem/` (twist paper).

## Round 1 (self-audit) — and what it MISSED

Initial state: 3 global axioms — the since-superseded declarations
`vanImhoffRoelands`, `lieHom_smooth`, `yokota_spin8_triality_faithful`;
`#print axioms` on the former capstone = those 3 + core; zero sorry; full
build green (2861 jobs) — all orchestrator-verified.
Anti-vacuity spot checks passed (antecedent-gated axioms, coupling PROVED in
the constructor). **The self-audit missed the deeper failure**: all three
axioms were quantified over interfaces too weak for their sources, making
them FALSE as global statements (instantiable counterexamples ⟹ potential
inconsistency) — the classic axiom-scope trap, one level below the vacuity
trap this file's 2026-03-29 audit documents.

## Round 2 (external adversarial audit, Sol) — findings + repairs

Report: `blog/research/qm-genericity-review/TWIST-NORMAL-FORM-MAXIMAL-ADVERSARIAL-2026-07-14.md`.
Findings (all orchestrator-re-verified against the code): A2 as typed asserted
every additive map ℝⁿ→Stab is ℝ-linear (false, no topology); A1 quantified
over `ComparisonSetup`, which encodes no Jordan identity/formal
reality/cone; A4's dims-8/28+nonzero gate does not imply injectivity; the
capstone was an abstract-coupling conjunction, not the paper theorem; the
differential face was disconnected from Θ; the appendix oversold all of it.

Repairs (loop 1, same day): **every custom axiom ELIMINATED** —
A1 → `ComparisonSetup.Θ_jordan` field (cited vIR hypothesis);
A2 → proved `def` via Mathlib `AddMonoidHom.toRealLinearMap` (continuity =
cited field `dχAdd_cont`); A3 was already the proved
`real_character_unique`; A4 → `IsAlbertModel.block_injective` field (cited
Yokota hypothesis). Capstone renamed `master_chain`, docstringed as the
dependency-SKELETON counterpart of `mthm:master` (NOT the paper theorem),
with the 5b globalization anchored to the produced coupling by a
deletion-verified hypothesis `Scfam F₀ = Dc.toStabilizerCoupling`.

End state (orchestrator-verified): zero `axiom` declarations tree-wide;
`#print axioms MasterTheorem.master_chain` = [propext, Classical.choice,
Quot.sound]; full build green (2861 jobs); zero sorry. NOTE: core-only
closure is a syntactic figure, not a faithfulness certificate — the
classical-import surface is the interface FIELD lists (Θ_jordan,
block_injective, dχAdd_cont, Θ_fix span-extension, coalescence_diff, hmove,
overlap, S2-continuity/density), all catalogued in `MasterTheorem/PLAN.md` §2.

# Adversarial Audit (2026-03-29)

## CRITICAL -- Lean claims to prove something it doesn't

### C1. SM gauge group is vacuous
`SMGaugeGroupData` = `{carrier : Type*, dim : ℕ, dim_eq : dim = 12}`.
`todorov_drenska` says `∃ G, True`. U(1)^12 satisfies this.
Paper 7 claims Spin(9) ∩ [SU(3)xSU(3)]/Z_3 = SM gauge group.
Lean proves: "there exists a type with a number equal to 12."

### C2. Chirality is tautological
`furey_selects_left` = `⟨.left, rfl⟩`. Constructs the answer, returns it.
`chirality_from_self_modeling` = get G from todorov_drenska, return `⟨G, .left, rfl⟩`.
No Cl(6), no Furey, no Pati-Salam enters. Could equally prove `.diagonal`.

### C3. Hypercharges are inputs not derivations
`HyperchargeAssignments` encodes SM values as structure fields.
Paper 7 claims computed from intersection. Lean puts them in by hand.

## MAJOR -- real gaps in derivation chain

### M1. SelfModelingSystem doesn't match Definition 1
Lean captures condition (ii) only (order isomorphism). Missing:
- Nontriviality (at least two orthogonal projective units)
- Finite-dimensionality
- Minimality of composite (condition iii) -- needed for LT derivation
- Simplicity/irreducibility (condition iv)

### M2. No self-modeling -> IsLocallyTomographic theorem
Paper 5 Theorem 5.10 (minimality -> dim = d^2) not formalized.
Chain has unfilled link: must manually supply IsLocallyTomographic to use vdw_theorem_3.
Blocked by M1 (need minimality condition first).

### M3. SimpleEJA too weak
Just a type + binary op + number called "rank". No Jordan identity, formal reality,
simplicity, or finite-dim. Axioms operate on unconstrained structures.

### M4. rhoJ F4-invariance bridge is vacuous
Degree-5 uniqueness proof is real. But `f4_invariant_ring : True` means the bridge
from F4-invariance to sigma_2/sigma_3 dependence contributes nothing.

## NOT BUGS (known/by design)

- Paper 6 chain all `True` -- documented as scaffolding
- `True` placeholder axioms for published theorems -- structural documentation
- Albert `zelmanov_uniqueness` concludes `True` -- not load-bearing
- `localTomographyHolds` definition is dead code (actual type exclusion theorems correct)

## What IS proved (real value)

- SelfModelingBridge S1-S7 from typed Alfsen-Shultz axioms
- Type exclusion (real/quaternionic) -- genuine arithmetic
- NonComposability chain -- structurally sound (modulo M3)
- rhoJ degree-5 uniqueness -- real polynomial argument
- F4 stabilizer conjugacy -- real proof from typed G2-transitivity axiom
