#import "../../Styles/styles.typ": *
#import "figures.typ": *
#import "@preview/mannot:0.3.1": *
#import "@preview/cetz:0.4.2": *

=== Levi-Civita Connection

==== metric connections

#paragraph_tab
First, let's treat the Euclidean connection on $bb(R)^n$. it has one very nice property with respect to the Euclidean metric.

#definition(title: [Euclidean connection on $bb(R)^n$])[
  In standard Cartesian coordinates, the Euclidean connection on $bb(R)^n$ is given by
  $
    dash(nabla)_X Y= sum_(i)X Y^(i) partial_i
  $
]

#special_lemma(title: "product rule of Euclidean connection")[
  The Euclidean connection on $bb(R)^n$ satisfies the product rule :
  $
    dash(nabla)_X chevron.l Y comma Z chevron.r=
    chevron.l dash(nabla)_X Y comma Z chevron.r+
    chevron.l Y comma dash(nabla)_X Z chevron.r #dots_space #footnote[Note that $chevron.l dot comma dot chevron.r$ is the standard inner product.]
  $
] <product_rule_of_Euclidean_connection>

#proof[
  We will calculate the Left Hand Side (LHS) and the Right Hand Side (RHS) separately and show they are identical.

  #paragraph_tab
  First, let's calculate the LHS. Since the inner product $chevron.l X comma Y chevron.r$ is just a scalar function, we can use the definition of covariant derivative of scalar function (@definition_of_covariant_derivative_of_scalar_function) :
  $
    "LHS" = dash(nabla)_X chevron.l Y comma Z chevron.r= X shell.l chevron.l Y comma Z chevron.r shell.r
  $
  Substitute the coordinate definition of the metric:
  $
    "LHS" = X shell.l chevron.l Y comma Z chevron.r shell.r &= X shell.l sum_(i)Y^(i) Z^(i) shell.r \
    & = sum_(i) paren.l X(Y^(i)) Z^(i) + Y^(i) X(Z^(i)) paren.r & "Leibnize Rule"
  $

  #paragraph_tab
  Now, let's calculate the RHS. The RHS involves the inner products of the covariant derivatives.

  #flowbox[
    1. First, write out the derivatives:
    $dash(nabla)_X Y = sum_(i) X(Y^i) e_i$
    $dash(nabla)_X Z = sum_(j) X(Z^j) e_j$

    2. Now, compute the first term of the RHS $chevron.l dash(nabla)_X Y, Z chevron.r$:
    $chevron.l sum_(i) X(Y^i) e_i, sum_(j) Z^j e_j chevron.r = sum_(i) X(Y^i) Z^i$

    3. Next, compute the second term of the RHS $chevron.l Y, dash{nabla}_X Z chevron.r$:
    $chevron.l sum_(i) Y^i e_i, sum_(j) X(Z^j) e_j chevron.r = sum_(i) Y^i X(Z^i)$

    4. Add them together:
    $"RHS" = sum_(i) X(Y^i) Z^i + sum_(i) Y^i X(Z^i)$

    $= sum_(i) shell.l X(Y^i)Z^i + Y^i X(Z^i) shell.r$
  ]

  #paragraph_tab
  compare the LHS and RHS, we have:
  $dash(nabla)_X chevron.l Y comma Z chevron.r = sum_(i) shell.l X(Y^i)Z^i + Y^i X(Z^i) shell.r$.
]

#paragraph_tab
This property makes sense on an abstract Riemannian manifold or pseudo-Riemannian manifold.
#definition(
  title: "metric connection",
)[Let $g$ be a Riemannian or pseudo-Riemannian metric on a smooth manifold $M$. A connection $nabla$ on $T M$ is said to be compatible with $g$, or to be a metric connection, if it satisfies the following product rule for all $X,Y,Z in frak(X)(M)$:
  $
    dash(nabla)_X chevron.l Y comma Z chevron.r = chevron.l dash(nabla)_X Y comma Z chevron.r + chevron.l Y comma dash(nabla)_X Z chevron.r
  $
]

#paragraph_tab
The next proposition gives several alternative characterizations of metric connections.
#proposition(title: "5.5 (Characterizations of Metric Connections)")[
  Let $(M,g)$ be a Riemannian or pseudo-Riemannian manifold. A connection, and let $nabla$ be a connection on $T M$. The following conditions are equivalent:
  + $nabla$ is a compatible with $g$ : $nabla_X chevron.l Y comma Z chevron.r = chevron.l nabla_X Y comma Z chevron.r + chevron.l Y comma nabla_X Z chevron.r$
  + $g$ is parallel with respect to $nabla$ : $nabla g$=0.
  + In terms of any smooth local frame $(E_i)$ the connection coefficient of $nabla$ satisfy :
  $
    Gamma^(l)_(k i)g_(l j)+ Gamma^(l)_(k j)g_(i l)=E_(k)(g_(l j))
  $
]

