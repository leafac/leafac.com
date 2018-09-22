---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

When we looked at [reduction relations](reduction-relations), we were interested in transforming terms. We defined clauses with patterns to match against inputs, and templates to produce outputs. But in some cases we are only interested in whether the inputs satisfy certain conditions, for example, whether a board is a winning board.<label class="margin-note"><input type="checkbox"><span markdown="1">A board is a winning board if [it contains a single peg](peg-solitaire-rules).</span></label> If we were to define that as a reduction relation, then the output templates would be booleans. For this special case, PLT Redex provides the [`define-relation`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=define-relation#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-relation%29%29) form to define *predicate relations*:

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

Predicate relations typically check whether a program is well formed, whether a type is a subtype of another type, and so forth. We define a predicate relation to check whether a board is a winning board:

<div class="code-block" markdown="1">
`predicate-relations.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-relation peg-solitaire
  winning-board? ⊆ board
  [(winning-board? ([· ... ○ ... · ...]
                    ...
                    [· ... ○ ... ● ○ ... · ...]
                    [· ... ○ ... · ...]
                    ...))])
```
</div>

The contract `winning-board? ⊆ board` says that the `winning-board?` predicate relation is only defined over boards—it would not make sense to ask this question about terms that are not boards. We use the symbol for subsetting (`⊆`) because only *some* boards are winning boards.

The pattern in the predicate relation clause in more detail:

- `[· ... ○ ... · ...] ...`: Any number of rows without a peg.
- `[· ... ○ ... ● ○ ... · ...]`: A row with a single peg.
- `[· ... ○ ... · ...] ...`: More rows without a peg.

We query the predicate relation by applying it, similar to a [metafunction](metafunctions):

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

The predicate relation only holds for the `example-winning-board`.

* * *

We will use the predicate relation `winning-board?` in a [later section](limitations) when trying to use our model to win Peg Solitaire:

```racket
(provide winning-board?)
```

Next, we cover the most general form of relations that may not be functions: [judgment forms](judgment-forms).
