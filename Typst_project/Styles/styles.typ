// Main styles file that imports all style modules
#import "../Styles/cetz_utils.typ" : *
#import "local_tags/local_tags.typ": *
#import "math_styles.typ": *
#import "@preview/mannot:0.3.2": *

// ---------- Marks ----------
#let rmark = mark.with(color: red)
#let bmark = mark.with(color: blue)
#let pmark = mark.with(color: purple)

// Define differential operator
#let dx = $upright(d) x$

// ---------- TITLE OF BOOK ----------
#let book-title(body) = {
  v(8em)
  text(font: "Rockwell", size: 36pt, weight: "bold")[#body]
}

// ---------- AUTHOR ----------
#let author-name(body) = {
  v(1.5em)
  text(font: "Copperplate", size: 24pt, weight: "medium")[#body]
}

// ---------- CALLOUT ----------
#let callout(
  type: "note",
  title: none,
  body,
) = {
  let colors = (
    note: (bg: rgb("#f8f9fa"), border: rgb("#2c3e50")),
    warning: (bg: rgb("#fef5f5"), border: rgb("#d63031")),
    important: (bg: rgb("#f0ebf8"), border: rgb("#6c5ce7")),
    tip: (bg: rgb("#ebf5e6"), border: rgb("#27ae60")),
    theorem: (bg: rgb("#f5f0ff"), border: rgb("#8e44ad")),
  )

  let color-info = colors.at(type, default: colors.note)

  block(
    fill: color-info.bg,
    stroke: (left: 3pt + color-info.border),
    inset: (left: 1.2em, right: 1em, top: 1em, bottom: 1em),
    radius: 2pt,
    [
      #if title != none {
        text(weight: "600", size: 10.5pt, color: color-info.border, tracking: 0.05em)[#title]
        linebreak()
        v(0.4em)
      }
      #text(size: 12pt, color: rgb("#1a1a1a"))[#body]
    ],
  )
}

// ---------- paragraph tab ----------
#let paragraph_tab = "\u{F000}"

// ---------- HIGHLIGHTED ----------
//
// Custom highlight function. The orginal highlight function doens't support to highlight equations properly. The custom function below highlights equations in a box.
#let highlighted(body) = {
  // Iterate over each child element within the provided body.
  for child in body.children {
    // Check if the child element is an equation.
    // `child.func()` returns the function associated with the element (e.g., `equation`).
    // `repr()` converts this function reference to a string for comparison.
    if repr(child.func()) == "equation" {
      // If it's an equation, display it in a highlighted box.
      box(
        fill: rgb("#FFFE80"), // Set the background color for the highlight.
        outset: (y: 0.25em), // Add some vertical padding around the equation.
      )[$#child.at("body")$] // Get the content of the equation.
    } else {
      // If it's not an equation, use the default highlight function.
      highlight(child)
    }
  }
}
