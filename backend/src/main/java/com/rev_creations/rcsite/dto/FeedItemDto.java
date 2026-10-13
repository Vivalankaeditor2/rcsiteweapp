package com.rev_creations.rcsite.dto;

import java.time.LocalDateTime;

/**
 * One item parsed from an RSS 2.0 or Atom document, before it is staged in
 * {@code feed_article}. {@code guid} is the feed's own identity for the item
 * (RSS {@code guid} / Atom {@code id}); it is what de-duplication keys on, so an
 * item without a usable guid is dropped by the parser rather than stored twice.
 */
public record FeedItemDto(
        String guid,
        String title,
        String link,
        String description,
        String details,
        LocalDateTime published,
        LocalDateTime updated) {
}
