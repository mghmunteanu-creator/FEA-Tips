# FEA Tips — Global Rules / Do Not Forget

Consult this checklist at the beginning of every FEA Tips task. Explicit instructions from Mircea for the current task take precedence.

## A. Scientific content

- Preserve all scientific content: equations, derivations, explanations, examples, figures, numerical results, and technical comments.
- Do not summarize, shorten, simplify, reorder, reinterpret, or modernize scientific material unless explicitly requested.
- Never introduce scientific changes as part of editorial cleanup.

## B. Mathematical rendering

- Keep braces continuous and correctly scaled; size parentheses and other delimiters proportionally to their contents.
- Keep integral and summation symbols well proportioned and overbars correctly centered.
- Long equations may remain on one line and use horizontal scrolling when necessary.
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
- Use the exact file header `%*** filename ***`, without `.m` and without spaces between `%` and `***`.
- Use `ip` instead of `ipos` when it denotes only the integration-point index.
- Every downloadable MATLAB package should contain `README.md`.
- Distinguish versions actually executed/tested from expected compatibility; never claim execution that did not occur.
- Preserve the established user-friendly load-step selection behavior where applicable.

## J. References

- Use direct bibliography/reference links where practical.
- Do not attribute the author's derivations, explanations, or numerical results to an external reference unless that reference actually supports them.

## K. The public site is self-contained

- Never refer in public scientific text to “the source”, “source derivation”, “original source”, “old site”, “old post”, “original post”, or the migration/reconstruction process.
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
