#lang racket
(require redex "terms.rkt" "reduction-relations.rkt" "judgment-forms.rkt")

;; > (stepper ⇨ (term initial-board))
;; > (stepper ⇨/judgment-form (term initial-board))

;; > (traces ⇨ (term initial-board))
;; > (traces ⇨/judgment-form (term initial-board))
