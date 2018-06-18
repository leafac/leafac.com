---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Pattern matching is the essence of how PLT Redex works, and all the forms we will explore in the following sections rely on it. But before we can experiment with pattern matching, we have to define a language, and to define a language we must understand pattern matching. To solve this conundrum, we define a dummy empty language for this section and revisit the definition [later](languages):

<div class="code-block" markdown="1">
`pattern-matching.rkt`
```racket
#lang racket
(require redex "terms.rkt")

(define-language peg-solitaire)
```
</div>

The most basic thing we can do with pattern matching is to verify whether a term matches a pattern with the `redex-match?` form:

```racket
(redex-match? <language> <pattern> <term>)
```

The simplest kind of pattern is the literal term, for example:

```racket
(test-equal (redex-match? peg-solitaire ●
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (● ● ○)
                          (term         (● ● ○)))
            #t)
```

The underscore pattern (`_`) means “anything,”<label class="margin-note"><input type="checkbox"><span markdown="1">Similar to the dot (`.`) in regular expressions and the star (`*`) in Unix path patterns.</span></label> for example:

```racket
(test-equal (redex-match? peg-solitaire _
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (_ ● ○)
                          (term         (● ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (_ _ ○)
                          (term         (● ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (_ _ _)
                          (term         (● ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire _
                          (term         (● ● ○)))
            #t)
```

In the listing above, the underscore pattern (`_`) can match elements in the list, or the whole list (last example). Another pattern that matches anything is the `any` pattern, for example:

```racket
(test-equal (redex-match? peg-solitaire (any ● ○)
                          (term         (●   ● ○)))
            #t)
```

But the underscore pattern (`_`) and the `any` pattern are not equivalent. In many of the forms that we will explore in the next sections, patterns not only recognize terms, but also introduce names to the fragments that were matched, which we can use to build other terms. These names are similar to the ones we defined with `define-term` in the [previous section](terms), except that they will be available only within the forms containing the pattern.

We can observe the names a pattern introduces with the `redex-match` form which is similar to the `redex-match?` form but returns the names instead of just whether the pattern matched or not:

```racket
> (redex-match peg-solitaire (_ ● ○)
               (term         (● ● ○)))
(list (match '()))

> (redex-match peg-solitaire (any ● ○)
               (term         (●   ● ○)))
(list (match (list (bind 'any '●))))
```

In the first interaction, no names are introduced, as indicated by the empty list `'()`, and in the second interaction the name `any` is bound to the term `●`. This is the output in more detail:

```racket
(list⁶ (match⁵ (list⁴ (bind³ 'any¹ '●²))))
```

1. `any`: The name in the pattern.
2. `●`: The term.
3. `bind`: The binding data structure representing the association between the name and the term.
4. `list`: There might be multiple bindings in a pattern.
5. `match`: The matching data structure representing one way to match the term with the pattern.
6. `list`: There might be multiple ways to match a term with a pattern.

The `any` form may appear more than once in a pattern to represent parts of a term that repeat, for example:

```racket
(test-equal (redex-match? peg-solitaire (any any ○)
                          (term         (●   ●   ○)))
            #t)
(test-equal (redex-match? peg-solitaire (any any any)
                          ;                      ≠
                          (term         (●   ●   ○)))
            #f)
```

The second pattern in the listing above does not match<label class="margin-note"><input type="checkbox"><span markdown="1">Note the `#f`.</span></label> because the `any` name cannot be associated with `●` and `○` at the same time.

A pattern may include multiple `any`s that associate with different terms by adding a suffix of the form `any_<suffix>`, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 any_2 any_3)
                          (term         (●     ●     ○)))
            #t)


> (redex-match peg-solitaire (any_1 any_2 any_3)
               (term         (●     ●     ○)))
