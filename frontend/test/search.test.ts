import { test } from "node:test";
import assert from "node:assert/strict";

import type { SearchResultDto } from "../src/lib/search";
import {
  formatSolrDate,
  isAllowedBot,
  searchExcerpt,
  searchResultHref,
  searchResultImage,
} from "../src/lib/search";

function result(overrides: Partial<SearchResultDto> = {}): SearchResultDto {
  return {
    id: "12272011",
    title: "Court Rejects Shiranthi's Bail Application",
    description: "A short description",
    content: "<p>Body</p>",
    url: "/newspage/12272011ai-court",
    categoryId: 90,
    category: "Local",
    parentCategoryId: 7,
    thumbnail: "./custom/thumb.jpg",
    image: null,
    lastModified: "2021-11-05T08:24:47Z",
    startDate: null,
    endDate: null,
    site: "web",
    ...overrides,
  };
}

test("isAllowedBot admits the search crawlers and refuses browsers", () => {
  assert.equal(isAllowedBot("Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"), true);
  assert.equal(isAllowedBot("Mozilla/5.0 (compatible; bingbot/2.0)"), true);
  assert.equal(isAllowedBot("DuckDuckBot/1.0"), true);
  assert.equal(isAllowedBot("Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120"), false);
  assert.equal(isAllowedBot(null), false);
});

test("formatSolrDate renders the legacy 'EEEE, MMMM dd, yyyy' shape", () => {
  // 2021-11-05 was a Friday.
  assert.equal(formatSolrDate("2021-11-05T08:24:47Z"), "Friday, November 05, 2021");
  assert.equal(formatSolrDate("2011-12-20T00:00:00Z"), "Tuesday, December 20, 2011");
  assert.equal(formatSolrDate(null), "");
  assert.equal(formatSolrDate("not-a-date"), "");
});

test("searchExcerpt strips tags and truncates past 400 characters", () => {
  assert.equal(searchExcerpt(result({ description: "<p>Hello <b>world</b></p>" })), "Hello world");
  const long = "x".repeat(450);
  assert.equal(searchExcerpt(result({ description: long })), `${"x".repeat(400)}...`);
  // Falls back to the content field when the description is empty.
  assert.equal(searchExcerpt(result({ description: "", content: "<p>from content</p>" })), "from content");
});

test("searchResultHref keeps internal legacy paths and passes external urls through", () => {
  assert.equal(searchResultHref(result()), "/newspage/12272011ai-court");
  assert.equal(searchResultHref(result({ url: "newspage/1ai-x" })), "/newspage/1ai-x");
  assert.equal(searchResultHref(result({ url: "https://example.com/x" })), "https://example.com/x");
  assert.equal(searchResultHref(result({ url: null })), "/news/page.jsp?articleid=12272011");
});

test("searchResultImage normalises the legacy './custom' path", () => {
  assert.equal(searchResultImage(result()), "/custom/thumb.jpg");
  assert.equal(searchResultImage(result({ thumbnail: null, image: "/custom/pic.jpg" })), "/custom/pic.jpg");
  assert.equal(searchResultImage(result({ thumbnail: null, image: "https://cdn.example.com/p.jpg" })), "https://cdn.example.com/p.jpg");
  assert.equal(searchResultImage(result({ thumbnail: null, image: null })), null);
});
