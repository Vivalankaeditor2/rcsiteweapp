# frontend/public

Static assets served from the site root.

- `robots.txt` — mirrors production (see `URL-INVENTORY.md`); points at
  `/sitemapindex.xml`.

`/sitemapindex.xml` and `/sitemap_{n}.xml` are **not** static files — the backend
generates them from `articles` at request time (D-020, D-025). They must keep the
legacy names because the live shards are the crawled/submitted URLs
(~204 shards, ~2M URLs).
