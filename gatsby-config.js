module.exports = {
  plugins: [
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/src/pages/`
      }
    },
    {
      resolve: `gatsby-plugin-mdx`,
      options: {
        extensions: [`.md`],
        defaultLayouts: {
          default: require.resolve(`./src/components/layout.js`)
        },
        gatsbyRemarkPlugins: [
          `gatsby-remark-autolink-headers`,
          {
            resolve: `gatsby-remark-vscode`,
            options: {
              theme: `Light+ (default light)`,
              extensions: [`latex-workshop`, `racket`]
            }
          }
        ],
        remarkPlugins: [require(`remark-math`)],
        rehypePlugins: [require(`rehype-katex`)]
      }
    },
    `gatsby-plugin-react-helmet`,
    `gatsby-plugin-favicon`
  ]
};
