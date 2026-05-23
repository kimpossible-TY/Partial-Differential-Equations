#import "../Styles/styles.typ" : *
#import "figures.typ" : *
#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.1": *

== first-order, scalar, Non-linear PDE

#paragraph_tab
This section is devoted to a study of PDE of the form :

$ F(x, u, nabla u) = 0 $
For a real-valued $u in C^infinity(Omega)$, $op("dim") Omega = n$, given $F(x, u, nabla u)$ smooth on $Omega times RR times RR^n$ or some sub-domain thereof.
We study local solutions of $F(x, u, nabla u) = 0$ satisfying:

$ u|_S = v $

#paragraph_tab
Where $S$ is a smooth hyper-surface of $Omega$, $v in C^infinity(S)$.

#definition[
For the first-order non-linear PDE given by $F(x, u, nabla u) = 0$ with initial data $u|_S = v$ on a initial surface $S$, the non-characteristic hypothesis is satisfied at a point if the equation can be solved for the derivative of $u$ in the direction normal to $S$. In other words,

$ (partial F) / (partial xi_n) eq.not 0 #dots_space #footnote[Note that the gradient of $S$ points to the direction normal to $S$.] $

Where $xi$ is gradient of $S$.#footnote[by Proposition 22.16 of @Manifolds]
]
If the condition fails $((partial F) / (partial xi_n) = 0)$, the surface $S$ is said to be characteristic. In this case, the characteristic curves lie within the initial surface which is $S$. The PDE itself provides information about the derivatives within the surface, but the initial data already prescribes them. This can lead to two problems:
#emphasis[
+ *No Solution*: If the initial data is inconsistent with the PDE along these characteristic curves, no solution can exist.
+ *Infinitely Many Solutions*: If the initial data is consistent, it doesn't provide enough information to uniquely determine the solution away from the surface.
]

#paragraph_tab
Actually, the non-characteristic problem can be more simplified. Let's consider 
$ F(x, nabla u) = 0
$
which is simplified non-characteristic condition. To investigate it, we replace $nabla u mapsto d u$ by the $hat(g)^(-1)$. Since $hat(g)$ is the isomorphism, the replacement is understandable.
Then why we do that? #highlight[It is because we want to introduce the Hamiltonian system!] To apply the system, we must can compute $d F$. If $nabla u$ don't be replaced to $d u$, however, we can't compute $d F$! Therefore the replacement $nabla u mapsto d u$ is required.

#paragraph_tab
Alright, now let's define the manifold which will be the domain of Hamiltonian function. However $F$ isn't directly on the manifold but also the cotangent bundle $T^* Omega$! But don't worry, $(x, zeta) in T^* Omega$ can be acted likely the point on the manifold. Since there is an isomorphism between vector and covector, the covector space or sets can be treated as manifold! By this argument, #highlighted[we can treat $T^* Omega$ as manifold, more precisely its dimension is $2n$#footnote[It is because when $x in Omega$ where op("dim") $Omega = n$], which is good to treat as the symplectic manifold!]
#note[we will treat $T^* Omega$ as a signle manifold.] <perspective_to_symplectic>

#paragraph_tab
Alright, we now define $A$ to be the union of the integral curves of the Hamiltonian vector field $H_F$ though the initial area which is matched to the $S$.

#definition[
$Sigma = { (x, xi) : x in S, xi_j = partial_j v "for" 1 lt.eq j lt.eq n-1, F(x, xi) = 0 }$
with
$partial_j v = (partial v) / (partial x_j)$
]

#note[
$Sigma$ is the graph of which has the component of gradient.
]

#lemma[$Sigma$ is isotropic.]

#proof[
To show that $Sigma$ is isotropic, we have to show that $sigma(X, Y) = 0$ for all tangent vectors $X, Y in T_p Sigma$ where $sigma$ is the symplectic form and $p$ is some point of $Sigma$. Then how can we determines the tangent vector?

#paragraph_tab
Using the chain rule, a tangent vector $X_j$ is:
$ X_j = markul(partial / (partial x_j), color: #blue, tag: #<x_j_in_X_j>) + sum_(l=1)^(n-1) (partial (partial_l v)) / (partial x_j) partial / (partial xi_l) 

#annot(<x_j_in_X_j>)[summation isn't exist.]
$

#paragraph_tab
Now, let's compute $sigma(X_j, X_k)$. Since $sigma$ is $sum_(l=1)^n d xi_l and d x_l$ and the wedge product is defined by $(d xi_l and d x_l)(A, B) = d xi_l (A) d x_l (B) - d xi_l (B) d x_l (A)$. We get:

$
sigma(X_j, X_k) &= (sum_(l=1)^n d xi_l and d x_l) (X_j, X_k) \
&= sum_(l=1)^n [ d xi_l (X_j) d x_l (X_k) - d xi_l (X_k) d x_l (X_j) ] \
&= sum_(l=1)^n ( (partial xi_l) / (partial x_j) (delta_(l k)) - (partial xi_l) / (partial x_k) (delta_(l j)) ) #dots_space #footnote[by the basic properety of differential. For example $d x_j / d x_i = delta_(i j)$] \
&= (partial xi_k) / (partial x_j) - (partial xi_j) / (partial x_k) #dots_space #footnote[by the kronecker delta] \
&= partial / (partial x_j) (partial v) / (partial x_k) - partial / (partial x_k) (partial v) / (partial x_j) #dots_space #footnote[by the definition of $xi_i$]
$

By the Clairaut's Theorem#footnote[See _Analysis 2_ written by Terence Tao. Since $v$ is smooth function by its definition, $partial / (partial x_j) (partial v) / (partial x_k) = partial / (partial x_k) (partial v) / (partial x_j)$], Since $v$ is smooth function by its definition, Therefore, $sigma(X_j, X_k) = 0$.
]

