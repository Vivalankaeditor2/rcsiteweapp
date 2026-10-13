package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.dto.AdminArticleRequest;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.dto.PageDto;
import com.rev_creations.rcsite.service.ArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Admin article surface (Phase 7). Secured by the {@code /api/admin/**} rule in
 * {@link com.rev_creations.rcsite.config.SecurityConfig} (ADMIN role). Writes
 * only to the frozen {@code articles} table - the schema is unchanged
 * (D-004/D-008).
 */
@RestController
@RequestMapping("/api/admin/articles")
@Validated
@Tag(name = "Admin - Articles", description = "List/create/update/publish articles (ADMIN)")
public class AdminArticleController {

    private final ArticleService articleService;

    public AdminArticleController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping
    @Operation(summary = "List every article (published or hidden), newest first")
    public PageDto<ArticleDto> list(
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size) {
        return articleService.listForAdmin(categoryId, page, size);
    }

    @PostMapping
    @Operation(summary = "Create an article")
    public ArticleDto create(@Valid @RequestBody AdminArticleRequest request) {
        return articleService.create(request);
    }

    @PutMapping("/{articleId}")
    @Operation(summary = "Update an article")
    public ArticleDto update(@PathVariable Integer articleId,
            @Valid @RequestBody AdminArticleRequest request) {
        return articleService.update(articleId, request);
    }

    @PutMapping("/{articleId}/publish")
    @Operation(summary = "Publish or hide an article")
    public ArticleDto setPublished(@PathVariable Integer articleId,
            @RequestParam(defaultValue = "true") boolean published) {
        return articleService.setPublished(articleId, published);
    }
}
