#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.3": *

== Uniqueness and finite propagation speed

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
    frac(1,2)integral_Omega [(partial_t u)^2+ mark(chevron.l d_x u comma d_x u chevron.r, tag: #(m.tag)("fourth"), color: #eastern)] d V d t 
    \ &- integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t

    #annot(((m.tag)("product rule of Riemannian divergence 1"), (m.tag)("product rule of Riemannian divergence 2")), pos: right, dx: 1em, dy: 1.5em)[by @the_product_rule_of_Riemmanian_divergence \ and @definition_of_Laplacian]
    #annot((m.tag)("mimic"), pos: left+bottom, dx: -6em, dy: -1em)[
      $partial_t partial_t^2 u= partial_t (frac(1,2) (partial_t u)^2)$
    ]
    #annot((m.tag)("fourth"), dx: 5em, dy: 0.5em)[$d_x partial_t u comma d_x u chevron.r = frac(1,2) [partial_t (d_x u)^2]$]
    
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

  The reason why we expend #(m.ref)("main equation") even go so far as to use $partial_t partial_t^2 u= partial_t (frac(1,2) (partial_t u)^2)$ and $chevron.l d_x partial_t u comma d_x u chevron.r = frac(1,2) [partial_t (d_x u)^2]$ is to isolate $integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t$ for more concrete computation.#footnote[$integral_Omega op("div")_x (partial_t u thick op("grad")_x u) thin d V  d t$ is quite hard to compute directly itself.]
])

