package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.DirectoryEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DirectoryEntryRepository extends JpaRepository<DirectoryEntry, Integer> {
}
