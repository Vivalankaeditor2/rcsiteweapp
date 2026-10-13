# ARTICLES-HANDLING.md

**Duty:** MyISAM rules, URL options and the SEO strategy for articles.

Companion to `TASK-PLAN.md`. Explains three things the owner asked about:
the MyISAM reality, the URL rules (with options), and the SEO strategy.

---

## 1. The MyISAM reality — explained plainly

**What MyISAM is.** MariaDB can store a table in different "engines". The two
common ones are InnoDB and MyISAM. This database is almost all **MyISAM**.

**What you lose with MyISAM (and why it matters):**

| Thing | InnoDB | MyISAM (ours) |
|---|---|---|
| Transactions (BEGIN/ROLLBACK) | Yes | **No** |
| Foreign keys enforced | Yes | **No** (declared nowhere, enforced nowhere) |
| Locking when writing | Row-level (others keep working) | **Whole table** (everyone waits) |
| Crash recovery | Good | Weaker; can need repair |
| `COUNT(*)` on 12M rows | Slower | Fast |

**Why this matters for `articles` (12.3M rows):**

1. **A write locks the whole table.** If the feed ingester inserts 500 rows, then
   during that insert **every** public read of `articles` waits. On a busy news
   site that is a visible stall.
2. **`@Transactional` gives false comfort.** In Java it *looks* atomic, but on
   MyISAM a failure part-way through leaves **half the rows written** — there is
   no rollback. The code must not assume "all or nothing".
3. **JPA relationships are a trap.** There are no foreign keys, so
   `@ManyToOne(category)` will not be validated and can silently point at nothing.
   `save()` cascades can also update tables you did not mean to touch.

**The rules we will follow (recorded in Phase 1, D-008):**

