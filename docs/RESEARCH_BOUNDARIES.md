<!--
This file is part of Geometric Weyl Transformer.
Copyright (C) 2026 AHMAD ALI PARR / SnapKitty Research Lab

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
-->


# Established mathematics versus unresolved research

## Established components represented here

1. The conformal transformation law of the Levi-Civita connection.
2. The Riemann–Schouten–Weyl decomposition (subject to the explicitly selected index convention).
3. The canonical symplectic structure on a cotangent bundle.
4. The fiberwise Weyl product on a symplectic vector space.
5. The Fedosov construction: a suitable symplectic connection and closed formal central two-form determine a flat Abelian connection and an associative star product.
6. The flat canonical case reduces to the Moyal product.
7. The leading star commutator recovers the Poisson bracket.

## Not established by this repository

1. A canonical symplectic connection on `T*M` determined solely by a conformal class.
2. A natural, nonzero, tensorial map from the conformal Weyl tensor to a closed phase-space two-form.
3. A conformal transformation law for that map.
4. A conformally covariant Fedosov connection with explicit nontrivial Weyl-curvature coupling.
5. A proof that the resulting coupling changes the equivalence class of the star product.

The `unresolvedWeylCoupling` constructor intentionally returns an error. Replace it only after supplying a mathematically defined map and proofs of its tensoriality, closedness, filtration degree, and conformal behavior.

## Important correction to schematic formulas

The Fedosov curvature equation is convention-dependent. This code does not pretend that an arbitrary curvature tensor can be added to the central two-form. The curvature of the symplectic connection is represented in the Weyl algebra bundle; the central formal two-form is a separate datum. A candidate Weyl coupling must be mapped into the correct type.

The Moyal product in `StarProduct.hs` is the exact polynomial bidifferential expansion for canonical flat coordinates. It is not, by itself, a curved-space Fedosov product.
