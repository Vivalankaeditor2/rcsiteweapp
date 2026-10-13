"use client";

import Link from "next/link";
import { AdminHeading, Card } from "@/components/admin/ui";
import { SITE_NAME } from "@/lib/site";
import { MAIN_NAV } from "@/lib/site";

/** Admin overview: the section index plus a link back to the public site. */
export default function AdminHomePage() {
  const sections = [
    { href: "/admin/articles", title: "Articles", body: "Write, edit, publish or hide news articles." },
    { href: "/admin/categories", title: "Categories", body: "Manage the article categories used by listings." },
    { href: "/admin/feeds", title: "Feeds", body: "Inspect external feed channels and trigger a poll." },
    { href: "/admin/config", title: "Config", body: "Edit site settings (cached; evicted on save)." },
    { href: "/admin/email", title: "Email", body: "The outbound email queue (read-only in this phase)." },
  ];

  return (
    <>
      <AdminHeading title="Admin" />
      <p className="mb-6 text-sm text-ink-mute">
        Content management for {SITE_NAME}. Changes are written to the existing database.
      </p>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {sections.map((section) => (
          <Link key={section.href} href={section.href} className="block">
            <Card>
              <h2 className="headline text-lg">{section.title}</h2>
              <p className="mt-1 text-sm text-ink-mute">{section.body}</p>
            </Card>
          </Link>
        ))}
      </div>
      <p className="mt-6 text-sm">
        <Link href={MAIN_NAV[0].href}>Back to the public site</Link>
      </p>
    </>
  );
}
