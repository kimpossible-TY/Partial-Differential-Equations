#import "../../Styles/styles.typ": *
#import "figures.typ": *
#import "@preview/mannot:0.4.0": *
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

#lemma(title: "product rule of Euclidean connection")[
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
  $ <proposition5.5_c>
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
] <definition_of_torsion_tensor>

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


#lemma(title: "symmetry of Christoffel symbols")[
  when torsion tensor is zero, Christoffel symbol is symmetric :
  $
    Gamma^(l)_(i j)=Gamma^(l)_(j i)
  $ 
] <symmetry_of_christoffel_symbols>

#proof[
  As considering the definition of torsion tensor (@definition_of_torsion_tensor) and the torsion-free condition, we have :
  $
    nabla_X Y - nabla_Y X = [X, Y]
  $ 
  As seeing, the LHS of the above equation, we can introduce Christoffel symbols by using the parallel coordinate frame $(partial_i)$#footnote[$(partial_i)$ is guaranteed by the definition of manifold. we can extract the frame from the coordinate chart.]. Then we have :
  #flowbox[
    $
      underbrace(cancel([partial_i, partial_j]), "by the parallelism") &= nabla_(partial_i) partial_j - nabla_(partial_j) partial_i \
      &= Gamma^(l)_(i j) partial_l - Gamma^(l)_(j i) partial_l #dots_space #footnote[by the definition of Christoffel symbols(@definition_of_christoffel_symbol)]
      \
      &= 0
    $

    $arrow.b$

    $
      therefore Gamma^(l)_(i j) = Gamma^(l)_(j i)
    $
  ]
]

#theorem(title: "Fundamental Theorem of Riemannian Geometry")[
  Let $(M, g)$ be a smooth Riemannian manifold or pseudo-Riemannian manifold. Then there exists a unique connection $nabla$ on $T M$ that is compatible with $g$ and symmetric.
] <Fundamental_theorem_of_Riemannian_geometry>

