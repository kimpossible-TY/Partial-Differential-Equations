#import "../../Styles/styles.typ": *
#import "figures.typ": *
#import "@preview/mannot:0.3.1": *
#import "@preview/cetz:0.4.2" as cetz

=== Covariant Derivatives of Tensor Fields

#paragraph_tab
By definition, a connection in $T M$ is a rule for computing covariant derivatives of vector fields. We show in this section that every connection in $T M$ automatically induces a connections in all tensor bundles over $M$.

#definition(title: "Funcitonal Evaluation")[
  Let $V$ be a finite-dimensional vector space (such as the tangent space $T_p M$) and $V^*$ be its dual space. For any covector $omega in V^*$ and vector $Y in V$, the *functional evaluation* (or *natural pairing*) is defined as the direct application of the linear functional $omega$ to the vector argument $Y$:

  $ chevron.l omega, Y chevron.r := omega(Y) $

  In local coordinates, if $omega = omega_i d x^i$ and $Y = Y^j partial_j$, this operation corresponds to the contraction of indices:

  $ chevron.l omega, Y chevron.r := omega_i Y^i $
] <Definition_of_functional_evaluation>
#note[Funcitonal Evaluation is purely algebraic; unlike an inner product $chevron.l Y, Z chevron.r_g$, it requires no metric tensor structure. However, we often omit the 'metric notation' to the inner product. For example,
  $
    chevron.l Y, Z chevron.r_g arrow.r.double chevron.l Y, Z chevron.r #dots_space #footnote[We will use this notation at @product_rule_of_Euclidean_connection]
  $
]

#paragraph_tab
There is a useful lemma induced by the definition of functional evaluation(@Definition_of_functional_evaluation).
#lemma(title: "Basic formula of functional evaluation")[
  Let $omega in V^*$ and $Y in V$. Then $chevron.l omega comma Y chevron.r= op("tr") (omega times.o Y)$.
] <Basic_formula_of_functional_evaluation>

#proof[Let's choose a local coordinate system with basis vectors $e_i$ and dual basis 1-forms $e^j$ (where $e^(j)(e_i) = delta^j_i$). Then the Left Hand Side is :
  $
    omega = omega_i e^i, \
    Y = Y^j e_j
  $

  The functional evaluation is just the linear application:
  $
    chevron.l omega, Y chevron.r = (omega_i e^i)(Y^j e_j) = omega_i Y^j underbrace(e^(i)(e_j), delta^i_j) = omega_i Y^i
  $
  This is just the standard dot product sum.

  #paragraph_tab
  Now, let's focus on the Right Hand Side (Trace of Tensor Product).
  The tensor product $F = omega times.o Y$ is a $(1,1)$ tensor. Its components are formed by multiplying the components of the parts:
  $
    F := (omega_i e^i) times.o (Y^j e_j) = omega_i Y^j (e^i times.o e_j)
  $
  In matrix terms, the components $F^j_i$ are given by $omega_i Y^j$. The trace is defined as the sum of the diagonal terms (where upper and lower indices match, i.e., $i=j$):
  $op("tr")(F) = sum_k F^k_k = sum_k omega_k Y^k$. $chevron.l omega, Y chevron.r = sum_k omega_k Y^k$, Hence, they are identical.
]
#note(
  title: [The abstact reasion of @Basic_formula_of_functional_evaluation],
)[If we consider the abstract definition of trace, we will be stopped thinking of the Trace as just "summing diagonals."

  #paragraph_tab
  In abstract algebra, the trace is defined as the unique linear map:
  $
    op("tr"): V^* times.o V arrow bb(R)
  $
  that satisfies exactly this property for "pure" tensors:
  $op("tr")(omega times.o Y) = omega(Y)$

  #paragraph_tab
  we might be thinking of "trace" and "function evaluation" as two different animals that happen to be equal. They aren't.
  function evaluation is the operation's natural definition.
  Summing diagonals is just the recipe for calculating that definition when you are stuck using coordinates (matrices).
  So, the equation isn't a coincidence; it is the definition of the trace for a rank-1 operator.]

#paragraph_tab
Applying @Basic_formula_of_functional_evaluation to the mixed tensor field, we can also get the similar formula.
#lemma(title: "basic formula of tensor field")[
  Let $F in Gamma(T^((k,l)) T M)$, $omega^1, dots, omega^k in Gamma(T^* M)$, and $Y_1, dots, Y_l in Gamma(T M)$. Then
  $
    F(omega^1, dots, omega^k, Y_1, dots, Y_l) &= chevron.l F, omega^1, dots, omega^k, Y_1, dots, Y_l chevron.r \
    &= op("tr") (F times.o omega^1 times.o dots times.o omega^k times.o Y_1 times.o dots times.o Y_l)
  $
] <Basic_formula_of_tensor_field>

