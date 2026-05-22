#import "../Styles/styles.typ" : *

== the Divergence of a Vector Field

#paragraph_tab 
As we know from Proposition 16.33 of _Introduction to Smooth Manifolds_, the divergence operator can be written:
$ Z_X V = ( op("div") X) omega = d(i_X omega) $

Now, let's treat $omega$ as the Riemannian volume form. Then we can combine the above equations and the basic properties of Riemannian volume form.
#flowbox[
$ 
omega  = sqrt(det(g)) d x_1 and dots and d x_n #dots_space #footnote[by proposition 15.31 of _Introduction to Smooth Manifolds_]
\
arrow.b
\
"How about" d(i_X omega)?
$
]

#paragraph_tab
To compute $d(i_X omega)$, let's decompose $X$ to $X = sum_j^n X^j partial_j$. Then $i_X omega$ is:
$
i_X omega &= i_(sum_j^n X^j partial_j) omega \
&= sum_j^n X^j (i_(partial_j) omega) & "by the bilinearity of " i
$

Thus the problem boils down to compute $i_(partial_j) omega$. If we compute it directly, we just get nothing special, in other words, it is useless.
The problem is more complicated. If we adopt this method, we will struggle to compute its exterior derivative.

By the way, if we use (pull) $d x^j$ on the first slot of blade, then the problem would be more clear
$ omega = sqrt(det g) (-1)^(j-1) d x^j and d x^1 and dots and hat(d x^j) and dots and d x^n 
#dots_space #footnote[Where hat operator represent the omitted term]

$ 

#highlighted[
This approach makes that we can treat $i_(partial_j) omega$ as just the general interior multiplication not considering $d x^i(partial_j) = delta_j^i$!
]

Define $f := sqrt(det g) (-1)^(j-1)$ and $beta := (d x^1 and dots and hat(d x^j) and dots and d x^n)$ then
$
i_(partial_j) omega &= f [ i_(partial_j) (d x^j) and beta + (-1)^(deg d x^j) d x^j and i_(partial_j) (beta) ] \
&= f beta 
#dots_space #footnote[by Lemma 14.13 of _Introduction to Smooth Manifolds_ because $d x^j(partial_j) = 1$, $beta$ doesn't have $d x^j$]
$ 

$ therefore i_X omega = sum_j (-1)^(j-1) X^j sqrt(det g) d x^1 and dots and hat(d x^j) and dots and d x^n $


#paragraph_tab
Now, let's compute $d(i_X omega)$.

$
d(i_X omega) &= sum_j (-1)^(j-1) d(X^j sqrt(det g)) and d x^1 and dots and hat(d x^j) and dots and d x^n \
&= sum_j (-1)^(j-1) [ sum_i partial_i (X^j sqrt(det g)) d x^i ] and d x^1 and dots and hat(d x^j) and dots and d x^n &

#dots_space
#footnote[by the definition of exterior derivative because $X^j sqrt(det g)$ are just the coefficients]
$

$ = sum_(i,j) (-1)^(j-1) [partial_i (X^j sqrt(det g))] d x^i and d x^1 and dots and hat(d x^j) and dots and d x^n 
#dots_space #footnote[by bilinearity of wedge product]
$ 

#note[The non-zero terms are when $i=j$.]

$ = sum_i [partial_i (X^i sqrt(det g))] d x^i and dots and d x^n &
#dots_space #footnote[pulling $d x^j$ to the front, then only $i=j$ terms survive]
$ 

#paragraph_tab
Finally, we can directly compare $(op("div") X)omega$ with $d(i_X omega)$!
$
(op("div") X) omega &= (op("div") X) sqrt(det(g)) d x_1 and dots and d x_n \
d(i_X omega) &= ( sum_i partial_i (X^i sqrt(det g)) ) d x^1 and dots and d x^n \
therefore op("div") X &= 1 / sqrt(det g) partial_j (sqrt(det g) thick X^j) 
#dots_space #footnote[where the summation convention is used.]
$ <formula_of_divergence>