#proof[
  First, let's prove the uniqueness. To show the uniqueness, #highlight[we compute the arbitrary commections and compare them.] To compute, we neede to use the compatible and symmetric conditions actively. Since the connection is compatible with $g$, it is understandable to pick $X,Y,Z in frak(X)(M)$. Then let's compute all of possible connection made by $X,Y "and" Z$.#footnote[Since our goal is computing connection directly, the more information we have, the better.]
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
    - chevron.l Y comma [X comma Z] chevron.r - chevron.l Z comma [Y comma X] chevron.r + chevron.l X comma [Z comma Y] chevron.r) #dots_space #footnote[It is called 'Koszul formula'.]
  $ <Koszul_formula>

  Now, suppose $nabla^1$ and $nabla^2$ are two connections on $T M$ that are compatible with $g$ and symmetric. #highlighted[Since the right-hand side of @Koszul_formula doesn't depend on the any connections, the result of any connections will be same. It implies that $chevron.l nabla^(1)_X Y - nabla^(2)_X Y comma Z chevron.r=0$ for all $X,Y,Z in frak(X)(M)$.] Hence, there exists a unique connection on $T M$ that is compatible with $g$ and symmetric.

  #paragraph_tab
  Now, let's prove the existence. By the uniqueness, we search the existence of connection in the single chart. Let's define a single smooth local coordinate chart $(U, (x^i))$. Then, how can we naturally derive the connection in this chart? First of all, #highlighted[Since what we want to show is about naturality, it is natural to use basis vector fields, instead of general vector fields $X,Y "and" Z$.] Moreover, because we are treating the coordinate chart $U$ and it is flat by the definition of manifold, the parallelism is guaranteed :
  $
    [partial_i comma partial_j]=0
  $ <parallelism_of_chart>

  #paragraph_tab
  Since we know @Koszul_formula is true when the connection is compatible with the metric and symmetric as considering the induction process of @Koszul_formula, we will use @Koszul_formula with @parallelism_of_chart. Since the RHS of @Koszul_formula doesn't depend on the connection and it could be computed without any assumptions,#footnote[In other words, the RHS of @Koszul_formula is naturall exist or well-defined.] #highlighted[it is good to define a new connection $nabla^("new")$ which satisfies @Koszul_formula then show that it is compatible with the metric and symmetric.]#footnote[If we show that $nabla^("new")$ is compatible with the metric and symmetric, then we prove that the connection is unique, compatible with $g$ and symmetric if and only if it satisfies Koszul formula(@Koszul_formula).]

  $
    chevron.l nabla^("new")_(partial_i) partial_j comma partial_k chevron.r & = frac(1,2) (partial_i chevron.l partial_j comma partial_k chevron.r + partial_j chevron.l partial_k comma partial_i chevron.r - partial_k chevron.l partial_i comma partial_j chevron.r \ & 
    - cancel(partial_j chevron.l partial_k comma [partial_i comma partial_j] chevron.r - partial_k chevron.l partial_i comma [partial_j comma partial_k] chevron.r + partial_i chevron.l partial_k comma [partial_j comma partial_i] chevron.r paren.r, stroke: #(paint : red))
    \
    & = frac(1,2) paren.l partial_i markrect(chevron.l partial_j comma partial_k chevron.r, color: #blue, tag: #<term_1_theorem5.10>) + partial_j markrect(chevron.l partial_k comma partial_i chevron.r, color: #green, tag: #<term_2_theorem5.10>) - partial_k markrect(chevron.l partial_i comma partial_j chevron.r, color: #purple, tag: #<term_3_theorem5.10>) paren.r
    \
    & = frac(1,2) (partial_i g_(j k) + partial_j g_(k i) - partial_k g_(i j)) #dots_space #footnote[By special lemma13.1 of @Manifolds.]
  $ #annot(<term_1_theorem5.10>, pos: bottom)[$g_(j k)$]
  #annot(<term_2_theorem5.10>, pos: bottom)[$g_(k i)$]
  #annot(<term_3_theorem5.10>, pos: bottom)[$g_(i j)$]
  Also, by the definition of Christoffel symbols, we have :
  $
    chevron.l nabla^("new")_(partial_i) partial_j comma partial_k chevron.r & = Gamma^l_(i j) chevron.l partial_l comma partial_k chevron.r
    \
    &= Gamma^l_(i j) g_(l k)
  $
  Therefore, we have :
  #flowbox[
    $
    Gamma^l_(i j) g_(l k) = frac(1,2) (partial_i g_(j k) + partial_j g_(k i) - partial_k g_(i j))
    $ <theorem5.10_2>
    $arrow.b$

    $
      therefore Gamma^l_(i j) = g^(l k)frac(1,2) (partial_i g_(j k) + partial_j g_(k i) - partial_k g_(i j))
    $ <result_of_theorem_5.10>
  ]
  
  #paragraph_tab
  Now, let's verify that $nabla^("new")$ is compatible with the metric and symmetric. First of all, let's check the symmetry.
  #flowbox[
    $
    chevron.l nabla^("new")_(partial_i) partial_j comma partial_k chevron.r - chevron.l nabla^("new")_(partial_j) partial_i comma partial_k chevron.r & = Gamma^l_(i j) g_(l k) - Gamma^l_(j i) g_(l k) 
    \ &
    =0  #dots_space #footnote[By @symmetry_of_christoffel_symbols]
    \ &
    =bracket.l partial_i comma partial_j bracket.r partial_k & #[By @parallelism_of_chart]
    $
    $arrow.b$
    $
      therefore  nabla^("new")_(partial_i) partial_j -  nabla^("new")_(partial_j) partial_i=bracket.l partial_i comma partial_j bracket.r
    $
  ] Therefore, $nabla^("new")$ is symmetric.

  #paragraph_tab
  Now, let's check the compatibility with the metric. #highlight[What does it mean "compatible with $g$" intuitively? We already treated it at Proposition 5.5.] Among the statements of Proposition 5.5, @proposition5.5_c will be useful, becuase the Christoffel symbol is used. Thus using @theorem5.10_2 twice, we get :
  $
    Gamma^(l)_(k i)g_(l j)+Gamma^(l)_(k j)g_(i l) & = frac(1,2) paren.l partial_k g_(i j) + cancel(partial_i g_(k j), stroke: #(paint : red)) - cancel(partial_j g_(k i) paren.r, stroke: #(paint : blue)) + frac(1,2) paren.l partial_k g_(j i) + cancel(partial_j g_(k i), stroke: #(paint : blue)) - cancel(partial_i g_(k j), stroke: #(paint : red)) paren.r
    \
    &= partial_k g_(i j) 
  $ <result_of_compatibility_theorem5.10>
  Since @result_of_compatibility_theorem5.10 is definitely the same as @proposition5.5_c, $nabla^("new")$ is compatible with the metric by proposition 5.5.
]

#definition(title: "Levi-Civita Connection")[
  The connection which is used to @Fundamental_theorem_of_Riemannian_geometry is called the Levi-Civita connection.
]<Definition_of_Levi-Civita_connection>
