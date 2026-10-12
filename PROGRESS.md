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
