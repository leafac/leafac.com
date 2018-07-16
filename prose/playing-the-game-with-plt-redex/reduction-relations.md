---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

A reduction relation is similar to a function, except for the following:

<aside markdown="1">
<figure markdown="1">
TODO:
```
-------------------------------------
| Relations                         |
|                                   |
|                                   |
| Functions       Reductions        |
|                                   |
|         [They intersect]          |
|                                   |
-------------------------------------
```
</figure>
</aside>

- As the word *reduction* implies, a reduction relation is expected to *reduce* the input. The notion of what constitutes a *reduced* term depends on the language, and PLT Redex does not enforce this expectation, but we should be careful in our definitions so that it holds. Generally, in programming languages, reducing a term reduces its size, for example, in Racket, the term `(+ 1 2)` reduces to `3`. In Peg Solitaire, the board size remains the same, but the number of pegs reduces with each move.

- A reduction relation in PLT Redex must be defined in terms of [pattern matching](pattern-matching). The input board is matched against a pattern and we provide a template with which to compute output.

- When the execution of a function has multiple paths it can follow—for example, when it reaches [`match`](TODO), [`cond`](TODO), [`case`](TODO), and so forth—it chooses only one option (generally the first successful clause). A reduction relation, on the hand, chooses *all* the options. We say a function is *deterministic*, while a reduction relation is *nondeterministic*.

More precisely, a function is a special case of relation that can only follow one execution path. Alternatively, a relation is a function that returns a set of results. The former interpretation is more mathematically accurate, while the latter is more useful for reasoning about certain PLT Redex features.<label class="margin-note"><input type="checkbox"><span markdown="1">For example, [`apply-reduction-relation`](TODO), which we introduce in a [later section](reduction-relations).</span></label>

One example of function<label class="margin-note"><input type="checkbox"><span markdown="1">As well as a relation, since all functions are relations.</span></label> is `successor`, that yields the successor of a number:<label class="margin-note"><input type="checkbox"><span markdown="1">In Racket, `successor` is called [`add1`](TODO).</span></label>

| `x` | `(sucessor x)` |
|-|-|
| `0` | `1` |
| `1` | `2` |
| `2` | `3` |
| `3` | `4` |
| `⋮` | `⋮` |

Observe how each number appears only once on the left column: a function relates each input with a single output.

One example of a relation that is not a function is greater-than (`>`):

| `x` | `(> x)` |
|-|-|
| `0` | `1` |
| `0` | `2` |
| `0` | `3` |
| `0` | `4` |
| `⋮` | `⋮` |
| `1` | `2` |
| `1` | `3` |
| `1` | `4` |
| `1` | `5` |
| `⋮` | `⋮` |

Observe how each number appears on the left column more than once: a relation may relate each input with multiple outputs.

We can also interpret a relation as a function that returns a set of outputs:

| `x` | `(> x)` |
|-|-|
| `0` | `{1, 2, 3, 4, …}` |
| `1` | `{2, 3, 4, 5, …}` |
| `⋮` | `⋮` |

* * *

The `→` [judgment form](judgment forms) from the previous section had one input and one output. We say the judgment form was *reducing* the `board` because after each move there are *fewer* possible moves going forward. This specific kind of relation is also know as a *reduction relation*.<label class="margin-note"><input type="checkbox"><span markdown="1">Like judgment forms, reduction relations compute nondeterministically.</span></label> PLT Redex supports reduction relations with the `reduction-relation` form:<label class="margin-note"><input type="checkbox"><span markdown="1">The `reduction-relation` form returns the reduction relation as a value, unlike the forms we discussed so far that assign names, for example, `define-metafunction`, `define-relation` and `define-judgment-form`.</span></label>

```racket
(reduction-relation
  <language>
  #:domain <pattern>

  (--> <pattern> <template> <name>)
  ...)
```

- `<language>`: A language as defined [previously](languages).
- `#:domain`: A contract pattern for the inputs and outputs of the reduction relation. The contract is verified and an error may be raised if the reduction relation is applied with an invalid input or produces an invalid output.
- `(--> <pattern> <template> <name>)`: A reduction relation clause.
- `<pattern>`: A pattern for the input.
- `<template>`: A template for the output.

We define the `⇨` reduction relation using the same patterns and templates from the `→` judgment form:

<div class="code-block" markdown="1">
`judgment-forms.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

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
</div>

We apply the reduction relation with the `apply-reduction-relation` form. It nondeterministically computes all the possible boards after one move:

```racket
(test-equal (apply-reduction-relation ⇨ (term initial-board))
            '(((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ● ● ● ● ● ●)
               (● ● ● ○ ● ● ●)
               (· · ● ○ ● · ·)
               (· · ● ● ● · ·))

              ((· · ● ● ● · ·)
               (· · ● ○ ● · ·)
               (● ● ● ○ ● ● ●)
               (● ● ● ● ● ● ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·))

              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ● ● ● ○ ○ ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·))

              ((· · ● ● ● · ·)
               (· · ● ● ● · ·)
               (● ● ● ● ● ● ●)
               (● ○ ○ ● ● ● ●)
               (● ● ● ● ● ● ●)
               (· · ● ● ● · ·)
               (· · ● ● ● · ·))))
```

We apply the reduction relation one or more times with the `apply-reduction-relation*` form. This outputs the same as the `→*` judgment form, except that the input in not present in the output:<label class="margin-note"><input type="checkbox"><span markdown="1">Mathematicians call this the *transitive closure* of the `⇨` reduction relation, as opposed to `→*`, which was the *reflexive*, transitive closure of the `→` relation.</span></label>

```racket
(test-equal (apply-reduction-relation* #:all? #t ⇨ (term ([● ● ● ○ ● ● ●])))
            '(((○ ○ ● ○ ● ○ ●))

              ((● ○ ○ ● ● ● ●))

              ((● ○ ● ○ ○ ● ●))

              ((● ○ ● ○ ● ○ ○))

              ((● ● ○ ○ ● ○ ●))

              ((● ● ● ● ○ ○ ●))))
```

We can also query just the *final* boards, in which no further moves are possible by omitting the `#:all?` keyword:

```racket
(test-equal (apply-reduction-relation* ⇨ (term ([● ● ● ○ ● ● ●])))
            '(((○ ○ ● ○ ● ○ ●))

              ((● ○ ● ○ ● ○ ○))))
```

* * *

We will use the reduction relation in later sections:

```racket
(provide ⇨)
```
