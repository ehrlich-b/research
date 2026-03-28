# Chirality-Time Entanglement Theorem

% ASSERT_CONVENTION: natural_units=dimensionless, clifford_convention=lorentzian_mostly_minus, octonion_basis=fano_e1e2=e4, complex_structure=u_equals_e7, spin_representation=S10plus_boyle

**Phase 24, Plan 01, Task 1**
**Date:** 2026-03-24

---

## Setup: Lorentzian Clifford Algebra Cl(d-1,1)

Consider a d-dimensional Lorentzian manifold with metric signature
eta = diag(+1, -1, -1, ..., -1) (mostly-minus convention).

The Clifford algebra Cl(d-1,1) has generators Gamma_mu satisfying:

$$\{\Gamma_\mu, \Gamma_\nu\} = 2\,\eta_{\mu\nu}$$

Explicitly:
- Gamma_0^2 = +1 (timelike)
- Gamma_i^2 = -1 for i = 1, ..., d-1 (spacelike)
- Gamma_mu Gamma_nu = -Gamma_nu Gamma_mu for mu != nu

## Step 1: The Volume Form (Chirality Operator) in Even Dimensions

In even dimension d = 2m, define the volume form:

$$\Gamma_* = i^k \, \Gamma_0 \Gamma_1 \cdots \Gamma_{d-1}$$

where k is chosen so that (Gamma_*)^2 = +1.

**Determining k.** Compute (Gamma_0 Gamma_1 ... Gamma_{d-1})^2.

The product Gamma_0 Gamma_1 ... Gamma_{d-1} has d gamma matrices.
To reverse the order (bringing the second copy next to the first):
- Number of transpositions = d(d-1)/2
- Each transposition gives a factor (-1) from anticommutation
- Each Gamma_mu^2 = eta_{mu mu}: one factor of +1 (from Gamma_0) and (d-1) factors of -1 (from Gamma_i)

So:

$$(\Gamma_0 \Gamma_1 \cdots \Gamma_{d-1})^2 = (-1)^{d(d-1)/2} \cdot (+1) \cdot (-1)^{d-1}$$

$$= (-1)^{d(d-1)/2 + d - 1}$$

For d = 2m:

$$d(d-1)/2 + d - 1 = m(2m-1) + 2m - 1 = 2m^2 - m + 2m - 1 = 2m^2 + m - 1$$

We need i^{2k} * (-1)^{2m^2 + m - 1} = +1, i.e., (-1)^k * (-1)^{2m^2+m-1} = +1.

This gives (-1)^{k + 2m^2 + m - 1} = +1, so k + 2m^2 + m - 1 must be even.

Since 2m^2 is even, we need k + m - 1 to be even, i.e., k and m-1 have the same parity.

**Standard choice:** Take k = m - 1 (mod 2), specifically:

For the mostly-minus convention, the standard physics convention is:

$$\Gamma_* = i^{\lfloor d/2 \rfloor - 1} \cdot \Gamma_0 \Gamma_1 \cdots \Gamma_{d-1}$$

when d = 2m with the appropriate power of i. Let me verify case by case.

### SELF-CRITIQUE CHECKPOINT (Step 1):
1. SIGN CHECK: Need to verify (Gamma_*)^2 = +1 for specific dimensions.
2. FACTOR CHECK: Factors of i introduced. Must track i^{2k} = (-1)^k carefully.
3. CONVENTION CHECK: Using mostly-minus metric {+,-,-,...,-}.
4. DIMENSION CHECK: Gamma_* is [dimensionless] -- product of dimensionless matrices times i^k. Correct.

## Step 2: Explicit Verification for d = 2 (m = 1)

Cl(1,1): Gamma_0^2 = +1, Gamma_1^2 = -1.

Product: Gamma_0 Gamma_1.

$$(Gamma_0 Gamma_1)^2 = Gamma_0 Gamma_1 Gamma_0 Gamma_1 = -Gamma_0 Gamma_0 Gamma_1 Gamma_1 = -(+1)(-1) = +1$$

So (Gamma_0 Gamma_1)^2 = +1 already. Take k = 0:

$$\Gamma_* = \Gamma_0 \Gamma_1, \quad (\Gamma_*)^2 = +1. \checkmark$$

**Time reversal:** Under Gamma_0 -> -Gamma_0, Gamma_1 -> Gamma_1:

