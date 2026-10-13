package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.dto.AdminCategoryRequest;
import com.rev_creations.rcsite.dto.ArticleCategoryDto;
import com.rev_creations.rcsite.service.ArticleCategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Admin category write surface (Phase 7, ADMIN role via {@code /api/admin/**}). */
@RestController
@RequestMapping("/api/admin/categories")
@Tag(name = "Admin - Categories", description = "Create/update categories (ADMIN)")
public class AdminArticleCategoryController {

    private final ArticleCategoryService service;

    public AdminArticleCategoryController(ArticleCategoryService service) {
        this.service = service;
    }

    @PostMapping
    @Operation(summary = "Create a category")
    public ArticleCategoryDto create(@Valid @RequestBody AdminCategoryRequest request) {
        return service.create(request);
    }

    @PutMapping("/{categoryId}")
    @Operation(summary = "Update a category")
    public ArticleCategoryDto update(@PathVariable Integer categoryId,
            @Valid @RequestBody AdminCategoryRequest request) {
        return service.update(categoryId, request);
    }
}
