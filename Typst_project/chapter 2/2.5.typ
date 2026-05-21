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
  d_x u (t,x) in cal(L)(T_x M, T_y N) quad "where" y=u(t,x)
$
Let $A in cal(L)(T_x M, T_y N)$ is a linear map. Then the defining $f$ likely to the following is natural :
$
  f(x,y,A) := op("Tr")(A^* A) 
$ <potential_energy_density>
where $A^* : T_y N arrow.r T_x M, A^* in cal(L)(T_y N, T_x M)$ is the adjoint of $A$ satisfying with :
$
  g_x (A^* W, X)= h_y (W, A X) quad attach(X, tl: forall) in T_x M, attach(W, tl: forall) in T_y N
$ <definition_of_adjoint_of_A>
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

#lemma()[
  Let $M $ and $N$ are Riemannian manifolds which are compact and $A in cal(L)(T_x M, T_y N)$ is a linear map. Then the following is true :
  $
    op("Tr")_g (T_A)= op("Tr") (A^* A)
  $
  As considering @definition_of_potential_energy_density_Riemannian_tensor_version, therefore we can argue :
  $
    f(x,y,A)= op("Tr") (A^* A)
  $
]

#local-tag-scope(s => [
    #proof()[
    By the definition of $A^*$(@definition_of_adjoint_of_A), we know : 
    $
      g_x (A^* W, X)= h_y (W, A X)
    $
    by defining $Z:= A Y$, 
    $
      g(A^* A Y comma X) &= h(A Y, A X)
      \
      & = underbracket( h(A X comma A Y), rmark(T_A (X comma Y))) #dots_space #footnote[It is undeerstandable becuase $h$ is defined as the metric. Thus the symmetry property is undeerstandable.]
    $

    Now, let $B:=A^* A$. Then $B : V arrow.r V$ and :
    #flowbox[
      $
      g(B Y comma X)=T_A (X comma Y), attach(X, tl: forall) , attach(Y, tl: forall) in V
      $
      
      $arrow.b$

      $
        therefore B= g^(-1)T_A , quad B^k_j =g^(k j)(T_A)_(i j)
      $ #(s.tag)("result")
    ]
    As taking the trace to #(s.ref)("result") and considering the Riemannian trace of $(0,2)$-tensor, we get :
    $
      op("Tr")(B)&=B^i_i=g^(i j)(T_A)_(i j)
      \
      &= op("Tr")_g (T_A)
    $
  ]
])

#paragraph_tab
Until now, we treated the general geometric model of energy density. Now take $N = bb(R)$, and suppose $f(x,y,A)$ is independent of $y in bb(R)$. In other words, we consider a potential energy of the form :
$
  V(t)= integral_M f(x,d_x u (t,x)) d V
$

#lemma()[
  let $M$ and $N:= bb(R)$ Riemannian manifold. For $attach(x, tl: forall) in M , attach(y, tl:forall) in N$, the following equation is true :
  $
    cal(L)(T_x M , T_y bb(R)) approx.eq T^*_x M
  $
] <first_lemma_for_one_D_string_vibration>

#proof()[
  By the basic property of tangent space, we have $T_y bb(R)=bb(R)$. therefore :
  $
    cal(L)(T_x M , T_y bb(R)) = cal(L)(T_x M, bb(R))
  $

  Since $cal(L)(T_x M, bb(R))$ means the space of $T_x M mapsto bb(R)$, it is the same as the definition of covector space which is $T_x^* M$.
] 

#note[  By @first_lemma_for_one_D_string_vibration, $d_x u in T^*_x M$ where $N= bb(R)$. Thus $A$ can be represented as the single covector $xi$ and the potential density $f(x, xi)$ is defined on $T^* M$.
  $
    f in T^* M quad "where " N = bb(R)
  $
]

#paragraph_tab
Our goal is to determine the wave function $u$. Since we already constructed the kinetic energy and potential energy, let's use the Euler-Lagrange equation to determine $u$. First of all, the action is :
$
  S[u] & =integral_(t_0)^(t_1) L thick d t
  \
  L &= frac(1,2) integral_M m(x) norm(d_t u)^2 d V - integral_M f(x,xi) thick d V
  \
  &= integral_M  underbrace([frac(1,2)m(x) norm(d_t u)^2- f(x,xi)]sqrt(op("det") g), cal(L)) thick d x #dots_space #footnote[Using the local coordinate $d V= sqrt(op("det") g)$]
