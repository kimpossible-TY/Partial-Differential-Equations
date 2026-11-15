// Compatibility facade for the local Typst packages used by this project.
#import "@local/text-utils:0.1.2": *
#import "@local/math-blocks:0.2.0": *
#import "@local/scoped-annotations:0.3.0": *
#import "@local/cetz-helpers:0.2.0": *
#import "@preview/mannot:0.4.0": *

// ---------- Marks ----------
#let rmark = mark.with(color: red)
#let bmark = mark.with(color: blue)
#let pmark = mark.with(color: purple)

// Theme-aware stroke for cancellation marks: follows the warning border color,
// so it stays legible in both light (#d63031) and dark (#ff9aa2) themes.
// The theme is selected by main.typ through `--input theme=...`.
#let cancelstroke = (
  paint: if sys.inputs.at("theme", default: "light") == "dark" {
    dark-theme.callouts.warning.border
  } else {
    light-theme.callouts.warning.border
  }
)

// Theme-aware cancellation mark. Use this instead of the bare `cancel(...)`,
// which keeps Typst's default black stroke and ignores the theme. Pass
// `stroke:` only to keep an intentional non-red emphasis, and pass other
// `cancel` options such as `cross:` through the remaining arguments.
#let cancelmark(body, stroke: auto, ..args) = {
  math.cancel(
    body,
    stroke: if stroke == auto { cancelstroke } else { stroke },
    ..args,
  )
}

// Define differential operator
#let dx = $upright(d) x$

// Use a wider tilde accent by default while preserving per-call overrides.
#let tilde(body, size: 150%) = math.tilde(body, size: size)
