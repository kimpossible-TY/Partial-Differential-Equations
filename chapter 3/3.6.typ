#import "../Styles/styles.typ": *
#import "figures/figures.typ": grounded-plane-images-diagram, reflection-center-and-translation-diagram, rectangular-dirichlet-domain-diagram, rectangular-period-lattice-diagram, reflected-cell-images-diagram, periodic-dirichlet-kernel-comparison-diagram, gaussian-polynomial-decay-diagram, periodic-heat-duality-diagram, jacobi-small-tau-diagram, torus-edge-identification-diagram, torus-periodization-diagram
#import "@preview/mannot:0.4.0": *

#local-tag-scope(s => [

== The method of images and Poisson's summation formula

#paragraph_tab
Earlier, we constructed evolution operators on the whole space from their Fourier multipliers. #highlighted[Let's now ask how to use those operators when the solution must satisfy a boundary condition.] We begin with the image charge familiar from electrostatics, then transfer the same reflection to the heat equation. Repeating the reflection leads to periodicity; comparing the resulting heat kernel with its Fourier series gives Poisson's summation formula. We then connect the Jacobi transformation to a Mellin integral for the Riemann zeta function.#footnote[This section develops Michael E. Taylor, _Partial Differential Equations I: Basic Theory_, Chapter 3, §7; the supplied extract is pp. 273–277. The electrostatic example and the detailed kernel comparisons explain the connection with our preceding notes.]

#paragraph_tab
Let $Omega=bb(R)^(3)_(+):={x:x_(3)>0}$, and place a charge $q eq.not 0$ at $z=(0,0,a)$, where $a>0$. A Dirichlet boundary condition prescribes the value of the potential on the boundary. For an infinite grounded conducting plane at $x_(3)=0$, we take the ground potential as zero, so the condition is $V=0$ there. With vacuum permittivity $epsilon_(0)$, the potential must satisfy
$
  -Delta V=frac(q,epsilon_(0))delta_(z) " in " Omega,
  quad V|_(partial Omega)=0,
  quad V(x) arrow.r 0 " as " |x| arrow.r infinity.
$ #(s.tag)("electrostatic-problem")
The free-space potential $q/(4pi epsilon_(0)|x-z|)$ has the correct source. #highlighted[It is nonzero at every finite positive distance from the charge and approaches zero only at infinity,] so it fails the boundary condition on the plane. We need an additional potential that cancels this boundary value without introducing another source inside $Omega$.

#paragraph_tab
Reflect the source across the plane, writing $z^(*)=(0,0,-a)$. For $x$ on the plane, $|x-z|=|x-z^(*)|$. Thus a charge $-q$ at $z^(*)$ supplies exactly the required cancellation. Using $C(r):=1/(4pi|r|)$, define
#local-scope-annotations(m => [
  #block(breakable: false, above: 1.5em, below: 1.5em)[
  $
    V(x):=frac(q,epsilon_(0))lr((
      mark(C(x-z), tag: #(m.tag)("real"))
      -mark(C(x-z^(*)), tag: #(m.tag)("image"))
    )).
    #annot((m.tag)("real"), pos: top, dy: -0.7em,
      leader: true, annot-text-props: (size: 0.8em))[source in $Omega$]
    #annot((m.tag)("image"), pos: bottom, dy: 0.7em,
      leader: true, annot-text-props: (size: 0.8em))[source outside $Omega$]
  $ #(s.tag)("image-potential")
  ]
], parent: s, name: "electrostatic-sources")

#figure(
  grounded-plane-images-diagram(),
  caption: [A section through the grounded plane. Equal distances at a boundary observer $b$ produce cancellation. The segments represent source-observer distances, not electric field lines.],
) #(s.tag)("grounded-plane")

#paragraph_tab
Applying @laplacian_fundamental_solution_identity with $n=3$ and $C=-Phi_(3)$ gives $-Delta C=delta_(0)$. Since the image source lies outside $Omega$, the proposed potential #(s.ref)("image-potential") has the required source. Equal boundary distances give $V=0$ on the plane, and both terms decay at infinity. The maximum principle applied to the difference of two solutions gives uniqueness, so this construction determines the physical potential.#footnote[For the planar maximum principle and boundary uniqueness, see #project-ref("complex-analysis", <thm-harmonic-maximum>) and #project-ref("complex-analysis", <thm-harmonic-boundary-uniqueness>). Here the same maximum-principle argument applies on expanding half-balls, using decay at infinity.]

#paragraph_tab
Recall the whole-space notation introduced earlier:
$
  A=sqrt(-Delta), quad e^(-t A^(2))f=p_(t)^((n))*f,
  quad p_(t)^((n))(r)=(4pi t)^(-n/2)e^(-|r|^(2)/(4t)).
$ #(s.tag)("free-heat")
The Gaussian depends only on distance. This is the property that allowed the Coulomb responses to cancel on a reflecting plane, #highlighted[so we can try the same construction for heat.] Let $Omega=bb(R)^(n)_(+)={x in bb(R)^(n):x_(n)>0}$, and prescribe an initial temperature $f in C_(c)^(infinity)(Omega)$. We seek a temperature $u(t,x)$ that evolves by the heat equation while the boundary is held at zero:
$
  cases(
    partial_(t)u=Delta_(x)u & quad "in " (0,infinity) times Omega,
    u=0 & quad "on " (0,infinity) times partial Omega,
    u(0,x)=f(x) & quad x in Omega.
  )
$ #(s.tag)("dirichlet-heat-problem")
#highlighted[The whole-space formula does not generally vanish on this boundary.] Our goal is to construct a kernel $K_(D)(t;x,z)$ such that $u(t,x)=integral_(Omega)K_(D)(t;x,z)f(z) thin d z$ satisfies all three conditions. The initial datum $f$ and the boundary value are fixed; the temperature for $t>0$ is what we seek. We work with classical solutions continuous up to the initial and boundary faces and bounded on $[0,T] times overline(Omega)$ for each $T>0$.

#paragraph_tab
For $Omega=(0,infinity)$, the given $f$ is defined only on $(0,infinity)$, while #(s.ref)("free-heat") requires data on $bb(R)$. Choose an extension $g in C_(c)^(infinity)(bb(R))$ with $g|_(Omega)=f$. The values of $g$ outside $Omega$ are auxiliary initial data. Each such extension gives a solution on $bb(R)$
$
  w_(g)(t,x):=integral_(bb(R))p_(t)^((1))(x-z)g(z) thin d z.
$
Its restriction to $x>0$ already satisfies the heat equation and has initial value $f$. It is a candidate for our problem, with the boundary condition still to be checked. #highlighted[We can choose $g$ on $z<0$ to enforce the remaining boundary condition.]

#paragraph_tab
To determine those values, first keep $g$ fixed and rewrite its convolution. Split the integral at zero and substitute $z=-y$ in the negative half. Since the Gaussian kernel is radial, $p_(t)^((1))(-z)=p_(t)^((1))(z)$, and we obtain
$
  w_(g)(t,x)
  &=integral_(0)^(infinity)
    lr([p_(t)^((1))(x-z)f(z)+p_(t)^((1))(x+z)g(-z)]) thin d z, \
  w_(g)(t,0)
  &=integral_(0)^(infinity)p_(t)^((1))(z)lr([f(z)+g(-z)]) thin d z.
$
Splitting the integral and changing variables have only rewritten the fixed candidate $w_(g)$. Choosing another extension can change its values for $t>0$ while keeping the prescribed initial datum $f$ fixed. For example, #highlighted[the zero extension leaves $w_(g)(t,0)=integral_(0)^(infinity)p_(t)^((1))(z)f(z) thin d z$, which is generally nonzero.]

#paragraph_tab
Choosing $g(-z)=-f(z)$ for $z>0$ makes the contributions from $z$ and $-z$ cancel at the boundary $x=0$, so $w_(g)(t,0)=0$ for every $t>0$. This selects a candidate satisfying the boundary condition while preserving $g|_(Omega)=f$. #highlighted[It assigns an opposite image to each initial heat contribution, just as in electrostatics.] Taking $g(0)=0$ gives the odd extension below.

#definition(title: "Odd extension across a boundary")[
The odd extension of $f$ to $bb(R)$ is
$
  f^("#")(z)=cases(f(z) & quad z>0, 0 & quad z=0, -f(-z) & quad z<0).
$
It satisfies $f^("#")(-z)=-f^("#")(z)$ and agrees with $f$ on $Omega$.
] #(s.tag)("odd-extension")

