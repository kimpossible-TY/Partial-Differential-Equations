#import "../Styles/styles.typ": *
#import "../Styles/mannot_utils.typ": mannot-scope
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.4.0": *

#local-scope-annotations(s=> [
== Maxwell's equations

#paragraph-tab
The equations govering the electromagnetic field are on of the major triumphs of theretical physics. We list them here, for the eletric field $E$ and the magnetic field $B$, in a vacuum :
#definition(title: "Maxwell's equations")[
  $
    op("div") B = 0
  $ <Gauss_magnetism>
  $
    frac(partial B, partial t)+ op("curl") E =0
  $ <Faraday_law>
  $
    op("div") E = 4 pi rho
  $ <Gauss_electricity>
  $
    frac(partial E, partial t) - op("curl") B = -4 pi J
  $ <Ampere_Maxwell_law>
] <Maxwells_equations>
Here, $rho$ is the charge density and $J$ the eletric current. Units are chosen so that the speed of light is 1. The first quantitiative expression of this effect written down was :
#flowbox()[
    from @Ampere_Maxwell_law,
    $
        cancel(frac(partial E, partial t), stroke: #(paint: red)) - op("curl") B = -4 pi J
        \
        arrow.b
        \
        op("curl") B = 4 pi J
    $ #(s.tag)("time independent of Ampere maxwell law")
]
which is valid all quantities involved are independent of time. It breaks down when with time is allowed. Indeed, the LHS of #(s.ref)("time independent of Ampere maxwell law") must have vanishing divergence#footnote[becuase $op("div") compose op("curl")=0$], but in time-varying case on has, not just $op("div") J =0$, but rather the following :
#flowbox()[
    start from @Ampere_Maxwell_law.
    $
      partial_(t) E &- nabla times B = - 4 pi J
      \
      op("div") (partial_(t) E) &- cancel(op("div") compose op("curl") B, stroke: #(paint: red)) = -4 pi op("div") J
      \
      op("div") (partial_(t) E) &= - 4 pi op("div") J
      \
      &= partial_(t) "div" E #dots_space #footnote[$partial_(t) ("div"_(g) E)=partial_(t) [frac(1,sqrt("det" g)) sum partial_(x) (sqrt("det" g) E)]= frac(1,sqrt("det" g)) sum partial_(x) (sqrt("det"g ) partial_(t) E)$ where $partial_(t) sqrt("det" g)=0$.]
      \
      &= partial_(t) 4 pi rho quad #[by @Gauss_electricity]
    $

    $arrow.b$

    $
      partial_(t) 4 pi rho= partial_(t) 4 pi rho
      \
      therefore frac(partial rho, partial t) + op("div") J =0
    $ #(s.tag)("charge continuity equation")
]
=== Electromagnetic Field 2-form on Lorentz Manifold
#paragraph-tab
Now, we rewrite the Maxwell's equations on Lorentz manifold $cal(M)$. To define physics on Lorentz manifold, let $Gamma$ be a curve on $cal(M)$.
$
  Gamma : I arrow.r cal(M), quad lambda in I subset.eq RR
$
We control $Gamma$ using a parameter $lambda in I$. THus :
$
  op("Im") Gamma := {Gamma(lambda) : lambda in I} in cal(M)
$
and its tangent vector is :
$
  u(lambda):= dot(Gamma)(lambda)= frac(d Gamma, d lambda) in T_(Gamma(lambda)) cal(M)
$ #(s.tag)("velocity on curve")
#definition(title: "4-velocity")[
  For Lorentz manifold $cal(M)$, define a smooth curve $"Im" Gamma subset cal(M)$, $Gamma: I arrow.r cal(M)$ where $I subset.eq RR$. For $lambda in I$, we define a velocity on the curve u likely to #(s.ref)("velocity on curve") where $u$ is timelike.#footnote[The timelike assumption is suitable to physics. Since we will use the stress-energy tensor to energy and energy must be positive,  the velocity(tangent vector) must be timelike(future-directed) by @stress-energy_tensor_and_energy_flux_lemma.]
  $
    chevron.l u comma u chevron.r_(h) < 0
  $
]

#paragraph-tab
Now, we treat $lambda$ is the same as $t$. Then using $lambda in RR$ to control $Gamma$ and $u$ isn't nautral(physically understood), becuase we treat $RR^(4)$ Minkowski space. Thus we re-parameterize $Gamma$ and $u$ to an arc length.
$
  tau(lambda)-tau(lambda_(0)):= integral^(lambda)_(lambda_(0)) sqrt(
    - h (u comma u)
  ) d S
$
We want :
$
  tilde(Gamma)(tau)= Gamma(lambda(tau))
$
By the chain rule,
#flowbox()[
  $
    mark(frac(d Gamma, d tau), tag: #(s.tag)("tilde u"), color: #red)&= mark(frac(d Gamma, d lambda), #(s.tag)("u"), color: #blue) mark(
      frac(d lambda, d tau), #olive, tag: #(s.tag)("inverse of Lorentz factor")
    )
    \
    &= frac(d Gamma, d lambda)(1/sqrt(-h(u comma u))) #dots_space #footnote[By using #(s.ref)("velocity on curve")]

    #annot((s.tag)("tilde u"), pos: top+left, dx: -1em)[$tilde(u)$]
    #annot((s.tag)("u"), pos: top+right, dx: 1em)[$u$]
    #annot((s.tag)("inverse of Lorentz factor"), pos: right, dx: 1em)[Let $lambda = t$ and define it as $gamma$.
    \
    Then $gamma$ is treated as a linear transform \ which does re-parameterization.]
  $ #(s.tag)("appearane of Lorentz factor")

  $arrow.b$

  Assume $norm(tilde(u))=norm(u)$#footnote[The assumption is suitable to the goal that we want to just re-parameterize $u$, not change other properties.]
  $
    tilde(u)=u (1/sqrt(-h(u,u)))
  $
]
#definition(title: "Lorentz factor")[
  In #(s.ref)("appearane of Lorentz factor"), the Lorentz factor $gamma$ is :
  $
    gamma := frac(d lambda, d tau)
  $
  If replacing $gamma <--> t$, we get :
  $
    gamma&= frac(d t, d tau)
    \
    &=(1-|v|^(2))^(-1/2)
  $ <specific_version_of_Lorentz_factor>
  where $v$ is called "3-velocity". It is a traditional velocity,
  $
    v:= frac(d x_(s), d t), quad "where " x_(s) in M
  $
  Remember the Lorentz manifold is composed to $RR times M$, where $M$ is space smooth manifold and $RR$ represents timeline.
]

@specific_version_of_Lorentz_factor is induced by :
#flowbox()[
  $
    h= -d t^(2) + |d x|^(2)
    \
    d tau^(2)= d t^(2) - |d x|^(2)
    \
    (frac(d tau, d t))^(2)= 1- markuw((frac(|d x|, d t))^(2), #olive, tag: #(s.tag)("3-velocity inside of inducing gamma process"))

    #annot((s.tag)("3-velocity inside of inducing gamma process"))[
      $=|v|$
    ]
  $

  $arrow.b$

  $
    therefore frac(d t , d tau)&= 1/sqrt(1- |v|^(2))
    \
    &= gamma
  $
]


#paragraph-tab
#highlighted()[Since the classical physics treats $t$ as parameter, it is hard to integrate a 'time-based' physics theorems to the 'spacetime-based' new phsyics.]
#flowbox()[
  $
   Gamma&=(t(lambda), x(lambda))
   \
   u=frac(d Gamma, d tau)&=(
    frac(d t , d tau),
    frac(d Gamma, d tau)
   )
   \
   &= (
    frac(d t ,d tau),
    frac(d Gamma, d tau) frac(d t , d tau)
   )
  $ #(s.tag)("ordered pair convention")

  $arrow.b$

  $
    u = gamma(mark(1, tag: #(s.tag)("time component"), color: #olive),mark(v, tag: #(s.tag)("space component"), color: #maroon))

    #annot((s.tag)("time component"), pos: bottom+left, dy: 0.5em, dx: -1em)[time component]
    #annot((s.tag)("space component"), pos: top+right, dy: -0.5em)[space component]
  $ #(s.tag)("notation displaying time component and space component")
]
Thus, we will use #(s.ref)("notation displaying time component and space component") notation until sucessfully integrating the 'time-based' old-fashioned phsyics to 'spacetime-based' new physics.

#paragraph-tab
As following the notation used to #(s.ref)("notation displaying time component and space component"), The particle whose motion is to be described is assumed to have a constant "rest mass" $m_(0)$, and then the "4-momentum" is defined to be :
$
  p &:= m_(0) u
  \
  &= (
    m_(0) gamma,
    m_(0) mark(gamma v, color: #olive, tag: #(s.tag)("velocity on Lorentz manifold"))
  )

  #annot((s.tag)("velocity on Lorentz manifold"), pos: top+right, leader-connect: "elbow", dx : 1em, dy: -0.5em)[
    $frac(d x, d tau)$
  ]
$ <definition_of_4-momentum>
The replacement for Newton's equation $m_(0) (d v)/(d t) =f$ is :
$
  F&:= frac(d p , d tau)
  \
  &= (
    frac(d m , d tau),
    frac(d(m v), d tau)
  )
  = (
    frac(d m , d tau),
    gamma frac(d(m v), d t)
  ) #dots_space #footnote[By using #(s.ref)("notation displaying time component and space component") notation]
$
where defining $m$ by $m_(0) gamma$. F is called to "Minkowski 4-force".

#paragraph-tab
Now, we consider a electromagnetism.
#definition(title: "Lorentz force")[
let's $e$ is a charge, $E$ is eletric field, $B$ is magnetic field, and $v$ is "classical" 3-velocity. Define
  $
    f_(L) := e(E+v times B)
  $
  which satisfies :
  $
    f_(L) = frac(d p_(s), d t)
  $ #(s.tag)("second definition of Lorentz force")
  where $p_(s)$ is "classical" momentum, which is 3-momentum.
] <definitino_of_Lorentz_force>
The next task is to integrate $F$ with $f_(L)$. Thanks to #(s.ref)("second definition of Lorentz force"), the following equation is obvious :
$
  F&=(
    frac(d m , d tau),
    gamma f_(L)
  )
  \
  &= e (
    frac(d m , d tau),
    gamma E + u times B
  )
$

Now, let's try to replace $frac(d m , d tau)$ using $f_(c)$. By using 4-momentum,
#flowbox()[
  $
    h(p,p)&=-m_(0)^(2)
    \
    &=-m^(2) + (m v)^(2)
  $

  $arrow.b$

  $
    -2m frac(d m , d t )+ 2 m v frac(d (m v), d t)= 2 m_(0) cancel(frac(d m_(0), d t), stroke: #(paint: red)) #dots_space #footnote[the mass is constant by its definition.]
  $

  $arrow.b$

  $
    therefore frac(d m , d t)&= frac( p_(s) , m ) dot frac(d p_(s), d t )= v dot f_(L)
  $
]
therefore we get :
$
  F&= gamma(
    v dot f_(L),
    f_(L)
  )
  \
  &= e (
    E dot u,
    gamma E + u times B
  ) #dots_space #footnote[by using $v dot ( v times B)=0$.]
$ <eletromagnetric_field>
Since the Lorentz force(@definitino_of_Lorentz_force) contains electromagnetic force, it is understandable to say that $F$ is electromagnetic field on Minkowski space.

#paragraph-tab
Remember that we are trying to integrate the calssical physics which is 'time-based' to Lorentz manifold. Therefore we need to treat the electromagnetic field as a tensor. #highlight()[Of course we can represent some tensor as a 'matrix form' but it can't reveal 'mathematical structure' instead of a differential form.] To treat $F$ as tensor, we don't treat $x$ and $u$ just the input of $F$. To reveal the tensority of $F$ more easily, let :
$
  F(x,u)&= tilde(cal(F))(x) u
  \
  & "or"
  \
  &= tilde(cal(F))_(x) u
$
Then what is the type of tensor that $cal(tilde(F))$ should be? Since $F$ is linear to $u$ and $cal(tilde(F))$ is a map $T_(x)M |-> T_(x)M$, $cal(tilde(F))$ is (1,1)-tensor by @linear_endomorphism_is_tensor.


#paragraph-tab
We can easily get (0,2)-tensor by lowering index :
$
  cal(F) := h (tilde(cal(F)))
  \
  cal(F)(u, omega)= chevron.l u , tilde(cal(F)) omega chevron.r
$
#highlighted()[Howerver it isn't sufficient to say that $cal(F)$ is 2-form if $tilde(cal(F))$ is skew-symmetric isn't proved.] @orthogonality_and_skew-symmetry provides that the skew-symmetry is deeply related to orthogonality. Since $tilde(cal(F))$ is ovbiously not orthogonal,#footnote[If the orthogonality is satisfied, then $cal(F)$ is constantly zero.] consider that $F$ is orthogonal to $u$.
#lemma(title: "electromagnetic field is orthogonal to 4-velocity")[
  Let $F$ be the eletromagnetric field considering @eletromagnetric_field and $u$ is a 4-velocity. Then the following equation is true :
  $
    chevron.l F u , u chevron.r_(h) =0
  $
]

#proof[
The fact that $F$ is linear is easily proved. Hence @orthogonality_and_skew-symmetry proves the lemma.
]

Therefore, $cal(F)$ can be represented to 2-form.

#paragraph-tab
Fially, let's specify $cal(F)$ in more detail. First,
$
  tilde(cal(F)) u = e(E dot v, E u^(0) + v times B), quad "for" u=(u^(0), v)
$

