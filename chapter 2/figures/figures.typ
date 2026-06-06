#import "@preview/cetz:0.4.2": *
#import "../../Styles/styles.typ": theme-from-text-fill

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

#let dirichlet_boundary_condition_visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_blue = rgb("#4a90e2")
  let color_blue_light = rgb("#4a90e2").lighten(50%)

  canvas({
    import draw: *

    // Draw the baseline (x-axis)
    line((-4, 0), (4, 0), stroke: (paint: color_muted, dash: "dashed", thickness: 0.5pt))
    
    // Draw boundary supports (walls or pinned brackets) at x = -3 and x = 3
    // Left support
    rect((-3.3, -0.4), (-3, 0.4), fill: color_muted.lighten(80%), stroke: color_muted)
    // Right support
    rect((3, -0.4), (3.3, 0.4), fill: color_muted.lighten(80%), stroke: color_muted)

    // Draw the vibrating curves (multiple phases for premium look)
    // Mid-phase curve (light)
    bezier((-3, 0), (3, 0), (-1.5, 0.9), (1.5, 0.9), stroke: (paint: color_blue_light, thickness: 1pt))
    bezier((-3, 0), (3, 0), (-1.5, -0.9), (1.5, -0.9), stroke: (paint: color_blue_light, thickness: 1pt))

    // Peak phase (solid blue)
    bezier((-3, 0), (3, 0), (-1.5, 1.8), (1.5, 1.8), stroke: (paint: color_blue, thickness: 2pt))
    
    // Trough phase (dashed blue)
    bezier((-3, 0), (3, 0), (-1.5, -1.8), (1.5, -1.8), stroke: (paint: color_blue_light, dash: "dashed", thickness: 1pt))

    // Draw boundary nodes (prominent circles)
    circle((-3, 0), radius: 0.08, fill: color_stroke, stroke: color_stroke)
    circle((3, 0), radius: 0.08, fill: color_stroke, stroke: color_stroke)

    // Vertical displacement arrows in the middle
    line((0, -1.6), (0, 1.6), mark: (start: ">", end: ">"), stroke: (paint: color_stroke, thickness: 1.0pt))
    content((0.3, 0.5), [Displacement $u(t,x)$], anchor: "west")

    // Label boundary conditions (outside the string and supports to prevent overlap)
    content((-4.2, 0), [$u(t, -L) = 0$], anchor: "east")
    content((4.2, 0), [$u(t, L) = 0$], anchor: "west")
    
    // Title/Description inside the canvas
    content((0, 2.3), text(weight: "bold", size: 11pt)[Dirichlet Boundary Condition], anchor: "south")
    content((0, -2.3), text(size: 9pt, style: "italic")[Fixed boundary: wave displacement is pinned to zero at the endpoints $partial M$], anchor: "north")
  })
}

