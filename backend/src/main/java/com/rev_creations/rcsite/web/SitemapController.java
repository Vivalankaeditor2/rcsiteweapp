package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.service.SitemapService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

/**
 * Serves the sitemaps at their frozen legacy paths (D-020, D-025): the index
 * files {@code /sitemapindex.xml} and {@code /sitemapindex04302022.xml}, and the
 * shards {@code /sitemap_{n}.xml}. Generation is read-only and parameterised.
 */
@RestController
@Tag(name = "Sitemaps", description = "Sitemap index and shards generated from articles")
public class SitemapController {

    private static final String XML = MediaType.APPLICATION_XML_VALUE;

    private final SitemapService sitemapService;

    public SitemapController(SitemapService sitemapService) {
        this.sitemapService = sitemapService;
    }

    @GetMapping(value = {"/sitemapindex.xml", "/sitemapindex04302022.xml"}, produces = XML)
    @Operation(summary = "Sitemap index listing the shard URLs")
    public String index() {
        return sitemapService.renderIndex();
    }

    @GetMapping(value = "/sitemap_{n}.xml", produces = XML)
    @Operation(summary = "One sitemap shard (stable, id-ordered page of articles)")
    public String shard(@PathVariable int n) {
        if (n < 1 || n > sitemapService.getShardCount()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No sitemap shard " + n);
        }
        return sitemapService.renderShard(n);
    }
}
