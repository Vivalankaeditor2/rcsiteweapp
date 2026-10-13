package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.dto.SearchResultDto.SearchPage;
import com.rev_creations.rcsite.service.RcSiteConfigService;
import com.rev_creations.rcsite.service.SearchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Search read API backed by the legacy Solr {@code /news} handler (D-011).
 *
 * <p>{@code categoryId} accepts the legacy shapes: a single id, a comma-separated
 * id list (as the old {@code (2,3,5,6)} filter), or the literal {@code local}.
 * Only digits, commas and {@code local} are allowed, so a value can never be
 * smuggled into the Solr filter (NC-005).
 */
@RestController
@RequestMapping("/api/search")
@Validated
@Tag(name = "Search", description = "Search proxied to Apache Solr (D-011)")
public class SearchController {

    /** Digits, comma-separated digits, or the legacy literal {@code local}. */
    private static final String CATEGORY_PATTERN = "(\\d{1,7})(,\\d{1,7})*|local";

    private final SearchService searchService;

    private final RcSiteConfigService configService;

    public SearchController(SearchService searchService, RcSiteConfigService configService) {
        this.searchService = searchService;
        this.configService = configService;
    }

    @GetMapping
    @Operation(summary = "Search articles, optionally filtered to one or more categories")
    public SearchPage search(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) @Pattern(regexp = CATEGORY_PATTERN) String categoryId,
            @RequestParam(defaultValue = "0") @Min(0) int start,
            @RequestParam(required = false) @Min(1) @Max(200) Integer rows) {
        return searchService.search(q, categoryId, start, resolveRows(categoryId, rows));
    }

    @GetMapping("/category/{categoryId}")
    @Operation(summary = "List articles for a category (parent-category filter by default)")
    public SearchPage byCategory(
            @PathVariable @Pattern(regexp = CATEGORY_PATTERN) String categoryId,
            @RequestParam(defaultValue = "true") boolean parentCategory,
            @RequestParam(defaultValue = "0") @Min(0) int start,
            @RequestParam(required = false) @Min(1) @Max(200) Integer rows) {
        return searchService.findByCategory(categoryId, parentCategory, start,
                resolveRows(categoryId, rows));
    }

    /**
     * The legacy page size came from the {@code categorylimit.search.*} settings
     * (per category, per site area). An explicit {@code rows} request wins;
     * otherwise the configured key is used, falling back to the service default
     * when neither the request nor the config supplies a value.
     */
    private Integer resolveRows(String categoryId, Integer rows) {
        if (rows != null || categoryId == null) {
            return rows;
        }
        for (String key : new String[] {"categorylimit.search." + categoryId,
                "categorylimit." + categoryId}) {
            String value = configService.getValue(key).orElse(null);
            if (value != null && value.matches("\\d{1,4}")) {
                return Integer.parseInt(value);
            }
        }
        return null;
    }
}
