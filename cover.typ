#import "Styles/styles.typ": *
#import "build-info.typ": document-version-check-url, document-pdf-url, document-source-url

#context {
  let theme = theme-from-text-fill()

  set page(margin: (x: 2in, y: 2in), fill: theme.page, footer: none, header: none)
  set par(justify: false)

  v(1fr)

  align(center)[
    // Top decoration
    #line(length: 100%, stroke: (thickness: 2pt, paint: theme.rule))
    #v(0.2em)
    #line(length: 100%, stroke: (thickness: 0.5pt, paint: theme.rule))
    
    #v(2.5em)
    
    // Title
    #text(font: "New Computer Modern", size: 38pt, weight: "bold", fill: theme.rule)[
      Partial Differential \ Equations
    ]
    
    #v(2.5em)
    
    // Bottom decoration
    #line(length: 100%, stroke: (thickness: 0.5pt, paint: theme.rule))
    #v(0.2em)
    #line(length: 100%, stroke: (thickness: 2pt, paint: theme.rule))
    
    #v(4em)
    
    // Subtitle
    #text(font: "New Computer Modern", size: 16pt, style: "italic", fill: theme.subtle-text)[
      An In-Depth Mathematical Formulation
    ]
    
    #v(5em)
    
    // Author
    #text(font: "New Computer Modern", size: 20pt)[*Kim Taeyoung*]
  ]

  pagebreak()

  align(center)[
    #v(1fr)
    
    #text(font: "New Computer Modern", size: 22pt, fill: theme.muted-text)[
      #set math.equation(numbering: none)
      $ (partial u)/(partial t) - alpha nabla^2 u = f(x, t) $
    ]
    
    #v(1.5fr)
    
    // Publisher / Affiliation
    #text(font: "New Computer Modern", size: 14pt, weight: "bold", tracking: 0.1em, fill: theme.rule)[
      DEPARTMENT OF PHYSICS, SOONGSIL UNIVERSITY
    ]
    #v(0.5em)
    #text(font: "New Computer Modern", size: 12pt, fill: theme.muted-text)[
      #datetime.today().display("[year]")
    ]
    #v(1em)
    #text(font: "New Computer Modern", size: 8.5pt, fill: theme.muted-text)[
      #link(document-version-check-url)[Check latest version] | #link(document-pdf-url)[Download latest PDF] | #link(document-source-url)[Source]
    ]
  ]

  pagebreak()
  set page(margin: auto, fill: theme.page)
  outline(title: "Contents", depth: 3)
}
