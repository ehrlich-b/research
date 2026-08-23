/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.EJA.Connection
import RadicalRelativity.Composition.Hurwitz

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

/-! ## The coordinate algebra as a type

Everything above is a statement about elements of `J`.  To hand the block to
`RadicalRelativity/Composition/`, it has to become a type carrying `NonAssocRing` and
`CompositionAlgebra` instances, which means the connectors have to be part of the *data* the
type depends on.  `CoordData` bundles them; `CoordAlg D` is the block `V_{ij}` regarded as an
algebra through them. -/

/-- The data Jacobson coordinatization consumes: a frame, three distinct indices, and connectors
on `(i,j)` and `(i,k)` whose induced element on `(j,k)` is again a connector.

★ The last field is *derivable* under `[FiniteDimensional ℝ J]` — it is `IsConnector.transfer` —
and is carried as a field anyway so that the algebra structure below needs no dimension
hypothesis.  `CoordData.mk'` builds it. -/
structure CoordData (J : Type*) [NormedAddCommGroup J] [InnerProductSpace ℝ J]
    [EuclideanJordanAlgebra J] (n : ℕ) where
  /-- The Jordan frame. -/
  F : JordanFrame J n
  /-- The row index of the block. -/
  i : Fin n
  /-- The column index of the block. -/
  j : Fin n
  /-- The third index the product is routed through. -/
  k : Fin n
  /-- The three indices are distinct. -/
  hij : i ≠ j
  /-- The three indices are distinct. -/
  hjk : j ≠ k
  /-- The three indices are distinct. -/
  hik : i ≠ k
  /-- The connector on `(i,j)`, which becomes the unit of the coordinate algebra. -/
  u : J
  /-- The connector on `(i,k)`. -/
  v : J
  /-- `u` connects `pᵢ` and `pⱼ`. -/
  hu : IsConnector F i j u
  /-- `v` connects `pᵢ` and `p_k`. -/
  hv : IsConnector F i k v
  /-- The induced element `2 (u ∘ v)` connects `pⱼ` and `p_k`. -/
  hw : IsConnector F j k (connMap u v)

/-- `CoordData` from two connectors, the third being `IsConnector.transfer`. -/
def CoordData.mk' [FiniteDimensional ℝ J] (F : JordanFrame J n) {i j k : Fin n} (hij : i ≠ j)
    (hjk : j ≠ k) (hik : i ≠ k) {u v : J} (hu : IsConnector F i j u)
    (hv : IsConnector F i k v) : CoordData J n :=
  { F := F, i := i, j := j, k := k, hij := hij, hjk := hjk, hik := hik, u := u, v := v,
    hu := hu, hv := hv,
    hw := IsConnector.transfer (Ne.symm hij) hik hjk hu.symm hv }

/-- **The coordinate algebra**: the block `V_{ij}` carrying the coordinate product. -/
def CoordAlg (D : CoordData J n) : Type _ := ↥(frameBlockRaw D.F D.i D.j)

namespace CoordAlg

variable {D : CoordData J n}

instance : AddCommGroup (CoordAlg D) :=
  inferInstanceAs (AddCommGroup ↥(frameBlockRaw D.F D.i D.j))

instance : Module ℝ (CoordAlg D) :=
  inferInstanceAs (Module ℝ ↥(frameBlockRaw D.F D.i D.j))

/-- The underlying element of `J`. -/
def val (x : CoordAlg D) : J :=
  Subtype.val (α := J) (p := fun z => z ∈ frameBlockRaw D.F D.i D.j) x

theorem val_mem (x : CoordAlg D) : val x ∈ frameBlockRaw D.F D.i D.j :=
  Subtype.property (p := fun z => z ∈ frameBlockRaw D.F D.i D.j) x

theorem val_injective : Function.Injective (val : CoordAlg D → J) :=
  Subtype.val_injective (p := fun z => z ∈ frameBlockRaw D.F D.i D.j)

@[ext] theorem ext {x y : CoordAlg D} (h : val x = val y) : x = y := val_injective h

