#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.4.0": *

#local-scope-annotations(s=>[
  
== The Hodge Laplacian on $k$-forms

#paragraph-tab
If $M$ is an $n$-dimensional Riemannian manifold, recall the exterior derivative :
#definition(title: "exterior derivative")[
  We studied the exterior derivative in @Manifolds.
  $
    d : Omega^(k)(M) arrow.r Omega^(k+1)(M)
    \
    d^(2)=0
  $ <conditions_of_exterior_derivative>
  We denoted the vector space of smooth $k$-forms by
  $
    Omega^(k)(M):= Gamma(Lambda^k T^(*) M)
  $
] <definition_of_exterior_derivative>

To introduce formal adjoint of $d$, we have to define a metric first.
#definition(title: "the metric on k-forms")[
  Let $(M,g)$ be a Riemannain manfold. The metric on $k$-forms is a bundle metric on the vector bundle where $E_k := Lambda^(k)T^(*) M$.#footnote[@The_metric_on_k-forms is @definition_of_bundle_metric.] For each $x in M$, define 
  $
    mono(g) : Omega^(k)(M) times Omega^(k)(M) arrow.r RR
    \
    mono(g)^k : Lambda^(k)T^*_(x)M times Lambda^(k)T^*_(x)M arrow.r RR
  $
  For decomposable $k$-covectors,
  $
    alpha&:= alpha_1 and dots.c and alpha_k
    \
    beta&:= beta_1 dots.c and beta_k
    \
    mono(g)^(k)_(x)(alpha, beta)&:= op("det")(g^(-1)(alpha_(i) , beta_(j)))^(k)_(i,j=1)
    \
    &= sum_(pi) (op("sgn") pi) g(alpha_1, beta_(pi(1))) dots.c g(alpha_k, beta_(pi(k))) #dots_space #footnote[by the definition of determinant]
  $
  where $pi$ ranges over the set of permutations of ${1, dots.c k}$.
]<The_metric_on_k-forms>

Consequently, there is an $L^2$ inner product on $k$-forms :
$
  (u,v)&:= integral chevron.l u comma v chevron.r_(mono(g)) d V(x)
  \
  &= integral_M g^k_(x)(alpha_(x), beta_(x)) d V_g
$ <definition_of_L-2_norm_on_k-forms>

@definition_of_L-2_norm_on_k-forms gives the formal adjoint of $d$ :
#definition(title: "formal adjoint of exterior derivative")[
  Let $d$ is a exterior derivative satisfied @definition_of_exterior_derivative. Using @@definition_of_L-2_norm_on_k-forms, we can define :
  $
    delta: Omega^(k+1)(M) arrow.r Omega^(k)(M)
    \
    (d u, v)=(u, delta v), quad u in Omega^(k+1)(M), thin v in Omega^(k)(M)
  $
  where $u$ and $v$ are compactly supported.
]
We set $delta=0$ on 0-forms. Of course, @conditions_of_exterior_derivative implies :
$
  delta^2=0
$

#paragraph-tab
Now define a Hodge Laplacian on $k$-forms.
#definition(title: "Hodge Laplacian")[
  The Hodge Laplacian on $k$-forms is a map :
  $
    Delta_H : Omega^(k)(M) arrow.r Omega^(k)(M)
  $
  is defined by :
  $
    -Delta_H = (d + delta)^2 = d delta + delta d
  $ <detailed_definition_of_Hodge_Laplacian>
]<definition_of_Hodge_Laplacian>
How can we connect between the calssical Laplacian(@definition_of_Laplacian) and the Hodge Laplacian?
#flowbox()[
  $
    op("grad")^(*)=-op("div")
    \
    (d u , v)= (u, delta v)
    \
    d f arrow.l.r (d f)^sharp = op("grad") 
  $

  $arrow.b$

  $
    (d f)^* op("grad")^(*)f arrow delta f = - op("div")f
  $

  $arrow.b$

  $
    delta d f =-op("div")(op("grad") f)^flat #dots_space #footnote[Actually, @detailed_definition_of_Hodge_Laplacian implies #(s.ref)("Laplacian on 0-form"),  which is a special case where $delta =0$ on $Omega^(0)(M)$. Hence, we have $-Delta_H=delta d$ on 0-form.]
  $ #(s.tag)("Laplacian on 0-form")
]
If we define $- Delta_H := delta d$, 
$
  (delta d omega , omega)= (d omega , omega)=norm(omega)^2
