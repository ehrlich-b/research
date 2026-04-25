# Velocity Hierarchy and Emergent Causal Structure

% ASSERT_CONVENTION: natural_units=natural, metric_signature=Riemannian_Fisher, coupling_convention=J_gt_0_AFM, fisher_metric=SLD_4xBures, sigma_model_field=O3_n_field

**Phase 34, Plan 02 -- Derivation Document**
**Date:** 2026-03-30

## Overview

This document establishes three results for the emergent spacetime structure:

- **Velocity hierarchy:** $v_{\text{LR}} \gg c_s = c_{\text{eff}}$ with explicit numerical ratio $v_{\text{LR}}/c_s \approx 7.6$
- **Identification of $c_{\text{eff}}$:** Four independent arguments why $c_{\text{eff}} = c_s$ (not $v_{\text{LR}}$)
- **Metric assembly:** Emergent Lorentzian metric $ds^2 = -c_s^2\, dt^2 + g_{ij}(x)\, dx^i dx^j$ from Fisher (spatial) + sigma model (temporal)
- **Two-tier causal structure:** Fundamental (LR, lattice) containing effective (Lorentzian, continuum)

**Starting point:** The O(3) NL sigma model from Phase 33, Eq. (33.11):
$$
S_{\text{eff}} = \frac{1}{2g} \int d^dx\, d\tau \left[\frac{(\partial_\tau \mathbf{n})^2}{c_s^2} + (\nabla \mathbf{n})^2\right], \quad \mathbf{n}^2 = 1
\tag{33.11}
$$
with $c_s = \sqrt{\rho_s/\chi_\perp} = 1.659\, Ja$ (Phase 33, Eq. (33.14); QMC: $1.65880(6)\, Ja$, Sandvik 2025).

---

## Part I: Three Velocities

### Definition 1: The Lieb-Robinson velocity $v_{\text{LR}}$

The Lieb-Robinson velocity is a **rigorous upper bound** on the speed at which correlations can spread in a lattice system with local interactions. For operators $O_A$, $O_B$ supported on separated regions $A$, $B$ at distance $d(A,B)$, the Lieb-Robinson bound states (Nachtergaele & Sims, CMP 265, 119, 2006; math-ph/0603064):

$$
\|[O_A(t), O_B(0)]\| \leq C\, \|O_A\| \|O_B\| \min(|A|,|B|)\, e^{-\mu(d(A,B) - v_{\text{LR}}|t|)}
\tag{34.1}
$$

This bound holds for any Hamiltonian $H = \sum_X h_X$ with finite-range, bounded-norm local terms. It establishes an effective light cone: correlations are exponentially suppressed outside the cone $d(A,B) > v_{\text{LR}}|t|$.

For the SWAP/Heisenberg Hamiltonian on $\mathbb{Z}^1$, the explicit LR velocity is (Paper 6, Phase 8):

$$
v_{\text{LR}} = \frac{8eJ}{e - 1} \approx 12.66\, J
\tag{34.2}
$$

**Units:** With $\hbar = 1$ and lattice spacing $a = 1$, $v_{\text{LR}}$ has units of $J$ (energy), which equals $[a/\text{time}] = [\text{velocity}]$ in natural units. When $a \neq 1$: $[v_{\text{LR}}] = [Ja/\hbar] = [\text{length}/\text{time}]$.

**What $v_{\text{LR}}$ includes:** The LR bound applies to ALL operators, not just low-energy ones. It bounds the fastest possible signal, including non-universal lattice-scale effects: multi-magnon scattering, UV modes near the zone boundary ($k \sim \pi/a$), and short-distance correlation spreading. These contributions have no counterpart in the continuum effective theory.

### Definition 2: The spin-wave velocity $c_s$

The spin-wave velocity is the **physical speed** of the low-energy excitations (magnons / Goldstone modes). From Phase 33, Eq. (33.14):

$$
c_s = \sqrt{\rho_s / \chi_\perp} = 1.659\, Ja
\tag{34.3}
$$