The operator in the preceding equation still contains the charge $e$. To separate the electromagnetic field itself from the force on a particular particle, define the charge-independent operator $tilde(cal(F))_(0)$ by
$
  tilde(cal(F)) &= e tilde(cal(F))_(0),
  \
  tilde(cal(F))_(0)(u^(0), v) &:= (E dot v, E u^(0) + v times B).
$
Thus, lowering the operator $tilde(cal(F))$ appearing literally above gives $e cal(F)$. #highlighted[From now on, $cal(F)$ denotes the charge-independent tensor obtained by lowering one index of $tilde(cal(F))_(0)$]:
$
  cal(F)(u, w) := h(u comma tilde(cal(F))_(0) w).
$

#paragraph-tab
We now expand this $2$-form in the coordinate coframe $(d t, d x^(1), d x^(2), d x^(3))$. Let
$
  u=(u^(0), v), quad w=(w^(0), z),
$
where $v=(v^(1),v^(2),v^(3))$ and $z=(z^(1),z^(2),z^(3))$. Then
$
  tilde(cal(F))_(0) w=(E dot z, E w^(0)+z times B).
$
Since the Minkowski metric is
$
  h((a^(0),a) comma (b^(0),b))=-a^(0) b^(0)+a dot b,
$
lowering the index gives the following explicit bilinear expression:
$
  cal(F)(u,w)
  &=h((u^(0),v) comma (E dot z, E w^(0)+z times B))
  \
  &=-u^(0)(E dot z)+v dot (E w^(0)+z times B)
  \
  &=-u^(0)(E dot z)+w^(0)(E dot v)+v dot (z times B)
  \
  &=w^(0)(E dot v)-u^(0)(E dot z)+v dot (z times B).
$

#paragraph-tab
First, expand the electric part. For each $j=1,2,3$,
$
  (d x^(j) and d t)(u,w)
  &=d x^(j)(u)d t(w)-d x^(j)(w)d t(u)
  \
  &=v^(j) w^(0)-z^(j) u^(0).
$
It follows that
$
  sum_(j=1)^(3) E_(j)(d x^(j) and d t)(u,w)
  &=sum_(j=1)^(3) E_(j)(v^(j) w^(0)-z^(j) u^(0))
  \
  &=w^(0) sum_(j=1)^(3) E_(j) v^(j)-u^(0) sum_(j=1)^(3) E_(j) z^(j)
  \
  &=w^(0)(E dot v)-u^(0)(E dot z).
$
This is exactly the electric contribution to $cal(F)(u,w)$.

#paragraph-tab
Next, expand the magnetic scalar triple product component by component:
$
  v dot (z times B)
  &=v^(1)(z^(2) B_(3)-z^(3) B_(2))
  \
  &+v^(2)(z^(3) B_(1)-z^(1) B_(3))
  \
  &+v^(3)(z^(1) B_(2)-z^(2) B_(1))
  \
  &=B_(1)(v^(2) z^(3)-v^(3) z^(2))
  \
  &+B_(2)(v^(3) z^(1)-v^(1) z^(3))
  \
  &+B_(3)(v^(1) z^(2)-v^(2) z^(1)).
$
On the other hand, evaluating the spatial coordinate $2$-forms gives
$
  (d x^(2) and d x^(3))(u,w)&=v^(2) z^(3)-v^(3) z^(2),
  \
  (d x^(3) and d x^(1))(u,w)&=v^(3) z^(1)-v^(1) z^(3),
  \
  (d x^(1) and d x^(2))(u,w)&=v^(1) z^(2)-v^(2) z^(1).
$
Hence
$
  v dot (z times B)
  &=B_(1)(d x^(2) and d x^(3))(u,w)
  \
  &+B_(2)(d x^(3) and d x^(1))(u,w)
  \
  &+B_(3)(d x^(1) and d x^(2))(u,w).
$

#paragraph-tab
Combining the electric and magnetic contributions, we obtain the coordinate expression of the electromagnetic $2$-form:
$
  cal(F)
  &=sum_(j=1)^(3) E_(j) d x^(j) and d t
  +B_(1) d x^(2) and d x^(3)
  +B_(2) d x^(3) and d x^(1)
  +B_(3) d x^(1) and d x^(2).
$ #(s.tag)("coordinate expression of electromagnetic 2-form")

#paragraph-tab
To convert #(s.ref)("coordinate expression of electromagnetic 2-form") into a matrix, first fix the ordered coordinate coframe
$
  (d x^(0),d x^(1),d x^(2),d x^(3)):=(d t,d x^(1),d x^(2),d x^(3))
$
and its dual frame $(partial_(0),partial_(1),partial_(2),partial_(3))$, where $partial_(0)=partial_(t)$. The components of the $2$-form are defined by
$
  cal(F)_(mu nu):=cal(F)(partial_(mu),partial_(nu)).
$
Because $cal(F)$ is alternating,
$
  cal(F)_(mu nu)=-cal(F)_(nu mu), quad cal(F)_(mu mu)=0.
$
Therefore its coordinate expansion can be written as
$
  cal(F)=frac(1,2) sum_(mu=0)^(3) sum_(nu=0)^(3) cal(F)_(mu nu) d x^(mu) and d x^(nu).
$
The factor $1/2$ is necessary because the double sum contains both ordered pairs $(mu,nu)$ and $(nu,mu)$. Indeed, for $mu<nu$,
$
  &frac(1,2) [cal(F)_(mu nu)d x^(mu) and d x^(nu)
  +cal(F)_(nu mu)d x^(nu) and d x^(mu)]
  \
  &quad=frac(1,2) [cal(F)_(mu nu)d x^(mu) and d x^(nu)
  +(-cal(F)_(mu nu))(-d x^(mu) and d x^(nu))]
  \
  &quad=cal(F)_(mu nu)d x^(mu) and d x^(nu).
$

#paragraph-tab
We can now read off the electric entries. Since $d t=d x^(0)$,
$
  E_(j) d x^(j) and d t
  &=E_(j) d x^(j) and d x^(0)
  \
  &=-E_(j) d x^(0) and d x^(j).
$
Hence, for $j=1,2,3$,
$
  cal(F)_(j 0)=E_(j), quad cal(F)_(0 j)=-E_(j).
$
Similarly, the magnetic terms give
$
  cal(F)_(23)&=B_(1), &cal(F)_(32)&=-B_(1),
  \
  cal(F)_(31)&=B_(2), &cal(F)_(13)&=-B_(2),
  \
  cal(F)_(12)&=B_(3), &cal(F)_(21)&=-B_(3).
$
All diagonal entries are zero. Thus, relative to the ordered frame $(partial_(t),partial_(1),partial_(2),partial_(3))$, the covariant matrix of the electromagnetic $2$-form is
$
  [cal(F)]_((0,2))
  =mat(
    0,   -E_(1), -E_(2), -E_(3);
    E_(1),  0,    B_(3), -B_(2);
    E_(2), -B_(3),  0,    B_(1);
    E_(3),  B_(2), -B_(1),  0
  ).
$ #(s.tag)("covariant matrix of electromagnetic 2-form")
The matrix is skew-symmetric, as expected:
$
  [cal(F)]_((0,2))^(T)=-[cal(F)]_((0,2)).
$

#paragraph-tab
To verify the signs directly, write the coordinate columns of $u=(u^(0),v)$ and $w=(w^(0),z)$ as
$
  [u]=mat(u^(0);v^(1);v^(2);v^(3)), quad
  [w]=mat(w^(0);z^(1);z^(2);z^(3)).
$
Then the matrix in #(s.ref)("covariant matrix of electromagnetic 2-form") satisfies
$
  cal(F)(u,w)
  &=[u]^(T) [cal(F)]_((0,2)) [w]
  \
  &=w^(0)(E dot v)-u^(0)(E dot z)+v dot (z times B),
$
which is exactly the bilinear expression obtained by lowering the index.

#paragraph-tab
It is important to distinguish the matrix of the $(0,2)$-tensor $cal(F)$ from the matrix of the $(1,1)$-tensor $tilde(cal(F))_(0)$. Let
$
  eta:=[h]=mat(
    -1,0,0,0;
     0,1,0,0;
     0,0,1,0;
     0,0,0,1
  ).
$
If $A:=[tilde(cal(F))_(0)]_((1,1))$, then the definition
$
  cal(F)(u,w)=h(u comma tilde(cal(F))_(0) w)
$
becomes, in matrix notation,
$
  [u]^(T) [cal(F)]_((0,2)) [w]=[u]^(T) eta A[w].
$
Since this is true for all $u$ and $w$,
$
  [cal(F)]_((0,2))=eta A.
$
Moreover, $eta^(-1)=eta$, so raising the first index gives
$
  A
  &=eta^(-1)[cal(F)]_((0,2))
  \
  &=eta[cal(F)]_((0,2))
  \
  &=mat(
    0,    E_(1),  E_(2),  E_(3);
    E_(1),  0,    B_(3), -B_(2);
    E_(2), -B_(3),  0,    B_(1);
    E_(3),  B_(2), -B_(1),  0
  ).
$ #(s.tag)("mixed matrix of electromagnetic operator")
Indeed,
$
  A[w]
  =mat(
    E_(1) z^(1)+E_(2) z^(2)+E_(3) z^(3);
    E_(1) w^(0)+B_(3) z^(2)-B_(2) z^(3);
    E_(2) w^(0)-B_(3) z^(1)+B_(1) z^(3);
    E_(3) w^(0)+B_(2) z^(1)-B_(1) z^(2)
  ),
$
which is the coordinate column of
$
  tilde(cal(F))_(0) w=(E dot z,E w^(0)+z times B).
$
The mixed matrix $A$ is not skew-symmetric in the ordinary Euclidean sense. Instead, it is skew-adjoint with respect to the Minkowski metric:
$
  A^(T) eta+eta A=0.
$
Finally, the charge-dependent Lorentz-force operator appearing earlier has matrix $e A$.

=== Invariant Maxwell's Equations

#paragraph-tab
Now, we integrate $F$ with the Maxwell's equations(@Maxwells_equations). First we will show why $d cal(F)=0$ is equivalent to @Gauss_magnetism and @Faraday_law. To compute the differential of $cal(F)$ more easiler, let's split it :
$
  cal(F)&= cal(F)_(E)+ cal(F)_(B)
  \
  cal(F)_(E) &= sum_(j) E_(j) d x^(j) and d t
  \
  cal(F)_(B) &= sum_(j) B_(j) hat(d x^(j)) #dots_space #footnote[where $hat(d x^(j)):= d x^(k) and d x^(l)$, for $(j,k,l) in {(1,2,3),(2,3,1),(3,1,2)}$.]
$
In fact, we can represent $cal(F)$ more simplest form using the volume form and Riemannian metric. The 2-form $cal(F)_(B)$ is contracted to :
$
  iota_(B) op("Vol")_(3) &=
  B_(1) iota_(partial_(1)) (d x^(1) and d x^(2) and d x^(3))
  +B_(2) iota_(partial_(2)) (d x^(1) and d x^(2) and d x^(3))
  \
  & +B_(3) iota_(partial_(3)) (d x^(1) and d x^(2) and d x^(3)), quad "where" B=B_(j)partial_(j)
  \
  &= cal(F)_(B)
$
IF we introduce Riemannian metric on Euclidean space, $cal(F)_(E)$ can be represented as:
$
  cal(F)_(E) = E^(flat) and d t, quad "where" E^(flat) = E_(j) d x^(j)
  \
  E=E_(j) partial_(j), quad dash(g)= (dx^(j))^(2)
$

#paragraph-tab
Now, compute $d cal(F)_(E)$ and $d cal(F)_(B)$. Firstly, we compute $d cal(F)_(E)$. By the definition of exterior derivative, the following equation is easily driven :
$
  d cal(F)_(E)= sum_(j) d E_(j) and d x^(j) and d t
$
becuase $E_(j)= E_(j)(t, x)$,
$
  d E_(j)= partial_(t) E_(j) d t + sum_(k) partial_(k) E_(j) d x^(k)
