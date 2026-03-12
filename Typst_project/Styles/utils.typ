// Styles/utils.typ

// Global state for heading numbering style (needed for scoped-numbering)
// Wait, if I move this, I need to make sure it's accessible or passed in.
// `heading-numbering-style` is defined in math_styles currently.
// I should probably move the state definition to utils or styles.typ as well if it's shared.
// For now, let's look at dependencies. `scoped-numbering` uses `heading-numbering-style`.

#let heading-numbering-style = state("heading-numbering-style", "1.1")

// Helper function for scoped numbering
#let scoped-numbering(item-counter) = {
  context numbering(
    heading-numbering-style.get(),
    counter(heading).get().first(),
    item-counter.get().first(),
  )
}

// Helper function to capitalize title (works for string and content)
#let capitalize-title(title) = {
  if title != none {
    // Rule for all lowercase words
    show regex("\b\p{Ll}+\b"): it => {
      let t = it.text
      upper(t.at(0)) + t.slice(1)
    }
    // Rule for all uppercase words (len > 1) to handle ALL CAPS -> Title Case
    show regex("\b\p{Lu}{2,}\b"): it => {
      let t = it.text
      upper(t.at(0)) + lower(t.slice(1))
    }
    // Rule for 1a -> 1A
    show regex("\d\p{Ll}"): it => {
      it.text.at(0) + upper(it.text.at(1))
    }
    title
  }
}


// Helper to check if title is numeric (only numbers and dots)
#let is-numeric-title(title) = {
  if title == none { return true }

  let text = if type(title) == str {
    title
  } else if type(title) == content and title.has("text") {
    title.text
  } else {
    return false
  }

  text.match(regex("^[0-9.]+$")) != none
}
