# BUILD-SPEC.md

**Duty:** the build blueprint - the source of truth for everything to be built, each with a duty and an acceptance test.

**Type:** `Software Development`
**Version:** v2.0.0 (revamp target)

## Deliverables

Target deliverables for the revamp. Status `specified` = planned, not yet built.

| # | Deliverable | Duty | Acceptance test | Status |
|---|---|---|---|---|
| 1 | `backend/` Spring Boot API (Java 17, WildFly 27) | serve article, category, config and feed data | `GET` article `12272011` returns the legacy fields as JSON | built (smoke test not run - no JVM here) |
| 2 | `frontend/` Next.js app (hosted on IIS) | render the public site (SEO + UX) | home lists published articles; article page renders SSR HTML for the sample | as-built-verified (Phase 3 shell: home listing + article page render 200 from the API; legacy head preserved) |
| 3 | Article route `/newspage/{id}ai-{alias}` + numeric-`dcode` variant | serve indexed article URLs unchanged | byte-identical canonical; 200 (not 301) | as-built-verified (200, canonical byte-identical; empty/dash alias shapes OK) |
| 4 | Legacy routes `/news/page.jsp`, `/n/p`, `/mobile/*`, `/mobilepage/*` | keep old URLs alive | each returns 200 with correct content | as-built-verified (all 200; bad ids 404) |
| 5 | Search `/rcsearch/news` (Solr) | Solr-backed search + category filter | known query matches legacy top results | specified |
| 6 | `/sitemapindex.xml` + `robots.txt` + sharded `/sitemap_{n}.xml` | SEO discovery | `robots.txt` points at `/sitemapindex.xml`; index lists shards; sample URL listed (D-020, D-025) | as-built-verified (index lists shards; sample URL listed; robots.txt byte-identical to production) |
| 7 | Feed/RSS endpoints | syndication parity | feed validates; same items as legacy | as-built-verified (RSS 2.0 at `/api/rss` + public `/rss`; legacy defaults category 7 / 10 items; item link rule shared with the sitemap; `FeedRssServiceTest` + `FeedRssControllerTest` green) |
| 8 | Admin app (React) + JWT auth against `rc_customer` | manage articles/categories/feeds/config | create -> publish round-trips to its URL (D-022) | in-progress (backend auth foundation built: JWT login/me, roles from `usertype`; D-036; React admin UI pending) |
| 9 | Feed ingestion jobs (no AI — D-010) | poll feeds into `feed_article`; log to `feed_channel_log` | a poll writes a log row and updates `next_poll` | as-built-verified (`FeedPollServiceTest` drives a real in-process HTTP feed: items staged, log row written, `next_poll` moved forward; `POST /api/feeds/{id}/poll` verified live) |
| 10 | Backend unit + integration tests | prove the API and repositories | `mvn test` green; article lookup covered | as-built-verified (71 tests green, incl. auth/JWT, feed parser/poll/RSS, sitemap and search) |
| 11 | Frontend E2E + a11y tests (Playwright/axe) | prove the UI and accessibility | E2E green on the sample; axe clean | specified |
| 12 | URL-contract regression suite (`tools/url-contract.ps1` + `tools/url-inventory/url-contract.json`) | prove no indexed URL broke | suite green against the live baseline | as-built-verified |
| 13 | Forbidden-table guard (D-019) | stop the news app touching ``article_category_has_articles`` | ``ForbiddenTableUsageTest`` + ``tools/check-forbidden-tables.ps1`` | as-built-verified |
| 14 | `backend/` scaffold: WAR pom + WildFly JNDI profile + main class | deploy to WildFly 27 / run locally | `mvn package` produces a WAR; context loads | as-built-verified (deployed to WildFly 27) |
| 15 | `backend/` JPA entities + repositories (19 in-scope tables, MyISAM-safe) | map the frozen schema; parameterised reads | `mvn test` green; guard test green | as-built-verified (validated against real schema) |
| 16 | `backend/` read APIs + DTOs/MapStruct + unified errors + OpenAPI | serve article/category/config/feed reads | `GET /api/articles/12272011` returns the article JSON | as-built-verified (200 + 404 tested on WildFly 27) |
| 17 | `backend/` `logback-spring.xml` (SLF4J + Logback) | replace the legacy log4j 1.2 (NC-002) | logging config loads; no log4j on the classpath | as-built-verified (logs clean on WildFly) |
| 18 | Paged article listing `GET /api/articles?page&size&categoryId` (+ `PageDto`) | feed listings/feeds from `articles` | page envelope; invalid `page`/`size` -> 400; newest-first | as-built-verified (200 via frontend; service + controller tests green) |
| 19 | Frontend Phase 3 shell: header/footer, brand tokens, home listing, restyled article | a branded, responsive, SEO-preserving UI | home + article 200; legacy head byte-identical; a11y signals present | as-built-verified (routes + head asserted on the local stack) |

## Decisions that shape the build

- Backend is a **WAR on WildFly 27, Java 17, DB via WildFly JNDI datasource**
  (D-007, D-017). Use the `jakarta.*` namespace.
- `articles` is the **only** article table; `articles2`/`articles3` are ignored
  (D-015).
- Almost all tables are **MyISAM** → `ddl-auto=none`; id columns are plain fields,
  not JPA relationships; writes are small single statements (D-008).
- The URL contract (`/newspage/{id}ai-{alias}` at the root) is frozen
  (D-003, D-013, D-016, D-018).
- Media base paths are ``/custom/images/`` and ``/custom/media*`` (D-021, D-024).

## Already-built baseline (legacy — read-only reference)

Items that exist on disk. None is proven to work and none may be marked
`as-built-verified` without evidence.

| # | Deliverable | Duty | Acceptance test | Status |
|---|---|---|---|---|
| B1 | `rcsiteweb/` Maven WAR app | the legacy website (behavioural reference) | builds/deploys where its private deps are available | built |
| B2 | `rcsiteweb/db/` seed SQL (001–016) | seed site config and feed channels | applies cleanly to a fresh DB | built |

## Build rules

1. Build **exactly as written** - paths, names, structure.
2. Do **not** change the schema. A schema change is a new migration, and only
   after owner approval. (D-004)
3. **No credentials in code or documents.** Names and locations only. (D-005)
4. Use the **existing theme or house style**. No new frameworks.
5. **Proof, not promises.** After building, prove it end-to-end and report the
   evidence - never just "done".
6. **Do not change any public URI pattern.** (D-003)
7. Every task-plan phase ends with a **smoke test**; run it before marking done.

## Definition of done

The new Next.js + Spring Boot stack runs against the existing database on a
staging domain; the full URL-contract regression suite passes with every
sampled indexed URL returning 200 with an identical canonical; the sample URL
`/newspage/12272011ai-court-rejects-shiranthi-s-bail-application` renders
identically; admin can publish an article end-to-end; no credential value exists
anywhere in git.
