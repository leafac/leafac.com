---
layout: default
title: Playing the Game with PLT Redex
date: 2018-06-18
table-of-contents: table-of-contents.html
---

<aside markdown="1">
**Pre-requisites**: Racket.
</aside>

[PLT Redex](https://redex.racket-lang.org/) is a tool for the researcher working with programming languages, operational semantics, type systems, program analyses, and so forth. It is a domain-specific language<label class="margin-note"><input type="checkbox"><span markdown="1">**Domain-Specific Language**: A language designed for a specific purpose, for example, querying data from a database (SQL) and matching strings (Regular Expressions), as opposed to *general-purpose programming languages*, for example, Racket, Ruby and Java.</span></label> in Racket designed after the notation found in research papers. You can find [great documentation and educational materials about PLT Redex](related-work), but they tend to assume that you are already familiar with programming-language theory. When I was learning about PLT Redex, I was new to both the tool and to programming-language theory, so sometimes I struggled to follow along. What I found, however, is that it can be a two-way street: learning PLT Redex has helped me understand papers and programming-language theory.

This article is targeted at people in a similar place. We introduce PLT Redex for the reader new to programming-language theory, avoiding Greek letters and jargon. We (ab)use the tool to play a game of [Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire) and explore the features for functional programming, pattern matching, contract verification, nondeterministic computation, visualization, typesetting, test generation, and so forth. It is a fun exercise of repurposing a tool for tasks beyond its intended design, and a first step for reading technical papers.

* * *

We start by reviewing [Peg Solitaire rules](peg-solitaire-rules). We model the game in PLT Redex in a series of steps. Pegs and boards become [terms](terms), and we learn how to [pattern match](pattern-matching) on them. We specify a [language](languages) to determine what terms represent pegs and boards, and define [metafunctions](metafunctions) and [predicate relations](predicate-relations) over them. We proceed to more sophisticated features for nondeterministic computation: [judgment forms](judgment-forms) and [reduction relations](redution-relations). We then use [visualization tools](visualization) to *play* Peg Solitaire. We glance at [other features](other-features), including test generation and typesetting. Finally, we discuss PLT Redex [limitations](limitations), [related work](related-work) and [conclude](conclusion).
