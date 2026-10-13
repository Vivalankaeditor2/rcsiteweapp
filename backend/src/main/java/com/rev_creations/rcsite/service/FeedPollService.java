package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.FeedProperties;
import com.rev_creations.rcsite.dto.FeedItemDto;
import com.rev_creations.rcsite.entity.FeedArticle;
import com.rev_creations.rcsite.entity.FeedChannel;
import com.rev_creations.rcsite.entity.FeedChannelLog;
import com.rev_creations.rcsite.repository.FeedArticleRepository;
import com.rev_creations.rcsite.repository.FeedChannelLogRepository;
import com.rev_creations.rcsite.repository.FeedChannelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Polls one {@code feed_channel}: fetch, parse, stage into {@code feed_article}
 * and record the attempt in {@code feed_channel_log}. This is the
 * {@code FeedGenerator}/feed-polling port; items are de-duplicated on the feed's
 * own {@code guid}, so re-polling is idempotent (the legacy job could re-insert).
 *
 * <p>A failed fetch is logged and the channel rescheduled, never thrown, so one
 * dead source cannot stop the sweep (each channel is its own transaction - see
 * {@code FeedScheduler}).
 */
@Service
public class FeedPollService {

    /** The legacy {@code message} column is varchar(200). */
    private static final int MAX_MESSAGE_LENGTH = 200;

    private static final String LOG_LOCATION = "FeedPollService";

    private final FeedChannelRepository channelRepository;

    private final FeedArticleRepository articleRepository;

    private final FeedChannelLogRepository logRepository;

    private final FeedParser parser;

    private final FeedFetchService fetchService;

    private final FeedProperties properties;

    public FeedPollService(FeedChannelRepository channelRepository,
            FeedArticleRepository articleRepository,
            FeedChannelLogRepository logRepository,
            FeedParser parser,
            FeedFetchService fetchService,
            FeedProperties properties) {
        this.channelRepository = channelRepository;
        this.articleRepository = articleRepository;
        this.logRepository = logRepository;
        this.parser = parser;
        this.fetchService = fetchService;
        this.properties = properties;
    }

    /** What one poll did, for the log line and the manual-trigger response. */
    public record PollResult(boolean ok, int fetched, int stored, String message) {
    }

    @Transactional
    public PollResult pollChannel(Long channelId) {
        FeedChannel channel = channelRepository.findById(channelId).orElse(null);
        if (channel == null) {
            return new PollResult(false, 0, 0, "channel " + channelId + " not found");
        }
        FeedFetchService.FetchResult result = fetchService.fetch(channel.getLink());
        if (!result.ok()) {
            log(channel, "ERROR", "fetch failed: " + result.error());
            reschedule(channel);
            return new PollResult(false, 0, 0, result.error());
        }
        List<FeedItemDto> items = parser.parse(result.body());
        int stored = 0;
        int limit = Math.max(1, properties.getMaxItemsPerPoll());
        for (FeedItemDto item : items) {
            if (item.guid() == null || item.guid().isBlank()) {
                continue;
            }
            FeedArticle existing = articleRepository.findByGuid(item.guid()).orElse(null);
            if (existing != null) {
                applyItem(existing, item);
                articleRepository.save(existing);
            } else if (stored < limit) {
                articleRepository.save(newArticle(channel, item));
                stored++;
            }
        }
        reschedule(channel);
        String message = "fetched " + items.size() + ", stored " + stored;
        log(channel, "INFO", message);
        return new PollResult(true, items.size(), stored, message);
    }

    private FeedArticle newArticle(FeedChannel channel, FeedItemDto item) {
        FeedArticle article = new FeedArticle();
        article.setChannelId(channel.getId());
        article.setGuid(item.guid());
        article.setProcessed(1);
        applyItem(article, item);
        return article;
    }

    /** Copies the mutable item fields onto a row (new or already staged). */
    private void applyItem(FeedArticle article, FeedItemDto item) {
        article.setTitle(item.title());
        article.setLink(item.link());
        article.setDescription(item.description());
        article.setDetails(item.details());
        article.setPublished(item.published());
        article.setUpdated(item.updated());
    }

    /**
     * Records the attempt and sets the next due time. The interval uses the
     * channel's {@code poll_interval} when set, else the configured default -
     * the legacy schema does not label the unit, and the config is authoritative
     * for the operator (see {@code AGENTS.md}).
     */
    private void reschedule(FeedChannel channel) {
        LocalDateTime now = LocalDateTime.now();
        channel.setLastPoll(now);
        long minutes = channel.getPollInterval() != null && channel.getPollInterval() > 0
                ? channel.getPollInterval()
                : properties.getDefaultPollIntervalMinutes();
        channel.setNextPoll(now.plusMinutes(minutes));
        channelRepository.save(channel);
    }

    private void log(FeedChannel channel, String severity, String message) {
        FeedChannelLog entry = new FeedChannelLog();
        entry.setChannelId(channel.getId());
        entry.setLogTime(LocalDateTime.now());
        entry.setLocation(LOG_LOCATION);
        entry.setSeverity(severity);
        entry.setMessage(truncate(message));
        logRepository.save(entry);
    }

    private static String truncate(String value) {
        if (value == null || value.length() <= MAX_MESSAGE_LENGTH) {
            return value;
        }
        return value.substring(0, MAX_MESSAGE_LENGTH);
    }
}
