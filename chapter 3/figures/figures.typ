#import "../../Styles/styles.typ": theme-from-text-fill
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/cetz-helpers:0.2.0": sample-function
#import "@local/fletcher-helpers:0.1.0": themed-diagram

#let wave-kernel-descent-diagram() = context {
  let theme = theme-from-text-fill()
  let accent = theme.callouts.proposition.border
  let ellipse-points = (cx, cy, rx, ry) => range(0, 65).map(j => {
    let angle = j * 360deg / 64
    (cx + rx * calc.cos(angle), cy + ry * calc.sin(angle))
  })
  canvas(length: 0.8cm, {
    import draw: *
    circle((-2, 1.4), radius: 1.35, stroke: 1pt + accent)
    line(..ellipse-points(-2, 1.4, 1.35, 0.3), stroke: (paint: theme.muted-text, dash: "dashed"))
    content((-2, 3.05), text(size: 10pt)[Sphere in $bb(R)^(3)$])
    line(..ellipse-points(-2, -1.1, 1.35, 0.4), close: true,
      fill: theme.callouts.proposition.bg, stroke: 1pt + accent)
    // Two sphere points above the same planar point x.
    line((-1.4, 2.61), (-1.4, -1.1),
      stroke: (paint: accent, dash: "dashed"), mark: (end: ">"))
    for yy in (2.61, 0.19, -1.1) {
      circle((-1.4, yy), radius: 0.055, fill: accent, stroke: none)
    }
    content((-1.15, 2.6), anchor: "west", text(size: 9pt)[$(x,z_(+))$])
    content((-1.15, 0.15), anchor: "west", text(size: 9pt)[$(x,z_(-))$])
    content((-1.15, -1.1), anchor: "west", text(size: 9pt)[$x$])
    content((-2, -1.85), text(size: 10pt)[Disk in $bb(R)^(2)$])
    content((1.1, 2.1), anchor: "west", text(size: 10pt)[$z_(plus.minus)=plus.minus sqrt(t^(2)-|x|^(2))$])
    content((1.1, 1.05), anchor: "west", text(size: 10pt)[Two sheets contribute])
    content((1.1, 0.15), anchor: "west", text(size: 10pt)[$d S=frac(t,sqrt(t^(2)-|x|^(2))) thin d x$])
    content((1.1, -1.0), anchor: "west", text(size: 10pt)[Equal projected widths; steeper surface])
    // Equal radial widths in the central section lift to unequal arc lengths.
    // These are section segments, not literal two-dimensional area patches.
    for (lo, hi, shade) in ((-0.12, 0.12, theme.callouts.tip.border), (0.99, 1.23, theme.callouts.important.border)) {
      let arc-points = range(0, 21).map(j => {
        let q = lo + (hi - lo)*j/20
        (-2 + q, 1.4 + calc.sqrt(1.35*1.35-q*q))
      })
      line(..arc-points, stroke: 2.5pt + shade)
      line((-2+lo, -1.1), (-2+hi, -1.1), stroke: 2.5pt + shade)
      let mid = (lo+hi)/2
      line((-2+mid, 1.4+calc.sqrt(1.35*1.35-mid*mid)), (-2+mid, -1.1),
        stroke: (paint: shade, thickness: 0.5pt, dash: "dotted"))
    }
  })
}

#let development-chain-diagram() = context {
  let theme = theme-from-text-fill()

  themed-diagram(
    spacing: (5mm, 4mm),
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

  themed-diagram(
    spacing: (12mm, 9mm),
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

#let wave-source-observer-diagram() = context {
  let theme = theme-from-text-fill()
  let front = theme.callouts.important.border
  let source = theme.callouts.proposition.border
  let observer = theme.callouts.tip.border
  let muted = theme.muted-text
  canvas(length: 0.9cm, {
    import draw: *
    content((0, 3.0), text(size: 10pt, weight: "bold")[A spherical wave expands from a fixed source])
    content((0, 2.55), text(size: 9pt)[$bb(R)^(3)$, wave speed $1$: circles are sections of spheres])
    for (center, radius, title, status) in (
      (-4, 0.65, [$t<r$], [not yet reached]),
      (0, 1.15, [$t=r$], [front reaches $x$]),
      (4, 1.7, [$t>r$], [front has passed]),
    ) {
      content((center, 2.0), text(size: 10pt, weight: "bold", title))
      circle((center, 0), radius: radius, stroke: 1.5pt + front)
      // A radial arrow indicates front expansion, not a particle trajectory.
      let a = 135deg
      line((center + 0.3 * calc.cos(a), 0.3 * calc.sin(a)),
        (center + radius * calc.cos(a), radius * calc.sin(a)),
        stroke: 0.9pt + front, mark: (end: ">"))
      line((center, 0), (center + 1.15, 0),
        stroke: (paint: muted, dash: "dashed", thickness: 0.7pt))
      circle((center, 0), radius: 0.075, fill: source, stroke: none)
      content((center - 0.16, -0.26), text(size: 10pt, fill: source)[$z$])
      circle((center + 1.15, 0), radius: 0.085, fill: observer, stroke: 0.6pt + theme.page)
      content((center + 1.36, -0.27), text(size: 10pt, fill: observer)[$x$])
      content((center, -2.08), text(size: 9pt, status))
    }
    content((-3.6, -2.7), text(size: 9pt, fill: source)[$z$: initial unit kick])
    content((0, -2.7), text(size: 9pt, fill: observer)[$x$: fixed observer])
    content((3.7, -2.7), text(size: 9pt)[$r=|x-z|$])

    line((-5.6, -3.15), (5.6, -3.15), stroke: 0.5pt + theme.rule)
    content((0, -3.6), text(size: 10pt, weight: "bold")[Fix $z$ and $x$: what does the observer receive?])
    line((-4.7, -5.35), (4.7, -5.35), stroke: 0.8pt + muted, mark: (end: ">"))
    content((4.9, -5.35), anchor: "west", text(size: 9pt)[$t$])
    content((-4.7, -5.65), text(size: 9pt)[$0$])
    line((0, -5.35), (0, -4.4), stroke: 1.5pt + front, mark: (end: ">"))
    content((0, -5.72), text(size: 9pt)[$t=r$])
    content((-2.7, -4.9), text(size: 9pt)[zero before arrival])
    content((2.65, -4.9), text(size: 9pt)[zero after passage])
    content((0, -4.1), text(size: 9pt, fill: front)[ideal impulse; weight $1/(4 pi r)$])
    content((0, -6.35), text(size: 10pt)[$R_(t)^(3)(x-z)=delta(t-r)/(4 pi r), quad r>0, thin t>0$])
    content((0, -6.95), text(size: 9pt)[The kernel gives the response, including its arrival time and weight.])
  })
}

#let heat-source-evolution-diagram() = context {
  let theme = theme-from-text-fill()
  let source = theme.callouts.proposition.border
  let response = theme.callouts.important.border
  let muted = theme.muted-text
  let z = -1.4
  let x = 1.5
  let profile = q => 2.5 + 1.3 * calc.exp(-calc.pow(q - z, 2) / 4)

  canvas(length: 0.9cm, {
    import draw: *
    // The two horizontal slices represent space at different times.
    line((-4.7, -0.1), (-4.7, 4.15), stroke: 0.8pt + muted, mark: (end: ">"))
    content((-4.7, 4.4), text(size: 9pt)[time])
    content((-4.95, 0), anchor: "east", text(size: 9pt)[$0$])
    content((-4.95, 2.5), anchor: "east", text(size: 9pt)[$t>0$])
    for height in (0, 2.5) {
      line((-4.2, height), (4.2, height), stroke: 0.7pt + muted, mark: (end: ">"))
    }
    content((0, 4.4), text(size: 10pt, weight: "bold")[One initial point source evolves into a profile])

    // This arrow symbolizes a Dirac mass; its height is not a function value.
    line((z, 0), (z, 1.0), stroke: 1.6pt + source, mark: (end: ">"))
    circle((z, 0), radius: 0.065, fill: source, stroke: none)
    content((z, -0.3), text(size: 9pt, fill: source)[source at $z$])
    content((z - 0.25, 0.75), anchor: "east", text(size: 9pt, fill: source)[$delta_(z)$: unit mass])
    content((2.2, 0.6), text(size: 9pt)[initial time])

    let points = range(0, 81).map(i => {
      let q = -4.1 + i * 8.2 / 80
      (q, profile(q))
    })
    line((-4.1, 2.5), ..points, (4.1, 2.5), close: true,
      fill: theme.callouts.important.bg, stroke: none)
    line(..points, stroke: 1.3pt + response)
    content((z, 3.98), text(size: 9pt, fill: response)[$K_(t)(dot,z)=T_(t)delta_(z)$])
    line((x, 2.5), (x, profile(x)), stroke: (paint: response, dash: "dashed"))
    circle((x, profile(x)), radius: 0.075, fill: response, stroke: none)
    content((x + 0.2, profile(x) + 0.2), anchor: "west",
      text(size: 9pt, fill: response)[$K_(t)(x,z)$])
    content((x + 0.35, 2.16), anchor: "west", text(size: 9pt)[observe at $x$])
    line((z, 1.2), (x - 0.12, 2.38), stroke: 1pt + source, mark: (end: ">"))
    content((-2.4, 1.65), text(size: 9pt, fill: source)[from $z$ to $x$])

    content((0, -1.0), text(size: 9pt)[For general initial data, add all source contributions:])
    content((0, -1.6), text(size: 10pt)[$u(t,x)=(T_(t)f)(x)=integral_(bb(R)^(n)) K_(t)(x,z)f(z) thin d z$])
  })
}

