#import "../Styles/styles.typ": *
#import "figures/figures.typ": radial-geometry-diagram, radial-bessel-routes-diagram, radial-angular-average-diagram, radial-antipodal-measure-diagram, radial-sphere-phase-diagram
#import "@preview/mannot:0.4.0": *

#local-tag-scope(s => [

== Radial distributions, polar coordinates, and Bessel functions

#paragraph_tab
The fundamental solution $Phi_(3)(x)=-1/(4pi|x|)$ and the heat kernel $p_(t)^((n))(x)=(4pi t)^(-n/2)e^(frac(-|x|^(2),4t))$ depend on distance from the origin, with no preferred direction. Let's use this symmetry to organize both differentiation and Fourier transformation. Polar coordinates separate distance from direction; integrating the directional part of a plane wave produces a Bessel function. The same function also solves the radial form of the Helmholtz equation.

#figure(
  radial-bessel-routes-diagram(),
  caption: [The two constructions meet because every unit-frequency plane wave solves the Helmholtz equation.],
)

=== Polar coordinates and the radial Laplacian

#definition(title: "Radial functions")[
Let $n>=2$. A function $F:bb(R)^(n) arrow.r bb(C)$ is *radial* if there is a function $f:[0,infinity) arrow.r bb(C)$ such that
$ F(x)=f(|x|). $
Equivalently, $F(Q x)=F(x)$ for every rotation $Q in op("SO")(n)$.
]

#paragraph_tab
Rotations preserve distance, so $F(Q x)=f(|Q x|)=f(|x|)$. Conversely, any two points of the same positive radius are related by a rotation; invariance therefore assigns a single value to each radius. The origin is fixed by every rotation. The function $F$ takes a vector $x$ as input, while $f$ takes its radius $r=|x|$ and gives the common value on that sphere.

#figure(
  radial-geometry-diagram(),
  caption: [Points on the same circle have the same value. The function $f(r)$ gives this common value at radius $r$; the area of a sphere in dimension $n$ grows as $r^(n-1)$.],
)

#paragraph_tab
For $x eq.not 0$, write $x=r omega$, where $r=|x|>0$ and $omega in S^(n-1)$. The Euclidean volume element becomes
$ d x=r^(n-1)thin d r thin d S(omega). $ #(s.tag)("polar-volume")
Here $d S$ is surface measure on the unit sphere. Scaling the sphere by $r$ multiplies its $(n-1)$-dimensional area by $r^(n-1)$; multiplying by the radial thickness $d r$ gives the shell volume. This factor must remain even when the function itself has no angular dependence.

#paragraph_tab
The same spherical geometry enters differentiation. We already derived the local coordinate formula for the Laplace--Beltrami operator in @Laplace-Beltrami_Operator. Applying it to the Euclidean metric in polar coordinates will explain both the radial first derivative and the angular scaling.

#lemma(title: "Euclidean Laplacian in polar coordinates")[
Let $n>=2$ and write $x=r omega$, with $r>0$ and $omega in S^(n-1)$. Under this change of coordinates, the Euclidean Laplacian on $C^(2)$ functions has the form
#local-scope-annotations(m => [
  #block(breakable: false, above: 2em, below: 2.2em)[
  $
    Delta=
    mark(partial_(r)^(2)+frac(n-1,r)partial_(r), tag: #(m.tag)("radial"))
    +mark(frac(1,r^(2))Delta_(S^(n-1)), tag: #(m.tag)("angular")).
    #annot((m.tag)("radial"), pos: top, dy: -0.6em, leader: true,
      annot-text-props: (size: 0.85em))[change with radius]
    #annot((m.tag)("angular"), pos: bottom, dy: 0.6em, leader: true,
      annot-text-props: (size: 0.85em))[change along the sphere]
  $ #(s.tag)("polar-laplacian")
  ]
], parent: s, name: "polar-operator")
Here $Delta_(S^(n-1))$ is the Laplace--Beltrami operator of the unit sphere with its induced round metric; it differentiates with respect to angular coordinates while $r$ is held fixed.
] #(s.tag)("polar-laplacian-lemma")

#proof[
We start from the Euclidean metric $g_("E")$, since the operator in the lemma is its Laplace--Beltrami operator. Our strategy is to express this metric in a polar coordinate chart using the radius and the unit sphere's metric, then substitute its determinant and inverse into the coordinate formula from @Laplace-Beltrami_Operator.

#paragraph_tab
Choose a sphere chart $phi:V arrow.r Omega subset bb(R)^(n-1)$ and write its inverse as $omega(theta)=phi^(-1)(theta)$, with $theta=(theta^(1),dots,theta^(n-1))$. On the open region $cal(U)={x in bb(R)^(n) without {0}:frac(x,|x|) in V}$, define the polar coordinate chart
$
  chi:cal(U) arrow.r (0,infinity) times Omega,
  quad chi(x)=lr((|x|,phi(frac(x,|x|)))).
$
It is a diffeomorphism, with smooth inverse
$
  chi^(-1)(r,theta)=r omega(theta).
$
#highlighted[The chart $chi$ assigns coordinates to a Euclidean point; $chi^(-1)$ reconstructs the point from its coordinates.] The differential $d(chi^(-1))$ therefore sends tangent vectors in the coordinate domain to Euclidean tangent vectors; its Jacobian is $J=D(chi^(-1))$.#footnote[For linearity and invertibility of the differential of a diffeomorphism, see #project-ref("smooth-manifolds", <source-proposition-3-6>).] By the pullback-metric definition in #project-ref("smooth-manifolds", <pullback-metric>), the coordinate expression of the Euclidean metric is $g:=(chi^(-1))^(*)g_("E")$.#footnote[Recall from #project-ref("smooth-manifolds", <riemannian-metric>) that a Riemannian metric takes two tangent vectors at the same point. The pullback applies $d(chi^(-1))_(q)$ to both inputs at a coordinate point $q$, then evaluates $g_("E")$ at $chi^(-1)(q)$.] Its components are
$
  g_(i j)&=g_("E")(d(chi^(-1))(partial_(i)),d(chi^(-1))(partial_(j))) \
  &=partial_(i)(chi^(-1)) dot partial_(j)(chi^(-1)),
  quad (g_(i j))=J^(upright(T))J.
$

#paragraph_tab
The unit sphere's induced metric has components $h_(a b)=partial_(a)omega dot partial_(b)omega$, where $partial_(a)=frac(partial,partial theta^(a))$ and angular indices $a,b$ run from $1$ to $n-1$. Since $|omega|^(2)=1$, differentiation gives $omega dot partial_(a)omega=0$. Differentiating the inverse chart in the radial and angular coordinate directions now gives
$
  partial_(r)(chi^(-1))=omega, quad partial_(a)(chi^(-1))=r partial_(a)omega.
$
Taking their Euclidean inner products gives $g_(r r)=1$, $g_(r a)=0$, and $g_(a b)=r^(2)h_(a b)$. Thus radial and angular directions are orthogonal, and the pullback of the Euclidean metric is
$
  g=(chi^(-1))^(*)g_("E")=d r ⊗ d r+r^(2)h,
  quad (g_(i j))=mat(1,0;0,r^(2)h).
$
There are $n-1$ angular directions. Taking the determinant and inverse therefore gives
$
  sqrt(op("det")g)=r^(n-1)sqrt(op("det")h),
  quad g^(r r)=1, quad g^(r a)=0, quad g^(a b)=r^(-2)h^(a b).
$
Here $(h^(a b))$ is the inverse of $(h_(a b))$. The determinant also recovers #(s.ref)("polar-volume"), since $d S=sqrt(op("det")h) thin d theta^(1) dots d theta^(n-1)$.

#paragraph_tab
For a Euclidean $C^(2)$ function $U$ on $cal(U)$, its coordinate representation is $u=U compose chi^(-1)$, so $u(r,theta)=U(r omega(theta))$. Recall the formula from @Laplace-Beltrami_Operator:
$
  Delta_(g)u=frac(1,sqrt(op("det")g))
    partial_(i)lr((sqrt(op("det")g)g^(i j)partial_(j)u)).
$
The indices $i,j$ range over all polar coordinates, and repeated indices are summed. Since $g=(chi^(-1))^(*)g_("E")$, the chart $chi$ is an isometry from the Euclidean region equipped with $g_("E")$ to the coordinate domain equipped with $g$, by #project-ref("smooth-manifolds", <riemannian-isometry>). The intrinsic definition $Delta=op("div")compose op("grad")$ from @definition_of_Laplacian therefore gives
$
  Delta_(g)u=(Delta U)compose chi^(-1).
