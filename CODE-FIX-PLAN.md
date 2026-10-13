# CODE-FIX-PLAN.md

**Duty:** the code work queue, in priority order - what code to do next.

The code work queue - priority order. Locked decisions live in
DECISIONS.md.

**Read before writing code.** If it and AGENTS.md disagree on what should
happen next, this file wins.

## Priority order

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | ~~Resolve content split: role of `articles2` / `articles3`~~ | done | D-015 â€” ignored, no live articles |
| 2 | Keep the committed `OfficeConnection`/`TrainingConnection` creds as-is | done | D-023 â€” owner: no rotation; new stack doesn't use them |
| 3 | `robots.txt` (production-faithful) | done | D-020; `frontend/public/robots.txt` |
| 4 | `article_category_has_articles` guard (test + script) | done | D-019; `ForbiddenTableUsageTest`, `tools/check-forbidden-tables.ps1` |
| 5 | Read the (empty) GitHub repo / confirm tree | done | Public, `main`, no commits â€” this tree is the source |
| 6 | Freeze the URL contract as a regression suite | open | D-003/D-013/D-016/D-018; sample `/newspage/12272011ai-...` |
| 7 | Scaffold `credentials/` + env-var loading (backend & frontend) | done | D-005; folder + `.example` templates created |
| 8 | Backend: Spring Boot WAR (Java 17) + WildFly JNDI datasource | built | D-017; `backend/pom.xml` + wildfly profile |
| 9 | Backend: entities for `articles` + the in-scope tables (MyISAM-safe) | built | D-008/D-015; 19 entities, plain ids, no relations |
| 10 | Backend: `logback-spring.xml` (replace log4j 1.2) | built | NC-002; D-006 |
| 11 | Verify `rc_customer.pword` format before designing auth | done (Phase 0) | NC-006 - confirmed plaintext; fix needs owner sign-off |
| 12 | Sitemap generator endpoints (`/sitemapindex.xml`, `/sitemapindex04302022.xml`, `/sitemap_{n}.xml`) | done | D-020, D-025; Phase 2 (SSR-verified end-to-end) |
| 13 | Frontend: Next.js + Tailwind + brand design tokens scaffold | done | TASK-PLAN Phase 3; shadcn/ui deferred until a page needs a real component |
| 14 | Backend: repositories + DTOs + MapStruct mappers (entities never exposed) | built | derived queries only (NC-005) |
| 15 | Backend: read APIs (article by id/dcode, categories, feeds, config) | built | TASK-PLAN Phase 1 |
| 16 | Backend: unified error body + Caffeine config cache + springdoc OpenAPI | built | TASK-PLAN Phase 1 |
| 17 | Deploy WAR to WildFly 27 + run the Phase 1 data smoke test | done | deployed to WildFly 27; `GET /api/articles/12272011` + by-dcode + feeds + config all HTTP 200 via JNDI `java:/jdbc/rcsite` |
| 18 | Backend: paged article listing `GET /api/articles?page&size&categoryId` | done | `/api/` contract (D-026); `PageDto`; bad `page`/`size` (page<0, size outside 1-100) -> 400; service+controller tests green |
| 19 | Frontend: responsive header/footer shell + home listing + restyled article page | done | TASK-PLAN Phase 3; Tailwind tokens; `ArticleView` shared by desktop + mobile routes |
| 20 | Remove the Phase 3 demo article `12272011` (and its NULLed image/thumbnail) before handover | open | read-only legacy schema (D-004/D-008); it was re-seeded for the Phase 3 demo only |

## Locked technical decisions

*(These live in `DECISIONS.md`. Listed here only as a short reminder, with the
`D-NNN` for each - never a second copy.)*

- Revamp to Next.js + Spring Boot â€” D-001
- Do not reuse `rcsiteJPA` â€” D-002
- Legacy URL pattern must not change â€” D-003
- Do not change the DB schema â€” D-004
- Credentials in `credentials/`, env vars at run time â€” D-005
- Logging via SLF4J + Logback â€” D-006
- Next.js on IIS, Spring Boot WAR on WildFly 27, Java 17, WildFly JNDI datasource â€” D-007, D-017
- Keep engines/charsets/shape exactly (schema freeze, MyISAM forever) â€” D-008
- Drop the commerce storefront â€” D-009
- No AI features; keep traditional SEO â€” D-010, D-010b
- Keep Apache Solr, reuse the index â€” D-011
- Only `/slcommunity/` out of scope â€” D-012
- `dcode` URL variants must resolve â€” D-013
- Do not write `dbschema.sql` â€” D-014
- `articles2`/`articles3` ignored â€” D-015
- URL prefix `/newspage/` at the domain root â€” D-016
- `dcode="hosted"` is the standard (non-numeric) case â€” D-018
- News app never touches `article_category_has_articles` â€” D-019
- `/sitemapindex.xml` + `/sitemap_{n}.xml` + `robots.txt` â€” D-020, D-025
- Media base path `/custom/images/` â€” D-021
- Auth uses the existing `rc_customer` table â€” D-022
- Keep the committed connection-file credentials as-is â€” D-023
- API contract stays at `/api/` (no `/api/v1/`) — D-026
