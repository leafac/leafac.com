---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

<aside markdown="1">
Download the [code](playing-the-game-with-plt-redex.zip) and follow along in [DrRacket](https://racket-lang.org).
</aside>

At its core, PLT Redex is a tool for manipulating and visualizing terms. In our game of Peg Solitaire, terms represent the pegs and the board.<label class="margin-note"><input type="checkbox"><span markdown="1">When working with programming languages, terms represent program fragments, types, machine states, and so forth.</span></label> In general, terms can be various Racket values, including numbers, strings and symbols:

<aside markdown="1">
PLT Redex includes a testing framework with the `(test-equal e_1 e_2)` form, which we use to indicate that `e_1` evaluates to `e_2`.
</aside>

<div class="code-block" markdown="1">
`terms.rkt`
```racket
#lang racket
(require redex)

(test-equal (term 0)
            0)
(test-equal (term "a")
            "a")
(test-equal (term a)
            'a)
```
</div>

We represent pegs with `●` and holes with `○`:<label class="margin-note"><input type="checkbox"><span markdown="1">Racket supports Unicode.</span></label>

```racket
(test-equal (term ●)
            '●)
(test-equal (term ○)
            '○)
```

We can group pegs and holes together in lists:

```racket
(test-equal (term (● ● ○))
            '(● ● ○))
```

We can assign terms to Racket names and refer to them later:

```racket
(define peg (term ●))
(test-equal peg
            '●)
```

Alternatively, we can assign terms to PLT Redex names and refer to them later:

```racket
(define-term hole ○)
(test-equal (term hole)
            '○)
```

The `define-term` form *is not* a shorthand for `(define ___ (term ___))` because names defined with `define-term` are only available in other terms, not directly in Racket. In the listing above, we must write `(term hole)` to access the name `hole` defined with `define-term`. If we try to access the name `hole` directly in Racket, the result is a syntax error:

```racket
> hole
hole: illegal use of syntax in: hole
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
(define-term hole ○)
(test-equal (term (● ,peg hole))
            '(● ● ○))
```

We can use the `term` form from within `unquote`:

```racket
(test-equal (term (● ,peg ,(term hole)))
            '(● ● ○))
```

* * *

In summary:

<div class="full-width no-padding-table" markdown="1">

| | `define` | Racket | terms | `unquote` | `,peg` |
| | `define-term` | terms | Racket | `term` | `(term hole)` |
| **Names defined with** | **______________ are available in** | **_______ but can be accessed in** | **_______ with** | **________, for example,** | **_____________** |

</div>

Boards
======

We represent<label class="margin-note"><input type="checkbox"><span markdown="1">We choose this representation because it is visually compelling, but it is not the only one. For example, we could represent pegs as 1s and holes as 0s, in which case the whole board would be a just a (binary) number.</span></label> a Peg Solitaire board as a list of rows; a row as a list of positions; and a position as either a peg (`●`), a hole (`○`) or a padding space that does not influence game play (`·`).<label class="margin-note"><input type="checkbox"><span markdown="1">A space is represented by a middle dot (`·`), not to be confused with a dot (`.`).</span></label>

The following are examples of boards:

```racket
(define-term example-board-1
  ([· · ● ● ● · ·]
   [· · ● ● ○ · ·]
   [● ○ ● ○ ● ● ●]
   [● ● ● ○ ○ ○ ●]
   [● ○ ● ● ● ● ●]
   [· · ● ○ ● · ·]
   [· · ● ● ● · ·]))

(define-term example-board-2
  ([· · ● ○ ● · ·]
   [· · ● ● ○ · ·]
   [● ○ ● ○ ● ● ●]
   [● ● ● ○ ○ ○ ●]
   [● ○ ● ● ○ ● ●]
   [· · ● ○ ● · ·]
   [· · ○ ● ● · ·]))
```

The following is the initial board:

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

We will use these boards in the following sections:

```racket
(provide example-board-1 example-board-2 initial-board)
```
