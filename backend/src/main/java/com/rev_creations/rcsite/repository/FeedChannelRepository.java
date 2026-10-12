package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.FeedChannel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeedChannelRepository extends JpaRepository<FeedChannel, Long> {
}
