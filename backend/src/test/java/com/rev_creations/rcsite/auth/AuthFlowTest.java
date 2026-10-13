package com.rev_creations.rcsite.auth;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rev_creations.rcsite.entity.RcCustomer;
import com.rev_creations.rcsite.entity.UserType;
import com.rev_creations.rcsite.repository.RcCustomerRepository;
import com.rev_creations.rcsite.repository.UserTypeRepository;
import com.rev_creations.rcsite.service.ArticleService;
import com.rev_creations.rcsite.service.FeedChannelService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Real security chain end-to-end: the login endpoint mints a token, that token
 * unlocks the admin surface, and the public read endpoints stay anonymous. Only
 * the repository (the DB boundary) is stubbed.
 */
@SpringBootTest
@AutoConfigureMockMvc
class AuthFlowTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private RcCustomerRepository customerRepository;

    @MockBean
    private UserTypeRepository userTypeRepository;

    @MockBean
    private ArticleService articleService;

    @MockBean
    private FeedChannelService feedChannelService;

    @MockBean
    private com.rev_creations.rcsite.service.FeedRssService feedRssService;

    @MockBean
    private com.rev_creations.rcsite.service.SitemapService sitemapService;

    @BeforeEach
    void seed() {
        RcCustomer admin = new RcCustomer();
        admin.setUsername("editor");
        admin.setPword("secret");           // plaintext, as the frozen schema stores it (NC-006)
        admin.setCustomer("Editor Person");
        admin.setEmail("editor@vivalanka.com");
        admin.setType("1");
        when(customerRepository.findById("editor")).thenReturn(Optional.of(admin));
        when(customerRepository.findById("ghost")).thenReturn(Optional.empty());

        UserType adminType = new UserType();
        adminType.setUserTypeId(1L);
        adminType.setUserTypeName("ADMIN");
        when(userTypeRepository.findAll()).thenReturn(List.of(adminType));
    }

    private String token() throws Exception {
        String body = objectMapper.writeValueAsString(
                java.util.Map.of("username", "editor", "password", "secret"));
        String json = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(json).get("token").asText();
    }

    @Test
    void login_should_return_a_token_and_the_identity() throws Exception {
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                java.util.Map.of("username", "editor", "password", "secret"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").isNotEmpty())
                .andExpect(jsonPath("$.tokenType").value("Bearer"))
                .andExpect(jsonPath("$.user.username").value("editor"))
                .andExpect(jsonPath("$.user.roles[0]").value("ADMIN"));
    }

    @Test
    void login_should_answer_401_with_the_unified_body_on_a_wrong_password() throws Exception {
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                java.util.Map.of("username", "editor", "password", "nope"))))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.status").value(401))
                .andExpect(jsonPath("$.message").value("Invalid username or password"));
    }

    @Test
    void login_should_answer_401_for_an_unknown_user() throws Exception {
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                java.util.Map.of("username", "ghost", "password", "secret"))))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void me_should_return_the_identity_behind_the_token() throws Exception {
        mockMvc.perform(get("/api/auth/me").header("Authorization", "Bearer " + token()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("editor"))
                .andExpect(jsonPath("$.roles[0]").value("ADMIN"));
    }

    @Test
    void me_should_answer_401_without_a_token() throws Exception {
        mockMvc.perform(get("/api/auth/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void the_admin_surface_should_require_a_token() throws Exception {
        mockMvc.perform(get("/api/feeds"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void the_admin_surface_should_open_with_a_valid_token() throws Exception {
        when(feedChannelService.listAll()).thenReturn(List.of());
        mockMvc.perform(get("/api/feeds").header("Authorization", "Bearer " + token()))
                .andExpect(status().isOk());
    }

    @Test
    void the_public_read_surface_should_stay_anonymous() throws Exception {
        when(articleService.listPublished(null, 0, 20)).thenReturn(null);
        mockMvc.perform(get("/api/articles"))
                .andExpect(status().isOk());
    }

    @Test
    void the_public_rss_paths_should_stay_anonymous() throws Exception {
        when(feedRssService.render(null, 0)).thenReturn("<rss></rss>");
        // The backend serves the feed at /api/rss; the public /rss is a frontend
        // rewrite to this path (D-033), so only /api/rss is asserted here.
        mockMvc.perform(get("/api/rss")).andExpect(status().isOk());
    }

    @Test
    void the_sitemap_paths_should_stay_anonymous() throws Exception {
        when(sitemapService.renderIndex()).thenReturn("<sitemapindex></sitemapindex>");
        mockMvc.perform(get("/sitemapindex.xml")).andExpect(status().isOk());
    }
}
