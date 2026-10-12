package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.Article;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Read/write access to the {@code articles} table (D-015: this is the only
 * article table). All access is through derived, parameterised queries (NC-005),
 * never string-concatenated SQL.
 */
@Repository
public interface ArticleRepository extends JpaRepository<Article, Integer> {
    /**
     * Articles whose {@code dcode} matches. {@code dcode} has no unique index,
     * so a list is returned; callers pick the newest.
     */
    List<Article> findByDcodeOrderByArticleIdDesc(String dcode);
}