$
Thus computing $Delta_(g)u$ gives the coordinate representation of the Euclidean Laplacian of $U$. Substituting the metric coefficients splits the formula into radial and angular parts:
$
  Delta_(g)u
  &=frac(1,r^(n-1)sqrt(op("det")h))
    partial_(r)lr((r^(n-1)sqrt(op("det")h)partial_(r)u)) \
  &quad+frac(1,r^(n-1)sqrt(op("det")h))
    partial_(a)lr((r^(n-1)sqrt(op("det")h)r^(-2)h^(a b)partial_(b)u)).
$
Since $h$ is independent of $r$, $sqrt(op("det")h)$ factors out of the radial derivative and cancels. Since $r$ is independent of the angular coordinates, the angular term retains only the factor $r^(-2)$. Thus
#context {
  let theme = theme-from-text-fill()
  let radial-color = theme.callouts.proposition.border
  let angular-color = theme.callouts.important.border
  local-scope-annotations(m => [
  #block(breakable: false, above: 2em, below: 2.3em)[
  $
    Delta_(g)u
    &=mark(frac(1,r^(n-1))partial_(r)lr((r^(n-1)partial_(r)u)),
      tag: #(m.tag)("radial-divergence"), color: #radial-color) \
    &quad+frac(1,r^(2))mark(frac(1,sqrt(op("det")h))
      partial_(a)lr((sqrt(op("det")h)h^(a b)partial_(b)u)),
      tag: #(m.tag)("sphere-laplacian"), color: #angular-color).
    #annot((m.tag)("radial-divergence"), pos: top, dy: -0.6em, leader: true,
      annot-text-props: (size: 0.85em))[radial divergence form]
    #annot((m.tag)("sphere-laplacian"), pos: bottom, dy: 0.6em, leader: true,
      annot-text-props: (size: 0.85em))[sphere Laplacian $Delta_(S^(n-1))u$]
  $
  ]
], parent: s, name: "polar-proof-splitting")
}
Applying the same Laplace--Beltrami formula to the metric $h$ identifies the marked angular expression as $Delta_(S^(n-1))u$. Expanding the radial derivative gives
$
  frac(1,r^(n-1))partial_(r)lr((r^(n-1)partial_(r)u))
  =partial_(r)^(2)u+frac(n-1,r)partial_(r)u,
$
which proves #(s.ref)("polar-laplacian"). Each sphere point lies in such a coordinate chart, so the identity holds throughout $bb(R)^(n) without {0}$. The restriction $r>0$ is essential because polar coordinates degenerate at the origin.
]

#paragraph_tab
For a radial function $F(x)=f(r)$ with $f in C^(2)((0,infinity))$, since $f(r)$ doesn't consider the angular variables, the angular term in #(s.ref)("polar-laplacian") vanishes. Therefore
$
  Delta F(x)=f''(r)+frac(n-1,r)f'(r)
  =frac(1,r^(n-1))frac(d,d r)lr((r^(n-1)f'(r))),
  quad r=|x|>0.
$ #(s.tag)("radial-laplacian")

=== Fourier transformation and Bessel functions

#paragraph_tab
Take a radial Schwartz function $F(x)=f(|x|)$, with the Schwartz space recalled from #project-ref("fourier-analysis", <multidimensional-schwartz>). Knowing $f(r)$ for every $r>=0$ determines $F$ at every point. #highlighted[Our goal is to compute its Fourier transform directly from $f$ by an integral over the radius alone.] Although $F$ is constant on each sphere, the Fourier phase varies with direction. We will first collect those directional contributions into a kernel, then use that kernel to compute the Fourier transform from $f(r)$. The radial Laplacian will let us identify the kernel and derive the radial Fourier formulas in #project-ref("fourier-analysis", <radial-fourier-bessel>). Our normalization is
$
  hat(F)(xi)=(2pi)^(-n/2)integral_(bb(R)^(n))F(x)e^(-i x dot xi) thin d x.
$ #(s.tag)("unitary-transform")
Write $cal(F)_("FA")$ for the transform in #project-ref("fourier-analysis", <multidimensional-fourier-definition>), whose exponential is $e^(-2pi i x dot xi)$. The conventions are related by
$
  hat(F)(xi)=(2pi)^(-n/2)(cal(F)_("FA")F)lr((frac(xi,2pi))).
$
Since $F$ is radial, $F compose Q=F$ for every rotation $Q$. The orthogonal-change-of-variables rule in #project-ref("fourier-analysis", <multidimensional-properties>) therefore gives $hat(F)(Q xi)=hat(F)(xi)$. #highlighted[Any two nonzero vectors of the same length are related by a rotation, so $hat(F)$ has the same value at every point of a sphere centered at the origin.] For example, in two dimensions,
$
  hat(F)(3,4)=hat(F)(5,0)=hat(F)(0,-5),
$
because all three frequency vectors have length $5$.

#paragraph_tab
To express the transform by an integral over the radius alone, let's first name its common value on each frequency sphere. In the frequency space $bb(R)^(n)$, use standard Cartesian coordinates and let $e_(1)=(1,0,dots,0)$ be the first basis vector. Since $hat(F)$ has the same value at every point of a frequency sphere, let's choose the representative $rho e_(1)$, #highlighted[which simplifies the dot product to $x dot.c (rho e_(1))=rho x_(1)$.] Denote this common value by $H(rho)$:
$
  H(rho):=hat(F)(rho e_(1)), quad rho>=0.
$
For $xi eq.not 0$, a rotation sends $xi$ to $|xi|e_(1)$; at $xi=0$, the same relation holds directly. Hence
$
  hat(F)(xi)=H(|xi|).
$
Here $rho:=|xi|$ names the radius in frequency space, just as $r:=|x|$ names the radius in physical space. Our task is now to compute $H(rho)$ from $f(r)$; once we know $H$, this identity recovers the full Fourier transform.

#paragraph_tab
Use #(s.ref)("polar-volume") in #(s.ref)("unitary-transform"). Fubini's theorem gives
#local-scope-annotations(m => [
  #block(breakable: false, above: 1.5em, below: 2.3em)[
  $
    hat(F)(xi)=(2pi)^(-n/2)integral_(0)^(infinity)
      f(r)r^(n-1)
      mark(lr((integral_(S^(n-1))e^(-i r omega dot xi) thin d S(omega))),
        tag: #(m.tag)("sphere")) thin d r.
    #annot((m.tag)("sphere"), pos: bottom, dy: 0.6em, leader: true,
      annot-text-props: (size: 0.85em))[integrate all directions at fixed radius]
  $
  ]
], parent: s, name: "angular-integration")
To compute $H(rho)$, evaluate this formula at $xi=rho e_(1)$. Then $omega dot xi=rho omega_(1)$, where $omega_(1)=omega dot e_(1)$ is the first component. The inner integral therefore depends only on the product $r rho$, so define
$
  psi_(n)(s):=integral_(S^(n-1))e^(-i s omega_(1)) thin d S(omega),
  quad s>=0.
$ #(s.tag)("angular-kernel")
Then we can treat $psi_n$ as a kernel. This angular kernel lets us compute $H(rho)$ directly from $f(r)$:
$
  H(rho)=(2pi)^(-n/2)integral_(0)^(infinity)
    f(r)psi_(n)(r rho)r^(n-1) thin d r.
$ #(s.tag)("radial-fourier-angular")
Thus we compute $H(rho)$ by weighting $f(r)$ with $psi_(n)(r rho)$ and integrating with the radial measure $r^(n-1)thin d r$. The same kernel works for every radial Schwartz function in dimension $n$; our remaining task is to identify it explicitly.

#paragraph_tab
Now, let's compute $psi_(n)$ starting from the case $n=2$. The sphere $S^(n-1)$ is now the unit circle. Parametrize it by
$
  omega(theta)=(cos theta,sin theta), quad 0<=theta<2pi.
