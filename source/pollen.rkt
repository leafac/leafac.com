#lang pollen/mode racket
(require (for-syntax racket/base syntax/parse pollen/setup racket/dict racket/list racket/syntax)
         racket/function racket/list racket/file racket/dict racket/string
         css-expr libuuid gregor gregor/period sugar xml
         (except-in syntax/parse attribute) syntax/parse/define
         pollen/core pollen/decode pollen/tag pollen/file pollen/setup pollen-component)

(provide (all-defined-out)
         (all-from-out racket/function racket/list racket/file racket/dict racket/string
                       gregor gregor/period sugar xml
                       pollen/core pollen/file
                       css-expr))

;; PERSONAL DATA -------------------------------------------------------------------------------------

(define personal-data
  (let ([date-of-birth (date 1990 10 20)])
    `((name           . ,◊~a{Leandro Facchinetti})
      (author         . ,◊~a{Leandro Facchinetti})
      (gpg-key-id     . ,◊~a{5925D0683DF3D583})
      (github-handle  . ,◊~a{leafac})
      (personal-email . ,◊~a{me@leafac.com})
      (work-email     . ,◊~a{leandro@jhu.edu})
      (skype-handle   . ,◊~a{leafac})
      (phone-number   . ,◊~a{+14107799526})
      (description    . ,◊~a{Leandro Facchinetti is a writer of prose, software and songs. He is a Ph.D. student at the Programming Languages Laboratory, at the Johns Hopkins University. His interests are computer programming, music, books, typography, lettering, education, minimalism and veganism.})
      (date-of-birth  . ,date-of-birth)
      (age            . ,(period-ref (period-between date-of-birth (today)) 'years)))))

;; COMPONENT SUPPORT ---------------------------------------------------------------------------------

(components-output-types #:dynamic html atom #:static css)

;; MISCELLANEOUS SUPPORT -----------------------------------------------------------------------------

(define (in-steps start end steps)
  (for/list ([step (in-range (add1 steps))])
    (exact->inexact (+ start (* step (/ (- end start) steps))))))

(define base-path (make-parameter ""))

(define (internal-url path) (string-append (base-path) path))

(define base-absolute (make-parameter "https://www.leafac.com"))

(define (absolute-url path) (string-append (base-absolute) path))

(define (prefix declaration #:prefixes [prefixes '(moz webkit ms o)])
  (syntax-parse declaration
    [(name:keyword rest:expr ...)
     (define name/datum (syntax->datum #'name))
     (define rests/datum (syntax->datum #'(rest ...)))
     (css-expr ,@(apply
                  append
                  (for/list ([the-prefix prefixes])
                    (define prefixed-name
                      (string->keyword (~a "-" the-prefix "-" (keyword->string name/datum))))
                    (css-expr ,prefixed-name ,@rests/datum)))
               ,name/datum ,@rests/datum)]))

(define (feed/uuid) (string-downcase (string-append "urn:uuid:" (uuid-generate))))

;; https://groups.google.com/forum/#!msg/pollenpub/4bOXKsIVzm4/RpzYRwqCAgAJ
(define (feed/date) (~t (now/moment) "yyyy-MM-dd'T'HH:mm:ssxxx"))

;; COLORSCHEME ---------------------------------------------------------------------------------------

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
    (emphasized-content   . ,(dict-ref solarized 'base01))))

;; FONTS ---------------------------------------------------------------------------------------------

(define (font/face family weight style #:path [path (internal-url "/vendor/assets/fonts")])
  (define basename (string-append path "/" family "/" family "--" weight "--" style))
  (css-expr [@font-face
             #:font-family ,family
             #:src (apply url ,(string-append basename ".eot"))
             #:src ((apply url ,(string-append basename ".eot?#iefix"))
                    (apply format "embedded-opentype"))
             ((apply url ,(string-append basename ".woff2")) (apply format "woff2"))
             ((apply url ,(string-append basename ".woff")) (apply format "woff"))
             ((apply url ,(string-append basename ".ttf")) (apply format "truetype"))
             ((apply url ,(string-append basename ".otf")) (apply format "opentype"))
             ((apply url ,(string-append basename ".svg#" family))
              (apply format "svg"))
             #:font-weight ,(string->symbol weight)
             #:font-style ,(string->symbol style)]))

(define (font/faces family weights styles #:path [path #f])
  (apply append
         (for*/list ([weight weights]
                     [style styles])
           (if path
               (font/face family weight style #:path path)
               (font/face family weight style)))))

(define-component font/faces/charis-sil
  #:css (font/faces "charis-sil" '("400" "700") '("normal" "italic")))

(define-component font/faces/source-sans-pro
  #:css (font/faces "source-sans-pro" '("200" "300" "400" "600" "700" "900") '("normal" "italic")))

(define-component font/faces/source-code-pro
  #:css (font/faces "source-code-pro" '("200" "300" "400" "500" "600" "700" "900")
                    '("normal" "italic")))

(define-component font/faces/font-awesome #:css (font/face "font-awesome" "400" "normal"))

(define font/serif (css-expr #:font-family "charis-sil"))

(define font/sans-serif (css-expr #:font-family "source-sans-pro"))

(define font/typewriter (css-expr #:font-family "source-code-pro"))

(define font/icons (css-expr #:font-family "font-awesome"))

(define font/italics (css-expr #:font-style italic))

(define font/feature-settings '("kern" "rlig" "liga" "clig" "calt"))

(define font/small-caps
  (css-expr ,@(prefix (css-expr #:font-feature-settings ,@font/feature-settings "smcp"))
            #:text-transform lowercase
            #:letter-spacing 0.2em
            [(aside &) #:letter-spacing 0.1em]
            #:margin-right -0.1em))

(define font/all-caps
  (css-expr #:text-transform uppercase
            #:letter-spacing 0.2em))

(define font/kerning
  (css-expr ,@(prefix (css-expr #:font-kerning normal))
            ,@(prefix (css-expr #:font-variant-ligatures (common-ligatures contextual)))
            ,@(prefix (css-expr #:text-rendering optimizeLegibility))
            ,@(prefix (css-expr #:font-feature-settings ,@font/feature-settings))))

(define (font/smart-underline #:colors colors
                              #:colors/hover [colors/hover #f]
                              #:distances [distances (in-steps .03 .15 4)]
                              #:thickness [thickness '1px]
                              #:top [top '90%])
  ;; Reference: https://eager.io/blog/smarter-link-underlines/.
  (define/match (rules colors)
    [(`(,color/foreground ,color/background))
     (css-expr #:text-decoration none
               #:text-shadow ,@(apply append
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

(define font/smart-underline/disable
  (css-expr #:background-image none !important))

(define font/main font/serif)

(define font/secondary font/sans-serif)

(define font/rendering (css-expr #:-moz-osx-font-smoothing grayscale
                                 #:-webkit-font-smoothing antialiased))

;; MODULAR SCALE -------------------------------------------------------------------------------------

;; Reference: http://www.modularscale.com/?1&em&1.2&js&table

(define (modular-scale step #:base [base 1] #:ratio [ratio 1.2])
  (* base (expt ratio step)))

;; SIZES ---------------------------------------------------------------------------------------------

(define size/body-text/start/unitless 15)

(define size/body-text/default/unitless 16)

(define size/body-text/end/unitless (modular-scale 1 #:base size/body-text/start/unitless))

(define size/body-text/start/ratio
  (exact->inexact (/ size/body-text/start/unitless size/body-text/default/unitless)))

(define size/body-text/end/ratio
  (exact->inexact (/ size/body-text/end/unitless size/body-text/default/unitless)))

(define size/body-text/start (css-expr rem ,size/body-text/start/ratio))

(define size/body-text/end (css-expr rem ,size/body-text/end/ratio))

(define size/indentation (css-expr rem ,(modular-scale 2)))

(define size/responsive/steps 5)

(define size/responsive/min-width/start/unitless (modular-scale 17))

(define size/responsive/min-width/start (css-expr rem ,size/responsive/min-width/start/unitless))

(define size/responsive/min-width/end/unitless (modular-scale 20))

(define size/responsive/min-width/end (css-expr rem ,size/responsive/min-width/end/unitless))

(define size/responsive/min-width/range
  (in-steps size/responsive/min-width/start/unitless
            size/responsive/min-width/end/unitless
            size/responsive/steps))

(define size/body/padding/unitless (modular-scale -2))

(define size/body/padding (css-expr rem ,size/body/padding/unitless))

(define size/responsive/two-columns/min-width/step 23)

(define size/responsive/two-columns/min-width/unitless
  (modular-scale size/responsive/two-columns/min-width/step))

(define size/responsive/two-columns/min-width
  (css-expr rem ,size/responsive/two-columns/min-width/unitless))

(define size/responsive/two-columns/width/unitless
  (- size/responsive/two-columns/min-width/unitless (* 2 size/body/padding/unitless)))

(define size/responsive/two-columns/width
  (css-expr rem ,size/responsive/two-columns/width/unitless))

;; `absolute' is to use with media queries, as they are relative to the browser's default `font-size',
;; and not to the `font-size' of the root element `html'. (See
;; `https://www.sitepoint.com/understanding-and-using-rem-units-in-css/'.) The approach I'm taking is
;; to use `rem' for everything, including the root `font-size', so that I /don't/ lose the information
;; of the browser's default `font-size'. This way, I'm able to compensate the fact that media queries
;; are /not/ relative to the `html' `font-size', but everything else is.
(define size/responsive/two-columns/min-width/absolute/unitless
  (modular-scale size/responsive/two-columns/min-width/step #:base size/body-text/end/ratio))

(define size/responsive/two-columns/min-width/absolute
  (css-expr rem ,size/responsive/two-columns/min-width/absolute/unitless))

(define size/ruler/thin '1px)

(define size/ruler/thick '3px)

(define size/two-columns/content (prefix (css-expr #:column-count 2)))

(define size/table/data/padding (css-expr rem ,(modular-scale -2)))

(define size/table/data/last/start (modular-scale 11))

(define size/table/data/last/end (modular-scale 15))

(define size/table/data/last
  (css-expr #:width (rem ,size/table/data/last/start)
            ,@(for/list ([min-width size/responsive/min-width/range]
                         [width (in-steps size/table/data/last/start
                                          size/table/data/last/end
                                          size/responsive/steps)])
                (css-expr @media (and screen (#:min-width (rem ,min-width)))
                          #:width (rem ,width)))))

;; MISCELLANEOUS MIXINS ------------------------------------------------------------------------------

(define (inline-block-enumeration gutter)
  (css-expr
   #:display inline-block
   #:margin-right (rem ,gutter)
   [(: & last-child)
    #:margin-right 0]))

;; COMPONENTS ----------------------------------------------------------------------------------------

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
  #:css (css-expr [* *::before *::after #:box-sizing border-box #:outline none]
                  [html
                   #:font-size ,size/body-text/start
                   ,@(for/list ([min-width size/responsive/min-width/range]
                                [font-size (in-steps size/body-text/start/ratio
                                                     size/body-text/end/ratio
                                                     size/responsive/steps)])
                       (css-expr @media (and screen (#:min-width (rem ,min-width)))
                                 #:font-size (rem ,font-size)))]
                  [body
                   #:font-synthesis none
                   ,@font/main
                   ,@font/kerning
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
                    [(+ .insertion aside &) (+ h1 aside &) (+ h2 aside &) (+ .no-indent &)
                     #:text-indent 0]]
                   [(: & first-of-type) #:text-indent 0 !important]]))

(define-component insertion
  #:css (css-expr [.insertion
                   #:width 100%
                   #:margin (#:top (rem ,(modular-scale -2))
                             #:bottom (rem ,(modular-scale -2)))]))

(define-component headings
  #:css (css-expr [h1 h2
                   #:font-size (rem ,(modular-scale 0))
                   [(header &)
                    #:font-size (rem ,(modular-scale 2))
                    [a ,@font/smart-underline/disable]]
                   #:margin (#:top (rem ,(modular-scale 2))
                             #:bottom (rem ,(modular-scale -2)))]
                  [h1
                   ,@font/small-caps
                   #:font-weight 600]
                  [h2
                   ,@font/italics
                   #:font-weight 400]))

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
                    ,@(font/smart-underline
                       #:colors `(,(dict-ref colorscheme 'secondary-content)
                                  ,(dict-ref colorscheme 'background))
                       #:colors/hover `(,(dict-ref colorscheme 'secondary-content)
                                        ,(dict-ref colorscheme 'background-highlight)))]
                   [(aside &)
                    ,@(font/smart-underline
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
                     ,@(font/smart-underline
                        #:colors `(,(dict-ref colorscheme 'secondary-content)
                                   ,(dict-ref colorscheme 'background-highlight))
                        #:colors/hover `(,(dict-ref colorscheme 'secondary-content)
                                         ,(dict-ref colorscheme 'background))
                        #:top '100%)]]]))

(define disabled-paths '("/music"))

(define-component (link/internal path . elements)
  #:html (if (member path disabled-paths)
             (apply (default-tag-function 'span #:class "disabled-path") elements)
             (apply link (internal-url path) elements))

  #:css (css-expr [.disabled-path
                   [(.menu &) #:display none]]))

(define-component (email address . elements)
  #:html (apply link (string-append "mailto:" address)
                (if (null? elements) `(,address) elements)))

(define-component (gpg-key-id key-id)
  #:html (link (string-append "http://pgp.mit.edu/pks/lookup?op=vindex&search=0x" key-id)
               (string-append "0x" key-id)))

(define-component (github-user handle)
  #:html (link (string-append "https://github.com/" handle) (string-append "@" handle)))

(define-component (skype-user handle)
  #:html ((default-tag-function 'em) handle))

(define-component (phone number)
  #:html ((default-tag-function '@) number))

(define-component new-thought
  #:html (default-tag-function 'span #:class "new-thought")
  #:css (css-expr [.new-thought ,@font/small-caps]))

(define-component navigation #:html (default-tag-function 'nav))

(define-component (menu . elements)
  #:html (apply navigation #:class "menu" elements)
  #:css (css-expr [.menu
                   ,@font/small-caps
                   ,@font/secondary
                   #:font-weight 300
                   #:line-height ,(modular-scale 4)
                   [a
                    ,@(inline-block-enumeration (modular-scale 0))]]))

(define-component header
  #:css (css-expr [body>header
                   #:padding-bottom (rem ,(modular-scale -4))
                   #:border-bottom
                   (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content))
                   #:margin-bottom (rem ,(modular-scale 4))]
                  [article>header
                   #:margin (#:top (rem ,(modular-scale 2))
                             #:bottom (rem ,(modular-scale -2)))
                   [time
                    ,@font/secondary
                    #:font-size (rem ,(modular-scale -1))
                    #:position relative
                    #:top (rem ,(- (modular-scale -3)))
                    #:color ,(dict-ref colorscheme 'secondary-content)]]))

(define-component time #:html (default-tag-function 'time))

(define-component margin-note
  #:html (default-tag-function 'aside)
  #:css (css-expr [aside
                   ,@font/secondary
                   [@media (and screen (#:max-width ,size/responsive/two-columns/min-width/absolute))
                    #:color ,(dict-ref colorscheme 'emphasized-content)
                    #:background-color ,(dict-ref colorscheme 'background-highlight)
                    #:border-left
                    (,size/ruler/thick solid ,(dict-ref colorscheme 'secondary-content))
                    #:padding (rem ,(modular-scale -4))
                    (#:left ,size/indentation
                     #:left (apply calc (- ,size/indentation ,size/ruler/thick)))
                    #:margin (#:top (rem ,(modular-scale 0))
                              #:bottom (rem ,(modular-scale 0)))]
                   [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
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

(define-component (image path caption)
  #:html (figure ((default-tag-function 'div #:class "image-in-figure")
                  ((default-tag-function 'img) #:src path #:alt caption))
                 (figure/caption caption))
  #:css (css-expr [img #:max-width 100%]
                  [.image-in-figure #:text-align center]))

(define svg/font-replacement
  '(("Charis SIL" . "charis-sil")
    ("Source Sans Pro" . "source-sans-pro")
    ("Source Code Pro" . "source-code-pro")
    ("Font Awesome" . "font-awesome")))

(define-component (svg path)
  #:html
  (define source (file->string path))
  (define font-replaced
    (for/fold ([font-replaced source])
              ([(source target) (in-dict svg/font-replacement)])
      (regexp-replace* (pregexp (~a "font-family:\\s*[\"']?" source "[\"']?;"))
                       font-replaced (~a "font-family:" target ";"))))
  (string->xexpr font-replaced))

(define-component code/inline
  #:html (default-tag-function 'code)
  #:css (css-expr [code ,@font/typewriter]))

(define-component (code/block . elements)
  #:html ((default-tag-function 'pre #:class "insertion") (apply code/inline elements))
  #:css (css-expr [pre
                   ,@font/typewriter
                   #:overflow auto
                   #:border (,size/ruler/thin solid ,(dict-ref colorscheme 'secondary-content))
                   #:padding ,size/indentation
                   #:padding (apply calc (- ,size/indentation ,size/ruler/thin))]))

(define-component (code/block/highlighted language . elements)
  #:html ((default-tag-function 'div #:class "insertion")
          (string->xexpr
           (with-input-from-string (apply string-append elements)
             (λ ()
               (with-output-to-string
                   (λ ()
                     (system (~a "pygmentize -f html -l " language)))))))))

(define-component acronym
  #:html (default-tag-function 'span #:class "acronym")
  #:css (css-expr [span.acronym
                   ,@font/small-caps]))

(define-component full-width
  #:html (default-tag-function 'div #:class "full-width")
  #:css (css-expr [div.full-width
                   [@media (and screen (#:min-width ,size/responsive/two-columns/min-width/absolute))
                    #:clear both
                    #:width ,size/responsive/two-columns/width]]))

(define-component list/unordered #:html (default-tag-function 'ul #:class "insertion"))

(define-component list/unordered/item #:html (default-tag-function 'li))

(define-component list/ordered #:html (default-tag-function 'ol #:class "insertion"))

(define-component list/ordered/item #:html (default-tag-function 'li))

(define-component (recipes . elements)
  #:html (apply list/unordered #:class "recipes" elements)
  #:css (css-expr [.recipes ,@size/two-columns/content #:padding-left 0]))

(define-component (recipe path . elements)
  #:html (list/unordered/item #:class "recipe"
                              (apply link/internal (string-append "/cooking/" path) elements))
  #:css (css-expr [.recipe
                   #:list-style none
                   #:margin-bottom (rem ,(modular-scale -4))
                   [a ,@font/smart-underline/disable]]))

(define-component emphasis
  #:html (default-tag-function 'em)
  #:css (css-expr [(aside em)
                   #:font-style normal
                   #:font-weight 600]))

(define-component foreign #:html emphasis)

(define-component technical-term #:html emphasis)

(define-component (label key)
  #:html ((default-tag-function 'span) #:id (~a key)))

(define-component (reference key . elements)
  #:html (apply link (~a "#" key) elements))

(define-component (show-on-hover . elements)
  #:html (apply (default-tag-function 'span #:class "show-on-hover") elements)
  #:css (css-expr [.show-on-hover
                   #:transition (opacity 0.3s)
                   #:opacity 0
                   [(> *:hover &) #:opacity 1]]))

(define-component (heading/mark . elements)
  #:html (show-on-hover
          (apply (default-tag-function 'span #:class "heading--mark")
                 elements))
  #:css (css-expr [.heading--mark
                   #:margin-left (rem ,(modular-scale -3))
                   [a
                    ,@font/smart-underline/disable
                    #:color ,(dict-ref colorscheme 'secondary-content)]]))

(define-component (reference/§ key)
  #:html (heading/mark (reference key "§")))

(define-component (section key . elements)
  #:html (apply (default-tag-function 'h1) `(,(label key) ,@elements ,(reference/§ key))))

(define-component (subsection key . elements)
  #:html (apply (default-tag-function 'h2) `(,(label key) ,@elements ,(reference/§ key))))

(define-component paragraph-separation
  #:html (default-tag-function 'div #:class "paragraph-separation insertion")
  #:css (css-expr [.paragraph-separation #:height 1px]))

(define-component new-line
  #:html (default-tag-function 'br))

(define-component no-indent
  #:html (default-tag-function 'div #:class "no-indent"))

(define-component big-separation
  #:css (css-expr [.big-separation #:margin-bottom (rem ,(modular-scale 5))]))

(define-component table #:html (default-tag-function 'table #:class "insertion"))

(define-component table/aligned-last-data
  #:css (css-expr [(.table--aligned-last-data td:last-child) ,@size/table/data/last]))

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
                   ,@font/small-caps
                   #:font-weight 400
                   #:text-align left
                   #:padding 0 (#:right ,size/table/data/padding)]))

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

(define-component (fraction numerator denominator)
  #:html `(span
           (span ((class "fraction--numerator")) ,(~a numerator))
           (span ((class "fraction--slash")) "/")
           (span ((class "fraction--denominator")) ,(~a denominator)))
  #:css (css-expr [.fraction--numerator .fraction--denominator
                   #:font-size 0.8em
                   #:font-weight 600]
                  [.fraction--numerator #:vertical-align super]
                  [.fraction--denominator #:vertical-align sub]
                  [.fraction--slash #:margin (#:left -0.1em #:right -0.1em)]))

(define-component roman-number #:html acronym)

(define-component production #:html emphasis)

(define-component informal #:html emphasis)

(define-component head/link #:html (default-tag-function 'link))

(define-component head/title #:html (default-tag-function 'title))

(define-component (icon #:illustration [illustration #f] the-icon)
  #:html ((default-tag-function 'span #:aria-hidden "true")
          #:class (string-append "icon" (if illustration " illustration" ""))
          the-icon)
  #:css (css-expr [.icon
                   ,@font/rendering
                   ,@font/icons
                   #:color ,(dict-ref colorscheme 'secondary-content)
                   [(\. & illustration)
                    #:display block
                    #:font-size (rem ,(modular-scale 10))
                    #:line-height (rem ,(modular-scale 10))
                    #:margin-bottom (rem ,(modular-scale -1))]]))

(define-component publication #:html emphasis)

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
                   [.acronym
                    #:margin-right 0]]
                  [.skill::before
                   #:content ""
                   #:display inline-block
                   #:margin-right (rem ,(modular-scale -8))
                   #:border-left ((rem ,(modular-scale -5)) solid)]
                  [.beginner::before
                   #:height .3em
                   #:border-left-color ,(dict-ref solarized 'red)]
                  [.intermediate::before
                   #:height .6em
                   #:border-left-color ,(dict-ref solarized 'yellow)]
                  [.advanced::before
                   #:height .9em
                   #:border-left-color ,(dict-ref solarized 'green)]))

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
