/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Connection
import RadicalRelativity.Composition.Defs

set_option linter.style.longLine false

/-!
# The coordinate algebra of a connected Jordan frame

Placeholder docstring; rewritten at the end of the build.
-/

noncomputable section

namespace RadicalRelativity.EJA

open EuclideanJordanAlgebra

variable {J : Type*} [NormedAddCommGroup J] [InnerProductSpace ℝ J] [EuclideanJordanAlgebra J]
variable {n : ℕ}

/-! ## The coordinate product

★ **Why a third index is needed.**  `V_{ij} ∘ V_{ij}` lands in `ℝpᵢ + ℝpⱼ`, never back in
`V_{ij}`, so the Jordan product does not restrict to a product on a block.  Faraut–Korányi's
device is to route through a third index: send `x ∈ V_{ij}` to `V_{ik}` and `y ∈ V_{ij}` to
`V_{kj}` using connectors, multiply *there* — where the middle-index rule
`V_{ik} ∘ V_{kj} ⊆ V_{ij}` applies — and come back.  This is exactly why coordinatization
needs rank `≥ 3` and says nothing at rank `2`.

Written out, with `w := 2 (u ∘ v)` the connector on `(j, k)` induced by the two given ones:

  `x ⊙ y := 8 ((x ∘ w) ∘ (v ∘ y))`.

Reading the model `H_n(C)`, where `V_{ij} = {a e_{ij} + a* e_{ji}}` and `u = [1]_{ij}`,
`v = [1]_{ik}`: `2(x ∘ w) = [a]_{ik}`, `2(v ∘ y) = [b]_{kj}`, and their doubled product is
`[ab]_{ij}`.  So `⊙` is matrix multiplication of the coordinates. -/

/-- The **coordinate product** on the block `V_{ij}`, relative to a third index `k` and
connectors `u ∈ V_{ij}`, `v ∈ V_{ik}`. -/
def coordMul (u v x y : J) : J := (8 : ℝ) • ((x * connMap u v) * (v * y))

theorem coordMul_apply (u v x y : J) :
    coordMul u v x y = (8 : ℝ) • ((x * connMap u v) * (v * y)) := rfl

/-- `x ⊙ y = 2 (A ∘ B)` with `A = 2 (x ∘ w) ∈ V_{ik}` and `B = 2 (v ∘ y) ∈ V_{kj}` — the form in
which the composition law is applied. -/
theorem coordMul_eq_smul_mul (u v x y : J) :
    coordMul u v x y
      = (2 : ℝ) • (((2 : ℝ) • (x * connMap u v)) * ((2 : ℝ) • (v * y))) := by
  rw [coordMul_apply, smul_mul, mul_smul_comm, smul_smul, smul_smul]
  norm_num

/-! ### Bilinearity -/

@[simp] theorem coordMul_zero_left (u v y : J) : coordMul u v 0 y = 0 := by
  rw [coordMul_apply, zero_mul', zero_mul', smul_zero]

@[simp] theorem coordMul_zero_right (u v x : J) : coordMul u v x 0 = 0 := by
  rw [coordMul_apply, mul_zero, mul_zero, smul_zero]

