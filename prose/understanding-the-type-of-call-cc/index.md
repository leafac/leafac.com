---
layout: default
title: "Understanding the Type of call/cc"
draft: true
---

<aside markdown="1">
**Pre-requisites**: First-class continuations and `call/cc` (this article does not cover what they are, how they work, or why they are useful, only their type); and reading [Racket](https://www.racket-lang.org) code.
</aside>

The function [`call/cc`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28lib._racket%2Fprivate%2Fmore-scheme..rkt%29._call%2Fcc%29%29) (short for [`call-with-current-continuation`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28quote._~23~25kernel%29._call-with-current-continuation%29%29)) has type `call/cc : ((α → β) → α) → α`, where `α` and `β` are type variables that can be instantiated with any type. This type is interesting, particularly in [how it relates to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic), but like most topics surrounding first-class continuations, it is unintuitive. In this short article, we derive `call/cc`’s type step-by-step by using [Racket](https://www.racket-lang.org) expressions as examples.<label class="margin-note"><input type="checkbox"><span markdown="1">Racket is dynamically typed, but it serves as a good basis for reasoning about static types as well. In [Typed Racket](https://docs.racket-lang.org/ts-guide/) the type of `call/cc` is a bit more elaborate, but for reasons that are beyond the scope of this article.</span></label>

We start with a simple expression:

```racket
> (+ 1 5)
6
```

We can surround the `5` in this expression with an use of `call/cc` without changing its output:

<pre>
> (+ 1 <mark>(call/cc (λ (k) </mark>5<mark>))</mark>)
6
</pre>

The meaning of the expression is preserved because `(call/cc (λ (k) e))` is the same as `e` when `e` does not reference `k`: `call/cc` calls `(λ (k) e)` with the current continuation as `k`, but `e` ignores it. From this example we learned three parts of `call/cc`’s type:

1. `call/cc` is being applied, so it is a function: `call/cc : ___ → ___`.<label class="margin-note"><input type="checkbox"><span markdown="1">The placeholders `___` represent parts of the type that we do not know yet.</span></label>
2. `call/cc` returns `5`, a number, so <code>call/cc : ___ → <mark>Number</mark></code>.
3. `call/cc` receives a function as argument, `(λ (k) 5) : ___ → Number`, so <code>call/cc : <mark>(___ → Number)</mark> → Number</code>.

To fill in the blank, we need an expression that uses `k` but does not change the return type of the function passed as `call/cc`’s argument. We can do this by calling `k` before the `5`, for example:

<pre>
> (+ 1 (call/cc (λ (k) <mark>(k 2)</mark> 5)))
3
</pre>

This changed the output from `6` to `3`, because `(k 2)` takes us back to the outer addition, skipping over the remainder of the function passed as `call/cc`’s argument (the remainder being just the `5` in this case). This expression is equivalent to `(+ 1 2)`, and it shows us two other parts of `call/cc`’s type:

1. `k` is being applied, so it is a function: <code>call/cc : (<mark>(___ → ___)</mark> → Number) → Number</code>.
2. `k` is called with a number: <code>call/cc : ((<mark>Number</mark> → ___) → Number) → Number</code>.  
   It is not a coincidence that these three types agree (in our example, they are all `Number`): if `k` is called, then `call/cc` returns the argument to `k`, and if `k` is not called, then `call/cc` returns the same as the function that was passed to it.

The final blank is `k`’s return type, and to fill it we have to explore how `k`’s output may be used. But `k` is not a regular function, it is a first-class continuation given by `call/cc`. *A first-class continuation does not return; it has no output*. When we call `k`, we resume the execution surrounding the call to `call/cc` and never come back. For example, when we call `k` in the previous expression, we resume the outer addition and never come back to the rest of function that was passed as `call/cc`’s argument (the `5`).

Since `k` has no output, it can appear in any context, and its return type can be anything! To exemplify this, the following two expressions modify the previous example so that the call to `k` appears in two different contexts: one expecting a `String` ([`string-length`](https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-length%29%29)), and another expecting a `List` ([`first`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._first%29%29)):<label class="margin-note"><input type="checkbox"><span markdown="1">This is similar to how [`raise`](https://docs.racket-lang.org/reference/exns.html#%28def._%28%28quote._~23~25kernel%29._raise%29%29) can appear in any context, because execution will skip that context up to the closest *catch*, so it’s return type can be anything: `raise : α → β`.</span></label>

<pre>
> (+ 1 (call/cc (λ (k) <mark>(string-length </mark>(k 2)<mark>)</mark> 5)))
3
> (+ 1 (call/cc (λ (k) <mark>(first </mark>(k 2)<mark>)</mark> 5)))
3
</pre>

Both expressions above typecheck, so both of the following hold: <code>call/cc : ((Number → <mark>String</mark>) → Number) → Number</code> and <code>call/cc : ((Number → <mark>List</mark>) → Number) → Number</code>. With this, we can generalize <code>call/cc : ((Number → <mark>β</mark>) → Number) → Number</code>, where `β` is a type variable that can be instantiated with any type.

Also, the use of numbers in our examples was incidental. We could replace them with strings, for example:

<pre>
> (<mark>string-append</mark> <mark>"hello "</mark> (call/cc (λ (k) (first (k <mark>"world"</mark>)) <mark>"mars"</mark>)))
"hello world"
</pre>

The only constraint is that the three types must agree: the return type of `call/cc`, the return type of the function passed as argument to `call/cc`, and the type of `k`’s argument.
Finally, we can conclude that <code>call/cc : ((<mark>α</mark> → β) → <mark>α</mark>) → <mark>α</mark></code>.
