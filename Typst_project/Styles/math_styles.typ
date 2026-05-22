#let math_font = "New Computer Modern Math"

#import "utils.typ": *
#import "callouts.typ": *
#import "theme.typ": *

// The theorem-like blocks are figures so they can be numbered, labeled, and
// referenced with Typst's normal @label mechanism.
#let math-block-kinds = ("theorem", "proposition", "lemma", "definition", "note")

// Helper for figure numbering that includes section number
#let scoped-figure-numbering(..nums) = {
  let n = nums.pos().first()
  context {
    let h = counter(heading).get().first()
    let style = heading-numbering-style.get()
    numbering(style, h, n)
  }
}

#let math-block-title(label, kind, title) = context {
  let c = counter(figure.where(kind: kind))
  let num = scoped-numbering(c)

  if title != none {
    strong[#label #num (#capitalize-title(title)) : ]
  } else {
    strong[#label #num : ]
  }
}

#let numbered-math-block(kind, label, body, title: none, callout-type: none) = {
  let box-type = if callout-type == none { kind } else { callout-type }

  figure(
    kind: kind,
    supplement: label,
    numbering: scoped-figure-numbering,
    caption: none,
    callout(
      type: box-type,
      title: math-block-title(label, kind, title),
      inline-title: is-numeric-title(title),
      body,
    ),
  )
}

#let reset-math-block-counters() = {
  for kind in math-block-kinds {
    counter(figure.where(kind: kind)).update(0)
  }
}

// ---------- THEOREM BOX ----------
#let theorem(body, title: none) = numbered-math-block("theorem", "Theorem", body, title: title)

// ---------- PROPOSITION BOX ----------
#let proposition(body, title: none) = numbered-math-block("proposition", "Proposition", body, title: title)

// ---------- LEMMA BOX ----------
#let lemma(body, title: none) = numbered-math-block("lemma", "Lemma", body, title: title)

// ---------- EMPHASIS BOX ----------
#let emphasis(body, title: none) = pad(left: 2em, callout(
  type: "emphasis",
  title: if title != none { strong(capitalize-title(title)) } else { none },
  inline-title: is-numeric-title(title),
  body,
))

// ---------- DEFINITION BOX ----------
#let definition(body, title: none) = numbered-math-block("definition", "Definition", body, title: title)

// ---------- NOTE BOX ----------
#let note(body, title: none) = numbered-math-block("note", "Note", body, title: title)

// Reset counters at the beginning of each section
#show heading.where(level: 1): it => {
  reset-math-block-counters()
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
#let flowbox(body) = context {
  let theme = theme-from-text-fill()

  block(
    width: 100%,
    stroke: 1pt + theme.rule,
    inset: (left: 1em, right: 1em, top: 1em, bottom: 1em),
    align(center, body),
  )
}
