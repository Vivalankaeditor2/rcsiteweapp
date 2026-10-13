"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { listArticles, setArticlePublished, type AdminArticle } from "@/lib/admin-api";
import { isPublished } from "@/components/admin/ArticleForm";
import { AdminHeading, Card, Notice, PrimaryButton } from "@/components/admin/ui";
import { formatDate } from "@/lib/format";

const PAGE_SIZE = 20;

/** The admin articles list: every article (published or hidden), newest first. */
export default function AdminArticlesPage() {
  const [articles, setArticles] = useState<AdminArticle[]>([]);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(1);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async (targetPage: number) => {
    setLoading(true);
    setError(null);
    try {
      const result = await listArticles(targetPage, PAGE_SIZE);
      setArticles(result.items);
      setTotalPages(Math.max(1, result.totalPages));
      setPage(result.page);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not load articles");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    load(0);
  }, [load]);

  async function toggle(article: AdminArticle) {
    const next = !isPublished(article);
    try {
      const updated = await setArticlePublished(article.articleId, next);
      setArticles((prev) => prev.map((a) => (a.articleId === updated.articleId ? updated : a)));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not change the status");
    }
  }

  return (
    <>
      <AdminHeading title="Articles">
        <Link
          href="/admin/articles/new"
          className="rounded bg-brand px-4 py-2 text-sm font-semibold text-white hover:bg-brand-dark"
        >
          New article
        </Link>
      </AdminHeading>

      {error ? <Notice kind="error">{error}</Notice> : null}

      <Card>
        {loading ? (
          <p className="text-sm text-ink-mute">Loading...</p>
        ) : articles.length === 0 ? (
          <p className="text-sm text-ink-mute">No articles yet.</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="border-b border-line text-xs uppercase tracking-wide text-ink-mute">
                <tr>
                  <th className="py-2 pr-3">ID</th>
                  <th className="py-2 pr-3">Title</th>
                  <th className="py-2 pr-3">Category</th>
                  <th className="py-2 pr-3">Published</th>
                  <th className="py-2 pr-3">Status</th>
                  <th className="py-2">Actions</th>
                </tr>
              </thead>
              <tbody>
                {articles.map((article) => (
                  <tr key={article.articleId} className="border-b border-line/60">
                    <td className="py-2 pr-3 text-ink-mute">{article.articleId}</td>
                    <td className="py-2 pr-3">
                      <Link href={`/admin/articles/${article.articleId}`} className="font-medium">
                        {article.title ?? "(untitled)"}
                      </Link>
                    </td>
                    <td className="py-2 pr-3 text-ink-mute">{article.categoryId ?? "-"}</td>
                    <td className="py-2 pr-3 text-ink-mute">{formatDate(article.published) || "-"}</td>
                    <td className="py-2 pr-3">
                      <span
                        className={
                          isPublished(article)
                            ? "rounded-full bg-green-100 px-2 py-0.5 text-xs font-semibold text-green-700"
                            : "rounded-full bg-gray-200 px-2 py-0.5 text-xs font-semibold text-ink-soft"
                        }
                      >
                        {isPublished(article) ? "Published" : "Hidden"}
                      </span>
                    </td>
                    <td className="py-2">
                      <div className="flex gap-2">
                        <Link href={`/admin/articles/${article.articleId}`} className="text-brand">
                          Edit
                        </Link>
                        <button type="button" onClick={() => toggle(article)} className="text-ink-soft hover:text-brand">
                          {isPublished(article) ? "Unpublish" : "Publish"}
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      {totalPages > 1 ? (
        <div className="mt-4 flex items-center gap-3">
          <PrimaryButton type="button" disabled={page === 0} onClick={() => load(page - 1)}>
            Previous
          </PrimaryButton>
          <span className="text-sm text-ink-mute">
            Page {page + 1} of {totalPages}
          </span>
          <PrimaryButton type="button" disabled={page >= totalPages - 1} onClick={() => load(page + 1)}>
            Next
          </PrimaryButton>
        </div>
      ) : null}
    </>
  );
}
