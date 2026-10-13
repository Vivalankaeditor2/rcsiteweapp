package com.rev_creations.rcsite.repository;

/**
 * Narrow projection over {@code articles} for sitemap generation. Only the
 * columns needed to build a canonical URL are read, so a full-table scan for
 * the ~2M indexed URLs never materialises entities (D-020).
 */
public interface ArticleUrlProjection {
    Integer getArticleId();

    String getAlias();

    String getDcode();
}
