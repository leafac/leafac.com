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

The term is not a `board` because `*` is not a `position`.

* * *

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

Advanced Pattern Matching
=========================

All operations we have covered rely on terms *matching* patterns, but it is often useful to query whether a term *does not match* a pattern, and PLT Redex does not support it. One workaround is to [unquote](other-features), escape back to Racket and use the `redex-match?` form. For example, the following listing defines the `not-peg?` predicate relation, which holds for `position`s other than a `peg`:

```racket
(define-relation peg-solitaire
  not-peg? ⊆ position
  [(not-peg? position) ,(not (redex-match? peg-solitaire peg (term position)))])

(test-equal (term (not-peg? ●))
            #f)
(test-equal (term (not-peg? ○))
            #t)
(test-equal (term (not-peg? ·))
            #t)
```

* * *

Similarly, PLT Redex does not include patterns for data structures other than S-expressions, for example, hashes and sets. One workaround is the same as before, to `unquote`, but models that `unquote` too often quickly become unreadable. The best solution is to approximate these data structures using S-expressions, for example, hashes become association lists<label class="margin-note"><input type="checkbox"><span markdown="1">Lists of pairs.</span></label> and sets become lists. The downside of this approach is that the model must provide utilities for manipulating these data structures (adding elements, looking up, and so forth) while guaranteeing the invariants, for example, that set elements are distinct.

Customized Typesetting
======================

PLT Redex includes many features to customize typesetting, but they can be hard to learn and have their shortcomings. For example, there is not way to change the arrangement of antecedents on a predicate relation—they always appear on the same line. Also, the paper size is fixed, and big definitions may not fit. In general, the figures require post-processing before they can appear on a paper: trimming, rearranging and so forth. I recommend [`pdfcrop`](http://pdfcrop.sourceforge.net) for simple trimming, [Inkscape](https://inkscape.org/) for more complex manipulation and [`pdf2svg`](http://www.cityinthesky.co.uk/opensource/pdf2svg/) for when the figure must appear on a web page.

Formal Proofs
=============

PLT Redex is a lightweight modeling tool, not a theorem prover or model checker. It can [check](other-features#testing) propositions to increase your confidence in them with little effort, but if you need mechanized formal proofs, use tools like [Coq](https://coq.inria.fr).
