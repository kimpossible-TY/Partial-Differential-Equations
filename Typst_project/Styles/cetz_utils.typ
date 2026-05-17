#import "@preview/cetz:0.4.2": *
#import "@preview/mannot:0.3.3" : *
#import "local_tags/local_tags.typ": local-tag-scope

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

#let _annot-cetz-local-counter = counter("_annot-cetz-local-counter")

#let annot-cetz-local(
  tag,
  cetz,
  drawable,
  id: auto,
) = {
  let build(id) = {
    let tags = if type(tag) == label {
      (tag,)
    } else {
      tag
    }

    let overlay(markers) = {
      let origin = markers.first()

      let preamble = markers
        .map(info => {
          cetz.draw.rect(
            (info.x - origin.x, -(info.y - origin.y)),
            (
              info.x + info.width - origin.x,
              -(info.y + info.height - origin.y),
            ),
            name: str(info.tag),
            stroke: none,
            fill: none,
          )
        })
        .sum()

      let ref-lab = label("_mannot-annot-cetz-ref-" + str(id))
      let ref-lab-content = cetz.draw.content((0, 0), [#none#ref-lab])

      place([#none#ref-lab])
      place(hide(cetz.canvas(ref-lab-content + preamble + drawable)))

      context {
        let ref-pos-array = query(selector(ref-lab).before(here()))
          .map(e => e.location().position())

        let ref-pos1 = ref-pos-array.at(ref-pos-array.len() - 2)
        let ref-pos2 = ref-pos-array.last()

        place(
          dx: origin.x + ref-pos1.x - ref-pos2.x,
          dy: origin.y + ref-pos1.y - ref-pos2.y,
          cetz.canvas(preamble + drawable),
        )
      }
    }

    core-annot(tags, overlay)
  }

  if id == auto {
    _annot-cetz-local-counter.step()

    context {
      let n = _annot-cetz-local-counter.get().first()
      build("auto-" + str(n))
    }
  } else {
    build(id)
  }
}

#let mannot-scope(body, prefix: auto) = {
  local-tag-scope(scope => {
    let annot = (names, cetz, drawable) => {
      annot-cetz-local(
        (scope.tags)(names),
        cetz,
        drawable,
      )
    }

    body((
      prefix: scope.prefix,
      tag: scope.tag,
      tags: scope.tags,
      name: scope.name,
      names: scope.names,
      node: scope.anchor,
      anchor: scope.anchor,
      annot: annot,
    ))
  }, prefix: prefix, namespace: "mannot-scope")
}
