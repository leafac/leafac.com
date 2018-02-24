#lang pollen/mode racket
(require (for-syntax racket/base syntax/parse pollen/setup racket/dict racket/list racket/syntax)
         racket/format racket/function racket/list racket/file racket/dict racket/string file/sha1
         css-expr libuuid gregor gregor/period sugar xml net/base64
         (except-in syntax/parse attribute) syntax/parse/define
         pollen/core pollen/decode pollen/tag pollen/file pollen/setup pollen-component)

(provide (all-defined-out)
         (all-from-out racket/format racket/function racket/list racket/file racket/dict racket/string
                       file/sha1 gregor gregor/period sugar xml
                       pollen/core pollen/file
                       css-expr))

;; TODO: Get rid of dictionaries?

;; ---------------------------------------------------------------------------------------------------
;; PERSONAL DATA

(define personal-data
  (let ([date-of-birth (date 1990 10 20)])
    `((name           . ,◊~a{Leandro Facchinetti})
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

(define base-path (make-parameter ""))
(define (internal-url path) (~a (base-path) path))
(define base-absolute (make-parameter "https://www.leafac.com"))
(define (absolute-url path) (~a (base-absolute) path))
(define (source-path path) (~a (current-project-root) "/" path))

;; CSS helpers

;; TODO: Get rid of ‘modular-scale’?
;; Reference: http://www.modularscale.com/?1&em&1.2&js&table
(define (modular-scale step #:base [base 1] #:ratio [ratio 1.2])
  (* base (expt ratio step)))

(define (px->rem px #:html/font-size [html/font-size 16])
  (exact->inexact (/ px html/font-size)))

(define (prefix declaration #:prefixes [prefixes '(moz webkit ms o)])
  (syntax-parse declaration
    [(name:keyword rest:expr ...)
     (define name/datum (syntax->datum #'name))
     (define rests/datum (syntax->datum #'(rest ...)))
     (css-expr ,@(append*
                  (for/list ([a-prefix prefixes])
                    (define prefixed-name
                      (string->keyword (~a "-" a-prefix "-" (keyword->string name/datum))))
                    (css-expr ,prefixed-name ,@rests/datum)))
               ,name/datum ,@rests/datum)]))

;; Feeds

;; Reference: https://groups.google.com/forum/#!msg/pollenpub/4bOXKsIVzm4/RpzYRwqCAgAJ
(define (feed/uuid) (string-downcase (~a "urn:uuid:" (uuid-generate))))
(define (feed/date) (~t (now/moment) "yyyy-MM-dd'T'HH:mm:ssxxx"))

;; ---------------------------------------------------------------------------------------------------
;; COMPONENTS

(components-output-types #:dynamic html atom #:static css)

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
;;
;;
;; |       smaller-screens       |
;; |             624             |
;; | padding | article | padding |
;; |   12    |   600   |   12    |

(define grid/body/unitless (px->rem 1000))
(define grid/body (css-expr rem ,grid/body/unitless))
(define grid/padding/unitless (px->rem 12))
(define grid/padding (css-expr rem ,grid/padding/unitless))
(define grid/article/unitless (px->rem 600))
(define grid/article (css-expr rem ,grid/article/unitless))
(define grid/gutter/unitless (px->rem 75))
(define grid/margin-note/unitless (px->rem 325))
(define grid/margin-note (css-expr rem ,grid/margin-note/unitless))
(define grid/margin-note/pull (css-expr rem ,(- (+ grid/gutter/unitless grid/margin-note/unitless))))
(define grid/breakpoint (+ grid/body/unitless (* grid/padding/unitless 2)))
(define grid/bigger-screens (css-expr #:min-width (rem ,grid/breakpoint)))
(define grid/smaller-screens (css-expr #:max-width (rem ,(- grid/breakpoint 0.01))))

;; ---------------------------------------------------------------------------------------------------
;; SPACES

(define space/none 0)
(define space/small '0.5rem)
(define space/small/negative '-0.5rem)
(define space/medium '1rem)
(define space/medium/negative '-1rem)
(define space/large '1.5rem)
(define space/large/negative '-1.5rem)
(define space/extra-large '2rem)
(define space/extra-large/negative '-2rem)

;; ---------------------------------------------------------------------------------------------------
;; TEXT

(define-component @font-face
  #:css
  (css-expr
   [@font-face
    #:font-family "Charter"
    #:font-style normal
    #:font-weight 400
    #:font-stretch normal
    #:src ((apply url ,(internal-url "/vendor/assets/fonts/charter_regular-webfont.woff"))
           (apply format "woff"))]
   [@font-face
    #:font-family "Charter"
    #:font-style italic
    #:font-weight 400
    #:font-stretch normal
    #:src ((apply url ,(internal-url "/vendor/assets/fonts/charter_italic-webfont.woff"))
           (apply format "woff"))]
   [@font-face
    #:font-family "Charter"
    #:font-style normal
    #:font-weight 700
    #:font-stretch normal
    #:src ((apply url ,(internal-url "/vendor/assets/fonts/charter_bold-webfont.woff"))
           (apply format "woff"))]
   [@font-face
    #:font-family "Charter"
    #:font-style italic
    #:font-weight 700
    #:font-stretch normal
    #:src ((apply url ,(internal-url "/vendor/assets/fonts/charter_bold_italic-webfont.woff"))
           (apply format "woff"))]
   [@font-face
    #:font-family "Fira Mono"
    #:font-style normal
    #:font-weight 400
    #:font-stretch normal
    #:src ((apply url ,(internal-url "/vendor/assets/fonts/FiraMono-Regular.woff"))
           (apply format "woff"))]
   [@font-face
    #:font-family "Fira Mono"
    #:font-style normal
    #:font-weight 500
    #:font-stretch normal
    #:src ((apply url ,(internal-url "/vendor/assets/fonts/FiraMono-Medium.woff"))
           (apply format "woff"))]))

(define font-family/main
  (css-expr #:font-family "Charter" "Iowan Old Style" "Georgia" serif))
(define font-family/monospace
  (css-expr #:font-family "Fira Mono" "Menlo" "Monaco" "Courier New" monospace))
(define font-size/extra-small (css-expr rem ,(px->rem 12)))
(define font-size/small (css-expr rem ,(px->rem 13)))
(define font-size/medium (css-expr rem ,(px->rem 16)))
(define font-size/large (css-expr rem ,(px->rem 20)))
(define font-size/extra-large (css-expr rem ,(px->rem 22)))
(define font-size/extra-extra-large (css-expr rem ,(px->rem 30)))
(define line-height/small 1.3)
(define line-height/medium 1.5)
(define line-height/large 2)
(define text-indent '1.5rem)
(define letter-spacing '0.2em)

;; ---------------------------------------------------------------------------------------------------
;; COLORS

(define solarized
  '((base03  . |#002b36|)
    (base02  . |#073642|)
    (base01  . |#586e75|)
    (base00  . |#657b83|)
    (base0   . |#839496|)
    (base1   . |#93a1a1|)
    (base2   . |#eee8d5|)
    (base3   . |#fdf6e3|)
    (yellow  . |#b58900|)
    (orange  . |#cb4b16|)
    (red     . |#dc322f|)
    (magenta . |#d33682|)
    (violet  . |#6c71c4|)
    (blue    . |#268bd2|)
    (cyan    . |#2aa198|)
    (green   . |#859900|)))

(define colors
  `((background           . ,(dict-ref solarized 'base3))
    (background-highlight . ,(dict-ref solarized 'base2))
    (secondary-content    . ,(dict-ref solarized 'base1))
    (primary-content      . ,(dict-ref solarized 'base00))
    (emphasized-content   . ,(dict-ref solarized 'base01))
    (yellow               . ,(dict-ref solarized 'yellow))
    (orange               . ,(dict-ref solarized 'orange))
    (red                  . ,(dict-ref solarized 'red))
    (magenta              . ,(dict-ref solarized 'magenta))
    (violet               . ,(dict-ref solarized 'violet))
    (blue                 . ,(dict-ref solarized 'blue))
    (cyan                 . ,(dict-ref solarized 'cyan))
    (green                . ,(dict-ref solarized 'green))))

;; ---------------------------------------------------------------------------------------------------
;; RULERS

(define ruler/thin/unitless 1)
(define ruler/thin (css-expr px ,ruler/thin/unitless))
(define ruler/thin/negative (css-expr px ,(- ruler/thin/unitless)))
(define ruler/thick/unitless 3)
(define ruler/thick (css-expr px ,ruler/thick/unitless))
(define ruler/thick/negative (css-expr px ,(- ruler/thick/unitless)))

;; ---------------------------------------------------------------------------------------------------
;; ANIMATIONS

(define animation/duration '0.3s)

;; ---------------------------------------------------------------------------------------------------
;; MIXINS

(define inline-block-enumeration
  (css-expr
   #:line-height ,line-height/large
   #:display inline-block
   #:margin-right ,space/medium
   [(: & last-child) #:margin-right ,space/none]))

(define show-on-hover
  (css-expr #:transition (opacity ,animation/duration)
            #:opacity 0
            [(> *:hover &) #:opacity 1]))

(define (section/flag label color)
  (css-expr
   #:border-left (,ruler/thick solid ,color)
   #:position relative
   [(:: & before)
    #:content ,label
    #:text-transform uppercase
    #:letter-spacing ,letter-spacing
    #:font-size ,font-size/small
    #:line-height 1
    #:background-color ,color
    #:color ,(dict-ref colors 'background)
    #:display inline-block
    #:padding (#:bottom 0.1em #:left 0.2em)
    #:position absolute
    #:left ,ruler/thick/negative
    #:top ,space/none
    ,@(prefix (css-expr #:transform ((apply rotate -90deg) (apply translate -100% 0))))
    ,@(prefix (css-expr #:transform-origin (top left)))]))

(define insertion
  (css-expr
   #:box-sizing border-box
   #:width 100%
   #:margin (,space/small ,space/none)))

;; ---------------------------------------------------------------------------------------------------
;; TEMPLATE

(define-component (root . elements)
  #:html
  (define elements/with-paragraphs
    (decode-elements
     elements
     #:txexpr-elements-proc
     (λ (elements)
       (filter-not (curry equal? '(p "\n"))
                   (decode-paragraphs elements #:linebreak-proc values)))
     #:exclude-tags '(pre code)))
  (define elements/with-paragraphs/with-merged-classes
    (decode-elements
     elements/with-paragraphs
     #:txexpr-attrs-proc
     (λ (attributes)
       (define-values (classes non-classes)
         (partition (λ (attribute) (equal? 'class (car attribute))) attributes))
       (define classes/strings (map second classes))
       (define classes/concatenated (string-join classes/strings " "))
       (if (empty? classes)
           non-classes
           (cons `(class ,classes/concatenated) non-classes)))))
  (apply (default-tag-function 'root) elements/with-paragraphs/with-merged-classes)

  #:css (css-expr [* *::before *::after #:outline none]))

(define-component head/link #:html (default-tag-function 'link))

(define-component head/title #:html (default-tag-function 'title))

(define-component header/body
  #:css
  (css-expr
   [body>header
    [h1 #:font-size ,font-size/extra-extra-large]
    #:border-bottom (,ruler/thin solid ,(dict-ref colors 'secondary-content))
    #:margin-bottom ,space/extra-large]))

(define-component navigation #:html (default-tag-function 'nav))

(define-component (menu . elements)
  #:html (apply navigation #:class "menu" elements)
  #:css
  (css-expr
   [.menu
    #:font-size ,font-size/small
    #:text-transform uppercase
    #:letter-spacing ,letter-spacing
    #:margin-bottom ,space/small
    [a
     #:text-decoration none
     ,@inline-block-enumeration]]))

(define-component header/article
  #:css
  (css-expr
   [article>header
    [h1 #:font-size ,font-size/extra-large]
    #:margin-bottom ,space/medium]))

(define-component time
  #:html (default-tag-function 'time)
  #:css
  (css-expr
   [time
    #:font-size ,font-size/small
    #:color ,(dict-ref colors 'secondary-content)]))

(define-component body
  #:css
  (css-expr
   [body
    ,@(prefix (css-expr #:font-synthesis none))
    ,@(prefix (css-expr #:font-kerning normal))
    ,@(prefix (css-expr #:text-rendering optimizeLegibility))
    ,@font-family/main
    #:font-size ,font-size/medium
    #:line-height ,line-height/medium
    #:margin (,space/large auto)
    #:padding (,space/none ,grid/padding)
    #:max-width ,grid/article
    [@media ,grid/bigger-screens
     #:max-width ,grid/body
     [article #:width ,grid/article]]
    #:background-color ,(dict-ref colors 'background)
    #:color ,(dict-ref colors 'primary-content)]
   [p
    #:margin ,space/none
    [(+ p &) #:text-indent ,text-indent]
    [@media ,grid/bigger-screens
     [(+ p aside &) (+ p aside aside &) (+ p aside aside aside &) (+ p aside aside aside aside &)
      #:text-indent ,text-indent]]]))

;; ---------------------------------------------------------------------------------------------------
;; WRITING

;; Headings

(define-component (section key . elements)
  #:html (apply heading 'h1 key elements)
  #:css
  (css-expr
   [h1
    #:font-size ,font-size/large
    #:font-style italic
    #:font-weight 400]))

(define-component (subsection key . elements)
  #:html (apply heading 'h2 key elements)
  #:css
  (css-expr
   [h2
    #:font-size ,font-size/medium
    #:font-weight 700]))

(define-component new-thought
  #:html (default-tag-function 'div #:class "new-thought")
  #:css (css-expr [.new-thought #:height ,space/extra-large]))

(define-component (appendix key . elements)
  #:html (apply section key `("Appendix: " ,@elements)))

(define-component (heading type key . elements)
  #:html
  (apply (default-tag-function type) `(,(label key) ,@elements ,(heading/mark (reference key "§"))))
  #:css
  (css-expr
   [h1 h2
    #:margin (#:top ,space/extra-large #:bottom ,space/small)
    #:line-height ,line-height/small
    [a #:text-decoration none]]))

(define-component (heading/mark . elements)
  #:html (apply (default-tag-function 'span #:class "heading--mark") elements)
  #:css
  (css-expr
   [.heading--mark
    ,@show-on-hover
    #:margin-left ,space/small
    [a #:color ,(dict-ref colors 'secondary-content)]]))

;; Links

(define-component (link path . elements)
  #:html (apply (default-tag-function 'a) #:href path (if (empty? elements) `(,path) elements))
  #:css
  (css-expr
   [a
    #:transition (background-color ,animation/duration)
    #:color ,(dict-ref colors 'primary-content)
    [(: & hover)
     #:background-color ,(dict-ref colors 'background-highlight)
     #:color ,(dict-ref colors 'emphasized-content)]
    [@media ,grid/smaller-screens
     [(aside &)
      #:color ,(dict-ref colors 'emphasized-content)
      [(: & hover)
       #:background-color ,(dict-ref colors 'background)
       #:color ,(dict-ref colors 'primary-content)]]]]))

(define-component (link/internal path . elements) #:html (apply link (internal-url path) elements))

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

;; Full width

(define-component full-width
  #:html (default-tag-function 'div #:class "full-width")
  #:css
  (css-expr
   [.full-width
    ,@insertion
    #:clear both
    [@media ,grid/bigger-screens #:width ,grid/body]]))

;; Margin notes

(define-component margin-note
  #:html (default-tag-function 'aside)
  #:css
  (css-expr
   [aside
    [@media ,grid/smaller-screens
     ,@insertion
     #:padding ,text-indent (#:left (apply calc (- ,text-indent ,ruler/thick)))
     #:color ,(dict-ref colors 'emphasized-content)
     #:background-color ,(dict-ref colors 'background-highlight)
     #:border-left (,ruler/thick solid ,(dict-ref colors 'secondary-content))]
    [@media ,grid/bigger-screens
     #:font-size ,font-size/small
     #:width ,grid/margin-note
     #:float right
     #:clear right
     #:margin (#:right ,grid/margin-note/pull #:bottom ,space/large)]]))

;; TODO: Add ‘foot-note’.
;; TODO: Generalize ‘side-note’. (But with better names than these.)

;; Figures

(define-component figure
  #:html (default-tag-function 'figure)
  #:css (css-expr [figure ,@insertion #:text-align center]))

(define-component figure/caption
  #:html (default-tag-function 'figcaption)
  #:css (css-expr [figcaption #:font-style italic]))

(define-component (image path [caption ""])
  #:html ((default-tag-function 'img) #:src path #:alt caption)
  #:css (css-expr [img #:max-width 100%]))

(define-component (figure/image path [caption ""])
  #:html (figure (image path caption) (figure/caption caption)))

(define-component (svg path)
  #:html (string->xexpr (file->string path))
  #:css (css-expr [svg #:max-width 100% #:height auto]))

(define-component (figure/svg path [caption ""])
  #:html (figure (svg path) (figure/caption caption)))

;; Code

(define-component code
  #:html (default-tag-function 'code)
  #:css (css-expr [code ,@font-family/monospace]))

(define-component (code/block #:language [language #f] #:caption [caption #f] . elements)
  #:html
  ((default-tag-function 'div #:class "code-block")
   (if caption ((default-tag-function 'span #:class "caption") caption) "")
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
     [else ((default-tag-function 'pre) (apply code elements))]))
  #:css
  (css-expr
   [.code-block
    ,@insertion
    #:font-size ,font-size/extra-small
    [.caption
     #:display inline-block
     #:border (,ruler/thin solid ,(dict-ref colors 'secondary-content))
     #:padding (,space/small ,text-indent) (#:left (apply calc (- ,text-indent ,ruler/thin)))
     #:margin-bottom -1px]]
   [pre
    ,@font-family/monospace
    #:margin ,space/none
    #:overflow auto
    #:border (,ruler/thin solid ,(dict-ref colors 'secondary-content))
    #:padding ,text-indent (#:left (apply calc (- ,text-indent ,ruler/thin)))]))

;; Lists

(define-component list/unordered
  #:html (default-tag-function 'ul)
  #:css (css-expr [ul ,@insertion]))

(define-component list/unordered/item #:html (default-tag-function 'li))

(define-component list/ordered
  #:html (default-tag-function 'ol)
  #:css (css-expr [ol ,@insertion]))

(define-component list/ordered/item #:html (default-tag-function 'li))

(define-component lists
  #:css
  (css-expr
   [ul ol
    #:padding-left ,text-indent]))

;; Tables

(define-component table
  #:html (default-tag-function 'table)
  #:css (css-expr [table ,@insertion]))

(define-component table/aligned-last-data
  #:css
  (css-expr
   [(.table--aligned-last-data td:last-child)
    #:width 40%
    #;[(ol &) (ul &) ;; FIXME
       #:width (apply calc (- 40% 40px))]]))

(define-component table/header #:html (default-tag-function 'thead))

(define-component table/body
  #:html (default-tag-function 'tbody)
  #:css
  (css-expr
   [tbody+tbody::before
    #:content ""
    #:display block
    #:margin-top (rem ,(modular-scale -4))]))

(define-component table/row #:html (default-tag-function 'tr))

(define-component table/data
  #:html (default-tag-function 'td)
  #:css (css-expr [td #:padding 0 (#:right ,grid/padding)]))

(define-component table/data/header
  #:html (default-tag-function 'th)
  #:css
  (css-expr
   [th
    #:font-weight 700
    #:text-align left
    #:padding 0 (#:right ,grid/padding)]))

;; ---------------------------------------------------------------------------------------------------

(define-component keyboard
  #:html (default-tag-function 'kbd)
  #:css (css-expr [kbd ,@font-family/monospace]))

(define-component path
  #:html (default-tag-function 'code))

(define-component emphasis
  #:html (default-tag-function 'em))

(define-component foreign #:html emphasis)

(define-component technical-term #:html emphasis)

(define-component new-line
  #:html (default-tag-function 'br))

(define-component big-separation
  #:css (css-expr [.big-separation #:margin-bottom (rem ,(modular-scale 5))]))

(define-component (fraction numerator denominator)
  #:html `(span
           (span ((class "fraction--numerator")) ,(~a numerator))
           (span ((class "fraction--slash")) "/")
           (span ((class "fraction--denominator")) ,(~a denominator)))
  #:css
  (css-expr
   [.fraction--numerator .fraction--denominator
    #:font-size 0.8em]
   [.fraction--numerator #:vertical-align super]
   [.fraction--denominator #:vertical-align sub]
   [.fraction--slash #:margin (#:left -0.1em #:right -0.1em)]))

(define-component production #:html emphasis)

(define-component informal #:html emphasis)

(define-component publication #:html emphasis)

(define-component (placeholder . elements)
  #:html (apply (default-tag-function 'span #:class "placeholder") `("<" ,@elements ">"))
  #:css (css-expr [.placeholder #:color ,(dict-ref colors 'blue)]))

(define-component menu-option
  #:html (default-tag-function 'span #:class "menu-option")
  #:css (css-expr [.menu-option #:font-style italic]))

(define-component (menu-option/path . elements)
  #:html (apply menu-option (add-between elements " > ")))

;; ---------------------------------------------------------------------------------------------------
;; COOKING

(define-component (recipes . elements)
  #:html (apply list/unordered #:class "recipes" elements)
  #:css (css-expr [.recipes ,@(prefix (css-expr #:column-count 2)) #:padding-left 0]))

(define-component (recipe path . elements)
  #:html (list/unordered/item #:class "recipe"
                              (apply link/internal (~a "/cooking/" path) elements))
  #:css
  (css-expr
   [.recipe
    #:list-style none
    #:margin-bottom (rem ,(modular-scale -4))
    [a #:text-decoration none]]))

(define ingredients/collected (make-hash))

(define-component (ingredients . elements)
  #:html (apply table #:class "table--aligned-last-data" elements))

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
  (set-box! baking/collected (table #:class "table--aligned-last-data" (apply table/body elements)))
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

(define-component education #:html (default-tag-function 'div #:class "big-separation"))

(define-component education/title #:html subsection)

(define-component (education/institution . elements)
  #:html (apply (default-tag-function '@) `(,(apply emphasis elements) ", ")))

(define-component (education/from . elements)
  #:html (apply (default-tag-function '@) `("from " ,@elements " ")))

(define-component (education/to . elements)
  #:html (apply (default-tag-function '@) `("to " ,@elements " ")))

(define-component (education/to/estimation . elements)
  #:html (apply education/to `(,@elements " (estimated)")))

(define-component education/highlights #:html list/unordered)

(define-component education/highlight #:html list/unordered/item)

(define-component work-experience #:html (default-tag-function 'div #:class "big-separation"))

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
  #:html (apply list/unordered #:class "skills" elements)
  #:css (css-expr [.skills #:padding-left 0]))

(define-component (skill level . elements)
  #:html (apply list/unordered/item #:class (~a "skill " level) elements)
  #:css
  (css-expr
   [.skill
    ,@inline-block-enumeration]
   [.skill::before
    #:content ""
    #:display inline-block
    #:margin-right (rem ,(modular-scale -8))
    #:border-left ((rem ,(modular-scale -5)) solid)]
   [.beginner::before
    #:height .3em
    #:border-left-color ,(dict-ref colors 'red)]
   [.intermediate::before
    #:height .6em
    #:border-left-color ,(dict-ref colors 'yellow)]
   [.advanced::before
    #:height .9em
    #:border-left-color ,(dict-ref colors 'green)]))

(define-component certification #:html (default-tag-function 'div #:class "big-separation"))

(define-component certification/title #:html subsection)

(define-component certification/date #:html (default-tag-function '@))

(define-component (certification/score . elements)
  #:html (apply (default-tag-function '@) `(,(new-line) ,@elements)))

(define-component event #:html (default-tag-function 'div #:class "big-separation"))

(define-component event/title #:html subsection)

(define-component event/date #:html (default-tag-function '@))

(define-component (event/from . elements)
  #:html (apply (default-tag-function '@) `("From " ,@elements)))

(define-component (event/to . elements)
  #:html (apply (default-tag-function '@) `(" to " ,@elements)))

(define-component (event/highlight . elements)
  #:html (apply (default-tag-function '@) `(,(new-line) ,@elements)))

(define-component course #:html (default-tag-function 'div #:class "big-separation"))

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

(define-component publication/paper #:html (default-tag-function 'div #:class "big-separation"))

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

(define-component (lyrics . elements)
  #:html (full-width (apply code/block elements)))

;; ---------------------------------------------------------------------------------------------------
;; PROSE

;; Git by Analogy

(define-component git/verb
  #:html (default-tag-function 'span #:class "git--verb")
  #:css (css-expr [.git--verb #:color ,(dict-ref colors 'blue)]))

(define-component git/object
  #:html (default-tag-function 'span #:class "git--object")
  #:css (css-expr [.git--object #:color ,(dict-ref colors 'green)]))

(define-component git/gui
  #:html (default-tag-function 'div #:class "git--gui")
  #:css (css-expr [.git--gui ,@(section/flag "GUI" (dict-ref colors 'violet))]))

(define-component git/cli
  #:html (default-tag-function 'div #:class "git--cli")
  #:css (css-expr [.git--cli ,@(section/flag "CLI" (dict-ref colors 'yellow))]))
