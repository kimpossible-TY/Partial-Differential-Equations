#import "../Styles/styles.typ": *
#import "figures/figures.typ": translation-orbit-diagram, subordination-mixture-diagram, source-mass-superposition-diagram, diagonal-kernel-support-diagram, distributional-tensor-coupling-diagram, kernel-duality-fletcher-diagram, compact-primitive-diagram, noncompact-primitive-diagram, coordinate-averaging-diagram, coordinate-averaging-surfaces
#import "@preview/mannot:0.4.0": *

#let translation-convolution-video-url = "https://github.com/kimpossible-TY/Partial-Differential-Equations/releases/download/translation-invariance-convolution-v1/translation-invariance-convolution-v1.mp4"
#let coordinate-averaging-video-url = "https://github.com/kimpossible-TY/Partial-Differential-Equations/releases/download/coordinate-averaging-video-v1/eta-lifting-en-3d-1.25x.mp4"

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
#emphasis(title : "Intuition of test functions used for distributional pairing")[
  + $f(z)$ : describes the input at the source point $z$.
  + $phi(x)$ : weights the output at the observation point $x$.
]

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
For a known function kernel, Fubini justifies this relation. What if we are given only a continuous linear map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$? The values $B(phi,f)$ determine a linear functional on finite sums of product test functions. The remaining question is whether it extends continuously to all of $cal(D)(X times Z)$. #highlight[The Schwartz kernel theorem(@schwartz-kernel-theorem) guarantees a unique such extension.] It gives a distribution kernel for every continuous linear map between these spaces.#footnote[The present section constructs each required kernel directly and then verifies that it represents the desired operator. The Schwartz kernel theorem, together with the topological definitions and auxiliary lemmas needed for its proof, is therefore developed separately in #link(<schwartz-kernel-theorem-supplement>)[the supplementary section “The Schwartz kernel theorem”]. See Richard Melrose, #link("https://math.mit.edu/~rbm/18.155-F16/L15.pdf")[18.155, Lecture 15 (2016)], for another test-function formulation of the theorem.]
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
The gravitational kernel depends on the displacement $x-z$ between source and observer. Let's identify the symmetry behind this dependence. Recall that $z$ records where the input is placed, while $x$ records where its output is observed. Moving the input by $a$ should move the output by the same amount whenever the chosen solution rule has no preferred origin. We first define this movement for both functions and distributions.

#definition(title: "Translation operator")[
Let $a in bb(R)^(n)$. For $f in cal(D)(bb(R)^(n))$, its *translation by* $a$ is the test function
$
  (tau_(a)f)(x):=f(x-a).
$
For $u in cal(D)^(*)(bb(R)^(n))$, its translation is defined by duality:
$
  chevron.l tau_(a)u,phi chevron.r
  :=chevron.l u,tau_(-a)phi chevron.r,
  quad phi in cal(D)(bb(R)^(n)),
$ #(s.tag)("translation-operator condition")
where $(tau_(-a)phi)(x)=phi(x+a)$.
] #(s.tag)("translation-operator")

For a locally integrable function $u$, the opposite sign in the duality definition follows by substituting $x=y+a$:
$
  chevron.l tau_(a)u,phi chevron.r
  =integral u(x-a)phi(x) thin d x
  =integral u(y)phi(y+a) thin d y
  =chevron.l u,tau_(-a)phi chevron.r.
$

#paragraph_tab
We can also express #(s.ref)("translation-operator condition") by translating the distribution and the test function together:
$
  chevron.l tau_(a)u,tau_(a)psi chevron.r
  =chevron.l u,tau_(-a)(tau_(a)psi) chevron.r
  =chevron.l u,psi chevron.r.
$
Thus moving both the field and its test observer by the same amount preserves the measured pairing. Could we take this identity itself as the definition of $tau_(a)u$? Yes, provided we require it for every $psi in cal(D)(bb(R)^(n))$. Translation is a bijection of the test-function space with inverse $tau_(-a)$, so every test function $phi$ has the unique form $phi=tau_(a)psi$, with $psi=tau_(-a)phi$. The simultaneous-translation identity therefore gives
$
  chevron.l tau_(a)u,phi chevron.r
  =chevron.l u,psi chevron.r
  =chevron.l u,tau_(-a)phi chevron.r,
$ 
recovering the stated definition. The two formulations are equivalent: one emphasizes preservation of the pairing, #highlight[while the other directly specifies the new distribution's action on an arbitrary test function.] This action is continuous and linear because $phi arrow.r tau_(-a)phi$ is continuous and linear on the test-function space and $u$ is a distribution.

#definition(title: "Translation Invariance")[With this convention(#(s.ref)("translation-operator")), translating the input and then applying $T$ gives the translated original output precisely when
$
  T tau_(a)f=tau_(a)(T f), quad a in bb(R)^(n).
$
We call this property *translation invariance*.]

#paragraph_tab
To see what this symmetry requires of a kernel, first suppose that $T$ has a continuous function kernel $K$ on $bb(R)^(n) times bb(R)^(n)$:
$
  (T f)(x)=integral_(bb(R)^(n))K(x,z)f(z) thin d z,
  quad f in cal(D)(bb(R)^(n)).
$
Here $K(x,z)$ describes the response at $x$ per unit source at $z$; the integral superposes these responses with weights $f(z)$. Compact support of $f$ makes the integral finite, and continuity of $K$ makes $T f$ continuous. We can therefore compare the two translated outputs pointwise. Translating the input gives
$
  (T tau_(a)f)(x)
  &=integral_(bb(R)^(n))K(x,z)f(z-a) thin d z \
  &=integral_(bb(R)^(n))K(x,w+a)f(w) thin d w,
$
where $w=z-a$. Translating the output instead gives
$
  (tau_(a)(T f))(x)=(T f)(x-a)
  =integral_(bb(R)^(n))K(x-a,w)f(w) thin d w.
$
Translation invariance says these expressions agree for every test function $f$, so
$
  integral_(bb(R)^(n))lr((K(x,w+a)-K(x-a,w)))f(w) thin d w=0.
$
For each fixed $x$ and $a$, the continuous function in parentheses thus represents the zero distribution in $w$. It vanishes everywhere: a nonzero continuous function would be detected by a test function supported near a point where it is nonzero. Consequently, $K(x,w+a)=K(x-a,w)$. Replacing $x$ by $x+a$ and renaming $w$ as $z$ yields
$
  K(x+a,z+a)=K(x,z).
$
#highlight[Moving the source and observer together leaves their coupling unchanged.]

#paragraph_tab
Now fix a pair $(x,z)$. The identity holds for every translation vector $a$, so we may choose $a=-z$. This moves the source to the origin and the observer to $x-z$:
$
  (x,z) arrow.r (x-z,0), quad K(x,z)=K(x-z,0).
$
Thus the response at $x$ to a source at $z$ equals the response at $x-z$ to a source at the origin. Define that origin-source response by
$
  k(r):=K(r,0).
$
Then $K(x,z)=k(x-z)$: the entire two-position kernel is determined by one function of the displacement $r=x-z$. Here $r$ is a vector, so translation invariance alone does not require dependence only on the distance $|r|$.

#paragraph_tab
Geometrically, simultaneous translation preserves the difference because $(x+a)-(z+a)=x-z$. Conversely, any two pairs with the same difference are simultaneous translates of one another. #highlighted[The kernel is therefore constant along each set $x-z=r$.] In one dimension these sets are parallel lines in the $(x,z)$-plane, and each meets the slice $z=0$ at exactly one point $(r,0)$, as shown in #(s.ref)("translation-orbits").

#figure(
  translation-orbit-diagram(),
  caption: [Each line records one difference $r=x-z$. A simultaneous translation moves the pair along that line; choosing $z=0$ selects $(r,0)$. The picture describes coordinates, not pointwise values of a singular kernel.],
) #(s.tag)("translation-orbits")

#paragraph_tab
Substituting the resulting kernel into the integral representation gives
$
  (T f)(x)
  =integral_(bb(R)^(n))K(x,z)f(z) thin d z
  =integral_(bb(R)^(n))k(x-z)f(z) thin d z
  =(k*f)(x).
$
This is why convolution appears: all source responses are translates of the same origin-source response, and the integral superposes them. For example, in one dimension $k(r)=e^(-r^(2))$ gives $K(x,z)=e^(-(x-z)^(2))$. The pairs $(3,1)$ and $(13,11)$ have the same displacement, so $K(3,1)=K(13,11)=e^(-4)$.

#paragraph_tab
The accompanying #link(translation-convolution-video-url)[#underline[narrated animation: from translation invariance to convolution (MP4 download)]] follows the same construction dynamically. It moves the source and observer together, carries their pair along a fixed-displacement line to $(x-z,0)$, and builds convolution by refining a weighted sum of translated responses. Its final sequence previews how integrating test functions along these lines replaces the unavailable slice for a distribution kernel.

#paragraph_tab
The step $k(r)=K(r,0)$ used pointwise values of a continuous kernel. #highlighted[For a distribution, evaluation on the slice $z=0$ may not exist. To recover the same reduction, we instead integrate test functions along the translation direction.] The next theorem makes this replacement precise: $Q$ integrates a two-position test function over the pairs with fixed displacement, and $k$ acts on the resulting test function of $r$. First, let's define convolution when the kernel is a distribution.

