#lang racket

;; ---------------------------------------------------------------------------------------------------

;; TEST CASES

(module+ test
  (require rackunit))

(define minimal-program `(λ (x) x))
(define minimal-program/result `(λ (x) x))
(define minimal-application `((λ (x) x) (λ (y) y)))
(define minimal-application/result `(λ (y) y))
(define non-shadowing-variable-name-reuse `((λ (x) x) (λ (x) x)))
(define non-shadowing-variable-name-reuse/result `(λ (x) x))
(define shadowing `(((λ (x) (λ (x) x)) (λ (y) y)) (λ (z) z)))
(define shadowing/result `(λ (z) z))
(define open `x)
(define sum-up-to
  `((λ (number)
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
(define sum-up-to/result
  `(λ (function)
     (λ (argument)
       (((λ (function)
           (λ (argument)
             (function
              (function
               (function
                (function
                 (function argument)))))))
         function)
        (((λ (function)
            (λ (argument)
              (((λ (function)
                  (λ (argument)
                    (((λ (function)
                        (λ (argument)
                          (((λ (function)
                              (λ (argument)
                                (((λ (function)
                                    (λ (argument)
                                      (((λ (function)
                                          (λ (argument)
                                            argument))
                                        function)
                                       (((λ (function)
                                           (λ (argument)
                                             (function
                                              argument)))
                                         function)
                                        argument))))
                                  function)
                                 (((λ (function)
                                     (λ (argument)
                                       (function
                                        argument)))
                                   function)
                                  argument))))
                            function)
                           (((λ (function)
                               (λ (argument)
                                 (function
                                  argument)))
                             function)
                            argument))))
                      function)
                     (((λ (function)
                         (λ (argument)
                           (function argument)))
                       function)
                      argument))))
                function)
               (((λ (function)
                   (λ (argument)
                     (((λ (function)
                         (λ (argument)
                           (((λ (function)
                               (λ (argument)
                                 (((λ (function)
                                     (λ (argument)
                                       (((λ (function)
                                           (λ (argument)
                                             argument))
                                         function)
                                        (((λ (function)
                                            (λ (argument)
                                              (function
                                               argument)))
                                          function)
                                         argument))))
                                   function)
                                  (((λ (function)
                                      (λ (argument)
                                        (function
                                         argument)))
                                    function)
                                   argument))))
                             function)
                            (((λ (function)
                                (λ (argument)
                                  (function
                                   argument)))
                              function)
                             argument))))
                       function)
                      (((λ (function)
                          (λ (argument)
                            (((λ (function)
                                (λ (argument)
                                  (((λ (function)
                                      (λ (argument)
                                        (((λ (function)
                                            (λ (argument)
                                              argument))
                                          function)
                                         (((λ (function)
                                             (λ (argument)
                                               (function
                                                argument)))
                                           function)
                                          argument))))
                                    function)
                                   (((λ (function)
                                       (λ (argument)
                                         (function
                                          argument)))
                                     function)
                                    argument))))
                              function)
                             (((λ (function)
                                 (λ (argument)
                                   (((λ (function)
                                       (λ (argument)
                                         (((λ (function)
                                             (λ (argument)
                                               argument))
                                           function)
                                          (((λ (function)
                                              (λ (argument)
                                                (function
                                                 argument)))
                                            function)
                                           argument))))
                                     function)
                                    (((λ (function)
                                        (λ (argument)
                                          argument))
                                      function)
                                     argument))))
                               function)
                              argument))))
                        function)
                       argument))))
                 function)
                argument))))
          function)
         argument)))))

;; ---------------------------------------------------------------------------------------------------

;; WELL-FORMEDNESS CONDITION

(define (well-formed? program)
  (and (syntactically-valid? program) (closed? program)))

(module+ test
  (check-true (well-formed? minimal-program))

  (check-true (well-formed? minimal-application))

  (check-true (well-formed? non-shadowing-variable-name-reuse))

  (check-true (well-formed? shadowing))

  (check-false (well-formed? open))

  (check-true (well-formed? sum-up-to)))

(define (syntactically-valid? program-fragment)
  (match program-fragment
    [`(λ (,argument-name) ,body)
     (and (symbol? argument-name) (syntactically-valid? body))]
    [`(,function ,argument)
     (and (syntactically-valid? function) (syntactically-valid? argument))]
    [variable
     (symbol? variable)]))

(module+ test
  (check-true (syntactically-valid? minimal-program))

  (check-true (syntactically-valid? minimal-application))

  (check-true (syntactically-valid? non-shadowing-variable-name-reuse))

  (check-true (syntactically-valid? shadowing))

  (check-true (syntactically-valid? open))

  (check-true (syntactically-valid? sum-up-to))

  (check-false (syntactically-valid? `(λ (a b) a)))

  (check-false (syntactically-valid? `(λ (a) (a a a)))))

(define (closed? program)
  (set-empty? (free-variables program)))

(module+ test
  (check-true (closed? minimal-program))

  (check-true (closed? minimal-application))

  (check-true (closed? non-shadowing-variable-name-reuse))

  (check-true (closed? shadowing))

  (check-false (closed? open))

  (check-true (closed? sum-up-to)))

(define (free-variables program-fragment)
  (match program-fragment
    [`(λ (,argument-name) ,body)
     (set-remove (free-variables body) argument-name)]
    [`(,function ,argument)
     (set-union (free-variables function) (free-variables argument))]
    [variable
     (set variable)]))

(module+ test
  (check-equal? (free-variables minimal-program)
                (set))

  (check-equal? (free-variables minimal-application)
                (set))

  (check-equal? (free-variables non-shadowing-variable-name-reuse)
                (set))

  (check-equal? (free-variables shadowing)
                (set))

  (check-equal? (free-variables open)
                (set 'x))

  (check-equal? (free-variables sum-up-to)
                (set)))

;; ---------------------------------------------------------------------------------------------------

;; INTERPRETER

(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [`(,function ,argument)
     (define interpreted-function (interpret function))
     (define interpreted-argument (interpret argument))
     (match-define `(λ (,argument-name) ,body) interpreted-function)
     (define substituted-body (substitute body argument-name interpreted-argument))
     (interpret substituted-body)]))

(define (substitute body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     (if (equal? argument-name other-argument-name)
         body
         `(λ (,other-argument-name) ,(substitute other-body argument-name argument)))]
    [`(,function ,other-argument)
     `(,(substitute function argument-name argument)
       ,(substitute other-argument argument-name argument))]
    [variable
     (if (equal? argument-name variable) argument variable)]))

(module+ test
  (check-equal? (interpret minimal-program)
                minimal-program/result)

  (check-equal? (interpret minimal-application)
                minimal-application/result)

  (check-equal? (interpret non-shadowing-variable-name-reuse)
                non-shadowing-variable-name-reuse/result)

  (check-equal? (interpret shadowing)
                shadowing/result)

  (check-equal? (interpret sum-up-to)
                sum-up-to/result))
