---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

The `→` [judgment form](judgment forms) from the previous section had one input and one output. We say the judgment form was *reducing* the `board` because after each move there are *fewer* possible moves going forward. This specific kind of relation is also know as a *reduction relation*.<label class="margin-note"><input type="checkbox"><span markdown="1">Like judgment forms, reduction relations compute nondeterministically.</span></label> PLT Redex supports reduction relations with the `reduction-relation` form:<label class="margin-note"><input type="checkbox"><span markdown="1">The `reduction-relation` form returns the reduction relation as a value, unlike the forms we discussed so far that assign names, for example, `define-metafunction`, `define-relation` and `define-judgment-form`.</span></label>

```racket
(reduction-relation
  <language>
  #:domain <pattern>

  (--> <pattern> <template> <name>)
  ...)
```

- `<language>`: A language as defined [previously](languages).
- `#:domain`: A contract pattern for the inputs and outputs of the reduction relation. The contract is verified and an error may be raised when the reduction relation is applied.
- `(--> <pattern> <template> <name>)`: A reduction relation clause.
- `<pattern>`: A pattern for the input.
- `<template>`: A template for the output.

We define the `⇨` reduction relation using the same patterns and templates from the `→` judgment form:

<div class="code-block" markdown="1">
`judgment-forms.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define
  ⇨
  (reduction-relation
   peg-solitaire
   #:domain board

   (--> (row_1
         ...
         [position_1 ... ● ● ○ position_2 ...]
         row_2
         ...)
        (row_1
         ...
         [position_1 ... ○ ○ ● position_2 ...]
         row_2
         ...)
        "→")

   (--> (row_1
         ...
         [position_1 ... ○ ● ● position_2 ...]
         row_2
         ...)
        (row_1
         ...
         [position_1 ... ● ○ ○ position_2 ...]
         row_2
         ...)
        "←")

   (--> (row_1
         ...
         [position_1 ..._n ● position_2 ...]
         [position_3 ..._n ● position_4 ...]
         [position_5 ..._n ○ position_6 ...]
         row_2
         ...)
        (row_1
         ...
         [position_1 ...   ○ position_2 ...]
         [position_3 ...   ○ position_4 ...]
         [position_5 ...   ● position_6 ...]
         row_2
         ...)
        "↓")

   (--> (row_1
         ...
         [position_1 ..._n ○ position_2 ...]
         [position_3 ..._n ● position_4 ...]
         [position_5 ..._n ● position_6 ...]
         row_2
         ...)
        (row_1
         ...
         [position_1 ...   ● position_2 ...]
         [position_3 ...   ○ position_4 ...]
         [position_5 ...   ○ position_6 ...]
         row_2
         ...)
        "↑")))
```
</div>

We apply the reduction relation with the `apply-reduction-relation` form. It nondeterministically computes all the possible boards after one move:

```racket
(test-equal (apply-reduction-relation ⇨ (term initial-board))
            '(((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ● ● ● ● ● ●)
               (● ● ● ○ ● ● ●)
               (· · ● ○ ● · ·)
               (· · ● ● ● · ·))

              ((· · ● ● ● · ·)
               (· · ● ○ ● · ·)
               (● ● ● ○ ● ● ●)
               (● ● ● ● ● ● ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·))

              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ● ● ● ○ ○ ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·))

              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ○ ○ ● ● ● ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·))))
```

We apply the reduction relation one or more times with the `apply-reduction-relation*` form. This outputs the same as the `→*` judgment form, except that the input in not present in the output:<label class="margin-note"><input type="checkbox"><span markdown="1">Mathematicians call this the *transitive closure* of the `⇨` reduction relation, as opposed to `→*`, which was the *reflexive*, transitive closure of the `→` relation.</span></label>

```racket
(test-equal (apply-reduction-relation* #:all? #t ⇨ (term ([● ● ● ○ ● ● ●])))
            '(((○ ○ ● ○ ● ○ ●))

              ((● ○ ○ ● ● ● ●))

              ((● ○ ● ○ ○ ● ●))

              ((● ○ ● ○ ● ○ ○))

              ((● ● ○ ○ ● ○ ●))

              ((● ● ● ● ○ ○ ●))))
```

We can also query just the *final* boards, in which no further moves are possible by omitting the `#:all?` keyword:

```racket
(test-equal (apply-reduction-relation* ⇨ (term ([● ● ● ○ ● ● ●])))
            '(((○ ○ ● ○ ● ○ ●))

              ((● ○ ● ○ ● ○ ○))))
```

* * *

We will use the reduction relation in later sections:

```racket
(provide ⇨)
```
