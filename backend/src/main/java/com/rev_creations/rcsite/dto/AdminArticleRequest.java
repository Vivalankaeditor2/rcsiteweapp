package com.rev_creations.rcsite.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * Create/update payload for an article. The frozen {@code articles} table is
 * shared (MyISAM, no FKs, latin1 text - D-008); every field maps 1:1 to a column.
 */
public record AdminArticleRequest(
        @NotBlank @Size(max = 500) String title,
        String description,
        String details,
        @Size(max = 500) String image,
        @Size(max = 500) String thumbnail,
        @Size(max = 500) String keywords,
        Integer categoryId,
        @Size(max = 255) String authorName,
        String authorIntro,
        @Size(max = 255) String editorName,
        @Size(max = 255) String editorEmail,
        @Size(max = 20) String aprovalStatus,
        @Size(max = 255) String alias,
        @Size(max = 255) String url,
        @NotNull Boolean publish) {
}
