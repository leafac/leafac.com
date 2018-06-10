---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Unquoting
=========

We can assign terms to Racket names and refer to them later:

```racket
(define peg (term ●))
(test-equal peg
            '●)
```

The `define-term` form *is not* a shorthand for `(define ___ (term ___))` because names defined with `define-term` are only available in other terms, not directly in Racket. In the listing above, we must write `(term space)` to access the name `space` defined with `define-term`. If we try to access the name `space` directly in Racket, the result is a syntax error:

```racket
> space
space: illegal use of syntax in: space
```

The converse also holds: names defined with `define` are only available directly in Racket, not in terms. Trying to access the name `peg` defined with `define` in a term is not a syntax error, but does not produce the result you might expect:

```racket
(test-equal (term peg)
            'peg)
```

In the listing above, the `peg` in `term` is interpreted as a symbol, not as a reference to the Racket variable `peg`. This is a common pitfall, so *pay attention to the different contexts and do not mix Racket with terms*.

We can *escape* from terms back to Racket with `unquote`, which is written with a comma (`,`),<label class="margin-note"><input type="checkbox"><span markdown="1">The `term` form is similar to the [quasiquote](https://docs.racket-lang.org/guide/qq.html), but it is aware of names defined with `define-term` and the other forms we will see in the next sections, for example, metafunctions and relations.</span></label> for example:

```racket
(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
```

In the listing above, the `,(+ 1 2)` form means “*escape* from the term back to Racket, compute `(+ 1 2)` and place the result here.”

With `unquote` we can access names defined with `define` from within terms and mix them with names defined with `define-term`, for example:

```racket
(define peg (term ●))
(define-term space ○)
(test-equal (term (● ,peg space))
            '(● ● ○))
```

We can use the `term` form from within `unquote`:

```racket
(test-equal (term (● ,peg ,(term space)))
            '(● ● ○))
```

* * *

In summary:

<div class="full-width no-padding-table" markdown="1">

| | `define` | Racket | terms | `unquote` | `,peg` |
| | `define-term` | terms | Racket | `term` | `(term space)` |
| **Names defined with** | **______________ are available in** | **_______ but can be accessed in** | **_______ with** | **________, for example,** | **_____________** |

</div>

* * *

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
