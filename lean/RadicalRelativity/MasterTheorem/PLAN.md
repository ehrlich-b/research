# MasterTheorem formalization — PLAN

Machine-checked formalization of the master theorem of

> Ehrlich 2026, *Sequential-Product Moduli on Simple Euclidean Jordan Algebras*
> (`landing/papers/twist-normal-form/main.tex`), theorem `mthm:master`.

**Mandate (verbatim).** "Lean is to make sure everything passes machine analysis not
just llm non-deterministic checking." The machine must certify the **logical chain**
from an honest axiom ledger (cited classical theorems only) to `mthm:master`.
Chain-completeness beats per-lemma depth: an abstract interface that lets the whole
chain assemble `sorry`-free is preferred over deep concrete constructions that stall.

**Master theorem.** On a finite-dimensional simple Euclidean Jordan algebra `J` of
rank `n ≥ 3`, every norm-continuous S1–S7 sequential product on `Eff(J)` is:
Lüders `a•b = Q_{√a}b` on the real (`Hₙ(ℝ)`), quaternionic (`Hₙ(ℍ)`), and exceptional
(`H₃(𝕆)`) types; and `a^{1/2+it} b a^{1/2−it}` for one global `t ∈ ℝ` on the complex
type `Hₙ(ℂ) = Mₙ(ℂ)ˢᵃ`. Rank-two boundary: real qubit rigid; complex qubit admits an
explicit frame-dependent `τ(F)` family (necessity-only, no exhaustiveness claim).

