#import "../../Styles/styles.typ": theme-from-text-fill
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.4.2": canvas, draw

#let development-chain-diagram() = context {
  let theme = theme-from-text-fill()

  diagram(
    spacing: (5mm, 4mm),
    node-stroke: 0.8pt + theme.rule,
    edge-stroke: 0.8pt + theme.rule,
    node-fill: theme.callouts.note.bg,
    node-inset: 4pt,
    node((0, 0), [Operator $P(D)$], name: <operator>),
    node((0, 1), [Principal symbol $sigma_P$], name: <symbol>),
    node((0, 2), [Multiplier $p(xi)$], name: <multiplier>),
    node((0, 3), [PDE algebra $p hat(u)=hat(f)$], name: <pde>, fill: theme.callouts.proposition.bg),
    node((0, 4), [Singular division $1/p$], name: <singular>, fill: theme.callouts.warning.bg),
    node((0, 5), [Distribution $cal(D)^(*)$], name: <distribution>),
    node((0, 6), [Tempered distribution $cal(S)^(*)$], name: <tempered>, fill: theme.callouts.important.bg),
    node((0, 7), [Fundamental solution $P Phi=delta_(0)$], name: <fundamental>, fill: theme.callouts.tip.bg),
    edge(<operator>, <symbol>, "->"),
    edge(<symbol>, <multiplier>, "->"),
    edge(<multiplier>, <pde>, "->"),
    edge(<pde>, <singular>, "->"),
    edge(<singular>, <distribution>, "->"),
    edge(<distribution>, <tempered>, "->"),
    edge(<tempered>, <fundamental>, "->"),
  )
}

#let differential-fourier-diagram() = context {
  let theme = theme-from-text-fill()

  diagram(
    spacing: (12mm, 9mm),
    node-stroke: 0.8pt + theme.rule,
    edge-stroke: 0.8pt + theme.rule,
    node-fill: theme.callouts.note.bg,
    node-inset: 5pt,
    node((0, 0), [$w$], name: <w>),
    node((1, 0), [$D^(alpha)w$], name: <dw>),
    node((0, 1), [$hat(w)$], name: <hatw>),
    node((1, 1), [$xi^(alpha)hat(w)$], name: <xihatw>),
    edge(<w>, <dw>, "->", label: $D^(alpha)$),
    edge(<w>, <hatw>, "->", label: $cal(F)$),
    edge(<dw>, <xihatw>, "->"),
    edge(<hatw>, <xihatw>, "->"),
  )
}

