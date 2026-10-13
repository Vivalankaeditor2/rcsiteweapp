package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.dto.SearchResultDto;
import com.rev_creations.rcsite.dto.SearchResultDto.SearchPage;
import com.rev_creations.rcsite.service.RcSiteConfigService;
import com.rev_creations.rcsite.service.SearchService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// Web-layer test: real Spring MVC + the unified error handler, search mocked.
@WebMvcTest(SearchController.class)
@AutoConfigureMockMvc(addFilters = false)
class SearchControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SearchService searchService;

    @MockBean
    private RcSiteConfigService configService;

    private static SearchResultDto sample() {
        return new SearchResultDto("12272011", "Court rejects bail", "d", "c", "/newspage/12272011ai-",
                90, "Local", 7, "t.jpg", "i.jpg", "2021-11-05T08:24:47Z", null, null, "web");
    }

    @Test
    void should_return_200_and_page_shape() throws Exception {
        when(searchService.search(eq("bail"), isNull(), eq(0), isNull()))
                .thenReturn(new SearchPage(List.of(sample()), 1, 0, 20, false, true));

        mockMvc.perform(get("/api/search").param("q", "bail"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items.length()").value(1))
                .andExpect(jsonPath("$.items[0].id").value("12272011"))
                .andExpect(jsonPath("$.items[0].categoryId").value(90))
                .andExpect(jsonPath("$.available").value(true));
    }

    @Test
    void should_pass_a_comma_separated_category_filter_through() throws Exception {
        when(searchService.search(isNull(), eq("2,3,5,6"), eq(0), isNull()))
                .thenReturn(new SearchPage(List.of(), 0, 0, 20, false, true));

        mockMvc.perform(get("/api/search").param("categoryId", "2,3,5,6"))
                .andExpect(status().isOk());
    }

    @Test
    void should_use_the_legacy_categorylimit_search_config_when_rows_absent() throws Exception {
        when(configService.getValue("categorylimit.search.17")).thenReturn(Optional.of("10"));
        when(searchService.findByCategory(eq("17"), eq(true), eq(0), eq(10)))
                .thenReturn(new SearchPage(List.of(sample()), 1, 0, 10, false, true));

        mockMvc.perform(get("/api/search/category/17"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.rows").value(10));
    }

    @Test
    void should_return_400_when_category_is_not_numeric() throws Exception {
        mockMvc.perform(get("/api/search").param("categoryId", "7 OR 1=1"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400));
    }

    @Test
    void should_return_400_when_start_is_negative() throws Exception {
        mockMvc.perform(get("/api/search").param("start", "-1"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400));
    }

    @Test
    void should_accept_the_legacy_local_category_literal() throws Exception {
        when(searchService.findByCategory(eq("local"), eq(true), eq(0), isNull()))
                .thenReturn(new SearchPage(List.of(), 0, 0, 20, false, true));

        mockMvc.perform(get("/api/search/category/local"))
                .andExpect(status().isOk());
    }
}
