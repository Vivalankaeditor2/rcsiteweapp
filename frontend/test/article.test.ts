import { test } from "node:test";
import assert from "node:assert/strict";

import type { ArticleDto } from "../src/lib/api";
import {
  articleHref,
  bodyDetails,
  canonicalUrl,
  imageSrc,
  isNumericId,
  isPublished,
  listingLink,
  metaDescription,
  parseMobileSlug,
  parseNewsPageSlug,
  shortenString,
} from "../src/lib/article";
import { articleHeadTags } from "../src/lib/metadata";
import { formatDate } from "../src/lib/format";

function article(overrides: Partial<ArticleDto> = {}): ArticleDto {
  return {
    articleId: 12272011,
    title: "Court Rejects Shiranthi's Bail Application",
    description: "<p>Some <b>description</b>&nbsp;text</p>",
    details: "<p>Full body</p>",
    image: "./custom/images/pic.jpg",
    thumbnail: null,
    keywords: "k1,k2",
    categoryId: 3,
    authorName: "Reporter",
    authorIntro: "intro",
    entryDate: null,
    published: null,
    updated: null,
    url: null,
    alias: "court-rejects-shiranthi-s-bail-application",
    dcode: "hosted",
    aprovalStatus: "1",
    ...overrides,
  };
}

test("isNumericId mirrors the legacy 1-9 digit rule", () => {
  assert.equal(isNumericId("12272011"), true);
  assert.equal(isNumericId("0"), true);
  assert.equal(isNumericId("1234567890"), false, "10 digits is out of range");
  assert.equal(isNumericId("12a"), false);
  assert.equal(isNumericId(""), false);
  assert.equal(isNumericId(null), false);
});

test("parseNewsPageSlug splits the id and alias at ai-", () => {
  assert.deepEqual(
    parseNewsPageSlug("12272011ai-court-rejects-shiranthi-s-bail-application"),
    { id: 12272011, alias: "court-rejects-shiranthi-s-bail-application" },
  );
  assert.deepEqual(parseNewsPageSlug("12247832ai-"), { id: 12247832, alias: "" });
  const dashAlias = "-".repeat(22);
  assert.deepEqual(parseNewsPageSlug(`12247828ai-${dashAlias}`), {
    id: 12247828,
    alias: dashAlias,
  });
  assert.equal(parseNewsPageSlug("12272011"), null, "missing ai- marker");
  assert.equal(parseNewsPageSlug("12aai-x"), null, "non-numeric id");
});

test("parseMobileSlug uses the ci- marker", () => {
  assert.deepEqual(parseMobileSlug("12272011ci-some-slug"), { id: 12272011, alias: "some-slug" });
  assert.equal(parseMobileSlug("12272011ai-x"), null);
});

test("shortenString strips tags, decodes nbsp and cuts at the legacy boundary", () => {
  assert.equal(shortenString("<p>Hello</p>", 150), "Hello");
  assert.equal(shortenString("a&nbsp;b", 150), "a b");
  const long = "x".repeat(200);
  assert.equal(shortenString(long, 150).length, 149, "over-length cut is length-1");
  assert.equal(shortenString(null, 150), "");
});

test("metaDescription is the tag-stripped description truncated to 150", () => {
  const desc = metaDescription(article());
  assert.equal(desc, "Some description text");
});

test("canonicalUrl is the legacy /newspage/{id}ai-{alias}", () => {
  assert.equal(
    canonicalUrl(article()),
    "https://www.vivalanka.com/newspage/12272011ai-court-rejects-shiranthi-s-bail-application",
  );
});

test("canonicalUrl lets a numeric dcode replace the id segment", () => {
  assert.equal(
    canonicalUrl(article({ articleId: 500, dcode: "12272011" })),
    "https://www.vivalanka.com/newspage/12272011ai-court-rejects-shiranthi-s-bail-application",
  );
});

test("canonicalUrl falls back to the query form when the alias is null", () => {
  assert.equal(
    canonicalUrl(article({ articleId: 2036, alias: null, dcode: "hosted" })),
    "https://www.vivalanka.com/news/page.jsp?articleid=2036",
  );
});

test("bodyDetails uses the tag-stripped description for a _short dcode", () => {
  // Legacy _short only strips tags; it does not decode &nbsp; (unlike shortenString).
  assert.equal(bodyDetails(article({ dcode: "news_short" })), "Some description&nbsp;text");
  assert.equal(bodyDetails(article({ dcode: "hosted" })), "<p>Full body</p>");
});

test("isPublished rejects approval status 4 and missing articles", () => {
  assert.equal(isPublished(article({ aprovalStatus: "4" })), false);
  assert.equal(isPublished(article({ aprovalStatus: "1" })), true);
  assert.equal(isPublished(null), false);
});

test("listingLink keeps a hosted article internal even with an external url", () => {
  assert.equal(
    listingLink(article({ url: "https://external.example/story", dcode: "hosted" })),
    "https://www.vivalanka.com/newspage/12272011ai-court-rejects-shiranthi-s-bail-application",
  );
});

test("listingLink uses a short external url when the article is not hosted", () => {
  assert.equal(
    listingLink(article({ url: "https://external.example/story", dcode: "news" })),
    "https://external.example/story",
  );
});

test("articleHeadTags emits the legacy head with a byte-identical canonical", () => {
  const head = articleHeadTags(article());
  assert.match(
    head,
    /<link rel="canonical" href="https:\/\/www\.vivalanka\.com\/newspage\/12272011ai-court-rejects-shiranthi-s-bail-application" \/>/,
  );
  assert.match(
    head,
    /<meta property="og:url" content="https:\/\/www\.vivalanka\.com\/newspage\/12272011ai-court-rejects-shiranthi-s-bail-application" \/>/,
  );
  assert.match(head, /<meta name="Description" content="Some description text" \/>/);
  assert.match(head, /<title>Court Rejects Shiranthi's Bail Application<\/title>/);
});

test("articleHref is the canonical path without the host", () => {
  assert.equal(
    articleHref(article()),
    "/newspage/12272011ai-court-rejects-shiranthi-s-bail-application",
  );
  assert.equal(
    articleHref(article({ articleId: 2036, alias: null, dcode: "hosted" })),
    "/news/page.jsp?articleid=2036",
  );
});

test("imageSrc resolves stored ./custom paths from the site root", () => {
  assert.equal(imageSrc(article({ image: "./custom/images/pic.jpg" })), "/custom/images/pic.jpg");
  assert.equal(imageSrc(article({ image: "/custom/media3/a.png" })), "/custom/media3/a.png");
  assert.equal(imageSrc(article({ image: "custom/images/pic.jpg" })), "/custom/images/pic.jpg");
  assert.equal(
    imageSrc(article({ image: "https://cdn.example/pic.jpg" })),
    "https://cdn.example/pic.jpg",
  );
  assert.equal(
    imageSrc(article({ image: null, thumbnail: null })),
    "/custom/template_files/vivalankalogo.png",
  );
});

test("formatDate reads the wall-clock components without a timezone shift", () => {
  assert.equal(formatDate("2011-12-20 12:20:11"), "Dec 20, 2011");
  assert.equal(formatDate("2011-12-20T00:30:00"), "Dec 20, 2011");
  assert.equal(formatDate("2026-01-01T23:00:00"), "Jan 1, 2026");
  assert.equal(formatDate(null), "");
  assert.equal(formatDate("not-a-date"), "");
});
