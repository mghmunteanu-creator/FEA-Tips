# Section 18.2 MATLAB programs — exact plane stress

This package keeps the original simplified formulation and adds exact enforcement of the plane-stress condition. Select the formulation in `main.m` with:

```matlab
iplane=2;    % 1 - J=1 approximation
             % 2 - exact plane stress, Sz=0
```

For `iplane=2`, the out-of-plane Green–Lagrange strain is solved locally at every Gauss point from `Sz=0`. The initial estimate is obtained from `J=1`, and the consistent plane-stress tangent is formed by static condensation of the three-dimensional constitutive tangent. `Ez` is a local constitutive variable and is not an additional nodal degree of freedom.

The program reports the mean local volume ratio only for the exact formulation:

```matlab
J_mean = Jt/4/nel
```

This package contains the Q4 plane-stress Total Lagrangian example for the nearly incompressible Mooney-Rivlin material.

- `main.m` controls the load steps and Newton iterations.
- `gen.m` reads the mesh and defines the material constants, boundary conditions, and loading.
- `stiff.m` evaluates the element internal-force vector and tangent stiffness matrix.
- `MoonRiv_stress.m` evaluates the plane-stress constitutive response using the approximation `J=1`.
- `MoonRiv_exact_stress.m` evaluates the three-dimensional constitutive response used by the local `Sz=0` iteration.
- `plot_disp.m`, `plot_strain.m`, and `plot_stress.m` plot displacement, Green-Lagrange-strain, and second Piola-Kirchhoff-stress maps.
- `nodes` and `elements` contain the mesh data.

Run `main.m`. The plotting programs have explicit prompts and defaults. `plot_disp.m` uses a default deformation scale of 1. `plot_strain.m` and `plot_stress.m` retain the default scale of 0 so that their maps are displayed on the undeformed configuration.

The exact option was executed successfully with MATLAB R2026a. For the supplied mesh and loading it gives `v_min=-202.9000 mm` and `J_mean=1.0119`.

`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results.
