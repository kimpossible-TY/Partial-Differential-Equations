#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "../Styles/mannot_utils.typ": mannot-scope
#import "@preview/mannot:0.4.0": *

#let distribution-probe-video-url = "https://github.com/kimpossible-TY/Partial-Differential-Equations/releases/download/distribution-video-v2/DistributionProbeResponseV2.mp4"
#let schwartz-space-video-url = "https://github.com/kimpossible-TY/Partial-Differential-Equations/releases/download/schwartz-space-rapid-decay-v1/SchwartzSpaceRapidDecay.mp4"

== From differential operators to tempered distributions

#local-scope-annotations(s => ([
#paragraph_tab
The symbol of a differential operator, the Fourier transform, and the theory of distributions are not three independent subjects. They form one argument. A differential operator first reveals how it acts on oscillation; the Fourier transform turns that oscillatory description into multiplication; the attempt to solve the resulting algebraic equation then forces us to enlarge the class of functions.

#figure(
  development-chain-diagram(),
  caption: [The continuous route from a differential operator to a fundamental solution.],
)

The aim of this section is to make every arrow in this chain explicit while keeping one normalization and one differential-operator convention throughout.

#paragraph_tab
@differential_operator develops this material in detail. We retain its scalar convention $D_(j)=1/i thin partial_(j)=-i partial_(j)$ and refer to @definition_of_general_differential_operator and @principal_symbol_coordinate_formula and @covector_version_of_D_in_differential_operator for the full coordinate setup.
#mannot-scope(
  m => [
    #v(0.8em)
    $
      P_(m)
      &:= sum_(|alpha|=m) p_(alpha)(x)
        mark(
          D^(alpha),
          tag: #(m.tag)("operator-monomial"),
          color: #olive,
        ) \
      &mapsto sum_(|alpha|=m) p_(alpha)(x)
        mark(
          xi^(alpha),
          tag: #(m.tag)("frequency-monomial"),
          color: #purple,
        ) \
      &=
        p_(m)(x,xi)
      \
      p_(m)(x,mark(
        d phi_(x),
        tag: #(m.tag)("phase-frequency"),
        color: #blue,
      ))
      &= sigma_(P)(x,d phi_(x)).

      #annot(
        (m.tag)("operator-monomial"),
        pos: top + left,
        dx: -1em,
        leader-connect: "elbow",
      )[top-order monomial]
      #annot(
        (m.tag)("frequency-monomial"),
        pos: top + right,
        dx: 0.8em,
        leader-connect: "elbow",
      )[plane-wave substitution]
      #annot(
        (m.tag)("phase-frequency"),
        pos: bottom + left,
        dx: -0.8em,
        leader-connect: "elbow",
      )[phase frequency]
    $
    #v(0.8em)
  ],
  prefix: "chapter-3-principal-symbol-identification",
)

Thus $p_(m)(x,xi)$ is the coordinate representative of $sigma_(P)$, and $xi=d phi_(x)$ supplies the covector at which that symbol acts. On $bb(R)^(n)$, we identify this covector with its frequency vector $rho$.

#paragraph_tab
Due to @coordinate-free_definition_of_principal_symbol, the symbol describes how the highest-order part of $P$ acts on local oscillations. The phase gradient $d phi$ is the local frequency, and $sigma_(P)(x,d phi)$ is the leading response of the operator to that frequency.

#mannot-scope(
  m => [
    #v(0.8em)
    $
      lim_(lambda arrow.r infinity)
      mark(
        lambda^(-m),
        tag: #(m.tag)("order-normalization"),
        color: #olive,
      )
      mark(
        e^(-i lambda x dot phi),
        tag: #(m.tag)("phase-cancellation"),
        color: #purple,
      )
      P(
        u(x)
        mark(
          e^(i lambda x dot phi),
          tag: #(m.tag)("frequency-oscillation"),
          color: #blue,
        )
      )
      &= mark(
        p_(m)(x,phi),
        tag: #(m.tag)("principal-symbol-at-frequency"),
        color: #fuchsia,
      )u(x).

      #annot(
        (m.tag)("order-normalization"),
        pos: top + left,
        dx: -0.8em,
        leader-connect: "elbow",
      )[normalize the order-$m$ growth]
      #annot(
        (m.tag)("phase-cancellation"),
        pos: bottom + left,
        dx: -0.8em,
        dy : 1em,
        leader-connect: "elbow",
      )[cancel the oscillatory phase]
      #annot(
        (m.tag)("frequency-oscillation"),
        pos: top + right,
        dx: 0.8em,
        leader-connect: "elbow",
      )[test oscillation with frequency $phi$]
      #annot(
        (m.tag)("principal-symbol-at-frequency"),
        pos: bottom + right,
        dx: 0.8em,
        leader-connect: "elbow",
      )[leading response at $phi$]
    $
    #v(0.8em)
  ],
  prefix: "chapter-3-principal-symbol-frequency-limit",
)

#paragraph_tab
The oscillatory factor in the preceding limit is already a plane wave: for the special phase $phi(x)=x dot rho$, it is $e^(i lambda x dot rho)$. This points naturally to Fourier analysis, which reconstructs functions by superposing precisely these plane-wave modes.

=== Fourier analysis and differential operator

#paragraph_tab
The plane-wave viewpoint becomes useful only after we choose a function space in which the Fourier integrals and repeated integrations by parts are legitimate. The Schwartz space supplies the required smoothness and rapid decay.#footnote[#link(schwartz-space-video-url)[#underline[the accompanying rapid-decay visualization]] makes this structure concrete.] Let $cal(S)(bb(R)^(n))$ be the standard Schwartz space, with seminorms
$
  q_(alpha,beta)(u):=sup_(x in bb(R)^(n))|x^(alpha)partial^(beta)u(x)|
$

#paragraph_tab
With the function space fixed, we must also fix a normalization so that the inverse transform and the constants in later convolution formulas are unambiguous. We use the unitary convention
$
  hat(u)(xi)=cal(F)u(xi)
  &:=(2 pi)^(-n/2)
    integral_(bb(R)^(n))u(x)e^(-i x dot xi) thin d x,
  \
  cal(F)^(-1)v(x)
  &:=(2 pi)^(-n/2)
    integral_(bb(R)^(n))v(xi)e^(i x dot xi) thin d xi.
$

#paragraph_tab
The first structural question is how the Fourier transform represents differentiation, because a constant-coefficient differential operator is assembled from derivatives. Under the convention above, each derivative becomes multiplication by its corresponding frequency variable.

#lemma(title: "Fourier transform of derivatives")[
For $u in cal(S)(bb(R)^(n))$ and every multi-index $alpha$,
$
  cal(F)(D^(alpha)u)(xi)=xi^(alpha)hat(u)(xi).
$
] <fourier_transform_of_derivatives>

#proof[
This is the derivative identity in Statement 1.2(4)--(5) of @Fourier.
]

#paragraph_tab
This derivative formula is the exact counterpart of the oscillatory test that motivated the subsection. The test $u e^(i lambda phi)$ gives a local, leading-order response, whereas the Fourier transform superposes the same modes $e^(i x dot xi)$ globally. #highlight()[Because constant coefficients do not mix those frequencies, Fourier transformation upgrades the leading-order relation to an exact multiplication law.] To state that law without discarding the lower-order terms, we must distinguish the full symbol from the principal symbol.

#definition(title: "Full and principal symbols for constant coefficients")[
Consider a constant-coefficient differential operator
$
  P(D):=sum_(|alpha| <= m)a_(alpha)D^(alpha).
$
Its *full symbol* is the polynomial
$
  p(xi):=sum_(|alpha| <= m)a_(alpha)xi^(alpha),
$
whereas its *principal symbol* is only the homogeneous part of highest degree,
$
  p_(m)(xi):=sum_(|alpha|=m)a_(alpha)xi^(alpha).
$
]
The principal symbol controls high-frequency and characteristic behavior. The full symbol records every order and is the polynomial that occurs in the exact Fourier identity.

