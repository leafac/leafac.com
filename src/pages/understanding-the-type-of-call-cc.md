---
title: Understanding the Type of `call/cc`
---

<fieldset>
<legend>Pre-Requisites</legend>

- First-class continuations & `call/cc`.
- Reading code written in [Racket](https://www.racket-lang.org).

This article is only about the _type_ of `call/cc`, not about what it is or how it works.

</fieldset>

In classical Hindley–Milner type systems (for example, the core of the type systems in [ML](https://www.smlnj.org) and [Haskell](https://www.haskell.org)), the function [`call/cc`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28lib._racket%2Fprivate%2Fmore-scheme..rkt%29._call%2Fcc%29%29) (short for [`call-with-current-continuation`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28quote._~23~25kernel%29._call-with-current-continuation%29%29)) has type `call/cc : ((α → β) → α) → α`, where `α` and `β` are type variables that can be instantiated with any type. This type is interesting, particularly in [how it relates to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic), but like most topics surrounding first-class continuations, it is unintuitive. In this short article, we derive `call/cc`’s type step-by-step by using [Racket](https://www.racket-lang.org) expressions as examples. Racket is dynamically typed, but we can use it to reason about static types as well. In [Typed Racket](https://docs.racket-lang.org/ts-guide/) the type of `call/cc` is a bit more elaborate, [see appendix](#appendix-callccs-type-in-typed-racket).

We start with a simple expression:

```racket
> (zero? 0)
#t
```

We can surround the `0` in this expression with an use of `call/cc` without changing its output:

```racket
> (zero? (call/cc (λ (k) 0)))
#t
```

The meaning of the expression is preserved because `(call/cc (λ (k) e))` is the same as `e` when `e` does not reference `k`: `call/cc` calls `(λ (k) e)` with the current continuation as `k`, but `e` ignores it. This example reveals three parts of `call/cc`’s type:

1. `call/cc` is being applied, so it is a function: `call/cc : ___ → ___`. (The placeholders `___` represent parts of the type that we do not know yet.)
2. `call/cc` returns `0`, a number, so `call/cc : ___ → Number`.
3. `call/cc` receives a function as argument, `(λ (k) 0) : ___ → Number`, so `call/cc : (___ → Number) → Number`.

To fill in the blank we need an expression that uses `k`. But we do not want to change the return type of the function passed as `call/cc`’s argument, so we use `k` before the `0`, for example:

```racket
> (zero? (call/cc (λ (k) (k 42) 0)))
#f
```

This changed the output from `#t` to `#f`, because `(k 42)` takes execution back to the outer addition, skipping over the remainder of the function passed as `call/cc`’s argument (the remainder being just the `0` in this case). This expression is equivalent to `(zero? 42)`, and it reveals two other parts of `call/cc`’s type:

1. `k` is being applied, so it is a function: `call/cc : ((___ → ___) → Number) → Number`.
2. `k` is called with a number: `call/cc : ((Number → ___) → Number) → Number`.  
   It is not a coincidence that these three types agree (in our example, they are all `Number`): if `k` is called, then `call/cc` returns the argument to `k`, and if `k` is not called, then `call/cc` returns the same as the function that was passed to it ([see the appendix](#appendix-callccs-type-in-typed-racket) for the full story).

The final blank is `k`’s return type, and to fill it we have to explore how `k`’s output may be used. But `k` is not a regular function, it is a first-class continuation produced by `call/cc`. _A first-class continuation does not return; it has no output_. When we call `k`, execution resumes on the surrounding of the call to `call/cc` and never returns. For example, when we call `k` in the previous expression, execution resumes on the outer addition and never returns to the rest of the function that was passed as `call/cc`’s argument (the `0`).

Since `k` has no output, it can appear in any context, and its return type can be anything. For example, consider the following two expressions in which the call to `k` appears in two different contexts: one expecting a `String` ([`string-length`](https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-length%29%29)), and one expecting a `List` ([`first`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._first%29%29)):

```racket
> (zero? (call/cc (λ (k) (string-length (k 42)) 0)))
#f
> (zero? (call/cc (λ (k) (first         (k 42)) 0)))
#f
```

Both expressions above have valid types, so both of the following hold: `call/cc : ((Number → String) → Number) → Number`, _and_ `call/cc : ((Number → List) → Number) → Number`. In general, `call/cc : ((Number → β) → Number) → Number`, where `β` is a type variable that can be instantiated with any type. This is similar to how [`raise`](https://docs.racket-lang.org/reference/exns.html#%28def._%28%28quote._~23~25kernel%29._raise%29%29) can appear in any context, because execution will skip that context up to the closest _catch_, so its return type can be anything: `raise : α → β`.

<fieldset>
<legend>Alternative Argument</legend>

The continuation `k` is `(zero? •)`, where `•` represents the hole that we plug with a value to continue the computation. We can reify `k` as a function `(λ (x) (zero? x)) : Number → Boolean`, and we can replace `Boolean` with `β` without loss of generality. This `k` is not a regular function, however, because execution discards the context under which it is called.

</fieldset>

The use of numbers in our examples was incidental. We could replace them with strings, for example:

```racket
> (string-length (call/cc (λ (k) (first (k "hi")) "hello")))
2
```

The only constraint is that these three types must agree: the return type of `call/cc`, the return type of the function passed as argument to `call/cc`, and the type of `k`’s argument ([see the appendix](#appendix-callccs-type-in-typed-racket) for the full story). Finally, we can conclude that `call/cc : ((α → β) → α) → α`.

# Appendix: `call/cc`’s type in Typed Racket

We had to compromise on the type for `call/cc` in the classical Hindley–Milner type system (`call/cc : ((α₁ → β) → α₂) → α`): we had to constrain the type `α₁` of the argument passed to the continuation `k` to be the same as the return type `α₂` of the function passed to `call/cc`. This constraint is artificial and is not present in Racket, as shown by the following expressions in which these types disagree (`α₁ = String` and `α₂ = Number`):

```racket
> (write (call/cc (λ (k) 0)))
0
> (write (call/cc (λ (k) (k "42") 0)))
"42"
```

This disagreement is not a problem at runtime as long as the surrounding context can handle values of either type—as [`write`](https://docs.racket-lang.org/reference/Writing.html#%28def._%28%28quote._~23~25kernel%29._write%29%29) can. But classical Hindley–Milner type systems have no way of representing the return type of `call/cc` used in this manner—there is no way to write that `call/cc` may return _either_ a `String` _or_ a `Number`—so languages with classical Hindley–Milner type systems disallow these kinds of expressions.

To type check expressions like the last example, Typed Racket’s type system has to go beyond the classical Hindley–Milner type systems, featuring something called [_union types_](https://docs.racket-lang.org/ts-guide/types.html#%28part._.Union_.Types%29). In particular, Typed Racket’s type system features _untagged unions_, as opposed to ML’s variants which are _tagged unions_, because they are tagged with constructor names. Thus, in Typed Racket, the type of `call/cc` is closer to `call/cc : ((α → β) → γ) → (α ∪ γ)`, where `α ∪ γ` represents the union of `α` and `γ`, meaning values of this type may be _either_ `α` _or_ `γ`. The actual type of `call/cc` in Typed Racket is a bit more elaborate, but for reasons that go beyond the scope of this article.

Union types are useful beyond esoteric language features like `call/cc`. For example, they allow type checking conditionals in which the branches produce different types, for example, `(if ___ 0 "hi")`, which are common in Racket but must also be disallowed by languages featuring classical Hindley–Milner type systems.

# Acknowledgements

I thank the following people for their comments and suggestions: Scott Smith, Sorawee Porncharoenwase, Dario Hamidi, and A. B. McLin.
