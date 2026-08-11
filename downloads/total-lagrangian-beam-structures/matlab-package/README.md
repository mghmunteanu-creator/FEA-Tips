# Total Lagrangian 2D beam structures

## Purpose

This package analyses planar beam structures with straight, prismatic two-node Timoshenko beam elements. Large displacements, small strains, linear elastic material behaviour, and a Total Lagrangian formulation are used.

## Main file

Run `main.m` from the folder containing all package files.

## Input data

`gen.m` defines the nodal coordinates, element connectivity, constraints, applied forces, material properties, cross-section data, and the initial element rotation matrices `Rt(:,:,ie)`.

The distributed example is a semicircular beam with radius 50 mm, rectangular cross-section 20 mm × 1 mm, Young's modulus 200000 MPa, and horizontal load 300 N.

## Files

- `main.m` — load stepping and Newton–Raphson iterations
- `gen.m` — geometry, material, loading, constraints, and rotation matrices
- `stiff.m` — element internal-force vectors, tangent matrices, transformations, and assembly
- `deriv.m` — generalized strains and their derivatives
- `print_results.m` — nodal displacements and element efforts for a selected load step
- `diagrams.m` — axial-force, shear-force, and bending-moment diagrams

## Output

The program prints the convergence history and, for the selected load step, the nodal displacements and element forces. It also displays the undeformed and deformed structure and plots the axial-force, shear-force, and bending-moment diagrams.

## MATLAB status

Tested in MATLAB R2024a. All ten load steps converged, requiring between six and eight Newton–Raphson iterations. The code uses standard MATLAB syntax and is expected to be compatible with newer MATLAB versions. No additional toolbox is required.

