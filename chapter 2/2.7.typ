#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.4.0": *

== Lorentz manifolds and stress-energy tensor

#paragraph-tab
The analysis of the wave equation in the last section made strong use of the fact that we were working with $frac(partial^2, partial t^2)- Delta$ on a product $bb(R) times M$. We will take a deeper look at the notion of energy, which will produce concepts that are important in the study of the wave equation on more general Lorentz manifolds.


#paragraph-tab
A Lorentz manifold is a pseudo-Riemannian manifold whose metric has one time direction and the remaining directions spatial. #highlighted()[This metric packages the wave operator $frac(partial^2, partial t^2)- Delta$ into one geometric notation.]

#figure(
  wave-operator-packaging-diagram(),
  caption: [The Lorentz metric $h$ packages the wave operator components (time derivative and spatial Laplacian) into a single coordinate-free geometric notation $square_h$.]
)<wave_operator_packaging_fig>

#definition(title: "Lorentz metric")[
A Lorentz metric on an $(n+1)$-dimensional smooth manifold $cal(M)$ is a smooth, symmetric, non-degenerate $(0,2)$-tensor $h$ with signature $(-,+,...,+)$. A vector $X in T_p cal(M)$ is called timelike, null, or spacelike according as
$
  h_p (X,X) < 0, quad h_p (X,X) = 0, quad "or" quad h_p (X,X) > 0.
$
On the product spacetime $bb(R) times M$, the standard example is $h=-d t^2+g$, where $g$ is the Riemannian metric on $M$. In coordinates, $h_(j k)$ has the form :
$
  (h_(j k))=mat(-1,0 ; 0 , (g_(alpha beta)))
$
]<definition_of_Lorentz_metric>

=== Definition of Stress-Energy Tensor
#paragraph-tab
To analyze the wave equation on a Lorentz manifold especially from the perspective of action, we need to abstract the action, as the Lorentz metric is itself the result of abstraction.#footnote[The abstraction used when defining the Lorentz metric is well-described at @wave_operator_packaging_fig.] Now, let's consider @wave-action which is a natural action of a wave, considering $Omega = bb(R)times M$ :
$
  S[u,h]&=-frac(1,2) integral_Omega chevron.l d u comma d u chevron.r_h d V_h
  \
  &= integral_Omega (frac(1,2)(partial_t u)^2 - frac(1,2)norm(d_x u)_g^2) d V_g d t #dots_space #footnote[Choosing $chevron.l d u comma d u chevron.r_h$ as Lagrangian is considered the Lagrangian for wave. $frac(1,2) (partial_t u)^2$ is just kinetic energy, and another term of Lagrangian is came from @quandratic_potential_energy_density.]
$ <wave-action>

