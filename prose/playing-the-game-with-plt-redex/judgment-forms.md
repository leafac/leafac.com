---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

A judgment form is different from a [metafunction](metafunctions) in two ways: (1) it may have multiple outputs,<label class="margin-note"><input type="checkbox"><span markdown="1">Similar to a regular Racket function that returns `values`.</span></label> and (2) it is nondeterministic. A metafunction tries to match its inputs with each of the patterns in the definition clauses in order, and the first match *determines* the metafunction output. We say a metafunction is *deterministic*. A judgment form, on the other hand, tries to match its inputs with *all* the patterns in the definition clauses and outputs all cases that match. A judgment form is *nondeterministic*. Another way of interpreting this is that a judgment form is a metafunction that returns a set of outputs.

For example, consider both a metafunction and a judgment form that have the same patterns in their clauses: `(any ...)` and `any`. When the input is `(1 2 3)`, the metafunction matches the first clause and returns the output determined by it, and the judgment form matches *both* patterns and returns both outputs.

We define a judgment form with `define-judgment-form`:

```racket
(define-judgment-form <language>
  #:mode (<judgment-form> <I/O> ...)
  #:contract (<judgment-form> <pattern> ...)

  [<condition>
   ...
   ----------------------------------------
   (<judgment-form> <pattern/template> ...)]
  ...)
```

- `<language>`: A language as defined [previously](languages).
- `#:mode`: A judgment form may have multiple inputs and outputs.<label class="margin-note"><input type="checkbox"><span markdown="1">A [predicate relation](predicate-relations) is a judgment form in which all arguments are inputs and the only output is a boolean.</span></label> Syntactically, they all appear as *arguments* to the form. The `#:mode` annotation specifies which *arguments* are inputs (`I`) and which are outputs (`O`).<label class="margin-note"><input type="checkbox"><span markdown="1">Mathematically, a judgment form does not have inputs and outputs, because it is a *relation*, not a *function*. But by defining which arguments are inputs and outputs, we are specifying a *mode of operation*, which allows PLT Redex to run our definition.</span></label>
- `#:contract`: A contract with patterns for the arguments of the judgment form. The contract is verified and an error may be raised when the judgment form is queried.
- `[<condition> ... --- (<judgment-form> <pattern/template> ...)]`: A judgment form clause.<label class="margin-note"><input type="checkbox"><span markdown="1">This notation with a bar separating conditions—sometimes called *antecedents*—and conclusion is common in papers and has a long tradition in formal logic.</span></label>
- `<condition>`: A condition under which the clause holds. For example, a condition may query another judgment form or [predicate relation](predicate-relations).
- `<judgment-form>`: The judgment form name.
- `<pattern/template>`: A pattern for an input argument or a template for an output pattern.

There are two ways to read a judgment form clause:

- **Logical**: “If `<condition>`s hold, then `(<judgment-form> <pattern/template> ...)` holds.”
- **Operational**: Start at the bottom of dashes, on `(<judgment-form> <pattern/template> ...)`, and match the judgment form inputs to the `<pattern>`s. If they match, then try to satisfy each `<condition>` over the dashes. Finally, output the `<template>`s.

The first reading is more mathematically correct, while the second is more intuitive<label class="margin-note"><input type="checkbox"><span markdown="1">To me, at least.</span></label> and useful when working in PLT Redex.

<div class="code-block" markdown="1">
`judgment-forms.rkt`
```racket
#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-judgment-form peg-solitaire
  #:mode (→ I O)
  #:contract (→ board board)

  [(→ (row_1
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

  [(→ (row_1
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

  [(→ (row_1
       ...
       [position_1 ..._n ● position_2 ...]
       [position_3 ..._n ● position_4 ...]
       [position_5 ..._n ○ position_6 ...]
       row_2
       ...)
      (row_1
       ...
       [position_1 ... ○ position_2 ...]
       [position_3 ... ○ position_4 ...]
       [position_5 ... ● position_6 ...]
       row_2
       ...))
   "↓"]

  [(→ (row_1
       ...
       [position_1 ..._n ○ position_2 ...]
       [position_3 ..._n ● position_4 ...]
       [position_5 ..._n ● position_6 ...]
       row_2
       ...)
      (row_1
       ...
       [position_1 ... ● position_2 ...]
       [position_3 ... ○ position_4 ...]
       [position_5 ... ○ position_6 ...]
       row_2
       ...))
   "↑"])

(test-equal
 (judgment-holds (→ ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ● ● ○ ● ● ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])

                    ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ○ ○ ● ● ● ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds (→ ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ● ● ○ ● ● ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])

                    ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ● ● ● ○ ○ ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds (→ ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ● ● ○ ● ● ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])

                    ([· · ● ● ● · ·]
                     [· · ● ○ ● · ·]
                     [● ● ● ○ ● ● ●]
                     [● ● ● ● ● ● ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])))
 #t)

(test-equal
 (judgment-holds (→ ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ● ● ○ ● ● ●]
                     [● ● ● ● ● ● ●]
                     [· · ● ● ● · ·]
                     [· · ● ● ● · ·])

                    ([· · ● ● ● · ·]
                     [· · ● ● ● · ·]
                     [● ● ● ● ● ● ●]
                     [● ● ● ● ● ● ●]
                     [● ● ● ○ ● ● ●]
                     [· · ● ○ ● · ·]
                     [· · ● ● ● · ·])))
 #t)

(test-equal (judgment-holds (→ initial-board board) board)
            '(([· · ● ● ● · ·]
               [· · ● ○ ● · ·]
               [● ● ● ○ ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ○ ○ ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ○ ○ ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ○ ● ● ●]
               [· · ● ○ ● · ·]
               [· · ● ● ● · ·])))

(define-judgment-form peg-solitaire
  #:mode (→* I O)
  #:contract (→* board board)

  [---------------- "Reflexivity"
   (→* board board)]

  [(→  board_1 board_2)
   (→* board_2 board_3)
   -------------------- "Transitivity"
   (→* board_1 board_3)])

(test-equal
 (judgment-holds (→* ([● ● ● ○ ● ● ●])
                     ([● ● ● ○ ● ● ●])))
 #t)

(test-equal
 (judgment-holds (→* ([● ● ● ○ ● ● ●])
                     ([● ○ ○ ● ● ● ●])))
 #t)

(test-equal
 (judgment-holds (→* ([● ● ● ○ ● ● ●])
                     ([● ○ ● ○ ○ ● ●])))
 #t)
#;
(show-derivations (build-derivations (→* ([● ● ● ○ ● ● ●])
                                         ([● ○ ● ○ ○ ● ●]))))
```
</div>

```racket
(provide → →*)
```