#definition(title: "Convolution of a distribution with a test function")[
Let $k in cal(D)^(*)(bb(R)^(n))$ and $f in cal(D)(bb(R)^(n))$, and let $r in bb(R)^(n)$ denote the variable on which $k$ acts. Their *convolution* is defined by
$
  (k*f)(x):=lr(chevron.l k,f(x-r) chevron.r)_(r),
  quad x in bb(R)^(n).
$
] #(s.tag)("distributional-convolution")

If $k$ is represented by a locally integrable function, this definition agrees with the usual convolution integral:
$
  (k*f)(x)
  =integral_(bb(R)^(n))k(r)f(x-r) thin d r
  =integral_(bb(R)^(n))k(x-z)f(z) thin d z.
$ #(s.tag)("ordinary-convolution-integral")
The last equality uses $z=x-r$.

#theorem(title: "Translation invariance characterizes convolution operators")[
Let $T:cal(D)(bb(R)^(n)) arrow.r cal(D)^(*)(bb(R)^(n))$ be continuous and linear. Then $T tau_(a)=tau_(a)T$ for every $a in bb(R)^(n)$ if and only if there exists $k in cal(D)^(*)(bb(R)^(n))$ such that $T f=k*f$ for every $f in cal(D)(bb(R)^(n))$. In this case, $k$ is unique, and the distribution kernel $K$ of $T$ satisfies, for every $Psi in cal(D)(bb(R)^(n) times bb(R)^(n))$,
$
  chevron.l K,Psi chevron.r=chevron.l k,Q Psi chevron.r,
  quad (Q Psi)(r):=integral_(bb(R)^(n))Psi(r+z,z) thin d z.
$ #(s.tag)("translation-kernel-pairing")
This identity defines the notation $K(x,z)=k(x-z)$ without restricting $K$ to a slice.
] #(s.tag)("translation-convolution-theorem")

#paragraph_tab
The continuous-kernel calculation suggests the conclusion, but the proof must now recover $k$ without evaluating $K$ at a point or on a slice. #highlighted[The proposition says that this symmetry is equivalent to describing the whole operator by convolution with a single distribution $k$ of the displacement $r=x-z$.]

#proof[
Assume $T tau_(a)=tau_(a)T$ for every $a$. The Schwartz kernel theorem (@schwartz-kernel-theorem) states that, for open sets $X$ and $Z$, every continuous linear map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$ has a unique distribution $K in cal(D)^(*)(X times Z)$ satisfying
$
  chevron.l T f,phi chevron.r=chevron.l K,phi ⊗ f chevron.r
$ #(s.tag)("schwartz-kernel-representation")
for all $f in cal(D)(Z)$ and $phi in cal(D)(X)$. Our operator satisfies these hypotheses, so let $K$ denote this unique kernel. Test a translated input with a translated observer. Commutation and the duality convention give
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
#highlighted[This is the distributional meaning of $K(x+a,z+a)=K(x,z)$; no pointwise values of $K$ are used.]

#paragraph_tab
It is uncomfortable to control two variables, so we now reduce to one. Introduce $r=x-z$ and retain $z$ as the second coordinate. The inverse map is $(r,z) arrow.r (r+z,z)$, and its absolute Jacobian is one. Define the transformed distribution by
$
  chevron.l U,Phi chevron.r
  :=chevron.l K,(x,z) arrow.r Phi(x-z,z) chevron.r.
$
For a function kernel, this would say $U(r,z)=K(r+z,z)$. Simultaneous translation of $(x,z)$ leaves $r$ fixed and translates only $z$, so the preceding invariance becomes
$
  chevron.l U,(r,z) arrow.r Phi(r,z-a) chevron.r
  =chevron.l U,Phi chevron.r.
$

#paragraph_tab
The identity above says that $U$ does not change however far we move in the $z$ direction while keeping $r$ fixed. When studying Noether's theorem in _Introduction to Smooth Manifolds_ (@Manifolds, Theorem 22.22), #highlight[we learned to view tangent vectors as infinitesimal shifts and differentiation as measuring change along them.] This gives a familiar way to read our identity: no change under a shift should mean zero derivative in that direction. Let's express this through the pairing by setting $a=t e_(j)$, where $e_(j)$ is the $j$th standard basis vector, and differentiating at $t=0$:
$
  0
  &=lr(frac(d,d t)chevron.l U,(r,z) arrow.r Phi(r,z-t e_(j))chevron.r)|_(t=0) \
  &=-chevron.l U,partial_(z_(j))Phi chevron.r
  =chevron.l partial_(z_(j))U,Phi chevron.r.
$ #(s.tag)("translation-vanishing-derivative")
The minus sign comes from translating the test function by $-t e_(j)$ and agrees with the definition of a distributional derivative. Differentiation through the pairing is valid because the translated test functions have a common compact support for small $t$, and their difference quotients converge with every derivative. Since the pairing in #(s.ref)("translation-vanishing-derivative") is zero for every test function $Phi$, the distribution $partial_(z_(j))U$ is zero. This does not say that $partial_(z_(j))Phi=0$; it says that $U$ annihilates these derivatives.

#paragraph_tab
#highlight[The fundamental theorem of calculus suggests reversing differentiation by integration.] Let's use this idea on the test functions in #(s.ref)("translation-vanishing-derivative"). First consider one translation coordinate $z in bb(R)$, with the other variables as parameters. We already know that $chevron.l U,partial_(z)H chevron.r=0$ for every $H in cal(D)$. To apply this identity to a test function $F$, we would like to find $H in cal(D)$ with $F=partial_(z)H$. This suggests the following construction strategy:
#mannot-scope(m => [
  #block(breakable: false)[
  #v(1.8em)
  $
    mark(underbrace(chevron.l U "," partial_(z)phi chevron.r=0),
      tag: #(m.tag)("known"))
    #h(3em)
    mark(arrow.r, tag: #(m.tag)("bridge"))
    #h(3em)
    mark(underbrace(F=partial_(z)H),
      tag: #(m.tag)("goal"))
    #annot((m.tag)("known"), pos: bottom, dy: 0.3em, leader: false,
      annot-text-props: (size: .8em))[
      Known for every $phi in cal(D)$ \
      #(s.ref)("translation-vanishing-derivative")
    ]
    #annot((m.tag)("bridge"), pos: top, dy: -0.8em,
      leader: true, leader-connect: "elbow",
      annot-text-props: (size: .8em))[
      Try integrating $F$ to find $H$
    ]
    #annot((m.tag)("goal"), pos: bottom, dy: 0.3em, leader: false,
      annot-text-props: (size: .8em))[
      Representation to construct \
      with $H in cal(D)$
    ]
  $ #(s.tag)("primitive-construction-strategy")
  #v(2.8em)
  ]
], parent: s, name: "derivative-to-zero-integral")
The requirement $H in cal(D)$ in #(s.ref)("primitive-construction-strategy") restricts which $F$ can have this representation. If such an $H$ exists, choose $R$ large enough that its support lies in the strip $|z|<R$. Since $F=partial_(z)H$ also vanishes outside that strip, the fundamental theorem of calculus gives, for every $r$,
$
  integral_(bb(R))F(r,z) thin d z
  &=integral_(-R)^(R)partial_(z)H(r,z) thin d z \
  &=H(r,R)-H(r,-R)=0.
$ #(s.tag)("primitive-necessary-integral")
Thus #(s.ref)("primitive-necessary-integral") reveals a necessary condition: #highlight[the integral in the translation coordinate must vanish for each fixed choice of the other variables.] This condition comes from requiring the primitive to vanish at both ends.

#paragraph_tab
Let's now check whether this necessary condition is sufficient. For $F in cal(D)$ with $integral_(bb(R))F(r,z) thin d z=0$ for every $r$, define
$
  H(r,z):=integral_(-infinity)^(z)F(r,t) thin d t.
$ #(s.tag)("test-function-primitive")
Applying the fundamental theorem of calculus to #(s.ref)("test-function-primitive") gives $partial_(z)H=F$. Before using this identity in the distributional argument, however, #highlighted[we must check that $H$ itself belongs to $cal(D)$.] To distinguish the defining identity from its intended application to $H$, recall that for an arbitrary test function $psi in cal(D)$,
$
  chevron.l U,partial_(z)psi chevron.r
  =-chevron.l partial_(z)U,psi chevron.r.
$ #(s.tag)("primitive-derivative-duality")
We cannot yet substitute $psi=H$ in #(s.ref)("primitive-derivative-duality"). Its left side would be defined because $partial_(z)H=F in cal(D)$, #highlighted[but its right side requires $H in cal(D)$], which remains to be proved. #highlight[The derivative being a test function does not by itself make the primitive an admissible test function.] We must verify both smoothness and compact support before making this substitution and using the vanishing derivative from #(s.ref)("translation-vanishing-derivative").

#block(sticky: true)[