$
which $delta omega$ vanishes!
Thus @detailed_definition_of_Hodge_Laplacian makes sense. By using @detailed_definition_of_Hodge_Laplacian, we have consequently :
$
  (-Delta u , v) = (d u , d v)+ (delta u, delta v), quad "for" u , v in C^(infinity)_(0) (M, Omega^(k)(M))
$


#paragraph-tab
$d$ can be interpreted to a first-order differential operator. In local coordinates, a $k$-form is 
$
  u=sum_(|I|=k) u_(I)(x)d x^I
$ #(s.tag)("example of that d is first-order differential operator")
Thus the exterior derivative of #(s.ref)("example of that d is first-order differential operator") is :
$
  d u = sum_(j, I) partial_j u_I d x^j and d x^(I)
$ #(s.tag)("the exterior derivative of example of that d is first-order differential operator")

#(s.ref)("the exterior derivative of example of that d is first-order differential operator") gives :
$
  d= sum_(j=1)^(n) ( d x^j and )partial_(j)
$ #(s.tag)("exterior derivative is a first-order differential operator")
#highlight()[which is the first-order differential operator.] Then we get the principal symbol of $d$ by using @coordinate-free_definition_of_principal_symbol.
#flowbox()[
  $
    d(u e^(i lambda psi))= i lambda e^(lambda psi) (d psi) and u + e^(lambda psi) d u #dots_space #footnote[by using proposition 14.23 of @Manifolds. Note that $e^(lambda psi)$ is 0-form.]
  $

  $arrow.b$

  $
    lim_(lambda arrow.r infinity) lambda^(-m) e^(i lambda psi) d (u e^(lambda psi)) = i (d psi) and u
  $

  $arrow.b$

  Use @coordinate-free_definition_of_principal_symbol.
  $
    p_(m) u (x)&= i (d psi) and u
    \
    &= i xi and u quad "where" xi := d psi
  $

  $arrow.b$

  $
    therefore sigma_(d)(x,xi)= i (xi and) 
  $ <principal_symbol_of_exterior_derivative>
]
Using @properties_of_principal_symbol, we have :
$
  sigma_(delta)(x,xi)=(sigma_(d)(x,xi))^t
$
Then, what is $sigma_(delta)(x,xi)$ exactly? To know $sigma_(delta)$ in more detail, we have to know :
$
  sigma_(delta)(x,xi)&=(sigma_(d)(x,xi))^t
  \
  &= (i xi and )^*
  \
  &= -i(xi and )^*
