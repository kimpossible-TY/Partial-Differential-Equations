#import "../../Styles/styles.typ" : *
#import "figures.typ" : *

=== Vector and Tensor Fields Along Curves

#paragraph_tab
Now we can address the question that originally motivated the definition of connections:
How can we make sense of the derivative of a vector field along a curve?

#definition[
Let $M$ be a smooth manifold with or without boundary. Given a smooth curve $gamma: I -> M$, a vector field along $gamma$ is a continuous map $V: I -> T M$ such that $V(t) in T_(gamma(t)) M$ for every $t in I$.
]

#note[
The most obvious example of a vector field along a smooth curve $gamma$ is the curve's velocity.
]

#definition[
The vector field along $gamma$ contains the velocity. A large supply of examples is provided by the following construction: suppose $gamma: I -> M$ is a smooth curve and $tilde(V)$ is a smooth vector field on an open subset of $M$ containing the image of $gamma$. Define $V: I -> T M$ by setting $V(t) = tilde(V)_(gamma(t))$#footnote[Note that it doesn't mean 'locally same', but 'this list of vectors on the curve is just a slice of a larger vector field that fills the space around the curve.'] for each $t in I$. Since $V$ is equal to the composition $tilde(V) compose gamma$, it is smooth. A smooth vector field along $gamma$ is said to be extendible if there exists a smooth vector field on a #highlight[neighborhood] of the image of $gamma$ that is related to $V$ in the following way.

#figure(
  extendible_vector_field(),caption: [Extendible vector field]
) #figure(non_extendible_vector_field(),caption: [Non-extendible vector field])
]

==== Covariant Derivatives Along Curves

#paragraph_tab
Here is the promised interpretation of a connection as a way to take derivatives of vector fields along curves.

#theorem(title:"4.24 (Covariant Derivative Along a Curve)")[Let $M$ be a smooth manifold with or without boundary and let $nabla$ be a connection in $T M$.
For each smooth curve $gamma: I -> M$ the connection determines a unique operator
$ D_t : frak(X)(gamma) -> frak(X)(gamma) $
Called the #highlighted[covariant derivative along $gamma$], satisfying the following properties:
+ Linearity over $RR$: $D_t (a V + b W) = a D_t V + b D_t W$ for $a, b in RR$.
+ Product Rule: $D_t (f V) = f' V + f D_t V$ for $f in C^infinity(I)$.
+ If $V in frak(X)(gamma)$ is extendible, then for every extension $tilde(V)$ of $V$, $D_t V(t) = nabla_(gamma'(t)) tilde(V)$.
]

#paragraph_tab
There is an analogous operator on the space of smooth tensor fields of any type along $gamma$.

#note[
$D_t$ is just the "restriction of $nabla$ to a given curve".
]

#proof[
Since $D_t$ is just the restriction of connection, the linearity and product rule are satisfied. Now, let's prove that such the operator is unique if it exists. Since it is the restriction of $nabla$, we get:

$
V(t) &= V^j (t) partial_j |_(gamma(t)) #dots_space #footnote[where $partial_j |_(gamma(t)) := (partial / (partial x^j))|_(gamma(t))$] \
D_t V(t) &= (D_t V^j (t)) partial_j |_(gamma(t)) + V^j (t) nabla_(gamma'(t)) partial_j |_(gamma(t)) #dots_space #footnote[by the product rule] \
&= (D_t V^j (t)) partial_j |_(gamma(t)) + V^j (t) nabla_(gamma_i' (t) partial_i) partial_j |_(gamma(t)) \
&= (D_t V^j (t)) partial_j |_(gamma(t)) + V^j (t) gamma_i' (t) nabla_(partial_i) partial_j |_(gamma(t)) \
&= D_t V^k (t) partial_k |_(gamma(t)) + V^j (t) gamma_i^' (t) Gamma_(i j)^k partial_k #dots_space #footnote[re-index the first term $j arrow.l.r k$. This interchange is valid because dummy indices are independent.] \
&= (dot(V)^k (t) + gamma_i^' (t) V^j (t) Gamma_(i j)^k) partial_k |_(gamma(t))
$

#paragraph_tab
Since the $Gamma_(i j)^k$ is unique, $D_t V(t)$ is also unique if it exists. As #highlighted[$D_t$ is just the restriction of $nabla$], the existence of it is implied by the existence of the connection.
]

#note[
$(dot(V)^k (t) + gamma_i' (t) V^j (t) Gamma_(i j)^k)$ is suggestive of the 'geodesics equation'.
]