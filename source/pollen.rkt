#lang pollen/mode racket
(require (for-syntax racket/base syntax/parse pollen/setup racket/dict racket/list racket/syntax)
         racket/string racket/format racket/function racket/list racket/dict racket/match
         racket/file file/sha1 racket/runtime-path
         css-expr libuuid gregor gregor/period sugar xml net/base64
         (except-in syntax/parse attribute) syntax/parse/define
         pollen/core pollen/file pollen/decode pollen/tag pollen/setup pollen-component)

(provide (all-defined-out)
         (all-from-out
          racket/string racket/format racket/function racket/list racket/dict racket/match
          racket/file file/sha1
          css-expr libuuid gregor gregor/period sugar xml
          pollen/core pollen/file))

;; ---------------------------------------------------------------------------------------------------
;; PERSONAL DATA

(define personal-data
  (let ([date-of-birth (date 1990 10 20)])
    `#hash((name           . ,◊~a{Leandro Facchinetti})
           (author         . ,◊~a{Leandro Facchinetti})
           (github-handle  . ,◊~a{leafac})
           (personal-email . ,◊~a{me@leafac.com})
           (work-email     . ,◊~a{leandro@jhu.edu})
           (skype-handle   . ,◊~a{leafac})
           (phone-number   . ,◊~a{+14107799526})
           (description    . ,◊~a{Leandro Facchinetti is a writer of prose, software and songs. He is a Ph.D. candidate at the Programming Languages Laboratory, at the Johns Hopkins University. His interests are computer programming, music, books, typography, education, minimalism and veganism.})
           (date-of-birth  . ,date-of-birth)
           (age            . ,(period-ref (period-between date-of-birth (today)) 'years)))))

;; ---------------------------------------------------------------------------------------------------
;; AUXILIARY

;; Paths

(define base-url "https://www.leafac.com/")
(define-runtime-path project-path "./")
(define (source-path path) (~a project-path path))

;; ---------------------------------------------------------------------------------------------------
;; COMPONENTS

(components-output-types #:dynamic html atom)

;; ---------------------------------------------------------------------------------------------------
;; TEMPLATE

(define-component (root . elements)
  #:html
  (define elements/with-paragraphs
    (decode-elements
     elements
     #:txexpr-elements-proc
     (λ (elements)
       (filter-not (curry equal? '(p "\n")) (decode-paragraphs elements #:linebreak-proc values)))
     #:exclude-tags '(pre code)))
  (define elements/with-paragraphs/with-merged-classes
    (decode-elements
     elements/with-paragraphs
     #:txexpr-attrs-proc
     (λ (attributes)
       (define-values (classes non-classes)
         (partition (match-lambda [`(,key ,_) (equal? 'class key)]) attributes))
       (define classes/strings (map second classes))
       (define classes/concatenated (string-join classes/strings " "))
       (if (empty? classes) non-classes `((class ,classes/concatenated) ,@non-classes)))))
  (apply (default-tag-function 'root) elements/with-paragraphs/with-merged-classes))

;; ---------------------------------------------------------------------------------------------------
;; WRITING

;; Outline

(define-component (section key . elements)
  #:html (apply heading 'h3 key elements))

(define-component (subsection key . elements)
  #:html (apply heading 'h4 key elements))

(define-component new-thought
  #:html (default-tag-function 'div #:class "new-thought"))

(define-component new-line
  #:html (default-tag-function 'br))

(define-component (appendix key . elements)
  #:html (apply section key `("Appendix: " ,@elements)))

(define-component (heading type key . elements)
  #:html
  (apply (default-tag-function type) `(,(label key) ,@elements ,(heading/mark (reference key "§")))))

(define-component (heading/mark . elements)
  #:html (apply (default-tag-function 'span #:class "mark") elements))

;; Full width

(define-component full-width
  #:html (default-tag-function 'div #:class "full-width"))

;; Margin notes

(define-component margin-note
  #:html (default-tag-function 'aside))

;; Figures

(define-component figure
  #:html (default-tag-function 'figure))

(define-component figure/caption
  #:html (default-tag-function 'figcaption))

(define-component (image path [caption ""])
  #:html ((default-tag-function 'img) #:src path #:alt caption))

(define-component (figure/image path [caption ""])
  #:html
  (figure (image path caption) (when/splice (non-empty-string? caption) (figure/caption caption))))

(define-component (svg path)
  #:html (string->xexpr (file->string path)))

(define-component (figure/svg path [caption ""])
  #:html (figure (svg path) (when/splice (non-empty-string? caption) (figure/caption caption))))

;; Code

(define-component code
  #:html (default-tag-function 'code))

(define-component (code/block #:language [language #f] #:caption [caption #f] . elements)
  #:html
  ((default-tag-function 'div #:class "code-block")
   (if caption ((default-tag-function 'span) caption) "")
   (cond
     [language
      (define code (string-append* elements))
      (define digest (sha1 (open-input-string code)))
      (define path/basedir "compiled/code-block/")
      (define path/full (~a path/basedir language "-" digest  ".html"))
      (define code/highlighted
        (cond
          [(file-exists? path/full) (file->string path/full)]
          [else
           (define code/highlighted
             (with-input-from-string code
               (λ ()
                 (with-output-to-string
                   (λ ()
                     (system (~a "pygmentize -f html -l " language)))))))
           (make-directory* path/basedir)
           (with-output-to-file path/full
             (λ () (display code/highlighted)))
           code/highlighted]))
      (string->xexpr code/highlighted)]
     [else ((default-tag-function 'pre) (apply code elements))])))

;; Lists

(define-component list/unordered
  #:html (default-tag-function 'ul))

(define-component list/unordered/item #:html (default-tag-function 'li))

(define-component list/ordered
  #:html (default-tag-function 'ol))

(define-component list/ordered/item #:html (default-tag-function 'li))

;; Tables

(define-component table
  #:html (default-tag-function 'table))

(define-component table/header #:html (default-tag-function 'thead))

(define-component table/body
  #:html (default-tag-function 'tbody))

(define-component table/row #:html (default-tag-function 'tr))

(define-component table/data
  #:html (default-tag-function 'td))

(define-component table/data/header
  #:html (default-tag-function 'th))

;; Links

(define-component (link path . elements)
  #:html (apply (default-tag-function 'a) #:href path (if (empty? elements) `(,path) elements)))

;; References

(define-component (label key)
  #:html ((default-tag-function 'span) #:id (~a key)))

(define-component (reference key . elements)
  #:html (apply link (~a "#" key) elements))

;; Data

(define-component (email address . elements)
  #:html (apply link (~a "mailto:" address) (if (empty? elements) `(,address) elements)))

(define-component (github-user handle)
  #:html (link (~a "https://github.com/" handle) (~a "@" handle)))

(define-component (skype-user handle)
  #:html ((default-tag-function 'em) handle))

(define-component (phone number)
  #:html ((default-tag-function '@) number))

(define-component publication #:html emphasis)

(define-component time
  #:html (default-tag-function 'time))

;; Inline elements

(define-component emphasis
  #:html (default-tag-function 'em))

(define-component foreign #:html emphasis)

(define-component technical-term #:html emphasis)

(define-component informal #:html emphasis)

(define-component keyboard
  #:html (default-tag-function 'kbd))

(define-component path
  #:html (default-tag-function 'code))

(define-component (fraction numerator denominator)
  #:html ((default-tag-function 'span #:class "fraction")
          ((default-tag-function 'span) #:class "numerator" (~a numerator))
          ((default-tag-function 'span) #:class "slash" "/")
          ((default-tag-function 'span) #:class "denominator" (~a denominator))))

(define-component (placeholder . elements)
  #:html (apply (default-tag-function 'span #:class "placeholder") `("<" ,@elements ">")))

(define-component (menu-option . elements)
  #:html ((default-tag-function 'span #:class "menu-option") (add-between elements " > ")))

;; ---------------------------------------------------------------------------------------------------
;; COOKING

(define-component (recipes . elements)
  #:html (apply list/unordered #:class "recipes" elements))

(define-component (recipe path . elements)
  #:html (list/unordered/item #:class "recipe" (apply link (~a "/cooking/" path) elements)))

(define ingredients/collected (make-hash))

(define-component ingredients #:html table)

(define-component (ingredients/section name . elements)
  #:html
  (dict-set! ingredients/collected name elements)
  (apply table/body elements))

(define-component ingredient #:html table/row)

(define-component ingredient/name #:html table/data)

(define-component ingredient/quantity #:html table/data)

(define-component (ingredients/repeat name)
  #:html (apply ingredients (dict-ref ingredients/collected name)))

(define baking/collected (box (void)))

(define-component (baking . elements)
  #:html
  (set-box! baking/collected (table (apply table/body elements)))
  (baking/repeat))

(define-component (baking/repeat)
  #:html (unbox baking/collected))

(define-component baking-step #:html table/row)

(define-component baking-step/temperature #:html table/data)

(define-component baking-step/duration #:html table/data)

(define-component baking-step/details #:html table/data)

(define-component directions #:html list/ordered)

(define-component direction #:html list/ordered/item)

(define-component sources #:html list/unordered)

(define-component source #:html list/unordered/item)

;; ---------------------------------------------------------------------------------------------------
;; ABOUT

(define-component education #:html (default-tag-function '@))

(define-component education/title #:html subsection)

(define-component (education/institution . elements)
  #:html (apply (default-tag-function '@) `(,(apply emphasis elements) ", ")))

(define-component (education/from . elements)
  #:html (apply (default-tag-function '@) `("from " ,@elements " ")))

(define-component (education/to #:estimated? [estimated? #f] . elements)
  #:html (apply (default-tag-function '@) `("to " ,@elements ,(if estimated? " (estimated)" "") " ")))

(define-component education/highlights #:html list/unordered)

(define-component education/highlight #:html list/unordered/item)

(define-component work-experience #:html (default-tag-function '@))

(define-component work-experience/institution #:html subsection)

(define-component (work-experience/title . elements)
  #:html (apply (default-tag-function '@) `(,(apply emphasis elements) ", ")))

(define-component (work-experience/from . elements)
  #:html (apply (default-tag-function '@) `("from " ,@elements " ")))

(define-component (work-experience/to . elements)
  #:html (apply (default-tag-function '@) `("to " ,@elements " ")))

(define-component work-experience/highlights #:html list/unordered)

(define-component work-experience/highlight #:html list/unordered/item)

(define-component (skills . elements)
  #:html (apply list/unordered #:class "skills" elements))

(define-component (skill level . elements)
  #:html (apply list/unordered/item #:class (~a "skill " level) elements))

(define-component certification #:html (default-tag-function '@))

(define-component certification/title #:html subsection)

(define-component certification/date #:html (default-tag-function '@))

(define-component (certification/score . elements)
  #:html (apply (default-tag-function '@) `(,(new-line) ,@elements)))

(define-component event #:html (default-tag-function '@))

(define-component event/title #:html subsection)

(define-component event/date #:html (default-tag-function '@))

(define-component (event/from . elements)
  #:html (apply (default-tag-function '@) `("From " ,@elements)))

(define-component (event/to . elements)
  #:html (apply (default-tag-function '@) `(" to " ,@elements)))

(define-component (event/highlight . elements)
  #:html (apply (default-tag-function '@) `(,(new-line) ,@elements)))

(define-component course #:html (default-tag-function '@))

(define-component course/title #:html subsection)

(define-component (course/by . elements)
  #:html (apply (default-tag-function '@) `(,@elements ", " )))

(define-component course/date #:html (default-tag-function '@))

(define-component (course/highlight . elements)
  #:html (apply (default-tag-function '@) `(,(new-line) ,@elements)))

(define-component service/reviewer #:html (default-tag-function '@))

(define-component (service/reviewer/title . elements)
  #:html (apply (default-tag-function '@) `(,@elements ". ")))

(define-component (service/reviewer/date . elements)
  #:html (apply (default-tag-function '@) `(,@elements ".")))

(define-component publication/paper #:html (default-tag-function '@))

(define-component publication/paper/title #:html subsection)

(define-component (publication/paper/authors . elements)
  #:html (apply (default-tag-function '@) `(,@elements ".")))

(define-component (publication/paper/venue . elements)
  #:html (apply (default-tag-function '@) `(,(new-line)
                                            ,(apply emphasis elements) ". ")))

(define-component (publication/paper/date . elements)
  #:html (apply (default-tag-function '@) `(,@elements ".")))

(define-component (publication/paper/abstract . elements)
  #:html (apply (default-tag-function '@) `(,(new-line) ,@elements)))

;; ---------------------------------------------------------------------------------------------------
;; MUSIC

(define-component lyrics #:html code/block)