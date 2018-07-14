---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Peg Solitaire Rules
===================

Peg Solitaire is a single-player board game that starts with the following board:<label class="margin-note"><input type="checkbox"><span markdown="1">In the most common American version.</span></label>

<div class="code-block" markdown="1">
Initial Board
```
    ● ● ●
    ● ● ●
● ● ● ● ● ● ●
● ● ● ○ ● ● ●
● ● ● ● ● ● ●
    ● ● ●
    ● ● ●


●  Peg
○  Space
```
</div>

With each move, a peg can jump over its immediate neighbor on the North, East, South or West, and land on a space. The neighbor peg that was jumped over is removed from the board. For example, the following are the four possible starting moves:

<div class="code-block" markdown="1">
Examples of Valid Moves (Starting Moves)
<pre>
    ● ● ●             ● ● ●
    ● <span class="active">●</span> ●             ● ○ ●
● ● ● <span class="jumped-over">●</span> ● ● ●     ● ● ● <span class="jumped-over">○</span> ● ● ●
● ● ● ○ ● ● ●  <span class="success">➡</span>  ● ● ● <span class="active">●</span> ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ <span class="jumped-over">●</span> <span class="active">●</span> ●  <span class="success">➡</span>  ● ● ● <span class="active">●</span> <span class="jumped-over">○</span> ○ ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ ● ● ●  <span class="success">➡</span>  ● ● ● <span class="active">●</span> ● ● ●
● ● ● <span class="jumped-over">●</span> ● ● ●     ● ● ● <span class="jumped-over">○</span> ● ● ●
    ● <span class="active">●</span> ●             ● ○ ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● <span class="active">●</span> <span class="jumped-over">●</span> ○ ● ● ●  <span class="success">➡</span>  ● ○ <span class="jumped-over">○</span> <span class="active">●</span> ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●


<span class="active">●</span> jumps over <span class="jumped-over">●</span>
</pre>
</div>

The following are examples of *invalid moves*:

- A peg cannot jump diagonally:

  <pre>
      ○ ○ ○             ○ ○ ○
      ○ ○ ○             ○ ○ ○
  ○ <span class="active">●</span> ○ ○ ○ ○ ○     ○ ○ ○ ○ ○ ○ ○
  ○ ○ <span class="jumped-over">●</span> ○ ○ ○ ○  <span class="error">➡</span>  ○ ○ <span class="jumped-over">○</span> ○ ○ ○ ○
  ○ ○ ○ ○ ○ ○ ○     ○ ○ ○ <span class="active">●</span> ○ ○ ○
      ○ ○ ○             ○ ○ ○
      ○ ○ ○             ○ ○ ○
  </pre>

- A peg cannot jump beyond its neighbor:

  <pre>
      ○ ○ ○             ○ ○ ○
      ○ ○ ○             ○ ○ ○
  ○ ○ ○ ○ ○ ○ ○     ○ ○ ○ ○ ○ ○ ○
  ○ <span class="active">●</span> <span class="jumped-over">●</span> ○ ○ ○ ○  <span class="error">➡</span>  ○ ○ <span class="jumped-over">○</span> ○ <span class="active">●</span> ○ ○
  ○ ○ ○ ○ ○ ○ ○     ○ ○ ○ ○ ○ ○ ○
      ○ ○ ○             ○ ○ ○
      ○ ○ ○             ○ ○ ○
  </pre>

- A peg cannot jump over multiple neighbors:

  <pre>
      ○ ○ ○             ○ ○ ○
      ○ ○ ○             ○ ○ ○
  ○ ○ ○ ○ ○ ○ ○     ○ ○ ○ ○ ○ ○ ○
  ○ <span class="active">●</span> <span class="jumped-over">●</span> <span class="jumped-over">●</span> ○ ○ ○  <span class="error">➡</span>  ○ ○ <span class="jumped-over">○</span> <span class="jumped-over">○</span> <span class="active">●</span> ○ ○
  ○ ○ ○ ○ ○ ○ ○     ○ ○ ○ ○ ○ ○ ○
      ○ ○ ○             ○ ○ ○
      ○ ○ ○             ○ ○ ○
  </pre>

The goal of Peg Solitaire is to leave a single peg on the board, for example:

<div class="code-block" markdown="1">
Example of Winning Board
```
    ○ ○ ○
    ○ ○ ○
○ ○ ○ ○ ○ ○ ○
○ ○ ○ ● ○ ○ ○
○ ○ ○ ○ ○ ○ ○
    ○ ○ ○
    ○ ○ ○
```
</div>

The following is an example of a lost game in which two pegs remain on the board, but they are not neighbors, so we cannot move:

<div class="code-block" markdown="1">
Example of Losing Board
```
    ○ ○ ○
    ○ ○ ○
○ ○ ○ ● ○ ○ ○
○ ○ ○ ○ ○ ○ ○
○ ○ ○ ○ ○ ● ○
    ○ ○ ○
    ○ ○ ○
```
</div>

Prototype
=========

Our first implementation is the bare minimum to play the game. Over the course of the next sections we revisit the corners we cut and dive deeper into each topic.

Setup
-----

We start by requiring PLT Redex:

<div class="code-block" markdown="1">
`overview.rkt`
```racket
#lang racket
(require redex)
```
</div>

Language and Terms
------------------

Most PLT Redex forms work over languages, so we define a language for Peg Solitaire:

```racket
(define-language peg-solitaire)
```

The `peg-solitaire` language is analog to a programming language, for example, [Racket](https://www.racket-lang.com) and [Ruby](https://www.ruby-lang.com). Programs and program fragments in these programming languages are called [*terms*](terms), for example, the following are terms in Racket:

<div class="code-block" markdown="1">
Example of Term: Complete Program
```racket
(define favorite-number 5)
```
</div>
<div class="code-block" markdown="1">
Example of Term: Fragment of Program Above<label class="margin-note"><input type="checkbox"><span markdown="1">It also happens to be a complete Racket program.</span></label>
```racket
5
```
</div>

In the `peg-solitaire` language, however, terms are not programs and program fragments, but Peg Solitaire entities, for example, pegs and boards. From PLT Redex’s perspective<label class="margin-note"><input type="checkbox"><span markdown="1">And from the perspective of any program that works on other programs, for example, compilers, interpreters, linters, and so forth.</span></label> programs are data structures, and we abuse this notion to represent Peg Solitaire entities. The definition of the `peg-solitaire` language above does not specify the language shape; it does not define which terms represent which Peg Solitaire entities, and we revisit this in a [later section](languages), but this definition suffices for our prototype.

Terms in PLT Redex can be any [S-expression](TODO), and we represent a Peg Solitaire board with a list of lists of positions, each of which may be symbols representing pegs, spaces, and paddings:

<aside markdown="1">
1. The delimiters `()` and `[]` are equivalent in Racket. We improve readability by delimiting board rows with `[]` and the whole board with `()`.
2. A padding is represented by a middle dot (`·`), not by a regular dot (`.`).
</aside>

```racket
(define-term initial-board
  ([· · ● ● ● · ·]
   [· · ● ● ● · ·]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [· · ● ● ● · ·]
   [· · ● ● ● · ·]))


;; ●  Peg
;; ○  Space
;; ·  Padding
```

PLT Redex does not check that the `initial-board` is in the `peg-solitaire` language unless we request, so the listing above works despite the definition of the `peg-solitaire` language not specifying what constitutes a board.

Reduction Relations and Nondeterminism
--------------------------------------

To model how a player can move pegs on the board, we use a PLT Redex form called [`reduction-relation`](TODO) to define a [reduction relation](reduction-relations). A reduction relation is similar to a function, except for the following:

<aside markdown="1">
<figure markdown="1">
TODO:
```
-------------------------------------
| Relations                         |
|                                   |
|                                   |
| Functions       Reductions        |
|                                   |
|         [They intersect]          |
|                                   |
-------------------------------------
```
</figure>
</aside>

- As the word *reduction* implies, a reduction relation is expected to *reduce* the input. The notion of what constitutes a *reduced* term depends on the language, and PLT Redex does not enforce this expectation, but we should be careful in our definitions so that it holds. Generally, in programming languages, reducing a term reduces its size, for example, in Racket, the term `(+ 1 2)` reduces to `3`. In Peg Solitaire, the board size remains the same, but the number of pegs reduces with each move.

- A reduction relation in PLT Redex must be defined in terms of [pattern matching](pattern-matching). The input board is matched against a pattern and we provide a template with which to compute output.

- When the execution of a function has multiple paths it can follow—for example, when it reaches [`match`](TODO), [`cond`](TODO), [`case`](TODO), and so forth—it chooses only one option (generally the first successful clause). A reduction relation, on the hand, chooses *all* the options. We say a function is *deterministic*, while a reduction relation is *nondeterministic*.

More precisely, a function is a special case of relation that can only follow one execution path. Alternatively, a relation is a function that returns a set of results. The former interpretation is more mathematically accurate, while the latter is more useful for reasoning about certain PLT Redex features.<label class="margin-note"><input type="checkbox"><span markdown="1">For example, [`apply-reduction-relation`](TODO), which we introduce in a [later section](reduction-relations).</span></label>

One example of function<label class="margin-note"><input type="checkbox"><span markdown="1">As well as a relation, since all functions are relations.</span></label> is `successor`, that yields the successor of a number:<label class="margin-note"><input type="checkbox"><span markdown="1">In Racket, `successor` is called [`add1`](TODO).</span></label>

| `x` | `(sucessor x)` |
|-|-|
| `0` | `1` |
| `1` | `2` |
| `2` | `3` |
| `3` | `4` |
| `⋮` | `⋮` |

Observe how each number appears only once on the left column: a function relates each input with a single output.

One example of a relation that is not a function is greater-than (`>`):

| `x` | `(> x)` |
|-|-|
| `0` | `1` |
| `0` | `2` |
| `0` | `3` |
| `0` | `4` |
| `⋮` | `⋮` |
| `1` | `2` |
| `1` | `3` |
| `1` | `4` |
| `1` | `5` |
| `⋮` | `⋮` |

Observe how each number appears on the left column more than once: a relation may relate each input with multiple outputs.

We can also interpret a relation as a function that returns a set of outputs:

| `x` | `(> x)` |
|-|-|
| `0` | `{1, 2, 3, 4, …}` |
| `1` | `{2, 3, 4, 5, …}` |
| `⋮` | `⋮` |

Moves
-----

We define moves as a reduction relation, as opposed to a regular function, because there might be multiple possible moves on a given board, and we want to explore all possibilities.
