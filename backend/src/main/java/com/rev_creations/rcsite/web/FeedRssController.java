package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.service.FeedRssService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * The public RSS 2.0 feed - the {@code FeedGenerator}/{@code GenerateRSS} port.
 *
 * <p>Defaults match the legacy servlet (category 7, 10 items) and the URL shape
 * it emitted ({@code news/page.jsp?articleid=}). The edge exposes it at the
 * stable public path {@code /rss} (IIS {@code web.config}, D-030); the backend
 * route lives under {@code /api} so it can be proxied like every other API.
 */
@RestController
@RequestMapping("/api")
@Validated
@Tag(name = "Feeds", description = "RSS output and feed ingestion (the feed_* tables)")
public class FeedRssController {

    private final FeedRssService rssService;

    public FeedRssController(FeedRssService rssService) {
        this.rssService = rssService;
    }

    @GetMapping(value = "/rss", produces = "application/rss+xml;charset=UTF-8")
    @Operation(summary = "Render the RSS 2.0 feed (default category 7, 10 items)")
    public String rss(
            @RequestParam(required = false) Integer categoryid,
            @RequestParam(required = false) @Min(1) @Max(100) Integer items) {
        return rssService.render(categoryid, items == null ? 0 : items);
    }
}