Remember that the first variation of action induces the Euler-Lagrange equation, which is analogous to Newton's second law ($F = m a$). Thus, we compute the first variation of the action ($delta S$) by varying with respect to $h$.
#local-scope-annotations(s => [
  #flowbox()[
    $
      S[u,h]=-frac(1,2) integral_Omega h^(a b) partial_a u partial_b u d V_h
    $

    $arrow.b$

    $
      delta_h S &= -frac(1,2) integral_Omega pmark(delta_h, tag: #(s.tag)("delta")) ( rmark(h^(a b), tag: #(s.tag)("h")) partial_a u partial_b u thick bmark(d V_h, tag: #(s.tag)("V")) )
      \
      &= -frac(1,2) integral_Omega ( (delta_h h^(a b)) partial_a u partial_b u thick d V_h + h^(a b) partial_a u partial_b u thick markhl(delta_h (d V_h)) )
      #dots_space #footnote[$delta_h partial_a u $ and $delta_h partial_b u$ are 0.]

      #(s.annot)(
        ("delta", "h", "V"),
        cetz,
        {
          import cetz.draw: *
          set-style(mark: (end: "straight"))
          
          bezier-through(
            (s.node)("delta", "south"),
            (rel: (x: 0.2, y: -0.25)),
            (s.node)("h", "south"),
            stroke: red,
          )
          
          bezier-through(
            (s.node)("delta", "north"),
            (rel: (x: 0.8, y: 0.35)),
            (s.node)("V", "north"),
            stroke: blue,
          )
        },
      )
    $ #(s.tag)("expanded wave action")
  ]

  #paragraph-tab
  Then how can we compute $delta_h (d V_h)$ of #(s.ref)("expanded wave action")? First of all, We have to expand $d V_h$ to the coordinate form.
  $
    d V_h = sqrt(op("det") h ) thick d x^1 and dots.c and d x^n
  $
  where $n:= op("dim") (bb(R)times M)$. Thus, compute $delta_h d V_h$ means to compute $delta_h (sqrt(op("det")h))$.

  #paragraph-tab
  Since $delta$ is actually the directional derivative, and $sqrt(op("det") h)$ is also the composition of $sqrt(dot) compose op("det")(dot) compose h$, we can consider the product rule of differentiating. First of all, Let $A:= op("det") h$, Then how can we compute $delta_h sqrt(A)$? Since $A$ is a tensor, we can't apply the one-dimentional Calculus directly.#footnote[we can't apply $(sqrt(A))'= -frac(1,2 sqrt(A))$ without doubt.] This carful approach leads us to start from 'how can we define the square root of tensor(or matrix)'.
  $
    sqrt(A):=e^(frac(1,2) op("log") A) #dots_space #footnote[The exponential of matrix is defined by Taylor's expansion. We treat it using 'formal power series' in @Complex. The logarithm of matrix is also similar.]
  $ #(s.tag)("root of matrix")
  The we can apply :
  $
    delta(sqrt(A))&=delta(e^(frac(1,2) op("log") A))
    \
    &= frac(1,2) e^(frac(1,2) op("log") A) dot.c delta(log A) #dots_space #footnote[by chain role.]
    \
    &= frac(1,2) e^(frac(1,2) op("log") A) dot.c frac(delta (A), A) #dots_space #footnote[By the chain role of logarithm.]
    \
    &= frac(1,2) sqrt(A) dot.c frac(delta (A), A) #dots_space #footnote[by using #(s.ref)("root of matrix")]
  $ #(s.tag)("first result")

  #paragraph-tab
  Second, let's focus on computing $delta A$.
  For some $epsilon >0$ and by the definition of variation($delta_h$) gives for some invertible $h$:
  $
    delta_h op("det") h &= lr(frac(d, d epsilon) |)_(epsilon=0) op("det")(h+epsilon K) quad "where " K:= delta_h h #dots_space #footnote[by definition of variation.]
    \
    &= op("det") h thin tr(h^(-1) delta h) #dots_space #footnote[by @Jacobis_formula.]
  $ #(s.tag)("second result")
  
  #paragraph-tab
  As combining #(s.ref)("first result") and #(s.ref)("second result"), we have :
  #flowbox()[
    $
      delta_h sqrt((op("det") h)) &= frac(1,2) sqrt((op("det") h)) dot.c frac(cancel((op("det") h), stroke: #(paint: red)) thin tr(h^(-1) delta_h h), cancel((op("det") h), stroke: #(paint: red)))
      \
      &= frac(1,2) sqrt((op("det") h)) dot.c  tr(h^(-1) delta_h h)
      \
      &= frac(1,2) bmark(sqrt((op("det") h)), tag: #(s.tag)("scalar of dV_h")) dot.c (h^(i j) (delta h)_(i j)) #dots_space #footnote[by computing the trace directly.]

      #annot((s.tag)("scalar of dV_h"))[=$norm(d V_h)$]
    $

    $arrow.b$

    $
      delta_h (d V_h)= frac(1,2) (h^(i j) (delta h)_(i j)) d V_h
    $ #(s.tag)("first result of variation of volume form")
  ]
  
  #paragraph-tab
  Applying #(s.ref)("first result of variation of volume form") to #(s.ref)("expanded wave action"), we have :
  $
   delta_h S &:= -frac(1,2) integral_Omega ( (delta_h h^(a b)) partial_a u partial_b u thick d V_h 
   + 
   h^(a b) partial_a u partial_b u thick bmark(delta_h (d V_h)) ) 
   \
   &= -frac(1,2) integral_Omega  (rmark(delta_h h^(a b), tag:#(s.tag)("want to combine 1")) partial_a u partial_b u thick d V_h +
   h^(a b) partial_a u partial_b u thick bmark(frac(1,2) (h^(i j) rmark(delta h_(i j), tag: #(s.tag)("want to combine 2"))) d V_h))

   #annot(((s.tag)("want to combine 1"), (s.tag)("want to combine 2")), pos : bottom+ right, dx: 1.5em, dy: 0.8em, leader-connect: "elbow")[want to combine both term with $(delta h)^(alpha beta)$]
  $ #(s.tag)("want to combine")

  If we combine the two terms. we do some mathematical trick! Let's take the variation to the product.
  $
    delta(h^(a c) h_(c b)) &= delta(delta^a_b)
    \
    &= 0
  $ #(s.tag)("taking variation to the product")
  
  
  Thus we have the following by applying the distributing rule of variation(derivative) :
  #flowbox()[
    $
      pmark(delta, tag: #(s.tag)("delta-prod")) ( rmark(h^(a c), tag: #(s.tag)("h-prod-1")) bmark(h_(c b), tag: #(s.tag)("h-prod-2")) ) &=(delta h^(a c)) h_(c b)+ h^(a c) delta h_(c b)
      \
      &=0

      #(s.annot)(
        ("delta-prod", "h-prod-1", "h-prod-2"),
        cetz,
        {
          import cetz.draw: *
          set-style(mark: (end: "straight"))
          
          bezier-through(
            (s.node)("delta-prod", "south"),
            (rel: (x: 0.15, y: -0.2)),
            (s.node)("h-prod-1", "south"),
            stroke: red,
          )
          
          bezier-through(
            (s.node)("delta-prod", "north"),
            (rel: (x: 0.5, y: 0.25)),
            (s.node)("h-prod-2", "north"),
            stroke: blue,
          )
        },
      )
    $

    $arrow.b$

    $
      therefore delta h_(a b)= - h_(a c)((delta h)^(c d) h_(b d)) #dots_space #footnote[be carful to the change of dummy indeices.]
    $ #(s.tag)("result of the trick")
  ]
  Now, substitute #(s.ref)("result of the trick") into #(s.ref)("first result of variation of volume form"). Then :
  #flowbox()[
    $
      h^(a b) delta(h)_(a b)& = rmark(h^(a b), tag: #(s.tag)("second cancelation 1"))(-rmark(h_(a c), tag: #(s.tag)("second cancelation 2"))h_(b d) delta (h^( c d)))
      \
      &=
      -h_(c d) (delta h)^(c d)

      #annot(((s.tag)("second cancelation 1"), (s.tag)("second cancelation 2")), pos: top, dx: 1em, dy: -0.5em, leader-connect: "elbow")[$=delta^b_c$]
    $

    $arrow.b$

    $
      therefore delta(d V_h)= -frac(1,2)h_(i j) (delta h)^(i j) d V_h
    $
  ]

  By applying #(s.ref)("result of the trick"), we have :
  $
    delta_h S & = -frac(1,2) integral_Omega  [(delta_h h^(a b)) partial_a u partial_b u thick d V_h \
    & -
    frac(1,2)h^(a b)partial_a u partial_b u thin bmark(h_(i j) (delta h)^(i j) d V_h)]
  $ 

  To achieve the goal,#footnote[combining two terms inside of integral of #(s.ref)("want to combine")] it is obvious to apply $i, j arrow.l.r.double.long a, b$ to $(delta h)^(i j)$. For doing that, we have to change $h^(a b)partial_a u partial_b u arrow h^(alpha beta)partial_alpha u partial_beta u$ firstly. Thus 

  $
    delta_h S & = -frac(1,2) integral_Omega  [rmark((delta_h h)^(a b)) partial_a u partial_b u thick d V_h \
    & -
    frac(1,2) h^(i j)partial_i u partial_j u thin h_(a b) rmark((delta h)^(a b)) d V_h]
    \
    &= -frac(1,2) integral_Omega  [underbrace(
      partial_a u partial_b u -frac(1,2) h^(i j)partial_i u partial_j u thin h_(a b), T_(a b))] (delta h)^(a b) d V_h #dots_space #footnote[by extracting $(delta h)^(a b)  d V_h$]
  $ #(s.tag)("discorvering the coefficient of stress-energy tensor")

  #definition(title: "stress-energy tensor")[
    We define the stress-energy tensor $T$ :
    $
      T:= d u times.o d u - frac(1,2) chevron.l d u comma d u chevron.r_h h
    $
    where $T_(a b):=
      partial_a u partial_b u -frac(1,2) h^(i j)partial_i u partial_j u thin h_(a b)$ from #(s.ref)("discorvering the coefficient of stress-energy tensor").
  ] <definition_of_stress-energy_tensor>

  #paragraph-tab
  The name "stress-energy tensor" comes from two facts at once. First, $T_(a b)$ is the coefficient paired with the metric variation $(delta h)^(a b)$ in $delta_h S$; thus it measures how the action changes when the geometry is strained. Second, after choosing a time direction, the time components $T_(0 0)$ and $T_(0 i)$ describe energy density and energy flux, while the spatial components $T_(i j)$ describe stress, or the flux of momentum through spatial directions.

  #figure(
    stress-energy-tensor-name-diagram(),
    caption: [The tensor $T$ is called the stress-energy tensor because the same coefficient of the metric variation contains both spatial stress components and time-energy components.]
  )<stress_energy_tensor_name_fig>
])

=== Definition of Lorentzian Laplacian

#paragraph-tab
As likely to @wave_operator_packaging_fig, now we abstract the Laplacian(@definition_of_Laplacian) on Lorentz manifold. Recall that the Laplacian is defined by metric at @Laplace-Beltrami_Operator(Laplace-Beltrami operator). Since we now use the metric $h$ instead of $g$, It is obvious to be satisfied :
$
    square u = frac(1, sqrt(op("det") h)) thick partial_i (sqrt(op("det") h) thick h^(i j) thick partial_j u) #dots_space #footnote[On the Lorentz manifold, the volume form is $d V_h:= sqrt(op("det") h) thick d x_1 and dots.c and dx_n$. Remenber $g$ in @Laplace-Beltrami_Operator is came from the Riemannian volume form formula, which is $d V_g= sqrt(op("det") g) thick d x_1 and dots.c and dx_n$.]
$ <Laplace-Beltrami_operator_of_metric_h>
where $square$ means the Laplacian on Lorentz manifold. Therefore we get the the Lorentzian version of the Laplace-Beltrami operator. 

#paragraph-tab
However there is an remain thing, how can we re-write  @lemma_relationship_of_laplacian_and_hessian for the Lorentz manifold? Think about $h^(j k) nabla_j nabla_k u$ just like @lemma_relationship_of_laplacian_and_hessian. Since $(h_(j k))=mat(-1,0 ; 0 , (g_(alpha beta)))$ by its definition, we get :
#local-scope-annotations(s=>[
  $
    h^(j k) nabla_j nabla_k u=h^(00) u_(; 00)+ h^(alpha beta)u_(;alpha beta)
  $ #(s.tag)("1")
  The 0-index is related to time. Since $h^(00)=-1$, we get :
  $
    h^(00)u_(;00)=-nabla_0 nabla_0 u= partial_t^2 u
  $ #(s.tag)("2")
  In addition, since $h^(alpha beta)=g^(alpha beta)$, #(s.ref)("1") will be changed likely to the following if substituting to #(s.tag)("2") :
  $
    h^(j k) nabla_j nabla_k u=underbrace(-(partial^2_t u) + nabla_g u, "wave equation")
  $ #(s.tag)("3")
  If we define 
  $
    square := h^(j k) nabla_j nabla_k
  $ <definition_of_Lorentizan_Laplacian_2>
  , it will achieve to explain the wave equation by using single operator! Fortunately, we can easily prove that makes sense by the similar argument to @lemma_relationship_of_laplacian_and_hessian.#footnote[If we just introduce the Lorentzian version of tangent-cotangent isomorphism, so that $op("grad")_h$ can be used, this argument is the same as @lemma_relationship_of_laplacian_and_hessian.] Thus we have the Lorentizan style wave equation :
  $
    square u = 0
  $ <Lorentizan_style_wave_equation>
])

