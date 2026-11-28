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

/-- Abstract carrier for a unital associative algebra. -/
class AssocAlgebra (A : Type) where
  mul : A → A → A
  one : A
  assoc : ∀ a b c, mul (mul a b) c = mul a (mul b c)
  one_mul : ∀ a, mul one a = a
  mul_one : ∀ a, mul a one = a

infixl:70 " ⋆ " => AssocAlgebra.mul

theorem star_assoc {A : Type} [AssocAlgebra A] (a b c : A) :
    (a ⋆ b) ⋆ c = a ⋆ (b ⋆ c) :=
  AssocAlgebra.assoc a b c

theorem star_left_unit {A : Type} [AssocAlgebra A] (a : A) :
    AssocAlgebra.one ⋆ a = a :=
  AssocAlgebra.one_mul a

theorem star_right_unit {A : Type} [AssocAlgebra A] (a : A) :
    a ⋆ AssocAlgebra.one = a :=
  AssocAlgebra.mul_one a

end CWF
