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

;; WELL-FORMEDNESS CONDITION

(module+ well-formedness-condition
  (define (free-variables program-fragment)
    (match program-fragment
      [`(λ (,argument-name) ,body)
       (set-remove (free-variables body) argument-name)]
      [`(,function ,argument)
       (set-union (free-variables function) (free-variables argument))]
      [variable
       (set variable)]))

  (module+ test
    (require rackunit (submod ".." ".." test-cases))

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

  (define (closed? program)
    (equal? (free-variables program) (set)))

  (module+ test
    (require rackunit (submod ".." ".." test-cases))

    (check-true (closed? minimal-program))

    (check-true (closed? minimal-application))

    (check-true (closed? non-shadowing-variable-name-reuse))

    (check-true (closed? shadowing))

    (check-false (closed? open))

    (check-true (closed? sum-up-to))))

;; ---------------------------------------------------------------------------------------------------

;; BIG-STEP INTERPRETER

(module+ big-step-interpreter
  (define (interpret expression)
    (match expression
      [`(λ (,argument-name) ,body)
       expression]
      [`(,function ,argument)
       (define interpreted-function (interpret function))
       (define interpreted-argument (interpret argument))
       (match-define `(λ (,argument-name) ,body) interpreted-function)
       (define substituted-body (substitute body argument-name interpreted-argument))
       (interpret substituted-body)]))

  (define (substitute body argument-name argument)
    (match body
      [`(λ (,other-argument-name) ,other-body)
       (cond
         [(equal? argument-name other-argument-name)
          body]
         [else
          `(λ (,other-argument-name) ,(substitute other-body argument-name argument))])]
      [`(,function ,other-argument)
       `(,(substitute function argument-name argument)
         ,(substitute other-argument argument-name argument))]
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

    (check-equal? (interpret sum-up-to)
                  sum-up-to/result)))

;; ---------------------------------------------------------------------------------------------------

;; SMALL-STEP INTERPRETER

(module+ small-step-interpreter
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
       (define-values (reduction-expression context) (split-expression expression))
       (match-define `((λ (,argument-name) ,body) ,argument) reduction-expression)
       (define reduced-expression (substitute body argument-name argument))
       (fill-hole reduced-expression context)]))

  (define (split-expression expression)
    (match expression
      [`((λ (,argument-name/function) ,body/function) (λ (,argument-name/argument) ,body/argument))
       (values expression `(hole))]
      [`((λ (,argument-name/function) ,body/function) ,argument)
       (define-values (reduction-expression context) (split-expression argument))
       (values reduction-expression `((λ (,argument-name/function) ,body/function) ,context))]
      [`(,function ,argument)
       (define-values (reduction-expression context) (split-expression function))
       (values reduction-expression `(,context ,argument))]))

  (define (fill-hole program-fragment context)
    (match context
      [`(hole)
       program-fragment]
      [`(,function ,argument)
       `(,(fill-hole program-fragment function) ,(fill-hole program-fragment argument))]
      [_
       context]))

  ;; ‘substitute’ is the same as for the big-step interpreter.

  (define (substitute body argument-name argument)
    (match body
      [`(λ (,other-argument-name) ,other-body)
       (cond
         [(equal? argument-name other-argument-name)
          body]
         [else
          `(λ (,other-argument-name) ,(substitute other-body argument-name argument))])]
      [`(,function ,other-argument)
       `(,(substitute function argument-name argument)
         ,(substitute other-argument argument-name argument))]
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

    (check-equal? (interpret sum-up-to)
                  sum-up-to/result)))

;; ---------------------------------------------------------------------------------------------------

;; ENVIRONMENT-BASED INTERPRETER

;; TODO: Refactor ‘expression’ + ‘environment’ into ‘state’ data structure. Define ‘initial-state’. ‘lookup’ should receive state.

(module+ environment-based-interpreter
  (define (interpret expression)
    (define (interpret* expression environment)
      (match expression
        [`(closure (λ (,argument-name) ,body) ,closure-environment)
         (close expression)]
        [_
         (define-values (new-expression new-environment) (step expression environment))
         (interpret* new-expression new-environment)]))
    (interpret* expression empty))

  (define (step expression environment)
    (match expression
      [`(closure (λ (,argument-name) ,body) ,closure-environment)
       (values expression environment)]
      [_
       (define-values (reduction-expression context) (split-expression expression))
       (define-values (reduced-expression new-environment)
         (match reduction-expression
           [`(λ (,argument-name) ,body)
            (values `(closure (λ (,argument-name) ,body) ,environment) environment)]
           [`((closure (λ (,argument-name) ,body) ,closure-environment) ,argument)
            (values `(restore ,body ,environment)
                    (dict-set closure-environment argument-name argument))]
           [`(restore ,value ,previous-environment)
            (values value previous-environment)]
           [variable
            (values (lookup variable environment) environment)]))
       (values (fill-hole reduced-expression context) new-environment)]))

  (define (lookup variable environment)
    (dict-ref environment variable))

  (define (split-expression expression)
    (match expression
      [`((closure (λ (,argument-name/function) ,body/function) ,closure-environment/function)
         (closure (λ (,argument-name/argument) ,body/argument) ,closure-environment/argument))
       (values expression `(hole))]
      [`((closure (λ (,argument-name/function) ,body/function) ,closure-environment/function)
         ,argument)
       (define-values (reduction-expression context) (split-expression argument))
       (values reduction-expression
               `((closure (λ (,argument-name/function) ,body/function) ,closure-environment/function)
                 ,context))]
      [`(,function ,argument)
       (define-values (reduction-expression context) (split-expression function))
       (values reduction-expression `(,context ,argument))]
      [`(restore (closure (λ (,argument-name) ,body) ,closure-environment) ,previous-environment)
       (values expression `(hole))]
      [`(restore ,body ,previous-environment)
       (define-values (reduction-expression context) (split-expression body))
       (values reduction-expression `(restore ,context ,previous-environment))]
      [variable
       (values expression `(hole))]))

  (define (fill-hole program-fragment context)
    (match context
      [`(hole)
       program-fragment]
      [`(,function ,argument)
       `(,(fill-hole program-fragment function) ,(fill-hole program-fragment argument))]
      [`(restore ,body ,previous-environment)
       `(restore ,(fill-hole program-fragment body) ,previous-environment)]
      [_
       context]))

  (define (close closure)
    (match-define `(closure ,raw-function ,closure-environment) closure)
    (for/fold ([function raw-function])
              ([binding (in-list closure-environment)])
      (match-define `(,variable . ,raw-value) binding)
      (cond
        [(set-member? (free-variables function) variable)
         (define value (close raw-value))
         (substitute function variable value)]
        [else
         function])))

  ;; ‘substitute’ is the same as for the big-step interpreter.

  (define (substitute body argument-name argument)
    (match body
      [`(λ (,other-argument-name) ,other-body)
       (cond
         [(equal? argument-name other-argument-name)
          body]
         [else
          `(λ (,other-argument-name) ,(substitute other-body argument-name argument))])]
      [`(,function ,other-argument)
       `(,(substitute function argument-name argument)
         ,(substitute other-argument argument-name argument))]
      [variable
       (if (equal? argument-name variable)
           argument
           variable)]))

  ;; ‘free-variables’ is the same as for the well-formedness condition.

  (define (free-variables program-fragment)
    (match program-fragment
      [`(λ (,argument-name) ,body)
       (set-remove (free-variables body) argument-name)]
      [`(,function ,argument)
       (set-union (free-variables function) (free-variables argument))]
      [variable
       (set variable)]))

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

    (check-equal? (interpret sum-up-to)
                  sum-up-to/result)))