The route formalized is the **de-ansatzed comparison-map route** (notes
`C6-TRANSPLANT-TEST`, `C1-CROSSTYPE-STABILIZER`, `C2A-KILLTEST-SANDWICH`, all
`research/qm-genericity-review/…-2026-07-13.md`). It replaces the ansatz normal form
`K(r) = Q_{√a}⁻¹ L_a` by van de Wetering's comparison map `Θ_a`, so Peirce-block
diagonality and the single block generator are **conclusions**, not hypotheses. The
older ansatz-route formalization lives in `RadicalRelativity/Selection/*.lean` (the
paper's §8 prior-art remark) and is **not modified**; it may be imported for reuse.

---

## 1. Dependency skeleton, per paper section

> **REFRAME (post-adversarial audit, 2026-07-14 — `TWIST-NORMAL-FORM-MAXIMAL-ADVERSARIAL-2026-07-14.md`).**
> The Lean development is an **abstract dependency skeleton**, NOT a formalization of the
> paper theorem. It checks downstream algebraic implications from explicit interface
> fields (hyperplane factorization, conditional typewise `T = 0` results, character
> equality on an interval, connectivity induction, a generic dense-agreement lemma). It
> does **not** formalize S1–S7, construct the comparison character or its differential,
> connect the global frame family to one sequential product, or state the paper's master
> theorem as an equality of products. **"PROVED" below means the Lean lemma of that name
> is proved from the interface fields** — NOT that the paper statement is machine-checked.
> `master_chain` is the *skeleton counterpart* of `mthm:master`, not the theorem itself
> (§2, §5.7 of the report).

| Paper section / label | Lean status | Module |
|---|---|---|
| `def:sp` (S1–S7 axioms) | **NOT encoded** — the skeleton begins at the comparison map `Θ`, downstream of the S1–S7 order-unit-space axioms; S1–S7 have no Lean representation | — |
| `lem:span` (effects span) | not needed (skeleton consumes `Θ`, not raw `L_a`) | — |
| `thm:vdw1` (SES ⟹ EJA structure thm) | **imported** context; not in the skeleton (we start abstractly at `Θ`) | — |
| `lem:simple-bridge` (every effect simple) | folded into the setup (`aOf_inv` carries invertibility as a hypothesis) | Interface |
| `lem:aone` (`a•1 = a`) | **SKIPPED** — inexpressible on the `Θ`-interface; `Θ_unital` covers the skeleton's need (§2) | — |
| `prop:bridge` (compatibility ⟺ operator commutation) | **imported field** (vdW EJA appendix / arXiv:1912.01903); enters as the `OpCommute` hypothesis of `Θ_fix` | Interface field |
| `prop:theta` (Θ_a is a Jordan automorphism) | **PROVED from field** — `jordanAuto` projects the `Θ_jordan` field (vIR conclusion carried as a cited hypothesis; **no axiom**) | Interface ✅ |
| `lem:frame-fix` (Θ fixes frame, preserves blocks, ∈ Stab(F)°) | **PROVED** — `frame_fixed` done; block-preservation + `Stab°` = target | Interface ✅ / DiagonalHom |
| `lem:coalescence` (D3) | **PROVED** ✅ (from `Θ_fix` + FK simult.-diag.) | Coalescence ✅ |
| `lem:homomorphism` (χ hom, `dχ` linear, ρ_{ij}(dχ r)=(r_i−r_j)T_{ij}) | **PROVED** ✅ (`lieHom_smooth` now a proved `def`, A2 DONE; hyperplane factorization) | DiagonalHom ✅ |
| `prop:real` | **PROVED** ✅ (trivial: 𝔰𝔬(1)=0) | Branches/Real ✅ |
| `thm:quaternionic` | **PROVED** ✅ (concrete `Quaternion ℝ`) | Branches/Quaternionic ✅ |
| `thm:albert` | **PROVED** ✅ (`IsAlbertModel.block_injective` field, A4 DONE + `faithful_kill`) | Branches/Albert ✅ |
| `thm:complex` (per-frame `t_F`) | **PROVED** ✅ (concrete ℝ-coefficient matching) | Branches/Complex ✅ |
| `thm:complex` (global `t`) | **PROVED** ✅ — `Globalization.global_t` (`real_character_unique`, A3 proved not axiom; frame connectivity as hypothesis) | Globalization ✅ |
| `lem:frame-connectivity` | **PROVED** in paper ⟹ Lean target (NOT an axiom); or explicit hypothesis of the globalization theorem | Globalization |
| `prop:singular` (S2 extension) | **PROVED (generic lemma)** — dense-agreement kernel (`Set.EqOn.closure`); S2-continuity + invertible-density as disclosed hypotheses; a standalone lemma **not invoked by the capstone** | Master |
| `mthm:master` (assembly) | **SKELETON COUNTERPART ONLY** — `master_chain` is a conjunction of the conditional interface lemmas (block-preservation; `T=0` for three abstract couplings; per-frame scalar; global constancy of a fourth abstract family). It does **not** state that `J` is a simple EJA of a type, that a product satisfies S1–S7, that `L_a=Q_{√a}Θ_a`, or `a·b = Q_{√a}b` / `a^{1/2+it}ba^{1/2−it}`. Not the paper theorem (§5.7). | Master |
| `prop:n2-necessity`, `thm:qubit-boundary` | **PROVED** ✅ (concrete `M₂(ℂ)`, algebraic core; 3 upper-layer items scoped — see §2) | RankTwo ✅ |
| `cor:selectors` | optional prior-art corollary | (skip / RankTwo) |

**Never axiomatized (proved as skeleton lemmas from the interface fields):**
`prop:theta`, `lem:frame-fix`, `lem:coalescence`, `lem:homomorphism`, every branch,
globalization, `lem:frame-connectivity` (induction only — §2), `prop:singular` (generic
lemma, not invoked by the capstone). **`mthm:master` is the exception:** its Lean form
`master_chain` is the *skeleton counterpart* (a conjunction of the conditional lemmas),
NOT the paper theorem as an equality of products — see the §1 reframe and §2 Master note.

---

## 2. LEDGER — cited imports as fields, located hypotheses, residual axioms

**Framing (post-adversarial audit, 2026-07-14): conditional dependency skeleton, target
ZERO global custom axioms.** The audit (report §5) showed the three former global axioms
quantified over interfaces too weak for their sources, so **as global statements they
were FALSE** — a soundness risk, not merely "strong":
- A1 asserted a unital order map preserves a Jordan product over structures encoding no
  JB-algebra (counterexample: a coordinatewise product on `ℝ²` with a unital
  non-multiplicative order map under a trivial `nonneg`);
- A2 asserted every additive map `ℝⁿ → Stab` is `ℝ`-linear (false: discontinuous
  Cauchy additive maps);
- A4 asserted a nonzero linear map out of an abstract 28-dim space is injective (false).

The repair converts each to a **scoped interface field / hypothesis** so nothing is a
false global axiom:

| Former axiom | New form | Status |
|---|---|---|
| **A1 `vanImhoffRoelands`** | `ComparisonSetup.Θ_jordan` **field** (cited vIR conclusion, scoped to the caller's instance) | **DONE** ✅ (Interface) |
| **A2 `lieHom_smooth`** | proved `def` (continuous-additive ⟹ ℝ-linear on `ℝⁿ`, `AddMonoidHom.toRealLinearMap`); Cartan smoothness = `DiagonalHomSetup.dχAdd_cont` continuity field | **DONE** ✅ (DiagonalHom) |
| **A3 `character_of_Rn`** | proved theorem `real_character_unique` | **DONE** ✅ (Globalization) |
| **A4 `yokota_spin8_triality_faithful`** | `IsAlbertModel.block_injective` **field** (`ρ_ij` injectivity as the cited Yokota hypothesis; false dimension gate + dims/nontriviality fields removed) | **DONE** ✅ (Albert) |

All four repaired: `#print axioms master_chain` (the capstone was renamed per report §5.7)
= **Lean core only** (`propext`, `Classical.choice`, `Quot.sound`) — *zero global custom
axioms over a conditional skeleton*. The `#print axioms` figure alone establishes only
syntactic closure — it omits every structure field, so it is not a faithfulness certificate
(report §5.9); the classical-import surface is the field lists of `ComparisonSetup` /
`CoalescenceSetup` / `DiagonalHomSetup` / `IsAlbertModel`.

### A1 · `vanImhoffRoelands` — **CONVERTED TO A FIELD** ✅ (`Interface.lean`, `Θ_jordan`)

- **Status.** **No longer an axiom.** Now the `ComparisonSetup.Θ_jordan` field:
  `∀ a, Inv a → ∀ x y, Θ a (jordan x y) = jordan (Θ a x) (Θ a y)`, projected by
  `jordanAuto`. Carried as a *cited hypothesis* — the conclusion of applying vIR to `Θ_a`
  on the intended EJA instance — because the interface does **not** encode the JB-algebra
  premises (Jordan identity, formal reality, cone-of-squares `nonneg`), so a global axiom
  form would be false. `#print axioms jordanAuto` = core only.
- **Source (of the imported conclusion).** van Imhoff & Roelands, *Order isomorphisms
  between cones of JB-algebras*, arXiv:1904.09278, **Corollary 2.5** (`orderisoms`,
  src.tex l. 246) / **Proposition 2.6** (`p:order_isomorphism`, l. 259). Classical
  corroboration: Alfsen–Shultz, *Geometry of State Spaces*, **Thm 2.80**.
- **Where used.** `ComparisonSetup.jordanAuto` = the skeleton's `prop:theta` conjunct;
  enters `master_chain` through the block-preservation certificate (§2 Master note).

### A2 · `lieHom_smooth` — **REPAIRED ✅ (proved `def`, no axiom; DiagonalHom lane)**

- **AUDIT FINDING (report §5.2), NOW FIXED.** The old axiom's *Lean type* took an
  arbitrary additive `(Fin n → ℝ) →+ Stab` and returned an `ℝ`-linear map equal to it —
  asserting **every additive map is real-linear**, false (discontinuous Cauchy maps).
- **Repair shipped.** `lieHom_smooth` is now a proved `def`: a *continuous* additive map
  `(Fin n → ℝ) →+ Stab` (into a normed ℝ-space `Stab`) is ℝ-linear, via Mathlib's
  `AddMonoidHom.toRealLinearMap` (ℚ-linearity from additivity, then `ℚ`-density + continuity).
  `#print axioms lieHom_smooth` = core only. `DiagonalHomSetup.Stab` is now
  `NormedAddCommGroup + NormedSpace ℝ`.
- **What carries the smoothness (Cartan).** Only the **continuity** of the differential —
  the `DiagonalHomSetup.dχAdd_cont : Continuous dχAdd` **field** (a cited hypothesis, not a
  global axiom). The differential `dχAdd`/`coalescence_diff` remain interface data.
- **§5.5 honesty (docstring + here).** `DiagonalHomSetup` begins **after** the paper's
  analytic comparison-to-differential step: nothing in Lean constructs `dχAdd` from the
  proved comparison cocycle (`chi_extend`/`chi_comm`) or equates it with a derivative of
  `Θ`. Lean checks only the downstream linear algebra — `lieHom_smooth` (continuity ⟹
  linearity) and `hyperplane_factorization` (the vanishing shadow `coalescence_diff` ⟹ the
  single-generator coupling, strictly stronger, hence a genuine conclusion). No "produced
  from the cocycle" is claimed.
- **Source (of the smoothness content carried as the continuity field).** Cartan's theorem
  / the one-parameter-subgroup theorem (Bröcker–tom Dieck, *Representations of Compact Lie
  Groups*), used in `main.tex` proof of `lem:homomorphism`.
- **Where used.** `DiagonalHom.dChiLinear` / `toStabilizerCoupling` (both core-only now).

### A3 · `character_of_Rn` — **REDUCED TO A PROVED THEOREM** ✅ (`Globalization.lean`)

- **Status.** **No longer an axiom.** Proved as `real_character_unique` in
  `Globalization.lean` from Mathlib's `Complex.exp` derivative machinery
  (`HasDerivAt.cexp` + eventual-constancy at an interior point + `HasDerivAt.unique`).
  `#print axioms` on the Globalization capstone shows only core axioms. With A1 a field
  (`Θ_jordan`), A4 a field (`IsAlbertModel.block_injective`), and A2 a proved `def`
  (`lieHom_smooth`), **no custom axioms remain** — `#print axioms master_chain` = core only.
- **Statement (as proved).** Two continuous real characters of `ℝ` agreeing on an open
  interval are equal: if `exp(i α x) = exp(i β x)` for all `x ∈ (a,b)` with `a < b`,
  then `α = β` (no `2π` ambiguity). This is the consumed form of "every continuous
  character of `ℝⁿ` is `e^{i⟨c,r⟩}`".
- **Source (now internalized).** Elementary theory of continuous characters of `ℝ`
  (`main.tex` `thm:complex`, "uniqueness of continuous characters of ℝ"); realized via
  the derivative of `x ↦ exp(i α x)` vanishing on an interval where the character is
  constant.
- **Where used.** `Globalization.ComplexGlobalizationData.adjacent_eq` → `global_t`.

### A4 · `yokota_spin8_triality_faithful` — **CONVERTED TO A FIELD** ✅ (`IsAlbertModel.block_injective`)

- **Status.** **No longer an axiom** (Albert lane, done). The global axiom is deleted;
  `IsAlbertModel` now carries `block_injective` — `ρ_{ij}` injectivity as the cited Yokota
  hypothesis — and the false dimension gate (the old dims-8/28 + nontriviality fields) is
  removed. `albert_luders` = core axioms only.
- **AUDIT FINDING it resolves (report §5.3).** The former marker asserted only block dim 8,
  stabilizer dim 28, nonzero maps, then concluded injectivity — which those do NOT imply
  (a nonzero linear map out of an arbitrary 28-dim space need not be injective; no
  `𝔰𝔭𝔦𝔫(8)`, no triality). **The "unsatisfiable off the exceptional type" claim was FALSE
  and is deleted everywhere.** The repair carries injectivity as an explicit cited field
  (`block_injective`), scoped honestly rather than falsely derived.
- **Statement (intended, faithful).** For `H₃(𝕆)` with `F₄ = Aut(H₃(𝕆))`, the pointwise
  stabilizer of the three diagonal primitive idempotents is `≅ Spin(8)`, realized as
  the triality triple `{(a₁,a₂,a₃) ∈ SO(8)³ : (a₁x)(a₂y) = a₃(xy)}`, whose three
  `SO(8)` factors act on the three octonionic Peirce lines `(V₁₂,V₁₃,V₂₃)` by the
  vector and two half-spin representations `8_v, 8_s, 8_c`. Each is a **nontrivial**
  representation of the **simple** Lie algebra `𝔰𝔭𝔦𝔫(8)`, hence **faithful**.
  Consumed form: each block representation `ρ_{ij}` is injective.
- **Source.** Yokota, *Exceptional Lie Groups*, arXiv:0902.0431, **Thm 2.7.1** (p. 51,
  pointwise stabilizer `≅ Spin(8)`) + **Thm 1.16.2** (pp. 28–29, the `SO(8)³` triple);
  representation labels `8_v/8_s/8_c` from Baez, *The Octonions*, Bull. AMS 39 (2002),
  §2.4, 4.2. (Simplicity ⟹ faithful is elementary Lie theory, provable in Lean if
  desired; the Yokota identification of the stabilizer is the imported fact.)
- **Where used.** `Branches/Albert` — hands injectivity of `ρ_{ij}` to
  `StabilizerCoupling.faithful_kill`.

### Imported vdW / FK facts carried as `ComparisonSetup` fields (not free axioms)

A reviewer enumerates these by reading the `ComparisonSetup` structure. Each is a
cited van de Wetering proposition or Faraut–Korányi fact, specialized to the setup:

| Field | Import | Source |
|---|---|---|
| `aOf_inv` | simple invertible effects are order preserving | vdW Prop **4.20** (`prop:finiteranksequentialorder`) |
| (compatibility transfer, inside `Θ_fix`) | commuting simple effects ⟹ products agree | vdW Prop **5.2** (`commutingeffects`) |
| `Θ_unital`, `Θ_orderIso` | `Θ_a` unital linear order iso, `L_a=Q_{√a}Θ_a` | vdW Prop **5.3** (`relatedsequentialproducts`) |
| `Θ_fix` | `Θ_a` fixes the operator-commutant | vdW Prop **5.5** (`automorphismcommute`) + bridge |
| `Θ_cocycle` | cocycle on commuting invertible effects | vdW Prop **5.7** (`isomorphismgroup`) |
| (`OpCommute` = hypothesis form) | compat ⟺ `[Q_a,Q_b]=0 ⟺ [T_a,T_b]=0` | vdW EJA appendix / arXiv:1912.01903 |
| `frame_opCommute` | frame idempotents operator-commute with `a(r)` | Faraut–Korányi Peirce/spectral |

`thm:vdw1` (SES ⟹ EJA) and the JvNW classification (which simple types occur) are
context, not chain inputs: we start *from* a simple EJA of a fixed type.

### Deferred / honesty notes

- **Full EJA-ness.** `ComparisonSetup` carries `jordan_comm`, `jordan_unit` as cheap
  anchors; the Jordan identity, formal reality, and simplicity are EJA data (FK/JvNW)
  the chain does not consume (it consumes `Θ`'s properties). Simplicity enters only
  through frame conjugacy (FK Thm IV.2.5) and the type list; ledger those where used.
- **`lem:frame-connectivity` — SHIPPED AS AN EXPLICIT HYPOTHESIS (auditor-visible).**
  The paper *proves* this (frames of `Mₙ(ℂ)` sharing `n−2` atoms form a connected
  graph), so it is **never an axiom**. In `Globalization.lean` it is the `connected`
  field of `ComplexGlobalizationData` — a documented *theorem hypothesis*, not a global
  `axiom` and not a `sorry`. **What is still assumed vs. machine-checked, stated plainly
  for the adversarial audit:** the graph-theoretic *induction* of the paper's proof IS
  machine-checked (`connected_of_reducing`: if every distinct pair admits a
  measure-reducing 2-plane-rotation adjacency move, the graph is connected — the paper's
  "after ≤ n−1 moves the atom is fixed; induct" skeleton). What remains assumed is the
  single *geometric* fact feeding it — that the reducing rotation move exists in `ℂⁿ`
  (the paper's "rotate a pair `{v_i,v_j}` toward `u`"), isolated as the `hmove`
  hypothesis of `connected_of_reducing` / discharged when `Master` builds a concrete
  `Frame`. A concrete `ℂⁿ`-orthonormal-frame formalization of `hmove` is deferred (heavy:
  unitary orbits + phase quotient), but the connectivity *reasoning* is no longer taken
  on faith — only the one located geometric move is.
- **`DiagonalHom` seam (Packet A) — three located disclosures (auditor-visible).**
  `Coalescence.lean` + `DiagonalHom.lean` shipped green with **no custom axioms** (`A2`
  `lieHom_smooth` is a proved `def`; continuity is the cited `dχAdd_cont` field), and the
  coupling `ρ_{ij}(dχ r) = (r_i − r_j)·T_{ij}` is **proved**
  in `toStabilizerCoupling` via `hyperplane_factorization` (the seam to `Branches`
  holds). What is assumed vs. proved, plainly:
  - **`coalescence_diff`** (`ρ_{ij}(dχ r) = 0` on `{r_i = r_j}`) is carried as a
    `DiagonalHomSetup` **field**. It is the A2-*differential* shadow of the group-level
    coalescence, which **IS proved** in `Coalescence.lean` (`coalescence_block`,
    `lem:coalescence`). Deriving the differential form *in Lean* from the group form
    would require exp/Lie differentiation on `End(V)` (`Θ`'s block action is
    `exp(ρ(dχ))`); that analytic bridge is **skipped under the chain-completeness
    mandate** and the field stands in for it — the mathematical content is proved at the
    group level, only its differentiation is assumed.
  - **`aone`** (`a•1 = a`, `lem:aone`) is **skipped**: it is not expressible on the
    `Θ`-interface (which exposes `Θ`, not the raw left action `L_a`), and `Θ_unital`
    already covers everything the chain needs from it. No loss to the chain.
  - **`chi_extend`** (the `ℝⁿ` extension of the `Θ`-cocycle) is stated in the paper's
    **cancellation form** `χ̃(s − t) := Θ_s Θ_t⁻¹` (well-defined by cancellation +
    abelian image), matching `main.tex` `lem:homomorphism`, not a stronger reformulation.
- **The differential object is disconnected from `Θ` (report §5.5) — auditor-visible.**
  Beyond `coalescence_diff`: `chi_extend` proves only one cross-product equality; it does
  **not** construct the homomorphism `χ : ℝⁿ → Stab(F)°`, its continuity, its
  differential, or the relation of that differential to `Θ`. `DiagonalHomSetup` supplies an
  **arbitrary additive `dχAdd`** and the assumed `coalescence_diff`; nothing equates
  `dχAdd` with a derivative of the proved comparison cocycle. `hyperplane_factorization`
  genuinely factors an *assumed* differential shadow; it does not derive the shadow from
  group-level coalescence. Honest statement: **`DiagonalHomSetup` begins after the paper's
  analytic comparison-to-differential step; Lean checks only the downstream linear
  algebra.** (Full connection = report R4, a major formalization repair, not yet done.)
- **Complex globalization anchor (report §5.6) — REPAIRED, residual caveat
  auditor-visible.** In `master_chain`, clause 5a concerns the produced coupling
  `Dc.toStabilizerCoupling`; clause 5b globalizes the frame family `Scfam`. The family's
  reference member is now explicitly anchored by the hypothesis
  `hanchor : Scfam F₀ = Dc.toStabilizerCoupling`, which the `master_chain` proof genuinely
  consumes (clause 5a is proved by rewriting along `hanchor`). Residual caveat: Lean still
  does **not** construct the entire family from one sequential product — the non-reference
  members remain interface data.
- **Master assembly (`master_chain`) — three located notes (auditor-visible).**
  `Master.lean` shipped green; after the A1→field repair, `#print axioms master_chain` =
  **Lean core only** (A1 = `Θ_jordan` field; A4 = `IsAlbertModel.block_injective` field;
  A3 = proved theorem `real_character_unique`; A2 = proved `def` `lieHom_smooth`). Zero
  global custom axioms. Three entry-point
  facts a reviewer should see stated plainly:
  1. **Where the vIR (former A1) content enters.** The `Θ_jordan` field reaches
     `master_chain` through the **frame-fixing certificate** conjunct (`block_preserved`
     / `lem:frame-fix`), *not* through the differential typewise kills. As a field it is
     invisible to `#print axioms`, so the audit must read the interface. Faithful to the
     paper — `prop:theta`
     (which A1 licenses via `jordanAuto`) is what makes `Θ_a` a Jordan automorphism, and
     the frame-fixing / block-preservation certificate is where that automorphism property
     is consumed; the differential face (`StabilizerCoupling`) is licensed by it. The
     entry point is named so the audit is not misled into expecting A1 inside the kills.
  2. **Complex clause: anchored family.** Master clause 5a is obtained from the
     anchored reference member (`hanchor : Scfam F₀ = Dc.toStabilizerCoupling`, consumed
     by the proof); clause 5b globalizes that same family `Scfam` via the adapter
     interface (`Adapter.complex_global_twist`). Non-reference members of the family
     remain interface data (see the §5.6 caveat above).
  3. **`prop:singular` is a separate disclosed lemma.** `prop_singular` is proved as the
     **dense-agreement kernel** (`Set.EqOn.closure`), with **S2-continuity** and
     **invertible-density** carried as explicit disclosed hypotheses. It is kept as its
     own lemma *outside* the master conjunction (so the conjunction stays clean and the
     two analytic hypotheses are visibly localized to the singular-extension step). This
     supersedes the earlier note that S2 was "not yet a field": it is now handled in
     `Master`, as a located hypothesis of `prop_singular`, not a `ComparisonSetup` field.
- **Rank-two boundary (`RankTwo.lean`) — three scoping notes (auditor-visible).**
  Shipped green (core axioms only, 15 top-level results) on concrete `M₂(ℂ)`. The
  algebraic core is formalized; three upper-layer items are scoped out, stated plainly:
  1. **Cocycle subcases.** In the `Θ_a` cocycle analysis (Step 6, `|ζ| = 1`), only the
     **load-bearing shared-frame `ζ = 1` case (V5a)** is formalized. The unimodular-scalar
     subcases **V5b/V5d** (one argument scalar / product scalar) are **not** formalized;
     the paper's full "`|ζ| = 1` in every commuting case" analysis stays a paper proof.
  2. **`thm:qubit-boundary`(ii) not bundled.** The seven-axiom verification of the
     `τ(F)` family is **not** assembled as one `S1–S7` theorem. Its ingredients are
     present (linearity, unitality, S4-backward, cone-preservation via `sp_maps_effects`),
     but the full `S1–S7` order-unit-space instantiation on `M₂(ℂ)` is outside the
     algebraic-core scope of this module.
  3. **Necessity at the generator level.** `n2_necessity` and
     `n2_exchange_selects_luders` (Remark 6.2, Paper-B-facing) are stated at the
     **generator level** — for an arbitrary real-linear block angle vanishing on the
     coalescence line — so they are **genuine necessity, not family-specific**. The
     interval→generator topological upgrade (the character-uniqueness step, cf.
     `real_character_unique`) sits **above** the formalized layer and is documented in the
     module docstring.

---

## 3. Module dependency DAG

```
                      Interface  ✅ (DONE, green, 0 sorry, 0 custom axioms)
                     /    |    \        \            \
                    /     |     \        \            \
            Coalescence   |   Branches/Real   Branches/Quaternionic   RankTwo
                 |        |   Branches/Albert  Branches/Complex          |
                 v        |        \              |                      |
            DiagonalHom --+         \             v                      |
                 |                   \       Globalization               |
                 |                    \         /                        |
                 +---------> Master <--+-------+-------------------------+
```

Edges = `import`. **Parallelism:** the four `Branches/*` lanes and `RankTwo` consume
only `Interface` (they take a `StabilizerCoupling` / concrete `M₂(ℂ)` as given), so
they run **immediately and in parallel** with the `Coalescence → DiagonalHom` lane
that *produces* the `StabilizerCoupling`. `Globalization` needs `Branches/Complex`.
`Master` integrates everything and adds `prop:singular`.

Suggested file layout:
```
RadicalRelativity/MasterTheorem/
  Interface.lean          ✅ done
  Coalescence.lean
  DiagonalHom.lean
  Branches/Real.lean
  Branches/Quaternionic.lean
  Branches/Albert.lean
  Branches/Complex.lean
  Globalization.lean
  RankTwo.lean
  Master.lean
```
Add each to `RadicalRelativity.lean` root imports as it lands (house pattern).

---

## 4. Interface.lean — the delivered API (what lanes import)

`namespace MasterTheorem`, imports `LocalTomography` (for `EJAType`) +
`Mathlib.Analysis.InnerProductSpace.Basic` + `Mathlib.LinearAlgebra.FiniteDimensional.Defs`.

- `blockDim : EJAType → ℕ` (=1,2,4,8 for ℝ/ℂ/ℍ/𝕆) with `@[simp]` evaluators;
  `blockDim_complex_unique_dial`.
- `mulOp jordan x`, `OpCommute jordan x y` (= `[T_x,T_y]=0`), `OpCommute.symm`.
- **`ComparisonSetup J`** (comparison-map face). Fields = the audit ledger of §2,
  including the `Θ_jordan` field (former A1, cited vIR conclusion — no axiom).
  - Derived: `ComparisonSetup.jordanAuto` (`prop:theta`) projects the `Θ_jordan` field;
    `ComparisonSetup.frame_fixed` (`lem:frame-fix`, first half).
  - **Zero custom axioms** in Interface.lean (the former `axiom vanImhoffRoelands` is gone).
- **`StabilizerCoupling n Stab V`** (differential face). Fields `ρ, ρ_skew, dχ, T,
  coupling, rank_ge`. Single inner-product space `V` models every block `V_{ij}`
  (blocks are isomorphic as inner-product spaces; the `ρ_{ij}` differ — that is the
  `8_v/8_s/8_c` distinction).
  - Derived: `StabilizerCoupling.coalescence` (differential shadow of `lem:coalescence`:
    `r_i=r_j ⟹ ρ_{ij}(dχ r)=0`); `StabilizerCoupling.T_eq` (`T_{ij}=ρ_{ij}(dχ r)` when
    `r_i−r_j=1`); `StabilizerCoupling.faithful_kill` (`dχ=0 ⟹ T_{ij}=0` for `i≠j`).

Axiom-closure verified: **all Interface results rest on core axioms only** —
`jordanAuto` (now projecting the `Θ_jordan` field), `frame_fixed`, `coalescence`,
`T_eq`, `faithful_kill`. Interface.lean declares no custom axioms.

---

## 5. Per-module target lists (each tagged with its paper label)

### Coalescence.lean  ← Interface — **SHIPPED ✅**
- ~~`aone` : `a•1 = a` (`lem:aone`)~~ — **SKIPPED** (Packet A decision): not expressible
  on the `Θ`-interface (which exposes `Θ`, not the raw `L_a`); `Θ_unital` already gives
  everything the chain needs. Recorded in §2 disclosures.
- `simDiag_opCommute` (FK field/axiom): if `b ∈ J₂(q)` and `a = λq + a₀` with
  `a₀ ∈ J₀(q)`, then `a, b` operator-commute (simultaneous diagonalization). Carry as a
  `ComparisonSetup` field extension or a small FK axiom — ledger it.
- `coalescence_J2q` (`lem:coalescence`, general form): `a` scalar on `range(q)` ⟹
  `Θ_a|_{J₂(q)} = id`. From `simDiag_opCommute` + `Θ_fix`.
- `coalescence_block` (`lem:coalescence`, first statement): `r_i = r_j ⟹ Θ_{a(r)}`
  fixes `V_{ij}` pointwise.
- `block_preserved` (`lem:frame-fix`, second half): `Θ_{a(r)}` preserves each `V_{ij}`
  (Jordan-auto fixing all `p_i`). From `jordanAuto` + the Peirce eigenrelation.

### DiagonalHom.lean  ← Interface, Coalescence — **SHIPPED ✅ (A2 = proved `def` `lieHom_smooth`, no axiom; `DiagonalHomSetup.Stab` normed, `dχAdd_cont` continuity field)**
- `lieHom_smooth` (A2): a proved `def` (`AddMonoidHom.toRealLinearMap`, continuous-additive ⟹ ℝ-linear); `#print axioms lieHom_smooth` = core only.
- `chi_hom` (`lem:homomorphism`): `r ↦ Θ_{a(r)}` is a homomorphism on the orthant
  (from `Θ_cocycle`); `chi_extend` : the `χ̃(s−t)=Θ_sΘ_t⁻¹` extension to `(ℝⁿ,+)`
  (well-defined by cancellation + abelian image).
- `dChi_linear` (`lem:homomorphism`): real-linear `dχ : ℝⁿ → 𝔰𝔱𝔞𝔟(F)` via
  `lieHom_smooth`.
- `hyperplane_factorization` (`lem:homomorphism`): a real-linear `ℝⁿ → 𝔰𝔬(V_{ij})`
  vanishing on `{r_i=r_j}` equals `(r_i−r_j)·T_{ij}`. **Pure linear algebra — fully
  provable; anchor target.** Uses `Coalescence.coalescence_block`.
- `toStabilizerCoupling : ComparisonSetup J → StabilizerCoupling n Stab V` — assembles
  the differential face. This is the DiagonalHom → Branches bridge.

### Branches/Real.lean  ← Interface — **SHIPPED ✅**
- `prop:real`: on `Hₙ(ℝ)`, `blockDim = 1 ⟹ 𝔰𝔬(V_{ij}) = 0 ⟹ T_{ij} = 0`. From
  `ρ_skew` on a 1-dim `V` (skew ⟹ 0), or `Stab° = {1}`. Trivial; also covers `n = 2`.

### Branches/Quaternionic.lean  ← Interface — **SHIPPED ✅**
- `thm:quaternionic`: per-type coupling `ρ_{ij}(ξ)x = ξ_i x − x ξ_j`, `ξ ∈ (Im ℍ)ⁿ`.
  Prove: matching `r_l` (`l ≠ i,j`, exists as `n ≥ 3`) gives `a_{il}x = x a_{jl} ∀x`,
  so `a_{il}=a_{jl}` (set `x=1`) then `a_{il} ∈ Z(ℍ)∩Im ℍ = 0`; matching `r_i, r_j`
  gives `a_{ii}=a_{jj}=0`, so `T_{ij}=0`. Concrete `Quaternion ℝ` (Mathlib
  `Mathlib.Algebra.Quaternion`); `Z(ℍ)∩Im ℍ = {0}` is a finite computation.

### Branches/Albert.lean  ← Interface — **SHIPPED ✅ (A4 = `IsAlbertModel.block_injective` field, no axiom)**
- `IsAlbertModel.block_injective` field (A4, cited Yokota hypothesis) gives `∀ i j, Injective (ρ_{ij})`.
- `thm:albert`: `dχ = 0` from the third-index coalescence (`n = 3`, coefficient of
  `r_k`, `k ∉ {i,j}`: `ρ_{ij}(η_k) = 0`, injective ⟹ `η_k = 0`), then
  `StabilizerCoupling.faithful_kill`. **Nearly done via the interface** — this is the
  smallest branch.

### Branches/Complex.lean  ← Interface — **SHIPPED ✅**
- `thm:complex` (per-frame): torus coupling `ρ_{ij}(dχ r) = i(θ_i(r)−θ_j(r))` on
  `V_{ij} ≅ ℂ`, `θ_i(r)=Σ_l c_{il}r_l`. Prove: `θ_i−θ_j = (r_i−r_j)t_{ij}` (coalescence)
  and coefficient matching (`l ≠ i,j`) gives `c_{il}=c_{jl}=:γ_l`, so
  `t_{ij}=c_{ii}−γ_i =: t_F` one constant per frame; `Θ_{a(r)}` acts by
  `e^{i t_F(r_i−r_j)}`. Concrete ℝ linear algebra; may reuse `TwistNormalForm` scalar
  shadow. Outputs `t_F` for Globalization.

### Globalization.lean  ← Interface, Branches/Complex — **SHIPPED ✅ (green, 0 sorry, 0 custom axioms)**
- `real_character_unique` (A3 **proved as theorem**, not an axiom): open-interval
  equality of characters ⟹ exact equality, no `2π` ambiguity (via `HasDerivAt.cexp`).
- `ComplexGlobalizationData` (the Master-facing seam): fields `t`, `Adj`, `connected`,
  `overlap`. The `overlap` field is the `crossCoherence_single_scalar` content
  (adjacent frames' `U(1)` characters agree on an open interval of `x = logλ−logλ_k`,
  because `lem:coalescence` fixes `J₂(q)` pointwise so the same `Θ_a` computes both).
- `ComplexGlobalizationData.adjacent_eq` (`thm:complex`): open-interval overlap ⟹
  `t_F = t_{F'}` (via `real_character_unique`).
- `const_of_adjacent` + `connected_of_reducing` (`lem:frame-connectivity`): the paper's
  connectivity **induction is machine-checked**; the residual geometric 2-plane-rotation
  move is the isolated `hmove` hypothesis (never an axiom, never a `sorry`).
- `ComplexGlobalizationData.global_t` / `t_eq_globalT` (`thm:complex`, capstone): one
  global `t`; `Θ_a = Ad_{a^{it}}`, i.e. `a•b = a^{1/2+it} b a^{1/2−it}` on invertibles.

### RankTwo.lean  ← Interface (independent; reuse `SpinFactor`, `Selection.TwistIsotropy`) — **SHIPPED ✅ (green, core axioms only, 15 results; 3 upper-layer items scoped, §2)**
- `prop:n2-necessity`: on `M₂(ℂ)`, one real parameter `t_F` per spectral frame; no
  cross-frame constancy (no third projection).
- `thm:qubit-boundary` (i) block form of the `τ(F)` family; (ii) S1–S7 verification
  skeleton; (iii) frame-dependence / non-conjugacy (`τ` takes both `0` and `1`).
  Concrete `M₂(ℂ)` computation; corroborated by `verify_n2.py` V1–V10 (not a substitute).

### Master.lean  ← all Branches, Globalization, RankTwo — **SHIPPED (skeleton counterpart `master_chain`; `#print axioms master_chain` = core only — zero custom axioms)**
Plus the complex adapter **`Adapter.lean`** (← Globalization, Branches/Complex) — **SHIPPED ✅**: `perFrameTwist` (per-frame `t_F` from `complex_perFrame_rho`) + `complex_global_twist` (the complex-case entry point Master consumes; `overlap`/`connected` located).
- Add an S2-continuity hypothesis/field; prove `prop:singular` (invertible ⟹ all
  effects by `a_ε=(1−ε)a+εe → a`).
- `mthm:master`: case on `EJAType`; assemble `prop:real`, `thm:quaternionic`,
  `thm:albert` (Lüders) and `thm:complex` + `Globalization.global_t` (single `t`),
  extended by `prop:singular`. State the rank-two boundary as the `RankTwo` scope.

---

## 6. Work packets (paste-ready for builder prompts)

Common preamble for every packet:
> Work in `~/repos/research/lean` (Lean 4 v4.28.0 + Mathlib; `lake build` green at
> baseline). Read `RadicalRelativity/MasterTheorem/Interface.lean` (the API) and
> `RadicalRelativity/MasterTheorem/PLAN.md` §2/§5 (ledger + your target list). Read the
> paper `landing/papers/twist-normal-form/main.tex` and the cited note. House rules:
> `RadicalRelativity/CLAUDE.md` + `AUDIT.md`. **Do not modify `Interface.lean`,
> `Selection/*.lean`, or any existing asset** — import only. Zero `sorry`. New `axiom`s
> only from the PLAN ledger, each with its docstring citation; `#print axioms` on your
> capstone must show only ledger + core axioms. Verify `lake build
> RadicalRelativity.MasterTheorem.<YourModule>` green; add your module to the
> `RadicalRelativity.lean` root import list. Report the exact `lake` output tail, your
> `#print axioms <capstone>`, and any statement you had to weaken.

**Packet C — Branches/Albert. ✅ SHIPPED (green, core axioms only).**
> Done (as repaired): A4 is the `IsAlbertModel.block_injective` **field** (not an axiom) —
> `ρ_{ij}` injectivity as the cited Yokota hypothesis, with the false dimension gate
> removed. `thm:albert`: from injectivity + the third-index coalescence coefficient
> (`n=3`; `StabilizerCoupling.coalescence` + coefficient extraction on the `ℝ³` basis)
> conclude `dχ = 0`, then `StabilizerCoupling.faithful_kill` gives every off-diagonal
> `T_{ij}=0`. Capstone: `albert_luders` (core axioms only).

**Packet B — Branches/Quaternionic. ✅ SHIPPED (green, core axioms only).**
> Create `Branches/Quaternionic.lean`. Model `V := Quaternion ℝ`, `Stab := Fin n →
> Im ℍ`, `ρ_{ij}(ξ)x = ξ i * x − x * ξ j`. Prove `Z(ℍ) ∩ Im ℍ = 0` and `thm:quaternionic`
> (PLAN §5) using the `n≥3` third index. Capstone: `quaternionic_luders`.

**Packet R — Branches/Real + Branches/Complex(per-frame). ✅ SHIPPED (green, core axioms only).**
> Create `Branches/Real.lean` (`prop:real`: `blockDim=1 ⟹ ρ_skew ⟹ T=0`; trivial) and
> `Branches/Complex.lean` (`thm:complex` per-frame: torus coupling, coefficient matching
> to one `t_F` per frame; may reuse `TwistNormalForm` scalar shadow). Capstones
> `real_luders`, `complex_perFrame_tF`.

**Packet A — Coalescence + DiagonalHom (the producer lane). ✅ SHIPPED (green; A2 `lieHom_smooth` = proved `def`, no axiom; coupling PROVED via `hyperplane_factorization`).**
> Create `Coalescence.lean` then `DiagonalHom.lean` (PLAN §5). Coalescence proves
> `lem:coalescence` from `Θ_fix` + an FK simultaneous-diagonalization fact (ledger it as
> `simDiag_opCommute`). DiagonalHom proves `lieHom_smooth` (A2) as a `def`, and proves
> `chi_extend`, `dChi_linear`, the **`hyperplane_factorization`** linear-algebra anchor,
> and `toStabilizerCoupling`. Capstone: `toStabilizerCoupling`.

**Packet G — Globalization. ✅ SHIPPED (green, 0 sorry, 0 custom axioms).**
> Done: `real_character_unique` **proves A3** (no axiom); `ComplexGlobalizationData`
> seam with `global_t`/`t_eq_globalT` capstone; `connected_of_reducing` machine-checks
> the `lem:frame-connectivity` induction with the geometric move isolated as `hmove`.
> Remaining for `Master`: package `Branches/Complex.complex_perFrame_tF` into the
> `t`/`Adj`/`overlap` fields (thin adapter) and discharge `connected`.

**Packet Q — RankTwo. ✅ SHIPPED (green, core axioms only, 15 results; 3 upper-layer items scoped — §2).**
> Create `RankTwo.lean` (independent; reuse `SpinFactor`, `Selection.TwistIsotropy`).
> Prove `prop:n2-necessity` and `thm:qubit-boundary` (i)–(iii) on concrete `M₂(ℂ)`.
> Capstone: `qubit_boundary`.

**Packet M — Master. ✅ SHIPPED (green; capstone `master_chain` = skeleton counterpart of `mthm:master`, NOT the paper theorem — §1/§2). `#print axioms master_chain` = **core only** (`propext`, `Classical.choice`, `Quot.sound`); zero custom axioms.**
> Create `Master.lean` (needs all branches + Globalization + RankTwo). Add the S2
> field/hypothesis, prove `prop:singular`, assemble `mthm:master` by `EJAType` case.
> Capstone: `master_chain` (the **skeleton counterpart**, not the paper theorem).
> `#print axioms master_chain` = **core only** (`propext`, `Classical.choice`,
> `Quot.sound`) — zero custom axioms. Note: `#print axioms` omits every structure field,
> so it is a syntactic-closure figure, not a faithfulness certificate.

---

## 7. Design decisions the orchestrator should know

1. **Two-face interface.** `ComparisonSetup` (group/algebra) and `StabilizerCoupling`
   (differential) are separate structures bridged by `DiagonalHom.toStabilizerCoupling`.
   This is what lets the branch lanes and the producer lane run in parallel: branches
   consume a `StabilizerCoupling` abstractly; they never wait on the Lie-differential
   machinery.
2. **Single block space `V`.** All `V_{ij}` are one inner-product space `V`; only the
   representations `ρ_{ij}` differ. Faithful (blocks are isomorphic as inner-product
   spaces) and removes a `Type`-family instance-plumbing headache. Per-type lanes
   specialize `V := ℝ / ℂ / ℍ / ℝ⁸`.
3. **vdW props (and now the vIR conclusion) are structure fields, not axioms.** They are
   cited (van de Wetering's / van Imhoff–Roelands', not proved in this paper), so carrying
   them as `ComparisonSetup` hypotheses is correct AND avoids the false-global-axiom trap
   the audit found. **Caveat the reviewer must hear:** `#print axioms` OMITS every
   structure field, so a short axiom list is *not* a faithfulness certificate — the real
   assumption ledger is the field list (§2), which must be read directly.
4. **A1 (`vanImhoffRoelands`) is now the `Θ_jordan` field, not an axiom.** As a global
   axiom over the weak `ComparisonSetup` it was FALSE (asserted the source theorem for
   non-JB structures); scoping it to a per-instance field is the repair. A4 had the same
   disease and is likewise fixed (`IsAlbertModel.block_injective` field). **A2** was the
   last one — now a **proved `def`** (`lieHom_smooth` via `AddMonoidHom.toRealLinearMap`,
   continuity carried as the `dχAdd_cont` field). **All three former axioms are gone; the
   tree has zero global custom axioms.**
5. **`Θ_cocycle` carries the `r ≤ 0` orthant riders** (Prop 5.7 is about effects); the
   `ℝⁿ` extension is DiagonalHom's proved step. Not stronger than the source.
6. **Never axiomatize paper-proved facts** — in particular `lem:frame-connectivity`
   (`Globalization` machine-checks the induction skeleton `connected_of_reducing` and
   carries the residual geometric 2-plane-rotation move as an explicit hypothesis; see
   §2 deferred notes) and every chain lemma. **Residual `axiom`s: NONE** — A1 → `Θ_jordan`
   field, A2 → proved `def` `lieHom_smooth`, A3 → proved theorem `real_character_unique`,
   A4 → `IsAlbertModel.block_injective` field. **ZERO global custom axioms tree-wide.**
7. **Honest scope.** `mthm:master` is rank `≥ 3`; the rank-two boundary is a separate
   necessity-only statement. Simplicity/formal-reality/Jordan-identity are EJA data the
   chain does not consume; ledger frame conjugacy (FK IV.2.5) where the uniform-frame
   step uses it.
