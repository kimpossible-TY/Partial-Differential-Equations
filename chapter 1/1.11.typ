#import "../Styles/styles.typ" : *
#import "figures.typ" : *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.3": *

== Geodesics

=== Geodesics Equation

#paragraph_tab
The geodesic equation is defined by the condition of zero acceleration :
$ nabla_(dot(gamma)) dot(gamma) = 0 $ <zero_acceleration>
Where $dot(gamma)$ is the velocity of the integral curve $gamma$. Suppose $M$ is a smooth manifold. We already know that $dot(gamma)(t_0) in T_(gamma(t_0))M$#footnote[See '3.5 : velocity vectors of curves' by @Manifolds]. If we restrict the time to $gamma$, we can represent $dot(gamma)$ by coordinate representation:
$ dot(gamma) = [d gamma (d / (d t))]_i (partial / (partial x_i))|_(gamma(t_0)) $

#highlighted[Since the 'velocity' concept comes from physics, we abbreviate $[d gamma (d / (d t))]_i$ to $dot(x)^i$.]

#paragraph_tab
Now let's apply the coordinate representation to the @zero_acceleration which is 'zero acceleration. By the product rule of connection, we get:
#flowbox[
$ 
nabla_dot(gamma)
(dot(x)^i E_i)
$
where ${E_i}$ is the frame of the tangent space

$arrow.b$

$ dot(x)^i nabla_(dot(gamma)) E_i + dot.double(x)^i E_i $

$arrow.b$

$dot(gamma) shell.l dot(x)^i
shell.r$ is actually $dot.double(x)^i$

$arrow.b$

$dot(x)^i nabla_dot(gamma) E_i
+
dot.double(x)^i E_i$
]

#paragraph_tab
We can apply the coordinate representation to the subscript of $nabla$.
$
dot(x)^i nabla_(dot(x)^j E_j) E_i + dot.double(x)^i E_i &= dot(x)^i dot(x)^j nabla_(E_j) E_i + dot.double(x)^i E_i  & #dots_space #footnote[apply $dot(gamma)=dot(x)^i E_j$ to subscript]

\

&= dot(x)^i dot(x)^j Gamma_(i j)^k E_k + dot.double(x)^i E_i & #dots_space #footnote[by the definition of Christoffel symbols $Gamma_(i j)^k$]
$

#paragraph_tab
Since the summation convention is used and the second term is a single summation, we can change the dummy index of the second term to $k$.

#definition[
$dot(x)^i dot(x)^j Gamma_(i j)^k + dot.double(x)^k = 0$
This is called the geodesics equation.
]
#definition[For every  smooth curve $gamma : I arrow M$, we define the acceleration of $gamma$ to be the vector field $D_t gamma'$ along $gamma$. A smooth curve $gamma$ is called a geodesic whose acceleration is zero.#footnote[Since this definition came from 『introduction to Riemannian manifold』, check theorem 4.24 if you wonder what $D_t$ is. ]]
#definition[If we write the component functions of $gamma$ as $gamma(t)=
(shell.l x_1(t), dots.h , x_n(t)shell.r)$, then  is called the geodesic if and only if its component functions satisfy the geodesic equation.
]

#note[
  Since the 'inline' geodesic equation naturally induced from the 'zero acceleration' condition, we often call @zero_acceleration the geodesic equation.
]

=== Interpretation Of The Geodesics Equation <interpretation_of_geodesics_equation>

#paragraph_tab
Now, let's interpret the geodesics equation. Note that $dot(gamma)$ is the component of the velocity of curve. Then what does $dot.double(gamma)$ mean? To understand it, let's make the problem easier. The velocity of curve means 'the time derivative when some particle moves from the $gamma(t_0)$ to $gamma(t_(e n d))'$.

#paragraph_tab
Actually the velocity of curves doesn't really means the velocity of particle, because the time shifting on the 'time line' is constant, which is represented to $partial / (partial t)$. As more rigorous speaking, the velocity of curve means the velocity of the particle which moves constantly.

#paragraph_tab
It seems like a contradiction, because we define the velocity which moves constantly! As speaking by physics, 'the velocity' doesn't measure on the manifold what particles is on, but also it measure outside of the manifold! Thus if the manifold is band, the velocity measured from the outside isn't constant even if the velocity measured on the manifold is constant.

#emphasis(title: "The Core Idea: Curvature and Perspective")[
  *Intrinsic View:* An ant walking this line perceives its path as perfectly straight. It experiences zero acceleration.
  
  *Extrinsic View:* Imagine we roll the paper into a cylinder. From our "outside" view in 3D space, the ant's path is a helix. A particle moving along a helix has a non-zero acceleration vector (it's constantly changing direction to curve around the cylinder).
]

#paragraph_tab
Now, we know that the velocity of curve is determined by degree of bending of $M$. #highlighted[So, if the space is flat, $dot(gamma)$ is constant, and it induces $dot.double(gamma) = 0$ directly.] Thus the acceleration $gamma$ means the 'degree of bending of $M$'. Let's apply it to the geodesic equation. #highlight[The geodesic equation is the mathematical expression of the intrinsic view because the left side is globally zero and it matches the intrinsic acceleration!]

$ dot(x)^i dot(x)^j Gamma_(i j)^k + dot.double(x)^k = 0 $
#emphasis[
+ The term $dot.double(x)^k$ represents the extrinsic acceleration—the acceleration of the curve's coordinates as seen from the embedding space. 
+ The term $dot(x)^i dot(x)^j Gamma_(i j)^k$ is the correction factor. It precisely quantifies the apparent acceleration created by the manifold's own curvature.
]

#paragraph_tab
By setting the sum to zero, the geodesic equation defines a path where the extrinsic acceleration is perfectly canceled by the curvature of the space itself. This is the definition of a path with zero intrinsic acceleration—a path that is as "straight as possible" on the manifold.

