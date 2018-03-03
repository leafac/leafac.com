#lang pollen/mode racket
(require (for-syntax racket/base syntax/parse pollen/setup racket/dict racket/list racket/syntax)
         racket/string racket/format racket/function racket/list racket/dict racket/match
         racket/file file/sha1 racket/runtime-path
         libuuid gregor gregor/period sugar xml net/base64
         (except-in syntax/parse attribute) syntax/parse/define
         pollen/core pollen/file pollen/decode pollen/tag pollen/setup pollen-component)

(provide (all-defined-out)
         (all-from-out
          racket/string racket/format racket/function racket/list racket/dict racket/match
          racket/file file/sha1
          libuuid gregor gregor/period sugar xml
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
     #:exclude-tags '(style pre code)))
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

;; ---------------------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------------------

;; ---------------------------------------------------------------------------------------------------
;; HELPERS

(define (style . elements)
  (apply (default-tag-function 'style) (map ~a elements)))

(define (px->rem px #:html/font-size [html/font-size 16])
  (exact->inexact (/ px html/font-size)))

(define (prefix #:prefixes [prefixes '(moz webkit ms o)] name . values)
  (define values/string (string-join values))
  ◊~a{
 ◊(string-append*
   (for/list ([prefix prefixes])
     ◊~a{-◊|prefix|-◊|name|:◊|values/string|;}))
 ◊|name|:◊|values/string|;
 })

;; ---------------------------------------------------------------------------------------------------
;; GRID


;; |                   bigger-screens                   |
;; |                        1024                        |
;; |         |              body              |         |
;; |         |              1000              |         |
;; | padding | article | gutter | margin-note | padding |
;; |   12    |   600   |   75   |     325     |   12    |
;;                     |   margin-note/pull   |
;;                     |         400          |

;; |       smaller-screens       |
;; |             624             |
;; | padding | article | padding |
;; |   12    |   600   |   12    |


(define grid/body             (px->rem 1000))
(define grid/padding          (px->rem 12))
(define grid/article          (px->rem 600))
(define grid/gutter           (px->rem 75))
(define grid/margin-note      (px->rem 325))
(define grid/margin-note/pull (+ grid/gutter grid/margin-note))
(define grid/breakpoint       (+ grid/body (* grid/padding 2)))
(define grid/bigger-screens   ◊~a{(min-width:◊|grid/breakpoint|rem)})
(define grid/smaller-screens  ◊~a{(max-width:◊(- grid/breakpoint 0.01)rem)})

;; ---------------------------------------------------------------------------------------------------
;; SPACES

(define space/none              0)
(define space/extra-extra-small 0.1)
(define space/extra-small       0.2)
(define space/small             0.5)
(define space/medium            1)
(define space/large             1.5)
(define space/extra-large       2)

;; ---------------------------------------------------------------------------------------------------
;; TEXT

(define font-family/main            ◊~a{"Charter", "Iowan Old Style", "Georgia", serif})
(define font-family/monospace       ◊~a{"Fira Mono", "Menlo", "Monaco", "Courier New", monospace})
(define font-size/extra-small       (px->rem 12))
(define font-size/small             (px->rem 13))
(define font-size/medium            (px->rem 16))
(define font-size/large             (px->rem 20))
(define font-size/extra-large       (px->rem 22))
(define font-size/extra-extra-large (px->rem 30))
(define line-height/extra-small     1)
(define line-height/small           1.3)
(define line-height/medium          1.5)
(define line-height/large           2)
(define text-indent                 1.5)
(define letter-spacing              0.2)

;; ---------------------------------------------------------------------------------------------------
;; COLORS

(define solarized/base03  ◊~a{#002b36})
(define solarized/base02  ◊~a{#073642})
(define solarized/base01  ◊~a{#586e75})
(define solarized/base00  ◊~a{#657b83})
(define solarized/base0   ◊~a{#839496})
(define solarized/base1   ◊~a{#93a1a1})
(define solarized/base2   ◊~a{#eee8d5})
(define solarized/base3   ◊~a{#fdf6e3})
(define solarized/yellow  ◊~a{#b58900})
(define solarized/orange  ◊~a{#cb4b16})
(define solarized/red     ◊~a{#dc322f})
(define solarized/magenta ◊~a{#d33682})
(define solarized/violet  ◊~a{#6c71c4})
(define solarized/blue    ◊~a{#268bd2})
(define solarized/cyan    ◊~a{#2aa198})
(define solarized/green   ◊~a{#859900})

(define color/background           solarized/base3)
(define color/background-highlight solarized/base2)
(define color/secondary-content    solarized/base1)
(define color/primary-content      solarized/base00)
(define color/emphasized-content   solarized/base01)
(define color/yellow               solarized/yellow)
(define color/orange               solarized/orange)
(define color/red                  solarized/red)
(define color/magenta              solarized/magenta)
(define color/violet               solarized/violet)
(define color/blue                 solarized/blue)
(define color/cyan                 solarized/cyan)
(define color/green                solarized/green)

;; ---------------------------------------------------------------------------------------------------
;; BORDERS

(define border-width/thin  1)
(define border-width/thick 3)
(define border-radius/none space/none)
(define border-radius      space/extra-small)

;; ---------------------------------------------------------------------------------------------------
;; ANIMATIONS

(define animation/duration 0.3)

;; ---------------------------------------------------------------------------------------------------
;; MIXINS

(define inline-block-enumeration
  ◊~a{
 line-height: ◊|line-height/large|rem;
 display: inline-block;
 margin-right: ◊|space/medium|rem;
 })

(define insertion
  ◊~a{
 box-sizing: border-box;
 width: 100%;
 margin: ◊|space/small|rem ◊|space/none|rem;
 })
