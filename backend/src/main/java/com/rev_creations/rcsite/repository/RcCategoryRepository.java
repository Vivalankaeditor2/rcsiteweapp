package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.RcCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RcCategoryRepository extends JpaRepository<RcCategory, Integer> {
}
