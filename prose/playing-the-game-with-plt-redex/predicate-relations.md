---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

A predicate relation is a special kind of metafunction that returns a boolean.<label class="margin-note"><input type="checkbox"><span markdown="1">When working with programming languages, predicate relations typically check whether a program is well formed, whether a type is a subtype of another type, and so forth.</span></label> As illustration, we start by defining a metafunction that returns true if and only if a given board is a winning board:<label class="margin-note"><input type="checkbox"><span markdown="1">A board is a winning board if [it contains a single peg](peg-solitaire-rules).</span></label>

<div class="code-block" markdown="1">
`predicate-relations.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-metafunction peg-solitaire
  winning-board?/metafunction : board -> boolean
  [(winning-board?/metafunction ([· ... ○ ... · ...]
                                 ...
                                 [· ... ○ ... ● ○ ... · ...]
                                 [· ... ○ ... · ...]
                                 ...))
   #t]
  [(winning-board?/metafunction _) #f])
```
</div>

The pattern in the metafunction in more detail:

| `[· ... ○ ... · ...] ...` | Any number of rows without a peg. |
| `[· ... ○ ... ● ○ ... · ...]` | A row with a single peg. |
| `[· ... ○ ... · ...] ...` | More rows without a peg. |

Testing the metafunction:

```racket
(test-equal (term (winning-board?/metafunction example-board-1))
            #f)
(test-equal (term (winning-board?/metafunction example-board-2))
            #f)
(test-equal (term (winning-board?/metafunction initial-board))
            #f)
(test-equal (term (winning-board?/metafunction example-winning-board))
            #t)
```

The metafunction `winning-board?/metafunction` only returns true for the `example-winning-board`.

* * *

Metafunctions that return booleans are common, so they deserve a special name: predicate relations. We define a predicate relation using the [`define-relation`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=define-relation#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-relation%29%29) form to specify under which conditions the predicate relation *holds* (when a metafunction would have returned true):

```racket
(define-relation <language>
  <contract>
  [(<relation> <pattern> ...)])
```

- `<language>`: A language as defined [previously](languages).
- `<contract>`: A contract with a pattern for the inputs of the predicate relation. The contract is verified and an error may be raised if the predicate relation is queried with invalid inputs.
- `[(<relation> <pattern> ...)]`: A predicate relation clause.
- `<relation>`: The predicate relation name.
- `<pattern>`: Pattern against which the predicate relation inputs are compared. If the patterns match, then the predicate relation holds.

The following is the `winning-board?/metafunction` metafunction written as a predicate relation:

```racket
(define-relation peg-solitaire
  winning-board? ⊆ board
  [(winning-board? ([· ... ○ ... · ...]
                    ...
                    [· ... ○ ... ● ○ ... · ...]
                    [· ... ○ ... · ...]
                    ...))])
```

The contract `winning-board? ⊆ board` says the `winning-board?` predicate relation is only defined over `board`s<label class="margin-note"><input type="checkbox"><span markdown="1">We use the symbol for subsetting (`⊆`) because only *some* boards are winning boards.</span></label> and PLT Redex will verify the input before a query. We query the predicate relation by applying it, similar to a metafunction:

```racket
(test-equal (term (winning-board? example-board-1))
            #f)
(test-equal (term (winning-board? example-board-2))
            #f)
(test-equal (term (winning-board? initial-board))
            #f)
(test-equal (term (winning-board? example-winning-board))
            #t)
```

The predicate relation `winning-board?` only holds for the `example-winning-board`.

* * *

We will use the predicate relation `winning-board?` in a [later section](limitations) when trying to use our model to win Peg Solitaire:

```racket
(provide winning-board?)
```