#paragraph_tab
Now, let us derive the Fourier representation of a constant-coefficient operator $P(D)$ with full symbol $p$. By @fourier_transform_of_derivatives,
$
  cal(F)(P(D)u)(xi) &= sum_(|alpha| <= m)a_(alpha)cal(F)(D^(alpha)u)(xi)
  \
  &= sum_(|alpha| <= m)a_(alpha)xi^(alpha)hat(u)(xi)
  \
  &= p(xi)hat(u)(xi) #dots_space #footnote[by the definition of full symbol $p(xi)$].
$ <Fourier_transform_of_constant_coefficient_differential_operator>

@Fourier_transform_of_constant_coefficient_differential_operator shows that, at each frequency $xi$, $cal(F)(P(D)u)(xi)$ depends only on $hat(u)(xi)$. Thus the action is pointwise in frequency space. To pass from this pointwise identity to an operator identity, define:
#definition(title: "Multiplication operator")[
For the full symbol $p$ of $P(D)$, define the associated multiplication operator by
$
  M_(p):cal(S)(bb(R)^(n)) arrow.r cal(S)(bb(R)^(n)),
  quad
  lr(M_(p)v)(xi):=p(xi)v(xi)
$
]
Let $v:= hat(u)$. To abstract @Fourier_transform_of_constant_coefficient_differential_operator, 
$
  cal(F)P(D)u(xi)&=M_(p) cal(F) u(xi)
  \
  cal(F)P(D) &= M_(p) cal(F)
  \
  cal(F) P(D) cal(F)^(-1) &= M_(p)
$ #(s.tag)("usage of Fourier multiplication operator")

Thus the Fourier transform diagonalizes $P(D)$: differentiation in the physical variable becomes multiplication by the full symbol in the frequency variable.

#paragraph_tab
#highlight()[This diagonalization raises a necessary scope question: why must the coefficients be constant?] A variable-coefficient term has the form $p_(alpha)(x)D^(alpha)u$, so answering the question requires knowing how the Fourier transform treats products. The product rule below, together with its companion convolution rule, identifies the resulting interaction between frequencies.

#lemma(title: "Convolution formulas for the Fourier transform")[
For $f,g in cal(S)(bb(R)^(n))$, define
$
  (f*g)(x)
  :=integral_(bb(R)^(n))f(x-y)g(y) thin d y.
$
Under the normalization fixed above,
$
  cal(F)(f*g)
  &=(2 pi)^(n/2)hat(f)hat(g),
  \
  cal(F)(f g)
  &=(2 pi)^(-n/2)lr(hat(f)*hat(g)).
$
] <unitary_fourier_convolution_formulas>

#proof[
This is Statement 1.11 of @Fourier.
]

#paragraph_tab
@unitary_fourier_convolution_formulas exposes exactly why the constant-coefficient assumption is essential. Under the lemma's Schwartz hypotheses, take $f=p_(alpha)$ and $g=D^(alpha)u$. The product formula and the derivative identity give
$
  cal(F)lr(p_(alpha)(x)D^(alpha)u)
  =(2 pi)^(-n/2)
   hat(p_(alpha)) * lr(xi^(alpha)hat(u)),
$
not $p_(alpha)(x)xi^(alpha)hat(u)(xi)$. #highlighted()[Thus multiplication by a variable coefficient becomes convolution with $hat(p_(alpha))$ and couples different frequencies.] The local symbol still describes the leading response to oscillation, #highlight()[but the Fourier transform no longer diagonalizes the whole operator by pointwise multiplication.]


#paragraph_tab
The Laplacian is the most familiar example of @Fourier_transform_of_constant_coefficient_differential_operator:
$
  Delta u:=op("div")op("grad")u
$
In Euclidean coordinates, using $partial_(j)=i D_(j)$, this becomes
$
  Delta
  :=sum_(j=1)^(n)partial_(j)^(2)
  =-sum_(j=1)^(n)D_(j)^(2).
$
#linebreak()
Applying the Fourier derivative identity twice gives
$
  hat(Delta u)(xi)
  &=-sum_(j=1)^(n)cal(F)(D_(j)^(2)u)(xi)
  \
  &=-sum_(j=1)^(n)xi_(j)^(2)hat(u)(xi)
  \
  &=-|xi|^(2)hat(u)(xi).
$
#block(breakable: false)[
  Thus the full and principal symbols of $Delta$ are both
  $
    p(xi)=p_(2)(xi)=-|xi|^(2).
  $
]

#definition(title: "Classical solution and the Schwartz class")[
Let $P(D)$ be a differential operator of order $m$ on $bb(R)^(n)$. A function $u in C^(m)(bb(R)^(n))$ is a *classical solution* of
$
  P(D)u=f
$
if the equality holds at every point of $bb(R)^(n)$. In the present Fourier framework, where $f in cal(S)(bb(R)^(n))$, a classical solution $u in cal(S)(bb(R)^(n))$ is called a *classical Schwartz solution*.
]

#paragraph_tab
Having identified the multiplier, we can reformulate a constant-coefficient PDE as an equation in frequency space. This leads to the following Fourier-algebraic problem.

#definition(title: "Fourier-algebraic problem")[
Fix a constant-coefficient operator $P(D)$ with nonzero full symbol $p$. For prescribed $g in cal(S)(bb(R)^(n))$, the associated *Fourier-algebraic problem* is to find $U in cal(S)(bb(R)^(n))$ such that
$
  M_(p)U=g,
  quad
  lr(M_(p)U)(xi):=p(xi)U(xi).
$
For the partial differential equation $P(D)u=f$, replace $U arrow.r cal(F)u$ and $g arrow.r cal(F)f$. #(s.ref)("usage of Fourier multiplication operator") then gives the exact equivalence:
$
  P(D)u=f
  quad arrow.l.r quad
  M_(p)U=g,
  quad
  u=cal(F)^(-1)U.
$
] <fourier_algebraic_problem>
The word algebraic means that the unknown $U$ is no longer differentiated: the transformed equation uses only multiplication by the known polynomial $p$.

#paragraph_tab
Multiplication by $p$ must be inverted within $cal(S)$. Away from the zeros of $p$, that inversion is pointwise. On the open set
$
  Omega_(p):={xi in bb(R)^(n):p(xi) eq.not 0},
$
the equation forces the unique candidate
$
  U(xi)=frac(g(xi),p(xi)).
$
The complementary zero set
$
  Z(p):={xi in bb(R)^(n):p(xi)=0}
$
is the division-singularity set of the full symbol.

=== Distributional differentiation and the first generalized derivative

#paragraph_tab
Now, let's treat the Laplace equation $Delta u = f$ on $bb(R)^(n)$, where $f in cal(S)(bb(R)^(n))$. When $xi eq.not 0$, the Fourier-algebraic problem in @fourier_algebraic_problem gives the frequency candidate:
$
  U(xi) = -frac(hat(f)(xi), |xi|^(2)).
$ #(s.tag)("result of Fourier-algebraic problem")
From #(s.ref)("result of Fourier-algebraic problem"), we see that the rapid decay of $hat(f)$ controls the quotient as $|xi| arrow.r infinity$. The difficulty is at $xi = 0$: the factor $|xi|^(-2)$ blows up, and $hat(f)(0)$ need not vanish.

#paragraph_tab
Therefore, $U$ does not belong to the Schwartz space $cal(S)$ in general, which means we cannot apply the classical inverse Fourier transform directly! This is the exact moment where distributions become necessary: we want to find a generalized object $U$ that satisfies $-|xi|^(2) U = hat(f)$, and then recover our solution $u$ by extending the inverse Fourier transform to these generalized objects. (Consider #link(distribution-probe-video-url)[#underline[narrated visualization]] for further intuition).

#definition(title: "Distribution as a continuous covector")[
The test-function space
$
  cal(D)(bb(R)^(n)) := C_(c)^(infinity)(bb(R)^(n))
$
is an infinite-dimensional vector space of smooth functions with compact support. Its continuous dual space is
$
  cal(D)^(*)(bb(R)^(n)) := lr(cal(D)(bb(R)^(n)))^(*).
$
An element $w in cal(D)^(*)(bb(R)^(n))$, in other words a continuous linear map
$
  w : cal(D)(bb(R)^(n)) arrow.r bb(C),
$
is called a *distribution*.#footnote[A distribution is a continuous covector on the test-function space $cal(D)$, not a covector field on $bb(R)^(n)$.]
] <definition_of_distribution>
Continuity means that if a sequence of test functions $phi_(k)$ are all supported in one fixed compact set $K$ and every derivative $partial^(alpha) phi_(k)$ converges uniformly to zero, then
$
  chevron.l phi_(k), w chevron.r arrow.r 0.
