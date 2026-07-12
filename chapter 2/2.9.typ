#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.4.0": *

== The symbol of a differental operator and a general Green-Stokes formula
#local-scope-annotations(s =>[
=== The symbol of a differental operator
#paragraph-tab
To treat more general system than @first_condition_of_hypoerbolic_equations, let's construct a differental operator which contain general high-order system. Let $p$ be a differental operator of order $m$ on a manifold $M$; $P$ could operate on sections of a vector bundle. In local coordinates, $P$ has the form :
$
  bmark(P u (x), tag: #(s.tag)("all derivatives")):= sum_(|alpha| <=m) p_alpha (x) D^alpha u (x)

  #annot((s.tag)("all derivatives"), pos: left, dx: -2em)[All derivatives of $u$ up to order $m$]
$ <definition_of_general_differential_operator>
where $D^alpha := D^(alpha_1)_1 dots.c D^(alpha_n)_n$, $D_j := frac(1,i) frac(partial, partial x_j)$ and $alpha$ is multi-index. The coefficients $P_alpha (x)$ could be matrix valued when $u$ isn't scalar function, but also vector-valued function. For example of $P$, let $m=2$.
$
  P u = sum_(|alpha|=2) P_alpha (x) D^alpha u + sum_(|alpha|=1) P_alpha (x)D^alpha u + P_0 (x) u
$ 

#paragraph-tab
Why do we define $D_j$ strangely? It is becuase it is common in microlocal analysis and PDE symbol theory.
$
  D_j e^(i x dot xi)= frac(1, i) frac(partial, partial x_j) e^(i x dot xi) = frac(1,i)(i xi)e^(i x dot xi)= xi_j e^(i x dot xi)
$
So $D_j$ turns into the multiplication by $xi_j$. This is the main reason for using $D_j:=1/i partial_j$. It makes the symbol cleaner.

#paragraph-tab
Let $xi in T_x M$. Then we denote the high-order part of $p$.
$
  p_m (x,xi):= sum_(|alpha|=m) p_(alpha)(x) xi^alpha
$ #(s.tag)("definition of principal symbol")
where $m:= op("dim") M$. #highlighted()[Heuristically, $xi$ is a covector version of $D$.] In more detail, 
#flowbox()[
  $
    D_j e^(i lambda phi)= partial_j phi e^(i lambda phi)
    \
    d phi = sum_(j=1)^n partial_j phi thin d x^j
    \
    xi := d phi in T^*_x M
  $ #(s.tag)("covector version of D")

  $arrow.b$

  $
    xi& = markrect(sum_(j=1)^n xi_j thin d x^j, tag:#(s.tag)("components of xi"), color: #purple)
    \
    markuw(xi & in T^*_x M, tag:#(s.tag)("covector version of D is independent of coordinates itself"), color: #olive)

    #annot((s.tag)("components of xi"), pos: right, dx: 2em)[The components of $xi$ depend on 
    \
    the choice of local coordinates.]
    #annot((s.tag)("covector version of D is independent of coordinates itself"), pos:left, dx: -2em)[$xi$ is independent of 
    \
    the choice of local coordinates itself.]
  $
]
$P_m$ is called the principal symbol(or just the symbol) of $P$.#footnote[This is usually the most important part because it controls the leading behavior of the equation.] Now, we want to give an intrinsic characterization, which will show that $p_(m)(x, xi)$ is well defined on the cotangent bundle of $M$. For a smooth function $psi$, a simple calculation, using the product rule and chain rule of differentiation, gives :
#flowbox()[
  $
    D_j ( u e^(i lambda psi)) &= (D_j u )e^(j lambda psi)+ u D_j e^(i lambda psi)
    \
    &= (D_j u + lambda u (partial_i psi))e^(i lambda psi)
  $

  $arrow.b$

  consider multi-index $alpha$
  $
    D^alpha (u e^(i lambda psi))=(markuw(lambda^(|alpha|) (partial_i psi)^(|alpha|) u, #purple, tag:#(s.tag)("highest-order of lambda")) + markuw(D^alpha_j u,#olive, tag: #(s.tag)("lower powers of lambda")) )e^(i lambda psi)

    #annot((s.tag)("lower powers of lambda"), pos: bottom+ right)[lower powers of $lambda$]
    #annot((s.tag)("highest-order of lambda"), pos: bottom+left, dx: -2em)[highest order term of $lambda$]
  $

  $arrow.b$

  $
    P(u(x) e^(i lambda psi)) =[p_(m)(x, d psi) u (x) lambda^m + markuw(r(x,lambda), #fuchsia, tag:#(s.tag)("residual polynomial"))]e^(i lambda psi)

    #annot((s.tag)("residual polynomial"), pos: top)[a polynoimal of degree $< m-1$ in $lambda$]
  $ #(s.tag)("before intrinsic characteristization")
]

#paragraph-tab
$r(x, lambda)$ is quite cumbersome. let's cancel the residual polynomial. In #(s.ref)("before intrinsic characteristization"), $p_m (x, d psi)$ is evaluated by substituting $xi = ((partial psi)/ (partial x_1) , dots.c , (partial psi)/ (partial x_n))$ into #(s.ref)("definition of principal symbol"). Thus the following formula is induced.
#flowbox()[
  $
    lambda^(-m) e^(-i lambda psi) P(u(x) e^(i lambda psi)) 
    &= [
      p_m (x, d psi) u (x) cancel(lambda^m lambda^(-m), stroke: #(paint: red)) 
      \
      &+ 
      markuw(lambda^(-m)r(x,lambda), color: #olive, tag:#(s.tag)("residual polynomial will be approximated"))
    ]cancel(e^(i lambda psi)e^(-i lambda psi), stroke: #(paint: red))

    #annot((s.tag)("residual polynomial will be approximated"), pos: bottom+right)[$cal(O)(lambda^(-1)) arrow.r 0$ when $lambda arrow.r infinity$]
  $

  $arrow.b$

  $
    lim_(lambda arrow.r infinity) lambda^(-m) e^(-i lambda psi) P(u(x) e^(i lambda psi)) = p_m (x, d psi) u (x) #dots_space #footnote[The limit represents that we don't care about the lower order terms of $lambda$ and we only want to focus on the leading term.]
  $ #(s.tag)("coordinate-free definition of principal symbol")
]
#(s.ref)("coordinate-free definition of principal symbol") gives the coordiate-free definition of the principal symbol, instead of the coordinate-dependent definition(#(s.ref)("definition of principal symbol")).#footnote[#(s.ref)("definition of principal symbol") is coordinate-dependent because $xi^alpha$ depends on the choice of local coordinates. Be careful that $xi$ doesn't depend on coordinates itself, but also the 'components' of $xi$ depend on the choice of local coordinates.] The meaning of #(s.ref)("coordinate-free definition of principal symbol") isn't just a cleaner definition, if we assume that :
$
  P: C^(infinity)(M, E_0) arrow.r C^(infinity)(M, E_1)
$ #(s.tag)("differential operator between section spaces")
where $E_0, E_1$ are smooth vector bundles over $M$. Then for each $(x, xi) in T^* M$ and the smooth section $u in C^(infinity)(M, E_0)$ $p_m$ defines a linear map :
$
  p_m (x, xi): E_(0)bar.v_x arrow.r E_(1)bar.v_x
$ #(s.tag)("principal symbol is a fiber map")
#highlighted()[Since #(s.ref)("coordinate-free definition of principal symbol") guarantees that $p_m (x, xi)$ can be defined independently of the choice of local coordinates, #(s.ref)("principal symbol is a fiber map") is well-defined. ]

#paragraph-tab
First of all, define a metric on the vector bundle $E_j$.
#definition(title: "metric on vector bundles")[
  We can easily define the metric on the vector bundles. By the definition of vector bundle(local trivialization property), $E_x approx.eq bb(R)^m$ which is also satisfied the manifold definition. Thus $cal(M)$ be the manifold satisfying $cal(M)=E_x$. Then we can introduce the metric $cal(g)_x: cal(M)times cal(M) arrow.r bb(R)$. As expanding $cal(g)_x$ to the global which denotes $cal(g)$, we will use $cal(g)$ as the metric of vector bundles.
]
Then it gives the formal adjoint of a differential operator. The formal adjoint is defined as follows.

#definition(title: "formal adjoint of a differential operator")[
  If $M$ has a Riemannian metric, and the vector bundles $E_j$ have metrics, then the formal adjoint $P^t$ of a differential operator of order $m$ like #(s.ref)("differential operator between section spaces") is the operator
  $
    P^t: C^(infinity)(M, E_1) arrow.r C^(infinity)(M, E_0)
  $
  defined by the condition that by using global L-2 norm(@L-2_norm_of_1-form)
  $
  (P u , v)= (u, P^t v) 
  $ #(s.tag)("definition of formal adjoint with compactly supported functions")
  if $u$ and $v$ are smooth, compactly supported sections of $E_0$ and $E_1$.
] <formal_adjoint_of_differential_operator>
#note(title: "formal adjoint of vector field and differential operator")[
  Both $P^t$ and $X^*$ are the same concept. #highlighted()[It is just that $X^*$ is a special case of $P^t$ when $P$ is a vector field.] Hence @formal_adjoint_of_vector_field and @formal_adjoint_of_differential_operator are related.
] #(s.tag)("Category of formal adjoint")

#paragraph-tab
Now we show that $P^t$ is again a differential operator of order at most $m$. Let $cal(O)$ be a coordinate patch on which $E_0$ and $E_1$ are trivialized. We write $u=(u^gamma)$ and $v=(v^delta)$, where $gamma, eta$ are fiber indices for $E_0$, and $epsilon, delta$ are fiber indices for $E_1$. Since $p_(alpha)(x): E_(0,x) arrow.r E_(1,x)$, its local matrix entries are $(p_alpha)^epsilon _gamma$. #highlighted[We take the local inner product formula as the starting point, with $tilde(cal(g))$ the metric on $E_1$, $cal(g)$ the metric on $E_0$,] and $sqrt(det(g)) thin d x$ the Riemannian volume density.
$
  (P u, v)
  &= integral_(cal(O)) tilde(cal(g))_(epsilon delta)(x) pmark((P u)^epsilon, tag: #(s.tag)("substitute-local-P")) v^delta sqrt(op("det") g(x)) thin d x
  \
  pmark((P u)^epsilon, tag: #(s.tag)("local-P-expanded"))
  &= sum_(|alpha| <= m) (p_alpha)^epsilon _gamma D^alpha u^gamma,
  quad D^alpha = D_1^(alpha_1) dots.c D_n^(alpha_n),
  quad D_j = frac(1, i) frac(partial, partial x_j)
  \
  therefore (P u, v)
  &= sum_(|alpha| <= m)
  integral_(cal(O))
  markrect(tilde(cal(g))_(epsilon delta) (p_alpha)^epsilon _gamma v^delta sqrt(op("det") g(x)), tag: #(s.tag)("C-factor"), color: #blue)
  D^alpha u^gamma thin d x
  quad
  C_(alpha,gamma):= markrect(tilde(cal(g))_(epsilon delta) (p_alpha)^epsilon _gamma v^delta sqrt(det(g)), tag: #(s.tag)("C-definition"), color: #blue)

  #annot(((s.tag)("substitute-local-P"), (s.tag)("local-P-expanded")), pos: top+right, dx: 3em, leader-connect: "elbow")[substitute the local formula for $P u$]
  #annot(((s.tag)("C-factor"), (s.tag)("C-definition")), pos: bottom, dy: 0.8em, leader-connect: "elbow")[collect all non-$D^alpha u^gamma$ factors]
$
Thus each summand has the form $integral_(cal(O)) C_(alpha,gamma) D^alpha u^gamma thin d x$.

#paragraph-tab
Integration by parts moves all derivatives from $u^gamma$ onto $C_(alpha,gamma)$. Since $u$ and $v$ are compactly supported in $cal(O)$, no boundary term appears. For a multi-index $alpha$, this means that integration by parts is applied $|alpha|$ times. Therefore, up to the sign and conjugation convention determined by $D_j = frac(1, i) partial_(x_j)$,
$
  integral_(cal(O)) C_(alpha,gamma) rmark(D_j w, tag: #(s.tag)("one-derivative-on-w")) thin d x
  &=
  cancel([C_(alpha,gamma) w]_(partial cal(O)), stroke: #(paint: red))
  + kappa_j integral_(cal(O)) markuw(D_j C_(alpha,gamma), color: #olive, tag: #(s.tag)("one-derivative-on-C")) w thin d x
  \
  integral_(cal(O)) C_(alpha,gamma) rmark(D^alpha u^gamma, tag: #(s.tag)("derivatives-on-u")) thin d x
  &=
  kappa_alpha integral_(cal(O)) u^gamma markuw(D^alpha C_(alpha,gamma), color: #olive, tag: #(s.tag)("derivatives-on-C")) thin d x
  \
  (P u, v)
  &= integral_(cal(O)) u^gamma B_gamma thin d x,
  quad
  B_gamma
  =
  sum_(|alpha| <= m)
  D^alpha (tilde(cal(g))_(epsilon delta) (p_alpha)^epsilon _gamma v^delta sqrt(det(g)))

  #annot(((s.tag)("one-derivative-on-w"), (s.tag)("one-derivative-on-C")), pos: top, dy: -0.8em, leader-connect: "elbow")[one integration by parts]
  #annot(((s.tag)("derivatives-on-u"), (s.tag)("derivatives-on-C")), pos: bottom, dy: 0.9em, leader-connect: "elbow")[repeat $|alpha|$ times]
$ #(s.tag)("ibp-B-formula")
Here $kappa_j$ and $kappa_alpha$ record only the sign and conjugation convention; they do not affect the order of the resulting operator.

#paragraph-tab
Now compare this expression with the defining identity
$
  integral_(cal(O)) u^gamma bmark(B_gamma, tag: #(s.tag)("compare-B")) thin d x
  &=
  integral_(cal(O)) u^gamma markrect(cal(g)_(gamma eta)(P^t v)^eta sqrt(det(g)), tag: #(s.tag)("compare-adjoint-coeff"), color: #purple) thin d x
  \
  B_gamma
  &= cal(g)_(gamma eta)(P^t v)^eta sqrt(det(g))
  \
  (P^t v)^eta
  &= frac(1, sqrt(det(g))) cal(g)^(eta gamma) B_gamma

  #annot(((s.tag)("compare-B"), (s.tag)("compare-adjoint-coeff")), pos: top+right, dx: 3em, dy: -0.6em, leader-connect: "elbow")[compare coefficients of arbitrary compactly supported $u^gamma$]
$ #(s.tag)("solve-for-formal-adjoint")

#paragraph-tab
To identify the order of $(P^t v)^eta$ in #(s.ref)("solve-for-formal-adjoint"), apply the product rule to the $B_gamma$ formula in #(s.ref)("ibp-B-formula"):
$ 
  A_(alpha,gamma,delta)(x)
  &:=
  markrect(tilde(cal(g))_(epsilon delta) (p_alpha)^epsilon _gamma sqrt(det(g)), tag: #(s.tag)("metric-coeff-factor"), color: #purple)
  \
  D^alpha (A_(alpha,gamma,delta) markuw(v^delta, color: #olive, tag: #(s.tag)("v-factor")))
  &=
  sum_(beta <= alpha)
  markuw(a_(alpha,beta,gamma,delta)(x), color: #olive, tag: #(s.tag)("product-rule-coefficient"))
  D^beta v^delta
  \
  markrect((p^t_beta)^(eta)_delta(x), tag: #(s.tag)("absorbed-coefficient"), color: #blue)
  &:=
  frac(1, sqrt(det(g))) cal(g)^(eta gamma)
  sum_(|alpha| <= m, beta <= alpha)
  a_(alpha,beta,gamma,delta)(x)
  \
  (P^t v)^eta
  &=
  sum_(|beta| <= m)
  markrect((p^t_beta)^(eta)_delta (x), tag: #(s.tag)("absorbed-coefficient-used"), color: #blue)
  D^beta v^delta,
  \
  therefore P^t v(x)
  &=
  sum_(|beta| <= m)
  p^t_beta (x) D^beta v(x)

  #annot(((s.tag)("metric-coeff-factor"), (s.tag)("v-factor")), pos: top+left, dx: -2em, dy: -0.4em, leader-connect: "elbow")[product rule]
  #annot(((s.tag)("product-rule-coefficient"), (s.tag)("absorbed-coefficient"), (s.tag)("absorbed-coefficient-used")), pos: bottom+right, dx: 2em, dy: 0.8em, leader-connect: "elbow")[absorbed into $p^t_beta$]
$ #(s.tag)("process of computing the formal adjoint of P locally")
Here $a_(alpha,beta,gamma,delta)(x)$ is smooth and contains the derivatives of $A_(alpha,gamma,delta)$. Since $beta <= alpha$ implies $|beta| <= |alpha| <= m$, only derivatives $D^beta v$ of order at most $m$ appear.
Thus the formal adjoint $P^t$ is again a differential operator of order at most $m$.

=== general Green-Stokes formula
#paragraph-tab
Now suppose $M$ is a compact, smooth manifold with smooth boundary. We want to obtain a generalization of @general_integral_version_of_the_product_rule_of_Riemmanian_divergence to induce the general Green-Stokes formula.
#lemma()[
  Let $M$ is a compact, smooth manifold with smooth boundary. For $X in frak(X)(M)$ , $u , v in C^infinity (M)$ where $u$ and $v$ are real valued scalar functions, the following equation is true :
  $
    (X u , v )- (u, X^t v )= integral_(partial M) chevron.l nu, X chevron.r u dash(v) d S
  $

]

#proof[
  By #(s.ref)("Category of formal adjoint") and @adjoint_and_diveregence, we get : 
  $
    (u, X^* v)= integral_M u (-X v - (op("div") X)v) d V
  $
  Therefore, 
  $
    (X u , v )- (u, X^* v )&= integral_M [markuw((X u )v + u(X v), tag:#(s.tag)("result of distirbution rule"), color: #olive)+ markul((op("div") X)u v)] d V #dots_space #footnote[Remember the global inner product with scalar functions is : $(u, v ) = integral_M chevron.l u comma v chevron.r _p d V$ and $chevron.l u, v chevron.r := u dash(v)$. If we assume that $u$ and $v$ are real-valued scalar functions, $chevron.l u, v chevron.r := u v$.]
    \
    &= integral_M [cancel(mark(X u v, color: #olive), stroke: #(paint: red))+ markul(
      op("div") (u v X)-cancel(X(u v)),
      color: #blue
    )] d V #dots_space #footnote[by the product rule of Riemannian divergence(@the_product_rule_of_Riemmanian_divergence)]
    \
    &= integral_M op("div") (u v X) d V
    \
    &= integral_(partial M) chevron.l nu, u v X chevron.r d S #dots_space #footnote[by the divergence theorem]
    \
    &= integral_(partial M) chevron.l nu, X chevron.r u v d S #dots_space #footnote[by moving $u$ and $v$ out of the inner product]
    

    #annot((s.tag)("result of distirbution rule"), pos: bottom+left, dx: -4em, dy: 1em)[$X( u v)= (X u)v + u(X v)$]
  $
]

#paragraph-tab
Now, let $P_1$ be a general first-order differential operator acting on sections as in #(s.ref)("differential operator between section spaces"):
$
  P_1: C^(infinity)(M, E_0) arrow.r C^(infinity)(M, E_1).
$
In a local coordinate patch $cal(O)$ where $E_0$ and $E_1$ are trivialized, assume
$
  P_1 u := sum^n_(j=1) a^(j)(x) frac(partial u, partial x_j)(x) + b(x) u,
$
where $a^(j)(x): E_(0,x) arrow.r E_(1,x)$ and $b(x): E_(0,x) arrow.r E_(1,x)$. The derivative $frac(partial u, partial x_j)(x)$ is locally $E_(0,x)$-valued, so $a^(j)(x) frac(partial u, partial x_j)(x)$ is $E_(1,x)$-valued. Also, $v$ is a section of $E_1$; it is not a normal vector. The normal direction will enter later through the outward conormal $nu$ inside the principal symbol.

#paragraph-tab
Set
$
  rho(x):=sqrt(det(g(x))).
$
Then the contribution of $cal(O)$ to the $L^2$ inner product of $P_1 u$ with $v$ is
$
  integral_(cal(O)) chevron.l P_1 u, v chevron.r_(tilde(cal(g))) thin d V_g
  &= integral_(cal(O)) chevron.l P_1 u, v chevron.r_(tilde(cal(g))) thin sqrt(det(g)) thin d x
  \
  &= integral_(cal(O)) chevron.l sum^n_(j=1) a^(j)(x) frac(partial u, partial x_j)(x) + b(x) u, v chevron.r_(tilde(cal(g))) thin sqrt(det(g)) thin d x
  \
  &= integral_(cal(O)) (
    sum^n_(j=1) chevron.l  a^(j)(x) frac(partial u, partial x_j)(x), v chevron.r_(tilde(cal(g)))
    + chevron.l b(x) u, v chevron.r_(tilde(cal(g)))
  )
  thin rho(x) thin d x #dots_space #footnote[by linearity of the fiber inner product in the first slot]
$ #(s.tag)("global L2 inner product of P1u with v")

#paragraph-tab
We now compute $P_1^t$ explicitly from the general local formula. First, we distinguish the pointwise complex inner product from the global $L^2$ inner product.

#definition(title: "complex inner product induced by a real fiber metric")[
  Let $E arrow.r M$ be a real vector bundle with a positive-definite fiber metric $h$. At $x in M$, its complexified fiber is
  $
    E_x^bb(C) := E_x times.o_(bb(R)) bb(C).
  $
  The metric $cal(g)$ extends to a complex inner product
  $
    chevron.l dot comma dot chevron.r_(cal(g)):
    E_x^bb(C) times E_x^bb(C) arrow.r bb(C)
  $
  characterized by
  $
    chevron.l lambda w,z chevron.r_(cal(g))
    &= lambda chevron.l w,z chevron.r_(cal(g)),
    \
    chevron.l w,lambda z chevron.r_(cal(g))
    &= dash(lambda) chevron.l w,z chevron.r_(cal(g)),
    \
    chevron.l w,z chevron.r_(cal(g))
    &= dash(chevron.l z comma w chevron.r_(cal(g))),
    \
    chevron.l w,w chevron.r_(cal(g))&>0
    quad "when" quad w!=0,
    quad lambda in bb(C).
  $
  Thus it is linear in the first slot, conjugate-linear in the second slot, conjugate-symmetric, and positive-definite. If $(cal(g)_(a b))$ is the real matrix of $cal(g)_x$ in a local frame, then
  $
    chevron.l w,z chevron.r_(cal(g)_x)
    = cal(g)_(a b)(x) w^a dash(z)^b.
  $
]
The word "local" means that $x$ is fixed. This pointwise complex inner product is not yet an $L^2$ inner product, because no integration has been performed.

#paragraph-tab
For the two bundles in the present calculation, the preceding definition gives
$
  chevron.l w_1,w_2 chevron.r_(cal(g))
  &:= cal(g)_(gamma kappa)(x)
      w_1^gamma dash(w_2^kappa),
  quad w_1,w_2 in E_(0,x) times.o_(bb(R)) bb(C),
  \
  chevron.l z_1,z_2 chevron.r_(tilde(cal(g)))
  &:= tilde(cal(g))_(epsilon delta)(x)
      z_1^epsilon dash(z_2^delta),
  quad z_1,z_2 in E_(1,x) times.o_(bb(R)) bb(C).
$
The real bundle metrics $cal(g)$ and $tilde(cal(g))$ have been extended to the complexified bundles, so their local matrices remain real and symmetric.

#definition(title: "global L2 inner product of sections")[
  Let $E arrow.r M$ have the pointwise complex inner product induced by a fiber metric $h$. For sections $u_1,u_2$ whose squared norms are integrable, define
  $
    (u_1,u_2)_(L^2(E))
    := integral_M
      chevron.l u_1(x),u_2(x) chevron.r_(h_x)
      thin d V_g(x) #dots_space #footnote[This is similar to @L-2_norm_of_1-form.]
  $
  For $E_0$ and $E_1$, respectively, this becomes
  $
    (u_1,u_2)_(L^2(E_0))
    &:= integral_M cal(g)_(gamma kappa)
        u_1^gamma dash(u_2^kappa) thin d V_g,
    \
    (v_1,v_2)_(L^2(E_1))
    &:= integral_M tilde(cal(g))_(epsilon delta)
        v_1^epsilon dash(v_2^delta) thin d V_g.
  $
]
The term $L^2$ refers to this integrated inner product. The matrices $cal(g)$ and $tilde(cal(g))$ contract the fiber components pointwise, while $d V_g=rho thin d x$ performs the integration over $M$.

#paragraph-tab
#highlighted()[For a bundle map $q:E_0 arrow.r E_1$, write $q^dagger:E_1 arrow.r E_0$ for its pointwise adjoint.] It is defined so that $q$ can be moved from the first slot to the second slot:
$
  chevron.l q w,z chevron.r_(tilde(cal(g)))
  = chevron.l w,q^dagger z chevron.r_(cal(g))
  quad attach(w, tl: forall) in E_(0,x),
  attach(z, tl: forall) in E_(1,x).
$ #(s.tag)("definition-of-pointwise-fiber-adjoint")
For a smooth bundle map $q$, this pointwise identity also gives
$
  (q u,v)_(L^2(E_1))
  = (u,q^dagger v)_(L^2(E_0)),
$
because both sides are integrated against the same density $d V_g$. The density does not enter the algebraic formula for $q^dagger$; it becomes relevant later when derivatives are moved by integration by parts.

#pagebreak(weak: true)
#paragraph-tab
We now derive the component formula for $q^dagger$. Write $(q w)^epsilon=q^epsilon _gamma w^gamma$ and $(q^dagger z)^kappa=(q^dagger)^kappa _delta z^delta$. Expanding both sides of #(s.ref)("definition-of-pointwise-fiber-adjoint") gives:
#flowbox()[
  expand the left-hand side
  $
    chevron.l q w,z chevron.r_(tilde(cal(g)))
    = tilde(cal(g))_(epsilon delta)
      q^epsilon _gamma w^gamma dash(z^delta).
  $

  $arrow.b$

  expand the right-hand side
  $
    chevron.l w,q^dagger z chevron.r_(cal(g))
    &= cal(g)_(gamma kappa)w^gamma
      dash((q^dagger)^kappa _delta z^delta)
    \
    &= cal(g)_(gamma kappa)w^gamma
      markrect(
        dash((q^dagger)^kappa _delta),
        tag: #(s.tag)("adjoint-entry-conjugated"),
        color: #purple,
      )
      dash(z^delta).

    #annot((s.tag)("adjoint-entry-conjugated"), pos: bottom+right, dx: 0.7em)[everything in the second slot is conjugated]
  $

  $arrow.b$

  compare the coefficients of the arbitrary $w^gamma dash(z^delta)$
  $
    cal(g)_(gamma kappa)
    dash((q^dagger)^kappa _delta)
    = tilde(cal(g))_(epsilon delta) q^epsilon _gamma.
  $

  $arrow.b$

  conjugate both sides and use that the metric matrices are real
  $
    cal(g)_(gamma kappa) (q^dagger)^kappa _delta
    = tilde(cal(g))_(epsilon delta)
      markrect(
        dash(q^epsilon _gamma),
        tag: #(s.tag)("coefficient-conjugated"),
        color: #blue,
      ).

    #annot((s.tag)("coefficient-conjugated"), pos: bottom, dy: 0.5em)[after conjugation, the bar is on $q$]
  $
  #v(0.9em)
]
Finally, multiply by the inverse metric $cal(g)^(eta gamma)$ and use $cal(g)^(eta gamma)cal(g)_(gamma kappa)=delta^eta _kappa$:
$
  (q^dagger)^eta _delta
  = cal(g)^(eta gamma)
    tilde(cal(g))_(epsilon delta)
    dash(q^epsilon _gamma).
$ #(s.tag)("relationship between fiber adjoint and metric components")
This proves the component identity used below. In orthonormal frames for $E_0$ and $E_1$, both metric matrices are the identity, and the last formula reduces to $q^dagger=dash(q)^T$, the usual conjugate transpose. We sum over repeated fiber indices, while the coordinate index $j$ will always be summed explicitly.

#paragraph-tab
The calculation leading to #(s.ref)("process of computing the formal adjoint of P locally") left its sign and conjugation in $kappa_alpha$ and then suppressed that factor. With $rho=sqrt(det(g))$, the corrected, convention-complete formula for the complex $L^2$ inner product is
$
  (P^t v)^eta
  =
  frac(1, rho)
  markrect(cal(g)^(eta gamma), tag: #(s.tag)("P1-adjoint-inverse-metric"), color: #purple)
  sum_(|alpha| <= m)
  D^alpha (
    rho cal(g)_(gamma kappa)
    (p_alpha^dagger)^kappa _delta v^delta
  ).

  #annot((s.tag)("P1-adjoint-inverse-metric"), pos: top+right, dx: 1em, leader-connect: "elbow")[raises the $E_0$ index; without it, \
  $eta$ would not occur on the right]
$ #(s.tag)("precise-general-formal-adjoint-formula")
The factor $cal(g)^(eta gamma)$ is necessary unless the chosen frame of $E_0$ is orthonormal. Moreover,
$
  cal(g)_(gamma kappa)(p_alpha^dagger)^kappa _delta
  =
  tilde(cal(g))_(epsilon delta) dash((p_alpha)^epsilon _gamma),
$
by using #(s.ref)("relationship between fiber adjoint and metric components"), so this is the stated metric-coordinate formula with the coefficient adjoint made explicit.

#pagebreak(weak: true)
#paragraph-tab
Let $e_j=(0,dots.c,0,1,0,dots.c,0)$ be the $j$-th coordinate multi-index. Since $D_j=frac(1,i)partial_j$, we have $partial_j=i D_j$. Therefore the only multi-indices for $P_1$ are $0,e_1,dots.c,e_n$. The complete substitution is:
#flowbox()[
  coefficient identification
  $
    (P_1 u)^epsilon
    &= sum_(j=1)^n (a^(j))^epsilon _gamma partial_j u^gamma
      + b^epsilon _gamma u^gamma
    \
    &= sum_(j=1)^n
      markrect(i(a^(j))^epsilon _gamma, tag: #(s.tag)("P1-p-ej"), color: #blue)
      D_j u^gamma
      +
      markrect(b^epsilon _gamma, tag: #(s.tag)("P1-p-zero"), color: #olive)
      u^gamma.

    #annot(((s.tag)("P1-p-ej"), (s.tag)("P1-p-zero")), pos: bottom, dy: 0.7em, leader-connect: "elbow")[$p_(e_j)=i a^(j)$ and $p_0=b$]
  $

  $arrow.b$

  take the fiber adjoints
  $
    p_0^dagger &= b^dagger,
    \
    p_(e_j)^dagger
    &= (i a^(j))^dagger
    = markrect(-i(a^(j))^dagger, tag: #(s.tag)("P1-conjugate-i"), color: #purple).

    #annot((s.tag)("P1-conjugate-i"), pos: bottom+right, dx: 0.7em)[the adjoint conjugates the scalar $i$]
  $

  $arrow.b$

  simplify the $D$-operators
  $
    D^0 F &= F,
    \
    D_(j)(-i F)
    &= frac(1,i) partial_(j)(-i F)
    = markrect(-partial_(j) F, tag: #(s.tag)("P1-minus-from-D"), color: #red).

    #annot((s.tag)("P1-minus-from-D"), pos: bottom+right, dx: 0.7em)[this is the adjoint's minus sign]
  $

  $arrow.b$

  substitute into #(s.ref)("precise-general-formal-adjoint-formula")
  $
    (P_1^t v)^eta
    &= -frac(1,rho) cal(g)^(eta gamma)
      sum_(j=1)^n partial_j (
        rho cal(g)_(gamma kappa)
        ((a^(j))^dagger)^kappa _delta v^delta
      )
    \
    &quad + frac(1,rho) cal(g)^(eta gamma)
      rho cal(g)_(gamma kappa)
      (b^dagger)^kappa _delta v^delta.
  $
]

#paragraph-tab
Replacing the fiber adjoints by their metric components gives the requested explicit formula:
$
  (P_1^t v)^eta
  &= frac(1,rho) cal(g)^(eta gamma)
  [
    markrect(
      -sum_(j=1)^n partial_j (
        rho tilde(cal(g))_(epsilon delta)
        dash((a^(j))^epsilon _gamma) v^delta
      ),
      tag: #(s.tag)("P1-adjoint-divergence-part"),
      color: #blue,
    )
    \
    &quad +
    markrect(
      rho tilde(cal(g))_(epsilon delta)
      dash(b^epsilon _gamma) v^delta,
      tag: #(s.tag)("P1-adjoint-b-part"),
      color: #olive,
    )
  ].

  #annot((s.tag)("P1-adjoint-divergence-part"), pos: bottom+right, dx: 0.5em, dy: 0.7em)[the adjoint of the derivative terms]
  #annot((s.tag)("P1-adjoint-b-part"), pos: bottom+right, dx: 0.7em, dy: 0.7em)[the adjoint of the zero-order term]
$ #(s.tag)("P1-formal-adjoint-divergence-form")
If $a^(j)$ and $b$ are real, the conjugation bars may be omitted. Notice that only $eta$ is free in #(s.ref)("P1-formal-adjoint-divergence-form"); $gamma,epsilon,delta$ are summed.

#proposition(title:"general Green-Stokes formula")[
  If $M$ is a smooth, compact manifold with boundary and $P_1$ is a first-order differental operator(acting on sections of a vector bundle). Then
  :
  $
    (P_1 u , v)- (u, P_1^t v)= frac(1, i) integral_(partial M) chevron.l
      (
        sum_(j=1)^n a^(j) nu_j
      ),
      v
    chevron.r d S
  $
  where $nu$ is the outward unit normal vector to the boundary.
] <general_Green-Stokes_formula>

#proof[
  We first specify the notation needed to read the displayed boundary term rigorously. Each $a^(j)$ is a bundle map from $E_0$ to $E_1$, so the coefficient combination must act on $u$ before it can be put in the same fiber inner product as $v$. Thus the first entry in the boundary inner product is understood as
  $
    (
      sum_(j=1)^n a^(j) nu_j
    )u.
  $
  Moreover, the factor $frac(1,i)$ uses the $D$-operator convention introduced above. To keep the two coefficient conventions distinct during the proof, we use the following notation.
  $
    P_1 u
    &= sum_(j=1)^n a^(j) D_(j) u+b u,
    quad D_(j)=frac(1,i) partial_j,
    \
    a_D^(j)&:=frac(1,i) a^(j),
    quad
    P_1 u=sum_(j=1)^n a_D^(j) partial_(j) u+b u.
  $
  Thus $a^(j)$ is the coefficient of $D_(j)$, while $a_D^(j)$ is the coefficient of the ordinary derivative $partial_(j)$. In particular, $frac(1,i)a^(j)=a_D^(j)$, and the $a^(j)$ occurring in the proposition's boundary term is the $D_(j)$-coefficient.

  #paragraph-tab
  The formal adjoint $P_1^t$ is still the interior differential operator characterized by
  $
    (P_1 u,v)_(L^2(E_1))=(u,P_1^t v)_(L^2(E_0))
  $
  #highlighted()[for test sections supported in $op("int")(M)$.] The local expansion of the first inner product was fixed in #(s.ref)("global L2 inner product of P1u with v"). We now allow arbitrary $u in C^(infinity)(M,E_0)$ and $v in C^(infinity)(M,E_1)$ that are smooth up to $partial M$; integration by parts will then retain the boundary term.

  #paragraph-tab
  Put $rho=sqrt(det(g))$. Let $(a^(j))^dagger:E_1 arrow.r E_0$ and $b^dagger:E_1 arrow.r E_0$ be the pointwise adjoints defined in #(s.ref)("definition-of-pointwise-fiber-adjoint"). Specializing #(s.ref)("precise-general-formal-adjoint-formula") to the first-order operator above gives
  $
    P_1^t v=sum_(j=1)^n R_(j) v+b^dagger v,
  $
  where, in a local frame of $E_0$,
  $
    (R_(j) v)^eta
    :=frac(1,rho)cal(g)^(eta gamma)
      D_(j)(
        rho cal(g)_(gamma kappa)
        ((a^(j))^dagger)^kappa _delta v^delta
      ).
  $ #(s.tag)("green-stokes-adjoint-derivative-part")
  We next split the local integrand of the difference. We use the $D_j$-coefficient convention fixed at the beginning of this proof; the zero-order contribution in the first inner product is the one displayed in #(s.ref)("global L2 inner product of P1u with v"). Together with the expansion of $P_1^t v$ above, this gives
  $
    &chevron.l P_1 u,v chevron.r_(tilde(cal(g)))
    -chevron.l u,P_1^t v chevron.r_(cal(g))
    \
    &quad =
    sum_(j=1)^n
    (
      chevron.l a^(j)D_j u,v chevron.r_(tilde(cal(g)))
      -chevron.l u,R_(j) v chevron.r_(cal(g))
    )
    \
    &quad quad+
    (cancel(
      chevron.l b u comma v chevron.r_(tilde(cal(g)))
      -chevron.l u comma b^dagger v chevron.r_(cal(g)),
      stroke: #(paint: red)
    )).
  $ #(s.tag)("green-stokes-local-integrand-splitting")
  The last parenthesis in #(s.ref)("green-stokes-local-integrand-splitting") is zero at each point of $M$, because the pointwise adjoint definition #(s.ref)("definition-of-pointwise-fiber-adjoint") gives
  $
    chevron.l b u,v chevron.r_(tilde(cal(g)))
    -chevron.l u,b^dagger v chevron.r_(cal(g))
    =0.
  $ #(s.tag)("green-stokes-zero-order-cancellation")
  This is only the cancellation of the explicit zero-order part $b$ against $b^dagger$; the coefficient-derivative terms hidden in the operators $R_(j)$ are kept in the derivative part and will become the divergence below.

  #paragraph-tab
  It remains to compare one derivative term with $R_(j)$. Define the complex-valued coefficient
  $
    F^j
    :=chevron.l a^(j)u,v chevron.r_(tilde(cal(g)))
    =tilde(cal(g))_(epsilon delta)
      (a^(j))^epsilon _gamma
      u^gamma dash(v^delta).
  $ #(s.tag)("green-stokes-current-components")
  Since the metrics are real and
  $
    cal(g)_(gamma kappa)
    ((a^(j))^dagger)^kappa _delta
    =tilde(cal(g))_(epsilon delta)
      dash((a^(j))^epsilon _gamma), #dots_space #footnote[by using #(s.ref)("relationship between fiber adjoint and metric components")]
  $
  conjugating the expression differentiated in #(s.ref)("green-stokes-adjoint-derivative-part") yields
  $
    dash(
      rho cal(g)_(gamma kappa)
      ((a^(j))^dagger)^kappa _delta v^delta
    )
    =rho tilde(cal(g))_(epsilon delta)
      (a^(j))^epsilon _gamma dash(v^delta).
  $ #(s.tag)("green-stokes-conjugated-adjoint-coefficient")

  #paragraph-tab
  The convention $D_j=frac(1,i)partial_j$ also gives
  $
    dash(D_j f)
    =markrect(-D_j dash(f), tag: #(s.tag)("green-stokes-conjugate-D"), color: #purple)

    #annot((s.tag)("green-stokes-conjugate-D"), pos: right, dx: 0.6em)[conjugation changes the sign]
  $
  for every complex-valued $f$. Consequently, using #(s.ref)("green-stokes-conjugated-adjoint-coefficient"), we obtain the pointwise Green identity:
  #flowbox()[
    move the adjoint derivative into components and contract the fiber metrics
    $
      chevron.l u,R_(j) v chevron.r_(cal(g))
      &=cal(g)_(mu eta)u^mu dash((R_(j) v)^eta)
      \
      &=frac(1,rho)
      markrect(
        cal(g)_(mu eta)cal(g)^(eta gamma),
        tag: #(s.tag)("green-stokes-metric-cancellation"),
        color: #blue,
      )
      u^mu
      dash(
        D_(j)(
          rho cal(g)_(gamma kappa)
          ((a^(j))^dagger)^kappa _delta v^delta
        )
      )
      \
      &=frac(1,rho)delta_mu^gamma u^mu
      dash(
        D_(j)(
          rho cal(g)_(gamma kappa)
          ((a^(j))^dagger)^kappa _delta v^delta
        )
      )
      \
      &=-frac(1,rho)u^gamma D_(j)(
        rho tilde(cal(g))_(epsilon delta)
        (a^(j))^epsilon _gamma dash(v^delta)
      ).

      #annot((s.tag)("green-stokes-metric-cancellation"), pos: bottom+left, dx: -3em,leader-connect: "elbow")[metric contraction]
    $

    $arrow.b$

    subtract it from the corresponding term of $P_1 u$
    $
      &chevron.l a^(j)D_j u,v chevron.r_(tilde(cal(g)))
      -chevron.l u,R_j v chevron.r_(cal(g))
      \
      &quad=
      tilde(cal(g))_(epsilon delta)
      (a^(j))^epsilon _gamma
      (D_j u^gamma)dash(v^delta)
      \
      &quad quad+frac(1,rho)u^gamma D_(j)(
        rho tilde(cal(g))_(epsilon delta)
        (a^(j))^epsilon _gamma dash(v^delta)
      ).
    $

    $arrow.b$

    apply the product rule and use the definition of $F^j$; put
    $B_(j,gamma):=tilde(cal(g))_(epsilon delta)(a^(j))^epsilon _gamma dash(v^delta)$,
    so that $F^j=B_(j,gamma)u^gamma$
    $
      chevron.l a^(j)D_j u,v chevron.r_(tilde(cal(g)))
      -chevron.l u,R_j v chevron.r_(cal(g))
      &=B_(j,gamma)D_(j)u^gamma
      +frac(1,rho)u^gamma D_(j)(rho B_(j,gamma))
      \
      &=frac(1,rho)(
        rho B_(j,gamma)D_(j)u^gamma
        +u^gamma D_(j)(rho B_(j,gamma))
      )
      \
      &=frac(1,rho)D_(j)(rho B_(j,gamma)u^gamma)
      \
      &=markrect(
        frac(1,rho)D_(j)(rho F^j),
        tag: #(s.tag)("green-stokes-total-derivative"),
        color: #blue,
      )
      \
      &=frac(1,i rho)partial_(j)(rho F^j).

      #annot((s.tag)("green-stokes-total-derivative"), pos: right, dx: 1em, dy: -0.35em)[induced by product rule]
    $
  ]
  The minus sign in the first step is exactly the conjugation rule marked above; this is why no additional sign occurs when the formal-adjoint formula is written with $D_j$.

  #paragraph-tab
  Summing over $j$ in #(s.ref)("green-stokes-local-integrand-splitting") and using #(s.ref)("green-stokes-zero-order-cancellation") gives
  $
    chevron.l P_1 u,v chevron.r_(tilde(cal(g)))
    -chevron.l u,P_1^t v chevron.r_(cal(g))
    =frac(1,i rho)sum_(j=1)^n partial_(j)(rho F^j).
  $ #(s.tag)("green-stokes-pointwise-divergence")
  #highlighted()[Using the coefficients from #(s.ref)("green-stokes-current-components"), define the complex vector field $Z$ locally by]
  $
    Z=sum_(j=1)^n F^j partial_j.
  $ #(s.tag)("green-stokes-current-vector-field")
  The coefficient transformation law of the first-order part of $P_1$, together with the scalar nature of the fiber pairing, shows that these local expressions agree on overlapping charts; hence $Z$ is globally defined. Applying the coordinate formula for divergence from @formula_of_divergence to the real and imaginary parts of $Z$ gives
  $
    op("div")_g Z
    =frac(1,rho)sum_(j=1)^n partial_(j)(rho F^j).
  $ #(s.tag)("green-stokes-divergence-coordinate-formula")

  #paragraph-tab
  Combining #(s.ref)("green-stokes-pointwise-divergence") with #(s.ref)("green-stokes-divergence-coordinate-formula"), integrate over $M$ and apply the divergence theorem to the real and imaginary parts of $Z$ from #(s.ref)("green-stokes-current-vector-field"). If $nu$ is the outward unit normal vector and $nu_j=g_(j k)nu^k$ are the components of its metric-dual conormal, then
  $
    (P_1 u,v)_(L^2(E_1))-(u,P_1^t v)_(L^2(E_0))
    &=frac(1,i)integral_M op("div")_g Z thin d V_g
    \
    &=frac(1,i)integral_(partial M) g(Z,nu) thin d S #dots_space #footnote[by the divergence theorem]
    \
    &=frac(1,i)integral_(partial M)
      sum_(j=1)^n F^j nu_j thin d S #dots_space #footnote[$g$ is absobed into $nu_j$.]
    \
    &=frac(1,i)integral_(partial M)
      chevron.l
        (sum_(j=1)^n a^(j)nu_j)u,
        v
      chevron.r_(tilde(cal(g)))
      thin d S.
  $ #(s.tag)("green-stokes-integrated-boundary-identity")
  In the third equality of #(s.ref)("green-stokes-integrated-boundary-identity"), we used #(s.ref)("green-stokes-current-components") to rewrite $g(Z,nu)=sum_(j=1)^n F^j nu_j$. Hence #(s.ref)("green-stokes-integrated-boundary-identity") is exactly the proposition's displayed boundary identity under the type-correct interpretation fixed at the beginning of the proof. If the boundary term is instead written with the ordinary-derivative coefficient $a_D^(j)$, then $frac(1,i)a^(j)=a_D^(j)$ gives the equivalent form
  $
    (P_1 u,v)_(L^2(E_1))-(u,P_1^t v)_(L^2(E_0))
    =integral_(partial M)
      chevron.l
        (sum_(j=1)^n a_D^(j)nu_j)u,
        v
      chevron.r_(tilde(cal(g)))
      thin d S.
  $
  In particular, if $u$ and $v$ are compactly supported in $op("int")(M)$, the boundary integral vanishes and we recover the defining identity for the formal adjoint. Without compact support or a boundary condition that annihilates this boundary expression, the boundary term need not vanish.
]

#note(title: [intuition for proving @general_Green-Stokes_formula])[
  The main idea is just computing directly. Since we knew @formal_adjoint_of_differential_operator first, however, treating on the boundary is inevitable. Thus we can guessed that the powerful tool on the boundary, which is the divergence theorem, will be used. The noteworthy point is to construct the complex vector field $Z$ made from which is not vector field to induce divgergence.
]

#paragraph-tab
The following table organizes the three adjoint symbols used in this section: $t$, $*$, and $dagger$.

#figure(
  text(size: 8pt)[
    #table(
      columns: (0.8in, 1.25fr, 1.8fr, 1.3fr),
      align: horizon,
      inset: 3pt,
      [*Symbol*], [*Formal adjoint of*], [*Defining identity*], [*Meaning*],
      [$P^t$],
      [Formal adjoint of a differential operator
      $P:C^(infinity)(M,E_0) arrow.r C^(infinity)(M,E_1)$],
      [#(s.ref)("precise-general-formal-adjoint-formula")],
      [The most general formal adjoint notation here. It is global and uses integration by parts, the volume density, and the bundle metrics.],
      [$X^*$],
      [Formal adjoint of a vector field $X$, regarded as a first-order differential operator on scalar functions.],
      [$(X u,v)=(u,X^* v)$],
      [This is the same idea as $P^t$, but the star notation is conventional for vector fields. For scalar functions, $X^* v=-X v-(op("div")X)v$.],
      [$q^dagger$ or $a^dagger$],
      [Pointwise adjoint of a fiber map, or coefficient function,
      $q:E_(0,x) arrow.r E_(1,x)$],
      [$chevron.l q w,z chevron.r_(tilde(cal(g)))=chevron.l w,q^dagger z chevron.r_(cal(g))$],
      [This is algebraic at each fiber; no integration by parts is involved. Coefficients such as $a^(j)$, $b$, and $p_alpha$ use this notation.]
    )
  ],
  caption: [Summary of the symbols $t$, $*$, and $dagger$ for adjoints.]
) <formal_adjoint_symbols_table>

=== principal symbol

#paragraph-tab
The highest-order part of a differential operator is often useful. Define it as follows.
$
  sigma_P (x, xi)&:= p_m (x, xi) #dots_space #footnote[by using #(s.ref)("definition of principal symbol")]
  \
  (x, xi) & in T^* M
$

#lemma(title: "basic properties of the principal symbol")[
  Let $P$ be a differential operator of order at most $m$ satisfying @definition_of_general_differential_operator, with
  $
    P : C^(infinity)(M,E_0) arrow.r C^(infinity)(M,E_1)
  $
  Let $Q$ be a differential operator of order at most $ell$, with
  $
    Q: C^(infinity)(M,E_1) arrow.r C^(infinity)(M,E_2)
  $
  where $E_0,E_1,E_2$ are smooth vector bundles over $M$. Assume the Riemannian density and the bundle metrics used to define the formal adjoint in @formal_adjoint_of_differential_operator are fixed. For an operator $A$ of order at most $r$, let $sigma_(r)(A)$ denote its homogeneous degree-$r$ symbol. When $A$ has order exactly $r$, this is the principal symbol $sigma_A$. Then, for $(x,xi) in T^*M$,
  + $Q P$ has order at most $m+ell$, and
    $
      sigma_(m+ell)(Q P)(x,xi)
      = sigma_(ell)(Q)(x,xi) sigma_(m)(P)(x,xi).
    $
  + $P^t$ has order at most $m$, and
    $
      sigma_(m)(P^t)(x,xi)
      = (sigma_(m)(P)(x,xi))^dagger,
    $
    where $dagger$ is the pointwise fiber adjoint from @formal_adjoint_symbols_table.
] <properties_of_principal_symbol>
#proof[
  Work in local coordinates and local frames for the three bundles. Write
  $
    P &= sum_(|alpha| <= m) p_alpha (x)D^alpha,
    \
    Q &= sum_(|beta| <= ell) q_beta (x)D^beta.
  $
  Here $p_alpha (x):E_(0,x) arrow.r E_(1,x)$ and $q_beta (x):E_(1,x) arrow.r E_(2,x)$, so the order of the factors below is fixed by their fiber types.

  #paragraph_tab
  By the multi-index product rule,
  $
    D^(beta)(p_alpha D^alpha u)
    =
    bmark(
      p_alpha D^(alpha+beta)u,
      tag: #(s.tag)("principal-symbol-composition-leading"),
    )
    +
    pmark(
      R_(alpha,beta)u,
      tag: #(s.tag)("principal-symbol-composition-lower"),
    ).

    #annot(
      (s.tag)("principal-symbol-composition-leading"),
      pos: top,
      dy: -0.5em,
    )[no derivative from $D^beta$ hits $p_alpha$]
    #annot(
      (s.tag)("principal-symbol-composition-lower"),
      pos: bottom + right,
      dx: 0.4em,
      dy: 0.7em,
    )[derivative hits $p_alpha$ \
      $arrow.r$ lower order]
  $
  #v(2.2em)
  Every term in $R_(alpha,beta)$ contains at most $|alpha|+|beta|-1$ derivatives of $u$; if $beta=0$, this remainder is zero. #highlighted()[Hence $Q P$ has order at most $m+ell$.] Its degree-$(m+ell)$ terms occur only when $|alpha|=m$, $|beta|=ell$, and no derivative hits $p_alpha$. Therefore,
  $
    sigma_(m+ell)(Q P)(x,xi)
    &= sum_(|beta|=ell, |alpha|=m)
      q_beta (x)p_alpha (x)xi^(alpha+beta)
    \
    &= lr((sum_(|beta|=ell)q_beta (x)xi^beta))
       lr((sum_(|alpha|=m)p_alpha (x)xi^alpha))
    \
    &= sigma_(ell)(Q)(x,xi)sigma_(m)(P)(x,xi).
  $
  #highlight()[This proves the composition identity,] including the case in which the displayed degree-$(m+ell)$ symbol vanishes and the actual order of $Q P$ drops.

  #paragraph_tab
  For the adjoint, use the convention-complete local formula #(s.ref)("precise-general-formal-adjoint-formula"). With $rho=sqrt(det(g))$, its product-rule expansion contains
  $
    D^(alpha)(
      rho cal(g)_(gamma kappa)
      (p_alpha^dagger)^(kappa)_delta v^delta
    )
    &=
    markrect(
      rho cal(g)_(gamma kappa)
      (p_alpha^dagger)^(kappa)_delta D^alpha v^delta,
      tag: #(s.tag)("principal-symbol-adjoint-leading"),
      color: #blue,
    )
    +
    markuw(
      R_(alpha,gamma)^(t)(v),
      tag: #(s.tag)("principal-symbol-adjoint-lower"),
      color: #purple,
    ).

    #annot(
      (s.tag)("principal-symbol-adjoint-leading"),
      pos: top,
      dy: -0.6em,
    )[all $D^alpha$ derivatives hit $v$]
    #annot(
      (s.tag)("principal-symbol-adjoint-lower"),
      pos: bottom + right,
      dx: 0.4em,
      dy: 0.7em,
    )[derivative hits \
      $rho$, $cal(g)$, or $p_alpha^dagger$]
  $
  #v(3.2em)
  The remainder $R_(alpha,gamma)^t(v)$ contains at most $|alpha|-1$ derivatives of $v$. In the leading term, the prefactor in #(s.ref)("precise-general-formal-adjoint-formula") cancels the density and contracts the two $E_0$ metric factors:
  $
    frac(1,rho)cal(g)^(eta gamma)
    rho cal(g)_(gamma kappa)
    (p_alpha^dagger)^kappa _delta D^alpha v^delta
    = (p_alpha^dagger)^eta _delta D^alpha v^delta.
  $
  Thus the degree-$m$ coefficients of $P^t$ are $p_alpha^dagger$. The notation $lr((sum_(|alpha|=m)p_alpha (x)xi^alpha))^dagger$ means that we first form one fiber map
  $
    sum_(|alpha|=m)p_alpha (x)xi^alpha: E_(0,x) arrow.r E_(1,x),
  $
  and then take its pointwise fiber adjoint. The `lr((...))` is only Typst's scalable-parenthesis syntax; it does not introduce another operation. Since $xi in T_x^*M$ is a real covector, each component $xi^alpha$ is a real scalar, and therefore
  $
    (p_alpha (x)xi^alpha)^dagger
    = dash(xi^alpha) p_alpha (x)^dagger
    = xi^alpha p_alpha (x)^dagger.
  $
  Additivity of the fiber adjoint now gives the detailed symbol calculation:
  $
    sigma_(m)(P^t)(x,xi)
    &= sum_(|alpha|=m)p_alpha (x)^dagger xi^alpha
    \
    &= sum_(|alpha|=m)(p_alpha (x)xi^alpha)^dagger
    \
    &= lr((sum_(|alpha|=m)p_alpha (x)xi^alpha))^dagger
    \
    &= (sigma_(m)(P)(x,xi))^dagger.
  $
  No factor $(-1)^m$ appears because $D_j=frac(1,i)partial_j$ is formally self-adjoint at principal order; derivatives of the density and the metric contribute only lower-order terms.

]

#paragraph-tab
We often expand some functions defined on real vector spaces to complex vector spaces.
#definition(title: "Complexification of a real vector space")[
  Let $V$ be a real vector space. The complexification of $V$ is the complex vector space $V_(bb(C))$ consisting of all formal linear combinations $v + i w$ with $v, w in V$. 
  $
    V_(bb(C))&:= V times.o_(bb(R)) bb(C)
    \
    & arrow.r {v + i w : v, w in V} arrow.r (v times.o 1)+ (w times.o i)
    \
    V_(bb(C)) & approx.eq V plus.o V
  $
  
  Therefore, 
  $
    op("dim")_(bb(C)) V_(bb(C)) = op("dim")_(bb(R)) V.
  $
] <complexification>

#proposition(title: "principal symbol of divergence")[
  Consider the divergence operator acting on complex-valued vector fields :
  $
    op("div"): C^(infinity)(Omega, bb(C)^n) arrow.r C^(infinity)(Omega), quad Omega subset bb(R)^n
  $
  Then, its symbol is :
  $
    sigma_(op("div"))(x, xi) v = i chevron.l v, xi chevron.r, quad v in C^(infinity)(Omega, bb(C)^n), (x, xi) in T^* Omega
  $
  where @Definition_of_functional_evaluation is used.
] <principal_symbol_of_divergence>

#proof[
  Yet, $v$ cannot be components of a vector field in $frak(X)(Omega)$, becuase it doesn't satisfy the definition of vector field.#footnote[To be the vector field, $v : Omega arrow.r Omega times bb(R)^(n)$ where $T Omega approx.eq Omega times bb(R)^(n)$ by $T_x Omega approx.eq bb(R)^n$.] By using @complexification, we can regard $v$ as a complex vector field.
  $
    T Omega_(bb(C)) &= T Omega times.o_(bb(R)) bb(C) = (Omega times bb(R)^n) times.o_(bb(R)) bb(C)
    \
    & approx.eq Omega times bb(C)^n
  $
  Thus, we can define a vector field(or tensor field) : 
  $
     X:= sum_(j=1)^n v^j partial_j, quad X in Gamma(T Omega_(bb(C)))
  $
  
  #paragraph-tab
  Now, consider the divergence operator acting on $X$ :
  $
    op("div") X & = sum_j X_(;j)^j #dots_space #footnote[by @divergence_and_trace]
    \
    &= sum_j^n partial_j v^j + cancel(Gamma^(j)_(j d) v^j, stroke: #(paint: red)) #dots_space #footnote[because $Gamma^(j)_(j d)=0$ in the Euclidean(flat) space which is $Omega$.]
  $
  Since the principal symbol is came from the differential operator, let's construct the differential operator.
  #flowbox()[
    $
      D_j := frac(1, i) partial_j arrow.double.r partial_j = i D_j
    $

    $arrow.b$

    $
      op("div") X = sum_j^n partial_j partial^j = sum_j^n D_j v^j = i sum^n_j D_j v^j
    $
  ]
  Now take the principal part and replace each $D_j$ by $xi_j$.#footnote[We did at #(s.ref)("definition of principal symbol").]
  $
    sigma_("div")(x,xi) v &= i sum_j^n xi_j v^j
    \
    &= i chevron.l v comma xi chevron.r #dots_space #footnote[by the definition of @Definition_of_functional_evaluation.]
  $
]

#proposition(title: "principal symbol of gradient")[
  Consider the gradient operator acting on complex-valued functions :
  $
    op("grad"): C^(infinity)(Omega) arrow.r C^(infinity)(Omega, bb(C)^n), quad Omega subset bb(R)^n
  $
  Then its symbol is :
  $
    sigma_(op("grad"))(x, xi) = i  xi, quad (x, xi) in T^* Omega
  $
] <principal_symbol_of_gradient>

#proof[
  Since the complex-valued functions is given, $C^(infinity)(Omega)$ means the function space which $Omega mapsto CC$. Since we already know about the principal symbol of divergence, let's consider to use @relationship_between_divergence_and_gradient.#footnote[Consider divergence first is better. We know the divergence more than gradient. We even know the specific formula of divergence!] For $A(xi):= sigma_("grad")(x,xi): CC arrow.r CC^n$ and using @properties_of_principal_symbol, we have :
  $
    sigma_(op("grad")^*)(x, xi)= (A(xi))^*
  $ 
  Since $"grad"^*=-"div"$, we have :
  $
    (A(xi))^*&=sigma_(-"div")(x, xi)
    \
    &= -sigma_("div")(x, xi)
  $
  From @principal_symbol_of_divergence, 
  $
    sigma_("div")(x, xi)v &= i chevron.l v, xi chevron.r
    \
    (A(xi))^* v &= - i chevron.l v, xi chevron.r
  $
  To get $A(xi)$, use the definition of adjoint. For $z in CC$,
  $
    chevron.l A(xi) z, v chevron.r &= chevron.l z, (A(xi))^* v chevron.r 
    = chevron.l z, -i chevron.l v , xi chevron.r chevron.r
    \
    &= chevron.l z, -i xi(v) chevron.r
    \
    &= chevron.l (-i xi)^* z comma v chevron.r
    \
    &= chevron.l i xi z comma v chevron.r
  $
  Therefore,
  $
    A(xi)=i xi=sigma_("grad")(x,xi)
  $
]

#proposition(title: "principal symbol of Laplacian")[
  Consider the Laplacian operator acting on complex-valued functions :
  $
    Delta= op("grad") compose op("div"): C^(infinity)(Omega, bb(C)^n) arrow.r C^(infinity)(Omega, bb(C)^n), quad Omega subset bb(R)^n
  $
  Then its symbol is :
  $
    sigma_(Delta)(x, xi) = -xi chevron.l v, xi chevron.r, quad (x, xi) in T^* Omega
  $ 
]

#proof[
  The proposition is proved directly by applying @properties_of_principal_symbol with @principal_symbol_of_divergence and @principal_symbol_of_gradient.
]

])
