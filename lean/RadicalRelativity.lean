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

-- Paper 5 (redesign): twist normal form + selection landing sites (statement-level scaffold)
import RadicalRelativity.TwistNormalForm

-- Paper 5 (redesign), Part II selection: block-restricted equidistribution (lem:equidistribution)
import RadicalRelativity.Selection.Equidistribution
import RadicalRelativity.Selection.NormalFormExistence
import RadicalRelativity.Selection.SelectorEquivalence
import RadicalRelativity.Selection.Descent
import RadicalRelativity.Selection.TwistIsotropy

-- Paper 5 (redesign), Part I type exclusion: base-equality dichotomy (prop:diachronic)
import RadicalRelativity.Selection.BaseEquality

-- Master theorem chain (twist-normal-form paper, mthm:master): de-ansatzed
-- comparison-map route. Foundation module (abstract interface + axiom ledger).
import RadicalRelativity.MasterTheorem.Interface
-- D3 coalescence (lem:coalescence) from Θ_fix + FK simultaneous diagonalization.
import RadicalRelativity.MasterTheorem.Coalescence
-- Diagonal homomorphism (lem:homomorphism): χ extension, hyperplane
-- factorization, toStabilizerCoupling (declares ledger axiom A2).
import RadicalRelativity.MasterTheorem.DiagonalHom
-- The four typewise branches (prop:real, thm:quaternionic, thm:albert declares
-- ledger axiom A4, thm:complex per-frame).
import RadicalRelativity.MasterTheorem.Branches.Real
import RadicalRelativity.MasterTheorem.Branches.Quaternionic
import RadicalRelativity.MasterTheorem.Branches.Albert
import RadicalRelativity.MasterTheorem.Branches.Complex
-- Complex-type globalization (thm:complex, global step): single global t.
import RadicalRelativity.MasterTheorem.Globalization
-- Complex-type adapter: binds Branches/Complex per-frame t_F to Globalization.
import RadicalRelativity.MasterTheorem.Adapter
-- Whole-chain assembly (mthm:master): #print axioms = exactly A1/A2/A4 + core.
import RadicalRelativity.MasterTheorem.Master
-- Rank-two boundary (prop:n2-necessity, thm:qubit-boundary core, rem:n2-selection).
import RadicalRelativity.MasterTheorem.RankTwo

-- Paper 6: Self-Modeling Lattice → GR (SCAFFOLD)
import RadicalRelativity.SelfModelingLattice
import RadicalRelativity.AreaLaw
import RadicalRelativity.JacobsonGR

-- Paper 7: h_3(O) → SM Gauge Group (SCAFFOLD)
import RadicalRelativity.Octonions
import RadicalRelativity.OctonionNucleus
import RadicalRelativity.OctonionTrace
import RadicalRelativity.Albert
import RadicalRelativity.NonComposability
import RadicalRelativity.UniverseAlgebra
import RadicalRelativity.F4
import RadicalRelativity.ObserverInterface
import RadicalRelativity.GaugeGroup
import RadicalRelativity.Chirality
import RadicalRelativity.RhoJ

-- Albert algebra, landing-grade rebuild (Layer 1): the 27-dimensional carrier, the Jordan
-- product as a bundled bilinear map, and the trace form with the Euclidean hypothesis
-- `hassoc`. Separate from the older expository RadicalRelativity.Albert, which is left alone.
-- The Jordan identity is deliberately absent; nothing here assumes it.
import RadicalRelativity.Albert.Carrier
import RadicalRelativity.Albert.Mul
import RadicalRelativity.Albert.Inner
