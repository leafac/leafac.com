---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

<aside markdown="1">
Download the [code](playing-the-game-with-plt-redex.zip) and follow along in [DrRacket](https://racket-lang.org).
</aside>

Terms represent elements in the game, for example, the pegs and the board.<label class="margin-note"><input type="checkbox"><span markdown="1">When working with programming languages, terms are program fragments, types, machine states, and so forth.</span></label> In general, terms can be various Racket values, including numbers, strings and symbols:

```racket
> (term 0)
0
> (term "a")
"a"
> (term a)
'a
```

We can represent pegs with `●` and holes with `○` because Racket supports Unicode:

```racket
> (term ●)
'●
> (term ○)
'○
```

We can group pegs and holes together in lists:

```racket
> (term (● ● ○))
'(● ● ○)
```

We can assign terms to Racket names and refer to them later:

```racket
> (define peg (term ●))
> peg
'●
```

Alternatively, we can assign terms to PLT Redex names and refer to them later:

```racket
> (define-term hole ○)
> (term hole)
'○
```

The `define-term` form *is not* a shorthand for `(define ___ (term ___))` because names defined with `define-term` are only available in other terms, not directly in Racket. In the interaction above, we must write `(term hole)` to access the name `hole` defined with `define-term`. If we try to access the name `hole` directly in Racket, the result is a syntax error:

```racket
> hole
hole: illegal use of syntax in: hole
```

The converse also holds: names defined with `define` are only available directly in Racket, not in terms. So trying to access the name `peg` defined with `define` in a term is not a syntax error, but does not produce the result you might expect:

```racket
> (term peg)
'peg
```

In the interaction above, `peg` in `term` is interpreted as a symbol, not as a reference to the Racket variable `peg`. This is a common pitfall, so pay attention to the two different contexts when working in PLT Redex and do not mix Racket names with terms.

We can *escape* from terms back to Racket with `unquote`, which is written with a comma (`,`),<label class="margin-note"><input type="checkbox"><span markdown="1">The `term` form is similar to the [quasiquote](https://docs.racket-lang.org/guide/qq.html), but it is aware of names defined with `define-term` and the other forms we will see in the next sections, for example, metafunctions and relations.</span></label> for example:

```racket
> (term (1 2 ,(+ 1 2)))
'(1 2 3)
```

In the interaction above, the `,(+ 1 2)` form means “*escape* from the term back to Racket, compute `(+ 1 2)` and place the result here.”

With `unquote` we can access names defined with `define` from within terms and mix them with names defined with `define-term`, for example:

```racket
> (term (● ,peg hole))
'(● ● ○)
```

We can use the `term` form from within `unquote`:

```racket
> (term (● ,peg ,(term hole)))
'(● ● ○)
```

* * *

In summary:

- Names defined with `define` are naturally available in Racket, but can be accessed in terms with `unquote`, for example, `,peg`.
- Names defined with `define-term` are naturally available in terms, but can be accessed in Racket with `term`, for example, `(term hole)`.

Boards
======

We represent Peg Solitaire boards as terms. A board is a list of rows, and a row is a list of positions. A position might be either a *peg* (`●`) or a *hole* (`○`). We also need to pad the spaces around the board, so we introduce a third kind of position, a *space* (`·`).<label class="margin-note"><input type="checkbox"><span markdown="1">A space is represented by a middle dot (`·`), not to be confused with a dot (`.`).</span></label> For example, the following is the initial board:

```racket
(define-term initial-board
  ([· · ● ● ● · ·]
   [· · ● ● ● · ·]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [· · ● ● ● · ·]
   [· · ● ● ● · ·]))
```
