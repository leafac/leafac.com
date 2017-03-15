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

(module+ numbers
  (define (zero function argument)
    argument)

  (define (one function argument)
    (function argument))

  (define (five function argument)
    (function
     (function
      (function
       (function
        (function argument))))))
  )

(module+ pretty-print
  (define (pretty-print/number number)
    (number add1 0))

  (define (zero function argument)
    argument)

  (define (one function argument)
    (function argument))

  (define (five function argument)
    (function
     (function
      (function
       (function
        (function argument))))))

  (pretty-print/number zero)
  (pretty-print/number one)
  (pretty-print/number five)
  )

(module+ initial-zero?
  (define (zero? number)
    (define (always-false ignored-argument)
      #f)
    (number always-false #t))

  (define (zero function argument)
    argument)

  (define (one function argument)
    (function argument))

  (define (five function argument)
    (function
     (function
      (function
       (function
        (function argument))))))

  (zero? zero)
  (zero? one)
  (zero? five)
  )

(module+ +
  (define (+ number-left number-right)
    (define (result function argument)
      (number-left function (number-right function argument)))
    result)

  (define (zero function argument)
    argument)

  (define (one function argument)
    (function argument))

  (define (five function argument)
    (function
     (function
      (function
       (function
        (function argument))))))

  (define (pretty-print/number number)
    (number add1 0))

  (pretty-print/number (+ five five))
  )

(module+ sub1
  (define (sub1 number)
    (define initial-pair `(,zero . ,zero))

    (define (slide-pair pair)
      (match-define `(,previous . ,current) pair)
      `(,current . ,(+ current one)))

    (define final-pair
      (number slide-pair initial-pair))

    (match-define `(,result . ,result+1) final-pair)

    result)

  (define (+ number-left number-right)
    (define (result function argument)
      (number-left function (number-right function argument)))
    result)

  (define (zero function argument)
    argument)

  (define (one function argument)
    (function argument))

  (define (five function argument)
    (function
     (function
      (function
       (function
        (function argument))))))

  (define (pretty-print/number number)
    (number add1 0))

  (pretty-print/number (sub1 five))
  )