#paragraph_tab
For the chosen extension, substitute $g=f^("#")$ into the split convolution:
#local-scope-annotations(m => [
  #let kmark(body) = {
    set math.equation(numbering: none)
    markub(body, tag: (m.tag)("kernel"), bracket: sym.brace.b)
  }
  #block(breakable: false, above: 1em, below: 2.4em)[
  $
    u^("#")(t,x)
    &:=w_(f^("#"))(t,x) \
    &=integral_(0)^(infinity)
      kmark(lr([p_(t)^((1))(x-z)-p_(t)^((1))(x+z)]))f(z) thin d z.
    #annot((m.tag)("kernel"), pos: bottom, dy: 0.2em,
      leader: false, annot-text-props: (size: 0.8em))[kernel]
  $ #(s.tag)("half-line-solution")
  ]
], parent: s, name: "half-line-kernel")
Set $u(t,x)=u^("#")(t,x)$ for $x>0$. The minus sign comes from the odd extension(#(s.ref)("odd-extension")). Inside $Omega$, the two kernel weights generally differ, allowing a nonzero temperature even though their boundary contributions cancel.

#paragraph_tab
This gives the candidate kernel for the one-dimensional case of #(s.ref)("dirichlet-heat-problem"). Returning to $Omega=bb(R)^(n)_(+)$, reflection changes only the normal coordinate $z_(n)$ and leaves the tangential coordinates $z'$ unchanged. The following proposition verifies that the same construction solves the half-space problem.

#proposition(title: "Heat kernel for a Dirichlet half-space")[
For $z=(z',z_(n)) in Omega$, set $z^(*)=(z',-z_(n))$. The Dirichlet heat kernel for #(s.ref)("dirichlet-heat-problem") is
$
  K_(D)(t;x,z)=p_(t)^((n))(x-z)-p_(t)^((n))(x-z^(*)),
  quad t>0, quad x,z in Omega.
$ #(s.tag)("half-space-kernel")
The unique solution is $u(t,x)=integral_(Omega)K_(D)(t;x,z)f(z) thin d z$.
]

#proof[
Let $R(x',x_(n))=(x',-x_(n))$. Extend $f$ oddly, and apply #(s.ref)("free-heat"). Both Gaussian terms solve the heat equation for $t>0$. The reflection preserves Lebesgue measure and Euclidean distance, so the substitution $z=R y$ gives
$
  u^("#")(t,R x)
  &=integral_(bb(R)^(n))p_(t)^((n))(R x-R y)f^("#")(R y) thin d y \
  &=-integral_(bb(R)^(n))p_(t)^((n))(x-y)f^("#")(y) thin d y
  =-u^("#")(t,x).
$ #(s.tag)("heat-preserves-oddness")
The Gaussian convolution is smooth for $t>0$. On the wall $R x=x$, oddness therefore forces $u^("#")(t,x)=0$. Splitting the convolution into the two half-spaces yields #(s.ref)("half-space-kernel"). The approximate identity recovers the initial value, including continuity up to the initial face:
$
  u(t,x)&=integral_(Omega)K_(D)(t;x,z)f(z) thin d z \
  &=(p_(t)^((n))*f^("#"))(x) arrow.r f(x)
  quad "as " t arrow.r 0^(+), quad x in Omega.
$ #(s.tag)("half-space-initial-value")
Since the Gaussian has mass one, $|u(t,x)|<=norm(f)_(infinity)$. Thus the construction gives a solution in the stated class.

#paragraph_tab
For uniqueness, we adapt the maximum-principle argument of #project-ref("complex-analysis", <thm-harmonic-boundary-uniqueness>). In that bounded-domain proof, the harmonic difference $w$ satisfies $Delta w=0$, so applying $Delta$ to the corrected function leaves only the contribution of the positive quadratic correction. Fix $T>0$ and let $v$ be the difference of two solutions in the stated class on $[0,T] times overline(Omega)$. It is bounded, solves the heat equation, and vanishes on the initial face and the wall. Write $L=partial_(t)-Delta_(x)$, so $L v=0$. #highlighted[We therefore apply $L$ to our corrected function]: again, only the correction contributes.

#paragraph_tab
Here $Omega$ is unbounded, so a positive supremum of $v$ need not be attained. For $epsilon>0$, adding $epsilon|x|^(2)$ would make the corrected function tend to $+infinity$ at spatial infinity. We first try subtracting it instead, so the corrected function tends uniformly to $-infinity$. However,
$
  L lr((v-epsilon|x|^(2)))=2n epsilon>0.
$
At a positive space-time maximum, the heat operator applied to the corrected function is nonnegative, so this sign gives no contradiction.

#paragraph_tab
Since $L(t)=1$, subtracting a time term $epsilon c t$ with $c>2n$ makes the result negative. Choosing $c=2n+1$, set
$
  v_(epsilon)(t,x)&:=v(t,x)-epsilon lr((1+|x|^(2)+(2n+1)t)), \
  L v_(epsilon)&=-epsilon.
$
The constant $1$ makes $v_(epsilon)$ strictly negative on the initial face and the wall, while the spatial term makes it tend uniformly to $-infinity$ at spatial infinity. The same comparison argument therefore gives $v=0$.#footnote[A positive maximum of $v_(epsilon)$ would give $L v_(epsilon)>=0$ (using the left time derivative at $t=T$), contradicting $-epsilon<0$. Thus $v_(epsilon)<=0$; let $epsilon arrow.r 0$ and repeat for $-v$.] Consequently, any extension that produces a solution in this class with the prescribed boundary values gives the same $u$ on $Omega$. The odd extension supplies one explicit construction of that solution.

]

#paragraph_tab
#highlighted[With the wall fixed at $0$, moving the source and observer by the same amount generally changes the heat response, even though their separation is unchanged.] In one dimension, $K_(D)(t;x,z)=p_(t)^((1))(x-z)-p_(t)^((1))(x+z)$. Fix $t>0$ and translate $x,z>0$ together by $a>0$, keeping the wall at $0$. Then
$
  K_(D)(t;x+a,z+a)
  &=p_(t)^((1))((x+a)-(z+a))-p_(t)^((1))((x+a)+(z+a)) \
  &=p_(t)^((1))(x-z)-p_(t)^((1))(x+z+2a).
$ #(s.tag)("translated-half-line-kernel")
The direct term is unchanged, but the reflected term changes. Since the Gaussian $p_(t)^((1))(r)$ is strictly decreasing for $r>0$,
$
  K_(D)(t;x+a,z+a)-K_(D)(t;x,z)
  =p_(t)^((1))(x+z)-p_(t)^((1))(x+z+2a)>0.
$ #(s.tag)("half-line-translation-response")
Thus $K_(D)(t;x+a,z+a)>K_(D)(t;x,z)$: moving both points farther from the wall increases the response to the same unit source because the reflected term being subtracted becomes smaller. In particular, the translation-invariance condition $K_(D)(t;x+a,z+a)=K_(D)(t;x,z)$ required by @translation-convolution-theorem fails here.

#block(breakable: false)[
#paragraph_tab
For $r eq.not 0$, apply scalar subordination from @scalar-subordination-identity with $a=0$ and $y=|r|$:
#local-scope-annotations(m => [
  #let normmark(body) = {
    set math.equation(numbering: none)
    markub(body, tag: (m.tag)("mass-one"), bracket: sym.brace.b)
  }
  #block(breakable: false, above: 1em, below: 0.5em)[
  $
    integral_(0)^(infinity)p_(t)^((3))(r) thin d t
    &=frac(1,4pi|r|)
      normmark(integral_(0)^(infinity)w_(|r|)(t) thin d t)
      #dots_space #footnote[The subordination density in @scalar-subordination-identity and the heat kernel in #(s.ref)("free-heat") satisfy $p_(t)^((3))(r)=(4pi)^(-3/2)t^(-3/2)e^(-|r|^(2)/(4t))=w_(|r|)(t)/(4pi|r|)$. The final identities use @fundamental_solution_of_laplacian.] \
    &=#box(width: 0pt, height: 3em)[]
      frac(1,4pi|r|)=-Phi_(3)(r)=C(r).
    #annot((m.tag)("mass-one"), pos: bottom, dy: 0.2em,
      leader: false, annot-text-props: (size: 0.8em))[$1$]
  $ #(s.tag)("integrated-heat")
  ]
], parent: s, name: "heat-time-integral")
]

Applying #(s.ref)("integrated-heat") to the two terms of #(s.ref)("half-space-kernel"), we obtain
$
  G_(D)(x,z):=integral_(0)^(infinity)K_(D)(t;x,z) thin d t
  , quad x,z in bb(R)^(3)_(+), quad x eq.not z.
