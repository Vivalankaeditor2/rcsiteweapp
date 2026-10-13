import Link from "next/link";
import { fetchArticlePage } from "@/lib/api";
import { ArticleCard } from "@/components/ArticleCard";
import type { CategorySection } from "@/lib/search";

export type SearchParams = Record<string, string | string[] | undefined>;

function first(value: string | string[] | undefined): string | undefined {
  return Array.isArray(value) ? value[0] : value;
}

const PAGE_SIZE = 20;

/**
 * A category listing page body. The heading and the DB listing come from the
 * {@code articles} table via the listing API (newest first, published only), so
 * a category page never links to a URL that 404s. The legacy {@code categoryid}
 * query parameter still overrides the section's default category.
 */
export async function CategoryListing({
  section,
  searchParams,
}: {
  section: CategorySection;
  searchParams: SearchParams;
}) {
  const overrideParam = first(searchParams.categoryid);
  const override = overrideParam != null && /^\d{1,7}$/.test(overrideParam)
    ? Number.parseInt(overrideParam, 10)
    : null;
  const categoryId = override ?? section.categoryId;

  const pageParam = Number.parseInt(first(searchParams.page) ?? "0", 10);
  const page = Number.isNaN(pageParam) || pageParam < 0 ? 0 : pageParam;

  const { items, totalItems, totalPages, hasNext } = await fetchArticlePage(
    page,
    PAGE_SIZE,
    categoryId,
  );

  return (
    <main className="mx-auto max-w-page px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl sm:text-3xl">{section.title}</h1>

      {items.length === 0 ? (
        <section className="mt-6 rounded-lg border border-dashed border-line bg-white p-10 text-center">
          <p className="headline text-xl">No articles yet</p>
          <p className="mt-2 text-sm text-ink-mute">
            Articles for this section will appear here once they are published.
          </p>
        </section>
      ) : (
        <>
          <div className="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {items.map((article) => (
              <ArticleCard key={article.articleId} article={article} />
            ))}
          </div>
          {totalPages > 1 ? (
            <nav className="mt-8 flex items-center justify-center gap-4 text-sm" aria-label="Pagination">
              {page > 0 ? (
                <Link href={pageHref(section.path, searchParams, page - 1)} className="text-brand hover:underline">
                  &larr; Newer
                </Link>
              ) : null}
              <span className="text-ink-mute">
                Page {page + 1} of {totalPages} ({totalItems} articles)
              </span>
              {hasNext ? (
                <Link href={pageHref(section.path, searchParams, page + 1)} className="text-brand hover:underline">
                  Older &rarr;
                </Link>
              ) : null}
            </nav>
          ) : null}
        </>
      )}
    </main>
  );
}

function pageHref(sectionPath: string, searchParams: SearchParams, page: number): string {
  const params = new URLSearchParams();
  const categoryId = first(searchParams.categoryid);
  if (categoryId) {
    params.set("categoryid", categoryId);
  }
  if (page > 0) {
    params.set("page", String(page));
  }
  const query = params.toString();
  return query ? `${sectionPath}?${query}` : sectionPath;
}