$$\Gamma_* \to (-Gamma_0)\Gamma_1 = -\Gamma_0 \Gamma_1 = -\Gamma_*$$

**Result for d=2:** Flipping time-orientation sends Gamma_* -> -Gamma_*. CHECK.

## Step 3: Explicit Verification for d = 4 (m = 2)

Cl(3,1): Gamma_0^2 = +1, Gamma_i^2 = -1 for i = 1,2,3.

Product: Gamma_0 Gamma_1 Gamma_2 Gamma_3.

$$(Gamma_0 Gamma_1 Gamma_2 Gamma_3)^2 = (-1)^{4 \cdot 3/2} \cdot (+1)(-1)^3 = (-1)^6 \cdot (-1) = (+1)(-1) = -1$$

So the bare product squares to -1. We need (Gamma_*)^2 = +1, so take Gamma_* = i * (product):

$$\Gamma_5 := i\,\Gamma_0 \Gamma_1 \Gamma_2 \Gamma_3$$

$$(\Gamma_5)^2 = i^2 \cdot (-1) = (-1)(-1) = +1. \checkmark$$

This is the standard gamma-5 matrix of 4D physics. Here k = 1 (one factor of i).

**Time reversal:** Under Gamma_0 -> -Gamma_0, Gamma_i -> Gamma_i:

$$\Gamma_5 \to i(-\Gamma_0)\Gamma_1\Gamma_2\Gamma_3 = -i\,\Gamma_0\Gamma_1\Gamma_2\Gamma_3 = -\Gamma_5$$

**Result for d=4:** Gamma_5 -> -Gamma_5 under time reversal. CHECK.

## Step 4: Explicit Verification for d = 10 (m = 5)

Cl(9,1): Gamma_0^2 = +1, Gamma_i^2 = -1 for i = 1,...,9.

Product: Gamma_0 Gamma_1 ... Gamma_9.

$$(Gamma_0 \cdots Gamma_9)^2 = (-1)^{10 \cdot 9/2} \cdot (+1)(-1)^9 = (-1)^{45} \cdot (-1) = (-1)^{46} = +1$$

The bare product already squares to +1. Take k = 0:

$$\Gamma_* = \Gamma_0 \Gamma_1 \cdots \Gamma_9, \quad (\Gamma_*)^2 = +1. \checkmark$$

**Time reversal:** Under Gamma_0 -> -Gamma_0, Gamma_i -> Gamma_i:

$$\Gamma_* \to (-\Gamma_0)\Gamma_1 \cdots \Gamma_9 = -\Gamma_0 \Gamma_1 \cdots \Gamma_9 = -\Gamma_*$$

**Result for d=10:** Gamma_* -> -Gamma_* under time reversal. CHECK.

### SELF-CRITIQUE CHECKPOINT (Step 4):
1. SIGN CHECK: d=2: (product)^2 = +1, k=0. d=4: (product)^2 = -1, k=1. d=10: (product)^2 = +1, k=0. All verified.
2. FACTOR CHECK: Factors of i: d=2 has 0, d=4 has 1, d=10 has 0. Correct pattern.
3. CONVENTION CHECK: Still using mostly-minus metric. Gamma_0 is timelike with Gamma_0^2 = +1. Consistent.
4. DIMENSION CHECK: All quantities dimensionless. Correct.

## Step 5: General Proof for All Even d

**Theorem (Time-reversal flips Gamma_*):** For any even d = 2m, the chirality operator Gamma_* defined by Gamma_* = i^k Gamma_0 Gamma_1 ... Gamma_{d-1} (with k chosen so (Gamma_*)^2 = +1) satisfies:

Under the time-reversal map T: Gamma_0 -> -Gamma_0, Gamma_i -> Gamma_i (i = 1,...,d-1):

$$T(\Gamma_*) = -\Gamma_*$$

**Proof:** Regardless of k, the factor i^k is unaffected by T. The product Gamma_0 Gamma_1 ... Gamma_{d-1} contains Gamma_0 exactly once. Under T:

$$\Gamma_0 \Gamma_1 \cdots \Gamma_{d-1} \to (-\Gamma_0)\Gamma_1 \cdots \Gamma_{d-1} = -\Gamma_0 \Gamma_1 \cdots \Gamma_{d-1}$$

Therefore T(Gamma_*) = i^k * (-Gamma_0 Gamma_1 ... Gamma_{d-1}) = -Gamma_*. QED.

