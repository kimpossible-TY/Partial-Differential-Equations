#import "../Styles/styles.typ": *
#import "../chapter 3/figures/figures.typ": schwartz-kernel-periodization-diagram
#import "@preview/mannot:0.4.0": *

#local-tag-scope(sk => [

== The Schwartz kernel theorem <schwartz-kernel-theorem-supplement>

#paragraph_tab
A kernel obtained by Fourier inversion or an eigenfunction expansion arrives with a concrete formula. An abstract continuous linear operator need not. Suppose that all we know is a map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$. Testing its output against $phi in cal(D)(X)$ gives the bilinear form
$
  B(phi, f):=chevron.l T f, phi chevron.r.
$
If a distribution kernel exists, it must satisfy
$
  B(phi,f)=chevron.l K,phi ⊗ f chevron.r,
  quad (phi ⊗ f)(x,z):=phi(x)f(z).
$

#paragraph_tab
The difficulty is that this identity initially specifies $K$ only on finite sums of separable test functions. A general element of $cal(D)(X times Z)$ need not itself be separable. We therefore need two facts: separable test functions must be dense in the full product-space test functions, and the bilinear form must obey a joint continuity estimate strong enough to pass to the limit. The Schwartz kernel theorem follows once these two facts are established.

=== Topological framework

#definition(title: "Weak-* topology and continuous linear operators")[
Let $X subset.eq bb(R)^(m)$ and $Z subset.eq bb(R)^(n)$ be open sets.
+ The space of distributions $cal(D)^(*)(X)$ carries the *weak-$*$ topology* $sigma(cal(D)^(*), cal(D))$: a net $u_(alpha) arrow.r u$ if and only if $chevron.l u_(alpha), phi chevron.r arrow.r chevron.l u, phi chevron.r$ for every $phi in cal(D)(X)$.
+ A linear map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$ is *continuous* if for each fixed $phi in cal(D)(X)$, the linear functional $f |-> chevron.l T f, phi chevron.r$ is continuous on $cal(D)(Z)$. We denote by $cal(L)(cal(D)(Z), cal(D)^(*)(X))$ the space of all such continuous linear maps.
] #(sk.tag)("weak-star-operator-space")

#paragraph_tab
To construct this extension rigorously without relying on abstract nuclear tensor products, we make the topological structures of test functions explicit. While the full space $cal(D)(X)$ is not metrizable, restricting to any fixed compact support produces a complete metric space where the classical Baire category theorem applies.

#definition(title: "Fréchet space of test functions on a compact set")[
Let $X subset.eq bb(R)^(m)$ be an open set and $K subset X$ be a compact subset. The space of test functions supported in $K$,
$
  cal(D)_(K)(X) := {u in cal(D)(X): op("supp") u subset.eq K},
$
equipped with the countable family of $C^(r)$ norms $norm(u)_(C^(r)) := max_(|alpha| <= r) sup_(x in K) |partial^(alpha) u(x)|$ ($r >= 0$), is a *Fréchet space* under the complete translation-invariant metric
$
  d(u, v) := sum_(r=0)^(infinity) 2^(-r) frac(norm(u - v)_(C^(r)), 1 + norm(u - v)_(C^(r))).
$
] #(sk.tag)("frechet-test-functions")

#definition(title: "Inductive limit topology on test functions")[
Let $X subset.eq bb(R)^(m)$ be an open set. The full space of test functions $cal(D)(X) = union.big_(K subset.eq X) cal(D)_(K)(X)$ carries the *canonical strict LF-topology* (locally convex inductive limit topology). Under this topology, a linear map $T: cal(D)(X) arrow.r Y$ into any locally convex topological vector space $Y$ is continuous if and only if its restriction
$
  T|_(cal(D)_(K)(X)): cal(D)_(K)(X) arrow.r Y
$
is continuous for every compact subset $K subset X$.
] #(sk.tag)("inductive-limit-topology")

=== Density of separable test functions

