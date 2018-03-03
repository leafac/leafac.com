#lang pollen

/****************************************************************************************************/
/* IMPORTS */

◊(string-append*
  (for/list ([file '("stylesheets/normalize.css.p"
                     "stylesheets/solarized-light.css.p")])
    (file->string file)))

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

◊(define grid/body (px->rem 1000))
◊(define grid/padding (px->rem 12))
◊(define grid/article (px->rem 600))
◊(define grid/gutter (px->rem 75))
◊(define grid/margin-note (px->rem 325))
◊(define grid/margin-note/pull (+ grid/gutter grid/margin-note))
◊(define grid/breakpoint (+ grid/body (* grid/padding 2)))
◊(define grid/bigger-screens ◊~a{(min-width:◊|grid/breakpoint|rem)})
◊(define grid/smaller-screens ◊~a{(max-width:◊(- grid/breakpoint 0.01)rem)})

/****************************************************************************************************/
/* SPACES */

◊(define space/none 0)
◊(define space/extra-small 0.2)
◊(define space/small 0.5)
◊(define space/medium 1)
◊(define space/large 1.5)
◊(define space/extra-large 2)

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

◊(define font-family/main ◊~a{font-family: "Charter", "Iowan Old Style", "Georgia", serif;}))
◊(define font-family/monospace ◊~a{font-family: "Fira Mono", "Menlo", "Monaco", "Courier New", monospace;}))
◊(define font-size/extra-small (px->rem 12))
◊(define font-size/small (px->rem 13))
◊(define font-size/medium (px->rem 16))
◊(define font-size/large (px->rem 20))
◊(define font-size/extra-large (px->rem 22))
◊(define font-size/extra-extra-large (px->rem 30))
◊(define line-height/extra-small 1)
◊(define line-height/small 1.3)
◊(define line-height/medium 1.5)
◊(define line-height/large 2)
◊(define text-indent 1.5)
◊(define letter-spacing 0.2)

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
/* RULERS */

◊(define ruler/thin 1)
◊(define ruler/thick 3)

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
/* TEMPLATE */

*, *::before, *::after {
  outline: none;
}

body {
  ◊prefix['font-synthesis]{none}
  ◊prefix['font-kerning]{normal}
  ◊prefix['text-rendering]{optimizeLegibility}
  ◊font-family/main
}

body > header {
  border-bottom: ◊|ruler/thin|px solid ◊|color/secondary-content|;
  margin-bottom: ◊|space/extra-large|rem;
}

body > header h1 {
  font-size: ◊|font-size/extra-extra-large|rem;
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
  border-radius: ◊|space/none|rem;
  border-bottom: ◊|ruler/thin|px solid ◊|color/secondary-content|;
  margin-bottom: -◊|ruler/thin|px;
}

/****************************************************************************************************/
/* REMOVE ME! */

◊(css-expr->css (append-map cdr (components/css)))