$ #(s.tag)("green-from-heat")
This is the reflected Coulomb kernel already verified in #(s.ref)("image-potential"), with the factor $q/epsilon_(0)$ removed.

#block(breakable: false)[
#paragraph_tab
Let's verify directly from the heat equation that the time integral #(s.ref)("green-from-heat") satisfies the Green kernel equation $-Delta_(x)G_(D)(x,z)=delta_(z)$. First, express the initial-value property #(s.ref)("half-space-initial-value") as convergence of the kernel in distributions. The image formula #(s.ref)("half-space-kernel") is symmetric: $K_(D)(t;x,z)=K_(D)(t;z,x)$.#footnote[The direct and reflected distances satisfy $|x-z|=|z-x|$ and $|x-z^(*)|=|z-x^(*)|$, and the Gaussian depends only on distance.] Hence, for fixed $z in Omega$ and any $phi in C_(c)^(infinity)(Omega)$,
$
  integral_(Omega)K_(D)(t;x,z)phi(x) thin d x
  &=integral_(Omega)K_(D)(t;z,x)phi(x) thin d x \
  &arrow.r phi(z)=chevron.l delta_(z),phi chevron.r
  quad "as " t arrow.r 0^(+).
$ #(s.tag)("half-space-initial-distribution")
Thus $K_(D)(t;dot,z) arrow.r delta_(z)$ when $t arrow.r 0^+$ in $cal(D)^(*)(Omega)$.
]

#paragraph_tab
The initial kernel is a distributional limit rather than an ordinary endpoint value, so we first compute on $0<epsilon<T$:
$
  -Delta_(x)integral_(epsilon)^(T)K_(D)(t;x,z) thin d t
  &=-integral_(epsilon)^(T)partial_(t)K_(D)(t;x,z) thin d t #dots_space #footnote[Since $K$ is heat kernel, it is satisfied the heat equation.]

  \
  &=K_(D)(epsilon;x,z)-K_(D)(T;x,z).
$
Using #(s.ref)("half-space-initial-distribution") and Gaussian decay, letting $epsilon arrow.r 0^(+)$ and $T arrow.r infinity$ yields $-Delta_(x)G_(D)(x,z)=delta_(z)$ in distributions on $Omega$.

=== Two reflecting walls create a doubled period

#paragraph_tab
Let's solve #(s.ref)("dirichlet-heat-problem") on $Omega=(0,a)$, with initial datum $f in C_(c)^(infinity)(0,a)$ and boundary values $u(t,0)=u(t,a)=0$. The two reflections are $R_(0)x=-x$ and $R_(a)x=2a-x$, as illustrated in #(s.ref)("reflection-centers").

#figure(
  reflection-center-and-translation-diagram(),
  caption: [Reflection at $a$ preserves distance from $a$. Composing the reflections at $0$ and $a$ gives a translation by $2a$.],
) #(s.tag)("reflection-centers")

#block(breakable: false)[
#paragraph_tab
To enforce both boundary values while keeping the initial datum fixed, seek an extension $f^("#")$ that agrees with $f$ on $(0,a)$ and is odd across each wall:
$
  f^("#")(R_(0)x)&=f^("#")(-x)=-f^("#")(x), \
  f^("#")(R_(a)x)&=f^("#")(2a-x)=-f^("#")(x).
$ #(s.tag)("interval-odd-symmetries")
For such an extension, define the candidate $u^("#")(t,x):=(p_(t)^((1))*f^("#"))(x)$ for $x in bb(R)$. #highlighted[We now check that its restriction to $(0,a)$ satisfies both prescribed boundary conditions.] The Gaussian reflection argument in #(s.ref)("heat-preserves-oddness") applies to either wall, giving $u^("#")(t,R_(j)x)=-u^("#")(t,x)$ for $j in {0,a}$. Since $R_(j)j=j$,
$
  u^("#")(t,j)=-u^("#")(t,j)
  quad arrow.r quad u^("#")(t,j)=0,
  quad j in {0,a}.
$
Its restriction to $(0,a)$ therefore has both required boundary values, and the agreement of $f^("#")$ with $f$ preserves the prescribed initial datum.
]

#block(breakable: false)[
#paragraph_tab
To find an extension satisfying both conditions in #(s.ref)("interval-odd-symmetries"), compose the reflections. #highlighted[Their composition is a translation], and the two sign changes cancel:
$
  R_(a)R_(0)x=x+2a,
  quad f^("#")(x+2a)=-f^("#")(-x)=f^("#")(x).
$ #(s.tag)("double-reflection")
Thus the odd extension has period $2a$. Explicitly, for $0<z<a$ and $k in bb(Z)$,
$
  f^("#")(z+2k a)=f(z), quad f^("#")(-z+2k a)=-f(z).
$ #(s.tag)("interval-extension")
Reflection across either wall changes sign; translation by twice the interval length preserves it. The extension need not have period $a$.
]

#figure(
  reflected-cell-images-diagram(),
  caption: [Successive reflections change orientation and sign. Top: sources at $z+2k a$ and $-z+2k a$ cancel in pairs at either wall. Bottom: reflecting a two-dimensional cell gives a checkerboard of signs; the arrows track the reflected coordinate directions.],
) #(s.tag)("image-lattice")

#paragraph_tab
Write $u(t,x)=u^("#")(t,x)$ for $0<x<a$. We already have a solution from the extension; our next goal is to express it using only the original datum $f$ on $(0,a)$. There are two distinct steps: periodicity collects the integral over $bb(R)$ into one period $(-a,a)$, and oddness then combines its two halves into an integral over $(0,a)$.

#paragraph_tab
To keep the first operation visible, introduce the periodized Gaussian
$
  H_(2a)(t,r):=sum_(k in bb(Z))p_(t)^((1))(r+2k a), quad t>0.
$ #(s.tag)("periodized-interval-kernel")
It sums the heat contributions from all translated copies of a source. Relabelling $k$ shows $H_(2a)(t,r+2a)=H_(2a)(t,r)$; Gaussian decay makes this series and its derivatives locally uniformly convergent for $t>0$. First, let's use the period $2a$ of $f^("#")$. Partition $bb(R)$ into $J_(k)=(2k a-a,2k a+a)$, up to endpoints of measure zero. In each interval put $y=z+2k a$ so that every integral runs over $(-a,a)$. Then $f^("#")(z+2k a)=f^("#")(z)$, and
$
  u(t,x)
  &=sum_(k in bb(Z))integral_(J_(k))p_(t)^((1))(x-y)f^("#")(y) thin d y \
  &=sum_(k in bb(Z))integral_(-a)^(a)
    p_(t)^((1))(x-z-2k a)f^("#")(z+2k a) thin d z \
  &=integral_(-a)^(a)lr([sum_(k in bb(Z))p_(t)^((1))(x-z-2k a)])f^("#")(z) thin d z
    #dots_space #footnote[The sum and integral can be exchanged because $sum_(k in bb(Z))integral_(J_(k))|p_(t)^((1))(x-y)f^("#")(y)| thin d y<=norm(f^("#"))_(infinity)integral_(bb(R))p_(t)^((1))(x-y) thin d y=norm(f)_(infinity)<infinity$.] \
  &=integral_(-a)^(a)H_(2a)(t,x-z)f^("#")(z) thin d z.
$ #(s.tag)("interval-one-period")
In the last line, $k arrow.r -k$ identifies the sum with #(s.ref)("periodized-interval-kernel"). The repeated values have disappeared from the data and their translated locations now appear in the kernel.

#paragraph_tab
Next, #highlighted[let's use oddness to bring the negative half of this period into $(0,a)$.] In that half, set $y=-z$:
#flowbox[
  $
    integral_(-a)^(0)H_(2a)(t,x-y)f^("#")(y) thin d y
    &=integral_(a)^(0)H_(2a)(t,x+z)f^("#")(-z)(-thin d z) #dots_space #footnote[just changing the variable $y$ to $z$.] 
    \
    &=integral_(0)^(a)H_(2a)(t,x+z)f^("#")(-z) thin d z \
    &=-integral_(0)^(a)H_(2a)(t,x+z)f(z) thin d z. #dots_space #footnote[by the definition of $f^sharp$ in #(s.ref)("interval-extension").]
  $

  $arrow.b$

  On the positive half, $f^("#")(z)=f(z)$, so #(s.ref)("interval-one-period") becomes :
  $
    u(t,x)=integral_(0)^(a)
      lr([H_(2a)(t,x-z)-H_(2a)(t,x+z)])f(z) thin d z.
  $ #(s.tag)("interval-folded-solution")
]

