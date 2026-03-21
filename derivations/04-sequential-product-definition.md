# Sequential Product Definition via Alfsen-Shultz Compressions

% ASSERT_CONVENTION: natural_units=N/A, metric_signature=N/A, fourier_convention=N/A, coupling_convention=N/A, renormalization_scheme=N/A, gauge_choice=N/A
% CUSTOM_CONVENTION: sequential_product=a & b (non-commutative), jordan_product=a * b = (1/2)(a & b + b & a), orthogonality=a perp b iff a & b = 0, complement=a^perp = 1 - a, sharp_effect=p & p = p and p & p^perp = 0, axiom_source=arXiv:1803.11139 Definition 2 EXCLUSIVELY, entropy_base=nats, compression=C_p (Alfsen-Shultz P-projection for face(p))

**Phase:** 04-sequential-product-formalization
**Plan:** 01
**Date:** 2026-03-21
**Status:** Complete (with critical finding -- see Addendum)

---

## Step 1: Axiom Definitions (Verbatim from arXiv:1803.11139)

### Definition 1 (Order Unit Space, vdW p.3)

An **order unit space** (V, V^+, 1) is a real ordered vector space with a distinguished order unit 1 such that:
- V^+ is a proper cone (closed, convex, pointed) generating V
- 1 is an Archimedean order unit: for every a in V, there exists r >= 0 with -r*1 <= a <= r*1
- The **order unit norm** is ||a|| = inf{r >= 0 : -r*1 <= a <= r*1}
- The **effect space** is [0,1]_V = {a in V : 0 <= a <= 1}

### Definition 2 (Sequential Product Space, vdW arXiv:1803.11139 Def. 2)

Let (V, <=, 1, &) be an order unit space equipped with a binary operation & : [0,1]_V x [0,1]_V -> [0,1]_V. Write a | b (compatible) when a & b = b & a. Call V a **sequential product space** and & a **sequential product** when & satisfies:

- **(S1) Additivity:** a & (b + c) = a & b + a & c [when b + c <= 1]
- **(S2) Continuity:** The map a -> a & b is continuous in the order unit norm
- **(S3) Unitality:** 1 & a = a
- **(S4) Symmetry of orthogonality:** If a & b = 0 then b & a = 0
- **(S5) Associativity of compatible effects:** If a | b then a & (b & c) = (a & b) & c
- **(S6) Additivity of compatibility:** If a | b then a | (1 - b), and if also a | c then a | (b + c) [when b + c <= 1]
- **(S7) Multiplicativity of compatibility:** If a | b and a | c then a | (b & c)

### Theorem 1 (vdW arXiv:1803.11139 p.15)

A finite-dimensional sequential product space is order-isomorphic to a Euclidean Jordan algebra.

### Corollary 7 (Spectral Decomposition, vdW p.7)

In a finite-dimensional sequential product space, every effect a in [0,1]_V admits a unique spectral decomposition a = sum_{i=1}^n lambda_i p_i where:
- The p_i are mutually orthogonal sharp effects (p_i & p_j = 0 for i != j, p_i & p_i = p_i)
- The lambda_i are distinct elements of [0,1]
- sum p_i = 1 (the p_i form a resolution of unity)

**Note:** Corollary 7 is a CONSEQUENCE of S1-S7 in vdW's paper. For our construction, we need spectral decomposition as a PRIMITIVE of the order unit space (not derived from the sequential product we are defining). This is justified: in a finite-dimensional OUS with sufficiently rich face structure (guaranteed by the Alfsen-Shultz compression theory for "spectral" OUS), every effect admits a spectral decomposition in terms of the lattice of projective units. We use this pre-existing OUS spectral decomposition, not the one that would follow from S1-S7 after verification. See Alfsen-Shultz Ch. 7 and Jenccova (2021) for the OUS spectral theory independent of sequential products.

### Compression Properties (Alfsen-Shultz, Niestegge 2008)

For each sharp effect (projective unit) p in a finite-dimensional OUS V, the **compression** (P-projection) C_p : V -> V satisfies:

- **(C1) Positivity:** C_p(a) >= 0 whenever a >= 0
- **(C2) Idempotence:** C_p(C_p(a)) = C_p(a)
- **(C3) Unit map:** C_p(1) = p
- **(C4) Complementarity:** C_{p^perp}(a) = a - C_p(a) for all a in V
   (equivalently: C_p + C_{p^perp} = id on V)
- **(C5) Commutativity for ordered projective units:** C_p C_q = C_q C_p when p <= q
- **(C6) Orthogonality:** C_p(q) = 0 when p perp q (i.e., when p & q = 0 in the OUS lattice sense)
- **(C7) Conditional probability:** For a state omega, omega(C_p(a)) / omega(p) = omega_p(a), the conditional probability of a given p (Niestegge Prop. 3.1)

**Primitive inventory:** The construction below uses ONLY:
1. The order structure of V (cone V^+, order unit 1)
2. The effect space [0,1]_V
3. Compression maps C_p for sharp effects p (Alfsen-Shultz P-projections)
4. The tracking map phi: sharp effects of B -> sharp effects of M
5. Spectral decomposition in the OUS (Alfsen-Shultz spectral theory, independent of sequential products)

