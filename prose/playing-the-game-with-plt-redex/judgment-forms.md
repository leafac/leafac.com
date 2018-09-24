---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

Both [reduction relations](reduction-relations) and [predicate relations](predicate-relations) are special forms of *relations*. A reduction relation has one input term and one output term, and a predicate relation only has inputs terms, but in general a relation may have any number of input terms and output terms.<label class="margin-note"><input type="checkbox"><span markdown="1">It would be more mathematically accurate to not think of terms in a relation as inputs or outputs, but we make this compromise to make it easier to *compute* with out definitions.</span></label> We can define relations in PLT Redex with [`define-judgment-form`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=define-relation#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-judgment-form%29%29):

```racket
(define-judgment-form <language>
  #:mode (<judgment-form> <I/O> ...)
  #:contract (<judgment-form> <pattern> ...)

  [(<judgment-form> <pattern/template> ...)]
  ...)
```

- `<language>`: A language as defined [previously](languages).
- `#:mode`: A judgment form may have multiple inputs and outputs, and they all appear as *arguments* to the form. The `#:mode` annotation distinguishes inputs (`I`) from outputs (`O`).
- `#:contract`: A contract with patterns for the arguments of the judgment form. The contract is verified and an error may be raised if the judgment form is queried with invalid inputs or produces invalid outputs.
- `[(<judgment-form> <pattern/template> ...)]`: A judgment form clause.
- `<judgment-form>`: The judgment form name.
- `<pattern/template>`: A pattern for an input or a template for an output.

* * *

We can recreate the `⇨` [reduction relation](reduction-relations) and the `winning-board?` [predicate relation](predicate-relations) in terms of judgment forms:

<div class="code-block" markdown="1">
`judgment-forms.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-judgment-form peg-solitaire
  #:mode (⇨/judgment-form I O)
  #:contract (⇨/judgment-form board board)

  [(⇨/judgment-form (row_1
                     ...
                     [position_1 ... ● ● ○ position_2 ...]
                     row_2
                     ...)
                    (row_1
                     ...
                     [position_1 ... ○ ○ ● position_2 ...]
                     row_2
                     ...))
   "→"]

  [(⇨/judgment-form (row_1
                     ...
                     [position_1 ... ○ ● ● position_2 ...]
                     row_2
                     ...)
                    (row_1
                     ...
                     [position_1 ... ● ○ ○ position_2 ...]
                     row_2
                     ...))
   "←"]

  [(⇨/judgment-form (row_1
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
                     ...))
   "↓"]

  [(⇨/judgment-form (row_1
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
                     ...))
   "↑"])

(define-judgment-form peg-solitaire
  #:mode (winning-board?/judgment-form I)
  #:contract (winning-board?/judgment-form board)
  [(winning-board?/judgment-form ([· ... ○ ... · ...]
                                  ...
                                  [· ... ○ ... ● ○ ... · ...]
                                  [· ... ○ ... · ...]
                                  ...))])
```
</div>

We can test whether a judgment holds with the [`test-judgment-holds`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=test-judgment-holds#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._test-judgment-holds%29%29) form:

```racket
(test-judgment-holds
 (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                 [· · ● ● ● · ·]
                                 [● ● ● ● ● ● ●]
                                 [● ○ ○ ● ● ● ●]
                                 [● ● ● ● ● ● ●]
                                 [· · ● ● ● · ·]
                                 [· · ● ● ● · ·])))

(test-judgment-holds
 (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                 [· · ● ● ● · ·]
                                 [● ● ● ● ● ● ●]
                                 [● ● ● ● ○ ○ ●]
                                 [● ● ● ● ● ● ●]
                                 [· · ● ● ● · ·]
                                 [· · ● ● ● · ·])))

(test-judgment-holds
 (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                 [· · ● ○ ● · ·]
                                 [● ● ● ○ ● ● ●]
                                 [● ● ● ● ● ● ●]
                                 [● ● ● ● ● ● ●]
                                 [· · ● ● ● · ·]
                                 [· · ● ● ● · ·])))

(test-judgment-holds
 (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                 [· · ● ● ● · ·]
                                 [● ● ● ● ● ● ●]
                                 [● ● ● ● ● ● ●]
                                 [● ● ● ○ ● ● ●]
                                 [· · ● ○ ● · ·]
                                 [· · ● ● ● · ·])))
```

We can also query a judgment form with the [`judgment-holds`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=judgment-holds#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._judgment-holds%29%29) form. The following listing includes tests for both `⇨/judgment-form` and `winning-board?/judgment-form`:

```racket
(test-equal
 (judgment-holds
  (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                  [· · ● ● ● · ·]
                                  [● ● ● ● ● ● ●]
                                  [● ○ ○ ● ● ● ●]
                                  [● ● ● ● ● ● ●]
                                  [· · ● ● ● · ·]
                                  [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds
  (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                  [· · ● ● ● · ·]
                                  [● ● ● ● ● ● ●]
                                  [● ● ● ● ○ ○ ●]
                                  [● ● ● ● ● ● ●]
                                  [· · ● ● ● · ·]
                                  [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds
  (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                  [· · ● ○ ● · ·]
                                  [● ● ● ○ ● ● ●]
                                  [● ● ● ● ● ● ●]
                                  [● ● ● ● ● ● ●]
                                  [· · ● ● ● · ·]
                                  [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds
  (⇨/judgment-form initial-board ([· · ● ● ● · ·]
                                  [· · ● ● ● · ·]
                                  [● ● ● ● ● ● ●]
                                  [● ● ● ● ● ● ●]
                                  [● ● ● ○ ● ● ●]
                                  [· · ● ○ ● · ·]
                                  [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds (winning-board?/judgment-form example-board-1))
 #f)
(test-equal
 (judgment-holds (winning-board?/judgment-form example-board-2))
 #f)
(test-equal
 (judgment-holds (winning-board?/judgment-form initial-board))
 #f)
(test-equal
 (judgment-holds (winning-board?/judgment-form example-winning-board))
 #t)
```

If we provide a pattern in an output position of the judgment form, then `judgment-holds` makes the names available in a template we provide as the second argument. The result becomes not only whether the relation holds, but the templates built from terms for which it hold. We can convert this resulting list into a set similar to how we did when testing [`apply-reduction-relation`](reduction-relations):

```racket
(test-equal
 (list->set (judgment-holds (⇨/judgment-form initial-board board) board))
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

Because `⇨/judgment-form` has mode `I O`, it behaves like a reduction relation, and we can query it with `apply-reduction-relation` and `apply-reduction-relation*` as well:

```racket
(test-equal
 (list->set (apply-reduction-relation ⇨/judgment-form (term initial-board)))
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

(test-equal
 (list->set
  (apply-reduction-relation* ⇨/judgment-form (term ([● ● ● ○ ● ● ●]))))
 (set
  (term ((○ ○ ● ○ ● ○ ●)))

  (term ((● ○ ● ○ ● ○ ○)))))
```

When to Use the Different Forms
===============================

<!-- When to use each form -->

<!--
A last fine point about reduction relations in programming-language theory.

If we define relation clauses to be mutually exclusive, then a relation may be deterministic, as each input will only match one clause. This is unsurprising, since functions are a special case of relation. Generally in programming-language theory interpreters, type systems and so forth are defined as deterministic relations, as opposed to metafunctions, because they are more mathematically accurate, not depending on the subtle consequences of clause order to resolve ambiguities.

As the word *reduction* implies, a reduction relation is expected to *reduce* the input. The notion of what constitutes a *reduced* term depends on the language, and PLT Redex does not enforce this expectation, but we should be careful in our definitions so that it holds. Generally, in programming languages, reducing a term reduces its size, for example, in Racket the term `(+ 1 2)` reduces to `3`. In Peg Solitaire, the notion of reduction is not related to board size, which remains the same throughout the game, but to the number of pegs, which reduces with each move.
-->

* * *

Next, we are ready to play Peg Solitaire using PLT Redex [visualization tools](visualization).
