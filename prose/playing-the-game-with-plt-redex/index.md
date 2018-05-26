---
layout: default
title: Playing the Game with PLT Redex
date: 2018-05-24
table-of-contents: table-of-contents.html
---

<aside markdown="1">
**Pre-requisites**: Racket.
</aside>

[PLT Redex](https://redex.racket-lang.org/) is a tool for semantics engineering: working with languages, operational semantics, type systems, program analyses, and so forth. It was designed as a domain-specific language in Racket that resembles what researchers write in their papers, particularly those in the area of programming-language theory. You can find [great documentation and educational materials about PLT Redex](related-work), but they tend to assume that you are familiar with programming-language theory and are already used to reading and writing those kinds of papers. When I was learning about PLT Redex, I was new both to the tool and to programming-language theory, and I sometimes struggled to follow along. What I found, however, is that this can be a two-way street: learning PLT Redex helped me read the papers and understand the theory.

This article introduces PLT Redex *outside* the domain of programming-language theory. We use the tool to play a game of [Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire), avoiding Greek letters and jargon, but leveraging PLT Redex features for functional programming, pattern matching, contract verification, non-deterministic computation, visualization, typesetting, test generation, and more. Besides, we have fun repurposing tools for tasks beyond their intended in an exercise of technical virtuosity, but more importantly, of aesthetics and creativity.

* * *

We start by reviewing [Peg Solitaire rules](peg-solitaire-rules). We then model the game in PLT Redex in a series of steps. Pegs and boards become [terms](terms), and we learn how to [pattern match](pattern-matching) on them. We specify a [language](languages) to determine what terms represent pegs and boards, and define a [metafunction](metafunctions) over them. We move on to more sophisticated features capable of non-deterministic computation: [predicate relations](predicate-relations), [judgment forms](judgment-forms) and [reduction relations](redution-relations). We than use [visualization tools](visualization) to *play* Peg Solitaire. We glance at [other features](other-features), including typesetting and test generation. Finally, we discuss PLT Redex [limitations](limitations), [related work](related-work) and [conclude](conclusion).
