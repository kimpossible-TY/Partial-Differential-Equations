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


