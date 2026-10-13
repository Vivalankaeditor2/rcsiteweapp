# AGENTS.md

**Duty:** the rules and the doorway - how to behave here; read first, every session.

Guidance for anyone — human or AI — working in this repo. Read this first,
every session.

## What this project is

A revamp of the VivaLanka.com Sri Lankan community-news website ("Raveendra
Creations"). The legacy app (`rcsiteweb`) is a Java 1.8 Maven web application
(JSP + servlets, Hibernate/JPA, MySQL/MariaDB) with news, community, events,
charities and sports sections, an AI article generator, YouTube video feeds,
Solr search and SMTP mail. It is being replaced with a **Next.js (React)**
frontend and a **Spring Boot** backend, running against the **existing
database**, with every public URL preserved exactly (see D-003).

## Project type

**Type:** `Software Development`

Building: a Next.js + Spring Boot revamp of the VivaLanka community-news site
and its supporting database, content feeds and admin tools.

## Working rules

- **Simple English.** Short sentences. Common words.
- **Explain before you change.** Say what will change and why.
- **Do not edit a file the owner is editing.** Ask first.
- **Never commit or push** unless asked.
- **No credentials in code or chat.** Names and locations only, never values.
- **State the rule, and name the SOP.** A rule that needs steps: give the short
  rule here, then point to the exact `SKILLS.md SOP-NNN`.
- **No dangling pointers.** Never name a `SOP-NNN`, `NC-NNN` or `D-NNN` that
  does not exist.
- **Never rewrite a text file with PowerShell string cmdlets.** `Set-Content`,
  `Out-File` and `Add-Content` re-encode on write, which adds a BOM and corrupts
  non-ASCII characters (this happened twice: `CAPA.md` NC-009, NC-011). Edit files
  with the `str_replace` editor. If a byte-level write is unavoidable, use
  `[System.IO.File]::WriteAllText($path, $text, (New-Object System.Text.UTF8Encoding($false)))`.
  Before committing record files, scan them for a BOM and for the `C3 A2` byte
  sequence.

## Hard rules for this project

These are safety rails. Do not break them, even if asked to "just try".
See `DECISIONS.md` D-003 to D-014.

- **URL contract is frozen (D-003, D-013).** Never change an existing URI pattern,
  and never turn a 200 into a redirect. Google has indexed millions of pages. Every
  URL in the contract in `TASK-PLAN.md` must keep resolving at the same path. The
  sample is `/newspage/12272011ai-court-rejects-shiranthi-s-bail-application`.
  Full procedure: `SKILLS.md` SOP-001.
- **Schema is frozen (D-004, D-008).** Do not change the database. Do not convert
  MyISAM→InnoDB, do not migrate charsets, do not add keys. A change is a new
  migration. There is no migration tool; `rcsiteweb/db/dbschema.sql` is the single
  DDL source, loaded as-is - do not write it (D-014).
  Full procedure: `SKILLS.md` SOP-003.
- **Secrets stay out of git (D-005).** Repo secrets live in `credentials/`
  (gitignored) or are injected as env vars. The owner's live credentials are at
  `C:\allcredentials\Credentials.md` — **outside** this repo; never copy values in.
- **Never reference `article_category_has_articles` (D-019).** The news app must not touch that table. Full procedure: `SKILLS.md` SOP-002.
- **No AI, no commerce (D-009, D-010).** Do not port `AIArticleGenerator` or the
  `rccommerce` storefront.
- **API contract is `/api/` (D-026).** Do not add an `/api/v1/` version segment.
- **`.env` and credential files are load-only.** Never read *and print* a secret
  value; never modify `.env`/credential files' tracked templates without asking.
- **Record files stay clean UTF-8 (NC-012).** Never write a tracked text file
  with PowerShell `Set-Content`/`Out-File`/`Add-Content`. After editing a record
  file, run `tools/check-record-encoding.ps1` (byte reader, not string cmdlets) and
  require `RECORD-ENCODING: PASS`. Full procedure: `SKILLS.md` SOP-005.
- **`rcsiteweb/` is read-only.** Treat the legacy app as the behavioural reference.
- **Backend shape is fixed (D-007):** Spring Boot 3 on **Java 17**, deployed to
  **WildFly 27**; frontend Next.js on **IIS**.

## The record system — one journal, many views

**PROGRESS.md is the single source of truth.** Everything else is a view of it.

### Milestone gates

| Gate | When it fires |
|---|---|
| **M0 — Session open** | Read PROGRESS.md, confirm state. |
| **M1 — Plan** | A phase or task is added or re-scoped. |
| **M2 — Deliverable** | A file or feature is finished and verified. |
| **M3 — Defect** | Something broke, or a record was wrong. |
| **M4 — Reusable process** | Done twice, or worth repeating reliably. |
| **M5 — Commit** | Anything is committed or handed over. |
| **M6 — Session close** | End of session. Always write the close entry. |

### The record step (at every gate)

1. **PROGRESS.md** — append a dated entry. Always.
2. **TASK-PLAN.md** — move status. Only if plan changed.
3. **CODE-FIX-PLAN.md** — open/close a code item. Only if code affected.
4. **BUILD-SPEC.md** — move a status marker. Only if built work moved.
5. **CAPA.md** — open/close a nonconformity. Only if M3 fired.
6. **SKILLS.md** — add/update an SOP. Only if M4 fired.
7. **DECISIONS.md** — lock a choice. Only when one is made.
8. **DATABASE.md** — update the dictionary. Only if the schema changed.
9. **README.md** — update run steps, layout or dependencies. Only if those changed.
10. **AGENTS.md** — add a rule. Only if a durable new rule was learned.

**The routing check.** Every PROGRESS.md entry carries a `**Views:**` field
naming the record files the gate touched — or `none`. No entry is complete
until every record file is either updated or explicitly ruled out. A stale view
is a defect, not a shortcut.

### Entry format

    ### [M2] YYYY-MM-DD — short title
    - **Gate:** M2 Deliverable
    - **Area:** frontend / db / api …
    - **Status:** done | in-progress | blocked
    - **Views:** TASK-PLAN.md, CODE-FIX-PLAN.md   (or: none)
    - **Detail:** what changed, where, how verified.

### If records disagree

Each file is the authority on its own subject:

| The question | The file that wins |
|---|---|
| What happened? | PROGRESS.md |
| What should happen next? | CODE-FIX-PLAN.md |
| What is already decided? | DECISIONS.md |
| What broke, and why? | CAPA.md |

Never edit history to settle a disagreement - add a new entry.

## Repo layout

- `AGENTS.md`, `PROGRESS.md`, `DECISIONS.md`, `TASK-PLAN.md`, `CODE-FIX-PLAN.md`,
  `DATABASE.md`, `CAPA.md`, `SKILLS.md`, `README.md`, `BUILD-SPEC.md` — the record
  system; `BUILD-SPEC.md` is the build blueprint.
- `ARTICLES-HANDLING.md` — MyISAM rules, URL rule options, SEO strategy.
- `URL-INVENTORY.md` — the live-captured URL contract and its findings (Phase 0).
- `SECURITY-NOTES.md` — the legacy security audit (Phase 0).
- `frontend/` — the Next.js (React) app.
  - `frontend/public/robots.txt` — production-faithful (D-020). Sitemaps are
    generated by the backend at `/sitemapindex.xml` → `/sitemap_{n}.xml` (D-025),
    not static files.
  - `frontend/tailwind.config.js`, `frontend/postcss.config.js`,
    `frontend/src/app/globals.css` - brand design tokens (Tailwind).
  - `frontend/src/lib/` - data access (`api.ts`), article/SEO rules (`article.ts`,
    `metadata.ts`), site config (`site.ts`), listing helpers (`format.ts`, `cn.ts`).
  - `frontend/src/components/` - `SiteHeader`, `SiteFooter`, `ArticleCard`,
    `ArticleView` (shared by the desktop and mobile article routes).
- `backend/` — the Spring Boot WAR.
  - `backend/pom.xml` - WAR build: Spring Boot 3, Java 17, WildFly 27 (D-017).
  - `backend/src/main/java/com/rev_creations/rcsite/` - `entity/`, `repository/`,
    `dto/`, `mapper/`, `service/`, `web/`, `config/`, `exception/`.
  - `backend/src/main/resources/application.properties` + `application-wildfly.properties`.
  - `backend/src/test/java/.../architecture/ForbiddenTableUsageTest.java` —
    guard that the news app never references the forbidden table (D-019).
- `tools/check-forbidden-tables.ps1` — the same guard for CI/legacy trees.
- `tools/check-record-kit.ps1` - checks the record set against the kit (SOP-004).
- `tools/url-contract.ps1` + `tools/url-inventory/url-contract.json` — the frozen
  URL contract and its regression harness (see `URL-INVENTORY.md`).
- `tools/capture-sitemap.ps1`, `tools/local-stack/`, `tools/wildfly/`,
  `tools/db-load.ps1` — Phase 0 local-stack and capture tooling.
- `credentials/` — local secrets, **gitignored**; only `README.md`, `.gitignore`
  and `*.example` are tracked.
- `claude/` — project-level assistant rules. Note: `project-level-claude.md`
  describes an unrelated "ecommerce-api" and is **not authoritative** for this
  project; the API-design and testing rules may be adopted where they fit.
- `rcsiteweb/` — the legacy app, kept **read-only** as the behavioural reference.
  - `rcsiteweb/pom.xml` — Maven build file.
  - `rcsiteweb/src/` — Java sources (`com.rev_creations.*`, `com.maxmind.geoip`).
  - `rcsiteweb/ROOT/` — web root (JSP, CSS, fonts, `WEB-INF`).
  - `rcsiteweb/db/dbschema.sql` — the **full DDL** (31 tables), owner-provided and
    read-only (D-014). This is the schema source of truth.
  - `rcsiteweb/db/001–016_*.sql` — numbered **seed** files (`INSERT` only).
  - `rcsiteweb/bin/` — generated/working copy of selected web files.
- `zenodo/` — the record-system kit (`interns_secret_general.md`).
## Local dev environment (verified 2026-10-12)
- **JDK 17:** ``C:\Program Files\Java\jdk-17`` (17.0.12). **Maven:** ``C:\Program Files\Apache Software Foundation\apache-maven-3.9.9``. Both are on the machine PATH but **not** in a fresh shell - export ``JAVA_HOME``/prepend ``bin`` before building.
- **DB:** MariaDB 10.6.16 service on ``127.0.0.1:3306``; database ``vivalanka``. **Local credentials live in ``C:\allcredentials\Credentials.md``** (outside the repo) as ``user ΓǪ`` / ``password ΓǪ`` lines. Do not copy values into the repo (D-005).
- **Load the schema:** ``tools\db-load.ps1 -User <u> -Password <p> -MysqlExe 'C:\Program Files\MariaDB 10.6\bin\mysql.exe' -SchemaFile <repo>\rcsiteweb\db\dbschema.sql -SeedDir <repo>\rcsiteweb\db`` (the script's ``$PSScriptRoot`` default is empty when run via ``&``, so pass the paths).
- **Backend run (dev, embedded Tomcat):** ``DB_URL=jdbc:mariadb://localhost:3306/vivalanka DB_USER=root DB_PASSWORD=ΓǪ mvn spring-boot:run``.
- **Backend run env (exact, local demo):** ``DB_URL``, ``DB_USER`` and ``DB_PASSWORD`` (values from the external ``C:\allcredentials\Credentials.md`` - never in-repo), plus ``RCSITE_AUTH_JWT_SECRET`` (>= 32 bytes) and ``AUTH_ALLOW_LEGACY_PLAINTEXT=true`` (demo only; default OFF). After any backend restart, verify a **DB-backed** read (``GET /api/articles?page=0&size=1``) - a 200 from ``/v3/api-docs`` does **not** prove the DB is reachable (NC-013).
- **Admin UI capture (no Playwright needed):** start the system Edge with ``--remote-debugging-port=9222 --remote-allow-origins=* --headless=new``, then run ``node frontend/scripts/capture-admin-screenshots.mjs`` (Node 22 ``fetch``/``WebSocket``) to write ``screenshots/01-login.png`` ... ``08-email.png``.
- **Backend deploy (WildFly 27 at ``C:\rev-crea\wildfly-27.0.0.Final``):** start ``standalone.bat`` with ``SPRING_PROFILES_ACTIVE=wildfly``; copy ``backend\target\rcsite-backend.war`` into ``standalone\deployments\``. Context root is ``/`` (``jboss-web.xml``); datasource JNDI ``java:/jdbc/rcsite``.
- **Caveat:** the seeds (``rcsiteweb/db/001-016``) contain **config/feed rows only** - no ``articles`` and no categories, so list endpoints are empty until real data is loaded.

## Frontend + end-to-end verification (verified 2026-10-12)
- **Frontend:** Node v22.12.0 / npm 10.9.0; Next.js 14.2.35 in ``frontend/``. ``npm install`` -> ``npm run build`` -> ``npm test`` (node:test via tsx; 23 tests) -> ``npm run start`` serves on :3000 and rewrites the API, sitemap and ``/rss`` paths to the backend (``BACKEND_URL``, default ``http://localhost:8080``).
- **Full local stack (Phase 2 smoke test):** load the schema/seed, run the backend (``mvn spring-boot:run``) and ``next start``; the frontend proxies ``/api/*``, ``/rss``, ``/sitemapindex.xml``, ``/sitemapindex04302022.xml`` and ``/sitemap_{n}.xml`` to the backend. ``/robots.txt`` is served statically from ``frontend/public/robots.txt`` (byte-identical to production, 834 B).
- **URL contract:** ``tools/url-contract.ps1 -BaseUrl <base>`` checks the frozen URL list (``tools/url-inventory/url-contract.json``) against any base (live or local); a 200 must never become a 301 (D-003).
- **Sitemap rule:** shards are generated from ``articles`` newest-first, published-only (``aproval_status`` is NULL or not ``4``); base host from ``rcsite.sitemap.base-url`` (default ``https://www.vivalanka.com``).
- **Feeds & RSS (Phase 6):** ``FeedScheduler`` sweeps active, due ``feed_channel`` rows on a fixed delay (``rcsite.feed.poll-delay-ms``, default 60000; disabled with ``FEED_SCHEDULER_ENABLED=false``, which the test profile sets). ``FeedPollService`` fetches -> ``FeedParser`` (RSS 2.0 + Atom, date-normalised to UTC, XXE-safe) -> upserts ``feed_article`` **keyed on guid** (idempotent; D-034) -> writes ``feed_channel_log`` -> sets ``last_poll``/``next_poll``. A fetch failure is logged and the channel rescheduled, never thrown. Fetch uses the JDK ``HttpClient`` (no new dependency). RSS 2.0 is rendered by ``FeedRssService`` with the legacy defaults (category 7, 10 items) and the frozen article link, at ``GET /api/rss`` and publicly at ``GET /rss`` (D-033). Admin: ``GET /api/feeds``, ``GET /api/feeds/{id}/log``, ``POST /api/feeds/{id}/poll``. Both the sitemap and the feed build links through ``ArticleUrls.canonical(...)`` so they cannot drift. Image upload (``ImageHelper``/``Scalr``) is **not ported** - blocked on a storage decision + Phase 7 auth (D-035).
- **Temporary data:** the Phase 2 smoke test seeded one ``articles`` row (id 12272011) and deleted it afterwards; never leave test rows in the legacy schema (read-only, D-004/D-008).
- **Phase 3 shell (verified 2026-10-12):** home ``/`` lists published articles newest-first from ``GET /api/articles?page=&size=``; the article page renders through a shared ``ArticleView`` used by ``/newspage``, ``/mobile`` and ``/mobilepage``. Tailwind brand tokens compile (``globals.css``); header/footer/skip-link present; SEO signals asserted from the served HTML (``html lang``, ``viewport``, a single ``h1``, alt text, byte-identical canonical, raw legacy ``<title>``).
- **Listing API:** ``GET /api/articles?page=&size=&categoryId=`` returns a ``PageDto`` envelope; a bad ``page``/``size`` (``page`` < 0, or ``size`` outside 1-100) -> 400. Contract stays ``/api/`` - no ``/api/v1/`` (D-026).
- **Temporary data (Phase 3):** the Phase 3 demo re-inserted the sample article 12272011 and set its ``image``/``thumbnail`` to NULL so the branded placeholder shows; remove it before handover (read-only schema, D-004/D-008).

## Phase 4 search & categories (verified 2026-10-13)
- **Search proxy:** ``GET /api/search?q=&categoryId=&start=&rows=`` and ``GET /api/search/category/{id}``. The backend calls Solr's HTTP JSON API directly via ``SearchService`` (Spring ``RestClient``; **no ``solrj``**; D-027) at ``rcsite.solr.base-url + request-handler`` (default ``https://www.vivalanka.com/rcsearch`` + ``/news``). It sends the legacy ``fl`` field list and ``fq=categoryid:``/``parent_categoryid:``; ``categoryId`` accepts digits, a comma list, or ``local`` only. A Solr outage **fails open** (empty page, ``available=false``); set ``SOLR_FAIL_OPEN=false`` to get a 503 instead. Default rows come from ``categorylimit.search.*`` bound by ``SOLR_MAX_ROWS``.
- **Bot-gated route:** ``/rcsearch/news`` keeps the legacy contract - a browser UA gets **403**, a known crawler (Googlebot/Bingbot/...) gets **200** (plain HTML). Humans search via ``/search`` (also the header form target), never ``/rcsearch/news``.
- **Category pages:** ``/news/worldnews.jsp``, ``/news/index.jsp``, ``/news/Sinhala.jsp``, ``/news/pagelist.jsp`` are real Next.js routes at the exact legacy paths (never redirects; D-028). Listings come from ``articles`` via the listing API (newest first, published-only), honouring ``?categoryid=``. Community/events/charities/sports are **data-gated** (D-029).
- **Local data caveat (2026-10-13):** the local ``vivalanka`` DB holds **1 article (id 12272011)** and **zero** category rows, and **no Solr is installed** on this host - so local search returns the fail-open empty page and category pages show the empty state. The Solr request/mapping is covered by ``SearchServiceTest`` (an in-process HTTP stand-in). Do **not** insert category/Solr rows to force a section to render - the schema is read-only (D-004/D-008).

## Phase 5 URL preservation (verified 2026-10-13)
- **IIS:** ``frontend/web.config`` (URL Rewrite + ARR) reverse-proxies ``/api/*`` and the sitemaps to WildFly (127.0.0.1:8080), everything else to Next.js (127.0.0.1:3000) at the **exact path**. It has **no** trailing-slash/casing/canonicalising rule - a 200 must never become a 301 (D-003, D-030). Server prerequisites: URL Rewrite installed, ARR proxy enabled (``appcmd set config -section:system.webServer/proxy /enabled:"True" /commit:apphost``), Node running as a Windows service. Confirm the two upstream ports per environment.
- **Structural routes now preserved:** ``/news/plainpage.jsp``, ``/news/contactus.jsp``, ``/news/sitemap.jsp``, ``/directory/suggesturl.jsp``, ``/user/login.jsp``, ``/user/passwordrecovery.jsp``, ``/user/changelocation.jsp``. ``plainpage``/``sitemap`` are fully implemented; the interactive ones are **URL-preserving shells** - legacy fields, submit **disabled**, a visible notice (D-031). Wire them in Phase 7 (auth) and once the SMTP settings are supplied by the owner (mail).
- **Contract result:** ``tools/url-contract.ps1 -BaseUrl http://localhost:3000`` -> **17/20**. The 3 misses are the sample articles ``12247832``/``12247828``/``12247838``, absent from the local DB (local-data limit). Run against production for the full picture.
- **Route guard:** ``frontend/test/routes.test.ts`` fails ``npm test`` if a frozen path loses its route file (D-032). It checks presence only; the rendered status is the contract harness.
- **``/directory/suggesturl.jsp`` caveat:** there is **no ``directory/`` source** in the legacy tree, so only the URL is preserved; confirm the intended behaviour with the owner before implementing.

## Phase 7 admin authentication (verified 2026-10-13)
- **Auth model (D-036):** stateless Spring Security **bearer JWT** (HS256, signed with `RCSITE_AUTH_JWT_SECRET`). Identity is `rc_customer.username`; roles resolve from `rc_customer.type` joined to `usertype.usertypeid -> usertypename` (there is **no** foreign key; the join is the numeric `type` value). `POST /api/auth/login` (`{username,password}`) returns `{token, tokenType, user}`; `GET /api/auth/me` re-reads the caller. Token TTL `rcsite.auth.token-ttl-minutes` (default 120), issuer `rcsite.auth.issuer`.
- **Public vs private:** anonymous paths are `/api/articles/**`, `/api/categories/**`, `/api/config/**`, `/api/search/**`, `/api/rss`, the sitemaps, `/swagger-ui/**`, `/v3/api-docs/**`. Every other path (e.g. `/api/feeds`) requires a bearer token; a missing/invalid token is **401** with the unified `ApiError` body. The backend serves the feed at `/api/rss` only (the public `/rss` is a frontend rewrite, D-033) - there is no backend `/rss` route.
- **NC-006 gate:** `LegacyPasswordVerifier` verifies an encoded value normally and **refuses** bare plaintext unless `rcsite.auth.allow-legacy-plaintext=true`. Keep the default **off**; enabling it is a migration-window-only, owner-approved switch (plaintext compare, no upgrade). The rehash/schema migration (NC-006, D-004) is **still open** - do not change the schema.
- **Local demo login:** insert a local-only row pair (not a schema change): `usertype` `(1,'ADMIN')` and `rc_customer` `('demo','demo123','Demo Editor','demo@vivalanka.local','1')`; run the backend with `RCSITE_AUTH_JWT_SECRET=... AUTH_ALLOW_LEGACY_PLAINTEXT=true`. This demo row is local seeded data, not part of the frozen schema.
- **Tests:** `AuthFlowTest` drives the real security chain (login -> bearer -> `/api/auth/me`; 401 on bad/absent token; public endpoints anonymous) and `LegacyPasswordVerifierTest` pins the NC-006 gate. The four `@WebMvcTest` web slices use `@AutoConfigureMockMvc(addFilters = false)` because they test MVC/content-negotiation, not security. `mvn test` -> **71/71**.
- **Record-file encoding (NC-012):** the committed record files carry pre-existing UTF-8 double-encoding (312 instances) and 4 BOMs. Before committing a record file, scan it with a **byte** reader (`[System.IO.File]::ReadAllBytes`), not PowerShell string cmdlets, and check for `C3 A2`, `C2 A0` and `EF BB BF`. Procedure: `SKILLS.md` SOP-005.

