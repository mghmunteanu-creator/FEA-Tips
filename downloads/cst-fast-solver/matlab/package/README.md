# CST fast MATLAB solver — Section 9.2

## Purpose

`triang2d_fast.m` is the vectorized CST solver presented in Section 9.2 of
FEA Tips. It evaluates the element matrices simultaneously, assembles the
global sparse stiffness matrix directly, and uses `multiprod.m` for the
batched matrix products.

## How to use the routine

1. Download the complete CST MATLAB package from Section 9.1.
2. Add `triang2d_fast.m` and `multiprod.m` to the same MATLAB folder.
3. In `main.m`, replace the call `triang2d` with `triang2d_fast`.
4. Run `main`.

The geometry, material, loading, constraints, and plotting routines remain
those supplied in Section 9.1.

For compatibility with the standard stress-postprocessing routine, the
vectorized assembly programs also provide `DBt` in element-wise form. Thus,
the same `plot_stress` routine can be used independently of the internal
assembly strategy.

## Files in this package

- `triang2d_fast.m` — vectorized CST solver and sparse assembly
- `multiprod.m` — simultaneous products of matrices stored in N-D arrays
- `LICENSE-multiprod.txt` — BSD-style license accompanying `multiprod.m`
- `README.md` — these instructions

## `multiprod` dependency

`multiprod.m` is by Paolo de Leva and is redistributed under its BSD-style
license. The license text is included in this package. The official MATLAB
Central distribution page is:

https://www.mathworks.com/matlabcentral/fileexchange/8773-multiple-matrix-multiplications-with-array-expansion-enabled

## Verification and compatibility

The routine was executed in MATLAB R2026a on the 80 × 200 and 100 × 250
benchmark meshes. Its nodal displacements and element stresses agreed with the
standard Section 9.1 solver to floating-point precision.

The routine uses standard MATLAB sparse-matrix operations. `multiprod` uses
`bsxfun`, which is available in MATLAB R2007a and later. Compatibility with
MATLAB releases other than R2026a is expected but was not tested for this
package.