#paragraph_tab
To verify $H in cal(D)$, first let's check smoothness of $H$. Since $F$ has compact support, choose a compact set $A$ in the parameter variables and $R>0$ such that $op("supp")F subset.eq A times [-R,R]$. We can then rewrite #(s.ref)("test-function-primitive") as $H(r,z)=integral_(-R)^(z)F(r,t) thin d t$. Differentiating this finite-interval integral gives, for every multi-index $alpha$ in the parameter variables and integer $m>=1$,
]
$
  partial_(r)^(alpha)H(r,z)
  &=integral_(-R)^(z)partial_(r)^(alpha)F(r,t) thin d t, \
  partial_(r)^(alpha)partial_(z)^(m)H(r,z)
  &=partial_(r)^(alpha)partial_(z)^(m-1)F(r,z).
$ #(s.tag)("primitive-smoothness")
The derivatives in #(s.ref)("primitive-smoothness") are continuous because $F$ is smooth, so $H$ is smooth in all variables.

#paragraph_tab
To check compact support, return to the primitive in #(s.ref)("test-function-primitive") and consider where it can be nonzero. If $r in.not A$, then $F(r,t)=0$ for every $t$, so $H(r,z)=0$. If $z < -R$, its defining integral has not reached the support of $F$, so again $H(r,z)=0$. If $z>R$, it has passed the entire support in the integration variable, and hence
$
  H(r,z)=integral_(-infinity)^(infinity)F(r,t) thin d t=0 quad "where" F in cal(D).
$ #(s.tag)("primitive-zero-tail")
The two equalities in #(s.ref)("primitive-zero-tail") have different roles: compact support of $F$ makes the primitive constant after the support, and the zero-integral condition in #(s.ref)("primitive-necessary-integral") makes that constant zero. #highlighted[Thus $H(r,z)=0$ at every finite $z>R$, not merely in the limit as $z arrow.r infinity$.] Consequently, $op("supp")H subset.eq A times [-R,R]$, which is compact. Together with the smoothness established in #(s.ref)("primitive-smoothness"), this proves $H in cal(D)$.

#figure(
  compact-primitive-diagram(),
  caption: [A smooth example at fixed $r in A$, with $partial_(z)H=F$. The positive and negative areas cancel, so the accumulated integral returns to zero for $z>R$. The dashed boundaries align the support interval in both plots; vanishing for $r in.not A$ gives the full compact support bound $A times [-R,R]$.],
) #(s.tag)("compact-primitive-support")

#paragraph_tab
The support check in #(s.ref)("primitive-zero-tail") has already identified the role of the zero-integral condition. Let's make the failure without it concrete, still in one translation coordinate. Take a nonnegative test function $eta$ with support in $[-1,1]$ and integral one. Its primitive $h(z):=integral_(-infinity)^(z)eta(t) thin d t$ is smooth, but equals zero for $z < -1$ and one for $z>1$. As #(s.ref)("noncompact-primitive-support") shows, #highlight[the accumulated integral retains a nonzero tail after the derivative has vanished.] Thus $h$ is not compactly supported even though $h'=eta$ is.

#figure(
  noncompact-primitive-diagram(),
  caption: [Removing the zero-integral condition. The shaded area under the smooth test function $eta$ is one, so its primitive stays at one for $z>1$. The arrow continues the plateau beyond the plotted interval. Here $h(plus.minus infinity)$ denotes the corresponding limit; their difference is the nonzero pairing with the constant distribution $1$.],
) #(s.tag)("noncompact-primitive-support")

#paragraph_tab
For our zero-integral $F$, we have now verified that the primitive in #(s.ref)("test-function-primitive") is a test function. We may therefore apply #(s.ref)("primitive-derivative-duality") and then #(s.ref)("translation-vanishing-derivative") to obtain
$
  chevron.l U,F chevron.r
  =chevron.l U,partial_(z)H chevron.r
  =-chevron.l partial_(z)U,H chevron.r=0.
$ #(s.tag)("zero-integral-pairing")
The construction proposed in #(s.ref)("primitive-construction-strategy") is now justified: the necessary condition #(s.ref)("primitive-necessary-integral") is also sufficient for a test-function primitive to exist. #highlighted[In several coordinates, zero total $z$ integral need not imply zero integral in each coordinate separately]. The original $F$ is still compactly supported; its primitive in one coordinate may retain the nonzero tail illustrated in #(s.ref)("noncompact-primitive-support").

#paragraph_tab
To use the known derivative identities(#(s.ref)("translation-vanishing-derivative")), we would like to express a test function with zero total integral as $F=sum_(j=1)^(n)partial_(z_(j))H_(j)$ with $H_(j) in cal(D)$: by linearity, #(s.ref)("translation-vanishing-derivative") would then give $chevron.l U,F chevron.r=0$. 
$
  cancel(chevron.l U comma partial_(z_1) H_(1) chevron.r) + dots.c cancel(chevron.l partial_(z_n) H_(n) chevron.r) &= chevron.l U comma sum_(j=1)^n partial_(z_j) H_(j) chevron.r \ &= chevron.l U,F chevron.r 
  \
  &=0 #dots_space #footnote[becuase of #(s.ref)("translation-vanishing-derivative")]
$ #(s.tag)("multi-variable-pairing") 
Then can the #(s.ref)("multi-variable-pairing") induce an equalvalance to 
$
  0 = sum_(j=1)^n chevron.l U , partial_(z_j) H_(j) chevron.r  attach(=, t: ?) - sum^n_(j=1) chevron.l partial_(z_j) U , H_j chevron.r quad "where" F in cal(D)
$
likely to #(s.ref)("translation-vanishing-derivative")? We have to prove that the primitive $H_(j)$ in each coordinate is a test function, in other words $H_(j) in cal(D)$. For $z=(z_(1),dots,z_(n))$, we apply the one-coordinate conclusion #(s.ref)("zero-integral-pairing") successively. Choose $eta_(j) in cal(D)(bb(R))$ with $integral eta_(j)=1$, and write $eta(z)=product_(j=1)^(n)eta_(j)(z_(j))$. Define the averaging operation
$
  (P_(j)F)(r,z)
  :=eta_(j)(z_(j))integral_(bb(R))
  F(r,z_(1),dots,z_(j-1),t,z_(j+1),dots,z_(n)) thin d t.
$ #(s.tag)("coordinate-averaging")
To see why both ingredients in #(s.ref)("coordinate-averaging") are needed, write $t=z_(j)$ and collect all the remaining variables, including $r$, into $x$. In this notation, let $M(x)=integral_(bb(R))F(x,t) thin d t$. This is a smooth, compactly supported function of $x$. But if $M eq.not 0$, regarding $M(x)$ as a function of $(x,t)$ produces a profile that extends unchanged along the entire $t$ axis, as in panel (b) of #(s.ref)("coordinate-averaging-surfaces"). #highlighted[Multiplication by $eta_(j)(t)$ gives $P_(j)F$ compact support in all variables, while the normalization $integral eta_(j)=1$ preserves each slice integral]:
$
  integral_(bb(R))(P_(j)F)(x,t) thin d t
  =M(x)integral_(bb(R))eta_(j)(t) thin d t=M(x).
$ #(s.tag)("coordinate-integral-preservation")
Thus $G_(j):=F-P_(j)F$ is a test function with $integral G_(j)(x,t) thin d t=0$ for every $x$. The cancellation in #(s.ref)("coordinate-integral-preservation") is shown one slice at a time in #(s.ref)("coordinate-averaging-role").

#figure(
  coordinate-averaging-diagram(),
  caption: [One coordinate at a time. The upper profiles have the same integral $M$; their difference below has cancelling signed areas. The drawing uses $M=1$, but integral preservation and the zero-integral difference hold for any $M$. The other variables remain fixed throughout.],
) #(s.tag)("coordinate-averaging-role")

