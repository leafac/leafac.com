---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

We covered the basics of PLT Redex without going into programming-language theory. Instead, we used it to model a game of [Peg Solitaire](peg-solitaire-rules). We used [terms](terms) to represent elements in the game: boards, pegs, spaces and paddings. We used [patterns to match](pattern-matching) those terms as the basis of several definitions:

- **[Languages](languages)**: Named patterns that specify which terms represent elements in Peg Solitaire and which do not.
- **[Metafunctions](metafunctions)**: Functions in the language of Peg Solitaire elements. They are deterministic: when faced with multiple choices (multiple clauses that match), a metafunction chooses *only one* path.
- **[Reduction Relations](reduction-relations)**: Similar to a metafunction, but works nondeterministically: when faced with multiple choices (multiple clauses that match), a judgment form chooses *all* paths. Can also be understood as a metafunction that returns a set of results.
- **[Predicate Relations](predicate-relations)**: Similar to a reduction relation that returns a single boolean indicating whether the predicate holds or not.
- **[Judgment Forms](judgment-forms)**: The most general form of relation, with arbitrarily many inputs and outputs.

With these definitions in place, we used PLT Redex [visualization](visualization) tools to play Peg Solitaire. We then explored [other features](other-features), including extra conditions for a clause to contribute to the output, unquoting, holes, testing and typesetting. We also discussed some [limitations](limitations), including debugging, performance, and more advanced pattern matching; the lack of metaparameters, parallel reduction and higher-order metafunctions; how definition extensions do not reinterpret dependent definitions; how it can be difficult to customize typeset figures; and how PLT Redex is not appropriate for mechanized formal proofs.

* * *

You now know enough to read the more advanced material on PLT Redex, and understanding the tool will help you read papers in programming-language theory.

Acknowledgments
===============

Thanks to the following people for providing feedback on a preliminary version of this article: [P.C. Shyamshankar](https://cs.jhu.edu/~shyam/), [Scott Moore](http://www.thinkmoore.net/), [Allan Vital](http://www.allanvital.com/) and [Rafael da Silva Almeida](http://rafaelalmeida.net/).
