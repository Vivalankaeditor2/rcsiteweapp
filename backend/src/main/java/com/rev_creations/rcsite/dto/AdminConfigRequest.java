package com.rev_creations.rcsite.dto;

import jakarta.validation.constraints.Size;

/** Update payload for a site setting ({@code rcsite_config}). */
public record AdminConfigRequest(
        String value,
        @Size(max = 255) String description,
        @Size(max = 50) String siteArea,
        Integer active) {
}