$
#linebreak()
Equivalently, for every compact set $K subset bb(R)^(n)$, there exist a constant $C_(K)$ and an integer $N_(K)$ such that
$
  |chevron.l phi, w chevron.r|
  <= C_(K)
    max_(|alpha| <= N_(K))
    sup_(x in K) |partial^(alpha) phi(x)|
$ #(s.tag)("distribution_continuity_estimate")
#linebreak()
whenever $op("supp")(phi) subset K$.

#note[
In simpler terms, a distribution is like a measuring device: it need not have a pointwise value at each $x$, but it takes a smooth test function $phi$ and returns the scalar $chevron.l phi, w chevron.r$.
]

#paragraph_tab
The simplest distributions come from ordinary functions. Since every test function $phi$ has compact support, the defining integral only requires local integrability rather than global integrability.

#definition(title: "Regular distribution induced by a locally integrable function")[
Let $f in L^(1)_("loc")(bb(R)^(n))$; that is,
$
  integral_K |f(x)| thin d x < infinity
$
for every compact set $K subset bb(R)^(n)$. The *regular distribution induced by* $f$ is the linear functional $T_(f) in cal(D)^(*)(bb(R)^(n))$ defined by
$
  chevron.l phi, T_(f) chevron.r
  := integral_(bb(R)^(n)) f(x) phi(x) thin d x,
  quad
  phi in cal(D)(bb(R)^(n)).
$
Indeed, if $op("supp")(phi) subset K$, then
$
  |chevron.l phi, T_(f) chevron.r|
  <= lr(integral_K |f(x)| thin d x)
    sup_(x in K) |phi(x)| #dots_space #footnote[by Hölder's inequality for $L^(1)$ and $L^(infinity)$],
$
so $T_(f)$ is continuous and has distributional order zero on each compact set.
] <regular_distribution_induced_by_locally_integrable_function>

#paragraph_tab
Now @regular_distribution_induced_by_locally_integrable_function gives a clear meaning to our candidate in #(s.ref)("result of Fourier-algebraic problem"). Away from $xi = 0$, $U$ is the smooth function $-hat(f)(xi)/|xi|^(2)$ and defines a regular distribution. At $xi = 0$, we treat the singular quotient distributionally so that:
$
  -|xi|^(2) U = hat(f).
$
Thus $U$ does not need to be an ordinary function at the origin; its action on test functions completely replaces pointwise evaluation.

=== Distributional derivative

#paragraph_tab
Now we face our next big question. Suppose we find $U$ as a distribution and take its inverse Fourier transform:
$
  u = cal(F)^(-1) U.
$ #(s.tag)("reconstructed_distributional_solution")
Since $U$ is a distribution, its inverse transform $u$ in #(s.ref)("reconstructed_distributional_solution") is also a distribution rather than a smooth $C^(m)$ function.

#paragraph_tab
Then how can we apply the differential operator $P(D)$ to $u$? #highlight()[The classical differential operator only knows how to differentiate smooth functions point by point.] If we try to differentiate a distribution point by point, it makes no sense at all!

#flowbox[
$ U = hat(f) / p "is a distribution" $

$arrow.b$

$ u = cal(F)^(-1) U "is also a distribution" $

$arrow.b$

"How can we apply the differential operator" $P(D)$ "to a distribution" $u$?
]

#paragraph_tab
This shows exactly why we must extend differentiation to distributions. We need derivatives acting on distributions so that the identity
$
  cal(F)(P(D) u) = p cal(F) u
$
still holds. Only then can our frequency-space solution $U$ return to physical space and solve $P(D) u = f$.

#paragraph_tab
How can we define the derivative of a distribution? The key idea is integration by parts.
First, consider the smooth case $f in C^(1)(bb(R)^(n))$ and $phi in cal(D)(bb(R)^(n))$. Computing the pairing gives:

#mannot-scope(
  m => [
    #v(0.8em)
    $
      chevron.l phi, mark(T_(partial_(j) f), tag: #(m.tag)("dist-deriv"), color: #olive) chevron.r
      &= integral_(bb(R)^(n)) partial_(j) f(x) phi(x) thin d x #dots_space #footnote[by definition of regular distribution (@regular_distribution_induced_by_locally_integrable_function)] \
      &= - integral_(bb(R)^(n)) f(x) mark(partial_(j) phi(x), tag: #(m.tag)("test-deriv"), color: #purple) thin d x #dots_space #footnote[by integration by parts, the boundary term vanishes because $phi in cal(D)$ has compact support] \
      &= - chevron.l mark(partial_(j) phi, tag: #(m.tag)("shifted-deriv"), color: #purple), T_(f) chevron.r.

      #annot(
        (m.tag)("dist-deriv"),
        pos: top + left,
        dx: -0.8em,
        leader-connect: "elbow",
      )[derivative on distribution]
      #annot(
        (m.tag)("test-deriv"),
        pos: bottom + right,
        dx: 0.8em,
        leader-connect: "elbow",
      )[derivative shifts to test function]
    $
    #v(0.8em)
  ],
  prefix: "chapter-3-distributional-derivative-ibp",
)

#paragraph_tab
In simpler terms, #highlighted()[the last line shows that the derivative $partial_(j)$ no longer acts on $f$.] It moves to the test function $phi$, with a minus sign. Since $phi$ is smooth, $partial_(j) phi$ is always defined, even when $f$ is not differentiable. This observation gives the natural definition of the derivative of an arbitrary distribution.

#definition(title: "Distributional derivative")[
Let $w in cal(D)^(*)(bb(R)^(n))$. For $j in {1, dots, n}$, the *distributional derivative* $partial_(j) w$ is defined by
$
  chevron.l phi, partial_(j) w chevron.r
  := - chevron.l partial_(j) phi, w chevron.r,
  quad
  phi in cal(D)(bb(R)^(n)).
$
For a multi-index $alpha$, repeating this step $|alpha|$ times gives
$
  chevron.l phi, partial^(alpha) w chevron.r
  = (-1)^(|alpha|)
    chevron.l partial^(alpha) phi, w chevron.r.
$
Under the convention $D_(j) = -i partial_(j)$ used in this section, the same definition becomes
$
  chevron.l phi, D^(alpha) w chevron.r
  = (-1)^(|alpha|)
    chevron.l D^(alpha) phi, w chevron.r.
$
] <definition_of_distributional_derivative>

#lemma(title: "Distributional derivatives are distributions")[
For every $w in cal(D)^(*)(bb(R)^(n))$ and every multi-index $alpha$, the functional $partial^(alpha) w$ defined in @definition_of_distributional_derivative belongs to $cal(D)^(*)(bb(R)^(n))$.
] <distributional_derivatives_are_distributions>

#proof[
First, linearity follows directly from the linearity of $w$ and $partial^(alpha)$. Next, let's verify continuity. Fix a compact set $K subset bb(R)^(n)$. Suppose that on test functions supported in $K$, the distribution $w$ satisfies the continuity estimate in #(s.ref)("distribution_continuity_estimate"):
$
  |chevron.l phi, w chevron.r|
  <= C_(K)
    max_(|beta| <= N_(K))
    sup_(x in K) |partial^(beta) phi(x)| #dots_space #footnote[from @definition_of_distribution on the compact set $K$].
$
Then for the distributional derivative $partial^(alpha) w$, we have:
$
  |chevron.l phi, partial^(alpha) w chevron.r|
  &= |chevron.l partial^(alpha) phi, w chevron.r| #dots_space #footnote[from @definition_of_distributional_derivative] \
  &<= C_(K)
    max_(|beta| <= N_(K))
    sup_(x in K)
      |partial^(beta + alpha) phi(x)| #dots_space #footnote[applying #(s.ref)("distribution_continuity_estimate") to the test function $partial^(alpha) phi$] \
  &<= C_(K)
    max_(|gamma| <= N_(K) + |alpha|)
    sup_(x in K) |partial^(gamma) phi(x)| #dots_space #footnote[relabeling the multi-index $gamma = beta + alpha$].
