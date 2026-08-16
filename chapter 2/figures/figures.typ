#import "@preview/cetz:0.4.2": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../Styles/styles.typ": theme-from-text-fill

#let first-isomorphism-factorization-diagram() = context {
  let theme = theme-from-text-fill()

  diagram(
    cell-size: 18mm,
    edge-stroke: 0.8pt + theme.rule,
    $
      V times.o V edge(hat(omega), ->) edge("d", pi, ->>) & bb(F) \
      Lambda^2 V edge("ur", tilde(omega), ->)
    $,
  )
}

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

#let swept-hyperbolic-region-visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_domain = rgb("#edf2ff")
  let color_truncated = rgb("#dff4e8")
  let color_sigma_one = rgb("#2f8f6b")
  let color_sigma_two = rgb("#5b6ee1")
  let color_slice = rgb("#d06a45")

  canvas(length: 0.9cm, {
    import draw: *

    let left = (-3.2, -1.25)
    let right = (3.2, 0.72)
    let lower_c1 = (-2.15, -1.85)
    let lower_c2 = (1.55, -0.65)
    let upper_c1 = (-2.15, 1.35)
    let upper_c2 = (2.0, 2.05)
    let slice_right = (2.65, 0.32)
    let slice_c1 = (-1.15, 0.15)
    let slice_c2 = (1.2, 0.52)
    let s_y = 0.32

    // Ambient product coordinates.
    line((-3.75, -2.0), (3.95, -2.0), stroke: (paint: color_muted, thickness: 0.7pt), mark: (end: ">"))
    line((-3.75, -2.0), (-3.75, 2.45), stroke: (paint: color_muted, thickness: 0.7pt), mark: (end: ">"))
    content((4.1, -2.0), anchor: "west")[$M$]
    content((-3.75, 2.62), anchor: "south")[$t$]
    content((-3.93, s_y), anchor: "east", text(size: 8.5pt)[$s$])
    line((-3.75, s_y), (3.45, s_y), stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))

    // The full swept region dash(cal(O)).
    bezier(left, right, lower_c1, lower_c2, fill: color_domain, stroke: none)
    bezier(left, right, upper_c1, upper_c2, fill: color_domain, stroke: none)

    // The truncated part cal(O)(s), bounded above by Sigma_2(s).
    bezier(left, slice_right, lower_c1, (0.65, -0.72), fill: color_truncated, stroke: none)
    bezier(left, slice_right, slice_c1, slice_c2, fill: color_truncated, stroke: none)
    bezier(left, slice_right, slice_c1, slice_c2, stroke: (paint: color_slice, thickness: 1.7pt))

    // Full boundary pieces.
    bezier(left, right, lower_c1, lower_c2, stroke: (paint: color_sigma_one, thickness: 1.25pt))
    bezier(left, right, upper_c1, upper_c2, stroke: (paint: color_sigma_two, thickness: 1.7pt))

    // The part of Sigma_1 lying below the time level s.
    bezier(left, slice_right, lower_c1, (0.65, -0.72), stroke: (paint: color_sigma_one, thickness: 2.2pt))

    // Vertical cut marker indicates intersection with {t <= s}.
    line((slice_right.at(0), -2.0), slice_right, stroke: (paint: color_muted, dash: "dashed", thickness: 0.55pt))
    circle(slice_right, radius: 0.045, fill: color_slice)

    // Labels.
    content((0.05, -0.4), anchor: "center", text(fill: color_sigma_one)[$cal(O)(s)$])
    content((-0.05, 1.6), anchor: "center", text(fill: color_sigma_two)[$cal(O)$])
    content((2.75, 1.3), anchor: "west", text(fill: color_sigma_two)[$Sigma_2$])
    content((2.8, 0), anchor: "west", text(fill: color_slice)[$Sigma_2(s)=dash(cal(O)) inter {t=s}$])
    content((-3.08, -1.42), anchor: "north-east", text(fill: color_sigma_one)[$Sigma_1$])
    content((0.3, -1.55), anchor: "north", text(fill: color_sigma_one, size: 9pt)[$Sigma_1^b (s)=Sigma_1 inter {t <= s}$])
  })
}

