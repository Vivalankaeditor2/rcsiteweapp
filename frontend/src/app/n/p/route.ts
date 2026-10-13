import { renderLegacyArticle } from "@/lib/legacyPage";

/**
 * Legacy short URL {@code /n/p?i=}. Preserved at its exact path (D-003).
 */
export const dynamic = "force-dynamic";

export async function GET(request: Request): Promise<Response> {
  const url = new URL(request.url);
  return renderLegacyArticle(url.searchParams.get("i"));
}
