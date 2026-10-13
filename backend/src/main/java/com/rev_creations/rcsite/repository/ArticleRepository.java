package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.Article;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Read/write access to the {@code articles} table (D-015: this is the only
 * article table). All access is through derived, parameterised queries (NC-005),
 * never string-concatenated SQL.
 */
@Repository
public interface ArticleRepository extends JpaRepository<Article, Integer> {
    /**
     * Articles whose {@code dcode} matches. {@code dcode} has no unique index,
     * so a list is returned; callers pick the newest.
     */
    List<Article> findByDcodeOrderByArticleIdDesc(String dcode);

    /**
     * Published articles only: an {@code aproval_status} of "4" is not published
     * and 404s, so it must never appear in a sitemap (a listed URL that 404s is
     * an SEO defect). {@code <> '4'} is NULL-safe here by the explicit OR.
     */
    @Query("select count(a) from Article a where a.aprovalStatus is null or a.aprovalStatus <> '4'")
    long countPublished();

    /**
     * A stable, page of published article URLs for sitemap shards, newest first
     * (TASK-PLAN Phase 2). Selecting the projection keeps the scan off the large
     * {@code description}/{@code details} columns; the seek method and binding are
     * supplied by Spring Data.
     */
    @Query("select a.articleId as articleId, a.alias as alias, a.dcode as dcode "
            + "from Article a where a.aprovalStatus is null or a.aprovalStatus <> '4' "
            + "order by a.articleId desc")
    List<ArticleUrlProjection> findSitemapUrls(Limit limit, int offset);

    /**
     * A page of published articles for a listing, newest first. A null
     * {@code categoryId} lists every category. Published-only is the same rule
     * as the sitemap so a listing never links to a URL that 404s. The optional
     * clause keeps a single parameterised query (NC-005) rather than two; the
     * ordering is supplied by the caller's {@code Pageable}.
     */
    @Query("select a from Article a "
            + "where (a.aprovalStatus is null or a.aprovalStatus <> '4') "
            + "and (:categoryId is null or a.categoryId = :categoryId)")
    Page<Article> findPublished(@Param("categoryId") Integer categoryId, Pageable pageable);
}
