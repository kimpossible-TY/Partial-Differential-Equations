#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/mannot:0.4.0": *

== the Covariant Derivative and Divergence of Tensor Fields

#paragraph_tab
Now we combine the divergence with the covariant derivative and geodesics.

If $X = X^k D_k$ and $D_k = partial / (partial x_k)$, then we can use the convension of @semicolon_standard_practice :
$ X_( ; j )^k := partial_j X^k + sum_l Gamma_(l j)^k X^l $
which satisfies
$ nabla_(D_j) X = X_( ; j )^k D_k $ <easy_definition_of_semi-colon_convention>


Actually, $X_( ; j )^k$ is directly driven by Proposition 4.6 (@basic_formula_of_connection_in_tangent_bundle) of @Riemannian

$
  nabla_A B & = [ (A(B^k) + sum_(i,m) A^i B^m Gamma_(i m)^k) ] E_k                 &                 "by proposition 4.6" \
            & = [ partial_j (X^k) + sum_(i,m) partial_j|_i X^m Gamma_(i m)^k ] E_k & "by putting " X, partial_j "to" B, A \
            & = [ partial_j (X^k) + sum_(i,m) delta_i^j X^m Gamma_(j m)^k ] E_k    &    "by i-th component of " partial_j \
            & = [ partial_j (X^k) + sum_m X^m Gamma_(j m)^k ] E_k                  &                    j" is free index"
$

This is $ X_( ; j )^k $. As considering  $X:=X^k D_k$ and the summation convention is used, we can argue that :

$
  X_( ; j )^k = shell.l nabla_(D_j) X shell.r^k
$ <semi_colon_concention_and_covariant_derivative>

#paragraph_tab
The divergence of a vector field has an important expression in terms of the covariant derivative.

#proposition(title: "divergence and trace")[Given a vector field $X$ with components $X^k$, then
  $ op("div") X = sum_j X_( ; j )^j $ <divergence_and_semi_colon>
]<divergence_and_trace>

#proof[Since $X_( ; j )^j$ is related to the geodesic, it is good way to use the following formula defining with $frak(g) := det g$ :
  $
    op("div") X = 1 / sqrt(frak(g)) partial_j (sqrt(frak(g)) X^j) #dots_space #footnote[by using @formula_of_divergence]
  $
  Then our goal is to represent right side to $X_( ; j )^j$.

  #paragraph_tab
  First, let's compute the partial derivative. By the chain rule, we get:
  $
    1 / sqrt(frak(g)) partial_k sqrt(frak(g)) = 1 / sqrt(frak(g)) (1 / (2 sqrt(frak(g))) partial_k frak(g)) = 1 / (2 frak(g)) partial_k frak(g)
  $

  Then how can we compute $partial_k frak(g)$? Since $frak(g)$ is actually $det g$, it is time to use Jacobi's formula(@Jacobis_formula)!
  $ d / (d t) det(A) = det(A) upright(T r)(A^(-1) (d A)/(d t)) & "Jacobi's formula" $

  $
    partial_k frak(g) & = frak(g) upright(T r)(g^(i j) partial_k g_(i j)) \
                      & = frak(g) (g^(i j) partial_k g_(j i))             & "by computing Tr(AB) = " A_(i j) B_(j i) \
                      & = frak(g) (g^(i j) partial_k g_(i j))             &       "by symmetry of Riemannian metric"
  $

  $ therefore 1 / frak(g) partial_k frak(g) = (g^(i j) partial_k g_(i j)) $ (where $k$ is free index and $i, j$ are dummy indices)

  Now applying all of the above things. We have:

  $
    op("div") X &= 1 / sqrt(frak(g)) partial_j (sqrt(frak(g)) X^j) & "formula for divergence" \
    &= partial_j X^j + 1 / sqrt(frak(g)) (partial_j sqrt(frak(g))) X^j & "by distributing" partial_j "(product rule)" \
    &= partial_j X^j + (1 / (2 frak(g)) partial_j frak(g)) X^j & "by the chain rule" \
    &= partial_j X^j + (1/2 (g^(d_1 d_2) partial_j g_(d_1 d_2))) X^j #dots_space #footnote[by Jacobi's formula(@Jacobis_formula)]
  $

  Hence, it is sufficient to show that $1/2 (g^(d_1 d_2) partial_j g_(d_1 d_2))$ is the same as Christoffel symbol.

  #paragraph_tab
  #highlighted[Note that the subscript and the superscript of $X$ are the same. Thus we can think the free indices $l$ and $m$ which came from $Gamma_(m i)^l$ are the same.
  ]

  #flowbox[
    $
      Gamma_(m i)^l & = 1/2 g^(l d_3) (partial_m g_(d_3 i) + partial_i g_(d_3 m) - partial_(d_3) g_(m i)) & #dots_space #footnote[$d_3$ is dummy index and others are free indices]
    $

    $arrow.b$

    Reformulate Christoffel symbol with $l, m = j$ and $i = d_4$ where $j, d_4$ are dummy indices :

    $
      sum_(j, d_3, d_4) Gamma_(j d_4)^j &= sum_(j, d_3, d_4) [ 1/2 g^(j d_3) partial_j g_(d_4 d_3) + 1/2 g^(j d_3) partial_(d_4) g_(d_3 j) - 1/2 g^(j d_3) partial_(d_3) g_(j d_4) ]
    $
  ]

  Now, we do some trick to extract the form $1/2 (g^(d_1 d_2) partial_j g_(d_1 d_2))$. First, let's distribute the multiple summation.

  $
    sum_(j, d_3, d_4) Gamma_(j d_4)^j &= sum_(j, d_3, d_4) 1/2 g^(j d_3) g_(d_3 j) + sum_(j, d_3, d_4) 1/2 g^(j d_3) partial_(d_4) g_(d_3 j) - sum_(j, d_3, d_4) 1/2 g^(j d_3) partial_(d_3) g_(j d_4)
  $

  Since all of the indices are dummy, those three terms of the last equation are the same!#footnote[It is the same principle : $sum_i dot = sum_j dot$ where $i$ and $j$ are dummy indices in this example.]

  $
    sum_(j, d_3, d_4) Gamma_(j d_4)^j &= sum_(j, d_3, d_4) 1/2 g^(j d_3) partial_(d_4) g_(d_3 j) \
    &= sum_(j, d_3, d_4) 1/2 g^(j d_3) partial_(d_4) g_(j d_3) & "by symmetry of Riemannian metric" \
    &= sum_(j, d_3, d_4) 1/2 g^(d_4 d_3) partial_j g_(d_4 d_3) & "by interchanging " j <--> d_4
  $

  Thus we can argue $1/2 (g^(d_1 d_2) partial_j g_(d_1 d_2)) = Gamma_(j d)^j$ where $d$ and $j$ are dummy indices.
]