#paragraph_tab
Let's now check what this gives for the primitive, rather than only for the integrand. Since $G_(j)$ has compact support in all variables, choose a compact $K$ and a single $R>0$ such that $op("supp")G_(j) subset.eq K times [-R,R]$. #highlighted[Define $H_(j)(x,t)=integral_(-infinity)^(t)G_(j)(x,s) thin d s$.]#footnote[At the above, we showed this definition doesn't influence the integral result(value). Hence it is justified.] The two steps of #(s.ref)("primitive-zero-tail") now read, for every $t>R$,
$
  underbrace(
    H_(j)(x,t)=integral_(-infinity)^(infinity)G_(j)(x,s) thin d s,
    #text(size: .8em)[Compact support: the tail is constant],
  )
  =underbrace(0, #text(size: .8em)[Zero slice integral]).
$ #(s.tag)("coordinate-primitive-tail")
Also $H_(j)=0$ for $t < -R$ or $x in.not K$, and #(s.ref)("primitive-smoothness") supplies smoothness. Hence $H_(j) in cal(D)$ and $partial_(z_(j))H_(j)=F-P_(j)F$, so #(s.ref)("zero-integral-pairing") applies. #highlight[The compact support of the integrand makes the tail constant; cancellation makes that constant zero.]

#figure(
  coordinate-averaging-surfaces(),
  caption: [A two-coordinate example with $r$ fixed: $F(z_(1),z_(2))=eta(z_(1)+0.65)eta(z_(2))$, where $eta$ is a smooth unit-integral bump supported in $[-1,1]$. All panels use the same axes, height scale, and viewing window; the flat sheet is height zero. Panel (b) is a cropped view of an unbounded ridge. In (d), the integrand is evaluated at $(t,z_(2))$: the primitive of $F-P_(1)F$ vanishes outside a bounded rectangle by #(s.ref)("coordinate-primitive-tail"). This construction works for arbitrary $F$; the example has total integral one.],
) #(s.tag)("coordinate-averaging-surfaces")

#paragraph_tab
See the #link(coordinate-averaging-video-url)[#underline[English 3D visualization of coordinate averaging (MP4 download)]].

#paragraph_tab
Set $F_(0)=F$ and $F_(j)=P_(j)F_(j-1)$. Each difference $F_(j-1)-F_(j)$ has zero integral in $z_(j)$, with all other variables fixed. The one-coordinate primitive construction therefore writes it as $partial_(z_(j))H_(j)$ for a test function $H_(j)$. Adding these differences gives
$
  F-F_(n)=sum_(j=1)^(n)partial_(z_(j))H_(j),
  quad F_(n)(r,z)=eta(z)integral_(bb(R)^(n))F(r,w) thin d w.
$
Since $U$ annihilates every derivative on the right, it has the same pairing with $F$ and $F_(n)$. Indeed, each constructed primitive $H_(j)$ belongs to $cal(D)$, so we may use the distributional derivative identity #(s.ref)("primitive-derivative-duality"). By linearity and the vanishing derivatives in #(s.ref)("translation-vanishing-derivative"),
$
  chevron.l U,F chevron.r-chevron.l U,F_(n) chevron.r
  &=chevron.l U,F-F_(n) chevron.r \
  &=sum_(j=1)^(n)chevron.l U,partial_(z_(j))H_(j) chevron.r \
  &=-sum_(j=1)^(n)chevron.l partial_(z_(j))U,H_(j) chevron.r=0.
$ #(s.tag)("coordinate-averaging-pairing")
Thus #(s.ref)("coordinate-averaging-pairing") gives $chevron.l U,F chevron.r=chevron.l U,F_(n) chevron.r$. #highlighted[In particular, if the full $z$ integral of $F$ is zero, then $F_(n)=0$ and hence $chevron.l U,F chevron.r=0$.]

#paragraph_tab
Above, we established the relevant properties of $U$. Let's now use them to construct a kernel that depends only on the displacement $r$. For any test function $Phi(r,z)$, set
$
  psi(r):=integral_(bb(R)^(n))Phi(r,z) thin d z.
$ #(s.tag)("displacement-test-function")
#highlighted[We have shown that two test functions with the same $z$-integral give the same pairing with $U$. Thus $psi$ alone determines $chevron.l U,Phi chevron.r$.] This suggests defining a distribution $k$ that acts directly on $psi$.

#paragraph_tab
To define $k$ on an arbitrary $psi in cal(D)(bb(R)^(n))$, however, we must first represent $psi$ by a test function that $U$ can accept. Viewing $psi(r)$ as a function of $(r,z)$ makes it constant along the entire $z$ direction, so it is not compactly supported unless $psi=0$. Choose the test function $eta(z)$ above, with $integral eta=1$. Then $psi(r)eta(z)$ is a test function in both variables, and its $z$-integral is exactly $psi(r)$. We therefore define
$
  chevron.l k,psi chevron.r
  :=chevron.l U,psi(r)eta(z) chevron.r.
$
This defines a distribution because $psi arrow.r psi ⊗ eta$ is continuous in the test-function topology. Indeed, a fixed compact support for $psi$ gives a fixed compact product support, and derivatives of the product are bounded by derivatives of $psi$ times fixed derivatives of $eta$.

#paragraph_tab
The coordinate-averaging identity #(s.ref)("coordinate-averaging-pairing") already applies to every test function. Taking $F=Phi$ there and using the definition of $k$ gives
$
  chevron.l U,Phi chevron.r
  =chevron.l U,eta(z)psi(r) chevron.r
  =chevron.l k,psi chevron.r.
$
This also proves that $k$ does not depend on the chosen $eta$: replacing it by another unit-integral test function changes $psi(r)eta(z)$ by a function whose $z$ integral is zero. #highlighted[In distribution notation, we have proved $U=k ⊗ 1$, where $1$ is the regular distribution that integrates test functions in $z$.]

#paragraph_tab
Finally, let's return to the original variables. Take $Phi(r,z)=Psi(r+z,z)$. For this choice, the test function defined above is $psi(r)=integral_(bb(R)^(n))Psi(r+z,z) thin d z=(Q Psi)(r)$. Thus
$
  chevron.l K,Psi chevron.r
  =chevron.l U,Phi chevron.r
  =chevron.l k,psi chevron.r
  =chevron.l k,Q Psi chevron.r,
$ #(s.tag)("original-variable-kernel-pairing")
which proves #(s.ref)("translation-kernel-pairing"). For a product test function $Psi=phi ⊗ f$, we have $psi(r)=integral_(bb(R)^(n))phi(r+z)f(z) thin d z$, and the kernel relation becomes
$
  chevron.l T f,phi chevron.r \
  &=chevron.l K,phi ⊗ f chevron.r #dots_space #footnote[The kernel identity #(s.ref)("schwartz-kernel-representation").] \
  &=chevron.l k,Q (phi ⊗ f) chevron.r #dots_space #footnote[Apply #(s.ref)("original-variable-kernel-pairing") with $Psi=phi ⊗ f$.] \
  &=chevron.l k,psi chevron.r #dots_space #footnote[The definition of $Q$ in #(s.ref)("translation-kernel-pairing") gives $Q(phi ⊗ f)=psi$.] \
  &=chevron.l k*f,phi chevron.r. #dots_space #footnote[Expand this pairing as in #(s.ref)("convolution-pairing-expansion").]
$
To see the last equality directly, expand the pairing with $psi$:
$
  chevron.l k,psi chevron.r
  &=chevron.l k,integral_(bb(R)^(n))phi(r+z)f(z) thin d z chevron.r \
  &=chevron.l k,integral_(bb(R)^(n))phi(x)f(x-r) thin d x chevron.r, quad "where " z=x-r
  \
  &=integral_(bb(R)^(n))phi(x)lr(chevron.l k,f(x-r) chevron.r)_(r) thin d x #dots_space #footnote[
    From the finite-sum perspective, linearity lets $k$ act inside the sum:
    $
      lr(chevron.l k,sum_(j)phi(x_(j))f(x_(j)-r)Delta V_(j) chevron.r)_(r)
      =sum_(j)phi(x_(j))lr(chevron.l k,f(x_(j)-r) chevron.r)_(r)Delta V_(j).
    $
  ] \
  &=integral_(bb(R)^(n))phi(x)(k*f)(x) thin d x #dots_space #footnote[By #(s.ref)("distributional-convolution").] \
  &=chevron.l k*f,phi chevron.r.
$ #(s.tag)("convolution-pairing-expansion")
The change from the $z$ integral to the $x$ integral uses $x=r+z$. Interchanging the pairing and integration is valid because $x$ ranges over $op("supp")phi$, and all the test functions in $r$ then have support in one compact set. #highlighted[Thus $T f=k*f$ as distributions.]

#paragraph_tab
Now let's show that the distribution $k$ in $T f=k*f$ is uniquely determined by $T$. By a uniquness of kernel $K$ guaranteed by @schwartz-kernel-theorem, the following equation is true if there is a two convolution distributions $K_1$ and $K_2$ for the same operator $T$:
$  chevron.l k_1, Q Psi chevron.r=chevron.l K , Psi chevron.r= chevron.l k_2, Q Psi chevron.r quad => k_(1)=k_(2)
$ #(s.tag)("kernel-uniqueness-pairing")

However, #(s.ref)("kernel-uniqueness-pairing") can be useful when every test function $d in cal(D)(RR^n)$ can be expressed as $Q Psi$ for some $Psi$. Take an arbitrary $d in cal(D)(bb(R)^(n))$ and use the unit-integral test function $eta$ above to set $Psi(x,z):=d(x-z)eta(z)$. This is a test function on the product space: $z$ lies in $op("supp")eta$, while $x-z$ lies in $op("supp")psi$, so $x$ lies in the sum of these compact sets. Applying $Q$ gives
$
  (Q Psi)(r)
  &=integral_(bb(R)^(n))Psi(r+z,z) thin d z \
  &=integral_(bb(R)^(n))d((r+z)-z)eta(z) thin d z \
  &=d(r)integral_(bb(R)^(n))eta(z) thin d z
  =d(r).
$
Thus the uniqueness of $k$ from #(s.ref)("kernel-uniqueness-pairing") is reserved usefully, So we can represent $T f = k * f$ for every $cal(D)(bb(R)^(n)) |-> cal(D)^(*)(bb(R)^(n))$ where $T$ has translation invariance and $f in cal(D)(bb(R)^(n))$.