#block(breakable: false)[
#paragraph_tab
#highlighted[The periodized kernel $H_(2a)$ is the heat kernel of a circle: it is strictly positive, so it cannot vanish at a wall for every source.] Antisymmetrizing it installs the two walls, and the result is a kernel that satisfies the Dirichlet condition by itself. We can now read off the Dirichlet kernel:
$
  K_(D,a)(t;x,z)
  &:=H_(2a)(t,x-z)-H_(2a)(t,x+z) \
  &=sum_(k in bb(Z))lr([p_(t)^((1))(x-z+2k a)-p_(t)^((1))(x+z+2k a)]).
$ #(s.tag)("interval-images")
]

#figure(
  periodic-dirichlet-kernel-comparison-diagram(),
  caption: [Profiles on $[0,a]$ for $a=1$, $z=0.35$, $t=0.06$, with identical scales. The circle has length $2a$ and no walls. On the interval, the direct (dotted) and reflected (dashed) profiles agree at both walls, so their difference $K_(D,a)$ (solid) vanishes there.],
) #(s.tag)("periodic-dirichlet-comparison")

#paragraph_tab
Let's verify directly that the antisymmetrized kernel in #(s.ref)("interval-images") satisfies the Dirichlet condition: do its two terms agree at $x=0$ and $x=a$? We use the evenness and $2a$-periodicity of $H_(2a)$. Its period follows from #(s.ref)("periodized-interval-kernel"). To check evenness, recall that the Gaussian in #(s.ref)("free-heat") satisfies $p_(t)^((1))(-r)=p_(t)^((1))(r)$. Apply this identity and relabel $k$ as $-k$ in the absolutely convergent sum:
#flowbox[
$
  H_(2a)(t,-r)
  &=sum_(k in bb(Z))p_(t)^((1))(-r+2k a) \
  &=sum_(k in bb(Z))p_(t)^((1))(r-2k a)
  =H_(2a)(t,r).
$ #(s.tag)("periodized-interval-evenness")
]

#block(breakable: false)[
#paragraph_tab
At $x=0$, evenness alone makes the two terms equal. At $x=a$, first shift by the period $2a$, then use evenness. Substituting these equalities into #(s.ref)("interval-images") gives the required cancellation at both walls:
#flowbox[
#block[
#set math.equation(numbering: none)
$
  H_(2a)(t,-z)&=H_(2a)(t,z), \
  H_(2a)(t,a+z)&=H_(2a)(t,z-a)=H_(2a)(t,a-z).
$
]

$arrow.b$

$
  K_(D,a)(t;0,z)&=cancelmark(H_(2a)(t,-z)-H_(2a)(t,z))=0, \
  K_(D,a)(t;a,z)&=cancelmark(H_(2a)(t,a-z)-H_(2a)(t,z-a))=0.
    #dots_space #footnote[In the image sum #(s.ref)("interval-images"), the $k$th direct Gaussian pairs with the $(-k)$th reflected Gaussian at $x=0$ and with the $(-k-1)$th reflected Gaussian at $x=a$.]
$ #(s.tag)("interval-boundary-values")
]
]

#paragraph_tab
We have checked the boundary values of $K_(D,a)$ in #(s.ref)("interval-boundary-values"). To see how this kernel gives the heat evolution in #(s.ref)("interval-folded-solution"), let's now verify that it also satisfies the heat equation for each source point $z$. Unlike the Laplacian's fundamental solution in @fundamental_solution_of_laplacian, which responds to a spatial point source in a stationary equation, #highlighted[$K_(D,a)(t;x,z)$ describes its evolution in time while respecting the walls.] The initial-value check will follow separately. Since #(s.ref)("interval-images") is an infinite series, we must justify differentiating it term by term. Fix $0<tau<T<infinity$, and let $D$ be any fixed mixed derivative in $t,x,z$, including the derivative of order zero. Differentiating the Gaussian in #(s.ref)("free-heat") produces polynomial factors multiplying the same Gaussian. Uniformly for $(t,x,z) in [tau,T] times [0,a] times [0,a]$, the image terms therefore satisfy
$
  |D p_(t)^((1))(x plus.minus z+2k a)|
  &<=C_(1)(1+|k|)^(N)e^(-c k^(2)) \
  &<=C_(2)e^(-c k^(2)/2),
  quad sum_(k in bb(Z))e^(-c k^(2)/2)<infinity.
    #dots_space #footnote[Here $c>0$, $N>=0$, and the constants may depend on $D,a,tau,T$, but not on $k,t,x,z$. For $|k|>=1$, $|x plus.minus z+2k a|>=2a(|k|-1)$, while $t>=tau$ bounds all negative powers of $t$. Finally, $(1+r)^(N)e^(-c r^(2)/2)$ is bounded for $r>=0$, which absorbs the polynomial factor into the slower Gaussian.]
$ #(s.tag)("interval-gaussian-majorant")
The comparison in #(s.ref)("gaussian-polynomial-decay") illustrates how a polynomial factor changes the profile but leaves a Gaussian bound. Since the summable majorant in #(s.ref)("interval-gaussian-majorant") is independent of $t,x,z$, the image series and #highlighted[its derivatives of each fixed order converge uniformly.] We can therefore differentiate the sum term by term. Each translated Gaussian satisfies the heat equation, so
$
  partial_(t)K_(D,a)(t;x,z)=partial_(x)^(2)K_(D,a)(t;x,z),
  quad t>0, quad 0<x,z<a.
$ #(s.tag)("interval-heat-equation")
Since $u=p_(t)^((1))*f^("#")$ with $f^("#")$ bounded and equal to $f$ on $(0,a)$, the argument for #(s.ref)("half-space-initial-value") gives $u(t,x) arrow.r f(x)$ as $t arrow.r 0^(+)$ at each $x in (0,a)$ where $f$ is continuous. Together with #(s.ref)("interval-boundary-values"), this verifies all three conditions for #(s.ref)("interval-folded-solution").

#figure(
  gaussian-polynomial-decay-diagram(),
  caption: [A polynomial factor changes the Gaussian profile but preserves rapid decay. Here $r^(4)e^(-r^(2))<=(16e^(-2))e^(-r^(2)/2)$ for $r>=0$; dots sample the summable Gaussian bound at integers.],
) #(s.tag)("gaussian-polynomial-decay")

#block(breakable: false)[
#paragraph_tab
Let's describe the solution in #(s.ref)("interval-folded-solution") by exponential Fourier analysis. The extension $f^("#")$ in #(s.ref)("interval-extension") has period $2a$, so its trigonometric basis function are $e^(i m pi x/a)$, $m in bb(Z)$. On one period, write
$
  f^("#")(x)&=sum_(m in bb(Z))c_(m)e^(i m pi x/a),
    quad x in (-a,a), \
  c_(m)&=frac(1,2a)integral_(-a)^(a)f^("#")(z)e^(-i m pi z/a) thin d z.
$ #(s.tag)("interval-complex-fourier")
The expansion is understood in $L^(2)(-a,a)$. Each mode $e^(i m pi x/a)$ is complex-valued and equals $1$ at $x=0$. #highlighted[How do we obtain real-valued modes on $[0,a]$ that vanish at both ends?] Since $f^("#")$ is odd, $c_(0)=0$ and $c_(-m)=-c_(m)$, so pairing the $m$th and $-m$th modes gives a sine:
$
  c_(m)e^(i m pi x/a)+c_(-m)e^(-i m pi x/a)
  &=c_(m)(e^(i m pi x/a)-e^(-i m pi x/a)) \
  &=2i c_(m)sin(frac(m pi x,a)) \
  &=b_(m)sin(frac(m pi x,a)), \
  b_(m)&:=2i c_(m) \
  &=frac(2,a)integral_(0)^(a)f(z)sin(frac(m pi z,a)) thin d z,
  quad m=1,2,dots.
$ #(s.tag)("interval-sine-coefficients")
Restricting to $(0,a)$, where $f^("#")(x)=f(x)$, yields $f(x)=sum_(m>=1)b_(m)sin(frac(m pi x,a))$ in $L^(2)(0,a)$.

#paragraph_tab
Each exponential mode satisfies $partial_(x)^(2)e^(i m pi x/a)=-(m pi/a)^(2)e^(i m pi x/a)$. Thus its coefficient $A_(m)(t)$ evolves by $partial_(t)A_(m)=-(m pi/a)^(2)A_(m)$, so $A_(m)(t)=c_(m)e^(-t(m pi/a)^(2))$. #highlighted[The modes $m$ and $-m$ have the same eigenvalue, so their sine pair remains a sine mode with the same decay factor.] Consequently,
$
  u(t,x)=sum_(m>=1)b_(m)e^(-t(m pi/a)^(2))sin(frac(m pi x,a)).