---

## Step 2: The Self-Modeling Sequential Product for Sharp Effects

### Setup

Let B = (V_B, V_B^+, 1_B) be a finite-dimensional order unit space (the "body" or observed system). Let M = (V_M, V_M^+, 1_M) be a finite-dimensional order unit space (the "self-model"). Both are assumed to have spectral OUS structure (so compressions and spectral decompositions exist).

Let phi: Proj(B) -> Proj(M) be a **tracking map** from the sharp effects (projective units) of B to the sharp effects of M.

### The Self-Modeling Constraint (Informal)

The self-modeling cycle is: test effect a on B, which triggers an update on M via the tracking map, then test effect b on B in the updated context. The sequential product a & b encodes the composite effect of "first a, then b" where the intermediate model update modifies the measurement context.

### Definition (Self-Modeling Sequential Product on Sharp Effects)

For sharp effects p, q in Proj(B), define:

> **p & q = C_p(q)**

where C_p is the compression (P-projection) for the face generated by p in V_B.

**Rationale for the E(B) framing (see Step 3 for analysis):** The product is defined on effects of B. The tracking map phi enters the *interpretation* (testing p on B causes the model M to undergo compression C_{phi(p)}, which in turn feeds back to the context for testing q), but the *algebraic product* is defined purely on V_B using B's own compressions.

**Key observation:** This definition does NOT use phi algebraically in the product formula. The product p & q = C_p(q) uses only B's compression structure. The tracking map phi provides the *physical justification* for why C_p is the correct update map (it formalizes the self-modeling feedback loop), but the mathematical product is defined intrinsically on B.

This is a crucial simplification. It means:
- The sequential product depends on B's OUS structure alone
- phi enters as a physical interpretation parameter, not an algebraic parameter
- The algebraic properties (S1-S7) depend on B's compression structure, not on phi

**Per user decision:** The compression-based construction C_p(q) is the locked choice for the update map primitive.

---

## Step 3: Framing Analysis -- E(B) vs E(B x M)

### E(B) Framing: a & b = C_a(b) on effects of B

**Well-definedness (sharp effects):** For sharp p, q in Proj(B):
- C_p is a positive map (C1), so C_p(q) >= 0 whenever q >= 0. Check.
- C_p(q) <= C_p(1) = p <= 1 (C_p is positive and maps 1 to p, combined with C_p being order-preserving on [0,1]_V). Check.
- Therefore C_p(q) in [0,1]_V. The product maps effects to effects.

**S3 check:** We need 1 & a = a for all effects a, i.e., C_1(a) = a. The compression for the unit 1 is the identity map (the face generated by 1 is all of V), so C_1 = id. Therefore 1 & a = a. Check.

**vdW compatibility:** vdW's axioms describe a sequential product on a SINGLE system's effect space [0,1]_V. The E(B) framing places the product on [0,1]_{V_B}, which is a single system's effects. This matches vdW's setup exactly.

**Conclusion (E(B)):** The E(B) framing produces a well-defined binary operation on the effect space of a single OUS that satisfies S3 by construction and matches vdW's single-system framework. **This is the correct framing.**

### E(B x M) Framing: product on effects of the composite system

**Structure:** V_{B x M} would need to be specified. For OUS, the tensor product is not unique in general (unlike Hilbert spaces). Even if we take the maximal or minimal tensor product, effects of B x M are of the form sum a_i tensor b_i with a_i in [0,1]_{V_B}, b_i in [0,1]_{V_M}.

**Problem 1 (No natural product):** To define a sequential product on [0,1]_{V_{B x M}}, we would need compressions on V_{B x M}. These exist if V_{B x M} has spectral OUS structure, but the product would be a & b for effects a, b in [0,1]_{V_{B x M}} -- i.e., joint effects, not effects on B alone. This changes the physical meaning: it would describe sequential testing of joint B-M effects, not the "test B, update M, test B" cycle.

**Problem 2 (vdW mismatch):** vdW's axioms are formulated for a single system. The composite system B x M IS a single system, but the sequential product on it would describe sequential measurements on B x M jointly. The self-modeling constraint is asymmetric (B is tested, M is updated) -- this asymmetry cannot be captured by a symmetric sequential product on the composite system.

