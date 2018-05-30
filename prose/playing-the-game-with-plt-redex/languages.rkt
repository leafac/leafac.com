#lang racket
(require redex "terms.rkt")
(provide peg-solitaire)

(define-language peg-solitaire
  [board    ::= (row ...)]
  [row      ::= [position ...]]
  [position ::= peg space padding]
  [peg      ::= ●]
  [space    ::= ○]
  [padding  ::= ·])

(test-equal (redex-match? peg-solitaire peg
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire position
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (peg ● ○)
                          (term         (●   ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (position ● ○)
                          (term         (●        ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (position position ○)
                          (term         (●        ●        ○)))
            #t)
(test-equal (redex-match? peg-solitaire (position position position)
                          ;                                ≠
                          (term         (●        ●        ○)))
            #f)
(test-equal (redex-match? peg-solitaire (position_1 position_2 position_3)
                          (term         (●          ●          ○)))
            #t)

(test-equal (redex-match? peg-solitaire board (term example-board-1))
            #t)
(test-equal (redex-match? peg-solitaire board (term example-board-2))
            #t)
(test-equal (redex-match? peg-solitaire board (term initial-board))
            #t)

(test-equal (redex-match? peg-solitaire board (term ([● ○]
                                                     [●])))
            #t)