#proposition(title: "Relationship between stress-energy tensor and Lorentizan Laplacian")[
  For a @Lorentizan_style_wave_equation on a general Lorentz manifold $Omega$, the stress-energy tensor has vanishing divergence, that is,
  $
    nabla_k tilde(T)=0 "where " tilde(T)=T^(j k)
  $ 
  More generally, for any $u$,
  $
    nabla_k T^(j k) = (nabla^j u) square u
  $ where $nabla^j u=h^(j k) nabla_k u$.#footnote[Actually, $nabla^j u$ considering the summation convention is $op("grad")_h u$.]
]<divergence_free_of_stress-energy_tensor>

#proof()[
  This is a straightforward calculation. We have :
  $
    T^(j k)= nabla^j u thin nabla^k u - frac(1,2) h^(j k) h ^(mu nu) nabla_mu u  thin nabla_nu u 
  $
  Moreover, Since we can introduce the Lorentzian version of @Fundamental_theorem_of_Riemannian_geometry,#footnote[it can be easily proved!] the connection is also Levi-Civita connection. It guarantees $nabla_l h^(j k)=0$. Therefore, we get the following, by distributing $nabla_k $ :
  #local-scope-annotations(s => [
    #flowbox()[
      $
        nabla_k T^(j k) &= pmark(nabla_k, tag: #(s.tag)("nabla-1")) ( rmark(nabla^j u, tag: #(s.tag)("term-1a")) rmark(nabla^k u, tag: #(s.tag)("term-1b")) )- frac(1,2) pmark(nabla_k, tag: #(s.tag)("nabla-2")) ( bmark(h^(j k), tag: #(s.tag)("metric-1")) bmark(h^(mu nu), tag: #(s.tag)("metric-2")) bmark(nabla_mu u, tag: #(s.tag)("term-2a")) bmark(nabla_nu u, tag: #(s.tag)("term-2b")) )
        \
        \
        &= underbrace((nabla_k nabla^j u) nabla^k u, (2)) + nabla^j u (nabla_k nabla^k u) \
        \
        & cancel(- frac(1,2) nabla_k h^(j k) h^(mu nu) nabla_mu u nabla_nu u - frac(1,2) h^(j k) nabla_k h^(mu nu) nabla_mu u nabla_nu u , stroke: #(paint: red)) \
        & - underbrace((frac(1,2) h^(j k) h^(mu nu) ( (nabla_k nabla_mu u) nabla_nu u + nabla_mu u (nabla_k nabla_nu u) )), (1): "the last term")
        
        #(s.annot)(
          ("nabla-1", "term-1a", "term-1b", "nabla-2", "metric-1", "metric-2", "term-2a", "term-2b"),
          cetz,
          {
            import cetz.draw: *
            set-style(mark: (end: "straight"))
            
            bezier-through(
              (s.node)("nabla-1", "south"),
              (rel: (x: 0.15, y: -0.25)),
              (s.node)("term-1a", "south"),
              stroke: red,
            )
            
            bezier-through(
              (s.node)("nabla-1", "north"),
              (rel: (x: 0.35, y: 0.35)),
              (s.node)("term-1b", "north"),
              stroke: red,
            )
            
            bezier-through(
              (s.node)("nabla-2", "south"),
              (rel: (x: 0.1, y: -0.25)),
              (s.node)("metric-1", "south"),
              stroke: blue,
            )
            
            bezier-through(
              (s.node)("nabla-2", "south"),
              (rel: (x: 0.2, y: -0.35)),
              (s.node)("metric-2", "south"),
              stroke: blue,
            )
            
            bezier-through(
              (s.node)("nabla-2", "north"),
              (rel: (x: 0.3, y: 0.35)),
              (s.node)("term-2a", "north"),
              stroke: blue,
            )
            
            bezier-through(
              (s.node)("nabla-2", "north"),
              (rel: (x: 0.4, y: 0.45)),
              (s.node)("term-2b", "north"),
              stroke: blue,
            )
          }
        )
      $
    ]
  ])
  Since the connection is torsion-free, the Hessian is symmetric: $nabla_k nabla_mu u = nabla_mu nabla_k u$. Using this symmetry and raising/lowering indices with the metric, the last term simplifies to:
  #local-scope-annotations(s => [
    #flowbox()[
      #set text(size: 1em)
      $
        (1) : & frac(1,2) h^(j k) h^(mu nu) ( (nabla_k nabla_mu u) nabla_nu u + nabla_mu u (nabla_k nabla_nu u) ) 
        \
        &= frac(1,2) h^(j k) h^(mu nu) ( (nabla_mu nabla_k u) nabla_nu u 
        + nabla_mu u (nabla_nu nabla_k u) )
        #dots_space #footnote[By Hessian symmetry: $nabla_k nabla_mu u = nabla_mu nabla_k u$.]
        \
        &= h^(j k) ( pmark(h^(mu nu), tag: #(s.tag)("metric-mu")) pmark(nabla_mu, tag: #(s.tag)("nabla-mu")) nabla_k u ) nabla_nu u
        #dots_space #footnote[Since $h^(mu nu)$ is symmetric, the two terms in the sum are identical under $mu arrow.l.r nu$ swap.]
        \
        \
        &= bmark(h^(j k), tag: #(s.tag)("metric-j-2")) (nabla^nu bmark(nabla_k, tag: #(s.tag)("nabla-j-2")) u) nabla_nu u
        #dots_space #footnote[Contracting $h^(mu nu) nabla_mu = nabla^nu$ raises the index.]
        \
        \
        &= (nabla^j nabla^nu u) nabla_nu u
        #dots_space #footnote[Contracting $h^(j k) nabla_k = nabla^j$ raises the index.]
        
        #(s.annot)(
          ("metric-mu", "nabla-mu"),
          cetz,
          {
            import cetz.draw: *
            set-style(mark: (end: "straight"))
            bezier-through(
              (s.node)("metric-mu", "south"),
              (rel: (x: 0.1, y: -0.25)),
              (s.node)("nabla-mu", "south"),
              stroke: purple,
            )
          }
        )
        
        #(s.annot)(
          ("metric-j-2", "nabla-j-2"),
          cetz,
          {
            import cetz.draw: *
            set-style(mark: (end: "straight"))
            bezier-through(
              (s.node)("metric-j-2", "south"),
              (rel: (x: 0.15, y: -0.25)),
              (s.node)("nabla-j-2", "south"),
              stroke: blue,
            )
          }
        )
      $
    ]
  ])
  Similarly, for the first term:
  $
    (2) : (nabla_k nabla^j u) nabla^k u = (nabla^j nabla_k u) nabla^k u = (nabla^j nabla^nu u) nabla_nu u
  $
  which cancels the last term exactly. Thus, we are left with only the second term:
  $
    nabla_k T^(j k) &= nabla^j u (nabla_k nabla^k u) 
    \
    &= nabla^j u (nabla_k h^(k i) nabla_i u)
    \
    &= nabla^j u thin rmark(h^(i k) (nabla_k  nabla_i u))
    \
    &= (nabla^j u) cancel(rmark(square u), stroke: #(paint: blue,thickness: 0.08em), cross: #true) #dots_space #footnote()[because the wave equation is satisfied(@Lorentizan_style_wave_equation).]
    \
    &=0
  $
]

