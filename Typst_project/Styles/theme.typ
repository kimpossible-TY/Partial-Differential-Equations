// Shared document palettes. Pick one in main.typ, then apply it through
// #set page(fill: ...) and #set text(fill: ...).
#let light-theme = (
  page: white,
  text: luma(0%),
  rule: rgb("#2c3e50"),
  subtle-text: rgb("#34495e"),
  muted-text: rgb("#7f8c8d"),
  highlight: rgb("#FFFE80"),
  callouts: (
    note: (bg: rgb("#f8f9fa"), border: rgb("#2c3e50")),
    warning: (bg: rgb("#fef5f5"), border: rgb("#d63031")),
    important: (bg: rgb("#f0ebf8"), border: rgb("#6c5ce7")),
    tip: (bg: rgb("#ebf5e6"), border: rgb("#27ae60")),
    theorem: (bg: rgb("#fdf2f2"), border: rgb("#d9534f")),
    proposition: (bg: rgb("#f0f5ff"), border: rgb("#4a90e2")),
    definition: (bg: rgb("#fffbe6"), border: rgb("#f5a623")),
    lemma: (bg: rgb("#f0fff0"), border: rgb("#50c878")),
    emphasis: (bg: none, border: black),
  ),
)

#let dark-theme = (
  page: rgb("#10151f"),
  text: rgb("#e8edf3"),
  rule: rgb("#94a9c4"),
  subtle-text: rgb("#c9d4e2"),
  muted-text: rgb("#95a3b5"),
  highlight: rgb("#665c1f"),
  callouts: (
    note: (bg: rgb("#18202c"), border: rgb("#89a6c7")),
    warning: (bg: rgb("#2a171b"), border: rgb("#ff8f9a")),
    important: (bg: rgb("#211a32"), border: rgb("#b9a3ff")),
    tip: (bg: rgb("#152517"), border: rgb("#75d58a")),
    theorem: (bg: rgb("#281b20"), border: rgb("#ff9aa2")),
    proposition: (bg: rgb("#152033"), border: rgb("#83b7ff")),
    definition: (bg: rgb("#2a2415"), border: rgb("#f2c166")),
    lemma: (bg: rgb("#142617"), border: rgb("#78d89a")),
    emphasis: (bg: none, border: rgb("#c9d4e2")),
  ),
)

#let theme-from-text-fill() = {
  if text.fill == dark-theme.text {
    dark-theme
  } else {
    light-theme
  }
}
