# DECISIONS.md

**Duty:** locked choices - what was decided, when, why, and what would reopen it.

Locked choices â€” what was decided, when, and why.

**Rule:** never edit or delete an entry. A reversal is a new entry that
references the old one (for example: "supersedes the earlier entry it names").

**Format:**

## D-NNN â€” short title
- **Decided:** YYYY-MM-DD
- **Decision:** what was chosen
- **Options considered:** what else was on the table
- **Why:** the reason
- **Revisit if:** the condition that would reopen it

## Decisions

## D-001 â€” Revamp rcsiteweb to Next.js (React) + Spring Boot
- **Decided:** 2026-10-10
- **Decision:** Replace the legacy Java 1.8 JSP/servlet app with a Next.js (React,
  App Router, TypeScript) frontend and a Spring Boot backend, against the existing
  MySQL/MariaDB database.
- **Options considered:** modernise the JSP app in place; a CMS migration
  (e.g. Strapi/WordPress); a static site generator.
- **Why:** owner's direction; the current stack is unsupported and hard to staff.
- **Revisit if:** the owner changes the target stack.

## D-002 â€” Do not reuse the `rcsiteJPA` artifact
- **Decided:** 2026-10-10
- **Decision:** Build new JPA entities/repositories in the Spring Boot backend
  rather than depending on the private `rcsiteJPA:0.0.1-SNAPSHOT` artifact.
- **Options considered:** depend on the existing artifact; rewrite the entity layer.
- **Why:** the artifact is private (Azure DevOps feed `VivaLanka`), unavailable,
  Hibernate 3-era, and the owner explicitly does not want it.
- **Revisit if:** a maintained entity module is required later.

## D-003 â€” Legacy URL pattern MUST NOT change (hard constraint)
- **Decided:** 2026-10-10
- **Decision:** Every existing public URL keeps its **exact** current pattern and
  keeps returning **200** wherever possible (rewrite, not redirect), because
  Google has indexed millions of pages. The article URL stays
  `/newspage/{id}ai-{alias}` (e.g.
  `/newspage/12272011ai-court-rejects-shiranthi-s-bail-application`). The legacy
  rule that a numeric `dcode` replaces `article_id` in the URL must be preserved.
- **Options considered:** redirect legacy URLs to new clean URLs; introduce
  `/article/{slug}`.
- **Why:** avoid losing search ranking and breaking inbound links.
- **Revisit if:** the owner accepts a redirect strategy with SEO sign-off.

## D-004 â€” Do not change the database schema
- **Decided:** 2026-10-10
- **Decision:** The existing schema is authoritative; the new code adapts to it.
  There is no migration tool; `rcsiteweb/db/dbschema.sql` is the single DDL source, loaded as-is. Any schema change needs owner approval first.
- **Options considered:** green-field schema + data migration.
- **Why:** the database is live and shared; a schema change is high risk.
- **Revisit if:** a change is proven necessary and approved.

## D-005 â€” Credentials live in `credentials/`, gitignored; env vars at run time
- **Decided:** 2026-10-10
- **Decision:** All local secrets go in the `credentials/` folder, which is
  gitignored (only `README.md`, `.gitignore` and `*.example` templates are
  tracked). In CI/CD and production, secrets are injected as environment
  variables from the pipeline secret store / a managed secret manager.
- **Options considered:** commit an encrypted `.env`; hardcode in app config.
- **Why:** the repo already leaked hardcoded passwords (see CAPA NC-001); this
  keeps values out of git while giving one obvious local location.
- **Revisit if:** the team adopts a different secret-management standard.

## D-006 â€” Logging uses SLF4J + Logback
- **Decided:** 2026-10-10
- **Decision:** The new backend uses Spring Boot's default SLF4J + Logback,
  configured via `logback-spring.xml`. The legacy `log4jconfigfilepath` config
  key is not used.
- **Options considered:** keep log4j 1.2 (end-of-life); log4j 2.
- **Why:** log4j 1.x is unsupported and a known security liability.
- **Revisit if:** an enterprise logging standard requires otherwise.