where $\rho_s = 0.181\, J$ is the spin stiffness and $\chi_\perp = 0.0657/J$ is the transverse susceptibility (QMC: $c_s = 1.65880(6)\, Ja$, Sandvik 2025).

**Units:** $[c_s] = [Ja]$. When $a = 1$: $c_s = 1.659\, J$, same units as $v_{\text{LR}}$.

**What $c_s$ describes:** The magnon dispersion relation is $\omega_{\mathbf{k}} = c_s|\mathbf{k}|$ for $|\mathbf{k}| \ll \pi/a$ (the linear, isotropic regime). This is the universal speed at which information propagates in the effective field theory. All low-energy excitations travel at speed $c_s$.

### Definition 3: The emergent speed of light $c_{\text{eff}}$

The emergent speed of light is the **invariant speed** of the emergent Lorentz group. It enters the Lorentzian effective theory as the speed appearing in the line element $ds^2 = -c_{\text{eff}}^2 dt^2 + d\mathbf{x}^2$. We will now show:

$$
c_{\text{eff}} = c_s = 1.659\, Ja
\tag{34.4}
$$

### The velocity hierarchy

**Numerical values (at $a = 1$):**

$$
v_{\text{LR}} = 12.66\, J, \quad c_s = 1.659\, J, \quad \frac{v_{\text{LR}}}{c_s} = 7.63
\tag{34.5}
$$

SELF-CRITIQUE CHECKPOINT (step 1):
1. SIGN CHECK: No sign changes in ratios. Expected: 0. Actual: 0.
2. FACTOR CHECK: No factors of 2, pi, hbar introduced. v_LR/c_s = pure numerical ratio.
3. CONVENTION CHECK: Units J with a=1, hbar=1. Matches convention lock.
4. DIMENSION CHECK: [v_LR/c_s] = [J/(Ja)] = [1/a] = [1] when a=1. Dimensionless. Correct.

**Physical content of $v_{\text{LR}} \gg c_s$:**

- $v_{\text{LR}}$ bounds ALL signals, including non-universal lattice-scale effects. These are "superluminal" from the effective-theory perspective but perfectly physical from the lattice perspective.
- $c_s$ governs the universal low-energy excitations (magnons in the linear dispersion regime $k \ll \pi/a$). These are the only excitations present in the NL sigma model effective theory.
- The ratio $v_{\text{LR}}/c_s \approx 7.6$ is **order one**, as expected: both velocities are set by the same energy scale $J$, with $O(1)$ numerical prefactors. There is no parametric separation (no power of a large or small parameter).
- The inequality $v_{\text{LR}} \geq c_s$ is **guaranteed** by the Lieb-Robinson theorem: $v_{\text{LR}}$ is a strict upper bound on ALL signal propagation including UV contributions, while $c_s$ is the physical propagation speed of low-energy magnons only. Since magnon propagation is a special case of general signal propagation, $v_{\text{LR}} \geq c_s$ follows as a theorem-level result (Nachtergaele-Sims 2006).

**Precedent: Hamma, Markopoulou, Premont-Schwarz, Severini (PRL 102, 017204, 2009; arXiv:0808.2495).**
For the toric code on a 2D square lattice, Hamma et al. showed $v_{\text{LR}} > c_{\text{photon}}$ with:
$$
\frac{v_{\text{LR}}}{c_{\text{photon}}} = \sqrt{2}\, e \approx 3.84
\tag{34.6}
$$
(their Eq. 13). The emergent photon speed $c_{\text{photon}}$ is set by the gap structure and dispersion of gauge excitations, not by $v_{\text{LR}}$. The same pattern holds here: the emergent speed $c_s$ is set by the effective theory, not by the lattice bound. Our ratio (7.63) is larger than theirs (3.84), reflecting different microscopic physics (Neel vs topological order), but the qualitative hierarchy $v_{\text{LR}} > c_{\text{eff}}$ is universal for lattice systems.

---

## Part II: Why $c_{\text{eff}} = c_s$ (Not $v_{\text{LR}}$)

We give four independent arguments.

