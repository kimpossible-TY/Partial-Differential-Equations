#import "@preview/cetz:0.4.2": *
#import "@local/cetz-helpers:0.1.0": *
#import "../Styles/styles.typ": *

#let trace-comparison-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let matrix-accent = rgb("#d06a45")
  let metric-accent = rgb("#2f8f6b")
  let slot-accent = rgb("#5b6ee1")

  canvas(length: 0.72cm, {
    import draw: *

    content((-4.2, 2.4), anchor: "west", text(weight: "bold", size: 9pt)[Ordinary matrix trace])
    content((5.0, 2.4), anchor: "west", text(weight: "bold", size: 9pt)[Riemannian trace])

    content((-4.2, 1.75), anchor: "west", text(size: 8.5pt)[$A: V arrow V$])
    rect((-3.55, -0.45), (-1.15, 1.55), stroke: (paint: stroke-color, thickness: 0.75pt))
    line((-2.35, -0.45), (-2.35, 1.55), stroke: (paint: muted, thickness: 0.45pt))
    line((-3.55, 0.55), (-1.15, 0.55), stroke: (paint: muted, thickness: 0.45pt))

    rect((-3.45, 0.65), (-2.45, 1.45), fill: rgb("#fff0e8"), stroke: (paint: matrix-accent, thickness: 0.8pt))
    rect((-2.25, -0.35), (-1.25, 0.45), fill: rgb("#fff0e8"), stroke: (paint: matrix-accent, thickness: 0.8pt))
    rect((-2.25, 0.65), (-1.25, 1.45), fill: rgb("#eef1ff"), stroke: (paint: slot-accent, thickness: 0.55pt))
    rect((-3.45, -0.35), (-2.45, 0.45), fill: rgb("#eef1ff"), stroke: (paint: slot-accent, thickness: 0.55pt))

    content((-2.95, 1.04), text(size: 8pt)[$A^1_1$])
    content((-1.75, 1.04), text(size: 8pt)[$A^1_2$])
    content((-2.95, 0.04), text(size: 8pt)[$A^2_1$])
    content((-1.75, 0.04), text(size: 8pt)[$A^2_2$])

    line((-0.75, 0.55), (0.2, 0.55), stroke: (paint: matrix-accent, thickness: 0.8pt), mark: (end: ">"))
    content((0.35, 0.55), anchor: "west", text(fill: matrix-accent, size: 8.5pt)[$op("tr")(A)=A^1_1+A^2_2$])
    content((-4.2, -1.0), anchor: "west", text(size: 8pt, fill: muted)[same input/output direction])

    content((5.0, 1.75), anchor: "west", text(size: 8.5pt)[$T_(i j)$ needs $g^(i j)$])

    rect((5.6, 0.55), (6.65, 1.45), fill: rgb("#eef1ff"), stroke: (paint: slot-accent, thickness: 0.7pt))
    rect((7.05, 0.55), (8.1, 1.45), fill: rgb("#eef1ff"), stroke: (paint: slot-accent, thickness: 0.7pt))
    content((6.13, 1.0), text(size: 8.5pt)[$i$])
    content((7.58, 1.0), text(size: 8.5pt)[$j$])
    content((6.85, 1.0), text(size: 10pt, fill: muted)[$T$])

    line((6.13, 0.42), (6.13, -0.15), stroke: (paint: metric-accent, thickness: 0.85pt), mark: (end: ">"))
    line((7.58, 0.42), (7.58, -0.15), stroke: (paint: metric-accent, thickness: 0.85pt), mark: (end: ">"))
    rect((5.5, -1.0), (8.2, -0.2), fill: rgb("#edf8f1"), stroke: (paint: metric-accent, thickness: 0.8pt), radius: 0.08)
    content((6.85, -0.6), text(size: 8.5pt)[$g^(i j) T_(i j)$])
    content((5.0, -1.52), anchor: "west", text(size: 8pt, fill: muted)[metric decides how slots are compared])
  })
}

