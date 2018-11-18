---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

We encoded booleans in the [previous section](booleans) with functions that represented what booleans *do*, as opposed to what they *are*. What booleans *do* is to select between two different options, so our encodings were functions that selected one of two arguments. For numbers, we will follow a similar strategy and use functions that do what numbers do: to count. And we will count with the only kind of operation that our core language supports: function application. 

Values
======

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

In general, the core language encoding has the form `(λ (f) (λ (x) eᵇ))`, in which `eᵇ` is `(f (f (... x)))` where `f` appears *number* times. We can use Racket’s [`for/fold`](https://docs.racket-lang.org/reference/for.html#%28form._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._for%2Ffold%29%29) form to generate the program fragment `eᵇ`. We start with `eᵇ` being `x`, and count up to the number `n` given in the surface language, wrapping the fragment with another call to `f` in each step. The following is the complete `expand` clause:

```racket
[(? (λ (n) (and (integer? n) (not (negative? n)))) n)
 `(λ (f) (λ (x) ,(for/fold ([eᵇ `x]) ([i (in-range n)]) `(f ,eᵇ))))]
```

We can check that the above clause works as intended:

```racket
> (compile '0)
'(λ (f) (λ (x) x))
> (compile '5)
'(λ (f) (λ (x) (f (f (f (f (f x)))))))
```

* * *

To inspect numbers encoded in the core language, we have to convert them back to Racket numbers. We can do that by letting the arbitrary argument `x` be `0` and the function `f` be [`add1`](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._add1%29%29):

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
[`add1 `(λ (n) (λ (f) (λ (x) (f ((n f) x)))))]
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

Our strategy for finding the predecessor of a number by counting up to it is to keep track of the previous number we counted. The figure shows an example of our strategy in action. We keep track of the previous number by [pairing](pairs) it with the current number, and in the end we project the answer out of the pair. The following is the `expand` clause for encoding `sub1`:

```racket
[`sub1 `(λ (n) (car ((n (λ (x) (let ([p (cdr x)]) (cons p (add1 p))))) (cons 0 0))))]
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
[`+ `(λ (m n) ((n add1) m))]
```

But addition in our surface language works over any number of arguments, not just two (`m` and `n`). So we need to add clauses for the cases in which `+` is applied to zero, one, two or more arguments. We start with the case in which it is applied to one argument, and we let it return `0`, because zero is a neutral number with respect to addition (`(+ 0 e)` is equivalent to `e`):

```racket
[`(+) `0]
```

When `+` is applied to a single argument, it does not alter the argument, so we just return it:

```racket
[`(+ ,e₁) e₁]
```

When `+` is applied to two arguments, we can use the encoding of `+` we defined above:

```racket
[`(+ ,e₁ ,e₂) `(,(expand `+) ,e₁ ,e₂)]
```

In the encoding above, the inner call to `(expand +)` will produce the addition function we defined in the beginning of this section.

When `+` is applied to more than two arguments, we need to convert it into a sequence of calls to `+` with two arguments. There are multiple ways to do this, for example, `(+ 0 1 2)` is equivalent to both `(+ (+ 0 1) 2)` (left associative) and `(+ 0 (+ 1 2))` (right associative). The results of these two alternatives are the same, because addition is an associative operation. But, as we will see on the [next section](#subtraction), subtraction is similar to addition in many ways, except that it is *not* associative. So, to align addition and subtraction better, we will choose the first option (left associative):

```racket
[`(+ ,e₁ ... ,e₂) `(+ (+ ,@e₁) ,e₂)]
```

The encoding above works by capturing as `e₁` a list of all operands except for the last, which is captured as `e₂`. Then, it reconstructs the addition as one top-level addition that is guaranteed to be binary: the right operand is `e₂`, and the left operand is the rest of the calculation. If the addition has more than three operands, than this clause will match again on the recursive call to `expand` with the inner addition `(+ ,@e₁)`. In the end, the n-ary addition will be reduced to a series of binary additions.

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

But subtraction is also different from addition in a few important ways. First, it is undefined for zero or one arguments—it is only defined for two or more arguments. Subtraction with zero arguments is undefined because our surface language is a subset of Racket, and subtraction with zero arguments is [undefined in Racket](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._-%29%29). Subtraction with a single argument is undefined because it would generate either zero or a negative number: zero is uninteresting and negative numbers are undefined in our core language. Second, subtraction is different from addition because it is not associative: `(- 3 2 1)` means `(- (- 3 2) 1)`(left associative), which results in `0`, not `(- 3 (- 2 1))` (right associative), which results in `2`. When defining addition, we already choose left associativity so that it would align with subtraction.

There is also a problem when subtraction would result in a negative number. Our encoding for numbers only supports non-negative numbers, so we allow this case to be imprecise and return `0`. We expect programs to never perform subtractions that would trigger this imprecision as a compromise for simplicity.

 We can define subtraction by adapting the clauses for addition:

```racket
[`- `(λ (m n) ((n sub1) m))]
[`(- ,e₁ ,e₂) `(,(expand `-) ,e₁ ,e₂)]
[`(- ,e₁ ... ,e₂) #:when (not (empty? e₁)) `(- (- ,@e₁) ,e₂)]
```

There are three differences between these clauses and the clauses for addition. First, we use `sub1` instead of `add1`. Second, subtraction with zero and one argument are undefined. Third, we check whether `e₁` is nonempty in the third clause using `#:when (not (empty? e₁))`. If we had not done that, this clause would also match subtraction with one argument `e₂` and an empty list for `e₁`. This was not a concern in addition because it was defined for one argument, so we could rely on the clause for addition with argument to be matched before we tried the clause for addition with more than two arguments.

We can test all the forms of subtraction:

```racket
(check-equal? (inspect/number (evaluate '(- 3 2))) '1)
(check-equal? (inspect/number (evaluate '(- 3 2 1))) '0)
```

Multiplication
==============

Our strategy for multiplication is based on iterated addition. To calculate `(* m n)`, we start an accumulator `a` with the *zero* of addition (which is actually `0`) and add `m` to it for `n` times. This is similar to what we did for [addition](#addition) and [subtraction](#subtraction). The following is the `expand` clause for the multiplication operator:

```racket
[`* `(λ (m n) ((n (λ (a) (+ a m))) (+)))]
```

We use `n` to apply the function `(λ (a) (+ a m))` for `n` times, starting with `0` (which we write `(+)` to bring out the parallel with [exponentiation](#exponentiation)). The function receives as argument the accumulator `a` and adds `m` to it.

Similar to addition, multiplication also accepts a variable number of arguments. The only difference is the *zero* of the operation, which is `1` instead of `0`, because `(* 1 e)` is equivalent to `e`:

```racket
[`(*) `1]
[`(* ,e₁) e₁]
[`(* ,e₁ ,e₂) `(,(expand `*) ,e₁ ,e₂)]
[`(* ,e₁ ... ,e₂) `(* (* ,@e₁) ,e₂)]
```

We can test all forms of multiplication:

```racket
(check-equal? (inspect/number (evaluate '(*))) '1)
(check-equal? (inspect/number (evaluate '(* 3))) '3)
(check-equal? (inspect/number (evaluate '(* 3 2))) '6)
(check-equal? (inspect/number (evaluate '(* 3 2 1))) '6)
```

Division
========

We only implement integer division, `quotient`, not the more general division operator `/`. The difference between them is that `(quotient 5 2)`, for example, is `2`, while `(/ 5 2)` is `2 ¹/₂`. The integer division `quotient` makes more sense in our language, since it only supports non-negative integers.

We also have to handle the case of division by zero `(quotient e 0)`, which is an undefined operation. In Racket, this causes an error, but our core language has no error handling mechanism. We could do something similar to what we did in the case of [subtraction](#subtraction): there we accepted an imprecise result when the subtraction would have yielded a negative number, so here we could return any value as the result of division by zero. But we are going to do something much more interesting instead and let the computation enter an infinite loop. This never returns any value, which is an appropriate answer to division by zero.

Our strategy for implementing `(quotient m n)` is the inverse of our strategy for [multiplication](#multiplication). For multiplication, we added `m` iteratively for `n` times, and for division we count how many times we can subtract `n` from `m`: `(- m n)`. Our base case occurs when `m` is less than `n`, because `(- m n)` would result in a negative number, which we do not support, so the result is `0`. If that is not the case, then we call `quotient` recursively with `(- m n)` and `n`, and `add1` to the result. We define `quotient` using [`letrec`](bindings#recursive-bindings), since it is a recursive function:

```racket
[`quotient `(letrec ([quot (λ (m n) (if (< m n) 0 (add1 (quot (- m n) n))))]) quot)]
```

We use `letrec` to define the auxiliary function `quot`, which we then return from the `letrec` form to be the definition of `quotient`. We have to use a name different from `quotient` for the auxiliary function or our `expand` function would try to expand it again.

We can test integer division:

```racket
(check-equal? (inspect/number (evaluate '(quotient 5 2))) '2)
(check-equal? (inspect/number (evaluate '(quotient 5 5))) '1)
```

Exponentiation
==============

The strategy for exponentiation (`expt`) is the same as the strategy for [multiplication](#multiplication), except that we perform iterated *multiplication* instead of iterated *addition*:

```racket
[`expt `(λ (m n) ((n (λ (a) (* a m))) (*)))]
```

We start the accumulator `a` with the *zero* of multiplication (`1`, written as `(*)`), and then we multiply `m` to it for `n` times.

We can test `expt`:

```racket
(check-equal? (inspect/number (evaluate '(expt 5 2))) '25)
```

Zero Predicate
==============

The [`zero?`](https://docs.racket-lang.org/reference/number-types.html#%28def._%28%28quote._~23~25kernel%29._zero~3f%29%29) predicate returns a [boolean](boolean) indicating whether or not the argument is `0`. In our encoding, numbers are functions that receive two arguments, a function `f` and an initial argument `x`, and apply `f` to `x` for *number* times. We can detect if a number is zero by letting the initial argument `x` be `#t` and `f` be a function that always returns `#f`. If the number is `0`, then `f` is never called and we return the initial argument `#t`, but any number other than `0` will apply `f` and return `#f`:

```racket
[`zero? `(λ (n) ((n (λ (x) #f)) #t))]
```

In the encoding above, `x` is the second argument to the number `n`: `#t`. And `f` is the function `(λ (x) #f)`, which ignores its argument and returns `#f`.

We can test the `zero?` predicate:

```racket
(check-equal? (inspect/boolean (evaluate '(zero? 0))) '#t)
(check-equal? (inspect/boolean (evaluate '(zero? 5))) '#f)
```

Number Comparison
=================

In this section we implement the remaining numeric operators: [`<=`](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._~3c~3d%29%29), [`>=`](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._~3e~3d%29%29), [`=`](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._~3d%29%29), [`<`](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._~3c%29%29), and [`>`](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._~3e%29%29). We implement them together because they are similar.

We start with `<=`. We can exploit the [imprecision in subtraction](#subtraction) to implement `<=`. Our encoding of numbers as functions only supports non-negative numbers, so `(- m n)` returns `0` for `(<= m n)`. We use the [`zero?`](#zero-predicate) predicate to check whether this happened:

```racket
[`<= `(λ (m n) (zero? (- m n)))]
```

The `>=` comparison is similar, we just need to invert `m` and `n`:

```racket
[`>= `(λ (m n) (zero? (- n m)))]
```

For `=`, we can check whether `(<= m n)` *and* `(>= m n)`. If two numbers are greater than or equal *and* less than or equal to each other, then it must be because they are *equal* to each other:

```racket
[`= `(λ (m n) (and (<= m n) (>= m n)))]
```

For `<`, we check whether `(<= m n)` but not `(= m n)`. Similarly for `>`:

```racket
[`< `(λ (m n) (and (<= m n) (not (= m n))))]
[`> `(λ (m n) (and (>= m n) (not (= m n))))]
```

* * *

The definitions above cover the case of comparing two numbers, but these operators work one or more arguments (but not zero arguments, as was the case with [addition](#addition) and [multiplication](#multiplication)). We start with the case of one argument, in which the operators return `#t`. A first attempt would be:

```racket
[`(<= ,e₁) `#t] ;; INCORRECT
[`(>= ,e₁) `#t] ;; INCORRECT
[`(=  ,e₁) `#t] ;; INCORRECT
[`(<  ,e₁) `#t] ;; INCORRECT
[`(>  ,e₁) `#t] ;; INCORRECT
```

The encoding above returns the correct answer `#t`, but it does not evaluate `e₁`. If `e₁` is an expression that does not terminate, then `(<= e₁)` should not terminate, and in our encoding above it would. Beyond non-termination, in the future we could extend our surface language to include other forms of side-effects, for example, printing to the console ([`display`](https://docs.racket-lang.org/reference/Writing.html#%28def._%28%28quote._~23~25kernel%29._display%29%29)) and mutable state ([`set!`](https://docs.racket-lang.org/reference/set_.html#%28form._%28%28quote._~23~25kernel%29._set%21%29%29)), and we would like to perform any side-effects in `e₁`. To address this, we use the [`begin`](bindings#sequencing) form to evaluate `e₁`, discard its result, and return `#t`:

```racket
[`(<= ,e₁) `(begin ,e₁ #t)]
[`(>= ,e₁) `(begin ,e₁ #t)]
[`(=  ,e₁) `(begin ,e₁ #t)]
[`(<  ,e₁) `(begin ,e₁ #t)]
[`(>  ,e₁) `(begin ,e₁ #t)]
```

For the case in which there are two arguments, we can use the same strategy we used in all other binary operators to this point: we call `expand` recursively and let it expand the operator:

```racket
[`(<= ,e₁ ,e₂) `(,(expand `<=) ,e₁ ,e₂)]
[`(>= ,e₁ ,e₂) `(,(expand `>=) ,e₁ ,e₂)]
[`(=  ,e₁ ,e₂) `(,(expand  `=) ,e₁ ,e₂)]
[`(<  ,e₁ ,e₂) `(,(expand  `<) ,e₁ ,e₂)]
[`(>  ,e₁ ,e₂) `(,(expand  `>) ,e₁ ,e₂)]
```

For the case in which there are three or more arguments, we have to devise a new strategy. When solving this issue for other operations, we nested operands, for example, when we considered addition of three or more arguments, we nested multiple additions in a way that all the operations were binary: `(+ 0 1 2)` became `(+ (+ 0 1) 2)`. But this does not work for number comparison operators, because they return booleans, not numbers: `(<= 3 2 1)` means `(and (<= 3 2) (<= 2 1))`, not `(<= (<= 3 2) 1)`—this would try to compare `(<= #f 1)` which is not even defined.

There is also the problem of evaluating the underlying expressions exactly once. If we encode `(<= e₁ e₂ e₃)` as `(and (<= e₁ e₂) (<= e₂ e₃))` then we risk evaluating `e₂` and `e₃` an incorrect number of times. If `(<= e₁ e₂)` holds, than the [`and` short-circuits](booleans) and we do not try to evaluate `(<= e₂ e₃)`, which means we never evaluate `e₃`. On the other hand, if `(<= e₁ e₂)` does not hold, then we evaluate `(<= e₂ e₃)`, which causes `e₂` to be evaluated twice.

To solve all these issues, we translate the comparison operators with three or more arguments by first evaluating all the operands `e₁ ... eₙ`, binding the results to variables `x₁ ... xₙ`, and then constructing an expression of the form `(and (<= x₁ x₂) ... (<= xₙ₋₁ xₙ))`:

```racket
[`(<= ,e₁ ...)
 #:when (not (empty? e₁))
 (let ([x₁ (map (λ (x) (gensym)) e₁)])
   `(let* (,@[map list x₁ e₁])
      (and ,@(map (λ (x₂ x₃) `(<= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
[`(>= ,e₁ ...)
 #:when (not (empty? e₁))
 (let ([x₁ (map (λ (x) (gensym)) e₁)])
   `(let* (,@[map list x₁ e₁])
      (and ,@(map (λ (x₂ x₃) `(>= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
[`(= ,e₁ ...)
 #:when (not (empty? e₁))
 (let ([x₁ (map (λ (x) (gensym)) e₁)])
   `(let* (,@[map list x₁ e₁])
      (and ,@(map (λ (x₂ x₃) `(= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
[`(< ,e₁ ...)
 #:when (not (empty? e₁))
 (let ([x₁ (map (λ (x) (gensym)) e₁)])
   `(let* (,@[map list x₁ e₁])
      (and ,@(map (λ (x₂ x₃) `(< ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
[`(> ,e₁ ...)
 #:when (not (empty? e₁))
 (let ([x₁ (map (λ (x) (gensym)) e₁)])
   `(let* (,@[map list x₁ e₁])
      (and ,@(map (λ (x₂ x₃) `(> ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
```

First, we check that the sequence of operands `e₁` is not empty with the guard `#:when (not (empty? e₁))`. This prevents the clauses from matching the case in which no operands were provided, which is undefined. Then, we use [`gensym`](https://docs.racket-lang.org/reference/symbols.html#%28def._%28%28quote._~23~25kernel%29._gensym%29%29) to generate a series of `x₁` fresh identifiers. Finally, we build an expression an expression with the following form:

```racket
(let* ([x₁ e₁] ... [xₙ eₙ])
  (and (<= x₁ x₂) ... (<= xₙ₋₁ xₙ)))
```

The `let*` form binds the results of operands to the fresh identifiers we generated, and the `and` form performs the comparison.

We can test all number comparison operators:

```racket
(check-equal? (inspect/boolean (evaluate '(<= 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(<= 3 2))) '#f)
(check-equal? (inspect/boolean (evaluate '(<= 2 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(<= 3 2 1))) '#f)
(check-equal? (inspect/boolean (evaluate '(>= 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(>= 3 2))) '#t)
(check-equal? (inspect/boolean (evaluate '(>= 2 3))) '#f)
(check-equal? (inspect/boolean (evaluate '(>= 3 2 1))) '#t)
(check-equal? (inspect/boolean (evaluate '(= 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(= 3 2))) '#f)
(check-equal? (inspect/boolean (evaluate '(= 3 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(= 3 2 1))) '#f)
(check-equal? (inspect/boolean (evaluate '(< 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(< 3 2))) '#f)
(check-equal? (inspect/boolean (evaluate '(< 2 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(< 3 2 1))) '#f)
(check-equal? (inspect/boolean (evaluate '(> 3))) '#t)
(check-equal? (inspect/boolean (evaluate '(> 3 2))) '#t)
(check-equal? (inspect/boolean (evaluate '(> 2 3))) '#f)
(check-equal? (inspect/boolean (evaluate '(> 3 2 1))) '#t)
```

Other Number Types
==================

We can build on the results of this section to extend the surface language to support other kinds of numbers:

- **Signed Integers**. [Pair](pairs) a non-negative number with a [boolean](booleans) for the sign, for example, `#f` means negative and `#t` means positive.
- **Rationals**. Pair two signed integers, one is the numerator and the other the denominator. As a special case, if the denominator is a power of `10`, then this also works as a representation of decimal numbers with a fixed point.
- **Complex Numbers**. Pair two rationals, one is the real part and the other the imaginary part.

All these encodings rely on pairs, which are the subject of the [next section](pairs).
