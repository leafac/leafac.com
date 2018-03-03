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
