#import "../Styles/styles.typ": *
#import "figures.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.1": *

== The Laplace Operator on a Riemannian Manifold

=== Motivation

#paragraph_tab
The Laplace operator is one of the most fundamental second-order differential operators in geometry and physics. On a Riemannian manifold $(M, g)$, it generalizes the classical Laplacian from Euclidean space. To understand its structure, we first examine how the identity relating the second-order derivative to the first-order differential arises naturally in the one-dimensional case.


#paragraph_tab
In one dimension, the relationship between the second derivative and the product of first derivatives is a direct consequence of the Fundamental Theorem of Calculus (specifically, integration by parts). Consider smooth functions $u, v: [a, b] arrow.r RR$ where $v$ is a test function that vanishes at the boundaries ($v(a) = v(b) = 0$).

#flowbox[
$
integral_a^b -u''(x) v(x) d x &= markul([-u'(x)v(x)]_a^b, tag: #<ftc_boundary_term>, color: #red) + integral_a^b u'(x) v'(x) d x \
&= 0 + integral_a^b u'(x) v'(x) d x
$ <1D_example_of_laplacian>
#annot(<ftc_boundary_term>, pos: top, dy: -0.5em)[vanishes as $v(a)=v(b)=0$]
]

#paragraph_tab
Now, let's think about $L^2$ inner products. To use it, let's expand $u$ and $v$ as complex plane. Then @1D_example_of_laplacian can be : 
#flowbox[
  $
    integral_a^b -u''(x) dash(v(x)) d x &= cancel(0) + integral_a^b u'(x) dash(u(x)) prime dx 
  $

  $arrow.b$

  $ (-u'', v) = (u' comma  v') $ <beyond_1D_example_of_laplacian>
] 

#paragraph_tab
Furthermore, let's approach @beyond_1D_example_of_laplacian from the perspective of the manifolds theory. The right hand side can be abstract to :
$
  (u prime comma v prime) arrow.r (d u comma d v)
$
and :
$
  u comma v in bb(C)_0 ^ infinity (M)
$
because the first derivative is a coefficient of differential. Then how about the second derivative? We already know that the Hessian matrix describes the second derivaitve of multi-variable function. Let's use it, so  make it be abstract to use in manifold theory.

=== Hessian and Laplacian
#paragraph_tab
To investigate the Hessian operator, let's consider the basic. Let $f in bb(C)^infinity$ and $X comma Y in frak(X) (M)$. Then we can define Hessian which is strictly a type $(0,2)$ tensor field.
#definition[
  Let $f in bb(C)^infinity$. Then the Hessian is : 
  $
    op("Hess") f := nabla shell.l nabla f shell.r
  $
]

Since $nabla f = d f$ by the definition of differential, we can write :
$
  op("Hess") f &= nabla shell.l nabla f shell.r
  \
  &= nabla (d f) #dots_space #footnote[By the definition of differential. See chapter 3.2 of @Manifolds]
$<modeified_definition_of_1_form_Hessian>
We already know that the total covariant derivative is just the same as covariant derivative which omits the input that is arbitrary vector field. Thus let's define the arbitrary vector fields $X comma Y in frak(X)(M)$, and put them to @modeified_definition_of_1_form_Hessian.
$
  ( nabla_X d f ) (Y) = X shell.l Y (f) shell.r - shell.l nabla_X Y shell.r (f) #dots_space #footnote[by the product rule of covariant derivative]
$ 
Now, i add additional assumption that $X:= frac(partial , partial x_i)$ and $Y:= frac(partial , partial x_j)$i. Then we have :
$
   op("Hess") f (X comma Y) &= op("Hess") f shell.l frac(partial , partial x_i) comma frac(partial , partial x_j) shell.r
   \
   &= frac(partial , partial x_i) shell.l frac(partial f, partial x_j) shell.r - Gamma_(i j) ^k frac(partial f ,partial x_k) #dots_space #footnote[by applying product rule and definition of christoffel symbol @definition_of_christoffel_symbol]
$

#paragraph_tab
Then how about vector field? If $Z$ is a vector field, then $nabla Z$ is a vector field if type $(1,1$. Hence it makes sense to consider the tensor field $nabla (nabla Z)$ which is type $(1,2)$.

#definition[
  Let $X,Y$ and $Z$ are  vector fields. for some 1-form covector $alpha$, The Hessian of $Z$ is :
  $
    shell.l nabla^2 _(shell.l X comma Y shell.r) Z  shell.r (alpha) := shell.l nabla nabla Z shell.r (X comma Y comma alpha)
  $
]

