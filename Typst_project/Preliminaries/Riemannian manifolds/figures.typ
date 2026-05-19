#import "@preview/cetz:0.4.2": *
#import "../../Styles/cetz_utils.typ": description_box, legend_box
#import "../../Styles/theme.typ": *

// Define the function name you want to use
#let extendible_vector_field() = {
  // 1. Move all your variable definitions INSIDE the function
  let arrow-style = (mark: (end: "straight", size: 0.15, fill: black), stroke: 0.5pt)
  let curve-style = (stroke: 0.8pt)

  let curve-points = (
    (0, 0),
    (1.5, 1.8),
    (3, 1.8),
    (2.5, 0.5),
    (1.8, 0.8),
    (2.2, 1.8),
    (4, 1.2),
  )

  let fig44-angle = 110deg
  let fig44-len = 0.8
  let fig44-origins = (
    (0.5, 2.2),
    (1.2, 2.5),
    (2.0, 2.8),
    (2.8, 2.4),
    (0.5, 0.5),
    (1.8, 0.0),
    (0.9, 1.1),
    (2.8, 1.8),
    (2.4, 0.6),
    (3.8, 1.4),
  )

  // 2. Return the content (the grid)
  grid(
    // Figure 4.4
    [
      #canvas(length: 1.5cm, {
        import draw: *
        for origin in fig44-origins {
          group({
            translate(origin)
            rotate(z: fig44-angle)
            line((0, 0), (fig44-len, 0), ..arrow-style)
          })
        }
        hobby(..curve-points, ..curve-style)
      })
    ],
  )
}

#let non_extendible_vector_field() = {
  let arrow-style = (mark: (end: "straight", size: 0.15, fill: black), stroke: 0.5pt)
  let curve-style = (stroke: 0.8pt)

  let curve-points = (
    (0, 0),
    (1.5, 1.8),
    (3, 1.8),
    (2.5, 0.5),
    (1.8, 0.8),
    (2.2, 1.8),
    (4, 1.2),
  )
  // Figure 4.5
  [
    #canvas(length: 1.5cm, {
      import draw: *
      hobby(..curve-points, ..curve-style)
      line((0.6, 0.8), (1.1, 1.3), ..arrow-style)
      line((1.8, 1.2), (1.6, 1.9), ..arrow-style)
      line((2.4, 0.5), (2.8, 0.2), ..arrow-style)
      line((2.1, 1.7), (2.8, 1.9), ..arrow-style)
      line((3.6, 1.5), (4.1, 1.3), ..arrow-style)
      line((2.1, 0.5), (1.8, -0.1), ..arrow-style)
    })
  ]
}

#let parallel_vector_field_along_a_curve() = context {
  let theme = theme-from-text-fill()

  canvas({
    import draw: *
    // 1. Define the exact points (knots) the curve passes through
    let knots = (
      (0, 0), // Start
      (2, 2), // Crest
      (4.5, 0.5), // Trough
      (7.5, 1.5), // Rise
      (8.5, 4), // Outer edge
      (7, 5), // Top of loop
      (5.5, 3.5), // End of loop
    )

    // 2. Draw the smooth curve through these points
    hobby(
      ..knots,
      tension: 1,
      stroke: (thickness: 1pt),
      name: "path",
    )

    // 3. Define the "Initial Vector" shape (Prototype)
    // We define it once at the origin (0,0) pointing Up.
    // This variable will be reused for all vectors.
    let arrow = line(
      (0, 0),
      (0, 2),
      stroke: (paint: theme.rule, thickness: 1.2pt),
      mark: (end: "stealth", fill: theme.rule, scale: 0.5),
    )

    // 4. Define configurations
    let configs = (
      (index: 0, angle: 110deg),
      (index: 1, angle: 110deg),
      (index: 2, angle: 110deg),
      (index: 3, angle: 110deg),
      (index: 4, angle: 110deg),
      (index: 5, angle: 110deg),
      (index: 6, angle: 110deg),
    )

    // 5. Generate the vectors using Group, Translate (Move), and Rotate
    for config in configs {
      let pt = knots.at(config.index)

      group({
        // Move the coordinate system origin to the point on the curve
        // This is effectively "moving to" the point.
        translate(pt)

        // Rotate the coordinate system
        // (Subtract 90deg because our prototype arrow points Up/90deg)
        rotate(config.angle - 90deg)

        // Draw the prototype arrow in this new context
        arrow
      })
    }
  })
}

