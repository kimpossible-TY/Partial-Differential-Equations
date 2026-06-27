#import "../Styles/styles.typ": *

#heading(level:1, numbering: none, outlined: false)[Notation]

#heading(level: 2, numbering: none, outlined: false)[Upper and lower indices]

#paragraph-tab
In this note, the position of an index is part of the notation, not only a typographical choice.
For a vector field $X$, an upper index denotes a component of the vector field with respect to a local frame:
$
  X = X^i partial_i
$
Thus $X^i$ is the $i$-th component of $X$.

#paragraph_tab
For a covector field, however, an upper index does not mean a component of the covector field. A covector field is written with lower-index components:
$
  omega = omega_i d x^i
$
Here $omega_i$ is the $i$-th component of $omega$, while $d x^i$ is the $i$-th coordinate covector basis element. Therefore, the upper index in $d x^i$ labels the basis covector, not a component of $omega$.

#paragraph_tab
More generally, lower and upper indices record the tensor type of the object. For example, a $(1, 1)$-tensor can be written as
$
  T = T^i_j partial_i times.o d x^j,
$
where the upper index belongs to the vector part and the lower index belongs to the covector part.

#paragraph_tab
The same upper-lower convention is also used for covariant derivatives. If $Y = Y^i E_i$ is a vector field, then the total covariant derivative $nabla Y$ is a $(1, 1)$-tensor field. Its components are written
$
  nabla Y = Y^(i)_(;j) E_i times.o epsilon^j,
$
where the upper index $i$ is the component index of the output vector part, and the lower index after the semicolon $j$ records the direction of differentiation:
$
  Y^(i)_(;j) = (nabla_(E_j) Y)^i.
$

#paragraph_tab
For a covector field $omega = omega_i epsilon^i$, the total covariant derivative $nabla omega$ is a $(0, 2)$-tensor field:
$
  nabla omega = omega_(i;j) epsilon^i times.o epsilon^j.
$
Here $i$ is the covector component index, while $j$ is again the covariant derivative direction. Thus the index after the semicolon is not an original component index of $omega$; it is added by the covariant derivative.

#paragraph_tab
When a metric is available, this derivative-direction index can be raised by the inverse metric. For example,
$
  nabla^j = g^(j k) nabla_k,
$
so an upper derivative index means that the covariant derivative direction has been raised. In this sense, lower derivative indices are covariant derivative indices, and upper derivative indices are contravariant derivative indices obtained by metric contraction.
