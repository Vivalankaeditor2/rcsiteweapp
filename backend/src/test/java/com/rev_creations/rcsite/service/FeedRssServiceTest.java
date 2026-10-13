package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.FeedProperties;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.dto.PageDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

// Unit test of the RSS renderer: real string generation, the article source
// (the DB edge) mocked. Verifies the frozen link shape (D-003) and the XML
// escaping that keeps the document well formed.
class FeedRssServiceTest {

    private final ArticleService articleService = mock(ArticleService.class);

    private FeedRssService service;

    @BeforeEach
    void setUp() {
        FeedProperties properties = new FeedProperties();
        properties.setRssBaseUrl("https://www.vivalanka.com");
        properties.setRssTitle("VivaLanka.com Sri Lanka Latest News.");
        properties.setRssCategoryId(7);
        properties.setRssItems(10);
        service = new FeedRssService(articleService, properties);
    }

    private static ArticleDto article(Integer id, String dcode, String alias, String title, String description) {
        return new ArticleDto(id, title, description, "body", "i.jpg", "t.jpg", "k", 7,
                "Author", null, LocalDateTime.of(2021, 11, 5, 8, 24, 47),
                LocalDateTime.of(2021, 11, 5, 8, 24, 47), null,
                null, alias, dcode, null);
    }

    @Test
    void defaults_to_category_7_and_renders_the_legacy_link_shape() {
        ArticleDto dto = article(12272011, null, "court-rejects-bail", "Court rejects bail", "Summary");
        when(articleService.listPublished(eq(7), eq(0), eq(10)))
                .thenReturn(new PageDto<>(List.of(dto), 0, 10, 1, 1, false));

        String xml = service.render(null, 0);

        assertThat(xml).contains("<title>VivaLanka.com Sri Lanka Latest News.</title>");
        assertThat(xml).contains("<link>https://www.vivalanka.com/newspage/12272011ai-court-rejects-bail</link>");
        assertThat(xml).contains("<guid isPermaLink=\"false\">https://www.vivalanka.com/newspage/12272011ai-court-rejects-bail</guid>");
        assertThat(xml).contains("<pubDate>Fri, 05 Nov 2021 08:24:47 +0000</pubDate>");
    }

    @Test
    void a_caller_supplied_category_and_count_win_over_the_defaults() {
        when(articleService.listPublished(eq(90), eq(0), eq(5)))
                .thenReturn(new PageDto<>(List.of(), 0, 5, 0, 0, false));

        service.render(90, 5);

        verify(articleService).listPublished(90, 0, 5);
    }

    @Test
    void numeric_dcode_replaces_the_id_in_the_link() {
        ArticleDto dto = article(1, "90012", "alias", "t", "d");
        when(articleService.listPublished(eq(90), eq(0), eq(3)))
                .thenReturn(new PageDto<>(List.of(dto), 0, 3, 1, 1, false));

        String xml = service.render(90, 3);

        assertThat(xml).contains("/newspage/90012ai-alias");
    }

    @Test
    void escapes_titles_and_wraps_the_description_in_cdata() {
        ArticleDto dto = article(2, null, "a", "Tom & Jerry <b>\"quoted\"</b>", "<p>5 > 4 & 3</p>");
        when(articleService.listPublished(eq(7), eq(0), eq(10)))
                .thenReturn(new PageDto<>(List.of(dto), 0, 10, 1, 1, false));

        String xml = service.render(null, 0);

        assertThat(xml).contains("<title>Tom &amp; Jerry &lt;b&gt;&quot;quoted&quot;&lt;/b&gt;</title>");
        assertThat(xml).contains("<![CDATA[<p>5 > 4 & 3</p>]]>");
    }

    @Test
    void a_literal_cdata_close_is_split_so_the_document_stays_well_formed() {
        ArticleDto dto = article(3, null, "a", "t", "ends with ]]> inside");
        when(articleService.listPublished(eq(7), eq(0), eq(10)))
                .thenReturn(new PageDto<>(List.of(dto), 0, 10, 1, 1, false));

        String xml = service.render(null, 0);

        assertThat(xml).contains("]]]]><![CDATA[>");
        assertThat(xml).doesNotContain("]]> inside");
    }
}
