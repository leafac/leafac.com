#lang racket
(require redex "terms.rkt" "languages.rkt"
         "reduction-relations.rkt" "judgment-forms.rkt")

;; ---------------------------------------------------------------------------------------------------
;; CONDITIONS

(define-relation peg-solitaire
  equal-length-rows? ⊆ board
  [(equal-length-rows? board)
   (side-condition
    (andmap (λ (row) (equal? (length row)
                             (length (first (term board)))))
            (term board)))])

(test-equal (term (equal-length-rows? initial-board))
            #t)
(test-equal (term (equal-length-rows? ([●]
                                       [●])))
            #t)
(test-equal (term (equal-length-rows? ([●]
                                       [● ●])))
            #f)

;; ---------------------------------------------------------------------------------------------------
;; UNQUOTING

(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))

(define-term a-peg ●)
(test-equal (term a-peg)
            '●)

(define a-space (term ○))
(test-equal a-space
            '○)
(test-equal (term ,a-space)
            '○)

; > a-peg
; a-peg: illegal use of syntax in: a-peg
(test-equal (term a-space)
            'a-space)

(test-equal (term (● a-peg ,a-space))
            '(● ● ○))
(test-equal (term (● ,(term a-peg) ,a-space))
            '(● ● ○))

(define-metafunction peg-solitaire
  count-● : board -> integer
  [(count-● ([position ...] ...))
   ,(count (λ (position) (equal? position (term ●)))
           (term (position ... ...)))])

(test-equal (term (count-● initial-board)) 32)

;; ---------------------------------------------------------------------------------------------------
;; EXTENSIONS AND HOLES

(define-extended-language Peg-Solitaire peg-solitaire
  [Board ::= (row ... hole row ...)])

(test-equal (redex-match? Peg-Solitaire (in-hole Board row)
                          (term ([●]
                                 [○]
                                 [●])))
            #t)
; > (redex-match Peg-Solitaire (in-hole Board row)
;                (term ([●]
;                       [○]
;                       [●])))
; (list
;  (match (list (bind 'Board '((●) (○) hole)) (bind 'row '(●))))
;  (match (list (bind 'Board '((●) hole (●))) (bind 'row '(○))))
;  (match (list (bind 'Board '(hole (○) (●))) (bind 'row '(●)))))

(define
  ⇨/hole
  (extend-reduction-relation
   ⇨
   Peg-Solitaire
   #:domain board

   (--> (in-hole Board [position_1 ... ● ● ○ position_2 ...])
        (in-hole Board [position_1 ... ○ ○ ● position_2 ...])
        "→")))

(test-equal (list->set (apply-reduction-relation ⇨/hole
                                                 (term initial-board)))
            (set
             (term
              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ○ ○ ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·]))

             (term
              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ○ ○ ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·]))

             (term
              ([· · ● ● ● · ·]
               [· · ● ○ ● · ·]
               [● ● ● ○ ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·]))

             (term
              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ○ ● ● ●]
               [· · ● ○ ● · ·]
               [· · ● ● ● · ·]))))

;; ---------------------------------------------------------------------------------------------------
;; CHECKING

(redex-check
 peg-solitaire board
 (for/and ([board′ (in-list (apply-reduction-relation ⇨ (term board)))])
   (> (term (count-● board)) (term (count-● ,board′)))))

#;
(redex-check
 peg-solitaire board
 (for/and ([board′ (in-list (apply-reduction-relation ⇨ (term board)))])
   (< (term (count-● board)) (term (count-● ,board′)))))

;; ---------------------------------------------------------------------------------------------------

(render-judgment-form ⇨/judgment-form)

;; Prepare image for article:
;; (render-judgment-form ⇨/judgment-form "judgment-form.pdf")
;; $ pdfcrop judgment-form.pdf judgment-form--cropped.pdf
;; $ pdf2svg judgment-form--cropped.pdf judgment-form.svg
