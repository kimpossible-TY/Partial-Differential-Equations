#import "../Styles/styles.typ" : *
#import "figures.typ" : *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.3": *

== Completely Integrable Hamiltonian Systems

#paragraph_tab
Here we will examine the consequences of having $n$ "conservation laws" for a Hamiltonian system with $n$ degrees of freedom. Define the $2n$-dimensional symplectic domain where the local symplectic form is:

$ (x, xi), sigma = sum_(j=1)^n d xi_j and d x_j $

#definition[
If $n$ functions $u_1, dots, u_n$ satisfy ${u_j, u_k} = 0$ where $1 lt.eq j, k lt.eq n$ we call them "there are in involution".
]

#note[
The function $u_1 = F$ could be the energy function whose Hamiltonian vector field we want to analyze, and others are auxiliary functions constructed to reflect conservation laws.
]

#definition[
In involution, one has $n$ such functions, with linearly independent gradients, one is said to have a completely integrable system.
]

#paragraph_tab
To begin the study of a completely integrable system, consider:

#definition[
For a given $p in RR^n$ and in involution, define the level set:

$ M_p := { (x, xi) in G : u_j (x, xi) = p_j } $

Where $j$ is 'free index' it means:

$ cases(u_1 (x, xi) = p_1, dots.v, u_j (x, xi) = p_j) $

Which is the embedded submanifold of $G$.
]

Each nonempty $M_p$ is manifold of dimension $n$, because the starting dimension is $2n$ which means $(x, xi) in O$ and op("dim") $O = 2n$, and there are the 'constraints which are $u_j (x, xi) = p_j$ therefore the final dimension(degree of freedom) is $n$. By the assumption, in addition, we get:
$ sigma(H_(u_j), H_(u_k)) = {u_j, u_k} #dots_space #footnote[by the definition of Poisson bracket] $

Thus, each $M_p$ is Lagrangian.

=== The Connection Between Completely Integrable Manifold And Completely Integrable System

#paragraph_tab
Moreover, we have to focus on that each vector field $H_(u_j)$ is tangent to $M_p$.#footnote[by Proposition 22.16 of _Introduction to Smooth Manifolds_] Since each of $u_j$ has linearly independent gradients#footnote[By the definition of symplectic vector fields, the differential of $u$ generates its Hamiltonian vector field $X_(u_j)$. Thus the independent property can be applied to Hamiltonian vector fields.], the Hamiltonian vector fields are independent. Thus we can think about $frak(H) := op("span"){ H_(u_j) : 1 lt.eq j lt.eq n }$. It is the distribution! Furthermore, $frak(H)$ satisfies the definition of integral manifold because all of the element of $frak(H)$ is tangent to $M_p$ in other words $T_q M_p = aleph $ where $q in M_p$. Then by the proposition 19.3 of _Introduction to Smooth Manifolds_ @Manifolds $scr(H)$ is involutive or actually, we can easily show that it is definitely involutive by:

$
[H_(u_j), H_(u_k)] &= -H_({u_j, u_k}) \
&= H_0 \
&= 0 #dots_space #footnote[by Proposition 22.19 of _Introduction to Smooth Manifolds_]
$
Thus, $H$ is trivially involutive. Since the Frobenius theorem guarantees that every involutive distribution is completely integrable, $H$ is also completely integrable.

=== Essence Of The Hamilton-Jacobi Method

#paragraph_tab
We want to represent $u_j (x, xi) = p_j$ as eikonal equation, because the eikonal equation is harmonic to Hamiltonian equations. We studied it before. Now, let's struggle to make the eikonal equations. To do this, we need some assumptions. The first assumption is that:
#emphasis[Define $pi: M_p -> RR^n$ as a local diffeomorphism satisfying $pi(x, xi) = x$. ]

#paragraph_tab
Since we know $x$ before computing $pi^(-1)(x)$, computing $pi^(-1)(x)$ actually the same as determining $xi$. Since $pi^(-1)(x)$ is bijective by the assumption, moreover, $xi$ must be determined by the single $x$. It means there is a function $Xi_p (x)$ which determines $xi$.
$ Xi_p (x) = xi $

