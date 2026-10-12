package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.GeoBlock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GeoBlockRepository extends JpaRepository<GeoBlock, Long> {
}
