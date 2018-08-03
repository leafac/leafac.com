---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

In functions, including [metafunctions](metafunctions), each input relates to one output. When we enumerate a function, each input appears only once on the left column, for example:

<pre markdown="1">
<strong>position     (invert/position position)</strong>

    ●                     ○
    ○                     ●
    ·                     ·
</pre>

A function<label class="margin-note"><input type="checkbox"><span markdown="1">Or, equivalently, a method, a procedure, a routine, and so forth.</span></label> is not a natural way to model moves in Peg Solitaire, because there might be multiple moves available for a given board. If functions were all we had, then we could encode our intent with a `⇨/function` that returned a *set* of output boards, for example:

<pre markdown="1">
<strong>        board                  (⇨/function board)</strong>

(term                         (set
 ([· · ● ● ● · ·]              (term
  [· · ● ● ● · ·]               ([· · ● ● ● · ·]
  [● ● ● ● ● ● ●]                [· · ● ● ● · ·]
  [● ● ● ○ ● ● ●]                [● ● ● ● ● ● ●]
  [● ● ● ● ● ● ●]                [● ○ ○ ● ● ● ●]
  [· · ● ● ● · ·]                [● ● ● ● ● ● ●]
  [· · ● ● ● · ·]))              [· · ● ● ● · ·]
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
                                 [· · ● ● ● · ·])))

                       ⋮
</pre>

But functions are just a special case of *relation*, which may relate one input to multiple outputs. While all functions are relations, not all relations are functions. When we enumerate a relation that is not a function, each input may appear on the left column multiple times. For example, we can define a relation called `⇨` to model moves in Peg Solitaire:

<pre markdown="1">
<strong>        board                       (⇨ board)</strong>

(term                          (term
 ([· · ● ● ● · ·]               ([· · ● ● ● · ·]
  [· · ● ● ● · ·]                [· · ● ● ● · ·]
  [● ● ● ● ● ● ●]                [● ● ● ● ● ● ●]
  [● ● ● ○ ● ● ●]                [● ○ ○ ● ● ● ●]
  [● ● ● ● ● ● ●]                [● ● ● ● ● ● ●]
  [· · ● ● ● · ·]                [· · ● ● ● · ·]
  [· · ● ● ● · ·]))              [· · ● ● ● · ·]))

(term                          (term
 ([· · ● ● ● · ·]               ([· · ● ● ● · ·]
  [· · ● ● ● · ·]                [· · ● ● ● · ·]
  [● ● ● ● ● ● ●]                [● ● ● ● ● ● ●]
  [● ● ● ○ ● ● ●]                [● ● ● ● ○ ○ ●]
  [● ● ● ● ● ● ●]                [● ● ● ● ● ● ●]
  [· · ● ● ● · ·]                [· · ● ● ● · ·]
  [· · ● ● ● · ·]))              [· · ● ● ● · ·]))

(term                          (term
 ([· · ● ● ● · ·]               ([· · ● ● ● · ·]
  [· · ● ● ● · ·]                [· · ● ○ ● · ·]
  [● ● ● ● ● ● ●]                [● ● ● ○ ● ● ●]
  [● ● ● ○ ● ● ●]                [● ● ● ● ● ● ●]
  [● ● ● ● ● ● ●]                [● ● ● ● ● ● ●]
  [· · ● ● ● · ·]                [· · ● ● ● · ·]
  [· · ● ● ● · ·]))              [· · ● ● ● · ·]))

(term                          (term
 ([· · ● ● ● · ·]               ([· · ● ● ● · ·]
  [· · ● ● ● · ·]                [· · ● ● ● · ·]
  [● ● ● ● ● ● ●]                [● ● ● ● ● ● ●]
  [● ● ● ○ ● ● ●]                [● ● ● ● ● ● ●]
  [● ● ● ● ● ● ●]                [● ● ● ○ ● ● ●]
  [· · ● ● ● · ·]                [· · ● ○ ● · ·]
  [· · ● ● ● · ·]))              [· · ● ● ● · ·]))

                       ⋮
</pre>