## D-007 â€” Deployment topology: Next.js on IIS, Spring Boot on WildFly 27
- **Decided:** 2026-10-10
- **Decision:** The Next.js frontend runs on **IIS**. The Spring Boot backend
  runs on **WildFly 27.0.0.Final** (Jakarta EE 10). Java **17** is the baseline
  for the backend. IIS reverse-proxies API/SSR traffic to WildFly.
- **Options considered:** Spring Boot as a standalone embedded-Tomcat jar; a
  container platform.
- **Why:** owner's infrastructure choice.
- **Revisit if:** WildFly proves unsuitable for the embedded-server model.

## D-008 â€” Keep the schema's engines, charsets and shape exactly (freeze)
- **Decided:** 2026-10-10
- **Decision:** Do **not** convert MyISAM tables to InnoDB, do **not** migrate
  `latin1`/`utf8mb3` charsets, and do **not** add keys/constraints unless the
  owner approves. The new code adapts to the existing schema. (Extends D-004.)
- **Options considered:** normalise engines/charsets as part of the revamp.
- **Why:** the database is live, large (12M+ rows) and shared; such changes are
  high risk and slow on MyISAM.
- **Revisit if:** a proven bottleneck or a data-correctness issue forces it.

## D-009 â€” Drop the legacy commerce storefront from scope
- **Decided:** 2026-10-10
- **Decision:** The `rccommerce` storefront is out of scope. Its tables
  (`products`, `product_categories`, `product_options`, `product_attributes`,
  `prodxcat`, `orders`, `order_items`, `order_charges`, `customers`) are left
  untouched but no new code is written for them.
- **Options considered:** port the storefront; keep it on the legacy app.
- **Why:** owner's direction ("drop").
- **Revisit if:** commerce is re-scoped later.

## D-010 â€” No AI features
- **Decided:** 2026-10-10
- **Decision:** Drop the AI article-generation feature. No OpenAI/Claude
  integration in the new stack; the legacy `ai.*` config keys and API clients
  are not ported.
- **Options considered:** port `AIArticleGenerator` as a scheduled job.
- **Why:** owner's direction ("no ai").
- **Revisit if:** AI content generation is re-scoped.

## D-010b â€” Search-engine optimisation: keep the layered traditional approach
- **Decided:** 2026-10-10
- **Decision:** Keep and extend the traditional, framework-agnostic SEO that the
  legacy site already relies on â€” exact URL preservation (D-003/D-013), a real
  `/sitemapindex.xml`, `robots.txt`, canonical tags, `<title>`/meta description,
  OG/Twitter cards, JSON-LD structured data (NewsArticle/Breadcrumb),
  `hreflang` for Sinhala/Tamil, RSS, and Search Console. Do **not** depend on any
  "AI SEO" trick that adds unique text without improving UX.
- **Options considered:** rely on AI-generated on-page SEO instead.
- **Why:** the site's traffic is Google-indexed; behaviour-based signals (Core
  Web Vitals, clean canonical URLs, real content) dominate ranking for news, and
  keywords live in the URL/title/body, not in a separate "AI optimisation" layer.
- **Revisit if:** a specific, measurably better technique is proposed.

## D-011 â€” Keep Apache Solr for search
- **Decided:** 2026-10-10
- **Decision:** Keep the existing Apache Solr for `/rcsearch/*`; the backend
  proxies/serves search results from it. No search-engine migration.
- **Options considered:** migrate to OpenSearch/Elasticsearch.
- **Why:** works today; lower risk and cost.
- **Revisit if:** Solr becomes a bottleneck.

## D-012 â€” Only `/slcommunity/` is out of scope; every other URL is migrated
- **Decided:** 2026-10-10
- **Decision:** The WordPress blog under `/slcommunity/` stays as-is (out of
  scope). **Every other** public URL is migrated and preserved (D-003).
- **Options considered:** migrate everything, including the blog.
- **Why:** owner's direction ("ignore only /slcommunity/ keep rest").
- **Revisit if:** the blog is later folded in.

