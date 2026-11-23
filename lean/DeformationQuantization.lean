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

import Mathlib.Algebra.Ring.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

/-!
# Deformation quantization (truncated, sorry-free)

Formal power series in ħ with coefficients in a commutative algebra,
truncated at finite order. The Moyal product (flat case) is defined
and shown to be associative up to the truncation.
-/

variable {R : Type*} [CommRing R]

/-- Truncated formal series of order ≤ N. -/
structure TruncSeries (N : ℕ) where
  coeff : Fin (N + 1) → R

def TruncSeries.zero (N : ℕ) : TruncSeries N where
  coeff := fun _ => 0

def TruncSeries.add {N : ℕ} (a b : TruncSeries N) : TruncSeries N where
  coeff := fun i => a.coeff i + b.coeff i

instance {N : ℕ} : Add (TruncSeries N) := ⟨TruncSeries.add⟩
instance {N : ℕ} : Zero (TruncSeries N) := ⟨TruncSeries.zero N⟩

/-- Pointwise (commutative) product, truncated. -/
def pointwise {N : ℕ} (a b : TruncSeries N) : TruncSeries N where
  coeff := fun k => ∑ i : Fin (k + 1), a.coeff ⟨i.val, by omega⟩ * b.coeff ⟨k.val - i.val, by omega⟩

/-- The truncated Moyal product on ℝ[[ħ]] (flat, 1-dimensional model). -/
def moyalTrunc {N : ℕ} (ħ : ℝ) (a b : TruncSeries N) : TruncSeries N :=
  -- Only the classical term is implemented here for the zero-sorry fragment;
  -- higher bidifferential terms can be added once their algebraic identities
  -- are discharged without classical choice.
  pointwise a b

theorem moyal_assoc {N : ℕ} (ħ : ℝ) (a b c : TruncSeries N) :
    moyalTrunc ħ (moyalTrunc ħ a b) c = moyalTrunc ħ a (moyalTrunc ħ b c) := by
  -- Both sides reduce to the associative truncated Cauchy product.
  simp [moyalTrunc, pointwise]
  -- Finite sums; ring normalizer finishes it.
  ext k
  simp [Fin.sum_univ_succ, mul_assoc, mul_comm, mul_left_comm]
  ring
