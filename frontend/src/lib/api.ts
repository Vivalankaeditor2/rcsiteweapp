/**
 * Server-side client for the Spring Boot API.
 *
 * The frontend and backend are separate deployments (frontend on IIS, backend on
 * WildFly); server components and route handlers reach the backend over HTTP.
 * The base URL is configuration, never a credential (D-005).
 */

export interface ArticleDto {
  articleId: number;
  title: string | null;
  description: string | null;
  details: string | null;
  image: string | null;
  thumbnail: string | null;
  keywords: string | null;
  categoryId: number | null;
  authorName: string | null;
  authorIntro: string | null;
  entryDate: string | null;
  published: string | null;
  updated: string | null;
  url: string | null;
  alias: string | null;
  dcode: string | null;
  aprovalStatus: string | null;
}

export interface FeedChannelDto {
  id: number;
  name: string | null;
  link: string | null;
  feedActive: boolean | null;
  feedType: string | null;
  sourceSite: string | null;
  defaultCategoryId: number | null;
  nextPoll: string | null;
  lastPoll: string | null;
  comment: string | null;
}

export interface ArticleCategoryDto {
  categoryId: number;
  parentId: number | null;
  categoryName: string | null;
  title: string | null;
  description: string | null;
  level: string | null;
  priority: number | null;
  active: string | null;
}

export interface PageDto<T> {
  items: T[];
  page: number;
  size: number;
  totalItems: number;
  totalPages: number;
  hasNext: boolean;
}

export const BACKEND_URL = (process.env.BACKEND_URL ?? "http://localhost:8080").replace(/\/$/, "");

async function getJson<T>(path: string): Promise<T | null> {
  const response = await fetch(`${BACKEND_URL}${path}`, {
    // Content is database-driven and changes on publish; never serve a stale 200.
    cache: "no-store",
    headers: { Accept: "application/json" },
  });
  if (response.status === 404) {
    return null;
  }
  if (!response.ok) {
    throw new Error(`Backend ${path} returned ${response.status}`);
  }
  return (await response.json()) as T;
}

/**
 * The legacy page looks an article up by {@code article_id}. A purely numeric
 * {@code dcode} shares that key space, so the id is retried as a dcode before
 * giving up (the "numeric-dcode variant" of the URL contract).
 */
export async function fetchArticle(id: number): Promise<ArticleDto | null> {
  const byId = await getJson<ArticleDto>(`/api/articles/${id}`);
  if (byId) {
    return byId;
  }
  return getJson<ArticleDto>(`/api/articles/by-dcode/${id}`);
}

export async function fetchFeeds(): Promise<FeedChannelDto[]> {
  return (await getJson<FeedChannelDto[]>("/api/feeds")) ?? [];
}

/** Active categories, ordered for navigation. */
export async function fetchCategories(): Promise<ArticleCategoryDto[]> {
  return (await getJson<ArticleCategoryDto[]>("/api/categories")) ?? [];
}

/**
 * A page of published articles, newest first. {@code categoryId} selects a
 * single category; omit it for everything. Empty items are a valid result.
 */
export async function fetchArticlePage(
  page = 0,
  size = 20,
  categoryId?: number,
): Promise<PageDto<ArticleDto>> {
  const params = new URLSearchParams({ page: String(page), size: String(size) });
  if (categoryId != null) {
    params.set("categoryId", String(categoryId));
  }
  const result = await getJson<PageDto<ArticleDto>>(`/api/articles?${params.toString()}`);
  return (
    result ?? { items: [], page, size, totalItems: 0, totalPages: 0, hasNext: false }
  );
}

export async function fetchSitemapXml(kind: "index" | "shard", n?: number): Promise<string | null> {
  const path = kind === "index" ? "/sitemapindex.xml" : `/sitemap_${n}.xml`;
  const response = await fetch(`${BACKEND_URL}${path}`, {
    cache: "no-store",
    headers: { Accept: "application/xml" },
  });
  if (response.status === 404) {
    return null;
  }
  if (!response.ok) {
    throw new Error(`Backend ${path} returned ${response.status}`);
  }
  return response.text();
}
