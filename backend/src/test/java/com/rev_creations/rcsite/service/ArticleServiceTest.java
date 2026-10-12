package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.entity.Article;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.ArticleMapper;
import com.rev_creations.rcsite.repository.ArticleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import java.util.List;
import java.util.Optional;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

// Unit test of the article read paths. The repository (the DB boundary) is
// mocked; the real MapStruct mapper is exercised.
class ArticleServiceTest {
    private ArticleRepository repository;

    private ArticleService service;

    @BeforeEach
    void setUp() {
        repository = mock(ArticleRepository.class);
        service = new ArticleService(repository, Mappers.getMapper(ArticleMapper.class));
    }

    private Article article(int id, String dcode) {
        Article a = new Article();
        a.setArticleId(id);
        a.setDcode(dcode);
        a.setTitle("t" + id);
        return a;
    }

    @Test
    void should_return_article_when_id_exists() {
        when(repository.findById(12272011)).thenReturn(Optional.of(article(12272011, "hosted")));
        ArticleDto dto = service.getById(12272011);
        assertThat(dto.articleId()).isEqualTo(12272011);
        assertThat(dto.dcode()).isEqualTo("hosted");
    }

    @Test
    void should_throw_when_id_missing() {
        when(repository.findById(1)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.getById(1))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void should_return_newest_when_multiple_dcode_matches() {
        when(repository.findByDcodeOrderByArticleIdDesc("news-1"))
                .thenReturn(List.of(article(200, "news-1"), article(100, "news-1")));
        ArticleDto dto = service.getByDcode("news-1");
        assertThat(dto.articleId()).isEqualTo(200);
    }

    @Test
    void should_throw_when_dcode_missing() {
        when(repository.findByDcodeOrderByArticleIdDesc("nope")).thenReturn(List.of());
        assertThatThrownBy(() -> service.getByDcode("nope"))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