(list (match (list (bind 'any_1 '●) (bind 'any_2 '●) (bind 'any_3 '○))))
```

Each `any_<suffix>` was associated with a different term.

We can insist that the first and second list elements are the same, but allow the third to differ by using `any_1` twice, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          (term         (●     ●     ○)))
            #t)


> (redex-match peg-solitaire (any_1 any_1 any_2)
               (term         (●     ●     ○)))
(list (match (list (bind 'any_1 '●) (bind 'any_2 '○))))
```

Using different suffixes allows patterns to match to different terms, but they might be the same, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          (term         (●     ●     ●)))
            #t)


> (redex-match peg-solitaire (any_1 any_1 any_2)
               (term         (●     ●     ●)))
(list (match (list (bind 'any_1 '●) (bind 'any_2 '●))))
```

The pattern does not match if the two occurrences of `any_1` are different, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          ;                    ≠
                          (term         (●     ○     ○)))
            #f)
```

* * *

We can match a sequence of terms using ellipsis (`...`), which means “zero or more of the previous pattern,” for example:

```racket
(test-equal (redex-match? peg-solitaire (any ...)
                          (term         (● ● ○)))
            #t)


> (redex-match peg-solitaire (any ...)
               (term         (● ● ○)))
(list (match (list (bind 'any '(● ● ○)))))
```

A pattern may match a term in multiple ways when it includes two or more ellipses, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 ... any_2 ...)
                          (term         (● ● ○)))
            #t)


> (redex-match peg-solitaire (any_1 ... any_2 ...)
               (term         (● ● ○)))
(list
 (match (list (bind 'any_1 '()) (bind 'any_2 '(● ● ○))))
 (match (list (bind 'any_1 '(●)) (bind 'any_2 '(● ○))))
 (match (list (bind 'any_1 '(● ●)) (bind 'any_2 '(○))))
 (match (list (bind 'any_1 '(● ● ○)) (bind 'any_2 '()))))
```

Similar to how we suffixed `any`, we can suffix ellipses, `..._<suffix>`, constraining them to match sequences of the same length, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._n)
                          (term         (● ●         ○ ●)))
            #t)


> (redex-match peg-solitaire (any_1 ..._n any_2 ..._n)
               (term         (● ●         ○ ●)))
(list (match (list (bind 'any_1 '(● ●)) (bind 'any_2 '(○ ●)))))


(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._n)
                          ;                ≠
                          (term         (● ● ○)))
            #f)
```

In the listing above, the first pattern matches because it can divide the term into two parts of the same length and satisfy the `..._n` constraint. But the second pattern does not match, because there is no way to divide a 3-element list into two sequences of the same length. Ellipses with different suffixes may match sequences of different lengths, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._m)
                          (term         (● ● ○)))
            #t)
```

The listing above is equivalent to the one without suffixed ellipses, because the ellipses have different suffixes, so they can match sequences of different lengths.

Finally, we can nest ellipses, and they still mean “zero or more of the previous pattern,” even if said pattern also contains ellipses itself. With this, we can define a pattern that matches the `initial-board` from the [previous section](terms):<label class="margin-note"><input type="checkbox"><span markdown="1">This is not the *only* pattern that matches the `initial-board`; for example, the `any` pattern and the underscore pattern (`_`) would also match it.</span></label>

```racket
(test-equal (redex-match? peg-solitaire
                          ([· ... ● ... ○ ... ● ... · ...]
                           ...)
                          (term initial-board))
            #t)
```

The part that reads `[· ... ● ... ○ ... ● ... · ...]` means “a sequence of zero or more paddings (`·`), followed by a sequence of zero or more pegs (`●`), followed by a sequence of zero or more spaces (`○`), followed by a sequence of zero or more pegs (`●`), followed by a sequence of zero or more paddings (`·`).” This matches a single row of our initial board, regardless of whether it is the first row, which includes paddings but no spaces, or the fourth row, which includes a space but no paddings. The part that reads `([___] ...)` means “zero or more rows”.
