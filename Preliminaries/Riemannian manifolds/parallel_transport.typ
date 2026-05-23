#import "../../Styles/styles.typ": *
#import "@preview/cetz:0.4.2"
#import "figures.typ": *
#import "@preview/mannot:0.3.1": *
=== Parallel Transport

#definition[
  Let $M$ be a smooth manifold and $nabla$ be a connection in $T M$. A smooth vector field or tensor field $V$ along smooth curve $gamma$ is said to be Parallel along $gamma$ if $D_t V=0$, in other words, its acceleration is zero.

  #figure(parallel_vector_field_along_a_curve(), caption: [A parallel vector field along a curve(flat space)])
]
#paragraph_tab
By the definition of geodesics(@definition_of_geodesics) and assuming that treat $V=gamma^prime$, the paraellism means that the curve is geodesics. This perspective gives :
#lemma(title: "geodesics definition of parallel transport")[
  A vector fild $V$ is parallel if and only if
  $
    dot(V)^k(t)=-V^j(t)dot(gamma)^i(t)Gamma^(k)_(i j)(gamma(t))
  $ <Linear_ODE_of_parallelism>
] <geometric_form_of_parallelism>
Note that the paraellism $D_t V=0$ doesn't mean that the components of $V$ and its direction are constant.
#figure(
  parallel_transport(),
  caption: [Components of Parallel vector field aren't constant.],
) <parallel_vector_components>
See @parallel_vector_components for more detail. The blue vector $V$ never turns (Parallel). But the basis $e_r, e_theta$ rotates by $90^degree$. Therefore, $V$'s components must change to compensate.

#paragraph_tab
Now, how about the direction of $V_p$ where $p in gamma$?
By theorem 4.24, we already know that $D_t$ is only vaild on $gamma$. #highlighted[At the entire manifold perspective(Extrinsic view#footnote[see @interpretation_of_geodesics_equation]),
  $v_gamma in V$ can be non-zero as moving on $gamma$!] The change is due to the curvature of $M$, not acceleration of $gamma$.

#paragraph_tab
The usual ODE theorem guarantees the existence and uniqueness of a solution for a short time(local)#footnote[Picard-Lindelöf theorem], but since @Linear_ODE_of_parallelism is linear, we can actualy show much more.


#theorem(
  title: "4.31 (Existnce, Unqiueness, and Smoothness for Linear ODE)",
)[ Let $I subset.eq bb(R)$ be an open interval, and for $1≤j, k<n$, let $A^k_j : I arrow bb(R)$ be smooth functions. For all $t_0 in I$ and every initial vector $(c^1, dots.h, c^n) in bb(R)^n$, the linear initial value problem
  $
    dot(V)^k(t)=A^k_j(t)V^j(t),
    \
    V^k (t_0)=C^k
  $ <Simultaneous_Linear_ODE_of_parallelism>
  has a unique solution on all of $I$, and the solution depends smoothly on $(t,c) in I times bb(R)^n$
]