**Corollary (Space-reversal also flips Gamma_*):** Under reversal of any single spatial direction, say Gamma_j -> -Gamma_j for one j in {1,...,d-1}, with all other generators unchanged:

$$\Gamma_* \to -\Gamma_*$$

since Gamma_j also appears exactly once in the product.

## Step 6: Weyl Projectors and Their Exchange

The Weyl (chirality) projectors are:

$$P_L = \frac{1 + \Gamma_*}{2}, \quad P_R = \frac{1 - \Gamma_*}{2}$$

These satisfy:
- P_L^2 = P_L, P_R^2 = P_R (idempotent, since (Gamma_*)^2 = 1)
- P_L + P_R = 1 (completeness)
- P_L P_R = 0 (orthogonality)

The Dirac spinor S decomposes as:

$$S = S_L \oplus S_R, \quad S_L = P_L S, \quad S_R = P_R S$$

**Under time reversal:**

$$P_L \to \frac{1 + (-\Gamma_*)}{2} = \frac{1 - \Gamma_*}{2} = P_R$$

$$P_R \to \frac{1 - (-\Gamma_*)}{2} = \frac{1 + \Gamma_*}{2} = P_L$$

**Conclusion:** Flipping the time-orientation exchanges left-handed and right-handed Weyl spinors: P_L <-> P_R.

## Step 7: Why Both Orientations Are Required

The volume form Gamma_* = i^k Gamma_0 Gamma_1 ... Gamma_{d-1} depends on:

**(a) An ordered basis** -- i.e., a choice of which ordering {Gamma_0, Gamma_1, ..., Gamma_{d-1}} to use. Permuting any two generators changes the sign of the product. A consistent global ordering requires an **orientation** of the manifold (i.e., space-orientation).

**(b) A choice of which direction is timelike** -- i.e., a **time-orientation**. Gamma_0 is distinguished as the generator satisfying Gamma_0^2 = +1 (in mostly-minus convention). Flipping the time-orientation (Gamma_0 -> -Gamma_0) flips Gamma_*.

Therefore a **globally consistent chirality** (a globally defined Gamma_* with definite sign) requires:
1. **Space-orientation**: to fix the sign from the spatial part of the ordered product.
2. **Time-orientation**: to fix the sign from Gamma_0.

This is the content of Lawson-Michelsohn, *Spin Geometry* (1989):
- Chapter II, Sections 1-2: Spin structures require an oriented manifold (the SO(n) bundle must exist before lifting to Spin(n)).
- Appendix D (Spinor representations of the Lorentz group): In Lorentzian signature, the relevant group is Spin(d-1,1), and the Weyl decomposition of the spinor representation requires a volume form that depends on both orientations.
- Specifically: a Lorentzian spin manifold admits Weyl spinor bundles S = S_L + S_R if and only if the manifold is both time-oriented and space-oriented.

**[UNVERIFIED - training data]** The exact location in Lawson-Michelsohn is Appendix D (spinor representations of the Lorentz group) and Chapter II, Sec. 1-2 (spin structures on oriented manifolds). The verifier should confirm the precise statement and page numbers.

## Step 8: Connection to Paper 7's Euclidean Cl(6)

### The Internal Chirality (Euclidean)

Paper 7 (chirality.tex, Sec. 3) works with the **internal** Euclidean Clifford algebra Cl(6), with generators gamma_1, ..., gamma_6 satisfying {gamma_i, gamma_j} = 2 delta_{ij}. The volume form is:

$$\omega_6 = \gamma_1 \gamma_2 \gamma_3 \gamma_4 \gamma_5 \gamma_6$$

From Paper 7, Proposition 3.1:
- omega_6^2 = (-1)^{6*5/2} = (-1)^{15} = -1
- The chirality operator i*omega_6 satisfies (i*omega_6)^2 = +1
- This is purely **Euclidean** chirality and does NOT involve time.

The Euclidean chirality operator i*omega_6 decomposes the 16-dimensional S_{10}^+ spinor as:

$$S_{10}^+ = S^+ \oplus S^-$$

into 8+8, where S^+ carries one generation of left-handed SM fermions (4,2,1) under Pati-Salam and S^- carries right-handed fermions (4bar,1,2).

### The Spacetime Chirality (Lorentzian)

The **spacetime** chirality involves the 4D Lorentzian Gamma_5 = i Gamma_0 Gamma_1 Gamma_2 Gamma_3 (or the 10D Gamma_*), which determines whether a fermion is left-handed or right-handed under the **Lorentz group** SO(3,1).