$
#highlighted[Each sine mode $sin(frac(m pi x,a))$ vanishes at $x=0$ and $x=a$ on its own, so it is a Dirichlet eigenfunction of $-partial_(x)^(2)$ on $(0,a)$ with eigenvalue $(m pi/a)^(2)$.]
]

#block(breakable: false)[

#paragraph_tab
Substitute the coefficient $b_(m)$ from #(s.ref)("interval-sine-coefficients") into this solution series. For $t>0$, exponential decay permits exchanging the sum and integral, giving $u(t,x)=integral_(0)^(a)K_(D,a)(t;x,z)f(z) thin d z$, now with
$
  K_(D,a)(t;x,z)=frac(2,a)sum_(m>=1)e^(-t(m pi/a)^(2))
    sin(frac(m pi x,a))sin(frac(m pi z,a)).
$ #(s.tag)("interval-spectral")
Why must this sine-series kernel $K_(D,a)$ agree with the image formula #(s.ref)("interval-images")? For each $f in C_(c)^(infinity)(0,a)$, #highlighted[both constructions solve the heat equation with the same initial datum and zero values at both walls. Their difference $w$ therefore satisfies $partial_(t)w=partial_(x)^(2)w$, $w(t,0)=w(t,a)=0$, and $w(0,dot)=0$.] Integration by parts gives
$
  frac(d,d t)norm(w(t,dot))_(2)^(2)=-2norm(partial_(x)w(t,dot))_(2)^(2)<=0,
  quad norm(w(0,dot))_(2)^(2)=0.
$
Hence $w=0$. Since this holds for every such $f$ and both kernels are continuous for $t>0$, #(s.ref)("interval-images") and #(s.ref)("interval-spectral") give the same $K_(D,a)$ pointwise. The first formula records reflected source locations; the second records the Dirichlet eigenmodes of $-partial_(x)^(2)$ on $(0,a)$.
]

#paragraph_tab
To pass from an interval to a rectangular box, we first combine the one-dimensional sine modes. The following lemma identifies the resulting basis and its eigenvalues.

#figure(
  rectangular-dirichlet-domain-diagram(),
  caption: [A 2D schematic of the general $n$-dimensional product $Omega=product_(j=1)^(n)(0,a_(j))$: each coordinate $x_(j)$ has its own interval $(0,a_(j))$, with $u=0$ on both opposite faces.],
)

#lemma(title: "Dirichlet eigenfunctions on a rectangular box")[
Let $a_(j)>0$ and $Omega=product_(j=1)^(n)(0,a_(j))$. For $m in {1,2,dots}^(n)$, define
$
  phi_(m)(x)&=product_(j=1)^(n)sqrt(frac(2,a_(j)))sin(frac(m_(j)pi x_(j),a_(j))), \
  lambda_(m)&=sum_(j=1)^(n)lr((frac(m_(j)pi,a_(j))))^(2).
$
Then $(phi_(m))$ is an orthonormal basis of $L^(2)(Omega)$, each $phi_(m)$ vanishes on $partial Omega$, and $-Delta phi_(m)=lambda_(m)phi_(m)$.
] #(s.tag)("rectangle-eigenbasis")

#proof[
In each coordinate, the normalized sine functions
$
  phi_(m_j)^((j))(x_(j))=sqrt(frac(2,a_(j)))sin(frac(m_(j)pi x_(j),a_(j)))
$
form an orthonormal basis of $L^(2)(0,a_(j))$, by the odd Fourier expansion in #(s.ref)("interval-complex-fourier") and #(s.ref)("interval-sine-coefficients"). Write $bold(m)=(m_1,dots,m_n)$ and set $bold(y)=(frac(pi x_1,a_1),dots,frac(pi x_n,a_n))$. The product form of $phi_(m)$ comes directly from the vector Fourier mode:
#block(breakable: false, above: 1.5em, below: 1.5em)[
$
  e^(i bold(m) dot bold(y))
    &=e^(i sum_(j=1)^n m_j y_j) \
    &=product_(j=1)^n e^(i m_j y_j).
$
]
This factorization is the vector-mode identity from #project-ref("fourier-analysis", <multidimensional-fourier-definition>). Odd extension pairs the positive and negative frequencies in each coordinate into the sine factors. Completeness uses a separate fact: the one-dimensional Fourier modes are complete in $L^(2)$, as established by #project-ref("fourier-analysis", <parseval-circle>). Applying that result in each coordinate and connecting the expansions by Fubini's theorem gives completeness of the product family; the mode factorization alone would not suffice. To verify orthonormality, compute:
#local-scope-annotations(m => [
  #block(breakable: false, above: 1.5em, below: 1.5em)[
  $
    chevron.l phi_(m),phi_(ell) chevron.r_(L^(2)(Omega))
    &=integral_(Omega)product_(j=1)^(n)phi_(m_j)^((j))(x_(j))overline(phi_(ell_j)^((j))(x_(j))) thin d x \
    &=mark(product_(j=1)^(n)(integral_(0)^(a_(j))phi_(m_j)^((j))(x_(j))overline(phi_(ell_j)^((j))(x_(j))) thin d x_(j)), tag: #(m.tag)("fubini-factorization")) \
    &=product_(j=1)^(n)delta_(m_j ell_j)=delta_(m ell).
    #annot((m.tag)("fubini-factorization"), pos: top + right, dx: 0.4em, dy: -0.5em,
      leader: true, annot-text-props: (size: 0.8em))[Fubini]
  $ #(s.tag)("rectangle-product-orthogonality")
  ]
], parent: s, name: "rectangle-product-inner-product")
The displayed factorization proves orthonormality. By the coordinatewise completeness result just recalled, the product modes are complete in $L^(2)(Omega)$.
#block(breakable: false)[
Each factor vanishes at both endpoints, so $phi_(m)=0$ on every face of $Omega$. Differentiating in coordinate $x_k$ acts only on its $k$th factor; therefore $-Delta=-sum_(k=1)^n partial_(x_k)^2$ adds the corresponding one-dimensional eigenvalues:
#block(breakable: false, above: 1.5em, below: 1.5em)[
$
  -Delta phi_(m)(x)
    &=-sum_(k=1)^n partial_(x_k)^2 product_(j=1)^n phi_(m_j)^((j))(x_j) \
    &=sum_(k=1)^n (frac(m_k pi,a_k))^2 product_(j=1)^n phi_(m_j)^((j))(x_j) \
    &=lambda_(m)phi_(m)(x).
$
]
]
]

#paragraph_tab
For this box $Omega$, zero values are prescribed on every face. We extend the initial datum $f$ from $Omega$ to $bb(R)^(n)$ by reflecting its values across each face and reversing their sign at each reflection. Repeating this construction tiles $bb(R)^(n)$ with copies of $Omega$, carrying the reflected and signed data. In two dimensions, these are the rectangular cells in the diagram below.

#paragraph_tab
By the doubled-period relation #(s.ref)("double-reflection"), reflections across $x_j=0$ and $x_j=a_j$ together restore orientation and sign and translate a copy by $2a_j e_j$. Thus the extended datum $f^("#")$ satisfies
$
  f^("#")(x+2a_j e_j)=f^("#")(x), quad j=1,dots,n,
$
where $e_j$ is the $j$th coordinate unit vector. The lattice $Gamma$ records the spacing of individual boxes; translations in $2Gamma$ reproduce the extended datum:
$
  Gamma&={(k_(1)a_(1),dots,k_(n)a_(n)): k in bb(Z)^(n)}, \
  2Gamma&={(2k_(1)a_(1),dots,2k_(n)a_(n)): k in bb(Z)^(n)}.
$
#figure(
  rectangular-period-lattice-diagram(),
  caption: [Odd reflection alternates signs across the $Gamma$ grid. The highlighted points form $2Gamma$, generated by the periods $(2a_1,0)$ and $(0,2a_2)$ in this 2D schematic.],
)

#paragraph_tab
The whole-space formula #(s.ref)("free-heat") factors as $p_(t)^((n))(x-z)=product_(j=1)^(n)p_(t)^((1))(x_(j)-z_(j))$.#footnote[
  #set math.equation(numbering: none)
  $
  p_(t)^((n))(r)&=(4pi t)^(-n/2)e^(-sum_(j=1)^(n) r_(j)^(2)/(4t)) \
  &=product_(j=1)^(n)lr(( (4pi t)^(-1/2)e^(-r_(j)^(2)/(4t)) ))=product_(j=1)^(n) p_(t)^((1))(r_(j)).
  $
]
Each coordinate therefore contributes the interval image kernel in #(s.ref)("interval-images"), giving
$
  K_(D,Omega)(t;x,z)=product_(j=1)^(n)K_(D,a_(j))(t;x_(j),z_(j)).
