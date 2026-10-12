package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.EmailReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmailReportRepository extends JpaRepository<EmailReport, Long> {
}
