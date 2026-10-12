package com.rev_creations.rcsite.mapper;
import com.rev_creations.rcsite.dto.FeedChannelDto;
import com.rev_creations.rcsite.entity.FeedChannel;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface FeedChannelMapper {
    FeedChannelDto toDto(FeedChannel channel);
}
