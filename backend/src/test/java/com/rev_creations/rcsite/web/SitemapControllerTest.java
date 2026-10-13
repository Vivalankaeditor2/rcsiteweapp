package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.service.SitemapService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// Web-layer test: the real controller keeps the legacy sitemap paths at 200.
@WebMvcTest(SitemapController.class)
class SitemapControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SitemapService sitemapService;

    @Test
    void should_serve_sitemap_index_at_legacy_path() throws Exception {
        when(sitemapService.renderIndex()).thenReturn(
                "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                        + "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
                        + "  <sitemap>\n    <loc>https://www.vivalanka.com/sitemap_1.xml</loc>\n  </sitemap>\n"
                        + "</sitemapindex>\n");
        mockMvc.perform(get("/sitemapindex.xml"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith("application/xml"))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("<sitemapindex")));
    }

    @Test
    void should_serve_the_secondary_index_path() throws Exception {
        when(sitemapService.renderIndex()).thenReturn("<sitemapindex/>");
        mockMvc.perform(get("/sitemapindex04302022.xml"))
                .andExpect(status().isOk());
    }

    @Test
    void should_serve_a_shard_within_range() throws Exception {
        when(sitemapService.getShardCount()).thenReturn(204);
        when(sitemapService.renderShard(1)).thenReturn(
                "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                        + "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
                        + "<url><loc>https://www.vivalanka.com/newspage/1ai-a</loc></url>\n</urlset>");
        mockMvc.perform(get("/sitemap_1.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>")));
    }

    @Test
    void should_return_404_for_out_of_range_shard() throws Exception {
        when(sitemapService.getShardCount()).thenReturn(204);
        mockMvc.perform(get("/sitemap_9999.xml"))
                .andExpect(status().isNotFound());
    }
}
