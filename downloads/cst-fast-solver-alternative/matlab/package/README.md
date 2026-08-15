# CST fast MATLAB solver — alternative version — Section 9.3

## Purpose

`triang2d_fast2.m` is the alternative fast CST routine presented in Section
9.3 of FEA Tips. It avoids the external `multiprod` dependency by storing all
element strain-displacement and constitutive matrices as block-diagonal sparse
matrices and using standard sparse matrix multiplication.

## How to use the routine

1. Download the complete CST MATLAB package from Section 9.1.
2. Add `triang2d_fast2.m` to the same MATLAB folder.
3. In `main.m`, replace the call `triang2d` with `triang2d_fast2`.
4. Run `main`.

The geometry, material, loading, constraints, and plotting routines remain
those supplied in Section 9.1.

## Files in this package

- `triang2d_fast2.m` — alternative sparse CST solver
- `README.md` — these instructions

The testing files used to generate the published benchmark are intentionally
not distributed in this package.

## Verification and compatibility

The routine was executed in MATLAB R2026a on the 80 × 200 and 100 × 250
benchmark meshes. Its global displacement vector and element stresses were
identical, within the recorded double-precision comparison, to the results of
the Section 9.2 solver for both meshes.

The routine uses standard MATLAB sparse-matrix operations and does not require
`multiprod`. Compatibility with newer MATLAB releases is expected. MATLAB
releases other than R2026a were not tested for this package.