#paragraph_tab
Now, let's develop the idea that 'the straight line' can be not straightforward depending on the above perspective. We abstract the 'straight line' is a shortcut which was treated at 'Calculus of variation'. First, we have to construct the 'length functional' from the integral curve $gamma$. #highlighted[We can't use $gamma$ just like that, because it is just a symbol! We have to unpack the length of general integral curve.]

$ 
L = integral || dot(gamma) || d t #dots_space #footnote[Since this definition came from _Introduction to Riemannian manifold_ check theorem 4.24 if you wonder what $D_t$ is.] 
$

#paragraph_tab
We unpack the norm squared:

$
|| dot(gamma) ||^2 &= < dot(gamma), dot(gamma) >_g \
&= g_(gamma(t)) (dot(gamma), dot(gamma)) \
&= (g_(i j) d x^i times d x^j) (dot(gamma), dot(gamma)) \
&= g_(i j) d x^i (dot(gamma)) d x^j (dot(gamma)) \
&= g_(i j) d x^i (dot(x)^l partial / (partial x^l)) d x^j (dot(x)^m partial / (partial x^m)) \
&= g_(i j) dot(x)^l d x^i (partial / (partial x^l)) dot(x)^m d x^j (partial / (partial x^m)) \
&= g_(i j) dot(x)^l delta_l^i dot(x)^m delta_m^j \
&= g_(i j) dot(x)^i dot(x)^j #dots_space #footnote[by the definition of tensor product and basic property of kronecker-delta]
$

#paragraph_tab
Second, suppose $F(x, dot(x)) := sqrt(g_(i j) dot(x)^i dot(x)^j)$#footnote[The reason why $x$ is a independent variable of $F$ is $gamma( t )$ is actually the compact set of $x$.]. The length functional is:

$ L = integral sqrt(g_(i j) dot(x)^i dot(x)^j) d t $

#paragraph_tab
Let's apply the Euler-Lagrange equation to the length functional:
#flowbox[
$ d / (d t) ( (partial F) / (partial dot(x)^l) ) - (partial F) / (partial x^l) = 0 $

$arrow.b$

$
cases(
  (partial F) / (partial dot(x)^l) = 1/2 (g_(i j) dot(x)^i dot(x)^j)^(-1/2) markrect(partial / (partial dot(x)^l) (g_(i j) dot(x)^i dot(x)^j), tag: #<first>, color: #blue),
  (partial F) / (partial x^l) = 1/2 (g_(i j) dot(x)^i dot(x)^j)^(-1/2) markrect(partial / (partial x^l) (g_(i j) dot(x)^i dot(x)^j), tag: #<second>, color: #red)
)

#annot(<first>, pos: top+right, dx: 2em)[first]
#annot(<second>, pos: bottom+right, dx: 2em)[second]
$
]

#paragraph_tab
To compute the Euler-Lagrange equation, first we have to compute $(partial) / (partial dot(x)^l) (g_(i j) dot(x)^i dot(x)^j)$.

$
partial / (partial dot(x)^l) (g_(i j) dot(x)^i dot(x)^j) &= g_(i j) partial / (partial dot(x)^l) (dot(x)^i dot(x)^j) \
&= g_(i j) [ (partial dot(x)^i) / (partial dot(x)^l) dot(x)^j + (partial dot(x)^j) / (partial dot(x)^l) dot(x)^i ] \
&= g_(i j) [ delta_l^i dot(x)^j + delta_l^j dot(x)^i ] \
&= g_(l j) dot(x)^j + g_(i l) dot(x)^i
$

#paragraph_tab
Since the Riemannian metric $g_(i l)$ is symmetric, $g_(l j) = g_(j l)$. In addition, $i$ and $j$ are just the separated 'dummy indices'
#footnote[Separated dummy indices means $g_(l j)dot(x)^j+g_(i l)dot(x)^i
= sum_j g_(l j)dot(x)^j + sum_i g_(i l)dot(x)^i$, so there is no problem that $i=j$, because each summations doesn't impact another.]
, we can rename it to whatever we want. Thus let's rename $i$ to $j$. Therefore, we have:

$ partial / (partial dot(x)^l) (g_(i j) dot(x)^i dot(x)^j) = 2 g_(l j) dot(x)^j $

#paragraph_tab
Hence,

$ (partial F) / (partial dot(x)^l) = (g_(l j) dot(x)^j) / F $

#paragraph_tab
Second, let's compute $(partial) / (partial x^l) (g_(i j) dot(x)^i dot(x)^j)$.

$
partial / (partial x^l) (g_(i j) dot(x)^i dot(x)^j) &= ((partial g_(i j)) / (partial x^l)) (dot(x)^i dot(x)^j) + cancel(g_(i j) (partial / (partial x^l) (dot(x)^i dot(x)^j))) \
&= ((partial g_(i j)) / (partial x^l)) (dot(x)^i dot(x)^j) 
#dots_space #footnote[because $dot(x)$ is independent to $x$]
$

#paragraph_tab
Thus:

$ (partial F) / (partial x^l) = 1 / (2 F) ((partial g_(i j)) / (partial x^l)) (dot(x)^i dot(x)^j) #dots_space #footnote[Note that $x=phi(p)$ where $p in M$ and $phi$ is the coordinate chart map, and $dot(x):=d gamma ( frac(d,d t) )$. So $dot(x)eq.not frac(d x, d t)$.] $

#paragraph_tab
The time derivative of $(partial F) / (partial dot(x)^l) = (g_(l j) dot(x)^j) / F$ is easier than the above. Since the shortcut means the 'straight line', the time derivative of $F$ which is $(d F) / (d t) = 0$.#footnote[Note that $F$ is similar to the velocity of $gamma$, because we defined it $F:= || dot(gamma)^2 ||$. Thus, $(d F) / (d t)$ is similar to the acceleration, which must be zero on the straight line.] Since $g_(l j)$ is determined by $p in M$, we differentiate it by time via chain rule.

$ 1 / F d / (d t) (g_(l j) dot(x)^j) = 1 / F [ (partial g_(l j)) / (partial x^m) dot(x)^m dot(x)^j + g_(l j) dot.double(x)^j ] $

#paragraph_tab
Hence, we get the Euler-Lagrange equation as combining the above works.

$
cancel(1 / F) [ g_(l j) dot.double(x)^j + (partial g_(l j)) / (partial x^m) dot(x)^m dot(x)^j - 1 / 2 ((partial g_(i j)) / (partial x^l)) (dot(x)^i dot(x)^j) ] = 0 & "Euler-Lagrange equation"
\
=
g_(l j) dot.double(x)^j + (partial g_(l j)) / (partial x^m) dot(x)^m dot(x)^j - 1 / 2 ((partial g_(i j)) / (partial x^l)) (dot(x)^i dot(x)^j)
  & "Simplified the above"

$

#paragraph_tab
Now, let's compare the Simplified equation with geodesics equation. #highlight[Since our goal is to describe the Christoffel symbol, let's isolate the acceleration term.]
$ 
g_(l j) dot.double(x)^j + (partial g_(l j))/(partial x^m) dot(x)^m dot(x)^j
- 1/2 ((partial g_(i j))/(partial x^l)) (dot(x)^i dot(x)^j)
\
= delta_j^k dot.double(x)^j +
underbrace(
  g^(k l) (partial g_(l j))/(partial x^m) dot(x)^m dot(x)^j
  - (g^(k l))/2 (partial g_(l j))/(partial x^l) (dot(x)^i dot(x)^j),
  "want to group these into a single term"
)
#dots_space #footnote[by multiplying the inverse of $g_(k l)$ ], #footnote[multiplying the inverse of $g_(k l)$ is more intuitive, but using $g^(k l)$ brings us to more general way], #footnote[Now $l$ is dummy index. the kronecker-delta is induced by $sum_(l=1)^n g^(k l)_(l j)=delta_l^k$]
$ 

