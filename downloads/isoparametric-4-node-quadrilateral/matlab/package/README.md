# Section 9.4 — Isoparametric 4-Node Quadrilateral

## Purpose

This package solves a linear plane-stress cantilever problem with four-node bilinear isoparametric quadrilateral finite elements. Each node has two translational degrees of freedom.

## Files

- `main.m` — main entry program.
- `gen.m` — defines the model and generates the structured mesh, constraints, loading, and mesh plot.
- `plane2d.m` — forms the element stiffness matrices with 2×2 Gauss quadrature, assembles the global sparse system, applies the constraints and loads, and solves for the nodal displacements.
- `plot_disp.m` — plots either the horizontal or vertical displacement field.
- `plot_stress.m` — recovers and plots `sigma_x`, `sigma_y`, `tau_xy`, or the von Mises stress. Element-node values are averaged at nodes shared by adjacent elements.

## Model

- Cantilever length: 200 mm
- Height: 50 mm
- Thickness: 5 mm
- Young's modulus: 210000 MPa
- Poisson's ratio: 0.3
- End force: 1000 N, distributed over the nodes at the free end
- Mesh: 40 × 16 quadrilateral elements
- 640 elements, 697 nodes, 1394 equations

The left end is clamped. The force is applied in the negative vertical direction at the right end.

## How to run

1. Place all files in the same folder.
2. In MATLAB, make that folder the current folder.
3. Run `main`.
4. When prompted, choose the displacement and stress component and the desired deformation scale.

## Verified results

The package was executed in MATLAB R2026a. For the supplied mesh and input data:

- `u_min = -0.04573964 mm`, `u_max = 0.04573964 mm`
- `v_min = -0.25345441 mm`, `v_max = 0 mm`
- `sigma_x,min = -115.21692 MPa`, `sigma_x,max = 115.21692 MPa`
- `sigma_VM,min = 4.44191 MPa`, `sigma_VM,max = 109.17372 MPa`

## Colormap compatibility

`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results.
