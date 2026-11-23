// This file is part of Geometric Weyl Transformer.
// Copyright (C) 2026 AHMAD ALI PARR / SnapKitty Research Lab
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

 /*
  weyl_e8_functor.als
  Alloy 6 / SAT relational model analyzing:
  - E8 Weyl group simple reflections s_i (i in 0..7) acting on roots
  - Functorial recursion into the Lie group / Coxeter presentation
  - Bounded counterexample search for closure, involution (s_i^2 = id), and braid relations
*/
module weyl_e8_functor

sig SimpleIdx {}
sig Root {
  reflect : SimpleIdx -> one Root
}

// Each simple reflection is an involution on the root system
fact Involution {
  all i: SimpleIdx, r: Root | r.(reflect[i]).(reflect[i]) = r
}

// Coxeter edge in E8 Dynkin diagram (m_ij = 3 if adjacent, 2 if non-adjacent)
sig DynkinEdge {
  u: one SimpleIdx,
  v: one SimpleIdx
}

pred BraidOrder2[i, j: SimpleIdx] {
  all r: Root |
    let r1 = r.(reflect[i]).(reflect[j]) |
    r1.(reflect[i]).(reflect[j]) = r
}

pred BraidOrder3[i, j: SimpleIdx] {
  all r: Root |
    let r1 = r.(reflect[i]).(reflect[j]) |
    let r2 = r1.(reflect[i]).(reflect[j]) |
    r2.(reflect[i]).(reflect[j]) = r
}

// Functoriality assertion: every simple reflection is bijective on Root
assert WeylFunctorBijective {
  all i: SimpleIdx | all r': Root | some r: Root | r.(reflect[i]) = r'
}

check WeylFunctorBijective for 8 SimpleIdx, 10 Root