Since $m$ and $j$ are just the dummy indices, we can swap $m <-> j$. Thus we get :
$ g_(l j) dot.double(x)^j + (partial g_(l j))/(partial x^m) dot(x)^m dot(x)^j
- 1/2 ((partial g_(i j))/(partial x^l)) (dot(x)^i dot(x)^j)
\ -> delta_l^k dot.double(x)^j + g^(k l) (partial g_(l j))/(partial x^m) dot(x)^m dot(x)^j - (g^(k l))/2 (partial g_(i j))/(partial x^l) (dot(x)^i dot(x)^j) #dots_space #footnote[by multiplying the inverse of $g_(k l)$]
\
= delta_l^k dot.double(x)^j + g^(k l) 1/2 (
  mark((partial g_(l j))/(partial x^m) dot(x)^m dot(x)^j + (partial g_(l m))/(partial x^j) dot(x)^j dot(x)^m, color:#blue)
  - (partial g_(i j))/(partial x^l) dot(x)^i dot(x)^j
)
 #dots_space #footnote[by swapping  $m <-> j$ and decomposing]
\
= delta_l^k dot.double(x)^j + g^(k l) 1/2 (
  mark((partial g_(l j))/(partial x^i) dot(x)^i dot(x)^j + (partial g_(l i))/(partial x^j) dot(x)^j dot(x)^i, color:#green)
  - (partial g_(i j))/(partial x^l) dot(x)^i dot(x)^j
)#dots_space #footnote[by swapping $m <-> i$]
\
= dot.double(x)^k + g^(k l) 1/2 (dot(x)^i dot(x)^j)
(
  (partial g_(l j))/(partial x^i) + (partial g_(l i))/(partial x^j) - (partial g_(i j))/(partial x^l)
) #dots_space #footnote[ grouping to $dot(x)^i dot(x)^j$]
\
= dot.double(x)^k + dot(x)^i dot(x)^j Gamma^k_(i j) #dots_space #footnote[which is the Geodesics equation]
\
= 0 $

#paragraph_tab
Swapping dummy indices $m <-> j$ and using symmetry:

$
dot.double(x)^k + g^(k l) 1 / 2 ( (partial g_(l j)) / (partial x^i) + (partial g_(l i)) / (partial x^j) - (partial g_(i j)) / (partial x^l) ) dot(x)^i dot(x)^j = 0
$

#paragraph_tab
Hence we have the specific equation of Christoffel symbol:

$ Gamma_(i j)^k = g^(k l) 1 / 2 ( (partial g_(l j)) / (partial x^i) + (partial g_(l i)) / (partial x^j) - (partial g_(i j)) / (partial x^l) ) $ <geodesics_equation_with_metric>
where $l$ is dummy index.

=== Exponential Maps

#paragraph_tab
To deepen our understanding of geodesics, we need to study their collective behavior. 
#emphasis[How do geodesics change if we vary the initial point or the initial velocity?]

The dependence of geodesics on the initial data is encoded in a map from the tangent bundle into the manifold, called the 'exponential map'.

#paragraph_tab
Rescaling Lemma#footnote[Lemma 9.3 by @Riemannian] gives us that geodesics with proportional initial velocity are related in a simple way: 
$
markhl(gamma_(c v) (t), tag: #<exponential_map>) = gamma_v (c t)

#annot(<exponential_map>, pos: top + left)[it will be the exponential map]
$

By the rescaling lemma, we know that if we vary the velocity, it impact to the time linearly. It allows us to define a map from the tangent bundle to $M$ itself.

#definition[
  Define a subset $cal(D) subset.eq T M$, the domain of the exponential map, by $S := {v in T M : gamma_v "is defined on an interval containing" [0,1]}$. And then define the exponential map $exp: cal(D) -> M$ by:
  $ exp(v) = gamma_v (1) $
  For each $p in M$, the restricted exponential map at $p$, denoted by $exp_p$ is the restriction of $exp$ to the set $S_p = S inter T_p M$.
]

#proposition(title:[5.19#footnote[@Riemannian] (Properties of the Exponential Map)])[Let $(M, g)$ be a Riemannian or pseudo-Riemannian manifold, and let $exp: cal(D) -> M$ be its exponential map.
  + $cal(D)$ is an open subset of $T M$ containing the image of the zero section, and each set $S_p subset.eq T_p M$ is star-shaped with respect to 0.
  + For each $v in T M$ the geodesic $gamma_v$ is given by $gamma_v (t) = exp(t v)$ for all $t$ such that either side is defined.
  + The exponential map is smooth.
  + For each point $p in M$, the differential $d(exp_p)_0 : T_0 (T_p M) tilde.eq T_p M -> T_p M$ is the identity map of $T_p M$ under the usual identification of $T_0 (T_p M)$.
]

#proof[
  The rescaling lemma with $t=1$ says precisely that $exp(c v) = gamma_(c v) (1) = gamma_v (c)$ whenever either side is defined, which is (b).

  #paragraph_tab
  The first argument is also proved by the rescaling lemma. 'Star-shaped with respect to 0' means every element of $S_p$ on a line which pass though 0. Thus it is sufficient to show that the end point of some straight path passing though the origin doesn't lie on the kernel space of $exp_p$.
  $ exp_p (t v) = gamma_(t v) (1) = gamma_v (t) #dots_space #footnote[by the rescaling lemma] $
  Thus the end point of some straight path $t v$ doesn't lie on the kernel space.

  #paragraph_tab
  Finally, let's prove (d). To compute $d(exp_p)_0 (v)$ for an arbitrary vector $v in T_p M$ we just need to choose a curve $tau$ starting at 0 whose initial velocity is $v$.#footnote[Actually, the notation $d (exp_p)_0 (v)$ is dropped the curve $d(exp_p)(v)(tau)$. By the definition of differential, $d(exp_p(v)(tau))$ is correct.]
  
  $
  d(exp_p)_0 (v') &= d(exp_p)_0 (v) \
  &= d(exp_p)_0 (v) (tau) \
  &= d / (d t) |_(t=0) (exp circle.small tau) (t) \
  &= d / (d t) |_(t=0) (exp(tau(v)))
  $

#highlighted[Since $exp_p$ is smooth which implies the continuous, it is locally path-independent by $epsilon - delta$ argument.]#footnote[This 'path-independent argument' is the same as Lemma 4.3 of @Complex] Thus there is no problem that we assume $tau = t v$.

  $
  d / (d t) |_(t=0) (exp(tau(v))) &= d / (d t) |_(t=0) exp(t v) \
  &= d / (d t) |_(t=0) gamma_v (t) \
  &= v #dots_space #footnote[by the physical definition of velocity]
  $
]

==== Normal Neighborhoods and Normal Coordinates#footnote[chatper 6 of @Riemannian]

#paragraph_tab
By Proposition 5.19 (d), we know that $d(exp_p)_0$ can be identity, which is invertible. If $d(exp_p)_0$ is invertible, the derivative of $exp_p : V -> U$ is also invertible. Thus, the inverse function theorem guarantees that there exist a neighborhood $V$ of the origin in $T_p M$ and a neighborhood $U$ of $p$ in $M$ such that $exp_p : V -> U$ is a diffeomorphism.

#definition[
  A neighborhood $U$ of $p in M$ that is the diffeomorphism image under $exp_p$ of a star-shaped neighborhood of $0 in T_p M$ is called a normal neighborhood of $p$.
]

