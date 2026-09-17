#import "../Styles/styles.typ": *
#import "figures/figures.typ": translation-orbit-diagram, subordination-mixture-diagram, kernel-support-comparison-diagram, frequency-operator-map, wave-kernel-descent-diagram, wave-source-observer-diagram, source-mass-superposition-diagram, boundary-image-kernel-diagram, diagonal-kernel-support-diagram, distributional-tensor-coupling-diagram, kernel-duality-fletcher-diagram
#import "@preview/mannot:0.4.0": *

#local-tag-scope(s => [

== Classical evolution equations: constructing kernels

#paragraph_tab
The preceding section constructed the response to a unit source at the origin. Let's now let the source move and ask how all such responses combine to produce a field. We will keep two positions distinct: $z$ is where the input is placed, and $x$ is where the output is observed. Newtonian gravity gives a concrete example in $bb(R)^(3)$. With the potential $u$ chosen to vanish at infinity, a point mass $M$ at $z$ produces
$
  u(x)=-frac(G M,|x-z|)=K_("grav")(x,z)M,
  quad K_("grav")(x,z):=-frac(G,|x-z|), quad x eq.not z,
$
where $G$ is the gravitational constant. The kernel $K_("grav")$ is the potential per unit source mass.

#paragraph_tab
For finitely many point masses, linearity gives
$
  u(x)=sum_(j=1)^(N)K_("grav")(x,z_(j))m_(j),
  quad x in bb(R)^(3) without {z_(1),dots,z_(N)}.
$
To pass to a continuous mass distribution, let $rho$ be a smooth, compactly supported density. A small cell of volume $Delta V_(j)$ near $z_(j)$ carries approximately $rho(z_(j))Delta V_(j)$ units of mass. The superposition sum becomes
$
  sum_(j)K_("grav")(x,z_(j))rho(z_(j))Delta V_(j)
  arrow.r integral_(bb(R)^(3))K_("grav")(x,z)rho(z) thin d z=:u(x).
$
At a source point, we interpret this passage by first excluding a small ball around $x$ and then shrinking that ball. The singularity is locally integrable: in three dimensions the radial volume factor turns $r^(-1)$ into $r thin d r$. Consequently, the excluded contribution tends to zero for bounded $rho$.

#figure(
  source-mass-superposition-diagram(),
  caption: [Superposition at a fixed observer. The cells schematically represent three-dimensional volume elements; connecting lines indicate source-observer coupling, not force vectors or trajectories.],
) #(s.tag)("mass-superposition")

#paragraph_tab
The physical superposition formula $u(x) = integral K_("grav")(x, z) rho(z) thin d z$ exemplifies the classical goal of operator theory: to represent a linear operator $T$ as a pointwise integral transform:

#definition(title: "Integral kernel")[
Let $(X,mu)$ and $(Z,nu)$ be measure spaces, and let $T$ be a linear operator from a suitable domain of functions on $Z$ to functions on $X$. A function $K_(x): Z arrow.r bb(C)$ is an *integral kernel* for $T$ if
$
  (T f)(x)=integral_(Z)K_(x)(z)f(z) thin d nu(z)
$
for every $f$ in the domain of $T$ for which the integral is defined.
] #(s.tag)("integral-kernel")

#paragraph_tab
In @fundamental_solution_of_laplacian, we constructed the fundamental solution of the Laplacian, $Phi_(3)(x) = -frac(1, 4 pi |x|)$, through the formal machinery of Fourier multipliers and tempered distributions. Having now assembled a global potential field $u(x) = integral K_("grav")(x, z) rho(z) thin d z$ from point-mass contributions, let's understand why the Laplacian is the natural differential operator governing this physical field. The connection is geometric: the Laplacian is the local differential operator of flux conservation for any conservative, inverse-square central field in three dimensions. Differentiating the potential $u(x) = -frac(G M, |x-z|)$ with $nabla_(x) (|x-z|^(-1)) = -frac(x-z, |x-z|^(3))$ gives the gravitational acceleration
$
  bold(g)(x) = - nabla u(x) = - frac(G M(x-z), |x-z|^(3)) = - frac(G M, |x-z|^(2)) frac(x-z, |x-z|).
$
Now enclose the mass distribution in a smooth bounded volume $V subset bb(R)^(3)$ with outward unit normal $bold(n)$. Because a sphere of radius $r$ has surface area $|S^(2)| r^(2) = 4 pi r^(2)$, the geometric expansion of the boundary exactly balances the $r^(-2)$ force decay. Thus the net flux across $partial V$ depends solely on the enclosed mass, yielding Gauss's law for gravity:
#mannot-scope(m => [
  #block(breakable: false, above: 1.2em, below: 1.2em)[
  $
    \

    integral_(V) nabla dot bold(g) thin d z
    = mark(integral.cont_(partial V) bold(g) dot bold(n) thin d S, tag: #(m.tag)("flux-surf"))
    = - 4 pi G M_("enc")
    = mark(- 4 pi G integral_(V) rho(z) thin d z, tag: #(m.tag)("gauss-mass")).
    #annot((m.tag)("flux-surf"), pos: top, dy: -0.6em,
      leader: true, leader-connect: "elbow")[boundary flux across $partial V$]
    #annot((m.tag)("gauss-mass"), pos: top, dy: -0.6em,
      leader: true, leader-connect: "elbow")[$-4pi G$ times enclosed mass]

    \
  $
  ]
], parent: s, name: "gauss-divergence-annotations")
Because this identity holds for every test volume $V$, equating the volume integrands produces the local divergence equation $nabla dot bold(g) = - 4 pi G rho$. Substituting the conservative relation $bold(g) = - nabla u$ yields the *gravitational Poisson equation*:
$
  nabla dot (- nabla u) = - Delta u = - 4 pi G rho
  quad arrow.r.double quad
  Delta u = 4 pi G rho.
$

#paragraph_tab
The Poisson equation connects the gravitational kernel with $Phi_(3)$: it is the local differential representation of inverse-square flux balance. In @fundamental_solution_of_laplacian, the unit-impulse fundamental solution in three dimensions was $Phi_(3)(x) = -frac(1, 4 pi |x|)$ with $Delta Phi_(3) = delta_(0)$ and $|S^(2)| = 4 pi$. Comparing the unit-mass gravitational potential $K_("grav")(x, z) = - frac(G, |x-z|)$ with $Phi_(3)(x-z)$ reveals:
#mannot-scope(m => [
  #block(breakable: false, above: 1.2em, below: 1.2em)[
  $
    bmark(K_("grav")(x,z), tag: #(m.tag)("kernel-grav"))
    = - frac(G, |x-z|)
    = mark(4 pi G, tag: #(m.tag)("norm-factor")) dot lr(- frac(1, 4 pi |x-z|))
    = pmark(4 pi G Phi_(3)(x-z), tag: #(m.tag)("laplace-kernel")).
    #annot((m.tag)("kernel-grav"), pos: top + left, dx: -0.5em, dy: -0.6em,
      leader: true, leader-connect: "elbow")[gravitational kernel]
    #annot((m.tag)("norm-factor"), pos: bottom, dy: 0.6em,
      leader: true, leader-connect: "elbow")[flux factor $|S^(2)| G$]
    #annot((m.tag)("laplace-kernel"), pos: top + right, dx: 0.4em, dy: -0.6em,
      leader: true, leader-connect: "elbow")[fundamental solution $Phi_(3)$]
  $
  ]
], parent: s, name: "kernel-fundamental-annotations")
Applying the distributional Laplacian in the observer variable $x$ therefore yields
$
  Delta_(x) K_("grav")(dot, z) = 4 pi G Delta_(x) Phi_(3)(x-z) = 4 pi G delta_(z).
$
Interpreting differentiation under the integral distributionally gives
$
  Delta u(x)
  &= integral_(bb(R)^(3)) Delta_(x) K_("grav")(x, z) rho(z) thin d z
  \
  &= integral_(bb(R)^(3)) 4 pi G delta(x-z) rho(z) thin d z
  = 4 pi G rho(x),
$
recovering the gravitational Poisson equation. Here the delta records the point source in the differentiated kernel.

#paragraph_tab
We can now read the gravitational calculation as a solution rule for the Poisson equation. Absorb the physical constant into the source by setting $f:=4 pi G rho$. Then the same potential satisfies
$
  u(x)=integral_(bb(R)^(3))Phi_(3)(x-z)f(z) thin d z,
  quad Delta u=f.
