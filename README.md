# Radical Relativity

A research program on self-modeling systems and the structure of quantum theory.

**Current result:** *Sequential Products on Euclidean Jordan Algebras:
Classification in Rank at Least Three and the Complex Qubit* (Paper A) — in
review at J. Phys. A. On a finite-dimensional simple Euclidean Jordan algebra of
rank ≥ 3, the seven standard sequential-product axioms force the Lüders product
`a·b = Q_√a b` on the real, quaternionic and exceptional types, and leave
exactly a one-real-parameter family `a^(1/2+it) b a^(1/2−it)` on the complex
type. Peirce-block-diagonality of the update is derived, not assumed.

**Read the direction carefully.** This does *not* select the complex type. It
shows the complex type is the **least rigid** one — rigidity is what the
non-complex types have. Any sentence of the form "rigidity picks out ℂ" reads
the theorem backwards. Paper A is pure mathematics: it says nothing about
observers or self-modeling, it imports the Euclidean Jordan setting rather than
deriving it, and it explicitly cedes the non-Jordan territory. It can price a
selector; it cannot supply one.

**What changed.** An earlier claim — that a finite-dimensional system admitting
a faithful self-model is *necessarily* governed by complex quantum mechanics
(Paper 5) — was **withdrawn on 2026-06-23** and desk-rejected without review by
JMP on 2026-07-11. It was refuted by this program's own witnesses: a real qubit,
a Niestegge ℓ⁴ system, and a Vinberg cone. The two advertised selecting steps,
reciprocity and local tomography, are irreducible **imports**, not theorems of
self-modeling; a later audit found a third and larger one upstream of both. The
withdrawn paper is kept in `papers/` so the record shows what was claimed.

Website: [ehrlich.dev/papers](https://ehrlich.dev/papers/)

## Papers

| # | Title | Status | PDF |
|---|-------|--------|-----|
| A | Sequential Products on Euclidean Jordan Algebras | in review at J. Phys. A | [pdf](https://ehrlich.dev/papers/twist-normal-form/main.pdf) |
| 5 | Quantum Mechanics from Self-Modeling | **withdrawn** | [pdf](papers/qm-from-self-modeling/main.pdf) |
| 4 | Falsification of the Born-Fisher-Experiential Conjecture | negative result | [pdf](papers/born-fisher-2026.pdf) |
| 3 | Lipschitz Stability of the Experiential Density Functional | stands alone | [pdf](papers/lipschitz-stability.pdf) |
| 2 | Exponential Suppression of Transient-Basin Contributions (Theorem A) | stands alone | [pdf](papers/theorem-a-proof.pdf) |
| 2a | Theorem A: Lemma Assembly | stands alone | [pdf](papers/theorem-a-lemmas.pdf) |
| 1 | Experiential Measure on the Structure Space of Self-Modeling Systems | needs re-scoping | [pdf](papers/h_3_O-measure-2026.pdf) |

Papers 2, 2a and 3 are Markov-chain and information-theory results with no
dependence on the quantum chain; they are unaffected by the withdrawal. Paper 4
is a falsification of the author's own conjecture and likewise stands.

## The two Lean developments are not the same thing

This repository contains **two** independent Lean 4 trees. Do not read them as
one.

- **`twist-normal-form-lean/`** — Paper A's tree. Zero `sorry`; the advertised
  results close over the three standard Lean core axioms only. It is a
  **dependency skeleton**, not a machine-check of the classification theorem —
  the capstone does not state the paper theorem. This is disclosed in that
  directory's own README and in the paper's supplementary material.

- **`lean/`** — the old `RadicalRelativity` tree, belonging to the withdrawn
  Paper 5. **It is unsound and should not be relied on for anything.** Its
  `CompressionSystem` structure is uninhabited (Alfsen–Shultz compressions exist
  for *projective units*, but the structure quantifies over *all effects*, and
  `½·𝟙` is an effect), while an axiom asserts an inhabitant of it. `False` is
  therefore derivable — confirmed in the kernel on 2026-07-26, with the axiom
  trace isolating `has_compression` as the sole cause. Every theorem in that
  tree taking a `CompressionSystem` argument is vacuous. Retained for the record
  pending archival.

## Repository structure

```
papers/                  TeX source and compiled PDFs
twist-normal-form-lean/  Paper A's Lean 4 tree (sound; a dependency skeleton)
lean/                    Old Paper 5 Lean tree — UNSOUND, see above
derivations/             Worked steps of the withdrawn chain. Several are
                         precisely the steps later shown to be imports rather
                         than derivations. Historical.
verification/            SymPy test suites for the withdrawn chain
experiments/             Self-modeling constants experiments — definitive null
                         at 256-dim scale; algebraic structure does not appear
                         in toy network weight matrices
```

## Building

Papers compile with [tectonic](https://tectonic-typesetting.github.io/):

```bash
cd papers/qm-from-self-modeling
tectonic main.tex
```

## Status

Paper A is in review and has not been peer-reviewed. Everything else here has
not been peer-reviewed either. The program's method is adversarial review by
independent frontier-LLM sessions, and it works in the sense that matters: the
withdrawal above, the Lean unsoundness, and the import-not-theorem finding were
all produced by it, against the author's interest. If you have the background to
evaluate Paper A and are willing to look, I would genuinely appreciate it. The
strongest objections found so far are documented in the paper's closing section.

## Produced with

[Get Physics Done](https://github.com/psi-oss/get-physics-done)
