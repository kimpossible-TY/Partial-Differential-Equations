#import "Styles/styles.typ": *

// Theme toggle.
// Use `light-theme` or `dark-theme`; the mode is applied through #set below.
#let theme = light-theme

// global setup
#set par(justify: true)
#set text(font: "Times New Roman", size: 12pt, fill: theme.text)
#set table(stroke: theme.rule)
#set page(
  fill: theme.page,
  margin: auto,
  header: context {
    let page_num = here().page()
    if calc.even(page_num) {
      let h_all = query(selector(heading.where(level: 2)))
      let h_valid = h_all.filter(h => h.location().page() <= page_num)
      
      if h_valid.len() > 0 {
        let h_on_page = h_valid.filter(h => h.location().page() == page_num)
        let current = if h_on_page.len() > 0 { h_on_page.first() } else { h_valid.last() }
        
        let ch_all = query(selector(heading.where(level: 1)))
        let ch_here = ch_all.filter(c => c.location().page() <= page_num)
        let ch_heading = ch_all.filter(c => c.location().page() <= current.location().page())
        
        let same_chapter = false
        if ch_here.len() > 0 and ch_heading.len() > 0 {
          if ch_here.last().location() == ch_heading.last().location() {
            same_chapter = true
          }
        } else if ch_here.len() == 0 and ch_heading.len() == 0 {
          same_chapter = true
        }

        if same_chapter {
          let num = if current.numbering != none {
            numbering(current.numbering, ..counter(heading).at(current.location()))
          }
          align(left)[
            #text(size: 10pt, style: "italic")[
              #num #current.body
            ]
          ]
        }
      }
    }
  },
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
    // Reset scoped counters at the start of each section.
    counter(math.equation).update(0)
    counter(footnote).update(0)
    reset-math-block-counters()
    set page(fill: theme.page, footer: none)
    set text(font: "New Computer Modern", size: 25pt, fill: theme.text)
    pagebreak(weak: true)
    align(center + horizon, it)
    pagebreak()
  }
}

// Reset the equation counter at the start of each subsection so equations use
// section.subsection.number numbering.
#show heading.where(level: 2): it => {
  counter(math.equation).update(0)
  it
}

// Define equation numbering as (section.subsection.equation).
#set math.equation(numbering: num => {
  let heading-numbers = counter(heading).get()
  let section = heading-numbers.at(0, default: 0)
  let subsection = heading-numbers.at(1, default: 0)

  numbering(
    "(" + heading-numbering-style.get() + ".1)",
    section,
    subsection,
    num,
  )
})

// ---------- ALIGNMENT RULES ----------
// Ensure theorem-like figures are left-aligned (start-aligned) instead of centered.
// These elements are implemented as figures to allow labeling and referencing
// (e.g. @def1), but figures are centered by default.
#show figure: it => {
  if it.kind in math-block-kinds {
    set align(start)
    it
  } else {
    it
  }
}

// ---------- PARAGRAPH TAB RULES ----------
// Rule 1: Handle paragraph_tab followed by normal lowercase text.
// Replaces marker + whitespace + lowercase letter with indent + uppercase letter.
#show regex("\u{F000}\s*(\p{Ll})"): it => {
  let char = it.text.match(regex("\u{F000}\s*(\p{Ll})")).captures.first()
  h(1.5em) + upper(char)
}

// Rule 2: Fallback for paragraph_tab not followed by text (e.g. before equation)
// Just adds the indentation
#show regex("\u{F000}"): h(1.5em)

// the includings
#include "cover.typ"

#set heading(numbering: "P1.1 :")
#heading-numbering-style.update("P1.1")
#show heading.where(level: 2): it => {
  counter(math.equation).update(0)
  align(center, it)
}
#include "Preliminaries/preliminaries.typ"

#set heading(numbering: "1.1 :")
#heading-numbering-style.update("1.1")
#counter(heading).update(0)
#show heading.where(level: 2): it => {
  counter(math.equation).update(0)
  it
}
#include "chapter 1/chapter 1.typ"
#include "chapter 2/chapter 2.typ"
#bibliography("references.bib")