=== Induced divergence-free vector field on Lorentz manifold

#paragraph-tab
Although we know that the stress-energy tensor is divergence free due to @divergence_free_of_stress-energy_tensor, we are far from to apply the divergence theorem to stress-energy tensor. #highlighted()[First of all, we cannot directly apply the divergence theorem to stress-energy tensor, becuase its divergence isn't vector field, but also the second-order tensor field.] Thus $T$ must be contracted to vector field sufficiently. It maks sense that vector field which made by Contracting $T$ should be divergence-free.

#paragraph-tab
The easiest way to contract $T$ is :
$
  X^j := T^(j k) Z^k
$
Then how can we make $X$ which inherit the divergence-free property from $T$? Again, the easiest way to think is to choose $Z$ as divergence-free. However it is not a good choice.
#local-scope-annotations(s=>[
  $
    nabla_j X^j &= nabla_j (T^(j k) Z^k)
    \
    &= cancel((nabla_j T^(j k)) Z^k, stroke: #(paint: red)) + T^(j k)(nabla_j Z^k) #dots_space #footnote[by @divergence_free_of_stress-energy_tensor]
  $ #(s.tag)("1")
  To $X$ is divergence-free, considering #(s.ref)("1"),$nabla_j Z^k$ should be zero. However we can't move forward without additional assumption! The assumption that $op("div") Z= 0$ isn't enough! As considering @Killing_field_is_more_stronger_condition_than_divergence-free, we can't help to introduce the Killing field.
]) 

