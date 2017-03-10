#lang racket
(require redex)

(define-language peg-solitaire
  (position ::= █ ○ ●)
  (board ::= ([position ...] ...)))

(module+ test
  (test-equal (redex-match? peg-solitaire board (term ([█])))
              #t)
  (test-equal (redex-match? peg-solitaire board (term ([█ ●]
                                                       [○ █])))
              #t)
  (test-equal (redex-match? peg-solitaire board (term ([█ █]
                                                       [█ ● ●])))
              #t))

(define-term initial-board
  ([█ █ ● ● ● █ █]
   [█ █ ● ● ● █ █]
   [● ● ● ● ● ● ●]
   [● ● ● ○ ● ● ●]
   [● ● ● ● ● ● ●]
   [█ █ ● ● ● █ █]
   [█ █ ● ● ● █ █]))

(define move
  (reduction-relation
   peg-solitaire
   #:domain board
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
        →)
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
        ←)
   (--> (any_1
         ...
         [any_2 ..._1 ● any_3 ...]
         [any_4 ..._1 ● any_5 ...]
         [any_6 ..._1 ○ any_7 ...]
         any_8
         ...)
        (any_1
         ...
         [any_2 ... ○ any_3 ...]
         [any_4 ... ○ any_5 ...]
         [any_6 ... ● any_7 ...]
         any_8
         ...)
        ↓)
   (--> (any_1
         ...
         [any_2 ..._1 ○ any_3 ...]
         [any_4 ..._1 ● any_5 ...]
         [any_6 ..._1 ● any_7 ...]
         any_8
         ...)
        (any_1
         ...
         [any_2 ... ● any_3 ...]
         [any_4 ... ○ any_5 ...]
         [any_6 ... ○ any_7 ...]
         any_8
         ...)
        ↑)))

(module+ test
  (test-equal (apply-reduction-relation move (term initial-board))
              '(((█ █ ● ● ● █ █)
                 (█ █ ● ● ● █ █)
                 (● ● ● ● ● ● ●)
                 (● ● ● ● ● ● ●)
                 (● ● ● ○ ● ● ●)
                 (█ █ ● ○ ● █ █)
                 (█ █ ● ● ● █ █))
                ((█ █ ● ● ● █ █)
                 (█ █ ● ○ ● █ █)
                 (● ● ● ○ ● ● ●)
                 (● ● ● ● ● ● ●)
                 (● ● ● ● ● ● ●)
                 (█ █ ● ● ● █ █)
                 (█ █ ● ● ● █ █))
                ((█ █ ● ● ● █ █)
                 (█ █ ● ● ● █ █)
                 (● ● ● ● ● ● ●)
                 (● ● ● ● ○ ○ ●)
                 (● ● ● ● ● ● ●)
                 (█ █ ● ● ● █ █)
                 (█ █ ● ● ● █ █))
                ((█ █ ● ● ● █ █)
                 (█ █ ● ● ● █ █)
                 (● ● ● ● ● ● ●)
                 (● ○ ○ ● ● ● ●)
                 (● ● ● ● ● ● ●)
                 (█ █ ● ● ● █ █)
                 (█ █ ● ● ● █ █))))

  #;
  (traces move (term initial-board))

  #;
  (stepper move (term initial-board)))

;; ---------------------------------------------------------------------------------------------------

(define (winning? board)
  (define pegs-left-on-board
    (count (curry equal? '●) (flatten board)))
  (= pegs-left-on-board 1))

(define (search-for-solution board)
  (define (step board-with-move)
    (match-define `(,_ ,board) board-with-move)
    (define next-boards-with-moves
      (apply-reduction-relation/tag-with-names move board))
    (cond
      [(empty? next-boards-with-moves)
       (and (winning? board) `(,board-with-move))]
      [else
       (define rest-of-solution
         (ormap step next-boards-with-moves))
       (and rest-of-solution
            `(,board-with-move ,@rest-of-solution))]))
  (step `("initial" ,board)))

(module+ test
  #;
  (search-for-solution (term initial-board)))