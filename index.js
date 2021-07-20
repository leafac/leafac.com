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
          <link
            rel="stylesheet"
            href="/vendor/node_modules/@fortawesome/fontawesome-free/css/all.min.css"
          />
        </head>
        <body
          style="${css`
            font-family: "IBM Plex Mono", var(--font-family--monospace);
            font-size: var(--font-size--sm);
            line-height: var(--line-height--sm);
            color: var(--color--gray--warm--700);
            background-color: var(--color--gray--warm--100);
            @media (prefers-color-scheme: dark) {
              color: var(--color--gray--warm--300);
              background-color: var(--color--gray--warm--900);
            }
            display: flex;
            justify-content: center;
          `}"
        >
          <div
            style="${css`
              width: var(--width--prose);
              display: flex;
              flex-direction: column;
              gap: var(--space--4);
              a {
                @media (prefers-color-scheme: dark) {
                  &:hover,
                  &:focus-within {
                    color: var(--color--fuchsia--300);
                  }
                }
                transition-property: var(--transition-property--colors);
                transition-duration: var(--transition-duration--150);
                transition-timing-function: var(
                  --transition-timing-function--in-out
                );
              }
            `}"
          >
            <h1
              style="${css`
                font-size: var(--font-size--4xl);
                line-height: var(--line-height--4xl);
                font-weight: var(--font-weight--semibold);
                font-style: italic;
                text-align: center;
                color: var(--color--gray--warm--900);
                margin-top: var(--space--4);
                @media (prefers-color-scheme: dark) {
                  color: var(--color--gray--warm--50);
                }
              `}"
            >
              <a href="https://leafac.com">Leandro Facchinetti</a>
            </h1>
            <p
              style="${css`
                margin-top: var(--space--4);
                text-align: center;
              `}"
            >
              <img
                src="avatar.png"
                alt="Avatar"
                width="300"
                style="${css`
                  @media (prefers-color-scheme: dark) {
                    filter: brightness(var(--brightness--90));
                  }
                `}"
              />
            </p>
            <nav>
              <ul
                style="${css`
                  margin-top: var(--space--4);
                  display: flex;
                  flex-direction: column;
                  gap: var(--space--2);
                  i {
                    width: var(--space--4);
                  }
                `}"
              >
                <li>
                  <a
                    href="https://www.youtube.com/channel/UC_R-6HcHW5V9_FlZe30tnGA"
                    ><i class="fab fa-youtube"></i> YouTube: Streams about code
                    & audio production every weekday at 17:30 UTC</a
                  >
                </li>
                <li>
                  <a href="https://github.com/leafac"
                    ><i class="fab fa-github"></i> GitHub: Open-source projects
                    on web development & audio production</a
                  >
                </li>
                <li>
                  <a href="https://patreon.com/leafac"
                    ><i class="fab fa-patreon"></i> Patreon: Recurrent
                    contributions</a
                  >
                </li>
                <li>
                  <a href="https://paypal.me/LeandroFacchinetti"
                    ><i class="fab fa-paypal"></i> PayPal: One-time
                    contribution</a
                  >
                </li>
                <li>
                  <a href="/leandro-facchinetti--resume.pdf"
                    ><i class="far fa-file"></i> Résumé: A bit about me</a
                  >
                </li>
                <li>
                  <a href="/leandro-facchinetti--curriculum-vitae.pdf"
                    ><i class="far fa-copy"></i> Curriculum Vitæ: A lot about
                    me</a
                  >
                </li>
                <li>
                  <a href="mailto:me@leafac.com"
                    ><i class="far fa-envelope"></i> Email</a
                  >
                </li>
              </ul>
            </nav>
            <!--<main>
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
                I was a PhD Candidate in computer science (programming
                languages) at the Johns Hopkins University. I had to end without
                a degree due to a combination of life circumstances: end of
                funding, the pandemic, the birth of my first son, having to move
                abroad, and so forth.
              </p>
              <p>I live in Portugal.</p>
              <p>
                In my spare time I make
                <a
                  href="https://www.youtube.com/channel/UC_R-6HcHW5V9_FlZe30tnGA"
                  >videos about programming and audio/video production</a
                >, develop
                <a href="https://github.com/leafac">open-source software</a>,
                run, bike, play the guitar, cook vegan foods, and spend time
                with my wife and son.
              </p>
            </main>-->
          </div>
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
