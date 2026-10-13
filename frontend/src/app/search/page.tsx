import type { Metadata } from "next";
import Link from "next/link";
import { SearchResultCard } from "@/components/SearchResultCard";
import { fetchSearch } from "@/lib/search";
import { SITE_NAME } from "@/lib/site";

/**
 * The public, human-facing search page {@code /search?q=}. The legacy
 * {@code /rcsearch/news} route stays crawler-only (D-003); this is the readable
 * front end over the same Solr results, so the header form can point a person
 * somewhere that renders instead of returning 403.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Search" };

interface PageProps {
  searchParams: { q?: string; categoryId?: string; start?: string };
}

const PAGE_SIZE = 20;

export default async function SearchPage({ searchParams }: PageProps) {
  const q = searchParams.q?.trim() ?? "";
  const categoryId = /^(\d{1,7})(,\d{1,7})*|local$/.test(searchParams.categoryId ?? "")
    ? searchParams.categoryId
    : undefined;
  const start = Number.parseInt(searchParams.start ?? "0", 10) || 0;

  const page = q || categoryId
    ? await fetchSearch({ q: q || undefined, categoryId, start, rows: PAGE_SIZE })
    : null;

  return (
    <main className="mx-auto max-w-page px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl sm:text-3xl">
        Search {SITE_NAME}
      </h1>

      <form action="/search" method="get" role="search" className="mt-6 flex max-w-xl gap-2">
        <label htmlFor="q" className="sr-only">
          Search query
        </label>
        <input
          id="q"
          type="search"
          name="q"
          defaultValue={q}
          placeholder="Search news"
          className="w-full rounded border border-line px-3 py-2 text-sm outline-none focus:border-brand"
        />
        <button
          type="submit"
          className="rounded bg-brand px-4 py-2 text-sm font-semibold text-white hover:bg-brand-600"
        >
          Search
        </button>
      </form>

      {page == null ? (
        <p className="mt-6 text-sm text-ink-mute">Enter a search term to begin.</p>
      ) : !page.available ? (
        <p className="mt-6 rounded-lg border border-dashed border-line bg-white p-6 text-sm text-ink-mute">
          Search is temporarily unavailable. Please try again shortly.
        </p>
      ) : page.items.length === 0 ? (
        <p className="mt-6 text-sm text-ink-mute">No results found.</p>
      ) : (
        <>
          <p className="mt-4 text-sm text-ink-mute">
            {page.totalItems} result{page.totalItems === 1 ? "" : "s"}
          </p>
          <div className="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {page.items.map((result) => (
              <SearchResultCard key={result.id ?? result.title} result={result} />
            ))}
          </div>
          {page.hasNext ? (
            <nav className="mt-8 text-center" aria-label="Pagination">
              <Link
                href={searchHref(q, categoryId, page.start + page.rows)}
                className="text-brand hover:underline"
              >
                Next results &rarr;
              </Link>
            </nav>
          ) : null}
        </>
      )}
    </main>
  );
}

function searchHref(q: string, categoryId: string | undefined, start: number): string {
  const params = new URLSearchParams();
  if (q) {
    params.set("q", q);
  }
  if (categoryId) {
    params.set("categoryId", categoryId);
  }
  if (start > 0) {
    params.set("start", String(start));
  }
  return `/search?${params.toString()}`;
}
