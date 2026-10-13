package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.FeedChannelLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FeedChannelLogRepository extends JpaRepository<FeedChannelLog, Long> {

    /** Newest-first log for one channel (the admin log view). */
    List<FeedChannelLog> findByChannelIdOrderByLogTimeDesc(Long channelId);
}
