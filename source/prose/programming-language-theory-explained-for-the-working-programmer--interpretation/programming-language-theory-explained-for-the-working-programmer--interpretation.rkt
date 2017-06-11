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
  (define (well-formed? program)
    (and (syntactically-valid? program) (closed? program)))

  (module+ test
    (require rackunit (submod ".." ".." test-cases))

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
    (require rackunit (submod ".." ".." test-cases))

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
    (require rackunit (submod ".." ".." test-cases))

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
                  (set))))

;; ---------------------------------------------------------------------------------------------------

;; BIG-STEP INTERPRETER

(module+ big-step-interpreter
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
  (define (interpret program)
    (match program
      [`(λ (,argument-name) ,body)
       program]
      [_
       (interpret (step program))]))

  (define (step program)
    (match program
      [`(λ (,argument-name) ,body)
       program]
      [`(,function ,argument)
       (define-values (reduction-expression context) (split-program program))
       (match-define `((λ (,argument-name) ,body) ,argument) reduction-expression)
       (define reduced-expression (substitute body argument-name argument))
       (fill-hole reduced-expression context)]))

  (define (split-program program-fragment)
    (match program-fragment
      [`((λ (,argument-name/function) ,body/function) (λ (,argument-name/argument) ,body/argument))
       (values program-fragment `(hole))]
      [`((λ (,argument-name/function) ,body/function) ,argument)
       (define-values (reduction-expression context) (split-program argument))
       (values reduction-expression `((λ (,argument-name/function) ,body/function) ,context))]
      [`(,function ,argument)
       (define-values (reduction-expression context) (split-program function))
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
       (if (equal? argument-name other-argument-name)
           body
           `(λ (,other-argument-name) ,(substitute other-body argument-name argument)))]
      [`(,function ,other-argument)
       `(,(substitute function argument-name argument)
         ,(substitute other-argument argument-name argument))]
      [variable
       (if (equal? argument-name variable) argument variable)]))

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

