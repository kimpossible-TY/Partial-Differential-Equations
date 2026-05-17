---
trigger: always_on
---

## the order of import
```typst
#import "../Styles/styles.typ" : *
#import "figures.typ" : * // this should be on the mannot.
#import "@preview/mannot:0.3.1": *
```

## spaceing role(including `#paragraph_tab` role)
- the empty line should be exist before `#paragraph_tab`
- Don't insert `#paragraph_tab` between equation block and equation block.
- Don't use `#paragraph_tab` before equation blocks.
- Don't use `#paragraph_tab` before headings.
- after, write `#footnote`, the empty line should not be exist after `#footnote`.


## highlight
- If there are some equations, don't use `highlight` instead of `highlighted`.
- However, if there are only text, use `highlight`.

for example :
```typst
#highlighted[
This approach makes that we can treat $i_(partial_j) omega$ as just the general interior multiplication not considering $d x^i(partial_j) = delta_j^i$!
]
```

## paragraph break
Use the function `#paragraph_tab`

```typst
// for example
#paragraph_tab 
As we know from Proposition 16.33 of _Introduction to Smooth Manifolds_, the divergence operator can be written:
$ Z_X V = ( op("div") X) omega = d(i_X omega) $
```

## Equations

### Equations blocks
#### flowbox
if treating complicated argument logically, use `flowbox`. Ensure that all steps and connecting arrows (like `$arrow.b$`) are contained *within* the `flowbox`. For example :
```typst
#flowbox[
$ 
    omega  = sqrt(det(g)) d x_1 and dots and d x_n #dots_space #footnote[by proposition 15.31 of _Introduction to Smooth Manifolds_] 
$
$arrow.b$

"How about" $d(i_X omega)$?

]

The arrow should be inline math.

```
#### Definition, theorem, Lemma , Note, proposition,  Special Lemma, Speical Proposition and Special Definition
Something will be auto-numbering, but something is not.
- auto-numbering
 - Definition
 - Note
 - Special Lemma, Speical Proposition and Special Definition

Others(Lemma, proposition, theorem) are not auto-numbering.

```typ
// definition is auto-numbering.
#definition[Let $pi: E -> M$ be a smooth vector bundle over a smooth manifold $M$ with or without boundary, and let $Gamma(E)$ denote the space of smooth sections of $E$. A connection in $E$ is a map:

$ nabla : frak(X)(M) times Gamma(E) -> Gamma(E) $

Written $(X, Y) |-> nabla_X Y$, satisfying the following properties:

+ $nabla_X Y$ is linear over $C^infinity(M)$ in $X$: for $f_1, f_2 in C^infinity(M)$ and $X_1, X_2 in frak(X)(M)$,$ nabla_(f_1 X_1 + f_2 X_2) Y = f_1 nabla_(X_1) Y + f_2 nabla_(X_2) Y $

+ $nabla_X Y$ is linear over $RR$ in $Y$: for $a_1, a_2 in RR$ and $Y_1, Y_2 in Gamma(E)$,$ nabla_X (a_1 Y_1 + a_2 Y_2) = a_1 nabla_X Y_1 + a_2 nabla_X Y_2 $

+ $nabla$ satisfies the following product rule: for $f in C^infinity(M)$, $ nabla_X (f Y) = f nabla_X Y + (X f) Y $
]

// proposition is not auto-numbering, so that you should write numberse manually.
#proposition[4.3 (Restriction of a connection): Suppose $nabla$ is a connection in a smooth vector bundle $E -> M$. For every open subset $U subset.eq M$, there is a unique connection $nabla^U$ on the restricted bundle $E|_U$ that satisfies the following relation for every open subset $X in frak(X)(M)$ and $Y in Gamma(E)$:

$ nabla_(X|_U)^U (Y|_U) = (nabla_X Y)|_U $
]
```

Those seperation is becuase what are not auto-numbering came from text-book.

#### proof
you have to write the proof inside of the `#proof` function.

