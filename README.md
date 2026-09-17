# Partial Differential Equations
![Typst](https://img.shields.io/badge/Typst-0.15.0-239DAD?logo=typst)

> Detailed personal PDE study notes based primarily on Michael E. Taylor’s Partial Differential Equations I.

These are my personal study notes on partial differential equations, based
primarily on Michael E. Taylor's *Partial Differential Equations I: Basic
Theory*. The notes reorganize the material and expand arguments, computations,
and geometric interpretations that I found necessary for a rigorous
understanding.

## Read the notes

[Open the unified notes homepage](https://kimpossible-ty.github.io/Partial-Differential-Equations/)

The homepage includes the interactive PDF reader, direct PDF access, and the
build-derived statistics view.

## Primary reference

Michael E. Taylor, *Partial Differential Equations I: Basic Theory*,  
3rd ed., Applied Mathematical Sciences, vol. 115, Springer, 2023.  
[https://doi.org/10.1007/978-3-031-33859-5](https://doi.org/10.1007/978-3-031-33859-5)

## Disclaimer

These notes are an independent study resource and are not an official
companion to Taylor's textbook. Any errors in the exposition are my own.

## Build and shared Typst packages

Install the sibling `typst-packages` repository with its `scripts/install-local.sh`
before compiling. The document uses `math-book:0.2.0`, `math-blocks:0.2.0`,
`text-utils:0.1.2`, `scoped-annotations:0.3.0`, `cetz-helpers:0.2.0`,
`fletcher-helpers:0.1.0`, and `pdf-versioning:0.1.0`.

```sh
typst compile --font-path fonts main.typ main.pdf
typst compile --font-path fonts --input theme=dark main.typ main-dark.pdf
```

`main.typ` owns metadata, theme choice, and document parts. `cover.typ` supplies
cover content and frontmatter. `Styles/styles.typ` is the shared import facade;
other `Styles` modules preserve old import paths without duplicate implementations.
Mathematical text and individual diagrams remain in this repository.

The deployment workflow installs packages from `kimpossible-TY/typst-packages`.
Publish its new package versions before deploying a revision using these imports.