#paragraph_tab
What does the result of @divergence_and_trace mean intuitively? Let $X = X^k partial_k$ and let $Phi_t$ be its local flow. At a point, the tensor
$
  nabla X = (nabla_j X^k)
$
is the infinitesimal deformation matrix of the flow: #highlight()[the lower index records the direction in which the field is differentiated, and the upper index records the component being changed.] Its trace is
$
  op("div") X = op("tr")(nabla X) = nabla_j X^j .
$

#figure(
  divergence-flow-comparison-diagram(),
  caption: [Expansion changes area to first order; pure rotation has zero trace.]
)

#figure(
  divergence-matrix-trace-diagram(),
  caption: [Only matching input-output directions enter the trace.]
)

#paragraph_tab
The diagonal terms $nabla_j X^j$ measure first-order expansion or compression in the matching coordinate directions. The off-diagonal terms $nabla_j X^k$ with $j != k$ measure shear or rotation; they change the shape of a small element, but they do not contribute to its volume change to first order.

#figure(
  volume-jacobian-diagram(),
  caption: [Volume change is controlled by the Jacobian determinant.]
)

#paragraph_tab
In a local frame,
$
  D Phi_t = I + t nabla X + O(t^2).
$
For any square matrix $A$,
$
  det(I + t A) = 1 + t op("tr")(A) + O(t^2).
$
Therefore
$
  det(D Phi_t) = 1 + t op("div") X + O(t^2).
$
Equivalently,
$
  op("div") X
  =
  d / (d t) |_(t=0)
  frac("new volume", "original volume").
$

#paragraph_tab
The differential-form definition is the coordinate-free form of the same statement. If $d V$ is the metric volume form, then
$
  d(iota_X d V) = (op("div") X) d V.
$
Thus $op("div") X$ is the scalar density by which the flow infinitesimally creates or removes volume.

=== The Killing vector field#footnote[Nobody is actually killed. The concept is named after the 19th-century german mathematician wihelm killing.]