#let stress-energy-normal-fields-visualization() = context {
  let theme = theme-from-text-fill()
  let color_stroke = theme.text
  let color_muted = theme.muted-text
  let color_sigma_one = rgb("#2f8f6b")
  let color_slice = rgb("#d06a45")
  let color_timelike = rgb("#5b6ee1")
  let color_choice = rgb("#c64b45")

  canvas(length: 0.9cm, {
    import draw: *

    let sigma_one_left = (-3.05, -1.05)
    let sigma_one_right = (2.55, -0.18)
    let sigma_two_left = (-2.7, 0.85)
    let sigma_two_right = (2.8, 0.85)
    let p = (-0.95, -0.72)
    let q = (-0.2, 0.85)

    // Ambient product coordinates.
    line((-3.55, -1.65), (3.35, -1.65), stroke: (paint: color_muted, thickness: 0.7pt), mark: (end: ">"))
    line((-3.55, -1.65), (-3.55, 2.05), stroke: (paint: color_muted, thickness: 0.7pt), mark: (end: ">"))
    content((3.5, -1.65), anchor: "west")[$M$]
    content((-3.55, 2.22), anchor: "south")[$t$]

    // The two hypersurfaces from the flux identity.
    bezier(sigma_one_left, sigma_one_right, (-2.0, -1.55), (0.85, -1.12), stroke: (paint: color_sigma_one, thickness: 1.9pt))
    line(sigma_two_left, sigma_two_right, stroke: (paint: color_slice, thickness: 1.8pt))
    content((-2.9, -0.72), anchor: "east", text(fill: color_sigma_one)[$Sigma_1$])
    content((2.95, 1.02), anchor: "west", text(fill: color_slice)[$Sigma_2(s)={t=s}$])

    // Forward-pointing unit normal on Sigma_1.
    circle(p, radius: 0.045, fill: color_sigma_one)
    line(p, (p.at(0) - 0.45, p.at(1) + 0.92), stroke: (paint: color_sigma_one, thickness: 1.3pt), mark: (end: ">"))
    content((p.at(0) - 0.62, p.at(1) + 0.88), anchor: "south-east", text(fill: color_sigma_one)[$nu_1$])
    content((p.at(0) - 0.92, p.at(1) + 0.38), anchor: "east", text(size: 8pt, fill: color_sigma_one)[forward unit normal])

    // grad t is normal to the level surface, and nu_2 is its normalization.
    circle(q, radius: 0.045, fill: color_slice)
    line(q, (q.at(0), q.at(1) + 0.9), stroke: (paint: color_choice, thickness: 1.35pt), mark: (end: ">"))
    content((q.at(0) + 0.16, q.at(1) + 0.8), anchor: "west", text(fill: color_choice)[$nu_2 = op("grad") t / norm(op("grad") t)$])
    content((q.at(0) + 0.15, q.at(1) - 0.28), anchor: "north-west", text(size: 8pt, fill: color_slice)[$d t$ timelike])

    // Timelike choices for Z; the energy estimate later chooses Z=nu_2.
    line((2.0, -1.08), (2.0, 0.62), stroke: (paint: color_muted, dash: "dotted", thickness: 0.6pt))
    line((1.55, -0.72), (2.0, 0.36), (2.45, -0.72), (1.55, -0.72), fill: color_timelike.lighten(62%), stroke: (paint: color_timelike, thickness: 0.75pt))
    content((2.0, -0.85), anchor: "north", text(size: 8pt, fill: color_timelike)[timelike cone])
    line((2.0, -0.5), (1.78, 0.18), stroke: (paint: color_timelike, thickness: 1.1pt), mark: (end: ">"))
    content((1.68, 0.2), anchor: "south-east", text(fill: color_timelike)[$Z$])
    line((2.0, -0.5), (2.0, 0.28), stroke: (paint: color_choice, thickness: 1.35pt), mark: (end: ">"))
    content((2.18, -0.04), anchor: "west", text(fill: color_choice)[choose $Z=nu_2$])
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

#let divergence-flow-comparison-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let expansion = rgb("#2f8f6b")
  let rotation = rgb("#5b6ee1")

  canvas(length: 0.72cm, {
    import draw: *

    let draw-axes = (x0) => {
      line((x0 - 1.85, 0), (x0 + 1.85, 0), stroke: (paint: muted, thickness: 0.55pt), mark: (end: ">"))
      line((x0, -1.45), (x0, 1.55), stroke: (paint: muted, thickness: 0.55pt), mark: (end: ">"))
      content((x0 + 1.98, 0), anchor: "west", text(size: 8pt)[$x$])
      content((x0, 1.72), anchor: "south", text(size: 8pt)[$y$])
    }

    draw-axes(-2.35)
    rect((-2.72, -0.37), (-1.98, 0.37), stroke: (paint: stroke-color, thickness: 0.75pt), fill: rgb("#dff4e8"))
    rect((-2.91, -0.56), (-1.79, 0.56), stroke: (paint: expansion, dash: "dashed", thickness: 0.85pt))
    for p in ((-3.2, -0.9), (-3.2, 0), (-3.2, 0.9), (-2.35, -0.9), (-2.35, 0.9), (-1.5, -0.9), (-1.5, 0), (-1.5, 0.9)) {
      let dx = p.at(0) + 2.35
      let dy = p.at(1)
      line(p, (p.at(0) + 0.28 * dx, p.at(1) + 0.28 * dy), stroke: (paint: expansion, thickness: 0.85pt), mark: (end: ">"))
    }
    content((-2.35, -1.7), anchor: "south", text(size: 8.5pt)[$X=(x,y), quad op("div") X=2$])

    draw-axes(2.35)
    rect((1.98, -0.37), (2.72, 0.37), stroke: (paint: stroke-color, thickness: 0.75pt), fill: rgb("#eef1ff"))
    line((1.77, -0.18), (2.17, -0.58), (2.93, 0.18), (2.53, 0.58), close: true, stroke: (paint: rotation, dash: "dashed", thickness: 0.85pt))
    for p in ((1.5, -0.9), (1.5, 0), (1.5, 0.9), (2.35, -0.9), (2.35, 0.9), (3.2, -0.9), (3.2, 0), (3.2, 0.9)) {
      let dx = p.at(0) - 2.35
      let dy = p.at(1)
      line(p, (p.at(0) - 0.24 * dy, p.at(1) + 0.24 * dx), stroke: (paint: rotation, thickness: 0.85pt), mark: (end: ">"))
    }
    content((2.35, -1.7), anchor: "south", text(size: 8.5pt)[$X=(-y,x), quad op("div") X=0$])
  })
}

#let divergence-matrix-trace-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let diag = rgb("#d06a45")
  let offdiag = rgb("#5b6ee1")

  canvas(length: 0.70cm, {
    import draw: *

    content((-3.25, 0.95), anchor: "west", text(size: 9pt)[$(nabla_j X^k) =$])
    rect((-1.45, -1.05), (1.05, 1.05), stroke: (paint: stroke-color, thickness: 0.75pt))
    line((-0.2, -1.05), (-0.2, 1.05), stroke: (paint: muted, thickness: 0.45pt))
    line((-1.45, 0), (1.05, 0), stroke: (paint: muted, thickness: 0.45pt))

    rect((-1.36, 0.09), (-0.29, 0.96), fill: rgb("#fff0e8"), stroke: (paint: diag, thickness: 0.8pt))
    rect((-0.11, -0.96), (0.96, -0.09), fill: rgb("#fff0e8"), stroke: (paint: diag, thickness: 0.8pt))
    rect((-0.11, 0.09), (0.96, 0.96), fill: rgb("#eef1ff"), stroke: (paint: offdiag, thickness: 0.55pt))
    rect((-1.36, -0.96), (-0.29, -0.09), fill: rgb("#eef1ff"), stroke: (paint: offdiag, thickness: 0.55pt))

    content((-0.82, 0.55), text(size: 8pt)[$nabla_1 X^1$])
    content((0.42, 0.55), text(size: 8pt)[$nabla_2 X^1$])
    content((-0.82, -0.55), text(size: 8pt)[$nabla_1 X^2$])
    content((0.42, -0.55), text(size: 8pt)[$nabla_2 X^2$])

    line((1.55, 0.45), (2.25, 0.45), stroke: (paint: diag, thickness: 0.8pt), mark: (end: ">"))
    content((2.45, 0.45), anchor: "west", text(fill: diag, size: 9pt)[$op("tr")(nabla X)=nabla_j X^j$])
    content((1.55, -0.45), anchor: "west", text(fill: offdiag, size: 8pt)[$j != k: "shear/rotation"$])
  })
}