The `⇨` relation models moves in Peg Solitaire more straightforwardly than the `⇨/function` function. The listing above is similar to how we wrote our [examples in the game description](/overview#pegsolitaire-rules):

<pre>
    ● ● ●             ● ● ●
    ● <span class="success">●</span> ●             ● ○ ●
● ● ● <span class="error">●</span> ● ● ●     ● ● ● <span class="error">○</span> ● ● ●
● ● ● ○ ● ● ●  <span class="success">➡</span>  ● ● ● <span class="success">●</span> ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ <span class="error">●</span> <span class="success">●</span> ●  <span class="success">➡</span>  ● ● ● <span class="success">●</span> <span class="error">○</span> ○ ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ ● ● ●  <span class="success">➡</span>  ● ● ● <span class="success">●</span> ● ● ●
● ● ● <span class="error">●</span> ● ● ●     ● ● ● <span class="error">○</span> ● ● ●
    ● <span class="success">●</span> ●             ● ○ ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● <span class="success">●</span> <span class="error">●</span> ○ ● ● ●  <span class="success">➡</span>  ● ○ <span class="error">○</span> <span class="success">●</span> ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●


<span class="success">●</span> jumps over <span class="error">●</span>
</pre>

Most programming languages only support functions, and when we use them we have to resort to `⇨/function`, but PLT Redex supports relations of any kind, so we can define the `⇨` relation directly. Among the different PLT Redex forms for defining relations, the first we encounter is [`reduction-relation`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=reduction-relation#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._reduction-relation%29%29):

<aside markdown="1">
The `reduction-relation` form returns the reduction relation as a value, unlike the forms we discussed so far that assign names, for example, `define-language` and `define-metafunction`. If we want to assign a name to a reduction relation, we need to use `define`:

```racket
(define <name>
  (reduction-relation ___))
```
</aside>

```racket
(reduction-relation
  <language>
  #:domain <pattern>

  (--> <pattern> <template> <name>)
  ...)
```

- `<language>`: A language as defined [previously](languages).
- `#:domain`: A contract pattern for the inputs and outputs of the reduction relation. The contract is verified and an error may be raised if the reduction relation is applied to an invalid input or produces an invalid output.
- `(--> <pattern> <template> <name>)`: A reduction relation clause.
- `<pattern>`: A pattern for the input.
- `<template>`: A template for the output.
- `<name>`: A name for the clause.

The shape of the `reduction-relation` form is similar to that of `define-metafunction`: it is a series of clauses with patterns for the inputs and templates for the outputs. The difference between the two is in how they proceed when multiple clauses match the input: while a metafunction follows the definition order and chooses *the first* clause that matches, a relation chooses *all* clauses. We say metafunctions compute *deterministically*, because an input *determines* exactly one output, while relations may compute *nondeterministically*.

* * *

The `⇨` reduction relation has four clauses, one for each kind of move. The following is the clause for when a peg jumps over its neighbor on the right:<label class="margin-note"><input type="checkbox"><span markdown="1">In the [Overview](overview), we wrote this clause using `any` patterns, instead of `row` and `position`, because we had only defined a dummy empty [language](languages).</span></label>

```racket
(--> (row_1
      ...
      [position_1 ... ● ● ○ position_2 ...]
      row_2
      ...)
     (row_1
      ...
      [position_1 ... ○ ○ ● position_2 ...]
      row_2
      ...)
     "→")
```

In detail:

- `(row_1 ... [position_1 ... ● ● ○ position_2 ...] row_2 ...)`: The pattern to match against the input board. The pattern matches if the board includes a sequence `● ● ○` surrounded by any other `position`s and `row`s, to which we assign the names `position_<n> ...` and `row_<n> ...` so we can reconstruct the board in the template.
- `(row_1 ... [position_1 ... ○ ○ ● position_2 ...] row_2 ...)`: The template to build the board after the move. It changes the sequence `● ● ○` into `○ ○ ●`, and reconstructs the surroundings with the names `position_<n> ...` and  `row_<n> ...`.
- `"→"`: The name of the clause.

The clause for when a peg jumps over its neighbor on the left is similar. The clauses for when a peg jumps over its neighbors on the top or bottom follow the same idea, but we must use named ellipses (`..._<suffix>`) to capture the surroundings involving multiple rows. The named ellipses align the sequence of interest (for example, `● ● ○`) in the same column, because it guarantees the sequence is preceded by the same number of `position`s in each `row`. For example, the following is the rule for when a peg jumps over its neighbor on the bottom:<label class="margin-note"><input type="checkbox"><span markdown="1">The ellipses `<suffix>`es (for example, `_n`) must only appear in the input pattern, not in the output template.</span></label>

```racket
(--> (row_1
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
      ...)
     "↓")
```

The named ellipses (`..._n`) only match sequences `position_1`, `position_3` and `position_5` of the same length, so the sequence `● ● ○` must appear in the same column. The clause for when a peg jumps over its neighbor on the top is similar, and with it we conclude the definition of `⇨`:

```racket
(define
  ⇨
  (reduction-relation
   peg-solitaire
   #:domain board

   (--> (row_1
         ...
         [position_1 ... ● ● ○ position_2 ...]
         row_2
         ...)
        (row_1
         ...
         [position_1 ... ○ ○ ● position_2 ...]
         row_2
         ...)
        "→")

   (--> (row_1
         ...
         [position_1 ... ○ ● ● position_2 ...]
         row_2
         ...)
        (row_1
         ...
         [position_1 ... ● ○ ○ position_2 ...]
         row_2
         ...)
        "←")

   (--> (row_1
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
         ...)
        "↓")

   (--> (row_1
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
         ...)
        "↑")))
```

* * *

We can test the `⇨` reduction relation with the [`test-->`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=test#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._test--~3e%29%29) form:

```racket
(test--> ⇨ (term initial-board)
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
           [· · ● ● ● · ·])))
```

We can also query the `⇨` reduction relation with the [`apply-reduction-relation`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=apply-reduction-relation#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._apply-reduction-relation%29%29) form. The `apply-reduction-relation` form returns a set of outputs, similar to the `⇨/function` encoding we mentioned above. This is a compromise because PLT Redex is embedded in Racket, a language that does not support relations that are not functions. Also, PLT Redex works over S-expressions, which do not include Racket’s [`set`s](https://docs.racket-lang.org/reference/sets.html), so the multiple outputs are returned in a list. We can turn the returned list into a set with [`list->set`](https://docs.racket-lang.org/reference/sets.html?q=list-%3Eset#%28def._%28%28lib._racket%2Fset..rkt%29._list-~3eset%29%29), so the following test is equivalent to the previous one:

```racket
(test-equal (list->set (apply-reduction-relation ⇨ (term initial-board)))
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

* * *

We can also apply this relation repeatedly and gather all the ancestors with the [`apply-reduction-relation*`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=apply-reduction-relation#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._apply-reduction-relation%2A%29%29) form:

```racket
(test-equal (list->set (apply-reduction-relation* #:all? #t parent "John"))
            (set "Anna" "Jack" "Lindsay" "Robert"))
```

* * *

We can also try to compute all boards with the `apply-reduction-relation*` form, which applies `⇨` repeatedly:

```racket
> (apply-reduction-relation* ⇨ (term initial-board))
∞
```

Unfortunately, there are too many possible boards, so the computation above does not terminate in reasonable time. But we can test `apply-reduction-relation*` in a fragment of the board with a single row:<label class="margin-note"><input type="checkbox"><span markdown="1">The `apply-reduction-relation*` form applies the *transitive closure* of the `⇨` relation.</span></label>

```racket
(test-equal
 (list->set
  (apply-reduction-relation* #:all? #t ⇨ (term ([● ● ● ○ ● ● ●]))))
 (set
  (term ((● ● ● ● ○ ○ ●)))

  (term ((● ● ○ ○ ● ○ ●)))

  (term ((○ ○ ● ○ ● ○ ●)))

  (term ((● ○ ○ ● ● ● ●)))

  (term ((● ○ ● ○ ○ ● ●)))

  (term ((● ○ ● ○ ● ○ ○)))))
```

We can also query just the *final* boards, from which we cannot move further, by omitting the `#:all?` argument:

```racket
(test-equal
 (list->set (apply-reduction-relation* ⇨ (term ([● ● ● ○ ● ● ●]))))
 (set
  (term ((○ ○ ● ○ ● ○ ●)))

  (term ((● ○ ● ○ ● ○ ○)))))
```

* * *

If we define relation clauses to be mutually exclusive, then a relation may be deterministic, as each input will only match one clause. This is unsurprising, since functions are a special case of relation. Generally in programming-language theory interpreters, type systems and so forth are defined as deterministic relations, as opposed to metafunctions, because they are more mathematically accurate, not depending on the subtle consequences of clause order to resolve ambiguities.

As the word *reduction* implies, a reduction relation is expected to *reduce* the input. The notion of what constitutes a *reduced* term depends on the language, and PLT Redex does not enforce this expectation, but we should be careful in our definitions so that it holds. Generally, in programming languages, reducing a term reduces its size, for example, in Racket the term `(+ 1 2)` reduces to `3`. In Peg Solitaire, the notion of reduction is not related to board size, which remains the same throughout the game, but to the number of pegs, which reduces with each move.

* * *

The `⇨` is enough to play Peg Solitaire using [PLT Redex visualization tools](visualization), but we explore a few other forms before we return to it. We will use this reduction relation in later sections:

```racket
(provide ⇨)
```