$
Then $omega_(1)=cos theta$. Using this parametrization in #(s.ref)("angular-kernel") gives
#context {
  let theme = theme-from-text-fill()
  let euler-color = theme.callouts.proposition.border
  let cancellation-color = theme.callouts.important.border
  local-scope-annotations(m => [
    #block(breakable: false, above: 0.8em, below: 0.8em)[
    $
      psi_(2)(s)
      &=integral_(S^(1))e^(-i s omega_(1)) thin d S(omega) \
      &=integral_(0)^(2pi)e^(-i s cos theta) thin d theta
        #dots_space #footnote[Since $|omega'(theta)|=1$, the arc length element is $d S=|omega'(theta)|thin d theta=d theta$. In the Fourier integral, $s$ is replaced by $r rho$.] \
      &=mark(integral_(0)^(2pi)lr([cos(s cos theta)-i sin(s cos theta)]) thin d theta,
        tag: #(m.tag)("euler"), color: #euler-color) \
      &=integral_(0)^(2pi)cos(s cos theta) thin d theta
        -i mark(integral_(0)^(2pi)sin(s cos theta) thin d theta,
          tag: #(m.tag)("imaginary-integral"), color: #cancellation-color) \
      &=integral_(0)^(2pi)cos(s cos theta) thin d theta.
        #dots_space #footnote[Pair opposite directions $theta$ and $theta+pi$. Since $cos(theta+pi)=-cos theta$, we have $sin(s cos theta)+sin(s cos(theta+pi))=0$. Splitting the integral into $[0,pi]$ and $[pi,2pi]$ pairs every direction once, so the sine integral is zero.]
      #annot((m.tag)("euler"), pos: right, dx: 0.9em, leader: true,
        annot-text-props: (size: 0.8em))[Euler's formula]
      #annot((m.tag)("imaginary-integral"), pos: right, dx: 0.9em, leader: true,
        annot-text-props: (size: 0.8em))[$=0$]
    $
    ]
  ], parent: s, name: "circle-kernel-expansion")
}
We define $J_(0)(s)$ as the average over the unit circle:
$
  J_(0)(s):=frac(psi_(2)(s),2pi)
  =frac(1,2pi)integral_(0)^(2pi)cos(s cos theta) thin d theta.
  #dots_space #footnote[This agrees with #project-ref("fourier-analysis", <integer-bessel-definition>): substitute $alpha=theta-pi/2$ in its integral for $J_(0)$ and use $2pi$-periodicity.]
$ #(s.tag)("circle-average")
At $s=0$, the integrand is one, so $J_(0)(0)=1$. We will identify the corresponding kernel for every dimension.

#figure(
  radial-angular-average-diagram(),
  caption: [Left: the real contributions $cos(2 omega_(1))$ on the unit circle; dot size records magnitude, and color records sign. Right: normalized directional averages in dimensions two and three.],
)

#paragraph_tab
We found $psi_(2)(s)=2pi J_(0)(s)$. To construct general dimension version, we investigate properties of $psi_n$ as many as possible. First, let's use the rotational symmetry of the angular integral. Its phase is $omega dot (r xi)$, so introduce $y=r xi$ and define, for $y in bb(R)^(n)$:
$
  Psi_(n)(y):=integral_(S^(n-1))e^(-i y dot omega) thin d S(omega).
$ #(s.tag)("vector-angular-kernel")
Rotations preserve the sphere and its surface measure, so the same change-of-variables argument shows that $Psi_(n)$ is radial. Evaluating on the first coordinate axis recovers $psi_(n)$:
$
  Psi_(n)(y)=Psi_(n)(|y|e_(1))=psi_(n)(|y|).
$
Its radius variable is therefore $s=|y|$; in the original Fourier integral, we evaluate it at $y=r xi$, so $s=r rho$.

#paragraph_tab
Second, the smoothness of its integrand is easily showen. ; its $y$-derivatives multiply it by bounded components of $-i omega$. The integrand is smooth in $y$ Compactness of the sphere therefore permits differentiation under the integral, giving $Psi_(n) in C^(infinity)(bb(R)^(n))$. Since $Psi_(n)$ is smooth and radial, #(s.ref)("radial-laplacian") gives
$
  Delta_(y)Psi_(n)(y)=psi''_(n)(s)+frac(n-1,s)psi'_(n)(s),
  quad s=|y|>0.
$

#paragraph_tab
Let's compute the same Laplacian from the integral. With $omega$ fixed, each plane wave has frequency vector $omega$ of length one, so
$
  Delta_(y)e^(-i y dot omega)=-|omega|^(2)e^(-i y dot omega)
  =-e^(-i y dot omega).
$
Integrating this identity gives $Delta_(y)Psi_(n)=-Psi_(n)$, or $(Delta_(y)+1)Psi_(n)=0$. Comparing with the radial formula above and using $Psi_(n)(y)=psi_(n)(s)$ gives
$
  psi''_(n)(s)+frac(n-1,s)psi'_(n)(s)+psi_(n)(s)=0,
  quad s>0.
$ #(s.tag)("angular-helmholtz")
The rotational symmetry of the smooth angular integral has turned the Helmholtz equation into an ODE for $psi_(n)$.

#paragraph_tab
#highlight[The ODE we obtained in #(s.ref)("angular-helmholtz") already resembles Bessel's standard form]: it contains a second derivative, a first derivative divided by $s$, and the function itself. Bessel's canonical equation has coefficient $1/s$ in front of the first derivative. Let's rescale the unknown function to obtain that canonical equation, with the dimension encoded in its order.

#lemma(title: "From the radial ODE to Bessel's canonical equation")[
Let $n>=2$ be an integer and let $psi_(n) in C^(2)((0,infinity))$ satisfy #(s.ref)("angular-helmholtz"). Define
$
  nu:=frac(n,2)-1, quad v(s):=s^(nu)psi_(n)(s).
$ #(s.tag)("bessel-order-definition")
Then $v in C^(2)((0,infinity))$ satisfies *Bessel's equation of order $nu$*:
$
  v''+frac(1,s)v'+lr((1-frac(nu^(2),s^(2))))v=0,
  quad s>0.
$ #(s.tag)("bessel-ode")
] #(s.tag)("radial-to-bessel-lemma")

#proof[
To determine the rescaling, first allow an arbitrary real exponent $a$ and write $psi_(n)(s)=s^(-a)v(s)$. The product rule gives
$
  psi'_(n)&=s^(-a)lr((v'-frac(a,s)v)), \
  psi''_(n)&=s^(-a)lr((v''-frac(2a,s)v'+frac(a(a+1),s^(2))v)).
$
Substitute these derivatives into #(s.ref)("angular-helmholtz") and divide by the nonzero factor $s^(-a)$. Collecting the coefficients of $v'$, $v$, and $v/s^(2)$ gives
$
  v''+frac(n-1-2a,s)v'
    +lr((1+frac(a(a-n+2),s^(2))))v=0.
$
To match the first derivative term of Bessel's canonical equation, choose
$
  n-1-2a=1 quad arrow.l.r quad a=frac(n,2)-1=nu.
$
Then $n-2=2nu$, so the remaining coefficient becomes $a(a-n+2)=nu(nu-2nu)=-nu^(2)$. The transformed equation is therefore exactly #(s.ref)("bessel-ode"). Since $s^(nu)$ is smooth and nonzero for $s>0$, $v=s^(nu)psi_(n)$ is $C^(2)$ and the substitution is reversible.
]

#paragraph_tab
To find the solution associated with our angular integral, let's first determine its form from #(s.ref)("angular-kernel"). Expand the exponential in its Taylor series:
$
  e^(-i s omega_(1))=sum_(k=0)^(infinity)
    frac((-i s omega_(1))^(k),k!).
$
For any $R>0$ and $|s|<=R$, the absolute value of the $k$th term is bounded by $R^(k)/k!$, since $|omega_(1)|<=1$. The sum of these bounds is $e^(R)<infinity$, so the series converges uniformly on the sphere for $s$ in any bounded interval. We can therefore integrate term by term and factor the powers of $s$ out of the integrals.
$
  psi_(n)(s)
  &=integral_(S^(n-1))e^(-i s omega_(1)) thin d S(omega) \
  &=integral_(S^(n-1))sum_(k=0)^(infinity)
    frac((-i s omega_(1))^(k),k!) thin d S(omega) \
  &=sum_(k=0)^(infinity)frac((-i)^(k),k!)
    lr((integral_(S^(n-1))omega_(1)^(k) thin d S(omega)))s^(k).
$

#paragraph_tab
Now let's check which coefficients vanish. The map $omega mapsto -omega$ is a bijection of the sphere and sends each surface patch to a congruent patch on the opposite side. Thus it permutes all integration points while preserving their surface measure. #(s.ref)("antipodal-measure-figure") illustrates this on $S^(2)$.

#figure(
  radial-antipodal-measure-diagram(),
  caption: [Antipodal reparametrization on $S^(2)$, shown transparently. Matching colors track congruent surface patches; every direction is counted once with the same surface measure.],
) #(s.tag)("antipodal-measure-figure")
The same change of variables applies on $S^(n-1)$. Applied to the scalar integrand $omega_(1)^(k)$, it gives
$
  integral_(S^(n-1))omega_(1)^(k) thin d S(omega)
  &=integral_(S^(n-1))(-omega_(1))^(k) thin d S(omega) \
  &=(-1)^(k)integral_(S^(n-1))omega_(1)^(k) thin d S(omega).
