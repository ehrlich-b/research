-- Radical Relativity: Lean 4 Formalization
-- From self-modeling to the Standard Model gauge group.

-- Papers 1-4: Experiential Measure (SCAFFOLD)
import RadicalRelativity.ExperientialMeasure

-- Paper 5: Self-Modeling → QM (FORMALIZED, 0 sorry's, 6 axioms)
-- Bridge: self-modeling premise → sequential product axioms
import RadicalRelativity.SelfModelingBridge
import RadicalRelativity.OrderUnitSpace
import RadicalRelativity.SequentialProduct
import RadicalRelativity.Compression
import RadicalRelativity.PeirceDecomp
import RadicalRelativity.JordanStructure
import RadicalRelativity.LocalTomography
import RadicalRelativity.CStarBridge
import RadicalRelativity.SpectralTheorem

-- Paper 5: Concrete models (S1-S7 verified from scratch)
import RadicalRelativity.M2CInstance
import RadicalRelativity.SpinFactor

-- Paper 6: Self-Modeling Lattice → GR (SCAFFOLD)
import RadicalRelativity.SelfModelingLattice
import RadicalRelativity.AreaLaw
import RadicalRelativity.JacobsonGR

-- Paper 7: h_3(O) → SM Gauge Group (SCAFFOLD)
import RadicalRelativity.Octonions
import RadicalRelativity.Albert
import RadicalRelativity.NonComposability
import RadicalRelativity.UniverseAlgebra
import RadicalRelativity.F4
import RadicalRelativity.ObserverInterface
import RadicalRelativity.GaugeGroup
import RadicalRelativity.Chirality
import RadicalRelativity.RhoJ