$
Thus
$
  d E_(j) and d x^(j) and d t&=
  cancel(partial_(t) E_(j) d t and d x^(j) and d t, stroke: #(paint: red)), quad "because" d t and d t=0
  \
  &+ sum_(k) partial_(k) E_(j) d x^(k) and d x^(j) and d t
  \
  &= sum_(j,k) partial_(k) E_(j) d x^(k) and d x^(j) and d t, quad "because" d x^(j) and d x^(j)=0
$
The coefficient of $d x^(2) and d x^(3) and d t$ comes from two terms :
$
  d x^(2) and d x^(3) and d t &=
  partial_(2) E_(2) d x^(2) and d x^(3) and d t
  \
  & + partial_(3) E_(2) d x^(3) and d x^(2) and d t
  \
  &= (partial_(2) E_(2)- partial_(3) E_(2)) d x^(2) and d x^(3) and d t #dots_space #footnote[becuase $d x^(3) and d x^(2) =- d x^(2) and d x^(3)$.]
  \
  &= (nabla times E)_(1) d x^(2) and d x^(3) and d t #dots_space #footnote[where $(nabla times E)_(1)= partial_(2) E_(3)- partial_(3) E_(2)$]
$
The other two coefficients are obtained similarly :
$
  (nabla times E)_(2)&:= partial_(3) E_(1)- partial_(1) E_(3)
  \
  (nabla times E)_(3)&:= partial_(1) E_(2)- partial_(2) E_(1)
$
Thus
$
  therefore d cal(F)_(E) = (nabla times E)_(j) thin hat(d x^(j)) and d t
$

Now calculate the magnetric part. By the linearlity of exterior derivative, we have :
#flowbox()[
  $
    d cal(F)_(B) &= d(B_(1) d x^(2) and d x^(3) + B_(2) d x^(3) and d x^(1) + B_(3) d x^(1) and d x^(2))
    \
    &= d B_(1) and d x^(2) and d x^(3) + d B_(2) and d x^(3) and d x^(1) + d B_(3) and d x^(1) and d x^(2)
  $

  $arrow.b$

  Expading $d B_(1)$.
  $
    d B_(1)&= partial_(t) B_(1) d t + sum_(k) partial_(k) B_(1) d x^(k)
    \
    d B_(1) and d x^(2) and d x^(3) &= partial_(t) B_(1) d t and d x^(2) and d x^(3)
    \
    & + partial_(1) B_(1) d x^(1) and d x^(2) and d x^(3)
    \
    &+ cancel(partial_(2) B_(1) d x^(2) and d x^(2) and d x^(3))
    \
    &+ cancel(partial_(3) B_(1) d x^(3) and d x^(2) and d x^(3))
  $ #(s.tag)("expanding d B_1")

  $arrow.b$

  similaly to #(s.ref)("expanding d B_1") :
  $
    d B_(2) and d x^(3) and d x^(1) &= partial_(t) B_(2) d t and d x^(3) and d x^(1) + partial_(2) B_(2) d x^(2) and d x^(3) and d x^(1)
    \
    d B_(3) and d x^(1) and d x^(2) &= partial_(t) B_(3) d t and d x^(1) and d x^(2) + partial_(3) B_(3) d x^(3) and d x^(1) and d x^(2)
  $

  $arrow.b$

  combine them and use $op("div") B= partial_(i) B_(i)$
  $
    therefore d cal(F)_(B) = (partial_(t) B_(j)) d t and hat(d x^(j)) + (op("div") B) d x^(1) and d x^(2) and d x^(3)
  $
]
Consquently, we have :
$
  therefore d cal(F) &= overbrace((nabla times E)_(j) thin hat(d x^(j)) and d t, cal(F)_(E))
  \
  &+
  underbrace((partial_(t) B_(j)) d t and hat(d x^(j)) + (op("div") B) d x^(1) and d x^(2) and d x^(3), cal(F)_(B))
  \
  &=
  mark((nabla times E+ partial_(t) B), #olive, tag: #(s.tag)("insert Faraday_law")) d t and hat(d x^(j)) + mark(op("div") B, #maroon, tag: #(s.tag)("insert Gauss_magnetism")) thin d x^(1) and d x^(2) and d x^(3) #dots_space #footnote[where $d t and hat(d x^(j))=hat(d x^(j)) and d t$. the two minus sgin appear and cancel each other.]

  #annot((s.tag)("insert Faraday_law"), pos: top+left, dx: -1.5em, leader-connect: "elbow")[
    @Faraday_law
  ]
  #annot((s.tag)("insert Gauss_magnetism"), pos: bottom+right, dx: 1em, leader-connect: "elbow")[
    @Gauss_magnetism
  ]
$ #(s.tag)("differential of electromagnetic 2-form")
Thus if we assume $d cal(F)=0$, then we get @Faraday_law and @Gauss_magnetism. Conversely, if we introduce @Faraday_law and @Gauss_magnetism, then we get $d cal(F)=0$. In addition, we can know the following equation from #(s.ref)("differential of electromagnetic 2-form") :
$
  d : Omega^(2)(cal(M)) arrow.r Omega^(3)(cal(M)), quad d cal(F) in Omega^(3)(cal(M))
$

#paragraph-tab
Second, we combine @Gauss_electricity and @Ampere_Maxwell_law into a single equation. Assume that @Faraday_law and @Gauss_magnetism have already been encoded by $d cal(F)=0$. The remaining equations suggest computing
$
  d_(h)^(*) cal(F), quad d_(h)^(*) : Omega^(2)(cal(M)) arrow.r Omega^(1)(cal(M)),
$
where $d_(h)^(*)$ is the formal adjoint of the exterior derivative with respect to the Minkowski metric $h$. It plays the same role as the Riemannian codifferential $delta$ in @formal_adjoint_of_exterior_derivative. To determine $d_(h)^(*) cal(F)$, we compute the pairing of $d alpha$ with $cal(F)$ for a compactly supported test $1$-form
$
  alpha in Omega^(1), quad alpha &= a_(0) d t + sum_(j=1)^(3) a_(j) d x^(j)
  \
  &= a_(0) d t + a^(flat), quad a=(a_(1),a_(2),a_(3)),
  \
  d alpha &= sum^(3)_(j=1) (partial_(j)a_(0)- partial_(t)a_(j)) d x^(j) and d t
  \
  &+ underbrace(sum_(1 <= j < k <= 3) (partial_(j) a_(k)- partial_(k) a_(j)) d x^(j) and d x^(k), d_(x) a^(flat))
  \
  &= (nabla a_(0)-partial_(t) a)^(flat) and d t+d_(x) a^(flat).
$ #(s.tag)("differential of test 1-form")

#paragraph-tab
Before we pair $alpha$ with $cal(F)$, we have to specify the inner product on $Omega^(2)(cal(M))$.
#definition(title: "Lorentzian pairing on 2-forms")[
  Let $(cal(M),h)$ be a Lorentz manifold and fix $p in cal(M)$. The inverse metric gives a pairing on covectors,
  $
    h_(p)^(-1):T_(p)^(*) cal(M) times T_(p)^(*) cal(M) arrow.r RR.
  $
  We abbreviate $h_(p)^(-1)(alpha,gamma)$ by $chevron.l alpha,gamma chevron.r_(h)$. For decomposable $2$-covectors, define
  $
    chevron.l alpha and beta, gamma and delta chevron.r_(h,2)
    &:= chevron.l alpha, gamma chevron.r_(h) chevron.l beta, delta chevron.r_(h)
    - chevron.l alpha, delta chevron.r_(h) chevron.l beta, gamma chevron.r_(h)
    \
    &= op("det") mat(
      chevron.l alpha, gamma chevron.r_(h), chevron.l alpha, delta chevron.r_(h);
      chevron.l beta, gamma chevron.r_(h), chevron.l beta, delta chevron.r_(h)
    ).
  $
  Extending this rule bilinearly defines a non-degenerate symmetric pairing on $Lambda^(2) T_(p)^(*) cal(M)$ and hence a smooth bundle metric on $Lambda^(2) T^(*) cal(M)$.
] #(s.tag)("inner product on 2-form with Lorentz metric")

#paragraph-tab
How can we understand #(s.ref)("inner product on 2-form with Lorentz metric") naturally?
#proposition(title: "Quotient factorization of an alternating bilinear map")[
  Let $V$ be a vector space over $bb(F)$, and let
  $
    omega:V times V arrow.r bb(F)
  $
  be alternating and bilinear. Then there exists a unique linear map
  $
    tilde(omega):Lambda^(2) V arrow.r bb(F)
  $
  such that
  $
    tilde(omega)(X and Y)=omega(X,Y)
  $
  for all $X,Y in V$. Equivalently, regarding the wedge product as the bilinear map
  $
    and:V times V arrow.r Lambda^(2) V,
    quad
    (X,Y) mapsto X and Y,
  $
  the assertion is
  $
    omega=tilde(omega) compose and.
  $
] #(s.tag)("alternating map factors through exterior square")

#proof[
Define
$
  S:=op("span"){X times.o X:X in V},
  quad
  Lambda^(2) V:=frac(V times.o V,S).
$
Let $pi$ be the canonical quotient homomorphism:
$
  pi:V times.o V arrow.r Lambda^(2) V,
  quad
  pi(T):=[T]=T+S.
$
The wedge product on the exterior algebra gives the following by its definition :
$
  and:Lambda^(p) V times Lambda^(r) V arrow.r Lambda^(p+r) V.
$
When $p=r=1$, since $Lambda^(1) V=V$, this restriction is
$
  and:V times V arrow.r Lambda^(2) V,
  quad
  (X,Y) mapsto X and Y.
$
We denote this restricted map by $q$:
$
  q:V times V arrow.r Lambda^(2) V,
  quad
  q(X,Y):=X and Y:=pi(X times.o Y).
$ #(s.tag)("exterior square homomorphism")
Thus $q$ denotes the map, while $X and Y=q(X,Y)$ denotes its value at $(X,Y)$.
Equivalently,
$
  q=pi compose times.o
$
because the canonical tensor-product map is
$
  times.o:V times V arrow.r V times.o V,
  quad
  (X,Y) mapsto X times.o Y.
$
Its image is the set of pure tensors ${X times.o Y:X,Y in V}$, whose linear span is $V times.o V$.

#paragraph_tab
By the universal property of the tensor product, the bilinear map $omega$ induces a unique linear map
$
  hat(omega):V times.o V arrow.r bb(F),
  quad
  omega=hat(omega) compose times.o.
$
Since $omega$ is alternating, its linearization $hat(omega)$ annihilates every generator $X times.o X$ of $S$. Since $ker pi=S$, this gives the kernel inclusion
$
  ker pi=S subset.eq ker hat(omega).
$
By the quotient-factorization form of the first isomorphism theorem, there exists a unique linear map
$
  tilde(omega):Lambda^(2) V arrow.r bb(F)
$
such that
$
  hat(omega)=tilde(omega) compose pi.
$ #(s.tag)("tensor functional quotient factorization")
#figure(
  first-isomorphism-factorization-diagram(),
  caption: [First-isomorphism factorization of $hat(omega)$ through $pi$.],
)
Thus both the existence and uniqueness of $tilde(omega)$ follow from the first isomorphism theorem. In particular,
$
  tilde(omega)([T])=hat(omega)(T).
$
Since $omega=hat(omega) compose times.o$ and $q=pi compose times.o$,
$
  omega
  =hat(omega) compose times.o
  =tilde(omega) compose pi compose times.o
  =tilde(omega) compose q
  =tilde(omega) compose and.
$
Equivalently, for every $X,Y in V$,
$
  tilde(omega)(X and Y)=omega(X,Y).
$ #(s.tag)("two form evaluation on bivector")
]

#paragraph-tab
#definition(title: "Sharp operator on 2-forms")[
  Let $V$ be a finite-dimensional real vector space, and let
  $
    h:V times V arrow.r RR
  $
  be a non-degenerate symmetric bilinear form. First define the flat map and its inverse by
  $
    flat_(h):V arrow.r V^(*),
    quad
    flat_(h)(X):=h(X,dot),
    quad
    sharp_(h):=flat_(h)^(-1):V^(*) arrow.r V.
  $
  Equivalently, $alpha^(sharp_(h)):=sharp_(h)(alpha)$ is the unique vector satisfying
  $
    h(alpha^(sharp_(h)),X)=alpha(X)
  $
  for every $X in V$.

  The sharp operator induced by $h$ on $2$-forms is the exterior square of $sharp_(h)$:
  $
    sharp_(h,2):=Lambda^(2)(sharp_(h)):Lambda^(2) V^(*) arrow.r Lambda^(2) V.
  $
  It is determined on decomposable $2$-forms by
  $
    sharp_(h,2)(alpha and beta)
    =alpha^(sharp_(h)) and beta^(sharp_(h)),
    quad
    alpha,beta in V^(*).
  $
  For $V=T_(p) cal(M)$ and $h=h_(p)$, this defines the pointwise sharp operator
  $
    sharp_(h,2):Lambda^(2) T_(p)^(*) cal(M) arrow.r Lambda^(2) T_(p) cal(M).
  $
] #(s.tag)("sharp operator on 2-forms")

#paragraph-tab
To apply #(s.ref)("alternating map factors through exterior square") explicitly, set $V=T_(p) cal(M)$ and fix $gamma,delta in V^(*)$. Define the alternating bilinear map
$
  omega_(gamma,delta):V times V arrow.r RR,
  quad
  omega_(gamma,delta)(X,Y)
  :=gamma(X) delta(Y)-gamma(Y) delta(X).
$
The proposition gives a unique linear functional
$
  tilde(omega)_(gamma,delta):Lambda^(2) V arrow.r RR
$
satisfying
$
  tilde(omega)_(gamma,delta)(X and Y)
  =omega_(gamma,delta)(X,Y).
$
Under the canonical identification of alternating bilinear maps with linear functionals on $Lambda^(2) V$, we suppress the tilde and write
$
  gamma and delta=tilde(omega)_(gamma,delta).
$

#paragraph-tab
For $eta,omega in Lambda^(2) T_(p)^(*) cal(M)$, write
$
  eta^(sharp_(h,2)):=sharp_(h,2)(eta) in Lambda^(2) T_(p) cal(M).
$
The Lorentzian pairing on $2$-forms is equivalently
$
  chevron.l eta,omega chevron.r_(h,2)
  =omega(eta^(sharp_(h,2))).
$
If $eta=eta_(1) and eta_(2)$ is decomposable, then
$
  eta^(sharp_(h,2))=eta_(1)^(sharp_(h)) and eta_(2)^(sharp_(h)).
