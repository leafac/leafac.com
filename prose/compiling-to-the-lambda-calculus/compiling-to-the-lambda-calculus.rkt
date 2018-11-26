#lang racket

;; ---------------------------------------------------------------------------------------------------
;; SURFACE LANGUAGE (RACKET SUBSET) (ˢ)
;;
;; e ::=                                          Expressions
;;     BOOLEANS
;;     | #t | #f
;;     | (if e e e)
;;     | (and e ...) | (or e ...) | not | xor
;;
;;     NUMBERS
;;     | <non-negative-integers>
;;     | add1 | sub1 | + | (+ e ...) | - | (- e ...{2,}) | * | (* e ...) | quotient | expt
;;     | zero?
;;     | <= | (<= e ...+) | >= | (>= e ...+) | = | (= e ...+) | < | (< e ...+) | > | (> e ...+)
;;
;;     PAIRS
;;     | null | cons
;;     | null? | car | cdr
;;
;;     LISTS
;;     | empty | (list e ...)
;;     | first | rest
;;     | map
;;
;;     BINDINGS
;;     | (let ([x e] ...) e ...+)
;;     | (let* ([x e] ...) e ...+)
;;     | (letrec ([x e]) e ...+)
;;     | (begin e ...+)
;;
;;     FUNCTIONS
;;     | (λ (x ...) e ...+)
;;     | identity | const | (thunk e)
;;     | (e ...+)
;;     | x
;;
;; x ::= <identifiers>                            Identifiers
;;
;; Closed

;; ---------------------------------------------------------------------------------------------------
;; CORE LANGUAGE (λ-CALCULUS) (ᶜ)
;;
;; e ::= (λ (x) e) | (e e) | x                    Expressions
;; x ::= <identifiers>                            Identifiers
;;
;; Closed · ᶜ ⊂ ˢ

;; ---------------------------------------------------------------------------------------------------
;; COMPILER

;; compile : eˢ → eᶜ
(define (compile e)
  (define e′ (expand e))
  (if (equal? e e′) e (compile e′)))