=== Geodesics And Minimizing Curves

#paragraph_tab
We connected the geodesics equation and Euler-Lagrange equation only by that the geodesic equation describes the 'straight line'. The 'straight line' argument, however, was made by a 'guesswork', not proved rigorously. In this sub-section, we prove that the geodesics are related to the 'minimizing curves'.

#definition[
  Let $(M,g)$ be a Riemannian manifold. An admissible curve $gamma$ in $M$ is said to be a minimizing curve if $L_g (gamma) <= L_g (tilde(gamma))$ where $L_g$ is the Riemannian Distance Function for every admissible curve $tilde(gamma)$ with the same endpoints.
]

==== Families of Curves

#definition[
  Given intervals $I, J subset.eq RR$ a continuous map $Gamma: J times I -> M$ is called a one-parameter family of curves.
]

#definition[
  Such a family defines two collections of admissible curves in $M$. The main curves $Gamma_s (t) = Gamma(s, t)$ defined for $t in I$ by holding $s$ as constant, and the transverse curves $Gamma^((t)) (s) = Gamma(s, t)$ defined for $s in J$ by holding $t$ as constant.
]

#definition[
  If such a family $Gamma$ is smooth, we denote the velocity vectors of them by:
  $
  cases(
    partial_t Gamma(s, t) = (Gamma_s)'(t) in T_(Gamma(s, t)) M,
    partial_s Gamma(s, t) = (Gamma^((t)))'(s) in T_(Gamma(s, t)) M
  )
  $
]

#definition[Each of these is an example of a vector field along $Gamma$, which is as continuous map $V:J times I arrow T M$ such that $V(s,t) in T_(Gamma(s,t)) M$ for each $(s,t)$.
#figure(variation_field(), caption: "components of the variation field")
]