#paragraph_tab
In the view of @divergence_and_semi_colon, we know that a vector field $X$ generates a volume-preserving flow if and only if $X_( ; j )^j=0$. Complementing this, we investigate that the flow leaves the metric g invariant, or equivalently :
$
  cal(L)_X g =0
$ <second_condition_of_killing_vector_field>
Now, we consider the two conditions.
#definition(title: "The conditions that are needed to killing vector field")[
  + torsion free condition(Levi-Civita condition)
  + g is invariant to X($cal(L)_X g =0$).
] <definition_of_killing_vector_field>

#paragraph_tab
To develop our argument, let's investigate @second_condition_of_killing_vector_field more. For arbitrary vector fields $U$ and $V$, we have :
$
  cal(L)_X g (U, V) &= - chevron.l cal(L)_X U comma V chevron.r - chevron.l U comma cal(L)_X V chevron.r + X chevron.l U comma V chevron.r #dots_space #footnote[by proposition 12.32 of @Manifolds] \
  &= chevron.l nabla_X U - cal(L)_X U comma V chevron.r + chevron.l U comma nabla_X V - cal(L)_X V chevron.r wide dots.h.c thin #footnote[Since $chevron.l U comma V chevron.r_g$ is a scalar function, we get :
    $X chevron.l U comma V chevron.r = nabla_X (chevron.l U comma V chevron.r_g)$.
    Moreover, we already know that if torsion free condition is satisfied, then $nabla$ is compatible with $g$. Hence we get :
    $nabla_X (chevron.l U comma V chevron.r_g) = chevron.l nabla_X U comma V chevron.r + chevron.l U comma nabla_X V chevron.r$.
  ] \
  &= chevron.l cancel(nabla_X U, stroke: #(paint: blue)) - shell.l cancel(nabla_X U, stroke: #(paint: blue)) - nabla_V X shell.r comma V chevron.r + chevron.l U comma cancel(nabla_X V, stroke: #(paint: red)) - shell.l cancel(nabla_X V, stroke: #(paint: red)) - nabla_U X shell.r chevron.r #dots_space #footnote[As we know, the torsion tensor is : $T(X comma V):= nabla_X V - nabla_V X - [X comma V]$. If torsion free condition is satisfied, then $T(X comma V) = 0$ and thus we get : $nabla_X V - nabla_V X = [X comma V]$. By theorem9.38 of @Manifolds, we have : $cal(L)_X V = [X comma V]$. Hence we get : $cal(L)_X V = nabla_X V - nabla_V X$. Similarly, we can get : $cal(L)_X U = nabla_X U - nabla_U X$.] \
  &= chevron.l nabla_U X comma V chevron.r + chevron.l U comma nabla_V X chevron.r
$ <Lie_derivative_of_metric_when_torsion_free>

#paragraph_tab
If $U$ and $V$ are coordinate vector fields, then we can write identity as :
$
  paren.l cal(L)_X g paren.r (D_j, D_k) &= chevron.l nabla_(D_j) X comma D_k chevron.r + chevron.l D_j comma nabla_(D_k) X chevron.r #dots_space #footnote[by using @Lie_derivative_of_metric_when_torsion_free] \
  &= chevron.l X_( ; j )^l D_l comma D_k chevron.r + chevron.l D_j comma X_( ; k )^l D_l chevron.r #dots_space #footnote[by the definition of semi-colon convention, see @easy_definition_of_semi-colon_convention]
  \
  &= X_( ; j)^l markul(chevron.l D_l comma D_k chevron.r, color: #blue) + X_( ; k )^l markul(chevron.l D_j comma D_l chevron.r, color: #red) #dots_space #footnote[Since $X_( ; j)^l$ is a scalar function, we can extract it due to the linearity of inner product]
  \
  &= X_( ; j )^l markul(g_(l k), color: #blue)+ X_( ; k )^l markul(g_(j l), color: #red) #dots_space #footnote[by definition of Riemannian metric]
$ <identitiy_of_Lie_derivative_of_metric_when_torsion_free>

Since $g_(l k)$ and $g_(j l)$ are actually used to the 'flat operator', which subjects to 'muscial isomorphism', we can apply the following :
#flowbox[
  Define the coefficients of covector fields $X_k$ and $X_j$ naturally which are satisfied :
  $ X_k := g_(k l) X^l , X_j := g_(j l) X^l $ <defining_X_k_and_X_j>

  $arrow.b$

  make @identitiy_of_Lie_derivative_of_metric_when_torsion_free to easily be shown the relationships(@defining_X_k_and_X_j) :
  $
    cal(L)_X g (D_j, D_k) &= g_(k l) X_( ; j )^l + g_(j l) X_( ; k )^l #dots_space #footnote[by using the symmetry of Riemannian metric]
  $
]
Now, we want to make the superscripts of $X_( ; j )^l$ and $X_( ; k )^l$ to be lower indices naturally. To do this, we have to define the following first :
$
  cases(X_(k ; j) := partial_j X_k - sum_l Gamma_(j k)^l X_l, X_( j; k ):= partial_k X_j - sum_l Gamma_(k j)^l X_l) #dots_space #footnote[we already did the simiar things at @covector_semi-colon_convention]
$ <defining_X_semicolon_j_k_and_X_semicolon_k_j>
Then, the following is understandable :
$ cases(g_(k l) X_( ; j)^l = X_(k ; j), g_(j l) X_( ; k )^l = X_( j; k )) $
Finally, we can reformulate @identitiy_of_Lie_derivative_of_metric_when_torsion_free as :
$
  cal(L)_X g (D_j, D_k) & = X_(k ; j) + X_( j; k )
$ <identitiy_of_Lie_derivative_of_metric_when_torsion_free_2>

#paragraph_tab
By the above statement, we can argue the following :
#proposition(title: "necessary and sufficient condition of Killing field")[$X$ is a Killing vector field if and only if
  $
    X_(k ; j) + X_( j; k ) = 0 #dots_space #footnote[the left side is called the deformation tensor of $X$]
  $ <condition_of_necessary_and_sufficient_condition_of_Killing_field>
] <necessary_and_sufficient_condition_of_Killing_field>

#proof[
  By using @identitiy_of_Lie_derivative_of_metric_when_torsion_free_2, we know that @condition_of_necessary_and_sufficient_condition_of_Killing_field is the same as the Lie derivative of metric when torsion free. By the definition of Killing vector field(@definition_of_killing_vector_field), we know that :
  $
    X_(k ; j) + X_( j; k ) & = cal(L)_X g (D_j, D_k) #dots_space #footnote[by @identitiy_of_Lie_derivative_of_metric_when_torsion_free_2] \
    & = 0 #dots_space #footnote[by @definition_of_killing_vector_field]
  $
  which proves the proposition.
]

