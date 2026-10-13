package com.rev_creations.rcsite.mapper;

import com.rev_creations.rcsite.dto.EmailMessageDto;
import com.rev_creations.rcsite.entity.EmailMessage;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface EmailMessageMapper {
    EmailMessageDto toDto(EmailMessage email);
}
