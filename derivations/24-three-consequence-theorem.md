# Three-Consequence Theorem: One Choice Determines Gauge Group, Chirality, and Time-Orientation

% ASSERT_CONVENTION: natural_units=dimensionless, clifford_convention=lorentzian_mostly_minus, octonion_basis=fano_e1e2=e4, complex_structure=u_equals_e7, spin_representation=S10plus_boyle

**Phase 24, Plan 02, Task 1**
**Date:** 2026-03-24

---

## 1. Recap: Paper 7's Two-Consequence Theorem

Paper 7, Theorem 4.2 ("One choice, two consequences") establishes:

**Inputs:**
- (Gap A) h_3(O) is the universe algebra.
- (Gap B1) Observer selects rank-1 idempotent E_{11}, breaking F_4 -> Spin(9).
- (Gap B2) Observer selects complex structure u in S^6 subset Im(O).
- (Gap C) Complexification principle: V_{1/2} tensor_R C = S_{10}^+.

**Theorem 4.2 (Paper 7, synthesis.tex).** The single choice of u in S^6 simultaneously determines:

**(a) GAUGE GROUP (Route A, F_4 intersection):**
The splitting O = C + C^3 induced by u gives [SU(3)_C x SU(3)_J]/Z_3 subset F_4. Its intersection with Spin(9) = Stab_{F_4}(E_{11}) contains SU(3)_C x SU(2) x U(1) (dim 12).

**(b) CHIRALITY (Route B, Cl(6)/Pati-Salam):**
The same u defines W = u^perp (6-dim subspace), whose generators gamma_1,...,gamma_6 form Cl(6) subset Cl(10). The volume form omega_6 = gamma_1...gamma_6 breaks Spin(10) -> Pati-Salam, and u further breaks SU(4) -> SU(3)_C x U(1)_{B-L}, giving the SM gauge group with the LEFT chiral embedding:

$$\mathbf{16} \to (\mathbf{4},\mathbf{2},\mathbf{1}) \oplus (\bar{\mathbf{4}},\mathbf{1},\mathbf{2})$$

Both consequences follow from the single algebraic input u. No additional data beyond u and E_{11} is needed.

**What Paper 7 does NOT say:** Paper 7 never mentions time-orientation. The chirality in Theorem 4.2 is purely algebraic: omega_6 decomposes S_{10}^+ into L/R sectors as a representation-theoretic fact. The question of what geometric conditions are needed to *physically realize* this chirality on a spacetime manifold is not addressed.

### SELF-CRITIQUE CHECKPOINT (Step 1):
1. SIGN CHECK: N/A (recap of established results).
2. FACTOR CHECK: N/A (no new factors introduced).
3. CONVENTION CHECK: Cl(6) is Euclidean ({gamma_i, gamma_j} = 2 delta_ij), matching Paper 7 chirality.tex. Cl(d-1,1) is Lorentzian, matching Plan 01.
4. DIMENSION CHECK: 16 = 8 + 8 = dim(4,2,1) + dim(4bar,1,2). Correct.

---

## 2. Recap: Plan 01's Chirality-Time Theorem

Plan 01 (derivations/24-chirality-time-theorem.md) established:

**Chirality-Time Theorem (CHIR-01).** On an even-dimensional Lorentzian manifold (M, g) of signature (d-1, 1):

$$\Gamma_* = i^k \Gamma_0 \Gamma_1 \cdots \Gamma_{d-1}, \quad (\Gamma_*)^2 = +1$$

Under time-reversal T: Gamma_0 -> -Gamma_0, Gamma_i -> Gamma_i:

$$T(\Gamma_*) = -\Gamma_*$$

Therefore the Weyl projectors exchange: P_L <-> P_R.

**Consequence:** A globally consistent Weyl decomposition S(M) = S_L(M) + S_R(M) requires both time-orientation and space-orientation. Without time-orientation, Gamma_* is not globally defined with a consistent sign, and the L/R decomposition is ambiguous.

**Verified:** Explicitly in d = 2, 4, 10 and proved for all even d (Gamma_0 appears exactly once in the product).

**Reference:** Lawson-Michelsohn, *Spin Geometry* (1989), Appendix D; Ch. II, Sec. 1-2. [UNVERIFIED - training data: verifier should confirm]

---

## 3. The Internal/Spacetime Chirality Distinction

Before stating the three-consequence theorem, the critical distinction (established in Plan 01, Step 8):

**Internal Cl(6) chirality (omega_6):** Euclidean. Determines which SM *representation* each state carries. Purely algebraic -- no geometry needed. The decomposition 16 -> 8_L + 8_R is a representation-theoretic fact about Cl(6) acting on S_{10}^+.