To define $Xi_p$ rigorously, define $pi': (x, xi) |-> xi$ similarly.

$ Xi := pi' compose pi^(-1) $ which is $x |-> xi$

#paragraph_tab
Since we want to represent $u_j (x, xi) = p_j$ to eikonal equation which implies that represent $xi$ to some differential and $xi$ is the same as $Xi_p (x)$ we have to investigate $xi$ to achieve our goal. First of all, we know that $E$ is closed.
#flowbox[
$
sigma|_(M_p) &= sum_(j=1)^n d xi_j and d x_j \
&= sum_i^n (sum_k^n frac(partial xi_j, partial x_k) d x_k) and d x_j #dots_space #footnote[where $xi = xi(x)$]
\
&= sum_(j, k) frac(partial xi_j, partial x_k) (d x_k and d x_j) #dots_space #footnote[by the basic property of wedge product]
\
&= cancel(sum_(j=k) frac(partial xi_j, partial x_k) (d x_k and d x_j))
+sum_(j<k) frac(partial xi_j, partial x_k) (d x_k and d x_j) + 
sum_(j>k) frac(partial xi_j, partial x_k) (d x_j and d x_k) #dots_space #footnote[the cancelation is due to $d x_j and d x_j=0 $]
\
&= sum_(j<k) frac(partial xi_j, partial x_k) (d x_k and d x_j) + sum_(k>j) frac(partial xi_j, partial x_k) (-d x_j and d x_k) #dots_space #footnote[$d x_j and d x_k = -d x_k and d x_j$]
\
&= sum_(j<k) (frac(partial xi_j, partial x_k) - frac(partial xi_k, partial x_j)) (d x_j and d x_k) \
&= 0 #dots_space #footnote[$M_p$ is Lagrangian.]
$

$arrow.b$

$ therefore (frac(partial xi_j, partial x_k) - frac(partial xi_k, partial x_j)) = 0 arrow.double xi(x) = Xi_p (x) "is closed." $

]

We can apply the closed property each of $p$ just like the above. Thus $xi$ is closed locally. #footnote[Since $xi$ is defined by $pi$ and $pi'$ and both $pi$ and $pi'$ are also defined at local, anyway, the locality of closed property is no matter.] And we get the Eikonal equation.

$
u_j (x, xi) &= p_j \
&= u_j (x, d_x phi) & "Eikonal equation"
$

=== Canonical Transformation And Linearization

#paragraph_tab
Second, If we additionally assume that $M_p$ is star-shaped, $xi$ is extract by Poincaré lemma. Thus we can think a new function :
#flowbox[
$
Xi(x, p) &= d phi(x, p) \
&= d_x phi(x, p) + d_p phi(x, p) #dots_space #footnote[by the definition of total differential]
$

+ Fix $p$: $Xi_p (x) = xi = d_x phi(x, p)$
+ Fix $x$: define $q := Xi_x (p)$ to $q = d_p phi(x, p)$
]

We can easily know that $xi = d_x phi$. Since the differential can be divided to the two parts and one is the same as $xi$, it is natural to define another as the new variable $q$.

#paragraph_tab
By the above arguments, we can single out a new argument.

#flowbox[
$
d phi(x, p) = d_x phi(x, p) + d_p phi(x, p) $

$arrow.b$

$
"We can single out that" d p "is related to" (x, p) |-> (q, xi)$

$arrow.b$

$
"There is a some local diffeomorphism" (x, p) |-> (q, xi). #dots_space #footnote[Since $xi$ is local diffeomorphism And so be $d p$, it guarantees that there is as bijective map $(x, p) |-> (q, xi)$ locally.]
$
]

The local diffeomorphism implies another diffeomorphism which is $(x, xi) |-> (q, p)$. $(x, p) |-> (q, xi)$ isn't useful actually, however, $(x, xi) |-> (q, p)$ is quite useful.
Defining $phi: (x, xi) |-> (q, p)$ and $tilde(u)(p, q) := u circle phi(x, xi) = u(x, xi)$, the Hamiltonian vector field of $tilde(u)$ is very useful:

#flowbox[
*Linearization of Hamiltonian vector field*
$
H_(tilde(u)_j) &= sum_k (frac(partial tilde(u)_j, partial p_k) frac(partial, partial q_k) - cancel(frac(partial tilde(u)_j, partial q_k) frac(partial, partial p_k)) ) #dots_space #footnote[because $tilde(u)(q, p) = p$ ]
\
&= sum_k (delta_k^j frac(partial, partial q_k)) #dots_space #footnote[because $tilde(u)(q, p) = p$ implies $tilde(u)_j = p_j$] \
&= frac(partial, partial q_j)
$
]

#paragraph_tab
To concrete $scr(C)$, define :
#flowbox[
$
cases(
  F_1 colon (x comma p) mapsto (d_p phi(x comma p) comma p) = (q comma p),
  F_2 colon (x comma p) mapsto (x comma d_x phi(x comma p)) = (x comma xi)
) 
$

$arrow.b$

$
scr(C) := F_1 compose F_2^(-1) #dots_space #footnote["canonical transformation"]
$
]

Then, is it okay to use $u compose scr(C) = tilde(u)(q comma p) = u(x comma xi)$? Since it must treats Hamiltonian vector field, we have to check whether it preserves the symplectic form.
#flowbox[
$
F_2^* (sum_j d xi_j and d x_j) = sum_j 
markrect((sum_k frac(partial xi_j, partial x_k) d x_k + sum_k frac(partial xi_j, partial p_k) d p_k), color: #blue, tag: #<canonical_form_first>)
and d x_j #dots_space #footnote[where $F^*$ is the pullback] 
#annot(<canonical_form_first>,pos:top+right,dx: 5em)[definition of $d xi_j$ (total differential)]
\
= sum_j (cancel(sum_k frac(partial^2 phi, partial x_k partial x_j) d x_k )+ sum_k frac(partial^2 phi, partial p_k partial x_j) d p_k) and d x_j #dots_space #footnote[by substituting $xi_j = frac(partial phi, partial x_j)$] \
= sum_(j, k) frac(partial^2 phi, partial p_k partial x_j) (d p_k and d x_j) #dots_space #footnote[$sum_k frac(partial^2 phi, partial x_k partial x_j) d x_k and d x_j = sum_(j<k) frac(partial^2 phi, partial x_k partial x_j) d x_k and d x_j + overbrace(underbrace(sum_(j>k) frac(partial^2 phi, partial x_k partial x_j) (-d x_k and d x_j), d x_j and d x_k), "clairaut's theorem and ") = 0$]
$

$arrow.b$

Thus $F_2$ preserves the symplectic form.
]

The fact $F_1$ preserves that symplectic form can be proved similar to above. Thus the combination of $F_1$ and $F_2$ which is $scr(C)$ preserves the symplectic form too.

=== Example: The Central Force Theorem

#paragraph_tab
The perfect example of Completely integrable system, canonical transforms and linearization is central forces problem. Let's construct the problem:

#emphasis(title: "Central forces problem")[
+ *Problem:* We are analyzing the motion of a particle in a 2D plane, $RR^2$. This means it has $n=2$ degrees of freedom (e.g., coordinates $x_1 comma x_2$).
+ *Phase Space:* The corresponding phase space $T^* RR^2$ is $2n=4$-dimensional, with coordinates.
+ *Complete Integrability:* To prove this system is completely integrable, we must find $n=2$ independent functions, $u_1$ and $u_2$, that are in involution (i.e., ${u_1 comma u_2} = 0$).]

#paragraph_tab
The first function, $u_1$, is always the Hamiltonian $H$, which represents the total energy of the system.

$ u_1 (x comma xi) = H(x comma xi) = frac(1, 2) |xi|^2 + V(|x|) = frac(1, 2) |xi_1^2 + xi_2^2| + V(sqrt(x_1^2 + x_2^2)) $

