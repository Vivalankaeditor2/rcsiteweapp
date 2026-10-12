package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.ReadmeEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReadmeEntryRepository extends JpaRepository<ReadmeEntry, Integer> {
}
