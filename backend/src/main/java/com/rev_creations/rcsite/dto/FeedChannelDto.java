package com.rev_creations.rcsite.dto;
import java.time.LocalDateTime;

public record FeedChannelDto(
        Long id,
        String name,
        String link,
        Boolean feedActive,
        String feedType,
        String sourceSite,
        Long defaultCategoryId,
        LocalDateTime nextPoll,
        LocalDateTime lastPoll,
        String comment) {
}