#let volume-jacobian-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let flow = rgb("#2f8f6b")

  canvas(length: 0.68cm, {
    import draw: *

    rect((-3.15, -0.52), (-2.15, 0.52), fill: rgb("#dff4e8"), stroke: (paint: stroke-color, thickness: 0.75pt))
    content((-2.65, -0.8), anchor: "north", text(size: 8.5pt)[$d V$])
    line((-1.68, 0), (-0.56, 0), stroke: (paint: stroke-color, thickness: 0.85pt), mark: (end: ">"))
    content((-1.12, 0.32), anchor: "south", text(size: 8.5pt)[$Phi_t$])
    line((-0.05, -0.58), (1.18, -0.42), (0.98, 0.68), (-0.25, 0.52), close: true, fill: rgb("#edf8f1"), stroke: (paint: flow, thickness: 0.85pt))
    content((0.46, -0.88), anchor: "north", text(size: 8.5pt)[$det(D Phi_t) d V$])
    content((2.0, 0.18), anchor: "west", text(size: 9pt)[$D Phi_t = I + t nabla X + O(t^2)$])
    content((2.0, -0.45), anchor: "west", text(size: 9pt)[$det(D Phi_t) = 1 + t op("div") X + O(t^2)$])
  })
}

#let wave-operator-packaging-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let time-bg = theme.callouts.warning.bg
  let time-stroke = theme.callouts.warning.border
  let space-bg = theme.callouts.proposition.bg
  let space-stroke = theme.callouts.proposition.border
  let unified-bg = theme.callouts.important.bg
  let unified-stroke = theme.callouts.important.border

  canvas(length: 0.7cm, {
    import draw: *

    // Left Box: Time Component
    rect((-5.0, 0.4), (-1.0, 3.2), fill: time-bg, stroke: (paint: time-stroke, thickness: 1.2pt), radius: 0.15)
    content((-3.0, 1.8), anchor: "center", stack(
      spacing: 3pt,
      align(center, text(weight: "bold", size: 10pt, fill: time-stroke)[Time Component]),
      align(center, text(size: 9pt)[Metric: $-d t^2$]),
      align(center, text(size: 9pt)[Operator: $frac(partial^2, partial t^2)$])
    ))

    // Right Box: Spatial Component
    rect((1.0, 0.4), (5.0, 3.2), fill: space-bg, stroke: (paint: space-stroke, thickness: 1.2pt), radius: 0.15)
    content((3.0, 1.8), anchor: "center", stack(
      spacing: 3pt,
      align(center, text(weight: "bold", size: 10pt, fill: space-stroke)[Spatial Component]),
      align(center, text(size: 9pt)[Metric: $g$]),
      align(center, text(size: 9pt)[Operator: $- Delta_g$])
    ))

    // Bottom Box: Unified Lorentzian Spacetime
    rect((-4.5, -3.0), (4.5, -0.2), fill: unified-bg, stroke: (paint: unified-stroke, thickness: 1.5pt), radius: 0.15)
    content((0, -1.6), anchor: "center", stack(
      spacing: 4pt,
      align(center, text(weight: "bold", size: 10.5pt, fill: unified-stroke)[Unified Lorentz Manifold $(cal(M), h)$]),
      align(center, text(size: 9.5pt)[Metric: $h = -d t^2 + g$]),
      align(center, text(size: 9.5pt)[Wave Operator: $square_h = frac(partial^2, partial t^2) - Delta_g$])
    ))

    // Connecting arrows
    line((-3.0, 0.4), (-1.5, -0.2), stroke: (paint: time-stroke, thickness: 1.2pt), mark: (end: ">"))
    line((3.0, 0.4), (1.5, -0.2), stroke: (paint: space-stroke, thickness: 1.2pt), mark: (end: ">"))
    
    // Label for packaging on the arrows
    content((-2.7, 0.1), text(size: 8.5pt, fill: muted, style: "italic")[packages], anchor: "east")
    content((2.7, 0.1), text(size: 8.5pt, fill: muted, style: "italic")[packages], anchor: "west")
  })
}

