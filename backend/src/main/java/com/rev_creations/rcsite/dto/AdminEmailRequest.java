package com.rev_creations.rcsite.dto;

/** Enqueue an outbound email ({@code email}) - the admin compose action. */
public record AdminEmailRequest(
        String toName,
        String toEmail,
        String subject,
        String message,
        String fromName,
        String fromEmail,
        String type) {
}