$
Indeed, for $alpha,beta,gamma,delta in T_(p)^(*) cal(M)$, #(s.ref)("sharp operator on 2-forms") is used in the second equality below, and #(s.ref)("alternating map factors through exterior square") is used in the third.
#mannot-scope(
  m => [
    #v(1.5em)
    $
      chevron.l alpha and beta,gamma and delta chevron.r_(h,2)
      &= (gamma and delta)(sharp_(h,2)(alpha and beta)) \
      &= mark(
        gamma and delta,
        tag: #(m.tag)("induced functional"),
        color: #olive,
      )(
        mark(
          alpha^(sharp_(h)) and beta^(sharp_(h)),
          tag: #(m.tag)("simple bivector"),
          color: #maroon,
        )
      ) \
      &=omega_(gamma,delta)(alpha^(sharp_(h)),beta^(sharp_(h))) \
      &=gamma(alpha^(sharp_(h))) delta(beta^(sharp_(h)))
        -gamma(beta^(sharp_(h))) delta(alpha^(sharp_(h))) \
      &=chevron.l alpha,gamma chevron.r_(h) chevron.l beta,delta chevron.r_(h)
        -chevron.l alpha,delta chevron.r_(h) chevron.l beta,gamma chevron.r_(h)
      \
      &= op("det")mat(
        chevron.l alpha,gamma chevron.r_(h), chevron.l alpha,delta chevron.r_(h);
        chevron.l beta,gamma chevron.r_(h), chevron.l beta,delta chevron.r_(h)
      ).

      #annot(
        (m.tag)("induced functional"),
        pos: top + left,
        leader-connect: "elbow",
        dx: -0.5em,
        dy: 1.5em,
      )[$tilde(omega)_(gamma,delta)$]
      #annot(
        (m.tag)("simple bivector"),
        pos: right,
        leader-connect: "elbow",
        dx: 0.5em,
        dy: 1.5em,
      )[$X and Y$]
    $
    #v(1em)
  ],
  prefix: "chapter-2-11-two-form-factorization",
)
That is #(s.ref)("inner product on 2-form with Lorentz metric"). It satisfies :
$
  chevron.l d t,d t chevron.r_(h)&=-1,
  &chevron.l d x^(j),d x^(k) chevron.r_(h)&=delta_(j k),
  &chevron.l d t,d x^(j) chevron.r_(h)&=0.
$
Using #(s.ref)("inner product on 2-form with Lorentz metric"), we therefore obtain
$
  chevron.l d x^(j) and d t,d x^(k) and d t chevron.r_(h,2)&=-delta_(j k),
  \
  chevron.l d x^(j) and d x^(k),d x^(j) and d x^(k) chevron.r_(h,2)&=1
  quad "for" j != k.
$
#lemma(title: "Orthogonality of mixed and spatial basis forms")[
  For every $j,k,l in {1,2,3}$,
  $
    chevron.l d x^(j) and d t,d x^(k) and d x^(l) chevron.r_(h,2)=0.
  $
  Hence the subspace spanned by the mixed forms $d x^(j) and d t$ is orthogonal to the subspace of purely spatial $2$-forms.
] #(s.tag)("orthogonality of mixed and spatial basis forms")

#proof[
By the determinant formula in #(s.ref)("inner product on 2-form with Lorentz metric"),
$
  chevron.l d x^(j) and d t,d x^(k) and d x^(l) chevron.r_(h,2)
  &=chevron.l d x^(j),d x^(k) chevron.r_(h)
    chevron.l d t,d x^(l) chevron.r_(h)
  \
  &quad-chevron.l d x^(j),d x^(l) chevron.r_(h)
    chevron.l d t,d x^(k) chevron.r_(h)
  \
  &=delta_(j k) dot 0-delta_(j l) dot 0
  \
  &=0,
$
because $d t$ is orthogonal to every spatial covector $d x^(m)$. Bilinearity then proves the statement for the two spanned subspaces.
]

#paragraph-tab
Now, come back to consider the pairing with $alpha$ and $cal(F)$.
#definition(title: "Global Lorentzian L-2 Pairing")[
  Recall the global Riemannian $L^(2)$ pairing introduced in @L-2_norm_of_1-form. Let $(cal(M),h)$ be an oriented Lorentzian manifold, and let $eta,omega in Omega_(c)^(k)(cal(M))$ be compactly supported $k$-forms. The global Lorentzian $L^(2)$ pairing is defined by
  $
    L_(h)(eta,omega)
    :=integral_(cal(M)) chevron.l eta,omega chevron.r_(h,k) d V_(h).
  $
  In the standard Minkowski spacetime $cal(M)=RR^(1+3)$, the Lorentzian volume form $d V_(h)$ is given in local coordinates by the determinant of $h$,#footnote[In local coordinates, $d V_(h)=sqrt(abs(det(h_(mu nu)))) d x^(0) d x^(1) d x^(2) d x^(3)$. For the signature $(-,+,+,+)$, this is equivalently $sqrt(-det(h_(mu nu))) d x^(0) d x^(1) d x^(2) d x^(3)$. For the standard Minkowski metric, $det(h_(mu nu))=-1$, so $d V_(h)=d t d x^(1) d x^(2) d x^(3)$.] so the pairing becomes
  $
    L_(h)(eta,omega)
    :=integral_(RR^(1+3))
    chevron.l eta,omega chevron.r_(h,k) d t d x^(1) d x^(2) d x^(3).
  $
] <global_L-2_Lorentzian_pairing>
When $eta$ and $omega$ are $2$-forms, the pointwise pairing in this formula means $chevron.l dot, dot chevron.r_(h,2)$. The formal adjoint $d_(h)^(*)$ is characterized by
$
  L_(h) (d alpha,beta)=L_(h) (alpha,d_(h)^(*) beta),
  quad
  alpha in Omega^(k-1),
  quad
  beta in Omega^(k).
$ #(s.tag)("Lorentzian formal adjoint of exterior derivative")
Although $L_(h)$ is not positive definite, its pointwise pairing is non-degenerate. Hence #(s.ref)("Lorentzian formal adjoint of exterior derivative") still determines $d_(h)^(*) beta$ uniquely. Compact support removes every boundary term in the integration by parts below.

#paragraph-tab
#mannot-scope(
  m => [
Return to the decomposition $cal(F)=cal(F)_(E)+cal(F)_(B)$ and the test form $alpha$ in #(s.ref)("differential of test 1-form"). Their mixed and purely spatial parts are
$
  d alpha
  &=mark(
    sum_(j=1)^(3)(partial_(j) a_(0)-partial_(t) a_(j))
      d x^(j) and d t,
    tag: #(m.tag)("mixed test part"),
    color: #olive,
  )
  +mark(
    d_(x) a^(flat),
    tag: #(m.tag)("spatial test part"),
    color: #maroon,
  ),
  \
  cal(F)
  &=mark(
    sum_(j=1)^(3) E_(j) d x^(j) and d t,
    tag: #(m.tag)("electric mixed part"),
    color: #olive,
  )
  +mark(
    sum_(j=1)^(3) B_(j) hat(d x^(j)),
    tag: #(m.tag)("magnetic spatial part"),
    color: #maroon,
  ).

  #annot(
    (m.tag)("mixed test part"),
    pos: top+left,
    dx: -0.25em,
    leader-connect: "elbow",
  )[mixed part of $d alpha$]
  #annot(
    (m.tag)("spatial test part"),
    pos: top+right,
    dx: 0.25em,
    leader-connect: "elbow",
  )[spatial part of $d alpha$]
$
The orthogonality lemma(#(s.ref)("orthogonality of mixed and spatial basis forms")) shows that the two cross-pairings vanish:
$
  chevron.l d_(x) a^(flat),cal(F)_(E) chevron.r_(h,2)
  &=mark(0, tag: #(m.tag)("first vanishing cross pairing"), color: #purple),
  \
  chevron.l
    sum_(j=1)^(3)(partial_(j) a_(0)-partial_(t) a_(j))d x^(j) and d t,
    cal(F)_(B)
  chevron.r_(h,2)
  &=mark(0, tag: #(m.tag)("second vanishing cross pairing"), color: #purple).

  #annot(
    (
      (m.tag)("first vanishing cross pairing"),
      (m.tag)("second vanishing cross pairing"),
    ),
    pos: right,
    dx: 0.75em,
    leader-connect: "elbow",
  )[mixed $perp$ spatial]
$
Thus, the electric contribution is :
$
  chevron.l d alpha,cal(F)_(E) chevron.r_(h,2)
  &=mark(
    -sum_(j=1)^(3)(partial_(j) a_(0)-partial_(t) a_(j))E_(j),
    tag: #(m.tag)("electric contraction sign"),
    color: #red,
  )
  \
  &=-nabla a_(0) dot E+partial_(t) a dot E,

  #annot(
    (m.tag)("electric contraction sign"),
    pos: top+right,
    dx: 0.5em,
  )[Lorentzian sign]
$ #(s.tag)("electric contribution to Lorentzian pairing")
where the minus sign is the contribution of the single timelike covector $d t$. For the spatial contribution, the definition of curl gives
$
  d_(x) a^(flat)
  =sum_(j=1)^(3)
  mark(
    (nabla times a)_(j),
    tag: #(m.tag)("curl coefficient"),
    color: #blue,
  )
  mark(
    hat(d x^(j)),
    tag: #(m.tag)("spatial two form basis"),
    color: #maroon,
  ).

  #annot(
    (m.tag)("curl coefficient"),
    pos: top+left,
    dx: 1em,
    dy: -1em,
  )[curl components]
  #annot(
    (m.tag)("spatial two form basis"),
    pos: bottom+right,
    dx: 0.5em,
  )[oriented spatial basis]
$
Moreover, the spatial basis $2$-forms are orthonormal:
$
  chevron.l hat(d x^(j)),hat(d x^(k)) chevron.r_(h,2)
  =mark(delta_(j k), tag: #(m.tag)("positive spatial norm"), color: #blue).

  #annot(
    (m.tag)("positive spatial norm"),
    pos: right,
    dx: 0.75em,
  )[purely spatial $arrow.r +1$]
$
Consequently,
$
  chevron.l d alpha,cal(F)_(B) chevron.r_(h,2)
  &=chevron.l d_(x) a^(flat),cal(F)_(B) chevron.r_(h,2)
  \
  &=mark(
    (nabla times a) dot B,
    tag: #(m.tag)("magnetic coefficient contraction"),
    color: #purple,
  ).

  #annot(
    (m.tag)("magnetic coefficient contraction"),
    pos: bottom+right,
    dx: 0.5em,
  )[coefficient-wise contraction]
$ #(s.tag)("magnetic contribution to Lorentzian pairing")
Combining #(s.ref)("electric contribution to Lorentzian pairing") and #(s.ref)("magnetic contribution to Lorentzian pairing") gives
$
  chevron.l d alpha,cal(F) chevron.r_(h,2)
  =mark(
    -nabla a_(0) dot E,
    tag: #(m.tag)("electric gradient term"),
    color: #red,
  )
  +mark(
    partial_(t) a dot E,
    tag: #(m.tag)("electric time term"),
    color: #olive,
  )
  +mark(
    (nabla times a) dot B,
    tag: #(m.tag)("magnetic curl term"),
    color: #blue,
  ).

  #annot(
    (m.tag)("electric gradient term"),
    pos: bottom+left,
    dx: -0.5em,
  )[electric gradient]
  #annot(
    (m.tag)("electric time term"),
    pos: top,
  )[electric time term]
  #annot(
    (m.tag)("magnetic curl term"),
    pos: bottom+right,
    dx: 0.5em,
  )[magnetic curl]
$ #(s.tag)("pairing test one-form with electromagnetic field")
  ],
  parent: s,
  name: "maxwell-pairing-components",
)

#paragraph-tab
To identify $d_(h)^(*) cal(F)$ from its defining pairing, we have to compute :
$
  integral_(M) -nabla a_(0) dot E + partial_t a dot.c E + (nabla times a) dot.c B thick d V_h
$

First, let's compute :
$
  integral_(M) -nabla a_(0) dot E d V_h
$ #(s.tag)("first integration equation of second Maxwell's invariant form")

For each fixed $t$, let $Sigma_(t):={t} times RR^(3)$. Since
$
  h=-d t^2+delta,
$
the restriction of the Minkowski metric to the tangent bundle of $Sigma_(t)$ is
$
  h|_(T Sigma_(t))=delta.
$
Thus the Euclidean metric used on each spatial slice is induced by the Minkowski metric. The operators $nabla$, $op("div")$, and $nabla times$ below act only on the spatial variables and are defined using this induced metric $delta$. First fix $t$. Apply @adjoint_relationship_between_divergence_and_gradient on $(RR^(3),delta)$ with $X=E(t,dot)$ and $u=a_(0)(t,dot)$:
$
  integral_(RR^(3)) E dot.c nabla a_(0) d^(3) x
  =-integral_(RR^(3)) a_(0) op("div")E d^(3) x.
$
Multiplying by $-1$ and integrating this identity in $t$ gives
$
  integral_(RR^(1+3)) -nabla a_(0) dot.c E d^(4) x
  =integral_(RR^(1+3)) a_(0) op("div")E d^(4) x.
$

#paragraph-tab
For the second computation,
$
  integral_(M) partial_t a dot.c E d V_h
$
fix $x$ and integrate by parts componentwise in the time variable:
$
  integral_RR partial_(t) a dot.c E d t
  &=(a dot.c E)|_(t=-infinity)^(t=infinity)
  -integral_RR a dot.c partial_(t)E d t
  \
  &=-integral_RR a dot.c partial_(t)E d t.
$
The boundary term vanishes because the test form $alpha$, and hence $a$, is compactly supported. Integrating the resulting identity over $RR^(3)$ gives
$
  integral_(RR^(1+3)) partial_(t) a dot.c E d^(4) x
  =-integral_(RR^(1+3)) a dot.c partial_(t)E d^(4) x.
$

#lemma(title: "Divergence of a cross product")[
  Let $a=(a_(1),a_(2),a_(3))$ and $B=(B_(1),B_(2),B_(3))$ be smooth vector fields on $(RR^(3),delta)$. Then
  $
    op("div")(a times B)
    =B dot.c (nabla times a)-a dot.c (nabla times B).
  $
] #(s.tag)("divergence of a cross product")

#proof[
By the coordinate definitions of the cross product and divergence,
$
  op("div")(a times B)
  &=partial_(1)(a_(2)B_(3)-a_(3)B_(2))
  \
  &quad+partial_(2)(a_(3)B_(1)-a_(1)B_(3))
  \
  &quad+partial_(3)(a_(1)B_(2)-a_(2)B_(1)).
