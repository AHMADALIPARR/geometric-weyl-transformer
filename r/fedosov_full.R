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

# ============================================================================
# fedosov_full.R
# Complete, zero-placeholder R implementation of:
#   1. Discrete-grid covariant Moyal + Weyl-curvature star product (star_nabla)
#   2. Conformal gauge adjustment (conformal_adjust)
#   3. Full Fedosov recursion (moyal_fibre, nabla_section, delta_inv_1form, fedosov_recursion)
#   4. Flat-section lifting & star product recovery (lift_flat_section_at_point, star_from_r)
# ============================================================================

# Base manifold dimension (set to 2L for fast phase-space grid tests; works for any n >= 2L)
n <- 2L
m <- 2L * n  # Phase-space / fibre dimension

# Metric g (Euclidean working chart; replaceable by any symmetric n x n matrix)
g_metric <- diag(n)

# Weyl tensor C[a,b,c,d] (trace-free part of Riemann) on base M
C <- array(0, dim = c(n, n, n, n))

# Canonical Poisson bivector Pi^{IJ} on T*M (2n x 2n)
Pi <- matrix(0, m, m)
for (i in 1:n) {
  Pi[i, n + i] <- 1
  Pi[n + i, i] <- -1
}

# Torsion-free connection coefficients Gamma^c_{ab}
Gamma <- array(0, dim = c(n, n, n))

# ----------------------------------------------------------------------------
# Finite-difference operators on an arbitrary-dimensional periodic grid
# ----------------------------------------------------------------------------
shift_array <- function(arr, axis, shift_by) {
  dims <- dim(arr)
  k <- dims[axis]
  idx_list <- lapply(dims, seq_len)
  shifted_idx <- ((seq_len(k) - 1L + shift_by) %% k) + 1L
  idx_list[[axis]] <- shifted_idx
  do.call(`[`, c(list(arr), idx_list, list(drop = FALSE)))
}

grad_fd <- function(arr, axis, dx = 1.0) {
  (shift_array(arr, axis, 1L) - shift_array(arr, axis, -1L)) / (2.0 * dx)
}

hess_fd <- function(arr, ax1, ax2, dx = 1.0) {
  if (ax1 == ax2) {
    (shift_array(arr, ax1, 1L) - 2.0 * arr + shift_array(arr, ax1, -1L)) / (dx * dx)
  } else {
    grad_fd(grad_fd(arr, ax1, dx), ax2, dx)
  }
}

# ----------------------------------------------------------------------------
# Part 1: Full star_nabla (Pass 0 + Pass 1 Poisson + Pass 2 Weyl + Pass 3 Gamma)
# ----------------------------------------------------------------------------
star_nabla <- function(f, g, hbar = 1.0, C, Gamma, Pi, dx = 1.0) {
  ndim <- length(dim(f))
  if (ndim != nrow(Pi)) {
    stop("dim(f) must have length equal to nrow(Pi) = 2*n")
  }
  n_base <- ndim %/% 2L

  # Pass 0: pointwise product
  res <- f * g + 0i

  # Precompute first derivatives along all 2n phase-space axes
  df <- vector("list", ndim)
  dg <- vector("list", ndim)
  for (I in seq_len(ndim)) {
    df[[I]] <- grad_fd(f, I, dx)
    dg[[I]] <- grad_fd(g, I, dx)
  }

  # Pass 1: classical Poisson bracket contribution (order hbar)
  poisson_acc <- array(0 + 0i, dim = dim(f))
  for (I in seq_len(ndim)) {
    for (J in seq_len(ndim)) {
      pij <- Pi[I, J]
      if (pij == 0) next
      poisson_acc <- poisson_acc + pij * (df[[I]] * dg[[J]])
    }
  }
  res <- res + (1i * hbar / 2.0) * poisson_acc

  # Precompute covariant second derivatives:
  # nabla_I nabla_J f = d_I d_J f - sum_K Gamma^K_{IJ} d_K f
  n2f <- vector("list", ndim * ndim)
  n2g <- vector("list", ndim * ndim)
  for (I in seq_len(ndim)) {
    for (J in seq_len(ndim)) {
      slot <- (I - 1L) * ndim + J
      hf <- hess_fd(f, I, J, dx)
      hg <- hess_fd(g, I, J, dx)

      # Pass 3: connection terms (Gamma contributions on base indices)
      if (I <= n_base && J <= n_base) {
        for (c_idx in seq_len(n_base)) {
          gam <- Gamma[c_idx, I, J]
          if (gam == 0) next
          hf <- hf - gam * df[[c_idx]]
          hg <- hg - gam * dg[[c_idx]]
        }
      }
      n2f[[slot]] <- hf
      n2g[[slot]] <- hg
    }
  }

  # Second-order Fedosov/Moyal term: ((i*hbar)^2 / 8) * Pi^{IA} Pi^{JB} (nabla_I nabla_J f)(nabla_A nabla_B g)
  order2_acc <- array(0 + 0i, dim = dim(f))
  for (I in seq_len(ndim)) {
    for (A in seq_len(ndim)) {
      pia <- Pi[I, A]
      if (pia == 0) next
      for (J in seq_len(ndim)) {
        for (B in seq_len(ndim)) {
          pjb <- Pi[J, B]
          if (pjb == 0) next
          slot_f <- (I - 1L) * ndim + J
          slot_g <- (A - 1L) * ndim + B
          order2_acc <- order2_acc + (pia * pjb) * (n2f[[slot_f]] * n2g[[slot_g]])
        }
      }
    }
  }
  res <- res + (((1i * hbar)^2) / 8.0) * order2_acc

  # Pass 2: explicit Weyl-curvature correction (order hbar^2)
  weyl_acc <- array(0 + 0i, dim = dim(f))
  for (a in seq_len(n_base)) {
    for (b in seq_len(n_base)) {
      for (c_idx in seq_len(n_base)) {
        for (d in seq_len(n_base)) {
          cabcd <- C[a, b, c_idx, d]
          if (cabcd == 0) next
          slot_f <- (a - 1L) * ndim + b
          slot_g <- (n_base + c_idx - 1L) * ndim + (n_base + d)
          weyl_acc <- weyl_acc + cabcd * (n2f[[slot_f]] * n2g[[slot_g]])
        }
      }
    }
  }
  res <- res + ((hbar^2) / 24.0) * weyl_acc

  res
}

