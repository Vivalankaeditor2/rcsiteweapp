import { test } from "node:test";
import assert from "node:assert/strict";
import { existsSync } from "node:fs";
import { resolve } from "node:path";

/**
 * The top-severity regression in this project is a frozen URL (D-003) turning
 * into a 404 because a route file was renamed or dropped. These checks fail the
 * build if a preserved path loses its route. They assert file presence, not
 * rendering - the rendered status is covered by tools/url-contract.ps1.
 */
const STATIC_ROUTES: Record<string, string> = {
  "/news/pagelist.jsp": "news/pagelist.jsp/page.tsx",
  "/news/worldnews.jsp": "news/worldnews.jsp/page.tsx",
  "/news/Sinhala.jsp": "news/Sinhala.jsp/page.tsx",
  "/news/index.jsp": "news/index.jsp/page.tsx",
  "/news/page.jsp": "news/page.jsp/route.ts",
  "/news/plainpage.jsp": "news/plainpage.jsp/page.tsx",
  "/news/contactus.jsp": "news/contactus.jsp/page.tsx",
  "/news/sitemap.jsp": "news/sitemap.jsp/page.tsx",
  "/directory/suggesturl.jsp": "directory/suggesturl.jsp/page.tsx",
  "/user/login.jsp": "user/login.jsp/page.tsx",
  "/user/passwordrecovery.jsp": "user/passwordrecovery.jsp/page.tsx",
  "/user/changelocation.jsp": "user/changelocation.jsp/page.tsx",
  "/search": "search/page.tsx",
  "/rcsearch/news": "rcsearch/news/route.ts",
  "/n/p": "n/p/route.ts",
};

test("every frozen path keeps a route file under src/app", () => {
  const missing = Object.entries(STATIC_ROUTES)
    .filter(([, file]) => !existsSync(resolve(process.cwd(), "src/app", file)))
    .map(([url]) => url);
  assert.deepEqual(missing, [], `frozen paths with no route: ${missing.join(", ")}`);
});

test("the dynamic article and mobile routes exist", () => {
  for (const file of ["newspage/[...slug]/page.tsx", "mobile/[[...slug]]/page.tsx", "mobilepage/[[...slug]]/page.tsx"]) {
    assert.ok(existsSync(resolve(process.cwd(), "src/app", file)), `missing ${file}`);
  }
});
