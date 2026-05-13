#import "@preview/cetz:0.4.2": *

#let conformal_killing_field_visualization() = canvas({
  import draw: *

  // Settings
  let color_conformal = rgb("3050F0") // Blue
  let color_non_conformal = rgb("E03030") // Red

  // --- Left: Conformal Killing Field ---
  group(name: "conformal", {
    translate((-3.5, 0))

    // Central point
    circle((0, 0), radius: 0.05, fill: black)
    content((0, -0.3), [$p$])

    // Initial circle (unit neighborhood)
    circle((0, 0), radius: 1, stroke: (paint: gray, dash: "dashed"))

    // The vector field arrows (isotropic stretching)
    let r = 1
    let scale = 0.6 // length of the arrows
    for angle in (0, 45, 90, 135, 180, 225, 270, 315) {
      let x = r * calc.cos(angle * 1deg)
      let y = r * calc.sin(angle * 1deg)
      let dx = scale * calc.cos(angle * 1deg)
      let dy = scale * calc.sin(angle * 1deg)
      line((x, y), (x + dx, y + dy), mark: (end: ">"), stroke: (paint: color_conformal, thickness: 1.5pt))
    }

    // Shape after a small time step (larger circle)
    circle((0, 0), radius: 1 + scale, stroke: (paint: color_conformal, dash: "dotted", thickness: 1.2pt))

    content((0, -2.2), text(weight: "bold")[Conformal Killing Field $X$])
    content((0, -2.6), text(size: 8pt)[Stretches evenly in all directions])
    content((0, -3.0), text(size: 8pt)[(Preserves the shape of the neighborhood)])
  })

  // --- Right: Non-Conformal Field ---
  group(name: "non_conformal", {
    translate((3.5, 0))

    // Central point
    circle((0, 0), radius: 0.05, fill: black)
    content((0, -0.3), [$q$])

    // Initial circle (unit neighborhood)
    circle((0, 0), radius: 1, stroke: (paint: gray, dash: "dashed"))

    // The vector field arrows (anisotropic stretching, e.g., stretch x more than y)
    let r = 1
    let scale_x = 0.8
    let scale_y = 0.2

    for angle in (0, 45, 90, 135, 180, 225, 270, 315) {
      let x = r * calc.cos(angle * 1deg)
      let y = r * calc.sin(angle * 1deg)
      let dx = scale_x * calc.cos(angle * 1deg)
      let dy = scale_y * calc.sin(angle * 1deg)
      line((x, y), (x + dx, y + dy), mark: (end: ">"), stroke: (paint: color_non_conformal, thickness: 1.5pt))
    }

    // Shape after a small time step (an ellipse)
    group({
      // Scale the circle to make an ellipse representing the stretched shape
      scale(x: 1 + scale_x, y: 1 + scale_y)
      circle((0, 0), radius: 1, stroke: (paint: color_non_conformal, dash: "dotted", thickness: 1.2pt))
    })

    content((0, -2.2), text(weight: "bold")[Non-Conformal Field $Y$])
    content((0, -2.6), text(size: 8pt)[Stretches unevenly])
    content((0, -3.0), text(size: 8pt)[(Distorts the shape of the neighborhood)])
  })
})


#let domain-codomain-u() = canvas({
  import draw: *

  // --- Domain: R x M ---
  rect(
    (0, 0),
    (4.6, 2.6),
    radius: .15,
    stroke: (paint: gray, thickness: .8pt),
    fill: rgb("#f7f7f7"),
  )

  content((2.7, 2.25), [$"domain": RR times M$])
  content((.45, 1.35), [$t in RR$])
  content((2.6, .45), [$x in M$])

  line((1.0, .8), (4.1, .8), stroke: gray)
  line((1.0, .8), (1.0, 2.0), stroke: gray)

  content((4.25, .8), [$M$])
  content((1.0, 2.15), [$RR$])

  circle((2.7, 1.35), radius: .06, fill: black)
  content((3.3, 1.35), [$(t,x)$])

  // --- Arrow u ---
  line(
    (5.2, 1.3),
    (6.9, 1.3),
    stroke: (paint: black, thickness: 1pt),
    mark: (end: ">"),
  )
  content((6.05, 1.65), [$u$])
  content((6.05, .95), [$(t,x) mapsto u(t,x)$])

  // --- Codomain: N ---
  rect(
    (7.5, 0),
    (11.5, 2.6),
    radius: .15,
    stroke: (paint: gray, thickness: .8pt),
    fill: rgb("#f4f8ff"),
  )

  content((9.4, 2.25), [$"codomain": N$])
  content((9.4, .35), [$u(t,x) in N$])

  // A point in N
  circle((9.25, 1.4), radius: .07, fill: black)
  content((9.75, 1), [$u(t,x)$])

  // --- Fixed x trajectory ---
  content((2.4, -.55), [$x "fixed": gamma_x(t) := u(t,x)$])

  line(
    (7.85, 1.0),
    (8.35, 1.45),
    (8.95, 1.55),
    (9.55, 1.25),
    (10.25, 1.65),
    stroke: (paint: rgb("#3366cc"), thickness: 1.1pt),
    mark: (end: ">"),
  )

  content((10.25, 1.95), [$gamma_x(t)$])
})