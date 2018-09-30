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

At this point, we covered four different ways to operate on terms in PLT Redex: [metafunctions](metafunctions), [reduction relations](reduction-relations), [predicate relations](predicate-relations) and [judgment forms](judgment-forms). We could solve some of the same problems with more than one of these forms, so we need criteria to choose. It is particularly difficult to choose between a metafunction and a reduction relation when the reduction relation is deterministic. We could leverage the clause order and define a metafunction that is terser than its reduction relation counterpart, for example:

```racket
(define-metafunction L
  [(m <some-kind-of-term>) ___]
  [(m _) ___])

(define r
  (reduction-relation
   (--> <some-kind-of-term> ___)
   (--> <any-other-term> ___)))
```

In the listing above, we can rely on the clause order and use the underscore pattern (`_`) in the second clause of the metafunction `m` to only match terms that are not `<some-kind-of-term>`. When defining `r` as a reduction relation version of `m`, we have to write mutually exclusive clauses and be explicit about what constitutes `<any-other-term>` that is not `<some-kind-of-term>`. If we had used `_` instead of `<any-other-term>`, then the second clause in `r` would always match, even for `<some-kind-of-term>`.

This case arrises often when defining the semantics of a deterministic language, and we could be tempted by the terser definition to prefer a metafunction, resorting to reduction relations only when we need nondeterminism (for example, in `⇨` in Peg Solitaire). But it is a better practice to use reduction relations when defining semantics. First, because it follows the semantic framework on which PLT Redex is built,<label class="margin-note"><input type="checkbox"><span markdown="1">Reduction semantics.</span></label> and programming-language researchers expect semantics in this form. Second, because the clause order may hide ambiguities and leave semantic considerations implicit. Third, because it leaves the foundation ready for when it is necessary to introduce nondeterminism in the semantics.

Usually, metafunctions are the auxiliary utilities, for example, to substitute variables for values, calculate the result of primitive operations, and so forth. Reduction relations are better suited for defining semantics. They should *reduce* the terms in the language. The notion of a *reduced* term depends on the language and does not always correspond to a smaller term; in Peg Solitaire, for example, a reduced term is not a smaller board, but one with less pegs. It is also common to use the more general `define-judgment-form` instead of `reduction-relation` when the only difference would be the notation.

* * *

Next, we are ready to play Peg Solitaire using PLT Redex [visualization tools](visualization).