### Argument (a): Dispersion relation

The magnon dispersion relation is $\omega_{\mathbf{k}} = c_s |\mathbf{k}|$ for $|\mathbf{k}| \ll \pi/a$. This is the relativistic dispersion relation $E = c\, p$ with $c = c_s$. All low-energy excitations propagate at speed $c_s$, and no low-energy excitation propagates faster.

In a Lorentz-invariant theory, the invariant speed $c$ is defined by the dispersion relation of massless particles: $E = cp$. The magnons ARE the massless particles of the effective theory (Goldstone modes of SU(2) $\to$ U(1) breaking). Their speed $c_s$ IS the invariant speed of the emergent Lorentz group.

### Argument (b): Effective field theory

The NL sigma model action (Eq. 33.11) is manifestly Lorentz-invariant with speed $c_s$ after the rescaling $\tau' = \tau/c_s$:
$$
S_{\text{eff}} = \frac{1}{2g} \int d^dx\, d\tau' \left[(\partial_{\tau'} \mathbf{n})^2 + (\nabla \mathbf{n})^2\right]
\tag{34.7}
$$
which has O($d+1$) Euclidean symmetry, hence SO($d$,1) Lorentz symmetry after Wick rotation. The speed $v_{\text{LR}}$ does **not** appear in the effective Lagrangian at any order. Only $c_s$ sets the causal structure within the EFT.

### Argument (c): Universality

$c_s = \sqrt{\rho_s/\chi_\perp}$ is a **universal** quantity: it is determined by the universality class (long-distance physics) and is independent of microscopic details beyond the infrared parameters $\rho_s$ and $\chi_\perp$.

$v_{\text{LR}} = 8eJ/(e-1)$ is **non-universal**: it depends on the specific microscopic Hamiltonian --- the interaction range, coupling constant, and detailed form of $H$. Different lattice realizations in the same universality class would have different $v_{\text{LR}}$ but the same $c_s$.

The emergent speed of light, being a feature of the universal low-energy theory, must itself be universal. Therefore $c_{\text{eff}} = c_s$.

### Argument (d): Hamma et al. precedent

In the toric code (Hamma et al. 2009), the emergent photon speed $c_{\text{photon}}$ is determined by the gap structure and dispersion of the gauge excitations --- the effective theory parameters --- not by $v_{\text{LR}}$. The same logic applies to our system: the emergent speed is set by the effective theory (sigma model with speed $c_s$), not by the lattice bound ($v_{\text{LR}}$).

### Conclusion

$$
\boxed{c_{\text{eff}} = c_s = 1.659\, Ja}
\tag{34.8}
$$

The emergent Lorentz group has invariant speed $c_s$. Excitations at the lattice scale ($k \sim \pi/a$) can exceed $c_s$ but are not part of the effective theory; they are "trans-Planckian" from the emergent-spacetime perspective.

---

## Part III: Emergent Metric Assembly

### The emergent spacetime metric

The emergent spacetime metric combines two independently derived structures:

$$
ds^2 = -c_s^2\, dt^2 + g_{ij}(x)\, dx^i dx^j
\tag{34.9}
$$

where:
- $c_s = 1.659\, Ja$ is the emergent speed of light (Part II above)
- $g_{ij}(x)$ is the Fisher metric on the space of reduced states (Phase 32)
- $t$ is the physical time (from Wick rotation of the Euclidean sigma model time)

### Source of each component

**Temporal part $(-c_s^2\, dt^2)$:** Comes from the NL sigma model structure. The Euclidean action (Eq. 33.11) has the rescaled time $\tau' = \tau/c_s$ appearing symmetrically with $x^i$, giving O($d+1$) symmetry (Eq. 34.7). Wick rotation $\tau' \to it$ yields the Minkowski signature with speed $c_s$. This temporal structure is a consequence of the sigma model dynamics, NOT from the Fisher metric.

