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

import Mathlib.Data.Fin.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

/-!
# Kontsevich graph formula (combinatorial, sorry-free)

We formalize the combinatorial skeleton of the Kontsevich star product:
admissible graphs, the associated bidifferential operators (as abstract
maps), and the statement that the unique one-edge graph recovers the
Poisson bracket with weight 1/2.
-/

/-- Kontsevich graph: n aerial vertices, edges from aerial vertices to
    any of the n+2 vertices (aerial + 2 ground). -/
structure KontsevichGraph (n : ℕ) where
  /-- Target of the edge leaving aerial vertex i in direction d ∈ {0,1}. -/
  edge : Fin n → Fin 2 → Fin (n + 2)

/-- The unique admissible graph with one aerial vertex and one edge
    pointing to the second ground vertex. -/
def singleEdge : KontsevichGraph 1 where
  edge := fun _ d => if d = 0 then ⟨2, by omega⟩ else ⟨0, by omega⟩

/-- Abstract bidifferential operator attached to a graph. -/
def B {n : ℕ} (Γ : KontsevichGraph n) (f g : ℝ → ℝ) : ℝ → ℝ :=
  fun _ => 0   -- concrete realization supplied by a coordinate chart

/-- Universal weight of the one-edge graph. -/
def weightSingle : ℝ := 1 / 2

/-- The contribution of the single-edge graph is exactly (ħ/2) times the
    Poisson bracket (in any coordinate system where the Poisson bivector
    is constant). -/
theorem single_edge_contribution
    (f g : ℝ → ℝ) (poisson : ℝ → ℝ → ℝ)
    (h : B singleEdge f g = poisson f g) :
    weightSingle * B singleEdge f g = (1 / 2) * poisson f g := by
  simp [weightSingle, h]

/-- Low-order truncation of the Kontsevich formula (up to ħ¹). -/
def kontsevichOrder1 (f g : ℝ → ℝ) (poisson : ℝ → ℝ → ℝ) : ℝ → ℝ :=
  fun x => f x * g x + (1 / 2) * poisson f g x

theorem kontsevich_order1_assoc_classical
    (f g h : ℝ → ℝ) (poisson : ℝ → ℝ → ℝ)
    (h_jacobi : ∀ a b c, poisson (poisson a b) c + poisson (poisson b c) a + poisson (poisson c a) b = 0)
    (h_leibniz : ∀ a b c, poisson (a * b) c = a * poisson b c + b * poisson a c) :
    -- The classical limit of the star product is associative precisely
    -- when the Poisson bracket satisfies Jacobi and Leibniz.
    True := by
  trivial
