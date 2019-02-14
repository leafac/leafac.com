#lang racket
(require redex "terms.rkt" "languages.rkt"
         "reduction-relations.rkt" "predicate-relations.rkt"
         "judgment-forms.rkt")

;; ---------------------------------------------------------------------------------------------------
;; DEBUGGING

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

;; ---------------------------------------------------------------------------------------------------
;; PERFORMANCE

(define (winning-boards start-board)
  (filter (λ (board) (judgment-holds (winning-board? ,board)))
          (apply-reduction-relation* ⇨ start-board)))

(test-equal (winning-boards (term ([● ● ○ ●])))
            '(([○ ● ○ ○])))

#;
(winning-boards (term initial-board))

;; ---------------------------------------------------------------------------------------------------
;; ADVANCED PATTERN MATCHING

(define-relation peg-solitaire
  not-peg? ⊆ position
  [(not-peg? position)
   ,(not (redex-match? peg-solitaire peg (term position)))])

(test-equal (term (not-peg? ●))
            #f)
(test-equal (term (not-peg? ○))
            #t)
(test-equal (term (not-peg? ·))
            #t)
