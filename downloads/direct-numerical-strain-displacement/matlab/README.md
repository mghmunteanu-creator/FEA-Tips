# Section 17.5 — Direct numerical evaluation of the strain–displacement matrix

Run `main.m`. The default example uses 150 Q4 elements and 186 nodes, ten load steps, and `tol=1e-4`.

## Files

- `main.m`: nonlinear solution and storage of converged displacements and Gauss-point results.
- `gen.m`: the reduced-mesh cantilever geometry, constraints, and end loading.
- `stiff.m`: central-difference element tangent and global assembly; select `istrain=1` for Hencky or `istrain=2` for Biot strain.
- `fel_el.m`: central-difference strain–displacement matrix, element internal force, and global/local stress storage.
- `strain_el.m`: total strain and total rotation, using a spectral evaluation.
- `strain_el_old.m`: equivalent square-root/logarithm implementation retained for comparison; not called by the solution.
- `plot_disp.m`, `plot_strain.m`, `plot_stress.m`: displacement, strain, and stress maps with explicit input defaults and deformation scale 1.

## Stress frames

`sigmt` columns 1:3 store global sx, sy, txy; column 4 stores von Mises; columns 5:7 store local sx, sy, txy. Local stress is evaluated at each Gauss point as `R0'*sg*R0`, using the unperturbed total rotation, before extrapolation and nodal averaging.

`plot_stress` asks for the global or local frame for components 1:3. Von Mises is frame-independent. Results for load step `istep` are stored at array index `istep+1`.

## Visualization

`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results.

## Validation

Validated in MATLAB R2026a with the supplied 150-element, 186-node example and ten load steps. All ten steps converged for both Hencky and Biot options. Displacement, strain, global stress, local stress, and von Mises plotting were checked with the default inputs and `turbo(16)`. The stress array has dimensions 600 x 7 x 11; von Mises invariance under the stored global/local rotation was also checked.
