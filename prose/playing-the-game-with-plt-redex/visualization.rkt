#lang racket
(require redex "terms.rkt" "judgment-forms.rkt" "reduction-relations.rkt")

#;
(stepper ⇨ (term initial-board))
;; Racket 7 or newer
;; See: https://github.com/racket/redex/issues/155
#;
(stepper → (term initial-board))
#;
(traces ⇨ (term initial-board))
#;
(traces → (term initial-board))
