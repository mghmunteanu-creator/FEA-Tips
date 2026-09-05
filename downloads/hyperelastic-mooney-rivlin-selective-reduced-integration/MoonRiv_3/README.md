# Section 18.3 MATLAB programs

These programs reproduce the plane-strain Q4 example from Section 18.3, using a nearly incompressible Mooney-Rivlin material and Selective Reduced Integration.

Run `main.m`. The program reads the mesh from `nodes` and `elements`.

The program structure is:

- `stiff.m` initializes the global system, calls the two element contributions, applies constraints, and applies the external force;
- `stiff_distortion.m` evaluates and integrates the distortional contribution with the four-point `2 x 2` Gauss rule;
- `stiff_bulk.m` evaluates and integrates the volumetric contribution at the element centre with the one-point `1 x 1` Gauss rule and total weight 4;
- `MoonRiv_distortion.m` evaluates the distortional second Piola–Kirchhoff stresses and constitutive tangent;
- `MoonRiv_bulk.m` evaluates the volumetric second Piola–Kirchhoff stresses and constitutive tangent;
- `convert_stress.m` transforms the stored second Piola–Kirchhoff stresses into Cauchy stresses;
- `plot_disp.m` plots nodal displacements;
- `plot_stress_Cauchy.m` plots Cauchy stresses.

Interactive defaults are shown in each prompt. In `plot_disp.m`, the defaults are the final load step, vertical displacement, and `scale=1`. In `plot_stress_Cauchy.m`, the defaults are the final load step, `sigma_x`, and `scale=0`.

The current plotting programs use `turbo(16)` and call `drawnow` after plotting.

The package was executed successfully in MATLAB R2026a for the supplied mesh (`767` nodes and `685` Q4 elements).