#paragraph_tab
Conversely, suppose $T f=k*f$ for every test function $f$. For every $a in bb(R)^(n)$, the definitions of convolution and translation give
$
  (T(tau_(a)f))(x)
  &=(k*(tau_(a)f))(x) \
  &=lr(chevron.l k,(tau_(a)f)(x-r) chevron.r)_(r) \
  &=lr(chevron.l k,f(x-r-a) chevron.r)_(r) \
  &=lr(chevron.l k,f((x-a)-r) chevron.r)_(r) \
  &=(k*f)(x-a) \
  &=(T f)(x-a) \
  &=(tau_(a)(T f))(x).
$
Thus $T tau_(a)f=tau_(a)(T f)$ for every test function $f$, proving the converse.
]

#note(title: [Scope of #(s.ref)("translation-convolution-theorem")])[
The theorem assumes an operator on $bb(R)^(n)$ that commutes with every translation. The shape of a domain or the imposed boundary conditions may prevent the solution operator from having this symmetry. In that case, the theorem does not apply, and its convolution representation need not hold.
]

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

=== Fourier representation of translation-invariant operators

#paragraph_tab
Earlier, we defined the translation operator $tau_(a)$ in #(s.ref)("translation-operator") and used it to describe translation invariance. We have not yet examined its eigenfunctions. Let's now study this operator from the viewpoint of linear algebra. For a linear operator, an eigenvector is a nonzero vector that the operator multiplies by a scalar. Here the vectors are functions. Since translation invariance involves every displacement $a$, we look for a *common eigenfunction* of all the translation operators. First consider one dimension: can we find a nonzero smooth complex-valued function $v$ such that
$
  tau_(a)v=lambda(a)v,
  quad v(x-a)=lambda(a)v(x)
$ #(s.tag)("translation-common-eigenfunction")
for every $a in bb(R)$? The function $v$ must be the same for all $a$, while the eigenvalue $lambda(a)$ may depend on the displacement. Since $tau_(a+b)=tau_(a)tau_(b)$, applying #(s.ref)("translation-common-eigenfunction") to two successive translations gives
$
  lambda(a+b)=lambda(a)lambda(b),
  quad lambda(0)=1.
$ #(s.tag)("translation-eigenvalue-composition")
To solve #(s.ref)("translation-eigenvalue-composition"), let's first check that we can differentiate $lambda$. Choose $x_(0)$ with $v(x_(0)) eq.not 0$. Evaluating #(s.ref)("translation-common-eigenfunction") at $x=x_(0)$ gives
$
  lambda(a)=frac(v(x_(0)-a),v(x_(0))).
$ #(s.tag)("translation-eigenvalue-ratio")
The denominator in #(s.ref)("translation-eigenvalue-ratio") is a fixed nonzero number, and $v$ is smooth, so $lambda$ is smooth as a function of the displacement $a$. Now hold $a$ fixed and differentiate both sides of #(s.ref)("translation-eigenvalue-composition") with respect to $b$. The chain rule on the left and the fact that $lambda(a)$ is constant with respect to $b$ on the right give
$
  frac(d,d b)lambda(a+b)&=lambda'(a+b), \
  frac(d,d b)lr(lambda(a)lambda(b))&=lambda(a)lambda'(b).
$ #(s.tag)("translation-eigenvalue-derivatives")
Equating the two derivatives in #(s.ref)("translation-eigenvalue-derivatives") and setting $b=0$ gives
$
  lambda'(a)=lambda(a)lambda'(0).
$ #(s.tag)("translation-eigenvalue-derivative-at-zero")
Writing $c:=lambda'(0)$ in #(s.ref)("translation-eigenvalue-derivative-at-zero"), we obtain an ordinary differential equation for $lambda$ with the initial value from #(s.ref)("translation-eigenvalue-composition"):
$
  lambda'(a)=c lambda(a),
  quad lambda(0)=1.
$ #(s.tag)("translation-eigenvalue-initial-value-problem")
Since $c$ is constant, the unique solution of #(s.ref)("translation-eigenvalue-initial-value-problem") is
$
  lambda(a)=e^(c a).
$ #(s.tag)("translation-eigenvalue-exponential")
The constant $c$ in #(s.ref)("translation-eigenvalue-exponential") may be any complex number: the translation law alone also allows exponentially growing or decaying patterns.

#paragraph_tab
Let's now determine the common eigenfunctions themselves. Substituting #(s.ref)("translation-eigenvalue-exponential") into #(s.ref)("translation-common-eigenfunction") and setting $a=x$ gives
$
  v(0)=e^(c x)v(x),
  quad v(x)=v(0)e^(-c x).
$ #(s.tag)("translation-common-eigenfunction-exponential")
Here $v(0) eq.not 0$, since otherwise #(s.ref)("translation-common-eigenfunction-exponential") would make $v$ identically zero. Among these common eigenfunctions, let's look for those that remain bounded on the whole real line. This is an additional condition on $v$. Writing $c=alpha+i beta$ with $alpha,beta in bb(R)$, we get
$
  |v(x)|=|v(0)|e^(-alpha x).
$ #(s.tag)("translation-eigenfunction-magnitude")
If $alpha>0$, #(s.ref)("translation-eigenfunction-magnitude") grows without bound as $x arrow.r -infinity$; if $alpha<0$, it grows without bound as $x arrow.r infinity$. Thus $v$ is bounded on $bb(R)$ exactly when $alpha=op("Re")c=0$. Write $c=-i xi$ for $xi in bb(R)$. Then #(s.ref)("translation-common-eigenfunction-exponential") becomes $v(x)=v(0)e^(i x xi)$, so we choose the normalized eigenfunction
$
  e_(xi)(x):=e^(i x xi),
  quad tau_(a)e_(xi)=e^(-i a xi)e_(xi).
$ #(s.tag)("one-dimensional-translation-mode")
The minus sign in #(s.ref)("one-dimensional-translation-mode") follows directly from $e^(i(x-a)xi)=e^(-i a xi)e^(i x xi)$. Both $|e_(xi)(x)|$ and the absolute value of its translation eigenvalue $e^(-i a xi)$ are $1$.

#paragraph_tab
In $bb(R)^(n)$, these functions take the form
$
  e_(xi)(x):=e^(i x dot xi),
  quad tau_(a)e_(xi)=e^(-i a dot xi)e_(xi),
  quad -i partial_(x_(j))e_(xi)=xi_(j)e_(xi).
$ #(s.tag)("multidimensional-translation-mode")
We call the continuous family $e_(xi)$ in #(s.ref)("multidimensional-translation-mode") the *trigonometric basis* for the Fourier inversion below, and $xi$ its *spatial frequency*. Here reconstruction uses an integral over $xi$, as these functions do not form a discrete $L^(2)$ basis on $bb(R)^(n)$. For $xi eq.not 0$, the phase $x dot xi$ changes fastest along the direction of $xi$, at a rate $|xi|$ per unit distance. The wavelength in that direction is therefore $2 pi/|xi|$. When $xi=0$, the basis function is the constant $1$.

#paragraph_tab
Having found these bounded common eigenfunctions, let's use them to reconstruct more general functions. The Fourier inversion theorem on Schwartz functions (@Fourier) expresses $f in cal(S)(bb(R)^(n))$ as an integral of the trigonometric basis functions. We use the normalization introduced in the preceding section:
$
  hat(f)(xi)
  &=(2 pi)^(-n/2) integral_(bb(R)^(n))e^(-i x dot xi)f(x) thin d x, \
  f(x)
  &=(2 pi)^(-n/2) integral_(bb(R)^(n))e^(i x dot xi)hat(f)(xi) thin d xi.
$ #(s.tag)("trigonometric-basis-inversion")
The coefficient $hat(f)(xi)$ in #(s.ref)("trigonometric-basis-inversion") gives the weight of $e_(xi)$ in the inversion integral.

#paragraph_tab
We can also use this decomposition for square-integrable functions. With the normalization in #(s.ref)("trigonometric-basis-inversion"), the Plancherel identity (@Fourier) gives $norm(hat(f))_(2)=norm(f)_(2)$, and the Fourier transform extends to a unitary operator on $L^(2)$. Each $e_(xi)$ has absolute value $1$ everywhere and hence is not in $L^(2)(bb(R)^(n))$; these basis functions serve as *generalized eigenfunctions* in the $L^(2)$ representation. To see how translation acts in this representation, apply the Fourier transform in #(s.ref)("trigonometric-basis-inversion") to $tau_(a)f$ and substitute $x=z+a$. For Schwartz functions, this gives
$
  hat(tau_(a)f)(xi)=e^(-i a dot xi)hat(f)(xi).
$ #(s.tag)("translation-trigonometric-basis")
The identity in #(s.ref)("translation-trigonometric-basis") extends to $L^(2)$ by density and shows that translation changes the phase of each Fourier coefficient while preserving its absolute value. Combining it with the Plancherel identity gives
$
  norm(tau_(a)f)_(2)=norm(hat(tau_(a)f))_(2)=norm(hat(f))_(2)=norm(f)_(2).
