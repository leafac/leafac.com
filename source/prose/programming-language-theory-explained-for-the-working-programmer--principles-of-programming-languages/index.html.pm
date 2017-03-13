#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}
◊define-meta[date]{2017-03-13}

◊margin-note{This article assumes prior knowledge in programming. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required.}

◊new-thought{Programming languages come} in many sizes and flavors. Some are high-level to the point that the abstractions in them make the brain hurt, some are down to the metal to the point that brain is thinking in terms of zeros and ones. Working programmers have been exposed to at least a few different programming languages and might question: Besides matters of convenience and taste, are there tasks that can only be accomplished in some languages and not in others? In other words, are there languages that are fundamentally more powerful than others? Moreover, what are the fundamental principles behind them?

In this article, we are going to explore those questions. But, differing from most presentations on the area, we are going to avoid mathematical notation and jargon. Instead, we are going to use working code to illustrate the ideas, making the discussion approachable to all programmers.

