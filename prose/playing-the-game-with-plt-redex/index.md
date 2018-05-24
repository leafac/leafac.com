---
layout: default
title: Playing the Game with PLT Redex
date: 2018-05-24
---

<aside markdown="1">
**Pre-requisites**: Functional programming; immutable data structures; pattern matching; Racket.
</aside>

I enjoy repurposing tools for tasks clearly beyond their intended design: I learn how the tools work and where they break. Besides, it is fun. It is also a way to avoid intimidating theory that might be associated with these tools, a common problem for more technical tools, particularly those designed by researchers for other researchers. While I play, I discover the beautiful, simple ideas that may have been obscured by the Greek letters and the jargon. It is an exercise in technical virtuosity, but more importantly, in aesthetics and creativity.

In a recent exploration, I (ab)used [PLT Redex](https://redex.racket-lang.org/) to implement a game of [Peg Solitaire](https://en.wikipedia.org/wiki/Peg_solitaire), and I discovered an unusual model of computation: non-deterministic computation. PLT Redex is a [Racket](https://racket-lang.org/) library for semantics engineering. In the hands of semanticists and programming-language theorists, PLT Redex is a lightweight tool to work with languages, operational semantics, type systems and so forth.

But at its core PLT Redex is just a functional programming language with sophisticated pattern matching and visualization tools. It also allow us to define relations capable of non-deterministic computation, a computational model with which most programmers are unfamiliar, but that can facilitate many programming tasks.

* * *

We start with [Peg Solitaire’s rules](#game-rules), and we model it in PLT Redex: the [data structures](#data-structures) become a language and the [moves](#moves) become a non-deterministic relation. We then use PLT Redex visualization tools to [play the game](#play). Next, we reach the limits of the tools capabilities and try to use our model to find a way to [win](#win) the game. We look at [other limitations](#other-limitations) and [conclude](#conclusion).

Acknowledgments
===============

Thanks to the following people for providing feedback on this article: [P.C. Shyamshankar](https://cs.jhu.edu/~shyam/), [Scott Moore](http://www.thinkmoore.net/), [Allan Vital](http://www.allanvital.com/) and [Rafael da Silva Almeida](http://rafaelalmeida.net/).

Appendix: Listing
=================

<div class="full-width" markdown="1">
<div class="code-block" markdown="1">
[peg-solitaire.rkt](peg-solitaire.rkt)
```racket
{% include_relative peg-solitaire.rkt %}
```
</div>
</div>