$ #(s.tag)("translation-l2-isometry")
The norm preservation in #(s.ref)("translation-l2-isometry") also follows directly by substituting $y=x-a$ in $integral |f(x-a)|^(2) thin d x$.

#paragraph_tab
Let's return to the translation-invariant operators in #(s.ref)("translation-convolution-theorem"). That theorem gives $T f=k*f$ but does not compute $k$. By #(s.ref)("translation-trigonometric-basis"), translation acts on each Fourier coefficient by multiplication. To understand what commutation with translation implies for $T$, temporarily suppose that $T e_(xi)$ is defined and is a smooth function. Then
$
  T(tau_(a)e_(xi)) &= tau_(a)(T e_(xi)), \
  T(tau_(a)e_(xi)) &= e^(-i a dot xi)T e_(xi).
$
Thus every translation multiplies $T e_(xi)$ by the same factor $e^(-i a dot xi)$. Setting $a=x$, as in the one-dimensional calculation, gives $(T e_(xi))(0)=e^(-i x dot xi)(T e_(xi))(x)$. Consequently,
$
  m(xi) &:= (T e_(xi))(0), \
  T e_(xi) &= m(xi)e_(xi).
$ #(s.tag)("translation-operator-mode-multiplier")
The formal relation in #(s.ref)("translation-operator-mode-multiplier") explains the expected form of the answer, but applying $T$ to these basis functions requires an extension beyond compactly supported or $L^(2)$ functions.

#paragraph_tab
For $k in L^(1)(bb(R)^(n))$, convolution also acts on the bounded function $e_(xi)$: the integral below converges absolutely, and
$
  (T e_(xi))(x)
  &=(k*e_(xi))(x) \
  &=integral_(bb(R)^(n))k(r)e^(i(x-r) dot xi) thin d r \
  &=e_(xi)(x) integral_(bb(R)^(n))e^(-i r dot xi)k(r) thin d r.
$ #(s.tag)("integrable-kernel-eigenfunction")
Setting $x=0$ in #(s.ref)("integrable-kernel-eigenfunction") and using the definition of $m(xi)$ in #(s.ref)("translation-operator-mode-multiplier") gives $m(xi)=(2 pi)^(n/2)hat(k)(xi)$. For $f in cal(S)(bb(R)^(n))$, the convolution identity in @unitary_fourier_convolution_formulas extends from Schwartz kernels to $L^(1)$ kernels by Fubini's theorem. Thus
$
  hat(T f)(xi)&=(2 pi)^(n/2)hat(k)(xi)hat(f)(xi)=m(xi)hat(f)(xi)
  \
  m(xi)&:=(2 pi)^(n/2)hat(k)(xi), quad "where" f in cal(S)(bb(R)^(n))
$ #(s.tag)("integrable-kernel-multiplier")
The function $m$ in #(s.ref)("integrable-kernel-multiplier") is called a *Fourier multiplier*: in Fourier variables, $T$ acts by multiplication by $m(xi)$.

#paragraph_tab
#highlight[The identity in #(s.ref)("integrable-kernel-multiplier") suggests how to recover a kernel from a multiplier.] If $cal(F)(T f)=m hat(f)$ and $T f=K*f$, the Fourier convolution identity in @unitary_fourier_convolution_formulas requires
$
  (2 pi)^(n/2)hat(K)hat(f)=m hat(f).
$

Let $m$ be measurable with $|m(xi)| <= C(1+|xi|)^(N)$ for some $C,N >= 0$. It defines a tempered distribution, so the preceding identity suggests the kernel
$
  K:=(2 pi)^(-n/2)cal(F)^(-1)m.
$ #(s.tag)("multiplier-kernel")
For $f in cal(S)(bb(R)^(n))$, set $T f:=cal(F)^(-1)(m hat(f))$. Convolution with the tempered distribution $K$ is defined on such $f$, and the Fourier convolution identity verifies
$
  cal(F)(K*f)
  =(2 pi)^(n/2)hat(K)hat(f)
  =m hat(f)
  =cal(F)(T f).
$
Thus $T f=K*f$: inverse transformation of the multiplier recovers the convolution kernel. If $m$ is integrable, Fourier inversion gives the ordinary integral
$
  K(x)=(2 pi)^(-n)integral_(bb(R)^(n))e^(i x dot xi)m(xi) thin d xi.
$
Otherwise, the inverse transform remains meaningful in $cal(S)^(*)$. A singular kernel is therefore part of the same construction.

=== A common operator for heat, Poisson, and waves

#paragraph_tab
We already studied the heat, Poisson, and wave kernels in Stein and Shakarchi's @Fourier. Recall their Fourier representations, which will let us relate the corresponding solution operators. For the heat equation with initial temperature $u(0,x)=f(x)$,
$
  hat(u)(t,xi)=e^(-t|xi|^(2))hat(f)(xi), quad t>=0.
$ #(s.tag)("heat-multiplier")
For the harmonic extension $u$ with boundary values $u(0,x)=f(x)$, assume that $u(y,dot)$ remains uniformly bounded in $L^(2)$ as the height $y>0$ varies. Then
$
  hat(u)(y,xi)=e^(-y|xi|)hat(f)(xi).
$ #(s.tag)("poisson-multiplier")
For the wave equation with initial displacement $f$ and velocity $g$,
$
  hat(u)(t,xi)=cos(t|xi|)hat(f)(xi)+b_(t)(|xi|)hat(g)(xi),
$ #(s.tag)("wave-multiplier")
where $b_(t)(a)=sin(t a)/a$ for $a>0$ and $b_(t)(0)=t$.

#paragraph_tab
#highlighted[The heat formula #(s.ref)("heat-multiplier") contains $|xi|^(2)$, whereas the Poisson and wave formulas #(s.ref)("poisson-multiplier") and #(s.ref)("wave-multiplier") contain $|xi|$.] By the Fourier derivative rule @fourier_transform_of_derivatives, $|xi|^(2)$ is the multiplier of $-Delta$. This suggests defining $A$ by the multiplier $|xi|$: its square should recover $-Delta$, and all three solution formulas should become functions of the same operator.

#definition(title: "The spatial frequency operator")[
On $L^(2)(bb(R)^(n))$, define
$
  A f:=cal(F)^(-1)(|xi|hat(f)(xi)),
  quad cal(D)(A):={f in L^(2): |xi|hat(f) in L^(2)}.
$ #(s.tag)("frequency-operator")
The domain consists of exactly those functions $f in L^(2)$ for which $|xi|hat(f)$ also belongs to $L^(2)$.
] #(s.tag)("spatial-frequency-operator")

We can now check that this square is $-Delta$. For $f in cal(D)(A^(2))$,#footnote[$cal(D)(A^(2)):={f in cal(D)(A): A f in cal(D)(A)}$] apply #(s.ref)("frequency-operator") first to $f$ and then to $A f$:
#flowbox[
  $
    cal(F)(A f)(xi) &= |xi|hat(f)(xi), \
    cal(F)(A^(2)f)(xi)
      &= |xi|cal(F)(A f)(xi) \
      &= |xi| |xi|hat(f)(xi) \
      &= |xi|^(2)hat(f)(xi).
  $

  $arrow.b$

  $
    A^(2)=-Delta, quad A=sqrt(-Delta)
  $ #(s.tag)("square-root-laplacian")
]

#paragraph_tab
Therefore we can rewrite #(s.ref)("heat-multiplier"), #(s.ref)("poisson-multiplier"), and #(s.ref)("wave-multiplier"):
$
  cal(F)^(-1)(e^(-t|xi|^(2))hat(f)(xi)) &arrow.r e^(-t A^(2))f, \
  cal(F)^(-1)(e^(-y|xi|)hat(f)(xi)) &arrow.r e^(-y A)f, \
  cal(F)^(-1)(cos(t|xi|)hat(f)(xi)) &arrow.r cos(t A)f, \
  cal(F)^(-1)(b_(t)(|xi|)hat(f)(xi)) &arrow.r b_(t)(A)f.
$ #(s.tag)("operator-multiplier-correspondence")
Here $t>=0$ for heat, $y>0$ for the Poisson extension, and $t in bb(R)$ for waves. Combining #(s.ref)("spatial-frequency-operator") with #(s.ref)("operator-multiplier-correspondence") gives the re-formulated solution formulas in #(s.ref)("The solutions written by A"):
$
  "Heat:" &quad u(t)=rmark(e^(-t A^(2)))f=e^(t Delta)f, \
  "Poisson extension:" &quad u(y)= bmark(e^(-y A))f, \
  "Wave:" &quad u(t)=cos(t A)f+b_(t)(A)g.
$ #(s.tag)("The solutions written by A")
These formulas restate the multipliers already derived. The exponential and trigonometric operator notation refers to the four definitions above; $b_(t)(A)$ uses its bounded multiplier at $xi=0$ without applying $A^(-1)$.

#paragraph_tab
Writing these solutions in terms of the same operator $A$ lets us compare their evolution operators. #highlighted()[In particular, #(s.ref)("The solutions written by A") pairs the Poisson operator $e^(-y A)$ with the heat operators $e^(-t A^(2))$.] Both are decaying exponentials built from $A$, with $A$ in one exponent and $A^(2)$ in the other. This common structure suggests that the two solution operators may be related.