#let neumann_boundary_condition_visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_red = rgb("#e35f5f")
  let color_red_light = rgb("#e35f5f").lighten(50%)

  canvas({
    import draw: *

    // Draw the baseline (x-axis)
    line((-4, 0), (4, 0), stroke: (paint: color_muted, dash: "dashed", thickness: 0.5pt))

    // Draw vertical guide rods at x = -3 and x = 3
    line((-3, -1.8), (-3, 1.8), stroke: (paint: color_muted, thickness: 1pt))
    line((3, -1.8), (3, 1.8), stroke: (paint: color_muted, thickness: 1pt))

    // Draw the vibrating curves (cosine-like waves with horizontal tangents)
    // Curve 1 (solid red)
    bezier((-3, -1.2), (0, 1.2), (-2, -1.2), (-1, 1.2), stroke: (paint: color_red, thickness: 2pt))
    bezier((0, 1.2), (3, -1.2), (1, 1.2), (2, -1.2), stroke: (paint: color_red, thickness: 2pt))

    // Mid-phase curves (light)
    bezier((-3, -0.6), (0, 0.6), (-2, -0.6), (-1, 0.6), stroke: (paint: color_red_light, thickness: 1pt))
    bezier((0, 0.6), (3, -0.6), (1, 0.6), (2, -0.6), stroke: (paint: color_red_light, thickness: 1pt))
    bezier((-3, 0.6), (0, -0.6), (-2, 0.6), (-1, -0.6), stroke: (paint: color_red_light, thickness: 1pt))
    bezier((0, -0.6), (3, 0.6), (1, -0.6), (2, 0.6), stroke: (paint: color_red_light, thickness: 1pt))

    // Opposite phase (dashed red)
    bezier((-3, 1.2), (0, -1.2), (-2, 1.2), (-1, -1.2), stroke: (paint: color_red_light, dash: "dashed", thickness: 1pt))
    bezier((0, -1.2), (3, 1.2), (1, -1.2), (2, 1.2), stroke: (paint: color_red_light, dash: "dashed", thickness: 1pt))

    // Draw rings at the boundary ends sliding on the rods
    circle((-3, -1.2), radius: 0.08, fill: theme.page, stroke: color_red)
    circle((3, -1.2), radius: 0.08, fill: theme.page, stroke: color_red)
    
    circle((-3, 1.2), radius: 0.08, fill: theme.page, stroke: color_red_light)
    circle((3, 1.2), radius: 0.08, fill: theme.page, stroke: color_red_light)

    // Draw tangent indicators (horizontal dashed lines) at the boundaries
    line((-3.6, -1.2), (-2.4, -1.2), stroke: (paint: color_stroke, dash: "dotted", thickness: 1pt))
    line((2.4, -1.2), (3.6, -1.2), stroke: (paint: color_stroke, dash: "dotted", thickness: 1pt))
    
    line((-3.6, 1.2), (-2.4, 1.2), stroke: (paint: color_stroke, dash: "dotted", thickness: 1pt))
    line((2.4, 1.2), (3.6, 1.2), stroke: (paint: color_stroke, dash: "dotted", thickness: 1pt))

    // Label boundary conditions (outside the string and guide rods to prevent overlap)
    content((-4.6, 0), [$frac(partial u, partial x)(t, -L) = 0$], anchor: "east")
    content((4.6, 0), [$frac(partial u, partial x)(t, L) = 0$], anchor: "west")

    // Title/Description inside the canvas
    content((0, 2.3), text(weight: "bold", size: 11pt)[Neumann Boundary Condition], anchor: "south")
    content((0, -2.3), text(size: 9pt, style: "italic")[Free boundary: wave has zero slope (horizontal tangent) at the endpoints $partial M$], anchor: "north")
  })
}

