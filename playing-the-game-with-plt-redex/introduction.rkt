#lang racket
(require redex)

(define-language peg-solitaire)

(define-term initial-board
  ([· · ● ● ● · ·]
   [· · ● ● ● · ·]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [· · ● ● ● · ·]
   [· · ● ● ● · ·]))


;; ●  Peg
;; ○  Space
;; ·  Padding

(define
  ⇨
  (reduction-relation
   peg-solitaire

   (--> (any_1
         ...
         [any_2 ... ● ● ○ any_3 ...]
         any_4
         ...)
        (any_1
         ...
         [any_2 ... ○ ○ ● any_3 ...]
         any_4
         ...)
        "→")

   (--> (any_1
         ...
         [any_2 ... ○ ● ● any_3 ...]
         any_4
         ...)
        (any_1
         ...
         [any_2 ... ● ○ ○ any_3 ...]
         any_4
         ...)
        "←")

   (--> (any_1
         ...
         [any_2 ..._n ● any_3 ...]
         [any_4 ..._n ● any_5 ...]
         [any_6 ..._n ○ any_7 ...]
         any_8
         ...)
        (any_1
         ...
         [any_2 ...   ○ any_3 ...]
         [any_4 ...   ○ any_5 ...]
         [any_6 ...   ● any_7 ...]
         any_8
         ...)
        "↓")

   (--> (any_1
         ...
         [any_2 ..._n ○ any_3 ...]
         [any_4 ..._n ● any_5 ...]
         [any_6 ..._n ● any_7 ...]
         any_8
         ...)
        (any_1
         ...
         [any_2 ...   ● any_3 ...]
         [any_4 ...   ○ any_5 ...]
         [any_6 ...   ○ any_7 ...]
         any_8
         ...)
        "↑")))

(stepper ⇨ (term initial-board))
