package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.FeedChannel;
import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface FeedChannelRepository extends JpaRepository<FeedChannel, Long> {

    /**
     * Active channels that are due: never polled or {@code next_poll} has passed.
     * Ordered oldest-due first (a null {@code next_poll} sorts first in the target
     * engines), so a stalled channel is retried before a fresh one.
     */
    @Query("select c from FeedChannel c where c.feedActive = true "
            + "and (c.nextPoll is null or c.nextPoll <= :now) "
            + "order by c.nextPoll asc")
    List<FeedChannel> findDue(@Param("now") LocalDateTime now, Limit limit);
}
