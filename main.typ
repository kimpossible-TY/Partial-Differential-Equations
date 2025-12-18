#import "Styles/styles.typ": *

// global setup
#set par(justify: true)
#set text(font: "Times New Roman", size: 12pt)
#set page(
  margin: auto,
  footer: context [
    #align(right)[
      #counter(page).display("1") / #counter(page).final().last()
    ]
  ],
)

#set document(
  title: "Partial Differential Equations",
  author: "Kim Taeyoung",
  description: "Partial Differential Equations",
)

#show heading.where(level: 1): it => {
  if it.numbering == none {
    pagebreak(weak: true)
    it
  } else {
    // Reset the equation counter at the start of each section
    counter(math.equation).update(0)
    counter(footnote).update(0)
    set page(footer: none)
    set text(font: "New Computer Modern", size: 25pt)
    pagebreak(weak: true)
    align(center + horizon, it)
    pagebreak()
  }
}

// Define equation numbering as (section.equation)
#set math.equation(numbering: num => {
  numbering(
    "(" + heading-numbering-style.get() + ")",
    counter(heading).get().first(), // Get current section number
    num, // Equation number within the section
  )
})

// ---------- ALIGNMENT RULES ----------
// Ensure these specific figures are left-aligned (start-aligned) instead of centered.
// These elements (definition, note, special_lemma) are implemented as figures to allow
// for labeling and referencing (e.g. @def1), but figures are centered by default.
#show figure: it => {
  if it.kind in ("definition", "note", "special_lemma") {
    set align(start)
    it
  } else {
    it
  }
}

// ---------- PARAGRAPH TAB RULES ----------
// Rule 1: Handle paragraph_tab followed by a character (captures the char)
// Replaces marker + whitespace + char with indent + uppercase char
#show regex("\u{F000}\s*(\S)"): it => {
  let char = it.text.match(regex("\u{F000}\s*(\S)")).captures.first()
  h(1.5em) + upper(char)
}

// Rule 2: Fallback for paragraph_tab not followed by text (e.g. before equation)
// Just adds the indentation
#show regex("\u{F000}"): h(1.5em)

// the includings
#include "cover.typ"

#set heading(numbering: "P1.1 :")
#heading-numbering-style.update("P1.1")
#include "Preliminaries/preliminaries.typ"

#set heading(numbering: "1.1 :")
#heading-numbering-style.update("1.1")
#counter(heading).update(0)
#include "chapter 1/chapter 1.typ"
#include "chapter 2/chapter 2.typ"
#bibliography("references.bib")
