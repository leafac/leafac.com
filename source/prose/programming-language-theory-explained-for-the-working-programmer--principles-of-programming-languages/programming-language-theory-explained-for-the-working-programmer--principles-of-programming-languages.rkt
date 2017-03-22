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

(module+ booleans/if-as-function
  (define (if condition then else)
    (condition then else))

  (define (sum-up-to number)
    (if (zero? number)
        zero
        (+ number (sum-up-to (sub1 number)))))

  (define (zero function argument)
    argument)
  )

(module+ booleans/delay-computation
  (define (sum-up-to number)
    (define (then)
      zero)

    (define (else)
      (+ number (sum-up-to (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (define (if condition then else)
    (condition then else))

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

(module+ pairs/store
  (define (store value)
    (define (retriever)
      value)

    retriever)

  (define stored-5 (store 5))
  (define stored-3 (store 3))

  (stored-5) ;; => 5
  (stored-3) ;; => 3
  )

(module+ pairs
  (define (pair left right)
    (define (retriever selector)
      (selector left right))
    retriever)

  (define (selector-left left right)
    left)

  (define (selector-right left right)
    right)

  (define number-pair (pair 2 3))

  (number-pair selector-left) ;; => 2
  (number-pair selector-right) ;; => 3

  (define (pair-left pair)
    (define (selector-left left right)
      left)

    (pair selector-left))

  (define (pair-right pair)
    (define (selector-right left right)
      right)

    (pair selector-right))

  (pair-left number-pair) ;; => 2
  (pair-right number-pair) ;; => 3
  )

;; Examples in the “recursion” section do not use the encoding for numbers, for simplicity.

(module+ recursion/introduce-sum-up-to/rest
  (define (sum-up-to/rest number)
    (define (then)
      zero)

    (define (else)
      (+ number (sum-up-to/rest (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (define (sum-up-to number)
    (define (then)
      zero)

    (define (else)
      (+ number (sum-up-to/rest (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (set! sum-up-to/rest sum-up-to)

  (define zero 0)
  )

(module+ recursion/tying-the-knot
  (define (sum-up-to/rest number)
    "TEMPORARY IMPLEMENTATION")

  (define (sum-up-to number)
    (define (then)
      zero)

    (define (else)
      (+ number (sum-up-to/rest (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (set! sum-up-to/rest sum-up-to)

  (define zero 0)

  (sum-up-to sum-up-to 5)
  )

(module+ recursion/self-passing/failing
  (define (sum-up-to sum-up-to/rest number)
    (define (then)
      zero)

    (define (else)
      (+ number
         (sum-up-to/rest (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (define zero 0)

  (sum-up-to sum-up-to 5)
  )

(module+ recursion/self-passing
  (define (sum-up-to sum-up-to/rest number)
    (define (then)
      zero)

    (define (else)
      (+ number
         (sum-up-to/rest sum-up-to/rest (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (define zero 0)

  (sum-up-to sum-up-to 5)
  )

(module+ recursion/façade
  (define (sum-up-to number)
    (define (sum-up-to/partial sum-up-to/rest number)
      (define (then)
        zero)

      (define (else)
        (+ number
           (sum-up-to/rest sum-up-to/rest (sub1 number))))

      (define branch-to-take
        (if (zero? number) then else))

      (branch-to-take))

    (sum-up-to/partial sum-up-to/partial number))

  (define zero 0)

  (sum-up-to 5)
  )

(module+ functions-with-multiple-arguments/multiple-arguments
  (define (pair left)
    (define (pair/intermediary right)
      (define (retriever selector)
        (selector left right))
      retriever)
    pair/intermediary)
  )

(module+ functions-with-multiple-arguments/zero-arguments
  (define (else dummy)
    ___)

  (define (dummy ignore-me)
    ignore-me)

  (else dummy)
  )

(module+ functions-with-multiple-arguments/checkpoint
  (define (sum-up-to number)
    (define (sum-up-to/partial sum-up-to/rest number)
      (define (then)
        zero)

      (define (else)
        (+ number
           (sum-up-to/rest sum-up-to/rest (sub1 number))))

      (define branch-to-take
        (if (zero? number) then else))

      (branch-to-take))

    (sum-up-to/partial sum-up-to/partial number))

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

  (define (zero? number)
    (define (always-false ignored-argument)
      false)
    (number always-false true))

  (define (+ number-left number-right)
    (define (result function argument)
      (number-left function (number-right function argument)))
    result)

  (define (sub1 number)
    (define initial-pair (pair zero zero))

    (define (slide-pair current-pair)
      (define current-number (pair-right current-pair))
      (pair current-number (+ current-number one)))

    (define final-pair
      (number slide-pair initial-pair))

    (pair-left final-pair))

  (define (true first second)
    first)

  (define (false first second)
    second)

  (define (if condition then else)
    (condition then else))

  (define (pair left right)
    (define (retriever selector)
      (selector left right))
    retriever)

  (define (pair-left pair)
    (define (selector-left left right)
      left)

    (pair selector-left))

  (define (pair-right pair)
    (define (selector-right left right)
      right)

    (pair selector-right))

  (define (pretty-print number)
    (number add1 0))

  (pretty-print (sum-up-to five))
  )

(module+ functions-with-multiple-arguments/complete
  (define (sum-up-to number)
    (define ((sum-up-to/partial sum-up-to/rest) number)
      (define (then dummy)
        zero)

      (define (else dummy)
        ((+ number)
         ((sum-up-to/rest sum-up-to/rest) (sub1 number))))

      (define branch-to-take
        (((if (zero? number)) then) else))

      (define (dummy ignore-me)
        ignore-me)

      (branch-to-take dummy))

    ((sum-up-to/partial sum-up-to/partial) number))

  (define ((zero function) argument)
    argument)

  (define ((one function) argument)
    (function argument))

  (define ((five function) argument)
    (function
     (function
      (function
       (function
        (function argument))))))

  (define (zero? number)
    (define (always-false ignored-argument)
      false)
    ((number always-false) true))

  (define ((+ number-left) number-right)
    (define ((result function) argument)
      ((number-left function)
       ((number-right function) argument)))
    result)

  (define (sub1 number)
    (define initial-pair ((pair zero) zero))

    (define (slide-pair current-pair)
      (define current-number (pair-right current-pair))
      ((pair current-number) ((+ current-number) one)))

    (define final-pair
      ((number slide-pair) initial-pair))

    (pair-left final-pair))

  (define ((true first) second)
    first)

  (define ((false first) second)
    second)

  (define (((if condition) then) else)
    ((condition then) else))

  (define ((pair left) right)
    (define (retriever selector)
      ((selector left) right))
    retriever)

  (define (pair-left pair)
    (define ((selector-left left) right)
      left)

    (pair selector-left))

  (define (pair-right pair)
    (define ((selector-right left) right)
      right)

    (pair selector-right))

  (define (pretty-print number)
    ((number add1) 0))

  (pretty-print (sum-up-to five)) ;; => 15
  )

(module+ named-definitions/reorder
  (define ((true first) second)
    first)

  (define ((false first) second)
    second)

  (define (((if condition) then) else)
    ((condition then) else))

  (define ((pair left) right)
    (define (retriever selector)
      ((selector left) right))
    retriever)

  (define (pair-left pair)
    (define ((selector-left left) right)
      left)

    (pair selector-left))

  (define (pair-right pair)
    (define ((selector-right left) right)
      right)

    (pair selector-right))

  (define ((zero function) argument)
    argument)

  (define ((one function) argument)
    (function argument))

  (define ((five function) argument)
    (function
     (function
      (function
       (function
        (function argument))))))

  (define (zero? number)
    (define (always-false ignored-argument)
      false)
    ((number always-false) true))

  (define ((+ number-left) number-right)
    (define ((result function) argument)
      ((number-left function)
       ((number-right function) argument)))
    result)

  (define (sub1 number)
    (define initial-pair ((pair zero) zero))

    (define (slide-pair current-pair)
      (define current-number (pair-right current-pair))
      ((pair current-number) ((+ current-number) one)))

    (define final-pair
      ((number slide-pair) initial-pair))

    (pair-left final-pair))

  (define (sum-up-to number)
    (define ((sum-up-to/partial sum-up-to/rest) number)
      (define (then dummy)
        zero)

      (define (else dummy)
        ((+ number)
         ((sum-up-to/rest sum-up-to/rest) (sub1 number))))

      (define branch-to-take
        (((if (zero? number)) then) else))

      (define (dummy ignore-me)
        ignore-me)

      (branch-to-take dummy))

    ((sum-up-to/partial sum-up-to/partial) number))

  (define (pretty-print number)
    ((number add1) 0))

  (pretty-print (sum-up-to five)) ;; => 15
  )

(module+ named-definitions/inlined
  (define (pretty-print number)
    ((number add1) 0))

  (pretty-print
   ((λ (number)
      (((λ (sum-up-to/rest)
          (λ (number)
            (((((λ (condition)
                  (λ (then)
                    (λ (else)
                      ((condition then)
                       else))))
                ((λ (number)
                   ((number
                     (λ (ignored-argument)
                       (λ (first)
                         (λ (second)
                           second))))
                    (λ (first)
                      (λ (second) first))))
                 number))
               (λ (dummy)
                 (λ (function)
                   (λ (argument) argument))))
              (λ (dummy)
                (((λ (number-left)
                    (λ (number-right)
                      (λ (function)
                        (λ (argument)
                          ((number-left
                            function)
                           ((number-right
                             function)
                            argument))))))
                  number)
                 ((sum-up-to/rest
                   sum-up-to/rest)
                  ((λ (number)
                     ((λ (pair)
                        (pair
                         (λ (left)
                           (λ (right) left))))
                      ((number
                        (λ (current-pair)
                          (((λ (left)
                              (λ (right)
                                (λ (selector)
                                  ((selector
                                    left)
                                   right))))
                            ((λ (pair)
                               (pair
                                (λ (left)
                                  (λ (right)
                                    right))))
                             current-pair))
                           (((λ (number-left)
                               (λ (number-right)
                                 (λ (function)
                                   (λ (argument)
                                     ((number-left
                                       function)
                                      ((number-right
                                        function)
                                       argument))))))
                             ((λ (pair)
                                (pair
                                 (λ (left)
                                   (λ (right)
                                     right))))
                              current-pair))
                            (λ (function)
                              (λ (argument)
                                (function
                                 argument)))))))
                       (((λ (left)
                           (λ (right)
                             (λ (selector)
                               ((selector
                                 left)
                                right))))
                         (λ (function)
                           (λ (argument)
                             argument)))
                        (λ (function)
                          (λ (argument)
                            argument))))))
                   number)))))
             (λ (ignore-me) ignore-me))))
        (λ (sum-up-to/rest)
          (λ (number)
            (((((λ (condition)
                  (λ (then)
                    (λ (else)
                      ((condition then)
                       else))))
                ((λ (number)
                   ((number
                     (λ (ignored-argument)
                       (λ (first)
                         (λ (second)
                           second))))
                    (λ (first)
                      (λ (second) first))))
                 number))
               (λ (dummy)
                 (λ (function)
                   (λ (argument) argument))))
              (λ (dummy)
                (((λ (number-left)
                    (λ (number-right)
                      (λ (function)
                        (λ (argument)
                          ((number-left
                            function)
                           ((number-right
                             function)
                            argument))))))
                  number)
                 ((sum-up-to/rest
                   sum-up-to/rest)
                  ((λ (number)
                     ((λ (pair)
                        (pair
                         (λ (left)
                           (λ (right) left))))
                      ((number
                        (λ (current-pair)
                          (((λ (left)
                              (λ (right)
                                (λ (selector)
                                  ((selector
                                    left)
                                   right))))
                            ((λ (pair)
                               (pair
                                (λ (left)
                                  (λ (right)
                                    right))))
                             current-pair))
                           (((λ (number-left)
                               (λ (number-right)
                                 (λ (function)
                                   (λ (argument)
                                     ((number-left
                                       function)
                                      ((number-right
                                        function)
                                       argument))))))
                             ((λ (pair)
                                (pair
                                 (λ (left)
                                   (λ (right)
                                     right))))
                              current-pair))
                            (λ (function)
                              (λ (argument)
                                (function
                                 argument)))))))
                       (((λ (left)
                           (λ (right)
                             (λ (selector)
                               ((selector
                                 left)
                                right))))
                         (λ (function)
                           (λ (argument)
                             argument)))
                        (λ (function)
                          (λ (argument)
                            argument))))))
                   number)))))
             (λ (ignore-me) ignore-me)))))
       number))
    (λ (function)
      (λ (argument)
        (function
         (function
          (function
           (function
            (function argument)))))))))
  )