#import "../Styles/styles.typ": *
#import "@preview/cetz:0.4.2"

#mannot-scope(l=> [
  $
    frac(partial f_Q, partial xi_j)&=gamma g^(a b) mark(frac(partial, partial xi_j), tag: #(l.tag)("derivative")) (rmark(xi_a, tag: #(l.tag)("xi_a")) bmark(xi_b, tag: #(l.tag)("xi_b")))
  $

  #(l.annot)(
    ("derivative", "xi_a", "xi_b"),
    cetz,
    {
      import cetz.draw: *
      set-style(mark: (end: "straight"))

      bezier-through(
        (l.node)("derivative","south"),
        (rel : (x:0.3, y: -0.3)),
        (l.node)("xi_a", "south"),
        stroke: red
      )

      bezier-through(
        (l.node)("derivative","south"),
        (rel : (x:0.5, y: -0.5)),
        (l.node)("xi_b", "south"),
        stroke: blue
      )
    }
  )
])
