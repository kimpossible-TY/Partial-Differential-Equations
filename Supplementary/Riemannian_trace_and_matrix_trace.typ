#import "../Styles/styles.typ" : *
#import "figures.typ": *

== Riemannian trace and ordinary matrix trace

#paragraph_tab
At first glance, these two traces look almost the same because both of them seem to "add diagonal terms." However, their roles are conceptually different.

#definition[
The ordinary matrix trace is the trace of a linear map $A : V arrow V$ after choosing a basis:
$
  op("tr")(A) = sum_i A^i_i.
$
]

#definition[
The Riemannian trace is the contraction of a covariant tensor by the metric. For a $(0,2)$ tensor $T$ on a Riemannian manifold $(M, g)$,
$
  op("Tr")_g(T) = g^(i j) T_(i j).
$
]

#paragraph_tab
So the ordinary matrix trace starts with an *endomorphism* $A : V arrow V$. It measures how much of the output of $A$ returns in the same basis directions as the input. Intuitively, it records the total self-action along the chosen coordinate axes.

#paragraph_tab
By contrast, the Riemannian trace usually starts with a $(0,2)$ tensor such as the Hessian. But a $(0,2)$ tensor does not compare input and output directions directly, because it only eats vectors. Therefore the metric is used first to convert one slot into a contravariant one. In other words, #highlight[the metric tells us how to compare the two covariant slots so that a contraction becomes possible.]

#paragraph_tab
This is the main intuitive difference:
#emphasis[
+ Ordinary matrix trace: "A linear map already knows how to send a direction to another direction, so we just sum the self-components."
+ Riemannian trace: "A covariant tensor does not yet know how to compare its two slots, so the metric must first provide the comparison rule."
]

#figure(
  trace-comparison-diagram(),
  caption: [Matrix trace directly reads the self-components, while Riemannian trace first contracts with the metric.]
)

#paragraph_tab
In Euclidean space with orthonormal coordinates, this distinction is easy to miss because the metric coefficients satisfy $g_(i j)=delta_(i j)$ and $g^(i j)=delta^(i j)$. Then
$
  op("Tr")_g (T) = delta^(i j) T_(i j) = sum_i T_(i i),
$
which looks exactly like summing the diagonal entries of a matrix.

#note[
This is why Riemannian trace often feels like ordinary matrix trace in standard Cartesian coordinates. The metric is still present, but it becomes invisible because it is the identity matrix.
]

#paragraph_tab
On a curved manifold or in non-orthonormal coordinates, the difference becomes visible. The quantity
$
  g^(i j) T_(i j)
$
is not merely "add the written diagonal terms" $T_(1 1)+T_(2 2)+dots$. Instead, the inverse metric weights and mixes the components according to the geometry of the manifold.

#paragraph_tab
For example, if $T = op("Hess") u$, then
$
  op("Tr")_g (op("Hess") u) = g^(i j) (op("Hess") u)_(i j) = Delta u.
$
So the Riemannian trace is the operation that turns the Hessian, a $(0,2)$ tensor carrying second-derivative information in all directions, into the scalar Laplacian by averaging those second derivatives according to the metric geometry.

#paragraph_tab
Therefore, the most useful picture is:
#emphasis[
+ Matrix trace is basis-level diagonal summation for an endomorphism.
+ Riemannian trace is metric-dependent contraction for a covariant tensor.
]

#paragraph_tab
They coincide in Euclidean orthonormal coordinates, but conceptually they come from different structures.

#paragraph_tab
To visualize this geometrically, we can look at the Laplacian of a function $u$ representing a surface $z = u(x,y)$. The Laplacian $Delta u = op("Tr")_g (op("Hess") u)$ is the Riemannian trace of the Hessian tensor. Under this operation, the Hessian acts as a $(0,2)$ tensor carrying second-derivative information (directional curvatures) in all directions. The Riemannian trace contracts this tensor with the inverse metric, averaging those curvatures. As a result, the Laplacian $Delta u$ at a point $P$ on the surface is equal to the sum of the principal curvatures of the surface at that point, representing how the surface is pulled towards its center of curvature.

#figure(
  curvature-trace-diagram(),
  caption: [The Riemannian trace of the Hessian (the Laplacian) is the sum of the directional curvatures $kappa_1$ and $kappa_2$ along orthogonal paths.]
)
