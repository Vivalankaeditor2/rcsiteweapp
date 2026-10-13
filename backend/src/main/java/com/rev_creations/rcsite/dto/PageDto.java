package com.rev_creations.rcsite.dto;
import java.util.List;

/**
 * A page of listing items. Spring's {@code Page} is not serialised directly
 * because its JSON shape is unstable; this keeps the API contract explicit.
 * Page numbers are zero-based, matching {@code Pageable}.
 */
public record PageDto<T>(
        List<T> items,
        int page,
        int size,
        long totalItems,
        int totalPages,
        boolean hasNext) {
}