=== Subordination: construct the Poisson kernel from heat

#paragraph_tab
To investigate this relation, recall the heat kernel studied in Stein and Shakarchi's @Fourier. Let $n>=1$ be the number of spatial coordinates, with $x in bb(R)^(n)$. We record this dimension in the superscript $(n)$. The heat kernel is readily available in every dimension: multiplying the one-dimensional Gaussian kernels gives, for $t>0$,
$
  p_(t)^((n))(x):=product_(j=1)^(n)p_(t)^((1))(x_(j))
  =(4 pi t)^(-n/2)e^(frac(-|x|^(2),4t)), \
  e^(-t A^(2))f=p_(t)^((n))*f.
$ #(s.tag)("heat-kernel")
This kernel is nonnegative and has integral one: $p_(t)^((n))>=0$ and $integral_(bb(R)^(n))p_(t)^((n))(x) thin d x=1$.

#paragraph_tab
The similar forms of the Poisson and heat multipliers suggest asking whether a weighted sum of heat multipliers can represent the Poisson multiplier.#footnote[In Fourier series, we approximate a function by weighted sums of trigonometric basis functions. Having just used the Fourier transform, it is natural to try a similar idea here: represent the desired multiplier by combining a family of known functions, in this case the heat multipliers.] Since the heat time $t>0$ varies continuously, we look for such a representation as an integral over $t$.#footnote[For $t>=0$, the heat multiplier $e^(-t|xi|^(2))$ is bounded by one and defines an operator on all of $L^(2)$. For $t<0$, it becomes $e^(|t||xi|^(2))$, whose growth can take an $L^(2)$ Fourier transform outside $L^(2)$. We therefore use the forward heat operators.] By #(s.ref)("operator-multiplier-correspondence"), we seek a weight $w_(y)$ such that, with $a=|xi|$,
#mannot-scope(m => [
  #block(breakable: false, above: 1.2em, below: 1.2em)[
  $
    bmark(e^(-y a), tag: #(m.tag)("poisson-multiplier"))
    = integral_(0)^(infinity)w_(y)(t)
      rmark(e^(-t a^(2)), tag: #(m.tag)("heat-multiplier")) thin d t
    quad "for every" a>=0.
    #annot((m.tag)("poisson-multiplier"), pos: top, dy: -0.6em,
      leader: true, leader-connect: "elbow")[Poisson multiplier]
    #annot((m.tag)("heat-multiplier"), pos: bottom, dy: 0.6em,
      leader: true, leader-connect: "elbow")[heat multiplier]
  $ #(s.tag)("subordination-target")
  ]
], parent: s, name: "subordination-multiplier-annotations")
The same weight must work at every frequency. To find a candidate for #(s.ref)("subordination-target"), we use the one-dimensional Poisson kernel already studied in Stein and Shakarchi's @Fourier as a guide.

#paragraph_tab
Write $P_(y)^((1))$ and $p_(t)^((1))$ for the known kernels in one spatial dimension:
$
  P_(y)^((1))(x)=frac(y,pi(y^(2)+x^(2))), quad
  p_(t)^((1))(x)=frac(1,sqrt(4pi t))e^(-x^(2)/(4t)),
  quad y,t>0.
$ #(s.tag)("subordination-known-kernels")
#highlighted()[To reveal a Gaussian inside $P_(y)^((1))$, first turn its denominator into an integral of exponentials.] For $B>0$, the antiderivative $-e^(-s B)/B$ gives
$
  integral_(0)^(infinity)e^(-s B) thin d s=lim_(R arrow.r infinity)frac(1-e^(-R B),B)=frac(1,B).
$ #(s.tag)("subordination-reciprocal-integral")
Taking $B=y^(2)+x^(2)>0$ in #(s.ref)("subordination-reciprocal-integral") rewrites #(s.ref)("subordination-known-kernels") as
$
  P_(y)^((1))(x)=frac(y,pi)integral_(0)^(infinity)e^(-s y^(2))e^(-s x^(2)) thin d s.
$ #(s.tag)("subordination-poisson-exponentials")
#highlighted[We want the spatial factor $e^(-s x^(2))$ in #(s.ref)("subordination-poisson-exponentials") to match $e^(-x^(2)/(4t))$ in the heat kernel #(s.ref)("subordination-known-kernels").] This determines the substitution
$
  s=frac(1,4t), quad thin d s=-frac(1,4t^(2)) thin d t.
$ #(s.tag)("subordination-kernel-substitution")
As $s$ runs from $0$ to $infinity$, $t$ runs from $infinity$ to $0$. Applying #(s.ref)("subordination-kernel-substitution") to #(s.ref)("subordination-poisson-exponentials") and reversing the limits gives
$
  P_(y)^((1))(x)
  &=-frac(y,4pi)integral_(infinity)^(0)t^(-2)e^(-(y^(2)+x^(2))/(4t)) thin d t \
  &=frac(y,4pi)integral_(0)^(infinity)t^(-2)e^(-y^(2)/(4t))e^(-x^(2)/(4t)) thin d t.
$ #(s.tag)("subordination-kernel-change")
To factor out the full heat kernel in #(s.ref)("subordination-known-kernels"), including its coefficient $(4pi t)^(-1/2)$, split the integrand in #(s.ref)("subordination-kernel-change"):
$
  P_(y)^((1))(x)=integral_(0)^(infinity)
    lr(frac(y,2sqrt(pi))t^(-3/2)e^(-y^(2)/(4t)))
    p_(t)^((1))(x) thin d t.
$ #(s.tag)("subordination-kernel-candidate")
The coefficient of $p_(t)^((1))(x)$ in #(s.ref)("subordination-kernel-candidate") gives the candidate weight. The factor $e^(-y^(2)/(4t))$ comes from $e^(-s y^(2))$, while $t^(-3/2)$ remains after factoring the heat kernel's $t^(-1/2)$ out of $t^(-2)$. We now verify directly that this weight satisfies the scalar identity #(s.ref)("subordination-target"), which we can then apply in any spatial dimension.

#lemma(title: "Scalar subordination identity")[
For $y>0$, define
$
  w_(y)(t):=frac(y,2sqrt(pi))t^(-3/2)e^(-y^(2)/(4t)), quad t>0.
$ #(s.tag)("subordination-weight")
Then, for every $a>=0$,
$
  e^(-y a)=integral_(0)^(infinity)w_(y)(t)e^(-t a^(2)) thin d t.
$ #(s.tag)("subordination")
Moreover, $w_(y)(t)>0$ for $t>0$ and $integral_(0)^(infinity)w_(y)(t) thin d t=1$.
]

#block(breakable: false)[
#proof[
Positivity follows from #(s.ref)("subordination-weight"). Both one-dimensional kernels in #(s.ref)("subordination-known-kernels") have integral one. Integrating #(s.ref)("subordination-kernel-candidate") over $x$ and using Tonelli's theorem therefore gives $integral_(0)^(infinity)w_(y)(t) thin d t=1$. Since $|e^(-i xi x)|=1$, the absolute integral of $w_(y)(t)e^(-i xi x)p_(t)^((1))(x)$ over $x$ and $t$ equals $integral_(0)^(infinity)w_(y)(t) thin d t=1$. Thus Fubini's theorem applies to the spatial Fourier transform of #(s.ref)("subordination-kernel-candidate"). The Fourier formulas #(s.ref)("poisson-multiplier") and #(s.ref)("heat-multiplier") give, for $xi in bb(R)$,
$
  e^(-y|xi|)
  &=hat(P_(y)^((1)))(xi) \
  &=integral_(0)^(infinity)w_(y)(t)hat(p_(t)^((1)))(xi) thin d t \
  &=integral_(0)^(infinity)w_(y)(t)e^(-t|xi|^(2)) thin d t.
$ #(s.tag)("subordination-fourier-proof")
Every $a>=0$ occurs as $|xi|$ for some $xi in bb(R)$. Thus #(s.ref)("subordination-fourier-proof") proves #(s.ref)("subordination") for every $a>=0$.
]

]
#paragraph_tab
Applying #(s.ref)("subordination") at $a=|xi|$ makes the Poisson multiplier equal to the weighted integral of heat multipliers at every frequency. By #(s.ref)("operator-multiplier-correspondence"), this gives, for $f in L^(2)$,
$
  e^(-y A)f=integral_(0)^(infinity)w_(y)(t)e^(-t A^(2))f thin d t.
$ #(s.tag)("subordination-operator")
The integral converges in $L^(2)$, since the heat operators are contractions and the weight has total mass one. This construction is called *subordination*: a Poisson extension is an average of heat evolutions over different heat times.

#pagebreak(weak: true)

#paragraph_tab
#highlighted[We now calculate the $n$-dimensional Poisson kernel from the heat kernel, which is readily obtained as a product of one-dimensional Gaussians in #(s.ref)("heat-kernel").] The weight $w_(y)$ was derived from the one-dimensional Poisson kernel, but #(s.ref)("subordination") holds for every $a>=0$, independently of dimension. Taking $a=|xi|$ lets us use this same weight to average the $n$-dimensional heat kernels and obtain $P_(y)^((n))$, without a new multidimensional Fourier inversion.

