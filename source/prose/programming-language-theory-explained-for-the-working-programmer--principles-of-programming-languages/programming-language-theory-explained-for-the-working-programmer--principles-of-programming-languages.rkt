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

(module+ numbers/pretty-print
  (define (pretty-print number)
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

  (pretty-print zero)
  (pretty-print one)
  (pretty-print five)
  )

(module+ numbers/sum-up-to
  (define (sum-up-to number)
    (if (zero? number)
        zero
        (+ number (sum-up-to (sub1 number)))))

  (define (zero function argument)
    argument)
  )

(module+ numbers/zero?
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

(module+ numbers/+
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

  (define (pretty-print number)
    (number add1 0))

  (pretty-print (+ five five))
  )

(module+ numbers/sub1
  (struct pair (left right))

  (define (sub1 number)
    (define initial-pair (pair zero zero))

    (define (slide-pair current-pair)
      (define current-number (pair-right current-pair))
      (pair current-number (+ current-number one)))

    (define final-pair
      (number slide-pair initial-pair))

    (pair-left final-pair))

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

  (define (pretty-print number)
    (number add1 0))

  (pretty-print (sub1 five))
  )

(module+ booleans
  (define (true first second)
    first)

  (define (false first second)
    second)
  )

(module+ booleans/zero?
  (define (zero? number)
    (define (always-false ignored-argument)
      false)
    (number always-false true))

  (define (true first second)
    first)

  (define (false first second)
    second)
  )

(module+ booleans/extract-conditional-branches
  (define (sum-up-to number)
    (define then-branch
      zero)

    (define else-branch
      (+ number (sum-up-to (sub1 number))))

    (if (zero? number) then-branch else-branch))

  (define (zero function argument)
    argument)
  )

(module+ booleans/wrap-conditional-branches
  (define (sum-up-to number)
    (define (then-branch)
      zero)

    (define (else-branch)
      (+ number (sum-up-to (sub1 number))))

    (define branch-to-take
      (if (zero? number) then-branch else-branch))

    (branch-to-take))

  (define (zero function argument)
    argument)
  )

(module+ booleans/remove-if
  (define (sum-up-to number)
    (define (then-branch)
      zero)

    (define (else-branch)
      (+ number (sum-up-to (sub1 number))))

    (define branch-to-take
      ((zero? number) then-branch else-branch))

    (branch-to-take))

  (define (zero? number)
    (define (always-false ignored-argument)
      false)
    (number always-false true))

  (define (true first second)
    first)

  (define (false first second)
    second)

  
  (struct pair (left right))

  (define (sub1 number)
    (define initial-pair (pair zero zero))

    (define (slide-pair current-pair)
      (define current-number (pair-right current-pair))
      (pair current-number (+ current-number one)))

    (define final-pair
      (number slide-pair initial-pair))

    (pair-left final-pair))

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

  (define (pretty-print number)
    (number add1 0))

  (pretty-print (sum-up-to five))
  )