- `spring.jpa.hibernate.ddl-auto=none` — never let Hibernate change the schema.
- Model `categoryid` / `feed_channel_id` as **plain number fields**, not JPA
  relationships, and join manually. (No FKs exist, so don't pretend.)
- Read-only paths use `@Immutable` / DTO projections. Mark MyISAM entities
  read-only unless writing is required.
- Writes are **single, small, self-contained statements**. No multi-table
  "transaction" that expects a rollback.
- Feed ingest: **small batches, off-peak, with lock-wait monitoring**; never one
  giant insert.

**Options for the write path** (owner already chose *stay MyISAM forever*):

| Option | Verdict |
|---|---|
| A. Keep MyISAM; disciplined small single-row writes + monitoring | **Chosen** (D-008, D-017) |
| B. Convert `articles` to InnoDB | Rejected by owner; big risk on 12M rows |
| C. Write into a small queue table, drain in batches | Possible later if stalls appear |
| D. `INSERT` with long lock waits | Avoid |

---

## 2. URL rules — recommendations

Show the case, the legacy behaviour, and the recommended action. Options are given
where a real choice exists.

| Case | Legacy behaviour | Recommendation | Options |
|---|---|---|---|
| `dcode` numeric | URL uses `dcode` instead of `article_id` | **Keep** — 200, canonical uses `dcode` | (a) keep, (b) 301 to `article_id` (loses equity — avoid) |
| `dcode` not numeric, e.g. `hosted` (our sample) | Uses `article_id` | **Keep** — canonical `/newspage/12272011ai-{alias}` | (a) keep, (b) 301 to a numeric form (avoid) |
| `dcode` contains `_short` | Body = description, HTML stripped | **Keep** | (a) keep, (b) 301 to full article (only if a full article exists) |
| `dcode` contains `hosted` | Listing link stays internal | **Keep** | (a) keep, (b) link externally |
| No `alias` | Link = `/news/page.jsp?articleid={id}` | **Keep** as a 200 rewrite to the article page | (a) rewrite (200), (b) 301 to `/newspage/...` (SEO risk) |
| `aproval_status = '4'` | Not published | **404 (or 410)** | (a) 404, (b) 410 Gone, (c) 301 to category — recommend (a)/(b) |
| Trailing slash / extra segment | `substring(10, indexOf("ai-"))` can misparse | **Prefix-based parse**, reject unknown shapes with 404 | (a) strict 404, (b) redirect to clean URL |
| URL has `?` query noise | Ignored | Serve 200 with canonical to the clean path | (a) canonical only, (b) 301 strip (avoid) |
| Non-existent id | Legacy error page | **404** with correct status (never soft-200) | — |
| Article moved/deleted | Legacy may still 200 | **410 Gone** after a grace period | — |
| Case/percent-encoding | Loose | Match the exact alias bytes; do not lowercase | — |

**Golden rules:** never change a URI path; never turn a 200 into a 301 (except an
agreed cleanup); always emit the canonical; never soft-200 a missing page.

---

## 3. SEO strategy — is "traditional" still worth it in the AI era?

**Short answer: yes — the traditional foundations matter *more* now, not less.**
Google still ranks on indexed URLs, real content, and page experience. The "AI
era" changed *how content is produced*, not *how crawling and ranking work*.

**What actually drives ranking for a news site today:**

1. **The URL keeps its identity** — a preserved, unique URL with a stable
   canonical is the single biggest lever. This is why D-003 exists.
2. **Core Web Vitals** (LCP, INP, CLS) — a fast, stable page beats a slow one.
   Next.js SSR + `next/image` + caching directly improve these.
3. **Structured data (JSON-LD)** — `NewsArticle`, `BreadcrumbList`, `Organization`.
   Rich results come from this, not from extra prose.
4. **Crawlable discovery** — `robots.txt`, XML sitemap, RSS, fast server responses.
5. **Freshness + internal links** — updated dates, category links, related items.
6. **`hreflang`** for Sinhala/Tamil/English variants.
7. **Search Console** — submit the sitemap; watch coverage and CWV reports.

**Where "AI" helps (and where it does not):**

- ✅ **Editorial aid** — drafting, translation, tagging, meta-description
  suggestions *reviewed by a human*. (Note: the owner dropped AI from this project,
  D-010 — so not in scope.)
- ❌ **Runtime AI tricks** — stuffing auto-generated keyword text into pages adds
  no ranking benefit and hurts UX and CWV.
- ❌ **Do not chase** "AI optimised" URLs or cloaking — risky and against
  Google's guidelines.

**Options considered:**

| Option | Verdict |
|---|---|
| A. Keep + extend traditional SEO (recommended) | **Chosen** (D-010b) |
| B. AI-generated on-page SEO layer | Rejected — no ranking benefit, UX/CWV cost |
| C. Traditional + `llms.txt` / answer-engine hints | Optional add-on in Phase 2 if wanted |

**Concrete deliverables** (already in the plan): the real index at
`/sitemapindex.xml` (→ `/sitemap_{n}.xml` shards) + `robots.txt`
(added now, below), canonical + meta implementation in Phase 2, JSON-LD in
Phase 2, `hreflang` when the language variants are confirmed, CWV gate in Phase 3,
Search Console in Phase 8.

---

## 4. `sitemapindex.xml` and `robots.txt`

Added:

- `frontend/public/robots.txt` - mirrors production (D-020); points at `/sitemapindex.xml`.
- The **index and shards are generated by the backend**, not static files:
  `/sitemapindex.xml` -> `/sitemap_{n}.xml` (legacy names, D-025), newest first.
  XML limit is 50,000 URLs / 50 MB per file, so shards carry ~10,047 URLs each.

---

## 5. `article_category_has_articles` — code (D-019)

The owner said "write code for this". The code we want for a table the news app
must **not** touch is a **guard**: it fails the build if anyone references it.

Built:

- `backend/src/test/java/com/rev_creations/rcsite/architecture/ForbiddenTableUsageTest.java`
  — a JUnit 5 test that walks `src/main` and fails if the table name appears.
- `tools/check-forbidden-tables.ps1` — the same check for CI, covering the
  backend, frontend and legacy trees.

Verified: the script reports **PASS** on a clean tree, and **FAILS** (exit 1) when
a file referencing the table is planted — then PASS again after cleanup.

Add an exception only with a new owner-approved decision (do not weaken the guard
silently).

---

## 6. Correction to an earlier note

The sample article `12272011` has **`dcode = "hosted"`**, i.e. a **non-numeric**
`dcode`. So the canonical stays `/newspage/12272011ai-{alias}` (using
`article_id`); `hosted` keeps listing links internal. A numeric `dcode` is still
supported (it would replace `article_id`) — see D-018.
