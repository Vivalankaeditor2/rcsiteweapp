import type { Metadata } from "next";
import type { ArticleDto } from "./api";
import {
  SITE_KEYWORDS,
  canonicalUrl,
  imageUrl,
  metaDescription,
  metaTitle,
  ogDescription,
} from "./article";

/**
 * The article {@code <head>} as Next metadata. Every value is proved against the
 * live page captured in {@code tools/legacy-capture/sample-article.html}: the
 * canonical must be byte-identical and a 200 must never become a 301 (D-003).
 */
export function articleMetadata(article: ArticleDto): Metadata {
  const canonical = canonicalUrl(article);
  const image = imageUrl(article);
  return {
    // legacy <title> is the raw title, with no site-name suffix
    title: metaTitle(article),
    description: metaDescription(article),
    keywords: SITE_KEYWORDS,
    alternates: { canonical },
    openGraph: {
      url: canonical,
      title: metaTitle(article),
      description: ogDescription(article),
      images: [image],
      type: "article",
    },
    twitter: {
      card: "summary_large_image",
      title: metaTitle(article),
      description: ogDescription(article),
      images: [image],
    },
  };
}

/**
 * The same head as raw tags, for the legacy {@code /news/page.jsp} route handler
 * which returns a standalone HTML document rather than a React tree.
 */
export function articleHeadTags(article: ArticleDto): string {
  const canonical = canonicalUrl(article);
  const image = imageUrl(article);
  const title = metaTitle(article);
  const description = metaDescription(article);
  const ogDescriptionValue = ogDescription(article);
  const escape = (value: string) =>
    value
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  return [
    `<title>${escape(title)}</title>`,
    `<meta name="Description" content="${escape(description)}" />`,
    `<meta name="keywords" content="${escape(SITE_KEYWORDS)}" />`,
    `<meta property="og:url" content="${escape(canonical)}" />`,
    `<meta property="og:title" content="${escape(title)}" />`,
    `<meta property="og:description" content="${escape(ogDescriptionValue)}" />`,
    `<meta property="og:image" content="${escape(image)}" />`,
    `<meta property="og:type" content="article" />`,
    `<meta name="twitter:card" content="summary_large_image" />`,
    `<meta name="twitter:description" content="${escape(ogDescriptionValue)}" />`,
    `<meta name="twitter:title" content="${escape(title)}" />`,
    `<meta name="twitter:image" content="${escape(image)}" />`,
    `<meta name="twitter:url" content="${escape(canonical)}" />`,
    `<link rel="canonical" href="${escape(canonical)}" />`,
  ].join("\n    ");
}
