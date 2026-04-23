#import "Styles/styles.typ": *

#set page(margin: (x: 2in, y: 2in), footer: none, header: none)
#set par(justify: false)

#v(1fr)

#align(center)[
  // Top decoration
  #line(length: 100%, stroke: (thickness: 2pt, paint: rgb("#2c3e50")))
  #v(0.2em)
  #line(length: 100%, stroke: (thickness: 0.5pt, paint: rgb("#2c3e50")))
  
  #v(2.5em)
  
  // Title
  #text(font: "New Computer Modern", size: 38pt, weight: "bold", fill: rgb("#2c3e50"))[
    Partial Differential \ Equations
  ]
  
  #v(2.5em)
  
  // Bottom decoration
  #line(length: 100%, stroke: (thickness: 0.5pt, paint: rgb("#2c3e50")))
  #v(0.2em)
  #line(length: 100%, stroke: (thickness: 2pt, paint: rgb("#2c3e50")))
  
  #v(4em)
  
  // Subtitle
  #text(font: "New Computer Modern", size: 16pt, style: "italic", fill: rgb("#34495e"))[
    An In-Depth Mathematical Formulation
  ]
  
  #v(5em)
  
  // Author
  #text(font: "New Computer Modern", size: 20pt)[*Kim Taeyoung*]
  
  #v(4em)
  
  // Equation decoration
  #text(font: "New Computer Modern", size: 22pt, fill: rgb("#7f8c8d"))[
    #set math.equation(numbering: none)
    $ (partial u)/(partial t) - alpha nabla^2 u = f(x, t) $
  ]
  
  #v(1.5fr)
  
  // Publisher / Affiliation
  #text(font: "New Computer Modern", size: 14pt, weight: "bold", tracking: 0.1em, fill: rgb("#2c3e50"))[
    DEPARTMENT OF PHYSICS, SOONGSIL UNIVERSITY
  ]
  #v(0.5em)
  #text(font: "New Computer Modern", size: 12pt, fill: rgb("#7f8c8d"))[
    #datetime.today().display("[year]")
  ]
]

#pagebreak()
#set page(margin: auto)
#outline(title: "Contents", depth: 3)