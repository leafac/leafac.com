import React from "react";
import { Helmet } from "react-helmet";
import remark from "remark";
import remarkReact from "remark-react";
import remarkStripMarkdown from "strip-markdown";
import "typeface-pt-serif";
import "typeface-pt-mono";
import "./layout.css";
import "katex/dist/katex.min.css";

export default ({
  children,
  pageContext: {
    frontmatter: { title },
  },
}) => (
  <>
    <Helmet>
      <meta name="author" content="Leandro Facchinetti" />
      <meta
        name="description"
        content="I’m a PhD candidate in Computer Science. I’m interested in writing & reading, music & video production, running, mindfulness, minimalism, and veganism."
      />
      <title>
        {title !== undefined
          ? `${remark().use(remarkStripMarkdown).processSync(title)} · `
          : ""}
        Leandro Facchinetti
      </title>
    </Helmet>
    <header>
      <h1>
        <a href="/">Leandro Facchinetti</a>
      </h1>
    </header>
    <main>
      {title !== undefined ? (
        <h1>{remark().use(remarkReact).processSync(title).contents}</h1>
      ) : null}
      {children}
    </main>
  </>
);
