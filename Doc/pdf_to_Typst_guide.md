two alphabets symbols are not supported in typst. instead, use seperation. for example :
```
$T M$, not $TM$
```


The colored texts should be converted using `#highlighted` or `#highlight`. look up `code_style_guide.md` to check the different useage of them.


use the equation code blocks sufficiently.

if the images exist, markes the image location using comments. for example :
```typst
// Figure (put the numbering of figure) is here!
```


in the `cancel()`function, we cannot use `,`, instead use `comma`.

`\frac{}{}` isn't used in Typst. instead, use `frac(,)`. for example :
```typst
$frac(1,2)$
```
