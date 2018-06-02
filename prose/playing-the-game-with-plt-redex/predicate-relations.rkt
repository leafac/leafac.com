#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-relation peg-solitaire
  winning-board? ⊆ board
  [(winning-board? ([· ... ○ ... · ...]
                    ...
                    [· ... ○ ... ● ○ ... · ...]
                    [· ... ○ ... · ...]
                    ...))])

(test-equal (judgment-holds (winning-board? example-board-1))
            #f)
(test-equal (judgment-holds (winning-board? example-board-2))
            #f)
(test-equal (judgment-holds (winning-board? initial-board))
            #f)
(test-equal (judgment-holds (winning-board? example-winning-board))
            #t)
