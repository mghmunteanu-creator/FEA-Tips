# FEA Tips — Global Rules / Do Not Forget

Consult this checklist at the beginning of every FEA Tips task. Explicit instructions from Mircea for the current task take precedence.

## A. Scientific content

- Preserve all scientific content: equations, derivations, explanations, examples, figures, numerical results, and technical comments.
- Do not summarize, shorten, simplify, reorder, reinterpret, or modernize scientific material unless explicitly requested.
- Never introduce scientific changes as part of editorial cleanup.
- Chapters and sections should remain scientifically self-contained when appropriate. Preserve controlled repetition of essential definitions, hypotheses, coordinate conventions, and governing equations so that a reader can enter directly at a page without being forced to read an earlier page first. Rephrase explanatory prose when useful, but do not alter formulas merely to create artificial variation.

## B. Mathematical rendering

- Keep braces continuous and correctly scaled; size parentheses and other delimiters proportionally to their contents.
- Keep integral and summation symbols well proportioned and overbars correctly centered.
- Long equations may remain on one line and use horizontal scrolling when necessary.
- Distinguish vectors and matrices typographically from scalars. In theoretical formulas, vectors and matrices use bold italic notation, while scalar quantities remain normal italic mathematics, unless a specific established convention requires otherwise. Do not use bold upright vector notation merely as a default. Preserve meaningful conventions already established in the project.
- In theoretical derivations, \(\boldsymbol{u}\) denotes the global vector containing all nodal displacement degrees of freedom of the finite element discretization. The same bold italic convention applies to global nodal vectors such as \(\boldsymbol{x}\) and \(\boldsymbol{y}\).
- MATLAB variables such as `S` may represent a theoretical vector inside a program, but implementation-variable names must not replace the theoretical notation merely because the code uses them. Use \(\boldsymbol{u}\) in theory, preserve the actual variable name in MATLAB code and program explanations, and make the distinction explicit when theory and code appear together and ambiguity is possible.
- Use \(\mathcal{A}\) for the standard finite element assembly operator and explain it briefly and locally when useful: \(\mathcal{A}\) denotes the standard finite element assembly operator. Element quantities retain their established notation, including \(A_{el}\) for element area and \(\boldsymbol{k}_{el}\) for the element stiffness matrix; do not change those symbols merely to accommodate the assembly operator. This short explanation may be repeated so that each section remains reasonably self-contained; do not add a dedicated Nomenclature entry at this time.
- Do not change global CSS or shared math-rendering components to solve a local problem without explicit approval.
- Protect previously approved pages from visual regressions.

## C. Hypotheses

- Where applicable, present the principal hypotheses near the beginning of the chapter or section in the established approved style.

## D. Derivative notation

- Use comma notation for coordinate derivatives in subscripts: \(N_{u,x}\), \(N_{v,x}\), \(N_{v,xx}\), and analogous expressions.

## E. Strain notation

- Use \(\varepsilon\) consistently for strain quantities and preserve meaningful subscripts such as \(\varepsilon_0\).

## F. Coordinate conventions

- Beam formulations: \(x\) is the axial reference/local coordinate, \(s\) is arc length, and \(\xi\in[-1,1]\) is the natural coordinate.
- Do not use \(s\) as the natural coordinate of a beam element.
- Elasticity formulations: use \(s,t\) in 2D and \(s,t,r\) in 3D.
- Never use one symbol for two different geometric meanings in the same formulation.

## G. Total and Updated Lagrangian cautions

- In a Total Lagrangian formulation, take derivatives with respect to the initial/reference configuration.
- For a straight beam in its local reference frame, \(x\) coincides with the initial arc coordinate; do not add unnecessary explanations such as \(ds\simeq dx\).
- In an Updated Lagrangian formulation, check the changing reference configuration especially carefully.

## H. Timoshenko and planar-beam notation

- \(\beta\): shear angle; \(\varphi\): rotation of the normal; \(\psi\): rotation of the cross-section.
- The angular nodal degree of freedom is \(\psi\), not \(\varphi\).
- For planar beams, \(T\equiv T_y\) and \(M\equiv M_z\).

## I. MATLAB conventions