#paragraph_tab
Now, let's consider the Laplacian operator. The Laplacian is a second-order differential operator that is defined on a manifold. It is a symmetric bilinear form on the tangent bundle of the manifold. It is also a linear operator on the cotangent bundle.

#definition[
  Let $M$ be a smooth manifold and $u in bb(C)^infinity$. Then the Laplacian operator is defined as :
  $
    Delta u:= op("div") op("grad") u
  $
]
The laplacian is very closely related to Hessian.
#special_lemma[
  Let's define $u in bb(C)^infinity(M)$ Then we can define Hessian which is strictly a type $(0,2)$ tensor field.
  $
    Delta u = op("Tr")_g op("Hess") u
  $ <relationship_of_laplacian_and_hessian>
] <specle_lemma_relationship_of_laplacian_and_hessian>
#proof[
 First of all, let's unpack the LHS and RHS of @relationship_of_laplacian_and_hessian, because @relationship_of_laplacian_and_hessian is too abstract!
  $
    op("div") op("grad") u =markrect( g^(j k), tag: #<Riemannian_trace>, color: #red) markrect(nabla_i nabla_k, tag:#<using_definition_of_Hessian> , color: #blue) u #dots_space #footnote[pick the standard coordinates $partial_i$ and $partial_k$. Using shorthand representation, $nabla_i nabla_k =nabla_(partial_i) nabla_(partial_k)$]
  $ <unpacked_relationship_of_laplacian_and_hessian>
  #annot(<Riemannian_trace>, pos: top, dy: -1em)[By definition of Riemannian trace]
  #annot(<using_definition_of_Hessian>, pos:  top+right, dy: -1em, dx: 3.5em)[using definition of Hessian]
  Thus, it is sufficient to prove that the LHS is the same as RHS. To show it, let's investigate $op("grad") u$ first.

  $
    op("grad") u &= g^(j k) (d u) #dots_space #footnote[By definition of gradient]
    \
    &= g^(j k) shell.l nabla_k u shell.r #dots_space #footnote[By definition of differential, $nabla_k u = d u$]
  $ <grad_u_laplacian_on_Riemannian_manifold>
  Now, apply the divergence to @grad_u_laplacian_on_Riemannian_manifold. By using @divergence_and_semi_colon, and applying @semi_colon_concention_and_covariant_derivative to the semi-colon notation, we can get :

 //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  $
    Delta u &= [ mark(nabla_i, tag: #<nabla>) ( rmark(g^(j k), tag: #<g>) bmark(nabla_k u, tag: #<u>) ) ]^i
    \
    &= [ cancel(nabla_i g^(j k) nabla_k u) + g^(j k) (nabla_i nabla_k u) ]^i
    #dots_space #footnote[By applying product rule(@basic_properties_of_connection)]
    \
    &= [g^(j k) (nabla_i nabla_k u)]^i  #dots_space #footnote[By the fundamental theorem of Reimannian geometry, $nabla$ is compatible with $g$.]
    \
    &= g^(j k) (nabla_i nabla_k u) #dots_space #footnote[Since $i$ is dummy index which means the summation is omitted. In additon, as considering that the dummy index is essentially picked arbitrarily, we can naturally delete the dummy index $i$!]
  $

  #annot-cetz(
    (<nabla>, <g>, <u>),
    cetz,
    {
      import cetz.draw: *
      set-style(mark: (end: "straight"))
      
      // nabla_i가 g^{jk}에 작용하는 항 (결과적으로 0이 됨)
      bezier-through("nabla.north", (rel: (x: 0.3, y: 0.5)), "g.north", stroke: red)
      
      // nabla_i가 nabla_k u에 작용하는 항
      bezier-through("nabla.south", (rel: (x: 0.8, y: -0.2)), "u.south", stroke: blue)
    },
  )
 //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  that is exactly the same as the RHS of  @unpacked_relationship_of_laplacian_and_hessian, which proves the special lemma.
]

#paragraph_tab
Using @specle_lemma_relationship_of_laplacian_and_hessian, we know that $Delta u = op("Hess")(u)$ when $op("dim")(M)=1$. Thus we can think the @beyond_1D_example_of_laplacian is the same as :
$
  -(Delta u comma v)=(d u comma d v)
$ <Laplacian_identity_1-D>
In the situation that we investigate the Laplacian, now the following question naturally occurs :
#emphasis()[
  is @beyond_1D_example_of_laplacian always true, regardless of the dimension of $M$?
]
To answer this question, we need to come back and deeply understand the where @beyond_1D_example_of_laplacian came from. it came from the fundamental principle of Calculus, as thinking it more abstractly, $L$-norm! Therefore we need to deeply understand $L$-norm.