$
Applying the product rule and grouping first the derivatives of $a$ and then those of $B$ gives
$
  op("div")(a times B)
  &=B_(1)(partial_(2)a_(3)-partial_(3)a_(2))
  \
  &quad+B_(2)(partial_(3)a_(1)-partial_(1)a_(3))
  \
  &quad+B_(3)(partial_(1)a_(2)-partial_(2)a_(1))
  \
  &quad-a_(1)(partial_(2)B_(3)-partial_(3)B_(2))
  \
  &quad-a_(2)(partial_(3)B_(1)-partial_(1)B_(3))
  \
  &quad-a_(3)(partial_(1)B_(2)-partial_(2)B_(1))
  \
  &=B dot.c (nabla times a)-a dot.c (nabla times B),
$
which is the claimed identity.
]

#paragraph-tab
Finally, fix $t$ again. Applying #(s.ref)("divergence of a cross product") to the spatial vector fields $a(t,dot)$ and $B(t,dot)$, and then using the spatial divergence theorem, gives
$
  0
  &=integral_(RR^(3)) op("div")(a times B)d^(3) x
  \
  &=integral_(RR^(3)) [
    B dot.c (nabla times a)-a dot.c (nabla times B)
  ]d^(3) x.
$
Here the boundary integral vanishes because $a times B$ is compactly supported. Therefore curl is formally self-adjoint on the Euclidean spatial slice:
$
  integral_(RR^(3)) (nabla times a) dot.c B d^(3) x
  =integral_(RR^(3)) a dot.c (nabla times B)d^(3) x.
$
Integrating in $t$ gives the corresponding spacetime identity. For a clear overview, the three spacetime identities are
$
  integral_(RR^(1+3)) -nabla a_(0) dot.c E d^(4) x
  &=integral_(RR^(1+3)) a_(0) op("div")E d^(4) x,
  \
  integral_(RR^(1+3)) partial_(t) a dot.c E d^(4) x
  &=-integral_(RR^(1+3)) a dot.c partial_(t)E d^(4) x,
  \
  integral_(RR^(1+3)) (nabla times a) dot.c B d^(4) x
  &=integral_(RR^(1+3)) a dot.c (nabla times B)d^(4) x.
$
Combining these three adjoint relations, we obtain
$
  L_(h) (d alpha,cal(F))
  =integral [
    a_(0) op("div")E
    +a dot.c nabla times B-partial_(t) E
  ]d^(4) x.
$ #(s.tag)("integrated Lorentzian pairing for Maxwell field")

#paragraph-tab
Likely to #(s.ref)("differential of test 1-form"), Write the unknown $1$-form as
$
  d_(h)^(*) cal(F)=beta_(0) d t+beta^(flat).
$
The Lorentzian pairing on $1$-forms is
$
  chevron.l alpha,d_(h)^(*) cal(F) chevron.r_(h)
  =-a_(0) beta_(0)+a dot.c beta.
$
Comparing this expression with #(s.ref)("integrated Lorentzian pairing for Maxwell field") for every compactly supported $alpha$ gives
$
  -beta_(0)=op("div")E,
  quad
  beta=nabla times B-partial_(t) E.
$
Hence the essential computational identity is
#highlighted[
$
  d_(h)^(*) cal(F)
  =-(op("div")E)d t
  +(nabla times B-partial_(t) E)^(flat).
$
]
The two contributions can also be displayed separately:
$
  d_(h)^(*) cal(F)_(E)
  &=-(op("div")E)d t-(partial_(t) E)^(flat),
  \
  d_(h)^(*) cal(F)_(B)
  &=(nabla times B)^(flat).
$
Notice in particular the minus sign in front of $(partial_(t) E)^(flat)$; it is forced by integration by parts in time.

#paragraph-tab
The computation above produces a spacetime $1$-form, whereas the sources in @Maxwells_equations were introduced separately: $rho$ is a scalar charge density in @Gauss_electricity, and $J$ is a spatial current vector in @Ampere_Maxwell_law. Before introducing new notation, we can see exactly how these sources must enter the spacetime equation. Gauss's law and the Maxwell--Ampere law can be rewritten as
$
  -op("div")E&=-4 pi rho,
  \
  nabla times B-partial_(t)E&=4 pi J.
$
Therefore, relative to the coframe $(d t,d x^(1),d x^(2),d x^(3))$, their source coefficients assemble as
$
  -rho d t+J^(flat).
$
This is the unique $1$-form whose temporal coefficient supplies Gauss's law and whose spatial coefficients supply the Maxwell--Ampere law.

#paragraph-tab
There is also an independent physical reason to combine $rho$ and $J$. The charge-conservation law derived in #(s.ref)("charge continuity equation"),
$
  partial_(t)rho+op("div")J=0,
$
couples the change of charge density on a spatial slice to the flux of charge through that slice. Thus $rho$ describes the temporal density of the same conserved quantity whose spatial transport is described by $J$.

#definition(title: "Charge-current 4-vector")[
  Consider first a single charged medium. Let $rho_(0)$ be its proper charge density, measured in the instantaneous rest frame of the medium, and let $U$ be its $4$-velocity. Define its charge-current $4$-vector by
  $
    cal(J):=rho_(0)U.
  $
  Relative to an inertial observer with coordinates $(t,x^(1),x^(2),x^(3))$, write
  $
    U=gamma(partial_(t)+v),
    quad
    v=sum_(j=1)^(3)v^(j)partial_(j).
  $
  The observer measures
  $
    rho:=gamma rho_(0),
    quad
    J:=rho v.
  $
  Hence
  $
    cal(J)
    =rho partial_(t)+J
    =rho partial_(t)+sum_(j=1)^(3)J^(j)partial_(j).
  $
  For several charged species, the total charge-current is the sum of their individual charge-current $4$-vectors.
] #(s.tag)("definition of charge-current 4-vector")

#paragraph-tab
Because $rho_(0)$ is a Lorentz scalar and $U$ is a spacetime vector, $rho_(0)U$ is a spacetime vector. Consequently, $rho$ and $J$ are not independent invariant quantities: they are respectively the temporal and spatial components of $cal(J)$ relative to a chosen inertial observer, and a Lorentz transformation mixes these components.

#paragraph-tab
The earlier charge-conservation law also acquires a spacetime interpretation. In inertial coordinates for the Minkowski metric, $abs(op("det")h)=1$, so
$
  op("div")_(h) cal(J)
  &=frac(1,sqrt(abs(op("det")h)))
    partial_(mu)(sqrt(abs(op("det")h))cal(J)^(mu))
  \
  &=partial_(t)rho+sum_(j=1)^(3)partial_(j)J^(j)
  \
  &=partial_(t)rho+op("div")J.
$
Thus #(s.ref)("charge continuity equation") is precisely the invariant conservation equation
$
  op("div")_(h) cal(J)=0.
$

#paragraph-tab
We now return to the source $1$-form required by Maxwell's equations. Since $d_(h)^(*) cal(F)$ is a $1$-form, lower the index of the vector in #(s.ref)("definition of charge-current 4-vector") using $h$:
$
  cal(J)^(flat)
  :=h(cal(J),dot.c)
  =-rho d t+sum_(j=1)^(3) J^(j) d x^(j)
  =-rho d t+J^(flat).
$ #(s.tag)("charge-current one-form")
The minus sign in the time component is a consequence of $h(partial_(t),partial_(t))=-1$; it is not an additional convention imposed on Maxwell's equations. In particular, $cal(J)^(flat)$ is exactly the source $1$-form $-rho d t+J^(flat)$ identified componentwise above.

#paragraph-tab
We can now state the second invariant Maxwell equation:
$
  d_(h)^(*) cal(F)=4 pi cal(J)^(flat).
$
Substituting the formulas for $d_(h)^(*) cal(F)$ and #(s.ref)("charge-current one-form") into this invariant equation gives
$
  -(op("div")E)d t
  +(nabla times B-partial_(t) E)^(flat)
  =-4 pi rho d t+4 pi J^(flat).
$

=== The Lorentzian Hodge wave operator and proof of Electromagnetic field is wave

#paragraph-tab
The Riemannian convention in @detailed_definition_of_Hodge_Laplacian is
$
  -Delta_(H)=d delta+delta d.
$
Maintaining this sign convention with the Lorentzian formal adjoint, define the Lorentzian Hodge wave operator by
#definition(title: "Lorentzian Hodge wave operator")[
  #mannot-scope(
    m => [
      #v(0.75em)
      $
        -square_(H)
        :=mark(
          d d_(h)^(*),
          tag: #(m.tag)("differentiate codifferential"),
          color: #olive,
        )
        +mark(
          d_(h)^(*)d,
          tag: #(m.tag)("codifferential after derivative"),
          color: #maroon,
        ).

        #annot(
          (m.tag)("differentiate codifferential"),
          pos: top+left,
          dx: -0.5em,
          leader-connect: "elbow",
        )[first apply $d_(h)^(*)$, then $d$]
        #annot(
          (m.tag)("codifferential after derivative"),
          pos: bottom+right,
          dx: 0.5em,
          leader-connect: "elbow",
        )[first apply $d$, then $d_(h)^(*)$]
      $
      #v(0.75em)
    ],
    parent: s,
    name: "hodge-wave-operator-parts",
  )
] #(s.tag)("definition of Lorentzian Hodge wave operator")

#paragraph-tab
This operator reveals directly that the electromagnetic field propagates as a wave. The source-free statement is a consequence of the following more general equation.

#proposition(title: "Wave equation for the electromagnetic field")[
  Suppose that the electromagnetic $2$-form $cal(F)$ and charge-current $4$-vector $cal(J)$ satisfy the invariant Maxwell equations
  #mannot-scope(
    m => [
      #v(0.75em)
      $
        mark(
          d cal(F)=0,
          tag: #(m.tag)("homogeneous equation"),
          color: #maroon,
        )
        quad
        mark(
          d_(h)^(*)cal(F)=4 pi cal(J)^(flat),
          tag: #(m.tag)("inhomogeneous equation"),
          color: #olive,
        ).

        #annot(
          (m.tag)("homogeneous equation"),
          pos: top+left,
          dx: -0.5em,
          leader-connect: "elbow",
        )[no magnetic source]
        #annot(
          (m.tag)("inhomogeneous equation"),
          pos: top+right,
          dx: 0.5em,
          leader-connect: "elbow",
        )[charge-current source]
      $
      #v(0.5em)
    ],
    parent: s,
    name: "maxwell-inputs-to-wave-equation",
  )
  Then
  $
    square_(H)cal(F)=-4 pi d(cal(J)^(flat)).
  $
  In particular, on every source-free region, where $cal(J)=0$,
  $
    square_(H)cal(F)=0.
  $
] #(s.tag)("wave equation for electromagnetic field")

#proof[
  Apply #(s.ref)("definition of Lorentzian Hodge wave operator") to $cal(F)$. The two invariant Maxwell equations give
  #mannot-scope(
    m => [
      #v(0.75em)
      $
        -square_(H)cal(F)
        &=(d d_(h)^(*)+d_(h)^(*)d)cal(F)
        \
        &=mark(
          d(d_(h)^(*)cal(F)),
          tag: #(m.tag)("inhomogeneous Maxwell term"),
          color: #olive,
        )
        +mark(
          d_(h)^(*)d cal(F),
          tag: #(m.tag)("homogeneous Maxwell term"),
          color: #maroon,
        )
        \
        &=d(4 pi cal(J)^(flat))+d_(h)^(*)0
        \
        &=4 pi d(cal(J)^(flat)).

        #annot(
          (m.tag)("inhomogeneous Maxwell term"),
          pos: left,
          dx: -1em,
          leader-connect: "elbow",
        )[second invariant equation]
        #annot(
          (m.tag)("homogeneous Maxwell term"),
          pos: right,
          dx: 1em,
          leader-connect: "elbow",
        )[first invariant equation]
      $
      #v(0.75em)
    ],
    prefix: "chapter-2-11-electromagnetic-wave-proof",
  )
  Multiplying by $-1$ proves the sourced equation. If $cal(J)=0$ on a region, then $d(cal(J)^(flat))=0$ there, and hence $square_(H)cal(F)=0$.
]

=== Electromagnetic potentials and gauge transformations

==== Electromagnetic potentials and gauge freedom

#paragraph-tab
The homogeneous Maxwell equation gives $d cal(F)=0$. Fix $p in cal(M)$ and choose a sufficiently small coordinate ball $U$ about $p$. Since
$
  d(cal(F)|_(U))=(d cal(F))|_(U)=0,
$
the Poincare lemma gives a $1$-form $A in Omega^(1)(U)$ such that
$
  d A=cal(F)|_(U).
$
Thus the existence of $A$ as a potential is a local consequence of the first Maxwell equation.

#definition(title: "Electromagnetic potential")[
  Let $U subset.eq cal(M)$ be open. An *electromagnetic potential* for $cal(F)$ on $U$ is a $1$-form $A in Omega^(1)(U)$ satisfying
  $
    d A=cal(F)|_(U).
  $
  A potential on a neighborhood $U$ of a point $p$ is called a *local potential near* $p$. A potential with $U=cal(M)$ is called a *global potential*.
] #(s.tag)("definition of electromagnetic potential")

