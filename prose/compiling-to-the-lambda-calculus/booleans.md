---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

With the [architecture](architecture) in place, we are ready to start defining the `compile` clauses that will compile the forms from the [surface language](surface-language) into the [core language](core-language). We begin with one of the simplest kind of values: booleans. Our surface language includes boolean values (`#t` and `#f`), operators (`and`, `or`, `not`, and `xor`), and one conditional control-flow operator (`if`).

The boolean operators `and` and `or` are short-circuiting, which means that they do not evaluate operands when the result is already determined. For example, in the expression `(and #f e)` we do not need to evaluate `e` because the result of is known to be `#f` as soon as we evaluate the first operand. It may seem unimportant whether or not we evaluate `e`—we could just discard `e`’s value in the end and return `#f`—but `e` could not terminate (for example, it could be `(letrec ([f (λ (x) (f x))]) (f 0))`), in which case the short-circuiting would guarantee termination. Because of short-circuiting, the `and` and `or` operators are control-flow operators, similar to `if`. In fact, as we will see in this section, `and` and `or` will be implemented in terms of `if`. The other boolean operators (`not` and `xor`) are not short-circuiting because they always need to evaluate all their arguments to determine their output.

Our surface language restricts the boolean operators to only work on boolean values. This is only a subset of what Racket can do, because in Racket any non-false value (anything that is not `#f`) is considered *truthy*. For example, `(if 5 0 3)` evaluates to `0` in Racket, because `5` is considered *truthy*, but its behavior in our surface language is unspecified. One way to implement Racket’s behavior on non-booleans would be to tag each value with its type and consider *truthy* any value for which the predicate `boolean?` does not hold. But this tagging would complicate our compiler so we prefer to restrict our surface language to avoid it.

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

Conditionals
============