$
For odd $k$, $(-1)^(k)=-1$, so this integral equals its own negative and must be zero.#footnote[Writing $I_(k):=integral_(S^(n-1))omega_(1)^(k) thin d S(omega)$, the preceding identity gives $I_(k)=(-1)^(k)I_(k)$. For odd $k$, this becomes $I_(k)=-I_(k) arrow.r 2I_(k)=0 arrow.r I_(k)=0$.] Only the even indices $k=2j$ remain. Using $(-i)^(2j)=((-i)^(2))^(j)=(-1)^(j)$ gives
$
  psi_(n)(s)
  &=sum_(j=0)^(infinity)frac((-i)^(2j),(2j)!)
    lr((integral_(S^(n-1))omega_(1)^(2j) thin d S(omega)))s^(2j) \
  &=sum_(j=0)^(infinity)frac((-1)^(j),(2j)!)
    lr((integral_(S^(n-1))omega_(1)^(2j) thin d S(omega)))s^(2j).
$

#block(sticky: true)[

#paragraph_tab
Every factor multiplying $s^(2j)$ is independent of $s$. Let's name that coefficient explicitly:
]
$
  c_(j):=frac((-1)^(j),(2j)!)
    integral_(S^(n-1))omega_(1)^(2j) thin d S(omega),
  quad j=0,1,2,dots.
$ #(s.tag)("angular-kernel-coefficients")
With these coefficients, #(s.ref)("radial-to-bessel-lemma") gives the series for both $psi_(n)$ and $v$.#footnote[For noninteger $nu$, the analytic even function is $s^(-nu)v=psi_(n)$; $v$ itself contains the noninteger power $s^(nu)$.]
$
  psi_(n)(s)&=sum_(j=0)^(infinity)c_(j)s^(2j), \
  v(s)=s^(nu)psi_(n)(s)&=s^(nu)sum_(j=0)^(infinity)c_(j)s^(2j).
$ #(s.tag)("angular-kernel-series")
For example, the first two coefficients are
$
  c_(0)&=integral_(S^(n-1))1 thin d S(omega)=|S^(n-1)|, \
  c_(1)&=-frac(1,2)integral_(S^(n-1))omega_(1)^(2) thin d S(omega).
$

#paragraph_tab
The coefficients $c_(j)$ in #(s.ref)("angular-kernel-coefficients") already describe our angular integral, and $c_(0)=psi_(n)(0)=|S^(n-1)|$ fixes its scale. #highlighted[Our goal is to express the kernel in #(s.ref)("radial-fourier-angular") using the standard Bessel function $J_(nu)$.] We therefore need to connect the solution $v$ in #(s.ref)("angular-kernel-series") to that standard function and determine the factor that matches the scale of our angular integral. To apply the standard normalization for $J_(nu)$, introduce coefficients $a_(j)$ for a solution $u$ of #(s.ref)("bessel-ode") in the same series form as $v$ (#(s.ref)("angular-kernel-series")), leaving $a_(0)$ free. For #box($nu=n/2-1>=0$), write
$
  u(s)=s^(nu)sum_(j=0)^(infinity)a_(j)s^(2j)
    =a_(0)s^(nu)+a_(1)s^(nu+2)+a_(2)s^(nu+4)+dots.
$ #(s.tag)("bessel-solution-series")

#context {
  let theme = theme-from-text-fill()
  figure(
    text(size: 9pt)[
      #set math.equation(numbering: none)
      #set par(justify: false)
      #table(
        columns: (0.65fr, 1.5fr, 1.5fr),
        align: left + top,
        inset: 6pt,
        stroke: 0.5pt + theme.rule,
        table.header(
          table.cell(align: center + horizon, fill: theme.callouts.note.bg)[*Aspect*],
          table.cell(align: center + horizon, fill: theme.callouts.proposition.bg)[
            #text(fill: theme.callouts.proposition.border)[*$c_(j)$: angular integral*]
          ],
          table.cell(align: center + horizon, fill: theme.callouts.important.bg)[
            #text(fill: theme.callouts.important.border)[*$a_(j)$: Bessel solution*]
          ],
        ),
        [*Series*],
        [
          $ psi_(n)(s)=sum_(j>=0)c_(j)s^(2j) $
          Thus $v(s)=s^(nu)psi_(n)(s)$ has coefficients $c_(j)$ in the same form as $u$.
        ],
        [
          $ u(s)=s^(nu)sum_(j>=0)a_(j)s^(2j) $
          The standard normalization below gives $u=J_(nu)$.
        ],
        [*First coefficient*],
        [
          $ c_(0)=|S^(n-1)| $
          Fixed by the original sphere integral.
        ],
        [
          Initially $a_(0)$ is free. The standard choice is
          $ a_(0)=frac(1,2^(nu)Gamma(nu+1)). $
        ],
        [*Coefficient rule*],
        [
          Each $c_(j)$ is already fixed by the integral in #(s.ref)("angular-kernel-coefficients").
        ],
        [
          The Bessel equation determines every $a_(j)$ from the chosen $a_(0)$.
        ],
        [*Use in the next steps*],
        [
          We will compare their recurrence with that of $a_(j)$ and use $c_(0)$ to match the scale of $psi_(n)$.
        ],
        [
          We will derive $J_(nu)$ and the limit of $s^(-nu)J_(nu)(s)$ at zero, then compare that limit with $c_(0)$ to find the proportionality factor.
        ],
      )
    ],
    kind: table,
    caption: [Roles of the coefficients $c_(j)$ and $a_(j)$.],
  )
} #(s.tag)("bessel-coefficient-roles-table")

#paragraph_tab
Multiplying #(s.ref)("bessel-ode") by $s^(2)$ and comparing coefficients gives, for $j>=1$,
$
  lr([(2j+nu)^(2)-nu^(2)])a_(j)+a_(j-1)=0,
  quad a_(j)=-frac(a_(j-1),4j(j+nu)).
$ #(s.tag)("bessel-coefficient-recurrence")
Since $nu>=0$, every denominator $4j(j+nu)$ is positive. The first two steps are
$
  a_(1)&=-frac(a_(0),4(nu+1)), \
  a_(2)&=-frac(a_(1),8(nu+2))
    =frac(a_(0),4^(2) 2! (nu+1)(nu+2)).
$
#highlighted[Thus $a_(0)$ determines $a_(1)$, then $a_(2)$, and every subsequent coefficient.] At $j=0$, however, coefficient comparison (as in #(s.ref)("bessel-coefficient-recurrence")) gives only
$
  (nu^(2)-nu^(2))a_(0)=0,
$
which leaves $a_(0)$ free. This agrees with the scaling freedom of a linear homogeneous equation: multiplying a solution by a constant gives another solution.

#block(sticky: true)[

#paragraph_tab
Let's make this dependence on $a_(0)$ explicit. Iterating the recurrence gives
]
$
  a_(j)=frac((-1)^(j)a_(0),
    4^(j)j!(nu+1)(nu+2) dots (nu+j)).
$
The empty product at $j=0$ is $1$, so this formula includes the leading coefficient. #highlighted[Repeated use of the Gamma recurrence] gives
$
  Gamma(j+nu+1)
  =(nu+j) dots (nu+1)Gamma(nu+1).
$
Therefore the same coefficients can be written as
$
  a_(j)=frac((-1)^(j)a_(0)Gamma(nu+1),
    4^(j)j! Gamma(j+nu+1)).
$ #(s.tag)("bessel-general-coefficients")
Every coefficient is proportional to $a_(0)$; the recurrence fixes their ratios while leaving the overall scale free.

#block(sticky: true)[

#paragraph_tab
#highlighted[We now identify this family of solutions with the already established standard Bessel function.] Its conventional normalization chooses
]
$
  a_(0)=frac(1,2^(nu)Gamma(nu+1)).