$
Let $cal(L):= sqrt(op("det") g)[frac(1,2)m(x) norm(d_t u)^2- f(x,xi)]$ which is Lagrangian density. Since $T$ and $V$ are smooth, $L$ is smooth too. Therefore we can change the order of derivative and integral :
#flowbox()[
  Euler-Lagrange equation
  #mannot-scope(s=>[
    $
      frac(partial L, partial u)- frac(partial, partial t) frac(partial L, partial markhl(d_t u, tag: #(s.tag)("first")))-frac(partial, partial x_j) frac(partial L, partial markhl(d_(x_j) u, color: #green, tag: #(s.tag)("second")))&=0 #dots_space #footnote[Since $u$ is real-valued funcion, $d_t u=partial_t u$ and $d_(x_j) u=partial_j u$ are satisfied.]
    $ <Euler-Lagrange_equation_for_wave_equation>

    #annot((s.tag)("first"))[
      $partial_t u$
    ]
    #annot((s.tag)("second"))[
      $partial_j u$
    ]
  ])

  $arrow.b$

  use $L:= integral_M cal(L) thick d x$ and switch the derivative and the integral
  $
    underbracket(frac(partial cal(L), partial u), (1)) 
    - 
    underbracket(frac(partial, partial t) frac(partial cal(L), partial (partial_t u)), (2))
    -
    underbracket(frac(partial, partial x_j) frac(partial cal(L), partial (partial_j u)), (3))
    =0
  $ <Euler-Lagrange_equation_of_Lagrangian_density_wave_eq>
]

#paragraph_tab
#local-tag-scope(l => [
  Now compute (1) $tilde$ (3) of @Euler-Lagrange_equation_of_Lagrangian_density_wave_eq. First, Since $f$ does not depend on $u$ itself, only on $x$ and $u_j$, therefore $frac(partial cal(L), partial u)=0$. second, 
  $
    frac(partial cal(L) , partial partial_t u)= sqrt(det g) thick m(x) thick partial_t u
  $ #(l.tag)("first_result")
  is easily proved. Since $g$ and $m$ depend only on $x$, not on $t$,

  #mannot-scope(s =>[
    $
      frac(partial , partial t) frac(partial cal(L), partial (partial_t u))= sqrt(det g) thick m(x) thick markrect(partial_t (partial_t u), color: #red, tag: #(s.tag)("partial^2_t_u"))
    $ #(l.tag)("second_result")
    #annot((s.tag)("partial^2_t_u"), pos: right)[second time derivative]
  ])
  Now let's compute (3). Since $cal(L)=sqrt(op("det") g)[frac(1,2) m (partial_t u)^2-f(x, xi)]$ where $xi=d_x u$ and $d_x u =partial_x u$, we get :
  #flowbox()[$
    frac(partial cal(L), partial u_j)=-sqrt(op("det") g) thick frac(partial f, partial xi_j)(x, xi)
  $

  $arrow.b$

  $
    partial_j frac(partial cal(L), partial u_j) =
    partial_j (-sqrt(op("det") g) thick frac(partial f, partial xi_j)(x, xi))
  $ #(l.tag)("third_result")
  ]

  As putting #(l.ref)("first_result"), #(l.ref)("second_result") and #(l.ref)("third_result") to @Euler-Lagrange_equation_for_wave_equation, 
])
we finally get :
#mannot-scope(s =>[
  $
    m frac(partial^2 u , partial t^2 ) - markul(frac(1, sqrt(op("det") g))( frac(partial, partial x_j) sqrt(op("det") g) thick frac(partial f, partial xi_j) (x, xi)), color: #blue, tag: #(s.tag)("hl"))
    = 0
  $ <wave-like_equation>
  #annot((s.tag)("hl"), pos: bottom)[will be $Delta u$ if adding some assumptions]
])

#paragraph_tab
To induce the standard wave equation from @wave-like_equation, we choose the quandratic potential energy density :
$
  f_Q (x, xi):= sum^n_(j=1) sum^n_(k=1) gamma g^(j k) (x) xi_j xi_k quad "where" gamma >0
$

#lemma(title: "Laplace-Beltrami Operator")[
  Let $(M,g)$ is the Riemannian manifold and $u in C^infinity(M)$. Then the Laplacian of $u$ is in local coordinate :
  $
    Delta u = frac(1, sqrt(op("det") g)) thick partial_i (sqrt(op("det") g) thick g^(i j) thick partial_j u)
  $
] <Laplace-Beltrami_Operator>

#proof[
  @Laplace-Beltrami_Operator is the result of @formula_of_divergence. By considering @definition_of_Laplacian and $op("grad") u= g^(i j) partial_j u$ because of musical isomorphism, we get the result as substituting $X=op("grad") u$ to @formula_of_divergence.
]

#note(title: "what is different between just Laplace operator and Laplace-Beltrami operator?")[
  we use the standard Laplace operator when our coordinates are a straight, flat grid. we use the Laplace-Beltrami operator when our coordinates are warped by the shape of the space itself.
]

#theorem(title: "wave equation")[
  As considering @wave-like_equation, let's substitute $f$ to the quandratic potential energy density $f_Q$. @wave-like_equation gives :
  $
    frac(partial^2 u, partial t^2)- frac(2 gamma, m) Delta u =0
  $ <wave_equation>
]