#proof[
  The proof is the same as @Basic_formula_of_functional_evaluation.
]
#note(
  title: "disassembly tool for tensor fields",
)[@Basic_formula_of_tensor_field is very useful, because it allows to investigate inside of tensor field. Thus we can adjust the 'abstact level'!]

#proposition(title: "4.15")[
  Let $M$ be a smooth manifold with or without boundary, and let $nabla$ be a connection in $T M$. Then $nabla$ uniquely determines a connection in each tensor bundle $T^((k,l)) T M$, also denoted by $nabla$, such that the following four conditions are satisfied.

  #set enum(numbering: "(i)")
  + In $T^((1,0)) T M = T M$, $nabla$ agrees with the given connection.
  + In $T^((0,0)) T M = M times RR$, $nabla$ is given by ordinary differentiation of functions:
    $
      nabla_X f = X f. #dots_space #footnote[We already treated at @definition_of_covariant_derivative_of_scalar_function]
    $
  + $nabla$ obeys the following product rule with respect to tensor products:
    $ nabla_X (F times.o G) = (nabla_X F) times.o G + F times.o (nabla_X G). $
  + $nabla$ commutes with all contractions: if "$tr$" denotes a trace on any pair of indices, one covariant and one contravariant, then
    $ nabla_X (tr F) = tr(nabla_X F). $

  This connection also satisfies the following additional properties:

  #set enum(numbering: "(a)")
  + $nabla$ obeys the following product rule with respect to the natural pairing between a covector field $omega$ and a vector field $Y$:
    $
      nabla_X chevron.l omega, Y chevron.r = chevron.l nabla_X omega, Y chevron.r + chevron.l omega, nabla_X Y chevron.r.
    $ <product_rule_of_covariant_derivative_with_tensor>
  + For all $F in Gamma(T^((k,l)) T M)$, smooth 1-forms $omega^1, dots, omega^k$, and smooth vector fields $Y_1, dots, Y_l$,
  $
    (nabla_X F)(omega^1, dots, omega^k, Y_1, dots, Y_l) &= X(F(omega^1, dots, omega^k, Y_1, dots, Y_l)) \
    &quad - sum_(i=1)^k F(omega^1, dots, nabla_X omega^i, dots, omega^k, Y_1, dots, Y_l) \
    &quad - sum_(j=1)^l F(omega^1, dots, omega^k, Y_1, dots, nabla_X Y_j, dots, Y_l).
  $ <proposition4.15_b>
]

