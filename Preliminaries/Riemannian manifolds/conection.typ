#import "../../Styles/styles.typ" : *
#import "figures.typ" : *
#import "@preview/mannot:0.3.3": *

=== Connections

#definition[Let $pi: E -> M$ be a smooth vector bundle over a smooth manifold $M$ with or without boundary, and let $Gamma(E)$ denote the space of smooth sections of $E$. A connection in $E$ is a map:

$ nabla : frak(X)(M) times Gamma(E) -> Gamma(E) $

Written $(X, Y) |-> nabla_X Y$, satisfying the following properties:

+ $nabla_X Y$ is linear over $C^infinity (M)$ in $X$: for $f_1, f_2 in C^infinity (M)$ and $X_1, X_2 in frak(X)(M)$,$ nabla_(f_1 X_1 + f_2 X_2) Y = f_1 nabla_(X_1) Y + f_2 nabla_(X_2) Y $

+ $nabla_X Y$ is linear over $RR$ in $Y$: for $a_1, a_2 in RR$ and $Y_1, Y_2 in Gamma(E)$,$ nabla_X (a_1 Y_1 + a_2 Y_2) = a_1 nabla_X Y_1 + a_2 nabla_X Y_2 $

+ $nabla$ satisfies the following product rule: for $f in C^infinity (M)$, $ nabla_X (f Y) = f nabla_X Y + markul((X f), color: #blue, tag: #<definition_of_covariant_derivative_of_scalar>) Y $ #annot(<definition_of_covariant_derivative_of_scalar>)[define $nabla_X f$:=$X f$]
] <basic_properties_of_connection>

#note[In differential geometry, the symbol ∇ is overloaded. To make the formula work, we must rely on a universal convention that extends the connection to scalar functions. By definition, for any scalar function $f$: 
$
  nabla_X f:=X f
$
]<definition_of_covariant_derivative_of_scalar_function>

#definition[The symbol $nabla$ is read "del" or "nabla", and $nabla_X Y$ is called the covariant derivative of $Y$ in the direction $X$.
]

#paragraph_tab
What does the connections do? As we know its name, it is not just a 'derivative'. A connection tells we how to differentiate those sections along vector fields — #highlighted[it "connects" the geometry of the manifold (directions = vector fields) with the data living in a vector bundle (sections).]


#paragraph_tab
Although a connection is defined by its action on global sections, it follows from the definitions that it is actually a local operator, as the next lemma shows.


#lemma(title: "Locality")[Suppose $nabla$ is a connection in a smooth vector bundle $E -> M$. For every $X in frak(X)(M)$, $Y in Gamma(E)$, and $p in M$ the covariant derivative $nabla_X Y|_p$ depends only on the values of $X$ and $Y$ in an arbitrarily small neighborhood of $p$.
More precisely, If $X = tilde(X)$ and when $Y = tilde(Y)$ on a neighborhood of $p$, then
$ nabla_X Y|_p = nabla_(tilde(X)) tilde(Y)|_p $
] <Lemma4.1>


#proof[Actually the assertion is easily inferred, #highlight[because the every linearities always guaranteed it. So, it is nice try to consider using the linear properties of connection to prove the lemma.]

#paragraph_tab
However those properties are defined globally, not locally.#footnote[It is not just from a guesswork. We have been experienced when treating the 'partition of unity'.]
Thus we introduce a smooth bump function so that it appears to operate locally. In addition, the conditions $X = tilde(X)$ and $Y = tilde(Y)$ on a neighborhood of $p$ mean that the covariant derivative is injective, define $Y' := Y - tilde(Y)$. Since $Y = tilde(Y)$, $Y'$ is zero on a neighborhood of $p$.

#paragraph_tab
Now let's restrict the covariant derivative using the smooth bump function. Since $Y'$ is locally zero nearby $p$, $phi Y' = 0$ identically. By the product rule of connection, we have:


$ nabla_X (phi Y') = (X phi) Y' + phi (nabla_X Y') $


#paragraph_tab
#highlighted[Now, we use some trick. Since $phi Y'$ is identically zero, $0 dot phi Y'$ is zero too. By the linearity of covariant derivative, thus we get:]


$
nabla_X (phi Y) &= nabla_X (0 dot phi Y) \
&= 0 nabla_X (phi Y) \
&= 0
$

#flowbox[
$
0 = (X phi) Y' + phi (nabla_X Y')
\
arrow.b
\
nabla_X Y|_p = 0
$
]

#paragraph_tab
The first term on the right is identically zero, because $phi Y'$ is identically zero. Then $phi (nabla_X Y')$ must be identically zero. Since $phi$ is zero whatever the input is outside of the neighborhood of $p$, it suffices that $nabla_X Y$ is zero on a neighborhood of $p$ to make is identically zero. It implies that $nabla_X Y|_p = 0$.

