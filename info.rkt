#lang info

(define collection "www.leafac.com")
(define deps '("base" "rackunit-lib" "pollen" "pollen-component" "css-expr" "gregor" "libuuid"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("documentation/www.leafac.com.scrbl" ())))
(define pkg-desc "Source for Leandro Facchinetti’s personal website")
(define pkg-authors '(leafac))
