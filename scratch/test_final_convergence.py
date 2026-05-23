import subprocess

# Read 2.5.typ
with open("chapter 2/2.5.typ", "r") as f:
    content = f.read()

# Define the new content
new_content = """  First, let's compute $frac(partial f_Q, partial xi_j)$#footnote[where the summation convention is used.]. Differentiate with respect to $xi_j$ is :
  #mannot-scope(l=> [
    $
      frac(partial f_Q, partial xi_j)&=gamma g^(a b) mark(frac(partial, partial xi_j), tag: #(l.tag)("derivative")) (rmark(xi_a, tag: #(l.tag)("xi_a")) bmark(xi_b, tag: #(l.tag)("xi_b")))
      \\
      \\
      &= gamma g^(a b)(delta^j_a xi_b + xi_a delta^j_b)
      \\
      &= gamma g^(j b) xi_b + gamma g^(a j) xi_a
      \\
      &= 2 sum^n_(k=1) gamma g^(j k) xi_k
    $

    #(l.annot)(
      ("derivative", "xi_a", "xi_b"),
      cetz,
      {
        import cetz.draw: *
        set-style(mark: (end: "straight"))

        bezier-through(
          (l.node)("derivative","south"),
          (rel : (x:0.3, y: -0.3)),
          (l.node)("xi_a", "south"),
          stroke: red
        )

        bezier-through(
          (l.node)("derivative","south"),
          (rel : (x:0.5, y: -0.5)),
          (l.node)("xi_b", "south"),
          stroke: blue
        )
      }
    )
  ])

  #paragraph_tab
  Note that $xi$ represents the spatial differential of $u$, we have $xi_k=partial_k u$#footnote[becuase $a$ and $b$ are dummy indices and $g^(a j)=g^(j a)$ by the symmetric property of metric. Note that $j$ isn't dummy index.]. it induces :"""

# Replace in content
target = """  First, let's compute $frac(partial f_Q, partial xi_j)$. Differentiate with respect to $xi_j$ is :
  #mannot-scope(l=> [
    $
      frac(partial f_Q, partial xi_j)&=gamma g^(a b) mark(frac(partial, partial xi_j), tag: #(l.tag)("derivative")) (rmark(xi_a, tag: #(l.tag)("xi_a")) bmark(xi_b, tag: #(l.tag)("xi_b"))) #dots_space #footnote[where the summation convention is used.]
      \\
      \\
      &= gamma g^(a b)(delta^j_a xi_b + xi_a delta^j_b)
      \\
      &= gamma g^(j b) xi_b + gamma g^(a j) xi_a
      \\
      &= 2 sum^n_(k=1) gamma g^(j k) xi_k #dots_space #footnote[becuase $a$ and $b$ are dummy indices and $g^(a j)=g^(j a)$ by the symmetric property of metric. Note that $j$ isn't dummy index.]
    $

    #(l.annot)(
      ("derivative", "xi_a", "xi_b"),
      cetz,
      {
        import cetz.draw: *
        set-style(mark: (end: "straight"))

        bezier-through(
          (l.node)("derivative","south"),
          (rel : (x:0.3, y: -0.3)),
          (l.node)("xi_a", "south"),
          stroke: red
        )

        bezier-through(
          (l.node)("derivative","south"),
          (rel : (x:0.5, y: -0.5)),
          (l.node)("xi_b", "south"),
          stroke: blue
        )
      }
    )
  ])

  #paragraph_tab
  Note that $xi$ represents the spatial differential of $u$, we have $xi_k=partial_k u$. it induces :"""

if target in content:
    modified = content.replace(target, new_content)
    with open("chapter 2/2.5.typ", "w") as f:
        f.write(modified)
    print("Updated 2.5.typ with footnotes moved outside the equation")
    
    # Compile
    res = subprocess.run(
        ["typst", "compile", "main.typ", "main.pdf"],
        capture_output=True,
        text=True
    )
    print("Compilation exit code:", res.returncode)
    print("Stderr:")
    print(res.stderr)
else:
    print("Could not find the target block in 2.5.typ")
