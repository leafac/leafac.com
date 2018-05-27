---
layout: default
title: Playing the Game with PLT Redex
table-of-contents: table-of-contents.html
---

Peg Solitaire is a single-player board game that starts with the following board:<label class="margin-note"><input type="checkbox"><span markdown="1">In the most common American version.</span></label>

```
    ● ● ●
    ● ● ●
● ● ● ● ● ● ●
● ● ● ○ ● ● ●
● ● ● ● ● ● ●
    ● ● ●
    ● ● ●


○  Hole
●  Peg
```

At each move, a peg can jump over its immediate neighbor on the North, East, South or West, and land on a hole. The neighbor peg that was jumped over is removed from the board. For example, the following are the four possible starting moves:

<pre>
    ● ● ●             ● ● ●
    ● <span class="active">●</span> ●             ● ○ ●
● ● ● <span class="jumped-over">●</span> ● ● ●     ● ● ● <span class="jumped-over">○</span> ● ● ●
● ● ● ○ ● ● ●  ➡  ● ● ● <span class="active">●</span> ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ <span class="jumped-over">●</span> <span class="active">●</span> ●  ➡  ● ● ● <span class="active">●</span> <span class="jumped-over">○</span> ○ ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ ● ● ●  ➡  ● ● ● <span class="active">●</span> ● ● ●
● ● ● <span class="jumped-over">●</span> ● ● ●     ● ● ● <span class="jumped-over">○</span> ● ● ●
    ● <span class="active">●</span> ●             ● ○ ●
    ● ● ●             ● ● ●

    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● <span class="active">●</span> <span class="jumped-over">●</span> ○ ● ● ●  ➡  ● ○ <span class="jumped-over">○</span> <span class="active">●</span> ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●


<span class="active">●</span> jumps over <span class="jumped-over">●</span>
</pre>

The following are examples of *disallowed moves*:

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

```
    ○ ○ ○
    ○ ○ ○
○ ○ ○ ○ ○ ○ ○
○ ○ ○ ● ○ ○ ○
○ ○ ○ ○ ○ ○ ○
    ○ ○ ○
    ○ ○ ○
```

The following is an example of a lost game in which two pegs remain on the board, but they are not neighbors, so we cannot move:

```
    ○ ○ ○
    ○ ○ ○
○ ○ ○ ● ○ ○ ○
○ ○ ○ ○ ○ ○ ○
○ ○ ○ ○ ○ ● ○
    ○ ○ ○
    ○ ○ ○
```