#proposition()[For a vector field $X = X^k D_k$, define its metric-dual 1-form by
  $
    xi := X^flat = g_(j k) X^k d x^j = X_j d x^j.
  $
  Then we have :
  $
    d xi = frac(1, 2) sum_(j comma k)(X_(j ; k) - X_(k ; j)) dx_k and dx_j
  $
]

#proof[
  Since, $xi$ is 1-form, by the definition of exterior derivative, we have :
  $
    d xi = frac(1, 2) sum_(j comma k) (partial_k X_j - partial_j X_k) dx_k and dx_j #dots_space #footnote[At @Manifolds, the definition of exterior derivative is $d xi = sum_(j < k) (partial_k X_j - partial_j X_k) dx_k and dx_j$. However both are the same, becuase of the anti-symmetric property of wedge product and $dx_k and dx_k=0$.]
  $ <d_xi_proposition_3.3>
  By the definition of semi-colon convention of covector field(@defining_X_semicolon_j_k_and_X_semicolon_k_j), we have :
  #flowbox[
    $
      X_(j ; k) - X_(k ; j) & = (partial_k X_j - markul(cancel(sum_l Gamma_(j k)^l X_l, stroke: #(paint: red)), tag: #<cancel_gamma_in_semicolon_convention_of_covector_field_1>)) - (partial_j X_k - markul(cancel(sum_l Gamma_(k j)^l X_l, stroke: #(paint: red)), tag: #<cancel_gamma_in_semicolon_convention_of_covector_field_2>)) #dots_space #footnote[by @defining_X_semicolon_j_k_and_X_semicolon_k_j] \
      & = partial_k X_j - partial_j X_k
      #annot((<cancel_gamma_in_semicolon_convention_of_covector_field_1>, <cancel_gamma_in_semicolon_convention_of_covector_field_2>), pos: bottom, dx: 8em, dy: 1em)[by $Gamma_(j k)^l = Gamma_(k j)^l$ (@symmetry_of_christoffel_symbols)]
    $

    $arrow.b$

    replace $partial_k X_j - partial_j X_k$ with $X_(j ; k) - X_(k ; j)$ at the right side of @d_xi_proposition_3.3.
    $
      therefore d xi = frac(1, 2) sum_(j comma k) (X_(j ; k) - X_(k ; j)) dx_k and dx_j
    $
  ]
]
#note[As considering @semicolon_convention_is_related_to_nabla, @necessary_and_sufficient_condition_of_Killing_field shows the relationships between the exterior derivative and total covariant derivative.]


#paragraph_tab
There is a useful generalization of the concept of a Killing field, namely a conformal Killing field, which is a vector field $X$ whose flow consists of conformal diffeomorphisms of $M$, that is, preseves the metric tensor up to a scalar factor.

#definition(title: "conformal Killing field")[
  A vector field $X$ is called a conformal Killing field if $cal(L)_X g = lambda(x) g$ for some smooth function $lambda(x)$.
] <definition_of_conformal_killing_field>
#note(title: "intuitive explanation of conformal Killing field")[
	The conformal Killing field(@definition_of_conformal_killing_field) means that at every point, the "stretching" or "shrinking" caused by the vector field is the same in every direction.

	#figure(conformal_killing_field_visualization(), caption: "Intuition to understand conformal killing field") <figure_of_conformal_Killing_field>

  Due to @figure_of_conformal_Killing_field, using the divergence to represent it is inevitable.

] <intuitive_explanation_of_conformal_killing_field>

