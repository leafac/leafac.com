---
title: Understanding the Type of `call/cc`
---

<fieldset>
<legend>Pre-Requisites</legend>

- First-class continuations & `call/cc`.
- Reading code written in [Racket](https://www.racket-lang.org).

This article is only about the _type_ of `call/cc`, not about what it is or how it works.

</fieldset>

The function [`call-with-current-continuation`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28quote._~23~25kernel%29._call-with-current-continuation%29%29), more commonly known by the contraction [`call/cc`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28lib._racket%2Fprivate%2Fmore-scheme..rkt%29._call%2Fcc%29%29), has the following type in classical Hindley–Milner type systems (for example, the core of the type systems in languages such as [ML](https://www.smlnj.org) and [Haskell](https://www.haskell.org)):

$$
\texttt{call/cc} : ((\alpha \rightarrow \beta) \rightarrow \alpha) \rightarrow \alpha
$$

Where $\alpha$ and $\beta$ are type variables that may be instantiated with any type such as `Number` or `String`.

This type is interesting, particularly in [its connection to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic), but like most ideas related to first-class continuations, it is unintuitive. In this article we derive `call/cc`’s type step-by-step using examples written in [Racket](https://www.racket-lang.org). Racket is dynamically typed, but we may use it to reason about static types. In fact, there’s a version of Racket that is statically typed, [Typed Racket](https://docs.racket-lang.org/ts-guide/), but the type system in Typed Racket is more sophisticated than a classical Hindley–Milner type system, so the type of `call/cc` in Typed Racket is a more sophisticated as well ([see appendix](#appendix-callccs-type-in-typed-racket)).

We start by knowing nothing about `call/cc`’s type:

$$
\texttt{call/cc} : \boxed{?}
$$

Then we consider the following expression:

```racket
> (zero? 0)
#t
```

We may surround the `0` in this expression with an use of `call/cc` while preserving its output:

```racket
> (zero? (call/cc (λ (k) 0)))
#t
```

The output is preserved because `call/cc` calls `(λ (k) 0)` with the current continuation, but `(λ (k) 0)` ignores its argument and returns `0`.

<fieldset>
<legend>Note</legend>

In general, for any expression `e`, the result of computing `e` is the same as the result of computing `(call/cc (λ (k) e))` as long as `e` doesn’t refer to `k`.

</fieldset>

This example reveals three facts about `call/cc`’s type:

1. `call/cc` is being called, so it must be function:

   $$
   \texttt{call/cc} : \textcolor{#09885A}{\boxed{?} \rightarrow \boxed{?}}
   $$

2. `call/cc`’s parameter, `(λ (k) 0)`, is also a function:

   $$
   \texttt{(λ (k) 0)} : \boxed{?} \rightarrow \texttt{Number}
   $$

   And therefore:

   $$
   \texttt{call/cc} : \textcolor{#09885A}{(\boxed{?} \rightarrow \texttt{Number})} \rightarrow \boxed{?}
   $$

3. Finally, `call/cc` is returning `0`, a `Number`:

   $$
   \texttt{call/cc} : (\boxed{?} \rightarrow \texttt{Number}) \rightarrow \textcolor{#09885A}{\texttt{Number}}
   $$

To proceed, we want to know more about the type of `k`, so we modify the function passed to `call/cc`, `(λ (k) 0)`, such that it uses `k`. But we want to preserve `Number` as the return type, so we add the call to `k` before the `0`:

```racket
> (zero? (call/cc (λ (k) (k 42) 0)))
#f
```

This modification changed the output from `#t` to `#f`, because the `(k 42)` takes execution back to the outer `zero?` and skips over the remainder of the function passed to `call/cc`, which in this case is just the `0`.

This expression reveals two more facts about `call/cc`’s type:

1. `k` is being applied, so it must be a function:

   $$
   \texttt{(λ (k) (k 42) 0)} : \textcolor{#09885A}{(\boxed{?} \rightarrow \boxed{?})} \rightarrow \texttt{Number}
   $$

   And therefore:

   $$
   \texttt{call/cc} : (\textcolor{#09885A}{(\boxed{?} \rightarrow \boxed{?})} \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   $$

2. `k`’s argument is a `42`, a `Number`:

   $$
   \texttt{(λ (k) (k 42) 0)} : (\textcolor{#09885A}{\texttt{Number}} \rightarrow \boxed{?}) \rightarrow \texttt{Number}
   $$

   And therefore:

   $$
   \texttt{call/cc} : ((\textcolor{#09885A}{\texttt{Number}} \rightarrow \boxed{?}) \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   $$

---

The final $\boxed{?}$ is `k`’s return type, and to fill it we have to explore how `k`’s output may be used. But `k` is not a regular function, it is a first-class continuation produced by `call/cc`. _A first-class continuation does not return; it has no output_. When we call `k`, execution resumes on the surrounding of the call to `call/cc` and never returns. For example, when we call `k` in the previous expression, execution resumes on the outer addition and never returns to the rest of the function that was passed as `call/cc`’s argument (the `0`).

Since `k` has no output, it may appear in any context, and its return type may be anything. For example, consider the following two expressions in which the call to `k` appears in two different contexts: one expecting a `String` ([`string-length`](https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-length%29%29)), and one expecting a `List` ([`first`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._first%29%29)):

```racket
> (zero? (call/cc (λ (k) (string-length (k 42)) 0)))
#f
> (zero? (call/cc (λ (k) (first         (k 42)) 0)))
#f
```

Both expressions above have valid types, so both of the following hold: `call/cc : ((Number \rightarrow String) \rightarrow Number) \rightarrow Number`, _and_ `call/cc : ((Number \rightarrow List) \rightarrow Number) \rightarrow Number`. In general, `call/cc : ((Number \rightarrow \beta) \rightarrow Number) \rightarrow Number`, where `\beta` is a type variable that may be instantiated with any type. This is similar to how [`raise`](https://docs.racket-lang.org/reference/exns.html#%28def._%28%28quote._~23~25kernel%29._raise%29%29) may appear in any context, because execution will skip that context up to the closest _catch_, so its return type may be anything: `raise : \alpha \rightarrow \beta`.

<fieldset>
<legend>Alternative Argument</legend>

The continuation `k` is `(zero? •)`, where `•` represents the hole that we plug with a value to continue the computation. We may reify `k` as a function `(λ (x) (zero? x)) : Number \rightarrow Boolean`, and we may replace `Boolean` with `\beta` without loss of generality. This `k` is not a regular function, however, because execution discards the context under which it is called.

</fieldset>

The use of numbers in our examples was incidental. We could replace them with strings, for example:

```racket
> (string-length (call/cc (λ (k) (first (k "hi")) "hello")))
2
```

The only constraint is that these three types must agree: the return type of `call/cc`, the return type of the function passed as argument to `call/cc`, and the type of `k`’s argument ([see the appendix](#appendix-callccs-type-in-typed-racket) for the full story). Finally, we may conclude that `call/cc : ((\alpha \rightarrow \beta) \rightarrow \alpha) \rightarrow \alpha`.

# Appendix: `call/cc`’s type in Typed Racket

We had to compromise on the type for `call/cc` in the classical Hindley–Milner type system (`call/cc : ((\alpha₁ \rightarrow \beta) \rightarrow \alpha₂) \rightarrow \alpha`): we had to constrain the type `\alpha₁` of the argument passed to the continuation `k` to be the same as the return type `\alpha₂` of the function passed to `call/cc`. This constraint is artificial and is not present in Racket, as shown by the following expressions in which these types disagree (`\alpha₁ = String` and `\alpha₂ = Number`):

```racket
> (write (call/cc (λ (k) 0)))
0
> (write (call/cc (λ (k) (k "42") 0)))
"42"
```

This disagreement is not a problem at runtime as long as the surrounding context may handle values of either type—as [`write`](https://docs.racket-lang.org/reference/Writing.html#%28def._%28%28quote._~23~25kernel%29._write%29%29) may. But classical Hindley–Milner type systems have no way of representing the return type of `call/cc` used in this manner—there is no way to write that `call/cc` may return _either_ a `String` _or_ a `Number`—so languages with classical Hindley–Milner type systems disallow these kinds of expressions.

To type check expressions like the last example, Typed Racket’s type system has to go beyond the classical Hindley–Milner type systems, featuring something called [_union types_](https://docs.racket-lang.org/ts-guide/types.html#%28part._.Union_.Types%29). In particular, Typed Racket’s type system features _untagged unions_, as opposed to ML’s variants which are _tagged unions_, because they are tagged with constructor names. Thus, in Typed Racket, the type of `call/cc` is closer to `call/cc : ((\alpha \rightarrow \beta) \rightarrow γ) \rightarrow (\alpha ∪ γ)`, where `\alpha ∪ γ` represents the union of `\alpha` and `γ`, meaning values of this type may be _either_ `\alpha` _or_ `γ`. The actual type of `call/cc` in Typed Racket is a bit more elaborate, but for reasons that go beyond the scope of this article.

Union types are useful beyond esoteric language features like `call/cc`. For example, they allow type checking conditionals in which the branches produce different types, for example, `(if ___ 0 "hi")`, which are common in Racket but must also be disallowed by languages featuring classical Hindley–Milner type systems.

# Acknowledgements

I thank the following people for their comments: Scott Smith, Sorawee Porncharoenwase, Dario Hamidi, and A. B. McLin.
