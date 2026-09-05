# Section 9.1 — ANSYS Comparison Model

## Purpose

`macro.mac` reproduces the plane-stress cantilever model used for the Section 9.1 CST comparison.

## Model represented by the macro

- PLANE182 elements with plane-stress behavior and thickness
- length: 200 mm
- height: 50 mm
- thickness: 5 mm
- Young's modulus: 2.1e5 MPa
- Poisson ratio: 0.3
- 697 nodes and 1280 triangular elements
- both translations constrained at the 17 nodes on `x = 0`
- total vertical end load: -1000 N, distributed over the 17 nodes on `x = 200`

## Use

Read `macro.mac` in a compatible ANSYS Mechanical APDL environment and solve the static analysis. Review nodal displacements and the corresponding plane-stress results for comparison with the MATLAB solution.

## Verification status

The macro was inspected structurally against the MATLAB model. It was not executed during preparation of this package.

This macro was validated in the original version of the example. It has been transferred to the present edition without technical modification and was therefore not re-executed during the current revision.