$ 
Since the formal adjoint is came from an inner product, consider :
#flowbox()[
  Let $alpha, I$ and $J$ are multi indeices, and $alpha$ appears in the $r$-th position of $J$.
  $
    chevron.l e^(alpha) and e^(I), e^(J) chevron.r_(mono(g))&=0, quad "where" alpha in I
    \
    chevron.l e^(alpha) and e^(I), e^(J) chevron.r_(mono(g)) &= markuw(chevron.l (-1)^(r-1) e^(I union {alpha}) comma e^(J) chevron.r_(mono(g)), tag:#(s.tag)("metric on k-forms orthogonal basis"), color: #purple), quad "where" alpha in.not I #dots_space #footnote[by proposition 14.11 of @Manifolds.]
    \
    \
    &= chevron.l (-1)^(r-1) e^(J) comma e^(J) chevron.r_(mono(g))
    \
    &= bmark((-1)^(r-1))

    #annot((s.tag)("metric on k-forms orthogonal basis"), pos: top+right, dx: 3em, dy:-1em)[is non-zero when $J=I union {alpha}$
    \
     by the definition of determinant.]
  $
  
  $arrow.b$

  Use the definition of interior multiplication to formulate $e^alpha$ in $e^J$.
  $
    iota_(e_(alpha)) e^(J) &= (-1)^(r-1)e^I, quad "where " e_(alpha)=(e^(alpha))^sharp #dots_space #footnote[by the definition of interior multiplication.], #footnote[The reason why the sharp operator appears is that the vector field isomorphic to $e^alpha$ is needed for using interior multiplication.]
    \
    bmark(chevron.l e^(I) comma iota_(e_(alpha)) e^(J) chevron.r_(mono(g)) &= (-1)^(r-1))
  $

  $arrow.b$

  $
    therefore chevron.l e^(alpha) and e^(I), e^(J) chevron.r_(mono(g))&=chevron.l e^(I) comma iota_(e_(alpha)) e^(J) chevron.r_(mono(g))
    \
    e^alpha and &= (iota_(e_(alpha)))^*
  $ <formal_adjoint_formula_on_metric_k-forms>
]
Thus $sigma_(d)(x, xi)$ is :
$
  sigma_(d)(x, xi) = -i thick iota_(xi^(sharp))
$ <principal_symbol_of_adjoint_of_exterior_derivative>
By @principal_symbol_of_adjoint_of_exterior_derivative and @principal_symbol_of_exterior_derivative, we have :
$
  -sigma_(Delta_H) (x,xi) u &= [sigma_(d) sigma_(delta) + sigma_(delta) sigma_(d)](x,xi) u #dots_space #footnote[By @properties_of_principal_symbol.]
  \
  &= iota_(xi^(sharp)) (xi and u) + xi and iota_(xi^(sharp)) u
$ <first_version_of_principal_symbol_of_Hodge_Laplacian>
More simple version of $sigma_(Delta_H)$ is :
#lemma(title: "principal symbol of Hodge Laplacian")[
 Let $(M, g)$ be a Riemannain manifold. For $k$-form u, the principal symbol of Hodge Laplacian is simplified as following.
 $
  sigma_(Delta_(H))(x, xi) u = - norm(xi)^(2)_(g) u , quad "where" xi in T^(*)_(x)M
 $
] <simplist_principal_symbol_of_Hodge_Laplacian>

#proof()[
  #highlighted()[Since $xi$ is 1-form covector], the result is directly proved by using @first_version_of_principal_symbol_of_Hodge_Laplacian.
  #flowbox()[
    Use a distibution rule of interior multplication to first term of RHS of @first_version_of_principal_symbol_of_Hodge_Laplacian.
    $
      iota_(xi^(sharp))(xi and u) &=  (iota_(xi^(sharp))xi) and u + (-1)^1(xi and iota_(xi^(sharp)) u) #dots_space #footnote[by using lemma 14.13 of @Manifolds.]
    $

    $arrow.b$

    $
      iota_(xi^(sharp)) (xi and u) + xi and iota_(xi^(sharp)) u &=
      (iota_(xi^(sharp))xi) and u
      \
      &= norm(xi)_(g)^(2) u #dots_space #footnote[$xi(xi^(sharp))=g(xi,xi)=norm(xi)_(g)^(2)$ which is already used at @perspective_represening_norm_to_interior_multplication.]
    $
  ]
]

Now, consider that the principal symbol is a coefficient of highest-order term of differental operator. Thus @simplist_principal_symbol_of_Hodge_Laplacian induces :
#flowbox()[
  $
    norm(xi)&=frac(partial_i u, partial x_i) #dots_space #footnote[It is exaclty the definition of $|xi|$ as considering @covector_version_of_D_in_differential_operator.]
    \
    norm(xi)^(2) &= markuw(partial_(i)partial_(j) u, tag: #(s.tag)("local result of principal symbol of Hodge Laplacian"),#olive)

    #annot((s.tag)("local result of principal symbol of Hodge Laplacian"), pos: bottom+right, dx: 2em)[second order derivative]
  $

  $arrow.b$

  For some sufficient first-order differential operator $Y$, the differential operator representation of Hodge Laplacian is :
  $
    Delta_(H) u = g^(i j) partial_(i) partial_(j) u + Y_(k) u 
  $
]


