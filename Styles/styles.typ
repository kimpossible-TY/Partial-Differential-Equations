// Compatibility facade for the local Typst packages used by this project.
#import "@local/text-utils:0.1.1": *
#import "@local/math-blocks:0.2.0": *
#import "@local/scoped-annotations:0.2.0": *
#import "@local/cetz-helpers:0.1.0": *
#import "@preview/mannot:0.4.0": *

// ---------- Marks ----------
#let rmark = mark.with(color: red)
#let bmark = mark.with(color: blue)
#let pmark = mark.with(color: purple)

// Define differential operator
#let dx = $upright(d) x$

// Use a wider tilde accent by default while preserving per-call overrides.
#let tilde(body, size: 150%) = math.tilde(body, size: size)

// ---------- TITLE OF BOOK ----------
#let book-title(body) = {
  v(8em)
  text(font: "Rockwell", size: 36pt, weight: "bold")[#body]
}

// ---------- AUTHOR ----------
#let author-name(body) = {
  v(1.5em)
  text(font: "Copperplate", size: 24pt, weight: "medium")[#body]
}