$
Here $Phi_(3)(x-z)$ is the response to a unit source at $z$, and integration superposes those responses. This is the convolution construction from the preceding section, now interpreted through the source and observer positions.

#paragraph_tab
To express this construction in the operator language introduced above, let $T$ send each smooth, compactly supported source to its potential:
$
  T:C_(c)^(infinity)(bb(R)^(3)) arrow.r C^(infinity)(bb(R)^(3)),
  quad T f:=Phi_(3)*f.
$
The integral is well-defined because $Phi_(3)$ is locally integrable; smoothness follows by moving derivatives onto $f$ in the convolution. #highlighted[Saying that this rule solves the Poisson equation means that applying $Delta$ to its output recovers its input.] Indeed, since distributional differentiation commutes with convolution with $f$,
$
  Delta(T f)=(Delta Phi_(3))*f=delta_(0)*f=f.
$
Thus $Delta T=I$ on these sources, where $I f=f$. In operator terminology, $T$ is a *right inverse* of $Delta$: first construct the potential, then recover the source by differentiation.

#paragraph_tab
This verification also tells us what a kernel must do when we apply the differential operator to the field. The solution operator $T$ has kernel $K_(T)(x,z)=Phi_(3)(x-z)$. Applying $Delta$ in the observer variable differentiates that kernel, so the distributional identity $Delta_(x)Phi_(3)(x-z)=delta_(z)$ gives
$
  K_(Delta T)(x,z)=Delta_(x)K_(T)(x,z)=delta(x-z)=K_(I)(x,z).
$
What does $delta(x-z)$ mean here? It says that the observer at $x$ receives the input only from the same point $z=x$. In the familiar shorthand,
$
  integral_(bb(R)^(3))delta(x-z)f(z) thin d z=f(x)=(I f)(x).
$
Unlike $Phi_(3)(x-z)$, however, $delta(x-z)$ is not a function with pointwise values. The displayed expression is therefore not an ordinary Lebesgue integral; it abbreviates the action of the Dirac distribution. Geometrically, that distribution is concentrated on the diagonal
$
  op("Diag"):=\{(x,z) in bb(R)^(3) times bb(R)^(3):x=z\},
  quad op("supp")K_(I)=op("Diag").
$
Thus it acts only along the diagonal and vanishes on test functions supported away from it. Here is why the earlier definition of an integral kernel fails. #highlight()[The diagonal has zero six-dimensional Lebesgue measure, so any locally integrable function supported there is zero almost everywhere and represents the zero operator.] Since $I$ is not zero, its kernel must be a distribution. We must describe what this singular kernel does without evaluating it pointwise.

#paragraph_tab
Distributions provide exactly this language: we describe an object by the scalar values it returns when tested against smooth functions. A detector with sensitivity profile $phi$ models such a test as a weighted measurement. Let $X subset.eq bb(R)^(m)$ and $Z subset.eq bb(R)^(n)$ be open sets, with Lebesgue measure. For a locally integrable output, the measurement is
$
  chevron.l T f, phi chevron.r := integral_(X) (T f)(x) phi(x) thin d x,
  quad phi in cal(D)(X).
$
In this section we place the distribution first in the pairing; the preceding section placed the test function first. Both conventions denote the same linear evaluation, without complex conjugation. The same pairing remains meaningful for singular objects; for example, $chevron.l delta_(a),phi chevron.r=phi(a)$ for $a in X$. The detector is only a model: mathematical test functions may change sign and need not have integral one.

#figure(
  distributional-tensor-coupling-diagram(),
  caption: [Pointwise evaluation versus distributional pairing. The test function $phi$ weights the observation variable, and the kernel acts on the tensor product $phi ⊗ f$.],
) #(s.tag)("distributional-tensor-coupling")

#paragraph_tab
To see how testing the output also tests the kernel, let's first return to an ordinary function kernel $K in L^(1)_("loc")(X times Z)$. For $f in cal(D)(Z)$ and $phi in cal(D)(X)$, substitute the integral formula for $T f$ into the output pairing:
$
  chevron.l T f,phi chevron.r
  &=integral_(X)(T f)(x)phi(x) thin d x \
  &=integral_(X)lr(integral_(Z)K(x,z)f(z) thin d z)phi(x) thin d x \
  &=integral_(X times Z)K(x,z)phi(x)f(z) thin d x thin d z.
$
The last equality follows from Fubini's theorem: $phi$ and $f$ are bounded and compactly supported, so their product with the locally integrable kernel is absolutely integrable. Notice what now multiplies $K(x,z)$: the input factor $f(z)$ and the observation factor $phi(x)$ have become a single function $(x,z) arrow.r phi(x)f(z)$ on $X times Z$. This is exactly the kind of test function a kernel needs. The kernel lives on $X times Z$, #highlight[so we must test it with a function on that same product space.] The factor $phi$ depends on the output variable $x$, while $f$ depends on the input variable $z$. We call the resulting two-variable function their *tensor product* and write
$
  (phi ⊗ f)(x,z):=phi(x)f(z).
$
It is smooth, and its support is the compact set $op("supp")phi times op("supp")f$, so $phi ⊗ f in cal(D)(X times Z)$. The notation records the two independent variables; even when $X=Z$, this differs from the one-variable product $phi(x)f(x)$. The calculation above can therefore be written as
$
  chevron.l T f,phi chevron.r=chevron.l K,phi ⊗ f chevron.r.
$
When $K$ is a function, the right side is the double integral we just computed. When $K$ is a distribution, its action on $phi ⊗ f$ is still defined. We use this relation to give meaning to a distribution kernel representing $T$. #highlight[Pairing gives ordinary function kernels and singular kernels the same operational meaning.]

#paragraph_tab
Let's apply this formulation to the identity operator. In the special case $X=Z=bb(R)^(n)$, pairing the identity kernel $delta(x-z)$ with this product gives
$
  chevron.l delta(x-z),phi ⊗ f chevron.r
  =integral_(bb(R)^(n))phi(x)f(x) thin d x
  =chevron.l I f,phi chevron.r.
$
#highlighted[This gives the earlier shorthand $integral delta(x-z)f(z) thin d z=f(x)$ its precise meaning]: the kernel acts on $phi ⊗ f$ without needing pointwise values.

#paragraph_tab
Let's see what this pairing reads in one dimension. In #(s.ref)("diagonal-kernel-support"), choose nonnegative smooth bump functions $phi$ and $f$, positive inside their support intervals. Each point $(x,z)$ records an observer position and a source position. The shaded rectangle is where their product $phi(x)f(z)$ is supported. The identity kernel reads this product only at pairs $(t,t)$ on the diagonal. On the left, the highlighted segment contributes $phi(t)f(t)>0$; on the right, the diagonal misses the rectangle, so the reading is zero. The shading shows support, not the height of either function or the value of the kernel.

#figure(
  diagonal-kernel-support-diagram(),
  caption: [The identity kernel reads matching positions. For the positive bump functions shown, overlapping support intervals give a positive reading; disjoint intervals give zero.],
) #(s.tag)("diagonal-kernel-support")

#definition(title: "Distributional pairing and tensor products")[
Let $X subset.eq bb(R)^(m)$ and $Z subset.eq bb(R)^(n)$ be open sets.
+ For $u in cal(D)^(*)(X)$ and $phi in cal(D)(X)$, the *distributional pairing* is the canonical evaluation
  $
    chevron.l u, phi chevron.r := u(phi) in bb(C).
  $
+ For $phi in cal(D)(X)$ and $f in cal(D)(Z)$, their *tensor product* is the smooth function on $X times Z$ defined by
  $
    (phi ⊗ f)(x, z) := phi(x) f(z),
  $
  and their linear span is the *algebraic tensor product* $cal(D)(X) ⊗ cal(D)(Z) subset.eq cal(D)(X times Z)$.
+ For a distribution $K in cal(D)^(*)(X times Z)$ on the product space, its action on a tensor product test function is denoted by
  $
    chevron.l K, phi ⊗ f chevron.r := K(phi ⊗ f) in bb(C).
  $
] #(s.tag)("distributional-pairing")