theorem coordMul_add_left (u v x x' y : J) :
    coordMul u v (x + x') y = coordMul u v x y + coordMul u v x' y := by
  simp only [coordMul_apply, EuclideanJordanAlgebra.add_mul, smul_add]

theorem coordMul_add_right (u v x y y' : J) :
    coordMul u v x (y + y') = coordMul u v x y + coordMul u v x y' := by
  simp only [coordMul_apply, mul_add, smul_add]

theorem coordMul_smul_left (r : ℝ) (u v x y : J) :
    coordMul u v (r • x) y = r • coordMul u v x y := by
  rw [coordMul_apply, coordMul_apply, smul_mul, smul_mul, smul_comm]

theorem coordMul_smul_right (r : ℝ) (u v x y : J) :
    coordMul u v x (r • y) = r • coordMul u v x y := by
  rw [coordMul_apply, coordMul_apply, mul_smul_comm, mul_smul_comm, smul_comm]

/-! ### Closure, the unit laws and the composition law -/

section Laws

variable (F : JordanFrame J n) {i j k : Fin n}

/-- **The coordinate product stays in the block.**  `V_{ij} ∘ V_{jk} ⊆ V_{ik}`,
`V_{ki} ∘ V_{ij} ⊆ V_{kj}` and `V_{ik} ∘ V_{kj} ⊆ V_{ij}`: three applications of the
middle-index rule, in that order. -/
theorem coordMul_mem (hij : i ≠ j) (hjk : j ≠ k) (hik : i ≠ k) {u v : J}
    (hv : IsConnector F i k v) (hw : IsConnector F j k (connMap u v)) {x y : J}
    (hx : x ∈ frameBlockRaw F i j) (hy : y ∈ frameBlockRaw F i j) :
    coordMul u v x y ∈ frameBlockRaw F i j := by
  have hA : x * connMap u v ∈ frameBlockRaw F i k :=
    frameBlockRaw_mul_middle F hij hjk hik hx hw.mem
  have hB : v * y ∈ frameBlockRaw F k j :=
    frameBlockRaw_mul_middle F (Ne.symm hik) hij (Ne.symm hjk) hv.symm.mem hy
  exact Submodule.smul_mem _ _
    (frameBlockRaw_mul_middle F hik (Ne.symm hjk) hij hA hB)

/-- `u ∘ w = ½ • v`: the connector `u` transfers the induced connector `w` on `(j,k)` back to
the given one on `(i,k)`.  This is `IsConnector.act` read at the index order `(j, i, k)`. -/
theorem conn_mul_connMap (hij : i ≠ j) (hjk : j ≠ k) (hik : i ≠ k) {u v : J}
    (hu : IsConnector F i j u) (hv : IsConnector F i k v) :
    u * connMap u v = (2 : ℝ)⁻¹ • v := by
  rw [connMap_apply, mul_smul_comm,
    IsConnector.act (F := F) (Ne.symm hij) hik hjk hu.symm hv.mem, smul_smul]
  norm_num

/-- **`u` is a left unit for `⊙`.** -/
theorem coordMul_one_left (hij : i ≠ j) (hjk : j ≠ k) (hik : i ≠ k) {u v : J}
    (hu : IsConnector F i j u) (hv : IsConnector F i k v) {y : J}
    (hy : y ∈ frameBlockRaw F i j) : coordMul u v u y = y := by
  rw [coordMul_apply, conn_mul_connMap F hij hjk hik hu hv, smul_mul, smul_smul,
    IsConnector.act (F := F) (Ne.symm hik) hij (Ne.symm hjk) hv.symm hy, smul_smul]
  norm_num

/-- `v ∘ u = ½ • w` — the same statement as `connMap`'s definition, with the factors commuted. -/
theorem conn_mul_conn_right {u v : J} : v * u = (2 : ℝ)⁻¹ • connMap u v := by
  rw [connMap_apply, smul_smul, _root_.mul_comm]
  norm_num

/-- **`u` is a right unit for `⊙`.** -/
theorem coordMul_one_right (hij : i ≠ j) (hjk : j ≠ k) (hik : i ≠ k) {u v : J}
    (hw : IsConnector F j k (connMap u v)) {x : J}
    (hx : x ∈ frameBlockRaw F i j) : coordMul u v x u = x := by
  rw [coordMul_apply, conn_mul_conn_right (u := u) (v := v), mul_smul_comm, smul_smul,
    _root_.mul_comm (x * connMap u v) (connMap u v), _root_.mul_comm x (connMap u v),
    IsConnector.act (F := F) (Ne.symm hjk) (Ne.symm hij) (Ne.symm hik) hw.symm ((frameBlockRaw_comm F i j) ▸ hx), smul_smul]
  norm_num

variable [FiniteDimensional ℝ J]

/-- **The composition law for `⊙`.**  If `x ∘ x = a • (pᵢ + pⱼ)` and `y ∘ y = b • (pᵢ + pⱼ)`
then `(x ⊙ y) ∘ (x ⊙ y) = (a b) • (pᵢ + pⱼ)`.

Three applications of `block_mul_sq`: the coefficient of `x` is carried to `V_{ik}` by `w`, the
coefficient of `y` is carried to `V_{kj}` by `v`, and the middle-index product multiplies
them. -/
theorem coordMul_sq (hij : i ≠ j) (hjk : j ≠ k) (hik : i ≠ k) {u v : J}
    (hv : IsConnector F i k v) (hw : IsConnector F j k (connMap u v)) {x y : J}
    (hx : x ∈ frameBlockRaw F i j) (hy : y ∈ frameBlockRaw F i j) {a b : ℝ}
    (hxx : x * x = a • (F.p i + F.p j)) (hyy : y * y = b • (F.p i + F.p j)) :
    coordMul u v x y * coordMul u v x y = (a * b) • (F.p i + F.p j) := by
  set A : J := (2 : ℝ) • (x * connMap u v) with hAdef
  set B : J := (2 : ℝ) • (v * y) with hBdef
  have hAmem : A ∈ frameBlockRaw F i k :=
    Submodule.smul_mem _ _ (frameBlockRaw_mul_middle F hij hjk hik hx hw.mem)
  have hBmem : B ∈ frameBlockRaw F k j :=
    Submodule.smul_mem _ _
      (frameBlockRaw_mul_middle F (Ne.symm hik) hij (Ne.symm hjk) hv.symm.mem hy)
  have hAA : A * A = a • (F.p i + F.p k) := by
    have := block_mul_sq F hij hjk hik hx hw.mem hxx hw.sq'
    rw [hAdef, this, _root_.mul_one]
  have hBB : B * B = b • (F.p k + F.p j) := by
    have := block_mul_sq F (Ne.symm hik) hij (Ne.symm hjk) hv.symm.mem hy hv.symm.sq' hyy
    rw [hBdef, this, _root_.one_mul]
  have hfin := block_mul_sq F hik (Ne.symm hjk) hij hAmem hBmem hAA hBB
  rw [coordMul_eq_smul_mul, ← hAdef, ← hBdef, hfin]

end Laws

end RadicalRelativity.EJA
