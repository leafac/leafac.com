#lang pollen

◊define-meta[title]{Playing the Game with PLT Redex}
◊define-meta[date]{2017-03-12}

◊margin-note{This article assumes prior knowledge on programming in general and some exposure to functional programming in particular—specially immutable data structures and pattern matching. Racket experience is helpful, but not mandatory.}

◊margin-note{◊figure{◊svg{images/peg.svg}◊figure/caption{A peg. Solitary.}}}

◊link["https://redex.racket-lang.org/"]{◊initialism{PLT} Redex} is a ◊link["https://racket-lang.org/"]{Racket} library for semantics engineering. For people trained in programming-language theory, it is a lightweight tool to work with languages, operational semantics, type systems and more. But that is not how we will use it in this article. At its core, ◊initialism{PLT} Redex is a functional programming language with sophisticated pattern matching and visualization tools. And we will abuse them to play a game of ◊link["https://en.wikipedia.org/wiki/Peg_solitaire"]{Peg Solitaire}.

Why? Mainly because it is amusing to repurpose tools for tasks clearly beyond their intended design. Also, for those new to ◊initialism{PLT} Redex, this might be a gentler introduction, avoiding the Greek letters and the jargon. Along the way, we will cover interesting topics including an alternative model of computation—non-deterministic computation—and goal-directed search.