for example :
```typst
#proof[$nabla^U|_p$ is the connection which treats the local vector field and local section, not restricted global section and vector field.

#paragraph_tab
Now let's think about $tilde(X)$ and $tilde(Y)$ satisfying $tilde(X) = X$ and $tilde(Y) = Y$ only on $p$. In addition, we can extend $X|_U$ and $Y|_U$ via the smooth bump functions. We denote them $X|_U^phi$ and $Y|_U^phi$.

#paragraph_tab
However, the Lemma 4.1 guarantees:

$
nabla_(X|_U)^U (Y|_U) &= nabla_(X|_U^phi)^U (Y|_U^phi) \
&= nabla_(tilde(X)) tilde(Y)|_p #dots_space #footnote[by Lemma 4.1]
$

#paragraph_tab
Therefore, the result of $nabla^U$ is unique whatever the vector field and sections locally are. This shows that $nabla^U$ is uniquely defined.
]
```

### Footnotes in equation
```typst
use `dots_space` before `footnote`.

for example : 
$
i_(partial_j) omega &= f [ i_(partial_j) (d x^j) and beta + (-1)^(deg d x^j) d x^j and i_(partial_j) (beta) ] \
&= f beta 
#dots_space #footnote[by Lemma 14.13 of _Introduction to Smooth Manifolds_ because $d x^j(partial_j) = 1$, $beta$ doesn't have $d x^j$]
$
```

If the footnote isn't in equation block or inline equation, don't use `dots_space`.

### equation alignment
check what is differnct between Latex's style math alighment and Typst's style math alignment.

```typst
$
(op("div") X) omega &= (op("div") X) sqrt(det(g)) d x_1 and dots and d x_n \
d(i_X omega) &= ( sum_i partial_i (X^i sqrt(det g)) ) d x^1 and dots and d x^n \
therefore op("div") X &= 1 / sqrt(det g) partial_j (sqrt(det g) X^j) & 
#dots_space #footnote["where the summation convention is used."]
$
```

# plugin usage rule
## local tag scopes

Use the reusable local tag system when a feature needs short names that must become globally unique labels or anchor names. The implementation lives in `Typst_project/Styles/local_tags/local_tags.typ` and is re-exported by `Typst_project/Styles/styles.typ`.

```typst
#local-tag-scope(s => [
  $ x $ #(s.tag)("x")

  // Use the globally unique plain name when a plugin needs a string key.
  #(s.name)("x")
])
```

The scope dictionary provides:

* `(s.tag)("name")` for a scoped Typst label.
* `(s.tags)(("a", "b"))` for several scoped labels.
* `(s.name)("name")` for the scoped string name.
* `(s.names)(("a", "b"))` for several scoped string names.
* `(s.anchor)("name", "north")` for anchor-style strings such as `scope-name.north`.

Prefer building plugin-specific wrappers on top of `local-tag-scope` instead of duplicating counter and prefix logic.

## mannot
### local mannot scope

`mannot-scope` is the mannot/CeTZ wrapper around the general `local-tag-scope` system.

Use `mannot-scope` when writing several `mannot` annotations in the same file.  
The purpose of `mannot-scope` is to avoid manually writing globally unique tags such as `<special_lemma_2_9_nabla>`, `<special_lemma_2_9_g>`, and so on.

Conceptually, it works as follows:

```text
local tag name -> automatically prefixed global label
```

Therefore, inside each `mannot-scope`, short local names such as `"nabla"`, `"g"`, `"u"`, `"position"`, and `"outside"` can be reused safely.

#### Basic rule

Do not write raw mannot labels manually unless there is a special reason.

```typst
// bad
mark(nabla_i, tag: #<nabla>)
mark(g^(j k), tag: #<g>)
```

Instead, use `(s.tag)(...)` inside `mannot-scope`.

```typst
// good
#mannot-scope(s => [
  $
    mark(nabla_i, tag: #(s.tag)("nabla"))
    mark(g^(j k), tag: #(s.tag)("g"))
  $
])
```

The expression

```typst
#(s.tag)("nabla")
```

creates a globally unique label from the local name `"nabla"`.

#### Full example

