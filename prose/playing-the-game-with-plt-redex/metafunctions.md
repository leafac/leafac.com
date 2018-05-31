---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

A metafunction is a function in the level of terms.<label class="margin-note"><input type="checkbox"><span markdown="1">When working with programming languages, metafunctions are the small utilities, for example, `δ`, which evaluates primitive operators.</span></label> We define a metafunction with the `define-metafunction` form:<label class="margin-note"><input type="checkbox"><span markdown="1">A metafunction is similar to `define/match` in that it compares the inputs to patterns and executes the first clause that matches. More generally, it is similar to `case` and `cond`.</span></label>

```racket
(define-metafunction <language>
  <contract>
  [(<metafunction> <pattern> ...) <template>]
  ...)
```

- `<language>`: A language as defined in the [previous section](languages).
- `<contract>`: A contract with patterns for the inputs and outputs of the metafunction. The contract is verified and an error may be raised when the metafunction is called.
- `<metafunction>`: The metafunction name.
- `[(<metafunction> <pattern> ...) <template>]`: A metafunction clause.
- `<pattern>`: A pattern against which the metafunction input is compared. Patterns are compared in the order they are defined, and the first clause that matches is executed.
- `<template>`: A term that is the output of the metafunction. Names from `<pattern>` are available in the `<template>`.

We define a metafunction over `position`s that inverts the board:<label class="margin-note"><input type="checkbox"><span markdown="1">This metafunction is for demonstration only—we will not use it for playing Peg Solitaire.</span></label>

<div class="code-block" markdown="1">
`metafunctions.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-metafunction peg-solitaire
  invert/position : position -> position
  [(invert/position peg) ○]
  [(invert/position space) ●]
  [(invert/position padding) padding])
```
</div>

In the listing above, we define the `invert/position` metafunction for the `peg-solitaire` language. Its input and output are `position`s. The `invert/position` metafuction compares the input to each of the patterns in turn: `peg`, `space` and `padding`. The first pattern that matches determines the metafunction output: `○`, `●` and `·`, respectively. The last clause exemplifies how a name in the pattern (`padding`) is available in the template.

We use a metafunction by applying it in the level of terms:

```racket
(test-equal (term (invert/position ●))
            (term ○))
(test-equal (term (invert/position ○))
            (term ●))
(test-equal (term (invert/position ·))
            (term ·))
```

We can call a metafunction from any place in which a term might appear, including the definition of another metafunction. To illustrate this, consider the following metafunction that inverts a whole board by calling `invert/position`:

```racket
(define-metafunction peg-solitaire
  invert/board : board -> board
  [(invert/board ([position ...] ...))
   ([(invert/position position) ...] ...)])
```

The `invert/board` metafunction matches its input to the pattern `([position ...] ...)`, which represents boards. Its output is the result of calling `invert/position` for each of the `position`s: the ellipses (`...`) after the metafunction call mean “map over the `position`s with the metafunction `invert/position`.” The following is an example of calling the `invert/board` metafunction with the [`initial-board`](terms):

```racket
(test-equal (term (invert/board initial-board))
            (term ((· · ○ ○ ○ · ·)
                   (· · ○ ○ ○ · ·)
                   (○ ○ ○ ○ ○ ○ ○)
                   (○ ○ ○ ● ○ ○ ○)
                   (○ ○ ○ ○ ○ ○ ○)
                   (· · ○ ○ ○ · ·)
                   (· · ○ ○ ○ · ·))))
```
