#lang racket
(require redex)

(term 0)
(term "a")
(term a)
(term ●)
(term ○)
(term (● ● ○))

(define peg (term ●))
peg

(define-term hole ○)
(term hole)

#;hole ; syntax error
(term peg) ; not a syntax error

(term (1 2 ,(+ 1 2)))
(term (● ,peg hole))
(term (● ,peg ,(term hole)))

(define-term initial-board
  ([· · ● ● ● · ·]
   [· · ● ● ● · ·]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [· · ● ● ● · ·]
   [· · ● ● ● · ·]))
(term initial-board)
