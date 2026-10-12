package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.entity.Article;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.ArticleMapper;
import com.rev_creations.rcsite.repository.ArticleRepository;
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
}
