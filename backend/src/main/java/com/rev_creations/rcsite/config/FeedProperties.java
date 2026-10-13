package com.rev_creations.rcsite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Feed ingestion (the {@code FeedGenerator}/{@code SearchUpdater} port) and the
 * RSS output (the {@code GenerateRSS}/{@code FeedGenerator} port).
 *
 * <p>The scheduler polls {@code feed_channel} rows that are active and due,
 * stages raw items in {@code feed_article} and records each attempt in
 * {@code feed_channel_log} - the three tables the legacy jobs wrote. No
 * credential is involved; see D-023.
 */
@Component
@ConfigurationProperties(prefix = "rcsite.feed")
public class FeedProperties {

    /** Master switch for the polling scheduler. Off in tests. */
    private boolean schedulerEnabled = true;

    /** How often the scheduler looks for due channels. */
    private long pollDelayMs = 60000;

    /** Connect timeout for a feed fetch; a dead source must fail fast. */
    private int connectTimeoutMs = 5000;

    /** Read timeout for a feed fetch. */
    private int readTimeoutMs = 10000;

    /** Hard cap on items stored from one poll, so a huge feed cannot flood the table. */
    private int maxItemsPerPoll = 200;

    /** Sent as the fetch User-Agent (some sources 403 an empty one). */
    private String userAgent = "VivaLankaFeedPoller/1.0";

    /** Fallback poll interval (minutes) when a channel has none configured. */
    private long defaultPollIntervalMinutes = 60;

    /** Number of due channels handled per scheduler tick. */
    private int batchSize = 20;

    /** RSS title, from the legacy FeedGenerator. */
    private String rssTitle = "VivaLanka.com Sri Lanka Latest News.";

    /** RSS description, from the legacy FeedGenerator. */
    private String rssDescription = "Current and up to date news and events for global Sri Lankan community.";

    /** RSS copyright, from the legacy FeedGenerator. */
    private String rssCopyright = "Copyright 2010 VivaLanka.com";

    /** Absolute host the feed links and self-reference are built from. */
    private String rssBaseUrl = "https://www.vivalanka.com";

    /** Items in the feed when the caller does not ask for a specific count. */
    private int rssItems = 10;

    /**
     * Default category for the feed, matching the legacy {@code FeedGenerator}
     * default of 7. A null value emits every published category.
     */
    private Integer rssCategoryId = 7;

    public boolean isSchedulerEnabled() {
        return schedulerEnabled;
    }

    public void setSchedulerEnabled(boolean schedulerEnabled) {
        this.schedulerEnabled = schedulerEnabled;
    }

    public long getPollDelayMs() {
        return pollDelayMs;
    }

    public void setPollDelayMs(long pollDelayMs) {
        this.pollDelayMs = pollDelayMs;
    }

    public int getConnectTimeoutMs() {
        return connectTimeoutMs;
    }

    public void setConnectTimeoutMs(int connectTimeoutMs) {
        this.connectTimeoutMs = connectTimeoutMs;
    }

    public int getReadTimeoutMs() {
        return readTimeoutMs;
    }

    public void setReadTimeoutMs(int readTimeoutMs) {
        this.readTimeoutMs = readTimeoutMs;
    }

    public int getMaxItemsPerPoll() {
        return maxItemsPerPoll;
    }

    public void setMaxItemsPerPoll(int maxItemsPerPoll) {
        this.maxItemsPerPoll = maxItemsPerPoll;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public long getDefaultPollIntervalMinutes() {
        return defaultPollIntervalMinutes;
    }

    public void setDefaultPollIntervalMinutes(long defaultPollIntervalMinutes) {
        this.defaultPollIntervalMinutes = defaultPollIntervalMinutes;
    }

    public int getBatchSize() {
        return batchSize;
    }

    public void setBatchSize(int batchSize) {
        this.batchSize = batchSize;
    }

    public String getRssTitle() {
        return rssTitle;
    }

    public void setRssTitle(String rssTitle) {
        this.rssTitle = rssTitle;
    }

    public String getRssDescription() {
        return rssDescription;
    }

    public void setRssDescription(String rssDescription) {
        this.rssDescription = rssDescription;
    }

    public String getRssCopyright() {
        return rssCopyright;
    }

    public void setRssCopyright(String rssCopyright) {
        this.rssCopyright = rssCopyright;
    }

    public String getRssBaseUrl() {
        return rssBaseUrl;
    }

    public void setRssBaseUrl(String rssBaseUrl) {
        this.rssBaseUrl = rssBaseUrl;
    }

    public int getRssItems() {
        return rssItems;
    }

    public void setRssItems(int rssItems) {
        this.rssItems = rssItems;
    }

    public Integer getRssCategoryId() {
        return rssCategoryId;
    }

    public void setRssCategoryId(Integer rssCategoryId) {
        this.rssCategoryId = rssCategoryId;
    }
}
