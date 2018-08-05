---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
draft: true
---

<aside markdown="1">
**Pre-requisites**: Functional programming with pattern matching, and the basics of [Racket](https://docs.racket-lang.org/quick/index.html).  
Download the [code](playing-the-game-with-plt-redex.zip) and follow along in [DrRacket](https://racket-lang.org).
</aside>

[PLT Redex](https://redex.racket-lang.org/) is a tool for modeling programming languages, operational semantics, type systems, program analyses, and so forth. It is designed after the notation established by research papers, and the existing [educational material](related-work) for PLT Redex targets experienced programming-language researchers. But when I started learning PLT Redex, I was new to the field, so I struggled with *both* the research papers *and* the education material. Through the struggle, I noticed that this was a two-way street: reading papers helped me to understand PLT Redex, but perhaps more importantly, understanding PLT Redex helped me to read papers. I became more fluent in the notation, and could implement the theory in the papers more easily. PLT Redex was lowering the cost of experimenting, and supporting the most effective kind of reading: *active* reading.

With time, I realized that there is no *magic* in PLT Redex—it is just functional programming with pattern matching. I wish someone had told me that without bringing up Greek letters and jargon, and this is what I want to do for fellow programmers trying to break into programming-language theory. I write this article from the other side of the bump hoping to smooth the path for those that follow.

We will (ab)use PLT Redex to play a game of [Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire). It is a simple board game, but it serves as a backdrop to explore functional programming, pattern matching, contract verification, nondeterministic computation, visualization, typesetting, test generation, and so forth. This is a fun exercise of repurposing a tool for a task beyond its intended design, and it is a first step toward the virtuous cycle between knowing PLT Redex and reading papers.

We begin with [the minimum to go from nothing to playing the game as quickly as possible](introduction). We then start over and redo everything, going into more detail. We model Peg Solitaire elements (for example, pegs and boards) as [terms](terms) and [match them against patterns](pattern-matching). We formalize the notion of which terms represent Peg Solitaire elements with a [language](languages) and define [metafunctions](metafunctions) on this language. We model moves and the winning condition in Peg Solitaire with forms capable of nondeterministic computation: [reduction relations](redution-relations), [judgment forms](judgment-forms), and [predicate relations](predicate-relations). We play the game with the [visualization tools](visualization). We glance at [other features](other-features), including test generation and typesetting. Finally, we discuss [limitations](limitations) and [related work](related-work), and [conclude](conclusion).