#paragraph_tab
With this duality framework established, evaluating a continuous linear map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$ against a test observer $phi in cal(D)(X)$ produces the scalar pairing
$
  B(phi, f) := chevron.l T f, phi chevron.r.
$
Linearly in both arguments, $B(phi, f)$ defines a bilinear form on $cal(D)(X) times cal(D)(Z)$. Representing $T$ by a distribution kernel means finding a single bivariate distribution $K in cal(D)^(*)(X times Z)$ that reproduces this pairing on every tensor product:
$
  chevron.l T f, phi chevron.r = chevron.l K, phi ⊗ f chevron.r.
$

#figure(
  kernel-duality-fletcher-diagram(),
  caption: [Duality commutative diagram of the Schwartz kernel theorem. Evaluating the output distribution $T f$ against the test observer $phi$ on $X$ is canonically equal to evaluating the bivariate distribution kernel $K$ against the tensor product test function $phi ⊗ f$ on $X times Z$.],
) #(s.tag)("kernel-duality-fletcher")

#paragraph_tab
For a known function kernel, Fubini justifies this relation. What if we are given only a continuous linear map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$? The values $B(phi,f)$ determine a linear functional on finite sums of product test functions. The remaining question is whether it extends continuously to all of $cal(D)(X times Z)$. #highlight[The Schwartz kernel theorem guarantees a unique such extension.] It gives a distribution kernel for every continuous linear map between these spaces.#footnote[The present section constructs each required kernel directly and then verifies that it represents the desired operator. The Schwartz kernel theorem, together with the topological definitions and auxiliary lemmas needed for its proof, is therefore developed separately in #link(<schwartz-kernel-theorem-supplement>)[the supplementary section “The Schwartz kernel theorem”]. See Richard Melrose, #link("https://math.mit.edu/~rbm/18.155-F16/L15.pdf")[18.155, Lecture 15 (2016)], for another test-function formulation of the theorem.]
#parbreak()

#paragraph_tab
Let's now make the identity kernel pictured in #(s.ref)("diagonal-kernel-support") precise. In any dimension its diagonal Dirac distribution is written formally as
$
  K_(I)(x,z)=delta(x-z),
  quad (I f)(x)=integral_(bb(R)^(n))delta(x-z)f(z) thin d z=f(x).
$
Precisely, this distribution on the product space $bb(R)^(n) times bb(R)^(n)$ is defined by pairing against general bivariate test functions:
$
  chevron.l K_(I), Psi chevron.r
  :=integral_(bb(R)^(n))Psi(x,x) thin d x,
  quad Psi in cal(D)(bb(R)^(n) times bb(R)^(n)).
$
Taking $Psi=phi ⊗ f$ verifies the kernel relation directly:
$
  chevron.l K_(I),phi ⊗ f chevron.r
  =integral_(bb(R)^(n))phi(x)f(x) thin d x
  =chevron.l I f,phi chevron.r.
$
Its diagonal support expresses that the identity passes each input value to the same location.

=== Translation invariance reduces two positions to one difference

#paragraph_tab
When translating the source and observer together leaves the chosen solution operator unchanged, its kernel satisfies
$
  K(x+a,z+a)=K(x,z).
$
For a continuous kernel, taking $a=-z$ gives $K(x,z)=K(x-z,0)$. Writing $k(r):=K(r,0)$ therefore yields
$
  K(x,z)=k(x-z),
  quad (T f)(x)=integral_(bb(R)^(n))k(x-z)f(z) thin d z=(k*f)(x).
$
In one dimension, the pairs with the same difference lie on a line in the $(x,z)$-plane. Simultaneous translation moves along this line, as shown in #(s.ref)("translation-orbits").

#figure(
  translation-orbit-diagram(),
  caption: [Each line records one difference $r=x-z$. A simultaneous translation moves the pair along that line; choosing $z=0$ selects $(r,0)$. The picture describes coordinates, not pointwise values of a singular kernel.],
) #(s.tag)("translation-orbits")

#paragraph_tab
For a distribution, evaluation on the slice $z=0$ may not exist. To recover the same reduction, we instead integrate test functions along the translation direction. Write $cal(D)'=cal(D)^(*)$ and $cal(S)'=cal(S)^(*)$ for the distribution spaces introduced earlier.

#proposition(title: "Translation invariance characterizes convolution operators")[
Let $T:cal(D)(bb(R)^(n)) arrow.r cal(D)'(bb(R)^(n))$ be continuous and linear. Set $(tau_(a)f)(x)=f(x-a)$, with translation of distributions defined by duality. Then $T tau_(a)=tau_(a)T$ for every $a in bb(R)^(n)$ if and only if there exists $k in cal(D)'(bb(R)^(n))$ such that $T f=k*f$ for every $f in cal(D)(bb(R)^(n))$. In this case, $k$ is unique, and the distribution kernel $K$ of $T$ satisfies, for every $Psi in cal(D)(bb(R)^(n) times bb(R)^(n))$,
$
  chevron.l K,Psi chevron.r=chevron.l k,Q Psi chevron.r,
  quad (Q Psi)(r):=integral_(bb(R)^(n))Psi(r+z,z) thin d z.
$ #(s.tag)("translation-kernel-pairing")
This identity defines the notation $K(x,z)=k(x-z)$ without restricting $K$ to a slice.
]

#paragraph_tab
Let's first unpack the hypothesis. The translated input $tau_(a)f$ moves the source profile by $a$. The equality $T tau_(a)f=tau_(a)(T f)$ says that moving the input and then applying the operator gives exactly the translated original output. Thus the operator has no preferred origin. For a distribution $u$, the precise convention is
$
  chevron.l tau_(a)u,phi chevron.r
  :=chevron.l u,tau_(-a)phi chevron.r,
  quad (tau_(-a)phi)(x)=phi(x+a).
$
The opposite sign on the test function follows by substituting $x=y+a$ in the pairing for an ordinary function. The proposition says that this symmetry is equivalent to describing the whole operator by convolution with a single distribution $k$ of the displacement $r=x-z$.

#proof[
*From translation invariance to convolution.* Assume $T tau_(a)=tau_(a)T$ for every $a$. By the Schwartz kernel theorem, $T$ has a unique distribution kernel $K$. Test a translated input with a translated observer. Commutation and the duality convention give
$
  chevron.l K,(tau_(a)phi) ⊗ (tau_(a)f) chevron.r
  &=chevron.l T(tau_(a)f),tau_(a)phi chevron.r \
  &=chevron.l tau_(a)(T f),tau_(a)phi chevron.r \
  &=chevron.l T f,phi chevron.r
  =chevron.l K,phi ⊗ f chevron.r.
$
The two distributions obtained by translating $K$ simultaneously in both variables and by leaving it unchanged therefore agree on all product test functions. Uniqueness in the kernel theorem implies that they agree on every test function:
$
  chevron.l K,(x,z) arrow.r Psi(x-a,z-a) chevron.r
  =chevron.l K,Psi chevron.r.
$
This is the distributional meaning of $K(x+a,z+a)=K(x,z)$; no pointwise values of $K$ are used.

#paragraph_tab
*Separate displacement from common translation.* Introduce $r=x-z$ and retain $z$ as the second coordinate. The inverse map is $(r,z) arrow.r (r+z,z)$, and its absolute Jacobian is one. Define the transformed distribution by
$
  chevron.l U,Phi chevron.r
  :=chevron.l K,(x,z) arrow.r Phi(x-z,z) chevron.r.
$
For a function kernel, this would say $U(r,z)=K(r+z,z)$. Simultaneous translation of $(x,z)$ leaves $r$ fixed and translates only $z$, so the preceding invariance becomes
$
  chevron.l U,(r,z) arrow.r Phi(r,z-a) chevron.r
  =chevron.l U,Phi chevron.r.
$
Differentiate with respect to $a_(j)$ at $a=0$. This differentiation is valid in the test-function topology: for $a$ near zero the supports stay in one compact set, and every derivative converges uniformly. Consequently,
$
  chevron.l U,partial_(z_(j))H chevron.r=0,
  quad H in cal(D)(bb(R)^(n) times bb(R)^(n)),
  quad j=1,dots,n.
$
Thus $U$ annihilates derivatives in the direction along which the source and observer move together. We must now show that it can read only the total integral of a test function in that direction.

