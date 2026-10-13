package com.rev_creations.rcsite.web;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.dto.PageDto;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.service.ArticleService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import java.util.List;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
// Web-layer test: real Spring MVC + the unified error handler, service mocked.
@WebMvcTest(ArticleController.class)
class ArticleControllerTest {
    @Autowired
    private MockMvc mockMvc;
    @MockBean
    private ArticleService articleService;
    @Test
    void should_return_200_and_body_when_article_exists() throws Exception {
        when(articleService.getById(12272011)).thenReturn(sample(12272011, "hosted"));
        mockMvc.perform(get("/api/articles/12272011"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.articleId").value(12272011))
                .andExpect(jsonPath("$.dcode").value("hosted"))
                .andExpect(jsonPath("$.title").value("Sample"));
    }
    @Test
    void should_return_404_error_body_when_article_missing() throws Exception {
        when(articleService.getById(anyInt()))
                .thenThrow(new ResourceNotFoundException("No article with id 999"));
        mockMvc.perform(get("/api/articles/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value("No article with id 999"));
    }
    @Test
    void should_return_200_when_looking_up_by_dcode() throws Exception {
        when(articleService.getByDcode(eq("news-1"))).thenReturn(sample(7, "news-1"));
        mockMvc.perform(get("/api/articles/by-dcode/news-1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.articleId").value(7));
    }
    @Test
    void should_return_200_and_page_shape_when_listing() throws Exception {
        when(articleService.listPublished(isNull(), eq(0), eq(20)))
                .thenReturn(new PageDto<>(List.of(sample(200, "hosted"), sample(100, "hosted")),
                        0, 20, 42, 3, true));
        mockMvc.perform(get("/api/articles"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items.length()").value(2))
                .andExpect(jsonPath("$.items[0].articleId").value(200))
                .andExpect(jsonPath("$.totalItems").value(42))
                .andExpect(jsonPath("$.hasNext").value(true));
    }
    @Test
    void should_pass_the_category_filter_through() throws Exception {
        when(articleService.listPublished(eq(90), eq(0), eq(5)))
                .thenReturn(new PageDto<>(List.of(sample(9, "hosted")), 0, 5, 1, 1, false));
        mockMvc.perform(get("/api/articles").param("categoryId", "90")
                        .param("page", "0").param("size", "5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items[0].articleId").value(9));
    }
    @Test
    void should_return_400_when_size_is_out_of_range() throws Exception {
        mockMvc.perform(get("/api/articles").param("size", "0"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400));
    }
    private ArticleDto sample(int id, String dcode) {
        return new ArticleDto(id, "Sample", "desc", "details", "img.jpg", "thumb.jpg",
                "kw", 3, "Author", "intro", null, null, null, "url", "alias", dcode, "1");
    }
}