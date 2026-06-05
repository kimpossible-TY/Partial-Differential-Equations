#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.3": *

== Uniqueness and finite propagation speed <finite_propagation_speed>

#paragraph_tab
We study some properties of solutions to the wave equation on $bb(R) times M$ :
$
  frac(partial^2 u, partial t^2) - Delta u=0
$
with initial conditions :
$
  u(0 comma x)=f(x), quad partial_t u(0 comma x)=g(x)
$
and boundary condition either the Dirichlet(@Dirichlet_condition) or the Neumann condition(@neumann_condition).

#paragraph_tab
We start from the energy conservation law for the wave equation(@energy_conservation). It is good to apply the fundamental theorem of calculus to the energy conservation derivation(@energy_conservation_derivation) :

#local-scope-annotations(s => [
  #flowbox()[
  $
    frac(partial E, partial t)=integral_M [frac(partial u, partial t) (frac(partial^2 u, partial t^2) - Delta u)] d V + integral_(partial M) partial_t u frac(partial u , partial nu) d S
  $ 

  $arrow.b$

  Use the fundamental theorem of calculus :

      $
      E(t_2)-E(t_1) &= integral_(t_1)^(t_2) integral_M [frac(partial u, partial t) (frac(partial^2 u, partial t^2) - Delta u)] d V d t 
      \
      &+ mark(cancel(integral_(t_1)^(t_2) integral_(partial M) partial_t u frac(partial u , partial nu) d S d t, stroke: #(paint: red)), tag: #(s.tag)("boundary term"))
    $ #(s.tag)("above")
    #annot((s.tag)("boundary term"), pos: bottom, dx: 4em)[due to the boundary condition]
  ]
  Now, let's focus on $integral_M partial_t u(partial_t^2 u- Delta u) d V$ which is came from the first term of RHS of #(s.ref)("above"). Since, our interest thing is 'the inside of $M$', moreover, let's restrict the integral domain $M$ to $Omega$ which doesn't intersect $bb(R) times M$. Computing it term by term, we have :
])

