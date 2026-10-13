package com.rev_creations.rcsite.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Create/update payload for an article category ({@code article_category}). */
public record AdminCategoryRequest(
        @NotBlank @Size(max = 255) String categoryName,
        @Size(max = 255) String title,
        String description,
        Integer parentId,
        @Size(max = 20) String level,
        Integer priority,
        @Size(max = 1) String active) {
}
