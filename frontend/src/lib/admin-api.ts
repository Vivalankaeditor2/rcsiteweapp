/**
 * Browser client for the admin write API (`/api/admin/**`, ADMIN-only).
 * Mirrors the field set of the backend DTOs; the frozen tables are unchanged.
 */

import { adminFetch } from "@/lib/auth";
import type { PageDto } from "@/lib/api";

export interface AdminArticle {
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
  editorName?: string | null;
  editorEmail?: string | null;
  published: string | null;
  updated: string | null;
  url: string | null;
  alias: string | null;
  dcode: string | null;
  aprovalStatus: string | null;
}

export interface AdminArticleInput {
  title: string;
  description?: string | null;
  details?: string | null;
  image?: string | null;
  thumbnail?: string | null;
  keywords?: string | null;
  categoryId?: number | null;
  authorName?: string | null;
  authorIntro?: string | null;
  editorName?: string | null;
  editorEmail?: string | null;
  alias?: string | null;
  url?: string | null;
  publish: boolean;
}

export interface AdminCategoryInput {
  categoryName: string;
  title?: string | null;
  description?: string | null;
  parentId?: number | null;
  level?: string | null;
  priority?: number | null;
  active?: string | null;
}

export interface AdminConfigInput {
  value?: string | null;
  description?: string | null;
  siteArea?: string | null;
  active?: number | null;
}

export function listArticles(page = 0, size = 20): Promise<PageDto<AdminArticle>> {
  return adminFetch<PageDto<AdminArticle>>(`/api/admin/articles?page=${page}&size=${size}`);
}

export function createArticle(input: AdminArticleInput): Promise<AdminArticle> {
  return adminFetch<AdminArticle>("/api/admin/articles", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateArticle(id: number, input: AdminArticleInput): Promise<AdminArticle> {
  return adminFetch<AdminArticle>(`/api/admin/articles/${id}`, {
    method: "PUT",
    body: JSON.stringify(input),
  });
}

export function setArticlePublished(id: number, published: boolean): Promise<AdminArticle> {
  return adminFetch<AdminArticle>(`/api/admin/articles/${id}/publish?published=${published}`, {
    method: "PUT",
  });
}

export function createCategory(input: AdminCategoryInput) {
  return adminFetch("/api/admin/categories", { method: "POST", body: JSON.stringify(input) });
}

export function updateCategory(id: number, input: AdminCategoryInput) {
  return adminFetch(`/api/admin/categories/${id}`, { method: "PUT", body: JSON.stringify(input) });
}

export function updateConfig(key: string, input: AdminConfigInput) {
  return adminFetch(`/api/admin/config/${encodeURIComponent(key)}`, {
    method: "PUT",
    body: JSON.stringify(input),
  });
}