$
The recurrence (#(s.ref)("bessel-coefficient-recurrence")), derived from the Bessel equation (#(s.ref)("bessel-ode")), makes every $a_(j)$ proportional to a freely chosen $a_(0)$: changing $a_(0)$ only scales $u$. Substituting the standard choice above into the general coefficient formula (#(s.ref)("bessel-general-coefficients")) gives
$
  a_(j)&=frac((-1)^(j),
    2^(nu)4^(j)j! Gamma(j+nu+1)) \
  &=frac((-1)^(j),
    2^(2j+nu)j! Gamma(j+nu+1)).
$
With this normalization, denote the resulting $u$ by $J_(nu)$. Substituting these coefficients into the series for $u$ (#(s.ref)("bessel-solution-series")) gives the standard series for the Bessel function of the first kind:
$
  J_(nu)(s):=sum_(j=0)^(infinity)
    frac((-1)^(j),j! Gamma(j+nu+1))lr((frac(s,2)))^(2j+nu).
$ #(s.tag)("bessel-series")

#block(breakable: false)[
#paragraph_tab
We now return to our angular integral $psi_(n)$, whose scale is fixed by $psi_(n)(0)=c_(0)=|S^(n-1)|$. #highlighted[To match this scale with that of $s^(-nu)J_(nu)(s)$, let's first compute its limit as $s arrow.r 0^+$.] We can obtain it from the first three terms of #(s.ref)("bessel-series"):
$
  J_(nu)(s)
  =frac((s/2)^(nu),Gamma(nu+1))
    -frac((s/2)^(nu+2),Gamma(nu+2))
    +frac((s/2)^(nu+4),2 Gamma(nu+3))-dots.
$
Now factor out the first term. Using $Gamma(nu+2)=(nu+1)Gamma(nu+1)$ and $Gamma(nu+3)=(nu+2)(nu+1)Gamma(nu+1)$ gives
$
  J_(nu)(s)
  =frac((s/2)^(nu),Gamma(nu+1))
    lr([1-frac(s^(2),4(nu+1))
      +frac(s^(4),32(nu+1)(nu+2))-dots]).
$
The convergent power series in brackets begins with $1$, and its remaining terms start at $s^(2)$. Thus the bracket is $1+O(s^(2))$, so
$
  J_(nu)(s)=frac((s/2)^(nu),Gamma(nu+1))lr((1+O(s^(2)))),
  quad s arrow.r 0^+.
$ #(s.tag)("bessel-origin")
Here $nu$ is fixed, and $s$ approaches zero through positive values.
]

#block(breakable: false)[

#paragraph_tab
To compare $psi_(n)$ with $s^(-nu)J_(nu)$, substitute the power series (#(s.ref)("angular-kernel-series")) into the differential equation (#(s.ref)("angular-helmholtz")). For $s>0$,
#context {
  let theme = theme-from-text-fill()
  let derivative-color = theme.callouts.proposition.border
  let index-color = theme.callouts.important.border
  local-scope-annotations(m => [
    $
      0&=psi''_(n)(s)+rmark(frac(n-1,s))psi'_(n)(s)+psi_(n)(s) \
      &=sum_(j=1)^(infinity)
        mark(lr([2j(2j-1)+2j(n-1)]),
          tag: #(m.tag)("derivatives"), color: #derivative-color)c_(j)s^(2j-2)
        +sum_(j=0)^(infinity)c_(j)s^(2j)
        #dots_space #footnote[Termwise differentiation gives $(s^(2j))'=2j s^(2j-1)$ and $(s^(2j))''=2j(2j-1)s^(2j-2)$. Multiplying the first derivative by $(n-1)/s$ contributes $2j(n-1)s^(2j-2)$. The constant term vanishes in both derivatives.] \
      &=sum_(j=1)^(infinity)2j(2j+n-2)c_(j)s^(2j-2)
        +mark(sum_(j=1)^(infinity)c_(j-1)s^(2j-2),
          tag: #(m.tag)("reindex"), color: #index-color)
        \
      &=sum_(j=1)^(infinity)
        lr([2j(2j+n-2)c_(j)+c_(j-1)])s^(2j-2).
      #annot((m.tag)("derivatives"), pos: top, dy: -0.3em, leader: true,
        annot-text-props: (size: 0.75em))[differentiate]
      #annot((m.tag)("reindex"), pos: right, dx: 0.6em, leader: true,
        annot-text-props: (size: 0.75em))[reindex]
    $ #(s.tag)("angular-kernel-substitution")
  ], parent: s, name: "angular-series-substitution")
}
#highlight[This convergent power series is identically zero, so each coefficient must vanish.] Hence
$
  2j(2j+n-2)c_(j)+c_(j-1)&=0, \
  2j(2j+n-2)c_(j)&=-c_(j-1), quad j>=1.
$ #(s.tag)("angular-kernel-coefficient-recurrence")
]

#block(sticky: true)[

#paragraph_tab
Since $n-2=2nu$ by the definition of $nu$ (#(s.ref)("bessel-order-definition")), the recurrences #(s.ref)("angular-kernel-coefficient-recurrence") and #(s.ref)("bessel-coefficient-recurrence") agree. With the standard normalization $a_(0)>0$, set $C:=c_(0)/a_(0)$. Starting with $c_(0)=C a_(0)$, induction using the common recurrence gives
]
$
  c_(j)=C a_(j), quad j=0,1,2,dots.
$ #(s.tag)("angular-bessel-coefficient-proportionality")
The constant $C$ is independent of $s$. Both series in #(s.ref)("angular-kernel-series") and #(s.ref)("bessel-series") converge for every $s>0$, so summing the coefficient identity gives
$
  psi_(n)(s)
  &=sum_(j=0)^(infinity)c_(j)s^(2j) \
  &=C sum_(j=0)^(infinity)a_(j)s^(2j)
    =C s^(-nu)J_(nu)(s), quad s>0.
$ #(s.tag)("angular-bessel-proportionality")
Thus #(s.ref)("angular-bessel-proportionality") already holds for every $s>0$.

#paragraph_tab
We now determine $C$ by taking $s arrow.r 0^+$ in #(s.ref)("angular-bessel-proportionality").#footnote[For fixed $nu>=0$, #(s.ref)("bessel-general-coefficients") defines all $a_(j)$ from any finite $a_(0)$, and $sum_(j>=0)a_(j)s^(2j)$ converges for every $s$, independently of that choice. Thus $a_(0)$ only scales the whole function. Since $c_(j)$ follows the same recurrence, matching the leading coefficients at zero determines that scale for all $s>0$.] Continuity of $psi_(n)$ at zero and the Bessel limit from #(s.ref)("bessel-origin") give
$
  |S^(n-1)|=psi_(n)(0)
  &=lim_(s arrow.r 0^+)psi_(n)(s) \
  &=C lim_(s arrow.r 0^+)s^(-nu)J_(nu)(s)
    =frac(C,2^(nu)Gamma(nu+1)).
$
Using $|S^(n-1)|=2pi^(n/2)/Gamma(n/2)$ and $nu+1=n/2$, we find
$
  C=frac(2pi^(n/2),Gamma(n/2))2^(nu)Gamma(nu+1)
    =(2pi)^(n/2).
$
Substituting this value of $C$ into #(s.ref)("angular-bessel-proportionality") gives
$
  psi_(n)(s)=(2pi)^(n/2)s^(1-n/2)J_(n/2-1)(s),
  quad s>0,
$ #(s.tag)("sphere-bessel")
with the value at zero supplied by continuity. This identifies the Bessel function in the directional integral and explains both its order and its normalization.

#proposition(title: "Fourier transform of a radial Schwartz function")[
Let $n>=2$, $F in cal(S)(bb(R)^(n))$, and $F(x)=f(|x|)$. For $rho=|xi|>0$,
$
  hat(F)(xi)=H(rho)=rho^(1-n/2)integral_(0)^(infinity)
    f(r)J_(n/2-1)(r rho)r^(n/2) thin d r.
$ #(s.tag)("radial-fourier-bessel")
At zero frequency, $xi=0$ and hence $rho=0$. The transform is
$
  H(0)=hat(F)(0)=(2pi)^(-n/2)|S^(n-1)|
    integral_(0)^(infinity)f(r)r^(n-1) thin d r.
$ #(s.tag)("radial-fourier-zero")
] #(s.tag)("radial-fourier-bessel-proposition")

#proof[
Insert #(s.ref)("sphere-bessel") into #(s.ref)("radial-fourier-angular"). The normalization factors cancel, and $r^(n-1)(r rho)^(1-n/2)=rho^(1-n/2)r^(n/2)$. For $rho>0$, the calculation is
#context {
  let theme = theme-from-text-fill()
  let normalization-color = theme.callouts.proposition.border
  let weight-color = theme.callouts.important.border
  local-scope-annotations(m => [
    #block(breakable: false, above: 0.8em, below: 1em)[
    $
      H(rho)
      &=(2pi)^(-n/2)integral_(0)^(infinity)
        f(r)psi_(n)(r rho)r^(n-1) thin d r \
      &=mark((2pi)^(-n/2)(2pi)^(n/2),
          tag: #(m.tag)("normalization"), color: #normalization-color)
        integral_(0)^(infinity)f(r)J_(n/2-1)(r rho)
        mark((r rho)^(1-n/2)r^(n-1),
          tag: #(m.tag)("radial-weight"), color: #weight-color) thin d r
        #dots_space #footnote[Use #(s.ref)("sphere-bessel") with $s=r rho$. For $rho>0$ this applies whenever $r>0$; the endpoint $r=0$ is supplied by continuity.] \
      &=rho^(1-n/2)integral_(0)^(infinity)
        f(r)J_(n/2-1)(r rho)r^(n/2) thin d r.
        #dots_space #footnote[For $r,rho>0$, $(r rho)^(1-n/2)r^(n-1)=rho^(1-n/2)r^(1-n/2+n-1)=rho^(1-n/2)r^(n/2)$. The factor $rho^(1-n/2)$ is independent of $r$ and can be taken outside the integral.]
      #annot((m.tag)("normalization"), pos: top, dy: -0.3em, leader: true,
        annot-text-props: (size: 0.75em))[$=1$]
      #annot((m.tag)("radial-weight"), pos: bottom, dy: 0.3em, leader: true,
        annot-text-props: (size: 0.75em))[$=rho^(1-n/2)r^(n/2)$]
    $ #(s.tag)("radial-fourier-bessel-proof")
    ]
  ], parent: s, name: "radial-fourier-positive-proof")
}

