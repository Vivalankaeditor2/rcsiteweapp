package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.AdminCategoryRequest;
import com.rev_creations.rcsite.dto.ArticleCategoryDto;
import com.rev_creations.rcsite.entity.ArticleCategory;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.ArticleCategoryMapper;
import com.rev_creations.rcsite.repository.ArticleCategoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/** Category reads plus the Phase 7 admin write path. */
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

    @Transactional
    public ArticleCategoryDto create(AdminCategoryRequest request) {
        ArticleCategory category = new ArticleCategory();
        apply(category, request);
        return mapper.toDto(repository.save(category));
    }

    @Transactional
    public ArticleCategoryDto update(Integer categoryId, AdminCategoryRequest request) {
        ArticleCategory category = repository.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("No category with id " + categoryId));
        apply(category, request);
        return mapper.toDto(repository.save(category));
    }

    /**
     * The table is latin1 (D-008), so {@code active} is stored as it is in the
     * legacy data - a one-character flag, never invented here.
     */
    private void apply(ArticleCategory category, AdminCategoryRequest request) {
        category.setCategoryName(request.categoryName());
        category.setTitle(request.title());
        category.setDescription(request.description());
        category.setParentId(request.parentId());
        category.setLevel(request.level());
        category.setPriority(request.priority());
        category.setActive(request.active());
    }
}
