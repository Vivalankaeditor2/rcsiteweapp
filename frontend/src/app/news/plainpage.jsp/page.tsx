import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { fetchArticle } from "@/lib/api";
import { isNumericId, isPublished } from "@/lib/article";

/**
 * Legacy {@code /news/plainpage.jsp?articleid=}. The page includes the row's
 * {@code details} body with no chrome, served at its exact path (D-003). It
 * shares the article lookup and published rule with the main article page.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "VivaLanka" };

interface PageProps {
  searchParams: { articleid?: string };
}

export default async function PlainPage({ searchParams }: PageProps) {
  if (!isNumericId(searchParams.articleid)) {
    notFound();
  }
  const article = await fetchArticle(Number.parseInt(searchParams.articleid!, 10));
  if (article == null || !isPublished(article)) {
    notFound();
  }

  return (
    <main className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <h1 className="headline text-2xl">{article.title}</h1>
      <div
        className="article-body mt-4"
        dangerouslySetInnerHTML={{ __html: article.details ?? "" }}
      />
    </main>
  );
}
