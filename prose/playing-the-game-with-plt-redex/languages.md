---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

A language defines names for the patterns we explored in the [previous section](pattern-matching), specifying the shape of the terms we use to represent Peg Solitaire elements including pegs, boards, and so forth. If terms are instances of data structures, then a language is the data structure definition. We revisit the language `peg-solitaire` we defined in the previous section with the [`define-language`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=define-language#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-language%29%29) form to add names for patterns:<label class="margin-note"><input type="checkbox"><span markdown="1">The `define-language` form specifies a grammar in [BNF](http://matt.might.net/articles/grammars-bnf-ebnf/).</span></label>

<div class="code-block" markdown="1">
`languages.rkt`
```racket
#lang racket
(require redex "terms.rkt")
(provide peg-solitaire)

(define-language peg-solitaire
  [board    ::= (row ...)]
  [row      ::= [position ...]]
  [position ::= peg space padding]
  [peg      ::= ●]
  [space    ::= ○]
  [padding  ::= ·])
```
</div>

Each line `[<name> ::= <pattern> ...]` is assigning the `<name>` to `<pattern>`, and occurrences of other `<name>`s in `<pattern>` are interpreted accordingly,<label class="margin-note"><input type="checkbox"><span markdown="1">Patterns in the `define-language` form are the only ones in which multiple occurrences of a name can match different terms. For example, if a language includes the line `[pair ::= (position position)]` then `pair` would match the term `(● ○)`. To insist on the same term, suffix the names, for example, `[pair ::= (position_1 position_1)]`.</span></label> for example, the pattern for `board` includes `row`. The following is each line of the definition above in more detail:

| `[board    ::= (row ...)]` | A `board` is a list of zero or more `row`s. |
| `[row      ::= [position ...]]` | A `row` is a list of zero or more `position`s. |
| `[position ::= peg space padding]` | A `position` is either a `peg`, or a `space`, or a `padding`. |
| `[peg      ::= ●]` | A `peg` is literally the term `●`. Similarly for `space` and `padding`. |

We can use the pattern names<label class="margin-note"><input type="checkbox"><span markdown="1">*Pattern names* are known as *non-terminals*.</span></label> when matching terms, for example:

```racket
(test-equal (redex-match? peg-solitaire peg
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire position
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (peg ● ○)
                          (term         (●   ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (position ● ○)
                          (term         (●        ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (position position ○)
                          (term         (●        ●        ○)))
            #t)
```

Multiple occurrences of a name must match the same term, so the following does not match because `position` cannot be `●` and `○` at the same time:

```racket
(test-equal (redex-match? peg-solitaire (position position position)
                          ;                                ≠
                          (term         (●        ●        ○)))
            #f)
```

We can suffix the names to allow them to match to different terms:

```racket
(test-equal (redex-match? peg-solitaire (position_1 position_2 position_3)
                          (term         (●          ●          ○)))
            #t)
```

We can use the `peg-solitaire` language to match the board examples:

```racket
(test-equal (redex-match? peg-solitaire board (term example-board-1))
            #t)
(test-equal (redex-match? peg-solitaire board (term example-board-2))
            #t)
(test-equal (redex-match? peg-solitaire board (term initial-board))
            #t)
(test-equal (redex-match? peg-solitaire board (term example-winning-board))
            #t)
```

* * *

Our language is too permissive, allowing `board` to match terms we consider ill-formed boards, for example:

```racket
(test-equal (redex-match? peg-solitaire board (term ([● ○]
                                                     [●])))
            #t)
```

The term above does not represent a Peg Solitaire board: it is too small and the rows have different sizes. Yet, the `board` in the `peg-solitaire` language matches it. We could refine the language definition so that it would match *exactly* the terms that represent Peg Solitaire elements, but that would be more complicated and would fail to communicate our intent to the readers. The named patterns we introduced in `peg-solitaire` will serve well for the definitions in the following sections, so this simpler language specification suffices. We will proceed assuming all boards are well-formed,<label class="margin-note"><input type="checkbox"><span markdown="1">If more rigor was necessary, we could have defined a [predicate relation](predicate-relations) that only holds for well-formed boards.</span></label> and in a few instances we will even use ill-formed boards on purpose to simplify tests.
