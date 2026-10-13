package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.config.AuthProperties;
import com.rev_creations.rcsite.dto.AdminUser;
import com.rev_creations.rcsite.dto.LoginRequest;
import com.rev_creations.rcsite.dto.LoginResponse;
import com.rev_creations.rcsite.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** Phase 7 authentication endpoints (D-022). */
@RestController
@RequestMapping("/api/auth")
@Tag(name = "Auth", description = "Login and identity for the admin surface")
public class AuthController {

    private final AuthService authService;
    private final AuthProperties authProperties;

    public AuthController(AuthService authService, AuthProperties authProperties) {
        this.authService = authService;
        this.authProperties = authProperties;
    }

    @PostMapping("/login")
    @Operation(summary = "Exchange credentials for a bearer token")
    public LoginResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request.username(), request.password());
    }

    @GetMapping("/me")
    @Operation(summary = "The identity behind the presented bearer token")
    public AdminUser me(@AuthenticationPrincipal Jwt jwt) {
        return new AdminUser(
                jwt.getSubject(),
                jwt.getClaimAsString("name"),
                jwt.getClaimAsString("email"),
                bareRoleNames(jwt.getClaimAsStringList("roles")));
    }

    private List<String> bareRoleNames(List<String> authorities) {
        if (authorities == null) {
            return List.of();
        }
        String prefix = authProperties.getRolePrefix();
        return authorities.stream()
                .map(a -> a.startsWith(prefix) ? a.substring(prefix.length()) : a)
                .toList();
    }
}
