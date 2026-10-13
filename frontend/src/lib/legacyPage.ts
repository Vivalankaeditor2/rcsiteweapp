import { fetchArticle } from "./api";
import { bodyDetails, isNumericId, isPublished, metaTitle } from "./article";
import { articleHeadTags } from "./metadata";

/**
 * Standalone HTML for the legacy query URLs {@code /news/page.jsp?articleid=} and
 * {@code /n/p?i=}. The legacy page emitted a full document here, so this returns
 * a complete HTML string with the same head contract as the React article page.
 * A missing or approval-status-4 article is a hard 404, never a soft-200 (D-003).
 */
export async function renderLegacyArticle(idParam: string | null): Promise<Response> {
  if (!isNumericId(idParam)) {
    return notFoundResponse();
  }
  const article = await fetchArticle(Number.parseInt(idParam as string, 10));
  if (article == null || !isPublished(article)) {
    return notFoundResponse();
  }
  const html = `<!doctype html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    ${articleHeadTags(article)}
  </head>
  <body>
    <main>
      <article>
        <h1>${metaTitle(article)}</h1>
        <div class="details">${bodyDetails(article)}</div>
      </article>
    </main>
  </body>
</html>`;
  return new Response(html, {
    status: 200,
    headers: { "Content-Type": "text/html; charset=utf-8" },
  });
}

function notFoundResponse(): Response {
  return new Response(
    "<!doctype html><html><head><title>Not Found</title></head>" +
      "<body><h1>404 - Not Found</h1></body></html>",
    { status: 404, headers: { "Content-Type": "text/html; charset=utf-8" } },
  );
}