#paragraph_tab
While @definition_of_conformal_killing_field provides a clean algebraic condition, it leaves the scaling factor $lambda(x)$ as an unknown. To utilize this condition practically, we must express $lambda(x)$ strictly in terms of the vector field $X$. 

#paragraph_tab
We know geometrically that $lambda(x)$ represents uniform scaling across all dimensions due to @intuitive_explanation_of_conformal_killing_field. To extract this total volumetric scaling from the tensor equation, we apply the trace operator. By contracting both sides of the conformal Killing equation with the inverse metric $g^(j k)$, we can isolate the isotropic expansion from the rest of the geometric data.

#flowbox[
  Start with the coordinate expression of the conformal condition, substituting our result from @identitiy_of_Lie_derivative_of_metric_when_torsion_free_2 into @definition_of_conformal_killing_field :
  $ X_(k ; j) + X_( j ; k ) = lambda g_(j k) $ <coordinate_conformal_killing>

  $arrow.b$

  Apply the trace by multiplying both sides by the inverse metric $g^(j k)$ and summing over the indices:
  $ g^(j k) (X_(k ; j) + X_( j ; k )) &= g^(j k) (lambda g_(j k)) $

  $arrow.b$

  Evaluate the left side. By distributing the inverse metric, we raise the lower indices, which yields the divergence of $X$ :
  $ g^(j k) X_(k ; j) + g^(j k) X_( j ; k ) &= X_( ; j)^j + X_( ; k)^k #dots_space #footnote[Recall that $g^(j k)$ raises the index $k$ in $X_(k ; j)$ to yield $X_( ; j)^j$. By definition, the sum of these diagonal components is $op("div") X$.] \
  &= 2 op("div") X $

  Evaluate the right side. The trace of the metric tensor itself is simply the dimension of the manifold, $n$ :
  $ lambda (g^(j k) g_(j k)) = lambda delta_j^j = lambda n $

  $arrow.b$

  Equate the results to solve for the scaling factor $lambda$ :
  $ 2 op("div") X = lambda n quad => quad lambda = frac(2, n) op("div") X $ <lambda_derivation>
]

#paragraph_tab
By defining $lambda$ entirely through the divergence of the field, we remove the unknown variable. Substituting @lambda_derivation back into @coordinate_conformal_killing, we arrive at the definitive equation for a conformal Killing vector field.

#lemma(title: "Conformal Killing Equation")[
  A vector field $X$ on an $n$-dimensional Riemannian manifold is a conformal Killing field if and only if its covariant derivatives satisfy:
  $
    X_(k ; j) + X_( j ; k ) = frac(2, n) (op("div") X) g_(j k)
  $ <formal_conformal_killing_equation>
] <conformal_Killing_vector_field_with_divergence>

#paragraph_tab
Then what did we do? Intuitively, the above arguments is to analyze the vector field $X$. Thus let's deep dive to understand the above arguments intuitively(physically). To truly grasp the physical significance of @formal_conformal_killing_equation, we must look beyond the algebraic derivation and analyze how the vector field physically interacts with the manifold's geometry. The appearance of the symmetric term $X_(k ; j) + X_( j ; k )$ is not an arbitrary mathematical choice; it is a strict geometric necessity forced by the nature of the metric tensor.

