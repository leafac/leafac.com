#lang racket
(require redex)
(provide example-board-1 example-board-2 initial-board example-winning-board)

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

(define-term space ○)
(test-equal (term space)
            '○)

; > space
; space: illegal use of syntax in: space
(test-equal (term peg)
            'peg)

(test-equal (term (1 2 ,(+ 1 2)))
            '(1 2 3))
(test-equal (term (● ,peg space))
            '(● ● ○))
(test-equal (term (● ,peg ,(term space)))
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

(define-term example-winning-board
  ([· · ○ ○ ○ · ·]
   [· · ○ ○ ○ · ·]
   [○ ○ ○ ○ ○ ○ ○]
   [○ ○ ○ ● ○ ○ ○]
   [○ ○ ○ ○ ○ ○ ○]
   [· · ○ ○ ○ · ·]
   [· · ○ ○ ○ · ·]))