#proof[
  Likely to the perspective of @perspective_to_symplectic, we will combine @Simultaneous_Linear_ODE_of_parallelism into a inline form.
  $
    Y:= markrect(frac(partial, partial x^0), color: #blue, tag: #<time_part>) + A^i_j (x^0) x^j frac(partial, partial x^1)+ dots.h.c + A^n_j (x^0)x^j frac(partial, partial x^n)
  $
  #annot(<time_part>, pos: top, dx: -1em, dy: -1em)[it corresponds to $t$ evaluation.]
  If $V(t)=(V^1 (t), dots.h, V^(n)(t))$ is a solution of @Simultaneous_Linear_ODE_of_parallelism with $t_0=0$ defined on some interval $I_0 subset.eq I$, then the curve $eta:=(t,V^1 (t),dots.h,V^(n)(t))$ is an integral curve of $Y$ defined on $I_0$ satisfying the intial condition.
  $
    eta(0)=(0,c^1,dots.h,c^n)
  $ <initial_condition_geometrization>

  #paragraph_tab
  Why is the above geometrization useful? because of the fundamental theorem of flows,#footnote[Actually, it is very similar to Picard-Lindelöf theorem. See @ODE.] there uniquely exists a maximal integral curve $eta$ of $Y$ defined on some open interval containing $0$ and satisfying the initial condition @initial_condition_geometrization. Since we can fine the local interval which the solution is exist on the local by Picard-Lindelöf theorem, it is sufficient to think that $I_0 subset.eq I$ is exist.
  Since every flow has group property, we can apply the above argument whatever $t_0$ is if $t_0 in I$, so that we can make many sub-intervals($I_(t^i_0)$)!
  #figure(expend_interval_of_existence(), caption: [make union $union.big_(t_0^i in I)^infinity I_(t_0^i)$])

  #paragraph_tab
  Define $I_("union"):=union.big_(t_0^i in I)^infinity I_(t_0^i)$.
  Than, there is no guarantee that $I_("union")=I$!#footnote[I don't explain this problem more detail. This problem is the same as Uniform time Lemma(Zeno's paradox) of @Manifolds.]
  To do this, the solution doesn't escape to infinity on $I$. How can we prove it? Note that $I$ is the time interval, it is more efficient to use $V$, not $Y$. I think there is only one way to prove it, which is directly computing. #highlight[At this situation, the energy is the best candidate.]
  $
    E(t):=bar.v V(t)bar.v^2=sum_(k=1)^n (V^(k)(t))^2 #dots_space #footnote[Energy is just a norm of $V$.]
  $

  #paragraph_tab
  We want to show how this energy evolves.
  $
    frac(d, d t) E(t)& =frac(d, d t) sum_(k=1)^n (V^(k)(t))^2
    \
    & =
    2sum_(k=1)^n dot(V)^(k)(t)V^(k)(t) & "by chain rule"
    \
    & =
    2sum_(k=1)^n A^(k)_(j) V^j(t) V^(k)(t) #dots_space #footnote[By the definition of system @initial_condition_geometrization]
    \
    & =
    2 V(t)^tack.b A(t) V(t) & "as writing matrix form"
    \
    & =2
    chevron.l V(t), A(t) V(t) chevron.r_g & "by definition of inner product"
  $
  By the basic property of inner product, we get a natural inequality.
  #flowbox[
    *Cauchy-Schwarz inequality*
    $
      bar.v chevron.l V(t), A(t) V(t) chevron.r_g bar.v lt.eq bar.v V(t)bar.v bar.v A(t) V(t)bar.v_g & lt.eq bar.v V bar.v dot bar.v A bar.v bar.v V bar.v \ lt.eq bar.v A bar.v bar.v V bar.v^2
    $
    $arrow.b$

    $frac(d, d t) bar.v V(t)bar.v^2=
    2chevron.l V(t), A(t) V(t) chevron.r_g
    lt.eq markrect(
      2 |chevron.l V(t) comma A(t) V(t) chevron.r |
      lt.eq 2 |A(t)| |V(t)|^2, tag: #<Cauchy-Schwarz_inequality_is_used>, color: #blue
    )$
    #annot(
      <Cauchy-Schwarz_inequality_is_used>,
      pos: top,
      dy: -1.5em,
      leader-toe: tiptoe.stealth.with(length: 1000%),
    )[use Cauchy-Schwarz inequality]

    $arrow.b$

    $
      therefore frac(d, d t) bar.v V(t)bar.v^2 lt.eq 2 |A(t)| |V(t)|^2
    $ <result_of_Cauchy_Schwarz_inequality>
  ]

  #paragraph_tab
  Now, we can show that $E(t)$ doesn't blow up when $t arrow b(t arrow sup I)$. #highlighted[Note that $E(t)$ or $V(t)$ are not determined explicitly. Thus the only way to show the blowing up is to compare with other function which is well-known.] In this situation, we often use the exponential, becuase it is 'rapidly' growing or decaying.

  #flowbox[
    Define
    $|A(t)| lt.eq M$ where $M$ is a constant.

    $arrow.b$

    $
      frac(d, d t) paren.l e^markrect((-2M t), color: #blue, tag: #<exponential>) bar.v V(t)bar.v^2 paren.r & =
                                                                                                              e^(-2M t)
                                                                                                              mark(
                                                                                                                paren.l
                                                                                                                frac(d, d t) bar.v V(t)bar.v^2 -2M bar.v V(t)bar.v^2
                                                                                                                paren.r, color: #purple, tag: #<result_of_chain_rule>
                                                                                                              )
    $
    #annot(<exponential>, pos: top, dy: -1.4em)[It is designed to make the right side]
    #annot-cetz(
      (<exponential>, <result_of_chain_rule>),
      cetz,
      {
        import cetz.draw: *
        set-style(mark: (end: "straight"))
        bezier-through("exponential.south", (rel: (x: 6.2, y: -0.5)), "result_of_chain_rule.south", stroke: red)
      },
    )
    #annot(
      <result_of_chain_rule>,
      pos: bottom + right,
    )[it is $lt.eq 0$ by moving the RH to LH of @result_of_Cauchy_Schwarz_inequality]

    $arrow.b$

    $
      therefore
      frac(d, d t) shell.l e^(-2M t) bar.v V(t)bar.v^2 shell.r
      lt.eq
      0
    $ <result_of_comparing_with_exponential>
  ]
  Since @result_of_comparing_with_exponential less than zero, the primitive of left hand side of @result_of_comparing_with_exponential is decreasing. It means $bar.v V(t)bar.v^2$ doesn't blow up at leat on $I$.
  #flowbox[
    The 'decreasing' implies that the biggest value is the initial.
    $
      e^(-2M t)|V(t)|^2 & lt.eq cancel(e^(-2M t_0))|V(t_0)|^2
      \
      & lt.eq |V(0)|^2 & "by assuming"^#footnote[This assumption is understandable becuase of the group property of flows.] t_0=0
    $

    $arrow.b$

    $
      therefore |V(t)|^2 lt.eq e^(2 M t) |V(0)|^2
    $
  ]
  Hence, the vector field $Y$ is well-defined on $I$, in other words it doesn't blow up at least on $I$.
]
#theorem(
  title: [4.32 (Existence and Uniqueness of Parallel Transport)],
)[ Supose $M$ is a smooth manifold with or without boundary, and $nabla$ is a connection in $T M$. Given a smooth curve $gamma : I arrow M$, $t_0 in I$, and $v in T_(gamma(t_0)) M$ or tensor $v in T^(k comma l) (T_(gamma(t_0)) M)$, there exists a unique parallel transport $Y$ along $gamma$ such that $V(t_0)=v$
]
#proof[
  The proof is a two-step process: Local Solving(inside one chart) and Global Patching.

  #paragraph_tab
  First, assume the entire curve $gamma(I)$ is inside one chart $U$. We know the condition for a vector field $V$ to be parallel along $gamma$ is $frac(d, d t) V(t) = 0$ or $nabla_(gamma'(t)) V(t) = 0$ translated into coordinates as a system of ODEs by using @Linear_ODE_of_parallelism.
  $
    dot(V)^k(t)=markhl(-dot(gamma)^i(t)Gamma^(k)_(i j)(gamma(t)))V^j(t)
  $
  Look at the coefficient of $V^j(t)$. it is exactly the form of the first line of @Simultaneous_Linear_ODE_of_parallelism! Therefore, We can apply theorem 4.31, such that guaranteeing the existence and uniqueness of the solution for a given initial.

  #paragraph_tab
  Now, suppose the curve is long and wanders through multiple coordinate charts. We use a "Supremum Argument" To prove it, we use reduction to absurdity. the reduction hypothesis is : there exists a sequence of charts $U_i$ such that $gamma(I) subset U_i$ and $gamma(I)$ is not contained in any single chart. Thus define $beta in I$, where $gamma(beta)$ is on $partial U_i$. By the reduction hypothesis, $beta$ is the supremum of existence of solution, so there is no guarantee that the solution is on $beta$. As picking $beta-delta/2$, we can fine the solution nearby $beta$. By the fundamental theorem of flow, there is a solution nearby $beta-delta/2$, so that the solution on $(beta-delta/2, beta+delta/2)$. Since $beta < beta+delta/2$, the reduction hypothesis is false, which proves that we can jump over the initial chart $U_i$.

  #figure(theorem432_run_up(), caption: [run-up point to jump over the initial chart])
]