#proof[
  It is suffcient to show that :
  $
    2 gamma Delta u = frac(1, sqrt(op("det") g))( frac(partial, partial x_j) sqrt(op("det") g) thick frac(partial f_Q, partial xi_j) (x, xi))
  $
  First, let's compute $frac(partial f_Q, partial xi_j)$. Differentiate with respect to $xi_j$ is :
  #mannot-scope(s=> [
    $
      frac(partial f_Q, partial xi_j)&=gamma g^(a b) mark(frac(partial, partial xi_j), tag: #(s.tag)("derivative")) (rmark(xi_a, tag: #(s.tag)("xi_a")) bmark(xi_b, tag: #(s.tag)("xi_b"))) #dots_space #footnote[where the summation convention is used.]
      \
      \
      &= gamma g^(a b)(delta^j_a xi_b + xi_a delta^j_b)
      \
      &= gamma g^(j b) xi_b + gamma g^(a j) xi_a
      \
      &= 2 sum^n_(k=1) gamma g^(j k) xi_k #dots_space #footnote[becuase $a$ and $b$ are dummy indices and $g^(a j)=g^(j a)$ by the symmetric property of metric. Note that $j$ isn't dummy index.]
    $

    #(s.annot)(
      ("derivative", "xi_a", "xi_b"),
      cetz,
      {
        import cetz.draw: *
        set-style(mark: (end: "straight"))

        bezier-through(
          (s.node)("derivative","south"),
          (rel : (x:0.3, y: -0.3)),
          (s.node)("xi_a", "south"),
          stroke: red
        )

        bezier-through(
          (s.node)("derivative","south"),
          (rel : (x:0.5, y: -0.5)),
          (s.node)("xi_b", "south"),
          stroke: blue
        )
      }
    )
  ])

  #paragraph_tab
  Note that $xi$ represents the spatial differential of $u$, we have $xi_k=partial_k u$. it induces :
  #local-tag-scope(s =>[
    $
      frac(partial f_Q, partial xi_j)= sum_(k=1)^n 2 gamma g^(j k) partial_k u
    $ #(s.tag)("input")
    Then if we apply $frac(1, sqrt(op("det") g)) thick frac(partial, partial x_j) sqrt(op("det") g)$ to #(s.ref)("input"), which means 
    $
      frac(1, sqrt(op("det") g)) thick frac(partial, partial x_j) [sqrt(op("det") g)  thick (2 gamma g^(j k) partial_k u)]
    $
  ])
  it is the same as what we want to show.
]

=== Energy conservation

#paragraph_tab
To prove the energy conservation, we need to assume:
#definition(title : "Dirichlet Condition")[
  Let $M$ be Riemannian manifold and $u in bb(C)^infinity (M)$. If $u$ satisfies the following condition:
  $
    u(t,x)=0, quad attach(x, tl: forall) in partial M
  $
  , then it is Dirichlet boundary condition for $u$.
]

#figure(
  dirichlet_boundary_condition_visualization(),
  caption: [Visual representation of the Dirichlet boundary condition. The function $u(t,x)$ is pinned at $0$ on the boundary $partial M$, acting like a vibrating string with fixed endpoints.]
) <vis_dirichlet>

#definition(title : "Neumann Condition")[
  Let $M$ be a Riemannian manifold with boundary and $u in bb(C)^infinity (M)$. If $u$ satisfies the following condition:
  $
    frac(partial u, partial n)(t,x) = 0, quad attach(x, tl: forall) in partial M
  $
  where $n$ is the outward unit normal vector field along $partial M$, then it is the Neumann boundary condition for $u$.
]

#paragraph_tab
Recall from @definition_of_normal_derivative that the normal derivative of $u$ at the boundary is given by:
$
  frac(partial u, partial n)(t,x) = nabla_n u(t,x) = d_x u(t,x)(n)
$
Thus, the Neumann condition states that the differential of the spatial configuration $u$ vanishes when evaluated on the outward unit normal vector $n$. Physically, in the 1D string case, this means the slope at the boundary is zero ($frac(partial u, partial x) = 0$), so the ends of the string can slide freely without vertical restriction.

#figure(
  neumann_boundary_condition_visualization(),
  caption: [Visual representation of the Neumann boundary condition. The normal derivative of $u(t,x)$ at the boundary is zero, which for a 1D string corresponds to zero spatial slope, allowing the endpoints to slide freely along guide rods.]
) <vis_neumann>

#paragraph_tab
Now, let's prove the energy conservation of wave equation. the total energy is :



#mannot-scope(m => [
  $
    E(t) := frac(1,2) integral_M [
      rmark(norm(d_t u (t,x))^2, tag: #(m.tag)("kinetic")) + bmark(chevron.l xi comma xi chevron.r_g , tag: #(m.tag)("potential"))
    ] d V #dots_space #footnote[where $m=1$ for the convenience.]
  $
  #annot((m.tag)("kinetic"), pos: bottom, dy: 1em)[kinetic energy density]
  #annot((m.tag)("potential"), pos: bottom, dy: 1em, dx: 2.5em)[potential energy density]
])

To find how the energy changes, we take the derivative of $E(t)$ with respect to time $t$.
$
  frac(d E, d t) &= frac(1,2) integral_M frac(partial, partial t) [(frac(partial u, partial t))^2 + chevron.l xi comma xi chevron.r_g ] d V
  \
  &=
  
$