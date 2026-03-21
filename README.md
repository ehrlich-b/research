# Radical Relativity

Research program deriving quantum mechanics from self-modeling.

**Main result:** A finite-dimensional system admitting a faithful self-model is necessarily governed by complex quantum mechanics. The complex field, C\*-involution, and local tomography are all derived from a single operational premise plus four structural assumptions.

Website: [ehrlich.dev/papers](https://ehrlich.dev/papers/)

## Papers

| # | Title | PDF |
|---|-------|-----|
| 5 | Quantum Mechanics from Self-Modeling | [pdf](papers/qm-from-self-modeling/main.pdf) |
| 4 | Falsification of the Born-Fisher-Experiential Conjecture | [pdf](papers/born-fisher-2026.pdf) |
| 3 | Lipschitz Stability of the Experiential Density Functional | [pdf](papers/lipschitz-stability.pdf) |
| 2 | Exponential Suppression of Transient-Basin Contributions (Theorem A) | [pdf](papers/theorem-a-proof.pdf) |
| 2a | Theorem A: Lemma Assembly | [pdf](papers/theorem-a-lemmas.pdf) |
| 1 | Experiential Measure on the Structure Space of Self-Modeling Systems | [pdf](papers/experiential-measure-2026.pdf) |

Paper 5 is the flagship result. Papers 1-4 support it.

## Repository structure

```
papers/              TeX source and compiled PDFs for all papers
derivations/         Full proofs of the derivation chain (S1-S7, local
                     tomography, type exclusion, maximal coherence,
                     decomposition independence, general positivity)
verification/        SymPy test suites (844+ sequential product tests,
                     658+ composite tests)
experiments/         Self-modeling constants experiments (algebraic
                     structure detection in neural network weight matrices)
```

## Building

Paper 5 compiles with [tectonic](https://tectonic-typesetting.github.io/):

```bash
cd papers/qm-from-self-modeling
tectonic main.tex
```

## Status

This work has not been peer-reviewed. It has been stress-tested through independent adversarial review sessions using frontier LLMs. Real issues were identified and fixed. The proofs are numerically verified. If you have the background to evaluate this and are willing to look, we would genuinely appreciate it. The strongest objections we have found are documented in Paper 5's discussion section.

## Produced with

[Get Physics Done](https://github.com/psi-oss/get-physics-done)
