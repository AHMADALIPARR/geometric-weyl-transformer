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

# Twelve-module mapping

| Module | Haskell source | Lean support |
|---|---|---|
| M01 Conformal foundation | `Conformal.hs` | `CWF/Conformal.lean` |
| M02 Weyl curvature | `Curvature.hs`, `Tensor.hs` | tensor axioms remain to instantiate |
| M03 Cotangent geometry | `Cotangent.hs` | `CWF/Symplectic.lean` |
| M04 Symplectic connection | `SymplecticConnection.hs` | interface-level |
| M05 Weyl algebra | `WeylAlgebra.hs` | `CWF/Algebra.lean` |
| M06 Fedosov recursion | `Fedosov.hs` | `CWF/Fedosov.lean` |
| M07 Weyl coupling | `CurvatureCoupling.hs` | candidate structure |
| M08 Conformal transport | `ConformalTransport.hs` | `CWF/Conformal.lean` |
| M09 Star product | `StarProduct.hs` | `CWF/Algebra.lean` |
| M10 Wigner–Moyal | `WignerMoyal.hs` | future analytic formalization |
| M11 Formal assurance | `lean/CWF/` | Lean project |
| M12 Validation | `Validation.hs`, `test/` | theorem/build checks |
