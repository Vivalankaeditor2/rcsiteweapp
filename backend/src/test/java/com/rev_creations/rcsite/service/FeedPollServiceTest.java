package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.FeedProperties;
import com.rev_creations.rcsite.entity.FeedArticle;
import com.rev_creations.rcsite.entity.FeedChannel;
import com.rev_creations.rcsite.entity.FeedChannelLog;
import com.rev_creations.rcsite.repository.FeedArticleRepository;
import com.rev_creations.rcsite.repository.FeedChannelLogRepository;
import com.rev_creations.rcsite.repository.FeedChannelRepository;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

// Exercises the real fetch (in-process HTTP server) and the real parser; only
// the repository boundary is mocked, which is the DB edge. So the poll loop,
// the de-duplication decision and the log/reschedule writes are what is tested.
class FeedPollServiceTest {

    private final FeedChannelRepository channelRepository = mock(FeedChannelRepository.class);

    private final FeedArticleRepository articleRepository = mock(FeedArticleRepository.class);

    private final FeedChannelLogRepository logRepository = mock(FeedChannelLogRepository.class);

    private HttpServer server;

    private FeedPollService service() {
        FeedProperties properties = new FeedProperties();
        properties.setConnectTimeoutMs(1000);
        properties.setReadTimeoutMs(2000);
        properties.setDefaultPollIntervalMinutes(60);
        return new FeedPollService(channelRepository, articleRepository, logRepository,
                new FeedParser(), new FeedFetchService(properties), properties);
    }

    private String serve(int status, String body) throws Exception {
        server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        server.createContext("/feed", exchange -> {
            byte[] out = body.getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/rss+xml;charset=UTF-8");
            exchange.sendResponseHeaders(status, out.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(out);
            }
        });
        server.start();
        return "http://127.0.0.1:" + server.getAddress().getPort() + "/feed";
    }

    @AfterEach
    void tearDown() {
        if (server != null) {
            server.stop(0);
        }
    }

    private FeedChannel channel(String link) {
        FeedChannel channel = new FeedChannel();
        channel.setId(5L);
        channel.setName("src");
        channel.setLink(link);
        channel.setFeedActive(true);
        return channel;
    }

    private static String rss(int items) {
        StringBuilder xml = new StringBuilder("<rss version=\"2.0\"><channel><title>s</title>");
        for (int i = 1; i <= items; i++) {
            xml.append("<item><guid>g").append(i).append("</guid><title>t").append(i)
                    .append("</title><link>https://s.example/").append(i)
                    .append("</link><description>d</description></item>");
        }
        return xml.append("</channel></rss>").toString();
    }

    @Test
    void stages_new_items_and_logs_a_success() throws Exception {
        String url = serve(200, rss(3));
        when(channelRepository.findById(5L)).thenReturn(Optional.of(channel(url)));
        when(articleRepository.findByGuid(any())).thenReturn(Optional.empty());

        FeedPollService.PollResult result = service().pollChannel(5L);

        assertThat(result.ok()).isTrue();
        assertThat(result.fetched()).isEqualTo(3);
        assertThat(result.stored()).isEqualTo(3);
        verify(articleRepository, times(3)).save(any(FeedArticle.class));
        // The channel is rescheduled and the attempt is logged once.
        verify(channelRepository).save(any(FeedChannel.class));
        ArgumentCaptor<FeedChannelLog> log = ArgumentCaptor.forClass(FeedChannelLog.class);
        verify(logRepository).save(log.capture());
        assertThat(log.getValue().getSeverity()).isEqualTo("INFO");
    }

    @Test
    void deduplicates_on_guid() throws Exception {
        String url = serve(200, rss(2));
        when(channelRepository.findById(5L)).thenReturn(Optional.of(channel(url)));
        FeedArticle existing = new FeedArticle();
        existing.setGuid("g1");
        when(articleRepository.findByGuid("g1")).thenReturn(Optional.of(existing));
        when(articleRepository.findByGuid("g2")).thenReturn(Optional.empty());

        FeedPollService.PollResult result = service().pollChannel(5L);

        assertThat(result.fetched()).isEqualTo(2);
        // One already staged (updated in place) and one new.
        assertThat(result.stored()).isEqualTo(1);
        verify(articleRepository, times(2)).save(any(FeedArticle.class));
    }

    @Test
    void caps_items_so_a_huge_feed_cannot_flood_the_table() throws Exception {
        String url = serve(200, rss(10));
        when(channelRepository.findById(5L)).thenReturn(Optional.of(channel(url)));
        when(articleRepository.findByGuid(any())).thenReturn(Optional.empty());

        FeedProperties properties = new FeedProperties();
        properties.setMaxItemsPerPoll(4);
        properties.setDefaultPollIntervalMinutes(60);
        FeedPollService capped = new FeedPollService(channelRepository, articleRepository,
                logRepository, new FeedParser(), new FeedFetchService(properties), properties);

        FeedPollService.PollResult result = capped.pollChannel(5L);

        assertThat(result.fetched()).isEqualTo(10);
        assertThat(result.stored()).isEqualTo(4);
        verify(articleRepository, times(4)).save(any(FeedArticle.class));
    }

    @Test
    void records_an_error_when_the_fetch_fails() throws Exception {
        String url = serve(500, "boom");
        when(channelRepository.findById(5L)).thenReturn(Optional.of(channel(url)));

        FeedPollService.PollResult result = service().pollChannel(5L);

        assertThat(result.ok()).isFalse();
        assertThat(result.stored()).isZero();
        // The failed attempt is logged as ERROR and the channel is still rescheduled.
        ArgumentCaptor<FeedChannelLog> log = ArgumentCaptor.forClass(FeedChannelLog.class);
        verify(logRepository).save(log.capture());
        assertThat(log.getValue().getSeverity()).isEqualTo("ERROR");
        verify(channelRepository).save(any(FeedChannel.class));
    }

    @Test
    void reports_a_missing_channel_without_touching_the_feed() {
        when(channelRepository.findById(99L)).thenReturn(Optional.empty());

        FeedPollService.PollResult result = service().pollChannel(99L);

        assertThat(result.ok()).isFalse();
        assertThat(result.message()).contains("not found");
        verify(articleRepository, times(0)).save(any(FeedArticle.class));
    }

    @Test
    void next_poll_is_moved_into_the_future_using_the_channel_interval() throws Exception {
        String url = serve(200, rss(1));
        FeedChannel channel = channel(url);
        channel.setPollInterval(30L);
        when(channelRepository.findById(5L)).thenReturn(Optional.of(channel));
        when(articleRepository.findByGuid(any())).thenReturn(Optional.empty());

        service().pollChannel(5L);

        ArgumentCaptor<FeedChannel> saved = ArgumentCaptor.forClass(FeedChannel.class);
        verify(channelRepository).save(saved.capture());
        assertThat(saved.getValue().getLastPoll()).isNotNull();
        assertThat(saved.getValue().getNextPoll())
                .isEqualTo(saved.getValue().getLastPoll().plusMinutes(30));
    }
}
