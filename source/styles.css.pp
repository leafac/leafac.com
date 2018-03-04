#lang pollen

/****************************************************************************************************/
/* NORMALIZE */

◊(file->string "stylesheets/normalize.css.p")

/****************************************************************************************************/
/* FONTS */

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

/****************************************************************************************************/
/* GRID */

*, *::before, *::after {
  outline: none;
}

body {
  margin: ◊|space/large| auto;
  padding: ◊|space/none| ◊|grid/padding|;
  max-width: ◊|grid/main|;
}

@media ◊grid/bigger-screens {
  body {
    max-width: ◊|grid/body|;
  }

  main {
    width: ◊|grid/main|;
  }

  aside {
    width: ◊|grid/margin-note|;
    float: right;
    clear: right;
    margin-right: -◊|grid/margin-note/pull|;
  }
}

.full-width {
  ◊insertion
  clear: both;
}

@media ◊grid/bigger-screens {
  .full-width {
    width: ◊|grid/body|;
  }
}

/****************************************************************************************************/
/* HEADERS */

body > header {
  border-bottom: ◊|border-width/thin| solid ◊|color/secondary-content|;
  margin-bottom: ◊|space/extra-large|;
}

body > header nav {
  margin-bottom: ◊|space/small|;
}

body > header nav a {
  ◊inline-block-enumeration
  font-size: ◊|font-size/small|;
  text-transform: uppercase;
  letter-spacing: ◊|letter-spacing|;
  text-decoration: none;
}

body > header nav a.active {
  border-bottom-left-radius: ◊|border-radius/none|;
  border-bottom-right-radius: ◊|border-radius/none|;
  border-bottom: ◊|border-width/thin| solid ◊|color/secondary-content|;
  margin-bottom: -◊|border-width/thin|;
}

main > header {
  margin-bottom: ◊|space/medium|;
}

time {
  font-weight: 400;
  font-size: ◊|font-size/small|;
  color: ◊|color/secondary-content|;
}

/****************************************************************************************************/
/* HEADINGS */

h1, h2, h3, h4  {
  color: ◊|color/emphasized-content|;
  margin-top: ◊|space/extra-large|;
  margin-bottom: ◊|space/small|;
  line-height: ◊|line-height/small|;
}

h1 a, h2 a, h3 a, h4 a {
  text-decoration: none;
  color: ◊|color/emphasized-content|;
}

h1 {
  font-size: ◊|font-size/extra-extra-large|;
  font-style: italic;
  font-weight: 400;
}

h2 {
  font-size: ◊|font-size/extra-large|;
  font-style: italic;
  font-weight: 400;
  margin-bottom: ◊|space/extra-small|;
}

h3 {
  font-size: ◊|font-size/large|;
  font-style: italic;
  font-weight: 400;
}

h4 {
  font-size: ◊|font-size/medium|;
  font-weight: 700;
}

h3 .mark, h4 .mark {
  transition: opacity ◊|animation/duration|;
  opacity: 0;
  margin-left: ◊|space/small|;
  color: ◊|color/secondary-content|;
}

h3:hover .mark, h4:hover .mark {
  opacity: 1;
}

h3 .mark a, h4 .mark a {
  color: ◊|color/secondary-content|;
}

hr {
  border: none;
  margin: ◊|space/none|;
  height: ◊|space/large|;
}

/****************************************************************************************************/
/* BODY */

body {
  ◊prefix['font-synthesis]{none}
  ◊prefix['font-kerning]{normal}
  ◊prefix['text-rendering]{optimizeLegibility}
  font-family: ◊|font-family/main|;
  font-size: ◊|font-size/medium|;
  background-color: ◊|color/background|;
  color: ◊|color/primary-content|;
  line-height: ◊|line-height/medium|;
}

p {
  margin: ◊|space/none|;
}

p + p {
  text-indent: ◊|text-indent|;
}

@media ◊grid/bigger-screens {
  p                                 + aside + p,
  p                         + aside + aside + p,
  p                 + aside + aside + aside + p,
  p         + aside + aside + aside + aside + p,
  p + aside + aside + aside + aside + aside + p {
    text-indent: ◊|text-indent|;
  }
}

/****************************************************************************************************/
/* MARGIN NOTES */

@media ◊grid/smaller-screens {
  aside {
    ◊insertion
    border-left: ◊|border-width/thick| solid ◊|color/secondary-content|;
    border-radius: ◊|border-radius|;
    padding: ◊|text-indent|;
    padding-left: calc(◊|text-indent| - ◊|border-width/thick|);
    background-color: ◊|color/background-highlight|;
    color: ◊|color/emphasized-content|;
  }
}

@media ◊grid/bigger-screens {
  aside {
    font-size: ◊|font-size/small|;
    margin-bottom: ◊|space/large|;
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

pre, code, var, samp, kbd {
  font-family: ◊|font-family/monospace|;
}

.code-block {
  ◊insertion
  font-size: ◊|font-size/extra-small|;
}

pre {
  background-color: ◊|color/background|;
  overflow: auto;
  padding: ◊|text-indent|;
  padding-left: calc(◊|text-indent| - ◊|border-width/thin|);
  border: ◊|border-width/thin| solid ◊|color/secondary-content|;
  border-radius: ◊|border-radius|;
  margin: ◊|space/none|;
}

◊(file->string "stylesheets/solarized-light.css.p")

/****************************************************************************************************/
/* LISTS */

ul, ol {
  ◊insertion
  padding-left: ◊|text-indent|;
}

/****************************************************************************************************/
/* TABLES */

table {
  ◊insertion
}

tbody + tbody::before {
  content: "";
  display: block;
  height: ◊|space/small|;
}

th, td {
  padding: ◊|space/none|;
  padding-right: ◊|space/medium|;
}

th:last-child, td:last-child {
  padding-right: ◊|space/none|;
}

th {
  font-weight: 700;
  text-align: left;
}

/****************************************************************************************************/
/* INLINE */

a {
  transition: background-color ◊|animation/duration|;
  border-radius: ◊|border-radius|;
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

.fraction--slash {
  margin: ◊|space/none| -◊|space/extra-extra-small|;
}

.placeholder {
  color: ◊|color/blue|;
}

.menu-option {
  font-weight: 700;
}
