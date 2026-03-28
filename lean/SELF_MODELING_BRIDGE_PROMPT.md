# Lean Agent Prompt: Fill SelfModelingBridge.lean

## Context

You are working on the Radical Relativity Lean 4 formalization at `~/repos/research/lean/`.
Package: RadicalRelativity. Build: `lake build`. Mathlib v4.28.0.

Paper 5 ("QM from Self-Modeling") claims: self-modeling forces complex QM.
The existing Lean code proves: S1-S7 axioms → Jordan → C* → QM.
The GAP: the construction from self-modeling to S1-S7 was only in prose.

`RadicalRelativity/SelfModelingBridge.lean` was written to close this gap.
It currently has:
- `SelfModelingSystem` structure (DEFINED, complete)
- 3 axioms (STATED, honest, citing published theorems)
- `self_modeling_gives_sequential_product` theorem (PLACEHOLDER, needs filling)
- `mixingFunction` definition (DEFINED)

Your job: replace the placeholder theorem with the actual construction that
builds a `SequentialProduct V` instance from a `SelfModelingSystem V`, using
the provided axioms.

## What the paper says (the spec)

Paper 5, Sections 3-4 construct the sequential product in four steps:

### Step 1: Sharp product (Section 3.1)

For sharp effects (projective units / idempotents) p, q:
```
sp(p, q) = C_p(q)
```
where C_p is the Alfsen-Shultz compression. This is already formalized in
`Compression.lean` as `compress p a = p & a`.

### Step 2: Naive spectral extension (Section 3.2)

For general effect a = Σ λᵢ pᵢ (spectral decomposition):
```
sp_naive(a, b) = Σᵢ λᵢ · C_{pᵢ}(b)
```
This FAILS S3 (unitality) because:
```
sp_naive(1, b) = Σᵢ C_{pᵢ}(b) = pinch(b) ≠ b
```
The pinching map annihilates Peirce 1-space components.

### Step 3: Corrected product (Section 3.3-3.4)

The corrected product adds Peirce 1-space terms:
```
sp(a, b) = Σᵢ λᵢ · C_{pᵢ}(b) + Σᵢ<ⱼ f(λᵢ,λⱼ) · P₁ᵢⱼ(b)
```
where P₁ᵢⱼ is the Peirce (i,j) projection onto V₁(pᵢ,pⱼ).

The mixing function f is constrained by:
- Positivity bound: |f(λᵢ,λⱼ)| ≤ √(λᵢ λⱼ)  (Proposition 4.1)
- Multiplicative functional equation from S5: f(α₁,α₂)·f(β₁,β₂) = f(α₁β₁,α₂β₂)
- Boundary conditions: f(1,λ) = λ, f(0,λ) = 0

### Step 4: Maximal coherence (Section 3.4, Proposition 4.2)

The faithful self-modeling constraint forces:
```
f(λᵢ, λⱼ) = √(λᵢ · λⱼ)
```
This is the UNIQUE solution satisfying the multiplicative equation + bounds.
The proof uses the multiplicative Cauchy theorem. The axiom
`mixing_function_forced` in the file encodes this.

### The final formula (equation 3.8 in the paper):

```
sp(a, b) = Σᵢ λᵢ · C_{pᵢ}(b) + Σᵢ<ⱼ √(λᵢ·λⱼ) · P₁ᵢⱼ(b)
```

## What you need to build

### Option A: Full construction (preferred if feasible)

1. Define `selfModelingSP` that takes a `SelfModelingSystem V` and a
   `SpectralDecomp V` for the left argument, and computes:
   ```
   selfModelingSP sd b = Σᵢ eigenval(i) • C_{proj(i)}(b)
                        + Σᵢ<ⱼ √(eigenval(i)·eigenval(j)) • P₁ᵢⱼ(b)
   ```

   Note: `SpectralDecomp` is already defined in `Compression.lean` with
   fields `n`, `proj`, `eigenval`, `proj_idempotent`, `eigenval_bound`,
   `proj_orthogonal`, `proj_sum_unit`.

   `peirceOneProj` is already defined in `PeirceDecomp.lean` as
   `peirceOneProj p q x = x - C[p] x - C[q] x`.

2. Build a `SequentialProduct V` instance using `selfModelingSP`.