#let spacelike-boundary-decomposition-visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_domain = rgb("#edf2ff")
  let color_sigma_one = rgb("#2f8f6b")
  let color_sigma_two = rgb("#5b6ee1")
  let color_slice = rgb("#d06a45")

  canvas(length: 0.9cm, {
    import draw: *

    let left = (-3.2, 0)
    let right = (3.2, 0)
    let top = (0, 1.65)
    let bottom = (0, -1.65)
    let slice_y = 0.78
    let slice_left = (-2.35, slice_y)
    let slice_right = (2.35, slice_y)
    let upper_normal_base = (0, 1.18)
    let lower_normal_base = (0, -1.18)

    // The bounded spacetime region Omega.
    bezier(left, right, (-2.2, 1.65), (2.2, 1.65), stroke: (paint: color_sigma_two, thickness: 1.8pt))
    bezier(left, right, (-2.2, -1.65), (2.2, -1.65), stroke: (paint: color_sigma_one, thickness: 1.8pt))
    bezier(left, right, (-2.2, 1.65), (2.2, 1.65), fill: color_domain, stroke: none)
    bezier(left, right, (-2.2, -1.65), (2.2, -1.65), fill: color_domain, stroke: none)

    // Redraw the boundary on top of the light fill.
    bezier(left, right, (-2.2, 1.65), (2.2, 1.65), stroke: (paint: color_sigma_two, thickness: 1.8pt))
    bezier(left, right, (-2.2, -1.65), (2.2, -1.65), stroke: (paint: color_sigma_one, thickness: 1.8pt))

    // Product coordinates.
    line((-3.6, 0), (3.85, 0), stroke: (paint: color_stroke, thickness: 0.8pt), mark: (end: ">"))
    line((0, -2.05), (0, 2.05), stroke: (paint: color_stroke, thickness: 0.8pt), mark: (end: ">"))
    content((4.05, 0), anchor: "west")[$"spaceline" M$]
    content((0, 2.22), anchor: "south")[$"timeline" RR$]

    // Spatial slice Omega_t.
    line(slice_left, slice_right, stroke: (paint: color_slice, thickness: 1.25pt))
    line((slice_left.at(0), 0), slice_left, stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    line((slice_right.at(0), 0), slice_right, stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    circle((0, slice_y), radius: 0.045, fill: color_slice)
    content((0.14, slice_y - 0.6), anchor: "south-west", text(fill: color_slice)[$Omega_t$])

    // Labels.
    content((-3.55, 2.18), anchor: "west", text(size: 9pt)[$Sigma_0 union Sigma_1 = partial Omega$])
    content((-0.38, -0.55), anchor: "east")[$Omega$]

    line((3.85, 1.05), (2.35, 1.02), stroke: (paint: color_sigma_two, thickness: 0.85pt), mark: (end: ">"))
    content((4.05, 1.08), anchor: "west", text(fill: color_sigma_two)[$Sigma_1$])

    line((3.85, -1.05), (2.35, -1.02), stroke: (paint: color_sigma_one, thickness: 0.85pt), mark: (end: ">"))
    content((4.05, -1.08), anchor: "west", text(fill: color_sigma_one)[$Sigma_0$])

    // Time components of the outward normal on each boundary piece.
    line(upper_normal_base, (upper_normal_base.at(0), upper_normal_base.at(1) + 0.62), stroke: (paint: color_sigma_two, thickness: 1pt), mark: (end: ">"))
    content((upper_normal_base.at(0) + 0.16, upper_normal_base.at(1) + 0.48), anchor: "west", text(fill: color_sigma_two)[$(N_t)_(Sigma_1)$])

    line(lower_normal_base, (lower_normal_base.at(0), lower_normal_base.at(1) - 0.62), stroke: (paint: color_sigma_one, thickness: 1pt), mark: (end: ">"))
    content((lower_normal_base.at(0) - 0.12, lower_normal_base.at(1) - 0.68), anchor: "north-east", text(fill: color_sigma_one)[$(N_t)_(Sigma_0)$])
  })
}

#let normal-measure-projection-visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_boundary = rgb("#5b6ee1")
  let color_time = rgb("#2f8f6b")
  let color_space = rgb("#d06a45")

  canvas(length: 1.25cm, {
    import draw: *

    // Boundary segment coordinates passing through the origin (0, 0)
    let a = (-1.0, -1.2)
    let b = (1.0, 1.2)
    
    // Normal vector starts at (0, 0)
    let m = (0, 0)
    
    // Outward unit normal components: N_x = -1.0, N_t = 0.83 (perpendicular to (2.0, 2.4))
    let n_end = (-1.0, 0.83)
    let nx_end = (-1.0, 0)

    // Ambient product coordinates.
    line((-2.2, 0), (2.7, 0), stroke: (paint: color_muted, thickness: 0.65pt), mark: (end: ">"))
    line((0, -1.7), (0, 1.75), stroke: (paint: color_muted, thickness: 0.65pt), mark: (end: ">"))
    content((2.85, 0), anchor: "west")[$x in M$]
    content((0, 1.92), anchor: "south")[$t in RR$]

    // Boundary hypersurface element.
    line(a, b, stroke: (paint: color_boundary, thickness: 2pt))
    content((1.15, 1.2), anchor: "west", text(fill: color_boundary)[$partial Omega$])
    content((1.15, 0.6), anchor: "west", text(fill: color_boundary)[$d S$])

    // Projections of the same boundary element (drawn directly on the axes).
    // Projection onto x-axis (spatial slice) -> omega = N_t d S
    line((a.at(0), 0), (b.at(0), 0), stroke: (paint: color_time, thickness: 1.6pt))
    line((a.at(0), a.at(1)), (a.at(0), 0), stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    line((b.at(0), b.at(1)), (b.at(0), 0), stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    content((0.5, -0.15), anchor: "north", text(fill: color_time)[$omega = N_t d S$])

    // Projection onto t-axis (time-cylinder) -> d S_t d t = ||N_x|| d S
    line((0, a.at(1)), (0, b.at(1)), stroke: (paint: color_space, thickness: 1.6pt))
    line((a.at(0), a.at(1)), (0, a.at(1)), stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    line((b.at(0), b.at(1)), (0, b.at(1)), stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    content((0.25, -0.8), anchor: "west", text(fill: color_space)[$d S_t d t = norm(N_x) d S$])

    // Normal and its decomposition.
    line(m, n_end, stroke: (paint: color_stroke, thickness: 1.1pt), mark: (end: ">"))
    line(m, nx_end, stroke: (paint: color_stroke, dash: "dotted", thickness: 0.85pt))
    line(nx_end, n_end, stroke: (paint: color_stroke, dash: "dotted", thickness: 0.85pt))
    
    content((n_end.at(0) - 0.15, n_end.at(1) + 0.05), anchor: "south-east", text(fill: color_stroke)[$N=(N_t,N_x)$])
    content((-0.6, -0.4), anchor: "south", text(fill: color_stroke)[$N_x$])
    content((nx_end.at(0) - 0.1, (nx_end.at(1) + n_end.at(1)) / 2), anchor: "east", text(fill: color_stroke)[$N_t$])

    circle(m, radius: 0.05, fill: color_stroke)
  })
}

#let finite-propagation-open-set-visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_protected = rgb("#dff4e8")
  let color_dike = rgb("#23845f")
  let color_wave = rgb("#d06a45")
  let color_initial = rgb("#4f6bd8")

  canvas(length: 0.95cm, {
    import draw: *

    // Ambient product coordinates.
    line((-4.35, 0), (4.45, 0), stroke: (paint: color_muted, thickness: 0.7pt), mark: (end: ">"))
    line((0, -0.45), (0, 3.05), stroke: (paint: color_muted, thickness: 0.7pt), mark: (end: ">"))
    content((4.6, 0), anchor: "west")[$x in M$]
    content((0, 3.22), anchor: "south")[$t$]
    content((-0.16, -0.25), anchor: "east")[$0$]

    // Initial zero interval cal(O).
    line((-3, 0), (3, 0), stroke: (paint: color_initial, thickness: 2pt))
    circle((-3, 0), radius: 0.06, fill: color_initial)
    circle((3, 0), radius: 0.06, fill: color_initial)
    content((0, -0.45), anchor: "north", text(fill: color_initial)[$cal(O)$ at $t=0$])
    content((-3, -0.25), anchor: "north", text(fill: color_initial)[$partial cal(O)$])
    content((3, -0.25), anchor: "north", text(fill: color_initial)[$partial cal(O)$])

    // The protected spacetime region. Its boundary is the finite-speed dike.
    line((-3, 0), (0, 2.55), (3, 0), (-3, 0), fill: color_protected, stroke: none)
    line((-3, 0), (0, 2.55), stroke: (paint: color_dike, thickness: 2.4pt))
    line((3, 0), (0, 2.55), stroke: (paint: color_dike, thickness: 2.4pt))
    content((0, 1.45), anchor: "center", text(fill: color_dike)[$cal(O)_t$])
    content((0, 0.84), anchor: "center", text(fill: color_dike, size: 9pt)[$u(t,x)=0$ is protected])

    // Short blocks make the slanted boundary read like a dike.
    line((-2.62, 0.32), (-2.24, 0.64), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((-2.02, 0.83), (-1.64, 1.15), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((-1.42, 1.34), (-1.04, 1.66), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((-0.82, 1.85), (-0.44, 2.17), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((2.62, 0.32), (2.24, 0.64), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((2.02, 0.83), (1.64, 1.15), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((1.42, 1.34), (1.04, 1.66), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))
    line((0.82, 1.85), (0.44, 2.17), stroke: (paint: color_dike.darken(15%), thickness: 0.75pt))

    // Left label near the dike boundary
    content((-0.5, 2.2), anchor: "south-east", text(fill: color_dike, size: 9pt)[
      dike boundary
    ])

    // Right label near the dike boundary
    content((0.5, 2.2), anchor: "south-west", text(fill: color_dike, size: 9pt)[
      $op("dist")_g (x, partial cal(O)) = t$
    ])

    // Incoming wave fronts from outside cal(O). They cannot enter the protected region.
    line((-4.15, 0.28), (-3.18, 0.78), stroke: (paint: color_wave, thickness: 1.1pt), mark: (end: ">"))
    line((-4.25, 0.78), (-2.72, 1.30), stroke: (paint: color_wave, thickness: 1.1pt), mark: (end: ">"))
    line((-4.0, 1.34), (-2.16, 1.86), stroke: (paint: color_wave, thickness: 1.1pt), mark: (end: ">"))
    content((-5, 1.9), anchor: "west", text(fill: color_wave, size: 9pt)[incoming wave \ $u eq.not 0$])

    line((4.15, 0.28), (3.18, 0.78), stroke: (paint: color_wave, thickness: 1.1pt), mark: (end: ">"))
    line((4.25, 0.78), (2.72, 1.30), stroke: (paint: color_wave, thickness: 1.1pt), mark: (end: ">"))
    line((4.0, 1.34), (2.16, 1.86), stroke: (paint: color_wave, thickness: 1.1pt), mark: (end: ">"))

    // A fixed time slice makes cal(O)_t visible as the surviving protected interval.
    line((-2.05, 1.15), (2.05, 1.15), stroke: (paint: color_muted, dash: "dashed", thickness: 0.6pt))
    line((-1.65, 1.15), (1.65, 1.15), stroke: (paint: color_dike, thickness: 1.3pt))
    content((1.7, 1.4), anchor: "west", text(size: 9pt)[$t$-slice])
  })
}