#paragraph_tab
With this topological framework established, the proof of the Schwartz kernel theorem splits into two independent analytic components: first, an approximation theorem showing that separable tensor products are dense in bivariate test functions; second, an automatic boundedness theorem promoting separate continuity to joint continuity on Fréchet spaces.

#lemma(title: "Density of algebraic tensor products")[
Let $X subset.eq bb(R)^(m)$ and $Z subset.eq bb(R)^(n)$ be open sets. The algebraic tensor product $cal(D)(X) ⊗ cal(D)(Z)$ is dense in $cal(D)(X times Z)$.

#paragraph_tab
Consequently, if a distribution $u in cal(D)^(*)(X times Z)$ satisfies $chevron.l u, phi ⊗ f chevron.r = 0$ for all $phi in cal(D)(X)$ and $f in cal(D)(Z)$, then $u = 0$.
] #(sk.tag)("tensor-product-density")

#proof[
Let $Psi in cal(D)(X times Z)$ be an arbitrary bivariate test function. Its compact support $op("supp") Psi$ has compact projections $A := pi_(X)(op("supp") Psi) subset X$ and $D := pi_(Z)(op("supp") Psi) subset Z$. Choose smooth cutoff functions $chi in cal(D)(X)$ and $eta in cal(D)(Z)$ such that $chi equiv 1$ on an open neighborhood of $A$ and $eta equiv 1$ on an open neighborhood of $D$. Now choose a half-length $L > 0$ sufficiently large that the compact sets $op("supp") chi$ and $op("supp") eta$ lie strictly inside the open cubes
$
  Q_(x) := (-pi L, pi L)^(m) subset bb(R)^(m),
  quad Q_(z) := (-pi L, pi L)^(n) subset bb(R)^(n).
$
Extending $Psi$ by zero outside its support and then periodically in each coordinate with period $2 pi L$ produces a smooth function on the product torus $bb(T)^(m+n) = (bb(R) slash 2 pi L bb(Z))^(m+n)$. Because $Psi$ and all of its derivatives vanish identically near the boundary $partial (Q_(x) times Q_(z))$, this periodic extension is smooth across the entire torus. It admits the classical multidimensional Fourier series
$
  Psi(x, z) = sum_(j in bb(Z)^(m), k in bb(Z)^(n))
    c_(j,k)(Psi) e_(j)(x) h_(k)(z),
$
where the orthogonal Fourier modes are
$
  e_(j)(x) := exp(i j dot x slash L),
  quad h_(k)(z) := exp(i k dot z slash L),
$
and their Fourier coefficients are given by
$
  c_(j,k)(Psi) := (2 pi L)^(-(m+n))
    integral_(Q_(x) times Q_(z)) Psi(x, z) e_(-j)(x) h_(-k)(z) thin d x thin d z.
$
To establish rapid decay of these coefficients, consider the self-adjoint differential operator $(1 - L^(2) Delta_(x) - L^(2) Delta_(z))$. Acting on the plane-wave modes, it pulls down the scalar eigenvalue:
$
  (1 - L^(2) Delta_(x) - L^(2) Delta_(z)) lr(e_(-j)(x) h_(-k)(z))
  = (1 + |j|^(2) + |k|^(2)) e_(-j)(x) h_(-k)(z).
$
For any non-negative integer $N >= 0$, integrating by parts $N$ times on the product torus yields
$
  &(1 + |j|^(2) + |k|^(2))^(N) c_(j,k)(Psi) \
  &= (2 pi L)^(-(m+n)) integral_(Q_(x) times Q_(z))
      lr([(1 - L^(2) Delta_(x) - L^(2) Delta_(z))^(N) Psi(x, z)])
      e_(-j)(x) h_(-k)(z) thin d x thin d z.
$
Because the periodic extension has no boundary discontinuities, every boundary term vanishes identically. Using the standard norm equivalence $(1 + |j| + |k|)^(2N) <= C'_(N) (1 + |j|^(2) + |k|^(2))^(N)$, bounding the integrand by the $C^(2N)$ norm of $Psi$ produces the rapid decay estimate
$
  |c_(j,k)(Psi)| <= C_(N,L) norm(Psi)_(C^(2N)) (1 + |j| + |k|)^(-2N).
