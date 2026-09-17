#import "Styles/styles.typ": *
#import "@local/math-book:0.2.0": book-cover
#import "build-info.typ": document-branch, document-built-at, document-base-url, document-source-url
#import "@local/pdf-versioning:0.1.0": pdf-version-links

#context {
  let theme = theme-from-text-fill()
  book-cover(
    title: [Partial Differential \ Equations],
    subtitle: [An In-Depth Mathematical Formulation],
    author: [Kim Taeyoung],
    affiliation: [DEPARTMENT OF PHYSICS, SOONGSIL UNIVERSITY],
    back-content: $ (partial u)/(partial t) - alpha nabla^2 u = f(x, t) $,
    back-footer: pdf-version-links(
      document-branch, document-built-at, document-base-url, document-source-url,
      fill: theme.muted-text,
    ),
  )
  // Frontmatter keeps the cover's header/footer and paragraph policy.
  set page(header: none, footer: none)
  set par(justify: false)
  [
    #include "Frontmatter/notation.typ"
  ]

  pagebreak()
  show outline.entry: it => {
    let hide-prefix = it.level == 1 and (
      it.body() == [Preliminaries] or
      it.body() == [Supplementaries]
    )

    link(
      it.element.location(),
      it.indented(
        if hide-prefix { none } else { it.prefix() },
        it.inner(),
      ),
    )
  }
  outline(title: "Contents", depth: 3)
}