=== Local inner product and global inner product

#paragraph_tab
Remember that the "algebraic field structure" is needed to exist norm, because we just know the norm of vector, not others. Thankfully, the manifolds have space sturcture, but it lives in the local. Thus it is better to define norm at each local and combine them to define global norm, than defining the new norm which acts on global but doesn't correspond to "the traditonal norm", which  we already defined.

#paragraph_tab
Now, let's define the local $L$-2-norm. Since this norm is defined on local, we can't use integral as likely as $L$-2 nrom that we already knew.#footnote[the local if manifold is fixed at some point, so that we can use integral on manifold!] Thus let's think only using "conjugate computation part" of $L$-2 nrom! First of all, let's consider $chevron.l u comma v chevron.r$ where $u comma v in bb(C)^infinity$. In this case, we can define the local norm simiar to what we already know :
$
  chevron.l u comma v chevron.r_p &= u dash(v) comma  forall p in M
$
However, as seeing @Laplacian_identity_1-D, what we really want to know is $(d u comma d v)$! So, how can we define $chevron.l u comma d v chevron.r_p$? it is understandable to start :
$
  chevron.l d u,d v chevron.r_p & = g_p shell.l (d u)^sharp comma (d v)^sharp shell.r 
$
Remember that $(d x^j)^sharp=g^(j m) frac(partial , partial x^m)$ by definition of $sharp$ operator. Thus apply it to $(d u)^sharp$ and $(d v )^sharp$.

