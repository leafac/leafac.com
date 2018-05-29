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

(test-equal (redex-match? peg-solitaire board (term example-board-1))
            #t)
(test-equal (redex-match? peg-solitaire board (term example-board-2))
            #t)
(test-equal (redex-match? peg-solitaire board (term initial-board))
            #t)