3. Prove each axiom field:
   - `sp_add_right`: Linearity of compression + Peirce projection.
     Both C_p and P₁ᵢⱼ are linear maps (sums of linear maps).
     Should follow from `sp_sub_right_general`-like reasoning.

   - `sp_mono_right`: Monotonicity of compression (already proved in
     Compression.lean: `compress_effect`). Need monotonicity of √ scaling.

   - `sp_unit_left`: When a = 1, all eigenvalues = 1, so
     sp(1,b) = Σ C_{pᵢ}(b) + Σ √(1·1) P₁ᵢⱼ(b) = pinch(b) + P₁(b) = b.
     This is the KEY step that the naive extension fails and the corrected
     one succeeds. Use `peirce_decomp` from PeirceDecomp.lean.

   - `sp_zero_symm`: Use `facial_orthogonality` axiom. If sp(a,b) = 0,
     then all compression terms and Peirce terms vanish. The facial
     orthogonality axiom gives the reverse direction.

   - `sp_assoc_of_compatible`: For compatible effects (commuting spectral
     decompositions), the Peirce 1-space terms factor multiplicatively.
     Use `peirce_one_space_invariance` axiom.

   - `compatible_ortho`, `compatible_add`, `compatible_sp`: Peirce
     structure preservation under complement/sum/product. Use
     `peirce_one_space_invariance`.

   - `sp_effect`: Need sp(a,b) ∈ [0,1] when a,b ∈ [0,1]. The positivity
     bound √(λᵢλⱼ) ≤ √(λᵢ·λⱼ) ensures this. Use `compress_effect`
     for the compression terms.

   - `sp_sub_right_general`: Linearity of the construction.

### Option B: Axiomatize the construction, prove the connection (if A is too hard)

If the full construction is too complex, take the approach:

1. Add an axiom `self_modeling_gives_sp` that says: given a
   `SelfModelingSystem V`, there exists a `SequentialProduct V` instance.
   Label it honestly: "Paper 5 Sections 3-4, construction verified by
   concrete models (M2CInstance, SpinFactor)."

2. Prove a theorem connecting `SelfModelingSystem` to the sequential
   product properties that CAN be proved:
   - The sharp product sp(p,b) = C_p(b) for idempotent p
   - Unitality sp(1,b) = b from the corrected formula
   - The mixing function is √(λᵢλⱼ)

This is less satisfying but still valuable: it makes the self-modeling
premise EXPLICIT in the formalization rather than invisible.

### Option C: Incremental (pragmatic)

Fill the placeholder with `sorry` for now but restructure it as:

```lean
instance selfModelingSP (V : Type*) [OrderUnitSpace V]
    (sm : SelfModelingSystem V) : SequentialProduct V where
  sp := sorry  -- define using spectral extension + mixing function
  sp_add_right := sorry  -- linearity of compression + Peirce projection
  sp_mono_right := sorry  -- monotonicity of compression + √ scaling
  sp_unit_left := sorry  -- KEY: corrected product restores Peirce 1-space
  sp_zero_symm := sorry  -- from facial_orthogonality axiom
  sp_assoc_of_compatible := sorry  -- from peirce_one_space_invariance
  compatible_ortho := sorry
  compatible_add := sorry
  compatible_sp := sorry
  sp_effect := sorry  -- positivity bound
  sp_sub_right_general := sorry  -- linearity
```

Then fill sorry's one at a time, starting with `sp` (the definition)
and `sp_unit_left` (the most important: proves the construction works).

## Key files to read

- `OrderUnitSpace.lean` — base types: `IsEffect`, `ousUnit`, `IsSharp`
- `SequentialProduct.lean` — the target: `SequentialProduct` class with S1-S7
- `Compression.lean` — `compress`, `SpectralDecomp`, `SharpOrthogonal`
- `PeirceDecomp.lean` — `PeirceTwo`, `PeirceOne`, `PeirceZero`, `peirceOneProj`, `peirce_decomp`
- `SpectralTheorem.lean` — spectral structure lemmas
- `M2CInstance.lean` — concrete model (diagonal 2x2) satisfying all axioms
- `SpinFactor.lean` — concrete model (Bloch sphere) satisfying all axioms
- `SelfModelingBridge.lean` — THIS FILE, your target

## Build and verify

```bash
cd ~/repos/research/lean && lake build
```

Currently builds clean (0 errors, 4 linter warnings in GaugeGroup/Chirality).
Your changes must maintain this. If you add sorry's, that's fine (they're
warnings, not errors). If you add axioms, label them honestly.

## What success looks like

**Minimum viable:** Option C (sorry-based skeleton that compiles, shows the
structure, can be filled incrementally).

**Good:** Option B (axiomatized construction with some proved connections).

**Great:** Option A (full construction with S1-S3 proved, S4-S7 from axioms).

**The key deliverable either way:** The theorem statement
`self_modeling_gives_sequential_product` should have type signature:
```lean
instance selfModelingSP (V : Type*) [OrderUnitSpace V] [FiniteDimensional ℝ V]
    (sm : SelfModelingSystem V) : SequentialProduct V
```
or equivalent, showing that a self-modeling system produces a sequential
product space. This is the bridge the formalization is missing.

## Do NOT modify

- Any file the lean bot is currently working on (UniverseAlgebra.lean,
  ExperientialMeasure.lean, SelfModelingLattice.lean, AreaLaw.lean, F4.lean)
- The existing axioms in JordanStructure.lean, LocalTomography.lean, CStarBridge.lean
- The concrete instances in M2CInstance.lean, SpinFactor.lean

## Priority

Start with Option C (get it compiling with sorry's), then upgrade toward
Option A by filling sorry's. The sp definition and sp_unit_left are the
two most important pieces - if you only fill two sorry's, fill those.
