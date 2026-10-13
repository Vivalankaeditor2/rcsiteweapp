package com.rev_creations.rcsite.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.rev_creations.rcsite.config.SolrProperties;
import com.rev_creations.rcsite.dto.SearchResultDto;
import com.rev_creations.rcsite.dto.SearchResultDto.SearchPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;

/**
 * Proxies search to the existing Apache Solr (D-011) instead of owning an index.
 *
 * <p>The legacy path is preserved: a category listing sends
 * {@code qt=/news} with {@code fq=parent_categoryid:{id}} (a category page) or
 * {@code fq=categoryid:{id}} (a single category) and a row limit, and the
 * response is the legacy {@code fl} field set. Legacy
 * {@code categorylimit.search.*} keys are honoured; if none is present the
 * configured default row count is used.
 *
 * <p>Solr is an external dependency that may be down. Failing open (an empty
 * result with {@code available=false}) keeps every page rendering instead of
 * turning a search outage into a site-wide error; set
 * {@code rcsite.solr.fail-open=false} to surface the failure as 503 instead.
 */
@Service
public class SearchService {

    private static final Logger log = LoggerFactory.getLogger(SearchService.class);

    /** The legacy {@code fl} field list, kept byte-for-byte for faithful output. */
    static final String FIELDS = "id,title,description,url,categoryid,category,thumbnail,"
            + "lastModified,content,parent_categoryid,start_date,end_date,site,image";

    private final SolrProperties properties;

    private final RestClient restClient;

    public SearchService(SolrProperties properties) {
        this.properties = properties;
        this.restClient = buildClient(properties);
    }

    private static RestClient buildClient(SolrProperties properties) {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(properties.getConnectTimeoutMs());
        factory.setReadTimeout(properties.getReadTimeoutMs());
        return RestClient.builder().requestFactory(factory).build();
    }

    /**
     * Full-text search restricted to {@code categoryIds} (a Solr OR list, as the
     * legacy {@code (2,3,5,6)} filter did) via {@code fq=categoryid:...}.
     * {@code q} is optional; when blank Solr's default match-all is used.
     */
    public SearchPage search(String q, String categoryIds, Integer start, Integer rows) {
        return run(q, categoryFilter(categoryIds, false), start, rows);
    }

    /**
     * A category listing: the parent-category branch uses
     * {@code parent_categoryid} when {@code parentCategory} is true, otherwise
     * {@code categoryid} — matching {@code RCSearchFacade.findForCategories}.
     */
    public SearchPage findByCategory(String categoryId, boolean parentCategory, Integer start, Integer rows) {
        return run(null, categoryFilter(categoryId, parentCategory), start, rows);
    }

    private String categoryFilter(String categoryIds, boolean parentCategory) {
        if (categoryIds == null || categoryIds.isBlank()) {
            return null;
        }
        String field = parentCategory ? "parent_categoryid" : "categoryid";
        // Accept a comma-separated list; anything else is rejected upstream by the
        // controller, so this only ever emits digits and commas (no Solr injection).
        return field + ":" + categoryIds.replaceAll("\\s+", "");
    }

    private SearchPage run(String q, String filter, Integer start, Integer rows) {
        int offset = (start == null || start < 0) ? 0 : start;
        int limit = (rows == null || rows <= 0) ? properties.getRows()
                : Math.min(rows, properties.getMaxRows());
        try {
            JsonNode root = query(q, filter, offset, limit);
            return map(root, offset, limit);
        } catch (RestClientException ex) {
            log.warn("Solr query failed ({} {}): {}", offset, limit, ex.getMessage());
            if (properties.isFailOpen()) {
                return new SearchPage(List.of(), 0, offset, limit, false, false);
            }
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                    "Search is temporarily unavailable");
        }
    }

    private JsonNode query(String q, String filter, int offset, int limit) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(properties.getEndpoint())
                .queryParam("wt", "json")
                .queryParam("fl", FIELDS)
                .queryParam("rows", limit)
                .queryParam("start", offset);
        if (q != null && !q.isBlank()) {
            builder.queryParam("q", q);
        }
        if (filter != null) {
            builder.queryParam("fq", filter);
        }
        URI uri = builder.build().encode().toUri();
        return restClient.get().uri(uri).retrieve().body(JsonNode.class);
    }

    private SearchPage map(JsonNode root, int offset, int limit) {
        if (root == null) {
            return new SearchPage(List.of(), 0, offset, limit, false, false);
        }
        JsonNode response = root.path("response");
        long numFound = response.path("numFound").asLong(0L);
        int start = response.path("start").asInt(offset);
        List<SearchResultDto> items = new ArrayList<>();
        for (JsonNode doc : response.path("docs")) {
            items.add(toDto(doc));
        }
        boolean hasNext = (long) start + items.size() < numFound;
        return new SearchPage(items, numFound, start, limit, hasNext, true);
    }

    private SearchResultDto toDto(JsonNode doc) {
        return new SearchResultDto(
                text(doc, "id"),
                text(doc, "title"),
                text(doc, "description"),
                text(doc, "content"),
                text(doc, "url"),
                number(doc, "categoryid"),
                text(doc, "category"),
                number(doc, "parent_categoryid"),
                text(doc, "thumbnail"),
                text(doc, "image"),
                text(doc, "lastModified"),
                text(doc, "start_date"),
                text(doc, "end_date"),
                text(doc, "site"));
    }

    private static String text(JsonNode doc, String field) {
        JsonNode value = doc.path(field);
        return value.isMissingNode() || value.isNull() ? null : value.asText();
    }

    private static Integer number(JsonNode doc, String field) {
        JsonNode value = doc.path(field);
        return value.isNumber() ? value.asInt() : null;
    }
}
