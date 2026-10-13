package com.rev_creations.rcsite.dto;

import java.util.List;

/**
 * One Solr hit mapped to the fields the legacy result page rendered
 * ({@code RCSearchFacade} request parameters: id, title, description, url,
 * categoryid, category, thumbnail, lastModified, content, parent_categoryid,
 * start_date, end_date, site, image). {@code lastModified} is kept as the raw
 * Solr timestamp string so the frontend formats it exactly like the legacy
 * page did ({@code SimpleDateFormat("EEEE, MMMM dd, yyyy")}).
 *
 * <p>{@code content} carries the Solr {@code content} field (HTML); the legacy
 * page stripped tags for the excerpt, so the frontend does the same rather than
 * the backend mutating stored content.
 */
public record SearchResultDto(
        String id,
        String title,
        String description,
        String content,
        String url,
        Integer categoryId,
        String category,
        Integer parentCategoryId,
        String thumbnail,
        String image,
        String lastModified,
        String startDate,
        String endDate,
        String site) {

    /** A page of search results; {@code start} is the Solr offset (zero-based). */
    public record SearchPage(
            List<SearchResultDto> items,
            long totalItems,
            int start,
            int rows,
            boolean hasNext,
            boolean available) {
    }
}
