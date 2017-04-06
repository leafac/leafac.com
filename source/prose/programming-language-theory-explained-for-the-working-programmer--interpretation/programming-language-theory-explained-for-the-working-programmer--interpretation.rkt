#lang racket

;; ---------------------------------------------------------------------------------------------------

;; MATHEMATICAL DEFINITIONS

(require redex)
(module+ test (require rackunit))

(define-language lambda-calculus
  [e ::= v x (e e)]
  [v ::= (λ (x) e)]
  [x ::= variable-not-otherwise-mentioned])

(define-term minimal-program (λ (x) x))
(define-term minimal-application ((λ (x) x) (λ (y) y)))
(define-term non-shadowing-variable-name-reuse ((λ (x) x) (λ (x) x)))
(define-term shadowing (((λ (x) (λ (x) x)) (λ (y) y)) (λ (z) z)))
(define-term open x)

(define-metafunction lambda-calculus
  → : e -> v
  [(→ v) v]
  [(→ x) ,(raise-user-error (~a "Variable not found: " (term x)))]
  [(→ (e_f e_a)) (→ (substitute e_b x v_a)) (where (λ (x) e_b) (→ e_f)) (where v_a (→ e_a))])

(define-metafunction lambda-calculus
  substitute : e x v -> e
  [(substitute (name e (λ (x) e_b)) x v) e]
  [(substitute (λ (x_1) e_b) x_2 v) (λ (x_1) (substitute e_b x_2 v))]
  [(substitute x x v) v]
  [(substitute x_1 x_2 v) x_1]
  [(substitute (e_1 e_2) x v) ((substitute e_1 x v) (substitute e_2 x v))])

(module+ test
  (test-equal (term (→ minimal-program))
              (term (λ (x) x)))

  (test-equal (term (→ minimal-application))
              (term (λ (y) y)))

  (test-equal (term (→ non-shadowing-variable-name-reuse))
              (term (λ (x) x)))

  (test-equal (term (→ shadowing))
              (term (λ (z) z)))

  (check-exn exn:fail:user? (λ () (term (→ open)))))