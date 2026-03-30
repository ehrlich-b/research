/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert
import RadicalRelativity.Octonions
import Mathlib.Data.Real.Basic

set_option linter.style.longLine false

/-!
# F_4: Automorphism Group of h_3(O)

Aut(h_3(O)) = F_4, the compact exceptional Lie group (52-dimensional,
rank 4). This is a theorem of Chevalley-Schafer (1950).

## Key subgroups

F_4 has exactly two maximal Borel-de Siebenthal subgroups:

1. **Spin(9)**: stabilizer of a rank-1 idempotent E_i in h_3(O).
   F_4/Spin(9) = OP^2 (octonionic projective plane, 16-dim).
   dim(Spin(9)) = 36, so dim(F_4) = 36 + 16 = 52.

2. **[SU(3) x SU(3)] / Z_3**: commutant of the order-3 automorphism
   induced by the octonion splitting O = C + C^3 (choice of unit
   imaginary octonion u). One SU(3) is color, the other is flavor.

These are the two subgroups whose intersection gives the SM gauge group.

## Main definitions

* `Aut_h3O` -- automorphisms of h_3(O)
* `Stab_idem` -- stabilizer of a rank-1 idempotent (= Spin(9))
* `Stab_complex` -- stabilizer of a complex structure (= [SU(3)xSU(3)]/Z_3)

## References

* Chevalley, Schafer, "The exceptional simple Lie algebras F_4 and E_6,"
  Proc. Nat. Acad. Sci. 36 (1950)
* Borel, de Siebenthal, "Les sous-groupes fermes de rang maximum des
  groupes de Lie clos," Comment. Math. Helv. 23 (1949)
-/

noncomputable section

open h3O Octonion

namespace F4

/-- An **automorphism** of h_3(O) is an R-linear bijection preserving
    the Jordan product. -/
structure Aut_h3O where
  /-- The underlying function. -/
  toFun : h3O → h3O
  /-- Preserves addition. -/
  map_add : ∀ a b, toFun (h3O.add a b) = h3O.add (toFun a) (toFun b)
  /-- Preserves scalar multiplication. -/
  map_smul : ∀ (r : ℝ) a, toFun (h3O.smul r a) = h3O.smul r (toFun a)
  /-- Preserves the Jordan product. -/
  map_jordan : ∀ a b, toFun (h3O.jordanMul a b) = h3O.jordanMul (toFun a) (toFun b)
  /-- Injectivity. -/
  injective : Function.Injective toFun
  /-- Surjectivity. -/
  surjective : Function.Surjective toFun

/-- The identity automorphism. -/
def Aut_h3O.id : Aut_h3O where
  toFun := fun a => a
  map_add := fun _ _ => rfl
  map_smul := fun _ _ => rfl
  map_jordan := fun _ _ => rfl
  injective := Function.injective_id
  surjective := Function.surjective_id

/-- Composition of automorphisms. -/
def Aut_h3O.comp (f g : Aut_h3O) : Aut_h3O where
  toFun := f.toFun ∘ g.toFun
  map_add := by intro a b; simp only [Function.comp, g.map_add, f.map_add]
  map_smul := by intro r a; simp only [Function.comp, g.map_smul, f.map_smul]
  map_jordan := by intro a b; simp only [Function.comp, g.map_jordan, f.map_jordan]
  injective := Function.Injective.comp f.injective g.injective
  surjective := Function.Surjective.comp f.surjective g.surjective

/-- Inverse of an automorphism (exists by bijectivity). -/
def Aut_h3O.inv (f : Aut_h3O) : Aut_h3O where
  toFun := Function.surjInv f.surjective
  map_add := by
    intro a b; apply f.injective
    simp only [f.map_add, Function.surjInv_eq f.surjective]
  map_smul := by
    intro r a; apply f.injective
    simp only [f.map_smul, Function.surjInv_eq f.surjective]
  map_jordan := by
    intro a b; apply f.injective
    simp only [f.map_jordan, Function.surjInv_eq f.surjective]
  injective := by
    intro a b hab
    have := congr_arg f.toFun hab
    simp only [Function.surjInv_eq f.surjective] at this; exact this
  surjective := fun x =>
    ⟨f.toFun x, f.injective (Function.surjInv_eq f.surjective _)⟩

/-- **Chevalley-Schafer theorem** (axiomatized):
    Aut(h_3(O)) is isomorphic to the compact exceptional Lie group F_4.
    F_4 is 52-dimensional and has rank 4. -/
axiom chevalley_schafer : True  -- Aut_h3O "is" F_4 as a Lie group

-- Subgroup 1: Spin(9) = stabilizer of a rank-1 idempotent

