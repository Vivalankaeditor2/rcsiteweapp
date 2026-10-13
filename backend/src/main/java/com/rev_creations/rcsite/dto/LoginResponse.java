package com.rev_creations.rcsite.dto;

/** Login response: the bearer token plus its expiry and the caller's identity. */
public record LoginResponse(
        String token,
        String tokenType,
        long expiresInSeconds,
        AdminUser user) {
}
