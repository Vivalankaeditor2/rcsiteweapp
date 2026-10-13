package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.SitemapProperties;
import com.rev_creations.rcsite.repository.ArticleRepository;
import com.rev_creations.rcsite.repository.ArticleUrlProjection;
import com.rev_creations.rcsite.util.ArticleUrls;
import org.springframework.data.domain.Limit;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Builds the sitemap XML from {@code articles} at request time (D-020, D-025).
 * Shard names and the canonical URL shape are frozen by the legacy contract
 * (see {@code URL-INVENTORY.md}); a 200 must never become a 301 (D-003).
 *
 * <p>Shard {@code n} serves a stable, offset-based page of the id-ordered table
 * ({@code ORDER BY article_id}), so a shard URL always returns the same set as
 * articles are added.
 */
@Service
public class SitemapService {

    private static final String INDEX_HEADER =
            "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                    + "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";

    private static final String URLSET_HEADER =
            "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                    + "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";

    private final ArticleRepository articleRepository;

    private final SitemapProperties properties;

    public SitemapService(ArticleRepository articleRepository, SitemapProperties properties) {
        this.articleRepository = articleRepository;
        this.properties = properties;
    }

    /** Number of shards the index advertises, capped by the configured maximum. */
    @Transactional(readOnly = true)
    public int getShardCount() {
        long total = articleRepository.countPublished();
        long needed = (total + properties.getShardSize() - 1) / properties.getShardSize();
        if (needed < 1) {
            return 1;
        }
        return (int) Math.min(needed, properties.getMaxShards());
    }

    @Transactional(readOnly = true)
    public String renderIndex() {
        StringBuilder xml = new StringBuilder(INDEX_HEADER);
        for (int n = 1; n <= getShardCount(); n++) {
            xml.append("  <sitemap>\n")
                    .append("    <loc>").append(properties.getBaseUrl())
                    .append("/sitemap_").append(n).append(".xml</loc>\n")
                    .append("  </sitemap>\n");
        }
        return xml.append("</sitemapindex>\n").toString();
    }

    @Transactional(readOnly = true)
    public String renderShard(int shardNumber) {
        int offset = (shardNumber - 1) * properties.getShardSize();
        List<ArticleUrlProjection> urls = articleRepository.findSitemapUrls(
                Limit.of(properties.getShardSize()), offset);
        StringBuilder xml = new StringBuilder(URLSET_HEADER);
        for (ArticleUrlProjection article : urls) {
            xml.append("  <url>\n")
                    .append("    <loc>").append(canonicalUrl(article)).append("</loc>\n")
                    .append("  </url>\n");
        }
        return xml.append("</urlset>\n").toString();
    }

    /**
     * The canonical article URL, mirroring {@code news/page.jsp}: a numeric
     * {@code dcode} replaces the id; a null alias falls back to the query form.
     * Shared with the RSS feed so the two cannot drift (D-003).
     */
    private String canonicalUrl(ArticleUrlProjection article) {
        return ArticleUrls.canonical(properties.getBaseUrl(), article.getArticleId(),
                article.getDcode(), article.getAlias());
    }
}