#block(breakable: false)[

#paragraph_tab
The zero-frequency formula in #(s.ref)("radial-fourier-zero") follows from #(s.ref)("unitary-transform") and #(s.ref)("polar-volume"): at $xi=0$, the exponential $e^(-i x dot xi)$ equals $1$, and integrating over the unit sphere gives $|S^(n-1)|$. Explicitly,
#context {
  let theme = theme-from-text-fill()
  let phase-color = theme.callouts.important.border
  let sphere-color = theme.callouts.proposition.border
  local-scope-annotations(m => [
    #block(breakable: false, above: 1.2em, below: 0.8em)[
    $
      H(0)&=hat(F)(0)=(2pi)^(-n/2)integral_(bb(R)^(n))
        f(|x|)mark(e^(-i x dot 0),
          tag: #(m.tag)("zero-phase"), color: #phase-color) thin d x \
      &=(2pi)^(-n/2)integral_(0)^(infinity)integral_(S^(n-1))
        f(r)r^(n-1) thin d S(omega) thin d r
        #dots_space #footnote[Set $x=r omega$ and use $d x=r^(n-1)thin d r thin d S(omega)$ from #(s.ref)("polar-volume"). Since $F$ is Schwartz, $integral_(bb(R)^(n))|F(x)|thin d x<infinity$, so Fubini's theorem applies.] \
      &=(2pi)^(-n/2)integral_(0)^(infinity)f(r)r^(n-1)
        mark(lr((integral_(S^(n-1))1 thin d S(omega))),
          tag: #(m.tag)("sphere-area"), color: #sphere-color) thin d r \
      &=(2pi)^(-n/2)|S^(n-1)|integral_(0)^(infinity)
        f(r)r^(n-1) thin d r.
      #annot((m.tag)("zero-phase"), pos: top, dy: -0.3em, leader: true,
        annot-text-props: (size: 0.75em))[$=1$]
      #annot((m.tag)("sphere-area"), pos: top, dy: -0.3em, leader: true,
        annot-text-props: (size: 0.75em))[$=|S^(n-1)|$]
    $ #(s.tag)("radial-fourier-zero-proof")
    ]
  ], parent: s, name: "radial-fourier-zero-proof")
}
]
]

=== Hankel transforms and radial distributions

#block(sticky: true)[

#paragraph_tab
#(s.ref)("radial-fourier-bessel-proposition") reduces the Euclidean Fourier transform of a radial Schwartz function to an integral over the radius. With $nu=n/2-1$, write $r^(n/2)=r^(nu)r$ and set $h(r)=r^(nu)f(r)$ in #(s.ref)("radial-fourier-bessel"). #highlighted()[The remaining integral has kernel $J_(nu)(r rho)$ and measure $r thin d r$.] Let's define this integral operator as the Hankel transform, so that we can express the proposition using the transform of $h(r)=r^(nu)f(r)$.
]

#definition(title: "Hankel transform")[
Let $nu>=0$ and let $h:(0,infinity) arrow.r bb(C)$ be measurable with $integral_(0)^(infinity)|h(r)|r thin d r<infinity$. The *Hankel transform of order $nu$* is defined by
$
  (cal(H)_(nu)h)(rho)
  :=integral_(0)^(infinity)h(r)J_(nu)(r rho)r thin d r,
  quad rho>=0.
$ #(s.tag)("hankel-transform")
] #(s.tag)("hankel-transform-definition")

Returning to #(s.ref)("radial-fourier-bessel-proposition"), take $nu=n/2-1$ and $h(r)=r^(nu)f(r)$. Since $f$ is bounded near zero and rapidly decreasing at infinity, $h$ satisfies the integrability condition in #(s.ref)("hankel-transform-definition"). We can therefore write #(s.ref)("radial-fourier-bessel") as
$
  H(rho)=rho^(-nu)(cal(H)_(nu)h)(rho),
  quad rho>0.
$ #(s.tag)("radial-fourier-hankel")
The dimension enters this relation through the Bessel order $nu=n/2-1$, the input weight $r^(nu)$, and the output factor $rho^(-nu)$. The two weights come from combining the angular kernel with the Euclidean radial volume element. Let's examine the two- and three-dimensional cases to see how these three ingredients work together.

#paragraph_tab
Let's first specialize #(s.ref)("radial-fourier-hankel") to two dimensions. For $n=2$, the Bessel order and the input and output weights are
$
  nu=frac(2,2)-1=0,
  quad h(r)=r^(0)f(r)=f(r),
  quad rho^(-nu)=rho^(0)=1.
$ #(s.tag)("hankel-two-dimensional-weights")
Thus the radial Fourier transform is exactly the order-zero Hankel transform of the function $f(r)$:
$
  H(rho)
  &=rho^(0)(cal(H)_(0)f)(rho) \
  &=integral_(0)^(infinity)f(r)J_(0)(r rho)r thin d r
    =(cal(H)_(0)f)(rho), quad rho>0. #dots_space #footnote[The measure $r thin d r$ is still present.]
$ #(s.tag)("hankel-two-dimensional-transform")
In #(s.ref)("sphere-bessel"), $n=2$ gives $psi_(2)(s)=2pi J_(0)(s)$, so the angular factor $2pi$ cancels the Fourier normalization $(2pi)^(-1)$. This recovers #project-ref("fourier-analysis", <radial-fourier-two-dimensional>) after the normalization change above. Since $J_(0)(0)=1$, the same integral gives $H(0)=integral_(0)^(infinity)f(r)r thin d r$.

#block(sticky: true)[

#paragraph_tab
Let's next make the three-dimensional case of #(s.ref)("radial-fourier-hankel") concrete. Here $nu=1/2$ and the weighted input is $h(r)=r^(1/2)f(r)$. #highlighted[We can evaluate the sphere integral $psi_(3)$ directly and use its relation with $J_(1/2)$ in #(s.ref)("sphere-bessel") to express the kernel through elementary functions.] Substituting this kernel will then show how the full radial Fourier integral simplifies. Choose the polar axis along $e_(1)$; then $omega_(1)=cos theta$ and $d S=sin theta thin d theta thin d phi$ on $S^(2)$. Integrating over the azimuthal angle and then setting $u=cos theta$ gives, for $s>0$,
]
$
  psi_(3)(s)
  &=integral_(0)^(2pi)integral_(0)^(pi)
    e^(-i s cos theta)sin theta thin d theta thin d phi \
  &=2pi integral_(-1)^(1)e^(-i s u) thin d u \
  &=2pi frac(e^(-i s)-e^(i s),-i s)
    =4pi frac(sin s,s).
$ #(s.tag)("sphere-three-dimensional-integral")
This is the sphere integral evaluated in #project-ref("fourier-analysis", <sphere-multiplier>). On the other hand, #(s.ref)("sphere-bessel") gives $psi_(3)(s)=(2pi)^(3/2)s^(-1/2)J_(1/2)(s)$. Solving for $J_(1/2)$ therefore yields
$
  J_(1/2)(s)
  &=frac(s^(1/2),(2pi)^(3/2))psi_(3)(s) \
  &=frac(4pi,(2pi)^(3/2))frac(sin s,s^(1/2))
    =sqrt(frac(2,pi s))sin s.
$ #(s.tag)("bessel-half-order-sine")

