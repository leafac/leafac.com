const glob = require("glob");
const fs = require("fs");
const path = require("path");
const remark = require("remark");
const { JSDOM } = require("jsdom");
const mathJax = require("mathjax-node");
const shiki = require("shiki");
const rangeParser = require("parse-numeric-range");
const GitHubSlugger = require("github-slugger");
const html = require("tagged-template-noop");

(async () => {
  for (const markdownPath of glob.sync("**/*.md", {
    ignore: [
      "node_modules/**",
      "typeface-pt-serif/**",
      "typeface-pt-mono/**",
      "CODE_OF_CONDUCT.md",
      "README.md",
    ],
  })) {
    // Render Markdown
    const htmlPath = markdownPath.replace(/\.md$/, ".html");
    const markdown = fs.readFileSync(markdownPath, "utf8");
    const renderedMarkdown = remark()
      .use({ settings: { commonmark: true } })
      .use(require("remark-html"))
      .processSync(markdown).contents;
    const documentSource = html`
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8" />
          <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
          />
          <title>Leandro Facchinetti</title>
          <meta name="author" content="Leandro Facchinetti" />
          <meta
            name="description"
            content="I’m a PhD candidate in Computer Science. I’m interested in writing & reading, music & video production, running, mindfulness, minimalism, and veganism."
          />
          <link rel="stylesheet" href="/styles.css" />
          <link
            rel="icon"
            type="image/png"
            sizes="32x32"
            href="/favicon-32x32.png"
          />
          <link
            rel="icon"
            type="image/png"
            sizes="16x16"
            href="/favicon-16x16.png"
          />
          <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
        </head>
        <body>
          <header>
            <h1><a href="/">Leandro Facchinetti</a></h1>
            <p>
              ${Object.entries({
                About: "/",
                "Tutorial Videos":
                  "https://www.youtube.com/playlist?list=PLQKZfz89aDZzx2STVeABdqG4zdR2UNGSs",
                Articles: "/#articles",
                Songs:
                  "https://www.youtube.com/playlist?list=PLQKZfz89aDZw6naqDCSrS1KGq4fAls3Os",
                GitHub: "https://github.com/leafac",
                YouTube:
                  "https://www.youtube.com/channel/UC_R-6HcHW5V9_FlZe30tnGA",
                News: "/#news",
                "Curriculum Vitae": "/curriculum-vitae/",
                Email: "mailto:me@leafac.com",
              })
                .map(([content, href]) => `<a href="${href}">${content}</a>`)
                .join(" · ")}
            </p>
          </header>
          <main>
            ${renderedMarkdown}
          </main>
        </body>
      </html>
    `.trim();
    const dom = new JSDOM(documentSource);
    const document = dom.window.document;

    // Slugify headings
    const slugger = new GitHubSlugger();
    for (const element of document.querySelectorAll("h1, h2, h3, h4, h5, h6"))
      element.id = slugger.slug(element.textContent);

    // Add Table of Contents
    const tableOfContents = html`
      <ul>
        ${[
          ...document.querySelectorAll(
            "h1:not(:first-child), h2, h3, h4, h5, h6"
          ),
        ]
          .filter((header) => header.textContent !== "Table of Contents")
          .map(
            (header) =>
              html`<li><a href="#${header.id}">${header.innerHTML}</a></li>`
          )
          .join("")}
      </ul>
    `;
    for (const element of document.querySelectorAll(
      "code.language-table-of-contents"
    ))
      element.parentElement.outerHTML = tableOfContents;

    // Render mathematics
    for (const element of document.querySelectorAll(
      "pre > code.language-math"
    )) {
      const renderedMath = (
        await mathJax.typeset({
          math: element.textContent,
          svg: true,
        })
      ).svg;
      element.parentElement.outerHTML = html`<figure>${renderedMath}</figure>`;
    }
    for (const element of [
      ...document.querySelectorAll(":not(pre) > code"),
    ].filter((element) => element.textContent.startsWith("math`")))
      element.outerHTML = (
        await mathJax.typeset({
          math: element.textContent.slice("math`".length),
          svg: true,
        })
      ).svg;

    // Add syntax highlighting
    const highlighter = await shiki.getHighlighter({ theme: "light_plus" });
    for (const element of document.querySelectorAll(
      `pre > code[class^="language-"]`
    )) {
      const { language, options } = element.className.match(
        /^language-(?<language>[a-z]+)(?<options>.*)$/
      ).groups;
      const code = element.textContent;
      let shouldNumberLines = false;
      let linesToHighlight = [];
      for (const option of options.match(/(?<=\{).*?(?=\})/g) ?? [])
        if (option === "number") shouldNumberLines = true;
        else if (option.match(/^[0-9,\-\.]+$/))
          linesToHighlight = rangeParser(option);
        else console.error(`Unrecognized option for code block: ${option}`);
      let highlightedText;
      try {
        highlightedText = highlighter.codeToHtml(code, language);
      } catch (error) {
        console.error(error);
        continue;
      }
      const highlightedCode = JSDOM.fragment(highlightedText).querySelector(
        "code"
      );
      const listing = JSDOM.fragment(
        html`
          <table class="listing">
            ${highlightedCode.innerHTML
              .split("\n")
              .map(
                (line) =>
                  html`
                    <tr>
                      <td>
                        <pre><code>${line === "" ? " " : line}</code></pre>
                      </td>
                    </tr>
                  `
              )
              .join("\n")}
          </table>
        `
      ).querySelector("table");
      const lines = listing.querySelectorAll("tr");
      if (shouldNumberLines)
        for (const [index, line] of Object.entries(lines)) {
          const lineNumber = Number(index) + 1;
          line.insertAdjacentHTML(
            "afterbegin",
            html`
              <td class="line-number">
                <pre><code>${lineNumber}</code></pre>
              </td>
            `
          );
        }
      for (const lineToHighlight of linesToHighlight) {
        const line = lines[lineToHighlight - 1];
        if (line === undefined) {
          console.error(
            `Failed to highlight line out of range: ${lineToHighlight}`
          );
          continue;
        }
        line.classList.add("highlighted-line");
      }
      element.parentElement.outerHTML = listing.outerHTML;
    }
    for (const element of [
      ...document.querySelectorAll(":not(pre) > code"),
    ].filter((element) => element.textContent.match(/^[a-z]+`/))) {
      const { language, code } = element.textContent.match(
        /^(?<language>[a-z]+)`(?<code>.*)$/
      ).groups;
      let highlightedText;
      try {
        highlightedText = highlighter.codeToHtml(code, language);
      } catch (error) {
        console.error(error);
        continue;
      }
      const highlightedCode = JSDOM.fragment(highlightedText).querySelector(
        "code"
      );
      element.innerHTML = highlightedCode.innerHTML;
    }

    // Inline SVGs
    for (const element of document.querySelectorAll(`img[src$=".svg"]`)) {
      const svgPath = path.join(
        path.dirname(htmlPath),
        element.getAttribute("src")
      );
      if (!fs.existsSync(svgPath)) {
        console.error(`${htmlPath}: Image not found: ${svgPath}`);
        continue;
      }
      element.outerHTML = fs.readFileSync(svgPath, "utf8");
    }

    // Make URLs monospaced
    for (const element of document.querySelectorAll("a"))
      if (
        element.getAttribute("href") === element.innerHTML ||
        element.getAttribute("href") === `mailto:${element.innerHTML}`
      )
        element.innerHTML = html`<code>${element.innerHTML}</code>`;

    // Add title
    const title = document.querySelector("main h1:first-child");
    if (title !== null)
      document
        .querySelector("title")
        .insertAdjacentText("afterbegin", `${title.textContent} · `);

    // Render HTML
    fs.writeFileSync(htmlPath, dom.serialize());
  }
})();