#paragraph-tab
Now, for $M$ a compact Riemannian manifold with boundary, we consider the Hodge Laplacian(@definition_of_Hodge_Laplacian). By using the general Green-Stokes formula(@general_Green-Stokes_formula),
#flowbox()[
  For the first-order differential operator $P_1$ and using @general_Green-Stokes_formula, 
  $
    (P_1 a  comma b)- (a comma P_(1)^(t)b) &= frac(1,i) integral_(partial M) chevron.l sigma_(p)(x, nu) a comma b chevron.r d S
    \
    (P_1 a  comma b) &=(a comma (P_1)^(t)b)+ frac(1,i) integral_(partial M) chevron.l sigma_(p)(x, nu) a comma b chevron.r d S
  $ #(s.tag)("applying general green-stokes formula to first order differential operator and using principal symbol")

  $arrow.b$

  - Put : $P_(1)=d, a=delta u$ and $b= v$ to #(s.ref)("applying general green-stokes formula to first order differential operator and using principal symbol").
  $
    (d delta u comma v)= (delta u comma delta v)+ frac(1,i) integral_(partial M) chevron.l sigma_(d)(x, nu) d u comma v chevron.r d S
  $#(s.tag)("first put to applying general green-stokes formula to first order differential operator and using principal symbol")

  - Put : $P_(1)=delta, a=d u$ and $b= v$ to #(s.ref)("applying general green-stokes formula to first order differential operator and using principal symbol").
  $
    (delta d u comma v)= (d u , d v )+ frac(1,i) integral_(partial M) chevron.l sigma_(delta)(x, nu)delta u , v chevron.r d S
  $ #(s.tag)("second put to applying general green-stokes formula to first order differential operator and using principal symbol")

  $arrow.b$

  compute $(delta d u, v)+ (d delta u , v)$ using #(s.ref)("first put to applying general green-stokes formula to first order differential operator and using principal symbol") and #(s.ref)("second put to applying general green-stokes formula to first order differential operator and using principal symbol"), to induce $(d u , d v)+(delta u , delta v)$
  $
    (delta d u, v)+ (d delta u , v) &= (d u , d v ) + frac(1,i) integral_(partial M) chevron.l sigma_(delta)(x, nu)d u , v chevron.r d S
    \
    &+ (delta u comma delta v)+ frac(1,i) integral_(partial M) chevron.l sigma_(d)(x, nu) delta u comma v chevron.r d S
    \
    &= (d u , d v ) + (delta u comma delta v) + integral_(partial M) [
      mark(chevron.l sigma_(delta)(x comma nu)d u comma v chevron.r, #olive)
      \
      &+
      mark(chevron.l sigma_(d)(x comma nu) delta u comma v chevron.r, #maroon)
    ] d S
    \
    &= (d u , d v ) + (delta u comma delta v) + integral_(partial M) [
      mark(chevron.l nu and (delta u ) comma v chevron.r,#olive)
      \
      &
      mark(-iota_(nu) (d u) comma v chevron.r, #maroon)
    ] thin d S #dots_space #footnote[by using @principal_symbol_of_adjoint_of_exterior_derivative and @principal_symbol_of_exterior_derivative]
  $
]
Therefore we get a general definition of Hodge Laplacian.
$
therefore -(Delta_(H) u comma v) &:= (d u , d v ) + (delta u comma delta v) + integral_(partial M) [
  chevron.l nu and (delta u ) comma v chevron.r
  \
  &
  -iota_(nu) (d u) comma v chevron.r] thin d S
$
])
