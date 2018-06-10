---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Unquoting
=========

We can *escape* from terms back to Racket with `unquote`, which is written with a comma (`,`),<label class="margin-note"><input type="checkbox"><span markdown="1">The `term` form is similar to the [quasiquote](https://docs.racket-lang.org/guide/qq.html), but it is aware of names defined with `define-term` as well as metafunctions, reduction relations and so forth.</span></label> for example:

```racket
(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
```

In the listing above, the `,(+ 1 2)` form means “*escape* from the term back to Racket, compute `(+ 1 2)` and place the result here.”

* * *

[Previously](terms), we used `define-term` to name terms, for example:

```racket
(define-term a-peg ●)
(test-equal (term a-peg)
            '●)
```

We can also assign terms to regular Racket names with `define`, for example:

```racket
(define a-space (term ○))
```

We access this name outside terms as usual:

```racket
(test-equal a-space
            '○)
```

In terms, we unquote to escape back to Racket and access the name, for example:

```racket
(test-equal (term ,a-space)
            '○)
```

* * *

The `define-term` form *is not* a shorthand for `(define ___ (term ___))` because names defined with `define-term` are only available in other terms, not directly in Racket. If we try to access in Racket a name defined with `define-term`, for example, `a-peg`, the result is a syntax error:

```racket
> a-peg
a-peg: illegal use of syntax in: a-peg
```

The converse also holds: names defined with `define` are only available directly in Racket, not in terms. Trying to access the name `a-space` defined with `define` in a term is not a syntax error, but does not produce the result you might expect:

```racket
(test-equal (term a-space)
            'a-space)
```

In the listing above, the `a-space` in `term` is interpreted as a symbol, not as a reference to the Racket variable `a-space`. This is a common pitfall, so *pay attention to the different contexts and do not mix Racket with terms*.

* * *

With `unquote` we can access names defined with `define` from within terms and mix them with names defined with `define-term`, for example:

```racket
(define-term a-peg ●)
(define a-space (term ○))
(test-equal (term (● a-peg ,a-space))
            '(● ● ○))
```

We can use the `term` form from within `unquote`:

```racket
(test-equal (term (● ,(term a-peg) ,a-space))
            '(● ● ○))
```

* * *

We can unquote to escape back to Racket in the definitions of all the forms we covered thus far, including metafunctions, judgment forms, reduction relations and so forth. For example, we can define a `count-●` metafunction to count how many pegs there are in a board by unquoting and relying on Racket’s functions for manipulating lists:

```racket
(define-metafunction peg-solitaire
  count-● : board -> integer
  [(count-● ([position ...] ...))
   ,(count (λ (position) (equal? position (term ●)))
           (term (position ... ...)))])
```

The listing above matches the input board with the pattern `([position ...] ...)`, so the name `position` in the template refers to a list of lists of `position`s. We use the template `(position ... ...)` to *flatten* this list of lists. We then unquote and use Racket’s `count` to count how many `position`s are `equal?` to pegs (`●`).

* * *

In summary:

<div class="full-width no-padding-table" markdown="1">

| | `define` | Racket | terms | `unquote` | `,peg` |
| | `define-term` | terms | Racket | `term` | `(term space)` |
| **Names defined with** | **______________ are available in** | **_______ but can be accessed in** | **_______ with** | **________, for example,** | **_____________** |

</div>

Extensions and Holes
====================

We can define languages, metafunctions, judgment forms and so forth by extending existing definitions. In the following example, we extend the `peg-solitaire` [language](languages) into the `Peg-Solitaire` language:

```racket
(define-extended-language Peg-Solitaire peg-solitaire
  [Board ::= (row ... hole row ...)])
```

The `Peg-Solitaire` language includes all names in `peg-solitaire` as well as the new name `Board`. It is equivalent to the following:

```racket
(define-language Peg-Solitaire
  [board    ::= (row ...)]
  [row      ::= [position ...]]
  [position ::= peg space padding]
  [peg      ::= ●]
  [space    ::= ○]
  [padding  ::= ·]
  [Board    ::= (row ... hole row ...)])
```

The name `Board` refers to pattern `(row ... hole row ...)`. A `hole` is a special built-in pattern in PLT Redex—similar to how `any` is a special built-in pattern. A `Board` is a `board` with a missing `row`, the `hole`. We can match a board with the `in-hole` form, for example:

```racket
(test-equal (redex-match? Peg-Solitaire (in-hole Board row)
                          (term ([●]
                                 [○]
                                 [●])))
            #t)
```

The pattern `(in-hole Board row)` means “the `Board` is a `board` with a `row` missing.” This pattern matches the simplified input board in three ways:

```racket
> (redex-match Peg-Solitaire (in-hole Board row)
               (term ([●]
                      [○]
                      [●])))
(list
 (match (list (bind 'Board '((●) (○) hole)) (bind 'row '(●))))
 (match (list (bind 'Board '((●) hole (●))) (bind 'row '(○))))
 (match (list (bind 'Board '(hole (○) (●))) (bind 'row '(●)))))
```

The first match, for example, means the missing `row` in the `Board` is the last one.

* * *

With `Peg-Solitaire` and `Board`s with `hole`s, we can shorten the definition of the [`⇨` reduction relation](reduction-relations). We define the `⇨/hole` reduction relation that extends `⇨` and replaces the `→` clause with a simpler definition using `in-hole`:<label class="margin-note"><input type="checkbox"><span markdown="1">The `→` clause is *replaced* because we use the same name as the clause in the original `⇨` reduction relation. If we had used a different name, the new clause would be *added* to the extended reduction relation.</span></label>

```racket
(define
  ⇨/hole
  (extend-reduction-relation
   ⇨
   Peg-Solitaire
   #:domain board

   (--> (in-hole Board [position_1 ... ● ● ○ position_2 ...])
        (in-hole Board [position_1 ... ○ ○ ● position_2 ...])
        "→")))
```

The `(in-hole Board [position_1 ... ● ● ○ position_2 ...])` in the input pattern matches a row including the `● ● ○` sequence. This saves us from having to repeat the surroundings by writing `(row_1 ... ___ row_2 ...)`. The `(in-hole Board [position_1 ... ○ ○ ● position_2 ...])` in the template does the opposite, *plugging* the term `[position_1 ... ○ ○ ● position_2 ...]` in the `hole` we had left in `Board`.

The `⇨/hole` extended reduction relation works the same as the `⇨` original reduction relation:

```racket
(test-equal (apply-reduction-relation ⇨/hole (term initial-board))
            '(([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ○ ○ ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ○ ● ● ●]
               [· · ● ○ ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ○ ● · ·]
               [● ● ● ○ ● ● ●]
               [● ● ● ● ● ● ●]
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
```

TODO
====

```racket
redex-check: /Users/leafac/Code/www.leafac.com/prose/playing-the-game-with-plt-redex/other-features.rkt:26
no counterexamples in 1000 attempts
```

```racket
redex-check: /Users/leafac/Code/www.leafac.com/prose/playing-the-game-with-plt-redex/other-features.rkt:31
counterexample found after 125 attempts:
((○) (●) (●))
```

{% include_relative judgment-form.svg %}