#paragraph_tab
*Why zero integral implies zero pairing.* First consider one translation coordinate $z$. If $F(r,z)$ satisfies $integral F(r,z) thin d z=0$ for every $r$, set
$
  H(r,z):=integral_(-infinity)^(z)F(r,t) thin d t.
$
Then $partial_(z)H=F$. The primitive vanishes below the support of $F$, and above that support it equals the full integral, which is zero. Its $r$ support remains in the compact projection of $op("supp")F$, so $H$ is smooth and compactly supported in all variables. Hence
$
  chevron.l U,F chevron.r
  =chevron.l U,partial_(z)H chevron.r=0.
$
The zero-integral assumption is essential: without it the primitive can remain nonzero arbitrarily far to the right and would no longer be a test function.

#paragraph_tab
For $z=(z_(1),dots,z_(n))$, we apply this argument one coordinate at a time. Choose $eta_(j) in cal(D)(bb(R))$ with $integral eta_(j)=1$, and write $eta(z)=product_(j=1)^(n)eta_(j)(z_(j))$. Define the averaging operation
$
  (P_(j)F)(r,z)
  :=eta_(j)(z_(j))integral_(bb(R))
  F(r,z_(1),dots,z_(j-1),t,z_(j+1),dots,z_(n)) thin d t.
$
Set $F_(0)=F$ and $F_(j)=P_(j)F_(j-1)$. Each difference $F_(j-1)-F_(j)$ has zero integral in $z_(j)$, with all other variables fixed. The one-coordinate primitive construction therefore writes it as $partial_(z_(j))H_(j)$ for a test function $H_(j)$. Adding these differences gives
$
  F-F_(n)=sum_(j=1)^(n)partial_(z_(j))H_(j),
  quad F_(n)(r,z)=eta(z)integral_(bb(R)^(n))F(r,w) thin d w.
$
Since $U$ annihilates every derivative on the right, it has the same pairing with $F$ and $F_(n)$. In particular, if the full $z$ integral of $F$ is zero, then $chevron.l U,F chevron.r=0$.

#paragraph_tab
*Construct the distribution of the displacement.* Using the unit-integral function $eta$ above, define
$
  chevron.l k,psi chevron.r
  :=chevron.l U,(r,z) arrow.r psi(r)eta(z) chevron.r,
  quad psi in cal(D)(bb(R)^(n)).
$
This defines a distribution because $psi arrow.r psi ⊗ eta$ is continuous in the test-function topology. Indeed, a fixed compact support for $psi$ gives a fixed compact product support, and derivatives of the product are bounded by derivatives of $psi$ times fixed derivatives of $eta$. For an arbitrary $Phi$, subtract its normalized average:
$
  F(r,z):=Phi(r,z)-eta(z)integral_(bb(R)^(n))Phi(r,w) thin d w.
$
Its $z$ integral is zero, so the preceding step gives
$
  chevron.l U,Phi chevron.r
  =chevron.l U,eta(z)integral Phi(r,w) thin d w chevron.r
  =chevron.l k,r arrow.r integral Phi(r,z) thin d z chevron.r.
$
This also proves that $k$ does not depend on the chosen $eta$: replacing it by another unit-integral test function changes $psi(r)eta(z)$ by a function whose $z$ integral is zero. In distribution notation, we have proved $U=k ⊗ 1$, where $1$ is the regular distribution that integrates test functions in $z$.

#paragraph_tab
*Return to the original variables.* Take $Phi(r,z)=Psi(r+z,z)$. Then
$
  chevron.l K,Psi chevron.r
  =chevron.l k,r arrow.r integral Psi(r+z,z) thin d z chevron.r
  =chevron.l k,Q Psi chevron.r,
$
which proves #(s.ref)("translation-kernel-pairing"). All the marginals used here are test functions: their supports lie in compact projections of the transformed support, and their derivatives pass under the integral. For a product test function $Psi=phi ⊗ f$, the kernel relation now becomes
$
  chevron.l T f,phi chevron.r
  =chevron.l k,r arrow.r integral phi(r+z)f(z) thin d z chevron.r
  =chevron.l k*f,phi chevron.r.
$
To see the last equality directly, convolution with a test function is the smooth function
$
  (k*f)(x):=chevron.l k,r arrow.r f(x-r) chevron.r.
$
Pairing this function with $phi$ and substituting $z=x-r$ inside the test function gives exactly the preceding integral. Interchanging the pairing and integration is valid because $x$ ranges over $op("supp")phi$, and all the test functions in $r$ then have support in one compact set. Thus $T f=k*f$ as distributions.

#paragraph_tab
*Uniqueness.* Every displacement test function $psi$ is of the form $Q Psi$: choose $Psi(x,z)=psi(x-z)eta(z)$. This is compactly supported because both $x-z$ and $z$ range over compact sets, and
$
  (Q Psi)(r)=psi(r)integral eta(z) thin d z=psi(r).
$
Any other convolution distribution representing $T$ gives the same two-position kernel by uniqueness in the Schwartz kernel theorem. Its pairing with every $psi=Q Psi$ must therefore equal that of $k$, proving uniqueness.

#paragraph_tab
*From convolution to translation invariance.* Conversely, suppose $T f=k*f$ for every test function $f$. The distributional convolution formula gives, for every $a in bb(R)^(n)$,
$
  (k*(tau_(a)f))(x)
  =chevron.l k,r arrow.r f(x-a-r) chevron.r
  =(k*f)(x-a).
$
Thus $T tau_(a)f=tau_(a)(T f)$ for every test function $f$, proving the converse.
]

#paragraph_tab
No decay or temperedness assumption on $k$ is needed here, since $f$ is compactly supported. Although the proposition allows distribution-valued outputs, it shows that each $T f$ is represented by a smooth function; singular behavior is carried by $k$ before it is convolved with the smooth input.

#paragraph_tab
Two examples clarify why $k$ must be allowed to be a distribution. For the identity operator, $k=delta_(0)$ and
$
  (delta_(0)*f)(x)=f(x),
  quad chevron.l K_(I),Psi chevron.r
  =chevron.l delta_(0),Q Psi chevron.r
  =integral Psi(z,z) thin d z.
$
For $T=partial_(j)$, the convolution distribution is $k=partial_(j)delta_(0)$. The minus sign from distributional differentiation cancels the minus sign from differentiating $f(x-r)$:
$
  ((partial_(j)delta_(0))*f)(x)
  =-lr(partial_(r_(j))f(x-r))|_(r=0)
  =partial_(j)f(x).
$
We may think of $k$ as the response to a point source at the origin, but writing $k=T delta_(0)$ is only heuristic under the stated hypotheses: $T$ is defined on test functions, and $delta_(0)$ is not a test function. The proof constructs $k$ without making that unsupported extension.

#paragraph_tab
In the Laplace example, the chosen convolution solution has $k=Phi_(n)$. Translation invariance concerns the entire solution rule, including any conditions used to select it.

#paragraph_tab
A boundary can remove this symmetry. For a homogeneous Dirichlet problem with a Green kernel, the kernel must satisfy both
$
  Delta_(x)K(dot,z)=delta_(z) " in " Omega,
  quad K(x,z)=0 " for " x in partial Omega,
$
with the boundary condition understood in the appropriate trace sense. Moving the source changes its position relative to the fixed boundary. In general, a correction depending separately on $x$ and $z$ is needed to make the free-space response meet that condition. Likewise, variable coefficients make the medium itself depend on position. Some symmetries can survive, but we can no longer assume invariance under every simultaneous translation. The Legendre example at the end of this section will exhibit a kernel with separate dependence on both positions.

#paragraph_tab
For a concrete geometric example, take the half-space $Omega={x in bb(R)^(3):x_(3)>0}$ and reflect $z$ across its boundary to $z^("*")=(z_(1),z_(2),-z_(3))$. The image construction gives
$
  K_(Omega)(x,z)=Phi_(3)(x-z)-Phi_(3)(x-z^("*")).
$
The image point lies outside $Omega$, so its term is harmonic there and $Delta_(x)K_(Omega)(dot,z)=delta_(z)$ in $Omega$. On the boundary, the two distances are equal and the terms cancel, giving the required zero trace. In #(s.ref)("boundary-image"), translating both points upward preserves $|x-z|$ but changes $|x-z^("*")|$. The kernel therefore changes even though the direct separation does not. Translations parallel to the boundary still preserve it.