$
Hence $partial^(alpha) w$ is continuous on $cal(D)(bb(R)^(n))$ and is indeed a distribution.
]

#paragraph_tab
The integration-by-parts calculation above shows that this construction agrees with classical differentiation whenever $f$ is smooth:
$
  partial^(alpha) T_(f) = T_(partial^(alpha) f)
$ #(s.tag)("compatibility_with_classical_derivatives")
for every $f in C^(|alpha|)(bb(R)^(n))$. Thus #(s.ref)("compatibility_with_classical_derivatives") proves that distributional differentiation extends the classical derivative rather than replacing it.

=== Singular distributions: the Dirac delta

#paragraph_tab
Now, let's see what happens when a function is not differentiable in the classical sense. Let's test the simplest example: the Heaviside step function:
$
  H(x) := cases(
    0 & "if" x < 0,
    1 & "if" x > 0.
  )
$ #(s.tag)("definition_of_heaviside_function")
Since a single point has Lebesgue measure zero, the value of $H$ at $x = 0$ does not change the integral. Because $H in L^(1)_("loc")(bb(R))$, by @regular_distribution_induced_by_locally_integrable_function it defines a regular distribution:
$
  chevron.l phi, T_(H) chevron.r
  = integral_0^(infinity) phi(x) thin d x.
$ #(s.tag)("heaviside_regular_distribution_pairing")

#paragraph_tab
The pointwise derivative of $H$ exists and equals $0$ for $x eq.not 0$, but it is undefined at $x=0$. Thus the almost-everywhere derivative misses the unit jump at the origin.#footnote[In the Sobolev sense, $H$ has no $L^(1)_("loc")$ weak derivative: its distributional derivative is $delta_(0)$, which is not represented by a locally integrable function.]

#paragraph_tab
Now, let's see what happens if we use our distributional derivative from @definition_of_distributional_derivative:
$
  chevron.l phi, partial T_(H) chevron.r
  &= - chevron.l partial phi, T_(H) chevron.r #dots_space #footnote[from @definition_of_distributional_derivative] \
  &= - integral_0^(infinity) phi'(x) thin d x #dots_space #footnote[from #(s.ref)("heaviside_regular_distribution_pairing")] \
  &= - lr([ phi(x) ])_(0)^(infinity) #dots_space #footnote[by the Fundamental Theorem of Calculus] \
  &= - lr( lim_(x arrow.r infinity) phi(x) - phi(0) ) \
  &= phi(0) #dots_space #footnote[since $phi in cal(D)(bb(R))$ has compact support, $phi(x) = 0$ for large $x$].
$ #(s.tag)("heaviside_distributional_derivative_computation")

#paragraph_tab
Look at the result: the distributional derivative does not vanish! It cleanly evaluates the test function at the exact location of the jump, $x = 0$.

#definition(title: "Dirac distribution")[
For $a in bb(R)^(n)$, the *Dirac distribution concentrated at* $a$ is the functional $delta_(a) in cal(D)^(*)(bb(R)^(n))$ defined by
$
  chevron.l phi, delta_(a) chevron.r := phi(a),
  quad
  phi in cal(D)(bb(R)^(n)).
$
It is continuous because, whenever $op("supp")(phi) subset K$ and $a in K$,
$
  |chevron.l phi, delta_(a) chevron.r|
  <= sup_(x in K) |phi(x)|.
$
If $a in.not K$, then $phi(a) = 0$.
] <definition_of_dirac_distribution>

#pagebreak()

#paragraph_tab
Comparing #(s.ref)("heaviside_distributional_derivative_computation") with @definition_of_dirac_distribution gives:
$
  partial T_(H) = delta_(0).
$ #(s.tag)("distributional-derivative-of-heaviside")
Thus #(s.ref)("distributional-derivative-of-heaviside") shows that the generalized derivative cleanly records the unit jump of $H$ as an object concentrated at the origin.

#figure(
  heaviside-dirac-diagram(),
  caption: [The Heaviside step function $H(x)$ and its distributional derivative, the Dirac delta distribution $delta_(0)$.],
)

#definition(title: "Singular distribution")[
A distribution $w in cal(D)^(*)(bb(R)^(n))$ is called *regular* if $w = T_(f)$ for some locally integrable function $f in L^(1)_("loc")(bb(R)^(n))$ by @regular_distribution_induced_by_locally_integrable_function. Otherwise, $w$ is called a *singular distribution*.
] <definition_of_singular_distribution>

#proposition(title: "The Dirac distribution is singular")[
For every $a in bb(R)^(n)$, the Dirac distribution $delta_(a)$ from @definition_of_dirac_distribution is not induced by any locally integrable function.
] <dirac_distribution_is_singular>

#proof[
Since a singular distribution is defined as one that is not regular, assume for contradiction that $delta_(a)$ is regular, so $delta_(a) = T_(g)$ for some $g in L^(1)_("loc")(bb(R)^(n))$. Let's choose a standard smooth cutoff bump function $eta in cal(D)(bb(R)^(n))$ satisfying $0 <= eta <= 1$, $eta(0) = 1$, and $op("supp")(eta) subset B_(1)(0)$. For each $epsilon > 0$, let's rescale it:
$
  eta_(epsilon)(x) := eta lr(frac(x - a, epsilon)).
$ #(s.tag)("rescaled_cutoff_bump")
Then $eta_(epsilon)(a) = eta(0) = 1$ and $op("supp")(eta_(epsilon)) subset B_(epsilon)(a)$.

#figure(
  rescaled-bump-diagram(),
  caption: [The rescaled cutoff bump function $eta_(epsilon)(x) = eta((x - a)/epsilon)$ for $epsilon_(1) > epsilon_(2) > epsilon_(3)$. The apex remains fixed at $eta_(epsilon)(a) = 1$ while the support $B_(epsilon)(a)$ shrinks toward $\{a\}$.],
)

#paragraph_tab
Now, let's evaluate $delta_(a)$ and $T_(g)$ on $eta_(epsilon)$:
$
  1
  &= |eta_(epsilon)(a)| \
  &= |chevron.l eta_(epsilon), delta_(a) chevron.r| #dots_space #footnote[by @definition_of_dirac_distribution] \
  &= |chevron.l eta_(epsilon), T_(g) chevron.r| #dots_space #footnote[by our assumption $delta_(a) = T_(g)$ in @regular_distribution_induced_by_locally_integrable_function] \
  &= lr(|integral_(B_(epsilon)(a)) g(x) eta_(epsilon)(x) thin d x|) #dots_space #footnote[since $op("supp")(eta_(epsilon)) subset B_(epsilon)(a)$ from #(s.ref)("rescaled_cutoff_bump")] \
  &<= integral_(B_(epsilon)(a)) |g(x)| thin d x #dots_space #footnote[since $|eta_(epsilon)| <= 1$].
$
Because $g$ is locally integrable, as $epsilon arrow.r 0$, the measure of the ball $|B_(epsilon)(a)| arrow.r 0$, so the integral tends to zero:
$
  lim_(epsilon arrow.r 0) integral_(B_(epsilon)(a)) |g(x)| thin d x = 0.
$
This gives $1 <= 0$, which is an immediate contradiction! Hence $delta_(a)$ cannot be represented by any locally integrable function, so $delta_(a)$ is singular.
]

#emphasis[
*The Key Takeaway:*
$
  underbrace(T_(H), "regular distribution")
  arrow.r^(partial)
  underbrace(delta_(0), "singular distribution").
$
Distributional differentiation can carry a regular distribution outside the regular class! The full space $cal(D)^(*)$ is the natural home because it is closed under differentiation of all orders.
]

#paragraph_tab
Now that every monomial derivative $D^(alpha) w$ is defined by @definition_of_distributional_derivative, we can extend any constant-coefficient differential operator
$
  P(D) = sum_(|alpha| <= m) a_(alpha) D^(alpha)
$
to act on distributions by setting:
$
  P(D) w := sum_(|alpha| <= m) a_(alpha) D^(alpha) w.