@[simp] theorem val_zero : val (0 : CoordAlg D) = 0 := rfl
@[simp] theorem val_add (x y : CoordAlg D) : val (x + y) = val x + val y := rfl
@[simp] theorem val_neg (x : CoordAlg D) : val (-x) = -val x := rfl
@[simp] theorem val_smul (r : ℝ) (x : CoordAlg D) : val (r • x) = r • val x := rfl

theorem val_eq_zero {x : CoordAlg D} : val x = 0 ↔ x = 0 :=
  ⟨fun h => ext (by rw [h, val_zero]), fun h => by rw [h, val_zero]⟩

instance : Mul (CoordAlg D) :=
  ⟨fun x y => (⟨coordMul D.u D.v (val x) (val y),
    coordMul_mem D.F D.hij D.hjk D.hik D.hv D.hw (val_mem x) (val_mem y)⟩ :
      ↥(frameBlockRaw D.F D.i D.j))⟩

instance : One (CoordAlg D) :=
  ⟨(⟨D.u, D.hu.mem⟩ : ↥(frameBlockRaw D.F D.i D.j))⟩

@[simp] theorem val_mul (x y : CoordAlg D) :
    val (x * y) = coordMul D.u D.v (val x) (val y) := rfl

@[simp] theorem val_one : val (1 : CoordAlg D) = D.u := rfl

/-- The coordinate algebra is a (non-associative) unital ring: distributivity is the bilinearity
of `⊙`, and the two unit laws are `coordMul_one_left` / `coordMul_one_right`. -/
instance : NonAssocRing (CoordAlg D) :=
  { (inferInstance : AddCommGroup (CoordAlg D)) with
    mul := (· * ·)
    one := 1
    left_distrib := fun x y z => ext (by simp [coordMul_add_right])
    right_distrib := fun x y z => ext (by simp [coordMul_add_left])
    zero_mul := fun x => ext (by simp)
    mul_zero := fun x => ext (by simp)
    one_mul := fun x =>
      ext (by
        rw [val_mul, val_one]
        exact coordMul_one_left D.F D.hij D.hjk D.hik D.hu D.hv (val_mem x))
    mul_one := fun x =>
      ext (by
        rw [val_mul, val_one]
        exact coordMul_one_right D.F D.hij D.hjk D.hik D.hw (val_mem x)) }

instance : IsScalarTower ℝ (CoordAlg D) (CoordAlg D) :=
  ⟨fun r x y => ext (by simp [coordMul_smul_left])⟩

instance : SMulCommClass ℝ (CoordAlg D) (CoordAlg D) :=
  ⟨fun r x y => ext (by simp [coordMul_smul_right])⟩

