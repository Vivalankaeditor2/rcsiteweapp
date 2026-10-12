package com.rev_creations.rcsite.web;
import com.rev_creations.rcsite.dto.ArticleCategoryDto;
import com.rev_creations.rcsite.service.ArticleCategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/categories")
@Tag(name = "Categories", description = "Read access to the article_category table")
public class ArticleCategoryController {
    private final ArticleCategoryService service;

    public ArticleCategoryController(ArticleCategoryService service) {
        this.service = service;
    }

    @GetMapping
    @Operation(summary = "List all article categories")
    public List<ArticleCategoryDto> listAll() {
        return service.listAll();
    }
}
