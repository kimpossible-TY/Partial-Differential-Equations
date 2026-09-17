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

// Define differential operator
#let dx = $upright(d) x$

// Use a wider tilde accent by default while preserving per-call overrides.
#let tilde(body, size: 150%) = math.tilde(body, size: size)
