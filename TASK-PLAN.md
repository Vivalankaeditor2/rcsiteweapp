# TASK-PLAN.md

**Duty:** the plan of record - phase -> task -> step, with status, plus the open-questions parking lot.

Phase → Task → Step. The plan of record.

**Status key:** `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked

**Companion doc:** `ARTICLES-HANDLING.md` explains the MyISAM rules, the URL rule
options, and the SEO strategy in plain language.

## Target architecture (approved 2026-10-10)

- `frontend/` — Next.js (App Router) + React + TypeScript. UI: Tailwind CSS +
  shadcn/ui (Radix), `next/image`, `lucide-react` icons, Embla carousel,
  TanStack Query (data), Zod (validation), Framer Motion (tasteful animation),
  next-themes (dark mode), Recharts (admin dashboards).
- `backend/` — Spring Boot 3.x on **Java 17**, packaged for **WildFly 27.0.0.Final**
  (Jakarta EE 10). Spring Web (REST), Spring Data JPA (Hibernate 6), Spring
  Security (JWT), Bean Validation, MapStruct + Lombok,
  springdoc-openapi (Swagger UI), Caffeine/Redis cache. Logging: SLF4J + Logback.
- Deployment — **frontend on IIS**, **backend on WildFly 27**; IIS reverse-proxies
  `/api` and SSR traffic to WildFly. Java 17 everywhere.
- Database — the existing **MariaDB 10.6.16** (`vivalanka`). **Schema frozen**
  (`rcsiteweb/db/dbschema.sql` is the read-only reference; D-004, D-008, D-014).
- Search — **keep Apache Solr** (D-011).
- Removed from scope — **AI article generation** (D-010) and the **commerce
  storefront** (D-009).
- `rcsiteweb/` — legacy app kept read-only as the behavioural reference.
- `credentials/` — all local secrets, **gitignored** (D-005). Live credentials are
  in `C:\allcredentials\Credentials.md` (outside the repo).

## Testing strategy & smoke-test convention

- **Backend:** JUnit 5 + Mockito unit tests; `@DataJpaTest` on a disposable DB;
  `@SpringBootTest`/MockMvc for API paths. (Adopt `claude/project-level-testing-rules`
  where it fits — `should_[expected]_when_[condition]`, AAA, same package as SUT.)
- **Frontend:** Playwright E2E + `axe` accessibility checks; Lighthouse SEO/Perf
  gate on the sample article.
- **API contract:** OpenAPI spec adds a schema-diff check (catches accidental
  field changes).
- **URL contract (most important):** one regression suite pins every public URL
  shape from the table above. It runs against **legacy first** (to capture the
  truth), then against the new stack. It must stay green.
- **Smoke test = required evidence, not a promise.** Each phase lists its smoke
  test. It must be: (1) scripted/repeatable, (2) run against the real stack,
  (3) reported with its output. A phase is not `done` until its smoke test passes.
- **CI gate:** build + unit tests + the URL contract suite + a secret scan.

## The URL contract — MUST NOT CHANGE (D-003)

Google has indexed millions of pages. Every URL below must keep resolving.
Where possible use a **rewrite** (URL stays the same, 200) — never a redirect
that drops the path — so no ranking is lost. Only `/slcommunity/` is out of
scope (D-012).

| Public URL | What it serves | 200 or 301? |
|---|---|---|
| `/newspage/{id}ai-{alias}` | SEO article page | 200 (rewrite, unchanged) |
| `/newspage/{dcode}ai-{alias}` | canonical variant when `dcode` is numeric | 200 (keep) |
| `/news/page.jsp?articleid={id}` | legacy article page | 200 (keep) |
| `/n/p?i={id}` | legacy article short URL | 200 (keep) |
| `/rcsearch/news?q=..&fq=category:..&NarrowBy=Category` | search / category listing | 200 (keep) |
| `/mobile/` and `/mobile/{id}ci-{alias}` | mobile pages | 200 (keep, responsive UI) |
| `/mobilepage/*` | mobile article | 200 (keep) |
| `/news/sitemap.jsp` | sitemap | 200 (keep); new `/sitemapindex.xml` (D-025) |
| `/feed`, RSS/Atom | syndication | 200 (keep) |
| `robots.txt` | crawler rules | 200 (keep) |
| `/slcommunity/*` | WordPress blog | **out of scope** (D-012) — stays as-is |

**SEO fixture (regression case):** article `article_id = 12272011`, alias
`court-rejects-shiranthi-s-bail-application`, must stay reachable at
`https://www.vivalanka.com/newspage/12272011ai-court-rejects-shiranthi-s-bail-application`.

**Verified legacy URL rules (from `ROOT/news/page.jsp`):**
- `articleIDString = URI.substring(10, URI.indexOf("ai-"))` — assumes
  `/newspage/` is exactly 10 chars. The new handler must be **prefix-based**, not
  a fixed offset, so a trailing slash or extra segment cannot break it.
- Numeric **`dcode` replaces `article_id`** in the canonical URL once the article
  is loaded (`dcode` wins).
- No alias ⇒ `/news/page.jsp?articleid={id}`.
- `dcode` containing **`_short`** ⇒ body = description with HTML stripped.
- `dcode` containing **`hosted`** ⇒ listing links stay internal (not the external `url`).
- Date shown prefers **`updated`**, falling back to **`published`**.
- `aproval_status = '4'` ⇒ not published (serve 404/410, not the article).
- **Sample data (owner):** article `12272011` has `dcode = "hosted"` — a
  **non-numeric** value, so the canonical stays `/newspage/12272011ai-{alias}`
  (`article_id`), not `dcode`. See D-018.

**Resolved:** the production prefix is **`/newspage/`** at the domain root
(owner, Q11) — see D-016.

---

## Phase 0 — Discovery & safety net

- [x] GitHub repo confirmed **public, `main`, empty** — this tree is the source
      (treated as first commit at cutover).
- [x] Schema is **provided** and frozen: `rcsiteweb/db/dbschema.sql` (31 tables).
      Never written to (D-014). Bootstrap is a plain load, not Flyway (no
      migrations — D-004/D-008).
- [x] Content split resolved (Q3/D-015): only `articles` is used.
- [x] URL inventory built from the **live site** and frozen — `URL-INVENTORY.md`,
      `tools/url-contract.ps1`, `tools/url-inventory/url-contract.json`
      (**20/20 PASS**).
- [x] Security audit of the legacy app — `SECURITY-NOTES.md` (plaintext passwords,
      SQL injection, Java 8, log4j 1.x).
- [x] Keep the committed connection credentials as-is (D-023); new stack ignores
      them. Legacy stays read-only.
- [ ] Local dev stack: Docker Compose with a **MariaDB 10.6** clone
      (schema + config seed) + Solr — `tools/local-stack/docker-compose.yml`
      (+`tools/db-load.ps1`). *(Not runnable in this sandbox: no Docker/Maven/MySQL.)*
- [ ] WildFly 27 datasource + JDBC module — `tools/wildfly/` (D-017).
- [x] URL-contract regression harness (runs against legacy now, new app later).

**Smoke test (end of Phase 0):** the local stack starts; the harness reports every
frozen URL as 200 against the legacy preview; no secret value is present anywhere
in the git tree.

## Phase 1 — Backend foundation (Spring Boot 3 on Java 17, WildFly 27)

- [x] Spring Boot skeleton in `backend/`, package `com.rev_creations.rcsite`;
      packaged as a **WAR** for **WildFly 27** (Jakarta EE 10 -> `jakarta.*`,
      Servlet 6), using a **WildFly datasource via JNDI** (D-017).
- [x] JPA entities + repositories for: `articles` (**only** - `articles2`/`articles3`
      ignored, D-015), `article_category`, `article_category_has_feed_channel`,
      `feed_channel`, `feed_article`, `feed_channel_log`, `geo_location`,
      `geo_blocks`, `location_article_category`, `rcsite_config`, `rc_customer`,
      `usertype`, `preferences`, `email`, `email_report`, `directory`,
      `rc_category`, `readme`, `webui`.
- [x] **Do NOT model `article_category_has_articles`** (D-019). Keep the guard test
      (`ForbiddenTableUsageTest`) and `tools/check-forbidden-tables.ps1` green.
- [x] **MyISAM-safe persistence:** `ddl-auto=none`; `categoryid`/`feed_channel_id`
      are plain fields, not JPA relationships (no FKs exist); read paths use
      DTO projections / `@Immutable`; writes are small single statements (D-008).
- [x] DTOs + MapStruct mappers (never expose entities) per `claude/api-design`.
- [x] Read APIs: article by `article_id` **and** by `dcode`; category listings;
      config; feeds. All queries **parameterised** (NC-005).
- [x] Article lookup on **`articles` only** (D-015).
- [x] Unified error body; Caffeine cache for `rcsite_config`; springdoc OpenAPI.
- [x] SLF4J + Logback (`logback-spring.xml`); secrets from env (D-005).

**Smoke test (end of Phase 1):** `GET` article `12272011` returns the exact legacy
fields (title, description, details, image, thumbnail, categoryid, author_name,
author_intro, entry_date, published, updated, url, alias, dcode, aproval_status);
lookup by `dcode` returns the same row; Swagger UI loads; no credentials in source.

## Phase 2 — SEO-critical endpoints & URL parity

- [x] Server-render `/newspage/{id}ai-{alias}` (and the numeric-`dcode` variant)
      with the exact canonical, `<title>`, meta description and OG/Twitter tags the
      legacy page emits.
- [x] Honour the `dcode` rules: numeric wins; `_short` ⇒ stripped-description body;
      `hosted` ⇒ internal link; `aproval_status='4'` ⇒ not published.
- [x] Serve `/news/page.jsp?articleid=`, `/n/p?i={id}`, `/mobile/{id}ci-{alias}`.
- [x] Sitemap: serve `/sitemapindex.xml` (+ the secondary
      `/sitemapindex04302022.xml`) pointing at `/sitemap_{n}.xml` shards — the
      **legacy names** (~204 shards, ~10k URLs each, ~2M total; D-025). Generated
      from `articles`, newest first. `robots.txt` mirrors production
      (`frontend/public/robots.txt`). See `URL-INVENTORY.md`.
- [x] Image URL bases: `/custom/images/` **and** `/custom/media*` (D-024).
- [x] 404/500 pages with correct status codes (no soft-200s).

**Smoke test (end of Phase 2):** the sample URL returns 200 with a byte-identical
canonical and equivalent head metadata vs legacy; the numeric-`dcode` form also
returns 200; sitemap contains the sample; `curl -I` shows 200 (not 301).

## Phase 3 — Frontend foundation (Next.js + React)

- [x] Next.js App Router app in `frontend/`; Tailwind + brand design tokens
  (`tailwind.config.js`, `postcss.config.js`, `src/app/globals.css`). shadcn/ui
  deferred until a page needs a real component.
- [x] Responsive shell matching the brand: sticky `SiteHeader` (nav + search
  entry point, mobile toggle), `SiteFooter`, skip link, `layout.tsx`.
- [x] Home `page.tsx`: newest-first article listing (lead + grid, empty state)
  from the new `/api/articles` paged endpoint (D-026).
- [x] Article page via shared `ArticleView` (desktop + mobile routes); legacy
  head (title/description/og/canonical) preserved byte-for-byte (D-003).
- [x] Listing helpers (`articleHref`, `imageSrc`, `formatDate`) + unit tests.
- [ ] shadcn/ui component adoption (only when a page needs a real component).
- [ ] Lighthouse SEO >= 95 / Performance >= 90 on the sample (tooling blocked on
  this host; SEO signals asserted from the served HTML instead).

**Smoke test (end of Phase 3):** article page renders the sample end-to-end
(API → SSR HTML); Lighthouse SEO ≥ 95 and Performance ≥ 90 on the sample;
usable at 360 px and 1440 px widths.

## Phase 4 — Search, categories & listings

- [x] Solr integration (proxy the existing `/news` collection; D-011).
      Backend `SearchService`/`SolrProperties` call Solr's HTTP JSON API directly
      (no `solrj` dependency), exposed as `GET /api/search` and
      `GET /api/search/category/{id}`. Row count is driven from `rcsite_config`;
      a Solr outage fails open (empty, `available=false`) instead of erroring (D-027).
- [x] `/rcsearch/news` search + `fq=category:` filter + pagination
      (`rows`/`start`) driven from `rcsite_config` keys (`categorylimit.*`,
      `categoryinterval.*`). The bot-only gate is preserved (browser -> 403,
      crawler -> 200); humans use `/search` (D-027). `layout=plain` is served by
      the plain-HTML `/rcsearch/news` response.
- [x] Category/landing pages: world news (`/news/worldnews.jsp`), news index
      (`/news/index.jsp`), Sinhala (`/news/Sinhala.jsp`) and
      `/news/pagelist.jsp?categoryid=` (D-028).
- [ ] Community, events, charities and sports landings - **data-gated**: their
      category ids are not fixed in any section JSP and the local category tables
      are empty, so the sections cannot be verified yet.

**Smoke test (end of Phase 4):** a known query returns the same top results as
legacy; category listing and pagination match; `layout=plain` renders for iframes.

## Phase 5 — Legacy URL preservation & mobile

- [x] IIS URL-rewrite / reverse-proxy rules so every contract URL resolves
      unchanged; Next.js `rewrites` for the app-owned paths. Delivered as
      `frontend/web.config` (URL Rewrite + ARR): `/api/*` and the sitemaps proxy
      to WildFly, everything else to Next.js at the **exact requested path**.
      It adds **no** trailing-slash/casing/canonicalising rule, so a 200 never
      becomes a 301 (D-003, D-030). Next.js `next.config.mjs` keeps the dev-time
      proxy for `/api/*` and the sitemaps.
- [x] Mobile URLs served by the responsive app (no separate mobile codebase):
      `/mobile/` and `/mobile/{id}ci-{alias}` (+ `/mobilepage/*`) render through
      the shared `ArticleView`.
- [x] Structural URL gaps closed: `/news/plainpage.jsp`, `/news/contactus.jsp`,
      `/news/sitemap.jsp`, `/directory/suggesturl.jsp`, `/user/login.jsp`,
      `/user/passwordrecovery.jsp`, `/user/changelocation.jsp` now resolve at
      their exact paths. The interactive `/user/*` and contact forms are
      URL-preserving shells pending Phase 6 (mail) / Phase 7 (auth); they render
      the legacy fields but submit disabled, with a visible notice rather than a
      silent no-op (D-030, D-031).

**Smoke test (end of Phase 5):** the full URL-contract regression suite passes
with **zero** URI changes and no unintended 301s; mobile URLs return 200.
Local result: **17/20** against `http://localhost:3000`. The only 3 misses are
the three extra sample articles (`12247832`, `12247828`, `12247838`) that are
**not in the local DB** - a local-data limit, not a routing gap; every
structural path passes.

## Phase 6 — Content, feeds & media

- [x] Port `FeedGenerator` (YouTube/Atom), `GenerateRSS`, `SearchUpdater` as
      scheduled jobs writing `feed_article` / `feed_channel_log` and updating
      `next_poll` on `feed_channel`. Delivered: `FeedScheduler` (fixed-delay
      sweep, `@EnableScheduling`), `FeedPollService` (fetch -> parse -> stage ->
      log -> reschedule; per-channel transaction), `FeedParser` (RSS 2.0 + Atom,
      guid de-dupe, XXE-safe), `FeedFetchService` (JDK HttpClient). RSS is served
      at `/api/rss` and publicly at `/rss` (D-033). Defaults match the legacy
      servlet: category 7, 10 items.
- [ ] Media handling: image resize/upload endpoints (port `ImageHelper`/`Scalr`);
      storage decision. **Blocked** - needs an owner storage decision (local disk
      vs object store vs the legacy `/custom/media*` tree) and Phase 7 auth: an
      unauthenticated upload endpoint is an arbitrary-file-write hole. Do not
      ship it until both exist (D-035).
- [x] **No AI** (D-010) - `AIArticleGenerator.java` exists in the legacy tree
      and is deliberately **not ported**; no AI code path is added.
- [x] **No commerce** (D-009) - the storefront is not ported (verified absent).

**Smoke test (end of Phase 6):** a feed poll writes a `feed_channel_log` row and
updates `next_poll`; a raw item lands in `feed_article`; the RSS endpoint validates.
Result: the happy path is covered end-to-end by `FeedPollServiceTest` (a real
in-process HTTP feed -> items staged, a log row written, `next_poll` moved
forward). On the local stack `POST /api/feeds/{id}/poll` logs a row and
reschedules, and `GET /rss` returns `application/rss+xml` (1 item for the local
article's category 3). The 3 bundled channels point at dead YouTube playlist URLs
(real legacy data), so a live poll logs `http 404` - exactly the recorded-and-
continue path.

## Phase 7 — Admin & authentication

- [x] Spring Security + JWT for the admin area; roles from `usertype`.
      Done (D-036): stateless HS256 bearer JWT; roles from `rc_customer.type` ->
      `usertype`. `POST /api/auth/login`, `GET /api/auth/me`.
- [x] Authenticate against the existing **`rc_customer`** table (D-022).
      Done: identity is `rc_customer.username`; no schema change.
- [x] Verify how `rc_customer.pword` is stored and design auth accordingly
      (storage is plaintext; `LegacyPasswordVerifier` refuses it unless
      `rcsite.auth.allow-legacy-plaintext` is enabled; NC-006 rehash still needs owner approval, D-004).
- [x] React admin UI: article, category, feed, config, email screens (drop
      commerce screens). Done: `src/app/admin/**` (articles list/new/edit,
      categories, feeds, config, email); JWT bearer wired via `src/lib/auth.ts`
      and `admin-api.ts`; `npm test` 26/26, `tsc` 0, `next build` ok; E2E
      create -> edit -> hide -> publish -> public read 200 (D-009, D-036).

**Smoke test (end of Phase 7):** admin login works; create → edit → publish an
article round-trips and appears at its `/newspage/` URL; the published row is read
back through the public API.

## Phase 8 — Cutover

- [x] CI/CD pipeline: GitHub Actions gate on every push/PR - backend `mvn test`,
      frontend test + typecheck + build, record-kit conformance + encoding
      (D-037; `.github/workflows/ci.yml`).
- [ ] IIS keeps the WordPress site on `/slcommunity/` and reverse-proxies the app
      paths + `/api` to WildFly; TLS; caching (D-007). **Owner-gated:** needs the
      production host, TLS cert and DNS.
- [ ] Observability (metrics, logs, alerts), load test, CI/CD pipeline update.
      **Partly done:** the CI gate above is the "pipeline update"; actuator/
      Prometheus metrics and the load test need the staging/production host.
- [ ] Search Console re-verify; monitor 404/5xx; decommission legacy.
      **Owner-gated:** needs Search Console access and the production host.

**Smoke test (end of Phase 8):** full end-to-end run on a staging domain;
sampled indexed URLs all 200 with identical canonicals; Core Web Vitals pass;
rollback plan tested.

---

## Open questions — status

All planning questions are now **resolved** except a few "nice to have" items.

| # | Question | Answer | Record |
|---|---|---|---|
| Q3 | `articles2`/`articles3`? | Ignored — no live articles | D-015 |
| Q4 | Mobile URLs indexed? | Keep (200) | D-003 |
| Q11 | URL prefix / `dcode` | `/newspage/` at root; sample `dcode="hosted"` | D-016, D-018 |
| Q12 | WildFly packaging | WAR + WildFly datasource (JNDI) | D-017 |
| Q13/Q14 | MyISAM writes / article write path | Stay MyISAM forever; `articles` is written | D-008 |
| Q15/Q16 | Solr host / re-index | Reuse the existing index as-is | D-011 |
| Q17 | `article_category_has_articles` | News app must not touch it → guard test | D-019 |
| Q19 | Media path | `/custom/images/` + `/custom/media*` | D-021, D-024 |
| Q20 | Sitemap | `/sitemapindex.xml` + `/sitemap_{n}.xml` + `robots.txt` | D-020, D-025 |
| Q9/Q10 | Auth source | Existing `rc_customer` | D-022 |
| Q5 | Hosting | IIS + WildFly on the same box | D-007 |
| NC-001/NC-007 | Rotate the committed creds? | No — leave them; new stack doesn't use them | D-023 |
| GitHub | Repo access | Public, `main`, **empty** (no commits); tree here is the source | PROGRESS |

**Still to confirm (non-blocking, in Phase 0):**

- [ ] **`rc_customer.pword` format** — **resolved**: stored **plaintext** (not
      hashed). NC-006; auth redesign needs owner-approved hash storage.
- [x] **Solr details** — production query name is still to confirm, but the
      web search namespace is `/rcsearch/` (bot-only; see `URL-INVENTORY.md`).
- [ ] **WildFly JNDI name** — datasource JNDI name to bind (working default
      `java:/jdbc/rcsite`); DB credentials live on WildFly.
- [ ] **Sinhala/Tamil language switch** — confirm whether it is a category or a
      field, for `hreflang` and listing filters.
- [ ] **Search Console access** — for the cutover checks in Phase 8.