#definition[
  If $gamma: [a, b] -> M$ is a given admissible curve, a variation of $gamma$ is an admissible family of curves $Gamma: (-epsilon, epsilon) times [a, b] -> M$ such that $J$ is an open interval containing 0.
]

#definition[
  It is called a proper variation if in addition, all of the main curves have the same starting and ending points.
]

#definition[
We can say a bit more about $partial_s Gamma$, though. If $Gamma$ is an admissible family, a piecewise smooth vector field along $Gamma$ is a continuous vector field along $Gamma$ whose restriction to each rectangle $J times [a_(i-1), a_i]$ is smooth for some admissible partition $(a_0,dots, a_k)$ for $Gamma$.

]

#definition[
  If $Gamma$ is a variation of $gamma$, the variation field of $Gamma$ is the piecewise smooth vector field $V(t) = partial_s Gamma(0, t)$#footnote[It means compute the derivative with respect to $s$ nearby $(0,t)$] along $gamma$. We said that a vector field $V$ is proper if $V(A)=0$ and $V(b)=0$.
]
#note[Since $Gamma$ is the admissible family, the tangent of $Gamma$ which is $V$ can be everything if it has the components whose direction is transverse to $gamma'$]

#lemma(title :"6.1")[If $gamma$ is an admissible curve and $V$ is a piecewise smooth vector field along $gamma$, 
+ then $V$ is the variation field of some variation of $gamma$.
+ If $V$ is proper, the variation can be taken to be proper as well.]
#proof[
The given condition which is ‘$V$ is along $gamma$' means $V(s,t) in T_(gamma(t)) M$ for some fixed $s$. To prove the first statement, it is sufficient to find some suitable variation. As considering that the variation is created by the ‘$J$-axis', the exponential map which propagates to $J$-direction is the variation curve which is very intuitive because it is related to the ‘straight line'. Thus the variation of $gamma$ is :

$
Gamma(s,t) = exp_(gamma(t)) (s V(t))
$

#paragraph_tab
It is easy to show that $V$ is the variation field. It is proved similar to Proposition 5.19 (d).
]

#lemma(title: "6.2 (Symmetry Lemma)")[Let $Gamma: J times [a, b] -> M$ be an admissible family of curves in a Riemannian manifold. On every rectangle $J times [a_(i-1), a_i]$ where $Gamma$ is smooth,
  $ D_s partial_t Gamma = D_t partial_s Gamma $
]
#proof[
$D_s$ is the connection and $partial_s$ is not a `common` derivative. Thus let's represent them more clear. Writing the components of $Gamma$ as $Gamma(s,t) = (x^1(s,t),...,x^n(s,t))$, we have :

#flowbox[
$ partial_t Gamma = (partial x^k)/(partial t) partial_k Gamma = (partial x^k)/(partial s) partial_k Gamma $

$arrow.b$

Use the coordinate formula which is formulated to Theorem 4.24 :

$ cases(
        D_s partial_t Gamma = (partial^2 x^k)/(partial s partial t) + (partial x^i)/(partial s) (partial x^j)/(partial t) Gamma^k_(j i),
        D_t partial_s Gamma = (partial^2 x^k)/(partial t partial s) + (partial x^i)/(partial t) (partial x^j)/(partial s) Gamma^k_(j i)
      ) $

]
Since the $i$ and $j$ are dummy indices, we can switch $i$ to $j$ in the second line above. And then, using the symmetry condition $Gamma^k_(i j) = Gamma^k_(j i)$, we conclude that these two expressions are equal.

]

==== Minimizing Curves Are Geodesics
#paragraph_tab
Traditionally, the derivative of a functional on a space of maps is called its first variation.

#theorem(title: "6.3 (First Variation Formula)")[Let $(M, g)$ be a Riemannian manifold. Suppose $gamma: [a, b] -> M$ is a unit-speed admissible curve, $Gamma: J times [a, b] -> M$ is a proper variation of $gamma$, and $V$ is its variation field. Then $L_g (Gamma_s)$ is a smooth function of $s$, and
  $ d / (d s) |_(s=0) L_g (Gamma_s) = - integral_a^b < V, D_t gamma' > d t - sum_(i=1)^(k-1) < V(a_i), Delta_i gamma' > $ #<variation_formula>
  #figure(jumping(),caption: [$Delta_i gamma'$ is the "jump" in $gamma'$ at $a_i$])
]

#note[
  $Delta gamma'$ can be interpreted to sharpness. A sharp corner exists if these two velocity vectors are different. The "jump" or difference between them is defined as $Delta gamma' = gamma'(a_i^+) - gamma'(a_i^-)$.
]

#proof[
  Actually, the above equation is just the result of massive and boring computations.

  #paragraph_tab
  First, introduce the notations for comfortable.
  $ T(s,t) = partial_t gamma(s,t), quad S(s,t) = partial_s gamma(s,t) $

  Then, by the definition of length, we get :

  #flowbox[
    $
      d / (d s) L_g (Gamma_s |_{[a_(i-1), a_i]}) &= integral_(a_(i-1))^(a_i) partial / (partial s) chevron.l T, T chevron.r^(1/2) d t #dots_space #footnote[by the definition of length] \
      &= integral_(a_(i-1))^(a_i) 1/2 chevron.l T, T chevron.r^(-1/2) 2 chevron.l D_s T, T chevron.r d t #dots_space #footnote[by the chain rule] \
      &= integral_(a_(i-1))^(a_i) 1 / abs(T) chevron.l D_s T, T chevron.r d t #dots_space #footnote[By Lemma 6.2] \
      arrow.b 
      \
      d / (d s) |_(s=0) L_g (Gamma_s |_{[a_(i-1), a_i]}) &= integral_(a_(i-1))^(a_i) chevron.l D_s V, gamma' chevron.r d t #dots_space #footnote[by $S(0,t) = V(t)$ and $T(0,t) = gamma'(t)$] \
      &= integral_(a_(i-1))^(a_i) (d / (d t) chevron.l V, gamma' chevron.r - chevron.l V, D_t gamma' chevron.r) d t #dots_space #footnote[by $d/(d t) chevron.l V, W chevron.r = chevron.l D_t V, W chevron.r + chevron.l V, D_t W chevron.r$] \
      &= chevron.l V(a_i), gamma'(a_i^+) chevron.r - chevron.l V(a_(i-1)), gamma'(a_(i-1)^-) chevron.r \
      &quad - integral_(a_(i-1))^(a_i) chevron.l V, D_t gamma' chevron.r d t #dots_space #footnote[by the fundamental theorem of Calculus]
    $
  ]
]

