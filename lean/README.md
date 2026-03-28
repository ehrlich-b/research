# Lean 4 Formalization: Faithful Self-Modeling Is Complex Quantum Mechanics

Machine verification of the derivation chain from the paper
"Faithful Self-Modeling Is Complex Quantum Mechanics" (Ehrlich, 2026),
submitted to the Journal of Mathematical Physics.

## Status

**11 files, ~2,400 lines, 0 `sorry` declarations.**

## Derivation Chain

```
Self-modeling premise (Definition 2.6)
  → Sequential product on effects (S1-S7)
  → Euclidean Jordan algebra          [van de Wetering, Theorem 1]
  → Local tomography                  [minimality + state separation]
  → Type exclusion                    [dimension counting + BW/BGW]
  → C*-algebra M_n(C)^sa             [van de Wetering, Theorem 3]
```

## Axioms

The formalization uses 4 axioms. Three correspond to published theorems
cited in the paper; one bridges the novel construction of Sections 3-4
to the formalized framework.

| Axiom | Source | Role |
|-------|--------|------|
| `self_model_gives_sp_data` | This paper, Sections 3-4 | Self-modeling → sequential product |
| `spectral_jordan_identity` | van de Wetering 2019, §4; Alfsen-Shultz 2003 | Spectral decomposition identity |
| `IsLocallyTomographic` | This paper, Theorem 5.8 | Minimality → dim(V_BM) = d² |
| `vdw_theorem_3` | van de Wetering 2019, Theorem 3 | EJA + LT → C*-algebra |

## Concrete Models

Two concrete models verify S1-S7 from scratch (no axioms):

- **SpinFactor**: 3D spin factor (Bloch ball). All axioms proved using
  explicit Lorentz cone / Lüders formulas. ~1,050 lines.
- **M2CInstance**: Diagonal 2×2 matrices. All axioms proved.

## Build

```bash
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
lake build
```

Requires Lean 4 and Mathlib (v4.28.0+).

## References

- van de Wetering, "Sequential product spaces are Jordan algebras,"
  JMP 60, 062201 (2019). [arXiv:1803.11139](https://arxiv.org/abs/1803.11139)
- Alfsen, Shultz, *Geometry of State Spaces of Operator Algebras*,
  Birkhäuser (2003).
- Barnum, Wilce, "Post-classical probability theory,"
  Found. Phys. 44, 192-212 (2014).
- Barnum, Graydon, Wilce, "Composites and categories of Euclidean
  Jordan algebras," Quantum 4, 359 (2020).

## License

Apache 2.0