- Target MATLAB 2024 unless otherwise specified.
- For current new work, prefer actual testing in MATLAB R2026a when it is available. If another version is used, record the exact tested version internally and use concise, accurate public wording.
- Use the exact file header `%*** filename ***`, without `.m` and without spaces between `%` and `***`.
- Use `ip` instead of `ipos` when it denotes only the integration-point index.
- Every downloadable MATLAB package should contain `README.md`.
- README compatibility statements must distinguish clearly between versions actually executed/tested, versions expected to work from the syntax and features used, and any special compatibility substitution. Never claim that a MATLAB release was tested unless the program was actually executed in that release.
- When a published MATLAB program uses `turbo(...)`, its `README.md` must state: "`turbo` is available in MATLAB R2020b and later. For earlier MATLAB releases, replace `turbo` with `jet`. This affects visualization only and does not change the numerical results."
- When `jet` appears in a legacy MATLAB program, do not replace it blindly. First verify that it is used only for visualization. If so, `turbo` may be used in the published program, the compatibility substitution must be documented in `README.md`, and numerical calculations and results must remain unchanged.
- Preserve the established user-friendly load-step selection behavior where applicable.

## J. References

- Use direct bibliography/reference links where practical.
- Do not attribute the author's derivations, explanations, or numerical results to an external reference unless that reference actually supports them.
- Every reference listed in a page bibliography must be cited in the page text where it is actually used. Avoid orphan bibliography entries, and ensure that each citation directly supports the surrounding statement, derivation, benchmark, or imported result.

## K. The public site is self-contained

- Never refer in public scientific text or README files to “the source”, “source derivation”, “original source”, “source version”, “old site”, “old post”, “original post”, “original program”, “revised program”, “old program”, “migrated version”, or the migration/reconstruction process, unless the historical distinction is itself scientifically relevant.
- Describe each program, formulation, figure, and section as it exists in the published FEA Tips site. Internal editing and migration history must remain internal.
- Treat old materials only as internal working references. The new site must read as an independent scientific website.

## L. Page hierarchy

- Chapter with sections: small header `SECTION X.Y OF CHAPTER X: Chapter title`; main title `Section title`; sidebar `SECTION X.Y`, `Section title`, `ON THIS PAGE`.
- Chapter without sections: small header `CHAPTER X`; main title `Chapter title`; sidebar `CHAPTER X`, `Chapter title`, `ON THIS PAGE`.
- Internal headings `01`, `02`, `03`, etc. are page headings, not sections. Never invent sections.

## M. Chapters 3–4 special case

- Chapters 3 and 4 retain the accepted common presentation title “Large Displacements of a Cantilever Beam”. They remain chapters, distinguished by their methods, not sections.

## N. Figures

- Preserve aspect ratio and image quality.
- Choose display size primarily from the readability and visual scale of letters, symbols, and annotations inside the figure.
- Do not enlarge figures unnecessarily.
- Figure captions must be left-aligned like normal body text and must never be justified or stretched across the available width.
- Mathematical expressions inside captions use normal mathematical weight and normal character spacing. Scalar quantities must not be bold. Bold mathematical notation is reserved for cases where it is mathematically required, such as vectors or matrices.
- The caption label, such as **Figure 7.**, may remain bold.
- Displacement maps, stress maps, and similar field-result figures may be displayed relatively compactly when this improves page balance. Where visual detail is useful, clicking the map should open a local lightbox-style enlarged view that preserves aspect ratio and remains within the viewport; clicking outside the image or pressing `Esc` closes it. Apply this selectively to result maps, not blindly to ordinary schematic figures.

## N.1 Tables

- When table headers make a table unnecessarily wide, use compact multi-line headers where appropriate. Prefer vertical compactness over horizontal expansion, for example **Standard** / **assembly (s)**, **Fast** / **assembly (s)**, and **Overall** / **speed-up**.
- Dimensionless speed-up quantities carry no time unit. Never use `(S)` as a time unit; the SI symbol for seconds is lowercase `s`, displayed as `(s)` where a unit is needed in a header.

## O. Branding

- Preserve previously approved branding elements, including the existing blue logo, unless explicitly instructed otherwise.

## P. Homepage

- Preserve the random formula/MATLAB card behavior on reload and the corrected character encoding.

## Q. Periodic audit

- After several chapters or major updates, perform a global visual and structural audit to detect regressions.

## Required completion check

- Confirm the task changed only authorized files and content.
- Run the existing checks appropriate to the change.
- Verify affected pages on desktop and mobile when visual work is involved.
- Before publication, review the final diff and report exact files changed, tests performed, and any item not verified.