$
  chevron.l d u,d v chevron.r_p & = g_p shell.l (d u)^sharp comma (d v)^sharp shell.r 
  \
  &= g_p ( bmark(g^(j m) partial_j u) frac(partial , partial x^m) comma bmark(g^(k l) partial_k markrect(dash(v), color: #red, tag: #<conjugate_part>)) frac(partial , partial x^l))
  \
  &=(partial_j u) g^(j m) (partial_k dash(v)) g^(k l) underbrace( g_p (frac(partial , partial x^m) comma frac(partial , partial x^l)), =g_(m l)) #dots_space #footnote[$g^(j m) comma partial_j u comma partial_k u$ and $g^(k l)$ can escape to the metric.]
  \
  &= (partial_j u ) (partial_k dash(v)) g^(k l) delta^j _l &  "by" g^(j m) g_(m l)
  \
  &= (partial_j u ) (partial_k dash(v)) g^(k j)
$ #annot(<conjugate_part>, pos: top, dy: -2em, dx: 1em)[It is the "conjegate part"!]
Therefore, we can define the local $L$-2 norm of differential as :
$
  chevron.l d u comma d v chevron.r_p &= g^(j k) (partial_j u) (partial_k dash(v)) ,  forall p in M
$
#paragraph_tab
Now it is time to define the global $L$-2 norm. What we want for global norm is to combine all of the local norm. Thus the integration on manifold should appear. In additon, since we don't want to be dependent to path, the volume form is also needed.

#definition[
  Let $M$ be a smooth manifold and $u , v in bb(C)^infinity$. Then the global $L$-2  norm of $d u$ and $d v$ is :
  $
    (d u comma d v) := integral chevron.l d u comma d v chevron.r d V_g
  $
  where $V_g$ is the volume form of $M$.
] <L-2_norm_of_1-form>

#note(title: "the local doesn't mean rigorously local")[
  At the previous definition, we have to be careful that the local norm is not rigorously local. It is true that the local norm is local, but it is not rigorously local. It is only vaild to exactly one single point, not on the entire local area. Due to this reason, the following equation is true.
  $
   chevron.l f op("grad") u comma op("grad") v chevron.r_p = f chevron.l  u comma d v chevron.r_p
  $ where $f,u,v in bb(C)^infinity$ and $p in M$.
]

=== Green First Identity <subsection_Greens_First_Identity>

#paragraph_tab
Now, let's prove whether @Laplacian_identity_1-D is true for high dimention or not. Firstly, let's start form  @L-2_norm_of_1-form. Since @L-2_norm_of_1-form is too abstract to investigate, we have to make it to be more specific.
#flowbox[
  $
    (d u comma d v) &= integral chevron.l d u comma d v chevron.r d V_g
    \
    &= integral g^(j k) (partial_j u) (partial_k dash(v)) d V_g
    \
    &= integral g^(j k) (partial_j u) (partial_k dash(v)) sqrt(op("det") g) thin  dx #dots_space #footnote[by proposition 15.31 of @Manifolds]
  $ <investigate_L2_norm_of_1-form>
]
See @investigate_L2_norm_of_1-form. At high-school level, we often used integrating by part when the intetegrand is composed to the some derivatives and multiplication. However, we can't directly apply the integrating by part! Instead, we have to use divergence theorem!#footnote[We know that the divergence theorem is more abstract version of integrating by part. See my note organzing @Manifolds] Let $W^k := dash(v) g^(j k) (partial_j u)$. Since $u =0$ when $u$ on $partial M$, the divergergence theorem gives :
#flowbox()[
  $
    integral ( nabla_k W)^k d V_g =0 #dots_space #footnote[As consdiering Einstein summation convention for k, $(nabla_k W) ^k$ is $sum W_(; k) ^k$ and will be $op("div") W$ by @divergence_and_semi_colon]
  $

  $arrow.b$

  substitute $W^k = dash(v) g^(j k) (partial_j u)$ :
  $
    integral nabla_k [dash(v) g^(j k) (partial_j u)] d V_g =0
  $

  $arrow.b$

  apply the product rule of covariant derivatives :
  $
    integral [(nabla_k dash(v)) g^(j k) (partial_j u) + rmark(dash(v) nabla_k (g^(j k) partial_j u))] d V_g =0
  $
]
As focusing $dash(v) nabla_k (g^(j k) partial_j u)$ and applying the product rule again, we get : 
#flowbox[
 $
   rmark(dash(v) nabla_k (g^(j k) partial_j u)) &= dash(v)[cancel( ( nabla_k g^(j k) partial_j u)) + g^(j k) nabla_k partial_j u]
   \
   &= dash(v)]g^(j k) (nabla_k partial_j u)] #dots_space #footnote[by the fundamental theorem of Riemmanian geometry, $nabla$ is compatible with $g$.] 
   \
   &= dash(v)[Delta u] #dots_space #footnote[by @specle_lemma_relationship_of_laplacian_and_hessian]
 $

]
Therefore, we have :
$
  integral_M underbrace((nabla_k dash(v)), =partial_k dash(v)) g^(j k) (partial_j u)   d V_g = - integral dash(v) Delta u d V_g
$

Note that the LHS is the same as $(d u comma d v)$ and the RHS is $(Delta u ,dash(v))$ Then we finally have :
$
  therefore (d u comma d v) = -(Delta u ,dash(v))
$
#paragraph_tab
Now, let's develop the Green's First Identity. we already know that there is the isomorphsim between the gradient and the differential. Thanks to the existence of cotangent-tanget isomorphsim, we can induce :
$
  (d u comma d v) := g( (d u)^sharp comma (d v)^sharp)
$
where it lives in the cotangent bundle. Since there is the isomorphism which is  $(d u comma d v) mapsto (op("grad") u comma op("grad") v)$, we finally construct the Green first identity :
#definition(title: "Green's First Identity")[
  Let $M$ be a smooth manifold and $u , v in bb(C)_0 ^infinity (M)$. Then the following equation is called to Green's First Identity :
  $
    -(Delta u ,dash(v))=(d u comma d v) = (op("grad") u comma op("grad") v)
  $
]<Greens_First_Identity>

=== Green's Identities with boundaries <Greens_Identities_with_boundaries>

#paragraph_tab
Recall that @Greens_First_Identity is just vaild when $u comma v in bb(C)_0 ^infinity (M)$. Let's assume more general case, assume that $u comma v in bb(C)^infinity (M)$. Since there are no more zero on $partial M$, we have to carefully investigate the boundaries. To do this let's introduce outward normal vector $n$, and normal derivative.

