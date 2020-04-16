module.exports = {
  plugins: [
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/src/pages/`,
      },
    },
    {
      resolve: `gatsby-plugin-mdx`,
      options: {
        extensions: [`.md`],
        defaultLayouts: {
          default: require.resolve(`./src/components/layout.js`),
        },
        gatsbyRemarkPlugins: [
          {
            resolve: `gatsby-remark-vscode`,
            options: {
              theme: `Light+ (default light)`,
            },
          },
        ],
        remarkPlugins: [
          require(`remark-slug`),
          require(`remark-toc`),
          require(`remark-math`),
        ],
        rehypePlugins: [require(`rehype-katex`)],
      },
    },
    `gatsby-plugin-react-helmet`,
    `gatsby-plugin-favicon`,
  ],
};
