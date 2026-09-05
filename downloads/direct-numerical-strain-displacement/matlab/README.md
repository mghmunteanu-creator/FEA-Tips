# Section 17.5 — direct numerical evaluation of B and kel

This package implements the multiplicative deformation-gradient update of Section 17.4 together with two nested central numerical differentiations:

1. `strain_el.m` evaluates the total Hencky or Biot strain from the current trial configuration and the deformation gradient stored at the preceding converged load step.
2. `fel_el.m` differentiates that total strain numerically to obtain the strain-displacement matrix `B`.
3. `stiff.m` differentiates the element internal nodal force vector numerically to obtain the tangent stiffness matrix `kel`.

The implemented sequence is:

```text
Fprev -> Finc -> Ftot -> total strain -> B -> fel -> kel
```

## Files

- `main.m` — load stepping, Newton iterations and storage of the converged total deformation gradients.
- `gen.m` — reduced cantilever mesh and input data: 150 Q4 elements and 186 nodes.
- `stiff.m` — global assembly and central numerical differentiation of `fel`.
- `fel_el.m` — element internal force and central numerical differentiation of the total strain.
- `strain_el.m` — multiplicative kinematics and total Hencky or Biot strain.
- `plot_disp.m`, `plot_strain.m`, `plot_stress.m` — postprocessing programs using `turbo(16)` and explicit input defaults.

## Strain option

At the beginning of `stiff.m`:

```matlab
istrain=1;   % 1 - Hencky strain
             % 2 - Biot strain
```

The distributed program uses Hencky strain by default. Set `istrain=2` for Biot strain.

## Numerical perturbations

The default values are:

```matlab
ddB=1e-3;    % perturbation for numerical B
ddK=1e-3;    % perturbation for numerical kel
```

For the bending example discussed in Section 17.5, values around `1e-3` were the most robust among the tested values. These perturbations are dimensional; their appropriate values depend on the analyzed problem and on the displacement scale.

The perturbations used to calculate `B` and `kel` always use `Fprev(:,:,ig,istep)`, which belongs to the preceding converged load step. Perturbed evaluations do not alter this history. Only the unperturbed evaluation stores the trial total deformation gradient in the next load-step slot.

## Stress output

The program stores Cauchy stresses with respect to the fixed global `x-y` axes:

- columns 1:3 of `sigmt` — `sigma_x`, `sigma_y`, `tau_xy`;
- column 4 — von Mises equivalent stress.

No local-stress transformation is performed in this formulation.

## Notes

The implementation is intentionally sequential and pedagogical. Because the numerical strain-displacement matrix is evaluated inside every perturbed internal-force evaluation, the program is computationally expensive.

The plotting programs use `turbo(16)`, provide explicit defaults, and use `scale=1` by default.

This multiplicative double-differentiation version is supplied for validation by Mircea before publication of Section 17.5.
