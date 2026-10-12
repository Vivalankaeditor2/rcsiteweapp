package com.rev_creations.rcsite.dto;
import java.time.LocalDateTime;

/**
 * Public view of one article. Entities are never exposed (claude/api-design);
 * the field set matches what the legacy article page emits.
 */
public record ArticleDto(
        Integer articleId,
        String title,
        String description,
        String details,
        String image,
        String thumbnail,
        String keywords,
        Integer categoryId,
        String authorName,
        String authorIntro,
        LocalDateTime entryDate,
        LocalDateTime published,
        LocalDateTime updated,
        String url,
        String alias,
        String dcode,
        String aprovalStatus) {
}
