# DATABASE.md

**Duty:** the data dictionary - one entry per table, plus the DB rules.

Data dictionary - one entry per table. This schema is fixed (D-004); if a
change is ever approved, update this dictionary in the same step - the two must
never drift.

## Rules

- **Engine:** MariaDB 10.6.16 (`5.5.5-10.6.16-MariaDB-log`), server `10.170.1.6`.
  Database name: **`vivalanka`**. Dump: MySQL 8.0.44 `mysqldump`
  (`rcsiteweb/db/dbschema.sql`).
- **Table engine:** mixed — mostly **MyISAM**, a few InnoDB
  (`rcsite_config`, `readme`, `articles2`, `feed_channel_log`). MyISAM has **no
  transactions and no foreign keys**, with table-level locking. This shapes how
  the new JPA layer must behave. **Do not convert engines without owner approval.**
- **Charsets:** mixed — `utf8mb3` (legacy 3-byte UTF-8) and `latin1`. `utf8mb3`
  cannot store 4-byte characters (emoji, some script marks). Leave as-is unless
  approved.
- **Migrations:** none. The schema is fixed and owner-provided (D-004, D-008). Load `rcsiteweb/db/dbschema.sql` (DDL) as-is, then the seed files. No migration tool, no versioned migrations, and no schema drift.
  The legacy `rcsiteweb/db/001–016` files are **seed data (`INSERT` only)**;
  `rcsiteweb/db/dbschema.sql` is the **DDL**. Versioned files only; never edit an
  applied migration.
- **Schema changes:** none without owner approval (D-004, D-008).
- **Naming:** snake_case; `_id`/`id` keys as they already exist; repeating values
  in lookup tables.

## Content tables — decided

**Only `articles` is used.** The owner confirmed `articles2` and `articles3`
are **not required** and hold **no live articles** — they are **ignored**
(do not build entities, mappers, or lookups for them). This removes the earlier
content-split risk (Q3 closed).

| Table | Engine | Rows (AUTO_INCREMENT) | Decision |
|---|---|---|---|
| `articles` | MyISAM | 12,330,553 | **The** article table. Used everywhere. |
| `articles3` | MyISAM | 12,107,816 | Ignored. |
| `articles2` | InnoDB | 39 | Ignored. |

### articles
- **Writable:** news app **writes** here (admin publish, feed ingest).
- **MyISAM forever** (owner, Q13/Q14) ⇒ no transactions, table-level locking.
  Write paths must be single-statement or accept non-atomic behaviour.

## Table dictionary (31 tables)

**Content**

### articles
- **Duty:** one row is one news article (main content table).
- **Key:** PK `article_id`.
- **Columns:** `article_id`, `title`, `description`, `image`, `details`,
  `author_name`, `author_intro`, `entry_date`, `published`, `updated`,
  `aproval_status`, `editor_name`, `editor_email`, `categoryid`, `dcode`, `url`,
  `feed_channel_id`, `process_status`, `alias`, `thumbnail`, `keywords`.
- **Indexes:** `categoryid`, `aproval_status`, `entry_date`, `process_status`,
  `feed_channel_id`. **No unique index on `alias` or `dcode`.**
- **Joins:** `categoryid` → `article_category.categoryid`;
  `feed_channel_id` → `feed_channel.id`.
- **Rules:** `aproval_status = '4'` means not published. `dcode` is a free-form
  string — numeric, or containing `_short` / `hosted`, or a full URL. `description`
  and `details` are `text` (64 KB cap) here but `longtext` in `articles2/3`.
- **URL rule:** canonical `/newspage/{dcode|article_id}ai-{alias}` — numeric
  `dcode` wins; no alias ⇒ `/news/page.jsp?articleid={id}`. Listing links may
  point straight at `url` (external) unless `dcode` contains `hosted`.

### articles2, articles3
- **Ignored.** Owner confirmed they hold no live articles and are not required.
  Do not build entities for them.

### article_category
- **Duty:** one row is one article category (113 seeded).
- **Key:** PK `categoryid` (int unsigned, AUTO_INCREMENT=113).
- **Columns:** `categoryid`, `parentid`, `category_name`, `title`, `description`,
  `level`, `priority`, `active`.
- **Joins:** `parentid` → `article_category.categoryid` (self, hierarchy).
- **Note:** engine MyISAM, **charset latin1** — check before storing non-ASCII.

### article_category_has_articles
- **Duty:** many-to-many link between categories and articles. Composite PK
  (`categoryid`, `article_id`); AUTO_INCREMENT=12,330,553.
- **Note:** **not referenced anywhere in this codebase** — used by another app
  (likely the Solr indexer / commerce). Confirm before relying on it.

### article_category_has_feed_channel
- **Duty:** many-to-many link between categories and feed channels. Composite PK
  (`category_id`, `channel_id`).

**Feeds**

### feed_channel
- **Duty:** one row is one external feed the site polls.
- **Key:** PK `id`. **Charset latin1.**
- **Columns:** `id`, `name`, `link`, `poll_interval`, `feed_active`, `feed_type`,
  `poll_interval_min`, `poll_interval_max`, `source_site`, `next_poll`,
  `last_poll`, `default_category_id`, `comment`.
- **Joins:** `default_category_id` → `article_category.categoryid`.

### feed_article
- **Duty:** one row is one raw item pulled from a feed (staging before it becomes
  an article). Key PK `id`; `channel_id` → `feed_channel.id`; has `processed`.

### feed_channel_log
- **Duty:** feed poll log/errors. PK `id`; `channel_id` → `feed_channel.id`.

**Geolocation**

### geo_location
- **Duty:** MaxMind GeoIP location rows. **No primary key** — indexed on
  `country`, `region`, `location_id`.
### geo_blocks
- **Duty:** IP-range → location mapping. PK `start_ip_num`; `loc_id` → `geo_location`.
### location_article_category
- **Duty:** maps a location to the categories to show there. PK `id`;
  `category_id` → `article_category.categoryid`; `location_id` → `geo_location`.

**Users / staff**

### rc_customer
- **Duty:** site user / login. PK `username`. Has `pword varchar(20)`,
  `customer` (unique), `type`, `consultant`, `email`. **Security: `pword` is 20
  chars — verify it is properly hashed (see CAPA NC-006).**

### usertype
- **Duty:** lookup of user roles. PK `usertypeid`, `usertypename`.

### preferences
- **Duty:** per-user preferences. PK `entryid`, unique `username`.

**Site configuration / misc**

### rcsite_config
- **Duty:** one row is one site setting (drives all `Config.getValue(...)` keys).
- **Key:** PK `config_key` (varchar 100). InnoDB.
- **Columns:** `config_key`, `value`, `description`, `site_area`, `active`,
  `hot_configurable`.

### email, email_report
- **Duty:** outbound email queue (`email`, PK `emailid`) and its send results
  (`email_report`, PK `reportid`, `emailid` → `email.emailid`).

### directory, rc_category, readme, webui
- **directory** — submitted link directory (PK `link_id`).
- **rc_category** — user-submitted categories (PK `category_id`).
- **readme** / **webui** — small config/content tables.

**Commerce — OUT OF SCOPE (dropped, D-009)**

`customers`, `orders`, `order_items`, `order_charges`, `products`,
`product_categories`, `product_options`, `product_attributes`, `prodxcat`.

These are the legacy `rccommerce` storefront. Not part of the revamp. Leave the
tables untouched; do not build code against them.