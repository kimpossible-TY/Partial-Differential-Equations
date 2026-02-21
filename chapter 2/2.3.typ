#import "../Styles/styles.typ" : *

== the Covariant Derivative and Divergence of Tensor Fields

#paragraph_tab
Now we combine the divergence with the covariant derivative and geodesics.

If $X = X^k D_k$ and $D_k = partial / (partial x_k)$, then we can use the convension of @semicolon_standard_practice : 
$ X_( ; j )^k := partial_j X^k + sum_l Gamma_(l j)^k X^l $ 
which satisfies 
$ nabla_(D_j) X = X_( ; j )^k D_k $


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
$ op("div") X = sum_j X_( ; j )^j $
]

#proof[Since $X_( ; j )^j$ is related to the geodesic, it is good way to use the following formula:
$ op("div") X = 1 / sqrt(g) partial_j (sqrt(g) X^j) $
Then our goal is to represent right side to $X_( ; j )^j$.
Let $frak(g) := det g$.

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
op("div") X &= 1 / sqrt(g) partial_j(sqrt(g) X^j) & "formula for divergence" \
&= partial_j X^j + 1 / sqrt(g) (partial_j sqrt(g)) X^j & "by distributing" partial_j "(product rule)" \
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