import React from "react";
import { Helmet } from "react-helmet";
import "./layout.css";
import "typeface-ibm-plex-serif";
import "typeface-ibm-plex-mono";

export default ({
  children,
  pageContext: {
    frontmatter: { title }
  }
}) => (
  <>
    <Helmet>
      {/* TODO: markdownify | strip_html */}
      <title>
        {title !== undefined ? `${title} · ` : ""}Leandro Facchinetti
      </title>
      <meta name="author" content="Leandro Facchinetti" />
      <meta
        name="description"
        content="I’m a PhD candidate in Computer Science. I’m interested in writing & reading, music & video production, running, mindfulness, minimalism, and veganism."
      />
      <link
        rel="icon"
        type="image/png"
        href="/favicon-32x32.png"
        sizes="32x32"
      />
      <link
        rel="icon"
        type="image/png"
        href="/favicon-16x16.png"
        sizes="16x16"
      />
      <link rel="icon" type="image/x-icon" href="/favicon.ico" />
    </Helmet>
    <header>
      <h1>
        <a href="/">Leandro Facchinetti</a>
      </h1>
    </header>
    <main>
      {/* TODO: markdownify */}
      {title !== undefined ? <h1>{title}</h1> : ""}
      {children}
    </main>
  </>
);
