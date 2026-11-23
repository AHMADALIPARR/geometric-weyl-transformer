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


# Conformal Weyl–Fedosov Deformation Architecture

Haskell + Lean 4 research implementation, with symbolic polynomial and numerical backends.

## Status and mathematical boundary

This repository is a complete, buildable **computational foundation and research scaffold** for the twelve-module architecture. It implements:

- finite-dimensional local tensor algebra and conformal rescaling;
- Riemann/Ricci/Schouten/Weyl decomposition for supplied coordinate tensors;
- canonical cotangent symplectic structure and Poisson brackets;
- polynomial symbols, formal-\hbar series, and truncated Moyal multiplication;
- a Fedosov Weyl-fiber algebra, homotopy primitives, and a filtration-ordered recursive solver interface;
- Wigner transforms for sampled one-dimensional wavefunctions;
- Lean proofs of the abstract algebraic laws that can be established without assuming the unresolved geometric construction.

It does **not** claim to solve the open research problem of constructing a nontrivial Weyl-curvature-coupled Fedosov product that is simultaneously conformally covariant. In particular, the coupling module deliberately rejects an untyped insertion of `C_abcd` into a central two-form. A valid coupling must be a tensorial, closed phase-space two-form (or a justified modification of the Fedosov curvature equation), with a proved conformal transport law.

The implemented Moyal engine is exact for polynomial symbols up to the chosen formal order. The general Fedosov recursion is represented as a typed, filtration-aware interface and flat-model implementation; arbitrary curved-manifold Fedosov data require a concrete symplectic connection, curvature convention, and closed central form.

## Layout

- `src/ConformalWeyl/` contains the twelve modules.
- `app/Main.hs` runs a symbolic/numeric flat-space demonstration.
- `test/Spec.hs` contains deterministic tests.
- `lean/` contains Lean 4 definitions and proofs.
- `docs/RESEARCH_BOUNDARIES.md` separates established results from research obligations.

## Build

Requirements: GHC 9.2+ and Cabal 3.8+; Lean 4 (lake).

```sh
cabal update
cabal build all
cabal test
cabal run cwf-demo
cd lean
lake build
```

No Python, network service, or external CAS is required at runtime.

## Conventions

- Coordinates are ordered `(x1,...,xn,p1,...,pn)` on `T*M`.
- The canonical symplectic form is `omega = sum_i dx_i ^ dp_i`.
- The Poisson bracket is `{f,g} = sum_i (df/dx_i dg/dp_i - df/dp_i dg/dx_i)`.
- Formal products are truncated at `hbarOrder`; truncation is a computational quotient, not a proof about omitted terms.
- Curvature index convention is documented in `Curvature.hs`.
