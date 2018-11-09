---
layout: default
title: Playing the Game with PLT Redex
date: 2018-09-30
table-of-contents: true
---

At a high level, PLT Redex is a tool for manipulating and visualizing S-expressions (identifiers, numbers, strings, lists, and so forth), which PLT Redex calls *terms*. In programming languages, terms represent programs and program fragments, types, machine states, and so forth. In Peg Solitaire, terms represent pegs, boards, and so forth. We use the [`term`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=term#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._term%29%29) form to construct terms from Racket values, for example:

<aside markdown="1">
PLT Redex includes a testing framework with the [`(test-equal e₁ e₂)`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=test-equal#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._test-equal%29%29) form, which we use to indicate that `e₁` evaluates to `e₂`.
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

We represent pegs with `●` and spaces with `○`:

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

We can assign terms to names in PLT Redex with the [`define-term`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=define-term#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-term%29%29) form. We can then refer to these names in other terms:

```racket
(define-term a-peg ●)
(test-equal (term a-peg)
            '●)
```

* * *

We represent<label class="margin-note"><input type="checkbox"><span markdown="1">We choose this representation because it is visually appealing, but it is not the only possibility. For example, we could represent pegs as 1s and spaces as 0s, in which case the whole board would be a just a (binary) number.</span></label> a Peg Solitaire board as a list of rows; a row as a list of positions; and a position as either a peg (`●`), a space (`○`) or a padding (`·`). The following are examples of boards:

<aside markdown="1">
1. The delimiters `()` and `[]` are equivalent in Racket. We improve readability by delimiting board rows with `[]` and the whole board with `()`.
2. A padding is represented by a middle dot (`·`), not by a regular dot (`.`).
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

And the following is an example of a winning board:

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

* * *

We will use these boards for testing in later sections, so we [`provide`](https://docs.racket-lang.org/guide/module-provide.html?q=provide) them here:

```racket
(provide example-board-1 example-board-2
         initial-board example-winning-board)
```

Next, we explore the most common operation on terms, [pattern matching](pattern-matching).
