package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.FeedProperties;
import com.rev_creations.rcsite.dto.ArticleDto;
import com.rev_creations.rcsite.util.ArticleUrls;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

/**
 * Renders the RSS 2.0 feed - the {@code FeedGenerator}/{@code GenerateRSS} port.
 * The legacy servlet produced this on demand with a default category of 7 and 10
 * items; those defaults are preserved (see {@code FeedProperties}). Only
 * published articles are listed (same rule as the sitemap, D-020), so the feed
 * never advertises a URL that 404s.
 */
@Service
public class FeedRssService {

    /** RFC 822, the shape RSS 2.0 expects for {@code pubDate}. */
    private static final DateTimeFormatter RFC_822 =
            DateTimeFormatter.ofPattern("EEE, dd MMM yyyy HH:mm:ss Z", Locale.ENGLISH);

    private final ArticleService articleService;

    private final FeedProperties properties;

    public FeedRssService(ArticleService articleService, FeedProperties properties) {
        this.articleService = articleService;
        this.properties = properties;
    }

    @Transactional(readOnly = true)
    public String render(Integer categoryId, int items) {
        int limit = items <= 0 ? properties.getRssItems() : items;
        // The legacy servlet defaulted to category 7; a null request keeps it.
        Integer category = categoryId != null ? categoryId : properties.getRssCategoryId();
        String base = properties.getRssBaseUrl();
        List<ArticleDto> articles = articleService.listPublished(category, 0, limit).items();
        StringBuilder xml = new StringBuilder(512);
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        xml.append("<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n")
                .append("  <channel>\n")
                .append("    <title>").append(escape(properties.getRssTitle())).append("</title>\n")
                .append("    <link>").append(escape(base)).append("</link>\n")
                .append("    <description>").append(escape(properties.getRssDescription())).append("</description>\n")
                .append("    <copyright>").append(escape(properties.getRssCopyright())).append("</copyright>\n")
                .append("    <atom:link href=\"").append(escape(base)).append("/rss\" rel=\"self\" type=\"application/rss+xml\"/>\n");
        for (ArticleDto article : articles) {
            xml.append(renderItem(article, base));
        }
        return xml.append("  </channel>\n</rss>\n").toString();
    }

    private String renderItem(ArticleDto article, String base) {
        String link = ArticleUrls.canonical(base, article.articleId(), article.dcode(), article.alias());
        StringBuilder item = new StringBuilder(256);
        item.append("    <item>\n")
                .append("      <title>").append(escape(article.title())).append("</title>\n")
                .append("      <link>").append(escape(link)).append("</link>\n")
                .append("      <guid isPermaLink=\"false\">").append(escape(link)).append("</guid>\n");
        LocalDateTime date = article.published() != null ? article.published() : article.entryDate();
        if (date != null) {
            item.append("      <pubDate>")
                    .append(date.atOffset(ZoneOffset.UTC).format(RFC_822))
                    .append("</pubDate>\n");
        }
        if (article.authorName() != null && !article.authorName().isBlank()) {
            item.append("      <author>").append(escape(article.authorName())).append("</author>\n");
        }
        if (article.categoryId() != null) {
            item.append("      <category>").append(article.categoryId()).append("</category>\n");
        }
        item.append("      <description>").append(cdata(article.description())).append("</description>\n")
                .append("    </item>\n");
        return item.toString();
    }

    /** XML text escaping for the five predefined entities. */
    private static String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }

    /**
     * The description may be HTML (the legacy feed set it as {@code text/html}),
     * so it goes in CDATA. A literal {@code ]]>} is split across two CDATA
     * sections, which is the standard way to carry it safely.
     */
    private static String cdata(String value) {
        if (value == null) {
            return "";
        }
        return "<![CDATA[" + value.replace("]]>", "]]]]><![CDATA[>") + "]]>";
    }
}
