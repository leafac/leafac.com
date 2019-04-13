---
layout: default
title: Playing the Game with PLT Redex
date: 2018-09-30
table-of-contents: true
---

A language defines patterns for terms and gives them names. In programming languages, a language determines which terms are programs and which are not. A language might also include extra machinery, for example, binding and type environments, stores, machine states, and so forth. This extra machinery is invisible to programmers, but is used by an interpreter or a type checker, for example. In general, if terms are data, then languages are the definitions of data structures. They provide names for the patterns we explored in the [previous section](pattern-matching).

A language for Peg Solitaire must specify the patterns for terms that represent pegs, boards, and so forth. In the previous section, we defined a placeholder language called `peg-solitaire`, using the [`define-language`](https://docs.racket-lang.org/redex/The_Redex_Reference.html#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._define-language%29%29) form. The specification was empty, because we just wanted enough to allow us to explore pattern matching, so we revisit that language definition now to add names for patterns:

<figure markdown="1">
<figcaption markdown="1">
`languages.rkt`
</figcaption>
```racket
#lang racket
(require redex "terms.rkt")

(define-language peg-solitaire
  [board    ::= (row ...)]
  [row      ::= [position ...]]
  [position ::= peg space padding]
  [peg      ::= ●]
  [space    ::= ○]
  [padding  ::= ·])
```
<figcaption markdown="1">
The `define-language` form specifies a grammar in [BNF](http://matt.might.net/articles/grammars-bnf-ebnf/).
</figcaption>
</figure>

Each line `[<name> ::= <pattern> ...]` assigns a `<name>` to a `<pattern>`, and occurrences of other `<name>`s in `<pattern>` are interpreted accordingly, for example, the name `row` appears in the pattern for `board`. Patterns in the `define-language` form are the only ones in which multiple occurrences of a name can match different terms. For example, if a language includes the line `[pair ::= (position position)]` then `pair` would match the term `(● ○)`. To insist on the same term, suffix the names, for example, `[pair ::= (position_1 position_1)]`. The following is each line of the definition above in more detail:

- `[board    ::= (row ...)]`: A `board` is a list of zero or more `row`s.
- `[row      ::= [position ...]]`: A `row` is a list of zero or more `position`s.
- `[position ::= peg space padding]`: A `position` is either a `peg`, or a `space`, or a `padding`.
- `[peg      ::= ●]`: A `peg` is literally the term `●`. Similarly for `space` and `padding`.

We can use the pattern names (also know as *non-terminals*) when matching terms, for example:

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

We can use the `peg-solitaire` language to match the [board examples](terms):

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

Our language is too permissive, allowing `board` to match terms we consider ill-formed boards, for example:

```racket
(test-equal (redex-match? peg-solitaire board (term ([● ○]
                                                     [●])))
            #t)
```

The term above does not represent a Peg Solitaire board: it is too small and the rows have different sizes. Yet, the `board` pattern in the `peg-solitaire` language matches it. We could refine the language definition so that it would match *exactly* the terms that represent Peg Solitaire elements, but that would be more complicated and would fail to communicate our intent to our readers. The named patterns we introduced in `peg-solitaire` will serve well for the definitions in the following sections, so this simpler language specification suffices. We will proceed assuming all boards are well-formed, and in a few cases we will even use ill-formed boards on purpose to simplify tests. If more rigor was necessary, we could define a [predicate relation](predicate-relations) that only holds for well-formed boards, and test the inputs to the forms we will define in later sections.

We will use the `peg-solitaire` language in later sections, so we `provide` it here:

```racket
(provide peg-solitaire)
```

Now that we have a language, we can operate on terms. On the next section, we cover the most familiar operation, the [metafunction](metafunctions).