#paragraph_tab
Moreover $A$ is the embedded sub-manifold of $T^* Omega$ whose dimension is $n$. Since $Sigma$ is the starting area, whose dimension is $(n-1)$ and the non-characteristic hypothesis guarantees that the vector field of $F$ are transversal to the initial surface $Sigma$. To contain the single vector field, $A$ is $n$-dimensional surface which is just 1 larger than $n-1$.

#emphasis(title: "Information of A")[
+ Embedded submanifold of $T^* Omega$
+ Whose dimension is $n$
+ Union of the integral curve $H_F$.
+ Contain the initial area $Sigma$
]

#paragraph_tab
We already know that $F$ must be constant that its flow is Hamiltonian.#footnote[Proposition 22.16 by @Manifolds] By the non-hypothesis, we know that $F=0$ on the initial area $Sigma$. Since $F$ is constant, $F$ must be equal to its initial condition, that is 0.

#theorem(title: "15.3")[The surface $A$ constructed above is Lagrangian for, a solution $u$ to
$ F(x, d u) = 0, u|_S = v $
]

#proof[
To show that $A$ is Lagrangian, we have to determine whether it is isotropic and its dimension is $1/2 op("dim") T^* Omega$. Since we already know that $op("dim") A = n = 1/2 op("dim") T^* Omega$, it is sufficient to show that $A$ is isotropic.

#paragraph_tab
The given condition implies $Sigma$ which is the starting area of Hamiltonian vector field and $Sigma$ is isotropic. Since $Lambda$ contains $Sigma$, it is sufficient to show that the Hamiltonian vector field preserves the symplectic form which is $sigma(X_1, X_2)$ for all $X_1, X_2 in T_p Lambda$ for arbitrary $p$.

#paragraph_tab
Then let's investigate the Hamiltonian vector field. We don't treat arbitrary Hamiltonian vector field, but also $H_F$. #highlighted[Since $F$ is constant which means the conserved quantity and its vector field is Hamiltonian, by Noether's theorem (a), $H_F$ is infinitesimal symmetry which means the vector field preserves $sigma$.] #footnote[See Theorem 22.22 by @Manifolds] Thus $H_F$ preserves the value of $sigma$ at initial area $Sigma$. Since $Sigma$ is isotropic which means the value of $sigma$ is zero, $Lambda$ is zero too.
]

=== Eikonal Equation Whose Norm Of Gradient Is Constant <Eikonal_Equation_constant>

#paragraph_tab
Let's consider more specific eikonal equation.

$ F(x, d phi) = 0 "where" |d phi|^2 = 1 $

Note that $|d phi|^2$ will be :
$ |d phi|^2 = sum_(j, k) g^(j k)(x) (partial phi) / (partial x_j) (partial phi) / (partial x_k) = 1 #dots_space #footnote[by the definition of covector norm] $

At the previous, only $F$ is constant. However if $|d phi|^2 = "constant"$ and apply the Hamiltonian equation, we get the relationship between geodesic, because the Hamiltonian equation can be geodesics equation if we choose the suitable 'energy function'. Define the energy function:

$
f(x, xi) &:= 1/2 |xi|^2 #h(2em) "where" xi := d phi \
&= 1/2 sum g^(j k)(x) xi_j xi_k \
&= 1/2
$

We already know that the energy function of the type mentioned above induces that the Hamiltonian vector field will be the tangent of geodesic.

$
gamma'(t) &= sum_j (partial f) / (partial xi_j) partial / (partial x_j) \
&= sum_(j, k) g^(j k)(x) xi_k partial / (partial x_j) #dots_space #footnote[by using $(partial f) / (partial xi_j) = sum_k g^(j k)(x) xi_k$, where $f = 1/2 sum g^(j k) xi_j xi_k$] \
&= sum_(j, k) g^(j k)(x) (partial phi) / (partial x_k) partial / (partial x_j) #dots_space #footnote[by the definition of $xi$, $xi_k = (partial phi) / (partial x_k)$] \
&= op("grad") f #dots_space #footnote[by the definition of gradient]
$

#note[
To argue the above, actually, there is no problem that $|d phi|^2 = "constant"$.
]