$ #(s.tag)("distributional_differential_operator_definition")

Once the Fourier transform and its inverse are extended to distributions, the identity in @Fourier_transform_of_constant_coefficient_differential_operator
$
  cal(F)(P(D) w) = p cal(F) w
$
will continue to hold. Then, if $U$ satisfies $p U = hat(f)$ from #(s.ref)("result of Fourier-algebraic problem") and we set $u = cal(F)^(-1) U$, we get:
$
  P(D) u
  &= cal(F)^(-1)(p U) #dots_space #footnote[by the multiplier identity extended from @Fourier_transform_of_constant_coefficient_differential_operator] \
  &= cal(F)^(-1)(hat(f)) #dots_space #footnote[from #(s.ref)("result of Fourier-algebraic problem")] \
  &= f.
$
This closes the loop from our frequency-space candidate to the actual solution of the differential equation!

=== Tempered distributions and Fourier duality

#paragraph_tab
Now comes the next natural question: can we apply the Fourier transform to an arbitrary distribution in $cal(D)^(*)(bb(R)^(n))$? At first glance, we might try to use duality directly:
$
  chevron.l phi, cal(F) w chevron.r
  " =? "
  chevron.l cal(F) phi, w chevron.r.
$ #(s.tag)("tentative_fourier_duality_pairing")
However, the direct duality attempt in #(s.ref)("tentative_fourier_duality_pairing") fails. If $phi in cal(D)(bb(R)^(n))$ is nonzero, then $cal(F) phi$ is analytic and cannot have compact support. Since an arbitrary distribution $w in cal(D)^(*)(bb(R)^(n))$ acts only on compactly supported test functions, the pairing $chevron.l cal(F) phi, w chevron.r$ is not defined.

#paragraph_tab
To fix this mismatch, we replace $cal(D)$ with the Schwartz space $cal(S)$. As we established, the Fourier transform is a continuous isomorphism on $cal(S)$:
$
  cal(F) : cal(S)(bb(R)^(n)) arrow.r cal(S)(bb(R)^(n)).
$
Therefore, we take the continuous dual of $cal(S)$ instead of $cal(D)$.

#definition(title: "Tempered distribution")[
A *tempered distribution* on $bb(R)^(n)$ is a continuous linear functional on the Schwartz space $cal(S)(bb(R)^(n))$. The space of tempered distributions is denoted by
$
  cal(S)^(*)(bb(R)^(n))
  := lr(cal(S)(bb(R)^(n)))^(*).
$
Equivalently, $w in cal(S)^(*)(bb(R)^(n))$ if and only if there exist a constant $C > 0$ and an integer $N >= 0$ such that
$
  |chevron.l phi, w chevron.r|
  <= C
    max_(|alpha| + |beta| <= N)
    q_(alpha, beta)(phi) #dots_space #footnote[where $q_(alpha, beta)$ is the Schwartz seminorm defined above: $q_(alpha, beta)(phi) = sup_(x in bb(R)^(n)) |x^(alpha) partial^(beta) phi(x)|$.]
$
for every test function $phi in cal(S)(bb(R)^(n))$.
] <definition_of_tempered_distribution>

#paragraph_tab
Because $cal(D)(bb(R)^(n)) subset cal(S)(bb(R)^(n))$,#footnote[Compactly supported is more restrictive than rapidly decreasing.] every tempered distribution in @definition_of_tempered_distribution restricts to an ordinary distribution:
$
  cal(S)^(*)(bb(R)^(n)) arrow.r cal(D)^(*)(bb(R)^(n)),
  quad
  w arrow.r w|_(cal(D)).
$
Furthermore, if $w in cal(S)^(*)$, then $partial^(alpha) w in cal(S)^(*)$ because differentiation maps $cal(S)$ continuously into itself. Likewise, multiplication by a polynomial $p(x)$ is defined by:
$
  chevron.l phi, p w chevron.r
  := chevron.l p phi, w chevron.r #dots_space #footnote[since $p phi in cal(S)$ whenever $phi in cal(S)$].
$

#definition(title: "Fourier transform of a tempered distribution")[
For $w in cal(S)^(*)(bb(R)^(n))$, the Fourier transform $cal(F) w$ and the inverse Fourier transform $cal(F)^(-1) w$ are defined by
$
  chevron.l phi, cal(F) w chevron.r
  &:= chevron.l cal(F) phi, w chevron.r, \
  chevron.l phi, cal(F)^(-1) w chevron.r
  &:= chevron.l cal(F)^(-1) phi, w chevron.r
$
for every $phi in cal(S)(bb(R)^(n))$.
] <definition_of_fourier_transform_on_tempered_distributions>

#proposition(title: "Fourier inversion on tempered distributions")[
The Fourier transform and inverse Fourier transform
$
  cal(F), cal(F)^(-1) : cal(S)^(*)(bb(R)^(n)) arrow.r cal(S)^(*)(bb(R)^(n))
$
are continuous isomorphisms and inverse to each other.
If $f in cal(S)(bb(R)^(n))$, then this transform agrees with the regular distribution induced by the classical Fourier transform:
$
  cal(F) T_(f) = T_(hat(f)).
$
] <fourier_inversion_on_tempered_distributions>

#proof[
Continuity follows immediately because $cal(F)$ and $cal(F)^(-1)$ act continuously on $cal(S)(bb(R)^(n))$.

#paragraph_tab
For the inversion formula, let $w in cal(S)^(*)$ and $phi in cal(S)$. Then:
$
  chevron.l phi, cal(F)^(-1) cal(F) w chevron.r
  &= chevron.l cal(F)^(-1) phi, cal(F) w chevron.r #dots_space #footnote[from @definition_of_fourier_transform_on_tempered_distributions] \
  &= chevron.l cal(F) cal(F)^(-1) phi, w chevron.r #dots_space #footnote[from @definition_of_fourier_transform_on_tempered_distributions] \
  &= chevron.l phi, w chevron.r #dots_space #footnote[by the classical Fourier inversion theorem on $cal(S)$; see @Fourier.].
$
The reverse composition $cal(F) cal(F)^(-1) w = w$ is identical.

#paragraph_tab
For a regular distribution $T_(f)$ with $f in cal(S)$, we use Fubini's theorem and the unitary normalization:
$
  chevron.l phi, cal(F) T_(f) chevron.r
  &= chevron.l cal(F) phi, T_(f) chevron.r #dots_space #footnote[from @definition_of_fourier_transform_on_tempered_distributions] \
  &= integral_(bb(R)^(n)) f(x) cal(F) phi(x) thin d x #dots_space #footnote[by @regular_distribution_induced_by_locally_integrable_function] \
  &= integral_(bb(R)^(n)) f(x) lr( (2 pi)^(-n/2) integral_(bb(R)^(n)) phi(xi) e^(-i x dot xi) thin d xi ) thin d x #dots_space #footnote[by classical Fourier transform on $cal(S)$] \
  &= integral_(bb(R)^(n)) lr( (2 pi)^(-n/2) integral_(bb(R)^(n)) f(x) e^(-i x dot xi) thin d x ) phi(xi) thin d xi #dots_space #footnote[by Fubini's theorem] \
  &= integral_(bb(R)^(n)) hat(f)(xi) phi(xi) thin d xi #dots_space #footnote[by definition of $hat(f)$] \
  &= chevron.l phi, T_(hat(f)) chevron.r #dots_space #footnote[by @regular_distribution_induced_by_locally_integrable_function].
$
Hence $cal(F) T_(f) = T_(hat(f))$.
]

#proposition(title: "Differentiation remains multiplication by frequency")[
For every $w in cal(S)^(*)(bb(R)^(n))$ and every multi-index $alpha$,
$
  cal(F)(D^(alpha) w) = xi^(alpha) cal(F) w.
$
Consequently, if $P(D)$ is a constant-coefficient operator with full symbol $p$, then
$
  cal(F)(P(D) w) = p cal(F) w.
$
] <fourier_multiplier_identity_on_tempered_distributions>