#proof[
  To prove (a), note that $chevron.l omega comma Y chevron.r= op("tr") (omega times.o Y)$ by @Basic_formula_of_functional_evaluation. Then (a) is just a result of the product rule for connections.
  We start by taking the covariant derivative $nabla_X$ of the left-hand side.

  #flowbox[
    Replace the pairing with the trace definition.
    $ nabla_X chevron.l omega, Y chevron.r = nabla_X (op("tr")(omega times.o Y)) $

    $arrow.b$

    Move trace to inside of functional evaluation.
    $= op("tr") ( nabla_X (omega times.o Y) ) #dots_space #footnote[It is vaild because both operators are linear.]$

    $arrow.b$

    Apply Condition (iii) - Product Rule.
    $ = op("tr") ( (nabla_X omega) times.o Y + omega times.o (nabla_X Y) ) $

    $arrow.b$

    Use the linearity of the Trace.
    $ = op("tr") ( (nabla_X omega) times.o Y ) + op("tr") ( omega times.o (nabla_X Y) ) $

    $arrow.b$

    Convert back to "Pairing" notation.
    $
      op("tr")((nabla_X omega) times.o Y) = chevron.l nabla_X omega, Y chevron.r \
      op("tr")(omega times.o (nabla_X Y)) = chevron.l omega, nabla_X Y chevron.r
    $

    $arrow.b$

    $
      therefore nabla_X chevron.l omega, Y chevron.r = chevron.l nabla_X omega, Y chevron.r + chevron.l omega, nabla_X Y chevron.r
    $
  ]

  #paragraph_tab
  Let $f$ be the scalar function defined by the full contraction of the tensor $F$ with its arguments:
  $ f = F(omega^1, dots, omega^k, Y_1, dots, Y_l) $

  #paragraph_tab
  By condition (ii), the covariant derivative of this scalar is simply the ordinary derivative:
  $ nabla_X f = X(f) = X(F(omega^1, dots, omega^k, Y_1, dots, Y_l)) $

  #paragraph_tab
  Alternatively, we can view $f$ as the contraction of the tensor product $cal(T) = F times.o omega^1 times.o dots times.o Y_l$.#footnote[We already know $f=op("tr")(cal(T))$ by @Basic_formula_of_tensor_field] Since $nabla$ commutes with traces (condition iv) and satisfies the product rule (condition iii), we have:

  $
    nabla_X f & = nabla_X (op("tr")(F times.o omega^1 times.o dots times.o Y_l)) \
              & = op("tr")(nabla_X (F times.o omega^1 times.o dots times.o Y_l)) \
              & = op("tr") [ (nabla_X F) times.o omega^1 dots times.o Y_l \
              & quad +
                markrect(
                  sum_(i=1)^k F times.o dots times.o (nabla_X omega^i) times.o dots times.o Y_l \
                  &quad + sum_(j=1)^l F times.o dots times.o omega^k times.o dots times.o (nabla_X Y_j) times.o dots, color: #red, tag: #<blades_made_by_trace>
                ) ]
  $ #annot(<blades_made_by_trace>)[result of the product rule of connection (condition (iii))]

  Evaluate these traces restores the function arguments:
  $
    markhl(nabla_X f, tag: #<nabla_X_f>) & = (nabla_X F)(omega^1, dots, Y_l) \
    markrect(
      & + sum_(i=1)^k F(omega^1, dots, nabla_X omega^i, dots, Y_l) \
      & + sum_(j=1)^l F(omega^1, dots, omega^k, dots, nabla_X Y_j, dots), color: #blue, tag: #<will_be_moved_to_LHS>
    )
  $ #annot-cetz((<will_be_moved_to_LHS>, <nabla_X_f>), cetz, {
    import draw: *
    set-style(mark: (end: "straight"))
    let (a, b) = ((0, -0.3), (-1, 0))
    line(a, b, stroke: purple)
  }) #annot(<will_be_moved_to_LHS>, pos: bottom, dx: -5em)[#text(size: 6pt)[It will be moved to the left-hand side.]]

  Equating the two expressions for $nabla_X f$ and isolating the term $(nabla_X F)(dots)$ yields the desired formula:
  $
    therefore (nabla_X F)(dots) = X(F(dots)) - sum F(dots, nabla_X omega^i, dots) - sum F(dots, nabla_X Y_j, dots).
  $
]

#paragraph_tab
Because the covariant derivative $nabla_X F$ of a tensor field is linear over $C^infinity (M)$ on $X$, the covariant derivatives of $F$ in all directions can be handily encoded in a signle tensor field whose rank is one more tahn the rank of $F$, as follows.
#definition(title: "The total covariant derivative")[
  Let $M$ be a smooth manifold with or without boundary and let $nabla$ be a connection in $T M$. For every $F in Gamma(T^((k,l)) T M)$, the map
  $
    nabla_X F : underbrace(Omega^1 (M) times dots.h Omega^1(M), "k copies") times underbrace(frak(X)(M) times dots.h frak(X)(M), "l+1 copies") arrow C^infinity (M)
  $
  given by :
  $
    (nabla F)(omega^1 , dots.h , omega^k, Y_1 , dots.h , Y_l , X) = (nabla_X F)(omega^1 , dots.h , omega^k, Y_1 , dots.h , Y_l)
  $
  defines a smooth $(k, l+1)$-tensor field $nabla F$ on $M$ called the total covariant derivative of F.
] <definition_of_total_covariant_derivative>