;; ---------------------------------------------------------------------------------------------------

;; FACTORED-ENVIRONMENT INTERPRETER

(module+ factored-environment-interpreter
  (define (interpret expression)
    (define (interpret* expression binding-environment value-environment time)
      (match expression
        [`(closure (λ (,argument-name) ,body) ,closure-binding-environment)
         (close expression value-environment)]
        [_
         (define-values (new-expression new-binding-environment new-value-environment new-time)
           (step expression binding-environment value-environment time))
         (interpret* new-expression new-binding-environment new-value-environment new-time)]))
    (interpret* expression empty empty initial-time))

  (define (step expression binding-environment value-environment time)
    (match expression
      [`(closure (λ (,argument-name) ,body)
                 ,closure-binding-environment)
       (values expression binding-environment value-environment time)]
      [_
       (define-values (reduction-expression context)
         (split-expression expression))
       (define-values (reduced-expression new-binding-environment new-value-environment new-time)
         (match reduction-expression
           [`(λ (,argument-name) ,body)
            (define closure
              `(closure (λ (,argument-name) ,body)
                        ,binding-environment))
            (values closure binding-environment value-environment time)]
           [`((closure (λ (,argument-name) ,body)
                       ,closure-binding-environment)
              ,argument)
            (define new-time (tick time))
            (define new-binding-environment
              (dict-set closure-binding-environment argument-name new-time))
            (define new-value-environment
              (dict-set value-environment new-time argument))
            (values `(restore ,body ,binding-environment)
                    new-binding-environment new-value-environment new-time)]
           [`(restore ,value ,previous-binding-environment)
            (values value previous-binding-environment value-environment time)]
           [variable
            (define value (lookup variable binding-environment value-environment))
            (values value binding-environment value-environment time)]))
       (values (fill-hole reduced-expression context)
               new-binding-environment new-value-environment new-time)]))

  (define (lookup variable binding-environment value-environment)
    (dict-ref value-environment (dict-ref binding-environment variable)))

  ;; ‘substitute’ is the same as for the environment-based interpreter, except for variable names.

  (define (split-expression expression)
    (match expression
      [`((closure (λ (,argument-name/function) ,body/function)
                  ,closure-binding-environment/function)
         (closure (λ (,argument-name/argument) ,body/argument)
                  ,closure-binding-environment/argument))
       (values expression `(hole))]
      [`((closure (λ (,argument-name/function) ,body/function)
                  ,closure-binding-environment/function)
         ,argument)
       (define-values (reduction-expression context)
         (split-expression argument))
       (values
        reduction-expression
        `((closure (λ (,argument-name/function) ,body/function)
                   ,closure-binding-environment/function)
          ,context))]
      [`(,function ,argument)
       (define-values (reduction-expression context)
         (split-expression function))
       (values reduction-expression
               `(,context ,argument))]
      [`(restore (closure (λ (,argument-name) ,body)
                          ,closure-binding-environment)
                 ,previous-binding-environment)
       (values expression `(hole))]
      [`(restore ,body ,previous-binding-environment)
       (define-values (reduction-expression context)
         (split-expression body))
       (values reduction-expression
               `(restore ,context ,previous-binding-environment))]
      [variable
       (values expression `(hole))]))

  ;; ‘fill-hole’ is the same as for the environment-based interpreter, except for variable names.

  (define (fill-hole program-fragment context)
    (match context
      [`(hole)
       program-fragment]
      [`(,function ,argument)
       `(,(fill-hole program-fragment function)
         ,(fill-hole program-fragment argument))]
      [`(restore ,body ,previous-binding-environment)
       `(restore ,(fill-hole program-fragment body)
                 ,previous-binding-environment)]
      [_
       context]))

  (define (close closure value-environment)
    (match-define
      `(closure ,raw-function ,closure-binding-environment)
      closure)
    (for/fold ([function raw-function])
              ([binding (in-list closure-binding-environment)])
      (match-define `(,variable . ,time) binding)
      (cond
        [(set-member? (free-variables function) variable)
         (define raw-value
           (lookup variable closure-binding-environment value-environment))
         (define value (close raw-value value-environment))
         (substitute function variable value)]
        [else
         function])))

  ;; ‘free-variables’ is the same as for the well-formedness condition.

  (define (free-variables program-fragment)
    (match program-fragment
      [`(λ (,argument-name) ,body)
       (set-remove (free-variables body) argument-name)]
      [`(,function ,argument)
       (set-union (free-variables function)
                  (free-variables argument))]
      [variable
       (set variable)]))

  (define initial-time 0)

  (define (tick time)
    (add1 time))

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
    (require rackunit (submod ".." ".." test-cases))

    (check-equal? (interpret minimal-program)
                  minimal-program/result)

    (check-equal? (interpret minimal-application)
                  minimal-application/result)

    (check-equal? (interpret non-shadowing-variable-name-reuse)
                  non-shadowing-variable-name-reuse/result)

    (check-equal? (interpret shadowing)
                  shadowing/result)

    (check-equal? (interpret sum-up-to)
                  sum-up-to/result)))

;; TODO: Test this whole thing! :)