package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.FeedChannelLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeedChannelLogRepository extends JpaRepository<FeedChannelLog, Long> {
}
