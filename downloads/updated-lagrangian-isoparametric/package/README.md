# Section 8.2 — Updated Lagrangian 2D isoparametric beam element

## Purpose

This package implements the two-node isoparametric Timoshenko beam element presented in Section 8.2 of FEA Tips. The Updated Lagrangian procedure uses the converged current configuration as the reference configuration for the following load step.

The distributed input data are intentionally configured for Example 2, the Mattiasson large-deflection beam-frame benchmark. Example 1 remains a comparison example in the accompanying web page and does not have a separate input file in this package.

## Files

- `main.m` — nonlinear load-step loop and Newton–Raphson iterations.
- `gen.m` — geometry, material data, boundary conditions, loading, and initial element rotation matrices for Example 2.
- `stiff.m` — element residual, tangent stiffness, generalized-strain storage, assembly, constraints, and applied load.
- `deriv.m` — axial strain, curvature, shear angle, and their first and second derivatives.
- `updt.m` — updates nodal coordinates, element lengths, orientations, and rotation matrices after each converged load step.
- `plt.m` — reconstructs the complete symmetric deformation from the modeled part.
- `print_results.m` — prints nodal displacements and element resultants for a selected load step.

## Running the program

1. Place all files in the same folder.
2. Open that folder in MATLAB.
3. Run `main`.
4. When prompted, enter a load-step number or press Enter to display the final load step.

The program uses 20 Timoshenko beam elements and 10 load steps for the included Example 2 data. It displays the deformed configurations and prints nodal displacements together with axial force, shear force, and bending moment.

## Symmetric plotting

The full symmetric benchmark can be reconstructed with `plt.m`. In `main.m`, remove the comment marker from `%cl='k'; plt` and `%cl='b'; plt`, and comment the neighboring direct `plot(x/Lb,y/Lb,...)` commands when the complete symmetric drawing is required.

## MATLAB verification

Executed successfully in MATLAB 26.1 (R2026a). All 10 load steps converged. At the final load step the Newton–Raphson procedure required 5 iterations and reached a convergence measure of approximately `1.03e-7`.

For the final node, the computed total degrees of freedom were approximately `u = 0`, `v = 24.59137`, and `psi = 0.726348`. The code uses standard MATLAB syntax and is expected to remain compatible with recent MATLAB releases.

No additional toolbox is required.
