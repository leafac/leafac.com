#lang racket
(require redex)

(define-language peg-solitaire
  (position ::= █ ○ ●)
  (board ::= ([position ...] ...)))

(module+ test
  (test-equal (redex-match? peg-solitaire board (term ([█])))
              #t)
  (test-equal (redex-match? peg-solitaire board (term ([█ ●]
                                                       [○ █])))
              #t)
  (test-equal (redex-match? peg-solitaire board (term ([█ █]
                                                       [█ ● ●])))
              #t))

(define-term initial-board
  ([█ █ █ ● ● ● █ █ █]
   [█ █ █ ● ● ● █ █ █]
   [● ● ● ● ● ● ● ● ●]
   [● ● ● ● ○ ● ● ● ●]
   [● ● ● ● ● ● ● ● ●]
   [█ █ █ ● ● ● █ █ █]
   [█ █ █ ● ● ● █ █ █]
   [█ █ █ ● ● ● █ █ █]))

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

#;
(apply-reduction-relation move (term initial-board))

#;
(traces move (term initial-board))

#;
(stepper move (term initial-board))