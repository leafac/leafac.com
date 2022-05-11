import fs from "fs/promises";
import { html } from "@leafac/html";
import { css, localCSS } from "@leafac/css";
import { execa } from "execa";

const indexLocalCSS = localCSS();
const indexBody = html`
  <body
    class="${indexLocalCSS(css`
      font-family: "IBM Plex Mono", var(--font-family--monospace);
      font-size: var(--font-size--sm);
      line-height: var(--line-height--sm);
      color: var(--color--gray--warm--600);
      background-color: var(--color--gray--warm--100);
      @media (prefers-color-scheme: dark) {
        color: var(--color--gray--warm--300);
        background-color: var(--color--gray--warm--900);
      }
      display: flex;
      justify-content: center;

      @at-root {
        a {
          &:hover,
          &:focus-within {
            color: var(--color--fuchsia--700);
          }
          &:active {
            color: var(--color--fuchsia--800);
          }
          @media (prefers-color-scheme: dark) {
            &:hover,
            &:focus-within {
              color: var(--color--fuchsia--300);
            }
            &:active {
              color: var(--color--fuchsia--500);
            }
          }
          cursor: pointer;
          transition-property: var(--transition-property--colors);
          transition-duration: var(--transition-duration--150);
          transition-timing-function: var(--transition-timing-function--in-out);
        }

        strong {
          font-weight: var(--font-weight--semibold);
          color: var(--color--gray--warm--900);
          @media (prefers-color-scheme: dark) {
            color: var(--color--gray--warm--50);
          }
          a:hover &,
          a:focus-within &,
          a:active & {
            color: inherit;
          }
        }

        hr {
          border-top: var(--border-width--1) solid
            var(--color--gray--medium--200);
          @media (prefers-color-scheme: dark) {
            border-color: var(--color--gray--medium--700);
          }
        }

        ul {
          display: flex;
          flex-direction: column;
          gap: var(--space--2);
          i {
            width: var(--space--4);
          }
        }
      }
    `)}"
  >
    <div
      class="${indexLocalCSS(css`
        min-width: var(--space--0);
        max-width: var(--width--prose);
        margin: var(--space--4);
        display: flex;
        flex-direction: column;
        gap: var(--space--4);
      `)}"
    >
      <h1
        class="${indexLocalCSS(css`
          font-size: var(--font-size--4xl);
          line-height: var(--line-height--4xl);
          font-weight: var(--font-weight--semibold);
          font-style: italic;
          text-align: center;
          color: var(--color--gray--warm--900);
          @media (prefers-color-scheme: dark) {
            color: var(--color--gray--warm--50);
          }
        `)}"
      >
        <a href="https://leafac.com">Leandro Facchinetti</a>
      </h1>
      <p
        class="${indexLocalCSS(css`
          text-align: center;
        `)}"
      >
        <img
          src="avatar.png"
          alt="Avatar"
          width="300"
          class="${indexLocalCSS(css`
            max-width: 100%;
            height: auto;
            @media (prefers-color-scheme: dark) {
              filter: brightness(var(--brightness--90));
            }
          `)}"
        />
      </p>
      <hr />
      <ul>
        <li>
          <strong><i class="fa-solid fa-code"></i> Software Developer:</strong>
          Web programming, audio programming, and programming language theory
        </li>
        <li>
          <a href="https://courselore.org">
            <strong>
              $${html`<svg
                width="16"
                height="16"
                viewBox="0 0 24 24"
                class="${indexLocalCSS(css`
                  vertical-align: var(--space---1);
                `)}"
              >
                <path
                  d="M 3 3 L 9 9 L 3 9 L 9 3 L 3 15 L 9 21 L 9 15 L 3 21 L 15 15 L 21 21 L 21 15 L 15 21 L 21 9 L 15 3 L 21 3 L 15 9 Z"
                  fill="none"
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                ></path>
              </svg>`} Courselore:</strong
            >
            My day job
          </a>
        </li>
        <li>
          <strong><i class="fa-solid fa-location-dot"></i> Portugal</strong>
        </li>
      </ul>
      <hr />
      <ul>
        <li>
          <a href="https://www.youtube.com/c/leafac"
            ><strong><i class="fab fa-youtube"></i> YouTube:</strong> Streams
            about code & audio production every weekday at 17:30 UTC</a
          >
        </li>
        <li>
          <a href="https://github.com/leafac"
            ><strong><i class="fab fa-github"></i> GitHub:</strong> Open-source
            projects on web development & audio production</a
          >
        </li>
      </ul>
      <hr />
      <ul>
        <li>
          <a href="https://patreon.com/leafac"
            ><strong><i class="fab fa-patreon"></i> Patreon:</strong> Ongoing
            support</a
          >
        </li>
        <li>
          <a href="https://paypal.me/LeandroFacchinettiEU"
            ><strong><i class="fab fa-paypal"></i> PayPal:</strong> One-time
            support</a
          >
        </li>
        <li>
          <a href="https://github.com/sponsors/leafac"
            ><strong><i class="fab fa-github-alt"></i> GitHub Sponsors:</strong>
            Yet another way to support</a
          >
        </li>
        <li>
          <strong><i class="fa-brands fa-bitcoin"></i> Bitcoin:</strong>
          34KJBgtaFYMtDqpSgMayw9qiKWg2GQXA9M Yet another way to support²
        </li>
      </ul>
      <hr />
      <ul>
        <li>
          <a href="/leandro-facchinetti--resume.pdf"
            ><strong><i class="far fa-file"></i> Résumé:</strong> A bit about
            me</a
          >
        </li>
        <li>
          <a href="/leandro-facchinetti--curriculum-vitae.pdf"
            ><strong><i class="far fa-copy"></i> Curriculum Vitæ:</strong> A lot
            about me</a
          >
        </li>
      </ul>
      <hr />
      <ul>
        <li>
          <a href="mailto:me@leafac.com"
            ><strong><i class="far fa-envelope"></i> Email:</strong>
            me@leafac.com</a
          >
        </li>
        <li>
          <a href="https://discord.gg/bjbssqHJmK"
            ><strong><i class="fab fa-discord"></i> Discord:</strong> Chat with
            me and a community of other audio programmers at
            <strong>The Unofficial REAPER Users Group</strong> in the
            <strong
              class="${indexLocalCSS(css`
                display: inline-block;
              `)}"
              >#leandro-facchinetti</strong
            >
            channel</a
          >
        </li>
      </ul>
    </div>
  </body>
`;

await fs.writeFile(
  "index.html",
  html`
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Leandro Facchinetti</title>
        <link
          rel="stylesheet"
          href="/vendor/node_modules/@ibm/plex/css/ibm-plex.min.css"
        />
        <link
          rel="stylesheet"
          href="/vendor/node_modules/@fortawesome/fontawesome-free/css/all.min.css"
        />
        <link
          rel="stylesheet"
          href="/vendor/node_modules/@leafac/css/distribution/browser.css"
        />
        $${indexLocalCSS.toString()}
      </head>
      $${indexBody}
    </html>
  `
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

await execa("caddy", ["run", "--config", "-", "--adapter", "caddyfile"], {
  preferLocal: true,
  stdout: "ignore",
  stderr: "ignore",
  input: `
    {
      admin off
      local_certs
    }

    ${process.env.BASE_URL ?? `https://localhost`} {
      file_server
      encode zstd gzip
    }
  `,
});
