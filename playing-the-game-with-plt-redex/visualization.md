---
layout: default
title: "Playing the Game with PLT Redex"
table-of-contents: true
---

We use PLT Redex visualization tools to play Peg Solitaire. The `stepper` form runs either the `⇨` [reduction relation](reduction-relations) or the `⇨/judgment-form` [judgment form](judgment-forms) on the `initial-board`:

<figure markdown="1">
<figcaption markdown="1">
`visualization.rkt`
</figcaption>
```racket
#lang racket
(require redex "terms.rkt" "reduction-relations.rkt" "judgment-forms.rkt")


> (stepper ⇨ (term initial-board))
> (stepper ⇨/judgment-form (term initial-board))
```
<figcaption markdown="1">
The `stepper` form only works on judgment forms with mode `I O` (for example, `⇨/judgment-form`) or `O I`.
</figcaption>
</figure>

DrRacket opens the window below:

<figure markdown="1">
![](stepper-1.png){:width="600"}
<figcaption markdown="1">
DrRacket showing the stepper. **Left:** The `initial-board`. **Right:** The button to make a move. **Bottom:** A graph showing the path we took while playing the game with only one node that represents the `initial-board`.
</figcaption>
</figure>

We click on the `→` button to make the first move:

<figure markdown="1">
![](stepper-2.png){:width="600"}
<figcaption markdown="1">
The stepper shows the four possible initial moves on the main pane and on the graph at the bottom.
</figcaption>
</figure>

We select the second board by clicking on the `↕` button next to it:

<figure markdown="1">
![](stepper-3.png){:width="600"}
<figcaption markdown="1">
The stepper highlights the differences between the `initial-board` and the board we chose. The graph at the bottom shows the path. On the bottom right, the stepper shows the clause we chose, `↑`.
</figcaption>
</figure>

We click on the `→` button to make the second move:

<figure markdown="1">
![](stepper-4.png){:width="600"}
<figcaption markdown="1">
The stepper shows the three available moves.
</figcaption>
</figure>

We select the board on the bottom by clicking on the `↕` button next to it:

<figure markdown="1">
![](stepper-5.png){:width="600"}
<figcaption markdown="1">
The game proceeds.
</figcaption>
</figure>

We can undo moves and try different paths by click on the nodes on the graph at the bottom:

<figure markdown="1">
![](stepper-6.png){:width="600"}
<figcaption markdown="1">
We return to the beginning of the game and chose a different move by clicking on a node in the graph at the bottom. The stepper highlights the differences between the `initial-board` and our new current board.
</figcaption>
</figure>

We proceed with the game in this alternate path by clicking on `→`:

<figure markdown="1">
![](stepper-7.png){:width="600"}
<figcaption markdown="1">
The next move in the alternate path. The graph at the bottom includes one node for every board we explored.
</figcaption>
</figure>

We accomplished our goal of playing Peg Solitaire by (ab)using PLT Redex.

Traces
======

We can explore Peg Solitaire further with the `traces` form, which accepts the same inputs as `stepper` and explores *all* possible moves:

```racket
> (traces ⇨ (term initial-board))
> (traces ⇨/judgment-form (term initial-board))
```

DrRacket opens the window below:

<figure markdown="1">
![](traces-1.png){:width="600"}
<figcaption markdown="1">
The tracer explores all possible moves up to a certain number of boards. This graph is the fully expanded version of the graph at the bottom of the `stepper` window. Click on **Reduce** to explore further.
</figcaption>
</figure>

<figure markdown="1">
![](traces-2.png){:width="600"}
<figcaption markdown="1">
When we click on a board, the tracer highlights the moves leading to it and those coming from it. The edges are labeled with the clause associated with the move.
</figcaption>
</figure>

We only explored a small fraction of PLT Redex, in the next section we cover [other features](other-features).