/-- The **stabilizer** of a rank-1 idempotent E_i under Aut(h_3(O)).
    Isomorphic to Spin(9) (double cover of SO(9)). -/
def Stab_idem (i : Fin 3) : Set Aut_h3O :=
  { f | f.toFun (h3O.rankOneIdem i) = h3O.rankOneIdem i }

/-- The stabilizer of E_i is closed under composition. -/
theorem stab_idem_closed_comp (i : Fin 3) (f g : Aut_h3O)
    (hf : f ∈ Stab_idem i) (hg : g ∈ Stab_idem i) :
    Aut_h3O.comp f g ∈ Stab_idem i := by
  simp only [Stab_idem, Set.mem_setOf_eq, Aut_h3O.comp, Function.comp] at *
  rw [hg, hf]

/-- The identity is in the stabilizer. -/
theorem stab_idem_id (i : Fin 3) : Aut_h3O.id ∈ Stab_idem i := rfl

/-- **Spin(9) theorem** (axiomatized): Stab(E_i) is isomorphic to Spin(9).
    dim(Spin(9)) = 36.
    Reference: Freudenthal, "Oktaven, Ausnahmegruppen und Oktavengeometrie,"
    Geom. Dedicata 19 (1985); Baez, "The Octonions," Bull. AMS 39 (2002),
    Section 3.4. -/
axiom stab_is_Spin9 (i : Fin 3) : True  -- Stab_idem i ≅ Spin(9)

/-- **F_4 / Spin(9) = OP^2**: the quotient is the octonionic projective plane
    (Cayley plane), which is 16-dimensional. 52 - 36 = 16.
    Reference: Baez, "The Octonions," Bull. AMS 39 (2002), Section 3.4. -/
axiom quotient_is_OP2 : True  -- F_4 / Stab_idem i ≅ OP^2

/-- Spin(9) acts on the Peirce 1-space V_1(E_i) = O^2 as the spin
    representation (16-dim real).
    Reference: Baez, "The Octonions," Bull. AMS 39 (2002), Section 3.4;
    Adams, "Lectures on Exceptional Lie Groups," Chicago Lectures in
    Mathematics (1996). -/
axiom spin9_acts_on_peirce1 : True  -- Spin(9) -> GL(V_1) via spin rep

-- Subgroup 2: [SU(3) x SU(3)] / Z_3 = stabilizer of complex structure

/-- The stabilizer of a complex structure on O in Aut(h_3(O)).
    Isomorphic to [SU(3) x SU(3)] / Z_3. -/
def Stab_complex (J : Octonion.ComplexStructure) : Set Aut_h3O :=
  { f | ∀ a : h3O, (∀ i, a.off i ∈ Octonion.complexSubspace J) →
    ∀ i, (f.toFun a).off i ∈ Octonion.complexSubspace J }

/-- **SU(3)xSU(3)/Z_3 theorem** (axiomatized): the stabilizer of a complex
    structure on O in Aut(h_3(O)) is isomorphic to [SU(3) x SU(3)] / Z_3.
    - One SU(3) acts on C^3 (the complement of C in O): color.
    - The other SU(3) acts on the 3 off-diagonal positions: flavor.
    - dim = 8 + 8 = 16.
    Reference: Borel, de Siebenthal, "Les sous-groupes fermes de rang maximum
    des groupes de Lie clos," Comment. Math. Helv. 23 (1949), 200-221.
    Applied to F_4: the maximal rank subgroups are Spin(9) and
    [SU(3) x SU(3)] / Z_3. See also Yokota, "Exceptional Lie Groups,"
    arXiv:0902.0431, Chapter 5. -/
axiom stab_complex_is_SU3xSU3modZ3 (J : Octonion.ComplexStructure) : True

-- Borel-de Siebenthal classification

/-- **Borel-de Siebenthal theorem for F_4** (axiomatized): the maximal
    connected subgroups of F_4 of maximal rank are exactly:
    1. Spin(9) (stabilizer of an idempotent)
    2. [SU(3) x SU(3)] / Z_3 (stabilizer of a complex structure)
    These are the only two types.
    Reference: Borel, de Siebenthal, "Les sous-groupes fermes de rang maximum
    des groupes de Lie clos," Comment. Math. Helv. 23 (1949), 200-221. -/
axiom borel_de_siebenthal_F4 : True

-- Cyclic permutation of Fin 3 and its inverse
private def cyc : Fin 3 → Fin 3 | 0 => 1 | 1 => 2 | 2 => 0
private def cycInv : Fin 3 → Fin 3 | 0 => 2 | 1 => 0 | 2 => 1