/-- The unit of the coordinate algebra is nonzero: `u ∘ u = pᵢ + pⱼ ≠ 0`. -/
instance : Nontrivial (CoordAlg D) := by
  refine ⟨1, 0, fun h => ?_⟩
  have hu0 : D.u = 0 := by
    have := congrArg (val (D := D)) h
    simpa using this
  have hsq := D.hu.sq
  rw [hu0, zero_mul'] at hsq
  have := congrArg (fun z : J => (inner ℝ z (D.F.p D.i) : ℝ)) hsq
  simp only [inner_zero_left, inner_add_left, inner_p_p_of_ne D.F (Ne.symm D.hij),
    add_zero] at this
  exact absurd this.symm (ne_of_gt (inner_p_self_pos D.F D.i))

/-- The normalisation constant `2 τᵢ = 2 ⟪pᵢ, pᵢ⟫`, positive. -/
def scale (D : CoordData J n) : ℝ := 2 * (inner ℝ (D.F.p D.i) (D.F.p D.i) : ℝ)

theorem scale_pos (D : CoordData J n) : 0 < scale D := by
  have := inner_p_self_pos D.F D.i
  unfold scale; linarith

/-- The norm form of the coordinate algebra: the ambient inner product, rescaled so that the
unit has norm `1`.  It is `x ↦ ` the coefficient of `x ∘ x` on `pᵢ + pⱼ`, by
`sq_eq_inner_smul`. -/
def form (D : CoordData J n) : CoordAlg D →ₗ[ℝ] CoordAlg D →ₗ[ℝ] ℝ :=
  LinearMap.mk₂ ℝ (fun x y => (inner ℝ (val x) (val y) : ℝ) / scale D)
    (fun x x' y => by simp [inner_add_left, add_div])
    (fun r x y => by simp [real_inner_smul_left, mul_div_assoc])
    (fun x y y' => by simp [inner_add_right, add_div])
    (fun r x y => by simp [real_inner_smul_right, mul_div_assoc])

@[simp] theorem form_apply (x y : CoordAlg D) :
    form D x y = (inner ℝ (val x) (val y) : ℝ) / scale D := rfl

section Comp

variable [FiniteDimensional ℝ J]

/-- The form reads off the square: `x ∘ x = (form x x) • (pᵢ + pⱼ)` in `J`. -/
theorem val_sq (x : CoordAlg D) :
    val x * val x = form D x x • (D.F.p D.i + D.F.p D.j) :=
  sq_eq_inner_smul D.F D.hij (val_mem x)

/-- **The coordinate algebra is a Euclidean composition algebra.**

`B_comp` is `coordMul_sq`: the square of `x ⊙ y` has coefficient the product of the two
coefficients, and `smul_pair_inj` says the coefficient determines the form value. -/
instance : CompositionAlgebra (CoordAlg D) where
  B := form D
  B_symm x y := by simp [real_inner_comm (val x) (val y)]
  B_pos x hx := by
    have hv : val x ≠ 0 := fun h => hx (val_eq_zero.mp h)
    have := real_inner_self_pos.mpr hv
    simpa [form_apply] using div_pos this (scale_pos D)
  B_comp x y := by
    have hxy : val (x * y) * val (x * y)
        = (form D x x * form D y y) • (D.F.p D.i + D.F.p D.j) := by
      rw [val_mul]
      exact coordMul_sq D.F D.hij D.hjk D.hik D.hv D.hw (val_mem x) (val_mem y)
        (val_sq x) (val_sq y)
    exact smul_pair_inj D.F D.hij ((val_sq (x * y)).symm.trans hxy)

/-- The coordinate algebra is finite-dimensional whenever `J` is: it is a submodule of `J`. -/
instance : FiniteDimensional ℝ (CoordAlg D) :=
  inferInstanceAs (FiniteDimensional ℝ ↥(frameBlockRaw D.F D.i D.j))

/-- **`dim V_{ij} ∈ {1, 2, 4, 8}` for a connected frame at rank `≥ 3`.**

Hurwitz's dimension theorem, applied to the coordinate algebra.  This is the first place the
composition-algebra block and the Jordan block layer meet, and it is a statement purely about
the Euclidean Jordan algebra `J`: the off-diagonal blocks of a Jordan frame with three distinct
indices and connectors between them have real dimension `1`, `2`, `4` or `8` — the dimensions
of `ℝ`, `ℂ`, `ℍ` and `𝕆`. -/
theorem finrank_coordAlg :
    Module.finrank ℝ (CoordAlg D) = 1 ∨ Module.finrank ℝ (CoordAlg D) = 2 ∨
      Module.finrank ℝ (CoordAlg D) = 4 ∨ Module.finrank ℝ (CoordAlg D) = 8 :=
  CompositionAlgebra.finrank_eq_one_or_two_or_four_or_eight

/-- The same, read as a statement about the block `V_{ij}` of `J`. -/
theorem finrank_frameBlockRaw_of_coordData (D : CoordData J n) :
    Module.finrank ℝ ↥(frameBlockRaw D.F D.i D.j) = 1 ∨
      Module.finrank ℝ ↥(frameBlockRaw D.F D.i D.j) = 2 ∨
      Module.finrank ℝ ↥(frameBlockRaw D.F D.i D.j) = 4 ∨
      Module.finrank ℝ ↥(frameBlockRaw D.F D.i D.j) = 8 :=
  finrank_coordAlg (D := D)

end Comp

end CoordAlg

end RadicalRelativity.EJA
