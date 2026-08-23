# h3O Jordan identity - working notes (attempt 4)

Target: `instance : IsCommJordan h3O`, whose single Mathlib field is
`lmul_comm_rmul_rmul : a * b * (a * a) = a * (b * (a * a))`
(`Mathlib/Algebra/Jordan/Basic.lean`, class requires `[CommMagma A]`).
On the bundled product that reads
`jordanMul (jordanMul a b) (jordanMul a a) = jordanMul a (jordanMul b (jordanMul a a))`.

## State of the tree (verified by declaration list, 2026-08-23)

- `Albert/Carrier.lean`: `Octonion` re-export + `octIp`, `octIp_eq_re`, `octIp_conj_cyc`,
  `octIp_conj_cyc'`, `re_three_cyc`; `h3O` structure, `ext_six`, module structure, finrank 27.
- `Albert/Mul.lean`: `jordanMul` + six `rfl` projections, `jordanMul_comm`, `jordanMul_one_left`,
  bilinearity, `jordanBilinO`. NO `Mul h3O` instance (deliberate: diamond avoidance).
- `Albert/Inner.lean`: `traceForm`, `traceForm_jordanMul_assoc`, `hassoc`, inner product space.
- `Octonions.lean`: `left_alternative`, `right_alternative`, `moufang_left/right/middle`,
  `conj_mul`, `conj_conj`, `mul_conj`, `norm_multiplicative`, `mul_eq_zero_iff`.
  Also three `axiom`s (hurwitz_classification, aut_octonions_eq_G2,
  unit_imag_sphere_eq_G2_mod_SU3) - unused by the Albert layer; `#print axioms` must confirm.
- `RadicalRelativity/Albert.lean` (older expository, separate `h3O`): `jordan_identity` is a
  `sorry`. Not the target and not imported by `Albert/`.

## Layout being used

`a = [[a1, x3*, x2], [x3, a2, x1*], [x2*, x1, a3]]`, `a.diag k = a_{k+1}`, `a.off k = x_{k+1}`.
Hand-checked against the matrix product `1/2(ab+ba)`: both the diagonal
(`a_k b_k + <x_i,y_i> + <x_j,y_j>`) and the off-diagonal
(`1/2(a_i+a_j) y_k + 1/2(b_i+b_j) x_k + 1/2(x_i* y_j* + y_i* x_j*)`, (k,i,j) cyclic)
match `jordanMul` term for term. So the normalization is NOT merely `hassoc`-cross-validated.

## Refuted routes (do not re-run)

1. Coordinate bash / `ring` on the whole identity: prior attempt died at 6.4M heartbeats
   (6m48s) on the *diagonal* branch of the weaker degree-4 power-associativity probe.
2. `native_decide`, `decide`: banned / impossible over R.
3. Basis-triple enumeration after full polarization: 27 basis vectors gives
   C(29,3) * 27 = 98,658 goals. Not feasible.

## Intended route

Structured, component-wise, all 12 variables (6 real, 6 octonionic) symbolic, with:
- a cyclic automorphism `sigma : (a1,a2,a3;x1,x2,x3) -> (a3,a1,a2;x3,x1,x2)` proved to commute
  with `jordanMul` (cheap, `rfl`-adjacent), cutting six components down to two;
- octonion lemmas: alternativity, Moufang, `octIp_conj_cyc`, `x (x* y) = N(x) y`.