#paragraph_tab
Consider the fundamental mismatch between the flow and the space it occupies. A vector field $X$, with contravariant components $X^k$, represents pure velocity or directional flow. However, the geometric "ruler" of the manifold is the metric $g_(j k)$, which is a $(0,2)$-tensor. We cannot mathematically or physically measure how $X$ alters $g$ without making their tensor types compatible. By lowering the index via $X_k = g_(k l) X^l$, we force the vector field to interact with the landscape of the metric. This operation translates a pure velocity vector into a geometric momentum (a 1-form), embedding the scale and curvature of the space directly into our description of the flow.

#paragraph_tab
Once the flow is embedded, #highlight[we measure its spatial variation by taking the total covariant derivative], producing the $(0,2)$-tensor $X_(k ; j)$.#highlight[This total covariant derivative captures all local kinematics, intertwining both the "spinning" (rotation) and the "stretching" (strain) of the space.] However, the metric $g_(j k)$ is perfectly symmetric. If a flow merely rotates a region rigidly, the distances between points remain constant. Because spinning an object does not change its length, the metric is entirely blind to the antisymmetric rotational data.

$
  X_(k ; j) = markul(frac(1, 2) (X_(k ; j) + X_( j ; k )), tag: #<symmetric_part_of_total_covariant_derivative>, color: #red) + markul(frac(1, 2) (X_(k ; j) - X_( j ; k )), tag: #<antisymmetric_part_of_total_covariant_derivative>, color: #blue)

  #annot(<symmetric_part_of_total_covariant_derivative>)[symmetric part] #annot(<antisymmetric_part_of_total_covariant_derivative>)[antisymmetric part]
$ <where_does_the_Killing_field_came_from>

#figure(
  table(
    columns: 4,
    align: horizon,
    [*Name*], [*Mathematical Result*], [*Geometric Name*], [*Physical Effect*],
    [symmetric part], [$1/2 (X_(k;j) + X_(j;k))$], [Deformation], [Stretching/Straining],
    [antisymmetric part], [$1/2 (X_(k;j) - X_(j;k))$], [Exterior Derivative], [Twisting/Rotating]
  ),
  caption: [Decomposition of the total covariant derivative]
)

#paragraph_tab
Therefore, when computing the actual geometric distortion, the antisymmetric part, $X_(k ; j) - X_( j ; k )$, naturally vanishes from the perspective of the metric. We are left exclusively with the symmetric part of the total covariant derivative, $X_(k ; j) + X_( j ; k )$, known as the deformation tensor. This tensor isolates the exact physical stretching of the metric's rulers. For the flow to be conformal, as dictated by @formal_conformal_killing_equation, this pure stretching must be isotropic. It must stretch the space equally in all directions, mathematically manifesting as a uniform scalar multiple of the metric itself.

#note(title: "The relationship between Killing field and conformal Killing field")[As considering @conformal_Killing_vector_field_with_divergence, the Killing field is conformal Killing field whose divergence is zero.

#figure(
  killing-field-visualization(),
  caption: [The Euclidean Killing field $X(x,y)=(-y,x)$. Its arrows are tangent to concentric circles, and its flow is rigid rotation about the origin.]
)<killing_field_visualization>

]

#note(title: "The converse is false")[
Every Killing field is divergence-free, but a divergence-free field need not be Killing. On the Euclidean plane, consider
$
  X(x,y)=(x,-y).
$
Its divergence vanishes:
$
  op("div") X = partial_x x + partial_y (-y) = 1-1=0.
$
However, its flow is
$
  phi_t (x,y)=(e^t x,e^(-t)y).
$
Thus the flow expands the horizontal direction and compresses the vertical direction. Since the two scale factors multiply to one, area is preserved; nevertheless, a circle becomes an ellipse. Equivalently,
$
  cal(L)_X g = 2 d x times.o d x - 2 d y times.o d y != 0.
$
Therefore $X$ is divergence-free but is not a Killing field.

#figure(
  divergence-free-non-killing-visualization(),
  caption: [The divergence-free field $X(x,y)=(x,-y)$ preserves area but deforms a circle into an ellipse. Hence zero divergence alone does not imply the Killing condition.]
)<divergence_free_non_killing_visualization>

#highlight()[Therefore, Killing field condition is more stronger than the divergence-free.]
] <Killing_field_is_more_stronger_condition_than_divergence-free>
