import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { fetchArticle } from "@/lib/api";
import { isPublished, parseNewsPageSlug } from "@/lib/article";
import { articleMetadata } from "@/lib/metadata";
import { ArticleView } from "@/components/ArticleView";

/**
 * The dominant public URL: {@code /newspage/{id}ai-{alias}}. The whole segment
 * (including the {@code ai-} marker, which may be followed by an empty or
 * all-dash alias) is one catch-all param so the legacy shapes survive exactly.
 */
interface PageProps {
  params: { slug: string[] };
}

function articleIdFrom(slug: string[]): number | null {
  if (slug.length !== 1) {
    return null;
  }
  return parseNewsPageSlug(slug[0])?.id ?? null;
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

export default async function NewsPage({ params }: PageProps) {
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
