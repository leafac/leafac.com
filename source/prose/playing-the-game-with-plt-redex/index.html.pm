#lang pollen

◊define-meta[title]{Playing the Game with PLT Redex}
◊define-meta[date]{2017-03-10}

◊new-thought{◊link["https://redex.racket-lang.org/"]{◊acronym{PLT} Redex} is a ◊link["https://racket-lang.org/"]{Racket} library} for semantics engineering. For people trained in programming-language theory, it is a lightweight tool to define languages, operational semantics, type systems and so on. But that is not how we are going to use it in this article. At its core, ◊acronym{PLT} Redex is a functional programming language with sophisticated pattern matching and visualization tools. And we are going to abuse these to play a game of ◊link["https://en.wikipedia.org/wiki/Peg_solitaire"]{Peg Solitaire}.

◊margin-note{◊link/internal["/prose/playing-the-game-with-plt-redex/peg-solitaire.rkt"]{Here} is the full executable code.}

◊paragraph-separation[]

◊new-thought{First, we need data structures} to represent the pegs and the board. We can use a ◊emphasis{language} for this purpose. ◊acronym{PLT} Redex lets us define a grammar for a language in ◊link["https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form"]{◊acronym{BNF}} form:

◊margin-note{We are using Racket’s support for Unicode identifiers.}

◊code/block/highlighted['racket]{
(define-language peg-solitaire
  (position ::= █ ○ ●)
  (board ::= ([position ...] ...)))
}

The code above defines two data structures. The first, ◊code/inline{position}, represents a position in the board. It can be in one of three states: ◊code/inline{█} means uninitialized, a position that only serves as padding and is not really part of the board; ◊code/inline{○} means the position is empty; and ◊code/inline{●} means there is a peg in that position.

◊margin-note{In Racket, different kinds of brackets—◊code/inline{()}, ◊code/inline{[]} and ◊code/inline{{}}—mean the same. Which one to use is a matter of readability.}

The second data structure is the ◊code/inline{board}, represented as a matrix of positions, or, more specifically, a list of lists of ◊code/inline{position}s. In ◊acronym{PLT} Redex, the ellipsis (◊code/inline{...}) means “the previous element repeated any number of times”. So ◊code/inline{[position ...]} means a list of ◊code/inline{position}s, and ◊code/inline{([position ...] ...)} means a list of lists of ◊code/inline{position}s.

Examples of possible boards are:

◊code/block/highlighted['racket]{
([█])

([█ ●]
 [○ █])

([█ █]
 [█ ● ●])
}

But we are not interested in boards of ◊emphasis{any} form. Peg Solitaire’s boards start in a specific configuration:

◊code/block/highlighted['racket]{
(define-term initial-board
  ([█ █ █ ● ● ● █ █ █]
   [█ █ █ ● ● ● █ █ █]
   [● ● ● ● ● ● ● ● ●]
   [● ● ● ● ○ ● ● ● ●]
   [● ● ● ● ● ● ● ● ●]
   [█ █ █ ● ● ● █ █ █]
   [█ █ █ ● ● ● █ █ █]
   [█ █ █ ● ● ● █ █ █]))
}

◊paragraph-separation[]

◊new-thought{Next, we need} to specify how pegs are allowed to move on the board. We can define a function that encodes the rules of Peg Solitaire; it receives a board as an argument and returns the board configurations it is possible to reach with one move. This function includes each rule in forms that reads as “if the board looks this way now, then this is what the board should look like after one move:”

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

◊margin-note{The code closely resembles the ◊link["https://en.wikipedia.org/wiki/Peg_solitaire#Play"]{game specification}.}

This rule (called ◊code/inline{→}) is saying that, if anywhere on the board there exists the sequence ◊code/inline{● ● ○}, then one possible move is for the peg on the left to jump to the right—over the peg in the middle—transforming the sequencing into ◊code/inline{○ ○ ●}.

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

The function ◊code/inline{move} is ◊emphasis{not} performing regular pattern matching. It is not choosing the first pattern that matches, but simultaneously following all the patterns that match in parallel. One way of thinking about this is that ◊code/inline{move} is a function that returns multiple values—or, equivalently, a list of values. Another way is to think of ◊code/inline{move} as performing a non-deterministic computation. This sort of super-powered function is what ◊acronym{PLT} Redex calls a ◊technical-term{reduction relation}.

◊;- I don't think it would be able to easily model the Game of Life, because, in that game, steps happen in parallel. It does allow us to escape to Racket, though.
◊;- GOAL DIRECTED SEARCH

◊; TODO: Add syntax highlighting.