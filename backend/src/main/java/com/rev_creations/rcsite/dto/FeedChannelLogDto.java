package com.rev_creations.rcsite.dto;

import java.time.LocalDateTime;

/** Public view of one {@code feed_channel_log} row (poll outcomes and errors). */
public record FeedChannelLogDto(
        Long id,
        Long channelId,
        LocalDateTime logTime,
        String location,
        String severity,
        String message,
        String trace) {
}