#lemma(title: "divergence-free vector field from stress-energy tensor")[
  If $T^(j k)$ is divergence-free and $Z_(k)$ is a Killing field, then 
  $
    X^j = T^(j k) Z^k
  $
  is exist which is the divergence free vector field.
] <naturally_induced_divergence-free_vector_field_from_stress-energy_tensor>

#proof[
 #local-scope-annotations(s=> [
  Again, we get :
 $
    nabla_j X^j &= nabla_j (T^(j k) Z^k)
    \
    &= cancel((nabla_j T^(j k)) Z^k, stroke: #(paint: red)) + rmark(T^(j k)(nabla_j Z^k)) #dots_space #footnote[by @divergence_free_of_stress-energy_tensor]
  $
  To apply the condition that $Z$ is Killing field, let's expand 
  likely to @where_does_the_Killing_field_came_from.
  #flowbox()[
    $
      T^(j k)(nabla_j Z^k) &=frac(1,2)T^(j k)[nabla_j Z^k + nabla_k Z^j] + bmark(frac(1,2)T^(j k)[nabla_j Z^k - nabla_k Z^j])
      \
      &= frac(1,2)T^(j k)[nabla_j Z^k + nabla_k Z^j] + bmark(frac(1,2)T^(k j)[nabla_k Z^j - nabla_j Z^k]) #dots_space #footnote[by interchanging $j<=> k$]
    $

    $arrow.b$

    By the symmetry of $T$
    $
      frac(1,2)T^(k j)[nabla_k Z^j - nabla_j Z^k]=bmark(frac(1,2)T^(j k)[nabla_k Z^j - nabla_j Z^k])
    $ #(s.tag)("the reasion why anti-symmetric part is canceled")
  ]
  Define $bmark(B):= frac(1,2)T^(j k)[nabla_j Z^k - nabla_k Z^j]$, then #(s.ref)("the reasion why anti-symmetric part is canceled") gives $B=-B$. It means $B=0$. Therefore, we get :
  $
    T^(j k)(nabla_j Z^k) &=frac(1,2)T^(j k)[nabla_j Z^k + nabla_k Z^j] + cancel(bmark(frac(1,2)T^(j k)[nabla_j Z^k - nabla_k Z^j]))
    \
    &= cancel(frac(1,2)T^(j k)[nabla_j Z^k + nabla_k Z^j], stroke: #(paint: red))
    \
    &= 0  #dots_space #footnote[by the condition that $Z$ is the Killing field.]
  $
])
]

