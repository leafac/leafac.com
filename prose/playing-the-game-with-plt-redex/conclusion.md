---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

We covered the basics of PLT Redex without going into programming-language theory. Instead, we used it to model a game of [Peg Solitaire](peg-solitaire-rules). We used [terms](terms) to represent elements in the game: boards, pegs, spaces and paddings. We use [patterns to match](pattern-matching) those terms as the basis of several definitions:

- **[Languages](languages)**: Name patterns and specify which terms represent elements in Peg Solitaire and which do not.
- **[Metafunctions](metafunctions)**: Functions in the language of Peg Solitaire elements. They are deterministic: when faced with multiple choices (multiple clauses that match), a metafunction chooses *only one* path.
- **[Predicate Relations](predicate-relations)**: Similar to a metafunction that returns a single boolean of whether the predicate holds or not.
- **[Judgment Forms](judgment-forms)**: Similar to a metafunction, but works nondeterministically: when faced with multiple choices (multiple clauses that match), a judgment form chooses *all* paths. Can also be interpreted as a metafunction that returns a set of results.
- **[Reduction Relation](reduction-relations)**: A special kind of judgment form with mode of operation `I O`.

With this definitions in place, we used PLT Redex [visualization](visualization) tools to play Peg Solitaire. We then explored [other features](other-features), including unquoting, holes, testing and typesetting. We also discussed some [limitations](limitations), including debugging, performance, more advanced pattern matching, the lack of metaparameters, parallel reduction and higher-order metafunctions, how definition extensions do not reinterpret dependent definitions, how it can be difficult to customize typeset figures, and how PLT Redex is not appropriate for mechanized formal proofs.

* * *

When working with programming languages, terms represent programs and program fragments, machine states, and so forth. Languages define the grammar of relevant terms. Metafunctions are appropriate for auxiliary functions, for example, the one that interprets primitive operators, commonly notated `δ`. Predicate relations are appropriate for predicates including, for example, whether a term in the language is well-formed: whether it is closed or contains free variables, whether all variable references are in scope, and so forth. A judgment form is appropriate for defining interpreters and type systems, for example. It is more appropriate to use judgment forms over metafunctions for these purposes even if they are deterministic: construct the clauses so that they are mutually exclusive instead of relying on the order of clause definitions to clarify intent. Reduction relations are particularly appropriate for interpreters, specially when used in conjunction with holes.

* * *

You now know enough to read the more advanced material on PLT Redex, and understanding the tool will help you read papers in programming-language theory.

Acknowledgments
===============

Thanks to the following people for providing feedback on this article: [P.C. Shyamshankar](https://cs.jhu.edu/~shyam/), [Scott Moore](http://www.thinkmoore.net/), [Allan Vital](http://www.allanvital.com/) and [Rafael da Silva Almeida](http://rafaelalmeida.net/).
