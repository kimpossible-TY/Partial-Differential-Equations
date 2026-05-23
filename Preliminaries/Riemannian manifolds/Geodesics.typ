#import "../../Styles/styles.typ" : *

=== Geodesics

#definition[
Let $M$ be a smooth manifold with or without boundary and let $nabla$ be a connection in $T M$. For every smooth curve $gamma: I -> M$ we define the acceleration of $gamma$ to be the vector field $D_t gamma'$ along $gamma$.
] 

#definition[
A smooth curve $gamma$ is called a geodesic if its acceleration is zero. 
] <definition_of_geodesics>

#paragraph_tab
If we write the component functions of $gamma$ as $gamma(t) = (x^1 (t), ..., x^n (t))$, then it follows from definition of acceleration and Theorem 4.24 that $gamma$ is a geodesic if and only if its component functions satisfy the following geodesic equation:

$ dot(x)^k + dot(x)^i (t) dot(x)^j (t) Gamma_(i j)^k (x(t)) = 0 $

#paragraph_tab
The next theorem uses ODE theory to prove existence and uniqueness of geodesics with suitable initial conditions.

#theorem(title:"4.27 (Existence and Uniqueness of Geodesics)")[Let $M$ be a smooth manifold and $nabla$ a connection in $T M$. For every $p in M$, $omega in T_p M$ and $t_0 in RR$, there exist an open interval $I subset.eq RR$ containing $t_0$ and a geodesic $gamma: I -> M$ satisfying $gamma(t_0) = p$ and $gamma'(t_0) = omega$. Any two such geodesics agree on their common domain.]

#proof[
The author already gives the hint how can we prove the theorem. We already know that the ODE solution is unique and exist everywhere. Furthermore we know that the flow has the role of connecting ODE theory and manifold theory! Since the fundamental theorem of flow is what we are looking for, it is sufficient to build some flow or vector field.

#paragraph_tab
#highlighted[The standard trick for proving existence and uniqueness for such a second-order system is to introduce auxiliary variables $v^i = dot(x)^i$ to convert it to the following equivalent first-order system in twice the number of variables:]

$ cases(dot(x)^k (t) = v^k (t), dot(v)^k (t) = -v^i (t) v^j (t) Gamma_(i j)^k (x(t))) $

#paragraph_tab
Treating $(x^1, ..., x^n, v^1, ..., v^n)$ as coordinate on $U times RR^n$, we can recognize the above simultaneous equations for the flow of the vector field $G in frak(X)(U times RR^n)$ given by:

$ G_((x, v)) = v^k partial / (partial x^k) | _((x, v)) - v^i v^j Gamma_(i j)^k (x) partial / (partial v^k) | _((x, v)) $

#paragraph_tab
Since the geodesic is defined by the geodesics equation and the geodesic vector field is just a 'vector field version' of the geodesics equations, we know that the flow of geodesic vector field is geodesic. By the fundamental theorem of flow, the flow of geodesics vector field which is geodesic is unique and exist.
]

==== Geodesic vector field

#paragraph_tab
Since the geodesic vector field appear the above first, it has a crucial role.

#definition[
$G_((x, v)) := v^k partial / (partial x^k) | _((x, v)) - v^i v^j Gamma_(i j)^k (x) partial / (partial v^k) | _((x, v))$
is a global vector field on the total space of $T M$, called the geodesic vector field.
]

#lemma[
The geodesic vector field acts on a function $f in C^infinity (T M)$ by:
$ G f(p, v) = d / (d t) |_(t=0) f(gamma_v (t), gamma_v' (t)) $
Where $gamma$ is the geodesic.
]

#proof[
Using the chain rule and the geodesic equation, we can write the right-hand side of the above as:

$
d / (d t) f(gamma_v (t), gamma_v' (t)) &= d / (d t) f(x, v) #dots_space #footnote[rewrite $gamma arrow.l.r x$ and $gamma' arrow.l.r v$ where $x$ is coordinate representation] \
&= ((partial f) / (partial x^k) (x(t), v(t)) dot(x)^k (t) + (partial f) / (partial v^k) (x(t), v(t)) dot(v)^k (t)) #dots_space #footnote[by using the chain rule] \
&= (partial f) / (partial x^k) (x, v) v^k - (partial f) / (partial v^k) (x, v) v^i v^j Gamma_(i j)^k (p) #dots_space #footnote[by using the auxiliary equations. Note that $dot(v)^k = - v^i v^j Gamma_(i j)^k$] \
&= G f(p, v)
$
]