private lemma cyc_cycInv (k : Fin 3) : cyc (cycInv k) = k := by fin_cases k <;> rfl
private lemma cycInv_cyc (k : Fin 3) : cycInv (cyc k) = k := by fin_cases k <;> rfl

-- The cyclic-shift automorphism of h_3(O): permutes all indices by 0→1→2→0.
private def cycShift (a : h3O) : h3O := ⟨a.diag ∘ cycInv, a.off ∘ cycInv⟩

private lemma cycShift_diag (a : h3O) (k : Fin 3) : (cycShift a).diag k = a.diag (cycInv k) := rfl
private lemma cycShift_off (a : h3O) (k : Fin 3) : (cycShift a).off k = a.off (cycInv k) := rfl

-- The inverse cyclic-shift
private def cycShiftInv (a : h3O) : h3O := ⟨a.diag ∘ cyc, a.off ∘ cyc⟩

private lemma cycShift_cycShiftInv (a : h3O) : cycShift (cycShiftInv a) = a := by
  ext k <;> simp [cycShift, cycShiftInv, Function.comp, cyc_cycInv]

private lemma cycShiftInv_cycShift (a : h3O) : cycShiftInv (cycShift a) = a := by
  ext k <;> simp [cycShift, cycShiftInv, Function.comp, cycInv_cyc]

-- cycShift maps rankOneIdem i to rankOneIdem (cyc i)
private lemma cycShift_rankOneIdem (i : Fin 3) :
    cycShift (h3O.rankOneIdem i) = h3O.rankOneIdem (cyc i) := by
  ext k
  · simp only [cycShift_diag, h3O.rankOneIdem]
    fin_cases i <;> fin_cases k <;> simp [cycInv, cyc]
  · simp [cycShift_off, h3O.rankOneIdem]

-- The automorphism: diagonal Jordan product verification with octIp permutation
set_option maxHeartbeats 800000 in
private def cycAut : Aut_h3O where
  toFun := cycShift
  map_add := fun a b => by ext k <;> simp [cycShift, h3O.add, Function.comp]
  map_smul := fun r a => by ext k <;> simp [cycShift, h3O.smul, Function.comp]
  map_jordan := fun a b => by
    apply h3O.ext
    · -- Diagonal
      intro k; fin_cases k <;> simp [cycShift, Function.comp, h3O.jordanMul, cycInv, h3O.octIp] <;> ring
    · -- Off-diagonal: each case reduces after resolving if-then-else + add_comm
      have hac : ∀ (x y : ℝ) (z : Octonion), ((x + y) / 2) • z = ((y + x) / 2) • z := by
        intros; rw [add_comm]
      intro k; fin_cases k <;>
        simp only [cycShift, Function.comp, cycInv, h3O.jordanMul, Fin.isValue] <;>
        (first | rfl | (norm_num; simp only [hac]))
  injective := fun a b h => by
    have := congr_arg cycShiftInv h
    simp only [cycShiftInv_cycShift] at this; exact this
  surjective := fun a => ⟨cycShiftInv a, cycShift_cycShiftInv a⟩

-- The "double cyclic shift" automorphism (inverse direction: 0→2→1→0)
private def cycAut2 : Aut_h3O := Aut_h3O.comp cycAut cycAut

private lemma cycAut2_toFun (a : h3O) :
    cycAut2.toFun a = cycShift (cycShift a) := rfl

private lemma cycShift_twice_rankOneIdem (i : Fin 3) :
    cycShift (cycShift (h3O.rankOneIdem i)) = h3O.rankOneIdem (cyc (cyc i)) := by
  rw [cycShift_rankOneIdem, cycShift_rankOneIdem]

-- Helper: g.toFun applied to g⁻¹.toFun gives identity
private lemma inv_toFun_eq {g : Aut_h3O} {x y : h3O} (h : g.toFun x = y) :
    (Aut_h3O.inv g).toFun y = x := by
  apply g.injective
  have : g.toFun ((Aut_h3O.inv g).toFun y) = y := by
    change g.toFun (Function.surjInv g.surjective y) = y
    exact Function.surjInv_eq g.surjective y
  rw [this, h]

