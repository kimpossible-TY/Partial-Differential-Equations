#import "../Styles/styles.typ" : *
#import "@preview/cetz:0.4.2"

== the Divergence of a Vector Field

#paragraph_tab
As we know from Proposition 16.33 of _Introduction to Smooth Manifolds_, the divergence operator can be written:
$ Z_X V = ( op("div") X) omega = d(i_X omega) $

Now, let's treat $omega$ as the Riemannian volume form. Then we can combine the above equations and the basic properties of Riemannian volume form.
#flowbox[
$
omega  = sqrt(det(g)) d x_1 and dots and d x_n #dots_space #footnote[by proposition 15.31 of _Introduction to Smooth Manifolds_]
\
arrow.b
\
"How about" d(i_X omega)?
$
]

#paragraph_tab
To compute $d(i_X omega)$, let's decompose $X$ to $X = sum_j^n X^j partial_j$. Then $i_X omega$ is:
$
i_X omega &= i_(sum_j^n X^j partial_j) omega \
&= sum_j^n X^j (i_(partial_j) omega) & "by the bilinearity of " i
$

Thus the problem boils down to compute $i_(partial_j) omega$. If we compute it directly, we just get nothing special, in other words, it is useless.
The problem is more complicated. If we adopt this method, we will struggle to compute its exterior derivative.

By the way, if we use (pull) $d x^j$ on the first slot of blade, then the problem would be more clear
$ omega = sqrt(det g) (-1)^(j-1) d x^j and d x^1 and dots and hat(d x^j) and dots and d x^n
#dots_space #footnote[Where hat operator represent the omitted term]

$

#highlighted[
This approach makes that we can treat $i_(partial_j) omega$ as just the general interior multiplication not considering $d x^i(partial_j) = delta_j^i$!
]

Define $f := sqrt(det g) (-1)^(j-1)$ and $beta := (d x^1 and dots and hat(d x^j) and dots and d x^n)$ then
$
i_(partial_j) omega &= f [ i_(partial_j) (d x^j) and beta + (-1)^(deg d x^j) d x^j and i_(partial_j) (beta) ] \
&= f beta
#dots_space #footnote[by Lemma 14.13 of _Introduction to Smooth Manifolds_ because $d x^j(partial_j) = 1$, $beta$ doesn't have $d x^j$]
$

$ therefore i_X omega = sum_j (-1)^(j-1) X^j sqrt(det g) d x^1 and dots and hat(d x^j) and dots and d x^n $


#paragraph_tab
Now, let's compute $d(i_X omega)$.

$
d(i_X omega) &= sum_j (-1)^(j-1) d(X^j sqrt(det g)) and d x^1 and dots and hat(d x^j) and dots and d x^n \
&= sum_j (-1)^(j-1) [ sum_i partial_i (X^j sqrt(det g)) d x^i ] and d x^1 and dots and hat(d x^j) and dots and d x^n &

#dots_space
#footnote[by the definition of exterior derivative because $X^j sqrt(det g)$ are just the coefficients]
$

$ = sum_(i,j) (-1)^(j-1) [partial_i (X^j sqrt(det g))] d x^i and d x^1 and dots and hat(d x^j) and dots and d x^n
#dots_space #footnote[by bilinearity of wedge product]
$

#note[The non-zero terms are when $i=j$.]

$ = sum_i [partial_i (X^i sqrt(det g))] d x^i and dots and d x^n &
#dots_space #footnote[pulling $d x^j$ to the front, then only $i=j$ terms survive]
$

#paragraph_tab
Finally, we can directly compare $(op("div") X)omega$ with $d(i_X omega)$!
$
(op("div") X) omega &= (op("div") X) sqrt(det(g)) d x_1 and dots and d x_n \
d(i_X omega) &= ( sum_i partial_i (X^i sqrt(det g)) ) d x^1 and dots and d x^n \
therefore op("div") X &= 1 / sqrt(det g) partial_j (sqrt(det g) thick X^j)
#dots_space #footnote[where the summation convention is used.]
$ <formula_of_divergence>

== Some useful formulas of divergence

#paragraph-tab
There are other characterizations of the divergence operation, of a more analytical flavor, which are also quite useful. Here is one.
#lemma(title: "The Product Rule of Riemmanian divergence")[
  Let $M$ be a smooth Riemannian manifold and $ Y in frak(X)(M)$, $f in bb(C)^infinity (M)$. Then :
  $
    op("div") (f Y) = f op("div") Y + g( op("grad") f comma Y)
  $
] <the_product_rule_of_Riemmanian_divergence>

