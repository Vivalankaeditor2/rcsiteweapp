import Link from "next/link";
import type { ArticleDto } from "@/lib/api";
import { articleHref, imageSrc, metaDescription } from "@/lib/article";
import { formatDate } from "@/lib/format";
import { cn } from "@/lib/cn";

interface ArticleCardProps {
  article: ArticleDto;
  /** The lead card shows a larger image and headline. */
  variant?: "default" | "lead";
  className?: string;
}

/**
 * One article in a listing. The anchor only uses the path (the canonical is
 * emitted on the article page itself), and the image falls back to the brand
 * placeholder when a row has no usable image.
 */
export function ArticleCard({ article, variant = "default", className }: ArticleCardProps) {
  const href = articleHref(article);
  const src = imageSrc(article);
  const date = formatDate(article.published ?? article.entryDate);
  const summary = metaDescription(article);
  const isLead = variant === "lead";

  return (
    <article
      className={cn(
        "group overflow-hidden rounded-lg border border-line bg-white transition-shadow hover:shadow-md",
        className,
      )}
    >
      <Link href={href} className="block">
        <div className={cn("relative w-full overflow-hidden bg-brand-50", isLead ? "aspect-[16/9]" : "aspect-[16/10]")}>
          {/* Storage paths are runtime data outside the build, so next/image
              optimisation is not used for them (IIS serves /custom directly). */}
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={src}
            alt=""
            className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
            loading={isLead ? "eager" : "lazy"}
          />
        </div>
        <div className={cn("p-4", isLead && "p-5")}>
          {date ? (
            <time className="text-xs font-medium uppercase tracking-wide text-brand">{date}</time>
          ) : null}
          <h3
            className={cn(
              "headline mt-1 group-hover:text-brand",
              isLead ? "text-2xl sm:text-3xl" : "text-lg",
            )}
          >
            {article.title}
          </h3>
          {summary ? (
            <p className={cn("mt-2 text-sm text-ink-mute", isLead ? "line-clamp-3" : "line-clamp-3")}>
              {summary}
            </p>
          ) : null}
          {article.authorName ? (
            <p className="mt-3 text-xs text-ink-mute">By {article.authorName}</p>
          ) : null}
        </div>
      </Link>
    </article>
  );
}
