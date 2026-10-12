package com.rev_creations.rcsite.mapper;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.entity.Article;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ArticleMapper {
    ArticleDto toDto(Article article);
}
