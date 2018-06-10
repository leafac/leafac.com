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

We represent pegs with `●` and spaces with `○`:<label class="margin-note"><input type="checkbox"><span markdown="1">Racket supports Unicode.</span></label>

```racket
(test-equal (term ●)
            '●)
(test-equal (term ○)
            '○)
```

We can group pegs and spaces together in lists:

```racket
(test-equal (term (● ● ○))
            '(● ● ○))
```

We can assign terms to PLT Redex names with the `define-term` form and refer to them in `term`s:

```racket
(define-term a-peg ●)
(test-equal (term a-peg)
            '●)
```

Boards
======

We represent<label class="margin-note"><input type="checkbox"><span markdown="1">We choose this representation because it is visually compelling, but it is not the only one. For example, we could represent pegs as 1s and spaces as 0s, in which case the whole board would be a just a (binary) number.</span></label> a Peg Solitaire board as a list of rows; a row as a list of positions; and a position as either a peg (`●`), a space (`○`) or a padding that does not influence game play (`·`).<label class="margin-note"><input type="checkbox"><span markdown="1">A padding is represented by a middle dot (`·`), not to be confused with a dot (`.`).</span></label>

The following are examples of boards:

<aside markdown="1">
In Racket, `[square brackets]` are delimiters equivalent to `(parentheses)`. We use square brackets to delimit rows for readability.
</aside>

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

The following is an example of a winning board:

```racket
(define-term example-winning-board
  ([· · ○ ○ ○ · ·]
   [· · ○ ○ ○ · ·]
   [○ ○ ○ ○ ○ ○ ○]
   [○ ○ ○ ● ○ ○ ○]
   [○ ○ ○ ○ ○ ○ ○]
   [· · ○ ○ ○ · ·]
   [· · ○ ○ ○ · ·]))
```

We will use these boards in the following sections:

```racket
(provide example-board-1 example-board-2 initial-board example-winning-board)
```