#figure(
  boundary-image-kernel-diagram(),
  caption: [Cross-sections of the three-dimensional Dirichlet image construction for $Delta$. The hollow image source is outside the domain. Both panels use the same scale and direct separation; only the distance to the reflected source changes.],
) #(s.tag)("boundary-image")

#definition(title: "Convolution kernel")[
Let $T$ be a linear operator on a suitable class of functions or distributions on $bb(R)^(n)$ equipped with Lebesgue measure. A function or distribution $k$ on $bb(R)^(n)$ is a *convolution kernel* for $T$ if
$
  T f=k*f
$
for every $f$ in the domain of $T$. In terms of the general integral kernel $K(x,z)$ on $bb(R)^(n) times bb(R)^(n)$, this corresponds to the translation-invariant form
$
  K(x,z)=k(x-z).
$
] #(s.tag)("convolution-kernel")

#paragraph_tab
The source-response viewpoint also applies to evolution, where the input may be initial data rather than a forcing term in the PDE. For reference, #(s.ref)("kernel-influence-diagram") shows the three-dimensional free-space wave response to initial velocity $delta_(z)$ and zero initial displacement, with speed one. Writing $R_(t)^(3)$ for the three-dimensional initial-velocity convolution kernel, the two-position response is $R_(t)^(3)(x-z)$. Its formula is derived later in this section.

#figure(
  wave-source-observer-diagram(),
  caption: [The wave front reaches $x$ at $t=|x-z|$. The time signal is a distribution; the impulse arrow indicates weight, not finite height.],
) #(s.tag)("kernel-influence-diagram")

#paragraph_tab
We construct the heat, wave, and harmonic-extension kernels by spatial Fourier transformation: solve the resulting ODE at each frequency, then invert the solution multiplier. We first work on $bb(R)^(n)$, $n >= 1$; the final eigenfunction example will return to kernels on an interval. Our Fourier convention is
$
  hat(f)(xi)=(2 pi)^(-n/2) integral_(bb(R)^(n)) e^(-i x dot xi) f(x) thin d x,
  quad cal(F)(-Delta f)(xi)=|xi|^(2)hat(f)(xi).
$
We retain the unitary normalization of the preceding section. In particular, $hat(delta)_(0)=(2 pi)^(-n/2)$ and $cal(F)(K*f)=(2 pi)^(n/2)hat(K)hat(f)$. These constants determine the normalization of every kernel below.

=== From a multiplier to a point-source response

#paragraph_tab
If $cal(F)(T f)=m hat(f)$, the Fourier convolution identity requires
$
  (2 pi)^(n/2)hat(K)hat(f)=m hat(f).
$

#definition(title: "Convolution kernel produced by a Fourier multiplier")[
Let $m$ be a measurable function with $|m(xi)| <= C(1+|xi|)^(N)$ for some $C,N >= 0$. Define
$
  T f:=cal(F)^(-1)(m hat(f)), quad f in cal(S)(bb(R)^(n)),
  quad K:=(2 pi)^(-n/2)cal(F)^(-1)m.
$ #(s.tag)("multiplier-kernel")
Here $m$ and $K$ are interpreted as tempered distributions. Then $K$ is the convolution kernel of $T$.
]

#paragraph_tab
Indeed, convolution of a tempered distribution with a Schwartz function is defined, and the Fourier convolution identity gives $T f=K*f$. If $m$ is integrable, Fourier inversion gives the ordinary integral
$
  K(x)=(2 pi)^(-n)integral_(bb(R)^(n))e^(i x dot xi)m(xi) thin d xi.
$
Otherwise, the inverse transform remains meaningful in $cal(S)'$. A singular kernel is therefore part of the same construction.

#paragraph_tab
The notation $K=T delta_(0)$ expresses its point-source meaning whenever $T$ has the required extension to that datum. Even when $T$ is initially defined only on functions, the formula for $K$ above gives a precise meaning to this notation. It does not claim that $T$ acts on every tempered distribution.

#note(title: "Three different roles for a kernel")[
Distinguish initial-data propagation, a spatial point-source equation $L K=delta_(0)$, and a causal space-time point-source equation. Their defining data differ; convolution form additionally requires spatial translation invariance.
]

=== Which multipliers do the evolution equations give?

#paragraph_tab
Transforming only $x$ replaces $Delta$ by $-|xi|^(2)$ and leaves time or height derivatives unchanged. Take Schwartz initial data for heat and waves, and $L^(2)$ boundary data for harmonic extension.

#paragraph_tab
For the heat equation $u_(t)-Delta u=0$ with $u(0)=f$, each frequency solves a first-order decay equation:
$
  partial_(t)hat(u)(t,xi)=-|xi|^(2)hat(u)(t,xi),
  quad hat(u)(0,xi)=hat(f)(xi), \
  hat(u)(t,xi)=e^(-t|xi|^(2))hat(f)(xi), quad t>=0.
$ #(s.tag)("heat-multiplier")
High spatial frequencies decay faster because their decay rate is $|xi|^(2)$.

#paragraph_tab
For the half-space Laplace equation $u_(y y)+Delta_(x)u=0$, the variable $y>0$ is height above the boundary. The transformed equation is
$
  partial_(y)^(2)hat(u)(y,xi)=|xi|^(2)hat(u)(y,xi).
$
For $xi eq.not 0$, its two modes are $e^(y|xi|)$ and $e^(-y|xi|)$. The boundary condition $u(0)=f$ alone does not choose between them. Requiring the extension to stay uniformly bounded in $L^(2)$ for all heights excludes the growing branch and selects
$
  hat(u)(y,xi)=e^(-y|xi|)hat(f)(xi).
$ #(s.tag)("poisson-multiplier")
The single frequency $xi=0$ has measure zero and does not change the $L^(2)$ formula. The choice of decay explains which harmonic extension we are constructing.

#paragraph_tab
For the wave equation $u_(t t)-Delta u=0$ with $u(0)=f$ and $u_(t)(0)=g$, each frequency is a harmonic oscillator:
$
  partial_(t)^(2)hat(u)(t,xi)+|xi|^(2)hat(u)(t,xi)=0, \
  hat(u)(t,xi)=cos(t|xi|)hat(f)(xi)+b_(t)(|xi|)hat(g)(xi),
$ #(s.tag)("wave-multiplier")
where $b_(t)(a)=sin(t a)/a$ for $a>0$ and $b_(t)(0)=t$. This value at zero is the continuous limit; it also gives the zero-frequency solution $hat(f)(0)+t hat(g)(0)$ for Schwartz data. Heat damps frequencies, whereas waves evolve them by oscillation.

=== From the common frequency factor to the operator A

#paragraph_tab
The multipliers in #(s.ref)("heat-multiplier"), #(s.ref)("poisson-multiplier"), and #(s.ref)("wave-multiplier") all depend on the same scalar quantity $a=|xi|$. Their scalar functions are
$
  e^(-t a^(2)), quad e^(-y a), quad cos(t a), quad b_(t)(a).
$
This suggests a useful question: which spatial operator corresponds to multiplication by $|xi|$? Defining that operator will let us express all three evolutions as functions of one spatial operator.

#definition(title: "The spatial frequency operator")[
On $L^(2)(bb(R)^(n))$, define
$
  A f:=cal(F)^(-1)(|xi|hat(f)(xi)),
  quad cal(D)(A):={f in L^(2): |xi|hat(f) in L^(2)}.
$ #(s.tag)("frequency-operator")
The domain consists of exactly those data for which the output of this multiplication is still in $L^(2)$.
]

#paragraph_tab
To relate $A$ to the Laplacian, let's apply it twice. For $f$ in the domain of $A^(2)$,
$
  cal(F)(A^(2)f)(xi)
  =|xi|cal(F)(A f)(xi)
  =|xi|^(2)hat(f)(xi)
  =cal(F)(-Delta f)(xi).
$
The domain of this square is ${f in L^(2): |xi|^(2)hat(f) in L^(2)}$. Indeed, this condition also implies $|xi|hat(f) in L^(2)$: use $|xi|<=1$ near zero and $|xi|<=|xi|^(2)$ for $|xi|>=1$. Thus both operators agree on the same domain.

#paragraph_tab
Multiplication by the real nonnegative function $|xi|$, with its maximal $L^(2)$ domain, is self-adjoint and nonnegative. The unitary Fourier transform transfers these properties to $A$. Consequently,
$
  A^(2)=-Delta, quad A=sqrt(-Delta).
