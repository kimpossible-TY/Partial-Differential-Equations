#import "../../Styles/styles.typ": *
#import "@preview/cetz:0.4.2"

=== Jacobi's Formula

#paragraph_tab
Jacobi's formula describes how the determinant varies along a differentiable family of matrices.

#proposition(title: "Jacobi's formula")[
  Let $A(t)$ be a differentiable curve in the space of $n times n$ matrices. If $A(t)$ is invertible, then
  $
    d/(d t) det(A(t)) = det(A(t)) op("tr")(A(t)^(-1) A'(t)).
  $
  where $A'(t)$ means $frac(d, d t) A(t)$
] <Jacobis_formula>

#proof[
  #local-scope-annotations(s=>[
    Let $F(A):= op("det") A$. THen we want :
    $
      lr(frac(d, d t) bar)_(t=t_0) F(A(t))=lim_(h arrow 0) frac(F(A(t_0 + h))- F(A(t_0)), h)
    $
    Now, set $A:= A(t_0)$ and $K:= A'(t_0)$. Since $A(t)$ is differentiable, we get the following equation by matrix version of Taylor's expansion.
    $
      A(t_0+h)=A+h K+ cal(o)(h)
    $
    Therefore, 
    $
      F(A (t_0+h))=F(A+h K+ cal(o)(h))
    $
    and it gives :
    $
      lr(frac(d, d t) bar)_(t=t_0) F(A(t)) &= lr(frac(d, d h) bar)_(h=0) F(A+h K)
      \
      &= D_K F #dots_space #footnote[where $D$ is the directional derivative] 
    $ #(s.tag)("change to directional derivative")

    #paragraph-tab
    As using #(s.ref)("change to directional derivative"), we have 
    $
      lr(frac(d, d t) bar)_(t=t_0) op("det")(A(t)) &= lr(frac(d, d h) bar)_(h=0) op("det")(A+ h K)
    $ #(s.tag)("directional derivative version")
    Since $A$ is invertible and $op("det")$ is bilinear, we have :
    #flowbox()[
      $A+h K=A(I + h A^(-1) K)$

      $arrow.b$

      $
        op("det")(A+h K)= op("det") A dot op("det")(I + A^(-1) K)
      $ #(s.tag)("using bilinearity and invertible")
    ]

    Applying the Leibniz formula to #(s.ref)("using bilinearity and invertible") and Truncate terms of degree two and higher, we get :
    $
      op("det")(I+h A^(-1) K)=I+h op("tr")(A^(-1) K)
      
    $ #(s.tag)("applying Leibniz formula")
    Since $A=A(t_0)$, it is independent of $h$, which induces $frac(d, d h)A = 0$ and $frac(d, d h) op("det") A = 0$.
    #flowbox()[
        $
          lr(frac(d, d t) bar)_(t=t_0) op("det")(A(t)) &= lr(frac(d, d h) bar)_(h=0) op("det")(A+ h K) #dots_space #footnote[from #(s.ref)("directional derivative version")]
          \
          &= lr(frac(d, d h) bar)_(h=0) op("det") A dot op("det")(I + A^(-1) K) #dots_space #footnote[from #(s.ref)("using bilinearity and invertible")]
          \
          &= pmark(lr(frac(d, d h) bar)_(h=0), tag: #(s.tag)("d_dh")) ( rmark(op("det") A, tag: #(s.tag)("det_A")) ) ( bmark(I+h op("tr")(A^(-1) K), tag: #(s.tag)("bracket")) ) #dots_space #footnote[from #(s.ref)("applying Leibniz formula")]
          \
          \
          &= op("det") A dot op("tr")(A^(-1) K) #dots_space #footnote[$frac(d, d h) op("det") A=0$ where $A=A(t_0)$.]

          #(s.annot)(
            ("d_dh", "det_A", "bracket"),
            cetz,
            {
              import cetz.draw: *
              set-style(mark: (end: "straight"))
              
              bezier-through(
                (s.node)("d_dh", "south"),
                (rel: (x: 0.15, y: -0.25)),
                (s.node)("det_A", "south"),
                stroke: red,
              )
              
              bezier-through(
                (s.node)("d_dh", "north"),
                (rel: (x: 0.8, y: 0.35)),
                (s.node)("bracket", "north"),
                stroke: blue,
              )
            },
          )
        $
    ]

  ])
]
