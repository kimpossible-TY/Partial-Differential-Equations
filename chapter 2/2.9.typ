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
$
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
where $m:= op("dim") M$. Heuristically, $xi$ is a covector version of $D$. In more detail, 
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
#highlighted[Since #(s.ref)("coordinate-free definition of principal symbol") guarantees that $p_m (x, xi)$ can be defined independently of the choice of local coordinates, #(s.ref)("principal symbol is a fiber map") is well-defined. ]

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
  $
  if $u$ and $v$ are smooth, compactly supported sections of $E_0$ and $E_1$.
] <formal_adjoint_of_differential_operator>
#note(title: "formal adjoint of vector field and differential operator")[
  Both $P^t$ and $X^*$ are the same concept. #highlighted[It is just that $X^*$ is a special case of $P^t$ when $P$ is a vector field.] Hence @formal_adjoint_of_vector_field and @formal_adjoint_of_differential_operator are related.
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
  markrect((p^t_beta)^eta _delta(x), tag: #(s.tag)("absorbed-coefficient"), color: #blue)
  &:=
  frac(1, sqrt(det(g))) cal(g)^(eta gamma)
  sum_(|alpha| <= m, beta <= alpha)
  a_(alpha,beta,gamma,delta)(x)
  \
  (P^t v)^eta
  &=
  sum_(|beta| <= m)
  markrect((p^t_beta)^eta _delta (x), tag: #(s.tag)("absorbed-coefficient-used"), color: #blue)
  D^beta v^delta,
  \
  P^t v(x)
  &=
  therefore sum_(|beta| <= m)
  p^t_beta (x) D^beta v(x)

  #annot(((s.tag)("metric-coeff-factor"), (s.tag)("v-factor")), pos: top+left, dx: -2em, dy: -0.4em, leader-connect: "elbow")[product rule]
  #annot(((s.tag)("product-rule-coefficient"), (s.tag)("absorbed-coefficient"), (s.tag)("absorbed-coefficient-used")), pos: bottom+right, dx: 2em, dy: 0.8em, leader-connect: "elbow")[absorbed into $p^t_beta$]
$
Here $a_(alpha,beta,gamma,delta)(x)$ is smooth and contains the derivatives of $A_(alpha,gamma,delta)$. Since $beta <= alpha$ implies $|beta| <= |alpha| <= m$, only derivatives $D^beta v$ of order at most $m$ appear.
Thus the formal adjoint $P^t$ is again a differential operator of order at most $m$.

#figure(
  text(size: 8.5pt)[
    #table(
      columns: (0.85in, 1.45fr, 1.15fr),
      align: horizon,
      inset: 3pt,
      [*Symbol*], [*Definition*], [*Role*],
      [$C_(alpha,gamma)$],
      [$tilde(cal(g))_(epsilon delta)(p_alpha)^epsilon _gamma v^delta sqrt(det(g))$],
      [Coefficient-$v$ factor before integration by parts.],
      [$B_gamma$],
      [$sum_(|alpha| <= m) D^alpha C_(alpha,gamma)$],
      [Coefficient of $u^gamma$ after integration by parts.],
      [$A_(alpha,gamma,delta)$],
      [$tilde(cal(g))_(epsilon delta)(p_alpha)^epsilon _gamma sqrt(det(g))$],
      [Part of $C_(alpha,gamma)$ not containing $v^delta$.],
      [$a_(alpha,beta,gamma,delta)$],
      [Product-rule coefficient in $D^alpha(A_(alpha,gamma,delta)v^delta)$],
      [Contains derivatives of $A_(alpha,gamma,delta)$.],
      [$(p^t_beta)^eta _delta$],
      [$frac(1,sqrt(det(g))) cal(g)^(eta gamma) sum_(|alpha| <= m, beta <= alpha) a_(alpha,beta,gamma,delta)$],
      [Absorbs coefficient factors multiplying $D^beta v^delta$.],
    )
  ],
  caption: [Temporary coefficients in the formal-adjoint calculation.]
) #(s.tag)("formal-adjoint-coefficient-table")

=== general Green-Stokes formula
#paragraph-tab
Now suppose $M$ is a compact, smooth manifold with smooth boundary. We want to obtain a generalization of @general_integral_version_of_the_product_rule_of_Riemmanian_divergence to induce the general Green-Stokes formula.
#lemma()[
  Let $M$ is a compact, smooth manifold with smooth boundary. For $X in frak(X)(M)$ , $u , v C^infinity (M)$ where $u$ and $v$ are real valued scalar functions, the following equation is true :
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
    &= integral_(partial M) chevron.l nu, X chevron.r u v d S #dots_space #footnote[by moving $u$ and $v$ out of the inner product]
    

    #annot((s.tag)("result of distirbution rule"), pos: bottom+left, dx: -4em, dy: 1em)[$X( u v)= (X u)v + u(X v)$]
  $
]

