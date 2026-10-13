package com.rev_creations.rcsite.mapper;

import com.rev_creations.rcsite.dto.FeedChannelLogDto;
import com.rev_creations.rcsite.entity.FeedChannelLog;
import org.springframework.stereotype.Component;

/** Maps the {@code feed_channel_log} entity to its public view (no entity is exposed). */
@Component
public class FeedChannelLogMapper {

    public FeedChannelLogDto toDto(FeedChannelLog entity) {
        return new FeedChannelLogDto(
                entity.getId(),
                entity.getChannelId(),
                entity.getLogTime(),
                entity.getLocation(),
                entity.getSeverity(),
                entity.getMessage(),
                entity.getTrace());
    }
}