#let stress-energy-tensor-name-diagram() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let action-bg = theme.callouts.note.bg
  let action-stroke = theme.callouts.note.border
  let stress-bg = theme.callouts.warning.bg
  let stress-stroke = theme.callouts.warning.border
  let energy-bg = theme.callouts.proposition.bg
  let energy-stroke = theme.callouts.proposition.border
  let tensor-bg = theme.callouts.important.bg
  let tensor-stroke = theme.callouts.important.border

  canvas(length: 0.68cm, {
    import draw: *

    rect((-5.35, 0.75), (-1.45, 3.05), fill: action-bg, stroke: (paint: action-stroke, thickness: 1.1pt), radius: 0.12)
    content((-3.4, 1.9), anchor: "center", stack(
      spacing: 3pt,
      align(center, text(weight: "bold", size: 9.5pt, fill: action-stroke)[Metric variation]),
      align(center, text(size: 8.5pt)[$delta_h S$]),
      align(center, text(size: 8.5pt)[$T_(a b) delta h^(a b)$])
    ))

    rect((-5.35, -2.65), (-1.45, -0.35), fill: stress-bg, stroke: (paint: stress-stroke, thickness: 1.1pt), radius: 0.12)
    content((-3.4, -1.5), anchor: "center", stack(
      spacing: 3pt,
      align(center, text(weight: "bold", size: 9.5pt, fill: stress-stroke)[Stress part]),
      align(center, text(size: 8.5pt)[$T_(i j)$]),
      align(center, text(size: 8.3pt)[spatial flux of momentum])
    ))

    rect((1.45, -2.65), (5.35, -0.35), fill: energy-bg, stroke: (paint: energy-stroke, thickness: 1.1pt), radius: 0.12)
    content((3.4, -1.5), anchor: "center", stack(
      spacing: 3pt,
      align(center, text(weight: "bold", size: 9.5pt, fill: energy-stroke)[Energy part]),
      align(center, text(size: 8.5pt)[$T_(0 0), T_(0 i)$]),
      align(center, text(size: 8.3pt)[density and flow])
    ))

    rect((1.15, 0.75), (5.65, 3.05), fill: tensor-bg, stroke: (paint: tensor-stroke, thickness: 1.25pt), radius: 0.12)
    content((3.4, 1.9), anchor: "center", stack(
      spacing: 2.5pt,
      align(center, text(weight: "bold", size: 9.6pt, fill: tensor-stroke)[Stress-energy tensor]),
      align(center, text(size: 8.2pt)[$T = d u times.o d u$]),
      align(center, text(size: 8.2pt)[$- frac(1,2) chevron.l d u comma d u chevron.r_h h$]),
      align(center, text(size: 8.3pt)[one geometric object])
    ))

    line((-1.45, 1.9), (1.15, 1.9), stroke: (paint: stroke-color, thickness: 0.9pt), mark: (end: ">"))
    content((-0.15, 2.16), anchor: "south", text(size: 8pt, fill: muted)[coefficient])

    line((-2.6, -0.35), (1.65, 0.75), stroke: (paint: stress-stroke, thickness: 0.85pt), mark: (end: ">"))
    line((2.6, -0.35), (3.05, 0.75), stroke: (paint: energy-stroke, thickness: 0.85pt), mark: (end: ">"))
    content((-0.6, 0.8), anchor: "south", text(size: 8pt, fill: muted)[spatial components])
    content((3.5, 0.2), anchor: "west", text(size: 8pt, fill: muted)[time components])
  })
}

