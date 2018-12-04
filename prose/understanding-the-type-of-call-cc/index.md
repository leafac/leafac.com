---
layout: default
title: "Understanding the type of call/cc"
draft: true
---

<aside markdown="1">
**Pre-requisites**: Readers are expected to know about first-order continuations and `call/cc`, because this article does not attempt to explain what they are or how they work, only their type.
</aside>

The function `call/cc` (short for [`call-with-current-continuation`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28quote._~23~25kernel%29._call-with-current-continuation%29%29)) has type `call/cc : ((α → β) → α) → α` where `α` and `β` are type variables that can be instantiated with any type. As with most things related to first-class continuations, this type is unintuitive but interesting, particularly in [its relationship to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic). In this short article, we derive `call/cc`’s type informally step by step using [Racket](https://www.racket-lang.org) expressions as examples.

We start with a simple expression:

```racket
> (+ 1 5)
6
```

We can replace the `5` with an use of `call/cc` without changing the output:

```racket
> (+ 1 (call/cc (λ (k) 5)))
6
```

The expression `(call/cc (λ (k) e))` is the same as `e` when `e` does not include references to `k`. From this example we learned three parts of `call/cc`’s type:

1. It is a function: `call/cc : ___ → ___`.<label class="margin-note"><input type="checkbox"><span markdown="1">The placeholders `___` represent parts of the type that we do not know yet.</span></label>
2. It receives another function as argument. In the example, this function was `(λ (k) 5) : ___ → Integer`, so `call/cc : (___ → Integer) → ___`.
3. It outputs the same type as the function it was passed as argument, in our example this was an integer: `call/cc : (___ → Integer) → Integer`.

To fill in the blanks, we need an example that uses `k`, for example:

```racket
> (+ 1 (call/cc (λ (k) (k 2) 5)))
3
```

This changed the output from `6` to `3`, because `(k 2)` takes us back to the outer addition skipping over the `5`—this example is equivalent to `(+ 1 2)`. We learned two parts of `call/cc`’s type:

1. `k` is a function: `call/cc : ((___ → ___) → Integer) → Integer`.
2. `k` is called with an integer: `call/cc : ((Integer → ___) → Integer) → Integer`.

The call to `k` can appear in a context that expects any type. The following example is a variant of the previous expression in which the call to `k` appears as an argument to [`first`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._first%29%29), which expects a list:

```racket
> (+ 1 (call/cc (λ (k) (first (k 2)) 5)))
3
```

The call to `first` is skipped over (along with the `5`) when `k` is called, but `first` expects a list as argument, so we need to have `call/cc : ((Integer → List) → Integer) → Integer` for the program to typecheck.

There is nothing special about `Integer` and `List` in these examples; we can use other types without losing generality. But the three occurrences of `Integer` in `call/cc : ((Integer³ → List) → Integer²) → Integer¹` must be the same type, because:

1. In case `k` is not called, `call/cc`’s output type (`¹`) is the same as the output type of the function that was passed as `call/cc`’s argument (`²`).
2. In case `k` is called, its argument must be of the same type (`³`).

So we replace `Integer` with `α` and `List` with `β`, and conclude that `call/cc : ((α → β) → α) → α`.