**Spatial part $(g_{ij}\, dx^i dx^j)$:** Comes from the Fisher metric on the manifold of reduced states $\rho_A(x)$. Phase 32 established: $g_{ij}$ is smooth and positive-definite for OBC in the gapped phase (FISH-01/02). Phase 33, Plan 03 (CORR-03) established: $g_F \sim O(m_s^2) > 0$ for the Neel phase in $d \geq 2$, with the conditional theorem (hypotheses H1--H4). The Fisher metric captures the distinguishability geometry of neighboring quantum states --- the information-geometric distance between reduced density matrices at different spatial positions.

**Connection between them:** In the homogeneous case (translation-invariant sigma model on a flat lattice), $g_{ij} = \delta_{ij}$ and the metric reduces to the flat Minkowski metric:
$$
ds^2 = -c_s^2\, dt^2 + \delta_{ij}\, dx^i dx^j
\tag{34.10}
$$
On an inhomogeneous background (position-dependent parameters), $g_{ij}$ inherits the curvature of the state manifold and the emergent metric becomes curved.

### Signature verification

- $g_{00} = -c_s^2 < 0$ (timelike): from the Wick rotation of the Euclidean sigma model
- $g_{ij} > 0$ (positive-definite): from the Fisher metric (Phase 32, strictly positive at interior for OBC; Phase 33 CORR-03, $O(m_s^2) > 0$ for Neel $d \geq 2$)
- **Signature: $(-,+,\ldots,+)$ = Lorentzian**

$$
\text{sgn}(g_{\mu\nu}) = (-,\underbrace{+,\ldots,+}_{d}), \quad d = \text{spatial dimension}
\tag{34.11}
$$

SELF-CRITIQUE CHECKPOINT (step 2):
1. SIGN CHECK: Temporal component negative (from -c_s^2). Spatial positive (from Fisher). No sign errors.
2. FACTOR CHECK: c_s^2 in temporal part, not c_s. Consistent with standard metric convention ds^2 = -c^2 dt^2 + dx^2.
3. CONVENTION CHECK: Signature (-,+,...,+) matches plan convention. Fisher metric is spatial only (no temporal index). Consistent with convention lock (Riemannian Fisher metric for spatial part).
4. DIMENSION CHECK: [-c_s^2 dt^2] = [J^2 a^2 * (1/J)^2] = [a^2] = [length^2]. [g_ij dx^i dx^j] = [a^2]. Consistent.

### What this metric does NOT give

- It does NOT give the full dynamical metric (that requires Einstein equations, which is Phase 36).
- It does NOT incorporate back-reaction or fluctuations of the metric.
- It IS the background emergent metric on which the effective theory propagates.
- The Fisher metric is the **kinematic** spatial geometry; the sigma model provides the **kinematic** temporal geometry.
- The metric assembly Eq. (34.9) is schematic in the sense that the Fisher metric $g_{ij}$ and the sigma model time come from different frameworks (density matrices vs field theory). Their precise coupling is physical intuition supported by the structure of both theories, not a theorem. This is noted as an uncertainty marker.

---

## Part IV: Two-Tier Causal Structure

### Tier 1: Fundamental (Lattice)

The Lieb-Robinson bound (Eq. 34.1) defines a strict causal cone with velocity $v_{\text{LR}} = 12.66\, J$. This is **exact** up to exponentially small tails: correlations decay as $e^{-\mu(d - v_{\text{LR}}t)}$ outside the cone. No signal of any kind --- including lattice-scale, non-universal, UV effects --- can propagate faster than $v_{\text{LR}}$ on the lattice.

**Properties of the Tier 1 causal structure:**
- **Exact** (rigorous theorem, not approximation)
- **Non-Lorentzian**: respects lattice symmetry (e.g., $C_4$ for square lattice), not SO($d$,1)
- **Includes UV:** bounds all modes, including non-universal lattice-scale physics
- **Speed:** $v_{\text{LR}} = 12.66\, J$ (for SWAP on $\mathbb{Z}^1$)

### Tier 2: Effective (Continuum)

