// Styles/callouts.typ
#import "theme.typ": *

#let math_font = "New Computer Modern Math"
#let title_size = 10.8pt

// ---------- CALLOUT ----------
#let callout(
  type: "note",
  title: none,
  inline-title: false,
  body,
) = context {
  let colors = theme-from-text-fill().callouts
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
      }#text(size: 12pt, font: math_font)[#body]
    ],
  )
}
