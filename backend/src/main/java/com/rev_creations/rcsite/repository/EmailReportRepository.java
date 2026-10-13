package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.EmailReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EmailReportRepository extends JpaRepository<EmailReport, Long> {

    /** Send results for one queued email, newest first. */
    List<EmailReport> findByEmailIdOrderByReportIdDesc(Long emailId);
}
