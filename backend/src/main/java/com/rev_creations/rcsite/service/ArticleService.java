package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.dto.AdminArticleRequest;
import com.rev_creations.rcsite.dto.PageDto;
import com.rev_creations.rcsite.entity.Article;
import com.rev_creations.rcsite.exception.ConflictException;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.ArticleMapper;
import com.rev_creations.rcsite.repository.ArticleRepository;
import com.rev_creations.rcsite.util.ArticleAlias;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Read access to articles, plus the Phase 7 admin write path. Lookups use
 * derived queries only (NC-005) and the {@code articles} table only (D-015).
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

    /**
     * A page of <em>every</em> article, published or hidden, for the admin
     * listing (Phase 7). The public listing stays published-only so it never
     * links to a hidden row; an editor needs to see hidden rows to re-publish.
     */
    @Transactional(readOnly = true)
    public PageDto<ArticleDto> listForAdmin(Integer categoryId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "articleId"));
        Page<Article> result = articleRepository.findAllForAdmin(categoryId, pageable);
        List<ArticleDto> items = result.getContent().stream().map(articleMapper::toDto).toList();
        return new PageDto<>(items, result.getNumber(), result.getSize(),
                result.getTotalElements(), result.getTotalPages(), result.hasNext());
    }

    /**
     * Create an article (admin, Phase 7). {@code aproval_status} is inherited
     * from the legacy editor: {@code "1"} is published, {@code "4"} is hidden -
     * the public read path treats anything except {@code "4"} as live (D-003).
     * {@code entry_date} is set by the database default and never written here.
     */
    @Transactional
    public ArticleDto create(AdminArticleRequest request) {
        Article article = new Article();
        apply(article, request);
        LocalDateTime now = LocalDateTime.now();
        article.setPublished(now);
        article.setUpdated(now);
        return articleMapper.toDto(articleRepository.save(article));
    }

    /** Update an existing article (admin, Phase 7). */
    @Transactional
    public ArticleDto update(Integer articleId, AdminArticleRequest request) {
        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new ResourceNotFoundException("No article with id " + articleId));
        apply(article, request);
        article.setUpdated(LocalDateTime.now());
        return articleMapper.toDto(articleRepository.save(article));
    }

    /** Publish or hide an article (admin, Phase 7): {@code "1"} live, {@code "4"} hidden. */
    @Transactional
    public ArticleDto setPublished(Integer articleId, boolean published) {
        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new ResourceNotFoundException("No article with id " + articleId));
        article.setAprovalStatus(published ? "1" : "4");
        article.setUpdated(LocalDateTime.now());
        return articleMapper.toDto(articleRepository.save(article));
    }

    private void apply(Article article, AdminArticleRequest request) {
        String alias = (request.alias() == null || request.alias().isBlank())
                ? ArticleAlias.fromTitle(request.title())
                : ArticleAlias.fromTitle(request.alias());
        requireUniqueAlias(alias, article.getArticleId());
        article.setTitle(request.title());
        article.setDescription(request.description());
        article.setDetails(request.details());
        article.setImage(request.image());
        article.setThumbnail(request.thumbnail());
        article.setKeywords(request.keywords());
        article.setCategoryId(request.categoryId());
        article.setAuthorName(request.authorName());
        article.setAuthorIntro(request.authorIntro());
        article.setEditorName(request.editorName());
        article.setEditorEmail(request.editorEmail());
        article.setAlias(alias);
        article.setUrl(request.url());
        article.setAprovalStatus(request.publish() ? "1" : "4");
    }

    /**
     * The alias is embedded in the frozen article URL, so two articles sharing
     * one would collide on the public path. Reject a clash with a 409 rather
     * than silently overwrite the other article's URL.
     */
    private void requireUniqueAlias(String alias, Integer selfId) {
        if (alias == null) {
            return;
        }
        boolean takenByAnother = articleRepository.findByAliasOrderByArticleIdDesc(alias).stream()
                .anyMatch(existing -> selfId == null || !existing.getArticleId().equals(selfId));
        if (takenByAnother) {
            throw new ConflictException("Alias '" + alias + "' is already used by another article");
        }
    }
}
