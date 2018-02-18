#lang pollen/mode racket
(require (for-syntax racket/base syntax/parse pollen/setup racket/dict racket/list racket/syntax)
         racket/function racket/list racket/file racket/dict racket/string file/sha1
         css-expr libuuid gregor gregor/period sugar xml net/base64
         (except-in syntax/parse attribute) syntax/parse/define
         pollen/core pollen/decode pollen/tag pollen/file pollen/setup pollen-component)

(provide (all-defined-out)
         (all-from-out racket/function racket/list racket/file racket/dict racket/string file/sha1
                       gregor gregor/period sugar xml
                       pollen/core pollen/file
                       css-expr))

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

(define (in-steps start end steps)
  (for/list ([step (in-range (add1 steps))])
    (exact->inexact (+ start (* step (/ (- end start) steps))))))

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

(define (feed/uuid) (string-downcase (~a "urn:uuid:" (uuid-generate))))

;; Reference: https://groups.google.com/forum/#!msg/pollenpub/4bOXKsIVzm4/RpzYRwqCAgAJ
(define (feed/date) (~t (now/moment) "yyyy-MM-dd'T'HH:mm:ssxxx"))

;; ---------------------------------------------------------------------------------------------------
;; FONTS

; 400, 400 italic, 700
(define font/serif
  (css-expr #:font-family "Charter" "Iowan Old Style" "Georgia" serif))

; 300, 400, 600
(define font/sans-serif
  (css-expr #:font-family "Fira Sans" "Gill Sans"
            -apple-system BlinkMacSystemFont "Helvetica Neue" "Helvetica" "Verdana" sans-serif))

; 400, 500
(define font/monospace
  (css-expr #:font-family "Fira Mono" "Menlo" "Monaco" "Courier New" monospace))

; 700
(define font/display
  (css-expr #:font-family "Cooper Hewitt" "Fira Sans" "Gill Sans"
            -apple-system BlinkMacSystemFont "Helvetica Neue" "Helvetica" "Verdana" sans-serif
            #:font-weight 700))

(define font/main font/serif)

(define font/secondary font/sans-serif)

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

(define colorscheme
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
;; SIZES

;; Modular Scale

;; Reference: http://www.modularscale.com/?1&em&1.2&js&table
(define (modular-scale step #:base [base 1] #:ratio [ratio 1.2])
  (* base (expt ratio step)))

;; Text

(define size/text/small (css-expr rem ,(modular-scale -1)))
(define size/indentation (css-expr rem ,(modular-scale 2)))
(define size/body/padding/unitless (modular-scale -2))
(define size/body/padding (css-expr rem ,size/body/padding/unitless))

;; Grid

(define size/responsive/two-columns/min-width/step 23)
(define size/responsive/two-columns/min-width/unitless
  (modular-scale size/responsive/two-columns/min-width/step))
(define size/responsive/two-columns/min-width
  (css-expr rem ,size/responsive/two-columns/min-width/unitless))
(define size/responsive/two-columns/width/unitless
  (- size/responsive/two-columns/min-width/unitless (* 2 size/body/padding/unitless)))
(define size/responsive/two-columns/width
  (css-expr rem ,size/responsive/two-columns/width/unitless))
(define size/responsive/two-columns/min-width/absolute/unitless
  (modular-scale size/responsive/two-columns/min-width/step))
(define size/responsive/two-columns/min-width/absolute
  (css-expr rem ,size/responsive/two-columns/min-width/absolute/unitless))

;; Rulers

(define size/ruler/thin/unitless 1)
(define size/ruler/thin (css-expr px ,size/ruler/thin/unitless))
(define size/ruler/thick/unitless 3)
(define size/ruler/thick (css-expr px ,size/ruler/thick/unitless))

;; TODO: Get rid of this

(define size/responsive/steps 5)
(define size/responsive/min-width/end/unitless (modular-scale 20))
(define size/responsive/min-width/end (css-expr rem ,size/responsive/min-width/end/unitless))
(define size/table/data/padding (css-expr rem ,(modular-scale -2)))
(define size/table/data/last/start (modular-scale 11))
(define size/table/data/last/end (modular-scale 15))
(define size/table/data/last
  (css-expr #:width (rem ,size/table/data/last/start)
            ,@(for/list ([min-width (in-steps (modular-scale 17)
                                              size/responsive/min-width/end/unitless
                                              size/responsive/steps)]
                         [width (in-steps size/table/data/last/start
                                          size/table/data/last/end
                                          size/responsive/steps)])
                (css-expr @media (and screen (#:min-width (rem ,min-width)))
                          #:width (rem ,width)))))

;; ---------------------------------------------------------------------------------------------------
;; COMPONENTS

(components-output-types #:dynamic html atom #:static css)

;; ---------------------------------------------------------------------------------------------------
;; MIXINS

;; Reference: https://eager.io/blog/smarter-link-underlines/
(define (smart-underline #:colors colors
                         #:colors/hover [colors/hover #f]
                         #:distances [distances (in-steps .03 .15 4)]
                         #:thickness [thickness '1px]
                         #:top [top '90%])
  (define/match (rules colors)
    [(`(,color/foreground ,color/background))
     (css-expr #:text-decoration none
               #:text-shadow ,@(append*
                                (for/list ([distance distances])
                                  (css-expr ((em ,distance) 0 ,color/background)
                                            (0 (em ,distance) ,color/background)
                                            ((em ,(- distance)) 0 ,color/background)
                                            (0 (em ,(- distance)) ,color/background))))
               #:background (#:image (apply linear-gradient ,color/foreground ,color/foreground)
                             #:size (,thickness ,thickness)
                             #:repeat repeat-x
                             #:position (0% ,top)))])
  (css-expr ,@(rules colors)
            ,@(if colors/hover (css-expr [(: & hover) ,@(rules colors/hover)]) (css-expr))))

(define smart-underline/disable
  (css-expr #:background-image none !important))

(define (inline-block-enumeration gutter)
  (css-expr
   #:display inline-block
   #:margin-right (rem ,gutter)
   [(: & last-child)
    #:margin-right 0]))

(define ruler-left-spacing
  (css-expr #:padding
            (#:top (rem ,(modular-scale -4))
             #:bottom (rem ,(modular-scale -4))
             #:left ,size/indentation
             #:left (apply calc (- ,size/indentation ,size/ruler/thick)))
            #:margin (#:top (rem ,(modular-scale 0))
                      #:bottom (rem ,(modular-scale 0)))
            [div.full-width
             [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
              #:width ,size/responsive/two-columns/width
              #:width (apply calc (- ,size/responsive/two-columns/width ,size/indentation))]]))

(define-component (show-on-hover . elements)
  #:html (apply (default-tag-function 'span #:class "show-on-hover") elements)
  #:css (css-expr [.show-on-hover
                   #:transition (opacity 0.3s)
                   #:opacity 0
                   [(> *:hover &) #:opacity 1]]))

(define (section/flag content color)
  (css-expr
   #:border-left (,size/ruler/thick solid ,color)
   ,@ruler-left-spacing
   #:position relative
   [(:: & before)
    #:content ,content
    ,@font/secondary
    #:text-transform uppercase
    #:letter-spacing 0.1em
    #:font-weight 300
    #:font-size ,size/text/small
    #:line-height 1
    #:background-color ,color
    #:color ,(dict-ref colorscheme 'background)
    #:display inline-block
    #:padding (#:bottom 0.1em #:left 0.2em)
    #:position absolute
    #:left (px ,(- size/ruler/thick/unitless))
    #:top 0
    ,@(prefix (css-expr #:transform ((apply rotate -90deg) (apply translate -100% 0))))
    ,@(prefix (css-expr #:transform-origin (top left)))]))

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
  (apply (default-tag-function 'root) elements/with-paragraphs/with-merged-classes))

(define-component body-text
  #:css
  (define elements-that-cause-paragraph-indent-reset
    `(,@(css-expr .insertion) ,@(css-expr h1) ,@(css-expr h2)))
  (css-expr [* *::before *::after #:box-sizing border-box #:outline none]
            [body
             ,@(prefix (css-expr #:font-synthesis none))
             ,@(prefix (css-expr #:font-kerning normal))
             ,@(prefix (css-expr #:font-variant-ligatures (common-ligatures contextual)))
             ,@(prefix (css-expr #:text-rendering optimizeLegibility))
             ,@(prefix (css-expr #:font-feature-settings "kern" "rlig" "liga" "clig" "calt"))
             ,@font/main
             #:line-height ,(modular-scale 2)
             #:margin ((rem ,(modular-scale 4)) auto)
             [@media (and screen (#:max-width ,size/responsive/two-columns/min-width/absolute))
              #:max-width ,size/responsive/min-width/end]
             [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
              #:width ,size/responsive/two-columns/min-width
              [article #:width ,size/responsive/min-width/end]]
             #:padding (0 ,size/body/padding)
             #:background-color ,(dict-ref colorscheme 'background)
             #:color ,(dict-ref colorscheme 'primary-content)]
            [p
             #:margin 0
             [(+ p &) #:text-indent ,size/indentation]
             [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
              [(+ aside &) #:text-indent ,size/indentation]
              [,@(for*/list ([an-element-that-causes-paragraph-indent-reset
                              (in-list elements-that-cause-paragraph-indent-reset)]
                             [quantity-of-asides (in-range 1 6)])
                   (css-expr + ,an-element-that-causes-paragraph-indent-reset
                             ,@(append* (make-list quantity-of-asides (css-expr aside)))
                             &))
               #:text-indent 0]]
             [(: & first-of-type) #:text-indent 0 !important]]))

(define-component insertion
  #:css (css-expr [.insertion
                   #:width 100%
                   #:margin (#:top (rem ,(modular-scale -2))
                             #:bottom (rem ,(modular-scale -2)))]))

(define-component headings
  #:css (css-expr [h1 h2
                   ,@font/secondary
                   #:font-size (rem ,(modular-scale 1))
                   #:margin (#:top (rem ,(modular-scale 2))
                             #:bottom (rem ,(modular-scale -2)))
                   [a ,@smart-underline/disable]]
                  [h1
                   #:font-weight 600]
                  [h2
                   #:font-weight 400]))

(define-component (heading/mark . elements)
  #:html (show-on-hover
          (apply (default-tag-function 'span #:class "heading--mark")
                 elements))
  #:css (css-expr [.heading--mark
                   #:margin-left (rem ,(modular-scale -3))
                   [a
                    ,@smart-underline/disable
                    #:color ,(dict-ref colorscheme 'secondary-content)]]))

(define-component (reference/§ key)
  #:html (heading/mark (reference key "§")))

(define-component navigation #:html (default-tag-function 'nav))

(define-component (menu . elements)
  #:html (apply navigation #:class "menu" elements)
  #:css (css-expr [.menu
                   ,@font/secondary
                   #:font-weight 300
                   #:line-height ,(modular-scale 4)
                   [a ,@(inline-block-enumeration (modular-scale 0))]]))

(define-component header
  #:css (css-expr [header
                   [h1
                    ,@font/display
                    #:font-size (rem ,(modular-scale 2))]
                   [(> body &)
                    #:padding-bottom (rem ,(modular-scale -4))
                    #:border-bottom
                    (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content))
                    #:margin-bottom (rem ,(modular-scale 4))]
                   [(> article &)
                    #:margin (#:top (rem ,(modular-scale 2))
                              #:bottom (rem ,(modular-scale -2)))]]))

(define-component time
  #:html (default-tag-function 'time)
  #:css (css-expr [time
                   ,@font/secondary
                   #:font-weight 300
                   #:font-size ,size/text/small
                   #:position relative
                   #:top (rem ,(- (modular-scale -3)))
                   #:color ,(dict-ref colorscheme 'secondary-content)]))

;; ---------------------------------------------------------------------------------------------------
;; WRITING

(define-component (label key)
  #:html ((default-tag-function 'span) #:id (~a key)))

(define-component (reference key . elements)
  #:html (apply link (~a "#" key) elements))

(define-component (link path . elements)
  #:html (apply (default-tag-function 'a) #:href path
                (if (null? elements) `(,path) elements))
  #:css (css-expr [a
                   #:text-decoration none
                   #:color ,(dict-ref colorscheme 'primary-content)
                   #:transition (background-color 0.3s) (text-shadow 0.3s)
                   [(: & hover)
                    #:background-color ,(dict-ref colorscheme 'background-highlight)
                    #:color ,(dict-ref colorscheme 'emphasized-content)]
                   [(article &)
                    ,@(smart-underline
                       #:colors `(,(dict-ref colorscheme 'secondary-content)
                                  ,(dict-ref colorscheme 'background))
                       #:colors/hover `(,(dict-ref colorscheme 'secondary-content)
                                        ,(dict-ref colorscheme 'background-highlight)))]
                   [(aside &)
                    ,@(smart-underline
                       #:colors `(,(dict-ref colorscheme 'secondary-content)
                                  ,(dict-ref colorscheme 'background))
                       #:colors/hover `(,(dict-ref colorscheme 'secondary-content)
                                        ,(dict-ref colorscheme 'background-highlight))
                       #:top '100%)
                    [@media (and screen (#:max-width ,size/responsive/two-columns/min-width/absolute))
                     #:color ,(dict-ref colorscheme 'emphasized-content)
                     [(: & hover)
                      #:background-color ,(dict-ref colorscheme 'background)
                      #:color ,(dict-ref colorscheme 'primary-content)]
                     ,@(smart-underline
                        #:colors `(,(dict-ref colorscheme 'secondary-content)
                                   ,(dict-ref colorscheme 'background-highlight))
                        #:colors/hover `(,(dict-ref colorscheme 'secondary-content)
                                         ,(dict-ref colorscheme 'background))
                        #:top '100%)]]]))

(define-component (link/internal path . elements)
  #:html (apply link (internal-url path) elements))

(define-component (email address . elements)
  #:html (apply link (~a "mailto:" address)
                (if (null? elements) `(,address) elements)))

(define-component (github-user handle)
  #:html (link (~a "https://github.com/" handle) (~a "@" handle)))

(define-component (skype-user handle)
  #:html ((default-tag-function 'em) handle))

(define-component (phone number)
  #:html ((default-tag-function '@) number))

(define-component new-thought
  #:html (default-tag-function 'span #:class "new-thought")
  #:css (css-expr #;[.new-thought]))

(define-component margin-note
  #:html (default-tag-function 'aside)
  #:css (css-expr [aside
                   [@media (and screen (#:max-width ,size/responsive/two-columns/min-width/absolute))
                    #:color ,(dict-ref colorscheme 'emphasized-content)
                    #:background-color ,(dict-ref colorscheme 'background-highlight)
                    #:border-left
                    (,size/ruler/thick solid ,(dict-ref colorscheme 'secondary-content))
                    ,@ruler-left-spacing
                    #:padding-right (rem ,(modular-scale -4))]
                   [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
                    #:font-size ,size/text/small
                    #:float right
                    #:clear right
                    #:width (rem ,(modular-scale 17)) !important
                    #:margin-bottom (rem ,(modular-scale 2))
                    #:margin-right (rem ,(- (modular-scale 18)))]]))

(define-component figure
  #:html (default-tag-function 'figure #:class "insertion")
  #:css (css-expr [figure #:margin 0 #:text-align center]))

(define-component figure/caption
  #:html (default-tag-function 'figcaption)
  #:css (css-expr [figcaption ,@font/secondary #:text-align center]))

(define-component (image path [caption ""])
  #:html (figure ((default-tag-function 'div #:class "image-in-figure")
                  ((default-tag-function 'img) #:src path #:alt caption))
                 (figure/caption caption))
  #:css (css-expr [img #:max-width 100%]
                  [.image-in-figure #:text-align center]))

(define-component (svg path)
  #:html (string->xexpr (file->string path))
  #:css (css-expr [svg #:max-width 100% #:height auto]))

(define-component code/inline
  #:html (default-tag-function 'code)
  #:css (css-expr [code ,@font/monospace]))

(define-component (code/block . elements)
  #:html ((default-tag-function 'pre #:class "code--block insertion") (apply code/inline elements))
  #:css (css-expr [pre
                   ,@font/monospace
                   #:font-size ,size/text/small
                   #:overflow auto
                   #:border (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content))
                   #:padding ,size/indentation
                   #:padding (apply calc (- ,size/indentation ,size/ruler/thin))]))

(define-component (code/block/highlighted language . elements)
  #:html
  (define code (string-join elements ""))
  (define digest (sha1 (open-input-string code)))
  (define path/basedir "compiled/code-block-highlighted/")
  (define path/full (~a path/basedir digest ".html"))
  (define code/highlighted
    (cond
      [(file-exists? path/full)
       (file->string path/full)]
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
  ((default-tag-function 'div #:class "code--block insertion") (string->xexpr code/highlighted)))

(define-component (file-listing a-path #:language [language #f] . elements)
  #:html ((default-tag-function 'div #:class "file-listing insertion")
          (path a-path)
          (if language
              (apply code/block/highlighted language elements)
              (apply code/block elements)))
  #:css (css-expr [.file-listing
                   [.code--block
                    #:margin-top 0]
                   [.path
                    #:border
                    (#:top (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content))
                     #:right (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content))
                     #:left (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content)))
                    #:padding
                    (#:left (rem ,(modular-scale -1))
                     #:right (rem ,(modular-scale -1)))
                    #:color ,(dict-ref colorscheme 'secondary-content)]
                   [(> & p)
                    #:margin-bottom (px ,(- size/ruler/thin/unitless))]]))

(define-component keyboard
  #:html (default-tag-function 'kbd)
  #:css (css-expr [kbd ,@font/monospace]))

(define-component path
  #:html (default-tag-function 'code #:class "path"))

(define-component initialism
  #:html (default-tag-function 'span #:class "initialism")
  #:css (css-expr #;[span.initialism
                     ,@font/capitals]))

(define-component full-width
  #:html (default-tag-function 'div #:class "full-width insertion")
  #:css (css-expr [div.full-width
                   [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
                    #:clear both
                    #:width ,size/responsive/two-columns/width]]))

(define-component list/unordered #:html (default-tag-function 'ul #:class "insertion"))

(define-component list/unordered/item #:html (default-tag-function 'li))

(define-component list/ordered #:html (default-tag-function 'ol #:class "insertion"))

(define-component list/ordered/item #:html (default-tag-function 'li))

(define-component emphasis
  #:html (default-tag-function 'em))

(define-component foreign #:html emphasis)

(define-component technical-term #:html emphasis)

(define-component (section key . elements)
  #:html (apply (default-tag-function 'h1) `(,(label key) ,@elements ,(reference/§ key))))

(define-component (subsection key . elements)
  #:html (apply (default-tag-function 'h2) `(,(label key) ,@elements ,(reference/§ key))))

(define-component (appendix key . elements)
  #:html (apply section key `("Appendix: " ,@elements)))

(define-component paragraph-separation ;; FIXME: Try to get rid of this using ‘@’ for splicing.
  #:html (default-tag-function 'div #:class "paragraph-separation insertion")
  #:css (css-expr [.paragraph-separation #:height 1px]))

(define-component new-line
  #:html (default-tag-function 'br))

(define-component big-separation
  #:css (css-expr [.big-separation #:margin-bottom (rem ,(modular-scale 5))]))

(define-component table #:html (default-tag-function 'table #:class "insertion"))

(define-component table/aligned-last-data
  #:css (css-expr [(.table--aligned-last-data td:last-child)
                   #:width 40%
                   #;[(ol &) (ul &) ;; FIXME
                    #:width (apply calc (- 40% 40px))]]))

(define-component table/header #:html (default-tag-function 'thead))

(define-component table/body
  #:html (default-tag-function 'tbody)
  #:css (css-expr [tbody+tbody::before
                   #:content ""
                   #:display block
                   #:margin-top (rem ,(modular-scale -4))]))

(define-component table/row #:html (default-tag-function 'tr))

(define-component table/data
  #:html (default-tag-function 'td)
  #:css (css-expr [td #:padding 0 (#:right ,size/table/data/padding)]))

(define-component table/data/header
  #:html (default-tag-function 'th)
  #:css (css-expr [th
                   ,@font/secondary
                   #:text-align left
                   #:padding 0 (#:right ,size/table/data/padding)]))

(define-component (fraction numerator denominator)
  #:html `(span
           (span ((class "fraction--numerator")) ,(~a numerator))
           (span ((class "fraction--slash")) "/")
           (span ((class "fraction--denominator")) ,(~a denominator)))
  #:css (css-expr [.fraction--numerator .fraction--denominator
                   #:font-size 0.8em
                   #:font-weight 700]
                  [.fraction--numerator #:vertical-align super]
                  [.fraction--denominator #:vertical-align sub]
                  [.fraction--slash #:margin (#:left -0.1em #:right -0.1em)]))

(define-component roman-number #:html initialism)

(define-component production #:html emphasis)

(define-component informal #:html emphasis)

(define-component head/link #:html (default-tag-function 'link))

(define-component head/title #:html (default-tag-function 'title))

(define-component publication #:html emphasis)

(define-component (placeholder . elements)
  #:html (apply (default-tag-function 'span #:class "placeholder") `("<" ,@elements ">"))
  #:css (css-expr [.placeholder #:color ,(dict-ref colorscheme 'blue)]))

(define-component menu-option
  #:html (default-tag-function 'span #:class "menu-option")
  #:css (css-expr [.menu-option
                   ,@font/secondary]))

(define-component (menu-option/path . elements)
  #:html (apply menu-option (add-between elements " > ")))

;; ---------------------------------------------------------------------------------------------------
;; COOKING

(define-component (recipes . elements)
  #:html (apply list/unordered #:class "recipes" elements)
  #:css (css-expr [.recipes
                   ,@(prefix (css-expr #:column-count 2))
                   #:padding-left 0]))

(define-component (recipe path . elements)
  #:html (list/unordered/item #:class "recipe"
                              (apply link/internal (~a "/cooking/" path) elements))
  #:css (css-expr [.recipe
                   #:list-style none
                   #:margin-bottom (rem ,(modular-scale -4))
                   [a ,@smart-underline/disable]]))

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
  #:css (css-expr [.skills
                   #:padding-left 0]))

(define-component (skill level . elements)
  #:html (apply list/unordered/item #:class (~a "skill " level) elements)
  #:css (css-expr [.skill
                   ,@(inline-block-enumeration (modular-scale 1))
                   #:line-height 2
                   [.initialism
                    #:margin-right 0]]
                  [.skill::before
                   #:content ""
                   #:display inline-block
                   #:margin-right (rem ,(modular-scale -8))
                   #:border-left ((rem ,(modular-scale -5)) solid)]
                  [.beginner::before
                   #:height .3em
                   #:border-left-color ,(dict-ref colorscheme 'red)]
                  [.intermediate::before
                   #:height .6em
                   #:border-left-color ,(dict-ref colorscheme 'yellow)]
                  [.advanced::before
                   #:height .9em
                   #:border-left-color ,(dict-ref colorscheme 'green)]))

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
  #:css (css-expr [.git--verb #:color ,(dict-ref colorscheme 'blue)]))

(define-component git/object
  #:html (default-tag-function 'span #:class "git--object")
  #:css (css-expr [.git--object #:color ,(dict-ref colorscheme 'green)]))

(define-component git/gui
  #:html (default-tag-function 'div #:class "git--gui")
  #:css (css-expr [.git--gui ,@(section/flag "GUI" (dict-ref colorscheme 'violet))]))

(define-component git/cli
  #:html (default-tag-function 'div #:class "git--cli")
  #:css (css-expr [.git--cli ,@(section/flag "CLI" (dict-ref colorscheme 'yellow))]))
