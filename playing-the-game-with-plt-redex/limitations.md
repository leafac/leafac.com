---
layout: default
title: "Playing the Game with PLT Redex"
table-of-contents: true
---

In this section we explore several ways in which PLT Redex falls short.

Debugging
=========

When things go wrong while you are developing your model, PLT Redex generally has little more to say than “relation does not hold,” or “term does not match pattern.” It does not say *why*: which clauses it tried to match, why they failed, and so forth. We are left with rudimentary debugging techniques, for example, using the `redex-match?` form to check parts of terms and patterns, and using `side-condition`s to trace the execution of metafunctions and reduction relations.

The following listing exemplifies a typical debugging session investigating why a term is not a `board` by reducing terms and patterns:

<figure markdown="1">
<figcaption markdown="1">
`limitations.rkt`
</figcaption>
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt"
         "reduction-relations.rkt" "predicate-relations.rkt"
         "judgment-forms.rkt")

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
</figure>

The term is not a `board` because `*` is not a `position`.

Performance
===========

An executable model is not an implementation. PLT Redex is good for visualizing and understanding a model on relatively small inputs. It can scale to moderately sized inputs if we design patterns and relations carefully, but it can never replace a performance-tuned implementation. It has to check contracts, perform nondeterministic computations, and so forth—tasks that are computationally expensive.

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
> (winning-boards (term initial-board))
; Runs for too long
```

Advanced Pattern Matching
=========================

All operations we have covered rely on terms *matching* patterns, but it is often useful to query whether a term *does not match* a pattern, and PLT Redex does not support it. One workaround is to [unquote](other-features#unquoting), escape back to Racket and use the `redex-match?` form. For example, the following listing defines the `not-peg?` predicate relation, which holds for `position`s other than a `peg`:

```racket
(define-relation peg-solitaire
  not-peg? ⊆ position
  [(not-peg? position)
   ,(not (redex-match? peg-solitaire peg (term position)))])

(test-equal (term (not-peg? ●))
            #f)
(test-equal (term (not-peg? ○))
            #t)
(test-equal (term (not-peg? ·))
            #t)
```

Similarly, PLT Redex does not include patterns for data structures other than S-expressions, for example, hashes and sets. One workaround is the same as before, to `unquote`, but models that `unquote` too often quickly become unreadable. The best solution is to approximate these data structures using S-expressions, for example, hashes become association lists (lists of pairs) and sets become lists. The downside of this approach is that the model must provide utilities for manipulating these data structures (adding elements, looking up, and so forth) while guaranteeing the invariants, for example, that set elements are distinct.

Metaparameters
==============

It is common for papers to include a series of definitions which rely on a parameter that remains the same, for example, a parameter that indicates how to allocate addresses. When the context is evident, papers often omit these parameters to improve readability. Because they are parameters in the guest language, we call them *metaparameters*. PLT Redex has no support for metaparameters: we must clutter the definitions by passing them around explicitly or resort to one of a few [other workarounds](https://groups.google.com/forum/#!topic/racket-users/cGRMPIoEZas), but they all have their downsides. Racket includes a feature to solve the issue, [parameters](https://docs.racket-lang.org/guide/parameterize.html), and we can use them with `unquote`, but then our definitions are no longer *pure*, they may output different results when given the same (explicit) inputs, so we must [turn off PLT Redex’s cache](https://docs.racket-lang.org/redex/The_Redex_Reference.html#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._caching-enabled~3f%29%29), aggravating the [performance issue](#performance).

Parallel Reduction
==================

PLT Redex is unable to reduce on multiple [`hole`s](other-features#extensions-and-holes) in a single step. We would have run into this limitation if we had chosen, for example, Conway’s Game of Life instead of Peg Solitaire. In each step of Conway’s Game of Life, all cells on the board change state (alive or dead) in parallel, but we could not model it with multiple `hole`s, we would have to opt for a less straightforward representation and serialize the step in a series of sub-steps.

Higher-Order Metafunctions
==========================

Metafunctions in PLT Redex are first-order: they cannot be passed as arguments, they cannot be a return value, they cannot be store in data structures, and so forth. This issue arises, for example, when trying to model a [*Continuation-Passing Style converter*](http://matt.might.net/articles/cps-conversion/). If higher-order functions are necessary, then we must `unquote` and use regular Racket functions.

Definition Extension Limitations
================================

Let `L` be a language, `m` a metafunction, `r` a reduction relation that uses `m`, and `L′`, `m′` and `r′` their respective extensions. The parts of `r′` that use `m` are not reinterpreted to use `m′` and range over `L′`. The only possible workarounds are to copy `r` into the definition fo `r′` and modify uses of `m` to `m′` or be careful in the definitions so that the issue does not occur. This is the approach taken in a paper that discusses this limitation, [*An Introduction to Redex with Abstracting Abstract Machines*](https://dvanhorn.github.io/redex-aam-tutorial/#%28part._.A_brief_aside_on_the_caveats_of_language_extensions%29).

Customized Typesetting
======================

PLT Redex includes many features to customize typesetting, but they can be hard to learn and have their shortcomings. For example, there is not way to change the arrangement of antecedents on a predicate relation—they always appear on the same line. Also, the paper size is fixed, and big definitions may not fit. In general, the figures require post-processing before they can appear on a paper: trimming, rearranging and so forth. I recommend [`pdfcrop`](http://pdfcrop.sourceforge.net) for simple trimming, [Inkscape](https://inkscape.org/) for more complex manipulation and [`pdf2svg`](http://www.cityinthesky.co.uk/opensource/pdf2svg/) for when the figure must appear on a web page.

Formal Proofs
=============

PLT Redex is a lightweight modeling tool, not a theorem prover or a model checker. It can [check](other-features#checking) propositions to increase your confidence in them with little effort, but if you need mechanized formal proofs, use tools like [Coq](https://coq.inria.fr).

At this point in our journey, we know enough to follow more advanced material on PLT Redex. In the next section, we list this [related work](related-work).