#let heaviside-dirac-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let blue-color = rgb("#1f77b4")
  let purple-color = rgb("#8e44ad")
  let purple-light = rgb("#a569bd")
  let red-color = rgb("#c0392b")
  let green-color = rgb("#27ae60")

  canvas(length: 0.86cm, {
    import draw: *

    let draw-axes = (x0, title-text) => {
      // Axes
      line((x0 - 2.2, 0), (x0 + 2.2, 0), stroke: (paint: muted, thickness: 0.65pt), mark: (end: ">"))
      line((x0, -0.6), (x0, 2.2), stroke: (paint: muted, thickness: 0.65pt), mark: (end: ">"))
      content((x0 + 2.35, 0), anchor: "west", text(size: 8.5pt)[$x$])
      content((x0 - 0.22, 2.2), anchor: "east", text(size: 8.5pt)[$y$])
      content((x0, 2.6), anchor: "south", text(weight: "bold", size: 9pt)[#title-text])
      content((x0 - 0.22, -0.28), text(size: 8pt)[$0$])
    }

    // Left Panel: Heaviside Function H(x)
    let x0 = -3.5
    draw-axes(x0, [Heaviside Step $H(x)$])

    // y = 1 tick
    line((x0 - 0.08, 1.25), (x0 + 0.08, 1.25), stroke: (paint: muted, thickness: 0.65pt))
    content((x0 - 0.28, 1.25), anchor: "east", text(size: 8pt)[$1$])

    // Step segments
    line((x0 - 1.85, 0), (x0, 0), stroke: (paint: blue-color, thickness: 2.0pt))
    circle((x0, 0), radius: 0.08, fill: white, stroke: (paint: blue-color, thickness: 1.3pt))

    line((x0, 0), (x0, 1.25), stroke: (paint: blue-color, dash: "dashed", thickness: 0.85pt))
    content((x0 + 0.25, 0.62), anchor: "west", text(size: 8pt, fill: blue-color)[Jump $+1$])

    circle((x0, 1.25), radius: 0.08, fill: blue-color, stroke: (paint: blue-color, thickness: 1.3pt))
    line((x0, 1.25), (x0 + 1.85, 1.25), stroke: (paint: blue-color, thickness: 2.0pt))

    // Subtitle annotations
    content((x0, -0.95), anchor: "north", text(size: 8.5pt)[$H'(x) = 0 quad (x eq.not 0)$])
    content((x0, -1.42), anchor: "north", text(size: 7.5pt, fill: red-color)[Classical derivative loses the jump])

    // Center Arrow: Distributional Derivative
    line((-1.0, 0.85), (1.0, 0.85), stroke: (paint: stroke-color, thickness: 1.2pt), mark: (end: ">"))
    content((0, 1.28), anchor: "south", text(size: 8pt, weight: "bold")[Distributional $partial$])
    content((0, 0.50), anchor: "north", text(size: 8.5pt)[$partial T_H = delta_0$])

    // Right Panel: Dirac Delta delta_0
    let x1 = 3.5
    draw-axes(x1, [Dirac Delta $delta_0$])

    // Approximating mollifier (smooth bell curve)
    bezier(
      (x1 - 1.5, 0),
      (x1 + 1.5, 0),
      (x1 - 0.45, 1.7),
      (x1 + 0.45, 1.7),
      stroke: (paint: purple-light, dash: "densely-dashed", thickness: 0.85pt),
      fill: rgb("#f5eef8"),
    )
    content((x1 + 1.05, 1.05), anchor: "west", text(size: 7.5pt, fill: purple-color)[$eta'_epsilon(x)$])

    // Zero baseline
    line((x1 - 1.85, 0), (x1 - 0.05, 0), stroke: (paint: purple-color, thickness: 2.0pt))
    line((x1 + 0.05, 0), (x1 + 1.85, 0), stroke: (paint: purple-color, thickness: 2.0pt))

    // Delta Spike (vertical arrow of unit mass)
    line((x1, 0), (x1, 2.1), stroke: (paint: purple-color, thickness: 2.3pt), mark: (end: ">", fill: purple-color))
    content((x1 + 0.25, 1.95), anchor: "west", text(size: 8.5pt, fill: purple-color)[$delta_0 ("mass " 1)$])

    // Subtitle annotations
    content((x1, -0.95), anchor: "north", text(size: 8.5pt)[$chevron.l phi, delta_0 chevron.r = phi(0)$])
    content((x1, -1.42), anchor: "north", text(size: 7.5pt, fill: green-color)[Concentrated at $x = 0$])
  })
}

#let rescaled-bump-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let c-eps1 = rgb("#2980b9") // Blue for widest eps1
  let c-eps2 = rgb("#8e44ad") // Purple for medium eps2
  let c-eps3 = rgb("#d35400") // Amber/Coral for narrowest eps3

  let fill-eps1 = rgb("#ebf5fb")
  let fill-eps2 = rgb("#f5eef8")
  let fill-eps3 = rgb("#fdf2e9")

  let bump-pts(x0, eps, h, n: 60) = {
    let pts = ()
    for i in range(0, n + 1) {
      let t = -1.0 + 2.0 * i / n
      let x = x0 + t * eps
      let y = if calc.abs(t) >= 0.999 { 0.0 } else { h * calc.exp(1.0 - 1.0 / (1.0 - t * t)) }
      pts.push((x, y))
    }
    pts
  }

  canvas(length: 0.92cm, {
    import draw: *

    let x0 = 0.0
    let h = 2.4
    let eps1 = 3.4
    let eps2 = 1.9
    let eps3 = 0.8

    // Horizontal dashed reference line at y = 1 (split around center peak)
    line((-4.5, h), (x0 - 0.4, h), stroke: (paint: muted, dash: "densely-dotted", thickness: 0.5pt))
    line((x0 + 0.4, h), (4.5, h), stroke: (paint: muted, dash: "densely-dotted", thickness: 0.5pt))

    // Axes
    line((-4.8, 0), (4.8, 0), stroke: (paint: muted, thickness: 0.75pt), mark: (end: ">"))
    line((x0, -0.3), (x0, 3.3), stroke: (paint: muted, thickness: 0.75pt), mark: (end: ">"))
    content((4.95, 0), anchor: "west", text(size: 9pt)[$x$])
    content((x0 + 0.25, 3.25), anchor: "west", text(size: 9pt)[$y$])

    // y = 1 tick
    line((x0 - 0.1, h), (x0 + 0.1, h), stroke: (paint: muted, thickness: 0.75pt))
    content((x0 - 0.25, h), anchor: "east", text(size: 8.5pt)[$1$])

    // Center point x = a
    circle((x0, 0), radius: 0.05, fill: stroke-color)
    content((x0, -0.25), anchor: "north", text(size: 8.5pt)[$a$])

    // Curve 1: eps1 (widest)
    let pts1 = bump-pts(x0, eps1, h)
    line((x0 - eps1, 0), ..pts1, (x0 + eps1, 0), close: true, fill: fill-eps1, stroke: none)
    line(..pts1, stroke: (paint: c-eps1, thickness: 1.5pt))

    // Curve 2: eps2 (medium)
    let pts2 = bump-pts(x0, eps2, h)
    line((x0 - eps2, 0), ..pts2, (x0 + eps2, 0), close: true, fill: fill-eps2, stroke: none)
    line(..pts2, stroke: (paint: c-eps2, thickness: 1.5pt))

    // Curve 3: eps3 (narrowest)
    let pts3 = bump-pts(x0, eps3, h)
    line((x0 - eps3, 0), ..pts3, (x0 + eps3, 0), close: true, fill: fill-eps3, stroke: none)
    line(..pts3, stroke: (paint: c-eps3, thickness: 1.8pt))

    // Baseline zeros (outside eps1)
    line((-4.6, 0), (x0 - eps1, 0), stroke: (paint: c-eps1, thickness: 1.5pt))
    line((x0 + eps1, 0), (4.6, 0), stroke: (paint: c-eps1, thickness: 1.5pt))

    // Fixed Apex point at (a, 1)
    circle((x0, h), radius: 0.08, fill: stroke-color, stroke: (paint: white, thickness: 1.2pt))
    content((x0, h + 0.32), anchor: "south", text(weight: "bold", size: 8.5pt, fill: stroke-color)[
      $eta_epsilon (a) = 1$ #text(weight: "regular", size: 7.5pt)[(fixed peak)]
    ])

    // Direct curve labels placed inside/beside their respective colored domains
    content((x0 - 2.8, 0.75), anchor: "east", text(size: 8.5pt, fill: c-eps1, weight: "bold")[$eta_(epsilon_1)(x)$])
    content((x0 + 1.65, 1.45), anchor: "west", text(size: 8.5pt, fill: c-eps2, weight: "bold")[$eta_(epsilon_2)(x)$])
    content((x0, 1.25), anchor: "center", text(size: 8.5pt, fill: c-eps3, weight: "bold")[
      #box(fill: fill-eps3, inset: (x: 2pt, y: 1pt), radius: 2pt)[$eta_(epsilon_3)(x)$]
    ])

    // Support intervals marked as brackets below axis
    // eps3 bracket
    let y_b3 = -0.55
    line((x0 - eps3, 0), (x0 - eps3, y_b3), stroke: (paint: c-eps3, dash: "dotted", thickness: 0.5pt))
    line((x0 + eps3, 0), (x0 + eps3, y_b3), stroke: (paint: c-eps3, dash: "dotted", thickness: 0.5pt))
    line((x0 - eps3, y_b3), (x0 + eps3, y_b3), stroke: (paint: c-eps3, thickness: 1.1pt))
    line((x0 - eps3, y_b3 - 0.06), (x0 - eps3, y_b3 + 0.06), stroke: (paint: c-eps3, thickness: 1.1pt))
    line((x0 + eps3, y_b3 - 0.06), (x0 + eps3, y_b3 + 0.06), stroke: (paint: c-eps3, thickness: 1.1pt))
    content((x0 + eps3 + 0.2, y_b3), anchor: "west", text(size: 7.5pt, fill: c-eps3, weight: "bold")[$B_(epsilon_3)(a)$])

    // eps2 bracket
    let y_b2 = -0.95
    line((x0 - eps2, 0), (x0 - eps2, y_b2), stroke: (paint: c-eps2, dash: "dotted", thickness: 0.5pt))
    line((x0 + eps2, 0), (x0 + eps2, y_b2), stroke: (paint: c-eps2, dash: "dotted", thickness: 0.5pt))
    line((x0 - eps2, y_b2), (x0 + eps2, y_b2), stroke: (paint: c-eps2, thickness: 1.1pt))
    line((x0 - eps2, y_b2 - 0.06), (x0 - eps2, y_b2 + 0.06), stroke: (paint: c-eps2, thickness: 1.1pt))
    line((x0 + eps2, y_b2 - 0.06), (x0 + eps2, y_b2 + 0.06), stroke: (paint: c-eps2, thickness: 1.1pt))
    content((x0 + eps2 + 0.2, y_b2), anchor: "west", text(size: 7.5pt, fill: c-eps2, weight: "bold")[$B_(epsilon_2)(a)$])

    // eps1 bracket
    let y_b1 = -1.35
    line((x0 - eps1, 0), (x0 - eps1, y_b1), stroke: (paint: c-eps1, dash: "dotted", thickness: 0.5pt))
    line((x0 + eps1, 0), (x0 + eps1, y_b1), stroke: (paint: c-eps1, dash: "dotted", thickness: 0.5pt))
    line((x0 - eps1, y_b1), (x0 + eps1, y_b1), stroke: (paint: c-eps1, thickness: 1.1pt))
    line((x0 - eps1, y_b1 - 0.06), (x0 - eps1, y_b1 + 0.06), stroke: (paint: c-eps1, thickness: 1.1pt))
    line((x0 + eps1, y_b1 - 0.06), (x0 + eps1, y_b1 + 0.06), stroke: (paint: c-eps1, thickness: 1.1pt))
    content((x0 + eps1 + 0.2, y_b1), anchor: "west", text(size: 7.5pt, fill: c-eps1, weight: "bold")[$B_(epsilon_1)(a)$])

    // Inward shrinking arrows (epsilon -> 0)
    let y_arr = -1.75
    line((-4.5, y_arr), (-2.2, y_arr), stroke: (paint: stroke-color, thickness: 0.9pt), mark: (end: ">"))
    line((4.5, y_arr), (2.2, y_arr), stroke: (paint: stroke-color, thickness: 0.9pt), mark: (end: ">"))
    content((0, y_arr), anchor: "center", text(size: 7.8pt)[
      #text(fill: stroke-color, weight: "bold")[$epsilon arrow.r 0$] (support collapses to $\{a\}$)
    ])
  })
}

#let fundamental-solution-laplace-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let c-n1 = rgb("#2980b9") // Blue for n=1
  let c-n2 = rgb("#27ae60") // Green for n=2
  let c-n3 = rgb("#d35400") // Amber/Rust for n=3

  canvas(length: 0.88cm, {
    import draw: *

    let x0 = -0.5

    // Axes
    line((x0 - 2.5, 0), (x0 + 2.7, 0), stroke: (paint: muted, thickness: 0.65pt), mark: (end: ">"))
    line((x0, -2.2), (x0, 2.2), stroke: (paint: muted, thickness: 0.65pt), mark: (end: ">"))
    content((x0 + 2.85, 0), anchor: "west", text(size: 8.5pt, fill: stroke-color)[$x$])
    content((x0 - 0.22, 2.25), anchor: "east", text(size: 8.5pt, fill: stroke-color)[$Phi_(n)(x)$])
    content((x0, 2.55), anchor: "south", text(weight: "bold", size: 9pt, fill: stroke-color)[Radial Potential Profiles])
    content((x0 - 0.25, 0.22), text(size: 8pt, fill: muted)[$0$])

    // Curve n = 1: Phi_1(x) = |x|/2 (V-shaped)
    let y-n1(x) = 0.68 * calc.abs(x)
    line((x0 - 1.8, y-n1(-1.8)), (x0, 0), (x0 + 1.8, y-n1(1.8)), stroke: (paint: c-n1, thickness: 1.8pt))
    circle((x0, 0), radius: 0.06, fill: c-n1)

    // Curve n = 2: Phi_2(x) = 1/(2pi) ln|x|
    let pts-n2-right = ()
    let pts-n2-left = ()
    for i in range(1, 40) {
      let r = 0.16 + 1.64 * (i / 39)
      let y = 0.72 * calc.log(r / 0.80)
      pts-n2-right.push((x0 + r, y))
      pts-n2-left.push((x0 - r, y))
    }
    let pts-n2-left-rev = ()
    for i in range(0, pts-n2-left.len()) {
      pts-n2-left-rev.push(pts-n2-left.at(pts-n2-left.len() - 1 - i))
    }
    line(..pts-n2-left-rev, stroke: (paint: c-n2, thickness: 1.6pt))
    line(..pts-n2-right, stroke: (paint: c-n2, thickness: 1.6pt))

    // Curve n = 3: Phi_3(x) = -1/(4pi |x|)
    let pts-n3-right = ()
    let pts-n3-left = ()
    for i in range(1, 40) {
      let r = 0.22 + 1.58 * (i / 39)
      let y = -0.38 / r + 0.16
      pts-n3-right.push((x0 + r, y))
      pts-n3-left.push((x0 - r, y))
    }
    let pts-n3-left-rev = ()
    for i in range(0, pts-n3-left.len()) {
      pts-n3-left-rev.push(pts-n3-left.at(pts-n3-left.len() - 1 - i))
    }
    line(..pts-n3-left-rev, stroke: (paint: c-n3, thickness: 1.6pt))
    line(..pts-n3-right, stroke: (paint: c-n3, thickness: 1.6pt))

    // Asymptote indicator for n=2,3 at x=0
    line((x0, -0.15), (x0, -2.0), stroke: (paint: muted, dash: "densely-dotted", thickness: 0.75pt))

    // Curve Labels placed cleanly to the right
    content((x0 + 1.95, 1.25), anchor: "west", text(size: 8pt, fill: c-n1, weight: "bold")[
      $n=1: frac(|x|, 2)$
    ])
    content((x0 + 1.95, 0.52), anchor: "west", text(size: 8pt, fill: c-n2, weight: "bold")[
      $n=2: frac(1, 2 pi) log |x|$
    ])
    content((x0 + 1.95, -0.55), anchor: "west", text(size: 8pt, fill: c-n3, weight: "bold")[
      $n=3: -frac(1, 4 pi |x|)$
    ])

    // Annotations below
    content((x0, -2.35), anchor: "north", text(size: 8.5pt, fill: stroke-color)[$Delta Phi_(n)(x) = 0 quad (x eq.not 0)$])
    content((x0, -2.85), anchor: "north", text(size: 7.5pt, fill: muted)[Harmonic everywhere away from origin])
  })
}

#let laplace-1d-proof-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let c-blue = rgb("#2980b9")
  let c-amber = rgb("#d35400")
  let c-purple = rgb("#8e44ad")

  canvas(length: 0.85cm, {
    import draw: *

    let draw-mini-axes = (x0, y-min, y-max, title-text) => {
      line((x0 - 1.15, 0), (x0 + 1.15, 0), stroke: (paint: muted, thickness: 0.65pt), mark: (end: ">"))
      line((x0, y-min), (x0, y-max), stroke: (paint: muted, thickness: 0.65pt), mark: (end: ">"))
      content((x0 + 1.30, 0), anchor: "west", text(size: 8pt, fill: stroke-color)[$x$])
      content((x0 - 0.16, y-max + 0.05), anchor: "east", text(size: 8pt, fill: stroke-color)[$y$])
      content((x0, y-max + 0.32), anchor: "south", text(weight: "bold", size: 8.5pt, fill: stroke-color)[#title-text])
    }

    // ==========================================
    // Panel 1: Potential Phi_1(x) = |x|/2
    // ==========================================
    let x0 = -4.2
    draw-mini-axes(x0, -0.35, 1.6, [Potential $Phi_(1)(x)$])
    content((x0 - 0.18, -0.22), text(size: 7.2pt, fill: muted)[$0$])

    line((x0 - 1.0, 0.50), (x0, 0), (x0 + 1.0, 0.50), stroke: (paint: c-blue, thickness: 1.8pt))
    circle((x0, 0), radius: 0.055, fill: c-blue)

    content((x0 - 0.50, 0.30), anchor: "south", text(size: 6.8pt, fill: c-blue, weight: "bold")[$-1/2$])
    content((x0 + 0.50, 0.30), anchor: "south", text(size: 6.8pt, fill: c-blue, weight: "bold")[$+1/2$])

    content((x0, -0.55), anchor: "north", text(size: 8pt, fill: stroke-color)[$Phi_(1)(x) = frac(|x|, 2)$])
    content((x0, -0.95), anchor: "north", text(size: 7pt, fill: muted)[Continuous kink (slopes $minus.plus 1/2$)])

    // Transition Arrow 1 -> 2 (elevated to y = 0.85 to avoid curve level)
    line((-2.5, 0.85), (-1.7, 0.85), stroke: (paint: stroke-color, thickness: 1.1pt), mark: (end: ">"))
    content((-2.1, 1.12), anchor: "south", text(size: 8.5pt, weight: "bold", fill: stroke-color)[$partial$])
    content((-2.1, 0.58), anchor: "north", text(size: 6.8pt, fill: muted)[distributional])

    // ==========================================
    // Panel 2: First Derivative Phi'_1(x) = H(x) - 1/2
    // ==========================================
    let x1 = 0.0
    draw-mini-axes(x1, -0.9, 1.5, [First Derivative $Phi'_(1)$])
    content((x1 - 0.18, 0.18), text(size: 7.2pt, fill: muted)[$0$])

    let y-step = 0.42
    line((x1 - 0.06, y-step), (x1 + 0.06, y-step), stroke: (paint: muted, thickness: 0.6pt))
    content((x1 - 0.20, y-step), anchor: "east", text(size: 7pt, fill: muted)[$+1/2$])
    line((x1 - 0.06, -y-step), (x1 + 0.06, -y-step), stroke: (paint: muted, thickness: 0.6pt))
    content((x1 - 0.20, -y-step), anchor: "east", text(size: 7pt, fill: muted)[$-1/2$])

    line((x1 - 1.0, -y-step), (x1, -y-step), stroke: (paint: c-amber, thickness: 1.8pt))
    circle((x1, -y-step), radius: 0.055, fill: white, stroke: (paint: c-amber, thickness: 1.2pt))

    line((x1, -y-step), (x1, y-step), stroke: (paint: c-amber, dash: "dashed", thickness: 0.8pt))
    content((x1 + 0.22, 0.1), anchor: "south-west", text(size: 6pt, fill: c-amber, weight: "bold")[Jump $+1$])

    circle((x1, y-step), radius: 0.055, fill: c-amber, stroke: (paint: c-amber, thickness: 1.2pt))
    line((x1, y-step), (x1 + 1.0, y-step), stroke: (paint: c-amber, thickness: 1.8pt))

    content((x1, -0.55), anchor: "north", text(size: 8pt, fill: stroke-color)[$Phi'_(1) = H - 1/2$])
    content((x1, -0.95), anchor: "north", text(size: 7pt, fill: muted)[Unit jump at $0$])

    // Transition Arrow 2 -> 3 (elevated to y = 0.85 to avoid curve level)
    line((1.7, 0.85), (2.5, 0.85), stroke: (paint: stroke-color, thickness: 1.1pt), mark: (end: ">"))
    content((2.1, 1.12), anchor: "south", text(size: 8.5pt, weight: "bold", fill: stroke-color)[$partial$])
    content((2.1, 0.58), anchor: "north", text(size: 6.8pt, fill: muted)[jump $arrow.r delta_0$])

    // ==========================================
    // Panel 3: Second Derivative Phi''_1 = delta_0
    // ==========================================
    let x2 = 4.2
    draw-mini-axes(x2, -0.35, 1.6, [Second Derivative $Phi''_(1)$])
    content((x2 - 0.18, -0.22), text(size: 7.2pt, fill: muted)[$0$])

    line((x2 - 1.0, 0), (x2 - 0.06, 0), stroke: (paint: c-purple, thickness: 1.8pt))
    line((x2 + 0.06, 0), (x2 + 1.0, 0), stroke: (paint: c-purple, thickness: 1.8pt))

    line((x2, 0), (x2, 1.25), stroke: (paint: c-purple, thickness: 2.3pt), mark: (end: ">", fill: c-purple))
    content((x2 + 0.18, 1.15), anchor: "west", text(size: 7.8pt, fill: c-purple, weight: "bold")[$delta_0 ("mass " 1)$])

    content((x2, -0.55), anchor: "north", text(size: 8pt, fill: stroke-color)[$partial^(2) T_(Phi_(1)) = delta_0$])
    content((x2, -0.95), anchor: "north", text(size: 7pt, fill: c-purple)[Dirac impulse at $0$])
  })
}

#let laplace-annulus-domain-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let is-light = (theme.page == white)
  let bg-ann = if is-light { rgb("#f4f8fb") } else { rgb("#141e2b") }
  let bg-supp = if is-light { rgb("#e8f4f8c0") } else { rgb("#1a3042c0") }
  let bg-ball = if is-light { rgb("#fdedec") } else { rgb("#2a171b") }
  let bg-box = if is-light { rgb("#ffffffea") } else { rgb("#10151fea") }

  let c-blue = rgb("#2980b9")
  let c-red = rgb("#c0392b")
  let c-purple = rgb("#8e44ad")
  let c-green = rgb("#27ae60")

  canvas(length: 0.86cm, {
    import draw: *

    // ==========================================
    // Left Panel: Annular Domain Omega_(eps, R)
    // ==========================================
    let x0 = -3.7
    let r-in = 0.70
    let r-out = 2.20

    // Title
    content((x0, 2.75), anchor: "south", text(weight: "bold", size: 9pt, fill: stroke-color)[
      Annular Domain $Omega_(epsilon, R)$
    ])

    // Annular region fill
    circle((x0, 0), radius: r-out, fill: bg-ann, stroke: (paint: stroke-color, thickness: 1.2pt))
    circle((x0, 0), radius: r-in, fill: bg-ball, stroke: (paint: c-red, thickness: 1.4pt))

    // Support of test function phi: smooth ellipse strictly inside B_R(0)
    group({
      translate((x0, 0))
      rotate(10deg)
      circle((0, 0), radius: (1.50, 1.20), fill: bg-supp, stroke: (paint: c-blue, dash: "densely-dashed", thickness: 1.1pt))
    })

    // Label for supp(phi) centered in upper half of support
    content((x0, 0.72), anchor: "center", text(size: 7.5pt, fill: c-blue, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2.5pt, y: 1.2pt), radius: 2pt)[$op("supp")(phi) subset.neq B_(R)(0)$]
    ])

    // Singularity center point
    circle((x0, 0), radius: 0.07, fill: c-red)
    content((x0 - 0.20, 0.16), anchor: "east", text(size: 7.8pt, fill: c-red, weight: "bold")[$0$])

    // Label for excised ball B_eps(0)
    content((x0 + 0.26, -0.24), text(size: 7pt, fill: c-red)[$B_(epsilon)(0)$])

    // Radii measurement lines
    // eps radius (at 40 deg)
    line((x0, 0), (x0 + r-in * calc.cos(40deg), r-in * calc.sin(40deg)), stroke: (paint: c-red, thickness: 0.65pt))
    content((x0 + 0.45 * r-in * calc.cos(40deg) - 0.06, 0.45 * r-in * calc.sin(40deg) + 0.14), text(size: 6.8pt, fill: c-red)[$epsilon$])

    // R radius (at -35 deg, pointing to lower-right)
    line((x0, 0), (x0 + r-out * calc.cos(-35deg), r-out * calc.sin(-35deg)), stroke: (paint: stroke-color, thickness: 0.65pt))
    content((x0 + 0.52 * r-out * calc.cos(-35deg) + 0.12, 0.52 * r-out * calc.sin(-35deg) + 0.12), text(size: 7.2pt, fill: stroke-color)[$R$])

    // Outer normal vectors on d B_R(0): nu = +partial_r (pointing outward)
    let outer-angs = (50deg, 135deg)
    for ang in outer-angs {
      let cx = calc.cos(ang)
      let cy = calc.sin(ang)
      line(
        (x0 + r-out * cx, r-out * cy),
        (x0 + (r-out + 0.50) * cx, (r-out + 0.50) * cy),
        stroke: (paint: stroke-color, thickness: 1.2pt),
        mark: (end: ">", fill: stroke-color),
      )
    }
    content((x0 + 1.85, 1.65), anchor: "south-west", text(size: 7.2pt, fill: stroke-color, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[$nu = +partial_r$]
    ])

    // Inner normal vectors on d B_eps(0): nu = -partial_r (pointing inward toward 0)
    let inner-angs = (110deg, 250deg)
    for ang in inner-angs {
      let cx = calc.cos(ang)
      let cy = calc.sin(ang)
      line(
        (x0 + r-in * cx, r-in * cy),
        (x0 + 0.30 * r-in * cx, 0.30 * r-in * cy),
        stroke: (paint: c-red, thickness: 1.3pt),
        mark: (end: ">", fill: c-red),
      )
    }
    content((x0 - 0.70, 0.90), anchor: "south-east", text(size: 7.2pt, fill: c-red, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[$nu = -partial_r$]
    ])

    // Boundary labels clearly separated from curves
    content((x0 + 1.60, -1.60), anchor: "north-west", text(size: 8pt, fill: stroke-color, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[$partial B_(R)(0)$]
    ])
    content((x0 - 1.15, -0.75), anchor: "north-east", text(size: 7.2pt, fill: c-red, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[$partial B_(epsilon)(0)$]
    ])

    // Interior harmonic label
    content((x0, -1.05), anchor: "center", text(size: 7.2pt, fill: c-green, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[$Delta Phi_(n) = 0$ in $Omega_(epsilon, R)$]
    ])

    // Subtitles below Left Panel
    content((x0, -2.50), anchor: "north", text(size: 7.6pt, fill: stroke-color)[
      $partial B_(R)(0): quad phi = 0, thin nabla phi = 0 arrow.r integral_(partial B_(R)(0)) = 0$
    ])
    content((x0, -2.90), anchor: "north", text(size: 7pt, fill: muted)[
      Outer boundary vanishes; only inner boundary survives
    ])

    // ==========================================
    // Right Panel: Inner Boundary Flux & Epsilon -> 0 Limit
    // ==========================================
    let x1 = 3.7
    let r-zoom = 1.85

    // Title
    content((x1, 2.75), anchor: "south", text(weight: "bold", size: 9pt, fill: stroke-color)[
      Boundary Flux & Limit $epsilon arrow.r 0$
    ])

    // Background disk
    circle((x1, 0), radius: r-zoom, fill: bg-ball, stroke: (paint: c-red, thickness: 1.4pt))

    // Intermediate shrinking spheres (dashed)
    circle((x1, 0), radius: r-zoom * 0.65, stroke: (paint: c-red, dash: "densely-dotted", thickness: 0.8pt))
    circle((x1, 0), radius: r-zoom * 0.35, stroke: (paint: c-red, dash: "densely-dotted", thickness: 0.8pt))

    // Center point singularity
    circle((x1, 0), radius: 0.08, fill: c-red)
    content((x1, -0.28), anchor: "north", text(size: 7.8pt, fill: c-red, weight: "bold")[$phi(0)$])

    // Inward normal flux vectors (-partial_nu Phi_n = 1/|dB_eps|)
    let flux-angs = (0deg, 60deg, 120deg, 180deg, 240deg, 300deg)
    for ang in flux-angs {
      let cx = calc.cos(ang)
      let cy = calc.sin(ang)
      line(
        (x1 + r-zoom * cx, r-zoom * cy),
        (x1 + (r-zoom - 0.42) * cx, (r-zoom - 0.42) * cy),
        stroke: (paint: c-red, thickness: 1.3pt),
        mark: (end: ">", fill: c-red),
      )
    }

    // Normal derivative label placed outside the circle at top-right
    content((x1 + 1.45, 1.45), anchor: "south-west", text(size: 7.2pt, fill: c-red, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[
        $-partial_(nu) Phi_(n) = frac(1, |partial B_(epsilon)(0)|)$
      ]
    ])

    // Boundary label on lower left of the circle
    content((x1 - 1.40, -1.35), anchor: "north-east", text(size: 7.2pt, fill: c-red, weight: "bold")[
      #box(fill: bg-box, inset: (x: 2pt, y: 1pt), radius: 2pt)[$partial B_(epsilon)(0)$]
    ])

    // Test points x on sphere with values phi(x)
    let pt-ang = 145deg
    let px = x1 + r-zoom * calc.cos(pt-ang)
    let py = r-zoom * calc.sin(pt-ang)
    circle((px, py), radius: 0.05, fill: c-blue)
    content((px - 0.12, py + 0.12), anchor: "south-east", text(size: 7.2pt, fill: c-blue)[$phi(x)$])

    // Shrinking arrows indicating epsilon -> 0
    line((x1 + 1.20, 0.65), (x1 + 0.55, 0.28), stroke: (paint: c-purple, thickness: 1.1pt), mark: (end: ">"))
    content((x1 + 0.85, 0.65), anchor: "south", text(size: 6.8pt, fill: c-purple, weight: "bold")[$epsilon arrow.r 0$])

    // Two boundary terms breakdown below Right Panel
    content((x1, -2.20), anchor: "north", text(size: 7.6pt, fill: c-red, weight: "bold")[
      $- integral_(partial B_(epsilon)(0)) phi partial_(nu) Phi_(n) thin d S = frac(1, |partial B_(epsilon)(0)|) integral_(partial B_(epsilon)(0)) phi(x) thin d S arrow.r phi(0)$
    ])
    content((x1, -2.82), anchor: "north", text(size: 7.2pt, fill: muted)[
      $integral_(partial B_(epsilon)(0)) Phi_(n) partial_(nu) phi thin d S = O(epsilon) arrow.r 0$ #text(fill: stroke-color)[(gradient flux vanishes)]
    ])
    content((x1, -3.20), anchor: "north", text(size: 7.5pt, fill: c-purple, weight: "bold")[
      Total boundary limit $= phi(0) = chevron.l phi, delta_(0) chevron.r$
    ])
  })
}