◊section['rules-of-the-game]{Rules of the Game}

◊margin-note{This section explains the rules of Peg Solitaire. If you already know them, ◊reference['data-structures]{skip ahead}.}

Peg Solitaire is a 1-player board game. The initial arrangement of the board is the following:

◊margin-note{There are other possible initial arrangements. We are considering the most common American variation.}

◊code/block{
    ● ● ●
    ● ● ●
● ● ● ● ● ● ●
● ● ● ○ ● ● ●
● ● ● ● ● ● ●
    ● ● ●
    ● ● ●
}

In the figures representing the board, ○ stands for holes and ● for holes containing pegs.

Pegs can jump over their immediate neighbors on the North, East, South and West—not on the diagonals—as long as they land on an empty hole. The neighbor peg that was jumped over is removed from the board. For example, the following is an allowed move:

◊code/block{
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ◊span[#:class "k"]{● ● ○} ● ● ●  ⇒  ● ◊span[#:class "k"]{○ ○ ●} ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
}

In this move, a peg jumped over its immediate neighbor on the East.

The following is an example of an ◊emphasis{invalid} move:

◊code/block{
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ◊span[#:class "x"]{○ ○ ● ●} ● ●  ⇒  ● ◊span[#:class "x"]{● ○ ○ ○} ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
}

The problem with this move is that the peg must land on the empty hole right next to the neighbor over which it jumped.

The goal of the game is to leave a single peg on the board. The following is an example of a ◊emphasis{lost} game:

◊code/block{
    ○ ○ ○
    ○ ○ ○
○ ○ ○ ● ○ ○ ○
○ ○ ○ ○ ○ ○ ○
○ ○ ○ ○ ○ ● ○
    ○ ○ ○
    ○ ○ ○
}

There are still two pegs remaining on the board, but they are not neighbors, so there are no further moves to make.

◊section['data-structures]{Data Structures}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/playing-the-game-with-plt-redex/peg-solitaire.rkt"]{Here} is the code for this entire article.}

We need data structures to represent the pegs and the board. Normally one would use enumerations, lists, records, objects and so forth, but we use a ◊emphasis{language} as our data structure definition. Terms in the language will represent board configurations. ◊initialism{PLT} Redex lets us define a grammar for a language in ◊link["https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form"]{◊initialism{BNF}} form:

◊margin-note{We are using Racket’s support for Unicode identifiers.}

◊code/block/highlighted['racket]{
(define-language peg-solitaire
  [position ::= █ ○ ●]
  [board ::= ([position ...] ...)])
}

◊margin-note{The ◊code/inline{position} data structure is analogous to an enumeration.}

The code above defines two data structures. The first, ◊code/inline{position}, represents a position on the board. It can be one of following: ◊code/inline{█} is an uninitialized position that only serves as padding and is not really part of the board; ◊code/inline{○} is an empty position; and ◊code/inline{●} is a position containing a peg.

◊margin-note{In Racket, different kinds of brackets—◊code/inline{()}, ◊code/inline{[]} and ◊code/inline{{}}—mean the same. The only constraint is that open and close brackets match; ◊code/inline{(]} is invalid. Which bracket to use is a matter of readability.}

◊margin-note{The ellipsis (◊code/inline{...}) in ◊initialism{PLT} Redex are similar to the Kleene star (◊code/inline{*}) in regular expressions.}

The second data structure is the ◊code/inline{board}, represented as a matrix of ◊code/inline{position}s, or, more specifically, a list of lists of ◊code/inline{position}s. In ◊initialism{PLT} Redex, the ellipsis (◊code/inline{...}) means “the previous element repeated any number of times.” So ◊code/inline{[position ...]} means a list of ◊code/inline{position}s, and ◊code/inline{([position ...] ...)} means a list of lists of ◊code/inline{position}s.

◊margin-note{
 Even ill-formed boards like the following are valid terms in this data structure definition:

 ◊code/block/highlighted['racket]{
([●])

([● ○ ●]
 [● ○ █ ●])
 }

 But we will not to consider them.
}

Examples of terms in the language (boards) are:

◊code/block/highlighted['racket]{
([█ █ ● ● ● █ █]
 [█ █ ● ● ○ █ █]
 [● ○ ● ○ ● ● ●]
 [● ● ● ○ ○ ○ ●]
 [● ○ ● ● ● ● ●]
 [█ █ ● ○ ● █ █]
 [█ █ ● ● ● █ █])

([█ █ ● ○ ● █ █]
 [█ █ ● ● ○ █ █]
 [● ○ ● ○ ● ● ●]
 [● ● ● ○ ○ ○ ●]
 [● ○ ● ● ○ ● ●]
 [█ █ ● ○ ● █ █]
 [█ █ ○ ● ● █ █])
}

We define the configuration for the initial Peg Solitaire board as a term in the language:

◊code/block/highlighted['racket]{
(define-term initial-board
  ([█ █ ● ● ● █ █]
   [█ █ ● ● ● █ █]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [█ █ ● ● ● █ █]
   [█ █ ● ● ● █ █]))
}

◊section['moves]{Moves}

We need to specify how pegs can to move on the board. We do this by defining a function that encodes the rules of Peg Solitaire; it receives a board as an argument and returns a set of new boards in which each board has a distinct configuration reachable in one move. Each of the rules that compose this function has the form “if the board looks this way now, then this is what the board can look like after one move.” The following is an example of a rule:

◊code/block/highlighted['racket]{
(--> (any_1
      ...
      [any_2 ... ● ● ○ any_3 ...]
      any_4
      ...)
     (any_1
      ...
      [any_2 ... ○ ○ ● any_3 ...]
      any_4
      ...)
     →)
}

◊margin-note{The code closely resembles the ◊reference['rules-of-the-game]{game specification}.}

The rule above starts with ◊code/inline{-->} to indicate that it is a transformation. Then it states that, if ◊code/inline{● ● ○} exists anywhere on the board, then the peg on the left can jump to the right—over the peg in the middle—resulting in ◊code/inline{○ ○ ●}. The occurrences of ◊code/inline{any_*} are just preserving the rest of the board unaffected. Finally, the rule is given the name ◊code/inline{→}.

The following is the function with all the rules in the game:

◊code/block/highlighted['racket]{
(define move
  (reduction-relation
   peg-solitaire
   #:domain board
   (--> (any_1
         ...
         [any_2 ... ● ● ○ any_3 ...]
         any_4
         ...)
        (any_1
         ...
         [any_2 ... ○ ○ ● any_3 ...]
         any_4
         ...)
        →)
   (--> (any_1
         ...
         [any_2 ... ○ ● ● any_3 ...]
         any_4
         ...)
        (any_1
         ...
         [any_2 ... ● ○ ○ any_3 ...]
         any_4
         ...)
        ←)
   (--> (any_1
         ...
         [any_2 ..._1 ● any_3 ...]
         [any_4 ..._1 ● any_5 ...]
         [any_6 ..._1 ○ any_7 ...]
         any_8
         ...)
        (any_1
         ...
         [any_2 ... ○ any_3 ...]
         [any_4 ... ○ any_5 ...]
         [any_6 ... ● any_7 ...]
         any_8
         ...)
        ↓)
   (--> (any_1
         ...
         [any_2 ..._1 ○ any_3 ...]
         [any_4 ..._1 ● any_5 ...]
         [any_6 ..._1 ● any_7 ...]
         any_8
         ...)
        (any_1
         ...
         [any_2 ... ● any_3 ...]
         [any_4 ... ○ any_5 ...]
         [any_6 ... ○ any_7 ...]
         any_8
         ...)
        ↑)))
}

The function above starts by stating that it works over the language ◊code/inline{peg-solitaire}, more specifically over the ◊code/inline{board}s in that language. Then follow the rules as discussed above. The only construct not explained thus far are the named ellipsis (◊code/inline{..._1}); they are constrained to expand to the same number of elements throughout the rule. This guarantees that the relevant pegs are aligned in the same column.

The function ◊code/inline{move} is ◊emphasis{not} performing regular pattern matching as found in other functional programming languages. It is not following only the first pattern that matches, but all the patterns that match, in parallel:

◊code/block/highlighted['racket]{
> (apply-reduction-relation move (term initial-board))
'(((█ █ ● ● ● █ █)
   (█ █ ● ● ● █ █)
   (● ● ● ● ● ● ●)
   (● ● ● ● ● ● ●)
   (● ● ● ○ ● ● ●)
   (█ █ ● ○ ● █ █)
   (█ █ ● ● ● █ █))
  ((█ █ ● ● ● █ █)
   (█ █ ● ○ ● █ █)
   (● ● ● ○ ● ● ●)
   (● ● ● ● ● ● ●)
   (● ● ● ● ● ● ●)
   (█ █ ● ● ● █ █)
   (█ █ ● ● ● █ █))
  ((█ █ ● ● ● █ █)
   (█ █ ● ● ● █ █)
   (● ● ● ● ● ● ●)
   (● ● ● ● ○ ○ ●)
   (● ● ● ● ● ● ●)
   (█ █ ● ● ● █ █)
   (█ █ ● ● ● █ █))
  ((█ █ ● ● ● █ █)
   (█ █ ● ● ● █ █)
   (● ● ● ● ● ● ●)
   (● ○ ○ ● ● ● ●)
   (● ● ● ● ● ● ●)
   (█ █ ● ● ● █ █)
   (█ █ ● ● ● █ █)))
}

◊margin-note{In accurate mathematical terms, a reduction relation is not a function, but a general relation, because of this non-deterministic behavior. But thinking of them as functions that execute in different universes is a good approximation.}

One way of thinking about ◊code/inline{move} is that it is a function returning multiple values—or, equivalently, a set of values. Another way of thinking about ◊code/inline{move} is that it is a function living in multiple universes. When multiple patterns match the input, functions have to decide which path (or paths) to take. In most programming languages featuring pattern matching, the first pattern that matches takes precedence over the rest, but ◊code/inline{move} explores all of them by creating multiple universes and following one path in each. This model of computation is called ◊technical-term{non-deterministic computation} and ◊initialism{PLT} Redex gives the name ◊technical-term{reduction relations} to these super-powered functions capable of non-deterministic computations.

◊section['game-play]{Game Play}

We can use the visualization tools that come with ◊initialism{PLT} Redex to play Peg Solitaire. These tools are designed for interactive exploration of evaluation rules; one can expand certain paths and backtrack, while seeing the differences highlighted. The following demonstrates game play:

◊code/block/highlighted['racket]{
> (stepper move (term initial-board))
}

◊image["images/game-play.gif"]{A sample game play.}

◊section['winning]{Winning}

Now that we can play Peg Solitaire, a natural question is: can we use what we have to compute a solution to the game? We can use another visualization tool from ◊initialism{PLT} Redex to understand what the search for an answer would look like:

◊code/block/highlighted['racket]{
> (traces move (term initial-board))
}

◊image["images/search-space.gif"]{The search space.}

Starting with the initial board—on the top left—we repeatedly follow every possible move. The result is a graph of boards which we can traverse looking for a board in the winning state, with a single peg left. The path in the graph from the initial board to the winning board is the sequence of moves to win the game.

First, we encode the definition of a winning board:

◊code/block/highlighted['racket]{
(define (winning? board)
  (define pegs-left-on-board
    (count (curry equal? '●) (flatten board)))
  (= pegs-left-on-board 1))
}

◊margin-note{The function ◊code/inline{curry} is performing ◊technical-term{partial application}. The function ◊code/inline{equal?} takes two arguments, so ◊code/inline{curry} is storing the first argument—the symbol ◊code/inline{●}—and yielding a function that takes the second argument for ◊code/inline{equal?}. This function that ◊code/inline{curry} yields is the predicate used for counting.}

This function works by flattening the board—turning the matrix (or list of lists) into a single long list—and counting the number of pegs. Then it checks if this count is equal to one.

Finally, we need a function that traverses the graph. We want not only to determine whether a solution exists, but also to keep track of the path we followed in the graph to reach the solution, which is the sequence of winning moves:

◊margin-note{There is no need to understand every detail of how ◊code/inline{search-for-solution} works. It uses ◊link["https://docs.racket-lang.org/guide/qq.html"]{quasiquoting} to build lists, ◊link["https://docs.racket-lang.org/guide/match.html"]{pattern matching} to destruct them, and other Racket features beyond the scope of the article.}

◊code/block/highlighted['racket]{
(define (search-for-solution board)
  (define (step board-with-move)
    (match-define `(,_ ,board) board-with-move)
    (define next-boards-with-moves
      (apply-reduction-relation/tag-with-names move board))
    (cond
      [(empty? next-boards-with-moves)
       (and (winning? board) `(,board-with-move))]
      [else
       (define rest-of-solution
         (ormap step next-boards-with-moves))
       (and rest-of-solution
            `(,board-with-move ,@rest-of-solution))]))
  (step `("initial" ,board)))
}

The function ◊code/inline{search-for-solution} works by recursion, accumulating the path it has been through. Its most unusual feature is the use of ◊code/inline{ormap}, which guarantees we stop the search after finding the first solution. The following are examples of using ◊code/inline{search-for-solution} on sections of the board:

◊code/block/highlighted['racket]{
> (search-for-solution (term ([● ● ○])))
'(("initial" ((● ● ○))) ("→" ((○ ○ ●))))
> (search-for-solution (term ([● ● ○ ●])))
'(("initial" ((● ● ○ ●))) ("→" ((○ ○ ● ●)))
                          ("←" ((○ ● ○ ○))))
> (search-for-solution (term ([● ● ● ○])))
#f
}

◊margin-note{Returning false when no solutions are available is a common Racket pattern, inherited from its Scheme origins.}

The snippet above demonstrates how ◊code/inline{search-for-solution} finds a solution and returns the whole path to reconstruct it. If the board is unsolvable, then ◊code/inline{search-for-solution} returns ◊technical-term{false} (◊code/inline{#f}).

Finally, we can call ◊code/inline{search-for-solution} on the full board and solve Peg Solitaire:

◊code/block/highlighted['racket]{
> (search-for-solution (term initial-board))
∞
}

Unfortunately, the above did not terminate after running for a whole night, when we interrupted the computation. This goes to show one limitation of ◊initialism{PLT} Redex (and other tools that are declarative and high-level): they are not always the fastest. They are designed for expressiveness, to aid on the design of programming languages, not to brute-force a search in a space containing millions of elements.

◊margin-note{Any tool, when bent enough, will break. It is important to know this limit so we understand what the tool can and cannot do.}

To find an answer within a reasonable time, we would need a ◊technical-term{goal-directed search}. This means we would prune the search space using more of our knowledge on the game. For example, we know that the board is symmetric, so we could prune search paths which are mirror images of paths we already explored. But this would complicate the model, so we will not pursue this venue in this article. Instead, we will leave open the problem of finding a solution for Peg Solitaire using ◊initialism{PLT} Redex.

◊section['other-limitations]{Other Limitations}

◊margin-note{For more on cellular automata, refer to ◊link["https://wolframscience.com/"]{A New Kind of Science}, by Stephen Wolfram.}

Peg Solitaire is similar to simple cellular automata. Like cellular automata, Peg Solitaire is based on a grid of cells that can assume certain states and evolve over time. So, could ◊initialism{PLT} Redex model cellular automata as well? For example, could it model ◊link["https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life"]{Conway’s Game of Life}, one of the most popular kinds of cellular automata?

◊margin-note{Simultaneous update of cells is not the same as non-deterministic computation, which we covered above. While reduction relations explore multiple possibilities for moves in Peg Solitaire, in the Game of Life each move consists of multiple updates to the board.}

Unfortunately, it would not be a straightforward task. Unlike Peg Solitaire, the evolution of the Game of Life does not happen one cell (or peg) at a time. Instead, on every tick of the clock, all the cells on the board are updated simultaneously, in parallel. ◊initialism{PLT} Redex does not support this.

There are two ways to work around this limitation. The first is to break apart the update of the board in multiple steps. The data structures (language) would encode the notion of ◊emphasis{current cell} and updates would occur only to the current cell. Then the neighbor of the current cell would be elected the new current cell. A single step in the evolution of the Game of Life would be complete when the current cell would have swept the whole board. Implementing this is feasible, though it is not as direct as the implementation of Peg Solitaire, which reads similar to the specification of the game.

The second way to implement the Game of Life in ◊initialism{PLT} Redex is to cheat. Languages and functions in ◊initialism{PLT} Redex are Racket programs, so it is possible to escape out to arbitrary Racket code. This is less clean than pattern-matching in ◊initialism{PLT} Redex, as the following example illustrates:

◊code/block/highlighted['racket]{
(define step
  (reduction-relation
   game-of-life
   #:domain board
   (--> board ,(racket-code-goes-here))))
}

The comma in the snippet above means “escape back to Racket, run this arbitrary code, and insert the result here.” At this point, there is little benefit in using ◊initialism{PLT} Redex for this model. But, for other models that mostly fit in ◊initialism{PLT} Redex, it is useful to have the possibility for localized arbitrary extensions.

◊section['conclusion]{Conclusion}

We showed how a language can work as data structure definitions. We used a language and the evaluation mechanisms in ◊initialism{PLT} Redex to implement a game of Peg Solitaire. Then we used the visualization tools that come with ◊initialism{PLT} Redex to play the game.

Along the way, we introduced a model for computation that is unusual in most programming languages: non-deterministic computation. When faced with multiple paths, non-deterministic computations ◊informal{create different universes} and follow them all.

We also used the model to look for a solution to the game. We showed how a brute-force search is a simple way to explore a space of potential solutions. It is enough for small slices of the Peg Solitaire board, but does not scale to solve the full board in a reasonable running time. We introduced the idea of ◊technical-term{goal-directed search}, which would prune the search space and improve the performance. But it would do this at the cost of simplicity, so we did not pursue this venue and left the problem open.

Finally, we discussed ◊initialism{PLT} Redex’s limitations. It cannot be used to directly encode systems of rules like most kinds of cellular automata, in which simultaneous updates need to occur throughout a data structure. We presented ways to work around this limitation, including one that demonstrates how ◊initialism{PLT} Redex is extensible with arbitrary Racket code.

◊section['acknowledgments]{Acknowledgments}

Thank you ◊link["https://cs.jhu.edu/~shyam/"]{P.C. Shyamshankar}, ◊link["http://www.thinkmoore.net/"]{Scott Moore}, ◊link["http://www.allanvital.com/"]{Allan Vital} and ◊link["http://rafaelalmeida.net/"]{Rafael da Silva Almeida} for your feedback on this article.