import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { fetchArticle } from "@/lib/api";
import { isPublished, parseMobileSlug } from "@/lib/article";
import { articleMetadata } from "@/lib/metadata";
import { ArticleView } from "@/components/ArticleView";

/**
 * Legacy mobile article path {@code /mobilepage/{id}ci-{alias}}; kept alive for
 * the old URLs (D-004 route parity), same metadata as {@code /mobile/}.
 */
interface PageProps {
  params: { slug?: string[] };
}

function articleIdFrom(slug?: string[]): number | null {
  if (!slug || slug.length !== 1) {
    return null;
  }
  return parseMobileSlug(slug[0])?.id ?? null;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const id = articleIdFrom(params.slug);
  if (id == null) {
    return { title: "Not Found" };
  }
  const article = await fetchArticle(id);
  if (article == null || !isPublished(article)) {
    return { title: "Not Found" };
  }
  return articleMetadata(article);
}

export default async function MobilePageLegacy({ params }: PageProps) {
  const id = articleIdFrom(params.slug);
  if (id == null) {
    notFound();
  }
  const article = await fetchArticle(id);
  if (article == null || !isPublished(article)) {
    notFound();
  }
  return (
    <main className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <ArticleView article={article} />
    </main>
  );
}
