#import "../../Styles/styles.typ": *
#import "@preview/cetz:0.4.2"

=== abstract algebraic approach and differential geometry approach

#local-scope-annotations(s=>[
#lemma(title: "linearity and homomorphism")[
every linear map is homomorphic on vector space.
] <linearity_and_homomorphism>

#proof()[
@linearity_and_homomorphism is automatically proved by the definition of linearity.
]

#lemma(title: "orthogonality and skew-symmetry")[
Let $V$ and $W$ are vector space, and $L$ is a linear map $L : V arrow.r W$. Suppose
$
  chevron.l L v comma v chevron.r=0
$ #(s.tag)("condition of @orthogonality_and_skew-symmetry")
for $v_0, v_1 in V$. Then $L$ is skew-symmetric.
]<orthogonality_and_skew-symmetry>

#proof()[
For symmetry property of metric, the skew-symmetry of $L$ for some vector $v in V$ is easily proved.
#flowbox()[
  $
    chevron.l L v , v chevron.r &=0
    \
    &=chevron.l v, L v chevron.r, quad "by symmetry of metric"
  $

  $arrow.b$

  $
    chevron.l L v, v chevron.r = - chevron.l v, L v chevron.r
  $ #(s.tag)("skew-symmetry only applied single vector")
]
#paragraph-tab
Now, let's expend it to the entire vector space $V$.
#flowbox()[
  $
    0 &=chevron.l L (v_0+v_1), v_0 + v_1 chevron.r = chevron.l L v_0+ L v_1, v_0 + v_1 chevron.r
    \
    &= chevron.l L v_0 + L v_1 , v_0 chevron.r + chevron.l L v_0 + L v_1 , v_1 chevron.r
    \
    &= cancel(chevron.l L v_0 comma v_0 chevron.r )
    + chevron.l L v_1, v_0 chevron.r
    \
    &+ chevron.l L v_0, v_1 chevron.r
    + cancel(chevron.l L v_1 comma v_1 chevron.r)
  $

  $arrow.b$

  $
    chevron.l L v_1, v_0 chevron.r = -chevron.l L v_0 , v_1 chevron.r
  $

  $arrow.b$

  Use #(s.ref)("skew-symmetry only applied single vector")
  $
    therefore chevron.l L v_1, v_0 chevron.r = -chevron.l v_1 , L v_0 chevron.r
  $
]
]


#lemma(title: "linear endomorphism is (1,1)-tensor")[
Let V be a vector space and $F in op("End")(V)$ be a linear map. Then $F$ is (1,1)-tensor.
]<linear_endomorphism_is_tensor>

#proof()[
  $(1,1)$-tensor is :
  $
    V times.o V^(*) &= v times.o alpha
  $
where $V^*$ is dual space of $V$ and $v in V$, $alpha in V^*$. For $omega in V$,
$
  (v times.o alpha ) (omega)= alpha(omega) v in V
$
Since the dual space is naturally exist, so the $(1,1)$-tensor $v times.o alpha$ be.
]
])
