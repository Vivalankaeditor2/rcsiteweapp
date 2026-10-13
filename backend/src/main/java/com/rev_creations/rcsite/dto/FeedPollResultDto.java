package com.rev_creations.rcsite.dto;

/** The outcome of one manual feed poll (used by the admin trigger). */
public record FeedPollResultDto(
        boolean ok,
        int fetched,
        int stored,
        String message) {
}