#note[Actually it is the same as :
$ delta J = integral_(x_0)^(x_1) [F_y - d/(d x) F_(y')] h(x) thin d x +
F_(y') thin delta y |_(x=x_0)^(x=x_1) +
(F - F_(y') y') thin delta x |_(x=x_0)^(x=x_1) $
which is treated at "3.1 : Derivation of the basic formula" by @Variation
]

#paragraph_tab
Now, finally we prove that the minimizing curve is related to geodesic.

#theorem(title: [6.4 #footnote[@Riemannian]])[In a Riemannian manifold, every minimizing curve is a geodesic when it is given a unit-speed parametrization.
]
#proof[
  Suppose $gamma: [a,b] -> M$ is minimizing and of unit speed, and $Gamma_s$ is any proper variation of $gamma$.

  #paragraph_tab
  #highlighted[The mathematical expression of 'minimizing curve' is $partial / (partial s) |_(s=0) L_g (Gamma_s) = 0$.]#footnote[It is the same argument that $Delta J[h]=0$ where $h->0$ which were treated at "Calculus of variation @Variation".] Thus it is good to use the first variation formula. 

  #paragraph_tab
  Now, imagine the shortest path between two points is a straight line (acceleration is zero). The first part of the proof might be that the path can't have any "wobbles" or "curves" in it. However, this still allows for a path that is made up of several straight line segments connected at sharp angles, like a zigzag line. 
  
  #paragraph_tab
  While each individual segment of the zigzag is "straight" (a geodesic), the overall path is clearly not the shortest route. To prove that the minimizing curve is a single geodesic, we must also prove that these "corners" cannot exist. Therefore, the proof is a two-step process:
  #emphasis[+ *No Bends*: First, show that the path must be "straight" on each piece, meaning it's a "broken geodesic".
  + *No Corners*: Then, show that these straight pieces must connect smoothly, eliminating the possibility of corners and proving the path is one continuous geodesic.]

  #paragraph_tab
  First, let's prove the minimizing curve has no bends which is 'locally geodesic'. As mathematically speaking, $partial / (partial s) |_(s=0) L_s (Gamma_s) = 0$ induces $D_t gamma' = 0$. Define the variation field $V := D_t gamma'$.

  #paragraph_tab
  Since we treat the 'local', it is sufficient to restrict $V$ to local by using the bump function $phi$. Then how can we define the subset of the domain that $phi$ isn't zero? #highlighted[Since we consider to use the first variation formula, let's restrict $V$ on $(a_(i-1), a_i)$, such that $phi = 0$ outside of $(a_(i-1), a_i)$.]#footnote[Why we define the restriction using open interval? It is because the bump function must be smooth on the whole domain. If we define the 'non-zero area' of using the closed interval, it contradicts to the smoothness!]
  Now, apply the first variation formula!

  #flowbox[
    $
      markrect(d / (d s) |_(s=0) L_g (Gamma_s),color: #blue, tag:#<minimizing_curve_condition>)
      &= - integral_(a_(i-1))^(a_i) chevron.l V, D_t gamma' chevron.r d t
      \ & cancel(- chevron.l V(a_i) comma Delta _i gamma' chevron.r)
      #dots_space #footnote[Since $Gamma_s$ is proper, $V(a_i)=0$] 
      \
      arrow.b 
      \
      integral_(a_(i-1))^(a_i) phi abs(D_t gamma')^2 d t &= 0 #dots_space #footnote[by restricted V, $V_"restricted" := phi D_t gamma'$]

      #annot(<minimizing_curve_condition>, pos: top+left, dx: -2em)[will be 0]
    $
  ]
  Since $phi$ is not zero on $(a_(i-1), a_i)$, $D_t gamma'$ must be zero.

  #paragraph_tab
  Second, let's prove the minimizing curve has no corners. This argument is necessary to combine each intervals $(a_(i-1), a_i)$. Similar to the above, define the variation field $V(a_i) = Delta_i gamma'$ and its restriction $V_"restricted" = rho_epsilon Delta_i gamma'$ on $(a_i - epsilon, a_i + epsilon)$. Now let's apply the first variation formula(@variation_formula) again!

  #flowbox[
    + $
      integral_(a_i - epsilon)^(a_i + epsilon) chevron.l phi Delta_i gamma', D_t gamma' chevron.r d t lt.eq 2 epsilon space sup chevron.l phi Delta_i gamma', D_t gamma' chevron.r approx 0
    $

    + $
    d / (d s) |_(s=0) L_g(Gamma_s) &= - cancel(integral_a^b chevron.l V comma D_t gamma' chevron.r d t) - sum_(i=1)^(k-1) chevron.l V(a_i), Delta_i gamma' chevron.r \
    &= - chevron.l phi Delta_i gamma', Delta_i gamma' chevron.r #dots_space #footnote[by $phi=0$ outside of $(a_i - epsilon, a_i + epsilon)$ for some $i$] \
    &= 0
  $
  ]
  since $phi$ is not zero, $Delta_i gamma'=0$ which proves there is no corners.
]