#paragraph-tab
Now, let $P_1$ be a general first-order differential operator acting on sections as in #(s.ref)("differential operator between section spaces"):
$
  P_1: C^infinity(M, E_0) arrow.r C^infinity(M, E_1).
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
Then the local $L^2$ pairing of $P_1 u$ with $v$ starts as follows:
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
$

#proposition(title: "general Green-Stokes formula")[
  Let $M$ be a compact smooth Riemannian manifold with smooth boundary, and let $E_0, E_1 arrow.r M$ be vector bundles with fiber metrics. If
  $
    P_1: C^infinity(M,E_0) arrow.r C^infinity(M,E_1)
  $
  is a first-order differential operator with principal symbol $sigma_(P_1)$, then for $u in C^infinity(M,E_0)$ and $v in C^infinity(M,E_1)$,
  $
    (P_1 u, v) - (u, P_1^t v)
    =
    frac(1,i) integral_(partial M)
    chevron.l sigma_(P_1)(x,nu) u, v chevron.r_(tilde(cal(g))) thin d S,
  $
  where $nu$ is the outward unit conormal covector on $partial M$. The section $v$ is a section of $E_1$, not a normal vector; the normal direction enters only through $nu$ inside the principal symbol.
]

#proof[
We prove the identity first in one boundary coordinate patch. For each derivative term, write
$
  I_j :=
  integral_(cal(O))
  chevron.l a^(j)(x) partial_j u, v chevron.r_(tilde(cal(g))) rho thin d x.
$
Let $(a^(j)(x))^*:E_(1,x) arrow.r E_(0,x)$ be the fiber adjoint, defined by
$
  chevron.l a^(j)(x) w, z chevron.r_(tilde(cal(g)))
  =
  chevron.l w, (a^(j)(x))^* z chevron.r_(cal(g))
$
for $w in E_(0,x)$ and $z in E_(1,x)$. Applying this with $w=partial_j u$ and $z=v$ gives
$
  chevron.l a^(j)(x) partial_j u, v chevron.r_(tilde(cal(g)))
  =
  chevron.l partial_j u, (a^(j)(x))^* v chevron.r_(cal(g)).
$

#paragraph-tab
Now use the product rule on the scalar density
$
  chevron.l u, (a^(j))^* v chevron.r_(cal(g)) rho.
$
There is a smooth expression $R_j(u,v)$, containing $u$, $v$, $partial_j v$, and derivatives of $a^(j)$, the fiber metrics, and $rho$, but containing no derivative of $u$, such that
$
  partial_j (
    chevron.l u, (a^(j))^* v chevron.r_(cal(g)) rho
  )
  =
  chevron.l partial_j u, (a^(j))^* v chevron.r_(cal(g)) rho
  + R_j(u,v) rho.
$
Therefore
$
  I_j
  =
  integral_(cal(O))
  partial_j (
    chevron.l u, (a^(j))^* v chevron.r_(cal(g)) rho
  ) thin d x
  -
  integral_(cal(O)) R_j(u,v) rho thin d x.
$
The second integral is an interior term. Since it is linear in $u$ and contains no derivative of $u$, it can be written as
$
  integral_(cal(O)) R_j(u,v) rho thin d x
  =
  integral_(cal(O)) chevron.l u, Q_j v chevron.r_(cal(g)) rho thin d x
$
for a locally defined first-order expression $Q_j v$. This is exactly where the derivatives of the coefficients, the bundle metrics, and the density are collected.

#paragraph-tab
The zero-order term is treated by the fiber adjoint $b^*$:
$
  integral_(cal(O)) chevron.l b u, v chevron.r_(tilde(cal(g))) rho thin d x
  =
  integral_(cal(O)) chevron.l u, b^* v chevron.r_(cal(g)) rho thin d x.
$
Thus the formal adjoint in this patch is the operator obtained by collecting all interior terms,
$
  P_1^t v = b^* v - sum^n_(j=1) Q_j v,
$
and after summing over $j$ we get
$
  integral_(cal(O)) chevron.l P_1 u, v chevron.r_(tilde(cal(g))) rho thin d x
  =
  integral_(cal(O)) chevron.l u, P_1^t v chevron.r_(cal(g)) rho thin d x
  +
  sum^n_(j=1)
  integral_(cal(O))
  partial_j (
    chevron.l u, (a^(j))^* v chevron.r_(cal(g)) rho
  ) thin d x.
$