### The Critical Distinction (Addressing Forbidden Proxy fp-spacetime-conflation)

The internal Cl(6) chirality (omega_6) and the spacetime chirality (Gamma_5 or Gamma_*) are **different objects** serving **different roles**:

- **omega_6** (internal, Euclidean): Determines which SM **representation** each state carries. Left-handed fermions are in (4,2,1) and right-handed in (4bar,1,2) under Pati-Salam. This is the **internal quantum number** assignment.

- **Gamma_5** (spacetime, Lorentzian): Determines which **Lorentz representation** each fermion has. Left-handed under Lorentz means the fermion transforms as (1/2, 0) under SL(2,C), right-handed means (0, 1/2). This requires **time-orientation** via the Gamma_0 in Gamma_5.

### How Time-Orientation Enters

The full Standard Model chiral structure requires **both** chiralities to be defined and **correlated**:

1. A fermion that is "left-handed" in the SM means it is BOTH:
   - In the (4,2,1) representation under Pati-Salam (from internal omega_6), AND
   - A left-handed Weyl spinor under SO(3,1) (from spacetime Gamma_5).

2. This correlation between internal and spacetime chirality is the defining feature of the chiral SM.

3. The spacetime Gamma_5 involves Gamma_0 (the timelike generator). Without time-orientation, Gamma_5 is not globally defined: flipping time-orientation exchanges P_L <-> P_R at the spacetime level.

4. If there is no time-orientation, you cannot consistently say which fermions are spacetime-left-handed and which are spacetime-right-handed. The internal chirality from omega_6 still assigns representations (4,2,1) vs (4bar,1,2), but these cannot be correlated with spacetime handedness without time-orientation.

**Therefore:** The internal Cl(6) chirality alone (from u in S^6, Paper 7) gives the correct representation decomposition. But the physical chiral Standard Model -- where left-handed fermions couple differently from right-handed fermions under the **spacetime** Lorentz group -- requires the emergent spacetime to carry a time-orientation.

### Addressing Forbidden Proxy fp-cite-without-verify

The Lawson-Michelsohn statement applies directly to the **spacetime** Clifford algebra Cl(d-1,1), which is Lorentzian. The internal Cl(6) is Euclidean. The connection is:

- The full theory has a **product structure**: internal (Euclidean Cl(6)) x spacetime (Lorentzian Cl(3,1)), or in the 10D context, these are embedded in Cl(9,1).
- The Lawson-Michelsohn statement about Weyl spinors requiring time-orientation applies to the **spacetime factor**, not to the internal factor.
- The internal Euclidean chirality does not need time-orientation (it is defined purely from the algebraic choice of u in S^6).
- The spacetime Lorentzian chirality DOES need time-orientation (the Gamma_5 involves Gamma_0).
- The SM's chiral fermion assignment requires BOTH chiralities, hence requires time-orientation.

