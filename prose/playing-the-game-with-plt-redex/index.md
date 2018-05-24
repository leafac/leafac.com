---
layout: default
title: Playing the Game with PLT Redex
date: 2018-05-24
table-of-contents: table-of-contents.html
---

<aside markdown="1">
**Pre-requisites**: Functional programming; pattern matching; Racket.
</aside>

I enjoy repurposing tools for tasks beyond their intended design. I do it to learn how the tools work and where they break, and as a way to avoid intimidating theory. Technical tools designed by academics generally include beautiful and simple ideas that may have been obscured by the Greek letters and the jargon. I discover these ideas as I play with the tools, in an exercise of technical virtuosity, but more importantly, of aesthetics and creativity.

In a recent exploration, I (ab)used [PLT Redex](https://redex.racket-lang.org/) to implement the game of [Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire), and I discovered an unusual model of computation: non-deterministic computation. PLT Redex is a [Racket](https://racket-lang.org/) library for semantics engineering. In the hands of semanticists and programming-language theorists, PLT Redex is a lightweight tool to work with languages, operational semantics, type systems and so forth.

But at its core PLT Redex is just a functional programming language with sophisticated pattern matching and visualization tools. It can define relations that compute non-deterministically, a model of computation unfamiliar to most programmers that can facilitate many programming tasks.

* * *

We start with [Peg Solitaire rules](peg-solitaire-rules), and how to model them in PLT Redex: the [data structures](data-structures) become a language and the [moves](moves) become a non-deterministic relation. We then use PLT Redex visualization tools to [play](play) the game. Next, we reach the tool’s limits when trying to use our model to [win](win) the game. We look at [other limitations](other-limitations) and [conclude](conclusion).
