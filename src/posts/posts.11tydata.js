module.exports = {
  layout: "blog-post.njk",
  eleventyComputed: {
    permalink: (data) => {
      if (data.permalink) return data.permalink;
      if (data.page?.fileSlug) return `/blog/${data.page.fileSlug}/index.html`;
      return undefined;
    },
  },
};
