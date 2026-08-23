/-
Copyright (c) 2026 Bryan Ehrlich. All rights reserved.
Released under Apache 2.0 license.
Authors: Bryan Ehrlich
-/
import RadicalRelativity.Albert.Inner

set_option linter.style.longLine false

/-!
# The Jordan identity on `h₃(𝕆)`

placeholder module docstring
-/

noncomputable section

namespace Octonion

/-! ## Octonionic input

Nine identities.  Each is a polynomial identity in the coordinates of the octonion
multiplication table and is proved by expanding it; none of them is assumed.
-/

/-- Polarised left alternativity: `x̄(xw) = N(x)w` linearised in `x`. -/
theorem polar_left_alt (u v w : Octonion) :
    mul (conj u) (mul v w) + mul (conj v) (mul u w) = (2 * octIp u v) • w := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

/-- Polarised right alternativity: `(wx)x̄ = N(x)w` linearised in `x`. -/
theorem polar_right_alt (u v w : Octonion) :
    mul (mul w u) (conj v) + mul (mul w v) (conj u) = (2 * octIp u v) • w := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

/-- `⟨x̄ā, x̄b̄⟩ = N(x)⟨a,b⟩`. -/
theorem octIp_mul_conj_left (u a b : Octonion) :
    octIp (mul (conj u) (conj a)) (mul (conj u) (conj b)) = octIp u u * octIp a b := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

/-- `⟨āx̄, b̄x̄⟩ = ⟨a,b⟩N(x)`. -/
theorem octIp_mul_conj_right (a b u : Octonion) :
    octIp (mul (conj a) (conj u)) (mul (conj b) (conj u)) = octIp a b * octIp u u := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

/-- `⟨(ā b̄)* c̄, b⟩ = N(b)⟨a,c⟩`. -/
theorem octIp_conj_mul_assoc_left (a b c : Octonion) :
    octIp (mul (conj (mul (conj a) (conj b))) (conj c)) b = octIp b b * octIp a c := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

/-- `⟨c̄ (b̄ ā)*, b⟩ = N(b)⟨a,c⟩`. -/
theorem octIp_conj_mul_assoc_right (a b c : Octonion) :
    octIp (mul (conj c) (conj (mul (conj b) (conj a)))) b = octIp b b * octIp a c := by
  simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue]; ring

set_option maxHeartbeats 1600000 in
/-- Polarised middle Moufang. -/
theorem polar_moufang (p q r s : Octonion) :
    mul (mul p r) (mul q s) + mul (mul s r) (mul q p)
        + (4 * octIp p s) • mul (conj q) (conj r)
      = mul (mul s (mul (conj p) (conj q))) (conj r)
        + mul (conj q) (mul (mul (conj r) (conj p)) s)
        + (4 * octIp (mul (conj q) (conj r)) s) • p := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

set_option maxHeartbeats 1600000 in
/-- Mixed Moufang, left form. -/
theorem mixed_moufang_left (p q r s : Octonion) :
    mul (mul p r) (mul s p) + (2 * octIp q s) • mul (conj q) (conj r)
        + (octIp p p - octIp q q) • mul (conj s) (conj r)
      = mul (conj q) (mul s (mul (conj q) (conj r)))
        + (2 * octIp (mul (conj r) (conj p)) s) • p := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

set_option maxHeartbeats 1600000 in
/-- Mixed Moufang, right form. -/
theorem mixed_moufang_right (p q r s : Octonion) :
    mul (mul p s) (mul q p) + (2 * octIp r s) • mul (conj q) (conj r)
        + (octIp p p - octIp r r) • mul (conj q) (conj s)
      = mul (mul (mul (conj q) (conj r)) s) (conj r)
        + (2 * octIp (mul (conj p) (conj q)) s) • p := by
  ext i; fin_cases i <;> simp [mul, conj, octIp, Fin.sum_univ_eight, Fin.isValue] <;> ring

end Octonion
