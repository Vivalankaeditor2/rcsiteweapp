package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.FeedProperties;
import com.rev_creations.rcsite.entity.FeedChannel;
import com.rev_creations.rcsite.repository.FeedChannelRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Limit;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * The scheduled sweep that replaces the legacy {@code FeedGenerator} timer: on a
 * fixed delay it asks for the active, due channels and polls each one. Each
 * channel is polled in its own transaction ({@code FeedPollService.pollChannel}),
 * so one bad feed cannot roll back the others.
 *
 * <p>Disabled with {@code rcsite.feed.scheduler-enabled=false} (the test profile
 * does this); nothing else in the app depends on it running.
 */
@Service
public class FeedScheduler {

    private static final Logger log = LoggerFactory.getLogger(FeedScheduler.class);

    private final FeedChannelRepository channelRepository;

    private final FeedPollService pollService;

    private final FeedProperties properties;

    public FeedScheduler(FeedChannelRepository channelRepository,
            FeedPollService pollService,
            FeedProperties properties) {
        this.channelRepository = channelRepository;
        this.pollService = pollService;
        this.properties = properties;
    }

    @Scheduled(fixedDelayString = "${rcsite.feed.poll-delay-ms:60000}", initialDelayString = "30000")
    public void pollDueChannels() {
        if (!properties.isSchedulerEnabled()) {
            return;
        }
        List<FeedChannel> due = channelRepository.findDue(LocalDateTime.now(),
                Limit.of(Math.max(1, properties.getBatchSize())));
        for (FeedChannel channel : due) {
            try {
                FeedPollService.PollResult result = pollService.pollChannel(channel.getId());
                log.info("Feed channel {} ({}): {}", channel.getId(), channel.getName(), result.message());
            } catch (RuntimeException ex) {
                // Keep the sweep alive; the next channel is still polled.
                log.warn("Feed channel {} failed: {}", channel.getId(), ex.getMessage());
            }
        }
    }
}