#let killing-field-visualization() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let killing-color = rgb("#24734f")
  let orbit-color = theme.rule

  canvas(length: 0.78cm, {
    import draw: *

    // Integral curves of X(x,y)=(-y,x) are concentric circles.
    circle(
      (0, 0),
      radius: 1.05,
      stroke: (paint: orbit-color, thickness: 0.65pt, dash: "dashed"),
    )
    circle(
      (0, 0),
      radius: 2.05,
      stroke: (paint: orbit-color, thickness: 0.65pt, dash: "dashed"),
    )

    // Coordinate axes.
    line(
      (-2.8, 0),
      (2.8, 0),
      stroke: (paint: muted, thickness: 0.65pt),
      mark: (end: ">"),
    )
    line(
      (0, -2.8),
      (0, 2.8),
      stroke: (paint: muted, thickness: 0.65pt),
      mark: (end: ">"),
    )
    content((2.95, 0), anchor: "west", text(size: 8pt, fill: muted)[$x$])
    content((0, 2.95), anchor: "south", text(size: 8pt, fill: muted)[$y$])

    // At (x,y), the vector (-y,x) is perpendicular to the radius (x,y).
    // Therefore every arrow is tangent to a circular symmetry orbit.
    for x in (-2, -1, 0, 1, 2) {
      for y in (-2, -1, 0, 1, 2) {
        let px = 0.92 * x
        let py = 0.92 * y

        if x == 0 and y == 0 {
          circle((0, 0), radius: 0.055, fill: stroke-color)
        } else {
          let dx = -0.26 * y
          let dy = 0.26 * x

          line(
            (px - dx / 2, py - dy / 2),
            (px + dx / 2, py + dy / 2),
            stroke: (paint: killing-color, thickness: 1.15pt),
            mark: (end: ">"),
          )
        }
      }
    }

    // Highlight one radius and its tangent vector.
    line(
      (0, 0),
      (1.84, 0),
      stroke: (paint: stroke-color, thickness: 0.8pt),
    )
    content((0.92, -0.18), anchor: "north", text(size: 8pt)[$r$])
    content((2.05, 0.48), anchor: "west", text(size: 8pt, fill: killing-color)[$X perp r$])

    content(
      (0, 3.45),
      anchor: "center",
      text(weight: "bold", size: 10pt)[
        Rotational Killing field
      ],
    )
    content(
      (0, -3.25),
      anchor: "center",
      text(size: 9pt)[$X(x,y)=(-y,x)$],
    )
    content(
      (0, -3.7),
      anchor: "center",
      text(size: 8.3pt, fill: muted)[the flow rotates every point without stretching],
    )
  })
}