$ #(s.tag)("rectangle-images")
#block(breakable: false)[

#paragraph_tab
Substitute the one-dimensional sine series #(s.ref)("interval-spectral") into each factor of #(s.ref)("rectangle-images"). The normalized coordinate modes come from #(s.ref)("rectangle-eigenbasis"). For $t>0$, each series converges absolutely, so we can expand their finite product as a sum over the multi-index $bold(m)=(m_1,dots,m_n)$:
$
  K_(D,Omega)(t;x,z)
    &=product_(j=1)^(n)K_(D,a_(j))(t;x_(j),z_(j)) #dots_space #footnote[by #(s.ref)("rectangle-images")] \
    &=product_(j=1)^(n)sum_(m_(j)=1)^(infinity)frac(2,a_(j))e^(-t(m_(j)pi/a_(j))^(2))sin(frac(m_(j)pi x_(j),a_(j)))sin(frac(m_(j)pi z_(j),a_(j))) #dots_space #footnote[by applying #(s.ref)("interval-spectral") in each coordinate] \
    &=product_(j=1)^(n)sum_(m_(j)=1)^(infinity)e^(-t(m_(j)pi/a_(j))^(2))phi_(m_(j))^((j))(x_(j))phi_(m_(j))^((j))(z_(j)) #dots_space #footnote[by the normalized coordinate-mode definition in #(s.ref)("rectangle-eigenbasis")] \
    &=sum_(bold(m) in {1,2,dots}^(n))product_(j=1)^(n)(e^(-t(m_(j)pi/a_(j))^(2))phi_(m_(j))^((j))(x_(j))phi_(m_(j))^((j))(z_(j))) #dots_space #footnote[by expanding the finite product; absolute convergence for $t>0$ was noted above] \
    &=sum_(bold(m) in {1,2,dots}^(n))e^(-t sum_(j=1)^(n)(m_(j)pi/a_(j))^(2))product_(j=1)^(n)phi_(m_(j))^((j))(x_(j))product_(j=1)^(n)phi_(m_(j))^((j))(z_(j)) #dots_space #footnote[by multiplying the exponential factors and grouping the $x$- and $z$-dependent factors] \
    &=sum_(bold(m) in {1,2,dots}^(n))e^(-t lambda_(bold(m)))phi_(bold(m))(x)phi_(bold(m))(z). #dots_space #footnote[by the eigenvalue and eigenfunction definitions in #(s.ref)("rectangle-eigenbasis")]
 $ #(s.tag)("rectangle-spectrum")
]
Thus #(s.ref)("rectangle-images") and #(s.ref)("rectangle-spectrum") describe the same rectangle kernel $K_(D,Omega)$: the equality of the two interval kernels carries over through their coordinate products.


=== Periodization and the heat kernel on a torus

#paragraph_tab
In #(s.ref)("double-reflection"), repeated reflections produced period $2a$, and the odd symmetry of the extension $f^("#")$ in #(s.ref)("interval-extension") paired the exponential modes into the sine modes in #(s.ref)("interval-spectral"). Let's now keep periodicity but remove the walls, so that all periodic data and every exponential mode are allowed. Our goal is to describe one heat kernel by translated sources and by Fourier modes, then use their equality to obtain Poisson summation. Use the lattice $Gamma$ and half-open cell $Q$ below to form the torus $bb(R)^(n)/Gamma$; the diagram shows the construction for $n=2$.#footnote[The surjective homomorphism $x ↦ (e^(2pi i x_(1)/a_(1)),dots,e^(2pi i x_(n)/a_(n)))$ has kernel $Gamma$, so the first isomorphism theorem gives $bb(R)^(n)/Gamma ≅ (S^(1))^(n)$.]

#figure(
  torus-edge-identification-diagram(),
  caption: [From lattice translates to the torus ($n=2$). Dashed edges are excluded from $Q$; the donut shows the topology of the flat quotient.],
)

#paragraph_tab
A datum on the torus can be represented by a function $f$ on $Q$. Extend $f$ by zero outside $Q$ to obtain $f^(0)$, and define its $Gamma$-periodic lift to $bb(R)^(n)$ by
$
  f^(b)(x)=sum_(gamma in Gamma)f^(0)(x+gamma)
    #dots_space #footnote[Unlike the odd extension $f^("#")$ in #(s.ref)("interval-extension"), which reflects copies and changes their signs to enforce zero boundary values with period $2Gamma$, this sum translates $f^(0)$ without changing its orientation or sign, giving period $Gamma$.]
$ #(s.tag)("periodic-data-extension")
#figure(
  torus-periodization-diagram(),
  caption: [Zero extension and lattice periodization of an example datum on a two-dimensional cell. Each colored pattern represents the same values of $f$ in the same orientation.],
)
Cell boundaries have measure zero, so their assigned values do not affect the integrals.

#paragraph_tab
To use the known whole-space Gaussian heat kernel for the torus problem, apply it to the periodic lift $f^(b)$, then rewrite the convolution using data on one fundamental cell $Q$. Partition $bb(R)^(n)$ into cells $Q+gamma$ and translate each cell back to $Q$, just as we collected one period in #(s.ref)("interval-one-period"). #highlighted[Since $f^(b)$ is $Gamma$-periodic by #(s.ref)("periodic-data-extension"), we can replace $f^(b)(z+gamma)$ by $f(z)$ for $z in Q$.] For bounded data on $Q$, absolute integrability justifies exchanging the sum and integral:
$
  u^(b)(t,x)
  &=integral_(bb(R)^(n))p_(t)^((n))(x-y)f^(b)(y) thin d y \
  &=sum_(gamma in Gamma)integral_(Q+gamma)p_(t)^((n))(x-y)f^(b)(y) thin d y \
  &=sum_(gamma in Gamma)integral_(Q)p_(t)^((n))(x-z-gamma)f(z) thin d z \
  &=integral_(Q)lr([sum_(gamma in Gamma)p_(t)^((n))(x-z+gamma)])f(z) thin d z.
$ #(s.tag)("periodic-cell-solution")
Here $y=z+gamma$, periodicity gives $f^(b)(z+gamma)=f(z)$, and the last line relabels $gamma$ as $-gamma$. Thus the sum in brackets is the periodic heat kernel. Since $Q$ has finite measure, $L^(2)(Q) subset L^(1)(Q)$, so the same formula applies to $L^(2)$ data. The periodic lift remains periodic under heat convolution, and Gaussian smoothing makes $u^(b)$ smooth for $t>0$; hence it defines a smooth solution on the torus.

#definition(title: "Periodic heat kernel")[
For $bb(T)^(n)=bb(R)^(n)/(2pi bb(Z))^(n)$, define
$
  H(t,x):=sum_(k in bb(Z)^(n))p_(t)^((n))(x+2pi k), quad t>0.
$ #(s.tag)("periodic-kernel")
The measure on the torus is Lebesgue measure on $Q=[0,2pi)^(n)$, so the solution is $u(t,x)=integral_(Q)H(t,x-z)f(z) thin d z$.
]

#paragraph_tab
The defining sum #(s.ref)("periodic-kernel") gives $H$ period $2pi$ in each coordinate by relabeling $k$. The exponential decay of $p_(t)^((n))$ in #(s.ref)("free-heat") makes the series converge with all derivatives locally uniformly for $t>0$. Moreover, summing the integrals over translated cells gives $integral_(Q)H(t,x) thin d x=integral_(bb(R)^(n))p_(t)^((n))(x) thin d x=1$. As $t arrow.r 0^(+)$, the whole-space kernels concentrate at zero, so their periodization $H$ approaches the unit periodic delta. On $bb(R)^(n)$ this initial distribution is the lattice of deltas $sum_(k in bb(Z)^(n))delta_(2pi k)$, representing a single point of the quotient.

#paragraph_tab
Here we pass from the Fourier transform on $bb(R)^(n)$, with continuous frequencies $xi in bb(R)^(n)$, to the Fourier series on the torus: $2pi$-periodicity restricts the modes $e^(i x dot xi)$ to integer frequencies $xi=ell in bb(Z)^(n)$. #highlighted[We use these discrete modes as eigenfunctions of the torus Laplacian to construct the same periodic kernel $H$ spectrally.] With the Fourier-series convention
$
  c_(ell)(f)=(2pi)^(-n)integral_(Q)f(x)e^(-i ell dot x) thin d x,
  quad f(x)=sum_(ell in bb(Z)^(n))c_(ell)(f)e^(i ell dot x),
