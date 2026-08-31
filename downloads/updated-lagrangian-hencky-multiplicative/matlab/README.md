# Section 17.4 — UL formulation with multiplicative update of the deformation gradient

Run `main.m` in the folder containing all the programs.

- `main.m`: load stepping and Newton iterations; calls `stiff_mult` by default.
- `gen.m`: cantilever data and Q4 mesh (480 elements, 549 nodes).
- `stiff_mult.m`, `B_matrix_mult.m`: multiplicative total-deformation-gradient update with derivatives referred to the preceding converged configuration.
- `stiff.m`, `B_matrix.m`: direct total evaluation from the initial configuration. Replace the `stiff_mult` call in `main.m` with `stiff` to select it.
- `plot_disp.m`, `plot_strain.m`, `plot_stress.m`: displacement, strain, and stress plots. Prompts show defaults; deformation scale defaults to 1.

Set `istrain=1` (Hencky) or `istrain=2` (Biot) at the beginning of the selected stiffness subroutine. The tangent retains approximate geometric terms.

`Fprev(:,:,ig,istep)` holds the preceding converged total deformation gradient. The trial value is written to `Fprev(:,:,ig,istep+1)`; the preceding slot remains fixed during the Newton iterations.

## MATLAB checks

Executed in MATLAB R2026a: both strain options with both implementations for two load steps; Hencky comparisons with 2, 5, 10, and 20 load steps. Other releases have not been execution-tested for this package.

`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results.

## Implementation details

`B_matrix` uses the prefactor `Ui`; `B_matrix_mult` uses `Uic` (`Ui^2` for Hencky and `Ui` for Biot), in addition to postmultiplication of its eight elementary matrices by `Fp`. These are the two implementations evaluated in the numerical comparison.

In `stiff_mult`, the derivative calculation uses `J`, the Jacobian of the preceding converged configuration, even though the adjacent program comment says initial configuration. The equations and this description follow the calculation.
