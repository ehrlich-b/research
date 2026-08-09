/-
DIAGNOSTIC FILE — not part of the development.

Purpose: settle, in the kernel rather than by hand, whether the
`has_compression` axiom in `SelfModelingBridge.lean` renders this tree
inconsistent. `BLUEPRINT.md` §9 records the uninhabitedness of
`CompressionSystem` as established by reading three structure fields, but notes
that deriving `False` additionally needs a concrete `SelfModelingSystem`
instance to elaborate, and that this link "was derived by hand and NOT run
through `lake build`".

This file runs it.
-/
import RadicalRelativity.SelfModelingBridge
import RadicalRelativity.M2CInstance

noncomputable section

open OrderUnitSpace

namespace UnsoundnessCheck

/-- A concrete `SelfModelingSystem` on the tree's own concrete OUS
(`DiagOUS = Fin 2 → ℝ`), taking the tracking map to be the identity.
Every clause of `SelfModelingSystem` is satisfied trivially by `id`; the
`nontrivial` clause is witnessed by `(1, 0)`. -/
def diagSM : SelfModelingSystem DiagOUS where
  phi := id
  phi_unit := rfl
  phi_mono := fun h => h
  phi_inj := fun _ _ h => h
  phi_surj := fun b => ⟨b, rfl⟩
  phi_effect := fun h => h
  phi_inv_mono := fun h => h
  nontrivial := by
    refine ⟨fun i => if i = 0 then 1 else 0, ?_, ?_⟩
    · intro h
      have h' := congrFun h 0
      norm_num at h'
    · intro h
      have h' := congrFun h 1
      have hu : (𝟙 : DiagOUS) 1 = 1 := rfl
      rw [hu] at h'
      norm_num at h'

/-- The half-unit `½·𝟙`, which is an effect in any order unit space and in
particular here. This is the element the `compress_unit` field is quantified
over but for which Alfsen--Shultz compressions do not exist: A--S compressions
are defined for **projective units**, and `½·𝟙` is not one. -/
def halfUnit : DiagOUS := (1/2 : ℝ) • (𝟙 : DiagOUS)

theorem halfUnit_isEffect : IsEffect halfUnit := by
  rw [DiagOUS.isEffect_iff]
  intro i
  simp [halfUnit, OrderUnitSpace.ousUnit, DiagOUS.unit]
  norm_num

/-- The three offending fields, taken together, force `𝟙 = 0`. -/
theorem unit_eq_zero : (𝟙 : DiagOUS) = 0 := by
  set cs := has_compression DiagOUS diagSM with hcs
  -- `compress_unit` : C_p(𝟙) = p, applied at the non-projective effect p = ½𝟙
  have h1 : cs.compress halfUnit (𝟙 : DiagOUS) = halfUnit :=
    cs.compress_unit halfUnit_isEffect
  -- `compress_idem` at x = 𝟙, rewritten by h1
  have h2 : cs.compress halfUnit halfUnit = halfUnit := by
    have := cs.compress_idem halfUnit (𝟙 : DiagOUS)
    rw [h1] at this
    exact this
  -- `compress_smul` : C_p(½·𝟙) = ½·C_p(𝟙) = ½·(½𝟙)
  have h3 : cs.compress halfUnit halfUnit = (1/2 : ℝ) • halfUnit := by
    have := cs.compress_smul halfUnit (1/2 : ℝ) (𝟙 : DiagOUS)
    rw [h1] at this
    exact this
  -- so ½𝟙 = ¼𝟙, i.e. ½𝟙 = ½·(½𝟙); pointwise at index 0 this is 1/2 = 1/4
  have h4 : halfUnit = (1/2 : ℝ) • halfUnit := h2.symm.trans h3
  have h5 : halfUnit = 0 := by
    funext i
    have h6 := congrFun h4 i
    simp only [Pi.smul_apply, smul_eq_mul, Pi.zero_apply] at h6 ⊢
    linarith
  -- ½𝟙 = 0 ⟹ 𝟙 = 0
  have h7 : (1/2 : ℝ) • (𝟙 : DiagOUS) = 0 := h5
  have h2ne : (1/2 : ℝ) ≠ 0 := by norm_num
  exact (smul_eq_zero.mp h7).resolve_left h2ne

/-- **The tree is inconsistent.** `𝟙 = 0` in `DiagOUS` says `(1,1) = (0,0)`,
i.e. `(1 : ℝ) = 0`. -/
theorem tree_derives_false : False := by
  have h := unit_eq_zero
  have h' := congrFun h 0
  have hu : (𝟙 : DiagOUS) 0 = 1 := rfl
  rw [hu] at h'
  norm_num at h'

end UnsoundnessCheck

-- Axiom provenance of the contradiction.
#print axioms UnsoundnessCheck.tree_derives_false
#print axioms UnsoundnessCheck.unit_eq_zero