The main operation we perform on booleans is to use them as the condition upon which to select what code to run in the `if` form. We encoded [boolean values](#values) as functions that select its first (`#t`) or second (`#f`) argument. Our first attempt at encoding the `if` form is to use the condition as a function that selects either the then (`ᵗ`) or the else (`ᵉ`) branches:

```racket
[`(if ,eᶜ ,eᵗ ,eᵉ) (compile `(,eᶜ ,eᵗ ,eᵉ))] ;; INCORRECT
```

This captures the intent of the conditional and works for simple cases in which both branches evaluate to a value:

```racket
(check-equal? (inspect/boolean (evaluate '(if #t #t #f))) '#t)
(check-equal? (inspect/boolean (evaluate '(if #f #t #f))) '#f)
```

But this encoding is incorrect because it lets both `eᵗ` and `eᵉ` evaluate to values before selecting one to return. This leads to problems when the other expression runs into an infinite loop and never returns a value, for example:

```racket
(if #t #t (letrec ([f (λ (x) (f x))]) (f 0)))
```

The result of this expression should be the `#t` from the then branch, but evaluation using the encoding above does not terminate, because it tries to evaluate the else branch that loops infinitely (`(letrec ([f (λ (x) (f x))]) (f 0))`). At first it may seem that this example is artificial and that this is not a big issue in practice, but any recursive function that does something useful uses a conditional to check whether it reached the base case.

We want an encoding that *delays* the computation of the conditional branches until after we have selected which branch should run. We can do this by wrapping the branches in functions and only calling one of these functions. Our surface language includes a convenience form called `thunk` for this purpose:

```racket
[`(if ,eᶜ ,eᵗ ,eᵉ) (compile `((,eᶜ (thunk ,eᵗ) (thunk ,eᵉ))))]
```

In the encoding above, note the extra pair of parentheses around the selection of the branches `((,eᶜ (thunk ,eᵗ) (thunk ,eᵉ)))`. These parentheses are calling the function that represents which branch to run, and the other branch’s function is discarded and never run. Now conditionals behave as we expect:

```racket
(check-equal? (inspect/boolean (evaluate '(if #t #t (letrec ([f (λ (x) (f x))]) (f 0))))) '#t)
```

Operators
=========

There are four boolean operators in our surface language: `and`, `or`, `not` and `xor`. The first two, `and` and `or`, are interesting because they are short-circuiting, and because they accept any number of arguments. The last two, `not` and `xor`, can be encoded directly as functions with a fixed number of arguments, and we will make them interesting by manipulating the booleans-encoded-as-functions directly.

We start with the simplest scenario, in which the `and` and `or` operators are called with no arguments. They return the *zero* of the corresponding operations:

```racket
[`(and) (compile `#t)]
[`(or) (compile `#f)]
```

The *zero* of `and` is `#t` because `(and #t e)` is equivalent to `e`—similar to the role that zero plays for [addition](numbers#addition) (`(+ 0 e)` is equivalent to `e`). The same holds for `or` and `#f`. The test for this is trivial:

```racket
(check-equal? (inspect/boolean (evaluate '(and))) '#t)
(check-equal? (inspect/boolean (evaluate '(or))) '#f)
```

When `and` and `or` are called with one argument, the argument just passes through:

```racket
[`(and ,e₁) (compile e₁)]
[`(or ,e₁) (compile e₁)]
```

Again, the tests are trivial:

```racket
(check-equal? (inspect/boolean (evaluate '(and #t))) '#t)
(check-equal? (inspect/boolean (evaluate '(or #t))) '#t)
```

Next, we consider the case in which `and` and `or` are called with two expressions. We need the encoding to short-circuit, only evaluating the second expression to an argument if the first does not determine the result by itself. We can leverage the `if` form we defined in the [previous section](#conditionals):

```racket
[`(and ,e₁ ,e₂) (compile `(if ,e₁ ,e₂ #f))]
[`(or ,e₁ ,e₂) (compile `(if ,e₁ #t ,e₂))]
```

We translate `(and e₁ e₂)` to `(if e₁ e₂ #f)` because if `e₁` is false, then we know the whole expression evaluates to `#f`; otherwise we let `e₂` determine the output: if it is true, then `(and e₁ e₂)` holds. But the `if` form only evaluates `e₂` if `e₁` is false, accomplishing the short-circuiting. We translate `or` to `if` based on a similar argument.

The following are a few tests for binary `and` and `or`, including tests for short-circuiting:

```racket
(check-equal? (inspect/boolean (evaluate '(and #t #t))) '#t)
(check-equal? (inspect/boolean (evaluate '(and #t #f))) '#f)
(check-equal? (inspect/boolean (evaluate '(and #f (letrec ([f (λ (x) (f x))]) (f 0))))) '#f)
(check-equal? (inspect/boolean (evaluate '(or #f #f))) '#f)
(check-equal? (inspect/boolean (evaluate '(or #t #f))) '#t)
(check-equal? (inspect/boolean (evaluate '(or #t (letrec ([f (λ (x) (f x))]) (f 0))))) '#t)
```

Finally, we address the case in which `and` and `or` are called with more than two arguments. This is equivalent to nesting calls to the binary version of these operators:

```racket
[`(and ,e₁ ,e₂ ...) (compile `(and ,e₁ (and ,@e₂)))]
[`(or ,e₁ ,e₂ ...) (compile `(or ,e₁ (or ,@e₂)))]
```

For example, `(and #f #t #f)` is equivalent to `(and #f (and #t #f))`. As soon as evaluation reaches the first `#t`, the whole form short-circuits and the remaining expressions do not run.

The following are tests for these forms:

```racket
(check-equal? (inspect/boolean (evaluate '(and #t #f #t))) '#f)
(check-equal? (inspect/boolean (evaluate '(or #t #f #t))) '#t)
```

Our encodings for `and` and `or` are complete, we now move on to the remaining two boolean operators: `not` and `xor`.

* * *

Unlike the `and` and `or` operators, `not` and `xor` can only determine their result after evaluating all their arguments, so they do not need to short-circuit. Also, they are only defined for a fixed number of arguments (one for `not` and two for `xor`). So `not` and `xor` can be functions in the core language that operate on our booleans-encoded-as-functions directly.

Recall that our encoding is a function that selects one of two arguments. The purpose of the `not` operator is to negate a boolean, so its encoding can be a function that selects the *other* argument:

```racket
[`not (compile `(λ (p) (λ (a b) (p b a))))]
```

The function receives a boolean encoded as a function `p`<label class="margin-note"><input type="checkbox"><span markdown="1">It is common to use `p` (which stands for “predicate”), `q`, `r`, and so forth for boolean metavariables.</span></label> and returns a boolean encoded as a function that returns the opposite of `p`: `(λ (a b) (p b a))`. The returned value achieves the goal by inverting the arguments passed to `p`: whatever `p` would choose, `(not p)` chooses the opposite.

We can test `not` on all possible inputs:

```racket
(check-equal? (inspect/boolean (evaluate '(not #f))) '#t)
(check-equal? (inspect/boolean (evaluate '(not #t))) '#f)
```

Finally, for `xor`, we again use a boolean-encoded-as-a-function to select between two options. When given two arguments `p` and `q`, `xor` uses `p` to choose between `(not q)` (if `p` is true) and `q` (if `p` is false). So `(xor p q)` holds if and only if `p` is true and `q` is false, or vice-versa:

```racket
[`xor (compile `(λ (p q) (p (not q) q)))]
```

We can test `xor` on a few inputs:

```racket
(check-equal? (inspect/boolean (evaluate '(xor #t #f))) '#t)
(check-equal? (inspect/boolean (evaluate '(xor #t #t))) '#f)
```

* * *

This concludes our exploration of booleans encoded as functions. At its core, booleans are a way of *selecting* between different options, which is a fundamental computational task. Next, we will look at encoding [numbers](numbers) as functions, and booleans will be useful for operations like `<=`, which return boolean values.
