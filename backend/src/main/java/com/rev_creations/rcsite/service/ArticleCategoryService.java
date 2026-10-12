package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.ArticleCategoryDto;
import com.rev_creations.rcsite.mapper.ArticleCategoryMapper;
import com.rev_creations.rcsite.repository.ArticleCategoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class ArticleCategoryService {
    private final ArticleCategoryRepository repository;

    private final ArticleCategoryMapper mapper;

    public ArticleCategoryService(ArticleCategoryRepository repository, ArticleCategoryMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Transactional(readOnly = true)
    public List<ArticleCategoryDto> listAll() {
        return repository.findAll().stream().map(mapper::toDto).toList();
    }
}
