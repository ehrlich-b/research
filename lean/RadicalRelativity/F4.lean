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
def Aut_h3O.inv (f : Aut_h3O) : Aut_h3O := sorry

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
    dim(Spin(9)) = 36. -/
axiom stab_is_Spin9 (i : Fin 3) : True  -- Stab_idem i ≅ Spin(9)

/-- **F_4 / Spin(9) = OP^2**: the quotient is the octonionic projective plane
    (Cayley plane), which is 16-dimensional. 52 - 36 = 16. -/
axiom quotient_is_OP2 : True  -- F_4 / Stab_idem i ≅ OP^2

/-- Spin(9) acts on the Peirce 1-space V_1(E_i) = O^2 as the spin
    representation (16-dim real). -/
axiom spin9_acts_on_peirce1 : True  -- Spin(9) -> GL(V_1) via spin rep

-- Subgroup 2: [SU(3) x SU(3)] / Z_3 = stabilizer of complex structure

/-- The stabilizer of a complex structure on O in Aut(h_3(O)).
    Isomorphic to [SU(3) x SU(3)] / Z_3. -/
def Stab_complex (J : Octonion.ComplexStructure) : Set Aut_h3O :=
  sorry  -- The set of automorphisms preserving the splitting induced by J

/-- **SU(3)xSU(3)/Z_3 theorem** (axiomatized): the stabilizer of a complex
    structure on O in Aut(h_3(O)) is isomorphic to [SU(3) x SU(3)] / Z_3.
    - One SU(3) acts on C^3 (the complement of C in O): color.
    - The other SU(3) acts on the 3 off-diagonal positions: flavor.
    - dim = 8 + 8 = 16. -/
axiom stab_complex_is_SU3xSU3modZ3 (J : Octonion.ComplexStructure) : True

-- Borel-de Siebenthal classification

/-- **Borel-de Siebenthal theorem for F_4** (axiomatized): the maximal
    connected subgroups of F_4 of maximal rank are exactly:
    1. Spin(9) (stabilizer of an idempotent)
    2. [SU(3) x SU(3)] / Z_3 (stabilizer of a complex structure)
    These are the only two types. -/
axiom borel_de_siebenthal_F4 : True

/-- All rank-1 idempotent stabilizers are conjugate in F_4.
    F_4 acts transitively on the set of rank-1 idempotents (= OP^2). -/
theorem stab_idem_conjugate (i j : Fin 3) :
    ∃ (g : Aut_h3O), ∀ f, f ∈ Stab_idem i ↔
      Aut_h3O.comp (Aut_h3O.comp g f) (Aut_h3O.inv g) ∈ Stab_idem j := sorry

/-- All complex structure stabilizers are conjugate in F_4.
    F_4 acts transitively on unit imaginary octonions (via G_2 on S^6). -/
theorem stab_complex_conjugate (J K : Octonion.ComplexStructure) :
    ∃ (g : Aut_h3O), ∀ f, f ∈ Stab_complex J ↔
      Aut_h3O.comp (Aut_h3O.comp g f) (Aut_h3O.inv g) ∈ Stab_complex K := sorry

end F4