## D-013 â€” `dcode` URL variants must resolve (extends D-003)
- **Decided:** 2026-10-10
- **Decision:** Beyond the numeric-`dcode` rule, the following legacy behaviours
  must be preserved: **`dcode` containing `_short`** â‡’ the article body is the
  description with HTML stripped; **`dcode` containing `hosted`** â‡’ listing links
  render as an internal article link instead of the external `url`; date display
  **prefers `updated` over `published`** (`FULL` format).
- **Options considered:** normalise these into `dcode`-less model.
- **Why:** they change rendered output/redirects for real indexed pages.
- **Revisit if:** an SEO audit shows a variant is dead and can be dropped.

## D-024 â€” Media bases: `/custom/images/` and `/custom/media*`
- **Decided:** 2026-10-10 (Phase 0; proposed, owner sign-off pending)
- **Decision:** `articles.image` / `thumbnail` values resolve under
  `/custom/images/`, and current articles also use `/custom/media*`
  (e.g. `https://www.vivalanka.com/custom/media3/2026/10/<uuid>.png`). Keep
  `/custom/images/` as the documented base and add `/custom/media*` as an
  additional base rather than one fixed prefix.
- **Options considered:** a single `/custom/images/` prefix (the earlier D-021).
- **Why:** the live article (2026-10-10) serves images from `/custom/media3/...`;
  see `URL-INVENTORY.md`.
- **Revisit if:** all media is confirmed to live under one base.

## D-025 â€” Preserve the legacy sitemap shard naming
- **Decided:** 2026-10-10 (Phase 0; proposed, owner sign-off pending)
- **Decision:** The new app serves `/sitemapindex.xml` (and the secondary
  `/sitemapindex04302022.xml`) pointing at shards named `/sitemap_{n}.xml`, the
  same scheme as the live site (n = 1â€¦212, ~10,047 URLs each, ~2M URLs). Do not
  invent new shard names for the article sitemap.
- **Options considered:** new names (`news-1.xml`, `categories.xml`, `pages.xml`).
- **Why:** the live shards are the crawled, submitted URLs; renaming them would
  404 ~2M sitemap URLs at cutover unless redirected. See `URL-INVENTORY.md`.
- **Revisit if:** Search Console confirms the legacy shards are no longer fetched.

## D-014 â€” Do not write the live `dbschema.sql` file
- **Decided:** 2026-10-10
- **Decision:** `rcsiteweb/db/dbschema.sql` is the owner-provided, read-only
  schema reference (the "fixed" schema). Do not write to, edit or regenerate that
  path.
- **Options considered:** keep generated dumps in the repo.
- **Why:** the owner supplied it as the fixed reference; keep it clean.
- **Revisit if:** the owner asks for a regenerated copy.

## D-015 â€” `articles2` / `articles3` are ignored
- **Decided:** 2026-10-10
- **Decision:** `articles2` and `articles3` hold no live articles and are not
  required. Build no entities, repositories, or lookups for them. `articles` is
  the only article table.
- **Options considered:** merge/shard lookup across all three.
- **Why:** owner confirmation (Q3). Simplifies the article lookup and the URL
  contract.
- **Revisit if:** live content is later found in those tables.

## D-016 â€” Production URL prefix is `/newspage/` at the domain root
- **Decided:** 2026-10-10
- **Decision:** The article route is `/newspage/{id}ai-{alias}` at the root of the
  site (not under `/slcommunity/`). IIS reverse-proxies `/newspage/*` (and the
  other app paths) to the Next.js app; `/slcommunity/*` stays on WordPress.
- **Options considered:** mount the app under `/slcommunity/`.
- **Why:** owner confirmation (Q11); matches the legacy `substring(10, ...)` logic
  and the external links in the legacy HTML.
- **Revisit if:** the deployment path changes.

## D-017 â€” Backend is a WAR on WildFly 27 using a WildFly datasource (JNDI)
- **Decided:** 2026-10-10
- **Decision:** Package the Spring Boot backend as a **WAR** deployed to
  **WildFly 27**. The database connection comes from a **WildFly-managed
  datasource via JNDI** (Jakarta EE 10, `jakarta.*`), not an app-managed
  HikariCP pool. Configure WildFly's HikariCP/JNDI resource for the `vivalanka`
  MariaDB database.
