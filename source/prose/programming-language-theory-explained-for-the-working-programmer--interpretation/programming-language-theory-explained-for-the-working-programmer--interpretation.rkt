#lang racket

;; ---------------------------------------------------------------------------------------------------

;; MATHEMATICAL DEFINITIONS

;; This section is not part of the article. It exists help exploration.

(module+ mathematical-definitions
  (require redex)
  (module+ test (require rackunit))

  (define-language lambda-calculus
    [e ::= v x (e e)]
    [v ::= (λ (x) e)]
    [x ::= variable-not-otherwise-mentioned])

  (define-term minimal-program (λ (x) x))
  (define-term minimal-program/result (λ (x) x))
  (define-term minimal-application ((λ (x) x) (λ (y) y)))
  (define-term minimal-application/result (λ (y) y))
  (define-term non-shadowing-variable-name-reuse ((λ (x) x) (λ (x) x)))
  (define-term non-shadowing-variable-name-reuse/result (λ (x) x))
  (define-term shadowing (((λ (x) (λ (x) x)) (λ (y) y)) (λ (z) z)))
  (define-term shadowing/result (λ (z) z))
  (define-term open x)

  (define-metafunction lambda-calculus
    → : e -> v
    [(→ v) v]
    [(→ x) ,(raise-user-error (~a "Variable not found: " (term x)))]
    [(→ (e_f e_a)) (→ (substitute e_b x v_a)) (where/error (λ (x) e_b) (→ e_f)) (where v_a (→ e_a))])

  (define-metafunction lambda-calculus
    substitute : e x v -> e
    [(substitute (name e (λ (x) e_b)) x v) e]
    [(substitute (λ (x_1) e_b) x_2 v) (λ (x_1) (substitute e_b x_2 v))]
    [(substitute x x v) v]
    [(substitute x_1 x_2 v) x_1]
    [(substitute (e_1 e_2) x v) ((substitute e_1 x v) (substitute e_2 x v))])

  (module+ test
    (test-equal (term (→ minimal-program))
                (term minimal-program/result))

    (test-equal (term (→ minimal-application))
                (term minimal-application/result))

    (test-equal (term (→ non-shadowing-variable-name-reuse))
                (term non-shadowing-variable-name-reuse/result))

    (test-equal (term (→ shadowing))
                (term shadowing/result))

    (check-exn exn:fail:user? (λ () (term (→ open))))))

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
  (define shadowing `(λ (z) z))
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
  (require rackunit (submod ".." test-cases))

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
                sum-up-to/result))