(module+ environment-based-interpreter
  (define (interpret program)
    (state->value (step* (initial-state program))))

  (define (step* current-state)
    (match (state-program current-state)
      [`(closure (λ (,argument-name) ,body) ,closure-binding-environment)
       current-state]
      [_
       (step* (step current-state))]))

  (define (step current-state)
    (match-define (state program environment) current-state)
    (match program
      [`(closure (λ (,argument-name) ,body) ,closure-environment)
       current-state]
      [_
       (define-values (reduction-expression context) (split-program program))
       (match-define (state reduced-expression new-environment)
         (match reduction-expression
           [`(λ (,argument-name) ,body)
            (define reduced-expression `(closure (λ (,argument-name) ,body) ,environment))
            (state reduced-expression environment)]
           [`((closure (λ (,argument-name) ,body) ,closure-environment) ,argument)
            (define reduced-expression `(restore ,body ,environment))
            (define new-environment (dict-set closure-environment argument-name argument))
            (state reduced-expression new-environment)]
           [`(restore ,value ,previous-environment)
            (state value previous-environment)]
           [variable
            (define reduced-expression (lookup variable current-state))
            (state reduced-expression environment)]))
       (define new-program (fill-hole reduced-expression context))
       (state new-program new-environment)]))

  (define (lookup variable current-state)
    (match-define (state program environment) current-state)
    (dict-ref environment variable))

  (struct state (program environment) #:transparent)

  (define (initial-state program)
    (state program empty))

  (define (split-program program-fragment)
    (match program-fragment
      [`((closure (λ (,argument-name/function) ,body/function) ,closure-environment/function)
         (closure (λ (,argument-name/argument) ,body/argument) ,closure-environment/argument))
       (values program-fragment `(hole))]
      [`((closure (λ (,argument-name/function) ,body/function) ,closure-environment/function)
         ,argument)
       (define-values (reduction-expression context) (split-program argument))
       (values reduction-expression
               `((closure (λ (,argument-name/function) ,body/function) ,closure-environment/function)
                 ,context))]
      [`(,function ,argument)
       (define-values (reduction-expression context) (split-program function))
       (values reduction-expression `(,context ,argument))]
      [`(restore (closure (λ (,argument-name) ,body) ,closure-environment) ,previous-environment)
       (values program-fragment `(hole))]
      [`(restore ,body ,previous-environment)
       (define-values (reduction-expression context) (split-program body))
       (values reduction-expression `(restore ,context ,previous-environment))]
      [variable
       (values program-fragment `(hole))]))

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

  (define (state->value current-state)
    (match-define (state `(closure ,raw-function ,closure-environment) environment) current-state)
    (for/fold ([function raw-function])
              ([binding (in-list closure-environment)])
      (match-define `(,variable . ,raw-value) binding)
      (cond
        [(set-member? (free-variables function) variable)
         (define raw-value (lookup variable (state variable closure-environment)))
         (define value (state->value (state raw-value environment)))
         (substitute function variable value)]
        [else
         function])))

  ;; ‘substitute’ is the same as for the big-step interpreter.

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
  (define (interpret program)
    (state->value (step* (initial-state program))))

  (define (step* current-state)
    (match (state-program current-state)
      [`(closure (λ (,argument-name) ,body) ,closure-binding-environment)
       current-state]
      [_
       (step* (step current-state))]))

  (define (step current-state)
    (match-define (state program binding-environment value-environment time) current-state)
    (match program
      [`(closure (λ (,argument-name) ,body) ,closure-binding-environment)
       current-state]
      [_
       (define-values (reduction-expression context) (split-program program))
       (match-define
         (state reduced-expression new-binding-environment new-value-environment new-time)
         (match reduction-expression
           [`(λ (,argument-name) ,body)
            (define reduced-expression `(closure (λ (,argument-name) ,body) ,binding-environment))
            (state reduced-expression binding-environment value-environment time)]
           [`((closure (λ (,argument-name) ,body) ,closure-binding-environment) ,argument)
            (define reduced-expression `(restore ,body ,binding-environment))
            (define new-time (tick current-state))
            (define new-binding-environment
              (dict-set closure-binding-environment argument-name new-time))
            (define new-value-environment (dict-set value-environment new-time argument))
            (state reduced-expression new-binding-environment new-value-environment new-time)]
           [`(restore ,value ,previous-binding-environment)
            (state value previous-binding-environment value-environment time)]
           [variable
            (define reduced-expression (lookup variable current-state))
            (state reduced-expression binding-environment value-environment time)]))
       (define new-program (fill-hole reduced-expression context))
       (state new-program new-binding-environment new-value-environment new-time)]))

  (define (lookup variable current-state)
    (match-define (state program binding-environment value-environment time) current-state)
    (dict-ref value-environment (dict-ref binding-environment variable)))

  (struct state (program binding-environment value-environment time) #:transparent)

  (define (initial-state program)
    (state program empty empty initial-time))

  (define initial-time 0)

  (define (tick current-state)
    (match-define (state program binding-environment value-environment time) current-state)
    (add1 time))

  ;; ‘split-program’ is the same as for the environment-based interpreter, except for variable names.

  (define (split-program program-fragment)
    (match program-fragment
      [`((closure (λ (,argument-name/function) ,body/function)
                  ,closure-binding-environment/function)
         (closure (λ (,argument-name/argument) ,body/argument)
                  ,closure-binding-environment/argument))
       (values program-fragment `(hole))]
      [`((closure (λ (,argument-name/function) ,body/function)
                  ,closure-binding-environment/function)
         ,argument)
       (define-values (reduction-expression context)
         (split-program argument))
       (values
        reduction-expression
        `((closure (λ (,argument-name/function) ,body/function)
                   ,closure-binding-environment/function)
          ,context))]
      [`(,function ,argument)
       (define-values (reduction-expression context)
         (split-program function))
       (values reduction-expression
               `(,context ,argument))]
      [`(restore (closure (λ (,argument-name) ,body)
                          ,closure-binding-environment)
                 ,previous-binding-environment)
       (values program-fragment `(hole))]
      [`(restore ,body ,previous-binding-environment)
       (define-values (reduction-expression context)
         (split-program body))
       (values reduction-expression
               `(restore ,context ,previous-binding-environment))]
      [variable
       (values program-fragment `(hole))]))

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

  (define (state->value current-state)
    (match-define
      (state `(closure ,raw-function ,closure-binding-environment)
             binding-environment value-environment time)
      current-state)
    (for/fold ([function raw-function])
              ([binding (in-list closure-binding-environment)])
      (match-define `(,variable . ,time) binding)
      (cond
        [(set-member? (free-variables function) variable)
         (define raw-value
           (lookup variable (state variable closure-binding-environment value-environment time)))
         (define value (state->value (state raw-value binding-environment value-environment time)))
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

  ;; ‘substitute’ is the same as for the big-step interpreter.

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