#proof[
It is enough to check for a single derivative $D_(j) = -i partial_(j)$. For every $phi in cal(S)$,
$
  chevron.l phi, cal(F)(D_(j) w) chevron.r
  &= chevron.l cal(F) phi, D_(j) w chevron.r #dots_space #footnote[from @definition_of_fourier_transform_on_tempered_distributions] \
  &= - chevron.l D_(j) cal(F) phi, w chevron.r #dots_space #footnote[from @definition_of_distributional_derivative] \
  &= chevron.l cal(F)(xi_(j) phi), w chevron.r #dots_space #footnote[since $-D_(j) cal(F) phi(xi) = cal(F)(xi_(j) phi)(xi)$ by @fourier_transform_of_derivatives] \
  &= chevron.l xi_(j) phi, cal(F) w chevron.r #dots_space #footnote[from @definition_of_fourier_transform_on_tempered_distributions] \
  &= chevron.l phi, xi_(j) cal(F) w chevron.r #dots_space #footnote[by definition of polynomial multiplication on $cal(S)^(*)$].
$
Repeating this step $|alpha|$ times gives $cal(F)(D^(alpha) w) = xi^(alpha) cal(F) w$. Then by linearity, we obtain $cal(F)(P(D) w) = p cal(F) w$.
]

#paragraph_tab
Now let's compute the Fourier transform of the Dirac delta $delta_(0)$. Applying @definition_of_fourier_transform_on_tempered_distributions to $delta_(0)$ gives:
$
  chevron.l phi, cal(F) delta_(0) chevron.r
  &= chevron.l cal(F) phi, delta_(0) chevron.r #dots_space #footnote[from @definition_of_fourier_transform_on_tempered_distributions] \
  &= cal(F) phi(0) #dots_space #footnote[from @definition_of_dirac_distribution] \
  &= (2 pi)^(-n/2) integral_(bb(R)^(n)) phi(x) thin d x #dots_space #footnote[evaluating the Fourier integral at $xi = 0$] \
  &= chevron.l phi, (2 pi)^(-n/2) chevron.r.
$
Hence we get the fundamental pair:
$
  cal(F) delta_(0) = (2 pi)^(-n/2),
  quad
  cal(F) 1 = (2 pi)^(n/2) delta_(0).
$ #(s.tag)("fourier-transform-of-dirac-and-one")

#paragraph_tab
Now let's return to the Laplace equation $Delta u = f$ with $f in cal(S)(bb(R)^(n))$. For $n >= 3$, our frequency candidate in #(s.ref)("result of Fourier-algebraic problem") was:
$
  U(xi) = -frac(hat(f)(xi), |xi|^(2)).
$
Is $U$ locally integrable near the origin? Let's check with polar coordinates:
$
  integral_(|xi| < 1) |xi|^(-2) thin d xi
  &= |S^(n-1)| integral_0^1 r^(-2) r^(n-1) thin d r #dots_space #footnote[converting to spherical polar coordinates] \
  &= |S^(n-1)| integral_0^1 r^(n-3) thin d r \
  &= frac(|S^(n-1)|, n-2) < infinity #dots_space #footnote[since $n-3 > -1$ when $n >= 3$].
$
At infinity, the rapid decay of $hat(f)$ easily controls the quotient. Thus $U$ defines a regular tempered distribution, even though it is not smooth at $xi = 0$.

#paragraph_tab
Multiplying by $-|xi|^(2)$ cancels the denominator in the distributional sense, giving $-|xi|^(2) U = hat(f)$. Setting $u = cal(F)^(-1) U$, by @fourier_multiplier_identity_on_tempered_distributions we compute:
$
  cal(F)(Delta u)
  &= -|xi|^(2) cal(F) u #dots_space #footnote[from @fourier_multiplier_identity_on_tempered_distributions for $Delta = -|D|^(2)$] \
  &= -|xi|^(2) U #dots_space #footnote[since $u = cal(F)^(-1) U$ and by @fourier_inversion_on_tempered_distributions] \
  &= hat(f) #dots_space #footnote[from #(s.ref)("result of Fourier-algebraic problem")].
$
Applying the Fourier inversion from @fourier_inversion_on_tempered_distributions gives:
$
  Delta u = f
$
as an exact equality in $cal(S)^(*)(bb(R)^(n))$. This completely finishes the argument that started from dividing by the full symbol in @fourier_algebraic_problem!

=== Fundamental solutions and convolution

#paragraph_tab
At first glance, our journey to solve constant-coefficient differential equations seems complete: for any given source $f in cal(S)(bb(R)^(n))$, we transform $P(D) u = f$ into the algebraic division problem $hat(u)(xi) = frac(hat(f)(xi), p(xi))$, resolve the singularities at the zero set $Z(p)$ in the distributional sense, and then recover $u = cal(F)^(-1) hat(u)$. #highlight()[However, let's think about what this method requires in practice.] Every single time someone gives us a new source function $f$, we must compute its Fourier transform $hat(f)$, analyze the division $frac(hat(f)(xi), p(xi))$ near the zero set $Z(p)$, and compute the inverse Fourier integral from scratch. #highlighted[In other words, the operator $P(D)$ and the external source $f$ are glued together throughout the entire calculation!]

#paragraph_tab
Can we separate the operator $P(D)$ from the source $f$ once and for all? Let's look at the frequency-space solution formula again:
$
  hat(u)(xi) = frac(1, p(xi)) dot hat(f)(xi).
$

Now remember our Fourier convolution theorem from @unitary_fourier_convolution_formulas: #highlight()[multiplication in frequency space corresponds to convolution in physical space!] Specifically,
$
  cal(F)^(-1) lr( hat(A) dot hat(B) ) = (2 pi)^(-n/2) (A * B).
$
This observation gives us a wonderful idea: suppose we can find a single universal distribution $Phi$ in physical space whose Fourier transform is exactly the reciprocal multiplier:
$
  hat(Phi)(xi) = frac((2 pi)^(-n/2), p(xi)).
$ #(s.tag)("formal_reciprocal_symbol_of_fundamental_solution")
If such a distribution $Phi$ exists, then for *any* source function $f$, we can immediately compute the physical solution $u$ by a single convolution:
$
  u = Phi * f.
$
We would never need to compute another Fourier transform or analyze frequency division separately for each source.#footnote[The singularity at $Z(p)$ is handled once in the construction of the fundamental solution.]

#definition(title: "Fundamental solution of linear constant-coefficient PDE")[
Let $P(D)$ be a constant-coefficient differential operator. A distribution $Phi in cal(D)^(*)(bb(R)^(n))$ satisfying
$
  P(D) Phi = delta_(0)
$
is called a *fundamental solution* of $P(D)$.
] <definition_of_fundamental_solution>

For the Laplacian $Delta = -sum_(j=1)^(n) D_(j)^(2)$, the symbol is $p(xi) = -|xi|^(2)$, so the formal Fourier transform of the fundamental solution from #(s.ref)("formal_reciprocal_symbol_of_fundamental_solution") becomes:
$
  hat(Phi)(xi) = -(2 pi)^(-n/2) |xi|^(-2).
$ #(s.tag)("fourier-transform-of-laplace-fundamental-solution")

#theorem(title: "Fundamental solution of the Laplacian")[
For $Delta = sum_(j=1)^(n) partial_(j)^(2)$, define
$
  Phi_(n)(x) := cases(
    frac(|x|, 2) & "if" n = 1,
    frac(1, 2 pi) log |x| & "if" n = 2,
    -frac(1, (n-2) |S^(n-1)|) |x|^(2-n) & "if" n >= 3,
  )
$
where $|S^(n-1)|$ denotes the $(n-1)$-dimensional surface area of the unit sphere $S^(n-1) = partial B_(1)(0) subset bb(R)^(n)$. Each function $Phi_(n)$ is locally integrable and has at most polynomial growth. Thus it induces the regular tempered distribution $T_(Phi_(n)) in cal(S)^(*)(bb(R)^(n))$ defined by
$
  chevron.l phi, T_(Phi_(n)) chevron.r
  := integral_(bb(R)^(n)) Phi_(n)(x) phi(x) thin d x,
  quad phi in cal(S)(bb(R)^(n)).
$
This induced distribution satisfies
$
  Delta T_(Phi_(n)) = delta_(0).