#let expend_interval_of_existence() = {
  canvas({
    import draw: *

    // Coordinate Definitions
    let a = -4
    let b = 4
    let a0 = -4
    let b0 = 1.5
    let b1 = 3.0
    let y_main = 0
    let y_offset = 1.0 // Lifted higher to give space from the axis

    // Style Settings
    let label_size = 8pt // Smaller font size

    // 1. Global Domain I
    line((a, y_main), (b, y_main), stroke: (paint: luma(150), dash: "dashed"), name: "global")

    // Apply text() inside the content block
    content((a, y_main), anchor: "east", padding: 0.2)[#text(size: label_size)[$a$]]
    content((b, y_main), anchor: "west", padding: 0.2)[#text(size: label_size)[$b$]]
    content((0, y_main - 0.4))[#text(fill: luma(150), size: label_size)[Global Domain $I$]]

    // 2. Interval I_0 (Current Solution)
    line((a0, y_offset), (b0, y_offset), stroke: (paint: blue, thickness: 2pt))
    // Label for I_0 (Left side)
    content(((a0 + b0) / 2, y_offset + 0.4))[#text(fill: blue, size: label_size)[$I_0$ (Current)]]

    // 3. Interval I_1 (Extension)
    line((b0, y_offset), (b1, y_offset), stroke: (paint: green, thickness: 2pt))
    // Label for I_1 (Right side)
    content(((b0 + b1) / 2, y_offset + 0.4))[#text(fill: green, size: label_size)[$I_1$ (Ext)]]

    // 4. Critical Points (b_0 and b_0 + epsilon)
    // b0 label (moved below the line slightly to avoid I_0/I_1 labels)
    content((b0, y_offset - 0.3))[#text(fill: blue, size: label_size)[$b_0$]]

    // b1 label
    content((b1, y_offset - 0.3))[#text(fill: green, size: label_size)[$b_0 + epsilon$]]

    // 5. The Patching Point Visualization
    circle((b0, y_offset), radius: 0.1, fill: black, stroke: none)

    // Connecting line to explanation
    let note_y = y_offset - 1.2
    line((b0, y_offset - 0.5), (b0, note_y + 0.2), stroke: (paint: black, dash: "dotted"))
    content((b0 - 1.2, note_y + 0.6))[#text(size: label_size, weight: "bold")[
      Patching Point \
      $V(b_0)$ is finite
    ]]

    // 6. The Union Brace
    let brace_y = note_y - 0.6
    line((a0, brace_y), (b1, brace_y), stroke: (paint: black, thickness: 1pt), mark: (start: "|", end: "|"))
    content(((a0 + b1) / 2, brace_y - 0.3))[#text(size: label_size)[Union: $I_0 union I_1$ (Extended)]]
  })
}

#let theorem432_run_up() = {
  canvas({
    import draw: *

    // --- Coordinates ---
    let beta_point = 0
    let delta_point = 2.5
    let run_up_x = beta_point - (delta_point / 2)
    let y_chart1 = 1.5
    let y_chart2 = 0
    let font_size = 8pt

    // --- 1. The "Wall" (Beta) ---
    // A vertical dashed line representing the limit of the first chart
    line((beta_point, -1), (beta_point, 2.5), stroke: (paint: red, dash: "dashed"))
    content((beta_point, 2.7))[#text(fill: red, size: font_size, weight: "bold")[$beta$ (Supremum)]]

    // --- 2. Chart 1 (The Old Path) ---
    // Moves from left and hits the wall
    line((-4, y_chart1), (beta_point, y_chart1), stroke: (paint: blue, thickness: 2pt), mark: (end: "|"))
    content((-3.5, y_chart1 + 0.3))[#text(fill: blue, size: font_size)[Chart 1 Domain]]

    // The Run-Up Point (Safe footing)
    circle((run_up_x, y_chart1), radius: 0.1, fill: blue, name: "p1")
    content((run_up_x, y_chart1 + 0.4))[#text(fill: blue, size: font_size)[Run-Up Point \ $beta - delta/2$]]

    // --- 3. Chart 2 (The Bridge) ---
    // Covers the wall (starts before beta, ends after beta)
    line((beta_point - delta_point, y_chart2), (beta_point + delta_point, y_chart2), stroke: (
      paint: green,
      thickness: 2pt,
    ))
    content((beta_point + 1.3, y_chart2 - 0.4))[#text(fill: green, size: font_size)[Chart 2 (The Bridge)]]

    // The Bridge Extension
    line((beta_point, y_chart2), (beta_point + delta_point, y_chart2), stroke: (paint: green, thickness: 4pt)) // Thicker to emphasize extension

    // --- 4. The Hand-Off (Logic) ---
    // An arrow showing we take the value from Chart 1 and use it in Chart 2
    bezier(
      (run_up_x, y_chart1 - 0.2),
      (run_up_x + 0.5, y_chart2 + 0.2),
      (run_up_x, y_chart1 - 1), // Control point 1
      (run_up_x + 0.2, y_chart2 + 1), // Control point 2
      mark: (end: ">"),
      stroke: (paint: black),
    )

    // Label for the action
    content((run_up_x - 0.8, (y_chart1 + y_chart2) / 2))[#text(size: 7pt, style: "italic")[Hand-off \ Initial Cond.]]

    // --- 5. The "Gap" Visualization ---
    // Showing the overlap interval clearly
    let brace_y = -0.8
    line(
      (beta_point - delta_point, brace_y),
      (beta_point, brace_y),
      stroke: (paint: luma(150)),
      mark: (start: "|", end: "|"),
    )
    content((beta_point - delta_point / 2, brace_y - 0.3))[#text(fill: luma(150), size: font_size)[Overlap Region]]
  })
}

#let parallel_transport_map() = canvas({
  import draw: *

  // Settings
  let t0_x = -3
  let t1_x = 3
  let curve_bend = 2
  let label_size = 8pt

  // 1. The Curve gamma
  bezier(
    (t0_x, 0),
    (t1_x, 0),
    (t0_x + 1, curve_bend),
    (t1_x - 1, -curve_bend),
    stroke: (paint: luma(150), dash: "dashed"),
    name: "gamma",
  )
  content((0, 0.5))[#text(size: label_size, fill: luma(150))[$gamma(t)$]]

  // 2. Tangent Space at t0 (represented as a disk)
  circle((t0_x, 0), radius: 1, fill: rgb(230, 230, 250), stroke: luma(150))
  content((t0_x, -1.5))[#text(size: label_size)[$T_(gamma(t_0))M$]]

  // The Initial Vector v
  line((t0_x, 0), (t0_x + 0.5, 0.8), mark: (end: ">"), stroke: (thickness: 2pt, paint: black))
  content((t0_x + 0.6, 0.8))[#text(size: label_size)[$v$]]

  // 3. Tangent Space at t1 (represented as a disk)
  circle((t1_x, 0), radius: 1, fill: rgb(230, 230, 250), stroke: luma(150))
  content((t1_x, -1.5))[#text(size: label_size)[$T_(gamma(t_1))M$]]

  // The Transported Vector V(t1)
  // Note: Just a visual representation, direction depends on curvature
  line((t1_x, 0), (t1_x + 0.8, 0.2), mark: (end: ">"), stroke: (thickness: 2pt, paint: blue))
  content((t1_x + 0.9, 0.5))[#text(size: label_size, fill: blue)[$V(t_1) = P(v)$]]

  // 4. The Map Operator P (The "Arrow" of transformation)
  bezier(
    (t0_x, 1.2),
    (t1_x, 1.2),
    (t0_x + 1, 2.5),
    (t1_x - 1, 2.5),
    mark: (end: ">"),
    stroke: (paint: blue, thickness: 1pt),
  )
  content((0, 2.5))[#text(size: label_size, fill: blue)[$P_(t_0 t_1)^gamma$ (Isomorphism)]]

  // 5. Piecewise Note (Visualizing a corner handling)
  // Just a small visual cue that we integrate along the path
  content((0, -2))[#text(size: 8pt, style: "italic")[
    The map slides $v$ along $gamma$ solving $nabla_(dot gamma)V=0$.
  ]]
})

#let parallel_transport() = canvas({
  import draw: *

  let r = 3

  // 1. Draw the "Path" (A quarter circle)
  arc((0, 0), start: 0deg, stop: 90deg, radius: r, stroke: (dash: "dashed"), name: "path")
  content((0.6, 1.5))[Path $gamma(t)$]

  // 2. Point A (Start at theta = 0)
  let p1 = (r, 0)
  circle(p1, radius: 0.1, fill: black)

  // Basis vectors at A
  line(p1, (r + 1, 0), stroke: (paint: luma(150), thickness: 1pt), mark: (end: ">")) // e_r
  content((r + 1, 0.4), text(fill: luma(150))[$e_r$])
  line(p1, (r, 1), stroke: (paint: luma(150), thickness: 1pt), mark: (end: ">")) // e_theta
  content((r, 1.2), text(fill: luma(150))[$e_theta$])

  // The Vector V (Parallel Transported)
  // Initially points "Right" (along e_r)
  line(p1, (r + 1.5, 0), stroke: (paint: blue, thickness: 2pt), mark: (end: ">"))
  content((r + 1.5, -0.3), text(blue)[$V$ (Start)])
  content((r, -0.8))[Components: $(1, 0)$]

  // 3. Point B (End at theta = 90)
  let p2 = (0, r)
  circle(p2, radius: 0.1, fill: black)

  // Basis vectors at B (Rotated!)
  line(p2, (0, r + 1), stroke: (paint: luma(150), thickness: 1pt), mark: (end: ">")) // e_r points UP now
  content((0, r + 1.2), text(fill: luma(150))[$e_r$])
  line(p2, (-1, r), stroke: (paint: luma(150), thickness: 1pt), mark: (end: ">")) // e_theta points LEFT now
  content((-1.2, r), text(fill: luma(150))[$e_theta$])

  // The Vector V (Parallel Transported)
  // Still points "Right" physically!
  line(p2, (1.5, r), stroke: (paint: blue, thickness: 2pt), mark: (end: ">"))
  content((1.5, r + 0.3), text(blue)[$V$ (End)])

  // Show decomposition at B
  line(p2, (1.5, r), stroke: (paint: red, dash: "dotted"))
  content((3.5, r))[Components:\ $V^r = 0$\ $V^theta < 0$]
})

#let Euclidean_space_parallel_transport() = canvas({
  import draw: *

  // Set up a 3D isometric view
  set-style(content: (padding: .2))

  // --- 1. Draw the Path (Gamma) ---
  // A curve winding through 3D space
  let p0 = (-4, -2, 0)
  let p1 = (0, 2, 2)
  let p2 = (4, -2, 0)

  bezier(p0, p2, (-2, 4, 2), (2, -4, 2), stroke: (paint: luma(150), dash: "dashed"), name: "gamma")
  content((0, -2.5, 0), text(size: 10pt)[$gamma(t)$])

  // --- Helper Function to Draw a Frame ---
  let draw-frame(origin, label_suffix) = {
    group({
      translate(origin)

      // Origin Point
      circle((0, 0, 0), radius: 0.1, fill: black, stroke: none)

      // Basis Vectors (Standard Cartesian Directions)
      // E1 (X-axis) - Red
      line((0, 0, 0), (1.5, 0, 0), stroke: (paint: red, thickness: 2pt), mark: (end: ">"))
      content((1.7, 0, 0), text(fill: red, size: 8pt)[$E_1$])

      // E2 (Y-axis) - Green
      line((0, 0, 0), (0, 1.5, 0), stroke: (paint: green, thickness: 2pt), mark: (end: ">"))
      content((0, 1.7, 0), text(fill: green, size: 8pt)[$E_2$])

      // E3 (Z-axis) - Blue
      line((0, 0, 0), (0, 0, 1.5), stroke: (paint: blue, thickness: 2pt), mark: (end: ">"))
      content((0, 0, 1.7), text(fill: blue, size: 8pt)[$E_3$])

      // Label for the time point
      content((0, -0.5, 0), text(size: 8pt)[$#label_suffix$])
    })
  }

  // --- 2. Place Frames along the Curve ---

  // Frame at t0 (Start)
  draw-frame(p0, "t_0")

  // Frame at t1 (Middle - approximate on the bezier)
  // We place it manually at a point that looks like it's on the curve for visual clarity
  draw-frame((0, -0.5, 1.5), "t_1")

  // Frame at t2 (End)
  draw-frame(p2, "t_2")
})

#let proof_of_connection_compatibility() = {
  canvas({
    import draw: *
    import "@preview/cetz:0.4.2": decorations

    let d = 2.5
    let row_height = 1.3

    // First line: (nabla g)(Y,Z,X) = (nabla_X g)(Y,Z)
    content((0, 0), anchor: "west")[
      $
        (nabla g)(Y, Z, X) & = (nabla_X g)(Y, Z) #h(2em) #text(size: 0.8em)[(by @definition_of_total_covariant_derivative)]
      $
    ]

    // Second line parts
    // We align manually roughly.

    let line2_y = -row_height
    let eq_x = 3.2

    content((eq_x, line2_y), anchor: "center")[$=$]

    // Terms for line 2
    let term1_pos = (eq_x + 0.5, line2_y)
    let term2_pos = (eq_x + 3.8, line2_y)
    let term3_pos = (eq_x + 7.5, line2_y)

    // Colors
    let col1 = red
    let col2 = blue

    content(term1_pos, anchor: "west", name: "first")[#text[$X(g(Y, Z))$]]
    content((eq_x + 3.2, line2_y), anchor: "center")[$-$]
    content(term2_pos, anchor: "west", name: "second")[#text[$g(nabla_X Y, Z)$]]
    content((eq_x + 6.8, line2_y), anchor: "center")[$-$]
    content(term3_pos, anchor: "west", name: "third")[#text[$g(Y, nabla_X Z)$]]

    content((eq_x + 10.8, line2_y), anchor: "west")[#text(size: 0.8em)[(by @proposition4.15_b)]]

    // Third line parts
    let line3_y = -2 * row_height

    content((eq_x, line3_y), anchor: "center")[$=$]

    let term1_res_pos = (eq_x + 0.5, line3_y)
    let term2_res_pos = (eq_x + 3.8, line3_y)
    let term3_res_pos = (eq_x + 7.5, line3_y)

    content(
      term1_res_pos,
      anchor: "west",
      name: "first_result",
    )[#text[$cancel(nabla_X chevron.l Y comma Z chevron.r_g, stroke: #(paint: fuchsia, thickness: 1.5pt, dash: "dashed"))$]]
    content((eq_x + 3.2, line3_y), anchor: "center", name: "minus_second")[$-$]
    content(term2_res_pos, anchor: "west", name: "second_result")[#text[$chevron.l nabla_X Y, Z chevron.r_g$]]
    content((eq_x + 6.8, line3_y), anchor: "center")[$-$]
    content(term3_res_pos, anchor: "west", name: "third_result")[#text[$chevron.l Y, nabla_X Z chevron.r_g$]]

    // Arrows with explanation
    group({
      set-style(mark: (end: "straight", fill: black, size: 0.15))

      let arrow_stroke = 0.5pt

      // First term: X(g(Y,Z)) -> nabla_X <Y,Z>
      line("first.south", "first_result.north", stroke: (paint: col1, thickness: arrow_stroke), name: "arrow1")
      content("arrow1.mid", anchor: "west", padding: 0.1)[#text(
        size: 0.4em,
        fill: col1,
      )[$X(g(Y, Z))=nabla_X chevron.l Y, Z chevron.r$ \ by proposition 4.15 (2)]]
      content("arrow1.mid", anchor: "east", padding: 0.1)[#text(
        size: 0.6em,
        fill: col1,
      )[$g( dot , dot ) = chevron.l dot , dot chevron.r$]]

      // Second term
      line("second.south", "second_result.north", stroke: (paint: col2, thickness: arrow_stroke), name: "arrow2")
      content("arrow2.mid", anchor: "west", padding: 0.1)[#text(
        size: 0.6em,
        fill: col2,
      )[$g( dot , dot ) = chevron.l dot , dot chevron.r$]]

      // Third term
      line("third.south", "third_result.north", stroke: (paint: col2, thickness: arrow_stroke), name: "arrow3")
      content("arrow3.mid", anchor: "west", padding: 0.1)[#text(
        size: 0.6em,
        fill: col2,
      )[$g( dot , dot ) = chevron.l dot , dot chevron.r$]]
    })

    // Combine 2nd and 3rd terms
    decorations.brace(
      "third_result.south-east",
      "minus_second.south-west",
      flip: false,
      name: "brace1",
      stroke: purple,
      thickness: 0.2pt,
    )
    content("brace1.content", anchor: "north")[
      #text(
        fill: purple,
        size: 0.6em,
      )[$= cancel(-nabla_X chevron.l Y comma Z chevron.r_g, stroke: #(paint: fuchsia, thickness: 0.8pt, dash: "dashed"))$ by the compatibility condition.]
    ]
  })
}

#let covariant_derivative_intuition() = {
  // Define colors locally as they are specific to this figure's theme
  let teal = rgb("008080")
  let orange = rgb("FF7F50")
  let purple = rgb("800080")

  canvas({
    import draw: *

    // --- Setup Coordinates and Data ---
    let P = (0, 0)
    // Movement vector Ek
    let vec_Ek = (4, 0.5)
    let Q = (P.at(0) + vec_Ek.at(0), P.at(1) + vec_Ek.at(1))

    // Basis at P
    // E1 is roughly x-aligned, E2 roughly y-aligned, but not orthogonal
    let vec_E1_P = (2.5, 0.3)
    let vec_E2_P = (0.8, 2.8)
    let E1_P = (P.at(0) + vec_E1_P.at(0), P.at(1) + vec_E1_P.at(1))
    let E2_P = (P.at(0) + vec_E2_P.at(0), P.at(1) + vec_E2_P.at(1))

    // Parallel Transported Basis at Q (Ghost basis)
    // Geometrically, these are rigid translations of the vectors at P
    let E1_Q_pt = (Q.at(0) + vec_E1_P.at(0), Q.at(1) + vec_E1_P.at(1))
    let E2_Q_pt = (Q.at(0) + vec_E2_P.at(0), Q.at(1) + vec_E2_P.at(1))

    // Actual Basis at Q (Twisted by Connection)
    // We define the "twist" vectors (nabla_Ek Ei) = Gamma terms
    let twist_E1 = (-0.2, 0.5) // E1 twists up and left
    let twist_E2 = (0.5, -0.1) // E2 twists right and slightly down
    let E1_Q_actual = (E1_Q_pt.at(0) + twist_E1.at(0), E1_Q_pt.at(1) + twist_E1.at(1))
    let E2_Q_actual = (E2_Q_pt.at(0) + twist_E2.at(0), E2_Q_pt.at(1) + twist_E2.at(1))


    // --- Drawing Scene 1: Point P ---
    circle(P, radius: 0.05, fill: black)
    content(P, anchor: "north-east", padding: 0.1)[$P$]

    // Basis vectors at P
    line(P, E1_P, stroke: (paint: teal, thickness: 2pt), mark: (end: ">"))
    content(E1_P, anchor: "south-east", padding: 0.1)[$E_i|_P$]
    line(P, E2_P, stroke: (paint: orange, thickness: 2pt), mark: (end: ">"))
    content(E2_P, anchor: "south", padding: 0.1)[$E_j|_P$]

    // Metric at P (visualized as angle arc)
    arc(P, start: 10deg, stop: 70deg, radius: 1, stroke: (paint: purple), mark: (start: ">", end: ">"))
    content((1.1, 1.3), anchor: "south-west", text(fill: purple)[$g_(i j)|_P$])


    // --- Drawing Transition: Movement along Ek ---
    line(P, Q, stroke: (paint: luma(150), thickness: 3pt), mark: (end: ">"))
    content((2, 0.25), anchor: "north", padding: 0.2)[Move along $E_k$]


    // --- Drawing Scene 2: Point Q ---
    circle(Q, radius: 0.05, fill: black)
    content(Q, anchor: "north-west", padding: 0.1)[$Q$]

    // 2a. Parallel Transported Basis (Ghosts)
    // These represent "no change in geometry"
    line(Q, E1_Q_pt, stroke: (paint: teal, thickness: 1.5pt, dash: "dashed"), mark: (end: ">"))
    line(Q, E2_Q_pt, stroke: (paint: orange, thickness: 1.5pt, dash: "dashed"), mark: (end: ">"))

    // Angle of PT basis (Same as at P!)
    arc(Q, start: 10deg, stop: 70deg, radius: 1, stroke: (paint: purple, dash: "dashed"), mark: (start: ">", end: ">"))
    content((Q.at(0) + 1.3, Q.at(1) + 1.4), anchor: "west", text(fill: purple, size: 8pt)[$g_(i j)$ (unchanged by PT)])

    // 2b. Actual Basis at Q
    line(Q, E1_Q_actual, stroke: (paint: teal, thickness: 2pt), mark: (end: ">"))
    content(E1_Q_actual, anchor: "west", padding: 0.1)[$E_i|_Q$]
    line(Q, E2_Q_actual, stroke: (paint: orange, thickness: 2pt), mark: (end: ">"))
    content(E2_Q_actual, anchor: "south-west", padding: 0.1)[$E_j|_Q$]

    // New Metric Angle at Q
    // Calculate rough angles for the arc based on data points
    arc(
      Q,
      start: 20deg,
      stop: 60deg,
      radius: 1.5,
      stroke: (paint: purple, thickness: 2pt),
      mark: (start: ">", end: ">"),
    )
    content((Q.at(0) + 1.6, Q.at(1) + 2), anchor: "west", text(
      size: 8pt,
      fill: purple,
      weight: "bold",
    )[$g_(i j)|_Q$ (Measured Value Changed!)])


    // --- Drawing The Crucial Part: The Twists (Gamma terms) ---

    // Twist vector for E1
    line(E1_Q_pt, E1_Q_actual, stroke: (paint: red, thickness: 2pt), mark: (end: ">"))
    // Labeling the twist using nabla and Gamma
    content((E1_Q_pt.at(0) - 0.1, E1_Q_pt.at(1) + 0.6), anchor: "east", text(
      fill: red,
      size: 9pt,
    )[$nabla_(E_k) E_i approx Gamma^l_(k i) E_l$])

    // Twist vector for E2
    line(E2_Q_pt, E2_Q_actual, stroke: (paint: red, thickness: 2pt), mark: (end: ">"))
    content((E2_Q_pt.at(0) - 2, E2_Q_pt.at(1) + 0.2), anchor: "west", text(
      fill: red,
      size: 9pt,
    )[$nabla_(E_k) E_j approx Gamma^l_(k j) E_l$])


    // --- Final Annotations ---
    // Main Title Formula
    content((4, 6.5), text(size: 0.8em)[
      Intuition: The change in measurement $g_(i j)$ is due to the twisting of the basis vectors.
    ])
    let term1 = [#box(
      stroke: (paint: blue, thickness: 1pt),
      inset: 3pt,
      radius: 2pt,
      fill: blue.lighten(90%),
    )[$Gamma^l_(k i) g_(l j)$] <twist1>]
    let term2 = [#box(
      stroke: (paint: red, thickness: 1pt),
      inset: 3pt,
      radius: 2pt,
      fill: red.lighten(90%),
    )[$Gamma^l_(k j) g_(i l)$] <twist2>]

    content((3, 5.5), text(weight: "bold")[
      $
        E_k (g_(i j)) = #term1 + #term2
      $
    ])

    // Note: Manual placement used because mannot's annot() introspection fails inside cetz canvas
    // Adjust coordinates (x, y) as needed to align with the terms
    content((3.3, 4.7), text(size: 0.8em, fill: blue)[#align(center)[$arrow.t$ \ Twist of $E_i$]])
    content((5.3, 4.7), text(size: 0.8em, fill: red)[#align(center)[$arrow.t$ \ Twist of $E_j$]])


    // Legend/Explanation box
    let box_top = -1
    let box_left = 0
    let box_width = 8.7
    let item_spacing = 0.5

    let legend_items = (
      (
        text: [Parallel Transported Angle (Constant Value)],
        stroke: (paint: purple, dash: "dashed"),
        mark: none,
      ),
      (
        text: [Actual Measured Angle (Changed Value)],
        stroke: (paint: purple, thickness: 2pt),
        mark: none,
      ),
      (
        text: [The "Twist" (Connection $Gamma$) causing the change],
        stroke: (paint: red, thickness: 2pt),
        mark: (end: ">"),
      ),
    )

    legend_box(
      x: box_left,
      y: box_top,
      width: box_width,
      items: legend_items,
      item_spacing: item_spacing,
    )
  })
}

#let twist_visualization() = canvas({
  import draw: *

  let red_vec = rgb("E03030")
  let blue_vec = rgb("3050F0")
  let ghost_grey = rgb("aaaaaa")

  // --- 1. Draw the "Grid" (Polar Coordinates) ---
  // This represents the coordinate system
  let origin = (0, 0)
  group(name: "grid", {
    // Radial lines (rays)
    for angle in (0, 30, 60, 90) {
      line(origin, (4 * calc.cos(angle * 1deg), 4 * calc.sin(angle * 1deg)), stroke: (
        paint: luma(150).lighten(50%),
        thickness: 0.5pt,
      ))
    }

    // Circles (constant r)
    for r in (1, 2, 3) {
      arc(origin, radius: r, start: 0deg, stop: 90deg, stroke: (paint: luma(150).lighten(50%), thickness: 0.5pt))
    }
  })

  // --- 2. Define Points ---
  let r_path = 3
  let theta_A = 0
  let theta_B = 45

  let A = (r_path * calc.cos(theta_A * 1deg), r_path * calc.sin(theta_A * 1deg))
  let B = (r_path * calc.cos(theta_B * 1deg), r_path * calc.sin(theta_B * 1deg))

  // --- 3. Draw Path ---
  group(name: "path", {
    arc(origin, radius: r_path, start: 0deg, stop: 45deg, stroke: (thickness: 2pt, dash: "dashed"), mark: (end: ">"))
    content((4, 1.5), text(size: 8pt)[Move along $theta$])
  })

  // --- 4. Draw Basis at Point A (theta = 0) ---
  group(name: "basis_p1", {
    circle(A, radius: 0.05, fill: black)
    content(A, anchor: "north-west", padding: 0.1)[$P_1$]

    // Er at A (Points Right)
    line(A, (A.at(0) + 1, A.at(1)), stroke: (paint: red_vec, thickness: 2pt), mark: (end: ">"))
    content((A.at(0) + 1, A.at(1)), anchor: "west", text(fill: red_vec)[$E_r$])

    // Etheta at A (Points Up)
    line(A, (A.at(0), A.at(1) + 1), stroke: (paint: blue_vec, thickness: 2pt), mark: (end: ">"))
    content((A.at(0), A.at(1) + 1), anchor: "south", text(fill: blue_vec)[$E_theta$])
  })


  // --- 5. Draw Basis at Point B (theta = 45) ---
  group(name: "basis_p2", {
    circle(B, radius: 0.05, fill: black)
    content(B, anchor: "north-west", padding: 0.1)[$P_2$]

    // Actual Er at B (Points 45 deg)
    let vec_Er_B = (calc.cos(theta_B * 1deg), calc.sin(theta_B * 1deg))
    line(
      B,
      (B.at(0) + vec_Er_B.at(0), B.at(1) + vec_Er_B.at(1)),
      stroke: (paint: red_vec, thickness: 2pt),
      mark: (end: ">"),
    )
    content((B.at(0) + vec_Er_B.at(0), B.at(1) + vec_Er_B.at(1)), anchor: "south-west", text(fill: red_vec)[$E_r$])

    // Actual Etheta at B (Points 135 deg)
    let vec_Etheta_B = (calc.cos((theta_B + 90) * 1deg), calc.sin((theta_B + 90) * 1deg))
    line(
      B,
      (B.at(0) + vec_Etheta_B.at(0), B.at(1) + vec_Etheta_B.at(1)),
      stroke: (paint: blue_vec, thickness: 2pt),
      mark: (end: ">"),
    )
    content((B.at(0) + vec_Etheta_B.at(0), B.at(1) + vec_Etheta_B.at(1)), anchor: "south-east", text(
      fill: blue_vec,
    )[$E_theta$])
  })


  // --- 6. The "Artifact" Visualization ---
  // Show the "Ghost" of P1's basis at P2 to show the twist
  group(name: "artifact", {
    // Ghost Er (Parallel Transported from A to B in flat space)
    // Since space is flat, parallel transport = rigid translation.
    // P1's Er pointed (1,0). So Ghost Er at B points (1,0).
    line(B, (B.at(0) + 1, B.at(1)), stroke: (paint: ghost_grey, thickness: 1.5pt, dash: "dotted"), mark: (end: ">"))
    content((B.at(0) + 1.1, B.at(1)), anchor: "west", text(fill: ghost_grey, size: 8pt)[$tau(E_r)$])

    // Draw Arc showing the twist for Er
    arc(B, radius: 0.6, start: 0deg, stop: 45deg, stroke: (paint: red_vec, thickness: 1pt), mark: (end: ">"))
    content((B.at(0) + 0.5, B.at(1) + 0.2), text(size: 6pt, fill: red_vec)[$Gamma$])

    // Ghost Etheta (Parallel Transported from A to B)
    // P1's Etheta pointed (0,1). So Ghost Etheta at B points (0,1).
    line(B, (B.at(0), B.at(1) + 1), stroke: (paint: ghost_grey, thickness: 1.5pt, dash: "dotted"), mark: (end: ">"))
    content((B.at(0), B.at(1) + 1.1), anchor: "south", text(fill: ghost_grey, size: 8pt)[$tau(E_theta)$])

    // Draw Arc showing the twist for Etheta
    // Real Etheta is at 135deg (90+45). Ghost is at 90deg.
    arc(B, radius: 0.6, start: 90deg, stop: 135deg, stroke: (paint: blue_vec, thickness: 1pt), mark: (end: ">"))
    content((B.at(0) - 0.2, B.at(1) + 0.5), text(size: 6pt, fill: blue_vec)[$Gamma$])
  })


  // --- 7. Explanatory Legends ---
  group(name: "legend", {
    let rect_shift_y = 1
    let rect_shift_x = 0
    rect(
      (-3.2 + rect_shift_x, 3.5 + rect_shift_y),
      (7.2 + rect_shift_x, 6 + rect_shift_y)
    )
    content((2 + rect_shift_x, 4.75 + rect_shift_y), [
      #align(center)[*Polar Coordinates on Flat Plane*]
      - Dotted "Ghost" vectors: Parallel Transport (no rotation).
      - Solid vectors: Basis rotates with the grid.
      - The difference is the connection $Gamma$ (Twist).
    ])
  })
})

#let torsion_tensor_visualization() = canvas({
  import draw: *

  let p = (0, 0)

  // Vectors X and Y
  let vec_X = (3.5, 0.5)
  let vec_Y = (1.0, 3.0)

  // 1. Start Point P
  circle(p, radius: 0.1, fill: black)
  content(p, anchor: "north-east", padding: 0.2)[$p$]

  // 2. Initial Flow Paths
  // Path for X
  bezier(p, vec_X, (1, 0.2), (2.5, 0.3), stroke: (paint: blue, thickness: 1.5pt), mark: (end: ">"))
  content((1.8, 0), anchor: "north", text(blue)[$X$])

  // Path for Y
  bezier(p, vec_Y, (0.3, 1), (0.4, 2), stroke: (paint: red, thickness: 1.5pt), mark: (end: ">"))
  content((0, 1.5), anchor: "east", text(red)[$Y$])

  // 3. Parallel Translation Endpoints (p_trans)
  let p_x = vec_X
  let p_y = vec_Y

  // Transport Y along X -> End point p_trans_xy
  let p_trans_xy = (p_x.at(0) + vec_Y.at(0) * 0.8 + 0.3, p_x.at(1) + vec_Y.at(1) * 0.8 - 0.2)
  bezier(
    p_x,
    p_trans_xy,
    (p_x.at(0) + 0.3, p_x.at(1) + 1),
    (p_x.at(0) + 0.4, p_x.at(1) + 2.5),
    stroke: (paint: red, dash: "dashed"),
    mark: (end: ">"),
    name: "bezier_1",
  )
  content(("bezier_1.start", 50%, "bezier_1.end"), anchor: "west", padding: 0.2, text(
    size: 8pt,
    fill: red,
  )[Transpt. $Y$])

  // Transport X along Y -> End point p_trans_yx
  let p_trans_yx = (p_y.at(0) + vec_X.at(0) * 0.8 - 0.5, p_y.at(1) + vec_X.at(1) * 0.8 + 0.2)
  bezier(
    p_y,
    p_trans_yx,
    (p_y.at(0) + 1, p_y.at(1) + 0.2),
    (p_y.at(0) + 2.5, p_y.at(1) + 0.3),
    stroke: (paint: blue, dash: "dashed"),
    mark: (end: ">"),
    name: "bezier_2",
  )
  content(("bezier_2.start", 50%, "bezier_2.end"), anchor: "south", padding: 0.2, text(
    size: 8pt,
    fill: blue,
  )[Transpt. $X$])

  // 4. Flow Endpoints (p_flow)
  // These represent p + X + Y (Flow along X then Y) and p + Y + X (Flow along Y then X)
  // We offset them from the transport points to show the difference (nabla)

  // Flow X then Y (near Transpt Y)
  // Difference is nabla_X Y
  let p_flow_xy = (p_trans_xy.at(0) + 0.8, p_trans_xy.at(1) + 0.4)
  circle(p_flow_xy, radius: 0.05, fill: black)

  // Flow Y then X (near Transpt X)
  // Difference is nabla_Y X
  let p_flow_yx = (p_trans_yx.at(0) + 0.4, p_trans_yx.at(1) - 0.6)
  circle(p_flow_yx, radius: 0.05, fill: black)

  // 5. Connecting Vectors (The Terms)

  // Vector: nabla_X Y (from parallel end to flow end)
  // Actually, geometry is FlowEnd - TransptEnd ~ nabla_X Y
  line(p_trans_xy, p_flow_xy, stroke: (paint: teal, thickness: 1.5pt), mark: (end: ">"), name: "line_2")
  content(
    ("line_2.start", 70%, "line_2.end"),
    anchor: "north",
    padding: 0.3,
    text(teal, size: 8pt)[$nabla_X Y$],
  )

  // Vector: nabla_Y X (from parallel end to flow end)
  line(p_trans_yx, p_flow_yx, stroke: (paint: orange, thickness: 1.5pt), mark: (end: ">"), name: "nabla_YX")
  content(
    ("nabla_YX.start", 50%, "nabla_YX.end"),
    anchor: "west",
    padding: 0.3,
    text(
      orange,
      size: 8pt,
    )[$nabla_Y X$],
  )

  // Vector: Lie Bracket [X, Y] (Connects flow endpoints)
  // p_flow_yx to p_flow_xy
  line(p_flow_yx, p_flow_xy, stroke: (paint: green, thickness: 1.5pt), mark: (end: ">"), name: "line_1")
  content(
    ("line_1.start", 100%, "line_1.end"),
    anchor: "south",
    padding: 0.1,
    text(green, size: 8pt)[$[X, Y]$],
  )

  // 6. The Torsion Vector (Closing the loop)
  // Connect p_trans_yx to p_trans_xy
  line(p_trans_yx, p_trans_xy, stroke: (paint: purple, thickness: 2.5pt), mark: (end: ">"), name: "torsion")
  content(
    ("torsion.start", 50%, "torsion.end"),
    anchor: "north-east",
    padding: 0.3,
    text(purple, weight: "bold", size: 8pt)[$tau(X, Y)$],
  )

  // Explanatory Legend
  description_box(
    x: 1.5,
    y: 6.5,
    width: auto,
    body: [
      *Decomposition*
      $
        tau(X, Y) & = nabla_X Y - nabla_Y X - [X, Y]
      $
      #text(size: 8pt)[
        $nabla_X Y$: difference between Flow and Parallel Transp. \
        $[X, Y]$: Non-closing of Flows
      ]
    ],
  )
})

#let torsion_free_visualization() = canvas({
  import draw: *

  let start_node = (0, 0)

  // Vector A: nabla_X Y
  let vec_A = (2.5, 1.5)
  let node_A = (start_node.at(0) + vec_A.at(0), start_node.at(1) + vec_A.at(1))

  line(start_node, node_A, stroke: (paint: teal, thickness: 2pt), mark: (end: ">"), name: "nabla_XY")
  content(
    ("nabla_XY.start", 65%, "nabla_XY.end"),
    anchor: "north",
    padding: 0.4,
    text(teal)[$nabla_X Y$],
  )

  // Vector B: - nabla_Y X
  // We want the loop to close, so C = -[X,Y] must close it.

  // Let vector B be pointing somewhat left/up
  let vec_B = (-1.0, 2.0)
  let node_B = (node_A.at(0) + vec_B.at(0), node_A.at(1) + vec_B.at(1))

  line(node_A, node_B, stroke: (paint: orange, thickness: 2pt), mark: (end: ">"), name: "neg_nabla_YX")
  content(
    ("neg_nabla_YX.start", 50%, "neg_nabla_YX.end"),
    anchor: "west",
    padding: 0.3,
    text(orange)[$- nabla_Y X$],
  )

  // Vector C: - [X, Y]
  // Must go from node_B back to start_node for Torsion = 0
  line(node_B, start_node, stroke: (paint: green, thickness: 2pt), mark: (end: ">"), name: "neg_Lie")
  content(
    ("neg_Lie.start", 50%, "neg_Lie.end"),
    anchor: "east",
    padding: 0.3,
    text(green)[$- [X, Y]$],
  )

  // Explanatory Text
  description_box(
    x: 4,
    y: 2,
    width: 11em,
    body: text(weight: "bold")[$tau(X, Y) = 0$: Vectors form a closed loop],
  )
})

#let torsion_intuition_visualization() = canvas({
  import draw: *

  let p = (0, 0)

  // Vectors X and Y at p
  let vec_X = (3, 0.5)
  let vec_Y = (1, 3)

  circle(p, radius: 0.1, fill: black)
  content(p, anchor: "north-east", padding: 0.2)[$p$]

  // Path 1: Walk along X then parallel Y
  // Step 1: Walk along X
  bezier(p, vec_X, (1, 0.2), (2, 0.3), stroke: (paint: blue, thickness: 1.5pt), mark: (end: ">"))
  content((1.5, 0.2), anchor: "north", text(blue)[$X$])

  // Step 2: Walk along parallel Y
  // We simulate "parallel transport" by just adding the vector, maybe with slight curve
  // Same distortion as before to create gap
  let p1 = (vec_X.at(0) + vec_Y.at(0) * 0.9 + 0.5, vec_X.at(1) + vec_Y.at(1) * 0.9 - 0.2)
  bezier(
    vec_X,
    p1,
    (vec_X.at(0) + 0.2, vec_X.at(1) + 1),
    (vec_X.at(0) + 0.3, vec_X.at(1) + 2),
    stroke: (paint: red, dash: "dashed"),
    mark: (end: ">"),
  )
  content(p1, anchor: "west", padding: 0.2, text(size: 8pt)[$p_1$])

  // Path 2: Walk along Y then parallel X
  // Step 1: Walk along Y
  bezier(p, vec_Y, (0.3, 1), (0.4, 2), stroke: (paint: red, thickness: 1.5pt), mark: (end: ">"))
  content((0.2, 1.5), anchor: "east", text(red)[$Y$])

  // Step 2: Walk along parallel X
  let p2 = (vec_Y.at(0) + vec_X.at(0) * 0.9 - 0.5, vec_Y.at(1) + vec_X.at(1) * 0.9 + 0.2)
  bezier(
    vec_Y,
    p2,
    (vec_Y.at(0) + 1, vec_Y.at(1) + 0.2),
    (vec_Y.at(0) + 2, vec_Y.at(1) + 0.3),
    stroke: (paint: blue, dash: "dashed"),
    mark: (end: ">"),
  )
  content(p2, anchor: "south", padding: 0.2, text(size: 8pt)[$p_2$])

  // The Gap (Torsion)
  // From p2 to p1
  line(p2, p1, stroke: (paint: purple, thickness: 2pt), mark: (end: ">"), name: "torsion_gap")
  content(
    ("torsion_gap.start", 50%, "torsion_gap.end"),
    anchor: "north-east",
    padding: 0.2,
    text(purple, weight: "bold")[$T(X, Y)$],
  )
})