#let divergence-free-non-killing-visualization() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text

  let field-color = rgb("#3157c8")
  let deformation-color = rgb("#c43d3d")

  canvas(length: 0.76cm, {
    import draw: *

    content(
      (0, 3.25),
      anchor: "center",
      text(weight: "bold", size: 10pt)[
        Divergence-free does not imply Killing
      ],
    )

    // Coordinate axes.
    line(
      (-2.8, 0),
      (2.8, 0),
      stroke: (paint: muted, thickness: 0.65pt),
      mark: (end: ">"),
    )
    line(
      (0, -2.65),
      (0, 2.65),
      stroke: (paint: muted, thickness: 0.65pt),
      mark: (end: ">"),
    )
    content((2.95, 0), anchor: "west", text(size: 8pt, fill: muted)[$x$])
    content((0, 2.8), anchor: "south", text(size: 8pt, fill: muted)[$y$])

    // The dashed circle is a small material neighborhood before the flow.
    circle(
      (0, 0),
      radius: 1.2,
      stroke: (paint: stroke-color, thickness: 0.8pt, dash: "dashed"),
    )

    // Under phi_t(x,y)=(e^t x,e^(-t)y), the circle becomes an ellipse.
    // The product of the two scale factors is one, so its area is unchanged.
    group({
      scale(x: 1.5, y: 2 / 3)
      circle(
        (0, 0),
        radius: 1.2,
        stroke: (paint: deformation-color, thickness: 1.1pt),
      )
    })

    // Arrow field X(x,y)=(x,-y): horizontal expansion and vertical compression.
    for x in (-2, -1, 0, 1, 2) {
      for y in (-2, -1, 0, 1, 2) {
        let px = 0.9 * x
        let py = 0.9 * y

        if x == 0 and y == 0 {
          circle((0, 0), radius: 0.055, fill: stroke-color)
        } else {
          let dx = 0.23 * x
          let dy = -0.23 * y

          line(
            (px - dx / 2, py - dy / 2),
            (px + dx / 2, py + dy / 2),
            stroke: (paint: field-color, thickness: 1.1pt),
            mark: (end: ">"),
          )
        }
      }
    }

    content(
      (0, -3.05),
      anchor: "center",
      text(size: 9pt)[$X(x,y)=(x,-y)$],
    )
    content(
      (0, -3.48),
      anchor: "center",
      text(size: 8.3pt, fill: muted)[
        horizontal expansion cancels vertical compression
      ],
    )

    line(
      (-2.65, -2.45),
      (-2.0, -2.45),
      stroke: (paint: stroke-color, thickness: 0.8pt, dash: "dashed"),
    )
    content((-1.88, -2.45), anchor: "west", text(size: 7.8pt, fill: muted)[initial circle])
    line(
      (0.65, -2.45),
      (1.3, -2.45),
      stroke: (paint: deformation-color, thickness: 1.1pt),
    )
    content((1.42, -2.45), anchor: "west", text(size: 7.8pt, fill: muted)[equal-area ellipse])
  })
}

#let quadratic-potential-energy-density-visualization() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let domain-fill = theme.callouts.note.bg
  let domain-stroke = theme.callouts.note.border
  let trace-fill = theme.callouts.proposition.bg
  let trace-stroke = theme.callouts.proposition.border
  let scalar-fill = theme.callouts.important.bg
  let scalar-stroke = theme.callouts.important.border
  let basis-color = rgb("#3157c8")
  let image-color = rgb("#c64b45")

  canvas(length: 0.78cm, {
    import draw: *

    rect(
      (-5.2, -1.55),
      (-1.75, 1.65),
      radius: 0.12,
      fill: domain-fill,
      stroke: (paint: domain-stroke, thickness: 0.9pt),
    )
    content((-3.48, 1.35), anchor: "center", text(weight: "bold", size: 9pt)[$A:T_x M arrow.r T_y N$])
    content((-3.48, 0.93), anchor: "center", text(size: 8pt, fill: muted)[$(e_1,dots,e_n)$ orthonormal])

    line((-4.55, -0.72), (-4.55, 0.12), stroke: (paint: basis-color, thickness: 1.15pt), mark: (end: ">"))
    line((-4.55, -0.72), (-3.72, -0.28), stroke: (paint: basis-color, thickness: 1.15pt), mark: (end: ">"))
    content((-4.62, 0.2), anchor: "south", text(size: 7.5pt, fill: basis-color)[$e_1$])
    content((-3.62, -0.23), anchor: "west", text(size: 7.5pt, fill: basis-color)[$e_2$])

    line((-2.85, -0.72), (-2.85, 0.28), stroke: (paint: image-color, thickness: 1.35pt), mark: (end: ">"))
    line((-2.85, -0.72), (-2.12, -0.12), stroke: (paint: image-color, thickness: 1.35pt), mark: (end: ">"))
    content((-2.92, 0.36), anchor: "south", text(size: 7.5pt, fill: image-color)[$A e_1$])
    content((-2.08, -0.18), anchor: "east", text(size: 7.5pt, fill: image-color)[$A e_2$])

    rect(
      (-0.95, -1.55),
      (2.25, 1.65),
      radius: 0.12,
      fill: trace-fill,
      stroke: (paint: trace-stroke, thickness: 0.9pt),
    )
    content((0.65, 1.32), anchor: "center", text(weight: "bold", size: 9pt)[take the trace])
    content((0.65, 0.55), anchor: "center", text(size: 9pt)[$op("Tr")(A^*A)$])
    content((0.65, 0.0), anchor: "center", text(size: 9pt)[$=sum_i norm(A e_i)^2_h$])
    content(
      (0.65, -0.67),
      anchor: "center",
      stack(
        spacing: 1pt,
        align(center, text(size: 7.2pt, fill: muted)[all directions]),
        align(center, text(size: 7.2pt, fill: muted)[one scalar]),
      ),
    )

    rect(
      (3.05, -1.55),
      (5.55, 1.65),
      radius: 0.12,
      fill: scalar-fill,
      stroke: (paint: scalar-stroke, thickness: 0.95pt),
    )
    content((4.3, 1.32), anchor: "center", text(weight: "bold", size: 9pt)[$N=bb(R)$])
    content((4.3, 0.72), anchor: "center", text(size: 8.5pt)[$A=xi=d_x u$])
    content((4.3, 0.13), anchor: "center", text(size: 8.5pt)[$sum_i xi(e_i)^2$])
    content((4.3, -0.38), anchor: "center", text(size: 8.5pt)[$=g^(j k)xi_j xi_k$])
    content((4.3, -0.95), anchor: "center", text(size: 8.5pt, fill: scalar-stroke)[$f_Q=gamma norm(xi)^2_(g^(-1))$])

    line((-1.75, 0.05), (-0.95, 0.05), stroke: (paint: stroke-color, thickness: 0.85pt), mark: (end: ">"))
    line((2.25, 0.05), (3.05, 0.05), stroke: (paint: stroke-color, thickness: 0.85pt), mark: (end: ">"))

    content(
      (0.15, -2.05),
      anchor: "center",
      text(size: 8.5pt, fill: muted)[
        coordinate independent $quad dot quad$ nonnegative $quad dot quad$ zero exactly when $d_x u=0$
      ],
    )
  })
}