The NL sigma model effective theory defines an effective causal cone with velocity $c_s = 1.659\, Ja$. This is **approximate**, valid for low-energy excitations in the continuum limit ($k \ll \pi/a$). The effective causal structure IS Lorentz-invariant (Eqs. 34.7--34.8).

**Properties of the Tier 2 causal structure:**
- **Approximate** (valid in continuum limit $k \ll \pi/a$, breaks at lattice scale)
- **Lorentzian**: respects SO($d$,1) symmetry (emergent from sigma model, Eq. 34.7)
- **Excludes UV:** only describes universal low-energy magnon physics
- **Speed:** $c_s = 1.659\, Ja$ (emergent speed of light)

### Nesting

The effective light cone is strictly inside the LR light cone:
$$
c_s < v_{\text{LR}} \quad \Longrightarrow \quad \text{Lorentzian cone} \subset \text{LR cone}
\tag{34.12}
$$

This means: every process allowed by the effective theory (within the $c_s$ cone) is also allowed by the fundamental lattice causal structure (within the $v_{\text{LR}}$ cone). There are processes allowed by the lattice (between the $c_s$ and $v_{\text{LR}}$ cones) that have no description in the effective theory --- these are the trans-Planckian processes.

### Analogy

This is exactly analogous to sound cones in condensed matter physics:
- Sound propagates at speed $c_{\text{sound}} \ll c$ (speed of light)
- The fundamental causal structure is set by $c$ (electromagnetic LR bound)
- From the perspective of phonon physics, $c_{\text{sound}}$ is the "speed of light"
- Our system: magnons propagate at $c_s$ (sound-like), the lattice LR bound is at $v_{\text{LR}}$ (analogous to the fundamental speed of light)

For the emergent gravity program: the effective theory "sees" only the $c_s$ light cone, just as a low-energy observer in the emergent spacetime would see only the Lorentzian causal structure. The lattice-scale LR bound $v_{\text{LR}}$ is invisible at the level of the effective theory.

---

## Consequence for the v9.0 Chain

| Phase | Provides | Equation |
|-------|----------|----------|
| Phase 32 | Smooth Riemannian spatial metric $g_{ij}$ (Fisher) | FISH-01/02 |
| Phase 33 | NL sigma model with $c_s = 1.659\, Ja$ | Eq. (33.14) |
| Phase 34 (this) | Lorentzian structure $ds^2 = -c_s^2 dt^2 + g_{ij} dx^i dx^j$; causal structure from LR bounds | Eq. (34.9) |
| Phase 35 (next) | Bisognano-Wichmann theorem applied to this Lorentz-invariant theory | Requires Lorentz invariance from Phase 34 |
| Phase 36 | Assembly with Jacobson argument for emergent Einstein equations | Requires metric + thermodynamics |

---

## Summary Table: Three Velocities

| Velocity | Value | Units | Source | Role |
|----------|-------|-------|--------|------|
| $v_{\text{LR}}$ | $8eJ/(e-1) \approx 12.66\, J$ | $J$ (at $a = 1$) | Paper 6; Nachtergaele-Sims 2006 | Fundamental causal bound (Tier 1) |
| $c_s$ | $1.659\, Ja$ | $Ja$ (at $a = 1$: $J$) | Phase 33, CHN 1989, QMC | Physical magnon speed |
| $c_{\text{eff}}$ | $= c_s = 1.659\, Ja$ | $Ja$ (at $a = 1$: $J$) | This derivation (Part II) | Emergent speed of light (Tier 2) |
| $v_{\text{LR}}/c_s$ | $\approx 7.63$ | dimensionless | This derivation (Part I) | UV/IR separation measure |

---

**Numerical verification (Level 5):**
```python
import math
e = math.e
v_LR = 8*e/(e-1)        # = 12.6558 J
c_s  = 1.65880           # Ja (QMC, a=1)
ratio = v_LR / c_s       # = 7.6295
# v_LR > c_s: True
# Hamma et al.: sqrt(2)*e = 3.8442
```

---

_Phase: 34-emergent-lorentz-invariance_
_Plan: 02_
_Completed: 2026-03-30_