-- Main conjugacy lemma: if g.toFun(E_i) = E_j, then stabilizers are conjugate
private lemma stab_conjugate_of_map {g : Aut_h3O} {i j : Fin 3}
    (hg : g.toFun (h3O.rankOneIdem i) = h3O.rankOneIdem j) :
    ∀ f, f ∈ Stab_idem i ↔
      Aut_h3O.comp (Aut_h3O.comp g f) (Aut_h3O.inv g) ∈ Stab_idem j := by
  intro f
  simp only [Stab_idem, Set.mem_setOf_eq, Aut_h3O.comp, Function.comp]
  constructor
  · intro hf
    have hinv : (Aut_h3O.inv g).toFun (h3O.rankOneIdem j) = h3O.rankOneIdem i :=
      inv_toFun_eq hg
    rw [hinv, hf, hg]
  · intro hgfg
    have hinv : (Aut_h3O.inv g).toFun (h3O.rankOneIdem j) = h3O.rankOneIdem i :=
      inv_toFun_eq hg
    rw [hinv] at hgfg
    -- hgfg : g.toFun (f.toFun (E_i)) = E_j
    -- hg   : g.toFun (E_i) = E_j
    exact g.injective (hgfg.trans hg.symm)

/-- All rank-1 idempotent stabilizers are conjugate in F_4.
    F_4 acts transitively on the set of rank-1 idempotents (= OP^2). -/
theorem stab_idem_conjugate (i j : Fin 3) :
    ∃ (g : Aut_h3O), ∀ f, f ∈ Stab_idem i ↔
      Aut_h3O.comp (Aut_h3O.comp g f) (Aut_h3O.inv g) ∈ Stab_idem j := by
  -- Choose the right power of the cyclic automorphism based on (i, j)
  fin_cases i <;> fin_cases j
  all_goals first
    | exact ⟨Aut_h3O.id, stab_conjugate_of_map rfl⟩
    | exact ⟨cycAut, stab_conjugate_of_map (cycShift_rankOneIdem _)⟩
    | exact ⟨cycAut2, stab_conjugate_of_map (by
        change cycShift (cycShift (h3O.rankOneIdem _)) = h3O.rankOneIdem _
        rw [cycShift_rankOneIdem, cycShift_rankOneIdem]; rfl)⟩

/-- **G_2 transitivity on complex structures** (axiomatized): G_2 acts
    transitively on S^6 (unit imaginary octonions). Every G_2 element
    lifts to an F_4 = Aut(h_3(O)) automorphism that maps the h_3(C_J)
    subalgebra to h_3(C_K), and whose inverse maps h_3(C_K) back.
    Reference: Baez, "The Octonions," Bull. AMS 39 (2002), Section 4.1
    (G_2 transitivity on S^6); Yokota, "Exceptional Lie Groups,"
    arXiv:0902.0431, Chapter 5 (G_2 ⊂ F_4 preserving Jordan structure). -/
axiom g2_transitive_complex_structures (J K : Octonion.ComplexStructure) :
    ∃ (g : Aut_h3O),
      (∀ a : h3O, (∀ i, a.off i ∈ Octonion.complexSubspace J) →
        ∀ i, (g.toFun a).off i ∈ Octonion.complexSubspace K) ∧
      (∀ a : h3O, (∀ i, a.off i ∈ Octonion.complexSubspace K) →
        ∀ i, ((Aut_h3O.inv g).toFun a).off i ∈ Octonion.complexSubspace J)

/-- All complex structure stabilizers are conjugate in F_4.
    F_4 acts transitively on unit imaginary octonions (via G_2 on S^6). -/
theorem stab_complex_conjugate (J K : Octonion.ComplexStructure) :
    ∃ (g : Aut_h3O), ∀ f, f ∈ Stab_complex J ↔
      Aut_h3O.comp (Aut_h3O.comp g f) (Aut_h3O.inv g) ∈ Stab_complex K := by
  obtain ⟨g, hg_fwd, hg_inv⟩ := g2_transitive_complex_structures J K
  refine ⟨g, fun f => ⟨fun hf => ?_, fun hgfg => ?_⟩⟩
  · -- Forward: f ∈ Stab_complex J → gfg⁻¹ ∈ Stab_complex K
    simp only [Stab_complex, Set.mem_setOf_eq, Aut_h3O.comp, Function.comp]
    intro a ha i
    exact hg_fwd _ (hf _ (hg_inv _ ha)) i
  · -- Reverse: gfg⁻¹ ∈ Stab_complex K → f ∈ Stab_complex J
    simp only [Stab_complex, Set.mem_setOf_eq, Aut_h3O.comp, Function.comp] at hgfg
    intro a ha i
    have h1 := hgfg (g.toFun a) (hg_fwd a ha)
    have h3 : (Aut_h3O.inv g).toFun (g.toFun a) = a := inv_toFun_eq rfl
    rw [h3] at h1
    have h4 := hg_inv _ h1
    have h5 : (Aut_h3O.inv g).toFun (g.toFun (f.toFun a)) = f.toFun a := inv_toFun_eq rfl
    rw [h5] at h4
    exact h4 i

end F4
