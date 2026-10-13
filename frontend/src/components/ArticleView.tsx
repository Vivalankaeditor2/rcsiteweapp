import type { ArticleDto } from "@/lib/api";
import { bodyDetails, imageSrc } from "@/lib/article";
import { formatDate } from "@/lib/format";

/**
 * The reading surface for one article, shared by the desktop ({@code /newspage})
 * and mobile ({@code /mobile}, {@code /mobilepage}) routes so they cannot drift.
 * Stored image paths are runtime data, so a plain {@code img} is used instead of
 * {@code next/image} (D-024).
 */
export function ArticleView({ article }: { article: ArticleDto }) {
  const date = formatDate(article.published ?? article.entryDate);
  return (
    <article>
      <header>
        {date ? (
          <time className="text-xs font-semibold uppercase tracking-wide text-brand">{date}</time>
        ) : null}
        <h1 className="headline mt-2 text-3xl sm:text-4xl">{article.title}</h1>
        {article.authorName ? (
          <p className="mt-3 text-sm text-ink-mute">By {article.authorName}</p>
        ) : null}
      </header>

      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={imageSrc(article)}
        alt=""
        className="mt-6 w-full rounded-lg object-cover"
        loading="eager"
      />

      <div className="article-body mt-6" dangerouslySetInnerHTML={{ __html: bodyDetails(article) }} />

      {article.authorIntro ? (
        <aside className="mt-8 rounded-lg bg-brand-50 p-4 text-sm text-ink-soft">
          <p className="font-semibold text-ink">{article.authorName}</p>
          <p className="mt-1">{article.authorIntro}</p>
        </aside>
      ) : null}
    </article>
  );
}
