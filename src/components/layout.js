import React from "react";
import "./layout.css";
import "typeface-ibm-plex-serif";
import "typeface-ibm-plex-mono";

export default ({ children }) => (
  <>
    <header>
      <h1>
        <a href="/">Leandro Facchinetti</a>
      </h1>
    </header>
    <main>{children}</main>
  </>
);
