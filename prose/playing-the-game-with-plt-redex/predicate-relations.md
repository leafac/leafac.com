---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

A predicate relation is a special kind of (meta)function that returns a boolean. We define a predicate relation by specifying under which conditions it *holds* (when it returns true), using the `define-relation` form:

```racket
(define-relation <language>
  <contract>
  [(<relation> <pattern> ...)])
```

- `<language>`: A language as defined [previously](languages).
- `<contract>`: A contract with a pattern for the inputs of the predicate relation. The contract is verified and an error may be raised when the predicate relation is queried.
- `[(<relation> <pattern> ...)]`: A predicate relation clause.
- `<relation>`: The predicate relation name.
- `<pattern>`: Pattern against which the predicate relation inputs are compared. If the patterns match, then the predicate relation holds.

The following is example of a predicate relation that holds if the board is a winning board (there is a single peg left):

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

The pattern on the predicate relation in more detail:

- `[· ... ○ ... · ...] ...`: Any number of rows without a peg.
- `[· ... ○ ... ● ○ ... · ...]`: A row with a single peg.
- `[· ... ○ ... · ...] ...`: More rows without a peg.

We can query this predicate relation using `judgment-holds`:

```racket
(test-equal (judgment-holds (winning-board? example-board-1))
            #f)
(test-equal (judgment-holds (winning-board? example-board-2))
            #f)
(test-equal (judgment-holds (winning-board? initial-board))
            #f)
(test-equal (judgment-holds (winning-board? example-winning-board))
            #t)
```

The predicate relation `winning-board?` only holds for the `example-winning-board`.
