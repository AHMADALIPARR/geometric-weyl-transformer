<!--
This file is part of Geometric Weyl Transformer.
Copyright (C) 2026 AHMAD ALI PARR / SnapKitty Research Lab

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
-->

# Numerical and symbolic backend notes

`Polynomial` is a sparse symbolic polynomial over complex floating-point coefficients. `FormalSeries` stores coefficients by powers of the formal parameter. The monomial exponents and formal order are exact integers; scalar coefficients are floating point, so this is not an exact rational symbolic algebra.

`moyalProduct` computes the canonical bidifferential expansion through the requested finite order. The coefficient at order k is `(i hbar/2)^k/k!` times the kth power of the canonical Poisson bidifferential operator. This is exact for polynomial symbols up to the selected truncation, modulo floating-point coefficient arithmetic.

The sampled Wigner transform uses zero extension and a finite grid. It is a numerical diagnostic, not an exact continuous Fourier integral.
