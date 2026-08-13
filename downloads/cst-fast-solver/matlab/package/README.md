# CST fast MATLAB solver — Section 9.2

## Purpose

This package implements the constant-strain triangular (CST) finite element
solver presented in Section 9.2 of FEA Tips. `triang2d_fast` evaluates the
element matrices simultaneously and assembles the global sparse stiffness
matrix from vectorized index and value arrays.

The package also includes `triang2d`, the standard element-by-element solver,
so that the two implementations can be compared for the same model.

## Run the program

1. Set the current MATLAB folder to this package directory.
2. Run `main`.

`main` calls `gen` and then `triang2d_fast`. The supplied `gen.m` input file is
configured for the 80 × 200 benchmark mesh: 80 subdivisions through the beam
height and 200 along its length, giving 32,000 CST elements and 32,562
equations.

To run the standard solver for the same generated data, execute `triang2d`
instead of `triang2d_fast` after `gen`.

## Files

- `main.m` — main entry script
- `gen.m` — geometry, mesh, material, constraints, and loading
- `triang2d_fast.m` — vectorized CST solver and sparse assembly
- `triang2d.m` — standard CST solver used for comparison
- `multiprod.m` — simultaneous products of matrices stored in N-D arrays
- `plot_disp.m` — displacement contour plotting
- `plot_stress.m` — stress recovery and contour plotting
- `LICENSE-multiprod.txt` — license for the redistributed `multiprod.m`

## Key variables

`B` contains the strain-displacement matrices for all elements as a
`3 × 6 × nel` array. `DHooke` contains the thickness- and area-weighted plane
stress constitutive matrices as a `3 × 3 × nel` array. `kelt` contains all
element stiffness matrices after reshaping. `ipos1` and `ipos2` identify the
global row and column positions used by `sparse`. `neq` is the number of global
equations. `K`, `F`, and `S` are the global stiffness matrix, load vector, and
computed displacement vector used in the MATLAB implementation.

## `multiprod` dependency

`multiprod.m` is included so that the package is self-contained. It is by
Paolo de Leva and is distributed under the license included in
`LICENSE-multiprod.txt`. The authoritative MATLAB Central entry is:

https://www.mathworks.com/matlabcentral/fileexchange/8773-multiple-matrix-multiplications-with-array-expansion-enabled

## Verification and compatibility

The standard and fast solvers were executed in MATLAB R2026a on the 80 × 200
and 100 × 250 benchmark meshes. Their nodal displacements and element stresses
agreed to approximately 10^-10 in relative norm.

The programs use standard MATLAB syntax. `multiprod` uses `bsxfun`, which is
available in MATLAB R2007a and later. Compatibility with releases other than
MATLAB R2026a is expected but was not tested for this package.