$ #(s.tag)("square-root-laplacian")
The square-root notation now records what we have constructed: $A$ is the nonnegative self-adjoint square root of $-Delta$.

#paragraph_tab
We can next replace each scalar function of $a$ by the corresponding operator. For a bounded Borel function $h$ on $[0,infinity)$, define
$
  h(A)f:=cal(F)^(-1)(h(|xi|)hat(f)(xi)).
$ #(s.tag)("functional-calculus")
This construction is called *functional calculus*. It is the same principle as applying $h$ to each diagonal entry of a diagonal matrix: Fourier transformation represents $A$ by multiplication, and we apply $h$ to that multiplier. Plancherel's theorem gives $norm(h(A)f)_(2)<=norm(h)_(infinity)norm(f)_(2)$, so the definition acts on all of $L^(2)$ for bounded $h$.

#paragraph_tab
The three frequency formulas can now be written as spatial solution operators:
$
  "Heat:" &quad u(t)=e^(-t A^(2))f=e^(t Delta)f, \
  "Poisson extension:" &quad u(y)=e^(-y A)f, \
  "Wave:" &quad u(t)=cos(t A)f+b_(t)(A)g.
$ #(s.tag)("evolution-operators")
Here heat time satisfies $t>=0$, height satisfies $y>0$, and wave time may be any real number. These formulas restate the multipliers already derived. Exponential notation follows #(s.ref)("functional-calculus") and does not assume that an operator power series converges on every datum. Likewise, $sin(t A)/A$ means the combined bounded multiplier $b_(t)(A)$, without separately applying $A^(-1)$. The common construction is summarized in #(s.ref)("frequency-operator-map").

#figure(
  frequency-operator-map(),
  caption: [Functional calculus applies a scalar function to the spatial frequency $a=|xi|$. The same transform-multiply-invert construction produces each evolution operator.],
) #(s.tag)("frequency-operator-map")

#paragraph_tab
The benefit of this notation will appear when we relate kernels: a scalar identity connecting $e^(-y a)$ and $e^(-t a^(2))$ will connect Poisson and heat evolution, and Fourier inversion in $a$ will build $h(A)$ from waves. We first need one explicit kernel to use in those constructions.

#note(title: "The data space is part of the formula")[
The heat and wave multipliers are smooth in $xi$, with polynomially bounded derivatives, and hence act on all of $cal(S)'$ by duality. In contrast, $e^(-y|xi|)$ is not smooth at $xi=0$, so multiplication by it is not defined on arbitrary tempered distributions. We use the Poisson operator on $L^(2)$, and construct its point-source kernel by inverse transformation of its integrable multiplier. These statements are compatible: a particular point source can be admissible even when arbitrary distributional data are not.
]

=== Direct inversion: the heat kernel

#block(sticky: true, above: 0.65em, below: 0.3em)[

#paragraph_tab
We begin with the heat multiplier from #(s.ref)("heat-multiplier"), $m_(t)(xi)=e^(-t|xi|^(2))$, $t>0$. Substituting it into #(s.ref)("multiplier-kernel") and taking the inverse Gaussian transform yields
]
$
  p_(t)(x)
  &=(2 pi)^(-n)integral_(bb(R)^(n))e^(-t|xi|^(2)+i x dot xi) thin d xi \
  &=(2 pi)^(-n)(pi/t)^(n/2)e^(-|x|^(2)/(4t)) \
  &=(4 pi t)^(-n/2)e^(-|x|^(2)/(4t)).
$ #(s.tag)("heat-kernel")
Thus $e^(-t A^(2))f=p_(t)*f$. The Gaussian is positive, has integral one, and satisfies $p_(t)(x)=t^(-n/2)p_(1)(x/sqrt(t))$.

#paragraph_tab
The initial point source is recovered through probes. For every $phi in cal(S)$, dominated convergence gives
$
  chevron.l p_(t),phi chevron.r
  =integral_(bb(R)^(n))p_(1)(z)phi(sqrt(t)z) thin d z
  arrow.r phi(0)=chevron.l delta_(0),phi chevron.r.
$
Hence $p_(t) arrow.r delta_(0)$ distributionally as $t arrow.r 0^(+)$. More generally, $p_(t)*f arrow.r f$ in the distributional sense for $f in cal(S)'$, because multiplication by $e^(-t|xi|^(2))$ tends to the identity on Schwartz test functions. For positive time, $p_(t)*f$ is smooth: differentiating the translated Gaussian inside the distributional pairing gives every spatial derivative.

#paragraph_tab
We can already read the propagation behavior from the kernel. Since $p_(t)(x)>0$ everywhere, heat has no finite propagation radius. Also,
$
  p_(t)*p_(s)=p_(t+s), quad s,t>0,
$
because the corresponding multipliers multiply to $e^(-(t+s)|xi|^(2))$. Evolving for two successive time intervals gives the same result as evolving for their sum.

=== Subordination: construct the Poisson kernel from heat

#paragraph_tab
Now that #(s.ref)("heat-kernel") gives us an explicit heat kernel, let's use it to construct the Poisson kernel. We need the multiplier $e^(-y|xi|)$ from #(s.ref)("poisson-multiplier"). Can we express it as a weighted average of the Gaussian multipliers we already inverted? The following scalar identity supplies exactly that representation.

#lemma(title: "Scalar subordination identity")[
For $a>=0$ and $y>0$,
$
  e^(-y a)=frac(y,2 sqrt(pi))integral_(0)^(infinity)
    e^(-y^(2)/(4t))t^(-3/2)e^(-t a^(2)) thin d t.
$ #(s.tag)("subordination")
]

#proof[
To evaluate the integral, set $r=y/(2sqrt(t))$ and $b=y a/2$. Its right side becomes $2 J(b)/sqrt(pi)$, where
$
  J(b):=integral_(0)^(infinity)e^(-r^(2)-b^(2)/r^(2)) thin d r.
$
For $b>0$, differentiation under the integral is justified by the exponential decay at both endpoints. Substituting $s=b/r$ in the resulting integral gives
$
  J'(b)
  &=-2b integral_(0)^(infinity)r^(-2)e^(-r^(2)-b^(2)/r^(2)) thin d r \
  &=-2 integral_(0)^(infinity)e^(-s^(2)-b^(2)/s^(2)) thin d s=-2J(b).
$
Dominated convergence gives $J(0)=sqrt(pi)/2$. Solving this first-order ODE and taking the continuous limit at zero yields $J(b)=sqrt(pi)e^(-2b)/2$, which proves the identity.
]

#block(sticky: true, above: 0.65em, below: 0.3em)[

#paragraph_tab
Define the positive weight
]
$
  w_(y)(t):=frac(y,2sqrt(pi))e^(-y^(2)/(4t))t^(-3/2).
$
Setting $a=0$ in #(s.ref)("subordination") shows $integral_(0)^(infinity)w_(y)(t) thin d t=1$. Applying the same identity at $a=|xi|$ gives, for $f in L^(2)$,
$
  e^(-y A)f=integral_(0)^(infinity)w_(y)(t)e^(-t A^(2))f thin d t.
$
The integral converges in $L^(2)$, since the heat operators are contractions and the weight has total mass one. This construction is called *subordination*: a Poisson extension is an average of heat evolutions over different heat times.

#paragraph_tab
To construct its spatial kernel, mix the heat kernels from #(s.ref)("heat-kernel") using the same weight. Positivity and unit mass justify interchanging the spatial and time integrals. With $B=y^(2)+|x|^(2)$, we obtain
$
  P_(y)(x)
  &=integral_(0)^(infinity)w_(y)(t)p_(t)(x) thin d t \
  &=frac(y,(4pi)^((n+1)/2))integral_(0)^(infinity)
      e^(-B/(4t))t^(-(n+3)/2) thin d t \
  &=frac(y,(4pi)^((n+1)/2))(4/B)^((n+1)/2)
      integral_(0)^(infinity)e^(-s)s^((n-1)/2) thin d s \
  &=frac(Gamma((n+1)/2),pi^((n+1)/2))
      frac(y,(y^(2)+|x|^(2))^((n+1)/2)).
$ #(s.tag)("poisson-kernel")
The third line uses $s=B/(4t)$, including the reversed integration limits. The last integral is the defining Gamma integral.

