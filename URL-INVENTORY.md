# URL-INVENTORY.md

**Duty:** the frozen, live-captured URL contract and the evidence behind it.

Phase 0 evidence for the URL contract (D-003). Everything below was captured
from the **live site** on 2026-10-10, not assumed from code.

## How the capture was done

- `tools/url-contract.ps1` â€” harness; checks every frozen URL's status.
- `tools/url-inventory/url-contract.json` â€” the frozen list (add URLs here).
- `tools/capture-sitemap.ps1` â€” samples the real sitemaps to see URL shapes.
- Raw evidence kept under `tools/legacy-capture/` (robots, one live article,
  sitemap index) and `tools/sitemaps/` (shard list + sampled URLs).

## Baseline result

**20/20 URLs PASS** against `https://www.vivalanka.com`.

```
sample-article         exp 200  got 200
article-empty-alias    exp 200  got 200   <- /newspage/12247832ai-
article-dash-alias     exp 200  got 200   <- /newspage/12247828ai-----------------------
article-video-alias    exp 200  got 200
legacy-article-query   exp 200  got 200   <- /news/page.jsp?articleid=...
legacy-short           exp 200  got 200   <- /n/p?i=...
mobile-root            exp 200  got 200
mobile-article         exp 200  got 200   <- /mobile/{id}ci-{alias}
home / home-paged      exp 200  got 200
login/password/location/contact/directory   200
robots / sitemapindex / sitemap_1 / news-sitemap   200
search-category        exp 403  got 403  [bot 200]  <- /rcsearch/ is bot-only
```

## Findings that change the plan

These are new facts found in Phase 0. They are **not** yet folded into
`TASK-PLAN.md` â€” decision needed (see below).

### 1. `/rcsearch/*` is bot-only
`/rcsearch/news` returns **403 to a browser UA** and **200 to Googlebot**, and it
is `Disallow`ed in `robots.txt`. The new search must preserve this posture; the
harness encodes it (`expect: 403`, `expectBot: 200`).

### 2. Aliases can be empty or all dashes
Real examples: `/newspage/12247832ai-`, `/newspage/12247828ai-----------------------`.
The parser must not require a non-empty alias, and an all-dash alias must still
render the article. (The legacy `indexOf("ai-")` logic also survives these.)

### 3. Sitemaps: `<n>.xml` files, no underscore
The live index is each of `/sitemapindex.xml` and `/sitemapindex04302022.xml`;
they point at `/sitemap_{n}.xml` shards, n = **1â€¦212** (204 present), ~**10,047
URLs each** â†’ roughly **2M URLs**. This does not match the three names proposed
earlier (`news-1.xml`, `categories.xml`, `pages.xml`). **Decision needed:** *new*
sharded names vs *preserving* the `/sitemap_{n}.xml` scheme (the legacy shards
would stop being generated at cutover, but existing crawled URLs would 404 if the
new app doesn't serve them).

### 4. Article imagery is on a different path
Live current article uses
`https://www.vivalanka.com/custom/media3/2026/10/<uuid>.png` â€” **not**
`/custom/images/`. D-021 is corrected: keep `/custom/images/` as one base and add
`/custom/media*` (D-024).

### 5. Meta description is truncated at ~155 chars
The live `<meta name="Description">` is cut mid-word ("â€¦summoned the inves").
Reproduce the same truncation so the head matches.

### 6. No JSON-LD on the live article
Confirmed absent. Adding `NewsArticle` JSON-LD is an **improvement**, not parity
(D-010b). Flagged because it changes the `<head>`.

### 7. `robots.txt` Disallows `/tag/` and `/cgi-bin/`
Keep them disallowed in the new robots (plus the existing `/rcsearch/`).

### 8. Rate limiting is real
Bursting requests returns **429**. The harness throttles (900 ms) and retries, so
a 429 is no longer mistaken for a contract break.

## URL shapes (from 30,026 sampled URLs)

| Shape | Share | Note |
|---|---|---|
| `/newspage/{n}ai-{slug}` | ~30,016 | the dominant contract |
| `/` (+ `?offset=`) | 5 | home + pagination |
| `/user/login.jsp`, `/user/changelocation.jsp`, `/user/passwordrecovery.jsp?â€¦` | 1 each | user pages |
| `/news/contactus.jsp`, `/directory/suggesturl.jsp` | 1 each | misc pages |

Host is always `www.vivalanka.com`. Old shards use `http://`; new ones `https://`.

## Decisions to record

| # | Question | Proposed |
|---|---|---|
| D-024 | Image bases | `/custom/images/` **and** `/custom/media*` |
| D-025 | Sitemap shard naming | new app **also serves `/sitemap_{n}.xml`** (and keeps `/sitemapindex.xml`), so no crawled URL 404s |

Both are **now recorded** - D-024 and D-025 in `DECISIONS.md` - and implemented
(the sitemap endpoints serve both index names and `/sitemap_{n}.xml`; see the
Phase 5 note below).

## Local re-run (Phase 5, 2026-10-13)

`tools/url-contract.ps1 -BaseUrl http://localhost:3000` -> **17/20**. Every
structural URL passes; the 3 misses are the extra sample articles
(`12247832`, `12247828`, `12247838`) that are not loaded in the local DB - a
local-data limit, not a routing gap. Run against `https://www.vivalanka.com`
for the 20/20 baseline. Paths are served at the exact requested path with no
301 (`MaximumRedirection 0` checked), per D-030.

## Phase 6 addition - `/rss` (2026-10-13)

`/rss` is **additive**, not frozen (D-033): the legacy feed servlet had no stable
public path, so no captured URL changes. The harness (`url-contract.json`) is
left as the frozen 20-entry contract. The feed is served at `/api/rss` and
exposed publicly at `/rss` (IIS `web.config` rule 1b + a Next.js dev rewrite).
Item links use the frozen article URL rule (D-003).