#let curvature-trace-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let curve1-color = rgb("#d06a45") // Orange
  let curve2-color = rgb("#5b6ee1") // Blue
  let metric-accent = rgb("#2f8f6b") // Green

  canvas(length: 0.9cm, {
    import draw: *

    let z(x, y) = (x * x + y * y) / 6.0
    let grid-stroke = (paint: stroke-color.lighten(70%), thickness: 0.4pt)

    // Draw grid lines of the surface paraboloid (dome in screen space)
    // Constant y lines
    for y in range(-3, 4) {
      let y_val = y * 1.0
      let pts = ()
      for x in range(-15, 16) {
        let x_val = x * 0.2
        pts.push((x_val, y_val, z(x_val, y_val)))
      }
      line(..pts, stroke: grid-stroke)
    }

    // Constant x lines
    for x in range(-3, 4) {
      let x_val = x * 1.0
      let pts = ()
      for y in range(-15, 16) {
        let y_val = y * 0.2
        pts.push((x_val, y_val, z(x_val, y_val)))
      }
      line(..pts, stroke: grid-stroke)
    }

    // Highlight Curve 1 (along x-axis, constant y = 0)
    let pts1 = ()
    for x in range(-15, 16) {
      let x_val = x * 0.2
      pts1.push((x_val, 0, z(x_val, 0)))
    }
    line(..pts1, stroke: (paint: curve1-color, thickness: 1.8pt))
    content((3.2, 0, z(3.2, 0)), anchor: "west", text(size: 8.5pt, fill: curve1-color)[Curve 1: $C_1(t)$])

    // Highlight Curve 2 (along y-axis, constant x = 0)
    let pts2 = ()
    for y in range(-15, 16) {
      let y_val = y * 0.2
      pts2.push((0, y_val, z(0, y_val)))
    }
    line(..pts2, stroke: (paint: curve2-color, thickness: 1.8pt))
    content((0, 3.2, z(0, 3.2)), anchor: "south-west", text(size: 8.5pt, fill: curve2-color)[Curve 2: $C_2(t)$])

    // Point P at the top of the dome (0, 0, 0)
    circle((0, 0, 0), radius: 0.1, fill: stroke-color, stroke: none)
    content((0, 0.4, -0.4), text(size: 10pt, weight: "bold")[$P$])

    // Tangent vectors at P
    // e1 tangent to Curve 1
    line((0, 0, 0), (2.0, 0, 0), stroke: (paint: curve1-color, thickness: 1.2pt), mark: (end: ">"))
    content((2.3, 0, 0), text(size: 9pt, fill: curve1-color)[$e_1$])

    // e2 tangent to Curve 2
    line((0, 0, 0), (0, 2.0, 0), stroke: (paint: curve2-color, thickness: 1.2pt), mark: (end: ">"))
    content((0, 2.3, 0), text(size: 9pt, fill: curve2-color)[$e_2$])

    // Curvature vectors at P (pointing downwards on screen / positive z)
    // Offset slightly for visual clarity
    line((-0.6, 0, 0), (-0.6, 0, 1.5), stroke: (paint: curve1-color, thickness: 1.2pt, dash: "dashed"), mark: (end: ">"))
    content((-1.1, 0, 0.75), text(size: 9pt, fill: curve1-color)[$vec(kappa)_1$])

    line((0.6, 0, 0), (0.6, 0, 1.5), stroke: (paint: curve2-color, thickness: 1.2pt, dash: "dashed"), mark: (end: ">"))
    content((1.1, 0, 0.75), text(size: 9pt, fill: curve2-color)[$vec(kappa)_2$])

    // Laplacian/Riemannian Trace vector (thick green arrow pointing straight down / positive z)
    line((0, 0, 0), (0, 0, 3.0), stroke: (paint: metric-accent, thickness: 2.2pt), mark: (end: ">"))
    content((0.0, -0.4, 3.5), anchor: "north", text(size: 9.5pt, fill: metric-accent, weight: "bold")[$Delta u = kappa_1 + kappa_2$])
  })
}
