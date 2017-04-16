#lang racket

;; ---------------------------------------------------------------------------------------------------

;; TEST CASES

(module+ test-cases
  (provide (all-defined-out))

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
           argument))))))

;; ---------------------------------------------------------------------------------------------------

;; BIG-STEP INTERPRETER

(module+ big-step-interpreter
  (define (interpret expression)
    (match expression
      [`(λ (,argument) ,body)
       expression]
      [`(,function ,argument)
       (match-define `(λ (,argument-name) ,body)
         (interpret function))
       (define interpreted-argument
         (interpret argument))
       (define substituted-body
         (substitute
          body argument-name
          interpreted-argument))
       (interpret substituted-body)]
      [variable
       (raise-user-error
        (~a "Variable not found: " variable))]))

  (define (substitute
           body argument-name argument)
    (match body
      [`(λ (,other-argument-name) ,other-body)
       (if (equal? argument-name other-argument-name)
           body
           `(λ (,other-argument-name)
              ,(substitute
                other-body argument-name argument)))]
      [`(,function ,other-argument)
       `(,(substitute
           function argument-name argument)
         ,(substitute
           other-argument argument-name argument))]
      [variable
       (if (equal? argument-name variable)
           argument
           variable)]))

  (module+ test
    (require rackunit (submod ".." ".." test-cases))

    (check-equal? (interpret minimal-program)
                  minimal-program/result)

    (check-equal? (interpret minimal-application)
                  minimal-application/result)

    (check-equal? (interpret non-shadowing-variable-name-reuse)
                  non-shadowing-variable-name-reuse/result)

    (check-equal? (interpret shadowing)
                  shadowing/result)

    (check-exn exn:fail:user? (λ () (interpret open)))

    (check-equal? (interpret sum-up-to)
                  sum-up-to/result)))

;; ---------------------------------------------------------------------------------------------------

;; SMALL-STEP INTERPRETER

(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [_
     (interpret (step expression))]))

(define (step expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (define-values (reduction-expression continuation)
       (split-expression expression))
     (match-define `((λ (,argument-name) ,body) ,argument)
       reduction-expression)
     (define reduced-expression
       (substitute body argument-name argument))
     (fill-hole reduced-expression continuation)]))

(define (split-expression expression)
  (match expression
    [`((λ (,argument-name/function) ,body/function)
       (λ (,argument-name/argument) ,body/argument))
     (values expression `(hole))]
    [`((λ (,argument-name/function) ,body/function)
       ,argument)
     (define-values (reduction-expression continuation)
       (split-expression argument))
     (values reduction-expression
             `((λ (,argument-name/function) ,body/function)
               ,continuation))]
    [`(,function ,argument)
     (define-values (reduction-expression continuation)
       (split-expression function))
     (values reduction-expression
             `(,continuation ,argument))]))

(define (fill-hole reduced-expression continuation)
  (match continuation
    [`(hole)
     reduced-expression]
    [`(λ (,argument-name) ,body)
     continuation]
    [`(,function ,argument)
     `(,(fill-hole reduced-expression function)
       ,(fill-hole reduced-expression argument))]
    [variable
     continuation]))

;; ‘substitute’ is the same as for the big-step interpreter.

(define (substitute
         body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     (if (equal? argument-name other-argument-name)
         body
         `(λ (,other-argument-name)
            ,(substitute
              other-body argument-name argument)))]
    [`(,function ,other-argument)
     `(,(substitute
         function argument-name argument)
       ,(substitute
         other-argument argument-name argument))]
    [variable
     (if (equal? argument-name variable)
         argument
         variable)]))

(module+ test
  (require rackunit (submod ".." test-cases))

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

;; ---------------------------------------------------------------------------------------------------

;; WELL-FORMEDNESS CONDITION

(module+ closed?
  (define (closed? program)
    (define (step program-fragment bound-variables)
      (match program-fragment
        [`(λ (,argument-name) ,body)
         (step body `(,@bound-variables ,argument-name))]
        [`(,function ,argument)
         (and (step function bound-variables)
              (step argument bound-variables))]
        [variable
         (and (member variable bound-variables) #t)]))
    (step program empty))

  (module+ test
    (require rackunit (submod ".." ".." test-cases))

    (check-true (closed? minimal-program))

    (check-true (closed? minimal-application))

    (check-true (closed? non-shadowing-variable-name-reuse))

    (check-true (closed? shadowing))

    (check-false (closed? open))

    (check-true (closed? sum-up-to))))