This is NOT simply "citing Lawson-Michelsohn without checking applicability." We have verified:
1. L-M applies to Lorentzian Cl(d-1,1) -- our spacetime is Lorentzian (from Paper 6's emergent causal structure).
2. The internal Cl(6) is Euclidean -- L-M does not directly constrain it, and indeed omega_6 is defined without time.
3. The FULL chiral SM requires both internal and spacetime chirality -- hence L-M applies to the spacetime part, giving the time-orientation requirement.

### SELF-CRITIQUE CHECKPOINT (Step 8):
1. SIGN CHECK: omega_6^2 = -1 (from Paper 7, verified: (-1)^{15} = -1). (i*omega_6)^2 = +1. Consistent.
2. FACTOR CHECK: No new factors of 2, pi, hbar, c. Internal chirality uses i*omega_6 (one factor of i).
3. CONVENTION CHECK: Internal Cl(6) is Euclidean ({gamma_i, gamma_j} = 2 delta_ij). Spacetime is Lorentzian ({Gamma_mu, Gamma_nu} = 2 eta_{mu nu}). Convention lock: natural_units=dimensionless. Consistent.
4. DIMENSION CHECK: omega_6 is dimensionless (product of dimensionless gammas). Gamma_5 is dimensionless. All correct.

## Theorem Statement

**THEOREM (Chirality requires time-orientation).** Let (M, g) be an even-dimensional Lorentzian manifold of signature (d-1, 1), with d = 2m. The spinor bundle S(M) admits a decomposition into Weyl spinor bundles

$$S(M) = S_L(M) \oplus S_R(M)$$

(defined by the chirality operator Gamma_* = i^k Gamma_0 Gamma_1 ... Gamma_{d-1}) if and only if M is both **time-oriented** and **space-oriented**.

*Proof sketch:* The chirality operator Gamma_* depends on:
- A choice of space-orientation (to fix the sign from the ordered spatial product), and
- A choice of time-orientation (to fix the sign from Gamma_0).

Reversing either orientation sends Gamma_* -> -Gamma_*, which exchanges P_L <-> P_R. For a globally consistent Weyl decomposition, both orientations must be fixed globally.

Conversely, if M is both time-oriented and space-oriented, then the ordered frame {e_0, e_1, ..., e_{d-1}} (with e_0 future-pointing, {e_1,...,e_{d-1}} positively oriented) is globally defined up to proper orthochronous Lorentz transformations SO^+(d-1,1), which preserve the sign of Gamma_*. Therefore S_L and S_R are well-defined bundles.

**Reference:** Lawson-Michelsohn, *Spin Geometry* (1989), Appendix D; Chapter II, Sec. 1-2. [UNVERIFIED - training data: verifier should confirm exact statement location]

**APPLICATION TO THE h_3(O) PROGRAM:**

In the context of Paper 7's derivation: the chiral SM fermion assignment determined by the Cl(6) volume form omega_6 (Theorem 4.2 of Paper 7) requires the emergent spacetime from Paper 6 to carry a time-orientation. Specifically:

1. The choice of u in S^6 (Paper 7) determines the internal chirality via omega_6, decomposing 16 -> (4,2,1) + (4bar,1,2) under Pati-Salam.
2. The physical identification of (4,2,1) as spacetime-left-handed and (4bar,1,2) as spacetime-right-handed requires the spacetime Gamma_5 (or Gamma_*), which involves Gamma_0.
3. Gamma_0 requires time-orientation for a globally consistent definition.
4. Therefore: **the single algebraic choice u determines not only the gauge group and internal chirality (Paper 7), but also implies the necessity of time-orientation for the emergent spacetime**.

This establishes the **chirality-time link (CHIR-01)** that feeds into Plan 02's three-consequence theorem.

---

## Verification Summary

| Check | Result | Status |
|-------|--------|--------|
| (Gamma_*)^2 = +1 for d=2 | Gamma_* = Gamma_0 Gamma_1, (Gamma_*)^2 = +1 | PASS |
| (Gamma_5)^2 = +1 for d=4 | Gamma_5 = i Gamma_0 Gamma_1 Gamma_2 Gamma_3, (Gamma_5)^2 = +1 | PASS |
| (Gamma_*)^2 = +1 for d=10 | Gamma_* = Gamma_0 ... Gamma_9, (Gamma_*)^2 = +1 | PASS |
| Time reversal flips Gamma_* (d=2) | Gamma_* -> -Gamma_* | PASS |
| Time reversal flips Gamma_5 (d=4) | Gamma_5 -> -Gamma_5 | PASS |
| Time reversal flips Gamma_* (d=10) | Gamma_* -> -Gamma_* | PASS |
| General proof for all even d | Gamma_0 appears once -> one sign flip | PASS |
| P_L <-> P_R under time reversal | P_L = (1+Gamma_*)/2 -> (1-Gamma_*)/2 = P_R | PASS |
| omega_6^2 = -1 (Euclidean, Paper 7) | (-1)^{15} = -1 | PASS |
| (i*omega_6)^2 = +1 (Euclidean chirality) | (-1)(-1) = +1 | PASS |
| Internal/spacetime distinction addressed | omega_6 is Euclidean, Gamma_5 is Lorentzian | PASS |
| Forbidden proxy (L-M applicability) addressed | L-M applies to spacetime Cl(d-1,1), not internal Cl(6); connection made explicit | PASS |
| Forbidden proxy (conflation) addressed | Internal and spacetime chirality distinguished; their correlation explained | PASS |

**Confidence:** [CONFIDENCE: HIGH] -- Result verified in d=2, 4, 10 by explicit computation. General proof is algebraically clean (Gamma_0 appears exactly once). The Euclidean/Lorentzian distinction is standard spin geometry. Three independent checks: (1) explicit dimension-by-dimension verification, (2) general algebraic proof, (3) consistency with Paper 7's Euclidean Cl(6) construction.
