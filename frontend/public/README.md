# frontend/public

Static assets served from the site root.

- `robots.txt` — byte-identical mirror of production (captured 2026-10-10, see
  `tools/legacy-capture/robots.txt` and `URL-INVENTORY.md`); points at
  `/sitemapindex.xml` and `/sitemapindex04302022.xml`.

`/sitemapindex.xml`, `/sitemapindex04302022.xml` and `/sitemap_{n}.xml` are **not**
static files — the backend generates them from `articles` at request time
(D-020, D-025). They must keep the legacy names because the live shards are the
crawled/submitted URLs (~204 shards, ~2M URLs). `next.config.mjs` rewrites these
paths to the Spring Boot backend.