```typst
#mannot-scope(s => [
  $
    mark(nabla_i, tag: #(s.tag)("nabla"))
    mark(g^(j k), tag: #(s.tag)("g"))
    mark(nabla_k u, tag: #(s.tag)("u"))

    #(s.annot)(
      ("nabla", "g", "u"),
      cetz,
      {
        import cetz.draw: *
        set-style(mark: (end: "straight"))

        // nabla_i acts on g^(j k).
        // This term vanishes by metric compatibility.
        bezier-through(
          (s.node)("nabla", "north"),
          (rel: (x: 0.3, y: 0.5)),
          (s.node)("g", "north"),
          stroke: red,
        )

        // nabla_i acts on nabla_k u.
        bezier-through(
          (s.node)("nabla", "south"),
          (rel: (x: 0.8, y: -0.2)),
          (s.node)("u", "south"),
          stroke: blue,
        )
      },
    )
  $
])
```

#### How to refer to CeTZ anchors

Inside the CeTZ drawing block, do not write the raw anchor name directly.

```typst
// bad
bezier-through("nabla.north", ..., "g.north")
```

Instead, use `(s.node)(name, side)`.

```typst
// good
bezier-through(
  (s.node)("nabla", "north"),
  (rel: (x: 0.3, y: 0.5)),
  (s.node)("g", "north"),
  stroke: red,
)
```

The second argument of `(s.node)` is the anchor direction, such as:

```typst
"north"
"south"
"east"
"west"
"center"
```

#### Dictionary function call rule

Since `s` is a dictionary, its stored functions must be called with parentheses around the field access.

```typst
// wrong
s.tag("nabla")
s.node("nabla", "north")
s.annot(...)
```

Use this form instead:

```typst
// correct
(s.tag)("nabla")
(s.node)("nabla", "north")
(s.annot)(...)
```

#### Multiple independent annotations

Different `mannot-scope` blocks may reuse the same local names.

```typst
#mannot-scope(s => [
  $
    mark(hat(dx)^i, tag: #(s.tag)("position"))
    mark(dx^i, tag: #(s.tag)("outside"))

    #(s.annot)(
      ("position", "outside"),
      cetz,
      {
        import cetz.draw: *
        set-style(mark: (end: "straight"))

        bezier-through(
          (s.node)("position", "south"),
          (rel: (x: -1.6, y: -0.5)),
          (s.node)("outside", "west"),
          stroke: red,
        )
      },
    )
  $
])
```

This is safe even if another `mannot-scope` also uses `"position"` or `"outside"`, because each scope automatically generates a distinct prefix.

#### Manual prefix

If the annotation needs a stable and readable internal namespace, provide `prefix`.

```typst
#mannot-scope(
  s => [
    $
      mark(nabla_i, tag: #(s.tag)("nabla"))
      mark(g^(j k), tag: #(s.tag)("g"))

      #(s.annot)(
        ("nabla", "g"),
        cetz,
        {
          import cetz.draw: *

          bezier-through(
            (s.node)("nabla", "north"),
            (rel: (x: 0.3, y: 0.5)),
            (s.node)("g", "north"),
            stroke: red,
          )
        },
      )
    $
  ],
  prefix: "special-lemma-2-9",
)
```

In this case, the local name `"nabla"` is internally converted into a label similar to:

```text
special-lemma-2-9-nabla
```

Usually, however, omit `prefix` and let `mannot-scope` generate it automatically.

#### Practical rules

* Use `mannot-scope` for new mannot annotations.
* Use `annot-cetz-local`, not `#annot-cetz`.
* Use `(s.tag)("local-name")` for `mark(..., tag: ...)`.
* Use `(s.node)("local-name", "direction")` inside CeTZ drawing code.
* Use `(s.annot)((...), cetz, { ... })` to draw the annotation.
* Keep the `mark(...)` calls and the corresponding `(s.annot)(...)` call close to each other, preferably in the same displayed equation block.
* Do not manually reuse raw labels like `<x>`, `<nabla>`, `<position>`, or `<target>` across the document.

summary :
```typst
#mannot-scope(s => [
  $
    mark(..., tag: #(s.tag)("a"))
    mark(..., tag: #(s.tag)("b"))

    #(s.annot)(
      ("a", "b"),
      cetz,
      {
        import cetz.draw: *

        bezier-through(
          (s.node)("a", "north"),
          (rel: (x: 0.3, y: 0.5)),
          (s.node)("b", "north"),
          stroke: red,
        )
      },
    )
  $
])
