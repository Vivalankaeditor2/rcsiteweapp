package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.dto.FeedItemDto;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

// Unit test of the RSS 2.0 / Atom parser. Real documents are parsed, so the
// DOM walk, the local-name matching and the date normalisation are what is
// tested - not a mock.
class FeedParserTest {

    private final FeedParser parser = new FeedParser();

    private static final String RSS = """
            <?xml version="1.0" encoding="UTF-8"?>
            <rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">
              <channel>
                <title>Source</title>
                <item>
                  <title>Coffee &amp; tea prices rise</title>
                  <link>https://source.example/a1</link>
                  <guid isPermaLink="false">source-1</guid>
                  <pubDate>Fri, 05 Nov 2021 08:24:47 +0530</pubDate>
                  <description>Short summary.</description>
                  <content:encoded><![CDATA[<p>Full <b>body</b></p>]]></content:encoded>
                </item>
                <item>
                  <title>No guid but a link</title>
                  <link>https://source.example/a2</link>
                  <description>Second.</description>
                </item>
                <item>
                  <title>No identity at all</title>
                  <description>Dropped: cannot be de-duplicated.</description>
                </item>
              </channel>
            </rss>
            """;

    // Atom items carry the namespace prefix in the source; the parser matches on
    // the local name, so the feed parses even though the prefix is arbitrary.
    private static final String ATOM = """
            <?xml version="1.0" encoding="utf-8"?>
            <feed xmlns="http://www.w3.org/2005/Atom">
              <title>Atom source</title>
              <entry>
                <title>Atom one</title>
                <id>tag:source.example,2021:1</id>
                <link rel="edit" href="https://source.example/edit/1"/>
                <link rel="alternate" href="https://source.example/1"/>
                <published>2021-11-05T08:24:47Z</published>
                <updated>2021-11-06T09:00:00Z</updated>
                <summary>Atom summary</summary>
                <content type="html">&lt;p&gt;Atom body&lt;/p&gt;</content>
              </entry>
            </feed>
            """;

    @Test
    void parses_rss_items_and_skips_identityless_ones() {
        List<FeedItemDto> items = parser.parse(RSS);

        // The third <item> has no guid and no link, so it is dropped.
        assertThat(items).hasSize(2);
        FeedItemDto first = items.get(0);
        assertThat(first.guid()).isEqualTo("source-1");
        assertThat(first.title()).isEqualTo("Coffee & tea prices rise");
        assertThat(first.link()).isEqualTo("https://source.example/a1");
        assertThat(first.description()).isEqualTo("Short summary.");
        // content:encoded wins for the details column.
        assertThat(first.details()).isEqualTo("<p>Full <b>body</b></p>");
        assertThat(first.published()).isEqualTo(LocalDateTime.of(2021, 11, 5, 2, 54, 47));
    }

    @Test
    void falls_back_to_link_when_guid_is_absent() {
        List<FeedItemDto> items = parser.parse(RSS);
        assertThat(items.get(1).guid()).isEqualTo("https://source.example/a2");
    }

    @Test
    void parses_atom_entries_and_prefers_the_alternate_link() {
        List<FeedItemDto> items = parser.parse(ATOM);

        assertThat(items).hasSize(1);
        FeedItemDto entry = items.get(0);
        assertThat(entry.guid()).isEqualTo("tag:source.example,2021:1");
        assertThat(entry.link()).isEqualTo("https://source.example/1");
        assertThat(entry.description()).isEqualTo("Atom summary");
        assertThat(entry.details()).isEqualTo("<p>Atom body</p>");
        assertThat(entry.published()).isEqualTo(LocalDateTime.of(2021, 11, 5, 8, 24, 47));
        assertThat(entry.updated()).isEqualTo(LocalDateTime.of(2021, 11, 6, 9, 0, 0));
    }

    @Test
    void parses_the_date_shapes_seen_in_the_wild() {
        assertThat(parser.parseDate("2021-11-05T08:24:47Z")).isEqualTo(LocalDateTime.of(2021, 11, 5, 8, 24, 47));
        assertThat(parser.parseDate("2021-11-05T08:24:47+05:30")).isEqualTo(LocalDateTime.of(2021, 11, 5, 2, 54, 47));
        assertThat(parser.parseDate("2021-11-05")).isEqualTo(LocalDateTime.of(2021, 11, 5, 0, 0, 0));
        assertThat(parser.parseDate("Fri, 05 Nov 2021 08:24:47 GMT")).isEqualTo(LocalDateTime.of(2021, 11, 5, 8, 24, 47));
        assertThat(parser.parseDate("not a date")).isNull();
        assertThat(parser.parseDate("")).isNull();
        assertThat(parser.parseDate(null)).isNull();
    }

    @Test
    void returns_empty_for_blank_or_unparseable_input() {
        assertThat(parser.parse(null)).isEmpty();
        assertThat(parser.parse("   ")).isEmpty();
        assertThat(parser.parse("<rss><channel><item>")).isEmpty();
    }

    @Test
    void does_not_expand_external_entities() {
        // A classic XXE attempt. External entities are disabled, so the system
        // file must not be read into the document - parse either fails (empty)
        // or yields no file content, never the secret.
        String xxe = """
                <?xml version="1.0"?>
                <!DOCTYPE rss [ <!ENTITY xxe SYSTEM "file:///etc/hostname"> ]>
                <rss version="2.0"><channel>
                  <item><guid>g1</guid><title>&xxe;</title></item>
                </channel></rss>
                """;
        List<FeedItemDto> items = parser.parse(xxe);

        assertThat(items).allSatisfy(item -> assertThat(String.valueOf(item.title())).doesNotContain("root:"));
    }
}
