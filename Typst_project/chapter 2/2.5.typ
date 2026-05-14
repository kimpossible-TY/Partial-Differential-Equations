#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.1": *

== The wave equation on a product manifold and energy conservation

#paragraph_tab
The analysis of vibrating membranes in Euclidean space has important extensions to studies of vibrating manifolds. We will start with a fairly general situation, specializing quickly to models that gives rise to "the wave equation".
$
  frac(partial^2 u, partial t^2) = Delta u
$ <wave_equation>

#paragraph_tab
After constructing the wave equation on a product manifold, we will show that the energy of the system is conserved. This is a fundamental property of wave equations and has important implications for the behavior of solutions over time.

=== The wave equation on a product manifold

#paragraph_tab
We consider the vibrations of one Riemannian manifold $(M,g)$ within another, $(N,h)$ where $h$ and $g$ are Riemannian metrics. The vibration is described by a map :
$
  u : bb(R) times M arrow.r N
$ 

#figure(
  domain-codomain-u(),
  caption : [how does $u$ work]
)

#paragraph_tab
Now, we allow $M$ to be a compact manifold with boundary.#footnote[That condition allows Green's identities with boundaries. Moreover, this condition makes to easliy use $u$ without other ackward assumptions.] We will induce the wave equation via action principle. Thus let us define the "kinetic energy" :
$
  T(t) := frac(1, 2) integral_M m(x) norm(d_t u (t,x))^2_h d V
$ <kinetic_energy_for_wave_equation>
where $d V$ is the natural volume element on $M$ and $m(x) >0$ is a given "mass density". $d_t u$ means "a differential at the point $t in bb(R)$, with $x in M$ fixed", just easily undeerstand as "partial differential".
#definition(title: "spatial and time differential")[
  Let $M, N$ are manifolds and $u : bb(R) times M arrow.r N$ is a map. For each fixed time $t in bb(R)$, define :
  $
    u^("sp")_t : M arrow.r N
  $
  Then $d_x u(t,x)$ means $d_x u^("sp")_t$
  
  #paragraph_tab
  Similarly, for each fixed point $x in M$, define $u^("time")_x : bb(R) arrow.r N$
  Then $d_t u(t,x)$ means $d_t u^("time")_x$
] <definitions_of_spatial_and_time_differential>

As considering @definitions_of_spatial_and_time_differential, we know that the "velocity term" of @kinetic_energy_for_wave_equation, which is $d_t u(t,x)$, is in $T_y N$ where $y = u(t,x)$ for some $(t,x)$. Now, we define the "potential energy" :
$
  V(t) := integral_M f(x, u(t,x), d_x u(t,x)) d V
$ <potential_energy_for_wave_equation>
where $f$ is a smooth real-valued function.

#paragraph_tab
How can we determine $f$ naturally? To define it, let investigate the spartial differential. As representing the space of the maps $T_x M mapsto T_y N$ to $cal(L)(T_x M, T_y N)$,
$
  u_x (t,x) in cal(L)(T_x M, T_y N) quad "where" y=u(t,x)
$
Let $A in cal(L)(T_x M, T_y N)$ is a linear map. Then the defining $f$ likely to the following is natural :
$
  f(x,y,A) := op("Tr")(A^* A) 
$ <potential_energy_density>
where $A^* : T_y N arrow.r T_x M, A^* in cal(L)(T_y N, T_x M)$ is the adjoint of $A$ satisfying with :
$
  g_x (A^* W, X)= h_y (W, A X) quad attach(X, tl: forall) in T_x M, attach(W, tl: forall) in T_y N
$
Now, let's build @potential_energy_density naturally. The potential energy density should measure local deformation. So if an infinitesimal direction#footnote[why does the tangent vector mean the infinitesimal direction(change)? We already did at @Manifolds with studying the Noether's theorem.] $X in T_x M$ is transformed only a little by $A: T_x M arrow.r T_y N$, then the local deformation energy should be small. That means the first natural quantity is :
$
  norm(A X)^2_h := h_y (A X, A X)
$ <norm_AX_2_h>
@norm_AX_2_h means :
#emphasis()[
  The more $A$ enlarges an infinitesimal vector $X$, the larger the local deformation should be
]
More easily speaking, If $A X$ is small, then $h_y (A X, A X)$ is small. On the other hands, If $A X$ is large, then $h_y (A X, A X)$ is large. So the first object we want is the quadratic measurement :
$
  X mapsto h_y (A X, A X)
$

#figure(
  image("figures/potential_difference.png"),
  caption: [steep slope VS gentle slope]
)
  
#paragraph_tab
However, the energy density should not depend on one chosed direction. It means $h_y (A X, A X)$ shouldn't depend on a chosed vector $X$. #highlight()[Thus we need an object that records the deformation of all infinitesimal directions at once.] To consider $attach(X, tl: forall) in T_X M$, define the $(0,2)$-tensor on $T_x M$ :
$
  T_A (X , Y)  := h_y (A X, A Y) #dots_space #footnote[In geometric language, $T_A$ is the result of the pullback of the metric $h_y$ by the infinitesimal deformation map $A$. Thus $T_A=A^*h_y$. where $A^*$ is a pullback.]
  \
  T_A (X , Y) in T^*_x M times.o T^*_x M
$ <definition_of_deformation_tensor>
#paragraph_tab
Altough $T_A$ is naturally defined, the potential energy density must be a scalar. Then how can we make the scalar naturally from $T_A$? Since $T_A$ is $(0,2)$-tensor on $T_x M$, the Riemannian metric gives the canonical contraction : 
$
  op("Tr")_g (T_A) = g^(i j) (T_A)_(i j) #dots_space #footnote[See "trace of (0,2)-tensor" in my note of @Manifolds.]
$
Thus, the scalar local deformation energy is naturally :
$
  f(x,y,A)=op("Tr")_g (T_A)
$ <definition_of_potential_energy_density_Riemannian_tensor_version>

#special_lemma()[
  Let $M $ and $N$ are Riemannian manifolds which are compact and $A in cal(L)(T_x M, T_y N)$ is a linear map. Then the following is true :
  $
    op("Tr")_g (T_A)= op("Tr") (A^* A)
  $
  As considering @definition_of_potential_energy_density_Riemannian_tensor_version, therefore we can argue :
  $
    f(x,y,A)= op("Tr") (A^* A)
  $
]

#proof()[
  
]