where $V$ is potential energy and $cases(x = sum_i x_i, xi = sum_i xi_i)$. Now, we have to fine $u_2$ which satisfying ${u_1 comma u_2} = 0$. By Proposition 22.21 of _Introduction to Smooth Manifolds_ @Manifolds, we know that $u_2$ is conserved quantity, because $u_1$ is actually Hamiltonian. By Noether's theorem, we already know the angular momentum is conserved. Thus define $u_2$ as the angular momentum.

#flowbox[
$
u_2 (x comma xi) &= x_1 xi_2 - x_2 xi_1 \
&= ||x times xi||
$
$arrow.b$


$
{u_1 comma u_2} = 0 #dots_space #footnote[by Noether's theorem and Proposition 22.21 of _Introduction to Smooth Manifolds_ @Manifolds]
$
]
Thus the system is completely integrable system.

#paragraph_tab
Now, let's apply the canonical transformation and linearization to the problem. Let's define the canonical transformation. Before constructing the transformation, we must construct the following:

#emphasis[Define $p = (p_1 comma p_2)$, $p_1 := H$("total energy") and $p_2 :=$ "angular momentum".

Define $phi(x comma p)$ where $x = (r comma theta)$ #footnote[make $(x_1 comma x_2)$ specifically to $(r comma theta)$ which is polar coordinates for the comfortable.] and $p = (E comma L)$.]

We already know that $d_x phi$ which is $frac(partial phi, partial r) + frac(partial phi, partial theta)$ and each are satisfied:

$ F_2^(-1) = cases(frac(partial p, partial r) |-> p_1 tilde.eq xi_1, frac(partial p, partial theta) |-> p_2 approx xi_2) $

#paragraph_tab
Then we can reformulate $u$ to $overline(u)$ by $(p_1 comma p_2)$ and polar coordinate representation.

#flowbox[
$
cases(
  overline(u)_1 (x comma p) = frac(1, 2) (p_1^2 + frac(1, r^2) p_2^2) + V(r),
  overline(u)_2 (x comma p) = p_2
) #dots_space #footnote[$frac(1, r^2)$ is due to polar coordinate representation]
$

$arrow.b$

#paragraph_tab
Reformulate the above equation by $F_2$:
$
cases(
  frac(1, 2) ((frac(partial phi, partial r))^2 + frac(1, r^2) (frac(partial phi, partial theta))^2) + V(r) = p_1 = E,
  frac(partial phi, partial theta) = p_2 = L
)
$

$arrow.b$

Since the angular momentum is preserved, we get:
$ therefore frac(partial phi, partial r) = sqrt(2(E - V(r) - frac(L, 2 r^2))) $
]

