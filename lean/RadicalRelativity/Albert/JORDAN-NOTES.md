# h3O Jordan identity - pricing record

The mathematics and the proof structure live in the module docstring of
`RadicalRelativity/Albert/Jordan.lean`.  This file keeps only the measurements, because those
decay out of a docstring and because three earlier attempts were priced wrong.

## Outcome

`instance : IsCommJordan h3O` compiles.  `#print axioms` on `jordanMul_jordan`,
`instIsCommJordan`, `instCommMagma` and on all nine octonionic lemmas returns exactly
`[propext, Classical.choice, Quot.sound]` - no custom axioms, no `sorryAx`.

## Measured costs (2026-08-23, this machine)

| item | cost |
|---|---|
| `polar_moufang` alone (quartic, 4 octonion variables, `simp [mul, ...] <;> ring`) | 37 s wall, closes under a 6.4M budget |
| the nine octonionic lemmas as one file | 51 s wall; six close at the default 200000 budget, three need more than that and are set to 1600000 |
| whole file including both component identities and the assembly | ~2 min wall |

## What the plan got wrong, in the direction of pessimism

The plan treated the octonionic quartics as the wall.  They are not: a degree-4 identity in
four octonion variables is a 37-second `ring` call, about a fifth of what `moufang_middle`
already costs in `Octonions.lean`.  The expensive thing was never the octonions; it was
*finding which* identities the components decompose into.  That was done outside Lean, in a
formal free `*`-algebra over the same multiplication table (words as trees, `octIp` as a
symbol), by subtracting the two sides of the identity and reading off the residue.  The
residue for each component then had to be matched against candidate identities exactly - the
first match failed only because the model canonicalised `octIp` orientation and Lean's `ring`
does not, which is what the `octIp_comm` instances in the two `simp only` lists repair.

## Routes not to re-run

1. Expanding the whole identity in the 54 real coordinates.
2. Full polarisation followed by enumeration over the 27-element basis: `C(29,3) * 27 = 98,658`
   goals.
3. `native_decide` / `decide`: banned, and impossible over `ℝ`.