$
Hence $T_(Phi_(n))$ is a fundamental solution of the Laplacian.
] <fundamental_solution_of_laplacian>

#figure(
  fundamental-solution-laplace-diagram(),
  caption: [The radial potential profiles of the fundamental solution $Phi_(n)(x)$ across dimensions: $n=1$ ($(|x|)/2$, blue), $n=2$ ($frac(1, 2 pi) log |x|$, green), and $n=3$ ($-frac(1, 4 pi |x|)$, amber). Each profile is harmonic everywhere away from the origin $x=0$.],
)

#proof[
First, let's treat the 1D case $n = 1$. The classical derivative of $|x|$ is $-1$ for $x < 0$ and $+1$ for $x > 0$, so $|x|' = 2 H(x) - 1$. Taking the second derivative distributionally and using #(s.ref)("distributional-derivative-of-heaviside") gives:
$
  partial^(2) T_(Phi_(1))
  = partial T_(H - 1/2)
  = delta_(0) #dots_space #footnote[from #(s.ref)("distributional-derivative-of-heaviside")].
$

#figure(
  laplace-1d-proof-diagram(),
  caption: [The distributional derivation of the 1D fundamental solution: the continuous potential $Phi_(1)(x) = (|x|)/2$ (left), its first derivative $Phi'_(1)(x) = H(x) - 1/2$ with unit jump $+1$ at the origin (center), and its second derivative $partial^(2) T_(Phi_(1)) = delta_(0)$ concentrating unit impulse at $x = 0$ (right).],
)

#paragraph_tab
Now let's treat $n >= 3$. The function $Phi_(n)$ is locally integrable because in polar coordinates $r^(2-n) r^(n-1) = r$. A direct calculation gives $Delta Phi_(n)(x)=0$ for every $x eq.not 0$. Thus the only possible contribution to $Delta T_(Phi_(n))$ comes from the singular point $x=0$. To find that contribution, let's test $Delta T_(Phi_(n))$ against $phi in cal(D)(bb(R)^(n))$.

#paragraph_tab
Let's first recall how the boundary formula comes from Green's first identity. Let $Omega$ be a bounded smooth domain, let $a$ and $b$ be smooth functions on a neighborhood of its closure, and let $nu$ be its outward unit normal. Writing @Greens_first_identity_with_boundaries once with $a$ in front and once with $b$ in front gives
$
  integral_(Omega) a Delta b thin d x
  &= integral_(partial Omega) a partial_(nu) b thin d S
    - integral_(Omega) sum_(j=1)^(n) (partial_(j) a)(partial_(j) b) thin d x, \
  integral_(Omega) b Delta a thin d x
  &= integral_(partial Omega) b partial_(nu) a thin d S
    - integral_(Omega) sum_(j=1)^(n) (partial_(j) b)(partial_(j) a) thin d x.
    #dots_space #footnote[In @Greens_first_identity_with_boundaries, take $(u,v)=(a,dash(b))$ and then $(u,v)=(b,dash(a))$. The conjugation in the inner product then gives the ordinary products written here.]
$
The two gradient integrals are equal because each $(partial_(j) a)(partial_(j) b)$ is a product of scalars. Call their common value $G$. Subtracting the second formula from the first gives
$
  integral_(Omega) (a Delta b-b Delta a) thin d x
  &= integral_(partial Omega) a partial_(nu) b thin d S
    - cancel(G, stroke: #blue) \
  &quad - integral_(partial Omega) b partial_(nu) a thin d S
    + cancel(G, stroke: #blue) \
  &= integral_(partial Omega)
    (a partial_(nu) b-b partial_(nu) a) thin d S.
    #dots_space #footnote[The equal gradient integrals cancel. This is @Greens_second_identity_with_boundaries with ordinary products, with its signs reversed.]
$

#paragraph_tab
Now, can we set $a=Phi_(n)$ and $b=phi$ on a ball containing the origin? #highlighted[We cannot apply the smooth boundary formula there, because $Phi_(n)$ is singular at $0$.] Instead, we remove a small ball around $0$, apply the formula where both functions are smooth, and then let the radius of the removed ball tend to zero.

#paragraph_tab
Since $phi$ has compact support, choose $R>0$ so that $op("supp")(phi)$ lies strictly inside $B_(R)(0)$. For $0<epsilon<R$, put
$
  Omega_(epsilon,R)
  := {x in bb(R)^(n) : epsilon < |x| < R}.
$
Both functions are smooth on a neighborhood of the closure of this annulus. Its boundary has two parts:
$
  partial Omega_(epsilon,R)
  = partial B_(R)(0) union partial B_(epsilon)(0).
$
On the outer sphere, $phi$ is zero on a whole neighborhood, because its support lies strictly inside the larger ball. Thus its derivatives are zero there too. On the inner sphere, leaving the annulus means entering the removed ball. Its outward normal therefore points toward the origin, opposite to the radial direction $frac(x, |x|)$. For any smooth function $h$, we get
$
  nu(x) &= cases(
    frac(x, |x|) & "on" partial B_(R)(0),
    -frac(x, |x|) & "on" partial B_(epsilon)(0),
  ), \
  partial_(nu) h &= nabla h dot nu
  = cases(
    partial_(r) h & "on" partial B_(R)(0),
    -partial_(r) h & "on" partial B_(epsilon)(0).
  ) #dots_space #footnote[The radial derivative is $partial_(r) h=nabla h dot frac(x, |x|)$. The normal is outward from $Omega_(epsilon,R)$, not outward from the removed ball.]
$
The surface measure $d S$ stays positive on both spheres; the change of direction enters through $partial_(nu)$. Thus the outer boundary contributes zero, while the inner boundary keeps the contribution from the singularity as $epsilon$ tends to zero.

#figure(
  laplace-annulus-domain-diagram(),
  caption: [The annular regularization domain $Omega_(epsilon, R) = B_(R)(0) without B_(epsilon)(0)$ (left) with outer boundary $partial B_(R)(0)$ where $phi = 0$ and inner boundary $partial B_(epsilon)(0)$ where $nu = -partial_(r)$; and the boundary flux mechanism as $epsilon arrow.r 0$ (right) where the normal flux $-partial_(nu) Phi_(n) = 1/(|partial B_(epsilon)|)$ computes the spherical average of $phi$, isolating the unit impulse $phi(0) = chevron.l phi, delta_(0) chevron.r$.],
)


#block(breakable: false)[
#flowbox[
  First, move the Laplacian from the distribution to the test function:
  $
    chevron.l phi, Delta T_(Phi_(n)) chevron.r
    &= sum_(j=1)^(n) chevron.l phi, partial_(j)^(2) T_(Phi_(n)) chevron.r #dots_space #footnote[by $Delta=sum_(j=1)^(n) partial_(j)^(2)$] \
    &= sum_(j=1)^(n) (-1)^(2) chevron.l partial_(j)^(2) phi, T_(Phi_(n)) chevron.r #dots_space #footnote[from @definition_of_distributional_derivative] \
    &= chevron.l Delta phi, T_(Phi_(n)) chevron.r. #dots_space #footnote[the two derivative signs cancel]
  $

  $arrow.b$

  Since $Phi_(n)$ is locally integrable, @regular_distribution_induced_by_locally_integrable_function gives
  $
    chevron.l Delta phi, T_(Phi_(n)) chevron.r
    &= integral_(bb(R)^(n)) Phi_(n)(x) Delta phi(x) thin d x \
    &= lim_(epsilon arrow.r 0) integral_(Omega_(epsilon,R)) Phi_(n)(x) Delta phi(x) thin d x. #dots_space #footnote[the integral over $B_(epsilon)(0)$ tends to zero because $Phi_(n)$ is locally integrable and $Delta phi$ is bounded]
  $

  $arrow.b$

  Apply @Greens_second_identity_with_boundaries on $Omega_(epsilon,R)$ with $u:=Phi_(n)$ and $v:=dash(phi)$. Since $dash(v)=phi$, its left and right sides become
  $
    integral_(Omega_(epsilon,R)) lr((Delta Phi_(n)) phi-Phi_(n) Delta phi) thin d x
    = integral_(partial Omega_(epsilon,R)) lr((partial_(nu) Phi_(n)) phi-Phi_(n) partial_(nu) phi) thin d S.
  $
  Multiply by $-1$ and move the volume term to the right:
  $
    integral_(Omega_(epsilon,R)) Phi_(n) Delta phi thin d x
    &= integral_(partial Omega_(epsilon,R)) lr(Phi_(n) partial_(nu) phi-phi partial_(nu) Phi_(n)) thin d S \
    &quad + integral_(Omega_(epsilon,R)) (Delta Phi_(n)) phi thin d x. #dots_space #footnote[by @Greens_second_identity_with_boundaries]
  $

  $arrow.b$

  The outer boundary term is zero by the choice of $R$, and the volume term is zero because $Delta Phi_(n)=0$ on $Omega_(epsilon,R)$. Therefore,
  $
    chevron.l phi, Delta T_(Phi_(n)) chevron.r
    = lim_(epsilon arrow.r 0) integral_(partial B_(epsilon)(0)) lr(
      Phi_(n) partial_(nu) phi
      - phi partial_(nu) Phi_(n)
    ) thin d S.
  $
]
]

