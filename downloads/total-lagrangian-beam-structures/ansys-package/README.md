# ANSYS comparison model

## Purpose

`macro.mac` defines the semicircular-beam model used to compare the Section 7.2 Total Lagrangian MATLAB solution with ANSYS.

## Model

- BEAM188 elements
- radius: 50 mm
- rectangular cross-section: 20 mm × 1 mm
- Young's modulus: 200000 MPa
- Poisson's ratio: 0.3
- horizontal load: 300 N
- large-displacement analysis enabled with `NLGEOM,1`

## How to use

Open ANSYS Mechanical APDL, read `macro.mac` as an input file, and solve the model. Review the deformed configuration at the final load level and compare it with the MATLAB result presented in Section 7.2.

## Verification status

The macro has been inspected structurally and preserved without changes to its mechanics. It was not executed during preparation of this package; therefore no ANSYS version is claimed as tested.

