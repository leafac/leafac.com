---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

We encoded booleans in the [previous section](booleans) with functions that represented what booleans *do*, as opposed to what they *are*. What booleans *do* is to select between two different options, so our encodings were functions that selected one of two arguments. For numbers, we will follow a similar strategy and use functions that do what numbers do: to count. And we will count with the only kind of operation that our core language supports: function application. 

Numbers in the surface language are encoded in the core language using functions that receive one function `f` and one arbitrary argument `x`, and apply `f` to `x` *number* times:

<div class="full-width" markdown="1">

| Surface Language Number | Core Language Encoding | `f` is applied to `x` *number* times |
|:-:|-|:-:|
| `0` | `(λ (f) (λ (x)                x))`      | 0 |
| `1` | `(λ (f) (λ (x)             (f x)))`     | 1 |
| `2` | `(λ (f) (λ (x)          (f (f x)))))))` | 2 |
| `3` | `(λ (f) (λ (x)       (f (f (f x)))))))` | 3 |
| `4` | `(λ (f) (λ (x)    (f (f (f (f x)))))))` | 4 |
| `5` | `(λ (f) (λ (x) (f (f (f (f (f x)))))))` | 5 |
| ⋮ | ⋮ | ⋮ |

</div>

In general, the core language encoding has the form `(λ (f) (λ (x) eᵇ))`, in which `eᵇ` is `(f (f (... x)))` where `f` appears *number* times. We can use Racket’s [`for/fold`](https://docs.racket-lang.org/reference/for.html#%28form._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._for%2Ffold%29%29) form to generate the program fragment `eᵇ`. We start with `eᵇ` being `x`, and count up to the number `n` given in the surface language, wrapping the fragment with another call to `f` in each step. The following is the complete `compile` clause:

```racket
[(? (λ (n) (and (integer? n) (not (negative? n)))) n)
    (compile `(λ (f) (λ (x) ,(for/fold ([eᵇ `x]) ([i (in-range n)]) `(f ,eᵇ)))))]
```

We can check that the above clause works as intended:

```racket
> (compile '0)
'(λ (f) (λ (x) x))
> (compile '5)
'(λ (f) (λ (x) (f (f (f (f (f x)))))))
```

* * *

To inspect numbers encoded in the core language, we have to convert them back to Racket numbers. We can do that by letting the arbitrary argument `x` be `0` and the function `f` be [`add1`](https://docs.racket-lang.org/reference/generic-numbers.html?q=add1#%28def._%28%28quote._~23~25kernel%29._add1%29%29):

```racket
(define (inspect/number e) ((e add1) 0))
```

The `add1` function will be applied to `0` *number* times:

```racket
(check-equal? (inspect/number (evaluate '0)) '0)
(check-equal? (inspect/number (evaluate '5)) '5)
```

* * *

Next, we address how to encode the numeric operations from our surface language as functions in the core language. The numeric operations include arithmetic operations (`add1`, `sub1`, `+`, `-`, `*`, `quotient`, and `expt`) and predicates (`zero?`, `<=`, `>=`, `=`, `<` and `>`).

Successor
=========

The successor function `add1` receives a number `n` as argument and returns `n + 1`. In our encoding, this means `add1` returns a number that applies `f` to `x` one time more than `n`:

```racket
[`add1 (compile `(λ (n) (λ (f) (λ (x) (f ((n f) x))))))]
```

In the encoding above, `(λ (f) (λ (x) (f ((n f) x))))` is the result of the `add1` function applied to `n`. It is a number following the form `(λ (f) (λ (x) ___))` that first applies `f` to `x` for `n` times by calling `n` with `f` and `x`: `((n f) x)`. Then it applies `f` once more to the result, to a total of `n + 1`: `(f ((n f) x))`.

We can test our encoding:

```racket
(check-equal? (inspect/number (evaluate '(add1 1))) '2)
```


- More interesting kinds of numbers: negatives, reals (fixed-point), complex.