#paragraph_tab
The argument for $X$ is similar but easier.
]

#paragraph_tab
#note[This lemma essentially states that the value of $nabla_X Y$ at a point $p$ only depends on the behavior of $X$ and $Y$ in an arbitrarily small neighborhood of $p$, not depending on the whole $X$ and $Y$.]

#paragraph_tab
As the above, we treated the restriction of sections. Now, How about restrict the connection?

#proposition(title: "Restriction of a connection")[Suppose $nabla$ is a connection in a smooth vector bundle $E -> M$. For every open subset $U subset.eq M$, there is a unique connection $nabla^U$ on the restricted bundle $E|_U$ that satisfies the following relation for every open subset $X in frak(X)(M)$ and $Y in Gamma(E)$:

$ nabla_(X|_U)^U (Y|_U) = (nabla_X Y)|_U $
]<proposition4.3>

#paragraph_tab
#proof[$nabla^U|_p$ is the connection which treats the local vector field and local section, not restricted global section and vector field.

#paragraph_tab
Now let's think about $tilde(X)$ and $tilde(Y)$ satisfying $tilde(X) = X$ and $tilde(Y) = Y$ only on $p$. In addition, we can extend $X|_U$ and $Y|_U$ via the smooth bump functions. We denote them $X|_U^phi$ and $Y|_U^phi$.

#paragraph_tab
However, the @Lemma4.1 guarantees:

$
nabla_(X|_U)^U (Y|_U) &= nabla_(X|_U^phi)^U (Y|_U^phi) \
&= nabla_(tilde(X)) tilde(Y)|_p #dots_space #footnote[by @Lemma4.1]
$

#paragraph_tab
Therefore, the result of $nabla^U$ is unique whatever the vector field and sections locally are. This shows that $nabla^U$ is uniquely defined.
]

#paragraph_tab
#note[@proposition4.3 treats the vector fields and sections which are defined at local, and the other which are defined at global first, but restricted.]

==== Connections In The Tangent Bundle

#paragraph_tab
#definition[Suppose $M$ is a smooth manifold with or without boundary. By the definition we just gave, a connection in $T M$ is a map:

$ nabla: frak(X)(M) times frak(X)(M) -> frak(X)(M) $

Satisfying the properties of connection.
]

#definition[Let $(E_i)$ be a smooth local frame for $T M$ on an open subset $U subset.eq M$. For every choice of the indices $i$ and $j$, we can expand the vector field $nabla_(E_i) E_j$ in terms of this same frame:

$ nabla_(E_i) E_j = Gamma_(i j)^k E_k $
] <definition_of_christoffel_symbol>
How can we understand @definition_of_christoffel_symbol intuitively? #highlight[The christoffel symbol describes how much the basis vectors 'twist' as we move along the manifold.]
#figure(
  twist_visualization(),
  caption: "Twist Visualization"
)
The expression $Gamma^(k)_(i j) E_k$ is the vector that represents the "twist" (or more generally, the rate of change) of the basis vector $E_j$ as moving along $E_i$.

#paragraph_tab
As $i, j$ and $k$ range from 1 to $n = dim M$, this defines smooth functions $Gamma_(i j)^k: U -> RR$, called the *connection coefficients* of $nabla$ with respect to the given frame.

#note[The connection coefficients will be developed to a 'geodesics'.]

#note[The indices $i, j$ and $k$ are not dummy indices, but also free indices. They are just placeholders.]

#paragraph_tab
The following proposition shows that the connection is completely determined in $U$ by its connection coefficients.

#proposition(title:"4.6")[Let $M$ be a smooth manifold with or without boundary, and let $nabla$ be a connection in $T M$. Suppose $(E_i)$ is a smooth local frame over an open subset $U subset.eq M$ and ${Gamma_(i j)^k}$ be the connection coefficients of $nabla$ with respect to this frame.


For smooth vector fields $X, Y in frak(X)(M)$, written in terms of the frame as $X := sum_i X^i E_i$ and $Y := sum_j Y^j E_j$ one has:

$ nabla_X Y = (X(Y^k) + X^i Y^j Gamma_(i j)^k) E_k $ <basic_formula_of_connection_in_tangent_bundle>
where the summation convention is used.
]

#proof[It is the result of product rule.

$
nabla_X Y &= nabla_X (Y^j E_j) \
&= X(Y^j) E_j + Y^j nabla_(X^i E_i) E_j #dots_space #footnote[by product rule] \
&= X(Y^j) E_j + X^i Y^j nabla_(E_i) E_j #dots_space #footnote[by linearity of connection] \
&= X(Y^j) E_j + X^i Y^j Gamma_(i j)^k E_k #dots_space #footnote[by the definition of $Gamma_(i j)^k$]
$
]