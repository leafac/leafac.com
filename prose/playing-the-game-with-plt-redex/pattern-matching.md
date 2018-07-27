---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

Pattern matching is the foundation of all the PLT Redex forms we will explore in the later sections. To experiment with pattern matching, we must first define a language, but to define a language we must first understand pattern matching. We solve this conundrum by defining a dummy empty language,<label class="margin-note"><input type="checkbox"><span markdown="1">The same we did in the [Overview](overview)</span></label> which we will revisit in the [next section](languages):

<div class="code-block" markdown="1">
`pattern-matching.rkt`
```racket
#lang racket
(require redex "terms.rkt")

(define-language peg-solitaire)
```
</div>

The primary purpose of pattern matching is to verify whether a term matches a pattern. We can ask this question with the [`redex-match?`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=redex-match%3F#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._redex-match~3f%29%29) form:

```racket
(redex-match? <language> <pattern> <term>)
```

The simplest kind of pattern is a literal term, for example:

```racket
(test-equal (redex-match? peg-solitaire ●
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (● ● ○)
                          (term         (● ● ○)))
            #t)
```

For example, the listing above shows that the pattern `●` matches the term `(term ●)`.

* * *

The [underscore pattern](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=test-equal#%28tech.__%29) (`_`) means “anything,” similar to the dot (`.`) in regular expressions. For example:

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

In the listing above, the underscore pattern (`_`) can match either elements in the list, or the whole list, as in the last example. Another pattern that matches anything is the [`any`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=test-equal#%28tech._any%29) pattern, for example:

```racket
(test-equal (redex-match? peg-solitaire (any ● ○)
                          (term         (●   ● ○)))
            #t)
```

But the underscore pattern (`_`) and the `any` pattern are not equivalent: only the latter introduces names. In the next sections we will explore forms in which patterns not only recognize terms, but also name the fragments that were matched, so we can use them to build other terms. These names are similar to the ones we defined with `define-term` in the [previous section](terms), but they are available only within the forms containing the pattern.

We can observe the names a pattern introduces with the [`redex-match`](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=redex-match#%28form._%28%28lib._redex%2Freduction-semantics..rkt%29._redex-match%29%29) form, which is similar to the `redex-match?` form but returns the introduced names instead of just whether the pattern matched or not:

```racket
> (redex-match peg-solitaire (_ ● ○)
               (term         (● ● ○)))
(list (match '()))

> (redex-match peg-solitaire (any ● ○)
               (term         (●   ● ○)))
(list (match (list (bind 'any '●))))
```

In the first interaction, no names are introduced, as indicated by the empty list `'()`, and in the second interaction the name `any` is associated with the term `●` that was matched. This is the output in more detail:

```racket
(list⁶ (match⁵ (list⁴ (bind³ 'any¹ '●²))))
```

1. `any`: The name in the pattern.
2. `●`: The term that was matched by `any`.
3. `bind`: The [binding data structure](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=bind#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._bind%29%29) representing the association between the name and the term.
4. `list`: There might be multiple bindings in a pattern.
5. `match`: The [matching data structure](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=bind#%28def._%28%28lib._redex%2Freduction-semantics..rkt%29._match~3f%29%29) representing one way to match the term with the pattern.
6. `list`: There might be multiple ways to match a term with a pattern.

The `any` form may appear more than once in a pattern to represent parts of a term that repeat, for example:

```racket
(test-equal (redex-match? peg-solitaire (any any ○)
                          (term         (●   ●   ○)))
            #t)
(test-equal (redex-match? peg-solitaire (any ●   any)
                          ;                      ≠
                          (term         (●   ●   ○)))
            #f)
```

The second pattern in the listing above does not match<label class="margin-note"><input type="checkbox"><span markdown="1">Note the `#f`.</span></label> because the `any` name cannot be associated with `●` and `○` at the same time.

A pattern may include multiple `any`s that associate with different terms by adding a suffix, `any_<suffix>`, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 any_2 any_3)
                          (term         (●     ●     ○)))
            #t)


> (redex-match peg-solitaire (any_1 any_2 any_3)
               (term         (●     ●     ○)))
(list (match (list (bind 'any_1 '●) (bind 'any_2 '●) (bind 'any_3 '○))))
```

Each `any_<suffix>` was associated with a different term.

We can require that the first and second list elements are the same, but allow the third to differ by using `any_1` twice, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          (term         (●     ●     ○)))
            #t)


> (redex-match peg-solitaire (any_1 any_1 any_2)
               (term         (●     ●     ○)))
(list (match (list (bind 'any_1 '●) (bind 'any_2 '○))))
```

Using different suffixes allows patterns to match different terms, but does not require them to be different, for example:

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

We can match a sequence of terms using [ellipsis](https://docs.racket-lang.org/redex/The_Redex_Reference.html?q=bind#%28tech._pattern._sequence%29) (`...`), which means “zero or more of the previous pattern,” similar to the Kleene star (`*`) in regular expressions. For example:

```racket
(test-equal (redex-match? peg-solitaire (any ...)
                          (term         (● ● ○)))
            #t)


> (redex-match peg-solitaire (any ...)
               (term         (● ● ○)))
(list (match (list (bind 'any '(● ● ○)))))
```

In the listing above the name `any` was associated with the sequence `● ● ○`.

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

In the listing above, the first pattern matches because it can divide the term into two parts of the same length, thus satisfying the `..._n` constraint. But the second pattern does not match, because there is no way to divide a 3-element list into two sequences of the same length. Ellipses with different suffixes may match sequences of different lengths, for example:

```racket
(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._m)
                          (term         (● ● ○)))
            #t)
```

The listing above is equivalent to the one in which ellipses are not suffixed; ellipses can match sequences of different lengths because they have different suffixes.

Finally, we can nest ellipses, and they still mean “zero or more of the previous pattern,” even if said pattern contains ellipses itself. With this, we can define a pattern that matches the `initial-board` from the [previous section](terms):<label class="margin-note"><input type="checkbox"><span markdown="1">This is not the *only* pattern that matches the `initial-board`; for example, the `any` pattern and the underscore pattern (`_`) match it as well.</span></label>

```racket
(test-equal (redex-match? peg-solitaire
                          ([· ... ● ... ○ ... ● ... · ...]
                           ...)
                          (term initial-board))
            #t)
```

The part that reads `[· ... ● ... ○ ... ● ... · ...]` means “a sequence of zero or more paddings (`·`), followed by a sequence of zero or more pegs (`●`), followed by a sequence of zero or more spaces (`○`), followed by a sequence of zero or more pegs (`●`), followed by a sequence of zero or more paddings (`·`).” This matches a single row of our initial board, regardless of whether it is the first row, `[· · ● ● ● · ·]`, which includes paddings but no spaces, or the fourth row, `[● ● ● ○ ● ● ●]`, which includes a space but no paddings. The part that reads `([___] ...)` means “zero or more rows.”
