#lang pollen/mode racket
(require (for-syntax racket/base syntax/parse pollen/setup racket/dict racket/list racket/syntax)
         racket/string racket/format racket/function racket/list racket/dict racket/match
         racket/file file/sha1 racket/runtime-path
         libuuid gregor gregor/period sugar xml net/base64
         (except-in syntax/parse attribute) syntax/parse/define
         pollen/core pollen/file pollen/decode pollen/tag pollen/setup txexpr)

(provide (all-defined-out)
         (all-from-out
          racket/string racket/format racket/function racket/list racket/dict racket/match
          racket/file file/sha1
          libuuid gregor gregor/period sugar xml
          pollen/core pollen/file pollen/decode pollen/tag pollen/setup txexpr))

;; ---------------------------------------------------------------------------------------------------
;; SETTINGS

(define settings/title       ◊~a{Leandro Facchinetti})
(define settings/description ◊~a{Leandro Facchinetti is a writer of prose, software and songs. He is a Ph.D. candidate at the Programming Languages Laboratory, at the Johns Hopkins University. His interests are computer programming, music, books, typography, education, minimalism and veganism.})
(define settings/author      ◊~a{Leandro Facchinetti})
(define settings/email       ◊~a{me@leafac.com})
(define settings/url         ◊~a{https://www.leafac.com})

;; ---------------------------------------------------------------------------------------------------
;; TEMPLATE

(define (root . elements)
  (txexpr 'root empty
          (decode-elements elements
                           #:txexpr-elements-proc decode-paragraphs
                           #:exclude-tags '(style script pre code))))
(define style (default-tag-function 'style #:type "text/css"))

;; ---------------------------------------------------------------------------------------------------
;; FEED

; Reference: https://groups.google.com/forum/#!msg/pollenpub/4bOXKsIVzm4/RpzYRwqCAgAJ
(define (feed/new-entry)
  (displayln (~a "
◊entry[
  ◊id{" (string-downcase (~a "urn:uuid:" (uuid-generate))) "}
  ◊title{}
  ◊link[#:href ◊~a{◊|settings/url|/}]
  ◊updated{" (~t (now/moment) "yyyy-MM-dd'T'HH:mm:ssxxx") "}
  ◊summary{}
]
")))
(define feed (default-tag-function 'feed #:xmlns "http://www.w3.org/2005/Atom"))
(define link (default-tag-function 'link))

;; ---------------------------------------------------------------------------------------------------
;; OUTLINE

(define ((heading level) key . elements)
  (txexpr (string->symbol (~a "h" level)) empty
          `(,◊label[key] ,@elements ,◊heading/mark{◊reference[(~a "#" key)]{§}})))
(define section (heading 3))
(define subsection (heading 4))
(define new-thought (default-tag-function 'hr))
(define new-line (default-tag-function 'br))
(define (appendix key . elements) (apply section key `("Appendix: " ,@elements)))
(define heading/mark (default-tag-function 'span #:class "mark"))
(define time (default-tag-function 'time))

;; ---------------------------------------------------------------------------------------------------
;; FULL WIDTH

(define full-width (default-tag-function 'div #:class "full-width"))

;; ---------------------------------------------------------------------------------------------------
;; MARGIN NOTES

(define margin-note (default-tag-function 'aside))

;; ---------------------------------------------------------------------------------------------------
;; FIGURES

(define figure (default-tag-function 'figure))
(define figure/caption (default-tag-function 'figcaption))
(define (image path [caption ""]) (txexpr 'img `((src ,path) (alt ,caption))))
(define (figure/image path [caption ""])
  ◊figure{
 ◊image[path]{◊caption}
 ◊when/splice[(non-empty-string? caption)]{◊figure/caption{◊caption}}
 })
(define (svg path) (string->xexpr (file->string path)))
(define (figure/svg path [caption ""])
  ◊figure{
 ◊svg[path]
 ◊when/splice[(non-empty-string? caption)]{◊figure/caption{◊caption}}
 })

;; ---------------------------------------------------------------------------------------------------
;; CODE

(define code (default-tag-function 'code))
(define (code/block #:language [language #f] #:caption [caption #f] . elements)
  (txexpr* 'div '((class "code-block"))
           (when/splice caption (txexpr* 'span empty caption))
           (cond
             [language
              (define code (string-append* elements))
              (define digest (sha1 (open-input-string code)))
              (define path/basedir "compiled/code-block/")
              (define path/full (~a path/basedir language "-" digest ".html"))
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
             [else (txexpr 'pre empty elements)])))
(define variable (default-tag-function 'var))
(define sample (default-tag-function 'samp))
(define keyboard (default-tag-function 'kbd))

;; ---------------------------------------------------------------------------------------------------
;; LISTS

(define list/unordered (default-tag-function 'ul))
(define list/unordered/item (default-tag-function 'li))
(define list/ordered (default-tag-function 'ol))
(define list/ordered/item (default-tag-function 'li))

;; ---------------------------------------------------------------------------------------------------
;; TABLES

(define table (default-tag-function 'table))
(define table/header (default-tag-function 'thead))
(define table/body (default-tag-function 'tbody))
(define table/row (default-tag-function 'tr))
(define table/data (default-tag-function 'td))
(define table/data/header (default-tag-function 'th))

;; ---------------------------------------------------------------------------------------------------
;; REFERENCES

(define (label key) (txexpr 'span `((id ,(~a key)))))
(define (reference path . elements)
  (txexpr 'a `((href ,(~a path))) (if (empty? elements) `(,path) elements)))
(define (email address . elements)
  (apply reference (~a "mailto:" address) (if (empty? elements) `(,address) elements)))
(define citation (default-tag-function 'cite))

;; ---------------------------------------------------------------------------------------------------
;; INLINE

(define emphasis (default-tag-function 'em))
(define foreign emphasis)
(define technical-term emphasis)
(define informal emphasis)
(define path code)
(define (fraction numerator denominator)
  (txexpr* '@ empty
           (txexpr* 'sup empty (~a numerator))
           (txexpr* 'span '((class "fraction--slash")) "/")
           (txexpr* 'sub empty (~a denominator))))
(define (placeholder . elements)
  (txexpr 'span '((class "placeholder")) `("<" ,@elements ">")))
(define (menu-option . elements)
  ((default-tag-function 'span #:class "menu-option") (add-between elements " > ")))

;; ---------------------------------------------------------------------------------------------------
;; COOKING

(define ingredients/collected (make-hash))
(define (ingredients . elements)
  (define/match (tabularize ingredients)
    [(`((ingredient (name ,name ...) (quantity ,quantity ...)) ...))
     (apply table/body
            (for/list ([name (in-list name)]
                       [quantity (in-list quantity)])
              (table/row (apply table/data name) (apply table/data quantity))))])
  (match elements
    [`((group ,group ,ingredients ...) ...)
     (apply table
            (for/list ([group (in-list group)]
                       [ingredients (in-list ingredients)])
              (define table/body (tabularize ingredients))
              (dict-set! ingredients/collected group table/body)
              table/body))]
    [`(,ingredients ...) (table (tabularize ingredients))]))
(define (ingredients/repeat group) (table (dict-ref ingredients/collected group)))
(define baking/collected (box (void)))
(define (baking . elements)
  (match elements
    [`((step (temperature ,temperature ...)
             (duration ,duration ...)
             (details ,details ...) ...)
       ...)
     (set-box!
      baking/collected
      (table
       (apply
        table/body
        (for/list ([temperature (in-list temperature)]
                   [duration (in-list duration)]
                   [details (in-list details)])
          (apply
           table/row
           `(,(apply table/data temperature)
             ,(apply table/data duration)
             ,@(if (empty? details)
                   empty
                   `(,(apply table/data (first details))))))))))
     (baking/repeat)]))
(define (baking/repeat) (unbox baking/collected))
(define directions list/ordered)
(define direction list/ordered/item)
(define sources list/unordered)
(define source list/unordered/item)

;; ---------------------------------------------------------------------------------------------------
;; MUSIC

(define lyrics code/block)

;; ---------------------------------------------------------------------------------------------------
;; CSS HELPERS

(define (px->rem px #:html/font-size [html/font-size 16])
  (~a (~r #:precision 2 (/ px html/font-size)) "rem"))

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

;; |                bigger-screens                   |
;; |                     1024                        |
;; |         |           body              |         |
;; |         |           1000              |         |
;; | padding | main | gutter | margin-note | padding |
;; |   12    | 600  |   75   |     325     |   12    |
;;                  |   margin-note/pull   |
;;                  |         400          |

;; |     smaller-screens      |
;; |           624            |
;; | padding | main | padding |
;; |   12    | 600  |   12    |

(define grid/body             ◊px->rem[1000])
(define grid/padding          ◊px->rem[12])
(define grid/main             ◊px->rem[600])
(define grid/gutter           ◊px->rem[75])
(define grid/margin-note      ◊px->rem[325])
(define grid/margin-note/pull ◊px->rem[400])
(define grid/bigger-screens   ◊~a{(min-width:◊px->rem[1024])})
(define grid/smaller-screens  ◊~a{(max-width:◊px->rem[1023])})

;; ---------------------------------------------------------------------------------------------------
;; SPACES

(define space/none              ◊~a{0})
(define space/extra-extra-small ◊~a{0.1rem})
(define space/extra-small       ◊~a{0.2rem})
(define space/small             ◊~a{0.5rem})
(define space/medium            ◊~a{1rem})
(define space/large             ◊~a{1.5rem})
(define space/extra-large       ◊~a{2rem})

;; ---------------------------------------------------------------------------------------------------
;; TEXT

(define font-family/main            ◊~a{"Charter", "Iowan Old Style", "Georgia", serif})
(define font-family/monospace       ◊~a{"Fira Mono", "Menlo", "Monaco", "Courier New", monospace})
(define font-size/extra-small       ◊px->rem[12])
(define font-size/small             ◊px->rem[13])
(define font-size/medium            ◊px->rem[16])
(define font-size/large             ◊px->rem[20])
(define font-size/extra-large       ◊px->rem[22])
(define font-size/extra-extra-large ◊px->rem[30])
(define line-height/extra-small     ◊~a{1})
(define line-height/small           ◊~a{1.3})
(define line-height/medium          ◊~a{1.5})
(define line-height/large           ◊~a{2})
(define text-indent                 ◊~a{1.5rem})
(define letter-spacing              ◊~a{0.2em})

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

(define color/background           ◊solarized/base3)
(define color/background-highlight ◊solarized/base2)
(define color/secondary-content    ◊solarized/base1)
(define color/primary-content      ◊solarized/base00)
(define color/emphasized-content   ◊solarized/base01)
(define color/yellow               ◊solarized/yellow)
(define color/orange               ◊solarized/orange)
(define color/red                  ◊solarized/red)
(define color/magenta              ◊solarized/magenta)
(define color/violet               ◊solarized/violet)
(define color/blue                 ◊solarized/blue)
(define color/cyan                 ◊solarized/cyan)
(define color/green                ◊solarized/green)

;; ---------------------------------------------------------------------------------------------------
;; BORDERS

(define border-width/thin  ◊~a{1px})
(define border-width/thick ◊~a{3px})
(define border-radius/none ◊space/none)
(define border-radius      ◊space/extra-small)

;; ---------------------------------------------------------------------------------------------------
;; ANIMATIONS

(define animation/duration ◊~a{0.3s})

;; ---------------------------------------------------------------------------------------------------
;; MIXINS

(define inline-block-enumeration
  ◊~a{
 line-height: ◊|line-height/large|;
 display: inline-block;
 margin-right: ◊|space/medium|;
 })

(define insertion
  ◊~a{
 box-sizing: border-box;
 width: 100%;
 margin: ◊|space/small| ◊|space/none|;
 })
