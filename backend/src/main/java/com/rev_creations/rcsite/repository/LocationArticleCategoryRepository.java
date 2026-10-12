package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.LocationArticleCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LocationArticleCategoryRepository extends JpaRepository<LocationArticleCategory, Long> {
}
