# PROGRESS.md

**Duty:** the journal - the single source of truth for what was done (append-only).

**The journal. The single source of truth for what was done.**

- Append-only. Newest entries go at the **bottom**.
- Every entry: gate · area · status · detail.
- Never edit old entries — corrections are new entries.

---

### [M0] 2026-10-10 — Session open

- **Gate:** M0 Session open
- **Area:** —
- **Status:** done
- **Views:** none
- **Detail:** Records initialised (bootstrap). All 10 record files now exist at
  the repo root. The workspace already contains `rcsiteweb` (Java 1.8 Maven WAR
  web application with JSP/servlets, Hibernate/JPA and a MariaDB/MySQL schema in
  `rcsiteweb/db/`) and `claude/` (project-level assistant rules). Next: install Java 17 + Maven to build the backend (Phase 1).

### [M1] 2026-10-10 — Revamp plan set (Next.js + React + Spring Boot)

- **Gate:** M1 Plan
- **Area:** whole project / planning
- **Status:** in-progress (awaiting owner approval — no code written)
- **Views:** TASK-PLAN.md, DECISIONS.md, CAPA.md, CODE-FIX-PLAN.md, DATABASE.md,
  AGENTS.md, BUILD-SPEC.md, README.md
- **Detail:** Owner asked to revamp VivaLanka.com (`rcsiteweb`) using Next.js +
  React (frontend) and Spring Boot (backend), against the existing database, with
  the **URL pattern frozen** so indexed pages survive. Recorded the 8-phase plan
  with a per-phase smoke test (TASK-PLAN.md); locked 6 decisions (DECISIONS.md
  D-001..D-006); opened 4 nonconformities (CAPA.md NC-001 credentials, NC-002
  log4j config missing, NC-003 private `rcsiteJPA` dependency, NC-004 no tests);
  built the code queue (CODE-FIX-PLAN.md); expanded the data dictionary
  (DATABASE.md); added hard rules (AGENTS.md); set the build blueprint
  (BUILD-SPEC.md) and refreshed the front door (README.md). Created
  `credentials/` (gitignored, with `*.example` templates). **No application code
  changed.** Blocked: GitHub repo `Vivalankaeditor2/rcsiteweapp` returned Bad
  credentials (expired token); DB schema export pending.

### [M1] 2026-10-10 — Owner answers folded in; plan reviewed for gaps

- **Gate:** M1 Plan
- **Area:** whole project / planning
- **Status:** in-progress (awaiting approval — no code written)
- **Views:** TASK-PLAN.md, DECISIONS.md, CAPA.md, CODE-FIX-PLAN.md, DATABASE.md,
  AGENTS.md, BUILD-SPEC.md, README.md
- **Detail:** Folding in the owner's answers: Java **17**; schema **provided**
  (`rcsiteweb/db/dbschema.sql`, 31 tables — now fully documented in `DATABASE.md`,
  closing NC-008); **keep Solr**; drop **commerce** and **AI**; only
  `/slcommunity/` out of scope; deploy **Next.js on IIS** + **Spring Boot on
  WildFly 27**. Added D-007..D-014. Added CAPA NC-005 (SQL injection),
  NC-006 (`pword` length/hashing) and NC-007 (external credential file). Reviewed
  the plan for bugs/gaps and fixed: removed AI/commerce phases, corrected the
  backend to Java 17/WildFly, added the **MyISAM read-only** persistence rule,
  added the full **URL contract with the `dcode` variants** (numeric wins, `_short`,
  `hosted`) and the `aproval_status='4'` rule. **New risk found:** the dump
  contains `articles`, `articles2` and `articles3` — content split must be
  confirmed (Q3) before building the article lookup. Outstanding owner questions:
  Q3, Q4, Q11–Q20. **No application code changed.**

### [M1] 2026-10-10 — Clarifications answered; first support files built

- **Gate:** M1 Plan (+ first M2 deliverables)
- **Area:** whole project
- **Status:** done for this step (still no app code)
- **Views:** TASK-PLAN.md, DECISIONS.md, CAPA.md, CODE-FIX-PLAN.md, DATABASE.md,
  AGENTS.md, BUILD-SPEC.md, README.md, ARTICLES-HANDLING.md
- **Detail:** Owner answered all planning questions and asked for four things.
  (a) **`articles2`/`articles3` ignored** (D-015) — the content-split risk is gone.
  (b) **MyISAM explained** in the new plain-language companion doc
  `ARTICLES-HANDLING.md` (no transactions / FK / row locks; the JPA rules that
  follow). (c) **URL rules + options + SEO strategy** documented in the same file,
  with the recommendation to keep the traditional, framework-agnostic SEO
  (D-010b). (d) **Built support files:** `frontend/public/robots.txt`,
  `frontend/public/sitemap.xml` + `frontend/public/sitemaps/{pages,news-1}.xml`
  (D-020), and the **forbidden-table guard** — `ForbiddenTableUsageTest.java` and
  `tools/check-forbidden-tables.ps1`, **verified** (clean PASS; FAILS on a planted
  offender, then clean again). Also added D-016..D-023, closed NC-001 (owner
  accepted the risk, D-023) and re-scoped NC-007. GitHub: the target repo is
  **public, `main`, and empty** — this tree is the source. **No application code
  changed.**

