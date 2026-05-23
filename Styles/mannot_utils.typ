#import "@preview/mannot:0.3.3" : *
#import "local_tags.typ": local-tag-scope

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

#let mannot-scope(
  body,
  prefix: auto,
  parent: auto,
  name: auto,
) = {
  let scope-prefix = if prefix != auto {
    prefix
  } else if parent != auto and name != auto {
    (parent.name)(name)
  } else {
    auto
  }

  let namespace = if parent != auto and name == auto {
    parent.prefix + "-mannot-scope"
  } else {
    "mannot-scope"
  }

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
      ref: scope.ref,
      annot: annot,
    ))
  }, prefix: scope-prefix, namespace: namespace)
}