$
Since $chi(x) eta(z) equiv 1$ on $op("supp") Psi$ and vanishes identically outside $Q_(x) times Q_(z)$, multiplying the Fourier expansion by $chi(x) eta(z)$ reproduces $Psi$ identically on all of $X times Z$:
#mannot-scope(m => [
  #block(breakable: false, above: 1.1em, below: 1.2em)[
  $
    \
    Psi = sum_(j,k) bmark(c_(j,k)(Psi), tag: #(m.tag)("fourier-coeff")) thin
          pmark((chi e_(j)), tag: #(m.tag)("x-mode")) ⊗
          mark((eta h_(k)), tag: #(m.tag)("z-mode")).
    #annot((m.tag)("fourier-coeff"), pos: bottom, dy: 0.55em, leader: true, leader-connect: "elbow")[decay $|c_(j,k)| <= C_(N) (1+|j|+|k|)^(-2N)$]
    #annot((m.tag)("x-mode"), pos: top + left, dx: -0.4em, dy: -0.55em, leader: true, leader-connect: "elbow")[$cal(D)(X)$ localized mode]
    #annot((m.tag)("z-mode"), pos: top + right, dx: 0.4em, dy: -0.55em, leader: true, leader-connect: "elbow")[$cal(D)(Z)$ localized mode]
    \
  $
  ]
], parent: sk, name: "step1-tensor-annot")
Whenever $2N > |alpha| + |beta| + m + n$, the decay factor $(1 + |j| + |k|)^(-2N)$ dominates the polynomial growth $(1+|j|)^(|alpha|)(1+|k|)^(|beta|)$ coming from differentiating $e_(j)$ and $h_(k)$, ensuring that the partial sums and all their derivatives converge absolutely and uniformly. Furthermore, every partial sum has support contained in the fixed compact set $op("supp") chi times op("supp") eta$. The series therefore converges in the Fréchet topology of $cal(D)_(op("supp") chi times op("supp") eta)(X times Z)$, and hence in $cal(D)(X times Z)$.

#figure(
  schwartz-kernel-periodization-diagram(),
  caption: [Torus periodization and localized tensor product decomposition of a coupled test function $Psi in cal(D)(X times Z)$. (Left) An arbitrary compact support $op("supp") Psi$ is enclosed within the cube $Q_(x) times Q_(z)$, with projections $A subset X$ and $D subset Z$ covered by smooth cutoffs $chi, eta$. (Middle) Periodizing $Psi$ over $bb(T)^(m+n)$ decouples the coordinates into orthogonal Fourier modes $e_(j)(x) h_(k)(z)$. (Right) Multiplying by $chi(x) eta(z)$ yields compactly supported tensor building blocks $(chi e_(j)) ⊗ (eta h_(k)) in cal(D)(X) ⊗ cal(D)(Z)$, whose super-polynomially decaying sum converges to $Psi$ in $cal(D)(X times Z)$.],
) #(sk.tag)("schwartz-kernel-periodization")

#paragraph_tab
This establishes that the algebraic tensor product $cal(D)(X) ⊗ cal(D)(Z)$ is dense in $cal(D)(X times Z)$. If $u in cal(D)^(*)(X times Z)$ satisfies $chevron.l u, phi ⊗ f chevron.r = 0$ for all product test functions, then for any $Psi in cal(D)(X times Z)$, evaluating against the convergent series yields
$
  chevron.l u, Psi chevron.r
  = lim_(R -> infinity) sum_(|j|, |k| <= R) c_(j,k)(Psi)
      chevron.l u, (chi e_(j)) ⊗ (eta h_(k)) chevron.r
  = 0,
$
forcing $u = 0$. The same density argument applies to any pair of open subdomains of $X$ and $Z$.
]

=== From separate to joint continuity