#paragraph_tab
Consequently, $e^(-y A)f=P_(y)*f$. Its multiplier verifies $(partial_(y)^(2)+Delta)P_(y)=0$ for $y>0$. Dominated convergence in frequency space gives $P_(y)*f arrow.r f$ in $L^(2)$ as $y arrow.r 0^(+)$. The kernel has mass one and scales as $P_(y)(x)=y^(-n)P_(1)(x/y)$, so it also approaches $delta_(0)$ distributionally. Its spatial scale is $y$, while that of heat at time $t$ is $sqrt(t)$. In #(s.ref)("subordination-mixture"), the heat profiles use one common scale, so their widening and decreasing peak height are visible. The Poisson profile is the continuous mixture over all positive heat times.

#figure(
  subordination-mixture-diagram(),
  caption: [Subordination in one spatial dimension with $y=1$. Three unit-mass heat profiles illustrate the family being averaged; the right curve is the exact Poisson profile, not the sum of the three samples. The horizontal and vertical scales agree across the two plots.],
) #(s.tag)("subordination-mixture")

=== Time integration: construct a resolvent kernel

#paragraph_tab
There is another way to use the heat kernel. To solve an elliptic equation, we want division by its symbol. The elementary Laplace integral writes that division as an integral of heat multipliers:
$
  frac(1,lambda^(2)+|xi|^(2))
  =integral_(0)^(infinity)e^(-lambda^(2)t)e^(-t|xi|^(2)) thin d t,
  quad lambda>0.
$
Thus the resolvent, meaning the indicated shifted inverse, is
$
  (lambda^(2)-Delta)^(-1)f
  =integral_(0)^(infinity)e^(-lambda^(2)t)e^(t Delta)f thin d t,
  quad f in L^(2).
$
This integral has operator norm at most $lambda^(-2)$. Multiplying its Fourier transform by $lambda^(2)+|xi|^(2)$ verifies the inverse identity and shows that the result belongs to the domain of $-Delta$.

#paragraph_tab
Its kernel is therefore
$
  G_(lambda)(x):=integral_(0)^(infinity)e^(-lambda^(2)t)p_(t)(x) thin d t,
  quad (lambda^(2)-Delta)G_(lambda)=delta_(0).
$
The integral defines a nonnegative $L^(1)$ function up to values on a set of measure zero, with integral $lambda^(-2)$; it may be singular at the origin. In dimension three, #(s.ref)("subordination") with $y=r=|x|>0$ and $a=lambda$ evaluates it directly:
$
  G_(lambda)(x)
  &=(4pi)^(-3/2)integral_(0)^(infinity)t^(-3/2)
      e^(-r^(2)/(4t)-lambda^(2)t) thin d t \
  &=frac(e^(-lambda r),4pi r).
$
As $lambda arrow.r 0^(+)$, these kernels converge in $cal(S)'(bb(R)^(3))$ to $G_(0)(x)=1/(4pi|x|)$. Indeed, $frac(1,|x|)$ is locally integrable in three dimensions and integrable against the absolute value of any Schwartz function at infinity, so dominated convergence applies. Passing to the limit in the distributional equation gives
$
  -Delta G_(0)=delta_(0).
$
This is the negative of the fundamental solution for $Delta$ in @fundamental_solution_of_laplacian. The sign changes because we are now inverting $-Delta$. Kernel convergence here does not assert convergence to a bounded inverse of $-Delta$ on all of $L^(2)$; the multiplier $|xi|^(-2)$ is unbounded near zero.

=== Wave kernels: a point source can remain singular

#paragraph_tab
The wave solution in #(s.ref)("wave-multiplier") has two terms because its initial data specify both displacement and velocity. Let's first construct the response to a point source in initial velocity. Applying #(s.ref)("multiplier-kernel") to $b_(t)(|xi|)$ gives
$
  R_(t):=(2pi)^(-n/2)cal(F)^(-1)lr(frac(sin(t|xi|),|xi|)).
$
The quotient is given its value $t$ at zero. Its power series contains only powers of $|xi|^(2)$, so it is smooth at the origin. Both this multiplier and $cos(t|xi|)$ act on $cal(S)'$. Differentiation in time gives
$
  R_(0)=0, quad partial_(t)R_(0)=delta_(0),
  quad partial_(t)^(2)R_(t)=Delta R_(t).
$
The solution is consequently
$
  u(t)=(partial_(t)R_(t))*f+R_(t)*g.
$
Initially we may take $f,g in cal(S)$. The compact support of the wave kernels, established below, also makes these convolutions meaningful for arbitrary tempered distributions.

#proposition(title: "The three-dimensional velocity kernel")[
In $bb(R)^(3)$ and for $t>0$, the wave kernel is the surface distribution
$
  chevron.l R_(t),phi chevron.r
  =frac(1,4pi t)integral_(|x|=t)phi(x) thin d S(x),
  quad phi in cal(S)(bb(R)^(3)).
$ #(s.tag)("sphere-kernel")
]

#proof[
To identify the distribution, compute its Fourier transform. Rotate the polar axis toward $xi$ and put $a=|xi|$. The spherical integral is
$
  integral_(S^(2))e^(-i t omega dot xi) thin d S(omega)
  =2pi integral_(-1)^(1)e^(-i t a s) thin d s
  =4pi frac(sin(t a),t a),
$
with the continuous value $4pi$ at $a=0$. Since surface measure on the radius-$t$ sphere is $t^(2)d S(omega)$, the Fourier transform of the proposed distribution is
$
  (2pi)^(-3/2)frac(t^(2),4pi t)4pi frac(sin(t a),t a)
  =(2pi)^(-3/2)frac(sin(t a),a).
$
This is precisely $hat(R)_(t)$, and the Fourier transform is injective on $cal(S)'$.
]

#paragraph_tab
Thus, for smooth initial velocity $g$,
$
  (R_(t)*g)(x)=frac(1,4pi t)integral_(|z-x|=t)g(z) thin d S(z).
$
The familiar spherical mean is convolution with a distribution concentrated on a sphere. The kernel is often written $delta(|x|-t)/(4pi t)$; the pairing in #(s.ref)("sphere-kernel") specifies exactly what that notation means.

#figure(
  wave-kernel-descent-diagram(),
  caption: [Descent projects both sphere sheets onto the disk; their surface weights add. Colored section segments have equal projected radial widths but unequal lifted lengths, illustrating the slope factor. They are not area patches. Fixed $t>0$.],
) #(s.tag)("descent-figure")

#paragraph_tab
We can now construct the two-dimensional kernel without another Fourier inversion. In #(s.ref)("descent-figure"), each interior point $x$ receives contributions from two sphere points. Project the surface distribution in #(s.ref)("sphere-kernel") onto the first two coordinates. On the sphere, the two graphs over $|x|<t$ are $z=plus.minus sqrt(t^(2)-|x|^(2))$. Each graph has surface element $t/sqrt(t^(2)-|x|^(2)) thin d x$. Adding their contributions gives
$
  R_(t)^(2)(x)=frac(bold(1)_( {|x|<t} ),2pi sqrt(t^(2)-|x|^(2))).
$ #(s.tag)("disk-kernel")
Here the superscript denotes spatial dimension. Let $pi_(2)(x,z)=x$ be the projection from three to two dimensions. For a compactly supported distribution $V$, its pushforward is defined by $chevron.l (pi_(2))_(*)V,phi chevron.r=chevron.l V,(x,z) arrow.r phi(x) chevron.r$; a cutoff equal to one near $op("supp")V$ makes the right side a valid test pairing. With our unitary Fourier convention, integrating out one spatial coordinate contributes a factor $sqrt(2pi)$:
$
  cal(F)_(2)R_(t)^(2)(xi)
  &=sqrt(2pi)cal(F)_(3)R_(t)^(3)(xi,0) \
  &=sqrt(2pi)(2pi)^(-3/2)frac(sin(t|xi|),|xi|)
  =(2pi)^(-1)frac(sin(t|xi|),|xi|).
