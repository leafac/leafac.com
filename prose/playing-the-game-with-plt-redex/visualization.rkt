#lang racket
(require redex "terms.rkt" "languages.rkt"
         "judgment-forms.rkt" "reduction-relations.rkt")

(stepper ⇨ (term initial-board))
