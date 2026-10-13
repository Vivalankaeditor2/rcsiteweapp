# PROGRESS.md

**Duty:** the journal - the single source of truth for what was done (append-only).

**The journal. The single source of truth for what was done.**

- Append-only. Newest entries go at the **bottom**.
- Every entry: gate Â· area Â· status Â· detail.
- Never edit old entries â€” corrections are new entries.

---

### [M0] 2026-10-10 â€” Session open

- **Gate:** M0 Session open
- **Area:** â€”
- **Status:** done
- **Views:** none
- **Detail:** Records initialised (bootstrap). All 10 record files now exist at
  the repo root. The workspace already contains `rcsiteweb` (Java 1.8 Maven WAR
  web application with JSP/servlets, Hibernate/JPA and a MariaDB/MySQL schema in
  `rcsiteweb/db/`) and `claude/` (project-level assistant rules). Next: install Java 17 + Maven to build the backend (Phase 1).

### [M1] 2026-10-10 â€” Revamp plan set (Next.js + React + Spring Boot)

- **Gate:** M1 Plan
- **Area:** whole project / planning
- **Status:** in-progress (awaiting owner approval â€” no code written)
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

### [M1] 2026-10-10 â€” Owner answers folded in; plan reviewed for gaps

- **Gate:** M1 Plan
- **Area:** whole project / planning
- **Status:** in-progress (awaiting approval â€” no code written)
- **Views:** TASK-PLAN.md, DECISIONS.md, CAPA.md, CODE-FIX-PLAN.md, DATABASE.md,
  AGENTS.md, BUILD-SPEC.md, README.md
- **Detail:** Folding in the owner's answers: Java **17**; schema **provided**
  (`rcsiteweb/db/dbschema.sql`, 31 tables â€” now fully documented in `DATABASE.md`,
  closing NC-008); **keep Solr**; drop **commerce** and **AI**; only
  `/slcommunity/` out of scope; deploy **Next.js on IIS** + **Spring Boot on
  WildFly 27**. Added D-007..D-014. Added CAPA NC-005 (SQL injection),
  NC-006 (`pword` length/hashing) and NC-007 (external credential file). Reviewed
  the plan for bugs/gaps and fixed: removed AI/commerce phases, corrected the
  backend to Java 17/WildFly, added the **MyISAM read-only** persistence rule,
  added the full **URL contract with the `dcode` variants** (numeric wins, `_short`,
  `hosted`) and the `aproval_status='4'` rule. **New risk found:** the dump
  contains `articles`, `articles2` and `articles3` â€” content split must be
  confirmed (Q3) before building the article lookup. Outstanding owner questions:
  Q3, Q4, Q11â€“Q20. **No application code changed.**

### [M1] 2026-10-10 â€” Clarifications answered; first support files built

- **Gate:** M1 Plan (+ first M2 deliverables)
- **Area:** whole project
- **Status:** done for this step (still no app code)
- **Views:** TASK-PLAN.md, DECISIONS.md, CAPA.md, CODE-FIX-PLAN.md, DATABASE.md,
  AGENTS.md, BUILD-SPEC.md, README.md, ARTICLES-HANDLING.md
- **Detail:** Owner answered all planning questions and asked for four things.
  (a) **`articles2`/`articles3` ignored** (D-015) â€” the content-split risk is gone.
  (b) **MyISAM explained** in the new plain-language companion doc
  `ARTICLES-HANDLING.md` (no transactions / FK / row locks; the JPA rules that
  follow). (c) **URL rules + options + SEO strategy** documented in the same file,
  with the recommendation to keep the traditional, framework-agnostic SEO
  (D-010b). (d) **Built support files:** `frontend/public/robots.txt`,
  `frontend/public/sitemap.xml` + `frontend/public/sitemaps/{pages,news-1}.xml`
  (D-020), and the **forbidden-table guard** â€” `ForbiddenTableUsageTest.java` and
  `tools/check-forbidden-tables.ps1`, **verified** (clean PASS; FAILS on a planted
  offender, then clean again). Also added D-016..D-023, closed NC-001 (owner
  accepted the risk, D-023) and re-scoped NC-007. GitHub: the target repo is
  **public, `main`, and empty** â€” this tree is the source. **No application code
  changed.**

### [Phase 0] 2026-10-10 â€” Discovery & safety net (partial)

- **Gate:** Phase 0
- **Area:** URL contract, local stack, DB bootstrap
- **Status:** in progress â€” URL baseline done; the running-stack smoke test is
  blocked by the sandbox (no Docker/Java/Maven/MySQL/clients)
- **Views:** URL-INVENTORY.md, tools/*, TASK-PLAN.md, DECISIONS.md, PROGRESS.md
- **Detail:** Captured the **live** behaviour and froze it.
  (a) **URL baseline: 20/20 PASS** against `https://www.vivalanka.com` via
  `tools/url-contract.ps1` + `tools/url-inventory/url-contract.json`.
  (b) Discovered and recorded: `/rcsearch/*` is **bot-only** (403 browser / 200
  Googlebot); aliases may be **empty or all dashes** (`/newspage/12247832ai-`);
  the real sitemap is **`/sitemapindex.xml` â†’ `/sitemap_{n}.xml`**, 204 shards,
  ~2M URLs; imagery is on **`/custom/media*`** not only `/custom/images/`; meta
  description is **truncated ~155 chars**; **no JSON-LD** live; the site
  **rate-limits (429)**, so the harness throttles and retries. All in
  `URL-INVENTORY.md`; new decisions **D-024** (media bases) and **D-025**
  (keep the legacy sitemap shard names â€” owner sign-off pending).
  (c) Made `frontend/public/robots.txt` production-faithful (the invented
  `/sitemap.xml` + `sitemaps/` placeholders were **removed**).
  (d) Built the local-stack artifacts: `tools/local-stack/docker-compose.yml`
  (+README), `tools/db-load.ps1`, wildfly module/datasource
  (`tools/wildfly/â€¦`), `tools/capture-sitemap.ps1`, raw evidence under
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
