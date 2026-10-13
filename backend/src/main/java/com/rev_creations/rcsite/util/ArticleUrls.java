package com.rev_creations.rcsite.util;

/**
 * Builds the frozen public article URL, mirroring the legacy {@code news/page.jsp}
 * resolver: a numeric {@code dcode} (the legacy "custom" id) replaces the article
 * id, and a null alias falls back to the query form. Shared by the sitemap and
 * the RSS feed so the two can never drift; a 200 must never become a 301 (D-003).
 */
public final class ArticleUrls {

    private ArticleUrls() {
    }

    public static String canonical(String baseUrl, Integer articleId, String dcode, String alias) {
        boolean numericDcode = dcode != null && dcode.matches("\\d+");
        if (numericDcode) {
            return baseUrl + "/newspage/" + dcode + "ai-" + nullToEmpty(alias);
        }
        if (alias != null) {
            return baseUrl + "/newspage/" + articleId + "ai-" + alias;
        }
        return baseUrl + "/news/page.jsp?articleid=" + articleId;
    }

    private static String nullToEmpty(String value) {
        return value == null ? "" : value;
    }
}
