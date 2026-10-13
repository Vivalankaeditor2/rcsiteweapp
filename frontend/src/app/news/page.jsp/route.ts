import { renderLegacyArticle } from "@/lib/legacyPage";

/**
 * Legacy URL {@code /news/page.jsp?articleid=}. Kept at its exact path so an
 * indexed query URL never breaks (D-003).
 */
export const dynamic = "force-dynamic";

export async function GET(request: Request): Promise<Response> {
  const url = new URL(request.url);
  return renderLegacyArticle(url.searchParams.get("articleid"));
}
