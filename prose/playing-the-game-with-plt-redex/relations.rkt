#lang racket
(require redex "terms.rkt" "languages.rkt")
(provide winning-board?)

(define-metafunction peg-solitaire
  winning-board?/metafunction : board -> boolean
  [(winning-board?/metafunction ([· ... ○ ... · ...]
                                 ...
                                 [· ... ○ ... ● ○ ... · ...]
                                 [· ... ○ ... · ...]
                                 ...))
   #t]
  [(winning-board?/metafunction _) #f])

(test-equal (term (winning-board?/metafunction example-board-1))
            #f)
(test-equal (term (winning-board?/metafunction example-board-2))
            #f)
(test-equal (term (winning-board?/metafunction initial-board))
            #f)
(test-equal (term (winning-board?/metafunction example-winning-board))
            #t)

(define-relation peg-solitaire
  winning-board? ⊆ board
  [(winning-board? ([· ... ○ ... · ...]
                    ...
                    [· ... ○ ... ● ○ ... · ...]
                    [· ... ○ ... · ...]
                    ...))])

(test-equal (term (winning-board? example-board-1))
            #f)
(test-equal (term (winning-board? example-board-2))
            #f)
(test-equal (term (winning-board? initial-board))
            #f)
(test-equal (term (winning-board? example-winning-board))
            #t)