#paragraph_tab
As combining $frac(partial phi, partial r)$ and $frac(partial phi, partial theta)$, we get $d_x phi$. #highlighted[However, we don't know what $d_p phi$ should be!] We need $d_p phi$ to define the new variables $q$. How can we break though this problem? #highlighted[Instead of struggling to compute the differential directly, let's focus to determine $phi$.] Since we know $frac(partial phi, partial r)$ and $frac(partial phi, partial theta)$, we can determine $phi$ by integrating them. Then we compute $q_1$ and $q_2$ by the primitive.
#flowbox[
1. Compute the partial integral $integral frac(partial phi, partial theta)$.
$
markrect(integral frac(partial phi, partial theta), color: #blue, tag: #<example_fist>) &= L theta + markrect(H(r comma E comma L), color: #red, tag:#<example_hamiltonian>)

#annot(<example_fist>,pos:top+left)[partial integral]
#annot(<example_hamiltonian>)[constant of integral]
\
&= phi #dots_space #footnote[by directly computing inside of integral]
$
2. Differentiate both sides of $phi = L theta + H(r comma E comma L)$ by $r$
$
frac(partial phi, partial r) &= cancel(frac(partial, partial r)(L theta)) + frac(partial H, partial r) \
&= sqrt(2(E - V(r) - frac(L, 2 r^2))) #dots_space #footnote[the cancelation is that we already know that]
$

$arrow.b$

$frac(partial H, partial r) = sqrt(2(E - V(r) - frac(L, 2 r^2)))$

3. Compute $H$ by using partial integral to substitute $phi = L theta + H$

$
H &= integral sqrt(2(E - V - frac(L^2, 2 r^2))) + G(E comma L) #dots_space #footnote[partial integral]
$

$arrow.b$

$therefore phi &= L theta + integral sqrt(2(E - V - frac(L^2, 2 r^2))) + G(E comma L)$


4. Compute $q_1$ by computing $frac(partial q, partial E)$

$
q_1 &:= frac(partial phi, partial E)(r comma theta comma E comma L) \
&= frac(partial, partial E) [cancel(L theta) + integral sqrt(2(E - V - frac(L^2, 2 r^2))) + G(E comma L)] \
&= integral markrect(frac(partial, partial E) sqrt(2(E - V - frac(L^2, 2 r^2))), color: #blue, tag: #<example_fist>) + frac(partial G, partial E)(E comma L) #dots_space #footnote["by Leibniz's rule, insert" $frac(partial, partial E)$ "to integral"] \
&= integral frac(1, sqrt(2(E - V - frac(L^2, 2 s^2)))) d s + frac(partial G, partial E)
$

#annot(<example_fist>, pos : top+left, dx: -6em)[insert $frac(partial, partial E)$to integral]


5. Compute $q_2$ by computing $frac(partial phi, partial L)$

$
q_2 &:= frac(partial phi, partial L) \
&= frac(partial, partial L) [L theta + integral sqrt(2(E - V - frac(L^2, 2 r^2))) + G(E comma L)] \
&= theta + integral frac(partial, partial L) sqrt(2(E - V - frac(L^2, 2 r^2))) + frac(partial G, partial L)(E comma L) #dots_space #footnote[by Leibniz's rule again] \
&= theta - integral frac(L \/ s^2, 2 sqrt(E - V - frac(L^2, 2 s^2))) d s + frac(partial G, partial L)
$
]

#paragraph_tab
Now, let's think $H_(tilde(u)_1)$. #highlighted[We already know that $H_(overline(u)_1) = frac(partial, partial q_1)$. Since $frac(partial, partial q_1)$ physically means 'shifting $q_1 (gamma)$ slightly' where $gamma$ is integral curve.] By the definition of integral curves, we know :

#flowbox[
$
gamma'(t) &= H_(tilde(u)_1) (gamma(t)) #dots_space #footnote[by the definition of integral curves]
\
&= gamma'_i frac(partial, partial alpha_i) #dots_space #footnote[where $alpha_i = q_1 comma q_2 comma p_1 comma p_2$]
$

$arrow.b$

$H_(overline(u)_1) = overbrace((1), =gamma'_1) dot frac(partial, partial q_1)$

$arrow.b$

$
cases(
  gamma'_1 (t) = dot(q)_1 = 1,
  gamma'_2 (t) = dot(q)_2 = 0
)
$]

Finally, we now compute the trajectory of central forces problem!
#flowbox[
$
cases(
  integral dot(q)_1 d t = q_1 + delta_1 = t,
  integral dot(q)_2 d t = q_2 + delta_2 = 0
)
$

Where $delta_1 comma delta_2$ are constants of integral. 

$arrow.b$

Package $c_1 := delta_1 + frac(partial G, partial E)$ and $c_2 := delta_2 + frac(partial G, partial L)$.

$
t &= integral frac(d s, sqrt(2(E - V - L^2 \/ 2 s^2))) + c_1 \
0 &= theta - integral frac(L \/ s^2, 2 sqrt(E - V - L^2 \/ 2 s^2)) d s + c_2
$
]
#paragraph_tab
Since $c_2$ is just a constant of integral, we can ignore it. Then we get :

#emphasis(title: "Trajectory of the central force problem")[
$ theta = integral frac(L \/ s^2, 2 sqrt(E - V - L^2 \/ 2 s^2)) d s $]