package com.rev_creations.rcsite.mapper;
import com.rev_creations.rcsite.dto.RcSiteConfigDto;
import com.rev_creations.rcsite.entity.RcSiteConfig;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface RcSiteConfigMapper {
    RcSiteConfigDto toDto(RcSiteConfig config);
}
