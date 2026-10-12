package com.rev_creations.rcsite.dto;
import java.time.Instant;
import java.util.List;

/** One error body for every failure path (unified error shape). */
public record ApiError(
        Instant timestamp,
        int status,
        String error,
        String message,
        String path,
        List<String> details) {
}