#proof()[We start from the definition of divergence. Define $X:= f Y$. Then we have :
  $
   cal(L)_X d V_g =(op("div") X) d V_g
  $
  By Cartan's magic formula, we have :
  $
  cal(L)_X d V_g &= X corner.r.b overbrace(cancel(d(d V_g), stroke: #(paint: red)), d^2=0) + d(X corner.r.b d V_g)
  \
  &= d(X corner.r.b d V_g)
  $
  Now, replace $X$ to $f Y$.
  $
    cal(L)_X d V_g &= (op("div") (f Y)) d V_g #dots_space #footnote[by definition of divergence]
    \
    &= d((f Y) corner.r.b d V_g)
    \
    &= d[f(Y corner.r.b d V_g)] #dots_space #footnote[by the linearity of interior multiplication]
  $

  #paragraph_tab
  Since $f$ is the scalar function, we can use a wedge product from another point of view.
  $
    d[f (Y corner.r.b d V_g)] = d[f and (Y corner.r.b d V_g)]
  $
  Then we get the following equation by using proposition 14.23(b) of @Manifolds.
  $
    markrect(d[f and (Y corner.r.b d V_g)], color: #red, tag: #<LHS_using_proposition_14.23_Riemannian_divergence>) &= d f and (Y corner.r.b d V_g) + markrect(f and d(Y corner.r.b d V_g),color: #blue, tag: #<RHS_using_proposition_14.23_Riemannian_divergence>)

    #annot(<LHS_using_proposition_14.23_Riemannian_divergence>, pos: bottom)[$=d [f and Y corner.r.b d V_g)]=op("div") (f Y) d V_g$]
    #annot(<RHS_using_proposition_14.23_Riemannian_divergence>, pos: top+right)[The sign of this term is positive because $f$ is 0-form]
    #annot(<RHS_using_proposition_14.23_Riemannian_divergence>, pos: bottom+right, dx: 2em)[As using the definition of divergence, \ $f(op("div") Y) d V_g$]
  $
  Therefore, it is sufficient to show that $d f and (Y corner.r.b d V_g)=g(op("grad") f, Y)$

  #paragraph_tab
  For any 1-form $alpha$ any the vector field $Y$, and any top-degree form $omega$, the following strict algebraic identity holds :
  $
  (alpha and (Y corner.r.b omega)) = rmark(alpha(Y) omega) #dots_space #footnote[When feeding $Y$ into $d f$, the result $d f(Y)$ is simply the directional derivative of the function $f$ along the vector field $Y$.]
  $ <identity_of_1-form_and_volume_form>
  The volumne form is an $n$-form, In our local basis, it is written as :
  $
  Omega = dx^1 and dx^2 and dots and dx^n
  $
  also,
  $
    Y= sum_(i=1)^n Y^i frac(partial, partial x^i)
  $
  and,
  $
    alpha = sum_(j=1)^n alpha_j dx^j #dots_space #footnote[where $alpha$ is a 1-form.]
  $
  Now, let's directly compute the interior multiplication($Y corner.r.b Omega$) which is RHS of @identity_of_1-form_and_volume_form.
  $
  Y corner.r.b Omega = sum^n_(i=1) (-1)^(i-1) Y^i dx^1 and dots and overbrace(bmark(hat(d x)^i), frac(partial x^i, partial x^j)=0) and dots and dx^n
  $ <direct_computation_of_interior_multiplication_of_identity_of_1-form_and_volume_form>
  where $hat(d x)^i$ means that $d x^i$ is omitted. Similar to @direct_computation_of_interior_multiplication_of_identity_of_1-form_and_volume_form, let's directly compute RHS of @identity_of_1-form_and_volume_form.
  $
    alpha and (Y corner.r.b Omega) &= sum_(j=1)^n alpha_j dx^j and (sum^n_(i=1) (-1)^(i-1) Y^i dx^1 and dots and hat(d x)^i and dots and dx^n)
    \
    &= sum_(i=1)^n alpha_i Y^i (-1)^(i-1) dx^1 and dots and hat(d x)^i and dots and dx^n #dots_space #footnote[by $dx^i and dx^i=0$]
  $

  To cancel $hat(d x)^i$ by $dx^i$, we have to move $hat(d x)^i$ to the front. In this moment, we have to apply the property which is about the changing the position of wedge product.
  #local-scope-annotations(s => [
    $
      dx^1 and dots and rmark(hat(d x)^i, tag: #(s.tag)("position_change")) and dots and dx^n = (-1)^(i-1) hat(d x)^i and dx^1 and dots and dx^n

      #(s.annot)(
        "position_change",
        cetz,
        {
          import cetz.draw: *
          set-style(mark: (end: "straight"))

          // Change the position of hat(dx)^i
          bezier-through((s.node)("position_change", "south"), (rel: (x: -1.6, y: -0.5)), (rel: (x: -1, y: 0.4)), stroke: red)
        }
      )
    $
  ])



  Therefore, we have :
  $
    alpha and (Y corner.r.b Omega) &= sum_(i=1)^n alpha_i Y^i dx^1 and dots and dx^n
    \
    &= overbracket((sum_(i=1)^n alpha_i Y^i), alpha(Y)) underbracket((d x^1 and dots and dx^n), Omega)
    \
    &= alpha(Y) Omega
  $
  As applying the above, finally we have :
  $
    d f and (Y corner.r.b d V_g) &= (d f)(Y) d V_g
    \
    &= g(op("grad") f, Y) d V_g #dots_space #footnote[by the tangent-cotangent isomorphism]
  $
]