#paragraph_tab
Since the parallel transport is unique, we can define the parallel transport map $P_(t_0 t_1)^gamma$ as the unique parallel transport along $gamma$ from $t_0$ to $t_1$.

#definition(
  title: "parallel transport map",
)[For each $t_0,t_1 in I$, $P_(t_0 t_1)^gamma$ we define a map $ P^(gamma)_(t_0t_1) : T_(gamma(t_0)) M arrow T_(gamma(t_1)) M $
  called the parallel transport map, by setting $P^(gamma)_(t_0t_1) = V(t_1)$, for each $v in T_(gamma(t_0)) M$, where $V$ is the unique parallel transport along $gamma$ from $t_0$ to $t_1$. This map is linear, becuase the equation of parallelism is linear.
]

#paragraph_tab
It is also useful to extend the parallel transport operation to curves that are merely piecewise smooth.
#definition(
  title: "piecewise smooth vector field",
)[Given an admissible curve $gamma : [a,b] arrow M$, a map $V : [a,b] arrow T M$ such that $V(t) in T_(gamma(t)) M$ for each $t in [a,b]$ is called a piecewise smooth vector field along $gamma$ if $V$ is continuous and there is and admissible partition $a_0, dots a_k )$ for $gamma$ such that $V$ is smooth on each subinterval $[a_(i-1), a_i]$.
  - We will call any such partition an admissible partition for $V$.
  - A piecewise smooth vector field $V$ along $gamma$ is said to be parallel along $gamma$ if $D_t V=0$ whereever $V$ is smooth.
]

