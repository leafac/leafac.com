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
| `2` | `(λ (f) (λ (x)          (f (f x))))`    | 2 |
| `3` | `(λ (f) (λ (x)       (f (f (f x)))))`   | 3 |
| `4` | `(λ (f) (λ (x)    (f (f (f (f x))))))`  | 4 |
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

Predecessor
===========

<aside markdown="1">
<figure markdown="1">
{% include_relative numbers--sub1.svg %}
<figcaption markdown="1">
Tracing the execution of the predecessor function `sub1`  where `n` is `5`. The initial argument `x` (in blue) is a pair containing zeroes. The function `f` (in green) is applied `n` times (there are five green arrows in the figure), and it moves a sliding window on the number line one step to the right. Finally, the answer is the left element of the pair (in magenta).
</figcaption>
</figure>
</aside>

The predecessor function `sub1` is only defined for positive numbers, because the predecessor of `0` would be `-1` and our core language does not support negative numbers. The predecessor function receives as argument a number `n` that applies a function a function `f` to `x` for *n* times, and it returns a number `n - 1` that applies `f` one time less than `n`. But there is no way to *undo* a function call, so we need to find a way to find the predecessor by *counting up*.

Our strategy for finding the predecessor of a number by counting up to it is to keep track of the previous number we counted. The figure shows an example of our strategy in action. We keep track of the previous number by [pairing](pairs) it with the current number, and in the end we project the answer out of the pair. The following is the `compile` clause for encoding `sub1`:

```racket
[`sub1 (compile `(λ (n) (car ((n (λ (x) (let ([p (cdr x)]) (cons p (add1 p))))) (cons 0 0)))))]
```

The encoding is a function that receives an argument `n`: `(λ (n) ___)`. It calls this number `n` with an initial argument `x` that is a pair of zeroes: `(cons 0 0)`. The iteration function `f` slides the window on the number line. It starts by capturing the right element in the pair to be the next predecessor `p`: `(let ([p (cdr x)]) ___)`. Then it builds the next pair with the predecessor `p` and its [successor](#successor): `(cons p (add1 p))`. When `f` finished counting up to `n` and sliding the window, we project the left element of the pair to be our final answer: `(car ___)`.

We can test our predecessor function:

```racket
(check-equal? (inspect/number (evaluate '(sub1 5))) '4)
```

Addition
========

We can implement addition (`+`) in terms of [successor](#successor) by noting that `m + n` amounts to applying `add1` to `m` for `n` times. Our encoding of numbers using functions captures this notion of applying a function for a number of times, so we just have to call `n` with `add1` as the function `f` to apply and pass `m` as the initial value `x`:

```racket
[`+ (compile `(λ (m n) ((n add1) m)))]
```

But addition in our surface language works over any number of arguments, not just two (`m` and `n`). So we need to add clauses for the cases in which `+` is applied to zero, one, two or more arguments. We start with the case in which it is applied to one argument, and we let it return `0`, because zero is a neutral number with respect to addition (`(+ 0 e)` is equivalent to `e`):

```racket
[`(+) (compile `0)]
```

When `+` is applied to a single argument, it does not alter the argument, so we just return it:

```racket
[`(+ ,e₁) (compile e₁)]
```

When `+` is applied to two arguments, we can use the encoding of `+` we defined above:

```racket
[`(+ ,e₁ ,e₂) (compile `(,(compile `+) ,(compile e₁) ,(compile e₂)))]
```

In the encoding above, the inner call to `(compile +)` will produce the addition function we defined in the beginning of this section.

When `+` is applied to more than two arguments, we need to convert it into a sequence of calls to `+` with two arguments. There are multiple ways to do this, for example, `(+ 0 1 2)` is equivalent to both `(+ (+ 0 1) 2)` (left associative) and `(+ 0 (+ 1 2))` (right associative). The results of these two alternatives are the same, because addition is an associative operation. But, as we will see on the [next section](#subtraction), subtraction is similar to addition in many ways, except that it is *not* associative. So, to align addition and subtraction better, we will choose the first option (left associative):

```racket
[`(+ ,e₁ ... ,e₂) (compile `(+ (+ ,@e₁) ,e₂))]
```

The encoding above works by capturing as `e₁` a list of all operands except for the last, which is captured as `e₂`. Then, it reconstructs the addition as one top-level addition that is guaranteed to be binary: the right operand is `e₂`, and the left operand is the rest of the calculation. If the addition has more than three operands, than this clause will match again on the recursive call to `compile` with the inner addition `(+ ,@e₁)`. In the end, the n-ary addition will be reduced to a series of binary additions.

We can test all the forms of addition:

```racket
(check-equal? (inspect/number (evaluate '(+))) '0)
(check-equal? (inspect/number (evaluate '(+ 0))) '0)
(check-equal? (inspect/number (evaluate '(+ 0 1))) '1)
(check-equal? (inspect/number (evaluate '(+ 0 1 2))) '3)
```

Subtraction
===========

Subtraction is similar to [addition](#addition) in many ways. First, its interpretation is similar: while `(+ m n)` meant to apply [`add1`](#successor) to `m` for `n` times, `(- m n)` means to apply [`sub1`](#predecessor) to `m` for `n` times. Second, subtraction accepts a variable number of arguments.

But subtraction is also different from addition in a few important ways. First, it is undefined for zero or one arguments—it is only defined for two or more arguments. Subtraction with zero arguments is undefined because our surface language is a subset of Racket, and subtraction with zero arguments is [undefined in Racket](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._-%29%29). Subtraction with a single argument is undefined because it would generate either zero or a negative number: zero is uninteresting and negative numbers are undefined in our core language. Second, subtraction is different from addition because it is not associative: `(- 3 2 1)` means `(- (- 3 2) 1)`(left associative), which results in `0`, not `(- 3 (- 2 1))` (right associative), which results in `2`. When defining addition, we already choose left associativity so that it would align with subtraction. We can define subtraction by adapting the clauses for addition:

```racket
[`- (compile `(λ (m n) ((n sub1) m)))]
[`(- ,e₁ ,e₂) (compile `(,(compile `-) ,(compile e₁) ,(compile e₂)))]
[`(- ,e₁ ... ,e₂) #:when (not (empty? e₁)) (compile `(- (- ,@e₁) ,e₂))]
```

There are differences between these clauses and the clauses for addition. First, we use `sub1` instead of `add1`. Second, subtraction with zero and one argument are undefined. Third, we check whether `e₁` is nonempty in the third clause using `#:when (not (empty? e₁))`. If we had not done that, this clause would also match subtraction with one argument `e₂` and an empty list for `e₁`. This was not a concern in addition because it was defined for one argument, so we could rely on the clause for addition with argument to be matched before we tried the clause for addition with more than two arguments.

We can test all the forms of subtraction:

```racket
(check-equal? (inspect/number (evaluate '(- 3 2))) '1)
(check-equal? (inspect/number (evaluate '(- 3 2 1))) '0)
```

- More interesting kinds of numbers: negatives, reals (fixed-point), complex.
