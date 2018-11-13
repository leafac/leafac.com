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
  (match e
    ;; BOOLEANS
    [#t (compile `(λ (a b) a))]
    [#f (compile `(λ (a b) b))]
    [`(if ,eᶜ ,eᵗ ,eᵉ) (compile `((,eᶜ (thunk ,eᵗ) (thunk ,eᵉ))))]
    [`(and) (compile `#t)]
    [`(and ,e₁) (compile e₁)]
    [`(and ,e₁ ,e₂) (compile `(if ,e₁ ,e₂ #f))]
    [`(and ,e₁ ,e₂ ...) (compile `(and ,e₁ (and ,@e₂)))]
    [`(or) (compile `#f)]
    [`(or ,e₁) (compile e₁)]
    [`(or ,e₁ ,e₂) (compile `(if ,e₁ #t ,e₂))]
    [`(or ,e₁ ,e₂ ...) (compile `(or ,e₁ (or ,@e₂)))]
    [`not (compile `(λ (p) (λ (a b) (p b a))))]
    [`xor (compile `(λ (p q) (p (not q) q)))]

    ;; NUMBERS
    [(? (λ (n) (and (integer? n) (not (negative? n)))) n)
     (compile `(λ (f) (λ (x) ,(for/fold ([eᵇ `x]) ([i (in-range n)]) `(f ,eᵇ)))))]
    [`add1 (compile `(λ (n) (λ (f) (λ (x) (f ((n f) x))))))]
    [`sub1 (compile `(λ (n) (λ (f) (λ (x) (((n (λ (g) (λ (h) (h (g f))))) (λ (u) x)) (λ (u) u))))))]
    [`+ (compile `(λ (m n) ((n add1) m)))]
    [`(+) (compile `0)]
    [`(+ ,e₁) (compile e₁)]
    [`(+ ,e₁ ,e₂) (compile `(,(compile `+) ,(compile e₁) ,(compile e₂)))]
    [`(+ ,e₁ ... ,e₂) (compile `(+ (+ ,@e₁) ,e₂))]
    [`- (compile `(λ (m n) ((n sub1) m)))]
    [`(- ,e₁ ,e₂) (compile `(,(compile `-) ,(compile e₁) ,(compile e₂)))]
    [`(- ,e₁ ... ,e₂) #:when (not (empty? e₁)) (compile `(- (- ,@e₁) ,e₂))]
    [`* (compile `(λ (m n) (λ (f) (m (n f)))))]
    [`(*) (compile `1)]
    [`(* ,e₁) (compile e₁)]
    [`(* ,e₁ ,e₂) (compile `(,(compile `*) ,(compile e₁) ,(compile e₂)))]
    [`(* ,e₁ ... ,e₂) (compile `(* (* ,@e₁) ,e₂))]
    [`quotient
     (compile `(letrec ([quot (λ (m n) (if (<= m n) 0 (add1 (quot (- m n) n))))]) quot))]
    [`expt (compile `(λ (m n) (n m)))]
    [`zero? (compile `(λ (n) ((n (λ (x) #f)) #t)))]
    [`<= (compile `(λ (m n) (zero? (- m n))))]
    [`(<= ,e₁) (compile `(begin ,e₁ #t))]
    [`(<= ,e₁ ,e₂) (compile `(,(compile `<=) ,(compile e₁) ,(compile e₂)))]
    [`(<= ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       (compile `(let* (,@[map list x₁ e₁])
                   (and ,@(map (λ (x₂ x₃) `(<= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1))))))]
    [`>= (compile `(λ (m n) (zero? (- n m))))]
    [`(>= ,e₁) (compile `(begin ,e₁ #t))]
    [`(>= ,e₁ ,e₂) (compile `(,(compile `>=) ,(compile e₁) ,(compile e₂)))]
    [`(>= ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       (compile `(let* (,@[map list x₁ e₁])
                   (and ,@(map (λ (x₂ x₃) `(>= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1))))))]
    [`= (compile `(λ (m n) (and (<= m n) (>= m n))))]
    [`(= ,e₁) (compile `(begin ,e₁ #t))]
    [`(= ,e₁ ,e₂) (compile `(,(compile `=) ,(compile e₁) ,(compile e₂)))]
    [`(= ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       (compile `(let* (,@[map list x₁ e₁])
                   (and ,@(map (λ (x₂ x₃) `(= ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1))))))]
    [`< (compile `(λ (m n) (and (<= m n) (not (= m n)))))]
    [`(< ,e₁) (compile `(begin ,e₁ #t))]
    [`(< ,e₁ ,e₂) (compile `(,(compile `<) ,(compile e₁) ,(compile e₂)))]
    [`(< ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       (compile `(let* (,@[map list x₁ e₁])
                   (and ,@(map (λ (x₂ x₃) `(< ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1))))))]
    [`> (compile `(λ (m n) (and (>= m n) (not (= m n)))))]
    [`(> ,e₁) (compile `(begin ,e₁ #t))]
    [`(> ,e₁ ,e₂) (compile `(,(compile `>) ,(compile e₁) ,(compile e₂)))]
    [`(> ,e₁ ...)
     #:when (not (empty? e₁))
     (let ([x₁ (map (λ (x) (gensym)) e₁)])
       (compile `(let* (,@[map list x₁ e₁])
                   (and ,@(map (λ (x₂ x₃) `(> ,x₂ ,x₃)) (drop-right x₁ 1) (drop x₁ 1))))))]

    ;; PAIRS
    [`null (compile `(λ (s) (λ (x) x)))]
    [`cons (compile `(λ (a b) (λ (s) (s a b))))]
    [`null? (compile `(λ (p) ((p (λ (a b) (λ (x) #f))) #t)))]
    [`car (compile `(λ (p) (p (λ (a b) a))))]
    [`cdr (compile `(λ (p) (p (λ (a b) b))))]

    ;; LISTS
    [`empty (compile `null)]
    [`(list) (compile `empty)]
    [`(list ,eʰ ,eᵗ ...) (compile `(cons ,eʰ (list ,@eᵗ)))]
    [`first (compile `car)]
    [`rest (compile `cdr)]
    [`map (compile `(letrec ([ma (λ (f l) (if (null? l) l (cons (f (car l)) (ma f (cdr l)))))]) ma))]

    ;; BINDINGS
    [`(let ([,x ,eˣ] ...) ,eᵇ ...) (compile `((λ (,@(reverse x)) ,@eᵇ) ,@(reverse eˣ)))]
    [`(let* () ,eᵇ ...) (compile `(let () ,@eᵇ))]
    [`(let* ([,x₁ ,eˣ₁]) ,eᵇ ...) (compile `(let ([,x₁ ,eˣ₁]) ,@eᵇ))]
    [`(let* ([,x₁ ,eˣ₁] [,x₂ ,eˣ₂] ...) ,eᵇ ...)
     (compile `(let ([,x₁ ,eˣ₁]) (let* (,@[map list x₂ eˣ₂]) ,@eᵇ)))]
    [`(letrec ([,x ,eˣ]) ,eᵇ ...)
     (compile `(let ([,x ((λ (f) ((λ (x) (f (λ (v) ((x x) v)))) (λ (x) (f (λ (v) ((x x) v))))))
                          (λ (,x) ,eˣ))])
                 ,@eᵇ))]
    [`(begin ,eᵇ) (compile eᵇ)]
    [`(begin ,eᵇ₁ ,eᵇ₂ ...) (compile `(let ([,(gensym) ,eᵇ₁]) ,@eᵇ₂))]

    ;; FUNCTIONS
    [`(λ (,x) ,eᵇ) `(λ (,x) ,(compile eᵇ))]
    [`(λ (,x) ,eᵇ ...) (compile `(λ (,x) (begin ,@eᵇ)))]
    [`(λ () ,eᵇ ...) (compile `(λ (,(gensym)) ,@eᵇ))]
    [`(λ (,x₁ ,x₂ ...) ,eᵇ ...) (compile `(λ (,x₁) (λ (,@x₂) ,@eᵇ)))]
    [`identity (compile `(λ (x) x))]
    [`const (compile `(λ (a) (λ (b) a)))]
    [`(thunk ,eᵇ) (compile `(λ () ,eᵇ))]
    [`(,eᶠ ,eᵃ) `(,(compile eᶠ) ,(compile eᵃ))]
    [`(,eᶠ) (compile `(,eᶠ null))]
    [`(,eᶠ ,eᵃ₁ ,eᵃ₂ ...) (compile `((,eᶠ ,eᵃ₁) ,@eᵃ₂))]
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
(define ((inspect/pair inspector/left inspector/right) e)
  (if (inspect/boolean ((evaluate 'null?) e))
      null
      (cons (inspector/left ((evaluate 'car) e))
            (inspector/right ((evaluate 'cdr) e)))))

;; LISTS
(define ((inspect/list inspector/element) e)
  ((inspect/pair inspector/element (inspect/list inspector/element)) e))

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
             (λ (,g349006) (λ (f) (λ (x) (f x)))))
            (λ (,g349007)
              (((λ (m) (λ (n) (λ (f) (m (n f))))) n)
               (factorial
                ((λ (n)
                   (λ (f)
                     (λ (x)
                       (((n (λ (g) (λ (h) (h (g f))))) (λ (u) x)) (λ (u) u)))))
                 n)))))
           (λ (s) (λ (x) x))))))))

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
  (check-equal? (inspect/number (evaluate '(sub1 1))) '0)
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
  (check-equal? ((inspect/pair inspect/boolean inspect/number) (evaluate 'null)) '())
  (check-equal? ((inspect/pair inspect/boolean inspect/number) (evaluate '(cons #t 5))) '(#t . 5))
  (check-equal? (inspect/boolean (evaluate '(null? null))) '#t)
  (check-equal? (inspect/boolean (evaluate '(null? (cons #t 5)))) '#f)
  (check-equal? (inspect/boolean (evaluate '(car (cons #t 5)))) '#t)
  (check-equal? (inspect/number (evaluate '(cdr (cons #t 5)))) '5)

  ;; LISTS
  (check-equal? ((inspect/list inspect/number) (evaluate 'empty)) '())
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