#paragraph_tab
Next, we upgrade separate continuity to joint continuity on compact supports. This is where the Fréchet completeness from #(sk.ref)("frechet-test-functions") plays its decisive role.

#definition(title: "Separately and jointly continuous bilinear forms")[
Let $E$ and $F$ be topological vector spaces over $bb(C)$. A bilinear form $B: E times F arrow.r bb(C)$ is:
+ *Separately continuous* if $phi |-> B(phi, f)$ is continuous on $E$ for each fixed $f in F$, and $f |-> B(phi, f)$ is continuous on $F$ for each fixed $phi in E$.
+ *Jointly continuous* if it is continuous on the product space $E times F$ equipped with the product topology. For Fréchet spaces $E = cal(D)_(K_(1))(X)$ and $F = cal(D)_(K_(2))(Z)$, this is equivalent to the existence of integers $p, q >= 0$ and a constant $C < infinity$ such that
  $
    |B(phi, f)| <= C norm(phi)_(C^(p)) norm(f)_(C^(q)), quad forall phi in E, #h(1em) f in F.
  $
] #(sk.tag)("bilinear-continuity")

#lemma(title: "Joint continuity of bilinear forms on Fréchet spaces")[
Let $K_(1) subset X$ and $K_(2) subset Z$ be compact sets, and let $E := cal(D)_(K_(1))(X)$ and $F := cal(D)_(K_(2))(Z)$ be the corresponding Fréchet spaces.

#paragraph_tab
Every separately continuous bilinear form $B: E times F arrow.r bb(C)$ is jointly continuous: there exist non-negative integers $p, q >= 0$ and a constant $C < infinity$ such that
$
  |B(phi, f)| <= C norm(phi)_(C^(p)) norm(f)_(C^(q)),
  quad forall phi in E, quad f in F.
$
] #(sk.tag)("frechet-bilinear-joint-continuity")

#proof[
For each pair of integers $q >= 0$ and $a >= 1$, define the subset
$
  E_(q,a) := {phi in E: |B(phi, f)| <= a norm(f)_(C^(q)) " for all " f in F}.
$
Each $E_(q,a)$ can be expressed as the intersection
$
  E_(q,a) = inter.big_(f in F, norm(f)_(C^(q)) <= 1) {phi in E: |B(phi, f)| <= a}.
$
By the separate continuity of $phi |-> B(phi, f)$, each set in the intersection is closed in $E$, so $E_(q,a)$ is closed. Next, let's show that the countable family $(E_(q,a))_(q>=0, a>=1)$ covers $E$. For any fixed $phi in E$, the linear functional $f |-> B(phi, f)$ is continuous on the Fréchet space $F$. In a Fréchet space, every continuous linear functional is bounded by some single seminorm from the defining family: there exist an integer $q >= 0$ and a finite constant $C_(phi) < infinity$ such that $|B(phi, f)| <= C_(phi) norm(f)_(C^(q))$ for all $f in F$. Choosing an integer $a >= C_(phi)$ ensures that $phi in E_(q,a)$, which confirms
$
  E = union.big_(q=0)^(infinity) union.big_(a=1)^(infinity) E_(q,a).
$
Because the Fréchet space $E$ is a complete metric space, the Baire category theorem asserts that $E$ cannot be a countable union of nowhere dense closed sets. Consequently, at least one subset $E_(q,a)$ must have a non-empty interior.

#paragraph_tab
Having non-empty interior means there exist a center point $phi_(0) in E_(q,a)$, a derivative order $p >= 0$, and a radius $epsilon > 0$ such that the open ball
$
  {phi_(0) + h in E: norm(h)_(C^(p)) < epsilon} subset.eq E_(q,a).
$
Thus, whenever $norm(h)_(C^(p)) < epsilon$, both $phi_(0) + h$ and $phi_(0)$ belong to $E_(q,a)$. By linearity $B(h, f) = B(phi_(0) + h, f) - B(phi_(0), f)$, applying the triangle inequality yields
$
  |B(h, f)|
  <= |B(phi_(0) + h, f)| + |B(phi_(0), f)|
  <= a norm(f)_(C^(q)) + a norm(f)_(C^(q))
  = 2a norm(f)_(C^(q)).
