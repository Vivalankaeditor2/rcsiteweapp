package com.rev_creations.rcsite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Search settings. Search is served by the existing Apache Solr (D-011): the
 * backend proxies the legacy {@code /news} request handler rather than
 * migrating engines. The legacy client pointed at
 * {@code https://www.vivalanka.com/rcsearch} and sent {@code qt=/news}; the
 * full endpoint is therefore {@code base-url + request-handler}, which is also
 * the public {@code /rcsearch/news} contract. No credential is involved.
 */
@Component
@ConfigurationProperties(prefix = "rcsite.solr")
public class SolrProperties {

    /** Solr servlet/context base, no trailing slash. */
    private String baseUrl = "https://www.vivalanka.com/rcsearch";

    /** Legacy request handler selected with {@code qt}. */
    private String requestHandler = "/news";

    /** Default number of rows when the caller does not ask for a specific size. */
    private int rows = 20;

    /** Upper bound on rows, so one request cannot ask Solr for an unbounded page. */
    private int maxRows = 100;

    /** Connect timeout; a down Solr must fail fast, not hang the request. */
    private int connectTimeoutMs = 1000;

    /** Read timeout for the Solr query. */
    private int readTimeoutMs = 3000;

    /** When true, a Solr failure returns an empty result instead of an error. */
    private boolean failOpen = true;

    /** The full request-handler endpoint the backend calls. */
    public String getEndpoint() {
        String base = baseUrl == null ? "" : baseUrl.replaceAll("/+$", "");
        String handler = requestHandler == null ? "" : requestHandler;
        if (!handler.isEmpty() && !handler.startsWith("/")) {
            handler = "/" + handler;
        }
        return base + handler;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getRequestHandler() {
        return requestHandler;
    }

    public void setRequestHandler(String requestHandler) {
        this.requestHandler = requestHandler;
    }

    public int getRows() {
        return rows;
    }

    public void setRows(int rows) {
        this.rows = rows;
    }

    public int getMaxRows() {
        return maxRows;
    }

    public void setMaxRows(int maxRows) {
        this.maxRows = maxRows;
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

    public boolean isFailOpen() {
        return failOpen;
    }

    public void setFailOpen(boolean failOpen) {
        this.failOpen = failOpen;
    }
}
