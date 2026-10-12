package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.ArticleCategoryFeedChannel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ArticleCategoryFeedChannelRepository
        extends JpaRepository<ArticleCategoryFeedChannel, ArticleCategoryFeedChannel.Key> {
}
