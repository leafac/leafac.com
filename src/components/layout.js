import React from "react";
import { Helmet } from "react-helmet";
import ReactMarkdown from "react-markdown";
import removeMd from "remove-markdown";
import "typeface-ibm-plex-serif";
import "typeface-ibm-plex-mono";
import "./layout.css";

export default ({
  children,
  path,
  pageContext: {
    frontmatter: { title }
  }
}) => (
  <>
    <Helmet>
      <title>
        {title !== undefined ? `${removeMd(title)} · ` : ""}Leandro Facchinetti
      </title>
      <meta name="author" content="Leandro Facchinetti" />
      <meta
        name="description"
        content="I’m a PhD candidate in Computer Science. I’m interested in writing & reading, music & video production, running, mindfulness, minimalism, and veganism."
      />
    </Helmet>
    <header>
      <h1>
        <a href="/">Leandro Facchinetti</a>
      </h1>
    </header>
    <main>
      {title !== undefined ? (
        <header>
          <h1>
            <a href={path}>
              <ReactMarkdown>{title}</ReactMarkdown>
            </a>
          </h1>
        </header>
      ) : (
        ""
      )}
      {children}
    </main>
  </>
);
