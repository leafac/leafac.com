#lang racket
(require redex "terms.rkt")

(define-language peg-solitaire)

(test-equal (redex-match? peg-solitaire ●
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (● ● ○)
                          (term         (● ● ○)))
            #t)

(test-equal (redex-match? peg-solitaire _
                          (term         ●))
            #t)
(test-equal (redex-match? peg-solitaire (_ ● ○)
                          (term         (● ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (_ _ ○)
                          (term         (● ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire (_ _ _)
                          (term         (● ● ○)))
            #t)
(test-equal (redex-match? peg-solitaire _
                          (term         (● ● ○)))
            #t)

(test-equal (redex-match? peg-solitaire (any ● ○)
                          (term         (●   ● ○)))
            #t)

; > (redex-match peg-solitaire (_ ● ○)
;                (term         (● ● ○)))
; (list (match '()))
;
; > (redex-match peg-solitaire (any ● ○)
;                (term         (●   ● ○)))
; (list (match (list (bind 'any '●))))

(test-equal (redex-match? peg-solitaire (any any ○)
                          (term         (●   ●   ○)))
            #t)
(test-equal (redex-match? peg-solitaire (any ●   any)
                          ;                      ≠
                          (term         (●   ●   ○)))
            #f)

(test-equal (redex-match? peg-solitaire (any_1 any_2 any_3)
                          (term         (●     ●     ○)))
            #t)
; > (redex-match peg-solitaire (any_1 any_2 any_3)
;                (term         (●     ●     ○)))
; (list (match (list (bind 'any_1 '●) (bind 'any_2 '●) (bind 'any_3 '○))))

(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          (term         (●     ●     ○)))
            #t)
; > (redex-match peg-solitaire (any_1 any_1 any_2)
;                (term         (●     ●     ○)))
; (list (match (list (bind 'any_1 '●) (bind 'any_2 '○))))

(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          (term         (●     ●     ●)))
            #t)
; > (redex-match peg-solitaire (any_1 any_1 any_2)
;                (term         (●     ●     ●)))
; (list (match (list (bind 'any_1 '●) (bind 'any_2 '●))))

(test-equal (redex-match? peg-solitaire (any_1 any_1 any_2)
                          ;                    ≠
                          (term         (●     ○     ○)))
            #f)

(test-equal (redex-match? peg-solitaire (any ...)
                          (term         (● ● ○)))
            #t)
; > (redex-match peg-solitaire (any ...)
;                (term         (● ● ○)))
; (list (match (list (bind 'any '(● ● ○)))))

(test-equal (redex-match? peg-solitaire (any_1 ... any_2 ...)
                          (term         (● ● ○)))
            #t)
; > (redex-match peg-solitaire (any_1 ... any_2 ...)
;                (term         (● ● ○)))
; (list
;  (match (list (bind 'any_1 '()) (bind 'any_2 '(● ● ○))))
;  (match (list (bind 'any_1 '(●)) (bind 'any_2 '(● ○))))
;  (match (list (bind 'any_1 '(● ●)) (bind 'any_2 '(○))))
;  (match (list (bind 'any_1 '(● ● ○)) (bind 'any_2 '()))))


(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._n)
                          (term         (● ●         ○ ●)))
            #t)
; > (redex-match peg-solitaire (any_1 ..._n any_2 ..._n)
;                (term         (● ●         ○ ●)))
; (list (match (list (bind 'any_1 '(● ●)) (bind 'any_2 '(○ ●)))))
(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._n)
                          ;                ≠
                          (term         (● ● ○)))
            #f)

(test-equal (redex-match? peg-solitaire (any_1 ..._n any_2 ..._m)
                          (term         (● ● ○)))
            #t)

(test-equal (redex-match? peg-solitaire
                          ([· ... ● ... ○ ... ● ... · ...]
                           ...)
                          (term initial-board))
            #t)
