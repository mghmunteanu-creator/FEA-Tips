# Section 17.2 MATLAB programs

This package contains the MATLAB programs for the plane-stress updated Lagrangian Q4 example using either the Hencky or the Biot strain tensor.

## Files

- `main.m` — load-step and equilibrium-iteration procedure
- `gen.m` — geometry, mesh, material data, constraints, and loading
- `stiff.m` — element internal force and approximate tangent stiffness
- `B_matrix.m` — strain-displacement matrix for the selected strain measure
- `plot_disp.m` — displacement plotting
- `plot_strain.m` — strain recovery and plotting
- `plot_stress.m` — stress recovery and plotting

Run `main.m`. At the beginning of `stiff.m`, select the strain measure with:

```matlab
istrain=1;   % 1 - Hencky strain
             % 2 - Biot strain
```

The programs were executed in MATLAB R2026a with both selector values. The example converged through all 20 load steps for both strain measures.
