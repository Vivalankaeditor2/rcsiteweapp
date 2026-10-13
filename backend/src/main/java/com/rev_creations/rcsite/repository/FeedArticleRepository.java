package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.FeedArticle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface FeedArticleRepository extends JpaRepository<FeedArticle, Long> {

    /** Dedupe on the feed's own {@code guid}; a re-poll never stores the same item twice. */
    Optional<FeedArticle> findByGuid(String guid);
}
