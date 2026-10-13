import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { fetchArticle } from "@/lib/api";
import { isPublished, parseMobileSlug } from "@/lib/article";
import { articleMetadata } from "@/lib/metadata";
import { ArticleView } from "@/components/ArticleView";

/**
 * The mobile URLs {@code /mobile/} and {@code /mobile/{id}ci-{alias}} (marker
 * {@code ci-}). An optional catch-all keeps {@code /mobile/} at 200 (a 200 must
 * never become a 301, D-003).
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
    return { title: "VivaLanka Mobile" };
  }
  const article = await fetchArticle(id);
  if (article == null || !isPublished(article)) {
    return { title: "Not Found" };
  }
  return articleMetadata(article);
}

export default async function MobilePage({ params }: PageProps) {
  const slug = params.slug;
  if (slug && slug.length === 1) {
    const id = articleIdFrom(slug);
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
  return (
    <main className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <h1 className="headline text-2xl">VivaLanka Mobile</h1>
    </main>
  );
}