$
Now let $phi in E$ be an arbitrary non-zero test function. The rescaled perturbation $h := frac(epsilon, 2 norm(phi)_(C^(p))) phi$ satisfies $norm(h)_(C^(p)) = epsilon slash 2 < epsilon$. Substituting this $h$ into the preceding inequality gives
$
  |B(phi, f)|
  = frac(2 norm(phi)_(C^(p)), epsilon) |B(h, f)|
  <= frac(4a, epsilon) norm(phi)_(C^(p)) norm(f)_(C^(q)).
$
Setting $C := 4a slash epsilon$, we obtain the joint continuity bound on $E times F$:
#mannot-scope(m => [
  #block(breakable: false, above: 1.2em, below: 2.2em)[
  $
    \
    |B(phi, f)| <= mark(frac(4a, epsilon), tag: #(m.tag)("baire-factor"))
                   bmark(norm(phi)_(C^(p)), tag: #(m.tag)("phi-norm"))
                   pmark(norm(f)_(C^(q)), tag: #(m.tag)("f-norm")),
    quad phi in cal(D)_(K_(1))(X), quad f in cal(D)_(K_(2))(Z).
    #annot((m.tag)("baire-factor"), pos: bottom, dy: 0.6em, leader: true, leader-connect: "elbow")[Baire ball factor $4a slash epsilon$]
    #annot((m.tag)("phi-norm"), pos: top + left, dx: -0.4em, dy: -0.55em, leader: true, leader-connect: "elbow")[order $p$ on $E = cal(D)_(K_(1))(X)$]
    #annot((m.tag)("f-norm"), pos: top + right, dx: 0.4em, dy: -0.55em, leader: true, leader-connect: "elbow")[order $q$ on $F = cal(D)_(K_(2))(Z)$]
    \
  $
  ]
], parent: sk, name: "step2-baire-annot")

Notice that the completeness of Fréchet spaces is entirely sufficient here; no recourse to Montel or nuclear space machinery is required.
]

#pagebreak()

=== The representation theorem

#paragraph_tab
Armed with these two foundational lemmas, we are now ready to state and prove the Schwartz kernel theorem. Lemma 1 provides the Fourier building blocks and uniqueness, while Lemma 2 provides the uniform continuity needed to sum them into a well-defined distribution.

#theorem(title: "Schwartz kernel theorem")[
Let $X subset.eq bb(R)^(m)$ and $Z subset.eq bb(R)^(n)$ be open sets. For every continuous linear map
$
  T: cal(D)(Z) arrow.r cal(D)^(*)(X),
$
there exists a unique distribution $K in cal(D)^(*)(X times Z)$ such that
$
  chevron.l T f, phi chevron.r = chevron.l K, phi ⊗ f chevron.r
$
for all $f in cal(D)(Z)$ and $phi in cal(D)(X)$, where $(phi ⊗ f)(x, z) := phi(x) f(z)$.

Conversely, every distribution $K in cal(D)^(*)(X times Z)$ defines a unique continuous linear map $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$ via this relation. Thus, there is a canonical linear isomorphism
$
  cal(L)(cal(D)(Z), cal(D)^(*)(X)) approx.eq cal(D)^(*)(X times Z).
$
] #(sk.tag)("schwartz-kernel-theorem")

#proof[
We work with complex-valued test functions; for real scalars, complexify $T$, apply the construction below, and restrict to real test functions (uniqueness guarantees that the resulting kernel is real).

