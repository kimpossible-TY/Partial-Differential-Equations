#import "../Styles/styles.typ" : *
#import "@preview/mannot:0.3.1" : *

== the Covariant Derivative and Divergence of Tensor Fields

#paragraph_tab
Now we combine the divergence with the covariant derivative and geodesics.

If $X = X^k D_k$ and $D_k = partial / (partial x_k)$, then we can use the convension of @semicolon_standard_practice : 
$ X_( ; j )^k := partial_j X^k + sum_l Gamma_(l j)^k X^l $ 
which satisfies 
$ nabla_(D_j) X = X_( ; j )^k D_k $ <easy_definition_of_semi-colon_convention>


Actually, $X_( ; j )^k$ is directly driven by Proposition 4.6 (@basic_formula_of_connection_in_tangent_bundle) of @Riemannian

$
nabla_A B &= [ (A(B^k) + sum_(i,m) A^i B^m Gamma_(i m)^k) ] E_k & "by proposition 4.6" \
&= [ partial_j (X^k) + sum_(i,m) partial_j|_i X^m Gamma_(i m)^k ] E_k & "by putting " X, partial_j "to" B, A \
&= [ partial_j (X^k) + sum_(i,m) delta_i^j X^m Gamma_(j m)^k ] E_k & "by i-th component of " partial_j \
&= [ partial_j (X^k) + sum_m X^m Gamma_(j m)^k ] E_k & j" is free index"
$

This is $ X_( ; j )^k $

#paragraph_tab
The divergence of a vector field has an important expression in terms of the covariant derivative.

#proposition(title: "3.1")[Given a vector field $X$ with components $X^k$, then
$ op("div") X = sum_j X_( ; j )^j $ <divergence_and_semi_comma>
]

#proof[Since $X_( ; j )^j$ is related to the geodesic, it is good way to use the following formula defining with $frak(g) := det g$.:
$ op("div") X = 1 / sqrt(frak(g)) partial_j (sqrt(frak(g)) X^j) #dots_space #footnote[by using @formula_of_divergence] $
Then our goal is to represent right side to $X_( ; j )^j$.

#paragraph_tab
First, let's compute the partial derivative. By the chain rule, we get:
$ 1 / sqrt(frak(g)) partial_k sqrt(frak(g)) = 1 / sqrt(frak(g)) (1 / (2 sqrt(frak(g))) partial_k frak(g)) = 1 / (2 frak(g)) partial_k frak(g) $

Then how can we compute $partial_k frak(g)$? Since $frak(g)$ is actually $det g$, it is time to use Jacobi's formula!
$ d / (d t) det(A) = det(A) upright(T r)(A^(-1) (d A)/(d t)) & "Jacobi's formula"
$

$
partial_k frak(g) &= frak(g) upright(T r)(g^(i j) partial_k g_(i j)) \
&= frak(g) (g^(i j) partial_k g_(j i)) & "by computing Tr(AB) = " A_(i j) B_(j i) \
&= frak(g) (g^(i j) partial_k g_(i j)) & "by symmetry of Riemannian metric"
$

$ therefore 1 / frak(g) partial_k frak(g) = (g^(i j) partial_k g_(i j)) $ (where $k$ is free index and $i, j$ are dummy indices)

Now applying all of the above things. We have:

$
op("div") X &= 1 / sqrt(frak(g)) partial_j (sqrt(frak(g)) X^j) & "formula for divergence" \
&= partial_j X^j + 1 / sqrt(frak(g)) (partial_j sqrt(frak(g))) X^j & "by distributing" partial_j "(product rule)" \
&= partial_j X^j + (1 / (2 frak(g)) partial_j frak(g)) X^j & "by the chain rule" \
&= partial_j X^j + (1/2 (g^(d_1 d_2) partial_j g_(d_1 d_2))) X^j & "by Jacobi's formula"
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

=== The Killing vector field#footnote[Nobody is actually killed. The concept is named after the 19th-century german mathematician wihelm killing.]

#paragraph_tab
In the view of @divergence_and_semi_comma, we know that a vector field $X$ generates a volume-preserving flow if and only if $X_( ; j )^j=0$. Complementing this, we investigate that the flow leaves the metric g imvariant, or equivalently :
$
	cal(L)_X g =0
$ <second_condition_of_killing_vector_field>
Now, we consider the two conditions.
#emphasis(title: "The conditions that are needed to killing vector field")[
	+ torsion free condition(Levi-Civita condition)
	+ g is invariant to X($cal(L)_X g =0$).
]

#paragraph_tab
To develop our argument, let's investigate @second_condition_of_killing_vector_field more. For arbitrary vector fields $U$ and $V$, we have :
$
cal(L)_X g (U, V) &= - chevron.l cal(L)_X U comma V chevron.r - chevron.l U comma cal(L)_X V chevron.r + X chevron.l U comma V chevron.r #dots_space #footnote[by proposition 12.32 of @Manifolds] \
&= chevron.l nabla_X U - cal(L)_X U comma V chevron.r + chevron.l U comma nabla_X V - cal(L)_X V chevron.r wide dots.h.c thin #footnote[Since $chevron.l U comma V chevron.r_g$ is a scalar function, we get : 
$X chevron.l U comma V chevron.r = nabla_X (chevron.l U comma V chevron.r_g)$.
Moreover, we already know that if torsion free condition is satisfied, then $nabla$ is compatible with $g$. Hence we get :
$nabla_X (chevron.l U comma V chevron.r_g) = chevron.l nabla_X U comma V chevron.r + chevron.l U comma nabla_X V chevron.r$.
] \
&= chevron.l cancel(nabla_X U, stroke: #(paint: blue)) - shell.l cancel(nabla_X U, stroke: #(paint: blue)) - nabla_V X shell.r comma V chevron.r + chevron.l U comma  cancel(nabla_X V, stroke: #(paint: red)) - shell.l  cancel(nabla_X V, stroke: #(paint: red)) - nabla_U X shell.r chevron.r #dots_space #footnote[As we know, the torsion tensor is : $T(X comma V):= nabla_X V - nabla_V X - [X comma V]$. If torsion free condition is satisfied, then $T(X comma V) = 0$ and thus we get : $nabla_X V - nabla_V X = [X comma V]$. By theorem9.38 of @Manifolds, we have : $cal(L)_X V = [X comma V]$. Hence we get : $cal(L)_X V = nabla_X V - nabla_V X$. Similarly, we can get : $cal(L)_X U = nabla_X U - nabla_U X$.] \
&= nabla_U X comma V chevron.r + chevron.l U comma nabla_V X chevron.r
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
$

Since $g_(l k)$ and $g_(j l)$ are actually used to the 'flat operator', which subjects to 'muscial isomorphism', we can apply the following :
#flowbox[
	Define the coefficients of covector fields $X_k$ and $X_j$ naturally which are satisfied :
	$ X_k := g_(k l) X^l , X_j := g_(j l) X^l $
	
	$arrow.b$


]