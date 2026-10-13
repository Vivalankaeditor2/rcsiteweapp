package com.rev_creations.rcsite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Sitemap generation settings. The base URL is the canonical host the legacy
 * page used ({@code Config.getValue("wwwUrl")}, e.g. https://www.vivalanka.com).
 * It is not present in the local seed data, so it is configurable with a
 * production-safe default; no credential or secret is involved (D-005).
 */
@Component
@ConfigurationProperties(prefix = "rcsite.sitemap")
public class SitemapProperties {

    /** Canonical scheme+host, no trailing slash. */
    private String baseUrl = "https://www.vivalanka.com";

    /** URLs per shard; the legacy shards held ~10k. */
    private int shardSize = 10000;

    /** Upper bound on advertised shards (legacy index listed 204). */
    private int maxShards = 204;

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public int getShardSize() {
        return shardSize;
    }

    public void setShardSize(int shardSize) {
        this.shardSize = shardSize;
    }

    public int getMaxShards() {
        return maxShards;
    }

    public void setMaxShards(int maxShards) {
        this.maxShards = maxShards;
    }
}
