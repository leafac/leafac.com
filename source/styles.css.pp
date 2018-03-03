#lang pollen

/****************************************************************************************************/
/* NORMALIZE */

◊(file->string "stylesheets/normalize.css.p")

/****************************************************************************************************/
/* HELPERS */

◊(define (px->rem px #:html/font-size [html/font-size 16])
  (exact->inexact (/ px html/font-size)))

◊(define (prefix #:prefixes [prefixes '(moz webkit ms o)] name . values)
   (define values/string (string-join values))
   ◊~a{
     ◊(string-append*
       (for/list ([prefix prefixes])
         ◊~a{-◊|prefix|-◊|name|:◊|values/string|;}))
     ◊|name|:◊|values/string|;
   })

/****************************************************************************************************/
/* GRID */

/*
|                   bigger-screens                   |
|                        1024                        |
|         |              body              |         |
|         |              1000              |         |
| padding | article | gutter | margin-note | padding |
|   12    |   600   |   75   |     325     |   12    |
                    |   margin-note/pull   |
                    |         400          |

|       smaller-screens       |
|             624             |
| padding | article | padding |
|   12    |   600   |   12    |
*/

◊(define grid/body             (px->rem 1000))
◊(define grid/padding          (px->rem 12))
◊(define grid/article          (px->rem 600))
◊(define grid/gutter           (px->rem 75))
◊(define grid/margin-note      (px->rem 325))
◊(define grid/margin-note/pull (+ grid/gutter grid/margin-note))
◊(define grid/breakpoint       (+ grid/body (* grid/padding 2)))
◊(define grid/bigger-screens   ◊~a{(min-width:◊|grid/breakpoint|rem)})
◊(define grid/smaller-screens  ◊~a{(max-width:◊(- grid/breakpoint 0.01)rem)})

/****************************************************************************************************/
/* SPACES */

◊(define space/none              0)
◊(define space/extra-extra-small 0.1)
◊(define space/extra-small       0.2)
◊(define space/small             0.5)
◊(define space/medium            1)
◊(define space/large             1.5)
◊(define space/extra-large       2)

/****************************************************************************************************/
/* TEXT */

@font-face {
  font-family: "Charter";
  font-style: normal;
  font-weight: 400;
  font-stretch: normal;
  src: url("/fonts/charter_regular-webfont.woff") format("woff");
}

@font-face {
  font-family: "Charter";
  font-style: italic;
  font-weight: 400;
  font-stretch: normal;
  src: url("/fonts/charter_italic-webfont.woff") format("woff");
}

@font-face {
  font-family: "Charter";
  font-style: normal;
  font-weight: 700;
  font-stretch: normal;
  src: url("/fonts/charter_bold-webfont.woff") format("woff");
}

@font-face {
  font-family: "Charter";
  font-style: italic;
  font-weight: 700;
  font-stretch: normal;
  src: url("/fonts/charter_bold_italic-webfont.woff") format("woff");
}

@font-face {
  font-family: "Fira Mono";
  font-style: normal;
  font-weight: 400;
  font-stretch: normal;
  src: url("/fonts/FiraMono-Regular.woff") format("woff");
}

@font-face {
  font-family: "Fira Mono";
  font-style: normal;
  font-weight: 500;
  font-stretch: normal;
  src: url("/fonts/FiraMono-Medium.woff") format("woff");
}

◊(define font-family/main            ◊~a{"Charter", "Iowan Old Style", "Georgia", serif}))
◊(define font-family/monospace       ◊~a{"Fira Mono", "Menlo", "Monaco", "Courier New", monospace}))
◊(define font-size/extra-small       (px->rem 12))
◊(define font-size/small             (px->rem 13))
◊(define font-size/medium            (px->rem 16))
◊(define font-size/large             (px->rem 20))
◊(define font-size/extra-large       (px->rem 22))
◊(define font-size/extra-extra-large (px->rem 30))
◊(define line-height/extra-small     1)
◊(define line-height/small           1.3)
◊(define line-height/medium          1.5)
◊(define line-height/large           2)
◊(define text-indent                 1.5)
◊(define letter-spacing              0.2)

/****************************************************************************************************/
/* COLORS */