#local-scope-annotations(m => [  
  $
    integral_Omega mark(partial_t u, tag: #(m.tag)("first")) thin (rmark(partial_t^2 u, tag: #(m.tag)("second"))- bmark(Delta u, tag: #(m.tag)("third"))) d V 
    &= 
    integral_Omega partial_t u thick partial _t^2 u thin d V 
    markul(-integral_Omega partial_t u thick Delta u thin d V, tag: #(m.tag)("target of product rule of Riemannian divergence"), color: #purple)
    \
    &=
    markrect(integral_Omega frac(partial, partial t)(frac(1,2) (partial_t u)^2) d V thin d t, color: #navy, tag: #(m.tag)("mimic")) +
    markhl(integral_Omega chevron.l d_x partial_t u comma d_x u chevron.r d V d t, tag: #(m.tag)("product rule of Riemannian divergence 1"))
    \ & 
    markhl(- integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t, tag: #(m.tag)("product rule of Riemannian divergence 2"))
    
    \
    
    &=
    frac(1,2)integral_Omega [partial_t (partial_t u)^2+ mark(partial_t chevron.l  d_x u comma d_x u chevron.r, tag: #(m.tag)("fourth"), color: #eastern)] d V d t 
    \ &- integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t

    #annot(((m.tag)("product rule of Riemannian divergence 1"), (m.tag)("product rule of Riemannian divergence 2")), pos: right, dx: 1em, dy: 1.5em)[by @the_product_rule_of_Riemmanian_divergence \ and @definition_of_Laplacian]
    #annot((m.tag)("mimic"), pos: left+bottom, dx: -6em, dy: -1em)[
      $partial_t partial_t^2 u= partial_t (frac(1,2) (partial_t u)^2)$
    ]
    #annot((m.tag)("fourth"), dx: 5em, dy: 0.5em)[$chevron.l d_x partial_t u comma d_x u chevron.r = frac(1,2) [partial_t (d_x u)^2]$]
    
    #(m.annot)(
      ("first", "second", "third", "target of product rule of Riemannian divergence"),
      cetz,
      {
        import cetz.draw : *
        set-style(mark: (end: "straight"))

        line((m.node)("target of product rule of Riemannian divergence", "south"),
         (10,-1),
         stroke: purple)

        bezier-through(
          (m.node)("first", "north"),
          (rel: (x: 0.8, y: 0.1)),
          (m.node)("second", "north"),
          stroke : red
        )
        bezier-through(
          (m.node)("first", "north"),
          (rel: (x: 0.8, y: 0.4)),
          (m.node)("third", "north"),
          stroke : blue
        )
      }
    )
  $ #(m.tag)("main equation")

  The reason why we expend #(m.ref)("main equation") even go so far as to use $partial_t partial_t^2 u= partial_t (frac(1,2) (partial_t u)^2)$ and $chevron.l d_x partial_t u comma d_x u chevron.r = frac(1,2) [partial_t (d_x u)^2]$ is to isolate $integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t$ for more concrete computation.#footnote[$integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t$ is quite hard to compute directly itself.] Applying the fundamental theorem of calculus to the first integrals of RHS of #(m.ref)("main equation") and applying the divergence theorem to the last term, we have :
  $
    integral_Omega partial_t u thin (partial_t^2 u - Delta u) d V & =
    overbrace(frac(1,2)integral_(partial Omega) [ (partial_t u)^2+ chevron.l d_x u comma d_x u chevron.r] omega, #text(blue)[by the fundamental theorem of calculus])
    \
    & - 
    underbrace(integral integral_(partial Omega_t) partial_t u thin frac(partial u, partial nu_x) thin d S_t thick d t, #text(purple)[divergence theorem])
  $ #(m.tag)("applied fundamental theorem of calculus and divergence theorem")

  where $Omega_t$ is the intersecion of $Omega$ with ${t} times M subset bb(R)times M$ and $d S_t$ is the measure on $partial Omega_t$. Here $omega$ is the volume form on $M$, thought of as an $n$-form on $bb(R) times M$ pulled back to $partial Omega$.#footnote[Since we used the fundamental theorem of Calculus, the time integral is disappeared. Thus the measure of $partial Omega$ which is $d S$ can't used directly. We need a new measure on $op("proj")_x (partial M)$ which is $omega$.] 
  
  #paragraph-tab
  How can we define $omega$ and $d S_t d t$ in more detail? The point is that both measures are obtained by projecting the same hypersurface measure $d S$ on $partial Omega$. If $N=(N_t,N_x)$ is the outward unit normal to $partial Omega subset RR times M$, then the Jacobian of the projection onto the spatial slice $M$ is the time component of the normal, while the Jacobian of the projection onto the time-cylinder measure is the spatial length of the normal. Thus, up to the chosen orientation of $N$, the projected measures are :
  $
    omega &= N_t d S
    \
    d S_t d t &= norm(N_x) d S
  $ #(m.tag)("definition of projected measures")
  #figure(
    normal-measure-projection-visualization(),
    caption: [The components of the normal vector give the projection factors from $d S$ to $omega$ and $d S_t d t$.]
  )
  Applying #(m.ref)("definition of projected measures") to #(m.ref)("applied fundamental theorem of calculus and divergence theorem"), we have :
  #flowbox()[
    $
    cancel(integral_Omega partial_t u thin (partial_t^2 u - Delta u) d V, stroke: #(paint: red)) &=
    frac(1,2) integral_(partial Omega) {
      [
        (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
      ] N_t
      \
      &-
      markhl(2, tag: #(m.tag)("inserted for combined to integrals")) partial_t u thin frac(partial u, partial nu_x) thin norm(N_x)
    } thick d S
    \
    #annot((m.tag)("inserted for combined to integrals"), pos: bottom, dx: -1em, dy: 1em)[It is just for combining two integrals into one integral.]
    $ #(m.tag)("combined integral ")

    $arrow.b$

    $
      frac(1,2) integral_(partial Omega) {
      [
        (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
      ] N_t
      -
      2 partial_t u thin frac(partial u, partial nu_x) thin norm(N_x)
    } thick d S=0
    $ #(m.tag)("need physics approach")
  ]
  Since we already assumed that $u$ satisfies the wave equation, The LHS of #(m.ref)("combined integral ") is zero.
  

  #paragraph-tab
  To analyze #(m.ref)("need physics approach"), it is time to use the physics approach. The time manifold which is $bb(R)$ has origin(zero). Consider $0 in bb(R)$ means present, $(-infinity comma 0) in bb(R)$ means past and $(0 comma infinity) in bb(R)$ means future. Then we can split $partial Omega$ into two parts : the part in the past of present and the part in the future of present. Let's denote them by $Sigma_0$ and $Sigma_1$ respectively. Then, we can rewrite #(m.ref)("need physics approach") as :
  $
    frac(1,2) integral_(Sigma_0) {
      [
        (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
      ] (N_t)_(Sigma_0)
      -
      2 partial_t u thin frac(partial u, partial nu_x) thin norm(N_x)
    } thick d S
    \
    +
    frac(1,2) integral_(Sigma_1) {
      [
        (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
      ] (N_t)_(Sigma_1)
      -
      2 partial_t u thin frac(partial u, partial nu_x) thin norm(N_x)
    } thick d S
    \
    &=0
  $ #(m.tag)("split into past and future")
  The reasion why $N_t$ splits into $(N_t)_(Sigma_0)$ and $(N_t)_(Sigma_1)$ is that the direction of normal vector $N_t$ is different on $Sigma_0$ and $Sigma_1$!
  #figure(
    spacelike-boundary-decomposition-visualization(),
    caption: [A spacelike bounded region with $partial Omega = Sigma_0 union Sigma_1$ and spatial slices $Omega_t$.]
  ) <spacelike_boundary_decomposition_visualization>
  Therefore, we get :
  $
    (N_t)_(Sigma_0)=-(N_t)_(Sigma_1)
  $ #(m.tag)("normal time vector component relation")

  Applying #(m.ref)("normal time vector component relation") to #(m.ref)("split into past and future"), we have :
  $
    overbracket(integral_(Sigma_1) {
      [
        (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
      ] (N_t)_(Sigma_1)
      -
      2 partial_t u thin frac(partial u , partial nu_x) thin norm(N_x)
    } thick d S, "energy flux on future boundary")
    \
    =
    underbracket(integral_(Sigma_0) {
      [
        (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
      ] (N_t)_(Sigma_1)
      +
      2 partial_t u thin frac(partial u , partial nu_x) thin norm(N_x)
    } thick d S, "energy flux on past boundary")
  $ <energy_flux_relation>

  #paragraph-tab
  Again, the physical interpretation is needed to #(m.ref)("normal time vector component relation"). As considering @energy_conservation_derivation#footnote[Remember that #(m.ref)("normal time vector component relation") is induced from @energy_conservation_derivation at the first of the current section(@finite_propagation_speed).], The LHS of #(m.ref)("normal time vector component relation") is the energy flux#footnote[Flux means “the amount of something passing through a surface.”] across $Sigma_1$ and the RHS of #(m.ref)("normal time vector component relation") is the energy flux across $Sigma_0$ which is past boundary. Since the energy of wave must be positive(@total_energy_of_wave), the energy flux must be positive too. To the energy flux must be positive, what does the condition is needed?
]
)
#flowbox()[
  #local-scope-annotations(s =>[
    $
      bar.v frac(partial u, partial nu_x) bar.v &= bar.v chevron.l op("grad")_x u comma nu_x chevron.r_g bar.v #dots_space #footnote[by definition of normal derivative(@definition_of_normal_derivative)]
      \
      &<= norm(op("grad")_x u) thin markul(norm(nu_x), color: #red, tag: #(s.tag)("norm of spatial normal vector")) #dots_space #footnote[by Cauchy-Schwarz inequality]
    
      #annot((s.tag)("norm of spatial normal vector"), pos: bottom+right, dx: 1em, dy: 1em)[$<=1$]
    $ #(s.tag)("normal derivative bound")

    $arrow.b$

    $
      2 norm(partial_t u thin frac(partial u , partial nu_x)) & <= norm(partial_t u)^2 + norm(frac(partial u , partial nu_x))^2 #dots_space #footnote[by the geometric inequality]
      \
      & <= norm(partial_t u)^2 + norm(op("grad")_x u dot norm(nu_x))^2 #dots_space #footnote[by #(s.ref)("normal derivative bound")] 
      \
      & <= norm(partial_t u)^2 + norm(op("grad")_x u)^2 #dots_space #footnote[Since $norm(nu_x)$ is spatial component of the normal vector, it is less than or equal to 1.]
      \
      &= norm(partial_t u)^2 + norm(d_x u)^2 #dots_space #footnote[by tangent-cotangent isomorphism]
    $ #(s.tag)("inequality for normal derivative term")
    
    $arrow.b$

    Apply #(s.ref)("inequality for normal derivative term") to @energy_flux_relation :
    #text(size: 0.8em)[
      $
        integral_(Sigma_1) {
        [
          (partial_t u)^2 + norm(d_x u)^2
        ] (N_t)_(Sigma_1)
        -
        2 partial_t u thin frac(partial u , partial nu_x) thin norm(N_x)
      } thick d S 
      
      & >= integral_(Sigma_1) {
        [
          (partial_t u)^2 + chevron.l d_x u comma d_x u chevron.r
        ] (N_t)_(Sigma_1)
        \
        -
        2 norm(partial_t u thin frac(partial u , partial nu_x)) thin norm(N_x)
      } thick d S #dots_space #footnote[$-a > -|a|$]
      \
      &>= integral_(Sigma_1) [
        (partial_t u)^2 + norm(d_x u)^2
      ] dot [(N_t)_(Sigma_1)- norm(N_x)] thin d S #dots_space #footnote[by applting #(s.ref)("inequality for normal derivative term")]
    $
    ]
  ])
]
Since $(partial_t u)^2 + norm(d_x u)^2$ must be positive, the energy flux on $Sigma_1$ is positive if $(N_t)_(Sigma_1)- norm(N_x)$ is positive. Aslo $(N_t)_(Sigma_1)=norm((N_t)_(Sigma_1))$ by considering @spacelike_boundary_decomposition_visualization. Thus if $(N_t)_(Sigma_1)- norm(N_x)$ is positive, then the following inequality is satisfied :
$
  norm(N_x) < norm((N_t)_(Sigma_1))
$ <normal_vector_inequality>

#paragraph-tab
Let assume that the inequality(@normal_vector_inequality) is satisfied.#footnote[This assumption is suitable for physics.] Moreover if we expend the idea that describing $partial Omega$ to the two parts $Sigma_0$ and $Sigma_1$ to the entire $Omega$:
$
  Omega= union.big_(0<=s<=1) Sigma_s
$
Then we can get the following result which is called finite propagation speed of wave.
#theorem(title: "finite propagation speed of wave")[
  Suppose $Omega in bb(R) times M$ is a domain of influence for its low boundary $Sigma_0$. If $u$ solves the wave equation $(partial_t^2 u - Delta u = 0)$ on $bb(R) times M$, and if $u$ and $d u$ vanish on $Sigma_0$, then $u$ vanishes throughout $Omega$.
]
#proof[
  The energy flux identity(@energy_flux_relation) implies that $d u$ also vanishes on $Sigma_1$.
]

#note(title: [@normal_vector_inequality is well-defined by the Lorentz metric])[
  The inequality @normal_vector_inequality is not merely an artificial analytic assumption. It is exactly the condition that the normal vector $N=(N_t,N_x)$ is timelike with respect to the Lorentz metric on $bb(R) times M$.

  Recall that the product spacetime $bb(R) times M$ carries the Lorentz metric
  $
    h=-d t^2+g
  $ <definition_of_Lorentz_metric>
  where $g$ is the Riemannian metric on $M$. Therefore, for a vector $N=(N_t,N_x)$, its Lorentz square length is
  $
    h(N,N)= - norm(N_t)^2 + norm(N_x)^2_g.
  $
  Thus $N$ is timelike precisely when
  $
    h(N,N)<0.
  $
  Expanding this condition gives
  $
    - norm(N_t)^2 + norm(N_x)^2_g <0
  $
  which is equivalent to
  $
    norm(N_x)_g < norm(N_t).
  $

  Hence the condition @normal_vector_inequality means that the normal direction to the boundary surface is timelike. Equivalently, the boundary surface itself is spacelike. This is why the boundary energy flux becomes positive-definite: the surface is crossed by time evolution rather than by spatial propagation.
]