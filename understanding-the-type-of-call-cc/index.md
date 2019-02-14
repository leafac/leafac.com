---
layout: default
title: "Understanding the Type of `call/cc`"
date: 2018-12-06
---

<aside markdown="1">
**Pre-requisites**: First-class continuations and `call/cc` (this article does not cover what they are, how they work, or why they are useful, only their type); and reading [Racket](https://www.racket-lang.org) code.
</aside>

In classical Hindley–Milner type systems,<label class="margin-note"><input type="checkbox"><span markdown="1">For example, the core of the type systems in [ML](https://www.smlnj.org) and [Haskell](https://www.haskell.org).</span></label> the function [`call/cc`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28lib._racket%2Fprivate%2Fmore-scheme..rkt%29._call%2Fcc%29%29) (short for [`call-with-current-continuation`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28quote._~23~25kernel%29._call-with-current-continuation%29%29)) has type `call/cc : ((α → β) → α) → α`, where `α` and `β` are type variables that can be instantiated with any type. This type is interesting, particularly in [how it relates to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic), but like most topics surrounding first-class continuations, it is unintuitive. In this short article, we derive `call/cc`’s type step-by-step by using [Racket](https://www.racket-lang.org) expressions as examples.<label class="margin-note"><input type="checkbox"><span markdown="1">Racket is dynamically typed, but we can use it to reason about static types as well. In [Typed Racket](https://docs.racket-lang.org/ts-guide/) the type of `call/cc` is a bit more elaborate, [see appendix](#appendix-callccs-type-in-typedracket).</span></label>

We start with a simple expression:

```racket
> (zero? 0)
#t
```

We can surround the `0` in this expression with an use of `call/cc` without changing its output:

<pre>
> (zero? <mark>(call/cc (λ (k) </mark>0<mark>))</mark>)
#t
</pre>

The meaning of the expression is preserved because `(call/cc (λ (k) e))` is the same as `e` when `e` does not reference `k`: `call/cc` calls `(λ (k) e)` with the current continuation as `k`, but `e` ignores it. This example reveals three parts of `call/cc`’s type:

1. `call/cc` is being applied, so it is a function: `call/cc : ___ → ___`.<label class="margin-note"><input type="checkbox"><span markdown="1">The placeholders `___` represent parts of the type that we do not know yet.</span></label>
2. `call/cc` returns `0`, a number, so <code>call/cc : ___ → <mark>Number</mark></code>.
3. `call/cc` receives a function as argument, `(λ (k) 0) : ___ → Number`, so <code>call/cc : <mark>(___ → Number)</mark> → Number</code>.

To fill in the blank we need an expression that uses `k`. But we do not want to change the return type of the function passed as `call/cc`’s argument, so we use `k` before the `0`, for example:

<pre>
> (zero? (call/cc (λ (k) <mark>(k 42)</mark> 0)))
#f
</pre>

This changed the output from `#t` to `#f`, because `(k 42)` takes execution back to the outer addition, skipping over the remainder of the function passed as `call/cc`’s argument (the remainder being just the `0` in this case). This expression is equivalent to `(zero? 42)`, and it reveals two other parts of `call/cc`’s type:

1. `k` is being applied, so it is a function: <code>call/cc : (<mark>(___ → ___)</mark> → Number) → Number</code>.
2. `k` is called with a number: <code>call/cc : ((<mark>Number</mark> → ___) → Number) → Number</code>.  
   It is not a coincidence that these three types agree (in our example, they are all `Number`): if `k` is called, then `call/cc` returns the argument to `k`, and if `k` is not called, then `call/cc` returns the same as the function that was passed to it.<label class="margin-note"><input type="checkbox"><span markdown="1">[See appendix](#appendix-callccs-type-in-typedracket) for the full story.</span></label>

The final blank is `k`’s return type, and to fill it we have to explore how `k`’s output may be used. But `k` is not a regular function, it is a first-class continuation produced by `call/cc`. *A first-class continuation does not return; it has no output*. When we call `k`, execution resumes on the surrounding of the call to `call/cc` and never returns. For example, when we call `k` in the previous expression, execution resumes on the outer addition and never returns to the rest of the function that was passed as `call/cc`’s argument (the `0`).

Since `k` has no output, it can appear in any context, and its return type can be anything. For example, consider the following two expressions in which the call to `k` appears in two different contexts: one expecting a `String` ([`string-length`](https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-length%29%29)), and one expecting a `List` ([`first`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._first%29%29)):<label class="margin-note"><input type="checkbox"><span markdown="1">This is similar to how [`raise`](https://docs.racket-lang.org/reference/exns.html#%28def._%28%28quote._~23~25kernel%29._raise%29%29) can appear in any context, because execution will skip that context up to the closest *catch*, so its return type can be anything: `raise : α → β`.</span></label>

<pre>
> (zero? (call/cc (λ (k) <mark>(string-length </mark>(k 42)<mark>)</mark> 0)))
#f
> (zero? (call/cc (λ (k) <mark>(first </mark>(k 42)<mark>)</mark> 0)))
#f
</pre>

Both expressions above have valid types, so both of the following hold: <code>call/cc : ((Number → <mark>String</mark>) → Number) → Number</code>, *and* <code>call/cc : ((Number → <mark>List</mark>) → Number) → Number</code>. In general, <code>call/cc : ((Number → <mark>β</mark>) → Number) → Number</code>, where `β` is a type variable that can be instantiated with any type.<label class="margin-note"><input type="checkbox"><span markdown="1">**Alternative argument**<br/>The continuation `k` is `(zero? •)`, where `•` represents the hole that we plug with a value to continue the computation. We can reify `k` as a function `(λ (x) (zero? x)) : Number → Boolean`, and we can replace `Boolean` with `β` without loss of generality. This `k` is not a regular function, however, because execution discards the context under which it is called.</span></label>

Also, the use of numbers in our examples was incidental. We could replace them with strings, for example:

<pre>
> (<mark>string-length</mark> (call/cc (λ (k) (first (k <mark>"hi"</mark>)) <mark>"hello"</mark>)))
2
</pre>

The only constraint is that these three types must agree: the return type of `call/cc`, the return type of the function passed as argument to `call/cc`, and the type of `k`’s argument.<label class="margin-note"><input type="checkbox"><span markdown="1">[See appendix](#appendix-callccs-type-in-typedracket) for the full story.</span></label>
Finally, we can conclude that <code>call/cc : ((<mark>α</mark> → β) → <mark>α</mark>) → <mark>α</mark></code>.

Appendix: `call/cc`’s type in Typed Racket
------------------------------------------

We had to compromise on the type for `call/cc` in the classical Hindley–Milner type system (`call/cc : ((α₁ → β) → α₂) → α`): we had to constrain the type `α₁` of the argument passed to the continuation `k` to be the same as the return type `α₂` of the function passed to `call/cc`. This constraint is artificial and is not present in Racket, as shown by the following expressions in which these types disagree (`α₁ = String` and `α₂ = Number`):

<pre>
> (<mark>write</mark> (call/cc (λ (k) <mark>0</mark>)))
0
> (<mark>write</mark> (call/cc (λ (k) (k <mark>"42"</mark>) <mark>0</mark>)))
"42"
</pre>

This disagreement is not a problem at runtime as long as the surrounding context can handle values of either type—as [`write`](https://docs.racket-lang.org/reference/Writing.html#%28def._%28%28quote._~23~25kernel%29._write%29%29) can. But classical Hindley–Milner type systems have no way of representing the return type of `call/cc` used in this manner—there is no way to write that `call/cc` may return *either* a `String` *or* a `Number`—so languages with classical Hindley–Milner type systems disallow these kinds of expressions.

To type check expressions like the last example, Typed Racket’s type system has to go beyond the classical Hindley–Milner type systems, featuring something called [union types](https://docs.racket-lang.org/ts-guide/types.html#%28part._.Union_.Types%29), specifically *untagged unions*.<label class="margin-note"><input type="checkbox"><span markdown="1">As opposed to ML’s variants which are *tagged unions*, because they are tagged with constructor names.</span></label> Thus, in Typed Racket, the type of `call/cc` is closer to <code>call/cc : ((α → β) → <mark>γ</mark>) → <mark>(α ∪ γ)</mark></code>, where `α ∪ γ` represents the union of `α` and `γ`, meaning values of this type may be *either* `α` *or* `γ`. The actual type of `call/cc` in Typed Racket is a bit more elaborate, but for reasons that go beyond the scope of this article.

Union types are useful beyond esoteric language features like `call/cc`. For example, they allow type checking conditionals in which the branches produce different types, for example, `(if ___ 0 "hi")`, which are common in Racket but must also be disallowed by languages featuring classical Hindley–Milner type systems.

Acknowledgements
----------------

I thank the following people for their comments and suggestions: Scott Smith, Sorawee Porncharoenwase, Dario Hamidi and A. B. McLin.
