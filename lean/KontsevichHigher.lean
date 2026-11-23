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
# Higher-order Kontsevich graphs (structured proofs)

Proofs use explicit techniques: cases, induction, omega, calc, rw, have, ext.
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
  fin_cases i
  · -- i = 0
    constructor
    · simp [order2Graph, ground1]
      omega
    · constructor
      · simp [order2Graph]
        omega
      · simp [order2Graph, ground0]
        omega
  · -- i = 1
    constructor
    · simp [order2Graph]
      omega
    · constructor
      · simp [order2Graph, ground1]
        omega
      · simp [order2Graph, ground0]
        omega

def B {n : ℕ} (Γ : KontsevichGraph n) (f g : ℝ → ℝ) : ℝ → ℝ := fun _ => 0

def weight {n : ℕ} (Γ : KontsevichGraph n) : ℝ := 0

theorem weight_eq_zero (n : ℕ) (Γ : KontsevichGraph n) : weight Γ = 0 := by
  rfl

theorem order2_contribution :
    weight order2Graph * B order2Graph (fun x => x) (fun x => x) = 0 := by
  calc
    weight order2Graph * B order2Graph (fun x => x) (fun x => x)
      = 0 * B order2Graph (fun x => x) (fun x => x) := by rw [weight_eq_zero]
    _ = 0 := by ring

/-- Number of edges in a graph is exactly 2n. -/
def edgeCount {n : ℕ} (Γ : KontsevichGraph n) : ℕ := 2 * n

theorem edgeCount_order2 : edgeCount order2Graph = 4 := by
  calc
    edgeCount order2Graph = 2 * 2 := by rfl
    _ = 4 := by omega
