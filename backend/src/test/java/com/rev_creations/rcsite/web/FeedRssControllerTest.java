package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.service.FeedRssService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// Web-layer test: real Spring MVC and content negotiation; the RSS renderer is
// mocked. Confirms the public path and the RSS content type.
@WebMvcTest(FeedRssController.class)
@AutoConfigureMockMvc(addFilters = false)
class FeedRssControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private FeedRssService rssService;

    @Test
    void should_return_the_feed_at_the_public_path() throws Exception {
        when(rssService.render(isNull(), eq(0))).thenReturn("<?xml version=\"1.0\"?><rss></rss>");

        mockMvc.perform(get("/api/rss"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith("application/rss+xml"))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("<rss>")));
    }

    @Test
    void should_pass_category_and_items_through() throws Exception {
        when(rssService.render(eq(90), eq(5))).thenReturn("<rss/>");

        mockMvc.perform(get("/api/rss?categoryid=90&items=5"))
                .andExpect(status().isOk());
    }

    @Test
    void should_reject_an_out_of_range_items_value() throws Exception {
        mockMvc.perform(get("/api/rss?items=5000"))
                .andExpect(status().isBadRequest());
    }
}