#paragraph_tab
Now that we have an elementary expression for the kernel, let's return to $H(rho)$ in #(s.ref)("radial-fourier-bessel") and combine it with the input and output weights.
#context {
  let theme = theme-from-text-fill()
  let frequency-color = theme.callouts.proposition.border
  let radius-color = theme.callouts.important.border
  local-scope-annotations(m => [
    #block(breakable: false, above: 1.4em, below: 2em)[
    $
      H(rho)
      &=rho^(-1/2)integral_(0)^(infinity)
        f(r)J_(1/2)(r rho)r^(3/2) thin d r \
      &=rho^(-1/2)integral_(0)^(infinity)
        f(r)sqrt(frac(2,pi r rho))sin(r rho)r^(3/2) thin d r \
      &=sqrt(frac(2,pi))
        mark(rho^(-1/2)rho^(-1/2), tag: #(m.tag)("frequency-weight"),
          color: #frequency-color)
        integral_(0)^(infinity)f(r)
        mark(r^(3/2)r^(-1/2), tag: #(m.tag)("radius-weight"),
          color: #radius-color)sin(r rho) thin d r \
      &=sqrt(frac(2,pi))frac(1,rho)
        integral_(0)^(infinity)r f(r)sin(r rho) thin d r.
      #annot((m.tag)("frequency-weight"), pos: top, dy: -0.3em, leader: true,
        annot-text-props: (size: 0.75em))[$=rho^(-1)$]
      #annot((m.tag)("radius-weight"), pos: bottom, dy: 0.3em, leader: true,
        annot-text-props: (size: 0.75em))[$=r$]
    $ #(s.tag)("radial-fourier-three-dimensional-weights")
    ]
  ], parent: s, name: "three-dimensional-hankel-weights")
}

#block(breakable: false)[

#paragraph_tab
The resulting integral has a sine kernel and the weighted input $r f(r)$. #highlight[We can therefore interpret the formula using the Fourier sine transform.] Put $g(r):=r f(r)$ and define its normalized sine transform by
$
  (cal(F)_("sin")g)(rho)
  :=sqrt(frac(2,pi))integral_(0)^(infinity)g(r)sin(r rho) thin d r.
$ #(s.tag)("normalized-sine-transform")
We have therefore obtained
$
  H(rho)=frac((cal(F)_("sin")g)(rho),rho), "where"
  quad g(r)=r f(r), quad rho>0.
$ #(s.tag)("radial-fourier-sine-transform")
Thus the three-dimensional radial Fourier transform can be computed by taking the sine transform of $r f(r)$ and dividing by the frequency radius $rho$.
]

#block(sticky: true)[

#paragraph_tab
Let's extend rotational symmetry from functions to distributions by checking whether rotating a test function changes the number a distribution assigns to it. This will also include point masses and surface measure on a sphere.
]

#definition(title: "Radial distributions")[
Let $n>=2$. A distribution $T$ on $bb(R)^(n)$ is *radial* if
$ chevron.l T,phi compose Q chevron.r=chevron.l T,phi chevron.r $
for every rotation $Q in op("SO")(n)$ and every test function $phi in cal(D)(bb(R)^(n))$. In other words, rotating the test function leaves the value assigned by $T$ unchanged.
] #(s.tag)("radial-distribution-definition")

#paragraph_tab
Recall from @definition_of_dirac_distribution that the point mass $delta_(0)$ evaluates a test function at the origin. #highlighted[Since every rotation fixes the origin, $delta_(0)$ is radial]:
$
  chevron.l delta_(0),phi compose Q chevron.r
  =(phi compose Q)(0)=phi(0)
  =chevron.l delta_(0),phi chevron.r.
$

#paragraph_tab
Let's now spread mass over the unit sphere using its surface area. The resulting distribution evaluates a test function by integrating its values over the sphere.

#definition(title: "Surface measure as a distribution")[
Let $n>=2$ and let $sigma$ be surface measure on $S^(n-1)$. For a Borel subset $A subset S^(n-1)$, $sigma(A)$ is its $(n-1)$-dimensional area. We also write $sigma$ for the distribution on $bb(R)^(n)$ defined by
$
  chevron.l sigma,phi chevron.r
  :=integral_(S^(n-1))phi(omega) thin d S(omega),
  quad phi in cal(D)(bb(R)^(n)).
$ #(s.tag)("sphere-surface-measure")
For $n=2$, $d S$ measures arc length on the unit circle; for $n=3$, it measures area on the unit sphere. The total mass is $sigma(S^(n-1))=|S^(n-1)|$.
] #(s.tag)("sphere-surface-measure-definition")

#lemma(title: "Rotations preserve the sphere and its surface measure")[
For every $Q in op("SO")(n)$,
$
  Q(S^(n-1))=S^(n-1),
  quad sigma(Q(A))=sigma(A)
$
for every Borel subset $A subset S^(n-1)$.
] #(s.tag)("sphere-rotation-lemma")

#proof[
A rotation satisfies $Q^(upright(T))Q=I$, so
$
  |Q omega|^(2)
  =omega^(upright(T))Q^(upright(T))Q omega
  =|omega|^(2).
$
Thus $|omega|=1$ implies $|Q omega|=1$. The inverse rotation has the same property, so $Q$ maps the sphere bijectively onto itself.

#paragraph_tab
To check surface area, recall the unit sphere's induced Riemannian metric $h$ from the proof of #(s.ref)("polar-laplacian-lemma"). In a local sphere parametrization $omega=omega(theta)$, with $theta=(theta^(1),dots,theta^(n-1))$, its coordinate components are
$
  h_(a b)=partial_(a)omega dot partial_(b)omega,
  quad 1<=a,b<=n-1.
$
Here $partial_(a)=frac(partial,partial theta^(a))$. As before, $op("det")h$ denotes the determinant of the coordinate matrix $(h_(a b))$. The corresponding surface element is
$
  d S=sqrt(op("det")h) thin d theta^(1) dots d theta^(n-1).
  #dots_space #footnote[For the coordinate formula for the Riemannian volume form, see #project-ref("smooth-manifolds", <source-proposition-15-31>). Applying it to the sphere with its induced metric $h$ gives this surface element.]
$ #(s.tag)("sphere-surface-element")
The rotated parametrization is $Q compose omega$, whose tangent vectors are $Q partial_(a)omega$. Its metric components in the same parameter coordinates satisfy
$
  tilde(h)_(a b)
  &=(Q partial_(a)omega) dot (Q partial_(b)omega) \
  &=(partial_(a)omega)^(upright(T))Q^(upright(T))Q(partial_(b)omega) \
  &=partial_(a)omega dot partial_(b)omega=h_(a b).
$
Thus rotation preserves the induced metric $h$. The coordinate matrices before and after rotation have the same determinant, so they give the same surface element. Under $eta=Q omega$, we therefore have $d S(eta)=d S(omega)$. Integrating over any Borel subset $A$ gives $sigma(Q(A))=sigma(A)$.
]

#paragraph_tab
We can now apply #(s.ref)("sphere-rotation-lemma") to the distribution in #(s.ref)("sphere-surface-measure-definition"). For any test function $phi$, substitute $eta=Q omega$:
$
  chevron.l sigma,phi compose Q chevron.r
  &=integral_(S^(n-1))phi(Q omega) thin d S(omega) \
  &=integral_(S^(n-1))phi(eta) thin d S(eta)
    =chevron.l sigma,phi chevron.r.
$ #(s.tag)("sphere-measure-radiality")
The substitution preserves both the region $S^(n-1)$ and the surface element $d S$. Thus $sigma$ satisfies #(s.ref)("radial-distribution-definition") and is radial.

#block(sticky: true)[

#paragraph_tab
Let's see the same argument in elementary coordinates when $n=2$. Parametrize the unit circle by
]
$
  omega(theta)=(cos theta,sin theta),
  quad 0<=theta<2pi, quad d S=d theta.
$
If $Q_(alpha)$ is rotation through angle $alpha$, then $Q_(alpha)omega(theta)=omega(theta+alpha)$. Therefore
$
  chevron.l sigma,phi compose Q_(alpha) chevron.r
  &=integral_(0)^(2pi)
    phi(cos(theta+alpha),sin(theta+alpha)) thin d theta \
  &=integral_(alpha)^(2pi+alpha)phi(cos u,sin u) thin d u \
  &=integral_(0)^(2pi)phi(cos u,sin u) thin d u
    =chevron.l sigma,phi chevron.r.
$ #(s.tag)("circle-measure-rotation")
The substitution in the second line is $u=theta+alpha$. The last line holds because $u arrow.r phi(cos u,sin u)$ is $2pi$-periodic. #highlighted[We integrate around one full circle, so the starting angle does not affect the result.]

#paragraph_tab
#highlighted[Our surface measure also connects directly with the angular kernel used to compute radial Fourier transforms.] Let's identify that connection using the normalization in #(s.ref)("unitary-transform").

