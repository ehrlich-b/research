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
