package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.SitemapProperties;
import com.rev_creations.rcsite.repository.ArticleRepository;
import com.rev_creations.rcsite.repository.ArticleUrlProjection;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Limit;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

// Unit test of sitemap generation. The repository (the DB boundary) is mocked;
// the URL shapes and shard arithmetic are the real code paths under test.
class SitemapServiceTest {

    private ArticleRepository repository;

    private SitemapProperties properties;

    private SitemapService service;

    @BeforeEach
    void setUp() {
        repository = mock(ArticleRepository.class);
        properties = new SitemapProperties();
        service = new SitemapService(repository, properties);
    }

    private ArticleUrlProjection projection(Integer id, String alias, String dcode) {
        return new ArticleUrlProjection() {
            @Override
            public Integer getArticleId() {
                return id;
            }

            @Override
            public String getAlias() {
                return alias;
            }

            @Override
            public String getDcode() {
                return dcode;
            }
        };
    }

    @Test
    void index_lists_one_shard_per_shard_size_page() {
        when(repository.countPublished()).thenReturn(25000L);
        String xml = service.renderIndex();
        assertThat(xml).contains("<sitemapindex");
        assertThat(xml).contains("<loc>https://www.vivalanka.com/sitemap_1.xml</loc>");
        assertThat(xml).contains("<loc>https://www.vivalanka.com/sitemap_3.xml</loc>");
        assertThat(xml).doesNotContain("sitemap_4.xml");
    }

    @Test
    void index_is_capped_at_max_shards() {
        when(repository.countPublished()).thenReturn(100_000_000L);
        assertThat(service.getShardCount()).isEqualTo(properties.getMaxShards());
    }

    @Test
    void shard_emits_canonical_url_for_legacy_article() {
        when(repository.findSitemapUrls(any(Limit.class), eq(0)))
                .thenReturn(List.of(projection(12272011, "court-rejects-shiranthi-s-bail-application", "hosted")));
        String xml = service.renderShard(1);
        assertThat(xml).contains(
                "<loc>https://www.vivalanka.com/newspage/12272011ai-court-rejects-shiranthi-s-bail-application</loc>");
    }

    @Test
    void numeric_dcode_replaces_the_id() {
        when(repository.findSitemapUrls(any(Limit.class), eq(0)))
                .thenReturn(List.of(projection(500, "some-slug", "12272011")));
        assertThat(service.renderShard(1))
                .contains("<loc>https://www.vivalanka.com/newspage/12272011ai-some-slug</loc>");
    }

    @Test
    void null_alias_falls_back_to_query_form() {
        when(repository.findSitemapUrls(any(Limit.class), eq(0)))
                .thenReturn(List.of(projection(2036, null, null)));
        assertThat(service.renderShard(1))
                .contains("<loc>https://www.vivalanka.com/news/page.jsp?articleid=2036</loc>");
    }

    @Test
    void empty_alias_renders_path_with_trailing_ai_dash() {
        when(repository.findSitemapUrls(any(Limit.class), eq(0)))
                .thenReturn(List.of(projection(12247832, "", "hosted")));
        assertThat(service.renderShard(1))
                .contains("<loc>https://www.vivalanka.com/newspage/12247832ai-</loc>");
    }

    @Test
    void shard_offset_is_page_index_times_size() {
        properties.setShardSize(10000);
        when(repository.findSitemapUrls(any(Limit.class), eq(10000))).thenReturn(List.of());
        service.renderShard(2);
        org.mockito.Mockito.verify(repository).findSitemapUrls(any(Limit.class), eq(10000));
    }
}