**Spacetime chirality (Gamma_5 or Gamma_*):** Lorentzian. Determines which *Lorentz representation* each fermion has: left-handed = (1/2, 0) under SL(2,C), right-handed = (0, 1/2). Requires time-orientation via the Gamma_0 factor.

**Physical chirality of the SM:** Requires BOTH chiralities to be defined and CORRELATED. A fermion that is "left-handed" in the SM is simultaneously:
- In the (4,2,1) representation under Pati-Salam (from internal omega_6), AND
- A left-handed Weyl spinor under SO(3,1) (from spacetime Gamma_5).

The internal chirality from omega_6 labels states; the spacetime chirality from Gamma_5 determines their propagation and coupling. The full chiral SM requires both, and the spacetime part requires time-orientation.

### SELF-CRITIQUE CHECKPOINT (Step 3):
1. SIGN CHECK: N/A (conceptual distinction, no signs to track).
2. FACTOR CHECK: N/A.
3. CONVENTION CHECK: Internal Cl(6) Euclidean. Spacetime Cl(3,1) Lorentzian with (+,-,-,-). Consistent with both Paper 7 and Plan 01.
4. DIMENSION CHECK: All quantities dimensionless. Correct.

---

## 4. The Third Consequence: Time-Orientation Requirement

The logical chain for consequence (c):

**Step 4.1:** u in S^6 defines W = u^perp cap Im(O), giving 6 generators of Cl(6).

**Step 4.2:** The Cl(6) volume form omega_6 = gamma_1...gamma_6 decomposes S_{10}^+ into chiral halves: S^+ (left-handed, (4,2,1)) and S^- (right-handed, (4bar,1,2)).

**Step 4.3:** For this algebraic chirality to be *physically realized* as the chiral Standard Model -- where left-handed fermions are spacetime-left-handed Weyl spinors and right-handed fermions are spacetime-right-handed Weyl spinors -- the spacetime must admit a Weyl decomposition.

**Step 4.4:** The spacetime Weyl decomposition requires the chirality operator Gamma_* (or Gamma_5 in d=4). This operator contains Gamma_0, which requires a globally chosen time-orientation. (Chirality-Time Theorem, Plan 01.)

**Step 4.5:** Therefore: if u's internal chirality is to be physically meaningful (i.e., correlated with spacetime handedness), the emergent spacetime MUST be time-oriented.

**What consequence (c) says:** u creates a REQUIREMENT for time-orientation. It does not SELECT a particular time-orientation (e.g., it does not pick a future-pointing vector). The specific time-orientation comes from the dynamics (Hamiltonian evolution in Paper 6), not from u.

**Addressing Forbidden Proxy fp-time-from-nowhere:** We are careful: u REQUIRES time-orientation to exist, but u does not PROVIDE it. The claim is constraint-level, not constructive.

---

## 5. Non-Circularity Check

The argument must not be circular. Let us verify the logical flow:

1. **u is chosen** (algebraic input, Gap B2). No geometry assumed.
2. **u defines W = u^perp** (pure algebra on Im(O)).
3. **W gives Cl(6) generators** (pure algebra: gamma_1,...,gamma_6 satisfy {gamma_i, gamma_j} = 2 delta_ij).
4. **omega_6 = gamma_1...gamma_6 defines L/R decomposition** (pure representation theory: eigenspaces of i*omega_6 on S_{10}^+).
5. **Physical realization of L/R as spacetime-handed fermions requires Weyl spinors on spacetime** (physical requirement: the SM is a chiral gauge theory with spacetime Weyl fermions).
6. **Weyl spinors on spacetime require time-orientation** (spin geometry: Gamma_* involves Gamma_0, which requires time-orientation for a consistent global sign; Lawson-Michelsohn).

**At no point do we assume time-orientation.** Steps 1-4 are pure algebra. Step 5 is a physical identification (the SM IS a chiral theory on spacetime). Step 6 is a geometric theorem. The conclusion is: IF the algebraic chirality from u is to be physically realized, THEN the spacetime must be time-oriented.

**Direction of implication:** algebra (u) -> representation theory (chirality) -> geometry (time-orientation required). Not the reverse.

### SELF-CRITIQUE CHECKPOINT (Step 5):
1. SIGN CHECK: The critical sign: Gamma_* -> -Gamma_* under time reversal (one sign flip from Gamma_0). Verified in Plan 01 for d = 2, 4, 10 and general d.
2. FACTOR CHECK: No factors of 2, pi, hbar, c in the logical argument.
3. CONVENTION CHECK: All conventions maintained from Plan 01 and Paper 7. No new conventions introduced.
4. DIMENSION CHECK: All quantities dimensionless. The argument is about existence of structures (orientations, spin structures), not about numerical values.

