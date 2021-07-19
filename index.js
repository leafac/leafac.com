const fs = require("fs/promises");
const { html } = require("@leafac/html");
const { css, extractInlineStyles } = require("@leafac/css");

(async () => {
  await fs.writeFile(
    "index.html",
    extractInlineStyles(html`
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
            content="I’m a computer scientist interested in audio/video application development, web development, and programming languages. In my spare time I make videos about programming and audio/video production, and develop open-source software."
          />
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
          <link
            rel="stylesheet"
            href="/vendor/node_modules/@ibm/plex/css/ibm-plex.min.css"
          />
          <style>
            body {
              font-family: "IBM Plex Mono";
              line-height: 1.5;
              -webkit-text-size-adjust: 100%;
              max-width: 600px;
              padding: 0 1rem;
              margin: 0 auto;
            }

            @media (prefers-color-scheme: dark) {
              body {
                color: #d4d4d4;
                background-color: #1e1e1e;
              }
            }

            a {
              color: inherit;
            }

            header a {
              text-decoration: none;
            }

            h1 {
              font-size: 1.5rem;
            }

            img {
              max-width: 100%;
              height: auto;
            }

            header {
              text-align: center;
            }
          </style>
        </head>
        <body>
          <header>
            <h1><a href="https://leafac.com">Leandro Facchinetti</a></h1>
            <p>
              <strong
                ><a
                  href="https://www.youtube.com/channel/UC_R-6HcHW5V9_FlZe30tnGA"
                  >YouTube</a
                ></strong
              > · <strong><a href="https://github.com/leafac">GitHub</a></strong
              > ·
              <strong><a href="https://patreon.com/leafac">Patreon</a></strong
              > ·
              <strong
                ><a href="https://paypal.me/LeandroFacchinetti"
                  >PayPal</a
                ></strong
              > ·
              <strong
                ><a href="/leandro-facchinetti--resume.pdf">Résumé</a></strong
              > ·
              <strong
                ><a href="/leandro-facchinetti--curriculum-vitae.pdf"
                  >Curriculum Vitæ</a
                ></strong
              > ·
              <strong><a href="mailto:me@leafac.com">Contact</a></strong>
            </p>
            <p><img src="avatar.png" alt="Avatar" width="300" /></p>
          </header>
          <main>
            <p>I’m a computer scientist.</p>
            <p>
              I’m interested in audio/video application development, web
              development, and programming languages.
            </p>
            <p>
              I’m working on <a href="https://courselore.org">CourseLore</a>,
              the open-source student forum.
            </p>
            <p>
              I was a PhD Candidate in computer science (programming languages)
              at the Johns Hopkins University. I had to end without a degree due
              to a combination of life circumstances: end of funding, the
              pandemic, the birth of my first son, having to move abroad, and so
              forth.
            </p>
            <p>I live in Portugal.</p>
            <p>
              In my spare time I make
              <a href="https://www.youtube.com/channel/UC_R-6HcHW5V9_FlZe30tnGA"
                >videos about programming and audio/video production</a
              >, develop
              <a href="https://github.com/leafac">open-source software</a>, run,
              bike, play the guitar, cook vegan foods, and spend time with my
              wife and son.
            </p>
          </main>
        </body>
      </html>
    `)
  );

  for (const [from, to] of Object.entries({
    2: "https://github.com/leafac/yocto-cfa",
    7: "https://oose-2019.leafac.com",
    8: "https://www.youtube.com/playlist?list=PLQKZfz89aDZwCKTCHgPBplQuJ3ViFIq3M",
    9: "https://github.com/leafac/oose-2019-roboose",
    10: "https://leafac.com/publications/oose.pdf",
    11: "https://oose-2019.leafac.com/fun-stuff-students-did/",
    12: "https://www.youtube.com/playlist?list=PLQKZfz89aDZzxKlgYEtvUxdywIEG0lZ9L",
    13: "https://www.youtube.com/playlist?list=PLQKZfz89aDZz08np6JsJkZrPnip-zUzSg",
    14: "https://www.youtube.com/watch?v=4iGkcq9g0tc",
    15: "https://github.com/leafac/lights-out",
    16: "https://leafac-oose-lights-out.herokuapp.com",
    17: "https://github.com/leafac/todo",
    18: "https://leafac-oose-todo.herokuapp.com",
    19: "https://leafac.com/publications/higher-order-demand-driven-program-analysis.pdf",
    20: "https://dl.acm.org/doi/10.1145/3310340",
    21: "https://leafac.com/publications/sdl--a-dsl-for-cryptographic-schemes.pdf",
    22: "https://leafac.com/publications/relative-store-fragments-for-singleton-abstraction.pdf",
    23: "https://link.springer.com/chapter/10.1007%2F978-3-319-66706-5_6",
    24: "https://leafac.com/publications/towards-practical-higher-order-demand-driven-program-analysis.pdf",
    25: "https://leafac.com/publications/towards-practical-higher-order-demand-driven-program-analysis.key",
    26: "https://leafac.com/publications/practical-demand-driven-program-analysis-with-recursion.pdf",
    27: "https://leafac.com/publications/higher-order-demand-driven-program-analysis--artifact.pdf",
    28: "https://leafac.com/publications/higher-order-demand-driven-program-analysis--artifact.tgz",
    29: "http://2016.ecoop.org/event/ecoop-2016-artifacts-higher-order-demand-driven-program-analysis",
    30: "https://leafac.com/publications/what-is-your-function--static-pattern-matching-on-function-behavior.pdf",
    31: "https://leafac.com/publications/pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos.pdf",
    32: "https://leafac.com/publications/sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes.pdf",
    33: "https://leafac.com/publications/navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens.pdf",
    34: "https://www.kill-the-newsletter.com",
    35: "https://github.com/leafac/shiki-latex",
    36: "https://github.com/leafac/collections-deep-equal",
    37: "https://github.com/leafac/latex-dissertation-template-for-the-johns-hopkins-university",
    38: "https://github.com/leafac/oose-2019-roboose",
    39: "https://github.com/leafac/pollen-component/",
    40: "https://github.com/leafac/css-expr/",
    41: "https://github.com/leafac/extensible-functions/",
    42: "https://github.com/leafac/org-password-manager",
    43: "https://github.com/leafac/programmable-foot-keyboard",
    44: "https://leafac.com/publications/a-set-based-context-model-for-program-analysis.pdf",
    45: "https://conf.researchr.org/details/aplas-2020/aplas-2020-papers/2/A-Set-Based-Context-Model-for-Program-Analysis",
    46: "https://www.youtube.com/channel/UC_R-6HcHW5V9_FlZe30tnGA",
    47: "https://github.com/leafac/obs-cli",
    48: "https://github.com/leafac/reaper",
    49: "https://github.com/leafac/caxa",
    50: "https://github.com/leafac/sqlite",
    51: "https://github.com/leafac/sqlite-migration",
    52: "https://github.com/leafac/html",
    53: "https://github.com/leafac/css",
    54: "https://github.com/leafac/rehype-shiki",
    55: "https://github.com/leafac/express-async-handler",
  }))
    await fs.writeFile(
      `${from}.html`,
      html`<!DOCTYPE html>
        <meta charset="utf-8" />
        <title>Redirecting to ${to}</title>
        <meta http-equiv="refresh" content="0; URL=${to}" />
        <h1>Redirecting to ${to}</h1> `
    );
})();
