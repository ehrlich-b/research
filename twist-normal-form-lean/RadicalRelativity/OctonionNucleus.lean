/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
-/
import RadicalRelativity.Octonions

-- The 56 coordinate expansions of the seven associators are large terms.
set_option maxHeartbeats 4000000

/-!
# The nucleus of the octonions is `ℝ · 1`

`nucleus 𝕆 = ℝ` is ingredient **(N)** of `ALBERT-KERNEL-MEMO.md` (2026-08-04) in the
`twist-normal-form-lean` project: the one computational input the memo's "unit-slot
argument" needs in order to discharge `IsAlbertModel.block_injective` without Spin(8),
triality, or any rank certificate.

The proof is the finite Cayley-table check the memo describes. For each of the seven Fano
triples `(i, j, k)` the associator `[e_i, e_j, c]` is expanded in coordinates; each
`c.coords m` outside the quaternion subalgebra `span{e_0, e_i, e_j, e_k}` picks up a
relation `c.coords m = -c.coords m`. Three triples already cover all seven imaginary
indices — `(1,2,4)` kills `3,5,6,7`, `(2,3,5)` kills `1,4,6,7`, `(3,4,6)` kills `1,2,5,7` —
and all seven are used here for margin.

`decide` handles the `Fin 8` guards; no `native_decide` (the Paper A axiom census rejects
it, and this file is intended to port into that tree alongside `Octonions.lean`).

## Provenance

Written 2026-08-08 to test the memo's "weeks, not blocked" estimate for the `H₃(𝕆)` row,
after the claim "octonions exist in no prover" was found to be false of this project. See
`twist-normal-form-lean/LEDGER.md`, the `H₃(𝕆)` row correction.
-/
namespace Octonion

theorem coord_eq {a b : Octonion} (hab : a = b) (k : Fin 8) : a.coords k = b.coords k := by
  rw [hab]

theorem tbl_1_2 : mul (basisVec 1) (basisVec 2) = basisVec 4 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

theorem tbl_2_3 : mul (basisVec 2) (basisVec 3) = basisVec 5 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

theorem tbl_3_4 : mul (basisVec 3) (basisVec 4) = basisVec 6 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

theorem tbl_4_5 : mul (basisVec 4) (basisVec 5) = basisVec 7 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

theorem tbl_5_6 : mul (basisVec 5) (basisVec 6) = basisVec 1 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

theorem tbl_6_7 : mul (basisVec 6) (basisVec 7) = basisVec 2 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

theorem tbl_7_1 : mul (basisVec 7) (basisVec 1) = basisVec 3 := by
  ext m; fin_cases m <;> simp [mul, basisVec]

/-- Memo ingredient (N): `nucleus 𝕆 = ℝ·1`. -/
theorem nucleus_real (c : Octonion)
    (h : ∀ x y : Octonion, mul (mul x y) c = mul x (mul y c)) :
    c.coords 1 = 0 ∧ c.coords 2 = 0 ∧ c.coords 3 = 0 ∧ c.coords 4 = 0 ∧
    c.coords 5 = 0 ∧ c.coords 6 = 0 ∧ c.coords 7 = 0 := by
  have H12 := h (basisVec 1) (basisVec 2)
  rw [tbl_1_2] at H12
  have H23 := h (basisVec 2) (basisVec 3)
  rw [tbl_2_3] at H23
  have H34 := h (basisVec 3) (basisVec 4)
  rw [tbl_3_4] at H34
  have H45 := h (basisVec 4) (basisVec 5)
  rw [tbl_4_5] at H45
  have H56 := h (basisVec 5) (basisVec 6)
  rw [tbl_5_6] at H56
  have H67 := h (basisVec 6) (basisVec 7)
  rw [tbl_6_7] at H67
  have H71 := h (basisVec 7) (basisVec 1)
  rw [tbl_7_1] at H71
  have u0 := coord_eq H12 0
  have u1 := coord_eq H12 1
  have u2 := coord_eq H12 2
  have u3 := coord_eq H12 3
  have u4 := coord_eq H12 4
  have u5 := coord_eq H12 5
  have u6 := coord_eq H12 6
  have u7 := coord_eq H12 7
  have v0 := coord_eq H23 0
  have v1 := coord_eq H23 1
  have v2 := coord_eq H23 2
  have v3 := coord_eq H23 3
  have v4 := coord_eq H23 4
  have v5 := coord_eq H23 5
  have v6 := coord_eq H23 6
  have v7 := coord_eq H23 7
  have w0 := coord_eq H34 0
  have w1 := coord_eq H34 1
  have w2 := coord_eq H34 2
  have w3 := coord_eq H34 3
  have w4 := coord_eq H34 4
  have w5 := coord_eq H34 5
  have w6 := coord_eq H34 6
  have w7 := coord_eq H34 7
  have x0 := coord_eq H45 0
  have x1 := coord_eq H45 1
  have x2 := coord_eq H45 2
  have x3 := coord_eq H45 3
  have x4 := coord_eq H45 4
  have x5 := coord_eq H45 5
  have x6 := coord_eq H45 6
  have x7 := coord_eq H45 7
  have y0 := coord_eq H56 0
  have y1 := coord_eq H56 1
  have y2 := coord_eq H56 2
  have y3 := coord_eq H56 3
  have y4 := coord_eq H56 4
  have y5 := coord_eq H56 5
  have y6 := coord_eq H56 6
  have y7 := coord_eq H56 7
  have z0 := coord_eq H67 0
  have z1 := coord_eq H67 1
  have z2 := coord_eq H67 2
  have z3 := coord_eq H67 3
  have z4 := coord_eq H67 4
  have z5 := coord_eq H67 5
  have z6 := coord_eq H67 6
  have z7 := coord_eq H67 7
  have t0 := coord_eq H71 0
  have t1 := coord_eq H71 1
  have t2 := coord_eq H71 2
  have t3 := coord_eq H71 3
  have t4 := coord_eq H71 4
  have t5 := coord_eq H71 5
  have t6 := coord_eq H71 6
  have t7 := coord_eq H71 7
  simp only [mul, basisVec, Fin.isValue] at u0 u1 u2 u3 u4 u5 u6 u7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at u0 u1 u2 u3 u4 u5 u6 u7
  simp only [mul, basisVec, Fin.isValue] at v0 v1 v2 v3 v4 v5 v6 v7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at v0 v1 v2 v3 v4 v5 v6 v7
  simp only [mul, basisVec, Fin.isValue] at w0 w1 w2 w3 w4 w5 w6 w7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at w0 w1 w2 w3 w4 w5 w6 w7
  simp only [mul, basisVec, Fin.isValue] at x0 x1 x2 x3 x4 x5 x6 x7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at x0 x1 x2 x3 x4 x5 x6 x7
  simp only [mul, basisVec, Fin.isValue] at y0 y1 y2 y3 y4 y5 y6 y7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at y0 y1 y2 y3 y4 y5 y6 y7
  simp only [mul, basisVec, Fin.isValue] at z0 z1 z2 z3 z4 z5 z6 z7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at z0 z1 z2 z3 z4 z5 z6 z7
  simp only [mul, basisVec, Fin.isValue] at t0 t1 t2 t3 t4 t5 t6 t7
  simp +decide only [if_true, if_false, add_zero, zero_add, zero_sub,
    sub_zero, zero_mul, one_mul, sub_neg_eq_add, sub_self] at t0 t1 t2 t3 t4 t5 t6 t7
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals linarith

end Octonion