#paragraph-tab
The preceding argument proves that every point has a neighborhood on which an electromagnetic potential exists. On such a neighborhood,
#mannot-scope(
  m => [
    #v(0.75em)
    $
      mark(
        cal(F)|_(U),
        tag: #(m.tag)("field strength"),
        color: #olive,
      )
      =mark(
        d A,
        tag: #(m.tag)("generated by potential"),
        color: #maroon,
      ).

      #annot(
        (m.tag)("field strength"),
        pos: top+left,
        dx: -0.5em,
        leader-connect: "elbow",
      )[electromagnetic field]
      #annot(
        (m.tag)("generated by potential"),
        pos: top+right,
        dx: 0.5em,
        leader-connect: "elbow",
      )[locally generated by $A$]
    $
    #v(0.5em)
  ],
  parent: s,
  name: "field-from-local-potential",
)
The two equations have different roles:
#mannot-scope(
  m => [
    #v(0.75em)
    $
      mark(
        d cal(F)=0,
        tag: #(m.tag)("maxwell constraint"),
        color: #olive,
      )
      quad "and" quad
      mark(
        d A=cal(F)|_(U),
        tag: #(m.tag)("potential representation"),
        color: #maroon,
      ).

      #annot(
        (m.tag)("maxwell constraint"),
        pos: bottom+left,
        dx: -0.5em,
        leader-connect: "elbow",
      )[condition on $cal(F)$]
      #annot(
        (m.tag)("potential representation"),
        pos: bottom+right,
        dx: 0.5em,
        leader-connect: "elbow",
      )[definition of local $A$]
    $
    #v(0.75em)
  ],
  parent: s,
  name: "closedness-versus-potential",
)
The first says that the electromagnetic field is closed; the second is the defining property of the local potential $A$.

#paragraph-tab
Now specialize to standard Minkowski spacetime with inertial coordinates $(t,x^(1),x^(2),x^(3))$ and dual frame $(partial_(t),partial_(1),partial_(2),partial_(3))$.

#definition(title: "Scalar and vector potentials")[
  Let $A$ be an electromagnetic potential on an open set $U$. Define
  $
    phi:=-A(partial_(t)),
    quad
    A_(j):=A(partial_(j)),
    quad
    bold(A):=sum_(j=1)^(3)A_(j)partial_(j).
  $
  The function $phi$ is the *scalar potential*, and the spatial vector field $bold(A)$ is the *vector potential*. If $flat$ denotes the Euclidean musical isomorphism on each spatial slice $Sigma_(t)$, then these definitions give the unique decomposition
  #mannot-scope(
    m => [
      #v(0.75em)
      $
        A
        =mark(
          -phi d t,
          tag: #(m.tag)("scalar potential"),
          color: #olive,
        )
        +mark(
          bold(A)^(flat),
          tag: #(m.tag)("spatial vector potential"),
          color: #maroon,
        )
        =-phi d t+sum_(j=1)^(3)A_(j)d x^(j),
        quad
        bold(A)=sum_(j=1)^(3)A_(j)partial_(j).

        #annot(
          (m.tag)("scalar potential"),
          pos: top+left,
          dx: -0.5em,
          leader-connect: "elbow",
        )[time part: scalar potential]
        #annot(
          (m.tag)("spatial vector potential"),
          pos: bottom,
          dy: 0.5em,
          leader-connect: "elbow",
        )[vector potential]
      $ #(s.tag)("spacetime decomposition of electromagnetic potential")
      #v(0.5em)
    ],
    parent: s,
    name: "scalar-and-vector-potential",
  )
] #(s.tag)("definition of scalar and vector potentials")
The decomposition of $A$ controls two complementary first-order quantities: $d A$, which produces the electromagnetic field, and $d_(h)^(*)A$, which will later express the Lorenz gauge. First, using $d(d t)=d(d x^(j))=0$, we compute
$
  d A
  &=-d phi and d t+sum_(j=1)^(3)d A_(j) and d x^(j)
  \
  &=sum_(j=1)^(3)(-partial_(j)phi-partial_(t)A_(j))d x^(j) and d t
  \
  &quad+(nabla times bold(A))_(1)d x^(2) and d x^(3)
  \
  &quad+(nabla times bold(A))_(2)d x^(3) and d x^(1)
  \
  &quad+(nabla times bold(A))_(3)d x^(1) and d x^(2).
$ #(s.tag)("exterior derivative of electromagnetic potential")

To express the codifferential in the same scalar-spatial decomposition, we use the following coordinate formula.

#lemma(title: "Lorentzian codifferential of a 1-form")[
  On standard Minkowski spacetime $(RR^(1+3),h)$ with signature $(-,+,+,+)$, let
  $
    beta
    :=beta_(0)d t+bold(beta)^(flat)
    =beta_(0)d t+sum_(j=1)^(3)beta_(j)d x^(j).
  $
  Then
  $
    d_(h)^(*)beta
    =partial_(t)beta_(0)-op("div")bold(beta).
  $
] #(s.tag)("Lorentzian codifferential of a one-form")

#proof[
Let $u in C_c^(infinity)(RR^(1+3))$ be a compactly supported test function. Its exterior derivative is
$
  d u
  =partial_(t)u d t
  +sum_(j=1)^(3)partial_(j)u d x^(j).
$
Since
$
  chevron.l d t,d t chevron.r_(h)=-1,
  quad
  chevron.l d x^(i),d x^(j) chevron.r_(h)=delta_(i j),
$
the pointwise Lorentzian pairing is
$
  chevron.l d u,beta chevron.r_(h)
  =-partial_(t)u beta_(0)
  +sum_(j=1)^(3)partial_(j)u beta_(j).
$
Using the formal-adjoint identity in #(s.ref)("Lorentzian formal adjoint of exterior derivative") and integrating by parts gives
$
  L_(h)(d u,beta)
  &=integral_(RR^(1+3)) [
    -partial_(t)u beta_(0)
    +sum_(j=1)^(3)partial_(j)u beta_(j)
  ]d^(4)x
  \
  &=integral_(RR^(1+3)) u [
    partial_(t)beta_(0)
    -sum_(j=1)^(3)partial_(j)beta_(j)
  ]d^(4)x
  \
  &=L_(h)(u,
    partial_(t)beta_(0)-op("div")bold(beta)).
$
There are no boundary terms because $u$ is compactly supported. In the temporal term, the minus sign from the Lorentzian metric and the minus sign from integration by parts cancel. Each spatial term receives only the minus sign from integration by parts. The non-degeneracy of $L_(h)$ now gives
$
  d_(h)^(*)beta
  =partial_(t)beta_(0)-op("div")bold(beta).
$
]

#paragraph-tab
Apply #(s.ref)("Lorentzian codifferential of a one-form") to the potential decomposition #(s.ref)("spacetime decomposition of electromagnetic potential"). Since $beta_(0)=-phi$ and $bold(beta)=bold(A)$ for
$
  A=-phi d t+bold(A)^(flat),
$
we obtain
$
  d_(h)^(*)A
  &=partial_(t)(-phi)-op("div")bold(A)
  \
  &=-partial_(t)phi-op("div")bold(A).
$ #(s.tag)("codifferential of electromagnetic potential")

We now have both first-order expressions associated with the potential. Because $d A=cal(F)$, comparing #(s.ref)("exterior derivative of electromagnetic potential") with #(s.ref)("coordinate expression of electromagnetic 2-form") gives
$
  E=-nabla phi-partial_(t)bold(A),
  quad
  B=nabla times bold(A).
$

These signs follow from the conventions already fixed in this chapter: the electric part of $cal(F)$ is $E^(flat) and d t$, while the temporal part of $A$ is $-phi d t$.

==== The Lorenz gauge and the wave equation for $A$
#paragraph-tab
The Poincare lemma provides a non-uniqueness of $A$. We formulate this non-uniqueness in terms of gauge freedom. Gauge freedom is the higher-degree analogue of the ordinary constant of integration. Begin with a closed $1$-form $omega$:
$
  d omega=0.
$
By the Poincare lemma, locally $omega=d f$ for a scalar function $f$. If $f$ is one primitive, then $f+C$ is another because
$
  d(f+C)=d f.
$
On a connected neighborhood, any two scalar primitives differ by a constant.

#paragraph-tab
Now move one degree upward. Suppose $A$ and $A^(prime)$ determine the same electromagnetic field:
$
  d A^(prime)=d A=cal(F).
$
Then
$
  d(A^(prime)-A)=0,
$
so $A^(prime)-A$ is a closed $1$-form. Applying the Poincare lemma once more, locally there is a scalar function $chi$ such that
$
  A^(prime)-A=d chi.
$
Therefore
$
  A^(prime)=A+d chi.
$

The two cases form a hierarchy. For a scalar primitive, the ambiguity is a constant $C$; for a $1$-form primitive, the ambiguity is an exact $1$-form $d chi$. The gauge function itself is determined only up to a constant, since
$
  d(chi+C)=d chi.
$

#definition(title: "Gauge transformation")[
  Let $A$ be an electromagnetic potential and let $chi$ be a smooth scalar function. The replacement
  $
    A mapsto A+d chi
  $
  is called a gauge transformation.
] #(s.tag)("definition of electromagnetic gauge transformation")

The electromagnetic field is unchanged under #(s.ref)("definition of electromagnetic gauge transformation") because
$
  d(A+d chi)
  =d A+d^(2)chi
  =d A
  =cal(F).
$
Thus $cal(F)$ is gauge invariant.

#paragraph-tab
To find the transformation of the scalar and spatial potentials, use #(s.ref)("spacetime decomposition of electromagnetic potential") and
$
  d chi=partial_(t)chi d t+(nabla chi)^(flat).
$
Then
$
  A+d chi
  &=(-phi+partial_(t)chi)d t
    +(bold(A)+nabla chi)^(flat)
  \
  &=-phi^(prime)d t+bold(A)^(prime flat),
$
so
$
  phi^(prime)=phi-partial_(t)chi,
  quad
  bold(A)^(prime)=bold(A)+nabla chi.
$

The electric field remains unchanged:
$
  E^(prime)
  &=-nabla phi^(prime)-partial_(t)bold(A)^(prime)
  \
  &=-nabla(phi-partial_(t)chi)
    -partial_(t)(bold(A)+nabla chi)
  \
  &=E,
$
because the spatial gradient commutes with $partial_(t)$. Likewise,
$
  B^(prime)
  =nabla times (bold(A)+nabla chi)
  =B,
$
because $nabla times nabla chi=0$.


#paragraph-tab
Substitute $cal(F)=d A$ into the second invariant Maxwell equation:
$
  d_(h)^(*)cal(F)=4 pi cal(J)^(flat).
$
This gives the potential equation
$
  d_(h)^(*)d A=4 pi cal(J)^(flat).
$

This equation cannot determine $A$ uniquely. Indeed,
$
  d_(h)^(*)d(A+d chi)
  =d_(h)^(*)d A
$
because $d^(2)chi=0$. From the PDE viewpoint, the operator $d_(h)^(*)d$ therefore has a gauge degeneracy: all potentials in the class
$
  [A]:={A+d chi:chi in C^(infinity)(cal(M))}
$
produce the same electromagnetic field and satisfy the same potential equation.

#paragraph-tab
The gauge degeneracy of the potential equation motivates a condition that selects a representative without changing $cal(F)$.

#definition(title: "Lorenz gauge")[
  A potential $A$ is said to satisfy the Lorenz gauge when
  $
    d_(h)^(*)A=0.
  $
] #(s.tag)("definition of Lorenz gauge")


#paragraph-tab
The choice in #(s.ref)("definition of Lorenz gauge") is natural because $d$ and $d_(h)^(*)$ are the geometric first-order adjoint pair already used to formulate Maxwell's equations. Imposing $d_(h)^(*)A=0$ selects a representative from the gauge-equivalence class by controlling the complementary first-order derivative of $A$.

#paragraph-tab
The coordinate formula already obtained in #(s.ref)("codifferential of electromagnetic potential") makes the Lorenz gauge equivalent to
$
  d_(h)^(*)A=0
  quad arrow.l.r quad
  -(partial_(t)phi+op("div")bold(A))=0
  quad arrow.l.r quad
  partial_(t)phi+op("div")bold(A)=0.
$

#paragraph-tab
The Lorenz gauge turns the potential equation into a wave equation. Indeed, using #(s.ref)("definition of Lorentzian Hodge wave operator"), for a $1$-form $A$,
$
  -square_(H)A
  =(d d_(h)^(*)+d_(h)^(*)d)A
  =d(d_(h)^(*)A)+d_(h)^(*)d A.
$
Under the Lorenz gauge, the first term vanishes, so
$
  -square_(H)A=d_(h)^(*)d A.
$
Consequently, the Maxwell equation for the potential becomes
$
  square_(H)A=-4 pi cal(J)^(flat).
$
This is the principal PDE advantage of Lorenz gauge: it converts the gauge-degenerate potential equation into a standard hyperbolic wave equation for the components of $A$.

#paragraph-tab
It remains to verify that this gauge condition can be imposed. Start with an arbitrary potential $A$ and perform the gauge transformation
$
  A^(prime)=A+d chi.
$
Then
$
  d_(h)^(*)A^(prime)
  =d_(h)^(*)A+d_(h)^(*)d chi.
$ #(s.tag)("Lorenz gauge after gauge transformation")
To interpret the last term, apply #(s.ref)("Lorentzian codifferential of a one-form") to $beta=d chi$. Here $beta_(0)=partial_(t)chi$ and $bold(beta)=nabla chi$, so
$
  d_(h)^(*)d chi
  =partial_(t)^(2)chi-Delta chi
  =-square_(H)chi,
$ #(s.tag)("scalar Lorentzian wave operator convention")
where
$
  square_(H)chi=-partial_(t)^(2)chi+Delta chi.
$
Therefore #(s.ref)("Lorenz gauge after gauge transformation") is
$
  d_(h)^(*)A^(prime)
  =d_(h)^(*)A-square_(H)chi.