---

## 6. Connection to Paper 6: The Emergent Spacetime Satisfies the Requirement

Plan 01, Task 2 (derivations/24-lattice-framing-spin.md) established:

**Proposition (VALD-01).** Paper 6's self-modeling lattice, in the continuum limit (L >> a), produces an emergent manifold (M, g) that is:

(i) **Framed** (from lattice basis vectors), hence w_1(TM) = w_2(TM) = 0.
(ii) **Spin** (from framing, since framing => spin), admitting spinor bundles S(M).
(iii) **Time-oriented** (from Hamiltonian time evolution exp(-iHt) with t > 0 defining the future).
(iv) **Space-oriented** (from the lattice orientation).

This means: Paper 6's emergent spacetime SATISFIES the requirement imposed by consequence (c). The chirality from Paper 7's u CAN be physically realized on Paper 6's spacetime.

**New structural connection between Papers 6 and 7:**
- Paper 7 (chirality from u) REQUIRES time-orientation [consequence (c)].
- Paper 6 (SWAP lattice -> emergent spacetime) PROVIDES time-orientation [from Hamiltonian evolution].
- This connection was implicit but never stated explicitly in either paper.

**Caveat:** This depends on the continuum limit existing as a smooth Lorentzian manifold (Paper 6, Gap 1). The statement is: IF the continuum limit exists, THEN the emergent spacetime satisfies the time-orientation requirement.

**Addressing Forbidden Proxy fp-three-consequence-restatement:** We have explicitly verified (Plan 01, Task 2) that Paper 6's lattice provides a framing, hence a spin structure, hence the emergent spacetime CAN carry the required Weyl spinor bundles. The three-consequence theorem is not vacuously true -- it is true because Paper 6's structure is rich enough to support it.

---

## 7. Three-Consequence Theorem: Precise Statement

**THEOREM (Three consequences of u).** Let h_3(O) be the exceptional Jordan algebra. Assume:

