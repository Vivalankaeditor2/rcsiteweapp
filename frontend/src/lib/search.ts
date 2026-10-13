import { BACKEND_URL, type PageDto } from "./api";

/**
 * Search and category-listing helpers. Search is proxied to the legacy Solr
 * {@code /news} handler through the backend (D-011); the result fields and the
 * display date match what the legacy {@code RCSearchFacade} page rendered.
 */

/** One Solr hit as the backend exposes it. */
export interface SearchResultDto {
  id: string | null;
  title: string | null;
  description: string | null;
  content: string | null;
  url: string | null;
  categoryId: number | null;
  category: string | null;
  parentCategoryId: number | null;
  thumbnail: string | null;
  image: string | null;
  lastModified: string | null;
  startDate: string | null;
  endDate: string | null;
  site: string | null;
}

export interface SearchPage {
  items: SearchResultDto[];
  totalItems: number;
  start: number;
  rows: number;
  hasNext: boolean;
  available: boolean;
}

/**
 * The legacy {@code /rcsearch/*} surface is bot-only: a browser user-agent gets
 * 403 and a search crawler gets 200 (URL-INVENTORY.md §1). Only the well-known
 * crawlers are allowed; anything else is refused.
 */
const ALLOWED_BOT = /(googlebot|bingbot|duckduckbot|yandexbot|baiduspider|slurp)/i;

export function isAllowedBot(userAgent: string | null | undefined): boolean {
  return userAgent != null && ALLOWED_BOT.test(userAgent);
}

/**
 * Legacy {@code yyyy...}: the Solr {@code lastModified} was rendered as
 * "EEEE, MMMM dd, yyyy". The weekday is computed from the date parts in UTC so
 * the output cannot shift with the server's timezone.
 */
const WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
const MONTHS_FULL = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];

export function formatSolrDate(value: string | null | undefined): string {
  if (!value) {
    return "";
  }
  const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value);
  if (!match) {
    return "";
  }
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const weekday = WEEKDAYS[new Date(Date.UTC(year, month - 1, day)).getUTCDay()];
  const monthName = MONTHS_FULL[month - 1];
  if (weekday == null || monthName == null) {
    return "";
  }
  return `${weekday}, ${monthName} ${String(day).padStart(2, "0")}, ${year}`;
}

/** Legacy excerpt rule: strip tags, then cut at 400 characters with an ellipsis. */
export function searchExcerpt(result: SearchResultDto): string {
  const raw = (result.description ?? "").trim() || (result.content ?? "").replace(/<[^>]*>/g, "");
  const text = raw.replace(/<[^>]*>/g, "");
  return text.length > 400 ? `${text.substring(0, 400)}...` : text;
}

/** The internal article href for a search hit, derived from its legacy {@code url}. */
export function searchResultHref(result: SearchResultDto): string {
  const url = (result.url ?? "").trim();
  if (url.startsWith("http://") || url.startsWith("https://")) {
    return url;
  }
  if (url.length > 0) {
    return url.startsWith("/") ? url : `/${url}`;
  }
  return result.id != null ? `/news/page.jsp?articleid=${result.id}` : "#";
}

/** The image path to render, or null to let the card show its placeholder. */
export function searchResultImage(result: SearchResultDto): string | null {
  const raw = (result.image ?? result.thumbnail)?.trim();
  if (raw == null || raw.length < 2) {
    return null;
  }
  if (/^https?:\/\//i.test(raw)) {
    return raw;
  }
  return raw.startsWith("/") ? raw : `/${raw.replace(/^\.\//, "")}`;
}

const EMPTY_PAGE: SearchPage = {
  items: [],
  totalItems: 0,
  start: 0,
  rows: 0,
  hasNext: false,
  available: true,
};

/** Server-side call to the backend search API. A 4xx/5xx yields an empty page. */
export async function fetchSearch(params: {
  q?: string;
  categoryId?: string;
  start?: number;
  rows?: number;
}): Promise<SearchPage> {
  const query = new URLSearchParams();
  if (params.q) {
    query.set("q", params.q);
  }
  if (params.categoryId) {
    query.set("categoryId", params.categoryId);
  }
  if (params.start != null) {
    query.set("start", String(params.start));
  }
  if (params.rows != null) {
    query.set("rows", String(params.rows));
  }
  const response = await fetch(`${BACKEND_URL}/api/search?${query.toString()}`, {
    cache: "no-store",
    headers: { Accept: "application/json" },
  });
  if (!response.ok) {
    return { ...EMPTY_PAGE, available: false };
  }
  return (await response.json()) as SearchPage;
}

/**
 * The category id used by each legacy section page. Taken from the section JSPs
 * ({@code ArticlePageGenerator.getArticleList("7")} etc.); {@code worldnews}
 * additionally uses the legacy {@code (2,3,5,6)} Solr filter for its world feed.
 */
export interface CategorySection {
  /** The frozen public path (D-003). */
  path: string;
  title: string;
  categoryId: number;
  /** Extra Solr filter for sections that aggregate several categories. */
  searchCategoryId?: string;
}

export const CATEGORY_SECTIONS: CategorySection[] = [
  { path: "/news/index.jsp", title: "Latest News", categoryId: 10 },
  { path: "/news/worldnews.jsp", title: "World News", categoryId: 10, searchCategoryId: "2,3,5,6" },
  { path: "/news/Sinhala.jsp", title: "Sinhala", categoryId: 44 },
  { path: "/news/pagelist.jsp", title: "News", categoryId: 7 },
];

export function sectionByPath(path: string): CategorySection | undefined {
  return CATEGORY_SECTIONS.find((section) => section.path === path);
}

export type { PageDto };
