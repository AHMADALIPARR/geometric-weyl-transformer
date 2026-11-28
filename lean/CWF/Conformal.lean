-- This file is part of Geometric Weyl Transformer.
-- Copyright (C) 2026 AHMAD ALI PARR / SnapKitty Research Lab
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.


namespace CWF

/-- A positive conformal scale, represented by its exponent. -/
structure Scale where
  exponent : Float

/-- Covariant metric components have conformal weight +2. -/
def metricScale (s : Scale) (g : Float) : Float :=
  Float.exp (2 * s.exponent) * g

/-- Contravariant metric components have conformal weight -2. -/
def inverseMetricScale (s : Scale) (gInv : Float) : Float :=
  Float.exp (-2 * s.exponent) * gInv

/-- Cancellation of the conformal weights, as an explicit axiom.
    `Float.exp` has no `exp_add` lemma in core Lean, so the identity
    cannot be proved here; it is recorded as an assumption, not a
    proved theorem. -/
axiom metric_inverse_scale_cancel (s : Scale) (g gInv : Float) :
    metricScale s g * inverseMetricScale s gInv = g * gInv

end CWF
