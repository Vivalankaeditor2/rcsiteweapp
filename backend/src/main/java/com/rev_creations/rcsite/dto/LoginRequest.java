package com.rev_creations.rcsite.dto;

import jakarta.validation.constraints.NotBlank;

/** Login request body. */
public record LoginRequest(
        @NotBlank String username,
        @NotBlank String password) {
}
