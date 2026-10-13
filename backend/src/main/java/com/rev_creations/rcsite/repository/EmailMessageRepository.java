package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.EmailMessage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmailMessageRepository extends JpaRepository<EmailMessage, Long> {

    /** The queue, newest first, for the admin listing. */
    Page<EmailMessage> findAllByOrderByEmailIdDesc(Pageable pageable);
}