=== energy-flux identity on Lorentz manifold
#local-scope-annotations( s=>[
  #paragraph-tab
  Since $op("div") X=0$ by @naturally_induced_divergence-free_vector_field_from_stress-energy_tensor, we get the following by applying the divergence theorem :
  $
    integral_cal(O) op("div") X d V = integral_(partial O) h(X, nu) d S=0
  $ #(s.tag)("starting point")
  where $cal(O)$ is the open set inside of Lorentz manifold and $nu$ is normal outward vector. #highlighted()[As mentioned the above(@wave_operator_packaging_fig), we are integrating the mathematics on the product manfold and the Lorentz manifold.] we finished the integration about Laplacian(Lorentizan Laplacian is the result), now let's integrate the energy-flux identity(@energy_flux_identity). Remember that we used the divergence theorem to induce @energy_flux_identity. Therefore, it is good to start from #(s.ref)("starting point") to induce the Lorentizan version of energy-flux identity.

  #paragraph-tab
  To do that, we have to investigate #(s.ref)("starting point") more. let's use $X=T Z$ where $Z$ is Killing field.
  #flowbox()[
    $
      h(X, nu)=h_(j l) X^j nu^l, X^j = T^(j k) Z^k
    $

    $arrow.b$

    $
      h(X, nu) & = markrect(h_(j l) T^(j k), color: #blue) Z^k nu^l
      \
      &= bmark(T_(l)^k) nu^l Z^k #dots_space #footnote[where $T_(l)^k= h_(j l) T^(j k)$]
    $

    $arrow.b$

    The mixed tensor $T_(l)^k$ is complecated to treat.

    $arrow.b$

    $
      h(X, nu) & = T_(l)^k nu^l pmark(Z^k)
      \
      &= T_(l)^k nu^l pmark(h_(m k), tag: #(s.tag)("h-start")) Z^m
      \
      &= pmark(h_(m k), tag: #(s.tag)("h-end")) T_(l)^k nu^l Z^m
      \
      &= T_(l m) nu^l Z^m 

      #(s.annot)(
        ("h-start", "h-end"),
        cetz,
        {
          import cetz.draw: *
          set-style(mark: (end: "straight"))
          line(
            (s.node)("h-start", "south"),
            (s.node)("h-end", "north"),
            stroke: purple,
          )
        }
      )
      \
      &= T (tilde(nu) comma tilde(Z)) #dots_space #footnote[where tilde means the covector version of it.]
    $ #(s.tag)("reformulate h to T")
  ]

  substituting #(s.ref)("reformulate h to T") to #(s.ref)("starting point"), we get :
  $
   integral_cal(O) op("div") X d V = integral_(partial O) T (tilde(nu) comma tilde(Z)) thick d S=0 
  $ <stress-energy_tensor_applied_divergence_theorem>
  Similar to @spacelike_boundary_decomposition_visualization, let's split the integral domain, $partial cal(O)= Sigma_1 union Sigma_2$.
  #flowbox()[
    $
      integral_(partial O) T (tilde(nu) comma tilde(Z)) thick d S & = integral_(Sigma_1) T(tilde(nu)_1, tilde(Z)) d S + integral_(Sigma_2) T(tilde(nu)_2, tilde(Z)) d S #dots_space #footnote[where $nu_i$ is outward normal vector of $Sigma_i$.]
      \
      &= integral_(Sigma_1) T(tilde(nu)_1, tilde(Z)) d S - integral_(Sigma_2) T(tilde(nu)_1, tilde(Z)) d S #dots_space #footnote[where nu_1=- nu_2]
    $

    $arrow.b$


    $
      integral_(Sigma_1) T(tilde(nu)_1, tilde(Z)) d S = integral_(Sigma_2) T(tilde(nu)_1, tilde(Z)) d S
    $ <stress-energy_tensor_flux_identity>
  ]

  #paragraph-tab
  Now, we have the similar equation(@stress-energy_tensor_flux_identity) to @energy_flux_identity. Then let's check $T$ could be energy flux. 
  #lemma(title: "Stress-energy tensor and energyflux")[
    If $Z$ and $nu$ are non-zero timelkie vectors pointing the fucture, then $T$ is positive-definite.
  ] <stress-energy_tensor_and_energy_flux_lemma>

  #proof[
    To compute $T(Z, nu)$ directly, let's pick some point and local coordinates.
    $
      Z & =(Z_0, Z_1, dots.c, Z_n) comma quad Z_x:= (Z_1, dots.c , Z_n)
      \
      Z_0 &> |Z_x| #dots_space #footnote[
        becuase Z is future-directed timelike.
      ] 
      \
      h & =-d t^2+ (d x^1)^2 + dots.c (d x^n)^2
      \
      nu &= partial_0 = (1, 0, dots.c, 0)
    $
    then, 
    #flowbox()[
      $
        T(Z, nu)= d u(Z) d u(nu)- frac(1,2)h (d u, d u) thin h(Z , nu)
      $

      $arrow.b$

      $
        d u(nu) & =d u(partial_0)= partial_0 u 
        \
        d u(Z) & = Z_0 partial_0 u + sum^n_(j=1) Z^j partial_j u
        \
        h(d u, d u) &= -(partial_0 u)^2 + sum^n_(j=1) (partial_j u)^2
        \
        h(Z, nu) &= h(Z, partial_0)= -Z_0 
      $ #(s.tag)("conditions")
      
      $arrow.b$
      
      $
        T(Z, nu)= underbrace(frac(1,2)Z_0 [(partial_0 u )^2 + sum^n_(j=1) (partial_j u)^2], (1)) + overbrace(sum^n_(j=1)Z^j (partial_0 u) (partial_j u), (2))
      $ #(s.tag)("first expandsion of T")
    ]
    (1) is definitely positive, #highlighted()[but (2) could be negative. Since the only way that $T$ can be negative is (2) is also negative, let's assume (2) be negative.] Then 
    $
      (2) >= - |(2)|
    $
    By Cauchy's inequality and geometic inequality, 
    $
      |(2)| = | (partial_0 u ) dot Z_X dot b | &<= |partial_0 u| |Z_x| |b| 
      
      \
      &<= frac(1,2) | Z_x| ((partial_0 u)^2 + |b|^2)   #dots_space #footnote[where $b:= (partial_1 u ,dots.c , partial_n u).$]
    $

    therefore, 
    $
      (2) >= frac(1,2) |Z_x| ((partial_0 u)^2 + |b|^2)
    $ #(s.tag)("expanded second component")

    Now, combine #(s.ref)("expanded second component") and #(s.ref)("first expandsion of T"), we have : 
    $
      T(Z, nu) & >= frac(1,2) Z_0 cal(N) - frac(1,2)|Z_x| cal(N) #dots_space #footnote[where $cal(N):= (partial_0 u)^2 + |b|^2$.]
      \
      & = frac(1,2)(Z_0 - |Z_x|)cal(N)
    $ 
    By #(s.ref)("conditions"), $Z_0 > |Z_x|$.Therefore $T(Z, nu)> 0$ which proves the lemma.
  ]

  #note()[Due to @stress-energy_tensor_and_energy_flux_lemma, $T$ could be energy flux itself.] <Stress-energy_tensor_and_energy_flux>
])
