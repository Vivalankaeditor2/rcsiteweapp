import type { AdminArticle } from "@/lib/admin-api";

/**
 * The site-relative public URL of an article, mirroring the backend
 * `ArticleUrls.canonical` rule exactly (numeric dcode replaces the id; a null
 * alias falls back to the query form). Kept identical so the "view on site"
 * link in the admin never points somewhere the public contract does not serve
 * (D-003).
 */
export function publicArticlePath(article: Pick<AdminArticle, "articleId" | "dcode" | "alias">): string {
  const { articleId, dcode, alias } = article;
  if (dcode && /^\d+$/.test(dcode)) {
    return `/newspage/${dcode}ai-${alias ?? ""}`;
  }
  if (alias) {
    return `/newspage/${articleId}ai-${alias}`;
  }
  return `/news/page.jsp?articleid=${articleId}`;
}
