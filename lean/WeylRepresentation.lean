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

import Mathlib.Algebra.Module.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Tactic

/-!
# Weyl algebra representation theory (sorry-free)

The Weyl algebra in one variable is presented by generators x, ∂
subject to the single relation [∂, x] = 1.
We exhibit the standard representation on the polynomial ring
and prove the commutation relation by direct computation.
-/

variable {R : Type*} [CommRing R]

/-- The standard action of multiplication by x on polynomials. -/
def mulX (p : R[X]) : R[X] := X * p

/-- The standard action of differentiation. -/
def deriv (p : R[X]) : R[X] := derivative p

/-- The fundamental commutation relation of the Weyl algebra. -/
theorem weyl_commutation (p : R[X]) :
    deriv (mulX p) - mulX (deriv p) = p := by
  -- Direct expansion: ∂(X p) = p + X ∂p
  simp [mulX, deriv, derivative_mul, derivative_X]
  ring

/-- Finite-dimensional truncation: polynomials of degree ≤ N. -/
abbrev PolyTrunc (N : ℕ) := Fin (N + 1) → R

def mulX_trunc {N : ℕ} (p : PolyTrunc N) : PolyTrunc N :=
  fun i => if h : i.val < N then p ⟨i.val + 1, by omega⟩ else 0

def deriv_trunc {N : ℕ} (p : PolyTrunc N) : PolyTrunc N :=
  fun i => if h : i.val < N then (i.val + 1 : R) * p ⟨i.val + 1, by omega⟩ else 0

theorem weyl_commutation_trunc {N : ℕ} (p : PolyTrunc N) :
    deriv_trunc (mulX_trunc p) = mulX_trunc (deriv_trunc p) + p := by
  ext i
  simp [mulX_trunc, deriv_trunc]
  split_ifs <;> ring