#proof[
  First, let's prove $(1) arrow.l.r (2)$. By the definition of total covariant derivative (@definition_of_total_covariant_derivative) and product rule of covariant derivative with tensor field (@proposition4.15_b), we have
  #proof_of_connection_compatibility()

  #paragraph_tab
  Let's prove $(2) arrow.r (3)$. We assume condition (2), which states that the metric is parallel: $nabla g = 0$.
  This implies that the total covariant derivative of $g$ vanishes everywhere. In terms of the local frame $(E_i)$, this means:
  $
    (nabla_(E_k) g) (E_i, E_j) = 0
  $

  We now expand the left-hand side using the product rule for tensor fields derived in @proposition4.15_b. Since $g$ is a $(0,2)$-tensor, the formula simplifies to:
  $
    markrect((nabla_(E_k) g) (E_i, E_j), color: #red, tag: #<total_covariant_derivative_of_metric>) &= E_k (g(E_i, E_j)) - g(nabla_(E_k) E_i, E_j) - g(E_i, nabla_(E_k) E_j)
  $ #annot(<total_covariant_derivative_of_metric>)[It is the same as the total covariant derivative.]

  #flowbox[
    Set the total derivative to zero by condition $(2)$.
    $ 0 = E_k (g(E_i, E_j)) - g(nabla_(E_k) E_i, E_j) - g(E_i, nabla_(E_k) E_j) $

    $arrow.b$

    Substitute the definition of connection coefficients: $nabla_(E_k) E_i = Gamma^l_(k i) E_l$.
    $ E_k (g_(i j)) = g(Gamma^l_(k i) E_l, E_j) + g(E_i, Gamma^l_(k j) E_l) $

    $arrow.b$

    Use the linearity of the metric tensor $g$.
    $ E_k (g_(i j)) = Gamma^l_(k i) g_(l j) + Gamma^l_(k j) g_(i l) $

    $arrow.b$

    Rewrite metric evaluations as components (ex. $g(E_a, E_b) = g_(a b)$).
    $
      markrect(E_k (g_(i j)), color: #red, tag: #<metric_derivative>) = Gamma^l_(k i) g_(l j) + Gamma^l_(k j) g_(i l)
    $
  ]
  #annot(<metric_derivative>, pos: left)[Ordinary derivative of component]

  Thus, we arrive at the condition (3):
  $
    E_k (g_(i j)) = Gamma^l_(k i) g_(l j) + Gamma^l_(k j) g_(i l)
  $
]

#note(title: "intuition of covariant derivative")[
  What does $E_k (g_(i j)) = Gamma^l_(k i) g_(l j) + Gamma^l_(k j) g_(i l)$ mean?
  #figure(
    covariant_derivative_intuition(),
    caption: "Intuition of covariant derivative",
  )
  $E_(k) (g_(i j))$ means that measures that rate of change of the scalar value $g_(i j)$ as we move infinitesimally along the path generated by the vector $E_(k)$.
]
==== Symmetric connections

#paragraph_tab
Define the 'torsion tensor' of the connection. #definition[
  The torsion tensor $tau: frak(X)(M) times frak(X)(M) arrow frak(X)(M)$ of a connection $nabla$ on the tangent bundle $T M$ is defined by
  $ tau(X, Y) = nabla_X Y - nabla_Y X - [X, Y] $
  for vector fields $X, Y in frak(X)(M)$.
]

#figure(
  torsion_tensor_visualization(),
  caption: "Geometric interpretation of Torsion: Failure of the parallelogram to close.",
)

Then what happens if the torsion tensor is zero? #definition[
  We say that a connection $nabla$ on the tangent bundle of a smooth manifold $M$ is symetric or torsion-free if
  $ nabla_X Y - nabla_Y X & = [X, Y] & "for all" X, Y in frak(X)(M) $

]

#figure(
  torsion_free_visualization(),
  caption: "Geometric interpretation of Symmetric Connection: Torsion is zero, so the vector loop closes.",
)

#paragraph_tab
How can we understand the torsion tensor intuitively? Imagine we are at point $p$. we have two directions, $X$ and $Y$.
1. Walk along $X$ for a small step, then walk along the *parallel transported* version of $Y$. we arrive at a point $p_1$.
2. Start again at $p$. Walk along $Y$ for a small step, then walk along the *parallel transported* version of $X$. we arrive at a point $p_2$.

If the connection is *symmetric* (Torsion is zero), we will end up at the exact same point ($p_1 = p_2$). The "parallelogram" formed by the flows closes perfectly. If $p_1 != p_2$, the "gap" vector extending from $p_2$ to $p_1$ is the Torsion $T(X, Y)$. It represents a "twisting" or "dislocation" of the tangent spaces as we move.
#figure(torsion_intuition_visualization(), caption: "Torsion as Dislocation")

