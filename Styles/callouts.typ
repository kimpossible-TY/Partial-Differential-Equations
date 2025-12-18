
// Styles/callouts.typ

#let math_font = "New Computer Modern Math"
#let title_size = 10.8pt

// ---------- CALLOUT ----------
#let callout(
  type: "note",
  title: none,
  inline-title: false,
  body,
) = {
  let colors = (
    note: (bg: rgb("#f8f9fa"), border: rgb("#2c3e50")),
    warning: (bg: rgb("#fef5f5"), border: rgb("#d63031")),
    important: (bg: rgb("#f0ebf8"), border: rgb("#6c5ce7")),
    tip: (bg: rgb("#ebf5e6"), border: rgb("#27ae60")),
    theorem: (bg: rgb("#fdf2f2"), border: rgb("#d9534f")),
    proposition: (bg: rgb("#f0f5ff"), border: rgb("#4a90e2")),
    definition: (bg: rgb("#fffbe6"), border: rgb("#f5a623")),
    lemma: (bg: rgb("#f0fff0"), border: rgb("#50c878")),
    emphasis: (bg: none, border: black),
  )

  let color-info = colors.at(type, default: colors.note)


  block(
    width: 100%,
    fill: color-info.bg,
    stroke: (left: 3pt + color-info.border),
    inset: (left: 1.2em, right: 1em, top: 1em, bottom: 1em),
    radius: 2pt,
    [
      #if title != none {
        if inline-title {
          text(weight: 600, size: title_size, fill: color-info.border, font: math_font)[#title]
        } else {
          block(width: 100%, below: 0.8em)[
            #text(weight: 600, size: title_size, fill: color-info.border, font: math_font)[#title]
          ]
        }
      }#text(size: 12pt, fill: rgb("#1a1a1a"), font: math_font)[#body]
    ],
  )
}
