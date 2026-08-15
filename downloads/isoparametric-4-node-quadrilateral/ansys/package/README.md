# Section 9.4 — ANSYS comparison model

The package contains the APDL macro `macro.mac` for the plane-stress cantilever comparison model accompanying Section 9.4.

The macro defines:

- a 200 mm × 50 mm cantilever with 5 mm thickness;
- `PLANE182` elements in plane stress with thickness;
- Young's modulus 210000 MPa and Poisson's ratio 0.3;
- 640 four-node elements and 697 nodes;
- a clamped left edge;
- a total vertical force of 1000 N distributed over the right-edge nodes.

The macro was inspected for consistency with the MATLAB model but was not executed during preparation of this package.
