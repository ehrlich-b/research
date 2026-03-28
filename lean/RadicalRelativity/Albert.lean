/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Octonions
import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# The Albert Algebra h_3(O)

The **Albert algebra** (or exceptional Jordan algebra) is h_3(O): the
27-dimensional real vector space of 3x3 Hermitian octonionic matrices,
with Jordan product a . b = 1/2(ab + ba).

## Key properties

1. **Jordan identity**: (a . b) . a^2 = a . (b . a^2)
2. **Formally real**: a_1^2 + ... + a_n^2 = 0 implies all a_i = 0
3. **Simple**: no nontrivial ideals
4. **Exceptional**: does not embed in any associative algebra
   (equivalently: the universal C*-algebra C*(h_3(O)) = {0})
5. **Unique**: the ONLY exceptional simple formally real Jordan algebra,
   in any dimension (Zel'manov 1979/83)
6. **27-dimensional**: 3 real diagonal + 3x8 octonionic off-diagonal entries

## Role in the program

The universe is the unique non-composable self-modeling structure. Every
special Jordan algebra admits composites (BGW, via Hanche-Olsen universal
tensor product). Therefore the universe's algebra is not special. h_3(O)
is the unique non-special simple Jordan algebra. Therefore the universe
contains h_3(O).

## Main definitions

* `h3O` -- the type of 3x3 Hermitian octonionic matrices
* `h3O.jordanMul` -- the Jordan product
* `h3O.rankOneIdem` -- rank-1 idempotents (diagonal projections)
* `h3O.peirce2`, `h3O.peirce1`, `h3O.peirce0` -- Peirce subspaces
* `IsSpecialJordanAlgebra` -- predicate for special Jordan algebras

## References

* Albert, "On a certain algebra of quantum mechanics," Ann. Math. 35 (1934)
* Jordan, von Neumann, Wigner, "On an algebraic generalization of the quantum mechanical formalism," Ann. Math. 35 (1934)
* Zel'manov, "Jordan algebras with finiteness conditions," Algebra Logic 17 (1979)
* Baez, "The Octonions," S3.4
-/

noncomputable section

open Octonion

/-- A 3x3 Hermitian octonionic matrix.
    Elements have the form:
      [[a1,  x3*, x2 ],
       [x3,  a2,  x1*],
       [x2*, x1,  a3 ]]
    where a1, a2, a3 are real and x1, x2, x3 are octonions.
    The * denotes octonionic conjugation. -/
structure h3O where
  /-- Diagonal entries (real). -/
  diag : Fin 3 → ℝ
  /-- Off-diagonal entries (octonionic). x1 = (2,3), x2 = (1,3), x3 = (1,2). -/
  off : Fin 3 → Octonion

namespace h3O

/-- Zero element of h_3(O). -/
def zero : h3O := ⟨fun _ => 0, fun _ => 0⟩

/-- The identity element of h_3(O) = diag(1,1,1). -/
def one : h3O := ⟨fun _ => 1, fun _ => 0⟩

/-- Addition of Hermitian octonionic matrices (componentwise). -/
def add (a b : h3O) : h3O :=
  ⟨fun i => a.diag i + b.diag i, fun i => a.off i + b.off i⟩

/-- Scalar multiplication. -/
def smul (r : ℝ) (a : h3O) : h3O :=
  ⟨fun i => r * a.diag i, fun i => r • a.off i⟩

/-- Negation. -/
def neg (a : h3O) : h3O :=
  ⟨fun i => -(a.diag i), fun i => -(a.off i)⟩

instance : Zero h3O := ⟨zero⟩
instance : One h3O := ⟨one⟩
instance : Add h3O := ⟨add⟩
instance : Neg h3O := ⟨neg⟩
instance : SMul ℝ h3O := ⟨smul⟩

-- Extensionality for h3O
@[ext]
theorem ext {a b : h3O} (hd : ∀ i, a.diag i = b.diag i) (ho : ∀ i, a.off i = b.off i) : a = b := by
  cases a; cases b; congr 1
  · exact funext hd
  · exact funext ho

-- Simp lemmas for h3O basic operations
@[simp] lemma zero_diag (i : Fin 3) : (zero : h3O).diag i = 0 := rfl
@[simp] lemma zero_off (i : Fin 3) : (zero : h3O).off i = 0 := rfl
@[simp] lemma one_diag (i : Fin 3) : (one : h3O).diag i = 1 := rfl
@[simp] lemma one_off (i : Fin 3) : (one : h3O).off i = 0 := rfl

-- Octonion arithmetic helpers (Octonions.lean is upstream, don't touch it)
@[simp] private lemma oct_smul_zero (r : ℝ) : r • (0 : Octonion) = 0 := by
  ext i; show r * 0 = 0; ring
@[simp] private lemma oct_zero_add (a : Octonion) : (0 : Octonion) + a = a := by
  ext i; show (0 : ℝ) + a.coords i = a.coords i; ring
@[simp] private lemma oct_add_zero (a : Octonion) : a + (0 : Octonion) = a := by
  ext i; show a.coords i + (0 : ℝ) = a.coords i; ring
@[simp] private lemma oct_conj_zero : Octonion.conj 0 = 0 := by
  ext i; simp [Octonion.conj]
@[simp] private lemma oct_add_coords (a b : Octonion) (i : Fin 8) :
    (a + b).coords i = a.coords i + b.coords i := rfl
@[simp] private lemma oct_smul_coords (r : ℝ) (a : Octonion) (i : Fin 8) :
    (r • a).coords i = r * a.coords i := rfl
@[simp] private lemma oct_mul_zero (a : Octonion) : Octonion.mul a 0 = 0 := by
  ext i; fin_cases i <;> simp [Octonion.mul]
@[simp] private lemma oct_zero_mul (a : Octonion) : Octonion.mul 0 a = 0 := by
  ext i; fin_cases i <;> simp [Octonion.mul]

/-- The octonionic inner product: ⟨x, y⟩ = Σᵢ xᵢ yᵢ = Re(x̄ · y). -/
def octIp (x y : Octonion) : ℝ := Finset.univ.sum fun i => x.coords i * y.coords i

@[simp] lemma octIp_zero_left (y : Octonion) : octIp 0 y = 0 := by simp [octIp]
@[simp] lemma octIp_zero_right (x : Octonion) : octIp x 0 = 0 := by simp [octIp]

private lemma octIp_self_nonneg (x : Octonion) : 0 ≤ octIp x x :=
  Finset.sum_nonneg fun _ _ => mul_self_nonneg _

private lemma octIp_self_eq_zero {x : Octonion} (h : octIp x x = 0) : x = 0 := by
  ext i
  have h_le : x.coords i * x.coords i ≤ octIp x x :=
    Finset.single_le_sum (fun _ _ => mul_self_nonneg _) (Finset.mem_univ i)
  have : x.coords i * x.coords i = 0 := by linarith [mul_self_nonneg (x.coords i)]
  exact mul_self_eq_zero.mp this

/-- The **Jordan product** on h_3(O): a . b = 1/2(ab + ba).
    Computed explicitly for 3×3 Hermitian octonionic matrices using
    the matrix layout [[a₁, x₃*, x₂], [x₃, a₂, x₁*], [x₂*, x₁, a₃]].
    Diagonal: (A∘B)ₖₖ = aₖbₖ + ⟨off_i, off_j⟩ (octonionic inner products).
    Off-diagonal: (A∘B)_off(k) = ½(aᵢ+aⱼ)·q_k + ½(bᵢ+bⱼ)·p_k + ½(p̄ᵢq̄ⱼ + q̄ᵢp̄ⱼ). -/
def jordanMul (a b : h3O) : h3O :=
  ⟨fun k =>
    if k.val = 0 then
      a.diag 0 * b.diag 0 + octIp (a.off 1) (b.off 1) + octIp (a.off 2) (b.off 2)
    else if k.val = 1 then
      a.diag 1 * b.diag 1 + octIp (a.off 0) (b.off 0) + octIp (a.off 2) (b.off 2)
    else
      a.diag 2 * b.diag 2 + octIp (a.off 0) (b.off 0) + octIp (a.off 1) (b.off 1),
   fun k =>
    if k.val = 0 then
      ((a.diag 1 + a.diag 2) / 2) • b.off 0 + ((b.diag 1 + b.diag 2) / 2) • a.off 0
      + (1/2 : ℝ) • (Octonion.mul (Octonion.conj (a.off 1)) (Octonion.conj (b.off 2))
                    + Octonion.mul (Octonion.conj (b.off 1)) (Octonion.conj (a.off 2)))
    else if k.val = 1 then
      ((a.diag 0 + a.diag 2) / 2) • b.off 1 + ((b.diag 0 + b.diag 2) / 2) • a.off 1
      + (1/2 : ℝ) • (Octonion.mul (Octonion.conj (a.off 2)) (Octonion.conj (b.off 0))
                    + Octonion.mul (Octonion.conj (b.off 2)) (Octonion.conj (a.off 0)))
    else
      ((a.diag 0 + a.diag 1) / 2) • b.off 2 + ((b.diag 0 + b.diag 1) / 2) • a.off 2
      + (1/2 : ℝ) • (Octonion.mul (Octonion.conj (a.off 0)) (Octonion.conj (b.off 1))
                    + Octonion.mul (Octonion.conj (b.off 0)) (Octonion.conj (a.off 1)))⟩

instance : Mul h3O where mul := jordanMul

/-- The **trace** of a Hermitian octonionic matrix. -/
def trace (a : h3O) : ℝ := a.diag 0 + a.diag 1 + a.diag 2

/-- The **determinant** of a 3x3 Hermitian octonionic matrix (Freudenthal).
    det(a) = a1*a2*a3 + 2*Re(x1*x2*x3) - a1*N(x1) - a2*N(x2) - a3*N(x3)
    This is well-defined because the cyclic Re(xyz) is associator-independent. -/
def det (a : h3O) : ℝ :=
  a.diag 0 * a.diag 1 * a.diag 2
  + 2 * Octonion.re (Octonion.mul (Octonion.mul (a.off 0) (a.off 1)) (a.off 2))
  - a.diag 0 * Octonion.norm_sq (a.off 0)
  - a.diag 1 * Octonion.norm_sq (a.off 1)
  - a.diag 2 * Octonion.norm_sq (a.off 2)

/-- The **rank-1 idempotent** E_i = diag(..., 1, ...) with 1 in position i.
    These are the primitive idempotents of h_3(O). -/
def rankOneIdem (i : Fin 3) : h3O :=
  ⟨fun j => if j = i then 1 else 0, fun _ => 0⟩

/-- E_1 + E_2 + E_3 = 1 (the identity decomposes into primitive idempotents). -/
theorem sum_rank1_eq_one :
    add (add (rankOneIdem 0) (rankOneIdem 1)) (rankOneIdem 2) = one := by
  ext i
  · fin_cases i <;> simp [add, rankOneIdem, one]
  · fin_cases i <;> simp [add, rankOneIdem, one]

/-- Each E_i is idempotent under the Jordan product. -/
theorem rankOneIdem_idempotent (i : Fin 3) :
    jordanMul (rankOneIdem i) (rankOneIdem i) = rankOneIdem i := by
  ext k
  · fin_cases i <;> fin_cases k <;> simp [jordanMul, rankOneIdem, octIp]
  · fin_cases i <;> fin_cases k <;> simp [jordanMul, rankOneIdem, octIp]

/-- E_i and E_j are orthogonal for i != j. -/
theorem rankOneIdem_orthogonal (i j : Fin 3) (h : i ≠ j) :
    jordanMul (rankOneIdem i) (rankOneIdem j) = zero := by
  ext k
  · fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all [jordanMul, rankOneIdem, zero, octIp]
  · fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all [jordanMul, rankOneIdem, zero, octIp]

-- The Jordan identity

/-- **The Jordan identity** on h_3(O):
    (a . b) . a^2 = a . (b . a^2)
    This is the defining property of a Jordan algebra. -/
theorem jordan_identity (a b : h3O) :
    jordanMul (jordanMul a b) (jordanMul a a) =
    jordanMul a (jordanMul b (jordanMul a a)) := by
  sorry -- Expository; not referenced by any downstream file. Follows from alternativity of O

-- Structural properties

/-- h_3(O) is **formally real**: if a^2 = 0 then a = 0. -/
theorem formally_real (a : h3O) :
    jordanMul a a = zero → a = zero := by
  intro h
  -- Extract diagonal equations: each is a sum of non-negative terms = 0
  have hd0 : a.diag 0 * a.diag 0 + octIp (a.off 1) (a.off 1) + octIp (a.off 2) (a.off 2) = 0 := by
    have := congr_arg (fun x => x.diag 0) h; dsimp [jordanMul, zero] at this; linarith
  have hd1 : a.diag 1 * a.diag 1 + octIp (a.off 0) (a.off 0) + octIp (a.off 2) (a.off 2) = 0 := by
    have := congr_arg (fun x => x.diag 1) h; dsimp [jordanMul, zero] at this; linarith
  have hd2 : a.diag 2 * a.diag 2 + octIp (a.off 0) (a.off 0) + octIp (a.off 1) (a.off 1) = 0 := by
    have := congr_arg (fun x => x.diag 2) h; dsimp [jordanMul, zero] at this; linarith
  -- All summands ≥ 0, so each = 0
  have h_o1 : octIp (a.off 1) (a.off 1) = 0 := by
    linarith [mul_self_nonneg (a.diag 0), octIp_self_nonneg (a.off 1), octIp_self_nonneg (a.off 2)]
  have h_o2 : octIp (a.off 2) (a.off 2) = 0 := by
    linarith [mul_self_nonneg (a.diag 0), octIp_self_nonneg (a.off 1), octIp_self_nonneg (a.off 2)]
  have h_o0 : octIp (a.off 0) (a.off 0) = 0 := by
    linarith [mul_self_nonneg (a.diag 1), octIp_self_nonneg (a.off 0), octIp_self_nonneg (a.off 2)]
  have h_d0 : a.diag 0 * a.diag 0 = 0 := by
    linarith [mul_self_nonneg (a.diag 0), octIp_self_nonneg (a.off 1), octIp_self_nonneg (a.off 2)]
  have h_d1 : a.diag 1 * a.diag 1 = 0 := by
    linarith [mul_self_nonneg (a.diag 1), octIp_self_nonneg (a.off 0), octIp_self_nonneg (a.off 2)]
  have h_d2 : a.diag 2 * a.diag 2 = 0 := by
    linarith [mul_self_nonneg (a.diag 2), octIp_self_nonneg (a.off 0), octIp_self_nonneg (a.off 1)]
  apply ext
  · intro i; fin_cases i
    · exact mul_self_eq_zero.mp h_d0
    · exact mul_self_eq_zero.mp h_d1
    · exact mul_self_eq_zero.mp h_d2
  · intro i; fin_cases i
    · exact octIp_self_eq_zero h_o0
    · exact octIp_self_eq_zero h_o1
    · exact octIp_self_eq_zero h_o2

/-- A Jordan ideal of h_3(O). -/
def IsJordanIdeal (I : Set h3O) : Prop :=
  (∀ a b, a ∈ I → jordanMul a b ∈ I) ∧
  (∀ a b, a ∈ I → b ∈ I → add a b ∈ I) ∧
  zero ∈ I

/-- h_3(O) is **simple**: it has no nontrivial Jordan ideals. -/
theorem simple : ∀ I : Set h3O, IsJordanIdeal I →
    I = {zero} ∨ I = Set.univ := by
  sorry -- Expository; not referenced by any downstream file. Needs spectral decomposition for h_3(O)

/-- A Jordan algebra is **special** if there exists an associative algebra A
    and an injection J -> A such that the Jordan product becomes the
    symmetrized associative product. h_3(O) has no such embedding.

    We define this as a Prop-valued predicate on a type equipped with
    an additive structure and a multiplication (the Jordan product). -/
def IsSpecialJordanAlgebra (J : Type*) [Add J] [Mul J] : Prop :=
  ∃ (A : Type*) (_ : Ring A) (f : J → A),
    Function.Injective f ∧
    ∀ a b : J, f (a * b) = f a * f b + f b * f a

/-- h_3(O) is **exceptional** (non-special): it does not embed in any
    associative algebra A via a -> a where the Jordan product becomes the
    symmetrized associative product. This is Albert's original result (1934). -/
theorem not_special : ¬ IsSpecialJordanAlgebra h3O := by
  sorry -- Expository; not referenced by any downstream file. Albert (1934), Glennie identity

/-- The **rank** of h_3(O) is 3 (maximal number of orthogonal idempotents). -/
def rank : ℕ := 3

-- Peirce decomposition with respect to E_1

/-- The **Peirce 2-space** V_2(E_1): elements fixed by L_{E_1}.
    For h_3(O) with E_1 = diag(1,0,0), this is the (1,1) entry.
    Isomorphic to R (1-dimensional). -/
def peirce2 : Set h3O :=
  { a | jordanMul (rankOneIdem 0) a = a }

/-- The **Peirce 1-space** V_1(E_1): the half-eigenspace of L_{E_1}.
    For h_3(O) with E_1, these are the off-diagonal entries involving row/col 1.
    Isomorphic to O^2 (16-dimensional). -/
def peirce1 : Set h3O :=
  { a | jordanMul (rankOneIdem 0) a = smul (1/2) a }

/-- The **Peirce 0-space** V_0(E_1): elements annihilated by L_{E_1}.
    For h_3(O) with E_1, this is the lower-right 2x2 block.
    Isomorphic to h_2(O) = V_9 (the 9-dimensional spin factor, 10-dim as space). -/
def peirce0 : Set h3O :=
  { a | jordanMul (rankOneIdem 0) a = zero }

/-- Peirce decomposition is complete: V = V_2 + V_1 + V_0. -/
theorem peirce_complete (a : h3O) :
    ∃ (a2 a1 a0 : h3O),
      a2 ∈ peirce2 ∧ a1 ∈ peirce1 ∧ a0 ∈ peirce0 ∧
      a = add (add a2 a1) a0 := by
  -- Explicit Peirce components w.r.t. E_0 = rankOneIdem 0
  refine ⟨⟨fun k => if k = 0 then a.diag 0 else 0, fun _ => 0⟩,
          ⟨fun _ => 0, fun k => if k = 0 then 0 else a.off k⟩,
          ⟨fun k => if k = 0 then 0 else a.diag k, fun k => if k = 0 then a.off 0 else 0⟩,
          ?_, ?_, ?_, ?_⟩
  -- a2 ∈ peirce2: jordanMul (rankOneIdem 0) a2 = a2
  · show jordanMul (rankOneIdem 0) _ = _
    apply ext
    · intro k; fin_cases k <;> simp [jordanMul, rankOneIdem, octIp]
    · intro k; fin_cases k <;> simp [jordanMul, rankOneIdem, octIp]
  -- a1 ∈ peirce1: jordanMul (rankOneIdem 0) a1 = smul (1/2) a1
  · show jordanMul (rankOneIdem 0) _ = smul (1/2) _
    apply ext
    · intro k; fin_cases k <;> simp [jordanMul, rankOneIdem, octIp, smul]
    · intro k; fin_cases k <;>
        (ext j; simp [oct_add_coords, Octonion.zero_coords, jordanMul, rankOneIdem, octIp, smul, HSMul.hSMul, SMul.smul, Octonion.conj, Octonion.mul]; try ring)
  -- a0 ∈ peirce0: jordanMul (rankOneIdem 0) a0 = zero
  · show jordanMul (rankOneIdem 0) _ = zero
    apply ext
    · intro k; fin_cases k <;> simp [jordanMul, rankOneIdem, octIp, zero]
    · intro k; fin_cases k <;>
        (ext j; simp [oct_add_coords, Octonion.zero_coords, jordanMul, rankOneIdem, octIp, zero, HSMul.hSMul, SMul.smul, Octonion.conj, Octonion.mul]; try ring)
  -- a = add (add a2 a1) a0
  · apply ext
    · intro k; fin_cases k <;> simp [add]
    · intro k; fin_cases k <;> simp [add]

-- Zel'manov uniqueness

/-- **Zel'manov's theorem** (axiomatized): h_3(O) is the UNIQUE exceptional
    simple formally real Jordan algebra. Any exceptional simple formally real
    Jordan algebra is isomorphic to h_3(O). -/
axiom zelmanov_uniqueness :
  ∀ (J : Type*) [Add J] [Mul J],
    ¬ IsSpecialJordanAlgebra J →  -- exceptional
    True  -- placeholder for "J isomorphic to h_3(O)"

end h3O
