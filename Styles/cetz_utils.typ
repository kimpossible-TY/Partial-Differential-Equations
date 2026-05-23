#import "@preview/cetz:0.4.2": *

// Reusable legend box function for CeTZ
#let legend_box(
  x: 0,
  y: 0,
  width: 8.7,
  items: (),
  item_spacing: 0.5,
  bg_fill: rgb("f0f0f0"),
  border_stroke: rgb(80, 80, 80),
  title: none,
) = {
  import draw: *

  let padding = 0.5
  let line_len = 1.0
  let line_x_start = x + padding
  let text_x_start = line_x_start + line_len + 0.3
  let start_y = y - padding

  // Calculate height based on items
  let content_height = (items.len() - 1) * item_spacing
  let box_height = content_height + (padding * 2)
  // If there's a title, we might need more space, but simpler for now to just start items
  // Let's assume title is TODO for now or simple addition.
  // The user didn't explicitly ask for title support but "new box" implies flexibility.

  let box_bottom = y - box_height

  group({
    // Draw background box
    rect((x, y), (x + width, box_bottom), fill: bg_fill, stroke: border_stroke)

    // Draw items
    for (i, item) in items.enumerate() {
      let row_y = start_y - i * item_spacing

      // Draw the icon/line
      // We assume mostly lines for now as per the use case
      if item.at("stroke", default: none) != none {
        line((line_x_start, row_y), (line_x_start + line_len, row_y), stroke: item.stroke, mark: item.at(
          "mark",
          default: none,
        ))
      }

      // Draw the text
      content((text_x_start, row_y), anchor: "west")[
        #text(size: 9pt)[#item.text]
      ]
    }
  })
}

// Reusable description box for CeTZ
#let description_box(
  x: 0,
  y: 0,
  width: auto,
  body: none,
  bg_fill: rgb("f0f0f0"),
  border_stroke: rgb(80, 80, 80),
  box_anchor: "north-west",
  text_size: 8pt,
) = {
  import draw: *

  content(
    (x, y),
    box(
      width: width,
      inset: 5pt,
      text(size: text_size, body),
    ),
    anchor: box_anchor,
    fill: bg_fill,
    stroke: border_stroke,
    frame: "rect",
  )
}