#let gronwall-convolution-visualization() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let kernel-color = rgb("#3157c8")
  let forcing-color = rgb("#c64b45")
  let result-fill = theme.callouts.note.bg
  let result-stroke = theme.callouts.note.border

  canvas(length: 0.78cm, {
    import draw: *

    content(
      (0, 2.35),
      anchor: "center",
      text(weight: "bold", size: 10pt)[
        Gronwall estimate as causal convolution
      ],
    )

    // Left panel: forcing history on [s_0,s].
    line((-5.2, -1.35), (-1.15, -1.35), stroke: (paint: muted, thickness: 0.7pt), mark: (end: ">"))
    line((-5.0, -1.55), (-5.0, 1.55), stroke: (paint: muted, thickness: 0.7pt), mark: (end: ">"))
    content((-5.0, -1.75), anchor: "north", text(size: 8pt, fill: muted)[$s_0$])
    content((-1.25, -1.75), anchor: "north", text(size: 8pt, fill: muted)[$s$])
    content((-3.1, 1.55), anchor: "center", text(size: 8.5pt, fill: forcing-color)[$cal(F)(r)$])

    for x in (-4.65, -4.15, -3.55, -2.95, -2.45, -1.85) {
      let h = 0.55 + 0.28 * calc.sin((x + 4.8) * 150deg)
      line((x, -1.35), (x, -1.35 + h), stroke: (paint: forcing-color, thickness: 1.35pt))
      circle((x, -1.35 + h), radius: 0.045, fill: forcing-color)
    }

    // Middle panel: kernel viewed backward from the observation time s.
    line((-0.35, -1.35), (3.65, -1.35), stroke: (paint: muted, thickness: 0.7pt), mark: (end: ">"))
    line((-0.15, -1.55), (-0.15, 1.55), stroke: (paint: muted, thickness: 0.7pt), mark: (end: ">"))
    content((3.25, -1.75), anchor: "north", text(size: 8pt, fill: muted)[$r$])
    content((1.75, 1.55), anchor: "center", text(size: 8.5pt, fill: kernel-color)[$G_s (r)=e^(frak(C)(s-r))$])

    bezier(
      (-0.15, 1.18),
      (3.35, -0.92),
      (0.75, 0.62),
      (2.15, -0.58),
      stroke: (paint: kernel-color, thickness: 1.35pt),
    )
    content((-0.15, -1.75), anchor: "north", text(size: 8pt, fill: muted)[$s_0$])
    content((3.35, -1.75), anchor: "north", text(size: 8pt, fill: muted)[$s$])

    // Output panel: weighted accumulation.
    rect(
      (4.25, -1.35),
      (7.05, 1.35),
      radius: 0.12,
      fill: result-fill,
      stroke: (paint: result-stroke, thickness: 0.9pt),
    )
    content((5.65, 0.58), anchor: "center", text(size: 9pt)[$(G * cal(F))(s)$])
    content((5.65, -0.04), anchor: "center", text(size: 8.4pt)[weighted history])
    content((5.65, -0.68), anchor: "center", text(size: 8.4pt, fill: result-stroke)[$E(s) <= "output"$])

    line((-1.05, 0.0), (-0.45, 0.0), stroke: (paint: stroke-color, thickness: 0.85pt), mark: (end: ">"))
    line((3.75, 0.0), (4.15, 0.0), stroke: (paint: stroke-color, thickness: 0.85pt), mark: (end: ">"))

    content((1.25, -2.25), anchor: "center", text(size: 8.2pt, fill: muted)[older forcing is weighted by the propagation factor from $r$ to $s$])
  })
}

