#import "Styles/styles.typ": *
#import "@local/math-book:0.2.0": apply-math-book, book-part

#let theme = if sys.inputs.at("theme", default: "light") == "dark" { dark-theme } else { light-theme }
#show: apply-math-book.with(
  theme: theme,
  title: "Partial Differential Equations",
  author: "Kim Taeyoung",
  description: "Partial Differential Equations",
  running-header: true,
  chapter-pages: true,
)

#include "cover.typ"

#book-part(prefix: "P", center-sections: true)[
  #include "Preliminaries/preliminaries.typ"
]

#book-part(prefix: "S", center-sections: true)[
  #include "Supplementary/supplementary.typ"
]

#book-part[
  #include "chapter 1/chapter 1.typ"
  #include "chapter 2/chapter 2.typ"
  #include "chapter 3/chapter_3.typ"
]
#bibliography("references.bib")
