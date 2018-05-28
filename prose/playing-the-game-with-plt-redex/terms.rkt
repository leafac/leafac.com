#lang racket
(require redex)
(provide (all-defined-out))

(test-equal (term 0)
            0)
(test-equal (term "a")
            "a")
(test-equal (term a)
            'a)
(test-equal (term ●)
            '●)
(test-equal (term ○)
            '○)
(test-equal (term (● ● ○))
            '(● ● ○))

(define peg (term ●))
(test-equal peg
            '●)

(define-term hole ○)
(test-equal (term hole)
            '○)

; > hole
; hole: illegal use of syntax in: hole
(test-equal (term peg)
            'peg)

(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
(test-equal (term (● ,peg hole))
            '(● ● ○))
(test-equal (term (● ,peg ,(term hole)))
            '(● ● ○))

(define-term example-board-1
  ([· · ● ● ● · ·]
   [· · ● ● ○ · ·]
   [● ○ ● ○ ● ● ●]
   [● ● ● ○ ○ ○ ●]
   [● ○ ● ● ● ● ●]
   [· · ● ○ ● · ·]
   [· · ● ● ● · ·]))

(define-term example-board-2
  ([· · ● ○ ● · ·]
   [· · ● ● ○ · ·]
   [● ○ ● ○ ● ● ●]
   [● ● ● ○ ○ ○ ●]
   [● ○ ● ● ○ ● ●]
   [· · ● ○ ● · ·]
   [· · ○ ● ● · ·]))

(define-term initial-board
  ([· · ● ● ● · ·]
   [· · ● ● ● · ·]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [· · ● ● ● · ·]
   [· · ● ● ● · ·]))
