"use client";

import { useCallback, useEffect, useState } from "react";
import { createCategory, updateCategory, type AdminCategoryInput } from "@/lib/admin-api";
import { BACKEND_URL, type ArticleCategoryDto } from "@/lib/api";
import { AdminHeading, Card, Field, Notice, PrimaryButton, inputClass } from "@/components/admin/ui";

interface FormState {
  categoryName: string;
  title: string;
  parentId: string;
  level: string;
  priority: string;
  active: string;
}

const EMPTY: FormState = { categoryName: "", title: "", parentId: "", level: "", priority: "", active: "Y" };

function toInput(form: FormState): AdminCategoryInput {
  return {
    categoryName: form.categoryName,
    title: form.title || null,
    parentId: form.parentId ? Number(form.parentId) : null,
    level: form.level || null,
    priority: form.priority ? Number(form.priority) : null,
    active: form.active || null,
  };
}

/** Category management: create a category or edit an existing one. */
export default function AdminCategoriesPage() {
  const [categories, setCategories] = useState<ArticleCategoryDto[]>([]);
  const [form, setForm] = useState<FormState>(EMPTY);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);
  const [busy, setBusy] = useState(false);

  const load = useCallback(() => {
    fetch(`${BACKEND_URL}/api/categories`, { cache: "no-store" })
      .then((r) => (r.ok ? r.json() : []))
      .then(setCategories)
      .catch(() => setCategories([]));
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  function set<K extends keyof FormState>(key: K, value: string) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  function edit(category: ArticleCategoryDto) {
    setEditingId(category.categoryId);
    setForm({
      categoryName: category.categoryName ?? "",
      title: category.title ?? "",
      parentId: category.parentId != null ? String(category.parentId) : "",
      level: category.level ?? "",
      priority: category.priority != null ? String(category.priority) : "",
      active: category.active ?? "",
    });
    setSaved(false);
  }

  function reset() {
    setEditingId(null);
    setForm(EMPTY);
    setSaved(false);
  }

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError(null);
    try {
      if (editingId != null) {
        await updateCategory(editingId, toInput(form));
      } else {
        await createCategory(toInput(form));
      }
      setSaved(true);
      reset();
      load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Save failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <>
      <AdminHeading title="Categories" />

      <Card>
        <form onSubmit={onSubmit} className="grid gap-4">
          {error ? <Notice kind="error">{error}</Notice> : null}
          {saved ? <Notice kind="ok">Category saved.</Notice> : null}
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="Name">
              <input
                className={inputClass}
                value={form.categoryName}
                onChange={(e) => set("categoryName", e.target.value)}
                required
              />
            </Field>
            <Field label="Title">
              <input className={inputClass} value={form.title} onChange={(e) => set("title", e.target.value)} />
            </Field>
          </div>
          <div className="grid gap-4 sm:grid-cols-4">
            <Field label="Parent id">
              <input className={inputClass} value={form.parentId} onChange={(e) => set("parentId", e.target.value)} />
            </Field>
            <Field label="Level">
              <input className={inputClass} value={form.level} onChange={(e) => set("level", e.target.value)} />
            </Field>
            <Field label="Priority">
              <input className={inputClass} value={form.priority} onChange={(e) => set("priority", e.target.value)} />
            </Field>
            <Field label="Active" hint="One-character flag, as stored.">
              <input className={inputClass} value={form.active} onChange={(e) => set("active", e.target.value)} />
            </Field>
          </div>
          <div className="flex gap-3">
            <PrimaryButton type="submit" disabled={busy}>
              {busy ? "Saving..." : editingId != null ? "Save changes" : "Create category"}
            </PrimaryButton>
            {editingId != null ? (
              <button type="button" onClick={reset} className="text-sm text-ink-soft hover:text-brand">
                Cancel
              </button>
            ) : null}
          </div>
        </form>
      </Card>

      <Card>
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-line text-xs uppercase tracking-wide text-ink-mute">
              <tr>
                <th className="py-2 pr-3">ID</th>
                <th className="py-2 pr-3">Name</th>
                <th className="py-2 pr-3">Parent</th>
                <th className="py-2 pr-3">Active</th>
                <th className="py-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {categories.map((c) => (
                <tr key={c.categoryId} className="border-b border-line/60">
                  <td className="py-2 pr-3 text-ink-mute">{c.categoryId}</td>
                  <td className="py-2 pr-3">{c.categoryName}</td>
                  <td className="py-2 pr-3 text-ink-mute">{c.parentId ?? "-"}</td>
                  <td className="py-2 pr-3 text-ink-mute">{c.active ?? "-"}</td>
                  <td className="py-2">
                    <button type="button" onClick={() => edit(c)} className="text-brand">
                      Edit
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </>
  );
}
