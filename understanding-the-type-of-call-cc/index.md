# Understanding the Type of `` clojure`call/cc ``

<div style="display: none;">

```math
\require{color}
```

</div>

<fieldset>
<legend><strong>Pre-Requisites</strong></legend>

**[First-class continuations](https://docs.racket-lang.org/guide/conts.html) & [`` clojure`call/cc ``](https://docs.racket-lang.org/reference/cont.html#%28def._%28%28lib._racket%2Fprivate%2Fmore-scheme..rkt%29._call%2Fcc%29%29).** This article is only about the _type_ of `` clojure`call/cc ``, not about what it is or how it works.

**Reading code written in [Racket](https://www.racket-lang.org).** Racket is used only as the language of discourse; the results of the article are about type theory and apply to other languages.

</fieldset>

`` clojure`call/cc `` has the following type in classical Hindley–Milner type systems:

```math
\texttt{call/cc} : ((\alpha \rightarrow \beta) \rightarrow \alpha) \rightarrow \alpha
```

Where `` math`\alpha `` and `` math`\beta `` are type variables that may be instantiated with any type such as `` clojure`Number `` or `` clojure`String ``.

<fieldset>
<legend><strong>Note</strong></legend>

See the type of `` clojure`call/cc `` in languages with Hindley–Milner-based type systems, for example, [Haskell](https://hackage.haskell.org/package/mtl-2.2.2/docs/Control-Monad-Cont.html) and [ML](https://www.smlnj.org/doc/SMLofNJ/pages/cont.html).

</fieldset>

This type is interesting, particularly in [its connection to logic](https://en.wikipedia.org/wiki/Call-with-current-continuation#Relation_to_non-constructive_logic), but like most ideas related to first-class continuations, it’s unintuitive. In this article we derive the type of `` clojure`call/cc `` step by step using examples written in Racket. Racket is dynamically typed, but we may use it to reason about static types as well.

<fieldset>
<legend><strong>Note</strong></legend>

There’s a version of Racket that is statically typed, [Typed Racket](https://docs.racket-lang.org/ts-guide/), but the type system in Typed Racket is more sophisticated than a classical Hindley–Milner type system, so the type of `` clojure`call/cc `` in Typed Racket is more sophisticated as well ([see appendix](#appendix-the-type-of-clojurecallcc-in-typed-racket)).

</fieldset>

We start by knowing nothing about the type of `` clojure`call/cc ``:

```math
\texttt{call/cc} : \boxed{?}
```

Then we consider the following expression:

```clojure
> (zero? 0)
#t
```

We may surround the `` clojure`0 `` in this expression with an use of `` clojure`call/cc `` while preserving its output:

```clojure
> (zero? (call/cc (λ (k) 0)))
#t
```

The output is preserved because `` clojure`call/cc `` calls `` clojure`(λ (k) 0) `` with the current continuation, but `` clojure`(λ (k) 0) `` ignores its parameter and returns `` clojure`0 ``.

<fieldset>
<legend><strong>Note</strong></legend>

In general, for any expression `` clojure`e ``, the result of computing `` clojure`e `` is the same as the result of computing `` clojure`(call/cc (λ (k) e)) `` as long as `` clojure`e `` doesn’t refer to `` clojure`k ``.

</fieldset>

This example reveals three facts about the type of `` clojure`call/cc ``:

1. `` clojure`call/cc `` is being called, so it must have a function type:

   ```math
   \texttt{call/cc} : \textcolor{#09885A}{\boxed{?} \rightarrow \boxed{?}}
   ```

2. The argument being passed to `` clojure`call/cc `` is `` clojure`(λ (k) 0) ``:

   ```math
   \texttt{(λ (k) 0)} : \textcolor{#09885A}{\boxed{?} \rightarrow \texttt{Number}}
   ```

   And therefore:

   ```math
   \texttt{call/cc} : \textcolor{#09885A}{(\boxed{?} \rightarrow \texttt{Number})} \rightarrow \boxed{?}
   ```

3. And `` clojure`call/cc `` is returning `` clojure`0 ``:

   ```math
   \texttt{0} : \textcolor{#09885A}{\texttt{Number}}
   ```

   And therefore:

   ```math
   \texttt{call/cc} : (\boxed{?} \rightarrow \texttt{Number}) \rightarrow \textcolor{#09885A}{\texttt{Number}}
   ```

To proceed, we want to know more about the type of `` clojure`k ``, so we modify the example expression such that the function passed to `` clojure`call/cc `` uses `` clojure`k ``:

```clojure
> (zero? (call/cc (λ (k) (k 29) 0)))
#f
```

The output changed from `` clojure`#t `` to `` clojure`#f `` because the `` clojure`(k 29) `` takes execution back to the outer `` clojure`zero? ``, skipping over the remainder of the function, which in this case is just the `` clojure`0 ``.

This expression reveals two facts about the type of `` clojure`call/cc ``:

1. `` clojure`k `` is being called, so it must have a function type:

   ```math
   \texttt{(λ (k) (k 29) 0)} : \textcolor{#09885A}{(\boxed{?} \rightarrow \boxed{?})} \rightarrow \texttt{Number}
   ```

   And therefore:

   ```math
   \texttt{call/cc} : (\textcolor{#09885A}{(\boxed{?} \rightarrow \boxed{?})} \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   ```

2. The argument being passed to `` clojure`k `` is `` clojure`29 ``:

   ```math
   \texttt{(λ (k) (k 29) 0)} : (\textcolor{#09885A}{\texttt{Number}} \rightarrow \boxed{?}) \rightarrow \texttt{Number}
   ```

   And therefore:

   ```math
   \texttt{call/cc} : ((\textcolor{#09885A}{\texttt{Number}} \rightarrow \boxed{?}) \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   ```

The last `` math`\boxed{?} `` is the return type of `` clojure`k ``, so next we consider how the result of the call to `` clojure`k `` may be used, for example:

```clojure
> (zero? (call/cc (λ (k) (string-length (k 29)) 0)))
#f
```

The result of this expression is the same as before (`` clojure`#f ``) because `` clojure`k `` causes execution to skip over the rest of the function that is passed to `` clojure`call/cc ``, including the call to [`` clojure`string-length ``](https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-length%29%29).

This expression reveals one fact about the type of `` clojure`call/cc ``:

1. The result of calling `` clojure`k `` is being passed to `` clojure`string-length ``, so it must be a `` clojure`String ``:

   ```math
   \texttt{(λ (k) (string}-\texttt{length (k 29)) 0)} : (\texttt{Number} \rightarrow \textcolor{#09885A}{\texttt{String}}) \rightarrow \texttt{Number}
   ```

   And therefore:

   ```math
   \texttt{call/cc} : ((\texttt{Number} \rightarrow \textcolor{#09885A}{\texttt{String}}) \rightarrow \texttt{Number}) \rightarrow \texttt{Number}
   ```

Finally, we observe that there’s nothing _special_ about the use of `` clojure`Number ``s and `` clojure`String ``s in the expressions we considered so far. We may, for example, swap them:

```clojure
> (string-length (call/cc (λ (k) (zero? (k "Leandro")) "Facchinetti")))
7
```

This expression reveals the final fact about the type of `` clojure`call/cc ``:

1. We may swap `` clojure`Number ``s and `` clojure`String ``s:

   ```math
   \texttt{call/cc} : ((\textcolor{#09885A}{\texttt{String}} \rightarrow \textcolor{#09885A}{\texttt{Number}}) \rightarrow \textcolor{#09885A}{\texttt{String}}) \rightarrow \textcolor{#09885A}{\texttt{String}}
   ```

   So in general:

   ```math
   \texttt{call/cc} : ((\textcolor{#09885A}{\alpha} \rightarrow \textcolor{#09885A}{\beta}) \rightarrow \textcolor{#09885A}{\alpha}) \rightarrow \textcolor{#09885A}{\alpha}
   ```

<fieldset>
<legend><strong>Note</strong></legend>

The type of `` clojure`k `` is `` math`\alpha \rightarrow \beta ``, so `` clojure`k `` has the type of a function that receives an argument of any type and _produces a result of the type you need_. If the call to `` clojure`k `` appears as argument to `` clojure`string-length ``, for example `` clojure`(string-length (k 29)) ``, then `` clojure`k `` produces a `` clojure`String ``; if the call to `` clojure`k `` appears as argument to `` clojure`zero? ``, for example `` clojure`(zero? (k "Leandro")) ``, then `` clojure`k `` produces a `` clojure`Number ``; and so forth. It makes sense for a type system to behave like this because execution skips over the `` clojure`string-length ``, `` clojure`zero? ``, and so forth, so no runtime type error could occur.

This shows that continuations like `` clojure`k `` don’t behave like regular functions.

</fieldset>

# Appendix: The Type of `` clojure`call/cc `` in Typed Racket

The type of `` clojure`call/cc `` in [Typed Racket](https://docs.racket-lang.org/ts-guide/) is more sophisticated than the type we derived in this article because the type system in Typed Racket is more sophisticated than a classical Hindley–Milner type system. The [entire type of `` clojure`call/cc `` in Typed Racket](https://github.com/racket/typed-racket/blob/b0f36e7d4d7fb8fe738fcea9344fc1d0ced8c58c/typed-racket-lib/typed-racket/base-env/base-env.rkt#L1356-L1361) is too complex and goes beyond the scope of this article, but the main difference is captured by the following type:

```math
\texttt{call/cc} : ((\textcolor{#09885A}{\alpha} \rightarrow \beta) \rightarrow \textcolor{#09885A}{\gamma}) \rightarrow \textcolor{#09885A}{\alpha \cup \gamma}
```

To understand this type, recall that `` clojure`call/cc `` may produce an output in one of two ways:

1. If `` clojure`k `` is not called, then the output of `` clojure`call/cc `` is the output of the function that it received as argument, for example, the output of `` clojure`(call/cc (λ (k) 0)) `` is `` clojure`0 ``. That is the first `` math`\gamma `` in the type above.

2. If `` clojure`k `` is called, then the output of `` clojure`call/cc `` is the argument passed to `` clojure`k ``, for example, the output of `` clojure`(call/cc (λ (k) (k 29) 0)) `` is `` clojure`29 ``. That is the first `` math`\alpha `` in the type above.

So we conclude that `` clojure`call/cc `` outputs a value of type `` math`\alpha \cup \gamma ``, which means _either `` math`\alpha `` or `` math`\gamma ``_.

<fieldset>
<legend><strong>Technical Terms</strong></legend>

**[Union Type](https://docs.racket-lang.org/ts-guide/types.html#%28part._.Union_.Types%29):** A type such as `` math`\alpha \cup \gamma ``.

</fieldset>

When deriving the type of `` clojure`call/cc `` in this article, we had to constrain `` math`\alpha `` and `` math`\gamma `` to be the same because a classical Hindley–Milner type system may not express a type such as `` math`\alpha \cup \gamma ``, but the type system in Typed Racket may.

This more general form is useful to type programs like the following:

```clojure
> (write (call/cc (λ (k) (k "Leandro") 0)))
"Leandro"
```

In this program `` math`\alpha `` is `` clojure`String `` and `` math`\gamma `` is `` clojure`Number ``, so `` clojure`call/cc `` returns a value of type `` math`\texttt{String} \cup \texttt{Number} ``. The type system in Typed Racket allows for types like these as long as they are used only in places where either a `` clojure`String `` or a `` clojure`Number `` would be acceptable, which is the case of the argument for [`` clojure`write ``](https://docs.racket-lang.org/reference/Writing.html?q=write#%28def._%28%28quote._~23~25kernel%29._write%29%29).

<fieldset>
<legend><strong>Note</strong></legend>

This kind of limitation in classical Hindley–Milner type systems occurs in many situations beyond `` clojure`call/cc ``. For example, in classical Hindley–Milner type systems the types of the _then_ and _else_ branches of a conditional must agree:

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