=== Hamiltonian Formulation

#paragraph_tab
At the above, we develop what is the 'straight line' using the velocity. In this time, we prove that the geodesic equation is actually the same as the Hamiltonian formalism which is essential of the physics.

#paragraph_tab
To use the Hamiltonian formalism, define the sub-manifolds one is related to position and another is momentum. Those are related by the Riemannian metrics:
$ xi_k = g_(l k) dot(x)^l #dots_space #footnote[At the elementary physics, we learned that the momentum is the product of mass and velocity. Since the mass is already determined as the given conditions, It could be thought as the ‘inheritance of given manifold'. We already learned about it likely the symplectic manifold or Riemannian manifold! Thus let's interpret the mass as covariant tensor not just a scalar. There is no problem to the interpretation, because the covariant tensor of codomain is $bb(R)$, so that we can't distinct between the scalar and value of some covariant tensor. Let's consider the mass as tensor. Then treating the Riemannian metric $g_(l k)$ as mass tensor is most natural! ] $

#paragraph_tab
The Hamiltonian is:
#flowbox[
  $ f(x, xi) := 1 / 2 g^(j k) (x) xi_j xi_k $
  where $f$ is Hamiltonian#footnote[To avoid the confusion with $H$ which is treated at physics, let's use $f$.], and $g^(j k)$ is the inverse of $g_(j k)$.

  $arrow.b$

  *Hamiltonian equations*
  $
  cases(dot(x)^l &= (partial f) / (partial xi_l) = g^(l k) xi_k ,
  dot(xi)_l &= - 1 / 2 (partial g^(l k)) / (partial x^l) xi_i xi_j)
$
]

#paragraph_tab
We want to prove that the system of first-order Hamiltonian equations is equivalent to the second-order geodesic equation. The strategy is to find two different expressions for $dot(xi)_l$ and then equate them. One expression will come from differentiating the relationship between momentum and velocity, and the other will be taken directly from Hamilton's equations.

==== step 1. Express $dot(xi)_l$ using time derivative of $xi_l$ of $dot(xi)_l=g_(l k)(x) dot(x)^k$

We begin with the definition relating the momentum components $dot(xi)$ (covector) to the velocity components $dot(x)$ (vector) via the metric tensor $g_(l k)$.

$ dot(xi)_l = g_(l k)(x) dot(x)^k $

Now, we differentiate this expression with respect to time,$t$, using the product rule and the chain rule for $g_(l k)(t)$.

$
  
dot(xi)_l&=frac(d, d t)
paren.l

g_(l k)(x)dot(x)^k
paren.r
 &
=paren.l
frac(partial g_(l k),partial x_j)frac(d x^j, d t)dot(x)^k+g_(l k)frac(d dot(x)^k, d t)

& "by the chain role"
paren.r
$

Replacing $frac(d x^j, d t)$ with $dot(x)^j$ and $frac(d dot(x)^k, d t)$ with $dot.double(x)^k$, we get our first expression for $dot(xi)_l$:

$
therefore
dot(xi)_l&=
frac(partial g_(l k),partial x_j)dot(x)^j dot(x)^k
+
g_(l k)dot.double(x)^k
$ 
<Hamiltonian_first_step>

==== Step 2: Transform Hamilton's equation for $dot(xi)_l$

#paragraph_tab
Next, we take the second of Hamilton's equations directly:

$ dot(xi)_l = - 1/2 (partial g^(i j)) / (partial x_l) xi_i xi_j $

#paragraph_tab
To make this comparable to @Hamiltonian_first_step, we must express it in terms of the velocity components $dot(x)$ and the covariant metric $g_(a b)$ instead of the momentum $xi$ and the contravariant metric $g^(i j)$.

#paragraph_tab
First, we substitute $xi_i = g_(i a) dot(x)^a$ and $xi_j = g_(j b) dot(x)^b$:

$ dot(xi)_l = - 1/2 markhl((partial g^(i j)) / (partial x_l), tag:#<metric_derivative_to_x_l>) (g_(i a) dot(x)^a) (g_(j b) dot(x)^b) 

#annot(<metric_derivative_to_x_l>, pos: bottom+left, dx:-3em)[how can we compute it?]
$ <hamiltonian_represented_by_xi>

Next, we need a crucial identity that relates the derivative of the inverse metric $g^(i j)$ to the derivative of the metric $g_(a b)$. This comes from differentiating the identity $g^(i a) g_(a k) = delta_k^i$ (the Kronecker delta) with respect to $x_l$:

#flowbox[
$
partial / (partial x_l) (g^(i a) g_(a k)) = 0 #dots_space #footnote[becuase $partial / (partial x_l)I=0$] 
\
arrow.b 
\

(partial g^(i a)) / (partial x_l) markrect(g_(a k), color: #red, tag:#<first_term_of_identity>) markrect(+ g^(i a) (partial g_(a k)) / (partial x_l), color: #blue, tag:#<second_term_of_identity>) = 0 

#annot-cetz(
  (<first_term_of_identity>, <second_term_of_identity>),cetz, {
    import cetz.draw : *
    set-style(mark: (end: "straight"))
    bezier-through((0.2,0), (2,1), (3.2,0.1), stroke: purple)
    bezier-through((1.2,-0.7), (2,-1), (3.2,-0.3), stroke: green)
  }
)

#annot(<first_term_of_identity>, pos :bottom, dy:1em)[divide it to BH]
#annot(<second_term_of_identity>, pos :bottom, dy:1em)[move it to RH]
\
arrow.b \
$

$ therefore
(partial g^(i j)) / (partial x_l) = - g^(i a) ((partial g_(a b)) / (partial x_l)) g^(b j) 
$ <metric_derivative_to_x_l_from_identity>

]


