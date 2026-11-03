# Consistent Updated Lagrangian formulation with HEX20 elements

Extract all eight MATLAB files to one directory, select it as the MATLAB current folder and run `main.m`. The main program controls load steps and Newton iterations; `gen.m` supplies the mesh, constraints and loads. The remaining files evaluate interpolation, element forces and tangent stiffness, and visualize the mesh and results.

The ZIP contains the eight MATLAB files unchanged. This README accompanies it separately.

## Compatibility and verification

The numerical results on Section 27.3 are supplied by the author. The program was not executed in MATLAB during this website integration. MATLAB R2024 is the project target; compatibility has not been independently executed or certified in this integration.

`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results.