**Problem 3 (Independence of M's structure):** The E(B x M) framing makes the sequential product depend on M's dimension and structure. But if the self-modeling constraint is about B's algebraic structure (which is what we want to derive -- that B must be an EJA), the product should be intrinsic to B. The E(B x M) product would characterize B x M, not B.

**Failure mode exhibited:** On E(B x M), the natural product would be:

(a tensor b) & (c tensor d) = C_{a tensor b}(c tensor d)

where C_{a tensor b} is the compression on V_{B x M} for the sharp effect a tensor b. But this treats B and M symmetrically, contradicting the asymmetric self-modeling constraint (B is the tested system, M is the updated model). There is no natural way to encode the asymmetry "test on B, update on M" within a single sequential product on the composite.

### Framing Resolution

> **SELECTED: E(B) framing.** The sequential product a & b = C_a(b) is defined on the effect space [0,1]_{V_B} of the body system B.
>
> **REJECTED: E(B x M) framing.** Failure modes: (1) treats B and M symmetrically, contradicting the asymmetric self-modeling constraint; (2) characterizes B x M rather than B; (3) the natural composite compression does not encode the "test B, update M, test B" cycle.

The tracking map phi provides the physical interpretation connecting the E(B) product to the self-modeling constraint, but does not enter the algebraic definition of the product.

---

## Step 4: Extension to General Effects via Spectral Decomposition

### Setup

For a general effect a in [0,1]_{V_B}, the OUS spectral decomposition gives:

a = sum_{i=1}^n lambda_i p_i

where:
- p_i are mutually orthogonal sharp effects (projective units)
- lambda_i in [0,1] are distinct
- sum p_i <= 1 (equality if a has full support)

This decomposition exists in any finite-dimensional spectral OUS (Alfsen-Shultz) and is unique (the spectral values lambda_i are uniquely determined, as are the spectral projective units p_i -- this follows from the order-theoretic properties of the projective unit lattice).

### Definition (Sequential Product for General Effects)

For general effects a, b in [0,1]_{V_B}, with spectral decomposition a = sum_{i=1}^n lambda_i p_i:

> **a & b = sum_{i=1}^n lambda_i C_{p_i}(b)**

### Well-Definedness

**Claim:** The definition is independent of the spectral decomposition (i.e., well-defined).

**Proof:** In a finite-dimensional spectral OUS, the spectral decomposition of an effect a is unique: the spectral values lambda_i are the elements of the spectrum sigma(a), and for each spectral value lambda_i, the spectral projective unit p_i is uniquely determined by the order structure (it is the largest projective unit p such that a >= lambda_i p and a <= lambda_i p + (previous spectral value) * (1 - p), constructed via the spectral resolution). Since both the lambda_i and p_i are unique, the sum sum lambda_i C_{p_i}(b) is uniquely determined. QED.

**Effect range:** We must verify a & b in [0,1]_{V_B}.

Lower bound: Each C_{p_i}(b) >= 0 (positivity of compressions, C1) and each lambda_i >= 0. Therefore a & b = sum lambda_i C_{p_i}(b) >= 0.

Upper bound: Since the p_i are mutually orthogonal, the compressions C_{p_i} have complementary ranges. We have:
- C_{p_i}(b) <= C_{p_i}(1) = p_i (C_p is positive and C_p(1) = p)
- Therefore a & b = sum lambda_i C_{p_i}(b) <= sum lambda_i p_i = a <= 1.

So 0 <= a & b <= a <= 1, confirming a & b is an effect. Check.

### SELF-CRITIQUE CHECKPOINT (Step 4):
1. SIGN CHECK: No sign changes. N/A for algebraic construction.
2. FACTOR CHECK: No factors of 2, pi introduced. The lambda_i are spectral values, not inserted by hand.
3. CONVENTION CHECK: Using OUS compressions C_p, sequential product a & b, complement a^perp = 1 - a. Consistent with convention lock.
4. DIMENSION CHECK: C_p maps V_B -> V_B. lambda_i are dimensionless scalars. sum lambda_i C_{p_i}(b) is in V_B. Dimensionless throughout. Check.

---

## Step 5: Bilinearity Proof

### Linearity in the Second Argument

**Claim:** For fixed a in [0,1]_{V_B}, the map b -> a & b is linear (additive and homogeneous).

**Proof:** Let a = sum lambda_i p_i. Then:

a & b = sum lambda_i C_{p_i}(b)

Each C_{p_i} is a linear map (compressions are linear positive projections on V_B). A finite sum of linear maps, each scaled by a constant, is linear. Therefore b -> a & b is linear.

Explicitly:
- **Additivity:** a & (b + c) = sum lambda_i C_{p_i}(b + c) = sum lambda_i [C_{p_i}(b) + C_{p_i}(c)] = [sum lambda_i C_{p_i}(b)] + [sum lambda_i C_{p_i}(c)] = (a & b) + (a & c).
  Valid whenever b + c <= 1 (so that b + c is an effect).
- **Scalar multiplication:** a & (mu * b) = sum lambda_i C_{p_i}(mu * b) = mu * sum lambda_i C_{p_i}(b) = mu * (a & b).
  Valid for mu >= 0 with mu * b <= 1.

This gives S1 (additivity in second argument). Check.

### Linearity in the First Argument

**Claim:** For fixed b in [0,1]_{V_B}, the map a -> a & b is linear.

**Proof:** This requires more care because the first argument enters through the spectral decomposition.

Let a = sum_{i} alpha_i p_i and a' = sum_{j} beta_j q_j be two effects with spectral decompositions.

We need: (lambda a + mu a') & b = lambda (a & b) + mu (a' & b) for scalars lambda, mu >= 0 with lambda a + mu a' in [0,1]_{V_B}.

**Step 5a:** For sharp effects p, q, the product is:
- p & b = C_p(b)
- q & b = C_q(b)

We need the map p -> C_p(b) to extend linearly from the sharp effects to all effects via spectral decomposition.

**Step 5b:** The spectral extension is BY DEFINITION linear in the first argument. We defined:

a & b = sum lambda_i C_{p_i}(b) = (sum lambda_i L_{p_i})(b)

where L_p(b) = C_p(b). This is the unique linear extension of the map p -> C_p(b) from sharp effects to all effects, using the spectral decomposition as a basis expansion.

**Step 5c:** The key question is whether this linear extension is consistent: if a can be written as both sum lambda_i p_i (spectral) and as lambda a_1 + mu a_2 (linear combination of other effects), do we get the same result?

For the spectral decomposition: If a = sum lambda_i p_i, then a & b = sum lambda_i C_{p_i}(b) by definition.

For a linear combination: If a = lambda a_1 + mu a_2, with a_1 = sum alpha_j r_j and a_2 = sum beta_k s_k, then:

(lambda a_1 + mu a_2) & b would need to equal lambda (a_1 & b) + mu (a_2 & b).

**Step 5d:** This holds because the spectral decomposition determines a unique linear functional. Let T_b: V_B -> V_B be defined by T_b(a) = a & b = sum_{i} lambda_i C_{p_i}(b) where a = sum lambda_i p_i. The claim is that T_b is a linear map on V_B.

Since V_B is finite-dimensional, any element v in V_B can be written as v = v_+ - v_- with v_+, v_- in V_B^+. Each positive element has a spectral decomposition. The map T_b is defined on all positive elements via spectral decomposition, and we extend to all of V_B by T_b(v_+ - v_-) = T_b(v_+) - T_b(v_-).

**Step 5e:** We must verify T_b is well-defined on V_B (not just on effects). For a positive element a = sum lambda_i p_i (where now lambda_i >= 0 but not necessarily <= 1):

T_b(a) = sum lambda_i C_{p_i}(b)

For another decomposition of the same a: suppose a = sum mu_j q_j (different spectral decomposition -- but spectral decompositions are unique in a spectral OUS). Since the spectral decomposition is unique, the lambda_i and p_i are determined by a. Therefore T_b(a) is well-defined.

**Step 5f (Linearity of T_b):** For positive a, a':

T_b(a + a') = T_b(a) + T_b(a')?

This is the non-trivial step. The spectral decomposition of a + a' is generally NOT the "sum" of the spectral decompositions of a and a'. The projective units of a + a' may differ from those of a or a'.

**However:** T_b(a) = sum lambda_i C_{p_i}(b) where a = sum lambda_i p_i. We can rewrite this as:

T_b(a) = L_b(a) where L_b is the linear operator on V_B defined by its action on the basis of projective units: L_b(p) = C_p(b) for each sharp p, extended linearly.

This is well-defined IF the map p -> C_p(b) extends to a linear map on V_B. Since the projective units span V_B (in a spectral OUS, every element is a linear combination of projective units via spectral decomposition), the extension is unique IF it is consistent: for any linear relation sum alpha_i p_i = 0 among projective units, we need sum alpha_i C_{p_i}(b) = 0.

**Step 5g (Consistency check):** Consider the simplest linear relation: p + p^perp = 1 for any sharp p. We need:

C_p(b) + C_{p^perp}(b) = C_1(b) = b.

This follows from (C4): C_p + C_{p^perp} = id. Check.

More generally, for any resolution of unity sum_i p_i = 1 (mutually orthogonal sharp effects summing to 1):

sum_i C_{p_i}(b) = b.

This follows from the complementarity property extended: the compressions for a complete set of orthogonal projective units partition V_B, so sum C_{p_i} = id. (This is a standard result in Alfsen-Shultz compression theory.)

**Step 5h:** For an arbitrary linear relation sum_j alpha_j q_j = 0 among projective units (not necessarily orthogonal): we need sum_j alpha_j C_{q_j}(b) = 0. This is more subtle and does not follow directly from the compression axioms.

**Resolution:** The map p -> C_p(b) IS the defining property of the sequential product's first-argument action. We DEFINE the sequential product to be the unique bilinear map satisfying:
1. For sharp p, q: p & q = C_p(q)
2. The extension to general effects is via spectral decomposition: a & b = sum lambda_i C_{p_i}(b) where a = sum lambda_i p_i

This definition IS bilinear by construction:
- Linearity in b: proved above (sum of linear maps)
- Linearity in a: BY DEFINITION via the spectral extension

The question of "consistency" (whether different decompositions give the same result) reduces to uniqueness of spectral decomposition, which holds in a finite-dimensional spectral OUS.

**The subtle point:** Bilinearity in the first argument is a property of the DEFINITION, not of the compressions. We are choosing to extend the product from sharp effects to general effects by declaring it linear in the first argument via spectral coefficients. The uniqueness of spectral decomposition ensures this is well-defined. An alternative extension (e.g., one that is NOT linear in the first argument) would also be well-defined but would not satisfy S1.

**Conclusion:** The sequential product a & b = sum lambda_i C_{p_i}(b) is bilinear by construction: linear in b because compressions are linear, and linear in a because the spectral extension is defined to be linear. The definition is well-defined because spectral decompositions in a finite-dimensional spectral OUS are unique.

### SELF-CRITIQUE CHECKPOINT (Step 5):
1. SIGN CHECK: No sign ambiguities in the bilinearity proof. All sums involve non-negative coefficients lambda_i.
2. FACTOR CHECK: No factors introduced. The spectral coefficients lambda_i come from the effect itself.
3. CONVENTION CHECK: C_p is the compression (P-projection), not Luders' rule. Sequential product notation a & b. Consistent with convention lock.
4. DIMENSION CHECK: Everything in V_B (finite-dimensional real vector space). Scalars are real. No dimensional issues.

**Note on the bilinearity proof's structure:** The proof establishes bilinearity AS A PROPERTY OF THE DEFINITION, not as a derived consequence. The spectral extension is DESIGNED to make the product bilinear. The non-trivial content is:
- The definition is well-defined (spectral decomposition is unique)
- The resulting product maps effects to effects (proved in Step 4)
- The definition agrees with compressions on sharp effects (by construction)

The bilinearity gate is PASSED. The product is well-defined and bilinear.

---

## Step 6: Classical Limit on Simplices

### Setup

When B is a classical system, V_B is isomorphic to R^n with the standard order (componentwise ordering) and unit 1 = (1, 1, ..., 1). The state space is the standard probability simplex Delta_{n-1}. Effects are vectors a = (a_1, ..., a_n) with 0 <= a_i <= 1.

Sharp effects in R^n with the simplex state space are exactly the characteristic functions of subsets: for S subset {1, ..., n}, the sharp effect p_S has (p_S)_i = 1 if i in S, (p_S)_i = 0 if i not in S.

### Compressions on a Simplex

For a sharp effect p_S (indicator of subset S), the compression C_{p_S} acts as:

C_{p_S}(b) = (b_1 * 1_{1 in S}, b_2 * 1_{2 in S}, ..., b_n * 1_{n in S})

That is, C_{p_S} projects onto the coordinates in S, zeroing out the rest. This is the unique compression for the face of the simplex generated by the vertices in S.

**Verification of compression properties:**
- C1 (Positivity): if b >= 0, then C_{p_S}(b) >= 0. Check.
- C2 (Idempotence): C_{p_S}(C_{p_S}(b)) = C_{p_S}(b) since zeroing coordinates in S^c twice is the same as once. Check.
- C3 (Unit map): C_{p_S}(1) = (1_{1 in S}, ..., 1_{n in S}) = p_S. Check.
- C4 (Complementarity): C_{p_S}(b) + C_{p_{S^c}}(b) = b. Check.

### Sequential Product on the Simplex

For sharp effects p_S, p_T:

p_S & p_T = C_{p_S}(p_T) = (1_{1 in S} * 1_{1 in T}, ..., 1_{n in S} * 1_{n in T}) = p_{S cap T}

This is the intersection (meet) of indicator functions, which equals the pointwise product p_S * p_T. Check.

For general effects a = sum lambda_i p_{S_i} and b:

a & b = sum lambda_i C_{p_{S_i}}(b)

On a simplex, every effect a = (a_1, ..., a_n) has spectral decomposition a = sum lambda_i p_{S_i} where the S_i are nested subsets determined by the distinct values of a.

### Explicit Verification: n = 2

Let a = (a_1, a_2) and b = (b_1, b_2) with a_i, b_i in [0,1].

**Case 1: a is sharp.** a = (1, 0) = p_{\{1\}}. Then a & b = C_{p_{\{1\}}}(b) = (b_1, 0). And a * b (pointwise) = (a_1 * b_1, a_2 * b_2) = (1 * b_1, 0 * b_2) = (b_1, 0). Equal. Check.

**Case 2: a is general.** a = (a_1, a_2). Spectral decomposition:

If a_1 = a_2 = lambda: a = lambda * 1, so a & b = lambda * C_1(b) = lambda * b = (lambda b_1, lambda b_2) = (a_1 b_1, a_2 b_2). Pointwise product. Check.

If a_1 > a_2: a = a_2 * 1 + (a_1 - a_2) * p_{\{1\}} = a_2 * (1, 1) + (a_1 - a_2) * (1, 0).
Spectral decomposition: lambda_1 = a_2 with p_1 = (0, 1) = p_{\{2\}}, lambda_2 = a_1 with p_2 = (1, 0) = p_{\{1\}}.

Wait -- let me redo this properly. The spectral decomposition writes a = sum lambda_i p_i with p_i orthogonal and sum p_i = 1.

a = (a_1, a_2). The two basis indicators are p_{\{1\}} = (1, 0) and p_{\{2\}} = (0, 1). These are orthogonal and sum to 1.

a = a_1 p_{\{1\}} + a_2 p_{\{2\}}

Spectral decomposition with distinct eigenvalues: if a_1 != a_2, this is the spectral decomposition with lambda_1 = a_1, p_1 = p_{\{1\}} and lambda_2 = a_2, p_2 = p_{\{2\}}.

Then: a & b = a_1 C_{p_{\{1\}}}(b) + a_2 C_{p_{\{2\}}}(b) = a_1 (b_1, 0) + a_2 (0, b_2) = (a_1 b_1, a_2 b_2).

This is exactly the pointwise product. Check.

If a_1 = a_2 = lambda, then a = lambda * 1, spectral decomposition is just a = lambda * 1 (with p = 1, the unit). Then a & b = lambda * C_1(b) = lambda * b = (lambda b_1, lambda b_2) = (a_1 b_1, a_2 b_2). Still pointwise. Check.

### Explicit Verification: n = 3

Let a = (a_1, a_2, a_3), b = (b_1, b_2, b_3).

Spectral decomposition: a = a_1 e_1 + a_2 e_2 + a_3 e_3 where e_i are standard basis indicator vectors (the atoms of the simplex), which are orthogonal sharp effects with sum = 1.

(This is for the case a_1, a_2, a_3 all distinct. If some coincide, the spectral decomposition groups them.)

a & b = a_1 C_{e_1}(b) + a_2 C_{e_2}(b) + a_3 C_{e_3}(b)
     = a_1 (b_1, 0, 0) + a_2 (0, b_2, 0) + a_3 (0, 0, b_3)
     = (a_1 b_1, a_2 b_2, a_3 b_3)

This is the pointwise product. Check.

### Classical Limit Theorem

> **Proposition (Classical Recovery).** When V_B = R^n with simplex state space, the compression-based sequential product a & b = sum lambda_i C_{p_i}(b) equals the pointwise product (a * b)_i = a_i b_i for all effects a, b in [0,1]^n.

This matches the Gudder-Greechie uniqueness result: the pointwise product is the unique sequential product on a simplex satisfying S1-S7. The compression-based construction recovers it exactly. Check.

---

## Step 7: Circularity Audit

### Primitive Usage Inventory

Every operation in the construction is catalogued below, with its OUS justification:

| Operation | Where Used | OUS Justification | Hilbert Space? |
|-----------|-----------|-------------------|----------------|
| Order structure (<=) on V_B | Effect space definition, positivity checks | Primitive of OUS | NO |
| Order unit 1 | S3 check, complement definition | Primitive of OUS | NO |
| Effect space [0,1]_V | Domain of sequential product | Defined by order structure | NO |
| Complement a^perp = 1 - a | Orthogonality, complement tests | Linear operation in V_B | NO |
| Compression C_p for sharp p | Product definition | Alfsen-Shultz P-projection, exists for any projective unit in a spectral OUS | NO |
| Spectral decomposition a = sum lambda_i p_i | Extension from sharp to general | Alfsen-Shultz spectral theory for OUS, independent of Hilbert space | NO |
| Tracking map phi | Physical interpretation | Map between OUS structures | NO |
| Linear combination sum lambda_i C_{p_i}(b) | Product formula | Finite sum of scaled linear maps on V_B | NO |

### Explicit Non-Occurrences

The following Hilbert space constructions are ABSENT from the derivation:

- **sqrt(a):** Never used. The product is C_p(b), not sqrt(p) b sqrt(p).
- **Trace:** Never used. No trace operation appears.
- **Inner product:** Never used. No inner product on V_B is assumed.
- **Density matrices:** Never used. States are positive linear functionals, but the construction works at the effect (Heisenberg) level.
- **Luders rule a & b = sqrt(a) b sqrt(a):** Never used. This is the positive control in the verification harness (Task 2), NOT part of the construction.
- **C*-algebra multiplication:** Never used. No associative algebra product is assumed.
- **Complex structure:** Never used. V_B is a REAL vector space.

### Circularity Verdict

> **PASSED.** The construction uses exclusively order unit space primitives: order structure, effect space, compressions (Alfsen-Shultz P-projections), and spectral decomposition (Alfsen-Shultz spectral theory). No Hilbert space, C*-algebra, or quantum-specific structure is imported. The product is defined on a general finite-dimensional spectral OUS.

---

## Step 8: Parametrization by phi

### The Role of phi

The tracking map phi: Proj(B) -> Proj(M) enters the construction as a PHYSICAL INTERPRETATION, not as an algebraic parameter in the product formula.

The sequential product a & b = sum lambda_i C_{p_i}(b) depends ONLY on B's compression structure. The tracking map phi provides the physical justification for why this product represents "test-update-test":

1. Testing sharp effect p on B triggers compression C_{phi(p)} on M
2. M's state is updated: rho_M -> C_{phi(p)}(rho_M) / omega(phi(p))
3. The updated M-state provides context for testing b on B
4. The combined effect is C_p(b) -- the compression on B corresponding to p

### Required Properties of phi

For the physical interpretation to be consistent, phi must satisfy:

**(P1) Positivity:** phi maps sharp effects of B to sharp effects of M. (This ensures the model update is a valid compression.)

**(P2) Unitality:** phi(1_B) = 1_M. (Testing the trivial effect should not update the model. This ensures S3: 1 & a = C_1(a) = a.)

**(P3) Orthogonality preservation:** If p perp q in B (i.e., p + q <= 1), then phi(p) perp phi(q) in M. (Per user decision: this is the property whose necessity is explored in Plans 02-04.)

**Note:** P3 is NOT required for the mathematical definition of the product (which depends only on B's compressions). P3 is a constraint on phi for the PHYSICAL INTERPRETATION of the self-modeling feedback loop to be consistent. Whether S4 requires P3 is a result of Plan 02, not a premise of this plan.

### What phi Does NOT Need to Satisfy (at This Stage)

- **Injectivity (faithfulness):** phi may or may not be injective. Injective phi (dim M >= dim B) represents a "faithful" self-model. Non-injective phi represents coarse-graining.
- **Surjectivity:** phi may or may not be surjective.
- **Algebraic homomorphism:** phi is not required to preserve the sequential product (that would be circular -- the sequential product on M is not yet defined).

### The Sequential Product as a One-Parameter Family

The sequential product a & b = sum lambda_i C_{p_i}(b) is actually INDEPENDENT of phi as a mathematical object. It depends only on B's internal compression structure.

The parametrization by phi enters at the level of physical interpretation:
- Different phi values represent different self-modeling relationships between B and M
- The algebraic properties (S1-S7) of the product are intrinsic to B
- phi determines whether the physical scenario (self-modeling cycle) is consistent, not whether the mathematical product is well-defined

> **Result:** The sequential product is defined intrinsically on B via compressions, independently of the tracking map phi. The tracking map phi parametrizes the PHYSICAL INTERPRETATION (which systems B and M are, and how they are coupled), not the ALGEBRAIC DEFINITION of the product. Properties of phi constrain the physical consistency of the self-modeling scenario but do not affect the mathematical properties (S1-S7) of the product on B.

This is a significant simplification: S1-S7 are properties of B's compression structure alone. If B has a spectral OUS structure whose compressions yield a sequential product satisfying S1-S7, then B is an EJA by Theorem 1, regardless of what phi is.

### Implication for the Project

The self-modeling constraint does NOT enter through the algebraic definition of the sequential product (which is C_p(b), defined using B's own compressions). Instead, the self-modeling constraint enters through the PHYSICAL JUSTIFICATION for why the compression-based product is the correct formalization of "test-update-test."

The key claim (to be explored in Plans 02-04) becomes: **self-modeling forces B to have the specific compression structure that makes S1-S7 hold.** In particular, S4 (symmetry of orthogonality) must follow from the self-modeling constraint on the relationship between B and M, manifested through the compression algebra of B.

---

## Summary of Results

| Result | Status | Confidence |
|--------|--------|-----------|
| Framing: E(B) selected, E(B x M) rejected | RESOLVED | [CONFIDENCE: HIGH] -- vdW single-system framework matches E(B); E(B x M) has three exhibited failure modes |
| Well-definedness: a & b in [0,1]_V | PROVED | [CONFIDENCE: HIGH] -- follows from positivity (C1) and unit map (C3) of compressions |
| Bilinearity | PROVED (by construction) | [CONFIDENCE: HIGH] -- linear in b by linearity of compressions; linear in a by spectral extension definition; well-defined by uniqueness of spectral decomposition |
| S3 (Unitality): 1 & a = a | PROVED | [CONFIDENCE: HIGH] -- C_1 = id |
| Classical limit: pointwise product on simplices | PROVED for n=2,3 | [CONFIDENCE: HIGH] -- explicit computation matches Gudder-Greechie uniqueness |
| Circularity audit | PASSED | [CONFIDENCE: HIGH] -- complete primitive inventory shows zero Hilbert space imports |
| phi parametrization | STATED | [CONFIDENCE: HIGH] -- phi is a physical interpretation parameter, not an algebraic parameter; product is intrinsic to B |

### What This Plan Establishes

The compression-based sequential product a & b = sum lambda_i C_{p_i}(b) is:
1. A well-defined bilinear map on the effect space of any finite-dimensional spectral OUS
2. Intrinsic to the OUS structure (no Hilbert space imports)
3. Consistent with the classical limit (pointwise product on simplices)
4. Compatible with vdW's single-system framework (E(B) framing)
5. Parametrized by the tracking map phi for physical interpretation, but algebraically independent of phi

### What Remains (Plans 02-04)

- Verify S1 (additivity) -- expected to follow from linearity of compressions
- Verify S2 (continuity) -- automatic in finite dimensions
- Verify S4 (symmetry of orthogonality) -- the decisive test
- Verify S5-S7 (associativity/additivity/multiplicativity of compatible effects)
- Verify non-associativity
- Classify the resulting EJA (if S1-S7 hold)

### Critical Observation for Downstream Plans

The product a & b = C_p(b) = sum lambda_i C_{p_i}(b) is exactly the **Alfsen-Shultz compression product**. This is a KNOWN algebraic structure on spectral OUS. Whether it satisfies S1-S7 is a question about the compression algebra of finite-dimensional spectral order unit spaces.

The self-modeling interpretation provides the PHYSICAL MOTIVATION for considering this specific product. But the mathematical verification is a question about compression algebras in OUS theory, not about self-modeling per se.

---

## ADDENDUM: Critical Finding from SymPy Verification

### The Peirce Decomposition Problem

**DEVIATION [Rule 5 -- Physics Redirect]:** The compression-based product as defined above FAILS S3 (unitality) on M_2(C)^sa for effects with off-diagonal components. This was discovered during SymPy verification.

### The Bug

In M_2(C)^sa, the Alfsen-Shultz compression for a rank-1 projection P = |v><v| is:

C_P(A) = P * A * P = <v|A|v> * P

For the identity I = P0 + P1, the spectral extension gives:

I & b = 1 * C_{P0}(b) + 1 * C_{P1}(b) = P0*b*P0 + P1*b*P1

This is the **pinching map** (diagonal projection in the P0/P1 eigenbasis), NOT the identity map. For any b with off-diagonal components (e.g., b = P_+ = (1/2)[[1,1],[1,1]]):

I & P_+ = P0*P_+*P0 + P1*P_+*P1 = (1/2)P0 + (1/2)P1 = (1/2)I != P_+

So S3 (1 & a = a) FAILS.

### Root Cause: Peirce Decomposition

The Alfsen-Shultz compression C_p maps V to the **face** generated by p. For V = M_2(C)^sa with p = P0:
- face(P0) = {lambda * P0 : lambda >= 0} (1-dimensional)
- face(P1) = {lambda * P1 : lambda >= 0} (1-dimensional)
- The Peirce 1-space = off-diagonal Hermitian matrices (2-dimensional)

The Peirce decomposition is V = V_2(p) + V_1(p) + V_0(p), where:
- V_2(p) = face(p) = range of C_p
- V_0(p) = face(p^perp) = range of C_{p^perp}
- V_1(p) = "off-diagonal" subspace, NOT in the range of either compression

The sum C_p + C_{p^perp} projects onto V_2 + V_0, losing V_1 entirely. For a non-commutative OUS (like M_2(C)^sa), V_1 is nontrivial, so C_p + C_{p^perp} != id.

This is not an error in the compression theory -- it is a correct statement about how compressions work. The error was in assuming sum_i C_{p_i} = id for a resolution of unity, which only holds in commutative (classical) OUS where V_1 = 0.

### What This Means for the Construction

The simple spectral extension a & b = sum lambda_i C_{p_i}(b) is TOO DESTRUCTIVE for non-commutative systems. It "decoheres" the second argument by killing Peirce 1-space components. This is physically interesting (it corresponds to a completely dephasing channel), but it does not give a sequential product.

### Why It Works Classically

On a simplex (commutative OUS), the Peirce 1-space is trivial (V_1 = 0). The compressions are coordinate projections, and sum C_{p_i} = id. So the spectral extension correctly gives pointwise multiplication. This is why the classical limit test passed.

### The Correct Approach

The Luders product sqrt(a)*b*sqrt(a) is the STANDARD sequential product on M_2(C)^sa. For projections, sqrt(P) = P, so the Luders product agrees with the compression product on sharp effects. But for general effects, sqrt(a) "interpolates" the Peirce components rather than projecting them away.

The correct OUS sequential product likely requires a formula that preserves the Peirce 1-space. Options:

1. **Quadratic representation:** a & b = U_a(b) where U_a is the quadratic representation of the Jordan algebra (in the EJA M_2(C)^sa, this is exactly the Luders map). But this imports Jordan algebra structure, which is what we are trying to derive.

2. **Modified compression with Peirce mixing:** Define a & b using compressions PLUS a contribution from the Peirce 1-space that depends on the spectral coefficients. This would need to be motivated by the self-modeling constraint.

3. **Operator geometric mean:** a & b = a^{1/2} b a^{1/2} (Luders). But a^{1/2} requires a notion of "square root" that is not a priori available in a general OUS.

### Impact on the Project

This finding does NOT kill the project. It sharpens the question:

**Old question:** Does the compression-based product C_p(b) satisfy S1-S7?
**New question:** What OUS primitive correctly extends the compression product from sharp to general effects while preserving S3?

The compression product IS correct on sharp effects. The extension to general effects is the non-trivial step. The self-modeling constraint may provide the missing ingredient: the feedback loop B -> M -> B might naturally produce an extension that preserves Peirce 1-space components.

### Revised Summary Table

| Result | Status | Confidence |
|--------|--------|-----------|
| Framing: E(B) selected, E(B x M) rejected | RESOLVED | [CONFIDENCE: HIGH] |
| Well-definedness (sharp effects): p & q = C_p(q) in [0,1] | PROVED | [CONFIDENCE: HIGH] |
| Bilinearity of C_p(b) in b (second argument) | PROVED | [CONFIDENCE: HIGH] |
| S3: 1 & a = a | **FAILS** for naive spectral extension on M_2(C)^sa | [CONFIDENCE: HIGH] -- exhibited numerically |
| Bilinearity in first argument via spectral extension | **FAILS** for non-commutative OUS (inconsistent with S3) | [CONFIDENCE: HIGH] |
| Classical limit: pointwise product on simplices | PROVED | [CONFIDENCE: HIGH] -- correct for commutative case |
| Circularity audit | PASSED | [CONFIDENCE: HIGH] |
| Compression product = valid SP | **REFUTED** for non-commutative OUS | [CONFIDENCE: HIGH] |

### Recommendation for Plans 02-04

The compression product C_p(b) is the correct "building block" for sharp effects. The challenge is extending it to a bilinear product on general effects that:
1. Agrees with C_p(b) when a = p is sharp
2. Satisfies S3 (1 & a = a)
3. Does not import Hilbert space structure

The self-modeling constraint (tracking map phi, feedback loop) may constrain the extension uniquely. This should be explored in Plan 02, which should be re-scoped to address this extension problem.

The key insight from this failure: **the Peirce 1-space carries the non-commutative structure, and any valid sequential product must preserve it.** The compression product kills it; the Luders product preserves it (via sqrt). The OUS version of "preserving the Peirce 1-space" is the structural requirement that the self-modeling constraint must impose.
