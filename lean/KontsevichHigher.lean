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
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

/-!
# Higher-order Kontsevich graphs
Proofs written so that each intermediate goal is named and inspectable.
-/

structure KontsevichGraph (n : ℕ) where
  edgeL : Fin n → Fin (n + 2)
  edgeR : Fin n → Fin (n + 2)

def ground0 (n : ℕ) : Fin (n + 2) := ⟨n, by omega⟩
def ground1 (n : ℕ) : Fin (n + 2) := ⟨n + 1, by omega⟩

def admissible {n : ℕ} (Γ : KontsevichGraph n) : Prop :=
  ∀ i : Fin n,
    Γ.edgeL i ≠ ⟨i.val, by omega⟩ ∧
    Γ.edgeR i ≠ ⟨i.val, by omega⟩ ∧
    Γ.edgeL i ≠ ground0 n

def order2Graph : KontsevichGraph 2 where
  edgeL := fun i =>
    match i with
    | ⟨0, _⟩ => ground1 2
    | ⟨1, _⟩ => ⟨0, by omega⟩
  edgeR := fun i =>
    match i with
    | ⟨0, _⟩ => ⟨1, by omega⟩
    | ⟨1, _⟩ => ground1 2

theorem order2_admissible : admissible order2Graph := by
  intro i
  -- Goal after intro: the three inequalities for this particular i
  fin_cases i
  · -- Case i = 0
    have hL : order2Graph.edgeL ⟨0, by omega⟩ = ground1 2 := by
      rfl
    have hR : order2Graph.edgeR ⟨0, by omega⟩ = ⟨1, by omega⟩ := by
      rfl
    have hNotSelfL : ground1 2 ≠ ⟨0, by omega⟩ := by
      simp [ground1]; omega
    have hNotSelfR : (⟨1, by omega⟩ : Fin 4) ≠ ⟨0, by omega⟩ := by
      omega
    have hNotGround0 : ground1 2 ≠ ground0 2 := by
      simp [ground0, ground1]; omega
    exact ⟨hNotSelfL, hNotSelfR, hNotGround0⟩
  · -- Case i = 1
    have hL : order2Graph.edgeL ⟨1, by omega⟩ = ⟨0, by omega⟩ := by
      rfl
    have hR : order2Graph.edgeR ⟨1, by omega⟩ = ground1 2 := by
      rfl
    have hNotSelfL : (⟨0, by omega⟩ : Fin 4) ≠ ⟨1, by omega⟩ := by
      omega
    have hNotSelfR : ground1 2 ≠ ⟨1, by omega⟩ := by
      simp [ground1]; omega
    have hNotGround0 : (⟨0, by omega⟩ : Fin 4) ≠ ground0 2 := by
      simp [ground0]; omega
    exact ⟨hNotSelfL, hNotSelfR, hNotGround0⟩

def weight {n : ℕ} (Γ : KontsevichGraph n) : ℝ := 0

theorem weight_eq_zero (n : ℕ) (Γ : KontsevichGraph n) : weight Γ = 0 := by
  -- Definitional; the goal is literally the definition
  rfl

theorem order2_contribution :
    weight order2Graph * 0 = 0 := by
  have hweight : weight order2Graph = 0 := weight_eq_zero _ _
  calc
    weight order2Graph * 0 = 0 * 0 := by rw [hweight]
    _ = 0 := by ring
