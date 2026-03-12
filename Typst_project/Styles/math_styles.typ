#let math_font = "New Computer Modern Math"

#import "utils.typ": *
#import "callouts.typ": *


// ---------- THEOREM BOX ----------
#let theorem(body, title: none) = callout(
  type: "theorem",
  title: strong("Theorem " + capitalize-title(title) + " : "),
  inline-title: is-numeric-title(title),
  body,
)

// ---------- PROPOSITION BOX ----------
#let proposition(body, title: none) = callout(
  type: "proposition",
  title: strong("Proposition " + capitalize-title(title) + " : "),
  inline-title: is-numeric-title(title),
  body,
)

// ---------- LEMMA BOX ----------
#let lemma(body, title: none) = callout(
  type: "lemma",
  title: strong("Lemma " + capitalize-title(title) + " : "),
  inline-title: is-numeric-title(title),
  body,
)

// ---------- EMPHASIS BOX ----------
#let emphasis(body, title: none) = pad(left: 2em, callout(
  type: "emphasis",
  title: if title != none { strong(capitalize-title(title)) } else { none },
  inline-title: is-numeric-title(title),
  body,
))

// ---------- DEFINITION BOX (with numbering) ----------
// Helper for figure numbering that includes section number
#let scoped-figure-numbering(..nums) = {
  let n = nums.pos().first()
  context {
    let h = counter(heading).get().first()
    let style = heading-numbering-style.get()
    numbering(style, h, n)
  }
}

// Implemented as a figure to support labeling and referencing (e.g. <def1>, @def1).
#let definition(body, title: none) = figure(
  kind: "definition",
  supplement: "Definition",
  numbering: scoped-figure-numbering,
  caption: none, // Hide default caption
  callout(
    type: "definition",
    title: context {
      let c = counter(figure.where(kind: "definition"))
      let num = scoped-numbering(c)
      if title != none {
        strong("Definition " + num + " (" + capitalize-title(title) + ") : ")
      } else {
        strong("Definition " + num + " : ")
      }
    },
    inline-title: is-numeric-title(title),
    body,
  ),
)

// ---------- NOTE BOX (with numbering) ----------
#let note(body, title: none) = figure(
  kind: "note",
  supplement: "Note",
  numbering: scoped-figure-numbering,
  caption: none,
  callout(
    type: "note",
    title: context {
      let c = counter(figure.where(kind: "note"))
      let num = scoped-numbering(c)
      if title != none {
        strong("Note " + num + " (" + capitalize-title(title) + ") : ")
      } else {
        strong("Note " + num + " : ")
      }
    },
    inline-title: is-numeric-title(title),
    body,
  ),
)

// ---------- special Lemma ----------
#let special_lemma(body, title: none) = figure(
  kind: "special_lemma",
  supplement: "Special Lemma",
  numbering: scoped-figure-numbering,
  caption: none,
  callout(
    type: "lemma",
    title: context {
      let c = counter(figure.where(kind: "special_lemma"))
      let num = scoped-numbering(c)
      if title != none {
        "Special Lemma " + num + " (" + capitalize-title(title) + "):"
      } else {
        "Special Lemma " + num + ":"
      }
    },
    inline-title: is-numeric-title(title),
    body,
  ),
)


// Reset counters at the beginning of each section
#show heading.where(level: 1): it => {
  counter(figure.where(kind: "definition")).update(0)
  counter(figure.where(kind: "note")).update(0)
  counter(figure.where(kind: "special_lemma")).update(0)
  it
}

// ---------- Proof ----------

#let qed = h(1fr) + sym.qed

#let proof(body) = {
  parbreak()
  text(weight: "bold", font: math_font)[Proof. ]
  body
  parbreak()
  qed
}

// ---------- FOOTNOTE IN EQUATION STYLE ----------
#let dots_space = {
  $& wide dots.h.c thin$
}

// ---------- FLOW BOX ----------
#let flowbox(body) = block(
  width: 100%,
  stroke: 1pt,
  inset: (left: 1em, right: 1em, top: 1em, bottom: 1em),
  align(center, body),
)