# Conformal adjustment: weighted star product with Omega = exp(omega)
conformal_adjust <- function(star_fun, omega, C, Gamma, Pi, dx = 1.0) {
  Omega <- exp(omega)
  function(f, g, hbar = 1.0) {
    star_fun(Omega * f, Omega * g, hbar = hbar, C = C, Gamma = Gamma, Pi = Pi, dx = dx) / Omega
  }
}

# ----------------------------------------------------------------------------
# Part 2: Full Fedosov Recursion (Weyl Algebra Bundle Sections)
# ----------------------------------------------------------------------------

symmetrize_tensor <- function(T_arr) {
  d <- length(dim(T_arr))
  if (d <= 1L) return(T_arr)
  if (d == 2L) return(0.5 * (T_arr + t(T_arr)))
  gen_perms <- function(v) {
    if (length(v) == 1L) return(list(v))
    out <- list()
    for (i in seq_along(v)) {
      sub <- gen_perms(v[-i])
      for (p in sub) out[[length(out) + 1L]] <- c(v[i], p)
    }
    out
  }
  perms <- gen_perms(seq_len(d))
  acc <- array(0 + 0i, dim = dim(T_arr))
  for (p in perms) {
    acc <- acc + aperm(T_arr, p)
  }
  acc / length(perms)
}

deriv_fibre <- function(T_arr, idx) {
  dims <- dim(T_arr)
  d <- length(dims)
  if (d == 0L) return(0)
  if (d == 1L) return(T_arr[idx])
  slice_args <- c(list(T_arr), list(idx), rep(list(TRUE), d - 1L), list(drop = FALSE))
  sub <- do.call(`[`, slice_args)
  new_dims <- dims[-1L]
  array(d * as.vector(sub), dim = new_dims)
}

outer_tensor <- function(A, B) {
  if (length(dim(A)) == 0L) return(A * B)
  if (length(dim(B)) == 0L) return(B * A)
  outer(A, B, `*`)
}

moyal_fibre <- function(A, B, Pi, max_deg, hbar = 1.0) {
  dim_y <- nrow(Pi)
  out <- vector("list", max_deg + 1L)
  out[[1L]] <- 0 + 0i
  for (d in seq_len(max_deg)) {
    out[[d + 1L]] <- array(0 + 0i, dim = rep(dim_y, d))
  }

  for (da in 0:max_deg) {
    A_d <- A[[da + 1L]]
    if (is.null(A_d) || all(A_d == 0)) next
    for (db in 0:max_deg) {
      B_d <- B[[db + 1L]]
      if (is.null(B_d) || all(B_d == 0)) next

      max_k <- min(da, db)
      for (k in 0:max_k) {
        deg_res <- da + db - 2L * k
        if (deg_res < 0L || deg_res > max_deg) next
        coeff <- ((1i * hbar / 2.0)^k) / factorial(k)

        contract_rec <- function(curA, curB, rem_k) {
          if (rem_k == 0L) {
            return(outer_tensor(curA, curB))
          }
          acc <- if (deg_res == 0L) 0 + 0i else array(0 + 0i, dim = rep(dim_y, deg_res))
          for (i in seq_len(dim_y)) {
            for (j in seq_len(dim_y)) {
              pij <- Pi[i, j]
              if (pij == 0) next
              dA <- deriv_fibre(curA, i)
              dB <- deriv_fibre(curB, j)
              acc <- acc + pij * contract_rec(dA, dB, rem_k - 1L)
            }
          }
          acc
        }

        term_k <- coeff * contract_rec(A_d, B_d, k)
        if (deg_res == 0L) {
          out[[1L]] <- out[[1L]] + term_k
        } else {
          out[[deg_res + 1L]] <- out[[deg_res + 1L]] + symmetrize_tensor(term_k)
        }
      }
    }
  }
  out
}