◊(define solarized/base03  ◊~a{#002b36})
◊(define solarized/base02  ◊~a{#073642})
◊(define solarized/base01  ◊~a{#586e75})
◊(define solarized/base00  ◊~a{#657b83})
◊(define solarized/base0   ◊~a{#839496})
◊(define solarized/base1   ◊~a{#93a1a1})
◊(define solarized/base2   ◊~a{#eee8d5})
◊(define solarized/base3   ◊~a{#fdf6e3})
◊(define solarized/yellow  ◊~a{#b58900})
◊(define solarized/orange  ◊~a{#cb4b16})
◊(define solarized/red     ◊~a{#dc322f})
◊(define solarized/magenta ◊~a{#d33682})
◊(define solarized/violet  ◊~a{#6c71c4})
◊(define solarized/blue    ◊~a{#268bd2})
◊(define solarized/cyan    ◊~a{#2aa198})
◊(define solarized/green   ◊~a{#859900})

◊(define color/background           solarized/base3)
◊(define color/background-highlight solarized/base2)
◊(define color/secondary-content    solarized/base1)
◊(define color/primary-content      solarized/base00)
◊(define color/emphasized-content   solarized/base01)
◊(define color/yellow               solarized/yellow)
◊(define color/orange               solarized/orange)
◊(define color/red                  solarized/red)
◊(define color/magenta              solarized/magenta)
◊(define color/violet               solarized/violet)
◊(define color/blue                 solarized/blue)
◊(define color/cyan                 solarized/cyan)
◊(define color/green                solarized/green)

/****************************************************************************************************/
/* BORDERS */

◊(define border-width/thin  1)
◊(define border-width/thick 3)
◊(define border-radius/none space/none)
◊(define border-radius      space/extra-small)

/****************************************************************************************************/
/* ANIMATIONS */

◊(define animation/duration 0.3)

/****************************************************************************************************/
/* MIXINS */

◊(define inline-block-enumeration
  ◊~a{
    line-height: ◊|line-height/large|rem;
    display: inline-block;
    margin-right: ◊|space/medium|rem;
  })

◊(define insertion
   ◊~a{
     box-sizing: border-box;
     width: 100%;
     margin: ◊|space/small|rem ◊|space/none|rem;
   })

/****************************************************************************************************/
/* GRID */

*, *::before, *::after {
  outline: none;
}

body {
  margin: ◊|space/large|rem auto;
  padding: ◊|space/none|rem ◊|grid/padding|rem;
  max-width: ◊|grid/article|rem;
}

@media ◊grid/bigger-screens {
  body {
    max-width: ◊|grid/body|rem;
  }

  article {
    width: ◊|grid/article|rem;
  }

  aside {
    width: ◊|grid/margin-note|rem;
    float: right;
    clear: right;
    margin-right: -◊|grid/margin-note/pull|rem;
  }
}

.full-width {
  ◊insertion
  clear: both;
}

@media ◊grid/bigger-screens {
  .full-width {
    width: ◊|grid/body|rem;
  }
}

/****************************************************************************************************/
/* HEADERS */

body > header {
  border-bottom: ◊|border-width/thin|px solid ◊|color/secondary-content|;
  margin-bottom: ◊|space/extra-large|rem;
}

body > header nav {
  margin-bottom: ◊|space/small|rem;
}

body > header nav a {
  ◊inline-block-enumeration
  font-size: ◊|font-size/small|rem;
  text-transform: uppercase;
  letter-spacing: ◊|letter-spacing|em;
  text-decoration: none;
}

body > header nav a.active {
  border-bottom-left-radius: ◊|border-radius/none|rem;
  border-bottom-right-radius: ◊|border-radius/none|rem;
  border-bottom: ◊|border-width/thin|px solid ◊|color/secondary-content|;
  margin-bottom: -◊|border-width/thin|px;
}

article > header {
  margin-bottom: ◊|space/medium|rem;
}

time {
  font-weight: 400;
  font-size: ◊|font-size/small|rem;
  color: ◊|color/secondary-content|;
}

/****************************************************************************************************/
/* HEADINGS */

h1, h2, h3, h4  {
  color: ◊|color/emphasized-content|;
  margin-top: ◊|space/extra-large|rem;
  margin-bottom: ◊|space/small|rem;
  line-height: ◊|line-height/small|;
}

h1 a, h2 a, h3 a, h4 a {
  text-decoration: none;
  color: ◊|color/emphasized-content|;
}

h1 {
  font-size: ◊|font-size/extra-extra-large|rem;
  font-style: italic;
  font-weight: 400;
}

h2 {
  font-size: ◊|font-size/extra-large|rem;
  font-style: italic;
  font-weight: 400;
  margin-bottom: ◊|space/extra-small|rem;
}

h3 {
  font-size: ◊|font-size/large|rem;
  font-style: italic;
  font-weight: 400;
}

h4 {
  font-size: ◊|font-size/medium|rem;
  font-weight: 700;
}

h3 + h4, header + h4 {
  margin-top: ◊|space/medium|rem;
}

h3 .mark, h4 .mark {
  transition: opacity ◊|animation/duration|s;
  opacity: 0;
  margin-left: ◊|space/small|rem;
  color: ◊|color/secondary-content|;
}

h3:hover .mark, h4:hover .mark {
opacity: 1;
}

h3 .mark a, h4 .mark a {
  color: ◊|color/secondary-content|;
}

.new-thought {
  height: ◊|space/extra-large|rem;
}

/****************************************************************************************************/
/* BODY */

body {
  ◊prefix['font-synthesis]{none}
  ◊prefix['font-kerning]{normal}
  ◊prefix['text-rendering]{optimizeLegibility}
  font-family: ◊|font-family/main|;
  font-size: ◊|font-size/medium|rem;
  background-color: ◊|color/background|;
  color: ◊|color/primary-content|;
  line-height: ◊|line-height/medium|;
}

p {
  margin: ◊|space/none|rem;
}

p + p {
  text-indent: ◊|text-indent|rem;
}

@media ◊grid/bigger-screens {
  p                                 + aside + p,
  p                         + aside + aside + p,
  p                 + aside + aside + aside + p,
  p         + aside + aside + aside + aside + p,
  p + aside + aside + aside + aside + aside + p {
    text-indent: ◊|text-indent|rem;
  }
}

/****************************************************************************************************/
/* MARGIN NOTES */

@media ◊grid/smaller-screens {
  aside {
    ◊insertion
    border-left: ◊|border-width/thick|px solid ◊|color/secondary-content|;
    border-radius: ◊|border-radius|rem;
    padding: ◊|text-indent|rem;
    padding-left: calc(◊|text-indent|rem - ◊|border-width/thick|px);
    background-color: ◊|color/background-highlight|;
    color: ◊|color/emphasized-content|;
  }
}

@media ◊grid/bigger-screens {
  aside {
    font-size: ◊|font-size/small|rem;
    margin-bottom: ◊|space/large|rem;
  }
}

/****************************************************************************************************/
/* FIGURES */

figure {
  ◊insertion
  text-align: center;
}

figcaption {
  font-style: italic;
}

img, svg {
  max-width: 100%;
  height: auto;
}

/****************************************************************************************************/
/* CODE */

code {
  font-family: ◊|font-family/monospace|;
}

.code-block {
  ◊insertion
  font-size: ◊|font-size/extra-small|rem;
}

pre {
  font-family: ◊|font-family/monospace|;
  background-color: ◊|color/background|;
  overflow: auto;
  padding: ◊|text-indent|rem;
  padding-left: calc(◊|text-indent|rem - ◊|border-width/thin|px);
  border: ◊|border-width/thin|px solid ◊|color/secondary-content|;
  border-radius: ◊|border-radius|rem;
  margin: ◊|space/none|rem;
}

◊(file->string "stylesheets/solarized-light.css.p")

/****************************************************************************************************/
/* LISTS */

ul, ol {
  ◊insertion
  padding-left: ◊|text-indent|rem;
}

/****************************************************************************************************/
/* TABLES */

table {
  ◊insertion
}

tbody + tbody::before {
  content: "";
  display: block;
  height: ◊|space/small|rem;
}

th, td {
  padding: ◊|space/none|rem;
  padding-right: ◊|space/medium|rem;
}

th:last-child, td:last-child {
  padding-right: ◊|space/none|rem;
}

th {
  font-weight: 700;
  text-align: left;
}

/****************************************************************************************************/
/* INLINE */

a {
  transition: background-color ◊|animation/duration|s;
  border-radius: ◊|border-radius|rem;
  color: ◊|color/primary-content|;
}

a:hover {
  background-color: ◊|color/background-highlight|;
  color: ◊|color/emphasized-content|;
}

@media ◊grid/smaller-screens {
  aside a {
    color: ◊|color/emphasized-content|;
  }

  aside a:hover {
    background-color: ◊|color/background|;
    color: ◊|color/primary-content|;
  }
}

kbd {
  font-family: ◊|font-family/monospace|;
}

.fraction {
  font-size: ◊|font-size/small|rem;
}

.fraction .numerator {
  vertical-align: super;
}

.fraction .denominator {
  vertical-align: sub;
}

.fraction .slash {
  margin: ◊|space/none|rem -◊|space/extra-extra-small|rem;
}

.placeholder {
  color: ◊|color/blue|;
}

.menu-option {
  font-weight: 700;
}

/****************************************************************************************************/
/* REMOVE ME! */

◊(css-expr->css (append-map cdr (components/css)))