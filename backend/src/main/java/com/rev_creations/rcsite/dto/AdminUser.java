package com.rev_creations.rcsite.dto;

import java.util.List;

/** Public-safe view of the authenticated user. Never carries the password. */
public record AdminUser(
        String username,
        String displayName,
        String email,
        List<String> roles) {
}
