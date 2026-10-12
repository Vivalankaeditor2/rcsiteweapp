package com.rev_creations.rcsite.web;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.service.ArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/articles")
@Tag(name = "Articles", description = "Read access to the articles table")
public class ArticleController {
    private final ArticleService articleService;

    public ArticleController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping("/{articleId}")
    @Operation(summary = "Get one article by article_id")
    public ArticleDto getById(@PathVariable Integer articleId) {
        return articleService.getById(articleId);
    }

    @GetMapping("/by-dcode/{dcode}")
    @Operation(summary = "Get the newest article matching a dcode value")
    public ArticleDto getByDcode(@PathVariable String dcode) {
        return articleService.getByDcode(dcode);
    }
}
