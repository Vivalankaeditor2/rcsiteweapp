package com.rev_creations.rcsite.mapper;
import com.rev_creations.rcsite.dto.ArticleCategoryDto;
import com.rev_creations.rcsite.entity.ArticleCategory;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ArticleCategoryMapper {
    ArticleCategoryDto toDto(ArticleCategory category);
}
