---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

Pairs are the basic building block for other [data structures](lists#other-data-structures). We already used pairs in our definition of [predecessor](#predecessor) to track the previous number on the number line. Pairs have two main uses: they couple two pieces of data together, and they allow us to transmit data between two points in the program (from the point where the pair is constructed to the point where we project an element out of it).

We construct pairs with the [`cons`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28quote._~23~25kernel%29._cons%29%29) function. It receives as arguments the two elements of the pair, `a` and `b`, and returns a pair encoded as a function. The pair encoding is a function that receives as argument a selector function `s`, which is applied to `a` and `b`. The selector `s` selects one of `a` or `b` to return:

```racket
[`cons `(λ (a b) (λ (s) (s a b)))]
```

The function `(λ (s) (s a b))` that encodes pairs couples `a` and `b` together, and allow us to transmit data between the point where the pair is defined to the point where we project one element out of it. The function representing a pair *remembers* the `a` and `b` from where the function was defined within `cons`, and different invocations to `cons` result in functions that remember different `a`s and `b`s. This kind of memory is related to something called *lexical scoping*, or *static scoping*, and functions that remember values from where it was defined are sometimes called *closures*.

To project the elements out of a pair, we define two functions: [`car`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28quote._~23~25kernel%29._car%29%29) selects the left element of a pair, and [`cdr`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28quote._~23~25kernel%29._cdr%29%29) selects the right one. These unintuitive names are historical artifacts that Racket preserves, and so does our surface language because it is a Racket subset. Given a pair-encoded-as-a-function `p`, the `car` and `cdr` functions call `p` with selectors that return the corresponding argument:<label class="margin-note"><input type="checkbox"><span markdown="1">The selectors for `car` and `cdr` are the same functions we used to [encode `#t` and `#f`](booleans). The purpose of our booleans-encoded-as-functions was to select between two possibilities, which is what the selector needs to do.</span></label>

```racket
[`car `(λ (p) (p (λ (a b) a)))]
[`cdr `(λ (p) (p (λ (a b) b)))]
```

To inspect a pair, we define a `inspect/pair` function that receives as argument a pair-encoded-as-a-function `e` and returns a Racket pair. It also needs to receive as arguments two other inspector functions to use on the left and right elements of the pair: `inspect/left` and `inspect/right`. We let these two inspectors come first in the list of arguments and let `inspect/pair` be partially applied with them, because it makes it easier to compose inspectors. For example, when inspecting a pair in which the left element is a pair of numbers and the right element is a boolean, we can write `(inspect/pair (inspect/pair inspect/number inspect/number) inspect/boolean)`, instead of `(inspect/pair (λ (e) (inspect/pair inspect/number inspect/number e)) inspect/boolean)`.

Our `inspect/pair` inspector projects the elements from the pair using the encoding of `car` and `cdr` we defined above by calling them with `evaluate` and applying the result to the given pair-encoded-as-a-function `e`:

```racket
(define ((inspect/pair inspect/left inspect/right) e)
  (cons (inspect/left ((evaluate 'car) e))
        (inspect/right ((evaluate 'cdr) e))))
```

We can test pairs:<label class="margin-note"><input type="checkbox"><span markdown="1">If you are following along and recreating the compiler from scratch, the tests for the [predecessor function](numbers#predecessor) and all other functions that depend on it should start to pass now.</span></label>

```racket
(check-equal? ((inspect/pair inspect/boolean inspect/number) (evaluate '(cons #t 5))) '(#t . 5))
(check-equal? (inspect/boolean (evaluate '(car (cons #t 5)))) '#t)
(check-equal? (inspect/number (evaluate '(cdr (cons #t 5)))) '5)
```

With this building block in place, we can construct other data structures, for example, [lists](lists).
