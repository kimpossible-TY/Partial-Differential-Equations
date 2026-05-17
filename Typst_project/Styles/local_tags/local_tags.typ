// Reusable local tag scopes.
//
// A scope converts short local names into stable, globally unique names.
// Plugin-specific modules can build on this without duplicating prefix logic.

#let _local-tag-scope-counter = counter("_local-tag-scope-counter")

#let local-tag-scope(
  body,
  prefix: auto,
  namespace: "local-scope",
) = {
  let make-scope(prefix) = {
    let name = local-name => prefix + "-" + local-name
    let names = local-names => local-names.map(name)
    let tag = local-name => label(name(local-name))
    let tags = local-names => local-names.map(tag)
    let anchor = (local-name, side) => name(local-name) + "." + side

    body((
      prefix: prefix,
      name: name,
      names: names,
      tag: tag,
      tags: tags,
      anchor: anchor,
    ))
  }

  if prefix == auto {
    _local-tag-scope-counter.step()

    context {
      let n = _local-tag-scope-counter.get().first()
      make-scope(namespace + "-" + str(n))
    }
  } else {
    make-scope(prefix)
  }
}
