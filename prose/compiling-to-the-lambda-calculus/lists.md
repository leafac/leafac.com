---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

Lists are composed of [pairs](pairs), for example, `(list 1 2)` is the same as `(cons 1 (cons 2 null))`, where `null` is a distinguished element that represents the empty list.

Values
======

The main challenge in encoding lists is defining the empty list ([`null`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28quote._~23~25kernel%29._null%29%29)) and its corresponding predicate [`null?`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28quote._~23~25kernel%29._null~3f%29%29). The empty list (`null`) must be similar to a pair in structure, because either one of them can be an argument to `null?`. Recall the encoding of pairs-as-functions from the [previous section](pairs):

```racket
[`cons `(λ (a b) (λ (s) (s a b)))]
```

The pair returned from `cons` is a function of the form `(λ (s) (s a b))`, where `s` is a selector that chooses between the pair elements `a` and `b`. The empty list (`null`) must also have the form `(λ (s) ___)`, and we can fill in the blank with a value that `null?` can extract. We ignore the selector `s` that as passed as argument and fill in the blank with `#t`. We also define [`empty`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._empty%29%29) and `(list)` as aliases for `null`:

```racket
[`null `(λ (s) #t)]
[`empty `null]
[`(list) `empty]
```

We can define `null?` as a function that receives a list as an argument: `(λ (l) ___)`. The list `l` may either be empty (`null`) or a pair resulting from `cons`. In any case `l` is a function that can be called with a selector `s`: if the list is empty, then the selector is ignored by our encoding for `null`, and if the list is non-empty, then our encoding for pairs calls `s` with arguments `a` and `b`. So we let `s` be a function that ignores its arguments `a` and `b` and returns `#f`: `(λ (a b) #f)`. This completes our encoding for `null?`:

```racket
[`null? `(λ (l) (l (λ (a b) #f)))]
```

When `null?` is called with the empty list (`null`) it ignores the selector `(λ (a b) #f)` and returns `#t` as per the encoding of `null` above. And when `null?` is called with a non-empty list (a pair), the selector `(λ (a b) #f)` ignores the pair elements and returns `#f`.

Finally, we can define non-empty lists in terms of pairs (`cons`):

```racket
[`(list ,eʰ ,eᵗ ...) `(cons ,eʰ (list ,@eᵗ))]
```

The encoding above transforms, for example, the list `(list 1 2)` into `(cons 1 (list 2))`, and then into `(cons 1 (cons 2 (list)))`, which means the same as `(cons 1 (cons 2 null))`.

* * *

We define [`first`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._first%29%29) and [`rest`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._rest%29%29) as aliases to [`car` and `cdr` on pairs](pairs) for convenience:

```racket
[`first `car]
[`rest `cdr]
```

Programmers in our language can use `car`/`cdr` or `first`/`rest` to communicate whether they to operate on pairs or lists, though their structure is the same.

* * *

To inspect lists in our language, we need to convert our encodings in terms of functions back into Racket lists. We will restrict ourselves to inspect lists in which elements have the same type, for example, `(list 1 2)` and `(list #t #f)`.<label class="margin-note"><input type="checkbox"><span markdown="1">Homogenous lists.</span></label> Our language supports lists in which elements have different types, for example, `(list 1 #f)`,<label class="margin-note"><input type="checkbox"><span markdown="1">Heterogenous lists.</span></label> but there is no natural way to define an inspector for them.<label class="margin-note"><input type="checkbox"><span markdown="1">One solution would be to tag every value with its type. We could map types to numbers (for example, number maps to 0, boolean maps to 1, and so forth), and pair every value in our language with its numeric tag. Then we could inspect the tag to select the appropriate inspector. But this would complicate our language; for example, we would need to modify all operators to handle the type tags.</span></label>

We can use the `null?` predicate defined above to check whether the list is empty, and delegate to [`inspect/pair`](pairs) if it is not. Similar to `inspect/pair`, the `inspect/list` function receives as argument another inspector `inspect/element` to use in the elements. This `inspect/element` is passed as the first argument to `inspect/pair`, because list elements are always in the left position of the pair. The right element is another list, so we let the second argument to `inspect/pair` be `(inspect/list inspect/element)`:<label class="margin-note"><input type="checkbox"><span markdown="1">This is example of how partially applying our inspectors is more ergonomic: we can write `(inspect/list inspect/element)` instead of `(λ (e) (inspect/list inspect/element e))`.</span></label>

```racket
(define ((inspect/list inspect/element) e)
  (if (inspect/boolean ((evaluate 'null?) e))
      null
      ((inspect/pair inspect/element (inspect/list inspect/element)) e)))
```

* * *

We can check our encoding for lists:

```racket
(check-equal? ((inspect/list inspect/number) (evaluate 'null)) '())
(check-equal? ((inspect/list inspect/number) (evaluate 'empty)) '())
(check-equal? (inspect/boolean (evaluate '(null? null))) '#t)
(check-equal? (inspect/boolean (evaluate '(null? (cons #t 5)))) '#f)
(check-equal? ((inspect/list inspect/number) (evaluate '(list))) '())
(check-equal? ((inspect/list inspect/number) (evaluate '(list 1))) '(1))
(check-equal? ((inspect/list inspect/number) (evaluate '(list 1 2))) '(1 2))
(check-equal? (inspect/number (evaluate '(first (list 1 2)))) '1)
(check-equal? ((inspect/list inspect/number) (evaluate '(rest (list 1 2)))) '(2))
```

List Iteration
==============

The inspector we defined above is one example of iterating through a list, but it is at the Racket level. We present [`map`](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Fmap..rkt%29._map%29%29) as an example of list iteration within our language. The `map` function receives two arguments, a function `f` to apply to each list element, and the list `l` through which to iterate. We can use the `null?` predicate to check whether we reached the end of the list (`null`); if there are list elements left, we reconstruct the list with `f` applied to the element from `l` and `map` applied to the rest of `l`:

```racket
[`map `(letrec ([ma (λ (f l) (if (null? l) l (cons (f (car l)) (ma f (cdr l)))))]) ma)]
```

The `map` function is recursive ([`letrec`](bindings#recursive-bindings)), and it uses the auxiliary name `ma` to prevent the compiler from trying to expand the recursive use of `map`. The function `ma` is returned in the `letrec` body immediately. We have enough high-level constructs in our language at this point that the definition of `map` is similar to the one we could write in Racket.

We can test `map`:

```racket
(check-equal? ((inspect/list inspect/number) (evaluate '(map add1 (list 1 2)))) '(2 3))
```

Other Data Structures
=====================

- Association lists & Objects

- [ ] Note the similarity between numbers and pairs!
  ;;       • 0 ≈ null
  ;;       • number’s f ≈ pair’s s
  ;;       • number’s x ≈ pair’s a, b
  ;;       • The major difference is the order (f x), (a b s)
  ;;       • zero? ≠ null? because of this difference in order
  ;;       • Numbers are lists that don’t hold any values
