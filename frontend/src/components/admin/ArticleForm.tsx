"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import {
  createArticle,
  updateArticle,
  type AdminArticle,
  type AdminArticleInput,
} from "@/lib/admin-api";
import type { ArticleCategoryDto } from "@/lib/api";
import { BACKEND_URL } from "@/lib/api";
import { Card, Field, Notice, PrimaryButton, inputClass } from "@/components/admin/ui";

/** Published articles are anything whose status is not the frozen "4" (D-003). */
export function isPublished(article: { aprovalStatus: string | null }): boolean {
  return article.aprovalStatus !== "4";
}

interface FormState {
  title: string;
  alias: string;
  categoryId: string;
  authorName: string;
  editorName: string;
  editorEmail: string;
  image: string;
  thumbnail: string;
  keywords: string;
  url: string;
  description: string;
  details: string;
  publish: boolean;
}

function initialState(article?: AdminArticle): FormState {
  return {
    title: article?.title ?? "",
    alias: article?.alias ?? "",
    categoryId: article?.categoryId != null ? String(article.categoryId) : "",
    authorName: article?.authorName ?? "",
    editorName: article?.editorName ?? "",
    editorEmail: article?.editorEmail ?? "",
    image: article?.image ?? "",
    thumbnail: article?.thumbnail ?? "",
    keywords: article?.keywords ?? "",
    url: article?.url ?? "",
    description: article?.description ?? "",
    details: article?.details ?? "",
    publish: article ? isPublished(article) : true,
  };
}

/**
 * Article create/edit form. The alias (the slug embedded in the frozen public
 * URL) is auto-derived from the title when left blank, mirroring the legacy
 * editor; the backend assigns it the same way.
 */
export function ArticleForm({ article }: { article?: AdminArticle }) {
  const router = useRouter();
  const [form, setForm] = useState<FormState>(initialState(article));
  const [categories, setCategories] = useState<ArticleCategoryDto[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState<AdminArticle | null>(null);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    fetch(`${BACKEND_URL}/api/categories`, { cache: "no-store" })
      .then((r) => (r.ok ? r.json() : []))
      .then(setCategories)
      .catch(() => setCategories([]));
  }, []);

  function set<K extends keyof FormState>(key: K, value: FormState[K]) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError(null);
    const input: AdminArticleInput = {
      title: form.title,
      description: form.description || null,
      details: form.details || null,
      image: form.image || null,
      thumbnail: form.thumbnail || null,
      keywords: form.keywords || null,
      categoryId: form.categoryId ? Number(form.categoryId) : null,
      authorName: form.authorName || null,
      editorName: form.editorName || null,
      editorEmail: form.editorEmail || null,
      alias: form.alias || null,
      url: form.url || null,
      publish: form.publish,
    };
    try {
      const result = article ? await updateArticle(article.articleId, input) : await createArticle(input);
      setSaved(result);
      router.push(`/admin/articles/${result.articleId}`);
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Save failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <form onSubmit={onSubmit} className="space-y-4">
      {error ? <Notice kind="error">{error}</Notice> : null}
      {saved ? <Notice kind="ok">Saved article #{saved.articleId}.</Notice> : null}

      <Card>
        <div className="grid gap-4">
          <Field label="Title">
            <input
              className={inputClass}
              value={form.title}
              onChange={(e) => set("title", e.target.value)}
              required
            />
          </Field>
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="Category">
              <select
                className={inputClass}
                value={form.categoryId}
                onChange={(e) => set("categoryId", e.target.value)}
              >
                <option value="">(none)</option>
                {categories.map((c) => (
                  <option key={c.categoryId} value={c.categoryId}>
                    {c.categoryName ?? c.categoryId}
                  </option>
                ))}
              </select>
            </Field>
            <Field label="Alias" hint="Public URL slug. Left blank, it is derived from the title.">
              <input className={inputClass} value={form.alias} onChange={(e) => set("alias", e.target.value)} />
            </Field>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="Author name">
              <input className={inputClass} value={form.authorName} onChange={(e) => set("authorName", e.target.value)} />
            </Field>
            <Field label="Editor email">
              <input className={inputClass} value={form.editorEmail} onChange={(e) => set("editorEmail", e.target.value)} />
            </Field>
          </div>
          <Field label="Summary (description)">
            <textarea
              className={inputClass}
              rows={2}
              value={form.description}
              onChange={(e) => set("description", e.target.value)}
            />
          </Field>
          <Field label="Body (details)" hint="HTML allowed, as in the legacy editor.">
            <textarea
              className={inputClass}
              rows={10}
              value={form.details}
              onChange={(e) => set("details", e.target.value)}
            />
          </Field>
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="Keywords">
              <input className={inputClass} value={form.keywords} onChange={(e) => set("keywords", e.target.value)} />
            </Field>
            <Field label="Image URL">
              <input className={inputClass} value={form.image} onChange={(e) => set("image", e.target.value)} />
            </Field>
          </div>
        </div>
      </Card>

      <div className="flex flex-wrap items-center gap-4">
        <label className="flex items-center gap-2 text-sm font-medium text-ink-soft">
          <input type="checkbox" checked={form.publish} onChange={(e) => set("publish", e.target.checked)} />
          Publish (visible on the public site)
        </label>
        <PrimaryButton type="submit" disabled={busy}>
          {busy ? "Saving..." : article ? "Save changes" : "Create article"}
        </PrimaryButton>
      </div>
    </form>
  );
}
