# Lieb-Robinson Bound Framework (Nachtergaele-Sims Formulation)

% ASSERT_CONVENTION: natural_units=natural, metric_signature=mostly_minus, hamiltonian_sign=H_min_energy, lattice_spacing=1, entropy_base=nats

## Purpose

Self-contained reference for the Lieb-Robinson (LR) bound computation pipeline, instantiated
for nearest-neighbor interactions on lattice graphs. Derived from the Nachtergaele-Sims-Young
framework [1] adapted to the conventions of this project. Used in Phase 08 (locality
formalization) and downstream phases.

**This file does NOT re-derive the LR bound.** The bound is a deep result (Lieb-Robinson 1972 [2],
refined by Nachtergaele-Sims 2006 [3], systematized in Nachtergaele-Sims-Young 2019 [1]).
We invoke it as a black box and instantiate it for our setup.

## 1. The Nachtergaele-Sims Lieb-Robinson Bound

**Setting.** A quantum lattice system on a graph $G = (V, E)$:
- Each vertex $x \in V$ carries a finite-dimensional Hilbert space $\mathcal{H}_x$
  (for us, $\mathcal{H}_x \cong \mathbb{C}^n$ so the local algebra is $A_x = M_n(\mathbb{C})$)
- The interaction $\Phi$ assigns to each finite subset $X \subset V$ a self-adjoint operator
  $\Phi(X) \in A_X = \bigotimes_{x \in X} A_x$
- The Hamiltonian is $H = \sum_{X \subset V} \Phi(X)$
- Heisenberg evolution: $\tau_t(A) = e^{iHt} A e^{-iHt}$

**Theorem (Nachtergaele-Sims-Young [1], cf. Theorem 3.4; Nachtergaele-Sims [3], Corollary 3.5).**
Let $F_a : [0, \infty) \to (0, \infty)$ be a nonincreasing function (the *F-function*)
parameterized by a decay parameter $a > 0$. Define:

$$C_a := \sup_{x \in V} \sum_{y \in V, \, y \neq x} F_a(d(x, y))
\qquad \text{(convolution constant)} \tag{1}$$

$$\|\Phi\|_a := \sup_{x \in V} \sum_{X \ni x} \frac{\|\Phi(X)\|}{\min_{y \in X} F_a(d(x, y))}
\qquad \text{(weighted interaction norm)} \tag{2}$$

For nearest-neighbor interactions where $\Phi(X) = 0$ unless $|X| = 2$ and $X = \{x, y\}$
with $\{x,y\} \in E$, the norm simplifies to:

$$\|\Phi\|_a = \sup_{x \in V} \sum_{y : \{x,y\} \in E} \frac{\|\Phi(\{x,y\})\|}{F_a(d(x,y))}
= \sup_{x \in V} \sum_{y : \{x,y\} \in E} \frac{\|h_{xy}\|}{F_a(1)} \tag{2'}$$

Then for observables $A$ supported on $X \subset V$ and $B$ supported on $Y \subset V$:

$$\|[\tau_t(A), B]\| \leq 2\|A\| \, \|B\| \cdot \min\left\{1, \,
\frac{1}{C_a}\left(e^{2\|\Phi\|_a C_a |t|} - 1\right)
\sum_{x \in X} \sum_{y \in Y} F_a(d(x,y))\right\} \tag{3}$$

**References:**
- [1] Nachtergaele, Sims, Young, J. Math. Phys. 60, 061101 (2019), arXiv:1810.02428
- [2] Lieb, Robinson, Commun. Math. Phys. 28, 251 (1972)
- [3] Nachtergaele, Sims, Commun. Math. Phys. 265, 119 (2006), arXiv:math-ph/0506030

## 2. LR Velocity

For single-site observables ($X = \{x\}$, $Y = \{y\}$) with exponential F-function,
the bound (3) becomes:

$$\|[\tau_t(A_x), B_y]\| \leq \frac{2\|A\| \, \|B\|}{C_a}
\left(e^{2\|\Phi\|_a C_a |t|} - 1\right) e^{-a \, d(x,y)} \tag{4}$$

Define the **LR velocity** for decay parameter $a$:

$$v_{LR}(a) := \frac{2\|\Phi\|_a \, C_a}{a} \tag{5}$$

The bound (4) is exponentially small for $d(x,y) > v_{LR}(a) |t|$, establishing an
effective light cone with slope $v_{LR}(a)$ and spatial decay rate $a$ outside the cone.

**Important:** The NS framework gives a *family* of bounds parameterized by $a > 0$.
For a given distance-time pair $(d, t)$, the tightest bound comes from optimizing over $a$.
On $\mathbb{Z}^1$ with exponential F-function, $v_{LR}(a)$ is monotonically decreasing
in $a$ (see Section 6), so smaller $a$ gives a wider but more strongly suppressed cone,
while larger $a$ gives a narrower cone with weaker suppression (larger prefactor $\sim 1/C_a$).

The optimal $a$ for fixed $(d, t)$ balances cone width against suppression strength.

## 3. Choice of F-Function

For nearest-neighbor interactions (range 1) on any lattice with bounded coordination number,
the standard choice is the exponential F-function:

$$F_a(r) = e^{-ar}, \quad r \geq 0, \quad a > 0 \tag{6}$$

This is the simplest F-function that gives finite $C_a$ on any lattice with bounded coordination
number. Other choices (e.g., $F_a(r) = (1+r)^{-\alpha}$ for power-law interactions) are needed
for long-range interactions but are not required here.

## 4. Convolution Constant $C_a$ for Cubic Lattices

With $F_a(r) = e^{-ar}$ and the graph distance $d(x,y) = \|x - y\|_1$ (Manhattan distance
on $\mathbb{Z}^d$):

$$C_a = \sup_{x \in \mathbb{Z}^d} \sum_{y \neq x} e^{-a \|x-y\|_1}
= \sum_{y \neq 0} e^{-a \|y\|_1} \tag{7}$$

where the second equality uses translation invariance of $\mathbb{Z}^d$.

### $\mathbb{Z}^1$:

$$C_a = 2\sum_{r=1}^{\infty} e^{-ar}
= \frac{2e^{-a}}{1 - e^{-a}} = \frac{2}{e^a - 1} \tag{8}$$

Dimensional check: $[C_a] = \text{dimensionless}$ (sum of dimensionless terms). $\checkmark$

Convergence: geometric series converges for $a > 0$. $\checkmark$

### $\mathbb{Z}^d$ (general):

The sum factors into $d$ independent sums over each coordinate:

$$\sum_{y \in \mathbb{Z}^d} e^{-a\|y\|_1} = \prod_{i=1}^{d} \sum_{y_i \in \mathbb{Z}} e^{-a|y_i|}
= \prod_{i=1}^{d} \left(1 + \frac{2}{e^a - 1}\right)
= \left(\frac{e^a + 1}{e^a - 1}\right)^d \tag{9}$$

Therefore:

$$C_a = \left(\frac{e^a + 1}{e^a - 1}\right)^d - 1 = \left(\coth\frac{a}{2}\right)^d - 1 \tag{10}$$

Verification for $d = 1$: $C_a = (e^a + 1)/(e^a - 1) - 1 = 2/(e^a - 1)$. $\checkmark$

### Explicit values at $a = 1$:

| Lattice | $C_1$ | Numerical |
|---------|-------|-----------|
| $\mathbb{Z}^1$ | $2/(e-1)$ | $1.1640$ |
| $\mathbb{Z}^2$ | $\left(\frac{e+1}{e-1}\right)^2 - 1$ | $3.6827$ |
| $\mathbb{Z}^3$ | $\left(\frac{e+1}{e-1}\right)^3 - 1$ | $9.1331$ |

## 5. Interaction Norm $\|\Phi\|_a$ for Nearest-Neighbor Interactions

For nearest-neighbor interactions $\Phi(\{x,y\}) = h_{xy}$ with uniform coupling
$\|h_{xy}\| = J$ for all edges $\{x,y\} \in E$, and $\Phi(X) = 0$ for $|X| \neq 2$:

$$\|\Phi\|_a = \sup_x \sum_{y : \{x,y\} \in E} \frac{J}{F_a(1)}
= z \cdot J \cdot e^{a} \tag{11}$$

where $z$ is the coordination number (number of nearest neighbors per site):
- $\mathbb{Z}^1$: $z = 2$
- $\mathbb{Z}^2$: $z = 4$
- $\mathbb{Z}^3$: $z = 6$

Dimensional check: $[\|\Phi\|_a] = [J] \cdot [\text{dimensionless}] = [\text{energy}]$. $\checkmark$

## 6. LR Velocity Formula

Combining (5), (10), (11):

$$v_{LR}(a) = \frac{2 z J e^a}{a} \left[\left(\coth\frac{a}{2}\right)^d - 1\right] \tag{12}$$

### $\mathbb{Z}^1$:

$$v_{LR}(a) = \frac{2 \cdot 2 \cdot J e^a}{a} \cdot \frac{2}{e^a - 1}
= \frac{8 J e^a}{a(e^a - 1)} \tag{13}$$

**Monotonicity analysis.** Define $g(a) := e^a / [a(e^a - 1)]$. Then:

$$g'(a) = \frac{e^a(1 - a - e^a)}{[a(e^a - 1)]^2}$$

Since $1 - a - e^a < 0$ for all $a > 0$, we have $g'(a) < 0$: the function $v_{LR}(a)$
is **strictly monotonically decreasing** on $(0, \infty)$.

**Consequences:**
- $v_{LR}(a) \to \infty$ as $a \to 0^+$ (F-function decays too slowly)
- $v_{LR}(a) \to 0$ as $a \to \infty$ (but the prefactor $1/C_a$ blows up)
- There is **no finite minimizer** for $v_{LR}(a)$ on $\mathbb{Z}^1$

This is standard behavior for the NS exponential F-function on $\mathbb{Z}^1$. The lack of
a finite minimizer means the NS bound provides a continuous family of light cones
$(v_{LR}(a), a)$ trading off cone width for decay strength. For any target distance $d$
and time $t$, the tightest bound is obtained by optimizing $a$ for that specific $(d, t)$.

### Representative values for $\mathbb{Z}^1$, $J = 1$:

| $a$ | $C_a$ | $\|\Phi\|_a$ | $v_{LR}(a)$ |
|-----|--------|---------------|--------------|
| 0.5 | 3.083 | 3.297 | 40.66 |
| 1.0 | 1.164 | 5.437 | 12.66 |
| 1.5 | 0.574 | 8.963 | 6.87 |
| 2.0 | 0.313 | 14.78 | 4.63 |
| 3.0 | 0.105 | 40.17 | 2.81 |

## 7. Comparison with Classical Lieb-Robinson Velocity

The original Lieb-Robinson bound [2] (via Dyson series expansion) gives for nearest-neighbor
interactions on a lattice with coordination $z$:

$$\|[\tau_t(A_x), B_y]\| \leq 2\|A\|\|B\| \sum_{n \geq d(x,y)} \frac{(2zJ|t|)^n}{n!} \tag{14}$$

By Stirling's approximation, this is exponentially small when $d(x,y) > 2e z J |t|$, giving
the classical LR velocity:

$$v_{LR}^{\text{(comb)}} = 2e z J \tag{15}$$

For $\mathbb{Z}^1$ ($z = 2$, $J = 1$): $v_{LR}^{(\text{comb})} = 4e \approx 10.87$.

The NS formula (12) at $a = 1$ gives $v_{LR}(1) = 8e/(e-1) \approx 12.66$ for the same
parameters. The NS bound is looser by a factor of $(e-1)^{-1} \cdot 2 \approx 1.16$ at $a = 1$,
but can be made tighter at larger $a$ (at the cost of a larger prefactor).

**For the purpose of this project:** The NS framework provides the computational infrastructure
for computing LR velocities on general graphs with general interactions. The specific numerical
value is an upper bound, not a tight bound; actual information propagation is slower. What
matters for Plan 03 is that the pipeline correctly computes $v_{LR}(a)$ for any interaction.

## 8. Effective Light Cone

The LR bound (4) implies that $\|[\tau_t(A_x), B_y]\|$ is exponentially suppressed outside
the effective light cone:

$$\|[\tau_t(A_x), B_y]\| \lesssim e^{-a(d(x,y) - v_{LR}(a)|t|)}
\quad \text{for } d(x,y) \gg v_{LR}(a)|t| \tag{16}$$

with decay rate $\mu = a$ and cone velocity $v_{LR}(a)$.

This establishes that quantum information in a lattice system with bounded local interactions
propagates at most at speed $v_{LR}$, up to exponentially small tails outside the cone.

## 9. Limiting Cases

1. **$J \to 0$** (no interaction): $\|\Phi\|_a \to 0$, hence $v_{LR}(a) \to 0$ for all $a$.
   No interaction means no propagation. $\checkmark$

2. **$a \to 0^+$**: $C_a \to \infty$, $v_{LR}(a) \to \infty$. F-function too flat;
   bound becomes trivial. $\checkmark$

3. **$a \to \infty$**: $C_a \to 0$, $\|\Phi\|_a \to \infty$, but $v_{LR}(a) \to 0$.
   Cone shrinks but prefactor blows up. $\checkmark$

4. **$d = 1 \to d = 2 \to d = 3$**: $C_a$ increases with $d$ (more neighbors at each
   distance), hence $v_{LR}(a)$ increases with $d$. Higher-dimensional lattices allow
   faster propagation due to more pathways. $\checkmark$

## Conventions Used

- **Units:** natural ($\hbar = c = k_B = 1$)
- **Lattice spacing:** $a_{\text{lat}} = 1$ (dimensionless graph distance)
- **Hamiltonian sign:** $H = \sum_{\langle x,y \rangle} h_{xy}$, ground state minimizes energy
- **Energy scale:** $\|h_{xy}\| = J$ (operator norm of bond interaction)
- **F-function:** $F_a(r) = e^{-ar}$ (exponential decay, parameter $a > 0$)
- **Commutator convention:** $[A, B] = AB - BA$

## References

1. B. Nachtergaele, R. Sims, A. Young, "Quasi-Locality Bounds for Quantum Lattice Systems.
   Part I," J. Math. Phys. 60, 061101 (2019). arXiv:1810.02428.
2. E. H. Lieb, D. W. Robinson, "The Finite Group Velocity of Quantum Spin Systems,"
   Commun. Math. Phys. 28, 251-257 (1972).
3. B. Nachtergaele, R. Sims, "Lieb-Robinson Bounds and the Exponential Clustering Theorem,"
   Commun. Math. Phys. 265, 119-130 (2006). arXiv:math-ph/0506030.
