#import "../Styles/styles.typ": *
#import "figures/figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.3": *

== More general hyperbolic equations : energy estimates

#local-scope-annotations(s => [
  #paragraph-tab
  In this section, we derive estimates for a solution to a non-homogeneous hyperbolic equation of the form :
  $
    L u = f "in " Omega
  $ <first_condition_of_hypoerbolic_equations>
  where $L$ is given in local coordinates by :
  $
    L u = bmark(h^(j k) partial_j partial_k u, tag: #(s.tag)("square u")) + pmark(b^j (x) partial_j u + c(x) u, tag: #(s.tag)("X u"))

    #annot((s.tag)("square u"), dx: -5em)[$square_h u$]
    #annot((s.tag)("X u"), pos: top+ right, dx: 5em)[$X u$]
  $ #(s.tag)("local coordinate form of L")
  By definition, to say $L$ is hyperbolic is to say that $h^(j k)$ is a symmetric matrix of signature $(n,1)$, if $dim Omega=n+1$. One can then use the inverse matrix  $h_(j k)$ to define a Lorentz metric on $Omega$, and in view of the formula(@definition_of_Lorentizan_Laplacian_2), we can write #(s.ref)("local coordinate form of L") as :
  $
    L u = square_h u + X u quad "where " X:= b^j (x) partial_j + c(x)
  $ <second_condition_of_hypoerbolic_equations> 

  #paragraph-tab
  #highlighted()[Suppose $cal(O) in Omega$ is bounded by two surfaces $Sigma_2$ and $Sigma_1$, both spacelike.]#footnote[Remember it is similar to @spacelike_boundary_decomposition_visualization.] Specifically, we suppose that there is a smooth function on a neighborhood of $dash(cal(O))$, which in fact we denote by $t$.
  $
    t:= bmark(pi_p, tag: #(s.tag)("natural projection")) : underbrace(bb(R) times M, Omega) arrow.r bb(R)

    #annot((s.tag)("natural projection"))[natural projection]
  $
  , such that $d t$ is timelike, and set :
  $
    cal(O)(s) := dash(cal(O)) inter {t <= s}, quad Sigma_2(s) =  dash(cal(O)) inter rmark({ t=s }, tag: #(s.tag)("contour set"))

    #annot((s.tag)("contour set"), pos: top + right, dx: 2em, dy: -1.1em)[ ${s}times M$ ]
  $
  We suppose $cal(O)$ is swept out by $Sigma_2(s)$, $s_0 <= s <= s_1$, with $Sigma_2=Sigma_2(s_1)$. Also set :
  $
    Sigma^b_1 (s):= Sigma_1 inter { t<= s}
  $

  #figure(
    swept-hyperbolic-region-visualization(),
    caption: [The truncated swept region $cal(O)(s)$ with moving cap $Sigma_2(s)$ and boundary part $Sigma_1^b (s) subset Sigma_1$.]
  )
  
  #paragraph-tab
  Now, let's focus on @stress-energy_tensor_flux_identity, which is induced the wave equation condition($square u =0$). However $square u$ isn't zero in this section! It means that we can't determine the "integral of divergence term". #highlighted()[Fortunately, we can construct an inequality instead of the equation likely @stress-energy_tensor_flux_identity.] To re-formulate @stress-energy_tensor_flux_identity, we have to start from @stress-energy_tensor_applied_divergence_theorem. 
  #flowbox()[
    $
      integral_(cal(O)(s)) X d V &= integral_(cal(O)(s)) rmark(op("div") T Z d V)
      \
      &= integral_(Sigma_1^b (s)) E_(Z, nu_1) (d u) d S - integral_(Sigma_2 (s)) E_(Z, nu_1) ( d u ) d S #dots_space #footnote[by Applying @Stress-energy_tensor_and_energy_flux]
    $ 

    $arrow.b$


    $
      integral_(Sigma_2 (s)) E_(Z, nu_1) ( d u ) d S = integral_(Sigma_1^b (s)) E_(Z, nu_1) (d u) d S - integral_(cal(O)(s)) op("div") T Z d V #dots_space #footnote[The reason why we re-array the equation likely to #(s.ref)("integral what we want to estimate") is to control the "future", which $integral_(Sigma_2 (s))$]
    $ #(s.tag)("integral what we want to estimate")
  ]
  though at this point it is not physically meaningful in general to think of $T$ as the stress-energy tensor. Here $nu_1$ is the forward-pointing unit normal to $Sigma_1$, with respect to the Lorentz metric, and $nu_2$ is the normalization of $op("grad") t$, the vector field obtained from $d t$ via the Lorentz metric. We define $Z$ to be any timelike vector field and :
  $
    Z=nu_2
  $ #(s.tag)("Z=nu-2")

  #figure(
    stress-energy-normal-fields-visualization(),
    caption: [The normals $nu_1$ and $nu_2$, and the timelike multiplier choice $Z=nu_2$.]
  )

  #highlighted()[We no longer have $op("div") T Z=0$, but we an estimate this quantity], as follows. First,
  $
    op("div") T Z &= nabla_k (T^(j k) Z^j) = nabla_k (T^(j k) h _(j l)Z^l)
    \
    &= nabla_k T(j k) h_(j l) Z^l + T^(j k) cancel((nabla_k h_(j l)) , stroke: #(paint: red))Z^l + T^(j k)h_(j l) (nabla_k Z^l) #dots_space #footnote[By Levi-Civita connection(Torsion-free condition)]
    \
    &= nabla_k T^(j k) h _(j l) Z^l + T^(j k) h_(j l) nabla_k Z^(l)
    \
    &= underbrace(chevron.l op("div") T comma Z chevron.r_h, (1)) + underbrace(chevron.l T comma nabla Z chevron.r_h, (2)) #dots_space #footnote[By the definition of norm with metriic]
  $ #(s.tag)("target")
  
  #paragraph-tab
  Now, let's investigate $(2)$. By the definition of stress-energy tensor(@definition_of_stress-energy_tensor), the following relationship is true.
  #flowbox()[
    $
      T ~ d u times.o d u- frac(1,2) h^(-1) norm(d u)_h^2 ~ (nabla u )(nabla u)
    $

    $arrow.b$

    $
      | T^(j k) nabla_k Z^j | ~ | (nabla u ) (nabla u ) (nabla Z) |  <= | d u|^2 K_1 #dots_space #footnote[Remember that $norm(nabla u )=norm( d u)$ becuase of the musical isomorphism(tangent-cotangent isomorphism).]
    $ #(s.tag)("1.1")
    Where $K_1 := sup { nabla Z}$
  ]
  #highlighted()[#(s.ref)("1.1") isn't enough, becuase we don't know what $d u$ should be! Instead of using it, let's endeaver to transform it into a knwon quantity, which is energy-flux.] By @stress-energy_tensor_and_energy_flux_lemma, there exists some constant $K_2$ which is induced the following lemma.
  #lemma()[
    Let $Z$ is the vector field on the bounded open set $cal(O) subset Omega$, satisfied #(s.ref)("Z=nu-2"), and $E$ is energy flux satisfied @Stress-energy_tensor_and_energy_flux. Then there exists some constant which satisfied the following inequality :
    $
      |alpha|^2 <= K_2 E ( alpha ) quad "where " alpha in T^*_p cal(O), attach(p, tl: forall) in cal(O)
    $
  ] #(s.tag)("lemma 1")

  #proof()[
    Since we assumed that $E$ is satisfied @stress-energy_tensor_and_energy_flux_lemma and it is quadratic by its definition, #footnote[It is also due to @stress-energy_tensor_and_energy_flux_lemma. Since the energy flux is the same as the stress-energy tensor and the tensor is quadratic, so be it.] $E_p$ could be written as :
    $
      E_p = alpha^* A(p) alpha
      \
      lambda_1 (p), thin  dots.c thin , lambda_(n+1) (p) > 0
    $
    where $A(p)$ is a symmetric positive-definite matrix and $lambda_i$ is its eigenvalues.#footnote[The positivity of eigenvalues is the definition of positive-definitness.] Then, 
    #flowbox()[
      $
        E_p (alpha) >= alpha^* (min{lambda_i (p)}) alpha, quad attach(alpha, tl: forall) in T^*_p cal(O)
      $ 

      $arrow.b$


      $
        |alpha|^2 <= frac(1, lambda_(min) (p)) E_p 
      $ #(s.tag)("1.3")
    ]
    #(s.ref)("1.3") can be generalized for all $p in cal(O)$, becuase $cal(O)$ is bounded.
    $
      |alpha|^2 <= frac(1, c) E "where " c:= min{lambda_(min) (p)| attach(p, tl: forall) in cal(O)}
    $
    If we define $K_2:= 1/c$, proving the lemma is over.
  ]
  
  Due to #(s.ref)("lemma 1"), we can write :
  $
    |d u |^2 <= K_2 E_(Z,Z)(d u)
  $ #(s.tag)("relationship between |du|^2 and energy flux")
  and it induces :
  $
    |chevron.l T, nabla Z chevron.r_h| <= K_1 |d u|^2 &<= K_1 K_2 E_(Z, Z)( d u )
    \

    &<= K_3 E_(Z, Z)( d u )
  $ #(s.tag)("result of (2)")
  where $K_3 := K_1 K_2$.
  
  #paragraph-tab
  Now, it is time to investigate (1). By @divergence_free_of_stress-energy_tensor and @second_condition_of_hypoerbolic_equations, we can write :
  #flowbox()[
    $
      op("div") T &= (op("grad") u ) square u
      \
      &= (op("grad") u) ( f- X u)
    $

    $arrow.b$

    $
      h_(j l)T^(j k)=(nabla_l u ) square u 
    $

    $arrow.b$
    
    $
      nabla_k T^(j k) h _(j l) Z^l &= Z^l ( nabla_l u) square u
      \
      &= rmark(Z^l paren.l partial_l) u paren.r (f-X u) #dots_space #footnote[by @definition_of_covariant_derivative_of_scalar_function, $nabla_l u = partial_l u$] 
      \
      &= (rmark(Z) u)(f-X u) #dots_space #footnote[Because $Z= Z^l partial_l$]
    $ #(s.tag)("unpacking of (1)")
  ]
  To make the inequality let's take the absolute value to #(s.ref)("unpacking of (1)") for the mathematical convenience. Now let's investigate $|(Z u)f|$ first.
  $
    |(Z u) f| <=|Z u| |f| <= K_1 |d u| |f| &<= frac(k_1,2) |d u|^2 + frac(k_1,2)|f|^2 #dots_space #footnote[by using Young inequality]
    \
    & <= K_4 |d u|^2 +  K_4 |f|^2 #dots_space #footnote[by defining $K_4 := frac(K_1, 2)$]
    \
    & <= K_4 K_3 E_(Z,Z)(d u) + K_4 |f|^2 #dots_space #footnote[by #(s.ref)("result of (2)")]
  $ #(s.tag)("result of (1)-1")

  #paragraph-tab
  Remember $X$ is first-order. Thus schematically,
  $
    |X u|= | B^l nabla_l u + b u| <= pmark(K_5 |d u| + K_5^prime |u|)
  $
  for some constant $K_5, K_5^prime$. Then $|(Z u)(X u)|$ could be :
  $
    |(Z u)(X u)| &<=  K_1 |d u|pmark((K_5 |d u| + K_5^prime|u|))
    \
    &<= K_1 K_5 |d u|^2 + K_1 K_5^prime |d u| |u|
    \
    &<= K_6 |d u|^2 + bmark(K_6 |d u| |u|, tag: #(s.tag)("applying Young inequality")) #dots_space #footnote[$K_6:= max{K_1 K_5 , K_1 K_5^prime}$]
    \
    &<= K_6 |d u|^2 + bmark(frac(K_6 , 2) |d u|^2 + frac(K_6 , 2) |u|^2)
    \
    &= K_7 |d u|^2 + K_7 |u|^2 #dots_space #footnote[$K_7:= max{K_6,frac(3 ,2)K_6, frac(1, 2) K_6$}] \

    &<= K_7 K_3 E_(Z,Z)(d u)+ K_7 |u|^2 #dots_space #footnote[by applying #(s.ref)("result of (2)")]
    \
    &<= K_8 E_(Z,Z)(d u)+ K_8 |u|^2 #dots_space #footnote[$K_8:= max{K_7K_3, K_7}$]

    #annot((s.tag)("applying Young inequality"), pos: top+right, dx: 6em, dy: -1.5em)[apply Young inequality]
  $ #(s.tag)("result of (1)-2")

  #paragraph-tab
  By using both #(s.ref)("result of (1)-2"), #(s.ref)("result of (1)-1") and #(s.ref)("result of (2)"), we can conclude :
  $
    |op("div")T Z| & <= underbrace(K_3 E_(Z, Z)( d u ), (2)) + K_4 K_3 E_(Z,Z)(d u) + K_4 |f|^2 
    \
    &+ K_8 E_(Z,Z)(d u)+ K_8 |u|^2
    \
    & <= cal(K) E(Z, Z)(d u)+ cal(K)|u|^2+ cal(K)|f|^2
  $ #(s.tag)("final estimate of divTZ")

  #figure(
    table(
      columns: 3,
      align: horizon,
      [*Constant*], [*Definition or source*], [*Role in the estimate*],
      [$K_1$], [$sup_(cal(O)) norm(nabla Z)$], [Controls the multiplier derivative and $|Z u|$.],
      [$K_2$], [Energy-flux comparison from #(s.ref)("lemma 1")], [Converts $|d u|^2$ into $E_(Z,Z)(d u)$.],
      [$K_3$], [$K_1 K_2$], [Controls $|chevron.l T, nabla Z chevron.r_h|$.],
      [$K_4$], [$K_1 / 2$], [Young inequality constant for $|(Z u) f|$.],
      [$K_5, K_5^prime$], [Bounds for the first-order operator $X$], [Give $|X u| <= K_5 |d u| + K_5^prime |u|$.],
      [$K_6$], [$max {K_1 K_5, K_1 K_5^prime}$], [Collects the first $|(Z u)(X u)|$ bound.],
      [$K_7$], [$max {K_6, frac(3,2) K_6, frac(1,2) K_6}$], [Collects the Young inequality terms in $|d u|^2$ and $|u|^2$.],
      [$K_8$], [$max {K_7 K_3, K_7}$], [Converts the $X u$ contribution to energy plus $|u|^2$.],
      [$cal(K)$], [A dominant constant], [Absorbs all remaining constants in the final divergence estimate.]
    ),
    caption: [Constants used to pass from the local estimates to the final $cal(K)$ bound.]
  ) #(s.tag)("table of constant K")

  #note(title: [philosophy of #(s.ref)("final estimate of divTZ")])[
    all of constants mentioned at #(s.ref)("table of constant K") is under the philosophy that represents $op("div") T Z$ to easiest way.
  ]

  #paragraph-tab
  consequently, combining #(s.ref)("integral what we want to estimate") with #(s.ref)("final estimate of divTZ") yields :
  $
   integral_(Sigma_2 (s)) E_(Z, nu_1) ( d u ) d S &= integral_(Sigma_1^b (s)) E_(Z, nu_1) (d u) d S - integral_(cal(O)(s)) op("div") T Z d V
   \
   &<= integral_(Sigma_1^b (s)) E_(Z, nu_1) (d u) d S + integral_(cal(O)(s)) |(op("div") T Z)| d V
   \
   &<= integral_(Sigma_1^b (s)) E_(Z, nu_1) (d u) d S + cal(K) integral_(cal(O)(s))  E(Z, Z)(d u)+ rmark(|u|^2, tag: #(s.tag)("integrad what we want to estimate"))+ |f|^2 d V

   #annot((s.tag)("integrad what we want to estimate"))[want to estimate]
  $ #(s.tag)("first integral estimation")

  #paragraph-tab
  Suppose that $u$ satisfies the following initial conditions on $Sigma_1$ :
  $
    u=g, quad d u = omega "on " Sigma_1
  $
  We want to estimate the left side of #(s.ref)("first integral estimation") in terms of $f, g$ and $omega$. Our first goal will be to deive a variant of #(s.ref)("first integral estimation") #highlighted()[without the $|u|^2$ term.] Any easy consequence of the fundamental theorem of calculus, Young inequality, and @stress-energy_tensor_and_energy_flux_lemma gives :
  #flowbox()[
    Let consider the simplified model $cal(O)(s)=[0,s] times Sigma_1$. 
    
    Firstly, the fundamental theorem of Calculus gives :
    $
      u(t,x) &-u_0 = integral_0^s partial_tau u(tau, x) d tau
      \
      u(t,x) &= u_0 + integral_0^s partial_tau u(tau, x) d tau
      \
      &= g(x) + integral_0^s partial_tau u(tau, x) d tau
    $

    $arrow.b$

    Second, apply Young's inequality after $(a+b)^2=a^2+2a b +b^2$
    $
      norm(u)^2 &= norm(g(x) + integral_0^s partial_tau u(tau, x) d tau)^2
      \
      &= norm(g)^2+2 chevron.l g comma  integral_0^s partial_tau u(tau, x) d tau chevron.r + norm(integral_0^s partial_tau u(tau, x) d tau)^2
      \
      &<= 2norm(g)^2+ 2norm(integral_0^s partial_tau u(tau, x) d tau)^2 #dots_space #footnote[By applying Young's inequality]
      \
      &<= 2 norm(g)^2+ 2 integral_0^s norm(partial_tau u(tau, x))^2 d tau 
    $ #(s.tag)("second")

    $arrow.b$

    Third, integrate #(s.ref)("second") over $cal(O)(s)$
    $
     integral_(cal(O)(s)) norm(u)^2 d V &<= 2 integral_(cal(O)(s))  norm(g)^2 d V+ 2 integral_(cal(O)(s)) norm(partial_tau u)^2 d V
     \
     &<= 2 integral_(Sigma^b_1 (s)) norm(g)^2 d S + 2 integral_(cal(O)(s)) norm(partial_tau u)^2 d V
     \
     &<= 2 integral_(Sigma^b_1 (s)) norm(g)^2 d S+ 2 K_2 integral_(cal(O)(s)) E_(Z,Z)(d u) d V #dots_space #footnote[by applying #(s.ref)("relationship between |du|^2 and energy flux")]
    $

    $arrow.b$

    $
      therefore integral_(cal(O)(s)) norm(u)^2 d V &<= C integral_(Sigma^b_1 (s)) norm(g)^2 d S + C integral_(cal(O)(s)) E_(Z,Z)(d u) d V #dots_space #footnote[where $C:= max{2, 2 K_2}.$]
    $ #(s.tag)("second integral estimate")
  ]
  #(s.ref)("second integral estimate") can be applied to #(s.ref)("first integral estimation").
  
  #paragraph-tab
  At this point, it is convenient to set :
  $
    E(s):= integral_(cal(O)(s)) E_(Z,Z)(d u) thin d V
  $ #(s.tag)("definition of energy")
  After long and hard arguments, now we reach a final goal of the current section. The goal of this section is estimates the "internal energy($E(s)$)" by using what we already knew#footnote[$g, u$ on the inital hyper-surface $Sigma_1$ and the given $f$] when the system is non-homogeneous hyperbolic equation(@first_condition_of_hypoerbolic_equations) Since the energy($E(s)$) is came from $u$ and $u$ is deriven from @first_condition_of_hypoerbolic_equations which is differential equations, it is effective to approach $E(s)$ from an 'Ordinary Differential Equation' perspective. First of all, let's compute $frac(d E, d s)$. picking some coordinates $(tau, x^1, dots.c y^n)$, the volumne form is :
  #flowbox()[
    $
      d V_h = a(tau,x) d t thin d S_tau #dots_space #footnote[where $d S_t$ is a volumne form on $Sigma_tau$, which is also the spacelike slice $Sigma_tau := {tau = "constant"}$.]
    $

    $arrow.b$
    
    The coefficients of volumne forms are :
    $
      cases(
        d S_t = sqrt(op("det") gamma_(a b)) thin d x^1 and dots.c and d x^n #dots_space #footnote[where $gamma_(a b):= h(partial_(y^a), partial_(y^b)$],
        d V_h = sqrt(op("det") h_(alpha beta)) thin d t d x^1 and dots.c and d x^n
      )
    $

    $arrow.b$
    $
      a(tau,x)& = frac(sqrt(op("det") h_(alpha beta)),sqrt(op("det") gamma_(a b)))
      \
      therefore d V_h &= frac(sqrt(op("det") h_(alpha beta)),sqrt(op("det") gamma_(a b))) d t thin d S_tau
    $ #(s.tag)("Volumne form")
  ]
  By applying the fundamental theorem of Calculus, #(s.ref)("definition of energy") will be in local coordiates :
 #flowbox()[
    Use #(s.ref)("Volumne form").
    $
      E(s) = integral_(cal(O)(s)) E_(Z,Z) (d u) d V = integral_(s_0)^s integral_(Sigma_2 (tau)) frac(sqrt(op("det") h_(alpha beta)),sqrt(op("det") gamma_(a b))) E_(Z,Z)(d u) d S_tau d tau
    $

    $arrow.b$

    Apply the fundamental theorem of Calculus.
    $
      frac(d E, d s)= integral_(Sigma_2 (s)) frac(sqrt(op("det") h_(alpha beta)),sqrt(op("det") gamma_(a b))) thin E_(Z,Z)( d u) thin d S
    $ #(s.tag)("derivative of E to s")

    $arrow.b$

    $
      frac(d E, d s) <= kappa integral_(Sigma_2 (s)) thin E_(Z,Z)( d u) thin d S #dots_space #footnote[where $kappa:= op("sup")(frac(sqrt(op("det") h_(alpha beta)),sqrt(op("det") gamma_(a b))))$]
    $ #(s.tag)("inequality of derivative of E to s")
 ]
 Hence, by applying #(s.ref)("first integral estimation") and #(s.ref)("second integral estimate") to #(s.ref)("inequality of derivative of E to s"), we have :
 $
   frac(d E, d s) &<= kappa[integral_(Sigma_1^b (s)) E_(Z, nu_1) (d u) d S 
   \
   &+ cal(K) 
    shell.l 
      integral_(cal(O)(s)) bmark(E(Z, Z)(d u))+ |f|^2 d V
      \
      &+ C integral_(Sigma^b_1 (s)) norm(g)^2 d S + C bmark(integral_(cal(O)(s)) E_(Z,Z)(d u)) thin d V 
    shell.r
   ]
   \
   & <= frak(C) bmark(E(s)) + cal(F)(s), quad frak(C):= max{kappa, kappa cal(K), kappa cal(K) C, kappa cal(K)(1+C) } #dots_space #footnote[The reason why we made this form is to use Gronwell ineqaulity. It doesn't look like the common integral-form Gronwall inequality($E(S)<= A+ c integral_(s_0)^s E(r) d r$). Instead, it is the differential-form version : $E'(s)<= frak(C) E(s) + cal(F)(s)$]
 $ #(s.tag)("differental inequality")
 where 
 $
   cal(F)(s):= frak(C) integral_(Sigma_1^b (s)) E_(Z,Z)(omega)+ |g|^2 d S + frak(C) integral_(cal(O)(s)) |f|^2 d V
 $

 Can we make #(s.ref)("differental inequality") to be ordered that $E(s)$ moves to one side and $cal(F)(s)$ moves to another side?
 $
   frac(d, d s)( e^(-frak(C)s) E(s)) <= e^(-frak(C)s) cal(F)(s)
 $
 and since $E(s_0)=0$, we finally have :
 $
    e^(-frak(C)s) E(s) &<= integral^s_(s_0) e^(-frak(C)r) cal(F)(r) d r
    \
    E(s) &<= integral^s_(s_0) e^(frak(C)(s-r)) cal(F)(r) d r
 $

 #paragraph-tab
 The last inequality has a useful convolution interpretation. Define the causal Gronwall kernel
 $
   G(t):= e^(frak(C)t) 1_(t >= 0).
 $
 Then
 $
   E(s) <= integral_(s_0)^s G(s-r) cal(F)(r) d r = (G * cal(F))(s)
 $
 if we extend $cal(F)(r)$ by zero for $r<s_0$. In this view, each past forcing value $cal(F)(r)$ contributes to the energy at time $s$, but it is weighted by the factor $G(s-r)$. The estimate therefore says that the energy is controlled by a causal memory of the data and forcing, not by the instantaneous value of $cal(F)$ alone.

 #figure(
   gronwall-convolution-visualization(),
   caption: [The final Gronwall estimate as a causal convolution of the forcing history with the exponential propagation kernel.]
 )

 #note(title: [What the convolution perspective gives])[
   The convolution form separates two roles. The term $cal(F)(r)$ records how much boundary data and interior forcing are injected at time $r$, while $G(s-r)$ records how strongly that injection can affect the later slice $s$. Thus the estimate is stable under superposition of forcing histories: if $cal(F)=cal(F)_1+cal(F)_2$, then the right side splits as $(G*cal(F)_1)(s)+(G*cal(F)_2)(s)$. It also clarifies the stability goal of energy estimates: to bound the solution, it is enough to control the forcing history in an integral norm weighted by the Gronwall kernel.
 ]

])