#theorem(title: "5.10 (Fundamental Theorem of Riemannian Geometry)")[
  Let $(M, g)$ be a smooth Riemannian manifold or pseudo-Riemannian manifold. Then there exists a unique connection $nabla$ on $T M$ that is compatible with $g$ and symmetric.
]

#proof[
  First, let's prove the uniqueness. To show the uniqueness, we compute the arbitrary commections and compare them. To compute, we neede to use the compatible and symmetric conditions actively. Since the connection is compatible with $g$, it is understandable to pick $X,Y,Z in frak(X)(M)$. Then let's compute all of possible connection made by $X,Y,Z$.#footnote[Since our goal is computing connection directly, the more information we have, the better.]
  $
    cases(
      nabla_X (Y,Z) = X chevron.l Y comma Z chevron.r = chevron.l nabla_X Y comma Z chevron.r + markrect(chevron.l Y comma nabla_X Z chevron.r, color: #purple, tag: #<term_1>),
      nabla_Y chevron.l Z comma X chevron.r= Y chevron.l Z comma X chevron.r = chevron.l nabla_Y Z comma X chevron.r + markrect(chevron.l Z comma nabla_Y X chevron.r, color: #purple, tag: #<term_2>),
      nabla_Z chevron.l X comma Y chevron.r= Z chevron.l X comma Y chevron.r = chevron.l nabla_Z X comma Y chevron.r + markrect(chevron.l X comma nabla_Z Y chevron.r, color: #purple, tag: #<term_3>),
    )
  $ #annot((<term_1>, <term_2>, <term_3>), pos: right)[#text(size: 8pt)[terms that will subject to symmetry conditions.]]

  #paragraph_tab
  Using the symmetry condition on the last term in each line, this can be rewritten as :
  $
    cases(
      X chevron.l Y comma Z chevron.r = markul(chevron.l nabla_X Y comma Z chevron.r, color: #red) + cancel(chevron.l Y comma nabla_Z X chevron.r, stroke: #(paint: blue)) + chevron.l Y comma [X comma Z] chevron.r ,
      Y chevron.l Z comma X chevron.r = cancel(chevron.l nabla_Y Z comma X chevron.r, stroke: #(paint: green)) + markul(chevron.l Z comma nabla_X Y chevron.r, color: #red) + chevron.l Z comma [Y comma X] chevron.r ,
      Z chevron.l X comma Y chevron.r = cancel(chevron.l nabla_Z X comma Y chevron.r, stroke: #(paint: blue)) + cancel(chevron.l X comma nabla_Y Z chevron.r, stroke: #(paint: green)) + chevron.l X comma [Z comma Y] chevron.r
    )
  $

  As adding the first two of these equations and subtracting the third, we obtain :
  $
    X chevron.l Y comma Z chevron.r + Y chevron.l Z comma X chevron.r - Z chevron.l X comma Y chevron.r \ 
    =
    2chevron.l nabla_X Y comma Z chevron.r + markrect(chevron.l Y comma [X comma Z] chevron.r + chevron.l Z comma [Y comma X] chevron.r - chevron.l X comma [Z comma Y] chevron.r, color: #red, tag: #<term_4_will_be_moved_to_LHS>)
  $ #annot(<term_4_will_be_moved_to_LHS>, pos: top, dx: 9em, dy: -1em, leader-connect: "elbow")[will be moved to the left hand side.]
  Finally, solving for $chevron.l nabla_X Y comma Z chevron.r$, we obtain :
  $
    chevron.l nabla_X Y comma Z chevron.r & = frac(1,2) (X chevron.l Y comma Z chevron.r + Y chevron.l Z comma X chevron.r - Z chevron.l X comma Y chevron.r \ & 
    - chevron.l Y comma [X comma Z] chevron.r - chevron.l Z comma [Y comma X] chevron.r + chevron.l X comma [Z comma Y] chevron.r)
  $ <result_of_connection_compatibility_and_symmetry>

  Now, suppose $nabla^1$ and $nabla^2$ are two connections on $T M$ that are compatible with $g$ and symmetric. #highlighted[Since the right-hand side of @result_of_connection_compatibility_and_symmetry doesn't depend on the any connections, the result of any connections will be same. It implies that $chevron.l nabla^(1)_X Y - nabla^(2)_X Y comma Z chevron.r=0$ for all $X,Y,Z in frak(X)(M)$.] Hence, there exists a unique connection on $T M$ that is compatible with $g$ and symmetric.

  #paragraph_tab
  Now, let's prove the existence.
]

#definition(title: "Levi-Civita Connection")[
  The connection which is used to theorem 5.10 is called the Levi-Civita connection.
]
