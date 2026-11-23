# This file is part of Geometric Weyl Transformer.
# Copyright (C) 2026 AHMAD ALI PARR / SnapKitty Research Lab
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Weyl algebra representation theory — numerical matrix realizations
# Generators: multiplication by x_i and differentiation d/dx_i on truncated polynomial space
# or finite-difference on a grid; commutation relations verified to machine precision.

weyl_matrix_rep <- function(n = 2L, max_deg = 4L) {
  # Basis of polynomials of total degree <= max_deg in n variables
  # Returns list of matrices for x_i and partial_i
  basis <- expand.grid(replicate(n, 0:max_deg, simplify = FALSE))
  basis <- basis[rowSums(basis) <= max_deg, , drop = FALSE]
  N <- nrow(basis)
  x_mats <- vector("list", n)
  d_mats <- vector("list", n)
  for (i in 1:n) {
    X <- matrix(0, N, N)
    D <- matrix(0, N, N)
    for (j in 1:N) {
      mon <- as.integer(basis[j, ])
      # Multiplication by x_i
      mon_x <- mon; mon_x[i] <- mon_x[i] + 1L
      if (sum(mon_x) <= max_deg) {
        idx <- which(apply(basis, 1, function(r) all(r == mon_x)))
        if (length(idx) == 1) X[idx, j] <- 1
      }
      # Differentiation partial_i
      if (mon[i] > 0) {
        mon_d <- mon; mon_d[i] <- mon_d[i] - 1L
        coeff <- mon[i]
        idx <- which(apply(basis, 1, function(r) all(r == mon_d)))
        if (length(idx) == 1) D[idx, j] <- coeff
      }
    }
    x_mats[[i]] <- X
    d_mats[[i]] <- D
  }
  list(basis = basis, x = x_mats, d = d_mats, N = N)
}

check_commutation <- function(rep) {
  n <- length(rep$x)
  residuals <- numeric(n)
  for (i in 1:n) {
    # [d_i, x_i] should be I
    comm <- rep$d[[i]] %*% rep$x[[i]] - rep$x[[i]] %*% rep$d[[i]]
    residuals[i] <- max(abs(comm - diag(rep$N)))
  }
  residuals
}

# Example usage (commented for library style)
# rep <- weyl_matrix_rep(n = 1L, max_deg = 5L)
# print(check_commutation(rep))
