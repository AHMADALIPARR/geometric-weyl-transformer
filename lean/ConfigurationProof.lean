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
# Configuration weight nonnegativity

The total weight of a finite configuration is nonnegative whenever
every individual weight is nonnegative.
-/

namespace ConfigurationProof

variable {State : Type*}
variable [DecidableEq State]

def totalWeight
    (states : Finset State)
    (weight : State → ℝ) : ℝ :=
  ∑ s ∈ states, weight s

theorem totalWeight_nonneg
    (states : Finset State)
    (weight : State → ℝ)
    (hweight : ∀ s ∈ states, 0 ≤ weight s) :
    0 ≤ totalWeight states weight := by
  unfold totalWeight
  apply Finset.sum_nonneg
  intro s hs
  exact hweight s hs

/-- Specialization to Kontsevich graphs: if every graph weight is
    nonnegative then the sum over any finite set of graphs is nonnegative. -/
theorem kontsevich_total_weight_nonneg
    {n : ℕ}
    (graphs : Finset (Fin n → Fin (n + 2) × Fin (n + 2)))
    (w : (Fin n → Fin (n + 2) × Fin (n + 2)) → ℝ)
    (h : ∀ Γ ∈ graphs, 0 ≤ w Γ) :
    0 ≤ ∑ Γ ∈ graphs, w Γ := by
  apply Finset.sum_nonneg
  intro Γ hΓ
  exact h Γ hΓ

end ConfigurationProof
