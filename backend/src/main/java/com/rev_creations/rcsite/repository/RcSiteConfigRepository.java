package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.RcSiteConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RcSiteConfigRepository extends JpaRepository<RcSiteConfig, String> {
}
