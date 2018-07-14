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

We start by requiring PLT Redex:

<div class="code-block" markdown="1">
`overview.rkt`
```racket
#lang racket
(require redex)
```
</div>

Most PLT Redex forms work over languages, so we define a language for Peg Solitaire:

```racket
(define-language peg-solitaire)
```

The `peg-solitaire` language is analog to a programming language, for example, [Racket](https://www.racket-lang.com) and [Ruby](https://www.ruby-lang.com). Programs and program fragments in these programming languages are called [*terms*](terms), for example, the following are terms in Ruby:

<div class="code-block" markdown="1">
Example of Term: Complete Ruby Program
```ruby
age = 27
name = :Leandro
puts "How are you?"
```
</div>
<div class="code-block" markdown="1">
Example of Term: Fragment of Program Above
```ruby
"How are you?"
```
</div>

In the `peg-solitaire` language, however, terms are not programs and program fragments, but Peg Solitaire entities, for example, pegs and boards. From PLT Redex’s perspective<label class="margin-note"><input type="checkbox"><span markdown="1">And from the perspective of any program that works on other programs, for example, compilers, interpreters, linters, and so forth.</span></label> programs are data structures, and we abuse this notion to represent Peg Solitaire entities. The definition of the `peg-solitaire` language above does not specify the language shape; it does not define which terms represent which Peg Solitaire entities, and we revisit this in [a later section](languages), but this definition suffices for our prototype.

We represent a Peg Solitaire board with a list of lists of positions, each of which may be pegs, spaces, or paddings:

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

PLT Redex does not check that the `initial-board` is in the `peg-solitaire` language unless we ask it, so the listing above works despite the definition of the `peg-solitaire` language not specifying what constitutes a board.

* * *