#paragraph_tab
Define the bilinear form $B(phi, f) := chevron.l T f, phi chevron.r$ on $cal(D)(X) times cal(D)(Z)$. For fixed $f$, $phi |-> chevron.l T f, phi chevron.r$ is continuous because $T f in cal(D)^(*)(X)$. For fixed $phi$, testing against $phi$ is continuous on $cal(D)^(*)(X)$ in the weak-$*$ topology, so $f |-> chevron.l T f, phi chevron.r$ is continuous on $cal(D)(Z)$ by continuity of $T$. Thus $B$ is separately continuous.

#paragraph_tab
*1. Uniqueness.* Suppose $K_(1), K_(2) in cal(D)^(*)(X times Z)$ both satisfy $chevron.l K, phi ⊗ f chevron.r = B(phi, f)$. Then the difference $u = K_(1) - K_(2)$ vanishes on all product test functions $phi ⊗ f$. By #(sk.ref)("tensor-product-density"), the algebraic tensor product $cal(D)(X) ⊗ cal(D)(Z)$ is dense in $cal(D)(X times Z)$, forcing $K_(1) = K_(2)$.

#paragraph_tab
*2. Local construction on relatively compact products.* Let $U subset X$ and $V subset Z$ be open subsets with compact closures $overline(U) subset X$ and $overline(V) subset Z$. Choose cutoffs $chi in cal(D)(X)$ and $eta in cal(D)(Z)$ equal to one on neighborhoods of $overline(U)$ and $overline(V)$, and set $K_(1) := op("supp") chi$, $K_(2) := op("supp") eta$. By #(sk.ref)("frechet-bilinear-joint-continuity"), $B$ is jointly continuous on $cal(D)_(K_(1))(X) times cal(D)_(K_(2))(Z)$:
$
  |B(phi, f)| <= C norm(phi)_(C^(p)) norm(f)_(C^(q)).
$
Choose cubes $Q_(x), Q_(z)$ containing $K_(1), K_(2)$ and Fourier modes $e_(j), h_(k)$ as in #(sk.ref)("tensor-product-density"). For $Psi in cal(D)(U times V)$, define
$
  Lambda_(U,V)(Psi) := sum_(j in bb(Z)^(m), k in bb(Z)^(n)) c_(j,k)(Psi) B(chi e_(j), eta h_(k)).
$
By the Leibniz rule, $norm(chi e_(j))_(C^(p)) <= C_(1) (1 + |j|)^(p)$ and $norm(eta h_(k))_(C^(q)) <= C_(2) (1 + |k|)^(q)$, so $|B(chi e_(j), eta h_(k))| <= C' (1 + |j|)^(p) (1 + |k|)^(q)$. Combining this with the rapid Fourier decay $|c_(j,k)(Psi)| <= C_(N) norm(Psi)_(C^(2N)) (1 + |j| + |k|)^(-2N)$ from #(sk.ref)("tensor-product-density"), the general term satisfies
#mannot-scope(m => [
  #block(breakable: false, above: 1.2em, below: 2.2em)[
  $
    \
    |c_(j,k)(Psi) B(chi e_(j), eta h_(k))|
    <= C'' bmark(norm(Psi)_(C^(2N)), tag: #(m.tag)("psi-sobolev"))
       mark((1 + |j| + |k|)^(-(2N - p - q)), tag: #(m.tag)("exponent-diff")).
    #annot((m.tag)("psi-sobolev"), pos: top + left, dx: -0.4em, dy: -0.55em, leader: true, leader-connect: "elbow")[smoothness order $2N$]
    #annot((m.tag)("exponent-diff"), pos: bottom, dy: 0.6em, leader: true, leader-connect: "elbow")[lattice exponent: $2N - p - q > m + n$]
    \
  $
  ]
], parent: sk, name: "step3-lattice-annot")

Choosing $2N > p + q + m + n$, the lattice sum converges absolutely, proving $|Lambda_(U,V)(Psi)| <= C_(U,V) norm(Psi)_(C^(2N))$. Thus $Lambda_(U,V) in cal(D)^(*)(U times V)$ is a well-defined distribution. On product test functions $phi ⊗ f in cal(D)(U) ⊗ cal(D)(V)$, the rectangular partial sums $S_(R) phi arrow.r phi$ and $S_(R) f arrow.r f$ converge in their respective Fréchet spaces; joint continuity yields
$
  Lambda_(U,V)(phi ⊗ f)
  = lim_(R -> infinity) B(S_(R) phi, S_(R) f)
  = B(phi, f).
