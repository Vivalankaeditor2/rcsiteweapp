import {
  fetchSearch,
  formatSolrDate,
  isAllowedBot,
  searchExcerpt,
  searchResultHref,
} from "@/lib/search";

/**
 * Legacy {@code /rcsearch/news}. The public contract is bot-only: a browser
 * user-agent gets 403 and a search crawler gets 200 (URL-INVENTORY.md §1), so
 * the gate is preserved here. Solr is called through the backend (D-011).
 */
export const dynamic = "force-dynamic";

export async function GET(request: Request): Promise<Response> {
  const userAgent = request.headers.get("user-agent");
  if (!isAllowedBot(userAgent)) {
    return new Response(
      "<!doctype html><html><head><title>Forbidden</title></head>" +
        "<body><h1>403 - Forbidden</h1><p>This resource is available to search crawlers only.</p></body></html>",
      { status: 403, headers: { "Content-Type": "text/html; charset=utf-8" } },
    );
  }

  const url = new URL(request.url);
  const q = url.searchParams.get("q") ?? url.searchParams.get("query") ?? undefined;
  const categoryId = url.searchParams.get("categoryId") ?? url.searchParams.get("categoryid") ?? undefined;
  const start = Number.parseInt(url.searchParams.get("start") ?? "0", 10) || 0;
  const rowsParam = Number.parseInt(url.searchParams.get("rows") ?? "", 10);

  const page = await fetchSearch({
    q: q ?? undefined,
    categoryId: categoryId ?? undefined,
    start,
    rows: Number.isNaN(rowsParam) ? undefined : rowsParam,
  });

  return new Response(renderResults(q, page.items), {
    status: 200,
    headers: { "Content-Type": "text/html; charset=utf-8" },
  });
}

function escapeHtml(value: string | null | undefined): string {
  return (value ?? "").replace(/[&<>"']/g, (c) =>
    ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c] as string,
  );
}

function renderResults(
  query: string | undefined,
  items: Awaited<ReturnType<typeof fetchSearch>>["items"],
): string {
  const heading = query ? `Search results for ${escapeHtml(query)}` : "Search results";
  const body = items
    .map((result) => {
      const href = escapeHtml(searchResultHref(result));
      const date = formatSolrDate(result.lastModified);
      return `<article>
        <h2><a href="${href}">${escapeHtml(result.title)}</a></h2>
        <p class="meta">${escapeHtml(result.category)}${date ? ` - ${escapeHtml(date)}` : ""}</p>
        <p>${escapeHtml(searchExcerpt(result))}</p>
      </article>`;
    })
    .join("\n");

  return `<!doctype html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, follow" />
    <title>${escapeHtml(query)} - VivaLanka search</title>
  </head>
  <body>
    <main>
      <h1>${heading}</h1>
      ${body || "<p>No results.</p>"}
    </main>
  </body>
</html>`;
}