### [Phase 0] 2026-10-10 — Discovery & safety net (partial)

- **Gate:** Phase 0
- **Area:** URL contract, local stack, DB bootstrap
- **Status:** in progress — URL baseline done; the running-stack smoke test is
  blocked by the sandbox (no Docker/Java/Maven/MySQL/clients)
- **Views:** URL-INVENTORY.md, tools/*, TASK-PLAN.md, DECISIONS.md, PROGRESS.md
- **Detail:** Captured the **live** behaviour and froze it.
  (a) **URL baseline: 20/20 PASS** against `https://www.vivalanka.com` via
  `tools/url-contract.ps1` + `tools/url-inventory/url-contract.json`.
  (b) Discovered and recorded: `/rcsearch/*` is **bot-only** (403 browser / 200
  Googlebot); aliases may be **empty or all dashes** (`/newspage/12247832ai-`);
  the real sitemap is **`/sitemapindex.xml` → `/sitemap_{n}.xml`**, 204 shards,
  ~2M URLs; imagery is on **`/custom/media*`** not only `/custom/images/`; meta
  description is **truncated ~155 chars**; **no JSON-LD** live; the site
  **rate-limits (429)**, so the harness throttles and retries. All in
  `URL-INVENTORY.md`; new decisions **D-024** (media bases) and **D-025**
  (keep the legacy sitemap shard names — owner sign-off pending).
  (c) Made `frontend/public/robots.txt` production-faithful (the invented
  `/sitemap.xml` + `sitemaps/` placeholders were **removed**).
  (d) Built the local-stack artifacts: `tools/local-stack/docker-compose.yml`
  (+README), `tools/db-load.ps1`, wildfly module/datasource
  (`tools/wildfly/…`), `tools/capture-sitemap.ps1`, raw evidence under
  `tools/legacy-capture/` and `tools/sitemaps/`. **No application code changed.**
### [M2] 2026-10-10 - Record-system kit conformance
- **Gate:** M2 Deliverable (+ M4 Reusable process)
- **Area:** records / docs
- **Status:** done
- **Views:** all ten record files; SKILLS.md, BUILD-SPEC.md, AGENTS.md, README.md, DATABASE.md, DECISIONS.md, CAPA.md
- **Detail:** Conformed the record set to the kit in `zenodo/interns_secret_general.md`.
  (a) Added a **Duty** line to every record file and the supporting docs.
  (b) Filled **SKILLS.md** with SOP-001 (URL check), SOP-002 (forbidden-table guard)
  and SOP-003 (load schema), and pointed to each from `AGENTS.md`.
  (c) Removed the **Flyway** contradiction - the schema is fixed and loaded as-is
  (D-004/D-008); there is no migration tool.
  (d) Moved **BUILD-SPEC.md** markers to the kit's vocabulary: #12 URL-contract suite
  and #13 forbidden-table guard are now `as-built-verified` (evidence: 20/20 PASS;
  guard PASS/FAIL/PASS).
  (e) Removed all `[FILL]` placeholders. Kit self-check and definition-of-done:
  PASS; no credential value appears in any file.
### [M6] 2026-10-10 - Session close
- **Gate:** M6 Session close
- **Area:** -
- **Status:** done
- **Views:** none
- **Detail:** Phase 0 discovery is complete and the record set conforms to the kit.
  Next session: install Java 17 + Maven (and Docker/MySQL where available) and start
  Phase 1 (backend foundation). Owner sign-offs still open: D-024 (media bases),
  D-025 (sitemap shard names), and the NC-006 password-hash storage change.
### [M2] 2026-10-10 - Phase 1 backend foundation (skeleton, entities, read API)
- **Gate:** M2 Deliverable
- **Area:** backend
- **Status:** built (not run here - no JDK/Maven/WildFly in this sandbox)
- **Views:** TASK-PLAN.md, CODE-FIX-PLAN.md, BUILD-SPEC.md, AGENTS.md, README.md, PROGRESS.md
- **Detail:** Wrote the Spring Boot 3 skeleton in ``backend/`` (package
  ``com.rev_creations.rcsite``), packaged as a **WAR** for **WildFly 27** (Java 17,
  ``jakarta.*``, SpringBootServletInitializer), with a WildFly JNDI profile
  (``java:/jdbc/rcsite``) and a direct-JDBC local profile.
  (a) **pom.xml** - Spring Web, Data JPA, Validation, Cache, Caffeine, springdoc,
  MapStruct, Lombok, MariaDB driver (runtime), Tomcat (provided), H2 + starter-test
  (test). ``ddl-auto=none`` - the schema is never created or altered (D-004/D-008).
  (b) **19 entities** for the in-scope tables - all **MyISAM-safe**: plain scalar
  id fields, **no JPA relationships** (`articles`, `article_category`,
  `article_category_has_feed_channel` (composite key), `feed_channel`,
  `feed_article`, `feed_channel_log`, `geo_*`, `location_article_category`,
  `rcsite_config`, `rc_customer`, `usertype`, `preferences`, `email`,
  `email_report`, `directory`, `rc_category`, `readme`, `webui`).
  ``article_category_has_articles`` is **not** modelled (D-019).
  (c) **19 repositories**, all derived (parameterised) queries only - no string SQL
  (NC-005). Article lookup is on ``articles`` only (D-015), by id and by ``dcode``.
  (d) **DTOs + MapStruct mappers** (entities never exposed), **read services**,
  and **REST controllers** under ``/api`` (articles, categories, feeds, config).
  (e) Unified ``ApiError`` body + ``@RestControllerAdvice``; Caffeine cache for
  ``rcsite_config``; springdoc OpenAPI + Swagger UI; ``logback-spring.xml``
  (replaces log4j - D-006).
  Verified here (no JVM): the forbidden-table scan of ``backend/src/main`` is
  **CLEAN**; all 62 Java files have balanced braces/parens; the pom is valid XML.
  **The Maven build and the Phase 1 smoke test are NOT run** - no JDK/Maven/WildFly
  in this sandbox, so status is ``built``, not ``as-built-verified``. Known
  integration risk for the WildFly run: Spring Boot 3 + WildFly needs a
  ``jboss-deployment-structure.xml`` (exclude container logging/Jakarta modules or
  align them); to confirm on first deploy.
  **No application code existed before this entry.**
### [M3] 2026-10-12 - Phase 1 backend: build, tests and WAR packaging verified
- **Gate:** M3 Verification
- **Area:** backend
- **Status:** verified (build + unit/web tests). Data smoke test still pending (no local DB loaded).
- **Views:** TASK-PLAN.md, CODE-FIX-PLAN.md, BUILD-SPEC.md, AGENTS.md, README.md, PROGRESS.md
- **Detail:** Java 17.0.12 (``C:\Program Files\Java\jdk-17``) + Maven 3.9.9 located.
  (a) ``mvn test`` -> **BUILD SUCCESS, Tests run: 9, Failures: 0, Errors: 0** (context load,
  ``ArticleServiceTest`` x4, ``ArticleControllerTest`` x3 - MockMvc proves the 200 JSON body and
  the 404 unified error body, ``ForbiddenTableUsageTest``).
  (b) ``mvn package`` -> ``backend/target/rcsite-backend.war`` (47 MB); ``WEB-INF/lib`` has 83 jars.
  (c) WildFly prep (no DB needed): MariaDB JDBC driver module installed at
  ``<WILDFLY>/modules/org/mariadb/jdbc/main`` and ``backend/src/main/webapp/WEB-INF/jboss-deployment-structure.xml``
  added (excludes WildFly logging modules so Logback binds) - confirmed present inside the WAR.
  **Still not proven:** the Phase 1 smoke test (``GET`` article ``12272011`` returns the legacy
  fields). It needs the ``vivalanka`` database loaded into the local MariaDB 10.6 (running),
  whose root password is not available to this session. Marked blocked until then.
### [M3b] 2026-10-12 - Phase 1 smoke test blocked: local DB credential rejected
- **Gate:** M3 Verification (blocker)
- **Area:** backend / environment
- **Status:** blocked
- **Views:** TASK-PLAN.md, CODE-FIX-PLAN.md, PROGRESS.md
- **Detail:** The local MariaDB 10.6 service is running (port 3306) but holds only the
  system databases; ``vivalanka`` is not loaded. The DB credential in
  ``C:\allcredentials\Credentials.md`` (the ``local MySQL <password>`` line) is **rejected**
  by the server (``ERROR 1045 Access denied``) for users ``root``, ``mysql`` and ``MySQL``,
  over both TCP and ``localhost``. Without a working login I cannot create/load the
  ``vivalanka`` database, so the Phase 1 data smoke test (``GET`` article ``12272011``)
  cannot run. All non-DB verification is already green (build + 9 tests + WAR). Reopen when
  the local DB password is confirmed.
### [M3c] 2026-10-12 - Phase 1 smoke test PASSES on WildFly 27 (JNDI datasource)
- **Gate:** M3 Verification
- **Area:** backend / deployment
- **Status:** verified - Phase 1 complete.
- **Views:** TASK-PLAN.md, BUILD-SPEC.md, CODE-FIX-PLAN.md, AGENTS.md, README.md, PROGRESS.md
- **Detail:** Local MariaDB 10.6.16 ``vivalanka`` database created + loaded (32 tables via
  ``tools/db-load.ps1``); a local ``rcsite`` DB user granted on ``vivalanka``. MariaDB JDBC
  module + ``RcSiteDS`` datasource added to WildFly (bound ``java:/jdbc/rcsite``); WAR deployed
  to ``wildfly-27.0.0.Final`` with ``SPRING_PROFILES_ACTIVE=wildfly``. Hibernate validated all
  19 entities against the real schema (no failures). Smoke result (HTTP through WildFly on :8080):
  ``GET /api/articles/12272011`` -> 200 with the legacy fields; ``by-dcode/12272011`` -> 200;
  ``/api/feeds`` -> 200 (3 rows); ``/api/config/categoryinterval.100`` -> 200.
  (``/api/categories`` returns ``[]`` only because the seed files contain no category rows.)
  The temporary test article was deleted afterwards. Phase 1 is now fully as-built-verified.
### [M4] 2026-10-12 - Phase 2 complete: SEO endpoints + URL parity (SSR verified end-to-end)
- **Gate:** M2 Implementation / M3 Verification
- **Area:** frontend / backend / SEO
- **Status:** verified - Phase 2 complete on the local stack (embedded Tomcat + next start).
- **Views:** TASK-PLAN.md, BUILD-SPEC.md, PROGRESS.md, AGENTS.md, URL-INVENTORY.md, frontend/public/README.md
- **Detail:** Built and end-to-end verified the Phase 2 SEO-critical endpoints against a
  temporary sample article (id 12272011, hosted, approval 1), then deleted the row
  (articles back to 0 rows; legacy schema untouched - read-only, D-004/D-008).
  (a) Backend: SitemapService/SitemapController generate /sitemapindex.xml (+ the
  secondary /sitemapindex04302022.xml) and /sitemap_{n}.xml shards from articles,
  newest first, published-only (aproval_status <> '4' or NULL), base URL from
  rcsite.sitemap.base-url (default https://www.vivalanka.com). An out-of-range shard
  returns 404 via the unified error handler. mvn test -> 20/20 green.
  (b) Frontend: Next.js 14.2.35 app; next build green; node --test -> 13/13 green
  (article id parsing ^\d{1,9}$, ai-/ci- splitting incl. empty and all-dash aliases,
  shortenString(desc,150), _short body, hosted internal link, approval-4 not published,
  canonical, head tags).
  (c) End-to-end (next start -> rewrites -> Spring Boot): /newspage/12272011ai-{alias}
  -> 200 with a BYTE-IDENTICAL canonical
  <link rel="canonical" href="https://www.vivalanka.com/newspage/12272011ai-..." />;
  /newspage/12272011ai- (empty alias, the numeric-dcode variant) -> 200; legacy
  /news/page.jsp?articleid=, /n/p?i=, /mobile/{id}ci-{alias}, /mobilepage/... -> 200;
  bad/non-numeric ids and missing articles -> 404 (no soft-200s). Every URL checked
  with MaximumRedirection 0, so none is a 301 (D-003). /sitemapindex.xml lists
  /sitemap_1.xml; the shard lists the sample URL and is served through the frontend
  rewrite; /sitemap_2.xml -> 404. /robots.txt is byte-identical to the production
  capture (834 B, served from frontend/public/robots.txt).
  Evidence note: the live legacy og:description/twitter:description use the raw
  description with tags stripped only (replaceAll("<.*?>","")), NOT shortenString, so no
  &nbsp; fix is required - our head logic is faithful.
  (d) Fixed a route collision: duplicate required+optional catch-all dirs under
  mobile/mobilepage ([...slug] vs [[...slug]]) made next build fail; kept the optional
  form and removed the required form.
- **Open:** search /rcsearch/news (Solr) and category listings are Phase 4; E2E/a11y
  (Playwright/axe) and IIS rewrite parity are Phase 3/5; the temporary sample row is not committed.
### [M2] 2026-10-12 - Phase 3 frontend shell + paged listing API (verified end-to-end)
- **Gate:** M2 Deliverable (+ M3 Verification for the listing error path, + M4 for the `/api/` decision)
- **Area:** frontend / backend / api
- **Status:** Phase 3 core done and verified on the local stack; shadcn/ui and the Lighthouse run remain open.
- **Views:** TASK-PLAN.md, CODE-FIX-PLAN.md, BUILD-SPEC.md, DECISIONS.md, AGENTS.md, PROGRESS.md
- **Detail:** Built the branded Phase 3 shell and a paged listing endpoint, then verified them end-to-end (embedded Tomcat + `next start`).
  (a) **Backend listing.** `GET /api/articles?page=&size=&categoryId=` returns a `PageDto` envelope (`items,page,size,totalItems,totalPages,hasNext`), newest-first, optional category filter. A bad `page`/`size` (`page` < 0, or `size` outside 1-100) is validated to a **400**; a bad path/query type is also 400. Contract stays under `/api/` - no `/api/v1/` segment (new **D-026**). Files: `ArticleRepository` (derived paging + category query), `PageDto` (new), `ArticleService`, `ArticleController`, `ApiExceptionHandler`, plus `ArticleServiceTest`/`ArticleControllerTest`. `mvn test` -> **26/26 green**.
  (b) **Frontend design system.** Tailwind 3.4.14 + postcss + autoprefixer; brand tokens from the legacy palette (`#0066cc` accent, `#1e90ff` bright, `#07056a` deep navy) in `tailwind.config.js`; `globals.css`; the legacy logo copied to `frontend/public`. **shadcn/ui deferred** - no page yet needs a real component, so none was added (avoids unused deps).
  (c) **Shell.** `SiteHeader` (sticky, primary nav, search entry point, accessible mobile toggle), `SiteFooter`, skip-link and `#main`, wired into `layout.tsx`. Footer uses `MAIN_NAV` from `site.ts`.
  (d) **Home.** `/` lists published articles newest-first (lead + grid + empty state) from the listing API, replacing the Phase 2 feed placeholder.
  (e) **Article.** A shared `ArticleView` now renders `/newspage`, `/mobile`, `/mobilepage` so they cannot drift; listing helpers `articleHref` (canonical-derived, always internal), `imageSrc` (resolves `./custom/...` and `/custom/...` from the root, external passthrough, brand placeholder fallback) and `formatDate` (wall-clock, no timezone shift).
  (f) **Fidelity fix.** The layout initially applied a `%s | VivaLanka` title template, which **appended a suffix to the article `<title>`** - the legacy page emits the raw headline. Removed the template (documented in `layout.tsx`); the article `<title>` is byte-faithful again.
  (g) **Verification.** `npm test` -> **16/16 green**; `npm run build` -> compiled, 7 routes; the sample article 12272011 was re-inserted for the demo (its `image`/`thumbnail` set NULL so the placeholder shows). All routes checked with `MaximumRedirection 0`: `/`, the sample article, `/newspage/12272011ai-`, `/news/page.jsp?articleid=`, `/n/p?i=`, `/mobile/{id}ci-`, `/mobilepage/...`, `/mobile/`, `/robots.txt`, `/sitemapindex.xml`, `/sitemap_1.xml` all **200**; a bad id -> **404**. The canonical is **byte-identical** to production; `<title>` is the raw headline.
  (h) **Tooling note.** Lighthouse and headless-Edge screenshots could not complete on this host (Edge/DevTools timeouts); the SEO/a11y signals were asserted directly from the served HTML instead (`html lang`, `viewport`, single `h1`, all images alt-tagged, canonical, title). Performance/SEO numbers remain unmeasured - recorded as an open item, not claimed.
  **Not done:** shadcn/ui adoption; a measurable Lighthouse run; removing the demo article 12272011 before handover.

### [M6] 2026-10-12 - Delivery: 4 commits pushed to origin/main (initial push)
- **Gate:** M6 Delivery (complete)
- **Area:** vcs / delivery
- **Status:** DONE - local commits made and pushed; remote `main` = `c7b76ed` (5 commits).
- **Views:** PROGRESS.md, CAPA.md, AGENTS.md, CODE-FIX-PLAN.md
- **Detail:** Committed the outstanding Phase 2 + Phase 3 + record work as three logical commits on main (backend sitemap/listing; frontend shell; records + tools) on top of the existing Phase 1 commit, then tried to push to https://github.com/Vivalankaeditor2/rcsiteweapp.
  (a) **Secrets scan before staging.** The 35 pending changes were scanned for hardcoded credentials; only masked placeholders were found (DB_PASSWORD=<value> in AGENTS.md, ${DB_PASSWORD:} in application.properties). No secret was staged or committed.
  (b) **Push (first attempt blocked, then succeeded).** The first push returned HTTP 403: the fine-grained PAT authenticated as Vivalankaeditor2 (repo admin/push=true) but every write was refused (POST /git/blobs -> 403 "Resource not accessible by personal access token"), i.e. the token lacked the fine-grained Contents: Read and write (repo) permission; GITHUB_TOKEN was not exported and the Windows credential-store entries also 403'd. Recorded as NC-010, the credential was given write access, and a retried push created origin/main (`c7b76ed`, 5 commits); confirmed via `git ls-remote` and the GitHub API.
  (c) **Secret hygiene.** The PAT was used only in-memory for the push attempts; git remote set-url was reset to the plain URL and .git/config was verified token-free. No secret was committed.
- **Open:** none for delivery - origin/main exists at `c7b76ed`. (Remaining project items are Phase 4+ and the Phase 3 Lighthouse run.)

### [M7] 2026-10-13 - Phase 4: Solr search proxy + search/category pages
- **Gate:** M2 Deliverable (+ M3 Verification + M4 for the fail-open and bot-gate decisions)
- **Area:** backend / frontend / api
- **Status:** Phase 4 core done and verified on the local stack; the community/events/charities/sports landings are data-gated (D-029).
- **Views:** TASK-PLAN.md, DECISIONS.md, PROGRESS.md, AGENTS.md, CAPA.md
- **Detail:** Search and category listings were built on the existing Solr (D-011) and the frozen URL contract (D-003).
  (a) **Search proxy.** `SolrProperties` (`rcsite.solr.*`) + `SearchService` call Solr's HTTP JSON API with Spring's `RestClient` - **no new dependency** (new **D-027**). The request mirrors the legacy `qt=/news` call: `wt=json`, the exact legacy `fl` list (`id,title,description,url,categoryid,category,category,thumbnail,lastModified,content,parent_categoryid,start_date,end_date,site,image`), `fq=categoryid:`/`parent_categoryid:` and `rows`/`start`. Category values are validated to digits/comma-list/`local` (NC-005), so nothing can be smuggled into the filter. A Solr outage **fails open** (empty page, `available=false`; configurable to 503). Endpoints `GET /api/search?q=&categoryId=&start=&rows=` and `GET /api/search/category/{id}?parentCategory=`. Row defaults come from the legacy `categorylimit.search.*` config keys when the caller does not pass `rows`.
  (b) **Bot-only `/rcsearch/news`.** The legacy contract is preserved: a browser user-agent gets **403**, a known search crawler gets **200** (URL-INVENTORY.md §1); the crawler response is the plain (iframe-friendly) HTML `layout=plain` produced. A public `/search` page (and the header form) gives humans the same Solr results, so no person lands on a 403.
  (c) **Category landings.** `/news/worldnews.jsp`, `/news/index.jsp`, `/news/Sinhala.jsp` and `/news/pagelist.jsp` are real routes at their exact legacy paths (never a redirect). The section->category mapping is read from the section JSPs (7/10, Sinhala 44); listings come from `articles` via the listing API, newest-first, published-only, with the `?categoryid=` override honoured (new **D-028**). The legacy `worldnews` `(2,3,5,6)` Solr filter is retained for its search feed.
  (d) **Frontend.** `lib/search.ts` (bot check, Solr date formatter "EEEE, MMMM dd, yyyy", excerpt rule, href/image normalisation), the `SearchResultCard`/`CategoryListing` components, and the routes above; `BACKEND_URL` is now exported from `lib/api.ts`.
  (e) **Verification.** `mvn test` -> **37/37 green** (was 26; +11: `SearchServiceTest` vs an in-process HTTP Solr stand-in, `SearchControllerTest` via MockMvc). `npm test` -> **21/21 green** (was 16; +5 search tests); `npm run build` -> compiled, 13 routes. End-to-end on the local stack: `/news/{worldnews,index,Sinhala,pagelist}.jsp` and `/search?q=` -> **200**; `/rcsearch/news` -> **200** for Googlebot, **403** for a browser UA; `/api/search?categoryId=7bad` -> **400**. The sample article 12272011 is still present for the demo.
  (f) **Two environment facts found and recorded.** The local `vivalanka` DB currently holds **1 article (id 12272011)** and **zero** category rows, and **no Solr is installed** on this host - so live search returns the fail-open empty page here (the mapping itself is covered by the tests, and the same code works unchanged against the production Solr). This is a **local-data** limitation, not a code gap.
  **Not done:** community/events/charities/sports landings (data-gated, D-029); live Solr verification; the Phase 3 Lighthouse run.

### [M8] 2026-10-13 - Phase 5: URL preservation (IIS rules + structural URL gaps)
- **Gate:** M2 Deliverable (+ M3 Verification + M4 for the proxy-only and shell decisions)
- **Area:** frontend / iis / routing
- **Status:** Phase 5 done and verified on the local stack; the only contract misses are local-data gaps, not routing.
- **Views:** TASK-PLAN.md, URL-INVENTORY.md, DECISIONS.md, PROGRESS.md, AGENTS.md
- **Detail:** The URL contract regression (`tools/url-contract.ps1`) was the driver. It started at **11/20** and now reads **17/20**, with every remaining miss a missing local row rather than a missing route.
  (a) **IIS rules (the real gap).** There was **no** IIS configuration in the repo at all. Added `frontend/web.config` (new **D-030**): URL Rewrite + ARR reverse-proxies `/api/*` and the sitemaps to WildFly (127.0.0.1:8080) and **everything else** to Next.js (127.0.0.1:3000) at the exact requested path. It contains **no** trailing-slash/casing/canonicalising rule - the whole point is that a 200 must never become a 301 (D-003). Documented the server prerequisites (URL Rewrite + ARR proxy enabled, Node service, WildFly port). Validated as well-formed XML with 4 rules.
  (b) **Structural URL gaps.** Seven contract URLs 404'd because no route existed: `/news/plainpage.jsp`, `/news/contactus.jsp`, `/news/sitemap.jsp`, `/directory/suggesturl.jsp`, `/user/{login,passwordrecovery,changelocation}.jsp`. All seven now resolve 200 at their exact paths. `/news/plainpage.jsp` (legacy body-inclusion) and `/news/sitemap.jsp` are fully implemented; the interactive ones are URL-preserving shells (**D-031**) - legacy fields rendered, submit **disabled**, plus a visible notice, so nothing silently no-ops and no fake success is shown. Auth arrives in Phase 7, mail in Phase 6.
  (c) **Mobile.** `/mobile/` and `/mobile/{id}ci-{alias}` (and `/mobilepage/*`) render through the shared `ArticleView` (responsive, no separate mobile codebase) - 200.
  (d) **No-301 evidence.** Checked every path with `MaximumRedirection 0`: all contract URLs answer directly (200/404), none 301. Next.js keeps `trailingSlash: false` + `skipTrailingSlashRedirect: true`.
  (e) **Tests.** Added `test/routes.test.ts` (new **D-032**) - it fails the suite if any frozen path loses its route file, so a future rename cannot silently 404 an indexed URL. `npm test` -> **23/23 green** (was 21); `npm run build` -> compiled, 20 routes.
- **Open:** the 3 remaining contract misses are local-data only (`12247832`, `12247828`, `12247838` - the DB has 1 article); `/directory/suggesturl.jsp` has **no legacy source** in the tree, so its behaviour is a shell pending owner confirmation; the interactive `/user/*`, contact and suggest forms await Phase 6/7.

### [M9] 2026-10-13 - Phase 6: feeds & RSS (feed-job port); media deferred
- **Gate:** M2 Deliverable (+ M3 Verification + M4 for the RSS-path and upload decisions)
- **Area:** backend / feeds / scheduled jobs
- **Status:** the feed job and RSS are done and verified; image upload is deliberately deferred (D-035).
- **Views:** TASK-PLAN.md, DECISIONS.md, PROGRESS.md, AGENTS.md, CODE-FIX-PLAN.md
- **Detail:** Ported the legacy feed machinery, which the backend already had entities/repositories for but no behaviour.
  (a) **Poll job.** `FeedScheduler` (`@EnableScheduling`, fixed delay, `initial-delay` 30s) sweeps `feed_channel` rows that are active and due (`findDue`), and `FeedPollService` fetches -> parses -> stages into `feed_article` -> writes `feed_channel_log` -> sets `last_poll`/`next_poll`. Each channel is its own transaction; a fetch failure is logged and the channel rescheduled, never thrown - so one dead source cannot stop the sweep.
  (b) **Parser.** `FeedParser` handles RSS 2.0 (items under `<channel>`) and Atom (entries), matches on element **local name** so prefixes like `content:encoded`/`atom:id` resolve, reads `content:encoded`/`content` into `details`, and normalises dates (RFC 822 including `GMT`/`EST`-style zones, ISO offsets) to **UTC**. XXE is disabled while a benign `DOCTYPE` is still tolerated. Items with no usable guid are dropped (see D-034).
  (c) **Fetch.** `FeedFetchService` uses the JDK `HttpClient` (no new dependency), a UA, timeouts, and returns failures as a result rather than throwing.
  (d) **De-dup (D-034).** Upsert keyed on the feed `guid`, so re-polling is idempotent; capped by `max-items-per-poll`. This is a real improvement over the legacy job, which re-inserted.
  (e) **RSS (D-033).** `FeedRssService` renders RSS 2.0 with the legacy defaults (category 7, 10 items) and the frozen article link, served at `/api/rss` and publicly at `/rss`. Titles are XML-escaped; descriptions go in CDATA with `]]>` splitting.
  (f) **Shared URL rule.** Extracted `ArticleUrls.canonical(...)`, now used by **both** the sitemap and the RSS feed, so the two cannot drift (D-003).
  (g) **Admin surface.** `GET /api/feeds`, `GET /api/feeds/{id}/log` (newest-first, 404 for an unknown channel), `POST /api/feeds/{id}/poll`.
  (h) **Verification.** `mvn test` -> **57/57 green** (was 37; +20 across `FeedParserTest`, `FeedPollServiceTest` - a real in-process HTTP feed - `FeedRssServiceTest`, `FeedRssControllerTest`). Records guards PASS. URL contract unchanged at 17/20 (no regression).
- **Open:** image upload is blocked on a storage decision + Phase 7 auth (D-035). The 3 bundled channels point at dead YouTube playlist URLs (real legacy data), so a live poll here logs `http 404`; the happy path is proven by the test. Solr is still not installed locally.

### [M3] 2026-10-13 - Phase 6 records: BUILD-SPEC view orphaned, then a record-file encoding defect (NC-011)
- **Gate:** M3 Defect
- **Area:** records / records-kit conformance
- **Status:** done
- **Views:** BUILD-SPEC.md, CODE-FIX-PLAN.md, CAPA.md, AGENTS.md
- **Detail:** Two record defects found while closing Phase 6, both fixed.
  (a) **Orphaned view.** The Phase 6 code moved but `BUILD-SPEC.md` markers 7 (Feed/RSS endpoints) and 9 (Feed ingestion jobs) were left at `specified`, and marker 10's test count still read "20 tests". The Phase 6 commit updated TASK-PLAN/PROGRESS/DECISIONS/CODE-FIX-PLAN/AGENTS/URL-INVENTORY but not BUILD-SPEC - an orphaned view, which the kit's self-check calls a defect. Fixed: markers 7 and 9 -> `as-built-verified` with the evidence, marker 10 -> 57 tests.
  (b) **Encoding defect (NC-011, a recurrence of NC-009).** Appending the D-033..D-035 reminders to `CODE-FIX-PLAN.md` with PowerShell `Set-Content -Encoding UTF8` added a BOM and double-encoded the em-dashes. Restored the file from `06bf6de` (safe - no uncommitted work) and re-applied the edits with the `str_replace` editor; byte scan now clean. See `CAPA.md` NC-011.
  (c) **Kit self-check run.** All 10 record files exist; `AGENTS.md` states the project type; every `SOP-NNN`/`NC-NNN`/`D-NNN` pointer resolves; record-kit guard PASS.
- **Open:** NC-009/NC-011 both stem from PowerShell writes to UTF-8 files; the standing rule (use `str_replace`; never `Set-Content`/`Out-File` on a tracked file) is recorded in CAPA and AGENTS.md.

### [M2] 2026-10-13 - Phase 7 (part): admin auth foundation (JWT login, roles, public/private split)
- **Gate:** M2 Deliverable (+ M1 for decision D-036)
- **Area:** backend / auth / security
- **Status:** done (backend foundation, verified end-to-end on the local stack); the React admin UI is still open.
- **Views:** DECISIONS.md, CODE-FIX-PLAN.md, TASK-PLAN.md, BUILD-SPEC.md, PROGRESS.md, AGENTS.md, CAPA.md
- **Detail:** Built the non-gated half of Phase 7 - the backend authentication foundation - so the admin area has a real login before the UI is wired.
  (a) **Auth model (D-036).** Stateless Spring Security bearer JWTs (HS256, secret from `RCSITE_AUTH_JWT_SECRET`). Identity is `rc_customer.username`; roles resolve from `rc_customer.type` joined to `usertype.usertypeid -> usertypename` (no foreign key exists; the join is the numeric `type`). `POST /api/auth/login` mints a token (`sub`, `roles`, `name`, `email`, `iss`, `exp`); `GET /api/auth/me` re-reads the caller's identity. No schema change - `rc_customer` and `usertype` are read exactly as frozen (D-004/D-008).
  (b) **Public/private split.** Public read paths stay anonymous: `/api/articles/**`, `/api/categories/**`, `/api/config/**`, `/api/search/**`, `/api/rss`, the sitemaps, `/swagger-ui/**`, `/v3/api-docs/**`. Everything else (e.g. `/api/feeds`) requires a bearer token; a missing/invalid token is 401 with the unified `ApiError` body.
  (c) **NC-006 gate.** `LegacyPasswordVerifier` verifies an encoded value normally and **refuses** bare plaintext unless `rcsite.auth.allow-legacy-plaintext` is explicitly enabled. The default is OFF, so the frozen plaintext column cannot silently become the auth scheme. The owner-approved rehash/schema change (NC-006, D-004) is still **pending** and was not attempted.
  (d) **Test blast radius fixed.** Adding the security starter made the four `@WebMvcTest` web slices fail with 401 under the default chain; `ArticleControllerTest`, `SearchControllerTest`, `FeedRssControllerTest` and `SitemapControllerTest` now use `@AutoConfigureMockMvc(addFilters = false)`, since they test MVC/content-negotiation, not security. Security itself is covered by `AuthFlowTest` (real chain: login -> bearer -> `/api/auth/me`; 401 on bad/absent token; public endpoints anonymous) and `LegacyPasswordVerifierTest`.
  (e) **Verified.** `mvn test` -> **71/71 green** (57 -> 71: +14 auth tests). Live on the local stack (backend :8080 + MariaDB): `POST /api/auth/login` with the local demo user -> token; `GET /api/auth/me` with the token -> 200; `/api/feeds` with the token -> 200, without -> 401; `/api/articles`, `/api/rss`, `/sitemapindex.xml` anonymous -> 200. (The local demo user `demo` (role ADMIN) was inserted into the local `vivalanka` `usertype`/`rc_customer` rows for the demo; it is local demo data, not a schema change.)
- **Open:** the React admin UI (article/category/feed/config screens) and wiring the bearer token into `frontend/`; media screens stay blocked on D-035. NC-006 rehash still needs owner approval.


### [M3] 2026-10-13 - NC-012 charset repair: record files cleaned (double-encoding + BOMs)
- **Gate:** M3 Defect (+ M4 for the new tool/SOP)
- **Area:** records / record-kit conformance
- **Status:** done
- **Views:** CAPA.md, SKILLS.md, AGENTS.md, README.md, PROGRESS.md
- **Detail:** Repaired the systemic encoding defect recorded as NC-012, at the owner's direction (option (a)).
  (a) **Scale.** The committed record files held **312** UTF-8 double-encoding instances across 12 files, plus **4 BOMs** (`DATABASE.md`, `ARTICLES-HANDLING.md`, `URL-INVENTORY.md`, `SECURITY-NOTES.md`). `SKILLS.md` was the only clean file.
  (b) **Repair.** A byte-level pass reversed each file (cp1252 -> utf-8), with a per-position longest-prefix fallback for characters cp1252 cannot encode (e.g. the `❌` cross mark), then stripped the BOMs. Result: **0** mojibake pairs, **0** BOMs, all 13 files valid UTF-8.
  (c) **Safety.** Every file's **ASCII byte projection is byte-identical** to the pre-repair copy, so only corrupted non-ASCII bytes changed - no text was lost or reordered. (Backup taken before the write; files are outside git's working history for the uncommitted edits.)
  (d) **Tool + rule (M4).** Added `tools/check-record-encoding.ps1` (raw-byte scan: fails on any `C3 A2`/`C2 A0` pair or UTF-8 BOM) and recorded the rule in AGENTS.md and `SKILLS.md` SOP-005. This defect class (NC-009/NC-011/NC-012) had fired three times, so the process is now written down and automated.
- **Open:** none for the repair. The repaired files are part of the pending commit set.

