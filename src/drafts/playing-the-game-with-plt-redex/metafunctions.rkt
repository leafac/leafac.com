#lang racket
(require redex "terms.rkt" "languages.rkt")

(define-metafunction peg-solitaire
  invert/position : position -> position
  [(invert/position peg) ○]
  [(invert/position space) ●]
  [(invert/position padding) padding])

(test-equal (term (invert/position ●))
            (term ○))
(test-equal (term (invert/position ○))
            (term ●))
(test-equal (term (invert/position ·))
            (term ·))

(define-metafunction peg-solitaire
  invert/board : board -> board
  [(invert/board ([position ...] ...))
   ([(invert/position position) ...] ...)])

(test-equal (term (invert/board initial-board))
            (term ((· · ○ ○ ○ · ·)
                   (· · ○ ○ ○ · ·)
                   (○ ○ ○ ○ ○ ○ ○)
                   (○ ○ ○ ● ○ ○ ○)
                   (○ ○ ○ ○ ○ ○ ○)
                   (· · ○ ○ ○ · ·)
                   (· · ○ ○ ○ · ·))))
