package com.rev_creations.rcsite.dto;
public record RcSiteConfigDto(
        String configKey,
        String value,
        String description,
        String siteArea,
        Integer active) {
}
