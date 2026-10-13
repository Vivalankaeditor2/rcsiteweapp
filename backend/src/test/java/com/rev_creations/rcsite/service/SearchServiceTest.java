package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.SolrProperties;
import com.rev_creations.rcsite.dto.SearchResultDto.SearchPage;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicReference;

import static org.assertj.core.api.Assertions.assertThat;

// Exercises the real HTTP path with an in-process Solr stand-in rather than a
// mocked client, so the query construction and JSON mapping are what is tested.
class SearchServiceTest {

    private HttpServer server;

    private final AtomicReference<String> lastQuery = new AtomicReference<>();

    private SearchService serviceFor(int status, String body) throws Exception {
        server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        server.createContext("/rcsearch/news", exchange -> {
            lastQuery.set(URLDecoder.decode(exchange.getRequestURI().getRawQuery(), StandardCharsets.UTF_8));
            byte[] out = body.getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/json;charset=UTF-8");
            exchange.sendResponseHeaders(status, out.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(out);
            }
        });
        server.start();
        SolrProperties props = new SolrProperties();
        props.setBaseUrl("http://127.0.0.1:" + server.getAddress().getPort() + "/rcsearch");
        props.setRequestHandler("/news");
        props.setConnectTimeoutMs(500);
        props.setReadTimeoutMs(2000);
        return new SearchService(props);
    }

    @AfterEach
    void tearDown() {
        if (server != null) {
            server.stop(0);
        }
    }

    @Test
    void should_map_docs_and_send_the_legacy_fl_and_filter() throws Exception {
        String body = "{\"response\":{\"numFound\":2,\"start\":0,\"docs\":["
                + "{\"id\":\"12272011\",\"title\":\"Court rejects bail\",\"description\":\"d\","
                + "\"url\":\"/newspage/12272011ai-court\",\"categoryid\":90,\"category\":\"Local\","
                + "\"thumbnail\":\"t.jpg\",\"lastModified\":\"2021-11-05T08:24:47Z\",\"image\":\"i.jpg\","
                + "\"parent_categoryid\":7},"
                + "{\"id\":\"12247832\",\"title\":\"Second\",\"url\":\"/newspage/12247832ai-\"}]}}";
        SearchPage page = serviceFor(200, body).search("bail", "2,3,5,6", 0, 10);

        assertThat(page.available()).isTrue();
        assertThat(page.totalItems()).isEqualTo(2);
        assertThat(page.items()).hasSize(2);
        assertThat(page.items().get(0).id()).isEqualTo("12272011");
        assertThat(page.items().get(0).categoryId()).isEqualTo(90);
        assertThat(page.items().get(0).parentCategoryId()).isEqualTo(7);
        assertThat(page.items().get(0).lastModified()).isEqualTo("2021-11-05T08:24:47Z");
        assertThat(page.items().get(1).description()).isNull();
        assertThat(page.hasNext()).isFalse();

        assertThat(lastQuery.get())
                .contains("wt=json")
                .contains("q=bail")
                .contains("start=0")
                .contains("rows=10")
                .contains("fq=categoryid:2,3,5,6")
                .contains("fl=id,title,description,url,categoryid,category,thumbnail,"
                        + "lastModified,content,parent_categoryid,start_date,end_date,site,image");
    }

    @Test
    void should_filter_on_parent_categoryid_for_a_parent_category_listing() throws Exception {
        serviceFor(200, "{\"response\":{\"numFound\":0,\"docs\":[]}}")
                .findByCategory("7", true, 0, 5);
        assertThat(lastQuery.get()).contains("fq=parent_categoryid:7");
    }

    @Test
    void should_cap_rows_at_the_configured_maximum() throws Exception {
        SearchPage page = serviceFor(200, "{\"response\":{\"numFound\":0,\"docs\":[]}}")
                .search(null, null, 0, 5000);
        assertThat(lastQuery.get()).contains("rows=100");
        assertThat(page.rows()).isEqualTo(100);
    }

    @Test
    void should_compute_has_next_from_offset_and_num_found() throws Exception {
        SearchPage page = serviceFor(200,
                "{\"response\":{\"numFound\":100,\"start\":20,\"docs\":[{\"id\":\"1\"}]}}")
                .search(null, null, 20, 20);
        assertThat(page.hasNext()).isTrue();
        assertThat(page.start()).isEqualTo(20);
    }

    @Test
    void should_fail_open_when_solr_is_unreachable() {
        SolrProperties props = new SolrProperties();
        props.setBaseUrl("http://127.0.0.1:1/rcsearch");
        props.setConnectTimeoutMs(300);
        props.setFailOpen(true);

        SearchPage page = new SearchService(props).search("x", null, 0, 5);

        assertThat(page.available()).isFalse();
        assertThat(page.items()).isEmpty();
    }
}
