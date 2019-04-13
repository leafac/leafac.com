---
layout: default
title: Playing the Game with PLT Redex
date: 2018-09-30
table-of-contents: true
---

In this section we give a high level view of a miscellanea of other PLT Redex features.

Conditions
==========

The forms for manipulating terms can do more than just pattern matching on the input terms to determine whether a clause contributes to the output. They can apply [metafunctions](metafunctions) and [reduction relations](reduction-relations), they can query [predicate relations](predicate-relations) and [judgment forms](judgment-forms), and they can perform arbitrary computations with the `side-condition` form. For example, the following predicate relation uses a `side-condition` form to check that the `board` has rows of matching length (ellipses with suffixes (`..._<suffix>`) would be a more straightforward way of achieving this same goal):

<figure markdown="1">
<figcaption markdown="1">
`other-features.rkt`
</figcaption>
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt"
         "reduction-relations.rkt" "judgment-forms.rkt")


(define-relation peg-solitaire
  equal-length-rows? ⊆ board
  [(equal-length-rows? board)
   (side-condition
    (andmap (λ (row) (equal? (length row)
                             (length (first (term board)))))
            (term board)))])

(test-equal (term (equal-length-rows? initial-board))
            #t)
(test-equal (term (equal-length-rows? ([●]
                                       [●])))
            #t)
(test-equal (term (equal-length-rows? ([●]
                                       [● ●])))
            #f)
```
</figure>

Unquoting
=========

We can use arbitrary computations to define extra [conditions](#conditions) under which a clause contributes to the output, and we can also use arbitrary computations to define that output. We can *escape* from terms back to Racket with `unquote`, which is written with a comma (`,`), for example:

<figure markdown="1">
```racket
(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
```
<figcaption markdown="1">
The `term` form is similar to the [quasiquote](https://docs.racket-lang.org/guide/qq.html), but it is aware of names defined with `define-term` as well as metafunctions, reduction relations and so forth.
</figcaption>
</figure>

In the listing above, the `,(+ 1 2)` form means “*escape* from the term back to Racket, compute `(+ 1 2)` and place the result here.”

[Previously](terms), we used `define-term` to name terms, for example:

```racket
(define-term a-peg ●)
(test-equal (term a-peg)
            '●)
```

We can also assign terms to regular Racket names with `define`, for example:

```racket
(define a-space (term ○))
```

We access this name outside terms as usual:

```racket
(test-equal a-space
            '○)
```

In terms, we unquote to escape back to Racket and access the name, for example:

```racket
(test-equal (term ,a-space)
            '○)
```

The `define-term` form *is not* a shorthand for `(define ___ (term ___))` because names defined with `define-term` are only available in other terms, not directly in Racket. If we try to access in Racket a name defined with `define-term`, for example, `a-peg`, the result is a syntax error:

```racket
> a-peg
a-peg: illegal use of syntax in: a-peg
```

The converse also holds: names defined with `define` are only available directly in Racket, not in terms. Trying to access the name `a-space` defined with `define` in a term is not a syntax error, but does not produce the result you might expect:

```racket
(test-equal (term a-space)
            'a-space)
```

In the listing above, the `a-space` in `term` is interpreted as a symbol, not as a reference to the Racket variable `a-space`. This is a common pitfall, so *pay attention to the different contexts and do not mix Racket with terms*.

With `unquote` we can access names defined with `define` from within terms and mix them with names defined with `define-term`, for example:

```racket
(define-term a-peg ●)
(define a-space (term ○))
(test-equal (term (● a-peg ,a-space))
            '(● ● ○))
```

We can use the `term` form from within `unquote`:

```racket
(test-equal (term (● ,(term a-peg) ,a-space))
            '(● ● ○))
```

In the following example, we define a `count-●` metafunction to count how many pegs there are in a board by unquoting and relying on Racket’s functions for manipulating lists:

```racket
(define-metafunction peg-solitaire
  count-● : board -> integer
  [(count-● ([position ...] ...))
   ,(count (λ (position) (equal? position (term ●)))
           (term (position ... ...)))])

(test-equal (term (count-● initial-board)) 32)
```

The listing above matches the input board with the pattern `([position ...] ...)`, so the name `position` in the template refers to a list of lists of `position`s. We use the template `(position ... ...)` to *flatten* this list of lists. We then unquote and use Racket’s `count` to count how many `position`s are `equal?` to pegs (`●`).

In summary:

- Names defined with **`define`** are available in **Racket** but can be accessed in **terms** with **`unquote`**, for example, **`,peg`**.
- Names defined with **`define-term`** are available in **terms** but can be accessed in **Racket** with **`term`**, for example, **`(term space)`**.

Extensions and Holes
====================

We can define languages, metafunctions, judgment forms and so forth by extending existing definitions. In the following example, we extend the `peg-solitaire` [language](languages) into the `Peg-Solitaire` language:

```racket
(define-extended-language Peg-Solitaire peg-solitaire
  [Board ::= (row ... hole row ...)])
```

The `Peg-Solitaire` language includes all names in `peg-solitaire` as well as the new name `Board`. It is equivalent to the following:

```racket
(define-language Peg-Solitaire
  [board    ::= (row ...)]
  [row      ::= [position ...]]
  [position ::= peg space padding]
  [peg      ::= ●]
  [space    ::= ○]
  [padding  ::= ·]
  [Board    ::= (row ... hole row ...)])
```

The name `Board` refers to pattern `(row ... hole row ...)`. A `hole` is a special pattern built into PLT Redex, similar to how `any` is a special pattern built into PLT Redex. A `Board` is a `board` with a missing `row`, the `hole`. We can match a board with the `in-hole` form, for example:

```racket
(test-equal (redex-match? Peg-Solitaire (in-hole Board row)
                          (term ([●]
                                 [○]
                                 [●])))
            #t)
```

The pattern `(in-hole Board row)` means “the `Board` is a `board` with a `row` missing.” This pattern matches the simplified input board in three ways:

```racket
> (redex-match Peg-Solitaire (in-hole Board row)
               (term ([●]
                      [○]
                      [●])))
(list
 (match (list (bind 'Board '((●) (○) hole)) (bind 'row '(●))))
 (match (list (bind 'Board '((●) hole (●))) (bind 'row '(○))))
 (match (list (bind 'Board '(hole (○) (●))) (bind 'row '(●)))))
```

The first match, for example, means the missing `row` in the `Board` is the last one.

With `Peg-Solitaire` and `Board`s with `hole`s, we can shorten the definition of the [`⇨` reduction relation](reduction-relations). We define the `⇨/hole` reduction relation that extends `⇨` and replaces the `→` clause with a simpler definition using `in-hole`:

<figure markdown="1">
```racket
(define
  ⇨/hole
  (extend-reduction-relation
   ⇨
   Peg-Solitaire
   #:domain board

   (--> (in-hole Board [position_1 ... ● ● ○ position_2 ...])
        (in-hole Board [position_1 ... ○ ○ ● position_2 ...])
        "→")))
```
<figcaption markdown="1">
The `→` clause is *replaced* because we use the same name as the clause in the original `⇨` reduction relation. If we had used a different name, the new clause would be *added* to the extended reduction relation.
</figcaption>
</figure>

The `(in-hole Board [position_1 ... ● ● ○ position_2 ...])` in the input pattern matches a row including the `● ● ○` sequence. This saves us from having to repeat the surroundings by writing `(row_1 ... ___ row_2 ...)`. We cannot shorten the definition further by removing the `position_<n> ...` parts because a `hole` cannot match a sequence of `position`s, for example, `● ● ○`. The `(in-hole Board [position_1 ... ○ ○ ● position_2 ...])` in the template does the opposite, *plugging* the term `[position_1 ... ○ ○ ● position_2 ...]` in the `hole` we had left in `Board`.

The `⇨/hole` extended reduction relation works the same as the `⇨` original reduction relation:

```racket
(test-equal (list->set (apply-reduction-relation ⇨/hole
                                                 (term initial-board)))
            (set
             (term
              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ○ ○ ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·]))

             (term
              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ○ ○ ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·]))

             (term
              ([· · ● ● ● · ·]
               [· · ● ○ ● · ·]
               [● ● ● ○ ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·]))

             (term
              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ○ ● ● ●]
               [· · ● ○ ● · ·]
               [· · ● ● ● · ·]))))
```

PLT Redex provides other more sophisticated forms for extending languages and reduction relations, for example, `define-union-language` creates a language by joining together the names for patterns from various languages, and `context-closure` defines a reduction relation based on another in a way that saves us from typing `(in-hole ___)` repeatedly, as we did in `⇨/hole`.

Checking
========

All tests we have written thus far depend on examples we have written by hand, for example, `initial-board`, `example-board-1` and `example-board-2`. While these tests increase our confidence in our model, they do not suffice to check more sophisticated properties. For example, we may conjecture that boards have less pegs after every move, because we remove the peg that was jumped over. We may want to prove this proposition holds for all boards, but developing a formal proof can be time-consuming, so before we start we want to use our model to test the proposition on a variety of boards, particularly on boards we did not think of ourselves.

PLT Redex includes a tool to generate terms and check propositions. For example, the following listing checks the proposition above:

```racket
(redex-check
 peg-solitaire board
 (for/and ([board′ (in-list (apply-reduction-relation ⇨ (term board)))])
   (> (term (count-● board)) (term (count-● ,board′)))))
```

The `redex-check` form is working over the `peg-solitaire` language and generating terms that follow the definition of `board`. For each term it generates, it runs the predicate `(for/and ___)`, which asserts that the `board` includes more pegs than the `board′`s after one move. By default, PLT Redex will try this a 1000 times:

```racket
redex-check: .../playing-the-game-with-plt-redex/other-features.rkt:131
no counterexamples in 1000 attempts
```

If we check for an invalid property, for example, the *opposite* of the one above (using `<` instead of `>`), then `redex-check` outputs a counterexample:

```racket
> (redex-check
   peg-solitaire board
   (for/and ([board′ (in-list (apply-reduction-relation ⇨ (term board)))])
     (< (term (count-● board)) (term (count-● ,board′)))))

redex-check: .../playing-the-game-with-plt-redex/other-features.rkt:131
counterexample found after 125 attempts:
((○) (●) (●))
```

Typesetting
===========

We can typeset the forms we defined thus far for including them in papers. This streamlines the writing process and prevents errors when translating our model to LaTeX. For example, the following is the typeset definition of `⇨/judgment-form`:

```racket
(render-judgment-form ⇨/judgment-form)
```

<figure markdown="1">
{% include_relative judgment-form.svg %}
<figcaption markdown="1">
The `⇨/judgment-form` judgment form as automatically typeset by PLT Redex.
</figcaption>
</figure>

This default typesetting may be unsatisfactory, for example, we may wish that `⇨/judgment-form` is infix instead of prefix. PLT Redex offers forms to customize the typesetting.

Next, we cover the [limitations](limitations) in PLT Redex.
