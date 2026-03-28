-- Lean 4 formalization for "Faithful Self-Modeling Is Complex Quantum Mechanics"
-- Bryan Ehrlich, 2026
-- 0 sorry declarations, 4 axioms (3 published theorems + 1 bridge)

-- Foundations: order unit spaces, compressions, Peirce decomposition
import RadicalRelativity.OrderUnitSpace
import RadicalRelativity.Compression
import RadicalRelativity.PeirceDecomp
import RadicalRelativity.SpectralTheorem

-- Sequential product axioms (S1-S7)
import RadicalRelativity.SequentialProduct

-- Bridge: self-modeling construction → sequential product (Sections 3-4)
import RadicalRelativity.SelfModelingBridge

-- Jordan algebra structure (van de Wetering Theorem 1)
import RadicalRelativity.JordanStructure

-- Local tomography and type exclusion (Section 5)
import RadicalRelativity.LocalTomography

-- C*-algebra promotion (van de Wetering Theorem 3)
import RadicalRelativity.CStarBridge

-- Concrete models: S1-S7 verified from scratch (no axioms)
import RadicalRelativity.M2CInstance
import RadicalRelativity.SpinFactor