#figure(parallel_transport_map(), caption: [parallel transport map])

#paragraph_tab
Here is an extremely useful tool for working with parallel transport. Imagine we choose 'smart' basis $E_1,dots, E_n$ that is already parallel transported along the curve. By the definition of parallel transport, $D_t E_i=0$. substitute this into the product rule :
$
  D_t V = dot(V)^i E_i+V^(i)(0)=dot(V)^i E_i
$<parallel_frame_transport>
Now, if we enforce the condition $D_t V=0$, we get $dot(V)^i=0$, which means the components are constant! Then when is possible? The representive example is Euclidean space where the standard basis is parallel.

#figure(
  Euclidean_space_parallel_transport(),
  caption: [Global Parallel Frame in $bb(R)^3$ : $E_1, E_2, E_3$ never rotate. $D_t E_i = 0 =>$ Components are constant.],
)

#paragraph_tab
The parallel transport map is the means by which a connection "connects" nearby tangent spaces. The next theroem and its corollary shows that parallel transport determines covariant differentiation along curves, and thereby the connection itself.
#theorem(
  title: "4.34(Parallel Transport Determines Covariant Differentiation)",
)[Let $M$ be a smooth manifold with or without boundary, and let $nabla$ be a connection in $"TM"$. Suppose $gamma : I arrow M$ is a smooth curve and $V$ is a smooth vector field along $gamma$. For each $t_0 in I$,
  $
    D_t V(t_0)= lim_(t_1 arrow t_0)frac(p_(t_1t_0)^(gamma)V(t_1)-V(t_0), t_1-t_0)
  $ <parallel_transport_determines_covariant_differentiation>.
  ]
#proof[
  Let $(E_i)$ be a parallel frame along $gamma$, and write $V(t)=V^i(t)E_i(t)$ for $t in I$. One the one hand, @parallel_frame_transport shows that $D_t V(t_0)= dot(V^i)(t_0)E_i(t_0)$. #highlighted[Then we can know that we @parallel_transport_determines_covariant_differentiation can come from $dot(V^i)(t_0)$.]
  #flowbox[
    $
    dot(V)^(i)(t_0):=lim_(t_1 arrow t_0)frac(V^(i)(t_1)-V^(i)(t_0), t_1-t_0)
    $

    $arrow.b$

    multiply both sides by $E_i (t_0)$
    $
    dot(V)^(i)(t_(0))=lim_(t_1 arrow t_0)frac(V^(i)(t_1)E_(i)(t_0) -V^(i)(t_0)E_(i)(t_0), t_1-t_0)
    $ <parallel_transport_determines_covariant_differentiation_2>

    $arrow.b$

    Use $P_(t_1 t_0)^(gamma)V(t_(1))=V^(i)(t_1)E_i(t_0)$ and $V(t_0)=V^(i)(t_0)E_i(t_0)$. Then @parallel_transport_determines_covariant_differentiation_2 shows that
    $
    lim_(t_1 arrow t_0)frac(P_(t_1 t_0)^(gamma)V(t_(1)) -V(t_0), t_1-t_0)
    $
  ]
]

#note[
  #figure(
    table(
      columns: 3,
      [Feature], [Covariant Derivative ($D_V W$)], [Lie Derivative ($L_V W$)],
      [Transport Tool], [Parallel Transport ($P_(t arrow 0)$)], [Flow Pushforward ($d theta_(-t)$)],
      [Source], [The Connection (Geometry)], [The Vector Field $V$ (Topology/Flow)],
      [Physical Meaning],
      [Rate of change relative to the straightest path (geodesic).],
      [Rate of change relative to the flowing fluid generated by $V$.],

      [Formula],
      [$lim_(t arrow 0) frac(P_(t arrow 0)(W_(gamma(t))) - W_(p), t)$],
      [$lim_(t arrow 0) frac(d shell.l theta_(-t)shell.r W_(theta_(t)(p)) - W_(p), t)$],
    ),
    caption: [Comparison of Covariant Derivative and Lie Derivative],
  )
]
