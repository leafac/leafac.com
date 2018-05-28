---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Pattern matching is the essence of how PLT Redex works and all the forms we will explore in the following sections rely on it. But before we can experiment with pattern matching, we have to define a language, and to define a language we must understand pattern matching. To solve this conundrum, we define a dummy empty language for this section and revisit the definition [later](languages):

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
