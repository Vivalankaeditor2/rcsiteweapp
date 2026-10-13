package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.FeedProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

/**
 * Fetches a feed document over HTTP with JDK 11+ {@link HttpClient} (no extra
 * dependency, consistent with the Solr client choice in D-027). A fetch failure
 * is returned as a result rather than thrown, so the poller can log it to
 * {@code feed_channel_log} and move on to the next channel.
 */
@Service
public class FeedFetchService {

    private static final Logger log = LoggerFactory.getLogger(FeedFetchService.class);

    private final FeedProperties properties;

    public FeedFetchService(FeedProperties properties) {
        this.properties = properties;
    }

    /** The outcome of one fetch: either a body, or a reason it failed. */
    public record FetchResult(String body, String error, int status) {
        public boolean ok() {
            return error == null;
        }
    }

    public FetchResult fetch(String url) {
        if (url == null || url.isBlank()) {
            return new FetchResult(null, "no feed link configured", 0);
        }
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofMillis(properties.getConnectTimeoutMs()))
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();
        HttpRequest request;
        try {
            request = HttpRequest.newBuilder(URI.create(url))
                    .timeout(Duration.ofMillis(properties.getReadTimeoutMs()))
                    .header("User-Agent", properties.getUserAgent())
                    .header("Accept", "application/rss+xml, application/atom+xml, application/xml, text/xml, */*")
                    .GET()
                    .build();
        } catch (IllegalArgumentException ex) {
            return new FetchResult(null, "invalid feed url: " + ex.getMessage(), 0);
        }
        try {
            HttpResponse<byte[]> response = client.send(request, HttpResponse.BodyHandlers.ofByteArray());
            int status = response.statusCode();
            if (status < 200 || status >= 300) {
                return new FetchResult(null, "http " + status, status);
            }
            return new FetchResult(new String(response.body(), StandardCharsets.UTF_8), null, status);
        } catch (IOException ex) {
            log.debug("Feed fetch failed for {}: {}", url, ex.getMessage());
            return new FetchResult(null, ex.getClass().getSimpleName() + ": " + ex.getMessage(), 0);
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            return new FetchResult(null, "interrupted", 0);
        }
    }
}
