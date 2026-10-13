import type { Metadata } from "next";
import { fetchArticlePage } from "@/lib/api";
import { ArticleCard } from "@/components/ArticleCard";
import { SITE_NAME, SITE_TAGLINE } from "@/lib/site";

/**
 * The home page {@code /}. Lists published articles newest first. Legacy served
 * the newest item out of the category feed here; this is the same data through
 * the listing API, with an explicit empty state because the seed database ships
 * with no article rows.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  description: SITE_TAGLINE,
};

export default async function Home() {
  const { items, totalItems } = await fetchArticlePage(0, 24);
  const [lead, ...rest] = items;

  return (
    <main className="mx-auto max-w-page px-4 py-8 sm:px-6">
      <h1 className="sr-only">{SITE_NAME} — latest news</h1>

      {items.length === 0 ? (
        <section className="rounded-lg border border-dashed border-line bg-white p-10 text-center">
          <p className="headline text-xl">No articles yet</p>
          <p className="mt-2 text-sm text-ink-mute">
            Published articles will appear here once they are available.
          </p>
        </section>
      ) : (
        <>
          <section>
            <ArticleCard article={lead} variant="lead" />
          </section>
          <section className="mt-8">
            <h2 className="headline mb-4 border-b border-line pb-2 text-xl">Latest</h2>
            <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {rest.map((article) => (
                <ArticleCard key={article.articleId} article={article} />
              ))}
            </div>
          </section>
          {totalItems > items.length ? (
            <p className="mt-8 text-center text-sm text-ink-mute">
              Showing {items.length} of {totalItems} articles.
            </p>
          ) : null}
        </>
      )}
    </main>
  );
}
