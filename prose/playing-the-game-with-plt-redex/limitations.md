---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Debugging
=========

When things go wrong while you are developing your model, PLT Redex generally has little more to say than “relation does not hold,” or “term does not match pattern.” It does not say *why*: which clauses it tried to match, why they failed, and so forth. We are left with rudimentary debugging techniques, for example, using the `redex-match?` form to check parts of terms and patterns, and using `side-condition`s to trace the execution of metafunctions and reduction relations.

The following listing exemplifies a typical debugging session investigating why a term is not a `board` by reducing terms and patterns:

<div class="code-block" markdown="1">
`limitations.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt"
         "predicate-relations.rkt" "reduction-relations.rkt")

(test-equal
 (redex-match? peg-solitaire board (term ([· ● ● ● ·]
                                          [· ● * ● ·])))
 #f)
(test-equal
 (redex-match? peg-solitaire (row ...) (term ([· ● ● ● ·]
                                              [· ● * ● ·])))
 #f)
(test-equal
 (redex-match? peg-solitaire row (term [· ● ● ● ·]))
 #t)
(test-equal
 (redex-match? peg-solitaire row (term [· ● * ● ·]))
 #f)
(test-equal
 (redex-match? peg-solitaire position (term *))
 #f)
```
</div>

To investigate a metafunction, predicate relation, judgment form or reduction relation we can use `side-condition` to display intermediary terms and trace execution, for example, the following is a variation of the `→*` judgment form instrumented to trace the intermediary board in the **Transitivity** clause:

```racket
(define-judgment-form peg-solitaire
  #:mode (→*′ I O)
  #:contract (→*′ board board)

  [---------------- "Reflexivity"
   (→*′ board board)]

  [(→            board_1 board_2)
   (side-condition ,(displayln (term board_2)))
   (→*′ board_2 board_3)
   -------------------------------------------- "Transitivity"
   (→*′ board_1 board_3)])
```

We can see the trace when we query the judgment form, for example:

```racket
> (judgment-holds (→*′ ([● ● ○ ●]) ([○ ● ○ ○])))
((○ ○ ● ●))
((○ ● ○ ○))
#t
```

The first two lines of output are the intermediary `board_2` in the two applications of the **Transitivity** rule. The last line is the query output, true, meaning the judgment form holds.

Performance
===========

An executable model is not an implementation. PLT Redex is good for visualizing and understanding a model on relatively small inputs. It can scale to moderately sized inputs if we design patterns and relations carefully, but it can never replace a performance-tuned implementation.

As an example of a declarative definition that does not scale for being too naïve, consider the following function to find winning boards:

```racket
(define (winning-boards start-board)
  (filter (λ (board) (judgment-holds (winning-board? ,board)))
          (apply-reduction-relation* ⇨ start-board)))
```

The `winning-boards` function works by applying the [`⇨` reduction relation](reduction-relations) to find all boards reachable by one or more moves starting from `start-board`. It then filters the winning boards among them with the [`winning-board?` predicate relation](predicate-relations). This strategy is straightforward and works for small boards, for example:

```racket
(test-equal (winning-boards (term ([● ● ○ ●])))
            '(([○ ● ○ ○])))
```

But it does not scale to the [`initial-board`](terms):

```racket
(winning-boards (term initial-board))
;; ∞ ...
```
