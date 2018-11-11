---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

With the [architecture](architecture) in place, we are ready to start defining the `compile` clauses that will compile the forms from the [surface language](surface-language) into the [core language](core-language). We begin with one of the simplest kind of values: booleans. Our surface language includes boolean values (`#t` and `#f`), operators (`and`, `or`, `not`, and `xor`), and one conditional control-flow operator (`if`).

The boolean operators `and` and `or` are short-circuiting, which means that they do not evaluate operands when the result is already determined. For example, in the expression `(and #f e)` we do not need to evaluate `e` because the result of is known to be `#f` as soon as we evaluate the first operand. It may seem unimportant whether or not we evaluate `e`—we could just discard `e`’s value in the end and return `#f`—but `e` could not terminate (for example, it could be `(letrec ([f (λ (x) (f x))] (f 0)))`), in which case the short-circuiting would guarantee termination. Because of short-circuiting, the `and` and `or` operators are control-flow operators, similar to `if`. In fact, as we will see in this section, `and` and `or` will be implemented in terms of `if`. The other boolean operators (`not` and `xor`) are not short-circuiting because they always need to evaluate all their arguments to determine their output.

Our surface language restricts the boolean operators to only work on boolean values. This is only a subset of what Racket can do, because in Racket any non-false value (anything that is not `#f`) is considered *true-ish*. For example, `(if 5 0 3)` evaluates to `0` in Racket, because `5` is considered *true-ish*, but its behavior in our surface language is unspecified. One way to implement Racket’s behavior on non-booleans would be to tag each value with its type and consider *true-ish* any value for which the predicate `boolean?` does not hold. But this tagging would complicate our compiler so we prefer to restrict our surface language to avoid it.

Values
======

The ultimate utility of boolean values is to select between two possibilities. For example, in the conditional operator `(if condition then else)` the `condition` boolean value selects between the `then` and the `else` branches. We can encode boolean values with functions that return only one of two given arguments. To align with `if`’s behavior, we will choose to let `#t` return the first argument, and `#f` return the second argument, because the `then` branch comes first and the `else` branch comes second:

```racket
[#t (compile `(λ (a b) a))]
[#f (compile `(λ (a b) b))]
```

To convert these values back to Racket for [inspection](architecture#inspectors), we apply them to `#t` and `#f`, which we have to provide separately because our core language only supports [functions of one argument](functions#functions-with-multiple-arguments):

```racket
(define (inspect/boolean e) ((e #t) #f))
```

We can now test our encoding by going from our surface language to our core language, and then back to Racket:

```racket
(check-equal? (inspect/boolean (evaluate '#t)) '#t)
(check-equal? (inspect/boolean (evaluate '#f)) '#f)
```
