#lang pollen

◊define-meta[title]{Playing the Game with PLT Redex}
◊define-meta[date]{2017-03-10}

◊new-thought{◊link["https://redex.racket-lang.org/"]{◊acronym{PLT} Redex} is a ◊link["https://racket-lang.org/"]{Racket} library} for semantics engineering. For people trained in programming-language theory, it is a lightweight tool to define languages, operational semantics, type systems and so on. But that is not how we are going to use it in this article. At its core, ◊acronym{PLT} Redex is a functional programming language with sophisticated pattern matching and visualization tools. And we are going to abuse these to play a game of ◊link["https://en.wikipedia.org/wiki/Peg_solitaire"]{Peg Solitaire}.

Why? Mainly because it is amusing to repurpose tools for tasks clearly beyond their intended design. Also, for those new to ◊acronym{PLT} Redex, it might be a gentler introduction, avoiding the Greek letters and the jargon. Along the way, we are going to cover interesting topics including an alternative model of computation—non-deterministic computation—and goal-directed search.

◊paragraph-separation[]

◊margin-note{◊link/internal["/prose/playing-the-game-with-plt-redex/peg-solitaire.rkt"]{Here} is the full executable code.}

◊new-thought{First, we need data structures} to represent the pegs and the board. Normally one would use lists, structs, objects and others, but we are going to use a ◊emphasis{language} as our data structure. ◊acronym{PLT} Redex lets us define a grammar for a language in ◊link["https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form"]{◊acronym{BNF}} form:

◊margin-note{We are using Racket’s support for Unicode identifiers.}

◊code/block/highlighted['racket]{
(define-language peg-solitaire
  (position ::= █ ○ ●)
  (board ::= ([position ...] ...)))
}

The code above defines two data structures. The first, ◊code/inline{position}, represents a position in the board. It can be one of following: ◊code/inline{█} represents an uninitialized position that only serves as padding and is not really part of the board; ◊code/inline{○} represents an empty position; and ◊code/inline{●} represents a position containing a peg.

◊margin-note{In Racket, different kinds of brackets—◊code/inline{()}, ◊code/inline{[]} and ◊code/inline{{}}—mean the same. Which one to use is a matter of readability—given that the kinds of open and close brackets match, of course.}

The second data structure is the ◊code/inline{board}, represented as a matrix of ◊code/inline{position}s, or, more specifically, a list of lists of ◊code/inline{position}s. In ◊acronym{PLT} Redex, the ellipsis (◊code/inline{...}) means “the previous element repeated any number of times.” So ◊code/inline{[position ...]} means a list of ◊code/inline{position}s, and ◊code/inline{([position ...] ...)} means a list of lists of ◊code/inline{position}s.

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
  ([█ █ ● ● ● █ █]
   [█ █ ● ● ● █ █]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [█ █ ● ● ● █ █]
   [█ █ ● ● ● █ █]))
}

◊paragraph-separation[]

◊new-thought{Next, we need} to specify how pegs are allowed to move on the board. We can define a function that encodes the rules of Peg Solitaire; it receives a board as an argument and returns a set of new boards in which each board has a distinct configuration reachable with one move. Each of the rules that compose this function has the form “if the board looks this way now, then this is what the board can look like after one move.” The following is an example of a rule:

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

The function ◊code/inline{move} is ◊emphasis{not} performing regular pattern matching as found in other functional programming languages. It is not following only the first pattern that matches, but all the patterns that match, in parallel. One way of thinking about this is that ◊code/inline{move} is a function that returns multiple values—or, equivalently, a set of values. Another way is to think of ◊code/inline{move} as performing a ◊technical-term{non-deterministic computation}. This sort of super-powered function is what ◊acronym{PLT} Redex calls a ◊technical-term{reduction relation}.

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

◊paragraph-separation[]

◊new-thought{Now we can use} the visualization tools that come with ◊acronym{PLT} Redex to play Peg Solitaire. The tools are designed to allow for interactive exploration of evaluation rules, they let the user expand certain paths and backtrack, while highlighting the differences. The following illustrates game play:


◊code/block/highlighted['racket]{
> (stepper move (term initial-board))
}

◊image["game-play.gif"]{A sample game play.}

◊; TODO: Write in sections.
◊; TODO: Pre-requisites.
◊; TODO: Illustration of the board.
◊; TODO: Explain the rules.

◊; TODO: Find the solution. (0) Use “traces” to show search space; (1) Define goal function; (2) Track used rules; (3) Run.
◊; IF THE ABOVE IS IMPOSSIBLE REVIEW INTRODUCTION!

◊; TODO: I don’t think it would be able to easily model celullar automata—for example, the Game of Life—because steps can’t happen in parallel. Two solutions: (1) encode “current-cell” in the language; (2) escape to Racket.

◊; TODO: Ask for review: people new to Redex “where do you do get lost?”, experienced users “is there any explanation missing?” And typos.