nabla_section <- function(s, Gamma, dim_y) {
  max_deg <- length(s) - 1L
  n_base <- dim(Gamma)[1L]
  out_1form <- vector("list", dim_y)
  for (l in seq_len(dim_y)) {
    sec_l <- vector("list", max_deg + 1L)
    sec_l[[1L]] <- 0 + 0i
    for (d in seq_len(max_deg)) {
      sec_l[[d + 1L]] <- array(0 + 0i, dim = rep(dim_y, d))
    }
    if (l <= n_base) {
      for (d in seq_len(max_deg)) {
        sd <- s[[d + 1L]]
        if (is.null(sd) || all(sd == 0)) next
        dims_d <- rep(dim_y, d)
        res_d <- array(0 + 0i, dim = dims_d)
        total_elems <- length(sd)
        for (lin in seq_len(total_elems)) {
          rem <- lin - 1L
          idx_vec <- integer(d)
          for (pos in seq_len(d)) {
            idx_vec[pos] <- (rem %% dim_y) + 1L
            rem <- rem %/% dim_y
          }
          val_acc <- 0 + 0i
          for (r_slot in seq_len(d)) {
            ir <- idx_vec[r_slot]
            if (ir > n_base) next
            for (m_idx in seq_len(n_base)) {
              gam <- Gamma[m_idx, l, ir]
              if (gam == 0) next
              alt_idx <- idx_vec
              alt_idx[r_slot] <- m_idx
              lin_alt <- 1L + sum((alt_idx - 1L) * (dim_y^(seq_len(d) - 1L)))
              val_acc <- val_acc - gam * sd[lin_alt]
            }
          }
          res_d[lin] <- val_acc
        }
        sec_l[[d + 1L]] <- res_d
      }
    }
    out_1form[[l]] <- sec_l
  }
  out_1form
}

delta_inv_1form <- function(s_1form, max_deg) {
  dim_y <- length(s_1form)
  out <- vector("list", max_deg + 1L)
  out[[1L]] <- 0 + 0i
  for (d in seq_len(max_deg)) {
    out[[d + 1L]] <- array(0 + 0i, dim = rep(dim_y, d))
  }

  for (k in 0:(max_deg - 1L)) {
    deg_target <- k + 1L
    acc <- array(0 + 0i, dim = rep(dim_y, deg_target))
    for (l in seq_len(dim_y)) {
      sk_l <- s_1form[[l]][[k + 1L]]
      if (is.null(sk_l) || all(sk_l == 0)) next
      e_l <- array(0 + 0i, dim = dim_y)
      e_l[l] <- 1.0
      acc <- acc + outer_tensor(sk_l, e_l)
    }
    out[[deg_target + 1L]] <- symmetrize_tensor(acc) / (deg_target + 0.0)
  }
  out
}

