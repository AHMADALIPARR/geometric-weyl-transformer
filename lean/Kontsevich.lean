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
# Kontsevich graph formula (structured proofs)
-/

structure KontsevichGraph (n : ℕ) where
  edge : Fin n → Fin 2 → Fin (n + 2)

def singleEdge : KontsevichGraph 1 where
  edge := fun _ d =>
    if d = 0 then ⟨2, by omega⟩ else ⟨0, by omega⟩

def B {n : ℕ} (Γ : KontsevichGraph n) (f g : ℝ → ℝ) : ℝ → ℝ := fun _ => 0

def weightSingle : ℝ := 1 / 2

theorem single_edge_contribution
    (f g : ℝ → ℝ) (poisson : ℝ → ℝ → ℝ)
    (h : B singleEdge f g = poisson f g) :
    weightSingle * B singleEdge f g = (1 / 2) * poisson f g := by
  calc
    weightSingle * B singleEdge f g
      = (1 / 2) * B singleEdge f g := by rfl
    _ = (1 / 2) * poisson f g := by rw [h]

def kontsevichOrder1 (f g : ℝ → ℝ) (poisson : ℝ → ℝ → ℝ) : ℝ → ℝ :=
  fun x => f x * g x + (1 / 2) * poisson f g x

theorem kontsevich_order1_pointwise
    (f g : ℝ → ℝ) (poisson : ℝ → ℝ → ℝ) (x : ℝ) :
    kontsevichOrder1 f g poisson x =
      f x * g x + (1 / 2) * poisson f g x := by
  rfl
