import type { Metadata } from "next";
import Link from "next/link";
import { CATEGORY_SECTIONS } from "@/lib/search";
import { MAIN_NAV } from "@/lib/site";

/**
 * Legacy {@code /news/sitemap.jsp}: the human-readable site map. It lists the
 * public sections the same way the legacy page linked into
 * {@code pagelist.jsp?categoryid=}. The machine-readable sitemaps stay at
 * {@code /sitemapindex.xml} (D-020).
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Site Map" };

export default function HtmlSitemap() {
  return (
    <main className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl">Site Map</h1>

      <section className="mt-6">
        <h2 className="headline text-lg">Sections</h2>
        <ul className="mt-2 list-disc space-y-1 pl-6 text-sm">
          {CATEGORY_SECTIONS.map((section) => (
            <li key={section.path}>
              <Link href={section.path} className="text-brand hover:underline">
                {section.title}
              </Link>
            </li>
          ))}
        </ul>
      </section>

      <section className="mt-6">
        <h2 className="headline text-lg">Pages</h2>
        <ul className="mt-2 list-disc space-y-1 pl-6 text-sm">
          {MAIN_NAV.map((item) => (
            <li key={item.href}>
              <Link href={item.href} className="text-brand hover:underline">
                {item.label}
              </Link>
            </li>
          ))}
          <li>
            <Link href="/news/sitemap.jsp" className="text-brand hover:underline">
              Site Map
            </Link>
          </li>
          <li>
            <Link href="/news/contactus.jsp" className="text-brand hover:underline">
              Contact Us
            </Link>
          </li>
          <li>
            <Link href="/search" className="text-brand hover:underline">
              Search
            </Link>
          </li>
        </ul>
      </section>

      <section className="mt-6">
        <h2 className="headline text-lg">XML sitemaps</h2>
        <ul className="mt-2 list-disc space-y-1 pl-6 text-sm">
          <li>
            <a href="/sitemapindex.xml" className="text-brand hover:underline">
              /sitemapindex.xml
            </a>
          </li>
          <li>
            <a href="/sitemap_1.xml" className="text-brand hover:underline">
              /sitemap_1.xml
            </a>
          </li>
        </ul>
      </section>
    </main>
  );
}