#definition(title: "Outward Normal Vector")[
  Let $(M, g)$ be a smooth Riemannian manifold with boundary. For each boundary point $p in partial M$, the outward unit normal vector is the unique vector $nu_p in T_p M$ satisfying the following conditions:
  + $g_p (nu_p, Y) = 0 quad "for every" quad Y in T_p (partial M)$
  + $g_p (nu_p, nu_p) = 1$
  + $nu_p$ points away from the interior of $M$.
] <definition_of_outward_normal_vector>
Equivalently, the outward unit normal vector field $nu$ along $partial M$ is a smooth vector field

  $
  nu : partial M -> T M
  $

  such that

  $
  nu_p in T_p M,
  quad
  nu_p perp T_p (partial M),
  quad
  norm(nu_p)_g = 1,
  $
  and $nu_p$ is chosen with the outward orientation. Moreover, we can understand the outward normal vector as the Local coordinate approach. Near a boundary point, we can choose coordinates :
  $
    (x^1, x^2, dots, x^(n-1), x^n)
  $
  such that $M={x^n =0}$ and $partial M = {x^n = 0}$. Then :
  $
    T_p M = op("span") {frac(partial, partial x^1), dots.h.c frac(partial, partial x^n)}
  $
  while 
  $
    T_p (partial M)= op("span") {frac(partial, partial x^1), dots.h.c frac(partial, partial x^(n-1))}
  $
  Thus, the outward normal vector is : 
  $
      frac(partial, partial x^n) quad "or" quad
      -frac(partial, partial x^n)
  $

#definition(title: "Normal derivative")[
  Let $M$ be a smooth manifold,  $n$ is outward normal vector and $u in bb(C)^infinity (M)$. Then we define the normal derivative :
  $
    frac(partial u , partial n) := nabla_n u
  $
  If we apply @definition_of_covariant_derivative_of_scalar_function, then we have :
  $
    nabla_n u &= n (u)
    \
    &= d u (n) #dots_space #footnote[By definition of differential]
  $
] <definition_of_normal_derivative>

 #special_lemma(title: "normal derivaitve on Riemannian manifold")[
   Let $M$ be a smooth manifold and $u in bb(C)^infinity (M)$, $n$ is the outward normal vector. Then :
   $
     frac( partial u , partial n) = <op("grad") u, n>
   $
 ]

 #proof[
  By computing $d u(n)$ from @definition_of_normal_derivative, the following equation is induced :
  $
    d u(n) = (partial_k u) n_k
  $ <induced_equation_of_outward_normal_vector>
  Similarly, computing $chevron.l op("grad") u comma n chevron.r_g$ directly, we get the result.
  $
    chevron.l op("grad") u comma n chevron.r_g &= g_(j k) (op("grad") u)_i n_k
    \
    &= underbrace(cancel(g_(j k) shell.l g^(i j)), delta_k^j)  partial_j u shell.r n_k #dots_space #footnote[by the cotangent-tangent isomorphsim]
    \
    &= (partial_k u ) n_k
    \
    &= d u(n) #dots_space #footnote[by @induced_equation_of_outward_normal_vector]
  $ 
 ]

#paragraph_tab
In @Greens_Identities_with_boundaries, we treat somethings on the bundaries of manifolds. As we can guess from the previous discussion(@subsection_Greens_First_Identity), the integral on the boundary will appear and the divergence theorem will be useful. Hence introducing the following lemma is helpful.
#special_lemma(title: "The Product Rule of Riemmanian divergence")[
  Let $M$ be a smooth Riemannian manifold and $ Y in frak(X)(M)$, $f in bb(C)^infinity (M)$. Then :
  $
    op("div") (f Y) = f op("div") Y + g( op("grad") f comma Y)
  $
]