$ #(s.tag)("torus-fourier-convention")
Each mode has Laplacian eigenvalue $-|ell|^(2)$#footnote[$Delta e^(i ell dot x)=sum_(j=1)^n partial_(x_j)^2 e^(i ell dot x)=sum_(j=1)^n(i ell_j)^2e^(i ell dot x)=-|ell|^(2)e^(i ell dot x)$], so
$
  H(t,x)=(2pi)^(-n)sum_(ell in bb(Z)^(n))e^(-t|ell|^(2))e^(i ell dot x).
  #dots_space #footnote[The periodic delta has Fourier coefficient $c_(ell)(delta_0)=(2pi)^(-n)$ for every $ell$.]
$ #(s.tag)("periodic-spectrum")
To verify that #(s.ref)("periodic-spectrum") agrees with the translated-source construction #(s.ref)("periodic-kernel"), compute the Fourier coefficients of that defining sum using #(s.ref)("torus-fourier-convention"). Put $y=x+2pi k$ in each cell. Since $ell,k in bb(Z)^(n)$, the phase $e^(2pi i ell dot k)$ is one, so the cell integrals join into one whole-space integral:
$
  c_(ell)(H(t,dot))
  &=(2pi)^(-n)sum_(k in bb(Z)^(n))integral_(Q)
    p_(t)^((n))(x+2pi k)e^(-i ell dot x) thin d x \
  &=(2pi)^(-n)integral_(bb(R)^(n))p_(t)^((n))(y)e^(-i ell dot y) thin d y \
  &=(2pi)^(-n)e^(-t|ell|^(2)).
$ #(s.tag)("periodic-heat-coefficients")
For the last equality, the whole-space kernel $p_(t)^((n))$ in #(s.ref)("free-heat") satisfies $integral_(bb(R)^(n))p_(t)^((n))(y)e^(-i y dot xi) thin d y=e^(-t|xi|^(2))$: convolution with it multiplies each Fourier mode by the heat factor. Thus #(s.ref)("periodic-heat-coefficients") gives exactly the coefficients in #(s.ref)("periodic-spectrum"). Fourier reconstruction identifies the two representations of $H$.

#figure(
  periodic-heat-duality-diagram(),
  caption: [Two descriptions of one periodic heat kernel at $t=1.5$ in one dimension. Left: two individual Gaussian contributions (dashed) and the periodized kernel (solid, summed over $|k|<=5$; the omitted tails are below plotting precision). Right: coefficients for $|ell|<=3$; negative frequencies supply the conjugate modes. The two panels use different vertical scales.],
) #(s.tag)("heat-duality")

#paragraph_tab
Multiply the two representations of $H$ by $(4pi t)^(n/2)$ to remove the prefactor of the whole-space kernel:
$
  sum_(k in bb(Z)^(n))e^(-|x+2pi k|^(2)/(4t))
  &=(4pi t)^(n/2)sum_(k in bb(Z)^(n))p_(t)^((n))(x+2pi k)
  #dots_space #footnote[by #(s.ref)("free-heat")] \
  &=(4pi t)^(n/2)H(t,x)
  #dots_space #footnote[by #(s.ref)("periodic-kernel")] \
  &=(4pi t)^(n/2)(2pi)^(-n)sum_(ell in bb(Z)^(n))e^(-t|ell|^(2))e^(i ell dot x)
  #dots_space #footnote[by #(s.ref)("periodic-spectrum")] \
  &=lr((frac(t,pi)))^(n/2)sum_(ell in bb(Z)^(n))e^(-t|ell|^(2))e^(i ell dot x).
$
This is the Gaussian form of Poisson summation:
#definition(title: "Poisson summation formula: Gaussian form")[
For $t>0$ and $x in bb(R)^(n)$,
#local-scope-annotations(m => [
  #block(breakable: false, above: 1.6em, below: 1.7em)[
  $
    mark(sum_(k in bb(Z)^(n))e^(-|x+2pi k|^(2)/(4t)), tag: #(m.tag)("space"))
    =lr((frac(t,pi)))^(n/2)
    mark(sum_(ell in bb(Z)^(n))e^(-t|ell|^(2))e^(i ell dot x), tag: #(m.tag)("frequency")).
    #annot((m.tag)("space"), pos: top, dy: -0.6em,
      leader: true, annot-text-props: (size: 0.8em))[spatial copies $2pi k$]
    #annot((m.tag)("frequency"), pos: bottom, dy: 0.6em,
      leader: true, annot-text-props: (size: 0.8em))[allowed frequencies $ell$]
  $ #(s.tag)("gaussian-poisson")
  ]
], parent: s, name: "poisson-two-sums")
#v(0.8em)
]

=== Jacobi's transformation and the Mellin transform

#paragraph_tab
We now use the Gaussian form of Poisson summation in #(s.ref)("gaussian-poisson") to compare a Gaussian sum at small and large parameters. #highlighted[The guiding idea is that a broad Gaussian in space has a narrow Fourier transform.] Consider the family $q_(tau)(y):=e^(-pi tau y^(2))$, parameterized by $tau>0$. For small $tau$, this Gaussian is broad, so many integer samples contribute to $sum_(m in bb(Z))q_(tau)(m)$. Its Fourier transform is narrow, suggesting that the same sum might be computed from far fewer frequency samples.

#paragraph_tab
To see why the width of the spatial Gaussian is inversely proportional to the width of its Fourier transform, use frequency $xi$ in cycles per unit length, with phase $e^(-2pi i y xi)$. Gaussian scaling gives
#local-scope-annotations(m => [
  #block(breakable: false, above: 1.6em, below: 0.5em)[
  $
    mark(hat(q)_(tau)(xi), tag: #(m.tag)("transform"))
    &=integral_(bb(R))mark(e^(-pi tau y^(2)), tag: #(m.tag)("gaussian"))e^(-2pi i y xi) thin d y \
    &=integral_(bb(R))e^(-pi tau (v/sqrt(tau))^(2))
      e^(-2pi i (v/sqrt(tau))xi) thin frac(d v,sqrt(tau))
    #dots_space #footnote[Set $v=sqrt(tau)y$, so $y=v/sqrt(tau)$ and $d y=d v/sqrt(tau)$.] \
    &=tau^(-1/2)integral_(bb(R))e^(-pi v^(2))e^(-2pi i v xi/sqrt(tau)) thin d v \
    &=tau^(-1/2)e^(-pi xi^(2)/tau).
    #dots_space #footnote[The Gaussian $e^(-pi v^(2))$ is its own Fourier transform with this phase convention.]
    #annot((m.tag)("transform"), pos: top, dy: -0.6em,
      leader: true, annot-text-props: (size: 0.8em))[Fourier transform]
    #annot((m.tag)("gaussian"), pos: top, dy: -0.6em,
      leader: true, annot-text-props: (size: 0.8em))[$q_(tau)(y)$]
  $
  ]
], parent: s, name: "jacobi-gaussian-transform")

#paragraph_tab
Poisson summation supplies the exact equality between these two sums of samples. In its Gaussian form #(s.ref)("gaussian-poisson"), take $n=1$ and $x=0$, and use $t=pi/tau$:
$
  sum_(m in bb(Z))e^(-pi tau m^(2))
  &=sum_(m in bb(Z))e^(-(2pi m)^(2)/(4(pi/tau))) \
  &=lr((frac(pi/tau,pi)))^(1/2)sum_(ell in bb(Z))e^(-(pi/tau)ell^(2))
  #dots_space #footnote[by #(s.ref)("gaussian-poisson")] \
  &=tau^(-1/2)sum_(ell in bb(Z))e^(-pi ell^(2)/tau).
$
Both sums belong to the same family. Defining $theta$ therefore expresses this identity as Jacobi's transformation formula:
$
  theta(tau):=sum_(m in bb(Z))e^(-pi m^(2)tau),
  quad theta(tau)=tau^(-1/2)theta(1/tau), quad tau>0.
$ #(s.tag)("theta-transform")
#highlighted[Jacobi's transformation lets us approximate the same sum using fewer terms when $tau$ is small.] In $theta(tau)$, the terms $e^(-pi tau m^(2))$ decrease slowly with $|m|$: the exponent has magnitude only $pi$ when $|m|=tau^(-1/2)$. In $theta(1/tau)$, however, even the first nonzero indices contribute only $e^(-pi/tau)$, which is already very small. We can therefore sum a few frequency terms and multiply the result by $tau^(-1/2)$ to recover an approximation to $theta(tau)$.

