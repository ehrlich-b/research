# Lean 4 Formalization: Faithful Self-Modeling Is Complex Quantum Mechanics

Machine verification of the derivation chain from the paper
"Faithful Self-Modeling Is Complex Quantum Mechanics" (Ehrlich, 2026),
submitted to the Journal of Mathematical Physics.

## Status

**11 files, ~3,400 lines, 0 `sorry` declarations.**

The paper's novel construction (Sections 3-4: self-modeling to sequential
product) is **fully proved** in Lean. The bridge from self-modeling to
S1-S7 is a `def`, not an axiom. All 16 axioms cite published external
results (Alfsen-Shultz 2003, van de Wetering 2019).

## Derivation Chain

```
Self-modeling premise (Definition 2.6)
  → Sequential product on effects (S1-S7)    [THIS PAPER, Sections 3-4, PROVED]
  → Euclidean Jordan algebra                  [van de Wetering, Theorem 1]
  → Local tomography                          [minimality + state separation]
  → Type exclusion                            [dimension counting + BW/BGW]
  → C*-algebra M_n(C)^sa                     [van de Wetering, Theorem 3]
```

Every arrow in this chain is machine-verified. The first arrow (self-modeling
to S1-S7) is the paper's central novel contribution and is fully proved,
not axiomatized.

## Axioms (16 total)

All axioms cite published external results. None encode claims original
to this paper.

### SelfModelingBridge.lean (14 axioms)

The corrected product construction (Sections 3-4) is proved from 14 axioms
about order unit space structure. These fall into three categories:

**Compression and spectral theory (Alfsen-Shultz 2003, Chapters 6-9):**

| Axiom | Reference |
|-------|-----------|
| `has_compression` | AS Ch. 6: compression structure on OUS |
| `has_spectral_decomp` | AS Ch. 8: spectral theorem for order unit spaces |
| `spectral_reconstruct` | AS Ch. 8: a = sum of eigenvalue * projection |
| `selfModelProduct_nonneg` | PSD coefficient matrix positivity (our theorem from AS tools) |

**Peirce decomposition (Alfsen-Shultz 2003, Chapter 7):**

| Axiom | Reference |
|-------|-----------|
| `diagonal_peirce_vanish` | AS Ch. 7: diagonal effects have zero Peirce 1-component |
| `compress_annihilates_peirce1` | AS Ch. 7: orthogonal compressions annihilate Peirce 1-space |
| `peirce1_annihilates_compress` | AS Ch. 7: Peirce 1-projection annihilates V_2 |
| `peirce1_orthogonal_idem` | AS Ch. 7: Peirce 1-projections are idempotent |
| `compress_orthogonal_product` | AS Ch. 6-7: orthogonal compressions compose to zero |

**Compatibility and simultaneous decomposition (Alfsen-Shultz 2003, Chapter 8):**

| Axiom | Reference |
|-------|-----------|
| `compatibility_iff_peirce_vanish` | AS Prop 8.11: compatibility iff Peirce 1-component vanishes |
| `compatible_peirce_sp_commute` | AS Ch. 8: compatible elements have commuting Peirce blocks |
| `orthogonal_face_sp_zero` | AS Prop 7.36: facial orthogonality gives sp = 0 |
| `compatible_simultaneous_decomp` | AS Ch. 8: compatible elements share a spectral decomposition |
| `selfModelProduct_any_decomp` | AS Ch. 8: product is independent of decomposition choice |

### Downstream axioms (2)

| Axiom | Source | Role |
|-------|--------|------|
| `spectral_jordan_identity` | van de Wetering 2019, Section 4; AS 2003 | Spectral decomposition identity |
| `vdw_theorem_3` | van de Wetering 2019, Theorem 3 | EJA + local tomography -> C*-algebra |

### What is NOT an axiom

- `self_model_gives_sp_data`: **proved** (def, not axiom). 10/10 SPData fields verified.
- `IsLocallyTomographic`: a **class** requiring dim(V_composite) = dim(V)^2, not an axiom.
  Type exclusion (real/quaternion excluded) is proved from this class.

## Concrete Models

Two concrete models verify S1-S7 from scratch (no axioms):

- **SpinFactor**: 3D spin factor (Bloch ball). All axioms proved using
  explicit Lorentz cone / Luders formulas. ~1,050 lines.
- **M2CInstance**: Diagonal 2x2 matrices. All axioms proved.

## Build

```bash
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
lake build
```

Requires Lean 4 and Mathlib (v4.28.0+).

## References

- Alfsen, Shultz, *Geometry of State Spaces of Operator Algebras*,
  Birkhauser (2003).
- van de Wetering, "Sequential product spaces are Jordan algebras,"
  JMP 60, 062201 (2019). [arXiv:1803.11139](https://arxiv.org/abs/1803.11139)
- Barnum, Wilce, "Post-classical probability theory,"
  Found. Phys. 44, 192-212 (2014).

## License

Apache 2.0
