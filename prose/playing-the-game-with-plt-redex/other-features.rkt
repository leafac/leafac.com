#lang racket
(require redex "terms.rkt" "languages.rkt"
         "judgment-forms.rkt" "reduction-relations.rkt")

;; ---------------------------------------------------------------------------------------------------

(define-term a-peg ●)
(test-equal (term a-peg)
            '●)

(define a-space (term ○))
(test-equal a-space
            '○)

; > a-peg
; space: illegal use of syntax in: space
(test-equal (term a-space)
            'a-space)

(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
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

(define-extended-language Peg-Solitaire peg-solitaire
  [Board ::= (row ... hole row ...)])

(define
  ⇨/hole
  (extend-reduction-relation
   ⇨
   Peg-Solitaire
   #:domain board

   (--> (in-hole Board [position_1 ... ● ● ○ position_2 ...])
        (in-hole Board [position_1 ... ○ ○ ● position_2 ...])
        "→")))

(test-equal (apply-reduction-relation ⇨/hole (term initial-board))
            '(([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ○ ○ ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ○ ● ● ●]
               [· · ● ○ ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ○ ● · ·]
               [● ● ● ○ ● ● ●]
               [● ● ● ● ● ● ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])

              ([· · ● ● ● · ·]
               [· · ● ● ● · ·]
               [● ● ● ● ● ● ●]
               [● ● ● ● ○ ○ ●]
               [● ● ● ● ● ● ●]
               [· · ● ● ● · ·]
               [· · ● ● ● · ·])))

;; ---------------------------------------------------------------------------------------------------

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

(render-judgment-form →*)

;; Prepare image for article:
;; (render-judgment-form →* "judgment-form.pdf")
;; $ pdfcrop judgment-form.pdf judgment-form--cropped.pdf
;; $ pdf2svg judgment-form--cropped.pdf judgment-form.svg
