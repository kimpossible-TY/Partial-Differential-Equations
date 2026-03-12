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
