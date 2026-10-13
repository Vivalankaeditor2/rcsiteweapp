import type { ArticleDto } from "./api";
import { IMAGE_PLACEHOLDER } from "./site";

/**
 * Faithful port of the legacy article-page rules in
 * {@code rcsiteweb/ROOT/news/page.jsp} and {@code Connections/dbconnection.jsp}.
 * These are pure functions so the exact behaviour (truncation, dcode rules,
 * canonical shape) is unit-tested without a browser or database (D-003).
 */

/** The canonical host, as the legacy page read from config key {@code wwwUrl}. */
export const SITE_URL = (process.env.SITE_URL ?? "https://www.vivalanka.com").replace(/\/$/, "");

/** Static keyword meta copied verbatim from the legacy head. */
export const SITE_KEYWORDS =
  "breaking news, video, teledrama, latest news,cultural events, Sri Lanka";

const IMAGE_FALLBACK = "/custom/images/200x200vivalanka0.png";

/** Legacy {@code validateNumeric}: 1-9 digits, a fixed id key space. */
export function isNumericId(value: string | null | undefined): boolean {
  return value != null && /^\d{1,9}$/.test(value);
}

/**
 * Parse the legacy {@code /newspage/{id}ai-{alias}} path segment. Mirrors the
 * legacy {@code indexOf("ai-")} logic: the alias may be empty or all dashes, and
 * a missing {@code ai-} marker or a non-numeric id is not a valid article path.
 */
export function parseNewsPageSlug(slug: string): { id: number; alias: string } | null {
  const marker = "ai-";
  const markerIndex = slug.indexOf(marker);
  if (markerIndex < 0) {
    return null;
  }
  const idPart = slug.substring(0, markerIndex);
  if (!isNumericId(idPart)) {
    return null;
  }
  return { id: Number.parseInt(idPart, 10), alias: slug.substring(markerIndex + marker.length) };
}

/**
 * Parse the legacy {@code /mobile/{id}ci-{alias}} path segment (marker {@code ci-}).
 */
export function parseMobileSlug(slug: string): { id: number; alias: string } | null {
  const marker = "ci-";
  const markerIndex = slug.indexOf(marker);
  if (markerIndex < 0) {
    return null;
  }
  const idPart = slug.substring(0, markerIndex);
  if (!isNumericId(idPart)) {
    return null;
  }
  return { id: Number.parseInt(idPart, 10), alias: slug.substring(markerIndex + marker.length) };
}

/** Legacy {@code shortenString}: strip tags, decode {@code &nbsp;}, cut to {@code length}. */
export function shortenString(value: string | null, length: number): string {
  if (value == null) {
    return "";
  }
  let text = value.replace(/<.*?>/g, "").replace(/&nbsp;/g, " ");
  if (text.length > length) {
    text = text.substring(0, length - 1);
  }
  return text;
}

/** The {@code <title>} / {@code og:title} value (empty when absent). */
export function metaTitle(article: ArticleDto): string {
  return article.title ?? "";
}

/**
 * The {@code <meta name="Description">} value: tags removed then truncated to
 * 150 characters, exactly as the legacy page does (it cuts mid-word).
 */
export function metaDescription(article: ArticleDto): string {
  return shortenString(article.description, 150);
}

/** The {@code og:description}/{@code twitter:description}: tags removed, not truncated. */
export function ogDescription(article: ArticleDto): string {
  return (article.description ?? "").replace(/<.*?>/g, "");
}

/** Absolute image URL, mirroring the legacy default and {@code substring(2)} trim. */
export function imageUrl(article: ArticleDto): string {
  const raw = article.image ?? article.thumbnail;
  if (raw == null || raw.trim().length < 2) {
    return SITE_URL + IMAGE_FALLBACK;
  }
  return SITE_URL + raw.trim().substring(2);
}

/**
 * The canonical URL the legacy page emits. A numeric {@code dcode} replaces the
 * id segment; a null alias falls back to the query form. This must stay
 * byte-identical or the URL contract breaks (D-003).
 */
export function canonicalUrl(article: ArticleDto): string {
  const numericDcode = isNumericId(article.dcode);
  if (article.alias != null) {
    const id = numericDcode ? article.dcode : String(article.articleId);
    return `${SITE_URL}/newspage/${id}ai-${article.alias}`;
  }
  const id = numericDcode ? article.dcode : String(article.articleId);
  return `${SITE_URL}/news/page.jsp?articleid=${id}`;
}

/** Body content: a {@code _short} dcode renders the tag-stripped description. */
export function bodyDetails(article: ArticleDto): string {
  if (article.dcode != null && article.dcode.includes("_short")) {
    return ogDescription(article);
  }
  return article.details ?? "";
}

/**
 * An article whose approval status is "4" (or which is missing) is not
 * published and must 404, never soft-200.
 */
export function isPublished(article: ArticleDto | null): boolean {
  return article != null && (article.aprovalStatus ?? "").toLowerCase() !== "4";
}

/**
 * The link a listing uses. The external {@code url} is only used when the
 * description is short, the url is present, and the dcode is not {@code hosted}
 * (D-010b "hosted" rule); otherwise the internal article path is used.
 */
export function listingLink(article: ArticleDto, baseUrl: string = SITE_URL): string {
  const shortDescription = (article.description ?? "").trim().length <= 150;
  const hosted = article.dcode != null && article.dcode.includes("hosted");
  if (
    shortDescription &&
    article.url != null &&
    article.url.length > 10 &&
    !hosted
  ) {
    return article.url;
  }
  if (article.alias != null) {
    return `${baseUrl}/newspage/${article.articleId}ai-${article.alias}`;
  }
  return `${baseUrl}/news/page.jsp?articleid=${article.articleId}`;
}

/**
 * The host-relative href a listing uses. Derived from the canonical so a listing
 * link and its canonical are always the same path (an inconsistency there is an
 * SEO defect). Always internal, unlike {@link listingLink}.
 */
export function articleHref(article: ArticleDto): string {
  const canonical = canonicalUrl(article);
  return canonical.startsWith(SITE_URL) ? canonical.slice(SITE_URL.length) : canonical;
}

/**
 * The image path the browser should request. Legacy stores {@code ./custom/...}
 * or {@code /custom/...} (D-024); both must resolve from the site root. Absolute
 * external URLs pass through untouched.
 */
export function imageSrc(article: ArticleDto): string {
  const raw = (article.image ?? article.thumbnail)?.trim();
  if (raw == null || raw.length < 2) {
    return IMAGE_PLACEHOLDER;
  }
  if (/^https?:\/\//i.test(raw)) {
    return raw;
  }
  let path = raw.startsWith("./") ? raw.substring(1) : raw;
  if (!path.startsWith("/")) {
    path = "/" + path;
  }
  return path;
}
