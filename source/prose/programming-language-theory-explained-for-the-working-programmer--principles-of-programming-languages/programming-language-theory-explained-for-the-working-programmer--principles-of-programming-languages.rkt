#lang racket

(define ___ "omitted")

;; Starting Point

(module+ original
  (define (sum-up-to number)
    (if (zero? number)
        0
        (+ number (sum-up-to (sub1 number)))))

  (sum-up-to 5) ;; => 15
  )

;; ---------------------------------------------------------------------------------------------------

;; Numbers

(module+ strings
  (define (zero? number)
    (equal? "0" number))

  (define (sub1 number)
    ___)

  (define (+ operand-left operand-right)
    ___)

  (define (sum-up-to number)
    (if (zero? number)
        "0"
        (+ number (sum-up-to (sub1 number)))))

  (sum-up-to "5")
  )

(module+ string-length
  (define (zero? number)
    (equal? "" number))

  (define (sub1 number)
    ___)

  (define (+ operand-left operand-right)
    (string-append operand-left operand-right))

  (define (sum-up-to number)
    (if (zero? number)
        ""
        (+ number (sum-up-to (sub1 number)))))

  (sum-up-to "☺☺☺☺☺")
  )

(module+ list-length
  (define (zero? number)
    (equal? '() number))

  (define (sub1 number)
    (if (zero? number)
        '()
        (rest number)))

  (define (+ operand-left operand-right)
    (append operand-left operand-right))

  (define (sum-up-to number)
    (if (zero? number)
        '()
        (+ number (sum-up-to (sub1 number)))))

  (sum-up-to '(☺ ☺ ☺ ☺ ☺))
  ;; => '(☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺)
  )