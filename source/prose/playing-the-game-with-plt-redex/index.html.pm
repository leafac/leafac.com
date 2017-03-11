#lang pollen

◊define-meta[title]{Playing the Game with PLT Redex}
◊define-meta[date]{2017-03-10}

◊margin-note{This article assumes prior knowledge on programming in general and some exposure to functional programming in particular—specially immutable data structures and pattern matching. Racket experience is helpful, but not mandatory.}

◊margin-note{◊figure{◊icon[#:illustration #t]{}◊figure/caption{A peg. Alone.}}}

◊new-thought{◊link["https://redex.racket-lang.org/"]{◊acronym{PLT} Redex} is a ◊link["https://racket-lang.org/"]{Racket} library} for semantics engineering. For people trained in programming-language theory, it is a lightweight tool to define languages, operational semantics, type systems and so on. But that is not how we are going to use it in this article. At its core, ◊acronym{PLT} Redex is a functional programming language with sophisticated pattern matching and visualization tools. And we are going to abuse these to play a game of ◊link["https://en.wikipedia.org/wiki/Peg_solitaire"]{Peg Solitaire}.

Why? Mainly because it is amusing to repurpose tools for tasks clearly beyond their intended design. Also, for those new to ◊acronym{PLT} Redex, it might be a gentler introduction, avoiding the Greek letters and the jargon. Along the way, we are going to cover interesting topics including an alternative model of computation—non-deterministic computation—and goal-directed search.

◊section['rules-of-the-game]{Rules of the Game}

◊margin-note{This section explains the rules of Peg Solitaire. If you already know them, ◊reference['data-structures]{skip ahead}.}

◊new-thought{Peg Solitaire} is a 1-player board game. The initial arrangement of the board looks like the following:

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

In figures representing the board, ○ stands for holes and ● for holes containing pegs.

Pegs are allowed to jump over their immediate neighbors on the North, East, South and West—diagonals not included—as long as they land on an empty hole. The neighbor that was jumped over is removed from the board. For example, the following is an allowed move:

◊code/block{
    ● ● ●             ● ● ●
    ● ● ●             ● ● ●
● ● ● ● ● ● ●     ● ● ● ● ● ● ●
● ● ● ○ ● ● ●  ⇒  ● ○ ○ ● ● ● ●
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
● ○ ○ ● ● ● ●  ⇒  ● ● ○ ○ ○ ● ●
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

◊margin-note{◊link/internal["/prose/playing-the-game-with-plt-redex/peg-solitaire.rkt"]{Here} is the full executable code.}

◊new-thought{We need data structures} to represent the pegs and the board. Normally one would use enumerations, lists, records, objects and others, but we are going to use a ◊emphasis{language} as our data structure. ◊acronym{PLT} Redex lets us define a grammar for a language in ◊link["https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form"]{◊acronym{BNF}} form:

◊margin-note{We are using Racket’s support for Unicode identifiers.}

◊code/block/highlighted['racket]{
(define-language peg-solitaire
  (position ::= █ ○ ●)
  (board ::= ([position ...] ...)))
}

The code above defines two data structures. The first, ◊code/inline{position}, represents a position in the board. It can be one of following: ◊code/inline{█} represents an uninitialized position that only serves as padding and is not really part of the board; ◊code/inline{○} represents an empty position; and ◊code/inline{●} represents a position containing a peg.

◊margin-note{In Racket, different kinds of brackets—◊code/inline{()}, ◊code/inline{[]} and ◊code/inline{{}}—mean the same. Which one to use is a matter of readability—given that the kinds of open and close brackets match, of course.}

The second data structure is the ◊code/inline{board}, represented as a matrix of ◊code/inline{position}s, or, more specifically, a list of lists of ◊code/inline{position}s. In ◊acronym{PLT} Redex, the ellipsis (◊code/inline{...}) means “the previous element repeated any number of times.” So ◊code/inline{[position ...]} means a list of ◊code/inline{position}s, and ◊code/inline{([position ...] ...)} means a list of lists of ◊code/inline{position}s.

◊margin-note{
 Even ill-formed boards like the following are possible:

 ◊code/block/highlighted['racket]{
([●])

([● ○ ●]
 [● ○ █ ●])
 }

 But we are not going to consider them.
}

Examples of possible boards are:

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

We can then define the configuration for the initial Peg Solitaire board:

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

◊new-thought{We need to specify} how pegs can to move on the board. We do this by defining a function that encodes the rules of Peg Solitaire; it receives a board as an argument and returns a set of new boards in which each board has a distinct configuration reachable with one move. Each of the rules that compose this function has the form “if the board looks this way now, then this is what the board can look like after one move.” The following is an example of a rule:

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

The function above starts by stating that it works over the language ◊code/inline{peg-solitaire}, more specifically over the ◊code/inline{board}s in that language. Then follows the rules. The only construct not explained thus far are the named ellipsis (◊code/inline{..._1}); they are constrained to expand to the same number of elements throughout the rule. This guarantees that the relevant pegs are aligned in the same column.

The function ◊code/inline{move} is ◊emphasis{not} performing regular pattern matching as found in other functional programming languages. It is not following only the first pattern that matches, but all the patterns that match, in parallel. One way of thinking about this is that ◊code/inline{move} is a function that returns multiple values—or, equivalently, a set of values.

◊margin-note{In accurate mathematical terms, a reduction relation is not a function, but a general relation, because of this non-deterministic behavior. But thinking of them as functions that return multiple values in different universes is a good approximation.}

Another way of thinking about ◊code/inline{move} is as a function that lives in multiple universes. When multiple patterns match the input, functions have to decide which path (or paths) to take. In most languages, the first pattern that matches takes precedence over the rest, but ◊code/inline{move} explores all of them by creating multiple universes and following one path in each. This model of computation is called ◊technical-term{non-deterministic computation} and ◊acronym{PLT} Redex calls this sort of super-powered functions capable of non-deterministic computations ◊technical-term{reduction relations}.

The following shows how ◊code/inline{move} works:

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

◊section['game-play]{Game Play}

◊new-thought{We can use} the visualization tools that come with ◊acronym{PLT} Redex to play Peg Solitaire. The tools are designed for interactive exploration of evaluation rules; they let the user expand certain paths and backtrack, while highlighting the differences. The following demonstrates game play:

◊code/block/highlighted['racket]{
> (stepper move (term initial-board))
}

◊image["game-play.gif"]{A sample game play.}

◊section['winning]{Winning}

◊; TODO: (0) Use “traces” to show search space; (1) Define goal function; (2) Track used rules; (3) Run.

◊section['limitations]{Limitations}

◊margin-note{For more on cellular automata, refer to ◊link["https://wolframscience.com/"]{A New Kind of Science}, by Stephen Wolfram.}

◊new-thought{Peg Solitaire is similar} to a simple cellular automata. It is a grid-based game in which cells can a assume certain states and evolve over time, the same as cellular automata. So, could ◊acronym{PLT} Redex model other automata? For example, could it model ◊link["https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life"]{Conway’s Game of Life}, one of the most popular cellular automata?

◊margin-note{Simultaneous update of cells is not the same as non-deterministic computation, which we explained above. While reduction relations explore multiple possibilities of moves for Peg Solitaire, in the Game of Life each move consists of multiple updates.}

Unfortunately, it would not be a straightforward task. Unlike in Peg Solitaire, the evolution of the Game of Life does not happen one cell (or peg) at a time. Instead, on every tick of the clock, all the cells on the board are updated simultaneously, in parallel. ◊acronym{PLT} Redex does not support this.

There are two ways to work around this limitation. The first is break apart the update of the board in multiple steps. The data structures (language) encode the notion of ◊emphasis{current cell} and updates occur only the current cell. A single step in the evolution of the Game of Life is complete when the current cell has swept the whole board. Though implementing this is not as direct as the implementation of Peg Solitaire, which reads similar to the specification of the game.

The second way to implement the Game of Life in ◊acronym{PLT} Redex is to cheat. Languages and functions in ◊acronym{PLT} Redex are Racket program, so it is possible to escape out and extend reduction relations with arbitrary Racket code. This is less clean than the powerful pattern-matching in ◊acronym{PLT} Redex, as the following example illustrates:

◊code/block/highlighted['racket]{
(define step
  (reduction-relation
   game-of-life
   #:domain board
   (--> board ,(racket-code-goes-here))))
}

The comma in the snippet above means “escape back to Racket, run this arbitrary code, and insert the result here.” At this point, ◊acronym{PLT} Redex is not contributing much, but having this possibility for extension is useful in localized contexts.

◊section['conclusion]{Conclusion}

◊; TODO:

◊; ---------------------------------------------------------------------------------------------------

◊; TODO: Ask for review: people new to Redex “where do you do get lost?”, experienced users “is there any explanation missing?” And typos. Ask Shyam.