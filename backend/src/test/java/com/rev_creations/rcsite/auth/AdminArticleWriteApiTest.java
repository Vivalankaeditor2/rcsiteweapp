package com.rev_creations.rcsite.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.rev_creations.rcsite.entity.Article;
import com.rev_creations.rcsite.entity.RcCustomer;
import com.rev_creations.rcsite.entity.UserType;
import com.rev_creations.rcsite.repository.ArticleRepository;
import com.rev_creations.rcsite.repository.RcCustomerRepository;
import com.rev_creations.rcsite.repository.UserTypeRepository;
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
import java.util.concurrent.atomic.AtomicInteger;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * The Phase 7 admin write smoke test over the real security chain: log in,
 * then create -> edit -> publish an article with the bearer token. Only the
 * repositories (the DB boundary) are stubbed.
 */
@SpringBootTest
@AutoConfigureMockMvc
class AdminArticleWriteApiTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private RcCustomerRepository customerRepository;

    @MockBean
    private UserTypeRepository userTypeRepository;

    @MockBean
    private ArticleRepository articleRepository;

    private final AtomicInteger idSequence = new AtomicInteger(5000);

    @BeforeEach
    void seed() {
        RcCustomer admin = new RcCustomer();
        admin.setUsername("editor");
        admin.setPword("secret");
        admin.setType("1");
        when(customerRepository.findById("editor")).thenReturn(Optional.of(admin));

        RcCustomer plainUser = new RcCustomer();
        plainUser.setUsername("writer");
        plainUser.setPword("secret");
        plainUser.setType("2");
        when(customerRepository.findById("writer")).thenReturn(Optional.of(plainUser));

        UserType adminType = new UserType();
        adminType.setUserTypeId(1L);
        adminType.setUserTypeName("ADMIN");
        UserType userType = new UserType();
        userType.setUserTypeId(2L);
        userType.setUserTypeName("USER");
        when(userTypeRepository.findAll()).thenReturn(List.of(adminType, userType));

        // Persist path: assign an id so the response is a real "saved" article.
        when(articleRepository.save(any(Article.class))).thenAnswer(call -> {
            Article a = call.getArgument(0);
            if (a.getArticleId() == null) {
                a.setArticleId(idSequence.incrementAndGet());
            }
            return a;
        });
        when(articleRepository.findByAliasOrderByArticleIdDesc(any())).thenReturn(List.of());
    }

    private String token(String username) throws Exception {
        String json = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                java.util.Map.of("username", username, "password", "secret"))))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(json).get("token").asText();
    }

    private String body(String title, boolean publish) throws Exception {
        return objectMapper.writeValueAsString(java.util.Map.of(
                "title", title, "description", "d", "details", "b",
                "categoryId", 3, "authorName", "A", "publish", publish));
    }

    @Test
    void create_edit_publish_round_trips_with_a_bearer_token() throws Exception {
        String token = token("editor");

        String created = mockMvc.perform(post("/api/admin/articles")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body("A Fresh Headline", true)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.alias").value("a-fresh-headline"))
                .andExpect(jsonPath("$.aprovalStatus").value("1"))
                .andReturn().getResponse().getContentAsString();
        int id = objectMapper.readTree(created).get("articleId").asInt();

        // The row now exists: every later read of it finds the saved article.
        when(articleRepository.findById(id)).thenAnswer(i -> {
            Article a = new Article();
            a.setArticleId(id);
            a.setTitle("A Fresh Headline Edited");
            return Optional.of(a);
        });

        mockMvc.perform(put("/api/admin/articles/" + id)
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body("A Fresh Headline Edited", true)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("A Fresh Headline Edited"));

        // Hide, then publish again - the frozen "not published" status is "4".
        mockMvc.perform(put("/api/admin/articles/" + id + "/publish?published=false")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.aprovalStatus").value("4"));
        mockMvc.perform(put("/api/admin/articles/" + id + "/publish?published=true")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.aprovalStatus").value("1"));
    }

    @Test
    void the_write_surface_should_answer_401_without_a_token() throws Exception {
        mockMvc.perform(post("/api/admin/articles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body("Nope", true)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void a_non_admin_token_should_answer_403() throws Exception {
        mockMvc.perform(post("/api/admin/articles")
                        .header("Authorization", "Bearer " + token("writer"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body("Not allowed", true)))
                .andExpect(status().isForbidden());
    }

    @Test
    void an_invalid_body_should_answer_400() throws Exception {
        mockMvc.perform(post("/api/admin/articles")
                        .header("Authorization", "Bearer " + token("editor"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"details\":\"no title\"}"))
                .andExpect(status().isBadRequest());
    }
}
