---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Unquoting
=========

We can *escape* from terms back to Racket with `unquote`, which is written with a comma (`,`),<label class="margin-note"><input type="checkbox"><span markdown="1">The `term` form is similar to the [quasiquote](https://docs.racket-lang.org/guide/qq.html), but it is aware of names defined with `define-term` as well as metafunctions, reduction relations and so forth.</span></label> for example:

```racket
(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
```

In the listing above, the `,(+ 1 2)` form means “*escape* from the term back to Racket, compute `(+ 1 2)` and place the result here.”

* * *

[Previously](terms), we used `define-term` to name terms, for example:

```racket
(define-term a-peg ●)
(test-equal (term a-peg)
            '●)
```

We can also assign terms to regular Racket names with `define`, for example:

```racket
(define a-space (term ○))
```

We access this name outside terms as usual:

```racket
(test-equal a-space
            '○)
```

In terms, we unquote to escape back to Racket and access the name, for example:

```racket
(test-equal (term ,a-space)
            '○)
```

* * *

The `define-term` form *is not* a shorthand for `(define ___ (term ___))` because names defined with `define-term` are only available in other terms, not directly in Racket. If we try to access in Racket a name defined with `define-term`, for example, `a-peg`, the result is a syntax error:

```racket
> a-peg
a-peg: illegal use of syntax in: a-peg
```

The converse also holds: names defined with `define` are only available directly in Racket, not in terms. Trying to access the name `a-space` defined with `define` in a term is not a syntax error, but does not produce the result you might expect:

```racket
(test-equal (term a-space)
            'a-space)
```

In the listing above, the `a-space` in `term` is interpreted as a symbol, not as a reference to the Racket variable `a-space`. This is a common pitfall, so *pay attention to the different contexts and do not mix Racket with terms*.

* * *

With `unquote` we can access names defined with `define` from within terms and mix them with names defined with `define-term`, for example:

```racket
(define-term a-peg ●)
(define a-space (term ○))
(test-equal (term (● a-peg ,a-space))
            '(● ● ○))
```

We can use the `term` form from within `unquote`:

```racket
(test-equal (term (● ,(term a-peg) ,a-space))
            '(● ● ○))
```

* * *



* * *

In summary:

<div class="full-width no-padding-table" markdown="1">

| | `define` | Racket | terms | `unquote` | `,peg` |
| | `define-term` | terms | Racket | `term` | `(term space)` |
| **Names defined with** | **______________ are available in** | **_______ but can be accessed in** | **_______ with** | **________, for example,** | **_____________** |

</div>

TODO
====

```racket
redex-check: /Users/leafac/Code/www.leafac.com/prose/playing-the-game-with-plt-redex/other-features.rkt:26
no counterexamples in 1000 attempts
```

```racket
redex-check: /Users/leafac/Code/www.leafac.com/prose/playing-the-game-with-plt-redex/other-features.rkt:31
counterexample found after 125 attempts:
((○) (●) (●))
```

{% include_relative judgment-form.svg %}
