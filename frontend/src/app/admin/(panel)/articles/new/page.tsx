"use client";

import { AdminHeading } from "@/components/admin/ui";
import { ArticleForm } from "@/components/admin/ArticleForm";

export default function AdminNewArticlePage() {
  return (
    <>
      <AdminHeading title="New article" />
      <ArticleForm />
    </>
  );
}
