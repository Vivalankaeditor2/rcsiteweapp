import type { Metadata } from "next";
import { CategoryListing, type SearchParams } from "@/components/CategoryListing";
import { sectionByPath } from "@/lib/search";

/** Legacy {@code /news/Sinhala.jsp} — Sinhala news (D-003). */
export const dynamic = "force-dynamic";

const section = sectionByPath("/news/Sinhala.jsp")!;

export const metadata: Metadata = { title: section.title };

export default function Page({ searchParams }: { searchParams: SearchParams }) {
  return <CategoryListing section={section} searchParams={searchParams} />;
}
