---
layout: default
title: Playing the Game with PLT Redex
date: 2018-07-14
table-of-contents: table-of-contents.html
---

<aside markdown="1">
**Pre-requisites**: [Racket](https://docs.racket-lang.org/quick/index.html).
</aside>

[PLT Redex](https://redex.racket-lang.org/) is a tool for modeling programming languages, operational semantics, type systems, program analyses, and so forth. When I was first learning PLT Redex, I was new both to the tool and to programming-language theory, so I struggled with the [educational material](related-work). The main reason for the struggle was that PLT Redex is designed after the notation found in research papers, which I found hard to grasp. I started to make progress when I identified the underlying familiar ideas, for example, functional programming and pattern matching. This formed a virtuous cycle: reading papers helped me to understand PLT Redex, but perhaps more importantly, understanding PLT Redex helped me to read papers.

This article is for people in a similar place, people with a background in programming that are breaking into programming-language theory. To smooth the path, we introduce PLT Redex avoiding Greek letters and jargon. We (ab)use the tool to play a game of [Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire), exploring features for functional programming, pattern matching, contract verification, nondeterministic computation, visualization, typesetting, test generation, and so forth. It is a fun exercise of repurposing a tool for tasks beyond its intended design, and a first step towards being able to read research papers.

* * *

We start by reviewing [Peg Solitaire rules](peg-solitaire-rules). We model the game in PLT Redex in a series of steps. Pegs and boards become [terms](terms), and we learn how to [pattern match](pattern-matching) on them. We specify which terms represent pegs and boards with a [language](languages). To warm up, we define [metafunctions](metafunctions) on this language. We proceed to a form capable of nondeterministic computation, the [reduction relation](redution-relations), which we use to model moves in Peg Solitaire. We then use [visualization tools](visualization) to *play* the game. We explore more sophisticated features: [relations](relations) and [judgment forms](judgment-forms).  We glance at [other features](other-features), including test generation and typesetting. Finally, we discuss PLT Redex [limitations](limitations) and [related work](related-work), and [conclude](conclusion).