fedosov_recursion <- function(R, Gamma, Pi, max_deg = 4L, hbar = 1.0) {
  dim_y <- nrow(Pi)
  n_base <- dim(R)[1L]

  r <- vector("list", max_deg + 1L)
  r[[1L]] <- 0 + 0i
  for (d in seq_len(max_deg)) r[[d + 1L]] <- array(0 + 0i, dim = rep(dim_y, d))

  R_1form <- vector("list", dim_y)
  for (l in seq_len(dim_y)) {
    sec_l <- vector("list", max_deg + 1L)
    sec_l[[1L]] <- 0 + 0i
    for (d in seq_len(max_deg)) sec_l[[d + 1L]] <- array(0 + 0i, dim = rep(dim_y, d))
    if (l <= n_base && max_deg >= 3L) {
      R2 <- array(0 + 0i, dim = c(dim_y, dim_y))
      for (i in seq_len(n_base)) {
        for (j in seq_len(n_base)) {
          R2[i, j] <- 0.25 * R[i, j, l, l]
        }
      }
      sec_l[[3L]] <- symmetrize_tensor(R2)
    }
    R_1form[[l]] <- sec_l
  }

  r_curv <- delta_inv_1form(R_1form, max_deg)
  if (max_deg >= 3L) {
    r[[4L]] <- r_curv[[4L]]
  }

  if (max_deg >= 4L) {
    for (deg in 4:max_deg) {
      nav_1form <- nabla_section(r, Gamma, dim_y)
      rr <- moyal_fibre(r, r, Pi, max_deg, hbar)

      rhs_1form <- vector("list", dim_y)
      for (l in seq_len(dim_y)) {
        sec_l <- nav_1form[[l]]
        if (!is.null(rr[[deg]])) {
          sec_l[[deg]] <- sec_l[[deg]] + rr[[deg]] / (1i * hbar)
        }
        rhs_1form[[l]] <- sec_l
      }
      r_next <- delta_inv_1form(rhs_1form, max_deg)
      r[[deg + 1L]] <- r_next[[deg + 1L]]
    }
  }
  r
}

lift_flat_section_at_point <- function(jets_f, r, Gamma, Pi, max_deg, hbar = 1.0) {
  dim_y <- nrow(Pi)
  tau <- vector("list", max_deg + 1L)
  tau[[1L]] <- jets_f$val + 0i
  for (d in seq_len(max_deg)) tau[[d + 1L]] <- array(0 + 0i, dim = rep(dim_y, d))
  if (max_deg >= 1L) {
    tau[[2L]] <- array(jets_f$grad, dim = dim_y) + 0i
  }
  if (max_deg >= 2L) {
    tau[[3L]] <- 0.5 * symmetrize_tensor(jets_f$hess) + 0i
  }
  if (max_deg >= 3L) {
    for (deg in 3:max_deg) {
      nav_1form <- nabla_section(tau, Gamma, dim_y)
      comm_rt <- moyal_fibre(r, tau, Pi, max_deg, hbar)
      comm_tr <- moyal_fibre(tau, r, Pi, max_deg, hbar)
      rhs_1form <- vector("list", dim_y)
      for (l in seq_len(dim_y)) {
        sec_l <- nav_1form[[l]]
        sec_l[[deg]] <- sec_l[[deg]] + (comm_rt[[deg]] - comm_tr[[deg]]) / (1i * hbar)
        rhs_1form[[l]] <- sec_l
      }
      tau_next <- delta_inv_1form(rhs_1form, max_deg)
      tau[[deg + 1L]] <- tau_next[[deg + 1L]]
    }
  }
  tau
}

star_from_r <- function(jets_f, jets_g, r, Gamma, Pi, max_deg = 4L, hbar = 1.0) {
  tau_f <- lift_flat_section_at_point(jets_f, r, Gamma, Pi, max_deg, hbar)
  tau_g <- lift_flat_section_at_point(jets_g, r, Gamma, Pi, max_deg, hbar)
  prod <- moyal_fibre(tau_f, tau_g, Pi, max_deg, hbar)
  prod[[1L]]
}

# ----------------------------------------------------------------------------
# Self-test: associativity on a 2n = 4D phase-space grid + Fedosov recursion
# ----------------------------------------------------------------------------
set.seed(1)
f <- array(rnorm(4^m), dim = rep(4L, m))
g <- array(rnorm(4^m), dim = rep(4L, m))
h <- array(rnorm(4^m), dim = rep(4L, m))

sfg  <- star_nabla(f, g, hbar = 0.1, C = C, Gamma = Gamma, Pi = Pi)
sfgh <- star_nabla(sfg, h, hbar = 0.1, C = C, Gamma = Gamma, Pi = Pi)
sgh  <- star_nabla(g, h, hbar = 0.1, C = C, Gamma = Gamma, Pi = Pi)
fsgh <- star_nabla(f, sgh, hbar = 0.1, C = C, Gamma = Gamma, Pi = Pi)

cat("Max associativity residual (truncated O(hbar^2)):", max(abs(sfgh - fsgh)), "\n")

r_sec <- fedosov_recursion(C, Gamma, Pi, max_deg = 4L, hbar = 0.1)
jets_f <- list(val = 1.5, grad = c(1, 0, -1, 0.5), hess = diag(m))
jets_g <- list(val = -2.0, grad = c(0, 1, 0.5, -1), hess = diag(m) * 0.5)
cat("star_from_r(f, g) at point:", star_from_r(jets_f, jets_g, r_sec, Gamma, Pi, max_deg = 4L, hbar = 0.1), "\n")
