# Updated Lagrangian 2D Euler-Bernoulli beam element

This package implements a geometrically nonlinear Updated Lagrangian analysis of a straight, prismatic two-node planar Euler-Bernoulli beam element. The current configuration at the end of each converged load step becomes the reference configuration for the next step.

## Files

- `main.m` - analysis driver and load-step loop
- `gen_ex1.m` - Example 1 geometry, properties, constraints, and applied end moment
- `stiff.m` - internal-force vector and tangent-stiffness assembly
- `deriv.m` - strain and curvature interpolation derivatives
- `updt.m` - nodal geometry, element length, and rotation-matrix update after each load step
- `print_results.m` - nodal displacements and element efforts for a selected load step

## Running the example

1. Place all files in one folder and make it the current MATLAB folder.
2. Run `main`.
3. When prompted, press Enter to print the final load step or enter a load-step number from 1 to 100.

Example 1 is a 100 mm cantilever with a 5 mm x 1 mm rectangular cross-section, Young's modulus of 200000 MPa, and an applied free-end moment of 5236 Nmm. The maximum analytical rotation is 2*pi radians. The program displays the deformed beam over 100 equidistant load steps and prints nodal displacements, axial forces, and bending moments.

## Output

- deformed configurations normalized by `L_b`, with axes `x/L_b` and `y/L_b`;
- Newton-Raphson iteration count and convergence error for each load step;
- nodal displacements and rotations for the selected step;
- element axial forces and bending moments.

## MATLAB compatibility

Executed successfully in MATLAB 26.1 (R2026a) Update 4. All 100 load steps reached convergence; the final step required 4 Newton-Raphson iterations, with a convergence measure of approximately `4.61e-8`. The computed maximum rotation was approximately `6.26691 rad`. The code uses standard MATLAB syntax and is expected to be compatible with recent MATLAB versions. No additional toolbox is required.