#note(title: "The total covariant derivative is a tensor field")[
  Since $nabla F$ is a $(k, l+1)$-tensor field, $nabla_X F$ is also a $(k, l)$-tensor field.
] <the_total_covariant_derivative_is_a_tensor_field>

#paragraph_tab
When we write the components of a total covariant derivative in terms of local frame, we can apply it to vector field and covector(1-form). For example, If $Y$ is a vector field written in coordinates as $Y=Y^i E_i$, the components of the $(1,1)-"tensor field"$ $nabla Y$ are written $Y^(i)_(;j)$, so that :
$
  nabla Y := Y^(i)_(;j) E^i times.o epsilon_j
$
with
$
  Y^(i)_(;j) := E_j Y^i+Y^k Gamma^(i)_("jk") #dots_space #footnote[It is inspired by @basic_formula_of_connection_in_tangent_bundle : $nabla_X Y= X^(j) underbrace((E_j Y^k + Y^m Gamma^(k)_("jm")), "This is " Y^(k)_(;j)) E_k$]
$ <semicolon_standard_practice>
which is often called "semicolon standard practice".

#paragraph_tab
Then how about 1-form $omega$? First, let's start with :
$
  nabla_(E_j)(omega^k epsilon^k) &= markul(E_j omega^k epsilon^k, color: #blue, tag: #<change_in_components>) + markul(omega_k nabla_(E_j) epsilon^k, color: #red, tag: #<change_in_basis>) & "by product rule"
  #annot(<change_in_components>, pos: bottom, dx: -1em)[#text(size: 8pt)[change in components]]
  #annot(<change_in_basis>, pos: bottom)[change in basis]
$ <product_rule_for_covector_omega>

Let's focus on the second term of @product_rule_for_covector_omega. How can we compute it? first let's start from :
$
  chevron.l epsilon^k, E_l chevron.r= delta_l^k
$
Since $delta_l^k$ is constant, $nabla_(E_j) chevron.l epsilon^k, E_l chevron.r=0$. We use it with applying the product rule of connection.
#flowbox[
  $
    chevron.l nabla_(E_j) epsilon^k, E_l chevron.r + chevron.l epsilon^k, markrect(nabla_(E_j) E_l, color: #blue, tag: #<christoffel_symbol>) chevron.r= 0
  $ #annot(<christoffel_symbol>, pos: bottom + right)[$Gamma^(m)_(j l) E_m$]

  $arrow.b$

  $
    chevron.l nabla_(E_j) epsilon^k, E_l chevron.r & = -chevron.l epsilon^k, Gamma^(m)_(j l) E_m chevron.r \
                                                   & = -Gamma^(m)_(j l) chevron.l epsilon^k, E_m chevron.r \
                                                   & = -Gamma^(m)_(j l) delta_m^k \
                                                   & = -Gamma^(k)_(j l)
  $ <result_of_product_rule_of_connection_covector>
]

Now, let's interpret @result_of_product_rule_of_connection_covector. What does $chevron.l nabla_(E_j) epsilon^k, E_l chevron.r = -Gamma^(k)_(j l)$ mean? By @the_total_covariant_derivative_is_a_tensor_field, We know that $nabla_(E_j) epsilon^k$ is also the tensor. By the definition of tensor, we can represent $nabla_(E_j) epsilon^k$ as $sum C_i epsilon^i$ for some $C_i in C^infinity (M)$. Thus $chevron.l nabla_(E_j) epsilon^k, E_l chevron.r = -Gamma^(k)_(j l)$ means that $-Gamma^(k)_(j l)$ is the coefficients of $epsilon^l$ which is $C_l$.#footnote[Becuase $sum C_i epsilon^i (E_l) = C_l delta_i^l$] Thus, we have :
$
  nabla_(E_j) epsilon^k = sum_(l) -Gamma^(k)_(j l) epsilon^l
$

Hence we finally have :
$
  nabla omega&:=omega_(i;j)epsilon^i times.o epsilon^j, quad & "with" omega_(i;j):=E_j omega_i - omega_k Gamma^(k)_("ji")
$ <covector_semi-colon_convention>

#note(title: [semi-cololon convensention and $nabla$])[Now, we know that the semi-colon convention is the components of total covariant derivative of covector, or covariant derivative of vector field. whatever it is, the semi-colon convention is directly related to $nabla$.] <semicolon_convention_is_related_to_nabla>