- **Options considered:** embedded HikariCP in a Spring Boot JAR; a Spring Boot
  WAR with its own pool.
- **Why:** owner's direction (Q12); centralises the connection pool and lets the
  container manage credentials.
- **Revisit if:** JNDI proves impractical.

## D-018 â€” `dcode = "hosted"` is the standard case
- **Decided:** 2026-10-10
- **Decision:** For the sample article (`12272011`), `dcode = "hosted"`. Treat
  non-numeric `dcode` values as a normal case: the canonical URL keeps the
  **numeric `article_id`** (`/newspage/12272011ai-{alias}`), and `dcode` is only
  used in place of `article_id` when it is numeric (legacy rule). `dcode` values
  containing `hosted` keep listing links internal; `_short` renders the stripped
  description.
- **Options considered:** assume `dcode` always nests the id.
- **Why:** matches the data the owner supplied and the legacy code.
- **Revisit if:** a numeric `dcode` sample is provided.

## D-019 â€” News app does not touch `article_category_has_articles`
- **Decided:** 2026-10-10
- **Decision:** The news application must **not** read, write, or build code
  against `article_category_has_articles`. It is owned by another process (the
  Solr indexer / commerce). "Write code for this" means: document it, add a
  **guard test** that asserts the news code never references it, and leave the
  table alone.
- **Options considered:** have the news app maintain the mapping.
- **Why:** owner confirmation (Q17); avoiding it prevents double-writes and
  surprising index behaviour.
- **Revisit if:** ownership changes.

## D-020 â€” Sitemap and robots
- **Decided:** 2026-10-10
- **Decision:** Serve the real index at `/sitemapindex.xml` (plus the secondary `/sitemapindex04302022.xml`) linking `/sitemap_{n}.xml` shards, so the ~2M URLs are crawlable, and a `robots.txt` that points to it. Shard names are the **legacy ones** (D-025). Keep the legacy `/news/sitemap.jsp` working (D-003).
- **Options considered:** only extend the legacy HTML sitemap.
- **Why:** Google needs XML + a robots pointer; a sharded index scales. Live capture (2026-10-10) confirms 204 shards of ~10,047 URLs; see `URL-INVENTORY.md`.
- **Revisit if:** the crawler strategy changes.

## D-021 â€” Media base path is `/custom/images/`
- **Decided:** 2026-10-10
- **Decision:** `articles.image` / `thumbnail` values resolve under `/custom/images/`; current articles also use `/custom/media*` (see D-024). The frontend builds absolute image URLs from these bases.
- **Options considered:** object storage / CDN.
- **Why:** owner confirmation (Q19).
- **Revisit if:** media moves to a CDN.

## D-022 â€” Authentication uses the existing `rc_customer` table
- **Decided:** 2026-10-10
- **Decision:** The new auth reads users from `rc_customer` (the existing table);
  no new user table. Handle the weak `pword` storage carefully (NC-006) â€” verify
  the stored format before designing the login.
- **Options considered:** introduce a new admin/user table.
- **Why:** owner's direction (Q9/Q10); avoids a data migration.
- **Revisit if:** the stored passwords cannot be supported securely.

## D-023 â€” Keep the committed OfficeConnection/TrainingConnection credentials
- **Decided:** 2026-10-10
- **Decision:** Do **not** switch/rotate the credentials hard-coded in
  `rcsiteweb/ROOT/Connections/OfficeConnection.jsp` and
  `TrainingConnection.jsp`; leave them as-is per owner. The new stack does not
  use them.
- **Options considered:** rotate and move them to config.
- **Why:** owner's explicit direction ("ignore, no switching credentials").
- **Revisit if:** the owner decides to rotate.

## D-026 — API contract stays at `/api/` (no `/api/v1/`)
- **Decided:** 2026-10-12
- **Decision:** The new backend REST services live under the `/api/` prefix
  (e.g. `/api/articles`, `/api/categories`, `/api/feeds`, `/api/config/...`).
  Do **not** introduce an `/api/v1/` version segment.