#paragraph_tab
Now let's compute the two boundary terms on $|x| = epsilon$.
First, the normal derivative on $|x| = epsilon$ is:
$
  partial_(nu) Phi_(n)
  &= - partial_(r) Phi_(n) #dots_space #footnote[since $nu = -frac(x, |x|)$ on the inner sphere $partial B_(epsilon)(0)$] \
  &= - partial_(r) lr( -frac(1, (n-2) |S^(n-1)|) r^(2-n) ) #dots_space #footnote[by the radial formula in @fundamental_solution_of_laplacian for $n >= 3$] \
  &= frac(2 - n, (n-2) |S^(n-1)|) epsilon^(1-n) \
  &= - frac(1, |S^(n-1)|) epsilon^(1-n). #dots_space #footnote[The formula for $Phi_(n)$ was chosen with precisely this normalization, so that the boundary flux yields the unit impulse in @fundamental_solution_of_laplacian.]
$ #(s.tag)("laplacian_fundamental_solution_normal_derivative")
Therefore, the second boundary integral becomes:
$
  - integral_(partial B_(epsilon)(0)) phi partial_(nu) Phi_(n) thin d S
  &= frac(1, |S^(n-1)| epsilon^(n-1)) integral_(partial B_(epsilon)(0)) phi(x) thin d S #dots_space #footnote[substituting #(s.ref)("laplacian_fundamental_solution_normal_derivative")] \
  &= frac(1, |partial B_(epsilon)(0)|) integral_(partial B_(epsilon)(0)) phi(x) thin d S #dots_space #footnote[since the sphere of radius $epsilon$ has surface area $|partial B_(epsilon)(0)| = |S^(n-1)| epsilon^(n-1)$] \
  &arrow.r phi(0) quad "as" epsilon arrow.r 0 #dots_space #footnote[since the spherical average of the continuous test function $phi$ converges to the center value $phi(0)$ as $epsilon arrow.r 0$].
$ #(s.tag)("second_boundary_integral_limit")

#paragraph_tab
For the first boundary term, since $|Phi_(n)| = O(epsilon^(2-n))$ and $|partial_(nu) phi| <= sup |nabla phi|$, the integral is bounded by:
$
  lr(|integral_(partial B_(epsilon)(0)) Phi_(n) partial_(nu) phi thin d S|)
  &<= lr(frac(1, (n-2) |S^(n-1)|) epsilon^(2-n)) lr(sup |nabla phi|) lr(|S^(n-1)| epsilon^(n-1)) \
  &= frac(1, n-2) lr(sup |nabla phi|) epsilon \
  &arrow.r 0 quad "as" epsilon arrow.r 0.
$ #(s.tag)("first_boundary_integral_limit")

Combining #(s.ref)("first_boundary_integral_limit") and #(s.ref)("second_boundary_integral_limit"), and using @definition_of_dirac_distribution, we arrive at:
$
  chevron.l phi, Delta T_(Phi_(n)) chevron.r
  = phi(0)
  = chevron.l phi, delta_(0) chevron.r.
$
For $n = 2$, the same calculation with $Phi_(2) = frac(1, 2 pi) log |x|$ gives the first term bounded by $O(epsilon |log epsilon|) arrow.r 0$ and the second term tending to $phi(0)$. Hence $Delta T_(Phi_(n)) = delta_(0)$ for all $n$.
]

#paragraph_tab
Now, how can we solve general equations $Delta u = f$? The fundamental solution gives the answer immediately via convolution! For any $f in cal(S)(bb(R)^(n))$, convolving the distribution $T_(Phi_(n))$ with $f$ gives the ordinary function
$
  u(x) := lr(T_(Phi_(n)) * f)(x)
  = (Phi_(n) * f)(x)
  := integral_(bb(R)^(n)) Phi_(n)(x - y) f(y) thin d y.
$ #(s.tag)("convolution_solution_definition")
Since differentiation commutes with convolution, by @unitary_fourier_convolution_formulas we compute:
$
  Delta u
  &= Delta lr(T_(Phi_(n)) * f) \
  &= lr(Delta T_(Phi_(n))) * f #dots_space #footnote[since distributional differentiation commutes with convolution] \
  &= delta_(0) * f #dots_space #footnote[by @fundamental_solution_of_laplacian] \
  &= f #dots_space #footnote[since the Dirac delta is the identity under convolution (@definition_of_dirac_distribution)].
$

Moreover, applying the Fourier transform to the convolution gives:
$
  hat(u)(xi)
  &= (2 pi)^(n/2) lr(cal(F) T_(Phi_(n)))(xi) hat(f)(xi) #dots_space #footnote[by the convolution theorem extended to tempered distributions] \
  &= - frac(hat(f)(xi), |xi|^(2)) #dots_space #footnote[substituting #(s.ref)("fourier-transform-of-laplace-fundamental-solution")],
$
which matches our frequency candidate in #(s.ref)("result of Fourier-algebraic problem") from @fourier_algebraic_problem perfectly!

#emphasis[
*Two Sides of the Same Coin:*
- *Frequency Space (Algebraic)*: $hat(u)(xi) = frac(hat(f)(xi), p(xi)) = (2 pi)^(n/2) hat(Phi)(xi) hat(f)(xi)$ (Division by symbol).
- *Physical Space (Geometric)*: $u(x) = (Phi * f)(x) = integral_(bb(R)^(n)) Phi(x - y) f(y) thin d y$ (Convolution with fundamental solution).

The Fourier transform beautifully bridges these two identical worlds!
]

#note(title: [What is $S^(n-1)$ and why does it appear here?])[
In simpler terms, $S^(n-1)$ denotes the unit sphere in $bb(R)^(n)$:
$
  S^(n-1) := lr({ x in bb(R)^(n) : |x| = 1 }) = partial B_(1)(0).
$
Why do we write the exponent as $n-1$ instead of $n$? Because the sphere living in $n$-dimensional Euclidean space $bb(R)^(n)$ is an $(n-1)$-dimensional surface (the boundary of the $n$-dimensional unit ball $B_(1)(0)$). The notation $|S^(n-1)|$ denotes the $(n-1)$-dimensional surface area of this unit sphere. The exact general formula for any dimension $n$ is:
$
  |S^(n-1)| = frac(2 pi^(n/2), Gamma(n/2)),
$
where $Gamma$ is the Euler Gamma function. Integrating over the entire sphere gives its total surface area:
$
  |partial B_(epsilon)(0)|
  = integral_(partial B_(epsilon)(0)) 1 thin d S
  = epsilon^(n-1) integral_(S^(n-1)) 1 thin d S(omega)
  = |S^(n-1)| epsilon^(n-1).
$

Hence, the integral in #(s.ref)("second_boundary_integral_limit") is *the exact spherical average* of $phi$ over $partial B_(epsilon)(0)$. Since the test function $phi$ is continuous, shrinking the sphere ($epsilon arrow.r 0$) forces this average to converge directly to the value at the center $phi(0)$. The total flux across the boundary is normalized to exactly $1$, producing $delta_(0)$!
]
]))
