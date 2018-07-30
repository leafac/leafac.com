---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

Relations
=========

<aside markdown="1">
<pre>
<strong>  Function           Relation

x   (add1 x)      x       (parent x)</strong>

0       1      "John"      "Anna"
1       2      "John"      "Jack"
2       3      "Anna"      "Lindsay"
3       4      "Anna"      "Robert"
    ⋮                  ⋮
</pre>

Each input (left column) appears only once in functions, but may appear multiple times in relations.
</aside>

Functions, including [metafunctions](metafunctions), are a particular kind of *relation*, and *reduction relations* will be our first encounter with this more general form. A function determines exactly one output for each input, but a relation may determine multiple outputs. While all functions are relations, not all relations are functions. For example, [`add1`](https://docs.racket-lang.org/reference/generic-numbers.html?q=add1#%28def._%28%28quote._~23~25kernel%29._add1%29%29) is relation that is also a function, because it determines a single output for each input, whereas `parent` would be a relation that is not a function, because a person has multiple (two) parents.

Most programming languages only support functions,<label class="margin-note"><input type="checkbox"><span markdown="1">Or, equivalently, methods, procedures, and so forth.</span></label> so if we were to use them to define a relation that is not a function, we would need to encode it as a function that returns a set, for example:

<pre>
<strong>   x        (parent/function x)</strong>

"John"      (set "Anna" "Jack" ⋯)
"Anna"      (set "Lindsay" "Robert" ⋯)
        ⋮
</pre>

In PLT Redex, however, we do not need to resort to an encoding, because the tool includes forms to specify relations of any kind, including those that are not functions and may return multiple outputs. The simplest of these forms is [`reduction-relation`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=reduction-relation#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._reduction-relation%29%29):

<aside markdown="1">
The `reduction-relation` form returns the reduction relation as a value, unlike the forms we discussed so far that assign names, for example, `define-language` and `define-metafunction`.
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

The `reduction-relation` form computes *nondeterministically*: if multiple clauses match the input, than multiple results are output. This is different from [metafunctions](metafunctions), in which clauses were tested in order and the first match *determined* the output. The following listing is an example of `reduction-relation` that defines the `parent` relation:

<aside markdown="1">
We must provide a language for the `reduction-relation` form, so we use the one we already defined, `peg-solitaire`, though this example is unrelated to the game.
</aside>

<div class="code-block" markdown="1">
`reduction-relations.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define
  parent
  (reduction-relation
   peg-solitaire
   #:domain string

   (--> "John" "Anna")
   (--> "John" "Jack")
   (--> "Anna" "Lindsay")
   (--> "Anna" "Robert")
   ; ⋮
   ))
```
</div>

We can query this reduction relation with the [`apply-reduction-relation`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=apply-reduction-relation#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._apply-reduction-relation%29%29) form. Using this form, the reduction relation behaves similar to the function encoding we mentioned above: it returns a set of outputs. Because PLT Redex works over S-expressions, the set is encoded in terms of a list, so when testing our relation, we use [`list->set`](https://docs.racket-lang.org/reference/sets.html?q=list-%3Eset#%28def._%28%28lib._racket%2Fset..rkt%29._list-~3eset%29%29):

```racket
(test-equal (list->set (apply-reduction-relation parent "John"))
            (set "Anna" "Jack"))
```

We can also apply this relation repeatedly and gather all the ancestors with the [`apply-reduction-relation*`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=apply-reduction-relation#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._apply-reduction-relation%2A%29%29) form:

```racket
(test-equal (list->set (apply-reduction-relation* #:all? #t parent "John"))
            (set "Anna" "Jack" "Lindsay" "Robert"))
```

In programming-language theory, the most common kind of reduction relation is the interpreter. Most interpreters are deterministic, so a designer must specify mutually-exclusive clauses, in which only one `<pattern>` may match the input program fragment. Even if an interpreter is deterministic, it is more appropriate to define it as a reduction relation than as a metafunction, which could rely solely on the order of the clauses solve ambiguity.

Moves
=====

We must model moves in Peg Solitaire as a relation, as opposed to a metafunction, because there might be multiple moves available for a single board. We define a `⇨` reduction relation over `board`s:

```racket
(define
  ⇨
  (reduction-relation
   peg-solitaire
   #:domain board

   ___))
```


The reduction relation has four clauses, one for each kind of move. The following is the clause for when a peg jumps over its neighbor on the right:<label class="margin-note"><input type="checkbox"><span markdown="1">In the [Overview](overview), we wrote this clause using `any` patterns, instead of `row` and `position`, because we had not defined a [language](languages).</span></label>

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

The clause for when a peg jumps over its neighbor on the left is similar, and the clauses for when a peg jumps over its neighbors on the top or bottom follow the same idea, but we must use named ellipses (`..._<suffix>`) to capture the surroundings involving multiple rows. The named ellipses guarantee the same number of `position`s to the left of the sequence in which we are interested, aligning the column. For example, the following is the rule for when a peg jumps over its neighbor on the bottom:<label class="margin-note"><input type="checkbox"><span markdown="1">The ellipses `<suffix>`es (for example, `_n`) must only appear in the input pattern, not in the output template.</span></label>

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

The named ellipses (`..._n`) only match sequences `position_1`, `position_3` and `position_5` of the same length, so the sequence `● ● ○` must appear in the same column. The clause for when a peg jumps over its neighbor on the top is similar, so we can conclude the definition of `⇨`:

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

We can test `⇨` with the `apply-reduction-relation` form. It nondeterministically computes all the possible boards after one move:

```racket
(test-equal (list->set (apply-reduction-relation ⇨ (term initial-board)))
            (set
             (term
              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ● ● ● ● ● ●)
               (● ● ● ○ ● ● ●)
               (· · ● ○ ● · ·)
               (· · ● ● ● · ·)))

             (term
              ((· · ● ● ● · ·)
               (· · ● ○ ● · ·)
               (● ● ● ○ ● ● ●)
               (● ● ● ● ● ● ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·)))

             (term
              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ● ● ● ○ ○ ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·)))

             (term
              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ○ ○ ● ● ● ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·)))))
```

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

As the word *reduction* implies, a reduction relation is expected to *reduce* the input. The notion of what constitutes a *reduced* term depends on the language, and PLT Redex does not enforce this expectation, but we should be careful in our definitions so that it holds. Generally, in programming languages, reducing a term reduces its size, for example, in Racket the term `(+ 1 2)` reduces to `3`. In Peg Solitaire, the notion of reduction is not related to board size, which remains the same throughout the game, but to the number of pegs, which reduces with each move.

* * *

The `⇨` is enough to play Peg Solitaire using [PLT Redex visualization tools](visualization), but we explore a few other forms before we return to it. We will use this reduction relation in later sections:

```racket
(provide ⇨)
```