;; expand : eˢ → eˢ⁺ᶜ
(define (expand e)
  (match e
    ;; BOOLEANS
    [`#t `(λ (a b) a)]
    [`#f `(λ (a b) b)]
    [`(if ,eᶜ ,eᵗ ,eᵉ) `((,eᶜ (thunk ,eᵗ) (thunk ,eᵉ)))]
    [`(and) `#t]
    [`(and ,e₁) e₁]
    [`(and ,e₁ ,e₂) `(if ,e₁ ,e₂ #f)]
    [`(and ,e₁ ,e₂ ...) `(and ,e₁ (and ,@e₂))]
    [`(or) `#f]
    [`(or ,e₁) e₁]
    [`(or ,e₁ ,e₂) `(if ,e₁ #t ,e₂)]
    [`(or ,e₁ ,e₂ ...) `(or ,e₁ (or ,@e₂))]
    [`not `(λ (p) (λ (a b) (p b a)))]
    [`xor `(λ (p q) (p (not q) q))]

    ;; NUMBERS
    [(? (λ (n) (and (integer? n) (not (negative? n)))) n)
     `(λ (f) (λ (x) ,(for/fold ([eᵇ `x]) ([i (in-range n)]) `(f ,eᵇ))))]
    [`add1 `(λ (n) (λ (f) (λ (x) (f ((n f) x)))))]
    [`sub1 `(λ (n) (car ((n (λ (x) (let ([p (cdr x)]) (cons p (add1 p))))) (cons 0 0))))]
    [`+ `(λ (m n) ((n add1) m))]
    [`(+) `0]
    [`(+ ,e₁) e₁]
    [`(+ ,e₁ ,e₂) `(,(expand `+) ,e₁ ,e₂)]
    [`(+ ,e₁ ... ,e₂) `(+ (+ ,@e₁) ,e₂)]
    [`- `(λ (m n) ((n sub1) m))]
    [`(- ,e₁ ,e₂) `(,(expand `-) ,e₁ ,e₂)]
    [`(- ,e₁ ... ,e₂) #:when (not (empty? e₁)) `(- (- ,@e₁) ,e₂)]
    [`* `(λ (m n) ((n (λ (a) (+ a m))) (+)))]
    [`(*) `1]
    [`(* ,e₁) e₁]
    [`(* ,e₁ ,e₂) `(,(expand `*) ,e₁ ,e₂)]
    [`(* ,e₁ ... ,e₂) `(* (* ,@e₁) ,e₂)]
    [`quotient `(letrec ([quot (λ (m n) (if (< m n) 0 (add1 (quot (- m n) n))))]) quot)]
    [`expt `(λ (m n) ((n (λ (a) (* a m))) (*)))]
    [`zero? `(λ (n) ((n (λ (x) #f)) #t))]
    [`<= `(λ (m n) (zero? (- m n)))]
    [`(<= ,e₁) `(begin ,e₁ #t)]
    [`(<= ,e₁ ,e₂) `(,(expand `<=) ,e₁ ,e₂)]
    [`(<= ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       `(let* (,@[map list x₁ e₁])
          (and ,@(map (λ (x₂ x₃) `(<= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
    [`>= `(λ (m n) (zero? (- n m)))]
    [`(>= ,e₁) `(begin ,e₁ #t)]
    [`(>= ,e₁ ,e₂) `(,(expand `>=) ,e₁ ,e₂)]
    [`(>= ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       `(let* (,@[map list x₁ e₁])
          (and ,@(map (λ (x₂ x₃) `(>= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
    [`= `(λ (m n) (and (<= m n) (>= m n)))]
    [`(= ,e₁) `(begin ,e₁ #t)]
    [`(= ,e₁ ,e₂) `(,(expand `=) ,e₁ ,e₂)]
    [`(= ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       `(let* (,@[map list x₁ e₁])
          (and ,@(map (λ (x₂ x₃) `(= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
    [`< `(λ (m n) (and (<= m n) (not (= m n))))]
    [`(< ,e₁) `(begin ,e₁ #t)]
    [`(< ,e₁ ,e₂) `(,(expand `<) ,e₁ ,e₂)]
    [`(< ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       `(let* (,@[map list x₁ e₁])
          (and ,@(map (λ (x₂ x₃) `(< ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]
    [`> `(λ (m n) (and (>= m n) (not (= m n))))]
    [`(> ,e₁) `(begin ,e₁ #t)]
    [`(> ,e₁ ,e₂) `(,(expand `>) ,e₁ ,e₂)]
    [`(> ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       `(let* (,@[map list x₁ e₁])
          (and ,@(map (λ (x₂ x₃) `(> ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1)))))]

    ;; PAIRS
    [`cons `(λ (a b) (λ (s) (s a b)))]
    [`car `(λ (p) (p (λ (a b) a)))]
    [`cdr `(λ (p) (p (λ (a b) b)))]

    ;; LISTS
    [`null `(λ (s) #t)]
    [`empty `null]
    [`null? `(λ (l) (l (λ (a b) #f)))]
    [`(list) `empty]
    [`(list ,eʰ ,eᵗ ...) `(cons ,eʰ (list ,@eᵗ))]
    [`first `car]
    [`rest `cdr]
    [`map `(letrec ([ma (λ (f l) (if (null? l) l (cons (f (car l)) (ma f (cdr l)))))]) ma)]

    ;; BINDINGS
    [`(let ([,x ,eˣ] ...) ,eᵇ ...) `((λ (,@(reverse x)) ,@eᵇ) ,@(reverse eˣ))]
    [`(let* () ,eᵇ ...) `(let () ,@eᵇ)]
    [`(let* ([,x₁ ,eˣ₁]) ,eᵇ ...) `(let ([,x₁ ,eˣ₁]) ,@eᵇ)]
    [`(let* ([,x₁ ,eˣ₁] [,x₂ ,eˣ₂] ...) ,eᵇ ...)
     `(let ([,x₁ ,eˣ₁]) (let* (,@[map list x₂ eˣ₂]) ,@eᵇ))]
    [`(letrec ([,x ,eˣ]) ,eᵇ ...)
     `(let ([,x ((λ (f) ((λ (x) (f (λ (v) ((x x) v)))) (λ (x) (f (λ (v) ((x x) v))))))
                 (λ (,x) ,eˣ))])
        ,@eᵇ)]
    [`(begin ,eᵇ) eᵇ]
    [`(begin ,eᵇ₁ ,eᵇ₂ ...) `(let ([,(gensym) ,eᵇ₁]) ,@eᵇ₂)]

    ;; FUNCTIONS
    [`(λ (,x) ,eᵇ) `(λ (,x) ,(expand eᵇ))]
    [`(λ (,x) ,eᵇ ...) `(λ (,x) (begin ,@eᵇ))]
    [`(λ () ,eᵇ ...) `(λ (,(gensym)) ,@eᵇ)]
    [`(λ (,x₁ ,x₂ ...) ,eᵇ ...) `(λ (,x₁) (λ (,@x₂) ,@eᵇ))]
    [`identity `(λ (x) x)]
    [`const `(λ (a) (λ (b) a))]
    [`(thunk ,eᵇ) `(λ () ,eᵇ)]
    [`(,eᶠ ,eᵃ) `(,(expand eᶠ) ,(expand eᵃ))]
    [`(,eᶠ) `(,eᶠ null)]
    [`(,eᶠ ,eᵃ₁ ,eᵃ₂ ...) `((,eᶠ ,eᵃ₁) ,@eᵃ₂)]
    [(? symbol? x) x]))

;; evaluate : eˢ → Racket Value
(define evaluate
  (let ([namespace (make-base-namespace)])
    (λ (e) (eval (compile e) namespace))))

;; ---------------------------------------------------------------------------------------------------
;; INSPECTORS

;; BOOLEANS
(define (inspect/boolean e) ((e #t) #f))

;; NUMBERS
(define (inspect/number e) ((e add1) 0))

;; PAIRS
(define ((inspect/pair inspect/left inspect/right) e)
  (cons (inspect/left ((evaluate 'car) e))
        (inspect/right ((evaluate 'cdr) e))))

;; LISTS
(define ((inspect/list inspect/element) e)
  (if (inspect/boolean ((evaluate 'null?) e))
      null
      ((inspect/pair inspect/element (inspect/list inspect/element)) e)))

;; ---------------------------------------------------------------------------------------------------
;; TESTS

(module+ test
  (require rackunit)

  (check-match
   (compile
    '(letrec ([factorial (λ (n) (if (zero? n) 1 (* n (factorial (sub1 n)))))])
       (factorial 5)))
   `((λ (factorial) (factorial (λ (f) (λ (x) (f (f (f (f (f x)))))))))
     ((λ (f) ((λ (x) (f (λ (v) ((x x) v)))) (λ (x) (f (λ (v) ((x x) v))))))
      (λ (factorial)
        (λ (n)
          (((((λ (n) ((n (λ (x) (λ (a) (λ (b) b)))) (λ (a) (λ (b) a)))) n)
             (λ (,g2269) (λ (f) (λ (x) (f x)))))
            (λ (,g2270)
              (((λ (m)
                  (λ (n)
                    ((n
                      (λ (a)
                        (((λ (m)
                            (λ (n) ((n (λ (n) (λ (f) (λ (x) (f ((n f) x)))))) m)))
                          a)
                         m)))
                     (λ (f) (λ (x) x)))))
                n)
               (factorial
                ((λ (n)
                   ((λ (p) (p (λ (a) (λ (b) a))))
                    ((n
                      (λ (x)
                        ((λ (p)
                           (((λ (a) (λ (b) (λ (s) ((s a) b)))) p)
                            ((λ (n) (λ (f) (λ (x) (f ((n f) x))))) p)))
                         ((λ (p) (p (λ (a) (λ (b) b)))) x))))
                     (((λ (a) (λ (b) (λ (s) ((s a) b)))) (λ (f) (λ (x) x)))
                      (λ (f) (λ (x) x))))))
                 n)))))
           (λ (s) (λ (a) (λ (b) a)))))))))

  ;; BOOLEANS
  (check-equal? (inspect/boolean (evaluate '#t)) '#t)
  (check-equal? (inspect/boolean (evaluate '#f)) '#f)
  (check-equal? (inspect/boolean (evaluate '(if #t #t #f))) '#t)
  (check-equal? (inspect/boolean (evaluate '(if #f #t #f))) '#f)
  (check-equal? (inspect/boolean (evaluate '(if #t #t (letrec ([f (λ (x) (f x))]) (f 0))))) '#t)
  (check-equal? (inspect/boolean (evaluate '(and))) '#t)
  (check-equal? (inspect/boolean (evaluate '(and #t))) '#t)
  (check-equal? (inspect/boolean (evaluate '(and #t #t))) '#t)
  (check-equal? (inspect/boolean (evaluate '(and #t #f))) '#f)
  (check-equal? (inspect/boolean (evaluate '(and #f (letrec ([f (λ (x) (f x))]) (f 0))))) '#f)
  (check-equal? (inspect/boolean (evaluate '(and #t #f #t))) '#f)
  (check-equal? (inspect/boolean (evaluate '(or))) '#f)
  (check-equal? (inspect/boolean (evaluate '(or #t))) '#t)
  (check-equal? (inspect/boolean (evaluate '(or #f #f))) '#f)
  (check-equal? (inspect/boolean (evaluate '(or #t #f))) '#t)
  (check-equal? (inspect/boolean (evaluate '(or #t (letrec ([f (λ (x) (f x))]) (f 0))))) '#t)
  (check-equal? (inspect/boolean (evaluate '(or #t #f #t))) '#t)
  (check-equal? (inspect/boolean (evaluate '(not #f))) '#t)
  (check-equal? (inspect/boolean (evaluate '(not #t))) '#f)
  (check-equal? (inspect/boolean (evaluate '(xor #t #f))) '#t)
  (check-equal? (inspect/boolean (evaluate '(xor #t #t))) '#f)

  ;; NUMBERS
  (check-equal? (inspect/number (evaluate '0)) '0)
  (check-equal? (inspect/number (evaluate '5)) '5)
  (check-equal? (inspect/number (evaluate '(add1 1))) '2)
  (check-equal? (inspect/number (evaluate '(sub1 5))) '4)
  (check-equal? (inspect/number (evaluate '(+))) '0)
  (check-equal? (inspect/number (evaluate '(+ 0))) '0)
  (check-equal? (inspect/number (evaluate '(+ 0 1))) '1)
  (check-equal? (inspect/number (evaluate '(+ 0 1 2))) '3)
  (check-equal? (inspect/number (evaluate '(- 3 2))) '1)
  (check-equal? (inspect/number (evaluate '(- 3 2 1))) '0)
  (check-equal? (inspect/number (evaluate '(*))) '1)
  (check-equal? (inspect/number (evaluate '(* 3))) '3)
  (check-equal? (inspect/number (evaluate '(* 3 2))) '6)
  (check-equal? (inspect/number (evaluate '(* 3 2 1))) '6)
  (check-equal? (inspect/number (evaluate '(quotient 5 2))) '2)
  (check-equal? (inspect/number (evaluate '(quotient 5 5))) '1)
  (check-equal? (inspect/number (evaluate '(expt 5 2))) '25)
  (check-equal? (inspect/boolean (evaluate '(zero? 0))) '#t)
  (check-equal? (inspect/boolean (evaluate '(zero? 5))) '#f)
  (check-equal? (inspect/boolean (evaluate '(<= 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(<= 3 2))) '#f)
  (check-equal? (inspect/boolean (evaluate '(<= 2 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(<= 3 2 1))) '#f)
  (check-equal? (inspect/boolean (evaluate '(>= 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(>= 3 2))) '#t)
  (check-equal? (inspect/boolean (evaluate '(>= 2 3))) '#f)
  (check-equal? (inspect/boolean (evaluate '(>= 3 2 1))) '#t)
  (check-equal? (inspect/boolean (evaluate '(= 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(= 3 2))) '#f)
  (check-equal? (inspect/boolean (evaluate '(= 3 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(= 3 2 1))) '#f)
  (check-equal? (inspect/boolean (evaluate '(< 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(< 3 2))) '#f)
  (check-equal? (inspect/boolean (evaluate '(< 2 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(< 3 2 1))) '#f)
  (check-equal? (inspect/boolean (evaluate '(> 3))) '#t)
  (check-equal? (inspect/boolean (evaluate '(> 3 2))) '#t)
  (check-equal? (inspect/boolean (evaluate '(> 2 3))) '#f)
  (check-equal? (inspect/boolean (evaluate '(> 3 2 1))) '#t)

  ;; PAIRS
  (check-equal? ((inspect/pair inspect/boolean inspect/number) (evaluate '(cons #t 5))) '(#t . 5))
  (check-equal? (inspect/boolean (evaluate '(car (cons #t 5)))) '#t)
  (check-equal? (inspect/number (evaluate '(cdr (cons #t 5)))) '5)

  ;; LISTS
  (check-equal? ((inspect/list inspect/number) (evaluate 'null)) '())
  (check-equal? ((inspect/list inspect/number) (evaluate 'empty)) '())
  (check-equal? (inspect/boolean (evaluate '(null? null))) '#t)
  (check-equal? (inspect/boolean (evaluate '(null? (cons #t 5)))) '#f)
  (check-equal? ((inspect/list inspect/number) (evaluate '(list))) '())
  (check-equal? ((inspect/list inspect/number) (evaluate '(list 1))) '(1))
  (check-equal? ((inspect/list inspect/number) (evaluate '(list 1 2))) '(1 2))
  (check-equal? (inspect/number (evaluate '(first (list 1 2)))) '1)
  (check-equal? ((inspect/list inspect/number) (evaluate '(rest (list 1 2)))) '(2))
  (check-equal? ((inspect/list inspect/number) (evaluate '(map add1 (list 1 2)))) '(2 3))

  ;; BINDINGS
  (check-equal? (inspect/number (evaluate '(let () 5))) '5)
  (check-equal? (inspect/number (evaluate '(let ([a 5]) a))) '5)
  (check-equal? (inspect/number (evaluate '(let ([a 5] [b 4]) b))) '4)
  (check-equal? (inspect/number (evaluate '(let* () 5))) '5)
  (check-equal? (inspect/number (evaluate '(let* ([a 5]) a))) '5)
  (check-equal? (inspect/number (evaluate '(let* ([a 5] [b a]) b))) '5)
  (check-equal? (inspect/number
                 (evaluate '(letrec ([factorial (λ (n) (if (zero? n) 1 (* n (factorial (sub1 n)))))])
                              (factorial 5))))
                '120)
  (check-equal? (inspect/number (evaluate '(begin 0))) '0)
  (check-equal? (inspect/number (evaluate '(begin 0 1))) '1)

  ;; FUNCTIONS
  (check-equal? ((evaluate '(λ (x) x)) 5) '5)
  (check-equal? ((evaluate '(λ (x) null x)) 5) '5)
  (check-equal? (inspect/number ((evaluate '(λ () 5)) null)) '5)
  (check-equal? (((evaluate '(λ (x y) x)) 5) null) '5)
  (check-equal? (inspect/number (evaluate '(identity 5))) '5)
  (check-equal? (inspect/number ((evaluate '(const 5)) null)) '5)
  (check-equal? (inspect/number ((evaluate '(thunk 5)) null)) '5)
  (check-equal? (inspect/number (evaluate '((λ (x) x) 5))) '5)
  (check-equal? (inspect/number (evaluate '((λ () 5)))) '5)
  (check-equal? (inspect/number (evaluate '((λ (a b) a) 5 null))) '5))