$
This is exactly the required two-dimensional normalization. The quotient takes its continuous value $t$ at zero. This construction is the *method of descent*. The weight in #(s.ref)("disk-kernel") grows toward the rim, as the graph becomes steeper in #(s.ref)("descent-figure"). The singularity at the circle is integrable, and the entire disk contributes. Descending once more, for $|x|<t$, gives
$
  R_(t)^(1)(x)
  =frac(1,2pi)integral_(-sqrt(t^(2)-x^(2)))^(sqrt(t^(2)-x^(2)))
    frac(1,sqrt(t^(2)-x^(2)-z^(2))) thin d z
  =frac(1,2).
$
Outside the interval it vanishes. Projection is legitimate here because the distributions have compact support.

#paragraph_tab
These formulas distinguish two geometric statements. *Finite propagation* means that the response is supported in the closed ball of radius $|t|$. In three dimensions the stronger *strict Huygens principle* holds: for $t>0$, the response is supported on the sphere itself. In dimensions one and two the velocity kernel has an interior tail. The three-dimensional sphere and the two-dimensional disk are therefore different propagation patterns, even though both have speed one. The comparison in #(s.ref)("kernel-support-comparison") records supports only, keeping this geometric distinction separate from the size or singularity of a kernel.

#figure(
  kernel-support-comparison-diagram(),
  caption: [Supports at a fixed $t>0$. Heat has support throughout space; the three-dimensional velocity kernel lies on a sphere; the two-dimensional velocity kernel fills the closed disk. The three-dimensional panels show central sections. Shading records support, not amplitude.],
) #(s.tag)("kernel-support-comparison")

#paragraph_tab
In any dimension, the local energy argument of @finite_propagation_speed gives the ball support of $R_(t)$ and $partial_(t)R_(t)$. To apply it to the point source, approximate $delta_(0)$ by smooth functions supported in a ball of radius $epsilon$. Their wave solutions are supported in the ball of radius $|t|+epsilon$, and converge distributionally to the multiplier-defined kernels. Testing outside the limiting ball proves
$
  op("supp")R_(t) subset.eq {x:|x|<=|t|},
  quad op("supp")(partial_(t)R_(t)) subset.eq {x:|x|<=|t|}.
$ #(s.tag)("wave-support")
Negative times are determined by $R_(-t)=-R_(t)$.

=== Wave synthesis: construct functions of the Laplacian

#paragraph_tab
We have built Poisson and resolvent kernels from heat. Waves provide a more general construction. Let $h in cal(S)(bb(R))$ be even, and let $hat(h)$ denote its one-dimensional unitary Fourier transform. Fourier inversion and evenness give
$
  h(a)
  =frac(1,sqrt(2pi))integral_(bb(R))hat(h)(s)e^(i s a) thin d s
  =frac(1,sqrt(2pi))integral_(bb(R))hat(h)(s)cos(s a) thin d s.
$
The sine term integrates to zero because its integrand is odd. Substituting $a=|xi|$ proves the following identity for $f in L^(2)$. The two marked factors separate how much of each wave we use from how far that wave can propagate.
#mannot-scope(m => [
  #block(breakable: false, above: 1.8em, below: 1.8em)[
  $
    h(A)f=frac(1,sqrt(2pi))integral_(bb(R))
      mark(hat(h)(s), tag: #(m.tag)("weight"))
      mark(cos(s A)f, tag: #(m.tag)("wave")) thin d s.
    #annot((m.tag)("weight"), pos: top + left, dx: -0.5em, dy: -0.6em,
      leader: true, leader-connect: "elbow")[wave synthesis weight]
    #annot((m.tag)("wave"), pos: bottom + right, dx: 0.5em, dy: 0.6em,
      leader: true, leader-connect: "elbow")[propagation distance $<=|s|$]
  $ #(s.tag)("wave-synthesis")
  ]
], parent: s, name: "synthesis-annotations")
This is an $L^(2)$-valued integral: $norm(cos(s A)f)_(2)<=norm(f)_(2)$ and $hat(h) in L^(1)$. The scalar identity identifies its Fourier multiplier, which justifies the operator equality.

#block(sticky: true, above: 0.65em, below: 0.3em)[

#paragraph_tab
At the kernel level, #(s.ref)("wave-synthesis") becomes
]
$
  K_(h):=(2pi)^(-n/2)cal(F)^(-1)(h(|xi|))
  =frac(1,sqrt(2pi))integral_(bb(R))hat(h)(s)partial_(s)R_(s) thin d s.
$ #(s.tag)("kernel-synthesis")
The right side is interpreted after pairing with a Schwartz test function. Those pairings are uniformly bounded in $s$, since $|cos(s|xi|)|<=1$ and the Fourier transform of the test function is integrable. Thus the distributional integral is well-defined. The variable $s$ is wave time, dual to the spectral variable $a$; the next condition concerns $hat(h)(s)$, not the support of $h(a)$.

#proposition(title: "Fourier support of the multiplier bounds spatial support")[
If $h in cal(S)(bb(R))$ is even and $op("supp")hat(h) subset.eq [-L,L]$ for some $L>0$, then
$
  op("supp")K_(h) subset.eq {x:|x|<=L}.
$
]

#proof[
Take a compactly supported smooth test function $phi$ whose support is outside the closed radius-$L$ ball. For $|s|<=L$, #(s.ref)("wave-support") gives $chevron.l partial_(s)R_(s),phi chevron.r=0$. For $|s|>L$, the coefficient $hat(h)(s)$ vanishes. Pairing #(s.ref)("kernel-synthesis") with $phi$ therefore gives zero, which is the required support statement.
]

#paragraph_tab
For example, with $h(a)=e^(-t a^(2))$ and fixed $t>0$, the one-dimensional Gaussian transform gives
$
  e^(t Delta)f=frac(1,sqrt(4pi t))integral_(bb(R))
    e^(-s^(2)/(4t))cos(s A)f thin d s.
$
Each wave operator has finite propagation distance $|s|$, but this integral includes arbitrarily large $|s|$. The formula is therefore consistent with the heat kernel being positive at every spatial point.

=== Eigenfunction expansions construct kernels too

#paragraph_tab
Fourier waves are one choice of spatial modes. To see how the general definition in #(s.ref)("integral-kernel") also covers separation of variables, suppose a nonnegative self-adjoint operator $L$ on $L^(2)(Omega,d mu)$ has a complete orthonormal eigenbasis $(phi_(j))$ with eigenvalues $lambda_(j)$. Expanding $f$ and evolving each coefficient gives
$
  e^(-t L)f(x)
  &=sum_(j)e^(-t lambda_(j))phi_(j)(x)
    integral_(Omega)overline(phi_(j)(z))f(z) thin d mu(z).
$
The series converges in $L^(2)$. Whenever the kernel series converges in a suitable function or distribution space, it identifies
$
  K_(t)(x,z)=sum_(j)e^(-t lambda_(j))phi_(j)(x)overline(phi_(j)(z)).
$
Pointwise convergence of this kernel series needs additional information about the eigenfunctions; it does not follow from the abstract eigenbasis assumption alone.

#block(sticky: true, above: 0.65em, below: 0.3em)[

#paragraph_tab
For a concrete instance, use the self-adjoint Legendre realization of
]
$
  L=-frac(d,d x)lr((1-x^(2))frac(d,d x))
$
on $L^(2)(-1,1)$ selected by its complete normalized Legendre eigenbasis. Since $L P_(ell)=ell(ell+1)P_(ell)$ and
$
  integral_(-1)^(1)P_(ell)(x)P_(k)(x) thin d x
  =frac(2,2ell+1)delta_(ell k),
$
the heat kernel is
$
  K_(t)(x,z)=sum_(ell=0)^(infinity)e^(-t ell(ell+1))
    frac(2ell+1,2)P_(ell)(x)P_(ell)(z), quad t>0.
$
The standard bound $|P_(ell)(x)|<=1$ on $[-1,1]$ (see #link("https://dlmf.nist.gov/18.14.E1")[DLMF 18.14.1] with Jacobi parameters zero) makes this series absolutely and uniformly convergent for each positive time. Its coefficients are the same coefficients obtained by separation of variables. Here the kernel depends separately on $x$ and $z$, since the Legendre operator is not translation invariant.

#paragraph_tab
The choice of operator realization, geometry, and initial or boundary conditions determines which kernel we must construct. Fourier inversion builds it from continuous frequency modes; eigenfunction expansions build it from discrete modes; subordination and wave synthesis build it from known evolution kernels. Once constructed, its mass, singularities, and support explain how that particular PDE responds to a localized input.
])
