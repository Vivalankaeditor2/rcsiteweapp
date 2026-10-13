package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.dto.PageDto;
import com.rev_creations.rcsite.entity.Article;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.ArticleMapper;
import com.rev_creations.rcsite.repository.ArticleRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * Read access to articles. Lookups use derived queries only (NC-005) and the
 * {@code articles} table only (D-015).
 */
@Service
public class ArticleService {
    private final ArticleRepository articleRepository;

    private final ArticleMapper articleMapper;

    public ArticleService(ArticleRepository articleRepository, ArticleMapper articleMapper) {
        this.articleRepository = articleRepository;
        this.articleMapper = articleMapper;
    }

    @Transactional(readOnly = true)
    public ArticleDto getById(Integer articleId) {
        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new ResourceNotFoundException("No article with id " + articleId));
        return articleMapper.toDto(article);
    }

    /**
     * Look up by {@code dcode}. The column is not unique, so the newest match
     * wins. A {@code dcode} that is purely numeric is the same key space as
     * {@code article_id}; callers decide which to pass.
     */
    @Transactional(readOnly = true)
    public ArticleDto getByDcode(String dcode) {
        List<Article> matches = articleRepository.findByDcodeOrderByArticleIdDesc(dcode);
        if (matches.isEmpty()) {
            throw new ResourceNotFoundException("No article with dcode " + dcode);
        }
        return articleMapper.toDto(matches.get(0));
    }

    /**
     * A page of published articles for a listing, newest first. {@code
     * categoryId} may be null to list every category. Only published articles
     * are returned, so a listing never links to a URL that 404s.
     */
    @Transactional(readOnly = true)
    public PageDto<ArticleDto> listPublished(Integer categoryId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "articleId"));
        Page<Article> result = articleRepository.findPublished(categoryId, pageable);
        List<ArticleDto> items = result.getContent().stream().map(articleMapper::toDto).toList();
        return new PageDto<>(items, result.getNumber(), result.getSize(),
                result.getTotalElements(), result.getTotalPages(), result.hasNext());
    }
}