$
Choosing $chi$ to solve the scalar wave equation
$
  square_(H)chi=d_(h)^(*)A
$
gives $d_(h)^(*)A^(prime)=0$. Thus gauge fixing is itself a PDE problem.

#paragraph-tab
The Lorenz gauge does not remove every gauge transformation. If $A$ already satisfies $d_(h)^(*)A=0$, then $A+d chi$ remains in Lorenz gauge precisely when
$
  square_(H)chi=0.
$
This is called a residual gauge freedom.

#paragraph-tab
The implication
$
  d cal(F)=0 arrow.r cal(F)=d A
$
is local. A global potential exists precisely when the de Rham cohomology class of the electromagnetic field vanishes:
$
  [cal(F)] in H_("dR")^(2)(cal(M)),
  quad
  [cal(F)]=0.
$
In particular, standard Minkowski spacetime is contractible, so this obstruction vanishes there.

#paragraph-tab
If $A$ and $A^(prime)$ are global potentials for the same field, their difference is a global closed $1$-form. Writing
$
  A^(prime)-A=d chi
$
globally requires the cohomology class $[A^(prime)-A] in H_("dR")^(1)(cal(M))$ to vanish. Thus both the existence of a global potential and the global form of a gauge transformation can contain topological obstructions.

=== Variational approach to the second invariant Maxwell equation

#paragraph-tab
Before constructing the action, we must distinguish a general variation from a gauge transformation. The variable of the variational problem is the potential $A$, not the field $cal(F)$ independently. A general variation chooses an arbitrary compactly supported $1$-form $alpha in Omega_(c)^(1)(cal(M))$ and forms the one-parameter family
$
  A_(epsilon):=A+epsilon alpha.
$
Since $cal(F)=d A$, the induced variation of the electromagnetic field is
$
  cal(F)_(epsilon)
  &=d A_(epsilon)
  =cal(F)+epsilon d alpha,
  \
  delta A&=alpha,
  quad
  delta cal(F)=d alpha.
$
Thus a general variation compares $A$ with nearby potentials and may change the physical field.

#paragraph-tab
A gauge transformation is the special variational family obtained by taking $alpha=d chi$:
$
  A_(epsilon)
  =A+epsilon d chi
  =A+d(epsilon chi),
  quad
  delta cal(F)=d^(2)chi=0.
$
At $epsilon=1$, this family gives $A mapsto A+d chi$. Within the compactly supported class used here, #highlight()[every infinitesimal gauge transformation is therefore an admissible variation, but a general variation need not be a gauge transformation.] The exact directions $d chi$ are tangent to the gauge orbit of $A$: they change the representative of the potential without changing $cal(F)$.

#paragraph-tab
The gauge part of this comparison is summarized by #(s.ref)("definition of electromagnetic gauge transformation"):
#mannot-scope(
  m => [
    #v(0.75em)
    $
      mark(
        A mapsto A+d chi,
        tag: #(m.tag)("gauge change of potential"),
        color: #olive,
      )
      quad arrow.r quad
      mark(
        d(A+d chi)=d A,
        tag: #(m.tag)("unchanged field"),
        color: #maroon,
      ).

      #annot(
        (m.tag)("gauge change of potential"),
        pos: bottom+left,
        dx: -0.5em,
      )[different representatives]
      #annot(
        (m.tag)("unchanged field"),
        pos: bottom+right,
        dx: 0.5em,
      )[same $cal(F)=d A$]
    $
    #v(0.75em)
  ],
  parent: s,
  name: "gauge-invariance-selects-field-strength",
)
Thus, among local gauge-invariant actions that are first-order and quadratic in $A$, the free-field term must be built from $cal(F)=d A$.

#paragraph-tab
The Lorentz metric supplies the quadratic scalar $chevron.l cal(F),cal(F) chevron.r_(h,2)$. Using #(s.ref)("coordinate expression of electromagnetic 2-form") and #(s.ref)("orthogonality of mixed and spatial basis forms"), bilinearity separates it into three contributions:
$
  chevron.l cal(F),cal(F) chevron.r_(h,2)
  &=chevron.l cal(F)_(E),cal(F)_(E) chevron.r_(h,2)
    +2 chevron.l cal(F)_(E),cal(F)_(B) chevron.r_(h,2)
    +chevron.l cal(F)_(B),cal(F)_(B) chevron.r_(h,2)
  \
  &=-abs(E)^(2)+abs(B)^(2)
  #dots_space #footnote[
    The reduction has three steps:
    + *Electric part:* $chevron.l d x^(j) and d t,d x^(k) and d t chevron.r_(h,2)=-delta_(j k)$, so $chevron.l cal(F)_(E),cal(F)_(E) chevron.r_(h,2)=-sum_(j=1)^(3)E_(j)^(2)=-abs(E)^(2)$.
    + *Mixed part:* #(s.ref)("orthogonality of mixed and spatial basis forms") gives $2 chevron.l cal(F)_(E),cal(F)_(B) chevron.r_(h,2)=0$.
    + *Magnetic part:* $chevron.l hat(d x^(j)),hat(d x^(k)) chevron.r_(h,2)=delta_(j k)$, so $chevron.l cal(F)_(B),cal(F)_(B) chevron.r_(h,2)=sum_(j=1)^(3)B_(j)^(2)=abs(B)^(2)$.
    Adding these three contributions gives the displayed identity.
  ].
$ #(s.tag)("electric magnetic decomposition of Maxwell scalar")
First consider only the free-field functional, with $c != 0$:
$
  cal(S)_("free",c)[A]:=c L_(h)(d A,d A).
$
For $alpha in Omega_(c)^(1)(cal(M))$, set $A_(epsilon)=A+epsilon alpha$ and $cal(F)=d A$. Linearity of $d$ gives
$
  d A_(epsilon)
  =d(A+epsilon alpha)
  =cal(F)+epsilon d alpha.
$
By the definition of first variation and bilinearity of $L_(h)$,
$
  delta cal(S)_("free",c)[A](alpha)
  &:=lr(frac(d,d epsilon)|)_(epsilon=0)
  cal(S)_("free",c)[A+epsilon alpha]
  \
  &=lr(frac(d,d epsilon)|)_(epsilon=0)
  c L_(h)(
    cal(F)+epsilon d alpha,
    cal(F)+epsilon d alpha
  )
  \
  &=lr(frac(d,d epsilon)|)_(epsilon=0)c[
    L_(h)(cal(F),cal(F))
    +epsilon L_(h)(d alpha,cal(F))
    \
    &+epsilon L_(h)(cal(F),d alpha)
    +epsilon^(2)L_(h)(d alpha,d alpha)
  ]
  \
  &=c[
    L_(h)(d alpha,cal(F))
    +L_(h)(cal(F),d alpha)
  ]
  \
  &=2c L_(h)(d alpha,cal(F))
  \
  &=2c L_(h)(alpha,d_(h)^(*)cal(F)).
$ #(s.tag)("variation of free Maxwell action")
The factor $2$ comes from the two equal cross terms by symmetry of $L_(h)$. The last equality uses #(s.ref)("Lorentzian formal adjoint of exterior derivative"). Because $alpha$ is compactly supported, no boundary term remains.
#block(breakable: false)[
  Therefore stationarity of the free action alone gives
  $
    d_(h)^(*)cal(F)=0.
  $ #(s.tag)("source-free Maxwell equation from free action")
]
This is the correct equation only on a source-free region. If $rho$ or $J$ is nonzero, #(s.ref)("source-free Maxwell equation from free action") cannot describe its effect because $cal(J)$ does not occur anywhere in the free functional.
#figure(
  maxwell-source-domain-comparison(),
  caption: [The field equation on $U$ depends on whether $U$ intersects the support of the charge-current $cal(J)$. A source outside $U$ may still generate a nonzero electromagnetic field inside $U$.],
)

#paragraph-tab
To describe a prescribed charge-current $cal(J)$, the action must contain a term whose first variation contributes $cal(J)^(flat)$. The local Lorentz scalar linear in both the potential and the current is $chevron.l A,cal(J)^(flat) chevron.r_(h)=A(cal(J))$. Hence define
$
  cal(S)_("src")[A]:=L_(h)(A,cal(J)^(flat)).
$ #(s.tag)("source coupling action")
#block(breakable: false)[
  Its variation is exactly
  $
    delta cal(S)_("src")[A](alpha)
    &:=lr(frac(d,d epsilon)|)_(epsilon=0)
      cal(S)_("src")[A+epsilon alpha]
    \
    &=lr(frac(d,d epsilon)|)_(epsilon=0)
      L_(h)(A+epsilon alpha,cal(J)^(flat))
    \
    &=lr(frac(d,d epsilon)|)_(epsilon=0)[
      L_(h)(A,cal(J)^(flat))
      +epsilon L_(h)(alpha,cal(J)^(flat))
    ]
    \
    &=L_(h)(alpha,cal(J)^(flat)).
  $ #(s.tag)("variation of source coupling action")
]
Here the prescribed charge-current $cal(J)$ is held fixed while the potential $A$ varies. Thus the source action is not an additional free-field energy: it is the interaction term through which the prescribed charge-current enters the field equation.

#paragraph-tab
The overall nonzero scaling of an action does not change its stationary points. We therefore normalize #(s.ref)("source coupling action") to have coefficient $+1$ and determine the field coefficient relative to it. Introduce
$
  cal(S)_(c)[A]
  :=c L_(h)(d A,d A)+L_(h)(A,cal(J)^(flat)).
$
Combining #(s.ref)("variation of free Maxwell action") and #(s.ref)("variation of source coupling action") gives
$
  delta cal(S)_(c)[A](alpha)
  =L_(h)(
    alpha,
    2c d_(h)^(*)cal(F)+cal(J)^(flat)
  ).
$ #(s.tag)("variation with undetermined Maxwell coefficient")
The factor $2$ comes from differentiating the two equal appearances of $cal(F)$ in the quadratic pairing. Thus stationarity for every compactly supported $alpha$ gives
$
  2c d_(h)^(*)cal(F)+cal(J)^(flat)=0
  quad arrow.l.r quad
  d_(h)^(*)cal(F)=-frac(1,2c)cal(J)^(flat).
$
To match the $4 pi$ source coefficient in @Maxwells_equations, we require
$
  -frac(1,2c)=4 pi
  quad arrow.l.r quad
  c=-frac(1,8 pi).
$ #(s.tag)("determination of Maxwell normalization coefficient")
Therefore the Gaussian-unit normalization of the free-field action is
#mannot-scope(
  m => [
    #v(0.75em)
    $
      cal(S)_("free")[A]
      :=mark(
        -frac(1,8 pi),
        tag: #(m.tag)("Gaussian normalization"),
        color: #purple,
      )
      L_(h)(d A,d A)
      =integral_(cal(M))
      frac(abs(E)^(2)-abs(B)^(2),8 pi)d V_(h).

      #annot(
        (m.tag)("Gaussian normalization"),
        pos: top+left,
        dx: -0.5em,
      )[normalization matching the $4 pi$ convention]
    $ #(s.tag)("free electromagnetic action")
    #v(0.5em)
  ],
  parent: s,
  name: "free-electromagnetic-action",
)
The minus sign in #(s.ref)("determination of Maxwell normalization coefficient") also changes the Lorentzian scalar $abs(B)^(2)-abs(E)^(2)$ into the standard Lagrangian density $(abs(E)^(2)-abs(B)^(2))/(8 pi)$. The last equality is its component expression on standard Minkowski spacetime.

#paragraph-tab
The invariant source term in #(s.ref)("source coupling action") also displays how charge and current couple to the classical potentials. By #(s.ref)("spacetime decomposition of electromagnetic potential") and #(s.ref)("charge-current one-form"),
#mannot-scope(
  m => [
    #v(0.75em)
    $
      chevron.l A,cal(J)^(flat) chevron.r_(h)
      =mark(
        -rho phi,
        tag: #(m.tag)("charge potential coupling"),
        color: #olive,
      )
      +mark(
        bold(A) dot.c J,
        tag: #(m.tag)("current potential coupling"),
        color: #maroon,
      ).

      #annot(
        (m.tag)("charge potential coupling"),
        pos: bottom+left,
        dx: -0.5em,
      )[charge with scalar potential]
      #annot(
        (m.tag)("current potential coupling"),
        pos: bottom+right,
        dx: 0.5em,
      )[current with vector potential]
    $ #(s.tag)("component form of source coupling")
    #v(0.75em)
  ],
  parent: s,
  name: "source-coupling-components",
)
Hence #(s.ref)("source coupling action") has the component form
$
  cal(S)_("src")[A]
  =integral_(cal(M))(-rho phi+bold(A) dot.c J)d V_(h).
$

#definition(title: "Maxwell action with source")[
  Fix a charge-current $4$-vector $cal(J)$ and let $A in Omega^(1)(cal(M))$ be an electromagnetic potential with $cal(F)=d A$. Adding #(s.ref)("free electromagnetic action") and #(s.ref)("source coupling action"), define
  #mannot-scope(
    m => [
      #v(0.75em)
      $
        cal(S)_("Max")[A]
        :=mark(
          -frac(1,8 pi)L_(h)(d A,d A),
          tag: #(m.tag)("free field term"),
          color: #olive,
        )
        +mark(
          L_(h)(A,cal(J)^(flat)),
          tag: #(m.tag)("source coupling"),
          color: #maroon,
        ).

        #annot(
          (m.tag)("free field term"),
          pos: top+left,
          dx: -0.5em,
          leader-connect: "elbow",
        )[electromagnetic field term]
        #annot(
          (m.tag)("source coupling"),
          pos: top+right,
          dx: 0.5em,
          leader-connect: "elbow",
        )[interaction with charge-current]
      $
      #v(0.5em)
    ],
    parent: s,
    name: "maxwell-action-terms",
  )
  A potential $A$ is a stationary point of $cal(S)_("Max")$ when
  $
    lr(frac(d,d epsilon)|)_(epsilon=0)
    cal(S)_("Max")[A+epsilon alpha]=0
  $
  for every $alpha in Omega_(c)^(1)(cal(M))$.
] #(s.tag)("definition of Maxwell action with source")