$
By #(sk.ref)("tensor-product-density"), $Lambda_(U,V)$ is independent of the choice of cutoffs or cubes.

#paragraph_tab
*3. Global patching via exhaustion.* Choose increasing open exhaustions $(U_(ell))_(ell=1)^(infinity)$ of $X$ and $(V_(ell))_(ell=1)^(infinity)$ of $Z$ with compact inclusions $U_(ell) subset.eq.sq U_(ell+1)$ and $V_(ell) subset.eq.sq V_(ell+1)$. For $r >= ell$, both $Lambda_(r)$ and $Lambda_(ell)$ give $B(phi, f)$ on $cal(D)(U_(ell)) ⊗ cal(D)(V_(ell))$. By #(sk.ref)("tensor-product-density"), $Lambda_(r)|_(cal(D)(U_(ell) times V_(ell))) = Lambda_(ell)$. For any $Psi in cal(D)(X times Z)$, $op("supp") Psi subset.eq U_(ell) times V_(ell)$ for some $ell$. Defining
$
  chevron.l K, Psi chevron.r := Lambda_(ell)(Psi)
$
yields a well-defined, linear functional independent of $ell$. On every compact subset of $X times Z$, Step 2 bounds it by a $C^(2N_(ell))$ norm, so by the inductive limit topology of #(sk.ref)("inductive-limit-topology"), $K in cal(D)^(*)(X times Z)$. For any $phi in cal(D)(X)$ and $f in cal(D)(Z)$, choosing $ell$ large enough gives $chevron.l K, phi ⊗ f chevron.r = B(phi, f) = chevron.l T f, phi chevron.r$.

#paragraph_tab
*4. Operator recovery and isomorphism.* Conversely, let $K in cal(D)^(*)(X times Z)$. For each $f in cal(D)(Z)$, define $T f$ by $chevron.l T f, phi chevron.r := chevron.l K, phi ⊗ f chevron.r$. On compact sets $A subset X$ and $D subset Z$, distribution order $r$ gives
$
  |chevron.l T f, phi chevron.r|
  = |chevron.l K, phi ⊗ f chevron.r|
  <= C'_(A,D) norm(phi)_(C^(r)) norm(f)_(C^(r)).
$
For fixed $f$, this proves $T f in cal(D)^(*)(X)$. For fixed $phi$, it proves continuity of $f |-> chevron.l T f, phi chevron.r$ on each Fréchet space $cal(D)_(D)(Z)$, and hence by #(sk.ref)("inductive-limit-topology"), continuity of $T: cal(D)(Z) arrow.r cal(D)^(*)(X)$ into the weak-$*$ topology. The linear maps $T |-> K$ and $K |-> T$ are mutual inverses by #(sk.ref)("tensor-product-density") and the pairing identity, establishing the canonical isomorphism
$
  cal(L)(cal(D)(Z), cal(D)^(*)(X)) approx.eq cal(D)^(*)(X times Z).
$
]

#definition(title: "Schwartz kernel of a continuous linear operator")[
Let $X subset.eq bb(R)^(m)$ and $Z subset.eq bb(R)^(n)$ be open sets. For any continuous linear operator $T in cal(L)(cal(D)(Z), cal(D)^(*)(X))$, the unique distribution $K in cal(D)^(*)(X times Z)$ guaranteed by #(sk.ref)("schwartz-kernel-theorem") such that
$
  chevron.l T f, phi chevron.r = chevron.l K, phi ⊗ f chevron.r, quad forall phi in cal(D)(X), #h(1em) f in cal(D)(Z),
$
is called the *Schwartz kernel* (or *distributional kernel*) of $T$.
] #(sk.tag)("schwartz-kernel-definition")
])