- **Options considered:** (a) version the API as `/api/v1/`; (b) keep the
  unversioned `/api/` contract.
- **Why:** owner-approved default (Phase 3). The API is consumed only by our own
  Next.js frontend, deployed in lockstep; a version segment adds no value and a
  second copy of every route to keep in sync.
- **Revisit if:** a third-party or independently-versioned client appears, or a
  breaking change must be served alongside the old shape.

## D-027 - Search proxied to Solr's HTTP JSON API; public `/search` page for humans
- **Decided:** 2026-10-13
- **Decision:** The backend proxies Solr over its HTTP/JSON API using Spring's
  `RestClient` rather than adding the `solrj` client dependency. It calls the
  legacy request handler (`base-url + /news`) with `wt=json`, the legacy `fl`
  field list, `fq=categoryid:`/`parent_categoryid:`, and `rows`/`start`
  pagination; the response is mapped to `SearchResultDto`. Rows default from
  `categorylimit.search.*` (falling back to a configured default) bounded by
  `rcsite.solr.max-rows`. A Solr outage **fails open** (empty page,
  `available=false`) so a search outage cannot take the site down.
  The legacy `/rcsearch/news` route keeps its **bot-only** gate (browser -> 403,
  crawler -> 200); the human-facing search lives at `/search`, which the header
  form targets, so a person never lands on a 403.
- **Options considered:** (a) add `solrj` and reuse `RCSearchFacade`; (b) proxy
  the HTTP JSON API with the already-present `RestClient`; (c) expose human
  search on `/rcsearch/news` and drop the bot gate.
- **Why:** (b) adds no dependency, keeps the backend a thin read layer, and uses
  the exact request Solr already serves. (c) would break the frozen contract that
  bots depend on (D-003); a separate `/search` preserves it.
- **Revisit if:** Solr's JSON response for `/news` is customised enough that a
  schema-aware client (solrj + a response parser) is needed, or auth/TLS to Solr
  requires a managed client.

## D-028 - Category landing pages use the frozen JSP paths, keyed on the section category
- **Decided:** 2026-10-13
- **Decision:** Each legacy section page is preserved at its exact path as a
  Next.js route (`/news/worldnews.jsp`, `/news/index.jsp`, `/news/Sinhala.jsp`,
  `/news/pagelist.jsp`), not as a redirect (a 200 must never become a 301; D-003).
  The section -> category id mapping is taken from the section JSPs
  (`index`/`worldnews`/`pagelist` -> 7 and 10; `Sinhala` -> 44; the world feed
  also uses the legacy `(2,3,5,6)` Solr filter). The listing content comes from
  the `articles` table via `GET /api/articles?categoryId=`, newest first,
  published-only, with the legacy `?categoryid=` override still honoured.
- **Options considered:** (a) serve categories from Solr only; (b) serve the
  listing from `articles` via the existing listing API.
- **Why:** (b) reuses the tested listing path, keeps postings fresh without
  waiting on an index, and needs no `article_category_has_articles` read (D-019).
  Solr remains the search surface; the two compose through `/search`.
- **Revisit if:** a section must page deeply enough that a live Solr scroll is a
  better source than the DB listing.

## D-029 - Community/events/charities/sports landings are data-gated
- **Decided:** 2026-10-13
- **Decision:** Do not hard-code category ids for the community, events,
  charities and sports landings yet. Their ids are not fixed in any section JSP
  and the local category tables (`article_category`, `rc_category`,
  `article_category_has_articles`) are **empty**, so the mapping cannot be
  verified. Add these landings once real category data (or the owner's mapping)
  is available, reusing the D-028 pattern.
- **Options considered:** (a) guess ids from `rcsite_config` keys; (b) defer.
- **Why:** guessing an id would ship a section that silently shows the wrong
  articles - an SEO defect worse than an absent page.
- **Revisit if:** category data is loaded, or the owner supplies the mapping.