#let maxwell-source-domain-comparison() = context {
  let theme = theme-from-text-fill()
  let stroke-color = theme.text
  let muted = theme.muted-text
  let domain-fill = theme.callouts.proposition.bg
  let domain-stroke = theme.callouts.proposition.border
  let source-fill = theme.callouts.warning.bg
  let source-stroke = theme.callouts.warning.border
  let field-stroke = theme.callouts.tip.border

  canvas(length: 0.72cm, {
    import draw: *

    // Panel headings and separator.
    content(
      (-3.65, 2.35),
      anchor: "center",
      text(weight: "bold", size: 9.5pt)[Source inside $U$],
    )
    content(
      (3.75, 2.35),
      anchor: "center",
      text(weight: "bold", size: 9.5pt)[Source outside $U$],
    )
    line(
      (0, -2.35),
      (0, 2.1),
      stroke: (paint: theme.rule, thickness: 0.6pt, dash: "dashed"),
    )

    // Left panel: U intersects the support of the charge-current.
    rect(
      (-6.2, -1.35),
      (-1.15, 1.75),
      radius: 0.22,
      fill: domain-fill,
      stroke: (paint: domain-stroke, thickness: 1.1pt, dash: "dashed"),
    )
    content((-5.85, 1.48), anchor: "west", text(fill: domain-stroke)[$U$])

    circle(
      (-3.65, 0.18),
      radius: 0.62,
      fill: source-fill,
      stroke: (paint: source-stroke, thickness: 1pt),
    )
    content((-3.65, 0.3), anchor: "center", text(fill: source-stroke, size: 12pt)[$+$])
    line(
      (-4.05, -0.18),
      (-3.12, 0.65),
      stroke: (paint: source-stroke, thickness: 1.15pt),
      mark: (end: ">"),
    )
    content((-3.0, 0.72), anchor: "west", text(fill: source-stroke, size: 8.5pt)[$cal(J)$])
    content((-3.65, -0.66), anchor: "north", text(fill: source-stroke, size: 8pt)[$op("supp") cal(J)$])

    content(
      (-3.65, -1.68),
      anchor: "north",
      text(size: 8.4pt)[$U inter op("supp") cal(J) eq.not emptyset$],
    )
    content(
      (-3.65, -2.08),
      anchor: "north",
      text(size: 8.4pt, fill: source-stroke)[$d_(h)^(*)cal(F)=4 pi cal(J)^(flat)$],
    )

    // Right panel: the source is outside U, but its field can enter U.
    rect(
      (2.05, -1.35),
      (6.25, 1.75),
      radius: 0.22,
      fill: domain-fill,
      stroke: (paint: domain-stroke, thickness: 1.1pt, dash: "dashed"),
    )
    content((5.9, 1.48), anchor: "east", text(fill: domain-stroke)[$U$])

    circle(
      (1.05, 0.18),
      radius: 0.58,
      fill: source-fill,
      stroke: (paint: source-stroke, thickness: 1pt),
    )
    content((1.05, 0.3), anchor: "center", text(fill: source-stroke, size: 12pt)[$+$])
    line(
      (0.72, -0.18),
      (1.47, 0.58),
      stroke: (paint: source-stroke, thickness: 1.1pt),
      mark: (end: ">"),
    )
    content((0.82, -0.62), anchor: "north", text(fill: source-stroke, size: 7.8pt)[$op("supp") cal(J)$])

    // Representative field lines cross partial U even though no source lies in U.
    bezier(
      (1.58, 0.52),
      (4.15, 1.08),
      (2.35, 1.22),
      (3.15, 1.3),
      stroke: (paint: field-stroke, thickness: 1pt),
      mark: (end: ">"),
    )
    bezier(
      (1.65, 0.18),
      (4.55, 0.18),
      (2.55, 0.5),
      (3.55, 0.5),
      stroke: (paint: field-stroke, thickness: 1pt),
      mark: (end: ">"),
    )
    bezier(
      (1.58, -0.16),
      (4.15, -0.72),
      (2.35, -0.86),
      (3.15, -0.94),
      stroke: (paint: field-stroke, thickness: 1pt),
      mark: (end: ">"),
    )
    content((4.72, 0.72), anchor: "west", text(fill: field-stroke, size: 8.3pt)[$cal(F)|_U eq.not 0$])
    content((4.72, 0.34), anchor: "west", text(fill: muted, size: 7.7pt)[is possible])

    content(
      (4.15, -1.68),
      anchor: "north",
      text(size: 8.4pt)[$U inter op("supp") cal(J)=emptyset$],
    )
    content(
      (4.15, -2.08),
      anchor: "north",
      text(size: 8.4pt, fill: domain-stroke)[$d_(h)^(*)cal(F)=0$],
    )
  })
}
