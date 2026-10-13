import Link from "next/link";
import type { SearchResultDto } from "@/lib/search";
import {
  formatSolrDate,
  searchExcerpt,
  searchResultHref,
  searchResultImage,
} from "@/lib/search";
import { IMAGE_PLACEHOLDER } from "@/lib/site";

/**
 * One search/category hit. The category label and display date mirror the
 * legacy {@code pagelist.jsp} markup (uppercase category, "EEEE, MMMM dd, yyyy").
 */
export function SearchResultCard({ result }: { result: SearchResultDto }) {
  const href = searchResultHref(result);
  const image = searchResultImage(result);
  const date = formatSolrDate(result.lastModified);
  const summary = searchExcerpt(result);

  return (
    <article className="group overflow-hidden rounded-lg border border-line bg-white transition-shadow hover:shadow-md">
      <Link href={href} className="block">
        <div className="relative aspect-[16/10] w-full overflow-hidden bg-brand-50">
          {/* Search images are runtime strings from Solr, so a plain img is used. */}
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={image ?? IMAGE_PLACEHOLDER}
            alt=""
            className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
            loading="lazy"
          />
        </div>
        <div className="p-4">
          <div className="flex items-center gap-2 text-xs font-medium uppercase tracking-wide text-brand">
            {result.category ? <span>{result.category}</span> : null}
            {result.category && date ? <span className="text-ink-mute">-</span> : null}
            {date ? <time className="text-ink-mute">{date}</time> : null}
          </div>
          <h3 className="headline mt-1 text-lg group-hover:text-brand">{result.title}</h3>
          {summary ? <p className="mt-2 text-sm text-ink-mute">{summary}</p> : null}
        </div>
      </Link>
    </article>
  );
}
