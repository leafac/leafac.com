const glob = require("glob");
const fs = require("fs");
const path = require("path");
const marked = require("marked");
const { JSDOM } = require("jsdom");
const shiki = require("shiki");
const rangeParser = require("parse-numeric-range");
const katex = require("katex");

(async () => {
  for (const markdownPath of glob.sync("**/*.md", {
    ignore: ["**/node_modules/**", "CODE_OF_CONDUCT.md", "README.md"],
  })) {
    const htmlPath = markdownPath.replace(/\.md$/, ".html");
    const markdown = fs.readFileSync(markdownPath, "utf8");
    const renderedMarkdown = marked(markdown);
    const html = `<!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Leandro Facchinetti</title>
          <meta name="author" content="Leandro Facchinetti">
          <meta name="description" content="I’m a PhD candidate in Computer Science. I’m interested in writing & reading, music & video production, running, mindfulness, minimalism, and veganism.">
          <link rel="stylesheet" href="/styles.css">
          <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
          <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
          <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico">      
        </head>
        <body>
          <header><h1><a href="/">Leandro Facchinetti</a></h1></header>
          <main>${renderedMarkdown}</main>
        </body>
      </html>
    `;
    const dom = new JSDOM(html);
    await processHTML(dom.window.document, htmlPath);
    fs.writeFileSync(htmlPath, dom.serialize());
  }
})();

async function processHTML(/** @type {Document} */ document, htmlPath) {
  // Add Table of Contents
  document
    .querySelector("#table-of-contents")
    ?.insertAdjacentHTML(
      "afterend",
      [...document.querySelectorAll("h1, h2, h3, h4, h5, h6")]
        .map(
          (header) => `<p><a href="#${header.id}">${header.innerHTML}</a></p>`
        )
        .join("")
    );

  // Render mathematics
  document.head.insertAdjacentHTML(
    "beforeend",
    `<link rel="stylesheet" href="/vendor/node_modules/katex/dist/katex.css">`
  );
  for (const element of document.querySelectorAll("code")) {
    const isBlock = element.parentElement.tagName === "PRE";
    if (isBlock) {
      if (element.className !== "language-math") continue;
      const renderedMath = katex.renderToString(
        `\\displaystyle ${element.textContent}`
      );
      element.parentElement.outerHTML = `<figure>${renderedMath}</figure>`;
    } else {
      if (!element.textContent.startsWith("math`")) continue;
      element.outerHTML = katex.renderToString(
        element.textContent.slice("math`".length)
      );
    }
  }

  // Add syntax highlighting
  const highlighter = await shiki.getHighlighter({ theme: "light_plus" });
  for (const element of document.querySelectorAll("code")) {
    let code;
    let language;
    let shouldNumberLines = false;
    let linesToHighlight = [];
    const isBlock = element.parentElement.tagName === "PRE";
    if (isBlock) {
      const match = element.className.match(
        /^language-(?<language>.*?)(?:\{(?<options>.*)\})?$/
      );
      if (match === null) continue;
      code = element.textContent;
      language = match.groups.language;
      for (const option of (match.groups.options ?? "").split("}{"))
        if (option === "number") shouldNumberLines = true;
        else if (option.match(/^[0-9,\-\.]+$/))
          linesToHighlight = rangeParser(option);
        else
          console.error(
            `${htmlPath}: Unrecognized option for code block: ${option}`
          );
    } else {
      const [languageSegment, ...codeSegments] = element.textContent.split("`");
      if (codeSegments.length === 0) continue;
      code = codeSegments.join("`");
      language = languageSegment;
    }
    let highlightedCode;
    try {
      highlightedCode = highlighter.codeToHtml(code, language);
    } catch (error) {
      console.error(`${htmlPath}: ${error}`);
      continue;
    }
    const highlightedLines = JSDOM.fragment(highlightedCode)
      .querySelector("code")
      .innerHTML.split("\n");
    if (shouldNumberLines) {
      const width = String(highlightedLines.length).length;
      for (const [index, line] of Object.entries(highlightedLines)) {
        const lineNumber = String(Number(index) + 1).padStart(width);
        highlightedLines[
          index
        ] = `<span style="color: #aaa;">${lineNumber}</span>  ${line}`;
      }
    }
    for (const lineToHighlight of linesToHighlight) {
      const index = lineToHighlight - 1;
      if (highlightedLines[index] === undefined) {
        console.error(
          `${htmlPath}: Failed to highlight line out of range: ${lineToHighlight}`
        );
        continue;
      }
      highlightedLines[
        index
      ] = `<div style="background-color: #e0ffff;">${highlightedLines[index]}`;
      highlightedLines[index + 1] = `</div>${
        highlightedLines[index + 1] ?? ""
      }`;
    }
    element.innerHTML = highlightedLines.join("\n");
  }

  // Make URLs monospaced
  for (const element of document.querySelectorAll("a"))
    if (
      element.innerHTML === element.getAttribute("href") ||
      `mailto:${element.innerHTML}` === element.getAttribute("href")
    )
      element.innerHTML = `<code>${element.innerHTML}</code>`;

  // Inline SVGs
  for (const element of document.querySelectorAll(`img[src$=".svg"]`)) {
    const svgPath = `${path.dirname(htmlPath)}/${element.getAttribute("src")}`;
    if (!fs.existsSync(svgPath)) {
      console.error(`${htmlPath}: Image not found: ${svgPath}`);
      continue;
    }
    const svg = JSDOM.fragment(fs.readFileSync(svgPath, "utf8")).querySelector(
      "svg"
    );
    for (const code of svg.querySelectorAll("[highlight]")) {
      let highlightedText;
      try {
        highlightedText = highlighter.codeToHtml(
          code.textContent,
          code.getAttribute("highlight")
        );
      } catch (error) {
        console.error(`${htmlPath}: ${error}`);
        continue;
      }
      const highlightedCode = JSDOM.fragment(highlightedText).querySelector(
        "code"
      );
      for (const span of highlightedCode.querySelectorAll("span")) {
        const style = span.getAttribute("style").replace(/color:/g, "fill:");
        span.outerHTML = `<tspan style="${style}">${span.innerHTML}</tspan>`;
      }
      code.innerHTML = highlightedCode.innerHTML;
    }
    element.outerHTML = svg.outerHTML;
  }

  // Add title
  const title = document.querySelector("main :first-child");
  if (title.tagName === "H1")
    document
      .querySelector("title")
      .insertAdjacentText("afterbegin", `${title.textContent} · `);
}
