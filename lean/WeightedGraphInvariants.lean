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

import Mathlib.Data.Finset.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

/-!
# Weighted graph invariants

Invariants of weighted graphs that are preserved under reweighting
by positive scalars or under finite summation.
-/

namespace WeightedGraphInvariants

variable {V : Type*} [DecidableEq V]

/-- A weighted graph is a finite set of vertices together with an edge-weight function. -/
structure WeightedGraph where
  vertices : Finset V
  edgeWeight : V → V → ℝ

/-- Total edge weight (sum of all directed edge weights). -/
def totalEdgeWeight (G : WeightedGraph) : ℝ :=
  ∑ u ∈ G.vertices, ∑ v ∈ G.vertices, G.edgeWeight u v

/-- The total edge weight is nonnegative when every edge weight is. -/
theorem totalEdgeWeight_nonneg
    (G : WeightedGraph)
    (h : ∀ u v, u ∈ G.vertices → v ∈ G.vertices → 0 ≤ G.edgeWeight u v) :
    0 ≤ totalEdgeWeight G := by
  unfold totalEdgeWeight
  apply Finset.sum_nonneg
  intro u hu
  apply Finset.sum_nonneg
  intro v hv
  exact h u v hu hv

/-- Scaling all edge weights by a nonnegative constant scales the total weight. -/
def scale (G : WeightedGraph) (c : ℝ) : WeightedGraph where
  vertices := G.vertices
  edgeWeight := fun u v => c * G.edgeWeight u v

theorem totalEdgeWeight_scale
    (G : WeightedGraph) (c : ℝ) :
    totalEdgeWeight (scale G c) = c * totalEdgeWeight G := by
  unfold totalEdgeWeight scale
  simp [Finset.sum_mul]

/-- The support (set of vertices with at least one positive-weight incident edge)
    is contained in the vertex set. -/
def support (G : WeightedGraph) : Finset V :=
  G.vertices.filter fun u =>
    ∃ v ∈ G.vertices, 0 < G.edgeWeight u v ∨ 0 < G.edgeWeight v u

theorem support_subset (G : WeightedGraph) : support G ⊆ G.vertices := by
  unfold support
  exact Finset.filter_subset _ _

end WeightedGraphInvariants
