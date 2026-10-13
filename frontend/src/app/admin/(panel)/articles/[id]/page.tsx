"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import type { AdminArticle } from "@/lib/admin-api";
import { ArticleForm, isPublished } from "@/components/admin/ArticleForm";
import { AdminHeading, Card, Notice } from "@/components/admin/ui";
import { publicArticlePath } from "@/lib/admin-links";

/** Edit one article. The row is read through the public article read API. */
export default function AdminEditArticlePage() {
  const params = useParams<{ id: string }>();
  const id = Number(params.id);
  const [article, setArticle] = useState<AdminArticle | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!Number.isFinite(id)) {
      setError("Invalid article id");
      return;
    }
    // The public read API is the same body the editor needs; a dedicated admin
    // GET is not required to load the form.
    fetch(`/api/articles/${id}`, { cache: "no-store" })
      .then((r) => (r.ok ? (r.json() as Promise<AdminArticle>) : null))
      .then((found) => {
        if (found) setArticle(found);
        else setError(`No article with id ${id}`);
      })
      .catch(() => setError("Could not load the article"));
  }, [id]);

  return (
    <>
      <AdminHeading title={article ? `Edit article #${id}` : `Article #${id}`}>
        <Link href="/admin/articles" className="text-sm text-brand">
          Back to articles
        </Link>
      </AdminHeading>

      {error ? <Notice kind="error">{error}</Notice> : null}

      {article ? (
        <>
          <Card>
            <p className="text-sm text-ink-mute">
              Status:{" "}
              <span className="font-semibold text-ink-soft">
                {isPublished(article) ? "Published" : "Hidden"}
              </span>{" "}
              - <Link href={publicArticlePath(article)}>view on site</Link>
            </p>
          </Card>
          <div className="mt-4">
            <ArticleForm article={article} />
          </div>
        </>
      ) : !error ? (
        <p className="text-sm text-ink-mute">Loading...</p>
      ) : null}
    </>
  );
}