#paragraph_tab
Substituting this identity(@metric_derivative_to_x_l_from_identity) into our expression for $dot(xi)_l$, which is @hamiltonian_represented_by_xi :

$
dot(xi)_l &= - 1/2 [ - g^(i a) ((partial g_(a b)) / (partial x_l)) g^(b j) ] (g_(i p) dot(x)^p) (g_(j q) dot(x)^q) \
&= 1/2 ((partial g_(a b)) / (partial x_l)) markrect((g^(i a) g_(i p)), color: #blue) markrect((g^(b j) g_(j q)), color: #red) dot(x)^p dot(x)^q #dots_space #footnote[Indices have been changed to avoid collision]

$
We can now group terms to simplify. Since $g^(i a) g_(i p) = delta_p^a$ and $g^(b j) g_(j q) = delta_q^b$ the expression simplifies beautifully.

$
dot(xi)_l &= frac(1,2) paren.l
frac(partial g_(a b), partial x_l) 
paren.r

 delta_p^a delta_p^b
 dot(x)^p dot(x)^q

= frac(1,2) frac(partial g_(p q), partial x_l) dot(x)^p dot(x)^q
$

By relabeling the dummy indices $p$ and $q$ to $j$ and $k$, we arrive at our second expression for $dot(xi)_l$:
$
therefore

dot(xi)_l& =frac(1,2) frac(partial g_(j k),partial x_l) dot(x)^j dot(x)^k
$ <hamiltonian_second_step>

==== Step 3: Equate the two expressions and derive the geodesic equation

#paragraph_tab
Now we equate our two derived expressions, @Hamiltonian_first_step and @hamiltonian_second_step:

$
(partial g_(l k)) / (partial x_j) dot(x)^j dot(x)^k + g_(l k) markrect(dot.double(x)^k, color: #blue, tag:#<want_to_isolated>) &= 1/2 (partial g_(j k)) / (partial x_l) dot(x)^j dot(x)^k

#annot(<want_to_isolated>, pos: bottom, dy:1em)[want be isolated]
$

#paragraph_tab
Our goal is to isolate $dot.double(x)^k$. Let's move all terms with $dot(x)^j dot(x)^k$ to one side.

$
g_(l k) dot.double(x)^k &= ( 1/2 (partial g_(j k)) / (partial x_l) - (partial g_(l k)) / (partial x_j) ) dot(x)^j dot(x)^k
$ <combination_first_second>


The term $(partial g_(l k)) / (partial x_j) dot(x)^j dot(x)^k$ contains a summation over dummy indices $j$ and $k$. We can use a standard symmetrization trick:

$ (partial g_(l k)) / (partial x_j) dot(x)^j dot(x)^k = 1/2 ( (partial g_(l k)) / (partial x_j) + (partial g_(l j)) / (partial x_k) ) dot(x)^j dot(x)^k $

#paragraph_tab
Substituting this back into @combination_first_second gives:

$
g_(l k) dot.double(x)^k &= [ 1/2 (partial g_(j k)) / (partial x_l) - 1/2 ( (partial g_(l k)) / (partial x_j) + (partial g_(l j)) / (partial x_k) ) ] dot(x)^j dot(x)^k \
&= - 1/2 ( (partial g_(l j)) / (partial x_k) + (partial g_(l k)) / (partial x_j) - (partial g_(j k)) / (partial x_l) ) dot(x)^j dot(x)^k
$

#paragraph_tab
The term in the parenthesis is precisely the definition of the Christoffel symbols of the first kind. More importantly, we recognize that the entire right-hand side is related to the Christoffel symbols of the second kind, $Gamma_(j k)^p$. So, our equation becomes:

$
g_(l k) dot.double(x)^k = - g_(l p) Gamma_(j k)^p dot(x)^j dot(x)^k #dots_space #footnote[by the formula: $ g_(l p) Gamma_(j k)^p = 1/2 ( (partial g_(p k)) / (partial x_j) + (partial g_(p j)) / (partial x_k) - (partial g_(j k)) / (partial x_p) ) $]
$

#paragraph_tab
Finally, we multiply both sides by the inverse metric $g^(m l)$ and sum over $l$:

$
g^(m l) g_(l k) dot.double(x)^k &= - g^(m l) g_(l p) Gamma_(j k)^p dot(x)^j dot(x)^k \
arrow.b \
delta_k^m dot.double(x)^k &= - delta_p^m Gamma_(j k)^p dot(x)^j dot(x)^k
$

It yields the standard geodesic equation:
$ therefore dot.double(x)^m + Gamma_(j k)^m dot(x)^j dot(x)^k = 0 $

#note[
Thanks to the above arguments, the energy satisfying the Hamiltonian equation makes vector field which is tangent to geodesic.#highlighted[More precisely the velocity of geodesic is the projection of Hamiltonian vector field because geodesic must be determined only by $x in Omega$.] We will more develop it at @Eikonal_Equation_constant.


#flowbox[
$
H_f = sum [ (partial f) / (partial xi_j) partial / (partial x_j) - (partial f) / (partial x_j) partial / (partial xi_j) ] \
H_f in T (T^* Omega) 
\
arrow.b
$

$
"Project" T (T^* Omega) "to" T Omega : "Treat" T^* Omega "as manifold" \
pi(T (T^* Omega)) = pi(T frak(D)) = 0 #dots_space #footnote[where $frak(D) := T^* Omega$ and by the definition of natural projection $pi: T frak(D) arrow frak(D)$] $

$
arrow.b \
gamma' &= pi(H_f) \
&= (partial f) / (partial xi_j) partial / (partial x_j)
$
]
]