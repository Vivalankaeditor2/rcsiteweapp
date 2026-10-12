package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.WebUi;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WebUiRepository extends JpaRepository<WebUi, Long> {
}