#let integral-kernel-influence-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let c-source = rgb("#2980b9")
  let c-target = rgb("#27ae60")
  let c-kernel = rgb("#8e44ad")
  let c-accent = rgb("#d35400")

  let fill-source = theme.callouts.proposition.bg
  let fill-kernel = theme.callouts.important.bg

  let z0 = -1.8
  let x0 = 1.4

  // Top Layer: Response profile K(., z0) = T delta_z0
  let y_axis_top = 1.8
  let H_resp = 1.8
  let sig_resp = 2.1
  let resp_val = x => y_axis_top + H_resp * calc.exp(-calc.pow(x - z0, 2) / (2 * calc.pow(sig_resp, 2)))

  // Bottom Layer: Input data curve f(z) on Z
  let y_axis_bot = -1.8
  let f_val = z => y_axis_bot + 1.2 * calc.exp(-calc.pow(z + 1.2, 2) / 2.8)

  canvas(length: 0.82cm, {
    import draw: *

    // Top Layer: Observation space X
    line((-4.5, y_axis_top), (4.5, y_axis_top), stroke: (paint: muted, thickness: 0.75pt), mark: (end: ">"))
    content((4.65, y_axis_top), anchor: "west", text(size: 8.5pt, weight: "bold")[$X$ #text(weight: "regular", size: 7.2pt)[(observation space)]])

    let n_pts = 60
    let x_min = -4.3
    let x_max = 4.0
    let resp_pts = sample-function(resp_val, x_min, x_max, segments: n_pts)

    line((x_min, y_axis_top), ..resp_pts, (x_max, y_axis_top), close: true, fill: fill-kernel, stroke: none)
    line(..resp_pts, stroke: (paint: c-kernel, thickness: 1.4pt))

    content((z0, resp_val(z0) + 0.28), anchor: "south", text(size: 8.5pt, fill: c-kernel, weight: "bold")[
      $K(dot, z) = T delta_(z)$ #text(weight: "regular", size: 7.2pt)[(impulse response profile on $X$)]
    ])

    let y_resp_at_x0 = resp_val(x0)
    line((x0, y_axis_top), (x0, y_resp_at_x0), stroke: (paint: c-accent, dash: "dashed", thickness: 1.0pt))
    circle((x0, y_axis_top), radius: 0.065, fill: stroke-color)
    content((x0, y_axis_top - 0.22), anchor: "north", text(size: 8.5pt, weight: "bold")[$x$])

    circle((x0, y_resp_at_x0), radius: 0.075, fill: c-accent, stroke: 1pt + theme.page)
    content((x0 + 0.1, y_resp_at_x0 + 0.18), anchor: "south-west", box(
      fill: theme.page,
      inset: (x: 2pt, y: 1pt),
      radius: 2pt,
      text(size: 8.5pt, fill: c-accent, weight: "bold")[$K(x, z)$]
    ))

    // Bottom Layer: Source space Z
    line((-4.5, y_axis_bot), (4.5, y_axis_bot), stroke: (paint: muted, thickness: 0.75pt), mark: (end: ">"))
    content((4.65, y_axis_bot), anchor: "west", text(size: 8.5pt, weight: "bold")[$Z$ #text(weight: "regular", size: 7.2pt)[(source space)]])

    let f_pts = sample-function(f_val, x_min, x_max, segments: n_pts)
    line((x_min, y_axis_bot), ..f_pts, (x_max, y_axis_bot), close: true, fill: fill-source, stroke: none)
    line(..f_pts, stroke: (paint: c-source, thickness: 1.3pt))

    content((0.7, -1.25), anchor: "west", text(size: 8.5pt, fill: c-source, weight: "bold")[
      $f(z)$ #text(weight: "regular", size: 7.2pt)[(input data on $Z$)]
    ])

    let y_f_at_z0 = f_val(z0)
    line((z0, y_axis_bot), (z0, y_f_at_z0), stroke: (paint: c-source, thickness: 2.3pt))
    circle((z0, y_axis_bot), radius: 0.065, fill: stroke-color)
    content((z0, y_axis_bot - 0.22), anchor: "north", text(size: 8.5pt, weight: "bold")[$z$])
    content((z0 - 0.16, y_axis_bot + (y_f_at_z0 - y_axis_bot) * 0.5), anchor: "east", box(
      fill: theme.page,
      inset: (x: 2pt, y: 1pt),
      radius: 2pt,
      text(size: 7.5pt, fill: c-source, weight: "bold")[$f(z) thin d nu(z)$]
    ))

    // Middle Layer: Transmission arrow
    bezier-through(
      (z0, y_f_at_z0 + 0.08),
      (-0.2, 0.95),
      (x0 - 0.06, y_resp_at_x0 - 0.06),
      stroke: (paint: c-accent, thickness: 1.4pt),
      mark: (end: ">", fill: c-accent),
    )

    // Callout box: Local influence (shifted left to clear transmission path)
    content((-2.8, 0.75), anchor: "center", box(
      fill: theme.callouts.definition.bg,
      stroke: 0.75pt + theme.callouts.definition.border,
      inset: (x: 5pt, y: 3.5pt),
      radius: 3pt,
      align(center)[
        #text(size: 7.2pt, weight: "bold", fill: stroke-color)[Local influence from $z$ to $x$:]\
        #text(size: 7.8pt, fill: c-accent, weight: "bold")[$d(T f)(x) = K(x, z) f(z) thin d nu(z)$]
      ]
    ))

    // Callout box: Total superposition (lower-right of transmission path)
    content((1.9, -0.45), anchor: "center", box(
      fill: theme.callouts.tip.bg,
      stroke: 0.75pt + theme.callouts.tip.border,
      inset: (x: 6pt, y: 4pt),
      radius: 3pt,
      align(center)[
        #text(size: 7.2pt, weight: "bold", fill: stroke-color)[Superposition over all $z in Z$:]\
        #text(size: 8.2pt, weight: "bold", fill: c-target)[
          $(T f)(x) = integral_(Z) K(x, z) f(z) thin d nu(z)$
        ]
      ]
    ))

    // Connecting dotted indicator from superposition box to observation point x
    line((1.9, -0.05), (x0 + 0.35, y_axis_top - 0.1), stroke: (paint: c-target, dash: "dotted", thickness: 0.85pt), mark: (end: ">", fill: c-target))
  })
}

// A planar schematic of three-dimensional source volumes, not force vectors.
#let source-mass-superposition-diagram() = context {
  let theme = theme-from-text-fill()
  let source = theme.callouts.proposition.border
  let observer = theme.callouts.tip.border
  let accent = theme.callouts.important.border
  let muted = theme.muted-text
  let masses = ((-1.6, 0.55, 0.10), (-0.7, 1.05, 0.14),
    (-1.25, -0.35, 0.17), (-0.15, 0.15, 0.11), (-0.45, -0.8, 0.13))

  canvas(length: 0.9cm, {
    import draw: *
    for (cx, discrete, title) in (
      (-3.5, true, [Point masses]),
      (3.5, false, [Volume elements]),
    ) {
      content((cx, 2.0), text(size: 10pt, weight: "bold", title))
      let target = (cx + 2.0, 0.35)
      // The same outline and observation point identify the same geometry.
      circle((cx - 0.85, 0.05), radius: (1.55, 1.35),
        fill: theme.callouts.proposition.bg,
        stroke: (paint: muted, thickness: 0.65pt, dash: "dashed"))
      if discrete {
        for (zx, zy, radius) in masses {
          line((cx + zx, zy), target,
            stroke: (paint: muted, thickness: 0.55pt, dash: "dotted"))
        }
        for (zx, zy, radius) in masses {
          circle((cx + zx, zy), radius: radius, fill: source, stroke: none)
        }
        content((cx - 1.25, -0.73), text(size: 9pt, fill: source)[$m_(j)$])
      } else {
        // Cells denote small volumes; this drawing shows a section only.
        for row in range(0, 5) {
          for col in range(0, 5) {
            let px = -1.95 + col * 0.48
            let py = -1.08 + row * 0.48
            if (calc.pow((px + 0.24 + 0.85) / 1.42, 2)
                + calc.pow((py + 0.24 - 0.05) / 1.22, 2) < 1) {
              let shade = 0.15 + 0.6 * calc.exp(
                -calc.pow(px + 0.9, 2) - calc.pow(py - 0.2, 2))
              rect((cx + px, py), (cx + px + 0.43, py + 0.43),
                fill: color.mix((theme.page, (1 - shade) * 100%), (source, shade * 100%)),
                stroke: none)
            }
          }
        }
        let cell = (cx - 0.78, 0.15)
        line(cell, target, stroke: (paint: accent, thickness: 1pt, dash: "dashed"))
        rect((cx - 0.99, -0.06), (cx - 0.56, 0.37),
          fill: theme.callouts.important.bg, stroke: 1.3pt + accent)
        circle(cell, radius: 0.045, fill: accent, stroke: none)
        content((cx - 0.78, -0.32), text(size: 9pt, fill: accent)[$z$])
        content((cx + 1.25, 1.05), text(size: 9pt, fill: accent)[$K_("grav")(x,z)$])
      }
      circle(target, radius: 0.10, fill: observer, stroke: 0.6pt + theme.page)
      content((cx + 2.0, -0.02), text(size: 10pt, fill: observer)[$x$])
      content((cx, -1.8), text(size: 10pt,
        if discrete { $u(x)=sum_(j)K_("grav")(x,z_(j))m_(j)$ }
        else { $u(x)=integral K_("grav")(x,z)rho(z) thin d z$ }))
      content((cx, -2.4), text(size: 9pt, fill: muted,
        if discrete { [Each mass contributes to the same observer.] }
        else { [Each cell carries mass $d m=rho(z) thin d z$.] }))
    }
    line((0, -1.25), (0, 1.55), stroke: 0.5pt + theme.rule)
  })
}

// Simultaneous multi-observer gravitational coupling mapped directly to the matrix equation.
#let gravity-matrix-coupling-diagram() = context {
  let theme = theme-from-text-fill()
  let source = theme.callouts.proposition.border
  let observer = theme.callouts.tip.border
  let accent = theme.callouts.important.border
  let muted = theme.muted-text

  canvas(length: 0.90cm, {
    import draw: *

    // --- Left Panel: Physical Configuration ---
    content((-3.8, 2.45), text(size: 10pt, weight: "bold")[Physical Configuration])
    content((-3.8, 1.95), text(size: 8.5pt, fill: muted)[Point sources $z_(j)$ and observers $x_(i)$ in $bb(R)^(3)$])

    // Observers
    circle((-5.6, 0.75), radius: 0.18, fill: theme.page, stroke: 1.6pt + observer)
    circle((-5.6, 0.75), radius: 0.07, fill: observer, stroke: none)
    content((-6.15, 0.75), text(size: 9.5pt, fill: observer, weight: "bold")[$x_(1)$])

    circle((-5.6, -0.75), radius: 0.18, fill: theme.page, stroke: 1.3pt + muted)
    circle((-5.6, -0.75), radius: 0.06, fill: muted, stroke: none)
    content((-6.15, -0.75), text(size: 9.5pt, fill: muted)[$x_(2)$])

    // Sources
    circle((-2.0, 1.25), radius: 0.14, fill: source, stroke: none)
    content((-1.25, 1.25), text(size: 9pt, fill: muted)[$z_(1) (m_(1))$])

    circle((-1.8, 0.0), radius: 0.19, fill: source, stroke: 1.6pt + source)
    content((-1.05, 0.0), text(size: 9pt, fill: source, weight: "bold")[$z_(2) (m_(2))$])

    circle((-2.1, -1.25), radius: 0.14, fill: source, stroke: none)
    content((-1.35, -1.25), text(size: 9pt, fill: muted)[$z_(3) (m_(3))$])

    // Inactive rays (dotted)
    line((-2.0, 1.25), (-5.42, -0.75), stroke: (paint: muted, thickness: 0.5pt, dash: "dotted"))
    line((-2.1, -1.25), (-5.42, -0.75), stroke: (paint: muted, thickness: 0.5pt, dash: "dotted"))

    // Row 1 rays (gathering into x_1: dashed green)
    line((-2.0, 1.25), (-5.42, 0.75), stroke: (paint: observer, thickness: 1.2pt, dash: "dashed"), mark: (end: ">", fill: observer, size: 0.15))
    line((-2.1, -1.25), (-5.42, 0.75), stroke: (paint: observer, thickness: 1.2pt, dash: "dashed"), mark: (end: ">", fill: observer, size: 0.15))

    // Column 2 radiating ray to x_2 (solid blue)
    line((-1.8, 0.0), (-5.42, -0.75), stroke: (paint: source, thickness: 1.3pt), mark: (end: ">", fill: source, size: 0.15))

    // Intersection ray: from z_2 to x_1 (belongs to Row 1 AND Column 2)
    line((-1.8, 0.0), (-5.42, 0.75), stroke: (paint: accent, thickness: 2.1pt), mark: (end: ">", fill: accent, size: 0.18))
    content((-2.8, 0.55), text(size: 8.5pt, fill: accent, weight: "bold")[$K(x_(1), z_(2))$])

    // Left panel annotations
    content((-3.6, -2.15), text(size: 8.5pt)[#text(fill: observer, weight: "bold")[Row 1 (Green):] Gather sources at $x_(1)$])
    content((-3.6, -2.70), text(size: 8.5pt)[#text(fill: source, weight: "bold")[Column 2 (Blue):] Source $z_(2)$ radiates to all $x$])

    // --- Divider ---
    line((0.0, -2.9), (0.0, 2.65), stroke: 0.5pt + theme.rule)
    content((0.0, 0.0), text(size: 10pt, fill: muted)[$arrow.l.r$])

    // --- Right Panel: Matrix Formulation ---
    content((3.8, 2.45), text(size: 10pt, weight: "bold")[Coupling Matrix Equation])
    content((3.8, 1.95), text(size: 8.5pt, fill: muted)[$u_(i) = sum_(j) B_(i j) m_(j) quad lr((B_(i j) = K(x_(i), z_(j))))$])

    // Headers for B
    content((1.3, 1.45), text(size: 8.5pt, fill: muted)[$z_(1)$])
    content((2.3, 1.45), text(size: 9pt, fill: source, weight: "bold")[$z_(2)$])
    content((3.3, 1.45), text(size: 8.5pt, fill: muted)[$z_(3)$])
    content((0.52, 0.80), text(size: 9pt, fill: observer, weight: "bold")[$x_(1)$])
    content((0.52, 0.10), text(size: 8.5pt, fill: muted)[$x_(2)$])

    // Cells of B (2x3)
    rect((0.8, -0.25), (1.8, 0.45), fill: none, stroke: 0.4pt + theme.rule)
    rect((2.8, -0.25), (3.8, 0.45), fill: none, stroke: 0.4pt + theme.rule)

    // Row 1 highlight (Green)
    rect((0.8, 0.45), (3.8, 1.15), fill: color.mix((theme.page, 85%), (observer, 15%)), stroke: 1.5pt + observer)

    // Column 2 highlight (Blue)
    rect((1.8, -0.25), (2.8, 1.15), fill: color.mix((theme.page, 85%), (source, 15%)), stroke: 1.5pt + source)

    // Intersection cell (1, 2)
    rect((1.8, 0.45), (2.8, 1.15), fill: color.mix((theme.page, 68%), (accent, 32%)), stroke: 2pt + accent)

    // Matrix labels
    content((1.3, 0.80), text(size: 8pt)[$K_(1 1)$])
    content((2.3, 0.80), text(size: 8.5pt, weight: "bold", fill: accent)[$K_(1 2)$])
    content((3.3, 0.80), text(size: 8pt)[$K_(1 3)$])
    content((1.3, 0.10), text(size: 7.5pt, fill: muted)[$K_(2 1)$])
    content((2.3, 0.10), text(size: 8pt, fill: source)[$K_(2 2)$])
    content((3.3, 0.10), text(size: 7.5pt, fill: muted)[$K_(2 3)$])

    // Operator times
    content((4.05, 0.45), text(size: 11pt)[$times$])

    // Vector m (3x1)
    rect((4.35, 0.45), (5.15, 1.15), fill: none, stroke: 0.4pt + theme.rule)
    rect((4.35, -0.25), (5.15, 0.45), fill: color.mix((theme.page, 85%), (source, 15%)), stroke: 1.5pt + source)
    rect((4.35, -0.95), (5.15, -0.25), fill: none, stroke: 0.4pt + theme.rule)
    content((4.75, 0.80), text(size: 8pt, fill: muted)[$m_(1)$])
    content((4.75, 0.10), text(size: 8.5pt, weight: "bold", fill: source)[$m_(2)$])
    content((4.75, -0.60), text(size: 8pt, fill: muted)[$m_(3)$])

    // Operator equals
    content((5.45, 0.45), text(size: 11pt)[$=$])

    // Vector u (2x1)
    rect((5.75, 0.45), (6.55, 1.15), fill: color.mix((theme.page, 85%), (observer, 15%)), stroke: 1.5pt + observer)
    rect((5.75, -0.25), (6.55, 0.45), fill: none, stroke: 0.4pt + theme.rule)
    content((6.15, 0.80), text(size: 8.5pt, weight: "bold", fill: observer)[$u(x_(1))$])
    content((6.15, 0.10), text(size: 7.5pt, fill: muted)[$u(x_(2))$])

    // Right panel annotations
    content((3.8, -2.15), text(size: 8.5pt)[$u(x_(1)) = sum_(j=1)^(3) K(x_(1), z_(j)) m_(j)$ #h(0.3em) #text(size: 7.5pt, fill: observer)[(Row)]])
    content((3.8, -2.70), text(size: 8.5pt)[$B bold(e)_(2) = (K_(1 2), K_(2 2))^(T)$ #h(0.3em) #text(size: 7.5pt, fill: source)[(Column)]])
  })
}

// A sampled kernel with both its column and row interpretations visible.
#let kernel-row-column-diagram() = context {
  let theme = theme-from-text-fill()
  let source = theme.callouts.proposition.border
  let observer = theme.callouts.tip.border
  let kernel = theme.callouts.important.border
  let muted = theme.muted-text
  let n = 7
  let step = 0.52
  let left = -3.7
  let top = 1.65
  let selected-j = 2
  let selected-i = 4
  let weights = (0.15, 0.5, 1.0, 0.7, 0.3, 0.1, 0.0)
  let entry = (i, j) => calc.exp(-calc.pow(i - j, 2) / 3)
  let outputs = range(n).map(i => range(n).map(j =>
    entry(i, j) * weights.at(j)).sum())
  let maximum = calc.max(..outputs)
  let shade = (paint, amount) => color.mix(
    (theme.page, (1 - amount) * 100%), (paint, amount * 100%))

  canvas(length: 0.95cm, {
    import draw: *
    content((-1.85, 2.85), text(size: 10pt, weight: "bold")[Kernel samples])
    content((1.3, 2.85), text(size: 10pt, weight: "bold")[Input weights])
    content((3.6, 2.85), text(size: 10pt, weight: "bold")[Output])
    content((-1.85, 2.3), text(size: 9pt)[$K(x_(i),z_(j))$])
    content((1.3, 2.3), text(size: 9pt)[$w_(j)=f(z_(j))Delta z$])
    content((3.6, 2.3), text(size: 9pt)[$u(x_(i))$])
    for j in range(n) {
      content((left + (j + 0.5) * step, top + 0.27),
        text(size: 8pt, fill: if j == selected-j { source } else { muted })[$#(j + 1)$])
    }
    content((left + n * step + 0.15, top + 0.27),
      anchor: "west", text(size: 9pt, fill: source)[$z_(j)$])
    for i in range(n) {
      let yy = top - (i + 1) * step
      content((left - 0.24, yy + step / 2),
        text(size: 8pt, fill: if i == selected-i { observer } else { muted })[$#(i + 1)$])
      for j in range(n) {
        let xx = left + j * step
        rect((xx, yy), (xx + step, yy + step),
          fill: shade(kernel, 0.08 + 0.62 * entry(i, j)),
          stroke: 0.35pt + theme.page)
      }
      rect((1.04, yy), (1.56, yy + step),
        fill: shade(source, 0.08 + 0.65 * weights.at(i)), stroke: 0.4pt + theme.page)
      rect((3.34, yy), (3.86, yy + step),
        fill: shade(observer, 0.08 + 0.65 * outputs.at(i) / maximum),
        stroke: 0.4pt + theme.page)
    }
    content((left - 0.6, top + 0.27), text(size: 9pt, fill: observer)[$x_(i)$])
    // Outlines distinguish the two ways of reading one kernel.
    rect((left + selected-j * step, top - n * step),
      (left + (selected-j + 1) * step, top), fill: none, stroke: 1.6pt + source)
    rect((left, top - (selected-i + 1) * step),
      (left + n * step, top - selected-i * step), fill: none, stroke: 1.6pt + observer)
    circle((left + (selected-j + 0.5) * step, top - (selected-i + 0.5) * step),
      radius: 0.095, fill: theme.text, stroke: 0.7pt + theme.page)
    rect((1.04, top - (selected-j + 1) * step), (1.56, top - selected-j * step),
      fill: none, stroke: 1.6pt + source)
    rect((3.34, top - (selected-i + 1) * step), (3.86, top - selected-i * step),
      fill: none, stroke: 1.6pt + observer)
    content((0.42, -0.15), text(size: 15pt)[$times$])
    content((2.45, -0.15), text(size: 15pt)[$=$])
    content((0, -2.5), text(size: 10pt)[$u(x_(i)) approx sum_(j)K(x_(i),z_(j))w_(j)$])
    line((-4.4, -2.95), (4.4, -2.95), stroke: 0.5pt + theme.rule)
    content((-2.2, -3.42), text(size: 9.5pt, fill: source)[Column: fix source $z_(3)$])
    content((-2.2, -3.95), text(size: 9pt)[$K(dot,z_(3))$: response over all $x$])
    content((2.2, -3.42), text(size: 9.5pt, fill: observer)[Row: fix observer $x_(5)$])
    content((2.2, -3.95), text(size: 9pt)[Weight every source, then add.])
  })
}

// Cross-sections of R^3_+: identical direct separation, different image distance.
#let boundary-image-kernel-diagram() = context {
  let theme = theme-from-text-fill()
  let source = theme.callouts.proposition.border
  let observer = theme.callouts.tip.border
  let image-color = theme.callouts.important.border
  let muted = theme.muted-text
  let r = 2.0

  canvas(length: 0.9cm, {
    import draw: *
    content((0, 3.05), text(size: 10pt, weight: "bold")[Same separation; different distance from the boundary])
    for (cx, height, title) in (
      (-3.1, 0.85, [Near the boundary]),
      (3.1, 1.75, [Translated upward]),
    ) {
      content((cx, 2.55), text(size: 9.5pt, weight: "bold", title))
      rect((cx - 2.35, -2.1), (cx + 2.35, 0),
        fill: theme.callouts.note.bg, stroke: none)
      // Short hatches mark the exterior; the image is outside the domain.
      for j in range(10) {
        let xx = cx - 2.3 + j * 0.47
        line((xx, 0), (xx + 0.16, -0.2), stroke: 0.45pt + theme.rule)
      }
      line((cx - 2.35, 0), (cx + 2.35, 0), stroke: 1pt + muted)
      content((cx + 1.95, -0.35), text(size: 9pt, fill: muted)[$x_(3)=0$])
      content((cx - 2.05, 1.8), text(size: 10pt, fill: muted)[$Omega$])
      let z = (cx - r / 2, height)
      let x = (cx + r / 2, height)
      let reflected = (cx - r / 2, -height)
      line(z, reflected, stroke: (paint: muted, thickness: 0.6pt, dash: "dotted"))
      line(z, x, stroke: 1.3pt + source)
      line(reflected, x, stroke: (paint: image-color, thickness: 1.1pt, dash: "dashed"))
      content((cx, height + 0.24), text(size: 9pt, fill: source)[$r$])
      content((cx + 0.37, -0.32), text(size: 9pt, fill: image-color)[$r^("*")$])
      circle(z, radius: 0.09, fill: source, stroke: 0.5pt + theme.page)
      circle(x, radius: 0.09, fill: observer, stroke: 0.5pt + theme.page)
      circle(reflected, radius: 0.095, fill: theme.page, stroke: 1.2pt + image-color)
      content((cx - r / 2 - 0.23, height + 0.1), anchor: "east",
        text(size: 10pt, fill: source)[$z$])
      content((cx + r / 2 + 0.2, height + 0.1), anchor: "west",
        text(size: 10pt, fill: observer)[$x$])
      content((cx - r / 2 - 0.23, -height), anchor: "east",
        text(size: 9pt, fill: image-color)[$z^("*")$])
      content((cx, -2.48), text(size: 9pt,
        if height < 1 { [Smaller $r^("*")$: stronger cancellation.] }
        else { [Larger $r^("*")$: weaker cancellation.] }))
    }
    content((0, -3.2), text(size: 10pt)[$K_(Omega)(x,z)=frac(1,4pi)lr((frac(1,r^("*"))-frac(1,r))), quad r=|x-z|, quad r^("*")=|x-z^("*")|$])
    content((0, -3.85), text(size: 9pt, fill: muted)[On the boundary, $r=r^("*")$ and the two contributions cancel.])
  })
}

#let kernel-duality-fletcher-diagram() = context {
  let theme = theme-from-text-fill()
  let source = rgb("#1f77b4")
  let observer = rgb("#27ae60")
  let kernel-color = rgb("#8e44ad")

  themed-diagram(
    spacing: (48mm, 26mm),
    node-inset: 7pt,
    // Nodes
    node((0, 0), [$(f, phi) in cal(D)(Z) times cal(D)(X)$], name: <input>),
    node((1, 0), [$phi ⊗ f in cal(D)(X times Z)$], name: <tensor>, fill: theme.callouts.proposition.bg),
    node((0, 1), [$(T f, phi) in cal(D)^(*)(X) times cal(D)(X)$], name: <operator>, fill: theme.callouts.tip.bg),
    node((1, 1), [$chevron.l T f, phi chevron.r = chevron.l K, phi ⊗ f chevron.r in bb(C)$], name: <pairing>, fill: theme.callouts.important.bg),

    // Edges
    edge(<input>, <tensor>, "->", [Tensor product $phi ⊗ f$], label-pos: 0.5, label-side: left, label-sep: 6pt),
    edge(<input>, <operator>, "->", [$T times op("id")$], label-pos: 0.5, label-side: right, label-sep: 6pt),
    edge(<tensor>, <pairing>, "->", [Bivariate pairing $chevron.l K, dot chevron.r$], label-pos: 0.5, label-side: left, label-sep: 6pt),
    edge(<operator>, <pairing>, "->", [Evaluation on $X$], label-pos: 0.5, label-side: right, label-sep: 8pt),
  )
}

#let diagonal-kernel-support-diagram() = context {
  let theme = theme-from-text-fill()
  let diagonal = theme.callouts.important.border
  let source = theme.callouts.proposition.border
  let observer = theme.callouts.definition.border
  let selected = theme.callouts.warning.border
  let muted = theme.muted-text

  canvas(length: 0.85cm, {
    import draw: *
    content((5.5, 6.5), text(size: 10pt, fill: diagonal)[Identity kernel $K_(I)=delta(x-z)$: reads only matching positions $x=z$])
    content((5.5, 5.9), text(size: 10pt)[Shaded rectangle: $op("supp")(phi ⊗ f)=op("supp")phi times op("supp")f$])
    for (offset, lo, hi, title) in (
      (0, 1.1, 2.5, [Shared locations]),
      (7, 2.4, 3.6, [Separated locations]),
    ) {
      content((offset + 2, 5.05), text(size: 11pt, weight: "bold")[#title])
      content((offset + 2, 4.55), text(size: 9pt, fill: source)[Vertical axis: source position $z$])
      rect((offset, 0), (offset + 4, 4),
        fill: theme.page, stroke: 0.6pt + theme.rule)
      rect((offset + 0.6, lo), (offset + 1.8, hi),
        fill: color.mix((theme.page, 82%), (source, 18%)),
        stroke: 0.9pt + source)
      // The same numerical scale on both axes makes this exactly x = z.
      line((offset, 0), (offset + 4.2, 0),
        stroke: 0.8pt + muted, mark: (end: ">"))
      line((offset, 0), (offset, 4.2),
        stroke: 0.8pt + muted, mark: (end: ">"))
      content((offset + 4.35, 0), text(size: 9pt)[$x$])
      content((offset - 0.18, 4.18), text(size: 9pt)[$z$])
      line((offset, 0), (offset + 4, 4), stroke: 1.6pt + diagonal)
      content((offset + 2.9, 3.45), text(size: 9pt, fill: diagonal)[$x=z$])
      // Marginal intervals identify which factor creates each rectangle side.
      line((offset + 0.6, -0.25), (offset + 1.8, -0.25), stroke: 3pt + observer)
      content((offset + 1.2, -0.65), text(size: 9pt, fill: observer)[$op("supp")phi$])
      line((offset - 0.25, lo), (offset - 0.25, hi), stroke: 3pt + source)
      content((offset - 0.43, (lo + hi) / 2), anchor: "east",
        text(size: 9pt, fill: source)[$op("supp")f$])
      content((offset + 2, -1.15), text(size: 9pt, fill: observer)[Horizontal axis: observer position $x$])
      if offset == 0 {
        line((lo, lo), (1.8, 1.8), stroke: 4pt + selected)
        circle((1.45, 1.45), radius: 0.07, fill: selected, stroke: none)
        line((1.6, 1.4), (2.25, 1.05), (3.65, 1.05), stroke: 0.8pt + selected)
        content((2.95, 0.7), text(size: 9pt, fill: selected)[Reads $phi(t)f(t)$])
        content((2, -1.85), text(size: 10pt)[$integral phi(t)f(t) thin d t > 0$])
      } else {
        content((offset + 2.8, 0.65), text(size: 9pt)[No diagonal overlap])
        content((offset + 2, -1.85), text(size: 10pt)[$integral phi(t)f(t) thin d t = 0$])
      }
    }
    content((5.5, -2.7), text(size: 10.5pt)[
      $chevron.l K_(I),phi ⊗ f chevron.r
      =integral (phi ⊗ f)(t,t) thin d t
      =integral phi(t)f(t) thin d t
      =chevron.l I f,phi chevron.r$
    ])
  })
}

#let distributional-tensor-coupling-diagram() = context {
  let theme = theme-from-text-fill()
  let source = rgb("#1f77b4")
  let observer = rgb("#27ae60")
  let kernel-color = rgb("#8e44ad")
  let muted = theme.muted-text
  let danger = rgb("#c0392b")

  canvas(length: 0.85cm, {
    import draw: *

    // ==========================================
    // --- Left Panel: Point Observation ---
    // ==========================================
    let lx = -4.3
    content((lx, 2.7), text(size: 10.5pt, weight: "bold", fill: theme.text)[Point-wise Evaluation (Idealized)])
    content((lx, 2.2), text(size: 8pt, fill: muted)[Zero-aperture detector sampling field at single point $x$])

    // Point observer at (-6.5, 0.0)
    circle((-6.5, 0.0), radius: 0.12, fill: observer, stroke: 1.5pt + theme.text)
    circle((-6.5, 0.0), radius: 0.28, fill: none, stroke: (paint: observer, thickness: 0.8pt, dash: "dotted"))
    content((-6.5, 0.55), text(size: 8.5pt, weight: "bold", fill: observer)[Observer $x$])
    content((-6.5, -0.52), text(size: 7.5pt, fill: danger)[$delta_x$ (point probe)])

    // Source mass Z at (-2.1, 0.0)
    circle((-2.1, 0.0), radius: (0.9, 1.15), fill: color.mix((theme.page, 88%), (source, 12%)), stroke: (paint: source, thickness: 1.2pt))
    circle((-2.1, 0.0), radius: (0.52, 0.68), fill: color.mix((theme.page, 74%), (source, 26%)), stroke: (paint: source, thickness: 0.8pt, dash: "densely-dotted"))
    content((-2.1, 1.55), text(size: 8.5pt, weight: "bold", fill: source)[Source Mass $Z$])
    content((-2.1, -1.55), text(size: 8pt, fill: source)[Density $f(z) in cal(D)(Z)$])

    // Source points
    circle((-2.2, 0.55), radius: 0.065, fill: source)
    circle((-1.8, 0.0), radius: 0.065, fill: source)
    circle((-2.2, -0.55), radius: 0.065, fill: source)
    content((-1.5, 0.0), text(size: 7.5pt, fill: source)[$z$])

    // Rays converging to x
    line((-2.2, 0.55), (-6.36, 0.06), stroke: (paint: muted, thickness: 0.7pt, dash: "dashed"), mark: (end: ">", fill: muted, size: 0.12))
    line((-1.8, 0.0), (-6.36, 0.0), stroke: (paint: kernel-color, thickness: 1.5pt), mark: (end: ">", fill: kernel-color, size: 0.15))
    line((-2.2, -0.55), (-6.36, -0.06), stroke: (paint: muted, thickness: 0.7pt, dash: "dashed"), mark: (end: ">", fill: muted, size: 0.12))
    content((-4.2, 0.55), text(size: 8.5pt, fill: kernel-color)[$- frac(G, |x - z|)$])

    // Left summary
    content((lx, -2.15), text(size: 8.5pt, fill: theme.text)[$(T f)(x) = integral_(Z) K(x, z) f(z) thin d z$])
    content((lx, -2.65), text(size: 8pt, fill: muted)[Smooth density: the potential is well-defined at every $x$])

    // ==========================================
    // --- Divider ---
    // ==========================================
    line((0.0, -3.0), (0.0, 2.9), stroke: 0.5pt + theme.rule)
    circle((0.0, 0.0), radius: 0.24, fill: theme.page, stroke: 0.6pt + theme.rule)
    content((0.0, 0.0), text(size: 9pt, fill: muted)[$arrow.r$])

    // ==========================================
    // --- Right Panel: Area Observation ---
    // ==========================================
    let rx = 4.5
    content((rx, 2.7), text(size: 10.5pt, weight: "bold", fill: theme.text)[Pairing (Weighted Measurement)])
    content((rx, 2.2), text(size: 8pt, fill: muted)[Detector sensitivity $phi$ weights the field over $X$])

    // Detector Area X at (1.6, 0.0)
    circle((1.6, 0.0), radius: (0.9, 1.15), fill: color.mix((theme.page, 88%), (observer, 12%)), stroke: (paint: observer, thickness: 1.2pt))
    circle((1.6, 0.0), radius: (0.52, 0.68), fill: color.mix((theme.page, 74%), (observer, 26%)), stroke: (paint: observer, thickness: 0.8pt, dash: "densely-dotted"))
    content((1.6, 1.55), text(size: 8.5pt, weight: "bold", fill: observer)[Detector Area $X$])
    content((1.6, -1.55), text(size: 8pt, fill: observer)[Aperture $phi(x) in cal(D)(X)$])

    circle((1.6, 0.15), radius: 0.065, fill: observer)
    content((1.6, 0.38), text(size: 7.5pt, fill: observer)[$x$])
    content((1.6, -0.2), text(size: 7pt, fill: observer)[$phi(x) thin d x$])

    // Source Area Z at (7.4, 0.0)
    circle((7.4, 0.0), radius: (0.9, 1.15), fill: color.mix((theme.page, 88%), (source, 12%)), stroke: (paint: source, thickness: 1.2pt))
    circle((7.4, 0.0), radius: (0.52, 0.68), fill: color.mix((theme.page, 74%), (source, 26%)), stroke: (paint: source, thickness: 0.8pt, dash: "densely-dotted"))
    content((7.4, 1.55), text(size: 8.5pt, weight: "bold", fill: source)[Source Area $Z$])
    content((7.4, -1.55), text(size: 8pt, fill: source)[Mass $f(z) in cal(D)(Z)$])

    circle((7.4, 0.15), radius: 0.065, fill: source)
    content((7.4, 0.38), text(size: 7.5pt, fill: source)[$z$])
    content((7.4, -0.2), text(size: 7pt, fill: source)[$f(z) thin d z$])

    // Coupling bundle between (1.6, 0.0) and (7.4, 0.0)
    // Upper ray
    line((7.1, 0.55), (1.9, 0.55), stroke: (paint: kernel-color, thickness: 0.85pt, dash: "dashed"), mark: (end: ">", fill: kernel-color, size: 0.12))
    // Center ray
    line((7.3, 0.15), (1.7, 0.15), stroke: (paint: kernel-color, thickness: 1.6pt), mark: (end: ">", fill: kernel-color, size: 0.15))
    // Lower ray
    line((7.1, -0.55), (1.9, -0.55), stroke: (paint: kernel-color, thickness: 0.85pt, dash: "dashed"), mark: (end: ">", fill: kernel-color, size: 0.12))

    // Labels in the middle gap
    content((4.5, 0.95), text(size: 8.5pt, fill: kernel-color, weight: "bold")[$K(x, z) = - frac(G, |x-z|)$])
    content((4.5, -0.95), text(size: 8pt, fill: theme.text)[Tensor probe: $(phi ⊗ f)(x, z)$])
    content((4.5, -1.3), text(size: 7pt, fill: muted)[Volume-to-volume coupling])

    // Right summary
    content((rx, -2.15), text(size: 8.5pt, weight: "bold", fill: theme.text)[$chevron.l T f, phi chevron.r = chevron.l K, phi ⊗ f chevron.r$])
    content((rx, -2.65), text(size: 8pt, fill: observer)[A scalar measurement; pairing also accommodates distribution kernels])
  })
}

#let schwartz-kernel-periodization-diagram() = context {
  let theme = theme-from-text-fill()
  let accent = theme.callouts.proposition.border
  let muted = theme.muted-text
  let source = rgb("#1f77b4")
  let observer = rgb("#27ae60")
  let kernel-color = rgb("#8e44ad")

  canvas(length: 0.76cm, {
    import draw: *

    // ==========================================
    // Left Panel: Support and Cutoff Geometry
    // ==========================================
    let lx = -4.2
    content((lx, 3.2), text(size: 9.5pt, weight: "bold", fill: theme.text)[Bivariate Support & Cube $Q_x times Q_z$])
    content((lx, 2.75), text(size: 7.5pt, fill: muted)[Coupled support $op("supp") Psi$ and compact projections $A, D$])

    // Cube Q_x x Q_z boundary: [-2.1, 2.1] centered at lx
    rect((lx - 2.1, -2.1), (lx + 2.1, 2.1),
      stroke: (paint: muted, thickness: 0.9pt, dash: "dashed"),
      fill: color.mix((theme.page, 95%), (theme.text, 5%)))

    // Axes inside the cube
    line((lx - 2.3, 0), (lx + 2.3, 0), stroke: 0.6pt + muted, mark: (end: ">", size: 0.1))
    line((lx, -2.3), (lx, 2.3), stroke: 0.6pt + muted, mark: (end: ">", size: 0.1))
    content((lx + 2.45, 0.0), text(size: 8pt, fill: observer)[$x$])
    content((lx, 2.45), text(size: 8pt, fill: source)[$z$])
    content((lx - 1.85, 1.85), text(size: 7.5pt, fill: muted)[$Q_x times Q_z$])

    // Coordinate intervals on axes: A subset X (horizontal) and D subset Z (vertical)
    line((lx - 0.9, 0), (lx + 1.1, 0), stroke: 2.2pt + observer)
    content((lx + 0.1, -0.32), text(size: 7.5pt, weight: "bold", fill: observer)[$A subset X$])
    line((lx, -0.8), (lx, 1.2), stroke: 2.2pt + source)
    content((lx - 0.45, 0.2), text(size: 7.5pt, weight: "bold", fill: source)[$D subset Z$])

    // Cutoff indicators: chi(x) along bottom, eta(z) along left
    content((lx + 0.1, -1.85), text(size: 7pt, fill: observer)[Cutoff $chi(x) equiv 1$ near $A$])
    content((lx - 1.6, -1.3), text(size: 7pt, fill: source)[$eta(z) equiv 1$ near $D$])

    // Support of Psi: tilted/coupled ellipse in X x Z (e.g. diagonal near x = z)
    rotate(38deg, origin: (lx + 0.1, 0.2))
    circle((lx + 0.1, 0.2), radius: (1.2, 0.55),
      fill: color.mix((theme.page, 75%), (kernel-color, 25%)),
      stroke: 1.2pt + kernel-color)
    content((lx + 0.1, 0.2), text(size: 8pt, weight: "bold", fill: kernel-color)[$op("supp") Psi$])
    rotate(-38deg, origin: (lx + 0.1, 0.2))

    // ==========================================
    // Middle Arrow: Periodization & Fourier Decoupling
    // ==========================================
    line((-1.2, 0.0), (0.8, 0.0), stroke: 1.2pt + theme.rule, mark: (end: ">", fill: theme.rule, size: 0.15))
    content((-0.2, 0.55), text(size: 8pt, weight: "bold", fill: theme.text)[Torus Fourier])
    content((-0.2, 0.2), text(size: 7pt, fill: muted)[Periodize $2 pi L$])
    content((-0.2, -0.4), text(size: 7.5pt, fill: kernel-color)[$e_j(x) h_k(z)$])
    content((-0.2, -0.75), text(size: 6.8pt, fill: muted)[Decouples $x, z$])

    // ==========================================
    // Right Panel: Tensor Product Decomposition
    // ==========================================
    let rx = 4.2
    content((rx, 3.2), text(size: 9.5pt, weight: "bold", fill: theme.text)[Separable Tensor Mode Expansion])
    content((rx, 2.75), text(size: 7.5pt, fill: muted)[Localized product basis $(chi e_j) ⊗ (eta h_k) in cal(D)(X) ⊗ cal(D)(Z)$])

    // Cube outline
    rect((rx - 2.1, -2.1), (rx + 2.1, 2.1),
      stroke: (paint: muted, thickness: 0.9pt, dash: "dashed"),
      fill: color.mix((theme.page, 95%), (theme.text, 5%)))

    // Grid of separable 1D waves
    // Vertical bands for chi(x) e_j(x)
    for k in (-1.4, -0.7, 0.0, 0.7, 1.4) {
      line((rx + k, -1.7), (rx + k, 1.7), stroke: (paint: observer, thickness: 0.6pt, dash: "dotted"))
    }
    // Horizontal bands for eta(z) h_k(z)
    for m in (-1.4, -0.7, 0.0, 0.7, 1.4) {
      line((rx - 1.7, m), (rx + 1.7, m), stroke: (paint: source, thickness: 0.6pt, dash: "dotted"))
    }

    // Grid points representing tensor product modes
    for k in (-1.4, -0.7, 0.0, 0.7, 1.4) {
      for m in (-1.4, -0.7, 0.0, 0.7, 1.4) {
        circle((rx + k, m), radius: 0.045, fill: theme.rule, stroke: none)
      }
    }

    // Localized support region highlighted in green-blue
    rect((rx - 1.1, -1.0), (rx + 1.2, 1.3),
      stroke: (paint: accent, thickness: 1pt),
      fill: color.mix((theme.page, 80%), (accent, 20%)))
    content((rx + 0.05, 0.15), text(size: 8pt, weight: "bold", fill: theme.text)[$(chi e_j) ⊗ (eta h_k)$])

    // Labels explaining the rapid convergence
    content((rx, -1.75), text(size: 7.5pt, fill: theme.text)[$Psi = sum_(j,k) c_(j,k)(Psi) (chi e_j) ⊗ (eta h_k)$])
    content((rx, -2.45), text(size: 7.5pt, fill: accent)[Rapid decay $|c_(j,k)| <= C_N (1+|j|+|k|)^(-2N)$])
  })
}

// Translation orbits in the product of source and observer coordinates.
#let translation-orbit-diagram() = context {
  let theme = theme-from-text-fill()
  let accent = theme.callouts.proposition.border
  canvas(length: 0.85cm, {
    import draw: *
    line((0, 0), (4.7, 0), stroke: theme.muted-text, mark: (end: ">"))
    line((0, 0), (0, 3.6), stroke: theme.muted-text, mark: (end: ">"))
    content((4.9, 0), text(size: 10pt)[$x$])
    content((0, 3.85), text(size: 10pt)[$z$])
    for r in (-1, 0, 1, 2) {
      let start = (calc.max(r, 0), calc.max(-r, 0))
      let end = (calc.min(4, 3 + r), calc.min(3, 4 - r))
      line(start, end, stroke: if r == 1 { 1.6pt + accent }
        else { (paint: theme.rule, thickness: 0.7pt, dash: "dashed") })
    }
    for pt in ((1, 0), (1.8, 0.8), (3, 2)) {
      circle(pt, radius: 0.065, fill: accent, stroke: none)
    }
    content((1, -0.35), text(size: 9pt)[$(r,0)$])
    content((1.94, 0.68), anchor: "west", text(size: 9pt)[$(x,z)$])
    content((3.15, 1.65), anchor: "west", text(size: 9pt)[$(x+a,z+a)$])
    line((1.55, 1.05), (2.75, 2.25), stroke: 1pt + accent, mark: (end: ">"))
    content((1.65, 1.9), anchor: "east", text(size: 9pt, fill: accent)[$(a,a)$])
    content((7.8, 2.9), text(size: 10pt, weight: "bold")[One line, one difference])
    content((7.8, 2.1), text(size: 11pt)[$(x+a)-(z+a)=x-z$])
    content((7.8, 1.25), text(size: 10pt, fill: accent)[$r=x-z$])
    content((7.8, 0.4), text(size: 9pt)[Integrate tests along each line])
  })
}

// Actual one-dimensional profiles, with the same x and density scales.
#let subordination-mixture-diagram() = context {
  let theme = theme-from-text-fill()
  let colors = (theme.callouts.proposition.border, theme.callouts.important.border, theme.callouts.tip.border)
  let scale-y = 2.5
  canvas(length: 0.85cm, {
    import draw: *
    content((-3.6, 3.3), text(size: 10pt, weight: "bold")[Heat profiles $p_(t)$])
    content((3.6, 3.3), text(size: 10pt, weight: "bold")[Poisson profile $P_(1)$])
    for cx in (-3.6, 3.6) {
      line((cx - 2.1, 0), (cx + 2.25, 0), stroke: 0.6pt + theme.muted-text, mark: (end: ">"))
      content((cx + 2.35, -0.15), text(size: 9pt)[$x$])
      for q in (-2, 0, 2) {
        line((cx + q, -0.05), (cx + q, 0.05), stroke: 0.5pt + theme.muted-text)
        content((cx + q, -0.3), text(size: 8pt)[#q])
      }
      line((cx - 2.1, 0), (cx - 2.1, 2.1), stroke: 0.5pt + theme.muted-text)
      for value in (0.4, 0.8) {
        let yy = scale-y * value
        line((cx - 2.15, yy), (cx - 2.05, yy), stroke: 0.5pt + theme.muted-text)
        content((cx - 2.25, yy), anchor: "east", text(size: 8pt)[#value])
      }
    }
    for (j, t) in (0.125, 0.5, 2).enumerate() {
      let points = range(0, 121).map(i => {
        let x = -2 + i / 30
        let density = calc.exp(-x*x/(4*t)) / calc.sqrt(4*calc.pi*t)
        (-3.6 + x, scale-y * density)
      })
      line(..points, stroke: 1.1pt + colors.at(j))
      let yy = 2.85 - j * 0.27
      line((-5.1, yy), (-4.6, yy), stroke: 1.1pt + colors.at(j))
      content((-4.45, yy), anchor: "west", text(size: 8pt)[$t=$ #t])
    }
    let poisson = range(0, 121).map(i => {
      let x = -2 + i / 30
      (3.6 + x, scale-y / (calc.pi*(1+x*x)))
    })
    line(..poisson, stroke: 1.5pt + colors.first())
    line((-0.95, 1.3), (0.95, 1.3), stroke: 1pt + theme.text, mark: (end: ">"))
    content((0, 1.9), text(size: 9pt)[$w_(1)(t) thin d t$])
    content((0, 0.75), text(size: 8pt)[all $t>0$])
    content((0, -1.0), text(size: 10pt)[$P_(1)(x)=integral_(0)^(infinity)w_(1)(t)p_(t)(x) thin d t$])
    content((0, -1.6), text(size: 9pt)[Each profile has integral one over the full real line.])
  })
}

#let kernel-support-comparison-diagram() = context {
  let theme = theme-from-text-fill()
  let accent = theme.callouts.proposition.border
  let support-fill = theme.callouts.proposition.bg
  canvas(length: 0.85cm, {
    import draw: *
    for (cx, title, label) in (
      (-4.3, [Heat in $bb(R)^(3)$], [all of $bb(R)^(3)$]),
      (0, [Wave in $bb(R)^(3)$], [$|x|=t$]),
      (4.3, [Wave in $bb(R)^(2)$], [$|x|<=t$]),
    ) {
      content((cx, 2.1), text(size: 10pt, weight: "bold", title))
      if cx < 0 {
        rect((cx - 1.45, -1.35), (cx + 1.45, 1.35), fill: support-fill, stroke: none)
        for direction in (-1, 1) {
          line((cx + direction * 0.8, 0), (cx + direction * 1.75, 0), stroke: accent, mark: (end: ">"))
          line((cx, direction * 0.6), (cx, direction * 1.6), stroke: accent, mark: (end: ">"))
        }
      } else {
        circle((cx, 0), radius: 1.25, stroke: 1.5pt + accent,
          fill: if cx > 0 { support-fill } else { none })
      }
      content((cx, -1.95), text(size: 10pt, label))
    }
    content((0, -2.6), text(size: 9pt)[Support only: no curve or shading represents a kernel's height.])
  })
}

#let frequency-operator-map() = context {
  let theme = theme-from-text-fill()
  canvas(length: 0.85cm, {
    import draw: *
    for (xx, body) in ((-5, [$f$]), (-1.8, [$hat(f)$]), (1.8, [$h(|xi|)hat(f)$]), (5, [$h(A)f$])) {
      content((xx, 1.7), text(size: 11pt, body))
    }
    for (x1, x2, label) in ((-4.6, -2.2, [$cal(F)$]), (-1.35, 0.7, [$times h(|xi|)$]), (2.9, 4.0, [$cal(F)^(-1)$])) {
      line((x1, 1.7), (x2, 1.7), stroke: theme.text, mark: (end: ">"))
      content(((x1+x2)/2, 2.2), text(size: 9pt, label))
    }
    line((-5.5, 0.9), (5.5, 0.9), stroke: 0.5pt + theme.rule)
    for (xx, title, body) in (
      (-3.8, [Heat], [$h(a)=e^(-t a^(2))$]),
      (0, [Poisson], [$h(a)=e^(-y a)$]),
      (3.8, [Wave], [$h(a)=cos(t a)$ #linebreak() or $h(a)=b_(t)(a)$]),
    ) {
      content((xx, 0.35), text(size: 10pt, weight: "bold", title))
      content((xx, -0.45), text(size: 10pt, body))
    }
    content((0, -1.4), text(size: 9pt)[$a=|xi|$, $A=cal(F)^(-1)|xi|cal(F)$])
  })
}