#proof()[We start from the definition of divergence. Define $X:= f Y$. Then we have :
  $
   cal(L)_X d V_g =(op("div") X) d V_g
  $
  By Cartan's magic formula, we have :
  $
  cal(L)_X d V_g &= X corner.r.b overbrace(cancel(d(d V_g), stroke: #(paint: red)), d^2=0) + d(X corner.r.b d V_g)
  \
  &= d(X corner.r.b d V_g)
  $
  Now, replace $X$ to $f Y$.
  $
    cal(L)_X d V_g &= (op("div") (f Y)) d V_g #dots_space #footnote[by definition of divergence]
    \
    &= d((f Y) corner.r.b d V_g)
    \
    &= d[f(Y corner.r.b d V_g)] #dots_space #footnote[by the linearity of interior multiplication]
  $

  #paragraph_tab
  Since $f$ is the scalar function, we can use a wedge product from another point of view.
  $
    d[f (Y corner.r.b d V_g)] = d[f and (Y corner.r.b d V_g)]
  $
  Then we get the following equation by using proposition 14.23(b) of @Manifolds.
  $
    markrect(d[f and (Y corner.r.b d V_g)], color: #red, tag: #<LHS_using_proposition_14.23_Riemannian_divergence>) &= d f and (Y corner.r.b d V_g) + markrect(f and d(Y corner.r.b d V_g),color: #blue, tag: #<RHS_using_proposition_14.23_Riemannian_divergence>)

    #annot(<LHS_using_proposition_14.23_Riemannian_divergence>, pos: bottom)[$=d [f and Y corner.r.b d V_g)]=op("div") (f Y) d V_g$]
    #annot(<RHS_using_proposition_14.23_Riemannian_divergence>, pos: top+right)[The sign of this term is positive because $f$ is 0-form]
    #annot(<RHS_using_proposition_14.23_Riemannian_divergence>, pos: bottom+right, dx: 2em)[As using the definition of divergence, \ $f(op("div") Y) d V_g$]
  $
  Therefore, it is sufficient to show that $d f and (Y corner.r.b d V_g)=g(op("grad") f, Y)$

  #paragraph_tab
  For any 1-form $alpha$ any the vector field $Y$, and any top-degree form $omega$, the following strict algebraic identity holds :
  $
  (alpha and (Y corner.r.b omega)) = rmark(alpha(Y) omega) #dots_space #footnote[When feeding $Y$ into $d f$, the result $d f(Y)$ is simply the directional derivative of the function $f$ along the vector field $Y$.]
  $ <identity_of_1-form_and_volume_form>
  The volumne form is an $n$-form, In our local basis, it is written as :
  $
  Omega = dx^1 and dx^2 and dots and dx^n
  $
  also, 
  $
    Y= sum_(i=1)^n Y^i frac(partial, partial x^i)
  $
  and,
  $
    alpha = sum_(j=1)^n alpha_j dx^j #dots_space #footnote[where $alpha$ is a 1-form.]
  $
  Now, let's directly compute the interior multiplication($Y corner.r.b Omega$) which is RHS of @identity_of_1-form_and_volume_form.
  $
  Y corner.r.b Omega = sum^n_(i=1) (-1)^(i-1) Y^i dx^1 and dots and overbrace(bmark(hat(d x)^i), frac(partial x^i, partial x^j)=0) and dots and dx^n
  $ <direct_computation_of_interior_multiplication_of_identity_of_1-form_and_volume_form>
  where $hat(d x)^i$ means that $d x^i$ is omitted. Similar to @direct_computation_of_interior_multiplication_of_identity_of_1-form_and_volume_form, let's directly compute RHS of @identity_of_1-form_and_volume_form.
  $
    alpha and (Y corner.r.b Omega) &= sum_(j=1)^n alpha_j dx^j and (sum^n_(i=1) (-1)^(i-1) Y^i dx^1 and dots and hat(d x)^i and dots and dx^n)
    \
    &= sum_(i=1)^n alpha_i Y^i (-1)^(i-1) dx^1 and dots and hat(d x)^i and dots and dx^n #dots_space #footnote[by $dx^i and dx^i=0$]
  $

  To cancel $hat(d x)^i$ by $dx^i$, we have to move $hat(d x)^i$ to the front. In this moment, we have to apply the property which is about the changing the position of wedge product.
  $
    dx^1 and dots and rmark(hat(d x)^i, tag: #<position_change>) and dots and dx^n = (-1)^(i-1) hat(d x)^i and dx^1 and dots and dx^n
  $

  #annot-cetz(
    (<position_change>),
    cetz,
    {
      import cetz.draw: *
      set-style(mark: (end: "straight"))
      
      // Change the position of hat(dx)^i
      bezier-through("position_change.south", (rel: (x: -1.6, y: -0.5)), (rel: (x: -1, y: 0.4)), stroke: red)
    }
  )
  Therefore, we have :
  $
    alpha and (Y corner.r.b Omega) &= sum_(i=1)^n alpha_i Y^i dx^1 and dots and dx^n
    \
    &= overbracket((sum_(i=1)^n alpha_i Y^i), alpha(Y)) underbracket((d x^1 and dots and dx^n), Omega)
    \
    &= alpha(Y) Omega
  $
  As applying the above, finally we have : 
  $
    d f and (Y corner.r.b d V_g) &= (d f)(Y) d V_g 
    \
    &= g(op("grad") f, Y) d V_g #dots_space #footnote[by the tangent-cotangent isomorphism]
  $
]