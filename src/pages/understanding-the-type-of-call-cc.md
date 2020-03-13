---
title: Understanding the Type of `call/cc`
---

<fieldset>
<legend>Pre-Requisites</legend>

**[First-class continuations](https://docs.racket-lang.org/guide/conts.html) & [`call/cc`](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28lib._racket%2Fprivate%2Fmore-scheme..rkt%29._call%2Fcc%29%29).** This article is only about the _type_ of `call/cc`, not about what it is or how it works.

**Reading code written in [Racket](https://www.racket-lang.org).** Racket is used only as the language of discourse; the results of the article are about type theory and apply to other languages.

</fieldset>

`call/cc` has the following type in classical Hindley–Milner type systems:

$$
\texttt{call/cc} : ((\alpha \rightarrow \beta) \rightarrow \alpha) \rightarrow \alpha
$$

Where $\alpha$ and $\beta$ are type variables that may be instantiated with any type such as `Number` or `String`.

<fieldset>
<legend>Note</legend>

See the type of `call/cc` in languages with Hindley–Milner-based type systems, for example, [Haskell](https://hackage.haskell.org/package/mtl-2.2.2/docs/Control-Monad-Cont.html) and [ML](https://www.smlnj.org/doc/SMLofNJ/pages/cont.html).

</fieldset>

This type is interesting, particularly in [its connection to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic), but like most ideas related to first-class continuations, it’s unintuitive. In this article we derive the type of `call/cc` step-by-step using examples written in Racket. Racket is dynamically typed, but we may use it to reason about static types as well.

<fieldset>
<legend>Note</legend>

There’s a version of Racket that is statically typed, [Typed Racket](https://docs.racket-lang.org/ts-guide/), but the type system in Typed Racket is more sophisticated than a classical Hindley–Milner type system, so the type of `call/cc` in Typed Racket is more sophisticated as well ([see appendix](#appendix-the-type-of-callcc-in-typed-racket)).

</fieldset>

We start by knowing nothing about the type of `call/cc`:

$$
\texttt{call/cc} : \boxed{?}
$$

Then we consider the following expression:

```clojure
> (zero? 0)
#t
```

We may surround the `0` in this expression with an use of `call/cc` while preserving its output:

```clojure
> (zero? (call/cc (λ (k) 0)))
#t
```

The output is preserved because `call/cc` calls `(λ (k) 0)` with the current continuation, but `(λ (k) 0)` ignores its parameter and returns `0`.

<fieldset>
<legend>Note</legend>

In general, for any expression `e`, the result of computing `e` is the same as the result of computing `(call/cc (λ (k) e))` as long as `e` doesn’t refer to `k`.

</fieldset>

This example reveals three facts about the type of `call/cc`:

1. `call/cc` is being called, so it must have a function type:

   $$
   \texttt{call/cc} : \textcolor{#09885A}{\boxed{?} \rightarrow \boxed{?}}
   $$

2. The argument being passed to `call/cc` is `(λ (k) 0)`:

   $$
   \texttt{(λ (k) 0)} : \textcolor{#09885A}{\boxed{?} \rightarrow \texttt{Number}}
   $$

   And therefore:

   $$
   \texttt{call/cc} : \textcolor{#09885A}{(\boxed{?} \rightarrow \texttt{Number})} \rightarrow \boxed{?}
   $$

3. And `call/cc` is returning `0`:

   $$
   \texttt{0} : \textcolor{#09885A}{\texttt{Number}}
   $$

   And therefore:

   $$
   \texttt{call/cc} : (\boxed{?} \rightarrow \texttt{Number}) \rightarrow \textcolor{#09885A}{\texttt{Number}}
   $$

To proceed, we want to know more about the type of `k`, so we modify the example expression such that the function passed to `call/cc` uses `k`:

```clojure
> (zero? (call/cc (λ (k) (k 29) 0)))
#f
```

The output changed from `#t` to `#f` because the `(k 29)` takes execution back to the outer `zero?`, skipping over the remainder of the function, which in this case is just the `0`.

This expression reveals two facts about the type of `call/cc`:

1. `k` is being called, so it must have a function type:

   $$
   \texttt{(λ (k) (k 29) 0)} : \textcolor{#09885A}{(\boxed{?} \rightarrow \boxed{?})} \rightarrow \texttt{Number}
   $$

   And therefore:

   $$
   \texttt{call/cc} : (\textcolor{#09885A}{(\boxed{?} \rightarrow \boxed{?})} \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   $$

2. The argument being passed to `k` is `29`:

   $$
   \texttt{(λ (k) (k 29) 0)} : (\textcolor{#09885A}{\texttt{Number}} \rightarrow \boxed{?}) \rightarrow \texttt{Number}
   $$

   And therefore:

   $$
   \texttt{call/cc} : ((\textcolor{#09885A}{\texttt{Number}} \rightarrow \boxed{?}) \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   $$

The last $\boxed{?}$ is the return type of `k`, so next we consider how the result of the call to `k` may be used, for example:

```clojure
> (zero? (call/cc (λ (k) (string-length (k 29)) 0)))
#f
```

The result of this expression is the same as before, `#f`, because `k` causes execution to skip over the rest of the function that is passed to `call/cc`, including the call to [`string-length`](https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-length%29%29).

This expression reveals one fact about the type of `call/cc`:

1. The result of calling `k` is being passed to `string-length`, so it must be a `String`:

   $$
   \texttt{(λ (k) (string-length (k 29)) 0)} :\\(\texttt{Number} \rightarrow \textcolor{#09885A}{\texttt{String}}) \rightarrow \texttt{Number}
   $$

   And therefore:

   $$
   \texttt{call/cc} : ((\texttt{Number} \rightarrow \textcolor{#09885A}{\texttt{String}}) \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   $$

Finally, we observe that there’s nothing _special_ about the use of `Number`s and `String`s in the expressions we considered so far. We may, for example, swap them:

```clojure
> (string-length (call/cc (λ (k) (zero? (k "Leandro")) "Facchinetti")))
7
```

This expression reveals the final fact about the type of `call/cc`:

1. We may swap `Number`s and `String`s:

   $$
   \texttt{call/cc} : ((\textcolor{#09885A}{\texttt{String}} \rightarrow \textcolor{#09885A}{\texttt{Number}}) \rightarrow \textcolor{#09885A}{\texttt{String}}) \rightarrow \textcolor{#09885A}{\texttt{String}}
   $$

   So in general:

   $$
   \texttt{call/cc} : ((\textcolor{#09885A}{\alpha} \rightarrow \textcolor{#09885A}{\beta}) \rightarrow \textcolor{#09885A}{\alpha}) \rightarrow \textcolor{#09885A}{\alpha}
   $$

<fieldset>
<legend>Note</legend>

The type of `k` is $\alpha \rightarrow \beta$, so `k` has the type of a function that receives an argument of any type and _produces a result of the type you need_. If the call to `k` appears as argument to `string-length`, for example `(string-length (k 29))`, then `k` produces a `String`; if the call to `k` appears as argument to `zero?`, for example `(zero? (k "Leandro"))`, then `k` produces a `Number`; and so forth. It makes sense for a type system to behave like this because execution skips over the `string-length`, `zero?`, and so forth, so no runtime type error could occur.

This shows that continuations like `k` don’t behave like regular functions.

</fieldset>

# Appendix: The Type of `call/cc` in Typed Racket

The type of `call/cc` in [Typed Racket](https://docs.racket-lang.org/ts-guide/) is more sophisticated than the type we derived in this article because the type system in Typed Racket is more sophisticated than a classical Hindley–Milner type system. The [entire type of `call/cc` in Typed Racket](https://github.com/racket/typed-racket/blob/b0f36e7d4d7fb8fe738fcea9344fc1d0ced8c58c/typed-racket-lib/typed-racket/base-env/base-env.rkt#L1356-L1361) is too complex and goes beyond the scope of this article, but the main difference is captured by the following type:

$$
\texttt{call/cc} : ((\textcolor{#09885A}{\alpha} \rightarrow \beta) \rightarrow \textcolor{#09885A}{\gamma}) \rightarrow \textcolor{#09885A}{\alpha \cup \gamma}
$$

To understand this type, recall that `call/cc` may produce an output in one of two ways:

1. If `k` is not called, then the output of `call/cc` is the output of the function that it received as argument, for example, the output of `(call/cc (λ (k) 0))` is `0`. That is the first $\gamma$ in the type above.

2. If `k` is called, then the output of `call/cc` is the argument passed to `k`, for example, the output of `(call/cc (λ (k) (k 29) 0))` is `29`. That is the first $\alpha$ in the type above.

So we conclude that `call/cc` outputs a value of type $\alpha \cup \gamma$, which means _either $\alpha$ or $\gamma$_.

<fieldset>
<legend>Technical Terms</legend>

A type such as $\alpha \cup \gamma$ is something called an [_union type_](https://docs.racket-lang.org/ts-guide/types.html#%28part._.Union_.Types%29).

</fieldset>

When deriving the type of `call/cc` in this article, we had to constrain $\alpha$ and $\gamma$ to be the same because a classical Hindley–Milner type system may not express a type such as $\alpha \cup \gamma$, but the type system in Typed Racket may.

This more general form is useful to type programs like the following:

```clojure
> (write (call/cc (λ (k) (k "Leandro") 0)))
"Leandro"
```

In this program $\alpha$ is `String` and $\gamma$ is `Number`, so `call/cc` returns a value of type $\texttt{String} \cup \texttt{Number}$. The type system in Typed Racket allows for types like these as long as they are used only in places where either a `String` or a `Number` would be acceptable, which is the case of the argument for [`write`](https://docs.racket-lang.org/reference/Writing.html?q=write#%28def._%28%28quote._~23~25kernel%29._write%29%29).

<fieldset>
<legend>Note</legend>

This kind of limitation in classical Hindley–Milner type systems occurs in many situations beyond `call/cc`. For example, in classical Hindley–Milner type systems the types of the _then_ and _else_ branches of a conditional must agree:

```clojure
(if <condition> 0 29)
```

But in Typed Racket their types may be different, for example:

```clojure
(if <condition> "Leandro" 29)
```

</fieldset>

# Acknowledgements

I thank the following people for their comments: Scott Smith, Sorawee Porncharoenwase, Dario Hamidi, and A. B. McLin.