The following Lemma is directly induced from @the_product_rule_of_Riemmanian_divergence.
#lemma(title: [integral version of @the_product_rule_of_Riemmanian_divergence])[
  If $M$ is a smooth, compact manifold with boundary, $u$ a smooth function, $X$ a smooth vector field on $M$, then :
  $
    integral_M (op("div") X) u thin d V_g + integral_M X u thin d V = integral_(partial M) chevron.l X comma nu chevron.r u thin d S
  $
  where $nu$ is an outward normal vector.
] <integral_version_of_the_product_rule_of_Riemmanian_divergence>

#proof()[
  We can prove the lemma by applying the divergence theorem.
]

#paragraph-tab
Let define the formal adjoint :
#definition(title: "formal conjucate")[
  Let $M$ be a smooth manifold, and $u ,  v in C^infinity (M)$. For a vector field $X$ on $M$, we define the formal adjoint of $X$ :
  $
    integral_M (X^* u) dash(v) thin d V = integral_M u (X dash(v)) thin d V
  $ where $dash(v)$ is a conjucate of $v$.
]
We can know the divergence is deeply related to adjoint operation by the following propositions.

#proposition(title: "adjoint relationship between divergence and gradient")[
  The divergence operation is the negative of the adjoint of the gradient operation on vector fields ; If $X$ is a vector field and $u$ a function on $M$, on compactly supported on the interior of $M$, then :
  $
    (X, op("grad") u )=-(op("div") X, u)
  $
  where @L-2_norm_of_1-form is used.
] <adjoint_relationship_between_divergence_and_gradient>

#proof[
  By the definition of the global $L^2$ product, we have :
  $
    (X, op("grad") u )&= integral_M chevron.l X comma op("grad")u chevron.r thin d V
    \
    &= integral_M X u thin d V
  $
  Thus @adjoint_relationship_between_divergence_and_gradient redues to proving :
  $
    integral_M X u thin d V = - integral_M u op("div") X thin d V
  $
  by applying @integral_version_of_the_product_rule_of_Riemmanian_divergence, we have :
  #flowbox()[
    $
      integral_M X u thin d V &= bmark(integral_M op("div") (u X) thin d V) - integral_M u op("div") X d V
      \
      &= bmark(integral_(partial M) chevron.l u X comma nu chevron.r thin d S)  - integral_M u op("div") X d V
      \
      &= bmark(cancel(integral_(partial M) u chevron.l  X comma nu chevron.r  thin d S)) - integral_M u op("div") X d V #dots_space #footnote[by the linearity of norm and the condition that $u$ is supported.]
    $

  ]

]

#note()[
  By @adjoint_relationship_between_divergence_and_gradient, we write :
  $
    op("div")=-op("grad")^*
  $
]

#proposition()[
  If $X$ is a smooth vector field on $M$ and $v in C^(infinity)_0 (op("int") M)$, then :
  $
    X^* u = - X u -(op("div") X)u
  $
]

#proof()[
  By the divergence theorem,
  #flowbox()[
    $
      integral_M ( u v X) d V &= 0
      \
      &= integral_M [u v op("div")X + (X u)v + rmark(u(X v))] d V #dots_space #footnote[by applying @the_product_rule_of_Riemmanian_divergence]
    $

    $arrow.b$

    Focus on $integral_M u (X v) thin d V$.
    $
      rmark(integral_M u (X v) thin d V) &= - integral_M ( X u ) v d V - integral_M ( op("div") X) u v d V
      \
      &= integral_M [-X u - u op("div") X] v thin d V
      \
      &= integral_M (X^* u ) v thin d V #dots_space #footnote[By the definition of formal adjoint.]
    $

    $arrow.b$

    $
      therefore X^* u = - X u - u op("div") X
    $
  ]
]

#lemma()[
  If $u$ and $v$ are smooth functions and $X$ be a smooth vector field on a compact manifold $M$ with boundary, then :
  $
    integral_M [ (X u )v + u(X v)] d V &= - integral_M (op("div") X) u v thin d V + integral_(partial M) chevron.l X comma nu chevron.r u v thin d S
  $
]

#proof[
  Let $omega:= v u$ and apply @integral_version_of_the_product_rule_of_Riemmanian_divergence.
  #flowbox()[
    $
      integral_M (op("div") X) omega thin d V + bmark(integral_M X omega thin d V) = integral_(partial M ) chevron.l X comma nu chevron.r omega thin d S
    $

    $arrow.b$

    $
      bmark(integral_M X(u v) thin d V) &= - integral_M (op("div") X) omega thin d V + integral_(partial M ) chevron.l X comma nu chevron.r omega thin d S
      \
      &= bmark(integral_M (X u ) v + u (X v) thin d V) #dots_space #footnote[by distributing $X$]
    $

    $arrow.b$

    $
      therefore integral_M (X u ) v + u (X v) thin d V = - integral_M (op("div") X) u v thin d V + integral_(partial M ) chevron.l X comma nu chevron.r u v thin d S
    $
  ]
]