#proposition(title: "Fourier transform of sphere surface measure")[
The surface measure $sigma$ on $S^(n-1)$ is a tempered distribution. Its Fourier transform is the smooth radial function
$
  hat(sigma)(xi)
  &=(2pi)^(-n/2)integral_(S^(n-1))e^(-i xi dot omega) thin d S(omega) \
  &=(2pi)^(-n/2)Psi_(n)(xi).
$ #(s.tag)("sphere-measure-fourier-transform")
] #(s.tag)("sphere-measure-fourier-proposition")

#proof[
Let's first examine what kind of distribution the surface integral defines. We introduced $sigma$ using compactly supported smooth test functions; what happens if we use a Schwartz function instead? Since the sphere has finite area, we can estimate the same integral for $phi in cal(S)(bb(R)^(n))$ as follows:
#local-scope-annotations(m => [
  #block(breakable: false, above: 0.8em, below: 2.2em)[
  $
    |chevron.l sigma,phi chevron.r|
    &<=integral_(S^(n-1))|phi(omega)| thin d S(omega) \
    &<=|S^(n-1)|sup_(x in bb(R)^(n))|phi(x)| \
    &=mark(|S^(n-1)|, tag: #(m.tag)("mass"))
      mark(q_(0,0)(phi), tag: #(m.tag)("seminorm")).
    #annot((m.tag)("mass"), pos: bottom, dx: -1.8em, dy: 0.6em, leader: true,
      annot-text-props: (size: 0.75em))[finite total mass]
    #annot((m.tag)("seminorm"), pos: bottom, dx: 1.8em, dy: 0.6em, leader: true,
      annot-text-props: (size: 0.75em))[Schwartz seminorm]
  $ #(s.tag)("sphere-measure-tempered-bound")
  ]
], parent: s, name: "sphere-measure-tempered")
Here $q_(0,0)(phi)=sup_(x in bb(R)^(n))|phi(x)|$. The estimate shows that the integral is finite and controlled by a single Schwartz seminorm. If $phi_(k) arrow.r 0$ in the Schwartz topology, then $q_(0,0)(phi_(k)) arrow.r 0$, and the estimate gives $chevron.l sigma,phi_(k) chevron.r arrow.r 0$. Thus the same surface integral defines a continuous linear functional on $cal(S)$. We have therefore found that $sigma$ is a tempered distribution, with $C=|S^(n-1)|<infinity$ and $N=0$ in @definition_of_tempered_distribution. This allows us to use Fourier duality to compute its Fourier transform.

#block(breakable: false)[

#paragraph_tab
Now let's compute the number $chevron.l hat(sigma),phi chevron.r$ for an arbitrary Schwartz test function $phi$. Fourier duality in @definition_of_fourier_transform_on_tempered_distributions lets us compute this number by integrating $hat(phi)$ over the unit sphere. Since $phi in cal(S)$, we can write $hat(phi)$ using the classical Fourier integral in #(s.ref)("unitary-transform"). Substituting this formula into the surface integral and then exchanging the order of integration gives
$
  chevron.l hat(sigma),phi chevron.r
  &=chevron.l sigma,hat(phi) chevron.r \
  &=integral_(S^(n-1))hat(phi)(omega) thin d S(omega) \
  &=(2pi)^(-n/2)integral_(S^(n-1))
    integral_(bb(R)^(n))phi(xi)e^(-i omega dot xi) thin d xi thin d S(omega) \
  &=integral_(bb(R)^(n))
    lr([(2pi)^(-n/2)integral_(S^(n-1))
      e^(-i xi dot omega) thin d S(omega)])phi(xi) thin d xi.
    #dots_space #footnote[Fubini applies because the absolute integral is $integral_(S^(n-1))integral_(bb(R)^(n))|phi(xi)e^(-i omega dot xi)| thin d xi thin d S(omega)=|S^(n-1)|norm(phi)_(L^(1))<infinity$: the sphere has finite area and every Schwartz function is integrable.]
$
The last line exhibits a function of $xi$ multiplying $phi(xi)$; #highlighted[the expression in brackets is independent of the test function.] We therefore define the function obtained from this calculation by
$
  K(xi):=(2pi)^(-n/2)integral_(S^(n-1))
    e^(-i xi dot omega) thin d S(omega).
$ #(s.tag)("sphere-measure-fourier-kernel")
The bound $|K(xi)|<=(2pi)^(-n/2)|S^(n-1)|$ shows that $K$ is bounded and locally integrable. Since the calculation holds for every Schwartz test function, @regular_distribution_induced_by_locally_integrable_function identifies $hat(sigma)$ with the regular distribution represented by $K$.
]

#paragraph_tab
Recall the definitions of $K$ in #(s.ref)("sphere-measure-fourier-kernel"), $Psi_(n)$ in #(s.ref)("vector-angular-kernel"), and $psi_(n)$ in #(s.ref)("angular-kernel"). The first two take vector arguments, while $psi_(n)$ takes a nonnegative scalar. Using $Psi_(n)(xi)=psi_(n)(|xi|)$, we obtain
$
  hat(sigma)(xi)=K(xi)=(2pi)^(-n/2)Psi_(n)(xi)
  =(2pi)^(-n/2)psi_(n)(|xi|).
$
We already showed that $Psi_(n)$ is unchanged by rotations, using the fact that they preserve both the unit sphere and its surface measure. Hence, for every $Q in op("SO")(n)$,
$
  K(Q xi)
  &=(2pi)^(-n/2)Psi_(n)(Q xi) \
  &=(2pi)^(-n/2)Psi_(n)(xi)=K(xi).
$
Thus $K(xi)$ depends only on $|xi|$: it is radial. Since $Psi_(n)$ is also smooth, as shown earlier, so is its constant multiple $K$. This proves that $hat(sigma)$ is represented by a smooth radial function.
]

#block(breakable: false)[

#paragraph_tab
#(s.ref)("sphere-measure-fourier-proposition") gives the Bessel kernel a geometric meaning. Combining #(s.ref)("sphere-measure-fourier-transform") with $Psi_(n)(xi)=psi_(n)(|xi|)$ and the Bessel formula in #(s.ref)("sphere-bessel") gives, for $rho=|xi|>0$,
$
  hat(sigma)(xi)
  &=(2pi)^(-n/2)Psi_(n)(xi)=(2pi)^(-n/2)psi_(n)(rho) \
  &=rho^(1-n/2)J_(n/2-1)(rho).
$ #(s.tag)("sphere-measure-bessel")
The Bessel expression therefore represents the Fourier transform of mass distributed over the unit sphere according to surface area. It records how the phases $e^(-i xi dot omega)$ from all points of the sphere combine; the dimension determines the order $n/2-1$. #(s.ref)("sphere-phase-figure") illustrates the area weights and phases for $n=3$ and $xi=2e_(1)$. At $xi=0$, continuity supplies the value $hat(sigma)(0)=(2pi)^(-n/2)|S^(n-1)|$.
]

#figure(
  radial-sphere-phase-diagram(),
  caption: [For $n=3$ and $xi=2e_(1)$, equal increments of $u=omega_(1)$ give equal-area bands on the sphere. Thin arrows show midpoint phase samples; the bold arrow is the exact continuous surface average $frac(Psi_(3)(2e_(1)),4pi)$.],
) #(s.tag)("sphere-phase-figure")

#paragraph_tab
We can now reinterpret the earlier radial Fourier formula in terms of spherical layers. Let $F in cal(S)(bb(R)^(n))$ with $F(x)=f(|x|)$, and write $rho=|xi|$. In #(s.ref)("radial-fourier-angular"), use $hat(F)(xi)=H(rho)$ and rewrite $psi_(n)(r rho)$ as $Psi_(n)(r xi)$. Substituting #(s.ref)("sphere-measure-fourier-transform") then gives
$
  hat(F)(xi)
  &=(2pi)^(-n/2)integral_(0)^(infinity)
    f(r)r^(n-1)Psi_(n)(r xi) thin d r \
  &=integral_(0)^(infinity)
    f(r)r^(n-1)hat(sigma)(r xi) thin d r.
$ #(s.tag)("radial-fourier-sphere-layers")
The factor $r^(n-1)$ is the surface-area scaling already present in the polar volume formula in #(s.ref)("polar-volume"). For $r>0$, scaling the unit sphere by $x=r omega$ shows that $r^(n-1)hat(sigma)(r xi)$ is the Fourier transform of surface measure on the sphere of radius $r$. The weight $f(r)$ is the common value of $F$ on that sphere. #highlighted[Thus the Fourier transform of a radial function is obtained by integrating the contributions of its spherical layers over all radii.] Inserting #(s.ref)("sphere-measure-bessel") into this integral recovers the Bessel formula in #(s.ref)("radial-fourier-bessel").

])
