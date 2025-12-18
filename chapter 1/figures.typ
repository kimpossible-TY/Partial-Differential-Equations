#import "@preview/cetz:0.4.2": *

#let variation_field() = {
  canvas({
  import draw: *

  // Define styles
  let axis-style = (stroke: (thickness: 1.5pt, cap: "round"))
  let red-color = rgb("#f08080") // Light coral/salmon for "generating variation"
  let blue-color = rgb("#4169e1") // Royal blue for "main propagation"

  // Vertical Axis (J)
  line((0, -1), (0, 3), mark: (end: ">", size: 0.2), ..axis-style, name: "y-axis")
  
  // Horizontal Axis (I)
  line((0, 0), (6, 0), mark: (end: ">", size: 0.2), ..axis-style, name: "x-axis")

  // Label J
  content((0, 3.2), text(size: 14pt)[J], anchor: "south")
  
  // Text "generating variation"
  // Positioned to the right of the J label
  content((2, 3.2), text(fill: red-color, size: 12pt)[generating variation])

  // Label I
  content((6.2, 0), text(size: 14pt)[I], anchor: "west")

  // Text "main propagation"
  // Positioned below the I label
  content((6, -0.5), text(fill: blue-color, size: 12pt)[main propagation])
})
}

#let jumping() = {
  canvas({
  import draw: *

  // --- Configuration ---
  let origin = (0, 0)
  let scale = 1.5
  
  // Vector Endpoints
  // Incoming tangent (horizontal right)
  let v-in = (2.5 * scale, 0)
  // Outgoing tangent (vertical down)
  let v-out = (0, -1.5 * scale)

  // --- Curves ---
  // 1. Incoming Curve (Left)
  // A bezier curve starting from bottom-left and becoming horizontal at (0,0)
  bezier(
    (-4 * scale, -1.5 * scale), 
    origin, 
    (-2 * scale, 0.5), // Control point 1
    (-1 * scale, 0)    // Control point 2 (aligned with origin y=0 for horizontal tangent)
  )

  // 2. Outgoing Curve (Right)
  // A bezier curve starting vertical at (0,0) and curving slightly right
  bezier(
    origin, 
    (1.5 * scale, -2.5 * scale), 
    (0, -1 * scale),   // Control point 1 (aligned with origin x=0 for vertical tangent)
    (0.5 * scale, -2 * scale) // Control point 2
  )

  // --- Vectors ---
  // Horizontal Vector (gamma'(a_i-))
  line(origin, v-in, mark: (end: "stealth", size: 0.25), stroke: (thickness: 1.2pt))
  
  // Vertical Vector (gamma'(a_i+))
  line(origin, v-out, mark: (end: "stealth", size: 0.25), stroke: (thickness: 1.2pt))

  // Dashed Difference Vector (Delta gamma')
  // Connects tip of v-in to tip of v-out
  line(v-in, v-out, 
    stroke: (dash: "dashed", thickness: 1pt), 
    mark: (end: "stealth", size: 0.25),
    name: "delta-vec"
  )

  // --- Point ---
  circle(origin, radius: 0.08, fill: black)

  // --- Labels ---
  // Top Label
  content((0, 0.2), text(size: 14pt)[$gamma(a_i)$], anchor: "south")
  
  // Delta Vector Label
  // Positioned relative to the dashed line midpoint
  content("delta-vec", text(size: 14pt)[$quad Delta_i gamma'$], anchor: "south-west")

})
}