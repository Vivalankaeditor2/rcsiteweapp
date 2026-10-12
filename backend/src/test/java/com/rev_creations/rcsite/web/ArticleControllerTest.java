package com.rev_creations.rcsite.web;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.service.ArticleService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
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
    private ArticleDto sample(int id, String dcode) {
        return new ArticleDto(id, "Sample", "desc", "details", "img.jpg", "thumb.jpg",
                "kw", 3, "Author", "intro", null, null, null, "url", "alias", dcode, "1");
    }
}