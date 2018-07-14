---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

TODO: If pattern matching is like using a regular expression to check whether the string is of a certain kind, then a metafunction is like ‘replace’.

The metafunction is the most familiar of all PLT Redex forms: it is a function on terms.<label class="margin-note"><input type="checkbox"><span markdown="1">When working with programming languages, metafunctions are the small utilities, for example, many papers use a metafunction to evaluate primitive operators—they generally name that metafunction `δ`.</span></label> We define a metafunction with the [`define-metafunction`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=define-metafunction#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-metafunction%29%29) form:<label class="margin-note"><input type="checkbox"><span markdown="1">A metafunction is similar to [`define/match`](https://docs.racket-lang.org/reference/match.html?q=define%2Fmatch#%28form._%28%28lib._racket%2Fmatch..rkt%29._define%2Fmatch%29%29) in that it compares the inputs to patterns and executes the first clause that matches. More generally, it is similar to `case` and `cond`.</span></label>

```racket
(define-metafunction <language>
  <contract>
  [(<metafunction> <pattern> ...) <template>]
  ...)
```

- `<language>`: A language as defined in the [previous section](languages).
- `<contract>`: A contract with patterns for the inputs and outputs of the metafunction. The contract is verified and an error may be raised if the metafunction is called with invalid inputs or produces an invalid output.
- `[(<metafunction> <pattern> ...) <template>]`: A metafunction clause.
- `<metafunction>`: The metafunction name.
- `<pattern>`: Patterns against which the metafunction inputs are compared. Patterns are compared clause by clause in the order they are defined, and the first clause that matches is executed.
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

In the listing above, we define the `invert/position` metafunction for the `peg-solitaire` language. Its input and output are `position`s. The `invert/position` metafuction compares the input to each of the patterns in turn: `peg`, `space`, and `padding`. The first pattern that matches determines the metafunction output: `○`, `●`, and `·`, respectively. The last clause exemplifies how a name in the pattern (`padding`) is available in the template.

We use a metafunction by applying on terms:<label class="margin-note"><input type="checkbox"><span markdown="1">We write `(term (invert/position ●))`, *not* `(invert/position (term ●))`.</span></label>

```racket
(test-equal (term (invert/position ●))
            (term ○))
(test-equal (term (invert/position ○))
            (term ●))
(test-equal (term (invert/position ·))
            (term ·))
```

We can call a metafunction from any place in which a term might appear, including the definition of another metafunction. To illustrate this, consider the following metafunction that inverts a whole board by calling `invert/position` on each position:

```racket
(define-metafunction peg-solitaire
  invert/board : board -> board
  [(invert/board ([position ...] ...))
   ([(invert/position position) ...] ...)])
```

The `invert/board` metafunction matches its input to the pattern `([position ...] ...)`, which represents boards. Its output is the result of calling `invert/position` on each `position`: the ellipses (`...`) after the metafunction call mean “map over the `position`s with the metafunction `invert/position`.” The following is an example of calling the `invert/board` metafunction with the [`initial-board`](terms):

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