#paragraph-tab
Now assume $cal(O) subset.eq bb(R)^n_+$, where $bb(R)^n_+={x_n >= 0}$, and that the boundary is locally $x_n=0$. We also assume $partial_n:=frac(partial, partial x_n)$ is the inward unit normal. For $j=1,dots,n-1$, the derivative $partial_j$ is tangential to the boundary. Because $u$ and $v$ are compactly supported inside the coordinate patch in the tangential directions, these tangential total-derivative terms give no boundary contribution.

#paragraph-tab
Only the $j=n$ term remains. For fixed $x'=(x_1,dots,x_(n-1))$, the fundamental theorem of calculus gives
$
  integral_0^infinity
  partial_n (
    chevron.l u, (a^(n))^* v chevron.r_(cal(g)) rho
  ) thin d x_n
  =
  - chevron.l u(x',0), (a^(n)(x',0))^* v(x',0) chevron.r_(cal(g)) rho(x',0)
  \
  =
  - chevron.l a^(n)(x',0) u(x',0), v(x',0) chevron.r_(tilde(cal(g))) rho(x',0).
$
The minus sign is important: the interval is $[0,infinity)$, and the boundary value is subtracted because the inward normal points in the positive $x_n$ direction.
Consequently,
$
  integral_(cal(O)) chevron.l P_1 u, v chevron.r_(tilde(cal(g))) rho thin d x
  &=
  integral_(cal(O)) chevron.l u, P_1^t v chevron.r_(cal(g)) rho thin d x
  \
  &quad -
  integral_(bb(R)^(n-1))
  chevron.l a^(n)(x',0) u(x',0), v(x',0) chevron.r_(tilde(cal(g))) rho(x',0) thin d x'.
$
Since $partial_n$ is unit normal and orthogonal to the boundary at $x_n=0$, the boundary density is $d S = rho(x',0) thin d x'$. Hence the local identity is
$
  (P_1 u, v)_(cal(O)) - (u, P_1^t v)_(cal(O))
  =
  -
  integral_(partial M inter cal(O))
  chevron.l a^(n)(x)u, v chevron.r_(tilde(cal(g))) thin d S.
$

#paragraph-tab
It remains to rewrite this boundary operator in intrinsic notation. Taylor's convention is
$
  D_j=frac(1,i) partial_j,
  quad
  partial_j=i D_j.
$
Therefore the first-order principal symbol of $P_1$ is
$
  sigma_(P_1)(x,xi)
  =
  i sum^n_(j=1) a^(j)(x) xi_j.
$
Because $partial_n$ is the inward unit normal, the outward conormal is $nu=-d x_n$. Thus
#flowbox()[
  $
    mark(nu, tag: #(s.tag)("gs-outward-conormal"), color: #purple)
    = -d x_n
    \
    sigma_(P_1)(x,nu)
    =
    markrect(-i a^(n)(x), tag: #(s.tag)("gs-symbol-normal"), color: #blue)
    \
    frac(1,i) sigma_(P_1)(x,nu)
    =
    markrect(-a^(n)(x), tag: #(s.tag)("gs-boundary-sign"), color: #red)

    #annot((s.tag)("gs-outward-conormal"), pos: top+left, dx: -1em)[normal direction enters here]
    #annot((s.tag)("gs-boundary-sign"), pos: bottom+right, dx: 1em)[same minus sign as the local boundary term]
  $
]
Here $sigma_(P_1)(x,nu)u$ is an element of $E_(1,x)$, so it is paired with $v(x) in E_(1,x)$. Again, $v$ is not the normal vector; the normal information is the outward conormal $nu$ inside the symbol.
Substituting $frac(1,i) sigma_(P_1)(x,nu)=-a^(n)(x)$ into the local boundary term gives
$
  (P_1 u, v)_(cal(O)) - (u, P_1^t v)_(cal(O))
  =
  frac(1,i)
  integral_(partial M inter cal(O))
  chevron.l sigma_(P_1)(x,nu)u, v chevron.r_(tilde(cal(g))) thin d S.
$

#paragraph-tab
Finally, this formula is invariant under changes of coordinates and local trivializations: the principal symbol is an intrinsic bundle map $E_(0,x) arrow.r E_(1,x)$, the fiber inner product is intrinsic, and $d S$ is the Riemannian boundary measure. Choose a partition of unity subordinate to interior and boundary coordinate patches. Interior patches contribute no boundary term, while the boundary patch contributions add because the partition of unity sums to $1$ on $partial M$. This gives the global Green-Stokes formula
$
  (P_1 u, v) - (u, P_1^t v)
  =
  frac(1,i)
  integral_(partial M)
  chevron.l sigma_(P_1)(x,nu)u, v chevron.r_(tilde(cal(g))) thin d S.
$
]
]) 
