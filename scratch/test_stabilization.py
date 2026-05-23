import subprocess

# Read mannot_utils.typ
with open("Styles/mannot_utils.typ", "r") as f:
    original_mannot_utils = f.read()

# Define the custom core-annot, annot, and annot-cetz in mannot_utils.typ
stabilized_code = """
// --- Stabilized Mannot ---
#let stable-len(l) = {
  if type(l) == length {
    calc.round(l.to-absolute().pt() * 2) / 2 * 1pt
  } else {
    l
  }
}

#let core-annot(
  tag,
  overlay,
) = {
  if type(tag) == label {
    tag = (tag,)
  }

  context {
    let markers = tag.map(tag => query(selector(tag).before(here())).last().value)
    let hpos = here().position()
    
    let stable-hx = stable-len(hpos.x)
    let stable-hy = stable-len(hpos.y)

    math.equation(
      place(
        dx: -stable-hx,
        dy: -stable-hy,
        float: false,
        left + top,
        overlay(markers),
      ),
      block: false,
    )
  }
}

#let annot(
  tag,
  annotation,
  pos: bottom,
  dx: auto,
  dy: auto,
  leader: auto,
  leader-stroke: .048em,
  leader-tip: none,
  leader-toe: tiptoe.straight.with(length: 600%),
  leader-connect: (center + horizon, center + horizon),
  annot-inset: (x: .08em, y: .16em),
  annot-alignment: auto,
  annot-text-props: (size: .7em),
  annot-par-props: (leading: .4em),
) = {
  pos = _coerce-pos(pos)

  if dx == auto {
    dx = if pos.at(0).x == left and pos.at(1).x == right {
      -.2em
    } else if pos.at(0).x == right and pos.at(1).x == left {
      .2em
    } else {
      0em
    }
  }
  if dy == auto {
    dy = if pos.at(0).y == top and pos.at(1).y == bottom {
      -.2em
    } else if pos.at(0).y == bottom and pos.at(1).y == top {
      .2em
    } else {
      0em
    }
  }

  if type(annot-inset) != dictionary {
    annot-inset = (annot-inset,)
  }

  annotation = {
    show: pad.with(..annot-inset)
    set par(..annot-par-props)
    text(..annot-text-props, annotation)
  }

  context {
    let dx = dx.to-absolute()
    let dy = dy.to-absolute()
    let annot-size = measure(annotation)
    let aw = annot-size.width
    let ah = annot-size.height

    let overlay(markers) = {
      let x = stable-len(markers.first().x)
      let y = stable-len(markers.first().y)
      let w = stable-len(markers.first().width)
      let h = stable-len(markers.first().height)
      let c = markers.first().color

      let leader-stroke = default-stroke(leader-stroke, paint: c, thickness: .048em)
      leader-stroke = copy-stroke(leader-stroke, thickness: leader-stroke.thickness.to-absolute())

      let ax = if pos.at(0).x == left { x } else if pos.at(0).x == right { x + w } else { x + w / 2 }
      ax -= if pos.at(1).x == left { 0pt } else if pos.at(1).x == right { aw } else { aw / 2 }
      ax += dx

      let ay = if pos.at(0).y == top { y } else if pos.at(0).y == bottom { y + h } else { y + h / 2 }
      ay -= if pos.at(1).y == top { 0pt } else if pos.at(1).y == bottom { ah } else { ah / 2 }
      ay += dy

      let annot-text-fill = annot-text-props.at("fill", default: c)
      let annot-alignment = if annot-alignment == auto {
        if ax + aw / 2 < x + w / 2 { right } else { left }
      } else {
        annot-alignment
      }
      let annotation = {
        show: box.with(width: aw, height: ah)
        set align(annot-alignment)
        set text(annot-text-fill)
        annotation
      }

      place(dx: stable-len(ax), dy: stable-len(ay), float: false, left + top, annotation)

      if leader != false {
        for info in markers {
          let x = stable-len(info.x)
          let y = stable-len(info.y)
          let w = stable-len(info.width)
          let h = stable-len(info.height)

          if leader == auto {
            let dst = calc.max(
              ax - x - w,
              x - ax - aw,
              ay - y - h,
              y - ay - ah,
            )
            if dst <= .3em.to-absolute() {
              continue
            }
          }

          if type(leader-connect) == array {
            let c0x = if leader-connect.at(0).x == left {
              x
            } else if leader-connect.at(0).x == right {
              x + w
            } else {
              x + w / 2
            }
            let c0y = if leader-connect.at(0).y == top {
              y
            } else if leader-connect.at(0).y == bottom {
              y + h
            } else {
              y + h / 2
            }
            let c1x = if leader-connect.at(1).x == left {
              ax
            } else if leader-connect.at(1).x == right {
              ax + aw
            } else {
              ax + aw / 2
            }
            let c1y = if leader-connect.at(1).y == top {
              ay
            } else if leader-connect.at(1).y == bottom {
              ay + ah
            } else {
              ay + ah / 2
            }
            let cdx = c1x - c0x
            let cdy = c1y - c0y

            let l0x = c0x
            let l0y = c0y
            let l1x = c1x
            let l1y = c1y

            if leader-connect.at(0) == center + horizon {
              if calc.abs(cdx.pt()) * h < calc.abs(cdy.pt()) * w {
                if cdy > 0pt {
                  l0x = c0x + h / 2 / cdy * cdx
                  l0y = y + h
                } else {
                  l0x = c0x - h / 2 / cdy * cdx
                  l0y = y
                }
              } else {
                if cdx > 0pt {
                  l0x = x + w
                  l0y = c0y + w / 2 / cdx * cdy
                } else {
                  l0x = x
                  l0y = c0y - w / 2 / cdx * cdy
                }
              }
            }

            if leader-connect.at(1) == center + horizon {
              if calc.abs(cdx.pt()) * ah < calc.abs(cdy.pt()) * aw {
                if cdy > 0pt {
                  l1x = c1x - ah / 2 / cdy * cdx
                  l1y = ay
                } else {
                  l1x = c1x + ah / 2 / cdy * cdx
                  l1y = ay + ah
                }
              } else {
                if cdx > 0pt {
                  l1x = ax
                  l1y = c1y - aw / 2 / cdx * cdy
                } else {
                  l1x = ax + aw
                  l1y = c1y + aw / 2 / cdx * cdy
                }
              }
            }

            {
              set place(left + top, float: false) // For RTL document.
              tiptoe.curve(
                stroke: leader-stroke,
                tip: leader-tip,
                toe: leader-toe,
                curve.move((stable-len(l0x), stable-len(l0y))),
                curve.line((stable-len(l1x), stable-len(l1y))),
              )
            }
          }
        }
      }
    }

    return core-annot(tag, overlay)
  }
}
"""

try:
    with open("Styles/mannot_utils.typ", "w") as f:
        # Append the custom core-annot and annot at the end
        f.write(original_mannot_utils + stabilized_code)
    print("Injected stabilized annot and core-annot into Styles/mannot_utils.typ")
    
    # Compile
    res = subprocess.run(
        ["typst", "compile", "--root", ".", "main.typ", "scratch/test_stabilization.pdf"],
        capture_output=True,
        text=True
    )
    print("Compilation exit code:", res.returncode)
    print("Stderr:")
    print(res.stderr)

finally:
    # Revert
    with open("Styles/mannot_utils.typ", "w") as f:
        f.write(original_mannot_utils)
    print("Reverted mannot_utils.typ")
