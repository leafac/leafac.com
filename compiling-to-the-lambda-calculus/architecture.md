---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

- http://matt.might.net/articles/compiling-up-to-lambda-calculus/
- Fixed point of `expand` to build `compile`
- Syntax-directed: Simplest thing, but may be repetitive.
- Recursive (make progress).
- Testing.
- Untyped & intrinsic vs. extrinsic & not supporting predicates like ‘number?’ (but ‘null?’ is fine, because it checks for a specific value)
- Quasiquoting & unquoting & unquote splicing.
- Pattern matching
- Currying and partial definitions with `define`.
- Variable number of arguments: only the ones we define, not available for the programmer to define.
- `gensym` for fresh identifiers
- `match`: `?`, guards (`#:when`), ellipses (`...`)
- There are multiple ways to encode.
- Some tests will only pass much later in the article, because we need the later encodings.
- It would have been possible to DRY the code, for example, on the binary operators. But we decided not to for simplicity.

Inspectors
==========
