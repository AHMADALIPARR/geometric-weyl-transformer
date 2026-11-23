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

**Concrete non-zero Weyl tensors** are supplied below for two standard vacuum spacetimes. In both cases the Ricci tensor vanishes, so the Weyl tensor coincides with the Riemann tensor. The components are given in conventional coordinates; all other independent components follow by the algebraic symmetries of the Weyl tensor

\[
C_{abcd}=-C_{bacd}=-C_{abdc},\qquad
C_{abcd}+C_{acdb}+C_{adbc}=0,\qquad
g^{ac}C_{abcd}=0.
\]

### 1. Schwarzschild spacetime

The metric in standard coordinates \((t,r,\theta,\phi)\) is

\[
ds^2=-\Bigl(1-\frac{2m}{r}\Bigr)dt^2+\Bigl(1-\frac{2m}{r}\Bigr)^{-1}dr^2+r^2\,d\theta^2+r^2\sin^2\theta\,d\phi^2.
\]

The independent non-vanishing components of the Weyl tensor (equivalently the Riemann tensor) are

\begin{align*}
C_{trtr}&=-\frac{2m}{r^3},\\
C_{t\theta t\theta}&=\frac{m(r-2m)}{r},\\
C_{t\phi t\phi}&=\frac{m(r-2m)\sin^2\theta}{r},\\
C_{r\theta r\theta}&=-\frac{m}{r-2m},\\
C_{r\phi r\phi}&=-\frac{m\sin^2\theta}{r-2m},\\
C_{\theta\phi\theta\phi}&=2mr\sin^2\theta.
\end{align*}

(The fully covariant components \(C_{0101}=-2m/r^3\), \(C_{0202}=m(r-2m)/r^2\), etc., appear in the literature with the same numerical coefficients once the coordinate ordering \(x^0=t\), \(x^1=r\), \(x^2=\theta\), \(x^3=\phi\) is fixed.) All other components are determined by the symmetries listed above. The single independent Weyl scalar is

\[
\Psi_2=-\frac{m}{r^3}.
\]

The tensor is of Petrov type D and is non-vanishing for all \(r>2m\).

### 2. Plane-fronted gravitational wave (pp-wave)

A simple exact solution with non-zero Weyl curvature is the Brinkmann form

\[
ds^2=-2\,du\,dv+H(u,x,y)\,du^2+dx^2+dy^2,
\]

where the profile function \(H\) satisfies the vacuum condition \(\partial_x^2H+\partial_y^2H=0\). The only non-vanishing curvature components are

\begin{align*}
R_{uxux}&=-\frac12\partial_x^2H,\\
R_{uxuy}&=-\frac12\partial_x\partial_yH,\\
R_{uyuy}&=-\frac12\partial_y^2H.
\end{align*}

Consequently the Weyl tensor coincides with the Riemann tensor and is given by the same expressions. Choosing, for example, the linearised monochromatic wave

\[
H(u,x,y)=A\bigl(x^2-y^2\bigr)\cos(ku)
\]

(with \(A,k\) constants) yields the concrete non-zero components

\begin{align*}
C_{uxux}&=-A\cos(ku),\\
C_{uyuy}&=+A\cos(ku),\\
C_{uxuy}&=0.
\end{align*}

The spacetime is of Petrov type N, the Weyl tensor is transverse to the propagation direction \(\partial_u\), and the trace-free tidal field in the \((x,y)\)-plane is precisely the matrix

\[
\begin{pmatrix}A\cos(ku)&0\\0&-A\cos(ku)\end{pmatrix}.
\]

### Insertion into the Fedosov recursion

Either of the above tensors may be substituted directly for the curvature parameter \(R\) that appears in the R and Lean implementations of the Fedosov recursion. In the Schwarzschild case the components are position-dependent; in the plane-wave case they depend only on the null coordinate \(u\). Both furnish a concrete, non-vanishing Weyl contribution that propagates into the higher-order terms of the star product.

If a numerical array representation (for the R nested-loop code) or a specific coordinate chart for the Lean formalisation is required, the components above can be converted into the corresponding multi-dimensional arrays without further theoretical adjustment.
