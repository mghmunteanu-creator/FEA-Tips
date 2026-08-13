# Section 9.1 — CST Finite Element

## Purpose

This package solves the plane-stress analysis of a rectangular cantilever beam with three-node constant-strain triangular (CST) finite elements.

## Model and input data

- beam length: `L = 200 mm`
- beam height: `H = 50 mm`
- thickness: `th = 5 mm`
- Young's modulus: `E = 2.1e5 MPa`
- Poisson ratio: `nu = 0.3`
- applied end force: `F0 = 1000 N`, distributed over the nodes at `x = L`
- mesh: 40 subdivisions along the length and 16 through the height
- 1280 CST finite elements, 697 nodes, and 1394 equations

The edge at `x = 0` is fixed in both translation directions. The model assumes small strains, small displacements, a linear elastic material, and plane stress.

## Files

- `main.m` — runs the complete analysis
- `gen.m` — defines the model, generates the mesh, constraints, and nodal forces
- `triang2d.m` — assembles and solves the global linear system
- `plot_disp.m` — plots either the horizontal or vertical displacement field
- `plot_stress.m` — recovers and plots the nodally averaged stress field

## How to run

1. Place all files in one folder and make that folder the current MATLAB folder.
2. Run `main`.
3. At the prompts, select displacement `1` (`u`) or `2` (`v`) and stress `1` (`sigma_x`), `2` (`sigma_y`), `3` (`tau_xy`), or `4` (von Mises stress). Press Enter to accept the defaults.
4. Use displacement scale `0` to plot the calculated field on the undeformed mesh, or enter a display scale when a deformed view is desired.

## Outputs

The program reports the minimum and maximum value of the selected displacement and stress fields and displays contour maps. The MATLAB R2026a verification gave:

- `u_min = -0.0449544312 mm`, `u_max = 0.0449544312 mm`
- `v_min = -0.2493638881 mm`, `v_max = 0 mm`
- `sigma_x,min = -93.95284025 MPa`, `sigma_x,max = 93.95284025 MPa`
- `tau_xy,min = -14.23122995 MPa`, `tau_xy,max = 0.51891293 MPa`

The CST approximation produces a constant stress within each triangular element. Nodal stress values are obtained by averaging the stresses of the adjacent elements; consequently, the shear-stress field is represented rather poorly by this mesh.

## MATLAB compatibility

Tested in MATLAB R2026a. The code uses standard MATLAB syntax and is expected to be compatible with recent MATLAB releases.

## Colormap compatibility

`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results.