#proposition(title: "Second invariant Maxwell equation as an Euler--Lagrange equation")[
  A potential $A$ is a stationary point of #(s.ref)("definition of Maxwell action with source") if and only if its field $cal(F)=d A$ satisfies
  $
    d_(h)^(*)cal(F)=4 pi cal(J)^(flat).
  $
]

#proof[
Fix $alpha in Omega_(c)^(1)(cal(M))$. The variation of the potential and its field is
#mannot-scope(
  m => [
    #v(0.75em)
    $
      A_(epsilon)
      &=mark(A, tag: #(m.tag)("background potential"), color: #olive)
      +mark(epsilon alpha, tag: #(m.tag)("potential variation"), color: #maroon),
      \
      cal(F)_(epsilon)=d A_(epsilon)
      &=mark(cal(F), tag: #(m.tag)("background field"), color: #olive)
      +mark(epsilon d alpha, tag: #(m.tag)("field variation"), color: #maroon).

      #annot(
        (m.tag)("background potential"),
        pos: top+left,
        dx: -0.5em,
      )[fixed at $epsilon=0$]
      #annot(
        (m.tag)("potential variation"),
        pos: top+right,
        dx: 0.5em,
      )[compactly supported direction]
      #annot(
        (m.tag)("background field"),
        pos: bottom+left,
        dx: -0.5em,
      )[$cal(F)=d A$]
      #annot(
        (m.tag)("field variation"),
        pos: bottom+right,
        dx: 0.5em,
      )[$delta cal(F)=d alpha$]
    $
    #v(0.75em)
  ],
  parent: s,
  name: "variation-of-potential-and-field",
)
By symmetry and bilinearity of $L_(h)$, followed by #(s.ref)("Lorentzian formal adjoint of exterior derivative"),
#mannot-scope(
  m => [
    #v(1em)
    $
      delta cal(S)_("Max")[A](alpha)
      &=mark(
        -frac(1,4 pi)L_(h)(d alpha,cal(F)),
        tag: #(m.tag)("varied field term"),
        color: #olive,
      )
      +mark(
        L_(h)(alpha,cal(J)^(flat)),
        tag: #(m.tag)("varied source term"),
        color: #maroon,
      )
      \
      &=L_(h)(
        alpha,
        mark(
          cal(J)^(flat)-frac(1,4 pi)d_(h)^(*)cal(F),
          tag: #(m.tag)("Euler Lagrange form"),
          color: #purple,
        )
      ).

      #annot(
        (m.tag)("varied field term"),
        pos: top+left,
        dx: -0.5em,
        leader-connect: "elbow",
      )[variation of $d A$]
      #annot(
        (m.tag)("varied source term"),
        pos: top+right,
        dx: 0.5em,
        leader-connect: "elbow",
      )[variation of $A$]
      #annot(
        (m.tag)("Euler Lagrange form"),
        pos: bottom,
        dy: 0.5em,
        leader-connect: "elbow",
      )[coefficient of every test $1$-form $alpha$]
    $ #(s.tag)("first variation of Maxwell action")
    #v(0.75em)
  ],
  parent: s,
  name: "first-variation-of-Maxwell-action",
)
Thus #(s.ref)("first variation of Maxwell action") vanishes for every compactly supported $alpha$ if and only if
$
  cal(J)^(flat)-frac(1,4 pi)d_(h)^(*)cal(F)=0,
$
which is equivalent to the second invariant Maxwell equation.
]

=== electromagnetic stress-energy tensor

#paragraph-tab
Varying the potential in #(s.ref)("definition of Maxwell action with source") produced the second invariant Maxwell equation. #highlighted()[We now keep $A$ fixed and vary the Lorentz metric $h$.] To distinguish the two action sectors, temporarily display all of their dependencies:
$
  cal(S)_("Max")[A,h,cal(J)]
  =cal(S)_("free")[A,h]+cal(S)_("src")[A,h,cal(J)].
$
Put $K^(a b):=delta_h h^(a b)$. Linearity of metric variation then gives
$
  delta_h cal(S)_("Max")
  =delta_h cal(S)_("free")+delta_h cal(S)_("src").
$ #(s.tag)("metric variation decomposition of Maxwell action")
Once the metric response of a sector has been specified, the convention of @definition_of_stress-energy_tensor reads
$
  delta_h cal(S)_("free")
  &=-frac(1,2)integral_(cal(M))
    T^("EM")_(a b)K^(a b)d V_(h),
  \
  delta_h cal(S)_("src")
  &=-frac(1,2)integral_(cal(M))
    T^("src")_(a b)K^(a b)d V_(h).
$ #(s.tag)("metric variation convention for stress-energy")
Here $T^("EM"):=T^("free")$ is the electromagnetic field tensor. Formally, the metric response of the displayed external-current action is therefore
$
  T^("Max"):=T^("EM")+T^("src").
$

#paragraph-tab
Maxwell's equations govern $cal(F)$ in the presence of the source $cal(J)$, but they do not determine $T^("src")$. Defining $T^("src")$ requires an additional metric-variation rule specifying whether $cal(J)$, $cal(J)^(flat)$, or the conserved current $3$-form is held fixed. #footnote[A physical $T^("matter")$ instead comes from a dynamical matter action. Its construction is treated in relativistic field theory, continuum and plasma physics, and general relativity. Thus $T^("Max")$ above is only a formal decomposition; this subsection computes the unambiguous $T^("EM")$ from #(s.ref)("free electromagnetic action").]

#paragraph-tab
Set $q_(h)(cal(F)):=chevron.l cal(F),cal(F) chevron.r_(h,2)$. The component formula follows from the metric induced by $h$ on $2$-forms:
#flowbox()[
  The inverse metric pairs coordinate covectors by
  $
    chevron.l d x^(a),d x^(c) chevron.r_(h)=h^(a c).
  $

  $arrow.b$

  The induced pairing on decomposable $2$-forms is the determinant pairing
  $
    chevron.l
      d x^(a) and d x^(b),
      d x^(c) and d x^(d)
    chevron.r_(h,2)
    =h^(a c)h^(b d)-h^(a d)h^(b c).
  $

  $arrow.b$

  Since $cal(F)$ is alternating, its coordinate expansion is
  $
    cal(F)=frac(1,2)cal(F)_(a b)d x^(a) and d x^(b),
    quad
    cal(F)_(a b)=-cal(F)_(b a).
  $
  Therefore bilinearity gives
  $
    q_(h)(cal(F))
    =frac(1,4)cal(F)_(a b)cal(F)_(c d)
      [h^(a c)h^(b d)-h^(a d)h^(b c)].
  $

  $arrow.b$

  Relabeling $c arrow.l.r d$ in the second term and using antisymmetry,
  $
    -h^(a d)h^(b c)cal(F)_(a b)cal(F)_(c d)
    &=-h^(a c)h^(b d)cal(F)_(a b)cal(F)_(d c)
    \
    &=h^(a c)h^(b d)cal(F)_(a b)cal(F)_(c d).
  $
  Thus the two determinant terms are equal, and the factor $1/4$ becomes $1/2$.

  $arrow.b$

  Raising both indices by
  $
    cal(F)^(a b):=h^(a c)h^(b d)cal(F)_(c d)
  $
  finally gives
  $
    q_(h)(cal(F))
    =frac(1,2)h^(a c)h^(b d)cal(F)_(a b)cal(F)_(c d)
    =frac(1,2)cal(F)_(a b)cal(F)^(a b).
  $ #(s.tag)("quadratic Maxwell scalar for metric variation")
]
For the Lorentz signature $(-,+,+,+)$, this scalar is $-abs(E)^(2)+abs(B)^(2)$, so it is an indefinite Lorentzian quadratic form rather than a positive norm.
Since $cal(F)=d A$ and $A$ is fixed during the metric variation by the assumption,
$
  delta_h cal(F)_(a b)=0.
$
Only the inverse metrics raising the indices vary. Consequently,
$
  delta_h q_(h)(cal(F))
  &=frac(1,2)K^(a c)h^(b d)cal(F)_(a b)cal(F)_(c d)
  \
  &quad+frac(1,2)h^(a c)K^(b d)cal(F)_(a b)cal(F)_(c d)
  \
  &=cal(F)_(a c)cal(F)_(b)^(c)K^(a b).
$ #(s.tag)("metric variation of quadratic Maxwell scalar")
The inverse-metric form of the volume variation used in @definition_of_stress-energy_tensor is
$
  delta_(h)(d V_(h))
  =-frac(1,2)h_(a b)K^(a b)d V_(h).
$ #(s.tag)("inverse metric variation of Lorentzian volume")

#block(breakable: false)[
  #paragraph-tab
  Apply these two variations to the free action:
  #mannot-scope(
    m => [
      #v(0.75em)
      $
        delta_h cal(S)_("free")
        =-frac(1,8 pi)integral_(cal(M))[
          mark(
            cal(F)_(a c)cal(F)_(b)^(c),
            tag: #(m.tag)("raised-index variation"),
            color: #olive,
          )
          -mark(
            frac(1,2)q_(h)(cal(F))h_(a b),
            tag: #(m.tag)("volume variation"),
            color: #maroon,
          )
        ]K^(a b)d V_(h).

        #annot(
          (m.tag)("raised-index variation"),
          pos: top+left,
          dx: -0.5em,
          dy: -1em,
          leader-connect: "elbow",
        )[metric inside the $2$-form pairing]
        #annot(
          (m.tag)("volume variation"),
          pos: top+right,
          dx: 0.5em,
          leader-connect: "elbow",
        )[metric inside $d V_(h)$]
      $ #(s.tag)("metric variation of free Maxwell action")
      #v(0.75em)
    ],
    parent: s,
    name: "metric-variation-parts-of-Maxwell-action",
  )
]
Comparing #(s.ref)("metric variation of free Maxwell action") with #(s.ref)("metric variation convention for stress-energy") determines the tensor.

#definition(title: "Covariant electromagnetic stress-energy tensor")[
  The electromagnetic stress-energy tensor is the symmetric $(0,2)$-tensor
  $
    T^("EM")(X,Y)
    :=frac(1,4 pi)[
      chevron.l i_(X)cal(F),i_(Y)cal(F) chevron.r_(h)
      -frac(1,2)q_(h)(cal(F))h(X,Y)
    ].
  $
  Equivalently, its covariant components are
  $
    T^("EM")_(a b)
    &=frac(1,4 pi)[
      cal(F)_(a c)cal(F)_(b)^(c)
      -frac(1,2)q_(h)(cal(F))h_(a b)
    ]
    \
    &=frac(1,4 pi)[
      cal(F)_(a c)cal(F)_(b)^(c)
      -frac(1,4)h_(a b)cal(F)_(c d)cal(F)^(c d)
    ].
  $
] #(s.tag)("definition of covariant electromagnetic stress-energy tensor")

#paragraph-tab
The formula is covariant because it is built only from the tensors $cal(F)$ and $h$ by contraction. Although an observer changes the electric and magnetic components, the $(0,2)$-tensor $T^("EM")$ itself does not depend on a coordinate frame. We retain the label $"EM"$ below to distinguish this tensor from $T^("src")$ and from the matter and total tensors introduced at the end.

#paragraph-tab
Symmetry follows before any coordinate calculation:
$
  chevron.l i_(X)cal(F),i_(Y)cal(F) chevron.r_(h)
  =chevron.l i_(Y)cal(F),i_(X)cal(F) chevron.r_(h),
$
and $h(X,Y)=h(Y,X)$. Thus $T^("EM")(X,Y)=T^("EM")(Y,X)$.

#paragraph-tab
In four spacetime dimensions the tensor is traceless. Indeed,
$
  op("tr")_(h)T^("EM")
  &=h^(a b)T^("EM")_(a b)
  \
  &=frac(1,4 pi)[
    cal(F)_(a c)cal(F)^(a c)
    -frac(1,4)h^(a b)h_(a b)
      cal(F)_(c d)cal(F)^(c d)
  ]
  \
  &=frac(1,4 pi)[1-frac(4,4)]
    cal(F)_(c d)cal(F)^(c d)
  \
  &=0.
$ #(s.tag)("tracelessness of electromagnetic stress-energy")
The cancellation uses the spacetime dimension $h^(a b)h_(a b)=4$. #footnote[See my note of @Manifolds "Application : The trace of the Meteic Itself".]

#paragraph-tab
Now use the inertial frame of #(s.ref)("coordinate expression of electromagnetic 2-form"). With
$
  cal(F)_(i 0)=E_(i),
  quad
  cal(F)_(i j)=epsilon_(i j k)B_(k),
$
we have
$
  cal(F)_(c d)cal(F)^(c d)
  =2(abs(B)^(2)-abs(E)^(2)),
  quad
  cal(F)_(0 c)cal(F)_(0)^(c)=abs(E)^(2).
$
#block(breakable: false)[
  Therefore the time-time component is
  $
    T^("EM")_(0 0)
    &=frac(1,4 pi)[
      abs(E)^(2)
      -frac(1,4)h_(0 0)2(abs(B)^(2)-abs(E)^(2))
    ]
    \
    &=frac(abs(E)^(2)+abs(B)^(2),8 pi).
  $ #(s.tag)("electromagnetic energy density")
  Thus every inertial observer measures a nonnegative electromagnetic energy density.
]


])
