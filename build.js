const glob = require("glob");
const fs = require("fs");
const marked = require("marked");
const { JSDOM } = require("jsdom");

(async () => {
  const paths = glob.sync("**/*.md", {
    ignore: ["**/node_modules/**", "CODE_OF_CONDUCT.md", "README.md"],
  });
  for (const path of paths) {
    const markdown = fs.readFileSync(path, "utf8");
    const html = marked(markdown);
    const document = new JSDOM(html).window.document.body;
    await processHTML(document);
    fs.writeFileSync(
      `${path.slice(0, path.length - ".md".length)}.html`,
      `<!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Leandro Facchinetti</title>
          </head>
          <body>
            <header>
            </header>
            <main>
              ${document.innerHTML}
            </main>
          </body>
        </html>
      `
    );
  }
})();

async function processHTML(/** @type {Document} */ document) {}
