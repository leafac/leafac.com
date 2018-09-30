#lang racket
(require redex "terms.rkt" "languages.rkt"
         "reduction-relations.rkt" "predicate-relations.rkt"
         "judgment-forms.rkt")

(test-equal
 (redex-match? peg-solitaire board (term ([· ● ● ● ·]
                                          [· ● * ● ·])))
 #f)
(test-equal
 (redex-match? peg-solitaire (row ...) (term ([· ● ● ● ·]
                                              [· ● * ● ·])))
 #f)
(test-equal
 (redex-match? peg-solitaire row (term [· ● ● ● ·]))
 #t)
(test-equal
 (redex-match? peg-solitaire row (term [· ● * ● ·]))
 #f)
(test-equal
 (redex-match? peg-solitaire position (term *))
 #f)

(define-judgment-form peg-solitaire
  #:mode (⇨*′ I O)
  #:contract (⇨*′ board board)

  [(⇨/judgment-form board_1 board_2)
   --------------------------------- "Base"
   (⇨*′ board_1 board_2)]

  [(⇨/judgment-form            board_1 board_2)
   (side-condition ,(displayln (term board_2)))
   (⇨*′ board_2 board_3)
   -------------------------------------------- "Transitivity"
   (⇨*′ board_1 board_3)])

; > (judgment-holds (⇨*′ ([● ● ○ ●]) ([○ ● ○ ○])))
; ((○ ○ ● ●))
; ((○ ● ○ ○))
;; ---------------------------------------------------------------------------------------------------

(define (winning-boards start-board)
  (filter (λ (board) (judgment-holds (winning-board? ,board)))
          (apply-reduction-relation* ⇨ start-board)))

(test-equal (winning-boards (term ([● ● ○ ●])))
            '(([○ ● ○ ○])))

#;
(winning-boards (term initial-board))

;; ---------------------------------------------------------------------------------------------------

(define-relation peg-solitaire
  not-peg? ⊆ position
  [(not-peg? position) ,(not (redex-match? peg-solitaire peg (term position)))])

(test-equal (term (not-peg? ●))
            #f)
(test-equal (term (not-peg? ○))
            #t)
(test-equal (term (not-peg? ·))
            #t)