#paragraph_tab
We seek $e^(-y A)f=P_(y)^((n))*f$, where $x=(x_(1),dots,x_(n))$ has $n$ spatial coordinates, $|x|^(2)=sum_(j=1)^(n)x_(j)^(2)$, and $y>0$ is the additional Poisson extension coordinate. Substituting $e^(-t A^(2))f=p_(t)^((n))*f$ into #(s.ref)("subordination-operator") gives
$
  e^(-y A)f
  &=integral_(0)^(infinity)w_(y)(t)(p_(t)^((n))*f) thin d t \
  &=lr((integral_(0)^(infinity)w_(y)(t)p_(t)^((n)) thin d t))*f.
$ #(s.tag)("subordination-convolution")
The second equality interchanges the heat-time integral with the convolution integral.#footnote[First take $f$ smooth and rapidly decreasing. Since $f$ is bounded and $p_(t)^((n))$ has mass one, the absolute double integral at each $x$ is at most $norm(f)_(infinity)integral_(0)^(infinity)w_(y)(t) thin d t=norm(f)_(infinity)$, so Fubini applies. The resulting kernel is nonnegative and has mass one by Tonelli. Both sides of #(s.ref)("subordination-convolution") are contractions on $L^(2)$, so the identity extends to all $L^(2)$ inputs by density.] Thus we define
$
  P_(y)^((n))(x):=integral_(0)^(infinity)w_(y)(t)p_(t)^((n))(x) thin d t.
$ #(s.tag)("subordination-kernel-mixture")
To evaluate #(s.ref)("subordination-kernel-mixture"), insert the weight from #(s.ref)("subordination-weight") and the heat kernel from #(s.ref)("heat-kernel"). The annotations identify the two formulas being substituted. We then combine their coefficients, powers of $t$, and exponentials separately, with $B:=y^(2)+|x|^(2)>0$:
#flowbox[
  #show math.equation: set block(above: 0.5em, below: 0.5em)
  #local-scope-annotations(m => [
    #block(breakable: false, above: 1.8em, below: 1.8em)[
    #v(1em)
    $
      P_(y)^((n))(x)=integral_(0)^(infinity)
        bmark(frac(y,2sqrt(pi))t^(-3/2)e^(-y^(2)/(4t)),
          tag: #(m.tag)("weight"))
        dot rmark((4pi t)^(-n/2)e^(-|x|^(2)/(4t)),
          tag: #(m.tag)("heat-kernel")) thin d t.
      #annot((m.tag)("weight"), pos: top, dy: -0.7em,
        leader: true, leader-connect: "elbow",
        annot-text-props: (size: 0.85em))[
        weight $w_(y)(t)$ from #(s.ref)("subordination-weight")
      ]
      #annot((m.tag)("heat-kernel"), pos: bottom, dy: 0.7em,
        leader: true, leader-connect: "elbow",
        annot-text-props: (size: 0.85em))[
        heat kernel $p_(t)^((n))(x)$ from #(s.ref)("heat-kernel")
      ]
    $ #(s.tag)("poisson-kernel-inserted-formulas")
    ]
  ], parent: s, name: "subordination-kernel-insertion")
  $arrow.b$
  $
    frac(y,2sqrt(pi))(4pi)^(-n/2)
    &=frac(y,2sqrt(pi) dot 2^(n)pi^(n/2)) \
    &=frac(y,2^(n+1)pi^((n+1)/2))
      =frac(y,(4pi)^((n+1)/2)), \
    t^(-3/2)t^(-n/2)&=t^(-(n+3)/2), \
    e^(-y^(2)/(4t))e^(-|x|^(2)/(4t))
    &=e^(-(y^(2)+|x|^(2))/(4t))=e^(-B/(4t)).
  $ #(s.tag)("poisson-kernel-product-simplification")
  $arrow.b$
  $
    P_(y)^((n))(x)=frac(y,(4pi)^((n+1)/2))
      integral_(0)^(infinity)e^(-B/(4t))t^(-(n+3)/2) thin d t.
  $ #(s.tag)("poisson-kernel-time-integral")
]

#block(breakable: false)[

#paragraph_tab
Next, remove $B$ from the exponential in #(s.ref)("poisson-kernel-time-integral") by setting $s=B/(4t)$. We compute both the differential and the power of $s$ before changing the integral. The limits reverse because $t arrow.r 0^(+)$ gives $s arrow.r infinity$, while $t arrow.r infinity$ gives $s arrow.r 0^(+)$:
#flowbox[
  #show math.equation: set block(above: 0.5em, below: 0.5em)
  $
    s=frac(B,4t), quad t=frac(B,4s), quad
    thin d t=frac(B,4)thin d(s^(-1))=-frac(B,4s^(2)) thin d s.
  $ #(s.tag)("poisson-kernel-time-change")
  $arrow.b$
  $
    t^(-(n+3)/2) thin d t
    &=lr((frac(B,4s)))^(-(n+3)/2)
      lr((-frac(B,4s^(2)))) thin d s \
    &=-lr((frac(4,B)))^((n+3)/2)frac(B,4)
      s^((n+3)/2-2) thin d s \
    &=-lr((frac(4,B)))^((n+1)/2)s^((n-1)/2) thin d s.
  $ #(s.tag)("poisson-kernel-time-differential")
  $arrow.b$
  $
    integral_(0)^(infinity)e^(-B/(4t))t^(-(n+3)/2) thin d t
    &=-lr((frac(4,B)))^((n+1)/2)
      integral_(infinity)^(0)e^(-s)s^((n-1)/2) thin d s \
    &=lr((frac(4,B)))^((n+1)/2)
      integral_(0)^(infinity)e^(-s)s^((n-1)/2) thin d s.
  $ #(s.tag)("poisson-kernel-transformed-integral")
]
]

#paragraph_tab
The last equality reverses the limits and cancels the minus sign. The remaining integral is a Gamma integral: its power of $s$ is $(n-1)/2=(n+1)/2-1$, so the definition gives
$
  Gamma(alpha)&=integral_(0)^(infinity)e^(-s)s^(alpha-1) thin d s,
  quad alpha>0, \
  integral_(0)^(infinity)e^(-s)s^((n-1)/2) thin d s
  &=Gamma(lr(frac(n+1,2))).
$ #(s.tag)("poisson-kernel-gamma-integral")

#block(breakable: false)[

#paragraph_tab
Substituting #(s.ref)("poisson-kernel-transformed-integral") and #(s.ref)("poisson-kernel-gamma-integral") into #(s.ref)("poisson-kernel-time-integral"), we obtain the result by simplifying the coefficient and then replacing $B$:
#flowbox[
  #show math.equation: set block(above: 0.5em, below: 0.5em)
  $
    P_(y)^((n))(x)=frac(y,(4pi)^((n+1)/2))
      lr((frac(4,B)))^((n+1)/2)Gamma(lr(frac(n+1,2))).
  $
  $arrow.b$
  $
    P_(y)^((n))(x)&=frac(y dot 4^((n+1)/2)Gamma((n+1)/2),
      4^((n+1)/2)pi^((n+1)/2)B^((n+1)/2)) \
    &=frac(Gamma((n+1)/2),pi^((n+1)/2))
      frac(y,B^((n+1)/2)).
  $
  $arrow.b$
  $
    P_(y)^((n))(x)=frac(Gamma((n+1)/2),pi^((n+1)/2))
      frac(y,(y^(2)+|x|^(2))^((n+1)/2)).
  $ #(s.tag)("poisson-kernel")
]
For $n=1$, $Gamma(1)=1$, so #(s.ref)("poisson-kernel") reduces to $P_(y)^((1))(x)=y/(pi(y^(2)+x^(2)))$, agreeing with #(s.ref)("subordination-known-kernels").
]

#block(breakable: false)[

#paragraph_tab
To see explicitly how #(s.ref)("poisson-kernel") gives a convolution, evaluate #(s.ref)("subordination-convolution") at $x$. The convolution inside the heat-time integral places the heat kernel at the displacement $x-z$. Averaging those kernels gives $P_(y)^((n))(x-z)$ by #(s.ref)("subordination-kernel-mixture"), so
$
  (e^(-y A)f)(x)
  &=integral_(bb(R)^(n))P_(y)^((n))(x-z)f(z) thin d z \
  &=integral_(bb(R)^(n))
    underbrace(
      frac(Gamma((n+1)/2),pi^((n+1)/2))
      frac(y,(y^(2)+|x-z|^(2))^((n+1)/2)),
      P_(y)^((n))(x-z)
    )f(z) thin d z \
  &=(P_(y)^((n))*f)(x).
$ #(s.tag)("poisson-solution-convolution")
The underbrace identifies the formula from #(s.ref)("poisson-kernel") with $x$ replaced by $x-z$. The final equality is exactly the convolution integral #(s.ref)("ordinary-convolution-integral") with $k=P_(y)^((n))$: we integrate the translated kernel $P_(y)^((n))(x-z)$ against $f(z)$.
]

])
