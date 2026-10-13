import type { Metadata } from "next";
import { CategoryListing, type SearchParams } from "@/components/CategoryListing";
import { sectionByPath } from "@/lib/search";

/** Legacy {@code /news/pagelist.jsp?categoryid=} — the news listing page (D-003). */
export const dynamic = "force-dynamic";

const section = sectionByPath("/news/pagelist.jsp")!;

export const metadata: Metadata = { title: section.title };

export default function Page({ searchParams }: { searchParams: SearchParams }) {
  return <CategoryListing section={section} searchParams={searchParams} />;
}