#paragraph_tab
For example, at $tau=1/25$, the two expressions are
$
  theta(1/25)&=1+2sum_(m=1)^(infinity)e^(-pi m^(2)/25) \
  &=5 lr(\(1+2sum_(ell=1)^(infinity)e^(-25pi ell^(2))\)).
$
The first nonzero term inside the original sum is $e^(-pi/25) approx 0.882$, whereas inside the transformed sum it is $e^(-25pi) approx 7.8 times 10^(-35)$. Thus retaining only the zero frequency already gives $theta(1/25) approx 5$, with a positive correction of about $7.8 times 10^(-34)$. Both sums still sample at integers: the lattice spacing remains one. What changes is the Gaussian width, so many integer samples #highlighted[lie under the broad spatial Gaussian, while only the zero sample matters at the scale shown for the narrow frequency Gaussian] in #(s.ref)("jacobi-small-tau").

#figure(
  jacobi-small-tau-diagram(),
  caption: [At $tau=1/25$, many terms matter in $theta(tau)$; in $theta(1/tau)$ only $m=0$ is visible, with overall factor $tau^(-1/2)=5$.],
) #(s.tag)("jacobi-small-tau")

#paragraph_tab
We now combine Jacobi's transformation with a Mellin transform to study the zeta series
$
  zeta(s)=sum_(m=1)^(infinity)m^(-s), quad op("Re") s>1.
$ #(s.tag)("zeta-series")
The sum $theta$ in #(s.ref)("theta-transform") runs over all integers, whereas the zeta series uses positive integers. For $t>0$, split $theta(t)$ into its zero, positive, and negative index terms:
$
  theta(t)
  &=sum_(m in bb(Z))e^(-pi m^(2)t) \
  &=e^(0)+sum_(m=1)^(infinity)e^(-pi m^(2)t)
    +sum_(m=-infinity)^(-1)e^(-pi m^(2)t).
$
The $m=0$ term is $1$. In the negative index sum, put $k=-m$. #highlighted[Since $m^(2)=k^(2)$, we obtain]
$
  sum_(m=-infinity)^(-1)e^(-pi m^(2)t)
  =sum_(k=1)^(infinity)e^(-pi k^(2)t)
  =sum_(m=1)^(infinity)e^(-pi m^(2)t).
$
Each positive index $m$ and its negative $-m$ therefore contribute the same term. Calling the sum over positive indices $g(t)$, we get
$
  g(t):=sum_(m=1)^(infinity)e^(-pi m^(2)t),
  quad theta(t)=1+2g(t).
$ #(s.tag)("positive-heat-sum")
Substitute $theta(t)=1+2g(t)$ from #(s.ref)("positive-heat-sum") into the reciprocal-argument relation #(s.ref)("theta-transform") and solve for $g(t)$:
$
  1+2g(t)=t^(-1/2)(1+2g(1/t)),
$
$
  g(t)=-frac(1,2)+frac(1,2)t^(-1/2)+t^(-1/2)g(1/t).
$ #(s.tag)("positive-theta-transform")
The terms $-1/2$ and $t^(-1/2)/2$ come from the zero terms of $theta(t)$ and $theta(1/t)$, with division by two accounting for the paired indices.

#paragraph_tab
#highlighted[To connect the heat sum $g(t)$ in #(s.ref)("positive-heat-sum") to the zeta series #(s.ref)("zeta-series"), we need to turn each exponential $e^(-pi m^(2)t)$ into a power of $m$.] Ordinary integration gives the first hint. For a decay rate $a>0$, doubling $a$ makes $e^(-a t)$ reach the same height in half the time, so the area under the curve halves. More generally, setting $r=a t$ gives
$
  integral_(0)^(infinity)e^(-a t) thin d t
  =a^(-1)integral_(0)^(infinity)e^(-r) thin d r
  =a^(-1).
$

#paragraph_tab
To get $a^(-w)$, we need another factor of $a^(-(w-1))$ alongside the $a^(-1)$ from $d t=d r/a$. Since $t=r/a$, the weight $t^(w-1)$ supplies exactly that factor. For complex powers we use $t^(w)=e^(w log t)$. The same substitution now gives
$
  integral_(0)^(infinity)e^(-a t)t^(w-1) thin d t
  &=integral_(0)^(infinity)e^(-r)lr((frac(r,a)))^(w-1)frac(d r,a) \
  &=a^(-w)integral_(0)^(infinity)e^(-r)r^(w-1) thin d r \
  &=a^(-w)Gamma(w), quad op("Re") w>0.
$
This weighted integral defines the Mellin transform $cal(M)h(w)=integral_(0)^(infinity)h(t)t^(w-1) thin d t$ wherever the integral converges. In our heat sum, $a=pi m^(2)$ gives $a^(-w)=pi^(-w)m^(-2w)$. To obtain the zeta term $m^(-s)$, choose $w=s/2$. The Gamma integral is common to all modes, and we get
$
  integral_(0)^(infinity)e^(-pi m^(2)t)t^(s/2-1) thin d t
  =pi^(-s/2)m^(-s)Gamma(s/2), quad op("Re") s>0.
$ #(s.tag)("mellin-single-mode")
To sum #(s.ref)("mellin-single-mode") over $m>=1$, put $sigma:=op("Re") s>1$. The sum of the absolute integrals is $pi^(-sigma/2)Gamma(sigma/2)sum_(m>=1)m^(-sigma)<infinity$, so Fubini applies. We obtain
$
  Lambda(s)&:=pi^(-s/2)Gamma(s/2)zeta(s) \
  &=pi^(-s/2)Gamma(s/2)sum_(m=1)^(infinity)m^(-s)
  #dots_space #footnote[by the definition of $zeta$ in #(s.ref)("zeta-series")] \
  &=sum_(m=1)^(infinity)integral_(0)^(infinity)e^(-pi m^(2)t)t^(s/2-1) thin d t
  #dots_space #footnote[by #(s.ref)("mellin-single-mode")] \
  &=integral_(0)^(infinity)lr((sum_(m=1)^(infinity)e^(-pi m^(2)t)))t^(s/2-1) thin d t
  #dots_space #footnote[by Fubini's theorem] \
  &=integral_(0)^(infinity)g(t)t^(s/2-1) thin d t,
  quad op("Re") s>1.
  #dots_space #footnote[by the definition of $g$ in #(s.ref)("positive-heat-sum")]
$ #(s.tag)("completed-zeta-integral")

#paragraph_tab
If we substitute Jacobi's relation #(s.ref)("positive-theta-transform") throughout the integral in #(s.ref)("completed-zeta-integral"), #highlighted[its terms cancel at large $t$ and cannot be integrated separately.] Instead, split at $t=1$ and apply the relation only for $0<t<1$, where $1/t>1$:
$
  integral_(0)^(1)g(t)t^(s/2-1) thin d t
  &=integral_(0)^(1)lr((-frac(1,2)+frac(1,2)t^(-1/2)+t^(-1/2)g(1/t)))t^(s/2-1) thin d t
  #dots_space #footnote[by #(s.ref)("positive-theta-transform")] \
  &=-frac(1,2)integral_(0)^(1)t^(s/2-1) thin d t
    +frac(1,2)integral_(0)^(1)t^((s-1)/2-1) thin d t \
  &quad +integral_(0)^(1)g(1/t)t^((s-1)/2-1) thin d t \
  &=-frac(1,s)+frac(1,s-1)
    +integral_(1)^(infinity)g(r)r^(-(s+1)/2) thin d r.
  #dots_space #footnote[Put $r=1/t$: $d t=-r^(-2)thin d r$ and $t^((s-1)/2-1)d t=-r^(-(s+1)/2)thin d r$.]
$ #(s.tag)("small-time-mellin")
Adding the integral over $t>=1$ gives
$
  Lambda(s)
  &=integral_(0)^(1)g(t)t^(s/2-1) thin d t
    +integral_(1)^(infinity)g(t)t^(s/2-1) thin d t \
  &=-frac(1,s)+frac(1,s-1)
    +integral_(1)^(infinity)g(t)lr((t^(s/2-1)+t^(-(s+1)/2))) thin d t,
  quad op("Re") s>1.
$ #(s.tag)("large-time-mellin")
The remaining integral uses only $t>=1$, where the terms $e^(-pi m^(2)t)$ defining $g(t)$ decay rapidly with $m$.

])