- **(A1)** h_3(O) is identified as the universe algebra via non-composability (Gap A).
- **(A2)** An observer selects a rank-1 idempotent E_{11}, breaking F_4 -> Spin(9) (Gap B1).
- **(A3)** A complex structure u in S^6 subset Im(O) is chosen (Gap B2).
- **(A4)** The complexification principle holds: V_{1/2} tensor_R C = S_{10}^+ (Gap C).
- **(A5)** Paper 6's continuum limit exists as a smooth manifold (Paper 6, Gap 1).
- **(A6)** The emergent spacetime has Lorentzian signature (from Paper 6's causal structure via Lieb-Robinson bounds).

Then the single choice of u simultaneously determines:

**(a) GAUGE GROUP** (constructive): The F_4 intersection with the u-preserving subgroup gives the SM gauge group SU(3)_C x SU(2) x U(1), dim = 12. [Paper 7, Theorem 4.1]

**(b) CHIRALITY** (constructive): The same u defines Cl(6) subset Cl(10), whose volume form omega_6 selects the LEFT chiral embedding: 16 -> (4,2,1) + (4bar,1,2) under Pati-Salam. [Paper 7, Theorem 4.2]

**(c) TIME-ORIENTATION REQUIREMENT** (constraint): The chirality defined by omega_6 can only be physically realized -- i.e., correlated with spacetime handedness to give the observed chiral fermion spectrum -- on a time-oriented Lorentzian manifold. Therefore u creates a necessity for time-orientation on the emergent spacetime. [Chirality-Time Theorem, Plan 01; Lawson-Michelsohn 1989]

Moreover, this requirement is SATISFIED: under assumptions A5-A6, Paper 6's emergent spacetime provides time-orientation (from Hamiltonian evolution) and spin structure (from lattice framing), so the chirality from (b) can be physically realized.

**Proof:**

- (a) follows from Paper 7, Theorem 4.1 (single input theorem, route A), proved in synthesis.tex Sec. 4.1-4.3.
- (b) follows from Paper 7, Theorem 4.2 (one choice, two consequences), proved in chirality.tex Sec. 3 and synthesis.tex Sec. 4.4.
- (c) follows from the chain:
  1. u defines omega_6 (Step 4.1-4.2 above, Paper 7 Sec. 3.2).
  2. omega_6 decomposes 16 -> 8_L + 8_R (Paper 7, Prop. 3.1).
  3. Physical realization of this L/R decomposition as spacetime Weyl spinors requires the spacetime chirality operator Gamma_* (physical requirement for the SM as a chiral gauge theory).
  4. Gamma_* requires time-orientation (Chirality-Time Theorem, Plan 01; Lawson-Michelsohn, *Spin Geometry*, 1989, Appendix D and Ch. II Sec. 1-2 [UNVERIFIED - training data]).
  5. Therefore u creates a requirement for time-orientation. QED for (c).

- The satisfaction claim follows from Plan 01, Task 2 (VALD-01): Paper 6's lattice provides framing -> spin structure -> orientability, and Hamiltonian evolution provides time-orientation, under assumptions A5-A6.

**Nature of the three consequences:**

| Consequence | Type | What u does | Logical status |
|---|---|---|---|
| (a) Gauge group | Constructive | u builds SU(3)_C x SU(2) x U(1) via explicit algebraic procedure | Proved in Paper 7 |
| (b) Chirality | Constructive | u builds L/R decomposition via omega_6 | Proved in Paper 7 |
| (c) Time-orientation | Constraint | u's chirality (b) imposes a requirement on spacetime geometry | Proved here (from Plan 01 + Paper 7) |

Consequence (c) is logically downstream of (b): it is a geometric implication of the algebraic chirality. The theorem is honestly characterized as "two constructions and one constraint."

---

## 8. Updated Chain Analysis

Paper 7's 9-link chain (Table 1, introduction.tex) is:

| Link | Statement | Status |
|---|---|---|
| L1 | Self-modeling forces M_n(C)^sa | Proved (Paper 5) |
| L2 | Non-composability identifies h_3(O) | Gap A (argued) |
| L3 | Observer selects E_{11}; Peirce decomposition; Stab = Spin(9) | Gap B1 (input) |
| L4 | C*-observer motivates complexification; Spin(9) -> Spin(10) | Argued (Gap C) |
| L5 | Complexification: F_4 -> E_6, 27 -> 1 + 10 + 16 | Proved (given L4) |
| L6 | Observer selects u in S^6; O = C + C^3 | Gap B2 (input) |
| L7 | u defines Cl(6); omega_6 selects LEFT embedding | Proved |
| L8 | Same u breaks F_4; intersection gives SM gauge group | Proved |
| L9 | Cl(6) route gives same gauge group PLUS chirality | Proved |

**New annotation on L7:** The internal chirality defined by omega_6 (L7) is purely algebraic and does not require any spacetime geometry. However, the *physical realization* of this chirality -- correlating the internal L/R labels with spacetime Weyl spinor handedness -- requires the emergent spacetime to be time-oriented. This is the content of consequence (c) of the three-consequence theorem.

**New cross-paper dependency:** L7 now depends not only on L6 (choice of u) but also on Paper 6's emergent spacetime being time-oriented, for the chirality to be physically meaningful. This is a logical dependency, not a modification of L7's proof: L7 is proved as pure algebra, and the time-orientation requirement is an additional consequence of interpreting L7 physically.

**Updated chain table with annotation:**

| Link | Statement | Status | New annotation (Phase 24) |
|---|---|---|---|
| L1 | Self-modeling forces M_n(C)^sa | Proved (Paper 5) | -- |
| L2 | Non-composability identifies h_3(O) | Gap A (argued) | -- |
| L3 | Observer selects E_{11}; Stab = Spin(9) | Gap B1 (input) | -- |
| L4 | C*-observer complexification; Spin(9) -> Spin(10) | Argued (Gap C) | -- |
| L5 | F_4 -> E_6, 27 -> 1 + 10 + 16 | Proved (given L4) | -- |
| L6 | Observer selects u in S^6; O = C + C^3 | Gap B2 (input) | -- |
| L7 | u defines Cl(6); omega_6 selects LEFT embedding | **Proved** | **Physical realization requires time-orientation (Three-Consequence Thm, consequence (c)). Satisfied by Paper 6's emergent spacetime (VALD-01, Plan 01 Task 2).** |
| L8 | Same u breaks F_4; intersection gives SM gauge group | Proved | -- |
| L9 | Cl(6) route gives same gauge group PLUS chirality | Proved | -- |

**Nature of the update:** No existing link is modified or removed. L7's proof remains unchanged (it is pure algebra). The annotation adds a *downstream implication* of L7: the physical content of the chirality requires time-orientation. This is a new cross-paper dependency (Paper 7 L7 -> Paper 6 spacetime structure) that was not identified in Paper 7.

---

## 9. Complete Assumption Register

The three-consequence theorem requires all six assumptions:

| Assumption | Source | Nature | Needed for |
|---|---|---|---|
| A1. h_3(O) is universe algebra | Gap A (JvNW + BGW + L4 realism) | Foundational premise | All of (a), (b), (c) |
| A2. Observer selects E_{11} | Gap B1 (symmetry-breaking input) | Input | All of (a), (b), (c) |
| A3. Observer selects u in S^6 | Gap B2 (symmetry-breaking input) | Input | All of (a), (b), (c) |
| A4. Complexification V_{1/2} -> S_{10}^+ | Gap C (argued, not proved) | Conjecture | (a) via Spin(10), (b) via Cl(10) |
| A5. Continuum limit exists | Paper 6, Gap 1 | Assumption | (c) satisfaction |
| A6. Emergent spacetime is Lorentzian | Paper 6 causal structure | Physical | (c) requirement and satisfaction |

**Assumptions A1-A4** are inherited from Paper 7. They were already required for consequences (a) and (b).

**Assumptions A5-A6** are NEW to the three-consequence theorem. They are needed for:
- The time-orientation *requirement* (c): the Chirality-Time Theorem applies to Lorentzian manifolds (A6).
- The time-orientation *satisfaction*: Paper 6's emergent spacetime must exist (A5) with Lorentzian signature (A6).

**If A5 or A6 fail:** Consequences (a) and (b) are unaffected (they are pure algebra within h_3(O)). Consequence (c) would not apply -- the three-consequence theorem would reduce to the two-consequence theorem of Paper 7. The connection between chirality and time-orientation would be severed.

---

## 10. Connection to Phase 26 (Forward Reference)

The three-consequence theorem matters for Phase 26 (entropy gradient theorem) because:

1. **Phase 26 will argue:** Self-modelers require an entropy gradient (arrow of time) to sustain the tracking update that defines self-modeling.

2. **The arrow of time requires time-orientation:** You need a "future" direction to define increasing entropy. Time-orientation is a geometric prerequisite for the arrow of time.

3. **Consequence (c) shows:** Chirality (from u) ALSO requires time-orientation. This is established here in Phase 24.

4. **The shared prerequisite:** Chirality and the arrow of time share a common geometric prerequisite: time-orientation. Both are consequences of the self-modeling framework's need for structured spacetime.

5. **The emerging picture:** The single choice u constrains the geometry (time-orientation) in a way that is COMPATIBLE with the thermodynamic requirements (entropy gradient) of self-modelers. This suggests that the particle physics content (chirality) and the thermodynamic content (arrow of time) are not independent -- they are linked through the geometric requirement of time-orientation.

**This is stated as a forward reference, not an overclaim.** Phase 24 establishes the geometric prerequisite (time-orientation needed for chirality). Phase 26 will develop the thermodynamic argument (time-orientation needed for entropy gradient). The full connection is Phase 26's responsibility.

---

## Verification Summary

| Check | Result | Status |
|---|---|---|
| Paper 7 Thm 4.2 correctly summarized | Two consequences: gauge group + chirality, both from u | PASS |
| Plan 01 Chirality-Time Theorem correctly used | Gamma_* -> -Gamma_* under time reversal; P_L <-> P_R | PASS |
| Internal/spacetime chirality distinction | omega_6 (Euclidean) vs Gamma_5 (Lorentzian); both needed for SM | PASS |
| Non-circularity | Argument flows algebra -> geometry, never assumes time-orientation | PASS |
| Non-triviality (consequence (c) is new) | Paper 7 never mentions time-orientation; (c) is genuinely new | PASS |
| Chain consistency | L7 annotation added; no links modified or removed | PASS |
| Assumption completeness | A1-A6 all listed; A1-A4 inherited, A5-A6 new | PASS |
| Paper 6 compatibility | Lattice provides framing => spin => orientability + time-orientation (VALD-01) | PASS |
| Phase 26 forward reference | Stated as connection, not overclaim | PASS |
| Forbidden proxy fp-three-consequence-restatement | Checked Paper 6 spin structure explicitly | PASS |
| Forbidden proxy fp-time-from-nowhere | u REQUIRES time-orientation, does not PROVIDE it | PASS |
| Distinction: constructive vs constraint | (a) and (b) constructive, (c) constraint -- honestly stated | PASS |
| Dimensional consistency | All quantities dimensionless throughout | PASS |

**Confidence:** [CONFIDENCE: HIGH] -- Result assembles two independently verified components (Paper 7's Theorem 4.2 and Plan 01's Chirality-Time Theorem) with a clean logical chain. Non-circularity verified step-by-step. Non-triviality confirmed by inspection of Paper 7 (no mention of time-orientation). Three independent checks: (1) logical chain validity, (2) consistency with Paper 7's existing chain, (3) consistency with Plan 01's chirality-time theorem.
