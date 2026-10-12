package com.rev_creations.rcsite.dto;
public record ArticleCategoryDto(
        Integer categoryId,
        Integer parentId,
        String categoryName,
        String title,
        String description,
        String level,
        Integer priority,
        String active) {
}
